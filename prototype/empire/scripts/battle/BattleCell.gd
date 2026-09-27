extends Node2D
class_name BattleCell
## BattleCell.gd - Cellule isometrique 2:1 du combat tactique (mode Empire).
## Tuiles losange natives 280x140 (plus de rotation -45 de sprites carres).
## Overlays dessines en parallele du losange (selection, portee, PV).

const TILE_SIZE = Vector2i(280, 140)
const HALF = Vector2(140, 70)

## Chemins des sprites
const SPRITE_PATH_PLAYERS = "res://assets/sprites/players/"
const SPRITE_PATH_ENEMIES = "res://assets/sprites/enemies/"
const SPRITE_PATH_TILES = "res://assets/sprites/tiles/"
const SPRITE_EXTENSION = ".png"

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

## Sprites
var tile_sprite = null
var entity_sprite = null
var _cached_sprite_path = ""

signal cell_clicked(x, y)


func _ready():
	# Sprite de la tuile losange (texture iso native, pas de rotation)
	tile_sprite = Sprite2D.new()
	tile_sprite.centered = false
	tile_sprite.z_index = 0
	add_child(tile_sprite)

	# Sprite de l'entite, pieds ancrés au centre du losange
	entity_sprite = Sprite2D.new()
	entity_sprite.centered = true
	entity_sprite.z_index = 10
	entity_sprite.visible = false
	add_child(entity_sprite)

	_load_tile_sprite()


func _load_tile_sprite():
	# Damier de deux textures, avec variation "stone" occasionnelle
	var is_grass = (grid_position.x + grid_position.y) % 2 == 0
	var tile_name = "grass" if is_grass else "dirt"
	if (grid_position.x * 7 + grid_position.y * 13) % 11 == 0:
		tile_name = "stone"
	var texture_path = SPRITE_PATH_TILES + tile_name + SPRITE_EXTENSION

	if ResourceLoader.exists(texture_path):
		tile_sprite.texture = load(texture_path)
		if tile_sprite.texture:
			var tex_size = tile_sprite.texture.get_size()
			tile_sprite.scale = Vector2(float(TILE_SIZE.x) / tex_size.x, float(TILE_SIZE.y) / tex_size.y)


func _draw():
	var w = float(TILE_SIZE.x)
	var h = float(TILE_SIZE.y)
	var hw = w / 2.0
	var hh = h / 2.0

	var main_points = PackedVector2Array([
		Vector2(0, hh), Vector2(hw, 0), Vector2(w, hh), Vector2(hw, h)
	])

	if in_spell_range:
		draw_polygon(main_points, _colors4(Color(1.0, 0.3, 0.2, 0.25)))
	elif in_move_range:
		draw_polygon(main_points, _colors4(Color(0.2, 0.7, 1.0, 0.22)))

	if selected:
		draw_polygon(main_points, _colors4(Color(1.0, 0.84, 0.0, 0.18)))
		_draw_outline(main_points, SELECTION_COLOR, 3.0)
	if highlighted:
		_draw_outline(main_points, HIGHLIGHT_COLOR, 3.0)

	if entity:
		_draw_ellipse(HALF + Vector2(0, hh * 0.10), Vector2(hw * 0.32, hh * 0.10), Color(0, 0, 0, 0.30))
		_draw_health_bar(HALF, hw, hh)


## Helpers couleurs
func _colors3(c):
	return PackedColorArray([c, c, c])


func _colors4(c):
	return PackedColorArray([c, c, c, c])


## Dessiner un contour
func _draw_outline(points, color, width):
	for i in range(points.size()):
		draw_line(points[i], points[(i + 1) % points.size()], color, width, true)


## Affiche le sprite de l'entite (pieds au centre du losange, ombre portee)
func _show_entity_sprite():
	var entity_type = entity.get("entity_type", "")
	var classe = entity.get("classe", "")
	if _try_load_sprite(classe, entity_type):
		entity_sprite.visible = true
		return true
	entity_sprite.visible = false
	return false


func hw() -> float:
	return float(TILE_SIZE.x) / 2.0


