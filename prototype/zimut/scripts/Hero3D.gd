class_name Hero3D
extends Node
## Hero3D.gd — PROTOTYPE (V161) : un héros modélisé en 3D, rendu EN DIRECT dans un petit SubViewport (192 × 192) et affiché
## par EntityView à la place des sprites cuits (tools/bake_hero_seq.gd). Même cadrage, mêmes animations (HeroAnim), même
## cellule : EntityView lui demande simplement « telle animation, telle phase, de face ou de dos » et reçoit la texture.
## Différences avec les planches : mouvements continus (pas d'images fixes), un rendu 3D par héros et par image.
##
## Les parties communes avec le script de cuisson (bâton rigide, visée du bâton, pose) sont volontairement recopiées :
## à fusionner si le prototype est retenu.

const CELL := 192
const CHAR_FRAC := 0.74            # hauteur du personnage au repos dans la cellule (comme la cuisson)
const FEET_ROW := 0.965            # ligne des pieds
const HERO_H := 1.8
const OUTLINE_FRAC := 0.0113       # contour de 1,6 px dans la cellule, en fraction de la hauteur du personnage (comme la cuisson)
## Deux familles de modèles :
##  - « procédural » (Sylvain) : pose calculée à l'exécution par HeroAnim, bâton rigide, pointe du bâton ;
##  - « clips » (modèles Meshy rigifiés, V163) : animations intégrées au .glb (AnimationPlayer). Chaque action du jeu
##    (idle, walk, attack, cast, hit) renvoie à un morceau de clip [t0, t1] (secondes) joué sur la durée [dur] du jeu ;
##    « key » = instant d'impact (fraction de l'action). Sans clip pour une action : pose tenue + mouvement du corps (« motion »).
const MODELS := {
	"Sylvain": {"path": "res://assets/heroes3d/sylvain.glb", "tip_bone": "main.r",
		"staff_x": -0.0035, "staff_z_max": 0.0045, "gain": 1.0},
	"Tharok": {"path": "res://assets/heroes3d/tharok.glb", "root_bone": "spine", "gain": 1.0,
		"clips": {
			"idle":   {"clip": "Walking", "t0": 0.0, "t1": 0.0, "dur": 3.0, "loop": true, "key": 0.0},
			"walk":   {"clip": "Walking", "t0": 0.0, "t1": 1.0333, "dur": 1.0, "loop": true, "key": 0.0},
			"attack": {"clip": "Axe_Spin_Attack", "t0": 0.2, "t1": 1.8, "dur": 1.0, "loop": false, "key": 0.5},
			"cast":   {"clip": "Double_Combo_Attack", "t0": 0.1, "t1": 1.5, "dur": 1.0, "loop": false, "key": 0.5},
			"hit":    {"clip": "Walking", "t0": 0.0, "t1": 0.0, "dur": 0.4, "loop": false, "key": 0.0, "motion": "hit"},
		}},
	"Ingénieur": {"path": "res://assets/heroes3d/ingenieur.glb", "root_bone": "spine", "gain": 1.0,
		"clips": {
			"idle":   {"clip": "Walking", "t0": 0.0, "t1": 0.0, "dur": 3.0, "loop": true, "key": 0.0},
			"walk":   {"clip": "Walking", "t0": 0.0, "t1": 1.0333, "dur": 1.0, "loop": true, "key": 0.0},
			"attack": {"clip": "Attack", "t0": 0.2, "t1": 1.8, "dur": 1.0, "loop": false, "key": 0.56},
			"cast":   {"clip": "Axe_Spin_Attack", "t0": 0.2, "t1": 1.8, "dur": 1.0, "loop": false, "key": 0.5},
			"hit":    {"clip": "Walking", "t0": 0.0, "t1": 0.0, "dur": 0.4, "loop": false, "key": 0.0, "motion": "hit"},
		}},
	## Tank : un seul clip d'attaque (« Double_Combo_Attack » : deux coups de hache). La hache, que Meshy lie à trois os qui s'écartent
	## (tête sur le pouce, bas du manche sur deux os racine), est rendue rigide au pouce à l'import (tools/import_fbx.gd, option « rigide »).
	"Tank": {"path": "res://assets/heroes3d/tank.glb", "root_bone": "spine", "gain": 1.0,
		"clips": {
			"idle":   {"clip": "Walking", "t0": 0.0, "t1": 0.0, "dur": 3.0, "loop": true, "key": 0.0},
			"walk":   {"clip": "Walking", "t0": 0.0, "t1": 1.0333, "dur": 1.0, "loop": true, "key": 0.0},
			"attack": {"clip": "Double_Combo_Attack", "t0": 0.1, "t1": 1.2, "dur": 0.9, "loop": false, "key": 0.56},
			"cast":   {"clip": "Double_Combo_Attack", "t0": 0.1, "t1": 2.2, "dur": 1.5, "loop": false, "key": 0.85},
			"hit":    {"clip": "Walking", "t0": 0.0, "t1": 0.0, "dur": 0.4, "loop": false, "key": 0.0, "motion": "hit"},
		}},
	## Chasseur : « Attack » est un grand geste d'arc levé puis abaissé (pas de tir à l'arc tendu) ; le sort réutilise le même clip.
	"Chasseur": {"path": "res://assets/heroes3d/chasseur.glb", "root_bone": "spine", "gain": 1.0,
		"clips": {
			"idle":   {"clip": "Walking", "t0": 0.0, "t1": 0.0, "dur": 3.0, "loop": true, "key": 0.0},
			"walk":   {"clip": "Walking", "t0": 0.0, "t1": 1.0333, "dur": 1.0, "loop": true, "key": 0.0},
			"attack": {"clip": "Attack", "t0": 0.3, "t1": 1.7, "dur": 0.9, "loop": false, "key": 0.54},
			"cast":   {"clip": "Attack", "t0": 0.3, "t1": 1.7, "dur": 1.1, "loop": false, "key": 0.54},
			"hit":    {"clip": "Walking", "t0": 0.0, "t1": 0.0, "dur": 0.4, "loop": false, "key": 0.0, "motion": "hit"},
		}},
	## Invocateur : « Charged_Spell_Cast_1 » = livre levé, tenu à hauteur du visage (≈ 2,1-2,9 s), puis relâché. L'attaque en reprend la poussée en avant.
	"Invocateur": {"path": "res://assets/heroes3d/invocateur.glb", "root_bone": "spine", "gain": 1.0,
		"clips": {
			"idle":   {"clip": "Walking", "t0": 0.0, "t1": 0.0, "dur": 3.0, "loop": true, "key": 0.0},
			"walk":   {"clip": "Walking", "t0": 0.0, "t1": 1.0333, "dur": 1.0, "loop": true, "key": 0.0},
			"attack": {"clip": "Charged_Spell_Cast_1", "t0": 1.3, "t1": 2.4, "dur": 0.7, "loop": false, "key": 0.77},
			"cast":   {"clip": "Charged_Spell_Cast_1", "t0": 0.3, "t1": 3.4, "dur": 1.4, "loop": false, "key": 0.6},
			"hit":    {"clip": "Walking", "t0": 0.0, "t1": 0.0, "dur": 0.4, "loop": false, "key": 0.0, "motion": "hit"},
		}},
}
## Classe du joueur (nom interne) ou nom de boss -> modèle.
const CLASS_MODEL := {"Sylvain": "Sylvain", "Artificier": "Ingénieur", "Chasseur": "Chasseur", "Invocateur": "Invocateur", "Tank": "Tank"}
const BOSS_MODEL := {"Gobelin Roi": "Tharok", "Tharok le Végétal": "Tharok"}
const CLIP_FRAMES := 24             # nombre d'images fictives d'une action (EntityView raisonne en images pour les temps d'impact)
const SHADER := """
shader_type spatial;
render_mode cull_back, specular_disabled;
uniform sampler2D albedo_tex : source_color, filter_linear_mipmap, repeat_enable, hint_default_white;
uniform float gain = 1.0;
void fragment() {
	vec3 c = texture(albedo_tex, UV).rgb * gain;
	ALBEDO = c;
	EMISSION = c * 0.16;
	ROUGHNESS = 0.9;
}
void light() {
	float h = dot(NORMAL, LIGHT) * 0.5 + 0.5;
	float band = smoothstep(0.38, 0.58, h) * 0.5 + smoothstep(0.66, 0.84, h) * 0.5;
	vec3 shade = mix(vec3(0.70, 0.74, 0.96), vec3(1.0), band);
	DIFFUSE_LIGHT += LIGHT_COLOR * ATTENUATION * (0.35 + 0.65 * band) * shade * 0.9;
}
"""
const OUTLINE_SHADER := """
shader_type spatial;
render_mode cull_front, unshaded;
uniform float width = 0.0002;
void vertex() {
	VERTEX += NORMAL * width;
}
void fragment() {
	ALBEDO = vec3(0.06, 0.08, 0.15);
}
"""

