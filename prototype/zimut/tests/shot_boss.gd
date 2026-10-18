extends SceneTree
## Capture d'un combat de boss (boss de nation illustré).
## xvfb-run -a -s "-screen 0 1920x1080x24" godot --path . -s tests/shot_boss.gd -- <dossier> [victoires]
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var dir: String = args[0] if args.size() > 0 else "/tmp/shots"
	var vic: int = int(args[1]) if args.size() > 1 else 3
	DirAccess.make_dir_recursive_absolute(dir)
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	root.get_node("GameSettings").tutorial_done = true
	var data: Dictionary = pm.new_game(4, "BossShot")
	data["victories"] = vic
	pm.rebuild_team(data, ["Tank", "Mage", "Heal"])
	gm.active_save = data
	gm.active_slot = 4
	gm.set_custom_team([{"classe": "Tank"}, {"classe": "Mage"}, {"classe": "Heal"}])
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await create_timer(2.0).timeout
	for e: Dictionary in gm.enemies:
		if bool(e.get("boss", false)):
			print("BOSS : ", e["name"], " biome=", gm.fight_biome, " nation_boss=", e.get("nation_boss", ""))
	root.get_viewport().get_texture().get_image().save_png(dir + "/boss_%d.png" % vic)
	pm.delete_save(4)
	quit(0)
