extends CanvasLayer
## Mode Aventure — carte d'exploration isométrique.
##
## Rendu uniquement : la logique (état, brouillard, récompenses, ponts
## inter-modes) vit dans AdventureManager.gd ; le catalogue officiel
## (zones, POI, énigmes) vient de ProgressionManager. Les sprites vivent
## dans assets/adventure/ (tiles par biome, poi, hero) — remplaçables
## sans toucher au code.
##
## La progression reste dans la sauvegarde commune aux trois modes.

const PANEL := Color(0.10, 0.17, 0.20, 0.96)
const PANEL_LIGHT := Color(0.18, 0.29, 0.29, 0.96)
const GOLD := Color(0.94, 0.76, 0.34)
const TEXT := Color(0.95, 0.94, 0.83)

## Tuiles par biome (2 variantes par biome, en damier) + brouillard.
## Les chemins pointent dans assets/adventure/ : les artistes peuvent
## remplacer les SVG sans modifier ce script.
## Tuiles et décors : RÉUTILISATION des assets existants du jeu.
## Sol : tuiles isométriques 128x64 du mode Tactique (6 variantes par biome,
## damier déterministe par position). Décors : objets du biome.
## Fond de carte : panoramiques des biomes de la carte de Conquête.
## Le brouillard est un voile semi-transparent par-dessus la vraie tuile.
const ZONE_TILES := {
	"Forêt": ["res://assets/sprites/tiles/forest_ground_01.svg",
		"res://assets/sprites/tiles/forest_ground_02.svg",
		"res://assets/sprites/tiles/forest_ground_03.svg",
		"res://assets/sprites/tiles/forest_ground_04.svg",
		"res://assets/sprites/tiles/forest_ground_05.svg",
		"res://assets/sprites/tiles/forest_ground_06.svg"],
	"Montagne": ["res://assets/sprites/tiles/mountain_ground_01.svg",
		"res://assets/sprites/tiles/mountain_ground_02.svg",
		"res://assets/sprites/tiles/mountain_ground_03.svg",
		"res://assets/sprites/tiles/mountain_ground_04.svg",
		"res://assets/sprites/tiles/mountain_ground_05.svg",
		"res://assets/sprites/tiles/mountain_ground_06.svg"],
	"Désert": ["res://assets/sprites/tiles/desert_ground_01.svg",
		"res://assets/sprites/tiles/desert_ground_02.svg",
		"res://assets/sprites/tiles/desert_ground_03.svg",
		"res://assets/sprites/tiles/desert_ground_04.svg",
		"res://assets/sprites/tiles/desert_ground_05.svg",
		"res://assets/sprites/tiles/desert_ground_06.svg"],
	"Donjon": ["res://assets/sprites/tiles/mountain_ground_01.svg",
		"res://assets/sprites/tiles/mountain_ground_02.svg",
		"res://assets/sprites/tiles/mountain_ground_03.svg",
		"res://assets/sprites/tiles/mountain_ground_04.svg",
		"res://assets/sprites/tiles/mountain_ground_05.svg",
		"res://assets/sprites/tiles/mountain_ground_06.svg"],
}
const ZONE_BACKDROP := {
	"Forêt": "res://assets/ui/conquest/biome_forest.svg",
	"Montagne": "res://assets/ui/conquest/biome_mountain.svg",
	"Désert": "res://assets/ui/conquest/biome_desert.svg",
	"Donjon": "res://assets/ui/conquest/biome_dungeon.svg",
}
const ZONE_PROPS := {
	"Forêt": ["res://assets/sprites/objects/forest_tree.svg",
		"res://assets/sprites/objects/forest_boulder.svg",
		"res://assets/sprites/objects/forest_fern.svg",
		"res://assets/sprites/objects/forest_mushrooms.svg",
		"res://assets/sprites/objects/forest_stump.svg"],
	"Montagne": ["res://assets/sprites/objects/forest_boulder.svg"],
	"Désert": ["res://assets/sprites/objects/forest_boulder.svg"],
	"Donjon": ["res://assets/sprites/objects/forest_boulder.svg"],
}
const FOG_COLOR := Color(0.07, 0.11, 0.13, 0.82)
const POI_ICONS := {
	"combat": "res://assets/adventure/poi/combat.svg",
	"chest": "res://assets/adventure/poi/chest.svg",
	"puzzle": "res://assets/adventure/poi/puzzle.svg",
	"camp": "res://assets/adventure/poi/camp.svg",
	"reveal": "res://assets/adventure/poi/reveal.svg",
	"exit": "res://assets/adventure/poi/exit.svg",
}
## Héros : sprite officiel du Mage (assets/sprites/players) — même
## personnage que sur le plateau de combat tactique.
const HERO_SPRITE := "res://assets/sprites/players/mage.svg"

