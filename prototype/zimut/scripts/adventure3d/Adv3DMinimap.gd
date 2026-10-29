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
	var dot: float = maxf(cell * 0.7, 4.0)
	for g: Dictionary in _gates:
		var gc: Vector2i = g["cell"]
		var gp: Vector2 = origin + (Vector2(gc) + Vector2(0.5, 0.5)) * cell
		draw_rect(Rect2(gp - Vector2(dot, dot) * 0.5, Vector2(dot, dot)), Color(0.4, 0.9, 0.7) if bool(g["open"]) else Color(0.9, 0.4, 0.35))
	for p: Dictionary in _pois:
		var pc: Vector2i = p["cell"]
		var pp: Vector2 = origin + (Vector2(pc) + Vector2(0.5, 0.5)) * cell
		var col: Color = p["color"]
		if bool(p["done"]):
			col = col.darkened(0.5)
		draw_circle(pp, dot * 0.6, Color(0, 0, 0, 0.8))
		draw_circle(pp, dot * 0.45, col)
	for m: Vector2i in _mobs:
		var mp: Vector2 = origin + (Vector2(m) + Vector2(0.5, 0.5)) * cell
		draw_circle(mp, dot * 0.4, Color(1.0, 0.25, 0.2))
	# joueur : triangle orienté selon la caméra
	var pl: Vector2 = origin + _player * cell
	var fwd := Vector2(-sin(_yaw), -cos(_yaw))
	var side := Vector2(-fwd.y, fwd.x)
	var r: float = maxf(cell * 1.1, 7.0)
	var tri: PackedVector2Array = [pl + fwd * r, pl - fwd * r * 0.7 + side * r * 0.65, pl - fwd * r * 0.7 - side * r * 0.65]
	draw_colored_polygon(tri, Color(1, 1, 1))
	var outline: PackedVector2Array = tri.duplicate()
	outline.append(tri[0])
	draw_polyline(outline, Color(0.1, 0.1, 0.1), 2.0)
