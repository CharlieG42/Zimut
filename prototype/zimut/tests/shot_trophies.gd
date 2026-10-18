extends SceneTree
## Captures Succès / Bestiaire.
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0] if OS.get_cmdline_user_args().size() > 0 else "/tmp/tro"
	DirAccess.make_dir_recursive_absolute(out)
	var pm: Node = root.get_node("ProgressionManager")
	var d: Dictionary = pm.new_game(4, "Trophées")
	pm.rebuild_team(d, ["Tank", "Mage", "Heal"])
	pm.register_victory(d, {"enemies": [{"type": "Loup", "level": 1, "boss": false}], "turns": 3, "boss": false, "deaths": 0})
	for biome in ["Forêt", "Montagne", "Désert"]:
		for t in ["Loup", "Gobelin", "Squelette", "Troll", "Dragonnet"]:
			Achievements.bestiary_seen(d, {"team": "enemy", "name": "%s Lv5" % t, "classe": t, "level": 5, "max_pv": 140, "force": 22, "defense": 6, "max_pm": 3, "spells": [{"name": "Morsure"}, {"name": "Hurlement"}]}, biome)
	var ui: CanvasLayer = (load("res://scripts/TrophyUI.gd") as GDScript).new()
	root.add_child(ui)
	ui.open(d, "succes")
	await create_timer(0.8).timeout
	root.get_viewport().get_texture().get_image().save_png(out + "/succes.png")
	ui._tab = "bestiaire"
	ui.refresh()
	await create_timer(0.8).timeout
	root.get_viewport().get_texture().get_image().save_png(out + "/bestiaire.png")
	pm.delete_save(4)
	quit(0)
