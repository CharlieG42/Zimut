extends Node2D
## WorldMapManager.gd - Carte monde isometrique du mode Empire.
## Vraies tuiles losange 280x140 (comme le combat Zimut), villes marquees
## par un pictogramme colore selon le proprietaire, cadrage auto a l'ecran.

const TILE_SIZE := Vector2i(280, 140)
const HALF_CELL := Vector2(140, 70)

var empire_manager: Node
var cell_nodes: Array = []
var city_marker_nodes: Dictionary = {}  # city_id -> Node2D
var origin := Vector2(960.0, 540.0)

signal city_clicked(city: Dictionary)

func init(manager) -> void:
	empire_manager = manager
	_fit_map_to_screen()
	_create_grid()
	refresh_display()

## Re-cadre la carte (apres une vue ville qui a deplace la camera).
func fit_map() -> void:
	_fit_map_to_screen()

## Centre la carte sur l'ecran et ajuste le zoom de la camera.
func _fit_map_to_screen() -> void:
	var viewport: Viewport = get_viewport()
	if viewport == null:
		return
	var screen: Vector2 = viewport.get_visible_rect().size
	var n: int = empire_manager.GRID_SIZE
	var map_w: float = float(n) * 280.0
	var map_h: float = float(2 * n - 2) * 70.0 + 140.0
	origin = Vector2(screen.x * 0.5, screen.y * 0.5 - map_h * 0.5 + 70.0)
	var cam: Camera2D = null
	for child in get_tree().get_current_scene().get_children():
		if child is Camera2D:
			cam = child
			break
	if cam:
		var margin := 0.86
		var zoom_x: float = screen.x * margin / map_w
		var zoom_y: float = (screen.y - 220.0) * margin / map_h
		var z: float = minf(zoom_x, zoom_y)
		cam.zoom = Vector2(z, z)
		cam.position = origin + Vector2(0.0, map_h * 0.5 - 70.0)
		cam.make_current()

func _create_grid() -> void:
	cell_nodes = []
	city_marker_nodes = {}
	for y: int in range(empire_manager.GRID_SIZE):
		var row: Array = []
		for x: int in range(empire_manager.GRID_SIZE):
			var cell: Node2D = preload("res://scripts/battle/BattleCell.gd").new()
			cell.grid_position = Vector2i(x, y)
			cell.z_index = x + y
			cell.connect("cell_clicked", Callable(self, "_on_cell_clicked"))
			add_child(cell)
			cell.position = grid_to_screen(Vector2i(x, y))
			row.append(cell)
		cell_nodes.append(row)
	_spawn_city_markers()

## Pictogrammes de ville superposes aux tuiles (drapeau colore + nom).
func _spawn_city_markers() -> void:
	for city: Dictionary in empire_manager.cities:
		if not city_marker_nodes.has(int(city["id"])):
			_make_city_marker(city)

func grid_to_screen(pos: Vector2i) -> Vector2:
	var half_w := float(TILE_SIZE.x) / 2.0
	var half_h := float(TILE_SIZE.y) / 2.0
	var x: float = origin.x + (float(pos.x) - float(pos.y)) * half_w
	var y: float = origin.y + (float(pos.x) + float(pos.y)) * half_h
	return Vector2(x, y)

func screen_to_grid(screen_pos: Vector2) -> Vector2i:
	var x_s: float = screen_pos.x - origin.x
	var y_s: float = screen_pos.y - origin.y
	var diff: float = x_s / 140.0
	var sum: float = y_s / 70.0
	return Vector2i(roundi((sum + diff) / 2.0), roundi((sum - diff) / 2.0))

## Teinte la tuile sous chaque ville a la couleur du proprietaire et
## dessine un contour: les villes restent identifiables d'un coup d'oeil.
func _highlight_city_tiles() -> void:
	for city: Dictionary in empire_manager.cities:
		var pos: Vector2i = Vector2i(int(city["x"]), int(city["y"]))
		if pos.x < 0 or pos.x >= empire_manager.GRID_SIZE \
				or pos.y < 0 or pos.y >= empire_manager.GRID_SIZE:
			continue
		var cell: Node2D = cell_nodes[pos.y][pos.x]
		var tint: Color = Color(0.85, 0.8, 0.3, 0.35)
		match city["owner"]:
			empire_manager.OWNER_PLAYER:
				tint = Color(0.2, 0.55, 1.0, 0.45)
			empire_manager.OWNER_NEUTRAL:
				tint = Color(0.9, 0.9, 0.9, 0.4)
			empire_manager.OWNER_AI:
				tint = Color(1.0, 0.25, 0.2, 0.45)
		cell.modulate = Color(1.0, 1.0, 1.0, 1.0) + tint * 0.0
		cell.set_meta("city_tint", tint)
		cell.queue_redraw()

## Detection losange precise via les BattleCell (la carte n'utilise plus son
## propre _input, ce qui evite les doublons avec la conversion ecran->grille).
func _on_cell_clicked(x: int, y: int) -> void:
	if empire_manager == null or empire_manager.game_over:
		return
	if not visible or ("in_battle" in empire_manager and empire_manager.in_battle):
		return
	var city: Dictionary = empire_manager.get_city_at(Vector2i(x, y))
	if not city.is_empty():
		city_clicked.emit(city)

## Rafraichit les marqueurs de ville (changement de proprietaire, conquete).
## Cree les marqueurs manquants (la carte peut etre initiee avant les villes).
func refresh_display() -> void:
	_highlight_city_tiles()
	for city: Dictionary in empire_manager.cities:
		var marker: Node2D = city_marker_nodes.get(int(city["id"]))
		if marker == null:
			marker = _make_city_marker(city)
		elif marker.has_method("setup"):
			marker.setup(city, empire_manager)

func _make_city_marker(city: Dictionary) -> Node2D:
	var pos: Vector2i = Vector2i(int(city["x"]), int(city["y"]))
	var marker: Node2D = preload("res://scripts/CityMarker.gd").new()
	marker.setup(city, empire_manager)
	marker.position = grid_to_screen(pos) + HALF_CELL
	marker.z_index = pos.x + pos.y + 40
	add_child(marker)
	city_marker_nodes[int(city["id"])] = marker
	return marker
