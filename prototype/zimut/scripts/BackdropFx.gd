class_name BackdropFx
extends Node2D
## BackdropFx.gd — Fond de la scène de combat (monde, derrière l'île) : lumière douce, nuages
## qui dérivent, petites îles flottantes lointaines teintées par la brume (perspective
## atmosphérique), surface de l'eau avec reflets, poussières lumineuses. Teinte selon le biome.

var _biome: String = "Forêt"
var _t: float = 0.0
var _clouds: Array[Dictionary] = []
var _islets: Array[Dictionary] = []
var _specks: Array[Dictionary] = []

## V144 : fond de scène propre à chaque nation (ciel en dégradé, deux plans de relief au lointain, mer ou
## mer de nuages, particules). Les nations absentes de SKY gardent le fond d'origine (voile de teinte).
##   top / hor : ciel au zénith et à l'horizon ; far / near : relief lointain et proche ; kind : silhouette ;
##   sea : bande du bas ; cloud : nuages ; speck : particules ; fall : true = elles tombent (neige).
const SKY := {
	"Forêt": {"top": Color(0.30, 0.56, 0.86), "hor": Color(0.84, 0.94, 0.88), "far": Color(0.34, 0.60, 0.56), "near": Color(0.18, 0.42, 0.28),
		"kind": "hills", "sea": Color(0.38, 0.66, 0.72), "cloud": Color(1, 1, 1), "speck": Color(1.0, 1.0, 0.72), "fall": false, "glow": Color(1.0, 0.97, 0.80)},
	"Montagne": {"top": Color(0.26, 0.48, 0.84), "hor": Color(0.86, 0.93, 1.0), "far": Color(0.50, 0.63, 0.88), "near": Color(0.36, 0.49, 0.76),
		"kind": "peaks", "sea": Color(0.93, 0.96, 1.0), "cloud": Color(1, 1, 1), "speck": Color(1, 1, 1), "fall": true, "glow": Color(1.0, 0.98, 0.92)},
	"Brasier": {"top": Color(0.13, 0.06, 0.08), "hor": Color(0.88, 0.42, 0.18), "far": Color(0.46, 0.19, 0.14), "near": Color(0.19, 0.09, 0.09),
		"kind": "volcano", "sea": Color(0.80, 0.30, 0.08), "cloud": Color(0.22, 0.12, 0.11), "speck": Color(1.0, 0.62, 0.22), "fall": false, "glow": Color(1.0, 0.55, 0.20)},
	"Brumes": {"top": Color(0.22, 0.34, 0.40), "hor": Color(0.72, 0.86, 0.82), "far": Color(0.52, 0.68, 0.66), "near": Color(0.30, 0.44, 0.44),
		"kind": "swamp", "sea": Color(0.34, 0.50, 0.50), "cloud": Color(0.86, 0.95, 0.92), "speck": Color(0.72, 1.0, 0.92), "fall": false, "glow": Color(0.86, 1.0, 0.94)},
}
const SEA_Y := 330.0

## Plan fixe du fond (ciel, reliefs) : dessiné une seule fois, jamais redessiné par image.
class StaticLayer extends Node2D:
	var painter: Callable
	func _draw() -> void:
		if painter.is_valid():
			painter.call(self)

var _static: StaticLayer = null
var _far: PackedVector2Array = PackedVector2Array()
var _near: PackedVector2Array = PackedVector2Array()
var _far_peaks: Array[int] = []
var _cones: Array[Dictionary] = []
var _snags: Array[Dictionary] = []

const TINT := {
	"Forêt": Color(0.40, 0.62, 0.66, 0.18), "Montagne": Color(0.55, 0.70, 0.90, 0.22),
	"Désert": Color(0.95, 0.72, 0.42, 0.22), "Donjon": Color(0.30, 0.22, 0.45, 0.42),
}


func _ready() -> void:
	add_to_group("backdrop")
	var gm: Node = get_node_or_null("/root/GameManager")
	configure(String(gm.fight_biome) if gm != null else "Forêt")


func set_biome(biome: String) -> void:
	if biome != _biome:
		configure(biome)


