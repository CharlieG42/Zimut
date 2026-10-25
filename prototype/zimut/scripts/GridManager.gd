extends Node2D
## GridManager.gd — Rendu isométrique 2:1 (style Dofus / Waven) et animations.
##
## - Cases dessinées par code (Cell), obstacles (Prop), entités (EntityView) triées en profondeur
## - File d'événements « fx » du GameManager jouée séquentiellement (déplacements, sorts,
##   dégâts flottants, particules, projectiles, secousses d'écran)
## - Entrées souris / tactile (double-tap pour confirmer sur mobile)

signal cell_clicked(x: int, y: int)
signal hover_changed(pos: Vector2i)

const TILE_W := 128.0
const TILE_H := 64.0

var game_manager
var cell_nodes: Array = []
var views: Dictionary = {}          # uid -> EntityView
var hover_cell: Vector2i = Vector2i(-1, -1)

var _cells_layer: Node2D
var _biome: String = ""
var _entity_layer: Node2D
var _fx_layer: Node2D
var _forest_ambience: ForestAmbience
var _scenery: BattleScenery
var _scenery_over: SceneryOver
var _scenery_amb: SceneryAmbient
var _cur_element: String = "physical"   # élément du dernier sort lancé (impacts)
var _trap_nodes: Dictionary = {}    # Vector2i -> Node2D
var _glyph_nodes: Dictionary = {}   # glyphe (Dictionary, par identité) -> SpellFx.GlyphMark
var _prop_nodes: Array = []
var _obstacle_sig: int = -1
var _void_layer: Node2D
var _queue: Array = []
var _pumping: bool = false
var _dirty: bool = false
var _glow_tex: GradientTexture2D
var _shake_amp: float = 0.0
var _confirm_tap: bool = false
var _gen: int = 0


func _ready() -> void:
	_confirm_tap = OS.has_feature("mobile")
	set_process(true)


# ═══════════════════════════════════════════════════════════════════════════
#  Initialisation
# ═══════════════════════════════════════════════════════════════════════════

func init(manager) -> void:
	game_manager = manager
	_make_glow_texture()
	_build_layers()
	_build_cells()
	game_manager.fx.connect(_on_fx)
	game_manager.spell_selected.connect(func(_s) -> void: refresh_highlights())
	game_manager.turn_changed.connect(func(_t: int) -> void: refresh_highlights())
	game_manager.state_changed.connect(func() -> void: refresh_highlights())


func _make_glow_texture() -> void:
	var g := Gradient.new()
	g.colors = PackedColorArray([Color(1, 1, 1, 1), Color(1, 1, 1, 0)])
	g.offsets = PackedFloat32Array([0.0, 1.0])
	_glow_tex = GradientTexture2D.new()
	_glow_tex.gradient = g
	_glow_tex.fill = GradientTexture2D.FILL_RADIAL
	_glow_tex.fill_from = Vector2(0.5, 0.5)
	_glow_tex.fill_to = Vector2(0.5, 0.0)
	_glow_tex.width = 64
	_glow_tex.height = 64


func _build_layers() -> void:
	for c: Node in get_children():
		c.queue_free()
	# Décor d'arrière-plan : rebord surélevé, prolongement de falaise, brume (derrière les cases)
	_scenery = BattleScenery.new()
	_scenery.name = "Scenery"
	add_child(_scenery)
	# V49 : gouffres des cases hors plateau (sous les cases, dont les faces forment les parois)
	_void_layer = Node2D.new()
	_void_layer.name = "VoidPits"
	add_child(_void_layer)
	_cells_layer = Node2D.new()
	_cells_layer.name = "Cells"
	add_child(_cells_layer)
	# Lèvre de l'île et lianes devant les falaises (devant les cases, derrière les unités)
	_scenery_over = SceneryOver.new()
	_scenery_over.name = "SceneryOver"
	add_child(_scenery_over)
	_forest_ambience = preload("res://scripts/ForestAmbience.gd").new()
	_forest_ambience.name = "ForestAmbience"
	_forest_ambience.z_index = 0
	_forest_ambience.configure(game_manager.GRID_SIZE, TILE_W, TILE_H, game_manager.fight_biome == "Forêt")
	add_child(_forest_ambience)
	_entity_layer = Node2D.new()
	_entity_layer.name = "Entities"
	_entity_layer.y_sort_enabled = true
	add_child(_entity_layer)
	_scenery_amb = SceneryAmbient.new()
	_scenery_amb.name = "SceneryAmbient"
	_scenery_amb.z_index = 150
	add_child(_scenery_amb)
	_fx_layer = Node2D.new()
	_fx_layer.name = "FX"
	_fx_layer.z_index = 200
	add_child(_fx_layer)
	_configure_scenery(game_manager.fight_biome)


## (Re)génère le décor de contour pour un biome : graine = combat en cours (décor stable par combat).
func _configure_scenery(biome: String) -> void:
	var fight_no: int = 1
	if game_manager != null and not game_manager.active_save.is_empty():
		fight_no = ProgressionManager.selected_fight_number(game_manager.active_save)
	var sd: int = fight_no * 37 + biome.hash() % 997
	var n: int = game_manager.GRID_SIZE
	if _scenery != null:
		_scenery.configure(n, biome, sd)
	if _scenery_over != null:
		_scenery_over.configure(n, biome, sd)
	if _scenery_amb != null:
		_scenery_amb.configure(n, biome, sd)
		_scenery_amb.visible = biome != "Forêt" or true


## Applique le biome courant aux cases existantes (palette/touffes/fleurs).
func apply_biome(biome: String) -> void:
	if biome == _biome:
		return
	_biome = biome
	_configure_scenery(biome)
	if _forest_ambience != null:
		_forest_ambience.set_forest_active(biome == "Forêt")
	for y: int in range(cell_nodes.size()):
		for x: int in range(cell_nodes[y].size()):
			var c: Cell = cell_nodes[y][x]
			c.biome = biome
			c.setup(c.grid_position)
	_obstacle_sig = -1

