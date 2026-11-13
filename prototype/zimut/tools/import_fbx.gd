extends SceneTree
## Convertit un personnage animé (.fbx exporté par Meshy, squelette humanoïde) en .glb léger pour le jeu :
## texture réduite (WebP avec perte), maillage simplifié (meshoptimizer, via les niveaux de détail de Godot),
## première animation renommée (nom « none » : toutes les animations gardent leur nom ; sans animation : rien à renommer), 4 influences de peau par sommet au plus.
## Les FBX bruts ne sont pas versionnés.
##   godot --headless --path . -s tools/import_fbx.gd -- <entrée.fbx> <sortie.glb> <nom_animation> [taille_texture=1024] [triangles_max=7000] [rigide]
## « rigide » = cible:os1,os2,… (ex. hand.R:thumb.01.R,Bone_053) : les sommets dont l'os dominant est dans la liste deviennent 100 % liés à la cible.
## Sert aux accessoires que Meshy répartit sur plusieurs os (hache du Tank : tête sur le pouce, bas du manche sur deux os racine → manche étiré).
## Pas d'écran nécessaire. Exemple (V153) :
##   godot --headless --path . -s tools/import_fbx.gd -- walking_meshy.fbx assets/zimut/zimut.glb Walk 1024 7000

func _init() -> void:
	var a: PackedStringArray = OS.get_cmdline_user_args()
	if a.size() < 3:
		push_error("usage : -- <entrée.fbx> <sortie.glb> <nom_animation> [taille_texture]")
		quit(1)
		return
	var tex_size: int = int(a[3]) if a.size() > 3 else 1024
	var max_tris: int = int(a[4]) if a.size() > 4 else 7000
	var rigid: String = a[5] if a.size() > 5 else ""
	var doc := FBXDocument.new()
	var st := FBXState.new()
	if doc.append_from_file(a[0], st) != OK:
		push_error("FBX illisible : " + a[0])
		quit(1)
		return
	var scene: Node = doc.generate_scene(st)
	root.add_child(scene)
	var done := {}
	for mi: Node in scene.find_children("*", "MeshInstance3D", true, false):
		var m: Mesh = (mi as MeshInstance3D).mesh
		for s: int in range(m.get_surface_count()):
			var mat := m.surface_get_material(s) as BaseMaterial3D
			if mat == null or mat.albedo_texture == null or done.has(mat):
				continue
			done[mat] = true
			var img: Image = mat.albedo_texture.get_image()
			if img.is_compressed():
				img.decompress()
			var longest: int = maxi(img.get_width(), img.get_height())
			if longest > tex_size:
				var k: float = float(tex_size) / float(longest)
				img.resize(maxi(1, roundi(img.get_width() * k)), maxi(1, roundi(img.get_height() * k)), Image.INTERPOLATE_LANCZOS)
			mat.albedo_texture = ImageTexture.create_from_image(img)
			# le matériau toon du jeu n'utilise que la couleur : on n'exporte ni normales ni autres cartes
			mat.normal_enabled = false
			mat.normal_texture = null
			mat.roughness_texture = null
			mat.metallic_texture = null
			mat.emission_texture = null
			mat.ao_texture = null
			print("texture ", img.get_width(), "x", img.get_height())
	for mi2: Node in scene.find_children("*", "MeshInstance3D", true, false):
		_simplify(mi2 as MeshInstance3D, max_tris)
		if rigid != "":
			_make_rigid(mi2 as MeshInstance3D, rigid)
	var aps: Array = scene.find_children("*", "AnimationPlayer", true, false)
	var ap: AnimationPlayer = aps[0] as AnimationPlayer if not aps.is_empty() else null
	if ap != null:
		var lib: AnimationLibrary = ap.get_animation_library(&"")
		var names: PackedStringArray = lib.get_animation_list()
		if a[2] != "none" and names.size() >= 1 and String(names[0]) != a[2]:     # « none » : garder tous les noms d'animation
			lib.rename_animation(StringName(names[0]), StringName(a[2]))
	var gd := GLTFDocument.new()
	gd.image_format = "Lossy WebP"
	gd.lossy_quality = 0.88
	var out := GLTFState.new()
	if gd.append_from_scene(scene, out) != OK or gd.write_to_filesystem(out, a[1]) != OK:
		push_error("export glb impossible")
		quit(1)
		return
	print("OK ", a[1], " animations : ", ap.get_animation_list() if ap != null else "aucune")
	quit()


