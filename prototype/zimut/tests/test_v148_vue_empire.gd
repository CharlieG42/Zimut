extends SceneTree
## V148 : vue d'ensemble de l'empire de Conquête (tableau + actions groupées).
## Lancement : godot --headless --path . -s tests/test_v148_vue_empire.gd
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
	var data: Dictionary = pm.new_game(4, "V148")
	data["gold"] = 1000
	data["conquest"] = {"owned": ["capitale", "clairiere", "hameau_pin", "fort_racine"], "pending_city": "",
		"city_levels": {"capitale": 3},
		"garrisons": {"capitale": {"troops": 6, "hero": ""}, "clairiere": {"troops": 3, "hero": "Chasseur"}},
		"ruin": {"fort_racine": 4},
		"threat": {"city": "hameau_pin", "power": 25, "eta": 2}}
	# ── tableau
	var rows: Array = CS.empire_rows(data)
	check(rows.size() == 4, "une ligne par ville de l'empire")
	check(String(rows[0]["id"]) == "hameau_pin" and bool(rows[0]["threatened"]), "la ville menacée vient en premier")
	var by_id: Dictionary = {}
	for r: Dictionary in rows:
		by_id[r["id"]] = r
	check(bool(by_id["fort_racine"]["ruined"]) and bool(by_id["fort_racine"]["alert"]) and int(by_id["fort_racine"]["income"]) == 0, "ville ruinée signalée, sans revenus")
	check(String(by_id["clairiere"]["hero"]) == "Chasseur" and int(by_id["clairiere"]["troops"]) == 3, "gouverneur et soldats lus")
	check(int(by_id["capitale"]["cap"]) == CS.garrison_cap(data["conquest"], "capitale"), "capacité de la garnison")
	check(CS.empire_action_count(data) >= 3, "pastille : au moins 3 villes à voir (%d)" % CS.empire_action_count(data))
	# ── recruter partout : la ville menacée d'abord, puis la moins défendue, dans la limite de l'or
	var cost: int = CS.recruit_all_cost(data)
	var expect_n: int = 0
	for r2: Dictionary in rows:
		expect_n += int(r2["cap"]) - int(r2["troops"])
	check(cost == expect_n * CS.TROOP_COST, "coût pour tout remplir : %d or" % cost)
	data["gold"] = CS.TROOP_COST * 3
	var res: Dictionary = CS.recruit_all(data)
	check(int(res["soldiers"]) == 3 and int(data["gold"]) == 0, "or limité : 3 soldats recrutés, trésor vidé")
	check(CS.troops(data["conquest"], "hameau_pin") >= 2, "la ville menacée a été servie en premier (%d soldats)" % CS.troops(data["conquest"], "hameau_pin"))
	data["gold"] = 100000
	CS.recruit_all(data)
	var full := true
	for id: String in data["conquest"]["owned"]:
		if CS.troops(data["conquest"], id) < CS.garrison_cap(data["conquest"], id):
			full = false
	check(full and CS.recruit_all_cost(data) == 0, "assez d'or : toutes les garnisons pleines")
	check(int(CS.recruit_all(data)["soldiers"]) == 0, "rien à recruter quand tout est plein")
	# ── améliorer ce qui est payable
	data["gold"] = 100000
	data["resources"] = {"Bois": 999, "Fer": 999, "Cuir": 999, "Magie": 999, "Venin": 999}
	var before: Dictionary = {}
	for id2: String in data["conquest"]["owned"]:
		before[id2] = CS.city_level(data["conquest"], id2)
	var up: Array = CS.upgrade_all_affordable(data)
	check(up.size() == 4, "riche : les 4 villes montent d'un niveau (%d)" % up.size())
	var one_each := true
	for id3: String in data["conquest"]["owned"]:
		if CS.city_level(data["conquest"], id3) != int(before[id3]) + 1:
			one_each = false
	check(one_each, "un seul niveau par ville et par appui")
	data["gold"] = 0
	check(CS.upgrade_all_affordable(data).is_empty(), "sans or : rien n'est amélioré")
	# ── réparer les ruines
	data["gold"] = CS.RUIN_REPAIR_GOLD
	check(CS.repair_all(data) == ["fort_racine"] and not CS.is_ruined(data["conquest"], "fort_racine") and int(data["gold"]) == 0, "ruines réparées (80 or)")
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
