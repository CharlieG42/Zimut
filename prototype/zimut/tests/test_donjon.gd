extends SceneTree

## Tests du donjon : cycle 16 combats (3 biomes x 4 + 4 salles de donjon),
## chaque salle de donjon est un combat de boss, la 4e a le big boss.

var fails: int = 0

func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1

func _init() -> void:
	_boot.call_deferred()

func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	# Cycle : 12 combats de biomes puis 4 salles de donjon
	var expected: Array = []
	for i: int in range(3):
		for j: int in range(4):
			expected.append(["Forêt", "Montagne", "Désert"][i])
	expected.append_array(["Forêt", "Montagne", "Désert", "Donjon"])
	var ok_cycle: bool = true
	for n: int in range(1, 17):
		if pm.biome_for_fight(n) != expected[n - 1]:
			ok_cycle = false
			print("   combat ", n, " : ", pm.biome_for_fight(n), " attendu ", expected[n - 1])
	check(ok_cycle, "cycle 16 combats : 3 biomes puis 4 salles de donjon")
	check(pm.biome_for_fight(17) == "Forêt", "le cycle recommence en forêt au combat 17")
	# Salles de donjon : boss partout, big boss en salle 4
	check(pm.donjon_room(13) == "Forêt" and pm.donjon_room(14) == "Montagne" and pm.donjon_room(15) == "Désert" and pm.donjon_room(16) == "Donjon", "salles du donjon : Forêt, Montagne, Désert, Donjon")
	check(pm.donjon_room(5) == "", "hors donjon : pas de salle")
	var data: Dictionary = pm.new_game(4, "Donjon")
	# simulation des victoires jusqu'à la salle du donjon
	for i: int in range(12):
		pm.register_victory(data, {"enemies": [{"type": "Gobelin", "level": 10, "boss": false}]})
	data["selected_fight"] = 0
	var n13: int = pm.next_fight_number(data)
	check(n13 == 13, "après 12 victoires, combat 13 (1re salle du donjon)")
	check(pm.donjon_room(n13) == "Forêt", "combat 13 = salle Forêt du donjon")
	check(pm.is_boss_fight(data), "1re salle du donjon : combat de boss")
	check(pm.donjon_boss(data) == "Gobelin Roi", "salle Forêt : boss Gobelin Roi")
	# salle finale
	for i: int in range(3):
		pm.register_victory(data, {"enemies": [{"type": "Gobelin", "level": 10, "boss": false}]})
	check(pm.donjon_room(pm.next_fight_number(data)) == "Donjon", "combat 16 = salle finale du donjon")
	check(pm.donjon_boss(data) == "Roi Squelette", "salle finale : big boss Roi Squelette")
	check(pm.is_boss_fight(data), "salle finale : combat de boss")
	print("== TOUS OK ==" if fails == 0 else "== %d ÉCHECS ==" % fails)
	quit(0 if fails == 0 else 1)
