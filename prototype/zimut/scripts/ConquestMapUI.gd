extends CanvasLayer

## Mode Conquête : carte des villes de Zimut reliée au combat tactique.
## Les villes, routes et types viennent du catalogue officiel
## (ProgressionManager.CONQUEST_CITIES / CONQUEST_ROUTES) : on ne peut
## attaquer qu'une ville reliée par route à son territoire.
## Les héros, sorts, caractéristiques et loots restent ceux de la sauvegarde commune.

const PANEL := Color(0.09, 0.15, 0.20, 0.97)
const TEXT := Color(0.95, 0.94, 0.84)
const GOLD := Color(0.96, 0.75, 0.31)

## Positions sur la carte (fractions du panneau) — le reste (noms, types,
## biomes, niveaux, routes) vient du catalogue de ProgressionManager.
## Carte organisée en quatre colonnes et sept rangées : les 28 villes
## s'étendent verticalement et demandent un défilement pour être explorées.
const CITY_POS := {
	"citadelle_ronce": Vector2(0.12, 0.09),
	"vieille_tour": Vector2(0.37, 0.09),
	"mine_cristal": Vector2(0.63, 0.09),
	"donjon_roi": Vector2(0.88, 0.09),
	"clairiere": Vector2(0.12, 0.22),
	"ruines_lierre": Vector2(0.37, 0.22),
	"col_givre": Vector2(0.63, 0.22),
	"garnison": Vector2(0.88, 0.22),
	"village_brume": Vector2(0.12, 0.35),
	"capitale": Vector2(0.37, 0.35),
	"abbaye_ronce": Vector2(0.63, 0.35),
	"bastion_orage": Vector2(0.88, 0.35),
	"pont_mousse": Vector2(0.12, 0.48),
	"fort_racine": Vector2(0.37, 0.48),
	"hameau_pin": Vector2(0.63, 0.48),
	"tour_sable": Vector2(0.88, 0.48),
	"caravanserail": Vector2(0.12, 0.61),
	"oasis": Vector2(0.37, 0.61),
	"observatoire": Vector2(0.63, 0.61),
	"port_sable": Vector2(0.88, 0.61),
	"bois_lune": Vector2(0.12, 0.74),
	"sanctuaire_mousse": Vector2(0.37, 0.74),
	"forge_givre": Vector2(0.63, 0.74),
	"pic_foudroyant": Vector2(0.88, 0.74),
	"marais_spectres": Vector2(0.12, 0.87),
	"fort_cendre": Vector2(0.37, 0.87),
	"temple_soleil": Vector2(0.63, 0.87),
	"citadelle_sable": Vector2(0.88, 0.87),
}
var _save: Dictionary = {}
var _slot: int = -1
var _conquest: Dictionary = {}
var _selected_id: String = "clairiere"
var _message: Label
var _attack: Button
var _city_buttons: Dictionary = {}
var _build_box: VBoxContainer
var _header: Label
var _root: Control
var _body_scroll: ScrollContainer
var _body_content: Control
var _map_scroll: ScrollContainer
var _map_panel: Panel
var _side_panel: PanelContainer
var _title_label: Label
var _subtitle_label: Label
var _legend_label: Label
var _map_title_label: Label
var _side_title: Label
var _back_button: Button
var _side_scroll: ScrollContainer

func _ready() -> void:
	Music.play("adventure")
	layer = 10
	_save = GameManager.active_save
	_slot = GameManager.active_slot
	if _save.is_empty() or _slot < 0:
		get_tree().change_scene_to_file("res://scenes/SaveSlots.tscn")
		return
	_conquest = _save.get("conquest", {})
	if _conquest.is_empty():
		_conquest = {"owned": ["capitale"], "pending_city": ""}
	_save["conquest"] = _conquest
	_save["campaign_mode"] = "conquest"
	_persist()
	_build()
	var annexed: String = String(_conquest.get("just_annexed", ""))
	if annexed != "":
		_conquest["just_annexed"] = ""
		_save["conquest"] = _conquest
		_persist()
		_show_annexion_popup(annexed)
	else:
		_show_counterattack_message()

