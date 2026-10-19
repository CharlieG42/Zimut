extends SceneTree
## Capture V30 : coup reçu (recul + bascule) puis chute au K.O. d'un ennemi.
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var dir: String = OS.get_cmdline_user_args()[0] if OS.get_cmdline_user_args().size() > 0 else "/tmp/shots"
	var gm: Node = root.get_node("GameManager")
	gm.set_custom_team([{"classe": "Tank"}, {"classe": "Mage"}, {"classe": "Artificier"}])
	gm.auto_mode = false
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await create_timer(1.5).timeout
	var views: Array = root.find_children("*", "Node2D", true, false).filter(func(n): return n is EntityView)
	var foe: EntityView = null
	var hero: EntityView = null
	for v in views:
		if String(v.entity.get("team", "")) == "enemy" and foe == null:
			foe = v
		if String(v.entity.get("team", "")) == "player" and hero == null:
			hero = v
	foe.hit_react(1.6, hero.position)
	await create_timer(0.06).timeout
	root.get_viewport().get_texture().get_image().save_png(dir + "/anim_hit.png")
	await create_timer(0.6).timeout
	foe.die()
	await create_timer(0.36).timeout
	root.get_viewport().get_texture().get_image().save_png(dir + "/anim_ko.png")
	print("foe at ", foe.global_position)
	quit(0)
