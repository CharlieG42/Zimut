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
    _setup_ui()
    _update_team_preview()

# Configuration de l'interface utilisateur
func _setup_ui():
    # Créer le titre
    var title = Label.new()
    title.text = "WILDZIMUT - Sélection d'équipe"
    title.position = Vector2(0, -250)
    title.add_theme_font_override("font", load("res://assets/fonts/big_font.tres") if ResourceLoader.exists("res://assets/fonts/big_font.tres") else null)
    title.add_theme_color_override("font_color", Color(1, 1, 1))
    title.add_theme_color_override("font_outline_color", Color(0, 0, 0))
    title.outline_thickness = 2
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.width = 1000
    add_child(title)

    # Créer la description
    var description = Label.new()
    description.text = "Choisissez 3 personnages pour former votre équipe"
    description.position = Vector2(0, -220)
    description.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
    description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    description.width = 800
    add_child(description)

    # Créer les boutons de sélection de classe
    var y_pos = -150
    var button_width = 250
    var button_height = 60
    var margin = 20
    var start_x = -300
    
    for i in range(available_classes.size()):
        var classname = available_classes[i]
        var row = i / 3
        var col = i % 3
        
        var x_pos = start_x + col * (button_width + margin)
        y_pos = -150 + row * (button_height + margin)
        
        # Créer le bouton
        var button = Button.new()
        button.name = "%s_Button" % classname
        button.position = Vector2(x_pos, y_pos)
        button.size = Vector2(button_width, button_height)
        button.text = class_data[classname]["icon"] + " %s" % class_data[classname]["name"]
        button.pressed.connect(_on_class_selected.bind(classname))
        
        # Styliser le bouton
        var stylebox = StyleBoxFlat.new()
        stylebox.bg_color = class_data[classname]["color"]
        stylebox.corner_radius_top_left = 10
        stylebox.corner_radius_top_right = 10
        stylebox.corner_radius_bottom_right = 10
        stylebox.corner_radius_bottom_left = 10
        button.add_theme_stylebox_override("normal", stylebox)
        
        var stylebox_hover = StyleBoxFlat.new()
        stylebox_hover.bg_color = class_data[classname]["color"] + Color(0.2, 0.2, 0.2)
        stylebox_hover.corner_radius_top_left = 10
        stylebox_hover.corner_radius_top_right = 10
        stylebox_hover.corner_radius_bottom_right = 10
        stylebox_hover.corner_radius_bottom_left = 10
        button.add_theme_stylebox_override("hover", stylebox_hover)
        
        var stylebox_pressed = StyleBoxFlat.new()
        stylebox_pressed.bg_color = class_data[classname]["color"] + Color(-0.2, -0.2, -0.2)
        stylebox_pressed.corner_radius_top_left = 10
        stylebox_pressed.corner_radius_top_right = 10
        stylebox_pressed.corner_radius_bottom_right = 10
        stylebox_pressed.corner_radius_bottom_left = 10
        button.add_theme_stylebox_override("pressed", stylebox_pressed)
        
        button.add_theme_color_override("font_color", Color(1, 1, 1))
        button.add_theme_font_override("font", load("res://assets/fonts/medium_font.tres") if ResourceLoader.exists("res://assets/fonts/medium_font.tres") else null)
        button.add_theme_font_size_override("font_size", 16)
        
        add_child(button)
        class_buttons[classname] = button
        
        # Créer le label de description (apparaÃ®t au survol)
        var info_label = Label.new()
        info_label.name = "%s_Info" % classname
        info_label.text = class_data[classname]["description"]
        info_label.position = Vector2(x_pos, y_pos + button_height + 10)
        info_label.width = button_width
        info_label.visible = false
        info_label.add_theme_color_override("font_color", Color(0.9, 0.9, 0.9))
        info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        add_child(info_label)
        class_info_labels[classname] = info_label
        
        # Connecter les signaux de survol
        button.mouse_entered.connect(_on_class_hover.bind(classname, true))
        button.mouse_exited.connect(_on_class_hover.bind(classname, false))

    # Créer la section de prévisualisation de l'équipe
    var preview_title = Label.new()
    preview_title.text = "Votre équipe (%d/%d)" % [selected_team.size(), MAX_TEAM_SIZE]
    preview_title.position = Vector2(0, 120)
    preview_title.add_theme_color_override("font_color", Color(1, 1, 0.8))
    preview_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    add_child(preview_title)
    
    # Stocker la référence pour mise Ã  jour
    preview_title.name = "PreviewTitle"

    # Créer les emplacements de prévisualisation
    for i in range(MAX_TEAM_SIZE):
        var preview_frame = Panel.new()
        preview_frame.name = "TeamPreview_%d" % i
        preview_frame.position = Vector2(-100 + i * 120, 80)
        preview_frame.size = Vector2(100, 100)
        
        var stylebox = StyleBoxFlat.new()
        stylebox.bg_color = Color(0.15, 0.15, 0.15, 0.8)
        stylebox.corner_radius_top_left = 15
        stylebox.corner_radius_top_right = 15
        stylebox.corner_radius_bottom_right = 15
        stylebox.corner_radius_bottom_left = 15
        stylebox.border_width_all = 2
        stylebox.border_color = Color(0.5, 0.5, 0.5)
        preview_frame.add_theme_stylebox_override("panel", stylebox)
        
        add_child(preview_frame)
        team_preview_nodes.append(preview_frame)
        
        # Ajouter un label pour le nom
        var name_label = Label.new()
        name_label.name = "NameLabel_%d" % i
        name_label.position = Vector2(0, -30)
        name_label.width = 100
        name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        name_label.add_theme_color_override("font_color", Color(1, 1, 1))
        name_label.add_theme_font_size_override("font_size", 12)
        preview_frame.add_child(name_label)
        
        # Ajouter un label pour les stats
        var stats_label = Label.new()
        stats_label.name = "StatsLabel_%d" % i
        stats_label.position = Vector2(0, -10)
        stats_label.width = 100
        stats_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        stats_label.add_theme_color_override("font_color", Color(0.8, 0.8, 0.8))
        stats_label.add_theme_font_size_override("font_size", 10)
        preview_frame.add_child(stats_label)
        
        # Ajouter un bouton de suppression
        var remove_button = Button.new()
        remove_button.name = "RemoveButton_%d" % i
        remove_button.position = Vector2(40, 35)
        remove_button.size = Vector2(20, 20)
        remove_button.text = "X"
        remove_button.pressed.connect(_on_remove_from_team.bind(i))
        remove_button.visible = false
        remove_button.add_theme_color_override("font_color", Color(1, 0.3, 0.3))
        remove_button.add_theme_font_size_override("font_size", 12)
        preview_frame.add_child(remove_button)

    # Créer le bouton "Lancer le combat"
    var start_button = Button.new()
    start_button.name = "StartButton"
    start_button.position = Vector2(0, 200)
    start_button.size = Vector2(200, 50)
    start_button.text = "LANCER LE COMBAT"
    start_button.disabled = true
    start_button.pressed.connect(_on_start_combat)
    
    var stylebox = StyleBoxFlat.new()
    stylebox.bg_color = Color(0.0, 0.6, 0.0)
    stylebox.corner_radius_top_left = 10
    stylebox.corner_radius_top_right = 10
    stylebox.corner_radius_bottom_right = 10
    stylebox.corner_radius_bottom_left = 10
    start_button.add_theme_stylebox_override("normal", stylebox)
    
    var stylebox_hover = StyleBoxFlat.new()
    stylebox_hover.bg_color = Color(0.0, 0.8, 0.0)
    stylebox_hover.corner_radius_top_left = 10
    stylebox_hover.corner_radius_top_right = 10
    stylebox_hover.corner_radius_bottom_right = 10
    stylebox_hover.corner_radius_bottom_left = 10
    start_button.add_theme_stylebox_override("hover", stylebox_hover)
    
    start_button.add_theme_color_override("font_color", Color(1, 1, 1))
    start_button.add_theme_font_size_override("font_size", 16)
    start_button.add_theme_font_override("font", load("res://assets/fonts/big_font.tres") if ResourceLoader.exists("res://assets/fonts/big_font.tres") else null)
    
    add_child(start_button)
    
    # Stocker la référence
    start_button.name = "StartButton"