func _build() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.34, 0.47, 0.49)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.offset_left = 28
	root.offset_right = -28
	root.offset_top = 20
	root.offset_bottom = -20
	add_child(root)
	_root = root
	_root.resized.connect(_layout_responsive)

	_title_label = Label.new()
	_title_label.text = "🏰  ZIMUT — CONQUÊTE"
	_title_label.position = Vector2(8, 0)
	_title_label.add_theme_color_override("font_color", TEXT)
	root.add_child(_title_label)

	_subtitle_label = Label.new()
	_subtitle_label.text = "Développez votre empire en remportant les batailles tactiques"
	_subtitle_label.position = Vector2(8, 42)
	_subtitle_label.add_theme_color_override("font_color", GOLD)
	root.add_child(_subtitle_label)

	_header = Label.new()
	_header.position = Vector2(8, 64)
	_header.add_theme_color_override("font_color", TEXT)
	_header.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	root.add_child(_header)

	# Le corps devient scrollable en mode compact : la carte reste lisible
	# et le conseil de guerre se retrouve sous elle, sans sortir de l'écran.
	_body_scroll = ScrollContainer.new()
	_body_scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_body_scroll.offset_top = 92
	_body_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_body_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	_body_scroll.follow_focus = false
	_body_scroll.mouse_filter = Control.MOUSE_FILTER_PASS
	root.add_child(_body_scroll)
	_body_content = Control.new()
	_body_content.custom_minimum_size = Vector2(1700, 750)
	_body_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_body_scroll.add_child(_body_content)

	# La carte de campagne comporte 28 villes sur sept rangées ; garder un
	# viewport distinct de son contenu permet de les explorer sans débordement. Le défilement
	# horizontal de la carte est indépendant du défilement vertical de la page.
	_map_scroll = ScrollContainer.new()
	_map_scroll.position = Vector2.ZERO
	_map_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	_map_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_map_scroll.follow_focus = false
	# Déclenchement du glissement presque immédiat, pour que le doigt déplace
	# la carte plutôt que de sélectionner accidentellement une ville.
	_map_scroll.scroll_deadzone = 2
	_body_scroll.scroll_deadzone = 2
	# Pas courts pour les commandes de défilement et barre plus large pour
	# pouvoir saisir précisément le curseur sur un écran tactile.
	var map_vbar := _map_scroll.get_v_scroll_bar()
	map_vbar.custom_step = 18.0
	map_vbar.custom_minimum_size.x = 20.0
	map_vbar.add_theme_stylebox_override("scroll", _style(Color(0.12, 0.19, 0.22, 0.92), Color(0.34, 0.43, 0.43)))
	map_vbar.add_theme_stylebox_override("grabber", _style(GOLD, Color(1.0, 0.9, 0.62)))
	map_vbar.add_theme_stylebox_override("grabber_highlight", _style(Color(1.0, 0.86, 0.38), Color(1.0, 0.96, 0.78)))
	map_vbar.add_theme_stylebox_override("grabber_pressed", _style(Color(0.95, 0.68, 0.22), Color(1.0, 0.96, 0.78)))
	_body_scroll.get_v_scroll_bar().custom_step = 18.0
	_map_scroll.mouse_filter = Control.MOUSE_FILTER_PASS
	_body_content.add_child(_map_scroll)

	var map := Panel.new()
	map.position = Vector2.ZERO
	map.size = Vector2(1320, 1600)
	map.add_theme_stylebox_override("panel", _style(PANEL, GOLD))
	_map_scroll.add_child(map)
	_map_panel = map

	_map_title_label = Label.new()
	_map_title_label.text = "LE MONDE DE ZIMUT"
	_map_title_label.position = Vector2(22, 14)
	_map_title_label.add_theme_color_override("font_color", TEXT)
	map.add_child(_map_title_label)

	_legend_label = Label.new()
	_legend_label.text = "Vert = territoire  ·  Gris = neutre  ·  Rouge = adverse  ·  ⚔ = attaquable"
	_legend_label.position = Vector2(260, 16)
	_legend_label.add_theme_color_override("font_color", GOLD)
	map.add_child(_legend_label)

	# Routes dessinées derrière les villes : dorées si elles relient deux
	# villes du territoire, ternes sinon.
	var routes := _RouteLines.new()
	routes.conquest = _conquest
	routes.city_pos = CITY_POS
	routes.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	map.add_child(routes)

	for city_id: String in _city_ids():
		var city: Dictionary = _city_meta(city_id)
		var btn := Button.new()
		var owned: bool = _conquest.get("owned", []).has(city_id)
		var attackable: bool = ProgressionManager.conquest_city_attackable(_conquest, city_id)
		var badge: String = "⚑" if owned else ("⚔" if attackable else ("⚔" if String(city["kind"]) == "enemy" else "●"))
		var siege_p: int = ProgressionManager.conquest_siege_progress(_conquest, city_id)
		var siege_txt: String = ("\nSiège %d/%d" % [siege_p, ProgressionManager.CONQUEST_SIEGE_BATTLES]) if siege_p > 0 else ""
		btn.text = ("%s\n" % badge) + String(city["name"]) + siege_txt
		btn.tooltip_text = "%s — %s" % [String(ProgressionManager.biome_label(String(city["biome"]))), String(city["desc"])]
		btn.position = Vector2(CITY_POS[city_id].x * map.size.x - 88, CITY_POS[city_id].y * map.size.y - 34)
		btn.custom_minimum_size = Vector2(196, 76)
		btn.add_theme_font_size_override("font_size", 18)
		btn.add_theme_color_override("font_color", TEXT)
		btn.add_theme_stylebox_override("normal", _style(_city_color(city_id), GOLD if city_id == _selected_id else Color(0.5, 0.64, 0.46)))
		btn.add_theme_stylebox_override("hover", _style(_city_color(city_id).lightened(0.12), GOLD))
		btn.pressed.connect(_select_city.bind(city_id))
		map.add_child(btn)
		_city_buttons[city_id] = btn

	var side := PanelContainer.new()
	side.position = Vector2(1340, 92)
	side.size = Vector2(430, 750)
	side.add_theme_stylebox_override("panel", _style(Color(0.10, 0.17, 0.21, 0.98), GOLD))
	_body_content.add_child(side)
	_side_panel = side

	_side_scroll = ScrollContainer.new()
	_side_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_side_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	_side_scroll.follow_focus = false
	side.add_child(_side_scroll)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 14)
	box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_side_scroll.add_child(box)

	_side_title = Label.new()
	_side_title.text = "CONSEIL DE GUERRE"
	_side_title.add_theme_color_override("font_color", TEXT)
	box.add_child(_side_title)

	_message = Label.new()
	_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_message.custom_minimum_size.y = 180
	_message.add_theme_color_override("font_color", TEXT)
	_message.add_theme_font_size_override("font_size", 18)
	box.add_child(_message)

	_attack = Button.new()
	_attack.text = "LANCER L'ASSAUT"
	_attack.custom_minimum_size.y = 68
	_attack.add_theme_font_size_override("font_size", 23)
	_attack.pressed.connect(_attack_selected_city)
	box.add_child(_attack)

	_build_box = VBoxContainer.new()
	_build_box.add_theme_constant_override("separation", 6)
	box.add_child(_build_box)

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_child(spacer)

	_back_button = Button.new()
	_back_button.text = "← MENU"
	_back_button.custom_minimum_size.y = 50
	_back_button.pressed.connect(_back_to_save)
	box.add_child(_back_button)

	_refresh_header()
	_select_city(_selected_id)
	_layout_responsive()

