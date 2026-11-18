extends Node3D
## Cinematic3D.gd — Cinématique d'ouverture en 3D (combat des héros contre les deux boss),
## jouée entre l'intro des Pierres (Intro.tscn) et l'accueil (MainMenu.tscn) quand le réglage
## « Cinématique 3D » est actif (GameSettings.cinematic_3d ; éteint par défaut sur mobile).
##
## Les vrais modèles .glb des héros (assets/heroes3d/, clés de Hero3D.MODELS) affrontent DEUX
## BOSS DIFFÉRENTS (Tharok = Gobelin Roi, Vorkann = Troll de givre : deux vrais modèles de boss, plus
## de héros côté ennemi) dans une arène Kenney, avec
## le même rendu toon que le combat (Hero3D.SHADER + texture « pad » + teinte). La timeline est
## entièrement pilotée par _t (déterministe) : travelling caméra, entrée des héros, apparition
## des boss, combat (assauts des héros avec impacts/flash/recul, barres de PV des boss, chute du
## boss vaincu via le clip « Dead » quand il existe), logo, letterbox. Toute entrée passe.
## Le rendu 3D lui-même ne se teste pas en headless : tests/test_cinematic3d.gd couvre la logique.

const SCENE := "res://scenes/Cinematic3D.tscn"
const NEXT_SCENE := "res://scenes/MainMenu.tscn"
const DURATION := 13.5
const BAR_FRAC := 0.11          # hauteur des barres de ciné (fraction de la hauteur d'écran)
const HERO_H := 1.8             # même hauteur normalisée que Hero3D
const LOGO_PATH := "res://assets/ui/logo_intro.png"

## Héros montrés (clés de Hero3D.MODELS), de gauche à droite.
const LINEUP: Array[String] = ["Tank", "Chasseur", "Sylvain", "Ingénieur", "Invocateur"]
## Les deux boss 3D du jeu (deux VRAIS modèles de boss, plus de héros côté ennemi) :
## modèle, teinte, échelle, position x, couleur des effets.
const BOSSES: Array = [
	{"model": "Tharok", "tint": Color(0.70, 1.0, 0.70), "k": 1.35, "x": -2.6, "fx": Color(0.55, 1.0, 0.40)},    # Gobelin Roi
	{"model": "Vorkann", "tint": Color(0.88, 0.96, 1.0), "k": 1.55, "x": 2.6, "fx": Color(0.50, 0.80, 1.0)},    # Troll de givre
]

## Effets visuels des héros (couleur, forme du projectile, taille) — clés de LINEUP.
const HERO_FX: Dictionary = {
	"Tank": {"col": Color(1.0, 0.82, 0.40), "bolt": false, "size": 0.17},
	"Chasseur": {"col": Color(0.65, 1.0, 0.55), "bolt": true, "size": 0.07},
	"Sylvain": {"col": Color(0.45, 1.0, 0.60), "bolt": false, "size": 0.20},
	"Ingénieur": {"col": Color(1.0, 0.60, 0.25), "bolt": false, "size": 0.18},
	"Invocateur": {"col": Color(0.78, 0.52, 1.0), "bolt": false, "size": 0.20},
}
const ENTER_DUR := 2.2          # durée de la marche d'entrée d'un acteur

## Chorégraphie du combat.
const BOSS_HP := 100
const DMG := 30                 # dégâts par impact de héros
const ROAR_T := 5.8             # les boss attaquent une première fois
const ATK_T := 6.6              # premier assaut des héros (puis tous les 0,35 s)
const ATK_STEP := 0.35
const IMPACT_DELAY := 0.5       # délai entre le geste du héros et l'impact chez le boss
const COUNTER_T := 8.8          # contre-attaque des boss encore vivants
const VOLLEY_T := 9.8           # volée finale des héros
const FINAL_T := 10.3           # impact final qui abat le premier boss
const FINAL_DMG := 60

## Même shader toon que Hero3D, plus une teinte (différencier les deux boss).
const SHADER := """
shader_type spatial;
render_mode cull_back, unshaded;
uniform sampler2D albedo_tex : source_color, filter_linear_mipmap_anisotropic, repeat_enable, hint_default_white;
uniform float gain = 1.0;
uniform float gamma = 1.0;
uniform vec3 tint = vec3(1.0, 1.0, 1.0);
const vec3 LDIR = vec3(-0.36, 0.62, 0.70);
void fragment() {
	vec3 c = pow(texture(albedo_tex, UV, -0.5).rgb, vec3(gamma)) * gain * tint;
	float h = dot(normalize(NORMAL), normalize(LDIR)) * 0.5 + 0.5;
	float band = smoothstep(0.34, 0.50, h) * 0.6 + smoothstep(0.66, 0.80, h) * 0.4;
	vec3 shade = mix(vec3(0.60, 0.64, 0.86), vec3(1.06, 1.04, 1.0), band);
	ALBEDO = c * shade;
}
"""

## Clés de caméra : [t, position, cible du regard].
const CAM_KEYS: Array = [
	[0.0, Vector3(0, 3.8, 13.8), Vector3(0, 1.4, -1)],
	[4.0, Vector3(0, 2.9, 10.6), Vector3(0, 1.5, -2)],
	[5.8, Vector3(0.4, 2.5, 8.4), Vector3(0, 1.8, -4.5)],
	[8.8, Vector3(0, 2.8, 9.6), Vector3(0, 1.6, -3)],
	[10.6, Vector3(-1.4, 2.3, 7.4), Vector3(-2.6, 1.2, -5.4)],
	[DURATION, Vector3(0, 3.4, 11.8), Vector3(0, 1.4, -1)],
]

