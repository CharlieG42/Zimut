extends SceneTree
## Aperçu du joueur et de Gligli en vraie 3D low-poly (Adv3DHeroModel), sous plusieurs angles.
##   xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_modele3d.gd -- <dossier> [zone]
func _init() -> void:
	_boot.call_deferred()
func _shot(path: String) -> void:
	root.get_texture().get_image().save_png(path)
func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var out: String = args[0]
	var zone: String = args[1] if args.size() > 1 else "foret_sylve"
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	var data: Dictionary = pm.new_game(4, "Modele3D")
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
	await create_timer(1.0).timeout
	var ex: Adv3DExplorer = sc.explorer
	# on remplace les illustrations par les modèles 3D
	ex._model.queue_free()
	ex._sprite = null
	var hero: Node3D = Adv3DHeroModel.make_hero()
	ex.add_child(hero)
	ex._model = hero
	sc._companion.visible = false
	sc._companion.set_process(false)
	var gl: Node3D = Adv3DHeroModel.make_gligli()
	gl.scale = Vector3.ONE * 0.95
	sc.add_child(gl)
	sc._hud.visible = false
	# un endroit dégagé : la case de départ
	var t: Dictionary = AdventureTerrain.zone_terrain(zone)
	ex.place_at(Adv3DWorld.cell_center(t["start"]))
	var views: Array = [["face", 0.0, -0.22, 4.4], ["trois_quarts", 0.75, -0.25, 4.4], ["profil", 1.57, -0.2, 4.4], ["dos", 3.14, -0.25, 4.4],
		["dessus", 0.3, -1.3, 8.0], ["jeu", 0.6, -0.82, 10.5]]
	for v: Array in views:
		ex.yaw = float(v[1])
		ex.pitch = float(v[2])
		ex.distance = float(v[3])
		ex._place_camera(1.0)
		hero.rotation.y = 0.0
		var fwd := Vector3(0, 0, 1)
		gl.position = ex.position + Basis(Vector3.UP, float(v[1])) * Vector3(1.0, 0.0, 0.5)
		gl.rotation.y = float(v[1]) - 0.5
		hero.rotation.y = float(v[1]) if v[0] == "jeu" else 0.0
		await create_timer(0.5).timeout
		_shot(out + "/m3d_%s.png" % v[0])
	pm.delete_save(4)
	quit(0)
