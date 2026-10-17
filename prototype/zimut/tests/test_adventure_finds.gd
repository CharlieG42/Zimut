extends SceneTree
## Trouvailles cachées et zones de nation en Aventure.
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
	for z: String in ["vents_plateau", "brumes_marais", "brasier_cendres", "ombres_necropole", "cristaux_caverne", "marees_cotes"]:
		check(pm.ADVENTURE_ZONES.has(z), "%s : zone au catalogue" % z)
		var biome: String = String(pm.ADVENTURE_ZONES[z]["biome"])
		check(Nations.is_new(biome), "%s : biome de nation (%s)" % [z, biome])
		var finds: Dictionary = AdventureTerrain.finds_of(z)
		check(finds.size() == 6, "%s : 6 trouvailles (%d)" % [z, finds.size()])
		var t: Dictionary = AdventureTerrain.zone_terrain(z)
		var ok: bool = true
		for p: Vector2i in finds.keys():
			if (t["obstacles"] as Dictionary).has(p) or AdventureTerrain.find_path(z, t["start"], p).is_empty():
				ok = false
		check(ok, "%s : trouvailles accessibles et hors obstacles" % z)
		AdventureTerrain._cache.clear()
		check(AdventureTerrain.finds_of(z) == finds, "%s : trouvailles déterministes" % z)
	var data: Dictionary = pm.new_game(4, "FindTest")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "adventure"
	var adv: Dictionary = pm.adventure_state(data)
	pm.adventure_enter_zone(adv, "foret_sylve")
	gm.active_save = data
	gm.active_slot = 4
	var mgr: Node = (load("res://scripts/AdventureManager.gd") as GDScript).new()
	root.add_child(mgr)
	mgr.load_state(data, 4)
	var finds2: Dictionary = AdventureTerrain.finds_of(mgr.zone_id())
	var cell: Vector2i = finds2.keys()[0]
	var gold0: int = int(data.get("gold", 0))
	var xp_before: int = 0
	var got: Dictionary = mgr.collect_find(cell)
	check(not got.is_empty() and String(got.get("text", "")) != "", "ramassage : %s" % String(got.get("text", "")))
	check(mgr.find_taken(cell), "trouvaille marquée comme prise")
	check(mgr.collect_find(cell).is_empty(), "on ne ramasse pas deux fois")
	var pr: Dictionary = mgr.finds_progress()
	check(int(pr["found"]) == 1 and int(pr["total"]) == 6, "progression 1/6")
	pm.delete_save(4)
	quit(1 if fails > 0 else 0)
