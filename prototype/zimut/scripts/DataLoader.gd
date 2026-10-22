extends Node
## DataLoader.gd - Chargeur de données CSV pour Zimut (refactorisé)
## Charge les données des classes, sorts, ennemis et objets depuis des fichiers CSV
## Ce script est conçu pour être utilisé comme autoload dans project.godot

## Chemins des fichiers CSV (relatifs au projet)
## Sur Android, essayer plusieurs chemins car le système de fichiers peut différer
const CLASS_DATA_PATHS = ["res://data/classes.txt", "user://data/classes.txt", "res://prototype/Godot_iso/data/classes.txt"]
const SPELL_DATA_PATHS = ["res://data/sorts.txt", "user://data/sorts.txt", "res://prototype/Godot_iso/data/sorts.txt"]
const ENEMY_DATA_PATHS = ["res://data/ennemis.txt", "user://data/ennemis.txt", "res://prototype/Godot_iso/data/ennemis.txt"]
const ITEM_DATA_PATHS = ["res://data/stuff.txt", "user://data/stuff.txt", "res://prototype/Godot_iso/data/stuff.txt"]

## Colonnes numériques à nettoyer (espaces dans les nombres) par fichier CSV
const NUMERIC_COLS: Dictionary = {
	"classes": ["Niveau", "PA", "PM", "Vita (PV)", "Force (CAC)", "Intelligence (Magie)",
		"Agilité (Vit. Atk)", "Sagesse (Précision)", "Défense", "XP pour atteindre ce niveau"],
	"spells": ["Coût PA", "Coût PM", "Portée", "Niveau requis", "Cout_PA", "Cout_PM",
		"Portee", "Niveau_requis"],
	"enemies": ["Niveau", "PV", "Attaque", "Défense", "PA", "PM", "XP"],
	"items": ["Niveau requis", "Bonus Force", "Bonus Intelligence", "Bonus Agilité",
		"Bonus Sagesse", "Bonus Vita", "Bonus Défense"],
}

## Données chargées
var classes_data: Array = []
var spells_data: Array = []
var enemies_data: Array = []
var items_data: Array = []

## État de chargement
var data_loaded: bool = false

signal data_loaded_successfully
signal data_load_failed(error)


func _ready() -> void:
	load_all_data()


## Charger toutes les données au démarrage
func load_all_data() -> bool:
	var success: bool = true

	classes_data = _load_csv(CLASS_DATA_PATHS, "classes", "classes.txt")
	if classes_data.is_empty():
		push_error("Failed to load classes data")
		success = false

	spells_data = _load_csv(SPELL_DATA_PATHS, "spells", "sorts.txt")
	if spells_data.is_empty():
		push_error("Failed to load spells data")
		success = false

	enemies_data = _load_csv(ENEMY_DATA_PATHS, "enemies", "ennemis.txt")
	if enemies_data.is_empty():
		push_error("Failed to load enemies data")
		success = false

	items_data = _load_csv(ITEM_DATA_PATHS, "items", "stuff.txt")
	if items_data.is_empty():
		push_error("Failed to load items data")
		success = false

	data_loaded = success
	data_loaded_successfully.emit()

	if not success:
		data_load_failed.emit("Failed to load one or more data files - using defaults")

	return success


# ─────────────────────────────────────────────
#  Parsing CSV générique
# ─────────────────────────────────────────────

## Ouvre un fichier en essayant plusieurs chemins
func _open_file(paths: Array) -> FileAccess:
	for path: String in paths:
		var file: FileAccess = FileAccess.open(path, FileAccess.READ)
		if file != null:
			return file
	return null

