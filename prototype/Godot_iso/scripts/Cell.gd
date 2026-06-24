extends Node2D
class_name Cell
## Cell.gd - Cellule isométrique style Waven
## Version finale avec compatibilité GridManager

const CELL_SIZE := Vector2i(100, 100)
const HALF := Vector2(50, 50)

const GRASS_COLOR := Color(0.42, 0.56, 0.14)
const GRASS_SIDE_LEFT := Color(0.33, 0.42, 0.18)
const GRASS_SIDE_RIGHT := Color(0.56, 0.74, 0.56)
const GRASS_HIGHLIGHT := Color(0.68, 1.0, 0.18, 0.4)
const GRASS_SHADOW := Color(0.18, 0.54, 0.34, 0.3)

const DIRT_COLOR := Color(0.54, 0.27, 0.07)
const DIRT_SIDE_LEFT := Color(0.40, 0.26, 0.13)
const DIRT_SIDE_RIGHT := Color(0.63, 0.32, 0.18)
const DIRT_HIGHLIGHT := Color(0.80, 0.52, 0.25, 0.5)
const DIRT_SHADOW := Color(0.29, 0.17, 0.16, 0.4)

const BORDER_HIGHLIGHT := Color(1.0, 0.83, 0.0, 0.6)
const SELECTION_COLOR := Color(1.0, 0.84, 0.0, 0.5)
const HIGHLIGHT_COLOR := Color(1.0, 1.0, 1.0, 0.3)

var grid_position: Vector2i = Vector2i(0, 0)
var entity = null
var selected: bool = false
var highlighted: bool = false

signal cell_clicked(x: int, y: int)

func _ready():
	pass

func _draw():
	var main_points = PackedVector2Array([Vector2(0, 50), Vector2(50, 0), Vector2(100, 50), Vector2(50, 100)])
	var is_grass := (grid_position.x + grid_position.y) % 2 == 0
	
	if is_grass:
		draw_polygon(main_points, make_colors([Color(0,0,0,0), GRASS_COLOR, GRASS_COLOR, GRASS_COLOR]))
		draw_polygon(PackedVector2Array([Vector2(0, 50), Vector2(50, 0), Vector2(50, 50)]), make_colors([Color(0,0,0,0), GRASS_SIDE_LEFT, GRASS_SIDE_LEFT]))
		draw_polygon(PackedVector2Array([Vector2(50, 50), Vector2(100, 50), Vector2(50, 100)]), make_colors([Color(0,0,0,0), GRASS_SIDE_RIGHT, GRASS_SIDE_RIGHT]))
		draw_polygon(PackedVector2Array([Vector2(15, 45), Vector2(50, 5), Vector2(85, 45), Vector2(50, 35)]), make_colors([Color(0,0,0,0), GRASS_HIGHLIGHT, GRASS_HIGHLIGHT, GRASS_HIGHLIGHT]))
		draw_polygon(PackedVector2Array([Vector2(15, 55), Vector2(50, 95), Vector2(85, 55), Vector2(50, 65)]), make_colors([Color(0,0,0,0), GRASS_SHADOW, GRASS_SHADOW, GRASS_SHADOW]))
		draw_polygon_outline(main_points, BORDER_HIGHLIGHT, 1.0)
		draw_grass_texture()
	else:
		draw_polygon(main_points, make_colors([Color(0,0,0,0), DIRT_COLOR, DIRT_COLOR, DIRT_COLOR]))
		draw_polygon(PackedVector2Array([Vector2(0, 50), Vector2(50, 0), Vector2(50, 50)]), make_colors([Color(0,0,0,0), DIRT_SIDE_LEFT, DIRT_SIDE_LEFT]))
		draw_polygon(PackedVector2Array([Vector2(50, 50), Vector2(100, 50), Vector2(50, 100)]), make_colors([Color(0,0,0,0), DIRT_SIDE_RIGHT, DIRT_SIDE_RIGHT]))
		draw_polygon(PackedVector2Array([Vector2(15, 45), Vector2(50, 5), Vector2(85, 45), Vector2(50, 35)]), make_colors([Color(0,0,0,0), DIRT_HIGHLIGHT, DIRT_HIGHLIGHT, DIRT_HIGHLIGHT]))
		draw_polygon(PackedVector2Array([Vector2(15, 55), Vector2(50, 95), Vector2(85, 55), Vector2(50, 65)]), make_colors([Color(0,0,0,0), DIRT_SHADOW, DIRT_SHADOW, DIRT_SHADOW]))
		draw_polygon_outline(main_points, BORDER_HIGHLIGHT, 1.0)
		draw_dirt_texture()
	
	if selected:
		draw_polygon_outline(PackedVector2Array([Vector2(5, 50), Vector2(50, 5), Vector2(95, 50), Vector2(50, 95)]), SELECTION_COLOR, 2.0)
	
	if highlighted:
		draw_polygon_outline(PackedVector2Array([Vector2(3, 50), Vector2(50, 3), Vector2(97, 50), Vector2(50, 97)]), HIGHLIGHT_COLOR, 2.0)
	
	if entity:
		draw_entity()

