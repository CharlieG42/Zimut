extends Node
## ProgressionManager.gd — Progression, sauvegardes, XP et inventaire.
##
## - 5 parties (slots) maximum, stockées dans user://saves/
## - Chaque partie : une ÉQUIPE (3 persos + équipement), un INVENTAIRE de loots et un
##   ROSTER : la progression de chacune des 8 classes (niveau, XP, points de
##   caractéristiques investis / à dépenser — voir ClassRules.gd)
## - Chaque victoire rapporte de l'XP (tous les persos, les classes hors équipe en
##   reçoivent une part) et 1-4 loots avec rareté (voir ItemRules.gd)
## - Le niveau des ennemis suit le niveau moyen de l'équipe (plus de mur de difficulté)

signal progression_changed()

const SAVE_DIR := "user://saves"
const MAX_SAVES := 5
const START_LEVEL := 1
const BOSS_EVERY := 4

## Version d'équilibrage des données (classes 1..100, ennemis 1..150, points de sorts).
## Les anciennes sauvegardes (< 15) sont converties au chargement (ensure_roster).
const BALANCE_VERSION := 15

## Combats de la frontière nécessaires par niveau sur l'ANCIENNE échelle 1..50
## (index = ancien niveau). La table actuelle (niveaux 1..100) en est dérivée :
## chaque niveau demande moitié moins de combats mais il y en a deux fois plus.
const OLD_LEVEL_COMBATS: PackedInt32Array = [
	0, 3, 3, 3, 3, 3, 3, 3, 3, 3,
	3, 3, 3, 4, 4, 5, 5, 6, 7, 8,
	9, 10, 12, 14, 16, 18, 21, 24, 27, 31,
	35, 40, 45, 51, 57, 64, 71, 79, 87, 96,
	105, 115, 125, 136, 147, 158, 170, 182, 194, 207,
	200,
]
## Palier XP du roster par niveau (index = niveau) et combats par niveau :
## construits dans _build_level_tables() (≈ 2 400 combats pour passer de 1 à 100).
var LEVEL_XP: PackedInt32Array = PackedInt32Array()
var LEVEL_COMBATS: PackedInt32Array = PackedInt32Array()

## Ancien niveau (1..50) -> niveau actuel (1..100), pour la migration des sauvegardes
## et les niveaux écrits « en dur » (zones d'aventure, villes de conquête).
static func level_from_old(old_level: int) -> int:
	return clampi(roundi(1.0 + float(old_level - 1) * 99.0 / 49.0), 1, ClassRules.MAX_LEVEL)

## Niveau des zones d'aventure/conquête : les anciens niveaux 10..25 deviennent 1..100
## (courbe douce pour garder des débuts faciles : première zone = niveau 1).
static func zone_level(old_level: int) -> int:
	var t: float = clampf(float(old_level - 10) / 15.0, 0.0, 1.3)
	return clampi(roundi(1.0 + 99.0 * pow(t, 1.5)), 1, ClassRules.ENEMY_MAX_LEVEL)

## V19 : montée de niveau trop rapide au début (3 niveaux en 4 combats) : les premiers niveaux
## demandent EARLY_XP_MULT_START fois plus de combats, effet qui s'estompe jusqu'au niveau EARLY_XP_MULT_END.
const EARLY_XP_MULT_START := 2.0
const EARLY_XP_MULT_END := 30

static func _early_xp_mult(lv: int) -> float:
	var t: float = clampf(float(lv - 1) / float(EARLY_XP_MULT_END - 1), 0.0, 1.0)
	return lerpf(EARLY_XP_MULT_START, 1.0, t)

func _build_level_tables() -> void:
	LEVEL_XP = PackedInt32Array()
	LEVEL_COMBATS = PackedInt32Array()
	LEVEL_XP.resize(ClassRules.MAX_LEVEL + 2)
	LEVEL_COMBATS.resize(ClassRules.MAX_LEVEL + 2)
	var acc: float = 0.0
	for lv: int in range(1, ClassRules.MAX_LEVEL + 1):
		var ol: float = 1.0 + float(lv - 1) * 49.0 / 99.0
		var i0: int = clampi(int(floor(ol)), 1, 49)
		var c_old: float = lerpf(float(OLD_LEVEL_COMBATS[i0]), float(OLD_LEVEL_COMBATS[i0 + 1]), ol - float(i0))
		var need: int = maxi(2, roundi(c_old * 0.5 * _early_xp_mult(lv)))
		if lv > 1:
			need = maxi(need, int(LEVEL_COMBATS[lv - 1]))   # jamais moins de combats qu'au niveau précédent
		LEVEL_COMBATS[lv] = need
		LEVEL_XP[lv] = roundi(acc)
		acc += float(need) * float(_combat_xp_raw(lv)) * ClassRules.FIGHT_XP_MULT
	LEVEL_XP[ClassRules.MAX_LEVEL + 1] = roundi(acc)
	LEVEL_COMBATS[ClassRules.MAX_LEVEL + 1] = LEVEL_COMBATS[ClassRules.MAX_LEVEL]

## XP de base d'un combat de niveau `fight_level` (avant FIGHT_XP_MULT et réglage de vitesse).
func _combat_xp_raw(fight_level: int) -> int:
	var lv: int = clampi(fight_level, 1, ClassRules.ENEMY_MAX_LEVEL)
	var gain: float = ClassRules.XP_PER_COMBAT_BASE * pow(ClassRules.XP_PER_COMBAT_GROWTH, float(lv - 1) * 0.5)
	return roundi(clampf(gain, ClassRules.XP_PER_COMBAT_FLOOR, ClassRules.XP_PER_COMBAT_CEIL))

## Biomes : cycle des combats. Chaque biome dure BOSS_EVERY combats, le dernier
## étant le boss du biome. Les types viennent de la colonne « Biome » de ennemis.txt.
const BIOME_ORDER: Array[String] = ["Forêt", "Montagne", "Désert"]

## Donjon : après un cycle complet des 3 biomes (12 combats), l'équipe entre dans
## le donjon — 4 salles thématiques : la salle de chaque biome (au niveau boss),
## puis la salle finale avec le big boss (Roi Squelette). Le cycle recommence
## ensuite en Forêt avec des ennemis plus forts (la difficulté suit l'équipe).
const DONJON_EVERY := 12
const DONJON_ORDER: Array[String] = ["Forêt", "Montagne", "Désert", "Donjon"]
const BIOME_LABEL := {"Forêt": "Forêt de Zimut", "Montagne": "Pics de Zimut", "Désert": "Dunes de Zimut", "Donjon": "Donjon de Zimut"}
## Types d'ennemis par biome (2 par biome, tirés de ennemis.txt).
const BIOME_ENEMIES := {
	"Forêt": ["Gobelin", "Loup"],
	"Montagne": ["Troll", "Squelette"],
	"Désert": ["Squelette", "Dragonnet"],
	"Donjon": ["Squelette", "Dragonnet"],
}
## Boss nommé de chaque biome (lignes « Boss ... » de ennemis.txt).
const BIOME_BOSSES := {
	"Forêt": "Gobelin Roi",
	"Montagne": "Troll Géant",
	"Désert": "Dragon",
	"Donjon": "Squelette Seigneur",
}
## Ressources de craft butinables (clé -> label).
const RESOURCE_LABEL := {"Fer": "Fer", "Bois": "Bois", "Cuir": "Cuir", "Magie": "Magie", "Venin": "Venin"}
## Quantités de ressources lâchées par un combat (par ennemi vaincu).
const RESOURCE_DROPS := {"Fer": 4, "Bois": 3, "Cuir": 3, "Magie": 2, "Venin": 1}

## Conquête : probabilité d'une contre-attaque ennemie après une bataille
## gagnée, et durée du pillage (en batailles) d'une ville ravagée.
## La capitale (id "capitale") ne peut JAMAIS être attaquée.
const CONQUEST_COUNTERATTACK_CHANCE := 0.35
const CONQUEST_RAVAGE_BATTLES := 3

## Siège d’une ville adverse (rouge) : 4 batailles — 3 plateaux de mobs
## de champs puis le plateau du boss. Une ville neutre (grise) se prend
## en une seule bataille de mobs.
const CONQUEST_SIEGE_BATTLES := 4

## ══════════════════════════════════════════════════════════════════════
## MODE AVENTURE — catalogue officiel (même format que la Conquête).
## La carte d’Aventure est LE MÊME MONDE que la carte de Conquête, vu au
## sol : chaque zone est rattachée à un biome et peut « révéler » des
## villes de CONQUEST_CITIES, marquées « discovered » côté Conquête
## (condition pour les attaquer — pont inter-modes).
##
## Zone : id -> { name, biome, size:[w,h], start:[x,y],
##               unlock: id de zone précédente ("" = départ),
##               reveals: [villes CONQUEST_CITIES révélées en l’explorant] }
## POI  : position "x,y" -> { kind, name, level, desc }
##   kind ∈ combat | chest | puzzle | camp (repos) | reveal (belvédère) | exit
## ADVENTURE_FOG_RADIUS : rayon de brouillard de guerre révélé autour du héros.
## ══════════════════════════════════════════════════════════════════════
const ADVENTURE_FOG_RADIUS := 2
## Les combats d'Aventure et de Conquête partagent leurs gains (XP, objets, or,
## ressources) mais n'avancent pas la campagne du mode Tactique. false = ancien comportement.
const CAMPAIGN_FIGHTS_ISOLATED := true
const ADVENTURE_BASE_XP := 60

## Monde d'Aventure façon Dofus Touch : chaque zone est une « carte » posée sur une
## grille du monde (`grid` = [x, y]). Deux cartes voisines (N/E/S/O) sont reliées par
## une porte au milieu du bord de l'île : on change de carte en y marchant.
## La grille suit la géographie de la Conquête : forêts à l'ouest, montagnes au nord,
## désert à l'est, Donjon au sud. `blend` = biome voisin qui déborde sur un côté de la
## carte (lisière). `key_poi` = combat qui ouvre les routes vers les cartes plus
## difficiles (les cartes de niveau égal ou inférieur restent toujours ouvertes).
## `unlock` est conservé pour les anciennes sauvegardes (voyage rapide).
const ADVENTURE_ZONES := {
	"foret_sylve": {
		"name": "Sentiers de la Sylve", "biome": "Forêt", "size": [22, 16], "shape": "ile", "grid": [1, 1],
		"start": [1, 3], "unlock": "", "key_poi": "7,2", "reveals": ["clairiere", "village_brume", "pont_mousse"],
	},
	"foret_ronces": {
		"name": "Ronces de l’Abbaye", "biome": "Forêt", "size": [18, 14], "shape": "ile", "grid": [0, 1],
		"start": [1, 3], "unlock": "foret_sylve", "key_poi": "4,5",
		"reveals": ["abbaye_ronce", "ruines_lierre", "citadelle_ronce", "marais_spectres"],
	},
	"lisiere_col": {
		"name": "Lisière du Col", "biome": "Forêt", "size": [20, 14], "shape": "ile_b", "grid": [2, 1],
		"blend": {"biome": "Montagne", "side": "N"},
		"start": [1, 3], "unlock": "foret_sylve", "key_poi": "6,3",
		"reveals": ["vieille_tour", "fort_racine", "bois_lune", "sanctuaire_mousse"],
	},
	"montagne_pics": {
		"name": "Pics du Givre", "biome": "Montagne", "size": [18, 16], "shape": "ile", "grid": [2, 0],
		"start": [1, 3], "unlock": "foret_sylve", "key_poi": "5,2", "reveals": ["hameau_pin", "col_givre", "garnison"],
	},
	"cretes_givre": {
		"name": "Crêtes du Givre", "biome": "Montagne", "size": [20, 12], "shape": "ile_b", "grid": [3, 0],
		"start": [1, 3], "unlock": "montagne_pics", "key_poi": "5,3",
		"reveals": ["mine_cristal", "bastion_orage", "forge_givre", "pic_foudroyant"],
	},
	"piemont_ocre": {
		"name": "Piémont Ocre", "biome": "Montagne", "size": [18, 14], "shape": "ile_b", "grid": [2, 2],
		"blend": {"biome": "Désert", "side": "E"},
		"start": [1, 3], "unlock": "lisiere_col", "key_poi": "4,3",
		"reveals": ["observatoire", "temple_soleil", "fort_cendre"],
	},
	"desert_dunes": {
		"name": "Dunes Perdues", "biome": "Désert", "size": [20, 16], "shape": "ile", "grid": [3, 2],
		"start": [1, 3], "unlock": "montagne_pics", "key_poi": "4,3", "reveals": ["oasis", "caravanserail", "tour_sable"],
	},
	"portes_donjon": {
		"name": "Portes du Donjon", "biome": "Donjon", "size": [16, 14], "shape": "ile", "grid": [2, 3],
		"start": [5, 1], "unlock": "piemont_ocre", "key_poi": "5,3",
		"reveals": ["donjon_roi", "citadelle_sable", "port_sable"],
	},
	"vents_plateau": {
		"name": "Plateau des Vents", "biome": "Vents", "size": [18, 14], "shape": "ile_b", "grid": [1, 0],
		"start": [1, 3], "unlock": "foret_sylve", "key_poi": "6,3", "reveals": ["bastion_orage", "pic_foudroyant"],
	},
	"brumes_marais": {
		"name": "Marais des Brumes", "biome": "Brumes", "size": [18, 16], "shape": "ile", "grid": [1, 2],
		"start": [1, 3], "unlock": "foret_sylve", "key_poi": "6,2", "reveals": ["village_brume", "marais_spectres", "bois_lune"],
	},
	"brasier_cendres": {
		"name": "Terres de Cendre", "biome": "Brasier", "size": [16, 14], "shape": "ile_b", "grid": [0, 2],
		"start": [1, 3], "unlock": "foret_ronces", "key_poi": "6,4", "reveals": ["fort_cendre", "citadelle_sable"],
	},
	"ombres_necropole": {
		"name": "Nécropole d'Ombre", "biome": "Ombres", "size": [18, 14], "shape": "ile", "grid": [1, 3],
		"start": [1, 3], "unlock": "brumes_marais", "key_poi": "5,3", "reveals": ["abbaye_ronce", "citadelle_ronce", "ruines_lierre"],
	},
	"cristaux_caverne": {
		"name": "Caverne de Cristal", "biome": "Cristaux", "size": [16, 16], "shape": "ile_b", "grid": [3, 3],
		"start": [1, 3], "unlock": "portes_donjon", "key_poi": "6,3", "reveals": ["mine_cristal", "forge_givre"],
	},
	"marees_cotes": {
		"name": "Côtes des Marées", "biome": "Marées", "size": [20, 14], "shape": "ile", "grid": [4, 2],
		"start": [1, 3], "unlock": "desert_dunes", "key_poi": "6,2", "reveals": ["port_sable", "caravanserail"],
	},
	"rouages_atelier": {
		"name": "Ateliers des Rouages", "biome": "Rouages", "size": [18, 12], "shape": "ile_b", "grid": [4, 1],
		"start": [1, 3], "unlock": "marees_cotes", "key_poi": "6,3", "reveals": ["atelier_cuivre", "citadelle_engrenages"],
	},
}

