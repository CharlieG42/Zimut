class_name Adv3DKayKit
extends Adv3DHeroRig
## Adv3DKayKit.gd — Héros 3D basés sur « KayKit : Adventurers 2.0 » (Kay Lousberg, CC0 — assets/kaykit/).
##
## Remplace le héros procédural : vrai modèle skinné (23 os) animé par les animations « Rig_Medium »
## (repos, marche, course). Le rendu reprend le style du monde : éclairage cartoon, ombres du soleil,
## contour fin. Les classes sans modèle propre réutilisent un modèle avec une recoloration (teinte des
## étoffes, métal teinté) faite dans le shader : la peau et le cuir ne changent pas.
##
## Même interface que Adv3DHeroRig : animate(delta, vitesse, rotation), run_amount(), stride(), force_fidget().

const DIR := "res://assets/kaykit/"
const HEIGHT := 1.95            # taille voulue du héros dans le monde (m)
const RUN_START := 3.2          # m/s : la course commence
const WALK_REF := 2.3           # m/s : vitesse de référence de l'animation de marche
const RUN_REF := 5.0

## classe → modèle + recoloration. hue = décalage de teinte (tour = 1.0) des étoffes colorées ;
## sat / val = multiplicateurs ; grey = teinte appliquée au métal / tissus gris (mix 0..1).
const LOOKS: Dictionary = {
	"Tank":       {"model": "Knight"},
	"Mage":       {"model": "Mage"},
	"Chasseur":   {"model": "Ranger"},
	"Assassin":   {"model": "Rogue_Hooded", "hue": 0.50, "sat": 0.85, "val": 0.72},
	"Sylvain":    {"model": "Rogue"},
	"Druide":     {"model": "Barbarian", "grey": Color(0.62, 0.52, 0.34), "grey_mix": 0.65},
	"Heal":       {"model": "Mage", "hue": 0.40, "sat": 0.45, "val": 1.55},
	"Invocateur": {"model": "Mage", "hue": 0.02, "sat": 0.9, "val": 0.62},
	"Géomancien": {"model": "Knight", "grey": Color(0.78, 0.60, 0.34), "grey_mix": 0.85},
	"Artificier": {"model": "Ranger", "hue": 0.48, "sat": 1.1, "val": 1.0, "grey": Color(0.86, 0.52, 0.30), "grey_mix": 0.7},
}

const SHADER := """
shader_type spatial;
render_mode cull_back, specular_disabled;
uniform sampler2D albedo_tex : filter_linear_mipmap, repeat_enable, hint_default_white;
uniform float hue_shift = 0.0;
uniform float sat_mul = 1.0;
uniform float val_mul = 1.0;
uniform vec3 grey_tint : source_color = vec3(1.0);
uniform float grey_mix = 0.0;
uniform float emit = 0.14;
vec3 rgb2hsv(vec3 c) {
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
vec3 hsv2rgb(vec3 c) {
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
void fragment() {
	vec3 c = texture(albedo_tex, UV).rgb;
	vec3 hsv = rgb2hsv(c);
	// étoffes colorées : saturées et hors des teintes chair / cuir / bois (0 – 0,13)
	float cloth = smoothstep(0.18, 0.30, hsv.y) * smoothstep(0.10, 0.16, hsv.x) * (1.0 - smoothstep(0.96, 0.99, hsv.x));
	vec3 shifted = hsv2rgb(vec3(fract(hsv.x + hue_shift), clamp(hsv.y * sat_mul, 0.0, 1.0), clamp(hsv.z * val_mul, 0.0, 1.0)));
	c = mix(c, shifted, cloth);
	// métal / tissus gris
	float grey = (1.0 - smoothstep(0.10, 0.20, hsv.y)) * smoothstep(0.18, 0.40, hsv.z) * grey_mix;
	vec3 tinted = c * (grey_tint * 1.7) * val_mul;
	c = mix(c, tinted, grey);
	ALBEDO = pow(max(c, vec3(0.0)), vec3(2.2));
	EMISSION = ALBEDO * emit;
	ROUGHNESS = 0.9;
}
""" + Adv3DMeshes.TOON_LIGHT

static var _shader: Shader = null
static var _anims: Dictionary = {}     # nom → Animation (partagées entre tous les héros)

var _model: Node3D = null
var _player: AnimationPlayer = null
var _cur: String = ""
var _spd: float = 0.0
var _run: float = 0.0
var _still_t: float = 0.0
var _fidget_left: float = -1.0
var _kfid_wait: float = 8.0
var _bank_v: float = 0.0


## Modèles et animations présents ? (sinon on garde le héros procédural)
static func available() -> bool:
	return ResourceLoader.exists(DIR + "Knight.glb") and ResourceLoader.exists(DIR + "Rig_Medium_MovementBasic.glb")


static func look_for(classe: String) -> Dictionary:
	if LOOKS.has(classe):
		return LOOKS[classe]
	return LOOKS["Sylvain"]


