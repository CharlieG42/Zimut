extends CanvasLayer
## Mode Aventure — carte d'exploration isométrique (rendu et interactions).
##
## La logique (état, brouillard, récompenses, événements, ponts inter-modes) vit dans
## AdventureManager.gd ; le catalogue officiel (zones, lieux, énigmes) dans
## ProgressionManager ; le terrain (obstacles, sentiers, chemins) dans AdventureTerrain.
##
## Rendu dans le même langage graphique que le mode Tactique : tuiles de sol des
## arènes, décors BattleScenery, fond d'îles flottantes (BackdropFx), héros = sprite de
## la classe choisie. Les icônes de lieux restent dans assets/adventure/poi/ (remplaçables).
## La progression reste dans la sauvegarde commune aux quatre modes.

const U = preload("res://scripts/UiKit.gd")

const TILE_W := 128.0
const TILE_H := 64.0
## V43 : en dessous de cette échelle, la carte entière deviendrait illisible : on passe en vue
## défilante (glisser pour parcourir, caméra qui suit le héros) au lieu de tout rétrécir.
const READABLE_SCALE := 0.82
const ISO_SCALE := 0.95            # V106 : plateau isométrique à étages
const BOARD_SCALE := 0.78          # V83 : échelle d'une planche illustrée
const DIORAMA_SCALE := 0.72        # V115 : diorama pré-rendu (~1 pixel du rendu par pixel écran)
const PAN_THRESHOLD := 14.0
const SIDE_W := 440.0
const STEP_TIME := 0.15
const BOARD_STEP_TIME := 0.24   # laisse le temps de lire une foulée complète sur la planche
const HELP_STEPS := 30          # l'aide de contrôle disparaît après ces premiers pas
const DIM := Color(0.80, 0.84, 0.92)          # texte secondaire (plus clair que UiKit.C_DIM)

const POI_ICONS := {
	"combat": "res://assets/adventure/poi/combat.svg",
	"chest": "res://assets/adventure/poi/chest.svg",
	"puzzle": "res://assets/adventure/poi/puzzle.svg",
	"camp": "res://assets/adventure/poi/camp.svg",
	"reveal": "res://assets/adventure/poi/reveal.svg",
	"exit": "res://assets/adventure/poi/exit.svg",
}
const POI_COLOR := {
	"combat": Color(1.0, 0.42, 0.36), "chest": Color(1.0, 0.82, 0.35), "puzzle": Color(0.72, 0.58, 1.0),
	"camp": Color(1.0, 0.62, 0.30), "reveal": Color(0.45, 0.85, 1.0), "exit": Color(0.55, 1.0, 0.55),
}
const POI_ACTION := {
	"combat": "⚔  COMBATTRE", "chest": "◇  OUVRIR LE COFFRE", "puzzle": "✦  RÉSOUDRE L'ÉNIGME",
	"camp": "☀  SE REPOSER", "reveal": "👁  OBSERVER L'HORIZON", "exit": "🌀  FRANCHIR LE PORTAIL",
}
## Objet posé au sol sous chaque lieu (décors BattleScenery), par biome.
const POI_PROP := {
	"combat": {"Forêt": "banner", "Montagne": "stakes", "Désert": "bones", "Donjon": "chains"},
	"chest": {"Forêt": "crate", "Montagne": "crate", "Désert": "jar", "Donjon": "crate"},
	"puzzle": {"Forêt": "standing_stone", "Montagne": "crystal", "Désert": "obelisk", "Donjon": "stone_pillar"},
	"camp": {"Forêt": "log_pile", "Montagne": "log_pile", "Désert": "well", "Donjon": "rubble"},
	"reveal": {"Forêt": "big_tree", "Montagne": "cairn", "Désert": "sand_pillar", "Donjon": "ruin_wall"},
	"exit": {"Forêt": "ruin_arch", "Montagne": "ice_portal", "Désert": "ruin_arch", "Donjon": "ruin_arch"},
}
## Décalage écran d'une case dans chaque direction du monde (projection isométrique) :
## est = +x de la grille (bas-droite), nord = −y (haut-droite)…
const GATE_VEC := {"N": Vector2(64, -32), "E": Vector2(64, 32), "S": Vector2(-64, 32), "W": Vector2(-64, -32)}
## Couleurs des biomes sur la mini-carte du monde.
const BIOME_COLOR := {"Forêt": Color(0.42, 0.70, 0.36), "Montagne": Color(0.74, 0.80, 0.88),
	"Désert": Color(0.92, 0.75, 0.42), "Donjon": Color(0.52, 0.40, 0.66),
	"Cristaux": Color(0.62, 0.50, 0.95), "Marées": Color(0.35, 0.78, 0.85), "Vents": Color(0.70, 0.88, 1.0),
	"Brasier": Color(0.95, 0.45, 0.15), "Brumes": Color(0.55, 0.80, 0.68), "Ombres": Color(0.55, 0.38, 0.82), "Rouages": Color(0.95, 0.62, 0.22)}
## Objets au sol des lieux, pour les biomes de nation : [combat, chest, puzzle, camp, reveal, exit].
const NATION_POI_PROP := {
	"Cristaux": ["stalagmite", "crystal_rock", "amethyst_spire", "glow_orb", "amethyst_spire", "crystal_throne"],
	"Marées": ["anchor", "barrel", "shell_big", "driftwood", "lighthouse", "lighthouse"],
	"Vents": ["feather_banner", "cloud_rock", "wind_totem", "stone_ring", "windmill", "wind_arch"],
	"Brasier": ["obsidian_spike", "lava_rock", "brazier", "lava_rock", "volcano_cone", "volcano_cone"],
	"Brumes": ["dead_tree", "stump", "mushroom_big", "wisp_lantern", "spirit_tree", "spirit_tree"],
	"Ombres": ["gravestone", "thorn_bush", "cracked_obelisk", "purple_torch", "raven_perch", "dark_gate"],
	"Rouages": ["gear_tower", "scrap_pile", "cog_wheel", "anvil", "tesla_coil", "workshop_crane"],
}
const POI_KIND_INDEX := {"combat": 0, "chest": 1, "puzzle": 2, "camp": 3, "reveal": 4, "exit": 5}
const RUNE_SHAPES: Array = ["●", "▲", "■", "◆", "★", "✚"]
const RUNE_COLORS: Array = [Color(0.95, 0.40, 0.35), Color(0.35, 0.80, 0.45), Color(0.35, 0.60, 1.0),
	Color(0.98, 0.80, 0.25), Color(0.80, 0.50, 1.0), Color(0.40, 0.90, 0.90)]

var manager: Node = null
var _save: Dictionary = {}
var _slot: int = -1

var _map_view: Control
var _world: Node2D
var _backdrop: Node2D
## V115 : diorama — morceaux (tuiles de fond / pages d'occultants) chargés à la demande selon la vue.
## [{path, rect (monde), sprites: Array[Sprite2D], req: bool}]
var _dio_chunks: Array = []
var _dio_clock: float = 0.0
var _dio_sync: bool = true
var _dio_low: Sprite2D = null
## V130 : carte de lumière du diorama (couleur ambiante sous les personnages) ; null hors diorama.
var _dio_light: Image = null
var _dio_light_pos: Vector2 = Vector2.ZERO
var _dio_light_scale: float = 1.0
var _dio_pending: bool = false
## V120 : netteté — sans mipmaps tant que l'image n'est pas trop réduite à l'écran (le filtrage
## trilinéaire mélangeait le niveau ½ et floutait le décor dès qu'on n'était pas au zoom maximal).
var _dio_holder: Node2D = null
var _dio_occ: Array[Sprite2D] = []
var _dio_mip: bool = true
var _dio_px: float = 1.0
## V119 : compteur de fluidité (Réglages › Graphismes) : images/s, moyenne et pire image sur 2 s.
var _perf_lbl: Label = null
var _perf_acc: Array[float] = []
var _perf_clock: float = 0.0
## V120 : temps le plus long (ms) par catégorie sur ~4 s : tuile (chargement + pose), pas (déplacement
## logique), sauv (écriture), maj (rafraîchissement du monde), mob (groupes). Affiché sous le compteur.
var _perf_max: Dictionary = {"tuile": 0.0, "pas": 0.0, "sauv": 0.0, "maj": 0.0, "mob": 0.0}
var _perf_win: float = 0.0
## V121 : durée de la scène (tous les _process, tweens, signaux) et du rendu (envoi des dessins + attente
## de l'écran), séparées par les signaux process_frame / frame_pre_draw / frame_post_draw. Max sur ~4 s.
var _perf_t0: int = 0
var _perf_t1: int = 0
var _perf_scene_max: float = 0.0
var _perf_draw_max: float = 0.0

func _perf_connect() -> void:
	get_tree().process_frame.connect(func() -> void: _perf_t0 = Time.get_ticks_usec())
	RenderingServer.frame_pre_draw.connect(func() -> void:
		_perf_t1 = Time.get_ticks_usec()
		if _perf_t0 > 0:
			_perf_scene_max = maxf(_perf_scene_max, float(_perf_t1 - _perf_t0) / 1000.0))
	RenderingServer.frame_post_draw.connect(func() -> void:
		if _perf_t1 > 0:
			_perf_draw_max = maxf(_perf_draw_max, float(Time.get_ticks_usec() - _perf_t1) / 1000.0))

func _perf_t(key: String, t0_usec: int) -> void:
	if _perf_lbl == null:
		return
	var ms: float = float(Time.get_ticks_usec() - t0_usec) / 1000.0
	if ms > float(_perf_max.get(key, 0.0)):
		_perf_max[key] = ms
var _bg_grad: Gradient
var _board: AdventureBoard
var _entities: Node2D
var _hero: HeroView
var _cell_nodes: Dictionary = {}   # Vector2i -> Array[Node2D] (décors / lieux de la case)
var _toast_tw: Tween = null
var _fade: ColorRect
var _toast: Label
var _side_box: VBoxContainer
var _modal_root: Control = null
var _modal_canvas: CanvasLayer = null
var _walking: bool = false
var _walk_s: float = 0.0        # V114 : position (longueur d'arc) courante sur le trajet continu
var _walk_stop_s: float = 0.0   # V114 : point d'arrêt si blocage en route
var _pending: Vector2i = Vector2i(-1, -1)      # destination en attente de confirmation (appui tactile)
var _hud_title: Label
var _hud_sub: Label
var _action_btn: Button
var _joystick: ZJoystick
var _joy_flip: bool = false
var _rng := RandomNumberGenerator.new()
var _redirect: Vector2i = Vector2i(-1, -1)     # nouvelle destination touchée pendant la marche
var _mob_nodes: Dictionary = {}                 # id de groupe -> MobNode
var _target_mob: int = -1                       # groupe visé (il ne bouge plus)
var _help_panel: Control = null
var _scroll_mode: bool = false                  # V43 : plateau plus grand que l'écran → vue défilante
var _pan_active: bool = false
var _edit_drag: bool = false
var _edit_on: bool = false          # V84 : retouche du masque de la planche
var _edit_mode: String = "open"    # open | close | move
var _edit_bar: HBoxContainer = null
var _edit_btn: Button = null
var _pan_moved: bool = false
var _pan_total: float = 0.0
var _cam_tween: Tween = null
var _recenter_btn: Button = null
var _zoom_in_btn: Button = null
var _zoom_out_btn: Button = null
var _touch_points: Dictionary = {} # index tactile -> position dans la vue
var _pinch_active: bool = false
var _pinch_start_distance: float = 0.0
var _pinch_start_scale: float = BOARD_SCALE
const MAP_ZOOM_MIN := 0.50
const MAP_ZOOM_MAX := 1.45


func _ready() -> void:
	layer = 10
	# Les fenêtres modales doivent rester au-dessus de tous les panneaux de l'Aventure.
	_modal_canvas = CanvasLayer.new()
	_modal_canvas.name = "AdventureModalLayer"
	_modal_canvas.layer = 100
	add_child(_modal_canvas)
	_rng.randomize()
	_save = GameManager.active_save
	_slot = GameManager.active_slot
	if _save.is_empty() or _slot < 0:
		get_tree().change_scene_to_file("res://scenes/SaveSlots.tscn")
		return
	# Vue d'Aventure courante mémorisée : le retour d'un combat reviendra ici (et les planches
	# illustrées, actives seulement dans cette vue, doivent l'être avant le chargement de l'état).
	_save["adventure_view"] = "map"
	manager = Node.new()
	manager.set_script(load("res://scripts/AdventureManager.gd"))
	add_child(manager)
	manager.load_state(_save, _slot)
	manager.persist()
	manager.cities_revealed.connect(_on_cities_revealed)
	_build()
	_rebuild_world()
	_refresh_side()
	_show_pending_rewards.call_deferred()


# ══════════════════════════════════════════════════════════════════════
#  Construction
# ══════════════════════════════════════════════════════════════════════

func _build() -> void:
	var grad := Gradient.new()
	_bg_grad = grad
	grad.colors = PackedColorArray([Color(0.46, 0.62, 0.74), Color(0.72, 0.83, 0.88), Color(0.80, 0.88, 0.86)])
	grad.offsets = PackedFloat32Array([0.0, 0.62, 1.0])
	var gtex := GradientTexture2D.new()
	gtex.gradient = grad
	gtex.fill_from = Vector2(0.5, 0.0)
	gtex.fill_to = Vector2(0.5, 1.0)
	gtex.width = 8
	gtex.height = 256
	var bg := TextureRect.new()
	bg.texture = gtex
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	# Zone de carte (le monde 2D est clippé à l'intérieur)
	_map_view = Control.new()
	_map_view.clip_contents = true
	_map_view.anchor_right = 1.0
	_map_view.anchor_bottom = 1.0
	_map_view.offset_right = -SIDE_W - 12.0
	_map_view.mouse_filter = Control.MOUSE_FILTER_STOP
	_map_view.gui_input.connect(_on_map_input)
	_map_view.resized.connect(_fit_world)
	add_child(_map_view)
	_world = Node2D.new()
	_map_view.add_child(_world)
	_recenter_btn = Button.new()
	_recenter_btn.text = "◎  Centrer"
	_recenter_btn.focus_mode = Control.FOCUS_NONE
	_recenter_btn.add_theme_font_size_override("font_size", 22)
	_recenter_btn.anchor_top = 1.0
	_recenter_btn.anchor_bottom = 1.0
	_recenter_btn.offset_left = 14.0
	_recenter_btn.offset_top = -316.0     # V115 : au-dessus du joystick (qui le recouvrait)
	_recenter_btn.offset_right = 190.0
	_recenter_btn.offset_bottom = -256.0
	_recenter_btn.pressed.connect(func() -> void: _recenter(true))
	_recenter_btn.hide()
	_map_view.add_child(_recenter_btn)
	_recenter_btn.z_index = 1321   # au-dessus des nœuds du monde (z_index de profondeur de la planche, jusqu'à ~600 sur un plateau iso 72x72)

	# Zoom accessible sur mobile, en complément du pincement à deux doigts.
	_zoom_in_btn = Button.new()
	_zoom_in_btn.text = "+"
	_zoom_in_btn.focus_mode = Control.FOCUS_NONE
	_zoom_in_btn.add_theme_font_size_override("font_size", 30)
	_zoom_in_btn.anchor_left = 1.0
	_zoom_in_btn.anchor_right = 1.0
	_zoom_in_btn.anchor_top = 1.0
	_zoom_in_btn.anchor_bottom = 1.0
	_zoom_in_btn.offset_left = -86.0      # V115 : colonne de droite, au-dessus de l'aide (qui les masquait)
	_zoom_in_btn.offset_top = -270.0
	_zoom_in_btn.offset_right = -24.0
	_zoom_in_btn.offset_bottom = -208.0
	_zoom_in_btn.pressed.connect(func() -> void: _zoom_at(_map_view.size * 0.5, 1.15))
	_zoom_in_btn.hide()
	_map_view.add_child(_zoom_in_btn)
	_zoom_in_btn.z_index = 1321   # au-dessus des nœuds du monde (z_index de profondeur de la planche, jusqu'à ~600 sur un plateau iso 72x72)

	_zoom_out_btn = Button.new()
	_zoom_out_btn.text = "−"
	_zoom_out_btn.focus_mode = Control.FOCUS_NONE
	_zoom_out_btn.add_theme_font_size_override("font_size", 30)
	_zoom_out_btn.anchor_left = 1.0
	_zoom_out_btn.anchor_right = 1.0
	_zoom_out_btn.anchor_top = 1.0
	_zoom_out_btn.anchor_bottom = 1.0
	_zoom_out_btn.offset_left = -86.0
	_zoom_out_btn.offset_top = -200.0
	_zoom_out_btn.offset_right = -24.0
	_zoom_out_btn.offset_bottom = -138.0
	_zoom_out_btn.pressed.connect(func() -> void: _zoom_at(_map_view.size * 0.5, 1.0 / 1.15))
	_zoom_out_btn.hide()
	_map_view.add_child(_zoom_out_btn)
	_zoom_out_btn.z_index = 1321   # au-dessus des nœuds du monde (z_index de profondeur de la planche, jusqu'à ~600 sur un plateau iso 72x72)

	_build_edit_ui()

	# Voile de transition entre deux cartes (nuages)
	_fade = ColorRect.new()
	_fade.color = Color(0.86, 0.91, 0.95, 0.0)
	_fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fade.z_index = 1420  # au-dessus des panonceaux (z_index des nœuds du monde)
	_fade.visible = false   # V119 : n'est montré que pendant une transition (couche plein écran)
	_map_view.add_child(_fade)

	# Bandeau d'annonce (fondu)
	_toast = U.lbl("", 26, Color(1.0, 0.92, 0.6), true)
	_toast.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_toast.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	_toast.offset_top = 22.0
	_toast.offset_bottom = 70.0
	_toast.modulate.a = 0.0
	_toast.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_toast.z_index = 1421
	_toast.visible = false
	_map_view.add_child(_toast)
	_build_hud()
	if GameSettings.show_perf:
		_perf_lbl = U.lbl("…", 18, Color(0.6, 1.0, 0.6), true)
		_perf_lbl.position = Vector2(16, 112)
		_perf_lbl.z_index = 1330
		_perf_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		_map_view.add_child(_perf_lbl)
		_perf_connect()

	# Panneau latéral
	var side := PanelContainer.new()
	side.anchor_left = 1.0
	side.anchor_right = 1.0
	side.anchor_bottom = 1.0
	side.offset_left = -SIDE_W
	side.add_theme_stylebox_override("panel", U.box(Color(0.06, 0.08, 0.13, 0.97), Color(0.86, 0.68, 0.30), 0, 2, 16))
	add_child(side)
	var scroll := ScrollContainer.new()
	TouchScroll.install(scroll)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	side.add_child(scroll)
	_side_box = VBoxContainer.new()
	_side_box.add_theme_constant_override("separation", 12)
	_side_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(_side_box)


func _build_hud() -> void:
	# Plaque d'information en haut à gauche : carte, biome, niveau, progression
	var plate := PanelContainer.new()
	plate.position = Vector2(16, 16)
	plate.mouse_filter = Control.MOUSE_FILTER_IGNORE
	plate.z_index = 1320
	plate.add_theme_stylebox_override("panel", U.box(Color(0.05, 0.07, 0.12, 0.88), Color(0.86, 0.68, 0.30), 14, 2, 14))
	_map_view.add_child(plate)
	var pv := VBoxContainer.new()
	pv.add_theme_constant_override("separation", 2)
	plate.add_child(pv)
	_hud_title = U.lbl("", 28, U.C_GOLD, true)
	pv.add_child(_hud_title)
	_hud_sub = U.lbl("", 19, Color(0.92, 0.94, 0.98))
	pv.add_child(_hud_sub)

	# Bouton d'action contextuel, grand et centré en bas
	_action_btn = U.btn("", Color(0.95, 0.75, 0.30), 26, Vector2(520, 76))
	_action_btn.anchor_left = 0.5
	_action_btn.anchor_right = 0.5
	_action_btn.anchor_top = 1.0
	_action_btn.anchor_bottom = 1.0
	_action_btn.offset_left = -260.0
	_action_btn.offset_right = 260.0
	_action_btn.offset_top = -100.0
	_action_btn.offset_bottom = -24.0
	_action_btn.z_index = 1322
	_action_btn.pressed.connect(_on_action_pressed)
	_action_btn.hide()
	_map_view.add_child(_action_btn)

	# Joystick tactile : on glisse le pouce, le héros marche case par case tant qu'on le tient.
	_joystick = ZJoystick.new()
	_joystick.anchor_top = 1.0
	_joystick.anchor_bottom = 1.0
	_joystick.offset_left = 20.0
	_joystick.offset_top = -236.0
	_joystick.offset_right = 232.0
	_joystick.offset_bottom = -24.0
	_joystick.z_index = 1322
	_map_view.add_child(_joystick)

	# Aide de contrôle, en bas à droite de la carte
	var help := PanelContainer.new()
	help.anchor_left = 1.0
	help.anchor_right = 1.0
	help.anchor_top = 1.0
	help.anchor_bottom = 1.0
	help.offset_left = -400.0
	help.offset_right = -16.0
	help.offset_top = -120.0
	help.offset_bottom = -24.0
	help.mouse_filter = Control.MOUSE_FILTER_IGNORE
	help.z_index = 1322
	help.add_theme_stylebox_override("panel", U.box(Color(0.05, 0.07, 0.12, 0.80), Color(0.30, 0.36, 0.50), 12, 1, 10))
	var hl: Label = U.lbl("Touchez une case pour y marcher (touchez ailleurs pour changer de cap).\nTouchez un groupe de monstres pour le combattre. Joystick : marche continue.", 16, Color(0.92, 0.94, 0.98))
	hl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	help.add_child(hl)
	_map_view.add_child(help)
	_help_panel = help
	help.visible = manager.moves() < HELP_STEPS


## Interaction de proximité : POI, trouvailles et portes accessibles à une case.
## L'activation emprunte le déplacement normal et conserve les règles existantes.
func _adjacent_interaction() -> Dictionary:
	var hp: Vector2i = manager.hero_pos()
	for direction: Vector2i in [Vector2i(0, -1), Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0)]:
		var target: Vector2i = hp + direction
		if not _inside(target) or not manager.can_move_to(target):
			continue
		var gate: Dictionary = manager.gate_at(target)
		if not gate.is_empty() and bool(gate.get("open", false)):
			return {"kind": "gate", "pos": target, "info": gate}
		var poi: Dictionary = manager.poi_at(target)
		if not poi.is_empty() and (not manager.poi_done(target) or String(poi.get("kind", "")) == "camp"):
			return {"kind": "poi", "pos": target, "info": poi}
		var find_kind: String = manager.find_at(target)
		if find_kind != "" and not manager.find_taken(target):
			return {"kind": "find", "pos": target, "info": {"kind": find_kind}}
	return {}


## Met à jour la plaque d'infos et le bouton d'action selon la case du héros.
func _refresh_hud() -> void:
	if _hud_title == null:
		return
	var prog: Dictionary = manager.zone_progress()
	_hud_title.text = manager.zone_name()
	var fprog: Dictionary = manager.finds_progress()
	_hud_sub.text = "%s · niveau %d · lieux %d/%d · ✦ %d/%d%s" % [ProgressionManager.biome_label(manager.zone_biome()),
		ProgressionManager.adventure_zone_level(manager.zone_id()), int(prog["done"]), int(prog["total"]),
		int(fprog["found"]), int(fprog["total"]), "  ★" if manager.is_mastered() else ""]
	var c: Dictionary = manager.contract()
	if not c.is_empty():
		_hud_sub.text += "\n📜 " + AdventureMobs.contract_text(c)
	var pos: Vector2i = manager.hero_pos()
	var gate: Dictionary = manager.gate_at(pos)
	var poi: Dictionary = manager.poi_at(pos)
	_action_btn.hide()
	if poi.is_empty() and not gate.is_empty():
		if bool(gate["open"]):
			_action_btn.text = "➜  PASSER VERS %s" % String(gate["name"]).to_upper()
			_action_btn.show()
		return
	if poi.is_empty():
		var nearby: Dictionary = _adjacent_interaction()
		if nearby.is_empty():
			return
		var nearby_kind: String = String(nearby.get("kind", ""))
		var nearby_info: Dictionary = nearby.get("info", {})
		if nearby_kind == "gate":
			_action_btn.text = "➜  PASSER VERS %s" % String(nearby_info.get("name", "LA CARTE VOISINE")).to_upper()
		elif nearby_kind == "find":
			_action_btn.text = "✦  RAMASSER LA TROUVAILLE"
		else:
			var nearby_action: String = String(POI_ACTION.get(String(nearby_info.get("kind", "")), "INTERAGIR"))
			if String(nearby_info.get("kind", "")) == "combat" and Dungeons.is_dungeon(nearby_info):
				nearby_action = "ENTRER DANS LE DONJON" if manager.dungeon_lock(nearby_info).is_empty() else "🔒 DONJON VERROUILLÉ"
			_action_btn.text = "▶  %s · %s" % [nearby_action, String(nearby_info.get("name", "LIEU")).to_upper()]
		_action_btn.show()
		return
	var kind: String = String(poi.get("kind", ""))
	if manager.poi_done(pos) and kind != "camp":
		return
	var act: String = String(POI_ACTION.get(kind, "INTERAGIR"))
	if kind == "combat" and Dungeons.is_dungeon(poi):
		var gb: String = String(poi["guardian"])
		var rm: int = Dungeons.current_room(manager.state, gb)
		act = "🏰  %s  (salle %d/%d · niv %d)" % ["ENTRER" if rm == 1 else "POURSUIVRE", rm, Dungeons.ROOMS, Dungeons.room_level(gb, rm)]
		if not manager.dungeon_lock(poi).is_empty():
			act = "🔒  DONJON VERROUILLÉ  (niv %d)" % Dungeons.room_level(gb, Dungeons.ROOMS)
	elif kind == "combat":
		act += "  (niv %d)" % manager.challenge_level(poi)
	_action_btn.text = "▶  %s" % act
	_action_btn.show()


func _on_action_pressed() -> void:
	if _walking or _modal_root != null:
		return
	var pos: Vector2i = manager.hero_pos()
	if not manager.gate_at(pos).is_empty() and manager.poi_at(pos).is_empty():
		_cross_gate(pos)
		return
	if manager.poi_at(pos).is_empty():
		var nearby: Dictionary = _adjacent_interaction()
		if not nearby.is_empty():
			var target: Vector2i = nearby.get("pos", Vector2i(-1, -1))
			if manager.can_move_to(target):
				_walk([target])
			else:
				_say("Le passage est momentanément bloqué.")
			return
	_interact()


func _process(_delta: float) -> void:
	if _perf_lbl != null:
		_perf_tick(_delta)
	if not _dio_chunks.is_empty():
		_dio_clock += _delta
		if _dio_sync or _dio_pending or _dio_clock >= 0.15:
			_dio_clock = 0.0
			_diorama_stream()
			_dio_filter_sync()
	if _joystick == null or not _joystick.pushed() or _walking or _modal_root != null:
		return
	_joy_step(_joystick.vector)


## Pixels écran par pixel du rendu ; sous ~0,58 on repasse en mipmaps (sinon l'herbe scintille au dézoom).
func _dio_filter_sync() -> void:
	if _dio_holder == null or not is_instance_valid(_dio_holder):
		return
	var eff: float = _world.scale.x * _dio_px * get_viewport().get_screen_transform().get_scale().x
	var want_mip: bool = eff < (0.62 if _dio_mip else 0.55)
	if want_mip == _dio_mip:
		return
	_dio_mip = want_mip
	var f: int = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS if want_mip else CanvasItem.TEXTURE_FILTER_LINEAR
	_dio_holder.texture_filter = f
	for o: Sprite2D in _dio_occ:
		if is_instance_valid(o):
			o.texture_filter = f


func _perf_tick(dt: float) -> void:
	_perf_acc.append(dt)
	_perf_clock += dt
	if _perf_clock < 0.5:
		return
	_perf_clock = 0.0
	while _perf_acc.size() > 240:
		_perf_acc.remove_at(0)
	var tot: float = 0.0
	var worst: float = 0.0
	var slow: int = 0
	for v: float in _perf_acc:
		tot += v
		worst = maxf(worst, v)
		if v > 1.0 / 40.0:
			slow += 1
	var avg: float = tot / maxf(1.0, float(_perf_acc.size()))
	_perf_max["sauv"] = maxf(float(_perf_max["sauv"]), manager.last_persist_ms) if manager != null else 0.0
	manager.last_persist_ms = 0.0
	_perf_win += 0.5
	var detail: String = "tuile %.0f · pas %.0f · sauv %.0f · maj %.0f · mob %.0f ms (max)" % [_perf_max["tuile"], _perf_max["pas"], _perf_max["sauv"], _perf_max["maj"], _perf_max["mob"]]
	var rend: String = "scène %.0f · rendu %.0f ms (max) · dessins %d · objets %d · vram %d Mo · nœuds %d" % [
		_perf_scene_max, _perf_draw_max, int(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)),
		int(Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME)),
		int(Performance.get_monitor(Performance.RENDER_VIDEO_MEM_USED) / 1048576.0),
		int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT))]
	if _perf_win >= 4.0:
		_perf_win = 0.0
		_perf_scene_max = 0.0
		_perf_draw_max = 0.0
		for k: String in _perf_max.keys():
			_perf_max[k] = 0.0
	_perf_lbl.text = "%d i/s · %.0f ms · pire %.0f ms · saccades %d\n%s\n%s" % [roundi(1.0 / maxf(avg, 0.0001)), avg * 1000.0, worst * 1000.0, slow, detail, rend]


