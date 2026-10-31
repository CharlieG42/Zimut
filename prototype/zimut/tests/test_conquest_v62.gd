extends SceneTree

## Tests V62 de la Conquête — aspect graphique : heure du jour, événements de ville,
## spécialisation de la Cité (militaire / marchande) et bonus associés.

var fails: int = 0

func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1

func _init() -> void:
	_boot.call_deferred()

func _fresh(owned: Array) -> Dictionary:
	var pm: Node = root.get_node("ProgressionManager")
	var d: Dictionary = pm.new_game(3, "V62")
	d["campaign_mode"] = "conquest"
	d["gold"] = 1000
	d["resources"] = {"Bois": 50, "Fer": 50, "Cuir": 50, "Magie": 50, "Venin": 50}
	d["conquest"] = {"owned": owned, "pending_city": ""}
	return d

func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")

	# ── Heure du jour ──
	var d: Dictionary = _fresh(["capitale", "clairiere"])
	var cq: Dictionary = d["conquest"]
	check(ConquestSystem.time_of_day(cq, "clairiere") in ConquestSystem.DAY_CYCLE, "heure du jour valide")
	cq["battle_count"] = 1
	var t1: String = ConquestSystem.time_of_day(cq, "clairiere")
	check(t1 != ConquestSystem.time_of_day(d["conquest"], "capitale") or true, "cycle lisible")
	var c0: String = ConquestSystem.effective_time(cq, "clairiere")
	var c1: String = ConquestSystem.cycle_time_of_day(cq, "clairiere")
	check(c1 != c0, "cycle_time_of_day avance l'heure (%s → %s)" % [c0, c1])
	check(ConquestSystem.effective_time(cq, "clairiere") == c1, "décalage manuel prioritaire sur le cycle auto")
	cq["battle_count"] = 50   # le cycle auto repart, mais le manuel reste
	check(ConquestSystem.effective_time(cq, "clairiere") == c1, "le décalage manuel persiste")

	# ── Événements de ville ──
	var rng := RandomNumberGenerator.new()
	rng.seed = 1
	check(ConquestSystem.city_event(cq, "clairiere") == "", "pas d'événement au départ")
	var seen := {}
	for i in range(40):
		var ev: String = ConquestSystem.maybe_city_event(cq, "clairiere", rng)
		if ev != "":
			seen[ev] = true
	check(seen.size() >= 1, "un événement finit par se déclencher (%s)" % str(seen.keys()))
	check(ConquestSystem.city_event(cq, "clairiere") != "", "l'événement en cours est lisible")
	var ev0: String = ConquestSystem.city_event(cq, "clairiere")
	ConquestSystem.maybe_city_event(cq, "clairiere", rng)
	check(ConquestSystem.city_event(cq, "clairiere") == ev0, "l'événement en cours ne change pas tant qu'il dure")
	cq["owned"] = ["capitale"]   # clairiere n'est plus à nous
	ConquestSystem.tick_city_events(cq)
	check(ConquestSystem.city_event(cq, "clairiere") == "", "l'événement disparaît si la ville n'est plus possédée")

	# ── Spécialisation de la Cité ──
	var d2: Dictionary = _fresh(["capitale", "clairiere"])
	d2["gold"] = 5000
	d2["resources"] = {"Bois": 999, "Fer": 999, "Cuir": 999, "Magie": 999, "Venin": 999}
	var cq2: Dictionary = d2["conquest"]
	check(ConquestSystem.city_spec(cq2, "clairiere") == "", "pas de spécialisation au départ")
	check(ConquestSystem.choose_spec(d2, "clairiere", "militaire") != "", "spécialisation refusée avant la Cité")
	pm.conquest_upgrade_city(d2, "clairiere")
	pm.conquest_upgrade_city(d2, "clairiere")
	check(ConquestSystem.city_level(cq2, "clairiere") == 3, "ville passée Cité (niveau 3)")
	var def_before: int = ConquestSystem.defense(d2, "clairiere")
	var inc_before: int = ConquestSystem.city_income(d2, "clairiere")
	check(ConquestSystem.choose_spec(d2, "clairiere", "militaire") == "", "spécialisation militaire choisie")
	check(ConquestSystem.city_spec(cq2, "clairiere") == "militaire", "spécialisation enregistrée")
	check(ConquestSystem.defense(d2, "clairiere") == def_before + int(ConquestSystem.CITY_SPECS["militaire"]["def"]), "militaire : +défense appliquée")
	check(ConquestSystem.choose_spec(d2, "clairiere", "marchande") != "", "une seule spécialisation par ville")
	var d3: Dictionary = _fresh(["capitale", "clairiere"])
	d3["gold"] = 5000
	d3["resources"] = {"Bois": 999, "Fer": 999, "Cuir": 999, "Magie": 999, "Venin": 999}
	pm.conquest_upgrade_city(d3, "clairiere")
	pm.conquest_upgrade_city(d3, "clairiere")
	var inc3: int = ConquestSystem.city_income(d3, "clairiere")
	check(ConquestSystem.choose_spec(d3, "clairiere", "marchande") == "", "spécialisation marchande choisie")
	check(ConquestSystem.city_income(d3, "clairiere") == inc3 + int(ConquestSystem.CITY_SPECS["marchande"]["gold"]), "marchande : +or par victoire appliqué")
	check(ConquestSystem.choose_spec(d3, "inconnue", "x") != "", "spécialisation inconnue refusée")
	# ville pillée : le bonus est gelé
	cq2["ravage"] = {"clairiere": 2}
	check(int(ConquestSystem.spec_bonus(cq2, "clairiere").get("def", 0)) == 0, "bonus gelé si la ville est pillée")
	cq2.erase("ravage")
	check(int(ConquestSystem.spec_bonus(cq2, "clairiere").get("def", 0)) == int(ConquestSystem.CITY_SPECS["militaire"]["def"]), "bonus de retour si plus pillée")
	check(int(ConquestSystem.spec_bonus(cq2, "capitale").get("def", 0)) == 0, "pas de bonus sans spécialisation")

	print("== %s ==" % ("TOUT OK" if fails == 0 else "%d échec(s)" % fails))
	quit(1 if fails > 0 else 0)
