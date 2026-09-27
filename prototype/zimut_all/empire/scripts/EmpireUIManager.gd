extends Node
## EmpireUIManager.gd - Interface strategique du mode Empire.
## Refonte ergonomique: bandeau superieur (ressources), panneau ville a gauche,
## barre d'actions en bas avec gros boutons tactiles, et tutoriel guide.
## Suit le style de construction d'UI codee de world.gd (mode ZOE).

const FONT_TITLE := 30
const FONT_BODY := 24
const FONT_BUTTON := 28
const FONT_BIG := 36

var empire_manager: Node
var world_map_manager: Node
var ui_layer: CanvasLayer
var stats_label: Label
var city_info_label: RichTextLabel
var message_label: Label
var selected_city: Dictionary = {}

var hero_class_option: OptionButton
var unit_option: OptionButton
var army_label: RichTextLabel
var tutorial_panel: PanelContainer
var tutorial_label: RichTextLabel
var tutorial_step: int = 0
var action_bar: HBoxContainer
var attack_button: Button
var build_button: Button
var team_setup_panel: PanelContainer
var team_setup_label: RichTextLabel
var team_hero_buttons: Array = []
var selected_hero_ids: Array = []
var build_panel: PanelContainer
var build_label: RichTextLabel
var city_view: Node = null
var city_panel_container: PanelContainer
var army_panel_container: PanelContainer
var city_panel_toggle: Button
var army_panel_toggle: Button

func init(manager: Node) -> void:
	empire_manager = manager
	world_map_manager = empire_manager.world_map_manager
	_setup_ui()
	empire_manager.resources_changed.connect(_on_resources_changed)
	empire_manager.message_requested.connect(_on_message)
	empire_manager.battle_resolved.connect(_on_battle_resolved)
	world_map_manager.city_clicked.connect(_on_city_clicked)
	empire_manager.city_changed.connect(_on_city_changed)
	_refresh()

# ─────────────────────────────────────────────────────────────────────────────
#  Construction de l'UI
# ─────────────────────────────────────────────────────────────────────────────

func _setup_ui() -> void:
	ui_layer = CanvasLayer.new()
	ui_layer.name = "UILayer"
	ui_layer.layer = 10
	empire_manager.add_child(ui_layer)

	var root: Control = Control.new()
	root.name = "UI"
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	ui_layer.add_child(root)

	_setup_top_bar(root)
	_setup_city_panel(root)
	_setup_army_panel(root)
	_setup_action_bar(root)
	_setup_message_label(root)
	_setup_team_setup_panel(root)
	_setup_build_panel(root)
	_setup_tutorial(root)

func _setup_top_bar(root: Control) -> void:
	var bar: PanelContainer = PanelContainer.new()
	bar.name = "TopBar"
	bar.anchor_left = 0.0
	bar.anchor_right = 1.0
	bar.anchor_top = 0.0
	bar.anchor_bottom = 0.0
	bar.offset_bottom = 70
	bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.08, 0.12, 0.9)
	style.set_border_width_all(2)
	style.border_color = Color(0.4, 0.35, 0.15)
	bar.add_theme_stylebox_override("panel", style)
	root.add_child(bar)
	stats_label = Label.new()
	stats_label.name = "StatsLabel"
	stats_label.add_theme_font_size_override("font_size", FONT_TITLE)
	stats_label.add_theme_color_override("font_color", Color(1.0, 0.95, 0.75))
	bar.add_child(stats_label)

