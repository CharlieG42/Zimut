extends SceneTree
## V110 : couplage permanent, électrocution au début du tour dans une barrière électrique
## (tous les personnages), aperçu de la zone d'impact du Déclencheur sur une bombe,
## rayon d'explosion des bombes porté à 3 cases.
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
func _clear(gm: Node, keep: Array) -> void:
	for y: int in range(gm.GRID_SIZE):
		for x: int in range(gm.GRID_SIZE):
			gm.obstacles.erase(Vector2i(x, y))
	for arr: Array in [gm.players, gm.enemies, gm.summons]:
		for e: Dictionary in arr.duplicate():
			if not keep.has(e):
				gm.grid[int(e["y"])][int(e["x"])] = null
				arr.erase(e)
	for e: Dictionary in keep:
		gm.grid[int(e["y"])][int(e["x"])] = null
func _put(gm: Node, e: Dictionary, c: Vector2i) -> void:
	gm.grid[int(e["y"])][int(e["x"])] = null
	e["x"] = c.x
	e["y"] = c.y
	gm.grid[c.y][c.x] = e
func _boot() -> void:
	var gm: Node = root.get_node("GameManager")
	await process_frame
	gm.set_custom_team([{"classe": "Artificier"}, {"classe": "Géomancien"}, {"classe": "Mage"}])
	gm.init_grid()
	gm.init_entities()
	var art: Dictionary = {}
	var geo: Dictionary = {}
	for p: Dictionary in gm.players:
		if String(p["classe"]) == "Artificier":
			art = p
		elif String(p["classe"]) == "Géomancien":
			geo = p
	var foe: Dictionary = gm.enemies[0]
	_clear(gm, [art, geo, foe])
	_put(gm, art, Vector2i(4, 2))
	_put(gm, geo, Vector2i(0, 9))
	_put(gm, foe, Vector2i(8, 8))
	art["spells"] = gm._build_spells("Artificier", 100)
	art["level"] = 100
	art["current_pa"] = 60
	art["max_pv"] = 5000
	art["current_pv"] = 5000
	geo["max_pv"] = 5000
	geo["current_pv"] = 5000
	foe["max_pv"] = 5000
	foe["current_pv"] = 5000
	gm.active_entity = art
	art["is_active"] = true
	gm.current_turn = 0

	# Deux mécanismes alignés puis couplés : une barrière se tend entre eux
	var bomb_sp: Dictionary = _sp(art, "Poser Bombe")
	var link: Dictionary = _sp(art, "Couplage")
	var dec: Dictionary = _sp(art, "Déclencheur")
	check(gm.cast_spell(art, bomb_sp, Vector2i(3, 4)), "mécanisme A posé")
	art["casts"] = {}
	check(gm.cast_spell(art, bomb_sp, Vector2i(6, 4)), "mécanisme C posé (aligné)")
	art["casts"] = {}
	check(gm.cast_spell(art, link, Vector2i(3, 4)), "A couplé")
	art["casts"] = {}
	check(gm.cast_spell(art, link, Vector2i(6, 4)), "C couplé")
	art["casts"] = {}
	var bars: Array = gm.barriers()
	check(bars.size() == 1 and (bars[0]["cells"] as Array).size() == 2, "barrière de 2 cases entre A et C")
	var mech_a: Dictionary = gm.entity_at(Vector2i(3, 4))

	# Couplage permanent : le drapeau ne retombe pas à la fin du tour
	check(int(mech_a.get("link_turns", 0)) == gm.LINK_TURNS and gm.LINK_TURNS > 100, "couplage permanent (link_turns = %d)" % int(mech_a.get("link_turns", 0)))
	gm.end_current_turn()
	check(int(mech_a.get("link_turns", 0)) == gm.LINK_TURNS, "fin de tour : le couplage ne s'éteint pas")
	check(gm.barriers().size() == 1, "fin de tour : la barrière persiste")
	art["current_pa"] = 60
	art["casts"] = {}

	# Électrocution au début du tour dans la barrière — ennemi (plein pot)
	_put(gm, foe, Vector2i(4, 4))
	foe["current_pv"] = 5000
	gm._begin_turn(foe)
	var foe_loss: int = 5000 - int(foe["current_pv"])
	check(foe_loss > 0, "ennemi commençant son tour dans la barrière : électrocuté (%d)" % foe_loss)
	# ... allié (moitié) ...
	_put(gm, geo, Vector2i(5, 4))
	geo["defense"] = foe.get("defense", 0)
	geo["res_mag"] = foe.get("res_mag", 0)
	geo["current_pv"] = 5000
	gm._barrier_shock_at_turn_start(geo)
	var ally_loss: int = 5000 - int(geo["current_pv"])
	check(ally_loss > 0 and ally_loss < foe_loss, "allié commençant son tour dans la barrière : électrocuté moitié (%d < %d)" % [ally_loss, foe_loss])
	# ... et personnage hors barrière : rien
	art["current_pv"] = 5000
	gm._barrier_shock_at_turn_start(art)
	check(int(art["current_pv"]) == 5000, "hors barrière au début du tour : aucun dégât")

	# Déclencheur sur une bombe : la zone d'impact est prévisualisée (rayon 3)
	check(gm.BOMB_RADIUS == 3, "rayon d'explosion des bombes : 3 cases")
	var aoe: Array[Vector2i] = gm.get_aoe_cells(art, dec, Vector2i(3, 4))
	check(aoe.size() == 25, "aperçu Déclencheur/bombe : losange de rayon 3 (%d cases)" % aoe.size())
	check(aoe.has(Vector2i(6, 4)) and aoe.has(Vector2i(3, 7)) and not aoe.has(Vector2i(7, 4)), "l'aperçu couvre 3 cases autour, pas 4")
	var aoe1: Array[Vector2i] = gm.get_aoe_cells(art, dec, Vector2i(9, 9))
	check(aoe1.size() == 1, "hors bombe, le Déclencheur ne prévisualise que la case ciblée")

	# L'explosion touche bien à 3 cases (et pas à 4)
	_put(gm, foe, Vector2i(3, 7))
	_put(gm, geo, Vector2i(3, 8))
	foe["current_pv"] = 5000
	geo["current_pv"] = 5000
	gm.active_entity = art
	art["current_pa"] = 60
	art["casts"] = {}
	check(gm.cast_spell(art, dec, Vector2i(3, 4)), "Déclencheur sur la bombe A")
	check(int(foe["current_pv"]) < 5000, "ennemi à 3 cases : touché par l'explosion")
	check(int(geo["current_pv"]) == 5000, "allié à 4 cases : hors de l'explosion")
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