func configure(biome: String) -> void:
	_biome = biome
	_clouds.clear()
	_islets.clear()
	_specks.clear()
	var rng := RandomNumberGenerator.new()
	rng.seed = 4242 + biome.hash() % 100
	for i: int in range(7):
		_clouds.append({"x": rng.randf_range(-1700.0, 1700.0), "y": rng.randf_range(-560.0, 420.0), "s": rng.randf_range(0.8, 1.7),
			"v": rng.randf_range(4.0, 11.0), "a": rng.randf_range(0.10, 0.22)})
	var slots: Array = [[-1100.0, -180.0], [1060.0, -260.0], [-780.0, 330.0], [880.0, 300.0], [-1450.0, 120.0], [1400.0, 90.0], [20.0, -620.0]]
	for sl: Array in slots:
		_islets.append({"x": float(sl[0]) + rng.randf_range(-60.0, 60.0), "y": float(sl[1]) + rng.randf_range(-40.0, 40.0),
			"w": rng.randf_range(110.0, 230.0), "ph": rng.randf() * TAU, "far": rng.randf_range(0.45, 0.8), "trees": rng.randi_range(1, 3),
			"seed": rng.randi()})
	for i: int in range(46):
		_specks.append({"x": rng.randf_range(-1800.0, 1800.0), "y": rng.randf_range(-800.0, 700.0), "r": rng.randf_range(1.0, 2.8),
			"ph": rng.randf() * TAU, "v": rng.randf_range(3.0, 9.0)})
	_build_static(rng)
	set_process(true)
	queue_redraw()


## Reliefs du lointain (V144) : deux crêtes posées sur l'horizon, selon la nation.
func _build_static(rng: RandomNumberGenerator) -> void:
	_far = PackedVector2Array()
	_near = PackedVector2Array()
	_far_peaks.clear()
	_cones.clear()
	_snags.clear()
	if _static == null:
		_static = StaticLayer.new()
		_static.name = "FondFixe"
		_static.show_behind_parent = true
		_static.painter = _paint_static
		add_child(_static)
	_static.visible = SKY.has(_biome)
	if not SKY.has(_biome):
		_static.queue_redraw()
		return
	var kind: String = String(SKY[_biome]["kind"])
	_far = _ridge(rng, kind, 230.0 if kind == "peaks" else 150.0, 430.0 if kind == "peaks" else 250.0, _far_peaks)
	var dummy: Array[int] = []
	_near = _ridge(rng, "hills" if kind != "peaks" else "peaks", 60.0, 150.0, dummy)
	if kind == "volcano":
		for cx: float in [-1180.0, -520.0, 760.0, 1420.0]:
			_cones.append({"x": cx + rng.randf_range(-80.0, 80.0), "w": rng.randf_range(260.0, 420.0), "h": rng.randf_range(300.0, 470.0), "ph": rng.randf() * TAU})
	if kind == "swamp":
		for i: int in range(16):
			_snags.append({"x": rng.randf_range(-1900.0, 1900.0), "h": rng.randf_range(90.0, 190.0), "lean": rng.randf_range(-0.25, 0.25), "seed": rng.randi()})
	_static.queue_redraw()


func _ridge(rng: RandomNumberGenerator, kind: String, h_min: float, h_max: float, peaks: Array[int]) -> PackedVector2Array:
	var pts := PackedVector2Array()
	var x: float = -3200.0
	if kind == "peaks":
		var up: bool = false
		while x < 3200.0:
			var h: float = rng.randf_range(h_max * 0.62, h_max) if up else rng.randf_range(h_min * 0.5, h_min)
			if up:
				peaks.append(pts.size())
			pts.append(Vector2(x, SEA_Y - h))
			x += rng.randf_range(130.0, 260.0)
			up = not up
	else:
		var p1: float = rng.randf() * TAU
		var p2: float = rng.randf() * TAU
		while x <= 3200.0:
			var k: float = 0.5 + 0.32 * sin(x * 0.0031 + p1) + 0.18 * sin(x * 0.0087 + p2)
			pts.append(Vector2(x, SEA_Y - lerpf(h_min, h_max, clampf(k, 0.0, 1.0))))
			x += 70.0
	return pts


## Remplit sous une crête (bandes verticales : pas de triangulation de polygone concave).
func _fill_ridge(ci: CanvasItem, pts: PackedVector2Array, top: Color, bot: Color) -> void:
	for i: int in range(pts.size() - 1):
		var a: Vector2 = pts[i]
		var b: Vector2 = pts[i + 1]
		ci.draw_polygon(PackedVector2Array([a, b, Vector2(b.x, SEA_Y + 30.0), Vector2(a.x, SEA_Y + 30.0)]), PackedColorArray([top, top, bot, bot]))