var _t: float = 0.0
var _leaving: bool = false
var _did: Dictionary = {}
var _cam: Camera3D
var _actors: Array = []         # {holder, ap, key, walk, home, from, enter_t, boss, mode, mode_t, k, hp, jolt_t, dead, fall_t, dead_clip}
var _bars: Array = []           # {bg: ColorRect, fill: ColorRect, actor: Dictionary} — PV des boss
var _ui: CanvasLayer
var _bar_top: ColorRect
var _bar_bot: ColorRect
var _flash: ColorRect
var _flash_amp: float = 0.0
var _flash_t: float = -1.0
var _logo: TextureRect
var _hint: Label
var _fade: ColorRect
var _fx: Array = []             # effets visuels en cours : {node, t0, dur, kind, ...}
var _shake_amp: float = 0.0
var _shake_t: float = -10.0


## La cinématique est-elle activée ? (réglage GameSettings.cinematic_3d, lu via l'arbre).
static func enabled() -> bool:
	var tree := Engine.get_main_loop() as SceneTree
	if tree == null:
		return true
	var gs: Node = tree.root.get_node_or_null("GameSettings")
	return true if gs == null else bool(gs.get("cinematic_3d"))


func _ready() -> void:
	if not enabled():
		_skip()
		return
	ResourceLoader.load_threaded_request(NEXT_SCENE)
	_build_world()
	_build_ui()
	_spawn_actors()
	_cam = Camera3D.new()
	_cam.fov = 50.0
	_cam.near = 0.1
	_cam.far = 60.0
	add_child(_cam)
	_cam.current = true
	_make_hp_bars()
	get_viewport().size_changed.connect(_fit_ui)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseButton or event is InputEventScreenTouch:
		_skip()


func _process(delta: float) -> void:
	if _leaving:
		return
	_t += delta
	_update_bars()
	_update_camera()
	_update_actors()
	_update_overlay()
	_update_hp_bars()
	_update_fx()
	if _t >= DURATION:
		_skip()


## — Monde : arène sombre (sol, 6 colonnes en retrait des couloirs d'entrée, statue au fond).
func _build_world() -> void:
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.03, 0.035, 0.06)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.45, 0.52, 0.72)
	env.ambient_light_energy = 0.5
	env.fog_enabled = true
	env.fog_light_color = Color(0.05, 0.06, 0.10)
	env.fog_density = 0.028
	var we := WorldEnvironment.new()
	we.environment = env
	add_child(we)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-48, -35, 0)
	sun.light_color = Color(1.0, 0.93, 0.82)
	sun.light_energy = 1.1
	add_child(sun)
	var fill := DirectionalLight3D.new()
	fill.rotation_degrees = Vector3(-30, 140, 0)
	fill.light_color = Color(0.55, 0.65, 0.95)
	fill.light_energy = 0.4
	add_child(fill)
	var glow := OmniLight3D.new()
	glow.position = Vector3(0, 5.0, 3.0)
	glow.light_color = Color(0.75, 0.85, 1.0)
	glow.light_energy = 0.6
	glow.omni_range = 20.0
	add_child(glow)
	# sol : grande dalle sombre + disque central plus clair ( assez large pour les entrées
	# des personnages, qui restent dessus : pas de chevauchement avec le bord)
	var floor_mat := StandardMaterial3D.new()
	floor_mat.albedo_color = Color(0.16, 0.15, 0.18)
	floor_mat.roughness = 1.0
	var floor_mesh := CylinderMesh.new()
	floor_mesh.top_radius = 13.0
	floor_mesh.bottom_radius = 13.5
	floor_mesh.height = 0.3
	var floor_mi := MeshInstance3D.new()
	floor_mi.mesh = floor_mesh
	floor_mi.position = Vector3(0, -0.15, 0)
	floor_mi.set_surface_override_material(0, floor_mat)
	add_child(floor_mi)
	var ring_mat := StandardMaterial3D.new()
	ring_mat.albedo_color = Color(0.24, 0.21, 0.27)
	ring_mat.roughness = 1.0
	var ring_mesh := CylinderMesh.new()
	ring_mesh.top_radius = 6.5
	ring_mesh.bottom_radius = 6.5
	ring_mesh.height = 0.06
	var ring_mi := MeshInstance3D.new()
	ring_mi.mesh = ring_mesh
	ring_mi.position = Vector3(0, 0.01, 0)
	ring_mi.set_surface_override_material(0, ring_mat)
	add_child(ring_mi)
	# colonnes à 60° (pas à 90°/270° : couloirs d'entrée des héros/boss au centre avant/arrière)
	_add_kit_prop("column", 6, 10.4, 4.4)
	_add_kit_prop("statue", 1, 0.0, 3.4, Vector3(0, 0, -12.6), 180.0)


