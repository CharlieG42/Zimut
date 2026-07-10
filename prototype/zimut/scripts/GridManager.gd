extends Node2D
## GridManager.gd - Gestion de la grille isométrique
## Correction: rotation des cellules de -45° pour perspective isométrique
## grid_to_screen adaptée pour cellules rotées

const CELL_SIZE   := Vector2i(140, 140)
const HALF_CELL   := Vector2(70, 70)

var game_manager
var cell_nodes: Array        = []
var decoration_nodes: Array  = []

var tree_texture: ImageTexture
var rock_texture: ImageTexture
var bush_texture: ImageTexture

signal cell_clicked(x: int, y: int)


func init(manager) -> void:
	game_manager = manager
	_load_decoration_textures()
	_create_grid()
	_add_random_decorations()


func _load_decoration_textures() -> void:
	var tree_res: Resource = load("res://assets/tree.svg")
	if tree_res is Texture2D:
		tree_texture = tree_res as ImageTexture
	var rock_res: Resource = load("res://assets/rock.svg")
	if rock_res is Texture2D:
		rock_texture = rock_res as ImageTexture
	var bush_res: Resource = load("res://assets/bush.svg")
	if bush_res is Texture2D:
		bush_texture = bush_res as ImageTexture


func _create_grid() -> void:
	cell_nodes      = []
	decoration_nodes = []

	for y: int in range(game_manager.GRID_SIZE):
		var row: Array = []
		for x: int in range(game_manager.GRID_SIZE):
			var cell: Cell = preload("res://scripts/Cell.gd").new()
			cell.position      = grid_to_screen(Vector2i(x, y))
			cell.grid_position = Vector2i(x, y)
			# APPLIQUER ROTATION -45° POUR PERSPECTIVE ISOMÉTRIQUE
			cell.rotation_degrees = -45.0
			cell.connect("cell_clicked", Callable(self, "_on_cell_clicked"))
			add_child(cell)
			row.append(cell)
		cell_nodes.append(row)

	update_entity_display()


func _add_random_decorations() -> void:
	var decoration_positions: Array[Vector2i] = [
		Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0),
		Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1),
		Vector2i(6, 6), Vector2i(7, 6), Vector2i(6, 7),
		Vector2i(5, 5), Vector2i(7, 7), Vector2i(5, 7),
		Vector2i(1, 6), Vector2i(2, 6), Vector2i(6, 1),
		Vector2i(3, 5), Vector2i(5, 3), Vector2i(4, 6),
	]
	for pos: Vector2i in decoration_positions:
		if pos.x < 0 or pos.x >= game_manager.GRID_SIZE:
			continue
		if pos.y < 0 or pos.y >= game_manager.GRID_SIZE:
			continue
		if game_manager.grid[pos.y][pos.x] != null:
			continue
		var deco := Sprite2D.new()
		deco.name    = "Deco_%d_%d" % [pos.x, pos.y]
		deco.centered = true
		deco.z_index  = 5
		# APPLIQUER LA MÊME ROTATION QUE LES CELLULES
		deco.rotation_degrees = -45.0
		var rand_val: int = randi() % 3
		if rand_val == 0 and tree_texture:
			deco.texture = tree_texture
			deco.scale   = Vector2(0.6, 0.6)
			deco.z_index = 6
		elif rand_val == 1 and rock_texture:
			deco.texture = rock_texture
			deco.scale   = Vector2(0.45, 0.45)
		elif bush_texture:
			deco.texture = bush_texture
			deco.scale   = Vector2(0.4, 0.4)
		deco.global_position = grid_to_screen(pos) + HALF_CELL
		add_child(deco)
		decoration_nodes.append(deco)


# ─── Coordonnées ───────────────────────────────────────────────────────────

