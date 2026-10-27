extends SceneTree
## Lance un vrai combat (mode Auto) et enregistre des captures d'écran.
## Usage (écran virtuel) : xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_battle.gd -- /tmp/shots 5
var shots_dir: String = "/tmp/shots"
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	if args.size() > 0:
		shots_dir = args[0]
	var count: int = int(args[1]) if args.size() > 1 else 6
	var boss: bool = args.size() > 2 and args[2] == "boss"
	DirAccess.make_dir_recursive_absolute(shots_dir)
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "Shots")
	pm.rebuild_team(data, ["Tank", "Mage", "Sylvain"])
	if args.size() > 3:
		data["victories"] = int(args[3])
	elif boss:
		data["victories"] = 3
	for _i in range(6):
		for it in pm._roll_loots(12, false):
			data["inventory"].append(it)
	pm.auto_equip(data)
	gm.active_save = data
	gm.active_slot = 4
	gm.set_custom_team([{"classe": "Tank"}, {"classe": "Mage"}, {"classe": "Sylvain"}])
	gm.auto_mode = false
	gm.fight_biome = "Montagne"
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await create_timer(1.5).timeout
	for i: int in range(count):
		await create_timer(1.5).timeout
		var img: Image = root.get_viewport().get_texture().get_image()
		img.save_png("%s/shot_%02d.png" % [shots_dir, i])
		print("capture ", i, " tour ", gm.turn_count)
	pm.delete_save(4)
	quit(0)
