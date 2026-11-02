extends SceneTree
## Alignement des 10 tenues de héros 3D :
##   xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_heros_classes.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var w := Node3D.new()
	root.add_child(w)
	var env := Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.55, 0.7, 0.85)
	env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.ambient_light_color = Color(0.8, 0.85, 0.95)
	env.ambient_light_energy = 0.6
	var we := WorldEnvironment.new()
	we.environment = env
	w.add_child(we)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-40, -30, 0)
	w.add_child(sun)
	var cls: Array = Adv3DHeroModel.CLASS_LOOK.keys()
	for i: int in range(cls.size()):
		var h: Node3D = Adv3DHeroModel.make_hero(String(cls[i]))
		h.position = Vector3((float(i % 5) - 2.0) * 1.1, 0.0, -float(i / 5) * 1.8)
		w.add_child(h)
	var cam := Camera3D.new()
	cam.position = Vector3(0, 2.9, 4.8)
	w.add_child(cam)
	cam.look_at(Vector3(0, 1.0, -0.9))
	cam.fov = 45.0
	await create_timer(1.0).timeout
	root.get_texture().get_image().save_png(out + "/heros_classes.png")
	quit(0)
