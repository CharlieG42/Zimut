extends SceneTree
## V151 : Bannières des Nations unies et chapitres de campagne (Conquête).
## Lancement : godot --headless --path . -s tests/test_v151_nations_chapitres.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var pm: Node = root.get_node("/root/ProgressionManager")
	var CS: GDScript = load("res://scripts/ConquestSystem.gd")
	var sylve: Array = pm.conquest_nation_cities("Forêt")
	check(sylve.size() == 7 and sylve.has("capitale"), "la Sylve compte 7 villes, capitale comprise")
	check(pm.conquest_nation_cities("*").size() == 44, "Tout Zimut : 44 villes (hors capitale et Donjon du Roi)")
	var data: Dictionary = pm.new_game(4, "V151")
	pm.rebuild_team(data, ["Tank", "Mage", "Sylvain"])
	data["conquest"] = {"owned": ["capitale", "clairiere"], "pending_city": ""}
	var cq: Dictionary = data["conquest"]
	# ── Bannière : rien tant que la Nation n'est pas entière
	var base: Dictionary = pm.member_stats(data, {"classe": "Tank"})
	check(CS.united_nations(cq).is_empty(), "Sylve incomplète : pas de Bannière")
	var def_before: int = CS.defense(data, "clairiere")
	cq["owned"] = sylve.duplicate()
	check(CS.united_nations(cq) == ["Forêt"], "toutes les villes de la Sylve : Nation unie")
	var with_b: Dictionary = pm.member_stats(data, {"classe": "Tank"})
	check(int(with_b["max_pv"]) > int(base["max_pv"]) and int((with_b["fx"] as Dictionary).get("heal_pct", 0)) >= 5, "Bannière de la Sylve : PV et soins en plus (%d → %d PV)" % [int(base["max_pv"]), int(with_b["max_pv"])])
	check(CS.defense(data, "clairiere") == def_before + CS.NATION_UNITED_DEF, "villes de la Sylve : +%d de défense" % CS.NATION_UNITED_DEF)
	check(CS.defense(data, "capitale") >= CS.NATION_UNITED_DEF, "la capitale en profite aussi")
	check(CS.announce_united(cq) == ["Forêt"] and CS.announce_united(cq).is_empty(), "annonce une seule fois")
	cq["owned"].erase("fort_racine")
	check(CS.united_nations(cq).is_empty() and int(pm.member_stats(data, {"classe": "Tank"})["max_pv"]) == int(base["max_pv"]), "une ville perdue : Bannière suspendue")
	cq["owned"] = sylve.duplicate()
	check(not CS.banner_text("Montagne").is_empty() and CS.banner_text("Forêt").contains("PV"), "texte des Bannières")
	# ── chapitres
	var d2: Dictionary = pm.new_game(4, "V151b")
	d2["conquest"] = {"owned": ["capitale"], "pending_city": ""}
	var c2: Dictionary = d2["conquest"]
	check(CS.chapter_index(c2) == 0 and CS.advance_chapters(d2, c2).is_empty(), "départ : chapitre 1, rien d'accompli")
	c2["owned"] = ["capitale", "clairiere", "vieille_tour", "pont_mousse"]
	var g0: int = int(d2.get("gold", 0))
	var done: Array = CS.advance_chapters(d2, c2)
	check(done.size() == 1 and CS.chapter_index(c2) == 1 and int(d2["gold"]) == g0 + 150, "3 villes conquises : chapitre 1 accompli, +150 or")
	var pr: Dictionary = CS.chapter_progress(d2, CS.CHAPTERS[1])
	check(int(pr["cur"]) == 4 and int(pr["max"]) == 7, "chapitre 2 : 4 / 7 villes de la Sylve (capitale comprise)")
	# plusieurs chapitres d'un coup : Sylve unie + une Cité
	c2["owned"] = sylve.duplicate()
	c2["city_levels"] = {"clairiere": 3}
	var res0: int = int((d2.get("resources", {}) as Dictionary).get("Bois", 0))
	done = CS.advance_chapters(d2, c2)
	check(done.size() == 3 and CS.chapter_index(c2) == 4, "Sylve unie (Fort Racine de Tharok compris) et une Cité : chapitres 2, 3 et 4 accomplis d'un coup")
	check(int((d2["resources"] as Dictionary).get("Bois", 0)) == res0 + 15, "récompense en ressources versée")
	var told := 0
	for line: Variant in c2.get("news", []):
		if String(line).contains("CHAPITRE"):
			told += 1
	check(told == 4, "chaque chapitre est annoncé dans les nouvelles")
	# fin de campagne
	c2["chapter"] = CS.CHAPTERS.size() - 1
	c2["owned"].append("donjon_roi")
	CS.advance_chapters(d2, c2)
	check(CS.chapter_index(c2) == CS.CHAPTERS.size(), "Donjon du Roi pris : campagne achevée")
	# victoire de Conquête : vérifie nations et chapitres
	var d3: Dictionary = pm.new_game(4, "V151c")
	pm.rebuild_team(d3, ["Tank", "Mage", "Sylvain"])
	d3["campaign_mode"] = "conquest"
	d3["conquest"] = {"owned": ["capitale", "clairiere", "hameau_pin"], "pending_city": "vieille_tour", "pending_level": 1, "sieges": {"vieille_tour": 20}}
	pm.register_victory(d3, {"enemies": [], "turns": 4})
	check(CS.chapter_index(d3["conquest"]) >= 1, "une victoire qui donne la 3e ville valide le chapitre 1")
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
