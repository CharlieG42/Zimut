extends SceneTree
## V53 : le HUD de combat se répare seul si son conteneur est déformé
## (cause probable de la disparition aléatoire de la barre de sorts / timeline sur Android).
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "HudGuard")
	pm.rebuild_team(data, ["Tank", "Mage", "Sylvain"])
	gm.active_save = data
	gm.active_slot = 4
	gm.set_custom_team([{"classe": "Tank"}, {"classe": "Mage"}, {"classe": "Sylvain"}])
	gm.auto_mode = false
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await create_timer(1.0).timeout
	var ui: CanvasLayer = main.get_node("UIManager")
	var vs: Vector2 = root.get_visible_rect().size
	check(ui._spell_scroll.size.y > 100.0, "barre de sorts visible au départ (h=%d)" % int(ui._spell_scroll.size.y))
	check(ui._timeline_scroll.size.y > 100.0, "timeline visible au départ (h=%d)" % int(ui._timeline_scroll.size.y))
	# 1) conteneur écrasé
	ui._root.set_anchors_preset(Control.PRESET_TOP_LEFT)
	ui._root.size = Vector2(vs.x, 120.0)
	await process_frame
	check(ui._spell_scroll.size.y < 100.0, "(sabotage) barre écrasée")
	await create_timer(0.7).timeout
	check(ui._root.size.distance_to(vs) < 2.0, "conteneur rétabli")
	check(ui._spell_scroll.size.y > 100.0, "barre de sorts rétablie (h=%d)" % int(ui._spell_scroll.size.y))
	check(ui._timeline_scroll.size.y > 100.0, "timeline rétablie (h=%d)" % int(ui._timeline_scroll.size.y))
	# 2) offsets d'un bloc corrompus
	ui._spell_scroll.offset_bottom = 300.0
	ui._timeline_scroll.anchor_bottom = 0.0
	ui._timeline_scroll.offset_bottom = 10.0
	await create_timer(0.7).timeout
	check(ui._spell_scroll.size.y > 100.0, "barre rétablie après offsets corrompus")
	check(ui._timeline_scroll.size.y > 100.0, "timeline rétablie après ancrage corrompu")
	# 3) barre vidée
	for c: Node in ui._spell_box.get_children():
		c.free()
	await create_timer(0.7).timeout
	check(ui._spell_box.get_child_count() > 0, "barre de sorts reconstruite si vide")
	pm.delete_save(4)
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
