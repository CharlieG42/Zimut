extends SceneTree
## Portail vers la Nation suivante (V104) : scellé tant que le donjon final n'est pas vaincu.
## Lancement : godot --headless --path . -s tests/test_portail_nations.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var gm: Node = root.get_node("/root/GameManager")
	var pm: Node = root.get_node("/root/ProgressionManager")
	var AT: GDScript = load("res://scripts/AdventureTerrain.gd")
	var BA: GDScript = load("res://scripts/BoardArt.gd")
	var D: GDScript = load("res://scripts/Dungeons.gd")
	var z := "foret_sylve"
	var data: Dictionary = pm.new_game(4, "PortailTest")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "adventure"
	data["adventure_view"] = "map"
	var adv: Dictionary = pm.adventure_state(data)
	pm.adventure_enter_zone(adv, z)
	gm.active_save = data
	gm.active_slot = 4
	var mgr: Node = (load("res://scripts/AdventureManager.gd") as GDScript).new()
	root.add_child(mgr)
	mgr.load_state(data, 4)
	var portal_key: String = ""
	for k: String in pm.pois_of(z).keys():
		if bool(pm.pois_of(z)[k].get("portal", false)):
			portal_key = k
	check(portal_key != "", "la Sylve possède un portail")
	var p: Vector2i = AT.parse(portal_key)
	var poi: Dictionary = pm.pois_of(z)[portal_key]
	check(String(poi["kind"]) == "exit" and String(poi["requires"]) == "Forêt" and pm.ADVENTURE_ZONES.has(String(poi["to"])), "portail : sortie vers une zone existante")
	check(String(pm.ADVENTURE_ZONES[String(poi["to"])]["unlock"]) == z, "la destination est bien la Nation suivante (%s)" % String(poi["to"]))
	check(AT.walkable(z, p) and not AT.find_path(z, BA.start(z), p).is_empty(), "portail jouable et accessible")
	# scellé
	mgr.state["hero_pos"] = [p.x, p.y]
	check(not mgr.portal_lock(poi).is_empty() and String(mgr.portal_lock(poi).get("name", "")) == "Donjon de la Nation Sylvestre", "scellé : attend le donjon final")
	var cmd: Dictionary = mgr.interact()
	check(String(cmd.get("action", "")) == "portal_locked", "interaction : portail scellé")
	check(not (mgr.state.get("zones_unlocked", []) as Array).has(String(poi["to"])), "zone suivante pas encore ouverte")
	# un palier inférieur terminé ne suffit pas
	mgr.state["dungeons"] = {"Forêt#4": {"clears": 1, "boss_kills": 1}}
	check(not mgr.portal_lock(poi).is_empty(), "palier 4 terminé : portail toujours scellé")
	# victoire du donjon final : la Nation suivante s'ouvre
	var res_adv: Dictionary = mgr.state
	res_adv["zone"] = z
	data["last_result"] = {}
	res_adv["dungeon"] = {"biome": "Forêt", "room": D.ROOMS, "session": D.session}
	pm._dungeon_victory(data, res_adv, "%s,45,27" % z, "Forêt")
	var dres: Dictionary = data["last_result"]["dungeon"]
	check(bool(dres["cleared"]) and String(dres.get("unlocked_zone", "")) == String(poi["to"]), "donjon final vaincu → %s débloquée" % String(poi["to"]))
	check((data["adventure"]["zones_unlocked"] as Array).has(String(poi["to"])), "zone ajoutée aux zones débloquées")
	mgr.load_state(data, 4)
	mgr.state["hero_pos"] = [p.x, p.y]
	check(mgr.portal_lock(poi).is_empty(), "portail ouvert")
	cmd = mgr.interact()
	check(String(cmd.get("action", "")) == "exit" and bool(cmd.get("portal", false)), "interaction : le portail s'ouvre")
	mgr.take_exit(String(cmd["key"]))
	check(not mgr.poi_done(p), "le portail reste utilisable (jamais « terminé »)")
	check(mgr.interact().get("action", "") == "exit", "…et se reprend à volonté")
	check(mgr.enter_zone(String(poi["to"])) and mgr.zone_id() == String(poi["to"]), "traversée : arrivée dans la Nation suivante")
	var prog: Dictionary = {}
	mgr.enter_zone(z)
	prog = mgr.zone_progress()
	check(int(prog["total"]) == pm.pois_of(z).size() - 3, "le portail ne compte pas dans les lieux à explorer (%d)" % int(prog["total"]))
	# une fois débloqué, le portail reste ouvert même si le compteur de donjon est perdu
	mgr.state["dungeons"] = {}
	check(mgr.portal_lock(poi).is_empty(), "portail toujours ouvert une fois la zone débloquée")
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