func _paint_static(ci: CanvasItem) -> void:
	if not SKY.has(_biome):
		return
	var sk: Dictionary = SKY[_biome]
	var top: Color = sk["top"]
	var hor: Color = sk["hor"]
	var far: Color = sk["far"]
	var near: Color = sk["near"]
	var kind: String = String(sk["kind"])
	# ciel : uni tout en haut, puis dégradé jusqu'à l'horizon
	ci.draw_rect(Rect2(-3200, -2200, 6400, 1500), top)
	ci.draw_polygon(PackedVector2Array([Vector2(-3200, -700), Vector2(3200, -700), Vector2(3200, SEA_Y + 30.0), Vector2(-3200, SEA_Y + 30.0)]),
		PackedColorArray([top, top, hor, hor]))
	# halo de lumière derrière l'île
	var glow: Color = sk["glow"]
	for i: int in range(6):
		var k: float = float(i) / 5.0
		ci.draw_circle(Vector2(-40, -80 if kind != "volcano" else 220), 900.0 - k * 620.0, Color(glow.r, glow.g, glow.b, 0.04 + 0.025 * k))
	# volcans : cônes tronqués derrière la première crête, cratère rougeoyant, panache
	for cn: Dictionary in _cones:
		var cx: float = float(cn["x"])
		var w: float = float(cn["w"])
		var h: float = float(cn["h"])
		var tip := Vector2(cx, SEA_Y - h)
		for j: int in range(5):
			var o := Vector2(40.0 + float(j) * 46.0, -40.0 - float(j) * 58.0)
			ci.draw_circle(tip + o, 46.0 + float(j) * 22.0, Color(0.16, 0.09, 0.09, 0.30 - float(j) * 0.045))
		ci.draw_polygon(PackedVector2Array([Vector2(cx - w, SEA_Y + 30.0), Vector2(cx - w * 0.16, tip.y), Vector2(cx + w * 0.16, tip.y), Vector2(cx + w, SEA_Y + 30.0)]),
			PackedColorArray([far.darkened(0.25), far.lightened(0.06), far.lightened(0.06), far.darkened(0.25)]))
		ci.draw_polygon(PackedVector2Array([Vector2(cx - w * 0.16, tip.y), Vector2(cx + w * 0.16, tip.y), Vector2(cx + w * 0.10, tip.y + 26.0), Vector2(cx - w * 0.02, tip.y + 60.0), Vector2(cx - w * 0.11, tip.y + 22.0)]),
			PackedColorArray([Color(1.0, 0.62, 0.20), Color(1.0, 0.62, 0.20), Color(0.95, 0.36, 0.10), Color(0.80, 0.22, 0.08), Color(0.95, 0.36, 0.10)]))
	# crête lointaine (fondue dans la brume de l'horizon)
	_fill_ridge(ci, _far, far.lerp(hor, 0.26), far.lerp(hor, 0.50))
	if kind == "peaks":
		for pi: int in _far_peaks:
			if pi <= 0 or pi >= _far.size() - 1:
				continue
			var p: Vector2 = _far[pi]
			var l: Vector2 = p.lerp(_far[pi - 1], 0.34)
			var r: Vector2 = p.lerp(_far[pi + 1], 0.34)
			ci.draw_colored_polygon(PackedVector2Array([p, r, Vector2(lerpf(p.x, r.x, 0.45), r.y + 16.0), Vector2(p.x, lerpf(p.y, r.y, 0.78)), Vector2(lerpf(p.x, l.x, 0.5), l.y + 20.0), l]), Color(0.97, 0.98, 1.0, 0.92))
	elif kind == "hills":
		for i: int in range(0, _far.size() - 1):
			var q: Vector2 = _far[i].lerp(_far[i + 1], 0.5)
			ci.draw_circle(q + Vector2(-18, 2), 26.0, far.lerp(hor, 0.22))
			ci.draw_circle(q + Vector2(18, 6), 22.0, far.lerp(hor, 0.30))
	# arbres morts du marais, entre les deux crêtes
	for sn: Dictionary in _snags:
		var rs := RandomNumberGenerator.new()
		rs.seed = int(sn["seed"])
		var base := Vector2(float(sn["x"]), SEA_Y - 40.0)
		var tip2 := base + Vector2(float(sn["lean"]) * float(sn["h"]), -float(sn["h"]))
		var tc: Color = near.lerp(hor, 0.22)
		ci.draw_line(base, tip2, tc, 7.0)
		for b: int in range(4):
			var f: float = 0.35 + float(b) * 0.17
			var o2: Vector2 = base.lerp(tip2, f)
			var dir: float = -1.0 if b % 2 == 0 else 1.0
			ci.draw_line(o2, o2 + Vector2(dir * rs.randf_range(26.0, 58.0), -rs.randf_range(18.0, 44.0)), tc, 3.5)
	# crête proche
	_fill_ridge(ci, _near, near.lerp(hor, 0.10), near.lerp(hor, 0.38))
	if kind == "peaks":
		for i: int in range(1, _near.size() - 1):
			if _near[i].y < _near[i - 1].y and _near[i].y < _near[i + 1].y:
				var p3: Vector2 = _near[i]
				ci.draw_colored_polygon(PackedVector2Array([p3, p3.lerp(_near[i + 1], 0.4), Vector2(p3.x, lerpf(p3.y, _near[i + 1].y, 0.3)), p3.lerp(_near[i - 1], 0.4)]), Color(0.96, 0.98, 1.0, 0.85))
	# voile d'horizon : le pied des reliefs se perd dans la brume
	ci.draw_polygon(PackedVector2Array([Vector2(-3200, SEA_Y - 150.0), Vector2(3200, SEA_Y - 150.0), Vector2(3200, SEA_Y + 30.0), Vector2(-3200, SEA_Y + 30.0)]),
		PackedColorArray([Color(hor.r, hor.g, hor.b, 0.0), Color(hor.r, hor.g, hor.b, 0.0), Color(hor.r, hor.g, hor.b, 0.42), Color(hor.r, hor.g, hor.b, 0.42)]))


