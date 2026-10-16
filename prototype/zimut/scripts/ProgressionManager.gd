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
const START_LEVEL := 10
const BOSS_EVERY := 4

## Palier XP du roster par niveau (index = niveau, 0 et 1 inutilisés).
## Calibré pour une progression progressive et évolutive :
## ~3 combats pour passer du niveau 10 au 11 (il faut 495 XP),
## de plus en plus de combats par niveau ensuite, jusqu'à ~200 combats
## pour le dernier palier (niveau 49 -> 50).
const LEVEL_XP: PackedInt32Array = [
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 495, 990, 1503, 2211, 2947, 3902, 4892, 6128, 7626,
	9402, 11472, 13862, 16838, 20450, 24722, 29726, 35774, 42950, 51320,
	61302, 72992, 86872, 103072, 122146, 144262, 170054, 199732, 234018, 273255,
	318183, 369213, 427173, 492548, 566396, 649304, 741734, 844924, 959766, 1086642,
	1227195,
]
## Combats de la frontière nécessaires par niveau (calage du rythme : 3 combats
## au niveau 10, ~200 pour le palier final).
const LEVEL_COMBATS: PackedInt32Array = [
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	3, 3, 3, 4, 4, 5, 5, 6, 7, 8,
	9, 10, 12, 14, 16, 18, 21, 24, 27, 31,
	35, 40, 45, 51, 57, 64, 71, 79, 87, 96,
	105, 115, 125, 136, 147, 158, 170, 182, 194, 207,
	200,
]

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

## Catalogue officiel des villes de Conquête (la carte de ConquestMapUI en est
## dérivée) : id -> { name, kind, biome, level }.
##   capital : imprenable, quartier général ;
##   neutral : 1 bataille de mobs ;
##   enemy   : siège en 4 batailles (3 mobs + boss du biome) ;
##   donjon_roi : objectif final, débloqué quand tout l'empire est conquis.
const CONQUEST_CITIES := {
	"capitale":     {"name": "Sylve-Cœur",      "kind": "capital",    "biome": "Forêt",     "level": 0},
	"clairiere":    {"name": "Clairière d'Aube", "kind": "neutral",   "biome": "Forêt",     "level": 10},
	"vieille_tour": {"name": "Vieille Tour",     "kind": "enemy",     "biome": "Forêt",     "level": 12},
	"pont_mousse":  {"name": "Pont-Mousse",      "kind": "neutral",   "biome": "Forêt",     "level": 11},
	"fort_racine":  {"name": "Fort Racine",       "kind": "enemy",     "biome": "Forêt",     "level": 14},
	"hameau_pin":   {"name": "Hameau du Pin",    "kind": "neutral",   "biome": "Montagne",  "level": 16},
	"garnison":    {"name": "Garnison des Pics", "kind": "enemy",     "biome": "Montagne",  "level": 18},
	"oasis":        {"name": "Oasis Perdue",      "kind": "neutral",   "biome": "Désert",    "level": 20},
	"tour_sable":   {"name": "Tour des Sables",  "kind": "enemy",     "biome": "Désert",    "level": 22},
	"donjon_roi":   {"name": "Donjon du Roi Squelette", "kind": "enemy", "biome": "Donjon", "level": 25},
	"village_brume": {"name": "Village des Brumes", "kind": "neutral", "biome": "Forêt", "level": 11},
	"ruines_lierre": {"name": "Ruines du Lierre", "kind": "enemy", "biome": "Forêt", "level": 13},
	"abbaye_ronce": {"name": "Abbaye des Ronces", "kind": "neutral", "biome": "Forêt", "level": 14},
	"citadelle_ronce": {"name": "Citadelle des Ronces", "kind": "enemy", "biome": "Forêt", "level": 15},
	"col_givre": {"name": "Col du Givre", "kind": "neutral", "biome": "Montagne", "level": 17},
	"mine_cristal": {"name": "Mine de Cristal", "kind": "enemy", "biome": "Montagne", "level": 19},
	"bastion_orage": {"name": "Bastion de l'Orage", "kind": "enemy", "biome": "Montagne", "level": 21},
	"caravanserail": {"name": "Caravansérail Rouge", "kind": "neutral", "biome": "Désert", "level": 22},
	"observatoire": {"name": "Observatoire Solaire", "kind": "neutral", "biome": "Désert", "level": 23},
	"port_sable": {"name": "Port des Sables", "kind": "enemy", "biome": "Désert", "level": 24},
	"bois_lune": {"name": "Bois de Lune", "kind": "neutral", "biome": "Forêt", "level": 16},
	"sanctuaire_mousse": {"name": "Sanctuaire Moussu", "kind": "neutral", "biome": "Forêt", "level": 17},
	"forge_givre": {"name": "Forge du Givre", "kind": "enemy", "biome": "Montagne", "level": 23},
	"pic_foudroyant": {"name": "Pic Foudroyant", "kind": "enemy", "biome": "Montagne", "level": 24},
	"marais_spectres": {"name": "Marais des Spectres", "kind": "neutral", "biome": "Forêt", "level": 18},
	"fort_cendre": {"name": "Fort des Cendres", "kind": "enemy", "biome": "Désert", "level": 26},
	"temple_soleil": {"name": "Temple du Soleil", "kind": "neutral", "biome": "Désert", "level": 25},
	"citadelle_sable": {"name": "Citadelle de Sable", "kind": "enemy", "biome": "Désert", "level": 27},
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
]

