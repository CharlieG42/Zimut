extends SceneTree
## V43 : vue défilante du mode Aventure (grands plateaux).
## Lancement : xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/test_adventure_scroll.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var ui_script: GDScript = load("res://scripts/AdventureMapUI.gd")
	# Décision de défilement selon la taille du plateau
	check(not ui_script.scroll_needed(Vector2i(10, 7), Vector2(1100, 850)), "plateau 10×7 : tout tient, pas de défilement")
	check(ui_script.scroll_needed(Vector2i(24, 18), Vector2(1100, 850)), "plateau 24×18 : défilement activé")
	check(not ui_script.scroll_needed(Vector2i(24, 18), Vector2(4, 4)), "vue pas encore dimensionnée : pas de décision")
	var pm: Node = root.get_node("ProgressionManager")
	var gm: Node = root.get_node("GameManager")
	var data: Dictionary = pm.new_game(4, "ScrollTest")
	pm.rebuild_team(data, ["Chasseur", "Mage", "Sylvain"])
	data["campaign_mode"] = "adventure"
	pm.adventure_state(data)
	gm.active_save = data
	gm.active_slot = 4
	var sc: Node = (load("res://scenes/AdventureMap.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(0.6).timeout
	check(not sc._scroll_mode, "carte actuelle (10×7) : vue fixe")
	# On force une petite fenêtre de vue pour simuler un plateau plus grand que l'écran
	var v: Control = sc._map_view
	v.anchor_right = 0.0
	v.anchor_bottom = 0.0
	v.offset_right = 520.0
	v.offset_bottom = 420.0
	await process_frame
	sc._scroll_mode = true
	sc._world.scale = Vector2(sc.READABLE_SCALE, sc.READABLE_SCALE)
	sc._focus_cell(sc.manager.hero_pos(), false)
	var hp: Vector2 = sc._world.position + sc.cell_center(sc.manager.hero_pos()) * sc._world.scale.x
	check(Rect2(Vector2.ZERO, v.size).grow(2.0).has_point(hp), "le héros est visible après recentrage")
	# Glisser : déplace la caméra, borné au plateau, et n'est pas pris pour un appui
	var before: Vector2 = sc._world.position
	var press := InputEventScreenTouch.new()
	press.pressed = true
	press.position = Vector2(200, 200)
	check(not sc._handle_pan(press), "appui : non consommé")
	var drag := InputEventScreenDrag.new()
	drag.position = Vector2(240, 200)
	drag.relative = Vector2(40, 0)
	var consumed: bool = sc._handle_pan(drag)
	check(consumed, "glissement : consommé")
	check(sc._world.position != before, "la caméra a bougé")
	var rel := InputEventScreenTouch.new()
	rel.pressed = false
	check(sc._handle_pan(rel), "relâchement après glissement : appui ignoré")
	var press2 := InputEventScreenTouch.new()
	press2.pressed = true
	sc._handle_pan(press2)
	var tap_rel := InputEventScreenTouch.new()
	tap_rel.pressed = false
	check(not sc._handle_pan(tap_rel), "appui sans glissement : traité comme un appui sur une case")
	# Bornes : impossible de sortir du plateau
	var far: Vector2 = sc._clamp_cam(Vector2(99999, 99999))
	var b: Rect2 = sc._world_bounds()
	check(far.x <= -b.position.x * sc._world.scale.x + 0.01 and far.y <= -b.position.y * sc._world.scale.y + 0.01, "caméra bornée (haut-gauche)")
	var far2: Vector2 = sc._clamp_cam(Vector2(-99999, -99999))
	check(far2.x >= v.size.x - (b.position.x + b.size.x) * sc._world.scale.x - 0.01, "caméra bornée (bas-droite)")
	pm.delete_save(4)
	print("")
	print("OK : tous les tests passent." if fails == 0 else "ÉCHEC : %d" % fails)
	quit(1 if fails > 0 else 0)
