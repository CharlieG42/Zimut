extends SceneTree
## Fiche Personnage : onglet Sorts de l'Ingénieur (niveau 10, points non dépensés) et de l'Invocateur.
## xvfb-run -a -s "-screen 0 1920x1080x24" godot --rendering-method gl_compatibility --path . -s tests/shot_fiche_ingenieur.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "Fiche")
	pm.rebuild_team(data, ["Invocateur", "Géomancien", "Artificier"])
	data.erase("heroes_unlocked")        # tous les héros visibles
	var e: Dictionary = pm.roster_entry(data, "Artificier")
	e["level"] = 10
	e["xp"] = pm.xp_for_level(10)
	e["unspent"] = 12
	e["spell_points"] = 12
	var e2: Dictionary = pm.roster_entry(data, "Invocateur")
	e2["level"] = 4
	e2["spell_levels"] = {"Lien d'âme": 3, "Symbiose": 2}
	pm.write_save(4, data)
	var ui: CanvasLayer = (load("res://scripts/CharacterSheetUI.gd") as GDScript).new()
	ui.layer = 10
	root.add_child(ui)
	ui.open(data, 4, "Artificier")
	ui._tab = "spells"
	ui.refresh()
	await create_timer(0.8).timeout
	root.get_viewport().get_texture().get_image().save_png(out + "/fiche_ingenieur.png")
	ui.open(data, 4, "Invocateur")
	ui._tab = "spells"
	ui.refresh()
	await create_timer(0.6).timeout
	root.get_viewport().get_texture().get_image().save_png(out + "/fiche_invocateur.png")
	pm.delete_save(4)
	quit()
