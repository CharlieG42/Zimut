extends Node2D
## WorldMapManager.gd - Gestion de la grille isometrique de la carte monde.
## Reutilise la logique de detection isometrique de Cell.gd / GridManager.gd (mode Zimut).
## Chaque case de la carte represente une region pouvant contenir une ville.

const CELL_SIZE := Vector2i(140, 140)
const HALF_CELL := Vector2(70, 70)

var empire_manager: Node
var cell_nodes: Array = []

signal city_clicked(city: Dictionary)

func init(manager: Node) -> void:
	empire_manager = manager
	_create_grid()

func _create_grid() -> void:
	cell_nodes = []
	for y: int in range(empire_manager.GRID_SIZE):
		var row: Array = []
		for x: int in range(empire_manager.GRID_SIZE):
			var cell: ColorRect = ColorRect.new()
			cell.size = Vector2(CELL_SIZE)
			cell.position = _grid_to_screen(Vector2i(x, y))
			cell.color = _cell_color(Vector2i(x, y))
			cell.name = "Cell_%d_%d" % [x, y]
			add_child(cell)
			row.append(cell)
		cell_nodes.append(row)

func _grid_to_screen(pos: Vector2i) -> Vector2:
	return Vector2(float(pos.x) * CELL_SIZE.x, float(pos.y) * CELL_SIZE.y)

func _cell_color(pos: Vector2i) -> Color:
	# Couleur de base: damier neutre
	var base: Color = Color(0.25, 0.45, 0.25) if (pos.x + pos.y) % 2 == 0 else Color(0.2, 0.4, 0.2)
	var city: Dictionary = empire_manager.get_city_at(pos)
	if city.is_empty():
		return base
	# Couleur selon le proprietaire
	match city["owner"]:
		empire_manager.OWNER_PLAYER:
			return Color(0.1, 0.5, 0.9)
		empire_manager.OWNER_NEUTRAL:
			return Color(0.7, 0.7, 0.7)
		empire_manager.OWNER_AI:
			return Color(0.85, 0.2, 0.2)
		_:
			return base

## Convertit une position ecran en position de grille (clic/tap).
func screen_to_grid(screen_pos: Vector2) -> Vector2i:
	var local_pos: Vector2 = to_local(screen_pos)
	var x: int = int(floor(local_pos.x / CELL_SIZE.x))
	var y: int = int(floor(local_pos.y / CELL_SIZE.y))
	return Vector2i(x, y)

func _input(event: InputEvent) -> void:
	if empire_manager == null or empire_manager.game_over:
		return
	# Pendant une bataille tactique, la carte monde est masquee : ignorer les clics.
	if not visible or ("in_battle" in empire_manager and empire_manager.in_battle):
		return
	var tap_pos: Vector2 = Vector2.ZERO
	var is_tap: bool = false
	if event is InputEventScreenTouch and event.pressed:
		tap_pos = event.position
		is_tap = true
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		tap_pos = event.position
		is_tap = true
	if not is_tap:
		return
	var grid_pos: Vector2i = screen_to_grid(tap_pos)
	if grid_pos.x < 0 or grid_pos.x >= empire_manager.GRID_SIZE \
		or grid_pos.y < 0 or grid_pos.y >= empire_manager.GRID_SIZE:
		return
	var city: Dictionary = empire_manager.get_city_at(grid_pos)
	if not city.is_empty():
		city_clicked.emit(city)

## Rafraichit les couleurs des cellules quand une ville change de proprietaire.
func refresh_display() -> void:
	for y: int in range(empire_manager.GRID_SIZE):
		for x: int in range(empire_manager.GRID_SIZE):
			var cell: ColorRect = cell_nodes[y][x]
			cell.color = _cell_color(Vector2i(x, y))
