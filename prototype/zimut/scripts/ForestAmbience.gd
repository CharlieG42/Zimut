class_name ForestAmbience
extends Node2D
## Particules d'ambiance légères, limitées au biome Forêt.
## Elles sont décoratives et n'interagissent jamais avec la grille ou les entités.

const MOTES := 18
var _time := 0.0
var _motes: Array[Dictionary] = []
var _bounds := Vector2(480.0, 300.0)

func configure(grid_size: int, tile_w: float, tile_h: float, active: bool) -> void:
	_bounds = Vector2(float(grid_size) * tile_w * 0.5, float(grid_size) * tile_h * 0.5)
	visible = active
	_motes.clear()
	var rng := RandomNumberGenerator.new()
	rng.seed = 74123
	for i in range(MOTES):
		_motes.append({
			"pos": Vector2(rng.randf_range(-_bounds.x * 0.78, _bounds.x * 0.78), rng.randf_range(30.0, _bounds.y * 1.65)),
			"phase": rng.randf_range(0.0, TAU),
			"speed": rng.randf_range(5.0, 13.0),
			"size": rng.randf_range(1.2, 2.8),
			"leaf": rng.randf() > 0.72
		})
	set_process(active)
	queue_redraw()

func set_forest_active(active: bool) -> void:
	visible = active
	set_process(active)

func _process(delta: float) -> void:
	_time += delta
	for mote in _motes:
		var p: Vector2 = mote["pos"]
		p.y -= delta * float(mote["speed"])
		p.x += sin(_time * 0.8 + float(mote["phase"])) * delta * 7.0
		if p.y < 18.0:
			p.y = _bounds.y * 1.65
			p.x = sin(_time + float(mote["phase"])) * _bounds.x * 0.75
		mote["pos"] = p
	queue_redraw()

func _draw() -> void:
	for mote in _motes:
		var p: Vector2 = mote["pos"]
		var phase: float = float(mote["phase"])
		var alpha: float = 0.25 + 0.25 * (0.5 + 0.5 * sin(_time * 2.0 + phase))
		var col := Color(0.92, 0.96, 0.58, alpha) if not bool(mote["leaf"]) else Color(0.62, 0.88, 0.42, alpha)
		if bool(mote["leaf"]):
			draw_set_transform(p, sin(_time + phase) * 0.5, Vector2(1.0, 0.65))
			draw_circle(Vector2.ZERO, float(mote["size"]) * 1.6, col)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		else:
			draw_circle(p, float(mote["size"]), col)
