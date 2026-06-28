extends Node2D
## Main.gd - Script principal pour la scène de combat
## Gère la coordination des managers DANS la scène de combat

@onready var grid_manager  = $GridManager
@onready var ui_manager    = $UIManager
@onready var turn_manager  = $TurnManager
@onready var entity_manager = $EntityManager
@onready var spell_manager = $SpellManager

var game_manager

func _ready() -> void:
	game_manager = GameManager
	grid_manager.init(game_manager)
	ui_manager.init(game_manager)
	turn_manager.init(game_manager)
	entity_manager.init(game_manager)
	spell_manager.init(game_manager)
	_connect_signals()

func _connect_signals() -> void:
	## Connexion simple sans disconnect() préalable

	# GridManager → GameManager
	if not grid_manager.cell_clicked.is_connected(game_manager.handle_cell_selected):
		grid_manager.cell_clicked.connect(game_manager.handle_cell_selected)

	# UIManager → GameManager
	if not ui_manager.end_turn_requested.is_connected(game_manager.next_player):
		ui_manager.end_turn_requested.connect(game_manager.next_player)

	if not ui_manager.restart_requested.is_connected(game_manager.reset_game):
		ui_manager.restart_requested.connect(game_manager.reset_game)

	if not ui_manager.spell_selected.is_connected(game_manager.handle_spell_selected):
		ui_manager.spell_selected.connect(game_manager.handle_spell_selected)

	# SpellManager → UIManager
	if not spell_manager.spell_selected.is_connected(ui_manager._on_spell_button_selected):
		spell_manager.spell_selected.connect(ui_manager._on_spell_button_selected)