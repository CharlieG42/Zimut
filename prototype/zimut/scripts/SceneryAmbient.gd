class_name SceneryAmbient
extends Node2D
## SceneryAmbient.gd — Particules d'ambiance au-dessus du plateau, selon le biome :
## lucioles et pollen (Forêt, en plus des feuilles de ForestAmbience), neige (Montagne),
## poussière chaude (Désert), braises (Donjon). Purement décoratif, très léger.

var _biome: String = "Forêt"
var _parts: Array[Dictionary] = []
var _t: float = 0.0
var _span: Vector2 = Vector2(560.0, 360.0)


func configure(grid_size: int, biome: String, seed_value: int = 1) -> void:
	_biome = biome
	_span = Vector2(float(grid_size) * BattleScenery.HW * 0.95, float(grid_size) * BattleScenery.HH * 1.5)
	_parts.clear()
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value * 61 + 3
	var count: int = 34
	for i: int in range(count):
		_parts.append({
			"x": rng.randf_range(-_span.x, _span.x), "y": rng.randf_range(-120.0, _span.y),
			"v": rng.randf_range(8.0, 26.0), "ph": rng.randf() * TAU, "r": rng.randf_range(1.2, 3.2),
		})
	set_process(true)
	queue_redraw()


func _process(delta: float) -> void:
	_t += delta
	for pt: Dictionary in _parts:
		match _biome:
			"Montagne":
				pt["y"] = float(pt["y"]) + delta * float(pt["v"]) * 1.4
				pt["x"] = float(pt["x"]) + sin(_t * 0.7 + float(pt["ph"])) * delta * 12.0 + delta * 6.0
				if float(pt["y"]) > _span.y:
					pt["y"] = -140.0
			"Désert":
				pt["x"] = float(pt["x"]) + delta * float(pt["v"]) * 1.8
				pt["y"] = float(pt["y"]) + sin(_t + float(pt["ph"])) * delta * 8.0
				if float(pt["x"]) > _span.x:
					pt["x"] = -_span.x
			"Donjon":
				pt["y"] = float(pt["y"]) - delta * float(pt["v"]) * 1.6
				pt["x"] = float(pt["x"]) + sin(_t * 1.3 + float(pt["ph"])) * delta * 10.0
				if float(pt["y"]) < -140.0:
					pt["y"] = _span.y
			_:
				pt["y"] = float(pt["y"]) - delta * float(pt["v"]) * 0.5
				pt["x"] = float(pt["x"]) + sin(_t * 0.6 + float(pt["ph"])) * delta * 9.0
				if float(pt["y"]) < -140.0:
					pt["y"] = _span.y
	queue_redraw()


func _draw() -> void:
	for pt: Dictionary in _parts:
		var c := Vector2(float(pt["x"]), float(pt["y"]))
		var r: float = float(pt["r"])
		var tw: float = 0.5 + 0.5 * sin(_t * 2.2 + float(pt["ph"]))
		match _biome:
			"Montagne":
				draw_circle(c, r, Color(1, 1, 1, 0.85))
			"Désert":
				draw_circle(c, r * 0.8, Color(0.95, 0.82, 0.55, 0.35))
			"Donjon":
				draw_circle(c, r * 2.2, Color(1.0, 0.5, 0.15, 0.10 * tw))
				draw_circle(c, r * 0.9, Color(1.0, 0.7, 0.3, 0.45 + 0.4 * tw))
			_:
				# lucioles douces
				draw_circle(c, r * 3.2, Color(1.0, 0.95, 0.55, 0.07 + 0.08 * tw))
				draw_circle(c, r * 0.9, Color(1.0, 0.97, 0.7, 0.35 + 0.5 * tw))
