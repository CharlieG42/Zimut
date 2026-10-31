extends SceneTree
## Captures V62 de l'écran de ville : illustrations par bâtiment, jour / soir / nuit,
## événements de ville (fête, incendie, marchand) et spécialisations (militaire / marchande).
##   xvfb-run -a -s "-screen 0 1920x1080x24" godot --rendering-method gl_compatibility --rendering-driver opengl3 --path . -s tests/shot_city_v62.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _shot(p: String) -> void:
	root.get_viewport().get_texture().get_image().save_png(p)
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	var gs: Node = root.get_node("GameSettings")
	gs.tutorial_enabled = true
	gs.tuto_seen = {"ville_v61": true}
	var data: Dictionary = pm.new_game(4, "CaptureV62")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "conquest"
	data["gold"] = 900
	data["resources"] = {"Bois": 60, "Fer": 60, "Cuir": 25, "Magie": 25, "Venin": 10}
	data["conquest"] = {"owned": ["capitale", "clairiere", "caravanserail"], "pending_city": "",
		"city_levels": {"clairiere": 3, "caravanserail": 2},
		"garrisons": {"clairiere": {"troops": 5, "hero": "Tank"}},
		"buildings": {"clairiere": ["scierie", "mine", "cabane"]},
		"building_levels": {"clairiere": {"scierie": 2, "mine": 3, "cabane": 1}, "caravanserail": {"verger": 2}},
		"wonders": ["clairiere"], "battle_count": 4}
	gm.active_save = data
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/ConquestMap.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(1.0).timeout
	# 1. Cité de la Forêt, jour, spécialisation non choisie (boutons visibles)
	sc._on_city_pressed("clairiere")
	await create_timer(0.8).timeout
	_shot(out + "/v62_cite_jour.png")
	# 2. Nuit : fenêtres et lanternes allumées
	var cs: Node = sc.get_node("CityScreen")
	ConquestSystem.cycle_time_of_day(cs._conq(), "clairiere")
	ConquestSystem.cycle_time_of_day(cs._conq(), "clairiere")  # soir -> nuit
	cs._render()
	await create_timer(0.6).timeout
	_shot(out + "/v62_cite_nuit.png")
	# 3. Événement de ville : fête
	cs._conq()["city_events"] = {"clairiere": "fete"}
	cs._render()
	await create_timer(0.5).timeout
	_shot(out + "/v62_fete.png")
	# 4. Spécialisation militaire choisie + incendie
	ConquestSystem.choose_spec(data, "clairiere", "militaire")
	cs._conq()["city_events"] = {"clairiere": "incendie"}
	cs._conq()["city_time"] = {"clairiere": 0}  # retour au jour
	cs._render()
	await create_timer(0.5).timeout
	_shot(out + "/v62_militaire_incendie.png")
	cs.close()
	await create_timer(0.3).timeout
	# 5. Bourg du Désert (caravansérail), soir, marchand de passage
	sc._on_city_pressed("caravanserail")
	await create_timer(0.6).timeout
	var cs2: Node = sc.get_node("CityScreen")
	cs2._conq()["city_time"] = {"caravanserail": 1}  # soir
	cs2._conq()["city_events"] = {"caravanserail": "marchand"}
	cs2._render()
	await create_timer(0.5).timeout
	_shot(out + "/v62_bourg_soir_marchand.png")
	pm.delete_save(4)
	quit()
