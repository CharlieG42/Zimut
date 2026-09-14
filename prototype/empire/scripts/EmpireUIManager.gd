extends Node
## EmpireUIManager.gd - Interface strategique du mode Empire.
## Affiche les ressources, les villes possedees, le panneau d'action sur ville selectionnee,
## et les messages. Suit le style de construction d'UI codee de world.gd (mode ZOE).

var empire_manager: Node
var world_map_manager: Node

var ui_layer: CanvasLayer
var stats_label: Label
var city_info_label: Label
var message_label: Label
var buttons_container: HBoxContainer

var selected_city: Dictionary = {}

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

func _setup_ui() -> void:
	ui_layer = CanvasLayer.new()
	ui_layer.name = "UILayer"
	empire_manager.add_child(ui_layer)

	var root: Control = Control.new()
	root.name = "UI"
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui_layer.add_child(root)

	var vbox: VBoxContainer = VBoxContainer.new()
	vbox.name = "StatsContainer"
	vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.position = Vector2(10, 10)
	root.add_child(vbox)

	stats_label = Label.new()
	stats_label.name = "StatsLabel"
	vbox.add_child(stats_label)

	city_info_label = Label.new()
	city_info_label.name = "CityInfoLabel"
	vbox.add_child(city_info_label)

	buttons_container = HBoxContainer.new()
	buttons_container.name = "ButtonsContainer"
	vbox.add_child(buttons_container)

	_add_button("Attaquer", _on_attack_pressed)
	_add_button("Reconnaitre", _on_scout_pressed)
	_add_button("Recruter hero", _on_recruit_hero_pressed)
	_add_button("Recruter unite", _on_recruit_unit_pressed)
	_add_button("Construire", _on_build_pressed)
	_add_button("Sauvegarder", _on_save_pressed)
	_add_button("Charger", _on_load_pressed)

	message_label = Label.new()
	message_label.name = "MessageLabel"
	message_label.position = Vector2(10, 140)
	message_label.add_theme_color_override("font_color", Color.YELLOW)
	root.add_child(message_label)

func _add_button(label: String, callback: Callable) -> void:
	var btn: Button = Button.new()
	btn.text = label
	btn.pressed.connect(callback)
	buttons_container.add_child(btn)

func _refresh() -> void:
	_on_resources_changed(empire_manager.resources)
	_on_city_changed(selected_city)

func _on_resources_changed(res: Dictionary) -> void:
	stats_label.text = "Or:%d Fer:%d Bois:%d Magie:%d Venin:%d | Villes:%d/%d" % [
		int(res.get("or", 0)),
		int(res.get("fer", 0)),
		int(res.get("bois", 0)),
		int(res.get("magie", 0)),
		int(res.get("venin", 0)),
		empire_manager.get_player_cities().size(),
		empire_manager.cities.size(),
	]

func _on_city_clicked(city: Dictionary) -> void:
	selected_city = city
	_on_city_changed(city)

func _on_city_changed(city: Dictionary) -> void:
	if city.is_empty():
		city_info_label.text = "Aucune ville selectionnee."
		return
	city_info_label.text = "Ville: %s (%s) Lv%d - %s - Garnison:%d" % [
		city["name"], city["type"], city["level"], city["owner"], city["garrison"].size()
	]
	if world_map_manager != null and world_map_manager.has_method("refresh_display"):
		world_map_manager.refresh_display()

func _on_message(text: String) -> void:
	message_label.text = text

func _on_battle_resolved(battle_victory: bool, _target_city: Dictionary) -> void:
	if world_map_manager != null and world_map_manager.has_method("refresh_display"):
		world_map_manager.refresh_display()
	_refresh()

func _on_attack_pressed() -> void:
	if selected_city.is_empty():
		empire_manager.message_requested.emit("Selectionnez une ville cible sur la carte.")
		return
	if selected_city["owner"] == empire_manager.OWNER_PLAYER:
		empire_manager.message_requested.emit("Vous possedez deja cette ville.")
		return
	var army: Dictionary = empire_manager.army_manager.build_attacking_team()
	empire_manager.attack_city(selected_city, army)

func _on_scout_pressed() -> void:
	if selected_city.is_empty():
		empire_manager.message_requested.emit("Selectionnez une ville cible.")
		return
	var info: Dictionary = empire_manager.scout_city(selected_city)
	empire_manager.message_requested.emit(
		"Reconnaissance %s: proprietaire=%s niveau=%d garnison=%d" % [
			info.get("name", "?"), info.get("owner", "?"),
			info.get("level", 0), info.get("garrison_size", 0)
		]
	)

func _on_recruit_hero_pressed() -> void:
	empire_manager.army_manager.recruit_hero("Tank", 10)

func _on_recruit_unit_pressed() -> void:
	empire_manager.army_manager.recruit_unit("Soldat")

func _on_build_pressed() -> void:
	if selected_city.is_empty():
		empire_manager.message_requested.emit("Selectionnez une de vos villes.")
		return
	if selected_city["owner"] != empire_manager.OWNER_PLAYER:
		empire_manager.message_requested.emit("Vous ne possedez pas cette ville.")
		return
	empire_manager.economy_manager.try_build(selected_city, "Mine de fer")

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
