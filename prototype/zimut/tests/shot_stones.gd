extends SceneTree
## Capture : vitrine des Pierres Élémentaires (V27).
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var dir: String = args[0] if args.size() > 0 else "/tmp/shots"
	DirAccess.make_dir_recursive_absolute(dir)
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "StoneShot")
	pm.rebuild_team(data, ["Artificier", "Tank", "Mage"])
	pm.ensure_roster(data)
	for b: String in ["Forêt", "Cristaux", "Rouages", "Vents"]:
		Stones.grant(data, b)
	Stones.equip(data, "Cristaux", "Mage")
	Stones.equip(data, "Rouages", "Artificier")
	data["gold"] = 5000
	data["resources"] = {"Magie": 50, "Bois": 3}
	Stones.awaken(data, "Cristaux")
	var ui: CanvasLayer = (load("res://scripts/StonesUI.gd") as GDScript).new()
	root.add_child(ui)
	ui.open(data, -1)
	await create_timer(1.2).timeout
	root.get_viewport().get_texture().get_image().save_png(dir + "/stones.png")
	pm.delete_save(4)
	quit(0)
