extends SceneTree
## Cuit les animations d'un héros 3D (FBX avec squelette) en images brutes pour le mode Tactique.
##   xvfb-run -a -s "-screen 0 1280x720x24" godot --rendering-method gl_compatibility --path . \
##       -s tools/bake_hero_seq.gd -- <hero.fbx> <dossier_sortie> [anim:image ...]
## Écrit <dossier>/raw/<vue>/<anim>_<NN>.png (images brutes, fond transparent, 2× la taille finale),
## <dossier>/meta.json (cellule, images clés, position du bout du bâton dans chaque image).
## Le script tools/pack_hero_seq.py réduit, ajoute le contour et assemble les deux planches.
## Sans « anim:image » : tout est cuit. Avec : seulement ces images (réglage des poses).
## Les animations viennent de tools/hero_anim.gd (os nommés comme dans le modèle de Sylvain).

const HeroAnimS := preload("res://tools/hero_anim.gd")
const CELL := 192                 # cellule finale (carrée)
const SS := 2                     # sur-échantillonnage avant réduction
const CHAR_FRAC := 0.74           # hauteur du personnage au repos dans la cellule
const FEET_ROW := 0.965           # ligne des pieds dans la cellule
const VIEWS := ["front", "back"]  # vue 3/4 de face / 3/4 de dos (la rotation vient de HeroAnim)
const TIP_BONE := "main.r"        # la main qui tient le bâton
const STAFF_X := -0.0035          # espace du maillage de Sylvain : le bâton est à gauche de cette abscisse…
const STAFF_Z_MAX := 0.0045       # …et sous cette hauteur (au-dessus, ce sont des mèches de cheveux)
const SHADER := """
shader_type spatial;
render_mode cull_back, specular_disabled;
uniform sampler2D albedo_tex : source_color, filter_linear_mipmap, repeat_enable, hint_default_white;
void fragment() {
	vec3 c = texture(albedo_tex, UV).rgb;
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

var _vp: SubViewport
var _cam: Camera3D
var _holder: Node3D
var _sk: Skeleton3D
var _rest_q: Array = []
var _rest_p: Array = []
var _hero_h: float = 1.8
var _tip_local := Vector3.ZERO     # bout du bâton dans le repère de la main
var _tip_ok: bool = false
var _staff_mesh: ArrayMesh = null
var _rest_dir := Vector3.UP        # direction du bâton au repos (espace du squelette)
var _mi: MeshInstance3D = null
var _skin: Skin = null

func _init() -> void:
	_run.call_deferred()

func _run() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var fbx: String = args[0]
	var out: String = args[1]
	var only: Array = []
	for k: int in range(2, args.size()):
		only.append(args[k])
	DirAccess.make_dir_recursive_absolute(out + "/raw/front")
	DirAccess.make_dir_recursive_absolute(out + "/raw/back")
	_vp = SubViewport.new()
	_vp.size = Vector2i(CELL * SS, CELL * SS)
	_vp.transparent_bg = true
	_vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	_vp.msaa_3d = Viewport.MSAA_4X
	root.add_child(_vp)
	var env := Environment.new()
	env.background_mode = Environment.BG_CLEAR_COLOR
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.86, 0.90, 1.0)
	env.ambient_light_energy = 0.55
	var we := WorldEnvironment.new()
	we.environment = env
	_vp.add_child(we)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-38, -28, 0)
	sun.light_energy = 0.9
	_vp.add_child(sun)
	_cam = Camera3D.new()
	_cam.projection = Camera3D.PROJECTION_ORTHOGONAL
	_cam.size = 3.0
	_vp.add_child(_cam)
	_cam.current = true
	if not _load_model(fbx):
		quit(1)
		return
	# cadrage : un rendu de la pose de repos de face fixe l'échelle pour toutes les images
	_set_pose("idle", 0.0, "front")
	_cam.position = Vector3(0, 0.9, 10)
	await _render()
	var img0: Image = _capture()
	var bb: Rect2i = _alpha_bbox(img0)
	if bb.size.y < 10:
		push_error("personnage introuvable dans l'image (cadrage)")
		quit(1)
		return
	var vp_h: float = float(CELL * SS)
	var wpp_old: float = _cam.size / vp_h
	var feet_world: float = _cam.position.y + (0.5 * vp_h - float(bb.end.y)) * wpp_old
	var f: float = (CHAR_FRAC * vp_h) / float(bb.size.y)
	_cam.size = _cam.size / f
	var wpp: float = _cam.size / vp_h
	_cam.position = Vector3(0, feet_world - (0.5 * vp_h - FEET_ROW * vp_h) * wpp, 10)
	print("cadrage : ", bb, " taille caméra ", _cam.size)
	await _calibrate_tip()
	var meta := {"cell": CELL, "char_frac": CHAR_FRAC, "feet_row": FEET_ROW, "views": VIEWS, "anims": {}}
	var tip_ok: bool = _tip_ok
	for an: String in HeroAnimS.ANIMS.keys():
		var info: Dictionary = HeroAnimS.ANIMS[an]
		var n: int = int(info["n"])
		var tips := {}
		meta["anims"][an] = {"n": n, "loop": bool(info["loop"]), "key": int(info["key"]), "dur": float(info["dur"]), "tips": tips}
		for view: String in VIEWS:
			var arr: Array = []
			for i: int in range(n):
				if not only.is_empty() and not only.has("%s:%d" % [an, i]):
					arr.append([0, 0])
					continue
				_set_pose(an, HeroAnimS.phase(an, i), view)
				await _render()
				var img: Image = _capture()
				img.save_png("%s/raw/%s/%s_%02d.png" % [out, view, an, i])
				if tip_ok:
					var tp: Vector2 = _tip_pixel()
					arr.append([snappedf(tp.x / float(SS), 0.1), snappedf(tp.y / float(SS), 0.1)])
				else:
					arr.append([0, 0])
			tips[view] = arr
	var f2 := FileAccess.open(out + "/meta.json", FileAccess.WRITE)
	f2.store_string(JSON.stringify(meta, "\t"))
	f2.close()
	print("OK ", out)
	quit()


func _load_model(path: String) -> bool:
	var doc := FBXDocument.new()
	var st := FBXState.new()
	if doc.append_from_file(path, st) != OK:
		push_error("FBX illisible : " + path)
		return false
	var n: Node3D = doc.generate_scene(st) as Node3D
	_holder = Node3D.new()
	_vp.add_child(_holder)
	var model := Node3D.new()
	_holder.add_child(model)
	model.add_child(n)
	_sk = n.find_children("*", "Skeleton3D", true, false)[0] as Skeleton3D
	var mi: MeshInstance3D = n.find_children("*", "MeshInstance3D", true, false)[0] as MeshInstance3D
	var src: Material = mi.mesh.surface_get_material(0)
	var tex: Texture2D = (src as BaseMaterial3D).albedo_texture if src is BaseMaterial3D else null
	if tex == null:
		push_error("texture introuvable : exporte le FBX avec les textures intégrées")
		return false
	var sh := Shader.new()
	sh.code = SHADER
	var mat := ShaderMaterial.new()
	mat.shader = sh
	mat.set_shader_parameter("albedo_tex", tex)
	mi.set_surface_override_material(0, mat)
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
	var s: float = _hero_h / maxf(hi.y - lo.y, 0.0001)
	model.scale = Vector3.ONE * s
	var bas: int = _sk.find_bone("bassin")
	var bx: float = (_sk.global_transform * _sk.get_bone_global_pose(bas)).origin.x
	model.position = Vector3(-bx * s, -lo.y * s, 0)
	_skin = mi.skin
	_mi = mi
	_rig_staff(mi)
	mi.set_surface_override_material(0, mat)
	return true


## Le bâton de Sylvain est lié à la main, mais ses derniers centimètres (le cristal) sont répartis sur le torse :
## dès que le bras bouge, le haut du bâton s'étire. On le rend rigide (100 % main) : tous les sommets du côté
## du bâton (x < STAFF_X dans l'espace du maillage). Le bout du bâton est alors le plus haut de ces sommets (z).
func _rig_staff(mi: MeshInstance3D) -> void:
	var arr: Array = mi.mesh.surface_get_arrays(0)
	var verts: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
	var bones: PackedInt32Array = arr[Mesh.ARRAY_BONES]
	var weights: PackedFloat32Array = arr[Mesh.ARRAY_WEIGHTS]
	var per: int = bones.size() / verts.size()
	var hand: int = _sk.find_bone(TIP_BONE)
	var hand_bind: int = -1
	for b: int in range(_skin.get_bind_count()):
		if _bind_bone(b) == hand:
			hand_bind = b
	if hand_bind < 0:
		push_warning("os de la main introuvable : bâton non rigidifié")
		return
	var best: int = -1
	var fixed: int = 0
	for v: int in range(verts.size()):
		if verts[v].x >= STAFF_X or verts[v].z > STAFF_Z_MAX:
			continue
		for k: int in range(per):
			bones[v * per + k] = hand_bind if k == 0 else 0
			weights[v * per + k] = 1.0 if k == 0 else 0.0
		fixed += 1
		best = v
	if best < 0:
		push_warning("bâton introuvable (STAFF_X)")
		return
	arr[Mesh.ARRAY_BONES] = bones
	arr[Mesh.ARRAY_WEIGHTS] = weights
	# maillage du seul bâton (triangles dont les 3 sommets sont du côté du bâton) : sert à mesurer son bout
	var idx: PackedInt32Array = arr[Mesh.ARRAY_INDEX]
	var sub := PackedInt32Array()
	for t: int in range(idx.size() / 3):
		if _is_staff(verts[idx[t * 3]]) and _is_staff(verts[idx[t * 3 + 1]]) and _is_staff(verts[idx[t * 3 + 2]]):
			sub.append(idx[t * 3])
			sub.append(idx[t * 3 + 1])
			sub.append(idx[t * 3 + 2])
	var arr2: Array = arr.duplicate()
	arr2[Mesh.ARRAY_INDEX] = sub
	_staff_mesh = ArrayMesh.new()
	_staff_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr2)
	var am := ArrayMesh.new()
	am.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)
	am.surface_set_material(0, mi.mesh.surface_get_material(0))
	mi.mesh = am
	print("bâton rigidifié : ", fixed, " sommets")


func _is_staff(p: Vector3) -> bool:
	return p.x < STAFF_X and p.z <= STAFF_Z_MAX


func _bind_bone(b: int) -> int:
	if _skin != null and b < _skin.get_bind_count():
		var idx: int = _skin.get_bind_bone(b)
		if idx >= 0:
			return idx
		return _sk.find_bone(_skin.get_bind_name(b))
	return b


## Position à l'écran (pixels du viewport) du bout du bâton dans la pose courante : le point mesuré au repos
## est fixe dans le repère de la main (le bâton est rigide).
func _tip_pixel() -> Vector2:
	var hand: int = _sk.find_bone(TIP_BONE)
	var g: Transform3D = _sk.global_transform * _sk.get_bone_global_pose(hand)
	return _cam.unproject_position(g * _tip_local)


## Mesure le bout du bâton : on rend le seul maillage du bâton (uni) sur la pose de repos, sous deux angles (la caméra
## est orthogonale : un seul angle ne donne pas la profondeur). Le point le plus haut est le cristal ; sa position 3D se
## déduit des deux rendus, puis elle est exprimée dans le repère de la main.
func _calibrate_tip() -> void:
	var keep_mesh: Mesh = _mi.mesh
	var keep_mat: Material = _mi.get_surface_override_material(0)
	var flat := StandardMaterial3D.new()
	flat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	flat.albedo_color = Color(1, 0, 1)
	_mi.mesh = _staff_mesh
	_mi.set_surface_override_material(0, flat)
	var yaw1: float = _holder.rotation_degrees.y
	var yaw2: float = yaw1 + 90.0
	var res: Array = []
	for yw: float in [yaw1, yaw2]:
		_holder.rotation_degrees = Vector3(0, yw, 0)
		await _render()
		var img: Image = _capture()
		var ty: int = -1
		for y: int in range(img.get_height()):
			for x: int in range(img.get_width()):
				if img.get_pixel(x, y).a > 0.5:
					ty = y
					break
			if ty >= 0:
				break
		if ty < 0:
			push_warning("bâton invisible à la mesure")
			_mi.mesh = keep_mesh
			_mi.set_surface_override_material(0, keep_mat)
			return
		var sx: float = 0.0
		var cnt: int = 0
		for x2: int in range(img.get_width()):
			if img.get_pixel(x2, ty).a > 0.5:
				sx += float(x2)
				cnt += 1
		res.append(Vector2(sx / float(cnt), float(ty)))
	_mi.mesh = keep_mesh
	_mi.set_surface_override_material(0, keep_mat)
	_holder.rotation_degrees = Vector3(0, yaw1, 0)
	var wpp: float = _cam.size / float(CELL * SS)
	var xs: Array = []
	for r: Vector2 in res:
		xs.append(_cam.position.x + (r.x - 0.5 * float(CELL * SS)) * wpp)
	var wy: float = _cam.position.y + (0.5 * float(CELL * SS) - float((res[0] as Vector2).y)) * wpp
	# x_caméra = Qx·cos θ + Qz·sin θ (rotation Y du holder) pour le point Q du repère du holder
	var c1: float = cos(deg_to_rad(yaw1))
	var s1: float = sin(deg_to_rad(yaw1))
	var c2: float = cos(deg_to_rad(yaw2))
	var s2: float = sin(deg_to_rad(yaw2))
	var det: float = c1 * s2 - c2 * s1
	var qx: float = (float(xs[0]) * s2 - float(xs[1]) * s1) / det
	var qz: float = (c1 * float(xs[1]) - c2 * float(xs[0])) / det
	var q := Vector3(qx, wy - _holder.position.y, qz)
	var hand: int = _sk.find_bone(TIP_BONE)
	var g: Transform3D = _sk.global_transform * _sk.get_bone_global_pose(hand)
	_tip_local = g.affine_inverse() * (_holder.global_transform * q)
	_rest_dir = (g.basis * _tip_local).normalized()
	_tip_ok = true
	print("bout du bâton (repère main) : ", _tip_local)


## Oriente le bâton : après la pose des os, fait pivoter la main pour que le bâton pointe dans la direction [d] (repère du
## personnage vu de face : x = vers la droite de l'écran, y = haut, z = vers l'avant). Le bras garde sa pose (position de
## la main), seul l'angle du bâton est imposé : plus besoin de régler à la main les rotations des trois os du bras.
func _aim_staff(d: Vector3, w: float = 1.0) -> void:
	var hand: int = _sk.find_bone(TIP_BONE)
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


func _set_pose(an: String, ph: float, view: String) -> void:
	for i: int in range(_sk.get_bone_count()):
		_sk.set_bone_pose_rotation(i, _rest_q[i])
		_sk.set_bone_pose_position(i, _rest_p[i])
	var p: Dictionary = HeroAnimS.pose(an, ph)
	var bones: Dictionary = p["bones"]
	for bn: String in bones.keys():
		var i2: int = _sk.find_bone(bn)
		if i2 < 0:
			push_warning("os inconnu : " + bn)
			continue
		var e: Vector3 = (bones[bn] as Vector3) * (PI / 180.0)
		_sk.set_bone_pose_rotation(i2, _rest_q[i2] * Quaternion.from_euler(e))
	_holder.position = Vector3(float(p["dx"]) * _hero_h, float(p["dy"]) * _hero_h, 0)
	var yaw: float = float(HeroAnimS.ANIMS[an]["yaw"]) + float(p["yaw"])
	_holder.rotation_degrees = Vector3(float(p["pitch"]), yaw if view == "front" else 180.0 - yaw, 0)
	if p.has("staff") and _tip_ok:
		_aim_staff(p["staff"] as Vector3, float(p["staff_w"]))


func _render() -> void:
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw


func _capture() -> Image:
	var img: Image = _vp.get_texture().get_image()
	img.convert(Image.FORMAT_RGBA8)
	return img


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
