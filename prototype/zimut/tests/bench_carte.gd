extends SceneTree
## Mesures de fluidité de la carte d'aventure (pas un test CI : chiffres à comparer avant / après).
##   godot --headless --path . -s tests/bench_carte.gd            (calculs : chemins, pas, sauvegarde)
##   xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/bench_carte.gd -- gpu   (+ mémoire des textures)
func _init() -> void:
	_boot.call_deferred()

func _us() -> int:
	return Time.get_ticks_usec()

func _boot() -> void:
	var gpu: bool = OS.get_cmdline_user_args().has("gpu")
	var pm: Node = root.get_node("/root/ProgressionManager")
	var gm: Node = root.get_node("/root/GameManager")
	var gs: Node = root.get_node("/root/GameSettings")
	var AT: GDScript = load("res://scripts/AdventureTerrain.gd")
	var before: String = gs.sylvestre_board
	for variant: String in ["diorama", "v2"]:
		gs.set_sylvestre_board(variant)
		var data: Dictionary = pm.new_game(4, "Bench")
		data["campaign_mode"] = "adventure"
		data["adventure_view"] = "map"
		gm.active_save = data
		gm.active_slot = 4
		var adv: Dictionary = pm.adventure_state(data)
		pm.adventure_unlock_zone(adv, "foret_sylve")
		pm.adventure_enter_zone(adv, "foret_sylve")
		# carte déjà bien explorée : 12 000 cases dans la liste des découvertes
		var disc: Array = adv.get("discovered", [])
		for i in range(12000):
			disc.append("foret_sylve,%d,%d" % [i % 140, i / 140])
		adv["discovered"] = disc
		var sc: Node = (load("res://scenes/AdventureMap.tscn") as PackedScene).instantiate()
		root.add_child(sc)
		await create_timer(0.6).timeout
		var m: Node = sc.manager
		var hp: Vector2i = m.hero_pos()
		var sz: Vector2i = m.zone_size()
		var tag := "[%s %dx%d] " % [variant, sz.x, sz.y]
		# chemin lointain
		var best := hp
		var bd := 0
		for y in range(0, sz.y, 3):
			for x in range(0, sz.x, 3):
				var c := Vector2i(x, y)
				var d: int = absi(c.x - hp.x) + absi(c.y - hp.y)
				if d > bd and d < 60 and AT.walkable("foret_sylve", c):
					bd = d
					best = c
		var t0 := _us()
		var p: Array = []
		for k in range(5):
			p = m.path_to(best)
		print(tag, "chemin (", p.size(), " pas) : %.1f ms" % ((_us() - t0) / 5000.0))
		var nb: Vector2i = hp
		for d2: Vector2i in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
			if m.can_move_to(hp + d2):
				nb = hp + d2
				break
		t0 = _us()
		m.move_hero(nb)
		print(tag, "un pas (move_hero + sauvegarde) : %.1f ms" % ((_us() - t0) / 1000.0))
		if gpu and variant == "diorama":
			await create_timer(1.0).timeout
			sc.set_process(false)
			for ch: Dictionary in sc._dio_chunks:
				for s2: Sprite2D in ch["sprites"]:
					s2.texture = null
			if sc.get("_dio_low") != null and sc._dio_low != null:
				sc._dio_low.texture = null
			await create_timer(0.5).timeout
			var mem0: float = Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED)
			t0 = _us()
			for ch: Dictionary in sc._dio_chunks:
				var tex: Texture2D = load(String(ch["path"]))
				for s2: Sprite2D in ch["sprites"]:
					s2.texture = tex
			var dt: float = (_us() - t0) / 1000.0
			await create_timer(0.5).timeout
			var mem1: float = Performance.get_monitor(Performance.RENDER_TEXTURE_MEM_USED)
			print(tag, "carte entière : %d morceaux chargés en %.0f ms (%.1f ms / morceau) ; mémoire des textures +%.0f Mo" % [sc._dio_chunks.size(), dt, dt / sc._dio_chunks.size(), (mem1 - mem0) / 1048576.0])
		sc.queue_free()
		await process_frame
		pm.delete_save(4)
	gs.set_sylvestre_board(before)
	quit(0)