func _add_kit_prop(model: String, count: int, radius: float, height: float, at := Vector3.ZERO, yaw := 0.0) -> void:
	var mesh: Mesh = Adv3DKit.arena(model)
	if mesh == null:
		return
	var s: float = height / maxf(mesh.get_aabb().size.y, 0.001)
	for i: int in range(count):
		var mi := MeshInstance3D.new()
		mi.mesh = mesh
		mi.scale = Vector3.ONE * s
		if count > 1:
			var a := TAU * float(i) / float(count)
			mi.position = Vector3(cos(a) * radius, mesh.get_aabb().size.y * s * 0.5 - 0.15, sin(a) * radius)
			mi.rotation_degrees.y = -rad_to_deg(a)
		else:
			mi.position = Vector3(at.x, mesh.get_aabb().size.y * s * 0.5 - 0.15, at.z)
			mi.rotation_degrees.y = yaw
		add_child(mi)


## — UI : letterbox, flash, logo, indice, fondu au noir (au-dessus de la 3D).
func _build_ui() -> void:
	_ui = CanvasLayer.new()
	_ui.layer = 100
	add_child(_ui)
	_bar_top = _mk_rect(Color(0, 0, 0))
	_bar_top.anchor_right = 1.0
	_bar_top.anchor_bottom = 0.0
	_bar_top.offset_bottom = 0.0
	_bar_bot = _mk_rect(Color(0, 0, 0))
	_bar_bot.anchor_top = 1.0
	_bar_bot.anchor_bottom = 1.0
	_bar_bot.anchor_right = 1.0
	_bar_bot.offset_top = 0.0
	_flash = _mk_rect(Color(1, 1, 1))
	_flash.modulate.a = 0.0
	_logo = TextureRect.new()
	_logo.texture = load(LOGO_PATH) as Texture2D
	_logo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_logo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_logo.modulate.a = 0.0
	_logo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_ui.add_child(_logo)
	_hint = Label.new()
	_hint.text = "Touchez pour passer"
	_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_hint.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_hint.add_theme_font_size_override("font_size", 18)
	_hint.add_theme_color_override("font_color", Color(1, 1, 1))
	_hint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_hint.anchor_right = 1.0
	_hint.anchor_top = 1.0
	_hint.anchor_bottom = 1.0
	_ui.add_child(_hint)
	_fade = _mk_rect(Color(0, 0, 0))
	_fade.modulate.a = 0.0
	_fit_ui()


func _mk_rect(col: Color) -> ColorRect:
	var r := ColorRect.new()
	r.color = col
	r.set_anchors_preset(Control.PRESET_FULL_RECT)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_ui.add_child(r)
	return r


func _fit_ui() -> void:
	if _logo == null or _logo.texture == null:
		return
	var vs: Vector2 = get_viewport().get_visible_rect().size
	var h: float = vs.y * 0.30
	var w: float = h * float(_logo.texture.get_width()) / float(_logo.texture.get_height())
	_logo.anchor_left = 0.5
	_logo.anchor_top = 0.5
	_logo.anchor_right = 0.5
	_logo.anchor_bottom = 0.5
	_logo.offset_left = -w * 0.5
	_logo.offset_top = -h * 0.5
	_logo.offset_right = w * 0.5
	_logo.offset_bottom = h * 0.5
	_hint.offset_bottom = 0.0
	_update_bars()


## — Personnages : instancie un .glb, matériau toon teinté, échelle normalisée, clips.
func _spawn_actors() -> void:
	var n: int = LINEUP.size()
	for i: int in range(n):
		var key := LINEUP[i]
		# entrée par l'avant (couloir central libre, sur le sol) : pas de chevauchement avec les colonnes
		var home := Vector3(lerpf(-3.2, 3.2, (float(i) + 0.5) / float(n)), 0.0, 4.0)
		var from := home + Vector3(0.0, 0.0, 7.5)
		var a: Dictionary = _spawn(key, from, 180.0, Color(1, 1, 1), 1.0)
		a["key"] = key
		a["home"] = home
		a["from"] = from
		a["enter_t"] = 1.2 + float(i) * 0.25
		a["boss"] = false
		a["fx"] = (HERO_FX.get(key, {}) as Dictionary).get("col", Color(0.8, 0.9, 1.0))
		_actors.append(a)
	for b: Dictionary in BOSSES:
		# entrée par l'arrière, de part et d'autre de la statue
		var home := Vector3(float(b["x"]), 0.0, -5.4)
		var from := home + Vector3(0, 0, -6.6)
		var a: Dictionary = _spawn(String(b["model"]), from, 0.0, b["tint"], float(b["k"]))
		a["key"] = String(b["model"])
		a["home"] = home
		a["from"] = from
		a["enter_t"] = 4.2
		a["boss"] = true
		a["fx"] = b.get("fx", Color(1.0, 0.5, 0.3))
		a["hp"] = BOSS_HP
		a["jolt_t"] = -1.0
		a["dead"] = false
		_actors.append(a)


