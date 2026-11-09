extends SceneTree
## V129 — Le portail de la carte Diorama est toujours visible : devant le décor, état lisible, bouton pour le montrer.
var _fails: int = 0
func ck(c: bool, m: String) -> void:
	if c:
		print("  ok  ", m)
	else:
		print("  ÉCHEC  ", m)
		_fails += 1
func _init() -> void:
	_run.call_deferred()
func _find(n: Node, nm: String) -> Node:
	if n.name == nm:
		return n
	for ch in n.get_children():
		var r: Node = _find(ch, nm)
		if r != null:
			return r
	return null
func _run() -> void:
	var pm: Node = root.get_node("/root/ProgressionManager")
	var gm: Node = root.get_node("/root/GameManager")
	var gs: Node = root.get_node("/root/GameSettings")
	var BA: GDScript = load("res://scripts/BoardArt.gd")
	var data: Dictionary = pm.new_game(4, "PortailVisible")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "adventure"
	data["adventure_view"] = "map"
	gm.active_save = data
	gm.active_slot = 4
	var before: String = gs.sylvestre_board
	gs.set_sylvestre_board("diorama")
	var adv: Dictionary = pm.adventure_state(data)
	pm.adventure_unlock_zone(adv, "foret_sylve")
	pm.adventure_enter_zone(adv, "foret_sylve")
	var sc: Node = (load("res://scenes/AdventureMap.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(0.8).timeout
	var pc: Vector2i = sc.portal_cell()
	ck(pc.x >= 0 and sc.manager.is_portal(sc.manager.poi_at(pc)), "portail trouvé sur la carte (%s)" % str(pc))
	var node: Node2D = null
	for n in sc._cell_nodes.get(pc, []):
		if n.get("portal") == true:
			node = n
	ck(node != null, "nœud du portail présent")
	# plus haut que tous les occultants du décor (arbres, bâtiments découpés)
	var max_occ: int = 0
	for oc: Dictionary in BA.diorama_occluders("foret_sylve"):
		max_occ = maxi(max_occ, sc._depth(oc["cell"]) + 4)
	sc._refresh_world()
	ck(node != null and node.z_index > max_occ and node.z_index < 1320, "portail dessiné devant tout le décor (z %d > %d), sous l'interface" % [node.z_index if node != null else -1, max_occ])
	ck(node != null and node.visible and node.locked and not node.done and node.show_label, "donjon final à faire : portail visible, SCELLÉ, étiquette affichée")
	sc._refresh_side()
	var btn: Button = _find(sc, "PortalShow") as Button
	ck(btn != null and btn.text.contains("scellé"), "panneau : bouton « Portail scellé · le voir »")
	# donjon final vaincu : ouvert
	sc.manager.state["dungeons"] = {"Forêt": {"clears": 1, "boss_kills": 1}}
	sc._refresh_world()
	sc._refresh_side()
	await create_timer(0.2).timeout
	ck(node != null and not node.locked and node.visible and node.show_label, "donjon final vaincu : portail OUVERT")
	btn = _find(sc, "PortalShow") as Button
	ck(btn != null and btn.text.contains("OUVERT"), "panneau : bouton « Portail OUVERT · le voir »")
	if btn != null:
		btn.pressed.emit()
	await create_timer(0.9).timeout
	var on_screen: Vector2 = node.get_global_transform_with_canvas().origin if node != null else Vector2(-1, -1)
	var vr: Vector2 = sc.get_viewport().get_visible_rect().size
	ck(on_screen.x > 0.0 and on_screen.y > 0.0 and on_screen.x < vr.x and on_screen.y < vr.y, "le bouton amène le portail à l'écran")
	gs.set_sylvestre_board(before)
	pm.delete_save(4)
	print("OK : tous les tests passent." if _fails == 0 else "ÉCHEC : %d" % _fails)
	quit(1 if _fails > 0 else 0)
