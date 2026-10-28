extends SceneTree
## Capture : Artificier dans le biome Rouages (bombe, tourelle, mine, glyphe, inversion).
## xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_artificier.gd -- /tmp/shots
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var dir: String = args[0] if args.size() > 0 else "/tmp/shots"
	DirAccess.make_dir_recursive_absolute(dir)
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "ArtShot")
	pm.rebuild_team(data, ["Artificier", "Tank", "Mage"])
	data["adventure"] = {"zone": "rouages_atelier"}
	gm.active_save = data
	gm.active_slot = 4
	data["campaign_mode"] = "adventure"
	gm.set_custom_team([{"classe": "Artificier"}, {"classe": "Tank"}, {"classe": "Mage"}])
	gm.auto_mode = false
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await create_timer(1.5).timeout
	print("biome = ", gm.fight_biome)
	var art: Dictionary = {}
	for p: Dictionary in gm.players:
		if String(p["classe"]) == "Artificier":
			art = p
	art["spells"] = gm._build_spells("Artificier", 70)
	art["current_pa"] = 40
	art["level"] = 70
	var gp: Vector2i = gm.pos_of(art)
	var seq: Array = ["Poser Bombe", "Poser Bombe incendiaire", "Poser Tourelle lourde", "Poser Bombe assourdissante", "Poser Charge à fragmentation", "Poser Mine"]
	var done: Array[String] = []
	for nm: String in seq:
		var spell: Dictionary = {}
		for s: Dictionary in art["spells"]:
			if String(s["name"]) == nm:
				spell = s
		art["casts"] = {}
		var placed: bool = false
		gp = gm.pos_of(art)
		for r: int in range(2, 6):
			for d: Vector2i in [Vector2i(r, 0), Vector2i(0, r), Vector2i(-r, 0), Vector2i(0, -r), Vector2i(r - 1, 1), Vector2i(1, r - 1), Vector2i(-1, -(r - 1))]:
				if not placed and gm.validate_cast(art, spell, gp + d) == "":
					placed = gm.cast_spell(art, spell, gp + d)
		done.append("%s=%s" % [nm, str(placed)])
		await create_timer(0.9).timeout
	print(done)
	await create_timer(1.0).timeout
	root.get_viewport().get_texture().get_image().save_png(dir + "/art_battle.png")
	pm.delete_save(4)
	quit(0)
