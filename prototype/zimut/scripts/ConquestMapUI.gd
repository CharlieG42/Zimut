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
## Emplacements des villes sur la carte peinte (coordonnées normalisées) : chaque ville
## est posée sur la région qui lui correspond (forêt, cimes, désert, Ronces, Rouages…).
const CITY_POS := {
	"capitale": Vector2(0.12, 0.28),
	"clairiere": Vector2(0.24, 0.20),
	"pont_mousse": Vector2(0.07, 0.43),
	"vieille_tour": Vector2(0.33, 0.15),
	"fort_racine": Vector2(0.27, 0.37),
	"sanctuaire_mousse": Vector2(0.22, 0.50),
	"bastion_orage": Vector2(0.13, 0.10),
	"pic_foudroyant": Vector2(0.26, 0.08),
	"hameau_pin": Vector2(0.41, 0.29),
	"col_givre": Vector2(0.47, 0.19),
	"garnison": Vector2(0.67, 0.24),
	"mine_cristal": Vector2(0.55, 0.31),
	"donjon_roi": Vector2(0.59, 0.09),
	"ruines_lierre": Vector2(0.36, 0.50),
	"abbaye_ronce": Vector2(0.54, 0.56),
	"citadelle_ronce": Vector2(0.47, 0.46),
	"village_brume": Vector2(0.37, 0.68),
	"bois_lune": Vector2(0.50, 0.75),
	"marais_spectres": Vector2(0.63, 0.85),
	"fort_cendre": Vector2(0.13, 0.62),
	"citadelle_sable": Vector2(0.18, 0.80),
	"oasis": Vector2(0.72, 0.40),
	"tour_sable": Vector2(0.85, 0.21),
	"observatoire": Vector2(0.66, 0.51),
	"temple_soleil": Vector2(0.79, 0.31),
	"caravanserail": Vector2(0.84, 0.55),
	"port_sable": Vector2(0.93, 0.46),
	"forge_givre": Vector2(0.86, 0.76),
	"atelier_cuivre": Vector2(0.91, 0.09),
	"citadelle_engrenages": Vector2(0.96, 0.25),
}
var _save: Dictionary = {}
var _slot: int = -1
var _conquest: Dictionary = {}
var _selected_id: String = "clairiere"
var _message: Label
var _threat_banner: Label
var _attack: Button
var _city_buttons: Dictionary = {}
var _city_labels: Dictionary = {}
var _city_sprite_cache: Dictionary = {}
var _side_art: TextureRect
var _build_box: VBoxContainer
var _header: Label
var _root: Control
var _body_scroll: ScrollContainer
var _body_content: Control
var _map_scroll: Control   # fenêtre de la carte (clip) : le panneau y est déplacé/zoomé à la main
var _pan: Vector2 = Vector2.ZERO
var _zoom_focus: Vector2 = Vector2.ZERO
var _zoom_inited: bool = false
var _halo_t: float = 0.0
var _map_panel: Panel
var _side_panel: PanelContainer
var _title_label: Label
var _subtitle_label: Label
var _legend_label: RichTextLabel
var _world_art: TextureRect = null
var _territory: ConquestMapLayers.TerritoryBaker = null
var _routes: ConquestMapLayers.Routes = null
var _challenge_label: Label
var _pulse_tween: Tween = null
var _map_title_label: Label
var _side_title: Label
var _back_button: Button
var _side_scroll: ScrollContainer
var _tab_city: VBoxContainer = null
var _tab_chron: VBoxContainer = null
var _tab_targets: VBoxContainer = null
var _details: Label
var _details_toggle: Button
## V64 : le détail de la ville (garnison, production, domination…) se replie pour garder
## « Lancer l'assaut » visible sans défiler ; le choix est gardé pendant la session.
static var details_collapsed: bool = false
var _tab_buttons: Array[Button] = []
var _chronicle_label: Label

# Capture le glissement directement sur toute la zone de carte, y compris
# au-dessus des boutons des villes. Le ScrollContainer seul ne reçoit pas
# toujours le mouvement tactile lorsque son enfant est un Button.
var _map_pointer_active: bool = false
var _map_pointer_index: int = -1
var _map_pointer_last: Vector2 = Vector2.ZERO
var _map_pointer_origin: Vector2 = Vector2.ZERO
var _map_dragged: bool = false
var _map_zoom: float = 1.0
var _target_map_zoom: float = 1.0
const MAP_ZOOM_SMOOTHING: float = 7.5
var _touch_positions: Dictionary = {}
var _pinch_start_distance: float = 0.0
var _pinch_start_zoom: float = 1.0
const MAP_ZOOM_MAX: float = 2.0
const MAP_ART := "res://assets/ui/conquest/conquest_world_map.jpg"
const MAP_FX := "res://assets/ui/conquest/conquest_world_fx.png"
const MAP_W: float = 1536.0
const PIN_SIZE := Vector2(96, 84)
const MAP_H: float = 1024.0

func _ready() -> void:
	set_process_input(true)
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
	# L'événement à trancher est posé en premier : les nouvelles et l'annexion
	# s'affichent par-dessus, puis le choix apparaît une fois celles-ci fermées.
	if not ProgressionManager.conquest_pending_event(_conquest).is_empty():
		_show_event_popup()
	if annexed != "":
		_conquest["just_annexed"] = ""
		_save["conquest"] = _conquest
		_persist()
		_show_annexion_popup(annexed)
	elif not (_conquest.get("news", []) as Array).is_empty():
		_show_popup("NOUVELLES DE L'EMPIRE", "\n\n".join(PackedStringArray(_conquest["news"])))
	else:
		_show_counterattack_message()
	_conquest["news"] = []
	_conquest["last_counterattack"] = ""
	_save["conquest"] = _conquest
	_persist()
	# V59 : Gultur présente les nouveautés de la Conquête (une seule fois chacune)
	# V60 : puis la carte vivante (routes, territoire, brouillard, offensives)
	Gultur.say(self, "conq_v59", Gultur.CONQ_V59, _side_panel,
		func() -> void: Gultur.say(self, "conq_carte", Gultur.CONQ_CARTE, _map_scroll))

func _build() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.34, 0.47, 0.49)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	# Surface agrandie selon le réglage « Taille du texte » (UiFit)
	var holder := Control.new()
	add_child(holder)
	UiFit.apply(holder, 1.0, Vector2(1300, 760))
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.offset_left = 28
	root.offset_right = -28
	root.offset_top = 20
	root.offset_bottom = -20
	holder.add_child(root)
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
	TouchScroll.install(_body_scroll)
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
	_map_scroll = Control.new()
	_map_scroll.name = "MapView"
	_map_scroll.position = Vector2.ZERO
	_map_scroll.clip_contents = true
	_map_scroll.mouse_filter = Control.MOUSE_FILTER_PASS
	_body_scroll.get_v_scroll_bar().custom_step = 18.0
	_body_content.add_child(_map_scroll)
	(_body_scroll.get_node("TouchScroll") as TouchScroll).exclude = _map_scroll

	var map := Panel.new()
	map.position = Vector2.ZERO
	map.size = Vector2(1536, 1024)
	map.add_theme_stylebox_override("panel", _style(PANEL, GOLD))
	_map_scroll.add_child(map)
	_map_panel = map

	# Fond de carte peint, animé par un shader (eau, lave, cristaux, nuages) et teinté par
	# le territoire de l'empire et le brouillard des terres inconnues (V60).
	var world_art := TextureRect.new()
	world_art.name = "ConquestWorldArtwork"
	world_art.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	world_art.texture = load(MAP_ART) as Texture2D
	world_art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	world_art.stretch_mode = TextureRect.STRETCH_SCALE
	world_art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	world_art.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	world_art.material = ConquestMapLayers.world_material(load(MAP_FX) as Texture2D, GfxQuality.low())
	map.add_child(world_art)
	_world_art = world_art
	_territory = ConquestMapLayers.TerritoryBaker.new()
	_territory.name = "TerritoryBaker"
	map.add_child(_territory)
	var wm: ShaderMaterial = world_art.material
	wm.set_shader_parameter("territory", _territory.get_texture())
	wm.set_shader_parameter("has_territory", 1.0)

	# Routes dessinées derrière les villes : pavées dans l'empire, pointillés animés
	# vers les villes attaquables, sentiers discrets ailleurs.
	_routes = ConquestMapLayers.Routes.new()
	_routes.name = "Routes"
	_routes.city_pos = CITY_POS
	_routes.animate = not GfxQuality.low()
	_routes.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	map.add_child(_routes)

	# Vie de la carte : navires, oiseaux, nuages.
	var ambient := ConquestMapLayers.Ambient.new()
	ambient.name = "Ambient"
	ambient.clouds = not GfxQuality.low()
	ambient.active = not GfxQuality.low()
	ambient.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	map.add_child(ambient)

	for city_id: String in _city_ids():
		var city: Dictionary = _city_meta(city_id)
		var btn := Button.new()
		btn.name = "City_" + city_id
		btn.text = ""
		btn.tooltip_text = "%s — %s" % [String(ProgressionManager.biome_label(String(city["biome"]))), String(city["desc"])]
		btn.add_theme_stylebox_override("normal", StyleBoxEmpty.new())
		btn.add_theme_stylebox_override("hover", StyleBoxEmpty.new())
		btn.add_theme_stylebox_override("pressed", StyleBoxEmpty.new())
		btn.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
		btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		var pin := ConquestMapLayers.Pin.new()
		pin.name = "CityPin"
		pin.animate = not GfxQuality.low()
		pin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		btn.add_child(pin)
		var nameplate := Label.new()
		nameplate.name = "CityNameplate"
		nameplate.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		nameplate.vertical_alignment = VERTICAL_ALIGNMENT_TOP
		nameplate.add_theme_constant_override("outline_size", 6)
		nameplate.add_theme_constant_override("line_spacing", -3)
		nameplate.add_theme_color_override("font_outline_color", Color(0.06, 0.04, 0.02, 0.92))
		nameplate.mouse_filter = Control.MOUSE_FILTER_IGNORE
		btn.add_child(nameplate)
		btn.pressed.connect(_on_city_pressed.bind(city_id))
		map.add_child(btn)
		_city_buttons[city_id] = btn
		_city_labels[city_id] = nameplate

	# Habillage fixe de la vue : vignette, titre et légende (ne bougent pas avec la carte).
	var vg := Gradient.new()
	vg.offsets = PackedFloat32Array([0.0, 0.62, 1.0])
	vg.colors = PackedColorArray([Color(0, 0, 0, 0), Color(0, 0, 0, 0.0), Color(0.02, 0.03, 0.05, 0.55)])
	var vt := GradientTexture2D.new()
	vt.gradient = vg
	vt.fill = GradientTexture2D.FILL_RADIAL
	vt.fill_from = Vector2(0.5, 0.5)
	vt.fill_to = Vector2(1.08, 1.08)
	vt.width = 128
	vt.height = 128
	var vignette := TextureRect.new()
	vignette.name = "Vignette"
	vignette.texture = vt
	vignette.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	vignette.stretch_mode = TextureRect.STRETCH_SCALE
	vignette.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	vignette.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_map_scroll.add_child(vignette)

	_map_title_label = Label.new()
	_map_title_label.text = "LE MONDE DE ZIMUT"
	_map_title_label.position = Vector2(12, 10)
	_map_title_label.add_theme_color_override("font_color", GOLD)
	_map_title_label.add_theme_stylebox_override("normal", _pill_style())
	_map_title_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_map_scroll.add_child(_map_title_label)

	_legend_label = RichTextLabel.new()
	_legend_label.bbcode_enabled = true
	_legend_label.fit_content = true
	_legend_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	_legend_label.scroll_active = false
	_legend_label.add_theme_color_override("default_color", TEXT)
	_legend_label.add_theme_stylebox_override("normal", _pill_style())
	_legend_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_map_scroll.add_child(_legend_label)

	var side := PanelContainer.new()
	side.position = Vector2(1340, 92)
	side.size = Vector2(430, 750)
	side.add_theme_stylebox_override("panel", _style(Color(0.10, 0.17, 0.21, 0.98), GOLD))
	_body_content.add_child(side)
	_side_panel = side

	_side_scroll = ScrollContainer.new()
	TouchScroll.install(_side_scroll)
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

	_threat_banner = Label.new()
	_threat_banner.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_threat_banner.add_theme_font_size_override("font_size", 16)
	_threat_banner.add_theme_color_override("font_color", Color(1.0, 0.88, 0.80))
	_threat_banner.add_theme_stylebox_override("normal", _style(Color(0.34, 0.10, 0.08, 0.96), Color(1.0, 0.45, 0.30)))
	box.add_child(_threat_banner)

	# V59 : le conseil est en deux onglets pour tenir à l'écran sans défiler :
	# « Ville » (illustration, situation, actions) et « Chronique » (nouvelles de l'empire).
	var tabs := HBoxContainer.new()
	tabs.add_theme_constant_override("separation", 6)
	box.add_child(tabs)
	_tab_city = VBoxContainer.new()
	_tab_city.add_theme_constant_override("separation", 12)
	box.add_child(_tab_city)
	_tab_targets = VBoxContainer.new()
	_tab_targets.add_theme_constant_override("separation", 8)
	_tab_targets.visible = false
	box.add_child(_tab_targets)
	_tab_chron = VBoxContainer.new()
	_tab_chron.add_theme_constant_override("separation", 10)
	_tab_chron.visible = false
	box.add_child(_tab_chron)
	for t: Array in [["⚑ VILLE", _tab_city], ["⚔ CIBLES", _tab_targets], ["✎ CHRONIQUE", _tab_chron]]:
		var tb := Button.new()
		tb.text = String(t[0])
		tb.toggle_mode = true
		tb.button_pressed = t[1] == _tab_city
		tb.custom_minimum_size = Vector2(0, 44)
		tb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tb.add_theme_font_size_override("font_size", 15)
		tb.add_theme_color_override("font_color", TEXT)
		tb.add_theme_stylebox_override("normal", _style(Color(0.12, 0.18, 0.22, 0.97), Color(0.42, 0.50, 0.46)))
		tb.add_theme_stylebox_override("pressed", _style(Color(0.24, 0.30, 0.22, 0.97), GOLD))
		tb.add_theme_stylebox_override("hover", _style(Color(0.18, 0.26, 0.28, 0.97), GOLD))
		tabs.add_child(tb)
		_tab_buttons.append(tb)
		var target: VBoxContainer = t[1]
		tb.pressed.connect(func() -> void: _show_tab(target))

	_side_art = TextureRect.new()
	_side_art.name = "SideCityArt"
	_side_art.custom_minimum_size = Vector2(0, 112)
	_side_art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_side_art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	_side_art.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_tab_city.add_child(_side_art)

	_message = Label.new()
	_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_message.add_theme_color_override("font_color", TEXT)
	_message.add_theme_font_size_override("font_size", 17)
	_tab_city.add_child(_message)

	_attack = Button.new()
	_attack.text = "LANCER L'ASSAUT"
	_attack.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_attack.custom_minimum_size.y = 68
	_attack.add_theme_font_size_override("font_size", 23)
	_attack.pressed.connect(_attack_selected_city)
	_style_button(_attack, Color(0.62, 0.20, 0.16), Color(1.0, 0.72, 0.42))
	_tab_city.add_child(_attack)

	_challenge_label = Label.new()
	_challenge_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_challenge_label.add_theme_font_size_override("font_size", 16)
	_challenge_label.add_theme_color_override("font_color", Color(0.80, 0.72, 1.0))
	_challenge_label.add_theme_stylebox_override("normal", _style(Color(0.13, 0.11, 0.24, 0.96), Color(0.62, 0.48, 0.95)))
	_challenge_label.visible = false
	_tab_city.add_child(_challenge_label)

	_build_box = VBoxContainer.new()
	_build_box.add_theme_constant_override("separation", 6)
	_tab_city.add_child(_build_box)

	_details_toggle = Button.new()
	_details_toggle.name = "DetailsToggle"
	_details_toggle.custom_minimum_size.y = 44
	_details_toggle.add_theme_font_size_override("font_size", 16)
	_details_toggle.add_theme_color_override("font_color", TEXT)
	_details_toggle.add_theme_stylebox_override("normal", _style(Color(0.12, 0.18, 0.22, 0.97), Color(0.42, 0.50, 0.46)))
	_details_toggle.add_theme_stylebox_override("hover", _style(Color(0.18, 0.26, 0.28, 0.97), GOLD))
	_details_toggle.pressed.connect(func() -> void:
		details_collapsed = not details_collapsed
		_apply_details_state())
	_tab_city.add_child(_details_toggle)
	_details = Label.new()
	_details.name = "CityDetails"
	_details.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_details.add_theme_color_override("font_color", TEXT)
	_details.add_theme_font_size_override("font_size", 16)
	_tab_city.add_child(_details)

	var targets_title := Label.new()
	targets_title.text = "PROCHAINES CIBLES"
	targets_title.add_theme_font_size_override("font_size", 18)
	targets_title.add_theme_color_override("font_color", GOLD)
	_tab_targets.add_child(targets_title)

	var chronicle_title := Label.new()
	chronicle_title.text = "CHRONIQUE RÉCENTE"
	chronicle_title.add_theme_font_size_override("font_size", 18)
	chronicle_title.add_theme_color_override("font_color", GOLD)
	_tab_chron.add_child(chronicle_title)

	_chronicle_label = Label.new()
	_chronicle_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_chronicle_label.custom_minimum_size.y = 104
	_chronicle_label.add_theme_font_size_override("font_size", 15)
	_chronicle_label.add_theme_color_override("font_color", TEXT)
	_chronicle_label.text = "Vos premières conquêtes apparaîtront ici."
	_tab_chron.add_child(_chronicle_label)

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	box.add_child(spacer)

	_back_button = Button.new()
	_back_button.text = "← MENU"
	_back_button.custom_minimum_size.y = 50
	_back_button.pressed.connect(_back_to_save)
	_style_button(_back_button, Color(0.13, 0.22, 0.27), Color(0.55, 0.66, 0.5))
	box.add_child(_back_button)

	_refresh_header()
	_select_city(_selected_id)
	_layout_responsive()

