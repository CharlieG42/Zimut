extends SceneTree
## V139 — Trajets redressés sur la carte 2D : lignes droites de grille, tracé à l'écran rectiligne, option de grille.
var _fails: int = 0
func ck(c: bool, m: String) -> void:
	if c:
		print("  ok  ", m)
	else:
		print("  ÉCHEC  ", m)
		_fails += 1
func _init() -> void:
	_run.call_deferred()
## Nombre de changements de direction d'un trajet de cases.
func _turns(from: Vector2i, path: Array[Vector2i]) -> int:
	var n: int = 0
	var prev: Vector2i = from
	var pd := Vector2i.ZERO
	for c: Vector2i in path:
		var d: Vector2i = c - prev
		if pd != Vector2i.ZERO and d != pd:
			n += 1
		pd = d
		prev = c
	return n
func _run() -> void:
	var pm: Node = root.get_node("/root/ProgressionManager")
	var gm: Node = root.get_node("/root/GameManager")
	var gs: Node = root.get_node("/root/GameSettings")
	var AT: GDScript = load("res://scripts/AdventureTerrain.gd")
	# ligne de grille : bon nombre de pas, 4 voisins, colle au segment
	for pair: Array in [[Vector2i(0, 0), Vector2i(9, 4)], [Vector2i(5, 5), Vector2i(-3, 6)], [Vector2i(2, 2), Vector2i(2, 9)], [Vector2i(0, 0), Vector2i(7, 7)]]:
		var a: Vector2i = pair[0]
		var b: Vector2i = pair[1]
		var line: Array[Vector2i] = AT.grid_line(a, b)
		var ok: bool = line.size() == absi(b.x - a.x) + absi(b.y - a.y) and line[line.size() - 1] == b
		var prev: Vector2i = a
		var dev: float = 0.0
		var dir: Vector2 = Vector2(b - a).normalized()
		for c: Vector2i in line:
			ok = ok and absi(c.x - prev.x) + absi(c.y - prev.y) == 1
			dev = maxf(dev, absf(Vector2(c - a).cross(dir)))
			prev = c
		ck(ok and dev <= 0.75, "ligne de grille %s → %s : %d pas, écart max %.2f case" % [str(a), str(b), line.size(), dev])
	var before: String = gs.sylvestre_board
	var before_grid: bool = gs.show_grid
	gs.set_sylvestre_board("diorama")
	var data: Dictionary = pm.new_game(4, "MarcheDroite")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "adventure"
	data["adventure_view"] = "map"
	gm.active_save = data
	gm.active_slot = 4
	var adv: Dictionary = pm.adventure_state(data)
	pm.adventure_unlock_zone(adv, "foret_sylve")
	pm.adventure_enter_zone(adv, "foret_sylve")
	var sc: Node = (load("res://scenes/AdventureMap.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(0.8).timeout
	var h: Vector2i = sc.manager.hero_pos()
	var tested: int = 0
	var fewer: int = 0
	var worst_dev: float = 0.0
	for off: Vector2i in [Vector2i(14, 5), Vector2i(-12, 7), Vector2i(9, -13), Vector2i(-8, -10), Vector2i(18, 11), Vector2i(-16, -4), Vector2i(6, 15)]:
		var target: Vector2i = h + off
		if not AT.walkable("foret_sylve", target):
			continue
		var raw: Array[Vector2i] = AT.find_path("foret_sylve", h, target, {})
		var path: Array[Vector2i] = sc.manager.path_to(target)
		if raw.is_empty() or path.is_empty():
			continue
		tested += 1
		var valid: bool = path.size() == raw.size() and path[path.size() - 1] == target
		var prev2: Vector2i = h
		for c2: Vector2i in path:
			valid = valid and absi(c2.x - prev2.x) + absi(c2.y - prev2.y) == 1 and AT.walkable("foret_sylve", c2) and AT.can_step("foret_sylve", prev2, c2)
			prev2 = c2
		ck(valid, "trajet vers %s : %d pas (inchangé), cases libres et voisines" % [str(off), path.size()])
		# à l'écran : chaque point est sur le segment de son tronçon, et il y a peu de tronçons
		var pts: Array[Vector2] = sc.straight_points(h, path)
		ck(pts.size() == path.size() + 1 and pts[pts.size() - 1].distance_to(sc.cell_center(target)) < 0.5, "  tracé : un point par case, arrivée au centre de la case visée")
		var bends: int = 0
		for i: int in range(1, pts.size() - 1):
			var d0: Vector2 = (pts[i] - pts[i - 1]).normalized()
			var d1: Vector2 = (pts[i + 1] - pts[i]).normalized()
			if d0.dot(d1) < 0.999:
				bends += 1
			worst_dev = maxf(worst_dev, pts[i].distance_to(sc.cell_center(path[i - 1])))
		if bends < _turns(h, path):
			fewer += 1
		print("    virages à l'écran : %d (escalier de cases : %d changements de direction)" % [bends, _turns(h, path)])
	ck(tested >= 3, "%d trajets testés" % tested)
	ck(fewer == tested, "le tracé à l'écran a toujours moins de virages que l'escalier de cases")
	ck(worst_dev < 60.0, "le héros ne s'écarte jamais de plus d'une case de sa case logique (%.0f px)" % worst_dev)
	# réglage de la grille : enregistré, lu par la carte
	gs.set_show_grid(true)
	gs.load_settings()
	ck(gs.show_grid, "réglage « grille des cases » enregistré")
	sc._board.queue_redraw()
	await create_timer(0.3).timeout
	gs.set_show_grid(before_grid)
	gs.set_sylvestre_board(before)
	pm.delete_save(4)
	print("OK : tous les tests passent." if _fails == 0 else "ÉCHEC : %d" % _fails)
	quit(1 if _fails > 0 else 0)
