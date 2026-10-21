extends SceneTree
## Capture V37 : combat dans la Nation des Ombres (Assassin + sprites Mistral).
## xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_ombres.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var dir: String = args[0] if args.size() > 0 else "/tmp/shots"
	DirAccess.make_dir_recursive_absolute(dir)
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	root.get_node("GameSettings").tutorial_done = true
	var data: Dictionary = pm.new_game(4, "OmbShot")
	pm.rebuild_team(data, ["Assassin", "Tank", "Mage"])
	data["adventure"] = {"zone": "ombres_necropole"}
	data["campaign_mode"] = "adventure"
	gm.active_save = data
	gm.active_slot = 4
	gm.set_custom_team([{"classe": "Assassin"}, {"classe": "Tank"}, {"classe": "Mage"}])
	gm.auto_mode = false
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await create_timer(1.5).timeout
	print("biome = ", gm.fight_biome)
	root.get_viewport().get_texture().get_image().save_png(dir + "/ombres_1_combat.png")
	# les 4 skins d'ennemis + le boss Nébulia
	var grid: Node = main.get_node("GridManager")
	var kinds: Array = ["Gobelin", "Squelette", "Troll", "BOSS"]
	var i: int = 0
	for e: Dictionary in gm.enemies:
		if i >= kinds.size():
			break
		if String(kinds[i]) == "BOSS":
			e["boss"] = true
			e["nation_boss"] = "Ombres"
		else:
			e["classe"] = kinds[i]
		var v: Node = grid.views.get(int(e["uid"]))
		if v != null:
			v.setup(e)
		i += 1
	await create_timer(0.8).timeout
	root.get_viewport().get_texture().get_image().save_png(dir + "/ombres_2_tous.png")
	# Assassin : pose d'attaque en plein mouvement
	for p: Dictionary in gm.players:
		if String(p["classe"]) == "Assassin":
			var av: Node = grid.views.get(int(p["uid"]))
			av.play_pose("attack", 1.2, "Lame")
	for e2: Dictionary in gm.enemies:
		var ev: Node = grid.views.get(int(e2["uid"]))
		if ev != null:
			ev.play_pose("attack", 1.2, "Griffe")
	await create_timer(0.35).timeout
	root.get_viewport().get_texture().get_image().save_png(dir + "/ombres_3_attaques.png")
	pm.delete_save(4)
	quit(0)
