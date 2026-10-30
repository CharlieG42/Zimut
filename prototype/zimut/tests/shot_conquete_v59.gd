extends SceneTree
## Captures Conquête V59 : conseil à onglets, audience du Chancelier (Plus tard), Gultur, écran de fin.
##   xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_conquete_v59.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _shot(p: String) -> void:
	root.get_viewport().get_texture().get_image().save_png(p)
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	var gs: Node = root.get_node("GameSettings")
	gs.tutorial_enabled = true
	gs.tuto_seen = {}
	var data: Dictionary = pm.new_game(4, "Charlie")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "conquest"
	data["gold"] = 400
	data["conquest"] = {"owned": ["capitale", "clairiere", "pont_mousse"], "pending_city": "", "battle_count": 6}
	gm.active_save = data
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/ConquestMap.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(1.6).timeout
	_shot(out + "/v59_gultur.png")
	gs.tuto_seen = {"conq_v59": true}
	for n: Node in sc.get_children():
		if n is Gultur:
			n.queue_free()
	sc._select_city("vieille_tour")
	await create_timer(0.5).timeout
	_shot(out + "/v59_conseil_ville.png")
	sc._show_tab(sc._tab_chron)
	await create_timer(0.3).timeout
	_shot(out + "/v59_conseil_chronique.png")
	# audience du Chancelier
	gs.tuto_seen = {"conq_v59": true, "conq_chancelier": true}
	ConquestSystem.maybe_chancellor(sc._conquest)
	sc._conquest["chancellor_cd"] = 99
	ConquestSystem.maybe_chancellor(sc._conquest)
	sc._show_event_popup()
	await create_timer(0.5).timeout
	_shot(out + "/v59_chancelier.png")
	# écran de fin
	var score: Dictionary = {"villes": 120, "niveaux": 46, "gouverneurs": 18, "pierres": 90, "diplomatie": 30, "ruines": -10}
	sc._show_epilogue(score, ConquestSystem.legend_ending(score, {"annexed_diplomacy": []}))
	await create_timer(1.0).timeout
	_shot(out + "/v59_fin.png")
	pm.delete_save(4)
	quit()