## Remplace le maillage par le plus grand niveau de détail qui tient dans max_tris (poids de peau conservés).
func _simplify(mi: MeshInstance3D, max_tris: int) -> void:
	var m: Mesh = mi.mesh
	var arrays: Array = m.surface_get_arrays(0)
	var im := ImporterMesh.new()
	im.add_surface(Mesh.PRIMITIVE_TRIANGLES, arrays, [], {}, m.surface_get_material(0), "s")
	# Sans tableau d'os : avec les poses de liaison, la simplification de Godot troue ce maillage (essayé en V153).
	im.generate_lods(25.0, 60.0, [])
	var best: PackedInt32Array = arrays[Mesh.ARRAY_INDEX]
	var best_n: int = best.size() / 3
	if best_n <= max_tris:
		# déjà assez léger (ex. Meshy, ~10 000 triangles) : on garde le maillage tel quel, seules les influences sont limitées
		arrays = _limit_influences(arrays, 4)
		var am0 := ArrayMesh.new()
		am0.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
		am0.surface_set_material(0, m.surface_get_material(0))
		mi.mesh = am0
		print("maillage gardé : ", best_n, " triangles")
		return
	var pick: PackedInt32Array = PackedInt32Array()
	for l: int in range(im.get_surface_lod_count(0)):
		var idx: PackedInt32Array = im.get_surface_lod_indices(0, l)
		if idx.size() / 3 <= max_tris and (pick.is_empty() or idx.size() > pick.size()):
			pick = idx
	if pick.is_empty():
		print("simplification : aucun niveau sous ", max_tris, " triangles, maillage gardé (", best_n, ")")
		return
	arrays = _compact(arrays, pick)
	arrays = _limit_influences(arrays, 4)
	var am := ArrayMesh.new()
	am.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	am.surface_set_material(0, m.surface_get_material(0))
	mi.mesh = am
	print("maillage : ", best_n, " -> ", pick.size() / 3, " triangles, ", (arrays[Mesh.ARRAY_VERTEX] as PackedVector3Array).size(), " sommets")


## Ne garde que les [n] influences de peau les plus fortes de chaque sommet (renormalisées) : le rendu mobile n'en lit que 4.
func _limit_influences(arrays: Array, n: int) -> Array:
	var bones: Variant = arrays[Mesh.ARRAY_BONES]
	var weights: Variant = arrays[Mesh.ARRAY_WEIGHTS]
	if bones == null or weights == null:
		return arrays
	var count: int = (arrays[Mesh.ARRAY_VERTEX] as PackedVector3Array).size()
	var per: int = (bones as PackedInt32Array).size() / count
	if per <= n:
		return arrays
	var b2 := PackedInt32Array()
	var w2 := PackedFloat32Array()
	b2.resize(count * n)
	w2.resize(count * n)
	for v: int in range(count):
		var order: Array = range(per)
		order.sort_custom(func(x: int, y: int) -> bool: return weights[v * per + x] > weights[v * per + y])
		var tot: float = 0.0
		for k: int in range(n):
			tot += weights[v * per + int(order[k])]
		for k2: int in range(n):
			b2[v * n + k2] = bones[v * per + int(order[k2])]
			w2[v * n + k2] = weights[v * per + int(order[k2])] / maxf(tot, 0.0001)
	arrays[Mesh.ARRAY_BONES] = b2
	arrays[Mesh.ARRAY_WEIGHTS] = w2
	return arrays


