extends SceneTree
## Vérifie que les scènes des modes se chargent et que les vues Aventure sont indépendantes.
var fails: int = 0

func check(ok: bool, message: String) -> void:
	print(("  ok  " if ok else "  ÉCHEC  ") + message)
	if not ok:
		fails += 1

func _mask_path_exists(mask: Array, cols: int, from: Vector2i, to: Vector2i, blocked: Dictionary) -> bool:
	if from.x < 0 or from.y < 0 or from.x >= cols or from.y >= mask.size():
		return false
	if to.x < 0 or to.y < 0 or to.x >= cols or to.y >= mask.size():
		return false
	if String(mask[from.y])[from.x] != "#" or String(mask[to.y])[to.x] != "#":
		return false
	var queue: Array[Vector2i] = [from]
	var seen: Dictionary = {from: true}
	var head: int = 0
	while head < queue.size():
		var current: Vector2i = queue[head]
		head += 1
		if current == to:
			return true
		for direction: Vector2i in [Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(0, -1)]:
			var next: Vector2i = current + direction
			if next.x < 0 or next.y < 0 or next.x >= cols or next.y >= mask.size():
				continue
			if String(mask[next.y])[next.x] != "#" or blocked.has(next) or seen.has(next):
				continue
			seen[next] = true
			queue.append(next)
	return false

func _init() -> void:
	_boot.call_deferred()

