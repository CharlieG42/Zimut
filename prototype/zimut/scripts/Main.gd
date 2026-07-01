extends Node2D
## Main.gd - Script principal pour la scène de combat
## FIX : redémarre explicitement la partie à l'arrivée sur cette scène,
##       pour que GameManager prenne en compte l'équipe choisie dans
##       TeamSelection (custom_team), au lieu de garder l'état du tout
##       premier _ready() de l'autoload (déclenché avant toute sélection).

@onready var grid_manager   = $GridManager
@onready var ui_manager     = $UIManager
@onready var turn_manager   = $TurnManager
@onready var entity_manager = $EntityManager
@onready var spell_manager  = $SpellManager

var game_manager


func _ready() -> void:
	game_manager = GameManager

	# IMPORTANT : initialiser tous les managers AVANT reset_game().
	# reset_game() déclenche en interne _refresh_grid(), qui appelle
	# GridManager.update_entity_display() — si GridManager.init() n'a pas
	# encore tourné, sa variable game_manager est encore null et l'appel
	# plante avec "Invalid access to property on a base object of type Nil".
	grid_manager.init(game_manager)
	ui_manager.init(game_manager)
	turn_manager.init(game_manager)
	entity_manager.init(game_manager)
	spell_manager.init(game_manager)

	# Reconstruit la grille et les entités à partir de l'état courant de
	# GameManager (qui contient déjà custom_team si on vient de TeamSelection).
	# reset_game() relance proprement init_grid()/init_entities() et remet
	# game_over/victory à false — indispensable si le joueur a déjà fait
	# une partie avant de revenir choisir une nouvelle équipe.
	if game_manager.has_method("reset_game"):
		game_manager.reset_game()

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