func _setup_city_panel(root: Control) -> void:
	var panel: PanelContainer = PanelContainer.new()
	panel.name = "CityPanel"
	city_panel_container = panel
	panel.anchor_left = 0.0
	panel.anchor_top = 0.0
	panel.anchor_bottom = 1.0
	panel.anchor_right = 0.0
	panel.offset_left = 20
	panel.offset_top = 90
	panel.offset_right = 560
	panel.offset_bottom = -260
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.05, 0.1, 0.85)
	style.set_border_width_all(2)
	style.border_color = Color(0.3, 0.3, 0.45)
	style.set_content_margin_all(16)
	panel.add_theme_stylebox_override("panel", style)
	root.add_child(panel)
	var vbox: VBoxContainer = VBoxContainer.new()
	vbox.name = "CityVBox"
	panel.add_child(vbox)
	var title: Label = Label.new()
	title.text = "Ville selectionnee"
	title.add_theme_font_size_override("font_size", FONT_TITLE)
	title.add_theme_color_override("font_color", Color(0.8, 0.85, 1.0))
	vbox.add_child(title)
	city_info_label = RichTextLabel.new()
	city_info_label.name = "CityInfoLabel"
	city_info_label.bbcode_enabled = true
	city_info_label.fit_content = false
	city_info_label.custom_minimum_size = Vector2(480, 200)
	city_info_label.add_theme_font_size_override("normal_font_size", FONT_BODY)
	vbox.add_child(city_info_label)
	var recruit_title: Label = Label.new()
	recruit_title.text = "Recrutement"
	recruit_title.add_theme_font_size_override("font_size", FONT_BODY)
	recruit_title.add_theme_color_override("font_color", Color(0.8, 0.85, 1.0))
	vbox.add_child(recruit_title)
	hero_class_option = OptionButton.new()
	hero_class_option.name = "HeroClassOption"
	hero_class_option.add_theme_font_size_override("font_size", FONT_BUTTON)
	hero_class_option.custom_minimum_size = Vector2(480, 60)
	vbox.add_child(hero_class_option)
	_add_big_button(vbox, "Recruter ce hero", _on_recruit_hero_pressed, Color(0.2, 0.45, 0.2))
	unit_option = OptionButton.new()
	unit_option.name = "UnitOption"
	unit_option.add_theme_font_size_override("font_size", FONT_BUTTON)
	unit_option.custom_minimum_size = Vector2(480, 60)
	vbox.add_child(unit_option)
	_add_big_button(vbox, "Recruter cette unite", _on_recruit_unit_pressed, Color(0.2, 0.35, 0.45))
	city_panel_toggle = _make_panel_toggle(root, "◂", true, Callable(self, "_on_city_panel_toggled"))

func _setup_army_panel(root: Control) -> void:
	var panel: PanelContainer = PanelContainer.new()
	panel.name = "ArmyPanel"
	army_panel_container = panel
	panel.anchor_left = 1.0
	panel.anchor_right = 1.0
	panel.anchor_top = 0.0
	panel.anchor_bottom = 1.0
	panel.offset_left = -580
	panel.offset_right = -20
	panel.offset_top = 90
	panel.offset_bottom = -260
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.05, 0.1, 0.85)
	style.set_border_width_all(2)
	style.border_color = Color(0.3, 0.3, 0.45)
	style.set_content_margin_all(16)
	panel.add_theme_stylebox_override("panel", style)
	root.add_child(panel)
	var vbox: VBoxContainer = VBoxContainer.new()
	vbox.name = "ArmyVBox"
	panel.add_child(vbox)
	var title: Label = Label.new()
	title.text = "Votre armee"
	title.add_theme_font_size_override("font_size", FONT_TITLE)
	title.add_theme_color_override("font_color", Color(0.9, 0.85, 0.7))
	vbox.add_child(title)
	army_label = RichTextLabel.new()
	army_label.name = "ArmyLabel"
	army_label.bbcode_enabled = true
	army_label.fit_content = false
	army_label.custom_minimum_size = Vector2(520, 300)
	army_label.add_theme_font_size_override("normal_font_size", FONT_BODY)
	vbox.add_child(army_label)
	_add_big_button(vbox, "Sauvegarder", _on_save_pressed, Color(0.25, 0.25, 0.3))
	_add_big_button(vbox, "Charger", _on_load_pressed, Color(0.25, 0.25, 0.3))
	army_panel_toggle = _make_panel_toggle(root, "▸", false, Callable(self, "_on_army_panel_toggled"))

