extends SceneTree
## xvfb-run -a -s "-screen 0 1920x1080x24" godot --rendering-method gl_compatibility --rendering-driver opengl3 --path . -s tests/shot_saveslots.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "Ma partie")
	data["difficulty"] = 2
	HeroUnlock.pick_initial(data, ["Tank", "Mage", "Heal"])
	pm.write_save(4, data)
	var sc: Node = (load("res://scenes/SaveSlots.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(0.8).timeout
	root.get_viewport().get_texture().get_image().save_png(out + "/saveslots.png")
	# V48 : fenêtre de suppression agrandie
	sc._modal("Supprimer la partie", "Supprimer « Ma partie » ?\nLa progression et l'inventaire seront définitivement perdus.", [
		["Annuler", Color(0.45, 0.40, 0.32), Callable()], ["SUPPRIMER", Color(0.70, 0.18, 0.12), Callable()]])
	await create_timer(0.4).timeout
	root.get_viewport().get_texture().get_image().save_png(out + "/saveslots_modal.png")
	pm.delete_save(4)
	quit()
