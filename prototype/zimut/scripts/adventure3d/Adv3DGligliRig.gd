class_name Adv3DGligliRig
extends Node3D
## Adv3DGligliRig.gd — Animation procédurale de Gligli 3D (construit par Adv3DHeroModel.make_gligli).
##
## animate(delta, vitesse_m_s, assis, regard_lacet_local) à chaque image ; react(émotion) pour les événements.
## • Déplacement en petits bonds dont la cadence suit la distance parcourue : écrasement à l'atterrissage,
##   étirement en l'air, tangage, pattes avant tendues / pattes arrière qui poussent ; galop quand il court.
## • Oreilles-feuilles et queue à ressort (elles traînent derrière, rebondissent, frétillent).
## • Repos : respiration, regard vers le joueur, tête penchée de curiosité, oreille qui frémit, clignements.
## • Assis : se tasse et se redresse, pattes arrière repliées, queue enroulée sur le côté.
## • Réactions : « heureux » (saut + queue qui frétille), « surpris » (sursaut, oreilles dressées),
##   « colere » (se ramasse, oreilles plaquées).

var body: Node3D
var head: Node3D
var eyes: Node3D
var tail: Node3D
var ears: Array[Node3D] = []
var paws_f: Array[Node3D] = []
var paws_b: Array[Node3D] = []

var _t: float = 0.0
var _phase: float = 0.0
var _speed: float = 0.0
var _w: float = 0.0
var _r: float = 0.0
var _sit: float = 0.0
var _ear_a: Array[float] = [0.0, 0.0]
var _ear_v: Array[float] = [0.0, 0.0]
var _tail_a: float = 0.0
var _tail_v: float = 0.0
var _prev_y: float = 0.0
var _jump_y: float = 0.0
var _jump_v: float = 0.0
var _mood: String = ""
var _mood_time: float = 0.0
var _tilt: float = 0.0
var _tilt_target: float = 0.0
var _tilt_timer: float = 3.0
var _twitch_timer: float = 4.0
var _blink_timer: float = 2.0
var _blink: float = -1.0
var _head_yaw: float = 0.0
var _rng := RandomNumberGenerator.new()


func setup() -> void:
	body = get_node("Body")
	head = body.get_node("Head")
	eyes = head.get_node("Eyes")
	tail = body.get_node("Tail")
	for side: String in ["L", "R"]:
		ears.append(head.get_node("Ear" + side))
		paws_f.append(body.get_node("PawF" + side))
		paws_b.append(body.get_node("PawB" + side))
	_rng.randomize()
	animate(0.0, 0.0, false, 0.0)


static func _k(delta: float, rate: float) -> float:
	return 1.0 - exp(-delta * rate)


## Réaction à un événement : « heureux », « surpris », « colere », « neutre ».
func react(kind: String) -> void:
	_mood = kind
	_mood_time = 2.2
	match kind:
		"heureux":
			_jump_v = 3.2
		"surpris":
			_jump_v = 2.2
			for i: int in range(2):
				_ear_v[i] += 6.0
		"colere":
			_jump_v = 0.0


func is_airborne() -> bool:
	return body.position.y > 0.02