## Bâtiments de ressources constructibles dans les villes conquises.
## type -> { label, coûts (ressources), or, production par bataille gagnée }
const CONQUEST_BUILDINGS := {
	"scierie":  {"label": "Scierie",  "cost": {"Bois": 12},               "gold": 40,  "yield": {"Bois": 3}},
	"mine":     {"label": "Mine",     "cost": {"Fer": 12},                "gold": 60,  "yield": {"Fer": 3}},
	"tannerie": {"label": "Tannerie", "cost": {"Cuir": 12},               "gold": 50,  "yield": {"Cuir": 3}},
	"cabane":   {"label": "Cabane des mages", "cost": {"Magie": 8},        "gold": 90,  "yield": {"Magie": 2}},
	"verger":   {"label": "Verger",   "cost": {"Bois": 8, "Venin": 4},    "gold": 70,  "yield": {"Venin": 2}},
}
## +1 niveau d'ennemi toutes les N victoires (la difficulté monte doucement)
const DIFFICULTY_CREEP_EVERY := 10

## Niveau de combat par défaut quand aucun n'est connu (combat rapide).
const DEFAULT_FIGHT_LEVEL := 10
const CLASS_ORDER: Array[String] = ["Tank", "Assassin", "Chasseur", "Mage", "Druide", "Heal", "Invocateur", "Sylvain"]

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
		"roster": {},         # { classe: { level, xp, invested{}, unspent, auto } }
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
	_normalize_ints(parsed, ["level", "victories", "gold"])
	ensure_roster(parsed)   # migration des anciennes parties + normalisation
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
	var lv: int = clampi(fight_level, 1, ClassRules.MAX_LEVEL)
	var gain: float = ClassRules.XP_PER_COMBAT_BASE * pow(ClassRules.XP_PER_COMBAT_GROWTH, float(lv - 1))
	gain = clampf(gain, ClassRules.XP_PER_COMBAT_FLOOR, ClassRules.XP_PER_COMBAT_CEIL)
	var settings: Node = get_node_or_null("/root/GameSettings")
	var speed: float = settings.xp_mult() if settings != null else 1.0
	return maxi(1, roundi(gain * ClassRules.FIGHT_XP_MULT * speed))

## Nombre de combats de la frontière estimé pour passer de `level` à `level + 1`.
func combats_for_level(level: int) -> int:
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
	return String(BIOME_LABEL.get(biome, biome))

## Types d'ennemis du biome (2 types, cf. BIOME_ENEMIES / ennemis.txt).
func biome_enemy_types(biome: String) -> Array[String]:
	var out: Array[String] = []
	for t: String in BIOME_ENEMIES.get(biome, ["Gobelin", "Squelette"]):
		out.append(t)
	return out

## Boss du biome.
func biome_boss(biome: String) -> String:
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

## État d'une recette pour l'interface : { craftable, missing: {res: n}, gold_missing }.
func craft_status(data: Dictionary, recipe: Dictionary) -> Dictionary:
	var res: Dictionary = data.get("resources", {})
	var missing: Dictionary = {}
	for k: String in recipe["cost"].keys():
		var lack: int = int(recipe["cost"][k]) - int(res.get(k, 0))
		if lack > 0:
			missing[k] = lack
	var gold_missing: int = maxi(0, int(recipe["gold"]) - int(data.get("gold", 0)))
	return {"craftable": missing.is_empty() and gold_missing == 0, "missing": missing, "gold_missing": gold_missing}

