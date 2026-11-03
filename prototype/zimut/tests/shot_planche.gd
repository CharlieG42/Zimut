extends SceneTree
## Captures de la planche 2D (V83) : vue de départ puis près d'une entrée de donjon.
##   xvfb-run -a -s "-screen 0 1920x1080x24" godot --rendering-method gl_compatibility --path . -s tests/shot_planche.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _shot(p: String) -> void:
	root.get_viewport().get_texture().get_image().save_png(p)
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	var BA: GDScript = load("res://scripts/BoardArt.gd")
	var AT: GDScript = load("res://scripts/AdventureTerrain.gd")
	var data: Dictionary = pm.new_game(4, "PL")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "adventure"
	var adv: Dictionary = pm.adventure_state(data)
	adv["zone"] = "foret_sylve"
	adv["hero_pos"] = [36, 23]
	data["adventure_view"] = "map"
	gm.active_save = data
	gm.active_slot = 4
	BA.enabled = true
	var sc: Node = (load("res://scenes/AdventureMap.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(1.5).timeout
	_shot("%s/pl_depart.png" % out)
	# près de chaque entrée de donjon
	var pois: Dictionary = pm.pois_of("foret_sylve")
	var n: int = 0
	for k: String in pois.keys():
		if String(pois[k].get("guardian", "")) == "":
			continue
		var c: Vector2i = AT.parse(k)
		sc.manager.state["hero_pos"] = [c.x, c.y]
		sc._hero.position = sc.cell_center(c)
		sc._recenter(false)
		sc._refresh_world()
		await create_timer(0.5).timeout
		_shot("%s/pl_donjon_%d.png" % [out, n])
		if n == 0:
			sc._interact()
			await create_timer(0.5).timeout
			_shot("%s/pl_modal_donjon.png" % out)
			sc._close_modal()
		n += 1
		if n >= 3:
			break
	pm.delete_save(4)
	quit(0)