## V115 : diorama — charge les tuiles / pages d'occultants proches de la vue (fil de chargement), libère les autres.
## Le premier passage (et après une reconstruction) charge de façon synchrone pour éviter un écran vide.
func _diorama_stream() -> void:
	if _world == null or _map_view == null:
		return
	var sc: float = maxf(_world.scale.x, 0.01)
	var vis := Rect2(-_world.position / sc, _map_view.size / sc)
	# V117 : hystérésis — on charge un peu au-delà de la vue, on ne libère que bien plus loin
	# (évite de décharger / recharger en boucle un morceau au bord de l'écran).
	var view := vis.grow(700.0 / sc + 300.0)
	var keep := vis.grow(2200.0 / sc + 900.0)
	var sync: bool = _dio_sync
	_dio_sync = false
	# V119 : au plus UN nouveau morceau envoyé au GPU par image (l'envoi d'une grande texture bloque
	# l'image courante : plusieurs d'un coup au dézoom faisaient une saccade).
	var budget: int = 99 if sync else 1
	_dio_pending = false
	for ch: Dictionary in _dio_chunks:
		var want: bool = view.intersects(ch["rect"])
		var spr: Sprite2D = (ch["sprites"] as Array)[0]
		var path: String = ch["path"]
		if want and spr.texture == null:
			if budget <= 0:
				_dio_pending = true
				continue
			var t_tile: int = Time.get_ticks_usec()
			var tex: Texture2D = null
			if sync or ResourceLoader.has_cached(path):
				tex = load(path) as Texture2D
			elif not bool(ch["req"]):
				ResourceLoader.load_threaded_request(path, "Texture2D")
				ch["req"] = true
			elif ResourceLoader.load_threaded_get_status(path) == ResourceLoader.THREAD_LOAD_LOADED:
				tex = ResourceLoader.load_threaded_get(path) as Texture2D
				ch["req"] = false
			if tex != null:
				budget -= 1
				for s2: Sprite2D in ch["sprites"]:
					s2.texture = tex
				_perf_t("tuile", t_tile)
			else:
				_dio_pending = true
		elif spr.texture != null and not keep.intersects(ch["rect"]):
			for s2: Sprite2D in ch["sprites"]:
				s2.texture = null


## Un pas dans la direction du joystick ; si l'axe de grille voulu est bloqué, essaie l'autre.
func _joy_step(v: Vector2) -> void:
	_joy_flip = not _joy_flip
	var dirs: Array[Vector2i] = ZJoystick.grid_dirs(v, _joy_flip)
	for d: Vector2i in dirs:
		var t: Vector2i = manager.hero_pos() + d
		if _inside(t) and manager.can_move_to(t):
			_step_dir(d)
			return


## Un pas dans une direction (joystick / clavier).
func _step_dir(d: Vector2i) -> void:
	if _walking or _modal_root != null:
		return
	var target: Vector2i = manager.hero_pos() + d
	_pending = Vector2i(-1, -1)
	_board.preview = []
	if not _inside(target):
		_say("Le bord de l'île : la route continue par les flèches.")
		return
	var g: Dictionary = manager.mob_at(target)
	if not g.is_empty():
		_confirm_mob(g)
		return
	if not manager.can_move_to(target):
		_say("Le passage est bloqué par le décor.")
		return
	var path: Array[Vector2i] = [target]
	_walk(path)


func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey) or not event.pressed or event.echo:
		return
	if _walking or _modal_root != null:
		return
	var d := Vector2i.ZERO
	match event.keycode:
		KEY_LEFT, KEY_A, KEY_Q: d = Vector2i(-1, 0)
		KEY_UP, KEY_W, KEY_Z: d = Vector2i(0, -1)
		KEY_RIGHT, KEY_D: d = Vector2i(1, 0)
		KEY_DOWN, KEY_S: d = Vector2i(0, 1)
		KEY_ENTER, KEY_KP_ENTER, KEY_SPACE, KEY_E:
			if _action_btn.visible:
				_on_action_pressed()
			get_viewport().set_input_as_handled()
			return
		_: return
	_step_dir(d)
	get_viewport().set_input_as_handled()


func _rebuild_world() -> void:
	for c: Node in _world.get_children():
		c.queue_free()
	_cell_nodes.clear()
	var biome: String = manager.zone_biome()
	GameManager.fight_biome = biome
	Music.play_adventure(biome)
	var layer: int = ProgressionManager.adventure_biome_layer(biome)
	_set_sky(layer)
	var zs: Vector2i = manager.zone_size()
	if is_board():
		_rebuild_board(biome)
		return
	var land := AdventureLandscape.new()
	land.z_index = 0
	_world.add_child(land)
	_backdrop = land
	var neigh: Array = []
	for dir: String in ["N", "E", "S", "W"]:
		var nz: String = ProgressionManager.adventure_neighbor(manager.zone_id(), dir)
		if nz != "":
			neigh.append({"dir": dir, "biome": ProgressionManager.adventure_zone_biome(nz), "layer": ProgressionManager.adventure_zone_layer(nz),
				"name": ProgressionManager.adventure_zone_name(nz)})
	land.configure(biome, layer, neigh, {
		"top": cell_center(Vector2i(0, 0)) + Vector2(0, -32),
		"left": cell_center(Vector2i(0, zs.y - 1)) + Vector2(-64, 0),
		"right": cell_center(Vector2i(zs.x - 1, 0)) + Vector2(64, 0),
		"bottom": cell_center(Vector2i(zs.x - 1, zs.y - 1)) + Vector2(0, 32)})
	_board = AdventureBoard.new()
	_board.ui = self
	_world.add_child(_board)
	_entities = Node2D.new()
	_entities.y_sort_enabled = true
	_world.add_child(_entities)

	var zid: String = manager.zone_id()
	var terrain: Dictionary = AdventureTerrain.zone_terrain(zid)
	var pal: Dictionary = BattleScenery.pal(biome)
	for p: Vector2i in (terrain["obstacles"] as Dictionary).keys():
		var cb: String = AdventureTerrain.cell_biome(zid, p)
		_add_decor(p, String(terrain["obstacles"][p]), cb, BattleScenery.pal(cb), 1.05)
	for p2: Vector2i in (terrain["decor"] as Dictionary).keys():
		var cb2: String = AdventureTerrain.cell_biome(zid, p2)
		_add_decor(p2, String(terrain["decor"][p2]), cb2, BattleScenery.pal(cb2), 0.8)
	# Portes vers les cartes voisines
	var gates: Dictionary = manager.gates()
	for gp: Vector2i in gates.keys():
		var gn := GateNode.new()
		gn.info = manager.gate_at(gp)
		gn.vec = GATE_VEC[String(gates[gp]["dir"])]
		gn.position = cell_center(gp)
		_entities.add_child(gn)
		_cell_nodes[gp] = _cell_nodes.get(gp, []) + [gn]
	var pois: Dictionary = ProgressionManager.adventure_zone_pois(manager.zone_id())
	for k: String in pois.keys():
		var pos: Vector2i = AdventureTerrain.parse(k)
		var poi: Dictionary = pois[k]
		var node := PoiNode.new()
		node.kind = String(poi.get("kind", "combat"))
		node.portal = manager.is_portal(poi)          # V126 : un portail se repère comme un donjon (halo, étiquette d'état)
		node.is_dungeon = Dungeons.is_dungeon(poi) or node.portal
		node.title = String(poi.get("name", "?"))
		node.level = int(poi.get("level", 10))
		node.biome = biome
		node.pal = pal
		node.icon = load(String(POI_ICONS.get(node.kind, POI_ICONS["combat"]))) as Texture2D
		node.prop = String(POI_PROP.get(node.kind, {}).get(biome, ""))
		if NATION_POI_PROP.has(biome):
			node.prop = String(NATION_POI_PROP[biome][int(POI_KIND_INDEX.get(node.kind, 0))])
		if node.kind == "combat":
			var etypes: Array[String] = ProgressionManager.biome_enemy_types(biome)
			var etype: String = etypes[absi(k.hash()) % etypes.size()]
			node.enemy_tex = Portraits.get_texture({"classe": etype, "team": "enemy", "entity_type": "Enemy"})
		# V27 : sanctuaire d'une Pierre Élémentaire (boss de la Nation)
		var gb: String = String(poi.get("guardian", ""))
		if gb != "":
			node.gem = Stones.info(Dungeons.base(gb)).get("color", Color.WHITE)
			node.gem_taken = Stones.has(manager.save, Dungeons.base(gb))
			var btex: Texture2D = Nations.boss_texture(Dungeons.base(gb))
			if btex != null:
				node.enemy_tex = btex
		node.position = cell_center(pos)
		_entities.add_child(node)
		_cell_nodes[pos] = _cell_nodes.get(pos, []) + [node]
	# Trouvailles cachées (herbes, bourses, reliques) : scintillent une fois la case découverte
	var finds: Dictionary = AdventureTerrain.finds_of(zid)
	for fp: Vector2i in finds.keys():
		var fnode := FindNode.new()
		fnode.kind = String(finds[fp])
		fnode.position = cell_center(fp)
		_entities.add_child(fnode)
		_cell_nodes[fp] = _cell_nodes.get(fp, []) + [fnode]
	# Ambiance : particules propres au biome, par-dessus la carte
	var amb := SceneryAmbient.new()
	amb.name = "Ambient"
	amb.z_index = 20
	amb.configure(maxi(zs.x, zs.y), biome, absi(zid.hash()) % 997)
	amb.position = cell_center(Vector2i(zs.x / 2, zs.y / 2)) + Vector2(0, -150)
	_world.add_child(amb)
	_hero = HeroView.new()
	_hero.tex = Portraits.get_texture({"classe": manager.hero_class(), "team": "player", "entity_type": "Player"})
	_hero.position = cell_center(manager.hero_pos())
	_entities.add_child(_hero)
	# Groupes de monstres errants
	_mob_nodes.clear()
	manager.ensure_mobs()
	_sync_mobs(false)
	_refresh_world()
	_fit_world.call_deferred()


## V83 : planche illustrée — l'illustration sert de décor, lieux / trouvailles / héros / monstres posés dessus.
func _rebuild_board(biome: String) -> void:
	var zid: String = manager.zone_id()
	var zs: Vector2i = manager.zone_size()
	var d: Dictionary = BoardArt.raw(zid)
	var ws: Vector2 = BoardArt.world_size(zid)
	_dio_chunks.clear()
	_dio_holder = null
	_dio_occ.clear()
	_dio_light = null
	if BoardArt.is_diorama(zid):
		var li: Dictionary = BoardArt.diorama_light(zid)
		if not li.is_empty():
			var lt: Texture2D = load(String(li["path"])) as Texture2D
			if lt != null:
				_dio_light = lt.get_image()
				_dio_light_pos = li["pos"]
				_dio_light_scale = float(li["scale"])
		# V115 : « Diorama » — scène 3D pré-rendue (tuiles) posée sur le plateau iso ; héros, lieux et monstres par-dessus.
		var holder := Node2D.new()
		holder.z_index = 0
		holder.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
		_world.add_child(holder)
		_dio_holder = holder
		_dio_occ.clear()
		_dio_mip = true
		_dio_px = BoardArt.diorama_scale(zid)
		_dio_sync = true
		# V117 : fond basse définition toujours présent sous les tuiles (aucun trou pendant un chargement)
		var lo: Dictionary = BoardArt.diorama_low(zid)
		_dio_low = null
		if not lo.is_empty():
			_dio_low = Sprite2D.new()
			_dio_low.texture = load(String(lo["path"])) as Texture2D
			_dio_low.centered = false
			_dio_low.position = lo["pos"]
			_dio_low.scale = Vector2.ONE * float(lo["scale"])
			holder.add_child(_dio_low)
		for t: Dictionary in BoardArt.diorama_tiles(zid):
			var tile := Sprite2D.new()
			tile.centered = false
			tile.position = t["pos"]
			tile.scale = Vector2.ONE * BoardArt.diorama_scale(zid)
			holder.add_child(tile)
			_dio_chunks.append({"path": t["path"], "rect": Rect2(t["pos"], t["size"]), "sprites": [tile], "req": false})
		_backdrop = holder
		# V127 : eau, lave, ombres de nuages et rayons animés (calques au-dessus des tuiles)
		DioramaFx.attach(holder, _world, zid, biome)
	elif BoardArt.is_iso(zid):
		var ground := IsoGround.new()
		ground.ui = self
		ground.z_index = 0
		_world.add_child(ground)
		_backdrop = ground
		# V114 : couche animée légère (clapot + nuages) — absente en qualité « Économie »
		if not GfxQuality.low():
			var fx := IsoFx.new()
			fx.ui = self
			fx.z_index = 0
			_world.add_child(fx)
	else:
		var spr := Sprite2D.new()
		spr.texture = load(String(d["image"])) as Texture2D
		spr.centered = false
		spr.scale = ws / Vector2(spr.texture.get_size())
		spr.z_index = 0
		_world.add_child(spr)
		_backdrop = spr
		# V114 : couche de détails peints par-dessus la planche (clé "detail", fond transparent)
		if d.has("detail") and ResourceLoader.exists(String(d["detail"])):
			var det := Sprite2D.new()
			det.texture = load(String(d["detail"])) as Texture2D
			if det.texture != null:
				det.centered = false
				det.scale = ws / Vector2(det.texture.get_size())
				det.z_index = 0
				_world.add_child(det)
	_board = AdventureBoard.new()
	_board.ui = self
	_board.z_index = 1
	_world.add_child(_board)
	_entities = Node2D.new()
	_entities.y_sort_enabled = true
	_entities.z_index = 2
	_world.add_child(_entities)
	var pal: Dictionary = BattleScenery.pal(biome)
	var pois: Dictionary = ProgressionManager.adventure_zone_pois(zid)
	if BoardArt.is_iso(zid):
		# V106 : arbres, rochers, fleurs… (sprites) sur le plateau à étages
		var terrain: Dictionary = AdventureTerrain.zone_terrain(zid)
		for p: Vector2i in (terrain["obstacles"] as Dictionary).keys():
			if String(terrain["obstacles"][p]) != "building":
				_add_decor(p, String(terrain["obstacles"][p]), biome, pal, 0.8, false, false, int(BoardArt.heights(zid).get(p, 0)))
		for p2: Vector2i in (terrain["decor"] as Dictionary).keys():
			_add_decor(p2, String(terrain["decor"][p2]), biome, pal, 0.7, false, false, int(BoardArt.heights(zid).get(p2, 0)))
		# V115 : bâtiments et arbres du diorama découpés dans le rendu : ils passent devant le héros quand il est derrière.
		var pages := {}
		for oc: Dictionary in BoardArt.diorama_occluders(zid):
			var os := Sprite2D.new()
			os.region_enabled = true
			os.region_rect = oc["rect"]
			os.centered = false
			os.position = oc["pos"]
			os.scale = Vector2.ONE * BoardArt.diorama_scale(zid)
			os.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
			_dio_occ.append(os)
			os.z_index = _depth(oc["cell"]) + 3
			_entities.add_child(os)
			var pk: int = int(oc["page"])
			if not pages.has(pk):
				pages[pk] = {"path": oc["path"], "rect": Rect2(oc["pos"], oc["size"]), "sprites": [], "req": false}
				_dio_chunks.append(pages[pk])
			(pages[pk]["sprites"] as Array).append(os)
			pages[pk]["rect"] = (pages[pk]["rect"] as Rect2).merge(Rect2(oc["pos"], oc["size"]))
		for b: Dictionary in BoardArt.buildings(zid):
			var bn := BuildingNode.new()
			bn.kind = String(b["k"])
			bn.fw = int(b["w"])
			bn.fh = int(b["h"])
			bn.cs = BoardArt.iso_cs(zid)
			bn.seed_value = int(b["x"]) * 31 + int(b["y"]) * 17
			bn.position = cell_center(Vector2i(int(b["x"]) + bn.fw - 1, int(b["y"]) + bn.fh - 1)) + Vector2(0, BoardArt.ISO_TH * bn.cs * 0.5)
			_entities.add_child(bn)
	else:
		# V114 : planche « v2 enrichie » — décors superposés lus dans la planche (clés "decor" / "over").
		# "over" = grands arbres sur cases non jouables, juste au sud des chemins : occlusion du héros.
		for dk: String in (d.get("decor", {}) as Dictionary).keys():
			_add_decor(AdventureTerrain.parse(dk), String(d["decor"][dk]), biome, pal, 0.7, biome == "Forêt")
		for ok: String in (d.get("over", {}) as Dictionary).keys():
			_add_decor(AdventureTerrain.parse(ok), String(d["over"][ok]), biome, pal, 1.05, biome == "Forêt", true)
	for k: String in pois.keys():
		var pos: Vector2i = AdventureTerrain.parse(k)
		var poi: Dictionary = pois[k]
		var node := PoiNode.new()
		node.kind = String(poi.get("kind", "combat"))
		node.portal = manager.is_portal(poi)          # V126 : un portail se repère comme un donjon (halo, étiquette d'état)
		node.is_dungeon = Dungeons.is_dungeon(poi) or node.portal
		node.title = String(poi.get("name", "?"))
		node.level = int(poi.get("level", 10))
		node.biome = biome
		node.pal = pal
		node.icon = load(String(POI_ICONS.get(node.kind, POI_ICONS["combat"]))) as Texture2D
		node.prop = ""                      # les bâtiments / entrées sont dessinés dans la planche
		if BoardArt.is_iso(zid):
			node.prop = String(POI_PROP.get(node.kind, {}).get(biome, ""))
			if node.kind == "combat":
				var etypes: Array[String] = ProgressionManager.biome_enemy_types(biome)
				node.enemy_tex = Portraits.get_texture({"classe": etypes[absi(k.hash()) % etypes.size()], "team": "enemy", "entity_type": "Enemy"})
			var gb: String = String(poi.get("guardian", ""))
			if gb != "":
				node.gem = Stones.info(Dungeons.base(gb)).get("color", Color.WHITE)
				node.gem_taken = Stones.has(manager.save, Dungeons.base(gb))
				var btex: Texture2D = Nations.boss_texture(Dungeons.base(gb))
				if btex != null:
					node.enemy_tex = btex
		node.position = cell_center(pos)
		_entities.add_child(node)
		_cell_nodes[pos] = _cell_nodes.get(pos, []) + [node]
	var finds: Dictionary = AdventureTerrain.finds_of(zid)
	for fp: Vector2i in finds.keys():
		var fnode := FindNode.new()
		fnode.kind = String(finds[fp])
		fnode.position = cell_center(fp)
		_entities.add_child(fnode)
		_cell_nodes[fp] = _cell_nodes.get(fp, []) + [fnode]
	# Même ambiance vivante que les cartes isométriques classiques : les effets
	# restent une couche indépendante et ne modifient jamais l'illustration de fond.
	var ambient := SceneryAmbient.new()
	ambient.name = "Ambient"
	ambient.z_index = 4
	ambient.configure_board(BoardArt.world_size(zid), biome, absi(zid.hash()) % 997)
	ambient.position = BoardArt.world_size(zid) * 0.5
	_world.add_child(ambient)
	# V114 : couche de lumière statique (vignette, teinte chaude, taches de lumière, rayons)
	# (le diorama a déjà sa lumière, son étalonnage et sa brume cuits dans le rendu)
	if not BoardArt.is_diorama(zid):
		var light := BoardLight.new()
		light.ui = self
		light.z_index = 5
		_world.add_child(light)
	_hero = HeroView.new()
	_hero.tex = Portraits.get_texture({"classe": manager.hero_class(), "team": "player", "entity_type": "Player"})
	if zid == "foret_sylve":
		_hero.sprite_height = 118.0
		_hero.forest_style = true
	_hero.position = cell_center(manager.hero_pos())
	_entities.add_child(_hero)
	_mob_nodes.clear()
	manager.ensure_mobs()
	_sync_mobs(false)
	_refresh_world()
	_fit_world.call_deferred()


## Dégradé du ciel selon l'étage : ciel lumineux, surface (par défaut), profondeurs sombres.
func _set_sky(layer: int) -> void:
	if _bg_grad == null:
		return
	match layer:
		1:
			_bg_grad.colors = PackedColorArray([Color(0.30, 0.55, 0.88), Color(0.62, 0.80, 0.97), Color(0.90, 0.96, 1.0)])
		-1:
			_bg_grad.colors = PackedColorArray([Color(0.04, 0.03, 0.07), Color(0.10, 0.07, 0.13), Color(0.20, 0.10, 0.12)])
		_:
			_bg_grad.colors = PackedColorArray([Color(0.46, 0.62, 0.74), Color(0.72, 0.83, 0.88), Color(0.80, 0.88, 0.86)])


func _add_decor(p: Vector2i, kind: String, biome: String, pal: Dictionary, sc: float, use_sprites: bool = false, over: bool = false, hgt: int = -1) -> void:
	var d := DecorNode.new()
	d.kind = kind
	d.biome = biome
	d.pal = pal
	d.seed_value = p.x * 31 + p.y * 57 + 3
	d.scale = Vector2(sc, sc)
	d.position = cell_center(p) + Vector2(0, 6)
	d.use_sprites = use_sprites
	if hgt >= 0:
		# V114 : teinte d'altitude — les basses terres sont ombrées, les hauteurs restent claires
		d.self_modulate = Color.WHITE.darkened(clampf(1.0 - float(hgt) / 12.0, 0.0, 1.0) * 0.22)
	if over:
		# Premier plan : au-dessus du héros (z_index = _depth+2) sur sa rangée et au nord.
		d.z_index = _depth(p) + 4
	_entities.add_child(d)
	_cell_nodes[p] = _cell_nodes.get(p, []) + [d]


## Met à jour la visibilité (brouillard) et l'état des lieux.
func _refresh_world() -> void:
	var board_depth: bool = is_board()
	var hp: Vector2i = manager.hero_pos()
	_apply_hero_depth(hp)
	for p: Vector2i in _cell_nodes.keys():
		var seen: bool = manager.cell_discovered(p)
		for n: Node2D in _cell_nodes[p]:
			n.visible = seen
			if n is FindNode:
				n.visible = seen and not manager.find_taken(p)
				if board_depth:
					n.z_index = _depth(p) + 1
			if n is PoiNode:
				var pn: PoiNode = n
				# Les POI non découverts ne sont pas animés : aucun rendu visible à rafraîchir.
				pn.set_process(n.visible)
				pn.done = manager.poi_done(p) and pn.kind != "camp" and not pn.portal
				pn.locked = pn.is_dungeon and not (manager.portal_lock(manager.poi_at(p)) if pn.portal else manager.dungeon_lock(manager.poi_at(p))).is_empty()
				var near: int = 4 if board_depth else 2
				var hero_distance: int = absi(p.x - hp.x) + absi(p.y - hp.y)
				pn.nearby = hero_distance <= near and not pn.done
				# V119 : les donjons gardent leur étiquette d'état (Ouvert / Verrouillé / Terminé) en permanence.
				pn.show_label = pn.is_dungeon or ((pn.nearby or p == _board.hover) and not pn.done)
				pn.z_index = _depth(p) + (3 if pn.show_label else 1) if board_depth else (3 if pn.show_label else 0)
				pn.queue_redraw()
			elif n is GateNode:
				n.z_index = _depth(p) + 2 if board_depth else 2
	var team_lvl: int = _team_level()
	for id: int in _mob_nodes.keys():
		var mn: MobNode = _mob_nodes[id]
		mn.visible = manager.cell_discovered(mn.cell)
		mn.danger = mn.level - team_lvl
		if board_depth:
			mn.z_index = _depth(mn.cell) + 2
			var mlt: Color = light_tint(mn.cell)
			mn.modulate = Color(mlt.r, mlt.g, mlt.b, mn.modulate.a)     # l'alpha reste celui du fondu d'apparition
			if _dio_light != null:
				mn.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR     # V130 : sprites lissés sur le décor peint
	_board.queue_redraw()


## Vue défilante nécessaire ? (plateau trop grand pour tenir lisiblement dans la vue)
static func scroll_needed(zone_size: Vector2i, view: Vector2) -> bool:
	if view.x < 10.0:
		return false
	var w: float = float(zone_size.x + zone_size.y) * TILE_W * 0.5 + 90.0
	var h: float = float(zone_size.x + zone_size.y) * TILE_H * 0.5 + 320.0
	return minf(view.x / w, view.y / h) < READABLE_SCALE


func _fit_world() -> void:
	if _map_view == null or _board == null:
		return
	var size: Vector2i = manager.zone_size()
	var w: float = float(size.x + size.y) * TILE_W * 0.5 + 90.0
	var h: float = float(size.x + size.y) * TILE_H * 0.5 + 320.0
	var vs: Vector2 = _map_view.size
	if vs.x < 10.0:
		return
	if is_board():
		# planche illustrée : échelle lisible fixe, la caméra suit le héros
		_scroll_mode = true
		if _recenter_btn != null:
			_recenter_btn.visible = true
		if _zoom_in_btn != null:
			_zoom_in_btn.visible = true
		if _zoom_out_btn != null:
			_zoom_out_btn.visible = true
		if _edit_btn != null:
			_edit_btn.visible = not is_iso()
		_world.scale = Vector2.ONE * (DIORAMA_SCALE if BoardArt.is_diorama(manager.zone_id()) else (ISO_SCALE if is_iso() else BOARD_SCALE))
		_recenter(false)
		return
	_scroll_mode = scroll_needed(size, vs)
	if _edit_btn != null and _edit_btn.visible:
		_edit_btn.hide()
		_set_edit(false)
	if _recenter_btn != null:
		_recenter_btn.visible = _scroll_mode
	if _zoom_in_btn != null:
		_zoom_in_btn.visible = _scroll_mode
	if _zoom_out_btn != null:
		_zoom_out_btn.visible = _scroll_mode
	if _scroll_mode:
		# échelle fixe et lisible ; la caméra suit le héros
		_world.scale = Vector2(READABLE_SCALE, READABLE_SCALE)
		_recenter(false)
		return
	var sc: float = clampf(minf(vs.x / w, vs.y / h), 0.55, 1.9)
	_world.scale = Vector2(sc, sc)
	# centre de la grille (losange) + marge pour les décors hauts et la falaise
	var center := Vector2(float(size.x - size.y) * TILE_W * 0.25, float(size.x + size.y - 2) * TILE_H * 0.25 + 40.0)
	_world.position = vs * 0.5 - center * sc


## Rectangle du plateau en coordonnées du monde (avec marge pour décors hauts et falaise).
func _world_bounds() -> Rect2:
	if is_board():
		return Rect2(Vector2.ZERO, BoardArt.world_size(manager.zone_id()))
	var s: Vector2i = manager.zone_size()
	var left: float = -float(s.y) * TILE_W * 0.5 - 60.0
	var right: float = float(s.x) * TILE_W * 0.5 + 60.0
	var top: float = -220.0
	var bottom: float = float(s.x + s.y) * TILE_H * 0.5 + 120.0
	return Rect2(left, top, right - left, bottom - top)


## Position du monde qui garde la vue à l'intérieur du plateau (centré si le plateau est plus petit).
func _clamp_cam(pos: Vector2) -> Vector2:
	var sc: float = _world.scale.x
	var vs: Vector2 = _map_view.size
	var b: Rect2 = _world_bounds()
	var out: Vector2 = pos
	if b.size.x * sc <= vs.x:
		out.x = (vs.x - b.size.x * sc) * 0.5 - b.position.x * sc
	else:
		out.x = clampf(pos.x, vs.x - (b.position.x + b.size.x) * sc, -b.position.x * sc)
	if b.size.y * sc <= vs.y:
		out.y = (vs.y - b.size.y * sc) * 0.5 - b.position.y * sc
	else:
		out.y = clampf(pos.y, vs.y - (b.position.y + b.size.y) * sc, -b.position.y * sc)
	return out


## Caméra centrée sur une case (vue défilante uniquement).
func _focus_cell(c: Vector2i, animated: bool, dur: float = 0.25) -> void:
	if not _scroll_mode or _map_view == null:
		return
	var target: Vector2 = _clamp_cam(_map_view.size * 0.5 - cell_center(c) * _world.scale.x)
	if _cam_tween != null and _cam_tween.is_valid():
		_cam_tween.kill()
	if animated and dur > 0.0:
		_cam_tween = create_tween()
		_cam_tween.tween_property(_world, "position", target, dur).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	else:
		_world.position = target


