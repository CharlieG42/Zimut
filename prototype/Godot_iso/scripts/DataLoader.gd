extends Node
## DataLoader.gd - Chargeur de données CSV pour Zimut
## Charge les données des classes, sorts, ennemis et objets depuis des fichiers CSV
## Ce script est conçu pour être utilisé comme autoload dans project.godot

## Chemins des fichiers CSV (relatifs au projet)
const CLASS_DATA_PATH = "res://data/classes.csv"
const SPELL_DATA_PATH = "res://data/sorts.csv"
const ENEMY_DATA_PATH = "res://data/ennemis.csv"
const ITEM_DATA_PATH = "res://data/stuff.csv"

## Données chargées
var classes_data = []
var spells_data = []
var enemies_data = []
var items_data = []

## État de chargement
var data_loaded = false

signal data_loaded_successfully
signal data_load_failed(error)


## Charger toutes les données au démarrage
func _ready():
	load_all_data()


## Charger toutes les données
func load_all_data():
	var success = true
	
	if not load_classes_data():
		success = false
		push_error("Failed to load classes data")
	
	if not load_spells_data():
		success = false
		push_error("Failed to load spells data")
	
	if not load_enemies_data():
		success = false
		push_error("Failed to load enemies data")
	
	if not load_items_data():
		success = false
		push_error("Failed to load items data")
	
	data_loaded = success
	
	if success:
		data_loaded_successfully.emit()
	else:
		data_load_failed.emit("Failed to load one or more data files")
	
	return success


## Charger les données des classes depuis classes.csv
func load_classes_data():
	var file = FileAccess.open(CLASS_DATA_PATH, FileAccess.READ)
	if file == null:
		push_error("Cannot open classes.csv at: %s" % CLASS_DATA_PATH)
		return false
	
	var content = file.get_as_text()
	file.close()
	
	var lines = content.split("\n")
	if lines.size() < 2:
		push_error("classes.csv is empty or invalid")
		return false
	
	# Lire l'en-tête
	var headers = lines[0].split(",")
	for i in range(headers.size()):
		headers[i] = headers[i].strip_edges()
	
	# Lire les données
	classes_data = []
	for i in range(1, lines.size()):
		var line = lines[i].strip_edges()
		if line.is_empty():
			continue
		
		var values = line.split(",")
		for j in range(values.size()):
			values[j] = values[j].strip_edges()
		
		# Créer un dictionnaire pour cette ligne
		var entry = {}
		for j in range(min(headers.size(), values.size())):
			var header = headers[j]
			var value = values[j]
			
			# Nettoyer les valeurs numériques (enlever les espaces dans les nombres)
			if header == "Niveau" or header == "PA" or header == "PM" or \
			   header == "Vita (PV)" or header == "Force (CAC)" or \
			   header == "Intelligence (Magie)" or header == "Agilité (Vit. Atk)" or \
			   header == "Sagesse (Précision)" or header == "Défense" or \
			   header == "XP pour atteindre ce niveau":
				value = value.replace(" ", "")
			
			entry[header] = value
		
		classes_data.append(entry)
	
	return classes_data.size() > 0


## Charger les données des sorts depuis sorts.csv
func load_spells_data():
	var file = FileAccess.open(SPELL_DATA_PATH, FileAccess.READ)
	if file == null:
		push_error("Cannot open sorts.csv at: %s" % SPELL_DATA_PATH)
		return false
	
	var content = file.get_as_text()
	file.close()
	
	var lines = content.split("\n")
	if lines.size() < 2:
		push_error("sorts.csv is empty or invalid")
		return false
	
	# Lire l'en-tête
	var headers = lines[0].split(",")
	for i in range(headers.size()):
		headers[i] = headers[i].strip_edges()
	
	# Lire les données
	spells_data = []
	for i in range(1, lines.size()):
		var line = lines[i].strip_edges()
		if line.is_empty():
			continue
		
		var values = line.split(",")
		for j in range(values.size()):
			values[j] = values[j].strip_edges()
		
		# Créer un dictionnaire pour cette ligne
		var entry = {}
		for j in range(min(headers.size(), values.size())):
			var header = headers[j]
			var value = values[j]
			
			# Nettoyer les valeurs numériques
			if header == "Coût PA" or header == "Coût PM" or \
			   header == "Portée" or header == "Niveau requis":
				value = value.replace(" ", "")
			
			entry[header] = value
		
		spells_data.append(entry)
	
	return spells_data.size() > 0


## Charger les données des ennemis depuis ennemis.csv
func load_enemies_data():
	var file = FileAccess.open(ENEMY_DATA_PATH, FileAccess.READ)
	if file == null:
		push_error("Cannot open ennemis.csv at: %s" % ENEMY_DATA_PATH)
		return false
	
	var content = file.get_as_text()
	file.close()
	
	var lines = content.split("\n")
	if lines.size() < 2:
		push_error("ennemis.csv is empty or invalid")
		return false
	
	# Lire l'en-tête
	var headers = lines[0].split(",")
	for i in range(headers.size()):
		headers[i] = headers[i].strip_edges()
	
	# Lire les données
	enemies_data = []
	for i in range(1, lines.size()):
		var line = lines[i].strip_edges()
		if line.is_empty():
			continue
		
		var values = line.split(",")
		for j in range(values.size()):
			values[j] = values[j].strip_edges()
		
		# Créer un dictionnaire pour cette ligne
		var entry = {}
		for j in range(min(headers.size(), values.size())):
			var header = headers[j]
			var value = values[j]
			
			# Nettoyer les valeurs numériques
			if header == "Niveau" or header == "PV" or header == "Attaque" or \
			   header == "Défense" or header == "PA" or header == "PM" or header == "XP":
				value = value.replace(" ", "")
			
			entry[header] = value
		
		enemies_data.append(entry)
	
	return enemies_data.size() > 0


## Charger les données des objets depuis stuff.csv
func load_items_data():
	var file = FileAccess.open(ITEM_DATA_PATH, FileAccess.READ)
	if file == null:
		push_error("Cannot open stuff.csv at: %s" % ITEM_DATA_PATH)
		return false
	
	var content = file.get_as_text()
	file.close()
	
	var lines = content.split("\n")
	if lines.size() < 2:
		push_error("stuff.csv is empty or invalid")
		return false
	
	# Lire l'en-tête
	var headers = lines[0].split(",")
	for i in range(headers.size()):
		headers[i] = headers[i].strip_edges()
	
	# Lire les données
	items_data = []
	for i in range(1, lines.size()):
		var line = lines[i].strip_edges()
		if line.is_empty():
			continue
		
		var values = line.split(",")
		for j in range(values.size()):
			values[j] = values[j].strip_edges()
		
		# Créer un dictionnaire pour cette ligne
		var entry = {}
		for j in range(min(headers.size(), values.size())):
			var header = headers[j]
			var value = values[j]
			
			# Nettoyer les valeurs numériques
			if header == "Niveau requis" or header == "Bonus Force" or \
			   header == "Bonus Intelligence" or header == "Bonus Agilité" or \
			   header == "Bonus Sagesse" or header == "Bonus Vita" or header == "Bonus Défense":
				value = value.replace(" ", "")
			
			entry[header] = value
		
		items_data.append(entry)
	
	return items_data.size() > 0


# ── Accesseurs utilitaires ───────────────────────────────────────────────

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
