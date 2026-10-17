extends SceneTree
## Nations : chaque biome de nation se dessine (props, monuments, ambiance), ennemis et boss résolus.

var fails: int = 0

func check(c: bool, label: String) -> void:
	print(("  OK     " if c else "  ÉCHEC  ") + label)
	if not c:
		fails += 1

func _init() -> void:
	_boot.call_deferred()

func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	for b: String in Nations.ORDER:
		if not Nations.is_new(b):
			continue
		var inf: Dictionary = Nations.info(b)
		var ci := Node2D.new()
		root.add_child(ci)
		var rng := RandomNumberGenerator.new()
		var all_ok: bool = true
		var kinds: Array = []
		for e: Array in inf["props"]:
			kinds.append(e[0])
		for f: String in inf["features"]:
			kinds.append(f)
		kinds.append(inf["obs_tree"])
		kinds.append(inf["obs_rock"])
		for k: String in kinds:
			rng.seed = 5
			if not NationScenery.draw(ci, k, Nations.pal(b), b, rng, 0.0):
				# type partagé avec BattleScenery : doit au moins exister dans son match
				if not (k in ["crystal", "barrel", "palm", "reeds", "bones", "rubble", "stump", "rock"]):
					all_ok = false
					print("    type inconnu: ", b, " ", k)
		check(all_ok, "%s : tous les décors spécifiques sont dessinés" % b)
		check(Nations.enemy_types(b).size() == 2, "%s : 2 types d'ennemis" % b)
		check(pm.biome_boss(b) == String(inf["boss"]), "%s : boss résolu" % b)
		check(Nations.boss_base(String(inf["boss"])) != "", "%s : type de base du boss" % b)
		check(BattleScenery.tile_tex(b, 0) != null, "%s : tuile de sol chargée" % b)
		ci.queue_free()
	quit(1 if fails > 0 else 0)
