extends SceneTree
## V140 — Caméra de la carte 2D : zone libre au centre, suivi seulement près des bords.
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
	var before: String = gs.sylvestre_board
	gs.set_sylvestre_board("diorama")
	var data: Dictionary = pm.new_game(4, "CameraZone")
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
	sc._recenter(false)
	var view: Vector2 = sc._map_view.size
	var sca: float = sc._world.scale.x
	var cam0: Vector2 = sc._world.position
	var centre: Vector2 = sc._hero.position
	# dans la zone libre : la caméra ne bouge pas
	sc._hero.position = centre + Vector2(view.x * 0.15, -view.y * 0.12) / sca
	sc._follow_hero()
	ck(sc._world.position == cam0, "héros dans la zone libre : caméra immobile")
	# au-delà du bord droit de la zone : la caméra glisse, le héros revient au bord de la zone
	sc._hero.position = centre + Vector2(view.x * 0.32, 0.0) / sca
	for i: int in range(60):
		sc._follow_hero()
	var hx: float = sc._world.position.x + sc._hero.position.x * sca
	ck(sc._world.position.x < cam0.x - 1.0 and absf(hx - view.x * (1.0 - sc.CAM_FREE_ZONE)) < 2.0, "héros près du bord droit : la caméra suit, il reste au bord de la zone libre")
	ck(absf(sc._world.position.y - cam0.y) < 0.01, "pas de mouvement vertical inutile")
	# rattrapage adouci : un seul appel ne fait pas tout le chemin
	sc._world.position = cam0
	sc._hero.position = centre + Vector2(0.0, view.y * 0.40) / sca
	sc._follow_hero()
	var moved: float = cam0.y - sc._world.position.y
	ck(moved > 0.5 and moved < view.y * 0.10 * 0.5, "rattrapage progressif (%.0f px au premier appel)" % moved)
	sc._hero.position = centre
	gs.set_sylvestre_board(before)
	pm.delete_save(4)
	print("OK : tous les tests passent." if _fails == 0 else "ÉCHEC : %d" % _fails)
	quit(1 if _fails > 0 else 0)
