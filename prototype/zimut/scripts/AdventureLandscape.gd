class_name AdventureLandscape
extends Node2D
## AdventureLandscape.gd — Paysage autour de l'île d'Aventure (V40), dessiné derrière la carte.
##
## Trois étages :
##   ciel (Vents, Brumes)        : mer de nuages sous l'île, soleil, îlots lointains, oiseaux ;
##   surface (autres Nations)    : horizon propre au biome (collines, pics, dunes, océan, cheminées…) ;
##   profondeurs (Ombres, Cristaux, Brasier) : caverne, stalactites, gouffre lumineux, puits de lumière.
## Les cartes voisines apparaissent au loin dans la direction de leur porte, à leur étage :
## au-dessus des nuages pour le ciel, au fond d'un gouffre pour les profondeurs.
## `ForeClouds` (nœud enfant, z plus haut) passe devant la falaise de l'île pour les étages ciel.

const DIR_VEC := {"N": Vector2(1, -0.5), "E": Vector2(1, 0.5), "S": Vector2(-1, 0.5), "W": Vector2(-1, -0.5)}

var biome: String = "Forêt"
var layer: int = 0
var neighbors: Array = []          # [{dir, biome, layer, name}]
var corners: Dictionary = {}       # top/right/bottom/left (repère local), bords extérieurs de l'île
var _t: float = 0.0
var _clouds: Array[Dictionary] = []
var _specks: Array[Dictionary] = []
var _birds: Array[Dictionary] = []
var _horizon: Array[Dictionary] = []
var _fore: ForeClouds = null


func configure(b: String, lay: int, neigh: Array, crn: Dictionary) -> void:
	biome = b
	layer = lay
	neighbors = neigh
	corners = crn
	var rng := RandomNumberGenerator.new()
	rng.seed = absi(b.hash()) % 9973 + 17
	_clouds.clear()
	_specks.clear()
	_birds.clear()
	_horizon.clear()
	for i: int in range(9):
		_clouds.append({"x": rng.randf_range(-2200.0, 2200.0), "y": rng.randf_range(-900.0, -250.0), "s": rng.randf_range(0.7, 1.6),
			"v": rng.randf_range(5.0, 14.0), "a": rng.randf_range(0.12, 0.26)})
	for i: int in range(60):
		_specks.append({"x": rng.randf_range(-2200.0, 2200.0), "y": rng.randf_range(-1100.0, 900.0), "r": rng.randf_range(1.0, 3.0),
			"ph": rng.randf() * TAU, "v": rng.randf_range(4.0, 14.0)})
	for i: int in range(5):
		_birds.append({"x": rng.randf_range(-1800.0, 1800.0), "y": rng.randf_range(-850.0, -380.0), "v": rng.randf_range(30.0, 60.0),
			"s": rng.randf_range(0.7, 1.2), "ph": rng.randf() * TAU})
	# silhouettes d'horizon (2 plans) : hauteur, largeur et position aléatoires mais stables
	for plane: int in range(2):
		var x: float = -2600.0
		while x < 2600.0:
			var w: float = rng.randf_range(140.0, 360.0) * (1.0 + 0.4 * float(plane))
			_horizon.append({"plane": plane, "x": x, "w": w, "h": rng.randf_range(0.5, 1.0), "seed": rng.randi()})
			x += w * rng.randf_range(0.55, 0.9)
	if _fore == null:
		_fore = ForeClouds.new()
		_fore.land = self
		_fore.z_index = 4
		add_child(_fore)
	set_process(true)
	queue_redraw()


func _process(delta: float) -> void:
	_t += delta
	for c: Dictionary in _clouds:
		c["x"] = float(c["x"]) + delta * float(c["v"])
		if float(c["x"]) > 2400.0:
			c["x"] = -2400.0
	for b: Dictionary in _birds:
		b["x"] = float(b["x"]) + delta * float(b["v"])
		if float(b["x"]) > 2200.0:
			b["x"] = -2200.0
	queue_redraw()
	if _fore != null:
		_fore.queue_redraw()


func _pal() -> Dictionary:
	return BattleScenery.pal(biome)


