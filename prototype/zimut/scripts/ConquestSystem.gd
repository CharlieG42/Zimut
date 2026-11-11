class_name ConquestSystem
extends RefCounted
## Cœur de la campagne Conquête, V14 : villes évolutives, garnisons, héros
## gouverneurs, offensives annoncées et événements entre les batailles.
##
## Tout est stocké dans data["conquest"] (rétro-compatible : chaque clé a une
## valeur par défaut), et toutes les fonctions sont statiques pour être testées
## sans interface. ProgressionManager garde les points d'entrée publics
## (conquest_*) et passe ici le catalogue de routes (pas d'autoload en static).
##
## Clés de data["conquest"] ajoutées :
##   city_levels {id:int}        niveau 1..5 (Hameau / Bourg / Cité / Grande Cité / Métropole)
##   building_levels {id:{bâtiment:int}}  niveau 1..5 des bâtiments (V61/V66, défaut 1)
##   wonders     [id]            villes qui ont bâti la Merveille de leur Nation (V61)
##   garrisons   {id:{troops,hero}}
##   threat      {city,power,eta}   offensive annoncée (compte à rebours en batailles)
##   event_pending {…}           événement à trancher par le joueur
##   news        [String]        nouvelles de la dernière bataille (affichées puis vidées)
##   truce int                   batailles restantes sans raid ni offensive
##   lost        [id]            villes perdues (reprise en 1 bataille)
##   rewarded    [id]            villes dont le butin d'annexion a déjà été versé
##   battle_count, event_cd, threat_cd

const MAX_LEVEL := 5
const LEVEL_NAMES: Array[String] = ["Hameau", "Bourg", "Cité", "Grande Cité", "Métropole"]
## Facteur de production (spécialité, bâtiments) par niveau de ville.
const LEVEL_MULT: Array[float] = [1.0, 1.5, 2.0, 2.4, 2.8]

## V61 — Bâtiments à niveaux : emplacements et niveau maximal des bâtiments selon le
## niveau de la ville, production et coût selon le niveau du bâtiment.
const BUILD_SLOTS: Array[int] = [3, 4, 5, 6, 6]
## V66 — 5 niveaux par bâtiment : le niveau N n'est accessible qu'à partir de la ville
## de niveau N (Hameau→Métropole). Le coût croît plus vite que la production
## (x1 / x2 / x3,5 / x6 / x10 contre x1 / x1,7 / x2,3 / x3 / x3,7) : les derniers
## niveaux sont un investissement de long terme, ce qui allonge la partie.
const BUILD_LEVEL_CAP: Array[int] = [1, 2, 3, 4, 5]
const BUILD_MAX_LEVEL := 5
const BUILD_YIELD_MULT: Array[float] = [1.0, 1.7, 2.3, 3.0, 3.7]
const BUILD_COST_MULT: Array[float] = [1.0, 2.0, 3.5, 6.0, 10.0]
const WALL_DEFENSE_BY_LEVEL: Array[int] = [6, 10, 14, 18, 22]
## Merveille de la Nation : une par ville, à partir de la Cité (niveau 3).
const WONDER_MIN_LEVEL := 3
const WONDERS := {
	"Forêt": {"label": "Arbre-Ancêtre", "shape": "tree", "text": "Les racines de l'Ancêtre nourrissent la ville.", "gold": 2, "def": 4, "res": {"Bois": 4}},
	"Montagne": {"label": "Forge des Cimes", "shape": "forge", "text": "L'acier des Cimes trempé au givre.", "gold": 2, "def": 4, "res": {"Fer": 4}},
	"Désert": {"label": "Grand Bazar", "shape": "pyramid", "text": "Toutes les caravanes des Sables y font halte.", "gold": 8, "def": 0, "res": {"Cuir": 2}},
	"Cristaux": {"label": "Prisme Éternel", "shape": "crystal", "text": "Un cristal géant qui concentre la Magie.", "gold": 2, "def": 2, "res": {"Magie": 3}},
	"Marées": {"label": "Grand Phare", "shape": "tower", "text": "Sa lumière guide les flottes marchandes.", "gold": 6, "def": 2, "res": {"Cuir": 2}},
	"Vents": {"label": "Moulin des Tempêtes", "shape": "mill", "text": "Les vents broient le grain et forgent les volontés.", "gold": 4, "def": 2, "res": {"Bois": 2, "Magie": 1}},
	"Brasier": {"label": "Haut-Fourneau", "shape": "forge", "text": "Le feu du volcan coule dans ses creusets.", "gold": 2, "def": 3, "res": {"Fer": 5}},
	"Brumes": {"label": "Serre des Brumes", "shape": "tree", "text": "Des plantes rares poussent dans la brume tiède.", "gold": 2, "def": 2, "res": {"Venin": 4}},
	"Ombres": {"label": "Crypte des Serments", "shape": "crypt", "text": "Les anciens serments veillent sur la ville.", "gold": 0, "def": 8, "res": {"Magie": 2}},
	"Rouages": {"label": "Grande Horloge", "shape": "tower", "text": "Ses rouages règlent toute l'économie de l'empire.", "gold": 5, "def": 2, "res": {"Fer": 2}},
	"Donjon": {"label": "Trône d'Os", "shape": "crypt", "text": "Le trône du Roi Squelette, désormais le vôtre.", "gold": 6, "def": 6, "res": {"Magie": 2}},
}
const WONDER_COST := {"gold": 450, "res_amount": 20}
const TROOP_COST := 30
const WALL_DEFENSE := 6
## Équipement du gouverneur : +1 défense par 10 de puissance (max 20), +1 or par 60 (max 4).
const GEAR_DEF_DIV := 10
const GEAR_DEF_MAX := 20
const GEAR_GOLD_DIV := 60
const GEAR_GOLD_MAX := 4
const RAID_CHANCE := 0.35
const RAVAGE_BATTLES := 3
const THREAT_ETA := 3
const THREAT_MIN_GAP := 5
const THREAT_CHANCE := 0.35
const EVENT_MIN_GAP := 2
const EVENT_CHANCE := 0.45
const RES_KEYS: Array[String] = ["Bois", "Fer", "Cuir", "Magie", "Venin"]

## Chancelier : tous ces batailles, le Conseil propose un édit stratégique
## (trade-off or / effet temporaire), via le même popup que les événements.
const CHANCELLOR_INTERVAL := 5
const CHANCELLOR_MIN_CITIES := 2
const DRILL_DEF := 2
const DRILL_BATTLES := 3
const ROADS_BOIS := 2
const ROADS_BATTLES := 4

## Lieutenance — missions de 3 batailles pour les héros libres : un héros
## envoyé en mission ne participe ni aux assauts ni au gouvernement, et
## rapporte sa récompense (ou sa complication) à son retour.
const MISSION_BATTLES := 3
const MISSION_CHANCE := 0.20
const MISSION_TYPES := {
	"caravane": {"label": "Escorte de caravane", "text": "Protéger les marchands jusqu'aux passes de l'empire.",
		"gold": 90, "res": {"Cuir": 4}},
	"carte": {"label": "Cartographie", "text": "Relever les terres inexplorées au-delà des frontières : 1 ville de plus en plus loin, jusqu'à 3 pour un héros expérimenté.",
		"reveal": 3},
	"filon": {"label": "Prospection", "text": "Chercher des filons dans les montagnes voisines.",
		"gold": 30, "res": {"Fer": 8}},
	}

## Généraux du Roi Squelette : chacun tient une forteresse (kind "enemy") d'une
## grande région. Tant qu'il vit, sa forteresse est mieux défendue et il peut
## lancer une offensive nommée ; le vaincre en assaut (4e bataille) calme la
## région et affaiblit le Donjon (tous les vaincus = assaut du Donjon facilité).
const GENERALS := {
	"garnison":      {"name": "Vorkann le Givre",   "region": "Montagne/Cristaux/Vents"},
	"fort_racine":   {"name": "Tharok le Végétal",  "region": "Forêt"},
	"tour_sable":    {"name": "Zahor le Sableux",   "region": "Désert/Marées"},
	"citadelle_ronce": {"name": "Nébulia l'Illusionniste", "region": "Ombres/Brumes"},
}
const GENERAL_DEF_BONUS := 3
const GENERAL_THREAT_BONUS := 2
const GENERAL_THREAT_CHANCE := 0.25

## Plans d'assaut (sièges ennemis) : le blocus et l'infiltration font
## progresser le siège d'une vague sans combat, au prix d'un risque ou d'un
## héros libre. L'assaut direct reste la voie des armes.
const PLAN_COST := {"blocus": 40, "infiltration": 50}
const PLAN_RAID_CHANCE := 0.35

## Reconquête ennemie : les villes non possédées se garnissent au fil de vos
## victoires — attendre une cible la durcit.
const GARRISON_EVERY := 3
const GARRISON_MAX := 6

## Diplomatie : coût d'annexion négociée d'une ville neutre (or + ressource
## de son biome). Plus cher que la voie des armes… en or. La ressource exigée
## est la spécialité de la ville (CITY_TRAITS), payable en une fois.
const DIPLO_GOLD := 120
const DIPLO_RES := 8
## Coût croissant avec le niveau de la ville (une ville de niveau 55 ne s'achète pas au prix d'un hameau)
const DIPLO_GOLD_PER_LEVEL := 4
const DIPLO_RES_PER_LEVEL := 0.15
## Victoires à attendre entre deux négociations (la diplomatie complète les combats, sans les remplacer)
const DIPLO_COOLDOWN := 3

## Ruine & reconstruction : une ville perdue puis reprise reste ruinée —
## niveau -1 (min 1) et production gelée RUIN_BATTLES, relevée en payant.
const RUIN_BATTLES := 3
const RUIN_REPAIR_GOLD := 80

## Légende (fin de campagne) : score construit tout au long de la conquête.
## Les composantes sont simples à suivre et affichées dans l'épilogue.
##   villes     : 10 par ville possédée (hors capitale)
##   niveaux    : 5 par niveau de ville au-dessus de Hameau
##   gouverneurs : 4 par gouverneur en poste
##   pierres    : 30 par Pierre Élémentaire possédée
##   diplomatie : 6 par ville annexée par négociation (voie pacifique)
##   ruines    : -8 par ville ruinée non réparée à la fin
const LEGEND_WEIGHTS := {"villes": 10, "niveaux": 5, "gouverneurs": 4, "pierres": 30, "diplomatie": 6, "ruines": -8}

## Spécialité économique de chaque ville (biome/Nation) : ressources versées
## à chaque victoire, mises à l'échelle du niveau de la ville. Les villes sans
## entrée (capitale, Donjon) n'ont pas de spécialité.
const CITY_TRAITS := {
	"clairiere": {"label": "Scierie d'Aube", "res": {"Bois": 2}},
	"vieille_tour": {"label": "Réserve de la Tour", "res": {"Fer": 2}},
	"pont_mousse": {"label": "Pêche du pont", "res": {"Cuir": 2}},
	"fort_racine": {"label": "Arsenal de Racine", "res": {"Fer": 3}},
	"hameau_pin": {"label": "Cabanons des Pics", "res": {"Bois": 2, "Cuir": 1}},
	"garnison": {"label": "Dépôt des Pics", "res": {"Fer": 3}},
	"oasis": {"label": "Herbier de l'Oasis", "res": {"Venin": 2}},
	"tour_sable": {"label": "Verriers des Dunes", "res": {"Magie": 2}},
	"village_brume": {"label": "Herbier des Brumes", "res": {"Venin": 2}},
	"ruines_lierre": {"label": "Pillardage du Lierre", "res": {"Magie": 2}},
	"abbaye_ronce": {"label": "Scriptorium", "res": {"Magie": 2, "Bois": 1}},
	"citadelle_ronce": {"label": "Fonderie des Ronces", "res": {"Fer": 2, "Cuir": 2}},
	"col_givre": {"label": "Cueillette du Col", "res": {"Magie": 2}},
	"mine_cristal": {"label": "Filon de cristal", "res": {"Magie": 3}},
	"bastion_orage": {"label": "Forge de l'Orage", "res": {"Fer": 2, "Bois": 1}},
	"caravanserail": {"label": "Comptoir rouge", "res": {"Cuir": 2}},
	"observatoire": {"label": "Lunettes solaires", "res": {"Magie": 2}},
	"port_sable": {"label": "Chantier naval", "res": {"Cuir": 3}},
	"bois_lune": {"label": "Sève de lune", "res": {"Bois": 2, "Magie": 1}},
	"sanctuaire_mousse": {"label": "Reliques moussues", "res": {"Magie": 1, "Venin": 1}},
	"forge_givre": {"label": "Forge du Givre", "res": {"Fer": 3}},
	"pic_foudroyant": {"label": "Capteurs de foudre", "res": {"Magie": 2, "Fer": 1}},
	"marais_spectres": {"label": "Essences des Marais", "res": {"Venin": 3}},
	"fort_cendre": {"label": "Trempe des Cendres", "res": {"Fer": 2, "Venin": 1}},
	"temple_soleil": {"label": "Offrandes solaires", "res": {"Magie": 3}},
	"citadelle_sable": {"label": "Four à grès", "res": {"Fer": 2, "Cuir": 1}},
	"atelier_cuivre": {"label": "Ateliers de cuivre", "res": {"Fer": 2, "Cuir": 1}},
	"citadelle_engrenages": {"label": "Usines à engrenages", "res": {"Fer": 3, "Magie": 1}},
}

## Coût (or + ressources) pour atteindre le niveau clé.
const UPGRADE := {
	2: {"gold": 120, "res": {"Bois": 10, "Fer": 10}},
	3: {"gold": 300, "res": {"Fer": 20, "Cuir": 10, "Magie": 10}},
	4: {"gold": 550, "res": {"Bois": 25, "Fer": 30, "Magie": 15}},
	5: {"gold": 900, "res": {"Fer": 40, "Cuir": 25, "Magie": 25, "Venin": 15}},
}

## Effets d'un héros gouverneur, par classe : def = défense en plus,
## gold = or par bataille, res = ressources par bataille, heal = soldats
## recrutés gratuitement par bataille dans sa ville.
const GOVERNOR := {
	"Tank":       {"def": 8, "gold": 0, "res": {}, "heal": 0, "text": "Rempart vivant : +8 défense"},
	"Assassin":   {"def": 0, "gold": 4, "res": {}, "heal": 0, "text": "Réseau d'informateurs : +4 or par bataille"},
	"Chasseur":   {"def": 2, "gold": 0, "res": {"Cuir": 2}, "heal": 0, "text": "Chasse et peaux : +2 Cuir par bataille"},
	"Mage":       {"def": 2, "gold": 0, "res": {"Magie": 1}, "heal": 0, "text": "Tour d'étude : +1 Magie par bataille"},
	"Druide":     {"def": 0, "gold": 0, "res": {"Bois": 2, "Venin": 1}, "heal": 0, "text": "Jardins sacrés : +2 Bois, +1 Venin"},
	"Heal":       {"def": 0, "gold": 0, "res": {}, "heal": 1, "text": "Infirmerie : +1 soldat par bataille"},
	"Invocateur": {"def": 4, "gold": 0, "res": {}, "heal": 0, "text": "Gardiens invoqués : +4 défense"},
	"Sylvain":    {"def": 3, "gold": 0, "res": {"Bois": 1}, "heal": 0, "text": "Sentinelles : +3 défense, +1 Bois"},
	"Géomancien": {"def": 2, "gold": 0, "res": {"Fer": 2}, "heal": 0, "text": "Filons : +2 Fer, +2 défense"},
	"Artificier": {"def": 2, "gold": 3, "res": {"Fer": 1}, "heal": 0, "text": "Ateliers : +3 or, +1 Fer, +2 défense"},
}

