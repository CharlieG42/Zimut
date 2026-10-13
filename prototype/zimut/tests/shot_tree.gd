extends SceneTree
## Capture : combat avec l'arbre du Sylvain posé.
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var gm: Node = root.get_node("GameManager")
	var pm: Node = root.get_node("ProgressionManager")
	var data: Dictionary = pm.new_game(4, "Tree")
	pm.rebuild_team(data, ["Tank", "Mage", "Sylvain"])
	for c in ["Tank", "Mage", "Sylvain"]:
		pm.roster_entry(data, c)["level"] = 12
	gm.active_save = data
	gm.active_slot = 4
	gm.set_custom_team([{"classe": "Tank"}, {"classe": "Mage"}, {"classe": "Sylvain"}])
	gm.auto_mode = false
	var main: Node = (load("res://scenes/Main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await create_timer(1.5).timeout
	var syl: Dictionary = {}
	for p: Dictionary in gm.players:
		if p["classe"] == "Sylvain":
			syl = p
	var spos: Vector2i = gm.pos_of(syl)
	var cell := Vector2i(spos.x + 1, spos.y + 1)
	if not gm.is_free(cell):
		cell = Vector2i(spos.x - 1, spos.y + 1)
	var spell: Dictionary = {}
	for sp in syl["spells"]:
		if sp["name"] == "Invoquer Arbre":
			spell = sp
	gm._resolve_summon(syl, spell, Combat.parse(spell), cell)
	await create_timer(2.0).timeout
	root.get_viewport().get_texture().get_image().save_png("/tmp/tree.png")
	pm.delete_save(4)
	quit(0)