signal framed
var _bone_cache := {}                      # le cadrage est calculé : la texture est utilisable

var vp: SubViewport
var ready_ok: bool = false         # modèle chargé, cadré et prêt à être affiché
var tip_ok: bool = false
var rendered: int = 0              # nombre de rendus demandés (compteur de performances)

var _cam: Camera3D
var _holder: Node3D
var _model: Node3D
var _sk: Skeleton3D
var _mi: MeshInstance3D
var _skin: Skin
var _prof: Dictionary
var _rest_q: Array = []
var _rest_p: Array = []
var _tip_local := Vector3.ZERO
var _rest_dir := Vector3.UP
var _last_key: String = ""
var _cell_px: float = float(CELL)
var _ap: AnimationPlayer = null
var _clips: Dictionary = {}


static func supported(classe: String) -> bool:
	return MODELS.has(classe) and ResourceLoader.exists(String((MODELS[classe] as Dictionary)["path"]))


## Modèle 3D d'une entité ("" si aucun) : boss nommé, sinon classe de héros.
static func model_key(ent: Dictionary) -> String:
	var classe: String = String(ent.get("classe", ""))
	var key: String = ""
	if bool(ent.get("boss", false)):
		key = String(BOSS_MODEL.get(classe, ""))
	elif String(ent.get("team", "")) == "player":
		key = String(CLASS_MODEL.get(classe, ""))
	return key if supported(key) else ""