## Affiche l'onglet du conseil demandé (Ville / Chronique).
func _show_tab(target: VBoxContainer) -> void:
	var tabs: Array = [_tab_city, _tab_targets, _tab_chron]
	for i: int in range(tabs.size()):
		(tabs[i] as VBoxContainer).visible = tabs[i] == target
		if i < _tab_buttons.size():
			_tab_buttons[i].button_pressed = tabs[i] == target
	if _side_scroll != null:
		_side_scroll.scroll_vertical = 0


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
		var map_view_h: float = clampf(h * 0.52, 360.0, 470.0)
		var side_h: float = 600.0
		_body_content.custom_minimum_size = Vector2(viewport_w, map_view_h + 14.0 + side_h)
		_map_scroll.position = Vector2.ZERO
		_map_scroll.size = Vector2(viewport_w, map_view_h)
		_map_scroll.custom_minimum_size = Vector2(viewport_w, map_view_h)
		var map_content_h: float = MAP_H
		_side_panel.position = Vector2(0, map_view_h + 14.0)
		_side_panel.size = Vector2(viewport_w, side_h)
		_side_panel.custom_minimum_size = Vector2(viewport_w, side_h)
		_legend_label.text = "[color=#4fd27a]●[/color] Empire   [color=#b0b0a8]●[/color] Neutre   [color=#e0574a]●[/color] Adverse   [color=#ffd75e]➜[/color] Attaquable   [color=#c8ccd4]?[/color] Inconnu"
		_legend_label.position = Vector2(10, map_view_h - 38.0)
		_map_title_label.visible = false
		_legend_label.add_theme_font_size_override("normal_font_size", 12)
		_side_title.add_theme_font_size_override("font_size", 20)
		_message.custom_minimum_size.y = 84
		_message.add_theme_font_size_override("font_size", 15)
		_details.add_theme_font_size_override("font_size", 14)
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
		_body_content.custom_minimum_size = Vector2(map_w + 18.0 + side_w, map_view_h)
		_map_scroll.position = Vector2.ZERO
		_map_scroll.size = Vector2(map_w, map_view_h)
		_map_scroll.custom_minimum_size = Vector2(map_w, map_view_h)
		_side_panel.position = Vector2(map_w + 18.0, 0)
		_side_panel.size = Vector2(side_w, map_view_h)
		_side_panel.custom_minimum_size = Vector2(side_w, map_view_h)
		_legend_label.text = "[color=#4fd27a]●[/color] Empire   [color=#b0b0a8]●[/color] Neutre   [color=#e0574a]●[/color] Adverse   [color=#ffd75e]➜[/color] Attaquable   [color=#c8ccd4]?[/color] Inconnu"
		_map_title_label.visible = true
		_map_title_label.add_theme_font_size_override("font_size", 20)
		_map_title_label.position = Vector2(map_w - _map_title_label.get_combined_minimum_size().x - 12.0, map_view_h - 48.0)
		_legend_label.add_theme_font_size_override("normal_font_size", 14 if map_w < 900.0 else 16)
		# La légende suit le cartouche du titre (fond sombre) sans le chevaucher.
		_legend_label.position = Vector2(12, map_view_h - 44.0)
		_side_title.add_theme_font_size_override("font_size", 23)
		_message.custom_minimum_size.y = 110
		_message.add_theme_font_size_override("font_size", 18)
		_details.add_theme_font_size_override("font_size", 16)
		_attack.custom_minimum_size.y = 68
		_attack.add_theme_font_size_override("font_size", 23)
		_back_button.custom_minimum_size.y = 50
		for child: Node in _build_box.get_children():
			if child is Button:
				(child as Button).custom_minimum_size.y = 54
				(child as Button).add_theme_font_size_override("font_size", 16)

	# Le panneau complet (fond, routes, sprites et libellés) porte le zoom.
	# Les contrôles gardent donc leurs dimensions de base et suivent ensemble
	# la transformation du panneau, sans agrandir les villes isolément.
	_map_panel.size = Vector2(MAP_W, MAP_H)
	_map_panel.custom_minimum_size = Vector2.ZERO
	_clamp_zoom_and_pan()
	# Repères compacts : le point au sol (2/3 de la hauteur du bouton) tombe pile sur la ville peinte.
	for city_id: String in _city_buttons.keys():
		var is_cap: bool = city_id == "capitale"
		var bs: Vector2 = PIN_SIZE * (1.3 if is_cap else 1.0)
		var btn: Button = _city_buttons[city_id]
		var p: Vector2 = CITY_POS[city_id] * Vector2(MAP_W, MAP_H)
		btn.size = bs
		btn.custom_minimum_size = bs
		btn.position = p - Vector2(bs.x * 0.5, bs.y * 0.66)
		btn.pivot_offset = Vector2(bs.x * 0.5, bs.y * 0.66)
		var nameplate: Label = _city_labels[city_id]
		nameplate.position = Vector2(-30.0, bs.y * 0.66 + 2.0)
		nameplate.size = Vector2(bs.x + 60.0, 40.0)
		nameplate.add_theme_font_size_override("font_size", (14 if compact else 15) + (3 if is_cap else 0))
	if _side_scroll != null:
		_side_scroll.queue_sort()
	if _body_scroll != null:
		_body_scroll.queue_sort()


## Le geste est suivi au niveau de la scène pour rester actif même si le
## doigt commence sur un bouton de ville. Le seuil filtre les micro-mouvements
## involontaires ; une fois dépassé, on déplace le contenu dans le sens du doigt.
func _process(delta: float) -> void:
	_halo_t += delta
	if _map_panel == null or not is_instance_valid(_map_panel):
		return
	if not is_equal_approx(_map_zoom, _target_map_zoom):
		var weight: float = 1.0 - exp(-MAP_ZOOM_SMOOTHING * delta)
		var next: float = lerpf(_map_zoom, _target_map_zoom, weight)
		if absf(_target_map_zoom - next) < 0.002:
			next = _target_map_zoom
		# le point sous le doigt / la souris reste fixe pendant le zoom
		_pan = _zoom_focus - (_zoom_focus - _pan) * (next / _map_zoom)
		_map_zoom = next
		_clamp_zoom_and_pan()


## Zoom minimum : la carte entière couvre la fenêtre (on ne voit jamais de vide autour).
func _min_zoom() -> float:
	if _map_scroll == null:
		return 1.0
	return maxf(_map_scroll.size.x / MAP_W, _map_scroll.size.y / MAP_H)


