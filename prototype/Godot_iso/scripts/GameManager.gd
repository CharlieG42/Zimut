extends Node
## GameManager - Gère la logique globale du jeu WildZimut (version isométrique)
## Ce script est un autoload (configuré dans project.godot)

const GRID_SIZE := 10
const CELL_SIZE := Vector2i(100, 100)
const CELL_HALF_OFFSET := Vector2i(50, 50)

const COLORS := {
	"Tank": Color(0, 0.4, 0.8),
	"Assassin": Color(0.8, 0, 0),
	"Chasseur": Color(0, 0.8, 0),
	"Mage": Color(0.6, 0, 0.8),
	"Support": Color(1, 0.8, 0),
	"Heal": Color(0, 0.8, 0.8),
	"Gobelin": Color(0.5, 0.8, 0.3),
	"Squelette": Color(0.8, 0.8, 0.8),
	"Loup": Color(0.6, 0.6, 0.4),
}

var grid: Array = []
var players: Array = []
var enemies: Array = []
var current_turn: int = 0
var current_player_index: int = 0
var turn_count: int = 1
var selected_entity = null
var selected_spell = null
var selected_cell: Vector2i = Vector2i(0, 0)
var show_spells: bool = false
var game_over: bool = false
var victory: bool = false

signal turn_changed(turn: int)
signal player_changed(index: int)
signal entity_selected(entity)
signal spell_selected(spell)
signal game_ended(victory: bool)
signal entity_moved(entity, from_pos: Vector2i, to_pos: Vector2i)
signal entity_attacked(attacker, target, damage: int)
signal spell_casted(caster, spell, target, result: String)
signal message_requested(text: String)

var classes_data: Array = []
var spells_data: Array = []
var enemies_data: Array = []


func _ready():
	randomize()
	load_data()
	init_grid()
	init_entities()
	current_turn = 0
	turn_count = 1
	turn_changed.emit(current_turn)
	
	# FIX: S'assurer que le Tank (index 0) est bien le premier joueur sélectionné
	if players.size() > 0:
		var first_alive_index = 0
		for i in range(players.size()):
			if players[i]["current_pv"] > 0:
				first_alive_index = i
				break
		current_player_index = first_alive_index
		selected_entity = players[current_player_index]
		players[current_player_index]["is_active"] = true
		show_spells = true  # Afficher les sorts pour le joueur sélectionné
		entity_selected.emit(selected_entity)
		player_changed.emit(current_player_index)


func load_data():
	classes_data = [
		{"Classe": "Tank", "Niveau": "30", "Vita (PV)": "120", "Force (CAC)": "20", "Intelligence (Magie)": "5", "Agilité (Vit. Atk)": "5", "Sagesse (Précision)": "10", "Défense": "30", "PA": "6", "PM": "3"},
		{"Classe": "Assassin", "Niveau": "30", "Vita (PV)": "80", "Force (CAC)": "15", "Intelligence (Magie)": "10", "Agilité (Vit. Atk)": "25", "Sagesse (Précision)": "20", "Défense": "10", "PA": "7", "PM": "4"},
		{"Classe": "Mage", "Niveau": "30", "Vita (PV)": "60", "Force (CAC)": "5", "Intelligence (Magie)": "25", "Agilité (Vit. Atk)": "10", "Sagesse (Précision)": "15", "Défense": "5", "PA": "8", "PM": "3"}
	]
	spells_data = [
		{"Nom": "Coup puissant", "Classe": "Tank", "Coût PA": "1", "Coût PM": "0", "Portée": "10", "Effet": "25 dégâts", "Niveau requis": "1", "Type": "CAC"},
		{"Nom": "Bouclier", "Classe": "Tank", "Coût PA": "2", "Coût PM": "0", "Portée": "10", "Effet": "Réduit les dégâts de 50% pour 1 tour", "Niveau requis": "5", "Type": "Défense"},
		{"Nom": "Attaque furtive", "Classe": "Assassin", "Coût PA": "1", "Coût PM": "2", "Portée": "10", "Effet": "30 dégâts + ignore 50% défense", "Niveau requis": "1", "Type": "CAC"},
		{"Nom": "Poison", "Classe": "Assassin", "Coût PA": "2", "Coût PM": "0", "Portée": "10", "Effet": "15 dégâts + poison", "Niveau requis": "5", "Type": "Magie"},
		{"Nom": "Boule de feu", "Classe": "Mage", "Coût PA": "3", "Coût PM": "0", "Portée": "10", "Effet": "40 dégâts", "Niveau requis": "1", "Type": "Magie"},
		{"Nom": "Soin", "Classe": "Mage", "Coût PA": "2", "Coût PM": "0", "Portée": "10", "Effet": "Restaure 30 PV", "Niveau requis": "3", "Type": "Soin"}
	]
	enemies_data = [
		{"Type": "Gobelin", "Niveau": "30", "PV": "60", "Attaque": "12", "Défense": "5", "PA": "5", "PM": "3", "Biome": "Forêt"},
		{"Type": "Squelette", "Niveau": "30", "PV": "50", "Attaque": "15", "Défense": "10", "PA": "4", "PM": "2", "Biome": "Donjon"},
		{"Type": "Loup", "Niveau": "30", "PV": "70", "Attaque": "10", "Défense": "3", "PA": "6", "PM": "4", "Biome": "Plaine"}
	]


