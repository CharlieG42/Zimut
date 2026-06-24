extends CanvasLayer
class_name UIManager
## UIManager.gd - Gestion de l'interface utilisateur

@onready var turn_label: Label = $TurnLabel
@onready var player_info_label: Label = $PlayerInfoLabel
@onready var message_label: Label = $MessageLabel
@onready var game_over_panel: ColorRect = $GameOverPanel
@onready var game_over_label: Label = $GameOverPanel/GameOverLabel
@onready var restart_button: Button = $GameOverPanel/RestartButton
@onready var spell_panel: Panel = $SpellPanel
@onready var spell_container: VBoxContainer = $SpellPanel/SpellContainer
@onready var spell_description: Label = $SpellPanel/SpellDescription
@onready var turn_order_panel: Panel = $TurnOrderPanel
@onready var turn_order_container: Control = $TurnOrderPanel/TurnOrderContainer

var game_manager
var end_turn_button: Button
var spell_buttons: Array = []
var turn_order_labels: Array = []
var turn_order_health_bars: Array = []

signal end_turn_requested
signal restart_requested
signal spell_selected(spell: Dictionary)


func init(manager):
	game_manager = manager
	_setup_ui_elements()
	_setup_connections()


func _setup_ui_elements():
	# End turn button
	end_turn_button = Button.new()
	end_turn_button.name = "EndTurnButton"
	end_turn_button.text = "Passer le tour"
	end_turn_button.position = Vector2(1660, 985)
	end_turn_button.size = Vector2(160, 50)
	end_turn_button.add_theme_font_size_override("font_size", 24)
	end_turn_button.z_index = 51
	add_child(end_turn_button)
	end_turn_button.pressed.connect(_on_end_turn_pressed)
	
	# Player info label
	if player_info_label:
		var settings = LabelSettings.new()
		settings.font_size = 44
		player_info_label.label_settings = settings
	
	# Restart button
	restart_button.pressed.connect(_on_restart_pressed)
	
	# Hide spell panel initially
	spell_panel.visible = false


func _setup_connections():
	pass


func _on_turn_changed(turn: int):
	update_ui()
	update_turn_order_display()
	if turn == 1:
		hide_spell_panel()
		if spell_description:
			spell_description.text = ""


func _on_player_changed(index: int):
	update_ui()
	update_entity_display()
	update_turn_order_display()
	if game_manager.current_turn == 0 and game_manager.players.size() > index:
		var current_player = game_manager.players[index]
		show_spells_for_player(current_player)
	else:
		hide_spell_panel()


func _on_entity_selected(_entity):
	update_ui()
	update_entity_display()


func _on_spell_selected(spell):
	for button in spell_buttons:
		if button.spell == spell:
			button.add_theme_color_override("font_color", Color.YELLOW)
		else:
			button.add_theme_color_override("font_color", Color.WHITE)
	if spell_description:
		spell_description.text = "%s: %s" % [spell.get("name", ""), spell.get("effect", "")]


func _on_game_ended(victory: bool):
	game_over_panel.visible = true
	hide_spell_panel()
	if spell_description:
		spell_description.text = ""
	if victory:
		game_over_label.text = "VICTOIRE !"
	else:
		game_over_label.text = "DEFAITE..."


func _on_entity_moved(_entity, _from_pos: Vector2i, _to_pos: Vector2i):
	update_entity_display()
	update_turn_order_display()


func _on_entity_attacked(_attacker, _target, _damage: int):
	update_entity_display()
	update_turn_order_display()


func _on_spell_casted(_caster, _spell, _target, _result: String):
	update_entity_display()
	update_turn_order_display()
	if spell_description:
		spell_description.text = ""
	for button in spell_buttons:
		button.add_theme_color_override("font_color", Color.WHITE)


func _on_message_requested(text: String):
	add_message(text)


func _on_end_turn_pressed():
	end_turn_requested.emit()


func _on_restart_pressed():
	restart_requested.emit()


func _on_spell_button_selected(spell: Dictionary):
	spell_selected.emit(spell)


func show_spells_for_player(player: Dictionary):
	for button in spell_buttons:
		button.queue_free()
	spell_buttons = []
	
	for child in spell_container.get_children():
		child.queue_free()
	
	for spell in player.get("spells", []):
		var button = preload("res://scripts/SpellButton.gd").new()
		button.spell = spell
		button.spell_selected.connect(_on_spell_button_selected)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		button.mouse_filter = Control.MOUSE_FILTER_PASS
		
		button.add_theme_color_override("font_color", Color.WHITE)
		button.add_theme_color_override("font_pressed_color", Color.YELLOW)
		button.add_theme_color_override("font_hover_color", Color(1, 1, 0.8))
		
		spell_container.add_child(button)
		spell_buttons.append(button)
	
	spell_panel.visible = true


