extends SceneTree
## Mode Cartes : parcours de l'interface (duel complet par l'UI, butin, deck builder), sans rendu.
## Lancement : godot --headless --path . -s tests/test_jcc_ui.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	await create_timer(0.5).timeout
	var pm = root.get_node("ProgressionManager")
	var gm = root.get_node("GameManager")
	var data = pm.new_game(3, "Test JCC")
	pm.write_save(3, data)
	gm.active_save = pm.load_save(3)
	gm.active_slot = 3
	var m = load("res://scenes/CardDuel.tscn").instantiate()
	root.add_child(m)
	current_scene = m
	await create_timer(0.3).timeout
	print("Accueil / deck :")
	check(m._root.get_child_count() > 3, "l'accueil est construit")
	var j: Dictionary = load("res://scripts/JccCollection.gd").ensure(m._save)
	check((j["deck"] as Array).size() == 20, "deck de départ de 20 cartes")
	m._show_builder()
	await create_timer(0.3).timeout
	var b = m._root.get_child(0)
	check(b != null and b.get("_deck") != null and b._deck.size() == 20, "le constructeur s'ouvre avec le deck")
	b._selected = "c_mage"
	b._refresh_detail()
	var before: int = b._deck.size()
	b._deck.append("c_mage")
	b._refresh_all()
	check(b._save_btn.disabled, "deck de 21 cartes : « Enregistrer » désactivé")
	b._deck.erase("c_mage")
	b._refresh_all()
	check(not b._save_btn.disabled, "deck de 20 : « Enregistrer » actif")
	print("Duel par l'interface :")
	m._start_duel(0)
	await create_timer(0.3).timeout
	var d = m._duel
	check(d != null and m._hand_views.size() == 4, "duel lancé, 4 cartes en main")
	var nterr: int = 0
	for k in m._slots.keys():
		if m._slots[k].terrain != "":
			nterr += 1
	check(nterr == 6, "6 cases de terrain affichées sur le plateau")
	check(m._power_btn != null and m._power_btn.visible, "bouton pouvoir du héros visible au tour 1")
	check(m._mull_btn != null and m._mull_btn.visible, "bouton nouvelle main visible au tour 1")
	m._on_mulligan()
	await create_timer(0.9).timeout
	check((d.side(0)["hand"] as Array).size() == 4 and not d.can_mulligan(0) and not m._mull_btn.visible, "mulligan : main repiochee, bouton caché")
	m._on_power_pressed()
	await create_timer(1.0).timeout
	check(d.side(1)["hero_hp"] == 26 and not m._power_btn.visible, "pouvoir du héros lancé par l'UI (30 -> 26), bouton caché")
	d.side(0)["hand"] = [d._make_instance("m_gobelin"), d._make_instance("s_etincelle")]
	m._refresh()
	m._on_hand_card(0)
	check(m._sel_hand == 0 and m._targets.size() == 8, "carte créature sélectionnée : 8 cases de déploiement (2 lignes) ciblables")
	m._on_slot(21)
	await create_timer(1.0).timeout
	check(d.creature_at(0, 21) != null and not m._busy, "le Gobelin est posé en (1,5) par un toucher")
	d.side(0)["mana"] = 3
	m._refresh()
	m._on_hand_card(0)
	check(m._targets.size() >= 1 and m._is_target(1, -1), "Étincelle : le héros adverse est ciblable")
	var hp_avant: int = d.side(1)["hero_hp"]
	m._on_hero(1)
	await create_timer(1.0).timeout
	check(d.side(1)["hero_hp"] == hp_avant - 2, "Étincelle touche le héros adverse (%d -> %d)" % [hp_avant, d.side(1)["hero_hp"]])
	m._on_end_turn()
	var guard: int = 0
	while (m._busy or d.current != 0) and guard < 200 and not d.is_over():
		await create_timer(0.1).timeout
		guard += 1
	check(d.current == 0 and not m._busy, "le tour adverse se déroule et rend la main (%d pas)" % guard)
	check(d.turn >= 3, "trois tours écoulés")
	print("Victoire et butin :")
	var col_before: int = 0
	for k in m._save["jcc"]["collection"]:
		col_before += int(m._save["jcc"]["collection"][k])
	d._hit(1, -1, 99)
	m._finish_if_over()
	await create_timer(0.3).timeout
	var col_after: int = 0
	for k in m._save["jcc"]["collection"]:
		col_after += int(m._save["jcc"]["collection"][k])
	check(m._over and col_after >= col_before + 1 and int(m._save["jcc"]["wins"]) == 1, "victoire : +1 carte de butin (et +1 si défi réussi), 1 victoire")
	var CO2 = load("res://scripts/JccCollection.gd")
	check(CO2.is_unlocked(m._save, 1), "victoire vs adversaire 0 : adversaire 1 débloqué")
	var ch3: Dictionary = CO2.daily_challenge(m._save)
	check(String(ch3.get("id", "")) != "", "défi du jour présent après le duel")
	var saved = pm.load_save(3)
	check(saved.has("jcc") and int(saved["jcc"]["wins"]) == 1, "la partie est enregistrée")
	check((saved["jcc"]["decks"] as Dictionary).has("Deck 1") and String(saved["jcc"]["active_deck"]) == "Deck 1", "multi-decks enregistrés (Deck 1 actif)")
	print("FIN : %d échec(s)" % fails)
	quit(fails)