const ADVENTURE_POIS := {
	"foret_sylve": {
		"4,1": {"kind": "puzzle", "name": "Sanctuaire des runes", "level": 1,
			"desc": "De vieilles runes attendent une réponse."},
		"7,2": {"kind": "combat", "name": "Camp gobelin", "level": 1,
			"desc": "Des gobelins ont dressé leurs tentes."},
		"3,4": {"kind": "chest", "name": "Coffre moussu", "level": 1,
			"desc": "Un coffre à demi enseveli sous la mousse."},
		"5,5": {"kind": "camp", "name": "Source claire", "level": 1,
			"desc": "Un endroit sûr pour reprendre souffle."},
		"8,5": {"kind": "reveal", "name": "Belvédère de la Sylve", "level": 1,
			"desc": "Du haut de l’arbre, la vallée se dévoile."},
		"2,1": {"kind": "puzzle", "name": "Cercle des pierres chantantes", "level": 1,
			"desc": "Des menhirs s'illuminent puis se taisent."},
		# V47 : la Sylve s'agrandit (22 × 16) ; ces lieux occupent les nouvelles terres.
		"5,10": {"kind": "combat", "name": "Tanière du sanglier", "level": 2,
			"desc": "Un grand sanglier défend sa bauge."},
		"11,7": {"kind": "combat", "name": "Embuscade sous les pins", "level": 3,
			"desc": "Des brigands guettent le sentier."},
		"14,11": {"kind": "combat", "name": "Meute de loups gris", "level": 4,
			"desc": "Des hurlements montent des fourrés."},
		"10,12": {"kind": "camp", "name": "Clairière des lucioles", "level": 1,
			"desc": "Des lucioles dansent autour d'un feu tranquille."},
		"19,4": {"kind": "chest", "name": "Souche creuse", "level": 2,
			"desc": "Quelque chose brille au fond de la souche."},
		"18,12": {"kind": "chest", "name": "Cache du bûcheron", "level": 3,
			"desc": "Un coffre dissimulé sous des fagots."},
	},
	"foret_ronces": {
		"1,1": {"kind": "combat", "guardian": "Forêt", "name": "Donjon de la Nation Sylvestre", "level": 17,
			"desc": "Quatre salles de plus en plus dures ; le Gardien veille sur la Pierre de Sève."},
		"5,1": {"kind": "combat", "name": "Embûche de ronces", "level": 8,
			"desc": "Quelque chose remue sous les ronces."},
		"2,2": {"kind": "puzzle", "name": "Autel du Lierre", "level": 8,
			"desc": "L’autel du Lierre pose son énigme."},
		"7,4": {"kind": "chest", "name": "Cachette du braconnier", "level": 8,
			"desc": "Un vieux sac oublié sous une racine."},
		"4,5": {"kind": "combat", "name": "Patrouille de la Citadelle", "level": 14,
			"desc": "Des soldats des Ronces rôdent ici."},
		"8,1": {"kind": "puzzle", "name": "Dalles du cloître", "level": 8,
			"desc": "Neuf dalles gravées, certaines éteintes."},
		"1,5": {"kind": "camp", "name": "Feu de camp des pèlerins", "level": 8,
			"desc": "Des braises encore tièdes sous un abri de ronces."},
		# V47 : zone agrandie (18 × 14), nouveaux lieux.
		"13,10": {"kind": "combat", "name": "Clairière des maraudeurs", "level": 8,
			"desc": "Des maraudeurs ont investi la clairière."},
		"6,9": {"kind": "chest", "name": "Terrier du renard", "level": 8,
			"desc": "Quelque chose brille au fond du terrier."},
		"9,7": {"kind": "combat", "name": "Gué des bûcherons", "level": 8,
			"desc": "Une bande armée garde le gué."},
		"3,7": {"kind": "camp", "name": "Abri sous les fougères", "level": 8,
			"desc": "Un coin sûr pour souffler."},
		"6,6": {"kind": "chest", "name": "Hotte abandonnée", "level": 8,
			"desc": "Une hotte oubliée sous les branches."},
	},
	"montagne_pics": {
		"5,2": {"kind": "combat", "name": "Caverne du Troll", "level": 32,
			"desc": "Un troll garde le passage."},
		"2,4": {"kind": "puzzle", "name": "Runes du Col", "level": 32,
			"desc": "Des runes gelées à déchiffrer."},
		"7,5": {"kind": "chest", "name": "Grotte au cristal", "level": 32,
			"desc": "Un éclat de cristal brille au fond."},
		"8,1": {"kind": "reveal", "name": "Panneau du Givre", "level": 32,
			"desc": "Tout le massif s’étale sous vos yeux."},
		"3,1": {"kind": "puzzle", "name": "Orgue de glace", "level": 32,
			"desc": "Des stalactites résonnent au gré du vent."},
		"5,4": {"kind": "camp", "name": "Refuge du berger", "level": 32,
			"desc": "Une cabane de pierre, un poêle et du thé chaud."},
		# V47 : zone agrandie (18 × 16), nouveaux lieux.
		"5,11": {"kind": "combat", "name": "Passe des éboulis", "level": 32,
			"desc": "Des brigands guettent dans les éboulis."},
		"10,9": {"kind": "chest", "name": "Corniche gelée", "level": 32,
			"desc": "Un coffre pris dans la glace."},
		"14,12": {"kind": "combat", "name": "Nid du gerfaut", "level": 32,
			"desc": "Un grand rapace défend son aire."},
		"3,7": {"kind": "camp", "name": "Refuge de berger", "level": 32,
			"desc": "Un refuge de pierre, encore chaud."},
		"6,8": {"kind": "chest", "name": "Sac de glace", "level": 32,
			"desc": "Un sac gelé laissé par un voyageur."},
	},
	"lisiere_col": {
		"6,3": {"kind": "combat", "name": "Loups de la lisière", "level": 12,
			"desc": "Une meute garde le passage vers les hauteurs."},
		"3,2": {"kind": "chest", "name": "Cabane du bûcheron", "level": 12,
			"desc": "Une cabane abandonnée, la porte entrouverte."},
		"2,5": {"kind": "puzzle", "name": "Totem des deux versants", "level": 12,
			"desc": "Les runes du totem s'allument tour à tour."},
		"7,1": {"kind": "reveal", "name": "Mirador de la lisière", "level": 12,
			"desc": "D'ici, forêts et sommets se partagent l'horizon."},
		"8,5": {"kind": "camp", "name": "Halte des colporteurs", "level": 12,
			"desc": "Un abri de toile où l'on échange les nouvelles."},
		# V47 : zone agrandie (20 × 14), nouveaux lieux.
		"12,8": {"kind": "combat", "name": "Clairière des maraudeurs", "level": 12,
			"desc": "Des maraudeurs ont investi la clairière."},
		"16,10": {"kind": "chest", "name": "Terrier du renard", "level": 12,
			"desc": "Quelque chose brille au fond du terrier."},
		"12,3": {"kind": "combat", "name": "Gué des bûcherons", "level": 12,
			"desc": "Une bande armée garde le gué."},
		"5,6": {"kind": "camp", "name": "Abri sous les fougères", "level": 12,
			"desc": "Un coin sûr pour souffler."},
		"14,6": {"kind": "chest", "name": "Hotte abandonnée", "level": 12,
			"desc": "Une hotte oubliée sous les branches."},
	},
	"cretes_givre": {
		"1,1": {"kind": "combat", "guardian": "Montagne", "name": "Donjon de la Nation Cimes", "level": 45,
			"desc": "Quatre salles de plus en plus dures ; le Gardien veille sur la Pierre de Givre."},
		"5,3": {"kind": "combat", "name": "Sentinelles de glace", "level": 42,
			"desc": "Des silhouettes figées bougent quand on approche."},
		"4,5": {"kind": "combat", "name": "Troll des crêtes", "level": 45,
			"desc": "Un troll énorme réclame un droit de passage."},
		"2,1": {"kind": "puzzle", "name": "Miroirs de givre", "level": 42,
			"desc": "Seize miroirs de glace, la plupart ternis."},
		"7,5": {"kind": "chest", "name": "Cache du contrebandier", "level": 42,
			"desc": "Un coffre arrimé sous un surplomb."},
		"8,1": {"kind": "reveal", "name": "Aiguille des Crêtes", "level": 42,
			"desc": "Le plus haut sommet de Zimut."},
		"2,5": {"kind": "camp", "name": "Grotte tiède", "level": 42,
			"desc": "Une source chaude fume au fond de la grotte."},
		# V47 : zone agrandie (20 × 12), nouveaux lieux.
		"13,7": {"kind": "combat", "name": "Passe des éboulis", "level": 42,
			"desc": "Des brigands guettent dans les éboulis."},
		"11,4": {"kind": "chest", "name": "Corniche gelée", "level": 42,
			"desc": "Un coffre pris dans la glace."},
		"16,8": {"kind": "combat", "name": "Nid du gerfaut", "level": 42,
			"desc": "Un grand rapace défend son aire."},
		"9,3": {"kind": "camp", "name": "Refuge de berger", "level": 42,
			"desc": "Un refuge de pierre, encore chaud."},
		"10,6": {"kind": "chest", "name": "Sac de glace", "level": 42,
			"desc": "Un sac gelé laissé par un voyageur."},
	},
	"piemont_ocre": {
		"4,3": {"kind": "combat", "name": "Pillards du piémont", "level": 38,
			"desc": "Des pillards rançonnent les caravanes."},
		"7,1": {"kind": "puzzle", "name": "Stèle des caravaniers", "level": 38,
			"desc": "Une stèle gravée d'une question."},
		"2,1": {"kind": "chest", "name": "Sacoche du muletier", "level": 38,
			"desc": "Une sacoche tombée d'un bât."},
		"7,5": {"kind": "reveal", "name": "Promontoire ocre", "level": 38,
			"desc": "Les dunes s'étendent jusqu'à la mer."},
		"2,5": {"kind": "camp", "name": "Bivouac des canyons", "level": 38,
			"desc": "Un feu à l'abri du vent des canyons."},
		# V47 : zone agrandie (18 × 14), nouveaux lieux.
		"11,8": {"kind": "combat", "name": "Passe des éboulis", "level": 38,
			"desc": "Des brigands guettent dans les éboulis."},
		"14,10": {"kind": "chest", "name": "Corniche gelée", "level": 38,
			"desc": "Un coffre pris dans la glace."},
		"10,3": {"kind": "combat", "name": "Nid du gerfaut", "level": 38,
			"desc": "Un grand rapace défend son aire."},
		"4,6": {"kind": "camp", "name": "Refuge de berger", "level": 38,
			"desc": "Un refuge de pierre, encore chaud."},
		"6,7": {"kind": "chest", "name": "Sac de glace", "level": 38,
			"desc": "Un sac gelé laissé par un voyageur."},
	},
	"portes_donjon": {
		"5,3": {"kind": "combat", "name": "Garde des Portes", "level": 94,
			"desc": "Les squelettes de la garde royale veillent encore."},
		"3,5": {"kind": "combat", "name": "Crypte oubliée", "level": 100,
			"desc": "Quelque chose gratte sous la dalle."},
		"2,2": {"kind": "puzzle", "name": "Sceau des Portes", "level": 94,
			"desc": "Sept sceaux à rallumer dans le bon ordre."},
		"8,2": {"kind": "chest", "name": "Ossuaire", "level": 94,
			"desc": "Des offrandes oubliées parmi les os."},
		"7,5": {"kind": "reveal", "name": "Tour de guet morte", "level": 94,
			"desc": "Du sommet, le Donjon du Roi Squelette."},
		"1,1": {"kind": "camp", "name": "Brasero des pèlerins", "level": 94,
			"desc": "Une flamme bleue qui ne s'éteint jamais."},
		# V47 : zone agrandie (16 × 14), nouveaux lieux.
		"5,9": {"kind": "combat", "name": "Salle des gardes", "level": 94,
			"desc": "Des gardes veillent encore."},
		"11,10": {"kind": "chest", "name": "Coffre scellé", "level": 94,
			"desc": "Un coffre aux sceaux intacts."},
		"8,8": {"kind": "combat", "name": "Cellules oubliées", "level": 94,
			"desc": "Des bruits de chaînes résonnent."},
		"4,7": {"kind": "camp", "name": "Alcôve de repos", "level": 94,
			"desc": "Une alcôve à l'abri des courants d'air."},
		"7,10": {"kind": "chest", "name": "Reliquaire brisé", "level": 94,
			"desc": "Un reliquaire fendu laisse voir un éclat."},
	},
	"desert_dunes": {
		"8,3": {"kind": "combat", "guardian": "Désert", "name": "Donjon de la Nation Sables", "level": 70,
			"desc": "Quatre salles de plus en plus dures ; le Gardien veille sur la Pierre d'Ocre."},
		"4,3": {"kind": "combat", "name": "Squelettes des sables", "level": 64,
			"desc": "Des ossements s’animent à votre approche."},
		"6,1": {"kind": "puzzle", "name": "Obélisque Solaire", "level": 64,
			"desc": "L’obélisque attend sa constellation."},
		"2,5": {"kind": "chest", "name": "Épave du convoi", "level": 64,
			"desc": "Les restes d’un convoi ensevelis."},
		"8,5": {"kind": "reveal", "name": "Mirador du Désert", "level": 64,
			"desc": "Un mirador dominant les Dunes."},
		"5,5": {"kind": "puzzle", "name": "Mosaïque du soleil", "level": 64,
			"desc": "Seize tuiles de verre attendent la lumière."},
		"1,1": {"kind": "camp", "name": "Puits de l'oasis", "level": 64,
			"desc": "Une eau fraîche au fond d'un puits de grès."},
		# V47 : zone agrandie (20 × 16), nouveaux lieux.
		"14,11": {"kind": "combat", "name": "Oasis disputée", "level": 64,
			"desc": "Des pillards se disputent l'oasis."},
		"6,11": {"kind": "chest", "name": "Jarre enfouie", "level": 64,
			"desc": "Une jarre scellée affleure."},
		"10,9": {"kind": "combat", "name": "Carrière ensablée", "level": 64,
			"desc": "Quelque chose remue sous le sable."},
		"16,5": {"kind": "camp", "name": "Puits ombragé", "level": 64,
			"desc": "Un puits à l'ombre des palmes."},
		"3,9": {"kind": "chest", "name": "Cache de caravane", "level": 64,
			"desc": "Les restes d'une caravane."},
	},
	"vents_plateau": {
		"1,1": {"kind": "combat", "guardian": "Vents", "name": "Donjon de la Nation Vents", "level": 54,
			"desc": "Quatre salles de plus en plus dures ; le Gardien veille sur la Pierre d'Azur."},
		"3,2": {"kind": "combat", "name": "Garde aérienne", "level": 46, "desc": "Des sentinelles ailées patrouillent."},
		"6,3": {"kind": "combat", "name": "Harpies du plateau", "level": 54, "desc": "Les harpies défendent leur nid."},
		"2,5": {"kind": "chest", "name": "Nid d'aigle", "level": 46, "desc": "Un nid garni de trouvailles."},
		"7,1": {"kind": "puzzle", "name": "Totem du souffle", "level": 46, "desc": "Le totem murmure une énigme."},
		"8,5": {"kind": "reveal", "name": "Tour des vents", "level": 46, "desc": "Une tour qui domine les nuages."},
		"4,4": {"kind": "camp", "name": "Abri de plume", "level": 46, "desc": "Un abri contre les rafales."},
		# V47 : zone agrandie (18 × 14), nouveaux lieux.
		"12,9": {"kind": "combat", "name": "Corniche des bourrasques", "level": 46,
			"desc": "Des créatures chevauchent les rafales."},
		"6,7": {"kind": "chest", "name": "Caisse emportée", "level": 46,
			"desc": "Une caisse prise dans un tourbillon."},
		"10,3": {"kind": "combat", "name": "Pont de nuages", "level": 46,
			"desc": "Un pont de brume garde son gardien."},
		"10,7": {"kind": "camp", "name": "Abri sous le vent", "level": 46,
			"desc": "Un creux où le vent ne passe pas."},
		"11,5": {"kind": "chest", "name": "Nid de plumes", "level": 46,
			"desc": "Un nid garni de trouvailles."},
	},
	"brumes_marais": {
		"1,1": {"kind": "combat", "guardian": "Brumes", "name": "Donjon de la Nation Brumes", "level": 31,
			"desc": "Quatre salles de plus en plus dures ; le Gardien veille sur la Pierre de Lune-des-Marais."},
		"3,2": {"kind": "combat", "name": "Rôdeurs brumeux", "level": 26, "desc": "Des formes se glissent dans la brume."},
		"6,2": {"kind": "combat", "name": "Liche du marais", "level": 31, "desc": "Un mort-vivant garde le marais."},
		"2,5": {"kind": "chest", "name": "Coffre englouti", "level": 26, "desc": "Un coffre à moitié enfoui dans la vase."},
		"7,1": {"kind": "puzzle", "name": "Champignon sage", "level": 26, "desc": "Un grand champignon pose une devinette."},
		"8,5": {"kind": "reveal", "name": "Arbre des esprits", "level": 26, "desc": "On voit loin depuis ses branches."},
		"4,4": {"kind": "camp", "name": "Cabane sur pilotis", "level": 26, "desc": "Un refuge au-dessus de l'eau."},
		# V47 : zone agrandie (18 × 16), nouveaux lieux.
		"5,11": {"kind": "combat", "name": "Gué des feux-follets", "level": 26,
			"desc": "Des lueurs attirent les imprudents."},
		"11,10": {"kind": "chest", "name": "Souche engloutie", "level": 26,
			"desc": "Une souche cache un coffre."},
		"14,12": {"kind": "combat", "name": "Hutte du marais", "level": 26,
			"desc": "Une hutte à moitié engloutie."},
		"3,9": {"kind": "camp", "name": "Îlot sec", "level": 26,
			"desc": "Un îlot sec au milieu des eaux."},
		"5,7": {"kind": "chest", "name": "Barque échouée", "level": 26,
			"desc": "Une barque pleine de bric-à-brac."},
	},
	"brasier_cendres": {
		"1,1": {"kind": "combat", "guardian": "Brasier", "name": "Donjon de la Nation Brasier", "level": 25,
			"desc": "Quatre salles de plus en plus dures ; le Gardien veille sur la Pierre de Braise."},
		"3,2": {"kind": "combat", "name": "Lieutenants de braise", "level": 18, "desc": "Des soldats de feu montent la garde."},
		"6,4": {"kind": "combat", "name": "Golem de lave", "level": 25, "desc": "Un colosse de roche en fusion."},
		"2,5": {"kind": "chest", "name": "Forge abandonnée", "level": 18, "desc": "Une forge oubliée, encore tiède."},
		"7,1": {"kind": "puzzle", "name": "Brasero oraculaire", "level": 18, "desc": "Les flammes posent une question."},
		"8,5": {"kind": "reveal", "name": "Cratère-belvédère", "level": 18, "desc": "Du bord du cratère on voit loin."},
		"4,4": {"kind": "camp", "name": "Source chaude", "level": 18, "desc": "Une source bienfaisante."},
		# V47 : zone agrandie (16 × 14), nouveaux lieux.
		"11,9": {"kind": "combat", "name": "Faille de braise", "level": 18,
			"desc": "Des flammes lèchent la faille."},
		"5,7": {"kind": "chest", "name": "Coffre de cendre", "level": 18,
			"desc": "Un coffre noirci mais intact."},
		"9,7": {"kind": "combat", "name": "Forge éteinte", "level": 18,
			"desc": "Une forge qui n'est pas si éteinte."},
		"12,7": {"kind": "camp", "name": "Cratère tranquille", "level": 18,
			"desc": "Un cratère éteint, à l'abri des cendres."},
		"3,6": {"kind": "chest", "name": "Urne tiède", "level": 18,
			"desc": "Une urne encore tiède."},
	},
	"ombres_necropole": {
		"1,1": {"kind": "combat", "guardian": "Ombres", "name": "Donjon de la Nation Ombres", "level": 63,
			"desc": "Quatre salles de plus en plus dures ; le Gardien veille sur la Pierre d'Ébène."},
		"3,2": {"kind": "combat", "name": "Assassins des ombres", "level": 55, "desc": "Des silhouettes jaillissent des tombes."},
		"5,3": {"kind": "combat", "name": "Spectre gardien", "level": 63, "desc": "Le gardien de la nécropole."},
		"2,5": {"kind": "chest", "name": "Caveau scellé", "level": 55, "desc": "Un caveau dont le sceau a cédé."},
		"7,1": {"kind": "puzzle", "name": "Obélisque fêlé", "level": 55, "desc": "L'obélisque exige une réponse."},
		"8,5": {"kind": "reveal", "name": "Tour du corbeau", "level": 55, "desc": "Un perchoir sur la nécropole."},
		"4,4": {"kind": "camp", "name": "Crypte tranquille", "level": 55, "desc": "Un coin de calme parmi les stèles."},
		# V47 : zone agrandie (18 × 14), nouveaux lieux.
		"13,10": {"kind": "combat", "name": "Crypte oubliée", "level": 55,
			"desc": "Quelque chose veille dans la crypte."},
		"5,9": {"kind": "chest", "name": "Sarcophage fissuré", "level": 55,
			"desc": "Un sarcophage entrouvert."},
		"10,8": {"kind": "combat", "name": "Allée des veilleurs", "level": 55,
			"desc": "Des silhouettes bordent l'allée."},
		"8,10": {"kind": "camp", "name": "Chapelle silencieuse", "level": 55,
			"desc": "Un silence apaisant règne ici."},
		"3,7": {"kind": "chest", "name": "Offrande ternie", "level": 55,
			"desc": "Une offrande oubliée sur un autel."},
	},
	"cristaux_caverne": {
		"1,1": {"kind": "combat", "guardian": "Cristaux", "name": "Donjon de la Nation Cristaux", "level": 86,
			"desc": "Quatre salles de plus en plus dures ; le Gardien veille sur la Pierre de Prisme."},
		"3,2": {"kind": "combat", "name": "Mineurs cristallins", "level": 79, "desc": "Des ouvriers de cristal veillent."},
		"6,3": {"kind": "combat", "name": "Golem prismatique", "level": 86, "desc": "Le gardien lumineux de la caverne."},
		"2,5": {"kind": "chest", "name": "Géode brisée", "level": 79, "desc": "Une géode pleine d'éclats précieux."},
		"7,1": {"kind": "puzzle", "name": "Miroir d'améthyste", "level": 79, "desc": "Le cristal pose son énigme."},
		"8,5": {"kind": "reveal", "name": "Dôme de cristal", "level": 79, "desc": "Une vue sur toute la caverne."},
		"4,4": {"kind": "camp", "name": "Grotte tiède", "level": 79, "desc": "Un coin chaud et abrité."},
		# V47 : zone agrandie (16 × 16), nouveaux lieux.
		"11,11": {"kind": "combat", "name": "Grotte aux éclats", "level": 79,
			"desc": "Des éclats vivants tapissent la grotte."},
		"5,8": {"kind": "chest", "name": "Géode intacte", "level": 79,
			"desc": "Une géode pleine de reflets."},
		"9,8": {"kind": "combat", "name": "Veine luisante", "level": 79,
			"desc": "Une veine luisante attire les rôdeurs."},
		"12,7": {"kind": "camp", "name": "Alcôve de lumière", "level": 79,
			"desc": "Une alcôve baignée de lumière douce."},
		"3,7": {"kind": "chest", "name": "Coffre serti", "level": 79,
			"desc": "Un coffre serti de gemmes."},
	},
	"marees_cotes": {
		"1,1": {"kind": "combat", "guardian": "Marées", "name": "Donjon de la Nation Marées", "level": 78,
			"desc": "Quatre salles de plus en plus dures ; le Gardien veille sur la Pierre de Corail."},
		"3,2": {"kind": "combat", "name": "Pirates des marées", "level": 71, "desc": "Des pirates ont jeté l'ancre."},
		"6,2": {"kind": "combat", "name": "Crabe titan", "level": 78, "desc": "Un crabe gigantesque garde la crique."},
		"2,5": {"kind": "chest", "name": "Épave échouée", "level": 71, "desc": "Une épave pleine de butin."},
		"7,1": {"kind": "puzzle", "name": "Phare muet", "level": 71, "desc": "Le gardien du phare pose une devinette."},
		"8,5": {"kind": "reveal", "name": "Grand phare", "level": 71, "desc": "Du phare, on voit tout le littoral."},
		"4,4": {"kind": "camp", "name": "Plage abritée", "level": 71, "desc": "Une crique calme pour souffler."},
		# V47 : zone agrandie (20 × 14), nouveaux lieux.
		"6,10": {"kind": "combat", "name": "Récif des pillards", "level": 71,
			"desc": "Des pillards guettent depuis le récif."},
		"14,10": {"kind": "chest", "name": "Malle salée", "level": 71,
			"desc": "Une malle rongée de sel."},
		"16,4": {"kind": "combat", "name": "Épave échouée", "level": 71,
			"desc": "Quelque chose rôde dans l'épave."},
		"10,8": {"kind": "camp", "name": "Crique abritée", "level": 71,
			"desc": "Une crique à l'abri des vagues."},
		"4,8": {"kind": "chest", "name": "Coquille nacrée", "level": 71,
			"desc": "Une coquille géante, nacrée."},
	},
	"rouages_atelier": {
		"1,1": {"kind": "combat", "guardian": "Rouages", "name": "Donjon de la Nation Rouages", "level": 93,
			"desc": "Quatre salles de plus en plus dures ; le Gardien veille sur la Pierre d'Airain."},
		"3,2": {"kind": "combat", "name": "Gobelins mécaniciens", "level": 87, "desc": "Des bricoleurs testent leurs inventions sur les visiteurs."},
		"6,3": {"kind": "combat", "name": "Colosse d'engrenages", "level": 93, "desc": "Une machine géante garde la grande forge."},
		"2,5": {"kind": "chest", "name": "Caisse d'outils scellée", "level": 87, "desc": "Une caisse pleine de pièces rares."},
		"7,1": {"kind": "puzzle", "name": "Tableau de commande", "level": 87, "desc": "Des cadrans à régler dans le bon ordre."},
		"8,5": {"kind": "reveal", "name": "Pont de l'horloger", "level": 87, "desc": "Le toit de l'atelier domine la région."},
		"4,4": {"kind": "camp", "name": "Chaufferie tiède", "level": 87, "desc": "Une chaudière ronronne : on s'y réchauffe."},
		# V47 : zone agrandie (18 × 12), nouveaux lieux.
		"12,7": {"kind": "combat", "name": "Atelier saboté", "level": 87,
			"desc": "Des automates tournent à vide."},
		"10,3": {"kind": "chest", "name": "Caisse d'outils", "level": 87,
			"desc": "Une caisse d'outils bien fournie."},
		"6,6": {"kind": "combat", "name": "Convoyeur fou", "level": 87,
			"desc": "Un convoyeur emballé barre le passage."},
		"10,6": {"kind": "camp", "name": "Poste de réparation", "level": 87,
			"desc": "Un poste où reprendre ses esprits."},
		"14,8": {"kind": "chest", "name": "Coffre à engrenages", "level": 87,
			"desc": "Un coffre à serrure complexe."},
	},

}

## Énigmes officielles des POI « puzzle » (clé = "zone,x,y").
## Énigmes officielles des POI « puzzle » (clé = "zone,x,y").
##   type « riddle » (défaut) : question, réponse + choix (la réponse tapée est aussi
##     acceptée, sans tenir compte des accents, majuscules ni articles) ;
##   type « runes »  : mémoire — reproduire une suite de `length` runes ;
##   type « lights » : dalles — allumer toutes les dalles d'une grille `size`×`size`
##     (toucher une dalle bascule aussi ses voisines), mélangée en `scramble` coups.
const ADVENTURE_PUZZLES := {
	"foret_sylve,4,1": {"type": "riddle", "text": "Je grandis quand on me nourrit, mais je meurs si l’on me donne à boire. Qui suis-je ?",
		"answer": "Le feu", "choices": ["Le feu", "L'arbre", "Le vent"], "wrong": "Les runes restent muettes."},
	"foret_ronces,2,2": {"type": "riddle", "text": "Plus j’ai de gardiens, moins je vaux. Moins j’en ai, plus je vaux. Qui suis-je ?",
		"answer": "Le secret", "choices": ["Le secret", "Le trésor", "La promesse"], "wrong": "L’autel garde son silence."},
	"montagne_pics,2,4": {"type": "riddle", "text": "Je brille sans brûler, je fuis sans marcher, je reviens chaque nuit. Qui suis-je ?",
		"answer": "La lune", "choices": ["La lune", "L'étoile filante", "Le feu follet"], "wrong": "Le givre dévore la réponse."},
	"desert_dunes,6,1": {"type": "riddle", "text": "On me jette car je perds ma valeur ; on me ramasse car j’en gagne une autre. Qui suis-je ?",
		"answer": "Une pièce de monnaie", "choices": ["Une pièce de monnaie", "Une graine", "Un os"], "wrong": "L’obélisque reste ténébreux."},
	"foret_sylve,2,1": {"type": "runes", "length": 4,
		"text": "Les pierres du cercle s'allument une à une. Reproduisez leur chant dans le même ordre.",
		"wrong": "Les pierres se taisent… et recommencent leur chant."},
	"foret_ronces,8,1": {"type": "lights", "size": 3, "scramble": 3,
		"text": "Allumez les neuf dalles. Toucher une dalle bascule aussi ses voisines (haut, bas, gauche, droite).",
		"wrong": "Les dalles s'éteignent dans un soupir de pierre."},
	"montagne_pics,3,1": {"type": "runes", "length": 6,
		"text": "Le vent joue un air sur les stalactites. Rejouez la mélodie note après note.",
		"wrong": "La glace grince : fausse note. Écoutez de nouveau."},
	"desert_dunes,5,5": {"type": "lights", "size": 4, "scramble": 4,
		"text": "Faites briller les seize tuiles de la mosaïque. Chaque tuile entraîne ses voisines.",
		"wrong": "Le soleil se voile sur la mosaïque."},
	"lisiere_col,2,5": {"type": "runes", "length": 5,
		"text": "Le totem fait briller ses runes une à une. Rejouez la même suite.",
		"wrong": "Le totem s'éteint. Il recommence…"},
	"cretes_givre,2,1": {"type": "lights", "size": 4, "scramble": 5,
		"text": "Faites briller les seize miroirs. Chaque miroir touché bascule aussi ses voisins.",
		"wrong": "Le givre recouvre les miroirs."},
	"piemont_ocre,7,1": {"type": "riddle", "text": "Je n'ai ni bouche ni voix, et pourtant je réponds à qui m'appelle dans la montagne. Qui suis-je ?",
		"answer": "L'écho", "choices": ["L'écho", "Le vent", "Le torrent"], "wrong": "La stèle reste silencieuse."},
	"portes_donjon,2,2": {"type": "runes", "length": 7,
		"text": "Les sept sceaux s'allument dans un ordre précis. Rallumez-les dans le même ordre.",
		"wrong": "Les sceaux se referment avec un grondement."},
	"vents_plateau,7,1": {"type": "riddle", "text": "Je traverse les montagnes sans bouger de ma place et je dévore la forêt sans dent. Qui suis-je ?",
		"answer": "Le vent", "choices": ["Le vent", "Le feu", "Le torrent"], "wrong": "Le totem reste silencieux."},
	"brumes_marais,7,1": {"type": "riddle", "text": "Plus il y a de moi, moins tu vois. Qui suis-je ?",
		"answer": "La brume", "choices": ["La brume", "La lumière", "La nuit"], "wrong": "Le champignon vire au gris."},
	"brasier_cendres,7,1": {"type": "riddle", "text": "Je nais du bois, je meurs de l'eau, et je laisse la cendre derrière moi. Qui suis-je ?",
		"answer": "Le feu", "choices": ["Le feu", "La fumée", "La lave"], "wrong": "Le brasero crache des étincelles."},
	"ombres_necropole,7,1": {"type": "runes", "length": 6,
		"text": "Les runes de l'obélisque s'éveillent une à une. Rejouez leur ordre sans faillir.",
		"wrong": "L'obélisque se tait, puis recommence."},
	"cristaux_caverne,7,1": {"type": "lights", "size": 4, "scramble": 5,
		"text": "Faites briller les seize facettes du miroir. Chaque facette touchée bascule ses voisines.",
		"wrong": "Le miroir s'éteint dans un tintement."},
	"marees_cotes,7,1": {"type": "riddle", "text": "Je monte et je descends sans jamais bouger d'un pas, deux fois par jour. Qui suis-je ?",
		"answer": "La marée", "choices": ["La marée", "Le courant", "La vague"], "wrong": "Le phare reste éteint."},
	"rouages_atelier,7,1": {"type": "runes", "length": 6,
		"text": "Les voyants du tableau s'allument un à un. Rejouez la séquence sans vous tromper.",
		"wrong": "Le tableau grésille, puis redémarre."},
}


