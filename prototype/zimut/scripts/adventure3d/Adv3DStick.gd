class_name Adv3DStick
extends Control
## Adv3DStick.gd — Joystick virtuel analogique du monde 3D (déplacement).
##
## Dessiné en code (pas d'image). Base flottante : elle apparaît sous le doigt dans la
## zone du contrôle, le vecteur est calculé par rapport à ce point d'appui et borné à 1.
## Fonctionne au toucher (index multi-touch) et à la souris (PC).

signal moved(vector: Vector2)

const MOUSE_INDEX := 1000
const MAX_REACH := 90.0

var value: Vector2 = Vector2.ZERO
var rest_right: bool = false          # position de repos : coin bas-droit (stick de caméra)
var tint: Color = Color(1, 1, 1)
var caption: String = ""
var _index: int = -1
var _center: Vector2 = Vector2.ZERO
var _finger: Vector2 = Vector2.ZERO


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	_rest()
	resized.connect(_rest)


func is_pressed() -> bool:
	return _index != -1


func _rest() -> void:
	if _index == -1:
		var rx: float = size.x - minf(size.x * 0.5, 130.0) if rest_right else minf(size.x * 0.5, 130.0)
		_center = Vector2(rx, size.y - minf(size.y * 0.5, 130.0))
		_finger = _center
		queue_redraw()


func _gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		var t := event as InputEventScreenTouch
		if t.pressed and _index == -1:
			_begin(t.index, t.position)
		elif t.index == _index and (not t.pressed or t.canceled):
			_release()
		accept_event()
	elif event is InputEventScreenDrag:
		var d := event as InputEventScreenDrag
		if d.index == _index:
			_update(d.position)
			accept_event()
	elif event is InputEventMouseButton:
		var b := event as InputEventMouseButton
		if b.device == InputEvent.DEVICE_ID_EMULATION or b.button_index != MOUSE_BUTTON_LEFT:
			return
		if b.pressed and _index == -1:
			_begin(MOUSE_INDEX, b.position)
		elif not b.pressed and _index == MOUSE_INDEX:
			_release()
		accept_event()
	elif event is InputEventMouseMotion and _index == MOUSE_INDEX:
		var m := event as InputEventMouseMotion
		if m.device != InputEvent.DEVICE_ID_EMULATION:
			_update(m.position)
			accept_event()


func _notification(what: int) -> void:
	# Évite un stick « coincé » quand le système interrompt le toucher.
	if what == NOTIFICATION_APPLICATION_FOCUS_OUT or what == NOTIFICATION_WM_WINDOW_FOCUS_OUT \
			or (what == NOTIFICATION_VISIBILITY_CHANGED and not is_visible_in_tree()):
		if _index != -1:
			_release()


func _begin(index: int, pos: Vector2) -> void:
	_index = index
	_center = pos
	_finger = pos
	_update(pos)


func _update(pos: Vector2) -> void:
	var delta: Vector2 = pos - _center
	if delta.length() > MAX_REACH:
		delta = delta.normalized() * MAX_REACH
	_finger = _center + delta
	value = delta / MAX_REACH
	moved.emit(value)
	queue_redraw()


func _release() -> void:
	_index = -1
	value = Vector2.ZERO
	moved.emit(Vector2.ZERO)
	_rest()


func _draw() -> void:
	var active: bool = _index != -1
	draw_circle(_center, MAX_REACH + 8.0, Color(0.05, 0.08, 0.06, 0.28 if not active else 0.40))
	draw_arc(_center, MAX_REACH + 8.0, 0.0, TAU, 48, Color(tint.r, tint.g, tint.b, 0.55 if not active else 0.9), 3.0, true)
	if caption != "" and not active:
		var f: Font = ThemeDB.fallback_font
		var w: float = f.get_string_size(caption, HORIZONTAL_ALIGNMENT_LEFT, -1, 20).x
		draw_string(f, _center + Vector2(-w * 0.5, MAX_REACH + 34.0), caption, HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color(1, 1, 1, 0.85))
	draw_circle(_finger, 40.0, Color(tint.r, tint.g, tint.b, 0.55 if not active else 0.9))
	draw_arc(_finger, 40.0, 0.0, TAU, 32, Color(0.2, 0.3, 0.2, 0.9), 2.5, true)
