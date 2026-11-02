extends SceneTree
## Captures : étirement au repos, feuilles tombantes, scintillements de l'eau.
##   xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_vie3d.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	var data: Dictionary = pm.new_game(4, "Vie3D")
	pm.rebuild_team(data, ["Mage", "Chasseur", "Sylvain"])
	data["campaign_mode"] = "adventure"
	var adv: Dictionary = pm.adventure_state(data)
	pm.adventure_enter_zone(adv, "foret_sylve")
	gm.active_save = data
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/Adventure3D.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(1.0).timeout
	var ex: Adv3DExplorer = sc.explorer
	ex.pitch = -0.2
	ex.distance = 4.6
	ex.yaw = 0.5 + PI
	ex._cam_yaw = 0.5 + PI
	await create_timer(1.5).timeout
	ex._rig.force_fidget()
	await create_timer(1.0).timeout
	root.get_texture().get_image().save_png(out + "/vie_etirement.png")
	await create_timer(3.0).timeout
	ex.pitch = -0.9
	ex.distance = 9.0
	await create_timer(1.0).timeout
	root.get_texture().get_image().save_png(out + "/vie_feuilles.png")
	pm.delete_save(4)
	quit(0)
