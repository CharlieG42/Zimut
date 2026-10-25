extends SceneTree
## V52 : animation d'ouverture — scène principale, passage au menu (fin ou appui).
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	check(String(ProjectSettings.get_setting("application/run/main_scene")) == "res://scenes/Intro.tscn", "l'animation est la scène de démarrage")
	check(not bool(ProjectSettings.get_setting("application/boot_splash/show_image", true)), "écran de démarrage Godot masqué")
	var sc: Node = (load("res://scenes/Intro.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	current_scene = sc
	await create_timer(0.3).timeout
	var ev := InputEventMouseButton.new()
	ev.pressed = true
	ev.button_index = MOUSE_BUTTON_LEFT
	sc._gui_input(ev)
	await create_timer(1.2).timeout
	check(current_scene != null and current_scene.scene_file_path == "res://scenes/MainMenu.tscn", "un appui passe à l'Accueil (%s)" % (current_scene.scene_file_path if current_scene else "aucune"))
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
