extends SceneTree
## V49 : rendu des cases hors plateau (gouffres intérieurs, replats au bord).
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	root.get_node("GameSettings").tutorial_done = true
	var data: Dictionary = pm.new_game(4, "Pits")
	HeroUnlock.pick_initial(data, ["Tank", "Mage", "Heal"])
	pm.rebuild_team(data, ["Tank", "Mage", "Heal"])
	gm.active_save = data
	gm.active_slot = 4
	gm.set_custom_team([{"classe": "Tank"}, {"classe": "Mage"}, {"classe": "Heal"}])
	gm.auto_mode = false
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await create_timer(1.2).timeout
	var grid: Node = main.get_node("GridManager")
	# anneau (trou intérieur) + coin retiré (relié au bord)
	var obs: Dictionary = {}
	for vc: Vector2i in gm.shape_void_cells("ring", gm.GRID_SIZE, 0):
		obs[vc] = "void"
	obs[Vector2i(7, 7)] = "void"
	gm.obstacles = obs
	grid._sync_props()
	await process_frame
	var pits: Array = grid._void_layer.get_children().filter(func(c: Node) -> bool: return not c.is_queued_for_deletion())
	check(pits.size() == obs.size(), "un gouffre par case vide (%d/%d)" % [pits.size(), obs.size()])
	var ledges: int = 0
	for p in pits:
		if p.ledge:
			ledges += 1
	check(ledges == 1, "seule la case du coin est un replat (%d)" % ledges)
	var c = grid.cell_nodes[1][3]   # (3,1) juste derrière le trou central (3,2)
	check(c.pit_left and c.visible, "la case derrière le gouffre affiche sa paroi")
	check(not grid.cell_nodes[3][3].visible, "la case vide n'est plus dessinée comme une tuile")
	for b in ["Forêt", "Montagne", "Désert", "Donjon", "Brasier"]:
		check(load("res://scripts/VoidPit.gd").abyss(b).size() == 3, "couleurs de gouffre : %s" % b)
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
