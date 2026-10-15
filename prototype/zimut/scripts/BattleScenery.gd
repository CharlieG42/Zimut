class_name BattleScenery
extends Node2D
## BattleScenery.gd — Décor de contour de l'aire de bataille, façon Waven (sans le copier).
##
## L'île de combat est entourée, sur ses deux bords arrière, d'un REBORD SURÉLEVÉ à deux
## étages (terrasses) : blocs d'herbe/pierre/sable avec lèvre de gazon, sur lesquels sont posés
## des éléments de décor propres au biome (clôtures, haies, roseaux, blé, tonneaux, pins,
## cactus, piliers, torches...). Sous l'île, la falaise est prolongée (strates, racines, rochers
## pendants) et flotte dans la brume avec une ombre portée.
##
## Ce nœud dessine l'ARRIÈRE-PLAN du plateau (il doit être le premier enfant de GridManager).
## SceneryOver (lèvre/lianes devant les falaises) et SceneryAmbient (particules) complètent.
## Tout est dessiné par code, déterministe (graine) et léger : une trentaine de nœuds.

const HW := 64.0
const HH := 32.0
const CLIFF := 68.0   # profondeur de falaise des cases (Cell.DEPTH)

var _n: int = 8
var _biome: String = "Forêt"
var _seed: int = 1
var _items: Array[Node2D] = []
var _t: float = 0.0


# ═══════════════════════════════════════════════════════════════════════════
#  Palettes
# ═══════════════════════════════════════════════════════════════════════════

static func pal(biome: String) -> Dictionary:
	match biome:
		"Montagne":
			return {"top_a": Color(0.62, 0.69, 0.62), "top_b": Color(0.55, 0.62, 0.56), "lip": Color(0.88, 0.93, 0.97),
				"l_t": Color(0.56, 0.54, 0.54), "l_b": Color(0.38, 0.36, 0.40), "r_t": Color(0.44, 0.42, 0.44), "r_b": Color(0.28, 0.27, 0.31),
				"leaf": Color(0.26, 0.45, 0.36), "leaf_hi": Color(0.42, 0.62, 0.48), "mist": Color(0.80, 0.88, 0.96)}
		"Désert":
			return {"top_a": Color(0.88, 0.79, 0.52), "top_b": Color(0.82, 0.72, 0.46), "lip": Color(0.93, 0.85, 0.60),
				"l_t": Color(0.80, 0.60, 0.38), "l_b": Color(0.60, 0.42, 0.26), "r_t": Color(0.66, 0.47, 0.29), "r_b": Color(0.46, 0.31, 0.19),
				"leaf": Color(0.42, 0.62, 0.30), "leaf_hi": Color(0.62, 0.80, 0.42), "mist": Color(0.98, 0.90, 0.72)}
		"Donjon":
			return {"top_a": Color(0.46, 0.44, 0.54), "top_b": Color(0.40, 0.38, 0.48), "lip": Color(0.36, 0.34, 0.44),
				"l_t": Color(0.42, 0.40, 0.50), "l_b": Color(0.24, 0.22, 0.32), "r_t": Color(0.32, 0.30, 0.40), "r_b": Color(0.18, 0.16, 0.25),
				"leaf": Color(0.30, 0.42, 0.34), "leaf_hi": Color(0.44, 0.58, 0.46), "mist": Color(0.60, 0.55, 0.78)}
		_:
			return {"top_a": Color(0.54, 0.68, 0.32), "top_b": Color(0.47, 0.62, 0.28), "lip": Color(0.30, 0.52, 0.20),
				"l_t": Color(0.56, 0.40, 0.24), "l_b": Color(0.36, 0.25, 0.15), "r_t": Color(0.44, 0.31, 0.19), "r_b": Color(0.26, 0.18, 0.11),
				"leaf": Color(0.28, 0.55, 0.24), "leaf_hi": Color(0.52, 0.76, 0.34), "mist": Color(0.80, 0.90, 0.92)}


static var _tile_cache: Dictionary = {}

## Texture de sol (identique à celle des cases de l'aire de combat) pour le biome, ou null.
static func tile_tex(biome: String, idx: int) -> Texture2D:
	var prefix: String = ""
	match biome:
		"Forêt":
			prefix = "forest_ground"
		"Montagne":
			prefix = "mountain_ground"
		"Désert":
			prefix = "desert_ground"
	if prefix == "":
		return null
	var path: String = "res://assets/sprites/tiles/%s_%02d.svg" % [prefix, posmod(idx, 6) + 1]
	if not _tile_cache.has(path):
		_tile_cache[path] = load(path) as Texture2D
	return _tile_cache[path]


static func gts(gx: float, gy: float) -> Vector2:
	return Vector2((gx - gy) * HW, (gx + gy) * HH)


# ═══════════════════════════════════════════════════════════════════════════
#  Construction
# ═══════════════════════════════════════════════════════════════════════════

func configure(grid_size: int, biome: String, seed_value: int = 1) -> void:
	_n = grid_size
	_biome = biome
	_seed = seed_value
	for it: Node2D in _items:
		if is_instance_valid(it):
			it.queue_free()
	_items.clear()
	_build_rim()
	_place_features()
	queue_redraw()


## Rebord surélevé à deux terrasses sur les bords arrière (haut-gauche et haut-droit).
func _build_rim() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = _seed * 7919 + 13
	var cells: Array = []   # [gx, gy, level, h, end_left, end_right]
	# Terrasse 1 : bord haut-droit (gy = -1) et bord haut-gauche (gx = -1)
	for gx: int in range(-1, _n):
		cells.append([gx, -1, 1, 30.0 + rng.randf_range(0.0, 8.0), false, gx == _n - 1])
	for gy: int in range(0, _n):
		cells.append([-1, gy, 1, 30.0 + rng.randf_range(0.0, 8.0), gy == _n - 1, false])
	# Terrasse 2 (plus haute, derrière) : présence aléatoire pour casser la silhouette
	for gx: int in range(-2, _n - 1):
		if gx <= 1 or rng.randf() < 0.72:
			cells.append([gx, -2, 2, 66.0 + rng.randf_range(0.0, 10.0), false, false])
	for gy: int in range(-1, _n - 1):
		if gy <= 1 or rng.randf() < 0.72:
			cells.append([-2, gy, 2, 66.0 + rng.randf_range(0.0, 10.0), false, false])
	# Tri de profondeur : du plus loin au plus proche
	cells.sort_custom(func(a: Array, b: Array) -> bool:
		var ka: int = (int(a[0]) + int(a[1])) * 10 - int(a[2])
		var kb: int = (int(b[0]) + int(b[1])) * 10 - int(b[2])
		return ka < kb)
	var palette: Dictionary = pal(_biome)
	for c: Array in cells:
		var gx: int = c[0]
		var gy: int = c[1]
		var level: int = c[2]
		var h: float = c[3]
		var blk := SceneryItem.new()
		blk.kind = "block"
		blk.biome = _biome
		blk.h = h
		blk.palette = palette
		blk.seed_value = gx * 131 + gy * 313 + _seed
		blk.end_left = bool(c[4])
		blk.end_right = bool(c[5])
		blk.position = gts(gx, gy)
		add_child(blk)
		_items.append(blk)
		# Décor posé sur le bloc
		var count: int = rng.randi_range(1, 2) if level == 1 else rng.randi_range(0, 2)
		var ground: Vector2 = gts(gx, gy) + Vector2(0, -h)
		var edge_axis: int = 0   # 1 : le long de l'axe x (bord haut-droit) ; 2 : le long de l'axe y
		if gy == -1 and level == 1:
			edge_axis = 1
		elif gx == -1 and level == 1:
			edge_axis = 2
		var placed_fence: bool = false
		# Rivière : la terrasse haut-gauche (gx = -1) porte un cours d'eau qui tombe en cascade au bout
		if _biome == "Forêt" and level == 1 and gx == -1 and gy >= 3:
			blk.water = true
			blk.cascade = gy == _n - 1
			count = 0
		for i: int in range(count):
			var kind: String = _pick_prop(rng, level, edge_axis, placed_fence)
			if kind == "":
				continue
			var p := SceneryItem.new()
			p.kind = kind
			p.biome = _biome
			p.palette = palette
			p.seed_value = rng.randi()
			p.h = h
			var off := Vector2(rng.randf_range(-22.0, 22.0), rng.randf_range(-9.0, 9.0))
			if kind.begins_with("fence"):
				placed_fence = true
				off = Vector2(-32.0, 16.0) if edge_axis == 1 else Vector2(32.0, 16.0)
				p.kind = "fence_x" if edge_axis == 1 else "fence_y"
			elif kind == "wheat":
				off = Vector2.ZERO
			p.position = ground + off
			p.sway = kind in ["reeds", "wheat", "tree", "pine", "hedge", "palm", "grass"]
			p.phase = rng.randf() * TAU
			add_child(p)
			_items.append(p)


