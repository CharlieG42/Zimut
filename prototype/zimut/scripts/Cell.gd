extends Node2D
class_name Cell
## Cell.gd - Cellule isométrique style Zoe pour Zimut
## Utilise des sprites pour les tuiles avec rotation -45° pour perspective isométrique

const CELL_SIZE = Vector2i(140, 140)
const HALF = Vector2(70, 70)

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
	# Créer le sprite pour la tuile
	tile_sprite = Sprite2D.new()
	tile_sprite.position = Vector2(CELL_SIZE.x / 2, CELL_SIZE.y / 2)
	tile_sprite.z_index = 0
	# APPLIQUER ROTATION ISO -45° ET SCALE POUR PERSPECTIVE
	tile_sprite.rotation_degrees = -45.0
	tile_sprite.scale = Vector2(1.41, 0.71)  # sqrt(2) * 1.0 pour Y, 0.5*1.41 pour compression
	add_child(tile_sprite)
	
	# Créer le sprite pour l'entité
	entity_sprite = Sprite2D.new()
	entity_sprite.position = HALF
	entity_sprite.z_index = 10
	entity_sprite.visible = false
	# APPLIQUER LA MÊME TRANSFORMATION
	entity_sprite.rotation_degrees = -45.0
	entity_sprite.scale = Vector2(1.41, 0.71)
	add_child(entity_sprite)
	
	# Charger la texture de la tuile
	_load_tile_sprite()


func _load_tile_sprite():
	# Alterner entre deux types de tuiles (herbe/dirt)
	var is_grass = (grid_position.x + grid_position.y) % 2 == 0
	var texture_path = SPRITE_PATH_TILES + ("grass" if is_grass else "dirt") + SPRITE_EXTENSION
	
	if ResourceLoader.exists(texture_path):
		tile_sprite.texture = load(texture_path)
		# Ajuster la taille pour remplir la cellule après rotation
		if tile_sprite.texture:
			var tex_size = tile_sprite.texture.get_size()
			# Calculer l'échelle pour compenser rotation et compression
			var base_scale = float(CELL_SIZE.x) / max(tex_size.x, tex_size.y)
			# Après rotation -45°, la largeur effective est multipliée par sqrt(2)/2
			# On compense avec un facteur de sqrt(2) ≈ 1.41
			tile_sprite.scale = Vector2(1.41, 0.71) * base_scale


func _draw():
	# On garde _draw pour les overlays (sélection, portée, etc.)
	# Appliquer rotation -45° aux overlays pour correspondre à la perspective
	var w = float(CELL_SIZE.x)
	var h = float(CELL_SIZE.y)
	var hw = w / 2.0
	var hh = h / 2.0
	var center = Vector2(hw, hh)
	
	# Pré-calculer rotation -45°
	var rotation = deg_to_rad(-45.0)
	var cos_r = cos(rotation)
	var sin_r = sin(rotation)
	
	# Points du polygone principal (losange)
	var local_points = PackedVector2Array([
		Vector2(0, hh), Vector2(hw, 0), Vector2(w, hh), Vector2(hw, h)
	])
	
	# Rotater tous les points de -45° autour du centre
	var main_points = PackedVector2Array()
	for i in range(local_points.size()):
		main_points.append(_rotate_point_around_center(local_points[i], center, rotation))
	
	# Points pour les contours intérieurs (pour sélection)
	var outline_points = PackedVector2Array([
		Vector2(hw*0.04, hh), Vector2(hw, hh*0.04), Vector2(w-hw*0.04, hh), Vector2(hw, hh*1.96)
	])
	var outline_points_rotated = PackedVector2Array()
	for i in range(outline_points.size()):
		outline_points_rotated.append(_rotate_point_around_center(outline_points[i], center, rotation))
	
	# Points pour le double contour intérieur
	var inner_outline_points = PackedVector2Array([
		Vector2(hw*0.12, hh), Vector2(hw, hh*0.12), Vector2(w-hw*0.12, hh), Vector2(hw, hh*1.88)
	])
	var inner_outline_points_rotated = PackedVector2Array()
	for i in range(inner_outline_points.size()):
		inner_outline_points_rotated.append(_rotate_point_around_center(inner_outline_points[i], center, rotation))
	
	# Points pour le highlight
	var highlight_points = PackedVector2Array([
		Vector2(hw*0.03, hh), Vector2(hw, hh*0.03), Vector2(w-hw*0.03, hh), Vector2(hw, hh*1.97)
	])
	var highlight_points_rotated = PackedVector2Array()
	for i in range(highlight_points.size()):
		highlight_points_rotated.append(_rotate_point_around_center(highlight_points[i], center, rotation))

	# Overlays d'état (ordre : portée < sélection < highlight actif)
	if in_spell_range:
		draw_polygon(main_points, _colors4(Color(1.0, 0.3, 0.2, 0.25)))
		_draw_outline(outline_points_rotated, SPELL_RANGE_COLOR, 2.5)
	elif in_move_range:
		draw_polygon(main_points, _colors4(Color(0.2, 0.7, 1.0, 0.22)))
		_draw_outline(outline_points_rotated, MOVE_RANGE_COLOR, 2.5)

	if selected:
		draw_polygon(main_points, _colors4(Color(1.0, 0.84, 0.0, 0.18)))
		_draw_outline(outline_points_rotated, SELECTION_COLOR, 3.0)
		# Double contour intérieur
		_draw_outline(inner_outline_points_rotated, Color(1.0,1.0,0.6,0.5), 1.2)

	if highlighted:
		_draw_outline(highlight_points_rotated, HIGHLIGHT_COLOR, 3.0)

	if entity:
		_draw_entity(hw, hh, center, rotation)
		_draw_health_bar(HALF, hw, hh, center, rotation)


