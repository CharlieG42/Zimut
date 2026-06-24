extends Node2D
## Main.gd - Script principal (coordination des managers)
## Version avec disconnect/connect pour éviter les doublons

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
	# Désconnecter d'abord, puis reconnecter pour éviter les doublons
	# is_connected() ne prend que 2 args en Godot 4, donc on utilise disconnect() systématiquement
	
	# GridManager -> GameManager
	grid_manager.disconnect("cell_clicked", game_manager)
	grid_manager.cell_clicked.connect(game_manager.handle_cell_selected)
	
	# GameManager -> UIManager
	game_manager.turn_changed.disconnect(ui_manager)
	game_manager.turn_changed.connect(ui_manager._on_turn_changed)
	
	game_manager.player_changed.disconnect(ui_manager)
	game_manager.player_changed.connect(ui_manager._on_player_changed)
	
	game_manager.entity_selected.disconnect(ui_manager)
	game_manager.entity_selected.connect(ui_manager._on_entity_selected)
	
	game_manager.spell_selected.disconnect(ui_manager)
	game_manager.spell_selected.connect(ui_manager._on_spell_selected)
	
	game_manager.game_ended.disconnect(ui_manager)
	game_manager.game_ended.connect(ui_manager._on_game_ended)
	
	game_manager.message_requested.disconnect(ui_manager)
	game_manager.message_requested.connect(ui_manager._on_message_requested)
	
	# UIManager -> GameManager
	ui_manager.disconnect("end_turn_requested", game_manager)
	ui_manager.end_turn_requested.connect(game_manager.next_player)
	
	ui_manager.disconnect("restart_requested", game_manager)
	ui_manager.restart_requested.connect(game_manager.reset_game)
	
	ui_manager.disconnect("spell_selected", game_manager)
	ui_manager.spell_selected.connect(game_manager.handle_spell_selected)
	
	# SpellManager -> UIManager
	spell_manager.disconnect("spell_selected", ui_manager)
	spell_manager.spell_selected.connect(ui_manager._on_spell_button_selected)