## Éléments « de scénario » de la forêt : arche en ruine au fond, rivière + cascade sur le bord gauche.
func _add_feature(kind: String, gx: int, gy: int, h: float, off: Vector2 = Vector2.ZERO) -> void:
	var p := SceneryItem.new()
	p.kind = kind
	p.biome = _biome
	p.palette = pal(_biome)
	p.seed_value = gx * 17 + gy * 29 + _seed
	p.h = h
	p.position = gts(gx, gy) + Vector2(0, -h) + off
	p.sway = false
	add_child(p)
	_items.append(p)


func _place_features() -> void:
	# Chaque biome a son monument signature sur la terrasse du fond (bord haut),
	# plus un élément secondaire sur le rebord gauche — même logique que la Forêt.
	match _biome:
		"Forêt":
			_add_feature("ruin_arch", 1, -2, 68.0, Vector2(0, 0))
			_add_feature("ruin_wall", -1, 1, 34.0, Vector2(20, 4))
		"Montagne":
			_add_feature("ice_portal", 1, -2, 68.0, Vector2(0, 0))
			_add_feature("cairn", -1, 1, 34.0, Vector2(20, 4))
		"Désert":
			_add_feature("obelisk", 1, -2, 68.0, Vector2(0, 0))
			_add_feature("well", -1, 1, 34.0, Vector2(20, 4))
		_:
			pass


func _pick_prop(rng: RandomNumberGenerator, level: int, edge_axis: int, placed_fence: bool) -> String:
	var table: Array = []
	match _biome:
		"Montagne":
			table = [["pine", 5], ["rock_snow", 4], ["crystal", 2], ["stakes", 2], ["snow_mound", 3], ["log", 2], ["pine", 2]]
		"Désert":
			table = [["cactus", 5], ["sand_pillar", 4], ["dry_grass", 4], ["bones", 2], ["jar", 2], ["palm", 2], ["rock", 2]]
		"Donjon":
			table = [["stone_pillar", 4], ["torch", 5], ["crate", 3], ["banner", 2], ["rubble", 4], ["bones", 2], ["chains", 2]]
		_:
			table = [["hedge", 5], ["reeds", 3], ["flowers", 4], ["tree", 3], ["big_tree", 3 if level == 2 else 1], ["rock", 2],
				["mushrooms", 3], ["stump", 3], ["log_pile", 2], ["ruin_wall", 3], ["standing_stone", 2], ["wheat", 1], ["grass", 3]]
			if level == 1 and edge_axis != 0 and not placed_fence and rng.randf() < 0.6:
				return "fence"
	var total: int = 0
	for e: Array in table:
		total += int(e[1])
	var r: int = rng.randi_range(0, total - 1)
	for e: Array in table:
		r -= int(e[1])
		if r < 0:
			return String(e[0])
	return ""


func _process(delta: float) -> void:
	_t += delta
	for it: Node2D in _items:
		if is_instance_valid(it) and it.get("sway") == true:
			it.rotation = sin(_t * 1.25 + float(it.get("phase"))) * 0.022


# ═══════════════════════════════════════════════════════════════════════════
#  Dessin du fond de l'île (sous les cases)
# ═══════════════════════════════════════════════════════════════════════════

func _draw() -> void:
	var p: Dictionary = pal(_biome)
	var n: float = float(_n)
	var left_v: Vector2 = gts(0, n - 1) + Vector2(-HW, 0)    # sommet gauche de la dernière rangée
	var bottom_v: Vector2 = gts(n - 1, n - 1) + Vector2(0, HH)
	var right_v: Vector2 = gts(n - 1, 0) + Vector2(HW, 0)
	# Ombre portée de l'île sur l'eau + brume dessous
	for i: int in range(5):
		var k: float = float(i) / 4.0
		draw_set_transform(Vector2(0, bottom_v.y + CLIFF + 120.0), 0.0, Vector2(1.0, 0.26))
		draw_circle(Vector2.ZERO, 640.0 - k * 150.0, Color(0.04, 0.07, 0.12, 0.07 + 0.05 * k))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	# Prolongement de la falaise (strates, bas déchiqueté) : face gauche puis face droite
	_lower_cliff(left_v + Vector2(0, CLIFF), bottom_v + Vector2(0, CLIFF), p["l_t"], p["l_b"], 11, true)
	_lower_cliff(bottom_v + Vector2(0, CLIFF), right_v + Vector2(0, CLIFF), p["r_t"], p["r_b"], 29, false)
	# Brume qui monte autour du pied de l'île
	var mist: Color = p["mist"]
	for i: int in range(7):
		var mx: float = lerpf(left_v.x, right_v.x, float(i) / 6.0)
		var my: float = bottom_v.y + CLIFF + 30.0 + sin(float(i) * 1.9) * 12.0 - absf(float(i) - 3.0) * 6.0
		draw_set_transform(Vector2(mx, my), 0.0, Vector2(1.0, 0.28))
		draw_circle(Vector2.ZERO, 130.0, Color(mist.r, mist.g, mist.b, 0.16))
		draw_circle(Vector2.ZERO, 80.0, Color(mist.r, mist.g, mist.b, 0.14))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _lower_cliff(a: Vector2, b: Vector2, c_top: Color, c_bot: Color, salt: int, left_face: bool) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = _seed * 31 + salt
	var steps: int = 14
	var top_pts := PackedVector2Array()
	var bot_pts := PackedVector2Array()
	for i: int in range(steps + 1):
		var f: float = float(i) / float(steps)
		var pt: Vector2 = a.lerp(b, f)
		top_pts.append(pt)
		var drop: float = 34.0 + rng.randf_range(0.0, 46.0) + sin(f * PI) * 14.0
		bot_pts.append(pt + Vector2(0, drop))
	# Polygone par quadrilatères (dégradé vertical, strates)
	for i: int in range(steps):
		var q := PackedVector2Array([top_pts[i], top_pts[i + 1], bot_pts[i + 1], bot_pts[i]])
		draw_polygon(q, PackedColorArray([c_top, c_top, c_bot.darkened(0.15), c_bot.darkened(0.15)]))
	for k: int in range(3):
		var f2: float = 0.28 + 0.25 * float(k)
		var strat_col: Color = Color(0, 0, 0, 0.16)
		var line := PackedVector2Array()
		for i: int in range(steps + 1):
			var d: float = (bot_pts[i].y - top_pts[i].y) * f2 + sin(float(i) * 1.7 + float(k)) * 3.0
			line.append(top_pts[i] + Vector2(0, d))
		draw_polyline(line, strat_col, 2.2, true)
	# Pierres encastrées + racines pendantes
	for i: int in range(5):
		var f3: float = rng.randf_range(0.08, 0.92)
		var pos: Vector2 = a.lerp(b, f3) + Vector2(0, rng.randf_range(10.0, 44.0))
		var r: float = rng.randf_range(4.0, 9.0)
		draw_set_transform(pos, 0.0, Vector2(1.0, 0.75))
		draw_circle(Vector2.ZERO, r, c_bot.lightened(0.18))
		draw_circle(Vector2(-r * 0.25, -r * 0.25), r * 0.45, c_top.lightened(0.15))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	for i: int in range(4):
		var f4: float = rng.randf_range(0.05, 0.95)
		var rt: Vector2 = bot_pts[int(f4 * float(steps))]
		var len_: float = rng.randf_range(16.0, 34.0)
		var rp := PackedVector2Array([rt + Vector2(0, -10), rt + Vector2(3, 0), rt + Vector2(-2, len_ * 0.6), rt + Vector2(1, len_)])
		draw_polyline(rp, Color(0.30, 0.20, 0.12, 0.85), 3.0, true)
	# Ligne d'ombre au bas de la falaise
	draw_polyline(bot_pts, Color(0, 0, 0, 0.18), 3.0, true)