## Géométrie isométrique (losanges façon Waven/Dofus).
const TILE_W := 128
const TILE_H := 64
const MAP_MARGIN := 40

var manager: Node = null

var _save: Dictionary = {}
var _slot: int = -1
var _message: Label
var _cells: Dictionary = {}
var _poi_icons: Dictionary = {}
var _hero_sprite: Sprite2D
var _map_root: Node2D
var _zone_label: Label
var _moves_label: Label
var _zone_buttons: Dictionary = {}
var _map_panel: PanelContainer

func _ready() -> void:
	Music.play("adventure")
	layer = 10
	_save = GameManager.active_save
	_slot = GameManager.active_slot
	if _save.is_empty() or _slot < 0:
		# Différé : on ne peut pas changer de scène pendant le _ready
		# (le tree est occupé à monter cette scène — sinon écran gris).
		_call_deferred_scene("res://scenes/SaveSlots.tscn")
		return
	manager = Node.new()
	manager.set_script(load("res://scripts/AdventureManager.gd"))
	add_child(manager)
	manager.load_state(_save, _slot)
	manager.message.connect(func(t: String) -> void: _message.text = t)
	manager.cities_revealed.connect(_on_cities_revealed)
	_build()

## Changement de scène sûr (jamais pendant un _ready).
func _call_deferred_scene(path: String) -> void:
	get_tree().change_scene_to_file.call_deferred(path)

# ══════════════════════════════════════════════════════════════════
#  Construction de l'interface
# ══════════════════════════════════════════════════════════════════

