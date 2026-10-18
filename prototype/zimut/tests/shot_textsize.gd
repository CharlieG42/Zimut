extends SceneTree
## Captures avec un réglage « Taille du texte » donné :
##   xvfb-run -a -s "-screen 0 1920x1080x24" godot --path . -s tests/shot_textsize.gd -- <0|1|2> <dossier>
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var ts: int = int(args[0]) if args.size() > 0 else 1
	var out: String = args[1] if args.size() > 1 else "/tmp/ts"
	DirAccess.make_dir_recursive_absolute(out)
	var gs: Node = root.get_node("GameSettings")
	gs.text_size = ts
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "Taille %d" % ts)
	pm.rebuild_team(data, ["Tank", "Mage", "Heal"])
	pm.write_save(4, data)
	for sc in ["SaveSlots", "Settings"]:
		var n: Node = (load("res://scenes/%s.tscn" % sc) as PackedScene).instantiate()
		root.add_child(n)
		await create_timer(0.8).timeout
		root.get_viewport().get_texture().get_image().save_png("%s/%s_%d.png" % [out, sc, ts])
		n.queue_free()
		await create_timer(0.2).timeout
	var sheet: CanvasLayer = (load("res://scripts/CharacterSheetUI.gd") as GDScript).new()
	root.add_child(sheet)
	sheet.open(data, 4, "Mage")
	await create_timer(0.8).timeout
	root.get_viewport().get_texture().get_image().save_png("%s/sheet_%d.png" % [out, ts])
	sheet.queue_free()
	var forge: CanvasLayer = (load("res://scripts/ForgeUI.gd") as GDScript).new()
	root.add_child(forge)
	forge.open(data, 4, 0)
	await create_timer(0.8).timeout
	root.get_viewport().get_texture().get_image().save_png("%s/forge_%d.png" % [out, ts])
	pm.delete_save(4)
	quit(0)
