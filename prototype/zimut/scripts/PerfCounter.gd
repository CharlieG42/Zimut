class_name PerfCounter
extends Label
## PerfCounter.gd — V135 : compteur de fluidité autonome (vues 3D de l'Aventure).
##
## Même lecture que celui de la carte 2D (V121) : images par seconde, durée moyenne et pire image, saccades
## (images de plus de 25 ms), puis durée max de la scène et du rendu sur ~4 s, dessins, objets, triangles,
## mémoire vidéo et nombre de nœuds. S'ajoute à n'importe quel calque d'interface ; ne fait rien d'autre.

var _acc: Array[float] = []
var _clock: float = 0.0
var _win: float = 0.0
var _t0: int = 0
var _t1: int = 0
var _scene_max: float = 0.0
var _draw_max: float = 0.0


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_theme_font_size_override("font_size", 18)
	add_theme_color_override("font_color", Color(0.6, 1.0, 0.6))
	add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
	add_theme_constant_override("outline_size", 6)
	text = "…"
	get_tree().process_frame.connect(_on_process_frame)
	RenderingServer.frame_pre_draw.connect(_on_pre_draw)
	RenderingServer.frame_post_draw.connect(_on_post_draw)


func _exit_tree() -> void:
	if get_tree().process_frame.is_connected(_on_process_frame):
		get_tree().process_frame.disconnect(_on_process_frame)
	if RenderingServer.frame_pre_draw.is_connected(_on_pre_draw):
		RenderingServer.frame_pre_draw.disconnect(_on_pre_draw)
	if RenderingServer.frame_post_draw.is_connected(_on_post_draw):
		RenderingServer.frame_post_draw.disconnect(_on_post_draw)


func _on_process_frame() -> void:
	_t0 = Time.get_ticks_usec()


func _on_pre_draw() -> void:
	_t1 = Time.get_ticks_usec()
	if _t0 > 0:
		_scene_max = maxf(_scene_max, float(_t1 - _t0) / 1000.0)


func _on_post_draw() -> void:
	if _t1 > 0:
		_draw_max = maxf(_draw_max, float(Time.get_ticks_usec() - _t1) / 1000.0)


func _process(delta: float) -> void:
	_acc.append(delta)
	_clock += delta
	if _clock < 0.5:
		return
	_clock = 0.0
	while _acc.size() > 240:
		_acc.remove_at(0)
	text = summary(_acc, _scene_max, _draw_max)
	_win += 0.5
	if _win >= 4.0:
		_win = 0.0
		_scene_max = 0.0
		_draw_max = 0.0


## Texte du compteur pour une série de durées d'image (s) — séparé pour être testable.
static func summary(frames: Array[float], scene_ms: float, draw_ms: float) -> String:
	var tot: float = 0.0
	var worst: float = 0.0
	var slow: int = 0
	for v: float in frames:
		tot += v
		worst = maxf(worst, v)
		if v > 1.0 / 40.0:
			slow += 1
	var avg: float = tot / maxf(1.0, float(frames.size()))
	return "%d i/s · %.0f ms · pire %.0f ms · saccades %d\nscène %.0f · rendu %.0f ms (max)\ndessins %d · objets %d · triangles %d k · vram %d Mo · nœuds %d" % [
		roundi(1.0 / maxf(avg, 0.0001)), avg * 1000.0, worst * 1000.0, slow, scene_ms, draw_ms,
		int(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)),
		int(Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME)),
		int(Performance.get_monitor(Performance.RENDER_TOTAL_PRIMITIVES_IN_FRAME) / 1000.0),
		int(Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / 1048576.0),
		int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT))]