# ═══════════════════════════════════════════════════════════════════════
#  Lecture de l'état
# ═══════════════════════════════════════════════════════════════════════

static func city_level(conq: Dictionary, id: String) -> int:
	return clampi(int(conq.get("city_levels", {}).get(id, 1)), 1, MAX_LEVEL)

static func level_name(level: int) -> String:
	return LEVEL_NAMES[clampi(level, 1, MAX_LEVEL) - 1]

static func garrison_cap(conq: Dictionary, id: String) -> int:
	return 2 + 2 * city_level(conq, id)

static func troops(conq: Dictionary, id: String) -> int:
	return clampi(int(conq.get("garrisons", {}).get(id, {}).get("troops", 0)), 0, garrison_cap(conq, id))

static func hero_of(conq: Dictionary, id: String) -> String:
	return String(conq.get("garrisons", {}).get(id, {}).get("hero", ""))

## Ville où ce héros est en poste, ou "".
static func hero_city(conq: Dictionary, classe: String) -> String:
	var g: Dictionary = conq.get("garrisons", {})
	for id: String in g.keys():
		if String(g[id].get("hero", "")) == classe:
			return id
	return ""

## Héros en poste (classes), pour les exclure de la sélection d'équipe.
static func stationed_heroes(conq: Dictionary) -> Array:
	var out: Array = []
	var g: Dictionary = conq.get("garrisons", {})
	for id: String in g.keys():
		var h: String = String(g[id].get("hero", ""))
		if h != "" and (conq.get("owned", []) as Array).has(id):
			out.append(h)
	return out

static func is_ravaged(conq: Dictionary, id: String) -> bool:
	return int(conq.get("ravage", {}).get(id, 0)) > 0

static func has_wall(conq: Dictionary, id: String) -> bool:
	return (conq.get("buildings", {}).get(id, []) as Array).has("muraille")

## Défense apportée par la muraille (selon son niveau), 0 sans muraille.
static func wall_defense(conq: Dictionary, id: String) -> int:
	if not has_wall(conq, id):
		return 0
	return WALL_DEFENSE_BY_LEVEL[building_level(conq, id, "muraille") - 1]

# ── Bâtiments à niveaux (V61) ──

static func buildings_of(conq: Dictionary, id: String) -> Array:
	return conq.get("buildings", {}).get(id, [])

## Niveau d'un bâtiment : 0 s'il n'est pas construit, sinon 1..5.
static func building_level(conq: Dictionary, id: String, key: String) -> int:
	if not buildings_of(conq, id).has(key):
		return 0
	return clampi(int(conq.get("building_levels", {}).get(id, {}).get(key, 1)), 1, BUILD_MAX_LEVEL)

## Emplacements de construction de la ville (selon son niveau).
static func building_slots(conq: Dictionary, id: String) -> int:
	return BUILD_SLOTS[city_level(conq, id) - 1]

## Niveau maximal des bâtiments autorisé par le niveau de la ville.
static func building_level_cap(conq: Dictionary, id: String) -> int:
	return BUILD_LEVEL_CAP[city_level(conq, id) - 1]

## Premier niveau de ville qui autorise ce niveau de bâtiment (pour l'afficher).
static func city_level_for_building(level: int) -> int:
	for i: int in range(BUILD_LEVEL_CAP.size()):
		if BUILD_LEVEL_CAP[i] >= level:
			return i + 1
	return MAX_LEVEL

## Premier niveau de ville qui offre n emplacements.
static func city_level_for_slots(n: int) -> int:
	for i: int in range(BUILD_SLOTS.size()):
		if BUILD_SLOTS[i] >= n:
			return i + 1
	return MAX_LEVEL

## Production d'un bâtiment à un niveau donné (hors facteur de la ville).
static func building_yield_at(info: Dictionary, level: int) -> Dictionary:
	var out: Dictionary = {}
	if level <= 0:
		return out
	var m: float = BUILD_YIELD_MULT[clampi(level, 1, BUILD_MAX_LEVEL) - 1]
	for r: String in info.get("yield", {}).keys():
		out[r] = roundi(float(info["yield"][r]) * m)
	return out

## Coût pour amener un bâtiment au niveau `level` (1 = construction).
static func building_cost(info: Dictionary, level: int) -> Dictionary:
	var m: float = BUILD_COST_MULT[clampi(level, 1, BUILD_MAX_LEVEL) - 1]
	var res: Dictionary = {}
	for r: String in info.get("cost", {}).keys():
		res[r] = roundi(float(info["cost"][r]) * m)
	return {"gold": roundi(float(info.get("gold", 0)) * m), "res": res}

static func _pay(data: Dictionary, cost: Dictionary) -> String:
	var res: Dictionary = data.get("resources", {})
	for k: String in cost.get("res", {}).keys():
		if int(res.get(k, 0)) < int(cost["res"][k]):
			return "Ressource insuffisante : %s (%d/%d)." % [k, int(res.get(k, 0)), int(cost["res"][k])]
	if int(data.get("gold", 0)) < int(cost.get("gold", 0)):
		return "Or insuffisant : %d pièces requises." % int(cost.get("gold", 0))
	for k: String in cost.get("res", {}).keys():
		res[k] = int(res.get(k, 0)) - int(cost["res"][k])
	data["resources"] = res
	data["gold"] = int(data.get("gold", 0)) - int(cost.get("gold", 0))
	return ""

## Améliore un bâtiment construit (niveau max selon la ville). "" si OK.
static func upgrade_building(data: Dictionary, id: String, key: String, info: Dictionary, label: String = "") -> String:
	var conq: Dictionary = data.get("conquest", {})
	if not (conq.get("owned", []) as Array).has(id):
		return "Ville non conquise."
	if is_ravaged(conq, id):
		return "Ville pillée : impossible de construire."
	var lvl: int = building_level(conq, id, key)
	if lvl <= 0:
		return "Bâtiment pas encore construit."
	if lvl >= BUILD_MAX_LEVEL:
		return "Bâtiment déjà au niveau maximum."
	if lvl >= building_level_cap(conq, id):
		return "La ville doit devenir %s pour ce niveau." % level_name(city_level_for_building(lvl + 1))
	var err: String = _pay(data, building_cost(info, lvl + 1))
	if err != "":
		return err
	var bl: Dictionary = conq.get("building_levels", {})
	var cl: Dictionary = bl.get(id, {})
	cl[key] = lvl + 1
	bl[id] = cl
	conq["building_levels"] = bl
	log_event(conq, "Bâtiment amélioré : %s niveau %d" % [label if label != "" else key, lvl + 1])
	data["conquest"] = conq
	return ""

# ── Merveilles de Nation (V61) ──

static func wonder_for(biome: String) -> Dictionary:
	return WONDERS.get(biome, WONDERS["Forêt"])

static func has_wonder(conq: Dictionary, id: String) -> bool:
	return (conq.get("wonders", []) as Array).has(id)

static func wonder_cost(biome: String) -> Dictionary:
	var r: String = Nations.resource_of(biome) if Nations.DATA.has(biome) else "Magie"
	var second: String = "Magie" if r != "Magie" else "Fer"
	return {"gold": int(WONDER_COST["gold"]), "res": {r: int(WONDER_COST["res_amount"]), second: 10}}

## Bâtit la Merveille de la Nation dans une ville (Cité minimum). "" si OK.
static func build_wonder(data: Dictionary, id: String, biome: String, city_name: String = "") -> String:
	var conq: Dictionary = data.get("conquest", {})
	if not (conq.get("owned", []) as Array).has(id):
		return "Ville non conquise."
	if is_ravaged(conq, id):
		return "Ville pillée : impossible de construire."
	if has_wonder(conq, id):
		return "La Merveille est déjà bâtie."
	if city_level(conq, id) < WONDER_MIN_LEVEL:
		return "La ville doit devenir une %s." % level_name(WONDER_MIN_LEVEL)
	var err: String = _pay(data, wonder_cost(biome))
	if err != "":
		return err
	var w: Array = conq.get("wonders", [])
	w.append(id)
	conq["wonders"] = w
	log_event(conq, "★ Merveille bâtie à %s : %s" % [city_name if city_name != "" else id, String(wonder_for(biome)["label"])])
	data["conquest"] = conq
	return ""

## Ressources produites par les Merveilles (villes non pillées ni ruinées).
static func wonder_yield(conq: Dictionary, biomes: Dictionary) -> Dictionary:
	var out: Dictionary = {}
	for id: String in conq.get("wonders", []):
		if not (conq.get("owned", []) as Array).has(id) or is_ravaged(conq, id) or is_ruined(conq, id):
			continue
		var r: Dictionary = wonder_for(String(biomes.get(id, "Forêt"))).get("res", {})
		for k: String in r.keys():
			out[k] = int(out.get(k, 0)) + int(r[k])
	return out

# ─────────────────────────────────────────────────────────────
#  Aspect graphique de la ville (V62) : heure du jour, événements
#  de ville et spécialisation choisie au niveau Cité.
# ─────────────────────────────────────────────────────────────

const DAY_CYCLE := ["jour", "soir", "nuit"]
## Événements de ville (décor + ambiance, sans effet de gameplay) :
## fête (étals + feu), incendie (fumée noire sur un bâtiment), marchand de passage (charrette).
const CITY_EVENTS := ["fete", "incendie", "marchand"]
## Spécialisations choisies au niveau Cité (niveau 3) : changent l'allure de la ville.
const CITY_SPECS := {
	"militaire": {"label": "Cité militaire", "text": "Remparts, casernes et bannières : la ville se hérisse.", "def": 2, "gold": 0, "res": {}},
	"marchande": {"label": "Cité marchande", "text": "Étals, bannières et charrettes : le commerce anime la place.", "def": 0, "gold": 3, "res": {}},
}
const SPEC_MIN_LEVEL := 3

## Heure du jour d'une ville : "jour", "soir" ou "nuit" (cycle lent, déterministe).
static func time_of_day(conq: Dictionary, id: String) -> String:
	var bc: int = int(conq.get("battle_count", 0))
	var idx: int = (bc + _city_index(conq, id)) % DAY_CYCLE.size()
	return DAY_CYCLE[maxi(idx, 0)]

## Avance l'heure de la ville (bouton jour/nuit de l'écran de ville).
static func cycle_time_of_day(conq: Dictionary, id: String) -> String:
	var cur: String = time_of_day(conq, id)
	var idx: int = DAY_CYCLE.find(cur)
	conq["city_time"] = conq.get("city_time", {})
	var t: Dictionary = conq["city_time"]
	t[id] = (idx + 1) % DAY_CYCLE.size()
	return DAY_CYCLE[int(t[id])]

## Heure effective : décalage manuel prioritaire, sinon cycle automatique.
static func effective_time(conq: Dictionary, id: String) -> String:
	var t: Dictionary = conq.get("city_time", {})
	if t.has(id):
		return DAY_CYCLE[int(t[id]) % DAY_CYCLE.size()]
	return time_of_day(conq, id)

static func _city_index(conq: Dictionary, id: String) -> int:
	var owned: Array = conq.get("owned", [])
	var i: int = owned.find(id)
	return i if i >= 0 else 0

## Événement de ville en cours : "" ou "fete" / "incendie" / "marchand".
static func city_event(conq: Dictionary, id: String) -> String:
	var ev: Dictionary = conq.get("city_events", {})
	return String(ev.get(id, ""))

## Déclenche un événement de ville (appelé à l'entrée dans la ville, proba faible).
static func maybe_city_event(conq: Dictionary, id: String, rng: RandomNumberGenerator = null) -> String:
	var r := rng if rng != null else RandomNumberGenerator.new()
	var ev: Dictionary = conq.get("city_events", {})
	if String(ev.get(id, "")) != "":
		return String(ev[id])
	if r.randf() > 0.25:
		return ""
	var pick: String = CITY_EVENTS[r.randi() % CITY_EVENTS.size()]
	ev[id] = pick
	conq["city_events"] = ev
	return pick

## Fait expirer les événements de ville (appelé à chaque victoire).
static func tick_city_events(conq: Dictionary) -> void:
	var ev: Dictionary = conq.get("city_events", {})
	for id: String in ev.keys().duplicate():
		if not (conq.get("owned", []) as Array).has(id):
			ev.erase(id)
			continue
		if randi() % 3 == 0:
			ev.erase(id)
	conq["city_events"] = ev

## Spécialisation de la ville choisie au niveau Cité : "" sinon.
static func city_spec(conq: Dictionary, id: String) -> String:
	return String(conq.get("city_specs", {}).get(id, ""))

## Choisit la spécialisation d'une ville devenue Cité (niveau 3+). "" si OK.
static func choose_spec(data: Dictionary, id: String, spec: String) -> String:
	if not CITY_SPECS.has(spec):
		return "Spécialisation inconnue."
	var conq: Dictionary = data.get("conquest", {})
	if not (conq.get("owned", []) as Array).has(id):
		return "Ville non conquise."
	if city_level(conq, id) < SPEC_MIN_LEVEL:
		return "La ville doit devenir une %s." % level_name(SPEC_MIN_LEVEL)
	if String(conq.get("city_specs", {}).get(id, "")) != "":
		return "Spécialisation déjà choisie."
	var s: Dictionary = conq.get("city_specs", {})
	s[id] = spec
	conq["city_specs"] = s
	data["conquest"] = conq
	log_event(conq, "⚑ %s devient une %s" % [id, String(CITY_SPECS[spec]["label"]).to_lower()])
	return ""

## Bonus de la spécialisation (défense / or par victoire), ville non pillée ni ruinée.
static func spec_bonus(conq: Dictionary, id: String) -> Dictionary:
	var spec: String = city_spec(conq, id)
	if spec == "" or is_ravaged(conq, id) or is_ruined(conq, id):
		return {"def": 0, "gold": 0, "res": {}}
	var s: Dictionary = CITY_SPECS.get(spec, {})
	return {"def": int(s.get("def", 0)), "gold": int(s.get("gold", 0)), "res": s.get("res", {})}

static func hero_level(data: Dictionary, classe: String) -> int:
	return int(data.get("roster", {}).get(classe, {}).get("level", 1))

## Niveau moyen des héros de l'équipe (1 si l'équipe est vide).
static func team_avg_level(data: Dictionary) -> int:
	var total: int = 0
	var n: int = 0
	for m: Dictionary in data.get("team", []):
		total += hero_level(data, String(m.get("classe", "")))
		n += 1
	return maxi(1, int(round(float(total) / float(n)))) if n > 0 else 1

