class_name SceneryOver
extends Node2D
## SceneryOver.gd — Lèvre de l'île devant les falaises avant : touffes d'herbe (ou neige, sable,
## mousse selon le biome) qui débordent sur le bord, fleurs, cailloux et lianes/racines/glaçons
## qui pendent le long de la falaise. Dessiné après les cases, avant les unités.

var _n: int = 8
var _biome: String = "Forêt"
var _seed: int = 1
var _t: float = 0.0
var _vines: Array[Dictionary] = []


func configure(grid_size: int, biome: String, seed_value: int = 1) -> void:
	_n = grid_size
	_biome = biome
	_seed = seed_value
	_vines.clear()
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value * 977 + 5
	var left_v: Vector2 = BattleScenery.gts(0, _n - 1) + Vector2(-BattleScenery.HW, 0)
	var bottom_v: Vector2 = BattleScenery.gts(_n - 1, _n - 1) + Vector2(0, BattleScenery.HH)
	var right_v: Vector2 = BattleScenery.gts(_n - 1, 0) + Vector2(BattleScenery.HW, 0)
	for i: int in range(7):
		var on_left: bool = i % 2 == 0
		var f: float = rng.randf_range(0.08, 0.92)
		var base: Vector2 = left_v.lerp(bottom_v, f) if on_left else bottom_v.lerp(right_v, f)
		_vines.append({"p": base + Vector2(0, 5), "len": rng.randf_range(34.0, 100.0), "ph": rng.randf() * TAU,
			"left": on_left, "leaves": rng.randi_range(2, 5)})
	set_process(true)
	queue_redraw()


func _process(delta: float) -> void:
	_t += delta
	queue_redraw()


func _draw() -> void:
	var p: Dictionary = BattleScenery.pal(_biome)
	var left_v: Vector2 = BattleScenery.gts(0, _n - 1) + Vector2(-BattleScenery.HW, 0)
	var bottom_v: Vector2 = BattleScenery.gts(_n - 1, _n - 1) + Vector2(0, BattleScenery.HH)
	var right_v: Vector2 = BattleScenery.gts(_n - 1, 0) + Vector2(BattleScenery.HW, 0)
	var rng := RandomNumberGenerator.new()
	rng.seed = _seed * 53 + 7
	var leaf: Color = p["leaf"]
	var leaf_hi: Color = p["leaf_hi"]
	var lip: Color = p["lip"]
	# Touffes et cailloux le long du bord supérieur des deux falaises avant
	for seg: int in range(2):
		var a: Vector2 = left_v if seg == 0 else bottom_v
		var b: Vector2 = bottom_v if seg == 0 else right_v
		var count: int = 34
		for i: int in range(count):
			var f: float = (float(i) + rng.randf_range(0.1, 0.9)) / float(count)
			var pt: Vector2 = a.lerp(b, f) + Vector2(0, rng.randf_range(-1.0, 5.0))
			var kind: float = rng.randf()
			match _biome:
				"Montagne":
					draw_circle(pt + Vector2(0, 2), rng.randf_range(3.0, 6.0), Color(0.93, 0.96, 1.0, 0.95))
				"Désert":
					if kind < 0.7:
						draw_circle(pt + Vector2(0, 2), rng.randf_range(3.0, 5.5), lip.lightened(0.05))
					else:
						draw_circle(pt, rng.randf_range(2.0, 3.6), Color(0.62, 0.46, 0.30))
				"Donjon":
					if kind < 0.6:
						draw_circle(pt + Vector2(0, 2), rng.randf_range(2.5, 4.5), Color(0.30, 0.42, 0.34, 0.9))
					else:
						draw_circle(pt, rng.randf_range(2.0, 3.4), Color(0.52, 0.50, 0.60))
				_:
					var sway: float = sin(_t * 1.6 + float(i) * 0.7) * 1.4
					var h: float = rng.randf_range(6.0, 13.0)
					draw_line(pt, pt + Vector2(sway - 2.0, -h), leaf, 2.4, true)
					draw_line(pt + Vector2(3, 0), pt + Vector2(3 + sway, -h * 0.8), leaf_hi, 2.0, true)
					if kind > 0.9:
						draw_circle(pt + Vector2(sway, -h - 1.0), 2.6, Color(1.0, 0.92, 0.5) if kind > 0.95 else Color(1, 1, 1))
	# Lianes / racines / glaçons qui pendent
	for v: Dictionary in _vines:
		var base: Vector2 = v["p"]
		var length: float = float(v["len"])
		var sway2: float = sin(_t * 1.1 + float(v["ph"])) * 3.0
		var pts := PackedVector2Array()
		for k: int in range(7):
			var ff: float = float(k) / 6.0
			pts.append(base + Vector2(sway2 * ff * ff + sin(ff * 4.0 + float(v["ph"])) * 2.0, length * ff))
		match _biome:
			"Montagne":
				draw_colored_polygon(PackedVector2Array([base + Vector2(-4, 0), base + Vector2(4, 0), base + Vector2(0, length * 0.55)]), Color(0.78, 0.92, 1.0, 0.9))
			"Donjon":
				draw_polyline(pts, Color(0.5, 0.5, 0.58), 3.0, true)
				draw_circle(pts[pts.size() - 1], 3.4, Color(0.4, 0.4, 0.48))
			"Désert":
				draw_polyline(pts, Color(0.36, 0.26, 0.17), 3.0, true)
			_:
				draw_polyline(pts, Color(0.12, 0.26, 0.10, 0.9), 4.2, true)
				draw_polyline(pts, leaf.darkened(0.05), 2.4, true)
				for k: int in range(int(v["leaves"])):
					var lp: Vector2 = pts[1 + k]
					var side: float = -1.0 if k % 2 == 0 else 1.0
					draw_colored_polygon(PackedVector2Array([lp, lp + Vector2(side * 9.0, -3.0), lp + Vector2(side * 13.0, 3.0), lp + Vector2(side * 5.0, 4.0)]), leaf_hi)
