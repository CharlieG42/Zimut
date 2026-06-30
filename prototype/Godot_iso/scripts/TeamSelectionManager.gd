extends Node2D
## TeamSelectionManager.gd - Sélection d'équipe avant combat (WildZimut)
## Réécriture complète : s'appuie UNIQUEMENT sur les nœuds déjà présents
## dans TeamSelection.tscn (7 boutons classe, 3 TeamPreview, StartButton).
## Aucune création dynamique de bouton -> plus de doublon ni de double _ready().

signal team_selected(team_data: Array)
signal back_to_menu

const MAX_TEAM_SIZE: int = 3

## Couleurs par classe (fallback si CSV absent)
const CLASS_COLORS: Dictionary = {
	"Tank":       Color(0.0, 0.4, 0.8),
	"Assassin":   Color(0.8, 0.0, 0.0),
	"Chasseur":   Color(0.0, 0.6, 0.0),
	"Mage":       Color(0.6, 0.0, 0.8),
	"Druide":    Color(1.0, 0.6, 0.0),
	"Heal":       Color(0.0, 0.75, 0.75),
	"Invocateur": Color(0.5, 0.0, 0.5),
}

## Données par défaut si le CSV ne fournit pas tout (icône + description manuelles)
const CLASS_META: Dictionary = {
	"Tank":       {"icon": "🛡️", "description": "Résistant, haute défense, encaisse pour l'équipe."},
	"Assassin":   {"icon": "🗡️", "description": "Rapide, dégâts élevés, frappe les cibles fragiles."},
	"Chasseur":   {"icon": "🏹", "description": "Polyvalent à distance, bon équilibre attaque/défense."},
	"Mage":       {"icon": "🔮", "description": "Dégâts magiques élevés, faible défense."},
	"Druide":    {"icon": "🌿", "description": "Maître de la nature, soigne et renforce avec des sorts naturels."},
	"Heal":       {"icon": "❤️", "description": "Spécialiste des soins et de la survie."},
	"Invocateur": {"icon": "🎭", "description": "Invoque des créatures, contrôle le champ."},
}

var available_classes: Array[String] = []
var selected_team: Array = []                 # [{ "name": String, "data": Dictionary }, ...]
var class_buttons: Dictionary = {}            # classname -> Button
var class_data: Dictionary = {}               # classname -> { name, description, color, icon, base_stats }

@onready var start_button: Button = $StartButton


func _ready() -> void:
	_load_class_data()
	# class_data.keys() retourne un Array générique non typé ; Godot 4.7 refuse
	# son assignation directe à une Array[String] -> conversion explicite requise.
	available_classes.clear()
	for k in class_data.keys():
		available_classes.append(k as String)
	_setup_class_buttons()
	_setup_start_button()
	_update_team_preview()


# ─── Chargement des données de classe (CSV si possible, sinon fallback) ────

func _load_class_data() -> void:
	var loaded_from_csv: bool = _try_load_from_csv()
	if not loaded_from_csv:
		_load_fallback_data()


func _try_load_from_csv() -> bool:
	## Lit res://data/classes.csv et prend les stats au niveau le plus haut
	## disponible (cohérent avec DEFAULT_PLAYER_LEVEL du GameManager).
	var file := FileAccess.open("res://data/classes.csv", FileAccess.READ)
	if file == null:
		return false

	var content: String = file.get_as_text()
	file.close()

	var lines: PackedStringArray = content.split("\n")
	if lines.size() < 2:
		return false

	var headers: PackedStringArray = lines[0].split(",")
	for i: int in range(headers.size()):
		headers[i] = headers[i].strip_edges()

	# best_level[classe] = niveau le plus élevé trouvé jusqu'ici
	var best_level: Dictionary = {}

	for i: int in range(1, lines.size()):
		var line: String = lines[i].strip_edges()
		if line.is_empty():
			continue
		var values: PackedStringArray = line.split(",")
		if values.size() < headers.size():
			continue

		var row: Dictionary = {}
		for j: int in range(headers.size()):
			row[headers[j]] = values[j].strip_edges()

		var classe: String = row.get("Classe", "")
		if classe == "":
			continue
		var lvl: int = int(row.get("Niveau", "0"))

		if not best_level.has(classe) or lvl > int(best_level[classe]):
			best_level[classe] = lvl
			var meta: Dictionary = CLASS_META.get(classe, {"icon": "⚔️", "description": ""})
			class_data[classe] = {
				"name":        classe,
				"description": meta["description"],
				"color":       CLASS_COLORS.get(classe, Color(0.5, 0.5, 0.5)),
				"icon":        meta["icon"],
				"base_stats": {
					"PV":           int(row.get("Vita (PV)", "0")),
					"PA":           int(row.get("PA", "0")),
					"PM":           int(row.get("PM", "0")),
					"Force":        int(row.get("Force (CAC)", "0")),
					"Intelligence": int(row.get("Intelligence (Magie)", "0")),
					"Agilite":      int(row.get("Agilité (Vit. Atk)", "0")),
					"Sagesse":      int(row.get("Sagesse (Précision)", "0")),
					"Defense":      int(row.get("Défense", "0")),
				}
			}

	return class_data.size() > 0