func _build_cells() -> void:
	cell_nodes = []
	var n: int = game_manager.GRID_SIZE
	# Les cases sont ajoutées dans l'ordre x+y pour un recouvrement correct des falaises
	for y: int in range(n):
		var row: Array = []
		for x: int in range(n):
			var cell := Cell.new()
			cell.biome = game_manager.fight_biome
			cell.setup(Vector2i(x, y))
			cell.position = grid_to_screen(x, y)
			cell.edge_left = (y == n - 1)
			cell.edge_right = (x == n - 1)
			_cells_layer.add_child(cell)
			row.append(cell)
		cell_nodes.append(row)


# ═══════════════════════════════════════════════════════════════════════════
#  Projection
# ═══════════════════════════════════════════════════════════════════════════

func grid_to_screen(gx: float, gy: float) -> Vector2:
	return Vector2((gx - gy) * TILE_W * 0.5, (gx + gy) * TILE_H * 0.5)


func screen_to_grid(p: Vector2) -> Vector2i:
	var gx: float = (p.y / (TILE_H * 0.5) + p.x / (TILE_W * 0.5)) * 0.5
	var gy: float = (p.y / (TILE_H * 0.5) - p.x / (TILE_W * 0.5)) * 0.5
	return Vector2i(roundi(gx), roundi(gy))


func grid_center() -> Vector2:
	var c: float = float(game_manager.GRID_SIZE - 1) * 0.5
	return grid_to_screen(c, c)


func _valid(c: Vector2i) -> bool:
	return c.x >= 0 and c.y >= 0 and c.x < game_manager.GRID_SIZE and c.y < game_manager.GRID_SIZE


func _cell(c: Vector2i) -> Cell:
	if not _valid(c):
		return null
	return cell_nodes[c.y][c.x]


# ═══════════════════════════════════════════════════════════════════════════
#  Synchronisation avec l'état logique
# ═══════════════════════════════════════════════════════════════════════════

func is_busy() -> bool:
	return _pumping or not _queue.is_empty()


func update_entity_display() -> void:
	if game_manager == null or cell_nodes.is_empty():
		return
	if is_busy():
		_dirty = true
		return
	_sync_now()


func _sync_now() -> void:
	_dirty = false
	_sync_props()
	var alive_uids: Dictionary = {}
	for e: Dictionary in game_manager.all_entities():
		var uid: int = int(e["uid"])
		alive_uids[uid] = true
		var v: EntityView = _ensure_view(e)
		v.entity = e
		v.position = grid_to_screen(int(e["x"]), int(e["y"]))
		v.set_hp(float(e["current_pv"]))
	for uid: int in views.keys():
		if not alive_uids.has(uid) and not views[uid].dying:
			views[uid].queue_free()
			views.erase(uid)
	_sync_traps()
	_sync_glyphs()
	refresh_highlights()


func _ensure_view(e: Dictionary) -> EntityView:
	var uid: int = int(e["uid"])
	if views.has(uid) and is_instance_valid(views[uid]):
		return views[uid]
	var v := EntityView.new()
	v.setup(e)
	v.position = grid_to_screen(int(e["x"]), int(e["y"]))
	# Les unités restent lisibles même derrière le feuillage des arbres : la profondeur
	# des décors ne doit pas masquer entièrement un combattant et ne laisser que sa barre de vie.
	v.z_index = 1
	_entity_layer.add_child(v)
	views[uid] = v
	return v


func _view(e: Dictionary) -> EntityView:
	var uid: int = int(e.get("uid", -1))
	if views.has(uid) and is_instance_valid(views[uid]):
		return views[uid]
	return null


func _sync_props() -> void:
	var sig: int = game_manager.obstacles.hash()
	if sig == _obstacle_sig:
		return
	_obstacle_sig = sig
	for p: Node in _prop_nodes:
		if is_instance_valid(p):
			p.queue_free()
	_prop_nodes = []
	_sync_void_pits()
	for c: Vector2i in game_manager.obstacles.keys():
		if String(game_manager.obstacles[c]) == "void":
			continue
		var prop := Prop.new()
		prop.setup(String(game_manager.obstacles[c]), c, game_manager.fight_biome)
		prop.position = grid_to_screen(c.x, c.y) + Vector2(0, 6)
		_entity_layer.add_child(prop)
		_prop_nodes.append(prop)


## V49 : cases hors plateau rendues en gouffres ; les faces des cases voisines deviennent
## les parois (pit_left / pit_right).
func _sync_void_pits() -> void:
	var obs: Dictionary = game_manager.obstacles
	var n: int = cell_nodes.size()
	if _void_layer != null:
		for c: Node in _void_layer.get_children():
			c.queue_free()
	# Cases vides reliées au bord de l'île (replats) vs. intérieures (gouffres)
	var outer: Dictionary = {}
	var stack: Array[Vector2i] = []
	for vc in obs.keys():
		if String(obs[vc]) == "void" and (vc.x == 0 or vc.y == 0 or vc.x == n - 1 or vc.y == n - 1):
			outer[vc] = true
			stack.append(vc)
	while not stack.is_empty():
		var cur: Vector2i = stack.pop_back()
		for d: Vector2i in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
			var nb: Vector2i = cur + d
			if not outer.has(nb) and String(obs.get(nb, "")) == "void":
				outer[nb] = true
				stack.append(nb)
	for y: int in range(n):
		for x: int in range(cell_nodes[y].size()):
			var cell: Cell = cell_nodes[y][x]
			var is_void: bool = String(obs.get(Vector2i(x, y), "")) == "void"
			cell.visible = not is_void
			cell.pit_left = not is_void and String(obs.get(Vector2i(x, y + 1), "")) == "void"
			cell.pit_right = not is_void and String(obs.get(Vector2i(x + 1, y), "")) == "void"
			cell.queue_redraw()
			if is_void and _void_layer != null:
				var pit := VoidPit.new()
				pit.position = grid_to_screen(x, y)
				pit.setup(Vector2i(x, y), game_manager.fight_biome, n, outer.has(Vector2i(x, y)))
				_void_layer.add_child(pit)


