extends SceneTree
## V115 — Captures in-engine de la carte 2D Sylve « Diorama » (scène 3D pré-rendue HD-2D).
## Nécessite un écran virtuel :
##   xvfb-run -a -s "-screen 0 1920x1080x24" godot --rendering-method gl_compatibility --path . -s tests/shot_sylve_diorama.gd -- <dossier>
## Produit : diorama_depart.png, diorama_place.png, diorama_derriere.png, diorama_lac.png, diorama_ruines.png
func _init() -> void:
	_boot.call_deferred()

func _shot(path: String) -> void:
	await RenderingServer.frame_post_draw
	root.get_viewport().get_texture().get_image().save_png(path)
	print("capture ", path)

func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var out: String = args[0] if args.size() > 0 else "/tmp"
	var zone: String = "foret_sylve"
	var pm: Node = root.get_node("/root/ProgressionManager")
	var gm: Node = root.get_node("/root/GameManager")
	var gs: Node = root.get_node("/root/GameSettings")
	var BA: GDScript = load("res://scripts/BoardArt.gd")
	var AT: GDScript = load("res://scripts/AdventureTerrain.gd")
	var data: Dictionary = pm.new_game(4, "ShotSylveDiorama")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "adventure"
	data["adventure_view"] = "map"
	gm.active_save = data
	gm.active_slot = 4
	var before: String = gs.sylvestre_board
	gs.set_sylvestre_board("diorama")
	var adv: Dictionary = pm.adventure_state(data)
	pm.adventure_unlock_zone(adv, zone)
	pm.adventure_enter_zone(adv, zone)
	var st: Vector2i = BA.start(zone)
	for y in range(144):
		for x in range(144):
			adv["discovered"].append("%s,%d,%d" % [zone, x, y])
	adv["hero_pos"] = [st.x, st.y]
	var sc: Node = (load("res://scenes/AdventureMap.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(1.5).timeout
	await _shot(out + "/diorama_depart.png")
	print("départ ", st, " héros ", sc.manager.hero_pos())
	# héros posé à d'autres endroits : place du village, puis derrière une maison (occultation)
	var spots: Dictionary = {"place": Vector2i(72, 66), "derriere": Vector2i(int(args[1]), int(args[2])) if args.size() > 2 else Vector2i(60, 57), "lac": Vector2i(118, 36), "ruines": Vector2i(26, 26)}
	for nm: String in spots.keys():
		var dest: Vector2i = spots[nm]
		sc.manager.state["hero_pos"] = [dest.x, dest.y]
		sc._hero.position = sc.cell_center(dest)
		sc._apply_hero_depth(dest)
		sc._focus_cell(dest, false)
		sc._dio_sync = true
		await create_timer(0.6).timeout
		await _shot(out + "/diorama_%s.png" % nm)
	# V118 : le Brasier (Terres de Cendre) et ses donjons
	if args.has("brasier"):
		adv["zones_unlocked"] = ["foret_sylve", "brasier_cendres"]
		pm.adventure_enter_zone(adv, "brasier_cendres")
		sc._rebuild_world()
		sc._refresh_world()
		sc._fit_world.call_deferred()
		await create_timer(1.5).timeout
		var BA2: GDScript = load("res://scripts/BoardArt.gd")
		var shots := {"brasier_depart": BA2.start("brasier_cendres")}
		for k: String in BA2.pois("brasier_cendres").keys():
			var nm: String = String(BA2.pois("brasier_cendres")[k]["name"])
			if nm in ["Donjon de la Nation Brasier", "Fosse Ardente", "Mine de Braise"]:
				shots["brasier_" + nm.split(" ")[0].to_lower() + "_" + nm.split(" ")[-1].to_lower()] = AT.parse(k) + Vector2i(1, 1)
		for nm: String in shots.keys():
			var dest: Vector2i = shots[nm]
			sc.manager.state["hero_pos"] = [dest.x, dest.y]
			sc._hero.position = sc.cell_center(dest)
			sc._apply_hero_depth(dest)
			sc._focus_cell(dest, false)
			sc._dio_sync = true
			await create_timer(0.8).timeout
			await _shot(out + "/%s.png" % nm)
	gs.set_sylvestre_board(before)
	pm.delete_save(4)
	quit(0)