# Appelé lorsqu'une classe est sélectionnée
func _on_class_selected(classname: String):
    # Vérifier si la classe est déjÃ  sélectionnée
    for i in range(selected_team.size()):
        if selected_team[i]["name"] == classname:
            # DéjÃ  sélectionnée, ne rien faire ou afficher un message
            return
    
    # Ajouter Ã  l'équipe si on a moins de MAX_TEAM_SIZE
    if selected_team.size() < MAX_TEAM_SIZE:
        var class_info = class_data[classname]
        selected_team.append({
            "name": classname,
            "data": class_info
        })
        _update_team_preview()
        
        # Mettre Ã  jour l'état du bouton
        var button = class_buttons[classname]
        if button:
            button.disabled = true
            var stylebox = StyleBoxFlat.new()
            stylebox.bg_color = Color(0.3, 0.3, 0.3)
            stylebox.corner_radius_top_left = 10
            stylebox.corner_radius_top_right = 10
            stylebox.corner_radius_bottom_right = 10
            stylebox.corner_radius_bottom_left = 10
            button.add_theme_stylebox_override("disabled", stylebox)
        
        # Vérifier si on peut lancer le combat
        var start_button = get_node("StartButton")
        if start_button:
            start_button.disabled = selected_team.size() < MAX_TEAM_SIZE
    else:
        # Ãquipe pleine, afficher un message
        print("L'équipe est déjÃ  complète (3/3)")