## Adapte la carte et le conseil à la taille réelle du viewport.
## En format compact (téléphone/portrait), la carte est en premier et le
## conseil de guerre se trouve dessous dans une zone verticalement défilante.
func _layout_responsive() -> void:
	if _root == null or _body_scroll == null or _body_content == null or _map_scroll == null or _map_panel == null or _side_panel == null:
		return
	if _title_label == null or _subtitle_label == null or _header == null or _legend_label == null or _map_title_label == null:
		return
	if _side_title == null or _message == null or _attack == null or _back_button == null or _build_box == null:
		return
	var w: float = maxf(280.0, _root.size.x)
	var h: float = maxf(400.0, _root.size.y)
	var compact: bool = w < 1000.0 or h < 560.0
	var body_top: float = 108.0 if compact else 92.0
	_body_scroll.offset_top = body_top
	_title_label.add_theme_font_size_override("font_size", 23 if compact else 30)
	_title_label.position = Vector2(8, 0)
	_subtitle_label.add_theme_font_size_override("font_size", 14 if compact else 18)
	_subtitle_label.position = Vector2(8, 32 if compact else 42)
	_header.add_theme_font_size_override("font_size", 12 if compact else 17)
	_header.position = Vector2(8, 55 if compact else 64)
	_header.size = Vector2(w - 16.0, 42.0 if compact else 24.0)

	if compact:
		var viewport_w: float = w
		# La zone visible reste bornée à l'écran ; la carte complète, elle,
		# est plus haute et défilante. Sur téléphone étroit, le défilement
		# horizontal reste disponible en plus du vertical.
		var map_w: float = maxf(1320.0, viewport_w)
		var map_view_h: float = clampf(h * 0.52, 360.0, 470.0)
		var map_content_h: float = maxf(1600.0, map_view_h)
		var side_h: float = 600.0
		_body_content.custom_minimum_size = Vector2(viewport_w, map_view_h + 14.0 + side_h)
		_map_scroll.position = Vector2.ZERO
		_map_scroll.size = Vector2(viewport_w, map_view_h)
		_map_scroll.custom_minimum_size = Vector2(viewport_w, map_view_h)
		_map_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO if map_w > viewport_w else ScrollContainer.SCROLL_MODE_DISABLED
		_map_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_ALWAYS
		_map_panel.position = Vector2.ZERO
		_map_panel.size = Vector2(map_w, map_content_h)
		_map_panel.custom_minimum_size = Vector2(map_w, map_content_h)
		_side_panel.position = Vector2(0, map_view_h + 14.0)
		_side_panel.size = Vector2(viewport_w, side_h)
		_side_panel.custom_minimum_size = Vector2(viewport_w, side_h)
		_legend_label.text = "Vert : allié · Gris : neutre · Rouge : ennemi · ⚔ : attaquable"
		_legend_label.position = Vector2(10, map_content_h - 27.0)
		_map_title_label.add_theme_font_size_override("font_size", 17)
		_legend_label.add_theme_font_size_override("font_size", 11)
		_side_title.add_theme_font_size_override("font_size", 20)
		_message.custom_minimum_size.y = 150
		_message.add_theme_font_size_override("font_size", 15)
		_attack.custom_minimum_size.y = 56
		_attack.add_theme_font_size_override("font_size", 18)
		_back_button.custom_minimum_size.y = 44
		for child: Node in _build_box.get_children():
			if child is Button:
				(child as Button).custom_minimum_size.y = 44
				(child as Button).add_theme_font_size_override("font_size", 13)
	else:
		var side_w: float = clampf(w * 0.27, 330.0, 430.0)
		var map_w: float = maxf(420.0, w - side_w - 18.0)
		# Le viewport de la carte reste dans l'écran ; son contenu peut être
		# plus haut, ce qui rend le défilement vertical réellement possible.
		var map_view_h: float = maxf(420.0, h - body_top - 8.0)
		var map_content_h: float = maxf(1300.0, map_view_h)
		_body_content.custom_minimum_size = Vector2(map_w + 18.0 + side_w, map_view_h)
		_map_scroll.position = Vector2.ZERO
		_map_scroll.size = Vector2(map_w, map_view_h)
		_map_scroll.custom_minimum_size = Vector2(map_w, map_view_h)
		_map_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
		_map_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_ALWAYS
		_map_panel.position = Vector2.ZERO
		_map_panel.size = Vector2(map_w, map_content_h)
		_map_panel.custom_minimum_size = Vector2(map_w, map_content_h)
		_side_panel.position = Vector2(map_w + 18.0, 0)
		_side_panel.size = Vector2(side_w, map_view_h)
		_side_panel.custom_minimum_size = Vector2(side_w, map_view_h)
		_legend_label.text = "Vert = territoire · Gris = neutre · Rouge = adverse · ⚔ = attaquable"
		_legend_label.position = Vector2(minf(260.0, map_w * 0.24), 16.0)
		_map_title_label.add_theme_font_size_override("font_size", 23)
		_legend_label.add_theme_font_size_override("font_size", 14 if map_w < 900.0 else 16)
		_side_title.add_theme_font_size_override("font_size", 23)
		_message.custom_minimum_size.y = 180
		_message.add_theme_font_size_override("font_size", 18)
		_attack.custom_minimum_size.y = 68
		_attack.add_theme_font_size_override("font_size", 23)
		_back_button.custom_minimum_size.y = 50
		for child: Node in _build_box.get_children():
			if child is Button:
				(child as Button).custom_minimum_size.y = 54
				(child as Button).add_theme_font_size_override("font_size", 16)

	var button_w: float = clampf(_map_panel.size.x * (0.23 if compact else 0.15), 70.0 if compact else 100.0, 196.0)
	var button_h: float = clampf(_map_panel.size.y * (0.13 if compact else 0.11), 48.0 if compact else 58.0, 76.0)
	for city_id: String in _city_buttons.keys():
		var btn: Button = _city_buttons[city_id]
		var p: Vector2 = CITY_POS[city_id]
		var px: float = clampf(p.x * _map_panel.size.x - button_w * 0.5, 0.0, _map_panel.size.x - button_w)
		var py_min: float = 34.0 if compact else 38.0
		var py_max: float = _map_panel.size.y - button_h - (30.0 if compact else 18.0)
		var py: float = clampf(p.y * _map_panel.size.y - button_h * 0.5, py_min, py_max)
		btn.position = Vector2(px, py)
		btn.size = Vector2(button_w, button_h)
		btn.custom_minimum_size = Vector2(button_w, button_h)
		btn.add_theme_font_size_override("font_size", 11 if compact else (14 if button_w < 140.0 else 18))
	if _side_scroll != null:
		_side_scroll.queue_sort()
	if _body_scroll != null:
		_body_scroll.queue_sort()


