extends Node3D
## Cinematic3D.gd — Petite cinématique d'ouverture en 3D (les héros contre les boss), jouée
## entre l'intro des Pierres (Intro.tscn) et l'accueil (MainMenu.tscn) quand le réglage
## « Cinématique 3D » est actif (GameSettings.cinematic_3d ; éteint par défaut sur mobile).
##
## Les vrais modèles .glb des héros (assets/heroes3d/, clés de Hero3D.MODELS) et des deux boss
## 3D du jeu (modèle Tharok, voir Hero3D.BOSS_MODEL) sont instanciés dans une arène Kenney,
## avec le même rendu toon que le combat (Hero3D.SHADER + texture « pad » + teinte). La timeline
## est entièrement pilotée par _t (déterministe) : travelling caméra, entrée des héros en
## « Walking », apparition des boss, assauts (clips d'attaque des .glb), flash d'impact, logo,
## barres de ciné (letterbox). N'importe quelle entrée passe la cinématique.
## Le rendu 3D lui-même ne se teste pas en headless : tests/test_cinematic3d.gd couvre la logique.

const SCENE := "res://scenes/Cinematic3D.tscn"
const NEXT_SCENE := "res://scenes/MainMenu.tscn"
const DURATION := 11.0
const BAR_FRAC := 0.11          # hauteur des barres de ciné (fraction de la hauteur d'écran)
const HERO_H := 1.8             # même hauteur normalisée que Hero3D
const LOGO_PATH := "res://assets/ui/logo_intro.png"

## Héros montrés (clés de Hero3D.MODELS), de gauche à droite.
const LINEUP: Array[String] = ["Tank", "Chasseur", "Sylvain", "Ingénieur", "Invocateur"]
## Les deux boss 3D du jeu (Hero3D.BOSS_MODEL) : modèle, teinte, échelle, position x.
const BOSSES: Array = [
	{"model": "Tharok", "tint": Color(0.72, 1.0, 0.72), "k": 1.30, "x": -2.4},   # Gobelin Roi
	{"model": "Tharok", "tint": Color(1.0, 0.95, 0.85), "k": 1.50, "x": 2.4},    # Tharok le Végétal
]

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
	[0.0, Vector3(0, 3.4, 11.5), Vector3(0, 1.3, 0)],
	[4.0, Vector3(0, 2.7, 8.8), Vector3(0, 1.4, -1.0)],
	[6.0, Vector3(0.6, 2.3, 6.4), Vector3(0, 1.7, -4.5)],
	[8.6, Vector3(-0.4, 3.0, 9.6), Vector3(0, 1.4, -1.5)],
	[DURATION, Vector3(0, 3.2, 10.4), Vector3(0, 1.4, -1.0)],
]

var _t: float = 0.0
var _leaving: bool = false
var _did: Dictionary = {}
var _cam: Camera3D
var _actors: Array = []         # {holder, ap, walk, atk, home, from, enter_t, boss, mode, mode_t}
var _bar_top: ColorRect
var _bar_bot: ColorRect
var _flash: ColorRect
var _logo: TextureRect
var _hint: Label
var _fade: ColorRect


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
	if _t >= DURATION:
		_skip()


## — Monde : arène sombre (sol, colonnes et statue Kenney), brume, deux lumières.
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
	# sol : grande dalle sombre + disque central plus clair
	var floor_mat := StandardMaterial3D.new()
	floor_mat.albedo_color = Color(0.16, 0.15, 0.18)
	floor_mat.roughness = 1.0
	var floor_mesh := CylinderMesh.new()
	floor_mesh.top_radius = 9.5
	floor_mesh.bottom_radius = 10.0
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
	ring_mesh.top_radius = 6.0
	ring_mesh.bottom_radius = 6.0
	ring_mesh.height = 0.06
	var ring_mi := MeshInstance3D.new()
	ring_mi.mesh = ring_mesh
	ring_mi.position = Vector3(0, 0.01, 0)
	ring_mi.set_surface_override_material(0, ring_mat)
	add_child(ring_mi)
	# colonnes en cercle + statue au fond (kit Kenney, mêmes maillages que le monde 3D)
	_add_kit_prop("column", 8, 7.6, 4.2)
	_add_kit_prop("statue", 1, 0.0, 3.2, Vector3(0, 0, -8.8), 180.0)


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
			var a := TAU * float(i) / float(count) + TAU / 16.0
			mi.position = Vector3(cos(a) * radius, mesh.get_aabb().size.y * s * 0.5 - 0.15, sin(a) * radius)
			mi.rotation_degrees.y = -rad_to_deg(a)
		else:
			mi.position = Vector3(at.x, mesh.get_aabb().size.y * s * 0.5 - 0.15, at.z)
			mi.rotation_degrees.y = yaw
		add_child(mi)