func _accent(b: String) -> Color:
	if Nations.is_new(b):
		return Nations.accent(b)
	return {"Forêt": Color(0.45, 0.75, 0.38), "Montagne": Color(0.80, 0.88, 0.96), "Désert": Color(0.92, 0.72, 0.40),
		"Donjon": Color(0.55, 0.45, 0.70)}.get(b, Color(0.7, 0.8, 0.7))


func _cnr(k: String) -> Vector2:
	return corners.get(k, Vector2.ZERO)


# ══════════════════════════════════════════════════════════════════════

func _draw() -> void:
	match layer:
		1:
			_draw_sky()
		-1:
			_draw_deep()
		_:
			_draw_surface()
	_draw_neighbors()
	_draw_specks()


# ── Surface : horizon du biome, eau ou plaine en contrebas, nuages ────────────
func _draw_surface() -> void:
	var p: Dictionary = _pal()
	var mist: Color = p["mist"]
	var top_y: float = _cnr("top").y
	# halo de lumière derrière l'île
	for i: int in range(6):
		var k: float = float(i) / 5.0
		draw_circle(Vector2(-60, top_y + 80.0), 1100.0 - k * 700.0, Color(1.0, 0.97, 0.85, 0.03 + 0.02 * k))
	_draw_clouds(1.0)
	# deux plans d'horizon, le plus lointain le plus pâle
	for plane: int in [1, 0]:
		var base_y: float = top_y - 40.0 + float(plane) * -110.0
		var col: Color = Color(p["top_a"]).darkened(0.12).lerp(mist, 0.45 + 0.25 * float(plane))
		col.a = 0.85
		for h: Dictionary in _horizon:
			if int(h["plane"]) != plane:
				continue
			_horizon_shape(h, base_y, col, plane)
	# vallée en contrebas : eau pour la plupart, sable pour le désert
	var sea_y: float = _cnr("bottom").y + 230.0
	var low: Color = Color(mist.r * 0.72, mist.g * 0.84, mist.b * 0.92, 0.42)
	if biome == "Désert":
		low = Color(0.93, 0.80, 0.58, 0.45)
	draw_rect(Rect2(-3000, sea_y, 6000, 1800), low)
	draw_rect(Rect2(-3000, sea_y, 6000, 8), Color(1, 1, 1, 0.30))
	var rng := RandomNumberGenerator.new()
	rng.seed = 77
	for i: int in range(40):
		var gx: float = rng.randf_range(-2000.0, 2000.0)
		var gy: float = sea_y + 20.0 + rng.randf_range(0.0, 600.0)
		var w: float = rng.randf_range(20.0, 80.0)
		var a: float = 0.08 + 0.14 * (0.5 + 0.5 * sin(_t * 0.9 + float(i)))
		draw_line(Vector2(gx - w, gy), Vector2(gx + w, gy), Color(1, 1, 1, a), 2.0, true)


