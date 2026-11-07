extends SceneTree
## V114 — Planche Sylve « v2 enrichie » : décors superposés lus dans la planche.
## Vérifie que les clés "decor" / "over" respectent les invariants de lisibilité
## (SYLVESTRE_VISUEL.md) et que la scène instancie bien les nœuds de décor.
## Lancement : godot --headless --path . -s tests/test_sylve_v2_decor.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1

func _cheb(a: Vector2i, b: Vector2i) -> int:
	return maxi(absi(a.x - b.x), absi(a.y - b.y))

func _init() -> void:
	_boot.call_deferred()

func _boot() -> void:
	var gm: Node = root.get_node("/root/GameManager")
	var gs: Node = root.get_node("/root/GameSettings")
	var pm: Node = root.get_node("/root/ProgressionManager")
	var BA: GDScript = load("res://scripts/BoardArt.gd")
	var AT: GDScript = load("res://scripts/AdventureTerrain.gd")
	var SD: GDScript = load("res://scripts/SpriteDecor.gd")
	var z := "foret_sylve"
	gm.active_save = {"adventure_view": "map"}
	gs.set_sylvestre_board("v2")
	check(BA.file_stem(z) == "foret_sylve_v2", "variante v2 active")
	var d: Dictionary = BA.raw(z)

	# Le masque, le départ et les lieux ne changent pas.
	check(d["mask"].size() == 73 and d["start"] == [54.0, 45.0] and d["pois"].size() == 19,
		"masque / départ / 19 lieux inchangés")

	var decor: Dictionary = d.get("decor", {})
	var over: Dictionary = d.get("over", {})
	check(decor.size() > 100 and over.size() > 30, "décors présents (%d sol, %d premier plan)" % [decor.size(), over.size()])

	var sprites: Dictionary = SD.SPRITES
	var start: Vector2i = AT.parse("%d,%d" % [int(d["start"][0]), int(d["start"][1])])
	var poi_cells: Array[Vector2i] = []
	for k: String in d["pois"].keys():
		poi_cells.append(AT.parse(k))

	var bad := 0
	for k: String in decor.keys():
		var p: Vector2i = AT.parse(k)
		if not AT.walkable(z, p):
			bad += 1
		if String(decor[k]) not in sprites:
			bad += 1
		for pc: Vector2i in poi_cells:
			if _cheb(p, pc) < 2:
				bad += 1
		if _cheb(p, start) <= 2:
			bad += 1
	check(bad == 0, "décors de sol : cases jouables, kinds valides, à distance des lieux et du départ")

	bad = 0
	for k: String in over.keys():
		var p: Vector2i = AT.parse(k)
		if AT.walkable(z, p):
			bad += 1
		elif not AT.walkable(z, p + Vector2i(0, -1)):
			bad += 1
		if String(over[k]) not in ["tree", "big_tree", "pine"]:
			bad += 1
		for pc: Vector2i in poi_cells:
			if _cheb(p, pc) < 3:
				bad += 1
		if _cheb(p, start) <= 2:
			bad += 1
	check(bad == 0, "premier plan : cases non jouables au sud d'un chemin, à distance des lieux")

	# Aucun décor ni arbre sur une surface PEINTE (bâtiment/toit) : case texturée
	# (écart-type des pixels >= 9.5), lu directement dans l'illustration.
	var img := Image.new()
	var lerr: int = img.load(String(d["image"]))
	check(lerr == OK, "illustration rechargeable en Image (%d)" % lerr)
	var flat_bad := 0
	for k: String in decor.keys() + over.keys():
		var p: Vector2i = AT.parse(k)
		var m := Vector3.ZERO
		var m2 := Vector3.ZERO
		for yy in range(16):
			for xx in range(16):
				var c: Color = img.get_pixel(p.x * 16 + xx, p.y * 16 + yy)
				var v := Vector3(c.r, c.g, c.b)
				m += v
				m2 += v * v
		m /= 256.0
		var var_ch: Vector3 = m2 / 256.0 - m * m
		var std_ch: float = (sqrt(maxf(0.0, var_ch.x)) + sqrt(maxf(0.0, var_ch.y)) + sqrt(maxf(0.0, var_ch.z))) / 3.0
		if std_ch * 255.0 < 9.5:   # composantes Color normalisées 0..1
			flat_bad += 1
	check(flat_bad == 0, "aucun décor/arbre sur surface peinte (std < 9.5/255) : %d" % flat_bad)

	# La scène instancie bien les nœuds de décor sprites.
	var data: Dictionary = pm.new_game(4, "TestDecorV114")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "adventure"
	var adv: Dictionary = pm.adventure_state(data)
	pm.adventure_unlock_zone(adv, z)
	pm.adventure_enter_zone(adv, z)
	gm.active_save = data
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/AdventureMap.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	for i in 8:
		await process_frame
	var entities: Node = sc.get("_entities")
	var n_sprites := 0
	var n_over := 0
	var z_ok := true
	for n: Node in entities.get_children():
		if n.get("use_sprites") == true:
			n_sprites += 1
			var pos := Vector2i(roundi(n.position.x / 32.0 - 0.5), roundi((n.position.y - 22.0) / 32.0))
			if over.has("%d,%d" % [pos.x, pos.y]):
				n_over += 1
				if n.z_index != pos.y * 4 + 4:
					z_ok = false
	check(n_sprites == decor.size() + over.size(), "nœuds de décor instanciés (%d attendus, %d trouvés)" % [decor.size() + over.size(), n_sprites])
	check(n_over == over.size(), "arbres de premier plan tous avec z au-dessus du héros (%d/%d, z ok=%s)" % [n_over, over.size(), str(z_ok)])
	check(sc.get("_hero") != null, "héros présent")

	# La variante iso reste fonctionnelle.
	gs.set_sylvestre_board("iso")
	check(BA.file_stem(z) == "foret_sylve_iso", "variante iso toujours disponible")
	gs.set_sylvestre_board("v2")
	check(BA.file_stem(z) == "foret_sylve_v2", "retour v2")
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
