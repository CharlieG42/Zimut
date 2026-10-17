extends SceneTree

## Tests V14 de la Conquête : niveaux de ville, garnisons, héros gouverneurs,
## offensives annoncées, raids contrés et événements.

var fails: int = 0

func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1

func _init() -> void:
	_boot.call_deferred()

func _fresh(owned: Array) -> Dictionary:
	var pm: Node = root.get_node("ProgressionManager")
	var d: Dictionary = pm.new_game(3, "CS")
	d["campaign_mode"] = "conquest"
	d["gold"] = 1000
	d["resources"] = {"Bois": 50, "Fer": 50, "Cuir": 50, "Magie": 50, "Venin": 50}
	d["conquest"] = {"owned": owned, "pending_city": ""}
	return d

func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	var names: Dictionary = {"clairiere": "Clairière", "pont_mousse": "Pont-Mousse", "fort_racine": "Fort Racine"}

	# ── Niveaux de ville ──
	var d: Dictionary = _fresh(["capitale", "clairiere"])
	var cq: Dictionary = d["conquest"]
	check(ConquestSystem.city_level(cq, "clairiere") == 1, "niveau initial 1")
	check(ConquestSystem.garrison_cap(cq, "clairiere") == 4, "garnison max niveau 1 = 4")
	check(pm.conquest_upgrade_city(d, "clairiere") == "", "amélioration en Bourg acceptée")
	check(int(d["gold"]) == 880 and int(d["resources"]["Bois"]) == 40, "coût d'amélioration débité (120 or, 10 Bois, 10 Fer)")
	check(ConquestSystem.garrison_cap(d["conquest"], "clairiere") == 6, "garnison max niveau 2 = 6")
	check(pm.conquest_upgrade_city(d, "clairiere") == "", "amélioration en Cité acceptée")
	check(pm.conquest_upgrade_city(d, "clairiere") != "", "niveau max : amélioration refusée")
	check(pm.conquest_upgrade_city(d, "fort_racine") != "", "ville non conquise refusée")
	var poor: Dictionary = _fresh(["capitale", "clairiere"])
	poor["gold"] = 50
	check(pm.conquest_upgrade_city(poor, "clairiere") != "" and int(poor["gold"]) == 50, "or insuffisant : rien n'est débité")

	# ── Garnison ──
	var g: Dictionary = _fresh(["capitale", "clairiere"])
	check(pm.conquest_recruit(g, "clairiere", 3) == "", "recrutement de 3 soldats")
	check(ConquestSystem.troops(g["conquest"], "clairiere") == 3 and int(g["gold"]) == 910, "3 soldats = 90 or")
	check(pm.conquest_recruit(g, "clairiere", 5) == "" and ConquestSystem.troops(g["conquest"], "clairiere") == 4, "recrutement plafonné par la place (4)")
	check(pm.conquest_recruit(g, "clairiere", 1) != "", "garnison pleine : refus")
	check(ConquestSystem.defense(g, "clairiere") == 4 * 2 + 3, "défense = soldats×2 + niveau×3")

	# ── Héros gouverneur ──
	check(pm.conquest_assign_hero(g, "clairiere", "Tank") == "", "Tank nommé gouverneur")
	check(pm.conquest_assign_hero(g, "clairiere", "Mage") != "", "un seul gouverneur par ville")
	g["conquest"]["owned"].append("pont_mousse")
	check(pm.conquest_assign_hero(g, "pont_mousse", "Tank") != "", "un héros ne gouverne qu'une ville")
	check(pm.conquest_stationed_heroes(g) == ["Tank"], "héros en poste indisponibles pour l'équipe")
	check(ConquestSystem.defense(g, "clairiere") > 11 + 6, "le gouverneur renforce la défense")
	check(pm.conquest_recall_hero(g, "clairiere") == "" and pm.conquest_stationed_heroes(g).is_empty(), "rappel du héros")
	pm.conquest_assign_hero(g, "pont_mousse", "Mage")
	var y: Dictionary = pm.conquest_empire_yield(g["conquest"])
	check(int(y.get("Magie", 0)) >= 1, "gouverneur Mage : +1 Magie par bataille")
	check(ConquestSystem.city_income(g, "pont_mousse") > ConquestSystem.city_income(g, "clairiere") - 1, "revenu or du gouverneur")

	# ── Revenus : or par victoire ──
	var inc: Dictionary = _fresh(["capitale", "clairiere"])
	inc["conquest"]["pending_city"] = "clairiere"
	var gold0: int = int(inc["gold"])
	pm.register_victory(inc, {"enemies": [{"type": "Gobelin", "level": 10, "boss": false}]})
	check(int(inc["gold"]) > gold0 and int(inc["conquest"].get("last_income", 0)) > 0, "les villes versent de l'or à chaque victoire")

	# ── Raids : garnison suffisante = repoussé, sinon pillage ──
	var raid_hit: int = 0
	var raid_held: int = 0
	for trial: int in range(80):
		var r: Dictionary = _fresh(["capitale", "clairiere", "pont_mousse"])
		pm.conquest_recruit(r, "clairiere", 4)   # défense 11 ≥ 5
		r["conquest"]["pending_city"] = ""
		var rr := RandomNumberGenerator.new()
		rr.seed = trial
		ConquestSystem.after_victory(r, r["conquest"], rr, pm.CONQUEST_ROUTES, names, "pont_mousse")
		if String(r["conquest"].get("last_counterattack", "")) != "":
			raid_hit += 1
		for line: String in r["conquest"].get("news", []):
			if line.contains("Raid repoussé"):
				raid_held += 1
	check(raid_held > 0, "des raids sont repoussés par la garnison (%d)" % raid_held)
	check(raid_hit == 0, "une ville bien gardée n'est jamais pillée par un raid (%d)" % raid_hit)

	# ── Offensive annoncée : compte à rebours puis résolution ──
	var t: Dictionary = _fresh(["capitale", "clairiere"])
	var tc: Dictionary = t["conquest"]
	tc["threat"] = {"city": "clairiere", "power": 40, "eta": 2}
	var rt := RandomNumberGenerator.new()
	rt.seed = 3
	ConquestSystem.after_victory(t, tc, rt, pm.CONQUEST_ROUTES, names, "")
	check(int(t["conquest"]["threat"]["eta"]) == 1, "le compte à rebours de l'offensive diminue")
	ConquestSystem.after_victory(t, t["conquest"], rt, pm.CONQUEST_ROUTES, names, "")
	check(not (t["conquest"].get("owned", []) as Array).has("clairiere"), "ville sans défense : perdue face à une offensive")
	check((t["conquest"].get("lost", []) as Array).has("clairiere"), "ville perdue enregistrée")
	check(pm.conquest_city_battles("clairiere", t["conquest"]) == 1, "ville perdue : reprise en 1 bataille")

	var t2: Dictionary = _fresh(["capitale", "clairiere"])
	pm.conquest_recruit(t2, "clairiere", 4)
	pm.conquest_assign_hero(t2, "clairiere", "Tank")
	t2["conquest"]["buildings"] = {"clairiere": ["muraille"]}
	var gold_pre: int = int(t2["gold"])
	var res_t2: String = ConquestSystem.resolve_assault(t2, t2["conquest"], "clairiere", 25)
	check(res_t2 == "repelled", "ville garnie + héros + muraille : offensive repoussée")
	check(int(t2["gold"]) > gold_pre, "butin de victoire défensive")
	var t3: Dictionary = _fresh(["capitale", "clairiere"])
	pm.conquest_recruit(t3, "clairiere", 4)   # défense 11
	check(ConquestSystem.resolve_assault(t3, t3["conquest"], "clairiere", 16) == "breach", "défense à 60 % de la force : brèche (pillage)")
	check(pm.conquest_stationed_heroes(t3).is_empty(), "aucun héros fantôme")

	# ── Reprise d'une ville perdue : une bataille, pas de second butin ──
	var rt2: Dictionary = _fresh(["capitale"])
	rt2["conquest"]["lost"] = ["clairiere"]
	rt2["conquest"]["rewarded"] = ["clairiere"]
	rt2["conquest"]["pending_city"] = "clairiere"
	rt2["conquest"]["pending_level"] = 10
	var gold_r: int = int(rt2["gold"])
	pm.register_victory(rt2, {"enemies": [{"type": "Gobelin", "level": 10, "boss": false}]})
	check((rt2["conquest"]["owned"] as Array).has("clairiere"), "ville reprise en une bataille")
	check(not (rt2["conquest"].get("lost", []) as Array).has("clairiere"), "ville retirée de la liste des perdues")
	check(String(rt2["conquest"].get("last_city_reward", {}).get("city", "")) != "clairiere" and gold_r > 0, "pas de second butin d'annexion")

	# ── Événements : chaque événement se construit et se résout ──
	var evd: Dictionary = _fresh(["capitale", "clairiere", "pont_mousse", "fort_racine", "vieille_tour"])
	pm.conquest_assign_hero(evd, "clairiere", "Heal")
	var seen: Dictionary = {}
	for eid: String in ConquestSystem.EVENT_WEIGHTS.keys():
		var ev: Dictionary = ConquestSystem.make_event(eid, evd, evd["conquest"], rng)
		if ev.is_empty():
			continue
		seen[eid] = true
		if bool(ev.get("auto", false)):
			ConquestSystem._apply_auto(evd, evd["conquest"], ev)
			check(not (evd["conquest"].get("news", []) as Array).is_empty(), "événement auto « %s » : nouvelle publiée" % eid)
		else:
			check(ev["options"].size() >= 2, "événement « %s » : au moins 2 choix" % eid)
			var snap: Dictionary = evd.duplicate(true)
			for o: Dictionary in ev["options"]:
				var tt: Dictionary = snap.duplicate(true)
				tt["conquest"]["event_pending"] = ev.duplicate(true)
				var out: String = pm.conquest_resolve_event(tt, String(o["id"]))
				check(out != "" and ConquestSystem.pending_event(tt["conquest"]).is_empty(), "« %s → %s » résolu et effacé" % [eid, String(o["id"])])
	check(seen.size() >= 8, "au moins 8 types d'événements possibles (%d)" % seen.size())

	# Effets précis
	var ec: Dictionary = _fresh(["capitale", "clairiere"])
	ec["conquest"]["event_pending"] = {"id": "caravane", "title": "CARAVANE MARCHANDE", "city": "", "res": "Fer",
		"options": [{"id": "commerce", "gold": 50}, {"id": "taxe", "gold": 0}]}
	var fer0: int = int(ec["resources"]["Fer"])
	pm.conquest_resolve_event(ec, "commerce")
	check(int(ec["resources"]["Fer"]) == fer0 + 12 and int(ec["gold"]) == 950, "caravane : commerce = +12 Fer pour 50 or")
	ec["conquest"]["event_pending"] = {"id": "diplomatie", "title": "ÉMISSAIRE", "city": "", "options": [{"id": "tribut", "gold": 80}]}
	ec["gold"] = 10
	check(pm.conquest_resolve_event(ec, "tribut").begins_with("Or insuffisant") and not ConquestSystem.pending_event(ec["conquest"]).is_empty(), "or insuffisant : l'événement reste en attente")
	ec["gold"] = 200
	pm.conquest_resolve_event(ec, "tribut")
	check(int(ec["conquest"].get("truce", 0)) == 6, "tribut : 6 batailles de trêve")

	# Trêve : plus de raid ni d'offensive
	var tr: Dictionary = _fresh(["capitale", "clairiere", "pont_mousse", "fort_racine", "vieille_tour"])
	tr["conquest"]["truce"] = 50
	var any_trouble: bool = false
	for i: int in range(40):
		var r3 := RandomNumberGenerator.new()
		r3.seed = 100 + i
		ConquestSystem.after_victory(tr, tr["conquest"], r3, pm.CONQUEST_ROUTES, names, "")
		if String(tr["conquest"].get("last_counterattack", "")) != "" or not ConquestSystem.threat(tr["conquest"]).is_empty():
			any_trouble = true
	check(not any_trouble, "sous trêve : ni raid ni offensive")

	# Offensives générées naturellement sur une longue partie
	var spawned: bool = false
	var lg: Dictionary = _fresh(["capitale", "clairiere", "pont_mousse", "fort_racine", "vieille_tour"])
	for i: int in range(60):
		var r4 := RandomNumberGenerator.new()
		r4.seed = 500 + i
		pm._tick_ravage(lg["conquest"])
		ConquestSystem.after_victory(lg, lg["conquest"], r4, pm.CONQUEST_ROUTES, names, "")
		if not ConquestSystem.threat(lg["conquest"]).is_empty():
			spawned = true
			break
		lg["conquest"].erase("event_pending")
	check(spawned, "une offensive est annoncée au fil des batailles")

	# Sauvegarde / rechargement JSON
	var js: String = JSON.stringify(lg)
	var back: Variant = JSON.parse_string(js)
	check(back is Dictionary and ConquestSystem.city_level(back["conquest"], "clairiere") >= 1, "l'état de campagne survit à la sérialisation JSON")

	print("== %s ==" % ("TOUT OK" if fails == 0 else "%d échec(s)" % fails))
	quit(1 if fails > 0 else 0)
