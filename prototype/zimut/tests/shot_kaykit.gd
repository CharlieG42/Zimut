extends SceneTree
## Les 10 classes en héros KayKit : ligne de classes au repos + marche + course.
##   xvfb-run -a -s "-screen 0 1920x720x24" godot --rendering-method gl_compatibility --path . -s tests/shot_kaykit.gd -- <dossier>

func _init() -> void:
	_run.call_deferred()


func _run() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
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
	var fl := MeshInstance3D.new()
	var pm := PlaneMesh.new()
	pm.size = Vector2(30, 10)
	fl.mesh = pm
	var fm := StandardMaterial3D.new()
	fm.albedo_color = Color(0.45, 0.62, 0.30)
	fl.material_override = fm
	root.add_child(fl)
	var classes: Array = ["Tank", "Assassin", "Chasseur", "Mage", "Sylvain", "Druide", "Heal", "Invocateur", "Géomancien", "Artificier"]
	var heroes: Array = []
	for i: int in range(classes.size()):
		var h: Adv3DHeroRig = Adv3DHeroModel.make_player(classes[i]) as Adv3DHeroRig
		root.add_child(h)
		h.position = Vector3((i - 4.5) * 1.25, 0, 0)
		heroes.append(h)
	var cam := Camera3D.new()
	cam.fov = 28.0
	root.add_child(cam)
	cam.current = true
	cam.position = Vector3(0, 1.5, 15.5)
	cam.look_at(Vector3(0, 1.0, 0))
	for k: int in range(30):
		for h: Adv3DHeroRig in heroes:
			h.animate(0.05, 0.0, 0.0)
		await process_frame
	root.get_texture().get_image().save_png(out + "/kk_classes_repos.png")
	for k: int in range(40):
		for h: Adv3DHeroRig in heroes:
			h.animate(0.05, 2.2, 0.0)
		await process_frame
	root.get_texture().get_image().save_png(out + "/kk_classes_marche.png")
	for k: int in range(40):
		for h: Adv3DHeroRig in heroes:
			h.animate(0.05, 5.0, 0.0)
		await process_frame
	root.get_texture().get_image().save_png(out + "/kk_classes_course.png")
	print("done")
	quit()