## Compteurs d'empire : villes contrôlées, production versée à chaque
## victoire, et objectif de campagne.
func _refresh_header() -> void:
	var owned: int = _conquest.get("owned", []).size()
	var total: int = _city_ids().size()
	var yld: Dictionary = ProgressionManager.conquest_empire_yield(_conquest)
	var parts: PackedStringArray = []
	for r: String in yld.keys():
		parts.append("%s +%d" % [r, int(yld[r])])
	var line: String = "Villes %d/%d" % [owned, total]
	if not parts.is_empty():
		line += "   ·   Production par victoire : " + " · ".join(parts)
	if ProgressionManager.conquest_campaign_won(_conquest):
		line += "   ·   ★ EMPIRE VICTORIEUX"
	elif ProgressionManager.conquest_empire_complete(_conquest):
		line += "   ·   ⚔ Tout Zimut est à vous : assailliez le Donjon du Roi Squelette !"
	_header.text = line

func _select_city(id: String) -> void:
	_selected_id = id
	var city: Dictionary = _city_meta(id)
	var owned: Array = _conquest.get("owned", ["capitale"])
	var conquered: bool = owned.has(id)
	var ravage: int = int(_conquest.get("ravage", {}).get(id, 0))
	_build_panel(id, conquered)
	_layout_responsive()
	if String(city["kind"]) == "capital":
		_message.text = "%s\n\n%s\n\nVotre territoire de départ, à l'abri des attaques." % [city["name"], city["desc"]]
		_attack.disabled = true
		_attack.text = "LANCER L'ASSAUT"
	elif conquered:
		var txt: String = "%s\n\n%s\n\n⚑ Territoire allié." % [city["name"], city["desc"]]
		if ravage > 0:
			txt += "\n\n⚠ PILLÉE : production gelée pendant %d bataille(s)." % ravage
		var builds: Array = _conquest.get("buildings", {}).get(id, [])
		if builds.size() > 0:
			var names: Array = []
			for b: String in builds:
				names.append(String(ProgressionManager.CONQUEST_BUILDINGS.get(b, {}).get("label", b)))
			txt += "\n\nBâtiments : %s" % ", ".join(PackedStringArray(names))
		var yld: Dictionary = {}
		for b: String in builds:
			for r: String in ProgressionManager.CONQUEST_BUILDINGS.get(b, {}).get("yield", {}).keys():
				yld[r] = int(yld.get(r, 0)) + int(ProgressionManager.CONQUEST_BUILDINGS[b]["yield"][r])
		if yld.size() > 0 and ravage == 0:
			var parts: Array = []
			for r: String in yld.keys():
				parts.append("%s +%d" % [r, int(yld[r])])
			txt += "\nProduction : %s" % " · ".join(PackedStringArray(parts))
		_message.text = txt
		_attack.disabled = true
		_attack.text = "LANCER L'ASSAUT"
	else:
		var kind: String = String(city["kind"])
		var prog: int = ProgressionManager.conquest_siege_progress(_conquest, id)
		var wave: int = ProgressionManager.conquest_siege_wave(_conquest, id)
		var attackable: bool = ProgressionManager.conquest_city_attackable(_conquest, id)
		if kind == "enemy":
			var left: int = ProgressionManager.CONQUEST_SIEGE_BATTLES - prog
			var wave_txt: String = ("\n\nSiège en cours : %d/%d — prochaine bataille : %s." % [prog, ProgressionManager.CONQUEST_SIEGE_BATTLES, "BOSS" if wave == ProgressionManager.CONQUEST_SIEGE_BATTLES else "mobs de champs"]) if prog > 0 else ""
			_message.text = "%s · %s · Niveau conseillé %d\n\n%s\n\n⚔ VILLE ADVERSE — siège en %d batailles : %d plateaux de mobs puis le BOSS du biome.%s" % [
				city["name"], ProgressionManager.biome_label(String(city["biome"])), int(city["level"]), city["desc"],
				ProgressionManager.CONQUEST_SIEGE_BATTLES, ProgressionManager.CONQUEST_SIEGE_BATTLES - 1, wave_txt]
		else:
			_message.text = "%s · %s · Niveau conseillé %d\n\n%s\n\n● VILLE NEUTRE — 1 bataille contre des mobs de champs suffit à la conquérir." % [
				city["name"], ProgressionManager.biome_label(String(city["biome"])), int(city["level"]), city["desc"]]
		if id == "donjon_roi" and not ProgressionManager.conquest_empire_complete(_conquest):
			_message.text += "\n\n★ Objectif final : verrouillé tant que tout Zimut n'est pas sous votre contrôle."
		if attackable:
			_attack.disabled = false
			if kind == "enemy":
				_attack.text = "LANCER LA BATAILLE %d/4 — %s" % [wave, "BOSS" if wave == ProgressionManager.CONQUEST_SIEGE_BATTLES else "MOBS"]
			else:
				_attack.text = "LANCER L'ASSAUT"
		else:
			_attack.disabled = true
			_attack.text = "HORS DE PORTÉE — CONQUÉREZ UNE VILLE RELIÉE"
			_message.text += "\n\n✖ Aucune route depuis votre territoire : conquérez d'abord une ville voisine."
	for other: String in _city_buttons.keys():
		var button: Button = _city_buttons[other]
		button.add_theme_stylebox_override("normal", _style(_city_color(other), GOLD if other == id else Color(0.5, 0.64, 0.46)))

