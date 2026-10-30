extends SceneTree
## Capture du voile de transition (écran de chargement aux couleurs de la Nation).
##   xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_voile.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	root.get_node("SceneVeil").force = true
	var data: Dictionary = pm.new_game(4, "Voile")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "adventure"
	var adv: Dictionary = pm.adventure_state(data)
	pm.adventure_unlock_zone(adv, "brasier_cendres")
	pm.adventure_enter_zone(adv, "brasier_cendres")
	gm.active_save = data
	gm.active_slot = 4
	change_scene_to_file("res://scenes/Adventure3D.tscn")
	await create_timer(0.35).timeout
	root.get_texture().get_image().save_png(out + "/voile_aventure.png")
	await create_timer(1.5).timeout
	gm.fight_biome = "Cristaux"
	change_scene_to_file("res://scenes/Main.tscn")
	await create_timer(0.35).timeout
	root.get_texture().get_image().save_png(out + "/voile_combat.png")
	pm.delete_save(4)
	quit(0)
