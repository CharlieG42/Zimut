extends SceneTree
## V83-84 (TEST) : planche illustrée du mode 2D (Sylve) — masque, lieux (5 entrées de donjon), accessibilité,
## et aucune incidence sur les vues 3D.
## Lancement : xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/test_planche_2d.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var gm: Node = root.get_node("/root/GameManager")
	root.get_node("/root/GameSettings").sylvestre_board = "classic"   # ancienne planche = BACKUP (la nouvelle : test_planche_sylvestre_v2)
	var pm: Node = root.get_node("/root/ProgressionManager")
	var BA: GDScript = load("res://scripts/BoardArt.gd")
	var AT: GDScript = load("res://scripts/AdventureTerrain.gd")
	var D: GDScript = load("res://scripts/Dungeons.gd")
	var z := "foret_sylve"
	check(BA.has_board(z), "planche de la Sylve présente")
	check(ResourceLoader.exists(String(BA.raw(z)["image"])), "illustration présente")
	# Hors carte 2D : aucune incidence
	gm.active_save = {"adventure_view": "3d"}
	check(BA.def(z).is_empty() and AT.zone_terrain(z)["size"] == Vector2i(54, 36), "vue 3D : terrain d'origine (54 × 36)")
	gm.active_save = {"adventure_view": "open3d"}
	check(BA.def(z).is_empty(), "monde ouvert : pas de planche")
	# Carte 2D : planche active
	gm.active_save = {"adventure_view": "map"}
	var t: Dictionary = AT.zone_terrain(z)
	var sz: Vector2i = t["size"]
	check(sz == BA.size(z) and sz.x >= 90, "carte 2D : grille de la planche (%s)" % str(sz))
	check(AT.walkable(z, t["start"]), "départ jouable")
	check((t["paths"] as Dictionary).size() >= 900, "assez de cases jouables (%d)" % (t["paths"] as Dictionary).size())
	var pois: Dictionary = pm.pois_of(z)
	var dungeon_doors: Array[String] = ["19,9", "14,32", "76,10", "77,38", "50,21"]
	var doors_ok: bool = true
	for door: String in dungeon_doors:
		if not pois.has(door) or not D.is_dungeon(pois.get(door, {})):
			doors_ok = false
	check(doors_ok, "quatre entrées périphériques + Grand Arbre référencés comme donjons")
	check(pois.has("77,38") and not pois.has("76,39"), "entrée sud-est calée sur le seuil cristallin")
	check(pois.has("14,32") and not pois.has("16,32"), "entrée sud-ouest calée sur le seuil de la porte")
	check(pois.has("19,9") and not pois.has("19,10"), "entrée nord-ouest calée devant la porte")
	check(pois.has("76,10") and not pois.has("76,11"), "entrée nord-est calée sur le seuil violet")
	check(pois.has("50,21") and not pois.has("50,23"), "entrée centrale calée devant la porte du Grand Arbre")
	var tiers: Array = []
	var bad := 0
	for k: String in pois.keys():
		var p: Vector2i = AT.parse(k)
		if not AT.walkable(z, p) or (p != t["start"] and AT.find_path(z, t["start"], p).is_empty()):
			bad += 1
		var g: String = String(pois[k].get("guardian", ""))
		if g != "":
			tiers.append(D.tier(g))
	check(bad == 0, "tous les lieux sont accessibles depuis le départ")
	tiers.sort()
	check(tiers == [1, 2, 3, 4, 5], "5 entrées de donjon : paliers 1 à 4 + Grand Arbre (Gardien) → %s" % str(tiers))
	var lv: Array = []
	for k2: String in pois.keys():
		var g2: String = String(pois[k2].get("guardian", ""))
		if g2 != "":
			lv.append(int(pois[k2]["level"]))
	lv.sort()
	check(lv[0] < lv[4], "difficulté croissante entre entrées (niv %s)" % str(lv))
	# V84 : retouche du masque en mémoire
	var probe := Vector2i(-1, -1)
	for y: int in range(sz.y):
		for x: int in range(sz.x):
			if probe.x < 0 and not AT.walkable(z, Vector2i(x, y)):
				probe = Vector2i(x, y)
	BA.set_cell(z, probe, true)
	check(AT.walkable(z, probe), "retouche : case ouverte")
	check((BA.diff(z)["open"] as Array).has("%d,%d" % [probe.x, probe.y]), "retouche : diff signalée")
	BA.reset_edits(z)
	check(not AT.walkable(z, probe), "retouche : annulation")
	check(pm.adventure_gates(z).is_empty(), "pas de portes : voyage par la carte du monde")
	print("OK" if fails == 0 else "ÉCHEC")
	quit(fails)
