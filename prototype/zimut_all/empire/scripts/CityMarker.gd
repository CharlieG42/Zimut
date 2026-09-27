extends Node2D
## CityMarker.gd - Pictogramme de ville sur la carte monde Empire.
## Dessine un drapeau colore selon le proprietaire + nom de la ville.

const FLAG_COLORS := {
	"player": Color(0.15, 0.55, 0.95),
	"neutral": Color(0.75, 0.75, 0.75),
	"ai": Color(0.9, 0.2, 0.2),
}

var city: Dictionary = {}
var empire_manager: Node = null
var label: Label

func setup(city_data: Dictionary, manager: Node) -> void:
	city = city_data
	empire_manager = manager
	queue_redraw()
	if label == null:
		label = Label.new()
		label.add_theme_font_size_override("font_size", 26)
		label.add_theme_color_override("font_color", Color.WHITE)
		label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.85))
		label.add_theme_constant_override("outline_size", 8)
		label.position = Vector2(-80, -96)
		label.size = Vector2(160, 32)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		add_child(label)
	label.text = str(city.get("name", "?"))

func _owner_key() -> String:
	match city.get("owner", ""):
		"player":
			return "player"
		"neutral":
			return "neutral"
		"ai":
			return "ai"
	return "neutral"

func _draw() -> void:
	if city.is_empty():
		return
	var color: Color = FLAG_COLORS.get(_owner_key(), Color.GRAY)
	# Socle ellipse (ombre)
	var pts := PackedVector2Array()
	var cols := PackedColorArray()
	for i: int in range(20):
		var a: float = TAU * float(i) / 20.0
		pts.append(Vector2(cos(a) * 34.0, sin(a) * 13.0))
		cols.append(Color(0, 0, 0, 0.35))
	draw_polygon(pts, cols)
	# Mast du drapeau
	draw_line(Vector2(0, 0), Vector2(0, -64), Color(0.25, 0.16, 0.08), 5.0)
	# Drapeau triangulaire
	var flag := PackedVector2Array([Vector2(0, -64), Vector2(48, -50), Vector2(0, -36)])
	draw_polygon(flag, PackedColorArray([color, color, color]))
	draw_line(Vector2(0, -64), Vector2(48, -50), Color(1, 1, 1, 0.6), 2.0)
	draw_line(Vector2(48, -50), Vector2(0, -36), Color(1, 1, 1, 0.6), 2.0)
	# Niveau de la ville (points)
	var level: int = int(city.get("level", 1))
	for i: int in range(level):
		draw_circle(Vector2(-18 + i * 18, -78), 4.0, Color(1.0, 0.85, 0.2))
