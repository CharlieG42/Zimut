extends SceneTree
## Captures V40 : étages de l'Aventure (paysage, portes, mini-carte).
## xvfb-run -a -s "-screen 0 1920x1080x24" godot --rendering-method gl_compatibility --path . -s tests/shot_adventure_etages.gd -- <dossier> [zones séparées par ,]
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var out: String = args[0]
	var zones: PackedStringArray = (args[1] if args.size() > 1 else "foret_sylve,vents_plateau,ombres_necropole,cristaux_caverne,brasier_cendres,desert_dunes,marees_cotes,montagne_pics").split(",")
	DirAccess.make_dir_recursive_absolute(out)
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	root.get_node("GameSettings").tutorial_done = true
	for zone: String in zones:
		var data: Dictionary = pm.new_game(4, "Etages")
		pm.rebuild_team(data, ["Géomancien", "Mage", "Sylvain"])
		data["campaign_mode"] = "adventure"
		var adv: Dictionary = pm.adventure_state(data)
		adv["zone"] = zone
		var unl: Array = pm.ADVENTURE_ZONES.keys()
		adv["zones_unlocked"] = unl
		var meta: Dictionary = pm.ADVENTURE_ZONES[zone]
		adv["hero_pos"] = [int(meta["start"][0]), int(meta["start"][1])]
		for y in range(int(meta["size"][1])):
			for x in range(int(meta["size"][0])):
				if (x + y) % 5 != 4:
					adv["discovered"].append("%s,%d,%d" % [zone, x, y])
		gm.active_save = data
		gm.active_slot = 4
		var sc: Node = (load("res://scenes/AdventureMap.tscn") as PackedScene).instantiate()
		root.add_child(sc)
		await create_timer(1.6).timeout
		root.get_viewport().get_texture().get_image().save_png(out + "/etage_" + zone + ".png")
		sc.queue_free()
		await process_frame
	pm.delete_save(4)
	quit(0)
