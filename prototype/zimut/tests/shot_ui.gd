extends SceneTree
## Captures d'écran des interfaces (écran virtuel) :
##   xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_ui.gd -- sheet /tmp/ui
## modes : sheet | spells | forge | equip | team | result
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var mode: String = args[0] if args.size() > 0 else "sheet"
	var out_dir: String = args[1] if args.size() > 1 else "/tmp/ui"
	var arg3: String = args[2] if args.size() > 2 else ""
	DirAccess.make_dir_recursive_absolute(out_dir)
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	var data: Dictionary = pm.new_game(4, "Capture")
	pm.rebuild_team(data, ["Tank", "Mage", "Sylvain"])
	for c in ["Tank", "Mage", "Sylvain"]:
		var e: Dictionary = pm.roster_entry(data, c)
		e["level"] = 24
		e["xp"] = pm.xp_for_level(24) + 800
		e["invested"] = {}
		e["unspent"] = 6
		e["auto"] = false
	data["victories"] = 11
	data["level"] = 24
	for _i in range(5):
		for it in pm._roll_loots(22, _i == 2):
			data["inventory"].append(it)
	pm.auto_equip(data)
	data["gold"] = 1240
	data["resources"] = {"Fer": 14, "Bois": 9, "Cuir": 6, "Magie": 12, "Venin": 3}
	gm.active_save = data
	gm.active_slot = 4
	var ui: Node = null
	if mode == "sheet" or mode == "spells":
		ui = (load("res://scripts/CharacterSheetUI.gd") as GDScript).new()
		root.add_child(ui)
		ui.open(data, 4, arg3 if arg3 != "" else "Mage")
		if mode == "spells":
			ui._tab = "spells"
			ui.refresh()
	elif mode == "forge" or mode == "equip":
		ui = (load("res://scripts/TeamEquipmentUI.gd") as GDScript).new()
		root.add_child(ui)
		ui.open(data, 4)
		if mode == "forge":
			ui._open_forge()
	elif mode == "team":
		ui = (load("res://scenes/TeamSelection.tscn") as PackedScene).instantiate()
		root.add_child(ui)
	elif mode == "result":
		pass
	await create_timer(1.0).timeout
	var img: Image = root.get_viewport().get_texture().get_image()
	img.save_png("%s/%s.png" % [out_dir, mode])
	print("capture ", mode)
	pm.delete_save(4)
	quit(0)