## Petit bouton en bord d'ecran pour replier/deplier un panneau lateral.
func _make_panel_toggle(root: Control, arrow: String, on_left: bool, callback: Callable) -> Button:
	var btn: Button = Button.new()
	btn.name = "PanelToggle%d" % (0 if on_left else 1)
	btn.text = arrow
	btn.add_theme_font_size_override("font_size", FONT_BODY)
	btn.add_theme_color_override("font_color", Color(0.95, 0.9, 0.7))
	btn.add_theme_color_override("font_pressed_color", Color(1.0, 1.0, 0.85))
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.16, 0.9)
	style.set_border_width_all(2)
	style.border_color = Color(0.4, 0.35, 0.15)
	btn.add_theme_stylebox_override("normal", style)
	btn.add_theme_stylebox_override("pressed", style)
	btn.add_theme_stylebox_override("hover", style)
	if on_left:
		btn.anchor_left = 0.0
		btn.anchor_right = 0.0
		btn.anchor_top = 0.5
		btn.anchor_bottom = 0.5
		btn.offset_left = 0
		btn.offset_right = 64
		btn.offset_top = -32
		btn.offset_bottom = 32
	else:
		btn.anchor_left = 1.0
		btn.anchor_right = 1.0
		btn.anchor_top = 0.5
		btn.anchor_bottom = 0.5
		btn.offset_left = -64
		btn.offset_right = 0
		btn.offset_top = -32
		btn.offset_bottom = 32
	btn.pressed.connect(callback)
	root.add_child(btn)
	return btn

func _on_city_panel_toggled() -> void:
	if city_panel_container == null or city_panel_toggle == null:
		return
	city_panel_container.visible = not city_panel_container.visible
	city_panel_toggle.text = "▸" if city_panel_container.visible else "◂"

func _on_army_panel_toggled() -> void:
	if army_panel_container == null or army_panel_toggle == null:
		return
	army_panel_container.visible = not army_panel_container.visible
	army_panel_toggle.text = "◂" if army_panel_container.visible else "▸"

func _setup_action_bar(root: Control) -> void:
	var bar: PanelContainer = PanelContainer.new()
	bar.name = "ActionBar"
	bar.anchor_left = 0.0
	bar.anchor_right = 1.0
	bar.anchor_top = 1.0
	bar.anchor_bottom = 1.0
	bar.offset_top = -220
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(0.08, 0.08, 0.12, 0.92)
	style.set_border_width_all(2)
	style.border_color = Color(0.4, 0.35, 0.15)
	style.set_content_margin_all(16)
	bar.add_theme_stylebox_override("panel", style)
	root.add_child(bar)
	action_bar = HBoxContainer.new()
	action_bar.name = "ActionButtons"
	action_bar.add_theme_constant_override("separation", 24)
	action_bar.alignment = BoxContainer.ALIGNMENT_CENTER
	bar.add_child(action_bar)
	_add_action_button("⚔ ATTAQUER", "Conquerir la ville selectionnee", _on_attack_pressed, Color(0.55, 0.15, 0.15))
	_add_action_button(" Construire", "Ameliorer votre ville", _on_build_pressed, Color(0.15, 0.4, 0.15))

func _setup_message_label(root: Control) -> void:
	message_label = Label.new()
	message_label.name = "MessageLabel"
	message_label.anchor_left = 0.0
	message_label.anchor_right = 1.0
	message_label.anchor_top = 1.0
	message_label.anchor_bottom = 1.0
	message_label.offset_top = -300
	message_label.offset_bottom = -230
	message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message_label.add_theme_font_size_override("font_size", FONT_BODY)
	message_label.add_theme_color_override("font_color", Color.YELLOW)
	root.add_child(message_label)

func _add_big_button(parent: Container, label: String, callback: Callable, color: Color) -> Button:
	var btn: Button = _make_button(label, callback, color)
	btn.custom_minimum_size = Vector2(480, 64)
	parent.add_child(btn)
	return btn

