extends SceneTree
## Capture V37/V38 : combat de nation avec les sprites Mistral.
## xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_nation_sprites.gd -- <dossier> [héros] [zone] [préfixe] [types séparés par ,]
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var dir: String = args[0] if args.size() > 0 else "/tmp/shots"
	DirAccess.make_dir_recursive_absolute(dir)
	var hero: String = args[1] if args.size() > 1 else "Assassin"
	var zone: String = args[2] if args.size() > 2 else "ombres_necropole"
	var pre: String = args[3] if args.size() > 3 else "ombres"
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	root.get_node("GameSettings").tutorial_done = true
	var data: Dictionary = pm.new_game(4, "OmbShot")
	pm.rebuild_team(data, [hero, "Tank", "Mage"])
	data["adventure"] = {"zone": zone}
	data["campaign_mode"] = "adventure"
	gm.active_save = data
	gm.active_slot = 4
	gm.set_custom_team([{"classe": hero}, {"classe": "Tank"}, {"classe": "Mage"}])
	gm.auto_mode = false
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await create_timer(1.5).timeout
	print("biome = ", gm.fight_biome)
	root.get_viewport().get_texture().get_image().save_png(dir + "/" + pre + "_1_combat.png")
	# les 4 skins d'ennemis + le boss Nébulia
	var grid: Node = main.get_node("GridManager")
	var kinds: Array = (args[4] if args.size() > 4 else "Gobelin,Squelette,Troll,BOSS").split(",")
	var i: int = 0
	for e: Dictionary in gm.enemies:
		if i >= kinds.size():
			break
		if String(kinds[i]) == "BOSS":
			e["boss"] = true
			e["nation_boss"] = gm.fight_biome
		else:
			e["classe"] = kinds[i]
		var v: Node = grid.views.get(int(e["uid"]))
		if v != null:
			v.setup(e)
		i += 1
	await create_timer(0.8).timeout
	root.get_viewport().get_texture().get_image().save_png(dir + "/" + pre + "_2_tous.png")
	# Assassin : pose d'attaque en plein mouvement
	for p: Dictionary in gm.players:
		if String(p["classe"]) == hero:
			var av: Node = grid.views.get(int(p["uid"]))
			av.play_pose("attack", 1.2, "Lame")
	for e2: Dictionary in gm.enemies:
		var ev: Node = grid.views.get(int(e2["uid"]))
		if ev != null:
			ev.play_pose("attack", 1.2, "Griffe")
	await create_timer(0.35).timeout
	root.get_viewport().get_texture().get_image().save_png(dir + "/" + pre + "_3_attaques.png")
	pm.delete_save(4)
	quit(0)
