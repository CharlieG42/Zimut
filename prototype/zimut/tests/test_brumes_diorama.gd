extends SceneTree
## V136 — Carte « Diorama » des Brumes (Marais des Brumes) : planche, lieux, donjons, portail, règles de voyage.
## Lancement : godot --headless --path . -s tests/test_brumes_diorama.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1

func _init() -> void:
	_boot.call_deferred()

func _reach(BA: GDScript, z: String, st: Vector2i) -> Dictionary:
	var seen := {st: true}
	var q: Array[Vector2i] = [st]
	while not q.is_empty():
		var p: Vector2i = q.pop_back()
		for dd: Vector2i in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
			var n: Vector2i = p + dd
			if not seen.has(n) and BA.walkable_cell(z, n):
				seen[n] = true
				q.append(n)
	return seen

func _boot() -> void:
	var gm: Node = root.get_node("/root/GameManager")
	var gs: Node = root.get_node("/root/GameSettings")
	var pm: Node = root.get_node("/root/ProgressionManager")
	var BA: GDScript = load("res://scripts/BoardArt.gd")
	var AT: GDScript = load("res://scripts/AdventureTerrain.gd")
	var DG: GDScript = load("res://scripts/Dungeons.gd")
	var before: String = gs.sylvestre_board
	gm.active_save = {"adventure_view": "map"}
	var z := "brumes_marais"
	gs.set_sylvestre_board("v2")
	check(not BA.is_diorama(z), "hors réglage Diorama : les Brumes gardent leur carte générée")
	gs.set_sylvestre_board("diorama")
	check(BA.file_stem(z) == "brumes_marais_diorama" and BA.is_diorama(z), "réglage Diorama : planche des Brumes")
	check(not BA.is_diorama("vents_plateau"), "les Nations suivantes gardent leur carte")
	var d: Dictionary = BA.raw(z)
	check(BA.size(z) == Vector2i(144, 144), "monde 144x144 cases")
	var tiles: Array = BA.diorama_tiles(z)
	var ok_t: bool = tiles.size() == 16
	for t: Dictionary in tiles:
		ok_t = ok_t and load(String(t["path"])) is Texture2D
	check(ok_t, "16 tuiles de fond chargeables")
	check(not BA.diorama_low(z).is_empty() and load(String(BA.diorama_low(z)["path"])) is Texture2D, "fond basse définition")
	var occ: Array = BA.diorama_occluders(z)
	check(occ.size() >= 150, "occultants (%d)" % occ.size())
	var vram := true
	for f: String in DirAccess.get_files_at("res://assets/boards/brumes_diorama/"):
		if f.ends_with(".import") and f != "fx.png.import":      # V127 : le masque d'effets reste sans perte (1280 × 720)
			var txt: String = FileAccess.get_file_as_string("res://assets/boards/brumes_diorama/" + f)
			vram = vram and txt.contains("compress/mode=2") and txt.contains("mipmaps/generate=true")
	check(vram, "textures compressées pour le GPU, avec mipmaps")
	# lieux : 5 donjons (paliers 1..4 + Nation), portail vers les Brumes, tous atteignables
	var pois: Dictionary = BA.pois(z)
	var guardians: Array = []
	var portal := false
	for k: String in pois.keys():
		var p: Dictionary = pois[k]
		if DG.is_dungeon(p):
			guardians.append(String(p["guardian"]))
		if String(p.get("kind", "")) == "exit" and bool(p.get("portal", false)) and String(p.get("requires", "")) == "Brumes":
			portal = true
	guardians.sort()
	check(guardians == ["Brumes", "Brumes#1", "Brumes#2", "Brumes#3", "Brumes#4"], "5 donjons des Brumes %s" % [guardians])
	check(portal, "portail vers les Cimes scellé par le Gardien des Brumes")
	check(pois.size() >= 18, "%d lieux" % pois.size())
	var st: Vector2i = BA.start(z)
	var seen: Dictionary = _reach(BA, z, st)
	var miss: Array = []
	for k: String in pois.keys():
		if not seen.has(AT.parse(k)):
			miss.append(String(pois[k]["name"]))
	check(miss.is_empty(), "tous les lieux atteignables %s" % [miss])
	check(seen.size() > 9000, "grande surface jouable (%d cases)" % seen.size())
	check(not AT.walkable(z, Vector2i(3, 6)), "départ du catalogue fermé : départ de la planche")
	# mares infranchissables : le masque d'effets repère de l'eau, et le centre de la plus grande mare est fermé
	var fx: Dictionary = BA.diorama_fx(z)
	check(not fx.is_empty() and not BA.diorama_light(z).is_empty(), "masque d'effets et carte de lumière présents")
	check(not BA.walkable_cell(z, Vector2i(75, 111)), "grande mare infranchissable")
	# entrée dans la zone
	var data: Dictionary = {"adventure_view": "map"}
	gm.active_save = data
	var adv: Dictionary = pm.adventure_state(data)
	adv["zones_unlocked"] = ["foret_sylve", "brasier_cendres", "brumes_marais"]
	pm.adventure_enter_zone(adv, z)
	check(Vector2i(int(adv["hero_pos"][0]), int(adv["hero_pos"][1])) == st, "entrée : héros au départ du bourg")
	# V118 : règles de voyage — N-1 toujours accessible, N+1 seulement après le Gardien de N
	var back_key := ""
	var portal_key := ""
	for k: String in pois.keys():
		if String(pois[k].get("kind", "")) == "exit":
			if bool(pois[k].get("back", false)) and String(pois[k].get("to", "")) == "brasier_cendres":
				back_key = k
			elif bool(pois[k].get("portal", false)):
				portal_key = k
	check(back_key != "" and seen.has(AT.parse(back_key)), "sentier de retour vers le Brasier, atteignable")
	var mgr: Node = load("res://scripts/AdventureManager.gd").new()
	root.add_child(mgr)
	mgr.load_state(data, -1)
	mgr.state = adv
	check(not mgr.portal_lock(pois[portal_key]).is_empty(), "portail vers les Cimes scellé tant que le Gardien règne")
	check(mgr.portal_lock(pois[back_key]).is_empty(), "le sentier de retour n'est jamais scellé")
	var revealed: Array = pm.adventure_complete_poi(adv, "%s,%s" % [z, back_key], "exit")
	check(revealed.is_empty() and not (adv["zones_unlocked"] as Array).has("montagne_pics"), "prendre le sentier de retour ne débloque pas les Cimes")
	check((adv["zones_unlocked"] as Array).has("brasier_cendres"), "le Brasier reste accessible")
	# V142 : le portail ne débloque la suite que si les 5 donjons de la Nation sont terminés
	pm.adventure_complete_poi(adv, "%s,%s" % [z, portal_key], "exit")
	check(not (adv["zones_unlocked"] as Array).has("montagne_pics"), "V142 : donjons non terminés, le portail ne débloque rien")
	adv["dungeons"] = {"Brumes#1": {"clears": 1, "boss_kills": 1}, "Brumes#2": {"clears": 1, "boss_kills": 1}, "Brumes#3": {"clears": 1, "boss_kills": 1}, "Brumes#4": {"clears": 1, "boss_kills": 1}, "Brumes": {"clears": 1, "boss_kills": 1}}
	pm.adventure_complete_poi(adv, "%s,%s" % [z, portal_key], "exit")
	check((adv["zones_unlocked"] as Array).has("montagne_pics"), "le portail (une fois ouvert) débloque bien les Cimes")
	mgr.queue_free()
	# un bâtiment devant chaque donjon, un donjon par coin, celui de la Nation au centre
	for pair: Array in [[z, occ]]:
		var zz: String = pair[0]
		var near := 0
		var n_d := 0
		for k: String in BA.pois(zz).keys():
			if not DG.is_dungeon(BA.pois(zz)[k]):
				continue
			n_d += 1
			var pc: Vector2i = AT.parse(k)
			for o: Dictionary in pair[1]:
				var oc: Vector2i = o["cell"]
				if absi(oc.x - pc.x) + absi(oc.y - pc.y) <= 12 and String(o["kind"]) == "dungeon":
					near += 1
					break
		check(n_d == 5 and near == n_d, "%s : un bâtiment devant chacun des %d donjons (%d)" % [zz, n_d, near])
		# V122 : règle de placement — un donjon par coin du monde (haut, droite, bas, gauche), celui de la Nation au centre
		var tips: Array = [Vector2(0, 0), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1)]
		var used: Array = []
		var centre_ok := false
		for k2: String in BA.pois(zz).keys():
			var pd: Dictionary = BA.pois(zz)[k2]
			if not DG.is_dungeon(pd):
				continue
			var c2: Vector2i = AT.parse(k2)
			var uv := Vector2(c2.x / 144.0, c2.y / 144.0)
			if String(pd.get("name", "")).contains("Nation"):
				centre_ok = uv.distance_to(Vector2(0.5, 0.5)) < 0.12
				continue
			var best := 0
			for ti in range(4):
				if uv.distance_to(tips[ti]) < uv.distance_to(tips[best]):
					best = ti
			if uv.distance_to(tips[best]) <= 0.42 and not used.has(best):
				used.append(best)
		check(centre_ok and used.size() == 4, "%s : donjon de la Nation au centre, un donjon par coin (%d coins)" % [zz, used.size()])
	gs.set_sylvestre_board(before)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
