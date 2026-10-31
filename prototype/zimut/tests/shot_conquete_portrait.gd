extends SceneTree
## Captures V64 en portrait (téléphone) : conseil, cibles, terres inconnues, alerte de siège, missions.
func _init() -> void:
	_boot.call_deferred()
func _shot(p: String) -> void:
	await create_timer(0.5).timeout
	root.get_viewport().get_texture().get_image().save_png(p)
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
	await create_timer(1.0).timeout
	sc._select_city("fort_racine")
	await _shot(out + "/p_conseil.png")
	sc._show_tab(sc._tab_targets)
	await _shot(out + "/p_cibles.png")
	sc._select_city("ruines_lierre")
	await _shot(out + "/p_inconnu.png")
	sc._select_city("fort_racine")
	sc._attack_selected_city()
	await _shot(out + "/p_alerte.png")
	sc.find_child("RiskyAssaultConfirm", true, false).queue_free()
	sc._select_city("clairiere")
	sc._show_mission_picker()
	await _shot(out + "/p_missions.png")
	pm.delete_save(4)
	quit()
