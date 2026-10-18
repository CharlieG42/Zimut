extends SceneTree
## Capture de l'écran de fin de combat (combat auto accéléré).
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0] if OS.get_cmdline_user_args().size() > 0 else "/tmp/result"
	DirAccess.make_dir_recursive_absolute(out)
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	var gs: Node = root.get_node("GameSettings")
	gs.tutorial_done = true
	gs.speed_override = 8.0
	var data: Dictionary = pm.new_game(4, "Résultat")
	pm.rebuild_team(data, ["Tank", "Mage", "Heal"])
	gm.active_save = data
	gm.active_slot = 4
	gm.set_custom_team([{"classe": "Tank"}, {"classe": "Mage"}, {"classe": "Heal"}])
	gm.auto_mode = true
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	var t0: int = Time.get_ticks_msec()
	while not gm.game_over and Time.get_ticks_msec() - t0 < 150000:
		await create_timer(0.5).timeout
	Engine.time_scale = 1.0
	await create_timer(3.5).timeout
	print("fin : victoire=", gm.victory, " stats=", gm.combat_stats.size())
	root.get_viewport().get_texture().get_image().save_png(out + "/result.png")
	pm.delete_save(4)
	quit(0)
