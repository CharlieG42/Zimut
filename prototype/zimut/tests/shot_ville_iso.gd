extends SceneTree
## Captures de la ville avec les sprites isométriques (Forêt = sylvestre, Montagne = cimes).
##   xvfb-run -a -s "-screen 0 1920x1080x24" godot --rendering-method gl_compatibility --rendering-driver opengl3 --resolution 2000x923 --path . -s tests/shot_ville_iso.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _shot(p: String) -> void:
	root.get_viewport().get_texture().get_image().save_png(p)
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	root.get_node("GameSettings").tutorial_enabled = false
	var data: Dictionary = pm.new_game(4, "CaptureIso")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "conquest"
	data["gold"] = 900
	data["resources"] = {"Bois": 60, "Fer": 60, "Cuir": 25, "Magie": 25, "Venin": 10}
	var all3: Dictionary = {"scierie": 3, "mine": 3, "tannerie": 3, "cabane": 3, "verger": 3, "muraille": 3}
	var all1: Dictionary = {"scierie": 1, "mine": 1, "tannerie": 1, "cabane": 1, "verger": 1}
	data["conquest"] = {"owned": ["capitale", "clairiere", "hameau_pin", "mine_cristal", "atelier_cuivre"], "pending_city": "",
		"city_levels": {"clairiere": 4, "hameau_pin": 2, "mine_cristal": 5, "atelier_cuivre": 3},
		"garrisons": {"clairiere": {"troops": 5, "hero": "Tank"}, "hameau_pin": {"troops": 3, "hero": ""}, "mine_cristal": {"troops": 3, "hero": ""}, "atelier_cuivre": {"troops": 3, "hero": ""}},
		"buildings": {"clairiere": all3.keys(), "hameau_pin": all1.keys(), "mine_cristal": all3.keys(), "atelier_cuivre": all3.keys()},
		"building_levels": {"clairiere": all3, "hameau_pin": all1, "mine_cristal": all3, "atelier_cuivre": all3},
		"wonders": ["clairiere"], "battle_count": 4}
	gm.active_save = data
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/ConquestMap.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(1.0).timeout
	sc._on_city_pressed("clairiere")
	await create_timer(0.8).timeout
	_shot(out + "/iso_foret.png")
	sc.get_node("CityScreen").close()
	await create_timer(0.3).timeout
	sc._on_city_pressed("hameau_pin")
	await create_timer(0.8).timeout
	_shot(out + "/iso_montagne.png")
	for cid: String in ["mine_cristal", "atelier_cuivre"]:
		sc.get_node("CityScreen").close()
		await create_timer(0.3).timeout
		sc._on_city_pressed(cid)
		await create_timer(0.8).timeout
		_shot(out + "/iso_%s.png" % cid)
	quit(0)
