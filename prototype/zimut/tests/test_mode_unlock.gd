extends SceneTree
## V60 : le niveau du JOUEUR (affiché sur la partie) débloque Aventure/Conquête comme celui d'un héros.
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "UnlockTest")
	data["player"] = {"level": 3, "xp": pm.xp_for_level(3)}
	for e: Variant in (data.get("roster", {}) as Dictionary).values():
		if e is Dictionary:
			(e as Dictionary)["level"] = 2
	check(pm.max_hero_level(data) == 2, "héros niveau 2")
	check(pm.mode_unlocked(data, "adventure"), "joueur niveau 3 → Aventure débloquée")
	check(not pm.mode_unlocked(data, "conquest"), "joueur niveau 3 → Conquête encore verrouillée")
	data["player"] = {"level": 5, "xp": pm.xp_for_level(5)}
	check(pm.mode_unlocked(data, "conquest"), "joueur niveau 5 → Conquête débloquée")
	data["player"] = {"level": 2, "xp": 0}
	check(not pm.mode_unlocked(data, "adventure"), "joueur 2 et héros 2 → Aventure verrouillée")
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