## Silhouette d'horizon selon le biome.
func _horizon_shape(h: Dictionary, base_y: float, col: Color, plane: int) -> void:
	var x: float = float(h["x"])
	var w: float = float(h["w"])
	var k: float = float(h["h"])
	var big: float = 1.0 + 0.5 * float(plane)
	match biome:
		"Montagne":
			var peak := Vector2(x + w * 0.5, base_y - 260.0 * k * big)
			draw_colored_polygon(PackedVector2Array([Vector2(x, base_y), peak, Vector2(x + w, base_y)]), col)
			var snow: Color = Color(1, 1, 1, 0.75 - 0.25 * float(plane))
			draw_colored_polygon(PackedVector2Array([peak, peak + Vector2(w * 0.16, 70.0 * k), peak + Vector2(0, 46.0 * k), peak + Vector2(-w * 0.16, 70.0 * k)]), snow)
		"Désert":
			if int(h["seed"]) % 3 == 0:
				# mesa à sommet plat
				var mh: float = 150.0 * k * big
				draw_colored_polygon(PackedVector2Array([Vector2(x, base_y), Vector2(x + w * 0.18, base_y - mh), Vector2(x + w * 0.82, base_y - mh), Vector2(x + w, base_y)]), col)
			else:
				_dune(x, w, base_y, 70.0 * k * big, col)
		"Marées":
			# horizon marin : longues vagues, un phare au loin
			_dune(x, w, base_y, 18.0 * k, col)
			if int(h["seed"]) % 7 == 0 and plane == 1:
				draw_rect(Rect2(x + w * 0.5 - 8, base_y - 90, 16, 90), col.darkened(0.1))
				draw_circle(Vector2(x + w * 0.5, base_y - 96), 9.0, Color(1.0, 0.95, 0.6, 0.6 + 0.4 * sin(_t * 2.0)))
		"Rouages":
			_dune(x, w, base_y, 50.0 * k, col)
			if int(h["seed"]) % 2 == 0:
				var ch: float = 170.0 * k * big
				draw_rect(Rect2(x + w * 0.4, base_y - ch, 26, ch), col.darkened(0.08))
				for j: int in range(3):
					var f: float = fmod(_t * 0.25 + float(j) / 3.0 + float(int(h["seed"]) % 10) * 0.1, 1.0)
					draw_circle(Vector2(x + w * 0.4 + 13 + f * 40.0, base_y - ch - 20.0 - f * 120.0), 14.0 + f * 26.0, Color(0.85, 0.85, 0.85, 0.30 * (1.0 - f)))
		"Donjon":
			_dune(x, w, base_y, 40.0 * k, col)
			if int(h["seed"]) % 3 == 0:
				var th: float = 200.0 * k * big
				draw_rect(Rect2(x + w * 0.3, base_y - th, 44, th), col.darkened(0.12))
				draw_colored_polygon(PackedVector2Array([Vector2(x + w * 0.3 - 8, base_y - th), Vector2(x + w * 0.3 + 22, base_y - th - 60), Vector2(x + w * 0.3 + 52, base_y - th)]), col.darkened(0.2))
		_:
			# Forêt et autres : collines rondes couronnées d'arbres
			_dune(x, w, base_y, 110.0 * k * big, col)
			var rng := RandomNumberGenerator.new()
			rng.seed = int(h["seed"])
			for j: int in range(3):
				var tx: float = x + w * rng.randf_range(0.2, 0.8)
				var ty: float = base_y - 110.0 * k * big * 0.85 + rng.randf_range(0.0, 20.0)
				draw_circle(Vector2(tx, ty), rng.randf_range(18.0, 34.0) * big, col.darkened(0.06))


func _dune(x: float, w: float, base_y: float, hgt: float, col: Color) -> void:
	var pts := PackedVector2Array([Vector2(x, base_y)])
	for i: int in range(9):
		var f: float = float(i) / 8.0
		pts.append(Vector2(x + w * f, base_y - sin(f * PI) * hgt))
	pts.append(Vector2(x + w, base_y))
	draw_colored_polygon(pts, col)


func _draw_clouds(alpha_mult: float) -> void:
	for c: Dictionary in _clouds:
		var base := Vector2(float(c["x"]), float(c["y"]))
		var s: float = float(c["s"])
		var a: float = float(c["a"]) * alpha_mult
		for j: int in range(5):
			var o := Vector2((float(j) - 2.0) * 70.0 * s, sin(float(j) * 1.7) * 14.0 * s)
			draw_set_transform(base + o, 0.0, Vector2(1.0, 0.38))
			draw_circle(Vector2.ZERO, (66.0 - absf(float(j) - 2.0) * 10.0) * s, Color(1, 1, 1, a))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