# ═══════════════════════════════════════════════════════════════════════════
#  Nœud d'élément (bloc ou décor)
# ═══════════════════════════════════════════════════════════════════════════

class SceneryItem extends Node2D:
	var kind: String = "block"
	var biome: String = "Forêt"
	var palette: Dictionary = {}
	var h: float = 30.0
	var seed_value: int = 0
	var sway: bool = false
	var phase: float = 0.0
	var end_left: bool = false
	var end_right: bool = false
	var water: bool = false
	var cascade: bool = false
	var _flicker: float = 0.0

	func _ready() -> void:
		set_process(kind == "torch" or water)

	func _process(delta: float) -> void:
		_flicker += delta
		queue_redraw()

	func _draw() -> void:
		var rng := RandomNumberGenerator.new()
		rng.seed = seed_value
		match kind:
			"block":
				BattleScenery.draw_block(self, h, palette, biome, rng, end_left, end_right)
				if water:
					BattleScenery.draw_water(self, h, cascade, _flicker)
			_:
				BattleScenery.draw_prop(self, kind, palette, biome, rng, _flicker)


# ═══════════════════════════════════════════════════════════════════════════
#  Bloc surélevé
# ═══════════════════════════════════════════════════════════════════════════

static func draw_block(ci: CanvasItem, h: float, p: Dictionary, biome: String, rng: RandomNumberGenerator,
		end_left: bool, end_right: bool) -> void:
	var top_a: Color = p["top_a"]
	var top_b: Color = p["top_b"]
	var lip: Color = p["lip"]
	var ext_l: float = CLIFF + 6.0 if end_left else 0.0
	var ext_r: float = CLIFF + 6.0 if end_right else 0.0
	# Face gauche (sud-ouest, éclairée) et droite (sud-est, plus sombre)
	var lt: Color = p["l_t"]
	var lb: Color = p["l_b"]
	var rt: Color = p["r_t"]
	var rb: Color = p["r_b"]
	ci.draw_polygon(PackedVector2Array([Vector2(-HW, -h), Vector2(0, HH - h), Vector2(0, HH + ext_l), Vector2(-HW, ext_l)]),
		PackedColorArray([lt, lt, lb, lb]))
	ci.draw_polygon(PackedVector2Array([Vector2(0, HH - h), Vector2(HW, -h), Vector2(HW, ext_r), Vector2(0, HH + ext_r)]),
		PackedColorArray([rt, rt, rb, rb]))
	# Strates / cailloux sur les faces
	var strat: Color = Color(0, 0, 0, 0.14)
	var y1: float = -h * 0.45
	ci.draw_polyline(PackedVector2Array([Vector2(-HW, y1), Vector2(0, HH + y1)]), strat, 2.0, true)
	ci.draw_polyline(PackedVector2Array([Vector2(0, HH + y1), Vector2(HW, y1)]), strat, 2.0, true)
	for i: int in range(2):
		var fx: float = rng.randf_range(0.15, 0.85)
		var sp := Vector2(-HW * (1.0 - fx), HH * fx - h * 0.5 + rng.randf_range(-4.0, 6.0))
		ci.draw_circle(sp, rng.randf_range(2.5, 5.0), lb.lightened(0.2))
	# Lèvre de gazon (festonnée) en haut des deux faces
	_lip_edge(ci, Vector2(-HW, -h), Vector2(0, HH - h), lip, rng, biome)
	_lip_edge(ci, Vector2(0, HH - h), Vector2(HW, -h), lip.darkened(0.12), rng, biome)
	# Dessus
	var top := PackedVector2Array([Vector2(0, -HH - h), Vector2(HW, -h), Vector2(0, HH - h), Vector2(-HW, -h)])
	var tc: Color = top_a if (int(absf(float(rng.seed))) % 2 == 0) else top_b
	var tile: Texture2D = tile_tex(biome, int(absi(rng.seed) % 6))
	if tile != null:
		# Même texture de sol que l'aire de combat : le rebord et le plateau forment un tout
		ci.draw_colored_polygon(top, tc)
		ci.draw_texture_rect(tile, Rect2(-HW, -HH - h, HW * 2.0, HH * 2.0), false)
	else:
		ci.draw_colored_polygon(top, tc)
	ci.draw_colored_polygon(PackedVector2Array([Vector2(0, -HH * 0.62 - h), Vector2(HW * 0.62, -h), Vector2(0, HH * 0.62 - h), Vector2(-HW * 0.62, -h)]),
		Color(1.0, 0.98, 0.8, 0.07))
	# Touffes / détails du dessus
	var tuft: Color = tc.darkened(0.22)
	for i: int in range(rng.randi_range(5, 9) if tile == null else 2):
		var pp := Vector2(rng.randf_range(-0.75, 0.75) * HW, rng.randf_range(-0.75, 0.75) * HH - h)
		if absf(pp.x) / HW + absf(pp.y + h) / HH < 0.85:
			if biome == "Montagne":
				ci.draw_circle(pp, rng.randf_range(2.0, 4.5), Color(0.95, 0.97, 1.0, 0.8))
			elif biome == "Donjon":
				ci.draw_line(pp, pp + Vector2(rng.randf_range(-6.0, 6.0), rng.randf_range(-1.0, 1.0)), Color(0, 0, 0, 0.18), 1.5)
			else:
				var sw: float = rng.randf_range(-3.0, 3.0)
				ci.draw_line(pp, pp + Vector2(sw, -rng.randf_range(3.0, 6.0)), tuft, 1.6)
				ci.draw_line(pp + Vector2(2, 0), pp + Vector2(2 + sw * 0.6, -4.0), tuft.lightened(0.22), 1.3)
	# Arêtes lumineuses / ombrées
	ci.draw_line(Vector2(-HW, -h), Vector2(0, -HH - h), Color(1, 1, 0.9, 0.28), 2.0)
	ci.draw_line(Vector2(0, -HH - h), Vector2(HW, -h), Color(1, 1, 0.9, 0.18), 2.0)
	ci.draw_polyline(PackedVector2Array([Vector2(0, -HH - h), Vector2(HW, -h), Vector2(0, HH - h), Vector2(-HW, -h), Vector2(0, -HH - h)]),
		Color(0.08, 0.14, 0.06, 0.25), 1.4, true)