func _load_fallback_data() -> void:
	## Stats de secours si classes.csv est introuvable
	class_data = {
		"Tank":       {"name": "Tank", "description": CLASS_META["Tank"]["description"], "color": CLASS_COLORS["Tank"], "icon": CLASS_META["Tank"]["icon"],
			"base_stats": {"PV": 236, "PA": 6, "PM": 4, "Force": 34, "Intelligence": 13, "Agilite": 10, "Sagesse": 10, "Defense": 39}},
		"Assassin":   {"name": "Assassin", "description": CLASS_META["Assassin"]["description"], "color": CLASS_COLORS["Assassin"], "icon": CLASS_META["Assassin"]["icon"],
			"base_stats": {"PV": 202, "PA": 6, "PM": 4, "Force": 39, "Intelligence": 22, "Agilite": 25, "Sagesse": 15, "Defense": 26}},
		"Chasseur":   {"name": "Chasseur", "description": CLASS_META["Chasseur"]["description"], "color": CLASS_COLORS["Chasseur"], "icon": CLASS_META["Chasseur"]["icon"],
			"base_stats": {"PV": 212, "PA": 6, "PM": 4, "Force": 42, "Intelligence": 24, "Agilite": 20, "Sagesse": 18, "Defense": 39}},
		"Mage":       {"name": "Mage", "description": CLASS_META["Mage"]["description"], "color": CLASS_COLORS["Mage"], "icon": CLASS_META["Mage"]["icon"],
			"base_stats": {"PV": 192, "PA": 6, "PM": 4, "Force": 28, "Intelligence": 49, "Agilite": 12, "Sagesse": 14, "Defense": 29}},
		"Druide":    {"name": "Druide", "description": CLASS_META["Druide"]["description"], "color": CLASS_COLORS["Druide"], "icon": CLASS_META["Druide"]["icon"],
			"base_stats": {"PV": 207, "PA": 6, "PM": 4, "Force": 34, "Intelligence": 39, "Agilite": 14, "Sagesse": 16, "Defense": 44}},
		"Heal":       {"name": "Heal", "description": CLASS_META["Heal"]["description"], "color": CLASS_COLORS["Heal"], "icon": CLASS_META["Heal"]["icon"],
			"base_stats": {"PV": 242, "PA": 6, "PM": 4, "Force": 20, "Intelligence": 42, "Agilite": 11, "Sagesse": 17, "Defense": 42}},
		"Invocateur": {"name": "Invocateur", "description": CLASS_META["Invocateur"]["description"], "color": CLASS_COLORS["Invocateur"], "icon": CLASS_META["Invocateur"]["icon"],
			"base_stats": {"PV": 202, "PA": 6, "PM": 4, "Force": 22, "Intelligence": 44, "Agilite": 13, "Sagesse": 19, "Defense": 36}},
	}


# ─── Connexion des boutons déjà présents dans la scène ─────────────────────

