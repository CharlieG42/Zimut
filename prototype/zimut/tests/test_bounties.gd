extends SceneTree
## V28 : primes du jour (génération stable, progression, crédit, coffre bonus).
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
	var data: Dictionary = pm.new_game(7, "Primes")
	pm.rebuild_team(data, ["Tank", "Mage", "Heal"])
	pm.ensure_roster(data)
	var l1: Array = Bounties.ensure(data)
	check(l1.size() == 3, "3 primes")
	var titles: Array = []
	for b: Dictionary in l1:
		titles.append(String(b["title"]))
	check(Bounties.ensure(data) == l1, "stables dans la journée")
	var kinds: Array = []
	for b2: Dictionary in l1:
		check(not kinds.has(b2["kind"]), "genre unique : " + String(b2["kind"]))
		kinds.append(b2["kind"])
	print("   primes : ", titles)
	# On force trois primes connues pour tester la progression
	data["bounties"]["list"] = [
		{"id": 0, "kind": "kill_type", "param": "Gobelin", "target": 3, "progress": 0, "done": false, "title": "Vaincre 3 gobelins", "reward": {"gold": 100, "res": {"Bois": 5}}},
		{"id": 1, "kind": "wins", "param": "", "target": 2, "progress": 0, "done": false, "title": "Gagner 2 combats", "reward": {"gold": 100, "res": {}}},
		{"id": 2, "kind": "flawless", "param": "", "target": 1, "progress": 0, "done": false, "title": "Sans K.O.", "reward": {"gold": 100, "res": {}}},
	]
	var gold0: int = int(data.get("gold", 0))
	var info: Dictionary = {"enemies": [{"type": "Gobelin"}, {"type": "Gobelin"}, {"type": "Loup"}], "turns": 6, "deaths": 1, "boss": false, "biome": "Forêt"}
	var f1: Array = Bounties.on_victory(data, info)
	check(f1.is_empty(), "rien de terminé au 1er combat")
	check(int(data["bounties"]["list"][0]["progress"]) == 2, "2 gobelins comptés")
	info["deaths"] = 0
	var f2: Array = Bounties.on_victory(data, info)
	check(f2.size() == 4, "3 primes + coffre au 2e combat (%d)" % f2.size())
	check(Bounties.done_count(data) == 3, "3 / 3")
	check(int(data["gold"]) > gold0 + 300, "or crédité (primes + coffre)")
	check(int(data["resources"].get("Bois", 0)) >= 5, "ressources créditées")
	check(int(data["bounties"]["streak"]) == 1, "série de 1 jour")
	check(Bounties.on_victory(data, info).is_empty(), "pas de double crédit")
	# Branché sur register_victory
	data["bounties"] = {}
	pm.register_victory(data, {"enemies": [{"type": "Gobelin", "level": 1, "boss": false}], "turns": 3, "deaths": 0, "boss": false, "biome": "Forêt"})
	check(not (data.get("bounties", {}).get("list", []) as Array).is_empty(), "primes générées à la victoire")
	pm.delete_save(7)
	print("ÉCHECS : ", fails)
	quit(0 if fails == 0 else 1)
