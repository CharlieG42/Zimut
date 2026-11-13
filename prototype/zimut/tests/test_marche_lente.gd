extends SceneTree
## V156 : déplacement ralenti en Tactique ; la cadence de marche suit la durée d'une case.
## Lancement : godot --headless --path . -s tests/test_marche_lente.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	await process_frame
	var gm: GDScript = load("res://scripts/GridManager.gd")
	var consts: Dictionary = gm.get_script_constant_map()
	var st: float = float(consts["MOVE_STEP"])
	var st_long: float = float(consts["MOVE_STEP_LONG"])
	check(st >= 0.22 and st <= 0.30, "une case dure %.2f s (0,15 avant)" % st)
	check(st_long >= 0.17 and st_long < st, "longs trajets : %.2f s par case (0,11 avant), toujours plus vifs" % st_long)
	var v := EntityView.new()
	root.add_child(v)
	v.setup({"uid": 5, "classe": "Sylvain", "team": "player", "entity_type": "Player", "current_pv": 10, "max_pv": 10, "x": 2, "y": 3})
	v.position = Vector2(0, 0)
	var pts: Array[Vector2] = [Vector2(40, 20), Vector2(80, 40)]
	var tw: Tween = v.move_along(pts, st)
	check(is_equal_approx(v._walk_step, st), "move_along transmet la durée d'une case à l'animation")
	if tw.is_running():
		await tw.finished
	check(not v._moving and v.position.distance_to(Vector2(80, 40)) < 0.5, "arrivée sur la dernière case, marche arrêtée")
	# cadence, sans dépendre du temps réel : on se place pendant un déplacement
	v._moving = true
	v._walk_t0 = 3.0
	# un cycle (8 images) couvre deux cases : image 0 au départ, image 4 après une case
	var fr: Array = v._sq["walk"]["back" if v._facing_back() else "front"]
	v._t = v._walk_t0
	check(v._seq_tex() == fr[0], "la marche part de sa première image")
	v._t = v._walk_t0 + st + 0.001
	check(v._seq_tex() == fr[4], "après une case : milieu du cycle (l'autre pied)")
	v._t = v._walk_t0 + st * 2.0 + 0.001
	check(v._seq_tex() == fr[0], "après deux cases : cycle complet")
	print("ÉCHECS : ", fails)
	quit(1 if fails > 0 else 0)