func _sync_traps() -> void:
	var wanted: Dictionary = {}
	for t: Dictionary in game_manager.traps:
		wanted[t["pos"]] = t
	for c: Vector2i in _trap_nodes.keys():
		if not wanted.has(c):
			_trap_nodes[c].queue_free()
			_trap_nodes.erase(c)
	for c: Vector2i in wanted.keys():
		if not _trap_nodes.has(c):
			_add_trap_node(c)


## Runes des glyphes actifs (une marque par glyphe, retirée à l'expiration).
func _sync_glyphs() -> void:
	var alive: Dictionary = {}
	for g: Dictionary in game_manager.glyphs:
		alive[int(g["id"])] = g
	for id in _glyph_nodes.keys():
		if not alive.has(id):
			if is_instance_valid(_glyph_nodes[id]):
				_glyph_nodes[id].queue_free()
			_glyph_nodes.erase(id)
	for id in alive.keys():
		if not _glyph_nodes.has(id):
			_add_glyph_node(alive[id])


func _add_glyph_node(g: Dictionary) -> void:
	var id: int = int(g["id"])
	if _glyph_nodes.has(id):
		return
	var center: Vector2i = g["center"]
	var m := SpellFx.GlyphMark.new()
	m.position = grid_to_screen(center.x, center.y)
	m.z_index = 1
	m.col = SpellFx.colors(String(g["element"]))[0]
	for c: Vector2i in g["cells"]:
		m.offsets.append(grid_to_screen(c.x, c.y) - m.position)
	_cells_layer.add_child(m)
	_glyph_nodes[id] = m


func _add_trap_node(c: Vector2i) -> void:
	if _trap_nodes.has(c):
		return
	var n := Node2D.new()
	n.position = grid_to_screen(c.x, c.y)
	n.z_index = 1
	n.draw.connect(func() -> void:
		n.draw_circle(Vector2.ZERO, 3.0, Color(0.8, 0.2, 0.2))
		for i: int in range(8):
			var a: float = TAU * float(i) / 8.0
			var p0 := Vector2(cos(a) * 8.0, sin(a) * 4.0)
			var p1 := Vector2(cos(a) * 22.0, sin(a) * 11.0)
			n.draw_line(p0, p1, Color(0.9, 0.25, 0.2, 0.95), 3.0)
		n.draw_arc(Vector2.ZERO, 26.0, 0.0, TAU, 24, Color(1, 0.3, 0.2, 0.5), 2.0))
	_cells_layer.add_child(n)
	_trap_nodes[c] = n
	n.queue_redraw()


# ═══════════════════════════════════════════════════════════════════════════
#  Surbrillances
# ═══════════════════════════════════════════════════════════════════════════

func _clear_highlights() -> void:
	for row: Array in cell_nodes:
		for c: Cell in row:
			c.in_move_range = false
			c.in_spell_range = false
			c.spell_target_ok = false
			c.aoe_hl = false
			c.ally_target = false
			c.path_hl = false
			c.path_cost = 0
			c.threat = 0
	for v: EntityView in views.values():
		v.preview_text = ""


func refresh_highlights() -> void:
	if game_manager == null or cell_nodes.is_empty():
		return
	_clear_highlights()
	if not is_busy() and game_manager.can_player_act():
		var e: Dictionary = game_manager.active_entity
		var spell = game_manager.selected_spell
		if spell == null:
			var reach: Dictionary = game_manager.compute_reach(e)
			for c: Vector2i in reach["cost"].keys():
				if c != game_manager.pos_of(e):
					_cell(c).in_move_range = true
			if _valid(hover_cell) and reach["cost"].has(hover_cell) and hover_cell != game_manager.pos_of(e):
				var path: Array[Vector2i] = game_manager.reach_path(reach, game_manager.pos_of(e), hover_cell)
				for p: Vector2i in path:
					_cell(p).path_hl = true
				_cell(hover_cell).path_cost = path.size()
		else:
			var p: Dictionary = Combat.parse(spell)
			var cells: Array[Vector2i] = game_manager.spell_range_cells(e, spell)
			for c: Vector2i in cells:
				var cn: Cell = _cell(c)
				cn.in_spell_range = true
				if game_manager.validate_cast(e, spell, c) == "":
					cn.spell_target_ok = true
					if p["target"] == "ally" or p["target"] == "self" or p["kind"] == "heal" or p["kind"] == "buff":
						cn.ally_target = true
			if cells.has(hover_cell) and game_manager.validate_cast(e, spell, hover_cell) == "":
				for c: Vector2i in game_manager.get_aoe_cells(e, spell, hover_cell):
					_cell(c).aoe_hl = true
					var t: Dictionary = game_manager.entity_at(c)
					if t.is_empty() or not _view(t):
						continue
					if p["kind"] == "attack" and t["team"] != e["team"]:
						var dmg: int = game_manager.estimate_damage(e, spell, t)
						if dmg > 0:
							_view(t).preview_text = "-%d" % dmg
					elif p["kind"] == "heal" and t["team"] == e["team"] and int(p["heal"]) > 0:
						_view(t).preview_text = "+%d" % roundi(float(p["heal"]) * (1.0 + float(e.get("intelligence", 0)) / 300.0))
	if not _threat_of.is_empty():
		_paint_threat(_threat_of)
	for row: Array in cell_nodes:
		for c: Cell in row:
			c.hover = (c.grid_position == hover_cell)
			c.refresh()
	for v: EntityView in views.values():
		v.hovered = _valid(hover_cell) and game_manager.pos_of(v.entity) == hover_cell


# ── Menace d'un ennemi (appui long sur lui ou sur son portrait) ──────────────
var _threat_of: Dictionary = {}
var _press_cell: Vector2i = Vector2i(-1, -1)
var _press_t: float = -1.0
const THREAT_HOLD := 0.45


## Affiche (ou masque avec {}) la zone de menace d'une entité ennemie.
func show_threat(e: Dictionary) -> void:
	_threat_of = e if not e.is_empty() and String(e.get("team", "")) == "enemy" else {}
	refresh_highlights()


