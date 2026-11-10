extends SceneTree
## V133 — Le sentier de retour (Brasier → Sylve) se reprend à volonté, comme un portail.
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
	var AT: GDScript = load("res://scripts/AdventureTerrain.gd")
	var data: Dictionary = pm.new_game(4, "SentierRetour")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "adventure"
	data["adventure_view"] = "map"
	gm.active_save = data
	gm.active_slot = 4
	var before: String = gs.sylvestre_board
	gs.set_sylvestre_board("diorama")
	var adv: Dictionary = pm.adventure_state(data)
	adv["zones_unlocked"] = ["foret_sylve", "brasier_cendres"]
	pm.adventure_enter_zone(adv, "brasier_cendres")
	var sc: Node = (load("res://scenes/AdventureMap.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(0.8).timeout
	var back := Vector2i(-1, -1)
	var pois: Dictionary = pm.adventure_zone_pois("brasier_cendres")
	for k: String in pois.keys():
		if bool(pois[k].get("back", false)):
			back = AT.parse(k)
	ck(back.x >= 0, "sentier de retour présent au Brasier (%s)" % str(back))
	for pass_n: int in range(2):
		pm.adventure_enter_zone(sc.manager.state, "brasier_cendres")
		sc.manager.state["hero_pos"] = [back.x, back.y]
		ck(not sc.manager.poi_done(back), "passage %d : le sentier n'est pas « terminé »" % (pass_n + 1))
		var cmd: Dictionary = sc.manager.interact()
		ck(String(cmd.get("action", "")) == "exit" and not bool(cmd.get("portal", false)), "passage %d : le sentier répond" % (pass_n + 1))
		var revealed: Array = sc.manager.take_exit(String(cmd.get("key", "")))
		ck(revealed.is_empty(), "passage %d : rien de nouveau débloqué par un retour" % (pass_n + 1))
		ck(sc.manager.enter_zone("foret_sylve") and sc.manager.zone_id() == "foret_sylve", "passage %d : arrivée en Sylve" % (pass_n + 1))
	# les autres lieux gardent leur état « terminé »
	pm.adventure_enter_zone(sc.manager.state, "brasier_cendres")
	var other := Vector2i(-1, -1)
	for k2: String in pois.keys():
		if String(pois[k2].get("kind", "")) == "rest" or String(pois[k2].get("kind", "")) == "treasure":
			other = AT.parse(k2)
			break
	if other.x >= 0:
		pm.adventure_complete_poi(data, sc.manager.poi_key(other), String(pois["%d,%d" % [other.x, other.y]].get("kind", "")))
		ck(sc.manager.poi_done(other), "un lieu ordinaire reste « terminé » une fois fait")
	gs.set_sylvestre_board(before)
	pm.delete_save(4)
	print("OK : tous les tests passent." if _fails == 0 else "ÉCHEC : %d" % _fails)
	quit(1 if _fails > 0 else 0)
