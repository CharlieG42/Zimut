extends Node
## GameManager - Gère la logique globale du jeu WildZimut (version isométrique)
## Ce script est un autoload (configuré dans project.godot)

const GRID_SIZE := 10
const CELL_SIZE := Vector2i(64, 32)
const CELL_HALF_OFFSET := Vector2i(32, 16)

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
	if players.size() > 0:
		for p in players:
			if p["current_pv"] > 0:
				selected_entity = p
				p["is_active"] = true
				entity_selected.emit(p)
				break
	current_player_index = 0
	player_changed.emit(current_player_index)


func load_data():
	"""Load game data: classes, spells, enemies"""
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
	"""Initialize the grid"""
	grid = []
	for y in range(GRID_SIZE):
		var row: Array = []
		for x in range(GRID_SIZE):
			row.append(null)
		grid.append(row)


func init_entities():
	"""Initialize players and enemies on the grid"""
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


func handle_cell_selected(cell_pos: Vector2i):
	"""Handle cell selection based on current game state"""
	var x = cell_pos.x
	var y = cell_pos.y
	if not (x >= 0 and x < GRID_SIZE and y >= 0 and y < GRID_SIZE):
		return
	selected_cell = cell_pos
	var entity = grid[y][x]
	cleanup_dead_entities()
	var current_player = null
	if current_turn == 0:
		current_player = players[current_player_index]
		if selected_spell != null:
			if entity and entity["current_pv"] > 0:
				var dx: int = abs(x - int(current_player["x"]))
				var dy: int = abs(y - int(current_player["y"]))
				var distance = dx + dy
				if distance <= selected_spell["range"]:
					var spell_result = cast_spell(current_player, selected_spell, entity)
					if spell_result:
						spell_casted.emit(current_player, selected_spell, entity, spell_result)
						message_requested.emit(spell_result)
						if entity["current_pv"] <= 0:
							remove_entity_from_grid(entity)
						selected_spell = null
						entity_selected.emit(null)
						player_changed.emit(current_player_index)
						cleanup_dead_entities()
				else:
					message_requested.emit("Cible hors de portée ! (Portée: %d)" % selected_spell["range"])
			else:
				message_requested.emit("Pas de cible valide à cette position")
			return
		if entity and entity["entity_type"] == "Player" and entity == current_player and entity["current_pv"] > 0:
			selected_entity = current_player
			show_spells = true
			for p in players:
				p["is_active"] = false
			current_player["is_active"] = true
			entity_selected.emit(current_player)
			player_changed.emit(current_player_index)
			return
		if entity == null and current_player["current_pv"] > 0 and current_player["current_pm"] > 0:
			var dx: int = x - int(current_player["x"])
			var dy: int = y - int(current_player["y"])
			if abs(dx) + abs(dy) == 1:
				if grid[y][x] == null:
					grid[current_player["y"]][current_player["x"]] = null
					current_player["x"] = x
					current_player["y"] = y
					grid[y][x] = current_player
					current_player["current_pm"] -= 1
					entity_moved.emit(current_player, Vector2i(current_player["x"] - dx, current_player["y"] - dy), cell_pos)
					selected_entity = current_player
					show_spells = false
					player_changed.emit(current_player_index)
					message_requested.emit("%s se déplace vers (%d,%d)" % [current_player["name"], x, y])
			return
		if entity and entity["current_pv"] > 0 and entity["entity_type"] == "Enemy" and current_player["current_pv"] > 0:
			var dx: int = abs(x - int(current_player["x"]))
			var dy: int = abs(y - int(current_player["y"]))
			var distance = dx + dy
			if distance == 1:
				var damage = current_player["force"] + ((randi() % 5) - 2)
				var actual_damage = max(1, damage - entity["defense"] / 2.0)
				entity["current_pv"] -= actual_damage
				entity_attacked.emit(current_player, entity, actual_damage)
				current_player["current_pa"] -= 1
				message_requested.emit("%s attaque %s : %d dégâts !" % [current_player["name"], entity["name"], actual_damage])
				if entity["current_pv"] <= 0:
					remove_entity_from_grid(entity)
				selected_entity = current_player
				show_spells = false
				player_changed.emit(current_player_index)
				cleanup_dead_entities()
			return
	selected_entity = null
	show_spells = false


