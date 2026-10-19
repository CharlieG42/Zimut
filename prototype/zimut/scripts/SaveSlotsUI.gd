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
	add_child(_root)
	UiFit.apply(_root, 1.0, Vector2(1300, 760))   # réglage « Taille du texte »

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
	# Importer une partie exportée (code copié dans le presse-papiers)
	var imp := Button.new()
	imp.text = "📥  Importer une partie"
	imp.custom_minimum_size = Vector2(0, 56)
	imp.add_theme_font_size_override("font_size", _ui_font(17))
	imp.add_theme_color_override("font_color", Color(0.95, 0.94, 0.90))
	imp.add_theme_stylebox_override("normal", _flat_bg(Color(0.16, 0.20, 0.27), Color(0.45, 0.52, 0.66), 2))
	imp.add_theme_stylebox_override("hover", _flat_bg(Color(0.22, 0.27, 0.36), Color(0.75, 0.80, 0.95), 3))
	imp.tooltip_text = "Copiez d'abord un code « ZIMUT1:… » (bouton Exporter), puis touchez ici : la partie va dans le premier emplacement libre."
	imp.pressed.connect(_on_import_pressed)
	_slots_box.add_child(imp)

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
		_prompt_pseudo(slot)
		return
	_current = data
	_current_slot = slot
	refresh()


var _gultur_busy: bool = false

## Tutoriel de Gultur sur « Mes Parties » : accueil, puis déblocage de l'Aventure (niv 3)
## et de la Conquête (niv 5). Chaque étape ne s'affiche qu'une fois.
func _start_tutorial(data: Dictionary, tac_btn: Button) -> void:
	if _gultur_busy or not GameSettings.tutorial_enabled:
		return
	GameManager.active_save = data
	var steps: Array = []
	if Gultur.should_show("intro"):
		steps.append(["intro", Gultur.INTRO, tac_btn])
	if Gultur.should_show("lvl3") and ProgressionManager.mode_unlocked(data, "adventure"):
		steps.append(["lvl3", Gultur.LVL3, null])
	if Gultur.should_show("lvl5") and ProgressionManager.mode_unlocked(data, "conquest"):
		steps.append(["lvl5", Gultur.LVL5, null])
	if steps.is_empty():
		return
	_gultur_busy = true
	_run_tutorial_steps.call_deferred(steps)


func _run_tutorial_steps(steps: Array) -> void:
	if steps.is_empty():
		_gultur_busy = false
		return
	var s: Array = steps.pop_front()
	var g: Gultur = Gultur.say(self, String(s[0]), s[1], s[2] as Control, func() -> void: _run_tutorial_steps(steps))
	if g == null:
		_gultur_busy = false


## Nouvelle partie : demande le pseudo du joueur (le même pseudo peut servir plusieurs fois).
func _prompt_pseudo(slot: int) -> void:
	var overlay := ColorRect.new()
	overlay.name = "PseudoDialog"
	overlay.color = Color(0, 0, 0, 0.6)
	overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	_root.add_child(overlay)
	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(center)
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _flat())
	center.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	box.custom_minimum_size = Vector2(560, 0)
	panel.add_child(box)
	var t := Label.new()
	t.text = "Quel est ton pseudo, voyageur ?"
	t.add_theme_font_size_override("font_size", _ui_font(26))
	t.add_theme_color_override("font_color", COL_TXT)
	box.add_child(t)
	var line := LineEdit.new()
	line.name = "PseudoEdit"
	line.placeholder_text = "Ton pseudo"
	line.max_length = 20
	line.custom_minimum_size = Vector2(0, 56)
	line.add_theme_font_size_override("font_size", _ui_font(24))
	box.add_child(line)
	var sub := Label.new()
	sub.text = "Le même pseudo peut être utilisé par plusieurs parties."
	sub.add_theme_font_size_override("font_size", _ui_font(16))
	sub.add_theme_color_override("font_color", Color(0.4, 0.3, 0.15))
	box.add_child(sub)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	box.add_child(row)
	var cancel := Button.new()
	cancel.text = "Annuler"
	cancel.custom_minimum_size = Vector2(0, 56)
	cancel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cancel.add_theme_font_size_override("font_size", _ui_font(22))
	cancel.pressed.connect(func() -> void: overlay.queue_free())
	row.add_child(cancel)
	var ok := Button.new()
	ok.name = "PseudoOk"
	ok.text = "COMMENCER"
	ok.custom_minimum_size = Vector2(0, 56)
	ok.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	ok.add_theme_font_size_override("font_size", _ui_font(22))
	var go := func() -> void:
		var pseudo: String = line.text.strip_edges()
		overlay.queue_free()
		_create_game(slot, pseudo)
	ok.pressed.connect(go)
	line.text_submitted.connect(func(_t: String) -> void: go.call())
	row.add_child(ok)
	line.grab_focus()


