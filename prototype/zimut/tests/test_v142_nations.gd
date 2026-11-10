extends SceneTree
## V142 : 5 donjons par Nation dans le monde généré, accès aux Nations par les donjons, sentiers en réseau,
## neige des Cimes. Lancement : godot --headless --path . -s tests/test_v142_nations.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _all(nation: String) -> Dictionary:
	var out: Dictionary = {}
	for k: String in ["%s#1" % nation, "%s#2" % nation, "%s#3" % nation, "%s#4" % nation, nation]:
		out[k] = {"clears": 1, "boss_kills": 1}
	return out
func _boot() -> void:
	var pm: Node = root.get_node("/root/ProgressionManager")
	var gm: Node = root.get_node("/root/GameManager")
	var AT: GDScript = load("res://scripts/AdventureTerrain.gd")
	var D: GDScript = load("res://scripts/Dungeons.gd")
	var data: Dictionary = pm.new_game(4, "V142")
	data["adventure_view"] = "open3d"          # monde généré (pas les planches 2D)
	gm.active_save = data
	var chain: Array = pm.adventure_chain()
	check(chain.size() == pm.ADVENTURE_ZONES.size() and chain[0] == "foret_sylve" and chain[chain.size() - 1] == "portes_donjon", "ordre des Nations : de la Sylve aux Portes du Donjon (%d zones)" % chain.size())
	# ── 5 donjons par Nation, aux mêmes noms que les planches 2D
	for z: String in ["foret_sylve", "brasier_cendres", "brumes_marais", "montagne_pics"]:
		var tiers: Dictionary = {}
		var pois: Dictionary = pm.pois_of(z)
		for k: String in pois.keys():
			var g: String = String(pois[k].get("guardian", ""))
			if g != "":
				tiers[D.tier(g)] = String(pois[k]["name"])
		check(tiers.size() == 5, "%s : 5 donjons dans le monde généré" % z)
		var t: Dictionary = AT.zone_terrain(z)
		var ok_reach := true
		for k2: String in pois.keys():
			if String(pois[k2].get("guardian", "")) != "" and AT.find_path(z, t["start"], AT.parse(k2)).is_empty():
				ok_reach = false
		check(ok_reach, "%s : chaque donjon est accessible depuis le départ" % z)
	var names: Dictionary = {}
	for k3: String in pm.pois_of("foret_sylve").keys():
		names[String(pm.pois_of("foret_sylve")[k3]["name"])] = true
	check(names.has("Grotte de la Feuille") and names.has("Crypte du Chêne Noir"), "Sylve : mêmes noms de donjons que la carte 2D")
	# ── accès aux Nations
	var adv: Dictionary = pm.adventure_state(data)
	check(not pm.adventure_gate_open(adv, "foret_sylve", "brasier_cendres"), "départ : portail vers les Cendres scellé")
	check(pm.adventure_dungeons_left(adv, "foret_sylve").size() == 5, "départ : 5 donjons à terminer")
	adv["dungeons"] = {"Forêt": {"clears": 1, "boss_kills": 1}}
	check(not pm.adventure_gate_open(adv, "foret_sylve", "brasier_cendres"), "donjon final seul : toujours scellé")
	adv["dungeons"] = _all("Forêt")
	check(pm.adventure_gate_open(adv, "foret_sylve", "brasier_cendres"), "5 donjons terminés : portail ouvert, sans condition de niveau")
	check(not pm.adventure_gate_open(adv, "brasier_cendres", "brumes_marais"), "la Nation d'après reste scellée")
	check(pm.adventure_gate_open(adv, "brasier_cendres", "foret_sylve"), "le retour est toujours ouvert")
	# ancienne sauvegarde : Nations ouvertes trop tôt → refermées
	adv["zones_unlocked"] = ["foret_sylve", "brasier_cendres", "vents_plateau", "rouages_atelier"]
	adv = pm.adventure_state(data)
	var zl: Array = adv["zones_unlocked"]
	check(zl.has("foret_sylve") and zl.has("brasier_cendres") and not zl.has("vents_plateau") and not zl.has("rouages_atelier"), "ancienne sauvegarde : seules les Nations méritées restent ouvertes %s" % str(zl))
	# victoire du dernier donjon manquant → la Nation suivante s'ouvre
	var d2: Dictionary = pm.new_game(4, "V142b")
	d2["adventure_view"] = "open3d"
	var a2: Dictionary = pm.adventure_state(d2)
	a2["dungeons"] = _all("Forêt")
	(a2["dungeons"] as Dictionary).erase("Forêt#3")
	a2["dungeon_rooms"] = {"Forêt#3": D.ROOMS}
	d2["last_result"] = {}
	pm._dungeon_victory(d2, a2, "foret_sylve,1,1", "Forêt#3")
	check(String((d2["last_result"]["dungeon"] as Dictionary).get("unlocked_zone", "")) == "brasier_cendres", "dernier donjon manquant terminé (même un palier) → Terres de Cendre débloquées")
	# ── sentiers : un réseau d'un seul tenant, qui relie tous les lieux, sans peigne de couloirs parallèles
	for z2: String in ["foret_sylve", "montagne_pics", "desert_dunes"]:
		var t2: Dictionary = AT.zone_terrain(z2)
		var paths: Dictionary = t2["paths"]
		var seen: Dictionary = {t2["start"]: true}
		var queue: Array = [t2["start"]]
		var head: int = 0
		while head < queue.size():
			var cur: Vector2i = queue[head]
			head += 1
			for dd: Vector2i in [Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(0, -1)]:
				if paths.has(cur + dd) and not seen.has(cur + dd):
					seen[cur + dd] = true
					queue.append(cur + dd)
		check(seen.size() == paths.size(), "%s : sentiers d'un seul tenant (%d cases)" % [z2, paths.size()])
		var all_on := true
		for p: Vector2i in t2["pois"]:
			if not paths.has(p):
				all_on = false
		check(all_on, "%s : chaque lieu est sur un sentier" % z2)
		# plus longue ligne droite verticale : l'ancien tracé alignait des couloirs sur presque toute la hauteur
		var longest: int = 0
		var sz: Vector2i = t2["size"]
		for x: int in range(sz.x):
			var run: int = 0
			for y: int in range(sz.y):
				run = run + 1 if paths.has(Vector2i(x, y)) else 0
				longest = maxi(longest, run)
		check(longest <= sz.y * 2 / 3, "%s : pas de couloir vertical traversant (plus longue ligne droite : %d cases)" % [z2, longest])
	# ── neige des Cimes
	var M: GDScript = load("res://scripts/adventure3d/Adv3DMeshes.gd")
	check(M.is_snow_biome("Montagne") and not M.is_snow_biome("Forêt"), "la neige ne concerne que les Cimes")
	check(String(ProjectSettings.get_setting("shader_globals/zimut_snow", {}).get("type", "")) == "float", "paramètre global de shader « zimut_snow » déclaré")
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