func hh() -> float:
	return float(TILE_SIZE.y) / 2.0


## Charger le sprite de l'entite
func _try_load_sprite(classe, entity_type):
	var sprite_path = ""
	var extensions = [".png", ".svg"]

	if entity_type == "Player":
		for ext in extensions:
			sprite_path = SPRITE_PATH_PLAYERS + classe.to_lower() + ext
			if ResourceLoader.exists(sprite_path):
				break
	elif entity_type == "Enemy":
		for ext in extensions:
			sprite_path = SPRITE_PATH_ENEMIES + classe.to_lower() + ext
			if ResourceLoader.exists(sprite_path):
				break

	if sprite_path != "" and ResourceLoader.exists(sprite_path):
		if _cached_sprite_path == sprite_path and entity_sprite.texture:
			return true
		var texture = load(sprite_path)
		if texture:
			_cached_sprite_path = sprite_path
			entity_sprite.texture = texture
			var tex_size = entity_sprite.texture.get_size()
			# Hauteur cible ~ la moitie de la tuile ; pieds ancrés au centre
			var target_h = 110.0
			var scale_f = target_h / tex_size.y
			entity_sprite.scale = Vector2(scale_f, scale_f)
			entity_sprite.position = Vector2(HALF.x, HALF.y - tex_size.y * scale_f * 0.5 + 6.0)
			return true

	return false


## Dessiner une ellipse
func _draw_ellipse(center, radius, color, steps = 20):
	var pts = PackedVector2Array()
	var cols = PackedColorArray()
	for i in range(steps):
		var a = TAU * float(i) / float(steps)
		pts.append(center + Vector2(cos(a) * radius.x, sin(a) * radius.y))
		cols.append(color)
	draw_polygon(pts, cols)


## Dessiner la barre de vie (au-dessus de l'entite, style Dofus)
func _draw_health_bar(center, hw_v, hh_v):
	var max_pv = float(entity.get("max_pv", entity.get("current_pv", 1)))
	var cur_pv = float(entity.get("current_pv", 0))
	if max_pv <= 0:
		return
	var ratio = clampf(cur_pv / max_pv, 0.0, 1.0)
	var bar_w = 90.0
	var bar_h = 10.0
	var bar_pos = Vector2(center.x - bar_w * 0.5, center.y - 108.0)

	draw_rect(Rect2(bar_pos, Vector2(bar_w, bar_h)), Color(0, 0, 0, 0.65), true)
	var fill_color = Color(0.2, 0.9, 0.2)
	if ratio < 0.5:
		fill_color = Color(0.95, 0.75, 0.1)
	if ratio < 0.25:
		fill_color = Color(0.95, 0.15, 0.1)
	draw_rect(Rect2(bar_pos, Vector2(bar_w * ratio, bar_h)), fill_color, true)
	draw_rect(Rect2(bar_pos, Vector2(bar_w, bar_h)), Color(1, 1, 1, 0.35), false)


func update_appearance():
	queue_redraw()
	if entity != null:
		var entity_type = entity.get("entity_type", "")
		var classe = entity.get("classe", "")
		_show_entity_sprite()
	else:
		entity_sprite.visible = false


func set_in_move_range(value):
	if in_move_range != value:
		in_move_range = value
		queue_redraw()


func set_in_spell_range(value):
	if in_spell_range != value:
		in_spell_range = value
		queue_redraw()


# Detection de clic (souris et tactile Android) - geometrie du losange
func _input(event):
	var is_tap: bool = false
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		is_tap = true
	elif event is InputEventScreenTouch and event.pressed:
		is_tap = true
	if not is_tap:
		return
	var local_event: InputEvent = make_input_local(event)
	if local_event and _is_point_in_diamond(local_event.position):
		emit_signal("cell_clicked", grid_position.x, grid_position.y)


func _is_point_in_diamond(point):
	var cx = HALF.x
	var cy = HALF.y
	return (absf(point.x - cx) / hw()) + (absf(point.y - cy) / hh()) <= 1.0
