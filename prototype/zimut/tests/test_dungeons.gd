extends SceneTree
## V43 : Donjons de Nation (Aventure) — 4 salles, Gardien, Pierre 50 % puis 5 %, refaisables.
## Lancement : xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/test_dungeons.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var pm: Node = root.get_node("/root/ProgressionManager")
	var gm: Node = root.get_node("/root/GameManager")
	var D: GDScript = load("res://scripts/Dungeons.gd")
	print("Règles :")
	# Un donjon par Nation, niveaux dans la tranche, croissants
	var guardians: Dictionary = {}
	for z: String in pm.ADVENTURE_POIS.keys():
		for k: String in pm.ADVENTURE_POIS[z].keys():
			var g: String = String(pm.ADVENTURE_POIS[z][k].get("guardian", ""))
			if g != "":
				guardians[g] = "%s|%s" % [z, k]
	check(guardians.size() == 10, "10 donjons de Nation (un par Nation)")
	var lv_ok: bool = true
	for b: String in guardians.keys():
		var band: Vector2i = Nations.level_band(b)
		var prev: int = 0
		for r: int in range(1, 5):
			var l: int = D.room_level(b, r)
			if l < band.x or l > band.y or l < prev:
				lv_ok = false
			prev = l
		if D.room_level(b, 4) != band.y:
			lv_ok = false
	check(lv_ok, "niveaux des 4 salles dans la tranche de la Nation, croissants, Gardien au sommet")
	check(D.ROOM_COUNT == [3, 4, 4, 4] and D.ROOM_POWER[0] == 0.0 and D.ROOM_POWER[2] > D.ROOM_POWER[1], "difficulté croissante (effectif, puissance)")
	# Expédition simulée (sans sauvegarde)
	var adv: Dictionary = {}
	check(D.current_room(adv, "Forêt") == 1, "pas d'expédition : salle 1")
	check(D.begin(adv, "Forêt") == 1 and int(adv["pending_count"]) == 3 and int(adv["pending_level"]) == D.room_level("Forêt", 1), "salle 1 : 3 ennemis")
	var r1: Dictionary = D.win_room(adv, "Forêt", 0.0, false)
	check(not bool(r1["cleared"]) and D.current_room(adv, "Forêt") == 2, "salle 1 gagnée → salle 2")
	D.win_room(adv, "Forêt", 0.0, false)
	D.win_room(adv, "Forêt", 0.0, false)
	check(D.current_room(adv, "Forêt") == 4, "après 3 victoires : salle du Gardien")
	check(is_equal_approx(D.stone_chance(adv, "Forêt"), 0.5), "1er Gardien : 50 % de Pierre")
	var r4: Dictionary = D.win_room(adv, "Forêt", 0.49, false)
	check(bool(r4["cleared"]) and bool(r4["first_clear"]) and String(r4["stone_roll"]) == "won", "tirage 0,49 < 50 % : Pierre gagnée")
	check(not adv.has("dungeon") and D.clears(adv, "Forêt") == 1, "expédition terminée, 1 donjon bouclé")
	check(is_equal_approx(D.stone_chance(adv, "Forêt"), 0.05), "ensuite : 5 %")
	for i: int in range(3):
		D.win_room(adv, "Forêt", 0.9, true)
	var r4b: Dictionary = D.win_room(adv, "Forêt", 0.04, false)
	check(String(r4b["stone_roll"]) == "won" and not bool(r4b["first_clear"]), "2e fois : 0,04 < 5 % → Pierre")
	for i: int in range(3):
		D.win_room(adv, "Forêt", 0.9, true)
	var r4c: Dictionary = D.win_room(adv, "Forêt", 0.06, false)
	check(String(r4c["stone_roll"]) == "missed", "2e fois : 0,06 ≥ 5 % → pas de Pierre")
	for i: int in range(3):
		D.win_room(adv, "Forêt", 0.9, true)
	check(String(D.win_room(adv, "Forêt", 0.0, true)["stone_roll"]) == "owned", "Pierre déjà possédée : pas de tirage")
	D.begin(adv, "Marées")
	D.win_room(adv, "Marées", 0.0, false)
	D.lose(adv)
	check(D.current_room(adv, "Marées") == 1, "défaite : retour à l'entrée")
	print("Intégration (sauvegarde, victoire, défaite) :")
	var data: Dictionary = pm.new_game(4, "Donjon")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "adventure"
	var a: Dictionary = pm.adventure_state(data)
	var gz: String = String(guardians["Forêt"]).split("|")[0]
	var gk: String = String(guardians["Forêt"]).split("|")[1]
	a["zone"] = gz
	var key: String = "%s,%s" % [gz, gk]
	var win_info: Dictionary = {"enemies": [{"type": "Gobelin", "level": 15, "boss": false}], "turns": 6, "deaths": 0}
	for room: int in range(1, 4):
		a["pending_challenge"] = key
		D.begin(a, "Forêt")
		pm.register_victory(data, win_info)
		a = data["adventure"]
		check(not (a.get("completed", []) as Array).has(key), "salle %d : le donjon n'est pas « terminé »" % room)
		check(not (data["last_result"]["dungeon"] as Dictionary).get("cleared", true), "salle %d : résultat « salle vaincue »" % room)
	a["pending_challenge"] = key
	check(D.begin(a, "Forêt") == 4, "4e salle atteinte")
	var boss_info: Dictionary = win_info.duplicate()
	boss_info["nation_boss"] = "Forêt"
	boss_info["boss"] = true
	pm.register_victory(data, boss_info)
	a = data["adventure"]
	var dg: Dictionary = data["last_result"]["dungeon"]
	check(bool(dg.get("cleared", false)) and int(dg.get("gold", 0)) > 0, "Gardien vaincu : donjon terminé avec butin")
	check((a.get("completed", []) as Array).has(key), "1re victoire : compte pour la maîtrise de la carte")
	check(String(dg["stone_roll"]) in ["won", "missed"], "tirage de Pierre effectué")
	check((String(dg["stone_roll"]) == "won") == Stones.has(data, "Forêt"), "Pierre donnée si et seulement si le tirage est gagnant")
	check(not a.has("dungeon") and String(a.get("pending_challenge", "x")) == "", "expédition et défi remis à zéro")
	# Défaite en salle 2 : retour à l'entrée
	a["pending_challenge"] = key
	D.begin(a, "Forêt")
	pm.register_victory(data, win_info)
	a = data["adventure"]
	a["pending_challenge"] = key
	check(D.current_room(a, "Forêt") == 2, "salle 2 en cours")
	pm.register_defeat(data, {"enemies": [{"type": "Gobelin", "level": 15, "boss": false}], "turns": 4})
	a = data["adventure"]
	check(D.current_room(a, "Forêt") == 1 and bool(data["last_result"]["dungeon"]["lost"]), "défaite : retour à la salle 1, résultat signalé")
	# Arrêt du jeu : une autre session de jeu repart de la salle 1
	a["dungeon"] = {"biome": "Forêt", "room": 3, "session": D.session}
	check(D.current_room(a, "Forêt") == 3, "même session : salle 3 conservée")
	a["dungeon"]["session"] = D.session + 1
	check(D.current_room(a, "Forêt") == 1, "jeu relancé : retour à la salle 1")
	print("Combat (salles 1 et 4) :")
	a["zone"] = gz
	for room2: int in [1, 4]:
		a["pending_challenge"] = key
		a["dungeon"] = {"biome": "Forêt", "room": room2, "session": D.session}
		D.begin(a, "Forêt")
		gm.active_slot = 4
		gm.active_save = data
		gm.init_grid()
		gm.init_entities()
		await process_frame
		var n_boss: int = 0
		for e in gm.enemies:
			if String(e.get("name", "")).contains("BOSS"):
				n_boss += 1
		check(gm.fight_dungeon_room == room2, "salle %d : combat de donjon reconnu" % room2)
		if room2 == 1:
			check(gm.enemies.size() == 3 and n_boss == 0, "salle 1 : 3 ennemis, pas de boss")
		else:
			check(n_boss == 1 and gm.enemies.size() == 4 and gm.fight_nation_boss == "Forêt", "salle 4 : le Gardien et 3 sbires")
	gm.active_slot = -1
	gm.active_save = {}
	pm.delete_save(4)
	print("")
	print("OK : tous les tests passent." if fails == 0 else "ÉCHEC : %d" % fails)
	quit(1 if fails > 0 else 0)
