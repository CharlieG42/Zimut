extends SceneTree
## Simulation IA contre IA de N combats d'affilée avec progression complète
## (XP, points auto-répartis, loots équipés automatiquement).
## Usage : godot --headless --path prototype/zimut -s tests/sim_progression.gd -- Tank,Assassin,Mage 30
var gm: Node
var pm: Node
var done: bool = false
var won: bool = false

func _init() -> void:
	_boot.call_deferred()

func _boot() -> void:
	gm = root.get_node("GameManager")
	pm = root.get_node("ProgressionManager")
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var classes: PackedStringArray = (args[0] if args.size() > 0 else "Tank,Assassin,Mage").split(",")
	var fights: int = int(args[1]) if args.size() > 1 else 24
	Engine.time_scale = 60.0
	var tm: Node = load("res://scripts/TurnManager.gd").new()
	root.add_child(tm)
	tm.init(gm)
	gm.game_ended.connect(func(v: bool) -> void:
		won = v
		done = true)
	var quick: bool = args.size() > 2 and args[2] == "quick"
	# Mode « niveau fixe » : lvl:30 ou lvl:30:boss -> mesure le taux de victoire à ce niveau
	var fixed_lvl: int = 0
	var fixed_boss: bool = false
	if args.size() > 2 and args[2].begins_with("lvl:"):
		var parts: PackedStringArray = args[2].split(":")
		fixed_lvl = int(parts[1])
		fixed_boss = parts.size() > 2 and parts[2] == "boss"
	var data: Dictionary = pm.new_game(4, "Sim")
	pm.rebuild_team(data, Array(classes))
	gm.active_save = {} if quick else data
	gm.active_slot = -1 if quick else 4
	gm.auto_mode = true
	var wins: int = 0
	var turns_sum: int = 0
	for f: int in range(fights):
		if fixed_lvl > 0:
			_set_level(data, classes, fixed_lvl, fixed_boss)
		if not quick and fixed_lvl == 0:
			_auto_equip(data)
		var elvl: int = pm.enemy_level_for(data)
		var boss: bool = pm.is_boss_fight(data)
		var lv_before: Array = []
		for m: Dictionary in data["team"]:
			lv_before.append(pm.member_level(data, m["classe"]))
		var cls: Array = []
		for c in classes:
			cls.append({"classe": c})
		gm.set_custom_team(cls)
		done = false
		gm.reset_game()
		var guard: float = 0.0
		while not done and guard < 400.0:
			await create_timer(0.5).timeout
			guard += 0.5 * Engine.time_scale / 60.0 * 60.0 / 60.0
			if gm.turn_count > 45:
				break
		var res: Dictionary = data.get("last_result", {}) if not quick else {}
		var xp_gain: int = 0
		for c in classes:
			xp_gain = maxi(xp_gain, int(res.get("xp", {}).get(c, {}).get("gain", 0)))
		if not done:
			# combat bloqué : on force la défaite pour ne pas boucler
			gm.game_over = true
			if not quick:
				pm.register_defeat(data, {"enemies": gm.fight_enemies, "turns": gm.turn_count})
			won = false
		if won:
			wins += 1
		turns_sum += gm.turn_count
		print("combat %2d%s  ennemis nv%2d  équipe nv%s  %s  tours:%2d  xp:+%d  inv:%d" % [
			f + 1, " ☠" if boss else "  ", elvl, str(lv_before), "VICTOIRE" if won else "défaite ", gm.turn_count, xp_gain, data["inventory"].size()])
		pm.write_save(4, data)
	print("== %d victoires / %d combats, %.1f tours en moyenne" % [wins, fights, float(turns_sum) / float(fights)])
	for c in classes:
		var e: Dictionary = pm.roster_entry(data, c)
		print("  %s niv %d  xp %d  capital:%d  investi:%s" % [c, e["level"], e["xp"], e["unspent"], str(e["invested"])])
	pm.delete_save(4)
	quit(0)

func _set_level(data: Dictionary, classes: PackedStringArray, lvl: int, boss: bool) -> void:
	for c in classes:
		var e: Dictionary = pm.roster_entry(data, c)
		e["level"] = lvl
		e["xp"] = pm.xp_for_level(lvl)
		e["invested"] = {}
		e["unspent"] = ClassRules.auto_allocate(c, e["invested"], ClassRules.total_points_for_level(lvl))
		for m: Dictionary in data["team"]:
			if m["classe"] == c:
				m["equipment"] = {}
	data["inventory"] = []
	data["victories"] = 3 if boss else 0
	data["level"] = lvl
	# équipement « moyen » : l'équivalent d'environ 2 combats de loots par membre de l'équipe
	for _i in range(7):
		for it in pm._roll_loots(lvl, false):
			data["inventory"].append(it)
	pm.auto_equip(data)

func _auto_equip(data: Dictionary) -> void:
	var guard: int = 0
	var changed: bool = true
	while changed and guard < 60:
		guard += 1
		changed = false
		var inv: Array = data["inventory"]
		for mi: int in range(data["team"].size()):
			var member: Dictionary = data["team"][mi]
			for ii: int in range(inv.size()):
				var it: Dictionary = inv[ii]
				var slot: String = pm.slot_for_type(it["type"])
				if slot == "":
					continue
				var cur: Dictionary = member.get("equipment", {}).get(slot, {})
				if cur.is_empty() or ItemRules.power(it) > ItemRules.power(cur):
					if pm.equip_item(data, mi, ii) == "":
						changed = true
						break
			if changed:
				break
