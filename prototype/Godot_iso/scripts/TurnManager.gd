extends Node
class_name TurnManager
## TurnManager.gd - Gestion des tours ennemis pour Zimut
## Tous les types sont explicites (mode strict GDScript 4.7)

var game_manager: Node


func init(manager: Node) -> void:
	game_manager = manager
	game_manager.turn_changed.connect(_on_turn_changed)


func _on_turn_changed(turn: int) -> void:
	if turn == 1:
		_process_enemy_turn()


# ═══════════════════════════════════════════════════════
#  GESTION DU TOUR DES ENNEMIS
# ═══════════════════════════════════════════════════════

## Traiter le tour de tous les ennemis
func _process_enemy_turn() -> void:
	# Collecter les ennemis vivants
	var alive_enemies: Array[Dictionary] = []
	for e: Dictionary in game_manager.enemies:
		if int(e["current_pv"]) > 0:
			alive_enemies.append(e)

	if alive_enemies.is_empty():
		# Pas d'ennemis vivants → passer directement au tour des joueurs
		game_manager.start_player_turn()
		return

	# Traiter chaque ennemi
	for enemy: Dictionary in alive_enemies:
		if int(enemy["current_pv"]) > 0:
			_process_single_enemy(enemy)

	# Remettre PA/PM ennemis pour le prochain tour
	for enemy: Dictionary in alive_enemies:
		if int(enemy["current_pv"]) > 0:
			enemy["current_pa"] = enemy["max_pa"]
			enemy["current_pm"] = enemy["max_pm"]

	# Retour au tour des joueurs
	game_manager.start_player_turn()


## Traiter le tour d'un ennemi individuel
func _process_single_enemy(enemy: Dictionary) -> void:
	# Trouver le joueur vivant le plus proche
	var closest_player: Dictionary = _find_closest_alive_player(enemy)
	if closest_player.is_empty():
		return

	# Si déjà adjacent, attaquer directement
	var dist_to_player: int = abs(int(enemy["x"]) - int(closest_player["x"])) + abs(int(enemy["y"]) - int(closest_player["y"]))
	if dist_to_player == 1 and int(enemy["current_pa"]) > 0:
		_attack_enemy(enemy, closest_player)
		return

	# Sinon, se déplacer vers le joueur
	if int(enemy["current_pm"]) > 0:
		_move_towards(enemy, closest_player)

	# Après déplacement, vérifier si on peut attaquer
	var new_dist: int = abs(int(enemy["x"]) - int(closest_player["x"])) + abs(int(enemy["y"]) - int(closest_player["y"]))
	if new_dist == 1 and int(enemy["current_pa"]) > 0:
		_attack_enemy(enemy, closest_player)


# ═══════════════════════════════════════════════════════
#  FONCTIONS UTILITAIRES POUR L'IA
# ═══════════════════════════════════════════════════════

## Trouver le joueur vivant le plus proche d'un ennemi
func _find_closest_alive_player(enemy: Dictionary) -> Dictionary:
	var closest_player: Dictionary = {}
	var min_dist: int = 9999
	for player: Dictionary in game_manager.players:
		if int(player["current_pv"]) > 0:
			var d: int = abs(int(enemy["x"]) - int(player["x"])) + abs(int(enemy["y"]) - int(player["y"]))
			if d < min_dist:
				min_dist = d
				closest_player = player
	return closest_player


## Déplacer l'ennemi vers une cible
func _move_towards(enemy: Dictionary, target: Dictionary) -> void:
	var ex: int = int(enemy["x"])
	var ey: int = int(enemy["y"])
	var px: int = int(target["x"])
	var py: int = int(target["y"])
	
	# Déterminer les directions possibles (priorité: se rapprocher)
	var dirs: Array[Vector2i] = []
	if px > ex:   dirs.append(Vector2i(1, 0))
	elif px < ex: dirs.append(Vector2i(-1, 0))
	if py > ey:   dirs.append(Vector2i(0, 1))
	elif py < ey: dirs.append(Vector2i(0, -1))
	
	# Essayer de se déplacer dans une direction valide
	for dir: Vector2i in dirs:
		if int(enemy["current_pm"]) <= 0:
			break
		
		var nx: int = ex + dir.x
		var ny: int = ey + dir.y
		
		# Vérifier que la case est valide et libre
		if nx >= 0 and nx < game_manager.GRID_SIZE and ny >= 0 and ny < game_manager.GRID_SIZE:
			if game_manager.grid[ny][nx] == null:
				# Déplacer l'ennemi
				game_manager.grid[ey][ex] = null
				enemy["x"] = nx
				enemy["y"] = ny
				game_manager.grid[ny][nx] = enemy
				enemy["current_pm"] = int(enemy["current_pm"]) - 1
				game_manager.entity_moved.emit(enemy, Vector2i(ex, ey), Vector2i(nx, ny))
				break


## Attaque d'un ennemi sur une cible
func _attack_enemy(attacker: Dictionary, target: Dictionary) -> void:
	if int(attacker["current_pa"]) <= 0 or int(target["current_pv"]) <= 0:
		return
	
	var raw_dmg: int = int(attacker["force"]) + (randi() % 5 - 2)
	var actual_dmg: int = maxi(1, raw_dmg - int(int(target["defense"]) / 2.0))
	
	target["current_pv"] = int(target["current_pv"]) - actual_dmg
	attacker["current_pa"] = int(attacker["current_pa"]) - 1
	
	game_manager.entity_attacked.emit(attacker, target, actual_dmg)
	game_manager.message_requested.emit("%s attaque %s : %d dégâts !" % [attacker["name"], target["name"], actual_dmg])
	
	if int(target["current_pv"]) <= 0:
		game_manager.remove_entity_from_grid(target)
