extends CanvasLayer
## Première ébauche du mode Aventure.
## La progression reste dans la sauvegarde commune utilisée par le mode Tactique.

const PANEL := Color(0.10, 0.17, 0.20, 0.96)
const PANEL_LIGHT := Color(0.18, 0.29, 0.29, 0.96)
const GOLD := Color(0.94, 0.76, 0.34)
const TEXT := Color(0.95, 0.94, 0.83)
const GRID_W := 8
const GRID_H := 5

var _save: Dictionary = {}
var _slot: int = -1
var _hero_pos := Vector2i(1, 2)
var _moves: int = 0
var _message: Label
var _grid: GridContainer
var _interact: Button
var _cells: Dictionary = {}
var _campaign: Dictionary = {}

const POIS := {
	"3,1": {"kind": "puzzle", "icon": "✦", "name": "Sanctuaire des runes"},
	"6,2": {"kind": "combat", "icon": "⚔", "name": "Camp gobelin"},
	"2,4": {"kind": "chest", "icon": "◇", "name": "Coffre moussu"},
	"6,4": {"kind": "exit", "icon": "➜", "name": "Sentier du vieux chêne"},
}

func _ready() -> void:
	Music.play("adventure")
	layer = 10
	_save = GameManager.active_save
	_slot = GameManager.active_slot
	if _save.is_empty() or _slot < 0:
		get_tree().change_scene_to_file("res://scenes/SaveSlots.tscn")
		return
	_campaign = _save.get("adventure", {})
	if _campaign.is_empty():
		_campaign = {"hero_pos": [1, 2], "moves": 0, "discovered": [], "completed": []}
	var pos_data: Array = _campaign.get("hero_pos", [1, 2])
	if pos_data.size() >= 2:
		_hero_pos = Vector2i(int(pos_data[0]), int(pos_data[1]))
	_moves = int(_campaign.get("moves", 0))
	_save["adventure"] = _campaign
	_save["campaign_mode"] = "adventure"
	_persist()
	_build()

