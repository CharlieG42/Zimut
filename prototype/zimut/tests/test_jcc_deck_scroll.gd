extends SceneTree
## Constructeur de deck : glisser n'importe où dans la zone des cartes fait défiler (sans sélectionner),
## un simple toucher sélectionne la carte.
## Lancement : godot --headless --path . -s tests/test_jcc_deck_scroll.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	if not c:
		print("  ÉCHEC  " + m)
		fails += 1
func _init() -> void:
	_boot.call_deferred()

func _mouse(pos: Vector2, pressed: bool) -> InputEventMouseButton:
	var e := InputEventMouseButton.new()
	e.button_index = MOUSE_BUTTON_LEFT
	e.pressed = pressed
	e.position = pos
	e.global_position = pos
	return e

func _boot() -> void:
	root.size = Vector2i(1920, 1080)
	await create_timer(0.5).timeout
	var pm = root.get_node("ProgressionManager")
	pm.write_save(3, pm.new_game(3, "Scroll"))
	var save: Dictionary = pm.load_save(3)
	var b := CardDeckBuilder.new()
	root.add_child(b)
	b.open(save)
	await create_timer(0.5).timeout
	var sc: ScrollContainer = b._scroll
	check(sc.get_v_scroll_bar().max_value > 300, "la collection dépasse la zone visible (max %d)" % int(sc.get_v_scroll_bar().max_value))
	# glissement en partant du milieu d'une carte (pas de la scrollbar)
	var start := sc.global_position + Vector2(100, 300)
	root.push_input(_mouse(start, true))
	await process_frame
	for i in 6:
		var mm := InputEventMouseMotion.new()
		mm.position = start + Vector2(0, -40 * (i + 1))
		mm.global_position = mm.position
		mm.relative = Vector2(0, -40)
		mm.button_mask = MOUSE_BUTTON_MASK_LEFT
		root.push_input(mm)
		await process_frame
	root.push_input(_mouse(start + Vector2(0, -240), false))
	await process_frame
	check(sc.scroll_vertical > 150, "glisser dans la zone fait défiler (scroll=%d)" % sc.scroll_vertical)
	check(b._selected == "", "un glissement ne sélectionne pas de carte")
	await create_timer(0.2).timeout
	# toucher simple : sélectionne
	sc.scroll_vertical = 0
	await process_frame
	var tp := sc.global_position + Vector2(80, 120)
	root.push_input(_mouse(tp, true))
	await process_frame
	root.push_input(_mouse(tp, false))
	await process_frame
	check(b._selected != "", "un toucher simple sélectionne la carte")
	print("FIN : %d échec(s)" % fails)
	quit(1 if fails > 0 else 0)
