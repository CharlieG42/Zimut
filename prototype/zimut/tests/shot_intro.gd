extends SceneTree
## Captures de l'animation d'ouverture (V52). Usage : -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var dir: String = OS.get_cmdline_user_args()[0] if OS.get_cmdline_user_args().size() > 0 else "/tmp"
	var sc: Node = (load("res://scenes/Intro.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	var t: float = 0.0
	for mark: float in [0.8, 1.75, 2.6]:
		await create_timer(mark - t).timeout
		t = mark
		root.get_viewport().get_texture().get_image().save_png("%s/intro_%d.png" % [dir, int(mark * 100)])
	quit()