## Panneau de construction de la ville sélectionnée : un bouton par
## bâtiment de ressources disponible, avec coûts, s'il n'est pas déjà bâti.
func _build_panel(city_id: String, conquered: bool) -> void:
	if _build_box == null:
		return
	for c: Node in _build_box.get_children():
		c.queue_free()
	if not conquered:
		return
	var res: Dictionary = _save.get("resources", {})
	var builds: Array = _conquest.get("buildings", {}).get(city_id, [])
	for key: String in ProgressionManager.CONQUEST_BUILDINGS.keys():
		var info: Dictionary = ProgressionManager.CONQUEST_BUILDINGS[key]
		var b := Button.new()
		var cost_parts: Array = []
		for r: String in info.get("cost", {}).keys():
			cost_parts.append("%s %d/%d" % [r, int(res.get(r, 0)), int(info["cost"][r])])
		cost_parts.append("%d or" % int(info.get("gold", 0)))
		b.text = "⚒ %s — %s" % [String(info["label"]), " · ".join(PackedStringArray(cost_parts))]
		b.custom_minimum_size.y = 54
		b.add_theme_font_size_override("font_size", 17)
		b.add_theme_color_override("font_color", TEXT)
		b.add_theme_stylebox_override("normal", _style(Color(0.13, 0.22, 0.27, 0.95), Color(0.55, 0.66, 0.5)))
		b.add_theme_stylebox_override("hover", _style(Color(0.18, 0.30, 0.34, 0.95), GOLD))
		if builds.has(key):
			b.text = "✓ %s (construit)" % String(info["label"])
			b.disabled = true
		else:
			b.pressed.connect(_on_build_pressed.bind(city_id, key))
		_build_box.add_child(b)

