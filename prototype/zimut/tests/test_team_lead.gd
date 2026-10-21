extends SceneTree
## Choix du héros « Explorateur » depuis la sélection d'équipe.
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
	root.get_node("GameSettings").tutorial_done = true
	var data: Dictionary = pm.new_game(4, "Lead")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	gm.active_save = data
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/TeamSelection.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(0.6).timeout
	check(sc.lead_class() == "Chasseur", "par défaut : premier héros (%s)" % sc.lead_class())
	sc.current = sc.classes.find("Mage")
	sc._on_lead()
	check(sc.lead_class() == "Mage", "★ passe au Mage")
	check(String(pm.adventure_state(data)["hero_class"]) == "Mage", "mémorisé dans la partie")
	check(pm.load_save(4)["adventure"]["hero_class"] == "Mage", "écrit en sauvegarde")
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