func _recenter(animated: bool) -> void:
	_focus_cell(manager.hero_pos(), animated, 0.3)


## Glisser pour parcourir un grand plateau. Retourne true si l'événement est consommé
## (un glissement n'est jamais interprété comme un appui sur une case).
func _handle_pan(event: InputEvent) -> bool:
	if event is InputEventScreenTouch:
		if event.pressed:
			_touch_points[int(event.index)] = event.position
			if _touch_points.size() >= 2:
				_start_pinch()
				return true
			_pan_active = true
			_pan_moved = false
			_pan_total = 0.0
			return false
		_touch_points.erase(int(event.index))
		if _pinch_active:
			_pinch_active = false
			_pan_active = _touch_points.size() == 1
			_pan_moved = true
			return true
		var was_moved: bool = _pan_moved
		_pan_active = false
		_pan_moved = false
		return was_moved
	if event is InputEventScreenDrag:
		if _touch_points.has(int(event.index)):
			_touch_points[int(event.index)] = event.position
		if _pinch_active and _touch_points.size() >= 2:
			_update_pinch()
			return true
		if _pan_active:
			return _pan_by(event.relative)
	if event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN) and event.pressed:
		_zoom_at(event.position, 1.12 if event.button_index == MOUSE_BUTTON_WHEEL_UP else 1.0 / 1.12)
		return true
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.device != InputEvent.DEVICE_ID_EMULATION:
		if event.pressed:
			_pan_active = true
			_pan_moved = false
			_pan_total = 0.0
			return false
		var was2: bool = _pan_moved
		_pan_active = false
		_pan_moved = false
		return was2
	if event is InputEventMouseMotion and _pan_active and event.device != InputEvent.DEVICE_ID_EMULATION \
			and (event.button_mask & MOUSE_BUTTON_MASK_LEFT) != 0:
		return _pan_by(event.relative)
	return false


func _start_pinch() -> void:
	var ids: Array = _touch_points.keys()
	var a: Vector2 = _touch_points[ids[0]]
	var b: Vector2 = _touch_points[ids[1]]
	_pinch_start_distance = maxf(a.distance_to(b), 1.0)
	_pinch_start_scale = _world.scale.x
	_pinch_active = true
	_pan_active = false
	_pan_moved = true
	if _cam_tween != null and _cam_tween.is_valid():
		_cam_tween.kill()


func _update_pinch() -> void:
	var ids: Array = _touch_points.keys()
	if ids.size() < 2:
		return
	var a: Vector2 = _touch_points[ids[0]]
	var b: Vector2 = _touch_points[ids[1]]
	var distance: float = maxf(a.distance_to(b), 1.0)
	var center: Vector2 = (a + b) * 0.5
	var next_scale: float = clampf(_pinch_start_scale * distance / _pinch_start_distance, MAP_ZOOM_MIN, MAP_ZOOM_MAX)
	var old_scale: float = _world.scale.x
	if is_equal_approx(next_scale, old_scale):
		return
	var world_anchor: Vector2 = (center - _world.position) / old_scale
	_world.scale = Vector2(next_scale, next_scale)
	_world.position = _clamp_cam(center - world_anchor * next_scale)


func _zoom_at(screen_point: Vector2, factor: float) -> void:
	if not _scroll_mode or _map_view == null:
		return
	if _cam_tween != null and _cam_tween.is_valid():
		_cam_tween.kill()
	var old_scale: float = _world.scale.x
	var next_scale: float = clampf(old_scale * factor, MAP_ZOOM_MIN, MAP_ZOOM_MAX)
	if is_equal_approx(next_scale, old_scale):
		return
	var world_anchor: Vector2 = (screen_point - _world.position) / old_scale
	_world.scale = Vector2(next_scale, next_scale)
	_world.position = _clamp_cam(screen_point - world_anchor * next_scale)


func _pan_by(rel: Vector2) -> bool:
	_pan_total += rel.length()
	if _pan_total < PAN_THRESHOLD and not _pan_moved:
		return false
	_pan_moved = true
	if _cam_tween != null and _cam_tween.is_valid():
		_cam_tween.kill()
	_world.position = _clamp_cam(_world.position + rel)
	return true


# ══════════════════════════════════════════════════════════════════════
#  Projection
# ══════════════════════════════════════════════════════════════════════

## V83 : la zone courante est-elle une planche illustrée (grille à plat sur l'image) ?
func is_board() -> bool:
	return manager != null and not BoardArt.def(manager.zone_id()).is_empty()


## V106 : plateau isométrique à étages (cases plus petites, hauteurs).
func is_iso() -> bool:
	return is_board() and BoardArt.is_iso(manager.zone_id())


## Ordre de profondeur d'une case (z_index) : la rangée en planche plate, la diagonale x+y en isométrique.
func _depth(p: Vector2i) -> int:
	return (p.x + p.y) * 4 if is_iso() else p.y * 4


func cell_center(p: Vector2i) -> Vector2:
	if is_iso():
		return BoardArt.iso_pos(manager.zone_id(), p)
	if is_board():
		return (Vector2(p) + Vector2(0.5, 0.5)) * BoardArt.cell_world(manager.zone_id())
	return Vector2(float(p.x - p.y) * TILE_W * 0.5, float(p.x + p.y) * TILE_H * 0.5)


## Échelle et ordre de profondeur de la planche : le héros grandit légèrement vers le premier plan.
func _hero_depth_scale(p: Vector2i) -> Vector2:
	if not is_board():
		return Vector2.ONE
	if is_iso():
		return Vector2.ONE * 0.72
	var max_y: int = maxi(1, manager.zone_size().y - 1)
	var depth: float = clampf(float(p.y) / float(max_y), 0.0, 1.0)
	var factor: float = lerpf(0.86, 1.12, depth)
	if manager.zone_id() == "foret_sylve":
		factor = lerpf(0.94, 1.18, depth)
	return Vector2.ONE * factor


## V130 : teinte de lumière locale d'un personnage posé sur cette case du diorama (blanc ailleurs).
## Lue dans la carte de lumière : sous-bois → plus sombre et vert ; près de la lave → orangé ; plein soleil → neutre.
func light_tint(p: Vector2i) -> Color:
	if _dio_light == null:
		return Color.WHITE
	var q: Vector2 = (cell_center(p) - _dio_light_pos) / _dio_light_scale
	var x: int = clampi(int(q.x), 0, _dio_light.get_width() - 1)
	var y: int = clampi(int(q.y), 0, _dio_light.get_height() - 1)
	var c: Color = _dio_light.get_pixel(x, y)
	var m: float = maxf(maxf(c.r, c.g), maxf(c.b, 0.001))
	var lum: float = c.r * 0.299 + c.g * 0.587 + c.b * 0.114
	var k: float = lerpf(0.78, 1.05, smoothstep(0.18, 0.62, lum))
	var hue: Color = Color.WHITE.lerp(Color(c.r / m, c.g / m, c.b / m), 0.28)
	return Color(hue.r * k, hue.g * k, hue.b * k, 1.0)


func _apply_hero_depth(p: Vector2i) -> void:
	if _hero == null:
		return
	_hero.scale = _hero_depth_scale(p)
	if _dio_light != null:
		_hero.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR         # V130 : sprite lissé sur le décor peint
	_hero.light_target = light_tint(p)
	_hero.z_index = _depth(p) + 2 if is_board() else 0


func screen_to_cell(local: Vector2) -> Vector2i:
	if is_iso():
		return BoardArt.iso_cell_at(manager.zone_id(), local)
	if is_board():
		var cwz: float = BoardArt.cell_world(manager.zone_id())
		return Vector2i(floori(local.x / cwz), floori(local.y / cwz))
	var gx: float = (local.y / (TILE_H * 0.5) + local.x / (TILE_W * 0.5)) * 0.5
	var gy: float = (local.y / (TILE_H * 0.5) - local.x / (TILE_W * 0.5)) * 0.5
	return Vector2i(roundi(gx), roundi(gy))


## Les icônes flottantes des lieux ont une zone tactile dédiée, plus large que leur case au sol.
func _pointer_to_cell(screen_pos: Vector2) -> Vector2i:
	var world_pos: Vector2 = (screen_pos - _world.position) / _world.scale.x
	var best: Vector2i = Vector2i(-1, -1)
	var best_distance: float = INF
	for p: Vector2i in _cell_nodes.keys():
		for node: Node2D in _cell_nodes[p]:
			if not (node is PoiNode) or not node.visible:
				continue
			var poi_node: PoiNode = node
			var icon_center: Vector2 = cell_center(p) + Vector2(0, -112.0 if poi_node.is_dungeon else -94.0)
			var hit_radius: float = 48.0 if poi_node.is_dungeon else 42.0
			var distance: float = world_pos.distance_squared_to(icon_center)
			if distance <= hit_radius * hit_radius and distance < best_distance:
				best = p
				best_distance = distance
	return best if best.x >= 0 else screen_to_cell(world_pos)


func _inside(p: Vector2i) -> bool:
	var s: Vector2i = manager.zone_size()
	return p.x >= 0 and p.y >= 0 and p.x < s.x and p.y < s.y


# ══════════════════════════════════════════════════════════════════════
#  Entrées
# ══════════════════════════════════════════════════════════════════════

func _on_map_input(event: InputEvent) -> void:
	if _modal_root != null:
		return
	if _edit_on and _edit_mode != "move":
		_edit_input(event)
		return
	if _scroll_mode and _handle_pan(event):
		return
	if _walking:
		# Pendant la marche, un nouvel appui change de destination (après le pas en cours).
		var released: bool = (event is InputEventScreenTouch and not event.pressed) \
			or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and event.device != InputEvent.DEVICE_ID_EMULATION)
		if released:
			var cr: Vector2i = _pointer_to_cell(event.position)
			if _inside(cr):
				_redirect = cr
		return
	if event is InputEventMouseMotion:
		var c: Vector2i = _pointer_to_cell(event.position)
		_board.hover = c if _inside(c) else Vector2i(-1, -1)
		if _pending.x < 0:
			_board.preview = manager.path_to(c) if _inside(c) and c != manager.hero_pos() else []
		_refresh_world()
	elif event is InputEventScreenTouch and not event.pressed:
		# Tactile : un premier appui montre le trajet, le second confirme.
		var ct: Vector2i = _pointer_to_cell(event.position)
		if _inside(ct):
			_on_cell_tapped(ct, true)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		# Les clics émulés par le tactile sont déjà traités par l'événement tactile.
		if event.device == InputEvent.DEVICE_ID_EMULATION:
			return
		var c2: Vector2i = _pointer_to_cell(event.position)
		if _inside(c2):
			_on_cell_tapped(c2, false)


## Case découverte et accessible la plus proche d'une case cachée par le brouillard.
func _nearest_reachable(target: Vector2i) -> Vector2i:
	var best: Vector2i = Vector2i(-1, -1)
	var best_d: int = 1 << 30
	var size: Vector2i = manager.zone_size()
	for y: int in range(size.y):
		for x: int in range(size.x):
			var c := Vector2i(x, y)
			if c == manager.hero_pos() or not manager.cell_discovered(c):
				continue
			var d: int = absi(c.x - target.x) + absi(c.y - target.y)
			if d >= best_d or not AdventureTerrain.walkable(manager.zone_id(), c):
				continue
			if manager.path_to(c).is_empty():
				continue
			best = c
			best_d = d
	return best


## ── V84 : outil de retouche du masque (planche) ──
func _build_edit_ui() -> void:
	_edit_btn = Button.new()
	_edit_btn.text = "✎  Masque"
	_edit_btn.focus_mode = Control.FOCUS_NONE
	_edit_btn.add_theme_font_size_override("font_size", 22)
	_edit_btn.anchor_top = 1.0
	_edit_btn.anchor_bottom = 1.0
	_edit_btn.offset_left = 204.0
	_edit_btn.offset_top = -316.0
	_edit_btn.offset_right = 390.0
	_edit_btn.offset_bottom = -256.0
	_edit_btn.pressed.connect(func() -> void: _set_edit(not _edit_on))
	_edit_btn.hide()
	_map_view.add_child(_edit_btn)
	_edit_btn.z_index = 1321   # au-dessus des nœuds du monde (z_index de profondeur de la planche, jusqu'à ~600 sur un plateau iso 72x72)
	_edit_bar = HBoxContainer.new()
	_edit_bar.add_theme_constant_override("separation", 8)
	_edit_bar.anchor_top = 1.0
	_edit_bar.anchor_bottom = 1.0
	_edit_bar.offset_left = 250.0
	_edit_bar.offset_top = -392.0
	_edit_bar.offset_bottom = -332.0
	_edit_bar.offset_right = 1450.0
	_edit_bar.hide()
	_map_view.add_child(_edit_bar)
	_edit_bar.z_index = 1321   # au-dessus des nœuds du monde (z_index de profondeur de la planche, jusqu'à ~600 sur un plateau iso 72x72)
	var defs: Array = [["open", "🟢 Ouvrir"], ["close", "🔴 Fermer"], ["move", "✋ Déplacer"],
		["save", "💾 Enregistrer"], ["copy", "📋 Copier"], ["reset", "↺ Annuler tout"]]
	for d: Array in defs:
		var b := Button.new()
		b.text = String(d[1])
		b.focus_mode = Control.FOCUS_NONE
		b.add_theme_font_size_override("font_size", 22)
		var id: String = String(d[0])
		b.pressed.connect(func() -> void: _edit_action(id))
		_edit_bar.add_child(b)


func _set_edit(on: bool) -> void:
	_edit_on = on and is_board() and not is_iso()
	_edit_mode = "open"
	if _edit_bar != null:
		_edit_bar.visible = _edit_on
	_board.queue_redraw()


func _edit_action(id: String) -> void:
	var zid: String = manager.zone_id()
	match id:
		"open", "close", "move":
			_edit_mode = id
		"save":
			var df: Dictionary = BoardArt.save_edits(zid)
			_toast_show("Masque enregistré (%d ouvertes, %d fermées)" % [df["open"].size(), df["close"].size()], 22)
		"copy":
			DisplayServer.clipboard_set(JSON.stringify(BoardArt.diff(zid)))
			_toast_show("Retouches copiées dans le presse-papiers", 22)
		"reset":
			BoardArt.reset_edits(zid)
			_board.queue_redraw()
			_toast_show("Retouches annulées", 22)


func _edit_input(event: InputEvent) -> void:
	var pressed_pos: Variant = null
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.device == InputEvent.DEVICE_ID_EMULATION:
			return
		_edit_drag = event.pressed
		if event.pressed:
			pressed_pos = event.position
	elif event is InputEventMouseMotion and _edit_drag and event.device != InputEvent.DEVICE_ID_EMULATION:
		pressed_pos = event.position
	elif event is InputEventScreenTouch:
		_edit_drag = event.pressed
		if event.pressed:
			pressed_pos = event.position
	elif event is InputEventScreenDrag and _edit_drag:
		pressed_pos = event.position
	if pressed_pos == null:
		return
	var c: Vector2i = screen_to_cell(((pressed_pos as Vector2) - _world.position) / _world.scale.x)
	if _inside(c):
		BoardArt.set_cell(manager.zone_id(), c, _edit_mode == "open")
		_board.queue_redraw()


## V84 (planche) : case libre atteignable la plus proche d'une case bloquée.
func _board_nearest_free(target: Vector2i) -> Vector2i:
	var zid: String = manager.zone_id()
	var cands: Array = []
	for dy: int in range(-14, 15):
		for dx: int in range(-14, 15):
			var c := Vector2i(target.x + dx, target.y + dy)
			if c != manager.hero_pos() and _inside(c) and AdventureTerrain.walkable(zid, c):
				cands.append([dx * dx + dy * dy, c])
	cands.sort_custom(func(a: Array, b: Array) -> bool: return a[0] < b[0])
	for i: int in range(mini(24, cands.size())):
		if not manager.path_to(cands[i][1]).is_empty():
			return cands[i][1]
	return Vector2i(-1, -1)


func _on_cell_tapped(p: Vector2i, _touch: bool = false) -> void:
	if p == manager.hero_pos():
		_pending = Vector2i(-1, -1)
		if not manager.gate_at(p).is_empty():
			_cross_gate(p)
			return
		_interact()
		return
	# Groupe de monstres : on va à son contact puis on propose le combat.
	var g: Dictionary = manager.mob_at(p) if manager.cell_discovered(p) else {}
	if not g.is_empty():
		var hp: Vector2i = manager.hero_pos()
		if absi(hp.x - p.x) + absi(hp.y - p.y) == 1:
			_confirm_mob(g)
			return
		var mpath: Array[Vector2i] = manager.path_to(p)
		if mpath.size() < 2:
			_say("Aucun sentier ne mène à ce groupe pour l'instant.")
			return
		mpath.remove_at(mpath.size() - 1)
		_target_mob = int(g["id"])
		_walk(mpath)
		return
	var target: Vector2i = p
	if not manager.cell_discovered(p):
		# Brouillard : on avance jusqu'à la case connue la plus proche pour l'explorer.
		target = _nearest_reachable(p)
		if target.x < 0:
			_say("Le brouillard est trop dense par là. Explorez les environs.")
			return
	elif not AdventureTerrain.walkable(manager.zone_id(), p):
		if is_board():
			# V84 : un appui sur un obstacle mène à la case libre la plus proche.
			target = _board_nearest_free(p)
			if target.x < 0:
				_say("Le passage est bloqué par le décor.")
				return
		else:
			_say("Le passage est bloqué par le décor.")
			return
	var path: Array[Vector2i] = manager.path_to(target)
	if path.is_empty():
		_say("Aucun sentier ne mène là pour l'instant.")
		return
	# Un seul appui suffit : le trajet s'affiche pendant la marche.
	_pending = Vector2i(-1, -1)
	_target_mob = -1
	if not manager.cell_discovered(p):
		_toast_show("Vous avancez au plus près…", 22)
	_walk(path)


func _walk(path: Array[Vector2i]) -> void:
	_walking = true
	_redirect = Vector2i(-1, -1)
	_pending = Vector2i(-1, -1)
	_board.preview = path.duplicate()
	_action_btn.hide()
	# les longs trajets sont plus rapides (jusqu'à deux fois)
	var sprint: bool = is_board() and path.size() >= 8
	var step_time: float = STEP_TIME * clampf(8.0 / float(maxi(1, path.size())), 0.5, 1.0)
	if is_board():
		step_time = BOARD_STEP_TIME * (0.72 if sprint else 1.0)
	# V114 : déplacement continu — UNE seule tween le long d'une polyligne à coins
	# arrondis (vitesse constante au milieu, accélération/décélération globales),
	# au lieu d'un arrêt à chaque case. La logique par case (monstres, trouvailles,
	# lieux, événements) est inchangée : elle se déclenche à chaque frontière de case.
	var pts: Array[Vector2] = [_hero.position]
	for s0: Vector2i in path:
		pts.append(cell_center(s0))
	var sp: Array = _smooth_path(pts)
	var cum: Array[float] = [0.0]
	for i: int in range(1, sp.size()):
		cum.append(cum[i - 1] + float(sp[i].distance_to(sp[i - 1])))
	var total_len: float = maxi(0.001, float(cum.back()))
	var dur: float = step_time * float(maxi(1, path.size()))
	_walk_s = 0.0
	_walk_stop_s = total_len
	var tw := create_tween()
	tw.tween_method(func(f: float) -> void:
		var s: float = clampf(f, 0.0, 1.0) * total_len
		if s > _walk_stop_s:
			s = _walk_stop_s
		_walk_s = s
		var k: int = 0
		while k < cum.size() - 2 and cum[k + 1] <= s:
			k += 1
		var seg: float = maxi(0.001, float(cum[k + 1] - cum[k]))
		var lt: float = clampf((s - cum[k]) / seg, 0.0, 1.0)
		_hero.position = sp[k].lerp(sp[k + 1], lt)
		_hero.hop = sin(lt * PI) * 7.0
		if is_board() and path.size() > 0:
			var c0: Vector2i = path[maxi(0, k - 1)]
			var c1: Vector2i = path[mini(path.size() - 1, k)]
			_hero.scale = _hero_depth_scale(c0).lerp(_hero_depth_scale(c1), lt)
	, 0.0, 1.0, dur).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	for j: int in range(path.size()):
		var step: Vector2i = path[j]
		await _walk_until(tw, float(cum[j]))       # départ de la case j (point j atteint)
		if not tw.is_running():
			break
		if _redirect.x >= 0:
			_walk_stop_s = float(cum[j])
			break
		if not manager.mob_at(step).is_empty():
			_say("Un groupe de monstres vous barre la route.")
			_walk_stop_s = float(cum[j])
			break
		_hero.locomotion(cell_center(step) - _hero.position, true, sprint)
		var t_step: int = Time.get_ticks_usec()
		var fresh: Array = manager.move_hero(step)
		if _board.preview.size() > 0:
			_board.preview.remove_at(0)
		if is_board():
			_hero.z_index = _depth(step) + 2
		_after_step()
		_perf_t("pas", t_step)
		if not _pan_moved:
			_focus_cell(step, true, step_time)
		await _walk_until(tw, float(cum[j + 1]))   # arrivée sur la case
		if not tw.is_running():
			break
		if not fresh.is_empty():
			var t_maj: int = Time.get_ticks_usec()
			_refresh_world()
			_perf_t("maj", t_maj)
		var got: Dictionary = manager.collect_find(step)
		if not got.is_empty():
			_hero.react()
			# V114 : flash lumineux sur la trouvaille
			var fl := FxFlash.new()
			fl.position = cell_center(step)
			fl.z_index = 3
			_world.add_child(fl)
			_toast_show("✦ " + String(got["text"]), 24)
			_log(String(got["text"]) + ".")
			_refresh_world()
			_refresh_side()
			if _check_mastery():
				if tw.is_running():
					tw.kill()
				_walk_place_hero(sp, cum)
				_hero.locomotion(Vector2.ZERO, false)
				_hero.hop = 0.0
				_walking = false
				_board.preview = []
				return
		var poi: Dictionary = manager.poi_at(step)
		# Une entrée de donjon située au milieu du chemin est franchie sans ouvrir
		# le donjon. Elle déclenche l'interaction uniquement si elle est la destination.
		var dungeon_transit: bool = Dungeons.is_dungeon(poi) and step != path.back()
		if not poi.is_empty() and not dungeon_transit:
			_hero.react()
		if (not poi.is_empty() and not dungeon_transit) or not manager.gate_at(step).is_empty():
			_walk_stop_s = float(cum[j + 1])
			break
		var ev: Dictionary = manager.roll_event(_rng)
		if not ev.is_empty():
			_show_event(ev)
	if tw.is_running():
		tw.kill()
	_walk_place_hero(sp, cum)
	_hero.locomotion(Vector2.ZERO, false)
	_hero.hop = 0.0
	_walking = false
	_board.preview = []
	if _help_panel != null and manager.moves() >= HELP_STEPS:
		_help_panel.visible = false
	_refresh_world()
	# Nouvelle destination touchée en route
	if _redirect.x >= 0:
		var r: Vector2i = _redirect
		_redirect = Vector2i(-1, -1)
		_on_cell_tapped(r)
		return
	# Groupe visé : combat s'il est au contact
	if _target_mob >= 0:
		var tid: int = _target_mob
		_target_mob = -1
		for g: Dictionary in manager.mobs():
			if int(g["id"]) == tid:
				var gp: Vector2i = AdventureMobs.pos_of(g)
				var hp: Vector2i = manager.hero_pos()
				if absi(gp.x - hp.x) + absi(gp.y - hp.y) == 1:
					_refresh_side()
					_confirm_mob(g)
					return
	if not manager.gate_at(manager.hero_pos()).is_empty():
		_cross_gate(manager.hero_pos())
		return
	var here: Dictionary = manager.poi_at(manager.hero_pos())
	if not here.is_empty():
		var kind: String = String(here.get("kind", ""))
		var done: bool = manager.poi_done(manager.hero_pos()) and kind != "camp"
		_toast_show(String(here.get("name", "")))
		_log("Vous arrivez : %s." % String(here.get("name", "")))
		_refresh_side()
		if not done:
			if kind == "combat":
				_confirm_combat(here)
			else:
				_interact()
		elif kind == "camp":
			_interact()
		return
	_refresh_side()


## V114 : coins arrondis d'une polyligne — chaque sommet intérieur est tiré vers le
## milieu de ses deux voisins (extrémités inchangées).
func _smooth_path(pts: Array[Vector2]) -> Array[Vector2]:
	var out: Array[Vector2] = []
	for i: int in range(pts.size()):
		if i == 0 or i == pts.size() - 1 or pts.size() < 3:
			out.append(pts[i])
		else:
			out.append((pts[i - 1] + pts[i] * 2.0 + pts[i + 1]) * 0.25)
	return out


## V114 : attend que le trajet continu atteigne la longueur d'arc target_s (ou que la tween meure).
func _walk_until(tw: Tween, target_s: float) -> void:
	while tw.is_valid() and tw.is_running() and _walk_s < target_s:
		await get_tree().process_frame


## V114 : cale le héros sur la polyligne à la position atteinte (min(s, stop_s)).
func _walk_place_hero(sp: Array, cum: Array[float]) -> void:
	var s: float = minf(_walk_s, _walk_stop_s)
	var k: int = 0
	while k < cum.size() - 2 and cum[k + 1] <= s:
		k += 1
	var seg: float = maxi(0.001, float(cum[k + 1] - cum[k]))
	var lt: float = clampf((s - cum[k]) / seg, 0.0, 1.0)
	_hero.position = sp[k].lerp(sp[k + 1], lt)
	_hero.hop = 0.0


## Après chaque pas : les groupes flânent, un groupe réapparaît si le délai est écoulé.
func _after_step() -> void:
	var moved: Array = manager.wander_mobs(_target_mob)
	var added: Array = manager.ensure_mobs()
	if not moved.is_empty() or not added.is_empty():
		var t_mob: int = Time.get_ticks_usec()
		_sync_mobs(true)
		_perf_t("mob", t_mob)


## Passage d'une carte à l'autre : le héros sort par le bord de l'île, un voile
## de nuages couvre l'écran, la carte voisine se construit et le héros y entre
## par la porte opposée.
func _cross_gate(pos: Vector2i) -> void:
	var g: Dictionary = manager.gate_at(pos)
	if g.is_empty() or _walking:
		return
	if not bool(g.get("open", false)):
		_say(String(g.get("reason", "La route est fermée.")))
		_log("Route vers %s gardée." % String(g.get("name", "?")))
		_refresh_side()
		return
	_walking = true
	var dir: String = String(g["dir"])
	var out_vec: Vector2 = GATE_VEC[dir]
	_hero.face(out_vec.x)
	var climb: int = int(g.get("climb", 0))
	var tw := create_tween()
	var out_pos: Vector2 = _hero.position + out_vec * 1.3
	var dur: float = 0.38
	if climb > 0:
		# courant ascendant : le héros s'élève, voile blanc
		_fade.color = Color(0.92, 0.97, 1.0, 0.0)
		out_pos += Vector2(0, -170)
		dur = 0.7
		_toast_show(String(g.get("text", "")), 22)
	elif climb < 0:
		# descente : le héros s'enfonce, voile sombre
		_fade.color = Color(0.03, 0.02, 0.06, 0.0)
		out_pos += Vector2(0, 90)
		dur = 0.7
		_toast_show(String(g.get("text", "")), 22)
	_fade.visible = true
	tw.tween_property(_hero, "position", out_pos, dur)
	tw.parallel().tween_property(_fade, "color:a", 1.0, dur)
	await tw.finished
	if not manager.cross_gate(pos):
		_fade.color.a = 0.0
		_fade.visible = false
		_walking = false
		_rebuild_world()
		return
	var lvl: int = ProgressionManager.adventure_zone_level(manager.zone_id())
	_log("Arrivée : %s." % manager.zone_name())
	_rebuild_world()
	await get_tree().process_frame
	var back: String = String(ProgressionManager.ADVENTURE_OPPOSITE[dir])
	var target: Vector2 = _hero.position
	var gate_back: Vector2i = ProgressionManager.adventure_gate_cell(manager.zone_id(), back)
	_hero.position = cell_center(gate_back) + GATE_VEC[back] * 0.9
	_hero.face(target.x - _hero.position.x)
	var tw2 := create_tween()
	tw2.tween_property(_fade, "color:a", 0.0, 0.42 if climb == 0 else 0.7)
	tw2.parallel().tween_property(_hero, "position", target, 0.55).set_delay(0.08)
	await tw2.finished
	_walking = false
	_fade.color = Color(0.86, 0.91, 0.95, 0.0)
	_fade.visible = false
	_refresh_world()
	_refresh_side()
	var team_lvl: int = 1
	for m: Dictionary in _save.get("team", []):
		team_lvl = maxi(team_lvl, ProgressionManager.member_level(_save, String(m.get("classe", ""))))
	var trait_txt: String = BiomeEffects.title(manager.zone_biome())
	if trait_txt != "":
		_log("Particularité des combats ici : %s." % BiomeEffects.describe(manager.zone_biome()))
	if lvl > team_lvl + 3:
		_toast_show("%s · niv %d — terres dangereuses !" % [manager.zone_name(), lvl])
	else:
		_toast_show("%s · niv %d" % [manager.zone_name(), lvl])