func _on_build_pressed(city_id: String, building: String) -> void:
	var err: String = ProgressionManager.conquest_build(_save, city_id, building)
	if err != "":
		_message.text = err
		return
	ProgressionManager.write_save(_slot, _save)
	_conquest = _save.get("conquest", {})
	_refresh_header()
	_select_city(city_id)

func _attack_selected_city() -> void:
	if not ProgressionManager.conquest_city_attackable(_conquest, _selected_id):
		return
	var city: Dictionary = _city_meta(_selected_id)
	_conquest["pending_city"] = _selected_id
	_conquest["pending_level"] = int(city["level"])
	_save["conquest"] = _conquest
	_save["campaign_mode"] = "conquest"
	_persist()
	GameManager.active_save = _save
	GameManager.active_slot = _slot
	GameManager.fight_biome = String(city["biome"])
	get_tree().change_scene_to_file("res://scenes/TeamSelection.tscn")

## Écran d'annexion : production versée, contre-attaque éventuelle et
## conseil de développement après une ville nouvellement conquise.
func _show_annexion_popup(city_id: String) -> void:
	var cname: String = ProgressionManager.conquest_city_name(city_id)
	var lines: Array = []
	var yld: Dictionary = _conquest.get("last_yield", {})
	var parts: PackedStringArray = []
	for r: String in yld.keys():
		parts.append("%s +%d" % [r, int(yld[r])])
	if parts.is_empty():
		lines.append("Aucune production pour l'instant : édifiez des bâtiments pour rapporter des ressources à chaque victoire.")
	else:
		lines.append("Production de votre empire versée : " + " · ".join(parts))
	var counter: String = String(_conquest.get("last_counterattack", ""))
	if counter != "":
		lines.append("⚠ CONTRE-ATTAQUE ! L'ennemi a pillé %s : production gelée %d bataille(s)." % [
			ProgressionManager.conquest_city_name(counter), ProgressionManager.CONQUEST_RAVAGE_BATTLES])
	if city_id == "donjon_roi":
		lines.append("★ CAMPAGNE TERMINÉE : le Roi Squelette est tombé, Zimut vous appartient ! Vous pouvez continuer en empire libre.")
	else:
		lines.append("Conseil : ouvrez %s sur la carte et édifiez un bâtiment de ressources." % cname)
	var title: String = "EMPIRE VICTORIEUX !" if city_id == "donjon_roi" else "VILLE ANNEXÉE !"
	var msg: String = "%s rejoint votre empire.\n\n%s" % [cname, "\n\n".join(PackedStringArray(lines))]
	_show_popup(title, msg)
	_show_counterattack_message()

