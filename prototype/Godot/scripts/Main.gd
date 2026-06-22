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
    end_turn_button.position = Vector2(960, 1060)
    end_turn_button.size = Vector2(250, 50)
    end_turn_button.add_theme_font_size_override("font_size", 24)
    add_child(end_turn_button)
    end_turn_button.pressed.connect(_on_end_turn_pressed)


func init_grid_display():
    cell_nodes = []
    for y in range(game_manager.GRID_SIZE):
        var row: Array = []
        for x in range(game_manager.GRID_SIZE):
            var cell = preload("res://scripts/Cell.gd").new()
            cell.position = Vector2(x * 64 - 480, y * 64 - 480)
            cell.grid_position = Vector2i(x, y)
            cell.connect("cell_clicked", Callable(self, "_on_cell_clicked").bind(x, y))
            grid.add_child(cell)
            row.append(cell)
        cell_nodes.append(row)
    update_entity_display()
