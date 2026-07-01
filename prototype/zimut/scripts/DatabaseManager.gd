extends Node
## DatabaseManager.gd - Gestionnaire de données pour Zimut
## Pour l'instant, utilise DataLoader (CSV) car SQLite n'est pas disponible
## Peut être migré vers SQLite plus tard

## Données chargées (même structure que DataLoader pour la compatibilité)
var classes_data = []
var spells_data = []
var enemies_data = []
var items_data = []

## État de chargement
var data_loaded = false
var using_database = false
var using_fallback = true

signal data_loaded_successfully
signal data_load_failed(error)
signal data_source_info(source: String)


## Initialisation
func _ready():
	load_all_data()


## Charger toutes les données depuis DataLoader (CSV)
func load_all_data():
	# Pour l'instant, on utilise DataLoader (CSV)
	var data_loader = preload("res://scripts/DataLoader.gd").new()
	add_child(data_loader)
	
	# Attendre que DataLoader charge les données
	await data_loader.data_loaded_successfully
	
	# Copier les données
	classes_data = data_loader.classes_data
	spells_data = data_loader.spells_data
	enemies_data = data_loader.enemies_data
	items_data = data_loader.items_data
	
	data_loaded = true
	using_database = false
	using_fallback = true
	
	data_source_info.emit("Fichiers CSV chargés (SQLite non activé)")
	data_loaded_successfully.emit()
	
	return true


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
