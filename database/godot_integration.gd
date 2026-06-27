# Gestionnaire de données SQLite pour Zimut (Godot)
# Inspiré de Waven, ce script permet d'interroger la base de données depuis Godot.
#
# Pour utiliser ce script :
# 1. Copiez `zimut.db` dans le dossier `res://assets/` de votre projet Godot.
# 2. Attachez ce script à un nœud (ex: un nœud `Node` nommé `DatabaseManager`).
# 3. Utilisez les méthodes fournies pour interroger la base.

extends Node

# Chemin vers la base de données
@export var db_path: String = "res://assets/zimut.db"

# Connexion SQLite
var db: SQLite = null

# Cache pour les données fréquemment utilisées
var _class_cache: Dictionary = {}
var _spell_cache: Dictionary = {}
var _enemy_cache: Dictionary = {}
var _item_cache: Dictionary = {}


# ==================== Initialisation ====================

func _ready():
	# Initialiser la connexion SQLite
	if SQLite.is_available():
		db = SQLite.new()
		db.path = db_path
		if db.open() == OK:
			print("Base de données SQLite ouverte avec succès : ", db_path)
		else:
			print("Erreur : Impossible d'ouvrir la base de données ", db_path)
	else:
		print("Erreur : Le module SQLite n'est pas disponible.")


func _exit_tree():
	# Fermer la connexion
	if db:
		db.close()


# ==================== Méthodes pour les classes ====================

# Récupère les stats d'une classe à un niveau donné
func get_class_stats(class_name: String, level: int) -> Dictionary:
	var cache_key = class_name + "_" + str(level)
	if _class_cache.has(cache_key):
		return _class_cache[cache_key]
	
	var query = """
		SELECT 
			cl.pa, cl.pm, cl.vita, cl.force, cl.intelligence, 
			cl.agility, cl.wisdom, cl.defense, cl.xp_required
		FROM class_levels cl
		JOIN classes c ON cl.class_id = c.id
		WHERE c.name = ? AND cl.level = ?
	"""
	
	db.query(query, [class_name, level])
	var result = db.fetch()
	
	if result.size() > 0:
		_class_cache[cache_key] = result[0]
		return result[0]
	
	return {}


# Récupère tous les niveaux d'une classe
func get_all_class_levels(class_name: String) -> Array:
	var query = """
		SELECT level, pa, pm, vita, force, intelligence, agility, wisdom, defense, xp_required
		FROM class_levels cl
		JOIN classes c ON cl.class_id = c.id
		WHERE c.name = ?
		ORDER BY level
	"""
	
	db.query(query, [class_name])
	return db.fetch()


# ==================== Méthodes pour les sorts ====================

# Récupère tous les sorts d'une classe à un niveau donné
func get_class_spells(class_name: String, level: int) -> Array:
	var cache_key = class_name + "_spells_" + str(level)
	if _spell_cache.has(cache_key):
		return _spell_cache[cache_key]
	
	var query = """
		SELECT s.name, s.cost_pa, s.cost_pm, s.range, s.effect, s.spell_type
		FROM spells s
		JOIN class_spells cs ON s.id = cs.spell_id
		JOIN classes c ON cs.class_id = c.id
		WHERE c.name = ? AND cs.level_required <= ?
		ORDER BY s.required_level
	"""
	
	db.query(query, [class_name, level])
	var result = db.fetch()
	_spell_cache[cache_key] = result
	return result


# Récupère un sort par son nom et sa classe
func get_spell(class_name: String, spell_name: String) -> Dictionary:
	var cache_key = class_name + "_" + spell_name
	if _spell_cache.has(cache_key):
		return _spell_cache[cache_key]
	
	var query = """
		SELECT name, cost_pa, cost_pm, range, effect, required_level, spell_type
		FROM spells
		WHERE name = ? AND class_required = ?
	"""
	
	db.query(query, [spell_name, class_name])
	var result = db.fetch()
	
	if result.size() > 0:
		_spell_cache[cache_key] = result[0]
		return result[0]
	
	return {}


# ==================== Méthodes pour les ennemis ====================

# Récupère un ennemi par son type et son niveau
func get_enemy(enemy_type: String, level: int) -> Dictionary:
	var cache_key = enemy_type + "_" + str(level)
	if _enemy_cache.has(cache_key):
		return _enemy_cache[cache_key]
	
	var query = """
		SELECT type, level, pv, attack, defense, pa, pm, xp, biome, special_effects
		FROM enemies
		WHERE type = ? AND level = ?
	"""
	
	db.query(query, [enemy_type, level])
	var result = db.fetch()
	
	if result.size() > 0:
		_enemy_cache[cache_key] = result[0]
		return result[0]
	
	return {}