## Borne zoom et décalage puis applique la transformation au panneau.
func _clamp_zoom_and_pan() -> void:
	if _map_scroll == null or _map_panel == null:
		return
	var zmin: float = _min_zoom()
	if not _zoom_inited and _map_scroll.size.x > 0.0:
		_zoom_inited = true
		_map_zoom = maxf(zmin * 1.12, 0.8)
		_target_map_zoom = _map_zoom
		_pan = _map_scroll.size * 0.5 - Vector2(0.30, 0.45) * Vector2(MAP_W, MAP_H) * _map_zoom
	_target_map_zoom = clampf(_target_map_zoom, zmin, maxf(MAP_ZOOM_MAX, zmin))
	_map_zoom = clampf(_map_zoom, zmin, maxf(MAP_ZOOM_MAX, zmin))
	var cw: float = MAP_W * _map_zoom
	var ch: float = MAP_H * _map_zoom
	_pan.x = clampf(_pan.x, minf(0.0, _map_scroll.size.x - cw), 0.0)
	_pan.y = clampf(_pan.y, minf(0.0, _map_scroll.size.y - ch), 0.0)
	_map_panel.scale = Vector2(_map_zoom, _map_zoom)
	_map_panel.position = _pan
	# Les villes se réduisent un peu quand on zoome (et se grossissent à peine en dézoomant)
	# pour que les plaques restent lisibles sans masquer la carte.
	var k: float = clampf(pow(_map_zoom, -0.6), 0.6, 1.2)
	for cid: String in _city_buttons.keys():
		var cb: Button = _city_buttons[cid]
		cb.scale = Vector2(k, k)


## Centre la fenêtre sur un point de la carte (coordonnées normalisées).
func _center_on(norm: Vector2) -> void:
	_pan = _map_scroll.size * 0.5 - norm * Vector2(MAP_W, MAP_H) * _map_zoom
	_clamp_zoom_and_pan()


func _input(event: InputEvent) -> void:
	if _map_scroll == null or not is_instance_valid(_map_scroll):
		return
	if event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch.pressed:
			_touch_positions[touch.index] = touch.position
			if _touch_positions.size() == 2:
				_map_pointer_active = false
				_map_dragged = true
				_pinch_start_distance = _pinch_distance()
				_pinch_start_zoom = _map_zoom
				_zoom_focus = _view_local(_pinch_center())
			else:
				_begin_map_pointer(touch.position, touch.index)
		else:
			_touch_positions.erase(touch.index)
			_end_map_pointer(touch.index)
			if _touch_positions.size() == 1:
				var remaining_index: int = int(_touch_positions.keys()[0])
				_begin_map_pointer(_touch_positions[remaining_index], remaining_index)
	elif event is InputEventScreenDrag:
		var drag := event as InputEventScreenDrag
		if _touch_positions.has(drag.index):
			_touch_positions[drag.index] = drag.position
		if _touch_positions.size() >= 2:
			var distance := _pinch_distance()
			if _pinch_start_distance > 0.0:
				_zoom_focus = _view_local(_pinch_center())
				_set_map_zoom(_pinch_start_zoom * distance / _pinch_start_distance, true)
			get_viewport().set_input_as_handled()
		elif _map_pointer_active and drag.index == _map_pointer_index:
			_update_map_pointer(drag.position)
	elif event is InputEventMouseButton:
		var mouse := event as InputEventMouseButton
		if mouse.button_index == MOUSE_BUTTON_LEFT:
			if mouse.pressed:
				_begin_map_pointer(mouse.position, -2)
			else:
				_end_map_pointer(-2)
		elif (mouse.button_index == MOUSE_BUTTON_WHEEL_UP or mouse.button_index == MOUSE_BUTTON_WHEEL_DOWN) and mouse.pressed:
			var lp: Vector2 = _view_local(mouse.position)
			if Rect2(Vector2.ZERO, _map_scroll.size).has_point(lp):
				_zoom_focus = lp
				_set_map_zoom(_target_map_zoom * (1.15 if mouse.button_index == MOUSE_BUTTON_WHEEL_UP else 1.0 / 1.15), true)
				get_viewport().set_input_as_handled()
	elif event is InputEventMouseMotion:
		var motion := event as InputEventMouseMotion
		if _map_pointer_active and _map_pointer_index == -2 and (motion.button_mask & MOUSE_BUTTON_MASK_LEFT) != 0:
			_update_map_pointer(motion.position)

func _pinch_distance() -> float:
	if _touch_positions.size() < 2:
		return 0.0
	var points: Array = _touch_positions.values()
	return Vector2(points[0]).distance_to(Vector2(points[1]))

func _pinch_center() -> Vector2:
	if _touch_positions.size() < 2:
		return Vector2.ZERO
	var points: Array = _touch_positions.values()
	return (Vector2(points[0]) + Vector2(points[1])) * 0.5

func _view_local(pos: Vector2) -> Vector2:
	return _map_scroll.get_global_transform_with_canvas().affine_inverse() * pos

func _set_map_zoom(value: float, keep_focus: bool = false) -> void:
	if not keep_focus:
		_zoom_focus = _map_scroll.size * 0.5
	_target_map_zoom = clampf(value, _min_zoom(), maxf(MAP_ZOOM_MAX, _min_zoom()))

func _begin_map_pointer(position: Vector2, pointer_index: int) -> void:
	# InputEventScreenTouch.position est en coordonnées viewport ; convertir
	# vers les coordonnées locales du ScrollContainer évite les écarts liés
	# au CanvasLayer / scaling Android.
	var local_pos: Vector2 = _map_scroll.get_global_transform_with_canvas().affine_inverse() * position
	if not Rect2(Vector2.ZERO, _map_scroll.size).has_point(local_pos):
		return
	# La barre reste manipulable directement, mais tout le reste du viewport
	# (fond, routes et boutons de villes) sert aussi de surface de glissement.
	_map_pointer_active = true
	_map_pointer_index = pointer_index
	_map_pointer_origin = position
	_map_pointer_last = position
	_map_dragged = false

func _update_map_pointer(position: Vector2) -> void:
	if not _map_pointer_active:
		return
	# Seuil faible pour reconnaître l'intention de glisser sans rendre les
	# clics sur les villes difficiles. Après ce seuil, la carte capte le geste.
	if not _map_dragged and position.distance_to(_map_pointer_origin) < 4.0:
		return
	_map_dragged = true
	# position en pixels écran ; la carte vit dans une surface éventuellement agrandie
	var delta: Vector2 = (position - _map_pointer_last) / maxf(0.01, _root.get_global_transform_with_canvas().get_scale().x)
	_pan += delta
	_clamp_zoom_and_pan()
	_map_pointer_last = position
	# Consommer le geste une fois le glissement confirmé pour empêcher un
	# bouton de ville de transformer le relâchement en sélection.
	get_viewport().set_input_as_handled()

func _end_map_pointer(pointer_index: int) -> void:
	if not _map_pointer_active or pointer_index != _map_pointer_index:
		return
	_map_pointer_active = false
	_map_pointer_index = -1
	if _map_dragged:
		# Laisser les Buttons traiter l'événement de relâchement avant de
		# réautoriser la sélection d'une ville.
		call_deferred("_clear_map_drag_state")

func _clear_map_drag_state() -> void:
	_map_dragged = false

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
	var income: int = ConquestSystem.total_income(_save)
	if income > 0:
		line += "   ·   Revenus +%d or" % income
	if not parts.is_empty():
		line += "   ·   Production par victoire : " + " · ".join(parts)
	var generals_alive: int = ConquestSystem.living_generals_count(_conquest)
	if generals_alive > 0:
		line += "   ·   ☠ %d %s du Roi Squelette en vie" % [generals_alive, "généraux" if generals_alive > 1 else "général"]
	if ProgressionManager.conquest_campaign_won(_conquest):
		line += "   ·   ★ EMPIRE VICTORIEUX"
	elif ProgressionManager.conquest_empire_complete(_conquest):
		line += "   ·   ⚔ Tout Zimut est à vous : assailliez le Donjon du Roi Squelette !"
	_header.text = line

func _select_city(id: String) -> void:
	if _tab_city != null and not _tab_city.visible:
		_show_tab(_tab_city)
	# Un glissement de carte ne doit jamais déclencher par erreur la sélection
	# de la ville sur laquelle le doigt a été relâché.
	if _map_dragged:
		return
	_selected_id = id
	var city: Dictionary = _city_meta(id)
	var owned: Array = _conquest.get("owned", ["capitale"])
	var conquered: bool = owned.has(id)
	var ravage: int = int(_conquest.get("ravage", {}).get(id, 0))
	var keep: int = 2    # paragraphes gardés dans l'en-tête ; le reste va sous « Détails »
	_build_panel(id, conquered)
	if _side_art != null:
		_side_art.texture = _city_sprite(id)
	_layout_responsive()
	if String(city["kind"]) == "capital":
		_message.text = Typo.fr("%s\n\n%s\n\nVotre territoire de départ, à l'abri des attaques.\n%s" % [city["name"], city["desc"], _city_status_text(id)])
		_show_challenge("")
		_attack.disabled = true
		_attack.text = "LANCER L'ASSAUT"
	elif conquered:
		var txt: String = "%s\n\n%s\n\n⚑ Territoire allié.\n%s" % [city["name"], city["desc"], _city_status_text(id)]
		if ConquestSystem.is_ruined(_conquest, id):
			txt += "\n\n⚒ RUINÉE (perdue puis reprise) : production gelée %d bataille(s) — réparable pour %d or." % [int(_conquest.get("ruin", {}).get(id, 0)), ConquestSystem.RUIN_REPAIR_GOLD]
		if ravage > 0:
			txt += "\n\n⚠ PILLÉE : production gelée pendant %d bataille(s)." % ravage
		var builds: Array = _conquest.get("buildings", {}).get(id, [])
		if builds.size() > 0:
			var names: Array = []
			for b: String in builds:
				names.append("%s %s" % [String(ProgressionManager.CONQUEST_BUILDINGS.get(b, {}).get("label", b)), "★".repeat(ConquestSystem.building_level(_conquest, id, b))])
			txt += "\n\nBâtiments (%d/%d) : %s" % [builds.size(), ConquestSystem.building_slots(_conquest, id), ", ".join(PackedStringArray(names))]
		if ConquestSystem.has_wonder(_conquest, id):
			txt += "\n★ Merveille : %s" % String(ConquestSystem.wonder_for(String(city["biome"]))["label"])
		var yld: Dictionary = ProgressionManager.conquest_city_building_yield(_conquest, id)
		if yld.size() > 0 and ravage == 0:
			var parts: Array = []
			for r: String in yld.keys():
				parts.append("%s +%d" % [r, int(yld[r])])
			txt += "\nProduction : %s" % " · ".join(PackedStringArray(parts))
		var city_trait: Dictionary = ProgressionManager.conquest_city_trait(id, _conquest)
		if String(city_trait.get("label", "")) != "" and ravage == 0:
			var tp: Array = []
			for r: String in city_trait.get("yield", {}).keys():
				tp.append("%s +%d" % [r, int(city_trait["yield"][r])])
			txt += "\nSpécialité — %s : %s" % [String(city_trait["label"]), " · ".join(PackedStringArray(tp))]
		if ConquestSystem.drill_defense(_conquest) > 0:
			txt += "\n⚑ Manœuvres du Chancelier : +%d défense pendant %d bataille(s)." % [ConquestSystem.drill_defense(_conquest), int(_conquest.get("drill", 0))]
		if ConquestSystem.roadworks_yield(_conquest).size() > 0:
			txt += "\n⚑ Routes entretenues du Chancelier : encore %d bataille(s)." % int(_conquest.get("roadworks", 0))
		_message.text = Typo.fr(txt)
		_show_challenge("")
		_attack.disabled = true
		_attack.text = "LANCER L'ASSAUT"
	else:
		var kind: String = String(city["kind"])
		keep = 3
		var prog: int = ProgressionManager.conquest_siege_progress(_conquest, id)
		var wave: int = ProgressionManager.conquest_siege_wave(_conquest, id)
		var attackable: bool = ProgressionManager.conquest_city_attackable(
			_conquest, id, _save.get("adventure", {}))
		# Aide au siège : niveau moyen de l'équipe contre le niveau conseillé.
		var advice: String = ""
		if attackable:
			var avg: int = ConquestSystem.team_avg_level(_save)
			advice = "\nVotre équipe : niveau moyen %d — %s" % [avg, String(ConquestSystem.assault_advice(avg, int(city["level"]))["text"])]
		if kind == "enemy":
			var left: int = ProgressionManager.CONQUEST_SIEGE_BATTLES - prog
			var wave_txt: String = ("\n\nSiège en cours : %d/%d — prochaine bataille : %s." % [prog, ProgressionManager.CONQUEST_SIEGE_BATTLES, "BOSS" if wave == ProgressionManager.CONQUEST_SIEGE_BATTLES else "mobs de champs"]) if prog > 0 else ""
			var general_txt: String = ""
			var gname: String = ConquestSystem.general_of(_conquest, id)
			if gname != "":
				general_txt = "\n\n☠ FORTERESSE DU GÉNÉRAL %s — le vaincre en personne à la 4e bataille calmera sa région (%s)." % [gname.to_upper(), ConquestSystem.general_region(id)]
			_message.text = "%s · %s · Niveau conseillé %d%s\n\n%s\n\n⚔ VILLE ADVERSE — siège en %d batailles : %d plateaux de mobs puis le BOSS du biome.%s%s" % [
				city["name"], ProgressionManager.biome_label(String(city["biome"])), int(city["level"]), advice, city["desc"],
				ProgressionManager.CONQUEST_SIEGE_BATTLES, ProgressionManager.CONQUEST_SIEGE_BATTLES - 1, wave_txt, general_txt]
		else:
			var dip_txt: String = ""
			if kind == "neutral" and attackable:
				var dcost: Dictionary = ProgressionManager.conquest_diplomacy_cost(_conquest, id)
				var dparts: Array = ["%d or" % int(dcost.get("gold", 0))]
				for r: String in dcost.get("res", {}).keys():
					dparts.append("%s %d" % [r, int(dcost["res"][r])])
				dip_txt = "\n\n☮ DIPLOMATIE : cette ville peut aussi rejoindre l'empire par négociation (%s) — le bouton « NÉGOCIER » ci-dessous." % " · ".join(PackedStringArray(dparts))
				var dcd: int = ConquestSystem.diplomacy_cooldown(_conquest)
				if dcd > 0:
					dip_txt += " Émissaires indisponibles encore %d victoire(s)." % dcd
			_message.text = "%s · %s · Niveau conseillé %d%s\n\n%s\n\n● VILLE NEUTRE — 1 bataille contre des mobs de champs suffit à la conquérir.%s" % [
				city["name"], ProgressionManager.biome_label(String(city["biome"])), int(city["level"]), advice, city["desc"], dip_txt]
		if id == "donjon_roi" and not ProgressionManager.conquest_empire_complete(_conquest):
			_message.text += "\n\n★ Objectif final : verrouillé tant que tout Zimut n'est pas sous votre contrôle."
		# Reconquête ennemie : la garnison adverse grossit avec le temps.
		var eg: int = ProgressionManager.conquest_enemy_garrison(_conquest, id)
		if eg > 0:
			_message.text += "\n\n⚑ Garnison adverse : %d soldat(s) (+%d niveau(x) de bataille). Attendre la durcit encore." % [eg, ProgressionManager.conquest_enemy_garrison_bonus(_conquest, id)]
		_show_challenge(id if attackable else "")
		if attackable:
			_attack.disabled = false
			if kind == "enemy":
				_attack.text = "LANCER LA BATAILLE %d/4 — %s" % [wave, "BOSS" if wave == ProgressionManager.CONQUEST_SIEGE_BATTLES else "MOBS"]
			else:
				_attack.text = "LANCER L'ASSAUT"
		else:
			_attack.disabled = true
			_attack.text = "HORS DE PORTÉE — CONQUÉREZ UNE VILLE RELIÉE"
			var way: Array = ConquestSystem.path_to(owned, ProgressionManager.CONQUEST_ROUTES, id)
			if way.size() > 1:
				var names: Array = []
				for w: Variant in way:
					names.append(ProgressionManager.conquest_city_name(String(w)))
				_message.text += "\n\n⇢ Chemin à ouvrir (%d étapes) : %s." % [way.size(), " → ".join(PackedStringArray(names))]
			else:
				_message.text += "\n\n✖ Aucune route depuis votre territoire : conquérez d'abord une ville voisine."
	# Rendre visible la progression de domination régionale au moment où
	# le joueur compare les cibles : les bonus existent déjà dans l'économie.
	var biome_summary: String = _biome_control_summary(String(city["biome"]))
	if biome_summary != "":
		_message.text += "\n\n" + biome_summary
	_message.text = Typo.fr(_message.text)
	_split_message(_message.text, keep)
	_refresh_nameplates()
	_pulse_selected(id)
	_refresh_chronicle()

