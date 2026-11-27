extends SceneTree
## V460 : le mode Debug coupé masque tout (même en cours d'écran) ; chaque onglet des Réglages tient sans défiler.
var fails := 0
func ck(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c: fails += 1

func _init() -> void:
	_run.call_deferred()

func _run() -> void:
	await create_timer(0.3).timeout
	var gs: Node = root.get_node("GameSettings")
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	pm.write_save(3, pm.new_game(3, "T"))
	gm.active_save = pm.load_save(3)
	gm.active_slot = 3
	gs.set_show_perf(true)
	var perf := Label.new()
	perf.set_script(load("res://scripts/PerfCounter.gd"))
	root.add_child(perf)
	await create_timer(0.7).timeout
	ck(is_instance_valid(perf) and not perf.is_queued_for_deletion(), "mode Debug activé : le compteur reste affiché")
	gs.set_show_perf(false)
	await create_timer(0.7).timeout
	ck(not is_instance_valid(perf) or perf.is_queued_for_deletion(), "mode Debug désactivé : le compteur disparaît tout de suite")
	var m: Node = (load("res://scenes/CardDuel.tscn") as PackedScene).instantiate()
	root.add_child(m)
	await create_timer(0.5).timeout
	ck(m.find_child("PerfCounter", true, false) == null, "mode Cartes sans Debug : aucun compteur")
	m.queue_free()
	await create_timer(0.2).timeout
	var s: Node = (load("res://scenes/Settings.tscn") as PackedScene).instantiate()
	root.add_child(s)
	await create_timer(0.5).timeout
	var tabs: Node = s.find_child("Tabs", true, false)
	var sc: ScrollContainer = s.find_child("PagesScroll", true, false)
	var i := 0
	for b: Node in tabs.get_children():
		b.pressed.emit()
		await create_timer(0.3).timeout
		var h: float = sc.get_child(0).size.y
		ck(h <= sc.size.y + 1.0, "onglet %d : contenu %.0f ≤ zone %.0f (pas de défilement)" % [i, h, sc.size.y])
		i += 1
	print("FIN – %d échec(s)" % fails)
	quit(1 if fails > 0 else 0)
