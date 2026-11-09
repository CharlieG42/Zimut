extends SceneTree
## V115 — Carte 2D Sylve « Diorama » (scène 3D pré-rendue posée sur un plateau iso) + Options en onglets.
## Lancement : godot --headless --path . -s tests/test_sylve_diorama.gd
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
	var BA: GDScript = load("res://scripts/BoardArt.gd")
	var AT: GDScript = load("res://scripts/AdventureTerrain.gd")
	var z := "foret_sylve"
	var before: String = gs.sylvestre_board
	gm.active_save = {"adventure_view": "map"}

	# --- variantes : le diorama ne remplace que la Sylve, les autres restent intactes
	check(gs._board_variant("diorama") == "diorama" and gs._board_variant("xyz") == "v2", "réglage « diorama » reconnu")
	gs.set_sylvestre_board("v2")
	check(BA.file_stem(z) == "foret_sylve_v2" and not BA.is_diorama(z), "variante v2 inchangée")
	gs.set_sylvestre_board("diorama")
	check(BA.file_stem(z) == "foret_sylve_diorama" and BA.is_diorama(z) and BA.is_iso(z), "Sylve : planche diorama (plateau iso)")
	check(BA.file_stem("montagne_pics") == "montagne_pics_v2", "les Cimes gardent leur planche v2")

	# --- données de la planche
	var d: Dictionary = BA.raw(z)
	var sz: Vector2i = BA.size(z)
	check(sz == Vector2i(144, 144) and (d["mask"] as Array).size() == 144 and (d["heights"] as Array).size() == 144, "monde 144x144 cases (masque + hauteurs)")
	check((d["pois"] as Dictionary).size() == 20, "20 lieux (%d)" % (d["pois"] as Dictionary).size())
	var tiles: Array = BA.diorama_tiles(z)
	var tiles_ok: bool = tiles.size() == 16
	for t: Dictionary in tiles:
		tiles_ok = tiles_ok and load(String(t["path"])) is Texture2D
	check(tiles_ok, "16 tuiles de fond (%d), toutes chargeables" % tiles.size())
	var occ: Array = BA.diorama_occluders(z)
	check(occ.size() >= 300, "occultants découpés (%d)" % occ.size())
	var occ_ok := true
	var occ_pages := {}
	for o: Dictionary in occ:
		var r: Rect2 = o["rect"]
		if not occ_pages.has(o["path"]):
			occ_pages[o["path"]] = load(String(o["path"])) as Texture2D
		var tex: Texture2D = occ_pages[o["path"]]
		if tex == null or r.end.x > tex.get_width() + 0.5 or r.end.y > tex.get_height() + 0.5:
			occ_ok = false
	check(occ_ok, "occultants dans leur page d'atlas")

	# --- calage : la case (0,0) et la case (71,71) tombent dans l'image ; l'image couvre le plateau
	var sc: float = BA.diorama_scale(z)
	var img_rect := Rect2((tiles[0] as Dictionary)["pos"], Vector2(10240, 5760) * sc)
	var inside := true
	for c: Vector2i in [Vector2i(0, 0), Vector2i(143, 0), Vector2i(0, 143), Vector2i(143, 143), Vector2i(72, 72)]:
		inside = inside and img_rect.has_point(BA.iso_pos(z, c))
	check(inside, "coins du plateau dans le rendu")
	var ws: Vector2 = BA.world_size(z)
	check(img_rect.position.x <= 0.5 and img_rect.end.x >= ws.x - 0.5 and img_rect.end.y >= ws.y - 0.5, "le rendu couvre tout le monde 2D (%s / %s)" % [img_rect, ws])

	# --- jouabilité : départ et lieux jouables, tous atteignables
	var st: Vector2i = BA.start(z)
	check(AT.walkable(z, st), "départ jouable %s" % st)
	check(not AT.walkable(z, Vector2i(3, 6)), "départ du catalogue (3,6) fermé : une partie neuve est replacée au départ du diorama")
	var seen := {st: true}
	var q: Array[Vector2i] = [st]
	while not q.is_empty():
		var p: Vector2i = q.pop_back()
		for dd: Vector2i in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
			var n: Vector2i = p + dd
			if not seen.has(n) and BA.walkable_cell(z, n):
				seen[n] = true
				q.append(n)
	var unreached: Array = []
	for k: String in (d["pois"] as Dictionary).keys():
		if not seen.has(AT.parse(k)):
			unreached.append(k)
	check(unreached.is_empty(), "tous les lieux atteignables depuis le départ %s" % [unreached])
	check(seen.size() > 11000, "monde vaste : grande surface jouable (%d cases)" % seen.size())

	# --- entrée dans la zone : le héros part du départ de la planche (pas du coin du Portail)
	var pm: Node = root.get_node("/root/ProgressionManager")
	var data: Dictionary = {"adventure_view": "map"}
	gm.active_save = data
	var adv: Dictionary = pm.adventure_state(data)
	pm.adventure_unlock_zone(adv, z)
	pm.adventure_enter_zone(adv, z)
	check(Vector2i(int(adv["hero_pos"][0]), int(adv["hero_pos"][1])) == st, "entrée dans la Sylve : héros au départ du diorama")

	# --- V117 : fluidité
	var vram := true
	for path: String in ["res://assets/boards/sylve_diorama/sol_0_0.webp.import", "res://assets/boards/sylve_diorama/occ_1_1.webp.import", "res://assets/boards/sylve_diorama/fond_bas.webp.import"]:
		var txt: String = FileAccess.get_file_as_string(path)
		vram = vram and txt.contains("compress/mode=2") and txt.contains("mipmaps/generate=true")
	check(vram, "textures du diorama compressées pour le GPU (ETC2 / S3TC) avec mipmaps")
	check(not BA.diorama_low(z).is_empty() and load(String(BA.diorama_low(z)["path"])) is Texture2D, "fond basse définition sous les tuiles")
	gm.active_save = {"adventure_view": "map"}
	var data2: Dictionary = gm.active_save
	var adv2: Dictionary = pm.adventure_state(data2)
	adv2["hero_pos"] = [100, 90]
	pm.adventure_state(data2)
	check(Vector2i(int(adv2["hero_pos"][0]), int(adv2["hero_pos"][1])) == Vector2i(100, 90), "héros loin du départ (100,90) : position gardée au rechargement")
	var n0: int = (adv2.get("discovered", []) as Array).size()
	pm.adventure_move(adv2, Vector2i(101, 90))
	check((adv2.get("discovered", []) as Array).size() == n0, "pas de brouillard tenu à jour sur une planche (liste des découvertes stable)")
	var tz: Dictionary = AT.zone_terrain(z)
	check((tz.get("heights", {}) as Dictionary).is_empty(), "diorama : pas de fausses falaises (pentes quantifiées)")
	var same := true
	var walls: Dictionary = AT._merge(tz["obstacles"], tz["voids"])
	for pair: Array in [[st, Vector2i(30, 128)], [st, Vector2i(120, 30)], [Vector2i(40, 40), Vector2i(110, 120)]]:
		var a0: Vector2i = pair[0]
		var b0: Vector2i = pair[1]
		while not BA.walkable_cell(z, b0):
			b0 += Vector2i(1, 0)
		while not BA.walkable_cell(z, a0):
			a0 += Vector2i(1, 0)
		var p1: Array = AT.find_path(z, a0, b0)
		var p2: Array = AT._bfs_path(tz["size"], walls, a0, b0, {})
		same = same and p1.size() == p2.size() and p1.size() > 0 and p1.back() == b0
	check(same, "chemins natifs (AStar) aussi courts que le parcours en largeur")

	# --- Options en onglets
	var opt: Node = (load("res://scenes/Settings.tscn") as PackedScene).instantiate()
	root.add_child(opt)
	await create_timer(0.3).timeout
	var tabs: Node = opt.find_child("Tabs", true, false)
	var pages: Node = opt.find_child("Pages", true, false)
	check(tabs != null and tabs.get_child_count() == 4 and pages.get_child_count() == 4, "Options : 4 onglets / 4 pages")
	var one_visible := true
	for i in range(4):
		(tabs.get_child(i) as Button).pressed.emit()
		var vis := 0
		for p: Node in pages.get_children():
			vis += 1 if (p as Control).visible else 0
		one_visible = one_visible and vis == 1 and (pages.get_child(i) as Control).visible
	check(one_visible, "un seul onglet affiché à la fois")
	check(opt.find_child("CloudBackup", true, false) != null and opt.find_child("TutoRestart", true, false) != null, "boutons Cloud et Tutoriel présents")
	opt.queue_free()

	gs.set_sylvestre_board(before)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
