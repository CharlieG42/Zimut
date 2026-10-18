extends SceneTree
## Tests des glyphes (V19) : Géomancien, Assassin, Chasseur.
## Lancement : godot --headless --path . -s tests/test_glyphs.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _spell(caster: Dictionary, nm: String) -> Dictionary:
	for s: Dictionary in caster["spells"]:
		if String(s["name"]) == nm:
			return s
	return {}
func _boot() -> void:
	var gm: Node = root.get_node("GameManager")
	await process_frame
	# ── Données : 6 glyphes, aucun ancien nom ──
	var sorts: String = FileAccess.get_file_as_string("res://data/sorts.txt")
	for nm: String in ["Glyphe de grès", "Glyphe sismique", "Glyphe de venin", "Glyphe d'ombre", "Glyphe d'entrave", "Glyphe de flammes"]:
		check(sorts.contains("," + nm + ","), "sort déclaré : " + nm)
		check(FileAccess.file_exists("res://assets/icons/spells/%s.svg" % SpellIcons.icon_id(nm)), "icône présente : " + nm)
	# ── Analyse ──
	gm.set_custom_team([{"classe": "Géomancien"}, {"classe": "Chasseur"}, {"classe": "Assassin"}])
	gm.init_grid()
	gm.init_entities()
	var geo: Dictionary = {}
	var cha: Dictionary = {}
	var ass: Dictionary = {}
	for p: Dictionary in gm.players:
		match String(p["classe"]):
			"Géomancien": geo = p
			"Chasseur": cha = p
			"Assassin": ass = p
	for h: Dictionary in [geo, cha, ass]:
		h["spells"] = gm._build_spells(String(h["classe"]), 100)
		h["current_pa"] = 30
		h["max_pv"] = 600
		h["current_pv"] = 600
	var sis: Dictionary = Combat.parse(_spell(geo, "Glyphe sismique"))
	check(String(sis["kind"]) == "glyph" and int(sis["zone_r"]) == 3 and String(sis["zone_shape"]) == "square_side", "Glyphe sismique : zone 3x3")
	check(int(sis["glyph_turns"]) == 3, "Glyphe sismique : 3 tours")
	check(int((sis["glyph_foes"] as Dictionary)["dmg"]) == 30 and (sis["glyph_foes"]["debuffs"] as Array).size() == 1, "Glyphe sismique : dégâts + ralentissement sur les ennemis")
	check((sis["glyph_allies"] as Dictionary).is_empty(), "Glyphe sismique : sans effet sur les alliés")
	var ent: Dictionary = Combat.parse(_spell(cha, "Glyphe d'entrave"))
	check(String(ent["zone_shape"]) == "diamond" and int(ent["zone_r"]) == 1, "Glyphe d'entrave : croix")
	var ven: Dictionary = Combat.parse(_spell(ass, "Glyphe de venin"))
	check((ven["glyph_foes"]["dots"] as Array).size() == 1 and String(ven["glyph_foes"]["dots"][0]["id"]) == "poison", "Glyphe de venin : poison")
	var omb: Dictionary = Combat.parse(_spell(ass, "Glyphe d'ombre"))
	check(String(omb["glyph_allies"]["buffs"][0]["id"]) == "invisible", "Glyphe d'ombre : alliés invisibles")
	var fla: Dictionary = Combat.parse(_spell(cha, "Glyphe de flammes"))
	check(int(fla["glyph_foes"]["dmg"]) == 25 and String(fla["glyph_foes"]["dots"][0]["id"]) == "burn", "Glyphe de flammes : dégâts + brûlure")
	# ── Combat : glyphe sismique sur un ennemi ──
	var foe: Dictionary = {}
	for e: Dictionary in gm.enemies:
		if gm.is_alive(e):
			foe = e
			break
	var fpos: Vector2i = gm.pos_of(foe)
	# place le Géomancien à portée (case libre à 3-4 cases de l'ennemi)
	var spot: Vector2i = Vector2i(-1, -1)
	for y: int in range(8):
		for x: int in range(8):
			var c: Vector2i = Vector2i(x, y)
			if spot.x < 0 and gm.is_free(c) and Combat.manhattan(c, fpos) >= 3 and Combat.manhattan(c, fpos) <= 4:
				spot = c
	var old_pos: Vector2i = gm.pos_of(geo)
	gm.grid[old_pos.y][old_pos.x] = null
	geo["x"] = spot.x
	geo["y"] = spot.y
	gm.grid[spot.y][spot.x] = geo
	var pv0: int = int(foe["current_pv"])
	var spell: Dictionary = _spell(geo, "Glyphe sismique")
	gm.active_entity = geo
	var reason: String = gm.validate_cast(geo, spell, fpos)
	check(reason == "", "Glyphe sismique : cible valide (%s)" % reason)
	check(gm.cast_spell(geo, spell, fpos), "Glyphe sismique lancé")
	check(gm.glyphs.size() == 1, "un glyphe est actif")
	check(int(foe["current_pv"]) < pv0, "effet immédiat : l'ennemi dans la zone perd des PV")
	check(Combat.has_status(foe, "slow"), "l'ennemi est ralenti")
	var pv1: int = int(foe["current_pv"])
	# même tour de jeu : pas de double déclenchement
	gm._glyph_tick(foe)
	check(int(foe["current_pv"]) == pv1, "un seul déclenchement par créature et par tour")
	gm.turn_count += 1
	gm._glyph_tick(foe)
	check(int(foe["current_pv"]) < pv1, "nouveau tour : le glyphe agit à nouveau")
	# Durée : 3 tours du lanceur
	for i: int in range(3):
		gm.active_entity = geo
		gm.end_current_turn()
	await process_frame
	check(gm.glyphs.size() == 0, "le glyphe expire après 3 tours du lanceur")
	# ── Limite de 2 glyphes par lanceur ──
	geo["current_pa"] = 30
	gm.active_entity = geo
	var g1: Dictionary = _spell(geo, "Glyphe de grès")
	for k: int in range(3):
		geo["casts"] = {}
		gm.cast_spell(geo, g1, gm.pos_of(geo))
	check(gm.glyphs_of(geo).size() == 2, "2 glyphes maximum par lanceur (%d)" % gm.glyphs_of(geo).size())
	# Glyphe de grès : l'allié dans la zone gagne de la défense
	check(Combat.has_status(geo, "def_up"), "Glyphe de grès : bonus de défense pour le lanceur dans la zone")
	# Mort du lanceur : le glyphe disparaît
	geo["current_pv"] = 0
	gm.active_entity = foe
	gm._glyphs_expire(foe)
	check(gm.glyphs_of(geo).size() == 0, "lanceur mort : ses glyphes s'effacent")
	print("\n%s — %d échec(s)" % ["OK" if fails == 0 else "KO", fails])
	quit(1 if fails > 0 else 0)
