extends Node
## ProgressionManager.gd — Progression, sauvegardes et inventaire.
##
## - 5 parties (slots) maximum, stockées dans user://saves/
## - Chaque partie : niveau de départ (progression +2 niveaux par victoire),
##   équipe librement modifiable, inventaire de loots et équipement par perso
## - Loots à chaque victoire : types d'items demandés (bague, collier, casque,
##   gants, bottes, boucles d'oreille, capes, armes, bouclier)

signal progression_changed()

const SAVE_DIR := "user://saves"
const MAX_SAVES := 5
const START_LEVEL := 10
const LEVELS_PER_VICTORY := 2

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
var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	_rng.randomize()
	_load_items_catalog()
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
			"effect": String(cols[9].strip_edges()) if cols.size() > 9 else "",
		})

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
	write_save(slot, data)
	return data

func _fresh_save() -> Dictionary:
	return {
		"name": "",
		"level": START_LEVEL,
		"victories": 0,
		"team": [],           # [{ "classe": String, "equipment": {slot -> item} }]
		"inventory": [],      # [{ "type", "name", "level", stats... }]
		"timestamp": Time.get_datetime_string_from_system(),
	}

func load_save(slot: int) -> Dictionary:
	if not save_exists(slot):
		return {}
	var file := FileAccess.open(_path(slot), FileAccess.READ)
	if file == null:
		return {}
	var parsed = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		return {}
	return parsed

func write_save(slot: int, data: Dictionary) -> bool:
	if slot < 0 or slot >= MAX_SAVES:
		return false
	data["timestamp"] = Time.get_datetime_string_from_system()
	var file := FileAccess.open(_path(slot), FileAccess.WRITE)
	if file == null:
		push_error("Impossible d'écrire la sauvegarde %d" % slot)
		return false
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	return true

func delete_save(slot: int) -> void:
	if save_exists(slot):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(_path(slot)))

# ═══════════════════════════════════════════════════════════════════════════
#  Victoire : progression + loots
# ═══════════════════════════════════════════════════════════════════════════

## À appeler après une victoire : +2 niveaux d'ennemis, 1-3 loots.
## Retourne la sauvegarde mise à jour (à écrire ensuite) ou {} si pas de partie active.
func register_victory(data: Dictionary) -> Dictionary:
	if data.is_empty():
		return {}
	data["victories"] = int(data.get("victories", 0)) + 1
	data["level"] = int(data.get("level", START_LEVEL)) + LEVELS_PER_VICTORY
	var loots: Array = _roll_loots(int(data["level"]))
	for l: Dictionary in loots:
		data["inventory"].append(l)
	data["last_loots"] = loots
	progression_changed.emit()
	return data

func _roll_loots(level: int) -> Array:
	var count: int = _rng.randi_range(1, 3)
	var out: Array = []
	for i: int in range(count):
		var item := _random_item(level)
		if not item.is_empty():
			out.append(item)
	return out

## Tire un item dont le niveau requis est <= level (le plus proche possible).
func _random_item(level: int) -> Dictionary:
	var candidates: Array = []
	for it: Dictionary in _items_catalog:
		if int(it["level"]) <= level:
			candidates.append(it)
	if candidates.is_empty():
		return {}
	return candidates[_rng.randi_range(0, candidates.size() - 1)].duplicate()

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
	var equipment: Dictionary = member.get("equipment", {})
	# Retirer l'item de l'inventaire
	inv.remove_at(item_index)
	# Renvoyer l'ancien item à l'inventaire
	if equipment.has(slot):
		inv.append(equipment[slot])
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

## Somme des bonus d'équipement d'un membre : { force, intelligence, agility,
## wisdom, vita, defense }
func equipment_bonuses(member: Dictionary) -> Dictionary:
	var out := {"force": 0, "intelligence": 0, "agility": 0, "wisdom": 0, "vita": 0, "defense": 0}
	for slot: String in member.get("equipment", {}).keys():
		var it: Dictionary = member["equipment"][slot]
		for k: String in out.keys():
			out[k] = int(out[k]) + int(it.get(k, 0))
	return out
