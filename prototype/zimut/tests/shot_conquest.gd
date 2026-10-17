extends SceneTree
## Captures Conquête : xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_conquest.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	var data: Dictionary = pm.new_game(4, "CaptureConq")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "conquest"
	gm.active_save = data
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/ConquestMap.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(1.5).timeout
	_shot(out + "/conq_1.png")
	# molette : zoom avant au centre, puis glisser
	sc._zoom_focus = sc._map_scroll.size * 0.5
	sc._set_map_zoom(1.8, true)
	await create_timer(1.2).timeout
	sc._pan += Vector2(-300, -100)
	sc._clamp_zoom_and_pan()
	await create_timer(0.3).timeout
	_shot(out + "/conq_2_zoom.png")
	sc._set_map_zoom(0.1, true)
	await create_timer(1.2).timeout
	_shot(out + "/conq_3_dezoom.png")
	pm.delete_save(4)
	quit()
func _shot(p: String) -> void:
	root.get_viewport().get_texture().get_image().save_png(p)
