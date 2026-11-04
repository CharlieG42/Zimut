extends SceneTree
## Vérifie que les scènes des modes se chargent et que les vues Aventure sont indépendantes.
var fails: int = 0

func check(ok: bool, message: String) -> void:
	print(("  ok  " if ok else "  ÉCHEC  ") + message)
	if not ok:
		fails += 1


func _board_cell_reachable(mask: Array, start: Vector2i, target: Vector2i) -> bool:
	var queue: Array[Vector2i] = [start]
	var visited: Dictionary = {start: true}
	var head: int = 0
	while head < queue.size():
		var current: Vector2i = queue[head]
		head += 1
		if current == target:
			return true
		for direction: Vector2i in [Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT, Vector2i.UP]:
			var next: Vector2i = current + direction
			if next.y < 0 or next.y >= mask.size():
				continue
			var row: String = String(mask[next.y])
			if next.x < 0 or next.x >= row.length() or row.substr(next.x, 1) != "#":
				continue
			if visited.has(next):
				continue
			visited[next] = true
			queue.append(next)
	return false

func _check_sylvestre_board_connectivity() -> void:
	var raw: String = FileAccess.get_file_as_string("res://data/boards/foret_sylve.json")
	check(not raw.is_empty(), "la définition de la planche Sylvestre est présente")
	if raw.is_empty():
		return
	var data: Dictionary = JSON.parse_string(raw)
	var mask: Array = data.get("mask", [])
	var start_data: Array = data.get("start", [])
	if mask.is_empty() or start_data.size() < 2:
		check(false, "la planche Sylvestre possède un masque et un départ valides")
		return
	var start := Vector2i(int(start_data[0]), int(start_data[1]))
	check(_board_cell_reachable(mask, start, start), "la case de départ est praticable")
	var pois: Dictionary = data.get("pois", {})
	var disconnected: Array[String] = []
	for key: String in pois.keys():
		var xy: PackedStringArray = key.split(",")
		if xy.size() != 2:
			disconnected.append(key + " (coordonnées invalides)")
			continue
		var target := Vector2i(int(xy[0]), int(xy[1]))
		if not _board_cell_reachable(mask, start, target):
			disconnected.append(String(pois[key].get("name", key)))
	check(disconnected.is_empty(), "tous les lieux et donjons Sylvestre sont reliés au départ" +
		(" — bloqués : " + ", ".join(disconnected) if not disconnected.is_empty() else ""))

func _init() -> void:
	_boot.call_deferred()

func _boot() -> void:
	var scripts: Array[String] = [
		"res://scripts/AdventureMapUI.gd",
		"res://scripts/adventure3d/Adventure3D.gd",
		"res://scripts/adventure3d/AdventureOpen3D.gd",
		"res://scripts/SaveSlotsUI.gd",
		"res://scripts/SettingsUI.gd",
		"res://scripts/ConquestMapUI.gd",
	]
	for path: String in scripts:
		check(load(path) is GDScript, "script chargé : " + path)

	var slots: String = FileAccess.get_file_as_string("res://scripts/SaveSlotsUI.gd")
	check(slots.contains('"2D"') and slots.contains('"res://scenes/AdventureMap.tscn"'),
		"Mes Parties lance explicitement la carte 2D")
	check(slots.contains('"3D"') and slots.contains('"res://scenes/AdventureOpen3D.tscn"'),
		"Mes Parties lance explicitement le monde 3D")
	check(slots.contains('"adventure_view"] = "map"') and slots.contains('"adventure_view"] = "open3d"'),
		"chaque mode mémorise sa propre vue")

	var map_ui: String = FileAccess.get_file_as_string("res://scripts/AdventureMapUI.gd")
	check(map_ui.contains('back.pressed.connect(_back_to_save)') and map_ui.contains('← MES PARTIES'),
		"la carte 2D propose le retour à Mes Parties")
	var board_start: int = map_ui.find("class AdventureBoard extends Node2D:")
	var hero_start: int = map_ui.find("class HeroView extends Node2D:")
	var board_code: String = map_ui.substr(board_start, hero_start - board_start)
	check(not board_code.contains("walking") and not board_code.contains("_gait_t"),
		"AdventureBoard ne référence plus les variables de HeroView")

	var open3d: String = FileAccess.get_file_as_string("res://scripts/adventure3d/AdventureOpen3D.gd")
	check(not open3d.contains("_switch_view(") and not open3d.contains("Carte 2D") and not open3d.contains("Vue 3D iso"),
		"le monde 3D ne propose plus de bascule vers une autre vue")
	check(open3d.contains('res://scenes/SaveSlots.tscn') and open3d.contains("Mes Parties"),
		"le monde 3D conserve le retour à Mes Parties")

	var iso3d: String = FileAccess.get_file_as_string("res://scripts/adventure3d/Adventure3D.gd")
	check(not iso3d.contains('"Carte classique"') and iso3d.contains('res://scenes/SaveSlots.tscn'),
		"la vue 3D isométrique ne propose plus de bascule vers la carte 2D et garde son retour menu")

	var settings: String = FileAccess.get_file_as_string("res://scripts/SettingsUI.gd")
	check(not settings.contains('"Mode Aventure"'), "le choix 2D/3D n'est plus un réglage global")

	check(map_ui.contains('"SAC DE RESSOURCES"') and map_ui.contains('_save.get("resources", {})'),
		"la carte 2D affiche les ressources de la sauvegarde commune")
	check(open3d.contains('_resource_label') and open3d.contains('save.get("resources", {})'),
		"le monde ouvert 3D affiche les ressources de la sauvegarde commune")
	var manager: String = FileAccess.get_file_as_string("res://scripts/AdventureManager.gd")
	check(manager.contains('ProgressionManager.add_resources(save, res)'),
		"les récoltes d’exploration alimentent l’inventaire de ressources partagé")

	_check_sylvestre_board_connectivity()
	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