# ── Ciel : soleil, mer de nuages, îlots hauts, oiseaux ─────────────────────────
func _draw_sky() -> void:
	var top_y: float = _cnr("top").y
	var sun := Vector2(-700.0, top_y - 260.0)
	for i: int in range(7):
		var k: float = float(i) / 6.0
		draw_circle(sun, 520.0 - k * 430.0, Color(1.0, 0.96, 0.78, 0.035 + 0.05 * k))
	draw_circle(sun, 70.0, Color(1.0, 0.98, 0.88, 0.9))
	# rayons
	for i: int in range(10):
		var ang: float = 0.3 + float(i) * 0.16 + sin(_t * 0.2) * 0.02
		var d := Vector2(cos(ang), sin(ang))
		draw_colored_polygon(PackedVector2Array([sun, sun + d.rotated(-0.03) * 2600.0, sun + d.rotated(0.03) * 2600.0]), Color(1, 1, 0.92, 0.035))
	_draw_clouds(1.2)
	# îlots lointains en hauteur (avec moulin à vent pour les Vents)
	var rng := RandomNumberGenerator.new()
	rng.seed = 5150
	for i: int in range(5):
		var c := Vector2(rng.randf_range(-1900.0, 1900.0), top_y - rng.randf_range(120.0, 480.0) + sin(_t * 0.4 + float(i)) * 8.0)
		var w: float = rng.randf_range(80.0, 170.0)
		_float_islet(c, w, biome, 0.6, i % 2 == 0)
	# oiseaux
	for b: Dictionary in _birds:
		var bp := Vector2(float(b["x"]), float(b["y"]) + sin(_t * 1.3 + float(b["ph"])) * 10.0)
		var flap: float = sin(_t * 8.0 + float(b["ph"])) * 6.0
		var s: float = float(b["s"])
		draw_polyline(PackedVector2Array([bp + Vector2(-14, -4 - flap) * s, bp, bp + Vector2(14, -4 - flap) * s]), Color(0.25, 0.30, 0.38, 0.6), 2.5, true)
	# mer de nuages sous l'île : bancs épais, du plus loin au plus proche
	var sea_y: float = _cnr("bottom").y + 120.0
	for row: int in range(4):
		var yy: float = sea_y + float(row) * 110.0
		var shade: float = 0.92 - float(row) * 0.04
		var r2 := RandomNumberGenerator.new()
		r2.seed = 300 + row
		var x: float = -2600.0
		while x < 2600.0:
			var rad: float = r2.randf_range(90.0, 170.0)
			var drift: float = sin(_t * 0.15 + x * 0.01 + float(row)) * 18.0
			draw_set_transform(Vector2(x + drift, yy + r2.randf_range(-20.0, 20.0)), 0.0, Vector2(1.0, 0.55))
			draw_circle(Vector2.ZERO, rad, Color(shade, shade + 0.02, 1.0, 0.95))
			draw_circle(Vector2(-rad * 0.25, -rad * 0.3), rad * 0.6, Color(1, 1, 1, 0.9))
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			x += rad * 1.2
		draw_rect(Rect2(-3000, yy + 40.0, 6000, 1600), Color(shade - 0.04, shade, 0.98, 0.95))