func _add_action_button(label: String, hint: String, callback: Callable, color: Color) -> Button:
	var btn: Button = _make_button(label, callback, color)
	btn.custom_minimum_size = Vector2(420, 140)
	btn.tooltip_text = hint
	action_bar.add_child(btn)
	return btn

func _make_button(label: String, callback: Callable, color: Color) -> Button:
	var btn: Button = Button.new()
	btn.text = label
	btn.add_theme_font_size_override("font_size", FONT_BUTTON)
	btn.modulate = color
	btn.pressed.connect(callback)
	return btn

# ─────────────────────────────────────────────────────────────────────────────
func _setup_team_setup_panel(root: Control) -> void:
	team_setup_panel = PanelContainer.new()
	team_setup_panel.name = "TeamSetupPanel"
	team_setup_panel.anchor_left = 0.25
	team_setup_panel.anchor_right = 0.75
	team_setup_panel.anchor_top = 0.12
	team_setup_panel.anchor_bottom = 0.88
	team_setup_panel.visible = false
	team_setup_panel.z_index = 60
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(0.09, 0.09, 0.16, 0.96)
	style.set_border_width_all(3)
	style.border_color = Color(0.85, 0.55, 0.15)
	style.set_content_margin_all(20)
	style.set_corner_radius_all(12)
	team_setup_panel.add_theme_stylebox_override("panel", style)
	root.add_child(team_setup_panel)

	var vbox: VBoxContainer = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 14)
	team_setup_panel.add_child(vbox)

	var title: Label = Label.new()
	title.text = "CONSTITUTION DE L'ÉQUIPE"
	title.add_theme_font_size_override("font_size", FONT_BIG)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	team_setup_label = RichTextLabel.new()
	team_setup_label.bbcode_enabled = true
	team_setup_label.fit_content = true
	team_setup_label.add_theme_font_size_override("normal_font_size", FONT_BODY)
	vbox.add_child(team_setup_label)

	var hero_list: VBoxContainer = VBoxContainer.new()
	hero_list.name = "HeroList"
	hero_list.add_theme_constant_override("separation", 10)
	vbox.add_child(hero_list)

	var buttons_row: HBoxContainer = HBoxContainer.new()
	buttons_row.add_theme_constant_override("separation", 24)
	buttons_row.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_child(buttons_row)

	var confirm_btn: Button = _make_button("⚔ LANCER L'ATTAQUE", _on_team_confirm_pressed, Color(0.75, 0.25, 0.15))
	confirm_btn.custom_minimum_size = Vector2(420, 90)
	buttons_row.add_child(confirm_btn)

	var cancel_btn: Button = _make_button("✕ Annuler", _on_team_cancel_pressed, Color(0.35, 0.35, 0.4))
	cancel_btn.custom_minimum_size = Vector2(300, 90)
	buttons_row.add_child(cancel_btn)

func _refresh_team_setup_list() -> void:
	if team_setup_panel == null:
		return
	var hero_list: VBoxContainer = null
	for child in team_setup_panel.get_child(0).get_children():
		if child.name == "HeroList":
			hero_list = child
			break
	if hero_list == null:
		return
	for child in hero_list.get_children():
		child.queue_free()
	team_hero_buttons = []
	selected_hero_ids = []
	var heroes: Array = empire_manager.heroes
	if heroes.is_empty():
		team_setup_label.text = "[color=gray]Aucun héros recruté.[/color] Recrutez des héros dans le panneau Armée (droite) avant d'attaquer."
		return
	team_setup_label.text = "[b]Cible : %s[/b]\nSélectionnez jusqu'à 3 héros pour mener l'assaut :\n" % selected_city.get("name", "?")
	var count: int = 0
	for i: int in range(heroes.size()):
		var hero: Dictionary = heroes[i]
		var btn: Button = _make_button("%s  Lv%d   (PV %d)" % [hero["classe"], hero["level"], hero["max_pv"]],
			_on_hero_toggled.bind(i), Color(0.25, 0.45, 0.25))
		btn.toggle_mode = true
		btn.custom_minimum_size = Vector2(0, 70)
		btn.add_theme_font_size_override("font_size", FONT_BODY)
		hero_list.add_child(btn)
		team_hero_buttons.append(btn)
		count += 1