## Catalogue officiel des villes de Conquête (la carte de ConquestMapUI en est
## dérivée) : id -> { name, kind, biome, level }.
##   capital : imprenable, quartier général ;
##   neutral : 1 bataille de mobs ;
##   enemy   : siège en 4 batailles (3 mobs + boss du biome) ;
##   donjon_roi : objectif final, débloqué quand tout l'empire est conquis.
const CONQUEST_CITIES := {
	"capitale":     {"name": "Sylve-Cœur",      "kind": "capital",    "biome": "Forêt",     "level": 0},
	"clairiere":    {"name": "Clairière d'Aube", "kind": "neutral",   "biome": "Forêt",     "level": 1},
	"vieille_tour": {"name": "Vieille Tour",     "kind": "enemy",     "biome": "Forêt",     "level": 6},
	"pont_mousse":  {"name": "Pont-Mousse",      "kind": "neutral",   "biome": "Forêt",     "level": 3},
	"fort_racine":  {"name": "Fort Racine",       "kind": "enemy",     "biome": "Forêt",     "level": 15},
	"hameau_pin":   {"name": "Hameau du Pin",    "kind": "neutral",   "biome": "Montagne",  "level": 26},
	"garnison":    {"name": "Garnison des Pics", "kind": "enemy",     "biome": "Montagne",  "level": 40},
	"oasis":        {"name": "Oasis Perdue",      "kind": "neutral",   "biome": "Désert",    "level": 55},
	"tour_sable":   {"name": "Tour des Sables",  "kind": "enemy",     "biome": "Désert",    "level": 72},
	"donjon_roi":   {"name": "Donjon du Roi Squelette", "kind": "enemy", "biome": "Donjon", "level": 100},
	"village_brume": {"name": "Village des Brumes", "kind": "neutral", "biome": "Brumes", "level": 3},
	"ruines_lierre": {"name": "Ruines du Lierre", "kind": "enemy", "biome": "Ombres", "level": 10},
	"abbaye_ronce": {"name": "Abbaye des Ronces", "kind": "neutral", "biome": "Ombres", "level": 15},
	"citadelle_ronce": {"name": "Citadelle des Ronces", "kind": "enemy", "biome": "Ombres", "level": 20},
	"col_givre": {"name": "Col du Givre", "kind": "neutral", "biome": "Montagne", "level": 33},
	"mine_cristal": {"name": "Mine de Cristal", "kind": "enemy", "biome": "Cristaux", "level": 47},
	"bastion_orage": {"name": "Bastion de l'Orage", "kind": "enemy", "biome": "Vents", "level": 63},
	"caravanserail": {"name": "Caravansérail Rouge", "kind": "neutral", "biome": "Marées", "level": 72},
	"observatoire": {"name": "Observatoire Solaire", "kind": "neutral", "biome": "Désert", "level": 81},
	"port_sable": {"name": "Port des Sables", "kind": "enemy", "biome": "Marées", "level": 90},
	"bois_lune": {"name": "Bois de Lune", "kind": "neutral", "biome": "Brumes", "level": 26},
	"sanctuaire_mousse": {"name": "Sanctuaire Moussu", "kind": "neutral", "biome": "Forêt", "level": 33},
	"forge_givre": {"name": "Forge du Givre", "kind": "enemy", "biome": "Cristaux", "level": 81},
	"pic_foudroyant": {"name": "Pic Foudroyant", "kind": "enemy", "biome": "Vents", "level": 90},
	"marais_spectres": {"name": "Marais des Spectres", "kind": "neutral", "biome": "Brumes", "level": 40},
	"fort_cendre": {"name": "Fort des Cendres", "kind": "enemy", "biome": "Brasier", "level": 110},
	"temple_soleil": {"name": "Temple du Soleil", "kind": "neutral", "biome": "Désert", "level": 100},
	"citadelle_sable": {"name": "Citadelle de Sable", "kind": "enemy", "biome": "Brasier", "level": 120},
	"atelier_cuivre": {"name": "Atelier de Cuivre", "kind": "neutral", "biome": "Rouages", "level": 95},
	"citadelle_engrenages": {"name": "Citadelle des Engrenages", "kind": "enemy", "biome": "Rouages", "level": 115},
}

## Récompense de première annexion : chaque lieu offre un petit butin
## thématique, crédité une seule fois lorsque la ville rejoint l'empire.
const CONQUEST_CITY_REWARDS := {
	"clairiere": {"name": "Réserve des bûcherons", "resources": {"Bois": 12}, "gold": 35},
	"vieille_tour": {"name": "Coffre de la garnison", "resources": {"Fer": 10}, "gold": 55},
	"pont_mousse": {"name": "Péage du vieux pont", "resources": {"Cuir": 8}, "gold": 45},
	"fort_racine": {"name": "Arsenal de Racine", "resources": {"Fer": 16}, "gold": 70},
	"hameau_pin": {"name": "Réserve des montagnards", "resources": {"Bois": 10, "Cuir": 5}, "gold": 45},
	"garnison": {"name": "Dépôt militaire", "resources": {"Fer": 18}, "gold": 80},
	"oasis": {"name": "Cargaison de l'oasis", "resources": {"Venin": 5}, "gold": 90},
	"tour_sable": {"name": "Butin du Dragon des dunes", "resources": {"Magie": 8, "Fer": 8}, "gold": 110},
	"donjon_roi": {"name": "Trésor du Roi Squelette", "resources": {"Magie": 20, "Venin": 15, "Fer": 15}, "gold": 500},
	"village_brume": {"name": "Herbes des brumes", "resources": {"Venin": 8}, "gold": 40},
	"ruines_lierre": {"name": "Reliques du Lierre", "resources": {"Magie": 6}, "gold": 60},
	"abbaye_ronce": {"name": "Offrandes de l'abbaye", "resources": {"Magie": 5, "Bois": 5}, "gold": 55},
	"citadelle_ronce": {"name": "Trésor des Ronces", "resources": {"Fer": 12, "Cuir": 8}, "gold": 95},
	"col_givre": {"name": "Cristaux du col", "resources": {"Magie": 7}, "gold": 65},
	"mine_cristal": {"name": "Filon de cristal", "resources": {"Magie": 12, "Fer": 6}, "gold": 100},
	"bastion_orage": {"name": "Réserves du bastion", "resources": {"Fer": 15, "Bois": 8}, "gold": 100},
	"caravanserail": {"name": "Caisse des marchands", "resources": {"Cuir": 8}, "gold": 120},
	"observatoire": {"name": "Fragments stellaires", "resources": {"Magie": 10}, "gold": 110},
	"port_sable": {"name": "Cargaison des pirates", "resources": {"Cuir": 12, "Venin": 5}, "gold": 140},
	"bois_lune": {"name": "Sève de lune", "resources": {"Bois": 12, "Magie": 4}, "gold": 70},
	"sanctuaire_mousse": {"name": "Reliques du sanctuaire", "resources": {"Magie": 8, "Venin": 4}, "gold": 80},
	"forge_givre": {"name": "Caisse de la forge", "resources": {"Fer": 18, "Magie": 5}, "gold": 130},
	"pic_foudroyant": {"name": "Cœur de foudre", "resources": {"Magie": 12, "Fer": 10}, "gold": 150},
	"marais_spectres": {"name": "Essences spectrales", "resources": {"Venin": 12, "Magie": 5}, "gold": 90},
	"fort_cendre": {"name": "Réserve de cendre", "resources": {"Fer": 20, "Venin": 8}, "gold": 160},
	"temple_soleil": {"name": "Offrande solaire", "resources": {"Magie": 15}, "gold": 150},
	"citadelle_sable": {"name": "Trésor de la Citadelle", "resources": {"Fer": 20, "Cuir": 12, "Magie": 8}, "gold": 220},
	"atelier_cuivre": {"name": "Caisse de pièces détachées", "resources": {"Fer": 14, "Cuir": 6}, "gold": 120},
	"citadelle_engrenages": {"name": "Coffre du Grand Horloger", "resources": {"Fer": 24, "Magie": 10}, "gold": 260},
}

## Routes de la carte : on ne peut attaquer qu'une ville RELIÉE par route à
## son territoire (arbre technologique spatial). Le Donjon n'est relié qu'aux
## trois places fortes : il exige de tenir tout le monde de Zimut.
const CONQUEST_ROUTES: Array = [
	["capitale", "clairiere"], ["capitale", "pont_mousse"],
	["clairiere", "vieille_tour"], ["clairiere", "fort_racine"],
	["vieille_tour", "fort_racine"], ["pont_mousse", "fort_racine"],
	["fort_racine", "hameau_pin"], ["hameau_pin", "garnison"],
	["fort_racine", "oasis"], ["garnison", "tour_sable"], ["oasis", "tour_sable"],
	["clairiere", "village_brume"], ["village_brume", "ruines_lierre"],
	["village_brume", "abbaye_ronce"], ["ruines_lierre", "citadelle_ronce"],
	["abbaye_ronce", "citadelle_ronce"], ["citadelle_ronce", "vieille_tour"],
	["hameau_pin", "col_givre"], ["col_givre", "mine_cristal"],
	["mine_cristal", "garnison"], ["garnison", "bastion_orage"],
	["oasis", "caravanserail"], ["caravanserail", "observatoire"],
	["observatoire", "port_sable"], ["port_sable", "tour_sable"],
	["fort_racine", "donjon_roi"], ["garnison", "donjon_roi"], ["tour_sable", "donjon_roi"],
	# Branches supplémentaires pour étendre la campagne au-delà du premier écran.
	["fort_racine", "bois_lune"], ["bois_lune", "sanctuaire_mousse"],
	["sanctuaire_mousse", "marais_spectres"], ["marais_spectres", "abbaye_ronce"],
	["col_givre", "forge_givre"], ["forge_givre", "pic_foudroyant"],
	["pic_foudroyant", "bastion_orage"], ["oasis", "fort_cendre"],
	["fort_cendre", "temple_soleil"], ["temple_soleil", "citadelle_sable"],
	["citadelle_sable", "port_sable"], ["citadelle_sable", "tour_sable"],
	# V27 : Nation Rouages, au nord-est
	["garnison", "atelier_cuivre"], ["atelier_cuivre", "citadelle_engrenages"], ["citadelle_engrenages", "tour_sable"],
]

## Bâtiments de ressources constructibles dans les villes conquises.
## type -> { label, coûts (ressources), or, production par bataille gagnée }
const CONQUEST_BUILDINGS := {
	"scierie":  {"label": "Scierie",  "cost": {"Bois": 12},               "gold": 40,  "yield": {"Bois": 3}},
	"mine":     {"label": "Mine",     "cost": {"Fer": 12},                "gold": 60,  "yield": {"Fer": 3}},
	"tannerie": {"label": "Tannerie", "cost": {"Cuir": 12},               "gold": 50,  "yield": {"Cuir": 3}},
	"cabane":   {"label": "Cabane des mages", "cost": {"Magie": 8},        "gold": 90,  "yield": {"Magie": 2}},
	"verger":   {"label": "Verger",   "cost": {"Bois": 8, "Venin": 4},    "gold": 70,  "yield": {"Venin": 2}},
	"muraille": {"label": "Muraille (+6 défense)", "cost": {"Fer": 15},     "gold": 60,  "yield": {}},
}
## +1 niveau d'ennemi toutes les N victoires (la difficulté monte doucement)
const DIFFICULTY_CREEP_EVERY := 25

## Niveau de combat par défaut quand aucun n'est connu (combat rapide).
const DEFAULT_FIGHT_LEVEL := 20
const CLASS_ORDER: Array[String] = ["Tank", "Assassin", "Chasseur", "Mage", "Druide", "Heal", "Invocateur", "Sylvain", "Géomancien", "Artificier"]

## Emplacements d'équipement par personnage (clé -> type d'item accepté)
const EQUIP_SLOTS := {
	"arme": ["Arme (1 main)", "Arme (2 mains)", "Épée (1 main)", "Épée (2 mains)",
		"Bâton (1 main)", "Bâton (2 mains)", "Arc", "Hache (1 main)", "Hache (2 mains)"],
	"bouclier": ["Bouclier"],
	"casque": ["Casque", "Chapeau"],
	"armure": ["Armure"],
	"bottes": ["Bottes"],
	"bague": ["Bague", "Anneau", "Accessoire"],
	"collier": ["Collier", "Amulette"],
	"gants": ["Gants"],
	"boucle_oreille": ["Boucle d'oreille"],
	"cape": ["Cape"],
}

var _items_catalog: Array = []   # entrées stuff.txt normalisées
var _class_table: Dictionary = {}   # classe -> { niveau(int) -> ligne }
var _enemy_rows: Array = []         # lignes de ennemis.txt
var _spell_levels: Dictionary = {}  # classe -> [{ "name", "level" }]
var _craft_recipes: Array = []     # lignes de craft.txt normalisées
var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	_rng.randomize()
	_build_level_tables()
	for cid: String in CONQUEST_CITIES.keys():
		ConquestSystem.city_names[cid] = String(CONQUEST_CITIES[cid].get("name", cid))
	_load_items_catalog()
	_load_class_table()
	_load_enemy_rows()
	_load_spell_levels()
	_load_craft_recipes()
	DirAccess.make_dir_recursive_absolute(SAVE_DIR)

# ═══════════════════════════════════════════════════════════════════════════
#  Catalogue d'items (stuff.txt)
# ═══════════════════════════════════════════════════════════════════════════

func _load_items_catalog() -> void:
	_items_catalog = []
	var file := FileAccess.open("res://data/stuff.txt", FileAccess.READ)
	if file == null:
		push_warning("stuff.txt introuvable — catalogue d'items vide")
		return
	var content := file.get_as_text()
	file.close()
	var lines := content.split("\n")
	if lines.size() < 2:
		return
	for i: int in range(1, lines.size()):
		var line: String = lines[i].strip_edges()
		if line.is_empty():
			continue
		var cols := line.split(",")
		if cols.size() < 8:
			continue
		var lvl: int = 1
		if cols.size() > 2:
			lvl = int(cols[2].strip_edges()) if cols[2].strip_edges().is_valid_int() else 1
		_items_catalog.append({
			"type": cols[0].strip_edges(),
			"name": cols[1].strip_edges(),
			"level": lvl,
			"force": _stat(cols, 3),
			"intelligence": _stat(cols, 4),
			"agility": _stat(cols, 5),
			"wisdom": _stat(cols, 6),
			"vita": _stat(cols, 7),
			"defense": _stat(cols, 8),
			"effect": _effect_col(cols),
		})

## L'effet est en colonne 9 ; une ligne mal formée (colonne en trop) le met en 10.
func _effect_col(cols: PackedStringArray) -> String:
	if cols.size() > 10:
		return String(cols[cols.size() - 1].strip_edges())
	return String(cols[9].strip_edges()) if cols.size() > 9 else ""

func _stat(cols: PackedStringArray, idx: int) -> int:
	if cols.size() <= idx:
		return 0
	var v: String = cols[idx].strip_edges()
	return int(v) if v.is_valid_int() else 0

# ═══════════════════════════════════════════════════════════════════════════
#  Gestion des parties (slots)
# ═══════════════════════════════════════════════════════════════════════════

## Liste des parties existantes : [{ "id": int, "name": String, "level": int,
## "victories": int, "timestamp": String }]. Les slots vides sont omis.
func list_saves() -> Array:
	var out: Array = []
	for i: int in range(MAX_SAVES):
		var data := load_save(i)
		if not data.is_empty():
			out.append({
				"id": i,
				"name": String(data.get("name", "Partie %d" % (i + 1))),
				"level": int(data.get("level", START_LEVEL)),
				"victories": int(data.get("victories", 0)),
				"playtime": playtime_total(data),
				"timestamp": String(data.get("timestamp", "")),
			})
	return out

func save_exists(slot: int) -> bool:
	return FileAccess.file_exists(_path(slot))

func _path(slot: int) -> String:
	return "%s/partie_%d.json" % [SAVE_DIR, slot]

func new_game(slot: int, game_name: String = "") -> Dictionary:
	var data := _fresh_save()
	data["name"] = game_name if game_name != "" else "Partie %d" % (slot + 1)
	ensure_roster(data)
	write_save(slot, data)
	return data

func _fresh_save() -> Dictionary:
	return {
		"name": "",
		"level": START_LEVEL,
		"victories": 0,
		"team": [],           # [{ "classe": String, "equipment": {slot -> item} }]
		"inventory": [],      # [{ "type", "name", "level", "rarity", stats... }]
		"resources": {},      # { "Fer": n, "Bois": n, ... } — butin de craft
		"gold": 0,            # pièces d'or (pour le craft)
		"roster": {},         # { classe: { level, xp, invested{}, unspent, auto, spell_levels{} } }
		"balance_v": BALANCE_VERSION,
		"difficulty": 1,      # difficulté des mobs propre à la partie (0 Facile … 3 Enfer)
		"playtime": 0,        # V46 : temps de jeu total en secondes
		"playtime_modes": {}, # V46 : temps de jeu par mode {"tactique": s, "adventure": s, "conquest": s}
		"timestamp": Time.get_datetime_string_from_system(),
	}

func load_save(slot: int) -> Dictionary:
	if not save_exists(slot):
		return {}
	var parsed = _read_json(_path(slot))
	if parsed.is_empty():
		# Fichier principal corrompu : tenter le backup
		parsed = _read_json(_path(slot) + ".bak")
		if parsed.is_empty():
			push_error("Sauvegarde %d illisible (et son backup)" % slot)
			return {}
	# JSON renvoie des floats pour tous les nombres : normaliser en int
	_normalize_ints(parsed, ["level", "victories", "gold", "playtime"])
	ensure_roster(parsed)   # migration des anciennes parties + normalisation
	ensure_playtime(parsed) # V46 : migration du temps de jeu
	return parsed

func _read_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		return {}
	return parsed

func _normalize_ints(d: Dictionary, keys: Array) -> void:
	for k in keys:
		if d.has(k):
			d[k] = int(d[k])

## ── Export / import d'une partie sous forme de code texte (V17) ─────────────
## Le code se colle n'importe où (note, message, mail) pour garder ou transférer
## sa partie : « ZIMUT1: » + base64 du JSON compressé (gzip).
const EXPORT_PREFIX := "ZIMUT1:"
## Extension des fichiers d'export : « .zimut » = fichier texte UTF-8 contenant exactement le code
## « ZIMUT1:<base64 du JSON gzip> ». Le préfixe porte la version du format (ZIMUT2… plus tard).
const EXPORT_EXT := "zimut"

## Nom de fichier sûr à partir d'un pseudo (lettres, chiffres, _ -).
func safe_file_stem(s: String) -> String:
	var out: String = ""
	for ch: String in s.strip_edges():
		out += ch if (ch.unicode_at(0) < 128 and (ch.is_valid_identifier() or ch == "-" or ch.is_valid_int())) else "_"
	return out if out != "" else "partie"

func export_code(data: Dictionary) -> String:
	var raw: PackedByteArray = JSON.stringify(data).to_utf8_buffer()
	return EXPORT_PREFIX + Marshalls.raw_to_base64(raw.compress(FileAccess.COMPRESSION_GZIP))


## Décode un code d'export ; {} si le texte n'est pas un code valide.
func import_code(text: String) -> Dictionary:
	var t: String = text.strip_edges().replace("\n", "").replace("\r", "").replace("\t", "").replace(" ", "")
	var at: int = t.find(EXPORT_PREFIX)
	if at < 0:
		return {}
	var packed: PackedByteArray = Marshalls.base64_to_raw(t.substr(at + EXPORT_PREFIX.length()))
	if packed.is_empty():
		return {}
	var raw: PackedByteArray = packed.decompress_dynamic(64 * 1024 * 1024, FileAccess.COMPRESSION_GZIP)
	var parsed: Variant = JSON.parse_string(raw.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY or not (parsed as Dictionary).has("team"):
		return {}
	return parsed


## Importe un code dans l'emplacement `slot` (écrase son contenu). "" si OK, sinon la raison.
func import_save(slot: int, text: String) -> String:
	var d: Dictionary = import_code(text)
	if d.is_empty():
		return "Code de sauvegarde invalide (il doit commencer par %s)." % EXPORT_PREFIX
	d["slot"] = slot
	_normalize_ints(d, ["level", "victories", "gold", "playtime"])
	ensure_roster(d)
	ensure_playtime(d)   # V46 : migration du temps de jeu
	return "" if write_save(slot, d) else "Écriture impossible."


func write_save(slot: int, data: Dictionary) -> bool:
	if slot < 0 or slot >= MAX_SAVES:
		return false
	data["timestamp"] = Time.get_datetime_string_from_system()
	var path := _path(slot)
	var payload := JSON.stringify(data, "\t")
	# Backup de la version précédente (limité aux 2 backups utiles)
	if FileAccess.file_exists(path):
		DirAccess.copy_absolute(path, path + ".bak")
	# Écriture atomique : d'abord dans un fichier temporaire, puis remplacement
	var tmp := path + ".tmp"
	var file := FileAccess.open(tmp, FileAccess.WRITE)
	if file == null:
		push_error("Impossible d'écrire la sauvegarde %d" % slot)
		return false
	file.store_string(payload)
	file.close()
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	DirAccess.rename_absolute(ProjectSettings.globalize_path(tmp), ProjectSettings.globalize_path(path))
	return true

func delete_save(slot: int) -> void:
	if save_exists(slot):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(_path(slot)))

# ═══════════════════════════════════════════════════════════════════════════
#  Tables de données (classes.txt, ennemis.txt, sorts.txt)
# ═══════════════════════════════════════════════════════════════════════════

func _read_lines(path: String) -> PackedStringArray:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return PackedStringArray()
	var txt: String = f.get_as_text()
	f.close()
	return txt.replace("\r", "").split("\n")

func _load_class_table() -> void:
	_class_table = {}
	var lines: PackedStringArray = _read_lines("res://data/classes.txt")
	for i: int in range(1, lines.size()):
		var c: PackedStringArray = lines[i].strip_edges().split(",")
		if c.size() < 11 or c[0].strip_edges() == "":
			continue
		var classe: String = c[0].strip_edges()
		if not _class_table.has(classe):
			_class_table[classe] = {}
		_class_table[classe][int(c[1])] = {
			"level": int(c[1]), "pa": int(c[2]), "pm": int(c[3]), "vita": int(c[4]),
			"force": int(c[5]), "intelligence": int(c[6]), "agility": int(c[7]),
			"wisdom": int(c[8]), "defense": int(c[9]), "xp": int(c[10]),
		}

func _load_enemy_rows() -> void:
	_enemy_rows = []
	var lines: PackedStringArray = _read_lines("res://data/ennemis.txt")
	for i: int in range(1, lines.size()):
		var c: PackedStringArray = lines[i].strip_edges().split(",")
		if c.size() < 8 or c[0].strip_edges() == "":
			continue
		_enemy_rows.append({"type": c[0].strip_edges(), "level": int(c[1]), "xp": int(c[7]),
			"biome": c[8].strip_edges() if c.size() > 8 else ""})

func _load_spell_levels() -> void:
	_spell_levels = {}
	var lines: PackedStringArray = _read_lines("res://data/sorts.txt")
	for i: int in range(1, lines.size()):
		var c: PackedStringArray = lines[i].strip_edges().split(",")
		if c.size() < 7 or c[0].strip_edges() == "":
			continue
		var classe: String = c[0].strip_edges()
		if not _spell_levels.has(classe):
			_spell_levels[classe] = []
		_spell_levels[classe].append({
			"name": c[1].strip_edges(), "level": int(c[6]),
			"pa": int(c[2]) if c[2].strip_edges().is_valid_int() else 1,
			"pm": int(c[3]) if c[3].strip_edges().is_valid_int() else 0,
			"range": int(c[4]) if c[4].strip_edges().is_valid_int() else 1,
			"effect": c[5].strip_edges(), "type": c[7].strip_edges() if c.size() > 7 else "Attaque",
			"phys": int(c[8]) if c.size() > 8 and c[8].strip_edges().is_valid_int() else 0,
			"mag": int(c[9]) if c.size() > 9 and c[9].strip_edges().is_valid_int() else 0,
			"heal": int(c[10]) if c.size() > 10 and c[10].strip_edges().is_valid_int() else 0,
		})

## Liste des classes jouables (ordre d'affichage).
func class_names() -> Array[String]:
	var out: Array[String] = []
	for c: String in CLASS_ORDER:
		if _class_table.has(c):
			out.append(c)
	for c in _class_table.keys():
		if not out.has(String(c)):
			out.append(String(c))
	return out

## Ligne classes.txt de la classe au niveau donné (le plus proche en dessous).
func class_row(classe: String, level: int) -> Dictionary:
	var rows: Dictionary = _class_table.get(classe, {})
	var best: Dictionary = {}
	var best_lvl: int = -1
	for lv: int in rows.keys():
		if lv <= level and lv > best_lvl:
			best_lvl = lv
			best = rows[lv]
	return best

func xp_for_level(level: int) -> int:
	if level <= 1:
		return 0
	if LEVEL_XP.is_empty():
		_build_level_tables()
	var lv: int = clampi(level, 1, ClassRules.MAX_LEVEL)
	return int(LEVEL_XP[lv])

func level_for_xp(xp: int) -> int:
	var lvl: int = 1
	while lvl < ClassRules.MAX_LEVEL and xp >= xp_for_level(lvl + 1):
		lvl += 1
	return lvl

