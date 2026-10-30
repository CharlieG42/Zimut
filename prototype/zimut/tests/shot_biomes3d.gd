extends SceneTree
## Captures du monde 3D de chaque Nation (vue de jeu + vue rasante), une image par zone.
##   xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_biomes3d.gd -- <dossier> [zone1,zone2,…]
const ZONES := ["foret_sylve", "montagne_pics", "desert_dunes", "vents_plateau", "brumes_marais", "brasier_cendres",
	"ombres_necropole", "cristaux_caverne", "marees_cotes", "rouages_atelier", "portes_donjon", "lisiere_col"]

func _init() -> void:
	_boot.call_deferred()

func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var out: String = args[0]
	var zones: Array = ZONES if args.size() < 2 else Array(args[1].split(","))
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	root.get_node("GameSettings").adventure_models_3d = true
	for zone: String in zones:
		var data: Dictionary = pm.new_game(4, "Biomes")
		pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
		data["campaign_mode"] = "adventure"
		var adv: Dictionary = pm.adventure_state(data)
		pm.adventure_unlock_zone(adv, zone)
		pm.adventure_enter_zone(adv, zone)
		gm.active_save = data
		gm.active_slot = 4
		var sc: Node = (load("res://scenes/Adventure3D.tscn") as PackedScene).instantiate()
		root.add_child(sc)
		await create_timer(0.6).timeout
		sc._hud.visible = false
		var ex: Adv3DExplorer = sc.explorer
		var t: Dictionary = AdventureTerrain.zone_terrain(zone)
		var size: Vector2i = t["size"]
		ex.place_at(Adv3DWorld.cell_center(Vector2i(size.x / 2, size.y / 2)) if Adv3DWorld.point_walkable(t, Adv3DWorld.cell_center(Vector2i(size.x / 2, size.y / 2))) else Adv3DWorld.cell_center(t["start"]))
		sc._companion.place_near_target()
		ex.yaw = 0.7
		ex._cam_yaw = 0.7
		ex.pitch = -0.62
		ex.distance = 14.0
		await create_timer(1.2).timeout
		root.get_texture().get_image().save_png(out + "/b3d_%s.png" % zone)
		sc.queue_free()
		await process_frame
	pm.delete_save(4)
	quit(0)