## Avis sur un assaut : niveau moyen de l'équipe contre le niveau conseillé de la ville.
## verdict : "ok" (à portée), "risky" (risqué), "weak" (trop faible).
static func assault_advice(avg_level: int, recommended: int) -> Dictionary:
	var gap: int = recommended - avg_level
	if gap <= 2:
		return {"verdict": "ok", "text": "✔ à votre portée"}
	if gap <= 6:
		return {"verdict": "risky", "text": "⚠ risqué (%d niveaux d'écart)" % gap}
	return {"verdict": "weak", "text": "✖ trop fort (%d niveaux d'écart)" % gap}

## Plus court chemin des villes à conquérir pour atteindre `target` depuis l'empire
## (parcours en largeur sur les routes). Le résultat commence par la ville voisine
## de l'empire et finit par `target` ; vide si la cible est déjà conquise ou inaccessible.
static func path_to(owned: Array, routes: Array, target: String) -> Array:
	if owned.has(target):
		return []
	var prev: Dictionary = {}
	var queue: Array = []
	for o: Variant in owned:
		prev[String(o)] = ""
		queue.append(String(o))
	while not queue.is_empty():
		var cur: String = queue.pop_front()
		if cur == target:
			break
		for pair: Array in routes:
			var a: String = String(pair[0])
			var b: String = String(pair[1])
			var nxt: String = ""
			if a == cur:
				nxt = b
			elif b == cur:
				nxt = a
			if nxt != "" and not prev.has(nxt):
				prev[nxt] = cur
				queue.append(nxt)
	if not prev.has(target):
		return []
	var out: Array = []
	var at: String = target
	while at != "" and not owned.has(at):
		out.push_front(at)
		at = String(prev[at])
	return out

## Équipement du gouverneur : valeur totale de ses objets portés (ItemRules.power).
static func governor_gear_power(data: Dictionary, classe: String) -> int:
	var total: int = 0
	var roster: Dictionary = data.get("roster", {})
	var eq: Dictionary = {}
	for m: Dictionary in data.get("team", []):
		if String(m.get("classe", "")) == classe:
			eq = m.get("equipment", {})
	if eq.is_empty():
		eq = roster.get(classe, {}).get("equipment", {})
	for it: Variant in eq.values():
		if it is Dictionary:
			total += ItemRules.power(it)
	return total

## Bonus de défense apporté par l'équipement du gouverneur (plafonné).
static func governor_gear_defense(data: Dictionary, classe: String) -> int:
	return mini(GEAR_DEF_MAX, governor_gear_power(data, classe) / GEAR_DEF_DIV)

## Bonus d'or par bataille apporté par l'équipement du gouverneur (plafonné).
static func governor_gear_gold(data: Dictionary, classe: String) -> int:
	return mini(GEAR_GOLD_MAX, governor_gear_power(data, classe) / GEAR_GOLD_DIV)

static func governor_text(classe: String) -> String:
	return String(GOVERNOR.get(classe, {}).get("text", "Gouverneur"))

## Défense d'une ville : soldats, niveau, muraille et héros gouverneur.
static func defense(data: Dictionary, id: String) -> int:
	var conq: Dictionary = data.get("conquest", {})
	var d: int = troops(conq, id) * 2 + city_level(conq, id) * 3 + drill_defense(conq)
	d += wall_defense(conq, id)
	if has_wonder(conq, id):
		d += int(wonder_for(_biome_of(id)).get("def", 0))
	var h: String = hero_of(conq, id)
	if h != "":
		d += 6 + int(float(hero_level(data, h)) * 0.5) + int(GOVERNOR.get(h, {}).get("def", 0)) + governor_gear_defense(data, h)
	d += int(spec_bonus(conq, id).get("def", 0))   # spécialisation Cité (V62)
	if united_nations(conq).has(_biome_of(id)):
		d += NATION_UNITED_DEF                         # V151 : Nation unie
	return d

## Or versé par bataille gagnée par une ville (gelé si pillée).
static func city_income(data: Dictionary, id: String) -> int:
	var conq: Dictionary = data.get("conquest", {})
	if is_ravaged(conq, id) or is_ruined(conq, id):
		return 0
	var base: int = (3 if id == "capitale" else 2) * city_level(conq, id)
	if has_wonder(conq, id):
		base += int(wonder_for(_biome_of(id)).get("gold", 0))
	var h: String = hero_of(conq, id)
	if h != "":
		base += 2 + int(GOVERNOR.get(h, {}).get("gold", 0)) + governor_gear_gold(data, h)
	base += int(spec_bonus(conq, id).get("gold", 0))   # spécialisation Cité (V62)
	return base

static func total_income(data: Dictionary) -> int:
	var conq: Dictionary = data.get("conquest", {})
	var t: int = 0
	for id: String in conq.get("owned", []):
		t += city_income(data, id)
	return t

## Facteur de production des bâtiments selon le niveau de la ville.
static func level_multiplier(conq: Dictionary, id: String) -> float:
	return LEVEL_MULT[city_level(conq, id) - 1]

## Biome d'une ville (catalogue de ProgressionManager, lu sans autoload statique).
static func _biome_of(id: String) -> String:
	var loop: MainLoop = Engine.get_main_loop()
	if loop is SceneTree:
		var pm: Node = (loop as SceneTree).root.get_node_or_null("ProgressionManager")
		if pm != null:
			return String(pm.call("conquest_city_biome", id))
	return "Forêt"

## Ressources produites par les héros gouverneurs (villes non pillées).
static func governor_yield(conq: Dictionary) -> Dictionary:
	var out: Dictionary = {}
	for id: String in conq.get("owned", []):
		if is_ravaged(conq, id) or is_ruined(conq, id):
			continue
		var h: String = hero_of(conq, id)
		if h == "":
			continue
		var r: Dictionary = GOVERNOR.get(h, {}).get("res", {})
		for k: String in r.keys():
			out[k] = int(out.get(k, 0)) + int(r[k])
	return out

static func threat(conq: Dictionary) -> Dictionary:
	return conq.get("threat", {})

# ═══════════════════════════════════════════════════════════════════════
#  Actions du joueur
# ═══════════════════════════════════════════════════════════════════════

static func upgrade_cost(conq: Dictionary, id: String) -> Dictionary:
	return UPGRADE.get(city_level(conq, id) + 1, {})

## Améliore une ville. Retourne "" si OK, sinon la raison.
static func upgrade_city(data: Dictionary, id: String, city_name: String = "") -> String:
	var conq: Dictionary = data.get("conquest", {})
	if not (conq.get("owned", []) as Array).has(id):
		return "Ville non conquise."
	if is_ravaged(conq, id):
		return "Ville pillée : impossible de l'améliorer."
	if city_level(conq, id) >= MAX_LEVEL:
		return "Cette ville est déjà une %s." % level_name(MAX_LEVEL)
	var cost: Dictionary = upgrade_cost(conq, id)
	var res: Dictionary = data.get("resources", {})
	for k: String in cost.get("res", {}).keys():
		if int(res.get(k, 0)) < int(cost["res"][k]):
			return "Ressource insuffisante : %s (%d/%d)." % [k, int(res.get(k, 0)), int(cost["res"][k])]
	if int(data.get("gold", 0)) < int(cost.get("gold", 0)):
		return "Or insuffisant : %d pièces requises." % int(cost.get("gold", 0))
	for k: String in cost.get("res", {}).keys():
		res[k] = int(res.get(k, 0)) - int(cost["res"][k])
	data["resources"] = res
	data["gold"] = int(data.get("gold", 0)) - int(cost.get("gold", 0))
	var lv: Dictionary = conq.get("city_levels", {})
	lv[id] = city_level(conq, id) + 1
	conq["city_levels"] = lv
	log_event(conq, "Ville améliorée : %s devient un %s" % [city_name if city_name != "" else id, level_name(int(lv[id]))])
	data["conquest"] = conq
	return ""

## Recrute n soldats (30 or pièce) dans la garnison, dans la limite de la place.
static func recruit(data: Dictionary, id: String, n: int) -> String:
	var conq: Dictionary = data.get("conquest", {})
	if not (conq.get("owned", []) as Array).has(id):
		return "Ville non conquise."
	var room: int = garrison_cap(conq, id) - troops(conq, id)
	if room <= 0:
		return "Garnison pleine (%d/%d) : améliorez la ville pour l'agrandir." % [troops(conq, id), garrison_cap(conq, id)]
	var count: int = mini(n, room)
	var cost: int = count * TROOP_COST
	if int(data.get("gold", 0)) < cost:
		return "Or insuffisant : %d pièces requises." % cost
	data["gold"] = int(data.get("gold", 0)) - cost
	_set_garrison(conq, id, troops(conq, id) + count, hero_of(conq, id))
	data["conquest"] = conq
	return ""

static func assign_hero(data: Dictionary, id: String, classe: String) -> String:
	var conq: Dictionary = data.get("conquest", {})
	if not (conq.get("owned", []) as Array).has(id):
		return "Ville non conquise."
	if not GOVERNOR.has(classe):
		return "Héros inconnu."
	if not HeroUnlock.is_unlocked(data, classe):
		return "%s n'est pas encore débloqué." % classe
	if hero_of(conq, id) != "":
		return "Cette ville a déjà un gouverneur."
	if stationed_heroes(conq).size() >= 6:
		return "Trop de gouverneurs : 3 héros doivent rester disponibles pour les assauts."
	var elsewhere: String = hero_city(conq, classe)
	if elsewhere != "":
		return "%s gouverne déjà une autre ville." % classe
	_set_garrison(conq, id, troops(conq, id), classe)
	data["conquest"] = conq
	return ""

static func recall_hero(data: Dictionary, id: String) -> String:
	var conq: Dictionary = data.get("conquest", {})
	if hero_of(conq, id) == "":
		return "Aucun gouverneur dans cette ville."
	_set_garrison(conq, id, troops(conq, id), "")
	data["conquest"] = conq
	return ""

# ═════════════════════════════════════════════════════════════════════════════
#  Lieutenance — missions des héros libres
# ═════════════════════════════════════════════════════════════════════════════

## Héros en mission : {classe -> {"type": mission_id, "eta": batailles restantes}}.
static func missions(conq: Dictionary) -> Dictionary:
	return conq.get("missions", {})

static func hero_on_mission(conq: Dictionary, classe: String) -> Dictionary:
	return missions(conq).get(classe, {})

## Héros indisponibles (gouverneurs + en mission), pour la sélection d'équipe
## et le choix des gouverneurs.
static func busy_heroes(conq: Dictionary) -> Array:
	var out: Array = stationed_heroes(conq)
	for classe: String in missions(conq).keys():
		if not out.has(classe):
			out.append(classe)
	return out

## Types de missions disponibles (tous peuvent être tentés à tout moment).
static func mission_types() -> Array:
	return MISSION_TYPES.keys()

static func mission_text(type_id: String) -> String:
	return String(MISSION_TYPES.get(type_id, {}).get("text", ""))

static func mission_label(type_id: String) -> String:
	return String(MISSION_TYPES.get(type_id, {}).get("label", "Mission"))

## Envoie un héros libre en mission de 3 batailles. Retourne "" si OK.
static func send_mission(conq: Dictionary, classe: String, type_id: String, data: Dictionary = {}) -> String:
	if not GOVERNOR.has(classe):
		return "Héros inconnu."
	if not data.is_empty() and not HeroUnlock.is_unlocked(data, classe):
		return "%s n'est pas encore débloqué." % classe
	if not MISSION_TYPES.has(type_id):
		return "Mission inconnue."
	if hero_city(conq, classe) != "":
		return "%s gouverne déjà une ville." % classe
	if not hero_on_mission(conq, classe).is_empty():
		return "%s est déjà en mission." % classe
	var m: Dictionary = missions(conq)
	m[classe] = {"type": type_id, "eta": MISSION_BATTLES}
	conq["missions"] = m
	return ""

## Villes révélées par une Cartographie selon le niveau du héros : 1, puis 2 dès le
## niveau 15 et 3 dès le niveau 40 (maximum).
static func cartography_count(hero_lvl: int) -> int:
	return 1 + (1 if hero_lvl >= 15 else 0) + (1 if hero_lvl >= 40 else 0)

## Annule les missions de héros pas encore débloqués (anciennes sauvegardes) ;
## retourne les classes rappelées.
static func cancel_locked_missions(data: Dictionary) -> Array:
	var conq: Dictionary = data.get("conquest", {})
	var m: Dictionary = missions(conq)
	var out: Array = []
	for classe: String in m.keys().duplicate():
		if not HeroUnlock.is_unlocked(data, classe):
			m.erase(classe)
			out.append(classe)
	if not out.is_empty():
		conq["missions"] = m
		data["conquest"] = conq
	return out

## Rappelle un héros de sa mission (il revient bredouille, sans récompense).
static func abort_mission(conq: Dictionary, classe: String) -> String:
	if hero_on_mission(conq, classe).is_empty():
		return "Aucune mission en cours pour ce héros."
	var m: Dictionary = missions(conq)
	m.erase(classe)
	conq["missions"] = m
	return ""

## Fait avancer les missions d'une bataille et règle les retours. Les villes
## révélées sont ajoutées à adventure.revealed_cities (pont inter-modes) par
## ProgressionManager, qui passe les candidates ici.
static func _tick_missions(data: Dictionary, conq: Dictionary, rng: RandomNumberGenerator,
		unrevealed: Array, routes: Array = []) -> void:
	var m: Dictionary = missions(conq)
	if m.is_empty():
		return
	for classe: String in m.keys().duplicate():
		var job: Dictionary = m[classe]
		job["eta"] = int(job.get("eta", 1)) - 1
		if int(job["eta"]) > 0:
			m[classe] = job
			continue
		m.erase(classe)
		var type: String = String(job.get("type", "caravane"))
		if type == "infiltration":
			note(conq, "⚑ %s revient de l'infiltration : il reprend sa place au combat." % classe)
			continue
		var info: Dictionary = MISSION_TYPES.get(type, {})
		var lvl: int = hero_level(data, classe)
		if rng.randf() < MISSION_CHANCE:
			var loss: int = 10 + lvl
			data["gold"] = maxi(0, int(data.get("gold", 0)) - loss)
			note(conq, "⚑ %s revient de « %s » bredouille : l'expédition a coûté %d or." % [classe, mission_label(type), loss])
			continue
		var gold: int = int(info.get("gold", 0)) + lvl * 2
		if gold > 0:
			data["gold"] = int(data.get("gold", 0)) + gold
		var drops: Dictionary = {}
		for r: String in info.get("res", {}).keys():
			drops[r] = int(info["res"][r]) + int(lvl / 3.0)
		if not drops.is_empty():
			_add_res(data, drops)
		var revealed: Array = []
		if int(info.get("reveal", 0)) > 0 and not unrevealed.is_empty():
			# Les terres les plus proches de l'empire d'abord (une à une), puis par identifiant.
			var owned_now: Array = conq.get("owned", [])
			var order: Array = unrevealed.duplicate()
			order.sort_custom(func(a: String, b: String) -> bool:
				var da: int = path_to(owned_now, routes, a).size() if not routes.is_empty() else 0
				var db: int = path_to(owned_now, routes, b).size() if not routes.is_empty() else 0
				if da != db:
					return da < db
				return a < b)
			for i: int in range(mini(cartography_count(lvl), order.size())):
				revealed.append(order[i])
			if not revealed.is_empty():
				var so_far: Array = conq.get("missions_revealed", [])
				for cid: String in revealed:
					if not so_far.has(cid):
						so_far.append(cid)
				conq["missions_revealed"] = so_far
		var parts: Array = ["+%d or" % gold]
		for r: String in drops.keys():
			parts.append("+%d %s" % [int(drops[r]), r])
		if not revealed.is_empty():
			var rnames: Array = []
			for cid: String in revealed:
				rnames.append(_name(conq, cid))
			parts.append("révèle %s" % ", ".join(PackedStringArray(rnames)))
		note(conq, "⚑ %s revient de « %s » : %s." % [classe, mission_label(type), ", ".join(PackedStringArray(parts))])
	conq["missions"] = m

