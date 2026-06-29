extends Node2D

# Script de gestion de la sélection d'équipe
# Permet au joueur de choisir 3 personnages parmi les classes disponibles

# Signaux
signal team_selected(team_data)
signal back_to_menu

# Constantes
const MAX_TEAM_SIZE = 3
const CLASS_COLORS = {
	"Tank": Color(0.0, 0.25, 0.5),      # Bleu
	"Assassin": Color(0.5, 0.0, 0.0),   # Rouge
	"Chasseur": Color(0.0, 0.5, 0.0),   # Vert
	"Mage": Color(0.38, 0.0, 0.5),     # Violet
	"Support": Color(1.0, 0.5, 0.0),    # Orange
	"Heal": Color(0.0, 0.75, 0.75),    # Cyan
	"Invocateur": Color(0.5, 0.0, 0.5)  # Violet foncé
}

# Variables
var available_classes = []
var selected_team = []
var class_buttons = {}
var class_info_labels = {}
var team_preview_nodes = []

# Données des classes (chargées depuis CSV ou définies ici)
var class_data = {
	"Tank": {
		"name": "Tank",
		"description": "Résistant, haute défense, bon en combat rapproché",
		"color": Color(0.0, 0.25, 0.5),
		"icon": "ð¡ï¸",
		"base_stats": {"PV": 236, "PA": 6, "PM": 4, "Force": 34, "Intelligence": 13, "Défense": 39}
	},
	"Assassin": {
		"name": "Assassin",
		"description": "Rapide, dégâts élevés, spécialiste des attaques critiques",
		"color": Color(0.5, 0.0, 0.0),
		"icon": "ð¡ï¸",
		"base_stats": {"PV": 202, "PA": 6, "PM": 4, "Force": 39, "Intelligence": 22, "Défense": 26}
	},
	"Chasseur": {
		"name": "Chasseur",
		"description": "Polyvalent, bon Ã  distance, équilibre parfait",
		"color": Color(0.0, 0.5, 0.0),
		"icon": "ð¹",
		"base_stats": {"PV": 212, "PA": 6, "PM": 4, "Force": 42, "Intelligence": 24, "Défense": 39}
	},
	"Mage": {
		"name": "Mage",
		"description": "Dégâts magiques élevés, faible défense, sorts puissants",
		"color": Color(0.38, 0.0, 0.5),
		"icon": "ð®",
		"base_stats": {"PV": 192, "PA": 6, "PM": 4, "Force": 28, "Intelligence": 49, "Défense": 29}
	},
	"Support": {
		"name": "Support",
		"description": "Renforce l'équipe, buffs et soins, polyvalent",
		"color": Color(1.0, 0.5, 0.0),
		"icon": "ð",
		"base_stats": {"PV": 207, "PA": 6, "PM": 4, "Force": 34, "Intelligence": 39, "Défense": 44}
	},
	"Heal": {
		"name": "Heal",
		"description": "Spécialiste des soins, restauration de PV, survie",
		"color": Color(0.0, 0.75, 0.75),
		"icon": "â¤ï¸",
		"base_stats": {"PV": 242, "PA": 6, "PM": 4, "Force": 20, "Intelligence": 42, "Défense": 42}
	},
	"Invocateur": {
		"name": "Invocateur",
		"description": "Invoque des créatures, stratégie de groupe, contrôle",
		"color": Color(0.5, 0.0, 0.5),
		"icon": "ð­",
		"base_stats": {"PV": 202, "PA": 6, "PM": 4, "Force": 22, "Intelligence": 44, "Défense": 36}
	}
}

# Appelé lorsque le nÅud est ajouté Ã  l'arbre de scène
func _ready():
	available_classes = class_data.keys()
	
# Récupérer le bouton existant de la scène
	var start_button = $StartButton
	start_button.pressed.connect(_on_start_combat)
	_update_team_preview()

