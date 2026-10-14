extends CanvasLayer

## SaveSlotsUI.gd — Écran de gestion des parties : 5 slots, équipe modifiable,
## inventaire de loots et équipement par personnage.
## Layout plein écran responsive (ancres, plus de positions fixes 1920x1080) :
## colonne de slots à gauche, détail de la partie sélectionnée à droite, empilés
## verticalement sur écran étroit (téléphone en paysage).

signal battle_requested(slot: int)

const COL_PANEL := Color(0.94, 0.89, 0.78, 0.97)
const COL_BORDER := Color(0.72, 0.58, 0.28, 1.0)
const COL_TXT := Color(0.22, 0.15, 0.05)
const COL_SLOT_EMPTY_BG := Color(0.12, 0.15, 0.21, 0.95)
const COL_SLOT_USED_BG := Color(0.20, 0.26, 0.35, 0.97)

var _root: Control
var _slots_box: VBoxContainer
var _detail_panel: PanelContainer
var _detail_box: VBoxContainer
var _current: Dictionary = {}     # sauvegarde affichée dans le détail
var _current_slot: int = -1

func _ready() -> void:
	_build()
	var intent: String = GameManager.menu_intent
	GameManager.menu_intent = ""
	if intent == "new":
		_select_first_empty_slot()

