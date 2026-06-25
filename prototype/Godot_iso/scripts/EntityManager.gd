extends Node
## EntityManager.gd - Gestion des entités (joueurs/ennemis)

var game_manager


func init(manager):
	game_manager = manager
	game_manager.entity_moved.connect(_on_entity_moved)
	game_manager.entity_attacked.connect(_on_entity_attacked)
	game_manager.spell_casted.connect(_on_spell_casted)


func _on_entity_moved(_entity, _from_pos: Vector2i, _to_pos: Vector2i):
	"""Update display when an entity moves"""
	if has_node("/root/Main/GridManager"):
		get_node("/root/Main/GridManager").update_entity_display()


func _on_entity_attacked(_attacker, _target, _damage: int):
	"""Update display when an entity is attacked"""
	_on_entity_moved(null, Vector2i(0, 0), Vector2i(0, 0))


func _on_spell_casted(_caster, _spell, _target, _result: String):
	"""Update display when a spell is cast"""
	_on_entity_moved(null, Vector2i(0, 0), Vector2i(0, 0))


# ==================== Utility functions ====================

func get_entity_at_position(pos: Vector2i):
	"""Return the entity at the given grid position"""
	if pos.y >= 0 and pos.y < game_manager.GRID_SIZE and pos.x >= 0 and pos.x < game_manager.GRID_SIZE:
		return game_manager.grid[pos.y][pos.x]
	return null


func is_position_valid(pos: Vector2i) -> bool:
	"""Check if a position is within the grid bounds"""
	return pos.x >= 0 and pos.x < game_manager.GRID_SIZE and pos.y >= 0 and pos.y < game_manager.GRID_SIZE


func get_distance(pos1: Vector2i, pos2: Vector2i) -> int:
	"""Calculate Manhattan distance between two positions"""
	return abs(pos1.x - pos2.x) + abs(pos1.y - pos2.y)


func can_move_to(entity: Dictionary, target_pos: Vector2i) -> bool:
	"""Check if an entity can move to the target position"""
	if not is_position_valid(target_pos):
		return false
	var distance = get_distance(
		Vector2i(int(entity["x"]), int(entity["y"])),
		target_pos
	)
	return distance == 1 and game_manager.grid[target_pos.y][target_pos.x] == null and entity["current_pm"] > 0


func can_attack(entity: Dictionary, target_pos: Vector2i) -> bool:
	"""Check if an entity can attack the target position"""
	if not is_position_valid(target_pos):
		return false
	var target = game_manager.grid[target_pos.y][target_pos.x]
	if target == null:
		return false
	var distance = get_distance(
		Vector2i(int(entity["x"]), int(entity["y"])),
		target_pos
	)
	return distance == 1 and target["current_pv"] > 0 and entity["current_pa"] > 0