func _build() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.35, 0.48, 0.45)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var root := VBoxContainer.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_theme_constant_override("separation", 12)
	root.offset_left = 28
	root.offset_right = -28
	root.offset_top = 22
	root.offset_bottom = -22
	add_child(root)

	var top := HBoxContainer.new()
	root.add_child(top)
	var title := Label.new()
	title.text = "🌿  ZIMUT — L'ODYSSÉE DES ÉLÉMENTS"
	title.add_theme_font_size_override("font_size", 28)
	title.add_theme_color_override("font_color", TEXT)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(title)
	var back := Button.new()
	back.text = "←  PARTIE"
	back.pressed.connect(_back_to_save)
	top.add_child(back)

	var subtitle := Label.new()
	subtitle.text = "AVENTURE  ·  Forêt de Zimut  ·  Explorez, découvrez, relevez des défis"
	subtitle.add_theme_font_size_override("font_size", 18)
	subtitle.add_theme_color_override("font_color", GOLD)
	root.add_child(subtitle)

	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 18)
	root.add_child(body)

	var map_panel := PanelContainer.new()
	map_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	map_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	map_panel.add_theme_stylebox_override("panel", _panel_style(PANEL, GOLD))
	body.add_child(map_panel)
	var map_box := VBoxContainer.new()
	map_box.add_theme_constant_override("separation", 8)
	map_panel.add_child(map_box)
	var map_title := Label.new()
	map_title.text = "SENTIERS DE LA FORÊT"
	map_title.add_theme_font_size_override("font_size", 20)
	map_title.add_theme_color_override("font_color", TEXT)
	map_box.add_child(map_title)
	_grid = GridContainer.new()
	_grid.columns = GRID_W
	_grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_grid.add_theme_constant_override("h_separation", 5)
	_grid.add_theme_constant_override("v_separation", 5)
	map_box.add_child(_grid)
	for y: int in range(GRID_H):
		for x: int in range(GRID_W):
			var p := Vector2i(x, y)
			var cell := Button.new()
			cell.custom_minimum_size = Vector2(66, 62)
			cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			cell.size_flags_vertical = Control.SIZE_EXPAND_FILL
			cell.add_theme_font_size_override("font_size", 22)
			cell.pressed.connect(_on_cell_pressed.bind(p))
			_cells[p] = cell
			_grid.add_child(cell)

	var side := PanelContainer.new()
	side.custom_minimum_size.x = 350
	side.add_theme_stylebox_override("panel", _panel_style(PANEL_LIGHT, GOLD))
	body.add_child(side)
	var side_box := VBoxContainer.new()
	side_box.add_theme_constant_override("separation", 12)
	side.add_child(side_box)
	var hero_title := Label.new()
	hero_title.text = "JOURNAL D'EXPLORATION"
	hero_title.add_theme_font_size_override("font_size", 20)
	hero_title.add_theme_color_override("font_color", TEXT)
	side_box.add_child(hero_title)
	_message = Label.new()
	_message.text = "Déplacez-vous de case en case. Les lieux remarquables révèlent des interactions."
	_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_message.custom_minimum_size.y = 120
	_message.add_theme_color_override("font_color", TEXT)
	side_box.add_child(_message)
	_interact = Button.new()
	_interact.text = "INTERAGIR"
	_interact.custom_minimum_size.y = 54
	_interact.pressed.connect(_interact_with_poi)
	side_box.add_child(_interact)
	var help := Label.new()
	help.text = "Déplacement : cases adjacentes\nDéfis et coffres : récompenses partagées\nCombat : équipe, sorts et règles du mode Tactique"
	help.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	help.add_theme_color_override("font_color", TEXT)
	side_box.add_child(help)
	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	side_box.add_child(spacer)
	var progress := Label.new()
	progress.text = "Pas parcourus : %d\nPersonnages, XP et inventaire : sauvegarde commune" % _moves
	progress.add_theme_color_override("font_color", GOLD)
	side_box.add_child(progress)
	_refresh_map()

func _refresh_map() -> void:
	for p: Vector2i in _cells.keys():
		var cell: Button = _cells[p]
		var key := "%d,%d" % [p.x, p.y]
		var poi: Dictionary = POIS.get(key, {})
		if p == _hero_pos:
			cell.text = "🧭"
			cell.tooltip_text = "Votre héros"
			cell.add_theme_color_override("font_color", Color(1.0, 0.88, 0.36))
			cell.add_theme_stylebox_override("normal", _panel_style(Color(0.38, 0.31, 0.12), GOLD))
		elif not poi.is_empty():
			cell.text = String(poi["icon"])
			cell.tooltip_text = String(poi["name"])
			cell.add_theme_color_override("font_color", TEXT)
			cell.add_theme_stylebox_override("normal", _panel_style(Color(0.20, 0.34, 0.24), Color(0.58, 0.75, 0.46)))
		else:
			cell.text = "·" if (p.x + p.y) % 2 == 0 else "✧"
			cell.tooltip_text = "Sentier forestier"
			cell.add_theme_color_override("font_color", Color(0.75, 0.84, 0.66))
			cell.add_theme_stylebox_override("normal", _panel_style(Color(0.30, 0.44, 0.34) if (p.x + p.y) % 2 == 0 else Color(0.34, 0.48, 0.36), Color(0.47, 0.61, 0.43)))
		cell.add_theme_stylebox_override("hover", _panel_style(Color(0.43, 0.55, 0.39), GOLD))
		cell.add_theme_color_override("font_hover_color", Color.WHITE)
		var completed: Array = _campaign.get("completed", [])
		if not poi.is_empty() and completed.has(key):
			cell.text = "✓"

	var key_here := "%d,%d" % [_hero_pos.x, _hero_pos.y]
	var completed_here: Array = _campaign.get("completed", [])
	_interact.disabled = not POIS.has(key_here) or completed_here.has(key_here)