## Sépare le texte du conseil : l'en-tête reste visible, le reste passe sous « Détails ».
func _split_message(full: String, keep: int) -> void:
	if _details == null or _details_toggle == null:
		return
	var paras: PackedStringArray = full.split("\n\n")
	_message.text = "\n\n".join(paras.slice(0, keep))
	_details.text = "\n\n".join(paras.slice(keep))
	_apply_details_state()

func _apply_details_state() -> void:
	var has: bool = _details.text.strip_edges() != ""
	_details_toggle.visible = has
	_details.visible = has and not details_collapsed
	_details_toggle.text = "▸ DÉTAILS DE LA VILLE" if details_collapsed else "▾ DÉTAILS DE LA VILLE"

## Onglet « Cibles » : villes attaquables, de la plus accessible à la plus dure.
func _refresh_targets(ids: Array) -> void:
	if _tab_targets == null:
		return
	while _tab_targets.get_child_count() > 1:
		var old: Node = _tab_targets.get_child(1)
		_tab_targets.remove_child(old)
		old.queue_free()
	var sorted_ids: Array = ids.duplicate()
	sorted_ids.sort_custom(func(a: String, b: String) -> bool:
		return int(_city_meta(a)["level"]) < int(_city_meta(b)["level"]))
	if sorted_ids.is_empty():
		var none := Label.new()
		none.text = "Aucune cible à portée : conquérez ou révélez une ville voisine."
		none.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		none.add_theme_font_size_override("font_size", 15)
		none.add_theme_color_override("font_color", TEXT)
		_tab_targets.add_child(none)
		return
	var avg: int = ConquestSystem.team_avg_level(_save)
	for id: String in sorted_ids:
		var meta: Dictionary = _city_meta(id)
		var rw: Dictionary = ProgressionManager.conquest_city_reward(id)
		var parts: Array = []
		if int(rw.get("gold", 0)) > 0:
			parts.append("%d or" % int(rw["gold"]))
		for r: String in rw.get("resources", {}).keys():
			parts.append("%s %d" % [r, int(rw["resources"][r])])
		var kind_txt: String = "adverse · siège %d/%d" % [ProgressionManager.conquest_siege_progress(_conquest, id), ProgressionManager.CONQUEST_SIEGE_BATTLES] if String(meta["kind"]) == "enemy" else "neutre · 1 bataille"
		var adv: Dictionary = ConquestSystem.assault_advice(avg, int(meta["level"]))
		var b := Button.new()
		b.name = "Target_" + id
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		b.custom_minimum_size.y = 84
		b.add_theme_font_size_override("font_size", 15)
		b.add_theme_color_override("font_color", TEXT)
		var edge: Color = {"ok": Color(0.45, 0.85, 0.50), "risky": Color(0.95, 0.75, 0.30), "weak": Color(0.90, 0.40, 0.35)}[String(adv["verdict"])]
		b.add_theme_stylebox_override("normal", _style(Color(0.12, 0.18, 0.22, 0.97), edge))
		b.add_theme_stylebox_override("hover", _style(Color(0.18, 0.26, 0.28, 0.97), GOLD))
		b.text = Typo.fr("%s — niv. %d\n%s · %s\nButin : %s" % [
			String(meta["name"]), int(meta["level"]), kind_txt, String(adv["text"]), String(rw.get("name", "—")) + (" (" + ", ".join(PackedStringArray(parts)) + ")" if not parts.is_empty() else "")])
		b.pressed.connect(func() -> void:
			_select_city(id)
			_center_on(CITY_POS[id]))
		_tab_targets.add_child(b)

## Ville révélée mais encore séparée de l'empire : « vue de loin ».
func _is_far(city_id: String) -> bool:
	if _conquest.get("owned", []).has(city_id) or city_id == "capitale":
		return false
	var st: String = _pin_state(city_id)
	if st == "unknown" or st == "attackable" or st == "lost":
		return false
	return not ConquestSystem.path_to(_conquest.get("owned", []), ProgressionManager.CONQUEST_ROUTES, city_id).is_empty()

## Panneau latéral d'une ville alliée : un seul bouton pour « entrer dans la ville »
## (la gestion complète — bâtiments, garnison, gouverneur — vit dans CityScreenUI).
func _build_panel(city_id: String, conquered: bool) -> void:
	if _build_box == null:
		return
	for c: Node in _build_box.get_children():
		c.queue_free()
	if not conquered:
		# Ville neutre attaquable : la voie diplomatique en plus des armes.
		if String(_city_meta(city_id)["kind"]) == "neutral" \
				and ProgressionManager.conquest_city_attackable(_conquest, city_id, _save.get("adventure", {})):
			var dip := Button.new()
			dip.name = "NegotiateButton"
			dip.text = "☮ NÉGOCIER L'ANNEXION"
			dip.custom_minimum_size.y = 54
			dip.add_theme_font_size_override("font_size", 18)
			dip.add_theme_color_override("font_color", TEXT)
			dip.add_theme_stylebox_override("normal", _style(Color(0.30, 0.26, 0.16, 0.97), GOLD))
			dip.add_theme_stylebox_override("hover", _style(Color(0.38, 0.34, 0.22, 0.97), GOLD))
			dip.pressed.connect(_negotiate_city.bind(city_id))
			_build_box.add_child(dip)
			if not Gultur.should_show("conq_v59"):
				Gultur.say(self, "conq_diplomatie", Gultur.CONQ_DIPLOMATIE, dip)
		return
	var b := Button.new()
	b.name = "EnterCityButton"
	b.text = "⌂ ENTRER DANS LA VILLE"
	b.custom_minimum_size.y = 60
	b.add_theme_font_size_override("font_size", 20)
	b.add_theme_color_override("font_color", TEXT)
	b.add_theme_stylebox_override("normal", _style(Color(0.22, 0.32, 0.18, 0.97), GOLD))
	b.add_theme_stylebox_override("hover", _style(Color(0.30, 0.42, 0.24, 0.97), GOLD))
	b.pressed.connect(_open_city_screen.bind(city_id))
	_build_box.add_child(b)
	var miss := Button.new()
	miss.name = "MissionsButton"
	miss.text = "⚑ MISSIONS DES LIEUTENANTS"
	miss.custom_minimum_size.y = 54
	miss.add_theme_font_size_override("font_size", 18)
	miss.add_theme_color_override("font_color", TEXT)
	miss.add_theme_stylebox_override("normal", _style(Color(0.18, 0.26, 0.34, 0.97), GOLD))
	miss.add_theme_stylebox_override("hover", _style(Color(0.24, 0.34, 0.44, 0.97), GOLD))
	miss.pressed.connect(_show_mission_picker)
	_build_box.add_child(miss)
	# Ville ruinée (perdue puis reprise) : réparer pour reprendre la production.
	if ConquestSystem.is_ruined(_conquest, city_id):
		var rep := Button.new()
		rep.name = "RepairButton"
		rep.text = "⚒ RÉPARER LA VILLE — %d or" % ConquestSystem.RUIN_REPAIR_GOLD
		rep.custom_minimum_size.y = 54
		rep.add_theme_font_size_override("font_size", 18)
		rep.add_theme_color_override("font_color", TEXT)
		rep.add_theme_stylebox_override("normal", _style(Color(0.34, 0.24, 0.14, 0.97), GOLD))
		rep.add_theme_stylebox_override("hover", _style(Color(0.42, 0.32, 0.20, 0.97), GOLD))
		rep.disabled = int(_save.get("gold", 0)) < ConquestSystem.RUIN_REPAIR_GOLD
		rep.pressed.connect(_repair_city.bind(city_id))
		_build_box.add_child(rep)
		if not Gultur.should_show("conq_v59"):
			Gultur.say(self, "conq_ruine", Gultur.CONQ_RUINE, rep)

## Clic sur une ville de la carte : sélection ; si elle nous appartient, on y entre.
func _on_city_pressed(city_id: String) -> void:
	if _map_dragged:
		return
	_select_city(city_id)
	if (_conquest.get("owned", ["capitale"]) as Array).has(city_id):
		_open_city_screen(city_id)