func grid_to_screen(grid_pos: Vector2i) -> Vector2:
	# Formule adaptée pour cellules rotées de -45°
	# Position isométrique standard: x = (x - y) * half_width, y = (x + y) * half_height
	var x: float = float(grid_pos.x + grid_pos.y) * float(CELL_SIZE.x) / 2.0
	var y: float = float(grid_pos.y - grid_pos.x) * float(CELL_SIZE.y) / 2.0
	# Centrer la grille 8x8 (560x560) sur l'écran (960, 540)
	x += 960.0 - (CELL_SIZE.x * 4.0)  # Ajustement pour centrer
	y += 540.0
	return Vector2(x, y)


func screen_to_grid(screen_pos: Vector2) -> Vector2i:
	# Inverse de la formule grid_to_screen pour cellules rotées
	var x_s: float = screen_pos.x - (960.0 - (CELL_SIZE.x * 4.0))
	var y_s: float = screen_pos.y - 540.0
	# Résoudre: x_screen = (gx + gy) * 70, y_screen = (gy - gx) * 70
	# gx + gy = x_screen / 70
	# gy - gx = y_screen / 70
	# => gy = (x_screen/70 + y_screen/70) / 2
	# => gx = (x_screen/70 - y_screen/70) / 2
	var sum: float = (x_s / 70.0 + y_s / 70.0) / 2.0
	var diff: float = (x_s / 70.0 - y_s / 70.0) / 2.0
	return Vector2i(roundi(diff), roundi(sum))


# ─── Highlights ────────────────────────────────────────────────────────────

func highlight_spell_range(positions: Array) -> void:
	# Effacer uniquement les flags de sort
	for row: Array in cell_nodes:
		for cell: Cell in row:
			cell.set_in_spell_range(false)
	for pos: Vector2i in positions:
		var cell: Cell = get_cell_node_at(pos)
		if cell:
			cell.set_in_spell_range(true)


func highlight_move_range(positions: Array) -> void:
	# Effacer uniquement les flags de mouvement, pas les sorts
	for row: Array in cell_nodes:
		for cell: Cell in row:
			cell.set_in_move_range(false)
	for pos: Vector2i in positions:
		var cell: Cell = get_cell_node_at(pos)
		if cell:
			cell.set_in_move_range(true)


func clear_move_range_only() -> void:
	for row: Array in cell_nodes:
		for cell: Cell in row:
			cell.set_in_move_range(false)


func clear_all_highlights() -> void:
	_clear_all_range_flags()


func _clear_all_range_flags() -> void:
	for row: Array in cell_nodes:
		for cell: Cell in row:
			cell.set_in_move_range(false)
			cell.set_in_spell_range(false)


# ─── Mise à jour affichage ─────────────────────────────────────────────────

func update_entity_display() -> void:
	# Mettre à jour l'affichage de toutes les cellules
	for y: int in range(game_manager.GRID_SIZE):
		for x: int in range(game_manager.GRID_SIZE):
			var cell_node: Node2D = grid_nodes[y][x]
			var entity = game_manager.grid[y][x]
			if cell_node.has_method("update_display"):
				cell_node.update_display(entity)
	
	var current_player: Dictionary = {}
	if game_manager.current_turn == 0 and game_manager.players.size() > game_manager.current_player_index:
		current_player = game_manager.players[game_manager.current_player_index]

	for y: int in range(game_manager.GRID_SIZE):
		for x: int in range(game_manager.GRID_SIZE):
			if y >= cell_nodes.size() or x >= cell_nodes[y].size():
				continue
			var cell: Cell    = cell_nodes[y][x]
			var entity         = game_manager.grid[y][x]
			cell.entity        = entity
			cell.selected      = (game_manager.selected_cell == Vector2i(x, y))
			# Highlight le joueur actif (celui dont c'est le tour)
			cell.highlighted   = (not current_player.is_empty() and
				int(current_player.get("x", -1)) == x and
				int(current_player.get("y", -1)) == y)
			cell.update_appearance()


func get_cell_node_at(grid_pos: Vector2i) -> Cell:
	if grid_pos.y < cell_nodes.size() and grid_pos.x < cell_nodes[grid_pos.y].size():
		return cell_nodes[grid_pos.y][grid_pos.x]
	return null


func _on_cell_clicked(x: int, y: int) -> void:
	emit_signal("cell_clicked", x, y)