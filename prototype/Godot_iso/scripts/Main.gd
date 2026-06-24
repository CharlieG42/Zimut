extends Node2D
## Main.gd - Script principal (coordination des managers)
## Version avec vérification is_connected pour éviter les erreurs

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
	# Vérifier que chaque signal n'est pas déjà connecté avant de le connecter
	# Cela évite les erreurs "already connected" et garantit que les signaux fonctionnent
	
	if not grid_manager.is_connected("cell_clicked", game_manager, "handle_cell_selected"):
		grid_manager.connect("cell_clicked", Callable(game_manager, "handle_cell_selected"))
	
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
	
	if not ui_manager.is_connected("end_turn_requested", game_manager, "next_player"):
		ui_manager.connect("end_turn_requested", Callable(game_manager, "next_player"))
	
	if not ui_manager.is_connected("restart_requested", game_manager, "reset_game"):
		ui_manager.connect("restart_requested", Callable(game_manager, "reset_game"))
	
	if not ui_manager.is_connected("spell_selected", game_manager, "handle_spell_selected"):
		ui_manager.connect("spell_selected", Callable(game_manager, "handle_spell_selected"))
	
	if not spell_manager.is_connected("spell_selected", ui_manager, "_on_spell_button_selected"):
		spell_manager.connect("spell_selected", Callable(ui_manager, "_on_spell_button_selected"))