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

func _setup_army_panel(root: Control) -> void:
	var panel: PanelContainer = PanelContainer.new()
	panel.name = "ArmyPanel"
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
	var army: Dictionary = empire_manager.army_manager.build_attacking_team()
	empire_manager.attack_city(selected_city, army)

func _on_build_pressed() -> void:
	if selected_city.is_empty():
		empire_manager.message_requested.emit("Selectionnez une de vos villes pour construire.")
		return
	if selected_city["owner"] != empire_manager.OWNER_PLAYER:
		empire_manager.message_requested.emit("Vous ne possedez pas cette ville.")
		return
	empire_manager.economy_manager.try_build(selected_city, "Mine de fer")

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
