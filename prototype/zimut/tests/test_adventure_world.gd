extends SceneTree
## Tests du monde d'Aventure en grille (façon Dofus Touch) : cartes voisines,
## portes au bord de l'île, routes gardées, passage d'une carte à l'autre,
## lisières de biomes et couverture des villes de Conquête.
## Lancement : godot --headless --path . -s tests/test_adventure_world.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	# ── Grille du monde ───────────────────────────────────────────────────
	var seen: Dictionary = {}
	for z: String in pm.ADVENTURE_ZONES.keys():
		var g: Vector2i = pm.adventure_zone_grid(z)
		check(not seen.has(g), "%s : case de grille unique %s" % [z, g])
		seen[g] = z
	# Toutes les cartes sont reliées à la Sylve
	var reach: Dictionary = {"foret_sylve": true}
	var queue: Array = ["foret_sylve"]
	while not queue.is_empty():
		var cur: String = queue.pop_front()
		for dir: String in pm.ADVENTURE_DIRS.keys():
			var nb: String = pm.adventure_neighbor(cur, dir)
			if nb != "" and not reach.has(nb):
				reach[nb] = true
				queue.append(nb)
	check(reach.size() == pm.ADVENTURE_ZONES.size(), "toutes les cartes sont reliées à la Sylve (%d/%d)" % [reach.size(), pm.ADVENTURE_ZONES.size()])
	for z2: String in pm.ADVENTURE_ZONES.keys():
		var t: Dictionary = AdventureTerrain.zone_terrain(z2)
		for gp: Vector2i in pm.adventure_gates(z2).keys():
			var info: Dictionary = pm.adventure_gates(z2)[gp]
			var back: String = pm.adventure_neighbor(String(info["to"]), String(pm.ADVENTURE_OPPOSITE[info["dir"]]))
			check(back == z2, "%s → %s : la route est réciproque" % [z2, info["to"]])
			check(not t["obstacles"].has(gp) and pm.adventure_poi(z2, gp).is_empty(), "%s : porte %s libre (ni obstacle ni lieu)" % [z2, info["dir"]])
			check(gp == t["start"] or not AdventureTerrain.find_path(z2, t["start"], gp).is_empty(), "%s : porte %s accessible depuis le départ" % [z2, info["dir"]])
			var arrive: Vector2i = pm.adventure_gate_cell(String(info["to"]), String(pm.ADVENTURE_OPPOSITE[info["dir"]])) - pm.ADVENTURE_DIRS[pm.ADVENTURE_OPPOSITE[info["dir"]]]
			check(AdventureTerrain.walkable(String(info["to"]), arrive), "%s → %s : case d'arrivée franchissable" % [z2, info["to"]])
	# V81 : une grande zone par nation, 1 à 2 portails max par zone
	var nation_zones: int = 0
	for z4: String in pm.ADVENTURE_ZONES.keys():
		var meta: Dictionary = pm.ADVENTURE_ZONES[z4]
		var sz: Array = meta.get("size", [14, 10])
		if String(meta.get("biome", "")) != "Donjon":
			nation_zones += 1
			check(int(sz[0]) >= 30 and int(sz[1]) >= 20, "%s : grande zone de nation %s" % [z4, str(sz)])
			var ng: int = pm.adventure_gates(z4).size()
			check(ng >= 1 and ng <= 2, "%s : %d portail(s) (1 à 2 max)" % [z4, ng])
	check(nation_zones == 10, "10 nations = 10 grandes zones (%d)" % nation_zones)

	# Couverture Conquête : chaque ville (hors capitale) est révélée par une carte
	var revealed: Dictionary = {}
	for z3: String in pm.ADVENTURE_ZONES.keys():
		for c: String in pm.ADVENTURE_ZONES[z3].get("reveals", []):
			revealed[c] = true
			check(pm.CONQUEST_CITIES.has(c), "%s révèle une ville connue (%s)" % [z3, c])
	var missing: Array = []
	for c2: String in pm.CONQUEST_CITIES.keys():
		if c2 != "capitale" and not revealed.has(c2):
			missing.append(c2)
	check(missing.is_empty(), "toutes les villes de Conquête sont révélables %s" % str(missing))

	# ── Passage d'une carte à l'autre ─────────────────────────────────────
	var data: Dictionary = pm.new_game(3, "AdvWorld")
	pm.rebuild_team(data, ["Tank", "Mage", "Sylvain"])
	gm.active_save = data
	gm.active_slot = 3
	var mgr: Node = Node.new()
	mgr.set_script(load("res://scripts/AdventureManager.gd"))
	root.add_child(mgr)
	await process_frame
	var adv: Dictionary = mgr.state
	check(not pm.adventure_gate_open(adv, "foret_sylve", "brasier_cendres"), "route vers les Terres de Cendre (niv 18) gardée au départ")
	check(pm.adventure_gate_lock_reason(adv, "foret_sylve", "brasier_cendres").contains("Camp gobelin"), "le message nomme le gardien")
	var east: Vector2i = pm.adventure_gate_cell("foret_sylve", "E")
	adv["hero_pos"] = [east.x, east.y]
	check(not mgr.cross_gate(east), "porte fermée : on reste sur la carte")
	check(mgr.zone_id() == "foret_sylve", "toujours dans la Sylve")
	adv["completed"].append("foret_sylve,10,3")
	check(mgr.gate_at(east)["open"], "Camp gobelin vaincu : la route s'ouvre")
	check(mgr.cross_gate(east), "passage de la frontière est")
	check(mgr.zone_id() == "brasier_cendres", "arrivée dans les Terres de Cendre (nation Brasier)")
	check(mgr.hero_pos() == pm.adventure_gate_cell("brasier_cendres", "W") + Vector2i(1, 0), "le héros entre par l'ouest, à côté de la porte")
	check(mgr.cell_discovered(pm.adventure_gate_cell("brasier_cendres", "W") + Vector2i(1, 0)) and mgr.cell_discovered(pm.adventure_gate_cell("brasier_cendres", "W")), "le brouillard se lève à l'arrivée")
	check(mgr.visited_zones().has("brasier_cendres"), "les Terres de Cendre rejoignent les cartes visitées")
	var west: Vector2i = pm.adventure_gate_cell("brasier_cendres", "W")
	check(pm.adventure_gate_open(adv, "brasier_cendres", "foret_sylve"), "retour vers une carte plus facile toujours ouvert")
	adv["hero_pos"] = [west.x, west.y]
	check(mgr.cross_gate(west) and mgr.zone_id() == "foret_sylve", "retour dans la Sylve par l'ouest des Terres de Cendre")
	check(mgr.hero_pos() == east - Vector2i(1, 0), "arrivée juste devant la porte est de la Sylve")
	# Un chemin ne traverse jamais une porte par accident
	var through: Array[Vector2i] = mgr.path_to(Vector2i(8, 3))
	check(not through.has(east), "le trajet évite la porte quand elle n'est pas la destination")
	# Voyage rapide vers une carte visitée
	check(mgr.enter_zone("brasier_cendres") and mgr.zone_id() == "brasier_cendres", "voyage rapide vers une carte visitée")
	check(not mgr.enter_zone("portes_donjon"), "pas de voyage rapide vers une carte jamais visitée")
	# Ancienne sauvegarde : les zones fondues disparaissent, celles connues sont conservées
	var old: Dictionary = {"zone": "montagne_pics", "hero_pos": [3, 3], "discovered": [], "completed": [],
		"zones_unlocked": ["foret_sylve", "foret_ronces", "montagne_pics", "desert_dunes"]}
	var od: Dictionary = {"adventure": old}
	pm.adventure_state(od)
	check(pm.adventure_gate_open(od["adventure"], "montagne_pics", "brumes_marais"), "ancienne partie : descente vers les Brumes ouverte (niv 26 ≤ 32)")
	check(pm.adventure_available_zones(od["adventure"]).has("desert_dunes"), "ancienne partie : zones déjà débloquées conservées")
	check(not pm.adventure_available_zones(od["adventure"]).has("foret_ronces"), "ancienne partie : zone fondue retirée des débloquées")

	pm.delete_save(3)
	print("\n%s — %d échec(s)" % ["OK" if fails == 0 else "KO", fails])
	quit(1 if fails > 0 else 0)