func _boot() -> void:
	var scripts: Array[String] = [
		"res://scripts/AdventureMapUI.gd",
		"res://scripts/adventure3d/Adventure3D.gd",
		"res://scripts/adventure3d/AdventureOpen3D.gd",
		"res://scripts/SaveSlotsUI.gd",
		"res://scripts/SettingsUI.gd",
		"res://scripts/SceneryAmbient.gd",
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
	check(iso3d.contains('_resource_label') and iso3d.contains('save.get("resources", {})')
		and iso3d.contains('resources.keys()'),
		"la vue 3D isométrique affiche elle aussi les ressources de la sauvegarde commune")
	var manager: String = FileAccess.get_file_as_string("res://scripts/AdventureManager.gd")
	check(manager.contains('ProgressionManager.add_resources(save, res)'),
		"les récoltes d’exploration alimentent l’inventaire de ressources partagé")

	check(manager.contains('and pos != target') and manager.contains('not Dungeons.is_dungeon(poi)'),
		"les combats ordinaires bloquent le passage, mais les portes de donjon restent traversables")
	check(map_ui.contains('Dungeons.is_dungeon(poi) and step != path.back()'),
		"une porte de donjon intermédiaire ne déclenche pas son interaction")

	var board: Dictionary = JSON.parse_string(FileAccess.get_file_as_string("res://data/boards/foret_sylve.json"))
	var mask: Array = board.get("mask", [])
	check(mask.size() == int(board.get("rows", 0)), "masque Sylvestre : nombre de lignes conforme")
	var mask_valid: bool = true
	for row: String in mask:
		if row.length() != int(board.get("cols", 0)):
			mask_valid = false
	check(mask_valid, "masque Sylvestre : toutes les lignes ont la largeur attendue")
	var dungeon_cells: Array[String] = ["19,10", "76,11", "50,23", "16,32", "76,39"]
	var dungeons_on_walkable: bool = true
	for key: String in dungeon_cells:
		var xy: PackedStringArray = key.split(",")
		var x: int = int(xy[0])
		var y: int = int(xy[1])
		if y < 0 or y >= mask.size() or x < 0 or x >= String(mask[y]).length() or String(mask[y])[x] != "#":
			dungeons_on_walkable = false
	check(dungeons_on_walkable, "les cinq entrées de donjon Sylvestre sont placées sur des cases ouvertes")

	# Vérifie le chemin réel sur le masque, en appliquant les règles de blocage :
	# les combats ordinaires barrent le passage ; les donjons restent franchissables.
	var poi_data: Dictionary = board.get("pois", {})
	var start_xy: Array = board.get("start", [0, 0])
	var start_cell := Vector2i(int(start_xy[0]), int(start_xy[1]))
	var all_pois_reachable: bool = true
	for target_key: String in poi_data.keys():
		var target_xy: PackedStringArray = target_key.split(",")
		var target_cell := Vector2i(int(target_xy[0]), int(target_xy[1]))
		var blocked_cells: Dictionary = {}
		for other_key: String in poi_data.keys():
			var other_poi: Dictionary = poi_data[other_key]
			if String(other_poi.get("kind", "")) != "combat" or String(other_poi.get("guardian", "")) != "" or other_key == target_key:
				continue
			var other_xy: PackedStringArray = other_key.split(",")
			blocked_cells[Vector2i(int(other_xy[0]), int(other_xy[1]))] = true
		if not _mask_path_exists(mask, int(board.get("cols", 0)), start_cell, target_cell, blocked_cells):
			all_pois_reachable = false
	check(all_pois_reachable and poi_data.size() == 18,
		"les 18 lieux de Sylvestre restent atteignables avec les combats ordinaires bloquants et les donjons traversables")

	check(map_ui.contains("func react()") and map_ui.contains("_hero.react()"),
		"le héros réagit visuellement aux trouvailles et aux lieux découverts")
	check(map_ui.contains("func _hero_depth_scale") and map_ui.contains("lerpf(0.86, 1.12") and map_ui.contains('tween_property(_hero, "scale"'),
		"le héros adapte progressivement son échelle à la profondeur de la planche")
	check(map_ui.contains("mn.z_index = mn.cell.y * 4 + 2"),
		"les personnages et groupes sont triés selon leur profondeur sur la planche")
	check(map_ui.contains("var sprint: bool = is_board() and path.size() >= 8") and map_ui.contains("var running: bool = false") and map_ui.contains("stride_period: float = 0.18 if running else 0.24"),
		"les longs trajets déclenchent une course plus rapide que la marche")
	check(map_ui.contains("var _idle_timer: float = 4.0") and map_ui.contains("_idle_variant = idle_pool[randi() % idle_pool.size()]")
		and map_ui.contains("if not walking and _idle_variant != null"),
		"les poses de repos du héros sont choisies par séquences espacées et stables")
	check(map_ui.contains("func _pointer_to_cell") and map_ui.contains("distance_squared_to(icon_center)") and map_ui.contains("hit_radius: float = 48.0 if poi_node.is_dungeon else 42.0"),
		"les icônes de lieux et de donjons disposent d'une zone tactile élargie")
	check(map_ui.contains("pn.nearby = hero_distance <= near and not pn.done") and map_ui.contains("if nearby:") and map_ui.contains("draw_arc(ic, icon_r + 7.0 + pulse * 3.0"),
		"les lieux proches du héros affichent un halo pulsé discret indiquant leur disponibilité")
	check(map_ui.contains('ambient.name = "Ambient"') and map_ui.contains("ambient.configure(maxi(zs.x, zs.y), biome"),
		"la planche illustrée reçoit aussi les effets d'ambiance du biome sans modifier son image")
	var ambient_script: String = FileAccess.get_file_as_string("res://scripts/SceneryAmbient.gd")
	check(ambient_script.contains("GfxQuality.density()") and ambient_script.contains("roundi(34.0 * GfxQuality.density())"),
		"les particules de la planche respectent le profil graphique Auto/Économie/Haute")
	check(ambient_script.contains('"leaves" if _biome == "Forêt"') and ambient_script.contains('"leaves":'),
		"Sylvestre reçoit un léger feuillage animé indépendant du fond illustré")
	check(map_ui.contains("func _adjacent_interaction()") and map_ui.contains('nearby_kind == "find"')
		and map_ui.contains('nearby_kind == "gate"') and map_ui.contains('_walk([target])'),
		"les POI, trouvailles et portails accessibles à une case proposent une action contextuelle")
	check(map_ui.contains("var _motion_blend: float = 0.0") and map_ui.contains("var _settle_t: float = 0.0")
		and map_ui.contains("var _turn_t: float = 0.0") and map_ui.contains("shadow_radius")
		and map_ui.contains("if walking or _settle_t > 0.0"),
		"les départs/arrêts et demi-tours du héros sont amortis et son ombre suit la profondeur")
	check(manager.contains("ProgressionManager.add_resources(save, res)") and manager.contains('save["gold"]')
		and manager.contains('save["inventory"].append(drops[0])') and manager.contains("ProgressionManager.award_xp(save, xp)"),
		"les récompenses d'exploration restent versées dans les données communes de la sauvegarde")

	print("ÉCHECS : %d" % fails)
	quit(1 if fails > 0 else 0)