## XP rapportée par un combat gagné, calibrée sur le niveau du combat :
## XP_PER_COMBAT_BASE × croissance exponentielle, bornée entre
## XP_PER_COMBAT_FLOOR et XP_PER_COMBAT_CEIL pour que le rythme suivi par les
## paliers LEVEL_XP / LEVEL_COMBATS soit respecté de bout en bout.
func combat_xp(fight_level: int) -> int:
	var gain: float = float(_combat_xp_raw(fight_level))
	var settings: Node = get_node_or_null("/root/GameSettings")
	var speed: float = settings.xp_mult() if settings != null else 1.0
	return maxi(1, roundi(gain * ClassRules.FIGHT_XP_MULT * speed))

## Nombre de combats de la frontière estimé pour passer de `level` à `level + 1`.
func combats_for_level(level: int) -> int:
	if LEVEL_COMBATS.is_empty():
		_build_level_tables()
	var lv: int = clampi(level, 1, ClassRules.MAX_LEVEL)
	var need: int = int(LEVEL_COMBATS[lv])
	if need > 0:
		return need
	var step: int = xp_for_level(lv + 1) - xp_for_level(lv)
	if step <= 0:
		return 1
	return maxi(1, int(round(float(step) / float(combat_xp(lv)))))

## Sorts d'une classe (ceux de « Druide » si la classe n'en a aucun, comme en combat).
func spells_of(classe: String) -> Array:
	var l: Array = _spell_levels.get(classe, [])
	if l.is_empty():
		l = _spell_levels.get("Druide", [])
	return l

func spells_unlocked_between(classe: String, from_level: int, to_level: int) -> Array[String]:
	var out: Array[String] = []
	for s: Dictionary in spells_of(classe):
		var lv: int = int(s["level"])
		if lv > from_level and lv <= to_level:
			out.append(String(s["name"]))
	return out

## Prochain déblocage de sort : { "name", "level" } ou {}.
func next_spell(classe: String, level: int) -> Dictionary:
	var best: Dictionary = {}
	for s: Dictionary in spells_of(classe):
		var lv: int = int(s["level"])
		if lv > level and (best.is_empty() or lv < int(best["level"])):
			best = s
	return best

## XP rapportée par un ennemi (ennemis.txt : ligne la plus proche sous son niveau).
func xp_for_enemy(type_name: String, level: int) -> int:
	var best: Dictionary = {}
	var first: Dictionary = {}
	for r: Dictionary in _enemy_rows:
		if r["type"] != type_name:
			continue
		if first.is_empty() or int(r["level"]) < int(first["level"]):
			first = r
		if int(r["level"]) <= level and (best.is_empty() or int(r["level"]) > int(best["level"])):
			best = r
	if best.is_empty():
		best = first
	return int(best.get("xp", 0))

## Biome du combat « numéro n » : cycle global de 16 combats — 12 combats sur les
## 3 biomes (4 chacun), puis 4 salles de donjon : la salle de chaque biome
## (au niveau boss) puis la salle du big boss (Donjon). Le cycle recommence
## ensuite en Forêt avec des ennemis plus forts (la difficulté suit l'équipe).
const CYCLE := 16   # 3 biomes x BOSS_EVERY(4) combats + 4 salles de donjon

func biome_for_fight(n: int) -> String:
	var pos: int = (n - 1) % CYCLE
	if pos < BIOME_ORDER.size() * BOSS_EVERY:
		return BIOME_ORDER[int(pos / BOSS_EVERY)]
	return DONJON_ORDER[pos - BIOME_ORDER.size() * BOSS_EVERY]

## Le combat n se déroule-t-il dans le donjon ?
func in_donjon(n: int) -> bool:
	return biome_for_fight(n) == "Donjon"

## Le combat n est-il la salle du big boss (dernière du cycle) ?
func is_donjon_final(n: int) -> bool:
	return in_donjon(n) and (n - 1) % CYCLE == CYCLE - 1

## Salle du donjon pour le combat n : 1re = Forêt, 2e = Montagne, 3e = Désert,
## 4e = Donjon (big boss). Retourne "" hors donjon.
func donjon_room(n: int) -> String:
	var pos: int = (n - 1) % CYCLE
	if pos < 12:
		return ""
	return DONJON_ORDER[pos - 12]

## Biome du prochain combat d'une partie.
func next_biome(data: Dictionary) -> String:
	return biome_for_fight(next_fight_number(data))

## Nom complet du biome pour affichage.
func biome_label(biome: String) -> String:
	if Nations.is_new(biome):
		return Nations.nation_name(biome)
	return String(BIOME_LABEL.get(biome, biome))

## Types d'ennemis du biome (2 types, cf. BIOME_ENEMIES / ennemis.txt).
func biome_enemy_types(biome: String) -> Array[String]:
	if Nations.is_new(biome):
		return Nations.enemy_types(biome)
	var out: Array[String] = []
	for t: String in BIOME_ENEMIES.get(biome, ["Gobelin", "Squelette"]):
		out.append(t)
	return out

## Boss du biome.
func biome_boss(biome: String) -> String:
	if Nations.is_new(biome):
		return String(Nations.info(biome).get("boss", "Dragonnet"))
	return String(BIOME_BOSSES.get(biome, "Dragonnet"))

## Charge les recettes de craft.txt :
## Type, Nom, Niveau requis, R1, Q1, R2, Q2, R3, Q3, Coût or
func _load_craft_recipes() -> void:
	_craft_recipes = []
	var lines: PackedStringArray = _read_lines("res://data/craft.txt")
	for i: int in range(1, lines.size()):
		var c: PackedStringArray = lines[i].strip_edges().split(",")
		if c.size() < 4 or c[0].strip_edges() == "":
			continue
		var recipe := {
			"type": c[0].strip_edges(),
			"name": c[1].strip_edges(),
			"level": int(c[2]) if c[2].strip_edges().is_valid_int() else 1,
			"gold": int(c[9].strip_edges()) if c.size() > 9 and c[9].strip_edges().is_valid_int() else 0,
			"cost": {},
		}
		for j: int in [3, 5, 7]:
			if c.size() > j + 1:
					var res: String = c[j].strip_edges()
					var qty: int = int(c[j + 1].strip_edges()) if c[j + 1].strip_edges().is_valid_int() else 0
					if res != "" and qty > 0:
							recipe["cost"][res] = qty
		_craft_recipes.append(recipe)

## Recettes disponibles, triées par niveau puis nom.
func craft_recipes() -> Array:
	var out: Array = _craft_recipes.duplicate()
	out.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		if int(a["level"]) != int(b["level"]):
			return int(a["level"]) < int(b["level"])
		return String(a["name"]) < String(b["name"])
	)
	return out

## Stock de ressources d'une partie ({ "Fer": n, ... }).
func resources(data: Dictionary) -> Dictionary:
	return data.get("resources", {})

## Or d'une partie (gagné avec les victoires).
func gold(data: Dictionary) -> int:
	return int(data.get("gold", 0))

## Ajoute des ressources (cumul).
func add_resources(data: Dictionary, drops: Dictionary) -> void:
	var res: Dictionary = data.get("resources", {})
	for k: String in drops.keys():
		res[k] = int(res.get(k, 0)) + int(drops[k])
	data["resources"] = res

## Recette par nom ({} si inconnue).
func craft_recipe(recipe_name: String) -> Dictionary:
	for r: Dictionary in _craft_recipes:
		if String(r["name"]) == recipe_name:
			return r
	return {}

## Objet obtenu en forgeant la recette : stats de stuff.txt (ligne la plus proche en
## dessous du niveau de la recette), qualité RARE (+15 % de stats) — un objet forgé est
## toujours meilleur qu'un objet commun de même niveau.
func forged_item(recipe: Dictionary) -> Dictionary:
	var item: Dictionary = {}
	var best_lvl: int = -1
	for it: Dictionary in _items_catalog:
		if String(it["name"]) != String(recipe["name"]) or String(it["type"]) != String(recipe["type"]):
			continue
		if int(it["level"]) > int(recipe["level"]):
			continue
		if int(it["level"]) > best_lvl:
			best_lvl = int(it["level"])
			item = it
	if item.is_empty():
		for it: Dictionary in _items_catalog:
			if String(it["name"]) == String(recipe["name"]):
				item = it
				break
	if item.is_empty():
		item = {"type": String(recipe["type"]), "name": String(recipe["name"]), "level": int(recipe["level"]),
			"force": 0, "intelligence": 0, "agility": 0, "wisdom": 0, "vita": 0, "defense": 0, "effect": ""}
	return ItemRules.apply_rarity(item.duplicate(), "rare", _rng)

## ── Forge : rangs (1..10), fusion de ressources, amélioration d'équipement ──────────────
## Une ressource a un rang : « Fer » = rang 1, « Fer@2 » = rang 2, etc. Deux ressources de même type
## et de même rang se fondent en une ressource de rang supérieur (FUSE_RATIO pour 1, + frais d'or).
## Un équipement a un rang (1..10) : stats x (1 + RANK_BONUS x (rang - 1)). Fabriquer au rang N
## demande des ressources de rang N ; améliorer N → N+1 demande des ressources de rang N+1.
const MAX_RANK := 10
const RANK_BONUS := 0.12
const FUSE_RATIO := 2
const UPGRADE_QTY := 1
## Ressource principale de chaque emplacement (coût d'amélioration).
const SLOT_MAIN_RES := {"arme": "Fer", "bouclier": "Fer", "casque": "Cuir", "armure": "Cuir", "bottes": "Cuir", "bague": "Magie"}
const RES_TYPES: Array[String] = ["Fer", "Bois", "Cuir", "Magie", "Venin"]


static func res_key(res_name: String, tier: int) -> String:
	return res_name if tier <= 1 else "%s@%d" % [res_name, tier]


func resource_count(data: Dictionary, res_name: String, tier: int = 1) -> int:
	return int(data.get("resources", {}).get(res_key(res_name, tier), 0))


## Or demandé pour fondre vers le rang `target_tier` (10, 20, 40 ... or).
func fuse_gold(target_tier: int) -> int:
	return 10 * (1 << maxi(0, target_tier - 2))


## Fond FUSE_RATIO ressources de rang `tier` en 1 ressource de rang tier+1. Retourne "" si OK.
func fuse_resource(data: Dictionary, res_name: String, tier: int) -> String:
	if not RES_TYPES.has(res_name):
		return "Ressource inconnue."
	if tier < 1 or tier >= MAX_RANK:
		return "Rang maximum atteint."
	var res: Dictionary = data.get("resources", {})
	var k_from: String = res_key(res_name, tier)
	if int(res.get(k_from, 0)) < FUSE_RATIO:
		return "Il faut %d × %s (rang %d)." % [FUSE_RATIO, res_name, tier]
	var gold_cost: int = fuse_gold(tier + 1)
	if int(data.get("gold", 0)) < gold_cost:
		return "Or insuffisant : %d pièces requises." % gold_cost
	res[k_from] = int(res.get(k_from, 0)) - FUSE_RATIO
	var k_to: String = res_key(res_name, tier + 1)
	res[k_to] = int(res.get(k_to, 0)) + 1
	data["resources"] = res
	data["gold"] = int(data.get("gold", 0)) - gold_cost
	progression_changed.emit()
	Achievements.bump(data, "fusions")
	Achievements.check(data)
	return ""


static func rank_mult(rank: int) -> float:
	return 1.0 + RANK_BONUS * float(clampi(rank, 1, MAX_RANK) - 1)


## Applique un rang à un objet (copie des stats de base au premier passage).
static func apply_rank(item: Dictionary, rank: int) -> void:
	rank = clampi(rank, 1, MAX_RANK)
	if not item.has("base_stats"):
		var base: Dictionary = {}
		for k: String in ItemRules.STAT_KEYS:
			if int(item.get(k, 0)) != 0:
				base[k] = int(item[k])
		item["base_stats"] = base
	var mult: float = rank_mult(rank)
	for k: String in item["base_stats"].keys():
		var v: int = int(item["base_stats"][k])
		item[k] = v if rank == 1 else maxi(v + 1, ceili(float(v) * mult - 0.001))
	item["rank"] = rank


## Coût (ressources) d'une recette au rang `tier` : x1 au rang 1, ~1/5 de la quantité ensuite
## (les ressources de rang supérieur valent FUSE_RATIO fois plus).
func craft_cost(recipe: Dictionary, tier: int = 1) -> Dictionary:
	var out: Dictionary = {}
	for k: String in recipe["cost"].keys():
		var q: int = int(recipe["cost"][k])
		if tier > 1:
			q = maxi(1, ceili(float(q) / 5.0))
		out[res_key(k, tier)] = q
	return out


func craft_gold(recipe: Dictionary, tier: int = 1) -> int:
	return int(recipe["gold"]) * maxi(1, tier)


## Objet obtenu en forgeant la recette au rang `tier` (qualité RARE).
func forged_item_ranked(recipe: Dictionary, tier: int = 1) -> Dictionary:
	var item: Dictionary = forged_item(recipe)
	apply_rank(item, tier)
	return item


## État d'une recette pour l'interface : { craftable, missing: {res: n}, gold_missing, cost, gold }.
func craft_status(data: Dictionary, recipe: Dictionary, tier: int = 1) -> Dictionary:
	var res: Dictionary = data.get("resources", {})
	var cost: Dictionary = craft_cost(recipe, tier)
	var missing: Dictionary = {}
	for k: String in cost.keys():
		var lack: int = int(cost[k]) - int(res.get(k, 0))
		if lack > 0:
			missing[k] = lack
	var gold: int = craft_gold(recipe, tier)
	var gold_missing: int = maxi(0, gold - int(data.get("gold", 0)))
	return {"craftable": missing.is_empty() and gold_missing == 0, "missing": missing,
		"gold_missing": gold_missing, "cost": cost, "gold": gold}


## Fabrique l'objet de la recette au rang `tier` : consomme ressources et or, l'objet part
## dans l'inventaire. Retourne "" si OK, sinon la raison.
func craft_item(data: Dictionary, recipe_name: String, tier: int = 1) -> String:
	var recipe: Dictionary = craft_recipe(recipe_name)
	if recipe.is_empty():
		return "Recette inconnue."
	tier = clampi(tier, 1, MAX_RANK)
	var st: Dictionary = craft_status(data, recipe, tier)
	var res: Dictionary = data.get("resources", {})
	for k: String in st["cost"].keys():
		if int(res.get(k, 0)) < int(st["cost"][k]):
			return "Ressource insuffisante : %s (%d/%d)." % [k.replace("@", " rang "), int(res.get(k, 0)), int(st["cost"][k])]
	if int(data.get("gold", 0)) < int(st["gold"]):
		return "Or insuffisant : %d pièces requises." % int(st["gold"])
	for k: String in st["cost"].keys():
		res[k] = int(res.get(k, 0)) - int(st["cost"][k])
	data["resources"] = res
	data["gold"] = int(data.get("gold", 0)) - int(st["gold"])
	data["inventory"].append(forged_item_ranked(recipe, tier))
	data["crafted"] = int(data.get("crafted", 0)) + 1
	progression_changed.emit()
	Achievements.bump(data, "crafted")
	Achievements.set_max(data, "max_rank", tier)
	Achievements.check(data)
	return ""

## Fabrique puis équipe directement sur un membre de l'équipe. Si l'équipement échoue
## (niveau trop bas...), l'objet reste dans l'inventaire : retourne alors la raison.
func craft_and_equip(data: Dictionary, recipe_name: String, member_index: int, tier: int = 1) -> String:
	var err: String = craft_item(data, recipe_name, tier)
	if err != "":
		return err
	var idx: int = data["inventory"].size() - 1
	var eq_err: String = equip_item(data, member_index, idx)
	if eq_err != "":
		return "Objet fabriqué (en inventaire) mais non équipé : %s" % eq_err
	return ""


## Équipements améliorables : portés (équipe) puis inventaire.
## Chaque entrée : { "src": "team"|"inv", "member": i, "slot": s, "index": j, "item": {...} }.
func upgradable_items(data: Dictionary) -> Array:
	var out: Array = []
	var team: Array = data.get("team", [])
	for i: int in range(team.size()):
		var eq: Dictionary = team[i].get("equipment", {})
		for slot: String in eq.keys():
			out.append({"src": "team", "member": i, "slot": slot, "index": -1, "item": eq[slot]})
	var in_team: Array[String] = []
	for m: Dictionary in team:
		in_team.append(String(m.get("classe", "")))
	var roster: Dictionary = data.get("roster", {})
	for cl: String in roster.keys():
		if in_team.has(cl):
			continue
		var eqr: Dictionary = roster[cl].get("equipment", {})
		for slot: String in eqr.keys():
			out.append({"src": "hero", "member": -1, "classe": cl, "slot": slot, "index": -1, "item": eqr[slot]})
	var inv: Array = data.get("inventory", [])
	for j: int in range(inv.size()):
		out.append({"src": "inv", "member": -1, "slot": "", "index": j, "item": inv[j]})
	return out


## Coût d'amélioration d'un objet : { "res": clé, "qty", "gold", "rank", "next" }.
func upgrade_cost(item: Dictionary) -> Dictionary:
	var rank: int = clampi(int(item.get("rank", 1)), 1, MAX_RANK)
	var slot: String = slot_for_type(String(item.get("type", "")))
	var main: String = String(SLOT_MAIN_RES.get(slot, "Magie"))
	var nxt: int = rank + 1
	return {"res": res_key(main, nxt), "res_name": main, "qty": UPGRADE_QTY, "gold": 30 * nxt, "rank": rank, "next": nxt}


## Améliore un objet d'un rang. Retourne "" si OK, sinon la raison.
func upgrade_item(data: Dictionary, entry: Dictionary) -> String:
	var item: Dictionary = {}
	if String(entry.get("src", "")) == "team":
		var team: Array = data.get("team", [])
		var mi: int = int(entry.get("member", -1))
		if mi < 0 or mi >= team.size():
			return "Personnage introuvable."
		item = team[mi].get("equipment", {}).get(String(entry.get("slot", "")), {})
	elif String(entry.get("src", "")) == "hero":
		item = hero_equipment(data, String(entry.get("classe", ""))).get(String(entry.get("slot", "")), {})
	else:
		var inv: Array = data.get("inventory", [])
		var ij: int = int(entry.get("index", -1))
		if ij < 0 or ij >= inv.size():
			return "Objet introuvable."
		item = inv[ij]
	if item.is_empty():
		return "Objet introuvable."
	var c: Dictionary = upgrade_cost(item)
	if int(c["rank"]) >= MAX_RANK:
		return "Rang maximum atteint."
	var res: Dictionary = data.get("resources", {})
	if int(res.get(String(c["res"]), 0)) < int(c["qty"]):
		return "Il faut %d × %s (rang %d)." % [int(c["qty"]), String(c["res_name"]), int(c["next"])]
	if int(data.get("gold", 0)) < int(c["gold"]):
		return "Or insuffisant : %d pièces requises." % int(c["gold"])
	res[String(c["res"])] = int(res.get(String(c["res"]), 0)) - int(c["qty"])
	data["resources"] = res
	data["gold"] = int(data.get("gold", 0)) - int(c["gold"])
	apply_rank(item, int(c["next"]))
	progression_changed.emit()
	Achievements.check(data)
	return ""

# ═══════════════════════════════════════════════════════════════════════════
## ── Niveaux de sorts (1..10) et points de sort ───────────────────────────
## Chaque héros a 10 sorts (3 au niveau 1, les autres débloqués jusqu'au niveau 100).
## Chaque sort peut monter du niveau 1 au niveau 10 : +SPELL_LEVEL_BONUS_PCT par niveau
## sur les dégâts / soins / valeurs d'effet. On gagne 3 points de sort par niveau de héros (297 au niveau 100) ;
## passer un sort du niveau n au niveau n+1 coûte n points (45 pour 1 -> 10). Au niveau 100 : 5 sorts
## au maximum (225 points) + 72 points restants ; les 10 à fond (450) sont impossibles. Remise à zéro GRATUITE.
const SPELL_LEVEL_MAX := 10
const SPELL_LEVEL_BONUS_PCT := 6.0

## Niveau actuel d'un sort pour une classe (1 si jamais amélioré).
func spell_level(data: Dictionary, classe: String, spell_name: String) -> int:
	var e: Dictionary = roster_entry(data, classe)
	var sl: Dictionary = e.get("spell_levels", {})
	return clampi(int(sl.get(spell_name, 1)), 1, SPELL_LEVEL_MAX)

## Multiplicateur d'efficacité du sort selon son niveau (1.0 au niveau 1).
func spell_mult(data: Dictionary, classe: String, spell_name: String) -> float:
	return 1.0 + (float(spell_level(data, classe, spell_name)) - 1.0) * SPELL_LEVEL_BONUS_PCT / 100.0

## Points de sort gagnés au total par un héros de niveau `level`.
func spell_points_total(level: int) -> int:
	return maxi(0, level - 1) * ClassRules.SPELL_POINTS_PER_LEVEL

## Points de sort déjà dépensés (somme des coûts de 1 -> niveau actuel de chaque sort).
func spell_points_spent(data: Dictionary, classe: String) -> int:
	var e: Dictionary = roster_entry(data, classe)
	var spent: int = 0
	for n in e.get("spell_levels", {}).values():
		var lv: int = clampi(int(n), 1, SPELL_LEVEL_MAX)
		spent += (lv - 1) * lv / 2
	return spent

func spell_points_free(data: Dictionary, classe: String) -> int:
	var e: Dictionary = roster_entry(data, classe)
	if e.is_empty():
		return 0
	return maxi(0, spell_points_total(int(e["level"])) - spell_points_spent(data, classe))

## Coût de la prochaine amélioration : { "points": int } ou {} au niveau max.
func spell_upgrade_cost(data: Dictionary, classe: String, spell_name: String) -> Dictionary:
	var lvl: int = spell_level(data, classe, spell_name)
	if lvl >= SPELL_LEVEL_MAX:
		return {}
	return {"points": lvl}

## Niveau de héros requis pour un sort de la classe (0 si inconnu).
func spell_unlock_level(classe: String, spell_name: String) -> int:
	for s: Dictionary in spells_of(classe):
		if String(s["name"]) == spell_name:
			return int(s["level"])
	return 0

## Aperçu d'un sort pour la fenêtre des sorts : { pa, pm, range, kind, target, aoe, zone,
## value (valeur principale au niveau `level`), label (Dégâts / Soin...), desc }.
func spell_preview(classe: String, spell_name: String, level: int) -> Dictionary:
	var row: Dictionary = {}
	for s: Dictionary in spells_of(classe):
		if String(s["name"]) == spell_name:
			row = s
			break
	if row.is_empty():
		return {}
	var spell: Dictionary = {
		"name": spell_name, "classe": classe, "cost_pa": int(row["pa"]), "cost_pm": int(row["pm"]),
		"range": int(row["range"]), "effect": String(row["effect"]), "level_required": int(row["level"]),
		"spell_type": String(row["type"]), "Degats_physiques": int(row["phys"]),
		"Degats_magiques": int(row["mag"]), "Soins": int(row["heal"]),
	}
	var p: Dictionary = Combat.parse(spell)
	var base: int = 0
	var label: String = ""
	match String(p["kind"]):
		"attack":
			base = maxi(int(p["dmg"]), int(p["adj_dmg"]))
			label = "Dégâts"
		"heal":
			base = int(p["heal"]) if int(p["heal"]) > 0 else int(p["regen"])
			label = "Soin"
		"trap":
			base = int(p["trap"])
			label = "Dégâts du piège"
		"glyph":
			var gf: Dictionary = p["glyph_foes"]
			if not gf.is_empty():
				base = int(gf["dmg"])
				label = "Dégâts du glyphe"
	if base == 0:
		for d: Dictionary in p.get("dots", []):
			base = int(float(d["value"]))
			label = "Dégâts par tour"
	var mult: float = 1.0 + (float(clampi(level, 1, SPELL_LEVEL_MAX)) - 1.0) * SPELL_LEVEL_BONUS_PCT / 100.0
	return {"pa": int(row["pa"]), "pm": int(row["pm"]), "range": int(row["range"]), "kind": String(p["kind"]),
		"target": String(p["target"]), "aoe": String(p["aoe"]), "zone": int(p["zone_r"]),
		"los": bool(p["needs_los"]), "value": roundi(float(base) * mult), "base_value": base, "label": label,
		"mult": mult, "desc": Combat.describe(spell), "type": String(row["type"]), "req": int(row["level"])}