func _setup_class_buttons() -> void:
	for classe: String in available_classes:
		var button_name: String = "%s_Button" % classe
		var button: Button = get_node_or_null(button_name) as Button
		if button == null:
			push_warning("Bouton '%s' introuvable dans la scène — classe ignorée." % button_name)
			continue

		class_buttons[classe] = button

		# Texte + style à partir des données chargées
		var info: Dictionary = class_data[classe]
		button.text = "%s %s" % [info["icon"], info["name"]]
		button.tooltip_text = _build_tooltip(info)
		_style_button(button, info["color"], false)

		# (re)connecter proprement (éviter double-connexion en cas de reload de scène)
		if button.pressed.is_connected(_on_class_selected):
			button.pressed.disconnect(_on_class_selected)
		button.pressed.connect(_on_class_selected.bind(classe))

		if not button.mouse_entered.is_connected(_on_class_hover):
			button.mouse_entered.connect(_on_class_hover.bind(classe, true))
		if not button.mouse_exited.is_connected(_on_class_hover):
			button.mouse_exited.connect(_on_class_hover.bind(classe, false))


func _build_tooltip(info: Dictionary) -> String:
	var s: Dictionary = info["base_stats"]
	return "%s\n\nPV: %d   PA: %d   PM: %d\nForce: %d   Intel: %d\nAgilité: %d   Sagesse: %d   Défense: %d" % [
		info["description"], s.get("PV", 0), s.get("PA", 0), s.get("PM", 0),
		s.get("Force", 0), s.get("Intelligence", 0), s.get("Agilite", 0),
		s.get("Sagesse", 0), s.get("Defense", 0)
	]


func _style_button(button: Button, color: Color, disabled: bool) -> void:
	var base: StyleBoxFlat = StyleBoxFlat.new()
	base.bg_color = color if not disabled else Color(0.25, 0.25, 0.25)
	for c in ["corner_radius_top_left", "corner_radius_top_right",
			  "corner_radius_bottom_left", "corner_radius_bottom_right"]:
		base.set(c, 10)
	button.add_theme_stylebox_override("normal", base)

	var hover: StyleBoxFlat = base.duplicate()
	hover.bg_color = (color + Color(0.15, 0.15, 0.15)).clamp() if not disabled else base.bg_color
	button.add_theme_stylebox_override("hover", hover)

	var pressed: StyleBoxFlat = base.duplicate()
	pressed.bg_color = (color - Color(0.15, 0.15, 0.15)).clamp() if not disabled else base.bg_color
	button.add_theme_stylebox_override("pressed", pressed)

	var disabled_box: StyleBoxFlat = base.duplicate()
	disabled_box.bg_color = Color(0.2, 0.2, 0.2)
	button.add_theme_stylebox_override("disabled", disabled_box)

	button.add_theme_color_override("font_color", Color(1, 1, 1))
	button.disabled = disabled


func _setup_start_button() -> void:
	if start_button:
		if start_button.pressed.is_connected(_on_start_combat):
			start_button.pressed.disconnect(_on_start_combat)
		start_button.pressed.connect(_on_start_combat)
		start_button.disabled = true


# ─── Survol : affiche les stats détaillées via tooltip natif (déjà câblé) ──

func _on_class_hover(_classe: String, _is_hover: bool) -> void:
	pass  # Le tooltip natif Godot (button.tooltip_text) gère déjà l'affichage au survol


# ─── Sélection / désélection d'une classe ──────────────────────────────────

func _on_class_selected(classe: String) -> void:
	# Déjà sélectionnée ?
	for entry: Dictionary in selected_team:
		if entry["name"] == classe:
			return

	if selected_team.size() >= MAX_TEAM_SIZE:
		message_full_team()
		return

	selected_team.append({"name": classe, "data": class_data[classe]})

	if class_buttons.has(classe):
		_style_button(class_buttons[classe], class_data[classe]["color"], true)

	_update_team_preview()
	_update_start_button_state()


func message_full_team() -> void:
	## Petit feedback visuel si on essaie d'ajouter un 4e personnage
	if start_button:
		var original: String = start_button.text
		start_button.text = "Équipe déjà complète (3/3)"
		await get_tree().create_timer(1.2).timeout
		if is_instance_valid(start_button):
			start_button.text = original


func _on_remove_from_team(index: int) -> void:
	if index < 0 or index >= selected_team.size():
		return
	var classe: String = selected_team[index]["name"]
	selected_team.remove_at(index)

	if class_buttons.has(classe):
		_style_button(class_buttons[classe], class_data[classe]["color"], false)

	_update_team_preview()
	_update_start_button_state()


func _update_start_button_state() -> void:
	if start_button:
		start_button.disabled = selected_team.size() < MAX_TEAM_SIZE


# ─── Mise à jour des 3 emplacements de prévisualisation ────────────────────