## Orange : cases où l'ennemi peut se rendre ce tour-ci ; rouge : cases qu'il peut frapper en plus.
func _paint_threat(e: Dictionary) -> void:
	if not game_manager.is_alive(e):
		_threat_of = {}
		return
	var reach: Dictionary = game_manager.compute_reach(e, int(e.get("max_pm", e.get("current_pm", 3))))
	var hit: Dictionary = {}
	for spell: Dictionary in e.get("spells", []):
		var p: Dictionary = Combat.parse(spell)
		if String(p["kind"]) != "attack":
			continue
		var r: int = int(spell.get("range", 1))
		var rmin: int = int(p.get("min_range", 1))
		for from: Vector2i in reach["cost"].keys():
			for dy: int in range(-r, r + 1):
				for dx: int in range(-r, r + 1):
					var d: int = absi(dx) + absi(dy)
					if d < rmin or d > r:
						continue
					var c := Vector2i(from.x + dx, from.y + dy)
					if _valid(c):
						hit[c] = true
	for c: Vector2i in reach["cost"].keys():
		_cell(c).threat = 1
	for c: Vector2i in hit.keys():
		if _cell(c).threat == 0:
			_cell(c).threat = 2


func _set_hover(c: Vector2i) -> void:
	if not _valid(c):
		c = Vector2i(-1, -1)
	if c == hover_cell:
		return
	hover_cell = c
	hover_changed.emit(c)
	refresh_highlights()


# ═══════════════════════════════════════════════════════════════════════════
#  Entrées
# ═══════════════════════════════════════════════════════════════════════════

## Transmet un appui court sur la timeline comme un clic sur la cellule
## correspondante : le ciblage du sort actif reste identique à celui du plateau.
func select_entity_from_timeline(cell: Vector2i) -> void:
	if game_manager == null or not _valid(cell):
		return
	# Reproduit la règle du plateau : sur mobile, le premier tap prévisualise
	# et le second tap sur la même cellule confirme la cible.
	if _confirm_tap and cell != hover_cell:
		_set_hover(cell)
		return
	_set_hover(cell)
	cell_clicked.emit(cell.x, cell.y)


func _unhandled_input(event: InputEvent) -> void:
	if game_manager == null or cell_nodes.is_empty():
		return
	if event is InputEventMouseButton and not event.pressed and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
		_press_t = -1.0
		if not _threat_of.is_empty():
			show_threat({})
		return
	if event is InputEventMouseMotion:
		_set_hover(screen_to_grid(to_local(get_global_mouse_position())))
	elif event is InputEventMouseButton and event.pressed:
		var mb := event as InputEventMouseButton
		if mb.button_index == MOUSE_BUTTON_RIGHT:
			if game_manager.selected_spell != null and game_manager.can_player_act():
				game_manager.selected_spell = null
				game_manager.spell_selected.emit(null)
			return
		if mb.button_index != MOUSE_BUTTON_LEFT:
			return
		var c: Vector2i = screen_to_grid(to_local(get_global_mouse_position()))
		# Début d'un éventuel appui long sur un ennemi
		_press_cell = c
		_press_t = 0.0
		if not _valid(c):
			return
		if _confirm_tap and c != hover_cell:
			_set_hover(c)     # 1er tap : prévisualisation, 2e tap : confirmation
			return
		_set_hover(c)
		cell_clicked.emit(c.x, c.y)


# ═══════════════════════════════════════════════════════════════════════════
#  File d'événements animés
# ═══════════════════════════════════════════════════════════════════════════

func _on_fx(kind: String, data: Dictionary) -> void:
	if kind == "error":
		Sfx.play("error")
		return
	if kind == "click":
		Sfx.play("click")
		return
	if kind == "banner":
		return
	_queue.append([kind, data])
	if not _pumping:
		_pump()


func _pump() -> void:
	_pumping = true
	var gen: int = _gen
	while not _queue.is_empty():
		var ev: Array = _queue.pop_front()
		await _play(String(ev[0]), ev[1])
		if not is_inside_tree() or gen != _gen:
			return
	_pumping = false
	_sync_now()
	game_manager.state_changed.emit()


func _wait(sec: float) -> void:
	if not is_inside_tree():
		return
	await get_tree().create_timer(sec).timeout


func _play(kind: String, d: Dictionary) -> void:
	match kind:
		"turn":
			Sfx.play("turn")
			_update_outlines()
			await _wait(0.25)
		"move":
			await _play_move(d)
		"teleport":
			await _play_teleport(d)
		"push":
			await _play_push(d)
		"cast":
			await _play_cast(d)
		"damage":
			await _play_damage(d)
		"heal":
			await _play_heal(d)
		"status":
			_play_status(d)
			await _wait(0.1)
		"death":
			await _play_death(d)
		"summon":
			await _play_summon(d)
		"trap_set":
			_add_trap_node(d["cell"])
			Sfx.play("trap", -4.0)
			await _wait(0.15)
		"beacon":
			for c: Vector2i in d["cells"]:
				_burst(grid_to_screen(c.x, c.y), Color(1.0, 0.70, 0.20), 10, 130.0, 0.4, 4.0)
			Sfx.play("hit", -2.0)
			await _wait(0.18)
		"glyph_set":
			var gg: Dictionary = d["glyph"]
			_add_glyph_node(gg)
			var gcol: Color = SpellFx.colors(String(gg["element"]))[0]
			var gcen: Vector2i = gg["center"]
			_ring(grid_to_screen(gcen.x, gcen.y), gcol, 12.0, 90.0, 0.7, 6.0)
			_burst(grid_to_screen(gcen.x, gcen.y), gcol, 22, 160.0, 0.6, 4.0)
			Sfx.play("trap", -3.0)
			await _wait(0.25)
		"glyph_end":
			var ge: Dictionary = d["glyph"]
			var gid: int = int(ge["id"])
			if _glyph_nodes.has(gid):
				if is_instance_valid(_glyph_nodes[gid]):
					_glyph_nodes[gid].queue_free()
				_glyph_nodes.erase(gid)
		"trap_trigger":
			var c: Vector2i = d["cell"]
			_burst(grid_to_screen(c.x, c.y), Color(1.0, 0.4, 0.2), 26, 220.0, 0.5, 5.0)
			if _trap_nodes.has(c):
				_trap_nodes[c].queue_free()
				_trap_nodes.erase(c)
			Sfx.play("hit")
			_shake(6.0)
			await _wait(0.2)
		"timer_expired":
			# V42 : anneau doré sur le personnage dont le timer de tour expire
			var te: Dictionary = d.get("entity", {})
			if not te.is_empty():
				var tp2: Vector2i = game_manager.pos_of(te)
				_ring(grid_to_screen(tp2.x, tp2.y), Color(1.0, 0.82, 0.25), 10.0, 64.0, 0.55, 7.0)
				_burst(grid_to_screen(tp2.x, tp2.y), Color(1.0, 0.85, 0.3), 18, 150.0, 0.45, 4.0)


