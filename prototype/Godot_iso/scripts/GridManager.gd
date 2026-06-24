extends Node2D
## GridManager.gd - Gestion de la grille isométrique
## Version avec vue inclinée style Waven (70°)

const CELL_SIZE := Vector2i(100, 100)
const HALF_CELL := Vector2(50, 50)

# Vue inclinée : scale vertical pour effet 3D + rotation
# scale.y = 0.4 simule une inclinaison à ~70°
# rotation_degrees = -15 pour l'angle final
const GRID_SCALE := Vector2(1.0, 0.4)
const GRID_ROTATION := -15.0

var game_manager
var cell_nodes: Array = []
var decoration_nodes: Array = []

var tree_texture: ImageTexture
var rock_texture: ImageTexture
var bush_texture: ImageTexture

signal cell_clicked(x: int, y: int)


func _ready():
	# Appliquer la transformation pour vue inclinée
	scale = GRID_SCALE
	rotation_degrees = GRID_ROTATION


func init(manager):
	game_manager = manager
	_load_decoration_textures()
	_create_grid()
	_add_random_decorations()


func _load_decoration_textures():
	"""Charge les textures des décors depuis le dossier assets"""
	var tree_img = Image.load_from_file("res://assets/tree.svg")
	if tree_img:
		tree_texture = ImageTexture.create_from_image(tree_img)
	
	var rock_img = Image.load_from_file("res://assets/rock.svg")
	if rock_img:
		rock_texture = ImageTexture.create_from_image(rock_img)
	
	var bush_img = Image.load_from_file("res://assets/bush.svg")
	if bush_img:
		bush_texture = ImageTexture.create_from_image(bush_img)


func _create_grid():
	"""Create isometric grid display with Node2D cells"""
	cell_nodes = []
	decoration_nodes = []
	
	for y in range(game_manager.GRID_SIZE):
		var row: Array = []
		for x in range(game_manager.GRID_SIZE):
			var cell = preload("res://scripts/Cell.gd").new()
			var screen_pos = grid_to_screen(Vector2i(x, y))
			cell.position = screen_pos
			cell.grid_position = Vector2i(x, y)
			cell.connect("cell_clicked", Callable(self, "_on_cell_clicked"))
			add_child(cell)
			row.append(cell)
		cell_nodes.append(row)
	
	update_entity_display()


func _add_random_decorations():
	"""Ajoute des décors aléatoires sur la grille"""
	var decoration_positions = [
		Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0),
		Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1),
		Vector2i(8, 8), Vector2i(9, 8), Vector2i(8, 9),
		Vector2i(6, 6), Vector2i(7, 6), Vector2i(6, 7),
		Vector2i(4, 4), Vector2i(5, 4), Vector2i(4, 5),
		Vector2i(1, 8), Vector2i(2, 8), Vector2i(8, 1),
		Vector2i(3, 7), Vector2i(7, 3), Vector2i(4, 8)
	]
	
	for pos in decoration_positions:
		if pos.x >= 0 and pos.x < game_manager.GRID_SIZE and pos.y >= 0 and pos.y < game_manager.GRID_SIZE:
			if game_manager.grid[pos.y][pos.x] == null:
				var decoration = Sprite2D.new()
				decoration.name = "Decoration_%d_%d" % [pos.x, pos.y]
				decoration.centered = true
				decoration.position = HALF_CELL
				decoration.z_index = 5
				
				var rand_val = randi() % 3
				if rand_val == 0 and tree_texture:
					decoration.texture = tree_texture
					decoration.scale = Vector2(0.6, 0.6)
					decoration.z_index = 6
				elif rand_val == 1 and rock_texture:
					decoration.texture = rock_texture
					decoration.scale = Vector2(0.45, 0.45)
					decoration.z_index = 5
				elif bush_texture:
					decoration.texture = bush_texture
					decoration.scale = Vector2(0.4, 0.4)
					decoration.z_index = 5
				
				var screen_pos = grid_to_screen(pos)
				decoration.global_position = screen_pos + HALF_CELL
				add_child(decoration)
				decoration_nodes.append(decoration)


func grid_to_screen(grid_pos: Vector2i) -> Vector2:
	"""Convert grid coordinates to isometric screen coordinates"""
	var x = grid_pos.x
	var y = grid_pos.y
	# Coordonnées isométriques de base
	var screen_x = float(x - y) * CELL_SIZE.x / 2.0
	var screen_y = float(x + y) * CELL_SIZE.y / 2.0
	# Centrage pour écran 1920x1080 avec grille 10x10
	# Après scale.y = 0.4, la hauteur effective est réduite
	# Largeur totale : 10 * 100 = 1000, offset X = (1920 - 1000) / 2 = 460
	# Hauteur totale après scale : 10 * 100 * 0.4 = 400, offset Y = (1080 - 400) / 2 = 340
	screen_x += 460.0
	screen_y += 340.0
	return Vector2(screen_x, screen_y)


func screen_to_grid(screen_pos: Vector2) -> Vector2i:
	"""Convert screen coordinates to grid coordinates"""
	# Inverser le centrage
	var x_screen = screen_pos.x - 460.0
	var y_screen = screen_pos.y - 340.0
	# Inverser le scale (division par scale.y)
	y_screen /= 0.4
	# Conversion isométrique inverse
	var grid_x = (x_screen / (CELL_SIZE.x / 2.0) + y_screen / (CELL_SIZE.y / 2.0)) / 2.0
	var grid_y = (y_screen / (CELL_SIZE.y / 2.0) - x_screen / (CELL_SIZE.x / 2.0)) / 2.0
	return Vector2i(round(grid_x), round(grid_y))


func _on_cell_clicked(x: int, y: int):
	emit_signal("cell_clicked", x, y)


func update_entity_display():
	"""Update all cell nodes to reflect current grid state"""
	for y in range(game_manager.GRID_SIZE):
		for x in range(game_manager.GRID_SIZE):
			if y < cell_nodes.size() and x < cell_nodes[y].size():
				var cell_node = cell_nodes[y][x]
				var entity = game_manager.grid[y][x]
				cell_node.entity = entity
				cell_node.selected = (game_manager.selected_cell == Vector2i(x, y))
				cell_node.highlighted = false
				var current_player = null
				if game_manager.current_turn == 0 and game_manager.players.size() > game_manager.current_player_index:
					current_player = game_manager.players[game_manager.current_player_index]
				if current_player and current_player["x"] == x and current_player["y"] == y:
					cell_node.highlighted = true
				cell_node.update_appearance()


func get_cell_node_at(grid_pos: Vector2i) -> Node2D:
	"""Return the cell node at the given grid position"""
	if grid_pos.y < cell_nodes.size() and grid_pos.x < cell_nodes[grid_pos.y].size():
		return cell_nodes[grid_pos.y][grid_pos.x]
	return null