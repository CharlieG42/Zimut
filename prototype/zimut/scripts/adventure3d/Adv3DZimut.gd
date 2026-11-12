class_name Adv3DZimut
extends Adv3DHeroRig
## Adv3DZimut.gd — Zimut, le personnage du joueur dans le monde 3D (V153).
##
## Un seul modèle pour toutes les classes : l'explorateur est le joueur lui-même, pas un héros de
## l'équipe. Modèle skinné (33 os, rig Mixamo) avec une seule animation, « Walk » (assets/zimut/zimut.glb,
## produit par tools/import_mixamo.gd). La marche est accélérée avec la vitesse (la course n'est que la
## marche à cadence élevée, légèrement penchée en avant). À l'arrêt, le personnage termine son pas puis se
## fige dans la pose « jambes jointes », avec une respiration légère.
##
## Même interface que Adv3DHeroRig : animate(delta, vitesse, rotation), run_amount(), stride(), force_fidget().

const PATH := "res://assets/zimut/zimut.glb"
const ANIM := "Walk"
const HEIGHT := 1.9              # taille du héros dans le monde (m)
const WALK_REF := 1.7            # m/s : vitesse à laquelle la cadence de l'animation est de 1×
const RUN_START := 3.2           # m/s : début de la « course » (penché en avant, cadence soutenue)
## Matériau toon : la texture du modèle est utilisée telle quelle (pas de recoloration par classe).
const SHADER := """
shader_type spatial;
render_mode cull_back, specular_disabled;
uniform sampler2D albedo_tex : source_color, filter_linear_mipmap, repeat_enable, hint_default_white;
uniform float emit = 0.12;
void fragment() {
	vec3 c = texture(albedo_tex, UV).rgb;
	ALBEDO = c;
	EMISSION = c * emit;
	ROUGHNESS = 0.9;
}
""" + Adv3DMeshes.TOON_LIGHT

static var _shader: Shader = null

const IDLE_PHASES: Array[float] = [0.0, 0.5]   # fractions du cycle où les jambes se croisent (pose de repos)

var _model: Node3D = null
var _player: AnimationPlayer = null
var _len: float = 1.0
var _spd: float = 0.0
var _run: float = 0.0
var _moving: bool = false
var _hold_t: float = 0.0          # position de la pose de repos tenue
var _prev_t: float = 0.0
var _clock: float = 0.0
var _bank_v: float = 0.0
var _scale: float = 1.0


static func available() -> bool:
	return ResourceLoader.exists(PATH)


static func make() -> Adv3DHeroRig:
	var rig := Adv3DZimut.new()
	rig.name = "Hero3D"
	Adv3DActors.add_shadow(rig, 0.6)
	var model: Node3D = (load(PATH) as PackedScene).instantiate() as Node3D
	rig._model = model
	rig.add_child(model)
	var top: float = 0.0
	for mi: Node in model.find_children("*", "MeshInstance3D", true, false):
		var m3 := mi as MeshInstance3D
		top = maxf(top, m3.get_aabb().end.y)
	rig._scale = HEIGHT / top if top > 0.0001 else 1.0
	model.scale = Vector3.ONE * rig._scale
	for mi2: Node in model.find_children("*", "MeshInstance3D", true, false):
		var m4 := mi2 as MeshInstance3D
		var src: Material = m4.mesh.surface_get_material(0)
		var tex: Texture2D = (src as BaseMaterial3D).albedo_texture if src is BaseMaterial3D else null
		var mat: ShaderMaterial = _toon(tex, rig._scale)
		for s: int in range(m4.mesh.get_surface_count()):
			m4.set_surface_override_material(s, mat)
		m4.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON if Adv3DMeshes.real_shadows \
			else GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	rig._player = model.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
	var a: Animation = rig._player.get_animation(ANIM)
	a.loop_mode = Animation.LOOP_LINEAR
	rig._len = a.length
	rig._hold_t = IDLE_PHASES[0] * rig._len
	rig._rest()
	return rig


