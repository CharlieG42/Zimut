extends SceneTree
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var pm: Node = root.get_node("ProgressionManager")
	root.get_node("GameSettings").skip_tutorial()
	var d: Dictionary = pm.new_game(4, "Alix", "f")
	HeroUnlock.pick_initial(d, ["Tank", "Mage", "Heal"])
	pm.write_save(4, d)
	var sc: Node = (load("res://scenes/SaveSlots.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(0.6).timeout
	for n: Node in sc.find_children("*", "BaseButton", true, false):
		for l: Node in n.find_children("*", "Label", true, false):
			if (l as Label).text.contains("genre"):
				(n as BaseButton).pressed.emit()
	await create_timer(0.4).timeout
	root.get_viewport().get_texture().get_image().save_png(out + "/rename.png")
	pm.delete_save(4)
	quit()