## Cours d'eau posé sur un bloc de rebord (légèrement en creux) ; cascade au bout de l'île.
static func draw_water(ci: CanvasItem, h: float, cascade: bool, t: float) -> void:
	var dep: float = 5.0
	var top := PackedVector2Array([Vector2(0, -HH - h + dep), Vector2(HW, -h + dep), Vector2(0, HH - h + dep), Vector2(-HW, -h + dep)])
	ci.draw_colored_polygon(top, Color(0.20, 0.55, 0.78))
	ci.draw_colored_polygon(PackedVector2Array([Vector2(0, -HH * 0.78 - h + dep), Vector2(HW * 0.78, -h + dep), Vector2(0, HH * 0.78 - h + dep), Vector2(-HW * 0.78, -h + dep)]), Color(0.36, 0.76, 0.92, 0.85))
	# rides qui avancent dans le sens du courant (axe y croissant : vers le bas-gauche)
	for i: int in range(3):
		var f: float = fposmod(t * 0.35 + float(i) * 0.33, 1.0)
		var a := Vector2(HW * 0.5, -h + dep - HH * 0.5) + Vector2(-HW, HH) * f * 0.9
		ci.draw_line(a + Vector2(-9, -4.5), a + Vector2(9, 4.5), Color(1, 1, 1, 0.55 * sin(f * PI)), 2.0, true)
	# berges de pierre mousseuse
	ci.draw_polyline(PackedVector2Array([Vector2(0, -HH - h + dep), Vector2(HW, -h + dep), Vector2(0, HH - h + dep), Vector2(-HW, -h + dep), Vector2(0, -HH - h + dep)]), Color(0.16, 0.22, 0.12, 0.5), 2.0, true)
	if cascade:
		# chute : traînées d'eau le long de la face gauche + écume + embruns
		for i: int in range(6):
			var fx: float = 0.1 + 0.16 * float(i)
			var x0: float = -HW + fx * HW
			var y0: float = HH * fx - h + dep
			var len_: float = h + CLIFF + 40.0
			var ph: float = fposmod(t * 1.4 + float(i) * 0.37, 1.0)
			ci.draw_line(Vector2(x0, y0), Vector2(x0, y0 + len_), Color(0.55, 0.85, 1.0, 0.7), 5.0, true)
			ci.draw_line(Vector2(x0 + 1.0, y0 + len_ * ph), Vector2(x0 + 1.0, y0 + len_ * ph + 18.0), Color(1, 1, 1, 0.85), 3.0, true)
		var foot := Vector2(-HW * 0.45, HH * 0.55 + CLIFF + 36.0)
		for i: int in range(5):
			var a2: float = fposmod(t * 0.9 + float(i) * 0.21, 1.0)
			ci.draw_circle(foot + Vector2(sin(float(i) * 2.1) * 24.0, -a2 * 22.0), 9.0 + a2 * 8.0, Color(1, 1, 1, 0.26 * (1.0 - a2)))
		ci.draw_set_transform(foot, 0.0, Vector2(1.0, 0.35))
		ci.draw_circle(Vector2.ZERO, 40.0, Color(1, 1, 1, 0.3))
		ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


static func _lip_edge(ci: CanvasItem, a: Vector2, b: Vector2, col: Color, rng: RandomNumberGenerator, biome: String) -> void:
	var n: int = 7
	var band := PackedVector2Array([a, b, b + Vector2(0, 7), a + Vector2(0, 7)])
	ci.draw_colored_polygon(band, col.darkened(0.08))
	for i: int in range(n):
		var f: float = (float(i) + 0.5) / float(n)
		var pt: Vector2 = a.lerp(b, f)
		var r: float = rng.randf_range(4.0, 7.5)
		ci.draw_circle(pt + Vector2(0, 6), r, col)
		ci.draw_circle(pt + Vector2(-r * 0.2, 5.0 - r * 0.2), r * 0.45, col.lightened(0.18))


# ═══════════════════════════════════════════════════════════════════════════
#  Ombres et petits utilitaires
# ═══════════════════════════════════════════════════════════════════════════

## Ombre douce portée vers la droite (lumière en haut à gauche, comme dans Waven).
static func soft_shadow(ci: CanvasItem, rx: float, a: float = 0.26) -> void:
	for i: int in range(3):
		var k: float = 1.0 - float(i) * 0.28
		ci.draw_set_transform(Vector2(rx * 0.42, 3.0), 0.0, Vector2(1.0, 0.30))
		ci.draw_circle(Vector2.ZERO, rx * k, Color(0.03, 0.06, 0.08, a * (0.5 + 0.25 * float(i))))
	ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


static func blob(ci: CanvasItem, c: Vector2, r: float, col: Color, hi: Color) -> void:
	ci.draw_circle(c + Vector2(0, 1.5), r + 1.5, col.darkened(0.45))
	ci.draw_circle(c, r, col)
	ci.draw_circle(c + Vector2(-r * 0.3, -r * 0.34), r * 0.55, hi)
	ci.draw_circle(c + Vector2(-r * 0.38, -r * 0.42), r * 0.2, Color(1, 1, 1, 0.25))


static func _bar(ci: CanvasItem, a: Vector2, b: Vector2, w: float, col: Color) -> void:
	ci.draw_line(a, b, col.darkened(0.45), w + 2.5, true)
	ci.draw_line(a, b, col, w, true)
	ci.draw_line(a + Vector2(-0.8, -0.8), b + Vector2(-0.8, -0.8), col.lightened(0.28), maxf(1.0, w * 0.3), true)


# ═══════════════════════════════════════════════════════════════════════════
#  Éléments de décor (origine = point d'appui au sol)
# ═══════════════════════════════════════════════════════════════════════════