# ═════════════════════════════════════════════════════════════════════════════
#  Généraux du Roi Squelette
# ═════════════════════════════════════════════════════════════════════════════

## Général tenant cette ville, ou "" (vide une fois la ville annexée : le
## général est vaincu quand sa forteresse tombe).
static func general_of(conq: Dictionary, id: String) -> String:
	if (conq.get("owned", []) as Array).has(id):
		return ""
	return String(GENERALS.get(id, {}).get("name", ""))

## Généraux encore en vie (leur forteresse n'est pas conquise).
static func living_generals(conq: Dictionary) -> Array:
	var out: Array = []
	for cid: String in GENERALS.keys():
		if general_of(conq, cid) != "":
			out.append(cid)
	return out

static func living_generals_count(conq: Dictionary) -> int:
	return living_generals(conq).size()

static func general_region(id: String) -> String:
	return String(GENERALS.get(id, {}).get("region", ""))

## Bonus de niveau des batailles de siège tant que le général tient sa
## forteresse (appliqué par GameManager à la difficulté, affiché sur la carte).
static func general_defense_bonus(conq: Dictionary, id: String) -> int:
	return GENERAL_DEF_BONUS if general_of(conq, id) != "" else 0

## Nom du boss de la 4e bataille du siège d'une forteresse de général.
## Vide pour une ville ordinaire (le boss du biome reste utilisé).
static func general_boss_name(conq: Dictionary, id: String) -> String:
	return general_of(conq, id)

## Les généraux vivants lancent parfois leur propre offensive, plus forte que
## les offensives anonymes (réutilise le système threat, avec un visage).
static func _maybe_general_threat(data: Dictionary, conq: Dictionary, rng: RandomNumberGenerator,
		routes: Array, just_conquered: String) -> void:
	if not threat(conq).is_empty():
		return
	var alive: Array = living_generals(conq)
	if alive.is_empty() or rng.randf() > GENERAL_THREAT_CHANCE:
		return
	var pool: Array = _target_pool(conq, routes, just_conquered, true)
	if pool.is_empty():
		return
	var id: String = String(pool[rng.randi_range(0, pool.size() - 1)])
	var power: int = roundi((8.0 + 2.0 * float(owned_count(conq)) + float(int(conq.get("battle_count", 0))) / 3.0) * rng.randf_range(0.95, 1.25)) + GENERAL_THREAT_BONUS
	var gid: String = String(alive[rng.randi_range(0, alive.size() - 1)])
	var gname: String = String(GENERALS.get(gid, {}).get("name", ""))
	conq["threat"] = {"city": id, "power": power, "eta": THREAT_ETA, "general": gname}
	conq["threat_cd"] = 0
	note(conq, "☠ %s, général du Roi Squelette, prépare une offensive (force %d) sur %s dans %d batailles !" % [gname, power, _name(conq, id), THREAT_ETA])

# ═════════════════════════════════════════════════════════════════════════════
#  Plans d'assalt (sièges ennemis)
# ═════════════════════════════════════════════════════════════════════════════

## Coût en or du plan d'assaut (0 pour l'assaut direct).
static func plan_cost(plan: String) -> int:
	return int(PLAN_COST.get(plan, 0))

## L'infiltration exige l'Assassin libre (ni gouverneur ni en mission).
static func infiltration_ready(conq: Dictionary) -> bool:
	return hero_city(conq, "Assassin") == "" and hero_on_mission(conq, "Assassin").is_empty()

## Applique un plan d'assaut au lancement du siège : débite l'or, engage
## l'Assassin si besoin, retourne {"error": raison} en cas de refus.
## Retour {"skipped": true} si le plan fait avancer le siège d'une vague sans
## combat (blocus / infiltration) ; l'Assassin revient après 1 bataille.
static func apply_plan(data: Dictionary, conq: Dictionary, id: String, plan: String, rng: RandomNumberGenerator) -> Dictionary:
	if (conq.get("owned", []) as Array).has(id):
		return {"error": "Ville déjà conquise."}
	match plan:
		"direct":
			return {"skipped": false}
		"blocus":
			var cost: int = plan_cost("blocus")
			if int(data.get("gold", 0)) < cost:
				return {"error": "Or insuffisant : %d pièces requises." % cost}
			data["gold"] = int(data.get("gold", 0)) - cost
			if rng.randf() < PLAN_RAID_CHANCE:
				var pool: Array = _target_pool(conq, [], "", true)
				if not pool.is_empty():
					var rid: String = String(pool[rng.randi_range(0, pool.size() - 1)])
					var r: Dictionary = conq.get("ravage", {})
					r[rid] = RAVAGE_BATTLES
					conq["ravage"] = r
					note(conq, "Le blocus de %s agace l'ennemi : %s est pillée (%d batailles) !" % [_name(conq, id), _name(conq, rid), RAVAGE_BATTLES])
			else:
				note(conq, "Le blocus de %s resserre l'étau : une vague saute sans combat." % _name(conq, id))
			return {"skipped": true}
		"infiltration":
			if not infiltration_ready(conq):
				return {"error": "L'Assassin doit être libre (ni gouverneur ni en mission)."}
			var cost2: int = plan_cost("infiltration")
			if int(data.get("gold", 0)) < cost2:
				return {"error": "Or insuffisant : %d pièces requises." % cost2}
			data["gold"] = int(data.get("gold", 0)) - cost2
			var m: Dictionary = missions(conq)
			m["Assassin"] = {"type": "infiltration", "eta": 1}
			conq["missions"] = m
			note(conq, "L'Assassin s'infiltre dans %s : une vague ennemie est sabordée de l'intérieur. Il revient à la prochaine victoire." % _name(conq, id))
			return {"skipped": true}
	return {"error": "Plan d'assaut inconnu."}

# ═════════════════════════════════════════════════════════════════════════════
#  Reconquête ennemie : garnisons adverses croissantes
# ═════════════════════════════════════════════════════════════════════════════

## Garnison adverse d'une ville non possédée (0 pour une ville possédée).
## Elle monte de 1 toutes les GARRISON_EVERY victoires du joueur, max GARRISON_MAX.
static func enemy_garrison(conq: Dictionary, id: String) -> int:
	if (conq.get("owned", []) as Array).has(id):
		return 0
	var battles: int = int(conq.get("battle_count", 0))
	return mini(GARRISON_MAX, int(battles / float(GARRISON_EVERY)))

## Bonus de niveau des batailles contre une ville défendue (+1 par tranche de 2
## soldats adverses) : attendre une cible la rend plus dure.
static func enemy_garrison_bonus(conq: Dictionary, id: String) -> int:
	return int(enemy_garrison(conq, id) / 2.0)

# ═════════════════════════════════════════════════════════════════════════════
#  Diplomatie — annexion négociée des villes neutres
# ═════════════════════════════════════════════════════════════════════════════

## Coût de l'annexion négociée d'une ville neutre : or + la ressource
## spécialité de la ville (CITY_TRAITS), payable en une fois.
static func diplomacy_cost(conq: Dictionary, id: String, level: int = 0) -> Dictionary:
	var res_key: String = ""
	var spec: Dictionary = CITY_TRAITS.get(id, {})
	if not spec.get("res", {}).is_empty():
		res_key = String(spec.get("res", {}).keys()[0])
	if res_key == "":
		res_key = "Bois"
	return {"gold": DIPLO_GOLD + maxi(0, level) * DIPLO_GOLD_PER_LEVEL, "res": {res_key: DIPLO_RES + int(float(maxi(0, level)) * DIPLO_RES_PER_LEVEL)}}


## Victoires restantes avant de pouvoir négocier à nouveau (0 = possible).
static func diplomacy_cooldown(conq: Dictionary) -> int:
	return maxi(0, int(conq.get("diplo_cd", 0)))

## Annexe une ville neutre par négociation (voie pacifique). Retourne "" si OK.
## routes : CONQUEST_ROUTES — la ville doit être atteignable (même règle que
## l'assaut : reliée au territoire). names : id -> nom, pour le journal.
static func negotiate_city(data: Dictionary, conq: Dictionary, id: String,
		routes: Array, names: Dictionary, level: int = 0) -> String:
	if (conq.get("owned", []) as Array).has(id):
		return "Ville déjà conquise."
	if diplomacy_cooldown(conq) > 0:
		return "Les émissaires sont encore en route : nouvelle négociation dans %d victoire(s)." % diplomacy_cooldown(conq)
	conq["_names"] = names
	var owned: Array = conq.get("owned", [])
	var linked: bool = false
	for pair: Array in routes:
		var a: String = String(pair[0])
		var b: String = String(pair[1])
		if (a == id and owned.has(b)) or (b == id and owned.has(a)):
			linked = true
			break
	if not linked:
		conq.erase("_names")
		return "Aucune route depuis votre territoire : conquérez d'abord une ville voisine."
	var cost: Dictionary = diplomacy_cost(conq, id, level)
	var res: Dictionary = data.get("resources", {})
	for k: String in cost.get("res", {}).keys():
		if int(res.get(k, 0)) < int(cost["res"][k]):
			conq.erase("_names")
			return "Ressource insuffisante : %s (%d/%d)." % [k, int(res.get(k, 0)), int(cost["res"][k])]
	if int(data.get("gold", 0)) < int(cost.get("gold", 0)):
		conq.erase("_names")
		return "Or insuffisant : %d pièces requises." % int(cost.get("gold", 0))
	for k: String in cost.get("res", {}).keys():
		res[k] = int(res.get(k, 0)) - int(cost["res"][k])
	data["resources"] = res
	data["gold"] = int(data.get("gold", 0)) - int(cost.get("gold", 0))
	owned.append(id)
	conq["owned"] = owned
	var dip: Array = conq.get("annexed_diplomacy", [])
	if not dip.has(id):
		dip.append(id)
	conq["annexed_diplomacy"] = dip
	conq["diplo_cd"] = DIPLO_COOLDOWN
	conq["just_annexed"] = id
	note(conq, "☮ %s rejoint l'empire par négociation : l'or a parlé plus fort que les armes." % _name(conq, id))
	conq.erase("_names")
	return ""

# ═════════════════════════════════════════════════════════════════════════════
#  Ruine & reconstruction
# ═════════════════════════════════════════════════════════════════════════════

## Une ville perdue puis reprise reste ruinée : niveau -1 (min 1, reflété par
## _ruin_level) et production gelée RUIN_BATTLES.
static func is_ruined(conq: Dictionary, id: String) -> bool:
	return int(conq.get("ruin", {}).get(id, 0)) > 0

## La ruine décrémente à chaque victoire ; réparée, elle disparaît.
static func _tick_ruins(conq: Dictionary) -> void:
	var ruins: Dictionary = conq.get("ruin", {})
	if ruins.is_empty():
		return
	for id: String in ruins.keys().duplicate():
		if not (conq.get("owned", []) as Array).has(id):
			continue
		ruins[id] = int(ruins.get(id, 0)) - 1
		if int(ruins[id]) <= 0:
			ruins.erase(id)
			note(conq, "⚒ %s se relève de ses ruines : production reprise." % _name(conq, id))
	conq["ruin"] = ruins

## Répare une ville ruinée (80 or) : la production reprend. Retourne "" si OK.
static func repair_city(data: Dictionary, conq: Dictionary, id: String) -> String:
	if not is_ruined(conq, id):
		return "Cette ville n'est pas ruinée."
	if int(data.get("gold", 0)) < RUIN_REPAIR_GOLD:
		return "Or insuffisant : %d pièces requises." % RUIN_REPAIR_GOLD
	data["gold"] = int(data.get("gold", 0)) - RUIN_REPAIR_GOLD
	var ruins: Dictionary = conq.get("ruin", {})
	ruins.erase(id)
	conq["ruin"] = ruins
	return ""

# ═════════════════════════════════════════════════════════════════════════════
#  Légende — score de fin de campagne et fins multiples
# ═════════════════════════════════════════════════════════════════════════════

## Détail du score de Légende (clé -> points). stones : nombre de Pierres
## Élémentaires du joueur (fourni par ProgressionManager depuis Stones).
static func legend_score(conq: Dictionary, stones: int) -> Dictionary:
	var w: Dictionary = LEGEND_WEIGHTS
	var out: Dictionary = {"villes": 0, "niveaux": 0, "gouverneurs": 0, "pierres": 0, "diplomatie": 0, "ruines": 0}
	out["villes"] = owned_count(conq) * int(w["villes"])
	var lv: int = 0
	for id: String in conq.get("owned", []):
		lv += maxi(0, city_level(conq, id) - 1)
	out["niveaux"] = lv * int(w["niveaux"])
	out["gouverneurs"] = stationed_heroes(conq).size() * int(w["gouverneurs"])
	out["pierres"] = stones * int(w["pierres"])
	out["diplomatie"] = (conq.get("annexed_diplomacy", []) as Array).size() * int(w["diplomatie"])
	var ruined: int = 0
	for id: String in conq.get("owned", []):
		if is_ruined(conq, id):
			ruined += 1
	out["ruines"] = ruined * int(w["ruines"])
	return out

static func legend_total(score: Dictionary) -> int:
	var total: int = 0
	for k: String in score.keys():
		total += int(score[k])
	return total

## Fin de campagne selon le score : trois légendes possibles à la chute du
## Donjon. Le style de jeu (diplomatie, développement, Pierres) décide de la
## fin, pas seulement le fait de gagner.
static func legend_ending(score: Dictionary, conq: Dictionary) -> Dictionary:
	var dip: int = (conq.get("annexed_diplomacy", []) as Array).size()
	var neutral_total: int = 0
	for id: String in conq.get("owned", []):
		if id != "capitale" and id != "donjon_roi":
			neutral_total += 1
	if dip >= 4:
		return {"id": "marchand", "title": "EMPIRE MARCHAND",
			"text": "L'or a conquis plus de villes que le fer. Les routes de Zimut sont à vous, les comptoirs affluent : sous votre règne, le commerce a remplacé la guerre."}
	if int(score.get("niveaux", 0)) >= 40 and int(score.get("gouverneurs", 0)) >= 12:
		return {"id": "bastion", "title": "BASTION DE ZIMUT",
			"text": "Chaque ville est une forteresse, chaque gouverneur un rempart. Les Nations se souviendront longtemps de celui qui a rendu l'empire imprenable."}
	return {"id": "heros", "title": "ÂGE DES HÉROS",
		"text": "Vos héros ont mené chaque assaut, vaincu les généraux et le Roi Squelette en personne. Les bardes de Zimut chanteront leurs noms pendant des siècles."}