func _spawn(key: String, pos: Vector3, yaw: float, tint: Color, k: float) -> Dictionary:
	var out := {"holder": null, "ap": null, "walk": "Walking", "mode": "walk", "mode_t": 0.0, "k": k}
	if not Hero3D.MODELS.has(key):
		return out
	var prof: Dictionary = Hero3D.MODELS[key]
	var ps: PackedScene = load(String(prof["path"]))
	if ps == null:
		return out
	var holder := Node3D.new()
	holder.position = pos
	holder.rotation_degrees.y = yaw
	add_child(holder)
	var inst: Node3D = ps.instantiate()
	holder.add_child(inst)
	var tex: Texture2D = null
	var pad_path: String = String(prof["path"]).get_basename() + "_albedo_pad.webp"
	if ResourceLoader.exists(pad_path):
		tex = load(pad_path) as Texture2D
	var sh := Shader.new()
	sh.code = SHADER
	var mat := ShaderMaterial.new()
	mat.shader = sh
	mat.set_shader_parameter("gain", float(prof.get("gain", 1.0)))
	mat.set_shader_parameter("tint", tint)
	var mis: Array = inst.find_children("*", "MeshInstance3D", true, false)
	if tex == null and not mis.is_empty():
		var src: Material = (mis[0] as MeshInstance3D).mesh.surface_get_material(0)
		if src is BaseMaterial3D:
			tex = (src as BaseMaterial3D).albedo_texture
	if tex != null:
		mat.set_shader_parameter("albedo_tex", tex)
	for mi: MeshInstance3D in mis:
		for s: int in range(mi.mesh.get_surface_count()):
			mi.set_surface_override_material(s, mat)
	# échelle normalisée sur la boîte englobante des maillages, pieds ramenés en y = 0
	var lo := Vector3(1e9, 1e9, 1e9)
	var hi := Vector3(-1e9, -1e9, -1e9)
	for mi: MeshInstance3D in mis:
		var box: AABB = mi.transform * mi.get_aabb()
		lo = lo.min(box.position)
		hi = hi.max(box.position + box.size)
	var s: float = HERO_H * k / maxf(hi.y - lo.y, 0.0001)
	inst.scale = Vector3.ONE * s
	inst.position = Vector3(-(lo.x + hi.x) * 0.5 * s, -lo.y * s, -(lo.z + hi.z) * 0.5 * s)
	var clips: Dictionary = prof.get("clips", {})
	out["walk"] = String((clips.get("walk", {}) as Dictionary).get("clip", "Walking"))
	var aps: Array = inst.find_children("*", "AnimationPlayer", true, false)
	if not aps.is_empty():
		var ap := aps[0] as AnimationPlayer
		if ap.has_animation(out["walk"]):
			ap.get_animation(out["walk"]).loop_mode = Animation.LOOP_LINEAR
			ap.play(out["walk"])
		out["ap"] = ap
	out["holder"] = holder
	return out


## — Barres de PV au-dessus des boss (projetées depuis la caméra).
func _make_hp_bars() -> void:
	for bi: int in range(LINEUP.size(), _actors.size()):
		var a: Dictionary = _actors[bi]
		if a["holder"] == null:
			continue
		var bg := ColorRect.new()
		bg.color = Color(0, 0, 0, 0.55)
		bg.size = Vector2(64, 7)
		bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_ui.add_child(bg)
		var fill := ColorRect.new()
		fill.color = Color(0.9, 0.25, 0.2)
		fill.position = Vector2(1, 1)
		fill.size = Vector2(62, 5)
		fill.mouse_filter = Control.MOUSE_FILTER_IGNORE
		bg.add_child(fill)
		_bars.append({"bg": bg, "fill": fill, "actor": a})


func _update_hp_bars() -> void:
	for b: Dictionary in _bars:
		var a: Dictionary = b["actor"]
		var holder: Node3D = a["holder"]
		if holder == null or _cam == null:
			continue
		var head := holder.global_position + Vector3(0, HERO_H * float(a.get("k", 1.0)) + 0.4, 0)
		if _cam.is_position_behind(head):
			(b["bg"] as ColorRect).visible = false
			continue
		var sp := _cam.unproject_position(head)
		var bg := b["bg"] as ColorRect
		bg.visible = true
		bg.position = sp - Vector2(32, 10)
		var frac: float = clampf(float(a.get("hp", BOSS_HP)) / float(BOSS_HP), 0.0, 1.0)
		var fill := b["fill"] as ColorRect
		fill.size = Vector2(62.0 * frac, 5.0)
		fill.color = Color(0.9, 0.25, 0.2).lerp(Color(0.3, 0.85, 0.3), frac)


## — Combat : un clip one-shot, puis retour à la marche.
func _play_once(a: Dictionary, action: String) -> void:
	var ap: AnimationPlayer = a["ap"]
	if ap == null:
		return
	var clips: Dictionary = (Hero3D.MODELS.get(String(a.get("key", "")), {}) as Dictionary).get("clips", {})
	var clip: String = String((clips.get(action, {}) as Dictionary).get("clip", ""))
	if clip != "" and ap.has_animation(clip):
		ap.play(clip)
		a["mode"] = "once"
		a["mode_t"] = _t


func _trigger(t: float, key: String, cb: Callable) -> void:
	if _t >= t and not _did.has(key):
		_did[key] = true
		cb.call()


func _roar() -> void:
	for bi: int in range(LINEUP.size(), _actors.size()):
		_play_once(_actors[bi], "attack")
		_shockwave(bi)
	_flash_amp = 0.4
	_flash_t = _t
	_shake(0.16)


func _hero_strike(i: int, target_bi: int = -1) -> void:
	if i >= _actors.size():
		return
	var a: Dictionary = _actors[i]
	if a["holder"] == null or bool(a.get("dead", false)):
		return
	_play_once(a, "cast" if i == 2 else "attack")
	var tbi: int = target_bi if target_bi >= 0 else LINEUP.size() + (i % 2)
	_fire_projectile(i, tbi)


## Impact d'un assaut de héros sur le boss ciblé (alternance gauche/droite).
func _impact(i: int) -> void:
	_boss_hit(LINEUP.size() + (i % 2), DMG)


