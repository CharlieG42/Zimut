extends SceneTree
## Un héros gouverneur n'est plus proposé pour les assauts de Conquête.
## xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/test_conquest_team.gd
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
	var d: Dictionary = pm.new_game(4, "TeamGov")
	pm.rebuild_team(d, ["Tank", "Mage", "Heal"])
	d["campaign_mode"] = "conquest"
	d["conquest"] = {"owned": ["capitale", "clairiere"], "garrisons": {"clairiere": {"troops": 0, "hero": "Tank"}}}
	gm.active_save = d
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/TeamSelection.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(0.6).timeout
	check(not sc.team.has("Tank"), "le gouverneur est retiré de l'équipe restaurée")
	check(sc.team.has("Mage") and sc.team.has("Heal"), "les autres héros restent")
	sc.current = sc.classes.find("Tank")
	sc._on_action()
	check(not sc.team.has("Tank"), "impossible d'ajouter le gouverneur à l'équipe")
	d["campaign_mode"] = "adventure"
	check(pm.conquest_stationed_heroes(d).is_empty(), "hors Conquête, aucun héros n'est bloqué")
	pm.delete_save(4)
	print("== %s ==" % ("TOUT OK" if fails == 0 else "%d échec(s)" % fails))
	quit(1 if fails > 0 else 0)
