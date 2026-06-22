extends Node2D
## Main.gd - Scene principale avec Node2D

@onready var grid: Node2D = $Grid
@onready var turn_label: Label = $TurnLabel
@onready var player_info_label: Label = $PlayerInfoLabel
@onready var message_label: Label = $MessageLabel
@onready var game_over_panel: ColorRect = $GameOverPanel
@onready var game_over_label: Label = $GameOverPanel/GameOverLabel
@onready var restart_button: Button = $GameOverPanel/RestartButton

@onready var spell_panel: Panel = $SpellPanel
@onready var spell_container: VBoxContainer = $SpellPanel/SpellContainer
@onready var turn_order_panel: Panel = $TurnOrderPanel
@onready var turn_order_container: VBoxContainer = $TurnOrderPanel/TurnOrderContainer

# CORRIGÉ : Pas de type hint car GameManager est un autoload
var game_manager

var cell_nodes: Array = []
var spell_buttons: Array = []
var turn_order_labels: Array = []
var end_turn_button: Button


func _ready():
    # CORRIGÉ : GameManager est un autoload, accessible directement
    game_manager = GameManager
    
    init_grid_display()
    init_turn_order_display()
    init_ui_elements()
    
    game_manager.turn_changed.connect(_on_turn_changed)
    game_manager.player_changed.connect(_on_player_changed)
    game_manager.entity_selected.connect(_on_entity_selected)
    game_manager.spell_selected.connect(_on_spell_selected)
    game_manager.game_ended.connect(_on_game_ended)
    game_manager.entity_moved.connect(_on_entity_moved)
    game_manager.entity_attacked.connect(_on_entity_attacked)
    game_manager.spell_casted.connect(_on_spell_casted)
    game_manager.message_requested.connect(_on_message_requested)
    
    restart_button.pressed.connect(_on_restart_pressed)
    
    spell_panel.visible = false
    update_ui()
    
    if game_manager.players.size() > 0:
        show_spells_for_player(game_manager.players[0])


func init_ui_elements():
    end_turn_button = Button.new()
    end_turn_button.name = "EndTurnButton"
    end_turn_button.text = "Passer le tour"
    end_turn_button.position = Vector2(400, 580)
    end_turn_button.size = Vector2(200, 40)
    add_child(end_turn_button)
    end_turn_button.pressed.connect(_on_end_turn_pressed)


func init_grid_display():
    cell_nodes = []
    for y in range(game_manager.GRID_SIZE):
        var row: Array = []
        for x in range(game_manager.GRID_SIZE):
            var cell = preload("res://scripts/Cell.gd").new()
            cell.position = Vector2(x * 64 - 320, y * 64 - 320)
            cell.grid_position = Vector2i(x, y)
            cell.connect("cell_clicked", Callable(self, "_on_cell_clicked").bind(x, y))
            grid.add_child(cell)
            row.append(cell)
        cell_nodes.append(row)
    update_entity_display()


func init_turn_order_display():
    turn_order_labels = []
    for child in turn_order_container.get_children():
        child.queue_free()
    
    for i in range(game_manager.players.size()):
        var player = game_manager.players[i]
        var label = Label.new()
        label.text = "%d. %s" % [i + 1, player.get("name", "Joueur")]
        var settings = LabelSettings.new()
        settings.font_size = 16
        label.label_settings = settings
        label.add_theme_color_override("font_color", Color.WHITE)
        turn_order_container.add_child(label)
        turn_order_labels.append(label)


func _on_cell_clicked(x: int, y: int):
    if game_manager.game_over:
        return
    game_manager.handle_cell_selected(Vector2i(x, y))


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
        spell_container.add_child(button)
        spell_buttons.append(button)
    spell_panel.visible = true


func hide_spell_panel():
    spell_panel.visible = false


func _on_spell_button_selected(spell: Dictionary):
    game_manager.handle_spell_selected(spell)
    hide_spell_panel()


