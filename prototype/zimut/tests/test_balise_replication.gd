extends SceneTree
## Balises du Chasseur : une zone qui touche une balise est répliquée autour des balises ;
## une zone qui ne touche aucune balise n'est PAS répliquée ; un ennemi est touché une fois par zone.
var fails: int = 0
func ck(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_run.call_deferred()
func _sp(c: Dictionary, nm: String) -> Dictionary:
	for s: Dictionary in c["spells"]:
		if String(s["name"]) == nm:
			return s
	return {}
func _move(gm: Node, e: Dictionary, to: Vector2i) -> void:
	gm.grid[e["y"]][e["x"]] = null
	e["x"] = to.x
	e["y"] = to.y
	gm.grid[to.y][to.x] = e
func _run() -> void:
	var gm: Node = root.get_node("GameManager")
	await process_frame
	gm.set_custom_team([{"classe": "Chasseur"}])
	gm.init_grid()
	gm.init_entities()
	var ch: Dictionary = gm.players[0]
	ch["spells"] = gm._build_spells("Chasseur", 100)
	ch["current_pa"] = 40
	var cp: Vector2i = gm.pos_of(ch)
	var bal: Dictionary = _sp(ch, "Balise de chasse")
	var cells: Array = []
	for y: int in range(gm.GRID_SIZE):
		for x: int in range(gm.GRID_SIZE):
			var c := Vector2i(x, y)
			if Combat.manhattan(cp, c) >= 2 and Combat.manhattan(cp, c) <= 4 and gm.is_free(c) and cells.size() < 2:
				cells.append(c)
	for c: Vector2i in cells:
		gm.cast_spell(ch, bal, c)
	var bs: Array = gm.beacons_of(ch)
	ck(bs.size() == 2, "2 balises posées")
	# Ennemi A touché par la zone d'origine, ennemi B seulement près de la 2e balise
	var ex: Dictionary = _sp(ch, "Tir explosif")
	var p: Dictionary = Combat.parse(ex)
	var b2: Vector2i = gm.pos_of(bs[1])
	var epos := Vector2i(-1, -1)
	for d: Vector2i in [Vector2i(0, 1), Vector2i(1, 0), Vector2i(0, -1), Vector2i(-1, 0)]:
		if gm.is_free(b2 + d):
			epos = b2 + d
			break
	var en: Dictionary = gm.enemies[0]
	_move(gm, en, epos)
	# Cible : une case libre assez loin de la zone de la 2e balise pour que la zone d'origine ne touche AUCUNE balise
	var cast_cell := Vector2i(-1, -1)
	var hit_far: Array = []
	for y: int in range(gm.GRID_SIZE):
		for x: int in range(gm.GRID_SIZE):
			var c2 := Vector2i(x, y)
			var zone: Array[Vector2i] = Combat.zone_cells(c2, int(p["zone_r"]), String(p["zone_shape"]), gm.GRID_SIZE)
			var touches: bool = false
			for b: Dictionary in bs:
				if zone.has(gm.pos_of(b)):
					touches = true
			if not touches and cast_cell == Vector2i(-1, -1) and gm.validate_cast(ch, ex, c2) == "" and not zone.has(epos):
				cast_cell = c2
	ck(cast_cell != Vector2i(-1, -1), "case de lancer sans balise dans la zone trouvée")
	if cast_cell != Vector2i(-1, -1):
		var pv0: int = int(en["current_pv"])
		ck(gm.cast_spell(ch, ex, cast_cell), "Tir explosif lancé")
		ck(int(en["current_pv"]) == pv0, "zone qui ne touche aucune balise : pas de réplique (%d → %d)" % [pv0, int(en["current_pv"])])
		ch["casts"] = {}
		ch["current_pa"] = 40
		# Zone lancée sur la 1re balise : elle touche une balise → réplique autour de la 2e
		ck(gm.cast_spell(ch, ex, gm.pos_of(bs[0])), "Tir explosif lancé sur une balise")
		ck(int(en["current_pv"]) < pv0, "zone qui touche une balise : l'ennemi près de l'autre balise est touché (%d → %d)" % [pv0, int(en["current_pv"])])
	# Un ennemi couvert par plusieurs zones répliquées est touché une fois par zone
	var bsx: Array = gm.beacons_of(ch)
	if bsx.size() == 2:
		var e2: Dictionary = gm.enemies[1]
		var spot := Vector2i(-1, -1)
		for y2: int in range(1, gm.GRID_SIZE - 1):
			for x2: int in range(1, gm.GRID_SIZE - 1):
				var q := Vector2i(x2, y2)
				if spot == Vector2i(-1, -1) and gm.is_free(q) and Combat.manhattan(q, cp) > 6:
					spot = q
		_move(gm, bsx[0], spot + Vector2i(1, 0) if gm.is_free(spot + Vector2i(1, 0)) else spot + Vector2i(-1, 0))
		_move(gm, bsx[1], spot + Vector2i(0, 1) if gm.is_free(spot + Vector2i(0, 1)) else spot + Vector2i(0, -1))
		_move(gm, e2, spot)
		var far_cell: Vector2i = spot
		# les dégâts ont une part de hasard (variance, critiques) : on cumule plusieurs tirages pour ne pas dépendre d'un seul
		var two: int = 0
		for _t: int in range(12):
			e2["current_pv"] = int(e2["max_pv"])
			var pv_a: int = int(e2["current_pv"])
			gm._beacon_replicas(ch, ex, p, far_cell, 40.0)
			two += pv_a - int(e2["current_pv"])
		var keep: Dictionary = bsx[1]
		keep["current_pv"] = 0
		var one: int = 0
		for _t: int in range(12):
			e2["current_pv"] = int(e2["max_pv"])
			var pv_b: int = int(e2["current_pv"])
			gm._beacon_replicas(ch, ex, p, far_cell, 40.0)
			one += pv_b - int(e2["current_pv"])
		ck(one > 0 and two >= one * 1.6, "touché une fois par zone : 2 balises = environ 2 fois 1 balise (%d vs %d)" % [two, one])
	# Sans balise : aucune réplique
	for b3: Dictionary in gm.beacons_of(ch):
		b3["current_pv"] = 0
	ck(gm._beacon_replicas(ch, ex, p, cp, 10.0).is_empty(), "sans balise : pas de réplique")
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