## Épilogue récapitulatif (affiché à la chute du Donjon) : score, détail et fin.
static func epilogue(score: Dictionary, ending: Dictionary) -> String:
	var lines: PackedStringArray = []
	lines.append("%s — %d points de Légende" % [String(ending.get("title", "")), legend_total(score)])
	lines.append("")
	lines.append("Villes %d · Développement +%d · Gouverneurs +%d" % [int(score.get("villes", 0)), int(score.get("niveaux", 0)), int(score.get("gouverneurs", 0))])
	lines.append("Pierres +%d · Diplomatie +%d · Ruines %d" % [int(score.get("pierres", 0)), int(score.get("diplomatie", 0)), int(score.get("ruines", 0))])
	lines.append("")
	lines.append(String(ending.get("text", "")))
	return "\n".join(lines)

static func _set_garrison(conq: Dictionary, id: String, n: int, hero: String) -> void:
	var g: Dictionary = conq.get("garrisons", {})
	g[id] = {"troops": clampi(n, 0, garrison_cap(conq, id)), "hero": hero}
	conq["garrisons"] = g

# ═══════════════════════════════════════════════════════════════════════
#  Journal
# ═══════════════════════════════════════════════════════════════════════

static func log_event(conq: Dictionary, text: String) -> void:
	var events: Array = conq.get("events", [])
	events.append(text)
	while events.size() > 10:
		events.pop_front()
	conq["events"] = events

## Nouvelle affichée au retour sur la carte, et gardée dans la chronique.
static func note(conq: Dictionary, text: String) -> void:
	var news: Array = conq.get("news", [])
	news.append(text)
	conq["news"] = news
	log_event(conq, text)

static func _add_res(data: Dictionary, drops: Dictionary) -> void:
	var res: Dictionary = data.get("resources", {})
	for k: String in drops.keys():
		res[k] = int(res.get(k, 0)) + int(drops[k])
	data["resources"] = res

## Noms de villes (renseignés une fois par ProgressionManager au démarrage).
static var city_names: Dictionary = {}

static func _name(conq: Dictionary, id: String) -> String:
	return String(conq.get("_names", city_names).get(id, city_names.get(id, id)))

# ═══════════════════════════════════════════════════════════════════════
#  Boucle après chaque victoire
# ═══════════════════════════════════════════════════════════════════════

## names : id -> nom de ville (fourni par ProgressionManager pour les messages).
## routes : CONQUEST_ROUTES (pour repérer les villes frontalières).
## unrevealed : villes que la cartographie peut révéler (pont Aventure).
static func after_victory(data: Dictionary, conq: Dictionary, rng: RandomNumberGenerator,
		routes: Array, names: Dictionary, just_conquered: String, unrevealed: Array = []) -> void:
	conq["_names"] = names
	conq["news"] = []
	conq["battle_count"] = int(conq.get("battle_count", 0)) + 1
	conq["last_counterattack"] = ""
	data["conquest"] = conq
	_collect_income(data, conq)
	_regen_garrisons(data, conq)
	_tick_threat(data, conq, rng)
	_tick_missions(data, conq, rng, unrevealed, routes)
	_tick_chancellor_buffs(conq)
	_tick_ruins(conq)
	tick_city_events(conq)   # V62 : les événements de ville s'éteignent avec le temps
	if int(conq.get("diplo_cd", 0)) > 0:
		conq["diplo_cd"] = int(conq["diplo_cd"]) - 1
	maybe_chancellor(conq)
	if int(conq.get("truce", 0)) > 0:
		conq["truce"] = int(conq["truce"]) - 1
	else:
		_roll_raid(data, conq, rng, routes, just_conquered)
		_maybe_spawn_threat(data, conq, rng, routes, just_conquered)
		_maybe_general_threat(data, conq, rng, routes, just_conquered)
	_maybe_event(data, conq, rng, routes, just_conquered)
	conq.erase("_names")
	data["conquest"] = conq

static func _collect_income(data: Dictionary, conq: Dictionary) -> void:
	var gold: int = total_income(data)
	if gold > 0:
		data["gold"] = int(data.get("gold", 0)) + gold
	conq["last_income"] = gold

static func _regen_garrisons(data: Dictionary, conq: Dictionary) -> void:
	for id: String in conq.get("owned", []):
		var h: String = hero_of(conq, id)
		if h == "" or is_ravaged(conq, id):
			continue
		var heal: int = int(GOVERNOR.get(h, {}).get("heal", 0))
		if heal > 0 and troops(conq, id) < garrison_cap(conq, id):
			_set_garrison(conq, id, troops(conq, id) + heal, h)

## Villes possédées pouvant être visées (ni la capitale, ni le Donjon, ni la
## ville fraîchement conquise), les villes frontalières comptant triple.
static func _target_pool(conq: Dictionary, routes: Array, just_conquered: String, skip_ravaged: bool) -> Array:
	var owned: Array = conq.get("owned", [])
	var pool: Array = []
	for id: String in owned:
		if id == "capitale" or id == "donjon_roi" or id == just_conquered:
			continue
		if skip_ravaged and is_ravaged(conq, id):
			continue
		var weight: int = 1
		for pair: Array in routes:
			var other: String = ""
			if String(pair[0]) == id:
				other = String(pair[1])
			elif String(pair[1]) == id:
				other = String(pair[0])
			if other != "" and not owned.has(other):
				weight = 3
				break
		for i: int in range(weight):
			pool.append(id)
	return pool

static func owned_count(conq: Dictionary) -> int:
	var n: int = 0
	for id: String in conq.get("owned", []):
		if id != "capitale" and id != "donjon_roi":
			n += 1
	return n

# ── Raids : petites attaques, contrées par la garnison ──────────────────
static func raid_power(conq: Dictionary) -> int:
	return 4 + int(float(owned_count(conq)) * 0.5)

static func _roll_raid(data: Dictionary, conq: Dictionary, rng: RandomNumberGenerator,
		routes: Array, just_conquered: String) -> void:
	if rng.randf() > RAID_CHANCE:
		return
	var pool: Array = _target_pool(conq, routes, just_conquered, true)
	if pool.is_empty():
		return
	var id: String = String(pool[rng.randi_range(0, pool.size() - 1)])
	if defense(data, id) >= raid_power(conq):
		var t: int = troops(conq, id)
		if t > 0:
			_set_garrison(conq, id, t - 1, hero_of(conq, id))
		note(conq, "♜ Raid repoussé à %s : la garnison tient bon." % _name(conq, id))
		return
	var r: Dictionary = conq.get("ravage", {})
	r[id] = RAVAGE_BATTLES
	conq["ravage"] = r
	conq["last_counterattack"] = id
	note(conq, "Contre-attaque : %s est pillée (%d batailles)" % [_name(conq, id), RAVAGE_BATTLES])

# ── Offensives annoncées ─────────────────────────────────────────────────
static func _maybe_spawn_threat(data: Dictionary, conq: Dictionary, rng: RandomNumberGenerator,
		routes: Array, just_conquered: String) -> void:
	if not threat(conq).is_empty():
		return
	conq["threat_cd"] = int(conq.get("threat_cd", 0)) + 1
	if owned_count(conq) < 3 or int(conq["threat_cd"]) < THREAT_MIN_GAP or rng.randf() > THREAT_CHANCE:
		return
	var pool: Array = _target_pool(conq, routes, just_conquered, true)
	if pool.is_empty():
		return
	var id: String = String(pool[rng.randi_range(0, pool.size() - 1)])
	var power: int = roundi((8.0 + 2.0 * float(owned_count(conq)) + float(int(conq.get("battle_count", 0))) / 3.0) * rng.randf_range(0.85, 1.15))
	conq["threat"] = {"city": id, "power": power, "eta": THREAT_ETA}
	conq["threat_cd"] = 0
	note(conq, "⚠ GRANDE OFFENSIVE ennemie (force %d) : %s sera attaquée dans %d batailles !" % [power, _name(conq, id), THREAT_ETA])

static func _tick_chancellor_buffs(conq: Dictionary) -> void:
	if int(conq.get("drill", 0)) > 0:
		conq["drill"] = int(conq["drill"]) - 1
	if int(conq.get("roadworks", 0)) > 0:
		conq["roadworks"] = int(conq["roadworks"]) - 1

static func _tick_threat(data: Dictionary, conq: Dictionary, rng: RandomNumberGenerator) -> void:
	var th: Dictionary = threat(conq)
	if th.is_empty():
		return
	var id: String = String(th.get("city", ""))
	if not (conq.get("owned", []) as Array).has(id):
		conq.erase("threat")
		return
	th["eta"] = int(th.get("eta", 1)) - 1
	if int(th["eta"]) > 0:
		conq["threat"] = th
		note(conq, "⚠ Offensive (force %d) sur %s : encore %d bataille(s). Défense actuelle : %d." % [
			int(th["power"]), _name(conq, id), int(th["eta"]), defense(data, id)])
		return
	conq.erase("threat")
	resolve_assault(data, conq, id, int(th.get("power", 10)))

# ── Nation unie (V151) ───────────────────────────────────────────────────
# Tenir TOUTES les villes d'une Nation donne sa Bannière : un bonus pour tous les héros, valable dans les trois
# modes (appliqué dans ProgressionManager.member_stats), et +NATION_UNITED_DEF de défense à ses villes. Perdre
# une seule ville suspend la Bannière jusqu'à sa reprise.

const NATION_UNITED_DEF := 5
const NATION_BANNERS := {
	"Forêt": {"name": "Bannière de la Sylve", "stats": {"vita": 20}, "fx": {"heal_pct": 5}},
	"Montagne": {"name": "Bannière des Cimes", "stats": {"defense": 4}, "fx": {"mres": 5}},
	"Brasier": {"name": "Bannière du Brasier", "stats": {"force": 4}, "fx": {"phys_pct": 5}},
	"Brumes": {"name": "Bannière des Brumes", "stats": {"intelligence": 4}, "fx": {"mag_pct": 5}},
	"Désert": {"name": "Bannière des Sables", "stats": {"agility": 4}, "fx": {"crit": 3}},
	"Cristaux": {"name": "Bannière des Cristaux", "stats": {"wisdom": 4}, "fx": {"mag_pct": 3}},
	"Marées": {"name": "Bannière des Marées", "stats": {"vita": 15}, "fx": {"lifesteal": 3}},
	"Vents": {"name": "Bannière des Vents", "stats": {"agility": 5}, "fx": {"crit": 2}},
	"Ombres": {"name": "Bannière des Ombres", "stats": {"force": 3}, "fx": {"crit": 4}},
	"Rouages": {"name": "Bannière des Rouages", "stats": {"defense": 3}, "fx": {"phys_pct": 3}},
}

## Villes de chaque Nation (catalogue de ProgressionManager), hors Donjon du Roi.
static func nation_cities(nation: String) -> Array:
	var loop: MainLoop = Engine.get_main_loop()
	if loop is SceneTree:
		var pm: Node = (loop as SceneTree).root.get_node_or_null("ProgressionManager")
		if pm != null:
			return pm.call("conquest_nation_cities", nation)
	return []

## Nations dont toutes les villes sont à l'empire.
static func united_nations(conq: Dictionary) -> Array:
	var owned: Array = conq.get("owned", [])
	var out: Array = []
	for n: String in NATION_BANNERS.keys():
		var cities: Array = nation_cities(n)
		if cities.is_empty():
			continue
		var all_in := true
		for c: String in cities:
			if not owned.has(c):
				all_in = false
				break
		if all_in:
			out.append(n)
	return out

## Villes tenues / total pour une Nation.
static func nation_progress(conq: Dictionary, nation: String) -> Vector2i:
	var owned: Array = conq.get("owned", [])
	var cities: Array = nation_cities(nation)
	var n: int = 0
	for c: String in cities:
		if owned.has(c):
			n += 1
	return Vector2i(n, cities.size())

## Bonus cumulé des Bannières actives, au format des Pierres ({stats, fx}).
static func banners_bonus(conq: Dictionary) -> Dictionary:
	var stats: Dictionary = {}
	var fx: Dictionary = {}
	for n: String in united_nations(conq):
		var b: Dictionary = NATION_BANNERS[n]
		for k: String in (b["stats"] as Dictionary).keys():
			stats[k] = int(stats.get(k, 0)) + int(b["stats"][k])
		for k2: String in (b["fx"] as Dictionary).keys():
			fx[k2] = int(fx.get(k2, 0)) + int(b["fx"][k2])
	return {"stats": stats, "fx": fx}

## Texte du bonus d'une Bannière (« PV +20, Soins +5 % »).
static func banner_text(nation: String) -> String:
	var b: Dictionary = NATION_BANNERS.get(nation, {})
	var parts: PackedStringArray = []
	for k: String in (b.get("stats", {}) as Dictionary).keys():
		parts.append("%s +%d" % [String(Stones.STAT_LABEL.get(k, k)), int(b["stats"][k])])
	for k2: String in (b.get("fx", {}) as Dictionary).keys():
		parts.append(String(Stones.FX_LABEL.get(k2, k2 + " +%d")) % int(b["fx"][k2]))
	return ", ".join(parts)

## Annonce les Nations nouvellement unies (une seule fois chacune) ; renvoie leurs noms.
static func announce_united(conq: Dictionary) -> Array:
	var done: Array = conq.get("nations_announced", [])
	var fresh: Array = []
	for n: String in united_nations(conq):
		if not done.has(n):
			done.append(n)
			fresh.append(n)
			note(conq, "★ NATION UNIE : toutes les villes %s sont à vous ! %s pour tous vos héros, dans les trois modes : %s. Ses villes gagnent +%d de défense." % [
				_nation_de(n), String(NATION_BANNERS[n]["name"]), banner_text(n), NATION_UNITED_DEF])
	conq["nations_announced"] = done
	return fresh

static func _nation_de(n: String) -> String:
	return {"Forêt": "de la Sylve", "Montagne": "des Cimes", "Brasier": "du Brasier", "Brumes": "des Brumes",
		"Désert": "des Sables", "Cristaux": "des Cristaux", "Marées": "des Marées", "Vents": "des Vents",
		"Ombres": "des Ombres", "Rouages": "des Rouages"}.get(n, "de " + n)


# ── Chapitres de campagne (V151) ──────────────────────────────────────────
# La conquête est découpée en étapes annoncées, chacune récompensée. Un seul chapitre est actif à la fois :
# le premier dont l'objectif n'est pas encore atteint. Vérifié après chaque victoire et à l'ouverture de la carte.

