extends CanvasLayer
## SaveSlotsUI.gd — Écran de gestion des parties : 5 slots, équipe modifiable,
## inventaire de loots et équipement par personnage.

signal battle_requested(slot: int)

const COL_PANEL := Color(0.94, 0.89, 0.78, 0.97)
const COL_BORDER := Color(0.72, 0.58, 0.28, 1.0)
const COL_TXT := Color(0.22, 0.15, 0.05)

var _root: Control
var _slots_box: VBoxContainer
var _detail_panel: PanelContainer
var _detail_box: VBoxContainer
var _current: Dictionary = {}     # sauvegarde affichée dans le détail
var _current_slot: int = -1

func _ready() -> void:
	_build()

func _build() -> void:
	_root = Control.new()
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_root)
	var bg := ColorRect.new()
	bg.color = Color(0.06, 0.09, 0.14, 0.92)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.add_child(bg)

	var title := Label.new()
	title.text = "MES PARTIES (max %d)" % ProgressionManager.MAX_SAVES
	title.add_theme_font_size_override("font_size", 34)
	title.add_theme_color_override("font_color", COL_TXT)
	title.position = Vector2(40, 18)
	_root.add_child(title)

	_slots_box = VBoxContainer.new()
	_slots_box.position = Vector2(40, 90)
	_slots_box.custom_minimum_size = Vector2(560, 0)
	_slots_box.add_theme_constant_override("separation", 14)
	_root.add_child(_slots_box)

	_detail_panel = PanelContainer.new()
	_detail_panel.position = Vector2(640, 90)
	_detail_panel.custom_minimum_size = Vector2(600, 880)
	_detail_panel.add_theme_stylebox_override("panel", _flat())
	_root.add_child(_detail_panel)
	_detail_box = VBoxContainer.new()
	_detail_box.add_theme_constant_override("separation", 10)
	_detail_panel.add_child(_detail_box)

	refresh()

func _flat() -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = COL_PANEL
	s.border_color = COL_BORDER
	s.set_border_width_all(3)
	s.set_corner_radius_all(12)
	return s

func refresh() -> void:
	for c: Node in _slots_box.get_children():
		c.queue_free()
	var saves: Array = ProgressionManager.list_saves()
	var used: Dictionary = {}
	for sv: Dictionary in saves:
		used[int(sv["id"])] = sv
	for slot: int in range(ProgressionManager.MAX_SAVES):
		var btn := Button.new()
		btn.custom_minimum_size = Vector2(560, 96)
		btn.add_theme_font_size_override("font_size", 22)
		btn.add_theme_color_override("font_color", COL_TXT)
		btn.add_theme_stylebox_override("normal", _flat())
		btn.add_theme_stylebox_override("hover", _flat())
		if used.has(slot):
			var sv: Dictionary = used[slot]
			btn.text = "%s — Niveau ennemis %d  (%d victoires)" % [sv["name"], sv["level"], sv["victories"]]
		else:
			btn.text = "+ Nouvelle partie (slot %d)" % (slot + 1)
		var slot_ref: int = slot
		btn.pressed.connect(func() -> void: _on_slot_pressed(slot_ref))
		_slots_box.add_child(btn)

	if _current_slot >= 0 and ProgressionManager.save_exists(_current_slot):
		_show_detail(ProgressionManager.load_save(_current_slot), _current_slot)

func _on_slot_pressed(slot: int) -> void:
	var data: Dictionary
	if ProgressionManager.save_exists(slot):
		data = ProgressionManager.load_save(slot)
	else:
		data = ProgressionManager.new_game(slot)
	_show_detail(data, slot)

