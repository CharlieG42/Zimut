class_name ZJoystick
extends Control
## ZJoystick.gd — Joystick tactile : on pose le pouce sur la base et on glisse dans la
## direction voulue. `vector` (longueur 0..1) est lu par l'écran qui l'utilise ; `active` dit si
## le doigt est posé. Fonctionne aussi à la souris (le tactile est émulé en souris).

signal released

var vector: Vector2 = Vector2.ZERO
var active: bool = false
const DEADZONE := 0.28

var _radius: float = 84.0
var _touch_index: int = -1


func _init() -> void:
	custom_minimum_size = Vector2(200, 200)
	mouse_filter = Control.MOUSE_FILTER_STOP


func _center() -> Vector2:
	return size * 0.5


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			active = true
			_update((event as InputEventMouseButton).position)
		else:
			_release()
		accept_event()
	elif event is InputEventMouseMotion and active:
		_update((event as InputEventMouseMotion).position)
		accept_event()


func _update(pos: Vector2) -> void:
	var d: Vector2 = pos - _center()
	vector = (d / _radius).limit_length(1.0)
	queue_redraw()


func _release() -> void:
	active = false
	vector = Vector2.ZERO
	queue_redraw()
	released.emit()


## Vrai quand le pouce est assez loin du centre pour compter comme une direction.
func pushed() -> bool:
	return active and vector.length() > DEADZONE


func _draw() -> void:
	var c: Vector2 = _center()
	draw_circle(c, _radius + 8.0, Color(0.03, 0.05, 0.10, 0.55))
	draw_arc(c, _radius + 4.0, 0.0, TAU, 48, Color(0.55, 0.68, 0.95, 0.85 if active else 0.55), 4.0, true)
	for k: int in range(4):
		var a: float = float(k) * PI * 0.5 + PI * 0.25
		draw_line(c + Vector2(cos(a), sin(a)) * 28.0, c + Vector2(cos(a), sin(a)) * (_radius - 10.0), Color(1, 1, 1, 0.12), 2.0, true)
	var knob: Vector2 = c + vector * (_radius - 18.0)
	draw_circle(knob + Vector2(0, 3), 34.0, Color(0, 0, 0, 0.35))
	draw_circle(knob, 34.0, Color(0.45, 0.60, 0.88, 0.95) if active else Color(0.38, 0.50, 0.75, 0.85))
	draw_circle(knob + Vector2(-8, -9), 13.0, Color(1, 1, 1, 0.28))


## Direction de grille (iso) pour un vecteur écran. `flip` départage les directions
## cardinales de l'écran (haut/bas/gauche/droite), qui tombent entre deux axes de la grille.
## Grille : (1,0)=↘  (0,1)=↙  (-1,0)=↖  (0,-1)=↗.
static func grid_dirs(v: Vector2, flip: bool) -> Array[Vector2i]:
	var ang: float = fposmod(v.angle(), TAU)   # 0 = droite, π/2 = bas
	var sector: int = int(round(ang / (PI * 0.25))) % 8
	# secteurs : 0 droite, 1 bas-droite, 2 bas, 3 bas-gauche, 4 gauche, 5 haut-gauche, 6 haut, 7 haut-droite
	var out: Array[Vector2i] = []
	match sector:
		1: out = [Vector2i(1, 0)]
		3: out = [Vector2i(0, 1)]
		5: out = [Vector2i(-1, 0)]
		7: out = [Vector2i(0, -1)]
		0: out = [Vector2i(1, 0), Vector2i(0, -1)]
		2: out = [Vector2i(1, 0), Vector2i(0, 1)]
		4: out = [Vector2i(0, 1), Vector2i(-1, 0)]
		_: out = [Vector2i(-1, 0), Vector2i(0, -1)]
	if out.size() == 2 and flip:
		out.reverse()
	return out