## Fabrique l'objet de la recette : consomme ressources et or, l'objet part
## dans l'inventaire. Retourne "" si OK, sinon la raison.
func craft_item(data: Dictionary, recipe_name: String) -> String:
	var recipe: Dictionary = craft_recipe(recipe_name)
	if recipe.is_empty():
		return "Recette inconnue."
	var res: Dictionary = data.get("resources", {})
	for k: String in recipe["cost"].keys():
		if int(res.get(k, 0)) < int(recipe["cost"][k]):
			return "Ressource insuffisante : %s (%d/%d)." % [k, int(res.get(k, 0)), int(recipe["cost"][k])]
	if int(data.get("gold", 0)) < int(recipe["gold"]):
		return "Or insuffisant : %d pièces requises." % int(recipe["gold"])
	for k: String in recipe["cost"].keys():
		res[k] = int(res.get(k, 0)) - int(recipe["cost"][k])
	data["resources"] = res
	data["gold"] = int(data.get("gold", 0)) - int(recipe["gold"])
	data["inventory"].append(forged_item(recipe))
	data["crafted"] = int(data.get("crafted", 0)) + 1
	progression_changed.emit()
	return ""

## Fabrique puis équipe directement sur un membre de l'équipe. Si l'équipement échoue
## (niveau trop bas...), l'objet reste dans l'inventaire : retourne alors la raison.
func craft_and_equip(data: Dictionary, recipe_name: String, member_index: int) -> String:
	var err: String = craft_item(data, recipe_name)
	if err != "":
		return err
	var idx: int = data["inventory"].size() - 1
	var eq_err: String = equip_item(data, member_index, idx)
	if eq_err != "":
		return "Objet fabriqué (en inventaire) mais non équipé : %s" % eq_err
	return ""

# ═══════════════════════════════════════════════════════════════════════════
## ── Niveaux de sorts (1..10) ─────────────────────────────────────────────
## Chaque sort d'une classe peut être amélioré du niveau 1 au niveau 10 :
## +SPELL_LEVEL_BONUS_PCT par niveau sur les dégâts / soins / valeurs d'effet.
## Coût d'amélioration : (SPELL_LEVEL_GOLD_BASE × niveau) or
## + (SPELL_LEVEL_MAGIC_BASE × niveau) unités de Magie.
const SPELL_LEVEL_MAX := 10
const SPELL_LEVEL_BONUS_PCT := 6.0
const SPELL_LEVEL_GOLD_BASE := 50
const SPELL_LEVEL_MAGIC_BASE := 2

## Niveau actuel d'un sort pour une classe (1 si jamais amélioré).
func spell_level(data: Dictionary, classe: String, spell_name: String) -> int:
	var e: Dictionary = roster_entry(data, classe)
	var sl: Dictionary = e.get("spell_levels", {})
	return clampi(int(sl.get(spell_name, 1)), 1, SPELL_LEVEL_MAX)

## Multiplicateur d'efficacité du sort selon son niveau (1.0 au niveau 1).
func spell_mult(data: Dictionary, classe: String, spell_name: String) -> float:
	return 1.0 + (float(spell_level(data, classe, spell_name)) - 1.0) * SPELL_LEVEL_BONUS_PCT / 100.0

## Coût de la prochaine amélioration : { "gold": int, "magie": int } ou {} au max.
func spell_upgrade_cost(data: Dictionary, classe: String, spell_name: String) -> Dictionary:
	var lvl: int = spell_level(data, classe, spell_name)
	if lvl >= SPELL_LEVEL_MAX:
		return {}
	return {"gold": SPELL_LEVEL_GOLD_BASE * lvl, "magie": SPELL_LEVEL_MAGIC_BASE * lvl}

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
	if base == 0:
		for d: Dictionary in p.get("dots", []):
			base = int(float(d["value"]))
			label = "Dégâts par tour"
	var mult: float = 1.0 + (float(clampi(level, 1, SPELL_LEVEL_MAX)) - 1.0) * SPELL_LEVEL_BONUS_PCT / 100.0
	return {"pa": int(row["pa"]), "pm": int(row["pm"]), "range": int(row["range"]), "kind": String(p["kind"]),
		"target": String(p["target"]), "aoe": String(p["aoe"]), "zone": int(p["zone_r"]),
		"los": bool(p["needs_los"]), "value": roundi(float(base) * mult), "base_value": base, "label": label,
		"mult": mult, "desc": String(row["effect"]), "type": String(row["type"]), "req": int(row["level"])}

