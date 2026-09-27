extends Node2D
## BuildingIcon.gd - Pictogramme de batiment dans la vue ville.
## Maison simple avec toit colore selon le type de production.

const ROOF_COLORS := {
	"fer": Color(0.55, 0.55, 0.62),
	"bois": Color(0.55, 0.35, 0.15),
	"or": Color(0.9, 0.75, 0.2),
	"": Color(0.5, 0.5, 0.55),
}

var building: Dictionary = {}

func setup(data: Dictionary) -> void:
	building = data
	queue_redraw()

func _draw() -> void:
	if building.is_empty():
		return
	var roof: Color = ROOF_COLORS.get(str(building.get("produces", "")), Color(0.5, 0.5, 0.55))
	# Ombre
	var pts := PackedVector2Array()
	var cols := PackedColorArray()
	for i: int in range(18):
		var a: float = TAU * float(i) / 18.0
		pts.append(Vector2(cos(a) * 26.0, sin(a) * 10.0))
		cols.append(Color(0, 0, 0, 0.35))
	draw_polygon(pts, cols)
	# Corps (mur)
	draw_rect(Rect2(-18, -34, 36, 30), Color(0.82, 0.72, 0.55))
	draw_rect(Rect2(-18, -34, 36, 30), Color(0.35, 0.28, 0.18), false, 2.0)
	# Toit
	var roof_pts := PackedVector2Array([
		Vector2(-24, -34), Vector2(0, -56), Vector2(24, -34),
	])
	draw_polygon(roof_pts, PackedColorArray([roof, roof, roof]))
	draw_line(Vector2(-24, -34), Vector2(0, -56), Color(0.2, 0.15, 0.1), 2.0)
	draw_line(Vector2(0, -56), Vector2(24, -34), Color(0.2, 0.15, 0.1), 2.0)
	# Porte
	draw_rect(Rect2(-6, -16, 12, 12), Color(0.3, 0.2, 0.1))
