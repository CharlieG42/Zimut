extends Control
## IntroUI.gd — Petite animation d'ouverture (V52), à la place de l'écran de démarrage Godot.
## Les dix Pierres Élémentaires (couleurs des Nations) tournoient, convergent vers le centre,
## un éclat révèle le logo Zimut, puis fondu vers l'Accueil. Un appui passe l'animation.
## Pendant ce temps, l'écran d'accueil est chargé en tâche de fond.

const NEXT_SCENE := "res://scenes/MainMenu.tscn"
const DURATION := 3.2
const STONES: Array[Color] = [
	Color(0.40, 0.75, 0.35), Color(0.55, 0.72, 0.95), Color(0.95, 0.75, 0.35), Color(0.62, 0.55, 1.0),
	Color(0.35, 0.80, 0.90), Color(0.70, 0.90, 0.95), Color(1.0, 0.55, 0.20), Color(0.65, 0.90, 0.80),
	Color(0.70, 0.50, 0.95), Color(0.95, 0.62, 0.22),
]
const BG := Color(0.05, 0.06, 0.10)

var _t: float = 0.0
var _logo: Texture2D
var _leaving: bool = false
var _sparks: Array = []   # [pos, vel, life, color]


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	_logo = load("res://assets/ui/logo_intro.png") as Texture2D
	ResourceLoader.load_threaded_request(NEXT_SCENE)
	var rng := RandomNumberGenerator.new()
	rng.seed = 42
	for i: int in range(40):
		_sparks.append([Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)), Vector2(rng.randf_range(-0.02, 0.02), rng.randf_range(-0.06, -0.02)),
			rng.randf_range(0.0, 1.0), STONES[i % STONES.size()]])


func _gui_input(ev: InputEvent) -> void:
	if (ev is InputEventMouseButton and (ev as InputEventMouseButton).pressed) or (ev is InputEventScreenTouch and (ev as InputEventScreenTouch).pressed):
		_leave()


func _process(delta: float) -> void:
	_t += delta
	for s: Array in _sparks:
		s[0] += s[1] * delta
		s[2] = fmod(float(s[2]) + delta * 0.35, 1.0)
		if s[0].y < -1.1:
			s[0].y = 1.1
	queue_redraw()
	if _t >= DURATION:
		_leave()


func _leave() -> void:
	if _leaving:
		return
	_leaving = true
	var tw := create_tween()
	tw.tween_property(self, "modulate", Color(0, 0, 0, 1), 0.35)
	tw.tween_callback(func() -> void:
		var packed: PackedScene = ResourceLoader.load_threaded_get(NEXT_SCENE) as PackedScene
		if packed != null:
			get_tree().change_scene_to_packed(packed)
		else:
			get_tree().change_scene_to_file(NEXT_SCENE))


static func _ease_out(x: float) -> float:
	x = clampf(x, 0.0, 1.0)
	return 1.0 - pow(1.0 - x, 3.0)


func _draw() -> void:
	var sz: Vector2 = size
	var c: Vector2 = sz * 0.5
	var unit: float = minf(sz.x, sz.y)
	draw_rect(Rect2(Vector2.ZERO, sz), BG)
	# halo de fond qui respire
	var glow_a: float = 0.10 + 0.05 * sin(_t * 2.0)
	for i: int in range(6):
		draw_circle(c, unit * (0.55 - 0.08 * float(i)), Color(0.35, 0.45, 0.75, glow_a * 0.35))
	# étincelles qui montent
	for s: Array in _sparks:
		var p: Vector2 = c + Vector2(s[0].x * sz.x * 0.5, s[0].y * sz.y * 0.5)
		var col: Color = s[3]
		draw_circle(p, 2.0 + 2.0 * sin(float(s[2]) * PI), Color(col.r, col.g, col.b, 0.5 * sin(float(s[2]) * PI) * clampf(_t, 0.0, 1.0)))
	# Les dix Pierres : orbite qui se resserre (0 → 1,6 s), puis convergence au centre
	var conv: float = smoothstep(0.0, 1.0, (_t - 0.4) / 1.3)
	var radius: float = unit * lerpf(0.42, 0.0, conv)
	var spin: float = _t * lerpf(1.2, 4.0, conv)
	for i: int in range(STONES.size()):
		var a: float = spin + TAU * float(i) / float(STONES.size())
		var sp: Vector2 = c + Vector2(cos(a), sin(a) * 0.55) * radius
		var col: Color = STONES[i]
		var alpha: float = clampf(_t * 2.0, 0.0, 1.0) * (1.0 - clampf((_t - 1.7) * 4.0, 0.0, 1.0))
		draw_circle(sp, unit * 0.030, Color(col.r, col.g, col.b, 0.25 * alpha))
		_draw_gem(sp, unit * 0.018, col, alpha)
	# Éclat de la réunion des Pierres
	var flash: float = clampf(1.0 - absf(_t - 1.8) * 3.0, 0.0, 1.0)
	if flash > 0.0:
		draw_circle(c, unit * 0.30 * flash, Color(1, 0.97, 0.85, 0.55 * flash))
		for k: int in range(12):
			var ang: float = TAU * float(k) / 12.0 + _t
			draw_line(c, c + Vector2(cos(ang), sin(ang)) * unit * 0.45 * flash, Color(1, 0.95, 0.75, 0.35 * flash), 3.0)
	# Logo révélé
	if _logo != null:
		var la: float = _ease_out((_t - 1.7) / 0.7)
		if la > 0.0:
			var h: float = unit * 0.62 * lerpf(0.85, 1.0, la)
			var w: float = h * float(_logo.get_width()) / float(_logo.get_height())
			var r := Rect2(c - Vector2(w, h) * 0.5, Vector2(w, h))
			draw_texture_rect(_logo, r, false, Color(1, 1, 1, la))
	# Indice discret
	if _t > 0.6:
		var font: Font = ThemeDB.fallback_font
		var a2: float = clampf((_t - 0.6) * 2.0, 0.0, 0.55)
		draw_string(font, Vector2(0, sz.y - unit * 0.05), "Touchez pour passer", HORIZONTAL_ALIGNMENT_CENTER, sz.x, int(unit * 0.03), Color(1, 1, 1, a2))


## Petite gemme taillée (losange + reflet).
func _draw_gem(p: Vector2, r: float, col: Color, a: float) -> void:
	var pts := PackedVector2Array([p + Vector2(0, -r * 1.3), p + Vector2(r, 0), p + Vector2(0, r * 1.3), p + Vector2(-r, 0)])
	draw_colored_polygon(pts, Color(col.r, col.g, col.b, a))
	draw_colored_polygon(PackedVector2Array([p + Vector2(0, -r * 1.3), p + Vector2(r * 0.45, -r * 0.2), p + Vector2(-r * 0.3, -r * 0.1)]), Color(1, 1, 1, 0.55 * a))
	draw_polyline(PackedVector2Array([pts[0], pts[1], pts[2], pts[3], pts[0]]), Color(col.lightened(0.4).r, col.lightened(0.4).g, col.lightened(0.4).b, a), 1.5, true)
