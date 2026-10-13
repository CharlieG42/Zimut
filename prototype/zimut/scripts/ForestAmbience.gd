class_name ForestAmbience
extends Node2D
## Particules d'ambiance légères, limitées au biome Forêt.
## Elles sont décoratives et n'interagissent jamais avec la grille ou les entités.

const MOTES := 18
var _time := 0.0
var _motes: Array[Dictionary] = []
var _bounds := Vector2(480.0, 300.0)

func configure(grid_size: int, tile_w: float, tile_h: float, active: bool) -> void:
	# Demi-emprise réelle du plateau projeté (pas grid_size × une tuile) :
	# les décors de bord restent juste à l’extérieur du losange jouable.
	_bounds = Vector2(float(grid_size - 1) * tile_w * 0.5, float(grid_size - 1) * tile_h * 0.5)
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

## Habillage discret du cadre : décor dans les marges, jamais sur les cases.
## Les formes sont dessinées dans le repère de la grille et restent non interactives.
func _draw_forest_frame() -> void:
	var side_x: float = _bounds.x + 56.0
	var top_y: float = 4.0
	for side: int in [-1, 1]:
		var anchor := Vector2(float(side) * side_x, top_y)
		# Brume froide et douce derrière les feuilles.
		draw_circle(anchor + Vector2(-float(side) * 10.0, 54.0), 68.0, Color(0.12, 0.30, 0.27, 0.12))
		draw_circle(anchor + Vector2(float(side) * 4.0, 104.0), 48.0, Color(0.18, 0.38, 0.29, 0.10))
		# Deux branches courbes entrent depuis les bords supérieurs.
		var branch_start := anchor + Vector2(float(side) * 92.0, -24.0)
		var branch_mid := anchor + Vector2(float(side) * 43.0, 18.0)
		var branch_end := anchor + Vector2(-float(side) * 22.0, 72.0)
		draw_line(branch_start, branch_mid, Color(0.22, 0.18, 0.12, 0.82), 13.0, true)
		draw_line(branch_mid, branch_end, Color(0.30, 0.23, 0.14, 0.86), 10.0, true)
		# Feuillage en bouquets irréguliers : contours sombres et reflets doux.
		var clusters: Array = [
			[Vector2(float(side) * 70.0, 4.0), 35.0],
			[Vector2(float(side) * 34.0, 30.0), 30.0],
			[Vector2(-float(side) * 5.0, 65.0), 25.0],
			[Vector2(float(side) * 92.0, 66.0), 32.0],
			[Vector2(float(side) * 55.0, 93.0), 23.0]
		]
		for cluster: Array in clusters:
			var cp: Vector2 = anchor + cluster[0]
			var radius: float = float(cluster[1])
			draw_circle(cp, radius + 3.0, Color(0.08, 0.25, 0.20, 0.88))
			draw_circle(cp + Vector2(-3.0, -4.0), radius, Color(0.15, 0.40, 0.27, 0.96))
			draw_circle(cp + Vector2(-radius * 0.22, -radius * 0.27), radius * 0.57, Color(0.30, 0.55, 0.31, 0.92))
			draw_circle(cp + Vector2(-radius * 0.28, -radius * 0.35), radius * 0.23, Color(0.53, 0.68, 0.35, 0.86))
		# Lianes fines avec petites feuilles, surtout visibles dans les marges.
		for vine_i: int in range(3):
			var vx: float = anchor.x - float(side) * (16.0 + float(vine_i) * 22.0)
			var vy: float = 72.0 + float(vine_i) * 13.0
			draw_line(Vector2(vx, vy), Vector2(vx + float(side) * 5.0, vy + 44.0), Color(0.16, 0.34, 0.20, 0.85), 2.2, true)
			for leaf_i: int in range(3):
				var lp := Vector2(vx + float(side) * float(leaf_i % 2) * 8.0, vy + 12.0 + float(leaf_i) * 11.0)
				draw_set_transform(lp, float(side) * 0.35, Vector2(1.0, 0.55))
				draw_circle(Vector2.ZERO, 5.0, Color(0.38, 0.61, 0.31, 0.9))
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


		# Petits détails peints dans la bordure : nervures, baies et lueurs.
		# Ils restent au-delà du bord du plateau et ne recouvrent aucune case.
		for leaf_i: int in range(4):
			var lp := anchor + Vector2(-float(side) * (24.0 + float(leaf_i) * 16.0), 118.0 + float(leaf_i % 2) * 14.0)
			var leaf_col: Color = Color(0.35, 0.60, 0.30, 0.92) if leaf_i % 2 == 0 else Color(0.48, 0.68, 0.34, 0.92)
			draw_colored_polygon(PackedVector2Array([
				lp + Vector2(-float(side) * 7.0, 0.0),
				lp + Vector2(0.0, -4.0),
				lp + Vector2(float(side) * 9.0, 1.0),
				lp + Vector2(0.0, 5.0)
			]), leaf_col)
			draw_line(lp + Vector2(-float(side) * 5.0, 0.0), lp + Vector2(float(side) * 6.0, 1.0), Color(0.72, 0.82, 0.45, 0.75), 1.2, true)
		for berry_i: int in range(3):
			var bp := anchor + Vector2(float(side) * (12.0 + float(berry_i) * 8.0), 142.0 + float(berry_i % 2) * 5.0)
			draw_circle(bp + Vector2(1.0, 1.5), 3.0, Color(0.05, 0.18, 0.12, 0.6))
			draw_circle(bp, 2.7, Color(0.72, 0.28, 0.22, 0.92))
			draw_circle(bp + Vector2(-0.8, -0.9), 0.9, Color(1.0, 0.75, 0.55, 0.9))
		# Deux champignons minuscules, décoratifs, sur la marge inférieure du cadre.
		var mush_base := anchor + Vector2(-float(side) * 18.0, 164.0)
		draw_line(mush_base, mush_base + Vector2(0.0, -7.0), Color(0.82, 0.77, 0.57, 0.9), 3.0, true)
		draw_arc(mush_base + Vector2(0.0, -7.0), 6.0, PI, TAU, 16, Color(0.76, 0.38, 0.24, 0.95), 4.0, true)
		draw_circle(mush_base + Vector2(-2.0, -8.5), 1.0, Color(1.0, 0.88, 0.6, 0.9))

		# Fougères de premier plan : silhouettes étagées pour relier les bouquets
		# au bord de l'écran et éviter l'impression de feuilles qui flottent.
		var fern_root := anchor + Vector2(float(side) * 18.0, 198.0)
		draw_line(fern_root, fern_root + Vector2(-float(side) * 22.0, -54.0), Color(0.16, 0.30, 0.18, 0.9), 3.0, true)
		for frond_i: int in range(5):
			var t: float = float(frond_i) / 4.0
			var stem: Vector2 = fern_root + Vector2(-float(side) * 22.0 * t, -54.0 * t)
			var leaf_dir: float = -float(side) * (13.0 + 4.0 * sin(t * PI))
			for branch_i: int in range(2):
				var sign_y: float = -1.0 if branch_i == 0 else 1.0
				var tip := stem + Vector2(leaf_dir, sign_y * (8.0 + 5.0 * sin(t * PI)))
				draw_line(stem, tip, Color(0.18, 0.38, 0.20, 0.88), 1.8, true)
				draw_colored_polygon(PackedVector2Array([
					tip,
					tip + Vector2(float(side) * 9.0, -sign_y * 2.0),
					tip + Vector2(float(side) * 4.0, sign_y * 5.0)
				]), Color(0.36, 0.58, 0.27, 0.92))

func _draw() -> void:
	if visible:
		_draw_forest_frame()
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
