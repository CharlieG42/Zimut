extends SceneTree
## test_combat.gd — Tests headless des règles de combat (zones d'effet, parsing).
## Lancement : godot --headless -s tests/test_combat.gd --path .

var failures: int = 0

func _init() -> void:
	_test_zone_shapes()
	_test_zone_parsing()
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

func _test_zone_shapes() -> void:
	print("zone_cells :")
	var c := Vector2i(5, 5)
	_check(Combat.zone_cells(c, 1, "diamond", 12).size() == 5, "diamant r=1 -> 5 cases (croix)")
	_check(Combat.zone_cells(c, 1, "square", 12).size() == 9, "carré r=1 -> 9 cases")
	_check(Combat.zone_cells(c, 2, "square", 12).size() == 25, "carré r=2 -> 25 cases (5x5)")
	var sq3: Array[Vector2i] = Combat.zone_cells(c, 3, "square_side", 12)
	_check(sq3.size() == 9, "côté 3x3 -> 9 cases")
	var sq2: Array[Vector2i] = Combat.zone_cells(c, 2, "square_side", 12)
	_check(sq2.size() == 4, "côté 2x2 -> 4 cases")
	var sq4: Array[Vector2i] = Combat.zone_cells(c, 4, "square_side", 12)
	_check(sq4.size() == 16, "côté 4x4 -> 16 cases")
	var edge: Array[Vector2i] = Combat.zone_cells(Vector2i(0, 0), 3, "square_side", 12)
	_check(edge.size() == 4, "zone 3x3 au bord -> seulement 4 cases dans la grille")

func _spell(effect: String, stype: String = "Attaque") -> Dictionary:
	return {"name": "Test", "effect": effect, "spell_type": stype, "range": 4,
		"Degats_physiques": 0, "Degats_magiques": 0, "Soins": 0}

func _test_zone_parsing() -> void:
	print("parsing des sorts de zone :")
	var p3: Dictionary = Combat.parse(_spell("120 dégâts en zone (3x3)"))
	_check(p3["aoe"] == "zone", "'en zone (3x3)' détecté comme zone")
	var cells3: Array[Vector2i] = Combat.zone_cells(Vector2i(5, 5), int(p3["zone_r"]), String(p3["zone_shape"]), 12)
	_check(cells3.size() == 9, "sort 3x3 -> 9 cases touchées (obtenu %d)" % cells3.size())
	var p2: Dictionary = Combat.parse(_spell("150 dégâts en zone (2x2)"))
	var cells2: Array[Vector2i] = Combat.zone_cells(Vector2i(5, 5), int(p2["zone_r"]), String(p2["zone_shape"]), 12)
	_check(cells2.size() == 4, "sort 2x2 -> 4 cases touchées (obtenu %d)" % cells2.size())
	var p4: Dictionary = Combat.parse(_spell("210 dégâts en zone (4x4)"))
	var cells4: Array[Vector2i] = Combat.zone_cells(Vector2i(5, 5), int(p4["zone_r"]), String(p4["zone_shape"]), 12)
	_check(cells4.size() == 16, "sort 4x4 -> 16 cases touchées (obtenu %d)" % cells4.size())
	var melee_spell: Dictionary = _spell("Inflige 40 dégâts à tous les ennemis adjacents")
	melee_spell["range"] = 1
	var pc: Dictionary = Combat.parse(melee_spell)
	_check(pc["aoe"] == "adjacent_enemies" and pc["dmg"] == 40, "'à tous les ennemis adjacents' -> adjacent_enemies (mêlée)")
	var pi: Dictionary = Combat.parse(_spell("L'invocation attaque tous les ennemis adjacents (60 dégâts)"))
	_check(pi["aoe"] == "zone" and bool(pi["needs_summon"]), "attaque d'invocation -> zone autour de la case ciblée")
	var pz: Dictionary = Combat.parse(_spell("Attaque tous les ennemis adjacents (20 dégâts)"))
	_check(pz["aoe"] == "zone" and pz["target"] == "cell", "'tous les ennemis adjacents' variante zone")
