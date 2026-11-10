extends SceneTree
## V135 — Quitter la carte 2D (« Mes Parties ») pendant une marche ou des chargements de tuiles ; compteur en 3D.
var _fails: int = 0
func ck(c: bool, m: String) -> void:
	if c:
		print("  ok  ", m)
	else:
		print("  ÉCHEC  ", m)
		_fails += 1
func _init() -> void:
	_run.call_deferred()
func _find(n: Node, nm: String) -> Node:
	if n.name == nm:
		return n
	for ch in n.get_children():
		var r: Node = _find(ch, nm)
		if r != null:
			return r
	return null
func _open_map(pm: Node, gm: Node, data: Dictionary) -> Node:
	gm.active_save = data
	gm.active_slot = 4
	pm.write_save(4, data)
	change_scene_to_file("res://scenes/AdventureMap.tscn")
	await create_timer(1.0).timeout
	return current_scene
func _run() -> void:
	var pm: Node = root.get_node("/root/ProgressionManager")
	var gm: Node = root.get_node("/root/GameManager")
	var gs: Node = root.get_node("/root/GameSettings")
	var AT: GDScript = load("res://scripts/AdventureTerrain.gd")
	var before: String = gs.sylvestre_board
	var before_perf: bool = gs.show_perf
	gs.set_sylvestre_board("diorama")
	var data: Dictionary = pm.new_game(4, "QuitterCarte")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "adventure"
	data["adventure_view"] = "map"
	var adv: Dictionary = pm.adventure_state(data)
	pm.adventure_unlock_zone(adv, "foret_sylve")
	pm.adventure_enter_zone(adv, "foret_sylve")
	# 1) quitter PENDANT une marche
	var sc: Node = await _open_map(pm, gm, data)
	ck(sc != null and sc.name == "AdventureMap", "carte ouverte")
	var h: Vector2i = sc.manager.hero_pos()
	var path: Array[Vector2i] = []
	var c: Vector2i = h
	for i: int in range(5):
		for d: Vector2i in [Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(0, -1)]:
			if AT.walkable("foret_sylve", c + d) and not path.has(c + d) and c + d != h:
				c += d
				path.append(c)
				break
	sc._walk(path)
	await create_timer(0.25).timeout
	ck(sc._walking, "le héros marche")
	sc._back_to_save()
	ck(sc._leaving and not sc._walking and not sc._walk_tw.is_valid(), "départ demandé : marche arrêtée")
	sc._back_to_save()                       # un second appui est ignoré
	await create_timer(1.2).timeout
	ck(current_scene != null and current_scene.name == "SaveSlots", "arrivée sur « Mes Parties » (quitté en marchant)")
	# 2) quitter avec des tuiles en cours de chargement en arrière-plan
	sc = await _open_map(pm, gm, pm.load_save(4))
	for q: Vector2i in [Vector2i(20, 20), Vector2i(120, 30), Vector2i(30, 120), Vector2i(120, 120)]:
		sc._focus_cell(q, false)
		await process_frame
		await process_frame
	var asked: int = 0
	for ch: Dictionary in sc._dio_chunks:
		asked += 1 if bool(ch["req"]) else 0
	if asked == 0:                           # sans écran (CI), la vue est vide : on demande deux tuiles à la main
		for ch0: Dictionary in sc._dio_chunks:
			if asked < 2 and ((ch0["sprites"] as Array).is_empty() or (ch0["sprites"][0] as Sprite2D).texture == null) and not ResourceLoader.has_cached(String(ch0["path"])):
				ResourceLoader.load_threaded_request(String(ch0["path"]), "Texture2D")
				ch0["req"] = true
				asked += 1
	ck(asked > 0, "tuiles demandées en arrière-plan (%d)" % asked)
	sc._back_to_save()
	var waited: int = 0
	while (current_scene == null or current_scene == sc) and waited < 400:
		await process_frame
		waited += 1
	var left: int = 0
	if is_instance_valid(sc):
		for ch2: Dictionary in sc._dio_chunks:
			left += 1 if bool(ch2["req"]) else 0
	ck(current_scene != null and current_scene.name == "SaveSlots" and left == 0, "arrivée sur « Mes Parties » une fois les chargements terminés")
	# 3) compteur de fluidité dans les vues 3D
	var PC: GDScript = load("res://scripts/PerfCounter.gd")
	var frames: Array[float] = [0.016, 0.016, 0.05, 0.016]
	var txt: String = PC.summary(frames, 7.0, 12.0)
	ck(txt.begins_with("41 i/s") and txt.contains("pire 50 ms") and txt.contains("saccades 1") and txt.contains("scène 7 · rendu 12") and txt.contains("triangles"), "texte du compteur")
	for on: bool in [true, false]:
		gs.show_perf = on
		var d3: Dictionary = pm.load_save(4)
		d3["adventure_view"] = "open3d"
		gm.active_save = d3
		gm.active_slot = 4
		var w3: Node = (load("res://scenes/AdventureOpen3D.tscn") as PackedScene).instantiate()
		root.add_child(w3)
		await create_timer(0.8).timeout
		ck((_find(w3, "PerfCounter") != null) == on, "monde 3D : compteur %s" % ("affiché quand le réglage est actif" if on else "absent sinon"))
		w3.queue_free()
		await process_frame
	gs.show_perf = before_perf
	gs.set_sylvestre_board(before)
	pm.delete_save(4)
	print("OK : tous les tests passent." if _fails == 0 else "ÉCHEC : %d" % _fails)
	quit(1 if _fails > 0 else 0)
