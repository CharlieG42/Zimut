extends Node
class_name TurnManager
## TurnManager.gd - Gestion des tours (joueurs/ennemis)

var game_manager


func init(manager):
	game_manager = manager
	game_manager.turn_changed.connect(_on_turn_changed)


func _on_turn_changed(turn: int):
	"""Called when the turn changes (0 = players, 1 = enemies)"""
	if turn == 0:
		# Players' turn - handled by GameManager
		pass
	else:
		# Enemies' turn - start enemy AI
		_process_enemy_turn()


func _process_enemy_turn():
	"""Process enemy turn: move and attack"""
	if game_manager.enemies.size() == 0:
		# No enemies left, players win
		game_manager.game_over = true
		game_manager.victory = true
		game_manager.game_ended.emit(true)
		game_manager.message_requested.emit("Tous les ennemis sont vaincus ! VICTOIRE !")
		return
	
	# Find first alive enemy
	var first_enemy = null
	for enemy in game_manager.enemies:
		if enemy["current_pv"] > 0:
			first_enemy = enemy
			break
	
	if first_enemy == null:
		# All enemies are dead
		game_manager.current_turn = 0
		game_manager.turn_count += 1
		game_manager.turn_changed.emit(game_manager.current_turn)
		game_manager.current_player_index = 0
		if game_manager.players.size() > 0:
			for p in game_manager.players:
				p["is_active"] = false
			game_manager.players[0]["is_active"] = true
			game_manager.selected_entity = game_manager.players[0]
			game_manager.entity_selected.emit(game_manager.players[0])
		game_manager.player_changed.emit(game_manager.current_player_index)
		game_manager.message_requested.emit("Tour des joueurs")
		game_manager.check_game_over()
		return
	
	# Enemy AI: Find closest player and attack
	var closest_player = null
	var min_distance = 999
	for player in game_manager.players:
		if player["current_pv"] > 0:
			var dx = abs(int(first_enemy["x"]) - int(player["x"]))
			var dy = abs(int(first_enemy["y"]) - int(player["y"]))
			var distance = dx + dy
			if distance < min_distance:
				min_distance = distance
				closest_player = player
	
	if closest_player:
		# Move towards player if not adjacent
		if min_distance > 1 and first_enemy["current_pm"] > 0:
			var ex = int(first_enemy["x"])
			var ey = int(first_enemy["y"])
			var px = int(closest_player["x"])
			var py = int(closest_player["y"])
			
			# Find adjacent cell towards player
			var directions = []
			if px > ex: directions.append(Vector2i(1, 0))
			elif px < ex: directions.append(Vector2i(-1, 0))
			if py > ey: directions.append(Vector2i(0, 1))
			elif py < ey: directions.append(Vector2i(0, -1))
			
			# Try to move in one of the directions
			for dir in directions:
				var new_x = ex + dir.x
				var new_y = ey + dir.y
				if new_x >= 0 and new_x < game_manager.GRID_SIZE and new_y >= 0 and new_y < game_manager.GRID_SIZE:
					if game_manager.grid[new_y][new_x] == null:
						game_manager.grid[ey][ex] = null
						first_enemy["x"] = new_x
						first_enemy["y"] = new_y
						game_manager.grid[new_y][new_x] = first_enemy
						first_enemy["current_pm"] -= 1
						game_manager.entity_moved.emit(first_enemy, Vector2i(ex, ey), Vector2i(new_x, new_y))
						game_manager.message_requested.emit("%s se déplace vers (%d,%d)" % [first_enemy["name"], new_x, new_y])
						break
			
			# Update distance after potential move
			var new_dx = abs(int(first_enemy["x"]) - int(closest_player["x"]))
			var new_dy = abs(int(first_enemy["y"]) - int(closest_player["y"]))
			min_distance = new_dx + new_dy
		
		# Attack if adjacent
		if min_distance == 1 and first_enemy["current_pa"] > 0:
			var damage = first_enemy["force"] + ((randi() % 5) - 2)
			var actual_damage = max(1, damage - closest_player["defense"] / 2.0)
			closest_player["current_pv"] -= actual_damage
			game_manager.entity_attacked.emit(first_enemy, closest_player, actual_damage)
			first_enemy["current_pa"] -= 1
			game_manager.message_requested.emit("%s attaque %s : %d dégâts !" % [first_enemy["name"], closest_player["name"], actual_damage])
			if closest_player["current_pv"] <= 0:
				game_manager.remove_entity_from_grid(closest_player)
	
	# Move to next enemy or end enemy turn
	var all_enemies_done = true
	for enemy in game_manager.enemies:
		if enemy["current_pv"] > 0 and (enemy["current_pa"] > 0 or enemy["current_pm"] > 0):
			all_enemies_done = false
			break
	
	if all_enemies_done:
		# Reset PA/PM for all enemies
		for enemy in game_manager.enemies:
			if enemy["current_pv"] > 0:
				enemy["current_pa"] = enemy["max_pa"]
				enemy["current_pm"] = enemy["max_pm"]
		# End enemy turn, go back to player turn
		game_manager.current_turn = 0
		game_manager.turn_count += 1
		game_manager.turn_changed.emit(game_manager.current_turn)
		game_manager.current_player_index = 0
		if game_manager.players.size() > 0:
			for p in game_manager.players:
				p["is_active"] = false
			game_manager.players[0]["is_active"] = true
			game_manager.selected_entity = game_manager.players[0]
			game_manager.entity_selected.emit(game_manager.players[0])
		game_manager.player_changed.emit(game_manager.current_player_index)
		game_manager.message_requested.emit("Tour des joueurs")
		game_manager.check_game_over()
	else:
		# Continue enemy turn (simplified: just process all enemies in sequence)
		for enemy in game_manager.enemies:
			if enemy["current_pv"] > 0:
				enemy["current_pa"] = enemy["max_pa"]
				enemy["current_pm"] = enemy["max_pm"]
		game_manager.current_turn = 0
		game_manager.turn_count += 1
		game_manager.turn_changed.emit(game_manager.current_turn)
		game_manager.current_player_index = 0
		if game_manager.players.size() > 0:
			for p in game_manager.players:
				p["is_active"] = false
			game_manager.players[0]["is_active"] = true
			game_manager.selected_entity = game_manager.players[0]
			game_manager.entity_selected.emit(game_manager.players[0])
		game_manager.player_changed.emit(game_manager.current_player_index)
		game_manager.message_requested.emit("Tour des joueurs")
		game_manager.check_game_over()
