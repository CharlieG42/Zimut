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
var _slots_content: VBoxContainer
var _slots_panel: PanelContainer
var _detail_panel: PanelContainer
var _detail_box: VBoxContainer
var _main_layout: BoxContainer
var _slots_scroll: ScrollContainer
var _detail_scroll: ScrollContainer
var _current: Dictionary = {}     # sauvegarde affichée dans le détail
var _current_slot: int = -1

func _ready() -> void:
	_build()
	# À l'ouverture : afficher directement les détails de la partie en cours
	# (la plus récente), sans attendre un clic sur un slot.
	var saves: Array = ProgressionManager.list_saves()
	if not saves.is_empty():
		var latest: Dictionary = saves[0]
		for entry: Dictionary in saves:
			if String(entry.get("timestamp", "")) > String(latest.get("timestamp", "")):
				latest = entry
		_show_detail(ProgressionManager.load_save(int(latest.get("id", 0))), int(latest.get("id", 0)))
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
	back.text = "← ACCUEIL"
	back.custom_minimum_size = Vector2(150, 56)
	back.add_theme_font_size_override("font_size", _ui_font(20))
	back.add_theme_color_override("font_color", COL_TXT)
	back.add_theme_stylebox_override("normal", _flat())
	back.add_theme_stylebox_override("hover", _flat())
	back.pressed.connect(func() -> void:
		GameManager.active_save = {}
		GameManager.active_slot = -1
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn"))
	top.add_child(back)

	var title := Label.new()
	title.text = "ZIMUT  ·  MES PARTIES"
	title.add_theme_font_size_override("font_size", _ui_font(30))
	title.add_theme_color_override("font_color", Color(0.96, 0.84, 0.52))
	title.tooltip_text = "Jusqu’à %d sauvegardes" % ProgressionManager.MAX_SAVES
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	top.add_child(title)

	# Zone principale : slots + détail, côte à côte en largeur, empilés sinon
	var main := HBoxContainer.new()
	_main_layout = main
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

	var slots_panel := PanelContainer.new()
	_slots_panel = slots_panel
	slots_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slots_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	slots_panel.add_theme_stylebox_override("panel", _slots_panel_style())
	main.add_child(slots_panel)

	var slots_scroll := ScrollContainer.new()
	TouchScroll.install(slots_scroll)
	_slots_scroll = slots_scroll
	slots_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slots_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	slots_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	slots_panel.add_child(slots_scroll)

	_slots_content = VBoxContainer.new()
	_slots_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_slots_content.add_theme_constant_override("separation", 10)
	slots_scroll.add_child(_slots_content)

	var slots_heading := Label.new()
	slots_heading.text = "MES PARTIES"
	slots_heading.add_theme_font_size_override("font_size", _ui_font(22))
	slots_heading.add_theme_color_override("font_color", Color(0.96, 0.84, 0.52))
	_slots_content.add_child(slots_heading)

	var slots_subtitle := Label.new()
	slots_subtitle.text = "Choisis ta sauvegarde"
	slots_subtitle.add_theme_font_size_override("font_size", _ui_font(15))
	slots_subtitle.add_theme_color_override("font_color", Color(0.77, 0.81, 0.87))
	slots_subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_slots_content.add_child(slots_subtitle)

	_slots_box = VBoxContainer.new()
	_slots_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_slots_box.add_theme_constant_override("separation", 10)
	_slots_content.add_child(_slots_box)

	_detail_panel = PanelContainer.new()
	_detail_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_detail_panel.add_theme_stylebox_override("panel", _flat())
	main.add_child(_detail_panel)

	_detail_scroll = ScrollContainer.new()
	TouchScroll.install(_detail_scroll)
	_detail_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_detail_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_detail_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_detail_panel.add_child(_detail_scroll)

	_detail_box = VBoxContainer.new()
	_detail_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_detail_box.add_theme_constant_override("separation", 8)
	_detail_scroll.add_child(_detail_box)

	get_viewport().size_changed.connect(_apply_responsive_layout)
	refresh()
	_apply_responsive_layout()

func _is_compact() -> bool:
	return get_viewport().get_visible_rect().size.x <= 1000.0

func _use_stacked_layout() -> bool:
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	return viewport_size.x < 650.0 or viewport_size.x / maxf(viewport_size.y, 1.0) < 1.15

func _ui_font(base_size: int) -> int:
	var width: float = get_viewport().get_visible_rect().size.x
	var scale: float = 1.15
	if width <= 600.0:
		scale = 0.82
	elif width <= 1000.0:
		scale = 0.95
	return maxi(12, roundi(float(base_size) * scale))

func _apply_responsive_layout() -> void:
	if _main_layout == null or _slots_scroll == null or _detail_panel == null:
		return
	var stacked: bool = _use_stacked_layout()
	if _main_layout.vertical != stacked:
		_main_layout.vertical = stacked
	_main_layout.add_theme_constant_override("separation", 10 if stacked else 16)
	_slots_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_slots_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_slots_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_slots_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_detail_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_detail_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	if stacked:
		_slots_panel.custom_minimum_size = Vector2(0, 0)
		_slots_panel.size_flags_stretch_ratio = 0.30
		_detail_panel.size_flags_stretch_ratio = 0.70
		_slots_scroll.custom_minimum_size = Vector2(0, 0)
	else:
		_slots_panel.custom_minimum_size = Vector2(260, 0)
		_slots_panel.size_flags_stretch_ratio = 0.27
		_detail_panel.size_flags_stretch_ratio = 0.73
		_slots_scroll.custom_minimum_size = Vector2(0, 0)

func _slots_panel_style() -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0.09, 0.12, 0.18, 0.98)
	s.border_color = Color(0.58, 0.46, 0.25, 1.0)
	s.set_border_width_all(2)
	s.set_corner_radius_all(14)
	s.content_margin_left = 12
	s.content_margin_right = 12
	s.content_margin_top = 14
	s.content_margin_bottom = 14
	return s

