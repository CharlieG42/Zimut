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
	check(art["spells"].size() == 30, "30 sorts au niveau 100")
	for nm: String in ["Pistolet à ressort", "Poser Bombe", "Déclencheur", "Poser Mine", "Poser Tourelle", "Poser Balise de transposition", "Glyphe de surcharge", "Poser Charge à fragmentation", "Fusil à pompe", "Arsenal total", "Rappel", "Maintenance", "Poser Bombe incendiaire", "Poser Bombe assourdissante", "Poser Tourelle lourde"]:
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
	# V68 : bombes à 4 tours, Rappel, Maintenance, variantes, 5 mécanismes
	gm.init_grid()
	gm.init_entities()
	for p3: Dictionary in gm.players:
		if String(p3["classe"]) == "Artificier":
			art = p3
	art["spells"] = gm._build_spells("Artificier", 100)
	art["current_pa"] = 60
	var rap: Dictionary = _sp(art, "Rappel")
	check(int(rap["cost_pa"]) == 1 and int(rap["range"]) == 5, "Rappel : 1 PA, 5 PO")
	var fc: Array = _free_at(gm, gm.pos_of(art), 2, 4, 8)
	art["casts"] = {}
	check(gm.cast_spell(art, _sp(art, "Poser Bombe"), fc[0]), "bombe (V68)")
	var bb: Dictionary = gm.entity_at(fc[0])
	check(int(bb.get("lifetime", 0)) == 4, "bombe : explosion au bout de 4 tours")
	art["casts"] = {}
	check(gm.cast_spell(art, rap, fc[0]), "Rappel sur la bombe")
	check(gm.mechs_of(art).is_empty() and not gm.is_alive(bb) or gm.entity_at(fc[0]).is_empty(), "bombe rappelée sans explosion")
	var kinds: Array = ["Poser Bombe", "Poser Bombe incendiaire", "Poser Bombe assourdissante", "Poser Charge à fragmentation", "Poser Tourelle"]
	for i: int in range(5):
		art["casts"] = {}
		check(gm.cast_spell(art, _sp(art, kinds[i]), fc[i + 1]), "mécanisme %d (%s)" % [i + 1, kinds[i]])
	check(gm.mechs_of(art).size() == 5, "5 mécanismes sur le terrain")
	art["casts"] = {}
	check(gm.validate_cast(art, _sp(art, "Poser Bombe"), fc[6]) != "", "6e mécanisme refusé")
	var fr: Dictionary = gm.entity_at(fc[4])
	check(int(fr.get("bomb_radius", 0)) == 3, "charge à fragmentation : rayon 3")
	var mt: Dictionary = gm.entity_at(fc[1])
	mt["current_pv"] = 1
	art["casts"] = {}
	check(gm.cast_spell(art, _sp(art, "Maintenance"), gm.pos_of(art)), "Maintenance")
	check(int(mt["current_pv"]) == int(mt["max_pv"]) and int(mt["lifetime"]) == 6, "réparée et prolongée de 2 tours")
	# bombe incendiaire : brûle l'ennemi touché
	var foe2: Dictionary = gm.enemies[0]
	var ib: Dictionary = gm.entity_at(fc[2])
	for d3: Vector2i in Combat.DIRS:
		if gm.is_free(fc[2] + d3):
			gm._teleport_entity(foe2, fc[2] + d3)
			break
	foe2["current_pv"] = foe2["max_pv"]
	art["casts"] = {}
	check(gm.cast_spell(art, _sp(art, "Déclencheur"), fc[2]), "Déclencheur bombe incendiaire")
	check(Combat.has_status(foe2, "burn"), "ennemi en feu")
	# Nation
	check(Nations.has("Rouages") and Nations.nation_name("Rouages") == "Rouages", "Nation Rouages")
	check(Nations.info("Rouages")["hero"] == "Artificier", "héros de la nation")
	check(ProgressionManager.ADVENTURE_ZONES.has("rouages_atelier"), "zone d'Aventure")
	check(BiomeEffects.has("Rouages"), "effet de biome")
	check(ResourceLoader.exists("res://assets/sprites/tiles/rouages_ground_01.svg"), "tuiles de sol")
	check(ResourceLoader.exists("res://assets/sprites/players/artificier.png"), "sprite provisoire")
	print("ÉCHECS : ", fails)
	quit(0 if fails == 0 else 1)
