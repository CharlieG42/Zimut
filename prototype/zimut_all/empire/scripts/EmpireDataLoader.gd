extends Node
## EmpireDataLoader.gd - Chargeur de donnees CSV pour le mode Empire
## Charge batiments, unites et divinites depuis les CSV du dossier data/.
## Suit le meme patron que DataLoader.gd du mode Zimut.
## Reutilise aussi les CSV existants (classes, sorts, craft, invocations, ennemis).

const BUILDING_DATA_PATHS = ["res://empire/data/batiments.csv", "user://data/batiments.csv"]
const UNIT_DATA_PATHS = ["res://empire/data/unites.csv", "user://data/unites.csv"]
const DIVINITY_DATA_PATHS = ["res://empire/data/divinites.csv", "user://data/divinites.csv"]
const CLASS_DATA_PATHS = ["res://empire/data/classes.csv", "user://data/classes.csv"]
const CRAFT_DATA_PATHS = ["res://empire/data/craft.csv", "user://data/craft.csv"]
const INVOCATION_DATA_PATHS = ["res://empire/data/invocations.csv", "user://data/invocations.csv"]
const ENEMY_DATA_PATHS = ["res://empire/data/ennemis.csv", "user://data/ennemis.csv"]
const SPELL_DATA_PATHS = ["res://empire/data/sorts.csv", "user://data/sorts.csv"]
const STUFF_DATA_PATHS = ["res://empire/data/stuff.csv", "user://data/stuff.csv"]

var buildings_data: Array = []
var units_data: Array = []
var divinities_data: Array = []
var classes_data: Array = []
var craft_data: Array = []
var invocations_data: Array = []
var enemies_data: Array = []
var spells_data: Array = []
var items_data: Array = []

var data_loaded: bool = false

signal data_loaded_successfully
signal data_load_failed(error: String)

func _ready() -> void:
	load_all_data()

## Ouvre un fichier en essayant plusieurs chemins (compat Android)
func _open_file(paths: Array) -> FileAccess:
	for path: String in paths:
		var file: FileAccess = FileAccess.open(path, FileAccess.READ)
		if file != null:
			return file
	return null

func load_all_data() -> void:
	var success: bool = true
	if not _load_csv(BUILDING_DATA_PATHS, "buildings_data", "batiments.csv"):
		success = false
	if not _load_csv(UNIT_DATA_PATHS, "units_data", "unites.csv"):
		success = false
	if not _load_csv(DIVINITY_DATA_PATHS, "divinities_data", "divinites.csv"):
		success = false
	if not _load_csv(CLASS_DATA_PATHS, "classes_data", "classes.csv"):
		success = false
	if not _load_csv(CRAFT_DATA_PATHS, "craft_data", "craft.csv"):
		success = false
	if not _load_csv(INVOCATION_DATA_PATHS, "invocations_data", "invocations.csv"):
		success = false
	if not _load_csv(ENEMY_DATA_PATHS, "enemies_data", "ennemis.csv"):
		success = false
	if not _load_csv(SPELL_DATA_PATHS, "spells_data", "sorts.csv"):
		success = false
	if not _load_csv(STUFF_DATA_PATHS, "items_data", "stuff.csv"):
		success = false
	data_loaded = success
	data_loaded_successfully.emit()
	if not success:
		data_load_failed.emit("Echec de chargement d'un ou plusieurs fichiers CSV Empire")

## Charge un CSV generique dans la variable membre nommee.
func _load_csv(paths: Array, dest_var: String, filename: String) -> bool:
	var file: FileAccess = _open_file(paths)
	if file == null:
		push_error("Impossible d'ouvrir %s" % filename)
		set(dest_var, [])
		return false
	var content: String = file.get_as_text()
	file.close()
	var lines: PackedStringArray = content.split("\n")
	if lines.size() < 2:
		push_error("%s vide ou invalide" % filename)
		set(dest_var, [])
		return false
	var headers: PackedStringArray = lines[0].split(",")
	for i: int in range(headers.size()):
		headers[i] = headers[i].strip_edges()
	var rows: Array = []
	for i: int in range(1, lines.size()):
		var line: String = lines[i].strip_edges()
		if line.is_empty():
			continue
		var values: PackedStringArray = line.split(",")
		for j: int in range(values.size()):
			values[j] = values[j].strip_edges()
		var entry: Dictionary = {}
		for j: int in range(min(headers.size(), values.size())):
			entry[headers[j]] = values[j]
		rows.append(entry)
	set(dest_var, rows)
	return rows.size() > 0

# ── Accesseurs utilitaires ──────────────────────────────────────────────────

func get_building_data(building_name: String) -> Dictionary:
	for row: Dictionary in buildings_data:
		if row.get("Nom", "") == building_name:
			return row
	return {}

func get_unit_data(unit_name: String) -> Dictionary:
	for row: Dictionary in units_data:
		if row.get("Nom", "") == unit_name:
			return row
	return {}

func get_divinity_data(divinity_name: String) -> Dictionary:
	for row: Dictionary in divinities_data:
		if row.get("Nom", "") == divinity_name:
			return row
	return {}

func get_class_data(class_name_arg: String, level: int) -> Dictionary:
	var best: Dictionary = {}
	var best_lvl: int = -1
	for row: Dictionary in classes_data:
		if row.get("Classe", "") != class_name_arg:
			continue
		var lvl: int = int(row.get("Niveau", "0"))
		if lvl <= level and lvl > best_lvl:
			best = row
			best_lvl = lvl
	return best

func get_craft_item(item_name: String) -> Dictionary:
	for row: Dictionary in craft_data:
		if row.get("Nom", "") == item_name:
			return row
	return {}

func get_invocation_data(invocation_name: String) -> Dictionary:
	for row: Dictionary in invocations_data:
		if row.get("Nom", "") == invocation_name:
			return row
	return {}

func get_enemy_data(enemy_type: String, level: int) -> Dictionary:
	var best: Dictionary = {}
	var best_lvl: int = -1
	for row: Dictionary in enemies_data:
		if row.get("Type", "") != enemy_type:
			continue
		var lvl: int = int(row.get("Niveau", "0"))
		if lvl <= level and lvl > best_lvl:
			best = row
			best_lvl = lvl
	return best

func get_unique_building_names() -> Array:
	var names: Array = []
	for row: Dictionary in buildings_data:
		var n: String = row.get("Nom", "")
		if n != "" and not n in names:
			names.append(n)
	return names

func get_unique_unit_names() -> Array:
	var names: Array = []
	for row: Dictionary in units_data:
		var n: String = row.get("Nom", "")
		if n != "" and not n in names:
			names.append(n)
	return names

func get_unique_divinity_names() -> Array:
	var names: Array = []
	for row: Dictionary in divinities_data:
		var n: String = row.get("Nom", "")
		if n != "" and not n in names:
			names.append(n)
	return names
