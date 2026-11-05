extends SceneTree
## Vérifie que la carte Sylvestre conserve son illustration complète et lisible.

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
	check(not ui.contains("_add_sylvestre_overlay"), "aucune couche plein cadre superposée à la planche")
	check(not ui.contains("SylvestreForegroundCanopy"), "aucune canopée opaque ne masque le plateau")
	check(not ui.contains("SylvestreForegroundTree_"), "aucun arbre décoratif flottant ne recouvre la carte")
	check(ui.contains('spr.z_index = 0') and ui.contains('_board.z_index = 1')
		and ui.contains('_entities.z_index = 2'), "ordre de rendu de la planche et des entités rétabli")
	var board_text: String = FileAccess.get_file_as_string("res://data/boards/foret_sylve.json")
	var board_data: Dictionary = JSON.parse_string(board_text)
	check(board_data.get("image", "") == "res://assets/boards/Sylvestre.png",
		"la planche originale Sylvestre reste la seule base visuelle")
	if fails > 0:
		push_error("ÉCHEC : %d contrôle(s) Sylvestre" % fails)
		quit(1)
	else:
		print("Tous les contrôles de lisibilité Sylvestre sont réussis.")
		quit(0)
