extends SceneTree
## Capture : infobulle de sort pendant le ciblage (ne doit pas masquer le plateau).
## xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_spelltip.gd -- <dossier> [mobile] [zone d'aventure]
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var dir: String = args[0] if args.size() > 0 else "/tmp/shots"
	DirAccess.make_dir_recursive_absolute(dir)
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	root.get_node("GameSettings").tutorial_done = true
	var data: Dictionary = pm.new_game(4, "TipShot")
	pm.rebuild_team(data, ["Géomancien", "Tank", "Sylvain"])
	if args.size() > 2:
		data["adventure"] = {"zone": args[2]}
		data["campaign_mode"] = "adventure"
	gm.active_save = data
	gm.active_slot = 4
	gm.set_custom_team([{"classe": "Géomancien"}, {"classe": "Tank"}, {"classe": "Sylvain"}])
	gm.auto_mode = false
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	if args.size() > 1 and args[1] == "mobile":
		main.get_node("UIManager").set_meta("force_mobile", true)
	root.add_child(main)
	await create_timer(1.5).timeout
	var ui: Node = main.get_node("UIManager")
	var geo: Dictionary = {}
	for p: Dictionary in gm.players:
		if String(p["classe"]) == "Géomancien":
			geo = p
	var spell: Dictionary = geo["spells"][1] if geo["spells"].size() > 1 else geo["spells"][0]
	for s: Dictionary in geo["spells"]:
		if String(s["name"]).contains("Pilier"):
			spell = s
	for s2: Dictionary in geo["spells"]:
		s2["spell_level"] = 3
		s2["mult"] = 1.12
	gm.active_entity = geo
	gm.selected_spell = spell
	gm.spell_selected.emit(spell)
	await create_timer(0.6).timeout
	root.get_viewport().get_texture().get_image().save_png(dir + "/spelltip%s%s.png" % ["_mobile" if args.size() > 1 else "", "_" + args[2] if args.size() > 2 else ""])
	pm.delete_save(4)
	quit(0)
