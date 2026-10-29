extends SceneTree
## V70 : flux réel écran d'équipe -> combat : niveaux et déblocage persistants.
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
	root.get_node("GameSettings").tutorial_done = true
	var slot: int = 4
	var d: Dictionary = pm.new_game(slot, "Flux")
	HeroUnlock.pick_initial(d, ["Artificier", "Druide", "Chasseur"])
	pm.rebuild_team(d, ["Artificier", "Druide", "Chasseur"])
	for c in ["Artificier", "Druide", "Chasseur"]:
		d["roster"][c]["level"] = 3
	d["player"] = {"level": 4, "xp": 0}
	pm.write_save(slot, d)
	gm.active_save = pm.load_save(slot)
	gm.active_slot = slot
	var sc: Node = (load("res://scenes/TeamSelection.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(0.6).timeout
	print("   équipe écran :", sc.team)
	# déblocage via l'écran
	sc._on_unlock_hero()
	await create_timer(0.3).timeout
	var pick: Node = sc.find_child("HeroPickUI", true, false)
	check(pick != null, "fenêtre de déblocage ouverte")
	if pick != null:
		pick._focus = "Tank"; pick._on_toggle(); pick._on_confirm()
	await create_timer(0.3).timeout
	var disk: Dictionary = pm.load_save(slot)
	check(HeroUnlock.is_unlocked(disk, "Tank"), "Tank débloqué sur le disque juste après le choix")
	# lancement du combat
	if sc.team.size() == 3:
		sc._on_combat()
	await create_timer(0.5).timeout
	print("   custom_team :", gm.custom_team.size(), " save team :", gm.active_save.get("team", []).map(func(m): return m["classe"]))
	var disk2: Dictionary = pm.load_save(slot)
	check(HeroUnlock.is_unlocked(disk2, "Tank"), "Tank toujours débloqué après le lancement du combat")
	gm.init_entities()
	for p in gm.players:
		print("   ", p["classe"], " niveau ", p["level"], " sorts ", (p["spells"] as Array).size())
		check(int(p["level"]) == 3, "%s niveau 3 en combat" % p["classe"])
	pm.delete_save(slot)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