func _create_game(slot: int, pseudo: String) -> void:
	_current = ProgressionManager.new_game(slot, pseudo)
	GameManager.active_save = _current
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
	title.add_theme_font_size_override("font_size", _ui_font(20 if compact else 24))
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
	diff_lbl.add_theme_font_size_override("font_size", _ui_font(17))
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
		db.custom_minimum_size = Vector2(0, 44)
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
	diff_hint.text = "Facile ×0,85 · Normal ×1 · Difficile ×1,2 · Enfer : bien plus de PV."
	diff_hint.add_theme_font_size_override("font_size", _ui_font(13))
	diff_hint.add_theme_color_override("font_color", COL_BORDER.darkened(0.3))
	diff_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_detail_box.add_child(diff_hint)
	_detail_box.add_child(_section_separator())

	# Les trois modes utilisent la même sauvegarde : roster, XP, caractéristiques,
	# sorts, équipement et inventaire ne sont jamais dupliqués par mode.
	var mode_lbl := Label.new()
	mode_lbl.text = "CHOISIR UN MODE DE JEU"
	mode_lbl.add_theme_font_size_override("font_size", _ui_font(18))
	mode_lbl.add_theme_color_override("font_color", COL_TXT)
	_detail_box.add_child(mode_lbl)
	var modes_row := HBoxContainer.new()
	modes_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	modes_row.add_theme_constant_override("separation", 10)
	_detail_box.add_child(modes_row)
	var tac_btn: Button = _mode_button("Combats Tactiques",
		"Combats stratégiques au tour par tour", "res://assets/ui/modes/mode_tactique.png",
		Color(0.22, 0.43, 0.69), true, func() -> void:
			_current.erase("campaign_mode")
			ProgressionManager.write_save(slot, _current)
			GameManager.active_save = ProgressionManager.load_save(slot)
			GameManager.active_slot = slot
			GameManager.fight_biome = "Forêt"
			battle_requested.emit(slot)
			get_tree().change_scene_to_file("res://scenes/TeamSelection.tscn"))
	modes_row.add_child(tac_btn)
	var adv_ok: bool = ProgressionManager.mode_unlocked(data, "adventure")
	var con_ok: bool = ProgressionManager.mode_unlocked(data, "conquest")
	modes_row.add_child(_mode_button("Aventure",
		"Explorez, découvrez et relevez des défis", "res://assets/ui/modes/mode_aventure.png",
		Color(0.22, 0.48, 0.31), adv_ok, func() -> void:
			_launch_campaign_mode("adventure", "res://scenes/AdventureMap.tscn", slot)))
	modes_row.add_child(_mode_button("Conquête",
		"Conquérez les cités par les armes", "res://assets/ui/modes/mode_conquete.png",
		Color(0.62, 0.25, 0.20), con_ok, func() -> void:
			_launch_campaign_mode("conquest", "res://scenes/ConquestMap.tscn", slot)))

	_start_tutorial(data, tac_btn)

	# Les 6 boutons illustrés tiennent sur 2 lignes de 3 (plus de défilement nécessaire).
	var grid := GridContainer.new()
	grid.columns = 3
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 6)
	_detail_box.add_child(grid)

	var team_btn := _action_button("team", "Gérer l'équipe (libre à chaque combat)", COL_TXT)
	team_btn.pressed.connect(func() -> void:
		get_tree().change_scene_to_file("res://scenes/TeamSelection.tscn"))
	grid.add_child(team_btn)

	var chars_btn := _action_button("chars", "PERSONNAGES — niveaux et caractéristiques", COL_TXT)
	chars_btn.pressed.connect(func() -> void:
		var ui: CanvasLayer = (load("res://scripts/CharacterSheetUI.gd") as GDScript).new()
		ui.layer = 10
		add_child(ui)
		ui.closed.connect(func() -> void:
			ui.queue_free()
			_show_detail(ProgressionManager.load_save(slot), slot))
		ui.open(_current, slot))
	grid.add_child(chars_btn)

	var forge_btn := _action_button("forge", "Forge : fabriquer ou briser de l'équipement", COL_TXT)
	forge_btn.pressed.connect(func() -> void: _open_forge(slot))
	grid.add_child(forge_btn)
	var gov_btn := _action_button("governors", "Gouverneurs en place dans vos villes", COL_TXT)
	gov_btn.pressed.connect(func() -> void: _show_governors(_current))
	grid.add_child(gov_btn)

	# Trophées : succès et bestiaire de la partie
	var tro_row := HBoxContainer.new()
	tro_row.add_theme_constant_override("separation", 10)
	_detail_box.add_child(tro_row)
	var n_ach: int = (data.get("achievements", {}) as Dictionary).size()
	var n_best: int = (data.get("bestiary", {}) as Dictionary).size()
	var inv_btn := Button.new()
	inv_btn.name = "InventoryButton"
	inv_btn.text = "🎒  Inventaire  (%d)" % (data.get("inventory", []) as Array).size()
	inv_btn.custom_minimum_size = Vector2(0, 50)
	inv_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	inv_btn.add_theme_font_size_override("font_size", _ui_font(18))
	inv_btn.add_theme_color_override("font_color", Color(0.98, 0.92, 0.75))
	inv_btn.add_theme_stylebox_override("normal", _flat_bg(Color(0.30, 0.22, 0.10), Color(0.85, 0.65, 0.28), 3))
	inv_btn.add_theme_stylebox_override("hover", _flat_bg(Color(0.40, 0.30, 0.14), Color(1.0, 0.80, 0.40), 3))
	inv_btn.pressed.connect(func() -> void: _open_inventory(slot))
	tro_row.add_child(inv_btn)
	for tb: Array in [["succes", "🏆  Succès  %d / %d" % [n_ach, Achievements.LIST.size()]], ["bestiaire", "📖  Bestiaire  (%d)" % n_best]]:
		var tab_key: String = String(tb[0])
		var tbtn := Button.new()
		tbtn.text = String(tb[1])
		tbtn.custom_minimum_size = Vector2(0, 50)
		tbtn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tbtn.add_theme_font_size_override("font_size", _ui_font(18))
		tbtn.add_theme_color_override("font_color", Color(0.98, 0.92, 0.75))
		tbtn.add_theme_stylebox_override("normal", _flat_bg(Color(0.30, 0.22, 0.10), Color(0.85, 0.65, 0.28), 3))
		tbtn.add_theme_stylebox_override("hover", _flat_bg(Color(0.40, 0.30, 0.14), Color(1.0, 0.80, 0.40), 3))
		tbtn.pressed.connect(func() -> void: _open_trophies(slot, tab_key))
		tro_row.add_child(tbtn)
	# V27 : Pierres Élémentaires (objectif final)
	var st_btn := Button.new()
	st_btn.name = "StonesButton"
	st_btn.text = "💎  Pierres  %d / %d" % [Stones.count(data), Stones.ORDER.size()]
	st_btn.custom_minimum_size = Vector2(0, 50)
	st_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	st_btn.add_theme_font_size_override("font_size", _ui_font(18))
	st_btn.add_theme_color_override("font_color", Color(0.85, 0.95, 1.0))
	st_btn.add_theme_stylebox_override("normal", _flat_bg(Color(0.12, 0.20, 0.32), Color(0.55, 0.80, 1.0), 3))
	st_btn.add_theme_stylebox_override("hover", _flat_bg(Color(0.16, 0.27, 0.42), Color(0.70, 0.90, 1.0), 3))
	st_btn.pressed.connect(func() -> void: _open_stones(slot))
	var goal_row := HBoxContainer.new()
	goal_row.add_theme_constant_override("separation", 10)
	_detail_box.add_child(goal_row)
	goal_row.add_child(st_btn)
	# V28 : tableau des primes du jour
	Bounties.ensure(data)
	var bo_btn := Button.new()
	bo_btn.name = "BountiesButton"
	bo_btn.text = "📜  Primes du jour  %d / %d" % [Bounties.done_count(data), Bounties.PER_DAY]
	bo_btn.custom_minimum_size = Vector2(0, 50)
	bo_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bo_btn.add_theme_font_size_override("font_size", _ui_font(18))
	bo_btn.add_theme_color_override("font_color", Color(1.0, 0.92, 0.70))
	bo_btn.add_theme_stylebox_override("normal", _flat_bg(Color(0.32, 0.18, 0.10), Color(0.95, 0.60, 0.30), 3))
	bo_btn.add_theme_stylebox_override("hover", _flat_bg(Color(0.42, 0.24, 0.12), Color(1.0, 0.75, 0.40), 3))
	bo_btn.pressed.connect(func() -> void: _open_bounties(slot))
	goal_row.add_child(bo_btn)
	# Objectifs (Pierres, primes) juste sous les modes de jeu : visibles sans défiler
	_detail_box.move_child(goal_row, grid.get_index())

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

	grid.add_child(rename_btn)
	grid.add_child(delete_btn)

	# Sauvegarde exportable : code texte copié dans le presse-papiers
	var exp_btn := Button.new()
	exp_btn.text = "📋  Exporter la partie"
	exp_btn.custom_minimum_size = Vector2(0, 50)
	exp_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	exp_btn.add_theme_font_size_override("font_size", _ui_font(18))
	exp_btn.clip_text = true
	exp_btn.add_theme_color_override("font_color", COL_TXT)
	exp_btn.add_theme_stylebox_override("normal", _flat_bg(Color(0.86, 0.80, 0.64), Color(0.62, 0.48, 0.22), 2))
	exp_btn.add_theme_stylebox_override("hover", _flat_bg(Color(0.95, 0.90, 0.75), Color(0.62, 0.48, 0.22), 3))
	exp_btn.tooltip_text = "Copie un code contenant toute la partie : collez-le dans une note ou un message pour la garder ou la transférer sur un autre appareil (bouton « Importer une partie »)."
	exp_btn.pressed.connect(func() -> void:
		var res: String = _export_game()
		exp_btn.text = res)
	tro_row.add_child(exp_btn)