## Améliore un sort d'un niveau (coûte `niveau actuel` points de sort). "" si OK, sinon la raison.
func upgrade_spell(data: Dictionary, classe: String, spell_name: String) -> String:
	var cost: Dictionary = spell_upgrade_cost(data, classe, spell_name)
	if cost.is_empty():
		return "Niveau maximum atteint."
	var e: Dictionary = roster_entry(data, classe)
	if e.is_empty():
		return "Héros inconnu."
	if int(e["level"]) < spell_unlock_level(classe, spell_name):
		return "Sort pas encore débloqué."
	if spell_points_free(data, classe) < int(cost["points"]):
		return "Points de sort insuffisants : %d requis." % int(cost["points"])
	var sl: Dictionary = e.get("spell_levels", {})
	sl[spell_name] = clampi(int(sl.get(spell_name, 1)) + 1, 1, SPELL_LEVEL_MAX)
	e["spell_levels"] = sl
	e["spell_auto"] = false
	progression_changed.emit()
	return ""

## Retire un niveau d'un sort et rend ses points (gratuit).
func downgrade_spell(data: Dictionary, classe: String, spell_name: String) -> String:
	var e: Dictionary = roster_entry(data, classe)
	var sl: Dictionary = e.get("spell_levels", {})
	var lvl: int = clampi(int(sl.get(spell_name, 1)), 1, SPELL_LEVEL_MAX)
	if lvl <= 1:
		return "Rien à retirer."
	sl[spell_name] = lvl - 1
	e["spell_levels"] = sl
	e["spell_auto"] = false
	progression_changed.emit()
	return ""

## Remise à zéro GRATUITE de tous les points de sort d'un héros.
func reset_spells(data: Dictionary, classe: String) -> void:
	var e: Dictionary = roster_entry(data, classe)
	if e.is_empty():
		return
	e["spell_levels"] = {}
	e["spell_auto"] = false
	progression_changed.emit()


## Répartition AUTOMATIQUE des points de sort : on monte d'abord les sorts de dégâts et
## de soin (les moins avancés en premier, puis les plus récents), ensuite les autres.
## Les points gagnés plus tard sont aussi répartis (e["spell_auto"]). Renvoie le nombre
## de niveaux de sort achetés.
func auto_spells(data: Dictionary, classe: String) -> int:
	var e: Dictionary = roster_entry(data, classe)
	if e.is_empty():
		return 0
	e["spell_auto"] = true
	var lvl: int = int(e["level"])
	var cands: Array = []
	for row: Dictionary in spells_of(classe):
		if int(row["level"]) > lvl:
			continue
		var pv: Dictionary = spell_preview(classe, String(row["name"]), 1)
		var main: bool = String(pv.get("kind", "")) in ["attack", "heal", "trap", "glyph"] and int(pv.get("base_value", 0)) > 0
		cands.append({"name": String(row["name"]), "main": main, "req": int(row["level"])})
	var bought: int = 0
	while true:
		var free: int = spell_points_free(data, classe)
		var best: Dictionary = {}
		var best_key: Array = []
		for c: Dictionary in cands:
			var cost: Dictionary = spell_upgrade_cost(data, classe, String(c["name"]))
			if cost.is_empty() or int(cost["points"]) > free:
				continue
			# clé de tri : sorts principaux d'abord, puis niveau le plus bas, puis le plus récent
			var key: Array = [0 if bool(c["main"]) else 1, spell_level(data, classe, String(c["name"])), -int(c["req"])]
			if best.is_empty() or key < best_key:
				best = c
				best_key = key
		if best.is_empty():
			break
		var sl: Dictionary = e.get("spell_levels", {})
		sl[String(best["name"])] = spell_level(data, classe, String(best["name"])) + 1
		e["spell_levels"] = sl
		bought += 1
	progression_changed.emit()
	return bought

#  Roster : progression de chaque classe
# ═══════════════════════════════════════════════════════════════════════════

func _new_entry(level: int) -> Dictionary:
	return {"level": level, "xp": xp_for_level(level), "invested": {},
		"unspent": ClassRules.total_points_for_level(level), "auto": true,
		"spell_levels": {}}

## Garantit que la sauvegarde contient un roster complet et cohérent (migration
## des anciennes parties incluse). Appelé au chargement.
## Anciens noms d'invocations -> nouveaux (sprites V15d).
const SPELL_RENAMES := {
	"Invoquer Tortue": "Invoquer Golem de Pierre", "Invoquer Loup": "Invoquer Loup Spectral",
	"Invoquer Sirène": "Invoquer Requin des Marées", "Invoquer Ange": "Invoquer Élémentaire de Cristal",
	"Invoquer Homme-Faucon": "Invoquer Ombre", "Invoquer Centaure": "Invoquer Esprit de la Forêt",
	"Invoquer Buisson": "Invoquer Archer Sylvestre", "Invoquer Champignon": "Invoquer Ent de Combat",
	# V19 : sorts transformés en glyphes
	"Armure de grès": "Glyphe de grès", "Invoquer Faille": "Glyphe sismique", "Piège": "Glyphe d'entrave",
	"Fleche enflammée": "Glyphe de flammes", "Marque de la mort": "Glyphe de venin", "Invisibilité": "Glyphe d'ombre",
}


## Renomme les clés de sorts d'une sauvegarde existante (spell_levels, sorts mémorisés...).
func _rename_spells(node: Variant) -> void:
	if typeof(node) == TYPE_DICTIONARY:
		var d: Dictionary = node
		for k in d.keys():
			if typeof(k) == TYPE_STRING and SPELL_RENAMES.has(k):
				d[SPELL_RENAMES[k]] = d[k]
				d.erase(k)
		for k in d.keys():
			var v: Variant = d[k]
			if typeof(v) == TYPE_STRING and SPELL_RENAMES.has(v):
				d[k] = SPELL_RENAMES[v]
			else:
				_rename_spells(v)
	elif typeof(node) == TYPE_ARRAY:
		var a: Array = node
		for i: int in range(a.size()):
			if typeof(a[i]) == TYPE_STRING and SPELL_RENAMES.has(a[i]):
				a[i] = SPELL_RENAMES[a[i]]
			else:
				_rename_spells(a[i])


func ensure_roster(data: Dictionary) -> void:
	if data.is_empty():
		return
	_rename_spells(data)
	var migrate: bool = int(data.get("balance_v", 0)) < BALANCE_VERSION and data.has("roster")
	var legacy_level: int = clampi(int(data.get("level", START_LEVEL)), START_LEVEL, 50)
	if int(data.get("balance_v", 0)) >= BALANCE_VERSION:
		legacy_level = clampi(int(data.get("level", START_LEVEL)), START_LEVEL, ClassRules.MAX_LEVEL)
	else:
		legacy_level = level_from_old(legacy_level)
	var fresh: bool = not data.has("roster")
	var roster: Dictionary = data.get("roster", {})
	if migrate:
		_migrate_balance(data, roster)
	var team_classes: Array[String] = []
	for m: Dictionary in data.get("team", []):
		team_classes.append(String(m.get("classe", "")))
	for classe: String in class_names():
		if not roster.has(classe):
			var lvl: int = START_LEVEL
			if not fresh:
				lvl = maxi(START_LEVEL, _roster_average(roster, team_classes) - 2)
			elif team_classes.has(classe):
				lvl = legacy_level   # ancienne partie : l'équipe rattrape le niveau des ennemis
			var e: Dictionary = _new_entry(lvl)
			e["unspent"] = ClassRules.auto_allocate(classe, e["invested"], int(e["unspent"]))
			roster[classe] = e
		var ent: Dictionary = roster[classe]
		ent["level"] = clampi(int(ent.get("level", START_LEVEL)), 1, ClassRules.MAX_LEVEL)
		ent["xp"] = int(ent.get("xp", xp_for_level(int(ent["level"]))))
		# V42 : entrée de l'arbre de talents par personnage (rétroactive)
		if not ent.has("talents"):
			ent["talents"] = {"unlocked": {}, "points": TalentTree.power_for_level(int(ent["level"]))}
		ent["unspent"] = int(ent.get("unspent", 0))
		ent["auto"] = bool(ent.get("auto", true))
		var inv: Dictionary = ent.get("invested", {})
		for k in inv.keys():
			inv[k] = int(inv[k])
		ent["invested"] = inv
		if not ent.has("spell_levels"):
			ent["spell_levels"] = {}
		# V42 : builds par personnage (rétroactif : liste vide, sorts actifs par défaut)
		Builds.ensure(data, classe)
	data["roster"] = roster
	data["balance_v"] = BALANCE_VERSION
	if not data.has("difficulty"):
		# Anciennes parties : reprend le réglage global qui existait avant (Options).
		var gs: Node = get_node_or_null("/root/GameSettings")
		data["difficulty"] = int(gs.difficulty) if gs != null else 1
	data["level"] = frontier_level(data)

## Conversion d'une sauvegarde d'avant l'équilibrage V15 : niveaux 1..50 -> 1..100,
## capital de points conservé (mêmes choix du joueur), points de sorts remis à zéro
## (les sorts ont changé), historique des niveaux de combat converti.
func _migrate_balance(data: Dictionary, roster: Dictionary) -> void:
	for classe in roster.keys():
		var ent: Dictionary = roster[classe]
		var new_lvl: int = level_from_old(clampi(int(ent.get("level", 1)), 1, 50))
		ent["level"] = new_lvl
		ent["xp"] = xp_for_level(new_lvl)
		var inv: Dictionary = ent.get("invested", {})
		var spent: int = 0
		for stat in inv.keys():
			spent += ClassRules.cost_between(String(classe), String(stat), 0, int(inv[stat]))
		ent["unspent"] = maxi(0, ClassRules.total_points_for_level(new_lvl) - spent)
		ent["spell_levels"] = {}
		if bool(ent.get("auto", true)):
			ent["unspent"] = ClassRules.auto_allocate(String(classe), inv, int(ent["unspent"]))
		ent["invested"] = inv
	var hist: Array = data.get("fight_levels", [])
	for i: int in range(hist.size()):
		hist[i] = level_from_old(clampi(int(hist[i]), 1, 50))
	data["fight_levels"] = hist
	data["balance_v"] = BALANCE_VERSION

func _roster_average(roster: Dictionary, classes: Array[String]) -> int:
	var tot: int = 0
	var n: int = 0
	for c: String in classes:
		if roster.has(c):
			tot += int(roster[c].get("level", START_LEVEL))
			n += 1
	return roundi(float(tot) / float(n)) if n > 0 else START_LEVEL

func roster_entry(data: Dictionary, classe: String) -> Dictionary:
	if not data.has("roster") or not data["roster"].has(classe):
		ensure_roster(data)
	return data.get("roster", {}).get(classe, {})

func member_level(data: Dictionary, classe: String) -> int:
	var e: Dictionary = roster_entry(data, classe)
	return int(e.get("level", START_LEVEL)) if not e.is_empty() else START_LEVEL

## Niveau minimum (au moins un héros de ce niveau) pour jouer chaque mode.
const MODE_MIN_LEVEL := {"tactique": 1, "adventure": 3, "conquest": 5}

## Plus haut niveau parmi tous les héros de la partie.
func max_hero_level(data: Dictionary) -> int:
	var best: int = START_LEVEL
	for e: Variant in (data.get("roster", {}) as Dictionary).values():
		if e is Dictionary:
			best = maxi(best, int((e as Dictionary).get("level", START_LEVEL)))
	return best


func mode_unlocked(data: Dictionary, mode: String) -> bool:
	return max_hero_level(data) >= int(MODE_MIN_LEVEL.get(mode, 1))

## ── Temps de jeu (V46) ───────────────────────────────────────────────
## Stocké dans la sauvegarde : "playtime" (total, secondes) et
## "playtime_modes" ({mode -> secondes}). Les anciennes parties sans ces
## champs sont migrées au chargement (ensure_playtime, appelé par ensure_roster).

## Migration rétroactive : ajoute les champs de temps de jeu s'ils manquent.
func ensure_playtime(data: Dictionary) -> void:
	if data.is_empty():
		return
	_normalize_ints(data, ["playtime"])
	if not data.has("playtime") or typeof(data["playtime"]) != TYPE_INT:
		data["playtime"] = 0
	if not data.has("playtime_modes") or typeof(data["playtime_modes"]) != TYPE_DICTIONARY:
		data["playtime_modes"] = {}

## Temps de jeu total en secondes (migré si absent).
func playtime_total(data: Dictionary) -> int:
	if data.is_empty():
		return 0
	if not data.has("playtime"):
		return 0
	return maxi(0, int(data["playtime"]))

## Temps de jeu d'un mode ("tactique", "adventure" ou "conquest") en secondes.
func playtime_mode(data: Dictionary, mode: String) -> int:
	if data.is_empty() or not data.has("playtime_modes"):
		return 0
	var modes: Dictionary = data["playtime_modes"]
	if not modes.has(mode):
		return 0
	return maxi(0, int(modes[mode]))

## Ajoute `seconds` au total et au compteur du mode, en écrivant la sauvegarde.
func add_playtime(slot: int, data: Dictionary, mode: String, seconds: float) -> void:
	if slot < 0 or data.is_empty() or seconds <= 0.0:
		return
	ensure_playtime(data)
	data["playtime"] = playtime_total(data) + int(round(seconds))
	var modes: Dictionary = data["playtime_modes"]
	modes[mode] = playtime_mode(data, mode) + int(round(seconds))
	data["playtime_modes"] = modes
	write_save(slot, data)

## Formate un temps en secondes : "45 s", "12 min", "3 h 05". Toujours en
## français dans le code ; la traduction passe par en.txt (mot "min"/"h").
static func format_playtime(seconds: int) -> String:
	var s: int = maxi(0, seconds)
	if s < 60:
		return "%d s" % s
	var mins: int = s / 60
	if mins < 60:
		return "%d min" % mins
	return "%d h %02d" % [mins / 60, mins % 60]


func team_average_level(data: Dictionary) -> int:
	var classes: Array[String] = []
	for m: Dictionary in data.get("team", []):
		classes.append(String(m.get("classe", "")))
	if classes.is_empty() or not data.has("roster"):
		return START_LEVEL
	return _roster_average(data["roster"], classes)

## Niveau des ennemis du prochain combat : niveau moyen de l'équipe (+1 toutes les
## DIFFICULTY_CREEP_EVERY victoires).
func frontier_level(data: Dictionary) -> int:
	var lvl: int = team_average_level(data) + int(data.get("victories", 0)) / DIFFICULTY_CREEP_EVERY
	return clampi(lvl, 1, ClassRules.ENEMY_MAX_LEVEL)

## Niveau des ennemis du combat SÉLECTIONNÉ : le combat de la « frontière » (premier non gagné)
## s'adapte à l'équipe ; un combat déjà gagné rejoué garde le niveau auquel il a été gagné.
func enemy_level_for(data: Dictionary) -> int:
	return fight_level_of(data, selected_fight_number(data))

## Premier combat non encore gagné.
func frontier_fight_number(data: Dictionary) -> int:
	return int(data.get("victories", 0)) + 1

## Combat choisi par le joueur (0 / invalide = la frontière).
func selected_fight_number(data: Dictionary) -> int:
	var frontier: int = frontier_fight_number(data)
	var sel: int = int(data.get("selected_fight", 0))
	if sel < 1 or sel >= frontier:
		return frontier
	return sel

## Choisit le combat à jouer (1..frontière). Retourne le numéro retenu.
func select_fight(data: Dictionary, n: int) -> int:
	var frontier: int = frontier_fight_number(data)
	n = clampi(n, 1, frontier)
	data["selected_fight"] = 0 if n == frontier else n
	return n

## Niveau des ennemis du combat n (historique des combats gagnés, sinon estimation).
func fight_level_of(data: Dictionary, n: int) -> int:
	var frontier: int = frontier_fight_number(data)
	if n >= frontier:
		return frontier_level(data)
	var hist: Array = data.get("fight_levels", [])
	if n >= 1 and n <= hist.size():
		return clampi(int(hist[n - 1]), 1, ClassRules.ENEMY_MAX_LEVEL)
	return clampi(frontier_level(data) - (frontier - n) / 4, 1, ClassRules.ENEMY_MAX_LEVEL)

## Facteur d'XP selon l'écart entre le niveau du combat et celui du perso :
## combat plus bas = moins d'XP (rejouer sert à farmer les objets), plus haut = bonus.
func xp_level_factor(fight_level: int, member_level: int) -> float:
	return clampf(1.0 + float(fight_level - member_level) * 0.10, 0.10, 1.25)

## Statistiques finales d'un membre d'équipe : base (classes.txt au niveau du perso)
## + points investis + équipement (+ panoplies) + paliers PA/PM.
## PA plafonnés à 14, PM à 6 et PO à 3, quelles que soient les sources.
func member_stats(data: Dictionary, member: Dictionary) -> Dictionary:
	var classe: String = String(member.get("classe", ""))
	var ent: Dictionary = roster_entry(data, classe)
	var level: int = int(ent.get("level", START_LEVEL))
	var row: Dictionary = class_row(classe, level)
	if row.is_empty():
		return {}
	var inv: Dictionary = ent.get("invested", {})
	var agg: Dictionary = ItemRules.aggregate(member.get("equipment", {}))
	var eq: Dictionary = agg["stats"]
	var ms: Dictionary = ClassRules.milestone_bonus(classe, level)
	var fx: Dictionary = agg["fx"]
	# V27 : Pierres Élémentaires portées par le héros (stats + effets)
	var sb: Dictionary = Stones.hero_bonus(data, classe)
	for sk: String in sb["stats"].keys():
		eq[sk] = int(eq.get(sk, 0)) + int(sb["stats"][sk])
	ItemRules.merge_fx(fx, sb["fx"])
	# V42 : bonus de l'arbre de talents DU HÉROS (stocké dans le roster)
	var tb: Dictionary = TalentTree.total_bonus(data, classe)
	var pv_pct: float = 1.0 + float(tb.get("pv_pct", 0)) / 100.0
	var def_pct: float = 1.0 + float(tb.get("def_pct", 0)) / 100.0
	var dmg_pct: float = 1.0 + float(tb.get("dmg_pct", 0)) / 100.0
	var heal_pct: float = 1.0 + float(tb.get("heal_pct", 0)) / 100.0
	var crit_pct: float = float(tb.get("crit_pct", 0))
	var out: Dictionary = {
		"classe": classe, "level": level,
		"max_pv": roundi(float(int(row["vita"]) + int(inv.get("vita", 0)) * int(ClassRules.STAT_GAIN["vita"]) + int(eq["vita"])) * pv_pct),
		"pa": mini(ClassRules.PA_CAP, int(row["pa"]) + int(ms["pa"]) + int(inv.get("pa", 0)) + int(fx.get("pa", 0)) + int(tb.get("pa", 0))),
		"pm": mini(ClassRules.PM_CAP, int(row["pm"]) + int(ms["pm"]) + int(inv.get("pm", 0)) + int(fx.get("pm", 0)) + int(tb.get("pm", 0))),
		"po": mini(ClassRules.PO_CAP, int(inv.get("po", 0)) + int(fx.get("po", 0))),
		"fx": fx, "sets": agg["sets"],
		"talent_dmg_pct": dmg_pct, "talent_heal_pct": heal_pct, "talent_crit_pct": crit_pct,
		"talent_def_pct": def_pct, "talent_revive_pct": int(tb.get("revive_pct", 0)),
	}
	for k: String in ["force", "intelligence", "agility", "wisdom"]:
		out[k] = int(row[k]) + int(inv.get(k, 0)) + int(eq[k])
	out["defense"] = roundi(float(int(row["defense"]) + int(inv.get("defense", 0)) + int(eq["defense"])) * def_pct)
	return out

## Investit 1 point de capital dans `stat`. Retourne "" si OK, sinon la raison.
func invest_point(data: Dictionary, classe: String, stat: String) -> String:
	var e: Dictionary = roster_entry(data, classe)
	if e.is_empty() or not (ClassRules.STATS.has(stat) or ClassRules.BONUS_STATS.has(stat)):
		return "Statistique inconnue."
	if ClassRules.BONUS_STATS.has(stat) and int(e["invested"].get(stat, 0)) >= ClassRules.BONUS_MAX_LEVELS:
		return "Maximum %d niveaux de %s." % [ClassRules.BONUS_MAX_LEVELS, ClassRules.BONUS_STAT_LABEL[stat]]
	var cost: int = ClassRules.point_cost(classe, stat, int(e["invested"].get(stat, 0)))
	if int(e["unspent"]) < cost:
		return "Capital insuffisant (%d requis)." % cost
	e["invested"][stat] = int(e["invested"].get(stat, 0)) + 1
	e["unspent"] = int(e["unspent"]) - cost
	e["auto"] = false
	return ""

## Retire 1 point investi et le rembourse.
func refund_point(data: Dictionary, classe: String, stat: String) -> String:
	var e: Dictionary = roster_entry(data, classe)
	if e.is_empty() or int(e["invested"].get(stat, 0)) <= 0:
		return "Rien à retirer."
	var n: int = int(e["invested"][stat])
	e["unspent"] = int(e["unspent"]) + ClassRules.point_cost(classe, stat, n - 1)
	e["invested"][stat] = n - 1
	e["auto"] = false
	return ""

## Rend tout le capital (respec gratuit) ; la classe repasse en répartition manuelle.
func reset_points(data: Dictionary, classe: String) -> void:
	var e: Dictionary = roster_entry(data, classe)
	if e.is_empty():
		return
	e["invested"] = {}
	e["unspent"] = ClassRules.total_points_for_level(int(e["level"]))
	e["auto"] = false

## Répartition automatique du capital restant ; les prochains niveaux seront aussi auto-répartis.
func auto_points(data: Dictionary, classe: String) -> void:
	var e: Dictionary = roster_entry(data, classe)
	if e.is_empty():
		return
	e["unspent"] = ClassRules.auto_allocate(classe, e["invested"], int(e["unspent"]))
	e["auto"] = true

# ═══════════════════════════════════════════════════════════════════════════
#  XP
# ═══════════════════════════════════════════════════════════════════════════

## XP brute d'un combat à partir de la liste des ennemis [{type, level, boss}].
func fight_xp(enemies: Array, fight_level: int = 0) -> int:
	var total: float = 0.0
	for e: Dictionary in enemies:
		var xp: float = float(xp_for_enemy(String(e.get("type", "")), int(e.get("level", 1))))
		if bool(e.get("boss", false)):
			xp *= ClassRules.BOSS_XP_MULT
		total += xp
	var xp_cap: int = combat_xp(fight_level if fight_level > 0 else DEFAULT_FIGHT_LEVEL)
	return mini(roundi(total * ClassRules.FIGHT_XP_MULT), xp_cap)

## Distribue l'XP à toute la roster. Retourne le rapport par classe :
## { classe: { gain, from_level, to_level, points, spells, in_team } }
func award_xp(data: Dictionary, raw_xp: int, ratio: float = 1.0, fight_level: int = 0) -> Dictionary:
	ensure_roster(data)
	var team_classes: Array[String] = []
	for m: Dictionary in data.get("team", []):
		team_classes.append(String(m.get("classe", "")))
	var avg: int = team_average_level(data)
	var report: Dictionary = {}
	for classe: String in data["roster"].keys():
		var e: Dictionary = data["roster"][classe]
		var in_team: bool = team_classes.has(classe)
		var gain: float = float(raw_xp) * ratio * ClassRules.xp_mult(classe)
		if fight_level > 0:
			gain *= xp_level_factor(fight_level, int(e["level"]))
		if not in_team:
			gain *= ClassRules.BENCH_XP_RATIO   # classes hors équipe : 10 % de l'XP
		var g: int = roundi(gain)
		var from_lvl: int = int(e["level"])
		e["xp"] = int(e["xp"]) + g
		var to_lvl: int = mini(ClassRules.MAX_LEVEL, level_for_xp(int(e["xp"])))
		var pts: int = 0
		if to_lvl > from_lvl:
			pts = (to_lvl - from_lvl) * ClassRules.POINTS_PER_LEVEL
			e["unspent"] = int(e["unspent"]) + pts
			e["level"] = to_lvl
			# V42 : paliers de l'arbre de talents (1 point de pouvoir tous les 5 niveaux à partir du niveau 15)
			TalentTree.apply_level_up(data, classe, from_lvl, to_lvl)
			# V43 : les sorts qui se débloquent comblent les places libres du build actif
			Builds.on_level_up(data, classe, from_lvl, to_lvl)
			if bool(e.get("auto", true)):
				e["unspent"] = ClassRules.auto_allocate(classe, e["invested"], int(e["unspent"]))
			if bool(e.get("spell_auto", false)):
				auto_spells(data, classe)
		report[classe] = {"gain": g, "from_level": from_lvl, "to_level": to_lvl, "points": pts,
			"spells": spells_unlocked_between(classe, from_lvl, to_lvl), "in_team": in_team,
			"xp": int(e["xp"]), "xp_next": xp_for_level(mini(ClassRules.MAX_LEVEL, to_lvl + 1)),
			"xp_cur": xp_for_level(to_lvl)}
	return report

