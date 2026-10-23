extends SceneTree
## V43 : formes de plateau — chaque forme laisse un plateau connexe et assez grand.
var failures := 0
func check(c: bool, l: String) -> void:
	if c: print("  ok  ", l)
	else:
		failures += 1
		print("  KO  ", l)
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var gm: Node = root.get_node("/root/GameManager")
	var n: int = gm.GRID_SIZE
	for shape: String in ["octagon", "round", "ravine", "cross", "wings"]:
		var v: Array = gm.shape_void_cells(shape, n)
		gm.obstacles = {}
		for c in v: gm.obstacles[c] = "void"
		var rows := ""
		for y in range(n):
			for x in range(n):
				rows += "#" if gm.obstacles.has(Vector2i(x, y)) else "."
			rows += "\n"
		print(shape, " vides=", v.size()); print(rows)
		check(gm._all_free_connected(), shape + " : plateau connexe")
		check(n * n - v.size() >= 36, shape + " : au moins 36 cases jouables")
	var seen := {}
	for i in range(60):
		gm.fight_biome = "Forêt"
		gm.init_grid(); gm.init_entities()
		seen[gm.board_shape] = true
		var ok := true
		for e in gm.enemies + gm.players:
			if String(gm.obstacles.get(gm.pos_of(e), "")) != "": ok = false
		if not ok:
			check(false, "unité sur une case hors plateau (%s)" % gm.board_shape); break
	check(seen.size() >= 3, "mélange de formes (%s)" % str(seen.keys()))
	print("OK" if failures == 0 else "ÉCHEC")
	quit(failures)
