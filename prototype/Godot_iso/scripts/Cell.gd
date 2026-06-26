extends Node2D
class_name Cell
## Cell.gd - Cellule isométrique style Waven pour Zimut
## Corrections : détection de clic, barres de vie, entité active
## Support des sprites pour les joueurs et ennemis

const CELL_SIZE = Vector2i(100, 100)
const HALF = Vector2(50, 50)

## Chemins des sprites (relatifs au projet)
const SPRITE_PATH_PLAYERS = "res://assets/sprites/players/"
const SPRITE_PATH_ENEMIES = "res://assets/sprites/enemies/"
const SPRITE_EXTENSION = ".svg"

const GRASS_COLOR = Color(0.42, 0.56, 0.14)
const GRASS_SIDE_LEFT = Color(0.33, 0.42, 0.18)
const GRASS_SIDE_RIGHT = Color(0.56, 0.74, 0.56)
const GRASS_HIGHLIGHT = Color(0.68, 1.0, 0.18, 0.4)
const GRASS_SHADOW = Color(0.18, 0.54, 0.34, 0.3)

const DIRT_COLOR = Color(0.54, 0.27, 0.07)
const DIRT_SIDE_LEFT = Color(0.40, 0.26, 0.13)
const DIRT_SIDE_RIGHT = Color(0.63, 0.32, 0.18)
const DIRT_HIGHLIGHT = Color(0.80, 0.52, 0.25, 0.5)
const DIRT_SHADOW = Color(0.29, 0.17, 0.16, 0.4)

const BORDER_HIGHLIGHT = Color(1.0, 0.83, 0.0, 0.6)
const SELECTION_COLOR = Color(1.0, 0.84, 0.0, 0.9)
const HIGHLIGHT_COLOR = Color(0.3, 1.0, 0.5, 0.85)
const MOVE_RANGE_COLOR = Color(0.2, 0.7, 1.0, 0.7)
const SPELL_RANGE_COLOR = Color(1.0, 0.3, 0.2, 0.7)

var grid_position = Vector2i(0, 0)
var entity = null
var selected = false
var highlighted = false
var in_move_range = false
var in_spell_range = false

## Référence au sprite de l'entité (chargé dynamiquement)
var entity_sprite = null

signal cell_clicked(x, y)


func _ready():
	# Créer le sprite pour l'entité
	entity_sprite = Sprite2D.new()
	entity_sprite.position = HALF
	entity_sprite.z_index = 10
	entity_sprite.visible = false
	add_child(entity_sprite)