func _on_cell_pressed(p: Vector2i) -> void:
	if absi(p.x - _hero_pos.x) + absi(p.y - _hero_pos.y) != 1:
		_message.text = "Le sentier est accessible case par case. Choisissez une case adjacente."
		return
	_hero_pos = p
	_moves += 1
	var key := "%d,%d" % [p.x, p.y]
	var discovered: Array = _campaign.get("discovered", [])
	if not discovered.has(key):
		discovered.append(key)
	_campaign["discovered"] = discovered
	_campaign["hero_pos"] = [p.x, p.y]
	_campaign["moves"] = _moves
	var poi: Dictionary = POIS.get(key, {})
	if not poi.is_empty():
		_message.text = "Découverte : %s. Approchez-vous et choisissez INTERAGIR." % String(poi["name"])
	else:
		_message.text = "Le sentier s'enfonce sous les frondaisons. Continuez à explorer."
	_persist()
	_refresh_map()

func _interact_with_poi() -> void:
	var key := "%d,%d" % [_hero_pos.x, _hero_pos.y]
	var poi: Dictionary = POIS.get(key, {})
	if poi.is_empty():
		return
	var completed: Array = _campaign.get("completed", [])
	if completed.has(key):
		return
	match String(poi["kind"]):
		"puzzle":
			var dialog := ConfirmationDialog.new()
			dialog.title = "Le sanctuaire des runes"
			dialog.dialog_text = "Énigme : je grandis quand on me nourrit, mais je meurs si l'on me donne à boire. Qui suis-je ?\n\nDans cette première ébauche, confirmer signifie proposer le feu."
			dialog.ok_button_text = "Le feu"
			dialog.cancel_button_text = "Je réfléchis encore"
			dialog.confirmed.connect(func() -> void:
				_award_exploration_reward(120, key, "Énigme résolue : le sanctuaire vous confie une relique.")
				dialog.queue_free())
			dialog.canceled.connect(func() -> void: dialog.queue_free())
			add_child(dialog)
			dialog.popup_centered(Vector2i(560, 220))
		"chest":
			var drops: Array = ProgressionManager._roll_loots(maxi(1, int(_save.get("level", 10))), false)
			if not drops.is_empty():
				_save["inventory"].append(drops[0])
			_award_exploration_reward(60, key, "Coffre ouvert : +60 XP et un objet ajouté à l'inventaire commun.")
		"combat":
			_campaign["pending_challenge"] = key
			_save["adventure"] = _campaign
			_save["campaign_mode"] = "adventure"
			_persist()
			GameManager.active_save = _save
			GameManager.active_slot = _slot
			GameManager.fight_biome = "Forêt"
			get_tree().change_scene_to_file("res://scenes/TeamSelection.tscn")
		"exit":
			_message.text = "Le vieux chêne marque la limite de cette première zone. D'autres clairières viendront ensuite."

func _award_exploration_reward(xp: int, key: String, message: String) -> void:
	ProgressionManager.award_xp(_save, xp)
	var completed: Array = _campaign.get("completed", [])
	if not completed.has(key):
		completed.append(key)
	_campaign["completed"] = completed
	_save["adventure"] = _campaign
	_persist()
	_message.text = message
	_refresh_map()

func _persist() -> void:
	_save["adventure"] = _campaign
	_save["campaign_mode"] = "adventure"
	ProgressionManager.write_save(_slot, _save)
	GameManager.active_save = _save
	GameManager.active_slot = _slot

func _back_to_save() -> void:
	_persist()
	get_tree().change_scene_to_file("res://scenes/SaveSlots.tscn")

func _panel_style(bg: Color, border: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(2)
	s.set_corner_radius_all(10)
	s.content_margin_left = 8
	s.content_margin_right = 8
	s.content_margin_top = 6
	s.content_margin_bottom = 6
	return s
