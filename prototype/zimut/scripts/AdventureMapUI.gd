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
## La progression reste dans la sauvegarde commune aux trois modes.

const U = preload("res://scripts/UiKit.gd")

const TILE_W := 128.0
const TILE_H := 64.0
const SIDE_W := 520.0
const STEP_TIME := 0.15
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
	"camp": "☀  SE REPOSER", "reveal": "👁  OBSERVER L'HORIZON", "exit": "➜  PRENDRE LE SENTIER",
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
var _board: AdventureBoard
var _entities: Node2D
var _hero: HeroView
var _cell_nodes: Dictionary = {}   # Vector2i -> Array[Node2D] (décors / lieux de la case)
var _toast_tw: Tween = null
var _fade: ColorRect
var _toast: Label
var _side_box: VBoxContainer
var _modal_root: Control = null
var _walking: bool = false
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


func _ready() -> void:
	layer = 10
	_rng.randomize()
	_save = GameManager.active_save
	_slot = GameManager.active_slot
	if _save.is_empty() or _slot < 0:
		get_tree().change_scene_to_file("res://scenes/SaveSlots.tscn")
		return
	manager = Node.new()
	manager.set_script(load("res://scripts/AdventureManager.gd"))
	add_child(manager)
	manager.load_state(_save, _slot)
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

	# Voile de transition entre deux cartes (nuages)
	_fade = ColorRect.new()
	_fade.color = Color(0.86, 0.91, 0.95, 0.0)
	_fade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fade.z_index = 20  # au-dessus des panonceaux (z_index des nœuds du monde)
	_map_view.add_child(_fade)

	# Bandeau d'annonce (fondu)
	_toast = U.lbl("", 26, Color(1.0, 0.92, 0.6), true)
	_toast.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_toast.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	_toast.offset_top = 22.0
	_toast.offset_bottom = 70.0
	_toast.modulate.a = 0.0
	_toast.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_toast.z_index = 21
	_map_view.add_child(_toast)
	_build_hud()

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
	plate.z_index = 5
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
	_action_btn.z_index = 6
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
	_joystick.z_index = 6
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
	help.z_index = 5
	help.add_theme_stylebox_override("panel", U.box(Color(0.05, 0.07, 0.12, 0.80), Color(0.30, 0.36, 0.50), 12, 1, 10))
	var hl: Label = U.lbl("Touchez une case pour y marcher (touchez ailleurs pour changer de cap).\nTouchez un groupe de monstres pour le combattre. Joystick : marche continue.", 16, Color(0.92, 0.94, 0.98))
	hl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	help.add_child(hl)
	_map_view.add_child(help)
	_help_panel = help
	help.visible = manager.moves() < HELP_STEPS


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
		return
	var kind: String = String(poi.get("kind", ""))
	if manager.poi_done(pos) and kind != "camp":
		return
	var act: String = String(POI_ACTION.get(kind, "INTERAGIR"))
	if kind == "combat":
		act += "  (niv %d)" % manager.challenge_level(poi)
	_action_btn.text = "▶  %s" % act
	_action_btn.show()


func _on_action_pressed() -> void:
	if _walking or _modal_root != null:
		return
	var pos: Vector2i = manager.hero_pos()
	if not manager.gate_at(pos).is_empty() and manager.poi_at(pos).is_empty():
		_cross_gate(pos)
	else:
		_interact()


func _process(_delta: float) -> void:
	if _joystick == null or not _joystick.pushed() or _walking or _modal_root != null:
		return
	_joy_step(_joystick.vector)


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
	_backdrop = BackdropFx.new()
	_backdrop.z_index = 0
	_world.add_child(_backdrop)
	_backdrop.configure(biome)
	var zs: Vector2i = manager.zone_size()
	_backdrop.position = Vector2(float(zs.x - zs.y) * TILE_W * 0.25, float(zs.x + zs.y) * TILE_H * 0.25 - 60.0)
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
			node.gem = Stones.info(gb).get("color", Color.WHITE)
			node.gem_taken = Stones.has(manager.save, gb)
			var btex: Texture2D = Nations.boss_texture(gb)
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


func _add_decor(p: Vector2i, kind: String, biome: String, pal: Dictionary, sc: float) -> void:
	var d := DecorNode.new()
	d.kind = kind
	d.biome = biome
	d.pal = pal
	d.seed_value = p.x * 31 + p.y * 57 + 3
	d.scale = Vector2(sc, sc)
	d.position = cell_center(p) + Vector2(0, 6)
	_entities.add_child(d)
	_cell_nodes[p] = _cell_nodes.get(p, []) + [d]


