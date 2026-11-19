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
	m._show_help()
	check(m._root.get_node_or_null("HelpView") != null, "l'aide s'ouvre")
	print("FIN : %d échec(s)" % fails)
	quit(fails)