func _build() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.22, 0.30, 0.28)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	var root := VBoxContainer.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_theme_constant_override("separation", 10)
	root.offset_left = 24
	root.offset_right = -24
	root.offset_top = 16
	root.offset_bottom = -16
	add_child(root)

	var top := HBoxContainer.new()
	root.add_child(top)

	var title := Label.new()
	title.text = "🧭  ZIMUT — AVENTURE"
	title.add_theme_font_size_override("font_size", 28)
	title.add_theme_color_override("font_color", TEXT)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(title)

	var back := Button.new()
	back.text = "←  PARTIE"
	back.pressed.connect(_back_to_save)
	top.add_child(back)

	_zone_label = Label.new()
	_zone_label.add_theme_font_size_override("font_size", 18)
	_zone_label.add_theme_color_override("font_color", GOLD)
	root.add_child(_zone_label)

	var body := HBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_theme_constant_override("separation", 16)
	root.add_child(body)

	# ── Carte isométrique ──────────────────────────────────────────
	var map_panel := PanelContainer.new()
	map_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	map_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	map_panel.add_theme_stylebox_override("panel", _panel_style(PANEL, GOLD))
	body.add_child(map_panel)
	_map_panel = map_panel

	var map_box := VBoxContainer.new()
	map_box.add_theme_constant_override("separation", 8)
	map_panel.add_child(map_box)

	var map_title := Label.new()
	map_title.text = "EXPLORATION"
	map_title.add_theme_font_size_override("font_size", 20)
	map_title.add_theme_color_override("font_color", TEXT)
	map_box.add_child(map_title)

	var map_scroll := ScrollContainer.new()
	map_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	map_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	map_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	map_box.add_child(map_scroll)

	var map_holder := Control.new()
	map_scroll.add_child(map_holder)
	_map_root = Node2D.new()
	map_holder.add_child(_map_root)

	# ── Panneau latéral : journal + actions ───────────────────────
	var side := PanelContainer.new()
	side.custom_minimum_size.x = 430
	side.add_theme_stylebox_override("panel", _panel_style(PANEL_LIGHT, GOLD))
	body.add_child(side)

	var side_box := VBoxContainer.new()
	side_box.add_theme_constant_override("separation", 14)
	side.add_child(side_box)

	var journal_title := Label.new()
	journal_title.text = "JOURNAL D'EXPLORATION"
	journal_title.add_theme_font_size_override("font_size", 26)
	journal_title.add_theme_color_override("font_color", TEXT)
	side_box.add_child(journal_title)

	_message = Label.new()
	_message.text = "Déplacez le héros case par case. Le brouillard se lève autour de vous."
	_message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_message.custom_minimum_size.y = 150
	_message.add_theme_color_override("font_color", TEXT)
	_message.add_theme_font_size_override("font_size", 22)
	side_box.add_child(_message)

	var interact := Button.new()
	interact.text = "INTERAGIR"
	interact.custom_minimum_size.y = 62
	interact.add_theme_font_size_override("font_size", 24)
	interact.pressed.connect(_interact)
	side_box.add_child(interact)

	var zones_title := Label.new()
	zones_title.text = "ZONES DU MONDE"
	zones_title.add_theme_font_size_override("font_size", 23)
	zones_title.add_theme_color_override("font_color", GOLD)
	side_box.add_child(zones_title)

	for zone_id: String in manager.available_zones():
		var btn := Button.new()
		var meta: Dictionary = ProgressionManager.adventure_zone_meta(zone_id)
		btn.text = "%s  ·  %s" % [String(meta.get("name", zone_id)),
			ProgressionManager.biome_label(String(meta.get("biome", "Forêt")))]
		btn.custom_minimum_size.y = 54
		btn.add_theme_font_size_override("font_size", 21)
		btn.pressed.connect(_on_zone_pressed.bind(zone_id))
		side_box.add_child(btn)
		_zone_buttons[zone_id] = btn

	var help := Label.new()
	help.text = "Clic case adjacente : déplacement\nBrouillard : révélé autour du héros\n" \
		+ "Belvédère : villes pour la Conquête\nCombat : règles du mode Tactique"
	help.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	help.add_theme_color_override("font_color", TEXT)
	help.add_theme_font_size_override("font_size", 19)
	side_box.add_child(help)

	var spacer := Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	side_box.add_child(spacer)

	_moves_label = Label.new()
	_moves_label.add_theme_color_override("font_color", GOLD)
	side_box.add_child(_moves_label)

	_build_map()
	_refresh()

# ══════════════════════════════════════════════════════════════════
#  Carte isométrique
# ════════════════════════════════════════════════════════════════

func _build_map() -> void:
	for c: Node in _map_root.get_children():
		c.queue_free()
	_cells.clear()
	_poi_icons.clear()

	var size: Vector2i = manager.zone_size()
	var zone_id: String = manager.zone_id()

	# Fond de carte : panoramique du biome (assets Conquête).
	var backdrop_path := String(ZONE_BACKDROP.get(manager.zone_biome(), ""))
	if backdrop_path != "" and ResourceLoader.exists(backdrop_path):
		var backdrop := TextureRect.new()
		backdrop.texture = load(backdrop_path)
		backdrop.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		backdrop.z_index = -20
		_map_root.add_child(backdrop)

	for y: int in range(size.y):
		for x: int in range(size.x):
			var pos := Vector2i(x, y)
			var screen := _cell_center(x, y, size)
			var tex: Texture2D = _tile_texture(x, y, zone_id)
			var spr := Sprite2D.new()
			spr.texture = tex
			spr.position = screen
			_map_root.add_child(spr)
			_cells[pos] = {"sprite": spr, "texture": tex}

			# Voile de brouillard au-dessus de la vraie tuile.
			var fog := Sprite2D.new()
			fog.texture = tex
			fog.position = screen
			fog.modulate = FOG_COLOR
			fog.z_index = 5
			_map_root.add_child(fog)
			_cells[pos]["fog"] = fog

			var btn := TextureButton.new()
			btn.texture_normal = tex
			btn.texture_hover = tex
			btn.scale = Vector2(0.98, 0.98)
			btn.position = screen - Vector2(TILE_W * 0.5, TILE_H * 0.5)
			btn.pressed.connect(_on_cell_pressed.bind(pos))
			_map_root.add_child(btn)
			_cells[pos]["button"] = btn

	_refresh_props(size, zone_id)

	var hero := Sprite2D.new()
	hero.texture = load(HERO_SPRITE)
	hero.scale = Vector2(0.68, 0.68)
	hero.z_index = 20
	_map_root.add_child(hero)
	_hero_sprite = hero
	_animate_hero_idle()

