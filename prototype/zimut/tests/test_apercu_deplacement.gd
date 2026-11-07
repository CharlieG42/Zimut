extends SceneTree
## V109 — aperçu du déplacement d'une cible poussée / attirée (GameManager.preview_displacement), sans rien modifier.
## Lancement : godot --headless --path . -s tests/test_apercu_deplacement.gd
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
	gm.set_custom_team([{"classe": "Chasseur"}, {"classe": "Tank"}, {"classe": "Mage"}])
	gm.init_grid()
	gm.init_entities()
	var h: Dictionary = gm.players[0]
	var foe: Dictionary = gm.enemies[0]
	for e: Dictionary in gm.players + gm.enemies:
		gm.grid[e["y"]][e["x"]] = null
	gm.obstacles.clear()
	h["x"] = 3; h["y"] = 5
	foe["x"] = 6; foe["y"] = 5
	gm.grid[5][3] = h
	gm.grid[5][6] = foe
	var d: Dictionary = gm.preview_displacement(h, foe, 2)
	check(d["path"] == [Vector2i(7, 5), Vector2i(8, 5)] and not bool(d["collided"]), "poussée libre : 2 cases, pas de choc")
	check(gm.pos_of(foe) == Vector2i(6, 5), "l'aperçu ne déplace rien")
	gm.obstacles[Vector2i(8, 5)] = "rock"
	d = gm.preview_displacement(h, foe, 3)
	check(d["path"] == [Vector2i(7, 5)] and bool(d["collided"]) and d["block"] == Vector2i(8, 5), "poussée bloquée par un obstacle : s'arrête avant, choc")
	d = gm.preview_displacement(h, foe, 3, true)
	check(d["path"] == [Vector2i(5, 5), Vector2i(4, 5)] and not bool(d["collided"]), "attirance : s'arrête au contact du lanceur, sans choc")
	foe["x"] = 3; foe["y"] = 5
	check(gm.preview_displacement(h, foe, 2).is_empty(), "même case : aucune direction")
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
