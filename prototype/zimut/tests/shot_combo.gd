extends SceneTree
## Capture V32 : 4 instants d'animations d'attaque et d'incantation (variantes / enchaînements).
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var dir: String = OS.get_cmdline_user_args()[0] if OS.get_cmdline_user_args().size() > 0 else "/tmp/shots"
	var gm: Node = root.get_node("GameManager")
	gm.set_custom_team([{"classe": "Assassin"}, {"classe": "Druide"}, {"classe": "Artificier"}])
	gm.auto_mode = false
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await create_timer(1.5).timeout
	var views: Array = root.find_children("*", "Node2D", true, false).filter(func(n): return n is EntityView and String(n.entity.get("team", "")) == "player")
	for k in range(4):
		for v in views:
			if k % 2 == 0:
				v.play_pose("attack", 0.9)
			else:
				v.play_pose("cast", 0.9)
		await create_timer(0.15).timeout
		root.get_viewport().get_texture().get_image().save_png(dir + "/combo_%d.png" % k)
		await create_timer(0.9).timeout
	for v in views:
		print(v.entity["classe"], " poses=", v._poses.keys(), " attaques=", (v._poses.get("attack", []) as Array).size())
	quit(0)
