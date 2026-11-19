extends SceneTree
## Lot visuel : biome par adversaire, aperçu de portée ennemie (tap), écran d'aide.
var fails: int = 0
func check(ok: bool, label: String) -> void:
	if ok:
		print("  ok  ", label)
	else:
		fails += 1
		print("  ÉCHEC  ", label)

func _initialize() -> void:
	root.size = Vector2i(1920, 1080)
	await create_timer(0.8).timeout
	var pm = root.get_node("ProgressionManager")
	var gm = root.get_node("GameManager")
	var gs = root.get_node("GameSettings")
	gs.tutorial_enabled = false
	pm.write_save(3, pm.new_game(3, "Capture"))
	gm.active_save = pm.load_save(3)
	gm.active_slot = 3
	var CO = load("res://scripts/JccCollection.gd")
	var okb: bool = true
	for i in CO.OPPONENTS.size():
		var o: Dictionary = CO.opponent(i)
		okb = okb and o.has("biome") and o.has("accent") and Color(String(o["accent"])) != Color.BLACK
	check(okb, "chaque adversaire a un biome et une couleur de camp")
	var m = load("res://scenes/CardDuel.tscn").instantiate()
	root.add_child(m)
	current_scene = m
	await create_timer(0.8).timeout
	m._start_duel(3)
	await create_timer(0.8).timeout
	check(m._biome == "Désert", "biome du duel = biome de l'adversaire (%s)" % m._biome)
	var d = m._duel
	for s in 2:
		d.side(s)["units"] = []
	d.place_unit(1, "m_troll", 1, 1)
	var cell: int = d.xy_cell(1, 1)
	m._refresh()
	m._on_board_card(1, cell)
	check(m._inspect_cell == cell and not m._foe_threat.is_empty(), "tap sur un ennemi : aperçu de menace (%d cases)" % m._foe_threat.size())
	check(not m._foe_moves.is_empty(), "tap sur un ennemi : aperçu de ses déplacements (%d cases)" % m._foe_moves.size())
	m._cancel_selection()
	# le héros adverse est un personnage au centre du bord haut : un toucher dessus le cible
	d.side(0)["hand"] = [d._make_instance("s_boule_feu")]
	d.side(0)["mana"] = 10
	var hp0: int = int(d.side(1)["hero_hp"])
	m._sel_hand = 0
	m._refresh()
	var ev := InputEventMouseButton.new()
	ev.button_index = MOUSE_BUTTON_LEFT
	ev.position = Vector2(960, 60)
	ev.global_position = ev.position
	ev.pressed = true
	check((m._hero_nodes[1] as Control).get_global_rect().has_point(Vector2(960, 60)), "le sprite du héros adverse est au centre du bord haut")
	var blockers: Array = []
	var all: Array = [m._root]
	while not all.is_empty():
		var n: Node = all.pop_back()
		for c: Node in n.get_children():
			all.append(c)
			if c is Control and c != m._hero_nodes[1] and (c as Control).mouse_filter == Control.MOUSE_FILTER_STOP and (c as Control).is_visible_in_tree() and (c as Control).get_global_rect().has_point(Vector2(960, 60)) and c.get_index() > (m._hero_nodes[1] as Node).get_index() and c.get_parent() == m._root:
				blockers.append(c.name)
	check(blockers.is_empty(), "rien d'opaque ne recouvre le héros adverse %s" % [blockers])
	(m._hero_nodes[1] as Control).gui_input.emit(ev)
	await create_timer(1.2).timeout
	check(int(d.side(1)["hero_hp"]) < hp0, "toucher le sprite du héros adverse le cible (%d -> %d PV)" % [hp0, int(d.side(1)["hero_hp"])])
	m._show_help()
	check(m._root.get_node_or_null("HelpView") != null, "l'aide s'ouvre")
	print("FIN : %d échec(s)" % fails)
	quit(fails)
