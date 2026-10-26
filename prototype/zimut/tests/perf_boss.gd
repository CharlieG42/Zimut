extends SceneTree
## Mesure de fluidité d'un combat de boss : temps CPU par image, appels de dessin, nœuds.
## xvfb-run -a -s "-screen 0 1280x720x24" godot --rendering-method gl_compatibility --path . -s tests/perf_boss.gd
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	root.get_node("GameSettings").tutorial_done = true
	var data: Dictionary = pm.new_game(4, "Perf")
	data["victories"] = 3
	pm.rebuild_team(data, ["Tank", "Mage", "Heal"])
	gm.active_save = data
	gm.active_slot = 4
	gm.set_custom_team([{"classe": "Tank"}, {"classe": "Mage"}, {"classe": "Heal"}])
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await create_timer(2.0).timeout
	var views: Array = []
	_collect(main, views)
	print("EntityView : ", views.size(), "  nœuds : ", Performance.get_monitor(Performance.OBJECT_NODE_COUNT))
	var worst: float = 0.0
	var tot: float = 0.0
	var n: int = 0
	var t_end: int = Time.get_ticks_msec() + 1500
	while Time.get_ticks_msec() < t_end:
		await process_frame
		var p: float = Performance.get_monitor(Performance.TIME_PROCESS) * 1000.0
		tot += p
		worst = maxf(worst, p)
		n += 1
	print("images : ", n, "  process moyen ms : ", snappedf(tot / maxf(n, 1), 0.01), "  pire : ", snappedf(worst, 0.01))
	print("draw calls : ", Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME),
		"  objets rendus : ", Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME))
	# coût de _process des EntityView seuls
	var t0: int = Time.get_ticks_usec()
	for k: int in 200:
		for v: Node in views:
			v._process(0.016)
	print("EntityView._process x", views.size(), " : ", snappedf((Time.get_ticks_usec() - t0) / 200.0 / 1000.0, 0.001), " ms/image")
	if "quick" in OS.get_cmdline_user_args():
		pm.delete_save(4)
		quit(0)
		return
	await process_frame
	await process_frame
	var base: float = Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
	var cands: Array = []
	_collect_ci(main, cands)
	var groups: Dictionary = {}
	for ci: CanvasItem in cands:
		var key: String = String(ci.get_script().resource_path).get_file() if ci.get_script() != null else ci.get_class()
		if not groups.has(key):
			groups[key] = []
		groups[key].append(ci)
	var rows: Array = []
	for key: String in groups:
		var lst: Array = groups[key]
		lst = lst.filter(func(x): return is_instance_valid(x))
		for ci: CanvasItem in lst:
			ci.visible = false
		await process_frame
		await process_frame
		var d: float = base - Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
		for ci: CanvasItem in lst:
			if is_instance_valid(ci):
				ci.visible = true
		rows.append([d, "%s x%d" % [key, lst.size()]])
	rows.sort_custom(func(a, b): return a[0] > b[0])
	for r in rows.slice(0, 25):
		print("  -", r[0], " ", r[1])
	pm.delete_save(4)
	quit(0)
func _collect(n: Node, out: Array) -> void:
	if n.get_script() != null and String(n.get_script().resource_path).ends_with("EntityView.gd"):
		out.append(n)
	for c: Node in n.get_children():
		_collect(c, out)
func _collect_ci(n: Node, out: Array) -> void:
	if n is CanvasItem and (n.get_script() != null or n is TileMapLayer or n is GPUParticles2D or n is CPUParticles2D or n is Sprite2D or n is Polygon2D or n is Line2D):
		out.append(n)
	for c: Node in n.get_children():
		_collect_ci(c, out)
