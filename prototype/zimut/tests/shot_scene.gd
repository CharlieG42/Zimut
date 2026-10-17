extends SceneTree
## Capture d'une scène de campagne avec une partie active (écran virtuel).
##   xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_scene.gd -- res://scenes/AdventureMap.tscn /tmp/x.png adventure [attente_s]
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var scene_path: String = args[0]
	var out: String = args[1]
	var mode: String = args[2] if args.size() > 2 else ""
	var wait: float = float(args[3]) if args.size() > 3 else 1.5
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	var data: Dictionary = pm.new_game(4, "Capture")
	pm.rebuild_team(data, ["Tank", "Mage", "Sylvain"])
	for c in ["Tank", "Mage", "Sylvain"]:
		pm.roster_entry(data, c)["level"] = 14
	data["campaign_mode"] = mode
	data["gold"] = 900
	data["resources"] = {"Fer": 20, "Bois": 14, "Cuir": 9, "Magie": 8, "Venin": 4}
	gm.active_save = data
	gm.active_slot = 4
	var sc: Node = (load(scene_path) as PackedScene).instantiate()
	root.add_child(sc)
	# Conquête : sélectionne la première ville attaquable (affiche défi + bouton d'assaut)
	if mode == "conquest" and sc.has_method("_select_city"):
		await process_frame
		var cq: Dictionary = data.get("conquest", {})
		for id: String in pm.CONQUEST_CITIES.keys():
			if not cq.get("owned", []).has(id) and pm.conquest_city_attackable(cq, id, data.get("adventure", {})):
				sc.call("_select_city", id)
				break
	await create_timer(wait).timeout
	root.get_viewport().get_texture().get_image().save_png(out)
	pm.delete_save(4)
	quit(0)