# ══════════════════════════════════════════════════════════════════════
#  Panneau latéral
# ══════════════════════════════════════════════════════════════════════

func _refresh_side() -> void:
	for c: Node in _side_box.get_children():
		c.queue_free()
	# En-tête
	var head := HBoxContainer.new()
	head.add_theme_constant_override("separation", 10)
	_side_box.add_child(head)
	head.add_child(U.lbl("🧭 AVENTURE", 28, U.C_GOLD, true))
	head.add_child(U.spacer())
	var back := U.btn("← MES PARTIES", Color(0.55, 0.62, 0.80), 20, Vector2(190, 56))
	back.pressed.connect(_back_to_save)
	head.add_child(back)

	# Lieu courant
	_side_box.add_child(_place_card())

	# Zone
	var zone_card := PanelContainer.new()
	zone_card.add_theme_stylebox_override("panel", U.box(U.C_CARD, U.C_BORDER, 14, 2, 12))
	_side_box.add_child(zone_card)
	var zv := VBoxContainer.new()
	zv.add_theme_constant_override("separation", 6)
	zone_card.add_child(zv)
	zv.add_child(U.lbl(manager.zone_name(), 24, U.C_TXT, true))
	zv.add_child(U.lbl("%s · niveau %d" % [ProgressionManager.biome_label(manager.zone_biome()),
		ProgressionManager.adventure_zone_level(manager.zone_id())], 18, DIM))
	var prog: Dictionary = manager.zone_progress()
	zv.add_child(_bar_row("Lieux explorés", float(prog["done"]), float(maxi(1, int(prog["total"]))),
		"%d / %d" % [int(prog["done"]), int(prog["total"])], Color(0.95, 0.75, 0.30)))
	zv.add_child(_bar_row("Carte révélée", float(prog["fog"]) * 100.0, 100.0,
		"%d %%" % int(float(prog["fog"]) * 100.0), Color(0.45, 0.80, 1.0)))

	# Explorateur
	var hero_card := PanelContainer.new()
	hero_card.add_theme_stylebox_override("panel", U.box(U.C_CARD, U.C_BORDER, 14, 2, 12))
	_side_box.add_child(hero_card)
	var hv := VBoxContainer.new()
	hv.add_theme_constant_override("separation", 6)
	hero_card.add_child(hv)
	var hrow := HBoxContainer.new()
	hrow.add_theme_constant_override("separation", 12)
	hv.add_child(hrow)
	var hclass: String = manager.hero_class()
	hrow.add_child(U.portrait(hclass, 68.0))
	var hinfo := VBoxContainer.new()
	hinfo.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hrow.add_child(hinfo)
	hinfo.add_child(U.lbl("Explorateur", 18, DIM))
	hinfo.add_child(U.lbl("%s · niv %d" % [hclass, ProgressionManager.member_level(_save, hclass)], 22, U.C_TXT))
	var team_row := HBoxContainer.new()
	team_row.add_theme_constant_override("separation", 6)
	hinfo.add_child(team_row)
	for m: Dictionary in _save.get("team", []):
		var cls: String = String(m.get("classe", ""))
		if cls == hclass:
			continue
		var b := U.btn("", Color(0.55, 0.62, 0.80), 12, Vector2(56, 56))
		b.tooltip_text = "Explorer avec : %s" % cls
		var pic: Control = U.portrait(cls, 46.0)
		pic.mouse_filter = Control.MOUSE_FILTER_IGNORE
		pic.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		b.add_child(pic)
		b.pressed.connect(func() -> void:
			manager.set_hero_class(cls)
			_hero.tex = Portraits.get_texture({"classe": cls, "team": "player", "entity_type": "Player"})
			_hero.queue_redraw()
			_refresh_side())
		team_row.add_child(b)

	# Ressources communes : ce panneau reflète directement la sauvegarde partagée.
	var resources: Dictionary = _save.get("resources", {})
	var resource_card := PanelContainer.new()
	resource_card.add_theme_stylebox_override("panel", U.box(Color(0.08, 0.12, 0.15), Color(0.42, 0.72, 0.58), 14, 1, 12))
	_side_box.add_child(resource_card)
	var rv := VBoxContainer.new()
	rv.add_theme_constant_override("separation", 5)
	resource_card.add_child(rv)
	rv.add_child(U.lbl("SAC DE RESSOURCES", 18, Color(0.62, 0.88, 0.72), true))
	var resource_names: Array = resources.keys()
	resource_names.sort()
	if resource_names.is_empty():
		rv.add_child(U.lbl("Aucune ressource récoltée", 17, DIM))
	else:
		var resource_text := ""
		for ri: int in range(resource_names.size()):
			var resource_name: String = String(resource_names[ri])
			if ri > 0:
				resource_text += "   ·   "
			resource_text += "%s %d" % [resource_name, int(resources[resource_name])]
			if ri % 3 == 2 or ri == resource_names.size() - 1:
				var resource_line: Label = U.lbl(resource_text, 17, U.C_TXT)
				resource_line.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
				rv.add_child(resource_line)
				resource_text = ""

	# Journal
	var journal: Array = manager.state.get("journal", [])
	if not journal.is_empty():
		var jc := PanelContainer.new()
		jc.add_theme_stylebox_override("panel", U.box(Color(0.08, 0.10, 0.16), U.C_BORDER, 14, 1, 12))
		_side_box.add_child(jc)
		var jv := VBoxContainer.new()
		jv.add_theme_constant_override("separation", 4)
		jc.add_child(jv)
		jv.add_child(U.lbl("JOURNAL", 18, U.C_GOLD))
		for i: int in range(journal.size() - 1, maxi(-1, journal.size() - 5), -1):
			var l: Label = U.lbl("• " + String(journal[i]), 18, U.C_TXT if i == journal.size() - 1 else DIM)
			l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			jv.add_child(l)

	# Monde : mini-carte des cartes visitées (voyage rapide)
	_side_box.add_child(U.lbl("MONDE DE ZIMUT", 18, U.C_GOLD))
	var mm := MiniMap.new()
	mm.ui = self
	mm.custom_minimum_size = Vector2(0, 280)
	_side_box.add_child(mm)
	var legend := U.lbl("▲ Ciel (Vents, Brumes)   ▼ Profondeurs (Ombres, Cristaux, Brasier)", 17, DIM)
	legend.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_side_box.add_child(legend)
	var hint := U.lbl("Marchez jusqu'aux flèches au bord de l'île pour passer à la carte voisine. Touchez une carte déjà visitée pour y voyager.", 19, DIM)
	hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_side_box.add_child(hint)
	var foot := U.lbl("XP, objets, or et ressources : sauvegarde commune aux quatre modes.", 19, DIM)
	foot.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_side_box.add_child(foot)
	_refresh_hud()


func _bar_row(title: String, value: float, maximum: float, txt: String, col: Color) -> Control:
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 2)
	var h := HBoxContainer.new()
	h.add_child(U.lbl(title, 17, DIM))
	h.add_child(U.spacer())
	h.add_child(U.lbl(txt, 17, U.C_TXT))
	v.add_child(h)
	var pb := ProgressBar.new()
	pb.custom_minimum_size = Vector2(0, 16)
	pb.show_percentage = false
	pb.max_value = maximum
	pb.value = value
	U.style_bar(pb, col)
	v.add_child(pb)
	return v


func _place_card() -> Control:
	var pos: Vector2i = manager.hero_pos()
	var poi: Dictionary = manager.poi_at(pos)
	var card := PanelContainer.new()
	var kind: String = String(poi.get("kind", ""))
	var col: Color = POI_COLOR.get(kind, U.C_BORDER)
	card.add_theme_stylebox_override("panel", U.box(Color(0.10, 0.12, 0.19), col, 14, 2, 14))
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 8)
	card.add_child(v)
	var gate: Dictionary = manager.gate_at(pos)
	if poi.is_empty() and not gate.is_empty():
		var gcol: Color = Color(0.55, 1.0, 0.55) if bool(gate["open"]) else Color(1.0, 0.45, 0.40)
		card.add_theme_stylebox_override("panel", U.box(Color(0.10, 0.12, 0.19), gcol, 14, 2, 14))
		v.add_child(U.lbl("ROUTE DU %s" % String(ProgressionManager.ADVENTURE_DIR_LABEL[String(gate["dir"])]).to_upper(), 18, U.C_GOLD))
		v.add_child(U.lbl("%s · niv %d" % [String(gate["name"]), int(gate["level"])], 21, U.C_TXT, true))
		if bool(gate["open"]):
			var gb := U.btn("➜  PASSER LA FRONTIÈRE", gcol, 24, Vector2(0, 72))
			gb.pressed.connect(_cross_gate.bind(pos))
			v.add_child(gb)
		else:
			var rl: Label = U.lbl("🔒 " + String(gate["reason"]), 19, U.C_BAD)
			rl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			v.add_child(rl)
		return card
	if poi.is_empty():
		_objectives_into(v)
		return card
	var done: bool = manager.poi_done(pos) and kind != "camp"
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	v.add_child(row)
	var ico := TextureRect.new()
	ico.texture = load(String(POI_ICONS.get(kind, POI_ICONS["combat"]))) as Texture2D
	ico.custom_minimum_size = Vector2(64, 64)
	ico.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	ico.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	row.add_child(ico)
	var nv := VBoxContainer.new()
	nv.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(nv)
	var nl: Label = U.lbl(String(poi.get("name", "?")), 21, U.C_TXT, true)
	nl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	nv.add_child(nl)
	nv.add_child(U.lbl("✓ Exploré" if done else "Niveau %d" % int(poi.get("level", 10)), 17, U.C_GOOD if done else col.lightened(0.3)))
	var d: Label = U.lbl(String(poi.get("desc", "")), 18, DIM)
	d.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	v.add_child(d)
	if not done:
		var act: String = String(POI_ACTION.get(kind, "INTERAGIR"))
		if kind == "combat" and Dungeons.is_dungeon(poi):
			var gb2: String = String(poi["guardian"])
			var rm2: int = Dungeons.current_room(manager.state, gb2)
			act = "🏰  %s  (salle %d/%d)" % ["ENTRER" if rm2 == 1 else "POURSUIVRE", rm2, Dungeons.ROOMS]
			if not manager.dungeon_lock(poi).is_empty():
				act = "🔒  DONJON VERROUILLÉ"
		elif kind == "combat":
			act += "  (niv %d)" % manager.challenge_level(poi)
		var b := U.btn(act, col, 24, Vector2(0, 72))
		b.pressed.connect(_interact)
		v.add_child(b)
	return card


# ══════════════════════════════════════════════════════════════════════
#  Interactions
# ══════════════════════════════════════════════════════════════════════

func _interact() -> void:
	var poi: Dictionary = manager.poi_at(manager.hero_pos())
	if not poi.is_empty() and String(poi.get("kind", "")) == "combat" and not manager.poi_done(manager.hero_pos()):
		_confirm_combat(poi)
		return
	var cmd: Dictionary = manager.interact()
	match String(cmd.get("action", "nothing")):
		"puzzle":
			_show_puzzle(cmd)
		"chest":
			var looted: Array = cmd.get("loots", [])
			var lines: Array[String] = ["+%d XP d'exploration" % ProgressionManager.ADVENTURE_BASE_XP]
			for it: Dictionary in looted:
				lines.append("[%s] %s" % [ItemRules.rarity_label(it), String(it.get("name", "objet"))])
			_log("Coffre ouvert.")
			_reward_modal("◇  Coffre ouvert !", POI_COLOR["chest"], "Le couvercle cède dans un nuage de mousse.", lines)
		"camp":
			_camp_modal(String(cmd.get("key", "")), int(cmd.get("xp", 0)))
		"reveal":
			var names: Array = cmd.get("names", [])
			if names.is_empty():
				_reward_modal("👁  Belvédère", POI_COLOR["reveal"], "Vous connaissiez déjà ces horizons.", [])
			else:
				var lines2: Array[String] = []
				for n in names:
					lines2.append("⚑ " + String(n))
				_log("Belvédère : %d ville(s) repérée(s)." % names.size())
				_reward_modal("👁  Horizons découverts !", POI_COLOR["reveal"],
					"Du haut du belvédère, vous repérez de nouvelles villes. Elles sortent du brouillard sur la carte de CONQUÊTE (il faudra les relier à votre empire pour les attaquer).", lines2)
				Gultur.say(self, "adv_belvedere", Gultur.ADV_BELVEDERE, null)
		"exit":
			_show_exit(String(cmd.get("key", "")), bool(cmd.get("portal", false)))
		"portal_locked":
			_show_portal_locked(cmd)
		_:
			_say("Rien de particulier ici… pour l'instant.")
	_refresh_world()
	_refresh_side()


## V43 : porte d'un donjon de Nation — 4 salles, la dernière abrite le Gardien et la Pierre.
func _confirm_dungeon(poi: Dictionary) -> void:
	var biome: String = String(poi["guardian"])
	var room: int = Dungeons.current_room(manager.state, biome)
	var lock: Dictionary = manager.dungeon_lock(poi)
	if not lock.is_empty():
		var lbox: VBoxContainer = _modal("🔒  " + String(poi.get("name", "Donjon")), POI_COLOR["combat"])
		var lt: Label = U.lbl("%s\n\nCe donjon est verrouillé : terminez d'abord « %s » (niveau %d) pour en forcer l'entrée.\nPalier %d/%d · ennemis niveau %d à %d." % [
			String(poi.get("desc", "")), String(lock.get("name", "?")), Dungeons.room_level(String(lock["guardian"]), Dungeons.ROOMS),
			Dungeons.tier(biome), Dungeons.TIERS, Dungeons.room_level(biome, 1), Dungeons.room_level(biome, Dungeons.ROOMS)], 18, U.C_TXT)
		lt.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		lbox.add_child(lt)
		var ok := U.btn("COMPRIS", U.C_BORDER, 22, Vector2(240, 60))
		ok.pressed.connect(_close_modal)
		lbox.add_child(ok)
		return
	var box: VBoxContainer = _modal("🏰  " + String(poi.get("name", "Donjon")), POI_COLOR["combat"])
	var lines: PackedStringArray = []
	lines.append(String(poi.get("desc", "")))
	lines.append("")
	for r: int in range(1, Dungeons.ROOMS + 1):
		var mark: String = "✔" if r < room else ("▶" if r == room else "○")
		var who: String = "  —  le Gardien : %s" % Nations.boss_title(Dungeons.base(biome)) if r == Dungeons.ROOMS and Nations.boss_title(Dungeons.base(biome)) != "" else ""
		lines.append("%s  Salle %d · %s · niv %d%s" % [mark, r, Dungeons.room_name(r), Dungeons.room_level(biome, r), who])
	lines.append("")
	if Dungeons.tier(biome) < Dungeons.TIERS:
		lines.append("Donjon de palier %d/%d : le Gardien de la Nation, lui, garde la Pierre." % [Dungeons.tier(biome), Dungeons.TIERS])
	elif Stones.has(manager.save, biome):
		lines.append("💎  %s déjà retrouvée : le donjon reste ouvert pour le butin." % Stones.stone_name(biome))
	else:
		lines.append("💎  %s : %d %% de chances au prochain Gardien vaincu." % [Stones.stone_name(biome), roundi(Dungeons.stone_chance(manager.state, biome) * 100.0)])
	if room > 1:
		lines.append("Expédition commencée : tu reprends à la salle %d (salles terminées : %d). Défaite ou abandon ne font rien perdre." % [room, room - 1])
	else:
		lines.append("Ta progression est gardée salle par salle : tu peux quitter après n'importe quel combat.")
	var t: Label = U.lbl("\n".join(lines), 18, U.C_TXT)
	t.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(t)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	box.add_child(row)
	var go := U.btn("⚔  %s" % ("ENTRER" if room == 1 else "REPRENDRE · SALLE %d" % room), POI_COLOR["combat"], 22, Vector2(340, 60))
	go.pressed.connect(func() -> void:
		_close_modal()
		manager.interact()
		_start_combat(poi))
	row.add_child(go)
	if room > 1:      # V124 : donjon commencé → possibilité de le recommencer depuis la salle 1
		var again := U.btn("↺ RECOMMENCER", U.C_BORDER, 20, Vector2(230, 60))
		again.name = "DungeonRestart"
		again.pressed.connect(func() -> void:
			Dungeons.restart(manager.state, biome)
			manager.persist()
			_close_modal()
			_confirm_dungeon(poi))
		row.add_child(again)
	var later := U.btn("PLUS TARD", U.C_BORDER, 20, Vector2(200, 60))
	later.pressed.connect(_close_modal)
	row.add_child(later)
	Gultur.say(self, "donjon", Gultur.DONJON, null)


func _confirm_combat(poi: Dictionary) -> void:
	if Dungeons.is_dungeon(poi):
		_confirm_dungeon(poi)
		return
	var lvl: int = manager.challenge_level(poi)
	var box: VBoxContainer = _modal("⚔  " + String(poi.get("name", "Combat")), POI_COLOR["combat"])
	var t: Label = U.lbl("%s\n\nCombat au tour par tour (règles du mode Tactique), ennemis niveau %d, décor %s.\nVictoire : XP, objets, or et ressources pour toute l'équipe." % [
		String(poi.get("desc", "")), lvl, ProgressionManager.biome_label(manager.zone_biome())], 18, U.C_TXT)
	t.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(t)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	box.add_child(row)
	var go := U.btn("⚔  COMBATTRE", POI_COLOR["combat"], 22, Vector2(280, 60))
	go.pressed.connect(func() -> void:
		_close_modal()
		manager.interact()
		_start_combat(poi))
	row.add_child(go)
	var later := U.btn("PLUS TARD", U.C_BORDER, 20, Vector2(200, 60))
	later.pressed.connect(_close_modal)
	row.add_child(later)


func _start_combat(poi: Dictionary) -> void:
	if not manager.dungeon_lock(poi).is_empty():
		return                                  # donjon verrouillé : jamais de combat
	if Dungeons.is_dungeon(poi):
		Dungeons.begin(manager.state, String(poi["guardian"]))   # niveau et effectif de la salle
	else:
		manager.state["pending_level"] = manager.challenge_level(poi)
	manager.persist()
	GameManager.fight_biome = manager.zone_biome()
	get_tree().change_scene_to_file("res://scenes/TeamSelection.tscn")


## V104 : portail scellé tant que le donjon final de la Nation n'est pas vaincu.
func _show_portal_locked(cmd: Dictionary) -> void:
	var poi: Dictionary = cmd.get("poi", {})
	var box: VBoxContainer = _modal("🔒  " + String(poi.get("name", "Portail")), POI_COLOR["exit"])
	var t: Label = U.lbl("%s\n\nLe portail est scellé. Vainquez « %s » pour l'ouvrir et gagner la Nation suivante." % [
		String(poi.get("desc", "")), String((cmd.get("lock", {}) as Dictionary).get("name", "le donjon final"))], 18, U.C_TXT)
	t.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(t)
	var ok := U.btn("COMPRIS", U.C_BORDER, 22, Vector2(240, 60))
	ok.pressed.connect(_close_modal)
	box.add_child(ok)


func _show_exit(key: String, portal: bool = false) -> void:
	var revealed: Array = manager.take_exit(key)
	var box: VBoxContainer = _modal("🌀  Portail" if portal else "➜  Sentier découvert !", POI_COLOR["exit"])
	var targets: Array = []
	for r: String in revealed:
		if String(r).begins_with("zone:"):
			targets.append(String(r).substr(5))
	var msg: String = "Le sentier s'ouvre vers de nouvelles terres." if not targets.is_empty() else "Ce sentier vous est familier. Où voulez-vous aller ?"
	if portal:
		msg = "Le portail s'ouvre vers de nouvelles terres." if not targets.is_empty() else "Le portail s'ouvre. Où voulez-vous aller ?"
	var choices: Array = targets if not targets.is_empty() else manager.available_zones()
	# V118 : chemin de retour : uniquement vers la Nation précédente
	var exit_poi: Dictionary = ProgressionManager.adventure_zone_pois(manager.zone_id()).get(key.substr(manager.zone_id().length() + 1), {})
	if bool(exit_poi.get("back", false)):
		choices = [String(exit_poi.get("to", ""))]
		msg = "Le sentier redescend vers une terre déjà parcourue."
	box.add_child(U.lbl(msg, 18, U.C_TXT))
	for zid: String in choices:
		if zid == manager.zone_id():
			continue
		var meta: Dictionary = ProgressionManager.adventure_zone_meta(zid)
		var b := U.btn("Voyager : %s · %s" % [String(meta.get("name", zid)), ProgressionManager.biome_label(String(meta.get("biome", "Forêt")))],
			POI_COLOR["exit"], 19, Vector2(0, 56))
		b.pressed.connect(func() -> void:
			_close_modal()
			_on_zone_pressed(zid))
		box.add_child(b)
	var stay := U.btn("RESTER ICI", U.C_BORDER, 18, Vector2(0, 50))
	stay.pressed.connect(_close_modal)
	box.add_child(stay)
	if not targets.is_empty():
		_log("Nouvelle zone débloquée.")


func _on_zone_pressed(zone_id: String) -> void:
	if zone_id == manager.zone_id() or _walking or _modal_root != null:
		return
	if manager.enter_zone(zone_id):
		_log("Arrivée : %s." % manager.zone_name())
		_rebuild_world()
		_refresh_side()
		_toast_show(manager.zone_name())


# ── Groupes de monstres, contrats, maîtrise (V22) ─────────────────────
func _team_level() -> int:
	var lvl: int = 1
	for m: Dictionary in _save.get("team", []):
		lvl = maxi(lvl, ProgressionManager.member_level(_save, String(m.get("classe", ""))))
	return lvl


## Crée / retire / déplace les nœuds des groupes selon l'état.
func _sync_mobs(animate: bool) -> void:
	var live: Dictionary = {}
	for g: Dictionary in manager.mobs():
		var id: int = int(g["id"])
		live[id] = true
		var cell: Vector2i = AdventureMobs.pos_of(g)
		var mn: MobNode = _mob_nodes.get(id, null)
		if mn == null or not is_instance_valid(mn):
			mn = MobNode.new()
			if is_board():
				mn.scale = Vector2(0.66, 0.66)      # V83 : sur la planche, les monstres restent à l'échelle du décor
			mn.level = int(g.get("level", 1))
			mn.count = int(g.get("count", 3))
			mn.elite = bool(g.get("elite", false))
			var types: Array[String] = ProgressionManager.biome_enemy_types(manager.zone_biome())
			for i: int in range(mini(3, mn.count)):
				var et: String = types[(id + i) % types.size()] if not types.is_empty() else "Gobelin"
				mn.texes.append(Portraits.get_texture({"classe": et, "team": "enemy", "entity_type": "Enemy"}))
			mn.cell = cell
			mn.position = cell_center(cell)
			_entities.add_child(mn)
			_mob_nodes[id] = mn
			if animate:
				mn.modulate.a = 0.0
				create_tween().tween_property(mn, "modulate:a", 1.0, 0.4)
			continue
		if mn.cell != cell:
			mn.cell = cell
			var to: Vector2 = cell_center(cell)
			mn.face(to.x - mn.position.x)
			if animate:
				mn.begin_walk()
				var mob_tween: Tween = create_tween()
				mob_tween.tween_property(mn, "position", to, STEP_TIME * 1.6).set_trans(Tween.TRANS_SINE)
				mob_tween.tween_callback(Callable(mn, "end_walk"))
			else:
				mn.end_walk()
				mn.position = to
	for id2: int in _mob_nodes.keys():
		if not live.has(id2):
			var dead: Node = _mob_nodes[id2]
			if is_instance_valid(dead):
				dead.queue_free()
			_mob_nodes.erase(id2)
	if _board != null:
		var tl: int = _team_level()
		for id3: int in _mob_nodes.keys():
			var n3: MobNode = _mob_nodes[id3]
			n3.visible = manager.cell_discovered(n3.cell)
			n3.danger = n3.level - tl


func _confirm_mob(g: Dictionary) -> void:
	var lvl: int = int(g.get("level", 1))
	var elite: bool = bool(g.get("elite", false))
	var accent: Color = Color(1.0, 0.80, 0.30) if elite else POI_COLOR["combat"]
	var box: VBoxContainer = _modal(("★  " if elite else "⚔  ") + AdventureMobs.label(g, manager.zone_biome()), accent)
	var diff: int = lvl - _team_level()
	var risk: String = "Facile" if diff <= -3 else ("Équilibré" if diff <= 1 else ("Risqué" if diff <= 4 else "Très dangereux"))
	var risk_col: Color = U.C_GOOD if diff <= 1 else (Color(1.0, 0.75, 0.35) if diff <= 4 else U.C_BAD)
	var info := HFlowContainer.new()
	info.add_theme_constant_override("h_separation", 8)
	info.add_theme_constant_override("v_separation", 8)
	info.add_child(U.chip("Niveau %d" % lvl, accent, 19))
	info.add_child(U.chip("%d ennemis" % int(g.get("count", 3)), U.C_TXT, 19))
	info.add_child(U.chip(risk, risk_col, 19))
	box.add_child(info)
	var c: Dictionary = manager.contract()
	var txt: String = "Combat Tactique dans le décor %s. Plus le groupe est nombreux, plus il rapporte d'XP et de butin." % ProgressionManager.biome_label(manager.zone_biome())
	if not c.is_empty():
		txt += "\n📜 Contrat : " + AdventureMobs.contract_text(c)
	var t: Label = U.lbl(txt, 18, U.C_TXT)
	t.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(t)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	box.add_child(row)
	var go := U.btn("⚔  COMBATTRE", accent, 22, Vector2(280, 60))
	go.name = "MobFight"
	go.pressed.connect(func() -> void:
		_close_modal()
		manager.start_mob_combat(g)
		GameManager.fight_biome = manager.zone_biome()
		get_tree().change_scene_to_file("res://scenes/TeamSelection.tscn"))
	row.add_child(go)
	var later := U.btn("PLUS TARD", U.C_BORDER, 20, Vector2(200, 60))
	later.pressed.connect(_close_modal)
	row.add_child(later)


## Camp : repos (XP, avec délai) et tableau des contrats de la carte.
func _camp_modal(key: String, xp: int) -> void:
	var box: VBoxContainer = _modal("☀  Halte au camp", POI_COLOR["camp"])
	if xp > 0:
		_log("Repos au camp (+%d XP)." % xp)
		box.add_child(U.chip("Repos : +%d XP d'exploration" % xp, U.C_GOOD, 18))
	else:
		box.add_child(U.lbl("Vous vous êtes déjà reposé ici. Prochain repos dans %d pas." % manager.camp_rest_wait(key), 17, DIM))
	box.add_child(U.lbl("📜  TABLEAU DES CONTRATS", 20, U.C_GOLD, true))
	var c: Dictionary = manager.contract()
	if not c.is_empty():
		var cl: Label = U.lbl("Contrat en cours : %s" % AdventureMobs.contract_text(c), 18, U.C_TXT)
		cl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		box.add_child(cl)
	else:
		var off: Dictionary = manager.contract_offer()
		var elite: bool = String(off.get("kind", "")) == "elite"
		var desc: String = AdventureMobs.contract_text(off)
		desc += "\nRécompense : or, ressources de la carte et XP%s." % (", ressource de rang 2 et un objet rare ou mieux" if elite else "")
		if elite:
			desc += "\nUne bande d'élite (4 ennemis, niveau %d) apparaîtra sur la carte." % (AdventureMobs.level_range(manager.zone_id()).y + AdventureMobs.ELITE_BONUS_LEVEL / 2)
		var dl: Label = U.lbl(desc, 18, U.C_TXT)
		dl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		box.add_child(dl)
		var acc := U.btn("ACCEPTER LE CONTRAT", Color(1.0, 0.80, 0.30) if elite else POI_COLOR["camp"], 21, Vector2(0, 58))
		acc.name = "AcceptContract"
		acc.pressed.connect(func() -> void:
			var got: Dictionary = manager.accept_contract()
			_log("Contrat accepté : %s." % AdventureMobs.contract_text(got))
			_close_modal()
			_sync_mobs(true)
			_refresh_world()
			_refresh_side()
			_toast_show("📜 Contrat accepté", 24))
		box.add_child(acc)
	var ok := U.btn("REPRENDRE LA ROUTE", U.C_BORDER, 19, Vector2(0, 52))
	ok.pressed.connect(func() -> void:
		_close_modal()
		_refresh_side())
	box.add_child(ok)


