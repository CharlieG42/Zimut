extends SceneTree
## Captures rapprochées d'un groupe de monstres 3D par Nation (normal + élite).
##   xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_monstres3d.gd -- <dossier>
const ZONES := {"cristaux_caverne": "Cristaux", "marees_cotes": "Marées", "vents_plateau": "Vents", "brasier_cendres": "Brasier",
	"brumes_marais": "Brumes", "ombres_necropole": "Ombres", "rouages_atelier": "Rouages", "portes_donjon": "Donjon"}
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	for zone: String in ZONES.keys():
		var data: Dictionary = pm.new_game(4, "Mobs")
		pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
		data["campaign_mode"] = "adventure"
		var adv: Dictionary = pm.adventure_state(data)
		pm.adventure_unlock_zone(adv, zone)
		pm.adventure_enter_zone(adv, zone)
		gm.active_save = data
		gm.active_slot = 4
		var sc: Node = (load("res://scenes/Adventure3D.tscn") as PackedScene).instantiate()
		root.add_child(sc)
		await create_timer(0.5).timeout
		sc._hud.visible = false
		sc.set_process(false)
		var ex: Adv3DExplorer = sc.explorer
		var t: Dictionary = AdventureTerrain.zone_terrain(zone)
		var p: Vector3 = Adv3DWorld.cell_center(t["start"])
		ex.place_at(p)
		ex.visible = false
		if sc._companion != null:
			sc._companion.visible = false
		var b: String = ZONES[zone]
		var a := Adv3DActors.make_mob_group({"count": 3, "level": 10, "elite": false}, "Normal", b)
		a.position = p + Vector3(-1.3, 0, 0)
		var e := Adv3DActors.make_mob_group({"count": 1, "level": 12, "elite": true}, "Élite", b)
		e.position = p + Vector3(1.5, 0, 0)
		sc.world_root.add_child(a)
		sc.world_root.add_child(e)
		ex.yaw = 0.0
		ex._cam_yaw = 0.0
		ex.pitch = -0.32
		ex.distance = 6.0
		ex._place_camera(1.0)
		await create_timer(0.4).timeout
		root.get_texture().get_image().save_png(out + "/mob_%s.png" % b)
		sc.queue_free()
		await process_frame
	pm.delete_save(4)
	quit(0)
