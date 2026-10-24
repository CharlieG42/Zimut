extends SceneTree
## V47 : Sylve agrandie (22 × 16) à contour irrégulier — cases « hors île », lieux et portes accessibles,
## ancienne sauvegarde réparée.
## Lancement : godot --headless --path . -s tests/test_adventure_island.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var zid := "foret_sylve"
	var t: Dictionary = AdventureTerrain.zone_terrain(zid)
	var size: Vector2i = t["size"]
	var voids: Dictionary = t["voids"]
	check(size == Vector2i(22, 16), "la Sylve fait 22 × 16 (%s)" % str(size))
	check(voids.size() >= 15, "contour irrégulier : %d cases hors île" % voids.size())
	# La façade (dernière ligne / dernière colonne) reste pleine : la falaise est dessinée dessous.
	var facade_ok := true
	for v: Vector2i in voids.keys():
		if v.x >= size.x - 1 or v.y >= size.y - 1:
			facade_ok = false
	check(facade_ok, "aucune case vide sur les bords de façade")
	check(not voids.has(t["start"]), "le départ n'est pas hors île")
	var bad := 0
	for g: Vector2i in t["gates"]:
		if voids.has(g) or AdventureTerrain.find_path(zid, t["start"], g).is_empty():
			bad += 1
	check(bad == 0, "toutes les portes sont accessibles")
	for gd: String in ["N", "E", "S", "W"]:
		var gc: Vector2i = AdventureTerrain.gate_cell(zid, gd)
		check(AdventureTerrain.walkable(zid, gc), "porte %s %s franchissable" % [gd, str(gc)])
	var pois: Dictionary = pm.ADVENTURE_POIS[zid]
	check(pois.size() >= 12, "%d lieux dans la Sylve" % pois.size())
	var unreachable := 0
	for k: String in pois.keys():
		var p: Vector2i = AdventureTerrain.parse(k)
		if voids.has(p) or t["obstacles"].has(p) or (p != t["start"] and AdventureTerrain.find_path(zid, t["start"], p).is_empty()):
			unreachable += 1
	check(unreachable == 0, "tous les lieux sont accessibles")
	# Les 6 lieux d'origine gardent leur clé (progression des anciennes sauvegardes).
	for old: String in ["4,1", "7,2", "3,4", "5,5", "8,5", "2,1"]:
		check(pois.has(old), "lieu d'origine %s conservé" % old)
	# Aucune case vide n'est franchissable ni ne reçoit de trouvaille.
	for v2: Vector2i in voids.keys():
		if AdventureTerrain.walkable(zid, v2):
			check(false, "case vide franchissable %s" % str(v2))
			break
	for f: Vector2i in AdventureTerrain.finds_of(zid).keys():
		if voids.has(f):
			check(false, "trouvaille sur une case vide %s" % str(f))
	check(AdventureTerrain.finds_of(zid).size() == 6, "6 trouvailles")
	# Ancienne sauvegarde : héros sur une case devenue hors île → ramené au départ.
	var gm: Node = root.get_node("GameManager")
	var data: Dictionary = pm.new_game(4, "IleTest")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "adventure"
	var adv: Dictionary = pm.adventure_state(data)
	var v0: Vector2i = voids.keys()[0]
	adv["hero_pos"] = [v0.x, v0.y]
	gm.active_save = data
	gm.active_slot = 4
	var mgr: Node = Node.new()
	mgr.set_script(load("res://scripts/AdventureManager.gd"))
	root.add_child(mgr)
	mgr.load_state(data, 4)
	check(AdventureTerrain.walkable(zid, mgr.hero_pos()), "héros sur case vide ramené sur l'île (%s)" % str(mgr.hero_pos()))
	# Plateau assez grand pour la vue défilante sur téléphone.
	var ui_script: GDScript = load("res://scripts/AdventureMapUI.gd")
	check(ui_script.scroll_needed(size, Vector2(1100, 850)), "22 × 16 : défilement activé")
	# Toutes les zones : grandes cartes à contour irrégulier, lieux et portes accessibles.
	var sizes := {}
	for z: String in pm.ADVENTURE_ZONES.keys():
		var tz: Dictionary = AdventureTerrain.zone_terrain(z)
		var sz: Vector2i = tz["size"]
		sizes[str(sz)] = true
		var bad_z := 0
		for k2: String in pm.ADVENTURE_POIS[z].keys():
			var pz: Vector2i = AdventureTerrain.parse(k2)
			if (tz["voids"] as Dictionary).has(pz) or (tz["obstacles"] as Dictionary).has(pz) \
					or (pz != tz["start"] and AdventureTerrain.find_path(z, tz["start"], pz).is_empty()):
				bad_z += 1
		for g2: Vector2i in tz["gates"]:
			if (tz["voids"] as Dictionary).has(g2) or AdventureTerrain.find_path(z, tz["start"], g2).is_empty():
				bad_z += 1
		check(sz.x * sz.y >= 190 and (tz["voids"] as Dictionary).size() >= 15 and bad_z == 0,
			"%s : %s, %d cases hors île, lieux et portes accessibles" % [z, str(sz), (tz["voids"] as Dictionary).size()])
	check(sizes.size() >= 5, "tailles de cartes variées (%s)" % str(sizes.keys()))
	print("OK" if fails == 0 else "ÉCHEC")
	quit(fails)
