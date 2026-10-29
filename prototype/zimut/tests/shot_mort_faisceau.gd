extends SceneTree
## Capture : faisceau de lumière à la mort. xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_mort_faisceau.gd -- /tmp/shots
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var dir: String = args[0] if args.size() > 0 else "/tmp/shots"
	DirAccess.make_dir_recursive_absolute(dir)
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "Mort")
	pm.rebuild_team(data, ["Tank", "Assassin", "Mage"])
	gm.active_save = data
	gm.active_slot = 4
	gm.set_custom_team([{"classe": "Tank"}, {"classe": "Assassin"}, {"classe": "Mage"}])
	gm.auto_mode = false
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await create_timer(1.5).timeout
	var victim: Dictionary = gm.enemies[0]
	var gridm: Node = main.get_node("GridManager")
	var vv: Node2D = gridm.views[int(victim["uid"])]
	var sp: Vector2 = vv.get_global_transform_with_canvas().origin
	print("VICTIME ", sp)
	victim["current_pv"] = 0
	gm._check_deaths()
	var t: Array = [0.30, 0.42, 0.55, 0.75, 1.0]
	var prev: float = 0.0
	for i: int in range(t.size()):
		await create_timer(float(t[i]) - prev).timeout
		prev = float(t[i])
		root.get_viewport().get_texture().get_image().save_png("%s/mort_%d.png" % [dir, i])
	quit()
