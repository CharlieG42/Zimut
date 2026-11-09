extends SceneTree
## V118 — Carte « Diorama » du Brasier (Terres de Cendre) + bâtiments de donjon (Sylve et Brasier).
## Lancement : godot --headless --path . -s tests/test_brasier_diorama.gd
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
	var z := "brasier_cendres"
	gs.set_sylvestre_board("v2")
	check(not BA.is_diorama(z), "hors réglage Diorama : le Brasier garde sa carte générée")
	gs.set_sylvestre_board("diorama")
	check(BA.file_stem(z) == "brasier_cendres_diorama" and BA.is_diorama(z), "réglage Diorama : planche du Brasier")
	check(BA.file_stem("brumes_marais") == "brumes_marais", "les Nations suivantes gardent leur carte")
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
	for f: String in DirAccess.get_files_at("res://assets/boards/brasier_diorama/"):
		if f.ends_with(".import"):
			var txt: String = FileAccess.get_file_as_string("res://assets/boards/brasier_diorama/" + f)
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
		if String(p.get("kind", "")) == "exit" and bool(p.get("portal", false)) and String(p.get("requires", "")) == "Brasier":
			portal = true
	guardians.sort()
	check(guardians == ["Brasier", "Brasier#1", "Brasier#2", "Brasier#3", "Brasier#4"], "5 donjons du Brasier %s" % [guardians])
	check(portal, "portail vers les Brumes scellé par le Gardien du Brasier")
	check(pois.size() >= 20, "%d lieux" % pois.size())
	var st: Vector2i = BA.start(z)
	var seen: Dictionary = _reach(BA, z, st)
	var miss: Array = []
	for k: String in pois.keys():
		if not seen.has(AT.parse(k)):
			miss.append(String(pois[k]["name"]))
	check(miss.is_empty(), "tous les lieux atteignables %s" % [miss])
	check(seen.size() > 9000, "grande surface jouable (%d cases)" % seen.size())
	check(not AT.walkable(z, Vector2i(3, 6)), "départ du catalogue fermé : départ de la planche")
	# lave et volcan infranchissables
	var hs: Dictionary = BA.heights(z)
	var top := Vector2i.ZERO
	for c: Vector2i in hs.keys():
		if int(hs[c]) > int(hs.get(top, 0)):
			top = c
	check(not BA.walkable_cell(z, top), "sommet du volcan infranchissable %s" % top)
	# entrée dans la zone
	var data: Dictionary = {"adventure_view": "map"}
	gm.active_save = data
	var adv: Dictionary = pm.adventure_state(data)
	adv["zones_unlocked"] = ["foret_sylve", "brasier_cendres"]
	pm.adventure_enter_zone(adv, z)
	check(Vector2i(int(adv["hero_pos"][0]), int(adv["hero_pos"][1])) == st, "entrée : héros au départ du bourg")
	# V118 : règles de voyage — N-1 toujours accessible, N+1 seulement après le Gardien de N
	var back_key := ""
	var portal_key := ""
	for k: String in pois.keys():
		if String(pois[k].get("kind", "")) == "exit":
			if bool(pois[k].get("back", false)) and String(pois[k].get("to", "")) == "foret_sylve":
				back_key = k
			elif bool(pois[k].get("portal", false)):
				portal_key = k
	check(back_key != "" and seen.has(AT.parse(back_key)), "sentier de retour vers la Sylve, atteignable")
	var mgr: Node = load("res://scripts/AdventureManager.gd").new()
	root.add_child(mgr)
	mgr.load_state(data, -1)
	mgr.state = adv
	check(not mgr.portal_lock(pois[portal_key]).is_empty(), "portail vers les Brumes scellé tant que le Gardien règne")
	check(mgr.portal_lock(pois[back_key]).is_empty(), "le sentier de retour n'est jamais scellé")
	var revealed: Array = pm.adventure_complete_poi(adv, "%s,%s" % [z, back_key], "exit")
	check(revealed.is_empty() and not (adv["zones_unlocked"] as Array).has("brumes_marais"), "prendre le sentier de retour ne débloque pas les Brumes")
	check((adv["zones_unlocked"] as Array).has("foret_sylve"), "la Sylve reste accessible")
	pm.adventure_complete_poi(adv, "%s,%s" % [z, portal_key], "exit")
	check((adv["zones_unlocked"] as Array).has("brumes_marais"), "le portail (une fois ouvert) débloque bien les Brumes")
	mgr.queue_free()
	# Sylve : les 5 donjons ont maintenant un bâtiment (un occultant « dungeon » près de chaque lieu de donjon)
	var occ_s: Array = BA.diorama_occluders("foret_sylve")
	var occ_b: Array = occ
	for pair: Array in [["foret_sylve", occ_s], [z, occ_b]]:
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
	gs.set_sylvestre_board(before)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