## Améliore un sort d'un niveau. Retourne "" si OK, sinon la raison.
func upgrade_spell(data: Dictionary, classe: String, spell_name: String) -> String:
	var cost: Dictionary = spell_upgrade_cost(data, classe, spell_name)
	if cost.is_empty():
		return "Niveau maximum atteint."
	if int(data.get("gold", 0)) < int(cost["gold"]):
		return "Or insuffisant : %d pièces requises." % int(cost["gold"])
	var res: Dictionary = data.get("resources", {})
	if int(res.get("Magie", 0)) < int(cost["magie"]):
		return "Magie insuffisante : %d requises." % int(cost["magie"])
	data["gold"] = int(data.get("gold", 0)) - int(cost["gold"])
	res["Magie"] = int(res.get("Magie", 0)) - int(cost["magie"])
	data["resources"] = res
	var e: Dictionary = roster_entry(data, classe)
	var sl: Dictionary = e.get("spell_levels", {})
	sl[spell_name] = clampi(int(sl.get(spell_name, 1)) + 1, 1, SPELL_LEVEL_MAX)
	e["spell_levels"] = sl
	progression_changed.emit()
	return ""

#  Roster : progression de chaque classe
# ═══════════════════════════════════════════════════════════════════════════

func _new_entry(level: int) -> Dictionary:
	return {"level": level, "xp": xp_for_level(level), "invested": {},
		"unspent": ClassRules.total_points_for_level(level), "auto": true,
		"spell_levels": {}}

## Garantit que la sauvegarde contient un roster complet et cohérent (migration
## des anciennes parties incluse). Appelé au chargement.
func ensure_roster(data: Dictionary) -> void:
	if data.is_empty():
		return
	var legacy_level: int = clampi(int(data.get("level", START_LEVEL)), START_LEVEL, ClassRules.MAX_LEVEL)
	var fresh: bool = not data.has("roster")
	var roster: Dictionary = data.get("roster", {})
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
		ent["unspent"] = int(ent.get("unspent", 0))
		ent["auto"] = bool(ent.get("auto", true))
		var inv: Dictionary = ent.get("invested", {})
		for k in inv.keys():
			inv[k] = int(inv[k])
		ent["invested"] = inv
	data["roster"] = roster
	data["level"] = frontier_level(data)

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
	return clampi(lvl, 1, ClassRules.MAX_LEVEL)

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
		return clampi(int(hist[n - 1]), 1, ClassRules.MAX_LEVEL)
	return clampi(frontier_level(data) - (frontier - n), 1, ClassRules.MAX_LEVEL)

## Facteur d'XP selon l'écart entre le niveau du combat et celui du perso :
## combat plus bas = moins d'XP (rejouer sert à farmer les objets), plus haut = bonus.
func xp_level_factor(fight_level: int, member_level: int) -> float:
	return clampf(1.0 + float(fight_level - member_level) * 0.10, 0.10, 1.5)

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
	var out: Dictionary = {
		"classe": classe, "level": level,
		"max_pv": int(row["vita"]) + int(inv.get("vita", 0)) * int(ClassRules.STAT_GAIN["vita"]) + int(eq["vita"]),
		"pa": mini(ClassRules.PA_CAP, int(row["pa"]) + int(ms["pa"]) + int(inv.get("pa", 0)) + int(fx.get("pa", 0))),
		"pm": mini(ClassRules.PM_CAP, int(row["pm"]) + int(ms["pm"]) + int(inv.get("pm", 0)) + int(fx.get("pm", 0))),
		"po": mini(ClassRules.PO_CAP, int(inv.get("po", 0)) + int(fx.get("po", 0))),
		"fx": fx, "sets": agg["sets"],
	}
	for k: String in ["force", "intelligence", "agility", "wisdom", "defense"]:
		out[k] = int(row[k]) + int(inv.get(k, 0)) + int(eq[k])
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
			if bool(e.get("auto", true)):
				e["unspent"] = ClassRules.auto_allocate(classe, e["invested"], int(e["unspent"]))
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
func register_victory(data: Dictionary, info: Dictionary = {}) -> Dictionary:
	if data.is_empty():
		return {}
	ensure_roster(data)
	var fight_no: int = selected_fight_number(data)
	var frontier: bool = fight_no == frontier_fight_number(data)
	var fight_level: int = enemy_level_for(data)
	var was_boss: bool = bool(info.get("boss", is_boss_fight(data)))
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
	else:
		data["replays"] = int(data.get("replays", 0)) + 1
	var loots: Array = _roll_loots(fight_level, was_boss)
	for l: Dictionary in loots:
		data["inventory"].append(l)
	data["last_loots"] = loots
	# Butin de craft : ressources selon le nombre d'ennemis vaincus, un peu d'or.
	var drops: Dictionary = _roll_resource_drops(enemies.size(), was_boss)
	add_resources(data, drops)
	var gold_gain: int = (50 + 10 * fight_level) * (3 if was_boss else 1)
	data["gold"] = int(data.get("gold", 0)) + (gold_gain if frontier else int(gold_gain * 0.6))
	data["last_resources"] = drops
	data["level"] = frontier_level(data)
	data["last_result"] = {"victory": true, "xp": report, "boss": was_boss, "fight_level": fight_level,
		"turns": int(info.get("turns", 0)), "fight_no": fight_no, "replay": not frontier}
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
	_apply_campaign_victory(data)
	progression_changed.emit()
	return data