func _process(delta: float) -> void:
	_t += delta
	for c: Dictionary in _clouds:
		c["x"] = float(c["x"]) + delta * float(c["v"])
		if float(c["x"]) > 1900.0:
			c["x"] = -1900.0
	queue_redraw()


func _draw() -> void:
	var p: Dictionary = BattleScenery.pal(_biome)
	var mist: Color = p["mist"]
	var sky: Dictionary = SKY.get(_biome, {})
	if not sky.is_empty():
		_draw_nation(sky, p, mist)
		return
	var tint: Color = Nations.tint(_biome) if Nations.is_new(_biome) else TINT.get(_biome, TINT["Forêt"])
	draw_rect(Rect2(-3200, -2200, 6400, 4400), tint)
	# lumière douce derrière l'île
	for i: int in range(6):
		var k: float = float(i) / 5.0
		draw_circle(Vector2(-40, -80), 900.0 - k * 620.0, Color(1.0, 0.97, 0.85, 0.035 + 0.02 * k))
	# nuages
	for c: Dictionary in _clouds:
		var base := Vector2(float(c["x"]), float(c["y"]))
		var s: float = float(c["s"])
		var a: float = float(c["a"])
		for j: int in range(5):
			var o := Vector2((float(j) - 2.0) * 70.0 * s, sin(float(j) * 1.7) * 14.0 * s)
			draw_set_transform(base + o, 0.0, Vector2(1.0, 0.36))
			draw_circle(Vector2.ZERO, (64.0 - absf(float(j) - 2.0) * 10.0) * s, Color(1, 1, 1, a))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	# îles flottantes lointaines
	for it: Dictionary in _islets:
		_draw_islet(it, p, mist)
	# surface de l'eau : bande lumineuse + reflets
	var sea_y: float = 330.0
	draw_rect(Rect2(-3200, sea_y, 6400, 1400), Color(mist.r * 0.7, mist.g * 0.82, mist.b * 0.9, 0.38))
	draw_rect(Rect2(-3200, sea_y, 6400, 10), Color(1, 1, 1, 0.35))
	var rng := RandomNumberGenerator.new()
	rng.seed = 91
	for i: int in range(34):
		var gx: float = rng.randf_range(-1700.0, 1700.0)
		var gy: float = sea_y + 24.0 + rng.randf_range(0.0, 520.0)
		var w: float = rng.randf_range(24.0, 90.0) * (0.6 + (gy - sea_y) / 700.0)
		var a: float = (0.10 + 0.14 * (0.5 + 0.5 * sin(_t * 0.9 + float(i)))) * (0.5 if gy > sea_y + 300.0 else 1.0)
		draw_line(Vector2(gx - w, gy), Vector2(gx + w, gy), Color(1, 1, 1, a), 2.0, true)
	# poussières lumineuses
	for s: Dictionary in _specks:
		var tw: float = 0.5 + 0.5 * sin(_t * 1.4 + float(s["ph"]))
		var pos := Vector2(float(s["x"]) + sin(_t * 0.2 + float(s["ph"])) * 14.0, float(s["y"]) - fposmod(_t * float(s["v"]), 90.0))
		draw_circle(pos, float(s["r"]), Color(1, 1, 1, 0.10 + 0.28 * tw))


