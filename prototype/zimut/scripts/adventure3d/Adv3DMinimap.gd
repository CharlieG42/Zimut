class_name Adv3DMinimap
extends Control
## Adv3DMinimap.gd — Mini-carte du monde 3D (coin haut-droit) : relief de la zone, lieux, portes,
## groupes de monstres et position / direction du joueur. Trois états (grande, petite, masquée),
## mémorisés pour la session. Nord en haut ; le triangle indique la direction de la caméra.

const MODE_BIG := 0
const MODE_SMALL := 1
const MODE_HIDDEN := 2
const LONG_SIDE := [300.0, 170.0]

static var mode: int = MODE_BIG

var _size: Vector2i = Vector2i(1, 1)
var _tex: ImageTexture = null
var _pois: Array = []            # [{cell, color, done}]
var _gates: Array = []           # [{cell, open}]
var _mobs: Array = []            # [Vector2i]
var _player: Vector2 = Vector2.ZERO   # en cases (flottant)
var _yaw: float = 0.0


func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST


## Construit l'image du terrain (1 pixel = 1 case).
func setup(terrain: Dictionary, pal: Dictionary) -> void:
	_size = terrain["size"]
	var img := Image.create(_size.x, _size.y, false, Image.FORMAT_RGBA8)
	img.fill(Color(0, 0, 0, 0))
	var ground: Array = pal["ground"]
	var voids: Dictionary = terrain["voids"]
	var obst: Dictionary = terrain["obstacles"]
	var paths: Dictionary = terrain["paths"]
	for cy: int in range(_size.y):
		for cx: int in range(_size.x):
			var c := Vector2i(cx, cy)
			if voids.has(c):
				continue
			var col: Color = (ground[1] as Color).darkened(0.12)
			if paths.has(c):
				col = (pal["path"] as Color).lightened(0.05)
			elif obst.has(c):
				var k: String = String(obst[c]).to_lower()
				col = Color(0.38, 0.40, 0.42) if (k.contains("rock") or k.contains("stone") or k.contains("crystal") or k.contains("pillar")) else (ground[0] as Color).darkened(0.45)
			img.set_pixel(cx, cy, col)
	_tex = ImageTexture.create_from_image(img)
	_apply_size()


func set_markers(pois: Array, gates: Array, mobs: Array) -> void:
	_pois = pois
	_gates = gates
	_mobs = mobs
	queue_redraw()


func set_player(cells_pos: Vector2, yaw: float) -> void:
	_player = cells_pos
	_yaw = yaw
	queue_redraw()


## Applique l'état (grande / petite / masquée) : taille proportionnelle à la zone.
func set_mode(m: int) -> void:
	mode = m
	_apply_size()


func _apply_size() -> void:
	visible = mode != MODE_HIDDEN
	if mode == MODE_HIDDEN:
		return
	var long_side: float = LONG_SIDE[mode]
	var ratio: float = float(_size.x) / float(maxi(_size.y, 1))
	var w: float = long_side if ratio >= 1.0 else long_side * ratio
	var h: float = long_side / ratio if ratio >= 1.0 else long_side
	custom_minimum_size = Vector2(w, h) + Vector2(16, 16)
	size = custom_minimum_size
	queue_redraw()