## Met à jour la visibilité (brouillard) et l'état des lieux.
func _refresh_world() -> void:
	for p: Vector2i in _cell_nodes.keys():
		var seen: bool = manager.cell_discovered(p)
		for n: Node2D in _cell_nodes[p]:
			n.visible = seen
			if n is FindNode:
				n.visible = seen and not manager.find_taken(p)
			if n is PoiNode:
				var pn: PoiNode = n
				pn.done = manager.poi_done(p) and pn.kind != "camp"
				var hp: Vector2i = manager.hero_pos()
				pn.show_label = (absi(p.x - hp.x) + absi(p.y - hp.y) <= 2 or p == _board.hover) and not pn.done
				pn.z_index = 3 if pn.show_label else 0  # étiquette lisible au-dessus des voisins
				pn.queue_redraw()
			elif n is GateNode:
				n.z_index = 2
	var team_lvl: int = _team_level()
	for id: int in _mob_nodes.keys():
		var mn: MobNode = _mob_nodes[id]
		mn.visible = manager.cell_discovered(mn.cell)
		mn.danger = mn.level - team_lvl
	_board.queue_redraw()


func _fit_world() -> void:
	if _map_view == null or _board == null:
		return
	var size: Vector2i = manager.zone_size()
	var w: float = float(size.x + size.y) * TILE_W * 0.5 + 160.0
	var h: float = float(size.x + size.y) * TILE_H * 0.5 + 330.0
	var vs: Vector2 = _map_view.size
	if vs.x < 10.0:
		return
	var sc: float = clampf(minf(vs.x / w, vs.y / h), 0.55, 1.6)
	_world.scale = Vector2(sc, sc)
	# centre de la grille (losange) + marge pour les décors hauts et la falaise
	var center := Vector2(float(size.x - size.y) * TILE_W * 0.25, float(size.x + size.y - 2) * TILE_H * 0.25 + 40.0)
	_world.position = vs * 0.5 - center * sc


# ══════════════════════════════════════════════════════════════════════
#  Projection
# ══════════════════════════════════════════════════════════════════════

func cell_center(p: Vector2i) -> Vector2:
	return Vector2(float(p.x - p.y) * TILE_W * 0.5, float(p.x + p.y) * TILE_H * 0.5)


func screen_to_cell(local: Vector2) -> Vector2i:
	var gx: float = (local.y / (TILE_H * 0.5) + local.x / (TILE_W * 0.5)) * 0.5
	var gy: float = (local.y / (TILE_H * 0.5) - local.x / (TILE_W * 0.5)) * 0.5
	return Vector2i(roundi(gx), roundi(gy))


func _inside(p: Vector2i) -> bool:
	var s: Vector2i = manager.zone_size()
	return p.x >= 0 and p.y >= 0 and p.x < s.x and p.y < s.y


# ══════════════════════════════════════════════════════════════════════
#  Entrées
# ══════════════════════════════════════════════════════════════════════