## Modèle à clips (sans planches cuites pour fournir les durées) ?
static func is_clip_model(key: String) -> bool:
	return MODELS.has(key) and (MODELS[key] as Dictionary).has("clips")


## Charge le modèle et prépare le rendu. Asynchrone (quelques images pour mesurer le cadrage) : attendre [signal framed].
func setup(classe: String) -> bool:
	if not supported(classe):
		return false
	_prof = MODELS[classe]
	vp = SubViewport.new()
	vp.size = Vector2i(CELL, CELL)
	vp.transparent_bg = true
	vp.own_world_3d = true
	vp.msaa_3d = Viewport.MSAA_2X
	vp.render_target_update_mode = SubViewport.UPDATE_ONCE
	add_child(vp)
	var env := Environment.new()
	env.background_mode = Environment.BG_CLEAR_COLOR
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.86, 0.90, 1.0)
	env.ambient_light_energy = 0.55
	var we := WorldEnvironment.new()
	we.environment = env
	vp.add_child(we)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-38, -28, 0)
	sun.light_energy = 0.9
	vp.add_child(sun)
	_cam = Camera3D.new()
	_cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	_cam.size = 3.0
	vp.add_child(_cam)
	_cam.current = true
	if not _load_model(String(_prof["path"])):
		return false
	_frame.call_deferred()
	return true


func texture() -> Texture2D:
	return vp.get_texture()