func hide_spell_panel():
	spell_panel.visible = false
	if spell_description:
		spell_description.text = ""


func add_message(text: String):
	if message_label:
		message_label.text = text


func update_ui():
	if game_manager.current_turn == 0:
		turn_label.text = "Tour des joueurs"
		end_turn_button.visible = true
	else:
		turn_label.text = "Tour des ennemis"
		end_turn_button.visible = false
	
	var current_player = null
	if game_manager.current_turn == 0 and game_manager.players.size() > game_manager.current_player_index:
		current_player = game_manager.players[game_manager.current_player_index]
	
	if current_player:
		player_info_label.text = "Joueur: %s (PA: %d/%d, PM: %d/%d)" % [
			current_player["name"],
			current_player["current_pa"],
			current_player["max_pa"],
			current_player["current_pm"],
			current_player["max_pm"]
		]
	else:
		player_info_label.text = "Joueur: -"


func update_entity_display():
	if has_node("/root/Main/Grid/GridManager"):
		get_node("/root/Main/Grid/GridManager").update_entity_display()


func update_turn_order_display():
	for child in turn_order_container.get_children():
		child.queue_free()
	turn_order_labels = []
	turn_order_health_bars = []
	
	var y_pos = 0
	
	for i in range(game_manager.players.size()):
		var player = game_manager.players[i]
		if player["current_pv"] > 0:
			var label = Label.new()
			label.text = "%d. %s" % [i + 1, player.get("name", "Joueur")]
			var settings = LabelSettings.new()
			settings.font_size = 24
			label.label_settings = settings
			label.add_theme_color_override("font_color", Color.WHITE)
			label.position = Vector2(10, y_pos)
			label.size = Vector2(260, 25)
			turn_order_container.add_child(label)
			turn_order_labels.append(label)
			
			var health_bar_bg = ColorRect.new()
			health_bar_bg.color = Color(0, 0, 0)
			health_bar_bg.position = Vector2(10, y_pos + 28)
			health_bar_bg.size = Vector2(120, 20)
			turn_order_container.add_child(health_bar_bg)
			
			var health_bar_fill = ColorRect.new()
			health_bar_fill.name = "HealthBar_%d" % i
			health_bar_fill.color = Color(0, 1.0, 0)
			health_bar_fill.position = Vector2(10, y_pos + 28)
			var health_ratio = player.get("current_pv", 0) / max(1, player.get("max_pv", 1))
			health_bar_fill.size.x = 120.0 * health_ratio
			health_bar_fill.size.y = 20
			health_bar_fill.z_index = 1
			turn_order_container.add_child(health_bar_fill)
			turn_order_health_bars.append(health_bar_fill)
			
			y_pos += 55
	
	for i in range(game_manager.enemies.size()):
		var enemy = game_manager.enemies[i]
		if enemy["current_pv"] > 0:
			var label = Label.new()
			label.text = "%d. %s" % [i + 1 + game_manager.players.size(), enemy.get("name", "Ennemi")]
			var settings = LabelSettings.new()
			settings.font_size = 24
			label.label_settings = settings
			label.add_theme_color_override("font_color", Color(0.9, 0.4, 0.4))
			label.position = Vector2(10, y_pos)
			label.size = Vector2(260, 25)
			turn_order_container.add_child(label)
			turn_order_labels.append(label)
			
			var health_bar_bg = ColorRect.new()
			health_bar_bg.color = Color(0, 0, 0)
			health_bar_bg.position = Vector2(10, y_pos + 28)
			health_bar_bg.size = Vector2(120, 20)
			turn_order_container.add_child(health_bar_bg)
			
			var health_bar_fill = ColorRect.new()
			health_bar_fill.name = "HealthBar_%d" % (game_manager.players.size() + i)
			health_bar_fill.color = Color(1.0, 0, 0)
			health_bar_fill.position = Vector2(10, y_pos + 28)
			var health_ratio = enemy.get("current_pv", 0) / max(1, enemy.get("max_pv", 1))
			health_bar_fill.size.x = 120.0 * health_ratio
			health_bar_fill.size.y = 20
			health_bar_fill.z_index = 1
			turn_order_container.add_child(health_bar_fill)
			turn_order_health_bars.append(health_bar_fill)
			
			y_pos += 55
