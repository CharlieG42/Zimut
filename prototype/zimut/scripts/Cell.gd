class_name Cell
extends Node2D
## Cell.gd — Une case isométrique 2:1 (128×64) dessinée entièrement par code.
## L'origine du nœud est le centre du losange supérieur.

const HW := 64.0
const HH := 32.0
const DEPTH := 34.0

var grid_position: Vector2i = Vector2i.ZERO
var edge_left: bool = false     # dernière rangée (bas-gauche) : falaise visible
var edge_right: bool = false    # dernière colonne (bas-droite) : falaise visible

# États de surbrillance (pilotés par GridManager)
var hover: bool = false
var in_move_range: bool = false
var in_spell_range: bool = false
var spell_target_ok: bool = false
var aoe_hl: bool = false
var ally_target: bool = false
var path_hl: bool = false
var path_cost: int = 0
var flash: float = 0.0

var _base: Color = Color(0.43, 0.68, 0.27)
var _tufts: Array = []
var _flowers: Array = []
var _pulse_phase: float = 0.0


func setup(gp: Vector2i) -> void:
	grid_position = gp
	var rng := RandomNumberGenerator.new()
	rng.seed = gp.x * 7919 + gp.y * 104729 + 17
	var checker: bool = (gp.x + gp.y) % 2 == 0
	var tint: float = rng.randf_range(-0.025, 0.025)
	_base = (Color(0.46, 0.71, 0.29) if checker else Color(0.40, 0.65, 0.25))
	_base = Color(_base.r + tint, _base.g + tint, _base.b + tint)
	for i: int in range(rng.randi_range(4, 7)):
		var p := Vector2(rng.randf_range(-0.8, 0.8) * HW, rng.randf_range(-0.8, 0.8) * HH)
		if absf(p.x) / HW + absf(p.y) / HH < 0.8:
			_tufts.append([p, rng.randf_range(3.0, 6.0), rng.randf_range(-3.0, 3.0)])
	if rng.randf() < 0.14:
		for i: int in range(rng.randi_range(1, 3)):
			var fp := Vector2(rng.randf_range(-0.55, 0.55) * HW, rng.randf_range(-0.55, 0.55) * HH)
			var palette: Array[Color] = [Color(1, 1, 1), Color(1, 0.9, 0.35), Color(1, 0.6, 0.75)]
			_flowers.append([fp, palette[rng.randi() % 3]])
	_pulse_phase = rng.randf() * TAU
	set_process(false)


func refresh() -> void:
	set_process(spell_target_ok or aoe_hl or flash > 0.0 or hover)
	queue_redraw()


func _process(delta: float) -> void:
	if flash > 0.0:
		flash = maxf(0.0, flash - delta * 2.2)
	queue_redraw()
	if not (spell_target_ok or aoe_hl or flash > 0.0 or hover):
		set_process(false)


func _diamond(s: float = 1.0, y_off: float = 0.0) -> PackedVector2Array:
	return PackedVector2Array([
		Vector2(0, -HH * s + y_off), Vector2(HW * s, y_off), Vector2(0, HH * s + y_off), Vector2(-HW * s, y_off)
	])


func _outline(pts: PackedVector2Array, col: Color, width: float) -> void:
	var closed: PackedVector2Array = pts.duplicate()
	closed.append(pts[0])
	draw_polyline(closed, col, width, true)


