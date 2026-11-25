extends SceneTree
## V453 : équipes de 1, 2 ou 3 héros (ennemis inchangés), bonus d'XP/or pour une petite équipe, bouton COMBATTRE dès 1 héros.
var fails: int = 0
func ck(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c: fails += 1

func _init() -> void:
	_run.call_deferred()

func _run() -> void:
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	ck(is_equal_approx(ClassRules.small_team_bonus(1), 1.5), "bonus 1 héros = ×1,5")
	ck(is_equal_approx(ClassRules.small_team_bonus(2), 1.2), "bonus 2 héros = ×1,2")
	ck(is_equal_approx(ClassRules.small_team_bonus(3), 1.0), "aucun bonus à 3 héros")
	for n: int in [1, 2, 3]:
		var classes: Array = ["Tank", "Mage", "Sylvain"].slice(0, n)
		var data: Dictionary = pm.new_game(4, "T%d" % n)
		pm.rebuild_team(data, classes)
		gm.active_save = data
		gm.active_slot = 4
		var ct: Array = []
		for c: String in classes:
			ct.append({"classe": c})
		gm.set_custom_team(ct)
		gm.auto_mode = false
		var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
		root.add_child(main)
		await create_timer(0.8).timeout
		ck(gm.players.size() == n, "%d héros : %d allié(s) sur le plateau" % [n, gm.players.size()])
		ck(gm.enemies.size() == 4, "%d héros : toujours 4 ennemis (%d)" % [n, gm.enemies.size()])
		var cls_ok := true
		for i: int in range(n):
			if String(gm.players[i].get("classe", "")) != classes[i]: cls_ok = false
		ck(cls_ok, "%d héros : bonnes classes (%s)" % [n, str(classes)])
		# récompense : l'or d'une victoire suit le bonus
		var before: int = int(data.get("gold", 0))
		pm.register_victory(data, {})
		var gain: int = int(data.get("gold", 0)) - before
		ck(is_equal_approx(float(data.get("last_team_bonus", 0.0)), ClassRules.small_team_bonus(n)), "%d héros : bonus enregistré ×%.1f (or +%d)" % [n, float(data.get("last_team_bonus", 0.0)), gain]) 
		main.queue_free()
		await process_frame
		gm.clear_custom_team()
	# écran d'équipe : COMBATTRE actif dès 1 héros
	var d: Dictionary = pm.new_game(4, "Sel")
	pm.rebuild_team(d, ["Tank"])
	gm.active_save = d
	gm.active_slot = 4
	var ts: Node = (load("res://scenes/TeamSelection.tscn") as PackedScene).instantiate()
	root.add_child(ts)
	await process_frame
	ts.team.clear()
	ts.team.append("Tank")
	ts.refresh()
	ck(ts.team.size() == 1 and not ts._fight_btn.disabled, "écran d'équipe : 1 héros suffit pour COMBATTRE")
	ts.team.clear()
	ts.refresh()
	ck(ts._fight_btn.disabled, "0 héros : COMBATTRE désactivé")
	pm.delete_save(4)
	print("FIN : %d échec(s)" % fails)
	quit(1 if fails > 0 else 0)
