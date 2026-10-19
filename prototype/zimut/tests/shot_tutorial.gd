extends SceneTree
## Captures : pseudo, intro de Gultur (modes verrouillés), niv 3, équipe, options.
## xvfb-run -a -s "-screen 0 1920x1080x24" godot --path . -s tests/shot_tutorial.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	var gs: Node = root.get_node("GameSettings")
	gs.restart_tutorial()
	for s in range(pm.MAX_SAVES):
		pm.delete_save(s)
	var sc: Node = (load("res://scenes/SaveSlots.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(0.8).timeout
	sc._on_slot_pressed(0)
	await create_timer(0.5).timeout
	_shot(out + "/pseudo.png")
	sc.get_node("%PseudoEdit") if false else null
	var edit: LineEdit = sc.find_child("PseudoEdit", true, false)
	edit.text = "Charlie"
	(sc.find_child("PseudoOk", true, false) as Button).pressed.emit()
	await create_timer(1.5).timeout
	_shot(out + "/intro_1.png")
	var g: Node = sc.find_children("*", "CanvasLayer", true, false).filter(func(n): return n is Gultur)[0]
	g._end_typing()
	g._on_next(); g._on_next(); g._on_next(); g._on_next()
	await create_timer(0.3).timeout
	g._end_typing()
	await create_timer(0.3).timeout
	_shot(out + "/intro_5.png")
	g._on_next()
	await create_timer(0.5).timeout
	_shot(out + "/modes_verrouilles.png")
	# Niveau 3
	var d: Dictionary = pm.load_save(0)
	d["roster"]["Tank"]["level"] = 3
	pm.write_save(0, d)
	sc._show_detail(pm.load_save(0), 0)
	await create_timer(1.0).timeout
	_shot(out + "/lvl3.png")
	sc.queue_free()
	# Écran d'équipe
	gs.tuto_seen["lvl3"] = true
	gm.active_save = pm.load_save(0)
	gm.active_slot = 0
	var ts: Node = (load("res://scenes/TeamSelection.tscn") as PackedScene).instantiate()
	root.add_child(ts)
	await create_timer(1.5).timeout
	_shot(out + "/team.png")
	pm.delete_save(0)
	gs.skip_tutorial()
	quit()
func _shot(p: String) -> void:
	root.get_viewport().get_texture().get_image().save_png(p)