func _update_outlines() -> void:
	for v: EntityView in views.values():
		v.queue_redraw()


func _play_move(d: Dictionary) -> void:
	var v: EntityView = _view(d["entity"])
	if v == null:
		return
	var pts: Array[Vector2] = []
	for c: Vector2i in d["path"]:
		pts.append(grid_to_screen(c.x, c.y))
	var step: float = 0.15 if pts.size() <= 4 else 0.11
	var tw: Tween = v.move_along(pts, step)
	for i: int in range(pts.size()):
		get_tree().create_timer(step * float(i) + step * 0.8).timeout.connect(func() -> void: Sfx.play("step", -6.0))
	await tw.finished
	_burst(v.position, Color(0.8, 0.75, 0.6, 0.8), 6, 40.0, 0.35, 3.0, 40.0, Vector2.UP)


func _play_teleport(d: Dictionary) -> void:
	var v: EntityView = _view(d["entity"])
	if v == null:
		return
	Sfx.play("teleport")
	_burst(v.position, Color(0.7, 0.5, 1.0), 20, 180.0, 0.5, 5.0)
	await v.vanish().finished
	var to: Vector2i = d["to"]
	v.position = grid_to_screen(to.x, to.y)
	_burst(v.position, Color(0.7, 0.5, 1.0), 20, 180.0, 0.5, 5.0)
	await v.appear().finished


func _play_push(d: Dictionary) -> void:
	var v: EntityView = _view(d["entity"])
	if v == null:
		return
	var pts: Array[Vector2] = []
	for c: Vector2i in d["path"]:
		pts.append(grid_to_screen(c.x, c.y))
	if not pts.is_empty():
		await v.slide_to(pts).finished
	if d["collided"]:
		v.hit_react(1.4)
		_burst(v.position + Vector2(0, -30), Color(1.0, 0.8, 0.4), 14, 200.0, 0.4, 5.0)
		_shake(8.0)
		Sfx.play("hit")
		await _wait(0.12)


func _spell_color(d: Dictionary) -> Color:
	match String(d.get("kind", "attack")):
		"heal":
			return Color(0.4, 1.0, 0.5)
		"buff":
			return Color(1.0, 0.9, 0.35)
		"summon", "teleport":
			return Color(0.7, 0.5, 1.0)
		"trap":
			return Color(1.0, 0.45, 0.25)
	return Color(0.45, 0.65, 1.0) if String(d.get("dtype", "phys")) == "mag" else Color(1.0, 0.85, 0.55)


func _play_cast(d: Dictionary) -> void:
	var caster: Dictionary = d["caster"]
	var v: EntityView = _view(caster)
	var from: Vector2i = d["from"]
	var to: Vector2i = d["to"]
	var kind: String = String(d["kind"])
	var elem: String = SpellFx.element_for(String(d.get("spell", "")), String(d["dtype"]), kind)
	_cur_element = elem
	var cols: Array = SpellFx.colors(elem)
	var col: Color = cols[0]
	var to_pos: Vector2 = grid_to_screen(to.x, to.y) + Vector2(0, -26)
	if v != null:
		v.face_screen_dx(to_pos.x - v.position.x)
	# Zone d'effet : flash des cases
	for c: Vector2i in d["cells"]:
		var cn: Cell = _cell(c)
		if cn != null:
			cn.flash = 1.0
			cn.refresh()
	var multi: bool = (d["cells"] as Array).size() > 1
	if kind == "attack":
		var phys: bool = String(d["dtype"]) == "phys"
		if d["ranged"] and v != null:
			_charge(v, elem, phys)   # V47 : charge d'incantation / élan côté lanceur
			v.tint_flash(col, 0.3, 0.35)
			await _wait(0.12)
			v.play_pose("attack", 0.6, String(d.get("spell", "")))
			Sfx.play("magic" if not phys else "cast")
			var start: Vector2 = v.position + Vector2(0, -50)
			await _projectile_el(start, to_pos, elem, phys)
		elif v != null:
			if elem != "physical":
				_charge(v, elem, false)
			Sfx.play("slash")
			v.lunge(grid_to_screen(to.x, to.y), String(d.get("spell", "")))
			await get_tree().create_timer(0.1).timeout
			_slash(to_pos, col)
			await get_tree().create_timer(0.08).timeout
		else:
			await _wait(0.1)
		if multi:
			_aoe_ripple(d["cells"], to, col, elem)
	else:
		Sfx.play("heal" if kind == "heal" else ("buff" if kind == "buff" else "cast"))
		if v != null:
			_charge(v, elem, false)
			_rune(v.position, col)
			_burst(v.position + Vector2(0, -40), col, 18, 120.0, 0.7, 5.0, 180.0, Vector2.UP, Vector2(0, -60))
			v.cast_pose(String(d.get("spell", "")))
			v.tint_flash(col, 0.35, 0.4)
			# V47 : étincelle de soutien qui rejoint un allié à distance
			if (kind == "heal" or kind == "buff") and from != to and v.position.distance_to(to_pos) > 90.0:
				await _wait(0.12)
				await _support_wisp(v.position + Vector2(0, -50), to_pos, col, cols[1])
		if multi:
			_aoe_ripple(d["cells"], to, col, elem)
		await _wait(0.2)


