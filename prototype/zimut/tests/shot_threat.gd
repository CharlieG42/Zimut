extends SceneTree
## Capture de la zone de menace d'un ennemi (appui long).
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0] if OS.get_cmdline_user_args().size() > 0 else "/tmp/threat"
	DirAccess.make_dir_recursive_absolute(out)
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	root.get_node("GameSettings").tutorial_done = true
	var data: Dictionary = pm.new_game(4, "Menace")
	pm.rebuild_team(data, ["Tank", "Mage", "Heal"])
	gm.active_save = data
	gm.active_slot = 4
	gm.set_custom_team([{"classe": "Tank"}, {"classe": "Mage"}, {"classe": "Heal"}])
	gm.auto_mode = false
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await create_timer(2.5).timeout
	var grid: Node = main.get_node("GridManager")
	var n: int = 0
	for e in gm.enemies:
		if gm.is_alive(e):
			grid.show_threat(e)
			break
	await create_timer(0.4).timeout
	for row in grid.cell_nodes:
		for c in row:
			if c.threat > 0:
				n += 1
	print("cases menacées : ", n)
	root.get_viewport().get_texture().get_image().save_png(out + "/threat.png")
	pm.delete_save(4)
	quit(0 if n > 0 else 1)