func _counter() -> void:
	for bi: int in range(LINEUP.size(), _actors.size()):
		var b: Dictionary = _actors[bi]
		if b["holder"] != null and not bool(b.get("dead", false)):
			_play_once(b, "attack")
			_shockwave(bi)
	_flash_amp = 0.35
	_flash_t = _t
	_shake(0.12)


func _volley() -> void:
	for i: int in range(LINEUP.size()):
		_hero_strike(i, LINEUP.size())   # toute la volée converge sur le premier boss


func _impact_final() -> void:
	_boss_hit(LINEUP.size(), FINAL_DMG)


## Le boss ciblé encaisse : recul, flash, PV ; à 0 PV il chute (clip « Dead » s'il existe).
func _boss_hit(bi: int, dmg: int) -> void:
	if bi >= _actors.size():
		return
	var b: Dictionary = _actors[bi]
	if b["holder"] == null or bool(b.get("dead", false)):
		return
	b["hp"] = int(b.get("hp", BOSS_HP)) - dmg
	b["jolt_t"] = _t
	_flash_amp = 0.5
	_flash_t = _t
	_impact_fx(b, dmg)
	if int(b["hp"]) <= 0:
		b["dead"] = true
		b["fall_t"] = _t
		_flash_amp = 0.9
		_flash_t = _t
		_death_fx(b)
		var ap: AnimationPlayer = b["ap"]
		if ap != null and ap.has_animation("Dead"):
			b["dead_clip"] = true
			ap.play("Dead")


func _seg(t0: float, t1: float) -> float:
	return smoothstep(0.0, 1.0, clampf((_t - t0) / maxf(t1 - t0, 0.0001), 0.0, 1.0))


func _ease(x: float) -> float:
	x = clampf(x, 0.0, 1.0)
	return x * x * (3.0 - 2.0 * x)


func _update_bars() -> void:
	if _bar_top == null:
		return
	var vs: Vector2 = get_viewport().get_visible_rect().size
	var h: float = vs.y * BAR_FRAC * _seg(0.15, 0.9) * (1.0 - _seg(12.8, DURATION))
	_bar_top.offset_bottom = h
	_bar_bot.offset_top = -h
	_hint.offset_top = -h
	_hint.modulate.a = clampf((_t - 0.6) * 2.0, 0.0, 0.55) * (1.0 - _seg(12.8, DURATION))


func _update_camera() -> void:
	if _cam == null:
		return
	var pos: Vector3 = CAM_KEYS[0][1]
	var tgt: Vector3 = CAM_KEYS[0][2]
	for i: int in range(CAM_KEYS.size() - 1):
		var k0: Array = CAM_KEYS[i]
		var k1: Array = CAM_KEYS[i + 1]
		if _t >= float(k0[0]) and _t <= float(k1[0]):
			var f: float = _ease(clampf((_t - float(k0[0])) / maxf(float(k1[0]) - float(k0[0]), 0.001), 0.0, 1.0))
			pos = (k0[1] as Vector3).lerp(k1[1] as Vector3, f)
			tgt = (k0[2] as Vector3).lerp(k1[2] as Vector3, f)
			break
	var sh: float = _shake_amp * maxf(0.0, 1.0 - (_t - _shake_t) / 0.55)
	if sh > 0.0:
		pos += Vector3(sin(_t * 71.0), cos(_t * 53.0), sin(_t * 37.0)) * sh
	_cam.position = pos
	_cam.look_at(tgt)


func _update_actors() -> void:
	for i: int in range(_actors.size()):
		var a: Dictionary = _actors[i]
		var holder: Node3D = a["holder"]
		if holder == null:
			continue
		var k: float = _ease(_seg(float(a["enter_t"]), float(a["enter_t"]) + 2.2))
		var p: Vector3 = (a["from"] as Vector3).lerp(a["home"] as Vector3, k)
		# recul d'impact (le boss est repoussé vers l'arrière)
		if float(a.get("jolt_t", -1.0)) >= 0.0:
			p.z -= 0.35 * maxf(0.0, 1.0 - (_t - float(a["jolt_t"])) / 0.45)
		# chute du boss vaincu
		if bool(a.get("dead", false)):
			var f: float = _ease(_seg(float(a["fall_t"]), float(a["fall_t"]) + 0.8))
			if not bool(a.get("dead_clip", false)):
				holder.rotation_degrees.x = lerpf(0.0, -80.0, f)
			p.y -= 0.25 * f
		holder.position = p
		# retour à la marche après un one-shot (sauf boss vaincu)
		if a["mode"] == "once" and not bool(a.get("dead", false)) and _t >= float(a["mode_t"]) + 1.4:
			a["mode"] = "walk"
			var ap: AnimationPlayer = a["ap"]
			if ap != null and ap.has_animation(String(a["walk"])):
				ap.play(a["walk"])
	# effets d'entrée : rune au sol avant l'apparition, colonne de lumière au départ, onde à l'arrivée
	for i: int in range(_actors.size()):
		var ea: Dictionary = _actors[i]
		if ea["holder"] == null:
			continue
		var et: float = float(ea["enter_t"])
		var boss: bool = bool(ea.get("boss", false))
		_trigger(et - (0.9 if boss else 0.4), "rune%d" % i, _fx_rune.bind(i))
		_trigger(et, "emerge%d" % i, _fx_emerge.bind(i))
		_trigger(et + ENTER_DUR, "arrive%d" % i, _fx_arrive.bind(i))
	# événements du combat
	_trigger(ROAR_T, "roar", _roar)
	for i: int in range(LINEUP.size()):
		_trigger(ATK_T + float(i) * ATK_STEP, "atk%d" % i, _hero_strike.bind(i))
		_trigger(ATK_T + float(i) * ATK_STEP + IMPACT_DELAY, "imp%d" % i, _impact.bind(i))
	_trigger(COUNTER_T, "counter", _counter)
	_trigger(VOLLEY_T, "volley", _volley)
	_trigger(FINAL_T, "imp_final", _impact_final)


