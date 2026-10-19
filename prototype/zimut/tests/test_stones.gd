extends SceneTree
## V27 : Pierres Élémentaires (obtention, port 2 max, unicité, éveil, bonus), sanctuaires d'Aventure,
## villes Rouages de Conquête.
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	await process_frame
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(7, "Pierres")
	pm.rebuild_team(data, ["Tank", "Mage", "Artificier"])
	pm.ensure_roster(data)
	check(Stones.ORDER.size() == 10, "10 Pierres (une par Nation)")
	for b: String in Stones.ORDER:
		check(Nations.has(b), "Nation de la %s" % Stones.stone_name(b))
	# Sanctuaires d'Aventure
	var guardians: Array = []
	for z: String in pm.ADVENTURE_POIS.keys():
		for k: String in pm.ADVENTURE_POIS[z].keys():
			var g: String = String(pm.ADVENTURE_POIS[z][k].get("guardian", ""))
			if g != "":
				guardians.append(g)
				check(pm.adventure_zone_biome(z) == g, "sanctuaire %s dans un biome %s" % [z, g])
				check(not pm.adventure_poi_by_key("%s,%s" % [z, k]).is_empty(), "POI par clé " + z)
	check(guardians.size() == 10, "10 sanctuaires (%d)" % guardians.size())
	# Obtention par victoire sur un boss de Nation
	var mage_before: Dictionary = pm.member_stats(data, data["team"][1])
	pm.register_victory(data, {"enemies": [{"type": "Troll", "level": 5, "boss": true}], "turns": 5, "boss": true, "nation_boss": "Cristaux"})
	check(Stones.has(data, "Cristaux"), "Pierre de Prisme gagnée")
	check(String(data["last_result"].get("stone", "")) == "Cristaux", "annoncée dans le résultat")
	pm.register_victory(data, {"enemies": [{"type": "Troll", "level": 5, "boss": true}], "turns": 5, "boss": true, "nation_boss": "Cristaux"})
	check(not data["last_result"].has("stone"), "pas de doublon")
	check(Achievements.stat(data, "stones") == 1, "compteur de succès")
	# Port
	check(Stones.equip(data, "Cristaux", "Mage") == "", "confiée au Mage")
	var ms: Dictionary = pm.member_stats(data, data["team"][1])
	check(int(ms["intelligence"]) == int(mage_before["intelligence"]) + 5, "Intelligence +5")
	check(int(ms["fx"].get("mag_pct", 0)) >= 3, "dégâts magiques +3 %")
	Stones.grant(data, "Rouages")
	Stones.grant(data, "Vents")
	check(Stones.equip(data, "Rouages", "Mage") == "", "2e Pierre au Mage")
	check(Stones.equip(data, "Vents", "Mage") != "", "3e Pierre refusée")
	var pa0: int = int(mage_before["pa"])
	check(int(pm.member_stats(data, data["team"][1])["pa"]) == mini(ClassRules.PA_CAP, pa0 + 1), "Pierre d'Airain : +1 PA")
	check(Stones.equip(data, "Rouages", "Tank") == "" and Stones.owner_of(data, "Rouages") == "Tank", "unicité : passe au Tank")
	check(Stones.stones_of(data, "Mage").size() == 1, "le Mage n'en porte plus qu'une")
	# Éveil
	data["gold"] = 0
	check(Stones.awaken(data, "Cristaux") != "", "éveil refusé sans or")
	data["gold"] = 10000
	data["resources"]["Magie"] = 100
	check(Stones.awaken(data, "Cristaux") == "" and Stones.level(data, "Cristaux") == 2, "éveil niveau 2")
	check(int(pm.member_stats(data, data["team"][1])["intelligence"]) == int(mage_before["intelligence"]) + 10, "bonus doublé au niveau 2")
	# Conquête Rouages
	check(pm.CONQUEST_CITIES.has("atelier_cuivre") and pm.CONQUEST_CITIES.has("citadelle_engrenages"), "villes Rouages")
	check((load("res://scripts/ConquestMapUI.gd") as GDScript).get_script_constant_map()["CITY_POS"].has("citadelle_engrenages"), "position sur la carte")
	pm.delete_save(7)
	print("ÉCHECS : ", fails)
	quit(0 if fails == 0 else 1)
