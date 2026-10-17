extends SceneTree
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	var rows: Array = gm.get_enemies_data()
	for b: String in Nations.ORDER:
		if not Nations.is_new(b):
			continue
		var boss: String = pm.biome_boss(b)
		var found: bool = false
		for r: Dictionary in rows:
			if String(r.get("Type", "")) == "Boss " + boss:
				found = true
		check(found, "%s : ligne ennemis.txt « Boss %s »" % [b, boss])
		var sp: Array = Combat.nation_boss_spells(boss, 100)
		check(sp.size() == 1, "%s : sort signature" % boss)
		var pr: Dictionary = Combat.parse(sp[0])
		check(not pr.is_empty(), "%s : sort analysé" % boss)
	for b2: String in Nations.ORDER:
		if not Nations.is_new(b2):
			continue
		gm.fight_biome = b2
		gm.active_save = {}
		var pos := Vector2i(5, 5)
		gm.enemies = []
		gm.grid = []
		for y: int in range(gm.GRID_SIZE):
			var row: Array = []
			row.resize(gm.GRID_SIZE)
			gm.grid.append(row)
		gm._spawn_boss(pos, 30)
		check(gm.enemies.size() == 1 and bool(gm.enemies[0].get("boss", false)), "%s : boss généré en combat" % b2)
		if gm.enemies.size() == 1:
			var e: Dictionary = gm.enemies[0]
			var names: Array = []
			for sp2: Dictionary in e["spells"]:
				names.append(String(sp2.get("name", sp2.get("nom", ""))))
			check(e["spells"].size() >= 3, "%s : kit de sorts (%s)" % [String(e.get("name", "?")), ", ".join(names)])
	quit(1 if fails > 0 else 0)