## Ouvre l'écran de la ville (thème de sa nation) par-dessus la carte.
func _open_city_screen(city_id: String) -> void:
	if get_node_or_null("CityScreen") != null:
		return
	var ui := CityScreenUI.new()
	ui.name = "CityScreen"
	add_child(ui)
	var kind: String = String(_city_meta(city_id).get("kind", "neutral"))
	ui.open(_save, _slot, city_id, _city_sprite(city_id), _city_desc(city_id, kind))
	ui.closed.connect(func() -> void:
		ui.queue_free()
		_conquest = _save.get("conquest", {})
		_persist()
		_refresh_header()
		_select_city(city_id))

func _on_build_pressed(city_id: String, building: String) -> void:
	var err: String = ProgressionManager.conquest_build(_save, city_id, building)
	if err != "":
		_message.text = Typo.fr(err)
		return
	ProgressionManager.write_save(_slot, _save)
	_conquest = _save.get("conquest", {})
	_refresh_header()
	_select_city(city_id)

## Résumé de gestion d'une ville alliée : niveau, garnison, gouverneur, défense, revenus.
func _city_status_text(id: String) -> String:
	var lvl: int = ConquestSystem.city_level(_conquest, id)
	var hero: String = ConquestSystem.hero_of(_conquest, id)
	var lines: PackedStringArray = []
	lines.append("\n%s (niveau %d/%d)" % [ConquestSystem.level_name(lvl), lvl, ConquestSystem.MAX_LEVEL])
	lines.append("♜ Garnison : %d/%d soldats" % [ConquestSystem.troops(_conquest, id), ConquestSystem.garrison_cap(_conquest, id)])
	if hero != "":
		lines.append("♞ Gouverneur : %s (niv. %d) — %s" % [hero, ConquestSystem.hero_level(_save, hero), ConquestSystem.governor_text(hero)])
	else:
		lines.append("♞ Aucun gouverneur")
	lines.append("Défense : %d  ·  Revenu : +%d or par victoire" % [ConquestSystem.defense(_save, id), ConquestSystem.city_income(_save, id)])
	var th: Dictionary = ConquestSystem.threat(_conquest)
	if String(th.get("city", "")) == id:
		lines.append("⚠ OFFENSIVE dans %d bataille(s) : force ennemie %d" % [int(th["eta"]), int(th["power"])])
	return "\n".join(lines)

func _mgmt_button(text: String, enabled: bool, color: Color, action: Callable) -> void:
	var b := Button.new()
	b.text = text
	b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	b.custom_minimum_size.y = 54
	b.add_theme_font_size_override("font_size", 17)
	b.add_theme_color_override("font_color", TEXT)
	b.add_theme_stylebox_override("normal", _style(color, Color(0.75, 0.68, 0.40)))
	b.add_theme_stylebox_override("hover", _style(color.lightened(0.12), GOLD))
	b.disabled = not enabled
	if enabled:
		b.pressed.connect(action)
	_build_box.add_child(b)

## Boutons d'évolution : amélioration, recrutement, gouverneur.
func _build_management(city_id: String) -> void:
	var res: Dictionary = _save.get("resources", {})
	var gold: int = int(_save.get("gold", 0))
	var lvl: int = ConquestSystem.city_level(_conquest, city_id)
	var ravaged: bool = ProgressionManager._is_city_ravaged(_conquest, city_id)
	if lvl >= ConquestSystem.MAX_LEVEL:
		_mgmt_button("★ %s — niveau maximum" % ConquestSystem.level_name(lvl), false, Color(0.2, 0.3, 0.2), Callable())
	else:
		var cost: Dictionary = ConquestSystem.upgrade_cost(_conquest, city_id)
		var parts: Array = ["%d or" % int(cost["gold"])]
		var ok: bool = gold >= int(cost["gold"]) and not ravaged
		for r: String in cost["res"].keys():
			parts.append("%s %d/%d" % [r, int(res.get(r, 0)), int(cost["res"][r])])
			ok = ok and int(res.get(r, 0)) >= int(cost["res"][r])
		_mgmt_button("⬆ %s → %s — %s" % [ConquestSystem.level_name(lvl), ConquestSystem.level_name(lvl + 1), " · ".join(PackedStringArray(parts))],
			ok, Color(0.22, 0.30, 0.16), _on_upgrade_pressed.bind(city_id))
	if city_id != "capitale":
		var room: int = ConquestSystem.garrison_cap(_conquest, city_id) - ConquestSystem.troops(_conquest, city_id)
		_mgmt_button("♜ RECRUTER +1 soldat — %d or" % ConquestSystem.TROOP_COST, room > 0 and gold >= ConquestSystem.TROOP_COST,
			Color(0.20, 0.26, 0.34), _on_recruit_pressed.bind(city_id, 1))
		if room > 1:
			_mgmt_button("♜ REMPLIR LA GARNISON (+%d) — %d or" % [room, room * ConquestSystem.TROOP_COST], gold >= room * ConquestSystem.TROOP_COST,
				Color(0.20, 0.26, 0.34), _on_recruit_pressed.bind(city_id, room))
	var hero: String = ConquestSystem.hero_of(_conquest, city_id)
	if hero != "":
		_mgmt_button("♞ RAPPELER %s (gouverneur)" % hero.to_upper(), true, Color(0.32, 0.22, 0.30), _on_recall_pressed.bind(city_id))
	else:
		_mgmt_button("♞ NOMMER UN GOUVERNEUR", true, Color(0.30, 0.22, 0.34), _show_governor_picker.bind(city_id))

func _after_management(city_id: String) -> void:
	ProgressionManager.write_save(_slot, _save)
	_conquest = _save.get("conquest", {})
	_refresh_header()
	_select_city(city_id)

func _on_upgrade_pressed(city_id: String) -> void:
	var err: String = ProgressionManager.conquest_upgrade_city(_save, city_id)
	_after_management(city_id)
	if err != "":
		_message.text = Typo.fr(err)

func _on_recruit_pressed(city_id: String, n: int) -> void:
	var err: String = ProgressionManager.conquest_recruit(_save, city_id, n)
	_after_management(city_id)
	if err != "":
		_message.text = Typo.fr(err)

func _on_recall_pressed(city_id: String) -> void:
	ProgressionManager.conquest_recall_hero(_save, city_id)
	_after_management(city_id)

## Choix du héros gouverneur : un héros en poste n'est plus disponible pour les assauts.
func _show_governor_picker(city_id: String) -> void:
	var vp: Vector2 = get_viewport().get_visible_rect().size
	var dim := ColorRect.new()
	dim.name = "GovernorPicker"
	dim.color = Color(0.015, 0.035, 0.055, 0.82)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(dim)
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _style(Color(0.10, 0.17, 0.22, 0.99), GOLD))
	panel.custom_minimum_size = Vector2(minf(660.0, vp.x - 40.0), 0)
	_center_panel(panel)
	dim.add_child(panel)
	var outer := VBoxContainer.new()
	outer.add_theme_constant_override("separation", 8)
	panel.add_child(outer)
	var title := Label.new()
	title.text = "GOUVERNEUR DE %s" % ProgressionManager.conquest_city_name(city_id).to_upper()
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", GOLD)
	outer.add_child(title)
	var hint := Label.new()
	hint.text = "Un gouverneur défend la ville et la fait prospérer, mais ne combat plus en assaut."
	hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hint.add_theme_font_size_override("font_size", 14)
	hint.add_theme_color_override("font_color", TEXT)
	outer.add_child(hint)
	var sc := ScrollContainer.new()
	TouchScroll.install(sc)
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	sc.custom_minimum_size.y = minf(300.0, maxf(160.0, vp.y - 190.0))
	outer.add_child(sc)
	var list := VBoxContainer.new()
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list.add_theme_constant_override("separation", 6)
	sc.add_child(list)
	for classe: String in ProgressionManager.CLASS_ORDER:
		var elsewhere: String = ConquestSystem.hero_city(_conquest, classe)
		var on_mission: Dictionary = ConquestSystem.hero_on_mission(_conquest, classe)
		var b := Button.new()
		b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		b.custom_minimum_size.y = 52
		b.add_theme_font_size_override("font_size", 16)
		var line: String = "%s — niv. %d · %s" % [classe, ConquestSystem.hero_level(_save, classe), ConquestSystem.governor_text(classe)]
		if elsewhere != "":
			line = "%s — déjà en poste à %s" % [classe, ProgressionManager.conquest_city_name(elsewhere)]
			b.disabled = true
		elif not on_mission.is_empty():
			line = "%s — en mission « %s » (%d bataille(s) restante(s))" % [classe,
				ConquestSystem.mission_label(String(on_mission.get("type", ""))), int(on_mission.get("eta", 0))]
			b.disabled = true
		b.text = line
		if not b.disabled:
			b.pressed.connect(func() -> void:
				dim.queue_free()
				ProgressionManager.conquest_assign_hero(_save, city_id, classe)
				_after_management(city_id))
		list.add_child(b)
	var cancel := Button.new()
	cancel.text = "ANNULER"
	cancel.custom_minimum_size.y = 46
	cancel.pressed.connect(func() -> void: dim.queue_free())
	outer.add_child(cancel)

## Missions de lieutenance : envoyer un héros libre en mission de 3 batailles
## (escorte, cartographie, prospection) ou rappeler une mission en cours.
func _show_mission_picker() -> void:
	if not Gultur.should_show("conq_v59"):
		Gultur.say(self, "conq_missions", Gultur.CONQ_MISSIONS, null)
	var vp: Vector2 = get_viewport().get_visible_rect().size
	var dim := ColorRect.new()
	dim.name = "MissionPicker"
	dim.color = Color(0.015, 0.035, 0.055, 0.82)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(dim)
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _style(Color(0.10, 0.17, 0.22, 0.99), GOLD))
	panel.custom_minimum_size = Vector2(minf(680.0, vp.x - 40.0), 0)
	_center_panel(panel)
	dim.add_child(panel)
	var outer := VBoxContainer.new()
	outer.add_theme_constant_override("separation", 8)
	panel.add_child(outer)
	var title := Label.new()
	title.text = "MISSIONS DES LIEUTENANTS"
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title.add_theme_font_size_override("font_size", 22)
	title.add_theme_color_override("font_color", GOLD)
	outer.add_child(title)
	var hint := Label.new()
	hint.text = "Un héros libre part en mission de 3 batailles : il ne combat ni ne gouverne pendant ce temps. À son retour : récompense… ou complication."
	hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hint.add_theme_font_size_override("font_size", 14)
	hint.add_theme_color_override("font_color", TEXT)
	outer.add_child(hint)
	var sc := ScrollContainer.new()
	TouchScroll.install(sc)
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	sc.custom_minimum_size.y = minf(360.0, maxf(200.0, vp.y - 200.0))
	outer.add_child(sc)
	var list := VBoxContainer.new()
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list.add_theme_constant_override("separation", 6)
	sc.add_child(list)
	var missions: Dictionary = ConquestSystem.missions(_conquest)
	for classe: String in ProgressionManager.CLASS_ORDER:
		var job: Dictionary = missions.get(classe, {})
		var header := Label.new()
		header.text = classe
		header.add_theme_font_size_override("font_size", 18)
		header.add_theme_color_override("font_color", GOLD)
		list.add_child(header)
		if not job.is_empty():
			var running := Button.new()
			running.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			running.text = "⚑ En mission « %s » — %d bataille(s) restante(s)\nRAPPELER (sans récompense)" % [
					ConquestSystem.mission_label(String(job.get("type", ""))), int(job.get("eta", 0))]
			running.custom_minimum_size.y = 58
			running.add_theme_font_size_override("font_size", 15)
			running.pressed.connect(func() -> void:
				dim.queue_free()
				ProgressionManager.conquest_abort_mission(_save, classe)
				_after_management(_selected_id))
			list.add_child(running)
			continue
		var elsewhere: String = ConquestSystem.hero_city(_conquest, classe)
		if elsewhere != "":
			var busy := Label.new()
			busy.text = "Gouverneur de %s" % ProgressionManager.conquest_city_name(elsewhere)
			busy.add_theme_font_size_override("font_size", 14)
			busy.add_theme_color_override("font_color", TEXT.darkened(0.2))
			list.add_child(busy)
			continue
		for type_id: String in ConquestSystem.mission_types():
			var b := Button.new()
			b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			b.text = "⚑ %s\n%s" % [ConquestSystem.mission_label(type_id), ConquestSystem.mission_text(type_id)]
			b.custom_minimum_size.y = 52
			b.add_theme_font_size_override("font_size", 14)
			b.pressed.connect(func() -> void:
				dim.queue_free()
				var err: String = ProgressionManager.conquest_send_mission(_save, classe, type_id)
				_after_management(_selected_id)
				if err != "":
					_message.text = Typo.fr(err))
			list.add_child(b)
	var cancel := Button.new()
	cancel.text = "ANNULER"
	cancel.custom_minimum_size.y = 46
	cancel.pressed.connect(func() -> void: dim.queue_free())
	outer.add_child(cancel)

