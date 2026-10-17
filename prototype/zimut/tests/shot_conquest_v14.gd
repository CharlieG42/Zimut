extends SceneTree
## Captures V14 : xvfb-run -a godot --rendering-method gl_compatibility --path . [--resolution 960x432] -s tests/shot_conquest_v14.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	var data: Dictionary = pm.new_game(4, "CaptureV14")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "conquest"
	data["gold"] = 400
	data["resources"] = {"Bois": 30, "Fer": 30, "Cuir": 12, "Magie": 12, "Venin": 5}
	data["conquest"] = {"owned": ["capitale", "clairiere", "pont_mousse", "fort_racine"], "pending_city": "",
		"city_levels": {"clairiere": 2}, "garrisons": {"clairiere": {"troops": 3, "hero": "Tank"}, "pont_mousse": {"troops": 1, "hero": ""}},
		"threat": {"city": "pont_mousse", "power": 21, "eta": 2},
		"news": ["⚠ GRANDE OFFENSIVE ennemie (force 21) : Pont-Mousse sera attaquée dans 3 batailles !", "🛡 Raid repoussé à Clairière d'Aube : la garnison tient bon."],
		"events": ["Ville annexée : Fort Racine"]}
	var rng := RandomNumberGenerator.new()
	rng.seed = 11
	var ev: Dictionary = ConquestSystem.make_event("mercenaires", data, data["conquest"], rng)
	data["conquest"]["event_pending"] = ev
	gm.active_save = data
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/ConquestMap.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(1.5).timeout
	_shot(out + "/v14_1_news.png")
	for n: Node in sc.get_children():
		if n is Control and n != null and n.get_class() == "ColorRect" and n.name != "EventPopup":
			pass
	# fermer les popups de nouvelles (boutons CONTINUER)
	_press_continue(sc)
	await create_timer(0.4).timeout
	_shot(out + "/v14_2_event.png")
	var popup: Node = sc.get_node_or_null("EventPopup")
	if popup != null:
		for b in popup.find_children("*", "Button", true, false):
			if not (b as Button).disabled:
				(b as Button).pressed.emit()
				break
	await create_timer(0.3).timeout
	_shot(out + "/v14_2b_result.png")
	_press_continue(sc)
	sc._select_city("clairiere")
	await create_timer(0.5).timeout
	_shot(out + "/v14_3_city.png")
	sc._show_governor_picker("pont_mousse")
	await create_timer(0.4).timeout
	_shot(out + "/v14_4_picker.png")
	pm.delete_save(4)
	quit()
func _press_continue(n: Node) -> void:
	var last: Button = null
	for c in n.find_children("*", "Button", true, false):
		if (c as Button).text == "CONTINUER" and (c as Button).is_visible_in_tree():
			last = c
	if last != null:
		last.pressed.emit()
func _shot(p: String) -> void:
	root.get_viewport().get_texture().get_image().save_png(p)