const CHAPTERS := [
	{"id": "premiers_pas", "title": "Les premiers pas", "goal": "Conquérir 3 villes", "type": "cities", "n": 3, "gold": 150},
	{"id": "sylve", "title": "Libérer la Sylve", "goal": "Unir la Nation de la Sylve", "type": "nation", "nation": "Forêt", "gold": 300, "res": {"Bois": 15}},
	{"id": "cite", "title": "Une vraie cité", "goal": "Élever une ville au rang de Cité", "type": "level", "n": 3, "gold": 250},
	{"id": "general", "title": "Briser un général", "goal": "Vaincre un général du Roi Squelette", "type": "general", "n": 1, "gold": 400, "res": {"Magie": 10}},
	{"id": "deuxieme", "title": "Au-delà des forêts", "goal": "Unir une deuxième Nation", "type": "nations", "n": 2, "gold": 500},
	{"id": "quatre", "title": "Les quatre Nations", "goal": "Unir la Sylve, les Cimes, le Brasier et les Brumes", "type": "four", "gold": 800, "res": {"Fer": 30, "Magie": 20}},
	{"id": "zimut", "title": "Tout Zimut", "goal": "Conquérir toutes les villes", "type": "all", "gold": 1500},
	{"id": "roi", "title": "La chute du Roi Squelette", "goal": "Prendre le Donjon du Roi", "type": "king", "gold": 3000},
]

## Indice du chapitre actif (CHAPTERS.size() = campagne terminée).
static func chapter_index(conq: Dictionary) -> int:
	return clampi(int(conq.get("chapter", 0)), 0, CHAPTERS.size())

## Avancement {cur, max, done} de l'objectif d'un chapitre.
static func chapter_progress(data: Dictionary, ch: Dictionary) -> Dictionary:
	var conq: Dictionary = data.get("conquest", {})
	var cur: int = 0
	var mx: int = 1
	match String(ch["type"]):
		"cities":
			cur = owned_count(conq)
			mx = int(ch["n"])
		"nation":
			var p: Vector2i = nation_progress(conq, String(ch["nation"]))
			cur = p.x
			mx = maxi(1, p.y)
		"level":
			for id: String in conq.get("owned", []):
				cur = maxi(cur, city_level(conq, id))
			mx = int(ch["n"])
		"general":
			cur = GENERALS.size() - living_generals_count(conq)
			mx = int(ch["n"])
		"nations":
			cur = united_nations(conq).size()
			mx = int(ch["n"])
		"four":
			var u: Array = united_nations(conq)
			for n: String in ["Forêt", "Montagne", "Brasier", "Brumes"]:
				if u.has(n):
					cur += 1
			mx = 4
		"all":
			var all_ids: Array = nation_cities("*")
			mx = maxi(1, all_ids.size())
			for c: String in all_ids:
				if (conq.get("owned", []) as Array).has(c):
					cur += 1
		"king":
			cur = 1 if (conq.get("owned", []) as Array).has("donjon_roi") else 0
	return {"cur": mini(cur, mx), "max": mx, "done": cur >= mx}

## Valide les chapitres atteints (plusieurs d'un coup si besoin) et verse leurs récompenses.
## Renvoie les chapitres validés.
static func advance_chapters(data: Dictionary, conq: Dictionary) -> Array:
	var done: Array = []
	data["conquest"] = conq
	while chapter_index(conq) < CHAPTERS.size():
		var ch: Dictionary = CHAPTERS[chapter_index(conq)]
		if not bool(chapter_progress(data, ch)["done"]):
			break
		data["gold"] = int(data.get("gold", 0)) + int(ch.get("gold", 0))
		var res: Dictionary = data.get("resources", {})
		for k: String in (ch.get("res", {}) as Dictionary).keys():
			res[k] = int(res.get(k, 0)) + int(ch["res"][k])
		data["resources"] = res
		conq["chapter"] = chapter_index(conq) + 1
		done.append(ch)
		note(conq, "📜 CHAPITRE %d ACCOMPLI — %s ! Récompense : %s." % [chapter_index(conq), String(ch["title"]), reward_text(ch)])
	data["conquest"] = conq
	return done

static func reward_text(ch: Dictionary) -> String:
	var parts: PackedStringArray = ["%d or" % int(ch.get("gold", 0))]
	for k: String in (ch.get("res", {}) as Dictionary).keys():
		parts.append("%d %s" % [int(ch["res"][k]), k])
	return ", ".join(parts)


# ── Vue d'ensemble de l'empire (V148) ───────────────────────────────────
# Un tableau de toutes les villes et trois actions groupées, pour ne plus entrer dans chaque ville.

## Peut-on payer l'amélioration de cette ville maintenant ?
static func can_afford_upgrade(data: Dictionary, id: String) -> bool:
	var conq: Dictionary = data.get("conquest", {})
	if city_level(conq, id) >= MAX_LEVEL or is_ravaged(conq, id):
		return false
	var cost: Dictionary = upgrade_cost(conq, id)
	if int(data.get("gold", 0)) < int(cost.get("gold", 0)):
		return false
	var res: Dictionary = data.get("resources", {})
	for k: String in cost.get("res", {}).keys():
		if int(res.get(k, 0)) < int(cost["res"][k]):
			return false
	return true

## Une ligne par ville de l'empire, triées : villes en alerte d'abord, puis défense croissante.
## {id, level, troops, cap, defense, income, hero, threatened, ruined, ravaged, empty, can_upgrade, alert}
static func empire_rows(data: Dictionary) -> Array:
	var conq: Dictionary = data.get("conquest", {})
	var th_city: String = String(threat(conq).get("city", ""))
	var rows: Array = []
	for id: String in conq.get("owned", []):
		var r: Dictionary = {
			"id": id, "level": city_level(conq, id), "troops": troops(conq, id), "cap": garrison_cap(conq, id),
			"defense": defense(data, id), "income": city_income(data, id), "hero": hero_of(conq, id),
			"threatened": id == th_city, "ruined": is_ruined(conq, id), "ravaged": is_ravaged(conq, id),
			"can_upgrade": can_afford_upgrade(data, id)}
		r["empty"] = int(r["troops"]) == 0
		r["alert"] = bool(r["threatened"]) or bool(r["ruined"]) or bool(r["empty"])
		rows.append(r)
	rows.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		if bool(a["threatened"]) != bool(b["threatened"]):
			return bool(a["threatened"])
		if bool(a["alert"]) != bool(b["alert"]):
			return bool(a["alert"])
		if int(a["defense"]) != int(b["defense"]):
			return int(a["defense"]) < int(b["defense"])
		return String(a["id"]) < String(b["id"]))
	return rows

## Nombre de villes où une action est possible ou urgente (pour la pastille du bouton).
static func empire_action_count(data: Dictionary) -> int:
	var n: int = 0
	for r: Dictionary in empire_rows(data):
		if bool(r["alert"]) or bool(r["can_upgrade"]) or (int(r["troops"]) < int(r["cap"]) and int(data.get("gold", 0)) >= TROOP_COST):
			n += 1
	return n

## Coût pour remplir toutes les garnisons (sans tenir compte de l'or disponible).
static func recruit_all_cost(data: Dictionary) -> int:
	var conq: Dictionary = data.get("conquest", {})
	var n: int = 0
	for id: String in conq.get("owned", []):
		n += garrison_cap(conq, id) - troops(conq, id)
	return n * TROOP_COST

## Recrute partout, un soldat à la fois, en servant d'abord la ville menacée puis la moins défendue,
## jusqu'à ce que l'or manque. Renvoie {soldiers, gold, cities}.
static func recruit_all(data: Dictionary) -> Dictionary:
	var conq: Dictionary = data.get("conquest", {})
	var out: Dictionary = {"soldiers": 0, "gold": 0, "cities": 0}
	var touched: Dictionary = {}
	var th_city: String = String(threat(conq).get("city", ""))
	while int(data.get("gold", 0)) >= TROOP_COST:
		var best: String = ""
		var best_key: int = 1 << 30
		for id: String in conq.get("owned", []):
			if troops(conq, id) >= garrison_cap(conq, id):
				continue
			var key: int = (-100000 if id == th_city else 0) + defense(data, id) * 10 + troops(conq, id)
			if key < best_key:
				best_key = key
				best = id
		if best == "":
			break
		if recruit(data, best, 1) != "":
			break
		conq = data.get("conquest", conq)
		out["soldiers"] = int(out["soldiers"]) + 1
		out["gold"] = int(out["gold"]) + TROOP_COST
		touched[best] = true
	out["cities"] = touched.size()
	return out

## Améliore d'un niveau chaque ville dont l'amélioration est payable, la moins chère d'abord.
## Renvoie la liste des villes améliorées.
static func upgrade_all_affordable(data: Dictionary, names: Dictionary = {}) -> Array:
	var conq: Dictionary = data.get("conquest", {})
	var ids: Array = (conq.get("owned", []) as Array).duplicate()
	ids.sort_custom(func(a: String, b: String) -> bool:
		var ga: int = int(upgrade_cost(conq, a).get("gold", 1 << 30))
		var gb: int = int(upgrade_cost(conq, b).get("gold", 1 << 30))
		return ga < gb if ga != gb else a < b)
	var done: Array = []
	for id: String in ids:
		if can_afford_upgrade(data, id) and upgrade_city(data, id, String(names.get(id, id))) == "":
			done.append(id)
	return done

## Répare toutes les villes ruinées que l'or permet. Renvoie la liste des villes réparées.
static func repair_all(data: Dictionary) -> Array:
	var conq: Dictionary = data.get("conquest", {})
	var done: Array = []
	var ids: Array = (conq.get("owned", []) as Array).duplicate()
	ids.sort()
	for id: String in ids:
		if is_ruined(conq, id) and repair_city(data, conq, id) == "":
			done.append(id)
	data["conquest"] = conq
	return done


# ── Empire vivant (V146) ────────────────────────────────────────────────
# Jouer la Conquête fait progresser, la délaisser fait perdre des villes peu à peu.
#   • Absence : après ABSENCE_GRACE_DAYS jours sans bataille de Conquête, une offensive est simulée, puis
#     une de plus par tranche de ABSENCE_STEP_DAYS jours, contre la ville la moins défendue. La dernière
#     reste EN ATTENTE pour être défendue en personne. Au plus ABSENCE_MAX_LOST villes perdues entre
#     deux batailles, jamais la capitale ; une ville bien gardée tient toute seule.
#   • Présence : les impôts s'accumulent (ABSENCE_TAX_DAYS_MAX jours au plus) et s'encaissent en ouvrant
#     la carte ; la première victoire de Conquête du jour double les revenus.
#   • Autres modes : toutes les OUTSIDE_WINS_PER_TICK victoires hors Conquête, l'empire avance d'un cran
#     (une offensive peut être annoncée, celle en cours approche).
# L'heure vient de l'horloge du téléphone : la reculer ne rapporte rien (le compteur repart de zéro).

const DAY_SECONDS := 86400
const ABSENCE_GRACE_DAYS := 3
const ABSENCE_STEP_DAYS := 2
const ABSENCE_MAX_OFFENSIVES := 5
const ABSENCE_MAX_LOST := 2
const ABSENCE_TAX_DAYS_MAX := 3
const OUTSIDE_WINS_PER_TICK := 3
const OUTSIDE_THREAT_CHANCE := 0.5
const EMPIRE_MIN_CITIES := 3       ## comme les offensives : pas avant 3 villes

## Une bataille de Conquête vient d'être jouée : l'absence repart de zéro.
static func touch_activity(conq: Dictionary, now: int) -> void:
	conq["last_active"] = now
	conq["absence_done"] = 0
	conq["absence_lost"] = 0

static func absence_days(conq: Dictionary, now: int) -> float:
	var last: int = int(conq.get("last_active", 0))
	return maxf(0.0, float(now - last) / float(DAY_SECONDS)) if last > 0 else 0.0

## Offensives dues après `days` jours sans bataille (0 pendant le délai de grâce).
static func absence_offensives_due(days: float) -> int:
	if days < float(ABSENCE_GRACE_DAYS):
		return 0
	return mini(ABSENCE_MAX_OFFENSIVES, 1 + int((days - float(ABSENCE_GRACE_DAYS)) / float(ABSENCE_STEP_DAYS)))

## Secondes avant la première offensive d'absence (0 si elle est déjà due ou sans empire à attaquer).
static func seconds_before_absence(conq: Dictionary, now: int) -> int:
	if owned_count(conq) < EMPIRE_MIN_CITIES or int(conq.get("last_active", 0)) <= 0:
		return 0
	return maxi(0, int(conq["last_active"]) + ABSENCE_GRACE_DAYS * DAY_SECONDS - now)

## Ville de l'empire la moins défendue (hors capitale et hors `exclude`), "" s'il n'y en a pas.
static func weakest_city(data: Dictionary, conq: Dictionary, exclude: Array = []) -> String:
	var best: String = ""
	var best_d: int = 1 << 30
	var ids: Array = (conq.get("owned", []) as Array).duplicate()
	ids.sort()
	for id: String in ids:
		if id == "capitale" or id == "donjon_roi" or exclude.has(id):
			continue
		var d: int = defense(data, id)
		if d < best_d:
			best_d = d
			best = id
	return best

static func _offensive_power(conq: Dictionary, rng: RandomNumberGenerator) -> int:
	return roundi((8.0 + 2.0 * float(owned_count(conq)) + float(int(conq.get("battle_count", 0))) / 3.0) * rng.randf_range(0.85, 1.15))