## Au retour d'un combat : contrat rempli, puis maîtrise de la carte.
func _show_pending_rewards() -> void:
	var r: Dictionary = manager.take_contract_reward()
	if not r.is_empty():
		var lines: Array[String] = ["+%d or" % int(r.get("gold", 0)), "+%d XP" % int(r.get("xp", 0))]
		for k: String in (r.get("resources", {}) as Dictionary).keys():
			lines.append("+%d %s" % [int(r["resources"][k]), k.replace("@", " R")])
		if r.has("item"):
			lines.append("[%s] %s" % [ItemRules.rarity_label(r["item"]), String(r["item"].get("name", "objet"))])
		_log(String(r.get("title", "Contrat rempli")) + ".")
		_reward_modal("📜  " + String(r.get("title", "Contrat rempli !")), U.C_GOLD,
			"Le tableau du camp vous réserve un nouveau contrat.", lines)
		_refresh_side()
		return
	_check_mastery()


## Verse et annonce la maîtrise de la carte si elle vient d'être atteinte.
func _check_mastery() -> bool:
	var m: Dictionary = manager.check_mastery()
	if m.is_empty():
		return false
	var lines: Array[String] = ["+%d or" % int(m.get("gold", 0))]
	for k: String in (m.get("resources", {}) as Dictionary).keys():
		lines.append("+%d %s" % [int(m["resources"][k]), k.replace("@", " R")])
	if m.has("item"):
		lines.append("[%s] %s" % [ItemRules.rarity_label(m["item"]), String(m["item"].get("name", "objet"))])
	_log("Carte maîtrisée : %s ★" % manager.zone_name())
	_reward_modal("★  Carte maîtrisée !", U.C_GOLD,
		"Tous les lieux et toutes les trouvailles de %s : la carte vous appartient." % manager.zone_name(), lines)
	_refresh_side()
	return true


## Objectifs de la carte (panneau latéral, hors lieu).
func _objectives_into(v: VBoxContainer) -> void:
	v.add_child(U.lbl("OBJECTIFS DE LA CARTE", 18, U.C_GOLD))
	var prog: Dictionary = manager.zone_progress()
	var fp: Dictionary = manager.finds_progress()
	var rows: Array = [
		[int(prog["done"]) >= int(prog["total"]), "Lieux explorés %d/%d" % [int(prog["done"]), int(prog["total"])]],
		[int(fp["found"]) >= int(fp["total"]), "Trouvailles ✦ %d/%d" % [int(fp["found"]), int(fp["total"])]],
	]
	for r: Array in rows:
		v.add_child(U.lbl(("✓ " if bool(r[0]) else "○ ") + String(r[1]), 18, U.C_GOOD if bool(r[0]) else U.C_TXT))
	if manager.is_mastered():
		v.add_child(U.lbl("★ Carte maîtrisée", 18, U.C_GOLD))
	else:
		v.add_child(U.lbl("Tout compléter : récompense de maîtrise ★", 16, DIM))
	var c: Dictionary = manager.contract()
	if not c.is_empty():
		var cl: Label = U.lbl("📜 " + AdventureMobs.contract_text(c), 18, Color(1.0, 0.85, 0.45))
		cl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		v.add_child(cl)
	else:
		var hl: Label = U.lbl("📜 Passez au camp pour prendre un contrat de chasse.", 16, DIM)
		hl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		v.add_child(hl)
	var n: int = manager.mobs().size()
	var kills: int = int((manager.state.get("mob_kills", {}) as Dictionary).get(manager.zone_id(), 0))
	v.add_child(U.lbl("⚔ Groupes de monstres : %d sur la carte · %d vaincus" % [n, kills], 16, DIM))


# ── Événements de route ─────────────────────────────────────────────────
func _show_event(ev: Dictionary) -> void:
	var kind: String = String(ev.get("kind", ""))
	if kind == "ambush":
		var box: VBoxContainer = _modal("⚠  " + String(ev.get("title", "Embuscade")), POI_COLOR["combat"])
		var t: Label = U.lbl("%s\n\nEnnemis niveau %d." % [String(ev.get("text", "")), int(ev.get("level", 10))], 18, U.C_TXT)
		t.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		box.add_child(t)
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 12)
		box.add_child(row)
		var fight := U.btn("⚔  AFFRONTER", POI_COLOR["combat"], 21, Vector2(260, 58))
		fight.pressed.connect(func() -> void:
			_close_modal()
			manager.start_event_combat(ev)
			GameManager.fight_biome = manager.zone_biome()
			get_tree().change_scene_to_file("res://scenes/TeamSelection.tscn"))
		row.add_child(fight)
		var flee := U.btn("CONTOURNER", U.C_BORDER, 19, Vector2(200, 58))
		flee.pressed.connect(func() -> void:
			_close_modal()
			_log("Vous contournez l'embuscade."))
		row.add_child(flee)
		return
	# Petites trouvailles de route : un bandeau et une ligne de journal, sans fenêtre à fermer.
	var parts: Array[String] = []
	if ev.has("resources"):
		for r: String in (ev["resources"] as Dictionary).keys():
			if int(ev["resources"][r]) > 0:
				parts.append("+%d %s" % [int(ev["resources"][r]), r])
	if ev.has("gold"):
		parts.append("+%d or" % int(ev["gold"]))
	if ev.has("xp"):
		parts.append("+%d XP" % int(ev["xp"]))
	var title: String = String(ev.get("title", "Événement"))
	_toast_show("✧ %s : %s" % [title, " · ".join(parts)], 22)
	if kind == "sage":
		_log("%s : %s" % [title, String(ev.get("text", ""))])
	else:
		_log("%s (%s)." % [title, " · ".join(parts)])
	_refresh_side()


# ── Énigmes ─────────────────────────────────────────────────────────────
func _show_puzzle(cmd: Dictionary) -> void:
	var puzzle: Dictionary = cmd.get("puzzle", {})
	var key: String = String(cmd.get("key", ""))
	match String(puzzle.get("type", "riddle")):
		"runes":
			_puzzle_runes(key, puzzle)
		"lights":
			_puzzle_lights(key, puzzle)
		_:
			_puzzle_riddle(key, puzzle)


func _puzzle_riddle(key: String, puzzle: Dictionary) -> void:
	var col: Color = POI_COLOR["puzzle"]
	var box: VBoxContainer = _modal("✦  Énigme", col)
	var q: Label = U.lbl(String(puzzle.get("text", "")), 21, U.C_TXT)
	q.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(q)
	var feedback: Label = U.lbl("", 17, U.C_BAD)
	feedback.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	var choices: Array = (puzzle.get("choices", []) as Array).duplicate()
	choices.sort_custom(func(a: Variant, b: Variant) -> bool: return (String(a) + key).hash() < (String(b) + key).hash())
	var submit := func(answer: String) -> void:
		if manager.solve_puzzle(key, answer):
			_close_modal()
			_log("Énigme résolue.")
			_reward_modal("✦  Énigme résolue !", col, "Les runes s'illuminent et vous livrent leur savoir.",
				["+%d XP d'exploration" % int(ProgressionManager.ADVENTURE_BASE_XP * 2)])
			_refresh_world()
			_refresh_side()
		else:
			feedback.text = String(puzzle.get("wrong", "Ce n'est pas la bonne réponse."))
	for ch in choices:
		var b := U.btn(String(ch), col, 20, Vector2(0, 56))
		b.pressed.connect(submit.bind(String(ch)))
		box.add_child(b)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	box.add_child(row)
	var input := LineEdit.new()
	input.placeholder_text = "…ou tapez votre réponse"
	input.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	input.custom_minimum_size = Vector2(0, 48)
	input.add_theme_font_size_override("font_size", 18)
	input.text_submitted.connect(func(t: String) -> void: submit.call(t))
	row.add_child(input)
	var ok := U.btn("OK", col, 18, Vector2(80, 48))
	ok.pressed.connect(func() -> void: submit.call(input.text))
	row.add_child(ok)
	box.add_child(feedback)
	_modal_close_button(box)


func _puzzle_runes(key: String, puzzle: Dictionary) -> void:
	var col: Color = POI_COLOR["puzzle"]
	var length: int = int(puzzle.get("length", 4))
	var box: VBoxContainer = _modal("✦  " + String(manager.poi_at(manager.hero_pos()).get("name", "Runes")), col)
	var q: Label = U.lbl(String(puzzle.get("text", "")), 18, U.C_TXT)
	q.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(q)
	var status: Label = U.lbl("Observez…", 20, U.C_GOLD)
	box.add_child(status)
	var grid := GridContainer.new()
	grid.columns = 3
	grid.add_theme_constant_override("h_separation", 12)
	grid.add_theme_constant_override("v_separation", 12)
	box.add_child(grid)
	var buttons: Array[Button] = []
	for i: int in range(RUNE_SHAPES.size()):
		var b := U.btn(String(RUNE_SHAPES[i]), RUNE_COLORS[i], 40, Vector2(150, 96))
		b.add_theme_color_override("font_color", (RUNE_COLORS[i] as Color).lightened(0.4))
		b.modulate = Color(0.55, 0.55, 0.6)
		grid.add_child(b)
		buttons.append(b)
	var st: Dictionary = {"seq": [], "pos": 0, "listening": false}
	var play := func() -> void:
		if not is_instance_valid(box) or not box.is_inside_tree():
			return
		var seq: Array = []
		for i: int in range(length):
			seq.append(_rng.randi_range(0, RUNE_SHAPES.size() - 1))
		st["seq"] = seq
		st["pos"] = 0
		st["listening"] = false
		status.text = "Observez…"
		status.add_theme_color_override("font_color", U.C_GOLD)
		var tw := box.create_tween()
		tw.tween_interval(0.5)
		for idx in seq:
			var bb: Button = buttons[int(idx)]
			tw.tween_property(bb, "modulate", Color(1.4, 1.4, 1.4), 0.12)
			tw.tween_callback(func() -> void: Sfx.play("click"))
			tw.tween_interval(0.32)
			tw.tween_property(bb, "modulate", Color(0.55, 0.55, 0.6), 0.12)
			tw.tween_interval(0.12)
		tw.tween_callback(func() -> void:
			if not is_instance_valid(box):
				return
			st["listening"] = true
			for bb2: Button in buttons:
				bb2.modulate = Color(1, 1, 1)
			status.text = "À vous : reproduisez la suite (%d runes)." % length)
	for i: int in range(buttons.size()):
		buttons[i].pressed.connect(func() -> void:
			if not bool(st["listening"]):
				return
			var seq: Array = st["seq"]
			if int(seq[int(st["pos"])]) == i:
				st["pos"] = int(st["pos"]) + 1
				status.text = "%d / %d" % [int(st["pos"]), length]
				if int(st["pos"]) >= length:
					st["listening"] = false
					var r: Dictionary = manager.complete_puzzle(key)
					_close_modal()
					_puzzle_success(r)
			else:
				st["listening"] = false
				status.text = String(puzzle.get("wrong", "Fausse note !"))
				status.add_theme_color_override("font_color", U.C_BAD)
				for bb3: Button in buttons:
					bb3.modulate = Color(0.55, 0.55, 0.6)
				var again := box.create_tween()
				again.tween_interval(1.2)
				again.tween_callback(play))
	play.call()
	_modal_close_button(box)


func _puzzle_lights(key: String, puzzle: Dictionary) -> void:
	var col: Color = POI_COLOR["puzzle"]
	var n: int = clampi(int(puzzle.get("size", 3)), 3, 5)
	var box: VBoxContainer = _modal("✦  " + String(manager.poi_at(manager.hero_pos()).get("name", "Dalles")), col)
	var q: Label = U.lbl(String(puzzle.get("text", "")), 18, U.C_TXT)
	q.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	box.add_child(q)
	var status: Label = U.lbl("", 18, U.C_GOLD)
	box.add_child(status)
	var center := CenterContainer.new()
	box.add_child(center)
	var grid := GridContainer.new()
	grid.columns = n
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 8)
	center.add_child(grid)
	# Grille mélangée par `scramble` appuis distincts depuis l'état résolu : toujours soluble.
	var start: Array = []
	for i: int in range(n * n):
		start.append(true)
	var presses: Array = []
	while presses.size() < int(puzzle.get("scramble", 3)):
		var c: int = _rng.randi_range(0, n * n - 1)
		if not presses.has(c):
			presses.append(c)
	for c2: int in presses:
		_lights_toggle(start, n, c2)
	var st: Dictionary = {"cells": start.duplicate(), "moves": 0}
	var tiles: Array[Button] = []
	var paint := func() -> void:
		var cells: Array = st["cells"]
		var lit: int = 0
		for i: int in range(tiles.size()):
			var on: bool = bool(cells[i])
			if on:
				lit += 1
			tiles[i].add_theme_stylebox_override("normal", U.box(Color(0.98, 0.84, 0.35) if on else Color(0.12, 0.13, 0.20), col if on else U.C_BORDER, 12, 3, 4))
			tiles[i].add_theme_stylebox_override("hover", U.box(Color(1.0, 0.9, 0.5) if on else Color(0.2, 0.22, 0.3), Color.WHITE, 12, 3, 4))
			tiles[i].text = "☀" if on else ""
		status.text = "Dalles allumées : %d / %d  ·  coups : %d" % [lit, n * n, int(st["moves"])]
	for i: int in range(n * n):
		var t := Button.new()
		t.custom_minimum_size = Vector2(96, 96) if n <= 3 else Vector2(80, 80)
		t.add_theme_font_size_override("font_size", 30)
		t.add_theme_color_override("font_color", Color(0.5, 0.3, 0.05))
		t.focus_mode = Control.FOCUS_NONE
		t.pressed.connect(func() -> void:
			_lights_toggle(st["cells"], n, i)
			st["moves"] = int(st["moves"]) + 1
			Sfx.play("click")
			paint.call()
			if not (st["cells"] as Array).has(false):
				var r: Dictionary = manager.complete_puzzle(key)
				_close_modal()
				_puzzle_success(r))
		grid.add_child(t)
		tiles.append(t)
	paint.call()
	var reset := U.btn("↺  RECOMMENCER", U.C_BORDER, 17, Vector2(0, 46))
	reset.pressed.connect(func() -> void:
		st["cells"] = start.duplicate()
		st["moves"] = 0
		paint.call())
	box.add_child(reset)
	_modal_close_button(box)


static func _lights_toggle(cells: Array, n: int, i: int) -> void:
	var x: int = i % n
	var y: int = i / n
	for d: Vector2i in [Vector2i(0, 0), Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
		var xx: int = x + d.x
		var yy: int = y + d.y
		if xx >= 0 and yy >= 0 and xx < n and yy < n:
			cells[yy * n + xx] = not bool(cells[yy * n + xx])


func _puzzle_success(r: Dictionary) -> void:
	var lines: Array[String] = []
	if r.has("xp"):
		lines.append("+%d XP d'exploration" % int(r["xp"]))
	for res: String in (r.get("resources", {}) as Dictionary).keys():
		lines.append("+%d %s" % [int(r["resources"][res]), res])
	_log("Énigme résolue.")
	_reward_modal("✦  Énigme résolue !", POI_COLOR["puzzle"], "Un déclic, puis une douce lumière : le lieu vous révèle son secret.", lines)
	_refresh_world()
	_refresh_side()


# ══════════════════════════════════════════════════════════════════════
#  Fenêtres, messages
# ══════════════════════════════════════════════════════════════════════

func _modal(title: String, accent: Color) -> VBoxContainer:
	_close_modal()
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.55)
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.mouse_filter = Control.MOUSE_FILTER_STOP
	dim.z_index = 0
	_modal_canvas.add_child(dim)
	_modal_root = dim
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.add_child(center)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(640, 0)
	panel.add_theme_stylebox_override("panel", U.box(Color(0.07, 0.09, 0.15, 0.98), accent, 20, 3, 26))
	center.add_child(panel)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 14)
	panel.add_child(box)
	box.add_child(U.lbl(title, 30, accent, true))
	panel.scale = Vector2(0.92, 0.92)
	panel.pivot_offset = Vector2(320, 120)
	create_tween().tween_property(panel, "scale", Vector2.ONE, 0.14).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	return box


func _modal_close_button(box: VBoxContainer) -> void:
	var close := U.btn("FERMER", U.C_BORDER, 17, Vector2(0, 46))
	close.pressed.connect(_close_modal)
	box.add_child(close)


func _close_modal() -> void:
	if _modal_root != null and is_instance_valid(_modal_root):
		_modal_root.queue_free()
	_modal_root = null


func _reward_modal(title: String, accent: Color, text: String, lines: Array) -> void:
	var box: VBoxContainer = _modal(title, accent)
	if text != "":
		var t: Label = U.lbl(text, 18, U.C_TXT)
		t.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		box.add_child(t)
	if not lines.is_empty():
		var flow := HFlowContainer.new()
		flow.add_theme_constant_override("h_separation", 8)
		flow.add_theme_constant_override("v_separation", 8)
		for l in lines:
			flow.add_child(U.chip(String(l), U.C_GOOD, 18))
		box.add_child(flow)
	var ok := U.btn("CONTINUER", accent, 20, Vector2(0, 56))
	ok.pressed.connect(func() -> void:
		_close_modal()
		_refresh_side()
		_check_mastery())
	box.add_child(ok)


func _say(text: String) -> void:
	_toast_show(text, 20)


func _toast_show(text: String, size: int = 26) -> void:
	_toast.text = text
	_toast.add_theme_font_size_override("font_size", size)
	_toast.modulate.a = 1.0
	_toast.visible = true
	if _toast_tw != null and _toast_tw.is_valid():
		_toast_tw.kill()
	_toast_tw = create_tween()
	_toast_tw.tween_interval(1.6)
	_toast_tw.tween_property(_toast, "modulate:a", 0.0, 0.6)
	_toast_tw.tween_callback(func() -> void: _toast.visible = false)


func _log(text: String) -> void:
	var j: Array = manager.state.get("journal", [])
	j.append(text)
	while j.size() > 6:
		j.remove_at(0)
	manager.state["journal"] = j
	manager.persist()


func _on_cities_revealed(city_ids: Array) -> void:
	for city_id: String in city_ids:
		if not _save.has("conquest") or not (_save["conquest"] is Dictionary):
			_save["conquest"] = {"owned": ["capitale"], "pending_city": "", "discovered": []}
		var conquest: Dictionary = _save["conquest"]
		var disc: Array = conquest.get("discovered", [])
		if not disc.has(city_id):
			disc.append(city_id)
		conquest["discovered"] = disc
		_save["conquest"] = conquest
	manager.persist()


func _back_to_save() -> void:
	PlayTimer.flush()
	manager.persist()
	get_tree().change_scene_to_file("res://scenes/SaveSlots.tscn")


# ══════════════════════════════════════════════════════════════════════
#  Nœuds de rendu
# ══════════════════════════════════════════════════════════════════════

## Plateau : falaise de l'île, sol (tuiles des arènes), sentiers, brouillard, survol.
class AdventureBoard extends Node2D:
	var ui: Node = null
	var hover: Vector2i = Vector2i(-1, -1)
	var preview: Array = []
	var _t: float = 0.0
	var _sig: String = ""
	var _since: float = 0.0

	func _ready() -> void:
		set_process(true)

	## V119 : ne redessine que si quelque chose a changé (survol, trajet, brouillard…) ; sur les cartes
	## générées, le brouillard ondule doucement : 4 fois par seconde suffisent (avant : chaque image,
	## des milliers de nuages redessinés).
	func _process(delta: float) -> void:
		_t += delta
		_since += delta
		var mgr: Node = ui.manager if ui != null else null
		var sig: String = "%s|%d|%s|%s|%d|%d" % [str(hover), preview.size(), str(preview[0]) if not preview.is_empty() else "",
			str(ui._edit_on) if ui != null else "", int(mgr.moves()) if mgr != null else 0, BoardArt.rev]
		var animated: bool = ui != null and not ui.is_board() and _since >= 0.25
		if sig != _sig or animated:
			_sig = sig
			_since = 0.0
			queue_redraw()


	func _diamond(c: Vector2, s: float = 1.0) -> PackedVector2Array:
		return PackedVector2Array([c + Vector2(0, -32 * s), c + Vector2(64 * s, 0), c + Vector2(0, 32 * s), c + Vector2(-64 * s, 0)])

	func _draw_board() -> void:
		var mgr: Node = ui.manager
		if ui.is_iso():
			_draw_iso_overlay()
			return
		var cw: float = BoardArt.cell_world(mgr.zone_id())
		if ui._edit_on:
			var bsz: Vector2i = mgr.zone_size()
			for ey: int in range(bsz.y):
				for ex: int in range(bsz.x):
					var ok: bool = BoardArt.walkable_cell(mgr.zone_id(), Vector2i(ex, ey))
					draw_rect(Rect2(Vector2(ex, ey) * cw, Vector2(cw, cw)).grow(-1.0),
						Color(0.2, 0.9, 0.3, 0.30) if ok else Color(0.9, 0.2, 0.2, 0.32))
		for i: int in range(preview.size()):
			var pc: Vector2 = ui.cell_center(preview[i])
			var last: bool = i == preview.size() - 1
			draw_circle(pc, 7.0 if not last else 13.0, Color(1.0, 0.95, 0.55, 0.85))
			if last and preview.size() > 1:
				var tag: String = "%d pas" % preview.size()
				var fnt: Font = ThemeDB.fallback_font
				var tw: Vector2 = fnt.get_string_size(tag, HORIZONTAL_ALIGNMENT_LEFT, -1, 26)
				var tp: Vector2 = pc + Vector2(-tw.x * 0.5, -40.0)
				draw_rect(Rect2(tp + Vector2(-10, -tw.y + 2), tw + Vector2(20, 10)), Color(0.05, 0.07, 0.12, 0.88))
				draw_string(fnt, tp, tag, HORIZONTAL_ALIGNMENT_LEFT, -1, 26, Color(1.0, 0.92, 0.55))
		if hover.x >= 0:
			var ok: bool = AdventureTerrain.walkable(mgr.zone_id(), hover)
			draw_rect(Rect2(Vector2(hover) * cw, Vector2(cw, cw)), Color(1, 1, 1, 0.9) if ok else Color(1, 0.4, 0.35, 0.8), false, 2.5)

	## V106 : survol et trajet sur le plateau à étages (losanges posés sur la hauteur de chaque case).
	func _draw_iso_overlay() -> void:
		var mgr: Node = ui.manager
		var cs: float = BoardArt.iso_cs(mgr.zone_id())
		for i: int in range(preview.size()):
			var pc: Vector2 = ui.cell_center(preview[i])
			var last: bool = i == preview.size() - 1
			draw_set_transform(pc, 0.0, Vector2(1.0, 0.5))
			draw_circle(Vector2.ZERO, (6.0 if not last else 10.0), Color(1.0, 0.95, 0.55, 0.85))
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			if last and preview.size() > 1:
				var tag: String = "%d pas" % preview.size()
				var fnt: Font = ThemeDB.fallback_font
				var tw: Vector2 = fnt.get_string_size(tag, HORIZONTAL_ALIGNMENT_LEFT, -1, 26)
				var tp: Vector2 = pc + Vector2(-tw.x * 0.5, -40.0)
				draw_rect(Rect2(tp + Vector2(-10, -tw.y + 2), tw + Vector2(20, 10)), Color(0.05, 0.07, 0.12, 0.88))
				draw_string(fnt, tp, tag, HORIZONTAL_ALIGNMENT_LEFT, -1, 26, Color(1.0, 0.92, 0.55))
		if hover.x >= 0:
			var ok: bool = AdventureTerrain.walkable(mgr.zone_id(), hover)
			var hc: Vector2 = ui.cell_center(hover)
			var dm := PackedVector2Array([hc + Vector2(0, -32 * cs), hc + Vector2(64 * cs, 0), hc + Vector2(0, 32 * cs), hc + Vector2(-64 * cs, 0), hc + Vector2(0, -32 * cs)])
			draw_polyline(dm, Color(1, 1, 1, 0.9) if ok else Color(1, 0.4, 0.35, 0.8), 2.0, true)

	func _draw() -> void:
		if ui.is_board():
			_draw_board()
			return
		var mgr: Node = ui.manager
		var size: Vector2i = mgr.zone_size()
		var biome: String = mgr.zone_biome()
		var p: Dictionary = BattleScenery.pal(biome)
		var terrain: Dictionary = AdventureTerrain.zone_terrain(mgr.zone_id())
		var voids: Dictionary = terrain["voids"]   # V47 : cases hors île (contour irrégulier)
		# Falaise sous l'île (faces avant + bas déchiqueté)
		var lv: Vector2 = ui.cell_center(Vector2i(0, size.y - 1)) + Vector2(-64, 0)
		var bv: Vector2 = ui.cell_center(Vector2i(size.x - 1, size.y - 1)) + Vector2(0, 32)
		var rv: Vector2 = ui.cell_center(Vector2i(size.x - 1, 0)) + Vector2(64, 0)
		var depth: float = 74.0
		draw_set_transform(Vector2(bv.x, bv.y + depth + 150.0), 0.0, Vector2(1.0, 0.22))
		draw_circle(Vector2.ZERO, float(size.x + size.y) * 34.0, Color(0.03, 0.06, 0.10, 0.10))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		_face(lv, bv, depth, p["l_t"], p["l_b"], 3)
		_face(bv, rv, depth, p["r_t"], p["r_b"], 9)
		# Sol
		for y: int in range(size.y):
			for x: int in range(size.x):
				var cell := Vector2i(x, y)
				var c: Vector2 = ui.cell_center(cell)
				if voids.has(cell) or not mgr.cell_discovered(cell):
					continue
				var tex: Texture2D = BattleScenery.tile_tex(AdventureTerrain.cell_biome(mgr.zone_id(), cell), posmod(x * 3 + y * 5, 6))
				if tex != null:
					draw_texture_rect(tex, Rect2(c - Vector2(64, 32), Vector2(128, 64)), false)
				else:
					draw_colored_polygon(_diamond(c), p["top_a"])
				draw_polyline(_diamond(c) + PackedVector2Array([c + Vector2(0, -32)]), Color(0.1, 0.15, 0.08, 0.18), 1.2, true)
		# Sentiers
		var trail: Color = {"Forêt": Color(0.78, 0.64, 0.42), "Montagne": Color(0.80, 0.82, 0.86), "Désert": Color(0.72, 0.52, 0.32), "Donjon": Color(0.52, 0.48, 0.50),
			"Cristaux": Color(0.62, 0.58, 0.85), "Marées": Color(0.86, 0.80, 0.60), "Vents": Color(0.82, 0.90, 0.92),
			"Brasier": Color(0.45, 0.32, 0.28), "Brumes": Color(0.62, 0.74, 0.66), "Ombres": Color(0.44, 0.36, 0.56), "Rouages": Color(0.50, 0.42, 0.34)}.get(biome, Color(0.7, 0.6, 0.45))
		var paths: Dictionary = terrain["paths"]
		# Le sentier file vers la carte voisine, au-delà du bord de l'île.
		var gates: Dictionary = mgr.gates()
		for gcell: Vector2i in gates.keys():
			if not mgr.cell_discovered(gcell):
				continue
			var gc: Vector2 = ui.cell_center(gcell)
			var gv: Vector2 = GATE_VEC[String(gates[gcell]["dir"])]
			draw_line(gc, gc + gv * 0.62, trail.darkened(0.25), 30.0, true)
			draw_line(gc, gc + gv * 0.60, trail, 22.0, true)
		for cell2: Vector2i in paths.keys():
			if not mgr.cell_discovered(cell2):
				continue
			var c2: Vector2 = ui.cell_center(cell2)
			for d: Vector2i in [Vector2i(1, 0), Vector2i(0, 1)]:
				var n: Vector2i = cell2 + d
				if paths.has(n) and mgr.cell_discovered(n):
					draw_line(c2, ui.cell_center(n), trail.darkened(0.25), 30.0, true)
			draw_set_transform(c2, 0.0, Vector2(1.0, 0.5))
			draw_circle(Vector2.ZERO, 17.0, trail.darkened(0.25))
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		for cell3: Vector2i in paths.keys():
			if not mgr.cell_discovered(cell3):
				continue
			var c3: Vector2 = ui.cell_center(cell3)
			for d2: Vector2i in [Vector2i(1, 0), Vector2i(0, 1)]:
				var n2: Vector2i = cell3 + d2
				if paths.has(n2) and mgr.cell_discovered(n2):
					draw_line(c3, ui.cell_center(n2), trail, 22.0, true)
			draw_set_transform(c3, 0.0, Vector2(1.0, 0.5))
			draw_circle(Vector2.ZERO, 13.0, trail)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			var rng := RandomNumberGenerator.new()
			rng.seed = cell3.x * 97 + cell3.y * 13
			for i: int in range(2):
				draw_circle(c3 + Vector2(rng.randf_range(-16, 16), rng.randf_range(-6, 6)), rng.randf_range(1.6, 3.0), trail.lightened(0.2))
		# Aperçu du trajet
		for i: int in range(preview.size()):
			var pc: Vector2 = ui.cell_center(preview[i])
			var last: bool = i == preview.size() - 1
			draw_set_transform(pc, 0.0, Vector2(1.0, 0.5))
			draw_circle(Vector2.ZERO, 9.0 if not last else 15.0, Color(1.0, 0.95, 0.55, 0.85))
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			if last and preview.size() > 1:
				var tag: String = "%d pas" % preview.size()
				var fnt: Font = ThemeDB.fallback_font
				var tw: Vector2 = fnt.get_string_size(tag, HORIZONTAL_ALIGNMENT_LEFT, -1, 26)
				var tp: Vector2 = pc + Vector2(-tw.x * 0.5, -46.0)
				draw_rect(Rect2(tp + Vector2(-10, -tw.y + 2), tw + Vector2(20, 10)), Color(0.05, 0.07, 0.12, 0.88))
				draw_string(fnt, tp, tag, HORIZONTAL_ALIGNMENT_LEFT, -1, 26, Color(1.0, 0.92, 0.55))
		# Survol
		if hover.x >= 0:
			var ok: bool = mgr.cell_discovered(hover) and AdventureTerrain.walkable(mgr.zone_id(), hover)
			var hc: Vector2 = ui.cell_center(hover)
			draw_polyline(_diamond(hc, 0.96) + PackedVector2Array([hc + Vector2(0, -30.7)]), Color(1, 1, 1, 0.9) if ok else Color(1, 0.4, 0.35, 0.8), 2.5, true)
		# Brouillard : nuages sur les cases non découvertes
		for y2: int in range(size.y):
			for x2: int in range(size.x):
				var fc := Vector2i(x2, y2)
				if voids.has(fc) or mgr.cell_discovered(fc):
					continue
				var c4: Vector2 = ui.cell_center(fc)
				var deep: bool = ProgressionManager.adventure_biome_layer(biome) < 0
				draw_colored_polygon(_diamond(c4, 1.02), Color(0.13, 0.10, 0.18, 0.97) if deep else Color(0.66, 0.74, 0.82, 0.96))
				var r2 := RandomNumberGenerator.new()
				r2.seed = x2 * 7 + y2 * 131
				for k: int in range(4):
					var off := Vector2(r2.randf_range(-36, 36), r2.randf_range(-12, 8) - 8.0 + sin(_t * 0.8 + float(k + x2)) * 2.0)
					draw_set_transform(c4 + off, 0.0, Vector2(1.0, 0.55))
					draw_circle(Vector2.ZERO, r2.randf_range(20, 30), Color(0.24, 0.19, 0.32, 0.85) if deep else Color(0.90, 0.94, 0.98, 0.85))
					draw_circle(Vector2(-5, -6), r2.randf_range(10, 16), Color(0.36, 0.29, 0.46, 0.6) if deep else Color(1, 1, 1, 0.6))
					draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)

	func _face(a: Vector2, b: Vector2, depth: float, ct: Color, cb: Color, salt: int) -> void:
		var steps: int = 12
		var rng := RandomNumberGenerator.new()
		rng.seed = salt * 31
		for i: int in range(steps):
			var f0: float = float(i) / float(steps)
			var f1: float = float(i + 1) / float(steps)
			var p0: Vector2 = a.lerp(b, f0)
			var p1: Vector2 = a.lerp(b, f1)
			var d0: float = depth + 30.0 + sin(f0 * PI) * 40.0 + rng.randf_range(0.0, 26.0)
			var d1: float = depth + 30.0 + sin(f1 * PI) * 40.0 + rng.randf_range(0.0, 26.0)
			draw_polygon(PackedVector2Array([p0, p1, p1 + Vector2(0, d1), p0 + Vector2(0, d0)]),
				PackedColorArray([ct, ct, cb.darkened(0.15), cb.darkened(0.15)]))
			draw_line(p0 + Vector2(0, depth * 0.5), p1 + Vector2(0, depth * 0.5), Color(0, 0, 0, 0.14), 2.0)
		draw_line(a, b, Color(0.20, 0.35, 0.15, 0.5), 5.0, true)