# ═══════════════════════════════════════════════════════════════════════════
#  Victoire / défaite : progression + loots
# ═══════════════════════════════════════════════════════════════════════════

## À appeler après une victoire : XP pour tout le monde, 1-4 loots avec rareté.
## info (facultatif) : { "enemies": [{type, level, boss}], "turns": int, "boss": bool }
## Retourne la sauvegarde mise à jour (à écrire ensuite) ou {} si pas de partie active.
# ═══════════════════════════════════════════════════════════════════════════
#  V18 : objectifs de combat et synergies de classes
# ═══════════════════════════════════════════════════════════════════════════

## Duos de classes : bonus appliqué à toute l'équipe au début du combat.
## [classe A, classe B, nom, statut, valeur (%), description]
const SYNERGIES: Array = [
	["Tank", "Heal", "Rempart béni", "def_up", 10.0, "+10 % de défense pour l'équipe"],
	["Mage", "Géomancien", "Arcanes telluriques", "dmg_up", 10.0, "+10 % de dégâts pour l'équipe"],
	["Chasseur", "Assassin", "Traque", "dmg_up", 8.0, "+8 % de dégâts pour l'équipe"],
	["Druide", "Sylvain", "Cercle de la forêt", "mres_up", 12.0, "+12 % de résistance magique pour l'équipe"],
	["Invocateur", "Druide", "Pacte sauvage", "def_up", 8.0, "+8 % de défense pour l'équipe"],
	["Tank", "Mage", "Garde arcanique", "mres_up", 10.0, "+10 % de résistance magique pour l'équipe"],
	["Artificier", "Tank", "Ligne fortifiée", "def_up", 10.0, "+10 % de défense pour l'équipe"],
	["Artificier", "Chasseur", "Tir croisé", "dmg_up", 8.0, "+8 % de dégâts pour l'équipe"],
]

## Trios de classes (V42) : bonus plus puissant quand les 3 classes sont réunies.
## [classe A, classe B, classe C, nom, statut, valeur (%), description]
const SYNERGY_TRIOS: Array = [
	["Tank", "Mage", "Druide", "Égide arcanique", "def_up", 15.0, "+15 % de défense pour l'équipe"],
	["Tank", "Heal", "Artificier", "Bastion vivant", "def_up", 12.0, "+12 % de défense pour l'équipe"],
	["Assassin", "Chasseur", "Sylvain", "Meute", "dmg_up", 12.0, "+12 % de dégâts pour l'équipe"],
	["Mage", "Druide", "Invocateur", "Cercle ancien", "mres_up", 15.0, "+15 % de résistance magique pour l'équipe"],
	["Tank", "Chasseur", "Heal", "Ligne de front", "dmg_up", 10.0, "+10 % de dégâts pour l'équipe"],
	["Artificier", "Géomancien", "Invocateur", "Forge élémentaire", "dmg_up", 12.0, "+12 % de dégâts pour l'équipe"],
	["Assassin", "Mage", "Géomancien", "Assaut mystique", "dmg_up", 15.0, "+15 % de dégâts pour l'équipe"],
	["Druide", "Sylvain", "Heal", "Bénédiction sylvestre", "mres_up", 12.0, "+12 % de résistance magique pour l'équipe"],
]


## Synergies de trio actives pour une liste de classes.
func active_synergy_trios(classes: Array) -> Array:
	var out: Array = []
	for sy: Array in SYNERGY_TRIOS:
		if classes.has(String(sy[0])) and classes.has(String(sy[1])) and classes.has(String(sy[2])):
			out.append({"name": String(sy[3]), "status": String(sy[4]), "value": float(sy[5]),
				"desc": String(sy[6]), "trio": "%s + %s + %s" % [sy[0], sy[1], sy[2]]})
	return out


## Synergies actives pour une liste de classes : [{name, status, value, desc, pair}]
func active_synergies(classes: Array) -> Array:
	var out: Array = []
	for sy: Array in SYNERGIES:
		if classes.has(String(sy[0])) and classes.has(String(sy[1])):
			out.append({"name": String(sy[2]), "status": String(sy[3]), "value": float(sy[4]),
				"desc": String(sy[5]), "pair": "%s + %s" % [sy[0], sy[1]]})
	return out


const OBJECTIVE_SWIFT_TURNS := 4

## Objectif du prochain combat (modes Tactique et Aventure ; la Conquête a ses propres défis).
## Déterministe : le même tant que le combat n'est pas joué.
func combat_objective(data: Dictionary) -> Dictionary:
	if data.is_empty() or String(data.get("campaign_mode", "")) == "conquest":
		return {}
	var n: int = int(data.get("victories", 0)) + int(data.get("replays", 0)) + int(data.get("defeats", 0))
	var h: int = absi(("%d:%s" % [n, String(data.get("name", ""))]).hash())
	var kinds: Array = ["swift", "flawless", "chief", "no_heal", "all_hit"]
	var kind: String = String(kinds[h % kinds.size()])
	var lvl: int = enemy_level_for(data)
	var res_name: String = String(RES_TYPES[(h / 7) % RES_TYPES.size()])
	var out: Dictionary = {"kind": kind, "gold": 30 + 5 * lvl, "resources": {res_key(res_name, 2): 1 + lvl / 20}}
	match kind:
		"swift":
			out["label"] = "Gagner en %d tours ou moins" % OBJECTIVE_SWIFT_TURNS
		"flawless":
			out["label"] = "Gagner sans qu'aucun héros ne tombe"
		"chief":
			out["label"] = "Vaincre le chef (l'ennemi le plus résistant) en premier"
		"no_heal":
			out["label"] = "Gagner sans aucun soin"
		"all_hit":
			out["label"] = "Chaque héros inflige des dégâts"
	out["reward_text"] = "+%d or · +%d %s R2" % [int(out["gold"]), 1 + lvl / 20, res_name]
	return out


func _objective_met(obj: Dictionary, info: Dictionary) -> bool:
	match String(obj.get("kind", "")):
		"swift":
			return int(info.get("turns", 99)) <= OBJECTIVE_SWIFT_TURNS
		"flawless":
			return info.has("deaths") and int(info["deaths"]) == 0
		"chief":
			return bool(info.get("chief_first", false))
		"no_heal":
			return info.has("heal_total") and int(info["heal_total"]) == 0
		"all_hit":
			return bool(info.get("all_hit", false))
	return false


func register_victory(data: Dictionary, info: Dictionary = {}) -> Dictionary:
	if data.is_empty():
		return {}
	ensure_roster(data)
	var fight_no: int = selected_fight_number(data)
	# Aventure / Conquête : les gains sont partagés, mais la bataille ne compte pas
	# comme un combat de la campagne Tactique (frontière, cycle des biomes, boss).
	var campaign: bool = CAMPAIGN_FIGHTS_ISOLATED and String(data.get("campaign_mode", "")) in ["adventure", "conquest"]
	var frontier: bool = fight_no == frontier_fight_number(data) and not campaign
	var fight_level: int = campaign_fight_level(data) if campaign else enemy_level_for(data)
	var was_boss: bool = bool(info.get("boss", is_boss_fight(data)))
	# Défi optionnel de Conquête : évalué avant que le siège n'avance
	_conquest_eval_challenge(data, info)
	var enemies: Array = info.get("enemies", [])
	if enemies.is_empty():
		enemies = [{"type": "Gobelin", "level": fight_level, "boss": false},
			{"type": "Squelette", "level": fight_level, "boss": false},
			{"type": "Loup", "level": fight_level, "boss": false},
			{"type": "Dragonnet", "level": fight_level, "boss": was_boss}]
	var report: Dictionary = award_xp(data, fight_xp(enemies, fight_level), 1.0, fight_level)
	if frontier:
		data["victories"] = int(data.get("victories", 0)) + 1
		var hist: Array = data.get("fight_levels", [])
		hist.append(fight_level)
		data["fight_levels"] = hist
		data["selected_fight"] = 0
	elif not campaign:
		data["replays"] = int(data.get("replays", 0)) + 1
	var loots: Array = _roll_loots(fight_level, was_boss)
	for l: Dictionary in loots:
		data["inventory"].append(l)
	data["last_loots"] = loots
	# Butin de craft : ressources selon le nombre d'ennemis vaincus, un peu d'or.
	var drops: Dictionary = _roll_resource_drops(enemies.size(), was_boss)
	add_resources(data, drops)
	var gold_gain: int = (50 + 10 * fight_level) * (3 if was_boss else 1)
	data["gold"] = int(data.get("gold", 0)) + (gold_gain if (frontier or campaign) else int(gold_gain * 0.6))
	data["last_resources"] = drops
	data["level"] = frontier_level(data)
	data["last_result"] = {"victory": true, "xp": report, "boss": was_boss, "fight_level": fight_level,
		"turns": int(info.get("turns", 0)), "fight_no": fight_no, "replay": not frontier and not campaign}
	# Journal cumulé des loots gagnés dans cette partie
	var log_arr: Array = data.get("loot_log", [])
	for l: Dictionary in loots:
		log_arr.append({
			"type": l.get("type", ""), "name": l.get("name", ""), "level": int(l.get("level", 0)),
			"rarity": l.get("rarity", "commun"),
			"force": int(l.get("force", 0)), "intelligence": int(l.get("intelligence", 0)),
			"agility": int(l.get("agility", 0)), "wisdom": int(l.get("wisdom", 0)),
			"vita": int(l.get("vita", 0)), "defense": int(l.get("defense", 0)),
		})
	data["loot_log"] = log_arr
	# Objectif de combat (évalué avec l'objectif annoncé AVANT ce combat)
	var obj: Dictionary = info.get("objective", {})
	if not obj.is_empty():
		var ok: bool = _objective_met(obj, info)
		obj["success"] = ok
		if ok:
			data["gold"] = int(data.get("gold", 0)) + int(obj["gold"])
			add_resources(data, obj["resources"])
			Achievements.bump(data, "objectives")
		data["last_result"]["objective"] = obj
	# V43 : la Pierre Élémentaire ne tombe plus en Tactique ni en Conquête : seuls les Donjons d'Aventure la donnent (_dungeon_victory)
	# V28 : tableau des primes du jour
	var bounty_done: Array[String] = Bounties.on_victory(data, info)
	if not bounty_done.is_empty():
		data["last_result"]["bounties"] = bounty_done
	_apply_campaign_victory(data)
	# Succès (V18 + contre-la-montre V42 : les succès de vitesse sont des
	# records par partie, débloqués dans l'écran Succès — plus de réglage global)
	Achievements.bump(data, "wins")
	if int(info.get("deaths", 1)) == 0 and info.has("deaths"):
		Achievements.bump(data, "flawless")
	Achievements.record_speed(data, int(info.get("turns", 0)), was_boss)
	if was_boss:
		Achievements.bump(data, "bosses")
	Achievements.bump(data, "loots", loots.size())
	data["last_achievements"] = []
	Achievements.check(data)
	progression_changed.emit()
	return data

## Défaite : un peu d'XP de consolation, pas de loot, pas de recul.
func register_defeat(data: Dictionary, info: Dictionary = {}) -> Dictionary:
	if data.is_empty():
		return {}
	ensure_roster(data)
	var campaign: bool = CAMPAIGN_FIGHTS_ISOLATED and String(data.get("campaign_mode", "")) in ["adventure", "conquest"]
	var fight_level: int = campaign_fight_level(data) if campaign else enemy_level_for(data)
	var enemies: Array = info.get("enemies", [])
	var report: Dictionary = {}
	if not enemies.is_empty():
		report = award_xp(data, fight_xp(enemies, fight_level), ClassRules.DEFEAT_XP_RATIO, fight_level)
	data["defeats"] = int(data.get("defeats", 0)) + 1
	data["last_loots"] = []
	data["last_resources"] = {}
	data["level"] = frontier_level(data)
	data["last_result"] = {"victory": false, "xp": report, "boss": bool(info.get("boss", false)),
		"fight_level": fight_level, "turns": int(info.get("turns", 0))}
	_apply_campaign_defeat(data)
	data["last_achievements"] = []
	Achievements.check(data)
	progression_changed.emit()
	return data

## Applique les conséquences de campagne au même profil que le mode Tactique.
## La ville n'est ajoutée au territoire qu'après une victoire réelle.
## Journal court et persistant des événements de campagne.
func conquest_add_event(conquest: Dictionary, event_text: String) -> void:
	if event_text.strip_edges().is_empty():
		return
	var events: Array = conquest.get("events", [])
	events.append(event_text)
	while events.size() > 8:
		events.pop_front()
	conquest["events"] = events

func _apply_campaign_victory(data: Dictionary) -> void:
	var mode: String = String(data.get("campaign_mode", ""))
	if mode == "conquest":
		var conquest: Dictionary = data.get("conquest", {})
		var pending: String = String(conquest.get("pending_city", ""))
		var just_conquered: String = pending
		if pending != "":
			var sieges: Dictionary = conquest.get("sieges", {})
			var progress: int = int(sieges.get(pending, 0))
			progress += 1
			if progress >= conquest_city_battles(pending, conquest):
				# Ville prise : annexion et fin du siège
				var owned: Array = conquest.get("owned", ["capitale"])
				if not owned.has(pending):
					owned.append(pending)
					conquest["owned"] = owned
					conquest_add_event(conquest, "Ville annexée : %s" % conquest_city_name(pending))
				conquest["just_annexed"] = pending
				# Butin thématique versé uniquement à la première annexion.
				var rewarded: Array = conquest.get("rewarded", [])
				var reward: Dictionary = CONQUEST_CITY_REWARDS.get(pending, {}) if not rewarded.has(pending) else {}
				if not rewarded.has(pending):
					rewarded.append(pending)
					conquest["rewarded"] = rewarded
				var lost_list: Array = conquest.get("lost", [])
				if lost_list.has(pending):
					lost_list.erase(pending)
					conquest["lost"] = lost_list
					conquest["retaken"] = pending
				if not reward.is_empty():
					var reward_resources: Dictionary = reward.get("resources", {})
					add_resources(data, reward_resources)
					data["gold"] = int(data.get("gold", 0)) + int(reward.get("gold", 0))
					conquest["last_city_reward"] = {
						"city": pending,
						"name": String(reward.get("name", "Butin de conquête")),
						"resources": reward_resources.duplicate(true),
						"gold": int(reward.get("gold", 0)),
					}
					var reward_summary: PackedStringArray = []
					for resource: String in reward_resources.keys():
						reward_summary.append("+%d %s" % [int(reward_resources[resource]), resource])
					if int(reward.get("gold", 0)) > 0:
						reward_summary.append("+%d or" % int(reward.get("gold", 0)))
					conquest_add_event(conquest, "Butin : %s (%s)" % [String(reward.get("name", "Récompense")), ", ".join(reward_summary)])
				conquest["pending_city"] = ""
				conquest.erase("pending_level")
				sieges.erase(pending)
				conquest["sieges"] = sieges
			else:
				# Siège en cours : la ville reste la cible pour la suite
				sieges[pending] = progress
				conquest["sieges"] = sieges
				conquest_add_event(conquest, "Siège : %s — %d/%d victoires" % [conquest_city_name(pending), progress, conquest_city_battles(pending, conquest)])
		# Production de l'empire : les bâtiments des villes possédées
		# rapportent leurs ressources à chaque bataille gagnée.
		var empire_yield: Dictionary = conquest_empire_yield(conquest)
		if not empire_yield.is_empty():
			add_resources(data, empire_yield)
			conquest["last_yield"] = empire_yield
		# Décrément du pillage, puis la boucle de campagne : revenus, garnisons,
		# raids, offensives annoncées et événements (ConquestSystem).
		_tick_ravage(conquest)
		var names: Dictionary = {}
		for cid: String in CONQUEST_CITIES.keys():
			names[cid] = String(CONQUEST_CITIES[cid].get("name", cid))
		data["conquest"] = conquest
		ConquestSystem.after_victory(data, conquest, _rng, CONQUEST_ROUTES, names, just_conquered)
		conquest = data.get("conquest", conquest)
		# Le choix de préparation ne s'applique qu'à une seule bataille,
		# même si le siège de cette ville nécessite plusieurs vagues.
		conquest.erase("pending_tactic")
		data["conquest"] = conquest
	elif mode == "adventure":
		var adventure: Dictionary = data.get("adventure", {})
		var pending_challenge: String = String(adventure.get("pending_challenge", ""))
		var mob: Dictionary = AdventureMobs.parse_challenge(pending_challenge)
		if not mob.is_empty():
			# Groupe de monstres errant : il disparaît, le contrat de la carte avance.
			var mz: String = String(mob["zone"])
			var gone: Dictionary = AdventureMobs.defeat(adventure, mz, int(mob["id"]))
			if not gone.is_empty():
				var filled: Dictionary = AdventureMobs.progress(adventure, mz, gone)
				if not filled.is_empty():
					var rew: Dictionary = adventure_contract_reward(data, mz, filled)
					adventure["last_contract"] = rew
			adventure["pending_challenge"] = ""
			adventure.erase("pending_level")
			adventure.erase("pending_name")
			adventure.erase("pending_count")
			data["adventure"] = adventure
		elif adventure_dungeon_biome(data) != "":
			_dungeon_victory(data, adventure, pending_challenge, adventure_dungeon_biome(data))
		elif pending_challenge != "":
			var completed: Array = adventure.get("completed", [])
			if not completed.has(pending_challenge):
				completed.append(pending_challenge)
			adventure["completed"] = completed
			adventure["pending_challenge"] = ""
			adventure.erase("pending_level")
			adventure.erase("pending_name")
			adventure.erase("pending_count")
			data["adventure"] = adventure

## V43 : Nation du donjon dont le défi d'Aventure est en cours ("" si ce n'est pas un donjon).
func adventure_dungeon_biome(data: Dictionary) -> String:
	if String(data.get("campaign_mode", "")) != "adventure":
		return ""
	var key: String = String(data.get("adventure", {}).get("pending_challenge", ""))
	if key == "":
		return ""
	return String(adventure_poi_by_key(key).get("guardian", ""))


## V43 : une salle de donjon vient d'être gagnée. Avance l'expédition ; à la 4e salle : butin,
## tirage de la Pierre (50 % la 1re fois, puis 5 %) et bilan du donjon.
func _dungeon_victory(data: Dictionary, adventure: Dictionary, key: String, biome: String) -> void:
	var res: Dictionary = Dungeons.win_room(adventure, biome, _rng.randf(), Stones.has(data, biome))
	if bool(res["cleared"]):
		if String(res["stone_roll"]) == "won" and Stones.grant(data, biome):
			data["last_result"]["stone"] = biome
			Achievements.bump(data, "stones")
		var lvl: int = Dungeons.room_level(biome, Dungeons.ROOMS)
		var gold: int = 100 + 15 * lvl
		data["gold"] = int(data.get("gold", 0)) + gold
		var res_name: String = String(CONQUEST_BIOME_RESOURCE.get(biome, Nations.resource_of(biome)))
		var loot_res: Dictionary = {res_name: 3 + lvl / 12, res_key(res_name, 2): 1 + lvl / 30}
		add_resources(data, loot_res)
		res["gold"] = gold
		res["resources"] = loot_res
		var drops: Array = _roll_loots(lvl + 2, true)
		if not drops.is_empty():
			data["inventory"].append(drops[0])
			res["item"] = drops[0]
		if bool(res["first_clear"]):
			var completed: Array = adventure.get("completed", [])
			if not completed.has(key):
				completed.append(key)
			adventure["completed"] = completed
	data["last_result"]["dungeon"] = res
	adventure["pending_challenge"] = ""
	adventure.erase("pending_level")
	adventure.erase("pending_name")
	adventure.erase("pending_count")
	data["adventure"] = adventure


## Récompense d'un contrat d'Aventure rempli, versée tout de suite à la sauvegarde.
## Retourne { title, zone, gold, resources, xp, item } pour l'affichage.
func adventure_contract_reward(data: Dictionary, zone: String, c: Dictionary) -> Dictionary:
	var lvl: int = maxi(1, int(c.get("level", adventure_zone_level(zone))))
	var elite: bool = String(c.get("kind", "")) == "elite"
	var mult: float = 1.6 if elite else 1.0
	var gold: int = roundi(float(40 + 8 * lvl) * mult)
	var res_name: String = String(CONQUEST_BIOME_RESOURCE.get(adventure_zone_biome(zone), Nations.resource_of(adventure_zone_biome(zone))))
	var res: Dictionary = {res_name: 3 + lvl / 8}
	if elite:
		res[res_key(res_name, 2)] = 1 + lvl / 25
	add_resources(data, res)
	data["gold"] = int(data.get("gold", 0)) + gold
	var xp: int = roundi(float(combat_xp(lvl)) * (1.5 if elite else 0.4 * float(int(c.get("need", 2)))))
	award_xp(data, xp, 1.0, lvl)
	var out: Dictionary = {"title": "Contrat d'élite rempli !" if elite else "Contrat de chasse rempli !",
		"zone": zone, "gold": gold, "resources": res, "xp": xp}
	if elite:
		var drops: Array = _roll_loots(lvl + 2, true)
		if not drops.is_empty():
			data["inventory"].append(drops[0])
			out["item"] = drops[0]
	return out

## Récompense unique de maîtrise d'une carte (tous les lieux et trouvailles) : un objet
## rare ou mieux du niveau de la carte, de l'or et des ressources.
func adventure_mastery_reward(data: Dictionary, zone: String) -> Dictionary:
	var adv: Dictionary = data.get("adventure", {})
	var mastered: Array = adv.get("mastered", [])
	if mastered.has(zone):
		return {}
	mastered.append(zone)
	adv["mastered"] = mastered
	var lvl: int = adventure_zone_level(zone)
	var gold: int = 80 + 10 * lvl
	data["gold"] = int(data.get("gold", 0)) + gold
	var res_name: String = String(CONQUEST_BIOME_RESOURCE.get(adventure_zone_biome(zone), Nations.resource_of(adventure_zone_biome(zone))))
	var res: Dictionary = {res_key(res_name, 2): 2 + lvl / 20}
	add_resources(data, res)
	var out: Dictionary = {"zone": zone, "gold": gold, "resources": res}
	var drops: Array = _roll_loots(lvl + 3, true)
	if not drops.is_empty():
		data["inventory"].append(drops[0])
		out["item"] = drops[0]
	return out

# ═══════════════════════════════════════════════════════════════════════
#  MODE AVENTURE — état, brouillard de guerre et pont vers la Conquête
# ═══════════════════════════════════════════════════════════════════════

## Initialise (si besoin) l'état Aventure d'une sauvegarde et le retourne.
## Structure : { zone, hero_pos:[x,y], moves, discovered:["zone,x,y"...],
##              completed:["zone,x,y"...], pending_challenge:"",
##              zones_unlocked:[zone...], revealed_cities:[ville...] }
func adventure_state(data: Dictionary) -> Dictionary:
	if not data.has("adventure") or not (data["adventure"] is Dictionary) \
			or data["adventure"].is_empty():
		data["adventure"] = {
			"zone": "foret_sylve",
			"hero_pos": ADVENTURE_ZONES["foret_sylve"]["start"].duplicate(),
			"moves": 0, "discovered": [], "completed": [],
			"pending_challenge": "", "zones_unlocked": ["foret_sylve"],
			"revealed_cities": [],
		}
	var adv: Dictionary = data["adventure"]
	if not adv.has("zones_unlocked") or (adv["zones_unlocked"] as Array).is_empty():
		adv["zones_unlocked"] = ["foret_sylve"]
	if String(adv.get("zone", "")) == "" or not ADVENTURE_ZONES.has(String(adv.get("zone", ""))):
		adv["zone"] = "foret_sylve"
	var zone: Dictionary = ADVENTURE_ZONES[String(adv["zone"])]
	var pos: Array = adv.get("hero_pos", [])
	if pos.size() != 2 or int(pos[0]) < 0 or int(pos[1]) < 0 \
				or int(pos[0]) >= int(zone["size"][0]) or int(pos[1]) >= int(zone["size"][1]):
		adv["hero_pos"] = zone["start"].duplicate()
	for k: String in ["discovered", "completed", "revealed_cities", "finds"]:
		if not adv.has(k) or not (adv[k] is Array):
			adv[k] = []
	if not adv.has("pending_challenge"):
		adv["pending_challenge"] = ""
	# Première visite : le brouillard se lève autour du point de départ.
	if (adv["discovered"] as Array).is_empty():
		var start: Array = adv.get("hero_pos", zone["start"])
		adventure_move(adv, Vector2i(int(start[0]), int(start[1])))
		adv["moves"] = 0
	return adv

