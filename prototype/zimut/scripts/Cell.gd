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



