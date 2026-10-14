extends SceneTree
## Tests V4 : combats rejouables, XP hors équipe 5 %, XP calibrée, bouton MENU.
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(3, "R")
	pm.rebuild_team(data, ["Tank", "Mage", "Sylvain"])
	check(ClassRules.BENCH_XP_RATIO == 0.05, "XP hors équipe = 5 %")
	var lv_start: Array = []
	for c in ["Tank", "Mage", "Sylvain"]:
		lv_start.append(pm.member_level(data, c))
	# 6 victoires de la frontière (1 ennemi faible par combat) : l'équipe progresse
	# au nouveau rythme calibré — ici 1 niveau sur 6 combats contre un ennemi seul,
	# plus avec une équipe complète au niveau du combat (~3 combats/palier).
	var lv_after6: int = 0
	for i in range(6):
		pm.register_victory(data, {"enemies": [{"type": "Gobelin", "level": 10, "boss": false}]})
		lv_after6 = pm.member_level(data, "Tank")
	check(lv_after6 > int(lv_start[0]), "6 victoires : l'équipe progresse d'au moins 1 niveau (XP calibrée, fin du gain garanti)")
	check(int(data["victories"]) == 6 and data["fight_levels"].size() == 6, "historique des niveaux de combat (6)")
	# XP hors équipe : <= 10 % du gain d'un membre de l'équipe (même multiplicateur de classe)
	var rep: Dictionary = pm.award_xp(data, 10000)
	var team_gain: int = int(rep["Tank"]["gain"])
	var bench_gain: int = int(rep["Assassin"]["gain"])
	check(bench_gain <= int(ceil(team_gain * 0.05 * 1.2)), "gain hors équipe plafonné à ~5 %% (%d vs %d)" % [bench_gain, team_gain])
	# Replay d'un combat plus bas
	var frontier: int = pm.frontier_fight_number(data)
	check(frontier == 7, "frontière = combat 7")
	check(pm.select_fight(data, 3) == 3 and pm.selected_fight_number(data) == 3, "sélection du combat 3")
	check(pm.enemy_level_for(data) == int(data["fight_levels"][2]), "niveau du combat 3 = niveau historique")
	check(pm.enemy_level_for(data) < pm.frontier_level(data), "combat rejoué plus bas que la frontière")
	var lv_before: int = pm.member_level(data, "Tank")
	var xp_before: int = int(pm.roster_entry(data, "Tank")["xp"])
	var inv_before: int = data["inventory"].size()
	pm.register_victory(data, {"enemies": [{"type": "Gobelin", "level": pm.enemy_level_for(data), "boss": false}]})
	check(int(data["victories"]) == 6, "rejouer ne fait pas avancer la progression")
	check(int(pm.roster_entry(data, "Tank")["xp"]) > xp_before, "XP gagnée en rejouant")
	check(data["inventory"].size() > inv_before, "loots en rejouant")
	check(bool(data["last_result"]["replay"]), "résultat marqué « rejoué »")
	check(pm.select_fight(data, 99) == 7 and pm.selected_fight_number(data) == 7, "sélection plafonnée à la frontière")
	# Bouton MENU : le script de sélection d'équipe expose bien le retour vers les parties
	var src: String = FileAccess.get_file_as_string("res://scripts/TeamSelectionUI.gd")
	check(src.contains("SaveSlots.tscn"), "le bouton MENU revient à la fenêtre des parties")
	# Caractéristiques bonus PA / PM / PO : 3 niveaux max, 4 points par niveau, plafonds
	var ent: Dictionary = pm.roster_entry(data, "Tank")
	ent["unspent"] = 40
	for _i: int in range(4):
		var r: String = pm.invest_point(data, "Tank", "pa")
		var should_fail: bool = _i >= ClassRules.BONUS_MAX_LEVELS
		check((r != "") == should_fail, "PA : max %d niveaux (tentative %d)" % [ClassRules.BONUS_MAX_LEVELS, _i + 1])
	check(int(ent["invested"].get("pa", 0)) == ClassRules.BONUS_MAX_LEVELS, "PA investis = 3 niveaux")
	var stt: Dictionary = pm.member_stats(data, data["team"][0])
	check(int(stt["pa"]) <= ClassRules.PA_CAP, "PA plafonnés à %d" % ClassRules.PA_CAP)
	check(int(stt["pm"]) <= ClassRules.PM_CAP, "PM plafonnés à %d" % ClassRules.PM_CAP)
	check(int(stt.get("po", 0)) <= ClassRules.PO_CAP, "PO plafonnées à %d" % ClassRules.PO_CAP)
	ent["invested"]["po"] = ClassRules.PO_CAP
	stt = pm.member_stats(data, data["team"][0])
	check(int(stt["po"]) == ClassRules.PO_CAP, "PO investies prises en compte")
	pm.delete_save(3)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
