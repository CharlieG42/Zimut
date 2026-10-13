class_name Cell
extends Node2D
## Cell.gd — Une case isométrique 2:1 (128×64) dessinée entièrement par code.
## L'origine du nœud est le centre du losange supérieur.

const HW := 64.0
const HH := 32.0
const DEPTH := 68.0

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
var _forest_tile_texture: Texture2D = null
var _tufts: Array = []
var _flowers: Array = []
var _pulse_phase: float = 0.0


## Palettes par biome : damier clair / foncé, couleurs de touffes et fleurs.
const BIOME_PALETTES := {
	"Forêt":    {"a": Color(0.56, 0.70, 0.34), "b": Color(0.49, 0.63, 0.29),
		"tuft": Color(0.32, 0.60, 0.22), "flowers": [Color(1, 1, 1), Color(1, 0.9, 0.35), Color(1, 0.6, 0.75)]},
	"Montagne": {"a": Color(0.55, 0.62, 0.52), "b": Color(0.48, 0.56, 0.47),
		"tuft": Color(0.38, 0.48, 0.30), "flowers": [Color(0.85, 0.85, 0.9), Color(0.7, 0.8, 0.95), Color(0.95, 0.95, 1)]},
	"Désert":   {"a": Color(0.85, 0.76, 0.48), "b": Color(0.78, 0.69, 0.42),
		"tuft": Color(0.60, 0.55, 0.25), "flowers": [Color(1, 0.95, 0.6), Color(0.95, 0.75, 0.35), Color(0.9, 0.6, 0.3)]},
	"Donjon":   {"a": Color(0.42, 0.40, 0.48), "b": Color(0.36, 0.34, 0.42),
		"tuft": Color(0.30, 0.30, 0.38), "flowers": [Color(0.6, 0.55, 0.8), Color(0.5, 0.6, 0.7)]},
}

## Biome affiché par cette case (défini avant setup()).
var biome: String = "Forêt"

func setup(gp: Vector2i) -> void:
	grid_position = gp
	_forest_tile_texture = null
	if biome == "Forêt":
		# Variantes déterministes : le décor reste stable entre les combats et les sessions.
		var tile_index: int = posmod(gp.x * 3 + gp.y * 5, 4) + 1
		var tile_path: String = "res://assets/sprites/tiles/forest_ground_%02d.svg" % tile_index
		_forest_tile_texture = load(tile_path) as Texture2D
		if _forest_tile_texture == null:
			push_warning("Texture de sol forestier introuvable : %s" % tile_path)
	var rng := RandomNumberGenerator.new()
	rng.seed = gp.x * 7919 + gp.y * 104729 + 17
	var pal: Dictionary = BIOME_PALETTES.get(biome, BIOME_PALETTES["Forêt"])
	var checker: bool = (gp.x + gp.y) % 2 == 0
	var tint: float = rng.randf_range(-0.025, 0.025)
	_base = (pal["a"] if checker else pal["b"])
	_base = Color(_base.r + tint, _base.g + tint, _base.b + tint)
	var tuft_col: Color = pal["tuft"]
	for i: int in range(rng.randi_range(3, 6)):
		var p := Vector2(rng.randf_range(-0.8, 0.8) * HW, rng.randf_range(-0.8, 0.8) * HH)
		if absf(p.x) / HW + absf(p.y) / HH < 0.8:
			_tufts.append([p, rng.randf_range(3.0, 6.0), rng.randf_range(-3.0, 3.0), tuft_col])
	var flower_chance: float = 0.16 if biome != "Désert" else 0.08
	if rng.randf() < flower_chance:
		for i: int in range(rng.randi_range(1, 2)):
			var fp := Vector2(rng.randf_range(-0.55, 0.55) * HW, rng.randf_range(-0.55, 0.55) * HH)
			var palette: Array = pal["flowers"]
			_flowers.append([fp, palette[rng.randi() % palette.size()]])
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
	if biome == "Forêt" and _forest_tile_texture != null:
		# La texture est un losange transparent 128×64, aligné sur la géométrie de Cell.
		draw_texture_rect(_forest_tile_texture, Rect2(-HW, -HH, HW * 2.0, HH * 2.0), false)
	else:
		draw_colored_polygon(top, _base)
		draw_colored_polygon(_diamond(0.62), Color(1, 0.96, 0.78, 0.025))
		# Fond de case plus clair au centre (bump lumineux)
		draw_colored_polygon(_diamond(0.80), Color(1, 0.96, 0.78, 0.035))
		draw_colored_polygon(_diamond(0.45), Color(1, 0.96, 0.78, 0.025))
	# Les motifs du sol forestier intègrent déjà mousse et brins d’herbe :
	# ne pas les doubler par les détails procéduraux, afin de garder les unités lisibles.
	if biome != "Forêt" or _forest_tile_texture == null:
		for t: Array in _tufts:
			var p: Vector2 = t[0]
			var h: float = t[1]
			var sway: float = t[2]
			var tc: Color = t[3] if t.size() > 3 else _base.darkened(0.22)
			draw_line(p, p + Vector2(sway, -h), tc, 1.6)
			draw_line(p + Vector2(2, 0), p + Vector2(2 + sway * 0.6, -h * 0.7), tc.lightened(0.25), 1.4)
	if biome != "Forêt" or _forest_tile_texture == null:
		for f: Array in _flowers:
			var fp: Vector2 = f[0]
			draw_circle(fp, 2.6, f[1])
			draw_circle(fp, 1.0, Color(0.95, 0.7, 0.1))
	# Reflets/ombres sur les arêtes pour donner du volume
	draw_line(Vector2(-HW, 0), Vector2(0, -HH), Color(0.93, 1.0, 0.82, 0.32), 2.0)
	draw_line(Vector2(0, -HH), Vector2(HW, 0), Color(0.93, 1.0, 0.82, 0.24), 2.0)
	draw_line(Vector2(HW, 0), Vector2(0, HH), Color(0.13, 0.24, 0.12, 0.28), 2.0)
	draw_line(Vector2(0, HH), Vector2(-HW, 0), Color(0.13, 0.24, 0.12, 0.28), 2.0)
	_outline(top, Color(0.12, 0.22, 0.10, 0.30), 1.25)

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