func _draw() -> void:
	if _tex == null or mode == MODE_HIDDEN:
		return
	var pad := Vector2(8, 8)
	var area: Vector2 = size - pad * 2.0
	var cell: float = minf(area.x / float(_size.x), area.y / float(_size.y))
	var map_size: Vector2 = Vector2(float(_size.x), float(_size.y)) * cell
	var origin: Vector2 = pad + (area - map_size) * 0.5
	# fond : cadre sombre translucide aux coins arrondis
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.06, 0.09, 0.14, 0.72)
	sb.border_color = Color(0.85, 0.72, 0.35, 0.9)
	sb.set_border_width_all(2)
	sb.set_corner_radius_all(10)
	draw_style_box(sb, Rect2(Vector2.ZERO, size))
	draw_texture_rect(_tex, Rect2(origin, map_size), false)
	var sz: float = clampf(cell * 0.95, 10.0, 24.0)
	for g: Dictionary in _gates:
		var gc: Vector2i = g["cell"]
		var gp: Vector2 = origin + (Vector2(gc) + Vector2(0.5, 0.5)) * cell
		_icon_gate(gp, sz, _gate_dir(gc), bool(g["open"]))
	for p: Dictionary in _pois:
		var pc: Vector2i = p["cell"]
		var pp: Vector2 = origin + (Vector2(pc) + Vector2(0.5, 0.5)) * cell
		var kind: String = "dungeon" if bool(p.get("dungeon", false)) else String(p.get("kind", ""))
		_icon_poi(kind, pp, sz, bool(p["done"]))
	for m: Vector2i in _mobs:
		var mp: Vector2 = origin + (Vector2(m) + Vector2(0.5, 0.5)) * cell
		_icon_mob(mp, sz)
	# joueur : triangle orienté selon la caméra
	var pl: Vector2 = origin + _player * cell
	var fwd := Vector2(-sin(_yaw), -cos(_yaw))
	var side := Vector2(-fwd.y, fwd.x)
	var r: float = maxf(cell * 1.1, 7.0)
	var tri: PackedVector2Array = [pl + fwd * r, pl - fwd * r * 0.7 + side * r * 0.65, pl - fwd * r * 0.7 - side * r * 0.65]
	draw_colored_polygon(tri, Color(1.0, 0.92, 0.25))
	var outline: PackedVector2Array = tri.duplicate()
	outline.append(tri[0])
	draw_polyline(outline, Color(0.1, 0.1, 0.1), 2.0)


# ── Pictogrammes : chaque type a sa forme ET sa couleur ──────────────

const OUTLINE := Color(0.05, 0.05, 0.08, 0.95)


func _poly(pts: PackedVector2Array, fill: Color) -> void:
	draw_colored_polygon(pts, fill)
	var o: PackedVector2Array = pts.duplicate()
	o.append(pts[0])
	draw_polyline(o, OUTLINE, 2.0)


## Direction (vers le bord de la carte) d'une porte : N, S, E ou O d'après sa case.
func _gate_dir(c: Vector2i) -> Vector2:
	var d_l: int = c.x
	var d_r: int = _size.x - 1 - c.x
	var d_t: int = c.y
	var d_b: int = _size.y - 1 - c.y
	var m: int = mini(mini(d_l, d_r), mini(d_t, d_b))
	if m == d_l:
		return Vector2(-1, 0)
	if m == d_r:
		return Vector2(1, 0)
	if m == d_t:
		return Vector2(0, -1)
	return Vector2(0, 1)


## Accès à une autre carte : grande flèche pointant vers le bord (verte = ouvert, rouge = fermé).
func _icon_gate(c: Vector2, sz: float, dir: Vector2, open: bool) -> void:
	var col: Color = Color(0.25, 0.95, 0.70) if open else Color(0.95, 0.35, 0.30)
	var side := Vector2(-dir.y, dir.x)
	var r: float = sz * 0.85
	var pts: PackedVector2Array = [c + dir * r, c + side * r * 0.85 - dir * r * 0.2, c + side * r * 0.35 - dir * r * 0.2, c + side * r * 0.35 - dir * r * 0.95,
		c - side * r * 0.35 - dir * r * 0.95, c - side * r * 0.35 - dir * r * 0.2, c - side * r * 0.85 - dir * r * 0.2]
	_poly(pts, col)


