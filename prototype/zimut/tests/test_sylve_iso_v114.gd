extends SceneTree
## V114 — Planche iso de la Sylve enrichie : eau/arrière-plan (IsoGround), teinte
## d'altitude des décors, nouveaux bâtiments (puits, feu, étal) bien placés.
## Lancement : godot --headless --path . -s tests/test_sylve_iso_v114.gd
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
	var BA: GDScript = load("res://scripts/BoardArt.gd")
	var AT: GDScript = load("res://scripts/AdventureTerrain.gd")
	var z := "foret_sylve"
	gm.active_save = {"adventure_view": "map"}
	gs.set_sylvestre_board("iso")
	check(BA.file_stem(z) == "foret_sylve_iso", "variante iso active")
	var d: Dictionary = BA.raw(z)
	check(d["mask"].size() == 54 and d["pois"].size() == 20, "masque et 20 lieux inchangés")

	var trail: Dictionary = {}
	for k: Variant in d.get("trail", []):
		trail[String(k)] = true
	var pois: Dictionary = d["pois"]
	var obstacles: Dictionary = d.get("obstacles", {})
	var kinds := {}
	var fp_bad := 0
	for b: Variant in d.get("buildings", []):
		var bd: Dictionary = b
		kinds[String(bd["k"])] = true
		for yy in range(int(bd["y"]), int(bd["y"]) + int(bd["h"])):
			for xx in range(int(bd["x"]), int(bd["x"]) + int(bd["w"])):
				var key := "%d,%d" % [xx, yy]
				if trail.has(key) or pois.has(key) or String(obstacles.get(key, "")) != "building":
					fp_bad += 1
	check(kinds.has("puits") and kinds.has("feu") and kinds.has("etal"), "puits + feu + étal présents : %s" % str(kinds.keys()))
	check(fp_bad == 0, "empreintes des bâtiments = obstacles, hors sentier et lieux")

	# Scène réelle en variante iso
	var data: Dictionary = pm.new_game(4, "TestIsoV114")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "adventure"
	var adv: Dictionary = pm.adventure_state(data)
	pm.adventure_unlock_zone(adv, z)
	pm.adventure_enter_zone(adv, z)
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
	check(sc.is_iso(), "scène en mode iso")
	var counts := {}
	var tinted := 0
	var hs: Dictionary = BA.heights(z)
	var mod_by_h := {}
	for n: Node in sc.get("_entities").get_children():
		if n.get("kind") != null and n.get("fw") != null:
			counts[String(n.get("kind"))] = int(counts.get(String(n.get("kind")), 0)) + 1
		elif n.get("use_sprites") != null or n.get("seed_value") != null:
			var sm: Color = n.get("self_modulate")
			if sm != Color.WHITE:
				tinted += 1
	check(int(counts.get("puits", 0)) >= 1 and int(counts.get("feu", 0)) >= 1 and int(counts.get("etal", 0)) >= 1,
		"bâtiments instanciés : %s" % str(counts))
	check(tinted > 0, "décors teintés selon l'altitude (%d nœuds non blancs)" % tinted)

	# petite marche sur le plateau à étages
	var mgr: Node = sc.get("manager")
	var start: Vector2i = mgr.hero_pos()
	var target := Vector2i(-1, -1)
	var best := 0
	for dy in range(-6, 7):
		for dx in range(-6, 7):
			var c := start + Vector2i(dx, dy)
			var p: Array = mgr.path_to(c)
			if p.size() > best and mgr.poi_at(c).is_empty():
				best = p.size()
				target = c
	check(target.x >= 0 and best >= 3, "cible iso à %d pas (%s)" % [best, str(target)])
	sc._walk(mgr.path_to(target))
	var guard := 0
	while sc.get("_walking") and guard < 5000:
		await process_frame
		guard += 1
	check(mgr.hero_pos() == target, "marche iso terminée à destination : %s" % str(mgr.hero_pos()))
	gs.set_sylvestre_board("v2")
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
