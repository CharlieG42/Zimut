extends SceneTree
## Captures V75 : fenêtre des nouveautés (menu) puis combat manuel avec un sort sélectionné (infobulle).
## xvfb-run -a -s "-screen 0 1920x1080x24" godot --rendering-method gl_compatibility --path . -s tests/shot_ameliorations.gd -- /tmp/shots
func _init() -> void:
	_boot.call_deferred()
func _shot(p: String) -> void:
	root.get_viewport().get_texture().get_image().save_png(p)
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0] if OS.get_cmdline_user_args().size() > 0 else "/tmp/shots"
	DirAccess.make_dir_recursive_absolute(out)
	var gs: Node = root.get_node("GameSettings")
	gs.changelog_seen = ""
	var menu: Node = (load("res://scenes/MainMenu.tscn") as PackedScene).instantiate()
	root.add_child(menu)
	await create_timer(1.2).timeout
	_shot(out + "/nouveautes.png")
	gs.mark_changelog_seen("")
	menu.queue_free()
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "Shots")
	pm.rebuild_team(data, ["Mage", "Tank", "Heal"])
	var e: Dictionary = pm.roster_entry(data, "Mage")
	e["level"] = 40
	e["spell_levels"] = {"Boule de feu": 3}
	gm.active_save = data
	gm.active_slot = 4
	gm.set_custom_team([{"classe": "Mage"}, {"classe": "Tank"}, {"classe": "Heal"}])
	gm.auto_mode = false
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await create_timer(2.0).timeout
	var caster: Dictionary = gm.active_entity
	for s: Dictionary in caster.get("spells", []):
		if int(s.get("cost_pa", 9)) <= 4 and Combat.parse(s)["kind"] == "attack":
			gm.handle_spell_selected(s)
			break
	await create_timer(0.8).timeout
	_shot(out + "/infobulle.png")
	pm.delete_save(4)
	quit(0)
