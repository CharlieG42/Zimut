extends Node
## DataLoader.gd - Chargeur CSV pour Zimut
## FIX : toutes les fonctions utilitaires ont un type de retour explicite

const CLASS_DATA_PATH := "res://data/classes.csv"
const SPELL_DATA_PATH := "res://data/sorts.csv"
const ENEMY_DATA_PATH := "res://data/ennemis.csv"
const ITEM_DATA_PATH  := "res://data/stuff.csv"

var classes_data: Array = []
var spells_data: Array  = []
var enemies_data: Array = []
var items_data: Array   = []
var data_loaded: bool   = false

signal data_loaded_successfully
signal data_load_failed(error: String)


func _ready() -> void:
	load_all_data()


func load_all_data() -> bool:
	var ok: bool = true
	if not _load_csv(CLASS_DATA_PATH, classes_data, ["Niveau","PA","PM","Vita (PV)",
		"Force (CAC)","Intelligence (Magie)","Agilité (Vit. Atk)","Sagesse (Précision)",
		"Défense","XP pour atteindre ce niveau"]):
		ok = false
		push_error("Impossible de charger classes.csv")

	if not _load_csv(SPELL_DATA_PATH, spells_data, ["Coût PA","Coût PM","Portée","Niveau requis"]):
		ok = false
		push_error("Impossible de charger sorts.csv")

	if not _load_csv(ENEMY_DATA_PATH, enemies_data, ["Niveau","PV","Attaque","Défense","PA","PM","XP"]):
		ok = false
		push_error("Impossible de charger ennemis.csv")

	# items non bloquant
	_load_csv(ITEM_DATA_PATH, items_data, ["Niveau requis","Bonus Force","Bonus Intelligence",
		"Bonus Agilité","Bonus Sagesse","Bonus Vita","Bonus Défense"])

	data_loaded = ok
	if ok:
		data_loaded_successfully.emit()
	else:
		data_load_failed.emit("Échec chargement données")
	return ok


## Charge un CSV générique dans `target_array`
## `numeric_cols` : colonnes à nettoyer des espaces (valeurs numériques)
func _load_csv(path: String, target_array: Array, numeric_cols: Array) -> bool:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		return false
	var content: String = file.get_as_text()
	file.close()

	var lines: PackedStringArray = content.split("\n")
	if lines.size() < 2:
		return false

	var headers: PackedStringArray = lines[0].split(",")
	for i: int in range(headers.size()):
		headers[i] = headers[i].strip_edges()

	target_array.clear()
	for i: int in range(1, lines.size()):
		var line: String = lines[i].strip_edges()
		if line.is_empty():
			continue
		var values: PackedStringArray = line.split(",")
		for j: int in range(values.size()):
			values[j] = values[j].strip_edges()

		var entry: Dictionary = {}
		for j: int in range(mini(headers.size(), values.size())):
			var h: String = headers[j]
			var v: String = values[j]
			if h in numeric_cols:
				v = v.replace(" ", "")
			entry[h] = v
		target_array.append(entry)

	return target_array.size() > 0


# ── Accesseurs utilitaires (types explicites) ───────────────────────────────

func get_class_data(class_name_arg: String, level: int) -> Dictionary:
	for data: Dictionary in classes_data:
		if data.get("Classe", "") == class_name_arg and int(data.get("Niveau", "0")) == level:
			return data
	return {}


func get_spells_for_class(class_name_arg: String) -> Array:
	var result: Array = []
	for spell: Dictionary in spells_data:
		if spell.get("Classe", "") == class_name_arg:
			result.append(spell)
	return result


func get_spells_for_class_and_level(class_name_arg: String, max_level: int) -> Array:
	var result: Array = []
	for spell: Dictionary in spells_data:
		if spell.get("Classe", "") == class_name_arg:
			if int(spell.get("Niveau requis", "1")) <= max_level:
				result.append(spell)
	return result


func get_enemy_data(enemy_type: String, level: int) -> Dictionary:
	for data: Dictionary in enemies_data:
		if data.get("Type", "") == enemy_type and int(data.get("Niveau", "0")) == level:
			return data
	return {}


func get_unique_enemy_types() -> Array:
	var types: Array = []
	for data: Dictionary in enemies_data:
		var t: String = data.get("Type", "")
		if not t in types:
			types.append(t)
	return types


func get_unique_class_names() -> Array:
	var names: Array = []
	for data: Dictionary in classes_data:
		var n: String = data.get("Classe", "")
		if not n in names:
			names.append(n)
	return names
