extends SceneTree
## Régression : `occupant()` renvoyait toujours le camp 0, donc taper une unité ENNEMIE avec un sort (ou une attaque)
## sélectionnait l'unité au lieu de la cibler. Ici on passe par les vraies vues du plateau (`tapped`), comme au doigt.
## Lancement : godot --headless --path . -s tests/test_jcc_occupant.gd
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
	pm.write_save(3, pm.new_game(3, "Occ"))
	gm.active_save = pm.load_save(3)
	gm.active_slot = 3
	var m = load("res://scenes/CardDuel.tscn").instantiate()
	root.add_child(m)
	current_scene = m
	await create_timer(0.5).timeout
	m._start_duel(0)
	await create_timer(0.8).timeout
	var d = m._duel
	for s in 2:
		d.side(s)["units"] = []
	d.place_unit(0, "m_troll", 0, 4)
	d.place_unit(1, "m_troll", 2, 2)
	check(int(d.occupant(d.xy_cell(0, 4))["side"]) == 0, "occupant : unité alliée = camp 0")
	check(int(d.occupant(d.xy_cell(2, 2))["side"]) == 1, "occupant : unité ennemie = camp 1")
	# sort de la main sur une unité ennemie, via la vue tapée
	d.side(0)["mana"] = 10
	d.side(0)["hand"] = [d._make_instance("s_javelot")]
	d.current = 0
	m._cancel_selection_silent(); m._busy = false; m._refresh()
	var ecell: int = d.xy_cell(2, 2)
	var ev = m._board_views.get("1:%d" % ecell)
	check(ev != null, "la vue de l'unité ennemie est rangée côté 1")
	check(m._board_views.get("0:%d" % ecell) == null, "pas de vue ennemie rangée côté 0")
	m._on_hand_card(0)
	var ev2 = m._board_views.get("1:%d" % ecell)
	check(ev2 != null and ev2.target_ok, "la cible ennemie est signalée (liseré doré)")
	check(ev2 != null and not ev2.ready_glow, "une unité ennemie n'a pas le halo « prête »")
	ev2.tapped.emit(ev2)
	await create_timer(1.5).timeout
	check(int(d.side(0)["mana"]) == 7, "toucher la cible ennemie lance le sort (mana %d)" % int(d.side(0)["mana"]))
	var tgt: Variant = d.creature_at(1, ecell)
	check(tgt == null or int((tgt as Dictionary)["hp"]) < int((tgt as Dictionary).get("max_hp", 99)), "la cible a perdu des PV ou est morte")
	# attaque : toucher une unité ennemie à portée
	d.side(1)["units"] = []
	d.place_unit(1, "m_troll", 0, 3)
	for u in d.creatures(0):
		u["sick"] = false; u["attacked"] = false; u["pa"] = 1
	d.current = 0
	m._cancel_selection_silent(); m._busy = false; m._refresh()
	var acell: int = d.xy_cell(0, 4)
	m._on_board_card(0, acell)
	m._begin_attack(acell)
	var hp0: int = int((d.creature_at(1, d.xy_cell(0, 3)) as Dictionary)["hp"])
	var ev3 = m._board_views.get("1:%d" % d.xy_cell(0, 3))
	ev3.tapped.emit(ev3)
	await create_timer(1.5).timeout
	var hp1: int = int((d.creature_at(1, d.xy_cell(0, 3)) as Dictionary)["hp"])
	check(hp1 < hp0, "toucher un ennemi en mode attaque le frappe (%d -> %d)" % [hp0, hp1])
	print("FIN : %d échec(s)" % fails)
	quit(1 if fails > 0 else 0)
