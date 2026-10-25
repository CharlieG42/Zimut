extends SceneTree
## Capture d'une réplique de Gultur (la plus longue du choix des héros). Usage : -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var dir: String = OS.get_cmdline_user_args()[0] if OS.get_cmdline_user_args().size() > 0 else "/tmp"
	var gs: Node = root.get_node("GameSettings")
	gs.restart_tutorial()
	var bg := ColorRect.new()
	bg.color = Color(0.2, 0.25, 0.3)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(bg)
	var longest: String = ""
	for l in Gultur.PICK:
		if String(l).length() > longest.length():
			longest = String(l)
	var g: Gultur = Gultur.say(root, "shot_pick", [longest], null)
	await create_timer(4.0).timeout
	root.get_viewport().get_texture().get_image().save_png(dir + "/gultur_pick.png")
	gs.skip_tutorial()
	quit()
