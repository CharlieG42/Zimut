extends SceneTree
## L'IA du Chasseur attaque au lieu de reposer des balises en boucle (blocage de 342 tours).
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var gm: Node = root.get_node("GameManager")
	await process_frame
	gm.set_custom_team([{"classe": "Chasseur"}, {"classe": "Tank"}, {"classe": "Heal"}])
	gm.init_grid()
	gm.init_entities()
	var ch: Dictionary = {}
	for p: Dictionary in gm.players:
		if String(p["classe"]) == "Chasseur":
			ch = p
	ch["spells"] = gm._build_spells("Chasseur", 30)
	ch["current_pa"] = 6
	ch["casts"] = {}
	var foe: Dictionary = gm.enemies[0]
	var spot := Vector2i(-1, -1)
	for y: int in range(gm.GRID_SIZE):
		for x: int in range(gm.GRID_SIZE):
			var c := Vector2i(x, y)
			if spot.x < 0 and gm.is_free(c) and Combat.manhattan(gm.pos_of(ch), c) == 3:
				spot = c
	gm._teleport_entity(foe, spot)
	var tm: Node = (load("res://scripts/TurnManager.gd") as GDScript).new()
	tm.game_manager = gm
	var act: Dictionary = tm.plan(ch)
	check(not act.is_empty() and String(act["type"]) == "cast", "le Chasseur agit")
	check(String(act["spell"]["name"]) != "Balise de chasse", "il n'ouvre pas par une balise (%s)" % String(act["spell"]["name"]))
	var bal: Dictionary = {}
	for s: Dictionary in ch["spells"]:
		if String(s["name"]) == "Balise de chasse":
			bal = s
	check(tm._score_cast(ch, bal, Combat.parse(bal), spot) == 0.0, "balise de chasse : score IA nul")
	print("ÉCHECS : ", fails)
	quit(0 if fails == 0 else 1)