## Décor : quelques objets du biome posés sur des cases vides (rendu
## déterministe — même décor à chaque visite de la zone).
func _refresh_props(size: Vector2i, zone_id: String) -> void:
	var props: Array = ZONE_PROPS.get(manager.zone_biome(), [])
	if props.is_empty():
		return
	var pois: Dictionary = ProgressionManager.adventure_zone_pois(zone_id)
	var occupied := {}
	for k: String in pois.keys():
		occupied[k] = true
	var start: Array = ProgressionManager.adventure_zone_meta(zone_id).get(
		"start", [0, 0])
	occupied["%d,%d" % [int(start[0]), int(start[1])]] = true
	for y: int in range(size.y):
		for x: int in range(size.x):
			if occupied.has("%d,%d" % [x, y]):
				continue
			var h: int = (x * 73856093) ^ (y * 19349663)
			if h % 7 != 0:
				continue
			var spr := Sprite2D.new()
			spr.texture = load(String(props[absi(h) % props.size()]))
			spr.position = _cell_center(x, y, size) - Vector2(0, 14)
			spr.z_index = 10 + y
			_map_root.add_child(spr)

## Petite respiration du héros à l'arrêt (montée/descente douce).
func _animate_hero_idle() -> void:
	if _hero_sprite == null:
		return
	var tween := create_tween().set_loops()
	var base := _hero_sprite.scale
	tween.tween_property(_hero_sprite, "scale",
		Vector2(base.x * 1.04, base.y * 0.96), 0.9)
	tween.tween_property(_hero_sprite, "scale", base, 0.9)
	_hero_sprite.set_meta("idle_tween", tween)

## Tuile de sol : variantes du biome en damier déterministe (6 variantes,
## réparties par position — visuel stable d'une visite à l'autre).
func _tile_texture(x: int, y: int, zone_id: String) -> Texture2D:
	var tiles: Array = ZONE_TILES.get(manager.zone_biome(), ZONE_TILES["Forêt"])
	var h: int = (x * 73856093) ^ (y * 19349663) ^ zone_id.hash()
	return load(String(tiles[absi(h) % tiles.size()])) as Texture2D

func _cell_center(x: int, y: int, size: Vector2i) -> Vector2:
	return Vector2(
		MAP_MARGIN + (size.x + x - y - 1) * TILE_W * 0.5,
		MAP_MARGIN + (x + y) * TILE_H * 0.5 + TILE_H)

func _refresh(animate: bool = false) -> void:
	var size: Vector2i = manager.zone_size()

	for pos: Vector2i in _cells.keys():
		var entry: Dictionary = _cells[pos]
		var fog: Sprite2D = entry.get("fog")
		if fog != null:
			# Voile : opaque au-dessus du brouillard, invisible sinon.
			var target: float = 0.0 if manager.cell_discovered(pos) else 1.0
			if animate:
				var tw := create_tween()
				tw.tween_property(fog, "modulate:a", target, 0.35)
			else:
				fog.modulate.a = target

	_refresh_pois(size)
	if _hero_sprite != null:
		var dest := _cell_center(manager.hero_pos().x,
			manager.hero_pos().y, size) - Vector2(0, 26)
		if animate:
			# Saut de case : montée puis descente (petit arc).
			var up := create_tween()
			up.tween_property(_hero_sprite, "position",
				Vector2(dest.x, dest.y - 22), 0.12)
			up.tween_property(_hero_sprite, "position", dest, 0.12)
		else:
			_hero_sprite.position = dest

	_zone_label.text = "AVENTURE  ·  %s  ·  %s" % [manager.zone_name(),
		ProgressionManager.biome_label(manager.zone_biome())]
	_moves_label.text = "Pas parcourus : %d\nSauvegarde commune aux trois modes" % manager.moves()
	for zone_id: String in _zone_buttons.keys():
		var btn: Button = _zone_buttons[zone_id]
		btn.disabled = zone_id == manager.zone_id()

