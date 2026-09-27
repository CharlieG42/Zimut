extends Node2D
## MainMenu.gd - Menu principal du jeu unifie Zimut.
## Trois modes : ZOE (aventure), Zimut (combat tactique), EMPIRE (conquete).
## Les autoloads des modes non lances sont desactives pour eviter les
## conflits de scenes (chaque mode gere son propre etat).

const BUTTON_STYLE := preload("res://scripts/MainMenuButton.gd")

func _ready() -> void:
	_setup_background()
	_setup_title()
	_setup_buttons()

func _setup_background() -> void:
	var bg := ColorRect.new()
	bg.name = "Background"
	bg.color = Color(0.05, 0.07, 0.05)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

func _setup_title() -> void:
	var title := Label.new()
	title.name = "Title"
	title.text = "ZIMUT"
	title.add_theme_font_size_override("font_size", 96)
	title.add_theme_color_override("font_color", Color(0.9, 0.85, 0.4))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.set_anchors_preset(Control.PRESET_CENTER_TOP)
	title.position = Vector2(960 - 200, 80)
	title.size = Vector2(400, 120)
	add_child(title)
	var subtitle := Label.new()
	subtitle.name = "Subtitle"
	subtitle.text = "Choisissez votre mode de jeu"
	subtitle.add_theme_font_size_override("font_size", 28)
	subtitle.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.set_anchors_preset(Control.PRESET_CENTER_TOP)
	subtitle.position = Vector2(960 - 250, 210)
	subtitle.size = Vector2(500, 40)
	add_child(subtitle)

func _setup_buttons() -> void:
	var container := VBoxContainer.new()
	container.name = "Buttons"
	container.set_anchors_preset(Control.PRESET_CENTER)
	container.position = Vector2(960 - 200, 380)
	container.size = Vector2(400, 300)
	container.add_theme_constant_override("separation", 24)
	add_child(container)
	_add_mode_button(container, "ZOE - Aventure", Color(0.1, 0.4, 0.2), _on_zoe_pressed)
	_add_mode_button(container, "ZIMUT - Combat tactique", Color(0.4, 0.2, 0.5), _on_zimut_pressed)
	_add_mode_button(container, "EMPIRE - Conquete", Color(0.5, 0.3, 0.1), _on_empire_pressed)
	_add_mode_button(container, "Quitter", Color(0.25, 0.25, 0.25), _on_quit_pressed)

func _add_mode_button(container: VBoxContainer, label: String, color: Color, callback: Callable) -> void:
	var btn := BUTTON_STYLE.new()
	btn.text = label
	btn.custom_minimum_size = Vector2(400, 60)
	btn.add_theme_font_size_override("font_size", 26)
	btn.modulate = color
	btn.pressed.connect(callback)
	container.add_child(btn)

## Avant de lancer un mode, on desactive les autoloads des autres modes :
## leurs _ready() construisent des noeuds (grille, UI) qui resteraient
## affiches par-dessus la scene du mode choisi.
func _deactivate_other_modes(active: String) -> void:
	if active != "zimut":
		var zgm: Node = get_node_or_null("/root/ZimutGameManager")
		if zgm:
			zgm.set_process(false)
	if active != "empire":
		var em: Node = get_node_or_null("/root/EmpireManager")
		if em:
			em.set_process(false)
			em._deactivate_for_menu()
	if active != "zoe":
		pass

func _on_zoe_pressed() -> void:
	get_tree().change_scene_to_file("res://zoe/scenes/world.tscn")

func _on_zimut_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/TeamSelection.tscn")

func _on_empire_pressed() -> void:
	get_tree().change_scene_to_file("res://empire/scenes/Main.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
