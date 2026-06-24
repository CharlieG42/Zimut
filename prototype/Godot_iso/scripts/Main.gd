extends Node2D
## Main.gd - Script principal (coordination des managers)
## Version isométrique - Architecture modulaire

@onready var grid_manager = $GridManager
@onready var ui_manager = $UIManager
@onready var turn_manager = $TurnManager
@onready var entity_manager = $EntityManager
@onready var spell_manager = $SpellManager

var game_manager


func _ready():
	game_manager = GameManager
	grid_manager.init(game_manager)
	ui_manager.init(game_manager)
	turn_manager.init(game_manager)
	entity_manager.init(game_manager)
	spell_manager.init(game_manager)
	_connect_signals()


func _connect_signals():
	grid_manager.connect("cell_clicked", Callable(game_manager, "handle_cell_selected"))
	game_manager.turn_changed.connect(ui_manager._on_turn_changed)
	game_manager.player_changed.connect(ui_manager._on_player_changed)
	game_manager.entity_selected.connect(ui_manager._on_entity_selected)
	game_manager.spell_selected.connect(ui_manager._on_spell_selected)
	game_manager.game_ended.connect(ui_manager._on_game_ended)
	game_manager.message_requested.connect(ui_manager._on_message_requested)
	ui_manager.connect("end_turn_requested", Callable(game_manager, "next_player"))
	ui_manager.connect("restart_requested", Callable(game_manager, "reset_game"))
	ui_manager.connect("spell_selected", Callable(game_manager, "handle_spell_selected"))
	spell_manager.connect("spell_selected", Callable(ui_manager, "_on_spell_button_selected"))