extends CanvasLayer
class_name UIManager
## UIManager.gd - Interface utilisateur Zimut
## Corrections : spell null crash, update PA/PM en temps réel,
##               portée du sort affichée, highlight grille sur sélection sort

@onready var turn_label: Label          = $TurnLabel
@onready var player_info_label: Label   = $PlayerInfoLabel
@onready var message_label: Label       = $MessageLabel
@onready var game_over_panel: ColorRect = $GameOverPanel
@onready var game_over_label: Label     = $GameOverPanel/GameOverLabel
@onready var restart_button: Button     = $GameOverPanel/RestartButton
@onready var spell_panel: Panel         = $SpellPanel
@onready var spell_container: VBoxContainer = $SpellPanel/SpellContainer
@onready var spell_description: Label   = $SpellPanel/SpellDescription
@onready var turn_order_panel: Panel    = $TurnOrderPanel
@onready var turn_order_container: Control = $TurnOrderPanel/TurnOrderContainer
@onready var data_source_label: Label = $DataSourceLabel

var game_manager
var end_turn_button: Button
var spell_buttons: Array         = []
var turn_order_labels: Array     = []
var turn_order_health_bars: Array = []

signal end_turn_requested
signal restart_requested
signal spell_selected(spell: Dictionary)


func init(manager) -> void:
	game_manager = manager
	_setup_ui_elements()
	_setup_connections()


func _setup_ui_elements() -> void:
	end_turn_button = Button.new()
	end_turn_button.name = "EndTurnButton"
	end_turn_button.text = "Passer le tour"
	end_turn_button.position = Vector2(1660, 985)
	end_turn_button.size = Vector2(220, 55)
	end_turn_button.add_theme_font_size_override("font_size", 26)
	end_turn_button.z_index = 100
	end_turn_button.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(end_turn_button)
	end_turn_button.pressed.connect(_on_end_turn_pressed)

	# Créer le label pour la source des données si il n'existe pas
	if data_source_label == null:
		data_source_label = Label.new()
		data_source_label.name = "DataSourceLabel"
		data_source_label.position = Vector2(20, 20)
		data_source_label.size = Vector2(1900, 40)
		var db_settings := LabelSettings.new()
		db_settings.font_size = 24
		db_settings.font_color = Color(1, 0.5, 0)  # Orange pour visibilité
		data_source_label.label_settings = db_settings
		data_source_label.horizontal_alignment = Control.HORIZONTAL_ALIGNMENT_LEFT
		data_source_label.visible = true
		add_child(data_source_label)

	if player_info_label:
		var settings := LabelSettings.new()
		settings.font_size = 36
		player_info_label.label_settings = settings

	restart_button.pressed.connect(_on_restart_pressed)
	spell_panel.visible = false


func _setup_connections() -> void:
	if game_manager:
		game_manager.turn_changed.connect(_on_turn_changed)
		game_manager.player_changed.connect(_on_player_changed)
		game_manager.entity_selected.connect(_on_entity_selected)
		game_manager.spell_selected.connect(_on_spell_selected)
		game_manager.game_ended.connect(_on_game_ended)
		game_manager.message_requested.connect(_on_message_requested)
		game_manager.entity_moved.connect(_on_action_done)
		game_manager.entity_attacked.connect(_on_entity_attacked_handler)
		game_manager.spell_casted.connect(_on_spell_casted)
	
	# Connexion au DatabaseManager pour afficher la source des données
	var db_manager: Node = get_node_or_null("/root/DatabaseManager")
	if db_manager and db_manager.has_signal("data_source_info"):
		db_manager.data_source_info.connect(_on_data_source_info)


# ─── Handlers signaux GameManager ──────────────────────────────────────────

func _on_turn_changed(turn: int) -> void:
	update_ui()
	update_turn_order_display()
	if turn == 1:
		hide_spell_panel()
		_clear_spell_range_display()


func _on_player_changed(index: int) -> void:
	update_ui()
	update_entity_display()
	update_turn_order_display()
	_clear_spell_range_display()
	if game_manager.current_turn == 0 and game_manager.players.size() > index:
		show_spells_for_player(game_manager.players[index])
		_show_move_range(game_manager.players[index])
	else:
		hide_spell_panel()


func _on_entity_selected(_entity) -> void:
	update_ui()
	update_entity_display()


