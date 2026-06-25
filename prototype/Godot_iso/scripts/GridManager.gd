extends Node2D
## GridManager.gd - Gestion de la grille isométrique
## Ajouts : highlight_spell_range, highlight_move_range, clear_all_highlights

const CELL_SIZE = Vector2i(100, 100)
const HALF_CELL = Vector2(50, 50)

var game_manager
var cell_nodes = []
var decoration_nodes = []

var tree_texture = null
var rock_texture = null
var bush_texture = null

signal cell_clicked(x, y)


func init(manager):
	game_manager = manager
	_load_decoration_textures()
	_create_grid()
	_add_random_decorations()


func _load_decoration_textures():
	var tree_res = load("res://assets/tree.svg")
	if tree_res is Texture2D:
		tree_texture = tree_res
	var rock_res = load("res://assets/rock.svg")
	if rock_res is Texture2D:
		rock_texture = rock_res
	var bush_res = load("res://assets/bush.svg")
	if bush_res is Texture2D:
		bush_texture = bush_res


func _create_grid():
	cell_nodes = []
	decoration_nodes = []

	for y in range(game_manager.GRID_SIZE):
		var row = []
		for x in range(game_manager.GRID_SIZE):
			var cell = preload("res://scripts/Cell.gd").new()
			cell.position = grid_to_screen(Vector2i(x, y))
			cell.grid_position = Vector2i(x, y)
			cell.connect("cell_clicked", Callable(self, "_on_cell_clicked"))
			add_child(cell)
			row.append(cell)
		cell_nodes.append(row)

	update_entity_display()


func _add_random_decorations():
	var decoration_positions = [
		Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0),
		Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1),
		Vector2i(8, 8), Vector2i(9, 8), Vector2i(8, 9),
		Vector2i(6, 6), Vector2i(7, 6), Vector2i(6, 7),
		Vector2i(1, 8), Vector2i(2, 8), Vector2i(8, 1),
		Vector2i(3, 7), Vector2i(7, 3), Vector2i(4, 8),
	]
	for pos in decoration_positions:
		if pos.x < 0 or pos.x >= game_manager.GRID_SIZE:
			continue
		if pos.y < 0 or pos.y >= game_manager.GRID_SIZE:
			continue
		if game_manager.grid[pos.y][pos.x] != null:
			continue
		var deco = Sprite2D.new()
		deco.name = "Deco_%d_%d" % [pos.x, pos.y]
		deco.centered = true
		deco.z_index = 5
		var rand_val = randi() % 3
		if rand_val == 0 and tree_texture:
			deco.texture = tree_texture
			deco.scale = Vector2(0.6, 0.6)
			deco.z_index = 6
		elif rand_val == 1 and rock_texture:
			deco.texture = rock_texture
			deco.scale = Vector2(0.45, 0.45)
		elif bush_texture:
			deco.texture = bush_texture
			deco.scale = Vector2(0.4, 0.4)
		deco.global_position = grid_to_screen(pos) + HALF_CELL
		add_child(deco)
		decoration_nodes.append(deco)


# Coordonnées

func grid_to_screen(grid_pos):
	var x = float(grid_pos.x - grid_pos.y) * float(CELL_SIZE.x) / 2.0
	var y = float(grid_pos.x + grid_pos.y) * float(CELL_SIZE.y) / 2.0
	x += 960.0
	y += 90.0
	return Vector2(x, y)


func screen_to_grid(screen_pos):
	var x_s = screen_pos.x - 960.0
	var y_s = screen_pos.y - 90.0
	var gx = (x_s / (float(CELL_SIZE.x) / 2.0) + y_s / (float(CELL_SIZE.y) / 2.0)) / 2.0
	var gy = (y_s / (float(CELL_SIZE.y) / 2.0) - x_s / (float(CELL_SIZE.x) / 2.0)) / 2.0
	return Vector2i(roundi(gx), roundi(gy))


# Highlights

func highlight_spell_range(positions):
	for row in cell_nodes:
		for cell in row:
			cell.set_in_spell_range(false)
	for pos in positions:
		var cell = get_cell_node_at(pos)
		if cell:
			cell.set_in_spell_range(true)


func highlight_move_range(positions):
	for row in cell_nodes:
		for cell in row:
			cell.set_in_move_range(false)
	for pos in positions:
		var cell = get_cell_node_at(pos)
		if cell:
			cell.set_in_move_range(true)


func clear_move_range_only():
	for row in cell_nodes:
		for cell in row:
			cell.set_in_move_range(false)


func clear_all_highlights():
	_clear_all_range_flags()


func _clear_all_range_flags():
	for row in cell_nodes:
		for cell in row:
			cell.set_in_move_range(false)
			cell.set_in_spell_range(false)


# Mise à jour affichage

func update_entity_display():
	var current_player = {}
	if game_manager.current_turn == 0 and game_manager.players.size() > game_manager.current_player_index:
		current_player = game_manager.players[game_manager.current_player_index]

	for y in range(game_manager.GRID_SIZE):
		for x in range(game_manager.GRID_SIZE):
			if y >= cell_nodes.size() or x >= cell_nodes[y].size():
				continue
			var cell = cell_nodes[y][x]
			var entity = game_manager.grid[y][x]
			cell.entity = entity
			cell.selected = (game_manager.selected_cell == Vector2i(x, y))
			cell.highlighted = (not current_player.is_empty() and
				int(current_player.get("x", -1)) == x and
				int(current_player.get("y", -1)) == y)
			cell.update_appearance()


func get_cell_node_at(grid_pos):
	if grid_pos.y < cell_nodes.size() and grid_pos.x < cell_nodes[grid_pos.y].size():
		return cell_nodes[grid_pos.y][grid_pos.x]
	return null


func _on_cell_clicked(x, y):
	emit_signal("cell_clicked", x, y)
