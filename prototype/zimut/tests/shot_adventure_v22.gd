extends SceneTree
## Captures V22 : groupes de monstres, fenêtre de combat de groupe, camp + contrat,
## combat Tactique à 2 ennemis. xvfb-run -a -s "-screen 0 1920x1080x24" godot --path . -s tests/shot_adventure_v22.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	DirAccess.make_dir_recursive_absolute(out)
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	var gs: Node = root.get_node("GameSettings")
	gs.tutorial_done = true
	var data: Dictionary = pm.new_game(4, "CaptureV22")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	for c in ["Chasseur", "Mage", "Sylvain"]:
		pm.roster_entry(data, c)["level"] = 3
	data["campaign_mode"] = "adventure"
	var adv: Dictionary = pm.adventure_state(data)
	var zone: String = "foret_sylve"
	var meta: Dictionary = pm.ADVENTURE_ZONES[zone]
	for y in range(int(meta["size"][1])):
		for x in range(int(meta["size"][0])):
			adv["discovered"].append("%s,%d,%d" % [zone, x, y])
	adv["moves"] = 40
	gm.active_save = data
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/AdventureMap.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(1.5).timeout
	_shot(out + "/v22_map.png")
	var g: Dictionary = sc.manager.mobs()[0]
	sc._confirm_mob(g)
	await create_timer(0.5).timeout
	_shot(out + "/v22_mob.png")
	sc._close_modal()
	sc._camp_modal("foret_sylve,5,5", 30)
	await create_timer(0.5).timeout
	_shot(out + "/v22_camp.png")
	sc.manager.accept_contract()
	sc._close_modal()
	sc._refresh_side()
	await create_timer(0.4).timeout
	_shot(out + "/v22_contract.png")
	# Combat contre un groupe de 2
	var small: Dictionary = {}
	for gg: Dictionary in sc.manager.mobs():
		if int(gg["count"]) == 2:
			small = gg
	if small.is_empty():
		small = g
		small["count"] = 2
	sc.manager.start_mob_combat(small)
	sc.queue_free()
	await process_frame
	gm.set_custom_team([{"classe": "Chasseur"}, {"classe": "Mage"}, {"classe": "Sylvain"}])
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await create_timer(2.0).timeout
	print("ennemis en combat : ", gm.enemies.size(), " (attendu ", int(small["count"]), ")")
	_shot(out + "/v22_fight.png")
	pm.delete_save(4)
	quit()
func _shot(p: String) -> void:
	root.get_viewport().get_texture().get_image().save_png(p)
