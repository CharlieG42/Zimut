extends SceneTree
## V130 — Personnages teintés par la lumière du lieu sur la carte Diorama (carte de lumière).
var _fails: int = 0
func ck(c: bool, m: String) -> void:
	if c:
		print("  ok  ", m)
	else:
		print("  ÉCHEC  ", m)
		_fails += 1
func _init() -> void:
	_run.call_deferred()
func _run() -> void:
	var pm: Node = root.get_node("/root/ProgressionManager")
	var gm: Node = root.get_node("/root/GameManager")
	var gs: Node = root.get_node("/root/GameSettings")
	var BA: GDScript = load("res://scripts/BoardArt.gd")
	var data: Dictionary = pm.new_game(4, "DioramaLumiere")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "adventure"
	data["adventure_view"] = "map"
	gm.active_save = data
	gm.active_slot = 4
	var before: String = gs.sylvestre_board
	gs.set_sylvestre_board("diorama")
	var adv: Dictionary = pm.adventure_state(data)
	adv["zones_unlocked"] = ["foret_sylve", "brasier_cendres"]
	pm.adventure_enter_zone(adv, "foret_sylve")
	for z: String in ["foret_sylve", "brasier_cendres"]:
		var li: Dictionary = BA.diorama_light(z)
		ck(not li.is_empty() and (load(String(li["path"])) as Texture2D).get_width() == 320, "%s : carte de lumière 320 px" % z)
	var sc: Node = (load("res://scenes/AdventureMap.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(0.8).timeout
	ck(sc._dio_light != null, "Sylve : carte de lumière chargée")
	# teintes : bornées, variables d'un lieu à l'autre, verdâtres en Sylve
	var lo: float = 9.0
	var hi: float = 0.0
	var green: int = 0
	var n: int = 0
	for y: int in range(8, 140, 6):
		for x: int in range(8, 140, 6):
			var t: Color = sc.light_tint(Vector2i(x, y))
			var v: float = maxf(t.r, maxf(t.g, t.b))
			lo = minf(lo, v)
			hi = maxf(hi, v)
			green += 1 if t.g >= t.r and t.g >= t.b else 0
			n += 1
			if t.a != 1.0 or minf(t.r, minf(t.g, t.b)) < 0.5:
				_fails += 1
	ck(lo >= 0.74 and hi <= 1.06 and hi - lo > 0.08, "Sylve : teinte bornée (%.2f à %.2f) et variable selon le lieu" % [lo, hi])
	ck(green * 10 >= n * 7, "Sylve : dominante verte (%d / %d cases)" % [green, n])
	# le héros rejoint la teinte de sa case ; les monstres gardent leur alpha de fondu
	var p: Vector2i = sc.manager.hero_pos()
	sc._apply_hero_depth(p)
	ck(sc._hero.light_target == sc.light_tint(p), "héros : teinte visée = celle de sa case")
	await create_timer(0.8).timeout
	ck(absf(sc._hero.modulate.g - sc.light_tint(p).g) < 0.03, "héros : teinte rejointe en douceur")
	sc._refresh_world()
	var mob_ok: bool = not sc._mob_nodes.is_empty()
	for id: int in sc._mob_nodes.keys():
		var mn: Node2D = sc._mob_nodes[id]
		var lt: Color = sc.light_tint(mn.cell)
		mob_ok = mob_ok and absf(mn.modulate.r - lt.r) < 0.001 and absf(mn.modulate.b - lt.b) < 0.001
	ck(mob_ok, "monstres : teintés par leur case")
	var any: Node2D = sc._mob_nodes[sc._mob_nodes.keys()[0]]
	any.modulate.a = 0.25
	sc._refresh_world()
	ck(absf(any.modulate.a - 0.25) < 0.001, "monstres : l'alpha du fondu est conservé")
	# Brasier : dominante chaude
	pm.adventure_enter_zone(adv, "brasier_cendres")
	sc._rebuild_world()
	await create_timer(0.5).timeout
	var warm: int = 0
	n = 0
	for y: int in range(8, 140, 6):
		for x: int in range(8, 140, 6):
			var t2: Color = sc.light_tint(Vector2i(x, y))
			warm += 1 if t2.r >= t2.g and t2.r >= t2.b else 0
			n += 1
	ck(warm * 10 >= n * 8, "Brasier : dominante chaude (%d / %d cases)" % [warm, n])
	# hors diorama : neutre
	sc._dio_light = null
	ck(sc.light_tint(Vector2i(10, 10)) == Color.WHITE, "sans carte de lumière : teinte neutre")
	gs.set_sylvestre_board(before)
	pm.delete_save(4)
	print("OK : tous les tests passent." if _fails == 0 else "ÉCHEC : %d" % _fails)
	quit(1 if _fails > 0 else 0)