# ── Profondeurs : voûte, stalactites, gouffre lumineux ─────────────────────────
func _draw_deep() -> void:
	var glow: Color = _accent(biome)
	if biome == "Brasier":
		glow = Color(1.0, 0.45, 0.12)
	var top_y: float = _cnr("top").y
	var bot_y: float = _cnr("bottom").y
	# lueur du gouffre sous l'île
	for i: int in range(8):
		var k: float = float(i) / 7.0
		draw_set_transform(Vector2(0, bot_y + 420.0), 0.0, Vector2(1.6, 0.6))
		draw_circle(Vector2.ZERO, 1100.0 - k * 900.0, Color(glow.r, glow.g, glow.b, 0.03 + 0.05 * k * (0.85 + 0.15 * sin(_t * 1.2))))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	# puits de lumière tombant d'une ouverture dans la voûte
	var hole := Vector2(380.0, top_y - 700.0)
	draw_colored_polygon(PackedVector2Array([hole + Vector2(-70, 0), hole + Vector2(70, 0), hole + Vector2(420, 1300), hole + Vector2(60, 1300)]),
		Color(1.0, 0.97, 0.85, 0.05 + 0.015 * sin(_t * 0.8)))
	# parois lointaines : colonnes de roche (stalagmites + stalactites reliées)
	var rock: Color = Color(0.10, 0.08, 0.13)
	var rock2: Color = rock.lerp(glow, 0.12)
	var rng := RandomNumberGenerator.new()
	rng.seed = 2024
	for i: int in range(9):
		var cx: float = -2300.0 + float(i) * 560.0 + rng.randf_range(-120.0, 120.0)
		if absf(cx) < 900.0:
			continue
		var w: float = rng.randf_range(120.0, 260.0)
		draw_colored_polygon(PackedVector2Array([Vector2(cx - w, -2200), Vector2(cx + w, -2200), Vector2(cx + w * 0.35, top_y + 120.0),
			Vector2(cx + w * 0.6, 2200), Vector2(cx - w * 0.6, 2200), Vector2(cx - w * 0.35, top_y + 120.0)]), rock2)
	# voûte et stalactites au-dessus de l'île
	var ceil_y: float = top_y + 30.0
	draw_rect(Rect2(-3000, -3000, 6000, 3000 + ceil_y), rock)
	var x: float = -2600.0
	var r2 := RandomNumberGenerator.new()
	r2.seed = 77
	while x < 2600.0:
		var w2: float = r2.randf_range(40.0, 120.0)
		var len: float = r2.randf_range(60.0, 260.0)
		draw_colored_polygon(PackedVector2Array([Vector2(x, ceil_y - 2), Vector2(x + w2, ceil_y - 2), Vector2(x + w2 * 0.5, ceil_y + len)]), rock)
		# gouttes / éclats lumineux au bout
		if r2.randf() < 0.35:
			draw_circle(Vector2(x + w2 * 0.5, ceil_y + len - 6.0), 5.0, Color(glow.r, glow.g, glow.b, 0.5 + 0.4 * sin(_t * 1.5 + x)))
		x += w2 * 0.8
	# décors propres à la Nation sur les parois
	r2.seed = 99
	for i: int in range(14):
		var p := Vector2(r2.randf_range(-2200.0, 2200.0), r2.randf_range(top_y - 200.0, bot_y + 400.0))
		if absf(p.x) < 820.0:
			continue
		match biome:
			"Cristaux":
				var hgt: float = r2.randf_range(40.0, 110.0)
				for j: int in range(3):
					var o: float = (float(j) - 1.0) * 18.0
					draw_colored_polygon(PackedVector2Array([p + Vector2(o - 10, 0), p + Vector2(o + o * 0.3, -hgt * (1.0 - absf(float(j) - 1.0) * 0.35)), p + Vector2(o + 10, 0)]),
						Color(glow.r, glow.g, glow.b, 0.55 + 0.25 * sin(_t * 1.1 + float(i + j))))
			"Brasier":
				# coulée de lave
				var lh: float = r2.randf_range(120.0, 320.0)
				draw_rect(Rect2(p.x - 7, p.y - lh, 14, lh), Color(1.0, 0.5, 0.12, 0.55 + 0.2 * sin(_t * 2.0 + float(i))))
				draw_circle(p, 22.0, Color(1.0, 0.62, 0.2, 0.45))
			_:
				# Ombres : flèches gothiques et flammes violettes
				var sh: float = r2.randf_range(90.0, 200.0)
				draw_colored_polygon(PackedVector2Array([p + Vector2(-16, 0), p + Vector2(0, -sh), p + Vector2(16, 0)]), rock.lightened(0.08))
				draw_circle(p + Vector2(0, -sh * 0.55), 6.0, Color(glow.r, glow.g, glow.b, 0.5 + 0.4 * sin(_t * 3.0 + float(i))))