func _on_message_requested(text: String):
    add_message(text)


func _on_turn_changed(turn: int):
    update_ui()
    update_turn_order_display()
    if turn == 1:
        hide_spell_panel()


func _on_player_changed(index: int):
    update_ui()
    update_entity_display()
    if game_manager.current_turn == 0 and game_manager.players.size() > index:
        var current_player = game_manager.players[index]
        show_spells_for_player(current_player)
    else:
        hide_spell_panel()


func _on_entity_selected(_entity):
    update_ui()


func _on_spell_selected(_spell):
    pass


func _on_game_ended(victory: bool):
    game_over_panel.visible = true
    hide_spell_panel()
    if victory:
        game_over_label.text = "VICTOIRE !"
    else:
        game_over_label.text = "DEFAITE..."


func _on_entity_moved(_entity, _from_pos: Vector2i, _to_pos: Vector2i):
    update_entity_display()


func _on_entity_attacked(_attacker, _target, _damage: int):
    update_entity_display()


func _on_spell_casted(_caster, _spell, _target, result: String):
    update_entity_display()
    hide_spell_panel()


func _on_end_turn_pressed():
    game_manager.next_player()


func _on_restart_pressed():
    game_manager.reset_game()
    game_over_panel.visible = false
    update_entity_display()
    update_ui()
    init_turn_order_display()
    if game_manager.players.size() > 0:
        show_spells_for_player(game_manager.players[0])


func update_ui():
    if game_manager.current_turn == 0:
        turn_label.text = "Tour des joueurs"
        end_turn_button.visible = true
    else:
        turn_label.text = "Tour des ennemis"
        end_turn_button.visible = false
    
    if game_manager.current_turn == 0 and game_manager.players.size() > 0:
        var current_player = game_manager.players[game_manager.current_player_index]
        player_info_label.text = "Joueur: %s | PV: %d/%d | PA: %d/%d | PM: %d/%d" % [
            current_player.get("name", "?"),
            current_player.get("current_pv", 0), current_player.get("max_pv", 0),
            current_player.get("current_pa", 0), current_player.get("max_pa", 0),
            current_player.get("current_pm", 0), current_player.get("max_pm", 0)
        ]
    else:
        player_info_label.text = ""


func update_turn_order_display():
    for i in range(turn_order_labels.size()):
        if i < game_manager.players.size():
            var player = game_manager.players[i]
            var label = turn_order_labels[i]
            var is_current = (i == game_manager.current_player_index && game_manager.current_turn == 0)
            if is_current:
                label.add_theme_color_override("font_color", Color.YELLOW)
                label.text = "%d. %s (ACTIF)" % [i + 1, player.get("name", "Joueur")]
            else:
                label.add_theme_color_override("font_color", Color.WHITE)
                label.text = "%d. %s" % [i + 1, player.get("name", "Joueur")]


func update_entity_display():
    for y in range(game_manager.GRID_SIZE):
        for x in range(game_manager.GRID_SIZE):
            var cell = cell_nodes[y][x]
            cell.entity = null
            cell.selected = false
            cell.highlighted = false
            cell.update_appearance()
    
    for y in range(game_manager.GRID_SIZE):
        for x in range(game_manager.GRID_SIZE):
            var entity = game_manager.grid[y][x]
            if entity != null:
                var cell = cell_nodes[y][x]
                cell.entity = entity
                cell.selected = (game_manager.selected_entity == entity)
                cell.highlighted = (entity == game_manager.players[game_manager.current_player_index] and 
                                   game_manager.current_turn == 0 and 
                                   entity.get("entity_type", "") == "Player")
                cell.update_appearance()


func add_message(message: String):
    message_label.text = message
    var timer = Timer.new()
    timer.wait_time = 2.0
    timer.one_shot = true
    timer.timeout.connect(func(): message_label.text = "")
    add_child(timer)
    timer.start()