extends CanvasLayer

## MainMenuUI.gd — Écran d'accueil Zimut : deux options.
##   - « Entrer dans le monde de Zimut » : accès aux parties (slot de sauvegarde),
##     puis choix du mode de jeu (Combats Tactiques ; Aventure et Conquête à venir)
##   - « Réglages » : difficulté des combats et rapidité de progression XP

const COL_PANEL := Color(0.94, 0.89, 0.78, 0.97)
const COL_BORDER := Color(0.72, 0.58, 0.28, 1.0)
const COL_TXT := Color(0.22, 0.15, 0.05)
const COL_DISABLED_BG := Color(0.14, 0.16, 0.22, 0.85)
const COL_DISABLED_BORDER := Color(0.28, 0.31, 0.39, 1.0)
const COL_DISABLED_TXT := Color(0.45, 0.48, 0.55)

func _ready() -> void:
	var root := Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(root)

	var bg := ColorRect.new()
	bg.color = Color(0.06, 0.09, 0.14, 0.95)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(bg)

	var title := Label.new()
	title.text = "ZIMUT"
	title.add_theme_font_size_override("font_size", 84)
	title.add_theme_color_override("font_color", Color(1.0, 0.86, 0.4))
	title.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	title.offset_top = 130.0
	title.offset_bottom = 240.0
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	root.add_child(title)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_child(center)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 22)
	center.add_child(box)

	box.add_child(_mode_button("Entrer dans le monde de Zimut", "Parties, équipe et combats", true, func() -> void:
		GameManager.active_save = {}
		GameManager.active_slot = -1
		get_tree().change_scene_to_file("res://scenes/SaveSlots.tscn")))

	box.add_child(_mode_button("Réglages", "Difficulté des combats et rapidité de l'XP", true, func() -> void:
		get_tree().change_scene_to_file("res://scenes/Settings.tscn")))

func _mode_button(title_txt: String, desc: String, enabled: bool, cb: Callable) -> Button:
	var b := Button.new()
	b.text = ""
	b.custom_minimum_size = Vector2(560, 110)
	b.disabled = not enabled
	b.focus_mode = Control.FOCUS_ALL if enabled else Control.FOCUS_NONE

	var vb := VBoxContainer.new()
	vb.set_anchors_preset(Control.PRESET_FULL_RECT)
	vb.add_theme_constant_override("separation", 4)
	vb.alignment = BoxContainer.ALIGNMENT_CENTER
	b.add_child(vb)

	var t := Label.new()
	t.text = title_txt
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	t.add_theme_font_size_override("font_size", 28)
	t.add_theme_color_override("font_color", COL_TXT if enabled else COL_DISABLED_TXT)
	vb.add_child(t)

	var d := Label.new()
	d.text = desc
	d.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	d.add_theme_font_size_override("font_size", 18)
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
	normal.content_margin_left = 16
	normal.content_margin_right = 16
	normal.content_margin_top = 12
	normal.content_margin_bottom = 12

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