func _update_overlay() -> void:
	if _flash != null:
		_flash.modulate.a = _flash_amp * maxf(0.0, 1.0 - (_t - _flash_t) / 0.5) if _flash_t >= 0.0 else 0.0
	if _logo != null:
		_logo.modulate.a = _seg(11.6, 12.6)
	if _fade != null:
		_fade.modulate.a = _seg(12.9, DURATION)


# ═══════════════════════════════════════════════════════════════════════════
#  Effets visuels (entrées et combat) — tous pilotés par _t, auto-libérés
# ═══════════════════════════════════════════════════════════════════════════

## Matériau lumineux additif (couleur de sommet = couleur des particules).
func _glow_mat(col: Color) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.blend_mode = BaseMaterial3D.BLEND_MODE_ADD
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	m.cull_mode = BaseMaterial3D.CULL_DISABLED
	m.vertex_color_use_as_albedo = true
	m.albedo_color = col
	return m


func _shake(amp: float) -> void:
	_shake_amp = maxf(amp, _shake_amp * maxf(0.0, 1.0 - (_t - _shake_t) / 0.55))
	_shake_t = _t


func _add_fx(node: Node3D, dur: float, kind: String, extra: Dictionary = {}) -> Dictionary:
	add_child(node)
	var e: Dictionary = {"node": node, "t0": _t, "dur": dur, "kind": kind}
	e.merge(extra, true)
	_fx.append(e)
	return e


## Anneau plat qui s'étend au sol puis s'estompe (onde de choc).
func _ring(pos: Vector3, col: Color, r0: float, r1: float, dur: float, alpha: float = 0.9) -> void:
	var tm := TorusMesh.new()
	tm.inner_radius = 0.90
	tm.outer_radius = 1.0
	tm.rings = 40
	tm.ring_segments = 6
	var mi := MeshInstance3D.new()
	mi.mesh = tm
	mi.material_override = _glow_mat(Color(col.r, col.g, col.b, alpha))
	mi.position = pos + Vector3(0, 0.05, 0)
	mi.scale = Vector3(r0, 0.3, r0)
	_add_fx(mi, dur, "ring", {"r0": r0, "r1": r1, "a": alpha, "col": col})


## Colonne de lumière qui jaillit du sol puis s'amincit.
func _pillar(pos: Vector3, col: Color, h: float, w: float, dur: float) -> void:
	var cm := CylinderMesh.new()
	cm.top_radius = 1.0
	cm.bottom_radius = 1.0
	cm.height = 1.0
	cm.radial_segments = 14
	cm.rings = 1
	var mi := MeshInstance3D.new()
	mi.mesh = cm
	mi.material_override = _glow_mat(Color(col.r, col.g, col.b, 0.28))
	mi.position = pos
	mi.scale = Vector3(w, 0.01, w)
	_add_fx(mi, dur, "pillar", {"h": h, "w": w, "col": col, "base": pos})


## Disque de rune qui s'allume au sol avant une apparition.
func _rune(pos: Vector3, col: Color, r: float, dur: float) -> void:
	var cm := CylinderMesh.new()
	cm.top_radius = 1.0
	cm.bottom_radius = 1.0
	cm.height = 0.02
	cm.radial_segments = 24
	cm.rings = 1
	var mi := MeshInstance3D.new()
	mi.mesh = cm
	mi.material_override = _glow_mat(Color(col.r, col.g, col.b, 0.5))
	mi.position = pos + Vector3(0, 0.04, 0)
	mi.scale = Vector3(r, 1.0, r)
	_add_fx(mi, dur, "rune", {"col": col, "r": r})
	_ring(pos, col, r * 1.3, r * 0.5, dur, 0.7)   # anneau qui se resserre sur la rune


## Gerbe de particules (étincelles, poussière, éclats). Se libère toute seule.
func _burst(pos: Vector3, col: Color, count: int, speed: float, life: float, size: float, grav: float = -6.0, up: float = 0.0) -> void:
	var p := CPUParticles3D.new()
	var sm := SphereMesh.new()
	sm.radius = size
	sm.height = size * 2.0
	sm.radial_segments = 6
	sm.rings = 3
	p.mesh = sm
	p.material_override = _glow_mat(Color(1, 1, 1, 1))
	p.amount = count
	p.lifetime = life
	p.one_shot = true
	p.explosiveness = 0.96
	p.direction = Vector3(0, 1, 0)
	p.spread = 180.0 if up <= 0.0 else 35.0
	p.initial_velocity_min = speed * 0.4
	p.initial_velocity_max = speed
	p.gravity = Vector3(0, grav, 0)
	p.scale_amount_min = 0.5
	p.scale_amount_max = 1.4
	var g := Gradient.new()
	g.set_color(0, Color(col.r, col.g, col.b, 0.85))
	g.set_color(1, Color(col.r, col.g, col.b, 0.0))
	p.color_ramp = g
	p.position = pos
	p.emitting = true
	_add_fx(p, life + 0.2, "parts")


