extends SceneTree
## Tests V4 : combats rejouables, XP hors équipe 10 %, +1 niveau garanti, bouton MENU.
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
	check(ClassRules.BENCH_XP_RATIO == 0.10, "XP hors équipe = 10 %")
	var lv_start: Array = []
	for c in ["Tank", "Mage", "Sylvain"]:
		lv_start.append(pm.member_level(data, c))
	# 6 victoires de la frontière : chaque perso de l'équipe gagne au moins 1 niveau à chaque combat
	var ok_each: bool = true
	for i in range(6):
		var before: Array = []
		for c in ["Tank", "Mage", "Sylvain"]:
			before.append(pm.member_level(data, c))
		pm.register_victory(data, {"enemies": [{"type": "Gobelin", "level": 10, "boss": false}]})
		for j in range(3):
			var c2: String = ["Tank", "Mage", "Sylvain"][j]
			if pm.member_level(data, c2) <= int(before[j]):
				ok_each = false
	check(ok_each, "chaque victoire de progression fait monter chaque perso d'au moins 1 niveau")
	check(int(data["victories"]) == 6 and data["fight_levels"].size() == 6, "historique des niveaux de combat (6)")
	# XP hors équipe : <= 10 % du gain d'un membre de l'équipe (même multiplicateur de classe)
	var rep: Dictionary = pm.award_xp(data, 10000, 1.0, 0, false)
	var team_gain: int = int(rep["Tank"]["gain"])
	var bench_gain: int = int(rep["Assassin"]["gain"])
	check(bench_gain <= int(ceil(team_gain * 0.10 * 1.2)), "gain hors équipe plafonné à ~10 %% (%d vs %d)" % [bench_gain, team_gain])
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
	# Bouton MENU : le script de sélection d'équipe expose bien le retour vers le menu
	var src: String = FileAccess.get_file_as_string("res://scripts/TeamSelectionUI.gd")
	check(src.contains("MainMenu.tscn"), "le bouton MENU change de scène")
	pm.delete_save(3)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
