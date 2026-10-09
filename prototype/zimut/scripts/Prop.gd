class_name Prop
extends Node2D
## Prop.gd — Obstacles du terrain (arbres, rochers) dessinés par code.
## L'origine est au pied de l'objet, au centre de la case.

var kind: String = "tree"
var seed_value: int = 0
var _sway: float = 0.0


func setup(k: String, cell: Vector2i) -> void:
	kind = k
	seed_value = cell.x * 31 + cell.y * 57
	_sway = float(seed_value % 10) * 0.6
	set_process(kind == "tree")


func _process(_delta: float) -> void:
	queue_redraw()


func _ellipse_shadow(rx: float, ry: float, alpha: float) -> void:
	draw_set_transform(Vector2(0, 4), 0.0, Vector2(1.0, ry / rx))
	draw_circle(Vector2.ZERO, rx, Color(0, 0, 0, alpha))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _draw() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value + 3
	var s: float = rng.randf_range(0.92, 1.1)
	if kind == "tree":
		var t: float = float(Time.get_ticks_msec()) / 1000.0
		var sway: float = sin(t * 1.3 + _sway) * 1.6
		_ellipse_shadow(38.0 * s, 15.0 * s, 0.32)
		# tronc
		draw_colored_polygon(PackedVector2Array([Vector2(-7, 6), Vector2(-5, -52 * s), Vector2(5, -52 * s), Vector2(8, 6)]), Color(0.38, 0.24, 0.13))
		draw_colored_polygon(PackedVector2Array([Vector2(-7, 6), Vector2(-5, -52 * s), Vector2(-1, -52 * s), Vector2(-2, 6)]), Color(0.5, 0.33, 0.18))
		# feuillage
		var base_col: Color = Color(0.34, 0.62, 0.25)
		var blobs: Array = [
			[Vector2(-24 + sway * 0.5, -62 * s), 27.0], [Vector2(24 + sway * 0.5, -62 * s), 27.0],
			[Vector2(0 + sway, -80 * s), 34.0], [Vector2(-12 + sway, -98 * s), 24.0], [Vector2(14 + sway, -96 * s), 22.0],
		]
		for b: Array in blobs:
			draw_circle(b[0], b[1], base_col.darkened(0.12))
		for b: Array in blobs:
			draw_circle(b[0] + Vector2(-3, -4), b[1] * 0.86, base_col)
		for b: Array in blobs:
			draw_circle(b[0] + Vector2(-9, -11), b[1] * 0.45, base_col.lightened(0.22))
	else:
		_ellipse_shadow(40.0 * s, 15.0 * s, 0.30)
		var pts := PackedVector2Array([
			Vector2(-36, 6), Vector2(-30, -22), Vector2(-10, -42 * s), Vector2(16, -38 * s), Vector2(36, -14), Vector2(32, 6), Vector2(0, 12)
		])
		draw_colored_polygon(pts, Color(0.5, 0.51, 0.56))
		draw_colored_polygon(PackedVector2Array([Vector2(-30, -22), Vector2(-10, -42 * s), Vector2(0, -20), Vector2(-14, 0), Vector2(-36, 6)]), Color(0.68, 0.70, 0.75))
		draw_colored_polygon(PackedVector2Array([Vector2(16, -38 * s), Vector2(36, -14), Vector2(32, 6), Vector2(8, 4), Vector2(0, -20)]), Color(0.38, 0.39, 0.44))
		draw_polyline(PackedVector2Array([Vector2(-10, -42 * s), Vector2(0, -20), Vector2(8, 4)]), Color(0, 0, 0, 0.25), 1.6)
		draw_circle(Vector2(-18, -18), 7.0, Color(0.3, 0.55, 0.25, 0.9))
		draw_circle(Vector2(-12, -22), 4.0, Color(0.38, 0.62, 0.3, 0.9))