## Défaite : un peu d'XP de consolation, pas de loot, pas de recul.
func register_defeat(data: Dictionary, info: Dictionary = {}) -> Dictionary:
	if data.is_empty():
		return {}
	ensure_roster(data)
	var fight_level: int = enemy_level_for(data)
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
	progression_changed.emit()
	return data

## Applique les conséquences de campagne au même profil que le mode Tactique.
## La ville n'est ajoutée au territoire qu'après une victoire réelle.
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
			if progress >= conquest_city_battles(pending):
				# Ville prise : annexion et fin du siège
				var owned: Array = conquest.get("owned", ["capitale"])
				if not owned.has(pending):
					owned.append(pending)
					conquest["owned"] = owned
				conquest["just_annexed"] = pending
				conquest["pending_city"] = ""
				conquest.erase("pending_level")
				sieges.erase(pending)
				conquest["sieges"] = sieges
			else:
				# Siège en cours : la ville reste la cible pour la suite
				sieges[pending] = progress
				conquest["sieges"] = sieges
		# Production de l'empire : les bâtiments des villes possédées
		# rapportent leurs ressources à chaque bataille gagnée.
		var empire_yield: Dictionary = conquest_empire_yield(conquest)
		if not empire_yield.is_empty():
			add_resources(data, empire_yield)
			conquest["last_yield"] = empire_yield
		# Décrément du pillage, puis contre-attaque ennemie éventuelle
		# (jamais la capitale, jamais la ville tout juste conquise).
		_tick_ravage(conquest)
		var counter: String = _roll_counterattack(conquest, just_conquered)
		if counter != "":
			conquest["ravage"] = _ravage_dict(conquest)
			conquest["ravage"][counter] = CONQUEST_RAVAGE_BATTLES
			conquest["last_counterattack"] = counter
		else:
			conquest["last_counterattack"] = ""
		data["conquest"] = conquest
	elif mode == "adventure":
		var adventure: Dictionary = data.get("adventure", {})
		var pending_challenge: String = String(adventure.get("pending_challenge", ""))
		if pending_challenge != "":
			var completed: Array = adventure.get("completed", [])
			if not completed.has(pending_challenge):
				completed.append(pending_challenge)
			adventure["completed"] = completed
			adventure["pending_challenge"] = ""
			data["adventure"] = adventure

## Production totale de l'empire (bâtiments des villes possédées non
## pillées), versée à chaque bataille gagnée.
func conquest_empire_yield(conquest: Dictionary) -> Dictionary:
	var out: Dictionary = {}
	for city_id: String in conquest.get("owned", []):
		if _is_city_ravaged(conquest, city_id):
			continue
		for b: String in _city_buildings(conquest, city_id):
			for r: String in CONQUEST_BUILDINGS.get(b, {}).get("yield", {}).keys():
				out[r] = int(out.get(r, 0)) + int(CONQUEST_BUILDINGS[b]["yield"][r])
	return out

