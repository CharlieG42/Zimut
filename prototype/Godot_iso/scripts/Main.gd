extends Node2D
## Main.gd - Script principal (coordination des managers)
## Version avec connexions directes (pas de Callable)

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
	# Utiliser la syntaxe directe : objet.signal.connect(fonction)
	# Plus fiable que Callable() surtout avec les autoloads
	
	# GridManager -> GameManager
	if not grid_manager.is_connected("cell_clicked", game_manager, "handle_cell_selected"):
		grid_manager.cell_clicked.connect(game_manager.handle_cell_selected)
	
	# GameManager -> UIManager
	if not game_manager.turn_changed.is_connected(ui_manager, "_on_turn_changed"):
		game_manager.turn_changed.connect(ui_manager._on_turn_changed)
	
	if not game_manager.player_changed.is_connected(ui_manager, "_on_player_changed"):
		game_manager.player_changed.connect(ui_manager._on_player_changed)
	
	if not game_manager.entity_selected.is_connected(ui_manager, "_on_entity_selected"):
		game_manager.entity_selected.connect(ui_manager._on_entity_selected)
	
	if not game_manager.spell_selected.is_connected(ui_manager, "_on_spell_selected"):
		game_manager.spell_selected.connect(ui_manager._on_spell_selected)
	
	if not game_manager.game_ended.is_connected(ui_manager, "_on_game_ended"):
		game_manager.game_ended.connect(ui_manager._on_game_ended)
	
	if not game_manager.message_requested.is_connected(ui_manager, "_on_message_requested"):
		game_manager.message_requested.connect(ui_manager._on_message_requested)
	
	# UIManager -> GameManager
	if not ui_manager.is_connected("end_turn_requested", game_manager, "next_player"):
		ui_manager.end_turn_requested.connect(game_manager.next_player)
	
	if not ui_manager.is_connected("restart_requested", game_manager, "reset_game"):
		ui_manager.restart_requested.connect(game_manager.reset_game)
	
	if not ui_manager.is_connected("spell_selected", game_manager, "handle_spell_selected"):
		ui_manager.spell_selected.connect(game_manager.handle_spell_selected)
	
	# SpellManager -> UIManager
	if not spell_manager.is_connected("spell_selected", ui_manager, "_on_spell_button_selected"):
		spell_manager.spell_selected.connect(ui_manager._on_spell_button_selected)