## Séparateur discret entre les sections de la fiche de partie.
func _section_separator() -> HSeparator:
	var sep := HSeparator.new()
	sep.add_theme_color_override("color", COL_BORDER)
	return sep

func _flat() -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = COL_PANEL
	s.border_color = COL_BORDER
	s.set_border_width_all(3)
	s.set_corner_radius_all(12)
	s.content_margin_left = 12
	s.content_margin_right = 12
	s.content_margin_top = 10
	s.content_margin_bottom = 10
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
		btn.custom_minimum_size = Vector2(0, 76 if _is_compact() else 88)
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		var is_used: bool = used.has(slot)
		if is_used:
			var sv: Dictionary = used[slot]
			btn.text = "✦  PARTIE %d\n%s\nNiv. ennemis %d  ·  %d victoires" % [slot + 1, sv["name"], sv["level"], sv["victories"]]
			btn.add_theme_stylebox_override("normal", _flat_bg(COL_SLOT_USED_BG, COL_BORDER, 2))
			btn.add_theme_stylebox_override("hover", _flat_bg(COL_SLOT_USED_BG.lightened(0.12), COL_BORDER, 3))
		else:
			btn.text = "＋  NOUVELLE PARTIE\nEmplacement libre %d" % (slot + 1)
			btn.add_theme_stylebox_override("normal", _flat_bg(COL_SLOT_EMPTY_BG, Color(0.3, 0.35, 0.45), 1))
			btn.add_theme_stylebox_override("hover", _flat_bg(COL_SLOT_EMPTY_BG.lightened(0.12), Color(0.58, 0.46, 0.25), 2))
		btn.add_theme_font_size_override("font_size", _ui_font(20))
		btn.add_theme_color_override("font_color", Color(0.95, 0.94, 0.90))
		if slot == _current_slot:
			btn.add_theme_color_override("font_color", Color(1.0, 0.86, 0.4))
			btn.add_theme_stylebox_override("normal", _flat_bg(Color(0.25, 0.28, 0.31), Color(1.0, 0.78, 0.28), 4))
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
	message.add_theme_font_size_override("font_size", _ui_font(22))
	message.add_theme_color_override("font_color", COL_TXT)
	_detail_box.add_child(message)

