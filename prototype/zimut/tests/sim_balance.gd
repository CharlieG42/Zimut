extends SceneTree
## Simulation d'équilibrage : combats automatiques (IA des deux côtés), sans équipement.
## Usage : xvfb-run -a godot --path . -s tests/sim_balance.gd -- <victoires> <niveau héros> <n combats>
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var vic: int = int(args[0]) if args.size() > 0 else 0
	var lvl: int = int(args[1]) if args.size() > 1 else 1
	var n: int = int(args[2]) if args.size() > 2 else 3
	Engine.time_scale = 16.0
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	var wins: int = 0
	var turns: Array = []
	for k in range(n):
		var data: Dictionary = pm.new_game(4, "Sim")
		pm.rebuild_team(data, ["Tank", "Mage", "Heal"])
		for c in ["Tank", "Mage", "Heal"]:
			var e: Dictionary = pm._new_entry(lvl)
			e["unspent"] = ClassRules.auto_allocate(c, e["invested"], int(e["unspent"]))
			data["roster"][c] = e
		pm.ensure_roster(data)
		data["victories"] = vic
		if args.size() > 3 and args[3] == "gear":
			for _i in range(4):
				for it in pm._roll_loots(lvl, false):
					data["inventory"].append(it)
			pm.auto_equip(data)
		gm.active_save = data
		gm.active_slot = 4
		gm.set_custom_team([{"classe": "Tank"}, {"classe": "Mage"}, {"classe": "Heal"}])
		gm.auto_mode = true
		print("niveau ennemis : ", pm.enemy_level_for(data))
		var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
		root.add_child(main)
		var t0: int = Time.get_ticks_msec()
		while not gm.game_over and Time.get_ticks_msec() - t0 < 240000:
			await create_timer(0.5).timeout
		var alive: int = 0
		for e in gm.players:
			if e.get("team", "") == "player" and int(e.get("current_pv", 0)) > 0 and e.get("entity_type", "") != "Summon":
				alive += 1
		print("combat %d : %s en %d tours, héros debout %d" % [k, "VICTOIRE" if gm.victory else ("DÉFAITE" if gm.game_over else "TIMEOUT"), gm.turn_count, alive])
		if gm.victory:
			wins += 1
		turns.append(gm.turn_count)
		main.queue_free()
		await create_timer(0.3).timeout
		gm.game_over = false
	print("RÉSUMÉ victoires=%d niveau=%d : %d/%d gagnés, tours %s" % [vic, lvl, wins, n, str(turns)])
	pm.delete_save(4)
	quit(0)
