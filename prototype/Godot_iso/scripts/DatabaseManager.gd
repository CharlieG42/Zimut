extends Node
## DatabaseManager.gd - Gestionnaire de base de données SQLite pour Zimut
## Remplace DataLoader.gd pour lire depuis zimut.db au lieu des CSV
## Utilise le plugin SQLite de Godot 4.x

## Chemin de la base de données
const DB_PATH = "res://database/zimut.db"

## Données chargées (même structure que DataLoader pour la compatibilité)
var classes_data = []
var spells_data = []
var enemies_data = []
var items_data = []

## État de chargement
var data_loaded = false
var using_database = false
var using_fallback = false

signal data_loaded_successfully
signal data_load_failed(error)
signal data_source_info(source: String)


## Initialisation
func _ready():
	load_all_data()


## Charger toutes les données depuis la base de données
func load_all_data():
	var db = SQLite.new()
	var err = db.open(DB_PATH)
	
	if err != OK:
		push_error("Cannot open database at: %s" % DB_PATH)
		load_fallback_data()
		data_loaded_successfully.emit()
		data_load_failed.emit("Database not found - using fallback data")
		return false
	
	var success = true
	
	# Charger les classes
	if not load_classes_data(db):
		success = false
		push_error("Failed to load classes from database")
	
	# Charger les sorts
	if not load_spells_data(db):
		success = false
		push_error("Failed to load spells from database")
	
	# Charger les ennemis
	if not load_enemies_data(db):
		success = false
		push_error("Failed to load enemies from database")
	
	# Charger les objets
	if not load_items_data(db):
		success = false
		push_error("Failed to load items from database")
	
	db.close()
	
	data_loaded = success
	using_database = success
	
	if success:
		data_source_info.emit("Base de données SQLite (zimut.db) chargée avec succès")
		data_loaded_successfully.emit()
	else:
		data_source_info.emit("ERREUR: Échec du chargement de la base de données")
		data_load_failed.emit("Failed to load one or more tables from database")
	
	return success


## Charger les classes depuis la table classes
func load_classes_data(db: SQLite) -> bool:
	classes_data = []
	
	var query = "SELECT * FROM classes"
	var err = db.execute(query)
	
	if err != OK:
		push_error("Error executing query: %s" % db.get_errmsg())
		return false
	
	# Récupérer les noms de colonnes
	var column_count = db.get_column_count()
	var columns = []
	for i in range(column_count):
		columns.append(db.get_column_name(i))
	
	# Lire les résultats
	while db.step() == OK:
		var entry = {}
		for i in range(column_count):
			var col_name = columns[i]
			var value = db.get_column_text(i)
			entry[col_name] = value
		classes_data.append(entry)
	
	db.reset()
	return classes_data.size() > 0


## Charger les sorts depuis la table sorts
func load_spells_data(db: SQLite) -> bool:
	spells_data = []
	
	var query = "SELECT * FROM sorts"
	var err = db.execute(query)
	
	if err != OK:
		push_error("Error executing query: %s" % db.get_errmsg())
		return false
	
	# Récupérer les noms de colonnes
	var column_count = db.get_column_count()
	var columns = []
	for i in range(column_count):
		columns.append(db.get_column_name(i))
	
	# Lire les résultats
	while db.step() == OK:
		var entry = {}
		for i in range(column_count):
			var col_name = columns[i]
			var value = db.get_column_text(i)
			# Nettoyer les valeurs numériques
			if col_name == "Cout_PA" or col_name == "Cout_PM" or \
			   col_name == "Portee" or col_name == "Niveau_requis" or \
			   col_name.begins_with("Degats_") or col_name.begins_with("Soins") or \
			   col_name.begins_with("Resistance_") or col_name.begins_with("Debuff_") or \
			   col_name.begins_with("Buff_"):
				value = value.replace(" ", "")
			entry[col_name] = value
		spells_data.append(entry)
	
	db.reset()
	return spells_data.size() > 0


## Charger les ennemis depuis la table ennemis
func load_enemies_data(db: SQLite) -> bool:
	enemies_data = []
	
	var query = "SELECT * FROM ennemis"
	var err = db.execute(query)
	
	if err != OK:
		push_error("Error executing query: %s" % db.get_errmsg())
		return false
	
	# Récupérer les noms de colonnes
	var column_count = db.get_column_count()
	var columns = []
	for i in range(column_count):
		columns.append(db.get_column_name(i))
	
	# Lire les résultats
	while db.step() == OK:
		var entry = {}
		for i in range(column_count):
			var col_name = columns[i]
			var value = db.get_column_text(i)
			# Nettoyer les valeurs numériques
			if col_name == "Niveau" or col_name == "PV" or col_name == "Attaque" or \
			   col_name == "Défense" or col_name == "PA" or col_name == "PM" or col_name == "XP":
				value = value.replace(" ", "")
			entry[col_name] = value
		enemies_data.append(entry)
	
	db.reset()
	return enemies_data.size() > 0


## Charger les objets depuis la table stuff
func load_items_data(db: SQLite) -> bool:
	items_data = []
	
	var query = "SELECT * FROM stuff"
	var err = db.execute(query)
	
	if err != OK:
		push_error("Error executing query: %s" % db.get_errmsg())
		return false
	
	# Récupérer les noms de colonnes
	var column_count = db.get_column_count()
	var columns = []
	for i in range(column_count):
		columns.append(db.get_column_name(i))
	
	# Lire les résultats
	while db.step() == OK:
		var entry = {}
		for i in range(column_count):
			var col_name = columns[i]
			var value = db.get_column_text(i)
			entry[col_name] = value
		items_data.append(entry)
	
	db.reset()
	return items_data.size() > 0


## Charger des données par défaut si la base n'est pas disponible
func load_fallback_data():
	# Charger les données par défaut depuis les CSV si disponibles
	var data_loader = preload("res://scripts/DataLoader.gd").new()
	add_child(data_loader)
	
	# Attendre que DataLoader charge les données
	await data_loader.data_loaded_successfully
	
	# Copier les données
	classes_data = data_loader.classes_data
	spells_data = data_loader.spells_data
	enemies_data = data_loader.enemies_data
	items_data = data_loader.items_data
	
	using_fallback = true
	using_database = false
	data_source_info.emit("Fichiers CSV chargés (zimut.db non trouvé)")
	
	data_loaded = true


# ── Accesseurs utilitaires (compatibilité avec DataLoader) ──────────────────

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
			if int(spell.get("Niveau_requis", "1")) <= max_level:
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