func _draw() -> void:
	# ── Falaises latérales (bord de l'île) ────────────────────────────────
	if edge_left:
		draw_polygon(PackedVector2Array([Vector2(-HW, 0), Vector2(0, HH), Vector2(0, HH + DEPTH), Vector2(-HW, DEPTH)]),
			PackedColorArray([Color(0.52, 0.38, 0.24), Color(0.52, 0.38, 0.24), Color(0.30, 0.21, 0.13), Color(0.30, 0.21, 0.13)]))
		draw_polygon(PackedVector2Array([Vector2(-HW, 0), Vector2(0, HH), Vector2(0, HH + 7), Vector2(-HW, 7)]),
			PackedColorArray([_base.darkened(0.15), _base.darkened(0.15), _base.darkened(0.3), _base.darkened(0.3)]))
		draw_line(Vector2(-HW * 0.5, HH * 0.5 + 16), Vector2(-HW * 0.2, HH * 0.8 + 14), Color(0, 0, 0, 0.18), 2.0)
		draw_line(Vector2(-HW * 0.9, 24), Vector2(-HW * 0.65, 30), Color(0, 0, 0, 0.15), 2.0)
	if edge_right:
		draw_polygon(PackedVector2Array([Vector2(0, HH), Vector2(HW, 0), Vector2(HW, DEPTH), Vector2(0, HH + DEPTH)]),
			PackedColorArray([Color(0.42, 0.30, 0.19), Color(0.42, 0.30, 0.19), Color(0.22, 0.15, 0.09), Color(0.22, 0.15, 0.09)]))
		draw_polygon(PackedVector2Array([Vector2(0, HH), Vector2(HW, 0), Vector2(HW, 7), Vector2(0, HH + 7)]),
			PackedColorArray([_base.darkened(0.3), _base.darkened(0.3), _base.darkened(0.42), _base.darkened(0.42)]))
		draw_line(Vector2(HW * 0.3, HH * 0.7 + 18), Vector2(HW * 0.6, HH * 0.4 + 18), Color(0, 0, 0, 0.2), 2.0)

	# ── Dessus de la case ─────────────────────────────────────────────────
	var top: PackedVector2Array = _diamond()
	draw_colored_polygon(top, _base)
	draw_colored_polygon(_diamond(0.62), Color(1, 1, 1, 0.045))
	for t: Array in _tufts:
		var p: Vector2 = t[0]
		var h: float = t[1]
		var sway: float = t[2]
		draw_line(p, p + Vector2(sway, -h), _base.darkened(0.22), 1.6)
		draw_line(p + Vector2(2, 0), p + Vector2(2 + sway * 0.6, -h * 0.7), _base.lightened(0.12), 1.4)
	for f: Array in _flowers:
		var fp: Vector2 = f[0]
		draw_circle(fp, 2.6, f[1])
		draw_circle(fp, 1.0, Color(0.95, 0.7, 0.1))
	# Reflets/ombres sur les arêtes pour donner du volume
	draw_line(Vector2(-HW, 0), Vector2(0, -HH), Color(1, 1, 1, 0.14), 2.0)
	draw_line(Vector2(0, -HH), Vector2(HW, 0), Color(1, 1, 1, 0.08), 2.0)
	draw_line(Vector2(HW, 0), Vector2(0, HH), Color(0, 0, 0, 0.12), 2.0)
	draw_line(Vector2(0, HH), Vector2(-HW, 0), Color(0, 0, 0, 0.12), 2.0)
	_outline(top, Color(0, 0, 0, 0.10), 1.0)

	# ── Surbrillances ─────────────────────────────────────────────────────
	var t_ms: float = float(Time.get_ticks_msec()) / 1000.0
	var pulse: float = 0.5 + 0.5 * sin(t_ms * 5.0 + _pulse_phase)

	if in_move_range:
		draw_colored_polygon(_diamond(0.94), Color(0.25, 0.55, 1.0, 0.30))
		_outline(_diamond(0.94), Color(0.45, 0.75, 1.0, 0.85), 2.0)
	if in_spell_range:
		draw_colored_polygon(_diamond(0.94), Color(1.0, 0.45, 0.2, 0.22))
		_outline(_diamond(0.94), Color(1.0, 0.6, 0.3, 0.7), 2.0)
	if ally_target:
		draw_colored_polygon(_diamond(0.94), Color(0.3, 1.0, 0.45, 0.20 + 0.14 * pulse))
		_outline(_diamond(0.94), Color(0.5, 1.0, 0.6, 0.95), 3.0)
	if spell_target_ok and not ally_target:
		draw_colored_polygon(_diamond(0.94), Color(1.0, 0.25, 0.15, 0.16 + 0.16 * pulse))
		_outline(_diamond(0.94), Color(1.0, 0.35, 0.25, 0.65 + 0.3 * pulse), 3.0)
	if aoe_hl:
		draw_colored_polygon(_diamond(0.9), Color(1.0, 0.7, 0.1, 0.30 + 0.15 * pulse))
		_outline(_diamond(0.9), Color(1.0, 0.85, 0.3, 0.95), 2.5)
	if path_hl:
		draw_colored_polygon(_diamond(0.38), Color(1.0, 0.95, 0.5, 0.85))
		_outline(_diamond(0.38), Color(0.4, 0.3, 0.0, 0.6), 1.5)
	if hover:
		draw_colored_polygon(_diamond(0.98), Color(1, 1, 1, 0.14))
		_outline(_diamond(0.98), Color(1, 1, 1, 0.95), 2.5)
		if path_cost > 0:
			var font: Font = ThemeDB.fallback_font
			draw_string_outline(font, Vector2(-30, 8), "%d PM" % path_cost, HORIZONTAL_ALIGNMENT_CENTER, 60, 20, 6, Color(0, 0, 0, 0.9))
			draw_string(font, Vector2(-30, 8), "%d PM" % path_cost, HORIZONTAL_ALIGNMENT_CENTER, 60, 20, Color(1, 1, 0.8))
	if flash > 0.0:
		draw_colored_polygon(_diamond(1.0), Color(1, 0.95, 0.7, flash * 0.6))
