extends SceneTree
## xvfb-run -a -s "-screen 0 1920x1080x24" godot --rendering-method gl_compatibility --rendering-driver opengl3 --path . -s tests/shot_shapes_v43.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	var data: Dictionary = pm.new_game(4, "ShotShape")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	gm.active_save = data
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/AdventureMap.tscn") as PackedScene).instantiate()
	data["campaign_mode"] = "adventure"
	pm.adventure_state(data)["zone"] = "foret_sylve"
	root.add_child(sc)
	await create_timer(1.0).timeout
	root.get_viewport().get_texture().get_image().save_png(out + "/adv_big.png")
	sc.queue_free()
	await process_frame
	gm.fight_biome = "Forêt"
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await create_timer(1.2).timeout
	for i in range(6):
		if gm.board_shape != "square": break
		gm.reset_game()
		await create_timer(0.8).timeout
	print("forme: ", gm.board_shape)
	root.get_viewport().get_texture().get_image().save_png(out + "/combat_shape.png")
	pm.delete_save(4)
	quit()
