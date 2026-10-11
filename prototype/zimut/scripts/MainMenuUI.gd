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

	var title := Label.new()
	title.text = "ZIMUT"
	title.add_theme_font_size_override("font_size", 84)
	title.add_theme_color_override("font_color", Color(1.0, 0.86, 0.4))
	title.position = Vector2(760, 140)
	title.size = Vector2(400, 100)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root.add_child(title)
	var sub := Label.new()
	sub.text = "Tactique tour par tour — affronte des ennemis de plus en plus forts"
	sub.add_theme_font_size_override("font_size", 22)
	sub.add_theme_color_override("font_color", COL_PANEL)
	sub.position = Vector2(560, 240)
	sub.size = Vector2(800, 40)
	sub.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	root.add_child(sub)

	var box := VBoxContainer.new()
	box.set_anchors_preset(Control.PRESET_CENTER)
	box.position = Vector2(790, 330)
	box.custom_minimum_size = Vector2(340, 0)
	box.add_theme_constant_override("separation", 20)
	root.add_child(box)

	box.add_child(_btn("⚔  NOUVELLE PARTIE", func() -> void:
		# Réinitialiser le contexte de partie puis ouvrir la gestion des slots
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

	var hint := Label.new()
	hint.text = "Une partie = une équipe, des loots et des ennemis qui gagnent 2 niveaux par victoire."
	hint.add_theme_font_size_override("font_size", 17)
	hint.add_theme_color_override("font_color", Color(0.7, 0.75, 0.85))
	hint.position = Vector2(560, 680)
	hint.size = Vector2(800, 40)
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
