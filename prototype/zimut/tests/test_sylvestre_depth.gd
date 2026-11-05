extends SceneTree
## Vérifie le premier passage de profondeur de la planche Sylvestre.
## Ces contrôles portent sur le rendu uniquement : aucune donnée de terrain n'est modifiée.

var fails: int = 0

func check(condition: bool, message: String) -> void:
	print(("  ok  " if condition else "  ÉCHEC  ") + message)
	if not condition:
		fails += 1

func _init() -> void:
	_run.call_deferred()

func _run() -> void:
	var ui_path := "res://scripts/AdventureMapUI.gd"
	var ui: String = FileAccess.get_file_as_string(ui_path)
	var tree_path := "res://assets/boards/sylvestre_foreground_tree.svg"
	check(ResourceLoader.exists(tree_path), "asset de premier plan Sylvestre présent")
	var tree_texture: Texture2D = load(tree_path) as Texture2D
	check(tree_texture != null, "asset de premier plan importable comme texture")
	check(ui.contains('if zid == "foret_sylve":') and ui.contains("SylvestreForegroundTree"),
		"les arbres de premier plan sont limités à la planche Sylvestre")
	check(ui.contains('Vector2i(34, 47)') and ui.contains('Vector2i(64, 47)'),
		"les deux arbres sont ancrés hors du masque jouable")
	check(ui.contains('tree.offset = Vector2(0, -88)') and ui.contains('tree.position = cell_center(tree_cell)'),
		"l'origine de chaque arbre reste à son pied pour le Y-sort")
	check(ui.contains('_hero.sprite_height = 118.0') and ui.contains('_hero.forest_style = true'),
		"le héros Sylvestre bénéficie d'une silhouette plus lisible")
	check(ui.contains('if manager.zone_id() == "foret_sylve":') and ui.contains('lerpf(0.94, 1.18, depth)'),
		"la variation d'échelle de profondeur est limitée à Sylvestre")
	check(ui.contains('if forest_style:') and ui.contains('Color(0.72, 0.91, 0.48, 0.68)'),
		"l'ombre et le repère au sol adoptent une teinte forestière")
	quit(fails)