# Appelé lorsqu'on survole une classe
func _on_class_hover(classname: String, is_hover: bool):
    if class_info_labels.has(classname):
        class_info_labels[classname].visible = is_hover

# Appelé pour supprimer un personnage de l'équipe
func _on_remove_from_team(index: int):
    if index < selected_team.size():
        var classname = selected_team[index]["name"]
        
        # Réactiver le bouton de la classe
        if class_buttons.has(classname):
            var button = class_buttons[classname]
            button.disabled = false
        
        # Supprimer de l'équipe
        selected_team.remove_at(index)
        _update_team_preview()
        
        # Vérifier si on peut lancer le combat
        var start_button = get_node("StartButton")
        if start_button:
            start_button.disabled = selected_team.size() < MAX_TEAM_SIZE

# Met Ã  jour l'aperçu de l'équipe
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
                
                # Mettre Ã  jour le style du cadre
                var stylebox = StyleBoxFlat.new()
                stylebox.bg_color = class_info["color"] + Color(0.1, 0.1, 0.1, 0.3)
                stylebox.corner_radius_top_left = 15
                stylebox.corner_radius_top_right = 15
                stylebox.corner_radius_bottom_right = 15
                stylebox.corner_radius_bottom_left = 15
                stylebox.border_width_all = 2
                stylebox.border_color = class_info["color"]
                preview_frame.add_theme_stylebox_override("panel", stylebox)
                
                # Mettre Ã  jour les labels
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
                # Réinitialiser
                if preview_frame:
                    var stylebox = StyleBoxFlat.new()
                    stylebox.bg_color = Color(0.15, 0.15, 0.15, 0.8)
                    stylebox.corner_radius_top_left = 15
                    stylebox.corner_radius_top_right = 15
                    stylebox.corner_radius_bottom_right = 15
                    stylebox.corner_radius_bottom_left = 15
                    stylebox.border_width_all = 2
                    stylebox.border_color = Color(0.5, 0.5, 0.5)
                    preview_frame.add_theme_stylebox_override("panel", stylebox)
                
                if name_label:
                    name_label.text = "-"
                
                if stats_label:
                    stats_label.text = ""
                
                if remove_button:
                    remove_button.visible = false

# Appelé pour lancer le combat
func _on_start_combat():
    if selected_team.size() == MAX_TEAM_SIZE:
        # Préparer les données de l'équipe pour le GameManager
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
                "agilite": class_info["base_stats"]["Agilité"],
                "sagesse": class_info["base_stats"]["Sagesse"],
                "x": -1,
                "y": -1,
                "color": class_info["color"]
            })
        
        # Passer l'équipe au GameManager (Autoload)
        var game_manager = get_node_or_null("/root/GameManager")
        if game_manager and game_manager.has_method("set_custom_team"):
            game_manager.set_custom_team(team_data)
        
        # Charger la scène de combat
        var game_scene = preload("res://scenes/Main.tscn")
        get_tree().change_scene_to(game_scene)

# Fonction pour charger les données depuis CSV (si disponible)
func load_classes_from_csv():
    var file = FileAccess.open("res://data/classes.csv", FileAccess.READ)
    if file:
        var content = file.get_as_text()
        file.close()
        
        var lines = content.split("
")
        for line in lines:
            if line.is_empty():
                continue
            var values = line.split(",")
            if values.size() >= 10:
                var classname = values[0]
                var level = int(values[1])
                
                # Si c'est le niveau 30 (niveau par défaut dans le jeu)
                if level == 30:
                    if not class_data.has(classname):
                        class_data[classname] = {
                            "name": classname,
                            "description": "",
                            "color": CLASS_COLORS[classname] if CLASS_COLORS.has(classname) else Color(0.5, 0.5, 0.5),
                            "icon": "âï¸",
                            "base_stats": {}
                        }
                    
                    class_data[classname]["base_stats"]["PV"] = int(values[3])
                    class_data[classname]["base_stats"]["PA"] = int(values[1])
                    class_data[classname]["base_stats"]["PM"] = int(values[2])
                    class_data[classname]["base_stats"]["Force"] = int(values[4])
                    class_data[classname]["base_stats"]["Intelligence"] = int(values[5])
                    class_data[classname]["base_stats"]["Défense"] = int(values[8])
        
        available_classes = class_data.keys()
        return true
    
    return false

# Fonction pour réinitialiser la sélection
func reset_selection():
    selected_team.clear()
    
    # Réactiver tous les boutons
    for classname in class_buttons.keys():
        if class_buttons[classname]:
            class_buttons[classname].disabled = false
    
    _update_team_preview()
    
    var start_button = get_node("StartButton")
    if start_button:
        start_button.disabled = true


# Méthode pour retourner Ã  la sélection d'équipe (appelée depuis UIManager)
func return_to_team_selection() -> void:
    reset_selection()
    # Recharger la scène de sélection d'équipe
    var team_scene = preload("res://scenes/TeamSelection.tscn")
    get_tree().change_scene_to(team_scene)