func _draw():
	var main_points = PackedVector2Array([
		Vector2(0, 50), Vector2(50, 0), Vector2(100, 50), Vector2(50, 100)
	])
	var is_grass = (grid_position.x + grid_position.y) % 2 == 0

	if is_grass:
		draw_polygon(main_points, _colors4(GRASS_COLOR))
		draw_polygon(PackedVector2Array([Vector2(0,50), Vector2(50,0), Vector2(50,50)]), _colors3(GRASS_SIDE_LEFT))
		draw_polygon(PackedVector2Array([Vector2(50,50), Vector2(100,50), Vector2(50,100)]), _colors3(GRASS_SIDE_RIGHT))
		draw_polygon(PackedVector2Array([Vector2(15,45), Vector2(50,5), Vector2(85,45), Vector2(50,35)]), _colors4(GRASS_HIGHLIGHT))
		draw_polygon(PackedVector2Array([Vector2(15,55), Vector2(50,95), Vector2(85,55), Vector2(50,65)]), _colors4(GRASS_SHADOW))
		_draw_outline(main_points, BORDER_HIGHLIGHT, 1.0)
		_draw_grass_texture()
	else:
		draw_polygon(main_points, _colors4(DIRT_COLOR))
		draw_polygon(PackedVector2Array([Vector2(0,50), Vector2(50,0), Vector2(50,50)]), _colors3(DIRT_SIDE_LEFT))
		draw_polygon(PackedVector2Array([Vector2(50,50), Vector2(100,50), Vector2(50,100)]), _colors3(DIRT_SIDE_RIGHT))
		draw_polygon(PackedVector2Array([Vector2(15,45), Vector2(50,5), Vector2(85,45), Vector2(50,35)]), _colors4(DIRT_HIGHLIGHT))
		draw_polygon(PackedVector2Array([Vector2(15,55), Vector2(50,95), Vector2(85,55), Vector2(50,65)]), _colors4(DIRT_SHADOW))
		_draw_outline(main_points, BORDER_HIGHLIGHT, 1.0)
		_draw_dirt_texture()

	# Overlays d'état (ordre : portée < sélection < highlight actif)
	if in_spell_range:
		draw_polygon(main_points, _colors4(Color(1.0, 0.3, 0.2, 0.25)))
		_draw_outline(PackedVector2Array([Vector2(4,50), Vector2(50,4), Vector2(96,50), Vector2(50,96)]), SPELL_RANGE_COLOR, 2.5)
	elif in_move_range:
		draw_polygon(main_points, _colors4(Color(0.2, 0.7, 1.0, 0.22)))
		_draw_outline(PackedVector2Array([Vector2(4,50), Vector2(50,4), Vector2(96,50), Vector2(50,96)]), MOVE_RANGE_COLOR, 2.5)

	if selected:
		draw_polygon(main_points, _colors4(Color(1.0, 0.84, 0.0, 0.18)))
		_draw_outline(PackedVector2Array([Vector2(4,50), Vector2(50,4), Vector2(96,50), Vector2(50,96)]), SELECTION_COLOR, 3.0)
		# Double contour intérieur style Waven
		_draw_outline(PackedVector2Array([Vector2(12,50), Vector2(50,12), Vector2(88,50), Vector2(50,88)]), Color(1.0,1.0,0.6,0.5), 1.2)

	if highlighted:
		_draw_outline(PackedVector2Array([Vector2(3,50), Vector2(50,3), Vector2(97,50), Vector2(50,97)]), HIGHLIGHT_COLOR, 3.0)

	if entity:
		_draw_entity()


func update_appearance():
	queue_redraw()
	
	if entity != null:
		var entity_type = entity.get("entity_type", "")
		var classe = entity.get("classe", "")
		_try_load_sprite(classe, entity_type)
		# Mettre à jour la visibilité du sprite
		entity_sprite.visible = _try_load_sprite(classe, entity_type)


func set_in_move_range(value):
	if in_move_range != value:
		in_move_range = value
		queue_redraw()


func set_in_spell_range(value):
	if in_spell_range != value:
		in_spell_range = value
		queue_redraw()


# Dessiner l'entité
func _draw_entity():
	var center = HALF
	var entity_type = entity.get("entity_type", "")
	var classe = entity.get("classe", "")
	var is_active = entity.get("is_active", false)
	var color = GameManager.COLORS.get(classe, Color(0.5, 0.5, 0.5))
	
	if _try_load_sprite(classe, entity_type):
		entity_sprite.visible = true
		if highlighted or is_active:
			var tip = center + Vector2(0, -32)
			draw_line(tip + Vector2(-7, 8), tip, Color(1.0, 1.0, 0.3), 2.5)
			draw_line(tip + Vector2(7, 8), tip, Color(1.0, 1.0, 0.3), 2.5)
	else:
		entity_sprite.visible = false
		_draw_entity_geometric(center, entity_type, classe, is_active, color)

	_draw_health_bar(center)


func _try_load_sprite(classe, entity_type):
	var sprite_path = ""
	
	if entity_type == "Player":
		sprite_path = SPRITE_PATH_PLAYERS + classe.to_lower() + SPRITE_EXTENSION
	elif entity_type == "Enemy":
		sprite_path = SPRITE_PATH_ENEMIES + classe.to_lower() + SPRITE_EXTENSION
	
	if sprite_path != "" and ResourceLoader.exists(sprite_path):
		var texture = load(sprite_path)
		if texture:
			entity_sprite.texture = texture
			entity_sprite.scale = Vector2(0.8, 0.8)
			return true
	
	return false


