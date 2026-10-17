extends SceneTree
## Capture : combat avec familiers (Invocateur + Sylvain) sur les nouveaux sprites.
## Usage : xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_familiers.gd -- /tmp/fam.png
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0] if OS.get_cmdline_user_args().size() > 0 else "/tmp/fam.png"
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "Fam")
	pm.rebuild_team(data, ["Invocateur", "Sylvain", "Tank"])
	for c in ["Invocateur", "Sylvain", "Tank"]:
		pm.roster_entry(data, c)["level"] = 100
	gm.active_save = data
	gm.active_slot = 4
	gm.set_custom_team([{"classe": "Invocateur"}, {"classe": "Sylvain"}, {"classe": "Tank"}])
	gm.auto_mode = false
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await create_timer(1.5).timeout
	for p: Dictionary in gm.players:
		var names: Array = []
		if p["classe"] == "Invocateur":
			names = ["Invoquer Golem de Pierre", "Invoquer Loup Spectral", "Invoquer Requin des Marées"]
		elif p["classe"] == "Sylvain":
			names = ["Invoquer Archer Sylvestre", "Invoquer Ent de Combat"]
		var pos: Vector2i = gm.pos_of(p)
		var k: int = 0
		for nm: String in names:
			for sp in p["spells"]:
				if sp["name"] == nm:
					for d: Vector2i in [Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(0, -1), Vector2i(1, 1), Vector2i(-1, 1)]:
						var cell: Vector2i = pos + d * (1 + k % 2)
						if gm.is_free(cell):
							gm._resolve_summon(p, sp, Combat.parse(sp), cell)
							k += 1
							break
	await create_timer(2.0).timeout
	root.get_viewport().get_texture().get_image().save_png(out)
	pm.delete_save(4)
	quit(0)
