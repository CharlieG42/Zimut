extends SceneTree
## Capture : arrivée devant une porte fermée (panneau d'info) + bouton d'action entre les sticks.
##   xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_porte_fermee.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	var data: Dictionary = pm.new_game(4, "Porte")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "adventure"
	pm.adventure_state(data)
	gm.active_save = data
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/Adventure3D.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(0.8).timeout
	var ex: Adv3DExplorer = sc.explorer
	var gate_c: Vector2i = Vector2i(-1, -1)
	for c: Vector2i in sc.manager.gates().keys():
		if not bool(sc.manager.gate_at(c).get("open", false)):
			gate_c = c
			break
	var gp: Vector3 = Adv3DWorld.cell_center(gate_c)
	var t: Dictionary = AdventureTerrain.zone_terrain(sc.zone_id)
	var center := Vector3(float(t["size"].x) * Adv3DWorld.CELL * 0.5, 0, float(t["size"].y) * Adv3DWorld.CELL * 0.5)
	var dir: Vector3 = (center - gp)
	dir.y = 0
	dir = dir.normalized()
	ex.place_at(gp + dir * 3.2)
	ex.yaw = atan2(dir.x, dir.z)
	ex._cam_yaw = ex.yaw
	ex.pitch = -0.55
	ex.distance = 9.0
	sc._companion.place_near_target()
	await create_timer(0.5).timeout
	sc._ask_gate(gate_c)
	sc.set_process(false)
	sc.set_physics_process(false)
	sc._act_btn.visible = true
	sc._act_btn.text = "⚔  Camp gobelin"
	await create_timer(0.6).timeout
	root.get_texture().get_image().save_png(out + "/porte_fermee.png")
	pm.delete_save(4)
	quit(0)
