extends SceneTree
## 10 sorts doivent tenir dans la barre de sorts sans défilement (PC et mobile).
## Lancement : godot --headless --path . -s tests/test_barre_sorts_10.gd
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
	var data: Dictionary = pm.new_game(4, "Barre10")
	pm.rebuild_team(data, ["Tank", "Mage", "Sylvain"])
	gm.active_save = data
	gm.active_slot = 4
	gm.set_custom_team([{"classe": "Tank"}, {"classe": "Mage"}, {"classe": "Sylvain"}])
	gm.auto_mode = false
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await create_timer(1.0).timeout
	var ui: CanvasLayer = main.get_node("UIManager")
	for sc: float in [1.0, 1.25]:
		ui._spell_scale = sc
		var h: float = ui._badge_height(10)
		var sep: float = 6.0 * sc
		var avail: float = ui._root.size.y - 244.0 - 20.0
		check(10.0 * h + 9.0 * sep <= avail + 0.5, "échelle %.2f : 10 badges (h=%.1f) tiennent dans %.0f px" % [sc, h, avail])
		check(h >= 44.0, "échelle %.2f : badge lisible (h=%.1f ≥ 44)" % [sc, h])
	ui._spell_scale = 1.0
	check(is_equal_approx(ui._badge_height(3), 62.0), "peu de sorts : hauteur d'origine conservée")
	pm.delete_save(4)
	print("ÉCHECS : ", fails)
	quit(0 if fails == 0 else 1)