## V47 : nombre d'effets à l'écran borné (lisibilité + perfs mobile).
func _fx_ok(limit: int = 70) -> bool:
	return _fx_layer != null and _fx_layer.get_child_count() < limit


## Charge d'incantation autour du lanceur (étincelles qui convergent / traits d'élan).
func _charge(v: EntityView, elem: String, phys: bool) -> void:
	if not _fx_ok():
		return
	var cols: Array = SpellFx.colors(elem)
	var c := SpellFx.Charge.new()
	c.col = cols[0]
	c.col2 = cols[1]
	c.physical = phys
	c.position = v.position + Vector2(0, -48)
	_fx_layer.add_child(c)


## V47 : onde de choc d'une zone d'effet — un anneau par case, retardé selon la distance au centre.
func _aoe_ripple(cells: Array, center: Vector2i, col: Color, elem: String) -> void:
	var shown: int = 0
	for c: Vector2i in cells:
		if shown >= 12 or not _fx_ok(90):
			return
		var dist: float = float(absi(c.x - center.x) + absi(c.y - center.y))
		var pos: Vector2 = grid_to_screen(c.x, c.y)
		var r := SpellFx.Ring.new()
		r.col = col
		r.r0 = 4.0
		r.r1 = 40.0
		r.life = 0.45
		r.thick = 4.0
		r.t = -0.07 * dist
		r.position = pos
		_fx_layer.add_child(r)
		if c != center:
			get_tree().create_timer(0.07 * dist).timeout.connect(func() -> void:
				if is_inside_tree() and _fx_ok(90):
					_burst(pos, col, 6, 80.0, 0.4, 4.0))
		shown += 1
	if elem in SpellFx.IMPACT_SPIKES:
		_spikes(grid_to_screen(center.x, center.y), elem, 1.2)


## V47 : pointes radiales à l'impact (glace, pierre, épines, rayons...).
func _spikes(pos: Vector2, elem: String, scale_: float = 1.0) -> void:
	if not SpellFx.IMPACT_SPIKES.has(elem) or not _fx_ok():
		return
	var info: Array = SpellFx.IMPACT_SPIKES[elem]
	var sp := SpellFx.Spikes.new()
	sp.col = SpellFx.colors(elem)[0]
	sp.n = int(info[0])
	sp.length = float(info[1]) * scale_
	sp.rot = float(info[2])
	sp.position = pos
	_fx_layer.add_child(sp)


## V47 : étincelle de soutien (soin, buff) du lanceur vers un allié, avec traînée.
func _support_wisp(start: Vector2, end: Vector2, col: Color, col2: Color) -> void:
	var m := SpellFx.Missile.new()
	m.kind = "wisp"
	m.col = col
	m.col2 = col2
	m.position = start
	_fx_layer.add_child(m)
	var trail: CPUParticles2D = _make_particles(col, 14, 0.4, 16.0, 0.3)
	trail.emitting = true
	trail.one_shot = false
	trail.explosiveness = 0.0
	m.add_child(trail)
	var tw: Tween = create_tween()
	tw.tween_method(func(f: float) -> void:
		m.position = start.lerp(end, f) + Vector2(0.0, -sin(f * PI) * 46.0),
		0.0, 1.0, clampf(start.distance_to(end) / 800.0, 0.2, 0.45)).set_trans(Tween.TRANS_SINE)
	await tw.finished
	m.queue_free()


## V47 : marque de statut (bouclier, chevrons, étoiles, racines, gouttes...) sur la cible.
func _status_mark(v: EntityView, id: String, col: Color, good: bool) -> void:
	if not _fx_ok(90):
		return
	var m := SpellFx.StatusMark.new()
	m.style = SpellFx.status_style(id, good)
	m.col = col
	m.h = clampf(float(v.height), 60.0, 160.0)
	m.position = v.position
	_fx_layer.add_child(m)


## Projectile propre à l'élément : flèche, éclat de glace, boule de feu, glu de poison,
## orbe d'ombre, feuille, éclair instantané...
func _projectile_el(start: Vector2, end: Vector2, elem: String, phys: bool) -> void:
	var cols: Array = SpellFx.colors(elem)
	var col: Color = cols[0]
	var col2: Color = cols[1]
	if elem == "lightning":
		var bolt := SpellFx.Bolt.new()
		bolt.setup(start, end, col)
		_fx_layer.add_child(bolt)
		_burst(end, col2, 10, 220.0, 0.3, 3.0)
		await _wait(0.14)
		return
	var m := SpellFx.Missile.new()
	m.col = col
	m.col2 = col2
	var arc_h: float = 0.0
	match elem:
		"ice":
			m.kind = "shard"
		"fire":
			m.kind = "flame"
		"poison", "water":
			m.kind = "glob"
			arc_h = 40.0
		"shadow":
			m.kind = "dark"
		"nature":
			m.kind = "leaf"
			arc_h = 24.0
		"physical":
			m.kind = "arrow" if phys else "orb"
		_:
			m.kind = "orb"
	m.position = start
	m.rotation = (end - start).angle() if m.kind in ["arrow", "flame", "leaf"] else 0.0
	_fx_layer.add_child(m)
	var trail: CPUParticles2D = _make_particles(col, 16, 0.4, 20.0, 0.35)
	trail.emitting = true
	trail.one_shot = false
	trail.explosiveness = 0.0
	m.add_child(trail)
	var dist: float = start.distance_to(end)
	var tw: Tween = create_tween()
	tw.tween_method(func(f: float) -> void:
		m.position = start.lerp(end, f) + Vector2(0.0, -sin(f * PI) * arc_h),
		0.0, 1.0, clampf(dist / 900.0, 0.15, 0.42)).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await tw.finished
	m.queue_free()