func _draw_entity_geometric(center, entity_type, classe, is_active, color):
	# Ombre portée
	_draw_ellipse(center + Vector2(0, 8), Vector2(18, 6), Color(0, 0, 0, 0.35))

	if entity_type == "Player":
		var num_pts = 32
		var pts = PackedVector2Array()
		var cols = PackedColorArray()
		for i in range(num_pts + 1):
			var angle = i * TAU / num_pts
			pts.append(center + Vector2(cos(angle), sin(angle)) * 25.0)
			cols.append(color)
		draw_polygon(pts, cols)
		var border_color = Color.YELLOW if is_active else Color.WHITE
		var border_w = 3.0 if is_active else 1.5
		for i in range(num_pts):
			draw_line(pts[i], pts[i + 1], border_color, border_w, true)
		if highlighted or is_active:
			var tip = center + Vector2(0, -32)
			draw_line(tip + Vector2(-7, 8), tip, Color(1.0, 1.0, 0.3), 2.5)
			draw_line(tip + Vector2(7, 8), tip, Color(1.0, 1.0, 0.3), 2.5)
	else:
		var tri = PackedVector2Array([
			center + Vector2(-20, -15),
			center + Vector2(20, -15),
			center + Vector2(0, 22),
		])
		draw_polygon(tri, PackedColorArray([color, color, color]))
		for i in range(tri.size()):
			draw_line(tri[i], tri[(i + 1) % tri.size()], Color.RED, 1.5, true)


func _draw_health_bar(center):
	var max_pv = float(entity.get("max_pv", entity.get("current_pv", 1)))
	var cur_pv = float(entity.get("current_pv", 0))
	if max_pv <= 0:
		return
	var ratio = clampf(cur_pv / max_pv, 0.0, 1.0)
	var bar_w = 32.0
	var bar_h = 5.0
	var bar_pos = center + Vector2(-bar_w * 0.5, 20.0)

	draw_rect(Rect2(bar_pos, Vector2(bar_w, bar_h)), Color(0, 0, 0, 0.7), true)
	var fill_color = Color(0.2, 0.9, 0.2)
	if ratio < 0.5:
		fill_color = Color(0.95, 0.75, 0.1)
	if ratio < 0.25:
		fill_color = Color(0.95, 0.15, 0.1)
	draw_rect(Rect2(bar_pos, Vector2(bar_w * ratio, bar_h)), fill_color, true)
	draw_rect(Rect2(bar_pos, Vector2(bar_w, bar_h)), Color(1, 1, 1, 0.35), false)


# Textures procédurales
func _draw_grass_texture():
	var c = Color(0.24, 0.70, 0.44)
	draw_line(Vector2(20, 30), Vector2(30, 20), c, 1.5, true)
	draw_line(Vector2(60, 35), Vector2(70, 25), c, 1.5, true)
	draw_line(Vector2(30, 60), Vector2(40, 50), c, 1.5, true)
	draw_line(Vector2(70, 65), Vector2(80, 55), c, 1.5, true)


func _draw_dirt_texture():
	var c = Color(0.63, 0.32, 0.18)
	for data in [[Vector2(25,35), Vector2(4,2)], [Vector2(45,40), Vector2(3,1.5)],
				 [Vector2(75,30), Vector2(5,2.5)], [Vector2(35,65), Vector2(3.5,2)],
				 [Vector2(65,70), Vector2(4,2)]]:
		_draw_ellipse(data[0], data[1], c)


func _draw_ellipse(center, radius, color, steps = 20):
	var pts = PackedVector2Array()
	var cols = PackedColorArray()
	for i in range(steps):
		var a = TAU * float(i) / float(steps)
		pts.append(center + Vector2(cos(a) * radius.x, sin(a) * radius.y))
		cols.append(color)
	draw_polygon(pts, cols)


# Helpers couleurs
func _colors3(c):
	return PackedColorArray([c, c, c])


func _colors4(c):
	return PackedColorArray([c, c, c, c])


func _draw_outline(points, color, width):
	for i in range(points.size()):
		draw_line(points[i], points[(i + 1) % points.size()], color, width, true)


# Détection de clic
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var local_pos = to_local(get_global_mouse_position())
		if _is_point_in_diamond(local_pos):
			emit_signal("cell_clicked", grid_position.x, grid_position.y)


func _is_point_in_diamond(point):
	var cx = 50.0
	var cy = 50.0
	var hw = 50.0
	var hh = 50.0
	return (absf(point.x - cx) / hw) + (absf(point.y - cy) / hh) <= 1.0