func _load_model(path: String) -> bool:
	var packed: PackedScene = load(path) as PackedScene
	if packed == null:
		return false
	var n: Node3D = packed.instantiate() as Node3D
	_holder = Node3D.new()
	vp.add_child(_holder)
	_model = Node3D.new()
	_holder.add_child(_model)
	_model.add_child(n)
	var sks: Array = n.find_children("*", "Skeleton3D", true, false)
	var mis: Array = n.find_children("*", "MeshInstance3D", true, false)
	if sks.is_empty() or mis.is_empty():
		return false
	_sk = sks[0] as Skeleton3D
	_mi = mis[0] as MeshInstance3D
	var src: Material = _mi.mesh.surface_get_material(0)
	var tex: Texture2D = (src as BaseMaterial3D).albedo_texture if src is BaseMaterial3D else null
	if tex == null:
		return false
	var sh := Shader.new()
	sh.code = SHADER
	var mat := ShaderMaterial.new()
	mat.shader = sh
	mat.set_shader_parameter("albedo_tex", tex)
	mat.set_shader_parameter("gain", float(_prof.get("gain", 1.0)))
	# contour : coque inversée (rendu des faces arrière, gonflée le long des normales)
	var osh := Shader.new()
	osh.code = OUTLINE_SHADER
	var omat := ShaderMaterial.new()
	omat.shader = osh
	var aabb: AABB = _mi.mesh.get_aabb()
	omat.set_shader_parameter("width", maxf(aabb.size.x, maxf(aabb.size.y, aabb.size.z)) * OUTLINE_FRAC)
	mat.next_pass = omat
	_skin = _mi.skin
	for i: int in range(_sk.get_bone_count()):
		_rest_q.append(_sk.get_bone_rest(i).basis.get_rotation_quaternion())
		_rest_p.append(_sk.get_bone_rest(i).origin)
	# taille : les os couvrent le personnage de la tête aux pieds
	var lo := Vector3(1e9, 1e9, 1e9)
	var hi := Vector3(-1e9, -1e9, -1e9)
	for k: int in range(_sk.get_bone_count()):
		var p: Vector3 = (_sk.global_transform * _sk.get_bone_global_pose(k)).origin
		lo = lo.min(p)
		hi = hi.max(p)
	var s: float = HERO_H / maxf(hi.y - lo.y, 0.0001)
	_model.scale = Vector3.ONE * s
	var bas: int = _bone(String(_prof.get("root_bone", "bassin")))
	var bx: float = (_sk.global_transform * _sk.get_bone_global_pose(bas)).origin.x
	_model.position = Vector3(-bx * s, -lo.y * s, 0)
	if _prof.has("clips"):
		_clips = _prof["clips"]
		var aps: Array = n.find_children("*", "AnimationPlayer", true, false)
		if aps.is_empty():
			push_warning("Hero3D : aucune animation dans " + path)
			return false
		_ap = aps[0] as AnimationPlayer
		_ap.callback_mode_process = AnimationMixer.ANIMATION_CALLBACK_MODE_PROCESS_MANUAL
	else:
		_rig_staff()
	_mi.set_surface_override_material(0, mat)
	return true


func _bind_bone(b: int) -> int:
	if _skin != null and b < _skin.get_bind_count():
		var idx: int = _skin.get_bind_bone(b)
		if idx >= 0:
			return idx
		return _sk.find_bone(_skin.get_bind_name(b))
	return b


func _is_staff(p: Vector3) -> bool:
	return p.x < float(_prof["staff_x"]) and p.z <= float(_prof["staff_z_max"])


## Le bâton est lié à la main, mais son cristal est réparti sur le torse dans les poids de peau : on le rend rigide (100 %
## main). Le bout du bâton (point le plus haut de ces sommets) est exprimé dans le repère de l'os de la main grâce à la
## pose de liaison : plus de mesure par rendu, contrairement à la cuisson.
func _rig_staff() -> void:
	var arr: Array = _mi.mesh.surface_get_arrays(0)
	var verts: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
	var bones: PackedInt32Array = arr[Mesh.ARRAY_BONES]
	var weights: PackedFloat32Array = arr[Mesh.ARRAY_WEIGHTS]
	var per: int = bones.size() / verts.size()
	var hand: int = _bone(String(_prof["tip_bone"]))
	var hand_bind: int = -1
	for b: int in range(_skin.get_bind_count()):
		if _bind_bone(b) == hand:
			hand_bind = b
	if hand_bind < 0:
		push_warning("Hero3D : os de la main introuvable")
		return
	var best: int = -1
	for v: int in range(verts.size()):
		if not _is_staff(verts[v]):
			continue
		for k: int in range(per):
			bones[v * per + k] = hand_bind if k == 0 else 0
			weights[v * per + k] = 1.0 if k == 0 else 0.0
		if best < 0 or verts[v].z > verts[best].z:
			best = v
	if best < 0:
		push_warning("Hero3D : bâton introuvable")
		return
	arr[Mesh.ARRAY_BONES] = bones
	arr[Mesh.ARRAY_WEIGHTS] = weights
	var am := ArrayMesh.new()
	am.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)
	am.surface_set_material(0, _mi.mesh.surface_get_material(0))
	_mi.mesh = am
	_tip_local = _skin.get_bind_pose(hand_bind) * verts[best]
	tip_ok = true