## Ne garde que les sommets utilisés par les triangles retenus (sinon le fichier garde tous les sommets d'origine).
func _compact(arrays: Array, indices: PackedInt32Array) -> Array:
	var remap := {}
	var order := PackedInt32Array()
	var new_idx := PackedInt32Array()
	new_idx.resize(indices.size())
	for i: int in range(indices.size()):
		var v: int = indices[i]
		if not remap.has(v):
			remap[v] = order.size()
			order.append(v)
		new_idx[i] = remap[v]
	var out: Array = []
	out.resize(Mesh.ARRAY_MAX)
	var n_old: int = (arrays[Mesh.ARRAY_VERTEX] as PackedVector3Array).size()
	for k: int in range(Mesh.ARRAY_MAX):
		var src: Variant = arrays[k]
		if k == Mesh.ARRAY_INDEX or src == null:
			continue
		match typeof(src):
			TYPE_PACKED_VECTOR3_ARRAY:
				var d := PackedVector3Array()
				for v: int in order:
					d.append(src[v])
				out[k] = d
			TYPE_PACKED_VECTOR2_ARRAY:
				var d2 := PackedVector2Array()
				for v: int in order:
					d2.append(src[v])
				out[k] = d2
			TYPE_PACKED_COLOR_ARRAY:
				var d3 := PackedColorArray()
				for v: int in order:
					d3.append(src[v])
				out[k] = d3
			TYPE_PACKED_FLOAT32_ARRAY:
				var per: int = src.size() / n_old     # valeurs par sommet (tangentes : 4 ; poids : 4 ou 8)
				var d4 := PackedFloat32Array()
				for v: int in order:
					for j: int in range(per):
						d4.append(src[v * per + j])
				out[k] = d4
			TYPE_PACKED_INT32_ARRAY:
				var per2: int = src.size() / n_old
				var d5 := PackedInt32Array()
				for v: int in order:
					for j: int in range(per2):
						d5.append(src[v * per2 + j])
				out[k] = d5
			_:
				out[k] = src
	out[Mesh.ARRAY_INDEX] = new_idx
	return out


## Rend rigides les sommets dont l'os dominant est l'un des os sources ("cible:src1,src2") : 100 % sur l'os cible.
func _make_rigid(mi: MeshInstance3D, spec: String) -> void:
	var parts: PackedStringArray = spec.split(":")
	if parts.size() != 2 or mi.skin == null:
		push_error("rigide : format cible:os1,os2 attendu (et maillage avec peau)")
		return
	var skel: Skeleton3D = mi.get_node_or_null(mi.skeleton) as Skeleton3D
	var skin: Skin = mi.skin
	var names := {}
	for b: int in range(skin.get_bind_count()):
		var idx: int = skin.get_bind_bone(b)
		names[skel.get_bone_name(idx) if (idx >= 0 and skel != null) else skin.get_bind_name(b)] = b
	if not names.has(parts[0]):
		push_error("rigide : os cible introuvable : " + parts[0])
		return
	var srcs := {}
	for nm: String in parts[1].split(","):
		if not names.has(nm):
			push_error("rigide : os source introuvable : " + nm)
			return
		srcs[names[nm]] = true
	var target: int = names[parts[0]]
	var arrays: Array = mi.mesh.surface_get_arrays(0)
	var bones: PackedInt32Array = arrays[Mesh.ARRAY_BONES]
	var weights: PackedFloat32Array = arrays[Mesh.ARRAY_WEIGHTS]
	var count: int = (arrays[Mesh.ARRAY_VERTEX] as PackedVector3Array).size()
	var per: int = bones.size() / count
	var changed: int = 0
	for v: int in range(count):
		var best: int = 0
		for k: int in range(1, per):
			if weights[v * per + k] > weights[v * per + best]:
				best = k
		if srcs.has(bones[v * per + best]):
			for k2: int in range(per):
				bones[v * per + k2] = target if k2 == 0 else 0
				weights[v * per + k2] = 1.0 if k2 == 0 else 0.0
			changed += 1
	arrays[Mesh.ARRAY_BONES] = bones
	arrays[Mesh.ARRAY_WEIGHTS] = weights
	var am := ArrayMesh.new()
	am.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	am.surface_set_material(0, mi.mesh.surface_get_material(0))
	mi.mesh = am
	print("rigide : ", changed, " sommets liés à 100 % à ", parts[0])
