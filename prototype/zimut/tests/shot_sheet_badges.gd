extends SceneTree
## xvfb-run -a -s "-screen 0 1920x1080x24" godot --rendering-method gl_compatibility --path . -s tests/shot_sheet_badges.gd -- <dossier>
var fails: int = 0
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "Fiche")
	HeroUnlock.pick_initial(data, ["Chasseur", "Druide", "Artificier"])
	pm.rebuild_team(data, ["Chasseur", "Druide", "Artificier"])
	var e: Dictionary = pm.roster_entry(data, "Chasseur")
	e["level"] = 20
	e["xp"] = pm.xp_for_level(20)
	e["unspent"] = 6
	e["talents"] = {"unlocked": {}, "points": 2}
	var e2: Dictionary = pm.roster_entry(data, "Druide")
	e2["level"] = 3
	e2["unspent"] = 0
	var ui: CanvasLayer = (load("res://scripts/CharacterSheetUI.gd") as GDScript).new()
	ui.layer = 10
	root.add_child(ui)
	ui.open(data, 4, "Chasseur")
	await create_timer(0.6).timeout
	var n: int = 0
	for c: Node in ui._tabs_row.get_children():
		if c.get_node_or_null("Badge") != null:
			n += 1
	print("onglets avec pastille : ", n)
	if n < 3:
		fails += 1
	root.get_viewport().get_texture().get_image().save_png(out + "/sheet_badges.png")
	quit(1 if fails > 0 else 0)
