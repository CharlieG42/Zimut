extends SceneTree
## Régression : les pouvoirs de héros qui demandent une cible (Tir précis, Frappe sournoise, Bombe, Appel de la meute)
## ne plantent plus l'interface (aperçu de cible sans créature source) et s'appliquent.
var fails: int = 0

func check(ok: bool, label: String) -> void:
	if ok:
		print("  ok  ", label)
	else:
		fails += 1
		print("  ÉCHEC  ", label)

func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	Engine.time_scale = 4.0
	await create_timer(0.8).timeout
	var pm = root.get_node("ProgressionManager")
	var gm = root.get_node("GameManager")
	root.get_node("GameSettings").tutorial_enabled = false
	pm.write_save(3, pm.new_game(3, "Capture"))
	gm.active_save = pm.load_save(3)
	gm.active_slot = 3
	var m = load("res://scenes/CardDuel.tscn").instantiate()
	root.add_child(m)
	current_scene = m
	await create_timer(0.6).timeout
	for k in ["chasseur", "assassin", "artificier", "invocateur"]:
		m._start_duel(0)
		await create_timer(0.4).timeout
		var d = m._duel
		d.side(0)["power"] = JccDuel.HERO_POWERS[k].duplicate()
		d.side(0)["power_used"] = false
		d.side(1)["units"] = []
		d.side(0)["units"] = []
		d.place_unit(1, "e_golem", 1, 1)
		var cell: int = d.xy_cell(1, 1)
		var hp0: int = int(d.creature_at(1, cell)["hp"])
		m._refresh()
		m._on_power_pressed()
		await create_timer(0.2).timeout
		check(not m._pending.is_empty() and not m._targets.is_empty(), "%s : le pouvoir attend une cible (%d cibles)" % [k, m._targets.size()])
		if k == "invocateur":
			var lane: int = d.xy_cell(1, 4)
			m._on_board_card(0, lane)
			await create_timer(1.2).timeout
			check(d.creature_at(0, lane) != null, "%s : la créature est invoquée" % k)
		else:
			m._on_board_card(1, cell)
			await create_timer(1.2).timeout
			var after: Variant = d.creature_at(1, cell)
			check(after == null or int(after["hp"]) < hp0, "%s : la cible a subi des dégâts" % k)
		check(bool(d.side(0)["power_used"]), "%s : pouvoir consommé" % k)
	print("FIN : %d échec(s)" % fails)
	quit(fails)