## Événement de campagne à trancher : un bouton par choix (grisé si l'or manque).
func _show_event_popup() -> void:
	var ev: Dictionary = ProgressionManager.conquest_pending_event(_conquest)
	if ev.is_empty():
		return
	var vp: Vector2 = get_viewport().get_visible_rect().size
	var dim := ColorRect.new()
	dim.name = "EventPopup"
	dim.color = Color(0.015, 0.035, 0.055, 0.82)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(dim)
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _style(Color(0.12, 0.17, 0.24, 0.99), Color(0.62, 0.48, 0.95)))
	panel.custom_minimum_size = Vector2(minf(680.0, vp.x - 40.0), 0)
	_center_panel(panel)
	dim.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	panel.add_child(box)
	var title := Label.new()
	title.text = "✦ %s" % String(ev.get("title", "ÉVÉNEMENT"))
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title.add_theme_font_size_override("font_size", 24)
	title.add_theme_color_override("font_color", Color(0.85, 0.76, 1.0))
	box.add_child(title)
	var text := Label.new()
	text.text = String(ev.get("text", ""))
	text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	text.add_theme_font_size_override("font_size", 18)
	text.add_theme_color_override("font_color", TEXT)
	box.add_child(text)
	var gold: int = int(_save.get("gold", 0))
	for o: Dictionary in ev.get("options", []):
		var b := Button.new()
		b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		b.text = String(o.get("label", ""))
		b.custom_minimum_size.y = 56
		b.add_theme_font_size_override("font_size", 17)
		b.disabled = gold < int(o.get("gold", 0))
		var oid: String = String(o.get("id", ""))
		b.pressed.connect(func() -> void: _resolve_event_choice(dim, box, oid))
		box.add_child(b)
	if bool(ev.get("chancellor", false)):
		# V59 : l'audience peut attendre (elle reviendra à la prochaine ouverture de la carte)
		var later := Button.new()
		later.name = "LaterButton"
		later.text = "⌛ Plus tard — le Chancelier patientera"
		later.custom_minimum_size.y = 48
		later.add_theme_font_size_override("font_size", 16)
		later.pressed.connect(func() -> void: dim.queue_free())
		box.add_child(later)
		if not Gultur.should_show("conq_v59"):
			Gultur.say(self, "conq_chancelier", Gultur.CONQ_CHANCELIER, panel)

func _resolve_event_choice(dim: Control, box: VBoxContainer, option_id: String) -> void:
	var out: String = ProgressionManager.conquest_resolve_event(_save, option_id)
	if out == "":
		return
	_persist()
	_conquest = _save.get("conquest", {})
	_refresh_header()
	_select_city(_selected_id)
	for c: Node in box.get_children():
		c.queue_free()
	var done := Label.new()
	done.text = out
	done.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	done.add_theme_font_size_override("font_size", 20)
	done.add_theme_color_override("font_color", TEXT)
	box.add_child(done)
	var ok := Button.new()
	ok.text = "CONTINUER"
	ok.custom_minimum_size.y = 52
	ok.pressed.connect(func() -> void: dim.queue_free())
	box.add_child(ok)

func _attack_selected_city() -> void:
	if not ProgressionManager.conquest_city_attackable(
			_conquest, _selected_id, _save.get("adventure", {})):
		return
	_show_assault_prep()

## Choix tactique facultatif avant l'assaut. Le coût est payé une seule fois,
## puis l'effet est transmis au combat et consommé à sa résolution.
func _show_assault_prep() -> void:
	var city: Dictionary = _city_meta(_selected_id)
	var dim := ColorRect.new()
	dim.name = "AssaultPrepOverlay"
	dim.color = Color(0.015, 0.035, 0.055, 0.78)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(dim)
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _style(Color(0.10, 0.17, 0.22, 0.99), GOLD))
	panel.custom_minimum_size = Vector2(620, 0)
	_center_panel(panel)
	dim.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	panel.add_child(box)
	var title := Label.new()
	title.text = "PRÉPARER L'ASSAUT — %s" % String(city["name"]).to_upper()
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	title.add_theme_font_size_override("font_size", 25)
	title.add_theme_color_override("font_color", GOLD)
	box.add_child(title)
	var intro := Label.new()
	intro.text = "Choisis une approche, ou pars sans dépenser de ressources."
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	intro.add_theme_font_size_override("font_size", 17)
	intro.add_theme_color_override("font_color", TEXT)
	box.add_child(intro)
	var ch: Dictionary = ProgressionManager.conquest_challenge_for(_save, _selected_id)
	if not ch.is_empty():
		var chl := Label.new()
		chl.text = "◆ Défi facultatif : %s  →  %s" % [String(ch["label"]), _challenge_reward_text(ch)]
		chl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		chl.add_theme_font_size_override("font_size", 16)
		chl.add_theme_color_override("font_color", Color(0.80, 0.72, 1.0))
		box.add_child(chl)
	var resources: Dictionary = _save.get("resources", {})
	var gold: int = int(_save.get("gold", 0))
	var wood: int = int(resources.get("Bois", 0))
	var iron: int = int(resources.get("Fer", 0))
	var leather: int = int(resources.get("Cuir", 0))
	var scout := Button.new()
	scout.text = "🔎 ÉCLAIREURS — 25 or\nRéduit le niveau des ennemis de 1"
	scout.custom_minimum_size.y = 66
	scout.add_theme_font_size_override("font_size", 18)
	scout.disabled = gold < 25
	scout.pressed.connect(func() -> void:
		dim.queue_free()
		_choose_assault_tactic("scouts"))
	box.add_child(scout)
	var sabotage := Button.new()
	sabotage.text = "🧨 SABOTAGE — 12 Bois + 8 Fer\nRéduit les PV et l'attaque ennemis de 15 %"
	sabotage.custom_minimum_size.y = 66
	sabotage.add_theme_font_size_override("font_size", 18)
	sabotage.disabled = wood < 12 or iron < 8
	sabotage.pressed.connect(func() -> void:
		dim.queue_free()
		_choose_assault_tactic("sabotage"))
	box.add_child(sabotage)
	var supply := Button.new()
	supply.text = "📦 RAVITAILLEMENT — 15 or + 6 Cuir\nRéduit l'attaque ennemie de 10 %"
	supply.custom_minimum_size.y = 66
	supply.add_theme_font_size_override("font_size", 18)
	supply.disabled = gold < 15 or leather < 6
	supply.pressed.connect(func() -> void:
		dim.queue_free()
		_choose_assault_tactic("supply"))
	box.add_child(supply)
	var none := Button.new()
	none.text = "⚔ PARTIR SANS PRÉPARATION"
	none.custom_minimum_size.y = 58
	none.add_theme_font_size_override("font_size", 18)
	none.pressed.connect(func() -> void:
		dim.queue_free()
		_choose_assault_tactic("none"))
	box.add_child(none)
	# V59 plans d'assaut : blocus et infiltration ne déclenchent pas de combat,
	# ils font avancer le siège d'une vague sans verser de sang (sièges ennemis).
	if String(city["kind"]) == "enemy" \
			and ProgressionManager.conquest_siege_wave(_conquest, _selected_id) < ProgressionManager.CONQUEST_SIEGE_BATTLES:
		var plans_head := Label.new()
		plans_head.text = "─ PLANS D'ASSAUT (sans combat) ─"
		plans_head.add_theme_font_size_override("font_size", 16)
		plans_head.add_theme_color_override("font_color", GOLD)
		box.add_child(plans_head)
		var blocus := Button.new()
		blocus.text = "⛓ BLOCUS — %d or\nSaute une vague sans combat ; 35 %% de représailles (pillage)" % ProgressionManager.conquest_plan_cost("blocus")
		blocus.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		blocus.custom_minimum_size.y = 62
		blocus.add_theme_font_size_override("font_size", 17)
		blocus.disabled = gold < ProgressionManager.conquest_plan_cost("blocus")
		blocus.pressed.connect(func() -> void:
			dim.queue_free()
			_apply_plan("blocus"))
		box.add_child(blocus)
		var infiltr := Button.new()
		infiltr.text = "🗡 INFILTRATION — %d or\nL'Assassin libre saborde une vague de l'intérieur ; il revient à la prochaine victoire" % ProgressionManager.conquest_plan_cost("infiltration")
		infiltr.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		infiltr.custom_minimum_size.y = 62
		infiltr.add_theme_font_size_override("font_size", 17)
		infiltr.disabled = gold < ProgressionManager.conquest_plan_cost("infiltration") \
			or not ProgressionManager.conquest_infiltration_ready(_conquest)
		infiltr.pressed.connect(func() -> void:
			dim.queue_free()
			_apply_plan("infiltration"))
		box.add_child(infiltr)
	var cancel := Button.new()
	cancel.text = "ANNULER"
	cancel.custom_minimum_size.y = 48
	cancel.pressed.connect(func() -> void: dim.queue_free())
	box.add_child(cancel)

## Diplomatie : annexion négociée d'une ville neutre (or + ressource).
func _negotiate_city(city_id: String) -> void:
	var err: String = ProgressionManager.conquest_negotiate_city(_save, city_id)
	if err != "":
		_message.text = Typo.fr(err)
		return
	_conquest = _save.get("conquest", {})
	_persist()
	_refresh_header()
	_select_city(city_id)
	_show_annexion_popup(city_id)

## Ruine & reconstruction : réparer une ville ruinée (production gelée sinon).
func _repair_city(city_id: String) -> void:
	var err: String = ProgressionManager.conquest_repair_city(_save, city_id)
	if err != "":
		_message.text = Typo.fr(err)
		return
	_conquest = _save.get("conquest", {})
	_persist()
	_refresh_header()
	_select_city(city_id)
	_message.text = Typo.fr("⚒ %s est réparée : sa production reprend." % ProgressionManager.conquest_city_name(city_id))

## Plan d'assaut sans combat (blocus / infiltration) : le siège avance d'une
## vague, la carte se rafraîchit, aucun combat n'est lancé.
func _apply_plan(plan: String) -> void:
	var err: String = ProgressionManager.conquest_apply_plan(_save, _selected_id, plan)
	if err != "":
		_message.text = Typo.fr(err)
		return
	_conquest = _save.get("conquest", {})
	_persist()
	_refresh_header()
	_select_city(_selected_id)
	if not (_conquest.get("news", []) as Array).is_empty():
		_show_popup("NOUVELLES DE L'EMPIRE", "\n\n".join(PackedStringArray(_conquest["news"])))
		_conquest["news"] = []
		_save["conquest"] = _conquest
		_persist()

func _choose_assault_tactic(tactic: String) -> void:
	# Les coûts sont validés et débités par ProgressionManager, également
	# utilisé par les tests de gameplay.
	var payment_error: String = ProgressionManager.conquest_pay_assault_tactic(_save, tactic)
	if payment_error != "":
		_message.text = Typo.fr(payment_error)
		return
	var city: Dictionary = _city_meta(_selected_id)
	_conquest["pending_city"] = _selected_id
	_conquest["pending_level"] = int(city["level"])
	_conquest["pending_tactic"] = tactic
	_save["conquest"] = _conquest
	_save["campaign_mode"] = "conquest"
	_persist()
	GameManager.active_save = _save
	GameManager.active_slot = _slot
	GameManager.fight_biome = String(city["biome"])
	get_tree().change_scene_to_file("res://scenes/TeamSelection.tscn")

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
	var city_reward: Dictionary = _conquest.get("last_city_reward", {})
	if String(city_reward.get("city", "")) == city_id:
		var reward_parts: PackedStringArray = []
		var reward_resources: Dictionary = city_reward.get("resources", {})
		for resource: String in reward_resources.keys():
			reward_parts.append("%s +%d" % [resource, int(reward_resources[resource])])
		var reward_gold: int = int(city_reward.get("gold", 0))
		if reward_gold > 0:
			reward_parts.append("%d or" % reward_gold)
		lines.append("🎁 Récompense unique — %s : %s." % [
			String(city_reward.get("name", "Butin de conquête")),
			" · ".join(reward_parts)])
	var income: int = int(_conquest.get("last_income", 0))
	if income > 0:
		lines.append("Revenus des villes : +%d or." % income)
	if String(_conquest.get("retaken", "")) == city_id:
		lines.append("⚑ Ville reprise à l'ennemi : sa garnison est à reconstituer.")
		_conquest["retaken"] = ""
	for n: String in _conquest.get("news", []):
		lines.append(n)
	if city_id == "donjon_roi":
		var score0: Dictionary = ProgressionManager.conquest_legend_score(_save)
		_show_epilogue(score0, ProgressionManager.conquest_legend_ending(score0, _conquest))
		var score: Dictionary = score0
		var ending: Dictionary = ProgressionManager.conquest_legend_ending(score, _conquest)
		lines.append("★ CAMPAGNE TERMINÉE : le Roi Squelette est tombé !")
		lines.append("")
		for l: String in ProgressionManager.conquest_epilogue(score, ending).split("\n"):
			lines.append(l)
		lines.append("")
		lines.append("Vous pouvez continuer en empire libre : le monde reste à vous.")
	else:
		lines.append("Conseil : ouvrez %s pour y bâtir, recruter une garnison ou nommer un gouverneur." % cname)
	var title: String = "EMPIRE VICTORIEUX !" if city_id == "donjon_roi" else "VILLE ANNEXÉE !"
	var msg: String = "%s rejoint votre empire.\n\n%s" % [cname, "\n\n".join(PackedStringArray(lines))]
	_show_popup(title, msg)