func animate(delta: float, speed: float, sitting: bool, look_yaw: float) -> void:
	_t += delta
	_speed = lerpf(_speed, speed, _k(delta, 10.0))
	_w = lerpf(_w, clampf(_speed / 0.9, 0.0, 1.0), _k(delta, 9.0))
	_r = lerpf(_r, clampf((_speed - 3.0) / 2.5, 0.0, 1.0), _k(delta, 6.0))
	_sit = lerpf(_sit, 1.0 if sitting else 0.0, _k(delta, 5.0))
	if _mood_time > 0.0:
		_mood_time -= delta
		if _mood_time <= 0.0:
			_mood = ""
	var still: float = (1.0 - _w)
	var angry: float = 1.0 if _mood == "colere" else 0.0
	var happy: float = 1.0 if _mood == "heureux" else 0.0
	var surprised: float = 1.0 if _mood == "surpris" else 0.0

	# ── bonds : 1 tour = 1 bond ; hauteur et longueur augmentent en courant
	var hop_len: float = lerpf(0.62, 1.25, _r)
	_phase = wrapf(_phase + _speed * delta / hop_len * TAU, 0.0, TAU)
	var s: float = sin(_phase)
	var c: float = cos(_phase)
	var air: float = maxf(0.0, s)
	var ground: float = maxf(0.0, -s)
	var hop_h: float = (0.09 + 0.11 * _r) * _w

	# saut de réaction (balistique)
	if delta > 0.0:
		_jump_v -= 16.0 * delta
		_jump_y = maxf(0.0, _jump_y + _jump_v * delta)
		if _jump_y <= 0.0 and _jump_v < 0.0:
			_jump_v = 0.0
	var breath: float = sin(_t * 2.6)
	var y: float = air * hop_h + _jump_y - 0.05 * _sit - 0.04 * angry
	body.position = Vector3(0.0, y, -0.03 * _sit)
	var sq: float = (air * 0.07 - ground * 0.11) * _w + breath * 0.018 * still - 0.08 * angry
	body.scale = Vector3(1.0 - sq * 0.5 + 0.05 * _sit, 1.0 + sq - 0.06 * _sit, 1.0 - sq * 0.5 + 0.05 * _sit)
	body.rotation = Vector3(-c * 0.16 * _w + 0.06 * _r - 0.16 * _sit + 0.12 * angry, 0.0, sin(_t * 0.7) * 0.03 * still * (1.0 - _sit))

	# ── pattes
	for i: int in range(2):
		var sgn: float = -1.0 if i == 0 else 1.0
		paws_f[i].rotation = Vector3(cos(_phase - 0.9) * 0.55 * _w + 0.1 * _sit, 0.0, 0.0)
		paws_b[i].rotation = Vector3(cos(_phase + 0.4) * 0.6 * _w - 0.55 * _sit, 0.0, sgn * 0.25 * _sit)

	# ── tête : regarde (le joueur), penche de curiosité, hoche avec les bonds
	_tilt_timer -= delta
	if _tilt_timer <= 0.0:
		_tilt_target = 0.0 if _rng.randf() < 0.5 else _rng.randf_range(-0.35, 0.35)
		_tilt_timer = _rng.randf_range(2.0, 5.0)
	if _w > 0.3:
		_tilt_target = 0.0
	_tilt = lerpf(_tilt, _tilt_target, _k(delta, 4.0))
	_head_yaw = lerpf(_head_yaw, clampf(look_yaw, -0.8, 0.8) * still, _k(delta, 5.0))
	head.rotation = Vector3(c * 0.10 * _w + 0.12 * _sit - 0.15 * surprised + 0.1 * angry - breath * 0.015 * still, _head_yaw, _tilt * still)

	# ── oreilles à ressort : en arrière quand il court, dressées de surprise, plaquées de colère
	var vy: float = 0.0
	if delta > 0.0:
		vy = (y - _prev_y) / delta
	_prev_y = y
	_twitch_timer -= delta
	var twitch: int = -1
	if _twitch_timer <= 0.0:
		twitch = _rng.randi_range(0, 1)
		_twitch_timer = _rng.randf_range(2.5, 6.5)
	for i: int in range(2):
		var sgn: float = -1.0 if i == 0 else 1.0
		var target: float = -(0.12 * _w + 0.45 * _r) + 0.12 * surprised - 0.95 * angry - 0.1 * _sit
		if delta > 0.0:
			_ear_v[i] += (target - _ear_a[i]) * 140.0 * delta - vy * 22.0 * delta
			if i == twitch and _w < 0.3:
				_ear_v[i] += -5.0
			_ear_v[i] *= exp(-8.0 * delta)
			_ear_a[i] += _ear_v[i] * delta
		_ear_a[i] = clampf(_ear_a[i], -1.2, 0.5)
		var splay: float = sgn * (0.10 + 0.22 * _sit + 0.25 * angry - 0.08 * surprised)
		ears[i].rotation = Vector3(_ear_a[i], 0.0, splay)

	# ── queue : frétille (vite si heureux), se relève en course, s'enroule assis
	var wag_f: float = lerpf(5.0, 15.0, happy)
	var wag_a: float = lerpf(0.18, 0.6, happy) * (1.0 - 0.6 * _r)
	var tail_lift: float = 0.25 * _r + 0.3 * happy - 0.1 * angry
	if delta > 0.0:
		_tail_v += (tail_lift - _tail_a) * 120.0 * delta - vy * 15.0 * delta
		_tail_v *= exp(-9.0 * delta)
		_tail_a += _tail_v * delta
	tail.rotation = Vector3(_tail_a, sin(_t * wag_f) * wag_a + 0.55 * _sit, 0.0)

	# ── clignements
	_blink_timer -= delta
	if _blink_timer <= 0.0 and _blink < 0.0:
		_blink = 0.0
	if _blink >= 0.0:
		_blink += delta
		var b: float = clampf(1.0 - absf(_blink - 0.06) / 0.06, 0.0, 1.0)
		eyes.scale = Vector3(1.0, maxf(0.08, 1.0 - b), 1.0)
		if _blink > 0.12:
			_blink = -1.0
			eyes.scale = Vector3.ONE
			_blink_timer = _rng.randf_range(0.15, 0.3) if _rng.randf() < 0.2 else _rng.randf_range(1.8, 4.5)
	if surprised > 0.0:
		eyes.scale = Vector3(1.12, 1.15, 1.0)
	elif angry > 0.0:
		eyes.scale = Vector3(1.0, 0.55, 1.0)
