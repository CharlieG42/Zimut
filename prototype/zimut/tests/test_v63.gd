extends SceneTree
## V63 : bombes à niveaux, Couplage (barrière entre mécanismes alignés), glyphes traversés,
## nom affiché de l'Artificier (Ingénieur).
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
func _clear(gm: Node, keep: Array) -> void:
	# libère le plateau : ne garde que les créatures listées
	for y: int in range(gm.GRID_SIZE):
		for x: int in range(gm.GRID_SIZE):
			gm.obstacles.erase(Vector2i(x, y))
	for arr: Array in [gm.players, gm.enemies, gm.summons]:
		for e: Dictionary in arr.duplicate():
			if not keep.has(e):
				gm.grid[int(e["y"])][int(e["x"])] = null
				arr.erase(e)
	for e: Dictionary in keep:
		gm.grid[int(e["y"])][int(e["x"])] = null
func _put(gm: Node, e: Dictionary, c: Vector2i) -> void:
	gm.grid[int(e["y"])][int(e["x"])] = null
	e["x"] = c.x
	e["y"] = c.y
	gm.grid[c.y][c.x] = e
func _boot() -> void:
	var gm: Node = root.get_node("GameManager")
	await process_frame
	gm.set_custom_team([{"classe": "Artificier"}, {"classe": "Géomancien"}, {"classe": "Mage"}])
	gm.init_grid()
	gm.init_entities()
	var art: Dictionary = {}
	var geo: Dictionary = {}
	for p: Dictionary in gm.players:
		if String(p["classe"]) == "Artificier":
			art = p
		elif String(p["classe"]) == "Géomancien":
			geo = p
	var foe: Dictionary = gm.enemies[0]
	_clear(gm, [art, geo, foe])
	_put(gm, art, Vector2i(1, 1))
	_put(gm, geo, Vector2i(0, 9))
	_put(gm, foe, Vector2i(8, 8))
	art["spells"] = gm._build_spells("Artificier", 100)
	art["level"] = 100
	art["current_pa"] = 60
	art["max_pv"] = 5000
	art["current_pv"] = 5000
	geo["max_pv"] = 5000
	geo["current_pv"] = 5000
	gm.active_entity = art
	art["is_active"] = true
	gm.current_turn = 0

	# ── Bombes à niveaux ──
	var bomb_sp: Dictionary = _sp(art, "Poser Bombe")
	check(gm.cast_spell(art, bomb_sp, Vector2i(3, 1)), "bombe posée")
	var b: Dictionary = gm.entity_at(Vector2i(3, 1))
	check(int(b.get("bomb_level", 0)) == 1, "la bombe commence au niveau 1")
	art["casts"] = {}
	# fin de tour : niveau 2
	for tp: Dictionary in gm.terrain_of(art):
		tp["lifetime"] = int(tp["lifetime"]) - 1
		if String(tp.get("mech", "")) == "bomb":
			gm._bomb_level_up(tp)
	check(int(b["bomb_level"]) == 2, "fin de tour : niveau 2")
	for i: int in range(5):
		gm._bomb_level_up(b)
	check(int(b["bomb_level"]) == gm.BOMB_MAX_LEVEL, "niveau plafonné à %d" % gm.BOMB_MAX_LEVEL)
	# l'explosion est plus forte à haut niveau : on compare deux ennemis identiques
	_put(gm, foe, Vector2i(4, 1))
	foe["max_pv"] = 5000
	foe["current_pv"] = 5000
	var dmg_hi: int = 0
	var pv0: int = int(foe["current_pv"])
	gm._mech_explode(art, b)
	gm.remove_entity_from_grid(b)
	dmg_hi = pv0 - int(foe["current_pv"])
	art["casts"] = {}
	check(gm.cast_spell(art, bomb_sp, Vector2i(3, 1)), "nouvelle bombe")
	var b2: Dictionary = gm.entity_at(Vector2i(3, 1))
	foe["current_pv"] = 5000
	gm._mech_explode(art, b2)
	gm.remove_entity_from_grid(b2)
	var dmg_lo: int = 5000 - int(foe["current_pv"])
	check(dmg_hi > dmg_lo and is_equal_approx(gm.BOMB_LEVEL_MULT[3], 2.0), "explosion niveau 4 plus forte qu'au niveau 1 (%d vs %d, ×2 hors critique)" % [dmg_hi, dmg_lo])
	art["casts"] = {}

	# ── Couplage ──
	var link: Dictionary = _sp(art, "Couplage")
	check(not link.is_empty(), "sort Couplage connu au niveau 100")
	var tur: Dictionary = _sp(art, "Poser Bombe")
	_put(gm, art, Vector2i(3, 2))
	_put(gm, foe, Vector2i(4, 4))
	check(gm.cast_spell(art, tur, Vector2i(2, 4)), "mécanisme A")
	art["casts"] = {}
	check(gm.cast_spell(art, tur, Vector2i(2, 2)), "mécanisme B (hors ligne)")
	art["casts"] = {}
	check(gm.validate_cast(art, link, Vector2i(6, 6)) != "", "Couplage refusé hors mécanisme")
	check(gm.cast_spell(art, link, Vector2i(2, 4)), "A couplé")
	art["casts"] = {}
	check(gm.barriers().is_empty(), "un seul mécanisme couplé : pas de barrière")
	# C aligné avec A sur la ligne y = 4, l'ennemi est entre les deux
	check(gm.cast_spell(art, tur, Vector2i(5, 4)), "mécanisme C aligné")
	art["casts"] = {}
	var fp0: int = int(foe["current_pv"])
	check(gm.cast_spell(art, link, Vector2i(5, 4)), "C couplé")
	art["casts"] = {}
	var bars: Array = gm.barriers()
	check(bars.size() == 1 and (bars[0]["cells"] as Array).size() == 2, "barrière de 2 cases entre A et C")
	check(int(foe["current_pv"]) < fp0, "l'ennemi pris dans la barrière est électrocuté")
	# l'ennemi au nord de la barrière ne peut pas la franchir ; l'allié oui
	_put(gm, foe, Vector2i(4, 3))
	foe["current_pm"] = 2
	var reach: Dictionary = gm.compute_reach(foe)
	check(not (reach["cost"] as Dictionary).has(Vector2i(4, 4)) and not (reach["cost"] as Dictionary).has(Vector2i(4, 5)), "l'ennemi ne franchit pas la barrière")
	_put(gm, foe, Vector2i(8, 8))
	_put(gm, geo, Vector2i(4, 3))
	geo["current_pm"] = 2
	var reach2: Dictionary = gm.compute_reach(geo)
	check((reach2["cost"] as Dictionary).has(Vector2i(4, 5)), "un allié traverse la barrière")
	# la barrière tombe quand le couplage expire
	for m: Dictionary in gm.mechs_of(art):
		m["link_turns"] = 0
	check(gm.barriers().is_empty(), "couplage expiré : plus de barrière")

	# ── Glyphe traversé ──
	geo["spells"] = gm._build_spells("Géomancien", 100)
	geo["current_pa"] = 30
	geo["level"] = 100
	var gl: Dictionary = {}
	for s: Dictionary in geo["spells"]:
		if String(s["name"]).begins_with("Glyphe") and gl.is_empty():
			gl = s
	check(not gl.is_empty(), "le Géomancien a un glyphe")
	for m2: Dictionary in gm.mechs_of(art).duplicate():
		m2["exploded"] = true
		gm.remove_entity_from_grid(m2)
	_put(gm, geo, Vector2i(0, 7))
	_put(gm, foe, Vector2i(2, 8))
	gm.glyphs.clear()
	gm.glyphs.append({"id": 999, "name": "Test", "cells": [Vector2i(4, 8)], "team": "player", "owner": int(geo["uid"]),
		"turns": 3, "foes": {"dmg": 30, "dtype": "mag", "dots": [], "debuffs": [], "buffs": []}, "allies": {},
		"snap": geo.duplicate(true), "last": {}, "center": Vector2i(4, 8), "element": "earth"})
	foe["current_pm"] = 6
	var hp0: int = int(foe["current_pv"])
	gm.active_entity = foe
	check(gm.try_move(foe, Vector2i(6, 8)), "l'ennemi se déplace à travers le glyphe")
	check(int(foe["current_pv"]) < hp0, "traverser le glyphe déclenche son effet")

	# ── Nom affiché ──
	var loc: Node = root.get_node("Loc")
	check(loc.rename("L'Artificier pose une bombe") == "L'Ingénieur pose une bombe", "l'Artificier s'affiche « Ingénieur »")
	check(tr("Artificier") == "Ingénieur" or TranslationServer.get_locale().begins_with("en"), "traduction automatique des Labels")
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
