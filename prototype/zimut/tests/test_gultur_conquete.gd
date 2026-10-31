extends SceneTree
## V64 : conseils de Gultur sur le brouillard, l'explorateur, le belvédère et les nouveautés de la carte.
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	var gs: Node = root.get_node("GameSettings")
	gs.restart_tutorial()
	var d: Dictionary = pm.new_game(4, "Alix", "f")
	gm.active_save = d
	var tips: Dictionary = {"conq_brouillard": Gultur.CONQ_BROUILLARD, "conq_explorateur": Gultur.CONQ_EXPLORATEUR,
		"conq_v64": Gultur.CONQ_CIBLES_V64, "adv_belvedere": Gultur.ADV_BELVEDERE}
	for id: String in tips.keys():
		var g: Variant = Gultur.say(root, id, tips[id])
		check(g != null, "%s : réplique affichée" % id)
		if g != null:
			var txt: String = " ".join(g._lines)
			check(not txt.contains("{pseudo}") and not txt.contains("{e}"), "%s : marqueurs remplacés" % id)
			g.queue_free()
	check(String(" ".join(Gultur.CONQ_BROUILLARD)).contains("belvédère") and String(" ".join(Gultur.CONQ_BROUILLARD)).contains("explorateur"), "brouillard : explique belvédère et explorateur")
	check(String(" ".join(Gultur.CONQ_EXPLORATEUR)).contains("Cartographie") and String(" ".join(Gultur.CONQ_EXPLORATEUR)).contains("2 villes"), "explorateur : Cartographie, 2 villes")
	check(ConquestSystem.MISSION_TYPES["carte"]["reveal"] == 2 and ConquestSystem.MISSION_BATTLES == 3, "le conseil colle aux règles (2 villes, 3 batailles)")
	# Une fois vue, une réplique ne revient pas.
	gs.mark_tuto_seen("conq_brouillard")
	check(Gultur.say(root, "conq_brouillard", Gultur.CONQ_BROUILLARD) == null, "réplique déjà vue : non répétée")
	gs.skip_tutorial()
	check(Gultur.say(root, "conq_v64", Gultur.CONQ_CIBLES_V64) == null, "conseils désactivés : rien ne s'affiche")
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