# ========== FONCTIONS MANQUANTES AJOUTÉES ==========

## Rotation d'un point autour d'un centre
func _rotate_point_around_center(p: Vector2, center: Vector2, angle_rad: float) -> Vector2:
	var px = p.x - center.x
	var py = p.y - center.y
	var rx = px * cos(angle_rad) - py * sin(angle_rad)
	var ry = px * sin(angle_rad) + py * cos(angle_rad)
	return Vector2(rx + center.x, ry + center.y)


## Helpers couleurs
func _colors3(c):
	return PackedColorArray([c, c, c])


func _colors4(c):
	return PackedColorArray([c, c, c, c])

## Dessiner un contour
func _draw_outline(points, color, width):
	for i in range(points.size()):
		draw_line(points[i], points[(i + 1) % points.size()], color, width, true)

## Dessiner l'entité (version adaptée pour les sprites)
func _draw_entity(hw, hh, center, rotation):
	var entity_type = entity.get("entity_type", "")
	var classe = entity.get("classe", "")
	var is_active = entity.get("is_active", false)
	var color = GameManager.COLORS.get(classe, Color(0.5, 0.5, 0.5))

	if _try_load_sprite(classe, entity_type):
		entity_sprite.visible = true
		if highlighted or is_active:
			var tip = _rotate_point_around_center(center + Vector2(0, -hh * 0.45), center, rotation)
			var tip_left = _rotate_point_around_center(center + Vector2(-hw*0.1, hh*0.11), center, rotation)
			var tip_right = _rotate_point_around_center(center + Vector2(hw*0.1, hh*0.11), center, rotation)
			draw_line(tip_left, tip, Color(1.0, 1.0, 0.3), 2.5)
			draw_line(tip_right, tip, Color(1.0, 1.0, 0.3), 2.5)
	else:
		entity_sprite.visible = false
		_draw_entity_geometric(center, entity_type, classe, is_active, color, hw, hh, rotation)

## Charger le sprite de l'entité
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
		var texture = load(sprite_path)
		if texture:
			entity_sprite.texture = texture
			var tex_size = entity_sprite.texture.get_size()
			var scale_f = 1.2
			entity_sprite.scale = Vector2(1.41, 0.71) * scale_f
			# Repositionner pour compenser la rotation
			entity_sprite.position = Vector2(HALF.x, HALF.y)
			return true

	return false

