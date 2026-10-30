extends SceneTree
## Captures du joueur et de Gligli en vraie 3D (repos, marche, course, assis, réactions), en jeu.
##   xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_modele3d.gd -- <dossier> [zone]
## Produit m3d_<pose>.png dans <dossier>.

var sc: Node
var ex: Adv3DExplorer
var out: String


func _init() -> void:
	_boot.call_deferred()


func _shot(nm: String) -> void:
	await process_frame
	root.get_texture().get_image().save_png(out + "/m3d_%s.png" % nm)


func _cam(yaw: float, pitch: float, dist: float) -> void:
	ex.yaw = yaw
	ex.pitch = pitch
	ex.distance = dist
	ex._cam_yaw = yaw


func _run(input: Vector2, seconds: float) -> void:
	sc._stick.value = input
	await create_timer(seconds).timeout


func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	out = args[0]
	var zone: String = args[1] if args.size() > 1 else "foret_sylve"
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	root.get_node("GameSettings").adventure_models_3d = true
	var data: Dictionary = pm.new_game(4, "Modele3D")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "adventure"
	var adv: Dictionary = pm.adventure_state(data)
	pm.adventure_enter_zone(adv, zone)
	gm.active_save = data
	gm.active_slot = 4
	sc = (load("res://scenes/Adventure3D.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(0.8).timeout
	ex = sc.explorer
	sc._hud.visible = false
	var t: Dictionary = AdventureTerrain.zone_terrain(zone)
	ex.place_at(Adv3DWorld.cell_center(t["start"]))
	sc._companion.place_near_target()

	# repos : face puis trois-quarts, Gligli assis
	ex._facing = 0.4
	ex._model.rotation.y = 0.4
	_cam(0.4, -0.2, 4.6)
	await create_timer(4.0).timeout
	await _shot("repos_face")
	_cam(1.2, -0.25, 4.6)
	await create_timer(0.6).timeout
	await _shot("repos_34")
	_cam(0.4 + PI, -0.3, 4.6)
	await create_timer(0.6).timeout
	await _shot("repos_dos")
	# marche (stick à moitié) vue de profil : 3 images successives
	_cam(0.4, -0.18, 4.8)
	await _run(Vector2(0.45, 0.0), 1.2)
	for i: int in range(3):
		await _shot("marche_%d" % i)
		await create_timer(0.11).timeout
	# course (stick à fond) vue de profil
	await _run(Vector2(1.0, 0.0), 1.2)
	for i: int in range(3):
		await _shot("course_%d" % i)
		await create_timer(0.08).timeout
	# course vers la caméra (trois-quarts face)
	await _run(Vector2(0.6, 0.8), 0.9)
	await _shot("course_face")
	# vue de dessus en marchant
	_cam(ex.yaw, -1.25, 7.5)
	await _run(Vector2(0.0, -0.6), 0.8)
	await _shot("dessus")
	# vue de jeu
	_cam(ex.yaw, -0.82, 10.5)
	await _run(Vector2(-0.7, -0.7), 0.8)
	await _shot("jeu")
	# arrêt, Gligli content
	await _run(Vector2.ZERO, 1.2)
	_cam(ex._facing, -0.22, 4.4)
	await create_timer(0.4).timeout
	sc._companion.emote("heureux")
	await create_timer(0.22).timeout
	await _shot("gligli_heureux")
	pm.delete_save(4)
	quit(0)
