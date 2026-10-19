extends SceneTree
## Capture : fenêtre Options (V34 : vitesse des animations).
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0] if OS.get_cmdline_user_args().size() > 0 else "/tmp/shots"
	root.add_child((load("res://scenes/Settings.tscn") as PackedScene).instantiate())
	await create_timer(0.8).timeout
	root.get_viewport().get_texture().get_image().save_png(out + "/options.png")
	quit()
