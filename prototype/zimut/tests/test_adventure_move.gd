extends SceneTree
## Déplacement en Aventure : appui unique (V22), brouillard → case connue
## la plus proche, joystick / clavier (un pas).
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
	# V22 : un seul appui suffit, le trajet s'affiche pendant la marche
	sc._on_cell_tapped(far, true)
	await process_frame
	check(sc._walking and sc._board.preview.size() >= 1, "1 appui : le héros part aussitôt, trajet affiché")
	await create_timer(3.0).timeout
	check(mgr.hero_pos() == far or not sc._walking, "le héros marche vers la case")
	check(mgr.hero_pos() != start, "le héros a quitté la case de départ")
	if sc._modal_root != null:
		sc._close_modal()
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
	# Joystick : le vecteur écran donne la bonne direction de grille
	check(ZJoystick.grid_dirs(Vector2(1, 1), false) == [Vector2i(1, 0)], "joystick ↘ -> (1,0)")
	check(ZJoystick.grid_dirs(Vector2(-1, -1), false) == [Vector2i(-1, 0)], "joystick ↖ -> (-1,0)")
	check(ZJoystick.grid_dirs(Vector2(1, 0), false).size() == 2, "joystick droite : deux axes en zigzag")
	var waited: float = 0.0
	while sc._walking and waited < 6.0:
		await create_timer(0.2).timeout
		waited += 0.2
	if sc._modal_root != null:
		sc._close_modal()
	await create_timer(0.3).timeout
	var here: Vector2i = mgr.hero_pos()
	var moved: bool = false
	for v: Vector2 in [Vector2(1, 1), Vector2(-1, 1), Vector2(1, -1), Vector2(-1, -1)]:
		var d: Vector2i = ZJoystick.grid_dirs(v, false)[0]
		if mgr.can_move_to(here + d):
			sc._joy_step(v)
			await create_timer(0.6).timeout
			moved = mgr.hero_pos() == here + d
			break
	check(moved, "joystick : un pas dans la direction poussée")
	# V22 : redirection pendant la marche
	if sc._modal_root != null:
		sc._close_modal()
	var cells: Array[Vector2i] = []
	for y3: int in range(mgr.zone_size().y):
		for x3: int in range(mgr.zone_size().x):
			var c3 := Vector2i(x3, y3)
			if mgr.cell_discovered(c3) and mgr.poi_at(c3).is_empty() and mgr.gate_at(c3).is_empty() and mgr.path_to(c3).size() >= 2:
				cells.append(c3)
	if cells.size() >= 2:
		var a: Vector2i = cells[0]
		var b: Vector2i = cells[cells.size() - 1]
		sc._on_cell_tapped(a)
		sc._redirect = b
		var w2: float = 0.0
		while (sc._walking or mgr.hero_pos() != b) and w2 < 8.0:
			await create_timer(0.2).timeout
			w2 += 0.2
			if sc._modal_root != null:
				break
		check(mgr.hero_pos() == b or sc._modal_root != null, "redirection : le héros rejoint la nouvelle destination")
	if sc._modal_root != null:
		sc._close_modal()
	# V22 : toucher un groupe éloigné → le héros va au contact et le combat est proposé
	# (une fenêtre d'événement aléatoire peut s'être ouverte en route : on referme tout avant le test)
	for _i in range(6):
		await create_timer(0.3).timeout
		if sc._modal_root != null:
			sc._close_modal()
		elif not sc._walking:
			break
	for y4: int in range(mgr.zone_size().y):
		for x4: int in range(mgr.zone_size().x):
			var k4: String = "%s,%d,%d" % [mgr.zone_id(), x4, y4]
			if not (mgr.state["discovered"] as Array).has(k4):
				mgr.state["discovered"].append(k4)
	sc._refresh_world()
	var target: Dictionary = {}
	var best_len: int = 9999
	for g: Dictionary in mgr.mobs():
		var gp: Vector2i = AdventureMobs.pos_of(g)
		var gpath: Array[Vector2i] = mgr.path_to(gp)
		var plen: int = gpath.size()
		# la route ne doit croiser ni lieu ni porte (la marche s'y arrêterait pour l'événement)
		var clear: bool = true
		for pc: Vector2i in gpath:
			if pc != mgr.hero_pos() and pc != gp and (not mgr.poi_at(pc).is_empty() or not mgr.gate_at(pc).is_empty()):
				clear = false
		# le groupe le plus proche : moins de risque qu'un autre groupe croise la route
		if clear and mgr.cell_discovered(gp) and plen >= 2 and plen < best_len:
			best_len = plen
			target = g
	if not target.is_empty():
		sc._on_cell_tapped(AdventureMobs.pos_of(target))
		var w3: float = 0.0
		while sc._walking and w3 < 25.0:
			await create_timer(0.2).timeout
			w3 += 0.2
		await create_timer(0.3).timeout
		var hp: Vector2i = mgr.hero_pos()
		var gp2: Vector2i = AdventureMobs.pos_of(target)
		check(absi(hp.x - gp2.x) + absi(hp.y - gp2.y) == 1 and sc._modal_root != null, "toucher un groupe : marche au contact puis fenêtre de combat")
	else:
		print("  (aucun groupe accessible dans la zone découverte : test du contact ignoré)")
	pm.delete_save(4)
	print("\n%s — %d échec(s)" % ["OK" if fails == 0 else "KO", fails])
	quit(1 if fails > 0 else 0)
