extends SceneTree

## V158 : équilibrage des offensives de Conquête — force plafonnée, généraux soumis au délai,
## villes tout juste reprises protégées, défense atteignable pour l'alerte.

var fails: int = 0

func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1

func _init() -> void:
	_boot.call_deferred()

func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var CS: GDScript = load("res://scripts/ConquestSystem.gd")
	var routes: Array = pm.CONQUEST_ROUTES

	# ── Force : croît avec les villes, le terme « batailles » est plafonné ──
	var c1: Dictionary = {"owned": ["capitale", "a", "b", "c"], "battle_count": 10}
	var c2: Dictionary = {"owned": ["capitale", "a", "b", "c"], "battle_count": 100000}
	var c3: Dictionary = {"owned": ["capitale"], "battle_count": 100000}
	check(CS.offensive_base(c1) < CS.offensive_base(c2), "la force croît avec les batailles")
	check(CS.offensive_base(c2) - CS.offensive_base(c1) <= CS.OFFENSIVE_BATTLE_CAP, "le terme batailles est plafonné")
	check(CS.offensive_base(c2) > CS.offensive_base(c3), "la force croît avec les villes possédées")
	var big: Array = ["capitale"]
	for i: int in range(44):
		big.append("v%d" % i)
	check(CS.offensive_base({"owned": big, "battle_count": 100000}) < 60.0, "même à 44 villes, la force reste à portée d'une ville bien tenue")

	# ── Villes : une ville de niveau 1 à garnison pleine tient la première offensive ──
	var data: Dictionary = pm.new_game(4, "Equilibre")
	pm.rebuild_team(data, ["Tank", "Mage", "Heal"])
	data["campaign_mode"] = "conquest"
	var conq: Dictionary = {"owned": ["capitale", "clairiere", "a", "b"], "battle_count": 8,
		"garrisons": {"clairiere": {"troops": 4, "hero": ""}}}
	data["conquest"] = conq
	var d: int = CS.defense(data, "clairiere")
	check(float(d) >= CS.offensive_base(conq) * 0.85, "première offensive typique (force basse) : ville niveau 1 pleine = %d ≥ %.0f" % [d, CS.offensive_base(conq) * 0.85])

	# ── Défense atteignable ──
	data["conquest"]["garrisons"]["clairiere"] = {"troops": 0, "hero": ""}
	var d0: int = CS.defense(data, "clairiere")
	var full: int = CS.reachable_defense(data, "clairiere")
	check(full == d0 + CS.garrison_cap(data["conquest"], "clairiere") * 2, "défense atteignable = défense + 2 par soldat manquant")
	check(CS.reachable_cost(data, "clairiere") == CS.garrison_cap(data["conquest"], "clairiere") * CS.TROOP_COST, "coût du renfort complet")

	# ── Généraux : mêmes règles que les offensives anonymes ──
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	var gens: Array = CS.GENERALS.keys()
	var base_conq := func() -> Dictionary:
		return {"owned": ["capitale", "clairiere", "a", "b", "c"], "battle_count": 30, "generals_dead": [], "threat_cd": 0}
	var gc: Dictionary = base_conq.call()
	var fired_early: int = 0
	for i: int in range(200):
		gc = base_conq.call()
		gc["threat_cd"] = 0
		CS._maybe_general_threat(data, gc, rng, routes, "")
		if not CS.threat(gc).is_empty():
			fired_early += 1
	check(fired_early == 0, "un général n'attaque pas avant le délai minimal (%d tirs sur 200)" % fired_early)
	var fired_late: int = 0
	for i: int in range(200):
		gc = base_conq.call()
		gc["threat_cd"] = CS.THREAT_MIN_GAP
		CS._maybe_general_threat(data, gc, rng, routes, "")
		if not CS.threat(gc).is_empty():
			fired_late += 1
			check(int(gc["threat_cd"]) == 0, "le délai repart de zéro après l'offensive d'un général") if fired_late == 1 else null
	check(fired_late > 0 or gens.is_empty(), "le délai écoulé, un général peut attaquer (%d/200)" % fired_late)
	var few: Dictionary = {"owned": ["capitale", "clairiere"], "battle_count": 30, "threat_cd": 99}
	var fired_few: int = 0
	for i: int in range(100):
		var f2: Dictionary = few.duplicate(true)
		CS._maybe_general_threat(data, f2, rng, routes, "")
		if not CS.threat(f2).is_empty():
			fired_few += 1
	check(fired_few == 0, "pas d'offensive de général avant 3 villes")

	# ── Ville tout juste reprise (ruinée) : non visée ──
	var rc: Dictionary = {"owned": ["capitale", "clairiere", "a"], "ruin": {"clairiere": 2}}
	var pool: Array = CS._target_pool(rc, routes, "", true, true)
	check(not pool.has("clairiere") and pool.has("a"), "une ville ruinée est exclue des cibles d'offensive")
	check(CS._target_pool(rc, routes, "", true).has("clairiere"), "les raids, eux, peuvent encore la viser")

	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
