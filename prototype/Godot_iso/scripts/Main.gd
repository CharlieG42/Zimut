extends Node2D
## Main.gd - Script principal (coordination des managers et gestion des scènes)
## Modifié pour inclure la sélection d'équipe

# Scènes
const TeamSelectionScene = preload("res://scenes/TeamSelection.tscn")
const GameScene = preload("res://scenes/Main.tscn")

# Variables
var current_scene: Node = null
var selected_team: Array = []
var team_selection_manager: Node = null

# Appelé au démarrage
func _ready() -> void:
	# Charger la scène de sélection d'équipe en premier
	_load_team_selection()

# Charge la scène de sélection d'équipe
func _load_team_selection() -> void:
	# Nettoyer la scène actuelle
	if current_scene:
		current_scene.queue_free()
		current_scene = null
	
	# Charger la nouvelle scène
	current_scene = TeamSelectionScene.instantiate()
	add_child(current_scene)
	
	# Connecter les signaux
	team_selection_manager = current_scene.get_node("TeamSelection")
	if team_selection_manager:
		team_selection_manager.team_selected.connect(_on_team_selected)

# Appelé lorsqu'une équipe est sélectionnée
func _on_team_selected(team_data: Array) -> void:
	# Sauvegarder l'équipe sélectionnée
	selected_team = team_data
	
	# Charger la scène de combat
	_load_game_scene()

# Charge la scène de combat
func _load_game_scene() -> void:
	# Nettoyer la scène actuelle
	if current_scene:
		current_scene.queue_free()
		current_scene = null
	
	# Charger la nouvelle scène
	current_scene = GameScene.instantiate()
	add_child(current_scene)
	
	# Passer l'équipe sélectionnée au GameManager
	var game_manager = get_node_or_null("/root/GameManager")
	if game_manager and game_manager.has_method("set_custom_team"):
		game_manager.set_custom_team(selected_team)
	
	# Initialiser le combat
	var main_node = current_scene.get_node("Main")
	if main_node and main_node.has_method("_init_game_with_team"):
		main_node._init_game_with_team(selected_team)

# Fonction pour revenir à la sélection d'équipe
func return_to_team_selection() -> void:
	_load_team_selection()

# Fonction pour relancer le combat avec la même équipe
func restart_with_same_team() -> void:
	_load_game_scene()
