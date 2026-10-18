extends SceneTree
## Balises du Chasseur (3 max, la plus ancienne disparaît, réplication sur toutes, rappel),
## attaque du Pilier (rayon 4), Éclair nerfé.
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
func _free_near(gm: Node, from: Vector2i, n: int) -> Array:
	var out: Array = []
	for y: int in range(gm.GRID_SIZE):
		for x: int in range(gm.GRID_SIZE):
			var c := Vector2i(x, y)
			var d: int = Combat.manhattan(from, c)
			if d >= 2 and d <= 4 and gm.is_free(c) and out.size() < n:
				out.append(c)
	return out
func _boot() -> void:
	var gm: Node = root.get_node("GameManager")
	await process_frame
	var rows: String = FileAccess.get_file_as_string("res://data/sorts.txt")
	check(rows.contains("Mage,Éclair,3,0,5,29 dégâts"), "Éclair nerfé puis / 1,8 (29 dégâts)")
	gm.set_custom_team([{"classe": "Chasseur"}, {"classe": "Géomancien"}, {"classe": "Tank"}])
	gm.init_grid()
	gm.init_entities()
	var ch: Dictionary = {}
	var geo: Dictionary = {}
	for p: Dictionary in gm.players:
		if String(p["classe"]) == "Chasseur": ch = p
		if String(p["classe"]) == "Géomancien": geo = p
	ch["spells"] = gm._build_spells("Chasseur", 100)
	geo["spells"] = gm._build_spells("Géomancien", 100)
	check(not _sp(ch, "Rappel de balise").is_empty(), "Rappel de balise dans le kit")
	ch["current_pa"] = 30
	var cells: Array = _free_near(gm, gm.pos_of(ch), 4)
	check(cells.size() == 4, "4 cases libres")
	var bal: Dictionary = _sp(ch, "Balise de chasse")
	check(Combat.parse(bal)["kind"] == "summon", "Balise de chasse = invocation")
	for i in range(3):
		check(gm.cast_spell(ch, bal, cells[i]), "balise %d posée" % (i + 1))
		ch["casts"] = {}
	check(gm.beacons_of(ch).size() == 3, "3 balises")
	check(gm.validate_cast(ch, bal, cells[3]) == "", "4e balise autorisée")
	gm.cast_spell(ch, bal, cells[3])
	check(gm.beacons_of(ch).size() == 3, "toujours 3 balises")
	check(gm.entity_at(cells[0]).is_empty(), "la plus ancienne a disparu")
	# Rappel
	ch["casts"] = {}
	var rap: Dictionary = _sp(ch, "Rappel de balise")
	check(gm.validate_cast(ch, rap, gm.pos_of(ch)) != "", "rappel refusé sur soi")
	if gm.spell_range_cells(ch, rap).has(cells[3]):
		check(gm.validate_cast(ch, rap, cells[3]) == "", "rappel valide sur une balise")
		gm.cast_spell(ch, rap, cells[3])
		check(gm.beacons_of(ch).size() == 2, "balise rappelée (2 restantes)")
	else:
		check(false, "balise à portée du rappel")
	# Réplication sur toutes les autres balises
	var bs: Array = gm.beacons_of(ch)
	var b1: Vector2i = gm.pos_of(bs[0])
	var b2: Vector2i = gm.pos_of(bs[1])
	var en_a: Dictionary = gm.enemies[0]
	var en_b: Dictionary = gm.enemies[1]
	var gs: int = gm.GRID_SIZE - 1
	var far := Vector2i(gs, gs)
	if Combat.manhattan(b1, far) <= 6 or not gm.is_free(far) or not gm.is_free(far + Vector2i(-1, 0)):
		far = Vector2i(1, gs)
	gm.grid[b2.y][b2.x] = null
	bs[1]["x"] = far.x
	bs[1]["y"] = far.y
	gm.grid[far.y][far.x] = bs[1]
	var ep := far + Vector2i(0, -1)
	if not gm.is_free(ep):
		ep = far + Vector2i(1, 0) if far.x < gs else far + Vector2i(-1, 0)
	gm.grid[en_a["y"]][en_a["x"]] = null
	en_a["x"] = ep.x
	en_a["y"] = ep.y
	gm.grid[ep.y][ep.x] = en_a
	var pv0: int = int(en_a["current_pv"])
	var ex: Dictionary = _sp(ch, "Tir explosif")
	var p: Dictionary = Combat.parse(ex)
	var rep: Dictionary = gm._beacon_replicas(ch, ex, p, b1, float(p["dmg"]))
	check(p["aoe"] == "zone" and rep.size() > 0 and int(en_a["current_pv"]) < pv0, "la zone sur une balise se réplique sur l'autre")
	# Pilier : attaque à 4 cases
	geo["current_pa"] = 20
	var gc: Array = _free_near(gm, gm.pos_of(geo), 1)
	gm.cast_spell(geo, _sp(geo, "Invoquer Pilier"), gc[0])
	var pil: Dictionary = gm.entity_at(gc[0])
	check(bool(pil.get("tower", false)), "pilier = tour")
	var foe: Dictionary = gm.enemies[2]
	var near: Vector2i = Vector2i(-1, -1)
	for d: Vector2i in [Vector2i(3, 0), Vector2i(-3, 0), Vector2i(0, 3), Vector2i(0, -3)]:
		if near.x < 0 and gm.is_free(gc[0] + d) and gc[0].x + d.x >= 0 and gc[0].y + d.y >= 0 and gc[0].x + d.x < gm.GRID_SIZE and gc[0].y + d.y < gm.GRID_SIZE:
			near = gc[0] + d
	gm.grid[foe["y"]][foe["x"]] = null
	foe["x"] = near.x
	foe["y"] = near.y
	gm.grid[near.y][near.x] = foe
	var hp0: int = 0
	for e0: Dictionary in gm.enemies:
		hp0 += int(e0["current_pv"])
	gm._tower_attacks(geo)
	var hp1: int = 0
	for e1: Dictionary in gm.enemies:
		hp1 += int(e1["current_pv"])
	check(hp1 < hp0, "le pilier attaque un ennemi à portée (4 cases)")
	quit(1 if fails > 0 else 0)