## Export : fichier « Zimut_<pseudo>.zimut » (texte ZIMUT1, voir ProgressionManager.EXPORT_PREFIX)
## + copie du même code dans le presse-papiers. Retourne le libellé du bouton.
func _export_game() -> String:
	var code: String = ProgressionManager.export_code(_current)
	DisplayServer.clipboard_set(code)
	var base: String = "Zimut_%s.%s" % [ProgressionManager.safe_file_stem(String(_current.get("name", "partie"))), ProgressionManager.EXPORT_EXT]
	if DisplayServer.has_feature(DisplayServer.FEATURE_NATIVE_DIALOG_FILE):
		DisplayServer.file_dialog_show("Exporter la partie", "", base, false, DisplayServer.FILE_DIALOG_MODE_SAVE_FILE,
			PackedStringArray(["*.%s ; Partie Zimut" % ProgressionManager.EXPORT_EXT]),
			func(ok: bool, paths: PackedStringArray, _f: int) -> void:
				if ok and paths.size() > 0:
					var f := FileAccess.open(paths[0], FileAccess.WRITE)
					if f != null:
						f.store_string(code)
						f.close())
		return "✓  Exporté (+ code copié)"
	# Pas de sélecteur de fichier natif : fichier dans user://exports + code copié.
	DirAccess.make_dir_recursive_absolute("user://exports")
	var f2 := FileAccess.open("user://exports/" + base, FileAccess.WRITE)
	if f2 != null:
		f2.store_string(code)
		f2.close()
	return "✓  Code copié !"


