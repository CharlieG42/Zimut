extends CanvasLayer

## MainMenuUI.gd — Écran d'accueil illustré de Zimut.
## L'illustration porte les libellés visuels ; des zones interactives transparentes
## conservent de vrais boutons Godot et restent compatibles avec les builds Android.

const BG_PATH := "res://assets/ui/main_menu_bg.svg"

func _ready() -> void:
	layer = 10
	var root := Control.new()
	root.name = "MainMenuRoot"
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)

	var bg := TextureRect.new()
	bg.name = "MainMenuArtwork"
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var texture: Texture2D = load(BG_PATH) as Texture2D
	if texture != null:
		bg.texture = texture
	else:
		push_error("Illustration du menu introuvable : " + BG_PATH)
		var fallback := ColorRect.new()
		fallback.color = Color("#1c3540")
		fallback.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		root.add_child(fallback)
	root.add_child(bg)

	# Les hitboxes recouvrent les quatre plaques peintes dans l'illustration.
	_add_menu_hitbox(root, "NouvellePartie", 0.682, 0.475, 0.946, 0.566, func() -> void:
		GameManager.active_save = {}
		GameManager.active_slot = -1
		get_tree().change_scene_to_file("res://scenes/SaveSlots.tscn"))
	_add_menu_hitbox(root, "Continuer", 0.682, 0.586, 0.946, 0.677, func() -> void:
		get_tree().change_scene_to_file("res://scenes/SaveSlots.tscn"))
	_add_menu_hitbox(root, "Options", 0.682, 0.697, 0.946, 0.788, func() -> void:
		get_tree().change_scene_to_file("res://scenes/Settings.tscn"))
	_add_menu_hitbox(root, "Quitter", 0.682, 0.808, 0.946, 0.900, func() -> void:
		get_tree().quit())


func _add_menu_hitbox(parent: Control, node_name: String, left: float, top: float, right: float, bottom: float, action: Callable) -> void:
	var button := Button.new()
	button.name = node_name
	button.text = ""
	button.tooltip_text = node_name
	button.anchor_left = left
	button.anchor_top = top
	button.anchor_right = right
	button.anchor_bottom = bottom
	button.offset_left = 0.0
	button.offset_top = 0.0
	button.offset_right = 0.0
	button.offset_bottom = 0.0
	button.focus_mode = Control.FOCUS_ALL
	button.mouse_filter = Control.MOUSE_FILTER_STOP

	var normal := StyleBoxFlat.new()
	normal.bg_color = Color(0.15, 0.35, 0.2, 0.0)
	normal.set_corner_radius_all(24)
	var hover := normal.duplicate() as StyleBoxFlat
	hover.bg_color = Color(0.7, 0.9, 0.45, 0.14)
	hover.border_color = Color(1.0, 0.86, 0.4, 0.55)
	hover.set_border_width_all(2)
	var pressed := normal.duplicate() as StyleBoxFlat
	pressed.bg_color = Color(0.05, 0.12, 0.08, 0.28)
	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("hover", hover)
	button.add_theme_stylebox_override("pressed", pressed)
	button.add_theme_stylebox_override("focus", hover)
	button.pressed.connect(action)
	parent.add_child(button)
