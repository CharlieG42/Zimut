extends SceneTree
## Mode Cartes : plateau iso (perspective) — géométrie des cases, touchers sur trapèzes, aperçus, plus réglage Options.
## Lancement : godot --headless --path . -s tests/test_jcc_iso.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	if not c:
		print("  ÉCHEC  " + m)
		fails += 1
func _init() -> void:
	_boot.call_deferred()

func _boot() -> void:
	root.size = Vector2i(1920, 1080)
	await create_timer(0.5).timeout
	var pm = root.get_node("ProgressionManager")
	var gm = root.get_node("GameManager")
	var gs = root.get_node("GameSettings")
	gs.tutorial_enabled = false
	gs.cards_iso = true
	pm.write_save(3, pm.new_game(3, "Iso"))
	gm.active_save = pm.load_save(3)
	gm.active_slot = 3
	var m = load("res://scenes/CardDuel.tscn").instantiate()
	root.add_child(m)
	current_scene = m
	await create_timer(0.5).timeout
	m._start_duel(2)
	await create_timer(0.8).timeout
	var d = m._duel
	check(m._iso, "mode iso actif")
	check(m._cell_polys.size() == 24, "24 trapèzes")
	var top: float = (m._cell_scale[0] as float)
	var bot: float = (m._cell_scale[23] as float)
	check(top < bot and top > 0.6 and bot <= 1.0, "rangées lointaines plus petites (%.2f < %.2f)" % [top, bot])
	# les cases ne se chevauchent pas : le centre de chaque case est dans son polygone et pas dans celui du voisin
	var ok := true
	for c in 24:
		if not Geometry2D.is_point_in_polygon(m._cell_ctr[c], m._cell_polys[c]):
			ok = false
		if c % 4 < 3 and Geometry2D.is_point_in_polygon(m._cell_ctr[c], m._cell_polys[c + 1]):
			ok = false
	check(ok, "centres dans leur trapèze, sans chevauchement")
	# toucher d'une case vide via son nœud : un déplacement par tap fonctionne en iso
	for s in 2:
		d.side(s)["units"] = []
		d.side(s)["hand"] = []
	d.place_unit(0, "m_troll", 1, 4)
	d.current = 0
	m._cancel_selection_silent()
	m._busy = false
	m._refresh()
	var from: int = d.xy_cell(1, 4)
	m._on_board_card(0, from)
	check(m._sel_cell == from, "unité sélectionnée en iso")
	check(m._range_cells.size() > 0, "cases à portée PO calculées (%d)" % m._range_cells.size())
	var tgt: int = d.xy_cell(1, 3)
	var node = m._slots["%d" % tgt]
	var local: Vector2 = (m._cell_ctr[tgt] as Vector2) - node.position
	check(node._has_point(local), "le centre de la case est cliquable")
	check(not node._has_point(Vector2(-5, -5)), "hors trapèze : non cliquable")
	m._on_slot(tgt)
	await create_timer(0.8).timeout
	check(d.creature_at(0, tgt) != null, "déplacement par tap en iso")
	# aperçu d'attaque
	d.place_unit(1, "m_troll", 1, 2)
	d.current = 0
	for u in d.creatures(0):
		u["pm"] = 0
	m._cancel_selection_silent()
	m._refresh()
	m._on_board_card(0, tgt)
	m._begin_attack(tgt)
	var labels := 0
	for n in m._cards_layer.get_children():
		if n is Label and String(n.text).contains("riposte"):
			labels += 1
	check(labels == 1, "aperçu des dégâts et de la riposte sur la cible (%d)" % labels)
	check(m._effect_preview("degats", "5") == "-5" and m._effect_preview("soin", "3") == "+3 PV", "aperçus d'effets")
	# réglage persistant
	gs.set_cards_iso(false)
	check(not gs.cards_iso, "réglage Options > Cartes modifiable")
	print("FIN : %d échec(s)" % fails)
	quit(1 if fails > 0 else 0)
