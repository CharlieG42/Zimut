extends SceneTree
## V106 — option de carte « Iso » : plateau isométrique à étages de la Sylve, décoré de sprites.
## Cases plus petites, 4 étages reliés par des rampes, 4 donjons de champ + donjon final, portail au sommet.
var fails: int = 0
func check(c: bool, m: String) -> void:
	if not c:
		fails += 1
		print("ÉCHEC : ", m)
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var gs: Node = root.get_node("GameSettings")
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	var old: String = gs.sylvestre_board
	gm.active_save = {"adventure_view": "map"}
	gs.set_sylvestre_board("iso")
	check(gs.sylvestre_board == "iso", "réglage iso accepté")
	check(SpriteDecor.active("Forêt"), "sprites actifs en Forêt")
	check(not SpriteDecor.active("Brasier"), "sprites inactifs ailleurs")
	var z: String = "foret_sylve"
	check(BoardArt.is_iso(z), "la Sylve utilise le plateau iso")
	check(BoardArt.iso_cs(z) < 0.8, "cases plus petites que 128 px")
	var sz: Vector2i = BoardArt.size(z)
	check(sz.x * sz.y > 54 * 36, "plus de cases qu'avant (%d)" % (sz.x * sz.y))
	# étages
	var hs: Dictionary = BoardArt.heights(z)
	check(BoardArt.iso_max_height(z) >= 12, "au moins 4 étages (hauteur max %d)" % BoardArt.iso_max_height(z))
	# les rampes : l'écart entre voisines franchissables ne dépasse jamais 1 ; les falaises (≥ 2) bloquent
	var cliffs: int = 0
	for c: Vector2i in hs.keys():
		if not BoardArt.walkable_cell(z, c):
			continue
		for d: Vector2i in [Vector2i(1, 0), Vector2i(0, 1)]:
			var n: Vector2i = c + d
			if hs.has(n) and BoardArt.walkable_cell(z, n):
				var dh: int = absi(int(hs[n]) - int(hs[c]))
				if dh >= 2:
					cliffs += 1
					check(not AdventureTerrain.can_step(z, c, n), "falaise infranchissable %s→%s" % [c, n])
				else:
					check(AdventureTerrain.can_step(z, c, n), "marche possible %s→%s" % [c, n])
	check(cliffs > 50, "des falaises séparent les étages (%d)" % cliffs)
	# lieux : 4 donjons de champ + donjon final de plus en plus hauts, portail
	var pois: Dictionary = pm.pois_of(z)
	var start: Vector2i = BoardArt.start(z)
	var level_of: Dictionary = {}
	for k: String in pois.keys():
		var p: Dictionary = pois[k]
		var pos: Vector2i = AdventureTerrain.parse(k)
		check(AdventureTerrain.walkable(z, pos), "lieu %s sur une case libre" % k)
		check(not AdventureTerrain.find_path(z, start, pos).is_empty() or pos == start, "lieu %s accessible depuis le départ (rampes)" % k)
		if String(p.get("guardian", "")) != "":
			level_of[String(p["guardian"])] = int(hs[pos])
	for g: String in ["Forêt#1", "Forêt#2", "Forêt#3", "Forêt#4", "Forêt"]:
		check(level_of.has(g), "donjon %s présent" % g)
	check(level_of["Forêt#1"] <= level_of["Forêt#2"] and level_of["Forêt#2"] <= level_of["Forêt#3"] and level_of["Forêt#3"] <= level_of["Forêt#4"] and level_of["Forêt#4"] < level_of["Forêt"], "les donjons montent d'étage en étage")
	check(level_of["Forêt"] >= 12, "le donjon final est au sommet")
	var portal: String = ""
	for k: String in pois.keys():
		if bool(pois[k].get("portal", false)):
			portal = k
	check(portal != "", "portail présent")
	if portal != "":
		check(String(pois[portal].get("to", "")) == "brasier_cendres", "le portail mène au Brasier")
		check(String(pois[portal].get("requires", "")) == "Forêt", "le portail s'ouvre avec le donjon final")
		check(int(hs[AdventureTerrain.parse(portal)]) >= 12, "portail au sommet")
	# mouvement : on ne monte pas une falaise pas à pas
	var mgr: Node = Node.new()
	mgr.set_script(load("res://scripts/AdventureManager.gd"))
	root.add_child(mgr)
	var data: Dictionary = pm.new_game(4, "IsoTest")
	data["campaign_mode"] = "adventure"
	data["adventure_view"] = "map"
	gm.active_save = data
	pm.adventure_enter_zone(pm.adventure_state(data), z)
	mgr.load_state(data, 4)
	check(mgr.hero_pos() == start, "arrivée au départ du plateau")
	# autres zones inchangées
	check(not BoardArt.is_iso("montagne_pics"), "Cimes : carte v2 inchangée")
	for k: String in SpriteDecor.SPRITES.keys():
		for e: Array in SpriteDecor.SPRITES[k]:
			check(SpriteDecor.texture(String(e[0])) != null, "sprite %s chargé" % e[0])
	var terrain: Dictionary = AdventureTerrain.zone_terrain(z)
	for kind: String in (terrain["obstacles"] as Dictionary).values() + (terrain["decor"] as Dictionary).values():
		check(SpriteDecor.SPRITES.has(kind), "décor %s a un sprite" % kind)
	gs.set_sylvestre_board("bidon")
	check(gs.sylvestre_board == "v2", "valeur inconnue → v2")
	gs.set_sylvestre_board("classic")
	check(not SpriteDecor.active("Forêt"), "classic : pas de sprites")
	check(not BoardArt.is_iso(z), "classic : plus de plateau iso")
	gs.set_sylvestre_board(old)
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(fails)
