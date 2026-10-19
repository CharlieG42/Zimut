extends SceneTree
## Artificier (V26) : kit, mécanismes (bombe, mine, tourelle, glyphe), Déclencheur,
## balise de transposition (inversion, 1 déplacement par tour), Arsenal total, Nation Rouages.
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _sp(c: Dictionary, nm: String) -> Dictionary:
	for s: Dictionary in c["spells"]:
		if String(s["name"]) == nm:
			return s
	return {}
func _free_at(gm: Node, from: Vector2i, dmin: int, dmax: int, n: int) -> Array:
	var out: Array = []
	for y: int in range(gm.GRID_SIZE):
		for x: int in range(gm.GRID_SIZE):
			var c := Vector2i(x, y)
			var d: int = Combat.manhattan(from, c)
			if d >= dmin and d <= dmax and gm.is_free(c) and out.size() < n:
				out.append(c)
	return out
func _boot() -> void:
	var gm: Node = root.get_node("GameManager")
	await process_frame
	gm.set_custom_team([{"classe": "Artificier"}, {"classe": "Tank"}, {"classe": "Mage"}])
	gm.init_grid()
	gm.init_entities()
	var art: Dictionary = {}
	for p: Dictionary in gm.players:
		if String(p["classe"]) == "Artificier":
			art = p
	check(not art.is_empty(), "Artificier jouable")
	art["spells"] = gm._build_spells("Artificier", 100)
	check(art["spells"].size() == 10, "10 sorts")
	for nm: String in ["Pistolet à ressort", "Poser Bombe", "Déclencheur", "Poser Mine", "Poser Tourelle", "Poser Balise de transposition", "Glyphe de surcharge", "Grenade à fragmentation", "Fusil à pompe", "Arsenal total"]:
		check(not _sp(art, nm).is_empty(), "sort " + nm)
	var dec: Dictionary = _sp(art, "Déclencheur")
	check(int(dec["cost_pa"]) == 1, "Déclencheur = 1 PA")
	check(Combat.parse(dec)["kind"] == "trigger", "Déclencheur parsé")
	art["current_pa"] = 40
	art["current_pm"] = 4
	var apos: Vector2i = gm.pos_of(art)
	var cells: Array = _free_at(gm, apos, 2, 4, 6)
	check(cells.size() >= 4, "cases libres")
	# Bombe
	var bomb: Dictionary = _sp(art, "Poser Bombe")
	check(gm.cast_spell(art, bomb, cells[0]), "bombe posée")
	check(gm.mechs_of(art).size() == 1, "1 mécanisme")
	check(gm.summons_of(art).is_empty(), "un mécanisme n'est pas un familier")
	check(gm.trigger_kind(art, cells[0]) == "bomb", "trigger_kind bombe")
	var foe: Dictionary = gm.enemies[0]
	# placer un ennemi à côté de la bombe
	var bpos: Vector2i = cells[0]
	var spot := Vector2i(-1, -1)
	for d: Vector2i in Combat.DIRS:
		if gm.is_free(bpos + d):
			spot = bpos + d
			break
	gm._teleport_entity(foe, spot)
	var hp0: int = int(foe["current_pv"])
	art["casts"] = {}
	check(gm.cast_spell(art, dec, bpos), "Déclencheur sur la bombe")
	check(int(foe["current_pv"]) < hp0, "la bombe a blessé l'ennemi voisin")
	check(gm.mechs_of(art).is_empty(), "bombe consommée")
	# Tourelle : une seule
	art["casts"] = {}
	var tur: Dictionary = _sp(art, "Poser Tourelle")
	var c2: Array = _free_at(gm, gm.pos_of(art), 2, 4, 6)
	check(gm.cast_spell(art, tur, c2[0]), "tourelle posée")
	art["casts"] = {}
	check(gm.validate_cast(art, tur, c2[1]) != "", "2e tourelle refusée (niveau < 65)")
	# Mine
	var mine: Dictionary = _sp(art, "Poser Mine")
	check(Combat.parse(mine)["kind"] == "trap" and bool(Combat.parse(mine)["mine"]), "mine = piège déclenchable")
	art["casts"] = {}
	var mc: Vector2i = c2[2]
	check(gm.cast_spell(art, mine, mc), "mine posée")
	check(gm.trigger_kind(art, mc) == "mine", "trigger_kind mine")
	# Glyphe
	art["casts"] = {}
	var gly: Dictionary = _sp(art, "Glyphe de surcharge")
	check(gm.cast_spell(art, gly, c2[3]), "glyphe posé")
	check(gm.trigger_kind(art, c2[3]) == "glyph", "trigger_kind glyphe")
	check(gm.trigger_all_count(art) >= 3, "Arsenal total : au moins 3 mécanismes")
	art["casts"] = {}
	check(gm.cast_spell(art, _sp(art, "Arsenal total"), apos), "Arsenal total lancé")
	check(gm.trigger_all_count(art) == 1 or gm.trigger_all_count(art) == 2, "Arsenal total consomme bombes/mines")
	# Inversion
	gm.init_grid()
	gm.init_entities()
	for p2: Dictionary in gm.players:
		if String(p2["classe"]) == "Artificier":
			art = p2
	art["spells"] = gm._build_spells("Artificier", 100)
	art["current_pa"] = 40
	art["current_pm"] = 4
	art["swapped"] = false
	var home: Vector2i = gm.pos_of(art)
	var bal: Dictionary = _sp(art, "Poser Balise de transposition")
	var far: Array = _free_at(gm, home, 3, 6, 3)
	check(gm.cast_spell(art, bal, far[0]), "balise posée")
	check(gm.pos_of(art) == far[0], "le héros a pris la place de la balise")
	check(gm.trigger_kind(art, home) == "swap", "la balise est sur l'ancienne case")
	check(bool(art["swapped"]), "déplacement consommé")
	art["casts"] = {}
	check(gm.validate_cast(art, _sp(art, "Déclencheur"), home) != "", "2e inversion refusée le même tour")
	check(gm.validate_cast(art, bal, far[1]) != "", "pas de nouvelle balise après l'inversion")
	# nouveau tour : l'inversion est de nouveau possible et ramène le héros
	art["swapped"] = false
	art["casts"] = {}
	check(gm.cast_spell(art, _sp(art, "Déclencheur"), home), "Déclencheur sur la balise")
	check(gm.pos_of(art) == home, "retour à la case d'origine")
	# immobilisé : pas d'inversion
	art["swapped"] = false
	Combat.add_status(art, "root", 1, 1.0)
	check(gm.validate_cast(art, _sp(art, "Déclencheur"), far[0]) != "", "immobilisé : inversion refusée")
	# Nation
	check(Nations.has("Rouages") and Nations.nation_name("Rouages") == "Rouages", "Nation Rouages")
	check(Nations.info("Rouages")["hero"] == "Artificier", "héros de la nation")
	check(ProgressionManager.ADVENTURE_ZONES.has("rouages_atelier"), "zone d'Aventure")
	check(BiomeEffects.has("Rouages"), "effet de biome")
	check(ResourceLoader.exists("res://assets/sprites/tiles/rouages_ground_01.svg"), "tuiles de sol")
	check(ResourceLoader.exists("res://assets/sprites/players/artificier.png"), "sprite provisoire")
	print("ÉCHECS : ", fails)
	quit(0 if fails == 0 else 1)