## Choix de la source d'import : fichier .zimut ou presse-papiers.
func _on_import_pressed() -> void:
	if not DisplayServer.has_feature(DisplayServer.FEATURE_NATIVE_DIALOG_FILE):
		_import_text(DisplayServer.clipboard_get())
		return
	var dlg := ConfirmationDialog.new()
	dlg.title = "Importer une partie"
	dlg.dialog_text = "D'où importer la partie ?"
	dlg.ok_button_text = "Fichier .%s" % ProgressionManager.EXPORT_EXT
	dlg.cancel_button_text = "Presse-papiers"
	dlg.confirmed.connect(func() -> void:
		DisplayServer.file_dialog_show("Importer une partie", "", "", false, DisplayServer.FILE_DIALOG_MODE_OPEN_FILE,
			PackedStringArray(["*.%s ; Partie Zimut" % ProgressionManager.EXPORT_EXT, "*.txt ; Code texte"]),
			func(ok: bool, paths: PackedStringArray, _f: int) -> void:
				if ok and paths.size() > 0:
					_import_text(FileAccess.get_file_as_string(paths[0]))))
	dlg.canceled.connect(func() -> void: _import_text(DisplayServer.clipboard_get()))
	_root.add_child(dlg)
	dlg.popup_centered()


## Importe un code (texte) dans le premier emplacement libre.
func _import_text(text: String) -> void:
	var free_slot: int = -1
	for i: int in range(ProgressionManager.MAX_SAVES):
		if not ProgressionManager.save_exists(i):
			free_slot = i
			break
	var msg: String = ""
	if free_slot < 0:
		msg = "Aucun emplacement libre : supprimez d'abord une partie."
	else:
		var err: String = ProgressionManager.import_save(free_slot, text)
		msg = err if err != "" else "Partie importée dans l'emplacement %d." % (free_slot + 1)
		if err == "":
			_current = ProgressionManager.load_save(free_slot)
			_current_slot = free_slot
			refresh()
	var dlg := AcceptDialog.new()
	dlg.dialog_text = msg
	dlg.title = "Importer une partie"
	_root.add_child(dlg)
	dlg.popup_centered()