# ── Cartes voisines au loin ───────────────────────────────────────────────────
func _draw_neighbors() -> void:
	var center := Vector2((_cnr("left").x + _cnr("right").x) * 0.5, (_cnr("top").y + _cnr("bottom").y) * 0.5)
	var half := Vector2((_cnr("right").x - _cnr("left").x) * 0.5, (_cnr("bottom").y - _cnr("top").y) * 0.5)
	# coins visibles autour du losange de l'île : N en haut à droite, E en bas à droite, S en bas à gauche, W en haut à gauche
	var slot := {"N": Vector2(0.80, -0.82), "E": Vector2(1.02, 0.62), "S": Vector2(-1.02, 0.62), "W": Vector2(-0.80, -0.78)}
	for nb: Dictionary in neighbors:
		var sl: Vector2 = slot.get(String(nb["dir"]), Vector2(0.8, 0))
		var anchor: Vector2 = center + Vector2(sl.x * half.x, sl.y * half.y)
		var dl: int = int(nb["layer"]) - layer
		var nbiome: String = String(nb["biome"])
		var bob: float = sin(_t * 0.5 + anchor.x * 0.01) * 6.0
		if dl > 0 and layer == -1:
			# des profondeurs vers la surface / le ciel : une ouverture dans la voûte et son faisceau de lumière
			_light_shaft(anchor + Vector2(0, 160.0), anchor + Vector2(0, -60.0))
		elif dl > 0:
			# plus haut : île au-dessus des nuages, reliée par un courant ascendant
			var top: Vector2 = anchor + Vector2(0, -90.0 + bob)
			_wind_column(anchor + Vector2(0, 140.0), top)
			_float_islet(top, 90.0, nbiome, 0.3, true)
		elif dl < 0 and layer == 1:
			# du ciel vers la terre : île lointaine, très loin sous les nuages
			_float_islet(anchor + Vector2(0, 90.0 + bob), 105.0, nbiome, 0.62, false)
		elif dl < 0:
			# plus bas : entrée de caverne qui s'ouvre sur les profondeurs
			_cave_mouth(anchor + Vector2(0, 20.0), nbiome, 0.5)
		else:
			_float_islet(anchor + Vector2(0, bob), 100.0, nbiome, 0.3, false)


func _float_islet(c: Vector2, w: float, b: String, far: float, mill: bool) -> void:
	var p: Dictionary = BattleScenery.pal(b)
	var mist: Color = _pal()["mist"]
	if layer == -1:
		mist = Color(0.12, 0.10, 0.16)
	var top_c: Color = Color(p["top_a"]).lerp(mist, far)
	var side_c: Color = Color(p["l_t"]).lerp(mist, far + 0.08)
	var pts := PackedVector2Array([c + Vector2(-w, 0), c + Vector2(w, 0)])
	for i: int in range(7):
		var f: float = float(i) / 6.0
		pts.append(c + Vector2(lerpf(w, -w, f) * (1.0 - 0.7 * sin(f * PI * 0.5)), 26.0 + sin(f * PI) * w * 0.6))
	draw_colored_polygon(pts, side_c)
	draw_set_transform(c, 0.0, Vector2(1.0, 0.36))
	draw_circle(Vector2.ZERO, w, top_c)
	draw_circle(Vector2(-w * 0.22, -w * 0.12), w * 0.68, top_c.lightened(0.07))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	var acc: Color = _accent(b).lerp(mist, far * 0.6)
	if mill:
		# petit moulin à vent
		var m := c + Vector2(w * 0.25, -8)
		draw_rect(Rect2(m.x - 6, m.y - 44, 12, 44), side_c.darkened(0.15))
		var ang: float = _t * 1.4
		for k: int in range(4):
			var d := Vector2(cos(ang + float(k) * PI * 0.5), sin(ang + float(k) * PI * 0.5))
			draw_line(m + Vector2(0, -44), m + Vector2(0, -44) + d * 30.0, acc.lightened(0.2), 4.0, true)
	else:
		for k: int in range(3):
			var tx: float = c.x + (float(k) - 1.0) * w * 0.45
			draw_colored_polygon(PackedVector2Array([Vector2(tx - 12, c.y - 4), Vector2(tx, c.y - 46), Vector2(tx + 12, c.y - 4)]), acc)


