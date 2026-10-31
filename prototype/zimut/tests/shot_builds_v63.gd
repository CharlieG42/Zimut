extends SceneTree
## Capture V63 : sélecteur de sorts actifs (ancien build cassé réparé, puis un sort retiré au toucher).
##   xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_builds_v63.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var pm: Node = root.get_node("ProgressionManager")
	root.get_node("GameSettings").tutorial_enabled = false
	var data: Dictionary = pm.new_game(4, "Fiche")
	pm.rebuild_team(data, ["Artificier", "Druide", "Géomancien"])
	data["heroes_unlocked"] = ["Artificier", "Druide", "Géomancien", "Chasseur"]
	var e: Dictionary = pm.roster_entry(data, "Artificier")
	e["level"] = 7
	e["xp"] = pm.xp_for_level(7)
	e["builds"] = [{"name": "Build 1", "equipment": {}, "spells": ["Rappel", "Couplage"], "talents": {"unlocked": {}, "points": 0}}]
	e["build_index"] = 0
	e.erase("spells_ok")
	pm.write_save(4, data)
	data = pm.load_save(4)
	root.get_node("GameManager").active_save = data
	root.get_node("GameManager").active_slot = 4
	print("après chargement : ", Builds.active_spells(data, "Artificier"))
	var ui: CanvasLayer = (load("res://scripts/CharacterSheetUI.gd") as GDScript).new()
	ui.layer = 10
	root.add_child(ui)
	ui.open(data, 4, "Artificier")
	ui._tab = "builds"
	ui.refresh()
	ui._open_spell_picker()
	await create_timer(0.6).timeout
	root.get_viewport().get_texture().get_image().save_png(out + "/picker_repare.png")
	var b: Button = ui.find_child("Pick_Fumigène", true, false) as Button
	for nn: Node in ui.find_children("Pick*", "", true, false):
		print("  noeud : ", nn.name)
	if b != null:
		b.pressed.emit()
	await create_timer(0.4).timeout
	root.get_viewport().get_texture().get_image().save_png(out + "/picker_toggle.png")
	print("après toucher Fumigène : ", Builds.active_spells(data, "Artificier"))
	pm.delete_save(4)
	quit()