# Récupère tous les ennemis d'un biome
func get_enemies_by_biome(biome: String) -> Array:
	var query = """
		SELECT type, level, pv, attack, defense, pa, pm, xp, special_effects
		FROM enemies
		WHERE biome = ?
		ORDER BY level
	"""
	
	db.query(query, [biome])
	return db.fetch()


# Récupère des ennemis aléatoires pour un combat
func get_random_enemies(biome: String, count: int, min_level: int, max_level: int) -> Array:
	var enemies = get_enemies_by_biome(biome)
	var filtered = []
	
	for enemy in enemies:
		if enemy["level"] >= min_level and enemy["level"] <= max_level:
			filtered.append(enemy)
	
	# Mélanger et sélectionner `count` ennemis
	filtered.shuffle()
	return filtered.slice(0, min(count, filtered.size()))


# ==================== Méthodes pour les items ====================

# Récupère un item par son nom
func get_item(item_name: String) -> Dictionary:
	if _item_cache.has(item_name):
		return _item_cache[item_name]
	
	var query = """
		SELECT 
			i.name, i.required_level, i.bonus_force, i.bonus_intelligence,
			i.bonus_agility, i.bonus_wisdom, i.bonus_vita, i.bonus_defense, i.special_effect,
			it.name as type_name
		FROM items i
		JOIN item_types it ON i.type_id = it.id
		WHERE i.name = ?
	"""
	
	db.query(query, [item_name])
	var result = db.fetch()
	
	if result.size() > 0:
		_item_cache[item_name] = result[0]
		return result[0]
	
	return {}


# Récupère tous les items accessibles à un niveau donné
func get_items_by_level(max_level: int) -> Array:
	var query = """
		SELECT 
			i.name, i.required_level, i.bonus_force, i.bonus_intelligence,
			i.bonus_agility, i.bonus_wisdom, i.bonus_vita, i.bonus_defense, i.special_effect,
			it.name as type_name
		FROM items i
		JOIN item_types it ON i.type_id = it.id
		WHERE i.required_level <= ?
		ORDER BY i.required_level
	"""
	
	db.query(query, [max_level])
	return db.fetch()


# ==================== Méthodes pour les invocations ====================

# Récupère une invocation par son nom
func get_invocation(invocation_name: String) -> Dictionary:
	var query = """
		SELECT name, required_level, pv, attack, defense, pa, pm, invocation_type, biome
		FROM invocations
		WHERE name = ?
	"""
	
	db.query(query, [invocation_name])
	var result = db.fetch()
	
	if result.size() > 0:
		return result[0]
	
	return {}


# Récupère les sorts d'une invocation
func get_invocation_spells(invocation_name: String) -> Array:
	var query = """
		SELECT name, cost_pa, cost_pm, range, effect, spell_type
		FROM invocation_spells
		WHERE invocation_id = (
			SELECT id FROM invocations WHERE name = ?
		)
	"""
	
	db.query(query, [invocation_name])
	return db.fetch()


# ==================== Méthodes utilitaires pour le combat ====================

# Récupère toutes les données de combat pour un joueur
func get_player_combat_data(class_name: String, level: int) -> Dictionary:
	var data = {
		"class_name": class_name,
		"level": level,
		"stats": get_class_stats(class_name, level),
		"spells": get_class_spells(class_name, level)
	}
	return data


# Récupère toutes les données de combat pour un ennemi
func get_enemy_combat_data(enemy_type: String, level: int) -> Dictionary:
	var data = {
		"enemy_type": enemy_type,
		"level": level,
		"stats": get_enemy(enemy_type, level)
	}
	return data


# Récupère des données de combat pour un groupe d'ennemis
func get_combat_enemies(biome: String, count: int, player_level: int) -> Array:
	# Sélectionner des ennemis avec un niveau proche de celui du joueur
	var min_level = max(1, player_level - 5)
	var max_level = player_level + 5
	return get_random_enemies(biome, count, min_level, max_level)


# ==================== Exemple d'utilisation ====================

# Voici comment utiliser ce script depuis une scène de combat :
#
# 1. Dans votre scène de combat, ajoutez un nœud `DatabaseManager` avec ce script.
# 2. Depuis votre script de combat, accédez au gestionnaire :
#
#    var db_manager = get_node("/root/DatabaseManager")
#    var player_data = db_manager.get_player_combat_data("Tank", 10)
#    var enemies = db_manager.get_combat_enemies("Forêt", 3, 10)
#
# 3. Utilisez les données pour initialiser votre combat :
#
#    for enemy in enemies:
#        var enemy_node = preload("res://scenes/enemy.tscn").instantiate()
#        enemy_node.init(enemy["type"], enemy["level"], enemy["pv"], enemy["attack"])
#        add_child(enemy_node)