func _on_hero_toggled(hero_index: int) -> void:
	if hero_index in selected_hero_ids:
		selected_hero_ids.erase(hero_index)
	else:
		if selected_hero_ids.size() >= 3:
			empire_manager.message_requested.emit("3 héros maximum : désélectionnez-en un d'abord.")
			if hero_index < team_hero_buttons.size():
				team_hero_buttons[hero_index].set_pressed_no_signal(false)
			return
		selected_hero_ids.append(hero_index)

func _on_team_confirm_pressed() -> void:
	if selected_hero_ids.is_empty():
		empire_manager.message_requested.emit("Sélectionnez au moins 1 héros.")
		return
	var heroes: Array = empire_manager.heroes
	var team: Array = []
	for id: int in selected_hero_ids:
		if id < heroes.size():
			team.append(heroes[id])
	team_setup_panel.visible = false
	var army: Dictionary = {"team": _heroes_to_team_format(team), "units": empire_manager.army_manager.army_units}
	empire_manager.attack_city(selected_city, army)

func _heroes_to_team_format(heroes: Array) -> Array:
	var team: Array = []
	for hero: Dictionary in heroes:
		team.append({
			"classe": hero["classe"],
			"max_pv": hero["max_pv"],
			"force": hero["force"],
			"intelligence": hero["intelligence"],
			"agilite": hero["agilite"],
			"sagesse": hero["sagesse"],
			"defense": hero["defense"],
			"pa": hero["pa"],
			"pm": hero["pm"],
		})
	return team

func _on_team_cancel_pressed() -> void:
	team_setup_panel.visible = false

func _setup_build_panel(root: Control) -> void:
	build_panel = PanelContainer.new()
	build_panel.name = "BuildPanel"
	build_panel.anchor_left = 0.25
	build_panel.anchor_right = 0.75
	build_panel.anchor_top = 0.12
	build_panel.anchor_bottom = 0.88
	build_panel.visible = false
	build_panel.z_index = 60
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(0.09, 0.12, 0.09, 0.96)
	style.set_border_width_all(3)
	style.border_color = Color(0.3, 0.7, 0.3)
	style.set_content_margin_all(20)
	style.set_corner_radius_all(12)
	build_panel.add_theme_stylebox_override("panel", style)
	root.add_child(build_panel)

	var vbox: VBoxContainer = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 14)
	build_panel.add_child(vbox)

	var title: Label = Label.new()
	title.text = "CONSTRUCTION"
	title.add_theme_font_size_override("font_size", FONT_BIG)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)

	build_label = RichTextLabel.new()
	build_label.bbcode_enabled = true
	build_label.fit_content = true
	build_label.add_theme_font_size_override("normal_font_size", FONT_BODY)
	vbox.add_child(build_label)

	var buttons_row: HBoxContainer = HBoxContainer.new()
	buttons_row.add_theme_constant_override("separation", 24)
	buttons_row.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_child(buttons_row)

	var mine_btn: Button = _make_button("⛏ Mine de fer", _on_build_mine_pressed, Color(0.2, 0.45, 0.2))
	mine_btn.custom_minimum_size = Vector2(380, 90)
	buttons_row.add_child(mine_btn)

	var close_btn: Button = _make_button("✕ Fermer", _on_build_close_pressed, Color(0.35, 0.35, 0.4))
	close_btn.custom_minimum_size = Vector2(300, 90)
	buttons_row.add_child(close_btn)

func _on_build_mine_pressed() -> void:
	if selected_city.is_empty():
		return
	empire_manager.economy_manager.try_build(selected_city, "Mine de fer")
	_refresh_build_panel()

