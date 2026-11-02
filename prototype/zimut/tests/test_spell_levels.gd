extends SceneTree
## V74 : le niveau d'un sort fait monter ses caractéristiques (valeur, durée, portée, invocations),
## le Rappel d'invocation de l'Invocateur, Renforcement/Transposition de l'Ingénieur.
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _row(classe: String, nm: String, lvl: int) -> Dictionary:
	var ProgressionManager: Node = root.get_node("ProgressionManager")
	for row: Dictionary in ProgressionManager.spells_of(classe):
		if String(row["name"]) == nm:
			return {"name": nm, "classe": classe, "cost_pa": int(row["pa"]), "cost_pm": int(row["pm"]),
				"range": int(row["range"]), "effect": String(row["effect"]), "level_required": int(row["level"]),
				"spell_type": String(row["type"]), "Degats_physiques": int(row["phys"]),
				"Degats_magiques": int(row["mag"]), "Soins": int(row["heal"]),
				"spell_level": lvl, "mult": 1.0 + (lvl - 1) * 0.06}
	return {}
func _boot() -> void:
	var gm: Node = root.get_node("GameManager")
	var ProgressionManager: Node = root.get_node("ProgressionManager")
	await process_frame
	# Attaque, soin : valeurs ×(1+6%/niv)
	var a1: Dictionary = Combat.parse(_row("Mage", "Boule de feu", 1)) if not _row("Mage", "Boule de feu", 1).is_empty() else {}
	var a10: Dictionary = Combat.parse(_row("Mage", "Boule de feu", 10)) if not _row("Mage", "Boule de feu", 10).is_empty() else {}
	if not a1.is_empty():
		check(int(a10["dmg"]) > int(a1["dmg"]), "attaque : dégâts en hausse au niveau 10")
	# Sorts de PA (+2 PA) : la durée monte, pas la valeur
	var found_flat: bool = false
	for classe: String in ProgressionManager.class_names():
		for row: Dictionary in ProgressionManager.spells_of(classe):
			var s1: Dictionary = _row(classe, String(row["name"]), 1)
			var p1: Dictionary = Combat.parse(s1)
			for b: Dictionary in p1["buffs"] + p1["self_buffs"]:
				if String(b.get("id", "")) == "pa_up":
					found_flat = true
					var p10: Dictionary = Combat.parse(_row(classe, String(row["name"]), 10))
					var bb: Array = p10["buffs"] + p10["self_buffs"]
					var same_val: bool = false
					var longer: bool = false
					for b10: Dictionary in bb:
						if String(b10.get("id", "")) == "pa_up":
							same_val = is_equal_approx(float(b10["value"]), float(b["value"]))
							longer = int(b10["turns"]) > int(b["turns"])
					check(same_val and longer, "%s : +PA inchangé, durée allongée au niv. 10" % row["name"])
	check(found_flat, "au moins un sort +PA testé")
	# Perks
	check(Combat.level_perks(1)["turns"] == 0 and Combat.level_perks(5)["turns"] == 1 and Combat.level_perks(10)["turns"] == 2, "paliers de durée")
	check(Combat.level_perks(3)["range"] == 0 and Combat.level_perks(4)["range"] == 1 and Combat.level_perks(8)["range"] == 2, "paliers de portée")
	# Invocation : l'invoqué est plus costaud
	gm.set_custom_team([{"classe": "Invocateur"}, {"classe": "Tank"}, {"classe": "Mage"}])
	gm.init_grid()
	gm.init_entities()
	var inv: Dictionary = {}
	for p: Dictionary in gm.players:
		if String(p["classe"]) == "Invocateur":
			inv = p
	inv["spells"] = gm._build_spells("Invocateur", 100)
	inv["current_pa"] = 60
	var golem: Dictionary = {}
	var rap: Dictionary = {}
	for s: Dictionary in inv["spells"]:
		if String(s["name"]) == "Invoquer Golem de Pierre":
			golem = s
		if String(s["name"]) == "Rappel d'invocation":
			rap = s
	check(not rap.is_empty(), "l'Invocateur a un Rappel d'invocation")
	var free: Array = []
	for y: int in range(gm.GRID_SIZE):
		for x: int in range(gm.GRID_SIZE):
			var c := Vector2i(x, y)
			if gm.is_free(c) and Combat.manhattan(gm.pos_of(inv), c) == 1:
				free.append(c)
	golem["spell_level"] = 10
	golem["mult"] = 1.54
	golem.erase("_p")
	inv["casts"] = {}
	check(gm.cast_spell(inv, golem, free[0]), "invocation du golem niv. 10")
	var g10: Dictionary = gm.entity_at(free[0])
	check(not g10.is_empty(), "golem présent")
	check(float(Combat.parse(golem).get("summon_mult", 1.0)) > 1.4, "summon_mult porté par le sort")
	# Rappel d'invocation
	inv["casts"] = {}
	check(gm.validate_cast(inv, rap, gm.pos_of(inv)) != "", "rappel : il faut viser une invocation")
	check(gm.cast_spell(inv, rap, free[0]), "rappel du golem")
	check(gm.entity_at(free[0]).is_empty() or not gm.is_alive(g10), "golem rappelé")
	print("ÉCHECS : ", fails)
	quit(0 if fails == 0 else 1)
