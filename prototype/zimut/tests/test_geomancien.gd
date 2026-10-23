extends SceneTree
## Tests du Géomancien : données (stats, sorts, icônes), piliers/murailles/failles
## qui modifient la grille, durée de vie, limites, ligne de vue.
## Lancement : godot --headless --path . -s tests/test_geomancien.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _spell(g: Node, caster: Dictionary, nm: String) -> Dictionary:
	for s: Dictionary in caster["spells"]:
		if String(s["name"]) == nm:
			return s
	return {}
func _boot() -> void:
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	await process_frame
	check(pm.CLASS_ORDER.has("Géomancien"), "classe présente dans CLASS_ORDER")
	check(FileAccess.file_exists("res://assets/sprites/players/geomancien.png"), "sprite du héros installé")
	check(EntityView.sprite_key("Géomancien") == "geomancien", "clé de sprite sans accent")
	var icons: String = FileAccess.get_file_as_string("res://data/spell_icons.txt")
	for nm: String in ["Éclat de grès", "Invoquer Pilier", "Invoquer Muraille", "Invoquer Faille", "Invoquer Cristal ambré", "Cataclysme minéral"]:
		check(icons.contains(nm + ","), "icône déclarée : " + nm)
	# Combat
	gm.set_custom_team([{"classe": "Géomancien"}, {"classe": "Tank"}, {"classe": "Mage"}])
	gm.init_grid()
	gm.init_entities()
	var geo: Dictionary = {}
	for p: Dictionary in gm.players:
		if String(p["classe"]) == "Géomancien":
			geo = p
	check(not geo.is_empty(), "le Géomancien est présent dans l'équipe")
	geo["spells"] = gm._build_spells("Géomancien", 100)
	check(geo["spells"].size() == 30, "30 sorts au niveau 100 (%d)" % geo["spells"].size())
	geo["current_pa"] = 20
	geo["max_pv"] = 400
	var gp: Vector2i = gm.pos_of(geo)
	var target: Vector2i = Vector2i(-1, -1)
	for y0: int in range(0, 12):
		for x0: int in range(0, 12):
			var c0: Vector2i = Vector2i(x0, y0)
			var dist: int = Combat.manhattan(gp, c0)
			if target.x < 0 and dist >= 2 and dist <= 4 and gm.is_free(c0) and gm.is_free(c0 + Vector2i(0, 1)) and gm.is_free(c0 + Vector2i(0, -1)) and gm.is_free(c0 + Vector2i(1, 0)) and gm.is_free(c0 + Vector2i(-1, 0)):
				target = c0
	check(target.x >= 0, "case libre trouvée pour poser du terrain")
	var before_sum: int = gm.summons_of(geo).size()
	var reason: String = gm.validate_cast(geo, _spell(gm, geo, "Invoquer Pilier"), target)
	check(reason == "", "Invoquer Pilier valide sur la case visée (%s)" % reason)
	check(gm.cast_spell(geo, _spell(gm, geo, "Invoquer Pilier"), target), "Invoquer Pilier lancé")
	check(not gm.is_free(target), "la case du pilier n'est plus libre")
	check(gm.terrain_of(geo).size() == 1, "1 case de terrain posée")
	check(gm.summons_of(geo).size() == before_sum, "le pilier ne compte pas comme familier")
	var pil: Dictionary = gm.entity_at(target)
	if pil.is_empty():
		check(false, "le pilier est posé sur la case visée")
		quit(1)
		return
	check(bool(pil.get("blocks_los", false)) and bool(pil.get("static", false)), "le pilier est statique et bloque la vue")
	check(int(pil["lifetime"]) == 4, "le pilier dure 4 tours")
	check(gm.cast_spell(geo, _spell(gm, geo, "Invoquer Muraille"), target + Vector2i(0, 0)) == false, "case occupée : impossible d'y poser une muraille")
	# Muraille : 3 cases
	var t2: Vector2i = Vector2i(-1, -1)
	var expected: int = 0
	for y: int in range(0, 12):
		for x: int in range(0, 12):
			var c: Vector2i = Vector2i(x, y)
			var dd: int = Combat.manhattan(gp, c)
			if t2.x < 0 and dd >= 2 and dd <= 4 and gm.is_free(c):
				var d: Vector2i = c - gp
				var perp: Vector2i = Vector2i(0, 1) if absi(d.x) >= absi(d.y) else Vector2i(1, 0)
				var cand: int = 1 + (1 if gm.is_free(c + perp) else 0) + (1 if gm.is_free(c - perp) else 0)
				if cand == 3 or (cand >= 2 and y == 11 and x == 11):
					t2 = c
					expected = cand
	if t2.x < 0:
		for y3: int in range(0, 12):
			for x3: int in range(0, 12):
				var c3: Vector2i = Vector2i(x3, y3)
				var d3: int = Combat.manhattan(gp, c3)
				if t2.x < 0 and d3 >= 2 and d3 <= 4 and gm.is_free(c3):
					var dv: Vector2i = c3 - gp
					var pp: Vector2i = Vector2i(0, 1) if absi(dv.x) >= absi(dv.y) else Vector2i(1, 0)
					t2 = c3
					expected = 1 + (1 if gm.is_free(c3 + pp) else 0) + (1 if gm.is_free(c3 - pp) else 0)
	var n0: int = gm.terrain_of(geo).size()
	var r2: String = gm.validate_cast(geo, _spell(gm, geo, "Invoquer Muraille"), t2)
	check(t2.x >= 0 and r2 == "", "Invoquer Muraille valide sur %s (%s) PA=%d" % [str(t2), r2, int(geo["current_pa"])])
	check(gm.cast_spell(geo, _spell(gm, geo, "Invoquer Muraille"), t2), "Invoquer Muraille lancée")
	check(gm.terrain_of(geo).size() == n0 + expected and expected >= 1, "la muraille pose %d case(s) (attendu %d)" % [gm.terrain_of(geo).size() - n0, expected])
	var uids: Dictionary = {}
	for tp: Dictionary in gm.terrain_of(geo):
		uids[tp["uid"]] = true
	check(uids.size() == gm.terrain_of(geo).size(), "chaque case de terrain a un identifiant unique")
	# Faille : bloque le passage mais pas la vue
	var finfo: Dictionary = Combat.SUMMONS["Faille"]
	check(not bool(finfo.get("blocks_los", false)) and bool(finfo["static"]), "la faille est infranchissable mais laisse voir")
	var cinfo: Dictionary = Combat.SUMMONS["Cristal ambré"]
	check(not bool(cinfo.get("blocks_los", false)) and int(cinfo["defense"]) >= 40, "le cristal ambré est robuste et transparent")
	# Durée de vie : le terrain s'effrite au fil des tours du Géomancien
	gm.active_entity = geo
	for i: int in range(4):
		gm.active_entity = geo
		gm.end_current_turn()
	await process_frame
	check(gm.terrain_of(geo).size() == 0 or gm.terrain_of(geo).all(func(e: Dictionary) -> bool: return int(e["lifetime"]) > 0), "le pilier de 4 tours a disparu ou expire")
	check(not gm.is_alive(pil), "le pilier est détruit après 4 tours")
	# Sorts : cibles de buff, zone
	var tp2: Dictionary = Combat.parse(_spell(gm, geo, "Glyphe de grès"))
	check(String(tp2["kind"]) == "glyph" and (tp2["glyph_allies"] as Dictionary)["buffs"].size() > 0, "Glyphe de grès : glyphe de défense pour les alliés")
	var ts: Dictionary = Combat.parse(_spell(gm, geo, "Tempête de sable"))
	check(String(ts["aoe"]) == "zone", "Tempête de sable : zone 3x3")
	check(int(Combat.parse(_spell(gm, geo, "Séisme ambré"))["push"]) == 1, "Séisme ambré repousse d'une case")
	print("\n%s — %d échec(s)" % ["OK" if fails == 0 else "KO", fails])
	quit(1 if fails > 0 else 0)