static func draw_prop(ci: CanvasItem, kind: String, p: Dictionary, biome: String, rng: RandomNumberGenerator, t: float) -> void:
	var leaf: Color = p["leaf"]
	var leaf_hi: Color = p["leaf_hi"]
	match kind:
		"fence_x", "fence_y":
			var dir := Vector2(HW, HH) * 0.5 if kind == "fence_x" else Vector2(HW, -HH) * 0.5
			var wood := Color(0.62, 0.45, 0.28)
			soft_shadow(ci, 34.0, 0.22)
			var posts: Array[Vector2] = [-dir, Vector2.ZERO, dir]
			_bar(ci, -dir + Vector2(0, -20), dir + Vector2(0, -20), 4.0, wood.lightened(0.05))
			_bar(ci, -dir + Vector2(0, -10), dir + Vector2(0, -10), 4.0, wood)
			for pp: Vector2 in posts:
				_bar(ci, pp, pp + Vector2(0, -28), 6.0, wood.darkened(0.08))
				ci.draw_circle(pp + Vector2(0, -29), 3.4, wood.lightened(0.12))
		"hedge":
			soft_shadow(ci, 30.0)
			for i: int in range(4):
				var o := Vector2(-18.0 + float(i) * 12.0 + rng.randf_range(-3.0, 3.0), -10.0 - rng.randf_range(0.0, 8.0))
				blob(ci, o, rng.randf_range(11.0, 15.0), leaf, leaf_hi)
			blob(ci, Vector2(0, -26), 12.0, leaf.lightened(0.04), leaf_hi)
			for i: int in range(3):
				ci.draw_circle(Vector2(rng.randf_range(-20.0, 20.0), rng.randf_range(-30.0, -8.0)), 2.2, Color(1.0, 0.85, 0.9) if i % 2 == 0 else Color(1, 1, 0.8))
		"reeds":
			soft_shadow(ci, 22.0, 0.2)
			for i: int in range(4):
				var bx: float = -14.0 + float(i) * 9.0
				var hh_: float = rng.randf_range(54.0, 92.0)
				var lean: float = rng.randf_range(-9.0, 9.0)
				var tip := Vector2(bx + lean, -hh_)
				var blade := PackedVector2Array([Vector2(bx - 3.5, 0), Vector2(bx + lean * 0.5 - 6.0, -hh_ * 0.55), tip, Vector2(bx + lean * 0.5 + 6.0, -hh_ * 0.55), Vector2(bx + 3.5, 0)])
				ci.draw_colored_polygon(blade, leaf.darkened(0.1))
				ci.draw_colored_polygon(PackedVector2Array([Vector2(bx - 1.0, 0), Vector2(bx + lean * 0.5 - 2.0, -hh_ * 0.55), tip, Vector2(bx + lean * 0.5 + 2.5, -hh_ * 0.5)]), leaf_hi)
				ci.draw_circle(tip + Vector2(0, 5), 4.0, Color(0.95, 0.70, 0.30, 0.9))
		"flowers":
			var cols: Array[Color] = [Color(1, 1, 1), Color(0.75, 0.82, 1.0), Color(1.0, 0.75, 0.85), Color(1.0, 0.92, 0.45)]
			for i: int in range(7):
				var fp := Vector2(rng.randf_range(-22.0, 22.0), rng.randf_range(-8.0, 8.0))
				ci.draw_line(fp, fp + Vector2(0, -8), leaf.darkened(0.2), 1.6)
				ci.draw_circle(fp + Vector2(0, -9), 3.4, cols[rng.randi() % cols.size()])
				ci.draw_circle(fp + Vector2(0, -9), 1.2, Color(1, 0.8, 0.2))
		"wheat":
			soft_shadow(ci, 40.0, 0.2)
			var gold: Color = Color(0.93, 0.70, 0.36)
			for row: int in range(5):
				for i: int in range(7):
					var wx: float = -34.0 + float(i) * 11.0 + float(row % 2) * 5.0
					var wy: float = -14.0 + float(row) * 6.5 - absf(wx) * 0.22
					var hh2: float = 26.0 + rng.randf_range(0.0, 8.0)
					ci.draw_line(Vector2(wx, wy), Vector2(wx + rng.randf_range(-2.0, 2.0), wy - hh2), gold.darkened(0.12 + 0.03 * float(row)), 3.0, true)
					ci.draw_circle(Vector2(wx, wy - hh2), 2.4, gold.lightened(0.1))
		"barrel":
			soft_shadow(ci, 18.0)
			var wc := Color(0.62, 0.42, 0.24)
			ci.draw_rect(Rect2(-12, -26, 24, 26), wc.darkened(0.3))
			ci.draw_polygon(PackedVector2Array([Vector2(-12, -26), Vector2(12, -26), Vector2(14, -13), Vector2(12, 0), Vector2(-12, 0), Vector2(-14, -13)]),
				PackedColorArray([wc, wc, wc.darkened(0.12), wc.darkened(0.2), wc.darkened(0.2), wc.darkened(0.12)]))
			ci.draw_line(Vector2(-13, -19), Vector2(13, -19), Color(0.28, 0.2, 0.14), 2.4)
			ci.draw_line(Vector2(-13, -7), Vector2(13, -7), Color(0.28, 0.2, 0.14), 2.4)
			ci.draw_set_transform(Vector2(0, -26), 0.0, Vector2(1.0, 0.45))
			ci.draw_circle(Vector2.ZERO, 12.0, wc.lightened(0.15))
			ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		"crate":
			soft_shadow(ci, 20.0)
			var cc := Color(0.50, 0.37, 0.26) if biome == "Donjon" else Color(0.66, 0.50, 0.30)
			ci.draw_rect(Rect2(-14, -26, 28, 26), cc.darkened(0.25))
			ci.draw_rect(Rect2(-12, -24, 24, 22), cc)
			ci.draw_line(Vector2(-12, -24), Vector2(12, -2), cc.darkened(0.3), 2.4)
			ci.draw_line(Vector2(12, -24), Vector2(-12, -2), cc.darkened(0.3), 2.4)
		"mushrooms":
			soft_shadow(ci, 18.0, 0.2)
			if biome == "Forêt":
				ci.draw_circle(Vector2(0, -8), 20.0, Color(1.0, 0.7, 0.55, 0.10))
			for i: int in range(3):
				var mx: float = -10.0 + float(i) * 10.0
				var s: float = 0.7 + 0.3 * float(i % 2)
				ci.draw_rect(Rect2(mx - 2.5 * s, -9 * s, 5 * s, 9 * s), Color(0.96, 0.92, 0.82))
				ci.draw_set_transform(Vector2(mx, -9 * s), 0.0, Vector2(1.0, 0.7))
				ci.draw_circle(Vector2.ZERO, 8.0 * s, Color(0.85, 0.22, 0.2))
				ci.draw_circle(Vector2(-2.5 * s, -2.0), 1.6 * s, Color(1, 0.95, 0.9))
				ci.draw_circle(Vector2(2.5 * s, 0.5), 1.3 * s, Color(1, 0.95, 0.9))
				ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		"grass":
			for i: int in range(9):
				var gx: float = rng.randf_range(-18.0, 18.0)
				var gh: float = rng.randf_range(10.0, 22.0)
				ci.draw_line(Vector2(gx, 0), Vector2(gx + rng.randf_range(-5.0, 5.0), -gh), leaf if i % 2 == 0 else leaf_hi, 2.4, true)
		"tree":
			soft_shadow(ci, 38.0, 0.32)
			var tr := Color(0.46, 0.32, 0.20)
			ci.draw_polygon(PackedVector2Array([Vector2(-9, 0), Vector2(-5, -48), Vector2(5, -48), Vector2(10, 0)]), PackedColorArray([tr.lightened(0.1), tr, tr.darkened(0.1), tr.darkened(0.2)]))
			ci.draw_line(Vector2(-2, -42), Vector2(-3, -6), Color(0, 0, 0, 0.2), 2.0)
			ci.draw_line(Vector2(0, -34), Vector2(-14, -50), tr.darkened(0.1), 5.0, true)
			ci.draw_set_transform(Vector2(0, -52), 0.0, Vector2(1.0, 0.5))
			ci.draw_circle(Vector2.ZERO, 34.0, leaf.darkened(0.45))
			ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			blob(ci, Vector2(-17, -56), 19.0, leaf.darkened(0.1), leaf_hi)
			blob(ci, Vector2(17, -58), 18.0, leaf.darkened(0.08), leaf_hi)
			blob(ci, Vector2(-4, -50), 16.0, leaf.darkened(0.05), leaf_hi)
			blob(ci, Vector2(0, -76), 23.0, leaf, leaf_hi)
			for lc: Array in [[-10.0, -84.0], [8.0, -80.0], [-22.0, -62.0], [18.0, -66.0], [0.0, -66.0]]:
				ci.draw_circle(Vector2(float(lc[0]), float(lc[1])), 3.2, leaf_hi.lightened(0.15))
		"palm":
			soft_shadow(ci, 26.0, 0.24)
			_bar(ci, Vector2(0, 0), Vector2(6, -58), 7.0, Color(0.62, 0.46, 0.28))
			for i: int in range(6):
				var ang: float = -PI * 0.5 + (float(i) - 2.5) * 0.52
				var tip := Vector2(6, -58) + Vector2(cos(ang), sin(ang)) * 36.0 + Vector2(0, 10)
				ci.draw_line(Vector2(6, -58), tip, leaf.darkened(0.1), 6.0, true)
				ci.draw_line(Vector2(6, -58), tip, leaf_hi, 2.6, true)
		"rock", "rock_snow", "rubble":
			soft_shadow(ci, 30.0, 0.28)
			var rc: Color = Color(0.58, 0.60, 0.58) if biome != "Désert" else Color(0.74, 0.58, 0.40)
			if biome == "Donjon":
				rc = Color(0.44, 0.42, 0.52)
			var pts := PackedVector2Array([Vector2(-26, 0), Vector2(-22, -16), Vector2(-8, -28), Vector2(10, -26), Vector2(24, -14), Vector2(28, 0)])
			ci.draw_colored_polygon(pts, rc.darkened(0.15))
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-26, 0), Vector2(-22, -16), Vector2(-8, -28), Vector2(0, -12), Vector2(-6, 0)]), rc.lightened(0.12))
			ci.draw_polyline(PackedVector2Array([Vector2(-26, 0), Vector2(-22, -16), Vector2(-8, -28), Vector2(10, -26), Vector2(24, -14), Vector2(28, 0)]), Color(0.1, 0.1, 0.12, 0.45), 1.6, true)
			if kind == "rock_snow" or biome == "Montagne":
				ci.draw_colored_polygon(PackedVector2Array([Vector2(-22, -16), Vector2(-8, -28), Vector2(10, -26), Vector2(20, -17), Vector2(4, -20), Vector2(-8, -17)]), Color(0.96, 0.98, 1.0))
			elif biome == "Forêt":
				ci.draw_circle(Vector2(-12, -22), 6.0, leaf.darkened(0.05))
				ci.draw_circle(Vector2(-4, -26), 5.0, leaf_hi)
		"pine":
			soft_shadow(ci, 30.0, 0.28)
			_bar(ci, Vector2(0, 0), Vector2(0, -22), 7.0, Color(0.38, 0.28, 0.20))
			for i: int in range(4):
				var w: float = 30.0 - float(i) * 6.0
				var y0: float = -18.0 - float(i) * 20.0
				ci.draw_colored_polygon(PackedVector2Array([Vector2(-w, y0), Vector2(0, y0 - 34.0), Vector2(w, y0)]), leaf.darkened(0.12))
				ci.draw_colored_polygon(PackedVector2Array([Vector2(-w, y0), Vector2(0, y0 - 34.0), Vector2(-2, y0 - 2.0)]), leaf_hi.darkened(0.1))
				ci.draw_colored_polygon(PackedVector2Array([Vector2(-w * 0.55, y0 - 15.0), Vector2(0, y0 - 34.0), Vector2(w * 0.55, y0 - 15.0), Vector2(0, y0 - 11.0)]), Color(0.96, 0.98, 1.0, 0.92))
		"crystal":
			soft_shadow(ci, 20.0, 0.2)
			for i: int in range(3):
				var cx: float = -10.0 + float(i) * 10.0
				var ch: float = 22.0 + float(i % 2) * 16.0
				ci.draw_colored_polygon(PackedVector2Array([Vector2(cx - 6, 0), Vector2(cx - 4, -ch), Vector2(cx + 1, -ch - 8), Vector2(cx + 6, -ch), Vector2(cx + 7, 0)]), Color(0.62, 0.86, 1.0, 0.92))
				ci.draw_colored_polygon(PackedVector2Array([Vector2(cx - 6, 0), Vector2(cx - 4, -ch), Vector2(cx + 1, -ch - 8), Vector2(cx, -4)]), Color(0.9, 0.98, 1.0, 0.85))
		"stakes":
			soft_shadow(ci, 22.0, 0.2)
			for i: int in range(3):
				var sx: float = -14.0 + float(i) * 14.0
				_bar(ci, Vector2(sx, 0), Vector2(sx + 2.0, -30.0 - float(i % 2) * 8.0), 5.0, Color(0.5, 0.38, 0.26))
			ci.draw_line(Vector2(-14, -22), Vector2(14, -20), Color(0.8, 0.7, 0.5), 2.0, true)
		"snow_mound":
			ci.draw_set_transform(Vector2(0, -2), 0.0, Vector2(1.0, 0.45))
			ci.draw_circle(Vector2(-8, 0), 22.0, Color(0.88, 0.93, 0.98))
			ci.draw_circle(Vector2(10, 2), 18.0, Color(0.96, 0.98, 1.0))
			ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		"log":
			soft_shadow(ci, 24.0, 0.22)
			_bar(ci, Vector2(-20, -6), Vector2(20, -2), 11.0, Color(0.50, 0.36, 0.24))
			ci.draw_circle(Vector2(20, -2), 5.5, Color(0.80, 0.66, 0.46))
		"cactus":
			soft_shadow(ci, 22.0, 0.22)
			var cg: Color = Color(0.36, 0.62, 0.34)
			ci.draw_line(Vector2(0, 0), Vector2(0, -46), cg.darkened(0.4), 15.0, true)
			ci.draw_line(Vector2(0, 0), Vector2(0, -46), cg, 11.5, true)
			ci.draw_line(Vector2(0, -22), Vector2(-14, -22), cg.darkened(0.4), 10.0, true)
			ci.draw_line(Vector2(0, -22), Vector2(-14, -22), cg, 7.0, true)
			ci.draw_line(Vector2(-14, -22), Vector2(-14, -36), cg.darkened(0.4), 10.0, true)
			ci.draw_line(Vector2(-14, -22), Vector2(-14, -36), cg, 7.0, true)
			ci.draw_line(Vector2(0, -30), Vector2(13, -30), cg.darkened(0.4), 10.0, true)
			ci.draw_line(Vector2(0, -30), Vector2(13, -30), cg, 7.0, true)
			ci.draw_line(Vector2(13, -30), Vector2(13, -42), cg.darkened(0.4), 10.0, true)
			ci.draw_line(Vector2(13, -30), Vector2(13, -42), cg, 7.0, true)
			ci.draw_line(Vector2(-2, -8), Vector2(-2, -40), cg.lightened(0.18), 2.0, true)
			ci.draw_circle(Vector2(0, -48), 3.2, Color(1.0, 0.55, 0.65))
		"sand_pillar":
			soft_shadow(ci, 26.0, 0.26)
			var sc := Color(0.82, 0.64, 0.42)
			ci.draw_polygon(PackedVector2Array([Vector2(-16, 0), Vector2(-12, -52), Vector2(-4, -64), Vector2(8, -60), Vector2(14, -50), Vector2(18, 0)]),
				PackedColorArray([sc.lightened(0.05), sc, sc.lightened(0.1), sc.darkened(0.1), sc.darkened(0.15), sc.darkened(0.25)]))
			ci.draw_line(Vector2(-14, -22), Vector2(16, -26), Color(0.4, 0.28, 0.16, 0.35), 2.2)
			ci.draw_line(Vector2(-12, -40), Vector2(14, -42), Color(0.4, 0.28, 0.16, 0.3), 2.0)
		"dry_grass":
			for i: int in range(8):
				var gx2: float = rng.randf_range(-16.0, 16.0)
				ci.draw_line(Vector2(gx2, 0), Vector2(gx2 + rng.randf_range(-8.0, 8.0), -rng.randf_range(12.0, 26.0)), Color(0.78, 0.66, 0.30) if i % 2 == 0 else Color(0.62, 0.52, 0.24), 2.2, true)
		"bones":
			var bc := Color(0.94, 0.92, 0.84)
			ci.draw_line(Vector2(-12, -3), Vector2(12, -5), bc.darkened(0.3), 6.0, true)
			ci.draw_line(Vector2(-12, -3), Vector2(12, -5), bc, 3.6, true)
			ci.draw_circle(Vector2(-6, -12), 8.0, bc.darkened(0.25))
			ci.draw_circle(Vector2(-6, -12), 6.4, bc)
			ci.draw_circle(Vector2(-8.5, -13), 1.8, Color(0.15, 0.1, 0.12))
			ci.draw_circle(Vector2(-3.5, -13), 1.8, Color(0.15, 0.1, 0.12))
		"jar":
			soft_shadow(ci, 16.0)
			var jc := Color(0.74, 0.46, 0.28)
			ci.draw_polygon(PackedVector2Array([Vector2(-6, -30), Vector2(6, -30), Vector2(13, -16), Vector2(8, 0), Vector2(-8, 0), Vector2(-13, -16)]),
				PackedColorArray([jc.lightened(0.1), jc, jc, jc.darkened(0.2), jc.darkened(0.2), jc]))
			ci.draw_line(Vector2(-9, -18), Vector2(9, -18), jc.darkened(0.35), 2.0)
		"stone_pillar":
			soft_shadow(ci, 24.0, 0.3)
			var pc := Color(0.50, 0.48, 0.58)
			ci.draw_polygon(PackedVector2Array([Vector2(-13, 0), Vector2(-11, -64), Vector2(11, -64), Vector2(13, 0)]), PackedColorArray([pc.lightened(0.1), pc.lightened(0.12), pc.darkened(0.1), pc.darkened(0.2)]))
			ci.draw_rect(Rect2(-16, -70, 32, 8), pc.lightened(0.05))
			ci.draw_rect(Rect2(-16, -6, 32, 6), pc.darkened(0.1))
			ci.draw_line(Vector2(-6, -56), Vector2(-4, -10), Color(0, 0, 0, 0.18), 2.0)
		"torch":
			soft_shadow(ci, 14.0, 0.22)
			_bar(ci, Vector2(0, 0), Vector2(0, -46), 5.5, Color(0.40, 0.30, 0.22))
			ci.draw_rect(Rect2(-8, -52, 16, 8), Color(0.30, 0.26, 0.28))
			var fl: float = 1.0 + 0.18 * sin(t * 11.0) + 0.08 * sin(t * 23.0)
			ci.draw_circle(Vector2(0, -62), 24.0 * fl, Color(1.0, 0.55, 0.15, 0.14))
			ci.draw_circle(Vector2(0, -62), 14.0 * fl, Color(1.0, 0.6, 0.2, 0.22))
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-7, -54), Vector2(-4, -68 * fl), Vector2(0, -80 * fl), Vector2(5, -66 * fl), Vector2(7, -54)]), Color(1.0, 0.55, 0.15))
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-3.5, -54), Vector2(0, -72 * fl), Vector2(3.5, -54)]), Color(1.0, 0.9, 0.45))
		"banner":
			_bar(ci, Vector2(0, 0), Vector2(0, -70), 5.0, Color(0.36, 0.28, 0.24))
			ci.draw_colored_polygon(PackedVector2Array([Vector2(2, -66), Vector2(26, -66), Vector2(26, -26), Vector2(14, -34), Vector2(2, -26)]), Color(0.60, 0.16, 0.28))
			ci.draw_colored_polygon(PackedVector2Array([Vector2(8, -58), Vector2(20, -58), Vector2(14, -44)]), Color(0.95, 0.80, 0.30))
		"chains":
			for i: int in range(5):
				ci.draw_circle(Vector2(-14.0 + float(i) * 7.0, -14.0 + sin(float(i) * 1.3) * 3.0), 3.4, Color(0.55, 0.56, 0.62))
				ci.draw_circle(Vector2(-14.0 + float(i) * 7.0, -14.0 + sin(float(i) * 1.3) * 3.0), 1.4, Color(0.2, 0.2, 0.26))
		"big_tree":
			soft_shadow(ci, 44.0, 0.32)
			var trunk := Color(0.43, 0.30, 0.19)
			ci.draw_polygon(PackedVector2Array([Vector2(-15, 0), Vector2(-9, -96), Vector2(9, -96), Vector2(16, 0)]), PackedColorArray([trunk.lightened(0.1), trunk.lightened(0.05), trunk.darkened(0.1), trunk.darkened(0.2)]))
			ci.draw_line(Vector2(-4, -80), Vector2(-6, -10), Color(0, 0, 0, 0.2), 2.5)
			ci.draw_line(Vector2(-12, 0), Vector2(-26, 6), trunk.darkened(0.1), 7.0, true)
			ci.draw_line(Vector2(12, 0), Vector2(28, 6), trunk.darkened(0.2), 7.0, true)
			ci.draw_set_transform(Vector2(0, -104), 0.0, Vector2(1.0, 0.45))
			ci.draw_circle(Vector2.ZERO, 54.0, leaf.darkened(0.5))
			ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			for o: Array in [[-30.0, -100.0, 24.0], [28.0, -104.0, 23.0], [-6.0, -128.0, 28.0], [-34.0, -126.0, 20.0], [32.0, -130.0, 20.0], [0, -100.0, 24.0], [-2.0, -152.0, 22.0]]:
				blob(ci, Vector2(float(o[0]), float(o[1])), float(o[2]), leaf.darkened(0.08), leaf_hi)
			for lc2: Array in [[-14.0, -158.0], [10.0, -146.0], [-28.0, -134.0], [26.0, -138.0], [0.0, -120.0], [-12.0, -108.0], [20.0, -112.0]]:
				ci.draw_circle(Vector2(float(lc2[0]), float(lc2[1])), 3.6, leaf_hi.lightened(0.15))
		"stump":
			soft_shadow(ci, 22.0, 0.26)
			var sw := Color(0.52, 0.38, 0.24)
			ci.draw_polygon(PackedVector2Array([Vector2(-16, 0), Vector2(-14, -26), Vector2(14, -26), Vector2(17, 0)]), PackedColorArray([sw.lightened(0.1), sw, sw.darkened(0.15), sw.darkened(0.25)]))
			ci.draw_set_transform(Vector2(0, -26), 0.0, Vector2(1.0, 0.45))
			ci.draw_circle(Vector2.ZERO, 14.5, Color(0.80, 0.64, 0.42))
			ci.draw_arc(Vector2.ZERO, 10.0, 0.0, TAU, 20, Color(0.55, 0.40, 0.24), 1.6)
			ci.draw_arc(Vector2.ZERO, 5.0, 0.0, TAU, 14, Color(0.55, 0.40, 0.24), 1.4)
			ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			ci.draw_circle(Vector2(-10, -22), 5.0, leaf)
		"log_pile":
			soft_shadow(ci, 28.0, 0.26)
			var lc := Color(0.55, 0.40, 0.26)
			for r: Array in [[-14.0, -7.0], [0.0, -7.0], [14.0, -7.0], [-7.0, -19.0], [7.0, -19.0]]:
				ci.draw_circle(Vector2(float(r[0]), float(r[1])), 8.0, lc.darkened(0.3))
				ci.draw_circle(Vector2(float(r[0]), float(r[1])), 6.4, Color(0.80, 0.64, 0.42))
				ci.draw_arc(Vector2(float(r[0]), float(r[1])), 3.6, 0.0, TAU, 12, Color(0.55, 0.4, 0.24), 1.2)
			ci.draw_line(Vector2(-22, -13), Vector2(22, -13), Color(0.78, 0.68, 0.5), 2.0)
		"ruin_wall":
			soft_shadow(ci, 34.0, 0.3)
			var st := Color(0.64, 0.64, 0.58)
			var blocks: Array = [[-26.0, -12.0, 26.0, 12.0], [0.0, -12.0, 24.0, 12.0], [-18.0, -24.0, 24.0, 12.0], [8.0, -24.0, 18.0, 12.0], [-8.0, -36.0, 18.0, 12.0]]
			for bk: Array in blocks:
				var r := Rect2(float(bk[0]), float(bk[1]), float(bk[2]), float(bk[3]))
				ci.draw_rect(r, st.darkened(0.25))
				ci.draw_rect(Rect2(r.position + Vector2(1.5, 1.5), r.size - Vector2(3, 3)), st.lightened(0.05 * float(int(bk[0]) % 3)))
			ci.draw_rect(Rect2(-26, -12, 50, 4), leaf.darkened(0.05))
			blob(ci, Vector2(-14, -38), 6.0, leaf, leaf_hi)
			blob(ci, Vector2(14, -26), 5.0, leaf, leaf_hi)
		"standing_stone":
			soft_shadow(ci, 22.0, 0.28)
			var sc2 := Color(0.60, 0.62, 0.60)
			ci.draw_polygon(PackedVector2Array([Vector2(-13, 0), Vector2(-10, -44), Vector2(0, -56), Vector2(11, -46), Vector2(14, 0)]), PackedColorArray([sc2.lightened(0.12), sc2, sc2.lightened(0.05), sc2.darkened(0.12), sc2.darkened(0.25)]))
			ci.draw_polyline(PackedVector2Array([Vector2(-6, -34), Vector2(0, -42), Vector2(6, -34), Vector2(0, -26), Vector2(-6, -34)]), Color(0.5, 0.95, 0.85, 0.9), 2.0, true)
			ci.draw_circle(Vector2(0, -34), 14.0, Color(0.5, 0.95, 0.85, 0.12))
			blob(ci, Vector2(-8, -3), 6.0, leaf, leaf_hi)
		"ruin_arch":
			soft_shadow(ci, 70.0, 0.34)
			var ac := Color(0.66, 0.66, 0.60)
			for sx: float in [-40.0, 40.0]:
				ci.draw_polygon(PackedVector2Array([Vector2(sx - 14.0, 0), Vector2(sx - 12.0, -96), Vector2(sx + 12.0, -96), Vector2(sx + 14.0, 0)]), PackedColorArray([ac.lightened(0.1), ac.lightened(0.06), ac.darkened(0.1), ac.darkened(0.2)]))
				for k: int in range(1, 5):
					ci.draw_line(Vector2(sx - 12.0, -float(k) * 22.0), Vector2(sx + 12.0, -float(k) * 22.0), Color(0, 0, 0, 0.22), 1.8)
				ci.draw_rect(Rect2(sx - 17.0, -8.0, 34.0, 8.0), ac.darkened(0.12))
			ci.draw_polygon(PackedVector2Array([Vector2(-58, -96), Vector2(-40, -122), Vector2(0, -134), Vector2(40, -122), Vector2(58, -96), Vector2(36, -96), Vector2(0, -108), Vector2(-36, -96)]),
				PackedColorArray([ac, ac.lightened(0.08), ac.lightened(0.12), ac.lightened(0.08), ac, ac.darkened(0.12), ac.darkened(0.08), ac.darkened(0.12)]))
			for kx: float in [-24.0, 0.0, 24.0]:
				ci.draw_line(Vector2(kx, -108.0 - absf(kx) * 0.2), Vector2(kx, -130.0 + absf(kx) * 0.25), Color(0, 0, 0, 0.25), 1.8)
			blob(ci, Vector2(-44, -128), 10.0, leaf, leaf_hi)
			blob(ci, Vector2(30, -124), 8.0, leaf, leaf_hi)
			for vx: float in [-30.0, -20.0, 18.0, 28.0]:
				ci.draw_line(Vector2(vx, -108.0), Vector2(vx + 2.0, -84.0 - absf(vx)), leaf.darkened(0.1), 2.6, true)
			ci.draw_circle(Vector2(0, -50), 54.0, Color(0.95, 0.95, 0.7, 0.05))
		"ice_portal":
			soft_shadow(ci, 70.0, 0.34)
			var ice := Color(0.62, 0.82, 0.94)
			for sx: float in [-36.0, 36.0]:
				ci.draw_polygon(PackedVector2Array([Vector2(sx - 13.0, 0), Vector2(sx - 10.0, -100), Vector2(sx + 10.0, -100), Vector2(sx + 13.0, 0)]),
					PackedColorArray([ice.lightened(0.25), ice.lightened(0.15), ice.darkened(0.1), ice.darkened(0.25)]))
				for k: int in range(1, 5):
					ci.draw_line(Vector2(sx - 10.0, -float(k) * 22.0), Vector2(sx + 10.0, -float(k) * 22.0), Color(0.9, 0.97, 1.0, 0.35), 1.6)
			ci.draw_polygon(PackedVector2Array([Vector2(-54, -100), Vector2(-36, -126), Vector2(0, -138), Vector2(36, -126), Vector2(54, -100), Vector2(34, -100), Vector2(0, -112), Vector2(-34, -100)]),
				PackedColorArray([ice, ice.lightened(0.2), ice.lightened(0.3), ice.lightened(0.2), ice, ice.darkened(0.15), ice.darkened(0.1), ice.darkened(0.15)]))
			ci.draw_circle(Vector2(0, -56), 46.0, Color(0.55, 0.85, 1.0, 0.16))
			ci.draw_circle(Vector2(0, -56), 34.0, Color(0.7, 0.92, 1.0, 0.2))
			for kx: float in [-26.0, 0.0, 26.0]:
				ci.draw_line(Vector2(kx, -112.0 - absf(kx) * 0.2), Vector2(kx, -134.0 + absf(kx) * 0.25), Color(0.95, 0.99, 1.0, 0.6), 2.2)
			for vx: float in [-30.0, -16.0, 20.0, 30.0]:
				ci.draw_line(Vector2(vx, -100.0), Vector2(vx + 2.0, -80.0 - absf(vx)), Color(0.85, 0.95, 1.0, 0.5), 2.4, true)
		"cairn":
			soft_shadow(ci, 30.0, 0.28)
			var rock := Color(0.58, 0.60, 0.60)
			var rows: Array = [[-16.0, -8.0, 15.0], [-9.0, -22.0, 12.0], [1.0, -34.0, 10.0], [-3.0, -44.0, 7.0], [0.0, -52.0, 4.5]]
			for rr: Array in rows:
				ci.draw_circle(Vector2(float(rr[0]) + rng.randf_range(-1.5, 1.5), float(rr[1])), float(rr[2]), rock.darkened(0.18))
				ci.draw_circle(Vector2(float(rr[0]), float(rr[1]) - 1.5), float(rr[2]) - 1.6, rock.lightened(0.08))
			ci.draw_circle(Vector2(0, -54.0), 5.0, Color(0.5, 0.95, 0.9, 0.7))
			ci.draw_circle(Vector2(0, -54.0), 9.0, Color(0.5, 0.95, 0.9, 0.18))
			ci.draw_circle(Vector2(-12, -3), 4.5, Color(0.95, 0.97, 1.0, 0.85))
			ci.draw_circle(Vector2(13, -5), 3.2, Color(0.95, 0.97, 1.0, 0.7))
		"obelisk":
			soft_shadow(ci, 60.0, 0.34)
			var sand := Color(0.82, 0.68, 0.42)
			ci.draw_polygon(PackedVector2Array([Vector2(-20, 0), Vector2(-14, -110), Vector2(0, -132), Vector2(14, -110), Vector2(20, 0)]),
				PackedColorArray([sand.lightened(0.12), sand.lightened(0.05), sand, sand.darkened(0.12), sand.darkened(0.28)]))
			for k: int in range(1, 6):
				ci.draw_line(Vector2(-16.0 + float(k), -float(k) * 20.0), Vector2(16.0 - float(k), -float(k) * 20.0), Color(0, 0, 0, 0.16), 2.0)
			ci.draw_line(Vector2(0, -36), Vector2(0, -60), Color(0.45, 0.8, 0.5, 0.8), 3.0, true)
			ci.draw_line(Vector2(-8, -46), Vector2(8, -46), Color(0.45, 0.8, 0.5, 0.7), 3.0, true)
			ci.draw_circle(Vector2(0, -46), 16.0, Color(0.45, 0.85, 0.5, 0.14))
			ci.draw_rect(Rect2(-26, -10, 52, 10), sand.darkened(0.2))
			blob(ci, Vector2(-24, -114), 7.0, leaf, leaf_hi)
			blob(ci, Vector2(18, -108), 5.0, leaf, leaf_hi)
		"well":
			soft_shadow(ci, 34.0, 0.3)
			var wstone := Color(0.78, 0.64, 0.40)
			ci.draw_circle(Vector2(0, 0), 24.0, wstone.darkened(0.3))
			ci.draw_circle(Vector2(0, -2), 20.0, wstone)
			ci.draw_circle(Vector2(0, -2), 13.0, Color(0.1, 0.16, 0.2))
			ci.draw_circle(Vector2(0, -2), 11.0, Color(0.2, 0.34, 0.42))
			for a: float in [0.0, PI / 2.0, PI, PI * 1.5]:
				ci.draw_circle(Vector2(cos(a), sin(a) * 0.5) * 22.0, 4.0, wstone.darkened(0.15))
			for sx: float in [-16.0, 16.0]:
				ci.draw_line(Vector2(sx, -2), Vector2(sx, -44), Color(0.55, 0.4, 0.26), 4.0)
			ci.draw_line(Vector2(-22, -44), Vector2(22, -44), Color(0.62, 0.46, 0.3), 5.0)
			var rope_len: float = 16.0 + sin(t * 1.4) * 1.5
			ci.draw_line(Vector2(0, -44), Vector2(0, -44 + rope_len), Color(0.75, 0.68, 0.55), 1.6)
			ci.draw_circle(Vector2(0, -44 + rope_len + 3.0), 4.0, Color(0.6, 0.5, 0.38))
		_:
			pass
