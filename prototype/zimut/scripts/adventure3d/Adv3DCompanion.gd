class_name Adv3DCompanion
extends Node3D
## Adv3DCompanion.gd — Gligli, le compagnon du joueur dans le monde 3D.
## Il suit l'explorateur (sans traverser arbres, rochers ni vide), court quand il est loin,
## s'assoit quand le joueur s'arrête, et réagit aux événements par une bulle d'émotion.

const DIR := "res://assets/adventure3d/gligli/"
const FOLLOW_BEHIND := 1.5
const FOLLOW_SIDE := 0.7
const MAX_SPEED := 6.4
const RADIUS := 0.25

var terrain: Dictionary = {}
var target: Adv3DExplorer = null

var _actor: Adv3DSpriteActor = null
var _model: Adv3DGligliRig = null        # vrai modèle 3D (si activé dans les Options)
var _t: float = 0.0
const SCALE_3D := 0.8                    # Gligli un peu plus petit que le modèle de base
const ACCEL := 14.0                      # m/s² : départs et arrêts progressifs
var _cur_speed: float = 0.0
var _chasing: bool = false
const SCALE_SPRITE := 0.82
var _facing: float = 0.0
var _last_target_pos: Vector3 = Vector3.ZERO
var _idle_time: float = 0.0
var _stuck: float = 0.0
var _emote: Sprite3D = null
var _emote_label: Label3D = null
var _emote_tween: Tween = null


static func create(terr: Dictionary, who: Adv3DExplorer) -> Adv3DCompanion:
	var c := Adv3DCompanion.new()
	c.name = "Gligli"
	c.terrain = terr
	c.target = who
	if Adv3DHeroModel.enabled():
		var m: Adv3DGligliRig = Adv3DHeroModel.make_gligli() as Adv3DGligliRig
		m.scale = Vector3.ONE * SCALE_3D
		c._model = m
		c.add_child(m)
	else:
		var a: Adv3DSpriteActor = Adv3DSpriteActor.create("gligli")
		if a == null:
			return null
		a.scale = Vector3.ONE * SCALE_SPRITE
		c._actor = a
		c.add_child(a)
		Adv3DActors.add_shadow(c, 0.35)
	c._build_emote()
	return c


func _build_emote() -> void:
	_emote = Sprite3D.new()
	_emote.name = "Emote"
	_emote.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	_emote.shaded = false
	_emote.double_sided = true
	_emote.alpha_cut = SpriteBase3D.ALPHA_CUT_OPAQUE_PREPASS
	_emote.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	_emote.pixel_size = 0.0045
	_emote.position = Vector3(0, 1.35, 0)
	_emote.visible = false
	add_child(_emote)
	_emote_label = Label3D.new()
	_emote_label.text = "Gligli"
	_emote_label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	_emote_label.font_size = 30
	_emote_label.pixel_size = 0.011
	_emote_label.outline_size = 10
	_emote_label.modulate = Color(0.85, 1.0, 0.7)
	_emote_label.no_depth_test = true
	_emote_label.position = Vector3(0, 0.9, 0)
	_emote_label.visible = false
	add_child(_emote_label)


## Pose Gligli près du joueur (au démarrage ou si on l'a perdu).
func place_near_target() -> void:
	if target == null:
		return
	var p: Vector3 = _follow_point()
	if not _free(p):
		p = target.position
	position = Vector3(p.x, Adv3DWorld.height_at(p.x, p.z), p.z)
	_last_target_pos = target.position
	_stuck = 0.0


