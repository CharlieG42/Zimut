extends SceneTree
## Captures du Monde Ouvert 3D : vue de jeu + vue haute (relief) pour quelques nations, puis les cartes.
##   xvfb-run -a -s "-screen 0 1920x1080x24" godot --rendering-method gl_compatibility --path . -s tests/shot_openworld.gd -- <dossier> [zone,zone…]
func _init() -> void:
	_boot.call_deferred()
func _shot(p: String) -> void:
	root.get_viewport().get_texture().get_image().save_png(p)
func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var out: String = args[0]
	var zones: PackedStringArray = args[1].split(",") if args.size() > 1 else PackedStringArray(["foret_sylve"])
	# Pas de référence statique à AdventureTerrain : il utilise l'autoload ProgressionManager (absent à la compilation d'un -s)
	var AT: GDScript = load("res://scripts/AdventureTerrain.gd")
	var W: GDScript = load("res://scripts/adventure3d/Adv3DWorld.gd")
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	for zone: String in zones:
		var data: Dictionary = pm.new_game(4, "OW")
		pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
		data["campaign_mode"] = "adventure"
		var adv: Dictionary = pm.adventure_state(data)
		for z: String in pm.ADVENTURE_ZONES.keys():
			pm.adventure_unlock_zone(adv, z)
		pm.adventure_enter_zone(adv, zone)
		data["adventure_view"] = "open3d"
		gm.active_save = data
		gm.active_slot = 4
		var sc: Node = (load("res://scenes/AdventureOpen3D.tscn") as PackedScene).instantiate()
		root.add_child(sc)
		await create_timer(1.6).timeout
		_shot("%s/ow_%s_jeu.png" % [out, zone])
		var t: Dictionary = AT.zone_terrain(zone)
		var mid := Vector2i((t["size"] as Vector2i).x / 2, (t["size"] as Vector2i).y / 2)
		for dd: int in range(0, 30):
			var c: Vector2i = mid + Vector2i(dd % 5 - 2, dd / 5 - 2)
			if AT.walkable(zone, c):
				mid = c
				break
		sc.explorer.place_at(W.cell_center(mid))
		sc.explorer.pitch = -0.40
		sc.explorer.distance = 17.0
		sc.explorer.yaw = 0.5
		sc.explorer._cam_yaw = 0.5
		await create_timer(1.2).timeout
		_shot("%s/ow_%s_pano.png" % [out, zone])
		sc.explorer.pitch = -0.85
		sc.explorer.distance = 75.0
		await create_timer(1.2).timeout
		_shot("%s/ow_%s_haut.png" % [out, zone])
		if zone == zones[0]:
			sc._open_full_map()
			await create_timer(0.5).timeout
			_shot("%s/ow_carte_instance.png" % out)
			sc._toggle_full_map_tab()
			await create_timer(0.5).timeout
			_shot("%s/ow_carte_monde.png" % out)
		sc.queue_free()
		await create_timer(0.3).timeout
	pm.delete_save(4)
	quit(0)