## Cadrage : comme la cuisson, un rendu de la pose de repos de face fixe l'échelle (le personnage occupe CHAR_FRAC de la
## cellule, pieds sur FEET_ROW).
func _frame() -> void:
	if not is_inside_tree():
		await tree_entered
	_set_pose("idle", 0.0, false)
	# plusieurs passes : large d'abord (taille réelle du modèle inconnue, il ne doit pas être coupé), puis affinée
	_cam.size = 8.0
	_cam.position = Vector3(0, 1.0, 10)
	var vp_h: float = float(CELL)
	for pass_i: int in range(3):
		await _render_wait()
		var img: Image = vp.get_texture().get_image()
		var bb: Rect2i = _alpha_bbox(img)
		if bb.size.y < 10:
			push_warning("Hero3D : personnage introuvable dans l'image (cadrage)")
			return
		var wpp_old: float = _cam.size / vp_h
		var feet_world: float = _cam.position.y + (0.5 * vp_h - float(bb.end.y)) * wpp_old
		var f: float = (CHAR_FRAC * vp_h) / float(bb.size.y)
		_cam.size = _cam.size / f
		var wpp: float = _cam.size / vp_h
		_cam.position = Vector3(0, feet_world - (0.5 * vp_h - FEET_ROW * vp_h) * wpp, 10)
	if tip_ok:
		var hand: int = _bone(String(_prof["tip_bone"]))
		var g: Transform3D = _sk.global_transform * _sk.get_bone_global_pose(hand)
		_rest_dir = (g.basis * _tip_local).normalized()
	ready_ok = true
	_last_key = ""
	framed.emit()


func _render_wait() -> void:
	vp.render_target_update_mode = SubViewport.UPDATE_ONCE
	await get_tree().process_frame
	await get_tree().process_frame
	await RenderingServer.frame_post_draw


func _alpha_bbox(img: Image) -> Rect2i:
	var x0: int = img.get_width()
	var y0: int = img.get_height()
	var x1: int = -1
	var y1: int = -1
	for y: int in range(img.get_height()):
		for x: int in range(img.get_width()):
			if img.get_pixel(x, y).a > 0.3:
				x0 = mini(x0, x)
				x1 = maxi(x1, x)
				y0 = mini(y0, y)
				y1 = maxi(y1, y)
	if x1 < 0:
		return Rect2i()
	return Rect2i(x0, y0, x1 - x0 + 1, y1 - y0 + 1)


## Pose + rendu demandé. Phase ∈ [0, 1] de l'animation [anim] (voir HeroAnim). Rien n'est refait si la pose ne change pas
## (phase arrondie au 1/72).
func show_pose(anim: String, phase: float, back: bool) -> void:
	if not ready_ok:
		return
	var key: String = "%s|%d|%d" % [anim, roundi(phase * 72.0), 1 if back else 0]
	if key == _last_key:
		return
	_last_key = key
	_set_pose(anim, phase, back)
	vp.render_target_update_mode = SubViewport.UPDATE_ONCE
	rendered += 1


## Position (pixels de la cellule 192 × 192) du bout du bâton dans la pose affichée.
func tip_px() -> Vector2:
	if not tip_ok or not ready_ok:
		return Vector2(-1.0, -1.0)
	var hand: int = _bone(String(_prof["tip_bone"]))
	var g: Transform3D = _sk.global_transform * _sk.get_bone_global_pose(hand)
	return _cam.unproject_position(g * _tip_local)