func _ring(pos: Vector2, col: Color, r0: float, r1: float, life: float = 0.5, thick: float = 6.0) -> void:
	var r := SpellFx.Ring.new()
	r.col = col
	r.r0 = r0
	r.r1 = r1
	r.life = life
	r.thick = thick
	r.position = pos
	_fx_layer.add_child(r)


func _rune(pos: Vector2, col: Color) -> void:
	var r := SpellFx.Rune.new()
	r.col = col
	r.position = pos + Vector2(0, 4)
	_fx_layer.add_child(r)


func _slash(pos: Vector2, col: Color) -> void:
	var sl := SpellFx.Slash.new()
	sl.col = col
	sl.ang = randf_range(-0.9, -0.3)
	sl.position = pos
	_fx_layer.add_child(sl)


func _pillar(pos: Vector2, col: Color) -> void:
	var p := SpellFx.Pillar.new()
	p.col = col
	p.position = pos
	_fx_layer.add_child(p)


## Impact visuel d'un sort selon son élément.
func _impact(pos: Vector2, elem: String, crit: bool) -> void:
	var cols: Array = SpellFx.colors(elem)
	var col: Color = cols[0]
	var col2: Color = cols[1]
	var n: float = 1.6 if crit else 1.0
	match elem:
		"fire":
			_burst(pos, col, int(22.0 * n), 170.0, 0.6, 5.0, 180.0, Vector2.UP, Vector2(0, -140))
			_burst(pos, col2, int(10.0 * n), 90.0, 0.4, 8.0, 180.0, Vector2.UP, Vector2(0, -80))
		"ice":
			_burst(pos, col, int(18.0 * n), 230.0, 0.55, 4.0, 180.0, Vector2.UP, Vector2(0, 420))
			_burst(pos, col2, 8, 120.0, 0.4, 3.0)
		"lightning":
			var b := SpellFx.Bolt.new()
			b.setup(pos + Vector2(randf_range(-24.0, 24.0), -140.0), pos, col)
			_fx_layer.add_child(b)
			_burst(pos, col2, int(14.0 * n), 260.0, 0.3, 3.0, 180.0, Vector2.UP, Vector2.ZERO)
		"poison":
			_burst(pos, col, int(14.0 * n), 70.0, 0.9, 6.0, 180.0, Vector2.UP, Vector2(0, -90))
			_burst(pos, col2, 6, 40.0, 0.8, 8.0, 180.0, Vector2.UP, Vector2(0, -50))
		"shadow":
			_burst(pos, col, int(20.0 * n), 90.0, 0.8, 9.0, 180.0, Vector2.UP, Vector2(0, -30))
			_burst(pos, col2, 10, 60.0, 0.7, 10.0, 180.0, Vector2.UP, Vector2(0, -20))
		"holy":
			_pillar(pos + Vector2(0, 40), col)
			_burst(pos, col, int(16.0 * n), 110.0, 0.9, 5.0, 180.0, Vector2.UP, Vector2(0, -110))
		"nature":
			_burst(pos, col, int(16.0 * n), 140.0, 0.9, 6.0, 180.0, Vector2.UP, Vector2(0, 140))
			_burst(pos, col2, 6, 100.0, 0.9, 5.0, 180.0, Vector2.UP, Vector2(0, 100))
		"earth":
			_burst(pos, col, int(14.0 * n), 230.0, 0.55, 7.0, 180.0, Vector2.UP, Vector2(0, 650))
			_burst(pos, col2, 8, 160.0, 0.5, 5.0, 180.0, Vector2.UP, Vector2(0, 650))
			_shake(5.0)
		"water":
			_burst(pos, col, int(18.0 * n), 190.0, 0.6, 5.0, 180.0, Vector2.UP, Vector2(0, 320))
			_burst(pos, col2, 8, 100.0, 0.5, 4.0)
		"arcane":
			_burst(pos, col, int(20.0 * n), 170.0, 0.6, 5.0)
			_burst(pos, col2, 8, 100.0, 0.5, 4.0)
		_:
			_slash(pos, col)
			_burst(pos, col2, int(12.0 * n), 200.0, 0.35, 3.0)
	_spikes(pos + Vector2(0, 38), elem, n)
	_ring(pos + Vector2(0, 38), col, 6.0, 52.0 * n, 0.38, 5.0)


func _play_damage(d: Dictionary) -> void:
	var t: Dictionary = d["target"]
	var v: EntityView = _view(t)
	if v == null:
		return
	var amount: int = int(d["amount"])
	var crit: bool = bool(d["crit"])
	var dtype: String = String(d["dtype"])
	v.set_hp(float(d["pv_after"]))
	var src: Vector2 = Vector2.INF
	var att_v: EntityView = _view(d.get("attacker", {})) if not (d.get("attacker", {}) as Dictionary).is_empty() else null
	if att_v != null and att_v != v:
		src = att_v.position
	v.hit_react(1.6 if crit else 1.0, src)
	var col: Color
	match dtype:
		"mag":
			col = Color(0.55, 0.75, 1.0)
		"dot":
			col = Color(0.8, 0.45, 0.95)
		"fall":
			col = Color(1.0, 0.75, 0.35)
		_:
			col = Color(1.0, 0.45, 0.25)
	var txt: String = "-%d" % amount
	if crit:
		txt += " !"
		col = Color(1.0, 0.9, 0.2)
	_float_text(v, txt, col, 40 if crit else 30)
	if bool(d.get("back", false)):
		_float_text(v, "Dans le dos !", Color(1.0, 0.7, 0.3), 20)
	var elem: String = "poison" if dtype == "dot" else ("earth" if dtype == "fall" else _cur_element)
	_impact(v.position + Vector2(0, -44), elem, crit)
	v.tint_flash(SpellFx.colors(elem)[0], 0.28, 0.75 if crit else 0.55)   # V47 : le sprite touché prend la teinte de l'élément
	Sfx.play("crit" if crit else "hit")
	if crit:
		Sfx.buzz(25)
	_shake(7.0 if crit else 3.0)
	await _wait(0.2)