## Métadonnées d'une zone du catalogue Aventure.
func adventure_zone_meta(zone_id: String) -> Dictionary:
	return ADVENTURE_ZONES.get(zone_id, {})

## Nom affichable d'une zone (retourne l'id si inconnue).
func adventure_zone_name(zone_id: String) -> String:
	return String(ADVENTURE_ZONES.get(zone_id, {}).get("name", zone_id))

## Biome de combat / rendu d'une zone Aventure.
func adventure_zone_biome(zone_id: String) -> String:
	return String(ADVENTURE_ZONES.get(zone_id, {}).get("biome", "Forêt"))

## POI à une position donnée d'une zone : {} si pas de POI.
## POI d'après sa clé « zone,x,y » ({} si inconnu).
func adventure_poi_by_key(key: String) -> Dictionary:
	var parts: PackedStringArray = key.split(",")
	if parts.size() != 3:
		return {}
	return ADVENTURE_POIS.get(parts[0], {}).get("%s,%s" % [parts[1], parts[2]], {})

func adventure_poi(zone_id: String, pos: Vector2i) -> Dictionary:
	var key := "%d,%d" % [pos.x, pos.y]
	return ADVENTURE_POIS.get(zone_id, {}).get(key, {})

## Tous les POI d'une zone.
func adventure_zone_pois(zone_id: String) -> Dictionary:
	return ADVENTURE_POIS.get(zone_id, {})

## Clé de sauvegarde d'un POI ("zone,x,y").
func adventure_poi_key(zone_id: String, pos: Vector2i) -> String:
	return "%s,%d,%d" % [zone_id, pos.x, pos.y]

## Une zone est-elle débloquée (elle-même ou son prédécesseur complété via
## son POI exit) ? Une zone sans prérequis est toujours débloquée.
func adventure_zone_unlocked(adv: Dictionary, zone_id: String) -> bool:
	var prereq: String = String(ADVENTURE_ZONES.get(zone_id, {}).get("unlock", ""))
	if prereq == "":
		return true
	return (adv.get("zones_unlocked", []) as Array).has(zone_id)

## Déplace le héros dans sa zone courante : révèle le brouillard de guerre
## autour de la nouvelle position (rayon ADVENTURE_FOG_RADIUS). Retourne
## la liste des clés nouvellement découvertes.
func adventure_move(adv: Dictionary, pos: Vector2i) -> Array:
	var zone_id: String = String(adv.get("zone", "foret_sylve"))
	var zone: Dictionary = ADVENTURE_ZONES.get(zone_id, {})
	if zone.is_empty():
		return []
	adv["hero_pos"] = [pos.x, pos.y]
	adv["moves"] = int(adv.get("moves", 0)) + 1
	var discovered: Array = adv.get("discovered", [])
	var fresh: Array = []
	var radius: int = ADVENTURE_FOG_RADIUS
	var w: int = int(zone["size"][0])
	var h: int = int(zone["size"][1])
	for y: int in range(maxi(0, pos.y - radius), mini(h, pos.y + radius + 1)):
		for x: int in range(maxi(0, pos.x - radius), mini(w, pos.x + radius + 1)):
			var key := "%s,%d,%d" % [zone_id, x, y]
			if not discovered.has(key):
				discovered.append(key)
				fresh.append(key)
	adv["discovered"] = discovered
	return fresh

## Une case est-elle découverte (hors brouillard) dans la zone courante ?
func adventure_cell_discovered(adv: Dictionary, pos: Vector2i) -> bool:
	var key := "%s,%d,%d" % [String(adv.get("zone", "foret_sylve")), pos.x, pos.y]
	return (adv.get("discovered", []) as Array).has(key)

## Un POI est-il déjà complété (clé "zone,x,y") ?
func adventure_poi_completed(adv: Dictionary, key: String) -> bool:
	return (adv.get("completed", []) as Array).has(key)

## Marque un POI complété. Si c'est une sortie (exit), débloque la zone
## suivante du catalogue. Si c'est un belvédère (reveal), révèle les villes
## de la zone côté Conquête (pont inter-modes). Retourne la liste des
## révélations ("zone:<id>" ou id de ville).
func adventure_complete_poi(adv: Dictionary, poi_key: String, kind: String = "") -> Array:
	var completed: Array = adv.get("completed", [])
	if not completed.has(poi_key):
		completed.append(poi_key)
	adv["completed"] = completed
	var zone_id: String = String(adv.get("zone", "foret_sylve"))
	var poi_kind: String = kind
	if poi_kind == "":
		poi_kind = "exit"
		var pos_part := poi_key.substr(zone_id.length() + 1)
		for k: String in ADVENTURE_POIS.get(zone_id, {}).keys():
			if k == pos_part:
				poi_kind = String(ADVENTURE_POIS[zone_id][k].get("kind", "exit"))
				break
	var revealed: Array = []
	if poi_kind == "exit":
		for next_id: String in ADVENTURE_ZONES.keys():
			if String(ADVENTURE_ZONES[next_id].get("unlock", "")) == zone_id:
				var unlocked: Array = adv.get("zones_unlocked", [])
				if not unlocked.has(next_id):
					unlocked.append(next_id)
					adv["zones_unlocked"] = unlocked
					revealed.append("zone:" + next_id)
	elif poi_kind == "reveal":
		var cities: Array = ADVENTURE_ZONES.get(zone_id, {}).get("reveals", [])
		var known: Array = adv.get("revealed_cities", [])
		for city_id: String in cities:
			if not known.has(city_id):
					known.append(city_id)
					revealed.append(city_id)
		adv["revealed_cities"] = known
	return revealed

## Débloque une zone Aventure (retour de conquête, événement…).
func adventure_unlock_zone(adv: Dictionary, zone_id: String) -> void:
	if not ADVENTURE_ZONES.has(zone_id):
		return
	var unlocked: Array = adv.get("zones_unlocked", [])
	if not unlocked.has(zone_id):
		unlocked.append(zone_id)
	adv["zones_unlocked"] = unlocked

## Change de zone Aventure (si débloquée) : le héros repart du point de
## départ de la zone et son brouillard y est révélé autour de lui.
func adventure_enter_zone(adv: Dictionary, zone_id: String) -> bool:
	if not ADVENTURE_ZONES.has(zone_id) or not adventure_zone_unlocked(adv, zone_id):
		return false
	adv["zone"] = zone_id
	adv["hero_pos"] = ADVENTURE_ZONES[zone_id]["start"].duplicate()
	var pos := Vector2i(int(adv["hero_pos"][0]), int(adv["hero_pos"][1]))
	adventure_move(adv, pos)
	adv["moves"] = maxi(0, int(adv.get("moves", 1)) - 1)
	return true

## Zones débloquées d'une partie Aventure (pour le sélecteur de l'UI).
func adventure_available_zones(adv: Dictionary) -> Array:
	var out: Array = []
	for zone_id: String in ADVENTURE_ZONES.keys():
		if adventure_zone_unlocked(adv, zone_id):
			out.append(zone_id)
	return out

# ── Monde d'Aventure : grille de cartes et portes (façon Dofus Touch) ────────
const ADVENTURE_DIRS := {"N": Vector2i(0, -1), "E": Vector2i(1, 0), "S": Vector2i(0, 1), "W": Vector2i(-1, 0)}
const ADVENTURE_OPPOSITE := {"N": "S", "S": "N", "E": "W", "W": "E"}
const ADVENTURE_DIR_LABEL := {"N": "nord", "E": "est", "S": "sud", "W": "ouest"}

## V40 : étages du monde. Les Nations des Vents et des Brumes flottent dans le ciel, celles des
## Ombres, des Cristaux et du Brasier sont sous terre ; les autres sont en surface.
## 1 = ciel, 0 = surface, -1 = profondeurs.
const ADVENTURE_LAYER := {"Vents": 1, "Brumes": 1, "Ombres": -1, "Cristaux": -1, "Brasier": -1}
const ADVENTURE_LAYER_NAME := {1: "Ciel", 0: "Surface", -1: "Profondeurs"}

func adventure_biome_layer(biome: String) -> int:
	return int(ADVENTURE_LAYER.get(biome, 0))

func adventure_zone_layer(zone_id: String) -> int:
	return adventure_biome_layer(adventure_zone_biome(zone_id))

## Passage entre deux cartes : nom et récit selon le changement d'étage (0 = même étage).
func adventure_climb_info(from_zone: String, to_zone: String) -> Dictionary:
	var a: int = adventure_zone_layer(from_zone)
	var b: int = adventure_zone_layer(to_zone)
	var d: int = b - a
	if d == 0:
		return {"climb": 0, "label": "", "text": ""}
	if b == 1:
		return {"climb": d, "label": "Courant ascendant" if a == 0 else "Colonne de brume",
			"text": "Un courant ascendant vous emporte au-dessus des nuages…" if a == 0 else "Une colonne de brume vous hisse des profondeurs jusqu'au ciel…"}
	if b == -1:
		return {"climb": d, "label": "Descente" if a == 0 else "Cascade de brume",
			"text": "Vous descendez dans les profondeurs, la lumière du jour s'éloigne…" if a == 0 else "Vous plongez dans une cascade de brume jusqu'aux profondeurs…"}
	if a == 1:
		return {"climb": d, "label": "Descente des nuées", "text": "Vous redescendez des nuées vers la terre ferme…"}
	return {"climb": d, "label": "Remontée", "text": "Vous remontez vers la surface : le jour revient…"}

## Position d'une carte sur la grille du monde (calculs dans AdventureTerrain).
func adventure_zone_grid(zone_id: String) -> Vector2i:
	return AdventureTerrain.grid_of(zone_id)

## Carte voisine dans une direction ("" si le bord de l'île donne sur le vide).
func adventure_neighbor(zone_id: String, dir: String) -> String:
	return AdventureTerrain.neighbor(zone_id, dir)

## Case de la porte d'un bord : milieu du côté (axe x de la grille = est/ouest).
func adventure_gate_cell(zone_id: String, dir: String) -> Vector2i:
	return AdventureTerrain.gate_cell(zone_id, dir)

## Portes de la carte : { Vector2i case : {"dir", "to"} }.
func adventure_gates(zone_id: String) -> Dictionary:
	return AdventureTerrain.gates_of(zone_id)

## La route vers une carte voisine est-elle ouverte ? Oui si la carte a déjà été
## visitée, si elle n'est pas plus difficile, ou si le combat clé de la carte de
## départ (`key_poi`) est remporté.
func adventure_gate_open(adv: Dictionary, from_zone: String, to_zone: String) -> bool:
	if (adv.get("zones_unlocked", []) as Array).has(to_zone):
		return true
	if adventure_zone_level(to_zone) <= adventure_zone_level(from_zone):
		return true
	var key_poi: String = String(ADVENTURE_ZONES.get(from_zone, {}).get("key_poi", ""))
	return key_poi == "" or adventure_poi_completed(adv, "%s,%s" % [from_zone, key_poi])

## Explication affichée quand une route est fermée ("" si ouverte).
func adventure_gate_lock_reason(adv: Dictionary, from_zone: String, to_zone: String) -> String:
	if adventure_gate_open(adv, from_zone, to_zone):
		return ""
	var key_poi: String = String(ADVENTURE_ZONES.get(from_zone, {}).get("key_poi", ""))
	var poi_name: String = String(ADVENTURE_POIS.get(from_zone, {}).get(key_poi, {}).get("name", "le gardien"))
	return "La route vers %s est gardée : remportez « %s » pour l'ouvrir." % [adventure_zone_name(to_zone), poi_name]

## Franchit la porte `dir` de la carte courante : le héros arrive sur la carte
## voisine, une case à l'intérieur de la porte opposée. Retourne false si fermée.
func adventure_cross(adv: Dictionary, dir: String) -> bool:
	var from_zone: String = String(adv.get("zone", "foret_sylve"))
	var to_zone: String = adventure_neighbor(from_zone, dir)
	if to_zone == "" or not adventure_gate_open(adv, from_zone, to_zone):
		return false
	var unlocked: Array = adv.get("zones_unlocked", [])
	if not unlocked.has(to_zone):
		unlocked.append(to_zone)
	adv["zones_unlocked"] = unlocked
	var back: String = String(ADVENTURE_OPPOSITE[dir])
	var arrive: Vector2i = adventure_gate_cell(to_zone, back) - ADVENTURE_DIRS[back]
	adv["zone"] = to_zone
	adventure_move(adv, arrive)
	return true

## Niveau d'un combat de campagne : lieu d'Aventure ou ville de Conquête en cours,
## sinon le niveau du mode Tactique.
func campaign_fight_level(data: Dictionary) -> int:
	match String(data.get("campaign_mode", "")):
		"adventure":
			var lv: int = int(data.get("adventure", {}).get("pending_level", 0))
			if lv > 0:
				return lv
		"conquest":
			var cq: Dictionary = data.get("conquest", {})
			if String(cq.get("pending_city", "")) != "" and int(cq.get("pending_level", 0)) > 0:
				return int(cq["pending_level"])
	return enemy_level_for(data)

## Niveau d'un défi Aventure (combat/énigme) : celui du POI si fourni,
## sinon le niveau moyen de l'équipe (comme le mode Tactique).
func adventure_challenge_level(data: Dictionary, poi: Dictionary = {}) -> int:
	if not poi.is_empty() and int(poi.get("level", 0)) > 0:
		return int(poi["level"])
	return enemy_level_for(data)

## Réponse d'énigme acceptée ? Comparaison sans accents, casse, ponctuation ni
## article initial (« le feu », « Feu », « FEU ! » sont équivalents).
func adventure_answer_matches(puzzle: Dictionary, answer: String) -> bool:
	var expected: String = _norm_answer(String(puzzle.get("answer", "")))
	return expected != "" and _norm_answer(answer) == expected

func _norm_answer(t: String) -> String:
	var s2: String = t.strip_edges().to_lower()
	for pair in [["é", "e"], ["è", "e"], ["ê", "e"], ["ë", "e"], ["à", "a"], ["â", "a"], ["î", "i"], ["ï", "i"],
			["ô", "o"], ["û", "u"], ["ù", "u"], ["ç", "c"], ["’", "'"]]:
		s2 = s2.replace(pair[0], pair[1])
	for ch in [".", ",", "!", "?", ";", ":", "\"", "«", "»"]:
		s2 = s2.replace(ch, "")
	s2 = s2.strip_edges()
	for art in ["le ", "la ", "les ", "l'", "un ", "une ", "des "]:
		if s2.begins_with(art):
			s2 = s2.substr(art.length()).strip_edges()
			break
	return s2

## Niveau de référence d'une zone (plus petit niveau de ses lieux) : rencontres de route.
func adventure_zone_level(zone_id: String) -> int:
	var lvl: int = 0
	for k: String in ADVENTURE_POIS.get(zone_id, {}).keys():
		var l: int = int(ADVENTURE_POIS[zone_id][k].get("level", 10))
		if lvl == 0 or l < lvl:
			lvl = l
	return maxi(1, lvl if lvl > 0 else 10)

## Production totale de l'empire (bâtiments des villes possédées non
## pillées), versée à chaque bataille gagnée.
func conquest_empire_yield(conquest: Dictionary) -> Dictionary:
	var out: Dictionary = {}
	for city_id: String in conquest.get("owned", []):
		if _is_city_ravaged(conquest, city_id):
			continue
		var mult: float = ConquestSystem.level_multiplier(conquest, city_id)
		for b: String in _city_buildings(conquest, city_id):
			for r: String in CONQUEST_BUILDINGS.get(b, {}).get("yield", {}).keys():
				out[r] = int(out.get(r, 0)) + int(roundf(float(CONQUEST_BUILDINGS[b]["yield"][r]) * mult))
	# Les héros gouverneurs produisent aussi (ressources de leur classe).
	var gy: Dictionary = ConquestSystem.governor_yield(conquest)
	for r: String in gy.keys():
		out[r] = int(out.get(r, 0)) + int(gy[r])
	# Contrôler toutes les villes d'un biome rapporte un bonus permanent à
	# chaque victoire, même si aucune ville ne possède encore de bâtiment.
	for r: String in conquest_biome_control_bonus(conquest).keys():
		out[r] = int(out.get(r, 0)) + int(conquest_biome_control_bonus(conquest)[r])
	return out

## Bonus de domination : il faut posséder toutes les villes conquérables
## d'un biome. Le Donjon et la capitale ne comptent pas dans les biomes.
func conquest_biome_control_bonus(conquest: Dictionary) -> Dictionary:
	var owned: Array = conquest.get("owned", [])
	var biome_cities: Dictionary = {}
	var biome_owned: Dictionary = {}
	for city_id: String in CONQUEST_CITIES.keys():
		if city_id == "capitale" or city_id == "donjon_roi":
			continue
		var biome: String = String(CONQUEST_CITIES[city_id].get("biome", "Forêt"))
		biome_cities[biome] = int(biome_cities.get(biome, 0)) + 1
		if owned.has(city_id):
			biome_owned[biome] = int(biome_owned.get(biome, 0)) + 1
	var bonus: Dictionary = {}
	for biome: String in biome_cities.keys():
		if int(biome_owned.get(biome, 0)) < int(biome_cities[biome]):
			continue
		match biome:
			"Forêt":
				bonus["Bois"] = 5
			"Montagne":
				bonus["Fer"] = 5
			"Désert":
				bonus["Venin"] = 5
			_:
				if Nations.is_new(biome):
					bonus[Nations.resource_of(biome)] = 5
	return bonus

## Nombre de batailles necessaires pour prendre cette ville :
## 4 (3 mobs + boss) pour une ville adverse, 1 pour une neutre.
func conquest_city_battles(city_id: String, conquest: Dictionary = {}) -> int:
	if (conquest.get("lost", []) as Array).has(city_id):
		return 1
	return CONQUEST_SIEGE_BATTLES if String(conquest_city_kind(city_id)) == "enemy" else 1

## Type (capital/neutral/enemy) d'une ville du catalogue Conquête.
func conquest_city_kind(city_id: String) -> String:
	return String(CONQUEST_CITIES.get(city_id, {}).get("kind", "neutral"))

## Biome d'une ville (décor et bestiaire de ses batailles).
func conquest_city_biome(city_id: String) -> String:
	return String(CONQUEST_CITIES.get(city_id, {}).get("biome", "Forêt"))

## Nom d'une ville du catalogue (retourne l'id si inconnu).
func conquest_city_name(city_id: String) -> String:
	return String(CONQUEST_CITIES.get(city_id, {}).get("name", city_id))

## Récompense thématique prévue pour une ville.
func conquest_city_reward(city_id: String) -> Dictionary:
	return CONQUEST_CITY_REWARDS.get(city_id, {}).duplicate(true)

## Une ville est-elle attaquable : reliée par route au territoire ET pas
## déjà conquise. La capitale ne s'attaque jamais ; le Donjon exige de
## contrôler toutes les autres villes (fin de campagne).
## Pont Aventure : si l'Aventure a révélé des villes (belvédères), seules
## les villes révélées sont attaquables ; sans révélation (parties où
## l'Aventure n'a pas été jouée), toutes les villes reliées restent
## attaquables — rétrocompatible avec les sauvegardes existantes.
func conquest_city_attackable(conquest: Dictionary, city_id: String, adventure: Dictionary = {}) -> bool:
	var kind: String = conquest_city_kind(city_id)
	if kind == "capital" or kind == "":
		return false
	if conquest.get("owned", []).has(city_id):
		return false
	if city_id == "donjon_roi" and not conquest_empire_complete(conquest):
		return false
	var revealed: Array = []
	if not adventure.is_empty():
		revealed = adventure.get("revealed_cities", [])
	if not revealed.is_empty() and not revealed.has(city_id):
		return false
	for pair: Array in CONQUEST_ROUTES:
		var a: String = String(pair[0])
		var b: String = String(pair[1])
		if (a == city_id and conquest.get("owned", []).has(b)) \
			or (b == city_id and conquest.get("owned", []).has(a)):
			return true
	return false

## Toutes les villes (hors capitale et Donjon) sont-elles conquises ?
func conquest_empire_complete(conquest: Dictionary) -> bool:
	var owned: Array = conquest.get("owned", [])
	for city_id: String in CONQUEST_CITIES.keys():
		if city_id == "capitale" or city_id == "donjon_roi":
			continue
		if not owned.has(city_id):
			return false
	return true

## Victoire de campagne : le Donjon du Roi Squelette est tombé.
func conquest_campaign_won(conquest: Dictionary) -> bool:
	return conquest.get("owned", []).has("donjon_roi")

## Progression du siège d’une ville adverse (batailles gagnées dessus).
func conquest_siege_progress(conquest: Dictionary, city_id: String) -> int:
	return int(conquest.get("sieges", {}).get(city_id, 0))

## Numéro de la bataille de siège à jouer (1..CONQUEST_SIEGE_BATTLES), ou 0 hors siège.
## Les 3 premières batailles opposent des mobs de champs ; la 4e est le boss.
func conquest_siege_wave(conquest: Dictionary, city_id: String) -> int:
	if not conquest.get("sieges", {}).has(city_id) and String(conquest.get("pending_city", "")) != city_id:
		return 0
	return clampi(conquest_siege_progress(conquest, city_id) + 1, 1, conquest_city_battles(city_id, conquest))

## La bataille de siège courante est-elle celle du boss ? (dernière vague)
func conquest_siege_is_boss(conquest: Dictionary, city_id: String) -> bool:
	return conquest_siege_wave(conquest, city_id) == CONQUEST_SIEGE_BATTLES

## La ville est-elle pillée (production gelée) ?
func _is_city_ravaged(conquest: Dictionary, city_id: String) -> bool:
	return int(_ravage_dict(conquest).get(city_id, 0)) > 0

func _ravage_dict(conquest: Dictionary) -> Dictionary:
	var r: Dictionary = conquest.get("ravage", {})
	for k: String in r.keys():
		r[k] = int(r[k])
	return r

## Bâtiments construits dans une ville.
func _city_buildings(conquest: Dictionary, city_id: String) -> Array:
	var builds: Dictionary = conquest.get("buildings", {})
	var lst: Array = builds.get(city_id, [])
	var out: Array = []
	for b in lst:
		out.append(String(b))
	return out

## Un combat de moins de pillage sur toutes les villes ravagées.
func _tick_ravage(conquest: Dictionary) -> void:
	var r: Dictionary = _ravage_dict(conquest)
	var cleaned: Dictionary = {}
	for k: String in r.keys():
		var v: int = int(r[k]) - 1
		if v > 0:
			cleaned[k] = v
	conquest["ravage"] = cleaned

## Contre-attaque ennemie : retourne l\'id de la ville ciblée, ou "".
## Ne cible jamais la capitale ni la ville qui vient d\'être conquise.
func _roll_counterattack(conquest: Dictionary, just_conquered: String) -> String:
	if _rng.randf() > CONQUEST_COUNTERATTACK_CHANCE:
		return ""
	var candidates: Array = []
	for city_id: String in conquest.get("owned", []):
		if city_id == "capitale" or city_id == just_conquered:
			continue
		if _is_city_ravaged(conquest, city_id):
			continue
		candidates.append(city_id)
	if candidates.is_empty():
		return ""
	return String(candidates[_rng.randi_range(0, candidates.size() - 1)])

## ── Villes évolutives, garnisons, gouverneurs, événements (ConquestSystem) ──
func conquest_city_level(conquest: Dictionary, city_id: String) -> int:
	return ConquestSystem.city_level(conquest, city_id)

func conquest_upgrade_city(data: Dictionary, city_id: String) -> String:
	var err: String = ConquestSystem.upgrade_city(data, city_id, conquest_city_name(city_id))
	if err == "":
		progression_changed.emit()
	return err

func conquest_recruit(data: Dictionary, city_id: String, n: int) -> String:
	var err: String = ConquestSystem.recruit(data, city_id, n)
	if err == "":
		progression_changed.emit()
	return err

func conquest_assign_hero(data: Dictionary, city_id: String, classe: String) -> String:
	var err: String = ConquestSystem.assign_hero(data, city_id, classe)
	if err == "":
		conquest_add_event(data["conquest"], "%s devient gouverneur de %s" % [classe, conquest_city_name(city_id)])
		progression_changed.emit()
	return err