func _launch_campaign_mode(mode: String, scene_path: String, slot: int) -> void:
	if _current.is_empty() or slot < 0:
		return
	if not ProgressionManager.mode_unlocked(_current, mode):
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
	"team": "res://assets/ui/actions/plain_team.png",
	"chars": "res://assets/ui/actions/plain_chars.png",
	"forge": "res://assets/ui/actions/plain_forge.png",
	"governors": "res://assets/ui/actions/plain_governors.png",
	"rename": "res://assets/ui/actions/plain_rename.png",
	"delete": "res://assets/ui/actions/plain_delete.png",
}
## Libellé écrit par Godot sur la plaque (donc traduisible, contrairement à un texte cuit dans le PNG).
const ACTION_LABELS := {
	"team": "Gérer l'équipe", "chars": "Personnages", "forge": "Forge",
	"governors": "Gouverneurs", "rename": "Renommer", "delete": "Supprimer",
}
const ACTION_ASPECT := 512.0 / 192.0

## Bouton d'action illustré : plaque + icône (PNG sans texte) et libellé dessiné par Godot.
## `txt` reste l'info-bulle.
func _action_button(icon_key: String, txt: String, _txt_col: Color, height: float = 0.0) -> Button:
	var b := Button.new()
	b.tooltip_text = txt
	var h: float = height if height > 0.0 else (84.0 if _is_compact() else 96.0)
	b.custom_minimum_size = Vector2(0, h)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.focus_mode = Control.FOCUS_ALL
	var icon_path: String = String(ACTION_ICONS.get(icon_key, ""))
	var art: Control = null
	if icon_path != "" and ResourceLoader.exists(icon_path):
		var arc := AspectRatioContainer.new()
		arc.ratio = ACTION_ASPECT
		arc.set_anchors_preset(Control.PRESET_FULL_RECT)
		arc.mouse_filter = Control.MOUSE_FILTER_IGNORE
		b.add_child(arc)
		var tr := TextureRect.new()
		tr.texture = load(icon_path) as Texture2D
		tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tr.stretch_mode = TextureRect.STRETCH_SCALE
		tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
		arc.add_child(tr)
		art = arc
		var lab := Label.new()
		lab.text = String(ACTION_LABELS.get(icon_key, txt))
		lab.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lab.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		lab.anchor_left = 0.40
		lab.anchor_right = 0.955
		lab.anchor_top = 0.2
		lab.anchor_bottom = 0.8
		lab.offset_left = 0.0
		lab.offset_right = 0.0
		lab.offset_top = 0.0
		lab.offset_bottom = 0.0
		lab.clip_text = true
		lab.mouse_filter = Control.MOUSE_FILTER_IGNORE
		lab.add_theme_color_override("font_color", Color(1.0, 0.96, 0.87))
		lab.add_theme_color_override("font_outline_color", Color(0.20, 0.12, 0.06))
		tr.add_child(lab)
		# taille de police adaptée à la hauteur du bouton ET à la largeur du libellé (FR/EN)
		var fit := func() -> void:
			if not is_instance_valid(lab) or not is_instance_valid(tr):
				return
			var bh: float = tr.size.y
			var avail: float = tr.size.x * (lab.anchor_right - lab.anchor_left) - 6.0
			var fs: int = maxi(12, roundi(bh * 0.30))
			var font: Font = lab.get_theme_font("font")
			while fs > 12 and font.get_string_size(lab.text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x > avail:
				fs -= 1
			lab.add_theme_font_size_override("font_size", fs)
			lab.add_theme_constant_override("outline_size", maxi(3, roundi(float(fs) * 0.2)))
		tr.resized.connect(fit)
		fit.call_deferred()
	else:
		b.text = txt

	# StyleBoxEmpty : seul le visuel illustré reste visible.
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
	b.custom_minimum_size = Vector2(0, 120 if _is_compact() else 160)
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
		art.modulate = Color(0.30, 0.30, 0.36)
	b.add_child(art)
	if not enabled:
		var need: int = int(ProgressionManager.MODE_MIN_LEVEL.get("adventure" if title_txt == "Aventure" else "conquest", 1))
		b.tooltip_text = "%s — verrouillé : atteignez le niveau %d avec un de vos héros." % [title_txt, need]
		var lock := Label.new()
		lock.name = "LockLabel"
		lock.text = "🔒\nNiveau %d requis" % need
		lock.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		lock.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		lock.set_anchors_preset(Control.PRESET_FULL_RECT)
		lock.mouse_filter = Control.MOUSE_FILTER_IGNORE
		lock.add_theme_font_size_override("font_size", _ui_font(22))
		lock.add_theme_color_override("font_color", Color(1.0, 0.9, 0.6))
		lock.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.95))
		lock.add_theme_constant_override("outline_size", 8)
		b.add_child(lock)

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

