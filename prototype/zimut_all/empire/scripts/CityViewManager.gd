extends Node2D
## CityViewManager.gd - Vue interieure d'une ville alliee (grille 8x8).
## Chaque case est un emplacement de construction. Le joueur choisit un
## batiment dans la liste, puis touche une case libre pour construire.
## Bouton "Sortir" pour revenir a la carte du monde.

const GRID_SIZE := 8
const TILE_SIZE := Vector2i(280, 140)
const HALF_CELL := Vector2(140, 70)

## Batiments disponibles (nom, cout, production par tick, description)
const BUILDINGS := [
	{"name": "Mine de fer", "cost": {"or": 50, "bois": 20}, "produces": "fer", "amount": 4, "desc": "Produit du fer"},
	{"name": "Scierie", "cost": {"or": 50, "fer": 10}, "produces": "bois", "amount": 4, "desc": "Produit du bois"},
	{"name": "Marché", "cost": {"or": 80, "fer": 20}, "produces": "or", "amount": 6, "desc": "Produit de l'or"},
	{"name": "Tour de garde", "cost": {"or": 60, "fer": 30, "bois": 30}, "produces": "", "amount": 0, "desc": "+2 unites de garnison"},
]

var city: Dictionary = {}
var empire_manager: Node = null
var ui_layer: CanvasLayer
var cell_nodes: Array = []
var origin := Vector2(960.0, 540.0)
var build_option: OptionButton
var info_label: RichTextLabel
var exit_button: Button
var build_button: Button

signal exit_requested

func setup(manager: Node, city_data: Dictionary) -> void:
	empire_manager = manager
	city = city_data
	_fit_to_screen()
	_create_grid()
	_setup_ui()

func _fit_to_screen() -> void:
	var viewport: Viewport = get_viewport()
	if viewport == null:
		return
	var screen: Vector2 = viewport.get_visible_rect().size
	var map_w: float = float(GRID_SIZE) * 280.0
	var map_h: float = float(2 * GRID_SIZE - 2) * 70.0 + 140.0
	origin = Vector2(screen.x * 0.5, screen.y * 0.5 - map_h * 0.5 + 70.0)
	var cam: Camera2D = null
	for child in get_tree().get_current_scene().get_children():
		if child is Camera2D:
			cam = child
			break
	if cam:
		var margin := 0.92
		var zoom_x: float = screen.x * margin / map_w
		var zoom_y: float = (screen.y - 240.0) * margin / map_h
		var z: float = minf(zoom_x, zoom_y)
		cam.zoom = Vector2(z, z)
		cam.position = origin + Vector2(0.0, map_h * 0.5 - 70.0)
		cam.make_current()

func _create_grid() -> void:
	cell_nodes = []
	for y: int in range(GRID_SIZE):
		var row: Array = []
		for x: int in range(GRID_SIZE):
			var cell: Node2D = preload("res://empire/scripts/battle/BattleCell.gd").new()
			cell.grid_position = Vector2i(x, y)
			cell.z_index = x + y
			cell.connect("cell_clicked", Callable(self, "_on_cell_clicked"))
			add_child(cell)
			cell.position = grid_to_screen(Vector2i(x, y))
			row.append(cell)
		cell_nodes.append(row)

func grid_to_screen(pos: Vector2i) -> Vector2:
	var x: float = origin.x + (float(pos.x) - float(pos.y)) * 140.0
	var y: float = origin.y + (float(pos.x) + float(pos.y)) * 70.0
	return Vector2(x, y)

func _slot_building(pos: Vector2i) -> Dictionary:
	for b: Dictionary in city.get("buildings", []):
		if int(b.get("x", -1)) == pos.x and int(b.get("y", -1)) == pos.y:
			return b
	return {}

func _on_cell_clicked(x: int, y: int) -> void:
	var pos := Vector2i(x, y)
	var existing: Dictionary = _slot_building(pos)
	if not existing.is_empty():
		empire_manager.message_requested.emit("%s occupe cet emplacement." % existing.get("name", "Bâtiment"))
		return
	var idx: int = build_option.selected
	if idx < 0:
		empire_manager.message_requested.emit("Choisissez d'abord un bâtiment dans la liste.")
		return
	var building: Dictionary = BUILDINGS[idx]
	var cost: Dictionary = building["cost"]
	var res: Dictionary = empire_manager.resources
	for key: String in cost:
		if int(res.get(key, 0)) < int(cost[key]):
			empire_manager.message_requested.emit("Ressources insuffisantes pour %s." % building["name"])
			return
	for key: String in cost:
		empire_manager.resources[key] = int(res[key]) - int(cost[key])
	empire_manager.resources_changed.emit(empire_manager.resources)
	city["buildings"].append({
		"name": building["name"],
		"produces": building["produces"],
		"amount": building["amount"],
		"x": pos.x,
		"y": pos.y,
		"level": 1,
	})
	empire_manager.city_changed.emit(city)
	empire_manager.message_requested.emit("%s construit !" % building["name"])
	_refresh_buildings()

