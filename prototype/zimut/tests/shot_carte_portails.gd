extends SceneTree
## Capture de la carte plein écran du monde 3D : destinations et niveaux des accès.
##   xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_carte_portails.gd -- <dossier> [zone]
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var out: String = args[0]
	var zone: String = args[1] if args.size() > 1 else "foret_sylve"
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	root.get_node("GameSettings").tutorial_enabled = false
	var data: Dictionary = pm.new_game(4, "Portails")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "adventure"
	var adv: Dictionary = pm.adventure_state(data)
	pm.adventure_enter_zone(adv, zone)
	gm.active_save = data
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/Adventure3D.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(1.0).timeout
	sc._open_full_map()
	await create_timer(0.5).timeout
	root.get_viewport().get_texture().get_image().save_png(out + "/carte_portails_%s.png" % zone)
	pm.delete_save(4)
	quit()