func _refresh_pois(size: Vector2i) -> void:
	for c: Node in _poi_icons.values():
		if is_instance_valid(c):
			c.queue_free()
	_poi_icons.clear()
	var pois: Dictionary = ProgressionManager.adventure_zone_pois(manager.zone_id())
	for key: String in pois.keys():
		var parts := key.split(",")
		var pos := Vector2i(int(parts[0]), int(parts[1]))
		if not manager.cell_discovered(pos):
			continue
		var poi: Dictionary = pois[key]
		var kind := String(poi.get("kind", "combat"))
		var icon := Sprite2D.new()
		icon.texture = load(String(POI_ICONS.get(kind, POI_ICONS["combat"])))
		icon.scale = Vector2(0.42, 0.42)
		icon.position = _cell_center(pos.x, pos.y, size) - Vector2(0, 14)
		_map_root.add_child(icon)
		_poi_icons[pos] = icon
		if manager.poi_done(pos):
			icon.modulate = Color(1, 1, 1, 0.35)

# ══════════════════════════════════════════════════════════════════
#  Interactions
# ══════════════════════════════════════════════════════════════════

func _on_cell_pressed(pos: Vector2i) -> void:
	if pos == manager.hero_pos():
		_interact()
		return
	if not manager.cell_discovered(pos):
		_message.text = "Le brouillard est trop dense par là. Explorez d'alentour."
		return
	if not manager.can_move_to(pos):
		_message.text = "Le sentier se parcourt case par case."
		return
	manager.move_hero(pos)
	var poi: Dictionary = manager.poi_at(pos)
	if not poi.is_empty():
		_message.text = "Découverte : %s — %s" % [String(poi.get("name", "?")),
			String(poi.get("desc", ""))]
	else:
		_message.text = "Le paysage s'ouvre devant vous."
	_refresh(true)

func _interact() -> void:
	var cmd: Dictionary = manager.interact()
	match String(cmd.get("action", "nothing")):
		"puzzle":
			_show_puzzle_dialog(cmd)
		"chest":
			var looted: Array = cmd.get("loots", [])
			var item_name: String = String(looted[0].get("name", "un objet")) \
				if not looted.is_empty() else ""
			if item_name != "":
				_message.text = "Coffre ouvert ! +%d XP — « %s » rejoint\nl'inventaire commun." \
					% [ProgressionManager.ADVENTURE_BASE_XP, item_name]
			else:
				_message.text = "Coffre ouvert ! +%d XP." % ProgressionManager.ADVENTURE_BASE_XP
			_refresh()
		"camp":
			_message.text = "Vous vous reposez à la source claire. +%d XP d'exploration." \
				% int(ProgressionManager.ADVENTURE_BASE_XP * 0.5)
			_refresh()
		"reveal":
			var names: Array = cmd.get("names", [])
			_show_reveal_popup(names)
			_refresh()
		"combat":
			_start_combat(cmd.get("poi", {}))
		"exit":
			_show_exit_dialog(cmd.get("key", ""))
		_:
			_message.text = "Rien de particulier ici... pour l'instant."

func _show_puzzle_dialog(cmd: Dictionary) -> void:
	var puzzle: Dictionary = cmd.get("puzzle", {})
	var dialog := AcceptDialog.new()
	dialog.title = "✦  Énigme"
	dialog.ok_button_text = "Répondre"
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 10)
	dialog.add_child(box)
	var label := Label.new()
	label.text = String(puzzle.get("text", ""))
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.custom_minimum_size.x = 520
	box.add_child(label)
	var input := LineEdit.new()
	input.placeholder_text = "Votre réponse..."
	box.add_child(input)
	dialog.confirmed.connect(func() -> void:
		var ok: bool = manager.solve_puzzle(String(cmd.get("key", "")),
			input.text)
		if ok:
			_message.text = "Énigme résolue : +%d XP d'exploration !" \
				% (ProgressionManager.ADVENTURE_BASE_XP * 2)
		else:
			_message.text = String(puzzle.get("wrong", "Les runes restent muettes."))
		_refresh()
		dialog.queue_free())
	add_child(dialog)
	dialog.popup_centered(Vector2i(620, 220))

