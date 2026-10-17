extends SceneTree
## Captures de l'écran de ville :
## xvfb-run -a -s "-screen 0 1920x1080x24" godot --rendering-method gl_compatibility --rendering-driver opengl3 --path . -s tests/shot_city_screen.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	var data: Dictionary = pm.new_game(4, "CaptureVille")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "conquest"
	data["gold"] = 400
	data["resources"] = {"Bois": 30, "Fer": 30, "Cuir": 12, "Magie": 12, "Venin": 5}
	data["conquest"] = {"owned": ["capitale", "clairiere", "col_givre", "mine_cristal", "caravanserail"], "pending_city": "",
		"city_levels": {"clairiere": 2}, "garrisons": {"clairiere": {"troops": 3, "hero": "Tank"}},
		"buildings": {"clairiere": ["scierie"]},
		"threat": {"city": "clairiere", "power": 21, "eta": 2}}
	gm.active_save = data
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/ConquestMap.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(1.0).timeout
	var i: int = 0
	for cid in ["clairiere", "col_givre", "mine_cristal", "caravanserail"]:
		sc._on_city_pressed(cid)
		await create_timer(0.5).timeout
		root.get_viewport().get_texture().get_image().save_png("%s/city_%d_%s.png" % [out, i, cid])
		var cs: Node = sc.get_node_or_null("CityScreen")
		if cs == null:
			print("PAS d'écran de ville pour ", cid)
		else:
			cs.close()
		await create_timer(0.3).timeout
		i += 1
	sc._on_city_pressed("clairiere")
	await create_timer(0.3).timeout
	sc.get_node("CityScreen")._show_governor_picker()
	await create_timer(0.3).timeout
	root.get_viewport().get_texture().get_image().save_png("%s/city_picker.png" % out)
	pm.delete_save(4)
	quit()
