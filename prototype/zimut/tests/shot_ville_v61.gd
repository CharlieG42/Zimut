extends SceneTree
## Captures de l'écran de ville V61 (vue illustrée, bâtiments à niveaux, Merveille).
##   xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_ville_v61.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _shot(p: String) -> void:
	await process_frame
	root.get_viewport().get_texture().get_image().save_png(p)
func _open(data: Dictionary, city: String) -> CanvasLayer:
	var ui: CanvasLayer = (load("res://scripts/CityScreenUI.gd") as GDScript).new()
	root.add_child(ui)
	ui.open(data, 4, city, null, String(ProgressionManager.CONQUEST_CITIES[city]["name"]))
	return ui
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "Charlie")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "conquest"
	data["gold"] = 900
	data["resources"] = {"Bois": 60, "Fer": 40, "Cuir": 20, "Magie": 30, "Venin": 12}
	data["conquest"] = {"owned": ["capitale", "clairiere", "col_givre", "caravanserail", "fort_cendre", "mine_cristal", "citadelle_ronce", "atelier_cuivre"], "pending_city": "",
		"city_levels": {"clairiere": 1, "col_givre": 3, "caravanserail": 5, "fort_cendre": 4, "mine_cristal": 2, "citadelle_ronce": 3, "atelier_cuivre": 5},
		"garrisons": {"col_givre": {"troops": 5, "hero": "Tank"}, "caravanserail": {"troops": 10, "hero": "Heal"}, "fort_cendre": {"troops": 7, "hero": ""}},
		"buildings": {"clairiere": ["scierie"], "col_givre": ["mine", "scierie", "muraille"], "caravanserail": ["scierie", "mine", "tannerie", "cabane", "verger", "muraille"],
			"fort_cendre": ["mine", "muraille", "cabane"], "mine_cristal": ["cabane", "mine"], "citadelle_ronce": ["cabane", "tannerie"], "atelier_cuivre": ["mine", "scierie", "tannerie", "cabane", "verger", "muraille"]},
		"building_levels": {"col_givre": {"mine": 2}, "caravanserail": {"scierie": 3, "mine": 3, "tannerie": 2, "cabane": 3, "verger": 2, "muraille": 3}, "fort_cendre": {"mine": 3, "muraille": 2},
			"atelier_cuivre": {"mine": 3, "scierie": 2, "cabane": 2, "muraille": 3}},
		"wonders": ["caravanserail", "fort_cendre", "atelier_cuivre"],
		"threat": {"city": "col_givre", "power": 25, "eta": 2}}
	var i: int = 0
	for city: String in ["clairiere", "col_givre", "caravanserail", "fort_cendre", "mine_cristal", "citadelle_ronce", "atelier_cuivre"]:
		var ui: CanvasLayer = _open(data, city)
		await create_timer(0.7).timeout
		await _shot("%s/ville_%d_%s.png" % [out, i, city])
		if city == "col_givre":
			ui._selected = "mine"
			ui._render()
			await create_timer(0.4).timeout
			await _shot("%s/ville_%d_%s_mine.png" % [out, i, city])
			ui._selected = "wonder"
			ui._render()
			await create_timer(0.4).timeout
			await _shot("%s/ville_%d_%s_merveille.png" % [out, i, city])
			ui._act(pm.conquest_build_wonder(data, city), "wonder")
			await create_timer(0.5).timeout
			await _shot("%s/ville_%d_%s_fx.png" % [out, i, city])
		ui.queue_free()
		await process_frame
		i += 1
	pm.delete_save(4)
	quit()
