extends SceneTree
## Cartes illustrées des Nations (Sylve, Brasier, Brumes, Cimes) : 5 donjons + un portail chacune (V105).
## Lancement : godot --headless --path . -s tests/test_cartes_nations.gd
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
	gm.active_save = {"adventure_view": "map"}
	gs.sylvestre_board = "v2"
	var nations := {"foret_sylve": "Forêt", "brasier_cendres": "Brasier", "brumes_marais": "Brumes", "montagne_pics": "Montagne"}
	for z: String in nations.keys():
		var nation: String = nations[z]
		print(z + " :")
		check(BA.has_board(z), "planche illustrée active")
		var d: Dictionary = BA.raw(z)
		check(load(String(d["image"])) != null, "illustration chargeable")
		var isz: Array = d["image_size"]
		check(BA.size(z) == Vector2i(int(isz[0]) / 16, int(isz[1]) / 16) and int(isz[0]) % 16 == 0 and int(isz[1]) % 16 == 0, "grille = image / 16")
		check(AT.walkable(z, BA.start(z)), "départ jouable")
		var pois: Dictionary = pm.pois_of(z)
		var tiers: Array = []
		var portals: Array = []
		var bad: int = 0
		for k: String in pois.keys():
			var p: Vector2i = AT.parse(k)
			if not AT.walkable(z, p) or (p != BA.start(z) and AT.find_path(z, BA.start(z), p).is_empty()):
				bad += 1
				print("     inaccessible : ", k, " ", pois[k].get("name", ""))
			var g: String = String(pois[k].get("guardian", ""))
			if g != "":
				tiers.append(D.tier(g))
				check(D.base(g) == nation, "donjon %s de la Nation %s" % [k, nation])
			if bool(pois[k].get("portal", false)):
				portals.append(pois[k])
			if String(pois[k].get("kind", "")) == "puzzle":
				check(pm.ADVENTURE_PUZZLES.has("%s,%s" % [z, k]), "énigme %s définie" % k)
		check(bad == 0, "tous les lieux jouables et accessibles")
		tiers.sort()
		check(tiers == [1, 2, 3, 4, 5], "5 donjons : paliers 1 à 4 + final → %s" % str(tiers))
		check(portals.size() == 1, "un portail")
		if portals.size() == 1:
			var po: Dictionary = portals[0]
			check(String(po["requires"]) == nation, "le portail exige le donjon final de la Nation")
			check(pm.ADVENTURE_ZONES.has(String(po["to"])) and String(pm.ADVENTURE_ZONES[String(po["to"])]["unlock"]) == z, "destination = la Nation suivante (%s)" % String(po["to"]))
		gs.set_sylvestre_board("classic")
		check(not BA.has_board(z) or z == "foret_sylve", "mode « Ancienne » : retour à l'ancien décor")
		gs.set_sylvestre_board("v2")
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
