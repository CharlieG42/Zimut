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
## Cherche (a, f, n) libres : f à distance da de a, n à distance 1 (ou 2) de f et au moins dn de a.
func _triple(gm: Node, da: int, dfn: int, dn: int, dmax: int = 99) -> Array:
	for ya: int in range(gm.GRID_SIZE):
		for xa: int in range(gm.GRID_SIZE):
			var a := Vector2i(xa, ya)
			if not gm.is_free(a):
				continue
			for yf: int in range(gm.GRID_SIZE):
				for xf: int in range(gm.GRID_SIZE):
					var f := Vector2i(xf, yf)
					if f == a or not gm.is_free(f) or Combat.manhattan(a, f) != da:
						continue
					for yn: int in range(gm.GRID_SIZE):
						for xn: int in range(gm.GRID_SIZE):
							var n := Vector2i(xn, yn)
							if n != a and n != f and gm.is_free(n) and Combat.manhattan(n, f) == dfn and Combat.manhattan(n, a) >= dn and Combat.manhattan(n, a) <= dmax:
								return [a, f, n]
	return []


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
	# bombe : posée à 4 de l'Artificier (portée 4, hors de son propre rayon 3) et à 1 de l'ennemi
	var tri: Array = _triple(gm, 5, 1, 4, 4)
	gm._teleport_entity(art, tri[0])
	var far: Vector2i = tri[1]
	gm._teleport_entity(foe, far)
	# alliés éloignés : le test ne dépend pas du placement aléatoire du début de combat
	for al: Dictionary in gm.players:
		if al != art:
			var away: Vector2i = Vector2i(-1, -1)
			for y0: int in range(gm.GRID_SIZE):
				for x0: int in range(gm.GRID_SIZE):
					var c0 := Vector2i(x0, y0)
					if away.x < 0 and gm.is_free(c0) and Combat.manhattan(c0, gm.pos_of(art)) >= 9 and Combat.manhattan(c0, tri[1]) >= 6:
						away = c0
			if away.x >= 0:
				gm._teleport_entity(al, away)

	var bomb_sp: Dictionary = _sp(art, "Poser Bombe")
	var spot: Vector2i = tri[2]
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
	if sc <= 0.0:
		print("DIAG kind=", gm.trigger_kind(art, spot), " bomb=", gm.entity_at(spot).get("mech", "?"), " foes=", tm._foes_near(art, spot, 2), " friends=", tm._friends_near(art, spot, 2), " foe=", gm.pos_of(foe), " spot=", spot, " art=", gm.pos_of(art), " pv=", foe["current_pv"])
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
	var tri2: Array = _triple(gm, 3, 2, 3)
	gm._teleport_entity(geo, tri2[0])
	var fpos: Vector2i = tri2[1]
	gm._teleport_entity(f2, fpos)
	for al2: Dictionary in gm.players:
		if al2 != geo:
			gm._teleport_entity(al2, _cell_at(gm, tri2[0], 8, [tri2[1], tri2[2]]))
	var pil: Dictionary = _sp(geo, "Invoquer Pilier")
	var mur: Dictionary = _sp(geo, "Invoquer Muraille")
	var near_foe: Vector2i = tri2[2]
	check(tm._score_cast(geo, pil, Combat.parse(pil), near_foe) > 0.0, "pilier : à portée de tir d'un ennemi")
	check(tm._score_cast(geo, mur, Combat.parse(mur), near_foe) == 0.0, "muraille : l'IA n'en pose pas")
	print("ÉCHECS : ", fails)
	quit(0 if fails == 0 else 1)
