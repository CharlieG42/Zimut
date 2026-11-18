extends SceneTree
## Mode Cartes (V401) : interface de la main (CardHand), règles du mana commun, deck partagé,
## champion et decks thématiques. Lancement : godot --headless --path . -s tests/test_card_hand.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	await process_frame
	var gm: Node = root.get_node("GameManager")
	var dl: Node = root.get_node("DataLoader")
	var CD = load("res://scripts/CardDeck.gd")
	print("Mana et pioche par manche :")
	check(CD.mana_for_round(1) == 3 and CD.mana_for_round(2) == 4 and CD.mana_for_round(8) == 10 and CD.mana_for_round(30) == 10, "mana : 3 à la manche 1, +1 par manche, plafonné à 10")
	var rng := RandomNumberGenerator.new()
	rng.seed = 5
	var deck = CD.from_names(dl.get_deck_cards("Deck de test"), dl.get_cards_data(), rng)
	check(deck.start_round(1).is_empty() and deck.mana == 3 and deck.hand.size() == 5, "manche 1 : mana 3, pas de pioche (main de 5)")
	check(deck.start_round(1).is_empty() and deck.hand.size() == 5, "même manche : rien de plus (une seule pioche par manche)")
	var drawn: Dictionary = deck.start_round(2)
	check(not drawn.is_empty() and deck.mana == 4 and deck.hand.size() == 6, "manche 2 : mana 4 et 1 carte piochée")
	check(deck.total_cards() == 20, "aucune carte perdue (20)")
	print("Decks thématiques :")
	var all_ok: bool = true
	var names: Array = dl.get_deck_names()
	for nm in names:
		var cards: Array = dl.get_deck_cards(String(nm))
		var known: bool = true
		for c in cards:
			if dl.get_card_by_name(String(c)).is_empty():
				known = false
		if cards.size() != 20 or not known:
			all_ok = false
			print("   deck incorrect : ", nm, " (", cards.size(), ")")
	check(all_ok and names.size() >= 5, "%d decks de 20 cartes connues" % names.size())
	var DP = load("res://scripts/DeckPickUI.gd")
	var proposable: Array = DP.deck_names()
	check(proposable.size() == names.size() - 1 and not proposable.has("Deck de test ennemis"), "le choix de deck exclut le deck des ennemis")
	var sm: Dictionary = DP.summarize("Invocateurs")
	check(int(sm["total"]) == 20 and int(sm["summon"]) == 9, "résumé du deck Invocateurs : 20 cartes dont %d invocations" % int(sm["summon"]))
	print("Combat : deck partagé, mana, champion :")
	gm.active_save = {"battle_mode": "cards", "cards_deck": "Assaut", "team": [{"classe": "Tank", "equipment": {}}, {"classe": "Mage", "equipment": {}}, {"classe": "Chasseur", "equipment": {}}], "roster": {}}
	gm.active_slot = -1
	gm.battle_mode = "cards"
	gm.reset_game()
	check(gm.players.size() >= 2, "équipe de %d héros" % gm.players.size())
	check(gm.players[0]["card_deck"] == gm.players[1]["card_deck"], "les héros partagent le même deck et la même main")
	check(gm.enemies[0]["card_deck"] != gm.players[0]["card_deck"], "les ennemis ont leur propre deck")
	check(gm.champions.has("player") and gm.champions.has("enemy"), "un champion par camp")
	var st: Dictionary = gm.card_state("player")
	check(st["hand"].size() == 5 and int(st["mana_max"]) == 3, "état : 5 cartes en main, mana max 3")
	var pdeck = gm.players[0]["card_deck"]
	check(int(pdeck.mana) == 3, "mana du camp = 3 à la première manche (%d)" % int(pdeck.mana))
	var active: Dictionary = gm.active_entity
	if not active.is_empty() and String(active["team"]) == "player":
		check(int(active["current_pa"]) == 3, "le héros actif joue avec le mana du camp (%d PA)" % int(active["current_pa"]))
	# la chute du champion ennemi termine le duel, même avec d'autres ennemis debout
	var other: int = gm.enemies.size()
	var ec: Dictionary = gm.champions["enemy"]
	ec["current_pv"] = 0
	gm._check_deaths()
	check(gm.game_over and gm.victory, "champion ennemi tombé : victoire (%d autre(s) ennemi(s) encore debout)" % (other - 1))
	gm.reset_game()
	var pc: Dictionary = gm.champions["player"]
	pc["current_pv"] = 0
	gm._check_deaths()
	check(gm.game_over and not gm.victory, "champion allié tombé : défaite")
	print("CardHand — interface :")
	gm.reset_game()
	var hand = (load("res://scripts/CardHand.gd") as GDScript).new()
	hand.set("gm", gm)
	root.add_child(hand)
	hand.size = Vector2(1920, 1080)
	hand.refresh()
	for i in 60:
		hand._process(1.0 / 30.0)
	check(hand._cards.size() == 5, "la main affiche 5 cartes")
	var c0: Dictionary = hand._cards[2]
	var centre: Vector2 = c0["pos"]
	check(not hand._card_at(centre).is_empty() and hand._has_point(centre), "une carte est cliquable à sa position")
	check(hand._card_at(Vector2(960, 300)).is_empty() and not hand._has_point(Vector2(960, 300)), "le plateau reste cliquable (rien au milieu de l'écran)")
	check(hand._pile_at(hand._deck_pos()) == "deck" and hand._pile_at(hand._discard_pos()) == "discard", "pioche et défausse détectées")
	var xs: Array = []
	for c in hand._cards:
		xs.append(float((c["pos"] as Vector2).x))
	check(xs == xs.duplicate() and float(xs[0]) < float(xs[4]) and absf((float(xs[0]) + float(xs[4])) * 0.5 - 960.0) < 2.0, "main en éventail centrée")
	hand._hover_uid = int(c0["uid"])
	hand._layout_targets()
	check(float((c0["tpos"] as Vector2).y) < float((hand._cards[1]["tpos"] as Vector2).y) - 40.0, "la carte survolée se soulève")
	# carte jouée : elle quitte la main et un fantôme file vers la défausse
	var uid0: int = int(c0["uid"])
	gm.players[0]["card_deck"].play_uid(uid0)
	gm._refresh_card_spells(gm.players[0])
	hand.refresh()
	check(hand._cards.size() == 4 and hand._ghosts.size() == 1, "carte jouée : 4 en main + 1 animation vers la défausse")
	var pile = (load("res://scripts/CardHand.gd") as GDScript).call("open_pile", root, gm, "discard")
	check(pile != null and pile.name == "PileView", "la défausse s'ouvre dans une fenêtre")
	hand.queue_free()
	if pile != null:
		pile.queue_free()
	gm.battle_mode = ""
	gm.active_save = {}
	print("FIN : %d échec(s)" % fails)
	quit(1 if fails > 0 else 0)
