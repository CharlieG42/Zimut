extends SceneTree
## V152 : mesure de la difficulté — combats automatiques (IA des deux côtés), équipement tiré au sort.
## Usage : xvfb-run -a godot --path . -s tests/sim_difficulte.gd -- <difficulté 0-3> <niveau héros> <n combats> [Classe,Classe,Classe] [victoires] [ia]
##   victoires : 1er combat joué = victoires+1 (chaque combat suivant avance de 3)
##   ia : « old » (ancienne IA partout), « new » (héros sur l'ancienne IA, ennemis sur la nouvelle — défaut),
##        « all » (nouvelle IA partout, comme le mode Auto du jeu)
## Sortie : une ligne par combat puis « RÉSUMÉ » (victoires, tours moyens, PV restants moyens, héros tombés).
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var diff: int = int(args[0]) if args.size() > 0 else 1
	var lvl: int = int(args[1]) if args.size() > 1 else 10
	var n: int = int(args[2]) if args.size() > 2 else 4
	var team: Array = ["Tank", "Mage", "Heal"]
	if args.size() > 3 and args[3] != "":
		team = Array(args[3].split(","))
	var vic: int = int(args[4]) if args.size() > 4 else 0
	var ia: String = args[5] if args.size() > 5 else "new"
	var TM: GDScript = load("res://scripts/TurnManager.gd")
	match ia:
		"old":
			TM.legacy_teams = ["player", "enemy"]
		"all":
			TM.legacy_teams = []
		_:
			TM.legacy_teams = ["player"]
	Engine.time_scale = 16.0
	root.get_node("GameSettings").speed_override = 16.0
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	var wins: int = 0
	var turns_sum: int = 0
	var hp_sum: float = 0.0
	var fallen_sum: int = 0
	for k in range(n):
		seed(1000 + k)
		var data: Dictionary = pm.new_game(4, "Sim")
		pm.rebuild_team(data, team)
		for c in team:
			var e: Dictionary = pm._new_entry(lvl)
			e["unspent"] = ClassRules.auto_allocate(c, e["invested"], int(e["unspent"]))
			data["roster"][c] = e
		pm.ensure_roster(data)
		data["victories"] = vic + 3 * k
		data["difficulty"] = diff
		data["diff_v"] = root.get_node("GameSettings").DIFFICULTY_VERSION
		for _i in range(4):
			for it in pm._roll_loots(lvl, false):
				data["inventory"].append(it)
		pm.auto_equip(data)
		gm.active_save = data
		gm.active_slot = 4
		var ct: Array = []
		for c2 in team:
			ct.append({"classe": c2})
		gm.set_custom_team(ct)
		gm.auto_mode = true
		var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
		root.add_child(main)
		var t0: int = Time.get_ticks_msec()
		while not gm.game_over and Time.get_ticks_msec() - t0 < 300000:
			await create_timer(0.5).timeout
		var hp_now: float = 0.0
		var hp_max: float = 0.0
		var fallen: int = 0
		for e0 in gm.players:
			if e0.get("team", "") == "player" and e0.get("entity_type", "") != "Summon":
				hp_now += maxf(0.0, float(e0.get("current_pv", 0)))
				hp_max += float(e0.get("max_pv", 1))
				if int(e0.get("current_pv", 0)) <= 0:
					fallen += 1
		fallen += maxi(0, team.size() - gm.players.filter(func(x: Dictionary) -> bool: return x.get("team", "") == "player" and x.get("entity_type", "") != "Summon").size())
		var pct: float = 100.0 * hp_now / maxf(1.0, hp_max) if gm.victory else 0.0
		print("combat %d : %s en %d tours, PV restants %d %%, héros tombés %d" % [k, "VICTOIRE" if gm.victory else ("DÉFAITE" if gm.game_over else "TIMEOUT"), gm.turn_count, int(pct), fallen])
		if gm.victory:
			wins += 1
		turns_sum += int(gm.turn_count)
		hp_sum += pct
		fallen_sum += fallen
		main.queue_free()
		await create_timer(0.3).timeout
		gm.game_over = false
	print("RÉSUMÉ ia=%s diff=%d niv=%d équipe=%s : %d/%d victoires, %.1f tours, PV restants %.0f %%, %.2f héros tombés / combat" % [
		ia, diff, lvl, ",".join(team), wins, n, float(turns_sum) / n, hp_sum / n, float(fallen_sum) / n])
	pm.delete_save(4)
	quit(0)