## Charge un CSV et retourne un tableau de dictionnaires.
## `kind` = clé dans NUMERIC_COLS ("classes", "spells", "enemies", "items")
## `label` = nom du fichier pour les messages d'erreur
func _load_csv(paths: Array, kind: String, label: String) -> Array:
	var file: FileAccess = _open_file(paths)
	if file == null:
		push_error("Cannot open %s in any path - using defaults" % label)
		return _load_defaults(kind)

	var content: String = file.get_as_text()
	file.close()

	var lines: PackedStringArray = content.split("\n")
	if lines.size() < 2:
		push_error("%s is empty or invalid" % label)
		return _load_defaults(kind)

	var headers: PackedStringArray = lines[0].split(",")
	for i: int in range(headers.size()):
		headers[i] = headers[i].strip_edges()

	var numeric_cols: Array = NUMERIC_COLS.get(kind, [])
	var out: Array = []
	for i: int in range(1, lines.size()):
		var line: String = lines[i].strip_edges()
		if line.is_empty():
			continue
		var values: PackedStringArray = line.split(",")
		for j: int in range(values.size()):
			values[j] = values[j].strip_edges()
		var entry: Dictionary = {}
		for j: int in range(mini(headers.size(), values.size())):
			var header: String = headers[j]
			var value: String = values[j]
			if numeric_cols.has(header) or _is_numeric_prefix(header):
				value = value.replace(" ", "")
			entry[header] = value
		out.append(entry)

	if out.is_empty():
		push_error("%s: no data rows found" % label)
		return _load_defaults(kind)

	return out


## Préfixes de colonnes numériques pour les sorts (Degats_*, Soins, etc.)
func _is_numeric_prefix(header: String) -> bool:
	return header.begins_with("Degats_") or header.begins_with("Soins") \
		or header.begins_with("Resistance_") or header.begins_with("Debuff_") \
		or header.begins_with("Buff_")


## Charge les données par défaut pour un kind et retourne le tableau
func _load_defaults(kind: String) -> Array:
	match kind:
		"classes":
			load_default_classes_data()
			return classes_data
		"spells":
			load_default_spells_data()
			return spells_data
		"enemies":
			load_default_enemies_data()
			return enemies_data
		"items":
			load_default_items_data()
			return items_data
	return []


# ─────────────────────────────────────────────
#  Accesseurs utilitaires
# ─────────────────────────────────────────────

func get_class_data(class_name_arg, level):
	for data in classes_data:
		if data.get("Classe", "") == class_name_arg and int(data.get("Niveau", "0")) == level:
			return data
	return {}


func get_spells_for_class(class_name_arg):
	var result = []
	for spell in spells_data:
		if spell.get("Classe", "") == class_name_arg:
			result.append(spell)
	return result


func get_spells_for_class_and_level(class_name_arg, max_level):
	var result = []
	for spell in spells_data:
		if spell.get("Classe", "") == class_name_arg:
			if int(spell.get("Niveau requis", "1")) <= max_level:
				result.append(spell)
	return result


func get_enemy_data(enemy_type, level):
	for data in enemies_data:
		if data.get("Type", "") == enemy_type and int(data.get("Niveau", "0")) == level:
			return data
	return {}


func get_unique_enemy_types():
	var types = []
	for data in enemies_data:
		var t = data.get("Type", "")
		if not t in types:
			types.append(t)
	return types


func get_unique_class_names():
	var names = []
	for data in classes_data:
		var n = data.get("Classe", "")
		if not n in names:
			names.append(n)
	return names


# ─────────────────────────────────────────────
#  Données par défaut si les fichiers CSV ne sont pas trouvés
# ─────────────────────────────────────────────

