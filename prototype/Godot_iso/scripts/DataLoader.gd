extends Node
## DataLoader.gd - Chargeur de données CSV pour Zimut
## Charge les données des classes, sorts, ennemis et objets depuis des fichiers CSV
## Ce script est conçu pour être utilisé comme autoload dans project.godot

## Chemins des fichiers CSV (relatifs au projet)
## Sur Android, essayer plusieurs chemins car le système de fichiers peut différer
const CLASS_DATA_PATHS = ["res://data/classes.csv", "user://data/classes.csv", "res://prototype/Godot_iso/data/classes.csv"]
const SPELL_DATA_PATHS = ["res://data/sorts.csv", "user://data/sorts.csv", "res://prototype/Godot_iso/data/sorts.csv"]
const ENEMY_DATA_PATHS = ["res://data/ennemis.csv", "user://data/ennemis.csv", "res://prototype/Godot_iso/data/ennemis.csv"]
const ITEM_DATA_PATHS = ["res://data/stuff.csv", "user://data/stuff.csv", "res://prototype/Godot_iso/data/stuff.csv"]

## Helper function to open file with multiple path attempts
func _open_file(paths: Array) -> FileAccess:
	for path in paths:
		var file = FileAccess.open(path, FileAccess.READ)
		if file != null:
			return file
	return null

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
	
	# Toujours émettre data_loaded_successfully, même avec des données par défaut
	# Cela permet à GameManager de continuer l'initialisation
	data_loaded_successfully.emit()
	
	if not success:
		data_load_failed.emit("Failed to load one or more data files - using defaults")
	
	return success


## Charger les données des classes depuis classes.csv
func load_classes_data():
	var file = _open_file(CLASS_DATA_PATHS)
	if file == null:
		push_error("Cannot open classes.csv in any path - using defaults")
		# Charger des données par défaut si le fichier n'est pas trouvé
		load_default_classes_data()
		return true  # Retourne true car on a des données par défaut
	
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
	var file = _open_file(SPELL_DATA_PATHS)
	if file == null:
		push_error("Cannot open sorts.csv in any path - using defaults")
		# Charger des données par défaut si le fichier n'est pas trouvé
		load_default_spells_data()
		return true  # Retourne true car on a des données par défaut
	
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
			   header == "Portée" or header == "Niveau requis" or \
			   header == "Cout_PA" or header == "Cout_PM" or \
			   header == "Portee" or header == "Niveau_requis" or \
			   header.begins_with("Degats_") or header.begins_with("Soins") or \
			   header.begins_with("Resistance_") or header.begins_with("Debuff_") or \
			   header.begins_with("Buff_"):
				value = value.replace(" ", "")
			
			entry[header] = value
		
		spells_data.append(entry)
	
	return spells_data.size() > 0


## Charger les données des ennemis depuis ennemis.csv
func load_enemies_data():
	var file = _open_file(ENEMY_DATA_PATHS)
	if file == null:
		push_error("Cannot open ennemis.csv in any path - using defaults")
		# Charger des données par défaut si le fichier n'est pas trouvé
		load_default_enemies_data()
		return true  # Retourne true car on a des données par défaut
	
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
	var file = _open_file(ITEM_DATA_PATHS)
	if file == null:
		push_error("Cannot open stuff.csv in any path - using defaults")
		# Charger des données par défaut si le fichier n'est pas trouvé
		load_default_items_data()
		return true  # Retourne true car on a des données par défaut
	
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


## Données par défaut si les fichiers CSV ne sont pas trouvés
func load_default_classes_data():
	classes_data = [
		{"Classe": "Tank", "Niveau": "1", "PA": "5", "PM": "3", "Vita (PV)": "120", "Force (CAC)": "15", "Intelligence (Magie)": "5", "Agilité (Vit. Atk)": "10", "Sagesse (Précision)": "8", "Défense": "20", "XP pour atteindre ce niveau": "100"},
		{"Classe": "Assassin", "Niveau": "1", "PA": "6", "PM": "4", "Vita (PV)": "80", "Force (CAC)": "12", "Intelligence (Magie)": "8", "Agilité (Vit. Atk)": "15", "Sagesse (Précision)": "12", "Défense": "10", "XP pour atteindre ce niveau": "100"},
		{"Classe": "Chasseur", "Niveau": "1", "PA": "5", "PM": "4", "Vita (PV)": "90", "Force (CAC)": "10", "Intelligence (Magie)": "10", "Agilité (Vit. Atk)": "14", "Sagesse (Précision)": "15", "Défense": "12", "XP pour atteindre ce niveau": "100"},
		{"Classe": "Mage", "Niveau": "1", "PA": "4", "PM": "3", "Vita (PV)": "70", "Force (CAC)": "5", "Intelligence (Magie)": "20", "Agilité (Vit. Atk)": "8", "Sagesse (Précision)": "10", "Défense": "8", "XP pour atteindre ce niveau": "100"},
		{"Classe": "Support", "Niveau": "1", "PA": "5", "PM": "3", "Vita (PV)": "85", "Force (CAC)": "8", "Intelligence (Magie)": "15", "Agilité (Vit. Atk)": "10", "Sagesse (Précision)": "12", "Défense": "10", "XP pour atteindre ce niveau": "100"}
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
