extends SceneTree
## test_summons.gd — Tests des invocations V4.1 : buisson soigneur, champignon
## empoisonneur, racines bloque-ldv, ronce agressive, balise du Chasseur,
## tir de recul, Mage sans sorts de soins.
## Lancement : godot --headless -s tests/test_summons.gd --path .

var failures: int = 0

func _init() -> void:
	# Les autoloads (GameManager, ProgressionManager) n'existent qu'après _init : on diffère.
	_run.call_deferred()

func _run() -> void:
	_test_summon_kits()
	_test_push_parse()
	_test_mage_no_heals()
	_test_beacon_limit()
	print("")
	if failures > 0:
		print("ÉCHEC : %d test(s) en erreur." % failures)
		quit(1)
	else:
		print("OK : tous les tests passent.")
		quit(0)

func _check(cond: bool, label: String) -> void:
	if cond:
		print("  ok  %s" % label)
	else:
		failures += 1
		print("  KO  %s" % label)

func _test_summon_kits() -> void:
	print("kits d'invocation :")
	var bush: Array = Combat.summon_spells("Archer Sylvestre")
	_check(bush.size() == 1, "l'Archer Sylvestre a un sort")
	var bp: Dictionary = Combat.parse(bush[0])
	_check(String(bp["kind"]) == "attack" and int(bp["range"] if bp.has("range") else 5) >= 4, "l'Archer Sylvestre tire à distance")
	_check(bp["debuffs"].size() > 0, "l'Archer Sylvestre ralentit")
	var shroom: Array = Combat.summon_spells("Ent de Combat")
	var sp: Dictionary = Combat.parse(shroom[0])
	_check(String(sp["kind"]) == "attack", "l'Ent de Combat attaque")
	_check(int(sp["stun_chance"]) > 0, "l'Ent de Combat peut étourdir")
	var roots: Dictionary = Combat.SUMMONS["Racines"]
	_check(bool(roots["static"]) and bool(roots["blocks_los"]), "les Racines sont statiques et bloquent la ldv")
	_check(not bool(roots.get("relay", false)), "les Racines ne relaient pas les soins")
	var bramble: Array = Combat.summon_spells("Ronce agressive")
	_check(String(Combat.parse(bramble[0])["kind"]) == "attack", "la Ronce agressive attaque")
	var beacon: Dictionary = Combat.SUMMONS["Balise"]
	_check(bool(beacon["static"]) and bool(beacon["beacon"]), "la Balise est statique et réplique les zones")

func _test_push_parse() -> void:
	print("tir de recul :")
	var spell := {
		"name": "Tir de recul", "classe": "Chasseur", "cost_pa": 3, "cost_pm": 0, "range": 5,
		"effect": "80 dégâts + repousse de 2 cases", "level_required": 12, "spell_type": "Attaque",
		"Degats_physiques": 80, "Degats_magiques": 0, "Soins": 0,
	}
	var p: Dictionary = Combat.parse(spell)
	_check(int(p["push"]) == 2, "Tir de recul repousse de 2 cases")

func _test_mage_no_heals() -> void:
	print("Mage dégâts purs :")
	var lines: PackedStringArray = FileAccess.get_file_as_string("res://data/sorts.txt").split("\n")
	var heal_names: Array[String] = ["Soin magique", "Soin supérieur", "Soin de groupe",
		"Soin magique supérieur", "Soin de l'âme", "Soin ultime", "Soin de la vie"]
	var found: int = 0
	for ln: String in lines:
		var cols: PackedStringArray = ln.strip_edges().split(",")
		if cols.size() > 1 and cols[0] == "Mage" and heal_names.has(cols[1]):
			found += 1
	_check(found == 0, "le Mage n'a plus de sorts de soins dédiés")

func _test_beacon_limit() -> void:
	print("balise du Chasseur :")
	var spell := {
		"name": "Balise de chasse", "classe": "Chasseur", "cost_pa": 2, "cost_pm": 0, "range": 4,
		"effect": "Plante une balise (3 max) : les dégâts de zone du Chasseur qui la touchent se répliquent autour d'elle",
		"level_required": 18, "spell_type": "Invocation",
		"Degats_physiques": 0, "Degats_magiques": 0, "Soins": 0,
	}
	var p: Dictionary = Combat.parse(spell)
	_check(String(p["kind"]) == "summon" and String(p["summon"]) == "Balise", "la Balise se parse en invocation")
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "B")
	pm.rebuild_team(data, ["Tank", "Chasseur", "Sylvain"])
	gm.active_save = data
	gm.active_slot = -1
	gm.set_custom_team([{"classe": "Tank"}, {"classe": "Chasseur"}, {"classe": "Sylvain"}])
	gm.reset_game()
	var hunter: Dictionary = {}
	for pl: Dictionary in gm.players:
		if pl["classe"] == "Chasseur":
			hunter = pl
	var hpos: Vector2i = gm.pos_of(hunter)
	var placed: int = 0
	for dy: int in range(-4, 5):
		for dx: int in range(-4, 5):
			var c := Vector2i(hpos.x + dx, hpos.y + dy)
			if absi(dx) + absi(dy) > 4 or not gm.is_free(c):
				continue
			var msg: String = gm._resolve_summon(hunter, spell, p, c)
			placed += 1
			if placed >= 3:
				break
		if placed >= 3:
			break
	_check(gm.beacons_of(hunter).size() == 3, "3 balises posées")
	var syl: Dictionary = {}
	for pl2: Dictionary in gm.players:
		if pl2["classe"] == "Sylvain":
			syl = pl2
	_check(gm.beacons_of(syl).size() == 0, "les balises sont liées à leur propriétaire")
	pm.delete_save(4)