func _icon_poi(kind: String, c: Vector2, sz: float, done: bool) -> void:
	var r: float = sz * 0.62
	var a: float = 0.55 if done else 1.0
	match kind:
		"dungeon":
			# donjon : tour crénelée violette, plus grande que le reste
			var w: float = r * 1.25
			var col := Color(0.78, 0.38, 0.95, a)
			var pts: PackedVector2Array = [c + Vector2(-w, w), c + Vector2(-w, -w * 0.55), c + Vector2(-w, -w), c + Vector2(-w * 0.45, -w), c + Vector2(-w * 0.45, -w * 0.6),
				c + Vector2(w * 0.45, -w * 0.6), c + Vector2(w * 0.45, -w), c + Vector2(w, -w), c + Vector2(w, w)]
			_poly(pts, col)
			draw_rect(Rect2(c + Vector2(-w * 0.25, w * 0.1), Vector2(w * 0.5, w * 0.9)), Color(0.15, 0.05, 0.2, a))
		"combat":
			# épreuve de combat : épées croisées sur disque rouge
			draw_circle(c, r, OUTLINE)
			draw_circle(c, r * 0.82, Color(0.92, 0.25, 0.20, a))
			draw_line(c + Vector2(-r, -r) * 0.55, c + Vector2(r, r) * 0.55, Color(1, 1, 1, a), 2.5)
			draw_line(c + Vector2(r, -r) * 0.55, c + Vector2(-r, r) * 0.55, Color(1, 1, 1, a), 2.5)
		"puzzle":
			# énigme : « ? » sur disque violet
			draw_circle(c, r, OUTLINE)
			draw_circle(c, r * 0.82, Color(0.58, 0.40, 0.95, a))
			var f: Font = ThemeDB.fallback_font
			var fs: int = int(r * 1.6)
			var w2: float = f.get_string_size("?", HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
			draw_string(f, c + Vector2(-w2 * 0.5, r * 0.55), "?", HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color(1, 1, 1, a))
		"chest":
			# coffre : petit coffre doré
			draw_rect(Rect2(c - Vector2(r, r * 0.7), Vector2(r * 2.0, r * 1.4)), OUTLINE)
			draw_rect(Rect2(c - Vector2(r * 0.82, r * 0.55), Vector2(r * 1.64, r * 1.1)), Color(0.98, 0.78, 0.22, a))
			draw_rect(Rect2(c - Vector2(r * 0.82, r * 0.05), Vector2(r * 1.64, r * 0.14)), Color(0.45, 0.28, 0.1, a))
		"camp":
			# camp / source : tente verte
			_poly([c + Vector2(0, -r), c + Vector2(r * 1.05, r * 0.85), c + Vector2(-r * 1.05, r * 0.85)], Color(0.30, 0.85, 0.40, a))
		"reveal":
			# belvédère : losange bleu avec point central
			_poly([c + Vector2(0, -r * 1.15), c + Vector2(r * 1.15, 0), c + Vector2(0, r * 1.15), c + Vector2(-r * 1.15, 0)], Color(0.35, 0.75, 1.0, a))
			draw_circle(c, r * 0.3, Color(1, 1, 1, a))
		"exit":
			# sentier : fanion turquoise
			draw_line(c + Vector2(-r * 0.5, r), c + Vector2(-r * 0.5, -r), OUTLINE, 3.0)
			_poly([c + Vector2(-r * 0.5, -r), c + Vector2(r, -r * 0.4), c + Vector2(-r * 0.5, r * 0.2)], Color(0.25, 0.90, 0.85, a))
		_:
			draw_circle(c, r * 0.8, OUTLINE)
			draw_circle(c, r * 0.6, Color(0.9, 0.9, 0.9, a))


## Monstres : tête rouge vif à deux yeux noirs et petites cornes, très visible sur le terrain.
func _icon_mob(c: Vector2, sz: float) -> void:
	var r: float = sz * 0.55
	draw_circle(c, r + 2.5, Color(1, 1, 1, 0.9))
	draw_circle(c, r, Color(0.95, 0.12, 0.12))
	_poly([c + Vector2(-r * 0.9, -r * 0.35), c + Vector2(-r * 0.55, -r * 1.35), c + Vector2(-r * 0.2, -r * 0.7)], Color(0.95, 0.12, 0.12))
	_poly([c + Vector2(r * 0.9, -r * 0.35), c + Vector2(r * 0.55, -r * 1.35), c + Vector2(r * 0.2, -r * 0.7)], Color(0.95, 0.12, 0.12))
	draw_circle(c + Vector2(-r * 0.35, -r * 0.05), r * 0.2, Color(0.05, 0.02, 0.02))
	draw_circle(c + Vector2(r * 0.35, -r * 0.05), r * 0.2, Color(0.05, 0.02, 0.02))
