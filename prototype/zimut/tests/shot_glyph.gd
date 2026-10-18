extends SceneTree
## Capture : glyphes posés par le Géomancien, le Chasseur et l'Assassin.
## xvfb-run -a -s "-screen 0 1920x1080x24" godot --path . -s tests/shot_glyph.gd -- /tmp/shots
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var dir: String = args[0] if args.size() > 0 else "/tmp/shots"
	DirAccess.make_dir_recursive_absolute(dir)
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "GlyphShot")
	pm.rebuild_team(data, ["Géomancien", "Chasseur", "Assassin"])
	gm.active_save = data
	gm.active_slot = 4
	gm.set_custom_team([{"classe": "Géomancien"}, {"classe": "Chasseur"}, {"classe": "Assassin"}])
	gm.auto_mode = false
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await create_timer(1.5).timeout
	var foes: Array = gm.enemies.duplicate()
	var plan: Dictionary = {"Géomancien": "Glyphe sismique", "Chasseur": "Glyphe de flammes", "Assassin": "Glyphe de venin"}
	var i: int = 0
	for p: Dictionary in gm.players:
		var cl: String = String(p["classe"])
		p["spells"] = gm._build_spells(cl, 100)
		p["current_pa"] = 30
		var spell: Dictionary = {}
		for s: Dictionary in p["spells"]:
			if String(s["name"]) == String(plan[cl]):
				spell = s
		var foe: Dictionary = foes[i % foes.size()]
		var placed: bool = false
		for r: int in range(0, 6):
			for dx: int in range(-r, r + 1):
				for dy: int in [-(r - absi(dx)), r - absi(dx)]:
					if not placed:
						placed = gm.validate_cast(p, spell, gm.pos_of(foe) + Vector2i(dx, dy)) == "" and gm.cast_spell(p, spell, gm.pos_of(foe) + Vector2i(dx, dy))
		print(cl, " ", plan[cl], " ", placed)
		i += 1
		await create_timer(1.0).timeout
	await create_timer(1.0).timeout
	root.get_viewport().get_texture().get_image().save_png(dir + "/glyphs.png")
	pm.delete_save(4)
	quit(0)