func _on_map_input(event: InputEvent) -> void:
	if _modal_root != null:
		return
	if _walking:
		# Pendant la marche, un nouvel appui change de destination (après le pas en cours).
		var released: bool = (event is InputEventScreenTouch and not event.pressed) \
			or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and event.device != InputEvent.DEVICE_ID_EMULATION)
		if released:
			var cr: Vector2i = screen_to_cell((event.position - _world.position) / _world.scale.x)
			if _inside(cr):
				_redirect = cr
		return
	if event is InputEventMouseMotion:
		var c: Vector2i = screen_to_cell((event.position - _world.position) / _world.scale.x)
		_board.hover = c if _inside(c) else Vector2i(-1, -1)
		if _pending.x < 0:
			_board.preview = manager.path_to(c) if _inside(c) and c != manager.hero_pos() else []
		_refresh_world()
	elif event is InputEventScreenTouch and not event.pressed:
		# Tactile : un premier appui montre le trajet, le second confirme.
		var ct: Vector2i = screen_to_cell((event.position - _world.position) / _world.scale.x)
		if _inside(ct):
			_on_cell_tapped(ct, true)
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		# Les clics émulés par le tactile sont déjà traités par l'événement tactile.
		if event.device == InputEvent.DEVICE_ID_EMULATION:
			return
		var c2: Vector2i = screen_to_cell((event.position - _world.position) / _world.scale.x)
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
	var step_time: float = STEP_TIME * clampf(8.0 / float(maxi(1, path.size())), 0.5, 1.0)
	for step: Vector2i in path:
		if _redirect.x >= 0:
			break
		if not manager.mob_at(step).is_empty():
			_say("Un groupe de monstres vous barre la route.")
			break
		var from: Vector2 = _hero.position
		var to: Vector2 = cell_center(step)
		_hero.face(to.x - from.x)
		var fresh: Array = manager.move_hero(step)
		if _board.preview.size() > 0:
			_board.preview.remove_at(0)
		var tw := create_tween()
		tw.tween_method(func(f: float) -> void:
			_hero.position = from.lerp(to, f)
			_hero.hop = sin(f * PI) * 10.0, 0.0, 1.0, step_time)
		_after_step()
		await tw.finished
		if not fresh.is_empty():
			_refresh_world()
		var got: Dictionary = manager.collect_find(step)
		if not got.is_empty():
			_toast_show("✦ " + String(got["text"]), 24)
			_log(String(got["text"]) + ".")
			_refresh_world()
			_refresh_side()
			if _check_mastery():
				_walking = false
				_board.preview = []
				return
		var poi: Dictionary = manager.poi_at(step)
		if not poi.is_empty() or not manager.gate_at(step).is_empty():
			break
		var ev: Dictionary = manager.roll_event(_rng)
		if not ev.is_empty():
			_show_event(ev)
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


## Après chaque pas : les groupes flânent, un groupe réapparaît si le délai est écoulé.
func _after_step() -> void:
	var moved: Array = manager.wander_mobs(_target_mob)
	var added: Array = manager.ensure_mobs()
	if not moved.is_empty() or not added.is_empty():
		_sync_mobs(true)


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
	var tw := create_tween()
	tw.tween_property(_hero, "position", _hero.position + out_vec * 1.3, 0.38)
	tw.parallel().tween_property(_fade, "color:a", 1.0, 0.38)
	await tw.finished
	if not manager.cross_gate(pos):
		_fade.color.a = 0.0
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
	tw2.tween_property(_fade, "color:a", 0.0, 0.42)
	tw2.parallel().tween_property(_hero, "position", target, 0.55).set_delay(0.08)
	await tw2.finished
	_walking = false
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
	var back := U.btn("← PARTIE", Color(0.55, 0.62, 0.80), 20, Vector2(150, 56))
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
	var hint := U.lbl("Marchez jusqu'aux flèches au bord de l'île pour passer à la carte voisine. Touchez une carte déjà visitée pour y voyager.", 19, DIM)
	hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_side_box.add_child(hint)
	var foot := U.lbl("XP, objets, or et ressources : sauvegarde commune aux trois modes.", 19, DIM)
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
		if kind == "combat":
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
					"Du haut du belvédère, vous repérez de nouvelles villes. Elles deviennent attaquables en CONQUÊTE.", lines2)
		"exit":
			_show_exit(String(cmd.get("key", "")))
		_:
			_say("Rien de particulier ici… pour l'instant.")
	_refresh_world()
	_refresh_side()


func _confirm_combat(poi: Dictionary) -> void:
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
	var level: int = manager.challenge_level(poi)
	manager.state["pending_level"] = level
	manager.persist()
	GameManager.fight_biome = manager.zone_biome()
	get_tree().change_scene_to_file("res://scenes/TeamSelection.tscn")


