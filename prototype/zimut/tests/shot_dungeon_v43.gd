extends SceneTree
## xvfb-run -a -s "-screen 0 1920x1080x24" godot --rendering-method gl_compatibility --rendering-driver opengl3 --path . -s tests/shot_dungeon_v43.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	var data: Dictionary = pm.new_game(4, "ShotDonjon")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "adventure"
	var adv: Dictionary = pm.adventure_state(data)
	adv["zone"] = "foret_ronces"
	adv["hero_pos"] = [1, 1]
	adv["dungeon"] = {"biome": "Forêt", "room": 3}
	gm.active_save = data
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/AdventureMap.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(0.8).timeout
	var poi: Dictionary = sc.manager.poi_at(Vector2i(1, 1))
	sc._confirm_combat(poi)
	await create_timer(0.6).timeout
	root.get_viewport().get_texture().get_image().save_png(out + "/dungeon_dialog.png")
	pm.delete_save(4)
	quit()
