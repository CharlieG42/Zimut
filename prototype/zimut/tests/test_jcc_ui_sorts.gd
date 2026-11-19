extends SceneTree
## Mode Cartes : chaque carte-sort et chaque sort de créature est jouable PAR L'INTERFACE (touchers simulés).
## Lancement : godot --headless --path . -s tests/test_jcc_ui_sorts.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	if not c:
		print("  ÉCHEC  " + m)
		fails += 1
func _init() -> void:
	_boot.call_deferred()

func _prep(m) -> void:
	m._start_duel(0)
	var d = m._duel
	for s in 2:
		d.side(s)["units"] = []
		d.side(s)["hand"] = []
	d.side(0)["mana"] = 10
	d.side(0)["hero_hp"] = 20
	d.place_unit(1, "m_troll", 2, 2)
	d.place_unit(1, "m_troll", 1, 3)
	d.place_unit(0, "m_troll", 0, 4)
	d.place_unit(0, "m_troll", 3, 4)
	for u in d.creatures(0):
		u["hp"] = 2
	d.current = 0
	m._cancel_selection_silent()
	m._busy = false
	m._over = false
	m._refresh()

## Touche la première cible valable comme le ferait le joueur (carte du plateau, case vide ou héros).
func _tap_target(m, cible: String) -> bool:
	var ts: Array = m._duel.targets_for(0, cible)
	if ts.is_empty():
		return false
	var t: Dictionary = ts[0]
	if int(t["lane"]) == -1:
		m._on_hero(int(t["side"]))
	elif m._duel.creature_at(int(t["side"]), int(t["lane"])) != null:
		m._on_board_card(int(t["side"]), int(t["lane"]))
	else:
		m._on_slot(int(t["lane"]))
	return true

func _wait(m) -> void:
	var g: int = 0
	while m._busy and g < 100:
		await create_timer(0.05).timeout
		g += 1

func _boot() -> void:
	Engine.time_scale = 4.0   # 61 sorts x 0.55 s d'animation : sinon proche des 60 s max du CI
	await create_timer(0.5).timeout
	var pm = root.get_node("ProgressionManager")
	var gm = root.get_node("GameManager")
	pm.write_save(3, pm.new_game(3, "UI sorts"))
	gm.active_save = pm.load_save(3)
	gm.active_slot = 3
	var m = load("res://scenes/CardDuel.tscn").instantiate()
	root.add_child(m)
	current_scene = m
	await create_timer(0.3).timeout
	var CC = load("res://scripts/JccCards.gd")
	var n: int = 0
	for id in CC.collectible_ids():
		var c: Dictionary = CC.get_card(id)
		var is_spell: bool = String(c["type"]) == "Sort"
		if not is_spell and String(c["sort"]) == "":
			continue
		n += 1
		_prep(m)
		var d = m._duel
		var cible: String = String(c["cible"])
		var needs: bool = d.needs_target(cible)
		var mana0: int = int(d.side(0)["mana"])
		var label: String = ("Carte « %s »" % c["name"]) if is_spell else ("Sort « %s » de %s" % [c["sort"], c["name"]])
		if is_spell:
			d.side(0)["hand"] = [d._make_instance(id)]
			m._refresh()
			m._on_hand_card(0)
			if needs:
				check(m._sel_hand == 0 and not m._targets.is_empty(), "%s : aucune cible ne s'allume après sélection" % label)
				_tap_target(m, cible)
			else:
				m._on_hand_card(0)
		else:
			var src: int = d.xy_cell(0, 4)
			var cr = d.creature_at(0, src)
			for k in ["sort", "sort_cost", "effet", "valeur", "duree", "cible"]:
				cr[k] = c[k]
			cr["sick"] = false
			m._refresh()
			m._on_board_card(0, src)
			check(m._sel_cell == src, "%s : la créature ne se sélectionne pas" % label)
			m._begin_sort(src)
			if needs:
				check(not m._pending.is_empty() and not m._targets.is_empty(), "%s : aucune cible ne s'allume" % label)
				_tap_target(m, cible)
		await _wait(m)
		var cost: int = int(c["cost"]) if is_spell else int(c["sort_cost"])
		var gained: int = int(c["valeur"]) if String(c["effet"]) == "mana" else 0
		check(int(d.side(0)["mana"]) == mana0 - cost + gained, "%s : l'interface n'a pas lancé le sort (mana %d, attendu %d)" % [label, int(d.side(0)["mana"]), mana0 - cost + gained])
		check(not m._busy, "%s : l'interface reste bloquée" % label)
	# attaque + déplacement par l'interface
	_prep(m)
	var d2 = m._duel
	var a: int = d2.xy_cell(0, 4)
	m._on_board_card(0, a)
	var mv: Array = d2.move_targets(0, a)
	check(not mv.is_empty(), "déplacement : des cases dorées sont proposées")
	if not mv.is_empty():
		m._on_slot(int(mv[0]["lane"]))
		check(d2.creature_at(0, int(mv[0]["lane"])) != null, "déplacement par toucher d'une case")
	print("%d sorts joués par l'interface" % n)
	print("FIN : %d échec(s)" % fails)
	quit(fails)