func _refresh_build_panel() -> void:
	if build_label == null or selected_city.is_empty():
		return
	var buildings: Array = selected_city.get("buildings", [])
	var txt: String = "[b]%s[/b] - vos terres\n\n" % selected_city["name"]
	if buildings.is_empty():
		txt += "[color=gray]Aucune construction.\nBâtissez pour produire plus de ressources ![/color]"
	else:
		txt += "[b]Bâtiments (%d) :[/b]\n" % buildings.size()
		for b: Dictionary in buildings:
			txt += "• %s (Niv. %d)" % [b.get("name", "?"), b.get("level", 1)]
	build_label.text = txt

func _on_build_close_pressed() -> void:
	build_panel.visible = false


#  Tutoriel guide
# ─────────────────────────────────────────────────────────────────────────────

func _setup_tutorial(root: Control) -> void:
	tutorial_panel = PanelContainer.new()
	tutorial_panel.name = "TutorialPanel"
	tutorial_panel.anchor_left = 0.0
	tutorial_panel.anchor_right = 1.0
	tutorial_panel.anchor_top = 0.0
	tutorial_panel.anchor_bottom = 0.0
	tutorial_panel.offset_left = 360
	tutorial_panel.offset_right = -360
	tutorial_panel.offset_top = 100
	tutorial_panel.offset_bottom = 380
	tutorial_panel.z_index = 200
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.12, 0.08, 0.96)
	style.set_border_width_all(3)
	style.border_color = Color(0.9, 0.8, 0.3)
	style.set_content_margin_all(20)
	tutorial_panel.add_theme_stylebox_override("panel", style)
	root.add_child(tutorial_panel)
	var vbox: VBoxContainer = VBoxContainer.new()
	tutorial_panel.add_child(vbox)
	var title: Label = Label.new()
	title.name = "TutorialTitle"
	title.text = "GUIDE DE L'EMPIRE"
	title.add_theme_font_size_override("font_size", FONT_BIG)
	title.add_theme_color_override("font_color", Color(1.0, 0.9, 0.4))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)
	tutorial_label = RichTextLabel.new()
	tutorial_label.name = "TutorialLabel"
	tutorial_label.bbcode_enabled = true
	tutorial_label.fit_content = true
	tutorial_label.add_theme_font_size_override("normal_font_size", FONT_BODY)
	vbox.add_child(tutorial_label)
	_add_big_button(vbox, "Suivant ▶", _on_tutorial_next, Color(0.35, 0.3, 0.5))
	_add_big_button(vbox, "Passer le tutoriel", _on_tutorial_skip, Color(0.3, 0.3, 0.3))
	tutorial_step = 0
	_show_tutorial_step()

const TUTORIAL_STEPS: Array[String] = [
	"[b]But du jeu[/b] : conquérir toutes les villes de la carte pour bâtir votre Empire.
Vos villes sont en [color=blue]bleu[/color], les neutres en [color=gray]gris[/color], les ennemis en [color=red]rouge[/color].",
	"[b]1. Recrutez[/b] : à gauche, choisissez une classe de héros ou une unité, puis cliquez sur [b]Recruter[/b].
Les recrutements coûtent de l'or, du fer et du bois (affichés en haut).",
	"[b]2. Sélectionnez une cible[/b] : touchez une case de la carte.
Les infos de la ville s'affichent à gauche (niveau, garnison).",
	"[b]3. Attaquez[/b] : appuyez sur le gros bouton [b]⚔ ATTAQUER[/b].
Le combat tactique Zimut se lance : déplacez vos héros et utilisez vos sorts pour vaincre la garnison.",
	"[b]Conseils[/b] : la capitale produit des ressources à chaque tick.
 Construisez des bâtiments dans vos villes pour augmenter la production.
Bon jeu, Empereur !",
]

