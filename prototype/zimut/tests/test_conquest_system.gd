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
	check(ConquestSystem.city_level(d["conquest"], "clairiere") == 3, "Cité (niveau 3)")
	d["gold"] = int(d["gold"]) + 5000
	d["resources"] = {"Bois": 500, "Fer": 500, "Cuir": 500, "Magie": 500, "Venin": 500}
	check(pm.conquest_upgrade_city(d, "clairiere") == "", "évolution en Grande Cité (V61)")
	check(pm.conquest_upgrade_city(d, "clairiere") == "", "évolution en Métropole (V61)")
	check(ConquestSystem.level_name(ConquestSystem.city_level(d["conquest"], "clairiere")) == "Métropole", "niveau 5 : Métropole")
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

	# ── V59 Chancelier : audience récurrente tous les 5 batailles (2 villes min) ──
	var ch: Dictionary = _fresh(["capitale", "clairiere", "pont_mousse"])
	ConquestSystem.after_victory(ch, ch["conquest"], rng, pm.CONQUEST_ROUTES, names, "")
	check(ConquestSystem.pending_event(ch["conquest"]).is_empty(), "chancelier : rien avant 5 batailles")
	var ch_ev: Dictionary = {}
	for i: int in range(10):
		var r5 := RandomNumberGenerator.new()
		r5.seed = 700 + i
		ConquestSystem.after_victory(ch, ch["conquest"], r5, pm.CONQUEST_ROUTES, names, "")
		var pend: Dictionary = ConquestSystem.pending_event(ch["conquest"])
		if String(pend.get("id", "")) == "chancelier":
			ch_ev = pend
			break
		ch["conquest"].erase("event_pending")
	check(not ch_ev.is_empty() and String(ch_ev.get("id", "")) == "chancelier", "audience du Chancelier proposée à temps")
	check(int(ch["conquest"].get("chancellor_seen", 0)) == 1, "le compteur d'audiences est tenu")
	check((ch_ev.get("options", []) as Array).size() == 4, "trois édits proposés + congédier le Chancelier")
	# Impôt : or versé, un soldat par garnison
	pm.conquest_recruit(ch, "clairiere", 2)
	var g0: int = int(ch["gold"])
	var t0: int = ConquestSystem.troops(ch["conquest"], "clairiere")
	var expected: int = 0
	for cid: String in ch["conquest"]["owned"]:
		expected += ConquestSystem.city_income(ch, cid)
	var out_ch: String = pm.conquest_resolve_event(ch, "impot")
	check(out_ch != "", "impôt résolu")
	check(ConquestSystem.troops(ch["conquest"], "clairiere") == t0 - 1, "impôt : la garnison perd 1 soldat")
	check(int(ch["gold"]) == g0 + expected, "impôt : or crédité (%d attendus)" % expected)
	# Manœuvres : +2 défense pendant 3 batailles
	ch["conquest"]["event_pending"] = ch_ev.duplicate(true)
	pm.conquest_resolve_event(ch, "manoeuvres")
	var def_drill: int = ConquestSystem.drill_defense(ch["conquest"])
	check(def_drill == 2 and int(ch["conquest"].get("drill", 0)) == 3, "manœuvres : +2 défense pendant 3 batailles")
	var r6 := RandomNumberGenerator.new()
	r6.seed = 900
	ConquestSystem.after_victory(ch, ch["conquest"], r6, pm.CONQUEST_ROUTES, names, "")
	check(int(ch["conquest"].get("drill", 0)) == 2, "le buff manœuvres décrémente à chaque victoire")
	# Routes : +2 Bois +1 Cuir par victoire pendant 4 batailles
	ch["conquest"]["event_pending"] = ch_ev.duplicate(true)
	pm.conquest_resolve_event(ch, "routes")
	check(ConquestSystem.roadworks_yield(ch["conquest"]) == {"Bois": 2, "Cuir": 1}, "routes : production temporaire active")
	ConquestSystem.after_victory(ch, ch["conquest"], r6, pm.CONQUEST_ROUTES, names, "")
	check(int(ch["conquest"].get("roadworks", 0)) == 3, "routes : décrément après victoire")
	# Inactif avec une seule ville (la capitale seule ne compte pas)
	var ch1: Dictionary = _fresh(["capitale", "clairiere"])
	var chancellor_seen1: bool = false
	for i: int in range(10):
		var r7 := RandomNumberGenerator.new()
		r7.seed = 1100 + i
		ConquestSystem.after_victory(ch1, ch1["conquest"], r7, pm.CONQUEST_ROUTES, names, "")
		if String(ConquestSystem.pending_event(ch1["conquest"]).get("id", "")) == "chancelier":
			chancellor_seen1 = true
			ch1["conquest"].erase("event_pending")
	check(not chancellor_seen1, "chancelier : aucune audience avec une seule ville conquise")
	
	# ── V59 Spécialités économiques par ville/biome ──
	var sp: Dictionary = _fresh(["capitale", "clairiere", "mine_cristal"])
	sp["conquest"].erase("event_pending")
	var tr_cl: Dictionary = ConquestSystem.city_trait_yield(sp["conquest"], "clairiere")
	check(tr_cl.get("Bois", 0) == 2, "spécialité Clairière : +2 Bois au niveau 1")
	var tr_mc: Dictionary = ConquestSystem.city_trait_yield(sp["conquest"], "mine_cristal")
	check(tr_mc.get("Magie", 0) == 3, "spécialité Mine de Cristal : +3 Magie")
	pm.conquest_upgrade_city(sp, "clairiere")
	check(ConquestSystem.city_trait_yield(sp["conquest"], "clairiere").get("Bois", 0) == 3, "spécialité mise à l'échelle : Bourg = +3 Bois")
	var tot: Dictionary = ConquestSystem.trait_yield(sp["conquest"])
	check(int(tot.get("Bois", 0)) == 3 and int(tot.get("Magie", 0)) == 3, "production totale des spécialités")
	check(String(ConquestSystem.city_trait_text("mine_cristal")) == "Filon de cristal", "label de spécialité")
	sp["conquest"]["ravage"] = {"mine_cristal": 2}
	check(ConquestSystem.city_trait_yield(sp["conquest"], "mine_cristal").is_empty(), "ville pillée : spécialité gelée")
	var empire: Dictionary = pm.conquest_empire_yield(sp["conquest"])
	check(int(empire.get("Magie", 0)) == 0, "ville pillée : la spécialité n'entre pas dans la production d'empire")

	# ── V59 Lieutenance : missions des héros libres ──
	var mi: Dictionary = _fresh(["capitale", "clairiere"])
	var mcq: Dictionary = mi["conquest"]
	check(ConquestSystem.missions(mcq).is_empty(), "aucune mission au départ")
	check(pm.conquest_send_mission(mi, "Assassin", "caravane") == "", "envoi d'un héros libre en mission")
	check(ConquestSystem.hero_on_mission(mcq, "Assassin").get("eta", 0) == ConquestSystem.MISSION_BATTLES, "mission de 3 batailles")
	check(pm.conquest_send_mission(mi, "Assassin", "filon") != "", "un héros ne part pas deux fois")
	pm.conquest_assign_hero(mi, "clairiere", "Tank")
	check(pm.conquest_send_mission(mi, "Tank", "caravane") != "", "un gouverneur ne part pas en mission")
	check(pm.conquest_busy_heroes(mi).has("Assassin") and pm.conquest_busy_heroes(mi).has("Tank"), "gouverneurs et lieutenants indisponibles pour les assauts")
	check(pm.conquest_send_mission(mi, "Mage", "inconnu") != "", "mission inconnue refusée")
	# Décompte : la mission avance d'une bataille par victoire
	var mr := RandomNumberGenerator.new()
	mr.seed = 42
	ConquestSystem.after_victory(mi, mcq, mr, pm.CONQUEST_ROUTES, names, "", ["vieille_tour", "fort_racine"])
	check(int(ConquestSystem.hero_on_mission(mi["conquest"], "Assassin").get("eta", -1)) == ConquestSystem.MISSION_BATTLES - 1, "la mission avance d'une bataille")
	# Retour bredouille possible : on boucle jusqu'au retour
	var news_assassin: bool = false
	var guard: int = 0
	while ConquestSystem.hero_on_mission(mi["conquest"], "Assassin") != {} and guard < 10:
		guard += 1
		ConquestSystem.after_victory(mi, mi["conquest"], mr, pm.CONQUEST_ROUTES, names, "", [])
		mi["conquest"].erase("event_pending")
	news_assassin = true
	check(news_assassin and guard < 10, "la mission se termine en 3 batailles")
	check(ConquestSystem.missions(mi["conquest"]).is_empty(), "le héros est de retour")
	var any_flag: bool = false
	for n: String in mi["conquest"].get("events", []):
		if n.begins_with("⚑"):
			any_flag = true
	check(any_flag, "le retour de mission est journalisé")
	# Cartographie : révélation de villes (déterministe : on force le succès)
	var mc: Dictionary = _fresh(["capitale", "clairiere"])
	mc["conquest"]["missions"] = {"Mage": {"type": "carte", "eta": 1}}
	var mcr := RandomNumberGenerator.new()
	mcr.seed = 7
	var tries: int = 0
	var revealed_ids: Array = []
	while revealed_ids.is_empty() and tries < 50:
		tries += 1
		mc["conquest"]["missions"] = {"Mage": {"type": "carte", "eta": 1}}
		ConquestSystem.after_victory(mc, mc["conquest"], mcr, pm.CONQUEST_ROUTES, names, "", ["vieille_tour", "fort_racine", "pont_mousse"])
		revealed_ids = mc["conquest"].get("missions_revealed", [])
	check(revealed_ids.size() == 2, "cartographie : 2 villes révélées")
	check(revealed_ids.has("vieille_tour") and revealed_ids.has("fort_racine"), "les bonnes villes sont révélées")
	# Rappel anticipé
	pm.conquest_send_mission(mc, "Chasseur", "filon")
	check(pm.conquest_abort_mission(mc, "Chasseur") == "" and ConquestSystem.missions(mc["conquest"]).is_empty(), "rappel du lieutenant")

	# ── V59 Généraux du Roi Squelette ──
	var ge: Dictionary = _fresh(["capitale"])
	var gcq: Dictionary = ge["conquest"]
	check(ConquestSystem.living_generals_count(gcq) == 4, "quatre généraux en vie au départ")
	check(ConquestSystem.general_of(gcq, "fort_racine") == "Tharok le Végétal", "Tharok tient Fort Racine")
	check(ConquestSystem.general_of(gcq, "garnison") == "Vorkann le Givre", "Vorkann tient la Garnison des Pics")
	check(ConquestSystem.general_defense_bonus(gcq, "fort_racine") == ConquestSystem.GENERAL_DEF_BONUS, "bonus de défense du siège tant que le général vit")
	# La forteresse tombe : le général est vaincu, le bonus disparaît
	gcq["owned"].append("fort_racine")
	check(ConquestSystem.general_of(gcq, "fort_racine") == "", "forteresse annexée : le général est vaincu")
	check(ConquestSystem.living_generals_count(gcq) == 3, "trois généraux restants")
	check(ConquestSystem.general_defense_bonus(gcq, "fort_racine") == 0, "plus de bonus après la chute")
	# Tous vaincus
	gcq["owned"].append("garnison")
	gcq["owned"].append("tour_sable")
	gcq["owned"].append("citadelle_ronce")
	check(ConquestSystem.living_generals_count(gcq) == 0, "tous les généraux sont tombés")
	# Offensives nommées : elles portent le nom d'un général vivant
	var go: Dictionary = _fresh(["capitale", "clairiere", "pont_mousse", "vieille_tour"])
	var gr := RandomNumberGenerator.new()
	gr.seed = 33
	var named_threat: bool = false
	guard = 0
	while not named_threat and guard < 200:
		guard += 1
		ConquestSystem.after_victory(go, go["conquest"], gr, pm.CONQUEST_ROUTES, names, "")
		var th: Dictionary = ConquestSystem.threat(go["conquest"])
		if not th.is_empty() and String(th.get("general", "")) != "":
			named_threat = true
		go["conquest"].erase("event_pending")
		go["conquest"].erase("threat")
	check(named_threat, "un général vivant peut lancer une offensive nommée")
	# Ville neutre : pas de général
	check(ConquestSystem.general_of(gcq, "clairiere") == "", "une ville neutre n'a pas de général")

	# ── V59 Plans d'assaut : blocus et infiltration ──
	var pl: Dictionary = _fresh(["capitale", "clairiere", "pont_mousse"])
	var plcq: Dictionary = pl["conquest"]
	plcq["sieges"] = {"vieille_tour": 1}
	pl["conquest"] = plcq
	check(ConquestSystem.plan_cost("blocus") == 40 and ConquestSystem.plan_cost("infiltration") == 50, "coûts des plans")
	check(ConquestSystem.infiltration_ready(plcq), "Assassin libre au départ")
	pm.conquest_assign_hero(pl, "clairiere", "Assassin")
	check(not ConquestSystem.infiltration_ready(pl["conquest"]), "Assassin gouverneur : infiltration impossible")
	pm.conquest_recall_hero(pl, "clairiere")
	# Blocus : or débité, siège avancé d'une vague (sans combat)
	var g0b: int = int(pl["gold"])
	var outb: Dictionary = ConquestSystem.apply_plan(pl, pl["conquest"], "vieille_tour", "blocus", rng)
	check(String(outb.get("error", "")) == "" and bool(outb.get("skipped", false)), "blocus accepté")
	check(int(pl["gold"]) == g0b - 40, "blocus : 40 or débités")
	# Infiltration : Assassin parti 1 bataille, mission spéciale
	var outi: Dictionary = ConquestSystem.apply_plan(pl, pl["conquest"], "vieille_tour", "infiltration", rng)
	check(String(outi.get("error", "")) == "" and bool(outi.get("skipped", false)), "infiltration acceptée")
	check(ConquestSystem.hero_on_mission(pl["conquest"], "Assassin").get("type", "") == "infiltration", "l'Assassin est en mission d'infiltration")
	check(not ConquestSystem.infiltration_ready(pl["conquest"]), "Assassin en mission : pas deux infiltrations")
	# Retour de l'Assassin après 1 victoire
	var pr := RandomNumberGenerator.new()
	pr.seed = 21
	ConquestSystem.after_victory(pl, pl["conquest"], pr, pm.CONQUEST_ROUTES, names, "", [])
	check(ConquestSystem.missions(pl["conquest"]).is_empty(), "l'Assassin revient après 1 victoire")
	# Or insuffisant
	pl["gold"] = 10
	check(String(ConquestSystem.apply_plan(pl, pl["conquest"], "fort_racine", "blocus", rng).get("error", "")).begins_with("Or insuffisant"), "blocus refusé sans or")
	# Plan inconnu
	check(String(ConquestSystem.apply_plan(pl, pl["conquest"], "fort_racine", "zigzag", rng).get("error", "")) != "", "plan inconnu refusé")
	# Progression complète du siège via ProgressionManager (annexion sans combat)
	var pv: Dictionary = _fresh(["capitale", "clairiere", "pont_mousse"])
	pv["conquest"]["sieges"] = {"vieille_tour": 3}
	check(pm.conquest_apply_plan(pv, "vieille_tour", "blocus") == "", "blocus final : annexion sans combat")
	check((pv["conquest"]["owned"] as Array).has("vieille_tour"), "ville annexée par le blocus")
	check(String(pv["conquest"].get("pending_city", "")) == "", "plus de cible en attente après l'annexion par plan")

	# ── V59 Reconquête ennemie : garnisons croissantes ──
	var rg: Dictionary = _fresh(["capitale", "clairiere"])
	var rgcq: Dictionary = rg["conquest"]
	check(ConquestSystem.enemy_garrison(rgcq, "fort_racine") == 0, "aucune garnison adverse au départ")
	rgcq["battle_count"] = 2
	check(ConquestSystem.enemy_garrison(rgcq, "fort_racine") == 0, "2 victoires : pas encore de renfort")
	rgcq["battle_count"] = 3
	check(ConquestSystem.enemy_garrison(rgcq, "fort_racine") == 1, "3 victoires : +1 soldat adverse")
	rgcq["battle_count"] = 30
	check(ConquestSystem.enemy_garrison(rgcq, "fort_racine") == 6, "garnison adverse plafonnée à 6")
	check(ConquestSystem.enemy_garrison_bonus(rgcq, "fort_racine") == 3, "bonus de niveau : +3")
	check(ConquestSystem.enemy_garrison(rgcq, "clairiere") == 0, "ville possédée : pas de garnison adverse")

	# ── V59 Diplomatie : annexion négociée des villes neutres ──
	var dp: Dictionary = _fresh(["capitale", "clairiere"])
	var dpcq: Dictionary = dp["conquest"]
	# clairiere est reliée à la capitale
	check(pm.conquest_negotiate_city(dp, "clairiere") != "", "ville déjà conquise : négociation refusée")
	check(pm.conquest_negotiate_city(dp, "oasis") != "", "ville non reliée : négociation refusée")
	var dgold0: int = int(dp["gold"])
	var dcost: Dictionary = pm.conquest_diplomacy_cost(dpcq, "pont_mousse")
	var dkey: String = String((dcost["res"] as Dictionary).keys()[0])     # ressource de la spécialité de la ville
	var dres0: int = int(dp["resources"].get(dkey, 0))
	check(pm.conquest_negotiate_city(dp, "pont_mousse") == "", "pont-mousse annexé par négociation")
	check((dpcq["owned"] as Array).has("pont_mousse"), "la ville rejoint l'empire")
	check(int(dp["gold"]) == dgold0 - int(dcost["gold"]), "négociation : %d or débités (selon le niveau)" % int(dcost["gold"]))
	check(int(dcost["gold"]) > 120 and int(pm.conquest_diplomacy_cost(dpcq, "oasis")["gold"]) > int(dcost["gold"]), "le prix grimpe avec le niveau de la ville")
	check(pm.conquest_negotiate_city(dp, "vieille_tour") != "", "forteresse ennemie : négociation refusée")
	check(ConquestSystem.diplomacy_cooldown(dpcq) == 3, "délai de 3 victoires avant une autre négociation")
	check(int(dp["resources"].get(dkey, 0)) == dres0 - int(dcost["res"][dkey]), "négociation : %d %s débités (spécialité de la ville)" % [int(dcost["res"][dkey]), dkey])
	check((dpcq.get("annexed_diplomacy", []) as Array).has("pont_mousse"), "annexion pacifique comptée pour la Légende")
	# Or insuffisant (ville reliée à l'empire)
	dp["gold"] = 50
	dpcq["diplo_cd"] = 0
	check(ConquestSystem.negotiate_city(dp, dpcq, "vieille_tour", pm.CONQUEST_ROUTES, {}).begins_with("Or insuffisant"), "or insuffisant : négociation refusée")

	# ── V59 Ruine & reconstruction ──
	var ru: Dictionary = _fresh(["capitale", "clairiere"])
	var rucq: Dictionary = ru["conquest"]
	rucq["city_levels"] = {"clairiere": 3}
	ru["conquest"] = rucq
	check(not ConquestSystem.is_ruined(rucq, "clairiere"), "pas de ruine au départ")
	# La ville tombe (offensive ennemie)
	var out_ru: String = ConquestSystem.resolve_assault(ru, rucq, "clairiere", 999)
	check(out_ru == "lost" and not (rucq["owned"] as Array).has("clairiere"), "ville perdue")
	check(ConquestSystem.is_ruined(rucq, "clairiere"), "la ville est marquée ruinée")
	check(int(rucq["city_levels"]["clairiere"]) == 2, "la chute coûte un niveau")
	# Reprise : la ruine persiste, la production est gelée
	rucq["owned"].append("clairiere")
	check(int(ConquestSystem.city_income(ru, "clairiere")) == 0, "ville ruinée : revenu gelé")
	check(ConquestSystem.city_trait_yield(rucq, "clairiere").is_empty(), "ville ruinée : spécialité gelée")
	# La ruine décrémente à chaque victoire, puis disparaît
	var rr2 := RandomNumberGenerator.new()
	var tries2: int = 0
	while ConquestSystem.is_ruined(rucq, "clairiere") and tries2 < 10:
		tries2 += 1
		ConquestSystem.after_victory(ru, rucq, rr2, pm.CONQUEST_ROUTES, names, "", [])
		rucq.erase("event_pending")
	check(not ConquestSystem.is_ruined(rucq, "clairiere"), "la ruine s'estompe après quelques victoires")
	check(int(ConquestSystem.city_income(ru, "clairiere")) > 0, "production reprise après la ruine")
	# Réparation immédiate (payante)
	rucq["ruin"] = {"clairiere": 3}
	var rgold0: int = int(ru["gold"])
	check(pm.conquest_repair_city(ru, "clairiere") == "" and not ConquestSystem.is_ruined(rucq, "clairiere"), "réparation payée : ruine levée")
	check(int(ru["gold"]) == rgold0 - 80, "réparation : 80 or débités")
	ru["gold"] = 10
	rucq["ruin"] = {"clairiere": 2}
	check(pm.conquest_repair_city(ru, "clairiere").begins_with("Or insuffisant"), "réparation refusée sans or")

	# ── V59 Légende : score et fins multiples ──
	var lg2: Dictionary = _fresh(["capitale", "clairiere", "pont_mousse", "fort_racine", "vieille_tour"])
	var lgcq: Dictionary = lg2["conquest"]
	var score: Dictionary = ConquestSystem.legend_score(lgcq, 2)
	check(int(score["villes"]) == 40, "score villes : 4 villes × 10")
	check(int(score["pierres"]) == 60, "score pierres : 2 × 30")
	check(int(score["diplomatie"]) == 0, "pas d'annexion pacifique : 0")
	var total: int = ConquestSystem.legend_total(score)
	check(total == int(score["villes"]) + int(score["niveaux"]) + int(score["gouverneurs"]) + int(score["pierres"]) + int(score["diplomatie"]) + int(score["ruines"]), "total = somme des composantes")
	# Fin « héros » par défaut
	var end1: Dictionary = ConquestSystem.legend_ending(score, lgcq)
	check(String(end1["id"]) == "heros", "fin par défaut : Âge des Héros")
	# Fin « marchand » : 4+ annexions pacifiques
	var annexed: Array = lgcq.get("annexed_diplomacy", [])
	for i: int in range(4):
		annexed.append("v%d" % i)
	lgcq["annexed_diplomacy"] = annexed
	var end2: Dictionary = ConquestSystem.legend_ending(score, lgcq)
	check(String(end2["id"]) == "marchand", "fin marchand après 4 annexions pacifiques")
	# Fin « bastion » : développement + gouverneurs
	var lg3: Dictionary = _fresh(["capitale", "clairiere", "pont_mousse", "fort_racine", "vieille_tour"])
	var lg3cq: Dictionary = lg3["conquest"]
	lg3cq["city_levels"] = {"clairiere": 3, "pont_mousse": 3, "fort_racine": 3, "vieille_tour": 3}
	for c: String in ["Tank", "Mage", "Heal"]:
		var cid: String = {"Tank": "clairiere", "Mage": "pont_mousse", "Heal": "fort_racine"}[c]
		pm.conquest_assign_hero(lg3, cid, c)
	var score3: Dictionary = ConquestSystem.legend_score(lg3cq, 0)
	check(int(score3["niveaux"]) >= 40 and int(score3["gouverneurs"]) >= 12, "bastion : développement (%d) et gouverneurs (%d) suffisants" % [int(score3["niveaux"]), int(score3["gouverneurs"])])
	var end3: Dictionary = ConquestSystem.legend_ending(score3, lg3cq)
	check(String(end3["id"]) == "bastion", "fin bastion : villes développées et gouverneurs nombreux")
	# Épilogue contient le score et le titre
	var epi: String = ConquestSystem.epilogue(score3, end3)
	check(epi.contains(String(end3["title"])) and epi.contains("points de Légende"), "épilogue : titre et score présents")

	# Sauvegarde / rechargement JSON
	var js: String = JSON.stringify(lg)
	var back: Variant = JSON.parse_string(js)
	check(back is Dictionary and ConquestSystem.city_level(back["conquest"], "clairiere") >= 1, "l'état de campagne survit à la sérialisation JSON")


	# ── V61 : bâtiments à niveaux, emplacements, Merveilles ──
	var bv: Dictionary = _fresh(["capitale", "clairiere"])
	bv["gold"] = 20000
	bv["resources"] = {"Bois": 999, "Fer": 999, "Cuir": 999, "Magie": 999, "Venin": 999}
	check(ConquestSystem.building_slots(bv["conquest"], "clairiere") == 3, "Hameau : 3 emplacements")
	for bk: String in ["scierie", "mine", "tannerie"]:
		check(pm.conquest_build(bv, "clairiere", bk) == "", "construction %s" % bk)
	check(pm.conquest_build(bv, "clairiere", "verger") != "", "4e bâtiment refusé au Hameau (emplacements pleins)")
	check(pm.conquest_upgrade_building(bv, "clairiere", "scierie") != "", "Hameau : bâtiments limités au niveau 1")
	var y1: int = int(pm.conquest_city_building_yield(bv["conquest"], "clairiere").get("Bois", 0))
	pm.conquest_upgrade_city(bv, "clairiere")
	check(pm.conquest_build(bv, "clairiere", "verger") == "", "Bourg : 4e emplacement")
	var bg0: int = int(bv["gold"])
	check(pm.conquest_upgrade_building(bv, "clairiere", "scierie") == "", "Bourg : scierie niveau 2")
	check(int(bv["gold"]) == bg0 - 80, "coût du niveau 2 = 2 × le coût de construction (80 or)")
	var y2: int = int(pm.conquest_city_building_yield(bv["conquest"], "clairiere").get("Bois", 0))
	check(y2 > y1, "la scierie niveau 2 produit davantage (%d → %d)" % [y1, y2])
	check(pm.conquest_upgrade_building(bv, "clairiere", "scierie") != "", "Bourg : niveau 3 refusé")
	check(pm.conquest_build_wonder(bv, "clairiere") != "", "Merveille refusée avant la Cité")
	pm.conquest_upgrade_city(bv, "clairiere")
	var inc0: int = ConquestSystem.city_income(bv, "clairiere")
	var def0: int = ConquestSystem.defense(bv, "clairiere")
	check(pm.conquest_build_wonder(bv, "clairiere") == "", "Cité : Merveille de la Nation bâtie")
	check(pm.conquest_build_wonder(bv, "clairiere") != "", "une seule Merveille par ville")
	check(ConquestSystem.city_income(bv, "clairiere") > inc0 and ConquestSystem.defense(bv, "clairiere") > def0, "la Merveille ajoute or et défense")
	check(int(pm.conquest_empire_yield(bv["conquest"]).get("Bois", 0)) >= 4, "l'Arbre-Ancêtre produit du Bois")
	check(pm.conquest_build(bv, "clairiere", "muraille") == "", "muraille construite")
	var dw1: int = ConquestSystem.defense(bv, "clairiere")
	check(pm.conquest_upgrade_building(bv, "clairiere", "muraille") == "" and ConquestSystem.defense(bv, "clairiere") == dw1 + 4, "muraille niveau 2 : +4 défense")
	print("== %s ==" % ("TOUT OK" if fails == 0 else "%d échec(s)" % fails))
	quit(1 if fails > 0 else 0)