func _on_spell_selected(spell) -> void:
	## CORRECTION : spell peut être null (désélection) → guard obligatoire
	if spell == null:
		for button: Button in spell_buttons:
			button.add_theme_color_override("font_color", Color.WHITE)
		if spell_description:
			spell_description.text = ""
		_clear_spell_range_display()
		# Remettre les cases de déplacement
		if game_manager.current_turn == 0 and game_manager.players.size() > game_manager.current_player_index:
			var cp: Dictionary = game_manager.players[game_manager.current_player_index]
			_show_move_range(cp)
		return

	# Surligner le bouton actif
	for button in spell_buttons:
		if button.spell == spell:
			button.add_theme_color_override("font_color", Color.YELLOW)
		else:
			button.add_theme_color_override("font_color", Color.WHITE)

	# Description avec portée
	if spell_description:
		var portee: int = int(spell.get("range", 0))
		var portee_str: String = "portée %d" % portee if portee > 0 else "auto"
		spell_description.text = "%s (%s)\n%s" % [
			spell.get("name", ""),
			portee_str,
			spell.get("effect", ""),
		]

	# Masquer le move range et afficher la portée du sort
	_clear_move_range_display()
	_show_spell_range(spell)


func _on_game_ended(victory: bool) -> void:
	game_over_panel.visible = true
	hide_spell_panel()
	_clear_spell_range_display()
	game_over_label.text = "VICTOIRE !" if victory else "DÉFAITE..."


func hide_game_over_panel() -> void:
	game_over_panel.visible = false


func _on_data_source_info(source: String) -> void:
	if data_source_label:
		data_source_label.text = source
		# Afficher temporairement dans le message label aussi
		message_label.text = source


func _on_action_done(_entity, _from: Vector2i, _to: Vector2i) -> void:
	update_ui()
	update_entity_display()
	update_turn_order_display()
	# Recalculer les cases accessibles après déplacement (PM réduits)
	if game_manager.current_turn == 0 and game_manager.players.size() > game_manager.current_player_index:
		var cp: Dictionary = game_manager.players[game_manager.current_player_index]
		_show_move_range(cp)


func _on_entity_attacked_handler(_attacker, _target, _damage: int) -> void:
	update_ui()
	update_entity_display()
	update_turn_order_display()


func _on_spell_casted(_caster, _spell, _target, _result: String) -> void:
	update_ui()
	update_entity_display()
	update_turn_order_display()
	_clear_spell_range_display()   # efface portée sort
	if spell_description:
		spell_description.text = ""
	for button: Button in spell_buttons:
		button.add_theme_color_override("font_color", Color.WHITE)
	# Réafficher les cases de déplacement après le sort
	if game_manager.current_turn == 0 and game_manager.players.size() > game_manager.current_player_index:
		var cp: Dictionary = game_manager.players[game_manager.current_player_index]
		_show_move_range(cp)


func _on_message_requested(text: String) -> void:
	if message_label:
		message_label.text = text


func _on_end_turn_pressed() -> void:
	_clear_spell_range_display()
	_clear_move_range_display()
	end_turn_requested.emit()


func _on_restart_pressed() -> void:
	restart_requested.emit()


func _on_spell_button_selected(spell: Dictionary) -> void:
	spell_selected.emit(spell)


# ─── Portée du sort ────────────────────────────────────────────────────────

func _clear_move_range_display() -> void:
	var grid_manager: Node = get_node_or_null("/root/Main/GridManager")
	if grid_manager:
		grid_manager.clear_move_range_only()



func _show_move_range(player: Dictionary) -> void:
	## Surligne en BLEU les cases accessibles selon les PM restants
	var grid_manager: Node = get_node_or_null("/root/Main/GridManager")
	if grid_manager == null:
		return
	var pm: int = int(player.get("current_pm", 0))
	if pm <= 0:
		_clear_spell_range_display()
		return
	var cx: int = int(player["x"])
	var cy: int = int(player["y"])
	var in_range: Array = []
	for dy: int in range(-pm, pm + 1):
		for dx: int in range(-pm, pm + 1):
			if abs(dx) + abs(dy) <= pm and (dx != 0 or dy != 0):
				var tx: int = cx + dx
				var ty: int = cy + dy
				if tx >= 0 and tx < game_manager.GRID_SIZE and ty >= 0 and ty < game_manager.GRID_SIZE:
					if game_manager.grid[ty][tx] == null:
						in_range.append(Vector2i(tx, ty))
	grid_manager.highlight_move_range(in_range)

func _show_spell_range(spell: Dictionary) -> void:
	var grid_manager: Node = get_node_or_null("/root/Main/GridManager")
	if grid_manager == null:
		return
	var spell_range: int = int(spell.get("range", 0))
	if spell_range <= 0:
		return
	var caster: Dictionary = game_manager.players[game_manager.current_player_index]
	var cx: int = int(caster["x"])
	var cy: int = int(caster["y"])
	var in_range: Array = []
	for dy: int in range(-spell_range, spell_range + 1):
		for dx: int in range(-spell_range, spell_range + 1):
			if abs(dx) + abs(dy) <= spell_range and (dx != 0 or dy != 0):
				var tx: int = cx + dx
				var ty: int = cy + dy
				if tx >= 0 and tx < game_manager.GRID_SIZE and ty >= 0 and ty < game_manager.GRID_SIZE:
					in_range.append(Vector2i(tx, ty))
	grid_manager.highlight_spell_range(in_range)


