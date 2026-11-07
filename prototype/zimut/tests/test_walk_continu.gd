extends SceneTree
## V114 — déplacement continu du héros sur la carte (polyligne à coins arrondis).
## Vérifie que _walk mène bien le héros à destination, visuellement calé sur la case.
## Lancement : godot --headless --path . -s tests/test_walk_continu.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1

func _init() -> void:
	_boot.call_deferred()

func _boot() -> void:
	var gm: Node = root.get_node("/root/GameManager")
	var gs: Node = root.get_node("/root/GameSettings")
	var pm: Node = root.get_node("/root/ProgressionManager")
	var z := "foret_sylve"
	gm.active_save = {"adventure_view": "map"}
	gs.set_sylvestre_board("v2")
	var data: Dictionary = pm.new_game(4, "TestWalkV114")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "adventure"
	var adv: Dictionary = pm.adventure_state(data)
	pm.adventure_unlock_zone(adv, z)
	pm.adventure_enter_zone(adv, z)
	# aucun monstre ne doit bloquer le trajet pendant le test
	var mobs: Dictionary = adv.get("mobs", {})
	mobs[z] = []
	adv["mobs"] = mobs
	var nxt: Dictionary = adv.get("mob_next", {})
	nxt[z] = 1000000000
	adv["mob_next"] = nxt
	gm.active_save = data
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/AdventureMap.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	for i in 10:
		await process_frame
	var mgr: Node = sc.get("manager")
	var start: Vector2i = mgr.hero_pos()
	var target := Vector2i(-1, -1)
	var best := 0
	for dy in range(-8, 9):
		for dx in range(-8, 9):
			var c := start + Vector2i(dx, dy)
			var p: Array = mgr.path_to(c)
			if p.size() > best and mgr.poi_at(c).is_empty():
				best = p.size()
				target = c
	check(target.x >= 0 and best >= 5, "cible à %d pas trouvée (%s)" % [best, str(target)])
	var path: Array = mgr.path_to(target)
	check(path.size() == best, "chemin recalculé identique (%d)" % path.size())
	sc._walk(path)
	var guard := 0
	while sc.get("_walking") and guard < 5000:
		await process_frame
		guard += 1
	check(not sc.get("_walking"), "marche terminée (guard=%d)" % guard)
	check(mgr.hero_pos() == target, "héros arrivé à destination : %s vs %s" % [str(mgr.hero_pos()), str(target)])
	var dc: Vector2 = sc.cell_center(target) - sc.get("_hero").position
	check(dc.length() < 40.0, "héros visuellement calé sur la case (écart %.1f px)" % dc.length())
	# un trajet avec un virage : le chemin adouci ne passe pas par les sommets d'angle
	var pts: Array[Vector2] = [Vector2(0, 0), Vector2(64, 0), Vector2(64, 64)]
	var sp: Array = sc._smooth_path(pts)
	check(sp[1].distance_to(Vector2(64, 0)) > 1.0 and sp[0] == Vector2(0, 0) and sp[2] == Vector2(64, 64),
		"coins arrondis : sommet intérieur déplacé %s" % str(sp[1]))
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