## À l'ouverture de la carte : impôts accumulés et offensives manquées. Renvoie le bilan
## {days, taxes, results:[{city, outcome, power, defense}], pending:{city, power}} ({} s'il ne s'est rien passé).
static func process_absence(data: Dictionary, conq: Dictionary, now: int, rng: RandomNumberGenerator) -> Dictionary:
	var last: int = int(conq.get("last_active", 0))
	if last <= 0 or now < last:
		# première visite, ou horloge reculée : on repart de maintenant, sans rien simuler
		touch_activity(conq, now)
		conq["last_tax"] = now
		data["conquest"] = conq
		return {}
	var report: Dictionary = {"days": int(absence_days(conq, now)), "taxes": 0, "results": [], "pending": {}}
	# ── impôts : un jour de revenus par jour écoulé depuis le dernier encaissement, plafonné
	var last_tax: int = int(conq.get("last_tax", last))
	if now < last_tax:
		last_tax = now
	var tax_days: int = int(float(now - last_tax) / float(DAY_SECONDS))
	if tax_days >= 1:
		var paid_days: int = mini(tax_days, ABSENCE_TAX_DAYS_MAX)
		var gold: int = total_income(data) * paid_days
		data["gold"] = int(data.get("gold", 0)) + gold
		report["taxes"] = gold
		report["tax_days"] = paid_days
		conq["last_tax"] = last_tax + tax_days * DAY_SECONDS
	else:
		conq["last_tax"] = last_tax
	# ── offensives manquées
	var due: int = absence_offensives_due(absence_days(conq, now))
	var todo: int = due - int(conq.get("absence_done", 0))
	if todo > 0 and owned_count(conq) >= EMPIRE_MIN_CITIES:
		var kept_news: Array = (conq.get("news", []) as Array).duplicate()
		var hit: Array = []
		for i: int in range(todo):
			var th: Dictionary = threat(conq)
			var id: String = String(th.get("city", "")) if not th.is_empty() else weakest_city(data, conq, hit)
			if id == "" or not (conq.get("owned", []) as Array).has(id):
				conq.erase("threat")
				id = weakest_city(data, conq, hit)
				th = {}
			if id == "":
				id = weakest_city(data, conq)      # toutes déjà visées : la plus faible l'est de nouveau
			if id == "":
				break
			var power: int = int(th.get("power", 0)) if not th.is_empty() else _offensive_power(conq, rng)
			hit.append(id)
			if i == todo - 1:
				# la dernière offensive attend le joueur : il peut la défendre en personne
				conq["threat"] = {"city": id, "power": power, "eta": THREAT_ETA}
				conq["threat_cd"] = 0
				report["pending"] = {"city": id, "power": power, "defense": defense(data, id)}
				break
			conq.erase("threat")
			var d: int = defense(data, id)
			var can_lose: bool = int(conq.get("absence_lost", 0)) < ABSENCE_MAX_LOST
			var outcome: String = resolve_assault(data, conq, id, power, can_lose)
			if outcome == "lost":
				conq["absence_lost"] = int(conq.get("absence_lost", 0)) + 1
			(report["results"] as Array).append({"city": id, "outcome": outcome, "power": power, "defense": d})
		conq["absence_done"] = due
		conq["news"] = kept_news      # le bilan d'absence remplace les nouvelles une à une
	data["conquest"] = conq
	if int(report["taxes"]) == 0 and (report["results"] as Array).is_empty() and (report["pending"] as Dictionary).is_empty():
		return {}
	return report

## Texte du bilan « Pendant votre absence ».
static func absence_report_text(report: Dictionary, names: Dictionary) -> String:
	var lines: PackedStringArray = []
	var days: int = int(report.get("days", 0))
	if not (report.get("results", []) as Array).is_empty() or not (report.get("pending", {}) as Dictionary).is_empty():
		lines.append("%d jours sans bataille de Conquête : le Roi Squelette en a profité." % days)
	for r: Dictionary in report.get("results", []):
		var nm: String = String(names.get(String(r["city"]), String(r["city"])))
		match String(r["outcome"]):
			"repelled":
				lines.append("★ %s a repoussé une offensive seule (défense %d contre force %d)." % [nm, int(r["defense"]), int(r["power"])])
			"breach":
				lines.append("⚔ Brèche à %s (défense %d contre force %d) : la ville est pillée." % [nm, int(r["defense"]), int(r["power"])])
			_:
				lines.append("☠ %s est tombée (défense %d contre force %d). Une seule bataille suffit à la reprendre." % [nm, int(r["defense"]), int(r["power"])])
	var pend: Dictionary = report.get("pending", {})
	if not pend.is_empty():
		lines.append("⚠ Une offensive (force %d) marche sur %s (défense %d) : renforcez la ville ou défendez-la en personne." % [
			int(pend["power"]), String(names.get(String(pend["city"]), String(pend["city"]))), int(pend["defense"])])
	if int(report.get("taxes", 0)) > 0:
		lines.append("● Impôts encaissés : +%d or (%d jour(s) de revenus)." % [int(report["taxes"]), int(report.get("tax_days", 1))])
	return "\n\n".join(lines)

## Première victoire de Conquête du jour : revenus doublés. Renvoie l'or ajouté (0 si déjà pris).
static func daily_bonus(data: Dictionary, conq: Dictionary, day: int) -> int:
	if int(conq.get("bonus_day", -1)) == day:
		return 0
	conq["bonus_day"] = day
	var gold: int = total_income(data)
	data["gold"] = int(data.get("gold", 0)) + gold
	return gold

## Victoire dans un AUTRE mode (Aventure, Tactique) : l'empire vit quand même. Renvoie une alerte à
## afficher ("" s'il ne se passe rien).
static func outside_victory(data: Dictionary, conq: Dictionary, rng: RandomNumberGenerator, routes: Array) -> String:
	if owned_count(conq) < EMPIRE_MIN_CITIES:
		return ""
	conq["outside_wins"] = int(conq.get("outside_wins", 0)) + 1
	if int(conq["outside_wins"]) < OUTSIDE_WINS_PER_TICK:
		return ""
	conq["outside_wins"] = 0
	var before: int = (conq.get("news", []) as Array).size()
	if not threat(conq).is_empty():
		_tick_threat(data, conq, rng)
	elif int(conq.get("truce", 0)) <= 0 and rng.randf() <= OUTSIDE_THREAT_CHANCE:
		var pool: Array = _target_pool(conq, routes, "", true)
		if not pool.is_empty():
			var id: String = String(pool[rng.randi_range(0, pool.size() - 1)])
			var power: int = _offensive_power(conq, rng)
			conq["threat"] = {"city": id, "power": power, "eta": THREAT_ETA}
			conq["threat_cd"] = 0
			note(conq, "⚠ Pendant que vos héros sont au loin, une offensive (force %d) marche sur %s : %d batailles pour réagir." % [power, _name(conq, id), THREAT_ETA])
	data["conquest"] = conq
	var news: Array = conq.get("news", [])
	return String(news[news.size() - 1]) if news.size() > before else ""


# ── Défendre en personne (V145) ─────────────────────────────────────────
# Une offensive annoncée peut être jouée en combat Tactique au lieu d'attendre la comparaison de
# chiffres. La préparation compte toujours : plus la défense de la ville est haute face à la force
# ennemie, plus les assaillants sont faibles. Une seule tentative par offensive ; perdre (ou quitter)
# ne coûte rien de plus : l'offensive suit son cours et se règle aux chiffres à l'échéance.

const DEFEND_LEVEL_STEP := 5.0     ## points d'écart force / défense pour 1 niveau d'assaillants
const DEFEND_LEVEL_MIN := -3       ## ville bien préparée : assaillants jusqu'à 3 niveaux sous l'équipe
const DEFEND_LEVEL_MAX := 4        ## ville négligée : jusqu'à 4 niveaux au-dessus
const DEFEND_LOOT_BONUS := 1.5     ## butin d'une offensive repoussée en personne (×1,5)

## L'offensive en cours peut-elle être jouée ? (une tentative par offensive)
static func can_defend(conq: Dictionary) -> bool:
	var th: Dictionary = threat(conq)
	return not th.is_empty() and not bool(th.get("fought", false)) \
		and (conq.get("owned", []) as Array).has(String(th.get("city", "")))

## Niveau des assaillants si l'on défend en personne (0 sans offensive).
static func defense_battle_level(data: Dictionary, conq: Dictionary) -> int:
	var th: Dictionary = threat(conq)
	if th.is_empty():
		return 0
	var gap: int = int(th.get("power", 0)) - defense(data, String(th.get("city", "")))
	return maxi(1, team_avg_level(data) + clampi(int(ceil(float(gap) / DEFEND_LEVEL_STEP)), DEFEND_LEVEL_MIN, DEFEND_LEVEL_MAX))

## Prépare le combat de défense (la ville menacée devient le lieu du combat). "" si tout va bien.
static func start_defense(data: Dictionary, conq: Dictionary) -> String:
	if not can_defend(conq):
		return "Aucune offensive à repousser en personne."
	var th: Dictionary = threat(conq)
	conq["pending_city"] = String(th["city"])
	conq["pending_level"] = defense_battle_level(data, conq)
	conq["pending_defense"] = true
	conq.erase("pending_tactic")
	data["conquest"] = conq
	return ""

static func is_defense_battle(conq: Dictionary) -> bool:
	return bool(conq.get("pending_defense", false))

## Le combat de défense a réellement commencé (le plateau est posé) : la tentative est engagée.
static func mark_defense_started(conq: Dictionary) -> void:
	if is_defense_battle(conq):
		conq["defense_started"] = true

## Retour sur la carte avec une défense non résolue : abandon si le combat avait commencé (tentative
## consommée), simple annulation sinon (retour depuis le choix de l'équipe).
static func settle_unresolved_defense(data: Dictionary, conq: Dictionary) -> void:
	if not is_defense_battle(conq):
		return
	if bool(conq.get("defense_started", false)):
		defense_lost(data, conq)
	else:
		_clear_defense(conq)
		data["conquest"] = conq

static func _clear_defense(conq: Dictionary) -> void:
	conq.erase("pending_defense")
	conq.erase("defense_started")
	conq.erase("pending_level")
	conq["pending_city"] = ""

## Victoire en défense : l'offensive est brisée, la garnison intacte. Renvoie {city, power, loot, general}.
static func defense_won(data: Dictionary, conq: Dictionary) -> Dictionary:
	var th: Dictionary = threat(conq)
	_clear_defense(conq)
	if th.is_empty():
		return {}
	var power: int = int(th.get("power", 10))
	var loot: int = int(round(float(20 + power * 3) * DEFEND_LOOT_BONUS))
	data["gold"] = int(data.get("gold", 0)) + loot
	conq.erase("threat")
	conq["threat_cd"] = 0
	conq["defended_in_person"] = int(conq.get("defended_in_person", 0)) + 1
	data["conquest"] = conq
	return {"city": String(th.get("city", "")), "power": power, "loot": loot, "general": String(th.get("general", ""))}

## Défaite ou abandon en défense : la tentative est consommée, l'offensive suit son cours.
static func defense_lost(data: Dictionary, conq: Dictionary) -> void:
	var th: Dictionary = threat(conq)
	_clear_defense(conq)
	if not th.is_empty():
		th["fought"] = true
		conq["threat"] = th
		note(conq, "⚔ La sortie a échoué à %s : l'offensive (force %d) continue. Renforcez la ville avant l'échéance." % [
			_name(conq, String(th.get("city", ""))), int(th.get("power", 0))])
	data["conquest"] = conq


## Résolution d'une offensive : repoussée, brèche, ou ville perdue.
## `allow_loss` = false : au pire une brèche (plafond de pertes pendant une absence, V146).
static func resolve_assault(data: Dictionary, conq: Dictionary, id: String, power: int, allow_loss: bool = true) -> String:
	var d: int = defense(data, id)
	var nm: String = _name(conq, id)
	var t: int = troops(conq, id)
	var h: String = hero_of(conq, id)
	if d >= power:
		_set_garrison(conq, id, t - int(ceil(float(t) * 0.25)), h)
		var loot: int = 20 + power * 3
		data["gold"] = int(data.get("gold", 0)) + loot
		note(conq, "★ OFFENSIVE REPOUSSÉE à %s (défense %d contre force %d) ! Butin : +%d or." % [nm, d, power, loot])
		return "repelled"
	if float(d) >= float(power) * 0.6 or not allow_loss:
		_set_garrison(conq, id, int(float(t) * 0.5), h)
		var r: Dictionary = conq.get("ravage", {})
		r[id] = RAVAGE_BATTLES + 1
		conq["ravage"] = r
		conq["last_counterattack"] = id
		note(conq, "⚔ BRÈCHE à %s (défense %d contre force %d) : la ville est pillée %d batailles." % [nm, d, power, RAVAGE_BATTLES + 1])
		return "breach"
	# Ville perdue : retirée de l'empire, garnison dispersée, héros libéré.
	var owned: Array = conq.get("owned", [])
	owned.erase(id)
	conq["owned"] = owned
	var g: Dictionary = conq.get("garrisons", {})
	g.erase(id)
	conq["garrisons"] = g
	var lv: Dictionary = conq.get("city_levels", {})
	lv[id] = maxi(1, city_level(conq, id) - 1)
	conq["city_levels"] = lv
	var lost: Array = conq.get("lost", [])
	if not lost.has(id):
		lost.append(id)
	conq["lost"] = lost
	# Ruine & reconstruction : reprise en une bataille, mais ruinée à son retour.
	var ruins: Dictionary = conq.get("ruin", {})
	if int(ruins.get(id, 0)) <= 0:
		ruins[id] = RUIN_BATTLES
		conq["ruin"] = ruins
		note(conq, "⚒ %s est ruinée : sa production sera gelée %d batailles après sa reprise." % [nm, RUIN_BATTLES])
	var r2: Dictionary = conq.get("ravage", {})
	r2.erase(id)
	conq["ravage"] = r2
	note(conq, "☠ %s EST TOMBÉE (défense %d contre force %d) ! Reprenez-la : une seule bataille suffit." % [nm, d, power])
	return "lost"

# ═══════════════════════════════════════════════════════════════════════
#  Événements
# ═══════════════════════════════════════════════════════════════════════

static func pending_event(conq: Dictionary) -> Dictionary:
	return conq.get("event_pending", {})

## Édits du Chancelier : décision stratégique récurrente, distincte des
## événements aléatoires. Le même popup sert à l'affichage.
static func chancellor_ready(conq: Dictionary) -> bool:
	return owned_count(conq) >= CHANCELLOR_MIN_CITIES

static func maybe_chancellor(conq: Dictionary) -> void:
	if not pending_event(conq).is_empty():
		return
	conq["chancellor_cd"] = int(conq.get("chancellor_cd", 0)) + 1
	if not chancellor_ready(conq) or int(conq["chancellor_cd"]) < CHANCELLOR_INTERVAL:
		return
	var drills: Array = []
	if int(conq.get("drill", 0)) > 0:
		drills.append("manœuvres : %d bataille(s)" % int(conq["drill"]))
	if int(conq.get("roadworks", 0)) > 0:
		drills.append("routes : %d bataille(s)" % int(conq["roadworks"]))
	var active: String = ""
	if not drills.is_empty():
		active = " Déjà en cours — %s." % ", ".join(PackedStringArray(drills))
	conq["event_pending"] = {"id": "chancelier", "chancellor": true,
		"title": "LE CHANCELIER DEMANDE AUDIENCE",
		"text": "Monseigneur, le Conseil a réuni les tailles de l'empire. Voici les édits qui s'offrent à vous.%s" % active,
		"options": [
			{"id": "impot", "label": "Lever un impôt — encaisse le revenu d'une victoire par ville, chaque garnison perd 1 soldat", "gold": 0},
			{"id": "manoeuvres", "label": "Organiser des manœuvres — +2 défense dans toutes les villes pendant 3 batailles", "gold": 60},
			{"id": "routes", "label": "Entretenir les routes — +2 Bois et +1 Cuir à chaque victoire pendant 4 batailles", "gold": 40},
			{"id": "congedier", "label": "Congédier le Chancelier — aucun édit cette fois", "gold": 0}]}
	conq["chancellor_cd"] = 0
	conq["chancellor_seen"] = int(conq.get("chancellor_seen", 0)) + 1

## Effet défensif temporaire des manœuvres du Chancelier.
static func drill_defense(conq: Dictionary) -> int:
	return DRILL_DEF if int(conq.get("drill", 0)) > 0 else 0

## Production temporaire des routes du Chancelier (par victoire).
static func roadworks_yield(conq: Dictionary) -> Dictionary:
	if int(conq.get("roadworks", 0)) <= 0:
		return {}
	return {"Bois": ROADS_BOIS, "Cuir": 1}

