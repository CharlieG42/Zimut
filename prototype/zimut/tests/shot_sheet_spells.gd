extends SceneTree
## xvfb-run -a -s "-screen 0 1920x1080x24" godot --rendering-method gl_compatibility --rendering-driver opengl3 --path . -s tests/shot_sheet_spells.gd -- <dossier>
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
	e["unspent"] = ClassRules.total_points_for_level(40)
	e["invested"] = {}
	pm.auto_points(data, "Mage")
	e["spell_levels"] = {"Boule de feu": 5, "Éclair": 3}
	pm.write_save(4, data)
	var ui: CanvasLayer = (load("res://scripts/CharacterSheetUI.gd") as GDScript).new()
	ui.layer = 10
	root.add_child(ui)
	ui.open(data, 4, "Mage")
	ui._tab = "spells"
	ui.refresh()
	await create_timer(0.6).timeout
	root.get_viewport().get_texture().get_image().save_png(out + "/sheet_spells.png")
	ui._tab = "stats"
	ui.refresh()
	await create_timer(0.4).timeout
	root.get_viewport().get_texture().get_image().save_png(out + "/sheet_stats.png")
	pm.delete_save(4)
	quit()
