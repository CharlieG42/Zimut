extends SceneTree
## V102 : le Chasseur a davantage de sorts de zone ; Tir rapide devient « Volée de flèches » (zone) et les anciennes sauvegardes suivent.
var fails := 0
func ck(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c: fails += 1

func _init() -> void:
	_run.call_deferred()

func _run() -> void:
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	var sp: Array = gm._build_spells("Chasseur", 100)
	var by: Dictionary = {}
	var zone: Array[String] = []
	var raw: Dictionary = {}
	for s: Dictionary in sp:
		raw[String(s["name"])] = s
		var pr: Dictionary = Combat.parse(s)
		pr["type"] = s.get("spell_type", "")
		pr["level_req"] = s.get("level_required", 99)
		by[String(s["name"])] = pr
		if String(pr.get("aoe", "")) == "zone" or String(pr.get("aoe", "")) == "enemies_in_range":
			zone.append(String(s["name"]))
	ck(not by.has("Tir rapide"), "« Tir rapide » n'existe plus")
	ck(by.has("Volée de flèches") and String(by["Volée de flèches"].get("aoe", "")) == "zone", "Volée de flèches : sort de zone")
	ck(int(by["Volée de flèches"].get("zone_r", 0)) == 3, "Volée de flèches : zone 3x3")
	ck(by.has("Tir précis") and String(by["Tir précis"].get("aoe", "")) == "single", "Tir précis reste mono-cible")
	# Parmi les attaques de niveau < 6, exactement une est de zone
	var attacks_lt6: int = 0
	var zone_lt6: int = 0
	for nm2: String in by.keys():
		var q: Dictionary = by[nm2]
		if int(q["level_req"]) < 6 and String(q["type"]) == "Attaque":
			attacks_lt6 += 1
			if String(q.get("aoe", "")) == "zone":
				zone_lt6 += 1
	ck(attacks_lt6 == 2 and zone_lt6 == 1, "niveau < 6 : 2 attaques dont 1 de zone (%d / %d)" % [zone_lt6, attacks_lt6])
	ck(zone.size() >= 8, "au moins 8 sorts de zone au niveau 100 (%d : %s)" % [zone.size(), ", ".join(zone)])
	for nm: String in ["Nuée empoisonnée", "Gerbe de glace", "Averse ardente"]:
		ck(by.has(nm) and String(by[nm].get("aoe", "")) == "zone", "%s : sort de zone" % nm)
	ck(not by["Nuée empoisonnée"].get("dots", []).is_empty(), "Nuée empoisonnée : poison sur la durée")
	ck(not by["Gerbe de glace"].get("debuffs", []).is_empty(), "Gerbe de glace : ralentit")
	ck(int(by["Averse ardente"].get("zone_r", 0)) == 4 and not by["Averse ardente"].get("dots", []).is_empty(), "Averse ardente : zone 4x4 + brûlure")
	# Migration : l'ancien nom suit dans niveaux de sort, sorts actifs et builds
	var ent: Dictionary = {"spell_levels": {"Tir rapide": 3, "Tir précis": 2}, "active_spells": ["Tir précis", "Tir rapide"],
		"builds": [{"name": "A", "spells": ["Tir rapide", "Balise de chasse"]}]}
	pm._rename_spells(ent)
	ck(ent["spell_levels"].get("Volée de flèches", 0) == 3 and not ent["spell_levels"].has("Tir rapide"), "niveau de sort reporté")
	ck(ent["active_spells"] == ["Tir précis", "Volée de flèches"], "sorts actifs renommés")
	ck(ent["builds"][0]["spells"][0] == "Volée de flèches", "builds renommés")
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