func _open_trophies(slot: int, tab: String) -> void:
	if _current.is_empty() or slot < 0:
		return
	var ui: CanvasLayer = (load("res://scripts/TrophyUI.gd") as GDScript).new()
	ui.layer = 10
	add_child(ui)
	ui.closed.connect(func() -> void: ui.queue_free())
	ui.open(_current, tab)


func _open_bounties(slot: int) -> void:
	if _current.is_empty() or slot < 0:
		return
	var ui: CanvasLayer = (load("res://scripts/BountiesUI.gd") as GDScript).new()
	ui.layer = 20
	add_child(ui)
	ui.closed.connect(func() -> void:
		ui.queue_free()
		_show_detail(ProgressionManager.load_save(slot), slot))
	ui.open(_current)


func _open_stones(slot: int) -> void:
	if _current.is_empty() or slot < 0:
		return
	var ui: CanvasLayer = (load("res://scripts/StonesUI.gd") as GDScript).new()
	ui.layer = 20
	add_child(ui)
	ui.closed.connect(func() -> void:
		ui.queue_free()
		_show_detail(ProgressionManager.load_save(slot), slot))
	ui.open(_current, slot)


func _open_forge(slot: int, mode: String = "") -> void:
	if _current.is_empty() or slot < 0:
		return
	var ui: CanvasLayer = (load("res://scripts/ForgeUI.gd") as GDScript).new()
	ui.layer = 20
	add_child(ui)
	ui.closed.connect(func() -> void:
		ui.queue_free()
		_show_detail(ProgressionManager.load_save(slot), slot))
	ui.open(_current, slot, 0)
	if mode != "" and ui.has_method("show_mode"):
		ui.call("show_mode", mode)