## Spécialité économique d'une ville (CITY_TRAITS), mise à l'échelle du niveau.
static func city_trait_yield(conq: Dictionary, id: String) -> Dictionary:
	var spec: Dictionary = CITY_TRAITS.get(id, {})
	if spec.is_empty() or is_ravaged(conq, id) or is_ruined(conq, id):
		return {}
	var mult: float = level_multiplier(conq, id)
	var out: Dictionary = {}
	for r: String in spec.get("res", {}).keys():
		out[r] = maxi(1, roundi(float(spec["res"][r]) * mult))
	return out

static func city_trait_text(id: String) -> String:
	return String(CITY_TRAITS.get(id, {}).get("label", ""))

## Somme des spécialités des villes possédées (par victoire).
static func trait_yield(conq: Dictionary) -> Dictionary:
	var out: Dictionary = {}
	for id: String in conq.get("owned", []):
		for r: String in city_trait_yield(conq, id).keys():
			out[r] = int(out.get(r, 0)) + int(city_trait_yield(conq, id)[r])
	return out

static func _maybe_event(data: Dictionary, conq: Dictionary, rng: RandomNumberGenerator,
		routes: Array, just_conquered: String) -> void:
	if not pending_event(conq).is_empty():
		return
	conq["event_cd"] = int(conq.get("event_cd", 0)) + 1
	if int(conq["event_cd"]) < EVENT_MIN_GAP or rng.randf() > EVENT_CHANCE:
		return
	var ev: Dictionary = roll_event(data, conq, rng, just_conquered)
	if ev.is_empty():
		return
	conq["event_cd"] = 0
	if bool(ev.get("auto", false)):
		_apply_auto(data, conq, ev)
	else:
		conq["event_pending"] = ev

## Table des événements : id -> poids. Chacun vérifie ses propres conditions.
const EVENT_WEIGHTS := {
	"caravane": 3.0, "refugies": 2.0, "mercenaires": 2.0, "rebellion": 2.0,
	"espion": 1.5, "diplomatie": 1.0,
	"recolte": 2.0, "tresor": 1.5, "epidemie": 1.5, "rapport": 2.0,
}

## Tire un événement parmi ceux dont les conditions sont réunies.
static func roll_event(data: Dictionary, conq: Dictionary, rng: RandomNumberGenerator, just_conquered: String = "") -> Dictionary:
	var made: Array = []
	var weights: Array = []
	for eid: String in EVENT_WEIGHTS.keys():
		var ev: Dictionary = make_event(eid, data, conq, rng, just_conquered)
		if not ev.is_empty():
			made.append(ev)
			weights.append(float(EVENT_WEIGHTS[eid]))
	if made.is_empty():
		return {}
	var total: float = 0.0
	for w in weights:
		total += float(w)
	var pick: float = rng.randf() * total
	for i: int in range(made.size()):
		pick -= float(weights[i])
		if pick <= 0.0:
			return made[i]
	return made[made.size() - 1]

static func _room_cities(conq: Dictionary, skip_capital: bool) -> Array:
	var out: Array = []
	for id: String in conq.get("owned", []):
		if skip_capital and id == "capitale":
			continue
		if garrison_cap(conq, id) - troops(conq, id) > 0:
			out.append(id)
	return out

## Construit l'événement `eid`, ou {} si ses conditions ne sont pas remplies.
static func make_event(eid: String, data: Dictionary, conq: Dictionary, rng: RandomNumberGenerator,
		just_conquered: String = "") -> Dictionary:
	var nc: int = owned_count(conq)
	var owned: Array = conq.get("owned", [])
	match eid:
		"caravane":
			var res: String = RES_KEYS[rng.randi_range(0, RES_KEYS.size() - 1)]
			return {"id": eid, "title": "CARAVANE MARCHANDE", "city": "", "res": res,
				"text": "Une caravane marchande demande le passage sur vos terres. Ses mules sont chargées de %s." % res,
				"options": [
					{"id": "commerce", "label": "Commercer — 50 or → +12 %s, +4 Magie" % res, "gold": 50},
					{"id": "taxe", "label": "Taxer le passage → +45 or", "gold": 0},
					{"id": "refus", "label": "Les laisser passer", "gold": 0}]}
		"refugies":
			var rooms: Array = _room_cities(conq, false)
			if rooms.is_empty():
				return {}
			var id: String = String(rooms[rng.randi_range(0, rooms.size() - 1)])
			return {"id": eid, "title": "RÉFUGIÉS", "city": id,
				"text": "Des villageois fuient les terres ennemies et demandent asile à %s." % _name(conq, id),
				"options": [
					{"id": "accueillir", "label": "Les accueillir → +2 soldats à %s" % _name(conq, id), "gold": 0},
					{"id": "former", "label": "Les équiper — 40 or → +4 soldats", "gold": 40},
					{"id": "refus", "label": "Les renvoyer", "gold": 0}]}
		"mercenaires":
			var rooms2: Array = _room_cities(conq, true)
			if rooms2.is_empty():
				return {}
			var weakest: String = String(rooms2[0])
			for c: String in rooms2:
				if defense(data, c) < defense(data, weakest):
					weakest = c
			var n: int = mini(4, garrison_cap(conq, weakest) - troops(conq, weakest))
			return {"id": eid, "title": "MERCENAIRES", "city": weakest, "n": n,
				"text": "Une compagnie de mercenaires offre ses lances. Ils se posteraient à %s." % _name(conq, weakest),
				"options": [
					{"id": "engager", "label": "Engager %d mercenaires — %d or" % [n, 15 * n], "gold": 15 * n},
					{"id": "refus", "label": "Décliner", "gold": 0}]}
		"rebellion":
			var restless: Array = []
			for id2: String in owned:
				if id2 == "capitale" or id2 == just_conquered or is_ravaged(conq, id2):
					continue
				if troops(conq, id2) == 0 and hero_of(conq, id2) == "":
					restless.append(id2)
			if restless.is_empty():
				return {}
			var rid: String = String(restless[rng.randi_range(0, restless.size() - 1)])
			return {"id": eid, "title": "AGITATION À %s" % _name(conq, rid).to_upper(), "city": rid,
				"text": "Sans garnison, %s gronde : la population réclame des vivres et de la sécurité." % _name(conq, rid),
				"options": [
					{"id": "vivres", "label": "Distribuer des vivres — 40 or", "gold": 40},
					{"id": "reprimer", "label": "Réprimer → ville pillée 2 batailles", "gold": 0},
					{"id": "ignorer", "label": "Ignorer → 50 % de révolte (3 batailles)", "gold": 0}]}
		"espion":
			if nc < 2:
				return {}
			var th: Dictionary = threat(conq)
			var inter: String = "Interroger → l'offensive affaiblie de 15 %, retardée d'1 bataille" if not th.is_empty() else "Interroger → +35 or de rançon"
			return {"id": eid, "title": "ESPION CAPTURÉ", "city": "",
				"text": "Vos sentinelles ont capturé un espion ennemi dans vos lignes.",
				"options": [
					{"id": "interroger", "label": inter, "gold": 0},
					{"id": "retourner", "label": "Le retourner — 60 or → 4 batailles sans raid", "gold": 60},
					{"id": "relacher", "label": "Le relâcher", "gold": 0}]}
		"diplomatie":
			if nc < 4:
				return {}
			return {"id": eid, "title": "ÉMISSAIRE ENNEMI", "city": "",
				"text": "Un émissaire propose une trêve en échange d'un tribut.",
				"options": [
					{"id": "tribut", "label": "Payer le tribut — 80 or → 6 batailles de paix", "gold": 80},
					{"id": "refus", "label": "Refuser", "gold": 0}]}
		"recolte":
			if nc < 1:
				return {}
			var rc: String = String(owned[rng.randi_range(0, owned.size() - 1)])
			return {"id": eid, "auto": true, "city": rc, "res": RES_KEYS[rng.randi_range(0, RES_KEYS.size() - 1)]}
		"tresor":
			return {"id": eid, "auto": true, "gold": 40 + nc * 6}
		"epidemie":
			if nc < 3:
				return {}
			var pool: Array = []
			for id3: String in owned:
				if id3 != "capitale" and not is_ravaged(conq, id3):
					pool.append(id3)
			if pool.is_empty():
				return {}
			return {"id": eid, "auto": true, "city": String(pool[rng.randi_range(0, pool.size() - 1)])}
		"rapport":
			var govs: Array = []
			for id4: String in owned:
				if hero_of(conq, id4) != "" and not is_ravaged(conq, id4):
					govs.append(id4)
			if govs.is_empty():
				return {}
			return {"id": eid, "auto": true, "city": String(govs[rng.randi_range(0, govs.size() - 1)])}
	return {}

static func _apply_auto(data: Dictionary, conq: Dictionary, ev: Dictionary) -> void:
	var id: String = String(ev.get("city", ""))
	match String(ev["id"]):
		"recolte":
			_add_res(data, {String(ev["res"]): 10})
			note(conq, "✦ Bonne récolte à %s : +10 %s." % [_name(conq, id), String(ev["res"])])
		"tresor":
			data["gold"] = int(data.get("gold", 0)) + int(ev["gold"])
			note(conq, "★ Vos éclaireurs découvrent une cache : +%d or." % int(ev["gold"]))
		"epidemie":
			var healer: bool = hero_city(conq, "Heal") != "" and not is_ravaged(conq, hero_city(conq, "Heal"))
			if healer or city_level(conq, id) >= 2:
				note(conq, "✦ Une fièvre menaçait %s, mais %s l'enraye." % [_name(conq, id),
					"votre soigneuse" if healer else "l'hospice de la ville"])
			else:
				var r: Dictionary = conq.get("ravage", {})
				r[id] = 2
				conq["ravage"] = r
				note(conq, "⚠ Une fièvre frappe %s : production gelée 2 batailles. (Un Bourg ou un Soigneur gouverneur l'aurait évité.)" % _name(conq, id))
		"rapport":
			var h: String = hero_of(conq, id)
			var gold: int = 20 + hero_level(data, h)
			data["gold"] = int(data.get("gold", 0)) + gold
			note(conq, "♞ %s (%s) rapporte les tributs de %s : +%d or." % [h, "gouverneur", _name(conq, id), gold])

## Tranche l'événement en attente. Retourne le texte du résultat ("" si choix invalide).
static func resolve_event(data: Dictionary, option_id: String, rng: RandomNumberGenerator, names: Dictionary = {}) -> String:
	var conq: Dictionary = data.get("conquest", {})
	var ev: Dictionary = pending_event(conq)
	if ev.is_empty():
		return ""
	var chosen: Dictionary = {}
	for o: Dictionary in ev.get("options", []):
		if String(o.get("id", "")) == option_id:
			chosen = o
	if chosen.is_empty():
		return ""
	var cost: int = int(chosen.get("gold", 0))
	if int(data.get("gold", 0)) < cost:
		return "Or insuffisant : %d pièces requises." % cost
	conq["_names"] = names
	data["gold"] = int(data.get("gold", 0)) - cost
	var id: String = String(ev.get("city", ""))
	var out: String = ""
	match String(ev["id"]) + ":" + option_id:
		"caravane:commerce":
			_add_res(data, {String(ev["res"]): 12, "Magie": 4})
			out = "Marché conclu : +12 %s, +4 Magie." % String(ev["res"])
		"caravane:taxe":
			data["gold"] = int(data.get("gold", 0)) + 45
			out = "Les marchands paient le péage : +45 or."
		"refugies:accueillir":
			_set_garrison(conq, id, troops(conq, id) + 2, hero_of(conq, id))
			out = "Deux réfugiés rejoignent la garnison de %s." % _name(conq, id)
		"refugies:former":
			_set_garrison(conq, id, troops(conq, id) + 4, hero_of(conq, id))
			out = "Quatre recrues équipées renforcent %s." % _name(conq, id)
		"mercenaires:engager":
			_set_garrison(conq, id, troops(conq, id) + int(ev.get("n", 1)), hero_of(conq, id))
			out = "%d mercenaires prennent position à %s." % [int(ev.get("n", 1)), _name(conq, id)]
		"rebellion:vivres":
			out = "Les vivres apaisent %s : le calme revient." % _name(conq, id)
		"rebellion:reprimer":
			var r: Dictionary = conq.get("ravage", {})
			r[id] = 2
			conq["ravage"] = r
			out = "La révolte est écrasée, mais %s est pillée 2 batailles." % _name(conq, id)
		"rebellion:ignorer":
			if rng.randf() < 0.5:
				var r2: Dictionary = conq.get("ravage", {})
				r2[id] = 3
				conq["ravage"] = r2
				out = "%s se révolte et se fait piller 3 batailles !" % _name(conq, id)
			else:
				out = "L'agitation retombe d'elle-même, cette fois."
		"espion:interroger":
			var th: Dictionary = threat(conq)
			if not th.is_empty():
				th["power"] = maxi(1, roundi(float(th["power"]) * 0.85))
				th["eta"] = int(th["eta"]) + 1
				conq["threat"] = th
				out = "L'espion parle : l'offensive est affaiblie (force %d) et retardée d'une bataille." % int(th["power"])
			else:
				data["gold"] = int(data.get("gold", 0)) + 35
				out = "Sa rançon rapporte 35 or."
		"espion:retourner":
			conq["truce"] = maxi(int(conq.get("truce", 0)), 4)
			out = "L'espion travaille pour vous : plus de raids pendant 4 batailles."
		"espion:relacher":
			out = "Vous relâchez l'espion. Il ne reviendra pas."
		"chancelier:congedier":
			out = "Le Chancelier se retire : aucun édit promulgué."
		"chancelier:impot":
			var owned: Array = conq.get("owned", [])
			var gold: int = 0
			for cid: String in owned:
				gold += city_income(data, cid)
				if troops(conq, cid) > 0:
					_set_garrison(conq, cid, troops(conq, cid) - 1, hero_of(conq, cid))
			data["gold"] = int(data.get("gold", 0)) + gold
			out = "L'impôt est levé : +%d or. Les garnisons, elles, ont payé le prix. Le revenu reprendra son cours normal à la prochaine victoire." % gold
		"chancelier:manoeuvres":
			conq["drill"] = DRILL_BATTLES
			out = "Les manœuvres commencent : +2 défense dans toutes les villes pendant %d batailles." % DRILL_BATTLES
		"chancelier:routes":
			conq["roadworks"] = ROADS_BATTLES
			out = "Les routes sont réparées : +%d Bois et +1 Cuir à chaque victoire pendant %d batailles." % [ROADS_BOIS, ROADS_BATTLES]
		"diplomatie:tribut":
			conq["truce"] = maxi(int(conq.get("truce", 0)), 6)
			out = "Le tribut est versé : paix pendant 6 batailles (pas de raid, pas de nouvelle offensive)."
		_:
			out = "Vous passez votre chemin."
	conq.erase("event_pending")
	conq.erase("_names")
	log_event(conq, "%s — %s" % [String(ev.get("title", "Événement")).capitalize(), out])
	data["conquest"] = conq
	return out