func _show_exit(key: String) -> void:
	var revealed: Array = manager.take_exit(key)
	var box: VBoxContainer = _modal("➜  Sentier découvert !", POI_COLOR["exit"])
	var targets: Array = []
	for r: String in revealed:
		if String(r).begins_with("zone:"):
			targets.append(String(r).substr(5))
	var msg: String = "Le sentier s'ouvre vers de nouvelles terres." if not targets.is_empty() else "Ce sentier vous est familier. Où voulez-vous aller ?"
	box.add_child(U.lbl(msg, 18, U.C_TXT))
	var choices: Array = targets if not targets.is_empty() else manager.available_zones()
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
				create_tween().tween_property(mn, "position", to, STEP_TIME * 1.6).set_trans(Tween.TRANS_SINE)
			else:
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
	dim.z_index = 30
	add_child(dim)
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
	if _toast_tw != null and _toast_tw.is_valid():
		_toast_tw.kill()
	_toast_tw = create_tween()
	_toast_tw.tween_interval(1.6)
	_toast_tw.tween_property(_toast, "modulate:a", 0.0, 0.6)


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

	func _ready() -> void:
		set_process(true)

	func _process(delta: float) -> void:
		_t += delta
		queue_redraw()

	func _diamond(c: Vector2, s: float = 1.0) -> PackedVector2Array:
		return PackedVector2Array([c + Vector2(0, -32 * s), c + Vector2(64 * s, 0), c + Vector2(0, 32 * s), c + Vector2(-64 * s, 0)])

	func _draw() -> void:
		var mgr: Node = ui.manager
		var size: Vector2i = mgr.zone_size()
		var biome: String = mgr.zone_biome()
		var p: Dictionary = BattleScenery.pal(biome)
		var terrain: Dictionary = AdventureTerrain.zone_terrain(mgr.zone_id())
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
				if not mgr.cell_discovered(cell):
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
				if mgr.cell_discovered(fc):
					continue
				var c4: Vector2 = ui.cell_center(fc)
				draw_colored_polygon(_diamond(c4, 1.02), Color(0.66, 0.74, 0.82, 0.96))
				var r2 := RandomNumberGenerator.new()
				r2.seed = x2 * 7 + y2 * 131
				for k: int in range(4):
					var off := Vector2(r2.randf_range(-36, 36), r2.randf_range(-12, 8) - 8.0 + sin(_t * 0.8 + float(k + x2)) * 2.0)
					draw_set_transform(c4 + off, 0.0, Vector2(1.0, 0.55))
					draw_circle(Vector2.ZERO, r2.randf_range(20, 30), Color(0.90, 0.94, 0.98, 0.85))
					draw_circle(Vector2(-5, -6), r2.randf_range(10, 16), Color(1, 1, 1, 0.6))
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


## Décor (arbre, rocher, fleurs…) dessiné par BattleScenery.
class DecorNode extends Node2D:
	var kind: String = "tree"
	var biome: String = "Forêt"
	var pal: Dictionary = {}
	var seed_value: int = 0

	func _draw() -> void:
		var rng := RandomNumberGenerator.new()
		rng.seed = seed_value
		BattleScenery.draw_prop(self, kind, pal, biome, rng, 0.0)


## Lieu remarquable : objet au sol, halo, icône flottante, nom, ennemi pour les camps.
class PoiNode extends Node2D:
	var kind: String = "combat"
	var title: String = ""
	var level: int = 10
	var biome: String = "Forêt"
	var pal: Dictionary = {}
	var icon: Texture2D = null
	var prop: String = ""
	var enemy_tex: Texture2D = null
	var done: bool = false
	var show_label: bool = false
	var gem: Color = Color(0, 0, 0, 0)
	var gem_taken: bool = false
	var _t: float = 0.0

	func _ready() -> void:
		_t = float(absi(int(position.x * 3 + position.y))) * 0.01
		set_process(true)

	func _process(delta: float) -> void:
		_t += delta
		queue_redraw()

	func _draw() -> void:
		var col: Color = POI_COLOR.get(kind, Color.WHITE)
		var pulse: float = 0.5 + 0.5 * sin(_t * 2.4)
		if not done:
			draw_set_transform(Vector2(0, 4), 0.0, Vector2(1.0, 0.5))
			draw_circle(Vector2.ZERO, 46.0 + pulse * 4.0, Color(col.r, col.g, col.b, 0.16))
			draw_arc(Vector2.ZERO, 44.0 + pulse * 4.0, 0.0, TAU, 40, Color(col.r, col.g, col.b, 0.75), 3.0, true)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		var mod: Color = Color(1, 1, 1) if not done else Color(0.62, 0.62, 0.66)
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
		var ic := Vector2(0, -100 + bob)
		draw_circle(ic + Vector2(0, 3), 24.0, Color(0, 0, 0, 0.35))
		draw_circle(ic, 24.0, Color(0.06, 0.08, 0.14, 0.95))
		draw_arc(ic, 23.0, 0.0, TAU, 36, col if not done else Color(0.5, 0.5, 0.55), 3.0, true)
		if icon != null:
			draw_texture_rect(icon, Rect2(ic - Vector2(19, 19), Vector2(38, 38)), false, mod)
		if done:
			draw_circle(ic + Vector2(19, -18), 11.0, Color(0.25, 0.75, 0.35))
			draw_string(ThemeDB.fallback_font, ic + Vector2(12, -12), "✓", HORIZONTAL_ALIGNMENT_CENTER, 14.0, 16, Color.WHITE)
		# Nom (près du héros ou au survol, pour ne pas surcharger la carte)
		if show_label:
			var font: Font = ThemeDB.fallback_font
			var txt: String = title
			var tw: float = font.get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT, -1, 15).x + 18.0
			var r := Rect2(Vector2(-tw * 0.5, 22), Vector2(tw, 24))
			var sb := StyleBoxFlat.new()
			sb.bg_color = Color(0.05, 0.07, 0.12, 0.85)
			sb.border_color = col
			sb.set_border_width_all(1)
			sb.set_corner_radius_all(10)
			draw_style_box(sb, r)
			draw_string(font, r.position + Vector2(9, 18), txt, HORIZONTAL_ALIGNMENT_LEFT, tw, 15, Color(1, 0.96, 0.85))