func _update_team_preview() -> void:
	var preview_title: Label = get_node_or_null("PreviewTitle") as Label
	if preview_title:
		preview_title.text = "Votre équipe (%d/%d)" % [selected_team.size(), MAX_TEAM_SIZE]

	for i: int in range(MAX_TEAM_SIZE):
		var frame: Panel = get_node_or_null("TeamPreview_%d" % i) as Panel
		if frame == null:
			continue
		var name_label: Label   = frame.get_node_or_null("NameLabel_%d" % i) as Label
		var stats_label: Label  = frame.get_node_or_null("StatsLabel_%d" % i) as Label
		var remove_btn: Button  = frame.get_node_or_null("RemoveButton_%d" % i) as Button

		if i < selected_team.size():
			var info: Dictionary = selected_team[i]["data"]
			var s: Dictionary = info["base_stats"]

			var box: StyleBoxFlat = StyleBoxFlat.new()
			box.bg_color = (info["color"] as Color)
			box.bg_color.a = 0.35
			box.border_color = info["color"]
			for side in ["left", "right", "top", "bottom"]:
				box.set("border_width_%s" % side, 2)
				box.set("corner_radius_%s_%s" % (["top","left"] if side=="top" else ["bottom","right"]), 12)
			frame.add_theme_stylebox_override("panel", box)

			if name_label:
				name_label.text = "%s %s" % [info["icon"], info["name"]]
			if stats_label:
				stats_label.text = "PV:%d  PA:%d  PM:%d\nForce:%d  Int:%d\nAgi:%d  Sag:%d  Def:%d" % [
					s.get("PV",0), s.get("PA",0), s.get("PM",0),
					s.get("Force",0), s.get("Intelligence",0),
					s.get("Agilite",0), s.get("Sagesse",0), s.get("Defense",0)
				]
			if remove_btn:
				remove_btn.visible = true
				if not remove_btn.pressed.is_connected(_on_remove_from_team):
					remove_btn.pressed.connect(_on_remove_from_team.bind(i))
		else:
			var empty_box: StyleBoxFlat = StyleBoxFlat.new()
			empty_box.bg_color = Color(0.15, 0.15, 0.15, 0.8)
			empty_box.border_color = Color(0.5, 0.5, 0.5)
			for side in ["left", "right", "top", "bottom"]:
				empty_box.set("border_width_%s" % side, 2)
			frame.add_theme_stylebox_override("panel", empty_box)

			if name_label:
				name_label.text = "-"
			if stats_label:
				stats_label.text = ""
			if remove_btn:
				remove_btn.visible = false


# ─── Lancement du combat ────────────────────────────────────────────────────

func _on_start_combat() -> void:
	if selected_team.size() != MAX_TEAM_SIZE:
		return

	var team_data: Array = []
	for entry: Dictionary in selected_team:
		var info: Dictionary = entry["data"]
		var s: Dictionary = info["base_stats"]
		team_data.append({
			"classe":       info["name"],
			"entity_type":  "Player",
			"max_pv":       s.get("PV", 100),
			"current_pv":   s.get("PV", 100),
			"force":        s.get("Force", 10),
			"intelligence": s.get("Intelligence", 10),
			"agilite":      s.get("Agilite", 10),
			"sagesse":      s.get("Sagesse", 10),
			"defense":      s.get("Defense", 10),
			"pa":           s.get("PA", 5),
			"max_pa":       s.get("PA", 5),
			"pm":           s.get("PM", 3),
			"max_pm":       s.get("PM", 3),
			"x": -1, "y": -1,
			"color": info["color"],
		})

	# Brancher directement sur l'autoload GameManager (set_custom_team existe déjà)
	if GameManager and GameManager.has_method("set_custom_team"):
		GameManager.set_custom_team(team_data)
	else:
		push_error("GameManager.set_custom_team() introuvable — vérifier l'autoload.")
		return

	team_selected.emit(team_data)

	# Changer de scène vers le combat
	get_tree().change_scene_to_file("res://scenes/Main.tscn")


# ─── Réinitialisation (utile si on revient sur cette scène) ────────────────

func reset_selection() -> void:
	selected_team.clear()
	for classe: String in class_buttons.keys():
		_style_button(class_buttons[classe], class_data[classe]["color"], false)
	_update_team_preview()
	_update_start_button_state()
