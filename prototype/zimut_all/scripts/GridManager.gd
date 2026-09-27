extends Node2D
## GridManager.gd - Grille isometrique 2:1 (style Dofus/Waven)
## Tuiles losange natives 280x140, pas de rotation de cellules.
## Ordre de dessin: tri par profondeur (y+x) pour un empilement propre.

const TILE_SIZE  := Vector2i(280, 140)
const HALF_CELL  := Vector2(140, 70)

var game_manager
var cell_nodes: Array        = []
var decoration_nodes: Array  = []
var origin := Vector2(960.0, 540.0)

var tree_texture: ImageTexture
var rock_texture: ImageTexture
var bush_texture: ImageTexture

signal cell_clicked(x: int, y: int)


func init(manager) -> void:
	game_manager = manager
	_fit_grid_to_screen()
	_load_decoration_textures()
	_create_grid()
	_add_random_decorations()

## Centre la grille sur l'ecran et ajuste le zoom de la camera pour que
## la totalite du plateau soit visible (meme apres un changement de taille).
func _fit_grid_to_screen() -> void:
	var viewport: Viewport = get_viewport()
	if viewport == null:
		return
	var screen: Vector2 = viewport.get_visible_rect().size
	var n: int = game_manager.GRID_SIZE
	# Emprise totale de la grille iso (tuiles 280x140)
	var grid_w: float = float(n) * 140.0 + float(n) * 140.0
	var grid_h: float = float(2 * n - 2) * 70.0 + 140.0
	origin = Vector2(screen.x * 0.5, screen.y * 0.5 - grid_h * 0.5 + 70.0)
	# Camera : zoom pour cadrer la grille
	var cam: Camera2D = null
	var p: Node = get_parent()
	while p:
		if p is Camera2D:
			cam = p
			break
		p = p.get_parent()
	if cam == null:
		for child in get_tree().get_current_scene().get_children():
			if child is Camera2D:
				cam = child
				break
	if cam:
		var margin := 0.92
		var zoom_x: float = screen.x * margin / grid_w
		var zoom_y: float = screen.y * margin / grid_h
		cam.zoom = Vector2(minf(zoom_x, zoom_y), minf(zoom_x, zoom_y))
		cam.position = origin + Vector2(0.0, grid_h * 0.5 - 70.0)
		cam.make_current()


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
			cell.grid_position = Vector2i(x, y)
			# Profondeur iso: les cellules du fond (x+y petit) dessinees en premier
			cell.z_index = x + y
			cell.connect("cell_clicked", Callable(self, "_on_cell_clicked"))
			add_child(cell)
			cell.position = grid_to_screen(Vector2i(x, y))
			row.append(cell)
		cell_nodes.append(row)

	update_entity_display()


## Positions de decoration aleatoire (eviter les cellules occupees)
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
		deco.centered = false
		# Meme profondeur que la cellule, legerement au-dessus pour couvrir la tuile
		deco.z_index  = pos.x + pos.y + 1
		var rand_val: int = randi() % 3
		if rand_val == 0 and tree_texture:
			deco.texture = tree_texture
			deco.scale   = Vector2(0.6, 0.6)
		elif rand_val == 1 and rock_texture:
			deco.texture = rock_texture
			deco.scale   = Vector2(0.45, 0.45)
		elif bush_texture:
			deco.texture = bush_texture
			deco.scale   = Vector2(0.4, 0.4)
		deco.global_position = grid_to_screen(pos)
		add_child(deco)
		decoration_nodes.append(deco)


# ──────────────────────────────────────────────── Coordonnees ──

func grid_to_screen(grid_pos: Vector2i) -> Vector2:
	# Iso 2:1 : deplacement d'une cellule = (+140, +70) sur l'axe x,
	# (-140, +70) sur l'axe y. Grille centree sur (960, 200).
	var half_w := float(TILE_SIZE.x) / 2.0
	var half_h := float(TILE_SIZE.y) / 2.0
	var x: float = origin.x + (float(grid_pos.x) - float(grid_pos.y)) * half_w
	var y: float = origin.y + (float(grid_pos.x) + float(grid_pos.y)) * half_h
	return Vector2(x, y)


func screen_to_grid(screen_pos: Vector2) -> Vector2i:
	var x_s: float = screen_pos.x - origin.x
	var y_s: float = screen_pos.y - origin.y
	# gx - gy = x_s / 140 ; gx + gy = (y_s - 70) / 70... inverser:
	var diff: float = x_s / 140.0
	var sum: float  = y_s / 70.0
	var gx: float = (sum + diff) / 2.0
	var gy: float = (sum - diff) / 2.0
	return Vector2i(roundi(gx), roundi(gy))


# ──────────────────────────────────────────────── Highlights ──

func highlight_spell_range(positions: Array) -> void:
	for row: Array in cell_nodes:
		for cell: Cell in row:
			cell.set_in_spell_range(false)
	for pos: Vector2i in positions:
		var cell: Cell = get_cell_node_at(pos)
		if cell:
			cell.set_in_spell_range(true)


func highlight_move_range(positions: Array) -> void:
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


# ──────────────────────────────────────────────── Mise a jour affichage ──

func update_entity_display() -> void:
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
			cell.highlighted   = (not current_player.is_empty() and
				int(current_player.get("x", -1)) == x and
				int(current_player.get("y", -1)) == y)
			cell.update_appearance()


func get_cell_node_at(grid_pos: Vector2i) -> Cell:
	if grid_pos.y < cell_nodes.size() and grid_pos.x < cell_nodes[grid_pos.y].size():
		return cell_nodes[grid_pos.y][grid_pos.x]
	return null


func _on_cell_clicked(x: int, y: int) -> void:
	cell_clicked.emit(x, y)
