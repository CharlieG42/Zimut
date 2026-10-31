extends SceneTree
## Capture V63 : entrée de donjon dans le monde 3D (marqueur, bouton d'action, fenêtre des salles).
##   xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_donjon_3d.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _shot(p: String) -> void:
	await process_frame
	root.get_viewport().get_texture().get_image().save_png(p)
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var zone: String = "foret_ronces"
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	root.get_node("GameSettings").tutorial_enabled = false
	var data: Dictionary = pm.new_game(4, "Donjon3D")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "adventure"
	var adv: Dictionary = pm.adventure_state(data)
	(adv["zones_unlocked"] as Array).append(zone)
	pm.adventure_enter_zone(adv, zone)
	gm.active_save = data
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/Adventure3D.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(1.0).timeout
	var key: String = ""
	for k: String in pm.ADVENTURE_POIS[zone].keys():
		if Dungeons.is_dungeon(pm.ADVENTURE_POIS[zone][k]):
			key = k
	var cell: Vector2i = AdventureTerrain.parse(key)
	var ex: Node3D = sc.explorer
	var target: Vector3 = Adv3DWorld.cell_center(cell)
	var best: Vector2i = cell
	for d: Vector2i in [Vector2i(0, 1), Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, 2), Vector2i(2, 0)]:
		if AdventureTerrain.walkable(zone, cell + d):
			best = cell + d
			break
	ex.place_at(Adv3DWorld.cell_center(best).lerp(target, 0.55))
	ex.yaw = atan2(ex.position.x - target.x, ex.position.z - target.z)
	ex._cam_yaw = ex.yaw
	ex.pitch = -0.45
	ex.distance = 9.0
	await create_timer(1.2).timeout
	sc._update_action_button(Vector2(ex.position.x, ex.position.z))
	await _shot(out + "/donjon3d_monde.png")
	sc._on_action_pressed()
	await create_timer(0.5).timeout
	await _shot(out + "/donjon3d_salles.png")
	print("zone=", sc.zone_id, " key=", key, " best=", best, " bouton : ", sc._act_btn.text, " · fenêtre : ", sc._modal_root != null)
	pm.delete_save(4)
	quit()
