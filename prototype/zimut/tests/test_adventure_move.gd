extends SceneTree
## Déplacement en Aventure : double appui tactile avec aperçu, brouillard → case connue
## la plus proche, croix directionnelle / clavier (un pas).
## Lancement : xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/test_adventure_move.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	var data: Dictionary = pm.new_game(4, "MoveTest")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "adventure"
	var adv: Dictionary = pm.adventure_state(data)
	gm.active_save = data
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/AdventureMap.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(0.6).timeout
	var mgr: Node = sc.manager
	var start: Vector2i = mgr.hero_pos()
	# Une case découverte à plusieurs pas
	var far: Vector2i = Vector2i(-1, -1)
	for y: int in range(mgr.zone_size().y):
		for x: int in range(mgr.zone_size().x):
			var c := Vector2i(x, y)
			if far.x < 0 and mgr.cell_discovered(c) and mgr.path_to(c).size() >= 3:
				far = c
	check(far.x >= 0, "case de destination à ≥3 pas trouvée")
	# 1er appui tactile : aperçu seulement
	sc._on_cell_tapped(far, true)
	check(mgr.hero_pos() == start, "1er appui tactile : le héros ne bouge pas")
	check(sc._board.preview.size() >= 3 and sc._pending == far, "1er appui : trajet affiché (%d pas)" % sc._board.preview.size())
	# 2e appui : marche
	sc._on_cell_tapped(far, true)
	await create_timer(3.0).timeout
	check(mgr.hero_pos() == far or not sc._walking, "2e appui : le héros marche vers la case")
	check(mgr.hero_pos() != start, "le héros a quitté la case de départ")
	# Brouillard : case cachée → on avance au plus près
	var fog: Vector2i = Vector2i(-1, -1)
	for y2: int in range(mgr.zone_size().y):
		for x2: int in range(mgr.zone_size().x):
			var c2 := Vector2i(x2, y2)
			if fog.x < 0 and not mgr.cell_discovered(c2) and AdventureTerrain.walkable(mgr.zone_id(), c2):
				fog = c2
	check(fog.x >= 0, "case dans la brume trouvée")
	var near: Vector2i = sc._nearest_reachable(fog)
	check(near.x >= 0 and mgr.cell_discovered(near), "brume : une case connue accessible est proposée")
	# Pas à pas : la croix directionnelle déplace d'une case
	await create_timer(0.3).timeout
	var here: Vector2i = mgr.hero_pos()
	var moved: bool = false
	for d: Vector2i in sc.DPAD_DIRS.values():
		if mgr.can_move_to(here + d):
			sc._step_dir(d)
			await create_timer(0.6).timeout
			moved = mgr.hero_pos() == here + d
			break
	check(moved, "croix directionnelle : un pas dans la direction choisie")
	pm.delete_save(4)
	print("\n%s — %d échec(s)" % ["OK" if fails == 0 else "KO", fails])
	quit(1 if fails > 0 else 0)