func _show_reveal_popup(names: Array) -> void:
	if names.is_empty():
		_message.text = "Vous connaissiez déjà ces horizons."
		return
	var dialog := AcceptDialog.new()
	dialog.title = "🔍  Horizons découverts !"
	var sighted: String = "\n".join(PackedStringArray(names))
	dialog.dialog_text = "Du haut du belvédère, vous repérez :\n\n%s" % sighted \
		+ "\n\nCes villes sont désormais visibles en CONQUÊTE."
	add_child(dialog)
	dialog.popup_centered(Vector2i(560, 260))
	_message.text = "Belvédère : villes révélées pour la Conquête !"

func _show_exit_dialog(key: String) -> void:
	var revealed: Array = manager.take_exit(key)
	var dialog := AcceptDialog.new()
	dialog.title = "🧭  Sentier découvert !"
	var zone_names: Array = []
	var new_zones: Array = []
	for r: String in revealed:
		if String(r).begins_with("zone:"):
			var zid := String(r).substr(5)
			new_zones.append(zid)
			zone_names.append(ProgressionManager.adventure_zone_name(zid))
	if zone_names.is_empty():
		var familiar: String = "Ce sentier vous est déjà familier.\n"
		dialog.dialog_text = familiar \
			+ "Empruntez une zone du panneau pour voyager."
	else:
		dialog.dialog_text = "Le sentier s'ouvre vers : %s\nChoisissez la zone dans « ZONES DU MONDE »." \
			% " · ".join(PackedStringArray(zone_names))
	add_child(dialog)
	dialog.popup_centered(Vector2i(560, 220))
	_refresh()
	_rebuild_zone_buttons()

func _rebuild_zone_buttons() -> void:
	for btn: Button in _zone_buttons.values():
		btn.queue_free()
	_zone_buttons.clear()
	var side_box: Node = _moves_label.get_parent()
	var idx: int = side_box.get_children().find(_moves_label)
	if idx < 0:
		idx = side_box.get_child_count()
	for zone_id: String in manager.available_zones():
		var btn := Button.new()
		var meta: Dictionary = ProgressionManager.adventure_zone_meta(zone_id)
		btn.text = "%s  ·  %s" % [String(meta.get("name", zone_id)),
			ProgressionManager.biome_label(String(meta.get("biome", "Forêt")))]
		btn.custom_minimum_size.y = 54
		btn.add_theme_font_size_override("font_size", 21)
		btn.pressed.connect(_on_zone_pressed.bind(zone_id))
		side_box.add_child(btn)
		side_box.move_child(btn, maxi(0, idx))
		_zone_buttons[zone_id] = btn
		idx += 1
	_refresh()

func _on_zone_pressed(zone_id: String) -> void:
	if zone_id == manager.zone_id():
		return
	if manager.enter_zone(zone_id):
		_message.text = "Vous arrivez : %s." % manager.zone_name()
		_build_map()
		_refresh()

func _start_combat(poi: Dictionary) -> void:
	var level: int = manager.challenge_level(poi)
	_save["adventure"] = manager.state
	_save["adventure"]["pending_level"] = level
	_save["campaign_mode"] = "adventure"
	manager.persist()
	GameManager.fight_biome = manager.zone_biome()
	get_tree().change_scene_to_file("res://scenes/TeamSelection.tscn")

func _on_cities_revealed(city_ids: Array) -> void:
	for city_id: String in city_ids:
		if not _save.has("conquest") or not (_save["conquest"] is Dictionary):
			_save["conquest"] = {"owned": ["capitale"], "pending_city": "",
				"discovered": []}
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

func _panel_style(bg: Color, border: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(2)
	s.set_corner_radius_all(10)
	s.content_margin_left = 8
	s.content_margin_right = 8
	s.content_margin_top = 6
	s.content_margin_bottom = 6
	return s