## Dessiner l'entité géométriquement (si pas de sprite)
func _draw_entity_geometric(center, entity_type, classe, is_active, color, hw, hh, rotation):
	# Ombre portée (rotée)
	var shadow_center = _rotate_point_around_center(center + Vector2(0, hh*0.14), center, rotation)
	_draw_ellipse_rotated(shadow_center, Vector2(hw*0.35, hh*0.12), Color(0, 0, 0, 0.35), rotation)

	if entity_type == "Player":
		var num_pts = 32
		var pts = PackedVector2Array()
		var cols = PackedColorArray()
		for i in range(num_pts + 1):
			var angle = i * TAU / num_pts
			var point_on_circle = center + Vector2(cos(angle), sin(angle)) * hw * 0.5
			pts.append(_rotate_point_around_center(point_on_circle, center, rotation))
			cols.append(color)
		draw_polygon(pts, cols)
		var border_color = Color.YELLOW if is_active else Color.WHITE
		var border_w = 3.0 if is_active else 2.0
		for i in range(num_pts):
			draw_line(pts[i], pts[i + 1], border_color, border_w, true)
		if highlighted or is_active:
			var tip = _rotate_point_around_center(center + Vector2(0, -hh * 0.55), center, rotation)
			var tip_left = _rotate_point_around_center(center + Vector2(-hw*0.14, hh*0.14), center, rotation)
			var tip_right = _rotate_point_around_center(center + Vector2(hw*0.14, hh*0.14), center, rotation)
			draw_line(tip_left, tip, Color(1.0, 1.0, 0.3), 3.0)
			draw_line(tip_right, tip, Color(1.0, 1.0, 0.3), 3.0)
	else:
		# Triangle pour les ennemis
		var tri = PackedVector2Array([
			center + Vector2(-hw*0.38, -hh*0.28),
			center + Vector2(hw*0.38, -hh*0.28),
			center + Vector2(0, hh*0.42),
		])
		var tri_rotated = PackedVector2Array()
		for i in range(tri.size()):
			tri_rotated.append(_rotate_point_around_center(tri[i], center, rotation))
		draw_polygon(tri_rotated, PackedColorArray([color, color, color]))
		for i in range(tri_rotated.size()):
			draw_line(tri_rotated[i], tri_rotated[(i + 1) % tri_rotated.size()], Color.RED, 2.0, true)

## Dessiner la barre de vie
func _draw_health_bar(center, hw, hh, cell_center, rotation):
	var max_pv = float(entity.get("max_pv", entity.get("current_pv", 1)))
	var cur_pv = float(entity.get("current_pv", 0))
	if max_pv <= 0:
		return
	var ratio = clampf(cur_pv / max_pv, 0.0, 1.0)
	var bar_w = hw * 0.65
	var bar_h = hh * 0.12
	
	# Positionner la barre de vie au-dessus de l'entité (rotée)
	var bar_center = _rotate_point_around_center(center + Vector2(0, -hh * 0.45), cell_center, rotation)
	var bar_pos = bar_center + Vector2(-bar_w * 0.5, -bar_h * 0.5)
	
	# Dessiner la barre (non rotée pour rester lisible)
	draw_rect(Rect2(bar_pos, Vector2(bar_w, bar_h)), Color(0, 0, 0, 0.7), true)
	var fill_color = Color(0.2, 0.9, 0.2)
	if ratio < 0.5:
		fill_color = Color(0.95, 0.75, 0.1)
	if ratio < 0.25:
		fill_color = Color(0.95, 0.15, 0.1)
	draw_rect(Rect2(bar_pos, Vector2(bar_w * ratio, bar_h)), fill_color, true)
	draw_rect(Rect2(bar_pos, Vector2(bar_w, bar_h)), Color(1, 1, 1, 0.35), false)

## Dessiner une ellipse (pour ombres)
func _draw_ellipse(center, radius, color, steps = 20):
	var pts = PackedVector2Array()
	var cols = PackedColorArray()
	for i in range(steps):
		var a = TAU * float(i) / float(steps)
		pts.append(center + Vector2(cos(a) * radius.x, sin(a) * radius.y))
		cols.append(color)
	draw_polygon(pts, cols)

## Dessiner une ellipse rotée
func _draw_ellipse_rotated(center, radius, color, rotation_angle, steps = 20):
	var pts = PackedVector2Array()
	var cols = PackedColorArray()
	for i in range(steps):
		var a = TAU * float(i) / float(steps)
		var px = cos(a) * radius.x
		var py = sin(a) * radius.y
		# Rotater le point
		var rx = px * cos(rotation_angle) - py * sin(rotation_angle)
		var ry = px * sin(rotation_angle) + py * cos(rotation_angle)
		pts.append(center + Vector2(rx, ry))
		cols.append(color)
	draw_polygon(pts, cols)

# ========== FIN DES FONCTIONS MANQUANTES ==========

func update_appearance():
	queue_redraw()
	if entity != null:
		var entity_type = entity.get("entity_type", "")
		var classe = entity.get("classe", "")
		_try_load_sprite(classe, entity_type)
		entity_sprite.visible = _try_load_sprite(classe, entity_type)
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