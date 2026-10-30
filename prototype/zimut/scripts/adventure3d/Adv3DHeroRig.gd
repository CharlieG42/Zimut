class_name Adv3DHeroRig
extends Node3D
## Adv3DHeroRig.gd — Animation procédurale du héros 3D (construit par Adv3DHeroModel.make_hero).
##
## Un seul appel par image : animate(delta, vitesse_réelle_m_s, vitesse_de_rotation_rad_s).
## • Marche → course : mélange continu selon la vitesse ; la cadence suit la distance parcourue
##   (pas de pieds qui glissent), genoux pliés en phase de balancier, bassin qui descend au contact,
##   contre-rotation épaules / bassin, bras opposés aux jambes avec coudes pliés, buste penché en course.
## • Virages : le corps s'incline vers l'intérieur et la tête anticipe la direction.
## • Repos : respiration, transfert de poids, regard qui se promène, clignements d'yeux.
## • Pans du manteau et sac à ressort (inertie), tête stabilisée.

const HIP_Y := 0.95
const LEG_LEN := 0.95
const RUN_FROM := 3.0          # m/s : début de la course (vitesse max de l'explorateur : 4,4)
const RUN_FULL := 4.3

var hips: Node3D
var torso: Node3D
var chest: Node3D
var head: Node3D
var eyes: Node3D
var cape: Node3D
var pack: Node3D
var arms: Array[Node3D] = []
var fores: Array[Node3D] = []
var legs: Array[Node3D] = []
var shins: Array[Node3D] = []

var _phase: float = 0.0
var _stride_amp: float = 0.0
var _t: float = 0.0
var _speed: float = 0.0
var _w: float = 0.0            # 0 = immobile, 1 = marche franche
var _r: float = 0.0            # 0 = marche, 1 = course
var _bank: float = 0.0
var _turn_look: float = 0.0
var _cape_a: float = 0.0
var _cape_v: float = 0.0
var _pack_y: float = 0.0
var _pack_v: float = 0.0
var _prev_hip_y: float = HIP_Y
var _look: Vector2 = Vector2.ZERO
var _look_target: Vector2 = Vector2.ZERO
var _look_timer: float = 2.0
var _blink_timer: float = 2.5
var _blink: float = -1.0
var _idle_time: float = 0.0
var _stance: float = 0.0          # -1 / +1 : jambe d'appui au repos (déhanché), 0 en marche
var _stance_target: float = 1.0
var _stance_timer: float = 4.0
var _head_base: Vector3 = Vector3.ZERO
var _rng := RandomNumberGenerator.new()


func setup() -> void:
	hips = get_node("Hips")
	torso = hips.get_node("Torso")
	chest = torso.get_node("Chest")
	head = chest.get_node("Head")
	eyes = head.get_node("Eyes")
	cape = hips.get_node("Cape")
	pack = chest.get_node("Pack")
	for side: String in ["L", "R"]:
		var a: Node3D = chest.get_node("Arm" + side)
		arms.append(a)
		fores.append(a.get_node("Forearm" + side))
		var l: Node3D = hips.get_node("Leg" + side)
		legs.append(l)
		shins.append(l.get_node("Shin" + side))
	_head_base = head.position + Vector3(0.0, 0.0, 0.03)   # tête légèrement en avant (cou naturel)
	_rng.randomize()
	_stance_target = 1.0 if _rng.randf() < 0.5 else -1.0
	animate(0.0, 0.0, 0.0)


static func _k(delta: float, rate: float) -> float:
	return 1.0 - exp(-delta * rate)


## Ressort amorti (valeur, vitesse) → nouvelle [valeur, vitesse].
static func _spring(x: float, v: float, target: float, stiff: float, damp: float, delta: float) -> Vector2:
	v += (target - x) * stiff * delta
	v *= exp(-damp * delta)
	x += v * delta
	return Vector2(x, v)


