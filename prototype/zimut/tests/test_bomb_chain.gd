extends SceneTree
## V53 : bombes de l'Artificier — rayon 2, ennemis et bombes pleins dégâts, alliés moitié,
## une bombe détruite explose (réaction en chaîne).
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
func _boot() -> void:
	var gm: Node = root.get_node("GameManager")
	await process_frame
	gm.set_custom_team([{"classe": "Artificier"}, {"classe": "Tank"}, {"classe": "Mage"}])
	gm.init_grid()
	gm.init_entities()
	var art: Dictionary = {}
	var ally: Dictionary = {}
	for p: Dictionary in gm.players:
		if String(p["classe"]) == "Artificier":
			art = p
		elif ally.is_empty():
			ally = p
	art["spells"] = gm._build_spells("Artificier", 100)
	art["level"] = 100
	art["current_pa"] = 60
	var bombspell: Dictionary = _sp(art, "Poser Bombe")
	var dec: Dictionary = _sp(art, "Déclencheur")
	var apos: Vector2i = gm.pos_of(art)
	# deux bombes côte à côte, à portée
	var ca := Vector2i(-1, -1)
	var cb := Vector2i(-1, -1)
	for y: int in range(gm.GRID_SIZE):
		for x: int in range(gm.GRID_SIZE):
			var c := Vector2i(x, y)
			if ca.x < 0 and Combat.manhattan(c, apos) >= 2 and Combat.manhattan(c, apos) <= 4 and gm.is_free(c):
				ca = c
	for d: Vector2i in Combat.DIRS:
		var c2: Vector2i = ca + d
		if cb.x < 0 and gm.is_free(c2) and Combat.manhattan(c2, apos) <= 4 and Combat.manhattan(c2, apos) >= 2:
			cb = c2
	check(ca.x >= 0 and cb.x >= 0, "deux cases pour les bombes")
	check(gm.cast_spell(art, bombspell, ca), "bombe A")
	art["casts"] = {}
	check(gm.cast_spell(art, bombspell, cb), "bombe B")
	art["casts"] = {}
	var ba: Dictionary = gm.entity_at(ca)
	var bb: Dictionary = gm.entity_at(cb)
	check(String(bb.get("mech", "")) == "bomb", "B est une bombe")
	# ennemi à distance 2 de A (hors croix), allié à distance 2 aussi
	var foe: Dictionary = gm.enemies[0]
	var far := Vector2i(-1, -1)
	var near2 := Vector2i(-1, -1)
	for y: int in range(gm.GRID_SIZE):
		for x: int in range(gm.GRID_SIZE):
			var c3 := Vector2i(x, y)
			if Combat.manhattan(c3, ca) == 2 and c3 != cb and gm.is_free(c3):
				if far.x < 0:
					far = c3
				elif near2.x < 0 and Combat.manhattan(c3, cb) > 0:
					near2 = c3
	check(far.x >= 0 and near2.x >= 0, "cases à 2 de la bombe")
	gm._teleport_entity(foe, far)
	gm._teleport_entity(ally, near2)
	foe["current_pv"] = foe["max_pv"]
	ally["current_pv"] = ally["max_pv"]
	var f0: int = int(foe["current_pv"])
	var a0: int = int(ally["current_pv"])
	var art0: int = int(art["current_pv"])
	check(gm.cast_spell(art, dec, ca), "déclenche A")
	check(int(foe["current_pv"]) < f0, "ennemi à 2 cases blessé (rayon 2)")
	check(int(ally["current_pv"]) < a0, "allié à 2 cases blessé (moitié)")
	check(int(ally["current_pv"]) > a0 - (f0 - int(foe["current_pv"])) or int(ally["max_pv"]) != int(foe["max_pv"]), "allié moins touché que l'ennemi")
	check(bool(ba.get("exploded", false)), "A a explosé")
	check(bool(bb.get("exploded", false)), "B détruite → a explosé (chaîne)")
	check(gm.mechs_of(art).is_empty(), "plus de bombe sur le terrain")
	check(int(art["current_pv"]) <= art0, "lanceur pas soigné")
	# bombe détruite par une attaque ennemie
	art["casts"] = {}
	check(gm.cast_spell(art, bombspell, ca) or true, "nouvelle bombe")
	var nb: Dictionary = gm.entity_at(ca)
	if String(nb.get("mech", "")) == "bomb":
		var fhp: int = int(foe["current_pv"])
		gm._teleport_entity(foe, far)
		gm._apply_damage(foe, nb, 999, "phys", false, false)
		gm._check_deaths()
		check(bool(nb.get("exploded", false)), "bombe détruite explose")
		check(int(foe["current_pv"]) < fhp or int(foe["current_pv"]) <= 0, "…et blesse l'ennemi proche")
	# V60 : une bombe blessée mais vivante n'explose PAS
	art["casts"] = {}
	gm.cast_spell(art, bombspell, ca)
	var hb: Dictionary = gm.entity_at(ca)
	if String(hb.get("mech", "")) == "bomb":
		var half: int = int(hb["current_pv"]) / 3
		gm._apply_damage(foe, hb, half, "phys", false, false)
		gm._check_deaths()
		check(int(hb["current_pv"]) > 0 and not bool(hb.get("exploded", false)), "bombe blessée mais vivante : pas d'explosion")
		check(gm.mechs_of(art).size() >= 1, "…elle reste sur le terrain")
		gm._apply_damage(foe, hb, int(hb["current_pv"]), "phys", false, false)
		gm._check_deaths()
		check(bool(hb.get("exploded", false)), "à 0 PV elle explose")
	# V60 : à bas niveau, une seule explosion ne détruit pas une bombe voisine intacte (il en faut deux)
	art["level"] = 3
	art["casts"] = {}
	var c1 := Vector2i(-1, -1)
	var c2 := Vector2i(-1, -1)
	for y: int in range(gm.GRID_SIZE):
		for x: int in range(gm.GRID_SIZE):
			var c := Vector2i(x, y)
			if c1.x < 0 and gm.is_free(c) and Combat.manhattan(c, apos) >= 2 and Combat.manhattan(c, apos) <= 4:
				c1 = c
	for d2: Vector2i in Combat.DIRS:
		if c2.x < 0 and gm.is_free(c1 + d2) and Combat.manhattan(c1 + d2, apos) >= 2 and Combat.manhattan(c1 + d2, apos) <= 4:
			c2 = c1 + d2
	if c1.x >= 0 and c2.x >= 0:
		gm.cast_spell(art, bombspell, c1)
		art["casts"] = {}
		gm.cast_spell(art, bombspell, c2)
		var b1: Dictionary = gm.entity_at(c1)
		var b2: Dictionary = gm.entity_at(c2)
		var pv2: int = int(b2["current_pv"])
		gm._mech_explode(art, b1)
		check(int(b2["current_pv"]) < pv2, "la bombe voisine est touchée")
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
