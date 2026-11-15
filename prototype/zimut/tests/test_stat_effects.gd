extends SceneTree
## V364 — Onglet CARACTÉRISTIQUES : résultats (dégâts, résistances, critique, soins…) et règles de calcul.
## Les chiffres affichés doivent être exactement ceux du combat (Combat.calc_damage, GameManager).
## Lancement : godot --headless --path . -s tests/test_stat_effects.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	# ── formules de base ──
	check(is_equal_approx(StatEffects.damage_stat_mult(100.0), 1.5), "100 de Force = +50 %")
	check(is_equal_approx(StatEffects.phys_resistance(100.0), 0.5), "Défense 100 = 50 % de résistance physique")
	check(is_equal_approx(StatEffects.mag_resistance(100.0), 50.0 / 150.0), "Défense 100 = 33 % de résistance magique (moitié)")
	check(StatEffects.phys_resistance(100000.0) <= StatEffects.RES_MAX, "plafond de résistance %d %%" % roundi(StatEffects.RES_MAX * 100.0))
	check(is_equal_approx(StatEffects.crit_chance(0.0, 0.0, 0.0), 0.05) and StatEffects.crit_chance(100000.0, 0.0, 0.0) == StatEffects.CRIT_MAX, "critique : 5 % mini, 60 % maxi")
	check(is_equal_approx(StatEffects.alteration_land(50.0, 50.0), 0.9) and StatEffects.alteration_land(0.0, 1000.0) == 0.5 and StatEffects.alteration_land(1000.0, 0.0) == 1.0, "altérations : 90 % à égalité, bornées 50-100 %")
	# ── l'affichage correspond au combat réel ──
	var att := {"x": 0, "y": 0, "force": 80, "intelligence": 120, "agility": 100, "wisdom": 40, "fx": {"phys_pct": 10, "mag_pct": 20, "crit": 5, "talent_dmg_pct": 1.1}}
	var tgt := {"x": 6, "y": 6, "defense": 90, "facing": Vector2i(0, 0), "fx": {"mres": 10}}
	var st := {"force": 80, "intelligence": 120, "agility": 100, "wisdom": 40, "defense": 90, "max_pv": 200,
		"fx": {"phys_pct": 10, "mag_pct": 20, "crit": 5, "mres": 10, "heal_pct": 15, "lifesteal": 4}, "talent_dmg_pct": 1.1, "talent_heal_pct": 1.0, "talent_crit_pct": 0.0}
	var v: Dictionary = StatEffects.values(st)
	for dtype: String in ["phys", "mag"]:
		var r: Dictionary = Combat.calc_damage(att, tgt, 100.0, dtype, 0.0, false, true)
		var res: float = float(v["phys_res"]) if dtype == "phys" else float(v["mag_res"])
		var expect: int = maxi(1, roundi(100.0 * float(v[dtype]) * (1.0 + float(v["crit"]) * 0.5) * (1.0 - res) * (StatEffects.BACK_MULT if bool(r["back"]) else 1.0)))
		check(int(r["dmg"]) == expect, "dégâts %s : combat %d = affichage %d" % [dtype, int(r["dmg"]), expect])
	check(is_equal_approx(float(v["heal"]), (1.0 + 120.0 / 300.0) * (1.0 + 40.0 / 300.0) * 1.15), "soins : (1+Int/300)(1+Sag/300)(1+objets)")
	# ── cartes de résultats ──
	var cards: Array[Dictionary] = StatEffects.results(st)
	var ids: Array = []
	for c: Dictionary in cards:
		ids.append(String(c["id"]))
	for need: String in ["pv", "phys", "mag", "crit", "phys_res", "mag_res", "heal", "init", "anti_dodge", "alter", "lifesteal"]:
		check(ids.has(need), "carte « %s » présente" % need)
	check(not ids.has("poison"), "pas de carte Poisons sans bonus de poison")
	var by: Dictionary = {}
	for c: Dictionary in cards:
		by[String(c["id"])] = c
	check(String(by["phys"]["value"]) == "+%d %%" % roundi((float(v["phys"]) - 1.0) * 100.0), "valeur dégâts physiques : %s" % String(by["phys"]["value"]))
	check(String(by["phys_res"]["value"]) == "%d %%" % roundi(float(v["phys_res"]) * 100.0), "valeur résistance physique : %s" % String(by["phys_res"]["value"]))
	var rules: String = StatEffects.rules_bbcode()
	check(rules.contains("Résistance physique") and rules.contains("Coup critique") and rules.contains("Soins") and rules.contains("Initiative") and rules.contains("Précision") and rules.contains("Altérations"), "règles : toutes les caractéristiques expliquées")
	check(rules.contains("5 % + Agilité") and rules.contains("Poisons +%"), "règles : pourcentages bien formatés")
	# ── vue : résultats et règles dans l'onglet ──
	var pm: Node = root.get_node("ProgressionManager")
	var d: Dictionary = pm.new_game(4, "StatFx")
	pm.rebuild_team(d, ["Tank", "Mage", "Heal"])
	pm.write_save(4, d)
	var ui: CanvasLayer = (load("res://scripts/CharacterSheetUI.gd") as GDScript).new()
	ui.layer = 10
	root.add_child(ui)
	ui.open(d, 4, "Tank")
	ui._tab = "stats"
	ui.refresh()
	await process_frame
	await process_frame
	check(ui.find_child("StatResults", true, false) != null, "section « Résultats en combat » affichée")
	check(ui.find_child("Result_phys", true, false) != null and ui.find_child("Result_phys_res", true, false) != null and ui.find_child("Result_crit", true, false) != null, "cartes dégâts / résistance / critique")
	var rules_node: Node = ui.find_child("StatRules", true, false)
	check(rules_node != null, "section « Règles de calcul » affichée")
	var content: Node = ui.find_child("StatRules", true, false).get_parent()
	check(content.get_child(content.get_child_count() - 1).name == "StatRules", "les règles sont tout à la fin de l'onglet")
	var tank: Dictionary = pm.member_stats(d, d["team"][0])
	var shown: Label = ui.find_child("Result_pv", true, false).find_child("ResultValue", true, false) as Label
	check(shown != null and shown.text == str(int(tank["max_pv"])), "PV affichés = PV du héros (%s)" % (shown.text if shown else "?"))
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
