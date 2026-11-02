extends SceneTree
## Audit : quels sorts ne gagnent RIEN quand leur niveau monte (1 → 10) ?
##   godot --headless -s tests/audit_spell_scaling.gd
func _init() -> void:
	_boot.call_deferred()
func _sig(p: Dictionary) -> String:
	var keys: Array = p.keys()
	keys.sort()
	var out: String = ""
	for k in keys:
		if String(k).begins_with("_"):
			continue
		out += "%s=%s;" % [k, str(p[k])]
	return out
func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var bad: Dictionary = {}
	var total: int = 0
	for classe: String in pm.class_names():
		for row: Dictionary in pm.spells_of(classe):
			total += 1
			var mk := func(mult: float, lvl: int) -> Dictionary:
				return {"name": row["name"], "classe": classe, "cost_pa": int(row["pa"]), "cost_pm": int(row["pm"]),
					"range": int(row["range"]), "effect": String(row["effect"]), "level_required": int(row["level"]),
					"spell_type": String(row["type"]), "Degats_physiques": int(row["phys"]),
					"Degats_magiques": int(row["mag"]), "Soins": int(row["heal"]), "mult": mult, "spell_level": lvl}
			var p1: Dictionary = Combat.parse(mk.call(1.0, 1))
			var p2: Dictionary = Combat.parse(mk.call(1.54, 10))
			if _sig(p1) == _sig(p2):
				var k: String = String(p1["kind"])
				if not bad.has(classe):
					bad[classe] = []
				bad[classe].append("%s [%s/%s]" % [row["name"], row["type"], k])
	print("== %d sorts audités ==" % total)
	for c in bad.keys():
		print("-- %s (%d)" % [c, bad[c].size()])
		for s in bad[c]:
			print("   ", s)
	quit(0)
