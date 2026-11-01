extends SceneTree
## Continuer (accueil) ouvre « Mes Parties » quand une partie existe, et non la sélection d'équipe.
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var pm: Node = root.get_node("ProgressionManager")
	root.get_node("GameSettings").tutorial_enabled = false
	pm.write_save(5, pm.new_game(5, "Continuer"))
	var menu: Node = (load("res://scenes/MainMenu.tscn") as PackedScene).instantiate()
	root.add_child(menu)
	await create_timer(0.5).timeout
	var btn: Button = menu.find_child("Continuer", true, false) as Button
	check(btn != null, "bouton Continuer présent")
	btn.pressed.emit()
	await create_timer(0.8).timeout
	var cur: Node = current_scene
	var path: String = cur.scene_file_path if cur != null else ""
	check(path == "res://scenes/SaveSlots.tscn", "Continuer → Mes Parties (%s)" % path)
	pm.delete_save(5)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
