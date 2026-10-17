extends SceneTree
## Capture d'un combat avec un Géomancien qui pose piliers, muraille, faille et cristal.
## xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_geomancien.gd -- /tmp/shots
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var dir: String = args[0] if args.size() > 0 else "/tmp/shots"
	DirAccess.make_dir_recursive_absolute(dir)
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "GeoShot")
	pm.rebuild_team(data, ["Géomancien", "Invocateur", "Sylvain"])
	gm.active_save = data
	gm.active_slot = 4
	gm.set_custom_team([{"classe": "Géomancien"}, {"classe": "Invocateur"}, {"classe": "Sylvain"}])
	gm.auto_mode = false
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await create_timer(1.5).timeout
	var geo: Dictionary = {}
	for p: Dictionary in gm.players:
		if String(p["classe"]) == "Géomancien":
			geo = p
	geo["spells"] = gm._build_spells("Géomancien", 50)
	geo["current_pa"] = 30
	var gp: Vector2i = gm.pos_of(geo)
	var done: Array[String] = []
	for nm: String in ["Invoquer Pilier", "Invoquer Muraille", "Invoquer Faille", "Invoquer Cristal ambré"]:
		var spell: Dictionary = {}
		for s: Dictionary in geo["spells"]:
			if String(s["name"]) == nm:
				spell = s
		var placed: bool = false
		for r: int in range(2, 5):
			for d: Vector2i in [Vector2i(r, 0), Vector2i(0, r), Vector2i(-r, 0), Vector2i(0, -r), Vector2i(r - 1, 1), Vector2i(1, r - 1)]:
				if not placed and gm.validate_cast(geo, spell, gp + d) == "":
					placed = gm.cast_spell(geo, spell, gp + d)
		done.append("%s=%s" % [nm, str(placed)])
		await create_timer(0.8).timeout
	print(done)
	await create_timer(1.0).timeout
	root.get_viewport().get_texture().get_image().save_png(dir + "/geo_battle.png")
	pm.delete_save(4)
	quit(0)
