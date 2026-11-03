extends SceneTree
## Gros plan du héros 3D (face, trois-quarts, dos) pour juger le modèle.
##   xvfb-run -a -s "-screen 0 1280x960x24" godot --rendering-method gl_compatibility --path . -s tests/shot_hero_close.gd -- <dossier> [classe]

func _init() -> void:
	_run.call_deferred()


func _run() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var out: String = args[0]
	var classe: String = args[1] if args.size() > 1 else ""
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.62, 0.78, 0.92)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.82, 0.86, 0.95)
	env.ambient_light_energy = 0.6
	var we := WorldEnvironment.new()
	we.environment = env
	root.add_child(we)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-48, -35, 0)
	sun.light_energy = 0.92
	root.add_child(sun)
	Adv3DMeshes.setup_sun(sun, env)
	var floor_mi := MeshInstance3D.new()
	var pm := PlaneMesh.new()
	pm.size = Vector2(8, 8)
	floor_mi.mesh = pm
	var fm := StandardMaterial3D.new()
	fm.albedo_color = Color(0.45, 0.62, 0.30)
	floor_mi.material_override = fm
	root.add_child(floor_mi)
	var hero: Node3D = Adv3DHeroModel.make_hero(classe)
	root.add_child(hero)
	var cam := Camera3D.new()
	cam.fov = 32.0
	root.add_child(cam)
	cam.current = true
	var views: Dictionary = {"face": 0.0, "trois_quarts": 0.7, "dos": PI}
	for nm: String in views.keys():
		hero.rotation.y = views[nm]
		cam.position = Vector3(0.0, 1.25, 4.6)
		cam.look_at(Vector3(0, 1.05, 0))
		for i: int in range(6):
			await process_frame
		root.get_texture().get_image().save_png(out + "/hero_%s.png" % nm)
	var head_cam := Vector3(0.0, 1.85, 1.5)
	hero.rotation.y = 0.35
	cam.position = head_cam
	cam.look_at(Vector3(0, 1.75, 0))
	for i: int in range(6):
		await process_frame
	root.get_texture().get_image().save_png(out + "/hero_tete.png")
	print("done")
	quit()
