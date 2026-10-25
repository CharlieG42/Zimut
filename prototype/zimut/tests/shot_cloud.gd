extends SceneTree
## Captures V49 : Options avec la sauvegarde Cloud + fenêtre du code Google. Usage : -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var dir: String = OS.get_cmdline_user_args()[0] if OS.get_cmdline_user_args().size() > 0 else "/tmp"
	var sc: Node = (load("res://scenes/Settings.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(0.6).timeout
	root.get_viewport().get_texture().get_image().save_png(dir + "/options_cloud.png")
	sc._show_code("KQBX-RTWM", "https://www.google.com/device")
	await create_timer(0.4).timeout
	root.get_viewport().get_texture().get_image().save_png(dir + "/options_code.png")
	quit()