func _build() -> void:
	_root = Control.new()
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(_root)

	var bg := ColorRect.new()
	bg.color = Color(0.06, 0.09, 0.14, 0.92)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.add_child(bg)

	# Barre de titre : bouton MENU à gauche, titre centré
	var top := HBoxContainer.new()
	top.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	top.offset_left = 20.0
	top.offset_right = -20.0
	top.offset_top = 14.0
	top.offset_bottom = 76.0
	top.add_theme_constant_override("separation", 16)
	_root.add_child(top)

	var back := Button.new()
	back.text = "← MENU"
	back.custom_minimum_size = Vector2(150, 56)
	back.add_theme_font_size_override("font_size", 20)
	back.add_theme_color_override("font_color", COL_TXT)
	back.add_theme_stylebox_override("normal", _flat())
	back.add_theme_stylebox_override("hover", _flat())
	back.pressed.connect(func() -> void:
		GameManager.active_save = {}
		GameManager.active_slot = -1
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn"))
	top.add_child(back)

	var title := Label.new()
	title.text = "ENTRER DANS ZIMUT — mes parties (max %d)" % ProgressionManager.MAX_SAVES
	title.add_theme_font_size_override("font_size", 30)
	title.add_theme_color_override("font_color", COL_TXT)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	top.add_child(title)

	# Zone principale : slots + détail, côte à côte en largeur, empilés sinon
	var main := HBoxContainer.new()
	main.anchor_left = 0.0
	main.anchor_right = 1.0
	main.anchor_top = 0.0
	main.anchor_bottom = 1.0
	main.offset_left = 20.0
	main.offset_right = -20.0
	main.offset_top = 80.0
	main.offset_bottom = -12.0
	main.add_theme_constant_override("separation", 16)
	_root.add_child(main)

	var slots_scroll := ScrollContainer.new()
	slots_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slots_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	slots_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	main.add_child(slots_scroll)

	_slots_box = VBoxContainer.new()
	_slots_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_slots_box.add_theme_constant_override("separation", 12)
	slots_scroll.add_child(_slots_box)

	_detail_panel = PanelContainer.new()
	_detail_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_detail_panel.add_theme_stylebox_override("panel", _flat())
	main.add_child(_detail_panel)

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
		btn.custom_minimum_size = Vector2(0, 96)
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		var is_used: bool = used.has(slot)
		if is_used:
			var sv: Dictionary = used[slot]
			btn.text = "  Continuer — %s\n  ennemis nv %d · %d victoires" % [sv["name"], sv["level"], sv["victories"]]
			btn.add_theme_stylebox_override("normal", _flat_bg(COL_SLOT_USED_BG, COL_BORDER, 4))
			btn.add_theme_stylebox_override("hover", _flat_bg(COL_SLOT_USED_BG.lightened(0.15), COL_BORDER, 5))
		else:
			btn.text = "  + Commencer une nouvelle partie (slot %d)" % (slot + 1)
			btn.add_theme_stylebox_override("normal", _flat_bg(COL_SLOT_EMPTY_BG, Color(0.3, 0.35, 0.45), 2))
			btn.add_theme_stylebox_override("hover", _flat_bg(COL_SLOT_EMPTY_BG.lightened(0.15), Color(0.3, 0.35, 0.45), 3))
		btn.add_theme_font_size_override("font_size", 20)
		btn.add_theme_color_override("font_color", Color(0.95, 0.94, 0.90))
		if slot == _current_slot:
			btn.add_theme_color_override("font_color", Color(1.0, 0.86, 0.4))
		var slot_ref: int = slot
		btn.pressed.connect(func() -> void: _on_slot_pressed(slot_ref))
		_slots_box.add_child(btn)

	if _current_slot >= 0 and ProgressionManager.save_exists(_current_slot):
		_show_detail(ProgressionManager.load_save(_current_slot), _current_slot)
	elif not _detail_box.get_children().is_empty() and _current_slot < 0:
		for c: Node in _detail_box.get_children():
			c.queue_free()

func _flat_bg(bg: Color, border: Color, bw: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(bw)
	s.set_corner_radius_all(12)
	s.content_margin_left = 10
	s.content_margin_right = 10
	s.content_margin_top = 8
	s.content_margin_bottom = 8
	return s

func _on_slot_pressed(slot: int) -> void:
	var data: Dictionary
	if ProgressionManager.save_exists(slot):
		data = ProgressionManager.load_save(slot)
	else:
		data = ProgressionManager.new_game(slot)
	_current = data
	_current_slot = slot
	refresh()


## Depuis « Nouvelle partie » sur l'accueil, sélectionne le premier emplacement libre.
## La partie n'est créée qu'ici, après une action explicite du joueur.
func _select_first_empty_slot() -> void:
	for slot: int in range(ProgressionManager.MAX_SAVES):
		if not ProgressionManager.save_exists(slot):
			_on_slot_pressed(slot)
			return

	# Aucun emplacement libre : on ne remplace jamais une sauvegarde existante.
	for child: Node in _detail_box.get_children():
		child.queue_free()
	var message := Label.new()
	message.text = "Tous les emplacements sont occupés.\nSupprime une partie existante pour en commencer une nouvelle."
	message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message.add_theme_font_size_override("font_size", 22)
	message.add_theme_color_override("font_color", COL_TXT)
	_detail_box.add_child(message)

func _show_detail(data: Dictionary, slot: int) -> void:
	_current = data
	_current_slot = slot
	for c: Node in _detail_box.get_children():
		c.queue_free()

	var title := Label.new()
	title.text = "%s — ennemis niveau %d" % [data.get("name", ""), int(data.get("level", 10))]
	title.add_theme_font_size_override("font_size", 24)
	title.add_theme_color_override("font_color", COL_TXT)
	_detail_box.add_child(title)

	var team_btn := Button.new()
	team_btn.text = "Gérer l'équipe (libre à chaque combat)"
	team_btn.add_theme_font_size_override("font_size", 19)
	team_btn.add_theme_color_override("font_color", COL_TXT)
	team_btn.add_theme_stylebox_override("normal", _flat())
	team_btn.pressed.connect(func() -> void:
		get_tree().change_scene_to_file("res://scenes/TeamSelection.tscn"))
	_detail_box.add_child(team_btn)

	var name_btn := Button.new()
	name_btn.text = "✎  RENOMMER CETTE PARTIE"
	name_btn.add_theme_font_size_override("font_size", 19)
	name_btn.add_theme_color_override("font_color", COL_TXT)
	name_btn.add_theme_stylebox_override("normal", _flat())
	name_btn.pressed.connect(func() -> void:
		var dialog := ConfirmationDialog.new()
		var line := LineEdit.new()
		line.text = String(data.get("name", ""))
		line.placeholder_text = "Nouveau nom"
		dialog.add_child(line)
		dialog.dialog_text = "Nouveau nom de la partie :"
		dialog.ok_button_text = "RENOMMER"
		dialog.cancel_button_text = "Annuler"
		dialog.confirmed.connect(func() -> void:
			ProgressionManager.rename_save(slot, line.text)
			_current = ProgressionManager.load_save(slot)
			refresh())
		dialog.register_text_enter(line)
		_root.add_child(dialog)
		dialog.popup_centered()
		line.call_deferred("grab_focus"))
	_detail_box.add_child(name_btn)

	var del_btn := Button.new()
	del_btn.text = "🗑  SUPPRIMER CETTE PARTIE"
	del_btn.add_theme_font_size_override("font_size", 19)
	del_btn.add_theme_color_override("font_color", Color(0.35, 0.08, 0.05))
	del_btn.add_theme_stylebox_override("normal", _flat())
	del_btn.pressed.connect(func() -> void:
		var confirm := ConfirmationDialog.new()
		confirm.dialog_text = "Supprimer '%s' ?\nLa progression et l'inventaire seront perdus." % String(data.get("name", ""))
		confirm.ok_button_text = "SUPPRIMER"
		confirm.cancel_button_text = "Annuler"
		confirm.confirmed.connect(func() -> void:
			ProgressionManager.delete_save(slot)
			if GameManager.active_slot == slot:
				GameManager.active_save = {}
				GameManager.active_slot = -1
			_current = {}
			_current_slot = -1
			refresh())
		_root.add_child(confirm)
		confirm.popup_centered())
	_detail_box.add_child(del_btn)

	# Les trois modes utilisent la même sauvegarde : roster, XP, caractéristiques,
	# sorts, équipement et inventaire ne sont jamais dupliqués par mode.
	var mode_lbl := Label.new()
	mode_lbl.text = "Choisir un mode de jeu :"
	mode_lbl.add_theme_font_size_override("font_size", 21)
	mode_lbl.add_theme_color_override("font_color", COL_TXT)
	_detail_box.add_child(mode_lbl)
	_detail_box.add_child(_mode_button("Combats Tactiques", "Combat au tour par tour — niveau conseillé %d" % int(data.get("level", 10)), true, func() -> void:
		GameManager.active_save = _current
		GameManager.active_slot = slot
		GameManager.fight_biome = "Forêt"
		battle_requested.emit(slot)
		get_tree().change_scene_to_file("res://scenes/TeamSelection.tscn")))
	_detail_box.add_child(_mode_button("Aventure", "Explorez la forêt, résolvez une énigme et découvrez des coffres", true, func() -> void:
		_launch_campaign_mode("adventure", "res://scenes/AdventureMap.tscn", slot)))
	_detail_box.add_child(_mode_button("Conquête", "Développez votre territoire et lancez des assauts tactiques", true, func() -> void:
		_launch_campaign_mode("conquest", "res://scenes/ConquestMap.tscn", slot)))

	var team: Array = data.get("team", [])
	var team_lbl := Label.new()
	team_lbl.text = "Équipe :"
	team_lbl.add_theme_font_size_override("font_size", 21)
	team_lbl.add_theme_color_override("font_color", COL_TXT)
	_detail_box.add_child(team_lbl)
	for i: int in range(team.size()):
		var m: Dictionary = team[i]
		var row := Label.new()
		row.text = "  %s niv %d — %d objet(s) équipé(s)" % [m.get("classe", "?"),
			ProgressionManager.member_level(data, String(m.get("classe", ""))), _equip_summary(m).size()]
		row.add_theme_font_size_override("font_size", 18)
		row.add_theme_color_override("font_color", COL_TXT)
		_detail_box.add_child(row)

	var chars_btn := Button.new()
	chars_btn.text = "📈  PERSONNAGES — niveaux et caractéristiques"
	chars_btn.add_theme_font_size_override("font_size", 19)
	chars_btn.add_theme_color_override("font_color", COL_TXT)
	chars_btn.add_theme_stylebox_override("normal", _flat())
	chars_btn.pressed.connect(func() -> void:
		var ui: CanvasLayer = (load("res://scripts/CharacterSheetUI.gd") as GDScript).new()
		ui.layer = 10
		add_child(ui)
		ui.closed.connect(func() -> void:
			ui.queue_free()
			_show_detail(ProgressionManager.load_save(slot), slot))
		ui.open(_current, slot))
	_detail_box.add_child(chars_btn)

	var inv: Array = data.get("inventory", [])
	var inv_lbl := Label.new()
	inv_lbl.text = "Inventaire (%d objets disponibles à équiper) :" % inv.size()
	inv_lbl.add_theme_font_size_override("font_size", 21)
	inv_lbl.add_theme_color_override("font_color", COL_TXT)
	_detail_box.add_child(inv_lbl)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_detail_box.add_child(scroll)
	var inv_box := VBoxContainer.new()
	inv_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	inv_box.add_theme_constant_override("separation", 6)
	scroll.add_child(inv_box)
	for j: int in range(inv.size()):
		var it: Dictionary = inv[j]
		var row2 := Label.new()
		row2.text = "  [%s] %s (nv%d) %s" % [ItemRules.rarity_label(it), it.get("name", "?"),
			int(it.get("level", 0)), ItemRules.stat_line(it)]
		row2.tooltip_text = ItemRules.describe(it)
		row2.mouse_filter = Control.MOUSE_FILTER_PASS
		row2.add_theme_font_size_override("font_size", 16)
		row2.add_theme_color_override("font_color", ItemRules.rarity_color(it).darkened(0.4))
		inv_box.add_child(row2)

	var log_arr: Array = data.get("loot_log", [])
	if log_arr.size() > 0:
		var log_btn := Button.new()
		log_btn.text = "Voir tous les loots gagnés (%d)" % log_arr.size()
		log_btn.add_theme_font_size_override("font_size", 19)
		log_btn.add_theme_color_override("font_color", COL_TXT)
		log_btn.add_theme_stylebox_override("normal", _flat())
		log_btn.pressed.connect(func() -> void: _show_loot_log(log_arr))
		_detail_box.add_child(log_btn)

	var auto_btn := Button.new()
	auto_btn.text = "Équiper automatiquement les meilleurs objets"
	auto_btn.add_theme_font_size_override("font_size", 19)
	auto_btn.add_theme_color_override("font_color", COL_TXT)
	auto_btn.add_theme_stylebox_override("normal", _flat())
	auto_btn.pressed.connect(_auto_equip)
	_detail_box.add_child(auto_btn)

func _launch_campaign_mode(mode: String, scene_path: String, slot: int) -> void:
	if _current.is_empty() or slot < 0:
		return
	_current["campaign_mode"] = mode
	if mode == "adventure" and not _current.has("adventure"):
		_current["adventure"] = {"hero_pos": [1, 2], "moves": 0, "discovered": [], "completed": []}
	if mode == "conquest" and not _current.has("conquest"):
		_current["conquest"] = {"owned": ["capitale"], "pending_city": ""}
	if not ProgressionManager.write_save(slot, _current):
		return
	GameManager.active_slot = slot
	GameManager.active_save = ProgressionManager.load_save(slot)
	GameManager.clear_custom_team()
	get_tree().change_scene_to_file(scene_path)

func _equip_summary(m: Dictionary) -> Dictionary:
	return m.get("equipment", {})

const COL_DISABLED_BG := Color(0.14, 0.16, 0.22, 0.85)
const COL_DISABLED_BORDER := Color(0.28, 0.31, 0.39, 1.0)
const COL_DISABLED_TXT := Color(0.45, 0.48, 0.55)

## Bouton de mode de jeu : titre + descriptif ; grisé et non cliquable si à venir.
func _mode_button(title_txt: String, desc: String, enabled: bool, cb: Callable) -> Button:
	var b := Button.new()
	b.text = ""
	b.custom_minimum_size = Vector2(0, 96)
	b.disabled = not enabled
	b.focus_mode = Control.FOCUS_ALL if enabled else Control.FOCUS_NONE
	var vb := VBoxContainer.new()
	vb.set_anchors_preset(Control.PRESET_FULL_RECT)
	vb.alignment = BoxContainer.ALIGNMENT_CENTER
	vb.add_theme_constant_override("separation", 2)
	b.add_child(vb)
	var t := Label.new()
	t.text = title_txt
	t.add_theme_font_size_override("font_size", 22)
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	t.add_theme_color_override("font_color", COL_TXT if enabled else COL_DISABLED_TXT)
	vb.add_child(t)
	var d := Label.new()
	d.text = desc
	d.add_theme_font_size_override("font_size", 16)
	d.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	d.add_theme_color_override("font_color", Color(0.35, 0.28, 0.12) if enabled else COL_DISABLED_TXT)
	vb.add_child(d)
	var normal := StyleBoxFlat.new()
	if enabled:
		normal.bg_color = COL_PANEL
		normal.border_color = COL_BORDER
	else:
		normal.bg_color = COL_DISABLED_BG
		normal.border_color = COL_DISABLED_BORDER
	normal.set_border_width_all(3)
	normal.set_corner_radius_all(12)
	normal.content_margin_left = 12
	normal.content_margin_right = 12
	normal.content_margin_top = 8
	normal.content_margin_bottom = 8
	var hover := normal.duplicate()
	if enabled:
		hover.bg_color = Color(0.99, 0.95, 0.83)
		hover.border_color = Color(0.85, 0.68, 0.3)
	var pressed_s := normal.duplicate()
	if enabled:
		pressed_s.bg_color = Color(0.88, 0.82, 0.66)
	b.add_theme_stylebox_override("normal", normal)
	b.add_theme_stylebox_override("hover", hover)
	b.add_theme_stylebox_override("pressed", pressed_s)
	b.add_theme_stylebox_override("disabled", normal)
	if enabled and cb.is_valid():
		b.pressed.connect(cb)
	return b

func _auto_equip() -> void:
	if _current.is_empty():
		return
	ProgressionManager.auto_equip(_current)
	ProgressionManager.write_save(_current_slot, _current)
	_show_detail(ProgressionManager.load_save(_current_slot), _current_slot)

func _show_loot_log(log_arr: Array) -> void:
	var overlay := ColorRect.new()
	overlay.color = Color(0, 0, 0, 0.55)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	_root.add_child(overlay)
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(center)
	var dialog := PanelContainer.new()
	dialog.add_theme_stylebox_override("panel", _flat())
	center.add_child(dialog)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)
	dialog.add_child(box)
	var title := Label.new()
	title.text = "LOOTS GAGNÉS DANS CETTE PARTIE (%d)" % log_arr.size()
	title.add_theme_font_size_override("font_size", 24)
	title.add_theme_color_override("font_color", COL_TXT)
	box.add_child(title)
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(520, 520)
	box.add_child(scroll)
	var rows := VBoxContainer.new()
	rows.add_theme_constant_override("separation", 6)
	scroll.add_child(rows)
	for it: Dictionary in log_arr:
		var row := Label.new()
		row.text = "✨ [%s] %s (nv%d) %s" % [ItemRules.rarity_label(it), it.get("name", "?"),
			int(it.get("level", 0)), ItemRules.stat_line(it)]
		row.add_theme_font_size_override("font_size", 17)
		row.add_theme_color_override("font_color", ItemRules.rarity_color(it).darkened(0.4))
		rows.add_child(row)
	var close := Button.new()
	close.text = "Fermer"
	close.add_theme_font_size_override("font_size", 20)
	close.add_theme_color_override("font_color", COL_TXT)
	close.add_theme_stylebox_override("normal", _flat())
	close.pressed.connect(overlay.queue_free)
	box.add_child(close)
