extends SceneTree
## Test : arbre du Sylvain (immobile, bloque la vue, relaie les soins aux alliés autour).
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
	var data: Dictionary = pm.new_game(3, "Tree")
	pm.rebuild_team(data, ["Tank", "Mage", "Sylvain"])
	for c in ["Tank", "Mage", "Sylvain"]:
		pm.roster_entry(data, c)["level"] = 20
	gm.active_save = data
	gm.active_slot = -1
	gm.set_custom_team([{"classe": "Tank"}, {"classe": "Mage"}, {"classe": "Sylvain"}])
	gm.reset_game()
	var syl: Dictionary = {}
	for p: Dictionary in gm.players:
		if p["classe"] == "Sylvain":
			syl = p
	var names: Array = []
	for sp in syl["spells"]:
		names.append(sp["name"])
	check(names.has("Invoquer Arbre"), "le Sylvain niv. 20 possède « Invoquer Arbre »")
	# Poser l'arbre sur une case libre à portée
	var spos: Vector2i = gm.pos_of(syl)
	var cell := Vector2i(-1, -1)
	for dx in range(-2, 3):
		for dy in range(-2, 3):
			var c := Vector2i(spos.x + dx, spos.y + dy)
			if cell.x < 0 and gm.is_free(c) and absi(dx) + absi(dy) == 2:
				cell = c
	var spell: Dictionary = {}
	for sp in syl["spells"]:
		if sp["name"] == "Invoquer Arbre":
			spell = sp
	var p: Dictionary = Combat.parse(spell)
	var msg: String = gm._resolve_summon(syl, spell, p, cell)
	var trees: Array = gm.trees_of(syl)
	check(trees.size() == 1, "un arbre est invoqué")
	check(not gm.turn_order.has(trees[0]), "l'arbre ne joue pas (pas dans l'ordre des tours)")
	check(int(trees[0]["max_pm"]) == 0, "l'arbre est immobile (0 PM)")
	check(gm.los_blockers().has(cell), "l'arbre bloque la ligne de vue")
	# Un second arbre remplace le premier
	var cell2 := Vector2i(-1, -1)
	for dx in range(-3, 4):
		for dy in range(-3, 4):
			var c2 := Vector2i(spos.x + dx, spos.y + dy)
			if cell2.x < 0 and gm.is_free(c2) and c2 != cell:
				cell2 = c2
	gm._resolve_summon(syl, spell, p, cell2)
	check(gm.trees_of(syl).size() == 1 and gm.pos_of(gm.trees_of(syl)[0]) == cell2, "1 seul arbre par Sylvain (le précédent se fane)")
	# Relais : placer un allié contre l'arbre, soigner un autre allié lointain
	var tree: Dictionary = gm.trees_of(syl)[0]
	var tp: Vector2i = gm.pos_of(tree)
	var tank: Dictionary = {}
	var mage: Dictionary = {}
	for pl: Dictionary in gm.players:
		if pl["classe"] == "Tank":
			tank = pl
		if pl["classe"] == "Mage":
			mage = pl
	# déplace le Mage à côté de l'arbre
	var spot := Vector2i(-1, -1)
	for dx in range(-1, 2):
		for dy in range(-1, 2):
			var c3 := Vector2i(tp.x + dx, tp.y + dy)
			if spot.x < 0 and (dx != 0 or dy != 0) and gm.is_free(c3):
				spot = c3
	var old: Vector2i = gm.pos_of(mage)
	gm.grid[old.y][old.x] = null
	mage["x"] = spot.x
	mage["y"] = spot.y
	gm.grid[spot.y][spot.x] = mage
	mage["current_pv"] = 10
	tank["current_pv"] = 10
	var heal: Dictionary = {}
	for sp in syl["spells"]:
		if sp["name"] == "Sève vitale":
			heal = sp
	var hp: Dictionary = Combat.parse(heal)
	var before: int = int(mage["current_pv"])
	gm._resolve_heal(syl, heal, hp, gm.pos_of(tank))
	check(int(tank["current_pv"]) > 10, "la cible du soin est soignée")
	check(int(mage["current_pv"]) > before, "l'allié contre l'arbre reçoit aussi le soin (relais)")
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
