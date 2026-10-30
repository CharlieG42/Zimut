extends SceneTree
## Écran de ville (CityScreenUI) + difficulté par partie.
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var gs: Node = root.get_node("GameSettings")
	# Difficulté propre à la partie
	var a: Dictionary = {"difficulty": 0}
	var b: Dictionary = {"difficulty": 3}
	check(gs.enemy_hp_mult(a) < gs.enemy_hp_mult({"difficulty": 1}) and gs.enemy_hp_mult(b) > gs.enemy_hp_mult({"difficulty": 2}), "multiplicateurs de PV par partie (Facile < Normal < Difficile < Enfer)")
	check(gs.save_difficulty({}) == gs.difficulty, "sans réglage : difficulté par défaut")
	var d: Dictionary = pm.new_game(4, "Ville")
	check(int(d.get("difficulty", -1)) == 1, "nouvelle partie : difficulté Normal enregistrée dans la sauvegarde")
	# Écran de ville
	pm.rebuild_team(d, ["Chasseur", "Mage", "Sylvain"])
	d["gold"] = 1000
	d["resources"] = {"Bois": 50, "Fer": 50, "Cuir": 50, "Magie": 50, "Venin": 50}
	d["conquest"] = {"owned": ["capitale", "clairiere", "mine_cristal"], "pending_city": ""}
	var ui: CanvasLayer = (load("res://scripts/CityScreenUI.gd") as GDScript).new()
	root.add_child(ui)
	ui.open(d, 4, "mine_cristal", null, "Une mine.")
	await process_frame
	check(ui.find_child("CardHall", true, false) != null and ui.find_child("CardBarracks", true, false) != null and ui.find_child("CardResidence", true, false) != null, "quartiers : hôtel de ville, caserne, résidence")
	check(ui.find_children("CardBuilding_*", "", true, false).size() == ProgressionManager.CONQUEST_BUILDINGS.size(), "un quartier par bâtiment de production")
	var up: Button = ui.find_child("UpgradeButton", true, false) as Button
	check(up != null and not up.disabled, "bouton d'évolution disponible")
	up.pressed.emit()
	await process_frame
	check(ConquestSystem.city_level(d["conquest"], "mine_cristal") == 2, "évolution Hameau -> Bourg depuis l'écran de ville")
	(ui.find_child("CardBarracks", true, false) as Button).pressed.emit()
	await process_frame
	var rec: Button = ui.find_child("RecruitButton", true, false) as Button
	rec.pressed.emit()
	await process_frame
	check(ConquestSystem.troops(d["conquest"], "mine_cristal") == 1, "recrutement depuis la caserne")
	(ui.find_child("CardBuilding_scierie", true, false) as Button).pressed.emit()
	await process_frame
	var bb: Button = ui.find_child("BuildButton_scierie", true, false) as Button
	bb.pressed.emit()
	await process_frame
	check((d["conquest"]["buildings"]["mine_cristal"] as Array).has("scierie"), "construction d'un bâtiment")
	check(ConquestSystem.building_level(d["conquest"], "mine_cristal", "scierie") == 1, "bâtiment construit au niveau 1")
	var upb: Button = ui.find_child("UpgradeBuilding_scierie", true, false) as Button
	check(upb != null and not upb.disabled, "amélioration du bâtiment proposée (Bourg : niveau 2 permis)")
	upb.pressed.emit()
	await process_frame
	check(ConquestSystem.building_level(d["conquest"], "mine_cristal", "scierie") == 2, "scierie niveau 2 depuis l'écran de ville")
	check(ui.find_child("UpgradeBuilding_scierie", true, false) == null, "niveau 3 verrouillé tant que la ville n'est pas Grande Cité")
	check(ui.find_child("CityView", true, false) != null and ui.find_child("CardWonder", true, false) != null, "vue illustrée avec la parcelle de la Merveille")
	(ui.find_child("CardResidence", true, false) as Button).pressed.emit()
	await process_frame
	(ui.find_child("GovernorButton", true, false) as Button).pressed.emit()
	await process_frame
	var pick: Button = ui.find_child("Pick_Tank", true, false) as Button
	check(pick != null, "sélecteur de gouverneur")
	pick.pressed.emit()
	await process_frame
	check(ConquestSystem.hero_of(d["conquest"], "mine_cristal") == "Tank", "gouverneur nommé depuis la résidence")
	check(ui.find_child("RecallButton", true, false) != null, "bouton de rappel du gouverneur")
	var closed: Array = [false]
	ui.closed.connect(func() -> void: closed[0] = true)
	(ui.find_child("BackButton", true, false) as Button).pressed.emit()
	check(closed[0], "bouton CARTE : fermeture")
	# La sauvegarde reflète les actions
	var back: Dictionary = pm.load_save(4)
	check(ConquestSystem.city_level(back["conquest"], "mine_cristal") == 2, "actions sauvegardées")
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
