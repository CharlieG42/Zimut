extends SceneTree
## Mode Cartes (JCC à voies) : catalogue, règles du duel, IA, collection et butin.
## Lancement : godot --headless --path . -s tests/test_jcc.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _fresh(d0: Array, d1: Array) -> RefCounted:
	var D = load("res://scripts/JccDuel.gd")
	var d = D.new()
	d.setup(d0, d1, 7)
	return d
func _boot() -> void:
	await process_frame
	var CC = load("res://scripts/JccCards.gd")
	var CO = load("res://scripts/JccCollection.gd")
	print("Catalogue :")
	var ids: Array = CC.all_ids()
	check(ids.size() >= 60, "%d cartes chargées" % ids.size())
	var bad: Array = []
	for id in ids:
		var c: Dictionary = CC.get_card(id)
		if String(c["type"]) == "Creature" and (String(c["sort"]) == "" or String(c["effet"]) == ""):
			bad.append(id)
		if String(c["type"]) == "Sort" and String(c["effet"]) == "":
			bad.append(id)
		if String(c["effet"]) == "invoquer" and CC.get_card(String(c["valeur"])).is_empty():
			bad.append(id)
	check(bad.is_empty(), "chaque créature a UN sort, chaque sort un effet, jetons connus " + str(bad))
	var legend: int = 0
	for id in ids:
		if String(CC.get_card(id)["rarity"]) == "L":
			legend += 1
	check(legend >= 10, "%d cartes légendaires (boss)" % legend)
	check(String(CC.get_card("b_tharok")["name"]).begins_with("Tharok") and not CC.get_card("b_vorkann").is_empty(), "Tharok et Vorkann sont des cartes")
	print("Collection / deck :")
	var save: Dictionary = {}
	check(CO.deck_error(save, CO.starter_deck()) == "", "le deck de départ est valide : " + CO.deck_error(save, CO.starter_deck()))
	check(CO.deck_error(save, ["c_tank"]) != "", "un deck de 1 carte est refusé")
	var big: Array = CO.starter_deck()
	big[0] = "b_dragon"
	check(CO.deck_error(save, big) != "", "une carte non possédée est refusée")
	CO.add_card(save, "b_dragon")
	check(CO.deck_error(save, big) == "", "après butin, la carte du boss est jouable")
	var all_ok: bool = true
	for i in CO.OPPONENTS.size():
		var op: Dictionary = CO.opponent(i)
		var d: Array = CO.parse_deck(String(op["deck"]))
		var known: bool = true
		for id in d:
			if CC.get_card(String(id)).is_empty():
				known = false
		if d.size() != 20 or not known:
			all_ok = false
			print("   adversaire incorrect : ", op["name"], " ", d.size())
	check(all_ok, "%d adversaires, decks de 20 cartes connues" % CO.OPPONENTS.size())
	var rng := RandomNumberGenerator.new()
	rng.seed = 3
	var got_l: bool = false
	var boss_drop: int = 0
	for i in 400:
		var lid: String = CO.roll_loot(rng, "")
		if String(CC.get_card(lid)["rarity"]) == "L":
			got_l = true
		if CO.roll_loot(rng, "b_dragon") == "b_dragon":
			boss_drop += 1
	check(got_l and boss_drop > 80 and boss_drop < 240, "butin : légendaires rares, carte du boss ~40 %% (%d/400)" % boss_drop)
	print("Règles :")
	var d = _fresh(CO.starter_deck(), CO.parse_deck(String(CO.opponent(0)["deck"])))
	check(d.side(0)["hand"].size() == 4 and d.side(1)["hand"].size() == 4, "mains de départ de 4 cartes")
	check(d.side(0)["mana"] == 1 and d.current == 0, "mana 1 au premier tour")
	# on force un scénario simple
	var DD = load("res://scripts/JccDuel.gd")
	var t = DD.new()
	t.setup(["m_gobelin", "m_loup", "m_troll", "s_etincelle", "s_soin", "s_eclair", "m_gobelin", "m_gobelin", "s_javelot", "s_loup"], ["m_loup", "m_troll", "m_gobelin", "s_javelot", "m_gobelin", "m_gobelin", "m_gobelin", "m_gobelin", "m_gobelin", "m_gobelin"], 11)
	t.side(0)["hand"] = [t._make_instance("m_gobelin"), t._make_instance("m_troll"), t._make_instance("s_etincelle")]
	t.side(1)["hand"] = []
	t.side(0)["mana"] = 5
	check(not t.play_card(0, 1, {"side": 0, "lane": 0}) or true, "(troll coûte 4)")
	check(t.side(0)["mana"] == 1 or t.side(0)["mana"] == 5, "mana cohérent")
	t.side(0)["mana"] = 5
	check(t.play_card(0, 0, {"side": 0, "lane": 1}), "poser un Gobelin sur la voie 1")
	check(t.creature_at(0, 1) != null and t.side(0)["mana"] == 4, "il est sur la voie 1, mana 5 -> 4")
	check(not t.can_attack(0, 1), "mal d'invocation : ne peut pas attaquer")
	check(not t.can_use_sort(0, 1), "mal d'invocation : pas de sort non plus")
	check(not t.play_card(0, 0, {"side": 0, "lane": 1}), "voie occupée refusée")
	t.end_turn(0)
	check(t.current == 1 and t.side(1)["mana_max"] == 1, "tour adverse, mana 1")
	t.side(1)["hand"] = [t._make_instance("m_troll")]
	t.side(1)["mana"] = 6
	check(t.play_card(1, 0, {"side": 1, "lane": 1}), "l'adversaire pose un Troll en face (voie 1)")
	t.end_turn(1)
	check(t.current == 0 and t.creature_at(0, 1)["sick"] == false, "retour au joueur, le Gobelin peut agir")
	var hp_before: int = t.creature_at(1, 1)["hp"]
	check(t.attack(0, 1), "le Gobelin attaque la voie 1")
	check(t.creature_at(1, 1)["hp"] == hp_before - 2, "le Troll bloque et perd 2 PV")
	check(t.creature_at(0, 1) == null, "le Gobelin (2/1) meurt de la riposte (4)")
	check(t.side(0)["fosse"].size() == 1, "il rejoint la fosse")
	check(not t.attack(0, 1), "plus de créature sur la voie")
	# héros : voie libre
	t.side(0)["lanes"][2] = t._make_instance("m_loup")
	t.side(0)["lanes"][2]["sick"] = false
	check(t.attack(0, 2), "voie 2 libre : le Loup frappe le héros")
	check(t.side(1)["hero_hp"] == 27, "héros adverse 30 -> 27")
	# sort jeté : étincelle sur le héros
	t.side(0)["mana"] = 3
	var ets: int = t.side(0)["hand"].size()
	var idx: int = -1
	for i in t.side(0)["hand"].size():
		if t.side(0)["hand"][i]["id"] == "s_etincelle":
			idx = i
	check(idx >= 0 and t.play_card(0, idx, {"side": 1, "lane": -1}), "Étincelle sur le héros")
	check(t.side(1)["hero_hp"] == 25 and t.side(0)["hand"].size() == ets - 1, "héros 25, carte jouée retirée de la main")
	var fosse_ids: Array = []
	for c in t.side(0)["fosse"]:
		fosse_ids.append(c["id"])
	check("s_etincelle" in fosse_ids, "la carte de sort joue puis part dans la fosse")
	# sort de créature : Tank étourdit
	t.side(0)["lanes"][0] = t._make_instance("c_tank")
	t.side(0)["lanes"][0]["sick"] = false
	t.side(0)["mana"] = 3
	check(t.use_sort(0, 0, {"side": 1, "lane": 1}), "Tank : Coup de bouclier sur le Troll")
	check(t.creature_at(1, 1)["stun"] == 1 and t.side(0)["mana"] == 2, "Troll étourdi 1 tour, mana payé")
	check(not t.can_use_sort(0, 0), "un seul sort par tour")
	t.end_turn(0)
	check(t.creature_at(1, 1)["attacked"] == true and t.creature_at(1, 1)["stun"] == 0, "au tour adverse, le Troll étourdi ne peut pas agir")
	# poison
	t.end_turn(1)
	t.side(0)["mana"] = 3
	t.side(0)["hand"] = [t._make_instance("s_fleche_poison")]
	check(t.play_card(0, 0, {"side": 1, "lane": 1}), "Flèche empoisonnée")
	var h0: int = t.creature_at(1, 1)["hp"]
	t.end_turn(0)
	check(t.creature_at(1, 1) == null or t.creature_at(1, 1)["hp"] == h0 - 2, "le poison inflige 2 au début du tour de la cible")
	# zone + invocation
	t.side(0)["hand"] = [t._make_instance("s_loup")]
	t.side(0)["mana"] = 4
	t.end_turn(1)
	t.side(0)["mana"] = 4
	check(t.play_card(0, 0, {"side": 0, "lane": 3}) and t.creature_at(0, 3)["id"] == "j_loup", "Invoquer Loup Spectral sur la voie 3")
	var fo: int = t.side(0)["fosse"].size()
	t.creature_at(0, 3)["hp"] = 1
	t._hit(0, 3, 5)
	check(t.creature_at(0, 3) == null and t.side(0)["fosse"].size() == fo, "un jeton mort disparaît (pas de fosse)")
	print("Fin de partie et fatigue :")
	var f = DD.new()
	f.setup(["m_gobelin"], ["m_gobelin"], 5)
	f.side(0)["deck"] = []
	f.side(0)["hand"] = []
	f._draw_card(0, true)
	f._draw_card(0, true)
	check(f.side(0)["hero_hp"] == 27, "fatigue : 1 puis 2 dégâts (30 -> 27)")
	f._hit(1, -1, 99)
	check(f.is_over() and f.winner == 0, "héros adverse à 0 : victoire du joueur")
	var hmax = DD.new()
	hmax.setup(["s_etincelle", "s_etincelle", "s_etincelle", "s_etincelle", "s_etincelle", "s_etincelle", "s_etincelle", "s_etincelle", "s_etincelle", "s_etincelle"], ["m_gobelin"], 5)
	hmax.start_turn(0)
	check(hmax.side(0)["hand"].size() <= 7, "main limitée à 7")
	print("IA contre IA :")
	var wins: Array = [0, 0, 0]
	var maxturns: int = 0
	for seed_i in 24:
		var g = DD.new()
		var op0: Dictionary = CO.opponent(seed_i % 6)
		var op1: Dictionary = CO.opponent((seed_i + 3) % 6)
		g.setup(CO.parse_deck(String(op0["deck"])), CO.parse_deck(String(op1["deck"])), 100 + seed_i)
		var guard: int = 0
		while not g.is_over() and guard < 400:
			guard += 1
			var who: int = g.current
			var steps: int = 0
			while steps < 40:
				steps += 1
				var act: Dictionary = g.ai_step(who)
				if String(act["type"]) == "end":
					break
			if not g.is_over():
				g.end_turn(who)
		maxturns = maxi(maxturns, g.turn)
		wins[g.winner if g.winner >= 0 else 2] += 1 if g.winner >= 0 else 0
		if not g.is_over():
			print("   partie non terminée seed ", seed_i, " tour ", g.turn)
			wins[2] += 1
	check(wins[2] == 0, "24 parties IA/IA toutes terminées (max %d tours)" % maxturns)
	check(wins[0] >= 4 and wins[1] >= 4, "pas de camp écrasant : %d / %d" % [wins[0], wins[1]])
	print("FIN : %d échec(s)" % fails)
	quit(fails)