## V59 — Écran de fin de campagne : couleurs de la fin obtenue, score de Légende détaillé en barres,
## texte de l'épilogue. Posé par-dessus le popup d'annexion (qui reste à lire en dessous).
const ENDING_COLORS := {"heros": [Color(0.20, 0.12, 0.04), Color(1.0, 0.80, 0.32)],
	"marchand": [Color(0.04, 0.16, 0.16), Color(0.45, 0.92, 0.80)], "bastion": [Color(0.08, 0.10, 0.18), Color(0.62, 0.74, 1.0)]}

func _show_epilogue(score: Dictionary, ending: Dictionary) -> void:
	var cols: Array = ENDING_COLORS.get(String(ending.get("id", "heros")), ENDING_COLORS["heros"])
	var bg: Color = cols[0]
	var acc: Color = cols[1]
	var dim := ColorRect.new()
	dim.name = "Epilogue"
	dim.color = Color(bg.r, bg.g, bg.b, 0.97)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	dim.modulate.a = 0.0
	add_child(dim)
	var centre := CenterContainer.new()
	centre.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.add_child(centre)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 14)
	box.custom_minimum_size.x = minf(1100.0, get_viewport().get_visible_rect().size.x - 80.0)
	centre.add_child(box)
	var crown := Label.new()
	crown.text = "★  LE ROI SQUELETTE EST TOMBÉ  ★"
	crown.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	crown.add_theme_font_size_override("font_size", 24)
	crown.add_theme_color_override("font_color", acc.lightened(0.2))
	box.add_child(crown)
	var t := Label.new()
	t.text = String(ending.get("title", ""))
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	t.add_theme_font_size_override("font_size", 62)
	t.add_theme_color_override("font_color", acc)
	t.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.7))
	t.add_theme_constant_override("outline_size", 10)
	box.add_child(t)
	var txt := Label.new()
	txt.text = String(ending.get("text", ""))
	txt.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	txt.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	txt.add_theme_font_size_override("font_size", 22)
	txt.add_theme_color_override("font_color", Color(0.94, 0.92, 0.86))
	box.add_child(txt)
	var total: int = ProgressionManager.conquest_legend_total(score)
	var tot := Label.new()
	tot.text = "%d points de Légende" % total
	tot.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tot.add_theme_font_size_override("font_size", 30)
	tot.add_theme_color_override("font_color", acc.lightened(0.3))
	box.add_child(tot)
	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 14)
	grid.add_theme_constant_override("v_separation", 8)
	box.add_child(grid)
	var labels := {"villes": "Villes", "niveaux": "Développement", "gouverneurs": "Gouverneurs", "pierres": "Pierres", "diplomatie": "Diplomatie", "ruines": "Ruines"}
	var top: float = 1.0
	for k: String in labels.keys():
		top = maxf(top, absf(float(score.get(k, 0))))
	for k2: String in labels.keys():
		var v: int = int(score.get(k2, 0))
		var l := Label.new()
		l.text = String(labels[k2])
		l.custom_minimum_size.x = 200
		l.add_theme_font_size_override("font_size", 20)
		l.add_theme_color_override("font_color", Color(0.9, 0.9, 0.86))
		grid.add_child(l)
		var bar := ProgressBar.new()
		bar.show_percentage = false
		bar.custom_minimum_size = Vector2(520, 22)
		bar.max_value = top
		bar.value = absf(float(v))
		var fill := StyleBoxFlat.new()
		fill.bg_color = acc if v >= 0 else Color(0.85, 0.35, 0.30)
		fill.set_corner_radius_all(6)
		var back := StyleBoxFlat.new()
		back.bg_color = Color(1, 1, 1, 0.08)
		back.set_corner_radius_all(6)
		bar.add_theme_stylebox_override("fill", fill)
		bar.add_theme_stylebox_override("background", back)
		grid.add_child(bar)
		var n := Label.new()
		n.text = "%+d" % v
		n.add_theme_font_size_override("font_size", 20)
		n.add_theme_color_override("font_color", acc if v >= 0 else Color(1.0, 0.55, 0.5))
		grid.add_child(n)
	var ok := Button.new()
	ok.text = "CONTINUER EN EMPIRE LIBRE"
	ok.custom_minimum_size = Vector2(420, 64)
	ok.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	ok.add_theme_font_size_override("font_size", 22)
	ok.add_theme_stylebox_override("normal", _style(bg.lightened(0.15), acc))
	ok.add_theme_stylebox_override("hover", _style(bg.lightened(0.25), acc))
	ok.pressed.connect(func() -> void: dim.queue_free())
	box.add_child(ok)
	var tw: Tween = create_tween()
	tw.tween_property(dim, "modulate:a", 1.0, 0.6)
	Gultur.say(self, "conq_legende", Gultur.CONQ_LEGENDE, null)


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
	# Un CenterContainer plein écran centre toujours la fenêtre, quelle que soit sa taille
	# (posé directement sur le CanvasLayer, le panneau restait coincé en haut à gauche).
	var centre := CenterContainer.new()
	centre.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	centre.mouse_filter = Control.MOUSE_FILTER_IGNORE
	dim.add_child(centre)
	centre.add_child(panel)
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
	m.custom_minimum_size.x = minf(900.0, get_viewport().get_visible_rect().size.x - 80.0)
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
		_message.text = Typo.fr("⚠ CONTRE-ATTAQUE ! L'ennemi a pillé %s : production gelée %d bataille(s)." % [cname, ProgressionManager.CONQUEST_RAVAGE_BATTLES])

## Nom d'une ville sous son repère : court, l'état est porté par le médaillon.
func _nameplate_text(city_id: String) -> String:
	var cname: String = String(_city_meta(city_id)["name"])
	var owned: bool = _conquest.get("owned", []).has(city_id)
	var th: Dictionary = ConquestSystem.threat(_conquest)
	var alert: String = "⚠ " if String(th.get("city", "")) == city_id else ""
	if owned:
		if ProgressionManager._is_city_ravaged(_conquest, city_id):
			return "%s%s\nPILLÉE" % [alert, cname]
		if ConquestSystem.is_ruined(_conquest, city_id):
			return "%s%s\nRUINÉE" % [alert, cname]
		return alert + cname
	if (_conquest.get("lost", []) as Array).has(city_id):
		return "%s\nÀ reprendre" % cname
	if _is_far(city_id):
		var steps: int = ConquestSystem.path_to(owned_list(), ProgressionManager.CONQUEST_ROUTES, city_id).size()
		return "%s\nà %d étapes" % [cname, steps]
	return cname

func owned_list() -> Array:
	return _conquest.get("owned", [])

## Couleur du nom d'une ville selon son état.
func _nameplate_color(city_id: String) -> Color:
	match _pin_state(city_id):
		"capital": return Color(1.0, 0.88, 0.48)
		"owned": return Color(0.82, 1.0, 0.82)
		"attackable": return Color(1.0, 0.90, 0.58)
		"enemy": return Color(1.0, 0.72, 0.66)
		"lost": return Color(1.0, 0.60, 0.55)
		"unknown": return Color(0.84, 0.86, 0.90)
	return Color(0.93, 0.92, 0.87)

func _is_unknown(city_id: String) -> bool:
	var revealed_cities: Array = _save.get("adventure", {}).get("revealed_cities", [])
	return (not _conquest.get("owned", []).has(city_id)) and (not revealed_cities.is_empty()) \
		and (not revealed_cities.has(city_id)) \
		and not ProgressionManager.conquest_city_adjacent_to_empire(_conquest, city_id)

## État d'un repère : capital / owned / lost / unknown / attackable / enemy / neutral.
func _pin_state(city_id: String) -> String:
	if city_id == "capitale":
		return "capital"
	if _conquest.get("owned", []).has(city_id):
		return "owned"
	if _is_unknown(city_id):
		return "unknown"
	if (_conquest.get("lost", []) as Array).has(city_id):
		return "lost"
	if ProgressionManager.conquest_city_attackable(_conquest, city_id, _save.get("adventure", {})):
		return "attackable"
	return "enemy" if String(ProgressionManager.conquest_city_kind(city_id)) == "enemy" else "neutral"

## Met à jour repères, routes et territoires d'après l'état de la campagne.
func _refresh_map_state() -> void:
	var owned: Array = _conquest.get("owned", [])
	var attackable: Array = []
	var unknown: Array = []
	var bake: Array = []
	var th: Dictionary = ConquestSystem.threat(_conquest)
	var threat_city: String = String(th.get("city", ""))
	for id: String in _city_buttons.keys():
		var st: String = _pin_state(id)
		var enemy_kind: bool = String(ProgressionManager.conquest_city_kind(id)) == "enemy"
		if st == "attackable" or (st == "lost" and ProgressionManager.conquest_city_attackable(_conquest, id, _save.get("adventure", {}))):
			attackable.append(id)
		if st == "unknown":
			unknown.append(id)
		var code: float = ConquestMapLayers.STATE_NEUTRAL
		if st == "owned" or st == "capital":
			code = ConquestMapLayers.STATE_OWNED
		elif st == "unknown":
			code = ConquestMapLayers.STATE_UNKNOWN
		elif enemy_kind or st == "lost":
			code = ConquestMapLayers.STATE_ENEMY
		bake.append({"pos": CITY_POS[id], "state": code})
		var pin: ConquestMapLayers.Pin = (_city_buttons[id] as Button).get_node("CityPin")
		pin.state = st
		pin.enemy_kind = enemy_kind
		pin.accent = _city_border_color(id)
		pin.selected = id == _selected_id
		var far: bool = _is_far(id)
		pin.far = far
		pin.general = ConquestSystem.general_of(_conquest, id) != "" and st != "unknown"
		pin.threatened = id == threat_city
		pin.smoke = st == "lost" or (owned.has(id) and (ProgressionManager._is_city_ravaged(_conquest, id) or ConquestSystem.is_ruined(_conquest, id)))
		pin.locked = id == "donjon_roi" and not ProgressionManager.conquest_empire_complete(_conquest)
		pin.siege = 0 if owned.has(id) else ProgressionManager.conquest_siege_progress(_conquest, id)
		pin.siege_max = ProgressionManager.CONQUEST_SIEGE_BATTLES
		pin.level = ConquestSystem.city_level(_conquest, id) if owned.has(id) else 0
		pin.queue_redraw()
		var lbl: Label = _city_labels[id]
		lbl.text = _nameplate_text(id)
		lbl.add_theme_color_override("font_color", _nameplate_color(id))
		# Noms au-delà de la frontière : contour plus épais pour rester lisibles sur le brouillard.
		lbl.add_theme_constant_override("outline_size", 9 if (st == "unknown" or far) else 6)
	if _routes != null:
		_routes.owned = owned
		_routes.attackable = attackable
		_routes.unknown = unknown
		_routes.threat_city = threat_city
		_routes.threat_from = _threat_origin(threat_city)
		_routes.threat_progress = 1.0 - float(int(th.get("eta", 0))) / float(ConquestSystem.THREAT_ETA + 1)
		_routes.queue_redraw()
	if _territory != null:
		_territory.bake(bake)
	_refresh_targets(attackable)

