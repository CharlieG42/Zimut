extends CanvasLayer

## MainMenuUI.gd — Écran d'accueil illustré de Zimut.
## Les plaques sont dessinées dans le SVG ; les zones interactives restent de vrais
## contrôles Godot afin de fonctionner avec la souris, le tactile et les builds Android.

const BG_TEXTURE: Texture2D = preload("res://assets/ui/main_menu_bg.svg")

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
	bg.texture = BG_TEXTURE
	root.add_child(bg)

	# Les zones sont relatives à la fenêtre : elles restent alignées sur les plaques
	# peintes même si la résolution ou le ratio de l'écran Android change.
	_add_menu_hitbox(root, "NouvellePartie", 0.682, 0.475, 0.946, 0.566, _start_new_game)
	_add_menu_hitbox(root, "Continuer", 0.682, 0.586, 0.946, 0.677, _continue_game)
	_add_menu_hitbox(root, "Options", 0.682, 0.697, 0.946, 0.788, func() -> void:
		get_tree().change_scene_to_file("res://scenes/Settings.tscn"))
	_add_menu_hitbox(root, "Quitter", 0.682, 0.808, 0.946, 0.900, func() -> void:
		get_tree().quit())


func _start_new_game() -> void:
	GameManager.active_save = {}
	GameManager.active_slot = -1
	GameManager.clear_custom_team()
	GameManager.menu_intent = "new"
	get_tree().change_scene_to_file("res://scenes/SaveSlots.tscn")


## Reprend la sauvegarde la plus récemment modifiée, puis rouvre la sélection d'équipe
## (qui restaure l'équipe enregistrée avant le prochain combat).
func _continue_game() -> void:
	var saves: Array = ProgressionManager.list_saves()
	if saves.is_empty():
		# Première visite : le bouton Continuer propose simplement de créer la partie.
		_start_new_game()
		return

	var latest: Dictionary = saves[0]
	for entry: Dictionary in saves:
		if String(entry.get("timestamp", "")) > String(latest.get("timestamp", "")):
			latest = entry

	var slot: int = int(latest.get("id", -1))
	var data: Dictionary = ProgressionManager.load_save(slot)
	if slot < 0 or data.is_empty():
		# Sauvegarde devenue illisible : revenir au gestionnaire sans écraser de données.
		GameManager.menu_intent = ""
		get_tree().change_scene_to_file("res://scenes/SaveSlots.tscn")
		return

	GameManager.active_slot = slot
	GameManager.active_save = data
	GameManager.clear_custom_team()
	GameManager.menu_intent = ""
	get_tree().change_scene_to_file("res://scenes/TeamSelection.tscn")


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
