extends SceneTree
## Capture de la fenêtre d'annexion (Conquête) avec un message court puis long.
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	var data: Dictionary = pm.new_game(4, "Annexion")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "conquest"
	gm.active_save = data
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/ConquestMap.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(1.2).timeout
	sc._conquest["last_yield"] = {"Fer": 3}
	sc._show_annexion_popup("clairiere")
	await create_timer(0.6).timeout
	_shot(out + "/annex_court.png")
	sc._conquest["news"] = ["Une longue nouvelle de l'empire qui prend de la place, sur plusieurs lignes, pour vérifier le centrage de la fenêtre.", "Deuxième nouvelle : les caravanes ont livré du fer, du bois et du cuir à la capitale ; la garnison est renforcée.", "Troisième nouvelle : un éclaireur signale une offensive ennemie prochaine sur la citadelle des ronces.", "Quatrième nouvelle supplémentaire pour faire grandir la fenêtre."]
	sc._show_annexion_popup("citadelle_ronce")
	await create_timer(0.6).timeout
	_shot(out + "/annex_long.png")
	sc._show_assault_prep()
	await create_timer(0.6).timeout
	_shot(out + "/assault_prep.png")
	pm.delete_save(4)
	quit()
func _shot(p: String) -> void:
	root.get_viewport().get_texture().get_image().save_png(p)
