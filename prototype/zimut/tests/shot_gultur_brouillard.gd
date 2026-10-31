extends SceneTree
## Capture : Conquête avec brouillard, conseils de Gultur déjà vus sauf brouillard / nouveautés.
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var pm: Node = root.get_node("ProgressionManager")
	var gs: Node = root.get_node("GameSettings")
	gs.restart_tutorial()
	gs.mark_tuto_seen("conq_v59")
	gs.mark_tuto_seen("conq_carte")
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
	await create_timer(4.5).timeout
	root.get_viewport().get_texture().get_image().save_png(out + "/gultur_brouillard.png")
	gs.skip_tutorial()
	pm.delete_save(4)
	quit()