## Bulle d'émotion : « heureux », « surpris », « colere » ou « neutre ».
func emote(kind: String, seconds: float = 2.2) -> void:
	var path: String = DIR + "emote_%s.png" % kind
	if _emote == null or not ResourceLoader.exists(path):
		return
	_emote.texture = load(path)
	if _model != null:
		_model.react(kind)
	_emote.visible = true
	_emote_label.visible = true
	_emote.scale = Vector3.ONE * 0.2
	if _emote_tween != null and _emote_tween.is_valid():
		_emote_tween.kill()
	_emote_tween = create_tween()
	_emote_tween.tween_property(_emote, "scale", Vector3.ONE, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_emote_tween.tween_interval(seconds)
	_emote_tween.tween_callback(func() -> void:
		_emote.visible = false
		_emote_label.visible = false)


func _follow_point() -> Vector3:
	var f: float = target.facing()
	var fwd := Vector3(sin(f), 0.0, cos(f))
	var right := Vector3(fwd.z, 0.0, -fwd.x)
	return target.position - fwd * FOLLOW_BEHIND + right * FOLLOW_SIDE


func _free(p: Vector3) -> bool:
	for o: Vector2 in [Vector2.ZERO, Vector2(RADIUS, 0), Vector2(-RADIUS, 0), Vector2(0, RADIUS), Vector2(0, -RADIUS)]:
		if not Adv3DWorld.point_walkable(terrain, Vector3(p.x + o.x, p.y, p.z + o.y)):
			return false
	return true


func _process(delta: float) -> void:
	if target == null or (_actor == null and _model == null):
		return
	# le joueur est-il à l'arrêt ?
	if target.position.distance_to(_last_target_pos) < 0.01:
		_idle_time += delta
	else:
		_idle_time = 0.0
	_last_target_pos = target.position
	var goal: Vector3 = _follow_point()
	if not _free(goal):
		goal = target.position
	var to_goal: Vector3 = goal - position
	to_goal.y = 0.0
	var dist: float = to_goal.length()
	var moving: bool = false
	var running: bool = false
	if dist > 8.0:
		place_near_target()
		return
	var before: Vector3 = position
	# hystérésis : il repart au-delà de 0,45 m, s'arrête sous 0,2 m (pas de piétinement)
	if dist > 0.45:
		_chasing = true
	elif dist < 0.2:
		_chasing = false
	var desired: float = clampf(dist * 3.2, 1.2, MAX_SPEED) if _chasing else 0.0
	_cur_speed = move_toward(_cur_speed, desired, ACCEL * delta)
	if _cur_speed > 0.05 and dist > 0.01:
		var step: Vector3 = to_goal.normalized() * minf(_cur_speed * delta, dist)
		var moved: bool = true
		if _free(position + step):
			position += step
		elif _free(position + Vector3(step.x, 0, 0)):
			position += Vector3(step.x, 0, 0)
		elif _free(position + Vector3(0, 0, step.z)):
			position += Vector3(0, 0, step.z)
		else:
			moved = false
		if moved:
			_stuck = 0.0
			moving = true
			_facing = lerp_angle(_facing, atan2(step.x, step.z), clampf(delta * 10.0, 0.0, 1.0))
		else:
			_stuck += delta
			_cur_speed = 0.0
			if _stuck > 1.5 and dist > 2.0:
				place_near_target()
		running = _cur_speed > 3.0
	position.y = Adv3DWorld.height_at(position.x, position.z)
	if not moving:
		# à l'arrêt : il regarde le joueur
		var to_t: Vector3 = target.position - position
		_facing = lerp_angle(_facing, atan2(to_t.x, to_t.z), clampf(delta * 5.0, 0.0, 1.0))
	var sitting: bool = not moving and _idle_time > 2.5 and dist < 1.2
	if _model != null:
		var flat: Vector3 = position - before
		flat.y = 0.0
		var real_speed: float = flat.length() / delta if delta > 0.0 else 0.0
		var to_p: Vector3 = target.position - position
		var look: float = wrapf(atan2(to_p.x, to_p.z) - _facing, -PI, PI)
		_model.rotation.y = _facing
		_model.animate(delta, real_speed, sitting, look)
		return
	_actor.set_running(running)
	_actor.set_sitting(sitting)
	_actor.set_facing(_facing, target.camera_yaw())
	_actor.animate(delta, 1.0 if moving else 0.0)
