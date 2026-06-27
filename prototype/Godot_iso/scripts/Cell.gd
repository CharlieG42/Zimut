extends Node2D
class_name Cell
## Cell.gd - Cellule isométrique style Waven pour Zimut
## Corrections : détection de clic, barres de vie, entité active
## Support des sprites pour les joueurs et ennemis

const CELL_SIZE = Vector2i(140, 140)
const HALF = Vector2(70, 70)

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

## Sprite de l'entité (affiché au-dessus de la tuile)
var entity_sprite = null
## Cache du chemin chargé pour éviter reload() à chaque frame
var _cached_sprite_path = ""

signal cell_clicked(x, y)


func _ready():
	# Créer le sprite pour l'entité
	entity_sprite = Sprite2D.new()
	entity_sprite.position = HALF
	entity_sprite.z_index = 10
	entity_sprite.visible = false
	add_child(entity_sprite)


func _draw():
	# Coordonnées basées sur CELL_SIZE (140x140)
	var w = float(CELL_SIZE.x)
	var h = float(CELL_SIZE.y)
	var hw = w / 2.0
	var hh = h / 2.0
	
	var main_points = PackedVector2Array([
		Vector2(0, hh), Vector2(hw, 0), Vector2(w, hh), Vector2(hw, h)
	])
	var is_grass = (grid_position.x + grid_position.y) % 2 == 0

	if is_grass:
		draw_polygon(main_points, _colors4(GRASS_COLOR))
		draw_polygon(PackedVector2Array([Vector2(0,hh), Vector2(hw,0), Vector2(hw,hh)]), _colors3(GRASS_SIDE_LEFT))
		draw_polygon(PackedVector2Array([Vector2(hw,hh), Vector2(w,hh), Vector2(hw,h)]), _colors3(GRASS_SIDE_RIGHT))
		draw_polygon(PackedVector2Array([Vector2(hw*0.3,hh*0.9), Vector2(hw,hh*0.1), Vector2(w-hw*0.3,hh*0.9), Vector2(hw,hh*0.7)]), _colors4(GRASS_HIGHLIGHT))
		draw_polygon(PackedVector2Array([Vector2(hw*0.3,hh*1.1), Vector2(hw,hh*1.9), Vector2(w-hw*0.3,hh*1.1), Vector2(hw,hh*1.3)]), _colors4(GRASS_SHADOW))
		_draw_outline(main_points, BORDER_HIGHLIGHT, 1.0)
		_draw_grass_texture(hw, hh)
	else:
		draw_polygon(main_points, _colors4(DIRT_COLOR))
		draw_polygon(PackedVector2Array([Vector2(0,hh), Vector2(hw,0), Vector2(hw,hh)]), _colors3(DIRT_SIDE_LEFT))
		draw_polygon(PackedVector2Array([Vector2(hw,hh), Vector2(w,hh), Vector2(hw,h)]), _colors3(DIRT_SIDE_RIGHT))
		draw_polygon(PackedVector2Array([Vector2(hw*0.3,hh*0.9), Vector2(hw,hh*0.1), Vector2(w-hw*0.3,hh*0.9), Vector2(hw,hh*0.7)]), _colors4(DIRT_HIGHLIGHT))
		draw_polygon(PackedVector2Array([Vector2(hw*0.15,hh*0.9), Vector2(hw*0.5,hh*1.35), Vector2(w-hw*0.15,hh*0.9), Vector2(hw,hh*0.45)]), _colors4(DIRT_SHADOW))
		_draw_outline(main_points, BORDER_HIGHLIGHT, 1.0)
		_draw_dirt_texture(hw, hh)

	# Overlays d'état (ordre : portée < sélection < highlight actif)
	if in_spell_range:
		draw_polygon(main_points, _colors4(Color(1.0, 0.3, 0.2, 0.25)))
		_draw_outline(PackedVector2Array([Vector2(hw*0.04,hh), Vector2(hw,hh*0.04), Vector2(w-hw*0.04,hh), Vector2(hw,hh*1.96)]), SPELL_RANGE_COLOR, 2.5)
	elif in_move_range:
		draw_polygon(main_points, _colors4(Color(0.2, 0.7, 1.0, 0.22)))
		_draw_outline(PackedVector2Array([Vector2(hw*0.04,hh), Vector2(hw,hh*0.04), Vector2(w-hw*0.04,hh), Vector2(hw,hh*1.96)]), MOVE_RANGE_COLOR, 2.5)

	if selected:
		draw_polygon(main_points, _colors4(Color(1.0, 0.84, 0.0, 0.18)))
		_draw_outline(PackedVector2Array([Vector2(hw*0.04,hh), Vector2(hw,hh*0.04), Vector2(w-hw*0.04,hh), Vector2(hw,hh*1.96)]), SELECTION_COLOR, 3.0)
		# Double contour intérieur style Waven
		_draw_outline(PackedVector2Array([Vector2(hw*0.12,hh), Vector2(hw,hh*0.12), Vector2(w-hw*0.12,hh), Vector2(hw,hh*1.88)]), Color(1.0,1.0,0.6,0.5), 1.2)

	if highlighted:
		_draw_outline(PackedVector2Array([Vector2(hw*0.03,hh), Vector2(hw,hh*0.03), Vector2(w-hw*0.03,hh), Vector2(hw,hh*1.97)]), HIGHLIGHT_COLOR, 3.0)

	if entity:
		_draw_entity(hw, hh)


