extends SceneTree
## Convertit un personnage Mixamo (.fbx, rig mixamorig_*) en .glb léger pour le jeu :
## texture réduite (WebP avec perte), maillage simplifié (meshoptimizer, via les niveaux de détail de Godot),
## animation renommée. Les FBX bruts ne sont pas versionnés.
##   godot --headless --path . -s tools/import_mixamo.gd -- <entrée.fbx> <sortie.glb> <nom_animation> [taille_texture=1024] [triangles_max=7000]
## Pas d'écran nécessaire. Exemple (V153) :
##   godot --headless --path . -s tools/import_mixamo.gd -- Walking.fbx assets/zimut/zimut.glb Walk 1024 7000

func _init() -> void:
	var a: PackedStringArray = OS.get_cmdline_user_args()
	if a.size() < 3:
		push_error("usage : -- <entrée.fbx> <sortie.glb> <nom_animation> [taille_texture]")
		quit(1)
		return
	var tex_size: int = int(a[3]) if a.size() > 3 else 1024
	var max_tris: int = int(a[4]) if a.size() > 4 else 7000
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
			print("texture ", img.get_width(), "x", img.get_height())
	for mi2: Node in scene.find_children("*", "MeshInstance3D", true, false):
		_simplify(mi2 as MeshInstance3D, max_tris)
	var ap: AnimationPlayer = scene.find_children("*", "AnimationPlayer", true, false)[0] as AnimationPlayer
	var lib: AnimationLibrary = ap.get_animation_library(&"")
	var names: PackedStringArray = lib.get_animation_list()
	if names.size() >= 1 and String(names[0]) != a[2]:
		lib.rename_animation(StringName(names[0]), StringName(a[2]))
	var gd := GLTFDocument.new()
	gd.image_format = "Lossy WebP"
	gd.lossy_quality = 0.88
	var out := GLTFState.new()
	if gd.append_from_scene(scene, out) != OK or gd.write_to_filesystem(out, a[1]) != OK:
		push_error("export glb impossible")
		quit(1)
		return
	print("OK ", a[1], " animations : ", ap.get_animation_list())
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
	var pick: PackedInt32Array = PackedInt32Array()
	for l: int in range(im.get_surface_lod_count(0)):
		var idx: PackedInt32Array = im.get_surface_lod_indices(0, l)
		if idx.size() / 3 <= max_tris and (pick.is_empty() or idx.size() > pick.size()):
			pick = idx
	if pick.is_empty():
		print("simplification : aucun niveau sous ", max_tris, " triangles, maillage gardé (", best_n, ")")
		return
	arrays[Mesh.ARRAY_INDEX] = pick
	var am := ArrayMesh.new()
	am.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	am.surface_set_material(0, m.surface_get_material(0))
	mi.mesh = am
	print("maillage : ", best_n, " -> ", pick.size() / 3, " triangles")