func _show_detail(data: Dictionary, slot: int) -> void:
	_current = data
	_current_slot = slot
	for c: Node in _detail_box.get_children():
		c.queue_free()

	var title := Label.new()
	title.text = "%s — ennemis niveau %d" % [data.get("name", ""), int(data.get("level", 10))]
	title.add_theme_font_size_override("font_size", 26)
	title.add_theme_color_override("font_color", COL_TXT)
	_detail_box.add_child(title)

	# Looter / recadrer l'équipe : bouton vers TeamSelection
	var team_btn := Button.new()
	team_btn.text = "Changer l'équipe (libre à chaque combat)"
	team_btn.add_theme_font_size_override("font_size", 20)
	team_btn.add_theme_color_override("font_color", COL_TXT)
	team_btn.add_theme_stylebox_override("normal", _flat())
	team_btn.pressed.connect(func() -> void:
		_current = _current
		get_tree().change_scene_to_file("res://scenes/TeamSelection.tscn"))
	_detail_box.add_child(team_btn)

	# Combat : lance la partie active
	var fight_btn := Button.new()
	fight_btn.text = "COMBAT — ennemis niveau %d" % int(data.get("level", 10))
	fight_btn.add_theme_font_size_override("font_size", 24)
	fight_btn.add_theme_color_override("font_color", COL_TXT)
	fight_btn.add_theme_stylebox_override("normal", _flat())
	fight_btn.pressed.connect(func() -> void:
		# Activer la partie (ennemis au niveau de la partie) et lancer le combat
		GameManager.active_save = _current
		GameManager.active_slot = slot
		battle_requested.emit(slot)
		get_tree().change_scene_to_file("res://scenes/TeamSelection.tscn"))
	_detail_box.add_child(fight_btn)

	# Équipe et équipement
	var team: Array = data.get("team", [])
	var team_lbl := Label.new()
	team_lbl.text = "Équipe :"
	team_lbl.add_theme_font_size_override("font_size", 22)
	team_lbl.add_theme_color_override("font_color", COL_TXT)
	_detail_box.add_child(team_lbl)
	for i: int in range(team.size()):
		var m: Dictionary = team[i]
		var row := Label.new()
		row.text = "  %s — %s" % [m.get("classe", "?"), _equip_summary(m)]
		row.add_theme_font_size_override("font_size", 18)
		row.add_theme_color_override("font_color", COL_TXT)
		_detail_box.add_child(row)

	# Inventaire
	var inv: Array = data.get("inventory", [])
	var inv_lbl := Label.new()
	inv_lbl.text = "Inventaire (%d objets) :" % inv.size()
	inv_lbl.add_theme_font_size_override("font_size", 22)
	inv_lbl.add_theme_color_override("font_color", COL_TXT)
	_detail_box.add_child(inv_lbl)
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(560, 360)
	_detail_box.add_child(scroll)
	var inv_box := VBoxContainer.new()
	inv_box.add_theme_constant_override("separation", 6)
	scroll.add_child(inv_box)
	for j: int in range(inv.size()):
		var it: Dictionary = inv[j]
		var row2 := Label.new()
		row2.text = "  [%s] %s (nv%d) F%d I%d A%d S%d V%d D%d" % [
			it.get("type", "?"), it.get("name", "?"), int(it.get("level", 0)),
			int(it.get("force", 0)), int(it.get("intelligence", 0)), int(it.get("agility", 0)),
			int(it.get("wisdom", 0)), int(it.get("vita", 0)), int(it.get("defense", 0))]
		row2.add_theme_font_size_override("font_size", 16)
		row2.add_theme_color_override("font_color", COL_TXT)
		inv_box.add_child(row2)
	# Équiper : simple boucle d'équipement auto sur l'équipe en place
	var auto_btn := Button.new()
	auto_btn.text = "Équiper automatiquement les meilleurs objets"
	auto_btn.add_theme_font_size_override("font_size", 20)
	auto_btn.add_theme_color_override("font_color", COL_TXT)
	auto_btn.add_theme_stylebox_override("normal", _flat())
	auto_btn.pressed.connect(_auto_equip)
	_detail_box.add_child(auto_btn)

func _equip_summary(m: Dictionary) -> Dictionary:
	return m.get("equipment", {})

func _auto_equip() -> void:
	if _current.is_empty():
		return
	var inv: Array = _current.get("inventory", [])
	var team: Array = _current.get("team", [])
	# Trier l'inventaire par "score" décroissant
	var scored: Array = []
	for it: Dictionary in inv:
		var score: int = int(it.get("force", 0)) + int(it.get("intelligence", 0)) \
			+ int(it.get("agility", 0)) + int(it.get("wisdom", 0)) \
			+ int(it.get("vita", 0)) + int(it.get("defense", 0))
		scored.append([score, it])
	scored.sort_custom(func(a, b) -> bool: return a[0] > b[0])
	for entry: Array in scored:
		var it: Dictionary = entry[1]
		var slot_name: String = ProgressionManager.slot_for_type(String(it.get("type", "")))
		if slot_name == "":
			continue
		# Trouver un membre sans item sur cet emplacement
		for m: Dictionary in team:
			var eq: Dictionary = m.get("equipment", {})
			if not eq.has(slot_name):
				ProgressionManager.equip_item(_current, team.find(m), inv.find(it))
				break
	ProgressionManager.write_save(_current_slot, _current)
	_show_detail(ProgressionManager.load_save(_current_slot), _current_slot)
