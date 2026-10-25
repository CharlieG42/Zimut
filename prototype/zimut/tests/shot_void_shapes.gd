extends SceneTree
## Capture des plateaux à cases « hors plateau » (void) par biome. Usage : -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var dir: String = args[0] if args.size() > 0 else "/tmp/shots"
	DirAccess.make_dir_recursive_absolute(dir)
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	root.get_node("GameSettings").tutorial_done = true
	var data: Dictionary = pm.new_game(4, "Void")
	HeroUnlock.pick_initial(data, ["Tank", "Mage", "Heal"])
	pm.rebuild_team(data, ["Tank", "Mage", "Heal"])
	gm.active_save = data
	gm.active_slot = 4
	gm.set_custom_team([{"classe": "Tank"}, {"classe": "Mage"}, {"classe": "Heal"}])
	gm.auto_mode = false
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await create_timer(1.5).timeout
	var grid: Node = main.get_node("GridManager")
	var combos: Array = [["Forêt", "ring"], ["Forêt", "octagon"], ["Montagne", "ridge"], ["Désert", "dunes"], ["Forêt", "islands"]]
	for cb: Array in combos:
		var biome: String = cb[0]
		gm.fight_biome = biome
		grid.apply_biome(biome)
		var obs: Dictionary = {}
		for vc: Vector2i in gm.shape_void_cells(String(cb[1]), gm.GRID_SIZE, 0):
			obs[vc] = "void"
		gm.obstacles = obs
		# unités hors des trous
		var free: Array = []
		for y in range(gm.GRID_SIZE):
			for x in range(gm.GRID_SIZE):
				if not obs.has(Vector2i(x, y)):
					free.append(Vector2i(x, y))
		var k: int = 0
		for u: Dictionary in gm.players + gm.enemies:
			u["pos"] = free[(k * 7) % free.size()]
			k += 1
		grid.update_entity_display()
		await create_timer(0.8).timeout
		root.get_viewport().get_texture().get_image().save_png("%s/void_%s_%s.png" % [dir, biome, cb[1]])
	pm.delete_save(4)
	quit(0)