## Inventaire complet (objets libres et portés) avec tri, filtres et envoi groupé au Briseur / à la Fusion.
func _open_inventory(slot: int) -> void:
	if _current.is_empty() or slot < 0:
		return
	var ui: CanvasLayer = (load("res://scripts/InventoryUI.gd") as GDScript).new()
	ui.layer = 20
	add_child(ui)
	ui.closed.connect(func() -> void:
		ui.queue_free()
		_show_detail(ProgressionManager.load_save(slot), slot))
	ui.fusion_requested.connect(func() -> void:
		ui.queue_free()
		_open_forge(slot, "fusion"))
	ui.open(_current, slot)

## Vue d'ensemble des gouverneurs en place (mode Conquête).
func _show_governors(data: Dictionary) -> void:
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
	box.custom_minimum_size = Vector2(620 if _is_compact() else 760, 0)
	dialog.add_child(box)
	var conq: Dictionary = data.get("conquest", {})
	var owned: Array = conq.get("owned", [])
	var title := Label.new()
	title.text = "GOUVERNEURS EN PLACE"
	title.add_theme_font_size_override("font_size", _ui_font(24))
	title.add_theme_color_override("font_color", COL_TXT)
	box.add_child(title)
	if owned.is_empty():
		var none := Label.new()
		none.text = "Aucune ville conquise : lancez le mode Conquête pour fonder votre empire."
		none.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		none.add_theme_font_size_override("font_size", _ui_font(18))
		none.add_theme_color_override("font_color", COL_TXT)
		box.add_child(none)
	else:
		var stationed: int = ConquestSystem.stationed_heroes(conq).size()
		var sub := Label.new()
		sub.text = "%d ville(s) · %d gouverneur(s) en poste (6 max)" % [owned.size(), stationed]
		sub.add_theme_font_size_override("font_size", _ui_font(16))
		sub.add_theme_color_override("font_color", COL_TXT.darkened(0.2))
		box.add_child(sub)
		var scroll := ScrollContainer.new()
		TouchScroll.install(scroll)
		scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		scroll.custom_minimum_size = Vector2(0, 320 if _is_compact() else 480)
		box.add_child(scroll)
		var rows := VBoxContainer.new()
		rows.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		rows.add_theme_constant_override("separation", 6)
		scroll.add_child(rows)
		for id: String in owned:
			var hero: String = ConquestSystem.hero_of(conq, id)
			var row := Label.new()
			row.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			row.custom_minimum_size = Vector2(0, 0)
			row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			row.add_theme_font_size_override("font_size", _ui_font(17))
			var city_name: String = ConquestSystem._name(conq, id)
			if hero == "":
				row.text = "⌂ %s — aucun gouverneur" % city_name
				row.add_theme_color_override("font_color", COL_TXT.darkened(0.35))
			else:
				var lvl: int = int(data.get("roster", {}).get(hero, {}).get("level", 1))
				row.text = "♞ %s — %s (niv. %d) : %s" % [city_name, hero, lvl, ConquestSystem.governor_text(hero)]
				row.add_theme_color_override("font_color", COL_TXT)
			rows.add_child(row)
	var close := Button.new()
	close.text = "Fermer"
	close.add_theme_font_size_override("font_size", _ui_font(20))
	close.add_theme_color_override("font_color", COL_TXT)
	close.add_theme_stylebox_override("normal", _flat())
	close.pressed.connect(overlay.queue_free)
	box.add_child(close)
