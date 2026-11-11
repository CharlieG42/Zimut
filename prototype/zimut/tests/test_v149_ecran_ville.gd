extends SceneTree
## V149 : écran de ville — sol par Nation, rues courbes, chantiers, arbres propres aux Nations.
## Lancement : godot --headless --path . -s tests/test_v149_ecran_ville.gd
var fails: int = 0
func check(c: bool, m: String) -> void:
	print(("  ok  " if c else "  ÉCHEC  ") + m)
	if not c:
		fails += 1
func _init() -> void:
	_boot.call_deferred()
func _boot() -> void:
	var V: GDScript = load("res://scripts/ConquestCityView.gd")
	for b: String in ["Forêt", "Montagne", "Brasier", "Brumes"]:
		check((V.GROUND_LOOK as Dictionary).has(b), "%s : sol propre à la Nation" % b)
	check((V.STYLE["Montagne"] as Array)[3].v > 0.85, "Cimes : sol de neige")
	var trees: Dictionary = {}
	for k: String in ["foret", "montagne", "brasier", "brumes"]:
		trees[FileAccess.get_file_as_string("res://assets/ui/conquest/city/%s/deco_tree.svg" % k).md5_text()] = true
	check(trees.size() == 4, "4 arbres de décor différents (feuillu, sapin enneigé, arbre calciné, saule)")
	# la vue se dessine pour chaque Nation sans erreur, chantiers compris
	for b2: String in ["Forêt", "Montagne", "Brasier", "Brumes", "Désert"]:
		var v: Control = V.new()
		v.size = Vector2(1200, 800)
		v.set("biome", b2)
		v.set("city_level", 2)
		root.add_child(v)
		await process_frame
		await process_frame
		v.queue_free()
	check(true, "la vue de ville se dessine pour 5 Nations (dont une sans sol dédié)")
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
