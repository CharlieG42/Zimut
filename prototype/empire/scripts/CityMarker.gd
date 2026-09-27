extends Node2D
## CityMarker.gd - Pictogramme de ville sur la carte monde Empire.
## Sprite genere (batiment selon type + toit/banniere couleur proprietaire),
## avec fallback dessin vectoriel si l'asset est absent.

const CITY_TYPE_CAPITAL := "capital"
const CITY_TYPE_VILLAGE := "village"
const CITY_TYPE_FORTRESS := "fortress"

const SPRITE_PATH := "res://assets/sprites/cities/"

var city: Dictionary = {}
var empire_manager: Node = null
var sprite: Sprite2D
var label: Label

func _init() -> void:
	sprite = Sprite2D.new()
	sprite.centered = true
	add_child(sprite)

func setup(city_data: Dictionary, manager: Node) -> void:
	city = city_data
	empire_manager = manager
	_load_sprite()
	_ensure_label()
	label.text = str(city.get("name", "?"))
	queue_redraw()

## Chemin du sprite: type de ville + proprietaire.
func _sprite_path() -> String:
	var kind: String = CITY_TYPE_VILLAGE
	match str(city.get("type", "")):
		"capital":
			kind = CITY_TYPE_CAPITAL
		"fortress":
			kind = CITY_TYPE_FORTRESS
		_:
			kind = CITY_TYPE_VILLAGE
	return SPRITE_PATH + kind + "_" + _owner_key() + ".png"

func _load_sprite() -> void:
	var path: String = _sprite_path()
	if ResourceLoader.exists(path):
		var tex: Resource = load(path)
		if tex is Texture2D:
			sprite.texture = tex
			# Pied de la ville pose sur la tuile
			var target_h: float = 190.0 if str(city.get("type", "")) == "capital" else 160.0
			var scale_f: float = target_h / tex.get_size().y
			sprite.scale = Vector2(scale_f, scale_f)
			sprite.position = Vector2(0.0, -tex.get_size().y * scale_f * 0.5 + 8.0)
			sprite.visible = true
			return
	# Fallback: dessin vectoriel (drapeau)
	sprite.visible = false
	queue_redraw()

func _ensure_label() -> void:
	if label == null:
		label = Label.new()
		label.add_theme_font_size_override("font_size", 24)
		label.add_theme_color_override("font_color", Color.WHITE)
		label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
		label.add_theme_constant_override("outline_size", 10)
		label.position = Vector2(-110, -150)
		label.size = Vector2(220, 34)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		add_child(label)

func _owner_key() -> String:
	match str(city.get("owner", "")):
		"player":
			return "player"
		"ai":
			return "ai"
	return "neutral"

## Couleur proprietaire (fallback vectoriel + points de niveau).
func _owner_color() -> Color:
	match _owner_key():
		"player":
			return Color(0.15, 0.45, 0.9)
		"ai":
			return Color(0.85, 0.2, 0.2)
	return Color(0.7, 0.7, 0.7)

func _draw() -> void:
	if city.is_empty():
		return
	var level: int = int(city.get("level", 1))
	# Points de niveau sous le nom
	for i: int in range(level):
		draw_circle(Vector2(-18 + i * 18, -162), 5.0, Color(1.0, 0.85, 0.25))
	if sprite.visible:
		return
	# Fallback vectoriel: socle + drapeau
	draw_set_transform(Vector2(0, 8), 0.0, Vector2(1, 0.5))
	draw_circle(Vector2(0, 0), 30.0, Color(0, 0, 0, 0.3))
	draw_set_transform(Vector2.ZERO)
	var color: Color = _owner_color()
	draw_line(Vector2(0, 6), Vector2(0, -70), Color(0.25, 0.16, 0.08), 6.0)
	var flag := PackedVector2Array([Vector2(0, -70), Vector2(52, -54), Vector2(0, -38)])
	draw_polygon(flag, PackedColorArray([color, color, color]))
