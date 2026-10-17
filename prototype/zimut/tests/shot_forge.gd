extends SceneTree
## Capture de la Forge (fabrication + Briseur). Usage : ... -s tests/shot_forge.gd -- /tmp/forge
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0] if OS.get_cmdline_user_args().size() > 0 else "/tmp/forge"
	DirAccess.make_dir_recursive_absolute(out)
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "Forge")
	pm.rebuild_team(data, ["Tank", "Mage", "Sylvain", "Heal"])
	data["resources"] = {"Fer": 60, "Bois": 45, "Cuir": 20, "Magie": 14, "Venin": 6}
	data["gold"] = 800
	for _i in range(5):
		for it in pm._roll_loots(30, false):
			data["inventory"].append(it)
	var ui: CanvasLayer = (load("res://scripts/ForgeUI.gd") as GDScript).new()
	root.add_child(ui)
	ui.open(data, 4, 0)
	await create_timer(1.0).timeout
	root.get_viewport().get_texture().get_image().save_png(out + "/forge_craft.png")
	ui._salvage_mode = true
	ui.refresh()
	await create_timer(0.6).timeout
	root.get_viewport().get_texture().get_image().save_png(out + "/forge_salvage.png")
	pm.delete_save(4)
	quit(0)
