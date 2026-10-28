extends SceneTree
## Captures V48 : choix des héros, équipe avec héros verrouillés. Usage : -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _shot(name: String, dir: String) -> void:
	await create_timer(0.7).timeout
	root.get_viewport().get_texture().get_image().save_png("%s/%s.png" % [dir, name])
func _boot() -> void:
	var dir: String = OS.get_cmdline_user_args()[0] if OS.get_cmdline_user_args().size() > 0 else "/tmp"
	DirAccess.make_dir_recursive_absolute(dir)
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	root.get_node("GameSettings").tutorial_done = true
	var d: Dictionary = pm.new_game(4, "Charlie")
	var pick: HeroPickUI = HeroPickUI.open(root, d, true)
	pick._focus = "Tank"; pick._on_toggle()
	pick._focus = "Heal"; pick._on_toggle()
	pick._focus = "Mage"
	pick._refresh()
	await _shot("pick_initial", dir)
	pick._on_toggle()
	pick._on_confirm()
	pm.rebuild_team(d, ["Tank", "Heal", "Mage"])
	d["player"]["level"] = 4
	gm.active_save = d
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/TeamSelection.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(0.6).timeout
	sc.current = sc.classes.find("Assassin")
	sc.refresh()
	await _shot("equipe_verrouille", dir)
	sc._on_unlock_hero()
	await _shot("pick_unlock_equipe", dir)
	sc.queue_free()
	var pick2: HeroPickUI = HeroPickUI.open(root, d, false)
	pick2._focus = "Sylvain"
	pick2._refresh()
	await _shot("pick_unlock", dir)
	pm.delete_save(4)
	quit()
