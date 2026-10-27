extends SceneTree
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var out: String = OS.get_cmdline_user_args()[0]
	var sc: Node = (load("res://scenes/SaveSlots.tscn") as PackedScene).instantiate()
	root.add_child(sc)
	await create_timer(0.5).timeout
	sc._prompt_pseudo(0)
	await create_timer(0.5).timeout
	root.get_viewport().get_texture().get_image().save_png(out + "/pseudo.png")
	quit()
