extends SceneTree
## Compteur de tour du combat : limite des défis « rapides » exposée à l'interface.
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
	gm.active_save = {}
	gm.fight_objective = {}
	check(gm.turn_limit() == 0, "sans défi : pas de limite de tours")
	gm.fight_objective = {"kind": "swift"}
	check(gm.turn_limit() == pm.OBJECTIVE_SWIFT_TURNS, "objectif rapide : limite %d" % pm.OBJECTIVE_SWIFT_TURNS)
	gm.fight_objective = {"kind": "flawless"}
	check(gm.turn_limit() == 0, "objectif sans limite de tours")
	gm.fight_objective = {}
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