func _draw_islet(it: Dictionary, p: Dictionary, mist: Color) -> void:
	var far: float = float(it["far"])
	var bob: float = sin(_t * 0.5 + float(it["ph"])) * 7.0
	var c := Vector2(float(it["x"]), float(it["y"]) + bob)
	var w: float = float(it["w"])
	var top_c: Color = Color(p["top_a"]).lerp(mist, far * 0.7)
	var side_c: Color = Color(p["l_t"]).lerp(mist, far * 0.75)
	var base_c: Color = Color(p["l_b"]).lerp(mist, far * 0.8)
	# dessous rocheux (cône irrégulier)
	var rng := RandomNumberGenerator.new()
	rng.seed = int(it["seed"])
	var pts := PackedVector2Array([c + Vector2(-w, 0), c + Vector2(w, 0)])
	var steps: int = 5
	for i: int in range(steps + 1):
		var f: float = float(i) / float(steps)
		pts.append(c + Vector2(lerpf(w, -w, f) * (1.0 - 0.72 * sin(f * PI * 0.5)), 28.0 + sin(f * PI) * w * 0.62 + rng.randf_range(-8.0, 8.0)))
	draw_colored_polygon(pts, side_c)
	draw_colored_polygon(PackedVector2Array([c + Vector2(-w, 0), c + Vector2(0, 14), c + Vector2(0, w * 0.5), c + Vector2(-w * 0.45, w * 0.3)]), base_c.lightened(0.05))
	# dessus
	draw_set_transform(c, 0.0, Vector2(1.0, 0.34))
	draw_circle(Vector2.ZERO, w, top_c)
	draw_circle(Vector2(-w * 0.2, -w * 0.12), w * 0.7, top_c.lightened(0.08))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	# petits arbres / pierres dressées
	for i: int in range(int(it["trees"])):
		var tx: float = c.x + (float(i) - float(it["trees"]) * 0.5 + 0.5) * w * 0.7
		var ty: float = c.y - 4.0
		var leaf: Color = Color(p["leaf"]).lerp(mist, far * 0.65)
		if Nations.is_new(_biome):
			var ac: Color = Nations.accent(_biome).lerp(mist, far * 0.5)
			draw_colored_polygon(PackedVector2Array([Vector2(tx - 8, ty), Vector2(tx, ty - 40), Vector2(tx + 8, ty)]), ac)
		elif _biome == "Désert":
			draw_rect(Rect2(tx - 3, ty - 30, 6, 30), leaf)
			draw_rect(Rect2(tx - 11, ty - 22, 5, 12), leaf)
		elif _biome == "Donjon":
			draw_rect(Rect2(tx - 6, ty - 38, 12, 38), side_c.darkened(0.1))
		elif _biome == "Montagne":
			draw_colored_polygon(PackedVector2Array([Vector2(tx - 14, ty), Vector2(tx, ty - 46), Vector2(tx + 14, ty)]), leaf)
		else:
			draw_rect(Rect2(tx - 3, ty - 24, 6, 24), side_c.darkened(0.2))
			draw_circle(Vector2(tx, ty - 34), 20.0, leaf)
			draw_circle(Vector2(tx - 6, ty - 40), 12.0, leaf.lightened(0.1))