## — UI : letterbox, flash, logo, indice, fondu au noir (au-dessus de la 3D).
func _build_ui() -> void:
	var cl := CanvasLayer.new()
	cl.layer = 100
	add_child(cl)
	_bar_top = _mk_rect(cl, Color(0, 0, 0))
	_bar_top.anchor_right = 1.0
	_bar_top.anchor_bottom = 0.0
	_bar_top.offset_bottom = 0.0
	_bar_bot = _mk_rect(cl, Color(0, 0, 0))
	_bar_bot.anchor_top = 1.0
	_bar_bot.anchor_bottom = 1.0
	_bar_bot.anchor_right = 1.0
	_bar_bot.offset_top = 0.0
	_flash = _mk_rect(cl, Color(1, 1, 1))
	_flash.modulate.a = 0.0
	_logo = TextureRect.new()
	_logo.texture = load(LOGO_PATH) as Texture2D
	_logo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_logo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_logo.modulate.a = 0.0
	_logo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cl.add_child(_logo)
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
	cl.add_child(_hint)
	_fade = _mk_rect(cl, Color(0, 0, 0))
	_fade.modulate.a = 0.0
	_fit_ui()


func _mk_rect(cl: CanvasLayer, col: Color) -> ColorRect:
	var r := ColorRect.new()
	r.color = col
	r.set_anchors_preset(Control.PRESET_FULL_RECT)
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	cl.add_child(r)
	return r


func _fit_ui() -> void:
	if _logo == null or _logo.texture == null:
		return
	var vs: Vector2 = get_viewport_rect().size
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
		var home := Vector3(lerpf(-3.4, 3.4, (float(i) + 0.5) / float(n)), 0.0, 3.6)
		var from := home + Vector3(home.x * 2.4, 0.0, 7.5)
		var a: Dictionary = _spawn(key, from, 180.0, Color(1, 1, 1), 1.0)
		a["key"] = key
		a["home"] = home
		a["from"] = from
		a["enter_t"] = 1.2 + float(i) * 0.25
		a["boss"] = false
		_actors.append(a)
	for b: Dictionary in BOSSES:
		var home := Vector3(float(b["x"]), 0.0, -5.6)
		var from := home + Vector3(0, 0, -7.0)
		var a: Dictionary = _spawn(String(b["model"]), from, 0.0, b["tint"], float(b["k"]))
		a["key"] = String(b["model"])
		a["home"] = home
		a["from"] = from
		a["enter_t"] = 4.2
		a["boss"] = true
		_actors.append(a)


func _spawn(key: String, pos: Vector3, yaw: float, tint: Color, k: float) -> Dictionary:
	var out := {"holder": null, "ap": null, "walk": "Walking", "atk": "", "mode": "walk", "mode_t": 0.0}
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
	out["atk"] = String((clips.get("attack", {}) as Dictionary).get("clip", ""))
	var aps: Array = inst.find_children("*", "AnimationPlayer", true, false)
	if not aps.is_empty():
		var ap := aps[0] as AnimationPlayer
		if ap.has_animation(out["walk"]):
			ap.get_animation(out["walk"]).loop_mode = Animation.LOOP_LINEAR
			ap.play(out["walk"])
		out["ap"] = ap
	out["holder"] = holder
	return out


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


func _seg(t0: float, t1: float) -> float:
	return smoothstep(0.0, 1.0, clampf((_t - t0) / maxf(t1 - t0, 0.0001), 0.0, 1.0))


func _ease(x: float) -> float:
	x = clampf(x, 0.0, 1.0)
	return x * x * (3.0 - 2.0 * x)


func _update_bars() -> void:
	if _bar_top == null:
		return
	var vs: Vector2 = get_viewport_rect().size
	var h: float = vs.y * BAR_FRAC * _seg(0.15, 0.9) * (1.0 - _seg(10.3, DURATION))
	_bar_top.offset_bottom = h
	_bar_bot.offset_top = -h
	_hint.offset_top = -h
	_hint.modulate.a = clampf((_t - 0.6) * 2.0, 0.0, 0.55) * (1.0 - _seg(10.3, DURATION))


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
	_cam.position = pos
	_cam.look_at(tgt)


func _update_actors() -> void:
	for i: int in range(_actors.size()):
		var a: Dictionary = _actors[i]
		var holder: Node3D = a["holder"]
		if holder == null:
			continue
		var k: float = _ease(_seg(float(a["enter_t"]), float(a["enter_t"]) + 2.2))
		holder.position = (a["from"] as Vector3).lerp(a["home"] as Vector3, k)
		if a["boss"]:
			if _t >= 6.9 and not _did.has("batk%d" % i):
				_did["batk%d" % i] = true
				_play_once(a, "attack")
		else:
			if _t >= 6.2 + float(i) * 0.3 and not _did.has("atk%d" % i):
				_did["atk%d" % i] = true
				_play_once(a, "cast" if i % 2 == 3 else "attack")
		if a["mode"] == "once" and _t >= float(a["mode_t"]) + 1.4:
			a["mode"] = "walk"
			var ap: AnimationPlayer = a["ap"]
			if ap != null and ap.has_animation(String(a["walk"])):
				ap.play(a["walk"])


func _update_overlay() -> void:
	if _flash != null:
		_flash.modulate.a = clampf(1.0 - absf(_t - 7.3) * 3.5, 0.0, 1.0) * 0.85
	if _logo != null:
		_logo.modulate.a = _seg(9.0, 10.1)
	if _fade != null:
		_fade.modulate.a = _seg(10.3, DURATION)


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