func remove_entity_from_grid(entity: Dictionary):
	"""Remove a dead entity from grid and arrays"""
	if entity["entity_type"] == "Player":
		for i in range(players.size()):
			if players[i] == entity:
				players.remove_at(i)
				if i <= current_player_index:
					current_player_index = max(0, current_player_index - 1)
				break
		if current_player_index >= players.size():
			current_player_index = max(0, players.size() - 1)
	elif entity["entity_type"] == "Enemy":
		for i in range(enemies.size()):
			if enemies[i] == entity:
				enemies.remove_at(i)
				break
	var ex = int(entity["x"])
	var ey = int(entity["y"])
	if ex >= 0 and ex < GRID_SIZE and ey >= 0 and ey < GRID_SIZE:
		grid[ey][ex] = null
	entity_selected.emit(null)
	player_changed.emit(current_player_index)
	check_game_over()


func cleanup_dead_entities():
	"""Remove all dead entities from grid and arrays"""
	for i in range(players.size() - 1, -1, -1):
		if players[i]["current_pv"] <= 0:
			var pos = Vector2i(int(players[i]["x"]), int(players[i]["y"]))
			if pos.x >= 0 and pos.x < GRID_SIZE and pos.y >= 0 and pos.y < GRID_SIZE:
				grid[pos.y][pos.x] = null
			players.remove_at(i)
			if current_player_index >= i:
				current_player_index = max(0, current_player_index - 1)
	for i in range(enemies.size() - 1, -1, -1):
		if enemies[i]["current_pv"] <= 0:
			var pos = Vector2i(int(enemies[i]["x"]), int(enemies[i]["y"]))
			if pos.x >= 0 and pos.x < GRID_SIZE and pos.y >= 0 and pos.y < GRID_SIZE:
				grid[pos.y][pos.x] = null
			enemies.remove_at(i)
	if current_player_index >= players.size():
		current_player_index = max(0, players.size() - 1)


func handle_spell_selected(spell: Dictionary):
	"""Handle spell selection from UI"""
	var current_player = players[current_player_index]
	if can_cast_spell(current_player, spell):
		selected_spell = spell
		spell_selected.emit(spell)
		message_requested.emit("Sort sélectionné: %s (Portée: %d)" % [spell["name"], spell["range"]])
		player_changed.emit(current_player_index)
	else:
		message_requested.emit("Pas assez de PA/PM pour ce sort !")
		selected_spell = null


func can_cast_spell(entity: Dictionary, spell: Dictionary) -> bool:
	"""Check if an entity can cast a spell"""
	return entity["current_pa"] >= spell["cost_pa"] and entity["current_pm"] >= spell["cost_pm"]


