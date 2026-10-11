extends CanvasLayer
## MainMenuUI.gd — Écran de démarrage : nouvelle partie, charger une partie,
## ou combat rapide (sans progression).

const COL_PANEL := Color(0.94, 0.89, 0.78, 0.97)
const COL_BORDER := Color(0.72, 0.58, 0.28, 1.0)
const COL_TXT := Color(0.22, 0.15, 0.05)

func _ready() -> void:
	var root := Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(root)
	var bg := ColorRect.new()
	bg.color = Color(0.06, 0.09, 0.14, 0.95)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.add_child(bg)

	# Titre : pleine largeur, centré
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

	# Sous-titre : pleine largeur, centré
	var sub := Label.new()
	sub.text = "Tactique tour par tour — affronte des ennemis de plus en plus forts"
	sub.add_theme_font_size_override("font_size", 22)
	sub.add_theme_color_override("font_color", COL_PANEL)
	sub.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	sub.offset_top = 250.0
	sub.offset_bottom = 290.0
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root.add_child(sub)

	# Boutons : colonne centrée horizontalement et verticalement
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_child(center)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 22)
	center.add_child(box)

	box.add_child(_btn("⚔  NOUVELLE PARTIE", func() -> void:
		GameManager.active_save = {}
		GameManager.active_slot = -1
		get_tree().change_scene_to_file("res://scenes/SaveSlots.tscn")))
	box.add_child(_btn("📂  CHARGER UNE PARTIE", func() -> void:
		GameManager.active_save = {}
		GameManager.active_slot = -1
		get_tree().change_scene_to_file("res://scenes/SaveSlots.tscn")))
	box.add_child(_btn("🗡  COMBAT RAPIDE (sans progression)", func() -> void:
		GameManager.active_save = {}
		GameManager.active_slot = -1
		GameManager.clear_custom_team()
		get_tree().change_scene_to_file("res://scenes/TeamSelection.tscn")))

	# Hint : pleine largeur en bas, centré
	var hint := Label.new()
	hint.text = "Une partie = une équipe, des loots et des ennemis qui gagnent 2 niveaux par victoire."
	hint.add_theme_font_size_override("font_size", 17)
	hint.add_theme_color_override("font_color", Color(0.7, 0.75, 0.85))
	hint.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	hint.offset_top = -60.0
	hint.offset_bottom = -20.0
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root.add_child(hint)

func _btn(txt: String, cb: Callable) -> Button:
	var b := Button.new()
	b.text = txt
	b.custom_minimum_size = Vector2(340, 74)
	b.add_theme_font_size_override("font_size", 22)
	b.add_theme_color_override("font_color", COL_TXT)
	var s := StyleBoxFlat.new()
	s.bg_color = COL_PANEL
	s.border_color = COL_BORDER
	s.set_border_width_all(3)
	s.set_corner_radius_all(12)
	b.add_theme_stylebox_override("normal", s)
	b.add_theme_stylebox_override("hover", s)
	b.add_theme_stylebox_override("pressed", s)
	b.pressed.connect(cb)
	return b
