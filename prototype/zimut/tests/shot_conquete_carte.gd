extends SceneTree
## Captures de la carte de Conquête V60 (repères, routes, territoires, brouillard, animations).
##   xvfb-run -a godot --rendering-method gl_compatibility --path . [--resolution 2400x1080] -s tests/shot_conquete_carte.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _shot(p: String) -> void:
	await process_frame
	root.get_viewport().get_texture().get_image().save_png(p)
func _scene(data: Dictionary) -> Node:
	var gm: Node = root.get_node("GameManager")
	gm.active_save = data
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/ConquestMap.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	return sc
func _zoom(sc: Node, z: float, center: Vector2) -> void:
	sc._map_zoom = z
	sc._target_map_zoom = z
	sc._clamp_zoom_and_pan()
	sc._center_on(center)
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var pm: Node = root.get_node("ProgressionManager")
	var gs: Node = root.get_node("GameSettings")
	gs.tutorial_enabled = false
	var data: Dictionary = pm.new_game(4, "Charlie")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "conquest"
	data["conquest"] = {"owned": ["capitale"], "pending_city": "", "battle_count": 0}
	var sc: Node = _scene(data)
	await create_timer(1.2).timeout
	await _shot(out + "/carte_debut.png")
	_zoom(sc, 0.0, Vector2(0.5, 0.5))
	await create_timer(0.4).timeout
	await _shot(out + "/carte_debut_entiere.png")
	sc.queue_free()
	await process_frame
	# Milieu de campagne : empire, ville pillée, ville perdue, siège, offensive d'un général, terres inconnues
	var d2: Dictionary = pm.new_game(4, "Charlie")
	pm.rebuild_team(d2, ["Chasseur", "Mage", "Sylvain"])
	d2["campaign_mode"] = "conquest"
	d2["conquest"] = {"owned": ["capitale", "clairiere", "pont_mousse", "fort_racine", "vieille_tour", "sanctuaire_mousse", "hameau_pin", "ruines_lierre"],
		"pending_city": "", "battle_count": 14, "city_levels": {"capitale": 3, "clairiere": 2, "fort_racine": 2},
		"ravage": {"hameau_pin": 2}, "lost": ["bastion_orage"], "sieges": {"citadelle_ronce": 2},
		"threat": {"city": "hameau_pin", "power": 30, "eta": 2, "general": "Morgrath"}}
	var adv: Dictionary = pm.adventure_state(d2)
	adv["revealed_cities"] = ["capitale", "clairiere", "pont_mousse", "fort_racine", "vieille_tour", "sanctuaire_mousse", "hameau_pin", "ruines_lierre",
		"bastion_orage", "col_givre", "citadelle_ronce", "village_brume", "fort_cendre", "pic_foudroyant", "abbaye_ronce", "mine_cristal", "donjon_roi", "garnison"]
	d2["adventure"] = adv
	sc = _scene(d2)
	await create_timer(1.2).timeout
	sc._select_city("citadelle_ronce")
	await create_timer(0.6).timeout
	await _shot(out + "/carte_milieu.png")
	sc._territory.get_texture().get_image().save_png(out + "/territoire.png")
	_zoom(sc, 0.0, Vector2(0.5, 0.5))
	await create_timer(0.5).timeout
	await _shot(out + "/carte_milieu_entiere.png")
	_zoom(sc, 1.6, Vector2(0.30, 0.35))
	await create_timer(0.5).timeout
	await _shot(out + "/carte_milieu_zoom.png")
	_zoom(sc, 1.4, Vector2(0.22, 0.72))
	await create_timer(0.5).timeout
	await _shot(out + "/carte_lave.png")
	_zoom(sc, 1.4, Vector2(0.85, 0.75))
	await create_timer(0.5).timeout
	await _shot(out + "/carte_cristaux.png")
	pm.delete_save(4)
	quit()