static func _toon(tex: Texture2D, look: Dictionary) -> ShaderMaterial:
	if _shader == null:
		_shader = Shader.new()
		_shader.code = SHADER
	var m := ShaderMaterial.new()
	m.shader = _shader
	m.set_shader_parameter("albedo_tex", tex)
	m.set_shader_parameter("hue_shift", float(look.get("hue", 0.0)))
	m.set_shader_parameter("sat_mul", float(look.get("sat", 1.0)))
	m.set_shader_parameter("val_mul", float(look.get("val", 1.0)))
	m.set_shader_parameter("grey_tint", look.get("grey", Color.WHITE))
	m.set_shader_parameter("grey_mix", float(look.get("grey_mix", 0.0)))
	m.set_shader_parameter("shade_tint", Color(0.74, 0.76, 0.95))
	m.set_shader_parameter("rim", 0.5)
	m.set_shader_parameter("rim_color", Color(1.0, 0.93, 0.78))
	var ol := StandardMaterial3D.new()
	ol.specular_mode = BaseMaterial3D.SPECULAR_DISABLED
	ol.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	ol.cull_mode = BaseMaterial3D.CULL_FRONT
	ol.albedo_color = Color(0.14, 0.09, 0.07)
	ol.grow = true
	ol.grow_amount = 0.006
	m.next_pass = ol
	return m


## Animations Rig_Medium (une seule lecture des fichiers, partagée).
static func _load_anims() -> void:
	if not _anims.is_empty():
		return
	var loops := ["Idle_A", "Idle_B", "Walking_A", "Walking_B", "Walking_C", "Running_A", "Running_B", "Jump_Idle"]
	for f: String in ["Rig_Medium_General", "Rig_Medium_MovementBasic"]:
		var ps := load(DIR + f + ".glb") as PackedScene
		if ps == null:
			continue
		var inst: Node = ps.instantiate()
		var ap: AnimationPlayer = inst.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
		for nm: String in ap.get_animation_list():
			var a: Animation = ap.get_animation(nm).duplicate()
			a.loop_mode = Animation.LOOP_LINEAR if nm in loops else Animation.LOOP_NONE
			_anims[nm] = a
		inst.free()


static func make(classe: String) -> Adv3DHeroRig:
	var look: Dictionary = look_for(classe)
	var rig := Adv3DKayKit.new()
	rig.name = "Hero3D"
	Adv3DActors.add_shadow(rig, 0.6)
	var ps := load(DIR + String(look["model"]) + ".glb") as PackedScene
	var model: Node3D = ps.instantiate() as Node3D
	rig._model = model
	rig.add_child(model)
	# taille : on mesure le maillage au repos et on met à l'échelle
	var top: float = 0.0
	var skel: Skeleton3D = model.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	for mi: Node in model.find_children("*", "MeshInstance3D", true, false):
		var m3 := mi as MeshInstance3D
		top = maxf(top, m3.get_aabb().end.y)
		var src: Material = m3.mesh.surface_get_material(0)
		var tex: Texture2D = (src as BaseMaterial3D).albedo_texture if src is BaseMaterial3D else null
		var mat: ShaderMaterial = _toon(tex, look)
		for s: int in range(m3.mesh.get_surface_count()):
			m3.set_surface_override_material(s, mat)
		m3.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON if Adv3DMeshes.real_shadows \
			else GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	if top > 0.01:
		model.scale = Vector3.ONE * (HEIGHT / top)
	# animations
	_load_anims()
	var ap := AnimationPlayer.new()
	ap.name = "Anim"
	model.add_child(ap)
	ap.root_node = NodePath("..")
	var lib := AnimationLibrary.new()
	for nm: String in _anims.keys():
		lib.add_animation(nm, _anims[nm])
	ap.add_animation_library("", lib)
	rig._player = ap
	rig._play("Idle_A", 0.0)
	return rig


func setup() -> void:
	pass


func _play(nm: String, blend: float = 0.22) -> void:
	if nm == _cur or _player == null or not _player.has_animation(nm):
		return
	_cur = nm
	_player.play(nm, blend)


func animate(delta: float, speed: float, turn_rate: float) -> void:
	_spd = lerpf(_spd, speed, 1.0 - exp(-delta * 10.0))
	_run = lerpf(_run, clampf((_spd - RUN_START) / 1.7, 0.0, 1.0), 1.0 - exp(-delta * 6.0))
	if _spd < 0.25:
		_still_t += delta
		_kfid_wait -= delta
		if _fidget_left >= 0.0:
			_fidget_left -= delta
			if _fidget_left < 0.0:
				_play("Idle_A", 0.3)
		elif _kfid_wait <= 0.0:
			force_fidget()
		_player.speed_scale = 1.0
		if _fidget_left < 0.0:
			_play("Idle_A", 0.3)
	else:
		_still_t = 0.0
		_fidget_left = -1.0
		_kfid_wait = randf_range(7.0, 12.0)
		if _spd < RUN_START:
			_play("Walking_A", 0.2)
			_player.speed_scale = clampf(_spd / WALK_REF, 0.55, 1.7)
		else:
			_play("Running_A", 0.2)
			_player.speed_scale = clampf(_spd / RUN_REF, 0.8, 1.35)
	# virage : le corps s'incline légèrement vers l'intérieur
	var bank_goal: float = clampf(-turn_rate * 0.045, -0.12, 0.12) * clampf(_spd / 2.0, 0.0, 1.0)
	_bank_v = lerpf(_bank_v, bank_goal, 1.0 - exp(-delta * 7.0))
	_model.rotation.z = _bank_v


## Petit mouvement au repos (Idle_B) ; lancé de temps en temps ou à la demande.
func force_fidget() -> void:
	_fidget_left = 2.6
	_kfid_wait = randf_range(8.0, 14.0)
	_play("Idle_B", 0.3)


func run_amount() -> float:
	return _run


## Pour les tests : « amplitude du pas » (≈ 0 à l'arrêt, > 0,35 en marche).
func stride() -> float:
	return clampf(_spd / 1.4, 0.0, 1.0) * 0.8
