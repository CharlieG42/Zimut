extends SceneTree
## Captures en anglais : xvfb-run ... -s tests/shot_lang.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0] if OS.get_cmdline_user_args().size() > 0 else "/tmp/lang"
	DirAccess.make_dir_recursive_absolute(out)
	var gs: Node = root.get_node("GameSettings")
	gs.language = "en"
	root.get_node("Loc").apply()
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "English")
	pm.rebuild_team(data, ["Tank", "Mage", "Heal"])
	pm.write_save(4, data)
	root.get_node("GameManager").active_save = data
	root.get_node("GameManager").active_slot = 4
	for sc in ["MainMenu", "SaveSlots", "Settings", "TeamSelection"]:
		var n: Node = (load("res://scenes/%s.tscn" % sc) as PackedScene).instantiate()
		root.add_child(n)
		await create_timer(0.8).timeout
		root.get_viewport().get_texture().get_image().save_png("%s/%s.png" % [out, sc])
		n.queue_free()
		await create_timer(0.2).timeout
	for ui_name in ["CharacterSheetUI", "ForgeUI"]:
		var ui: CanvasLayer = (load("res://scripts/%s.gd" % ui_name) as GDScript).new()
		root.add_child(ui)
		if ui_name == "ForgeUI":
			ui.open(data, 4, 0)
		else:
			ui.open(data, 4, "Mage")
		await create_timer(0.8).timeout
		root.get_viewport().get_texture().get_image().save_png("%s/%s.png" % [out, ui_name])
		ui.queue_free()
	gs.language = "fr"
	pm.delete_save(4)
	quit(0)
