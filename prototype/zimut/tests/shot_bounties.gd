extends SceneTree
## Captures V28 : Mes Parties (rangée Pierres / Primes) et tableau des primes.
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0] if OS.get_cmdline_user_args().size() > 0 else "/tmp/shots"
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "Charlie")
	pm.rebuild_team(data, ["Artificier", "Tank", "Mage"])
	pm.ensure_roster(data)
	Stones.grant(data, "Forêt")
	Bounties.ensure(data)
	data["bounties"]["list"][0]["progress"] = int(data["bounties"]["list"][0]["target"])
	data["bounties"]["list"][0]["done"] = true
	data["bounties"]["list"][1]["progress"] = 1
	pm.write_save(4, data)
	var sc: Node = (load("res://scenes/SaveSlots.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(0.8).timeout
	if sc.has_method("_show_detail"):
		sc.call("_show_detail", pm.load_save(4), 4)
		sc.set("_current", pm.load_save(4))
	await create_timer(0.8).timeout
	root.get_viewport().get_texture().get_image().save_png(out + "/mes_parties.png")
	sc.call("_open_bounties", 4)
	await create_timer(0.8).timeout
	root.get_viewport().get_texture().get_image().save_png(out + "/primes.png")
	pm.delete_save(4)
	quit()
