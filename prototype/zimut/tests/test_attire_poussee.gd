extends SceneTree
## V108 — Héros Chasseur : +1 de portée sur ses sorts ; Chasseur et Ingénieur : poussées et attirance (« attire de N cases »).
## Lancement : godot --headless --path . -s tests/test_attire_poussee.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _spell(caster: Dictionary, nm: String) -> Dictionary:
	for s: Dictionary in caster["spells"]:
		if String(s["name"]) == nm:
			return s
	return {}
func _boot() -> void:
	var gm: Node = root.get_node("GameManager")
	await process_frame
	# Archer Sylvestre
	var arc: Dictionary = Combat.summon_spells("Archer Sylvestre")[0]
	check(int(arc["range"]) == 5, "Archer Sylvestre inchangé (portée 5)")
	# Héros Chasseur : +1 PO sur ses sorts à distance
	var ch_max: int = 0
	for line: String in FileAccess.get_file_as_string("res://data/sorts.txt").split("\n"):
		var c: PackedStringArray = line.split(",")
		if c.size() > 4 and c[0] == "Chasseur":
			ch_max = maxi(ch_max, int(c[4]))
			if c[1] == "Tir précis":
				check(int(c[4]) == 6, "Tir précis : portée 6 (5 + 1)")
			if c[1] == "Flèche du destin":
				check(int(c[4]) == 9, "Flèche du destin : portée 9 (8 + 1)")
	check(ch_max == 9, "portée max du Chasseur : 9")
	# données
	var sorts: String = FileAccess.get_file_as_string("res://data/sorts.txt")
	var prog: String = FileAccess.get_file_as_string("res://data/progression_sorts.txt")
	for nm: String in ["Flèche-grappin", "Tir de dispersion", "Grappin mécanique", "Onde de choc"]:
		check(sorts.contains("," + nm + ","), "sort présent : " + nm)
		check(prog.contains(nm), "sort dans la progression : " + nm)
		check(SpellIcons.texture_for(nm) != null, "icône chargeable : " + nm)
	# parse
	var sp := {"classe": "Chasseur", "cost_pa": 3, "cost_pm": 0, "range": 5, "effect": "40 dégâts + attire de 2 cases", "level_required": 32, "spell_type": "Attaque", "name": "Flèche-grappin", "phys_damage": 40}
	check(int(Combat.parse(sp)["pull"]) == 2, "Flèche-grappin attire de 2 cases")
	check(int(Combat.parse({"name": "Grappin mécanique", "classe": "Artificier", "cost_pa": 2, "cost_pm": 0, "range": 6, "effect": "30 dégâts + attire de 3 cases", "level_required": 36, "spell_type": "Attaque", "phys_damage": 30})["pull"]) == 3, "Grappin mécanique attire de 3 cases")
	check(Combat.PUSH.has("Fusil à pompe") and Combat.PUSH.has("Roquette") and Combat.PUSH.has("Onde de choc") and Combat.PUSH.has("Tir de dispersion"), "poussées Ingénieur / Chasseur déclarées")
	check(Combat.describe(sp).contains("Attire de 2"), "infobulle : « Attire de 2 case(s) »")
	# déplacement réel
	gm.set_custom_team([{"classe": "Chasseur"}, {"classe": "Tank"}, {"classe": "Mage"}])
	gm.init_grid()
	gm.init_entities()
	var h: Dictionary = gm.players[0]
	var foe: Dictionary = gm.enemies[0]
	var o: Vector2i = Vector2i(3, 5)
	for e: Dictionary in gm.players + gm.enemies:
		if gm.grid[e["y"]][e["x"]] == e:
			gm.grid[e["y"]][e["x"]] = null
	gm.obstacles.clear()
	h["x"] = o.x; h["y"] = o.y
	gm.grid[o.y][o.x] = h
	foe["x"] = o.x + 5; foe["y"] = o.y
	gm.grid[foe["y"]][foe["x"]] = foe
	foe["current_pv"] = 9999
	gm._push(h, foe, 2, true)
	check(gm.pos_of(foe) == o + Vector2i(3, 0), "attiré de 2 cases vers le lanceur (%s)" % str(gm.pos_of(foe)))
	var pv: int = int(foe["current_pv"])
	gm._push(h, foe, 5, true)
	check(gm.pos_of(foe) == o + Vector2i(1, 0), "s'arrête au contact du lanceur (%s)" % str(gm.pos_of(foe)))
	check(int(foe["current_pv"]) == pv, "aucun dégât de collision pour une attirance")
	gm._push(h, foe, 1)
	check(gm.pos_of(foe) == o + Vector2i(2, 0), "la poussée existante fonctionne toujours")
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
