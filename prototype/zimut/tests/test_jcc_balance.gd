extends SceneTree
## Équilibrage du mode Cartes : simulations IA/IA avec seuils (durée, avantage du 1er joueur, difficulté croissante).
const DD := preload("res://scripts/JccDuel.gd")
const CO := preload("res://scripts/JccCollection.gd")
var fails: int = 0

func check(ok: bool, label: String) -> void:
	if ok:
		print("  ok  ", label)
	else:
		fails += 1
		print("  KO  ", label)

func play(d0: Array, d1: Array, seed_i: int) -> Array:
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
	return [sim.winner, sim.turn]

func _initialize() -> void:
	var n: int = 16
	var p0: int = 0
	var games: int = 0
	var turns: int = 0
	var unfinished: int = 0
	var decks: Array = []
	for o in CO.OPPONENTS.size():
		decks.append(CO.parse_deck(String(CO.opponent(o)["deck"])))
	for o in decks.size():
		for i in n:
			var r: Array = play(decks[o], decks[o], 500 + i)
			games += 1
			turns += int(r[1])
			if int(r[0]) < 0:
				unfinished += 1
			elif int(r[0]) == 0:
				p0 += 1
	var pct: int = p0 * 100 / games
	var avg: int = turns / games
	print("miroirs : P0 %d%%, %d tours en moyenne (%d parties)" % [pct, avg, games])
	check(unfinished == 0, "toutes les parties se terminent")
	check(pct >= 40 and pct <= 60, "avantage du 1er joueur contenu (%d%%)" % pct)
	check(avg <= 30, "durée moyenne <= 30 tours (%d)" % avg)
	# Difficulté croissante : le deck de départ doit battre le 1er adversaire et perdre face au dernier.
	var sd: Array = CO.starter_deck()
	var wins: Array = []
	for o in [0, 5]:
		var w: int = 0
		for i in 12:
			if int(play(sd, decks[o], 900 + i)[0]) == 0:
				w += 1
			if int(play(decks[o], sd, 900 + i)[0]) == 1:
				w += 1
		wins.append(w)
	print("deck de départ : %d/24 contre l'adversaire 1, %d/24 contre le dernier" % [wins[0], wins[1]])
	check(wins[0] >= 14, "le 1er adversaire est battable avec le deck de départ")
	check(wins[1] <= wins[0] - 6, "le dernier adversaire est nettement plus dur")
	print("FIN : %d échec(s)" % fails)
	quit(fails)