func _play_heal(d: Dictionary) -> void:
	var v: EntityView = _view(d["target"])
	if v == null:
		return
	v.set_hp(float(d["pv_after"]))
	_float_text(v, "+%d" % int(d["amount"]), Color(0.4, 1.0, 0.5), 30)
	_pillar(v.position + Vector2(0, 6), Color(0.55, 1.0, 0.65))
	v.tint_flash(Color(0.5, 1.0, 0.6), 0.45, 0.5)
	_status_mark(v, "regen", Color(0.55, 1.0, 0.65), true)
	_ring(v.position + Vector2(0, 6), Color(0.55, 1.0, 0.65), 8.0, 46.0, 0.5, 5.0)
	_burst(v.position + Vector2(0, -30), Color(0.4, 1.0, 0.55), 16, 80.0, 0.9, 5.0, 40.0, Vector2.UP, Vector2(0, -90))
	await _wait(0.15)


func _play_status(d: Dictionary) -> void:
	var v: EntityView = _view(d["target"])
	if v == null:
		return
	var col: Color = d.get("color", Color.WHITE)
	var good: bool = bool(d.get("good", false))
	_float_text(v, String(d["text"]), col, 22)
	_burst(v.position + Vector2(0, -40), col, 8, 70.0, 0.6, 4.0, 60.0, Vector2.UP, Vector2(0, -60 if good else 40))
	_status_mark(v, String(d.get("id", "")), col, good)
	v.tint_flash(col, 0.4, 0.4)
	v.queue_redraw()


func _play_death(d: Dictionary) -> void:
	var e: Dictionary = d["entity"]
	var v: EntityView = _view(e)
	if v == null:
		return
	Sfx.play("death")
	Sfx.buzz(45 if String(e.get("team", "")) == "enemy" else 90)
	v.set_hp(0.0)
	_burst(v.position + Vector2(0, -30), Color(0.85, 0.85, 0.85, 0.9), 24, 150.0, 0.7, 6.0)
	_shake(5.0)
	await v.die().finished
	views.erase(int(e["uid"]))
	v.queue_free()


func _play_summon(d: Dictionary) -> void:
	var e: Dictionary = d["entity"]
	var v: EntityView = _ensure_view(e)
	v.position = grid_to_screen(int(e["x"]), int(e["y"]))
	v.set_hp(float(e["current_pv"]))
	Sfx.play("cast")
	_rune(v.position, Color(0.8, 0.6, 1.0))
	_pillar(v.position + Vector2(0, 6), Color(0.8, 0.65, 1.0))
	_burst(v.position + Vector2(0, -20), Color(0.8, 0.6, 1.0), 22, 160.0, 0.6, 5.0)
	await v.pop_in().finished


# ═══════════════════════════════════════════════════════════════════════════
#  Effets visuels
# ═══════════════════════════════════════════════════════════════════════════

func _float_text(v: EntityView, text: String, col: Color, size: int) -> void:
	var off: float = v.next_float_offset()
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", size)
	label.add_theme_color_override("font_color", col)
	label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.95))
	label.add_theme_constant_override("outline_size", 8)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.custom_minimum_size = Vector2(240, 0)
	label.size = Vector2(240, 0)
	label.pivot_offset = Vector2(120, 20)
	label.position = v.position + Vector2(-120, -v.height - 36.0 - off)
	label.scale = Vector2(0.4, 0.4)
	_fx_layer.add_child(label)
	var tw: Tween = create_tween()
	tw.tween_property(label, "scale", Vector2(1.25, 1.25), 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.tween_property(label, "scale", Vector2.ONE, 0.08)
	tw.parallel().tween_property(label, "position:y", label.position.y - 50.0, 0.9)
	tw.tween_property(label, "modulate:a", 0.0, 0.3)
	tw.tween_callback(label.queue_free)


func _make_particles(col: Color, amount: int, life: float, speed: float, size: float) -> CPUParticles2D:
	var p := CPUParticles2D.new()
	p.texture = _glow_tex
	p.amount = amount
	p.lifetime = life
	p.initial_velocity_min = speed * 0.4
	p.initial_velocity_max = speed
	p.scale_amount_min = size * 0.04
	p.scale_amount_max = size * 0.09
	var g := Gradient.new()
	g.colors = PackedColorArray([Color(col.r, col.g, col.b, col.a), Color(col.r, col.g, col.b, 0.0)])
	g.offsets = PackedFloat32Array([0.0, 1.0])
	p.color_ramp = g
	var mat := CanvasItemMaterial.new()
	mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	p.material = mat
	return p


func _burst(pos: Vector2, col: Color, amount: int = 14, speed: float = 140.0, life: float = 0.5,
		size: float = 4.0, spread: float = 180.0, dir: Vector2 = Vector2.UP, gravity: Vector2 = Vector2(0, 260)) -> void:
	var p: CPUParticles2D = _make_particles(col, amount, life, speed, size)
	p.position = pos
	p.one_shot = true
	p.explosiveness = 0.95
	p.direction = dir
	p.spread = spread
	p.gravity = gravity
	_fx_layer.add_child(p)
	p.emitting = true
	get_tree().create_timer(life + 0.4).timeout.connect(p.queue_free)


func _shake(amp: float) -> void:
	_shake_amp = maxf(_shake_amp, amp)


func _process(delta: float) -> void:
	if _press_t >= 0.0:
		_press_t += delta / maxf(0.01, Engine.time_scale)
		if _press_t >= THREAT_HOLD:
			_press_t = -1.0
			var t: Dictionary = game_manager.entity_at(_press_cell) if _valid(_press_cell) else {}
			if not t.is_empty() and String(t.get("team", "")) == "enemy":
				show_threat(t)
	if _shake_amp > 0.0:
		var cam: Camera2D = get_viewport().get_camera_2d()
		if cam != null:
			cam.offset = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * _shake_amp
		_shake_amp = maxf(0.0, _shake_amp - delta * 40.0)
		if _shake_amp == 0.0 and cam != null:
			cam.offset = Vector2.ZERO