func animate(delta: float, speed: float, turn_rate: float) -> void:
	_t += delta
	_speed = lerpf(_speed, speed, _k(delta, 10.0))
	_w = lerpf(_w, clampf(_speed / 1.4, 0.0, 1.0), _k(delta, 9.0))
	_r = lerpf(_r, clampf((_speed - RUN_FROM) / (RUN_FULL - RUN_FROM), 0.0, 1.0), _k(delta, 6.0))
	var still: float = 1.0 - _w
	if _speed < 0.2:
		_idle_time += delta
	else:
		_idle_time = 0.0

	# ── cycle de pas : 1 tour = 2 pas ; longueur de foulée croissante avec la vitesse
	var cycle_len: float = lerpf(1.35, 2.3, _r)
	_phase = wrapf(_phase + _speed * delta / cycle_len * TAU, 0.0, TAU)
	var leg_amp: float = (0.42 + 0.20 * _r) * _w
	_stride_amp = leg_amp
	var arm_amp: float = (0.34 + 0.40 * _r) * _w

	# ── déhanché au repos : le poids passe d'une jambe à l'autre de temps en temps
	if _idle_time > 0.6:
		_stance_timer -= delta
		if _stance_timer <= 0.0:
			_stance_target = -_stance_target
			_stance_timer = _rng.randf_range(5.0, 9.0)
	var stance_goal: float = _stance_target * still if _idle_time > 0.6 else 0.0
	_stance = lerpf(_stance, stance_goal, _k(delta, 2.2))
	var st: float = _stance                     # < 0 : appui sur la jambe gauche (x négatif)

	# ── bassin : descend au contact (jambes écartées), monte au croisement ; rebond en course
	var spread: float = absf(sin(_phase))
	var drop: float = LEG_LEN * (1.0 - cos(leg_amp * spread))
	var bounce: float = _r * _w * 0.05 * (1.0 - spread)
	var breath: float = sin(_t * 1.9)
	var hip_y: float = HIP_Y - drop + bounce - 0.015 * _r - absf(st) * 0.012
	hips.position = Vector3(cos(_phase) * 0.022 * _w + st * 0.035, hip_y, 0.0)
	_bank = lerpf(_bank, clampf(-turn_rate * _speed * 0.018, -0.2, 0.2), _k(delta, 6.0))
	# bassin basculé vers l'avant (cambrure), roulis du côté de la jambe libre
	hips.rotation = Vector3(0.06, sin(_phase) * 0.10 * _w + st * 0.05, _bank + st * 0.06 + cos(_phase) * 0.035 * _w)

	# ── colonne en S : le ventre suit, la poitrine se redresse et compense le bassin
	var twist: float = -sin(_phase) * 0.12 * _w
	var lean: float = 0.03 * _w + 0.16 * _r
	var yaw_rel: float = twist - hips.rotation.y
	torso.rotation = Vector3(-0.02 + lean * 0.45, yaw_rel * 0.45, -hips.rotation.z * 0.55)
	chest.rotation = Vector3(-0.07 + lean * 0.55 + sin(_phase * 2.0) * 0.02 * _w, yaw_rel * 0.55, -hips.rotation.z * 0.25 - st * 0.035 - _bank * 0.15)
	chest.scale = Vector3(1.0 + breath * 0.008 * still, 1.0 + breath * 0.012 * still, 1.0 + breath * 0.016 * still)

	# ── jambes : balancier, genou plié quand la jambe revient vers l'avant ; au repos, jambe libre détendue
	for i: int in range(2):
		var sgn_l: float = -1.0 if i == 0 else 1.0
		var p: float = _phase + float(i) * PI
		var s: float = sin(p)
		var c: float = cos(p)
		var free: float = maxf(0.0, st * sgn_l)          # cette jambe ne porte pas le poids
		var support: float = maxf(0.0, -st * sgn_l)
		legs[i].rotation = Vector3(-s * leg_amp - 0.06 - free * 0.1, sgn_l * free * 0.04, -hips.rotation.z - sgn_l * (support * 0.035 - 0.012))
		var knee: float = 0.07 + _w * (0.08 + maxf(0.0, c) * (0.75 + 0.5 * _r) + _r * 0.12) + free * 0.2
		shins[i].rotation.x = knee

	# ── bras : opposés aux jambes, coudes toujours un peu pliés, mains légèrement vers l'avant
	for i: int in range(2):
		var sgn: float = -1.0 if i == 0 else 1.0
		var s2: float = sin(_phase + float(i) * PI)
		var idle_sway: float = sin(_t * 1.9 + float(i) * 0.8) * 0.03 * still
		arms[i].rotation = Vector3(s2 * arm_amp + idle_sway - 0.05 + lean * 0.3, -sgn * 0.12 * still, sgn * (0.09 + 0.05 * _r + breath * 0.012 * still) + st * 0.03)
		fores[i].rotation = Vector3(-(0.28 + 0.12 * _w + 0.85 * _r + maxf(0.0, -s2) * 0.25 * _w), sgn * 0.25 * still, 0.0)

	# ── tête : stabilisée, regarde dans le virage, se promène au repos
	_turn_look = lerpf(_turn_look, clampf(turn_rate * 0.09, -0.45, 0.45), _k(delta, 5.0))
	_update_look(delta)
	head.position = _head_base
	head.rotation = Vector3(0.05 - lean * 0.6 + _look.y + sin(_phase * 2.0) * 0.025 * _w, -twist * 0.85 + _look.x * still + _turn_look, -_bank * 0.3 + _look.x * 0.08 * still)

	# ── yeux : clignements
	_blink_timer -= delta
	if _blink_timer <= 0.0 and _blink < 0.0:
		_blink = 0.0
	if _blink >= 0.0:
		_blink += delta
		var b: float = clampf(1.0 - absf(_blink - 0.07) / 0.07, 0.0, 1.0)
		eyes.scale = Vector3(1.0, maxf(0.08, 1.0 - b), 1.0)
		if _blink > 0.14:
			_blink = -1.0
			eyes.scale = Vector3.ONE
			_blink_timer = _rng.randf_range(0.15, 0.3) if _rng.randf() < 0.18 else _rng.randf_range(2.2, 5.0)

	# ── pans du manteau (ressort) : s'écartent avec la vitesse, ondulent à chaque pas
	var cape_target: float = 0.04 + 0.22 * _w + 0.38 * _r + sin(_phase * 2.0) * 0.05 * _w + sin(_t * 1.3) * 0.02 * still
	if delta > 0.0:
		var cs: Vector2 = _spring(_cape_a, _cape_v, cape_target, 90.0, 7.0, delta)
		_cape_a = maxf(cs.x, -0.05)
		_cape_v = cs.y
		# le sac rebondit avec un temps de retard sur le bassin
		var hv: float = (hip_y - _prev_hip_y) / delta
		var ps: Vector2 = _spring(_pack_y, _pack_v - hv * 0.25, 0.0, 160.0, 10.0, delta)
		_pack_y = clampf(ps.x, -0.04, 0.04)
		_pack_v = ps.y
	_prev_hip_y = hip_y
	cape.rotation = Vector3(_cape_a, 0.0, sin(_phase) * 0.05 * _w)
	pack.position = Vector3(0.0, Adv3DHeroModel.H_PACK.y - Adv3DHeroModel.H_CHEST.y + _pack_y, Adv3DHeroModel.H_PACK.z)
	pack.rotation.x = -_pack_y * 2.0


func _update_look(delta: float) -> void:
	if _idle_time > 1.2:
		_look_timer -= delta
		if _look_timer <= 0.0:
			if _rng.randf() < 0.35:
				_look_target = Vector2.ZERO
			else:
				_look_target = Vector2(_rng.randf_range(-0.6, 0.6), _rng.randf_range(-0.12, 0.14))
			_look_timer = _rng.randf_range(1.8, 4.5)
	else:
		_look_target = Vector2.ZERO
		_look_timer = _rng.randf_range(0.8, 2.0)
	_look = _look.lerp(_look_target, _k(delta, 3.5))


## Pour les tests : amplitude actuelle du pas (radians).
func stride() -> float:
	return _stride_amp * 2.0
