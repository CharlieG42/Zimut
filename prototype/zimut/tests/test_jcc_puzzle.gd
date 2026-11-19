extends SceneTree
## Puzzles : chaque puzzle est résoluble par sa solution scriptée, et perdu si on passe son tour.
const DD := preload("res://scripts/JccDuel.gd")
const CO := preload("res://scripts/JccCollection.gd")
var fails: int = 0

func check(ok: bool, label: String) -> void:
	if ok:
		print("  ok  ", label)
	else:
		fails += 1
		print("  ÉCHEC  ", label)

func _tgt(d, step: Dictionary) -> Dictionary:
	if step.has("hero"):
		return {"side": 1, "lane": -1}
	if step.has("ally"):
		var a: Array = step["ally"]
		return {"side": 0, "lane": d.xy_cell(int(a[0]), int(a[1]))}
	return {}

func _initialize() -> void:
	for pz: Variant in CO.PUZZLES:
		var def: Dictionary = pz
		var d = DD.new()
		d.setup_puzzle(def)
		check(d.current == 0 and not d.is_over(), "%s : démarrage au tour du joueur" % def["id"])
		var ok: bool = true
		for st: Variant in def["solution"]:
			var step: Dictionary = st
			var r: bool = true
			match String(step["k"]):
				"play":
					r = d.play_card(0, int(step["hand"]), _tgt(d, step))
				"move":
					var f: Array = step["from"]
					var t: Array = step["to"]
					r = d.move(0, d.xy_cell(int(f[0]), int(f[1])), d.xy_cell(int(t[0]), int(t[1])))
				"attack":
					var f2: Array = step["from"]
					r = d.attack(0, d.xy_cell(int(f2[0]), int(f2[1])), _tgt(d, step))
				"end":
					d.end_turn(0)
					d.end_turn(1)
			if not r:
				ok = false
				print("     étape refusée : ", step)
		check(ok and d.winner == 0, "%s : la solution gagne (héros adverse à %d)" % [def["id"], int(d.side(1)["hero_hp"])])
		var d2 = DD.new()
		d2.setup_puzzle(def)
		var guard: int = 0
		while not d2.is_over() and guard < 10:
			guard += 1
			d2.end_turn(0)
			if not d2.is_over():
				d2.end_turn(1)
		check(d2.winner == 1, "%s : passer son tour fait perdre au bout de %d tour(s)" % [def["id"], int(def["turns"])])
		check(int(d2.side(0)["hero_hp"]) == int(def["my_hp"]) and int(d2.side(1)["hero_hp"]) == int(def["foe_hp"]), "%s : pas de fatigue ni de pioche" % def["id"])
	var save: Dictionary = {}
	var w: Dictionary = CO.weekly_puzzle(save)
	check(not bool(w["done"]) and CO.puzzle_won(save) != "", "1re victoire de la semaine : une carte")
	check(bool(CO.weekly_puzzle(save)["done"]) and CO.puzzle_won(save) == "", "2e victoire la même semaine : pas de carte")
	await _ui_test()
	print("FIN : %d échec(s)" % fails)
	quit(fails)

func _ui_test() -> void:
	root.size = Vector2i(1920, 1080)
	await create_timer(0.8).timeout
	var pm = root.get_node("ProgressionManager")
	var gm = root.get_node("GameManager")
	var gs = root.get_node("GameSettings")
	gs.tutorial_enabled = false
	pm.write_save(3, pm.new_game(3, "Capture"))
	gm.active_save = pm.load_save(3)
	gm.active_slot = 3
	var m = load("res://scenes/CardDuel.tscn").instantiate()
	root.add_child(m)
	current_scene = m
	await create_timer(0.8).timeout
	var j: Dictionary = CO.ensure(m._save)
	var losses0: int = int(j["losses"])
	m._start_puzzle()
	await create_timer(0.5).timeout
	check(m._puzzle and not m._duel.puzzle.is_empty() and m._puzzle_lbl != null and m._puzzle_lbl.text.contains("Tour 1"), "UI : le puzzle démarre, compteur de tours affiché")
	var guard: int = 0
	while not m._over and guard < 6:
		guard += 1
		m._on_end_turn()
		await create_timer(0.9).timeout
	check(m._over and m._duel.winner == 1, "UI : passer ses tours = défaite du puzzle")
	check(int(CO.ensure(m._save)["losses"]) == losses0, "UI : un puzzle perdu ne compte pas dans les défaites")