func _wind_column(from: Vector2, to: Vector2) -> void:
	for i: int in range(6):
		var f: float = fmod(float(i) / 6.0 + _t * 0.18, 1.0)
		var p: Vector2 = from.lerp(to, f) + Vector2(sin(f * TAU * 2.0 + _t) * 30.0, 0)
		draw_set_transform(p, 0.0, Vector2(1.0, 0.35))
		draw_arc(Vector2.ZERO, 40.0 + 20.0 * sin(f * PI), 0.4, 5.6, 24, Color(1, 1, 1, 0.45 * sin(f * PI)), 4.0, true)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _cave_mouth(c: Vector2, b: String, sz: float = 1.0) -> void:
	var glow: Color = _accent(b)
	if b == "Brasier":
		glow = Color(1.0, 0.45, 0.12)
	var rock: Color = Color(0.30, 0.26, 0.24) if layer >= 0 else Color(0.18, 0.15, 0.20)
	# rocher en arche
	var arch: Array = [Vector2(-230, 60), Vector2(-170, -120), Vector2(-40, -190), Vector2(110, -170), Vector2(220, -60), Vector2(250, 60)]
	var pts := PackedVector2Array()
	for v: Vector2 in arch:
		pts.append(c + v * sz)
	draw_colored_polygon(pts, rock)
	draw_colored_polygon(PackedVector2Array([c + Vector2(-230, 60) * sz, c + Vector2(250, 60) * sz, c + Vector2(170, 160) * sz, c + Vector2(-160, 150) * sz]), rock.darkened(0.25))
	# ouverture lumineuse (ellipse)
	draw_set_transform(c + Vector2(0, 10) * sz, 0.0, Vector2(sz, sz * 0.75))
	draw_circle(Vector2.ZERO, 100.0, Color(0.03, 0.02, 0.05))
	for i: int in range(4):
		var k: float = float(i) / 3.0
		draw_circle(Vector2(0, 30), 90.0 - k * 60.0, Color(glow.r, glow.g, glow.b, 0.10 + 0.10 * k * (0.8 + 0.2 * sin(_t * 1.6))))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	# marches qui s'enfoncent
	for st: int in range(4):
		var y: float = c.y + (60.0 - float(st) * 16.0) * sz
		var w: float = (70.0 - float(st) * 12.0) * sz
		draw_line(Vector2(c.x - w, y), Vector2(c.x + w, y), Color(0.55, 0.50, 0.46, 0.8 - float(st) * 0.15), 6.0 * sz)


## Faisceau de lumière qui descend d'une ouverture (profondeurs → surface ou ciel).
func _light_shaft(base: Vector2, top: Vector2) -> void:
	var pulse: float = 0.5 + 0.5 * sin(_t * 0.9)
	draw_colored_polygon(PackedVector2Array([top + Vector2(-26, 0), top + Vector2(26, 0), base + Vector2(60, 0), base + Vector2(-60, 0)]),
		Color(1.0, 0.97, 0.85, 0.10 + 0.05 * pulse))
	draw_set_transform(top, 0.0, Vector2(1.0, 0.4))
	draw_circle(Vector2.ZERO, 34.0, Color(1.0, 0.98, 0.9, 0.55))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _draw_specks() -> void:
	var col: Color = Color(1, 1, 1)
	if layer == -1:
		col = _accent(biome) if biome != "Brasier" else Color(1.0, 0.55, 0.2)
	for s: Dictionary in _specks:
		var tw: float = 0.5 + 0.5 * sin(_t * 1.4 + float(s["ph"]))
		var rise: float = fposmod(_t * float(s["v"]), 120.0)
		var pos := Vector2(float(s["x"]) + sin(_t * 0.2 + float(s["ph"])) * 14.0, float(s["y"]) - rise)
		draw_circle(pos, float(s["r"]), Color(col.r, col.g, col.b, 0.08 + 0.25 * tw))


## Nuages qui passent DEVANT la falaise de l'île (étage du ciel) sans couvrir les cases.
class ForeClouds extends Node2D:
	var land: AdventureLandscape = null

	func _draw() -> void:
		if land == null or land.layer != 1:
			return
		var l: Vector2 = land._cnr("left")
		var b: Vector2 = land._cnr("bottom")
		var r: Vector2 = land._cnr("right")
		var t: float = land._t
		for i: int in range(14):
			var f: float = float(i) / 13.0
			var p: Vector2 = l.lerp(b, f * 2.0) if f < 0.5 else b.lerp(r, (f - 0.5) * 2.0)
			p += Vector2(sin(t * 0.3 + float(i)) * 16.0, 150.0 + 30.0 * sin(float(i) * 2.1))
			draw_set_transform(p, 0.0, Vector2(1.0, 0.5))
			draw_circle(Vector2.ZERO, 95.0 + 25.0 * sin(float(i) * 1.3), Color(0.97, 0.98, 1.0, 0.92))
			draw_circle(Vector2(-30, -26), 60.0, Color(1, 1, 1, 0.95))
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