## Projectile (orbe ou trait) du héros i vers le boss bi pendant IMPACT_DELAY ; laisse une traînée.
func _fire_projectile(i: int, bi: int) -> void:
	if bi >= _actors.size() or i >= LINEUP.size():
		return
	var src: Node3D = _actors[i]["holder"]
	var dst: Node3D = _actors[bi]["holder"]
	if src == null or dst == null:
		return
	var prof: Dictionary = HERO_FX.get(LINEUP[i], {"col": Color(1, 1, 1), "bolt": false, "size": 0.15})
	var col: Color = prof["col"]
	var from: Vector3 = src.position + Vector3(0, HERO_H * 0.62, -0.5)
	var to: Vector3 = dst.position + Vector3(0, HERO_H * float(_actors[bi].get("k", 1.0)) * 0.55, 0)
	_burst(from, col, 10, 2.4, 0.35, 0.05, -2.0)   # éclat au départ
	var sm := SphereMesh.new()
	var sz: float = float(prof["size"])
	sm.radius = sz
	sm.height = sz * 2.0
	sm.radial_segments = 10
	sm.rings = 5
	var mi := MeshInstance3D.new()
	mi.mesh = sm
	mi.material_override = _glow_mat(Color(col.r, col.g, col.b, 0.9))
	mi.position = from
	if bool(prof["bolt"]):
		mi.scale = Vector3(1, 1, 7)
	# traînée continue (particules non liées au projectile)
	var tr := CPUParticles3D.new()
	var tm := SphereMesh.new()
	tm.radius = sz * 0.55
	tm.height = sz * 1.1
	tm.radial_segments = 6
	tm.rings = 3
	tr.mesh = tm
	tr.material_override = _glow_mat(Color(1, 1, 1, 1))
	tr.amount = 22
	tr.lifetime = 0.32
	tr.local_coords = false
	tr.direction = Vector3(0, 0, 0)
	tr.spread = 180.0
	tr.initial_velocity_min = 0.1
	tr.initial_velocity_max = 0.5
	tr.gravity = Vector3.ZERO
	var g := Gradient.new()
	g.set_color(0, Color(col.r, col.g, col.b, 0.9))
	g.set_color(1, Color(col.r, col.g, col.b, 0.0))
	tr.color_ramp = g
	tr.emitting = true
	mi.add_child(tr)
	_add_fx(mi, IMPACT_DELAY, "proj", {"from": from, "to": to, "arc": 0.5 if not bool(prof["bolt"]) else 0.1})
	if bool(prof["bolt"]):
		mi.look_at_from_position(from, to)


## Onde de choc d'un boss : anneau au sol + poussière.
func _shockwave(bi: int) -> void:
	if bi >= _actors.size() or _actors[bi]["holder"] == null:
		return
	var b: Dictionary = _actors[bi]
	var pos: Vector3 = (b["holder"] as Node3D).position
	var col: Color = b.get("fx", Color(1, 0.5, 0.3))
	_ring(pos, col, 0.6, 7.0, 0.9, 0.85)
	_ring(pos, col.lightened(0.4), 0.4, 4.5, 0.7, 0.6)
	_burst(pos + Vector3(0, 0.2, 0), col, 26, 3.6, 0.8, 0.07, -3.0, 1.0)


## Impact sur un boss : étincelles, anneau, chiffre de dégâts flottant, léger tremblement.
func _impact_fx(b: Dictionary, dmg: int) -> void:
	var holder: Node3D = b["holder"]
	var k: float = float(b.get("k", 1.0))
	var pos: Vector3 = holder.position + Vector3(0, HERO_H * k * 0.55, 0.3)
	_burst(pos, Color(1.0, 0.85, 0.45), 20, 4.5, 0.55, 0.035, -7.0)
	_burst(pos, b.get("fx", Color(1, 0.6, 0.3)), 12, 2.5, 0.7, 0.07, -3.0)
	_ring(holder.position, Color(1.0, 0.95, 0.75), 0.4, 2.2, 0.45, 0.7)
	_shake(0.06)
	var lb := Label3D.new()
	lb.text = "-%d" % dmg
	lb.font_size = 72
	lb.pixel_size = 0.012
	lb.outline_size = 14
	lb.outline_modulate = Color(0.1, 0.05, 0.0, 1.0)
	lb.modulate = Color(1.0, 0.88, 0.45)
	lb.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	lb.no_depth_test = true
	lb.position = pos + Vector3(randf_range(-0.4, 0.4), 0.4, 0.2)
	_add_fx(lb, 1.0, "label", {"base": lb.position})


## Chute du boss : explosion, grande onde, colonne de lumière, forte secousse.
func _death_fx(b: Dictionary) -> void:
	var holder: Node3D = b["holder"]
	var k: float = float(b.get("k", 1.0))
	var col: Color = b.get("fx", Color(1, 0.6, 0.3))
	var pos: Vector3 = holder.position
	_burst(pos + Vector3(0, HERO_H * k * 0.5, 0), Color(1.0, 0.75, 0.35), 56, 7.0, 1.1, 0.06, -5.0)
	_burst(pos + Vector3(0, HERO_H * k * 0.5, 0), col, 36, 4.0, 1.4, 0.08, -1.5)
	_ring(pos, Color(1.0, 0.9, 0.6), 0.5, 11.0, 1.1, 0.9)
	_ring(pos, col, 0.3, 8.0, 0.9, 0.8)
	_pillar(pos, col, 7.0, 0.9, 1.2)
	_shake(0.32)


