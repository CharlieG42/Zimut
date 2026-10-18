extends SceneTree
## xvfb-run -a -s "-screen 0 1920x1080x24" godot --path . -s tests/shot_governors.gd -- <dossier> [largeur hauteur]
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var out: String = args[0]
	if args.size() >= 3:
		root.size = Vector2i(int(args[1]), int(args[2]))
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "Ma partie")
	if args.size() >= 4:
		root.get_node("GameSettings").set_text_size(int(args[3]))
	pm.write_save(4, data)
	var sc: Node = (load("res://scenes/SaveSlots.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(0.6).timeout
	# données de conquête factices
	var conq: Dictionary = {"owned": ["a", "b", "c", "d", "e", "f"], "names": {}, "garrisons": {"a": {"hero": "Tank"}, "b": {"hero": "Soigneur"}, "c": {"hero": "Géomancien"}}}
	data["conquest"] = conq
	sc.call("_show_governors", data)
	await create_timer(0.5).timeout
	root.get_viewport().get_texture().get_image().save_png(out + "/gov.png")
	pm.delete_save(4)
	quit()
