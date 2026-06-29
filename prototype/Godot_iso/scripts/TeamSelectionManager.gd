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
	
# Initialiser les dictionnaires
	for classname in available_classes:
		var button = get_node("%s_Button" % classname)
		if button:
			class_buttons[classname] = button
			# Créer le label d'info si nécessaire
			var info_label_name = "%s_Info" % classname
			var info_label = get_node_or_null(info_label_name)
			if not info_label:
				info_label = Label.new()
				info_label.name = info_label_name
				info_label.text = class_data[classname]["description"]
				info_label.position = button.position + Vector2(0, button.rect_size.y + 10)
				info_label.visible = false
				info_label.add_theme_color_override("font_color", Color(0.9, 0.9, 0.9))
				info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
				add_child(info_label)
			class_info_labels[classname] = info_label
	
	# Initialiser team_preview_nodes
	for i in range(MAX_TEAM_SIZE):
		var preview_frame = get_node_or_null("TeamPreview_%d" % i)
		if preview_frame:
			team_preview_nodes.append(preview_frame)
	
# Connecter les boutons de classe
	for classname in available_classes:
		var button_name = "%s_Button" % classname
		var button = get_node_or_null(button_name)
		if button:
			button.pressed.connect(_on_class_selected.bind(classname))
			button.mouse_entered.connect(_on_class_hover.bind(classname, true))
			button.mouse_exited.connect(_on_class_hover.bind(classname, false))
	available_classes = class_data.keys()
	
# Récupérer le bouton existant de la scène
	var start_button = $StartButton
	start_button.pressed.connect(_on_start_combat)
	_update_team_preview()



# Appelé lorsqu'une classe est sélectionnée
func _on_class_selected(classname: String):
	for i in range(selected_team.size()):
		if selected_team[i]["name"] == classname:
			return
	
	if selected_team.size() < MAX_TEAM_SIZE:
		var class_info = class_data[classname]
		selected_team.append({
			"name": classname,
			"data": class_info
		})
		_update_team_preview()
		
		var start_button = get_node("StartButton")
		if start_button:
			start_button.disabled = selected_team.size() < MAX_TEAM_SIZE
	else:
		print("L'équipe est déjà complète (3/3)")

func _on_class_hover(classname: String, is_hover: bool):
	if class_info_labels.has(classname):
		class_info_labels[classname].visible = is_hover

func _on_remove_from_team(index: int):
	if index < selected_team.size():
		var classname = selected_team[index]["name"]
		if class_buttons.has(classname):
			class_buttons[classname].disabled = false
		selected_team.remove_at(index)
		_update_team_preview()
		
		var start_button = get_node("StartButton")
		if start_button:
			start_button.disabled = selected_team.size() < MAX_TEAM_SIZE

func _update_team_preview():
	var preview_title = get_node("PreviewTitle")
	if preview_title:
		preview_title.text = "Votre équipe (%d/%d)" % [selected_team.size(), MAX_TEAM_SIZE]
	
	for i in range(MAX_TEAM_SIZE):
		var preview_frame = get_node("TeamPreview_%d" % i)
		var name_label = get_node("TeamPreview_%d/NameLabel_%d" % [i, i])
		var stats_label = get_node("TeamPreview_%d/StatsLabel_%d" % [i, i])
		var remove_button = get_node("TeamPreview_%d/RemoveButton_%d" % [i, i])
		
		if preview_frame:
			if i < selected_team.size():
				var class_info = selected_team[i]["data"]
				var stylebox = StyleBoxFlat.new()
				stylebox.bg_color = class_info["color"] + Color(0.1, 0.1, 0.1, 0.3)
				stylebox.corner_radius_top_left = 15
				stylebox.corner_radius_top_right = 15
				stylebox.corner_radius_bottom_right = 15
				stylebox.corner_radius_bottom_left = 15
				stylebox.border_width_left = 2
				stylebox.border_width_right = 2
				stylebox.border_width_top = 2
				stylebox.border_width_bottom = 2
				stylebox.border_color = class_info["color"]
				preview_frame.add_theme_stylebox_override("panel", stylebox)
				if name_label:
					name_label.text = class_info["icon"] + " %s" % class_info["name"]
				if stats_label:
					var stats_text = "PV: %d
PA: %d
PM: %d" % [
						class_info["base_stats"]["PV"],
						class_info["base_stats"]["PA"],
						class_info["base_stats"]["PM"]
					]
					stats_label.text = stats_text
				if remove_button:
					remove_button.visible = true
			else:
				if preview_frame:
					var stylebox = StyleBoxFlat.new()
					stylebox.bg_color = Color(0.15, 0.15, 0.15, 0.8)
					stylebox.corner_radius_top_left = 15
					stylebox.corner_radius_top_right = 15
					stylebox.corner_radius_bottom_right = 15
					stylebox.corner_radius_bottom_left = 15
					stylebox.border_width_left = 2
					stylebox.border_width_right = 2
					stylebox.border_width_top = 2
					stylebox.border_width_bottom = 2
					stylebox.border_color = Color(0.5, 0.5, 0.5)
					preview_frame.add_theme_stylebox_override("panel", stylebox)
		if name_label:
			name_label.text = "-"
		if stats_label:
			stats_label.text = ""
		if remove_button:
			remove_button.visible = false

func _on_start_combat():
	if selected_team.size() == MAX_TEAM_SIZE:
		var team_data = []
		for i in range(selected_team.size()):
			var class_info = selected_team[i]["data"]
			team_data.append({
				"classe": class_info["name"],
				"entity_type": "Player",
				"max_pv": class_info["base_stats"]["PV"],
				"current_pv": class_info["base_stats"]["PV"],
				"pa": class_info["base_stats"]["PA"],
				"current_pa": class_info["base_stats"]["PA"],
				"pm": class_info["base_stats"]["PM"],
				"current_pm": class_info["base_stats"]["PM"],
				"force": class_info["base_stats"]["Force"],
				"intelligence": class_info["base_stats"]["Intelligence"],
				"defense": class_info["base_stats"]["Défense"],
				"x": -1,
				"y": -1,
				"color": class_info["color"]
			})
		if GameManager and GameManager.has_method("set_custom_team"):
			GameManager.set_custom_team(team_data)
			team_selected.emit(team_data)
		get_tree().change_scene_to_file("res://scenes/Main.tscn")
