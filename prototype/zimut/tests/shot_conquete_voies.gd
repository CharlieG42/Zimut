extends SceneTree
## Capture : carte Conquête, 3 villes, brouillard partiel — les voies vers les voisines doivent rester visibles.
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var pm: Node = root.get_node("ProgressionManager")
	root.get_node("GameSettings").tutorial_enabled = false
	var d: Dictionary = pm.new_game(4, "Charlie")
	pm.rebuild_team(d, ["Chasseur", "Mage", "Sylvain"])
	d["campaign_mode"] = "conquest"
	d["conquest"] = {"owned": ["capitale", "clairiere", "pont_mousse"], "pending_city": "", "battle_count": 3}
	var adv: Dictionary = pm.adventure_state(d)
	adv["revealed_cities"] = ["capitale", "hameau_pin"]
	d["adventure"] = adv
	var gm: Node = root.get_node("GameManager")
	gm.active_save = d
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/ConquestMap.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(1.2).timeout
	sc._select_city("fort_racine")
	await create_timer(0.6).timeout
	await process_frame
	root.get_viewport().get_texture().get_image().save_png(out + "/voies.png")
	sc._select_city("vieille_tour")
	sc._show_tab(sc._tab_targets)
	await create_timer(0.5).timeout
	root.get_viewport().get_texture().get_image().save_png(out + "/cibles.png")
	sc._select_city("ruines_lierre")
	sc._center_on(Vector2(0.4, 0.5))
	await create_timer(0.6).timeout
	root.get_viewport().get_texture().get_image().save_png(out + "/loin.png")
	sc._select_city("pont_mousse")
	sc.details_collapsed = true
	sc._apply_details_state()
	await create_timer(0.5).timeout
	root.get_viewport().get_texture().get_image().save_png(out + "/replie.png")
	pm.delete_save(4)
	quit()