## D'où vient la colonne ennemie : une ville voisine hors de l'empire (forteresse de
## préférence), sinon la plus proche.
func _threat_origin(target: String) -> String:
	if target == "" or not CITY_POS.has(target):
		return ""
	var owned: Array = _conquest.get("owned", [])
	var best: String = ""
	var best_score: float = INF
	for id: String in CITY_POS.keys():
		if owned.has(id) or id == target:
			continue
		var d: float = (CITY_POS[id] as Vector2).distance_to(CITY_POS[target])
		var linked: bool = false
		for pair: Array in ProgressionManager.CONQUEST_ROUTES:
			if (pair[0] == id and pair[1] == target) or (pair[1] == id and pair[0] == target):
				linked = true
		var score: float = d - (0.5 if linked else 0.0) - (0.1 if String(ProgressionManager.conquest_city_kind(id)) == "enemy" else 0.0)
		if score < best_score:
			best_score = score
			best = id
	return best

## Bandeau d'alerte du conseil : offensive annoncée et trêve en cours.
func _refresh_threat_banner() -> void:
	if _threat_banner == null:
		return
	var lines: PackedStringArray = []
	var th: Dictionary = ConquestSystem.threat(_conquest)
	if not th.is_empty():
		var tid: String = String(th.get("city", ""))
		var who: String = String(th.get("general", ""))
		var lead: String = "☠ %s, général du Roi Squelette, mène l'offensive !\n" % who if who != "" else ""
		lines.append("%s⚠ OFFENSIVE sur %s dans %d bataille(s)\nForce ennemie %d · défense %d%s" % [
			lead, ProgressionManager.conquest_city_name(tid), int(th.get("eta", 0)), int(th.get("power", 0)),
			ConquestSystem.defense(_save, tid), " — RENFORCEZ-LA !" if ConquestSystem.defense(_save, tid) < int(th.get("power", 0)) else " — elle tiendra."])
	if int(_conquest.get("truce", 0)) > 0:
		lines.append("☮ Trêve : %d bataille(s) sans raid" % int(_conquest["truce"]))
	_threat_banner.visible = not lines.is_empty()
	_threat_banner.text = Typo.fr("\n".join(lines))

func _refresh_nameplates() -> void:
	_refresh_threat_banner()
	_refresh_map_state()

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
		"bastion_orage": "Un bastion perché dans les courants d'air des hautes terres.",
		"caravanserail": "Une halte marchande sur la côte, là où la marée dépose les caravanes.",
		"observatoire": "Un observatoire oublié tourné vers le soleil.",
		"port_sable": "Un port fortifié battu par les marées, repaire de pirates.",
		"atelier_cuivre": "Un atelier où les ingénieurs des Rouages testent leurs inventions.",
		"citadelle_engrenages": "Une forteresse mécanique dont les murs tournent au rythme des engrenages.",
		"bois_lune": "Un bois ancien où la brume s'accroche aux arbres argentés.",
		"sanctuaire_mousse": "Un sanctuaire oublié protégé par les esprits de la forêt.",
		"forge_givre": "Une forge de cristal où l'on taille des lames qui chantent.",
		"pic_foudroyant": "Un sommet balayé par les vents et les orages, gardé par des sentinelles.",
		"marais_spectres": "Un marais brumeux où rôdent des silhouettes spectrales.",
		"fort_cendre": "Un fort bâti sur un champ de lave, sous un ciel de cendres.",
		"temple_soleil": "Un temple ancien consacré au soleil du désert.",
		"citadelle_sable": "Une citadelle de lave durcie qui verrouille les routes du sud.",
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

## L'icône et la bordure identifient le biome ; le fond reste réservé au statut.
func _city_biome_icon(city_id: String) -> String:
	match ProgressionManager.conquest_city_biome(city_id):
		"Forêt": return "🌲"
		"Montagne": return "⛰"
		"Désert": return "☀"
		"Donjon": return "☠"
		"Cristaux": return "💎"
		"Marées": return "🌊"
		"Vents": return "🌀"
		"Brasier": return "🔥"
		"Brumes": return "🌫"
		"Ombres": return "🌙"
		"Rouages": return "⚙"
		_: return "◆"

func _city_border_color(city_id: String) -> Color:
	match ProgressionManager.conquest_city_biome(city_id):
		"Forêt": return Color(0.43, 0.72, 0.38)
		"Montagne": return Color(0.43, 0.70, 0.88)
		"Désert": return Color(0.92, 0.66, 0.32)
		"Donjon": return Color(0.70, 0.48, 0.82)
		_:
			if Nations.is_new(ProgressionManager.conquest_city_biome(city_id)):
				return Nations.accent(ProgressionManager.conquest_city_biome(city_id))
			return Color(0.5, 0.64, 0.46)

func _city_sprite(city_id: String) -> Texture2D:
	var biome := String(_city_meta(city_id).get("biome", "Forêt"))
	var art: String = CityScreenUI.art_key(biome)
	var key: String = "%s|%s" % [art, "cap" if city_id == "capitale" else "city"]
	if not _city_sprite_cache.has(key):
		_city_sprite_cache[key] = _city_medallion(art, city_id == "capitale")
	return _city_sprite_cache[key] as Texture2D

## Médaillon illustré d'une ville : l'illustration de la nation (cities/*.jpg),
## coins arrondis et liseré doré (plus épais pour la capitale).
func _city_medallion(art: String, capital: bool) -> Texture2D:
	var tex: Texture2D = load("res://assets/ui/conquest/cities/%s.jpg" % art) as Texture2D
	if tex == null:
		return null
	var src: Image = tex.get_image()
	if src.is_compressed():
		src.decompress()
	src.convert(Image.FORMAT_RGBA8)
	var w: int = 288
	var h: int = 200
	# recadrage centré au format du médaillon
	var ratio: float = float(w) / float(h)
	var cw: int = src.get_width()
	var ch: int = int(float(cw) / ratio)
	if ch > src.get_height():
		ch = src.get_height()
		cw = int(float(ch) * ratio)
	var crop: Image = src.get_region(Rect2i((src.get_width() - cw) / 2, (src.get_height() - ch) / 2, cw, ch))
	crop.resize(w, h, Image.INTERPOLATE_LANCZOS)
	var radius: float = 26.0
	var border: float = 7.0 if capital else 4.0
	var gold := Color(1.0, 0.82, 0.38) if capital else Color(0.86, 0.72, 0.40)
	var out := Image.create(w, h, false, Image.FORMAT_RGBA8)
	for y: int in range(h):
		for x: int in range(w):
			# distance au rectangle arrondi
			var dx: float = maxf(absf(x + 0.5 - w * 0.5) - (w * 0.5 - radius), 0.0)
			var dy: float = maxf(absf(y + 0.5 - h * 0.5) - (h * 0.5 - radius), 0.0)
			var d: float = sqrt(dx * dx + dy * dy) - radius   # <0 : dedans
			if d > 0.5:
				continue
			var c: Color = crop.get_pixel(x, y)
			if d > -border:
				c = gold.darkened(0.25 * clampf((d + border) / border, 0.0, 1.0))
			c.a = clampf(0.5 - d, 0.0, 1.0)
			out.set_pixel(x, y, c)
	return ImageTexture.create_from_image(out)

## Progression de domination par biome, hors capitale et Donjon.
## Le bonus est versé à chaque victoire lorsque toutes les villes du biome
## sont contrôlées ; cette ligne rend la condition visible avant l'annexion.
func _biome_control_summary(biome: String) -> String:
	var reward: String = ""
	match biome:
		"Forêt":
			reward = "+5 Bois par victoire"
		"Montagne":
			reward = "+5 Fer par victoire"
		"Désert":
			reward = "+5 Venin par victoire"
		_:
			if not Nations.is_new(biome):
				return ""
			reward = "+5 %s par victoire" % Nations.resource_of(biome)
	var total: int = 0
	var controlled: int = 0
	var owned: Array = _conquest.get("owned", [])
	for city_id: String in ProgressionManager.CONQUEST_CITIES.keys():
		if city_id == "capitale" or city_id == "donjon_roi":
			continue
		if String(ProgressionManager.CONQUEST_CITIES[city_id].get("biome", "")) != biome:
			continue
		total += 1
		if owned.has(city_id):
			controlled += 1
	if total <= 0:
		return ""
	if controlled == total:
		return "★ DOMINATION %s : bonus actif — %s." % [biome.to_upper(), reward]
	return "Domination %s : %d/%d villes — bonus à 100 %% : %s." % [biome, controlled, total, reward]

func _refresh_chronicle() -> void:
	if _chronicle_label == null:
		return
	var events: Array = _conquest.get("events", [])
	if events.is_empty():
		_chronicle_label.text = "Vos premières conquêtes apparaîtront ici."
		return
	var lines: PackedStringArray = []
	var index: int = events.size() - 1
	while index >= 0 and lines.size() < 4:
		lines.append("• " + String(events[index]))
		index -= 1
	_chronicle_label.text = Typo.fr("\n".join(lines))

func _persist() -> void:
	_save["conquest"] = _conquest
	_save["campaign_mode"] = "conquest"
	ProgressionManager.write_save(_slot, _save)
	GameManager.active_save = _save
	GameManager.active_slot = _slot

func _back_to_save() -> void:
	PlayTimer.flush()
	_persist()
	get_tree().change_scene_to_file("res://scenes/SaveSlots.tscn")

## Défi facultatif de la prochaine bataille (bonus d'or et de ressource du biome).
func _show_challenge(city_id: String) -> void:
	if _challenge_label == null:
		return
	var ch: Dictionary = ProgressionManager.conquest_challenge_for(_save, city_id) if city_id != "" else {}
	_challenge_label.visible = not ch.is_empty()
	if ch.is_empty():
		return
	_challenge_label.text = Typo.fr("◆ DÉFI FACULTATIF\n%s\nBonus : %s" % [String(ch["label"]), _challenge_reward_text(ch)])

func _challenge_reward_text(ch: Dictionary) -> String:
	var parts: PackedStringArray = ["+%d or" % int(ch.get("gold", 0))]
	var res: Dictionary = ch.get("resources", {})
	for r: String in res.keys():
		parts.append("+%d %s" % [int(res[r]), r])
	return " · ".join(parts)

## Petite respiration de la ville sélectionnée (repère visuel sur téléphone).
func _pulse_selected(id: String) -> void:
	if _pulse_tween != null and _pulse_tween.is_valid():
		_pulse_tween.kill()
	for other: String in _city_buttons.keys():
		((_city_buttons[other] as Button).get_node("CityPin") as Control).scale = Vector2.ONE
	if not _city_buttons.has(id):
		return
	var pin: Control = (_city_buttons[id] as Button).get_node("CityPin") as Control
	pin.pivot_offset = Vector2(pin.size.x * 0.5, pin.size.y * 0.66)
	_pulse_tween = pin.create_tween().set_loops()
	_pulse_tween.tween_property(pin, "scale", Vector2(1.12, 1.12), 0.55).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_pulse_tween.tween_property(pin, "scale", Vector2.ONE, 0.55).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _pill_style() -> StyleBoxFlat:
	var s := _style(Color(0.05, 0.08, 0.11, 0.82), Color(0.82, 0.66, 0.30, 0.85))
	s.set_corner_radius_all(16)
	s.content_margin_left = 14
	s.content_margin_right = 14
	s.content_margin_top = 4
	s.content_margin_bottom = 4
	return s

func _style_button(b: Button, base: Color, border: Color) -> void:
	b.add_theme_stylebox_override("normal", _style(base, border))
	b.add_theme_stylebox_override("hover", _style(base.lightened(0.12), border.lightened(0.2)))
	b.add_theme_stylebox_override("pressed", _style(base.darkened(0.2), border))
	b.add_theme_stylebox_override("focus", _style(base, border.lightened(0.3)))
	var dis := _style(Color(0.16, 0.18, 0.20, 0.9), Color(0.32, 0.34, 0.36))
	b.add_theme_stylebox_override("disabled", dis)
	b.add_theme_color_override("font_color", Color(1.0, 0.95, 0.85))
	b.add_theme_color_override("font_hover_color", Color.WHITE)
	b.add_theme_color_override("font_disabled_color", Color(0.62, 0.64, 0.66))

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

## Centre un panneau (taille = contenu) quelle que soit sa taille finale : ancres au centre,
## il grandit des deux côtés (un preset posé avant le calcul de la taille le décalait vers le bas/droite).
func _center_panel(panel: Control) -> void:
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	panel.grow_vertical = Control.GROW_DIRECTION_BOTH
