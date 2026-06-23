extends Node2D
## Main.gd - Scene principale avec Node2D et grille isometrique

@onready var grid_node: Node2D = $Grid
@onready var turn_label: Label = $UI/TurnLabel
@onready var player_info_label: Label = $UI/PlayerInfoLabel
@onready var message_label: Label = $UI/MessageLabel
@onready var game_over_panel: ColorRect = $UI/GameOverPanel
@onready var game_over_label: Label = $UI/GameOverPanel/GameOverLabel
@onready var restart_button: Button = $UI/GameOverPanel/RestartButton

@onready var spell_panel: Panel = $UI/SpellPanel
@onready var spell_container: VBoxContainer = $UI/SpellPanel/SpellContainer
@onready var spell_description: Label = $UI/SpellPanel/SpellDescription
@onready var turn_order_panel: Panel = $UI/TurnOrderPanel
@onready var turn_order_container: Control = $UI/TurnOrderPanel/TurnOrderContainer

var game_manager

var cell_nodes: Array = []
var spell_buttons: Array = []
var turn_order_labels: Array = []
var turn_order_health_bars: Array = []
var end_turn_button: Button


func _ready():
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
    end_turn_button.position = Vector2(1660, 985)
    end_turn_button.size = Vector2(160, 50)
    end_turn_button.add_theme_font_size_override("font_size", 24)
    end_turn_button.z_index = 51
    add_child(end_turn_button)
    end_turn_button.pressed.connect(_on_end_turn_pressed)
    if player_info_label:
        var settings = LabelSettings.new()
        settings.font_size = 44
        player_info_label.label_settings = settings


func init_grid_display():
    cell_nodes = []
    for y in range(game_manager.GRID_SIZE):
        var row: Array = []
        for x in range(game_manager.GRID_SIZE):
            var cell = preload("res://scripts/Cell.gd").new()
            var screen_pos = grid_to_screen(Vector2i(x, y))
            cell.position = screen_pos
            cell.grid_position = Vector2i(x, y)
            cell.connect("cell_clicked", Callable(self, "_on_cell_clicked"))
            grid_node.add_child(cell)
            row.append(cell)
        cell_nodes.append(row)
    update_entity_display()


func grid_to_screen(grid_pos: Vector2i) -> Vector2:
    var x = grid_pos.x
    var y = grid_pos.y
    var screen_x = (x - y) * game_manager.CELL_SIZE.x / 2
    var screen_y = (x + y) * game_manager.CELL_SIZE.y / 2
    screen_x += 960 - (game_manager.GRID_SIZE * game_manager.CELL_SIZE.x / 4)
    screen_y += 540 - (game_manager.GRID_SIZE * game_manager.CELL_SIZE.y / 4)
    return Vector2(screen_x, screen_y)