## Entrée — rune au sol (les boss : large et sombre ; les héros : petit cercle clair).
func _fx_rune(i: int) -> void:
	var a: Dictionary = _actors[i]
	if a["holder"] == null:
		return
	var boss: bool = bool(a.get("boss", false))
	_rune(a["home"] as Vector3, a.get("fx", Color(0.8, 0.9, 1.0)), 1.9 if boss else 0.8, 1.1 if boss else 0.8)


## Entrée — le personnage apparaît : colonne de lumière (boss : plus haute) et brume.
func _fx_emerge(i: int) -> void:
	var a: Dictionary = _actors[i]
	if a["holder"] == null:
		return
	var boss: bool = bool(a.get("boss", false))
	var col: Color = a.get("fx", Color(0.8, 0.9, 1.0))
	var pos: Vector3 = (a["from"] as Vector3)
	_pillar(pos, col, 6.0 if boss else 3.2, 1.0 if boss else 0.5, 1.0)
	_burst(pos + Vector3(0, 0.2, 0), col, 30 if boss else 14, 2.2, 1.0, 0.09, 0.6, 1.0)
	if boss:
		_shake(0.10)


## Entrée — arrivée à la position finale : anneau + poussière (boss : secousse).
func _fx_arrive(i: int) -> void:
	var a: Dictionary = _actors[i]
	if a["holder"] == null:
		return
	var boss: bool = bool(a.get("boss", false))
	var col: Color = a.get("fx", Color(0.8, 0.9, 1.0))
	var pos: Vector3 = (a["home"] as Vector3)
	_ring(pos, col, 0.3, 5.0 if boss else 1.8, 0.8 if boss else 0.55, 0.9)
	_burst(pos + Vector3(0, 0.1, 0), col.lightened(0.3), 24 if boss else 10, 3.0 if boss else 1.8, 0.7, 0.06, -2.5, 1.0)
	if boss:
		_shake(0.2)


## Fait vivre les effets (échelle, transparence, trajectoires) et libère les terminés.
func _update_fx() -> void:
	var i: int = _fx.size() - 1
	while i >= 0:
		var e: Dictionary = _fx[i]
		var node: Node3D = e["node"] as Node3D
		if node == null or not is_instance_valid(node):
			_fx.remove_at(i)
			i -= 1
			continue
		var p: float = (_t - float(e["t0"])) / maxf(float(e["dur"]), 0.001)
		if p >= 1.0:
			node.queue_free()
			_fx.remove_at(i)
			i -= 1
			continue
		p = maxf(p, 0.0)
		var kind: String = String(e["kind"])
		if kind == "ring":
			var r: float = lerpf(float(e["r0"]), float(e["r1"]), 1.0 - pow(1.0 - p, 3.0))
			node.scale = Vector3(r, 0.3, r)
			_fx_alpha(node, float(e["a"]) * pow(1.0 - p, 1.5), e["col"])
		elif kind == "pillar":
			var grow: float = 1.0 - pow(1.0 - minf(p * 3.0, 1.0), 2.0)
			var h: float = float(e["h"]) * grow
			var w: float = float(e["w"]) * (1.0 - 0.7 * p)
			node.scale = Vector3(w, maxf(h, 0.01), w)
			node.position = (e["base"] as Vector3) + Vector3(0, h * 0.5, 0)
			_fx_alpha(node, 0.28 * (1.0 - p), e["col"])
		elif kind == "rune":
			var glow: float = sin(p * PI)
			node.rotation.y = _t * 1.6
			_fx_alpha(node, 0.55 * glow, e["col"])
		elif kind == "proj":
			var f: float = p
			var pos: Vector3 = (e["from"] as Vector3).lerp(e["to"] as Vector3, f)
			pos.y += sin(f * PI) * float(e["arc"])
			node.position = pos
		elif kind == "label":
			node.position = (e["base"] as Vector3) + Vector3(0, 0.9 * p, 0)
			(node as Label3D).modulate.a = 1.0 - smoothstep(0.55, 1.0, p)
		i -= 1


func _fx_alpha(node: Node3D, a: float, col: Color) -> void:
	var m: Material = (node as MeshInstance3D).material_override
	if m is StandardMaterial3D:
		(m as StandardMaterial3D).albedo_color = Color(col.r, col.g, col.b, clampf(a, 0.0, 1.0))


func _skip() -> void:
	if _leaving:
		return
	_leaving = true
	if _fade == null:
		_change_to_menu.call_deferred()
		return
	var tw := create_tween()
	tw.tween_property(_fade, "modulate:a", 1.0, 0.35)
	tw.tween_callback(_change_to_menu)


func _change_to_menu() -> void:
	if not is_inside_tree():
		return
	var packed: PackedScene = ResourceLoader.load_threaded_get(NEXT_SCENE) as PackedScene
	if packed != null:
		get_tree().change_scene_to_packed(packed)
	else:
		get_tree().change_scene_to_file(NEXT_SCENE)
