extends Node2D

## BattleMain.gd - Script de la scene de bataille (mode Empire, Etape 2).
## Orchestre le combat tactique Zimut integre : instancie BattleGameManager,
## injecte l'armee attaquante et la garnison de la ville via BattleBridge,
## et remonte l'issue au EmpireManager avant retour a la carte.

@onready var grid_manager = $GridManager
@onready var ui_manager = $UIManager
@onready var turn_manager = $TurnManager

var battle_game_manager: Node
var empire_manager: Node

func _ready() -> void:
	empire_manager = get_node_or_null("/root/EmpireManager")
	if empire_manager == null:
		push_error("BattleMain: EmpireManager introuvable")
		return

	# BattleGameManager est instancie ici (et non en autoload) pour garder
	# un etat de bataille isole par conquete. Les equipes sont injectees
	# AVANT add_child : son _ready() appelle _on_data_loaded() qui peuple
	# directement players[]/enemies[] depuis ce contexte.
	var bgm_script: GDScript = load("res://scripts/battle/BattleGameManager.gd")
	battle_game_manager = bgm_script.new()
	battle_game_manager.name = "BattleGameManager"
	var bridge: Node = empire_manager.battle_bridge
	if bridge:
		battle_game_manager.set_custom_team(bridge.get_custom_team_for_gamemanager())
		battle_game_manager.set_custom_enemy_team(bridge.get_enemy_garrison_for_gamemanager())
	add_child(battle_game_manager)

	# Initialiser les managers APRES l'init des entites (cf Main.gd du mode
	# Zimut : grid_manager.init() appelle update_entity_display()).
	grid_manager.init(battle_game_manager)
	ui_manager.init(battle_game_manager)
	turn_manager.init(battle_game_manager)

	_connect_signals()
	# Activer le premier joueur : emet player_changed -> l'UI affiche
	# les sorts et la portee de deplacement.
	if battle_game_manager.players.size() > 0:
		battle_game_manager._set_active_player(0)
	var city: Dictionary = empire_manager.pending_battle.get("target_city", {})
	print("[BattleMain] Bataille pour %s lancee." % city.get("name", "?"))

func _connect_signals() -> void:
	# GridManager -> BattleGameManager
	if not grid_manager.cell_clicked.is_connected(battle_game_manager.handle_cell_selected):
		grid_manager.cell_clicked.connect(battle_game_manager.handle_cell_selected)
	# UIManager -> BattleGameManager
	if not ui_manager.end_turn_requested.is_connected(battle_game_manager.next_player):
		ui_manager.end_turn_requested.connect(battle_game_manager.next_player)
	if not ui_manager.spell_selected.is_connected(battle_game_manager.handle_spell_selected):
		ui_manager.spell_selected.connect(battle_game_manager.handle_spell_selected)
	# BattleGameManager -> retour Empire
	if not battle_game_manager.game_ended.is_connected(_on_battle_ended):
		battle_game_manager.game_ended.connect(_on_battle_ended)
	# UIManager -> retour Empire
	if not ui_manager.back_to_empire_requested.is_connected(_on_back_to_empire_pressed):
		ui_manager.back_to_empire_requested.connect(_on_back_to_empire_pressed)

## L'issue du combat remonte au EmpireManager (conquete ou echec).
func _on_battle_ended(battle_victory: bool) -> void:
	var bridge: Node = empire_manager.battle_bridge
	if bridge:
		bridge.on_zimut_battle_ended(battle_victory)

## Retour a la carte monde Empire apres la bataille.
func _on_back_to_empire_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