func update_appearance():
	# Mettre à jour l'affichage de l'entité
	queue_redraw()
	
	# Recharger le sprite si l'entité a changé
	if entity != null:
		var entity_type = entity.get("entity_type", "")
		var classe = entity.get("classe", "")
		_try_load_sprite(classe, entity_type)
		entity_sprite.visible = _try_load_sprite(classe, entity_type)
	else:
		# Masquer le sprite si aucune entité (fix image fantôme)
		entity_sprite.visible = false


func set_in_move_range(value):
	if in_move_range != value:
		in_move_range = value
		queue_redraw()


func set_in_spell_range(value):
	if in_spell_range != value:
		in_spell_range = value
		queue_redraw()


# Dessiner l'entité
func _draw_entity(hw, hh):
	var center = HALF
	var entity_type = entity.get("entity_type", "")
	var classe = entity.get("classe", "")
	var is_active = entity.get("is_active", false)
	var color = GameManager.COLORS.get(classe, Color(0.5, 0.5, 0.5))
	
	if _try_load_sprite(classe, entity_type):
		entity_sprite.visible = true
		if highlighted or is_active:
			var tip = center + Vector2(0, -hh * 0.45)
			draw_line(tip + Vector2(-hw*0.1, hh*0.11), tip, Color(1.0, 1.0, 0.3), 2.5)
			draw_line(tip + Vector2(hw*0.1, hh*0.11), tip, Color(1.0, 1.0, 0.3), 2.5)
	else:
		entity_sprite.visible = false
		_draw_entity_geometric(center, entity_type, classe, is_active, color, hw, hh)

	_draw_health_bar(center, hw, hh)


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
			# Centrer et ajuster la taille du sprite - AGRANDI
			var tex_size = entity_sprite.texture.get_size()
			var scale_f = 1.2
			entity_sprite.scale = Vector2(scale_f, scale_f)
			entity_sprite.position = Vector2(HALF.x, HALF.y - tex_size.y * scale_f * 0.5 + HALF.y * 0.05)
			return true
	
	return false


