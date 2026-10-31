extends SceneTree
## V64 : carte Conquête — terres inconnues sans détails, alerte de siège trop fort,
## raccourci explorateur, Cartographie recommandée.
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	root.get_node("GameSettings").tutorial_enabled = false
	var d: Dictionary = pm.new_game(4, "UiV64")
	pm.rebuild_team(d, ["Chasseur", "Mage", "Sylvain"])
	d["campaign_mode"] = "conquest"
	d["heroes_unlocked"] = ["Chasseur", "Mage", "Sylvain", "Tank"]
	d["conquest"] = {"owned": ["capitale", "clairiere", "pont_mousse"], "pending_city": "", "battle_count": 3}
	var adv: Dictionary = pm.adventure_state(d)
	adv["revealed_cities"] = ["capitale", "hameau_pin"]
	d["adventure"] = adv
	var gm: Node = root.get_node("GameManager")
	gm.active_save = d
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/ConquestMap.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(0.8).timeout

	# Terres inconnues : aucun détail ne fuit
	sc._select_city("ruines_lierre")
	check(sc._message.text.contains("Terres inconnues"), "ville inconnue : message « Terres inconnues »")
	check(not sc._message.text.contains("Ruines du Lierre") and not sc._message.text.contains("Niveau conseillé"), "ville inconnue : ni nom ni niveau dans le panneau")
	check(sc._attack.disabled and sc._attack.text == "TERRES INCONNUES", "ville inconnue : assaut impossible")
	check(not sc._details_toggle.visible, "ville inconnue : pas de détails")

	# Brouillard : raccourci explorateur dans l'onglet Cibles
	check(sc._fog_remaining() > 0, "il reste du brouillard")
	check(sc._tab_targets.find_child("ExplorerButton", true, false) != null, "onglet Cibles : bouton explorateur")

	# Siège trop fort : confirmation avant l'assaut
	sc._select_city("fort_racine")
	check(sc._message.text.contains("trop fort"), "Fort Racine annoncé trop fort pour une équipe de niveau 1")
	sc._attack_selected_city()
	await process_frame
	check(sc.find_child("RiskyAssaultConfirm", true, false) != null, "alerte de siège risqué affichée")
	var cancel: Button = sc.find_child("RiskyCancel", true, false) as Button
	if cancel != null:
		cancel.pressed.emit()
	await process_frame
	check(sc.find_child("RiskyAssaultConfirm", true, false) == null, "« Choisir une autre cible » ferme l'alerte")
	check(sc._tab_targets.visible, "… et ouvre l'onglet Cibles")

	# Ville à portée de l'équipe : pas d'alerte
	sc._select_city("clairiere")
	for h: String in ["Chasseur", "Mage", "Sylvain"]:
		(d["roster"][h] as Dictionary)["level"] = 20
	sc._select_city("vieille_tour")
	sc._attack_selected_city()
	await process_frame
	check(sc.find_child("RiskyAssaultConfirm", true, false) == null, "équipe niveau 20 face à la Vieille Tour : pas d'alerte")

	# Mission de Cartographie recommandée
	sc._show_mission_picker()
	await process_frame
	var picker: Node = sc.find_child("MissionPicker", true, false)
	var found: bool = false
	for b: Node in picker.find_children("*", "Button", true, false):
		if (b as Button).text.begins_with("★ RECOMMANDÉE"):
			found = true
	check(found, "sélecteur de missions : Cartographie recommandée")
	var heroes_listed: Array = []
	for lb: Node in picker.find_children("*", "Label", true, false):
		if ProgressionManager.CLASS_ORDER.has((lb as Label).text):
			heroes_listed.append((lb as Label).text)
	check(heroes_listed.has("Tank") and not heroes_listed.has("Assassin"), "sélecteur de missions : seuls les héros débloqués sont proposés")
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