## V106 : sol du plateau à étages — cases lisses (sans quadrillage), falaises entre les étages, sentiers.
## Dessiné une seule fois (le nœud ne se redessine pas à chaque image).
class IsoGround extends Node2D:
	var ui: Node = null
	# V114 : le sol reste STATIQUE (redessiné une fois) — l'animation (clapot, nuages)
	# vit dans IsoFx, une couche légère à part, pour ne pas relancer tout le plateau à chaque frame.

	func _ready() -> void:
		queue_redraw()

	static func _tint(base: Color, h: float, x: int, y: int) -> Color:
		# relief doux : chaque étage éclaircit un peu ; un bruit à grande échelle évite l'effet damier
		var n: float = 0.5 + 0.5 * sin(float(x) * 0.37 + sin(float(y) * 0.21) * 1.7) * cos(float(y) * 0.29 + float(x) * 0.11)
		return base.lightened(h * 0.045 + n * 0.05).darkened((1.0 - n) * 0.03)

	func _draw() -> void:
		var zid: String = ui.manager.zone_id()
		var d: Dictionary = BoardArt.raw(zid)
		var cols: int = int(d.get("cols", 0))
		var rows: int = int(d.get("rows", 0))
		var cs: float = BoardArt.iso_cs(zid)
		var hs: Dictionary = BoardArt.heights(zid)
		var up: float = BoardArt.iso_unit_px(zid)
		var hw: float = BoardArt.ISO_TW * cs * 0.5
		var hh: float = BoardArt.ISO_TH * cs * 0.5
		var p: Dictionary = BattleScenery.pal("Forêt")
		var grass := Color(0.33, 0.55, 0.25)
		var rock_t := Color(0.55, 0.47, 0.36)
		var rock_b := Color(0.25, 0.20, 0.17)
		var trail := Color(0.80, 0.67, 0.45)
		var paths: Dictionary = AdventureTerrain.zone_terrain(zid)["paths"]
		var base_y: float = BoardArt.iso_origin(zid).y
		# V114 : arrière-plan lointain — soleil, deux rides de collines dans la brume, nuages qui dérivent
		var wsize: Vector2 = BoardArt.world_size(zid)
		var sun := Vector2(wsize.x * 0.82, base_y - 250.0)
		draw_circle(sun, 64.0, Color(1.0, 0.95, 0.75, 0.16))
		draw_circle(sun, 44.0, Color(1.0, 0.96, 0.78, 0.85))
		for ridge in range(2):
			var yb: float = base_y - 40.0 + float(ridge) * 52.0
			var hcol: Color = Color(0.42, 0.58, 0.48, 0.38 - float(ridge) * 0.13)
			var rpts := PackedVector2Array()
			for i in range(24):
				var fx: float = float(i) / 23.0
				rpts.append(Vector2(fx * wsize.x, yb - 70.0 - sin(fx * 9.0 + float(ridge) * 3.0) * 52.0 - sin(fx * 23.0) * 18.0))
			rpts.append(Vector2(wsize.x, yb + 200.0))
			rpts.append(Vector2(0.0, yb + 200.0))
			draw_colored_polygon(rpts, hcol)
		# ombre portée sous l'île flottante
		var bot: Vector2 = BoardArt.iso_origin(zid) + Vector2(float(cols - rows) * hw * 0.5, float(cols + rows) * hh * 0.5)
		# V114 : eau autour de l'île (base statique ; le clapot animé est dans IsoFx)
		var wr: float = float(cols + rows) * hw * 0.62
		draw_set_transform(bot + Vector2(0, 170.0), 0.0, Vector2(1.0, 0.24))
		draw_circle(Vector2.ZERO, wr, Color(0.09, 0.24, 0.32))
		draw_circle(Vector2.ZERO, wr * 0.94, Color(0.15, 0.38, 0.45))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		draw_set_transform(bot + Vector2(0, 250), 0.0, Vector2(1.0, 0.22))
		draw_circle(Vector2.ZERO, float(cols + rows) * hw * 0.5, Color(0.03, 0.06, 0.10, 0.12))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		for sum: int in range(cols + rows - 1):
			for x: int in range(maxi(0, sum - rows + 1), mini(cols, sum + 1)):
				var y: int = sum - x
				var c := Vector2i(x, y)
				if not hs.has(c) or not BoardArt.walkable_cell(zid, c):
					continue
				var h: int = int(hs[c])
				var ctr: Vector2 = BoardArt.iso_pos(zid, c)
				# faces de falaise : vers le sud-ouest (x, y+1) et le sud-est (x+1, y)
				for side: int in range(2):
					var n := Vector2i(x, y + 1) if side == 0 else Vector2i(x + 1, y)
					var nh: int = int(hs[n]) if hs.has(n) and BoardArt.walkable_cell(zid, n) else -99
					var drop: float
					if nh == -99:
						drop = 2.6 * BoardArt.ISO_LEVEL_PX + float(h) * up * 0.0
					else:
						drop = float(h - nh) * up
					if drop <= 0.5:
						continue
					var a: Vector2 = ctr + (Vector2(-hw, 0) if side == 0 else Vector2(0, hh))
					var b: Vector2 = ctr + (Vector2(0, hh) if side == 0 else Vector2(hw, 0))
					var shade: float = 0.0 if side == 0 else 0.22
					var ragged: float = 0.0
					if nh == -99:
						var rr := RandomNumberGenerator.new()
						rr.seed = x * 131 + y * 17 + side
						ragged = rr.randf_range(0.0, 26.0)
					var t_col: Color = rock_t.darkened(shade)
					var b_col: Color = (rock_b if nh == -99 else rock_t.darkened(0.30)).darkened(shade * 0.6)
					# haut de falaise herbeux
					var lip: float = minf(drop, 9.0)
					draw_polygon(PackedVector2Array([a, b, b + Vector2(0, drop + ragged), a + Vector2(0, drop + ragged)]),
						PackedColorArray([t_col, t_col, b_col, b_col]))
					draw_polygon(PackedVector2Array([a, b, b + Vector2(0, lip), a + Vector2(0, lip)]),
						PackedColorArray([grass.darkened(0.25 + shade * 0.5), grass.darkened(0.25 + shade * 0.5), grass.darkened(0.45 + shade * 0.4), grass.darkened(0.45 + shade * 0.4)]))
					if drop > 20.0:
						draw_line(a + Vector2(0, drop * 0.5), b + Vector2(0, drop * 0.5), Color(0, 0, 0, 0.10), 1.5)
					# V114 : escalier de bois là où le sentier gravit une marche
					if nh != -99 and paths.has(c) and drop > 0.5:
						var wood := Color(0.55, 0.40, 0.24)
						for s_i in range(3):
							var fy: float = drop * (0.25 + 0.25 * float(s_i))
							draw_line(a + Vector2(0, fy), b + Vector2(0, fy), wood.lightened(0.08 * float(s_i)), 5.0, true)
				# dessus de la case
				var top: Color = _tint(grass, float(h) / float(BoardArt.raw(zid).get("unit", 4)), x, y)
				if paths.has(c):
					top = _tint(trail, float(h) / float(BoardArt.raw(zid).get("unit", 4)) * 0.4, x, y)
				# V114 : rivage — cases basses au bord de l'île, teinte de sable humide
				if h <= int(d.get("unit", 4)) and not paths.has(c):
					var edge: bool = false
					for dd: Vector2i in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
						var nn := c + dd
						if not hs.has(nn) or not BoardArt.walkable_cell(zid, nn):
							edge = true
					if edge:
						top = top.lerp(Color(0.72, 0.62, 0.40), 0.55)
				var e: float = 1.015   # recouvrement léger : aucun interstice entre les cases
				draw_colored_polygon(PackedVector2Array([ctr + Vector2(0, -hh * e), ctr + Vector2(hw * e, 0), ctr + Vector2(0, hh * e), ctr + Vector2(-hw * e, 0)]), top)


## V114 : couche animée LÉGÈRE au-dessus du sol iso — clapot de l'eau + nuages qui dérivent.
## Redessin partiel (~30 ips) : le plateau lui-même (IsoGround) reste statique.
## Absente en qualité « Économie » (GfxQuality.low()).
class IsoFx extends Node2D:
	var ui: Node = null
	var _t: float = 0.0
	var _acc: float = 0.0

	func _ready() -> void:
		set_process(true)
		queue_redraw()

	func _process(delta: float) -> void:
		_acc += delta
		if _acc < 1.0 / 30.0:
			return
		_t += _acc
		_acc = 0.0
		queue_redraw()

	func _draw() -> void:
		var zid: String = ui.manager.zone_id()
		var d: Dictionary = BoardArt.raw(zid)
		var cols: int = int(d.get("cols", 0))
		var rows: int = int(d.get("rows", 0))
		var cs: float = BoardArt.iso_cs(zid)
		var hw: float = BoardArt.ISO_TW * cs * 0.5
		var hh: float = BoardArt.ISO_TH * cs * 0.5
		var bot: Vector2 = BoardArt.iso_origin(zid) + Vector2(float(cols - rows) * hw * 0.5, float(cols + rows) * hh * 0.5)
		# clapot autour de l'île
		var wr: float = float(cols + rows) * hw * 0.62
		for k in range(12):
			var rr := RandomNumberGenerator.new()
			rr.seed = k * 71 + 3
			var ang: float = float(k) / 12.0 * TAU + sin(_t * 0.7 + float(k)) * 0.06
			var rad: float = wr * (0.97 + 0.05 * sin(_t * 1.1 + float(k) * 2.0))
			var wp: Vector2 = bot + Vector2(cos(ang) * rad, 170.0 + sin(ang) * rad * 0.24)
			draw_arc(wp, rr.randf_range(12.0, 26.0), ang + 0.4, ang + PI - 0.4, 10, Color(0.60, 0.85, 0.88, 0.30), 2.0, true)
		# nuages qui dérivent
		var wsize: Vector2 = BoardArt.world_size(zid)
		var base_y: float = BoardArt.iso_origin(zid).y
		for ci in range(3):
			var cx: float = fposmod(float(ci) * 0.37 * wsize.x + _t * (6.0 + float(ci) * 2.5), wsize.x + 320.0) - 160.0
			var cy: float = base_y - 320.0 + float(ci) * 38.0
			draw_set_transform(Vector2(cx, cy), 0.0, Vector2(1.0, 0.45))
			draw_circle(Vector2.ZERO, 34.0 + float(ci) * 8.0, Color(1, 1, 1, 0.72))
			draw_circle(Vector2(-26, 6), 22.0, Color(1, 1, 1, 0.55))
			draw_circle(Vector2(24, 8), 26.0, Color(1, 1, 1, 0.55))
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


## V114 : couche de LUMIÈRE statique au-dessus de la carte 2D (planche ou plateau iso) :
## teinte globale chaude, taches de lumière au sol (dappled light), ombres de contact
## renforcées sous les arbres de premier plan, rayons de soleil aux lisières, vignette.
## Un seul redraw ; allégé en qualité « Économie ».
class BoardLight extends Node2D:
	var ui: Node = null
	static var _vg: Texture2D = null

	func _ready() -> void:
		queue_redraw()

	static func _vignette_tex() -> Texture2D:
		if _vg != null:
			return _vg
		var img := Image.create(256, 256, false, Image.FORMAT_RGBA8)
		for y in range(256):
			for x in range(256):
				var dx: float = (float(x) - 128.0) / 128.0
				var dy: float = (float(y) - 128.0) / 128.0
				var q: float = clampf(sqrt(dx * dx + dy * dy) - 0.55, 0.0, 1.0) / 0.45
				img.set_pixel(x, y, Color(0.04, 0.03, 0.08, q * q * 0.42))
		_vg = ImageTexture.create_from_image(img)
		return _vg

	func _draw() -> void:
		var zid: String = ui.manager.zone_id()
		var d: Dictionary = BoardArt.raw(zid)
		var ws: Vector2 = BoardArt.world_size(zid)
		var low: bool = GfxQuality.low()
		# teinte globale chaude
		draw_rect(Rect2(Vector2.ZERO, ws), Color(1.0, 0.94, 0.82, 0.05))
		if not low:
			var sz: Vector2i = BoardArt.size(zid)
			var rng := RandomNumberGenerator.new()
			rng.seed = absi(zid.hash()) + 77
			# taches de lumière filtrant la canopée
			var n: int = int(260.0 * GfxQuality.density())
			for i in range(n):
				var c := Vector2i(rng.randi_range(0, sz.x - 1), rng.randi_range(0, sz.y - 1))
				if not BoardArt.walkable_cell(zid, c):
					continue
				var p: Vector2 = ui.cell_center(c)
				draw_set_transform(p, 0.0, Vector2(1.0, 0.5))
				draw_circle(Vector2.ZERO, rng.randf_range(18.0, 46.0), Color(1.0, 0.95, 0.70, rng.randf_range(0.05, 0.11)))
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			# ombres de contact renforcées + rayons de soleil aux lisières (clé "over")
			for k: String in (d.get("over", {}) as Dictionary).keys():
				var op: Vector2i = AdventureTerrain.parse(k)
				var pp: Vector2 = ui.cell_center(op)
				draw_set_transform(pp + Vector2(6, 10), 0.0, Vector2(1.0, 0.4))
				draw_circle(Vector2.ZERO, 52.0, Color(0.02, 0.05, 0.02, 0.30))
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
				for b in range(2):
					var bx: float = pp.x + rng.randf_range(-30.0, 30.0)
					var w0: float = rng.randf_range(8.0, 16.0)
					draw_polygon(PackedVector2Array([
						Vector2(bx - w0, -ws.y * 0.2), Vector2(bx + w0, -ws.y * 0.2),
						pp + Vector2(rng.randf_range(26.0, 60.0), -40.0), pp + Vector2(rng.randf_range(-60.0, -26.0), -40.0)]),
						PackedColorArray([Color(1.0, 0.93, 0.66, 0.10), Color(1.0, 0.93, 0.66, 0.10),
							Color(1.0, 0.93, 0.66, 0.0), Color(1.0, 0.93, 0.66, 0.0)]))
		# vignette douce
		var vg := _vignette_tex()
		if vg != null:
			draw_texture_rect(vg, Rect2(Vector2.ZERO, ws), false)


## V114 : flash bref sur une case (trouvaille ramassée) — anneau qui s'élargit et s'estompe.
class FxFlash extends Node2D:
	var _t: float = 0.0

	func _ready() -> void:
		set_process(true)

	func _process(delta: float) -> void:
		_t += delta
		if _t >= 0.55:
			queue_free()
			return
		queue_redraw()

	func _draw() -> void:
		var f: float = _t / 0.55
		draw_arc(Vector2.ZERO, 20.0 + f * 60.0, 0.0, TAU, 24, Color(1.0, 0.9, 0.5, (1.0 - f) * 0.8), 4.0, true)
		draw_circle(Vector2.ZERO, 10.0 * (1.0 - f) + 4.0, Color(1.0, 0.95, 0.6, (1.0 - f) * 0.5))


## V106 : bâtiment stylisé du plateau iso (maison, chaumière, grange, moulin, tour, chapelle).
## Dessiné en code : un volume isométrique à deux faces (lumière à gauche) + toit. Origine = sommet avant de l'emprise.
class BuildingNode extends Node2D:
	var kind: String = "maison"
	var fw: int = 2
	var fh: int = 2
	var cs: float = 0.625
	var seed_value: int = 0
	var _t: float = 0.0

	const STYLE := {
		"maison": {"wall": Color(0.90, 0.83, 0.68), "frame": Color(0.45, 0.30, 0.18), "roof": Color(0.70, 0.30, 0.22), "wh": 96.0, "rh": 64.0, "roof_kind": "gable"},
		"chaumiere": {"wall": Color(0.74, 0.58, 0.40), "frame": Color(0.40, 0.27, 0.16), "roof": Color(0.82, 0.68, 0.34), "wh": 62.0, "rh": 52.0, "roof_kind": "gable"},
		"grange": {"wall": Color(0.62, 0.40, 0.30), "frame": Color(0.36, 0.22, 0.16), "roof": Color(0.52, 0.26, 0.22), "wh": 100.0, "rh": 66.0, "roof_kind": "gable"},
		"moulin": {"wall": Color(0.80, 0.77, 0.72), "frame": Color(0.50, 0.46, 0.42), "roof": Color(0.55, 0.36, 0.26), "wh": 170.0, "rh": 66.0, "roof_kind": "pyramid"},
		"tour": {"wall": Color(0.70, 0.70, 0.72), "frame": Color(0.44, 0.44, 0.48), "roof": Color(0.30, 0.42, 0.58), "wh": 210.0, "rh": 80.0, "roof_kind": "pyramid"},
		"chapelle": {"wall": Color(0.82, 0.82, 0.80), "frame": Color(0.50, 0.50, 0.52), "roof": Color(0.32, 0.45, 0.60), "wh": 112.0, "rh": 66.0, "roof_kind": "gable"},
	}

	## V107 : sprites cuits depuis les kits Kenney (CC0) — tools/bake_kenney.gd ; repli sur le dessin en code si absents.
	const KENNEY_DIR := "res://assets/sprites/decor/kenney/batiments/"
	const KENNEY_VARIANTS := {"maison": ["maison_bois", "maison_pierre"], "chaumiere": ["chaumiere"], "grange": ["grange"],
		"moulin": ["moulin"], "tour": ["tour"], "chapelle": ["chapelle"]}
	static var _ktable: Dictionary = {}
	static var _ktex: Dictionary = {}

	static func kenney_sprite(kind_: String, seed_: int) -> String:
		if _ktable.is_empty():
			var raw: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://data/batiments_kenney.json"))
			_ktable = raw if raw is Dictionary else {"_": true}
		var names: Array = KENNEY_VARIANTS.get(kind_, [])
		if names.is_empty():
			return ""
		var nm: String = String(names[absi(seed_) % names.size()])
		if not _ktable.has(nm):
			return ""
		if not _ktex.has(nm):
			_ktex[nm] = load(KENNEY_DIR + nm + ".png") as Texture2D
		return nm if _ktex[nm] != null else ""

	func _draw_kenney(nm: String) -> void:
		var m: Dictionary = _ktable[nm]
		var tex: Texture2D = _ktex[nm]
		var hw: float = BoardArt.ISO_TW * cs * 0.5
		var hh: float = BoardArt.ISO_TH * cs * 0.5
		var sc: float = float(fw + fh) * hw / float(m["ref"])
		# ombre douce au sol (emprise de la bâtisse)
		var ex := Vector2(hw * fw, hh * fw)
		var ey := Vector2(-hw * fh, hh * fh)
		draw_colored_polygon(PackedVector2Array([Vector2(8, 3) - ex - ey, Vector2(14, 4) - ey, Vector2(10, 8), Vector2(2, 6) - ex]), Color(0.03, 0.06, 0.08, 0.20))
		draw_texture_rect(tex, Rect2(-Vector2(float(m["ax"]), float(m["ay"])) * sc, Vector2(tex.get_width(), tex.get_height()) * sc), false)

	func _ready() -> void:
		set_process(((kind == "moulin" and kenney_sprite(kind, seed_value) == "") or kind == "feu") and not GfxQuality.low())

	func _process(delta: float) -> void:
		_t += delta
		if _on_screen():
			queue_redraw()

	## V118 : on ne redessine (animation) que si le nœud est à l'écran — sur les grandes cartes,
	## des dizaines de lieux / monstres / trouvailles se redessinaient à chaque image même hors champ.
	func _on_screen() -> bool:
		var p: Vector2 = get_global_transform_with_canvas().origin
		var vs: Vector2 = get_viewport_rect().size
		return p.x > -260.0 and p.y > -260.0 and p.x < vs.x + 260.0 and p.y < vs.y + 260.0

	func _up(h: float) -> Vector2:
		return Vector2(0.0, -h)

	func _quad(a: Vector2, b: Vector2, c: Vector2, d: Vector2, col: Color, line: bool = true) -> void:
		draw_colored_polygon(PackedVector2Array([a, b, c, d]), col)
		if line:
			draw_polyline(PackedVector2Array([a, b, c, d, a]), Color(0.10, 0.07, 0.05, 0.55), 1.2, true)

	func _tri(a: Vector2, b: Vector2, c: Vector2, col: Color) -> void:
		draw_colored_polygon(PackedVector2Array([a, b, c]), col)
		draw_polyline(PackedVector2Array([a, b, c, a]), Color(0.10, 0.07, 0.05, 0.55), 1.2, true)

	## V114 : petits aménagements dessinés en code (pas de sprite Kenney cuit pour ceux-là).
	func _draw_small_prop(kind: String, hw: float, hh: float) -> void:
		var rng := RandomNumberGenerator.new()
		rng.seed = seed_value
		var wood := Color(0.50, 0.36, 0.22)
		var wood_l := wood.lightened(0.15)
		var stone := Color(0.55, 0.55, 0.58)
		match kind:
			"puits":
				draw_set_transform(Vector2(0, 2), 0.0, Vector2(1.0, 0.45))
				draw_circle(Vector2.ZERO, 26.0, stone.darkened(0.15))
				draw_circle(Vector2.ZERO, 19.0, Color(0.08, 0.12, 0.16))
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
				for i in range(8):
					var a := TAU * float(i) / 8.0
					draw_circle(Vector2(cos(a) * 24.0, 2.0 + sin(a) * 11.0), 5.0, stone.lightened(rng.randf_range(-0.08, 0.08)))
				draw_line(Vector2(-20, 0), Vector2(-20, -46), wood, 6.0)
				draw_line(Vector2(20, 0), Vector2(20, -46), wood, 6.0)
				_tri(Vector2(-26, -44), Vector2(0, -62), Vector2(26, -44), Color(0.62, 0.30, 0.20))
				draw_line(Vector2(-20, -44), Vector2(20, -44), wood_l, 3.0)
				draw_line(Vector2(0, -44), Vector2(0, -18), Color(0.25, 0.20, 0.14), 2.0)
				draw_rect(Rect2(-5, -20, 10, 8), Color(0.45, 0.33, 0.20))
			"feu":
				var fl: float = 1.0 + 0.18 * sin(_t * 9.0) + 0.08 * sin(_t * 23.0)
				draw_set_transform(Vector2(0, 4), 0.0, Vector2(1.0, 0.42))
				draw_circle(Vector2.ZERO, 30.0 + 6.0 * sin(_t * 9.0), Color(1.0, 0.55, 0.15, 0.16))
				draw_circle(Vector2.ZERO, 24.0, Color(0.06, 0.05, 0.05, 0.25))
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
				for i in range(7):
					var a2 := TAU * float(i) / 7.0
					draw_circle(Vector2(cos(a2) * 20.0, 4.0 + sin(a2) * 8.0), 4.5, stone.darkened(rng.randf_range(0.0, 0.15)))
				draw_line(Vector2(-12, 2), Vector2(10, -6), wood, 5.0)
				draw_line(Vector2(-8, -4), Vector2(12, 4), wood_l, 5.0)
				_tri(Vector2(-10, 2), Vector2(0, -26.0 * fl), Vector2(10, 2), Color(1.0, 0.62, 0.18, 0.95))
				_tri(Vector2(-5, 2), Vector2(0, -16.0 * fl), Vector2(5, 2), Color(1.0, 0.88, 0.40, 0.95))
			"etal":
				for px in [-24.0, 24.0]:
					draw_line(Vector2(px, 2), Vector2(px, -40), wood, 5.0)
				_quad(Vector2(-30, -38), Vector2(30, -38), Vector2(24, -50), Vector2(-24, -50), Color(0.85, 0.30, 0.25))
				for i in range(4):
					var x0: float = -30.0 + float(i) * 15.0
					_quad(Vector2(x0, -38), Vector2(x0 + 7.5, -38), Vector2(x0 + 6.0, -50), Vector2(x0 - 1.5, -50), Color(0.95, 0.92, 0.82))
				draw_rect(Rect2(-26, -14, 52, 12), wood_l)
				draw_rect(Rect2(-26, -14, 52, 4), wood.darkened(0.2))
				draw_rect(Rect2(-20, -26, 12, 10), Color(0.65, 0.45, 0.25))
				draw_rect(Rect2(8, -27, 12, 11), Color(0.55, 0.38, 0.22))

	func _draw() -> void:
		var kn: String = kenney_sprite(kind, seed_value)
		if kn != "":
			_draw_kenney(kn)
			return
		if kind in ["puits", "feu", "etal"]:
			var hw0: float = BoardArt.ISO_TW * cs * 0.5
			var hh0: float = BoardArt.ISO_TH * cs * 0.5
			_draw_small_prop(kind, hw0, hh0)
			return
		var st: Dictionary = STYLE.get(kind, STYLE["maison"])
		var hw: float = BoardArt.ISO_TW * cs * 0.5
		var hh: float = BoardArt.ISO_TH * cs * 0.5
		var inset: float = 0.10
		var ex := Vector2(hw * fw, hh * fw) * (1.0 - inset)
		var ey := Vector2(-hw * fh, hh * fh) * (1.0 - inset)
		# C = sommet avant (origine) ; on recentre légèrement l'emprise pour laisser un peu d'herbe autour
		var C := Vector2(0.0, -hh * 0.35)
		var D: Vector2 = C - ex
		var B: Vector2 = C - ey
		var A: Vector2 = C - ex - ey
		var wh: float = float(st["wh"])
		var rh: float = float(st["rh"])
		var wall: Color = st["wall"]
		var frame: Color = st["frame"]
		var roof: Color = st["roof"]
		var wl: Color = wall
		var wr: Color = wall.darkened(0.22)
		# ombre au sol
		draw_colored_polygon(PackedVector2Array([A + Vector2(8, 3), B + Vector2(14, 4), C + Vector2(10, 8), D + Vector2(2, 6)]), Color(0.03, 0.06, 0.08, 0.20))
		var A2: Vector2 = A + _up(wh)
		var B2: Vector2 = B + _up(wh)
		var C2: Vector2 = C + _up(wh)
		var D2: Vector2 = D + _up(wh)
		var rg: String = String(st["roof_kind"])
		var rs: Vector2 = (A + D) * 0.5 + _up(wh + rh)
		var re: Vector2 = (B + C) * 0.5 + _up(wh + rh)
		var apex: Vector2 = (A + C) * 0.5 + _up(wh + rh)
		if rg == "gable":
			_quad(A2, B2, re, rs, roof.darkened(0.30))                      # pan arrière
		# murs
		_quad(D, C, C2, D2, wl)
		_quad(C, B, B2, C2, wr)
		var rng := RandomNumberGenerator.new()
		rng.seed = seed_value
		var timber: bool = kind in ["maison", "chaumiere", "grange"]
		# structure : colombages / assises de pierre
		if timber:
			for i: int in range(1, fw * 2):
				var f: float = float(i) / float(fw * 2)
				draw_line(D.lerp(C, f), D2.lerp(C2, f), frame, 2.0)
			draw_line(D2.lerp(C2, 0.0), C2, frame, 2.5)
			draw_line(D + _up(wh * 0.5), C + _up(wh * 0.5), frame.lightened(0.1), 1.5)
			for i2: int in range(1, fh * 2):
				var f2: float = float(i2) / float(fh * 2)
				draw_line(C.lerp(B, f2), C2.lerp(B2, f2), frame.darkened(0.15), 2.0)
		else:
			for row: int in range(1, int(wh / 20.0)):
				var hy: float = float(row) * 20.0
				draw_line(D + _up(hy), C + _up(hy), frame, 1.0)
				draw_line(C + _up(hy), B + _up(hy), frame.darkened(0.2), 1.0)
				for j: int in range(1, 4):
					var jf: float = (float(j) + float(row % 2) * 0.5) / 4.0
					draw_line(D.lerp(C, jf) + _up(hy - 20.0), D.lerp(C, jf) + _up(hy), frame, 1.0)
		# porte et fenêtres sur la face gauche
		var door_c: Vector2 = D.lerp(C, 0.5)
		var dw: float = 0.12 if kind != "grange" else 0.22
		var dh: float = minf(wh * 0.72, 74.0) if kind != "grange" else 84.0
		var d0: Vector2 = D.lerp(C, 0.5 - dw)
		var d1: Vector2 = D.lerp(C, 0.5 + dw)
		_quad(d0, d1, d1 + _up(dh), d0 + _up(dh), Color(0.20, 0.12, 0.08))
		if kind == "grange":
			draw_line(door_c, door_c + _up(dh), Color(0.5, 0.35, 0.2), 1.5)
		if wh > 40.0 and kind != "grange":
			for wf: float in [0.2, 0.8]:
				var w0: Vector2 = D.lerp(C, wf - 0.07) + _up(wh * 0.58)
				var w1: Vector2 = D.lerp(C, wf + 0.07) + _up(wh * 0.58)
				_quad(w0, w1, w1 + _up(24.0), w0 + _up(24.0), Color(0.95, 0.82, 0.45) if kind != "tour" else Color(0.15, 0.12, 0.2))
		if wh > 40.0 and kind in ["tour", "moulin", "chapelle"]:
			var wc: Vector2 = C.lerp(B, 0.5) + _up(wh * 0.6)
			var w2: Vector2 = wc + (B - C).normalized() * 10.0
			var w3: Vector2 = wc - (B - C).normalized() * 10.0
			_quad(w3, w2, w2 + _up(28.0), w3 + _up(28.0), Color(0.15, 0.12, 0.2) if kind != "chapelle" else Color(0.45, 0.65, 0.85))
		# toit
		if rg == "gable":
			_tri(C2, B2, re, wr)                                           # pignon (face droite)
			_quad(D2, C2, re, rs, roof)                                     # pan avant
			# rebord de toit
			draw_line(D2, C2, roof.darkened(0.45), 3.0)
			draw_line(rs, re, roof.lightened(0.25), 2.5)
			if kind in ["maison", "grange"]:
				var ch: Vector2 = D2.lerp(re, 0.55) + Vector2(10, 0)
				_quad(ch, ch + Vector2(15, 5), ch + Vector2(15, -17), ch + Vector2(0, -22), Color(0.55, 0.50, 0.46))
				_quad(ch + Vector2(0, -22), ch + Vector2(15, -17), ch + Vector2(15, -38), ch + Vector2(0, -43), Color(0.40, 0.36, 0.34))
			if kind == "chaumiere":
				for i3: int in range(1, 5):
					var tf: float = float(i3) / 5.0
					draw_line(D2.lerp(rs, tf), C2.lerp(re, tf), roof.darkened(0.18), 1.2)
			if kind == "chapelle":
				var sb: Vector2 = (rs + re) * 0.5
				_quad(sb + Vector2(-12, 0), sb + Vector2(12, 8), sb + Vector2(12, -38), sb + Vector2(-12, -46), wl)
				_tri(sb + Vector2(-15, -44), sb + Vector2(15, -34), sb + Vector2(0, -88), roof.lightened(0.1))
				draw_circle(sb + Vector2(0, -94), 5.0, Color(0.95, 0.8, 0.3))
		else:
			var fl: Vector2 = C2 + Vector2(0, 0)
			_tri(D2, C2, apex, roof)
			_tri(C2, B2, apex, roof.darkened(0.25))
			draw_line(D2, C2, roof.darkened(0.45), 3.0)
			draw_line(C2, B2, roof.darkened(0.55), 3.0)
			if kind == "tour":
				# créneaux sous le toit et fanion
				for i4: int in range(1, 4):
					var cf: float = float(i4) / 4.0
					var m0: Vector2 = D2.lerp(C2, cf)
					draw_rect(Rect2(m0 + Vector2(-5, -9), Vector2(10, 9)), wall.darkened(0.1))
				draw_line(apex, apex + Vector2(0, -36), Color(0.2, 0.15, 0.1), 3.0)
				draw_colored_polygon(PackedVector2Array([apex + Vector2(0, -36), apex + Vector2(26, -28), apex + Vector2(0, -20)]), Color(0.85, 0.2, 0.2))
			if kind == "moulin":
				var hub: Vector2 = (D + C) * 0.5 + _up(wh * 0.72) + Vector2(0, 2)
				var ang: float = _t * 0.9
				for i5: int in range(4):
					var a5: float = ang + float(i5) * PI * 0.5
					var tip: Vector2 = hub + Vector2(cos(a5), sin(a5)) * 80.0
					draw_line(hub, tip, Color(0.45, 0.32, 0.20), 5.0, true)
					var side: Vector2 = Vector2(-sin(a5), cos(a5)) * 15.0
					draw_colored_polygon(PackedVector2Array([hub + (tip - hub) * 0.35, tip, tip + side, hub + (tip - hub) * 0.35 + side]), Color(0.93, 0.90, 0.80, 0.95))
				draw_circle(hub, 7.0, Color(0.3, 0.2, 0.12))