func conquest_recall_hero(data: Dictionary, city_id: String) -> String:
	var err: String = ConquestSystem.recall_hero(data, city_id)
	if err == "":
		progression_changed.emit()
	return err

func conquest_defense(data: Dictionary, city_id: String) -> int:
	return ConquestSystem.defense(data, city_id)

## Héros (classes) en poste dans une ville : indisponibles pour les assauts.
func conquest_stationed_heroes(data: Dictionary) -> Array:
	if String(data.get("campaign_mode", "")) != "conquest":
		return []
	return ConquestSystem.stationed_heroes(data.get("conquest", {}))

func conquest_pending_event(conquest: Dictionary) -> Dictionary:
	return ConquestSystem.pending_event(conquest)

func conquest_resolve_event(data: Dictionary, option_id: String) -> String:
	var names: Dictionary = {}
	for cid: String in CONQUEST_CITIES.keys():
		names[cid] = String(CONQUEST_CITIES[cid].get("name", cid))
	var out: String = ConquestSystem.resolve_event(data, option_id, _rng, names)
	if out != "":
		progression_changed.emit()
	return out

## Paie la préparation d'assaut. Centralisé ici pour que l'interface et les
## tests utilisent exactement les mêmes coûts et contrôles de ressources.
## Retourne "" si le paiement est accepté, sinon un message explicatif.
func conquest_pay_assault_tactic(data: Dictionary, tactic: String) -> String:
	var costs: Dictionary = {}
	var gold_cost: int = 0
	match tactic:
		"none":
			return ""
		"scouts":
			gold_cost = 25
		"sabotage":
			costs = {"Bois": 12, "Fer": 8}
		"supply":
			gold_cost = 15
			costs = {"Cuir": 6}
		_:
			return "Préparation d'assaut inconnue."
	var resources: Dictionary = data.get("resources", {})
	for resource: String in costs.keys():
		var required: int = int(costs[resource])
		if int(resources.get(resource, 0)) < required:
			return "Ressource insuffisante : %s (%d/%d)." % [resource, int(resources.get(resource, 0)), required]
	if int(data.get("gold", 0)) < gold_cost:
		return "Or insuffisant : %d pièces requises." % gold_cost
	for resource: String in costs.keys():
		resources[resource] = int(resources.get(resource, 0)) - int(costs[resource])
	data["resources"] = resources
	data["gold"] = int(data.get("gold", 0)) - gold_cost
	return ""

## ── Défis optionnels de Conquête ─────────────────────────────────────
## Chaque bataille d'assaut propose un défi facultatif (déterministe : même ville et
## même vague = même défi). Réussi, il rapporte de l'or et une ressource du biome.
##   swift    : gagner en CONQUEST_SWIFT_TURNS tours ou moins ;
##   flawless : aucun allié K.O. ;
##   class    : gagner avec une classe donnée dans l'équipe.
const CONQUEST_SWIFT_TURNS := 6
const CONQUEST_BIOME_RESOURCE := {"Forêt": "Bois", "Montagne": "Fer", "Désert": "Venin", "Donjon": "Magie"}

func conquest_challenge_for(data: Dictionary, city_id: String) -> Dictionary:
	if city_id == "" or not CONQUEST_CITIES.has(city_id):
		return {}
	var conquest: Dictionary = data.get("conquest", {})
	var wave: int = int(conquest.get("sieges", {}).get(city_id, 0))
	var h: int = absi(city_id.hash() + wave * 7919)
	var kinds: Array = ["swift", "flawless", "class"]
	var kind: String = String(kinds[h % kinds.size()])
	var level: int = int(CONQUEST_CITIES[city_id].get("level", 10))
	var res_name: String = String(CONQUEST_BIOME_RESOURCE.get(conquest_city_biome(city_id), Nations.resource_of(conquest_city_biome(city_id))))
	var out: Dictionary = {"kind": kind, "gold": 40 + 4 * level, "resources": {res_name: 4 + level / 6}}
	match kind:
		"swift":
			out["label"] = "Victoire éclair : gagner en %d tours ou moins" % CONQUEST_SWIFT_TURNS
		"flawless":
			out["label"] = "Sans pertes : aucun allié K.O."
		"class":
			var classes: Array = CLASS_ORDER.duplicate()
			var cls: String = String(classes[(h / 3) % classes.size()])
			out["class"] = cls
			out["label"] = "Avec un %s dans l'équipe" % cls
	return out

## Le défi est-il rempli ? info : { turns, deaths } transmis par GameManager.
func conquest_challenge_met(data: Dictionary, challenge: Dictionary, info: Dictionary) -> bool:
	match String(challenge.get("kind", "")):
		"swift":
			return int(info.get("turns", 99)) > 0 and int(info.get("turns", 99)) <= CONQUEST_SWIFT_TURNS
		"flawless":
			return info.has("deaths") and int(info["deaths"]) == 0
		"class":
			for m: Dictionary in data.get("team", []):
				if String(m.get("classe", "")) == String(challenge.get("class", "")):
					return true
	return false

func _conquest_eval_challenge(data: Dictionary, info: Dictionary) -> void:
	if String(data.get("campaign_mode", "")) != "conquest":
		return
	var conquest: Dictionary = data.get("conquest", {})
	var city: String = String(conquest.get("pending_city", ""))
	var ch: Dictionary = conquest_challenge_for(data, city)
	if ch.is_empty():
		conquest.erase("last_challenge")
		return
	var ok: bool = conquest_challenge_met(data, ch, info)
	ch["success"] = ok
	if ok:
		data["gold"] = int(data.get("gold", 0)) + int(ch["gold"])
		add_resources(data, ch["resources"])
		conquest_add_event(conquest, "Défi réussi : %s (+%d or)" % [String(ch["label"]), int(ch["gold"])])
	conquest["last_challenge"] = ch
	data["conquest"] = conquest

## Construire un bâtiment dans une ville conquise. Retourne "" si OK.
func conquest_build(data: Dictionary, city_id: String, building: String) -> String:
	var info: Dictionary = CONQUEST_BUILDINGS.get(building, {})
	if info.is_empty():
		return "Bâtiment inconnu."
	var conquest: Dictionary = data.get("conquest", {})
	if not conquest.get("owned", []).has(city_id):
		return "Ville non conquise."
	if _is_city_ravaged(conquest, city_id):
		return "Ville pillée : impossible de construire."
	var builds: Dictionary = conquest.get("buildings", {})
	var lst: Array = builds.get(city_id, [])
	if lst.has(building):
		return "Bâtiment déjà construit."
	var res: Dictionary = data.get("resources", {})
	for k: String in info.get("cost", {}).keys():
		if int(res.get(k, 0)) < int(info["cost"][k]):
			return "Ressource insuffisante : %s (%d/%d)." % [k, int(res.get(k, 0)), int(info["cost"][k])]
	if int(data.get("gold", 0)) < int(info.get("gold", 0)):
		return "Or insuffisant : %d pièces requises." % int(info.get("gold", 0))
	for k: String in info.get("cost", {}).keys():
		res[k] = int(res.get(k, 0)) - int(info["cost"][k])
	data["resources"] = res
	data["gold"] = int(data.get("gold", 0)) - int(info.get("gold", 0))
	lst.append(building)
	builds[city_id] = lst
	conquest["buildings"] = builds
	conquest_add_event(conquest, "Bâtiment construit : %s — %s" % [conquest_city_name(city_id), String(info["label"])])
	data["conquest"] = conquest
	progression_changed.emit()
	return ""

## Brisage d\'un objet de l\'inventaire : le détruit et rend des ressources
## selon sa rareté et son niveau (matières pour la Forge).
const SALVAGE_RARITY := {
	"commun":     {"n": 1, "res": ["Fer", "Bois"]},
	"rare":       {"n": 2, "res": ["Fer", "Cuir", "Bois"]},
	"epique":     {"n": 3, "res": ["Magie", "Fer", "Cuir"]},
	"legendaire": {"n": 5, "res": ["Magie", "Venin", "Fer"]},
}

## Aperçu de ce que rend un objet au Briseur (sans le détruire).
func salvage_preview(it: Dictionary) -> Dictionary:
	var info: Dictionary = SALVAGE_RARITY.get(String(it.get("rarity", "commun")), SALVAGE_RARITY["commun"])
	var lvl: int = maxi(1, int(it.get("level", 1)))
	var n_per: int = maxi(1, int(round((1.0 + float(lvl) * 0.1) * float(info["n"] * 0.6))))
	var bonus: String = ""
	var rk: int = int(it.get("rank", 1))
	if rk >= 2:
		bonus = res_key(String(SLOT_MAIN_RES.get(slot_for_type(String(it.get("type", ""))), "Magie")), rk - 1)
	return {"total": int(info["n"]) * n_per, "pool": info["res"], "bonus": bonus}


func salvage_item(data: Dictionary, inv_index: int) -> Dictionary:
	## Retourne { "ok": bool, "gains": {res: n}, "reason": "" }
	var inv: Array = data.get("inventory", [])
	if inv_index < 0 or inv_index >= inv.size():
		return {"ok": false, "gains": {}, "reason": "Objet introuvable."}
	var it: Dictionary = inv[inv_index]
	var rarity: String = String(it.get("rarity", "commun"))
	var info: Dictionary = SALVAGE_RARITY.get(rarity, SALVAGE_RARITY["commun"])
	var lvl: int = maxi(1, int(it.get("level", 1)))
	var n_per: int = maxi(1, int(round((1.0 + float(lvl) * 0.1) * float(info["n"] * 0.6))))
	var gains: Dictionary = {}
	var res_pool: Array = info["res"]
	for i: int in range(int(info["n"])):
		var res: String = String(res_pool[_rng.randi_range(0, res_pool.size() - 1)])
		gains[res] = int(gains.get(res, 0)) + n_per
	# Un objet de rang supérieur rend une ressource de rang (rang - 1)
	var rk: int = int(it.get("rank", 1))
	if rk >= 2:
		var main: String = String(SLOT_MAIN_RES.get(slot_for_type(String(it.get("type", ""))), "Magie"))
		var kk: String = res_key(main, rk - 1)
		gains[kk] = int(gains.get(kk, 0)) + 1
	inv.remove_at(inv_index)
	data["inventory"] = inv
	add_resources(data, gains)
	progression_changed.emit()
	return {"ok": true, "gains": gains, "reason": ""}

## Brise plusieurs objets d'un coup. `items` : dictionnaires d'objets (libres ou portés) ;
## un objet porté est d'abord retiré à son porteur. Retourne { "count", "gains" }.
func salvage_many(data: Dictionary, items: Array) -> Dictionary:
	var gains: Dictionary = {}
	var count: int = 0
	for it: Dictionary in items:
		var inv: Array = data.get("inventory", [])
		var idx: int = inv.find(it)
		if idx < 0:
			# objet porté : on le cherche chez les héros
			var found: bool = false
			for cl: String in class_names():
				var eq: Dictionary = hero_equipment(data, cl)
				for slot: String in eq.keys():
					if eq[slot] == it:
						unequip_hero_item(data, cl, slot)
						found = true
						break
				if found:
					break
			if not found:
				continue
			inv = data.get("inventory", [])
			idx = inv.rfind(it)
			if idx < 0:
				continue
		var r: Dictionary = salvage_item(data, idx)
		if bool(r.get("ok", false)):
			count += 1
			for k: String in (r["gains"] as Dictionary).keys():
				gains[k] = int(gains.get(k, 0)) + int(r["gains"][k])
	return {"count": count, "gains": gains}

## En cas de défaite, on ne valide pas la conquête/le défi : le joueur pourra retenter.
func _apply_campaign_defeat(data: Dictionary) -> void:
	var mode: String = String(data.get("campaign_mode", ""))
	if mode == "conquest":
		# Defaite : le siege en cours est conserve (meme cible, meme
		# progression) : le joueur peut retenter la bataille perdue.
		var conquest: Dictionary = data.get("conquest", {})
		conquest.erase("pending_tactic")
		data["conquest"] = conquest
	elif mode == "adventure":
		var adventure: Dictionary = data.get("adventure", {})
		var lost_biome: String = adventure_dungeon_biome(data)
		if lost_biome != "":
			var room_lost: int = Dungeons.current_room(adventure, lost_biome)
			Dungeons.lose(adventure)
			if data.has("last_result"):
				data["last_result"]["dungeon"] = {"lost": true, "biome": lost_biome, "room": room_lost,
					"rooms": Dungeons.ROOMS, "reset": Dungeons.DEFEAT_RESETS}
		adventure["pending_challenge"] = ""
		adventure.erase("pending_name")
		adventure.erase("pending_count")
		data["adventure"] = adventure

## Numéro du prochain combat (1 = premier). Boss tous les BOSS_EVERY combats.
func next_fight_number(data: Dictionary) -> int:
	return selected_fight_number(data)

## Boss : 4e combat de chaque biome hors donjon ; dans le donjon, chaque salle
## est un combat de boss (salle 1-3 : boss du biome, salle 4 : big boss).
func is_boss_fight(data: Dictionary) -> bool:
	var n: int = next_fight_number(data)
	if donjon_room(n) != "":
		return true
	return n % BOSS_EVERY == 0

## Nom du boss de la salle de donjon courante : boss du biome de la salle,
## ou le big boss (Roi Squelette) pour la salle finale.
func donjon_boss(data: Dictionary) -> String:
	var n: int = next_fight_number(data)
	var room: String = donjon_room(n)
	if room == "":
		return ""
	if room == "Donjon":
		return "Roi Squelette"
	return biome_boss(room)

func _roll_loots(level: int, boss: bool = false) -> Array:
	var count: int = _rng.randi_range(1, 3)
	if boss:
		count = _rng.randi_range(3, 4)
	var out: Array = []
	for i: int in range(count):
		var item := _random_item(level)
		if item.is_empty():
			continue
		# Le boss garantit du rare+ sur son premier objet ; les autres tirages sont normaux
		var rarity: String = ItemRules.roll_rarity(_rng, boss and i == 0)
		out.append(ItemRules.apply_rarity(item, rarity, _rng))
	return out

## Ressources de craft lâchées par un combat : une par ennemi vaincu environ,
## choix pondéré ; le boss en garantit deux de plus.
func _roll_resource_drops(enemy_count: int, boss: bool = false) -> Dictionary:
	var drops: Dictionary = {}
	var keys: Array = RESOURCE_DROPS.keys()
	var weights: Array = []
	var total: int = 0
	for k: String in keys:
		var w: int = int(RESOURCE_DROPS[k])
		weights.append(w)
		total += w
	var n: int = maxi(1, enemy_count / 2) + (2 if boss else 0)
	for i: int in range(n):
		var r: int = _rng.randi_range(1, total)
		var rkey: String = keys[keys.size() - 1]
		var j: int = 0
		while j < keys.size() and r > 0:
			r -= int(weights[j])
			if r > 0:
				j += 1
			else:
				rkey = keys[j]
		var qty: int = _rng.randi_range(1, 2) + (1 if boss else 0)
		drops[rkey] = int(drops.get(rkey, 0)) + qty
	return drops

## Tire un item proche du niveau du combat : les objets obsolètes sont de plus en
## plus rares, et un objet légèrement au-dessus du niveau peut tomber (à convoiter).
func _random_item(level: int) -> Dictionary:
	var candidates: Array = []
	var weights: Array = []
	var total: float = 0.0
	for it: Dictionary in _items_catalog:
		var lv: int = int(it["level"])
		if lv > level + 3:
			continue
		var gap: float = maxf(0.0, float(level - lv))
		var w: float = 1.0 / pow(1.0 + gap / 5.0, 2.0)
		candidates.append(it)
		weights.append(w)
		total += w
	if candidates.is_empty():
		return {}
	var r: float = _rng.randf() * total
	for i: int in range(candidates.size()):
		r -= float(weights[i])
		if r <= 0.0:
			return candidates[i].duplicate()
	return candidates[candidates.size() - 1].duplicate()

# ═══════════════════════════════════════════════════════════════════════════
#  Équipement
# ═══════════════════════════════════════════════════════════════════════════

## Trouve l'emplacement d'équipement compatible avec un type d'item ("" sinon).
func slot_for_type(item_type: String) -> String:
	for slot: String in EQUIP_SLOTS.keys():
		if EQUIP_SLOTS[slot].has(item_type):
			return slot
	return ""

## Remplace l'équipement d'un héros (membre d'équipe ou roster) par une copie.
func set_hero_equipment(data: Dictionary, classe: String, eq: Dictionary) -> void:
	for m: Dictionary in data.get("team", []):
		if String(m.get("classe", "")) == classe:
			m["equipment"] = eq.duplicate(true)
			return
	var roster: Dictionary = data.get("roster", {})
	if not roster.has(classe):
		roster[classe] = {}
		data["roster"] = roster
	var entry: Dictionary = roster[classe]
	entry["equipment"] = eq.duplicate(true)


## Équipement d'un héros (référence vivante) : celui du membre d'équipe s'il en fait
## partie, sinon celui conservé dans le roster (gouverneurs, héros au repos).
func hero_equipment(data: Dictionary, classe: String) -> Dictionary:
	for m: Dictionary in data.get("team", []):
		if String(m.get("classe", "")) == classe:
			if not m.has("equipment"):
				m["equipment"] = {}
			return m["equipment"]
	var roster: Dictionary = data.get("roster", {})
	if not roster.has(classe):
		roster[classe] = {}
		data["roster"] = roster
	var entry: Dictionary = roster[classe]
	if not entry.has("equipment"):
		entry["equipment"] = {}
	return entry["equipment"]


## Équipe un item de l'inventaire sur un héros (équipe ou non) ; l'ancien item retourne
## à l'inventaire. Retourne "" si OK, sinon la raison.
func equip_hero_item(data: Dictionary, classe: String, item_index: int) -> String:
	var inv: Array = data.get("inventory", [])
	if not class_names().has(classe):
		return "Personnage introuvable."
	if item_index < 0 or item_index >= inv.size():
		return "Objet introuvable."
	var item: Dictionary = inv[item_index]
	var slot: String = slot_for_type(String(item["type"]))
	if slot == "":
		return "Type d'objet inconnu : %s" % String(item["type"])
	var lvl: int = member_level(data, classe)
	if int(item.get("level", 1)) > lvl:
		return "Niveau %d requis (%s est niveau %d)." % [int(item.get("level", 1)), classe, lvl]
	var equipment: Dictionary = hero_equipment(data, classe)
	if slot == "bouclier" and equipment.has("arme") and ItemRules.is_two_handed(equipment["arme"]):
		return "Arme à deux mains équipée : retirez-la pour porter un bouclier."
	inv.remove_at(item_index)
	if equipment.has(slot):
		inv.append(equipment[slot])
	if slot == "arme" and ItemRules.is_two_handed(item) and equipment.has("bouclier"):
		inv.append(equipment["bouclier"])
		equipment.erase("bouclier")
	equipment[slot] = item
	return ""


func unequip_hero_item(data: Dictionary, classe: String, slot: String) -> String:
	var equipment: Dictionary = hero_equipment(data, classe)
	if not equipment.has(slot):
		return "Emplacement vide."
	data["inventory"].append(equipment[slot])
	equipment.erase(slot)
	return ""


## Équipe un item de l'inventaire sur un membre de l'équipe (par index).
func equip_item(data: Dictionary, member_index: int, item_index: int) -> String:
	var team: Array = data.get("team", [])
	if member_index < 0 or member_index >= team.size():
		return "Personnage introuvable."
	return equip_hero_item(data, String(team[member_index].get("classe", "")), item_index)

func unequip_item(data: Dictionary, member_index: int, slot: String) -> String:
	var team: Array = data.get("team", [])
	if member_index < 0 or member_index >= team.size():
		return "Personnage introuvable."
	return unequip_hero_item(data, String(team[member_index].get("classe", "")), slot)

## Valeur totale (ItemRules.power) de l'équipement porté par un héros.
func hero_gear_power(data: Dictionary, classe: String) -> int:
	var total: int = 0
	for it: Variant in hero_equipment(data, classe).values():
		if it is Dictionary:
			total += ItemRules.power(it)
	return total

## Somme des bonus d'équipement d'un membre (panoplies incluses) : { force, intelligence,
## agility, wisdom, vita, defense }
func equipment_bonuses(member: Dictionary) -> Dictionary:
	return ItemRules.aggregate(member.get("equipment", {}))["stats"]

## Effets spéciaux d'équipement d'un membre (clés de ItemRules).
func equipment_fx(member: Dictionary) -> Dictionary:
	return ItemRules.aggregate(member.get("equipment", {}))["fx"]

## Reconstruit l'équipe depuis une liste de classes en conservant l'équipement des
## classes qui restent ; l'équipement des classes écartées retourne à l'inventaire
## (avant : il était perdu).
func rebuild_team(data: Dictionary, classes: Array) -> Array:
	var old_team: Array = data.get("team", [])
	var roster: Dictionary = data.get("roster", {})
	var new_team: Array = []
	var used: Array = []
	for classe in classes:
		var kept: Dictionary = {}
		for i: int in range(old_team.size()):
			if String(old_team[i].get("classe", "")) == String(classe) and not used.has(i):
				kept = old_team[i].get("equipment", {})
				used.append(i)
				break
		# Un héros qui revient dans l'équipe retrouve l'équipement qu'il portait au repos
		# (gouverneur, par exemple).
		if kept.is_empty() and roster.has(String(classe)) and roster[String(classe)].has("equipment"):
			kept = roster[String(classe)]["equipment"]
			roster[String(classe)].erase("equipment")
		new_team.append({"classe": String(classe), "equipment": kept})
	# Un héros écarté rend son équipement à l'inventaire, sauf s'il est gouverneur d'une
	# ville : il le garde alors (les gouverneurs ne combattent pas mais comptent leur stuff).
	var conq_state: Dictionary = data.get("conquest", {})
	for i: int in range(old_team.size()):
		if used.has(i):
			continue
		var cl: String = String(old_team[i].get("classe", ""))
		var eq_old: Dictionary = old_team[i].get("equipment", {})
		if eq_old.is_empty() or cl == "":
			continue
		if ConquestSystem.hero_city(conq_state, cl) == "":
			for slot2: String in eq_old.keys():
				data["inventory"].append(eq_old[slot2])
			continue
		if not roster.has(cl):
			roster[cl] = {}
		var dest: Dictionary = roster[cl].get("equipment", {})
		for slot: String in eq_old.keys():
			if dest.has(slot):
				data["inventory"].append(eq_old[slot])
			else:
				dest[slot] = eq_old[slot]
		roster[cl]["equipment"] = dest
	data["roster"] = roster
	data["team"] = new_team
	ensure_roster(data)
	return new_team


## Équipe automatiquement les meilleurs objets (valeur ItemRules.power) en respectant le
## niveau requis et la règle arme à 2 mains / bouclier. Retourne le nombre de changements.
func auto_equip(data: Dictionary) -> int:
	var changes: int = 0
	var team: Array = data.get("team", [])
	var guard: int = 0
	while guard < 80:
		guard += 1
		var inv: Array = data.get("inventory", [])
		var best_gain: int = 0
		var best_m: int = -1
		var best_i: int = -1
		for mi: int in range(team.size()):
			var member: Dictionary = team[mi]
			var lvl: int = member_level(data, String(member.get("classe", "")))
			var eq: Dictionary = member.get("equipment", {})
			for ii: int in range(inv.size()):
				var it: Dictionary = inv[ii]
				var slot: String = slot_for_type(String(it.get("type", "")))
				if slot == "" or int(it.get("level", 1)) > lvl:
					continue
				if slot == "bouclier" and eq.has("arme") and ItemRules.is_two_handed(eq["arme"]):
					continue
				var cur: Dictionary = eq.get(slot, {})
				var gain: int = ItemRules.power(it) - (ItemRules.power(cur) if not cur.is_empty() else 0)
				if slot == "arme" and ItemRules.is_two_handed(it) and eq.has("bouclier"):
					gain -= ItemRules.power(eq["bouclier"])
				if gain > best_gain:
					best_gain = gain
					best_m = mi
					best_i = ii
		if best_m < 0:
			break
		if equip_item(data, best_m, best_i) != "":
			break
		changes += 1
	return changes


## Renomme une partie existante. Retourne "" si OK.
func rename_save(slot: int, new_name: String) -> String:
	new_name = new_name.strip_edges()
	if new_name == "":
		return "Nom vide."
	var data := load_save(slot)
	if data.is_empty():
		return "Partie introuvable."
	data["name"] = new_name
	return "" if write_save(slot, data) else "Écriture impossible."
