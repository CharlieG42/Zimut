extends SceneTree
## Carte des Cimes (V103) + déblocage séquentiel des 5 donjons d'une Nation.
## Lancement : godot --headless --path . -s tests/test_cimes_donjons.gd
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
	var z := "montagne_pics"
	gm.active_save = {"adventure_view": "map"}
	gs.sylvestre_board = "v2"
	print("Carte :")
	check(BA.file_stem(z) == "montagne_pics_v2" and BA.has_board(z), "planche des Cimes active")
	var d: Dictionary = BA.raw(z)
	check(load(String(d["image"])) != null, "illustration chargeable")
	var isz: Array = d["image_size"]
	check(int(isz[0]) % 16 == 0 and int(isz[1]) % 16 == 0 and BA.size(z) == Vector2i(int(isz[0]) / 16, int(isz[1]) / 16), "grille = image / 16")
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
			check(D.base(g) == "Montagne", "donjon %s : Nation Montagne" % k)
		if String(pois[k].get("kind", "")) == "puzzle":
			check(pm.ADVENTURE_PUZZLES.has("%s,%s" % [z, k]), "énigme %s définie" % k)
	check(bad == 0, "tous les lieux jouables et accessibles depuis le départ")
	tiers.sort()
	check(tiers == [1, 2, 3, 4, 5], "5 donjons : paliers 1 à 4 + château → %s" % str(tiers))
	gs.set_sylvestre_board("classic")
	check(BA.file_stem(z) == "montagne_pics" and not BA.has_board(z), "mode « Ancienne » : décor généré par code")
	gs.set_sylvestre_board("v2")
	print("Niveaux :")
	for nation: String in Nations.LEVEL_BANDS.keys():
		if nation == "Donjon":
			continue
		var tops: Array = []
		for t: int in range(1, 6):
			tops.append(D.room_level(D.tier_key(nation, t), 4))
		var inc: bool = true
		for i: int in range(1, 5):
			if tops[i] < tops[i - 1]:
				inc = false
		check(inc, "%s : niveaux croissants %s" % [nation, str(tops)])
		var gap: int = D.room_level(nation, 1) - tops[3]
		var band: Vector2i = Nations.level_band(nation)
		if band.y - band.x >= 12:
			check(gap >= 3, "%s : le final démarre %d niveaux au-dessus du palier 4" % [nation, gap])
		else:
			check(gap >= 1 and tops[4] > tops[3], "%s (tranche étroite) : final au-dessus du palier 4 (+%d)" % [nation, gap])
	check(D.room_level("Montagne", 4) == 45 and D.room_level("Montagne", 1) - D.room_level("Montagne#4", 4) >= 3, "Cimes : final niveau 42-45, palier 4 jusqu'à 39")
	print("Déblocage séquentiel :")
	var adv: Dictionary = {}
	check(D.locked_by(adv, pois, "Montagne#1").is_empty(), "palier 1 toujours ouvert")
	for t: int in range(2, 6):
		var lock: Dictionary = D.locked_by(adv, pois, D.tier_key("Montagne", t))
		check(String(lock.get("guardian", "")) == D.tier_key("Montagne", t - 1), "palier %d verrouillé par le palier %d" % [t, t - 1])
	for t: int in range(1, 5):
		var key: String = D.tier_key("Montagne", t)
		adv["dungeons"] = adv.get("dungeons", {})
		adv["dungeons"][key] = {"clears": 1, "boss_kills": 1}
		check(D.locked_by(adv, pois, D.tier_key("Montagne", t + 1)).is_empty(), "palier %d terminé → palier %d ouvert" % [t, t + 1])
		if t < 4:
			check(not D.locked_by(adv, pois, D.tier_key("Montagne", t + 2)).is_empty(), "…mais le palier %d reste fermé" % (t + 2))
	# donjon déjà terminé : jamais re-verrouillé (anciennes sauvegardes)
	var old: Dictionary = {"dungeons": {"Montagne": {"clears": 1, "boss_kills": 1}}}
	check(D.locked_by(old, pois, "Montagne").is_empty(), "final déjà vaincu : reste ouvert")
	# zone à paliers 2/4/5 (cartes générées) : on s'appuie sur le palier existant juste en dessous
	var gen: Dictionary = pm.ADVENTURE_POIS["foret_sylve"].duplicate(true)
	gen["1,1"] = {"kind": "combat", "guardian": "Forêt#2", "name": "A"}
	gen["2,2"] = {"kind": "combat", "guardian": "Forêt#4", "name": "B"}
	check(D.locked_by({}, gen, "Forêt#2").is_empty(), "carte à 3 donjons : palier 2 = le plus bas, ouvert")
	check(String(D.locked_by({}, gen, "Forêt#4").get("guardian", "")) == "Forêt#2", "palier 4 attend le palier 2")
	check(String(D.locked_by({}, gen, "Forêt").get("guardian", "")) == "Forêt#4", "Gardien attend le palier 4")
	check(D.locked_by({"dungeons": {"Forêt#4": {"clears": 1}}}, gen, "Forêt").is_empty(), "palier 4 terminé : Gardien ouvert")
	# côté gestionnaire d'aventure
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