## Décor (arbre, rocher, fleurs…) dessiné par BattleScenery.
class DecorNode extends Node2D:
	var kind: String = "tree"
	var biome: String = "Forêt"
	var pal: Dictionary = {}
	var seed_value: int = 0
	var use_sprites: bool = false   # V114 : planche v2 — sprites illustrés même hors réglage « iso »

	func _draw() -> void:
		var rng := RandomNumberGenerator.new()
		rng.seed = seed_value
		if (use_sprites or SpriteDecor.active(biome)) and SpriteDecor.draw(self, kind, rng):
			return
		BattleScenery.draw_prop(self, kind, pal, biome, rng, 0.0)


## Lieu remarquable : objet au sol, halo, icône flottante, nom, ennemi pour les camps.
class PoiNode extends Node2D:
	var forest_style: bool = false
	var kind: String = "combat"
	var is_dungeon: bool = false
	var portal: bool = false
	var title: String = ""
	var level: int = 10
	var biome: String = "Forêt"
	var pal: Dictionary = {}
	var icon: Texture2D = null
	var prop: String = ""
	var enemy_tex: Texture2D = null
	var done: bool = false
	var show_label: bool = false
	var nearby: bool = false
	var gem: Color = Color(0, 0, 0, 0)
	var gem_taken: bool = false
	var locked: bool = false
	var _t: float = 0.0

	func _ready() -> void:
		_t = float(absi(int(position.x * 3 + position.y))) * 0.01
		set_process(true)

	func _process(delta: float) -> void:
		_t += delta
		if _on_screen():
			queue_redraw()

	## V118 : on ne redessine (animation) que si le nœud est à l'écran — sur les grandes cartes,
	## des dizaines de lieux / monstres / trouvailles se redessinaient à chaque image même hors champ.
	func _on_screen() -> bool:
		var p: Vector2 = get_global_transform_with_canvas().origin
		var vs: Vector2 = get_viewport_rect().size
		return p.x > -260.0 and p.y > -260.0 and p.x < vs.x + 260.0 and p.y < vs.y + 260.0

	## Forme du médaillon selon le type de lieu (0 = rond) et sa rotation.
	const MEDAL_SIDES: Dictionary = {"combat": 6, "chest": 4, "puzzle": 4, "reveal": 8, "camp": 0}
	const MEDAL_ROT: Dictionary = {"combat": PI / 6.0, "chest": PI / 4.0, "puzzle": 0.0, "reveal": PI / 8.0}

	static func _medal_pts(center: Vector2, r: float, sides: int, rot: float) -> PackedVector2Array:
		var n: int = sides if sides >= 3 else 40
		var pts := PackedVector2Array()
		for i: int in range(n):
			var a: float = rot + TAU * float(i) / float(n)
			# un carré / losange reste plus compact qu'un polygone inscrit au même rayon
			var k: float = 1.0 if sides != 4 else 0.86
			pts.append(center + Vector2(cos(a), sin(a)) * r * k)
		return pts

	## V119 : couleur d'état d'un donjon — or (ouvert), gris rougeâtre (verrouillé), vert (terminé).
	const DUN_OPEN := Color(1.0, 0.78, 0.30)
	const DUN_LOCK := Color(0.56, 0.50, 0.54)
	const DUN_DONE := Color(0.42, 0.82, 0.48)

	func _dungeon_col() -> Color:
		if done:
			return DUN_DONE
		return DUN_LOCK if locked else DUN_OPEN

	## Cadenas vectoriel (les émojis ne s'affichent pas sur tous les Android).
	func _draw_padlock(c: Vector2, s: float) -> void:
		draw_circle(c + Vector2(0, 1.5 * s), 12.0 * s, Color(0.02, 0.02, 0.04, 0.55))
		draw_arc(c + Vector2(0, -3.0 * s), 6.0 * s, PI, TAU, 16, Color(0.10, 0.10, 0.12), 4.6 * s, true)
		draw_arc(c + Vector2(0, -3.0 * s), 6.0 * s, PI, TAU, 16, Color(0.80, 0.80, 0.84), 2.6 * s, true)
		draw_line(c + Vector2(-6.0 * s, -3.0 * s), c + Vector2(-6.0 * s, 0), Color(0.80, 0.80, 0.84), 2.6 * s, true)
		draw_line(c + Vector2(6.0 * s, -3.0 * s), c + Vector2(6.0 * s, 0), Color(0.80, 0.80, 0.84), 2.6 * s, true)
		var body := Rect2(c + Vector2(-9.0 * s, -1.0 * s), Vector2(18.0 * s, 13.0 * s))
		draw_rect(body.grow(1.5 * s), Color(0.10, 0.06, 0.06))
		draw_rect(body, Color(0.78, 0.26, 0.22))
		draw_rect(Rect2(body.position, Vector2(body.size.x, 3.0 * s)), Color(0.93, 0.45, 0.38))
		draw_circle(c + Vector2(0, 4.5 * s), 2.2 * s, Color(0.12, 0.04, 0.04))
		draw_line(c + Vector2(0, 4.5 * s), c + Vector2(0, 8.5 * s), Color(0.12, 0.04, 0.04), 1.6 * s)

	func _draw() -> void:
		var col: Color = _dungeon_col() if is_dungeon else POI_COLOR.get(kind, Color.WHITE)
		var pulse: float = 0.5 + 0.5 * sin(_t * (2.0 if is_dungeon else 2.4))
		var dun_open: bool = is_dungeon and not done and not locked
		if dun_open:
			# Colonne de lumière dorée : un donjon ouvert se repère de loin, même dézoomé.
			var bh: float = 230.0
			for k: int in range(4):
				var w: float = 30.0 - float(k) * 7.0
				var a: float = (0.07 + 0.05 * pulse) * (1.0 + float(k) * 0.6)
				draw_colored_polygon(PackedVector2Array([Vector2(-w, 0), Vector2(w, 0), Vector2(w * 0.45, -bh), Vector2(-w * 0.45, -bh)]),
					Color(1.0, 0.86, 0.45, a))
			for k: int in range(3):
				var f: float = fmod(_t * 0.35 + float(k) / 3.0, 1.0)
				draw_circle(Vector2(sin(_t * 1.3 + float(k) * 2.1) * 10.0, -f * bh), 2.4, Color(1.0, 0.95, 0.70, 0.75 * (1.0 - f)))
		# Assise au sol : ombre douce et anneau de matière pour mieux détacher le POI du décor.
		# Cette couche est purement graphique et reste centrée sur la position existante.
		var ground_radius: float = 48.0 if is_dungeon else 34.0
		draw_set_transform(Vector2(0, 5), 0.0, Vector2(1.0, 0.34))
		draw_circle(Vector2.ZERO, ground_radius + 10.0, Color(0.015, 0.025, 0.035, 0.18))
		if forest_style:
			# Socle organique : mousse et pierres au lieu d'un simple disque lumineux.
			draw_circle(Vector2.ZERO, ground_radius + 2.0, Color(0.16, 0.29, 0.13, 0.38))
			for stone: Vector2 in [Vector2(-27, -5), Vector2(22, -10), Vector2(-9, 17), Vector2(31, 12)]:
				draw_circle(stone, 7.0, Color(0.34, 0.39, 0.27, 0.72))
				draw_circle(stone + Vector2(-1, -2), 3.5, Color(0.57, 0.61, 0.40, 0.72))
			draw_arc(Vector2.ZERO, ground_radius - 2.0, PI * 0.12, PI * 0.88, 32,
				Color(0.48, 0.68, 0.31, 0.44 if not done else 0.20), 2.4, true)
		else:
			draw_circle(Vector2.ZERO, ground_radius, Color(col.r * 0.45, col.g * 0.45, col.b * 0.45, 0.24))
			draw_arc(Vector2.ZERO, ground_radius - 3.0, PI * 0.12, PI * 0.88, 32,
				Color(col.r, col.g, col.b, 0.42 if not done else 0.20), 2.2, true)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		if not done:
			draw_set_transform(Vector2(0, 4), 0.0, Vector2(1.0, 0.5))
			if dun_open:
				# Double halo doré pulsé : le seuil est ouvert.
				draw_circle(Vector2.ZERO, 68.0 + pulse * 8.0, Color(1.0, 0.72, 0.22, 0.12 + 0.10 * pulse))
				draw_arc(Vector2.ZERO, 58.0 + pulse * 6.0, 0.0, TAU, 48, Color(1.0, 0.86, 0.45, 0.92), 4.0, true)
			elif is_dungeon:
				# Verrouillé : anneau fixe en pointillés, sans pulsation ni lumière.
				for k: int in range(16):
					var a0: float = TAU * float(k) / 16.0
					draw_arc(Vector2.ZERO, 58.0, a0, a0 + TAU / 32.0, 4, Color(0.62, 0.30, 0.30, 0.80), 3.5, true)
			draw_circle(Vector2.ZERO, 46.0 + pulse * 4.0, Color(col.r, col.g, col.b, 0.18 if is_dungeon else 0.16))
			draw_arc(Vector2.ZERO, 44.0 + pulse * 4.0, 0.0, TAU, 40, Color(col.r, col.g, col.b, 0.85 if is_dungeon else 0.75), 4.0 if is_dungeon else 3.0, true)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		var mod: Color = Color(1, 1, 1) if not done else Color(0.62, 0.62, 0.66)
		if is_dungeon and locked and not done:
			mod = Color(0.50, 0.48, 0.52)
			pulse = 0.0
		if prop != "":
			var rng := RandomNumberGenerator.new()
			rng.seed = 17
			draw_set_transform(Vector2(-8, 4), 0.0, Vector2(0.8, 0.8))
			BattleScenery.draw_prop(self, prop, pal, biome, rng, _t)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		if kind == "camp":
			var fl: float = 1.0 + 0.15 * sin(_t * 10.0)
			draw_circle(Vector2(18, -10), 18.0 * fl, Color(1.0, 0.55, 0.15, 0.18))
			draw_colored_polygon(PackedVector2Array([Vector2(12, -6), Vector2(15, -22 * fl), Vector2(18, -30 * fl), Vector2(22, -20 * fl), Vector2(25, -6)]), Color(1.0, 0.6, 0.18))
			draw_colored_polygon(PackedVector2Array([Vector2(15, -6), Vector2(18, -18 * fl), Vector2(22, -6)]), Color(1.0, 0.92, 0.5))
		if gem.a > 0.0 and not gem_taken:
			# Pierre Élémentaire en lévitation au-dessus du sanctuaire
			var gc := Vector2(-30, -70 + sin(_t * 1.7) * 5.0)
			draw_circle(gc, 20.0 + 3.0 * sin(_t * 3.0), Color(gem.r, gem.g, gem.b, 0.22))
			var gp := PackedVector2Array([gc + Vector2(0, -15), gc + Vector2(10, -4), gc + Vector2(7, 12), gc + Vector2(-7, 12), gc + Vector2(-10, -4)])
			draw_colored_polygon(gp, gem)
			draw_colored_polygon(PackedVector2Array([gc + Vector2(0, -15), gc + Vector2(10, -4), gc]), gem.lightened(0.35))
			draw_polyline(gp + PackedVector2Array([gp[0]]), gem.darkened(0.5), 1.6, true)
		if enemy_tex != null and not done:
			var h: float = 78.0 if gem.a <= 0.0 else 104.0
			var sc: float = h / float(enemy_tex.get_height())
			var w: float = float(enemy_tex.get_width()) * sc
			draw_texture_rect(enemy_tex, Rect2(Vector2(-w * 0.5 + 14.0, -h + 6.0), Vector2(w, h)), false)
		# Icône flottante
		var bob: float = sin(_t * 2.0) * 4.0
		var icon_r: float = 33.0 if is_dungeon else 28.0
		var icon_size: float = 58.0 if is_dungeon else 46.0
		var icon_y: float = -122.0 if is_dungeon else -104.0
		var ic := Vector2(0, icon_y + bob)
		if dun_open:
			draw_circle(ic, icon_r + 9.0 + pulse * 3.0, Color(1.0, 0.75, 0.25, 0.22))
		# À proximité, un anneau doux et pulsé indique que le lieu peut être activé.
		# Il reste discret à distance pour préserver la lisibilité de la carte.
		if nearby:
			draw_circle(ic, icon_r + 8.0 + pulse * 3.0, Color(col.r, col.g, col.b, 0.10 + pulse * 0.08))
			draw_arc(ic, icon_r + 7.0 + pulse * 3.0, 0.0, TAU, 40,
				Color(col.r, col.g, col.b, 0.48 + pulse * 0.32), 2.5, true)
		# Médaillon : silhouette propre à chaque type de lieu, fond teinté (et non noir) pour que
		# l'icône ressorte, même à l'échelle générale de la planche.
		var sides: int = 8 if is_dungeon else int(MEDAL_SIDES.get(kind, 0))
		var rot: float = float(MEDAL_ROT.get(kind, 0.0)) if not is_dungeon else PI / 8.0
		var rim_col: Color = col if not done else Color(0.5, 0.5, 0.55)
		var fill: Color = Color(0.06, 0.08, 0.14).lerp(col, 0.30 if not done else 0.10)
		draw_colored_polygon(_medal_pts(ic + Vector2(0, 4), icon_r + 3.0, sides, rot), Color(0.01, 0.02, 0.04, 0.34))
		var outer: PackedVector2Array = _medal_pts(ic, icon_r + 1.0, sides, rot)
		draw_colored_polygon(outer, Color(0.015, 0.02, 0.04, 0.97))
		draw_colored_polygon(_medal_pts(ic, icon_r - 2.5, sides, rot), fill)
		var ring: PackedVector2Array = _medal_pts(ic, icon_r - 1.0, sides, rot)
		ring.append(ring[0])
		draw_polyline(ring, rim_col, 3.5 if is_dungeon else 3.0, true)
		# Reflet supérieur : donne un léger volume au médaillon sans changer sa zone tactile.
		draw_arc(ic + Vector2(0, -1), icon_r - 6.0, PI * 1.15, PI * 1.85, 24,
			Color(1.0, 1.0, 1.0, 0.34 if not done else 0.12), 1.6, true)
		if icon != null:
			draw_texture_rect(icon, Rect2(ic - Vector2(icon_size * 0.5, icon_size * 0.5), Vector2(icon_size, icon_size)), false, mod)
		# V114 : étincelles autour du médaillon (absentes en qualité « Économie »)
		if not done and not (is_dungeon and locked) and not GfxQuality.low():
			for s_i in range(3):
				var sa: float = _t * 1.6 + float(s_i) * TAU / 3.0
				var sp := ic + Vector2(cos(sa), sin(sa) * 0.45) * (icon_r + 13.0 + 3.0 * sin(_t * 2.0 + float(s_i)))
				draw_circle(sp, 2.2, Color(1.0, 0.95, 0.60, 0.55 + 0.35 * sin(_t * 3.0 + float(s_i) * 2.0)))
		if locked and not done:
			draw_circle(ic, icon_r - 2.0, Color(0.02, 0.03, 0.07, 0.45))
			_draw_padlock(ic + Vector2(0, 2), 1.25)
		if done:
			draw_circle(ic + Vector2(19, -18), 11.0, Color(0.25, 0.75, 0.35))
			draw_string(ThemeDB.fallback_font, ic + Vector2(12, -12), "✓", HORIZONTAL_ALIGNMENT_CENTER, 14.0, 16, Color.WHITE)
		# Nom (près du héros ou au survol, pour ne pas surcharger la carte)
		if show_label:
			var font: Font = ThemeDB.fallback_font
			var txt: String = title
			var tw: float = font.get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 15).x + 18.0
			if is_dungeon:
				# Pastille d'état sous le nom : lisible sans couleur (texte) et sans émoji.
				var st: String = ("SCELLÉ" if locked else "OUVERT") if portal else ("TERMINÉ" if done else ("VERROUILLÉ" if locked else "OUVERT"))
				var sw: float = font.get_string_size(st, HORIZONTAL_ALIGNMENT_LEFT, -1, 13).x + 16.0
				var sr := Rect2(Vector2(-sw * 0.5, 48), Vector2(sw, 20))
				var ssb := StyleBoxFlat.new()
				ssb.bg_color = Color(col.r * 0.30, col.g * 0.30, col.b * 0.30, 0.92)
				ssb.border_color = col
				ssb.set_border_width_all(2)
				ssb.set_corner_radius_all(9)
				draw_style_box(ssb, sr)
				draw_string(font, sr.position + Vector2(8, 15), st, HORIZONTAL_ALIGNMENT_LEFT, sw, 13, col.lightened(0.35))
			var r := Rect2(Vector2(-tw * 0.5, 22), Vector2(tw, 24))
			var sb := StyleBoxFlat.new()
			sb.bg_color = Color(0.05, 0.07, 0.12, 0.85)
			sb.border_color = col
			sb.set_border_width_all(1)
			sb.set_corner_radius_all(10)
			draw_style_box(sb, r)
			# Ombre portée typographique : le nom reste lisible sur les zones claires du décor.
			draw_string(font, r.position + Vector2(9, 19), txt, HORIZONTAL_ALIGNMENT_LEFT, tw, 15, Color(0.0, 0.0, 0.0, 0.85))
			draw_string(font, r.position + Vector2(9, 17), txt, HORIZONTAL_ALIGNMENT_LEFT, tw, 15, Color(1, 0.96, 0.85))


## Trouvaille cachée : petit scintillement au sol (herbe, bourse ou relique).
class FindNode extends Node2D:
	var kind: String = "herb"
	var _t: float = 0.0

	func _ready() -> void:
		_t = float(absi(int(position.x * 7 + position.y))) * 0.013
		set_process(true)

	func _process(delta: float) -> void:
		_t += delta
		if _on_screen():
			queue_redraw()

	## V118 : on ne redessine (animation) que si le nœud est à l'écran — sur les grandes cartes,
	## des dizaines de lieux / monstres / trouvailles se redessinaient à chaque image même hors champ.
	func _on_screen() -> bool:
		var p: Vector2 = get_global_transform_with_canvas().origin
		var vs: Vector2 = get_viewport_rect().size
		return p.x > -260.0 and p.y > -260.0 and p.x < vs.x + 260.0 and p.y < vs.y + 260.0

	func _draw() -> void:
		var pulse: float = 0.5 + 0.5 * sin(_t * 3.0)
		var col: Color = {"herb": Color(0.55, 0.95, 0.55), "gold": Color(1.0, 0.85, 0.30), "relic": Color(0.75, 0.60, 1.0)}.get(kind, Color.WHITE)
		draw_set_transform(Vector2(0, 4), 0.0, Vector2(1.0, 0.5))
		draw_circle(Vector2.ZERO, 20.0 + pulse * 4.0, Color(col.r, col.g, col.b, 0.14 + 0.10 * pulse))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		match kind:
			"herb":
				for i: int in range(3):
					var a: float = -PI * 0.5 + (float(i) - 1.0) * 0.5
					draw_line(Vector2(0, 2), Vector2(cos(a), sin(a)) * 14.0 + Vector2(0, 2), Color(0.30, 0.65, 0.30), 3.0, true)
					draw_circle(Vector2(cos(a), sin(a)) * 14.0 + Vector2(0, 2), 3.2, col)
			"gold":
				draw_circle(Vector2(0, -3), 9.0, Color(0.70, 0.50, 0.15))
				draw_circle(Vector2(0, -5), 8.0, col)
				draw_circle(Vector2(-3, -8), 2.6, Color(1, 1, 0.8, 0.9))
			_:
				draw_colored_polygon(PackedVector2Array([Vector2(0, -22), Vector2(8, -10), Vector2(0, 0), Vector2(-8, -10)]), col)
				draw_colored_polygon(PackedVector2Array([Vector2(0, -22), Vector2(8, -10), Vector2(0, -10)]), col.lightened(0.35))
		var tw: float = 0.5 + 0.5 * sin(_t * 4.0 + 1.0)
		var sp := Vector2(10, -18 - pulse * 4.0)
		draw_line(sp + Vector2(-5, 0), sp + Vector2(5, 0), Color(1, 1, 1, 0.4 + 0.5 * tw), 2.0, true)
		draw_line(sp + Vector2(0, -5), sp + Vector2(0, 5), Color(1, 1, 1, 0.4 + 0.5 * tw), 2.0, true)