func update_appearance():
	queue_redraw()

func make_colors(arr: Array) -> PackedColorArray:
	var result = PackedColorArray()
	for c in arr:
		result.append(c)
	return result

func draw_polygon_outline(points: PackedVector2Array, color: Color, width: float):
	for i in range(points.size()):
		var start = points[i]
		var end = points[(i + 1) % points.size()]
		draw_line(start, end, color, width, true)

func draw_grass_texture():
	var grass_color = Color(0.24, 0.70, 0.44)
	draw_line(Vector2(20, 30), Vector2(30, 20), grass_color, 1.5, true)
	draw_line(Vector2(60, 35), Vector2(70, 25), grass_color, 1.5, true)
	draw_line(Vector2(30, 60), Vector2(40, 50), grass_color, 1.5, true)
	draw_line(Vector2(70, 65), Vector2(80, 55), grass_color, 1.5, true)

func draw_dirt_texture():
	var dirt_color = Color(0.63, 0.32, 0.18)
	var ellipse_data = [
		[Vector2(25, 35), Vector2(4, 2)],
		[Vector2(45, 40), Vector2(3, 1.5)],
		[Vector2(75, 30), Vector2(5, 2.5)],
		[Vector2(35, 65), Vector2(3.5, 2)],
		[Vector2(65, 70), Vector2(4, 2)]
	]
	for data in ellipse_data:
		var center = data[0]
		var radius = data[1]
		var num_points = 20
		var pts = PackedVector2Array()
		var cols = PackedColorArray()
		for j in range(num_points + 1):
			var angle = j * TAU / num_points
			pts.append(center + Vector2(cos(angle) * radius.x, sin(angle) * radius.y))
			cols.append(dirt_color)
		draw_polygon(pts, cols)

func draw_entity():
	var center = HALF
	var entity_type = entity.get("entity_type", "")
	var classe = entity.get("classe", "")
	var color = GameManager.COLORS.get(classe, Color(0.5, 0.5, 0.5))
	if entity_type == "Player":
		var circle_points = PackedVector2Array()
		var circle_cols = PackedColorArray()
		var num_points = 32
		for i in range(num_points + 1):
			var angle = i * TAU / num_points
			circle_points.append(center + Vector2(cos(angle), sin(angle)) * 25.0)
			circle_cols.append(color)
		draw_polygon(circle_points, circle_cols)
		var border_color = Color.YELLOW if entity.get("is_active", false) else Color.WHITE
		var border_width = 2.0 if entity.get("is_active", false) else 1.5
		for i in range(num_points):
			var start = circle_points[i]
			var end = circle_points[i + 1]
			draw_line(start, end, border_color, border_width, true)
	else:
		var triangle_points = PackedVector2Array([
			center + Vector2(-20, -15),
			center + Vector2(20, -15),
			center + Vector2(0, 20)
		])
		draw_polygon(triangle_points, make_colors([color, color, color]))
		for i in range(triangle_points.size()):
			var start = triangle_points[i]
			var end = triangle_points[(i + 1) % triangle_points.size()]
			draw_line(start, end, Color.RED, 1.0, true)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var local_pos = to_local(get_global_mouse_position())
		if _is_point_in_cell(local_pos):
			emit_signal("cell_clicked", grid_position.x, grid_position.y)

func _is_point_in_cell(point: Vector2) -> bool:
	var dx = abs(point.x - HALF.x)
	var dy = abs(point.y - HALF.y)
	return (dx + dy) < 50