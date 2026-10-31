extends SceneTree
## Capture V63 : bombes à niveaux et barrière de Couplage de l'Ingénieur (Artificier).
##   xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_ingenieur_v63.gd -- <dossier>
func _init() -> void:
	_boot.call_deferred()
func _sp(c: Dictionary, nm: String) -> Dictionary:
	for s: Dictionary in c["spells"]:
		if String(s["name"]) == nm:
			return s
	return {}
func _boot() -> void:
	var dir: String = OS.get_cmdline_user_args()[0]
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	root.get_node("GameSettings").tutorial_enabled = false
	var data: Dictionary = pm.new_game(4, "IngShot")
	pm.rebuild_team(data, ["Artificier", "Tank", "Mage"])
	data["adventure"] = {"zone": "rouages_atelier"}
	data["campaign_mode"] = "adventure"
	gm.active_save = data
	gm.active_slot = 4
	gm.set_custom_team([{"classe": "Artificier"}, {"classe": "Tank"}, {"classe": "Mage"}])
	gm.auto_mode = false
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await create_timer(1.5).timeout
	var art: Dictionary = {}
	for p: Dictionary in gm.players:
		if String(p["classe"]) == "Artificier":
			art = p
	art["spells"] = gm._build_spells("Artificier", 70)
	art["current_pa"] = 60
	art["level"] = 70
	var gp: Vector2i = gm.pos_of(art)
	var bomb: Dictionary = _sp(art, "Poser Bombe")
	var link: Dictionary = _sp(art, "Couplage")
	# deux bombes alignées à 3 cases d'écart, couplées
	var pair: Array = []
	for r: int in range(1, 4):
		for d: Vector2i in [Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(0, -1)]:
			var a: Vector2i = gp + d * r
			var side := Vector2i(-d.y, d.x)
			var c1: Vector2i = a - side * 2
			var c2: Vector2i = a + side * 2
			if pair.is_empty() and gm.validate_cast(art, bomb, c1) == "" and gm.validate_cast(art, bomb, c2) == "":
				pair = [c1, c2]
	if not pair.is_empty():
		for c: Vector2i in pair:
			art["casts"] = {}
			gm.cast_spell(art, bomb, c)
		var b1: Dictionary = gm.entity_at(pair[0])
		b1["bomb_level"] = 3
		for c: Vector2i in pair:
			art["casts"] = {}
			gm.cast_spell(art, link, c)
	print("barrières : ", gm.barriers().size())
	await create_timer(1.6).timeout
	root.get_viewport().get_texture().get_image().save_png(dir + "/ingenieur_barriere.png")
	pm.delete_save(4)
	quit(0)
