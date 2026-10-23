extends SceneTree
## xvfb-run -a -s "-screen 0 1920x1080x24" godot --rendering-method gl_compatibility --rendering-driver opengl3 --path . -s tests/shot_sheet_v43.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "Fiche")
	pm.rebuild_team(data, ["Mage", "Tank", "Heal"])
	var e: Dictionary = pm.roster_entry(data, "Mage")
	e["level"] = 40
	e["xp"] = pm.xp_for_level(40)
	e["unspent"] = 6
	e["talents"] = {"unlocked": {}, "points": 4}
	Builds.create_build(data, "Mage")
	Builds.create_build(data, "Mage")
	pm.write_save(4, data)
	var ui: CanvasLayer = (load("res://scripts/CharacterSheetUI.gd") as GDScript).new()
	ui.layer = 10
	root.add_child(ui)
	ui.open(data, 4, "Mage")
	for tab in ["stats", "talents", "builds", "spells"]:
		ui._tab = tab
		ui.refresh()
		await create_timer(0.5).timeout
		root.get_viewport().get_texture().get_image().save_png(out + "/sheet_%s.png" % tab)
	pm.delete_save(4)
	quit()
