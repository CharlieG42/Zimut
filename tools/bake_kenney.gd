extends SceneTree
## Cuit des modèles 3D Kenney (GLB) en sprites isométriques 2:1 (fond transparent).
## Usage (depuis prototype/zimut) :
##   xvfb-run -a godot --rendering-method gl_compatibility --path . -s ../../tools/bake_kenney.gd -- jobs.json sortie/
## jobs.json : [{name, fp:[nx,nz], gs?, parts:[{f, p, r, sc, s}]}]  (f relatif à atelier_3d/kenney/)
## Écrit <name>.png (non rogné) + <name>.json (pixel du sommet avant de l'emprise, pixels par unité).
const VIEW := 14.0
const PX := 1400

func _init() -> void:
	_boot.call_deferred()

func _aabb(n: Node, t: Transform3D, acc: Array) -> void:
	var tt: Transform3D = t
	if n is Node3D:
		tt = t * (n as Node3D).transform
	if n is MeshInstance3D:
		var bb: AABB = tt * (n as MeshInstance3D).get_aabb()
		acc[0] = bb if acc[0] == null else (acc[0] as AABB).merge(bb)
	for c in n.get_children():
		_aabb(c, tt, acc)

func _fix(n: Node) -> void:
	if n is MeshInstance3D:
		var mi: MeshInstance3D = n
		if mi.mesh != null:
			for i in range(mi.mesh.get_surface_count()):
				var m: Material = mi.mesh.surface_get_material(i)
				if m is BaseMaterial3D:
					var d: BaseMaterial3D = (m as BaseMaterial3D).duplicate()
					d.metallic = 0.0
					d.roughness = 0.9
					mi.set_surface_override_material(i, d)
	for c in n.get_children():
		_fix(c)

func _boot() -> void:
	var a: PackedStringArray = OS.get_cmdline_user_args()
	var jobs: Array = JSON.parse_string(FileAccess.get_file_as_string(a[0]))
	var out: String = a[1]
	DirAccess.make_dir_recursive_absolute(out)
	var base: String = ProjectSettings.globalize_path("res://").path_join("../../atelier_3d/kenney/")
	if OS.get_environment("KENNEY_DIR") != "":
		base = OS.get_environment("KENNEY_DIR").path_join("")   # dossier des kits, ex. un autre worktree
	for job in jobs:
		var vp := SubViewport.new()
		vp.size = Vector2i(PX, PX)
		vp.transparent_bg = true
		vp.own_world_3d = true
		vp.render_target_update_mode = SubViewport.UPDATE_ALWAYS
		var holder := Node3D.new()
		vp.add_child(holder)
		var asm := Node3D.new()
		var gs: float = float(job.get("gs", 1.0))
		asm.scale = Vector3(gs, gs, gs)
		holder.add_child(asm)
		for part in job["parts"]:
			var n: Node3D
			if part.has("prism"):
				# fronton triangulaire plein (le kit n'en fournit pas) : taille [largeur, hauteur, epaisseur]
				var pm := PrismMesh.new()
				var ps: Array = part["prism"]
				pm.size = Vector3(ps[0], ps[1], ps[2])
				var mat := StandardMaterial3D.new()
				var c: Array = part["col"]
				mat.albedo_color = Color(c[0], c[1], c[2])
				mat.roughness = 0.9
				pm.material = mat
				var mi := MeshInstance3D.new()
				mi.mesh = pm
				n = mi
			else:
				var doc := GLTFDocument.new()
				var st := GLTFState.new()
				doc.append_from_file(base + String(part["f"]), st)
				n = doc.generate_scene(st)
				_fix(n)
			var p: Array = part.get("p", [0, 0, 0])
			n.position = Vector3(p[0], p[1], p[2])
			n.rotation_degrees.y = float(part.get("r", 0))
			n.rotation_degrees.x = float(part.get("rx", 0))
			var sc: Array = part.get("sc", [1, 1, 1])
			n.scale = Vector3(sc[0], sc[1], sc[2]) * float(part.get("s", 1.0))
			asm.add_child(n)
		var e := Environment.new()
		e.background_mode = Environment.BG_COLOR
		e.background_color = Color(0, 0, 0, 0)
		e.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
		e.ambient_light_color = Color(0.92, 0.92, 0.9)
		e.ambient_light_energy = 0.5
		var env := WorldEnvironment.new()
		env.environment = e
		holder.add_child(env)
		var sun := DirectionalLight3D.new()
		sun.rotation_degrees = Vector3(-52, -38, 0)
		sun.light_energy = 0.7
		sun.light_color = Color(1.0, 0.97, 0.9)
		sun.shadow_enabled = true
		holder.add_child(sun)
		var cam := Camera3D.new()
		cam.projection = Camera3D.PROJECTION_ORTHOGONAL
		cam.size = float(job.get("view", VIEW))
		holder.add_child(cam)
		root.add_child(vp)
		await process_frame
		var fp: Array = job["fp"]
		var ctr := Vector3(float(fp[0]) * 0.5, float(job.get("cy", 2.5)), float(fp[1]) * 0.5)
		var dir := Vector3(1, 0.8165, 1).normalized()
		cam.look_at_from_position(ctr + dir * 40.0, ctr, Vector3.UP)
		cam.current = true
		for i in range(4):
			await process_frame
		await RenderingServer.frame_post_draw
		vp.get_texture().get_image().save_png("%s/%s.png" % [out, job["name"]])
		var front: Vector2 = cam.unproject_position(Vector3(float(fp[0]), 0.0, float(fp[1])))
		var f := FileAccess.open("%s/%s.json" % [out, job["name"]], FileAccess.WRITE)
		f.store_string(JSON.stringify({"fx": front.x, "fy": front.y, "ppu": float(PX) / VIEW, "nx": fp[0], "nz": fp[1]}))
		f.close()
		vp.queue_free()
	quit()
