extends SceneTree
## V82 : monde ouvert — zones de nation agrandies (54×36), relief par nation, 3 donjons à paliers
## par nation (Pierre seulement au palier 3), lieux/énigmes cohérents.
## Lancement : xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/test_monde_ouvert_v82.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var pm: Node = root.get_node("/root/ProgressionManager")
	var AT: GDScript = load("res://scripts/AdventureTerrain.gd")
	var D: GDScript = load("res://scripts/Dungeons.gd")
	var W: GDScript = load("res://scripts/adventure3d/Adv3DWorld.gd")
	var nations: Array = ["foret_sylve", "brasier_cendres", "brumes_marais", "montagne_pics", "vents_plateau",
		"ombres_necropole", "desert_dunes", "marees_cotes", "cristaux_caverne", "rouages_atelier"]
	for z: String in nations:
		var meta: Dictionary = pm.ADVENTURE_ZONES[z]
		var sz: Array = meta["size"]
		check(sz == [54, 36], "%s : zone 54×36" % z)
		var pois: Dictionary = pm.pois_of(z)
		var tiers: Dictionary = {}
		var inside := true
		for k: String in pois.keys():
			var p: Vector2i = AT.parse(k)
			if p.x < 0 or p.y < 0 or p.x >= 54 or p.y >= 36:
				inside = false
			var g: String = String(pois[k].get("guardian", ""))
			if g != "":
				tiers[D.tier(g)] = g
		check(inside, "%s : tous les lieux dans la zone" % z)
		check(tiers.size() == 3 and tiers.has(2) and tiers.has(4) and tiers.has(5), "%s : 3 donjons (paliers 2, 4 et Gardien)" % z)
		var t: Dictionary = AT.zone_terrain(z)
		var bad := 0
		for k2: String in pois.keys():
			var p2: Vector2i = AT.parse(k2)
			if (t["voids"] as Dictionary).has(p2) or (p2 != t["start"] and AT.find_path(z, t["start"], p2).is_empty()):
				bad += 1
		check(bad == 0, "%s : lieux et donjons accessibles" % z)
		if tiers.size() == 3:
			var l1: int = D.room_level(tiers[2], 4)
			var l2: int = D.room_level(tiers[4], 4)
			var l3: int = D.room_level(tiers[5], 4)
			check(l1 <= l2 and l2 <= l3, "%s : niveaux croissants entre paliers (%d ≤ %d ≤ %d)" % [z, l1, l2, l3])
	# Pierre : seulement au palier 3
	var adv: Dictionary = {}
	var key1: String = D.tier_key("Forêt", 1)
	check(D.base(key1) == "Forêt" and D.tier(key1) == 1 and D.tier("Forêt") == D.TIERS, "clés de palier : base / palier")
	for i: int in range(3):
		D.begin(adv, key1)
		D.win_room(adv, key1, 0.0, false)
	D.begin(adv, key1)
	var r: Dictionary = D.win_room(adv, key1, 0.0, false)
	check(bool(r["cleared"]) and String(r["stone_roll"]) == "" and D.stone_chance(adv, key1) == 0.0, "palier 1 : donjon bouclé, aucune Pierre")
	check(D.clears(adv, key1) == 1 and D.clears(adv, "Forêt") == 0, "bilans séparés par palier")
	# Relief
	W.set_relief("montagne_pics", true)
	var hmin: float = 99.0
	var hmax: float = -99.0
	for x: int in range(0, 54, 2):
		for y: int in range(0, 36, 2):
			var h: float = W.corner_h(x, y)
			hmin = minf(hmin, h)
			hmax = maxf(hmax, h)
	check(hmax - hmin > 2.5, "relief de montagne marqué (%.1f d'écart)" % (hmax - hmin))
	var st: Array = pm.ADVENTURE_ZONES["montagne_pics"]["start"]
	check(absf(W.corner_h(int(st[0]), int(st[1]))) < 0.3, "le départ reste sur un replat")
	W.set_relief("montagne_pics", false)
	check(absf(W.corner_h(10, 10)) <= 0.61, "vue iso : relief doux historique")
	# Carte du monde peinte
	check(ResourceLoader.exists("res://assets/ui/conquest/conquest_world_map.jpg"), "carte peinte présente")
	var wm: GDScript = load("res://scripts/adventure3d/Adv3DWorldMap.gd")
	for z2: String in pm.ADVENTURE_ZONES.keys():
		check(wm.NATION_POS.has(z2), "carte du monde : repère pour %s" % z2)
	print("OK" if fails == 0 else "ÉCHEC")
	quit(fails)
