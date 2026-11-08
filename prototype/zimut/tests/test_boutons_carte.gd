extends SceneTree
## V115 — Tous les boutons de la carte d'aventure (et des Réglages) sont branchés, visibles et cliquables :
## aucun bouton n'est recouvert par le joystick, l'aide ou un autre bouton ; zoom / recentrage agissent vraiment.
## Lancement : godot --headless --path . -s tests/test_boutons_carte.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1

func _init() -> void:
	_boot.call_deferred()

func _wired(b: BaseButton) -> bool:
	for sig: String in ["pressed", "toggled", "button_down", "button_up", "item_selected"]:
		if b.has_signal(sig) and not b.get_signal_connection_list(sig).is_empty():
			return true
	return not b.get_signal_connection_list("gui_input").is_empty()

func _all_buttons(n: Node, acc: Array) -> void:
	if n is BaseButton:
		acc.append(n)
	for c in n.get_children():
		_all_buttons(c, acc)

func _boot() -> void:
	var pm: Node = root.get_node("/root/ProgressionManager")
	var gm: Node = root.get_node("/root/GameManager")
	var gs: Node = root.get_node("/root/GameSettings")
	var before: String = gs.sylvestre_board
	for variant: String in ["diorama", "v2"]:
		gs.set_sylvestre_board(variant)
		var data: Dictionary = pm.new_game(4, "TestBoutons")
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
		var tag := "[%s] " % variant
		# boutons de la carte forcés visibles pour vérifier leur disposition
		var hud: Array[Control] = [sc._recenter_btn, sc._zoom_in_btn, sc._zoom_out_btn, sc._action_btn, sc._joystick]
		for c: Control in hud:
			c.visible = true
		await process_frame
		var rects: Array[Rect2] = []
		for c: Control in hud:
			rects.append(c.get_global_rect())
		var overlap: Array = []
		for i in range(hud.size()):
			for j in range(i + 1, hud.size()):
				if rects[i].grow(-2).intersects(rects[j].grow(-2)):
					overlap.append("%s/%s" % [hud[i].name if hud[i].name != "" else str(i), hud[j].name if hud[j].name != "" else str(j)])
		check(overlap.is_empty(), tag + "aucun chevauchement entre Centrer, +, −, action et joystick %s" % [overlap])
		var help: Control = sc._help_panel
		var under_help: bool = help.get_global_rect().grow(-2).intersects(rects[1]) or help.get_global_rect().grow(-2).intersects(rects[2])
		check(not under_help, tag + "les boutons de zoom ne sont plus sous l'aide")
		var view: Rect2 = sc._map_view.get_global_rect()
		var inside := true
		for r: Rect2 in rects:
			inside = inside and view.encloses(r)
		check(inside, tag + "tous les boutons dans la vue de la carte")
		# zoom et recentrage agissent
		var s0: float = sc._world.scale.x
		sc._zoom_in_btn.pressed.emit()
		var s1: float = sc._world.scale.x
		sc._zoom_out_btn.pressed.emit()
		sc._zoom_out_btn.pressed.emit()
		var s2: float = sc._world.scale.x
		check(s1 > s0 and s2 < s1, tag + "zoom + / − (%.2f → %.2f → %.2f)" % [s0, s1, s2])
		sc._world.position += Vector2(900, 700)
		sc._recenter_btn.pressed.emit()
		await create_timer(0.8).timeout
		var hero_screen: Vector2 = sc._world.position + sc._hero.position * sc._world.scale.x
		var mid: Vector2 = sc._map_view.size * 0.5
		check(hero_screen.distance_to(mid) < 160.0, tag + "« Centrer » ramène le héros au centre (écart %d px)" % int(hero_screen.distance_to(mid)))
		# tous les boutons de l'écran sont branchés
		var btns: Array = []
		_all_buttons(sc, btns)
		var dead: Array = []
		for b: BaseButton in btns:
			if not _wired(b):
				dead.append("%s « %s »" % [b.name, (b as Button).text if b is Button else ""])
		check(dead.is_empty(), tag + "%d boutons, tous branchés %s" % [btns.size(), dead])
		if variant == "diorama":
			sc._dio_sync = true
			sc._diorama_stream()
			var loaded := 0
			for ch: Dictionary in sc._dio_chunks:
				loaded += 1 if ((ch["sprites"] as Array)[0] as Sprite2D).texture != null else 0
			check(loaded > 0 and loaded < sc._dio_chunks.size(), tag + "chargement à la demande : %d morceaux sur %d en mémoire" % [loaded, sc._dio_chunks.size()])
		sc.queue_free()
		await process_frame
		pm.delete_save(4)
	# Réglages : chaque bouton branché
	var opt: Node = (load("res://scenes/Settings.tscn") as PackedScene).instantiate()
	root.add_child(opt)
	await create_timer(0.3).timeout
	var ob: Array = []
	_all_buttons(opt, ob)
	var odead: Array = []
	for b: BaseButton in ob:
		if not _wired(b):
			odead.append("%s « %s »" % [b.name, (b as Button).text if b is Button else ""])
	check(odead.is_empty(), "Réglages : %d boutons, tous branchés %s" % [ob.size(), odead])
	opt.queue_free()
	gs.set_sylvestre_board(before)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