func init_grid():
	grid = []
	for y in range(GRID_SIZE):
		var row: Array = []
		for x in range(GRID_SIZE):
			row.append(null)
		grid.append(row)


func init_entities():
	var player_classes: Array = ["Tank", "Assassin", "Mage"]
	var player_positions: Array[Vector2i] = [Vector2i(2, 2), Vector2i(2, 3), Vector2i(3, 2)]
	players = []
	
	for i in range(player_classes.size()):
		var classe = player_classes[i]
		var pos = player_positions[i]
		var class_info = null
		for data in classes_data:
			if data["Classe"] == classe and data["Niveau"] == "30":
				class_info = data
				break
		if class_info:
			var player = {
				"name": "%s Lv30" % classe,
				"entity_type": "Player",
				"classe": classe,
				"level": 30,
				"max_pv": int(class_info["Vita (PV)"]),
				"current_pv": int(class_info["Vita (PV)"]),
				"force": int(class_info["Force (CAC)"]),
				"intelligence": int(class_info["Intelligence (Magie)"]),
				"agility": int(class_info["Agilité (Vit. Atk)"]),
				"wisdom": int(class_info["Sagesse (Précision)"]),
				"defense": int(class_info["Défense"]),
				"max_pa": int(class_info["PA"]),
				"current_pa": int(class_info["PA"]),
				"max_pm": int(class_info["PM"]),
				"current_pm": int(class_info["PM"]),
				"x": pos.x,
				"y": pos.y,
				"spells": [],
				"is_active": false
			}
			for spell_info in spells_data:
				if spell_info["Classe"] == classe and int(spell_info["Niveau requis"]) <= 30:
					player["spells"].append({
						"name": spell_info["Nom"],
						"classe": spell_info["Classe"],
						"cost_pa": int(spell_info["Coût PA"]),
						"cost_pm": int(spell_info["Coût PM"]),
						"range": int(spell_info["Portée"]),
						"effect": spell_info["Effet"],
						"level_required": int(spell_info["Niveau requis"]),
						"spell_type": spell_info["Type"]
					})
			players.append(player)
			grid[pos.y][pos.x] = player
	
	var enemy_types: Array = ["Gobelin", "Squelette", "Loup"]
	var enemy_positions: Array[Vector2i] = [Vector2i(7, 7), Vector2i(7, 6), Vector2i(6, 7)]
	enemies = []
	
	for i in range(enemy_types.size()):
		var enemy_type = enemy_types[i]
		var pos = enemy_positions[i]
		var enemy_info = null
		for data in enemies_data:
			if data["Type"] == enemy_type and data["Niveau"] == "30":
				enemy_info = data
				break
		if enemy_info:
			var enemy = {
				"name": "%s Lv30" % enemy_type,
				"entity_type": "Enemy",
				"classe": enemy_type,
				"level": 30,
				"max_pv": int(enemy_info["PV"]),
				"current_pv": int(enemy_info["PV"]),
				"force": int(enemy_info["Attaque"]),
				"intelligence": 0,
				"agility": float(enemy_info["Attaque"]) / 2.0,
				"wisdom": 0,
				"defense": int(enemy_info["Défense"]),
				"max_pa": int(enemy_info["PA"]),
				"current_pa": int(enemy_info["PA"]),
				"max_pm": int(enemy_info["PM"]),
				"current_pm": int(enemy_info["PM"]),
				"x": pos.x,
				"y": pos.y
			}
			enemies.append(enemy)
			grid[pos.y][pos.x] = enemy