static func _toon(tex: Texture2D, model_scale: float) -> ShaderMaterial:
	if _shader == null:
		_shader = Shader.new()
		_shader.code = SHADER
	var m := ShaderMaterial.new()
	m.shader = _shader
	m.set_shader_parameter("albedo_tex", tex)
	m.set_shader_parameter("shade_tint", Color(0.74, 0.76, 0.95))
	m.set_shader_parameter("rim", 0.45)
	m.set_shader_parameter("rim_color", Color(1.0, 0.93, 0.78))
	var ol := StandardMaterial3D.new()
	ol.specular_mode = BaseMaterial3D.SPECULAR_DISABLED
	ol.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	ol.cull_mode = BaseMaterial3D.CULL_FRONT
	ol.albedo_color = Color(0.14, 0.09, 0.07)
	ol.grow = true
	# le contour se règle dans l'espace du modèle (≈ 1/100e de mètre) : on le ramène à ≈ 5 mm
	ol.grow_amount = 0.005 / model_scale
	m.next_pass = ol
	return m


func setup() -> void:
	pass


## Pose de repos : jambes jointes, animation en pause.
func _rest() -> void:
	_moving = false
	_player.play(ANIM)
	_player.seek(_hold_t, true)
	_player.pause()


## Pour la cuisson des planches 2D et les tests : pose de marche à la phase donnée (0..1 du cycle).
func pose_walk(phase: float) -> void:
	_moving = false
	_player.play(ANIM)
	_player.seek(fposmod(phase, 1.0) * _len, true)
	_player.pause()
	_model.scale = Vector3.ONE * _scale


## Pose de repos « respirée » (phase 0..1 : un souffle) pour les planches 2D.
func pose_idle(phase: float) -> void:
	pose_walk(IDLE_PHASES[0])
	var b: float = 0.5 - 0.5 * cos(phase * TAU)
	_model.scale = Vector3.ONE * (1.0 + 0.004 * b) * _scale


func animate(delta: float, speed: float, turn_rate: float) -> void:
	_spd = lerpf(_spd, speed, 1.0 - exp(-delta * 10.0))
	_run = lerpf(_run, clampf((_spd - RUN_START) / 1.7, 0.0, 1.0), 1.0 - exp(-delta * 6.0))
	_clock += delta
	if _spd >= 0.25:
		var rate: float = clampf(_spd / WALK_REF, 0.6, 2.6)
		if not _moving:
			_moving = true
			_player.play(ANIM)
			_player.seek(_hold_t, true)
		_player.speed_scale = rate
		_prev_t = _player.current_animation_position
	elif _moving:
		# on termine le pas : arrêt dès que les jambes se croisent (ou tout de suite si le pas est presque fini)
		_player.speed_scale = maxf(_player.speed_scale, 1.0)
		var cur: float = _player.current_animation_position
		for ph: float in IDLE_PHASES:
			var tt: float = ph * _len
			if (_prev_t <= tt and cur >= tt) or (cur < _prev_t and (tt >= _prev_t or tt <= cur)):
				_hold_t = tt
				_rest()
				break
		_prev_t = cur
	# respiration à l'arrêt
	if not _moving:
		var b: float = 0.5 - 0.5 * cos(_clock * 1.9)
		_model.scale = Vector3.ONE * (1.0 + 0.004 * b) * _scale
	else:
		_model.scale = Vector3.ONE * _scale
	# virage : le corps s'incline vers l'intérieur ; en course, il se penche en avant
	var bank_goal: float = clampf(-turn_rate * 0.045, -0.12, 0.12) * clampf(_spd / 2.0, 0.0, 1.0)
	_bank_v = lerpf(_bank_v, bank_goal, 1.0 - exp(-delta * 7.0))
	_model.rotation.z = _bank_v
	_model.rotation.x = 0.10 * _run


## Pas de petit mouvement au repos : le modèle n'a qu'une animation, donc rien à jouer.
func force_fidget() -> void:
	pass


func run_amount() -> float:
	return _run


## Pour les tests : « amplitude du pas » (≈ 0 à l'arrêt, > 0,35 en marche).
func stride() -> float:
	return clampf(_spd / 1.4, 0.0, 1.0) * 0.8
