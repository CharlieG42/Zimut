extends SceneTree
## test_card_deck.gd — Tests headless de CardDeck et des données du mode Cartes tactiques.
## Lancement : godot --headless -s tests/test_card_deck.gd --path .
##
## NOTE : en mode `-s` (script), les class_name ne sont PAS enregistrés dans
## le ClassDB. Il faut charger explicitement le script avec load().

var failures: int = 0
var CardDeck = load("res://scripts/CardDeck.gd")


func _init() -> void:
	# Les autoloads n'existent qu'après le premier frame en mode -s.
	_start.call_deferred()


func _start() -> void:
	_test_from_names()
	_test_draw_hand_max()
	_test_play_uid()
	_test_data_files()
	_test_battle_mode_flag()
	print("")
	if failures > 0:
		print("ÉCHEC : %d test(s) en erreur." % failures)
		quit(1)
	else:
		print("OK : tous les tests passent.")
		quit(0)


func _check(cond: bool, label: String) -> void:
	if cond:
		print("  ok  %s" % label)
	else:
		failures += 1
		print("  KO  %s" % label)


func _cards_data() -> Array:
	return [
		{"Nom": "Attaque A", "Classe": "Tank", "Cout_PA": "1", "Cout_PM": "0", "Portee": "1", "Effet": "10 dégâts", "Niveau_requis": "1", "Type": "Attaque"},
		{"Nom": "Soin B", "Classe": "Druide", "Cout_PA": "2", "Cout_PM": "0", "Portee": "1", "Effet": "Restaure 10 PV", "Niveau_requis": "1", "Type": "Soin"},
		{"Nom": "Invoquer Loup Spectral", "Classe": "Invocateur", "Cout_PA": "2", "Cout_PM": "0", "Portee": "1", "Effet": "Invoque un Loup Spectral", "Niveau_requis": "1", "Type": "Invocation"},
	]


func _deck_names(n: int) -> Array:
	var pool: Array = ["Attaque A", "Soin B", "Invoquer Loup Spectral"]
	var out: Array = []
	for i in range(n):
		out.append(pool[i % pool.size()])
	return out


func _test_from_names() -> void:
	print("CardDeck — construction (Q3 : deck 20, main 5) :")
	var rng := RandomNumberGenerator.new()
	rng.seed = 42
	var d = CardDeck.from_names(_deck_names(20), _cards_data(), rng)
	_check(d.total_cards() == 20, "20 cartes au total")
	_check(d.hand_size() == 5, "main de départ = 5")
	_check(d.deck.size() == 15, "pioche = 15 après la main de départ")
	var uids: Dictionary = {}
	var unique := true
	for c in d.hand + d.deck:
		if uids.has(int(c["card_uid"])):
			unique = false
		uids[int(c["card_uid"])] = true
	_check(unique and uids.size() == 20, "card_uid uniques sur les 20 cartes")


func _test_draw_hand_max() -> void:
	print("CardDeck — pioche et main max 7 (Q3) :")
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	var d = CardDeck.from_names(_deck_names(20), _cards_data(), rng)
	d.draw()
	d.draw()  # main = 7
	_check(d.hand_size() == 7, "main = 7 après 2 pioches")
	var c: Dictionary = d.draw()  # main pleine -> défausse
	_check(d.hand_size() == 7 and d.discard.size() == 1 and not c.is_empty(), "main pleine : la carte piochée part en défausse")
	_check(d.total_cards() == 20, "aucune carte perdue (20)")
	while not d.deck.is_empty():
		d.draw()
	# 5 (départ) + 2 pioches = main 7 ; les 13 pioches suivantes partent en défausse
	_check(d.hand_size() == 7 and d.discard.size() == 13, "pioche vide : main 7, défausse 13")
	_check(d.draw().is_empty(), "piocher une pioche vide retourne {}")


func _test_play_uid() -> void:
	print("CardDeck — play_uid (jouer une carte -> défausse) :")
	var rng := RandomNumberGenerator.new()
	rng.seed = 1
	var d = CardDeck.from_names(_deck_names(20), _cards_data(), rng)
	var uid: int = int(d.hand[0]["card_uid"])
	var played: Dictionary = d.play_uid(uid)
	_check(not played.is_empty() and int(played["card_uid"]) == uid, "la carte jouée est retournée")
	_check(d.hand_size() == 4 and d.discard.size() == 1, "main 4, défausse 1 après play")
	_check(d.play_uid(uid).is_empty(), "rejouer le même uid retourne {} (déjà défaussée)")
	_check(d.total_cards() == 20, "aucune carte perdue après play (20)")


func _test_data_files() -> void:
	print("DataLoader — cartes.txt / decks.txt :")
	var dl: Node = (Engine.get_main_loop() as SceneTree).root.get_node("DataLoader")
	_check(dl.get_cards_data().size() >= 20, "cartes.txt chargé (%d cartes)" % dl.get_cards_data().size())
	_check(dl.get_deck_names().has("Deck de test"), "decks.txt : 'Deck de test' présent")
	_check(dl.get_deck_cards("Deck de test").size() == 20, "'Deck de test' = 20 cartes")
	_check(dl.get_deck_cards("Deck de test ennemis").size() == 20, "'Deck de test ennemis' = 20 cartes")
	var all_known := true
	for nm in dl.get_deck_cards("Deck de test"):
		if dl.get_card_by_name(String(nm)).is_empty():
			all_known = false
	_check(all_known, "toutes les cartes du deck existent dans cartes.txt")


func _test_battle_mode_flag() -> void:
	print("GameManager — battle_mode (tuile « Cartes » -> start_battle) :")
	var gm: Node = (Engine.get_main_loop() as SceneTree).root.get_node("GameManager")
	# Chemin nominal : la sauvegarde contient battle_mode="cards"
	gm.active_save = {"battle_mode": "cards", "team": [{"classe": "Tank", "equipment": {}}], "roster": {}}
	gm.active_slot = 0
	gm.reset_game()
	_check(gm.battle_mode == "cards", "start_battle lit battle_mode depuis la sauvegarde")
	_check(not gm.players.is_empty() and gm.players[0].has("card_deck"), "le héros a un card_deck")
	if not gm.players.is_empty():
		var spells: Array = gm.players[0]["spells"]
		_check(spells.size() == 5 and spells[0].has("card_uid"), "la barre de sorts = la main (5 cartes avec card_uid)")
	# Repli : drapeau en mémoire posé par la tuile, clé absente de la sauvegarde
	gm.active_save = {"team": [{"classe": "Tank", "equipment": {}}], "roster": {}}
	gm.battle_mode = "cards"
	gm.start_battle()
	_check(gm.battle_mode == "cards", "sans clé de sauvegarde, le drapeau mémoire de la tuile est conservé")
	# Garde-fou : un combat de campagne ne garde jamais le mode cartes
	gm.active_save = {"battle_mode": "cards", "campaign_mode": "adventure", "team": [{"classe": "Tank", "equipment": {}}], "roster": {}}
	gm.battle_mode = "cards"
	gm.start_battle()
	_check(gm.battle_mode == "", "campaign_mode != \"\" -> mode cartes ignoré")
	# Nettoyage
	gm.battle_mode = ""
	gm.active_save = {}
	gm.active_slot = -1
