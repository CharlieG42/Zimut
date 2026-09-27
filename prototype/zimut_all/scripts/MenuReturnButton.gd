extends Button
class_name MenuReturnButton
## MenuReturnButton.gd - Bouton "Menu" standard, reutilise par tous les modes.
## Style large et lisible pour l'ecran tactile Android.

signal menu_requested

const BUTTON_SIZE := Vector2(220, 70)

func _init() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	menu_requested.emit()
const MARGIN := Vector2(24, 24)

static func create() -> Button:
	var btn := MenuReturnButton.new()
	btn.text = "⌂ Menu"
	btn.custom_minimum_size = BUTTON_SIZE
	btn.add_theme_font_size_override("font_size", 28)
	btn.add_theme_color_override("font_color", Color.WHITE)
	btn.add_theme_color_override("font_hover_color", Color.YELLOW)
	btn.modulate = Color(1, 1, 1, 0.9)
	btn.anchor_left = 1.0
	btn.anchor_right = 1.0
	btn.anchor_top = 0.0
	btn.anchor_bottom = 0.0
	btn.offset_left = -BUTTON_SIZE.x - MARGIN.x
	btn.offset_right = -MARGIN.x
	btn.offset_top = MARGIN.y
	btn.offset_bottom = MARGIN.y + BUTTON_SIZE.y
	return btn