## V144 : partie animée du fond d'une nation (le ciel et les reliefs sont dans le plan fixe).
func _draw_nation(sky: Dictionary, p: Dictionary, mist: Color) -> void:
	var cc: Color = sky["cloud"]
	var kind: String = String(sky["kind"])
	for c: Dictionary in _clouds:
		var base := Vector2(float(c["x"]), float(c["y"]) - 120.0)
		var s: float = float(c["s"])
		var a: float = float(c["a"]) * (1.6 if kind == "volcano" else 1.25)
		for j: int in range(5):
			var o := Vector2((float(j) - 2.0) * 70.0 * s, sin(float(j) * 1.7) * 14.0 * s)
			draw_set_transform(base + o, 0.0, Vector2(1.0, 0.36))
			draw_circle(Vector2.ZERO, (64.0 - absf(float(j) - 2.0) * 10.0) * s, Color(cc.r, cc.g, cc.b, a))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	# cratères : lueur qui respire
	for cn: Dictionary in _cones:
		var tip := Vector2(float(cn["x"]), SEA_Y - float(cn["h"]))
		var pulse: float = 0.5 + 0.5 * sin(_t * 1.3 + float(cn["ph"]))
		draw_set_transform(tip, 0.0, Vector2(1.0, 0.5))
		draw_circle(Vector2.ZERO, float(cn["w"]) * 0.30, Color(1.0, 0.50, 0.14, 0.10 + 0.10 * pulse))
		draw_circle(Vector2.ZERO, float(cn["w"]) * 0.17, Color(1.0, 0.76, 0.30, 0.16 + 0.14 * pulse))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	for it: Dictionary in _islets:
		_draw_islet(it, p, (sky["hor"] as Color))
	# bas de l'image : eau, lave, eau dormante ou mer de nuages
	var sea: Color = sky["sea"]
	draw_polygon(PackedVector2Array([Vector2(-3200, SEA_Y), Vector2(3200, SEA_Y), Vector2(3200, SEA_Y + 1400.0), Vector2(-3200, SEA_Y + 1400.0)]),
		PackedColorArray([sea.lerp(sky["hor"], 0.45), sea.lerp(sky["hor"], 0.45), sea.darkened(0.25), sea.darkened(0.25)]))
	var rng := RandomNumberGenerator.new()
	rng.seed = 91
	if kind == "peaks":
		for i: int in range(26):
			var cx: float = rng.randf_range(-1800.0, 1800.0) + sin(_t * 0.08 + float(i)) * 30.0
			var cy: float = SEA_Y + rng.randf_range(-14.0, 300.0)
			draw_set_transform(Vector2(cx, cy), 0.0, Vector2(1.0, 0.34))
			draw_circle(Vector2.ZERO, rng.randf_range(90.0, 210.0), Color(1, 1, 1, 0.42))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	else:
		var gl: Color = Color(1.0, 0.86, 0.42) if kind == "volcano" else Color(1, 1, 1)
		draw_rect(Rect2(-3200, SEA_Y, 6400, 8), Color(gl.r, gl.g, gl.b, 0.30))
		for i: int in range(34):
			var gx: float = rng.randf_range(-1700.0, 1700.0)
			var gy: float = SEA_Y + 24.0 + rng.randf_range(0.0, 520.0)
			var w: float = rng.randf_range(24.0, 90.0) * (0.6 + (gy - SEA_Y) / 700.0)
			var a2: float = (0.10 + 0.16 * (0.5 + 0.5 * sin(_t * 0.9 + float(i)))) * (0.5 if gy > SEA_Y + 300.0 else 1.0)
			draw_line(Vector2(gx - w, gy), Vector2(gx + w, gy), Color(gl.r, gl.g, gl.b, a2 * (0.6 if kind == "swamp" else 1.0)), 2.0, true)
	# particules : lucioles, flocons, braises, feux follets
	var sc: Color = sky["speck"]
	var fall: bool = bool(sky["fall"])
	for sp: Dictionary in _specks:
		var tw: float = 0.5 + 0.5 * sin(_t * 1.4 + float(sp["ph"]))
		var drift: float = fposmod(_t * float(sp["v"]) * (3.0 if fall else 1.0), 90.0 if not fall else 1500.0)
		var pos := Vector2(float(sp["x"]) + sin(_t * 0.2 + float(sp["ph"])) * 14.0, (fposmod(float(sp["y"]) + 800.0 + drift, 1500.0) - 800.0) if fall else float(sp["y"]) - drift)
		draw_circle(pos, float(sp["r"]) * (1.3 if fall else 1.0), Color(sc.r, sc.g, sc.b, (0.45 + 0.3 * tw) if fall else (0.14 + 0.40 * tw)))