func _draw_entity_geometric(center, entity_type, classe, is_active, color, hw, hh):
	# Ombre portée - AGRANDIE
	_draw_ellipse(center + Vector2(0, hh*0.14), Vector2(hw*0.35, hh*0.12), Color(0, 0, 0, 0.35))

	if entity_type == "Player":
		var num_pts = 32
		var pts = PackedVector2Array()
		var cols = PackedColorArray()
		for i in range(num_pts + 1):
			var angle = i * TAU / num_pts
			# Cercle AGRANDI (de 0.35 à 0.5)
			pts.append(center + Vector2(cos(angle), sin(angle)) * hw * 0.5)
			cols.append(color)
		draw_polygon(pts, cols)
		var border_color = Color.YELLOW if is_active else Color.WHITE
		var border_w = 3.0 if is_active else 2.0
		for i in range(num_pts):
			draw_line(pts[i], pts[i + 1], border_color, border_w, true)
		if highlighted or is_active:
			var tip = center + Vector2(0, -hh * 0.55)
			draw_line(tip + Vector2(-hw*0.14, hh*0.14), tip, Color(1.0, 1.0, 0.3), 3.0)
			draw_line(tip + Vector2(hw*0.14, hh*0.14), tip, Color(1.0, 1.0, 0.3), 3.0)
	else:
		# Triangle AGRANDI
		var tri = PackedVector2Array([
			center + Vector2(-hw*0.38, -hh*0.28),
			center + Vector2(hw*0.38, -hh*0.28),
			center + Vector2(0, hh*0.42),
		])
		draw_polygon(tri, PackedColorArray([color, color, color]))
		for i in range(tri.size()):
			draw_line(tri[i], tri[(i + 1) % tri.size()], Color.RED, 2.0, true)


func _draw_health_bar(center, hw, hh):
	var max_pv = float(entity.get("max_pv", entity.get("current_pv", 1)))
	var cur_pv = float(entity.get("current_pv", 0))
	if max_pv <= 0:
		return
	var ratio = clampf(cur_pv / max_pv, 0.0, 1.0)
	# Dynamic sizing based on cell size - barre plus large pour personnages agrandis
	var bar_w = hw * 0.65  # ~45% of cell width (augmenté)
	var bar_h = hh * 0.12   # ~12% of cell height (augmenté)
	var bar_pos = center + Vector2(-bar_w * 0.5, hh * 0.52)  # Position plus haute pour personnages plus grands

	draw_rect(Rect2(bar_pos, Vector2(bar_w, bar_h)), Color(0, 0, 0, 0.7), true)
	var fill_color = Color(0.2, 0.9, 0.2)
	if ratio < 0.5:
		fill_color = Color(0.95, 0.75, 0.1)
	if ratio < 0.25:
		fill_color = Color(0.95, 0.15, 0.1)
	draw_rect(Rect2(bar_pos, Vector2(bar_w * ratio, bar_h)), fill_color, true)
	draw_rect(Rect2(bar_pos, Vector2(bar_w, bar_h)), Color(1, 1, 1, 0.35), false)


# Textures procédurales
func _draw_grass_texture(hw, hh):
	var c = Color(0.24, 0.70, 0.44)
	draw_line(Vector2(hw*0.28, hh*0.42), Vector2(hw*0.42, hh*0.28), c, 1.5, true)
	draw_line(Vector2(hw*0.84, hh*0.5), Vector2(hw*1.0, hh*0.35), c, 1.5, true)
	draw_line(Vector2(hw*0.42, hh*0.84), Vector2(hw*0.56, hh*0.7), c, 1.5, true)
	draw_line(Vector2(hw*1.0, hh*0.91), Vector2(hw*1.12, hh*0.77), c, 1.5, true)


func _draw_dirt_texture(hw, hh):
	var c = Color(0.63, 0.32, 0.18)
	for data in [[Vector2(hw*0.35,hh*0.5), Vector2(hw*0.06,hh*0.03)], 
				 [Vector2(hw*0.63,hh*0.56), Vector2(hw*0.04,hh*0.02)],
				 [Vector2(hw*1.05,hh*0.42), Vector2(hw*0.07,hh*0.035)], 
				 [Vector2(hw*0.5,hh*0.91), Vector2(hw*0.05,hh*0.03)],
				 [Vector2(hw*0.91,hh*0.98), Vector2(hw*0.06,hh*0.03)]]:
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
	var cx = HALF.x
	var cy = HALF.y
	var hw = HALF.x
	var hh = HALF.y
	return (absf(point.x - cx) / hw) + (absf(point.y - cy) / hh) <= 1.0
