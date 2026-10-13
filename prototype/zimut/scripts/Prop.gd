class_name Prop
extends Node2D
## Obstacles et végétation du terrain. L'origine est au pied de l'objet.

var kind: String = "tree"
var seed_value: int = 0
var _sway: float = 0.0
var biome: String = "Forêt"
var _rock_sprite: Sprite2D = null
var _tree_sprite: Sprite2D = null

func setup(k: String, cell: Vector2i, b: String = "Forêt") -> void:
	kind = k
	biome = b
	seed_value = cell.x * 31 + cell.y * 57
	_sway = float(seed_value % 10) * 0.6
	set_process(kind == "tree")
	if kind == "tree" and biome == "Forêt":
		var tree_texture := load("res://assets/sprites/objects/forest_tree.svg") as Texture2D
		if tree_texture != null:
			_tree_sprite = Sprite2D.new()
			_tree_sprite.texture = tree_texture
			_tree_sprite.position = Vector2(0, -88)
			_tree_sprite.z_index = 0
			add_child(_tree_sprite)
	elif kind != "tree":
		var rock_texture := load("res://assets/sprites/objects/forest_boulder.svg") as Texture2D
		if rock_texture != null:
			_rock_sprite = Sprite2D.new()
			_rock_sprite.texture = rock_texture
			_rock_sprite.position = Vector2(0, -42)
			_rock_sprite.z_index = 0
			add_child(_rock_sprite)

func _process(_delta: float) -> void:
	if _tree_sprite != null:
		var t := float(Time.get_ticks_msec()) / 1000.0
		_tree_sprite.rotation = sin(t * 1.3 + _sway) * 0.012
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
		_ellipse_shadow(38.0 * s, 15.0 * s, 0.32)
		if _tree_sprite != null:
			return
		var t: float = float(Time.get_ticks_msec()) / 1000.0
		var sway: float = sin(t * 1.3 + _sway) * 1.6
		if biome == "Désert":
			var cac: Color = Color(0.30, 0.55, 0.28)
			draw_colored_polygon(PackedVector2Array([Vector2(-12, 6), Vector2(-9, -76 * s), Vector2(9, -76 * s), Vector2(12, 6)]), cac)
			draw_colored_polygon(PackedVector2Array([Vector2(-12, 6), Vector2(-9, -76 * s), Vector2(-2, -76 * s), Vector2(-3, 6)]), cac.lightened(0.14))
			draw_colored_polygon(PackedVector2Array([Vector2(-12, -30 * s), Vector2(-12, -48 * s), Vector2(-26, -48 * s), Vector2(-26, -38 * s), Vector2(-22, -38 * s), Vector2(-22, -30 * s)]), cac)
			draw_colored_polygon(PackedVector2Array([Vector2(12, -22 * s), Vector2(12, -56 * s), Vector2(26, -56 * s), Vector2(26, -46 * s), Vector2(22, -46 * s), Vector2(22, -22 * s)]), cac)
		else:
			draw_colored_polygon(PackedVector2Array([Vector2(-7, 6), Vector2(-5, -52 * s), Vector2(5, -52 * s), Vector2(8, 6)]), Color(0.38, 0.24, 0.13))
			var base_col: Color = Color(0.34, 0.62, 0.25) if biome != "Montagne" else Color(0.22, 0.45, 0.30)
			var blobs: Array = [[Vector2(-24 + sway * 0.5, -62 * s), 27.0], [Vector2(24 + sway * 0.5, -62 * s), 27.0], [Vector2(sway, -80 * s), 34.0], [Vector2(-12 + sway, -98 * s), 24.0], [Vector2(14 + sway, -96 * s), 22.0]]
			for blob: Array in blobs:
				draw_circle(blob[0], blob[1], base_col.darkened(0.12))
			for blob: Array in blobs:
				draw_circle(blob[0] + Vector2(-3, -4), blob[1] * 0.86, base_col)
			for blob: Array in blobs:
				draw_circle(blob[0] + Vector2(-9, -11), blob[1] * 0.45, base_col.lightened(0.22))
	else:
		_ellipse_shadow(40.0 * s, 15.0 * s, 0.30)
		if _rock_sprite == null:
			var pts := PackedVector2Array([Vector2(-36, 6), Vector2(-30, -22), Vector2(-10, -42 * s), Vector2(16, -38 * s), Vector2(36, -14), Vector2(32, 6), Vector2(0, 12)])
			draw_colored_polygon(pts, Color(0.5, 0.51, 0.56))
			draw_colored_polygon(PackedVector2Array([Vector2(-30, -22), Vector2(-10, -42 * s), Vector2(0, -20), Vector2(-14, 0), Vector2(-36, 6)]), Color(0.68, 0.70, 0.75))
			draw_colored_polygon(PackedVector2Array([Vector2(16, -38 * s), Vector2(36, -14), Vector2(32, 6), Vector2(8, 4), Vector2(0, -20)]), Color(0.38, 0.39, 0.44))
			draw_circle(Vector2(-18, -18), 7.0, Color(0.3, 0.55, 0.25, 0.9))
			draw_circle(Vector2(-12, -22), 4.0, Color(0.38, 0.62, 0.3, 0.9))