func _show_detail(data: Dictionary, slot: int) -> void:
	_current = data
	_current_slot = slot
	for c: Node in _detail_box.get_children():
		c.queue_free()

	var compact: bool = _is_compact()
	var title := Label.new()
	title.text = "✦  %s" % String(data.get("name", "Partie"))
	title.add_theme_font_size_override("font_size", _ui_font(20 if compact else 26))
	title.add_theme_color_override("font_color", COL_TXT)
	_detail_box.add_child(title)
	var summary := Label.new()
	summary.text = "ENNEMIS NV %d     ·     %d VICTOIRE(S)     ·     EMPLACEMENT %d" % [
		int(data.get("level", 10)), int(data.get("victories", 0)), slot + 1]
	summary.add_theme_font_size_override("font_size", _ui_font(13 if compact else 15))
	summary.add_theme_color_override("font_color", COL_BORDER.darkened(0.3))
	_detail_box.add_child(summary)
	_detail_box.add_child(_section_separator())

	# Difficulté des ennemis : propre à cette partie, modifiable à tout moment.
	var diff_lbl := Label.new()
	diff_lbl.text = "DIFFICULTÉ DES ENNEMIS (cette partie)"
	diff_lbl.add_theme_font_size_override("font_size", _ui_font(18))
	diff_lbl.add_theme_color_override("font_color", COL_TXT)
	_detail_box.add_child(diff_lbl)
	var diff_row := HBoxContainer.new()
	diff_row.name = "DifficultyRow"
	diff_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	diff_row.add_theme_constant_override("separation", 8)
	_detail_box.add_child(diff_row)
	var diff_group := ButtonGroup.new()
	var cur_diff: int = GameSettings.save_difficulty(data)
	for di: int in range(GameSettings.DIFFICULTIES.size()):
		var db := Button.new()
		db.text = GameSettings.DIFFICULTIES[di]
		db.toggle_mode = true
		db.button_group = diff_group
		db.button_pressed = di == cur_diff
		db.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		db.custom_minimum_size = Vector2(0, 52)
		db.add_theme_font_size_override("font_size", _ui_font(19))
		db.add_theme_color_override("font_color", Color(0.95, 0.94, 0.90))
		db.add_theme_color_override("font_pressed_color", Color(1.0, 0.88, 0.45))
		db.add_theme_stylebox_override("normal", _flat_bg(COL_SLOT_USED_BG, COL_BORDER.darkened(0.2), 2))
		db.add_theme_stylebox_override("hover", _flat_bg(COL_SLOT_USED_BG.lightened(0.12), COL_BORDER, 2))
		db.add_theme_stylebox_override("pressed", _flat_bg(Color(0.34, 0.27, 0.12), Color(1.0, 0.78, 0.28), 4))
		var di_ref: int = di
		db.pressed.connect(func() -> void:
			_current["difficulty"] = di_ref
			ProgressionManager.write_save(slot, _current)
			if not GameManager.active_save.is_empty() and GameManager.active_slot == slot:
				GameManager.active_save["difficulty"] = di_ref)
		diff_row.add_child(db)
	var diff_hint := Label.new()
	diff_hint.text = "Facile ×0,85 · Normal ×1 · Difficile ×1,2 · Enfer : bien plus de PV. S'applique aux prochains combats."
	diff_hint.add_theme_font_size_override("font_size", _ui_font(13))
	diff_hint.add_theme_color_override("font_color", COL_BORDER.darkened(0.3))
	diff_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_detail_box.add_child(diff_hint)
	_detail_box.add_child(_section_separator())

	# Les trois modes utilisent la même sauvegarde : roster, XP, caractéristiques,
	# sorts, équipement et inventaire ne sont jamais dupliqués par mode.
	var mode_lbl := Label.new()
	mode_lbl.text = "CHOISIR UN MODE DE JEU"
	mode_lbl.add_theme_font_size_override("font_size", _ui_font(21))
	mode_lbl.add_theme_color_override("font_color", COL_TXT)
	_detail_box.add_child(mode_lbl)
	var modes_row := HBoxContainer.new()
	modes_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	modes_row.add_theme_constant_override("separation", 10)
	_detail_box.add_child(modes_row)
	modes_row.add_child(_mode_button("Combats Tactiques",
		"Combats stratégiques au tour par tour", "res://assets/ui/modes/mode_tactique.png",
		Color(0.22, 0.43, 0.69), true, func() -> void:
			_current.erase("campaign_mode")
			ProgressionManager.write_save(slot, _current)
			GameManager.active_save = ProgressionManager.load_save(slot)
			GameManager.active_slot = slot
			GameManager.fight_biome = "Forêt"
			battle_requested.emit(slot)
			get_tree().change_scene_to_file("res://scenes/TeamSelection.tscn")))
	modes_row.add_child(_mode_button("Aventure",
		"Explorez, découvrez et relevez des défis", "res://assets/ui/modes/mode_aventure.png",
		Color(0.22, 0.48, 0.31), true, func() -> void:
			_launch_campaign_mode("adventure", "res://scenes/AdventureMap.tscn", slot)))
	modes_row.add_child(_mode_button("Conquête",
		"Conquérez les cités par les armes", "res://assets/ui/modes/mode_conquete.png",
		Color(0.62, 0.25, 0.20), true, func() -> void:
			_launch_campaign_mode("conquest", "res://scenes/ConquestMap.tscn", slot)))

	# Actions principales sur une même ligne : les PNG sont plus lisibles et
	# prennent moins de hauteur que deux grands boutons empilés.
	var top_actions := HBoxContainer.new()
	top_actions.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_actions.add_theme_constant_override("separation", 10)
	_detail_box.add_child(top_actions)

	var team_btn := _action_button("team", "Gérer l'équipe (libre à chaque combat)", COL_TXT)
	team_btn.pressed.connect(func() -> void:
		get_tree().change_scene_to_file("res://scenes/TeamSelection.tscn"))
	team_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_actions.add_child(team_btn)

	var chars_btn := _action_button("chars", "PERSONNAGES — niveaux et caractéristiques", COL_TXT)
	chars_btn.pressed.connect(func() -> void:
		var ui: CanvasLayer = (load("res://scripts/CharacterSheetUI.gd") as GDScript).new()
		ui.layer = 10
		add_child(ui)
		ui.closed.connect(func() -> void:
			ui.queue_free()
			_show_detail(ProgressionManager.load_save(slot), slot))
		ui.open(_current, slot))
	chars_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top_actions.add_child(chars_btn)

	var inv: Array = data.get("inventory", [])
	var inv_lbl := Label.new()
	inv_lbl.text = "INVENTAIRE — %d OBJET(S) DISPONIBLE(S) À ÉQUIPER" % inv.size()
	inv_lbl.add_theme_font_size_override("font_size", _ui_font(21))
	inv_lbl.add_theme_color_override("font_color", COL_TXT)
	_detail_box.add_child(inv_lbl)

	var scroll := ScrollContainer.new()
	TouchScroll.install(scroll)
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
		row2.add_theme_font_size_override("font_size", _ui_font(16))
		row2.add_theme_color_override("font_color", ItemRules.rarity_color(it).darkened(0.4))
		inv_box.add_child(row2)

	var log_arr: Array = data.get("loot_log", [])
	var inventory_actions := HBoxContainer.new()
	inventory_actions.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	inventory_actions.add_theme_constant_override("separation", 10)
	var auto_btn := _action_button("autoequip", "Équiper automatiquement les meilleurs objets", COL_TXT)
	auto_btn.pressed.connect(_auto_equip)
	auto_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	inventory_actions.add_child(auto_btn)
	if log_arr.size() > 0:
		var log_btn := _action_button("inventory", "Voir tous les loots gagnés (%d)" % log_arr.size(), COL_TXT)
		log_btn.pressed.connect(func() -> void: _show_loot_log(log_arr))
		log_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		inventory_actions.add_child(log_btn)
	_detail_box.add_child(inventory_actions)

	var rename_btn := _action_button("rename", "RENOMMER CETTE PARTIE", COL_TXT)
	rename_btn.pressed.connect(func() -> void:
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
	var delete_btn := _action_button("delete", "SUPPRIMER CETTE PARTIE", Color(0.35, 0.08, 0.05))
	delete_btn.pressed.connect(func() -> void:
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

	# Renommer / Supprimer : en bas de la fiche, cote a cote
	var edit_row := HBoxContainer.new()
	edit_row.add_theme_constant_override("separation", 10)
	edit_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for c: Node in [rename_btn, delete_btn]:
		c.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		edit_row.add_child(c)
	_detail_box.add_child(edit_row)

func _launch_campaign_mode(mode: String, scene_path: String, slot: int) -> void:
	if _current.is_empty() or slot < 0:
		return
	_current["campaign_mode"] = mode
	if mode == "adventure" and not _current.has("adventure"):
		_current["adventure"] = ProgressionManager.adventure_state(_current)
	if mode == "conquest" and not _current.has("conquest"):
		_current["conquest"] = {"owned": ["capitale"], "pending_city": ""}
	if not ProgressionManager.write_save(slot, _current):
		return
	GameManager.active_slot = slot
	GameManager.active_save = ProgressionManager.load_save(slot)
	GameManager.clear_custom_team()
	get_tree().change_scene_to_file(scene_path)



## Bouton d'action illustré : vignette PNG à gauche du libellé.
## Les icônes vivent dans assets/ui/actions/action_<clé>.png ; privilégier une
## source haute résolution (512x256 ou plus, fond transparent) pour limiter le flou.
const ACTION_ICONS := {
	"team": "res://assets/ui/actions/action_team.png",
	"chars": "res://assets/ui/actions/action_chars.png",
	"inventory": "res://assets/ui/actions/action_inventory.png",
	"autoequip": "res://assets/ui/actions/action_autoequip.png",
	"rename": "res://assets/ui/actions/action_rename.png",
	"delete": "res://assets/ui/actions/action_delete.png",
}

## Bouton d'action illustré : on laisse le PNG porter tout le décor.
## Le contrôle Godot n'ajoute donc plus de cadre beige autour de l'image.
## La hauteur accrue permet au visuel (128x64, texte intégré) d'être nettement
## plus grand, tout en conservant une grille compacte de deux boutons par ligne.
func _action_button(icon_key: String, txt: String, txt_col: Color) -> Button:
	var b := Button.new()
	b.tooltip_text = txt
	b.custom_minimum_size = Vector2(0, 124 if _is_compact() else 144)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.focus_mode = Control.FOCUS_ALL
	var icon_path: String = String(ACTION_ICONS.get(icon_key, ""))
	var art: TextureRect
	if icon_path != "" and ResourceLoader.exists(icon_path):
		art = TextureRect.new()
		art.texture = load(icon_path) as Texture2D
		art.set_anchors_preset(Control.PRESET_FULL_RECT)
		art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		art.mouse_filter = Control.MOUSE_FILTER_IGNORE
		b.add_child(art)

	# Les anciennes bordures beige provenaient du StyleBox du Button.
	# StyleBoxEmpty supprime fond, contour et marge ajoutés par le thème ;
	# seul le bouton illustré reste visible.
	var empty := StyleBoxEmpty.new()
	b.add_theme_stylebox_override("normal", empty)
	b.add_theme_stylebox_override("hover", empty)
	b.add_theme_stylebox_override("pressed", empty)
	b.add_theme_stylebox_override("focus", empty)
	b.add_theme_stylebox_override("disabled", empty)
	if art != null:
		b.mouse_entered.connect(func() -> void: art.modulate = Color(1.12, 1.12, 1.12, 1.0))
		b.mouse_exited.connect(func() -> void: art.modulate = Color.WHITE)
	return b

const COL_DISABLED_BG := Color(0.14, 0.16, 0.22, 0.85)
const COL_DISABLED_BORDER := Color(0.28, 0.31, 0.39, 1.0)
const COL_DISABLED_TXT := Color(0.45, 0.48, 0.55)

## Carte de mode : l'illustration PNG occupe tout le bouton (elle est
## explicite), sans texte superposé ; le libellé reste en info-bulle.
func _mode_button(title_txt: String, desc: String, art_path: String, accent: Color, enabled: bool, cb: Callable) -> Button:
	var b := Button.new()
	b.text = ""
	b.tooltip_text = "%s — %s" % [title_txt, desc]
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.size_flags_stretch_ratio = 1.0
	b.custom_minimum_size = Vector2(0, 180 if _is_compact() else 240)
	b.disabled = not enabled
	b.focus_mode = Control.FOCUS_ALL if enabled else Control.FOCUS_NONE

	var art := TextureRect.new()
	if ResourceLoader.exists(art_path):
		art.texture = load(art_path) as Texture2D
	art.set_anchors_preset(Control.PRESET_FULL_RECT)
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	if not enabled:
		art.modulate = Color(0.45, 0.45, 0.5)
	b.add_child(art)

	var normal := StyleBoxFlat.new()
	normal.bg_color = COL_PANEL if enabled else COL_DISABLED_BG
	normal.border_color = accent if enabled else COL_DISABLED_BORDER
	normal.set_border_width_all(3)
	normal.set_corner_radius_all(12)
	normal.content_margin_left = 7
	normal.content_margin_right = 7
	normal.content_margin_top = 7
	normal.content_margin_bottom = 7
	var hover := normal.duplicate()
	if enabled:
		hover.bg_color = Color(0.99, 0.95, 0.83)
		hover.border_color = accent.lightened(0.25)
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
	title.add_theme_font_size_override("font_size", _ui_font(24))
	title.add_theme_color_override("font_color", COL_TXT)
	box.add_child(title)
	var scroll := ScrollContainer.new()
	TouchScroll.install(scroll)
	scroll.custom_minimum_size = Vector2(0, 360 if _is_compact() else 520)
	box.add_child(scroll)
	var rows := VBoxContainer.new()
	rows.add_theme_constant_override("separation", 6)
	scroll.add_child(rows)
	for it: Dictionary in log_arr:
		var row := Label.new()
		row.text = "✨ [%s] %s (nv%d) %s" % [ItemRules.rarity_label(it), it.get("name", "?"),
			int(it.get("level", 0)), ItemRules.stat_line(it)]
		row.add_theme_font_size_override("font_size", _ui_font(17))
		row.add_theme_color_override("font_color", ItemRules.rarity_color(it).darkened(0.4))
		rows.add_child(row)
	var close := Button.new()
	close.text = "Fermer"
	close.add_theme_font_size_override("font_size", _ui_font(20))
	close.add_theme_color_override("font_color", COL_TXT)
	close.add_theme_stylebox_override("normal", _flat())
	close.pressed.connect(overlay.queue_free)
	box.add_child(close)