func cast_spell(caster: Dictionary, spell: Dictionary, target: Dictionary) -> String:
	"""Cast a spell and return the result message"""
	var result: String = ""
	caster["current_pa"] -= spell["cost_pa"]
	caster["current_pm"] -= spell["cost_pm"]
	match spell["spell_type"]:
		"CAC":
			var damage = caster["force"] + ((randi() % 5) - 2)
			var actual_damage = max(1, damage - target["defense"] / 2.0)
			target["current_pv"] -= actual_damage
			result = "%s utilise %s sur %s : %d dégâts !" % [caster["name"], spell["name"], target["name"], actual_damage]
			entity_attacked.emit(caster, target, actual_damage)
		"Magie":
			if "Poison" in spell["effect"]:
				var damage = int(spell["effect"].split(" ")[0])
				target["current_pv"] -= damage
				result = "%s utilise %s sur %s : %d dégâts + poison !" % [caster["name"], spell["name"], target["name"], damage]
				entity_attacked.emit(caster, target, damage)
			else:
				var damage = caster["intelligence"] + ((randi() % 5) - 2)
				var actual_damage = max(1, damage)
				target["current_pv"] -= actual_damage
				result = "%s utilise %s sur %s : %d dégâts !" % [caster["name"], spell["name"], target["name"], actual_damage]
				entity_attacked.emit(caster, target, actual_damage)
		"Défense":
			caster["defense"] = int(caster["defense"] * 1.5)
			result = "%s utilise %s : défense augmentée !" % [caster["name"], spell["name"]]
		"Soin":
			var heal_amount = caster["intelligence"] + ((randi() % 5) - 2)
			target["current_pv"] = min(target["max_pv"], target["current_pv"] + heal_amount)
			result = "%s utilise %s sur %s : +%d PV !" % [caster["name"], spell["name"], target["name"], heal_amount]
	return result


func next_player():
	"""Move to the next player's turn"""
	selected_spell = null
	show_spells = false
	selected_cell = Vector2i(0, 0)
	var start_index = current_player_index
	var found_alive = false
	var current_player = null
	for i in range(players.size()):
		current_player_index = (start_index + 1 + i) % players.size()
		current_player = players[current_player_index]
		if current_player["current_pv"] > 0:
			found_alive = true
			break
	if not found_alive:
		current_turn = 1
		turn_changed.emit(current_turn)
		turn_count += 1
		message_requested.emit("Tour des ennemis")
		_process_enemy_turn()
		return
	current_player = players[current_player_index]
	selected_entity = current_player
	for p in players:
		p["is_active"] = false
	current_player["is_active"] = true
	player_changed.emit(current_player_index)
	entity_selected.emit(current_player)
	message_requested.emit("Tour de %s" % current_player.get("name", "?"))
	cleanup_dead_entities()


