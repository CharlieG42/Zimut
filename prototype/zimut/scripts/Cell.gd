extends Node2D
class_name Cell
## Cell.gd - Cellule isométrique style Zoe pour Zimut
## Utilise des sprites pour les tuiles, tout en conservant la perspective et les overlays

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
	add_child(tile_sprite)
	
	# Créer le sprite pour l'entité
	entity_sprite = Sprite2D.new()
	entity_sprite.position = HALF
	entity_sprite.z_index = 10
	entity_sprite.visible = false
	add_child(entity_sprite)
	
	# Charger la texture de la tuile
	_load_tile_sprite()


func _load_tile_sprite():
	# Alterner entre deux types de tuiles (herbe/dirt)
	var is_grass = (grid_position.x + grid_position.y) % 2 == 0
	var texture_path = SPRITE_PATH_TILES + ("grass" if is_grass else "dirt") + SPRITE_EXTENSION
	
	if ResourceLoader.exists(texture_path):
		tile_sprite.texture = load(texture_path)
		# Ajuster la taille
		if tile_sprite.texture:
			var tex_size = tile_sprite.texture.get_size()
			var scale_x = float(CELL_SIZE.x) / tex_size.x
			var scale_y = float(CELL_SIZE.y) / tex_size.y
			tile_sprite.scale = Vector2(scale_x, scale_y)


func _draw():
	# On garde _draw uniquement pour les overlays (sélection, portée, etc.)
	var w = float(CELL_SIZE.x)
	var h = float(CELL_SIZE.y)
	var hw = w / 2.0
	var hh = h / 2.0
	
	var main_points = PackedVector2Array([
		Vector2(0, hh), Vector2(hw, 0), Vector2(w, hh), Vector2(hw, h)
	])

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
		# Double contour intérieur
		_draw_outline(PackedVector2Array([Vector2(hw*0.12,hh), Vector2(hw,hh*0.12), Vector2(w-hw*0.12,hh), Vector2(hw,hh*1.88)]), Color(1.0,1.0,0.6,0.5), 1.2)

	if highlighted:
		_draw_outline(PackedVector2Array([Vector2(hw*0.03,hh), Vector2(hw,hh*0.03), Vector2(w-hw*0.03,hh), Vector2(hw,hh*1.97)]), HIGHLIGHT_COLOR, 3.0)

	if entity:
		_draw_entity(HALF.x, HALF.y)
		_draw_health_bar(HALF, hw, hh)


# ========== FONCTIONS MANQUANTES AJOUTÉES ==========

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
			entity_sprite.scale = Vector2(scale_f, scale_f)
			entity_sprite.position = Vector2(HALF.x, HALF.y - tex_size.y * scale_f * 0.5 + HALF.y * 0.05)
			return true

	return false

## Dessiner l'entité géométriquement (si pas de sprite)
func _draw_entity_geometric(center, entity_type, classe, is_active, color, hw, hh):
	# Ombre portée
	_draw_ellipse(center + Vector2(0, hh*0.14), Vector2(hw*0.35, hh*0.12), Color(0, 0, 0, 0.35))

	if entity_type == "Player":
		var num_pts = 32
		var pts = PackedVector2Array()
		var cols = PackedColorArray()
		for i in range(num_pts + 1):
			var angle = i * TAU / num_pts
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
		# Triangle pour les ennemis
		var tri = PackedVector2Array([
			center + Vector2(-hw*0.38, -hh*0.28),
			center + Vector2(hw*0.38, -hh*0.28),
			center + Vector2(0, hh*0.42),
		])
		draw_polygon(tri, PackedColorArray([color, color, color]))
		for i in range(tri.size()):
			draw_line(tri[i], tri[(i + 1) % tri.size()], Color.RED, 2.0, true)

## Dessiner la barre de vie
func _draw_health_bar(center, hw, hh):
	var max_pv = float(entity.get("max_pv", entity.get("current_pv", 1)))
	var cur_pv = float(entity.get("current_pv", 0))
	if max_pv <= 0:
		return
	var ratio = clampf(cur_pv / max_pv, 0.0, 1.0)
	var bar_w = hw * 0.65
	var bar_h = hh * 0.12
	var bar_pos = center + Vector2(-bar_w * 0.5, hh * 0.52)

	draw_rect(Rect2(bar_pos, Vector2(bar_w, bar_h)), Color(0, 0, 0, 0.7), true)
	var fill_color = Color(0.2, 0.9, 0.2)
	if ratio < 0.5:
		fill_color = Color(0.95, 0.75, 0.1)
	if ratio < 0.25:
		fill_color = Color(0.95, 0.15, 0.1)
	draw_rect(Rect2(bar_pos, Vector2(bar_w * ratio, bar_h)), fill_color, true)
	draw_rect(Rect2(bar_pos, Vector2(bar_w, bar_h)), Color(1, 1, 1, 0.35), false)

## Dessiner une ellipse
func _draw_ellipse(center, radius, color, steps = 20):
	var pts = PackedVector2Array()
	var cols = PackedColorArray()
	for i in range(steps):
		var a = TAU * float(i) / float(steps)
		pts.append(center + Vector2(cos(a) * radius.x, sin(a) * radius.y))
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