## Popup plein écran (titre + message + bouton CONTINUER) posé sur cette
## carte : utilisé pour l'écran d'annexion après une victoire.
func _show_popup(title: String, message: String) -> void:
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.55)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(dim)
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _style(Color(0.98, 0.86, 0.45), Color(0.72, 0.58, 0.28)))
	add_child(panel)
	panel.set_anchors_and_offsets_preset(Control.PRESET_CENTER, Control.PRESET_MODE_MINSIZE, 0)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 12)
	panel.add_child(box)
	var t := Label.new()
	t.text = "⚑ %s" % title
	t.add_theme_font_size_override("font_size", 28)
	t.add_theme_color_override("font_color", Color(0.22, 0.15, 0.05))
	box.add_child(t)
	var m := Label.new()
	m.text = message
	m.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	m.custom_minimum_size.x = 900
	m.add_theme_font_size_override("font_size", 20)
	m.add_theme_color_override("font_color", Color(0.30, 0.22, 0.08))
	box.add_child(m)
	var ok := Button.new()
	ok.text = "CONTINUER"
	ok.custom_minimum_size = Vector2(300, 60)
	ok.add_theme_font_size_override("font_size", 22)
	ok.add_theme_color_override("font_color", Color(0.22, 0.15, 0.05))
	ok.add_theme_stylebox_override("normal", _style(Color(0.85, 0.72, 0.35), Color(0.72, 0.58, 0.28)))
	ok.pressed.connect(func() -> void:
		dim.queue_free()
		panel.queue_free())
	box.add_child(ok)

func _show_counterattack_message() -> void:
	var counter: String = String(_conquest.get("last_counterattack", ""))
	if counter != "" and _message != null:
		var cname: String = ProgressionManager.conquest_city_name(counter)
		_message.text = "⚠ CONTRE-ATTAQUE ! L'ennemi a pillé %s : production gelée %d bataille(s)." % [cname, ProgressionManager.CONQUEST_RAVAGE_BATTLES]

func _city_ids() -> Array:
	return ProgressionManager.CONQUEST_CITIES.keys()

func _city_meta(id: String) -> Dictionary:
	var info: Dictionary = ProgressionManager.CONQUEST_CITIES.get(id, {})
	var out: Dictionary = {
		"name": info.get("name", id),
		"kind": info.get("kind", "neutral"),
		"biome": info.get("biome", "Forêt"),
		"level": int(info.get("level", 10)),
		"desc": _city_desc(id, String(info.get("kind", "neutral"))),
	}
	return out

