extends SceneTree
## Outil de diagnostic : joue des combats manuels (fin de tour immédiate / sorts au hasard) et
## surveille à chaque image que la barre de sorts et la timeline restent visibles.
var anomalies: Dictionary = {}
var frames: int = 0
func _init() -> void:
	_boot.call_deferred()
func _viol(ui: CanvasLayer, what: String) -> void:
	if not anomalies.has(what):
		anomalies[what] = frames
		print("ANOMALIE '%s' à l'image %d" % [what, frames])
func _boot() -> void:
	var args: PackedStringArray = OS.get_cmdline_user_args()
	var fights: int = int(args[0]) if args.size() > 0 else 3
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	Engine.time_scale = 4.0
	for f: int in range(fights):
		var data: Dictionary = pm.new_game(4, "Mon")
		pm.rebuild_team(data, ["Tank", "Mage", "Sylvain"])
		data["victories"] = f * 2
		gm.active_save = data
		gm.active_slot = 4
		gm.set_custom_team([{"classe": "Tank"}, {"classe": "Mage"}, {"classe": "Sylvain"}])
		gm.auto_mode = false
		var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
		root.add_child(main)
		await create_timer(0.5).timeout
		var ui: CanvasLayer = main.get_node("UIManager")
		var t0: int = Time.get_ticks_msec()
		while not gm.game_over and Time.get_ticks_msec() - t0 < 120000:
			await process_frame
			frames += 1
			# joueur : lance un sort au hasard puis termine le tour
			var e: Dictionary = gm.active_entity
			if not e.is_empty() and String(e.get("entity_type", "")) == "Player" and gm.current_turn == 0 and randf() < 0.05:
				for s: Dictionary in e["spells"]:
					if gm.can_afford(e, s) and gm.casts_left(e, s) > 0:
						var cs: Array = gm.enemies
						if not cs.is_empty():
							gm.cast_spell(e, s, gm.pos_of(cs[0]))
						break
				gm.next_player()
			var vs: Vector2 = root.get_visible_rect().size
			if not ui.visible: _viol(ui, "ui.visible")
			if not ui._root.visible: _viol(ui, "root.visible")
			if ui._root.size.distance_to(vs) > 2.0: _viol(ui, "root.size %s vs %s" % [ui._root.size, vs])
			if not ui._spell_scroll.is_visible_in_tree(): _viol(ui, "spell_scroll hidden")
			if not ui._timeline_scroll.is_visible_in_tree(): _viol(ui, "timeline hidden")
			if ui._spell_scroll.size.y < 100.0: _viol(ui, "spell_scroll h=%d" % int(ui._spell_scroll.size.y))
			if ui._timeline_scroll.size.y < 100.0: _viol(ui, "timeline h=%d" % int(ui._timeline_scroll.size.y))
			if ui._spell_box.get_child_count() == 0: _viol(ui, "spell_box vide")
			if ui._spell_scroll.modulate.a < 0.99: _viol(ui, "spell_scroll alpha")
			if ui._timeline.size.y < 50.0: _viol(ui, "timeline content h=%d" % int(ui._timeline.size.y))
			if ui._timeline_scroll.scroll_vertical > 0 and ui._timeline.size.y <= ui._timeline_scroll.size.y: _viol(ui, "timeline scrollée alors que rien à scroller")
			if not gm.turn_order.is_empty() and ui._timeline.get("_last_count") != null: pass
		print("combat %d fini (game_over=%s) images=%d" % [f, str(gm.game_over), frames])
		main.queue_free()
		await process_frame
	print("ANOMALIES: ", anomalies)
	pm.delete_save(4)
	quit(0)