func _show_tutorial_step() -> void:
	if tutorial_step >= TUTORIAL_STEPS.size():
		_hide_tutorial()
		return
	tutorial_label.text = TUTORIAL_STEPS[tutorial_step]
	tutorial_label.text += "\n\n[center][color=gray]Etape %d / %d[/color][/center]" % [tutorial_step + 1, TUTORIAL_STEPS.size()]
	tutorial_panel.visible = true

func _on_tutorial_next() -> void:
	tutorial_step += 1
	_show_tutorial_step()

func _on_tutorial_skip() -> void:
	_hide_tutorial()

func _hide_tutorial() -> void:
	tutorial_panel.visible = false

func _on_tutorial_button_pressed() -> void:
	tutorial_step = 0
	_show_tutorial_step()

# ─────────────────────────────────────────────────────────────────────────────
#  Rafraichissement
# ─────────────────────────────────────────────────────────────────────────────

func _refresh() -> void:
	_fill_recruit_options()
	_on_resources_changed(empire_manager.resources)
	_on_city_changed(selected_city)
	_on_army_changed()

## Remplit les listes de recrutement depuis les CSV (classes / unites).
func _fill_recruit_options() -> void:
	var loader: Node = get_node_or_null("/root/EmpireDataLoader")
	if loader == null:
		return
	hero_class_option.clear()
	for classe: String in ["Tank", "Assassin", "Chasseur", "Mage", "Druide", "Heal", "Invocateur"]:
		hero_class_option.add_item(classe)
	unit_option.clear()
	var unit_names: Array = loader.get_unique_unit_names()
	for unit_name: String in unit_names:
		unit_option.add_item(unit_name)

func _on_resources_changed(res: Dictionary) -> void:
	stats_label.text = "Or: %d   Fer: %d   Bois: %d   Magie: %d   Venin: %d   |   Villes: %d / %d" % [
		int(res.get("or", 0)), int(res.get("fer", 0)), int(res.get("bois", 0)),
		int(res.get("magie", 0)), int(res.get("venin", 0)),
		empire_manager.get_player_cities().size(), empire_manager.cities.size(),
	]

func _on_city_clicked(city: Dictionary) -> void:
	selected_city = city
	_on_city_changed(city)
	_hide_tutorial()
	# Fermer les panneaux ouverts
	if team_setup_panel:
		team_setup_panel.visible = false
	if build_panel:
		build_panel.visible = false
	# Nouveau flow : ville a vous -> vue ville (construction) ; neutre/ennemie -> constitution d'equipe
	if city["owner"] == empire_manager.OWNER_PLAYER:
		_enter_city_view(city)
	else:
		_refresh_team_setup_list()
		team_setup_panel.visible = true
		empire_manager.message_requested.emit("%s : constituez votre équipe d'assaut !" % city["name"])

func _on_city_changed(city: Dictionary) -> void:
	if city.is_empty():
		city_info_label.text = "[color=gray]Touchez une ville sur la carte pour voir ses informations.[/color]"
		return
	var owner_color: String = "white"
	match city["owner"]:
		empire_manager.OWNER_PLAYER: owner_color = "blue"
		empire_manager.OWNER_NEUTRAL: owner_color = "gray"
		empire_manager.OWNER_AI: owner_color = "red"
	city_info_label.text = "[b]%s[/b] (%s)
Niveau %d
Propriétaire : [color=%s]%s[/color]
Garnison : %d unités" % [
		city["name"], city["type"], city["level"], owner_color, city["owner"], city["garrison"].size(),
	]
	if world_map_manager != null and world_map_manager.has_method("refresh_display"):
		world_map_manager.refresh_display()

func _on_army_changed() -> void:
	var heroes: Array = empire_manager.heroes
	var units: Array = empire_manager.army_manager.army_units
	var txt: String = ""
	if heroes.is_empty() and units.is_empty():
		txt = "[color=gray]Aucun héros ni unité.
Recrutez pour former votre armée ![/color]"
	else:
		txt += "[b]Héros (%d)[/b]
" % heroes.size()
		for hero: Dictionary in heroes:
			txt += "• %s Lv%d
