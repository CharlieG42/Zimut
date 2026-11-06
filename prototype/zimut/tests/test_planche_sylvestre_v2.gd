extends SceneTree
## Planche Sylvestre v2 (île flottante + village) et BACKUP de l'ancienne planche.
## Lancement : godot --headless --path . -s tests/test_planche_sylvestre_v2.gd
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
	var pm: Node = root.get_node("/root/ProgressionManager")
	var BA: GDScript = load("res://scripts/BoardArt.gd")
	var AT: GDScript = load("res://scripts/AdventureTerrain.gd")
	var D: GDScript = load("res://scripts/Dungeons.gd")
	var z := "foret_sylve"
	gm.active_save = {"adventure_view": "map"}
	# ── Nouvelle planche (défaut) ──
	gs.sylvestre_board = "v2"
	check(BA.file_stem(z) == "foret_sylve_v2", "défaut : nouvelle planche")
	var d: Dictionary = BA.raw(z)
	check(ResourceLoader.exists(String(d["image"])) and load(String(d["image"])) != null, "illustration v2 chargeable")
	var isz: Array = d["image_size"]
	check(int(isz[0]) % 16 == 0 and int(isz[1]) % 16 == 0, "image divisible par la case (16 px)")
	check(BA.size(z) == Vector2i(int(isz[0]) / 16, int(isz[1]) / 16), "grille = image / 16 (%s)" % str(BA.size(z)))
	var mask: Array = d["mask"]
	var rows_ok: bool = mask.size() == BA.size(z).y
	for r: String in mask:
		if r.length() != BA.size(z).x:
			rows_ok = false
	check(rows_ok, "masque aux dimensions de la grille")
	check(AT.walkable(z, BA.start(z)), "départ jouable")
	var pois: Dictionary = pm.pois_of(z)
	check(pois.size() == 19, "19 lieux (%d)" % pois.size())
	var tiers: Array = []
	var bad: int = 0
	for k: String in pois.keys():
		var p: Vector2i = AT.parse(k)
		if not AT.walkable(z, p) or (p != BA.start(z) and AT.find_path(z, BA.start(z), p).is_empty()):
			bad += 1
		var g: String = String(pois[k].get("guardian", ""))
		if g != "":
			tiers.append(D.tier(g))
	check(bad == 0, "tous les lieux jouables et accessibles depuis le départ")
	tiers.sort()
	check(tiers == [1, 2, 3, 4, 5], "5 donjons : paliers 1 à 4 + Grand Arbre → %s" % str(tiers))
	check(BA.cell_world(z) == 32.0 and BA.world_size(z) == Vector2(float(isz[0]), float(isz[1])) * 2.0, "échelle monde conservée")
	# ── Retour à l'ancienne planche (BACKUP) ──
	gs.set_sylvestre_board("classic")
	check(BA.file_stem(z) == "foret_sylve" and BA.size(z) == Vector2i(96, 54), "ancienne planche toujours disponible (96×54)")
	check(pm.pois_of(z).has("50,21") and AT.walkable(z, AT.parse("50,21")), "ancienne planche : Grand Arbre à sa place")
	gs.set_sylvestre_board("v2")
	check(BA.file_stem(z) == "foret_sylve_v2", "bascule vers la nouvelle planche")
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