## Trouvaille cachée : petit scintillement au sol (herbe, bourse ou relique).
class FindNode extends Node2D:
	var kind: String = "herb"
	var _t: float = 0.0

	func _ready() -> void:
		_t = float(absi(int(position.x * 7 + position.y))) * 0.013
		set_process(true)

	func _process(delta: float) -> void:
		_t += delta
		queue_redraw()

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
	var tex: Texture2D = null
	var hop: float = 0.0
	var _flip: bool = false
	var _t: float = 0.0

	func _ready() -> void:
		set_process(true)

	func _process(delta: float) -> void:
		_t += delta
		queue_redraw()

	func face(dx: float) -> void:
		if absf(dx) > 1.0:
			_flip = dx < 0.0

	func _draw() -> void:
		draw_set_transform(Vector2(0, 4), 0.0, Vector2(1.0, 0.45))
		draw_circle(Vector2.ZERO, 34.0, Color(0, 0, 0, 0.30))
		draw_arc(Vector2.ZERO, 36.0, 0.0, TAU, 40, Color(1.0, 0.84, 0.3, 0.9), 3.5, true)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		if tex == null:
			draw_circle(Vector2(0, -40), 24.0, Color(0.9, 0.8, 0.4))
			return
		var h: float = 104.0
		var sc: float = h / float(tex.get_height())
		var w: float = float(tex.get_width()) * sc
		var breathe: float = sin(_t * 2.2) * 1.5
		var y: float = -h + 6.0 - hop - breathe
		if _flip:
			draw_set_transform(Vector2.ZERO, 0.0, Vector2(-1.0, 1.0))
		draw_texture_rect(tex, Rect2(Vector2(-w * 0.5, y), Vector2(w, h + breathe)), false)
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
		queue_redraw()

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
		var txt: String = "%s %s · niv %d" % ["➜" if open else "🔒", String(info.get("name", "?")), int(info.get("level", 1))]
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
		return Vector2(float(g.x - g.y) * HW, float(g.x + g.y) * HH)

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
		return "%s · %s · niv %d" % [name, ProgressionManager.biome_label(ProgressionManager.adventure_zone_biome(z)), lvl]

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

	func _ready() -> void:
		_t = float(absi(int(position.x * 5 + position.y * 3))) * 0.01
		set_process(true)

	func _process(delta: float) -> void:
		_t += delta
		queue_redraw()

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
			var h: float = (84.0 if i == 0 else 66.0) * (1.12 if elite else 1.0)
			var sc: float = h / float(tex.get_height())
			var w: float = float(tex.get_width()) * sc
			var bob: float = sin(_t * 2.0 + float(i)) * 1.5
			var o: Vector2 = offs[i]
			if _flip:
				draw_set_transform(Vector2(-o.x, o.y), 0.0, Vector2(-1.0, 1.0))
				draw_texture_rect(tex, Rect2(Vector2(-w * 0.5, -h + 4.0 - bob), Vector2(w, h)), false, Color(1, 1, 1) if i == 0 else Color(0.85, 0.85, 0.9))
				draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			else:
				draw_texture_rect(tex, Rect2(o + Vector2(-w * 0.5, -h + 4.0 - bob), Vector2(w, h)), false, Color(1, 1, 1) if i == 0 else Color(0.85, 0.85, 0.9))
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
