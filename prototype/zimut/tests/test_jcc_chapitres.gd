extends SceneTree
## Boss de chapitre : decks valides, déblocage par la campagne, 1re victoire récompensée, équilibre de base.
const DD := preload("res://scripts/JccDuel.gd")
const CO := preload("res://scripts/JccCollection.gd")
var fails: int = 0

func check(ok: bool, label: String) -> void:
	if ok:
		print("  ok  ", label)
	else:
		fails += 1
		print("  ÉCHEC  ", label)

func play(d0: Array, d1: Array, seed_i: int) -> int:
	var sim = DD.new()
	sim.setup(d0, d1, seed_i)
	var guard: int = 0
	while not sim.is_over() and guard < 300:
		guard += 1
		var who: int = sim.current
		var steps: int = 0
		while steps < 40:
			steps += 1
			if String(sim.ai_step(who)["type"]) == "end":
				break
		if not sim.is_over():
			sim.end_turn(who)
	return sim.winner

func _initialize() -> void:
	check(CO.CHAPTER_BOSSES.size() == ConquestSystem.CHAPTERS.size(), "un boss par chapitre de la Conquête (%d)" % CO.CHAPTER_BOSSES.size())
	var ok_all: bool = true
	for k in CO.CHAPTER_BOSSES.size():
		var b: Dictionary = CO.CHAPTER_BOSSES[k]
		var deck: Array = CO.parse_deck(String(b["deck"]))
		var good: bool = deck.size() == 20 and int(b["chapter"]) == k and String(deck[0]) == String(b["boss"]) and not JccCards.get_card(String(b["boss"])).is_empty()
		good = good and JccCardView.art_texture(String(b["sprite"])) != null and JccCardView.art_texture(String(JccCards.get_card(String(b["boss"]))["sprite"])) != null
		if not good:
			print("     deck/sprite invalide : ", b["name"], " ", deck.size())
		ok_all = ok_all and good
	check(ok_all, "decks de 20 cartes, boss en tête, sprites présents")
	# Déblocage par la campagne
	var save: Dictionary = {"conquest": {"chapter": 0}}
	var i0: int = CO.OPPONENTS.size()
	check(not CO.is_unlocked(save, i0) and not CO.is_unlocked(save, i0 + 1), "boss verrouillés au chapitre 0")
	save["conquest"]["chapter"] = 2
	check(CO.is_unlocked(save, i0) and CO.is_unlocked(save, i0 + 1) and not CO.is_unlocked(save, i0 + 2), "chapitre 2 atteint : 2 boss débloqués")
	check(CO.unlock_next(save, CO.OPPONENTS.size() - 1) == -1, "battre le dernier adversaire ne débloque pas de boss de chapitre")
	# 1re victoire
	var r: Dictionary = CO.chapter_boss_won(save, i0)
	check(String(r.get("card", "")) == "b_loup_alpha" and int(r.get("gold", 0)) == 100 and int(save.get("gold", 0)) == 100, "1re victoire : carte du boss + or")
	check(int(CO.ensure(save)["collection"].get("b_loup_alpha", 0)) >= 1, "la carte est dans la collection")
	check(CO.chapter_boss_won(save, i0).is_empty() and int(save["gold"]) == 100, "2e victoire : pas de seconde récompense garantie")
	check(CO.chapter_boss_won(save, 0).is_empty(), "un adversaire normal ne donne pas de récompense de chapitre")
	# Équilibre : le premier boss est battable par un deck de boss d'avant, le dernier est plus fort
	var dragon: Array = CO.parse_deck(String(CO.opponent(5)["deck"]))
	var first: Array = CO.parse_deck(String(CO.CHAPTER_BOSSES[0]["deck"]))
	var last: Array = CO.parse_deck(String(CO.CHAPTER_BOSSES[CO.CHAPTER_BOSSES.size() - 1]["deck"]))
	var wf: int = 0
	var wl: int = 0
	for i in 12:
		if play(dragon, first, 700 + i) == 0:
			wf += 1
		if play(first, dragon, 700 + i) == 1:
			wf += 1
		if play(dragon, last, 700 + i) == 0:
			wl += 1
		if play(last, dragon, 700 + i) == 1:
			wl += 1
	print("   Dragon bat le 1er boss %d/24, le dernier %d/24" % [wf, wl])
	check(wf > wl, "le dernier boss de chapitre est plus dur que le premier")
	print("FIN : %d échec(s)" % fails)
	quit(fails)
