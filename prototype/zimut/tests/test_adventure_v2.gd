extends SceneTree
## Tests Aventure V2 : terrain (obstacles, accessibilité), catalogue d'énigmes,
## réponses tolérantes, déplacement par chemin, énigmes de réflexion, événements de
## route, combats de campagne isolés du mode Tactique, défis optionnels de Conquête.
## Lancement : godot --headless --path . -s tests/test_adventure_v2.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	# ── Terrain et catalogue ──────────────────────────────────────────────
	for zone_id: String in pm.ADVENTURE_ZONES.keys():
		var t: Dictionary = AdventureTerrain.zone_terrain(zone_id)
		var size: Vector2i = t["size"]
		var bad: int = 0
		var unreachable: int = 0
		for k: String in pm.ADVENTURE_POIS[zone_id].keys():
			var p: Vector2i = AdventureTerrain.parse(k)
			if p.x < 0 or p.y < 0 or p.x >= size.x or p.y >= size.y or t["obstacles"].has(p) or t["voids"].has(p):
				bad += 1
			if p != t["start"] and AdventureTerrain.find_path(zone_id, t["start"], p).is_empty():
				unreachable += 1
			if String(pm.ADVENTURE_POIS[zone_id][k]["kind"]) == "puzzle":
				check(pm.ADVENTURE_PUZZLES.has("%s,%s" % [zone_id, k]), "%s %s : énigme au catalogue" % [zone_id, k])
		check(bad == 0 and not t["obstacles"].has(t["start"]), "%s : aucun obstacle sur départ ni lieux, lieux dans la grille" % zone_id)
		check(unreachable == 0, "%s : tous les lieux accessibles depuis le départ" % zone_id)
		check(t["obstacles"].size() >= 6, "%s : décor bloquant présent (%d obstacles)" % [zone_id, t["obstacles"].size()])
		AdventureTerrain._cache.clear()
		check(AdventureTerrain.zone_terrain(zone_id)["obstacles"] == t["obstacles"], "%s : terrain déterministe" % zone_id)
	for k: String in pm.ADVENTURE_PUZZLES.keys():
		var pz: Dictionary = pm.ADVENTURE_PUZZLES[k]
		if String(pz.get("type", "riddle")) == "riddle":
			check((pz["choices"] as Array).has(pz["answer"]), "%s : la bonne réponse figure dans les choix" % k)
	var fire: Dictionary = pm.ADVENTURE_PUZZLES["foret_sylve,4,1"]
	check(pm.adventure_answer_matches(fire, "feu") and pm.adventure_answer_matches(fire, "  LE FEU ! ") and pm.adventure_answer_matches(fire, "Le Feu"), "réponse tolérante (article, casse, ponctuation)")
	check(not pm.adventure_answer_matches(fire, "l'eau"), "mauvaise réponse refusée")
	check(pm.adventure_answer_matches(pm.ADVENTURE_PUZZLES["desert_dunes,6,1"], "piece de monnaie"), "réponse sans accent ni article")

	# ── AdventureManager ──────────────────────────────────────────────────
	var data: Dictionary = pm.new_game(3, "AdvV2")
	pm.rebuild_team(data, ["Tank", "Mage", "Sylvain"])
	data["campaign_mode"] = "adventure"
	gm.active_save = data
	gm.active_slot = 3
	var mgr: Node = Node.new()
	mgr.set_script(load("res://scripts/AdventureManager.gd"))
	root.add_child(mgr)
	await process_frame
	check(mgr.hero_class() == "Tank", "explorateur = première classe de l'équipe")
	var far := Vector2i(9, 3)
	check(mgr.path_to(far).is_empty(), "pas de chemin à travers le brouillard")
	var near_target := Vector2i(-1, -1)
	for y in range(7):
		for x in range(10):
			var c := Vector2i(x, y)
			if mgr.cell_discovered(c) and AdventureTerrain.walkable("foret_sylve", c) and absi(c.x - 1) + absi(c.y - 3) >= 2 and near_target.x < 0:
				near_target = c
	var path: Array = mgr.path_to(near_target)
	check(not path.is_empty() and path[path.size() - 1] == near_target, "chemin vers une case découverte (%d pas)" % path.size())
	var moves_before: int = mgr.moves()
	for step: Vector2i in path:
		mgr.move_hero(step)
	check(mgr.hero_pos() == near_target and mgr.moves() == moves_before + path.size(), "déplacement case par case le long du chemin")
	var obstacle: Vector2i = AdventureTerrain.zone_terrain("foret_sylve")["obstacles"].keys()[0]
	data["adventure"]["hero_pos"] = [obstacle.x + 1, obstacle.y] if obstacle.x < 9 else [obstacle.x - 1, obstacle.y]
	check(not mgr.can_move_to(obstacle), "un obstacle bloque le passage")
	var prog: Dictionary = mgr.zone_progress()
	check(int(prog["total"]) >= 5 and float(prog["fog"]) > 0.0, "avancement de zone (%d lieux, %d %% révélé)" % [int(prog["total"]), int(float(prog["fog"]) * 100.0)])
	# Énigmes de réflexion
	var xp_before: int = int(pm.roster_entry(data, "Tank")["xp"])
	var res_before: int = int(data.get("resources", {}).get("Bois", 0))
	var r: Dictionary = mgr.complete_puzzle("foret_sylve,2,1")
	check(int(r.get("xp", 0)) > 0 and int(pm.roster_entry(data, "Tank")["xp"]) > xp_before and int(data["resources"].get("Bois", 0)) > res_before, "énigme de runes : XP + ressource partagées")
	check(mgr.complete_puzzle("foret_sylve,2,1").is_empty(), "une énigme ne rapporte qu'une fois")
	check(mgr.solve_puzzle("foret_sylve,4,1", "le feu"), "énigme à réponse tolérante résolue")
	# Événements de route
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	data["adventure"]["hero_pos"] = [0, 0]
	var got: Dictionary = {}
	for i in range(80):
		var ev: Dictionary = mgr.roll_event(rng)
		if not ev.is_empty():
			got[String(ev["kind"])] = true
	check(got.size() >= 3, "événements de route variés (%s)" % str(got.keys()))
	data["adventure"]["steps_since_event"] = 0
	check(mgr.roll_event(rng).is_empty(), "délai minimal entre deux événements")
	# Combat de campagne isolé du mode Tactique
	mgr.start_event_combat({"kind": "ambush", "title": "Embuscade de gobelins", "level": 13})
	var vic_before: int = int(data.get("victories", 0))
	var inv_before: int = data["inventory"].size()
	pm.register_victory(data, {"enemies": [{"type": "Gobelin", "level": 13, "boss": false}], "turns": 5, "deaths": 0})
	check(int(data.get("victories", 0)) == vic_before, "victoire d'Aventure : la campagne Tactique n'avance pas")
	check(int(data["last_result"]["fight_level"]) == 13 and data["inventory"].size() > inv_before, "butin au niveau du défi (13), partagé dans l'inventaire")
	check(String(data["adventure"]["pending_challenge"]) == "" and not data["adventure"].has("pending_name"), "défi nettoyé après la victoire")
	mgr.queue_free()

	# ── Défis optionnels de Conquête ──────────────────────────────────────
	data["campaign_mode"] = "conquest"
	data["conquest"] = {"owned": ["capitale"], "pending_city": "clairiere", "pending_level": 10, "sieges": {}}
	var ch: Dictionary = pm.conquest_challenge_for(data, "clairiere")
	check(ch.has("label") and int(ch["gold"]) > 0, "défi proposé pour l'assaut : %s" % String(ch.get("label", "")))
	check(pm.conquest_challenge_for(data, "clairiere") == ch, "défi déterministe (même ville, même vague)")
	var info_ok: Dictionary = {"turns": 3, "deaths": 0}
	var info_ko: Dictionary = {"turns": 30, "deaths": 2}
	check(pm.conquest_challenge_met(data, {"kind": "swift"}, info_ok) and not pm.conquest_challenge_met(data, {"kind": "swift"}, info_ko), "défi « victoire éclair »")
	check(pm.conquest_challenge_met(data, {"kind": "flawless"}, info_ok) and not pm.conquest_challenge_met(data, {"kind": "flawless"}, info_ko), "défi « sans pertes »")
	check(pm.conquest_challenge_met(data, {"kind": "class", "class": "Mage"}, info_ko) and not pm.conquest_challenge_met(data, {"kind": "class", "class": "Assassin"}, info_ok), "défi « classe imposée »")
	var gold_before: int = int(data["gold"])
	vic_before = int(data.get("victories", 0))
	var ch_kind: String = String(ch["kind"])
	if ch_kind == "class":
		pm.rebuild_team(data, [String(ch["class"]), "Tank", "Mage"] if String(ch["class"]) not in ["Tank", "Mage"] else ["Tank", "Mage", "Sylvain"])
	pm.register_victory(data, {"enemies": [{"type": "Gobelin", "level": 10, "boss": false}], "turns": 3, "deaths": 0})
	check(bool(data["conquest"]["last_challenge"]["success"]), "défi réussi enregistré")
	check(int(data["gold"]) > gold_before + int(ch["gold"]) - 1, "récompense du défi versée")
	check(int(data.get("victories", 0)) == vic_before, "victoire de Conquête : la campagne Tactique n'avance pas")
	check((data["conquest"]["owned"] as Array).has("clairiere"), "la ville neutre est annexée")
	pm.delete_save(3)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