func _process_enemy_turn():
	"""Process all enemies' turns"""
	if enemies.size() == 0:
		game_over = true
		victory = true
		game_ended.emit(true)
		message_requested.emit("Tous les ennemis sont vaincus ! VICTOIRE !")
		return
	var first_enemy = null
	for enemy in enemies:
		if enemy["current_pv"] > 0:
			first_enemy = enemy
			break
	if first_enemy == null:
		current_turn = 0
		turn_count += 1
		turn_changed.emit(current_turn)
		current_player_index = 0
		if players.size() > 0:
			for p in players:
				p["is_active"] = false
			players[0]["is_active"] = true
			selected_entity = players[0]
			entity_selected.emit(players[0])
		player_changed.emit(current_player_index)
		message_requested.emit("Tour des joueurs")
		return
	var closest_player = null
	var min_distance = 999
	for player in players:
		if player["current_pv"] > 0:
			var dx = abs(int(first_enemy["x"]) - int(player["x"]))
			var dy = abs(int(first_enemy["y"]) - int(player["y"]))
			var distance = dx + dy
			if distance < min_distance:
				min_distance = distance
				closest_player = player
	if closest_player:
		if min_distance > 1 and first_enemy["current_pm"] > 0:
			var ex = int(first_enemy["x"])
			var ey = int(first_enemy["y"])
			var px = int(closest_player["x"])
			var py = int(closest_player["y"])
			var directions = []
			if px > ex: directions.append(Vector2i(1, 0))
			elif px < ex: directions.append(Vector2i(-1, 0))
			if py > ey: directions.append(Vector2i(0, 1))
			elif py < ey: directions.append(Vector2i(0, -1))
			for dir in directions:
				var new_x = ex + dir.x
				var new_y = ey + dir.y
				if new_x >= 0 and new_x < GRID_SIZE and new_y >= 0 and new_y < GRID_SIZE:
					if grid[new_y][new_x] == null:
						grid[ey][ex] = null
						first_enemy["x"] = new_x
						first_enemy["y"] = new_y
						grid[new_y][new_x] = first_enemy
						first_enemy["current_pm"] -= 1
						entity_moved.emit(first_enemy, Vector2i(ex, ey), Vector2i(new_x, new_y))
						message_requested.emit("%s se déplace vers (%d,%d)" % [first_enemy["name"], new_x, new_y])
						break
			var new_dx = abs(int(first_enemy["x"]) - int(closest_player["x"]))
			var new_dy = abs(int(first_enemy["y"]) - int(closest_player["y"]))
			min_distance = new_dx + new_dy
		if min_distance == 1 and first_enemy["current_pa"] > 0:
			var damage = first_enemy["force"] + ((randi() % 5) - 2)
			var actual_damage = max(1, damage - closest_player["defense"] / 2.0)
			closest_player["current_pv"] -= actual_damage
			entity_attacked.emit(first_enemy, closest_player, actual_damage)
			first_enemy["current_pa"] -= 1
			message_requested.emit("%s attaque %s : %d dégâts !" % [first_enemy["name"], closest_player["name"], actual_damage])
			if closest_player["current_pv"] <= 0:
				remove_entity_from_grid(closest_player)
	var all_enemies_done = true
	for enemy in enemies:
		if enemy["current_pv"] > 0 and (enemy["current_pa"] > 0 or enemy["current_pm"] > 0):
			all_enemies_done = false
			break
	if all_enemies_done:
		for enemy in enemies:
			if enemy["current_pv"] > 0:
				enemy["current_pa"] = enemy["max_pa"]
				enemy["current_pm"] = enemy["max_pm"]
		current_turn = 0
		turn_count += 1
		turn_changed.emit(current_turn)
		current_player_index = 0
		if players.size() > 0:
			for p in players:
				p["is_active"] = false
			players[0]["is_active"] = true
			selected_entity = players[0]
			entity_selected.emit(players[0])
		player_changed.emit(current_player_index)
		message_requested.emit("Tour des joueurs")
		check_game_over()
	else:
		for enemy in enemies:
			if enemy["current_pv"] > 0:
				enemy["current_pa"] = enemy["max_pa"]
				enemy["current_pm"] = enemy["max_pm"]
		current_turn = 0
		turn_count += 1
		turn_changed.emit(current_turn)
		current_player_index = 0
		if players.size() > 0:
			for p in players:
				p["is_active"] = false
			players[0]["is_active"] = true
			selected_entity = players[0]
			entity_selected.emit(players[0])
		player_changed.emit(current_player_index)
		message_requested.emit("Tour des joueurs")
		check_game_over()


func check_game_over():
	"""Check if the game is over (all players or all enemies dead)"""
	var alive_players = 0
	for player in players:
		if player["current_pv"] > 0:
			alive_players += 1
	var alive_enemies = 0
	for enemy in enemies:
		if enemy["current_pv"] > 0:
			alive_enemies += 1
	if alive_players == 0:
		game_over = true
		victory = false
		game_ended.emit(false)
		message_requested.emit("Tous les joueurs sont vaincus ! DEFAITE...")
	elif alive_enemies == 0:
		game_over = true
		victory = true
		game_ended.emit(true)
		message_requested.emit("Tous les ennemis sont vaincus ! VICTOIRE !")


func reset_game():
	"""Reset the game to initial state"""
	init_grid()
	init_entities()
	current_turn = 0
	turn_count = 1
	current_player_index = 0
	selected_entity = null
	selected_spell = null
	selected_cell = Vector2i(0, 0)
	show_spells = false
	game_over = false
	victory = false
	var current_player = null
	if players.size() > 0:
		for p in players:
			p["is_active"] = false
		players[0]["is_active"] = true
		current_player = players[0]
		selected_entity = current_player
	turn_changed.emit(current_turn)
	player_changed.emit(current_player_index)
	entity_selected.emit(selected_entity)