func _clear_spell_range_display() -> void:
	var grid_manager: Node = get_node_or_null("/root/Main/GridManager")
	if grid_manager:
		grid_manager.clear_all_highlights()


# ─── Panneau de sorts ──────────────────────────────────────────────────────

func show_spells_for_player(player: Dictionary) -> void:
	for button: Button in spell_buttons:
		button.queue_free()
	spell_buttons = []
	for child: Node in spell_container.get_children():
		child.queue_free()

	for spell: Dictionary in player.get("spells", []):
		var button: SpellButton = preload("res://scripts/SpellButton.gd").new()
		button.spell_selected.connect(_on_spell_button_selected)
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.size_flags_vertical   = Control.SIZE_SHRINK_CENTER
		button.mouse_filter          = Control.MOUSE_FILTER_STOP
		spell_container.add_child(button)
		button.setup_spell(spell)   # Configurer APRÈS add_child (node dans le tree)
		spell_buttons.append(button)

	spell_panel.visible = true


func hide_spell_panel() -> void:
	spell_panel.visible = false
	if spell_description:
		spell_description.text = ""


# ─── Mise à jour UI ────────────────────────────────────────────────────────

func update_ui() -> void:
	if game_manager.current_turn == 0:
		turn_label.text = "Tour des joueurs"
		end_turn_button.visible = true
	else:
		turn_label.text = "Tour des ennemis"
		end_turn_button.visible = false

	if game_manager.current_turn == 0 and game_manager.players.size() > game_manager.current_player_index:
		var cp: Dictionary = game_manager.players[game_manager.current_player_index]
		player_info_label.text = "%s  |  PA : %d / %d   PM : %d / %d" % [
			cp["name"],
			int(cp["current_pa"]), int(cp["max_pa"]),
			int(cp["current_pm"]), int(cp["max_pm"]),
		]
	else:
		player_info_label.text = "—"


func update_entity_display() -> void:
	var gm: Node = get_node_or_null("/root/Main/GridManager")
	if gm:
		gm.update_entity_display()


func update_turn_order_display() -> void:
	for child: Node in turn_order_container.get_children():
		child.queue_free()
	turn_order_labels      = []
	turn_order_health_bars = []

	var y_pos: int = 0

	for i: int in range(game_manager.players.size()):
		var player: Dictionary = game_manager.players[i]
		if int(player["current_pv"]) > 0:
			var is_active: bool = (i == game_manager.current_player_index and game_manager.current_turn == 0)
			var lbl: Label = Label.new()
			lbl.text = "%s%d. %s" % ["▶ " if is_active else "    ", i + 1, player.get("name", "Joueur")]
			var ls := LabelSettings.new()
			ls.font_size = 22
			lbl.label_settings = ls
			lbl.add_theme_color_override("font_color", Color.YELLOW if is_active else Color.WHITE)
			lbl.position = Vector2(10, y_pos)
			lbl.size = Vector2(260, 25)
			turn_order_container.add_child(lbl)
			turn_order_labels.append(lbl)

			_add_health_bar(turn_order_container, y_pos + 28, player, Color(0.2, 0.9, 0.2))
			y_pos += 55

	for i: int in range(game_manager.enemies.size()):
		var enemy: Dictionary = game_manager.enemies[i]
		if int(enemy["current_pv"]) > 0:
			var lbl: Label = Label.new()
			lbl.text = "    %d. %s" % [i + 1 + game_manager.players.size(), enemy.get("name", "Ennemi")]
			var ls := LabelSettings.new()
			ls.font_size = 22
			lbl.label_settings = ls
			lbl.add_theme_color_override("font_color", Color(0.9, 0.4, 0.4))
			lbl.position = Vector2(10, y_pos)
			lbl.size = Vector2(260, 25)
			turn_order_container.add_child(lbl)
			turn_order_labels.append(lbl)

			_add_health_bar(turn_order_container, y_pos + 28, enemy, Color(0.9, 0.2, 0.2))
			y_pos += 55


func _add_health_bar(container: Control, y: int, entity: Dictionary, fill_color: Color) -> void:
	var bg := ColorRect.new()
	bg.color    = Color(0.1, 0.1, 0.1)
	bg.position = Vector2(10, y)
	bg.size     = Vector2(240, 14)
	container.add_child(bg)

	var fill := ColorRect.new()
	fill.color    = fill_color
	fill.position = Vector2(10, y)
	var ratio: float = float(int(entity.get("current_pv", 0))) / float(maxi(1, int(entity.get("max_pv", 1))))
	fill.size     = Vector2(240.0 * clampf(ratio, 0.0, 1.0), 14)
	fill.z_index  = 1
	container.add_child(fill)
	turn_order_health_bars.append(fill)
