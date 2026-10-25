extends SceneTree
## V48 : niveau du joueur + déblocage des héros + fiches de classes.
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	root.get_node("GameSettings").tutorial_done = true
	# ── Courbe de déblocage
	check(HeroUnlock.earned_unlocks(3) == 0, "niveau 3 : aucun déblocage")
	check(HeroUnlock.earned_unlocks(4) == 1 and HeroUnlock.earned_unlocks(6) == 1, "niveaux 4-6 : 1 déblocage")
	check(HeroUnlock.earned_unlocks(7) == 2 and HeroUnlock.earned_unlocks(22) == 7, "niveau 7 : 2 ; niveau 22 : 7 (tous)")
	check(HeroUnlock.level_for_unlock(7) == 22, "le 7e héros bonus arrive au niveau 22")
	# ── Nouvelle partie : rien de débloqué, 3 choix à faire
	var d: Dictionary = pm.new_game(4, "Test")
	check((d["heroes_unlocked"] as Array).is_empty() and HeroUnlock.needs_initial_picks(d), "nouvelle partie : choix initial requis")
	check(HeroUnlock.player_level(d) == 1, "joueur niveau 1")
	check(not HeroUnlock.pick_initial(d, ["Tank", "Mage"]), "2 héros refusés")
	check(not HeroUnlock.pick_initial(d, ["Tank", "Tank", "Mage"]), "doublons refusés")
	check(HeroUnlock.pick_initial(d, ["Tank", "Heal", "Mage"]), "3 héros acceptés")
	check(HeroUnlock.is_unlocked(d, "Tank") and not HeroUnlock.is_unlocked(d, "Assassin"), "Tank débloqué, Assassin non")
	check(not HeroUnlock.needs_initial_picks(d) and HeroUnlock.pending_unlocks(d) == 0, "plus de choix initial, aucun déblocage en attente")
	check(HeroUnlock.next_unlock_level(d) == 4, "prochain déblocage au niveau 4")
	check(not HeroUnlock.unlock(d, "Assassin"), "déblocage refusé sans niveau")
	# ── XP du joueur et plafond des héros
	pm.rebuild_team(d, ["Tank", "Heal", "Mage"])
	var lvl_before: int = int(d["roster"]["Tank"]["level"])
	for i in range(6):
		pm.award_xp(d, 400, 1.0, 5)
	var pl: int = HeroUnlock.player_level(d)
	check(pl > 1, "le joueur monte de niveau (%d)" % pl)
	var over: bool = false
	for c in d["roster"].keys():
		if int(d["roster"][c]["level"]) > pl:
			over = true
	check(not over, "aucun héros au-dessus du niveau du joueur")
	check(int(d["roster"]["Tank"]["level"]) > lvl_before, "les héros d'équipe montent aussi")
	check(int(d["last_player"]["to"]) == pl, "rapport joueur disponible")
	# ── Déblocage au choix
	d["player"]["level"] = 4
	check(HeroUnlock.pending_unlocks(d) == 1, "niveau 4 : 1 déblocage en attente")
	check(HeroUnlock.unlock(d, "Assassin"), "Assassin débloqué")
	check(HeroUnlock.pending_unlocks(d) == 0 and HeroUnlock.next_unlock_level(d) == 7, "puis prochain au niveau 7")
	check(not HeroUnlock.unlock(d, "Assassin"), "pas de double déblocage")
	d["player"]["level"] = 40
	check(HeroUnlock.pending_unlocks(d) == 6, "niveau 40 : les 6 héros restants dispo (%d)" % HeroUnlock.pending_unlocks(d))
	for c in HeroUnlock.locked(d).duplicate():
		HeroUnlock.unlock(d, c)
	check(HeroUnlock.locked(d).is_empty() and HeroUnlock.next_unlock_level(d) == -1, "tous débloqués")
	# ── Sauvegarde / chargement
	pm.write_save(4, d)
	var r: Dictionary = pm.load_save(4)
	check((r["heroes_unlocked"] as Array).size() == 10 and int(r["player"]["level"]) == 40, "persisté en sauvegarde")
	pm.delete_save(4)
	# ── Migration d'une ancienne sauvegarde
	var old: Dictionary = pm.new_game(4, "Vieux")
	old.erase("heroes_unlocked")
	old.erase("player")
	old["roster"]["Mage"]["level"] = 17
	pm.ensure_roster(old)
	check((old["heroes_unlocked"] as Array).size() == 10, "ancienne partie : tout est débloqué")
	check(HeroUnlock.player_level(old) == 17, "ancienne partie : niveau joueur = meilleur héros")
	pm.delete_save(4)
	# ── Fiches de classes
	for c in ClassRules.CLASSES.keys():
		var i: Dictionary = ClassInfo.get_info(String(c))
		check(String(i["description"]).length() > 80 and (i["strengths"] as Array).size() >= 2 and String(i["tips"]) != "", "fiche complète : %s" % c)
	# ── Écrans
	var data: Dictionary = pm.new_game(4, "UI")
	var pick: HeroPickUI = HeroPickUI.open(root, data, true)
	await create_timer(0.3).timeout
	check(pick != null, "écran de choix ouvert")
	for c in ["Tank", "Mage", "Druide"]:
		pick._focus = c
		pick._on_toggle()
	check(not pick._confirm.disabled, "3 choisis : confirmation possible")
	var got: Array = []
	pick.done.connect(func(p: Array) -> void: got.append_array(p))
	pick._on_confirm()
	await create_timer(0.2).timeout
	check(got.size() == 3 and HeroUnlock.is_unlocked(data, "Druide"), "confirmation : héros débloqués")
	var gm: Node = root.get_node("GameManager")
	pm.rebuild_team(data, ["Tank", "Mage", "Druide"])
	gm.active_save = data
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/TeamSelection.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(0.6).timeout
	check(sc._is_locked("Assassin") and not sc._is_locked("Tank"), "équipe : Assassin verrouillé")
	sc.current = sc.classes.find("Assassin")
	sc._on_action()
	check(not (sc.team as Array).has("Assassin"), "équipe : un héros verrouillé ne s'ajoute pas")
	check(not sc._unlock_btn.visible, "pas de bouton de déblocage au niveau 1")
	data["player"]["level"] = 4
	sc.refresh()
	check(sc._unlock_btn.visible, "niveau 4 : bouton de déblocage visible")
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
