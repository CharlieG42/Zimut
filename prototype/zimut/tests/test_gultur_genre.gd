extends SceneTree
## V63 : genre du joueur → accords des répliques de Gultur ; LVL3 félicite le joueur.
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
	check(String(d["gender"]) == "f", "genre femme enregistré")
	gm.active_save = d
	var g: Variant = Gultur.say(root, "intro", Gultur.INTRO)
	var txt: String = " ".join(g._lines)
	check(txt.contains("venue") and txt.contains("prête ?"), "texte accordé au féminin")
	check(not txt.contains("{e}"), "plus de marqueur {e}")
	g.queue_free()
	var d2: Dictionary = pm.new_game(4, "Alex", "m")
	gm.active_save = d2
	var g2: Variant = Gultur.say(root, "intro", Gultur.INTRO)
	var t2: String = " ".join(g2._lines)
	check(t2.contains("venu ") and t2.contains("prêt ?"), "texte au masculin")
	g2.queue_free()
	check(not String(Gultur.LVL3[0]).contains("héros a atteint") and String(Gultur.LVL3[0]).contains("{pseudo}"), "niveau 3 : on félicite le joueur")
	pm.new_game(4, "Alix", "m")
	check(pm.set_gender(4, "f") and String(pm.load_save(4)["gender"]) == "f", "set_gender → femme")
	pm.set_gender(4, "x")
	check(String(pm.load_save(4)["gender"]) == "m", "valeur invalide → homme")
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