func _city_desc(id: String, kind: String) -> String:
	var descs := {
		"capitale": "Votre capitale de départ. Elle ne peut pas être perdue.",
		"clairiere": "Un village forestier peu défendu.",
		"vieille_tour": "Un avant-poste gobelin fortifié.",
		"pont_mousse": "Un passage stratégique au-dessus de la rivière.",
		"fort_racine": "La forteresse du chef de la forêt.",
		"hameau_pin": "Un hameau de bûcherons niché dans les Pics.",
		"garnison": "L'avant-poste militaire des Pics de Zimut.",
		"oasis": "Une oasis marchande au cœur des Dunes.",
		"tour_sable": "La place forte du désert, gardée par le Dragon.",
		"donjon_roi": "Le repaire du Roi Squelette. Objectif final de la campagne.",
		"village_brume": "Un village caché dans les brumes de la forêt.",
		"ruines_lierre": "Des ruines anciennes envahies par le lierre.",
		"abbaye_ronce": "Une abbaye isolée gardée par ses anciens serments.",
		"citadelle_ronce": "Une citadelle fortifiée qui contrôle les sous-bois.",
		"col_givre": "Un col étroit battu par les vents glacés.",
		"mine_cristal": "Une mine de cristaux précieux sous la montagne.",
		"bastion_orage": "Un bastion militaire au sommet des Pics.",
		"caravanserail": "Une halte marchande sur la route des dunes.",
		"observatoire": "Un observatoire oublié tourné vers le soleil.",
		"port_sable": "Un port fortifié qui contrôle les caravanes du désert.",
		"bois_lune": "Un bois ancien où la lumière filtre à travers les arbres argentés.",
		"sanctuaire_mousse": "Un sanctuaire oublié protégé par les esprits de la forêt.",
		"forge_givre": "Une forge naine alimentée par les feux sous la glace.",
		"pic_foudroyant": "Un sommet balayé par les orages et gardé par les sentinelles.",
		"marais_spectres": "Un marais brumeux où rôdent des silhouettes spectrales.",
		"fort_cendre": "Un fort désertique bâti dans la roche volcanique.",
		"temple_soleil": "Un temple ancien consacré au soleil du désert.",
		"citadelle_sable": "Une citadelle imprenable qui verrouille les routes du sud.",
	}
	return String(descs.get(id, "Ville de Zimut."))

## Couleur d'une ville selon son ÉTAT, pas son type d'origine :
##   vert  = conquise ou capitale (imprenable),
##   gris  = neutre (1 bataille de mobs),
##   rouge = adverse (siège : 3 batailles de mobs puis le boss).
func _city_color(city_id: String) -> Color:
	if _conquest.get("owned", []).has(city_id):
		return Color(0.16, 0.42, 0.24)
	match String(ProgressionManager.conquest_city_kind(city_id)):
		"capital": return Color(0.16, 0.42, 0.24)
		"neutral": return Color(0.34, 0.36, 0.38)
		_: return Color(0.52, 0.16, 0.14)

func _persist() -> void:
	_save["conquest"] = _conquest
	_save["campaign_mode"] = "conquest"
	ProgressionManager.write_save(_slot, _save)
	GameManager.active_save = _save
	GameManager.active_slot = _slot

func _back_to_save() -> void:
	_persist()
	get_tree().change_scene_to_file("res://scenes/SaveSlots.tscn")

func _style(bg: Color, border: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(2)
	s.set_corner_radius_all(12)
	s.content_margin_left = 8
	s.content_margin_right = 8
	s.content_margin_top = 6
	s.content_margin_bottom = 6
	return s

class _RouteLines:
	extends Control
	var conquest: Dictionary = {}
	var city_pos: Dictionary = {}
	func _draw() -> void:
		for pair: Array in ProgressionManager.CONQUEST_ROUTES:
			var a_id: String = String(pair[0])
			var b_id: String = String(pair[1])
			var a: Vector2 = city_pos.get(a_id, Vector2.ZERO)
			var b: Vector2 = city_pos.get(b_id, Vector2.ZERO)
			var owned: Array = conquest.get("owned", [])
			var open: bool = owned.has(a_id) and owned.has(b_id)
			var col: Color = Color(0.96, 0.75, 0.31, 0.95) if open else Color(0.79, 0.68, 0.43, 0.45)
			draw_line(Vector2(size.x * a.x, size.y * a.y), Vector2(size.x * b.x, size.y * b.y), col, 5.0 if open else 3.0, true)
