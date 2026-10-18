extends SceneTree
## Capture de la fenêtre de victoire en mode Conquête, à plusieurs tailles d'écran.
## xvfb-run -a godot --path . -s tests/shot_result_conq.gd -- <dossier> [largeur hauteur]
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var out: String = args[0] if args.size() > 0 else "/tmp/result"
	if args.size() >= 3:
		root.size = Vector2i(int(args[1]), int(args[2]))
	DirAccess.make_dir_recursive_absolute(out)
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	var gs: Node = root.get_node("GameSettings")
	gs.tutorial_done = true
	gs.speed_override = 8.0
	var data: Dictionary = pm.new_game(4, "Résultat")
	pm.rebuild_team(data, ["Tank", "Mage", "Heal"])
	data["campaign_mode"] = "conquest"
	gm.active_save = data
	gm.active_slot = 4
	gm.set_custom_team([{"classe": "Tank"}, {"classe": "Mage"}, {"classe": "Heal"}])
	gm.auto_mode = true
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	var t0: int = Time.get_ticks_msec()
	while not gm.game_over and Time.get_ticks_msec() - t0 < 150000:
		await create_timer(0.5).timeout
	Engine.time_scale = 1.0
	await create_timer(3.5).timeout
	print("fin : victoire=", gm.victory, " vp=", root.get_visible_rect().size)
	root.get_viewport().get_texture().get_image().save_png(out + "/result_conq.png")
	# Contenu chargé : beaucoup de butin, empire, défi, succès, texte agrandi
	var save: Dictionary = gm.active_save
	var loots: Array = []
	for i in 14:
		loots.append({"type": "Bouclier", "name": "Bouclier de test %d" % i, "level": 5, "rarity": "rare", "defense": 4})
	save["last_loots"] = loots
	var cq: Dictionary = save.get("conquest", {})
	cq["last_yield"] = {"Fer": 3, "Bois": 2, "Cuir": 1}
	cq["last_challenge"] = {"success": true, "gold": 50, "resources": {"Fer": 2}, "label": "Victoire éclair"}
	save["conquest"] = cq
	var ach: Array = []
	for i in 4:
		ach.append({"name": "Succès %d" % i, "reward_text": "+10 or"})
	save["last_achievements"] = ach
	gs.text_size = 2
	for n in main.ui_manager.get_children():
		pass
	main.ui_manager._show_result_window(true)
	await create_timer(1.0).timeout
	root.get_viewport().get_texture().get_image().save_png(out + "/result_conq_full.png")
	pm.delete_save(4)
	quit(0)
