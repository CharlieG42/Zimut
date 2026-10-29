extends SceneTree
## Captures du monde d'Aventure 3D (écran virtuel) :
##   xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_adventure3d.gd -- <dossier> [zone]
## Produit : vue de départ, vue au milieu de la carte (caméra tournée), contact avec un groupe.
func _init() -> void:
	_boot.call_deferred()
func _shot(path: String) -> void:
	var img: Image = root.get_texture().get_image()
	img.save_png(path)
	print("capture : ", path)
func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var out: String = args[0]
	var zone: String = args[1] if args.size() > 1 else "foret_sylve"
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	var data: Dictionary = pm.new_game(4, "Capture3D")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "adventure"
	var adv: Dictionary = pm.adventure_state(data)
	for z: String in ["foret_ronces", "lisiere_col", "montagne_pics", "piemont_ocre", "desert_dunes", zone]:
		pm.adventure_unlock_zone(adv, z)
	pm.adventure_enter_zone(adv, zone)
	gm.active_save = data
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/Adventure3D.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(1.5).timeout
	_shot(out + "/a3d_depart.png")
	var t: Dictionary = AdventureTerrain.zone_terrain(zone)
	var mid := Vector2i((t["size"] as Vector2i).x / 2, (t["size"] as Vector2i).y / 2)
	for dd: int in range(0, 8):
		var c: Vector2i = mid + Vector2i(dd % 3 - 1, dd / 3 - 1)
		if AdventureTerrain.walkable(zone, c):
			mid = c
			break
	sc.explorer.place_at(Adv3DWorld.cell_center(mid))
	sc.explorer.yaw = 0.6
	await create_timer(1.0).timeout
	_shot(out + "/a3d_milieu.png")
	var mobs: Array = sc.manager.mobs()
	if not mobs.is_empty():
		var n: Node3D = sc._mob_nodes[int(mobs[0]["id"])]
		sc._declined_mobs.clear()
		sc.explorer.place_at(Vector3(n.position.x, 0.0, n.position.z - 3.5))
		sc.explorer.yaw = 0.0
		await create_timer(1.0).timeout
		_shot(out + "/a3d_groupe.png")
	pm.delete_save(4)
	quit(0)