func _setup_ui() -> void:
	ui_layer = CanvasLayer.new()
	ui_layer.name = "CityViewUI"
	ui_layer.layer = 20
	add_child(ui_layer)
	var root: Control = Control.new()
	root.name = "UI"
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_layer.add_child(root)

	# Titre
	var title: Label = Label.new()
	title.text = "VILLE : %s" % str(city.get("name", "?")).to_upper()
	title.add_theme_font_size_override("font_size", 34)
	title.position = Vector2(24, 16)
	title.add_theme_color_override("font_color", Color(1, 0.95, 0.7))
	ui_layer.add_child(title)

	# Liste des batiments disponibles
	var panel: PanelContainer = PanelContainer.new()
	panel.anchor_left = 0.0
	panel.anchor_top = 0.0
	panel.anchor_bottom = 1.0
	panel.offset_left = 24
	panel.offset_top = 70
	panel.offset_right = 480
	panel.offset_bottom = -120
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.08, 0.14, 0.93)
	style.set_border_width_all(2)
	style.border_color = Color(0.55, 0.45, 0.2)
	style.set_content_margin_all(14)
	style.set_corner_radius_all(10)
	panel.add_theme_stylebox_override("panel", style)
	root.add_child(panel)

	var vbox: VBoxContainer = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 12)
	panel.add_child(vbox)

	var list_title: Label = Label.new()
	list_title.text = "Bâtiments disponibles"
	list_title.add_theme_font_size_override("font_size", 26)
	vbox.add_child(list_title)

	build_option = OptionButton.new()
	build_option.add_theme_font_size_override("font_size", 26)
	build_option.custom_minimum_size = Vector2(0, 70)
	for b: Dictionary in BUILDINGS:
		var cost_txt: String = ""
		var cost: Dictionary = b["cost"]
		var parts: Array = []
		for key: String in cost:
			parts.append("%d %s" % [int(cost[key]), key])
		cost_txt = " — ".join(parts)
		build_option.add_item("%s (%s)" % [b["name"], cost_txt])
	vbox.add_child(build_option)

	info_label = RichTextLabel.new()
	info_label.bbcode_enabled = true
	info_label.fit_content = true
	info_label.add_theme_font_size_override("normal_font_size", 22)
	vbox.add_child(info_label)

	build_button = Button.new()
	build_button.text = "🔨 Construire ici"
	build_button.add_theme_font_size_override("font_size", 26)
	build_button.custom_minimum_size = Vector2(0, 80)
	build_button.pressed.connect(_on_build_hint)
	vbox.add_child(build_button)

	# Bouton Sortir (bas centre)
	exit_button = Button.new()
	exit_button.text = "⤶ Sortir de la ville"
	exit_button.add_theme_font_size_override("font_size", 30)
	exit_button.anchor_left = 0.5
	exit_button.anchor_right = 0.5
	exit_button.anchor_top = 1.0
	exit_button.anchor_bottom = 1.0
	exit_button.offset_left = -220
	exit_button.offset_right = 220
	exit_button.offset_top = -104
	exit_button.offset_bottom = -24
	exit_button.pressed.connect(_on_exit_pressed)
	root.add_child(exit_button)

	_refresh_buildings()

func _on_build_hint() -> void:
	var idx: int = build_option.selected
	if idx < 0:
		return
	var b: Dictionary = BUILDINGS[idx]
	empire_manager.message_requested.emit("Touchez une case libre pour construire %s." % b["name"])

func _refresh_buildings() -> void:
	var txt: String = ""
	var buildings: Array = city.get("buildings", [])
	if buildings.is_empty():
		txt = "[color=gray]Aucun bâtiment.Touchez une case libre après avoir choisi un bâtiment.[/color]"
	else:
		txt = "[b]Construit (%d) :[/b]\n" % buildings.size()
		for b: Dictionary in buildings:
			if str(b.get("produces", "")) != "":
				txt += "• %s (+%d %s/tick)\n" % [b.get("name", "?"), int(b.get("amount", 0)), b.get("produces", "")]
			else:
				txt += "• %s\n" % b.get("name", "?")
	info_label.text = txt
	# Marquer visuellement les cases occupees via les cellules
	for y: int in range(GRID_SIZE):
		for x: int in range(GRID_SIZE):
			var slot := _slot_building(Vector2i(x, y))
			var cell: Node2D = cell_nodes[y][x]
			cell.set_meta("building", slot)
			cell.queue_redraw()
	_redraw_building_overlays()

## Affiche un pictogramme par batiment construit.
func _redraw_building_overlays() -> void:
	for child in get_children():
		if child.name.begins_with("BuildingIcon_"):
			child.queue_free()
	for b: Dictionary in city.get("buildings", []):
		var pos := Vector2i(int(b.get("x", 0)), int(b.get("y", 0)))
		if pos.x < 0 or pos.x >= GRID_SIZE or pos.y < 0 or pos.y >= GRID_SIZE:
			continue
		var icon: Node2D = preload("res://empire/scripts/BuildingIcon.gd").new()
		icon.name = "BuildingIcon_%d_%d" % [pos.x, pos.y]
		icon.setup(b)
		icon.position = grid_to_screen(pos) + HALF_CELL
		icon.z_index = pos.x + pos.y + 50
		add_child(icon)

func _on_exit_pressed() -> void:
	exit_requested.emit()
