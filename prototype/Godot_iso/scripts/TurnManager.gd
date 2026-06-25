extends Node
class_name TurnManager
## TurnManager.gd - Gestion des tours ennemis
## Tous les types sont explicites (mode strict GDScript 4.7)

var game_manager: Node


func init(manager: Node) -> void:
	game_manager = manager
	game_manager.turn_changed.connect(_on_turn_changed)


func _on_turn_changed(turn: int) -> void:
	if turn == 1:
		_process_enemy_turn()


func _process_enemy_turn() -> void:
	# Collecter les ennemis vivants
	var alive_enemies: Array = []
	for e: Dictionary in game_manager.enemies:
		if int(e["current_pv"]) > 0:
			alive_enemies.append(e)

	if alive_enemies.is_empty():
		game_manager.start_player_turn()
		return

	for enemy: Dictionary in alive_enemies:
		if int(enemy["current_pv"]) > 0:
			_process_single_enemy(enemy)

	# Remettre PA/PM ennemis
	for enemy: Dictionary in alive_enemies:
		if int(enemy["current_pv"]) > 0:
			enemy["current_pa"] = enemy["max_pa"]
			enemy["current_pm"] = enemy["max_pm"]

	game_manager.start_player_turn()


func _process_single_enemy(enemy: Dictionary) -> void:
	# Trouver le joueur vivant le plus proche
	var closest_player: Dictionary = {}
	var min_dist: int = 9999
	for player: Dictionary in game_manager.players:
		if int(player["current_pv"]) > 0:
			var d: int = abs(int(enemy["x"]) - int(player["x"])) + abs(int(enemy["y"]) - int(player["y"]))
			if d < min_dist:
				min_dist        = d
				closest_player  = player

	if closest_player.is_empty():
		return

	# Déplacement pas à pas selon PM disponibles
	var steps: int = int(enemy["current_pm"])
	for _i: int in range(steps):
		var ex: int = int(enemy["x"])
		var ey: int = int(enemy["y"])
		var px: int = int(closest_player["x"])
		var py: int = int(closest_player["y"])
		var dist: int = abs(ex - px) + abs(ey - py)
		if dist <= 1:
			break

		var dirs: Array[Vector2i] = []
		if px > ex:   dirs.append(Vector2i(1, 0))
		elif px < ex: dirs.append(Vector2i(-1, 0))
		if py > ey:   dirs.append(Vector2i(0, 1))
		elif py < ey: dirs.append(Vector2i(0, -1))

		var moved: bool = false
		for dir: Vector2i in dirs:
			var nx: int = ex + dir.x
			var ny: int = ey + dir.y
			if nx >= 0 and nx < game_manager.GRID_SIZE and ny >= 0 and ny < game_manager.GRID_SIZE:
				if game_manager.grid[ny][nx] == null:
					game_manager.grid[ey][ex] = null
					enemy["x"] = nx
					enemy["y"] = ny
					game_manager.grid[ny][nx] = enemy
					enemy["current_pm"] = int(enemy["current_pm"]) - 1
					game_manager.entity_moved.emit(enemy, Vector2i(ex, ey), Vector2i(nx, ny))
					moved = true
					break
		if not moved:
			break

	# Attaque si adjacent
	var final_dist: int = abs(int(enemy["x"]) - int(closest_player["x"])) + abs(int(enemy["y"]) - int(closest_player["y"]))
	if final_dist == 1 and int(enemy["current_pa"]) > 0 and int(closest_player["current_pv"]) > 0:
		var raw_dmg: int    = int(enemy["force"]) + (randi() % 5 - 2)
		var actual_dmg: int = maxi(1, raw_dmg - int(int(closest_player["defense"]) / 2.0))
		closest_player["current_pv"] = int(closest_player["current_pv"]) - actual_dmg
		enemy["current_pa"] = int(enemy["current_pa"]) - 1
		game_manager.entity_attacked.emit(enemy, closest_player, actual_dmg)
		game_manager.message_requested.emit("%s attaque %s : %d dégâts !" % [enemy["name"], closest_player["name"], actual_dmg])
		if int(closest_player["current_pv"]) <= 0:
			game_manager.remove_entity_from_grid(closest_player)