" % [hero["classe"], hero["level"]]
		txt += "
[b]Unités (%d)[/b]
" % units.size()
		for unit: Dictionary in units:
			txt += "• %s
" % unit["name"]
	army_label.text = txt

func _on_message(text: String) -> void:
	message_label.text = text

## Masque/affiche l'UI strategique (utilise pendant le combat tactique).
func set_ui_visible(visible_flag: bool) -> void:
	if ui_layer:
		ui_layer.visible = visible_flag

func _refresh_ui_visibility() -> void:
	set_ui_visible(true)

func _on_battle_resolved(battle_victory: bool, _target_city: Dictionary) -> void:
	if world_map_manager != null and world_map_manager.has_method("refresh_display"):
		world_map_manager.refresh_display()
	_refresh()

# ─────────────────────────────────────────────────────────────────────────────
#  Actions
# ─────────────────────────────────────────────────────────────────────────────

func _on_attack_pressed() -> void:
	if selected_city.is_empty():
		empire_manager.message_requested.emit("Touchez d'abord une ville ennemie ou neutre sur la carte.")
		return
	if selected_city["owner"] == empire_manager.OWNER_PLAYER:
		empire_manager.message_requested.emit("Cette ville est deja a vous. Selectionnez une cible adverse.")
		return
	_refresh_team_setup_list()
	team_setup_panel.visible = true

func _on_build_pressed() -> void:
	if selected_city.is_empty():
		empire_manager.message_requested.emit("Selectionnez une de vos villes pour construire.")
		return
	if selected_city["owner"] != empire_manager.OWNER_PLAYER:
		empire_manager.message_requested.emit("Vous ne possedez pas cette ville.")
		return
	_enter_city_view(selected_city)

## Entre dans la vue 8x8 de la ville alliee (grille de construction).
func _enter_city_view(city: Dictionary) -> void:
	if city_view != null:
		return
	set_ui_visible(false)
	if empire_manager.world_map_manager:
		empire_manager.world_map_manager.visible = false
	city_view = preload("res://empire/scripts/CityViewManager.gd").new()
	city_view.name = "CityView"
	city_view.exit_requested.connect(_on_city_view_exit)
	get_tree().get_current_scene().add_child(city_view)
	city_view.setup(empire_manager, city)
	empire_manager.message_requested.emit("Ville de %s : choisissez un bâtiment puis touchez une case." % city["name"])

func _on_city_view_exit() -> void:
	if city_view == null:
		return
	city_view.queue_free()
	city_view = null
	set_ui_visible(true)
	if empire_manager.world_map_manager:
		empire_manager.world_map_manager.visible = true
		empire_manager.world_map_manager.fit_map()
		empire_manager.world_map_manager.refresh_display()
	_refresh()

func _on_recruit_hero_pressed() -> void:
	var idx: int = hero_class_option.selected
	if idx < 0:
		empire_manager.message_requested.emit("Choisissez une classe d'hero dans la liste.")
		return
	var classe: String = hero_class_option.get_item_text(idx)
	empire_manager.army_manager.recruit_hero(classe, 10)
	_on_army_changed()

func _on_recruit_unit_pressed() -> void:
	var idx: int = unit_option.selected
	if idx < 0:
		empire_manager.message_requested.emit("Choisissez une unite a recruter dans la liste.")
		return
	var unit_name: String = unit_option.get_item_text(idx)
	empire_manager.army_manager.recruit_unit(unit_name)
	_on_army_changed()

func _on_save_pressed() -> void:
	if empire_manager.save_game():
		empire_manager.message_requested.emit("Empire sauvegarde.")
	else:
		empire_manager.message_requested.emit("Echec de la sauvegarde.")

func _on_load_pressed() -> void:
	if empire_manager.load_game():
		empire_manager.message_requested.emit("Empire charge.")
		_refresh()
	else:
		empire_manager.message_requested.emit("Aucune sauvegarde.")