## Héros : sprite de la classe de l'explorateur, ombre, anneau doré, petit rebond.
class HeroView extends Node2D:
	const WALK_SHEET_DIR := "res://assets/sprites/walk3d/"
	const SHEET_IDLE := 4
	const SHEET_WALK := 8
	var tex: Texture2D = null
	var sprite_height: float = 104.0
	var forest_style: bool = false
	## Planche « modèle 3D cuit » (8 directions × [4 repos + 8 marche]) ; null = illustrations seules.
	var sheet: Texture2D = null
	var walk_poses: Array[Texture2D] = []
	var back_tex: Texture2D = null
	var back_walk_poses: Array[Texture2D] = []
	var idle_poses: Array[Texture2D] = []
	var back_idle_poses: Array[Texture2D] = []
	var hop: float = 0.0
	## V130 : teinte de lumière du lieu, rejointe en douceur (pas de saut de couleur d'une case à l'autre).
	var light_target: Color = Color.WHITE
	var _flip: bool = false
	var walking: bool = false
	var running: bool = false
	var _walk_dir: Vector2 = Vector2.DOWN
	var _t: float = 0.0
	var _gait_t: float = 0.0
	var _reaction_t: float = 0.0
	var _idle_timer: float = 4.0
	var _idle_variant: Texture2D = null
	var _motion_blend: float = 0.0
	var _settle_t: float = 0.0
	var _turn_t: float = 0.0

	func _ready() -> void:
		# Les poses sont rangées à côté du sprite de classe (comme pour EntityView).
		# On charge toutes les variantes walk_2…, idle_2… et back_walk_2… disponibles.
		if tex != null:
			var sprite_key: String = tex.resource_path.get_file().get_basename()
			var gs: Node = (Engine.get_main_loop() as SceneTree).root.get_node_or_null("GameSettings")
			if gs == null or bool(gs.get("adventure_walk_sprites")):
				var sheet_path: String = WALK_SHEET_DIR + sprite_key + ".png"
				if ResourceLoader.exists(sheet_path):
					sheet = load(sheet_path) as Texture2D
			var pose_root: String = "res://assets/sprites/nations/heros/poses/"
			var back_path: String = pose_root + sprite_key + "_back.png"
			if ResourceLoader.exists(back_path):
				back_tex = load(back_path) as Texture2D
			walk_poses = _load_pose_variants(pose_root + sprite_key + "_walk", false)
			back_walk_poses = _load_pose_variants(pose_root + sprite_key + "_back_walk", false)
			idle_poses = _load_pose_variants(pose_root + sprite_key + "_idle", true)
			back_idle_poses = _load_pose_variants(pose_root + sprite_key + "_back_idle", true)
		_idle_timer = randf_range(3.5, 6.0)
		set_process(true)

	## Direction (0 = vers le bas, puis par pas de 45° dans le sens horaire de l'écran) d'un vecteur de marche.
	static func sheet_dir(v: Vector2) -> int:
		return posmod(roundi(atan2(v.x, v.y) / (PI / 4.0)), 8)

	## Colonne de la planche : 0‑3 repos (respiration lente), 4‑11 boucle de marche.
	static func sheet_col(moving: bool, running_now: bool, gait: float, t: float) -> int:
		if moving:
			return SHEET_IDLE + int(gait / (0.075 if running_now else 0.1)) % SHEET_WALK
		return int(t * 2.5) % SHEET_IDLE

	func _draw_sheet_frame() -> void:
		var cell := Vector2(sheet.get_width() / float(SHEET_IDLE + SHEET_WALK), sheet.get_height() / 8.0)
		var moving: bool = walking or _settle_t > 0.0
		var col: int = sheet_col(moving, running, _gait_t, _t)
		var src := Rect2(Vector2(col * cell.x, sheet_dir(_walk_dir) * cell.y), cell)
		var dh: float = sprite_height / 0.89
		var dw: float = dh * cell.x / cell.y
		var bob: float = absf(sin(_gait_t * TAU / (0.18 if running else 0.24))) * (3.0 if running else 2.0) * _motion_blend
		var dest := Rect2(Vector2(-dw * 0.5, 0.05 * dh + 4.0 - dh - hop - bob), Vector2(dw, dh))
		for o: Vector2 in [Vector2(-1.5, 0), Vector2(1.5, 0), Vector2(0, -1.5), Vector2(0, 1.5)]:
			draw_texture_rect_region(sheet, Rect2(dest.position + o, dest.size), src, Color(0.05, 0.07, 0.10, 0.30))
		draw_texture_rect_region(sheet, dest, src)

	func _load_pose_variants(stem: String, skip_first: bool) -> Array[Texture2D]:
		var result: Array[Texture2D] = []
		for index: int in range(1, 10):
			if skip_first and index == 1:
				continue
			var path: String = stem + ".png" if index == 1 else stem + "_%d.png" % index
			if ResourceLoader.exists(path):
				var pose_tex: Texture2D = load(path) as Texture2D
				if pose_tex != null:
					result.append(pose_tex)
		return result

	func _process(delta: float) -> void:
		modulate = modulate.lerp(light_target, clampf(delta * 6.0, 0.0, 1.0))
		_t += delta
		_motion_blend = move_toward(_motion_blend, 1.0 if walking else 0.0, delta * (6.5 if walking else 4.0))
		_turn_t = maxf(0.0, _turn_t - delta)
		if _settle_t > 0.0:
			_settle_t = maxf(0.0, _settle_t - delta)
			if _settle_t == 0.0 and not walking:
				_gait_t = 0.0
		if walking:
			_gait_t += delta
			_idle_variant = null
			_idle_timer = randf_range(3.5, 6.0)
		else:
			_idle_timer -= delta
			if _idle_timer <= 0.0:
				if _idle_variant == null:
					var facing_back: bool = _walk_dir.y < -0.12
					var idle_pool: Array[Texture2D] = back_idle_poses if facing_back else idle_poses
					if not idle_pool.is_empty():
						_idle_variant = idle_pool[randi() % idle_pool.size()]
						_idle_timer = randf_range(1.0, 1.7)
					else:
						_idle_timer = randf_range(4.0, 7.0)
				else:
					_idle_variant = null
					_idle_timer = randf_range(4.0, 7.0)
		if _reaction_t > 0.0:
			_reaction_t = maxf(0.0, _reaction_t - delta)
		queue_redraw()

	## Petite réaction positive à une trouvaille ou à l'arrivée sur un lieu.
	func react() -> void:
		_reaction_t = 0.65
		queue_redraw()

	func face(dx: float) -> void:
		if absf(dx) > 1.0:
			var next_flip: bool = dx < 0.0
			if next_flip != _flip:
				_flip = next_flip
				_turn_t = 0.18
				queue_redraw()

	func locomotion(direction: Vector2, active: bool, sprint: bool = false) -> void:
		if active and not walking:
			_gait_t = 0.0
			_settle_t = 0.0
		if not active and walking:
			# Conserve brièvement la dernière pose de marche pour amortir l'arrêt.
			_settle_t = 0.16
		walking = active
		running = active and sprint
		if direction.length_squared() > 0.01:
			_walk_dir = direction.normalized()
			face(direction.x)
			queue_redraw()

	func _draw() -> void:
		# Ombre de contact adaptée à la profondeur et à la hauteur du saut.
		var depth_t: float = clampf((scale.x - 0.86) / 0.26, 0.0, 1.0)
		var shadow_radius: float = lerpf(30.0, 38.0, depth_t)
		var shadow_alpha: float = clampf(0.30 - hop * 0.012, 0.12, 0.30)
		draw_set_transform(Vector2(0, 4), 0.0, Vector2(1.0, 0.45))
		draw_circle(Vector2.ZERO, shadow_radius + 8.0, Color(0.06, 0.12, 0.05, 0.12))
		draw_circle(Vector2.ZERO, shadow_radius, Color(0, 0, 0, shadow_alpha))
		if forest_style:
			draw_circle(Vector2(0, 2), shadow_radius * 0.72, Color(0.28, 0.48, 0.18, 0.12))
			draw_arc(Vector2.ZERO, shadow_radius + 2.0, 0.0, TAU, 40, Color(0.72, 0.91, 0.48, 0.68), 2.4, true)
		else:
			draw_arc(Vector2.ZERO, shadow_radius + 2.0, 0.0, TAU, 40, Color(1.0, 0.84, 0.3, 0.9), 3.5, true)
		if _reaction_t > 0.0:
			var pulse: float = 1.0 - _reaction_t / 0.65
			draw_arc(Vector2.ZERO, 44.0 + pulse * 12.0, 0.0, TAU, 40,
				Color(1.0, 0.86, 0.42, (1.0 - pulse) * 0.85), 3.0, true)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		if tex == null:
			draw_circle(Vector2(0, -40), 24.0, Color(0.9, 0.8, 0.4))
			return
		if sheet != null:
			_draw_sheet_frame()
			return
		var facing_back: bool = _walk_dir.y < -0.12
		var rest_tex: Texture2D = back_tex if facing_back and back_tex != null else tex
		var display_tex: Texture2D = rest_tex
		# De temps en temps, le héros adopte brièvement une pose de repos alternative.
		# Le choix est fait dans _process (et non dans _draw) pour éviter tout scintillement
		# ou changement de pose provoqué par la fréquence de rafraîchissement.
		if not walking and _idle_variant != null:
			display_tex = _idle_variant
		# Foulée en deux temps : appui sur la pose de marche, puis retour au repos.
		var walk_pool: Array[Texture2D] = back_walk_poses if facing_back else walk_poses
		if (walking or _settle_t > 0.0) and not walk_pool.is_empty():
			var gait_step: int = int(_gait_t / (0.09 if running else 0.12))
			if gait_step % 2 == 0:
				display_tex = walk_pool[(gait_step >> 1) % walk_pool.size()]
		var h: float = sprite_height
		var sc: float = h / float(display_tex.get_height())
		var w: float = float(display_tex.get_width()) * sc
		var breathe: float = sin(_t * 2.2) * 1.5
		var stride_period: float = 0.18 if running else 0.24
		var stride: float = sin(_gait_t * TAU / stride_period) if walking or _settle_t > 0.0 else 0.0
		var bob: float = absf(stride) * (4.5 if running else 3.0) * _motion_blend
		var lean: float = _walk_dir.x * (3.0 if running else 2.0) * _motion_blend
		var reaction_bob: float = sin((1.0 - _reaction_t / 0.65) * PI) * 8.0 if _reaction_t > 0.0 else 0.0
		var y: float = -h + 6.0 - hop - breathe - bob - reaction_bob
		var x: float = lean + (stride * 1.2 if walking else 0.0)
		var turn_squash: float = 1.0
		if _turn_t > 0.0:
			turn_squash = 1.0 - 0.16 * sin((1.0 - _turn_t / 0.18) * PI)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2((-1.0 if _flip else 1.0) * turn_squash, 1.0))
		# Liseré sombre discret pour détacher le héros des feuillages clairs.
		# Respiration très légère au repos : elle anime la silhouette sans déformer le sprite.
		var idle_breath: float = sin(_t * 1.9) * 0.012 if not walking else 0.0
		var rect := Rect2(Vector2(x - w * (1.0 + idle_breath) * 0.5, y - idle_breath * h * 0.5),
			Vector2(w * (1.0 + idle_breath), (h + breathe) * (1.0 - idle_breath)))
		for o: Vector2 in [Vector2(-1.5, 0), Vector2(1.5, 0), Vector2(0, -1.5), Vector2(0, 1.5)]:
			draw_texture_rect(display_tex, Rect2(rect.position + o, rect.size), false, Color(0.05, 0.07, 0.10, 0.42))
		draw_texture_rect(display_tex, rect, false)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


## Porte vers une carte voisine : chevrons animés vers le bord de l'île et
## panonceau « ➜ Carte · niv N » (cadenas si la route est gardée).
class GateNode extends Node2D:
	var info: Dictionary = {}
	var vec: Vector2 = Vector2(64, 32)
	var _t: float = 0.0

	func _ready() -> void:
		set_process(true)

	func _process(delta: float) -> void:
		_t += delta
		if _on_screen():
			queue_redraw()

	## V118 : on ne redessine (animation) que si le nœud est à l'écran — sur les grandes cartes,
	## des dizaines de lieux / monstres / trouvailles se redessinaient à chaque image même hors champ.
	func _on_screen() -> bool:
		var p: Vector2 = get_global_transform_with_canvas().origin
		var vs: Vector2 = get_viewport_rect().size
		return p.x > -260.0 and p.y > -260.0 and p.x < vs.x + 260.0 and p.y < vs.y + 260.0

	func _draw() -> void:
		var open: bool = bool(info.get("open", false))
		var col: Color = Color(0.55, 1.0, 0.55) if open else Color(1.0, 0.45, 0.40)
		var pulse: float = 0.5 + 0.5 * sin(_t * 2.6)
		# Anneau au sol
		draw_set_transform(Vector2(0, 2), 0.0, Vector2(1.0, 0.5))
		draw_circle(Vector2.ZERO, 40.0, Color(col.r, col.g, col.b, 0.12 + 0.08 * pulse))
		draw_arc(Vector2.ZERO, 38.0, 0.0, TAU, 40, Color(col.r, col.g, col.b, 0.8), 3.0, true)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		# Chevrons qui défilent vers la carte voisine
		var d: Vector2 = vec.normalized()
		var n := Vector2(-d.y, d.x)
		for i: int in range(3):
			var f: float = fmod(float(i) / 3.0 + _t * 0.45, 1.0)
			var q: Vector2 = vec * (0.15 + f * 0.75)
			var a: float = sin(f * PI) * (0.95 if open else 0.45)
			var cc := Color(1.0, 0.93, 0.55, a) if open else Color(0.75, 0.75, 0.78, a)
			draw_polyline(PackedVector2Array([q - d * 9.0 + n * 13.0, q + d * 7.0, q - d * 9.0 - n * 13.0]), cc, 6.0, true)
		# Panonceau
		var font: Font = ThemeDB.fallback_font
		var climb: int = int(info.get("climb", 0))
		var mark: String = "➜" if open else "🔒"
		if climb > 0:
			mark = "▲" if open else "🔒▲"
		elif climb < 0:
			mark = "▼" if open else "🔒▼"
		var txt: String = "%s %s · niv %d" % [mark, String(info.get("name", "?")), int(info.get("level", 1))]
		var tw: float = font.get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 15).x + 34.0
		var bob: float = sin(_t * 2.0) * 3.0
		var r := Rect2(Vector2(-tw * 0.5, -78.0 + bob), Vector2(tw, 28))
		draw_line(Vector2(0, -50.0 + bob), Vector2(0, -4), Color(0.45, 0.32, 0.20), 5.0)
		var sb := StyleBoxFlat.new()
		sb.bg_color = Color(0.05, 0.07, 0.12, 0.90)
		sb.border_color = col
		sb.set_border_width_all(2)
		sb.set_corner_radius_all(12)
		draw_style_box(sb, r)
		var bcol: Color = BIOME_COLOR.get(String(info.get("biome", "Forêt")), Color.WHITE)
		draw_circle(r.position + Vector2(14, 14), 6.0, bcol)
		draw_string(font, r.position + Vector2(25, 20), txt, HORIZONTAL_ALIGNMENT_LEFT, tw, 15, Color(1, 0.96, 0.85) if open else Color(0.85, 0.80, 0.78))


## Mini-carte du monde : une case losange par carte (couleur du biome, lisière en
## demi-teinte), routes entre cartes, cartes voisines encore inexplorées en « ? ».
## Toucher une carte visitée y fait voyager le héros (voyage rapide).
class MiniMap extends Control:
	var ui: Node = null
	var _t: float = 0.0
	const HW := 58.0
	const HH := 30.0

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_STOP
		tooltip_text = " "
		set_process(true)

	func _process(delta: float) -> void:
		_t += delta
		queue_redraw()


	func _raw(zone_id: String) -> Vector2:
		var g: Vector2i = ProgressionManager.adventure_zone_grid(zone_id)
		# V40 : le ciel est dessiné plus haut, les profondeurs plus bas
		return Vector2(float(g.x - g.y) * HW, float(g.x + g.y) * HH - float(ProgressionManager.adventure_zone_layer(zone_id)) * 20.0)

	func _offset() -> Vector2:
		var lo := Vector2(INF, INF)
		var hi := Vector2(-INF, -INF)
		for z: String in ProgressionManager.ADVENTURE_ZONES.keys():
			var p: Vector2 = _raw(z)
			lo = Vector2(minf(lo.x, p.x), minf(lo.y, p.y))
			hi = Vector2(maxf(hi.x, p.x), maxf(hi.y, p.y))
		return size * 0.5 - (lo + hi) * 0.5

	func _visited() -> Array:
		return ui.manager.visited_zones() if ui != null else []

	func _known(zone_id: String, visited: Array) -> bool:
		if visited.has(zone_id):
			return true
		for dir: String in ProgressionManager.ADVENTURE_DIRS.keys():
			if visited.has(ProgressionManager.adventure_neighbor(zone_id, dir)):
				return true
		return false

	func _zone_at(pos: Vector2) -> String:
		var off: Vector2 = _offset()
		for z: String in ProgressionManager.ADVENTURE_ZONES.keys():
			var c: Vector2 = _raw(z) + off
			if absf(pos.x - c.x) / HW + absf(pos.y - c.y) / HH <= 1.0:
				return z
		return ""

	func _diamond(c: Vector2, s: float) -> PackedVector2Array:
		return PackedVector2Array([c + Vector2(0, -HH * s), c + Vector2(HW * s, 0), c + Vector2(0, HH * s), c + Vector2(-HW * s, 0)])

	func _draw() -> void:
		if ui == null:
			return
		var off: Vector2 = _offset()
		var visited: Array = _visited()
		var here: String = ui.manager.zone_id()
		var zones: Array = ProgressionManager.ADVENTURE_ZONES.keys()
		# Routes entre cartes connues
		for z: String in zones:
			if not _known(z, visited):
				continue
			for dir: String in ["E", "S"]:
				var nb: String = ProgressionManager.adventure_neighbor(z, dir)
				if nb != "" and _known(nb, visited) and (visited.has(z) or visited.has(nb)):
					draw_line(_raw(z) + off, _raw(nb) + off, Color(0.86, 0.72, 0.42, 0.9), 5.0, true)
		var font: Font = ThemeDB.fallback_font
		for z2: String in zones:
			if not _known(z2, visited):
				continue
			var c: Vector2 = _raw(z2) + off
			var pts: PackedVector2Array = _diamond(c, 0.84)
			if visited.has(z2):
				var meta: Dictionary = ProgressionManager.adventure_zone_meta(z2)
				draw_colored_polygon(pts, BIOME_COLOR.get(String(meta.get("biome", "Forêt")), Color.GRAY))
				var blend: Dictionary = meta.get("blend", {})
				if not blend.is_empty():
					var idx: Dictionary = {"N": [0, 1], "E": [1, 2], "S": [2, 3], "W": [3, 0]}
					var e: Array = idx.get(String(blend.get("side", "N")), [0, 1])
					draw_colored_polygon(PackedVector2Array([c, pts[int(e[0])], pts[int(e[1])]]),
						BIOME_COLOR.get(String(blend.get("biome", "Forêt")), Color.GRAY))
				var lvl: String = str(ProgressionManager.adventure_zone_level(z2))
				var tw: float = font.get_string_size(lvl, HORIZONTAL_ALIGNMENT_LEFT, -1, 17).x
				draw_string(font, c + Vector2(-tw * 0.5, 6), lvl, HORIZONTAL_ALIGNMENT_LEFT, -1, 17, Color(0.08, 0.08, 0.10, 0.85))
			else:
				draw_colored_polygon(pts, Color(0.16, 0.19, 0.26))
				draw_string(font, c + Vector2(-5, 7), "?", HORIZONTAL_ALIGNMENT_LEFT, -1, 20, Color(0.7, 0.74, 0.82))
			var lay: int = ProgressionManager.adventure_zone_layer(z2)
			if lay != 0:
				# pied de l'étage : nuage sous le ciel, ombre d'une cavité sous les profondeurs
				if lay > 0:
					draw_circle(c + Vector2(-20, HH * 0.8), 11.0, Color(1, 1, 1, 0.75))
					draw_circle(c + Vector2(0, HH * 0.95), 14.0, Color(1, 1, 1, 0.8))
					draw_circle(c + Vector2(22, HH * 0.8), 10.0, Color(1, 1, 1, 0.75))
				else:
					draw_colored_polygon(PackedVector2Array([c + Vector2(-HW * 0.8, 0), c + Vector2(0, HH * 0.84), c + Vector2(HW * 0.8, 0), c + Vector2(0, HH * 1.5)]), Color(0.05, 0.04, 0.08, 0.55))
			var outline: Color = Color(0, 0, 0, 0.45)
			var width: float = 1.5
			if z2 == here:
				outline = Color(1.0, 0.84, 0.3, 0.7 + 0.3 * sin(_t * 3.0))
				width = 3.0
			draw_polyline(pts + PackedVector2Array([pts[0]]), outline, width, true)
		# Héros : portrait de l'explorateur au-dessus de la carte courante
		var hc: Vector2 = _raw(here) + off + Vector2(0, -HH * 1.05)
		var tex: Texture2D = ui._hero.tex if ui._hero != null else null
		draw_circle(hc + Vector2(0, 14), 9.0, Color(0, 0, 0, 0.25))
		if tex != null:
			var h: float = 40.0
			var w: float = float(tex.get_width()) * h / float(tex.get_height())
			draw_texture_rect(tex, Rect2(hc + Vector2(-w * 0.5, -h + 16.0 + sin(_t * 3.0) * 1.5), Vector2(w, h)), false)
		else:
			draw_circle(hc, 6.0, Color(1.0, 0.84, 0.3))

	func _get_tooltip(at_position: Vector2) -> String:
		var z: String = _zone_at(at_position)
		if z == "" or not _known(z, _visited()):
			return ""
		var name: String = ProgressionManager.adventure_zone_name(z)
		var lvl: int = ProgressionManager.adventure_zone_level(z)
		if not _visited().has(z):
			return "Carte inexplorée · niv %d" % lvl
		var lay_t: String = ""
		var ly: int = ProgressionManager.adventure_zone_layer(z)
		if ly != 0:
			lay_t = " · " + String(ProgressionManager.ADVENTURE_LAYER_NAME[ly])
		return "%s · %s%s · niv %d" % [name, ProgressionManager.biome_label(ProgressionManager.adventure_zone_biome(z)), lay_t, lvl]

	func _gui_input(event: InputEvent) -> void:
		var released: bool = (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed) \
			or (event is InputEventScreenTouch and not event.pressed)
		if not released:
			return
		var z: String = _zone_at(event.position)
		if z == "" or z == ui.manager.zone_id():
			return
		if _visited().has(z):
			ui._on_zone_pressed(z)
		elif _known(z, _visited()):
			ui._say("Carte inexplorée : rejoignez-la à pied par une route voisine.")



## Groupe de monstres errant : jusqu'à 3 silhouettes d'ennemis, badge de niveau et
## d'effectif. Couleur du badge selon le danger (écart avec le niveau de l'équipe) ;
## les bandes d'élite ont un halo doré.
class MobNode extends Node2D:
	var texes: Array = []
	var level: int = 1
	var count: int = 3
	var elite: bool = false
	var danger: int = 0
	var cell: Vector2i = Vector2i.ZERO
	var _flip: bool = false
	var _t: float = 0.0
	var _idle_variants: Array = []
	var _idle_choices: Array = []
	var _walk_variants: Array = []
	var _walking: bool = false
	var _gait_t: float = 0.0
	var _idle_timer: float = 4.5

	func _ready() -> void:
		_t = float(absi(int(position.x * 5 + position.y * 3))) * 0.01
		_idle_timer = randf_range(3.5, 6.0)
		for tex: Texture2D in texes:
			var idle_variants: Array[Texture2D] = []
			var walk_variants: Array[Texture2D] = []
			if tex != null and tex.resource_path != "":
				var base: String = tex.resource_path.get_basename()
				idle_variants = _load_pose_variants(base + "_idle", true)
				walk_variants = _load_pose_variants(base + "_walk", false)
			_idle_variants.append(idle_variants)
			_idle_choices.append(null)
			_walk_variants.append(walk_variants)
		set_process(true)

	func _load_pose_variants(stem: String, skip_first: bool) -> Array[Texture2D]:
		var result: Array[Texture2D] = []
		for index: int in range(1, 10):
			if skip_first and index == 1:
				continue
			var path: String = stem + ".png" if index == 1 else "%s_%d.png" % [stem, index]
			if ResourceLoader.exists(path):
				var pose_tex: Texture2D = load(path) as Texture2D
				if pose_tex != null:
					result.append(pose_tex)
		return result

	func begin_walk() -> void:
		_walking = true
		_gait_t = 0.0
		queue_redraw()

	func end_walk() -> void:
		_walking = false
		_gait_t = 0.0
		queue_redraw()

	func _process(delta: float) -> void:
		_t += delta
		if _walking:
			_gait_t += delta
		_idle_timer -= delta
		if _idle_timer <= 0.0:
			var candidates: Array[int] = []
			for i: int in range(_idle_variants.size()):
				var available: Array = _idle_variants[i]
				if not available.is_empty():
					candidates.append(i)
			if not candidates.is_empty():
				var chosen: int = candidates[randi() % candidates.size()]
				var variants: Array = _idle_variants[chosen]
				if _idle_choices[chosen] == null:
					_idle_choices[chosen] = variants[randi() % variants.size()]
				else:
					_idle_choices[chosen] = null
			_idle_timer = randf_range(3.5, 6.0)
		if _on_screen():
			queue_redraw()

	## V118 : on ne redessine (animation) que si le nœud est à l'écran — sur les grandes cartes,
	## des dizaines de lieux / monstres / trouvailles se redessinaient à chaque image même hors champ.
	func _on_screen() -> bool:
		var p: Vector2 = get_global_transform_with_canvas().origin
		var vs: Vector2 = get_viewport_rect().size
		return p.x > -260.0 and p.y > -260.0 and p.x < vs.x + 260.0 and p.y < vs.y + 260.0

	func face(dx: float) -> void:
		if absf(dx) > 1.0:
			_flip = dx < 0.0

	func _draw() -> void:
		var col: Color = Color(1.0, 0.82, 0.30) if elite else Color(1.0, 0.42, 0.36)
		var pulse: float = 0.5 + 0.5 * sin(_t * 2.6)
		draw_set_transform(Vector2(0, 4), 0.0, Vector2(1.0, 0.45))
		draw_circle(Vector2.ZERO, 44.0, Color(0, 0, 0, 0.25))
		draw_arc(Vector2.ZERO, 44.0 + pulse * 3.0, 0.0, TAU, 40, Color(col.r, col.g, col.b, 0.55 + 0.3 * pulse), 3.0 if not elite else 5.0, true)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		var offs: Array = [Vector2(0, 0), Vector2(-26, -8), Vector2(24, -10)]
		var n: int = texes.size()
		for i: int in range(n - 1, -1, -1):
			var tex: Texture2D = texes[i]
			if tex == null:
				continue
			var phase: float = _t * (2.0 if i == 0 else 1.7) + float(i) * 1.9
			var idle_tex: Texture2D = _idle_choices[i] if i < _idle_choices.size() and _idle_choices[i] is Texture2D else null
			var display_tex: Texture2D = idle_tex if idle_tex != null else tex
			# Les poses de marche dédiées sont utilisées uniquement pendant le déplacement.
			# Sans fichier _walk, le sprite de base reste affiché : repli sans rupture.
			if _walking and i < _walk_variants.size():
				var walk_pool: Array = _walk_variants[i]
				if not walk_pool.is_empty():
					var gait_step: int = int(_gait_t / 0.12)
					display_tex = walk_pool[(gait_step >> 1) % walk_pool.size()]
			var breathe: float = 1.0 + sin(phase) * (0.018 if i == 0 else 0.026)
			var h: float = (84.0 if i == 0 else 66.0) * (1.12 if elite else 1.0) * breathe
			var sc: float = h / float(display_tex.get_height())
			var w: float = float(display_tex.get_width()) * sc
			var bob: float = sin(phase) * (2.2 if i == 0 else 2.8)
			var o: Vector2 = offs[i]
			# Ombre de contact individuelle : elle ancre chaque silhouette au sol.
			draw_set_transform(o + Vector2(0, 2), 0.0, Vector2(1.0, 0.34))
			draw_circle(Vector2.ZERO, 19.0 if i == 0 else 15.0, Color(0.02, 0.04, 0.05, 0.30 if i == 0 else 0.22))
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			if _flip:
				draw_set_transform(Vector2(-o.x, o.y), 0.0, Vector2(-1.0, 1.0))
				draw_texture_rect(display_tex, Rect2(Vector2(-w * 0.5, -h + 4.0 - bob), Vector2(w, h)), false, Color(1, 1, 1) if i == 0 else Color(0.85, 0.85, 0.9))
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			else:
				draw_texture_rect(display_tex, Rect2(o + Vector2(-w * 0.5, -h + 4.0 - bob), Vector2(w, h)), false, Color(1, 1, 1) if i == 0 else Color(0.85, 0.85, 0.9))
		# Badge : niveau + effectif
		var bcol: Color = Color(0.45, 0.88, 0.50) if danger <= 1 else (Color(1.0, 0.72, 0.30) if danger <= 4 else Color(1.0, 0.40, 0.36))
		var font: Font = ThemeDB.fallback_font
		var txt: String = "%sniv %d · ×%d" % ["★ " if elite else "", level, count]
		var tw: float = font.get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 16).x + 18.0
		var r := Rect2(Vector2(-tw * 0.5, -(94.0 if elite else 86.0) - 30.0), Vector2(tw, 26))
		var sb := StyleBoxFlat.new()
		sb.bg_color = Color(0.05, 0.07, 0.12, 0.90)
		sb.border_color = bcol
		sb.set_border_width_all(2)
		sb.set_corner_radius_all(11)
		draw_style_box(sb, r)
		draw_string(font, r.position + Vector2(9, 19), txt, HORIZONTAL_ALIGNMENT_LEFT, tw, 16, bcol.lightened(0.35))
