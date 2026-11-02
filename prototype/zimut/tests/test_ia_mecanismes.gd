extends SceneTree
## IA (mode Auto) : déclenche les bombes utiles, ne pose les mécanismes/piliers que près des ennemis.
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _sp(c: Dictionary, nm: String) -> Dictionary:
	for s: Dictionary in c["spells"]:
		if String(s["name"]) == nm:
			return s
	return {}
func _cell_at(gm: Node, from: Vector2i, d: int, avoid: Array) -> Vector2i:
	for y: int in range(gm.GRID_SIZE):
		for x: int in range(gm.GRID_SIZE):
			var c := Vector2i(x, y)
			if gm.is_free(c) and Combat.manhattan(from, c) == d and not avoid.has(c):
				return c
	return Vector2i(-1, -1)
func _boot() -> void:
	var gm: Node = root.get_node("GameManager")
	await process_frame
	var tm: Node = (load("res://scripts/TurnManager.gd") as GDScript).new()
	tm.game_manager = gm
	# ── Artificier ──
	gm.set_custom_team([{"classe": "Artificier"}, {"classe": "Tank"}, {"classe": "Heal"}])
	gm.init_grid()
	gm.init_entities()
	var art: Dictionary = {}
	for p: Dictionary in gm.players:
		if String(p["classe"]) == "Artificier":
			art = p
	art["spells"] = gm._build_spells("Artificier", 60)
	art["current_pa"] = 6
	art["casts"] = {}
	var foe: Dictionary = gm.enemies[0]
	for e2: Dictionary in gm.enemies:
		if e2 != foe:
			e2["current_pv"] = 0   # un seul ennemi vivant : mesures lisibles
	var far: Vector2i = _cell_at(gm, gm.pos_of(art), 3, [])
	gm._teleport_entity(foe, far)
	var bomb_sp: Dictionary = _sp(art, "Poser Bombe")
	var spot: Vector2i = _cell_at(gm, far, 1, [gm.pos_of(art)])
	check(tm._score_cast(art, bomb_sp, Combat.parse(bomb_sp), spot) > 0.0, "bombe : posée près d'un ennemi")
	var nowhere := Vector2i(-1, -1)
	for y: int in range(gm.GRID_SIZE):
		for x: int in range(gm.GRID_SIZE):
			var c := Vector2i(x, y)
			if nowhere.x < 0 and gm.is_free(c) and Combat.manhattan(c, far) > 6:
				nowhere = c
	check(tm._score_cast(art, bomb_sp, Combat.parse(bomb_sp), nowhere) == 0.0, "bombe : jamais loin des ennemis")
	# bombe posée à côté de l'ennemi : le Déclencheur devient rentable
	art["casts"] = {}
	check(gm.cast_spell(art, bomb_sp, spot), "bombe posée")
	var trig: Dictionary = _sp(art, "Déclencheur")
	var sc: float = tm._score_cast(art, trig, Combat.parse(trig), spot)
	check(sc > 0.0, "Déclencheur rentable avec un ennemi dans le rayon (%.0f)" % sc)
	var ally: Dictionary = gm.players[1] if gm.players[1] != art else gm.players[2]
	var near_ally: Vector2i = _cell_at(gm, spot, 1, [far, gm.pos_of(art)])
	gm._teleport_entity(foe, _cell_at(gm, spot, 4, [gm.pos_of(art)]))   # ennemi hors du rayon
	check(tm._score_cast(art, trig, Combat.parse(trig), spot) == 0.0, "Déclencheur inutile sans ennemi dans le rayon")
	# ── Géomancien : piliers près des ennemis seulement, jamais de muraille ──
	gm.set_custom_team([{"classe": "Géomancien"}, {"classe": "Tank"}, {"classe": "Heal"}])
	gm.init_grid()
	gm.init_entities()
	var geo: Dictionary = {}
	for p2: Dictionary in gm.players:
		if String(p2["classe"]) == "Géomancien":
			geo = p2
	geo["spells"] = gm._build_spells("Géomancien", 60)
	geo["current_pa"] = 6
	var f2: Dictionary = gm.enemies[0]
	for e3: Dictionary in gm.enemies:
		if e3 != f2:
			e3["current_pv"] = 0
	var fpos: Vector2i = _cell_at(gm, gm.pos_of(geo), 3, [])
	gm._teleport_entity(f2, fpos)
	var pil: Dictionary = _sp(geo, "Invoquer Pilier")
	var mur: Dictionary = _sp(geo, "Invoquer Muraille")
	var near_foe := Vector2i(-1, -1)
	for y3: int in range(gm.GRID_SIZE):
		for x3: int in range(gm.GRID_SIZE):
			var c3 := Vector2i(x3, y3)
			if near_foe.x < 0 and gm.is_free(c3) and Combat.manhattan(c3, fpos) == 2 and Combat.manhattan(c3, gm.pos_of(geo)) >= 3:
				near_foe = c3
	check(tm._score_cast(geo, pil, Combat.parse(pil), near_foe) > 0.0, "pilier : à portée de tir d'un ennemi")
	check(tm._score_cast(geo, mur, Combat.parse(mur), near_foe) == 0.0, "muraille : l'IA n'en pose pas")
	print("ÉCHECS : ", fails)
	quit(0 if fails == 0 else 1)
