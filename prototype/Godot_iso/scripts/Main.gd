extends Node2D
## Main.gd - Script principal (coordination des managers)
## Version isométrique - Architecture modulaire

@onready var grid_manager: GridManager = $Grid/GridManager
@onready var ui_manager: UIManager = $UI/UIManager
@onready var turn_manager: TurnManager = $TurnManager
@onready var entity_manager: EntityManager = $EntityManager
@onready var spell_manager: SpellManager = $SpellManager

var game_manager


func _ready():
    # Initialiser GameManager (autoload)
    game_manager = GameManager
    
    # Initialiser tous les managers avec GameManager
    grid_manager.init(game_manager)
    ui_manager.init(game_manager)
    turn_manager.init(game_manager)
    entity_manager.init(game_manager)
    spell_manager.init(game_manager)
    
    # Connecter les signaux entre managers
    _connect_signals()


func _connect_signals():
    # GridManager -> GameManager
    grid_manager.connect("cell_clicked", Callable(game_manager, "handle_cell_selected"))
    
    # GameManager -> UIManager
    game_manager.turn_changed.connect(ui_manager._on_turn_changed)
    game_manager.player_changed.connect(ui_manager._on_player_changed)
    game_manager.entity_selected.connect(ui_manager._on_entity_selected)
    game_manager.spell_selected.connect(ui_manager._on_spell_selected)
    game_manager.game_ended.connect(ui_manager._on_game_ended)
    game_manager.entity_moved.connect(ui_manager._on_entity_moved)
    game_manager.entity_attacked.connect(ui_manager._on_entity_attacked)
    game_manager.spell_casted.connect(ui_manager._on_spell_casted)
    game_manager.message_requested.connect(ui_manager._on_message_requested)
    
    # GameManager -> TurnManager
    game_manager.turn_changed.connect(turn_manager._on_turn_changed)
    
    # GameManager -> EntityManager
    game_manager.entity_moved.connect(entity_manager._on_entity_moved)
    game_manager.entity_attacked.connect(entity_manager._on_entity_attacked)
    game_manager.spell_casted.connect(entity_manager._on_spell_casted)
    
    # UIManager -> GameManager
    ui_manager.connect("end_turn_requested", Callable(game_manager, "next_player"))
    ui_manager.connect("restart_requested", Callable(game_manager, "reset_game"))
    ui_manager.connect("spell_selected", Callable(game_manager, "handle_spell_selected"))
    
    # SpellManager -> UIManager
    spell_manager.connect("spell_selected", Callable(ui_manager, "_on_spell_button_selected"))