## Nombre de batailles necessaires pour prendre cette ville :
## 4 (3 mobs + boss) pour une ville adverse, 1 pour une neutre.
func conquest_city_battles(city_id: String) -> int:
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

## Une ville est-elle attaquable : reliée par route au territoire ET pas
## déjà conquise. La capitale ne s'attaque jamais ; le Donjon exige de
## contrôler toutes les autres villes (fin de campagne).
func conquest_city_attackable(conquest: Dictionary, city_id: String) -> bool:
	var kind: String = conquest_city_kind(city_id)
	if kind == "capital" or kind == "":
		return false
	if conquest.get("owned", []).has(city_id):
		return false
	if city_id == "donjon_roi" and not conquest_empire_complete(conquest):
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
	return clampi(conquest_siege_progress(conquest, city_id) + 1, 1, conquest_city_battles(city_id))

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
	inv.remove_at(inv_index)
	data["inventory"] = inv
	add_resources(data, gains)
	progression_changed.emit()
	return {"ok": true, "gains": gains, "reason": ""}

## En cas de défaite, on ne valide pas la conquête/le défi : le joueur pourra retenter.
func _apply_campaign_defeat(data: Dictionary) -> void:
	var mode: String = String(data.get("campaign_mode", ""))
	if mode == "conquest":
		# Defaite : le siege en cours est conserve (meme cible, meme
		# progression) : le joueur peut retenter la bataille perdue.
		var conquest: Dictionary = data.get("conquest", {})
		data["conquest"] = conquest
	elif mode == "adventure":
		var adventure: Dictionary = data.get("adventure", {})
		adventure["pending_challenge"] = ""
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

## Équipe un item de l'inventaire sur un perso ; l'ancien item retourne
## à l'inventaire. Retourne "" si OK, sinon la raison.
## Règles : niveau requis ; une arme à 2 mains libère le bouclier.
func equip_item(data: Dictionary, member_index: int, item_index: int) -> String:
	var inv: Array = data.get("inventory", [])
	var team: Array = data.get("team", [])
	if member_index < 0 or member_index >= team.size():
		return "Personnage introuvable."
	if item_index < 0 or item_index >= inv.size():
		return "Objet introuvable."
	var item: Dictionary = inv[item_index]
	var member: Dictionary = team[member_index]
	var slot: String = slot_for_type(String(item["type"]))
	if slot == "":
		return "Type d'objet inconnu : %s" % String(item["type"])
	var lvl: int = member_level(data, String(member.get("classe", "")))
	if int(item.get("level", 1)) > lvl:
		return "Niveau %d requis (%s est niveau %d)." % [int(item.get("level", 1)), String(member.get("classe", "")), lvl]
	var equipment: Dictionary = member.get("equipment", {})
	if slot == "bouclier" and equipment.has("arme") and ItemRules.is_two_handed(equipment["arme"]):
		return "Arme à deux mains équipée : retirez-la pour porter un bouclier."
	# Retirer l'item de l'inventaire
	inv.remove_at(item_index)
	# Renvoyer l'ancien item à l'inventaire
	if equipment.has(slot):
		inv.append(equipment[slot])
	# Une arme à 2 mains libère le bouclier
	if slot == "arme" and ItemRules.is_two_handed(item) and equipment.has("bouclier"):
		inv.append(equipment["bouclier"])
		equipment.erase("bouclier")
	equipment[slot] = item
	member["equipment"] = equipment
	return ""

func unequip_item(data: Dictionary, member_index: int, slot: String) -> String:
	var team: Array = data.get("team", [])
	if member_index < 0 or member_index >= team.size():
		return "Personnage introuvable."
	var member: Dictionary = team[member_index]
	var equipment: Dictionary = member.get("equipment", {})
	if not equipment.has(slot):
		return "Emplacement vide."
	data["inventory"].append(equipment[slot])
	equipment.erase(slot)
	return ""

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
	var new_team: Array = []
	var used: Array = []
	for classe in classes:
		var kept: Dictionary = {}
		for i: int in range(old_team.size()):
			if String(old_team[i].get("classe", "")) == String(classe) and not used.has(i):
				kept = old_team[i].get("equipment", {})
				used.append(i)
				break
		new_team.append({"classe": String(classe), "equipment": kept})
	for i: int in range(old_team.size()):
		if not used.has(i):
			for slot: String in old_team[i].get("equipment", {}).keys():
				data["inventory"].append(old_team[i]["equipment"][slot])
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