func load_default_classes_data():
	classes_data = [
		{"Classe": "Tank", "Niveau": "1", "PA": "5", "PM": "3", "Vita (PV)": "120", "Force (CAC)": "15", "Intelligence (Magie)": "5", "Agilité (Vit. Atk)": "10", "Sagesse (Précision)": "8", "Défense": "20", "XP pour atteindre ce niveau": "100"},
		{"Classe": "Assassin", "Niveau": "1", "PA": "6", "PM": "4", "Vita (PV)": "80", "Force (CAC)": "12", "Intelligence (Magie)": "8", "Agilité (Vit. Atk)": "15", "Sagesse (Précision)": "12", "Défense": "10", "XP pour atteindre ce niveau": "100"},
		{"Classe": "Chasseur", "Niveau": "1", "PA": "5", "PM": "4", "Vita (PV)": "90", "Force (CAC)": "10", "Intelligence (Magie)": "10", "Agilité (Vit. Atk)": "14", "Sagesse (Précision)": "15", "Défense": "12", "XP pour atteindre ce niveau": "100"},
		{"Classe": "Mage", "Niveau": "1", "PA": "4", "PM": "3", "Vita (PV)": "70", "Force (CAC)": "5", "Intelligence (Magie)": "20", "Agilité (Vit. Atk)": "8", "Sagesse (Précision)": "10", "Défense": "8", "XP pour atteindre ce niveau": "100"},
		{"Classe": "Druide", "Niveau": "1", "PA": "5", "PM": "3", "Vita (PV)": "85", "Force (CAC)": "8", "Intelligence (Magie)": "15", "Agilité (Vit. Atk)": "10", "Sagesse (Précision)": "12", "Défense": "10", "XP pour atteindre ce niveau": "100"}
	]
	push_warning("Loaded default classes data - CSV files not found")


func load_default_spells_data():
	spells_data = [
		{"Classe": "Tank", "Nom": "Coup de bouclier", "Cout_PA": "1", "Cout_PM": "0", "Portee": "1", "Effet": "15 dégâts + étourdit 1 tour (50%)", "Niveau_requis": "1", "Type": "Attaque", "Degats_physiques": "15", "Degats_magiques": "0", "Soins": "0", "Resistance_physique": "0", "Resistance_magique": "0", "Debuff_physique": "0", "Debuff_magique": "0", "Buff_physique": "0", "Buff_magique": "0"},
		{"Classe": "Tank", "Nom": "Soin de combat", "Cout_PA": "2", "Cout_PM": "0", "Portee": "1", "Effet": "Restaure 20 PV", "Niveau_requis": "1", "Type": "Soin", "Degats_physiques": "0", "Degats_magiques": "0", "Soins": "20", "Resistance_physique": "0", "Resistance_magique": "0", "Debuff_physique": "0", "Debuff_magique": "0", "Buff_physique": "0", "Buff_magique": "0"},
		{"Classe": "Assassin", "Nom": "Lame fatale", "Cout_PA": "3", "Cout_PM": "1", "Portee": "2", "Effet": "30 dégâts (critique si dos tourné)", "Niveau_requis": "1", "Type": "Attaque", "Degats_physiques": "30", "Degats_magiques": "0", "Soins": "0", "Resistance_physique": "0", "Resistance_magique": "0", "Debuff_physique": "0", "Debuff_magique": "0", "Buff_physique": "0", "Buff_magique": "0"},
		{"Classe": "Mage", "Nom": "Boule de feu", "Cout_PA": "4", "Cout_PM": "0", "Portee": "5", "Effet": "30 dégâts magiques", "Niveau_requis": "1", "Type": "Magie", "Degats_physiques": "0", "Degats_magiques": "30", "Soins": "0", "Resistance_physique": "0", "Resistance_magique": "0", "Debuff_physique": "0", "Debuff_magique": "0", "Buff_physique": "0", "Buff_magique": "0"}
	]
	push_warning("Loaded default spells data - CSV files not found")


func load_default_enemies_data():
	enemies_data = [
		{"Type": "Gobelin", "Niveau": "1", "PV": "40", "Attaque": "8", "Défense": "2", "PA": "3", "PM": "2", "XP": "50"},
		{"Type": "Squelette", "Niveau": "1", "PV": "50", "Attaque": "10", "Défense": "5", "PA": "2", "PM": "2", "XP": "60"},
		{"Type": "Loup", "Niveau": "1", "PV": "35", "Attaque": "12", "Défense": "1", "PA": "3", "PM": "3", "XP": "45"}
	]
	push_warning("Loaded default enemies data - CSV files not found")


func load_default_items_data():
	items_data = []
	push_warning("Loaded default items data - CSV files not found")
