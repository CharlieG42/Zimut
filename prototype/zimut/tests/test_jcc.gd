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
	print("Méta (multi-decks, défi du jour, déblocages) :")
	var save2: Dictionary = {}
	var j2: Dictionary = CO.ensure(save2)
	check((j2["decks"] as Dictionary).has("Deck 1") and String(j2["active_deck"]) == "Deck 1", "migration : decks['Deck 1'] créé, active_deck = Deck 1")
	check(CO.deck_of(save2, "Deck 1").size() == 20 and CO.deck_of(save2, "Inconnu").size() == 20, "deck_of : deck nommé, repli sur le deck actif si inconnu")
	(j2["decks"] as Dictionary)["Deck 2"] = CO.starter_deck()
	CO.set_active_deck(save2, "Deck 2")
	check(CO.active_deck_name(save2) == "Deck 2" and (j2["deck"] as Array).size() == 20, "set_active_deck : nom actif + miroir j['deck']")
	CO.set_active_deck(save2, "Deck 1")
	check(CO.active_deck_name(save2) == "Deck 1", "retour au Deck 1")
	var chall: Dictionary = CO.daily_challenge(save2)
	check(String(chall.get("id", "")) != "" and String(chall.get("date", "")) == Time.get_date_string_from_system() and int(chall.get("target", 0)) > 0, "défi du jour créé pour aujourd'hui")
	var chall_bis: Dictionary = CO.daily_challenge(save2)
	check(String(chall_bis["id"]) == String(chall["id"]) and int(chall_bis["progress"]) == int(chall["progress"]), "défi du jour stable dans la journée")
	var stats_full: Dictionary = {"creatures": 99, "spells": 99, "hero_dmg": 99}
	var rep: Dictionary = CO.challenge_report(save2, stats_full, String(chall["id"]) == "win")
	if not bool(rep.get("done", false)):
		rep = CO.challenge_report(save2, stats_full, true)
	check(bool(rep.get("done", false)) and String(rep.get("reward", "")) != "", "défi complété en un duel : récompense carte attribuée")
	check(CO.owned(save2, String(rep["reward"])) >= 1, "la récompense du défi est bien possédée")
	var rep2: Dictionary = CO.challenge_report(save2, stats_full, true)
	check(bool(rep2.get("done", false)) and String(rep2.get("reward", "")) == "", "défi déjà réussi : plus de récompense")
	check(CO.is_unlocked(save2, 0) and not CO.is_unlocked(save2, 1) and not CO.is_unlocked(save2, 5), "déblocage : adversaire 0 oui, 1 et 5 non")
	var nu: int = CO.unlock_next(save2, 0)
	check(nu == 1 and CO.is_unlocked(save2, 1), "unlock_next après victoire vs 0 débloque l'adversaire 1")
	check(CO.unlock_next(save2, 5) == -1 and CO.unlock_next(save2, 0) == -1, "unlock_next sans nouveau déblocage renvoie -1")
	print("Règles (grille 4x6, PA/PM/PO) :")
	var DD = load("res://scripts/JccDuel.gd")
	var t = DD.new()
	t.setup(["m_gobelin", "m_loup", "m_troll", "s_etincelle", "s_soin", "s_eclair", "m_gobelin", "m_gobelin", "s_javelot", "s_loup"], ["m_loup", "m_troll", "m_gobelin", "s_javelot", "m_gobelin", "m_gobelin", "m_gobelin", "m_gobelin", "m_gobelin", "m_gobelin"], 11)
	t.side(0)["hand"] = [t._make_instance("m_gobelin"), t._make_instance("m_troll"), t._make_instance("s_etincelle")]
	t.side(1)["hand"] = []
	t.side(0)["mana"] = 5
	# dépôt : 2 lignes proches du héros (y=4..5 pour le joueur -> cases 16..23)
	check(not t.play_card(0, 0, {"side": 0, "lane": 0}), "hors zone de déploiement : dépôt refusé (case 0 = y 0)")
	check(t.play_card(0, 0, {"side": 0, "lane": 21}), "poser un Gobelin en case 21 (x1, y5)")
	check(t.creature_at(0, 21) != null and t.side(0)["mana"] == 4, "Gobelin en (1,5), mana 5 -> 4")
	check(not t.can_attack(0, 21), "mal d'invocation : ne peut pas attaquer")
	check(not t.can_use_sort(0, 21), "mal d'invocation : pas de sort non plus")
	check(not t.play_card(0, 0, {"side": 0, "lane": 21}), "case occupée refusée")
	# PM : déplacement case par case (BFS), 1 PM par case
	var g: Dictionary = t.creature_at(0, 21)
	check(int(g["pm"]) == 2 and int(g["pa"]) == 1 and int(g["po"]) == 1, "Gobelin : PA 1 / PM 2 / PO 1 (lus dans cartes_jcc.txt)")
	check(t.can_move(0, 21, 17), "PM : peut avancer en (1,4)")
	check(t.move(0, 21, 17) and t.creature_at(0, 17) != null and int(g["pm"]) == 1, "1 case = 1 PM")
	check(t.can_move(0, 17, 13) and not t.can_move(0, 17, 9), "PM restant 1 : 1 case oui, 2 cases non")
	check(t.move(0, 17, 13) and int(g["pm"]) == 0, "2e case, PM à 0")
	check(not t.can_move(0, 13, 12), "plus de PM : plus de déplacement")
	# attaque : portée PO, riposte, mort
	t.place_unit(1, "m_troll", 1, 2)   # case 9, à distance 1 du Gobelin (1,3)
	t.current = 0
	g = t.creature_at(0, 13)
	g["sick"] = false
	var at1: Array = t.attack_targets(0, 13)
	check(at1.size() == 1 and int(at1[0]["lane"]) == 9, "PO 1 : seule la case (1,2) est à portée")
	var hp_before: int = t.creature_at(1, 9)["hp"]
	check(t.attack(0, 13), "le Gobelin attaque le Troll")
	check(t.creature_at(1, 9) == null or t.creature_at(1, 9)["hp"] == hp_before - 2, "le Troll perd 2 PV")
	check(t.creature_at(0, 13) == null, "le Gobelin (2/1) meurt de la riposte (4)")
	check(t.side(0)["fosse"].size() == 1, "il rejoint la fosse")
	check(not t.can_attack(0, 13), "plus de créature en (1,3)")
	# PA : attaque et sort consomment les PA
	var tk: Dictionary = t.place_unit(0, "c_tank", 0, 5)   # case 20
	tk["sick"] = false
	t.place_unit(1, "m_gobelin", 0, 4)                       # case 16, distance 1
	t.side(0)["mana"] = 5
	t.current = 0
	check(int(tk["pa"]) == 1 and t.can_attack(0, 20), "Tank : PA 1 dispo")
	check(t.attack(0, 20, {"side": 1, "lane": 16}), "Tank attaque le Gobelin en (0,4)")
	check(int(tk["pa"]) == 0 and not t.can_attack(0, 20), "1 PA consommé : plus d'attaque")
	check(not t.can_use_sort(0, 20), "plus de PA : le sort non plus")
	t.end_turn(0)
	t.end_turn(1)
	check(t.current == 0 and int(tk["pa"]) == 1, "PA rechargé au début du tour")
	t.place_unit(1, "m_gobelin", 1, 4)   # case 17 : le gobelin en (0,4) est mort, il en faut un autre pour la cible "ennemi"
	var mana_avant: int = t.side(0)["mana"]
	check(t.use_sort(0, 20, {"side": 1, "lane": 17}), "Tank : Coup de bouclier (1 PA + 1 mana)")
	check(int(tk["pa"]) == 0 and t.creature_at(1, 17)["stun"] == 1 and t.side(0)["mana"] == mana_avant - 1, "sort lancé : PA 0, mana payé, cible étourdie")
	# PO 3 (Chasseur) et attaque du héros depuis la ligne arrière adverse
	var ch: Dictionary = t.place_unit(0, "c_chasseur", 3, 5)   # case 23
	ch["sick"] = false
	t.place_unit(1, "m_gobelin", 3, 2)                          # case 11, distance 3
	t.current = 0
	var at3: Array = t.attack_targets(0, 23)
	var has11 := false
	for e in at3:
		if int(e["lane"]) == 11:
			has11 = true
	check(int(ch["po"]) == 3 and has11, "PO 3 : une cible à distance 3 est ciblable")
	var lp: Dictionary = t.place_unit(0, "m_loup", 2, 0)        # case 2 = ligne arrière adverse
	lp["sick"] = false
	check(t.hero_dist_to(0, 2) == 1, "case (2,0) : distance 1 du héros adverse")
	check(t.attack(0, 2), "le Loup frappe le héros adverse")
	check(t.side(1)["hero_hp"] == 27, "héros adverse 30 -> 27")
	# sort jeté sur le héros, puis fosse
	t.side(0)["mana"] = 3
	var ets: int = t.side(0)["hand"].size()
	var idx: int = -1
	for i in t.side(0)["hand"].size():
		if t.side(0)["hand"][i]["id"] == "s_etincelle":
			idx = i
	t.current = 0
	check(idx >= 0 and t.play_card(0, idx, {"side": 1, "lane": -1}), "Étincelle sur le héros")
	check(t.side(1)["hero_hp"] == 25 and t.side(0)["hand"].size() == ets - 1, "héros 25, carte retirée de la main")
	var fosse_ids: Array = []
	for cc in t.side(0)["fosse"]:
		fosse_ids.append(cc["id"])
	check("s_etincelle" in fosse_ids, "la carte de sort jouée part dans la fosse")
	# invocation de jeton
	t.side(0)["hand"] = [t._make_instance("s_loup")]
	t.side(0)["mana"] = 4
	t.current = 0
	check(t.play_card(0, 0, {"side": 0, "lane": 22}) and t.creature_at(0, 22)["id"] == "j_loup", "Invoquer Loup Spectral en (2,5)")
	var fo: int = t.side(0)["fosse"].size()
	t.creature_at(0, 22)["hp"] = 1
	t._hit(0, 22, 5)
	check(t.creature_at(0, 22) == null and t.side(0)["fosse"].size() == fo, "un jeton mort disparaît (pas de fosse)")
	print("Mots-clés (vol, perforation, provocation, régénération, initiative) :")
	check("vol" in CC.get_card("m_vampire")["keywords"] and "perforation" in CC.get_card("m_belier")["keywords"], "mots-clés parsés depuis cartes_jcc.txt")
	var kw = DD.new()
	kw.setup(["m_gobelin"], ["m_gobelin"], 77, ["Mage", "boss"])
	kw.terrain = []
	for i in JccDuel.LANES:
		kw.terrain.append("")
	# vol : le vampire se soigne des dégâts infligés ; une cible morte ne riposte pas
	var va: Dictionary = kw.place_unit(0, "m_vampire", 1, 5)   # case 21, atq 3
	va["hp"] = 1
	var dl: Dictionary = kw.place_unit(1, "m_loup", 1, 4)       # case 17, hp 2
	dl["hp"] = 2
	check(kw.attack(0, 21, {"side": 1, "lane": 17}), "le Vampire attaque le Loup")
	check(int(va["hp"]) == 3, "vol : le Vampire se soigne (1 -> 3)")
	check(kw.creature_at(1, 17) == null, "le Loup (2 PV) meurt : pas de riposte sur un mort")
	# perforation : l'excédent passe au héros adverse
	var be: Dictionary = kw.place_unit(0, "m_belier", 0, 5)     # case 20, atq 4
	var dl2: Dictionary = kw.place_unit(1, "m_loup", 0, 4)      # case 16, hp 2
	dl2["hp"] = 2
	check(kw.attack(0, 20, {"side": 1, "lane": 16}), "le Bélier attaque le Loup")
	check(kw.side(1)["hero_hp"] == 28, "perforation : 4 - 2 = 2 dégâts excédentaires au héros (30 -> 28)")
	# provocation : seule la case avec provocation est ciblable, l'attaque est redirigée
	var gb: Dictionary = kw.place_unit(0, "m_gobelin", 2, 5)    # case 22, PO 1
	var ch2: Dictionary = kw.place_unit(1, "c_chevalier", 2, 4) # case 18, provocation, hp 8
	kw.place_unit(1, "m_gobelin", 3, 4)                          # case 19, sans provocation
	var atp: Array = kw.attack_targets(0, 22)
	check(atp.size() == 1 and int((atp[0] as Dictionary)["lane"]) == 18, "provocation : seule la case 18 est ciblable")
	kw.attack(0, 22, {"side": 1, "lane": 19})
	check(int(ch2["hp"]) == 6 and kw.creature_at(1, 19) != null, "provocation : l'attaque est redirigée sur le Chevalier")
	# régénération : +2 PV au début du tour de son camp
	var mo: Dictionary = kw.place_unit(0, "m_moine", 0, 3)      # case 12, hp 5 max
	mo["hp"] = 2
	kw.end_turn(0)
	kw.end_turn(1)
	check(int(mo["hp"]) == 4, "régénération : +2 PV au début du tour (2 -> 4)")
	# initiative : jamais de riposte
	var iw = DD.new()
	iw.setup(["m_gobelin"], ["m_gobelin"], 78)
	iw.terrain = []
	for i in JccDuel.LANES:
		iw.terrain.append("")
	var sa2: Dictionary = iw.place_unit(0, "c_samourai", 1, 5)  # case 21, atq 3, initiative
	sa2["hp"] = 2
	var tr2: Dictionary = iw.place_unit(1, "m_troll", 1, 4)     # case 17, atq 4 hp 6
	check(iw.attack(0, 21, {"side": 1, "lane": 17}), "le Samouraï attaque le Troll")
	check(iw.creature_at(0, 21) != null and int(sa2["hp"]) == 2 and int(tr2["hp"]) == 3, "initiative : aucune riposte (PV attaquant inchangés, Troll 6 -> 3)")
	var gb2: Dictionary = iw.place_unit(0, "m_gobelin", 0, 5)   # case 20, atq 2 hp 1
	iw.place_unit(1, "m_troll", 0, 4)                           # case 16, atk 4 hp 6
	check(iw.attack(0, 20, {"side": 1, "lane": 16}), "le Gobelin attaque le Troll")
	check(iw.creature_at(0, 20) == null, "sans initiative : la riposte tue le Gobelin (1 PV)")
	print("Terrain / pouvoir de héros / mulligan :")
	var tg = DD.new()
	tg.setup(["m_gobelin"], ["m_gobelin"], 42, ["Mage", "boss"])
	var nt: int = 0
	var has_boue := false
	var has_haut := false
	var has_buis := false
	for i in JccDuel.LANES:
		var tt: String = tg.terrain_at(i)
		if tt != "":
			nt += 1
			if tt == "boue": has_boue = true
			if tt == "hauteur": has_haut = true
			if tt == "buisson": has_buis = true
	check(nt == JccDuel.TERRAIN_COUNT and has_boue and has_haut and has_buis, "terrain : 6 cases, 2 de chaque type (seed 42)")
	var tg2 = DD.new()
	tg2.setup(["m_gobelin"], ["m_gobelin"], 42)
	var same := true
	for i in JccDuel.LANES:
		if tg2.terrain_at(i) != tg.terrain_at(i):
			same = false
	check(same, "terrain déterministe pour une même seed")
	# terrain contrôlé : boue en 17 (1,4), hauteur en 9 (1,2), buisson en 12 (0,3) et 10 (2,2)
	tg.terrain = []
	for i in JccDuel.LANES:
		tg.terrain.append("")
	tg.terrain[17] = "boue"
	tg.terrain[9] = "hauteur"
	tg.terrain[12] = "buisson"
	tg.terrain[10] = "buisson"
	tg.place_unit(0, "m_gobelin", 1, 5)   # case 21
	check(tg._path_cost(21, 17) == 2, "boue : entrer coûte 2 PM (au lieu de 1)")
	check(tg._path_cost(21, 22) == 1, "case normale voisine : 1 PM")
	tg.place_unit(0, "m_gobelin", 0, 2)    # case 8, PO 1, terrain normal
	tg.place_unit(1, "m_troll", 2, 2)      # case 10 = buisson, distance 2
	tg.place_unit(1, "m_loup", 0, 3)       # case 12 = buisson, distance 1
	var at8: Array = tg.attack_targets(0, 8)
	var hasb10 := false
	var hasb12 := false
	for e in at8:
		if int((e as Dictionary)["lane"]) == 10: hasb10 = true
		if int((e as Dictionary)["lane"]) == 12: hasb12 = true
	check(not hasb10 and hasb12, "buisson : camouflage à distance 2, mais corps à corps (distance 1) OK")
	tg.place_unit(0, "m_gobelin", 1, 2)    # case 9 = hauteur, PO 1 -> 2
	tg.place_unit(1, "m_loup", 3, 2)       # case 11, distance 2 de la case 9
	var at9: Array = tg.attack_targets(0, 9)
	var hash11 := false
	for e in at9:
		if int((e as Dictionary)["lane"]) == 11: hash11 = true
	check(hash11, "hauteur : +1 PO, une cible à distance 2 est à portée")
	# pouvoir du héros : Mage = 4 dégâts au héros adverse, 1 fois par duel
	check(tg.can_use_hero_power(0), "pouvoir dispo au début")
	check(tg.use_hero_power(0) and tg.side(1)["hero_hp"] == 26, "pouvoir Mage : héros adverse 30 -> 26")
	check(not tg.can_use_hero_power(0) and not tg.use_hero_power(0), "pouvoir utilisé 1 seule fois")
	check(String(DD.power_for("Géomancien")["effet"]) == "degats_zone" and String(DD.power_for("boss")["valeur"]) == "5", "power_for : classe et boss")
	# mulligan : main repiochee, 1 fois, 20 cartes conservées
	var mg = DD.new()
	mg.setup(["m_gobelin", "m_loup", "m_troll", "s_etincelle", "s_soin", "s_eclair", "m_gobelin", "m_loup", "m_troll", "s_javelot"], ["m_loup", "m_gobelin", "m_troll", "s_javelot", "s_etincelle", "s_soin", "m_loup", "m_gobelin", "m_troll", "s_eclair"], 5)
	check(mg.can_mulligan(0) and mg.side(0)["hand"].size() == 4, "mulligan dispo, main de 4")
	check(mg.mulligan(0) and mg.side(0)["hand"].size() == 4 and (mg.side(0)["deck"] as Array).size() == 6, "mulligan : nouvelle main de 4, pioche 10 -> 6")
	check(not mg.can_mulligan(0) and not mg.mulligan(0), "mulligan utilisé 1 seule fois")
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
		var sim = DD.new()
		var op0: Dictionary = CO.opponent(seed_i % 6)
		var op1: Dictionary = CO.opponent((seed_i + 3) % 6)
		sim.setup(CO.parse_deck(String(op0["deck"])), CO.parse_deck(String(op1["deck"])), 100 + seed_i)
		var guard: int = 0
		while not sim.is_over() and guard < 400:
			guard += 1
			var who: int = sim.current
			var steps: int = 0
			while steps < 40:
				steps += 1
				var act: Dictionary = sim.ai_step(who)
				if String(act["type"]) == "end":
					break
			if not sim.is_over():
				sim.end_turn(who)
		maxturns = maxi(maxturns, sim.turn)
		wins[sim.winner if sim.winner >= 0 else 2] += 1 if sim.winner >= 0 else 0
		if not sim.is_over():
			print("   partie non terminée seed ", seed_i, " tour ", sim.turn)
			wins[2] += 1
	check(wins[2] == 0, "24 parties IA/IA toutes terminées (max %d tours)" % maxturns)
	check(wins[0] >= 4 and wins[1] >= 4, "pas de camp écrasant : %d / %d" % [wins[0], wins[1]])
	print("FIN : %d échec(s)" % fails)
	quit(fails)
