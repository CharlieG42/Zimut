extends SceneTree
## V70 : niveau des héros en combat = niveau de la sauvegarde ; déblocage d'un héros conservé après relance.
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
	var slot: int = 3
	var d: Dictionary = pm.new_game(slot, "Repro")
	HeroUnlock.pick_initial(d, ["Artificier", "Druide", "Chasseur"])
	pm.rebuild_team(d, ["Artificier", "Druide", "Chasseur"])
	d["player"] = {"level": 4, "xp": pm.xp_for_level(4) if pm.has_method("xp_for_level") else 0}
	for c in ["Artificier", "Druide", "Chasseur"]:
		d["roster"][c]["level"] = 3
	pm.write_save(slot, d)
	# ── relance : on recharge depuis le disque
	var d2: Dictionary = pm.load_save(slot)
	check(HeroUnlock.pending_unlocks(d2) == 1, "un déblocage en attente (joueur niv. %d)" % HeroUnlock.player_level(d2))
	check(HeroUnlock.unlock(d2, "Tank"), "Tank débloqué")
	pm.write_save(slot, d2)
	var d3: Dictionary = pm.load_save(slot)
	check(HeroUnlock.is_unlocked(d3, "Tank"), "Tank toujours débloqué après relance")
	check(HeroUnlock.pending_unlocks(d3) == 0, "plus de déblocage en attente")
	# ── niveau en combat
	gm.active_save = d3
	gm.active_slot = slot
	gm.set_custom_team([{"classe": "Artificier"}, {"classe": "Druide"}, {"classe": "Chasseur"}])
	gm.init_entities()
	for p in gm.players:
		print("   ", p["classe"], " niveau ", p["level"], " sorts ", (p["spells"] as Array).size())
		check(int(p["level"]) == pm.member_level(d3, String(p["classe"])), "%s : niveau combat = niveau sauvegarde (%d)" % [p["classe"], int(p["level"])])
	# équipe de combat différente (autre ordre) de l'équipe enregistrée : le niveau du héros reste celui de la partie
	gm.set_custom_team([{"classe": "Chasseur"}, {"classe": "Artificier"}, {"classe": "Druide"}])
	gm.init_entities()
	for p in gm.players:
		check(int(p["level"]) == 3, "%s : niveau 3 même si l'ordre de l'équipe diffère (%d sorts)" % [p["classe"], (p["spells"] as Array).size()])
		check((p["spells"] as Array).size() <= 6, "%s : peu de sorts au niveau 3" % p["classe"])
	pm.delete_save(slot)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