## Oriente le bâton (voir tools/bake_hero_seq.gd, _aim_staff) : la main pivote pour que le bâton pointe vers [d].
func _aim_staff(d: Vector3, w: float) -> void:
	var hand: int = _bone(String(_prof["tip_bone"]))
	var g: Transform3D = _sk.get_bone_global_pose(hand)
	var t_hs: Basis = (_holder.global_transform.affine_inverse() * _sk.global_transform).basis.orthonormalized()
	var target: Vector3 = (t_hs.inverse() * d.normalized()).normalized()
	var cur: Vector3 = (g.basis * _tip_local).normalized()
	var want: Vector3 = _rest_dir.slerp(target, w).normalized()
	var axis: Vector3 = cur.cross(want)
	if axis.length() < 0.0001:
		return
	var rot := Basis(axis.normalized(), cur.angle_to(want))
	_sk.set_bone_global_pose(hand, Transform3D(rot * g.basis, g.origin))


## Les noms d'os du .glb n'ont pas de point (« bras_r », « avantBras_r », « torax ») : on retrouve celui d'une pose (« bras.r », « avantbras.r », « torse »).
func _bone(name: String) -> int:
	if _bone_cache.has(name):
		return _bone_cache[name]
	var want: String = name.replace(".", "_").to_lower()
	if want == "torse":
		want = "torax"
	var found: int = -1
	for i: int in range(_sk.get_bone_count()):
		if _sk.get_bone_name(i).to_lower() == want:
			found = i
			break
	_bone_cache[name] = found
	return found


## Pose d'un modèle à clips : temps dans le clip de l'action, puis éventuel mouvement du corps (actions sans clip propre).
func _set_pose_clip(anim: String, ph: float, back: bool) -> void:
	var c: Dictionary = _clips.get(anim, _clips["idle"])
	var name: String = String(c["clip"])
	if _ap.has_animation(name):
		var len: float = _ap.get_animation(name).length
		var t: float = clampf(lerpf(float(c["t0"]), float(c["t1"]), clampf(ph, 0.0, 1.0)), 0.0, len)
		if _ap.current_animation != name:
			_ap.play(name)
		_ap.seek(t, true)
		_ap.pause()
		_ap.advance(0.0)
	var dy: float = 0.0
	var pitch: float = 0.0
	var s1: float = sin(clampf(ph, 0.0, 1.0) * PI)
	match String(c.get("motion", "")):
		"walk":
			dy = 0.025 * absf(sin(ph * TAU * 2.0))
		"attack":
			pitch = 14.0 * s1
			dy = 0.03 * s1
		"cast":
			dy = 0.07 * s1
			pitch = -6.0 * s1
		"hit":
			pitch = -12.0 * s1
	_holder.position = Vector3(0, dy * HERO_H, 0)
	_holder.rotation_degrees = Vector3(pitch, 180.0 if back else 0.0, 0)


func _set_pose(anim: String, ph: float, back: bool) -> void:
	if _ap != null:
		_set_pose_clip(anim, ph, back)
		return
	for i: int in range(_sk.get_bone_count()):
		_sk.set_bone_pose_rotation(i, _rest_q[i])
		_sk.set_bone_pose_position(i, _rest_p[i])
	var p: Dictionary = HeroAnim.pose(anim, ph)
	var bones: Dictionary = p["bones"]
	for bn: String in bones.keys():
		var i2: int = _bone(bn)
		if i2 < 0:
			continue
		var e: Vector3 = (bones[bn] as Vector3) * (PI / 180.0)
		_sk.set_bone_pose_rotation(i2, _rest_q[i2] * Quaternion.from_euler(e))
	_holder.position = Vector3(float(p["dx"]) * HERO_H, float(p["dy"]) * HERO_H, 0)
	var yaw: float = float(HeroAnim.ANIMS[anim]["yaw"]) + float(p["yaw"])
	_holder.rotation_degrees = Vector3(float(p["pitch"]), 180.0 - yaw if back else yaw, 0)
	if p.has("staff") and tip_ok and ready_ok:
		_aim_staff(p["staff"] as Vector3, float(p["staff_w"]))
