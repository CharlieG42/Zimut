class_name NationScenery
extends RefCounted
## NationScenery.gd — Décors dessinés par code des biomes de nation (Cristaux, Marées, Vents,
## Brasier, Brumes, Ombres). Même langage graphique que BattleScenery : origine au pied de
## l'objet, ombre douce, aplats + reflets. `draw()` retourne false quand le type d'élément
## n'est pas géré ici (BattleScenery prend alors le relais).

const OL := Color(0.10, 0.06, 0.12)


static func _poly(ci: CanvasItem, pts: PackedVector2Array, col: Color, hi: Color = Color(0, 0, 0, 0)) -> void:
	ci.draw_colored_polygon(pts, col)
	var closed: PackedVector2Array = pts.duplicate()
	closed.append(pts[0])
	ci.draw_polyline(closed, col.darkened(0.55), 1.8, true)
	if hi.a > 0.0:
		ci.draw_line(pts[0], pts[1], hi, 1.6, true)


static func _crystal(ci: CanvasItem, base: Vector2, h: float, w: float, col: Color, lean: float = 0.0) -> void:
	var tip: Vector2 = base + Vector2(lean, -h)
	var body := PackedVector2Array([base + Vector2(-w, 0), base + Vector2(-w * 0.8, -h * 0.55), tip, base + Vector2(w * 0.8, -h * 0.55), base + Vector2(w, 0)])
	ci.draw_colored_polygon(body, col)
	ci.draw_colored_polygon(PackedVector2Array([base + Vector2(0, 0), tip, base + Vector2(w * 0.8, -h * 0.55), base + Vector2(w, 0)]), col.darkened(0.22))
	ci.draw_colored_polygon(PackedVector2Array([base + Vector2(-w * 0.6, -h * 0.2), base + Vector2(-w * 0.45, -h * 0.55), tip + Vector2(-1, 4)]), col.lightened(0.45))
	var closed: PackedVector2Array = body.duplicate()
	closed.append(body[0])
	ci.draw_polyline(closed, col.darkened(0.6), 1.8, true)

## Roue dentée (polygone à `teeth` dents) centrée sur `c`, pivotée de `rot` radians.
static func _gear(ci: CanvasItem, c: Vector2, r: float, teeth: int, col: Color, rot: float) -> void:
	var pts := PackedVector2Array()
	for i: int in range(teeth * 4):
		var a: float = rot + float(i) / float(teeth * 4) * TAU
		var rr: float = r if (i % 4) < 2 else r * 0.76
		pts.append(c + Vector2(cos(a), sin(a)) * rr)
	ci.draw_colored_polygon(pts, col)
	ci.draw_polyline(pts + PackedVector2Array([pts[0]]), col.darkened(0.45), 1.6, true)


static func draw(ci: CanvasItem, kind: String, p: Dictionary, biome: String, rng: RandomNumberGenerator, t: float) -> bool:
	var leaf: Color = p["leaf"]
	var leaf_hi: Color = p["leaf_hi"]
	var lip: Color = p["lip"]
	match kind:
		# ───────────────────────── Cristaux ─────────────────────────
		"crystal_cluster":
			BattleScenery.soft_shadow(ci, 26.0)
			var cols: Array[Color] = [Color(0.45, 0.85, 1.0), Color(0.70, 0.55, 1.0), Color(0.95, 0.55, 0.90)]
			_crystal(ci, Vector2(-14, 0), rng.randf_range(26, 38), 7.0, cols[0], -3.0)
			_crystal(ci, Vector2(12, 2), rng.randf_range(22, 34), 6.5, cols[2], 3.0)
			_crystal(ci, Vector2(0, 3), rng.randf_range(40, 58), 9.0, cols[1], 1.0)
			ci.draw_circle(Vector2(0, -22), 20.0 + sin(t * 2.0) * 2.0, Color(0.7, 0.6, 1.0, 0.10))
		"amethyst_spire":
			BattleScenery.soft_shadow(ci, 22.0)
			_crystal(ci, Vector2(0, 2), rng.randf_range(62, 84), 11.0, Color(0.62, 0.42, 0.95), 2.0)
			_crystal(ci, Vector2(-14, 4), rng.randf_range(24, 36), 6.0, Color(0.50, 0.80, 1.0), -4.0)
			ci.draw_circle(Vector2(0, -40), 26.0, Color(0.7, 0.5, 1.0, 0.08 + 0.04 * sin(t * 1.7)))
		"glow_orb":
			var bob: float = sin(t * 1.6 + float(rng.seed % 7)) * 4.0
			ci.draw_set_transform(Vector2(0, 2), 0.0, Vector2(1.0, 0.3))
			ci.draw_circle(Vector2.ZERO, 11.0, Color(0, 0, 0, 0.22))
			ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			for i: int in range(4):
				ci.draw_circle(Vector2(0, -26 + bob), 22.0 - float(i) * 5.0, Color(0.6, 0.85, 1.0, 0.07 + 0.06 * float(i)))
			ci.draw_circle(Vector2(0, -26 + bob), 7.0, Color(0.9, 0.98, 1.0))
		"stalagmite":
			BattleScenery.soft_shadow(ci, 20.0)
			for i: int in range(3):
				var sx: float = -10.0 + float(i) * 10.0
				var hh: float = rng.randf_range(24, 48)
				_poly(ci, PackedVector2Array([Vector2(sx - 8, 0), Vector2(sx + 1, -hh), Vector2(sx + 8, 0)]), Color(0.40, 0.36, 0.62).lightened(0.05 * float(i)))
		"crystal_rock":
			BattleScenery.soft_shadow(ci, 22.0)
			_poly(ci, PackedVector2Array([Vector2(-18, 0), Vector2(-14, -16), Vector2(-3, -24), Vector2(12, -18), Vector2(19, 0)]), Color(0.38, 0.34, 0.60), Color(0.7, 0.7, 1.0, 0.6))
			_crystal(ci, Vector2(4, -10), 20.0, 5.0, Color(0.55, 0.88, 1.0), 2.0)
		"crystal_throne":
			BattleScenery.soft_shadow(ci, 50.0, 0.3)
			_poly(ci, PackedVector2Array([Vector2(-42, 0), Vector2(-34, -14), Vector2(34, -14), Vector2(42, 0)]), Color(0.36, 0.32, 0.58))
			_crystal(ci, Vector2(-26, -12), 62.0, 11.0, Color(0.52, 0.80, 1.0), -4.0)
			_crystal(ci, Vector2(26, -12), 54.0, 10.0, Color(0.95, 0.55, 0.90), 4.0)
			_crystal(ci, Vector2(0, -12), 118.0, 18.0, Color(0.66, 0.45, 1.0), 0.0)
			for i: int in range(4):
				ci.draw_circle(Vector2(0, -70), 52.0 - float(i) * 11.0, Color(0.75, 0.6, 1.0, 0.05 + 0.03 * float(i) + 0.02 * sin(t * 1.5)))
		# ───────────────────────── Marées ─────────────────────────
		"coral":
			BattleScenery.soft_shadow(ci, 20.0, 0.2)
			var cc: Array[Color] = [Color(0.96, 0.45, 0.50), Color(1.0, 0.65, 0.40), Color(0.85, 0.40, 0.80)]
			for i: int in range(3):
				var bx: float = -12.0 + float(i) * 12.0
				var col: Color = cc[i]
				var hh2: float = rng.randf_range(24, 44)
				BattleScenery._bar(ci, Vector2(bx, 0), Vector2(bx + rng.randf_range(-4, 4), -hh2), 5.0, col)
				BattleScenery._bar(ci, Vector2(bx, -hh2 * 0.55), Vector2(bx + 8, -hh2 * 0.9), 3.6, col)
				BattleScenery._bar(ci, Vector2(bx, -hh2 * 0.4), Vector2(bx - 8, -hh2 * 0.75), 3.6, col)
				ci.draw_circle(Vector2(bx, -hh2), 3.4, col.lightened(0.3))
		"shell_big":
			BattleScenery.soft_shadow(ci, 22.0, 0.22)
			var sc: Color = Color(0.98, 0.86, 0.82)
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-20, 0), Vector2(-16, -22), Vector2(0, -34), Vector2(16, -22), Vector2(20, 0)]), sc)
			for i: int in range(-3, 4):
				ci.draw_line(Vector2(float(i) * 2.5, -2), Vector2(float(i) * 5.2, -30 + absf(float(i)) * 3.0), Color(0.82, 0.60, 0.55), 1.8, true)
			ci.draw_polyline(PackedVector2Array([Vector2(-20, 0), Vector2(-16, -22), Vector2(0, -34), Vector2(16, -22), Vector2(20, 0), Vector2(-20, 0)]), Color(0.55, 0.38, 0.34), 2.0, true)
		"driftwood":
			BattleScenery.soft_shadow(ci, 30.0, 0.2)
			var wd: Color = Color(0.62, 0.52, 0.42)
			BattleScenery._bar(ci, Vector2(-26, -4), Vector2(24, -12), 8.0, wd)
			BattleScenery._bar(ci, Vector2(-6, -8), Vector2(10, -28), 4.0, wd.darkened(0.1))
			BattleScenery._bar(ci, Vector2(8, -10), Vector2(-4, -22), 3.5, wd.lightened(0.05))
		"anchor":
			BattleScenery.soft_shadow(ci, 22.0, 0.22)
			var ac: Color = Color(0.40, 0.46, 0.50)
			BattleScenery._bar(ci, Vector2(0, 0), Vector2(0, -42), 5.0, ac)
			BattleScenery._bar(ci, Vector2(-9, -34), Vector2(9, -34), 4.0, ac)
			ci.draw_arc(Vector2(0, -12), 18.0, 0.15, PI - 0.15, 14, ac.darkened(0.45), 7.0, true)
			ci.draw_arc(Vector2(0, -12), 18.0, 0.15, PI - 0.15, 14, ac, 4.5, true)
			ci.draw_arc(Vector2(0, -46), 5.0, 0.0, TAU, 12, Color(0.72, 0.52, 0.28), 2.5, true)
		"net_posts":
			BattleScenery.soft_shadow(ci, 30.0, 0.2)
			var pw: Color = Color(0.58, 0.44, 0.30)
			for sx2: float in [-24.0, 24.0]:
				BattleScenery._bar(ci, Vector2(sx2, 0), Vector2(sx2, -44), 6.0, pw)
			for k: int in range(4):
				var yy: float = -40.0 + float(k) * 8.0
				ci.draw_line(Vector2(-24, yy), Vector2(24, yy + 6.0), Color(0.9, 0.88, 0.78, 0.8), 1.4, true)
			for k2: int in range(7):
				ci.draw_line(Vector2(-22.0 + float(k2) * 7.5, -42), Vector2(-20.0 + float(k2) * 7.5, -12), Color(0.9, 0.88, 0.78, 0.7), 1.2, true)
		"tide_rock":
			BattleScenery.soft_shadow(ci, 24.0)
			_poly(ci, PackedVector2Array([Vector2(-20, 0), Vector2(-17, -17), Vector2(-4, -26), Vector2(12, -20), Vector2(21, 0)]), Color(0.46, 0.52, 0.56), Color(0.85, 0.95, 1.0, 0.6))
			ci.draw_set_transform(Vector2(0, -3), 0.0, Vector2(1.0, 0.35))
			ci.draw_circle(Vector2.ZERO, 22.0, Color(0.35, 0.78, 0.85, 0.28))
			ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			ci.draw_circle(Vector2(-8, -8), 3.0, Color(0.35, 0.62, 0.38))
		"lighthouse":
			BattleScenery.soft_shadow(ci, 36.0, 0.3)
			_poly(ci, PackedVector2Array([Vector2(-18, 0), Vector2(-11, -86), Vector2(11, -86), Vector2(18, 0)]), Color(0.94, 0.92, 0.86))
			for i: int in range(3):
				var y0: float = -14.0 - float(i) * 26.0
				ci.draw_colored_polygon(PackedVector2Array([Vector2(-17.0 + float(i) * 2.0, y0), Vector2(17.0 - float(i) * 2.0, y0), Vector2(16.0 - float(i) * 2.0, y0 - 11.0), Vector2(-16.0 + float(i) * 2.0, y0 - 11.0)]), Color(0.86, 0.30, 0.28))
			ci.draw_rect(Rect2(-14, -96, 28, 10), Color(0.30, 0.34, 0.42))
			ci.draw_rect(Rect2(-10, -108, 20, 12), Color(1.0, 0.92, 0.55))
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-14, -108), Vector2(0, -124), Vector2(14, -108)]), Color(0.86, 0.30, 0.28))
			for i2: int in range(4):
				ci.draw_circle(Vector2(0, -102), 34.0 - float(i2) * 7.0, Color(1.0, 0.95, 0.6, 0.05 + 0.03 * float(i2) + 0.02 * sin(t * 2.0)))
		# ───────────────────────── Vents ─────────────────────────
		"wind_totem":
			BattleScenery.soft_shadow(ci, 20.0)
			var tw: Color = Color(0.74, 0.66, 0.54)
			_poly(ci, PackedVector2Array([Vector2(-8, 0), Vector2(-7, -60), Vector2(7, -60), Vector2(8, 0)]), tw)
			for i: int in range(3):
				var y1: float = -14.0 - float(i) * 17.0
				ci.draw_line(Vector2(-6, y1), Vector2(6, y1), Color(0.35, 0.55, 0.62), 2.4)
				ci.draw_circle(Vector2(0, y1 - 6), 2.4, Color(0.4, 0.7, 0.8))
			for k: int in range(3):
				var sway: float = sin(t * 2.0 + float(k)) * 4.0
				BattleScenery._bar(ci, Vector2(0, -58), Vector2(-14 + sway, -42 - float(k) * 6.0), 2.6, Color(1, 1, 1))
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-8, -60), Vector2(0, -70), Vector2(8, -60)]), Color(0.45, 0.72, 0.82))
		"cloud_puff":
			for i: int in range(3):
				var bx2: float = -16.0 + float(i) * 16.0
				BattleScenery.blob(ci, Vector2(bx2, -12 - sin(t + float(i)) * 2.0), 12.0 + float(i % 2) * 3.0, Color(0.96, 0.98, 1.0), Color(1, 1, 1))
			ci.draw_set_transform(Vector2(0, 3), 0.0, Vector2(1.0, 0.3))
			ci.draw_circle(Vector2.ZERO, 26.0, Color(0, 0, 0, 0.12))
			ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		"feather_banner":
			BattleScenery.soft_shadow(ci, 16.0, 0.2)
			BattleScenery._bar(ci, Vector2(0, 0), Vector2(0, -64), 4.5, Color(0.72, 0.62, 0.48))
			for i: int in range(4):
				var fl: float = sin(t * 2.4 + float(i) * 0.6) * 5.0
				var fy: float = -60.0 + float(i) * 6.5
				ci.draw_colored_polygon(PackedVector2Array([Vector2(1, fy), Vector2(26 + fl, fy + 3.0), Vector2(1, fy + 6.0)]), Color(0.45, 0.78, 0.88).lerp(Color(1, 1, 1), float(i) * 0.15))
		"stone_ring":
			BattleScenery.soft_shadow(ci, 34.0, 0.2)
			for i: int in range(6):
				var ang: float = float(i) / 6.0 * TAU
				var sp := Vector2(cos(ang) * 28.0, sin(ang) * 11.0)
				_poly(ci, PackedVector2Array([sp + Vector2(-6, 0), sp + Vector2(-5, -24), sp + Vector2(5, -24), sp + Vector2(6, 0)]), Color(0.72, 0.78, 0.80))
			for k: int in range(3):
				ci.draw_arc(Vector2(0, -26), 6.0 + float(k) * 7.0 + fposmod(t * 8.0, 7.0), 0.0, TAU, 20, Color(0.8, 0.95, 1.0, 0.35 - float(k) * 0.1), 1.4, true)
		"cyclone":
			for k: int in range(6):
				var f: float = float(k) / 5.0
				var rr: float = 6.0 + f * 16.0
				var yy2: float = -f * 52.0
				ci.draw_arc(Vector2(sin(t * 1.5 + f * 4.0) * 3.0, yy2), rr, 0.0, PI * 1.5, 14, Color(0.92, 0.98, 1.0, 0.75 - f * 0.4), 3.0, true)
			ci.draw_set_transform(Vector2(0, 2), 0.0, Vector2(1.0, 0.3))
			ci.draw_circle(Vector2.ZERO, 14.0, Color(0, 0, 0, 0.14))
			ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		"windmill":
			BattleScenery.soft_shadow(ci, 24.0)
			_poly(ci, PackedVector2Array([Vector2(-14, 0), Vector2(-9, -46), Vector2(9, -46), Vector2(14, 0)]), Color(0.92, 0.88, 0.78))
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-12, -46), Vector2(0, -60), Vector2(12, -46)]), Color(0.45, 0.62, 0.78))
			for k: int in range(4):
				var a: float = t * 1.4 + float(k) * PI * 0.5
				var tip := Vector2(0, -46) + Vector2(cos(a), sin(a)) * 26.0
				BattleScenery._bar(ci, Vector2(0, -46), tip, 3.0, Color(0.7, 0.6, 0.45))
				ci.draw_circle(tip, 3.5, Color(1, 1, 1, 0.85))
		"cloud_rock":
			BattleScenery.soft_shadow(ci, 22.0)
			_poly(ci, PackedVector2Array([Vector2(-18, 0), Vector2(-16, -16), Vector2(-3, -24), Vector2(13, -18), Vector2(19, 0)]), Color(0.62, 0.70, 0.74), Color(1, 1, 1, 0.7))
			BattleScenery.blob(ci, Vector2(-4, -26), 9.0, Color(0.98, 1.0, 1.0), Color(1, 1, 1))
		"wind_arch":
			BattleScenery.soft_shadow(ci, 46.0, 0.28)
			var st: Color = Color(0.78, 0.84, 0.86)
			_poly(ci, PackedVector2Array([Vector2(-44, 0), Vector2(-42, -90), Vector2(-26, -90), Vector2(-24, 0)]), st)
			_poly(ci, PackedVector2Array([Vector2(24, 0), Vector2(26, -90), Vector2(42, -90), Vector2(44, 0)]), st)
			ci.draw_arc(Vector2(0, -90), 34.0, PI, TAU, 22, st.darkened(0.5), 17.0, true)
			ci.draw_arc(Vector2(0, -90), 34.0, PI, TAU, 22, st, 13.0, true)
			for k: int in range(5):
				var f2: float = float(k) / 4.0
				var yy3: float = -30.0 - f2 * 40.0 + sin(t * 2.0 + f2 * 5.0) * 3.0
				ci.draw_line(Vector2(-14, yy3), Vector2(14, yy3 - 3.0), Color(1, 1, 1, 0.55), 2.0, true)
		# ───────────────────────── Brasier ─────────────────────────
		"obsidian_spike":
			BattleScenery.soft_shadow(ci, 20.0)
			for i: int in range(3):
				var sx3: float = -10.0 + float(i) * 10.0
				var hh3: float = rng.randf_range(34, 64)
				_poly(ci, PackedVector2Array([Vector2(sx3 - 7, 0), Vector2(sx3 + rng.randf_range(-3, 3), -hh3), Vector2(sx3 + 7, 0)]), Color(0.16, 0.12, 0.20), Color(0.8, 0.5, 0.9, 0.6))
			ci.draw_line(Vector2(-3, -6), Vector2(2, -22), Color(1.0, 0.45, 0.1, 0.8), 1.8, true)
		"lava_rock":
			BattleScenery.soft_shadow(ci, 24.0)
			_poly(ci, PackedVector2Array([Vector2(-19, 0), Vector2(-16, -17), Vector2(-3, -26), Vector2(13, -19), Vector2(20, 0)]), Color(0.22, 0.16, 0.16), Color(0.7, 0.4, 0.3, 0.5))
			var glow: float = 0.65 + 0.35 * sin(t * 2.2 + float(rng.seed % 5))
			ci.draw_polyline(PackedVector2Array([Vector2(-10, -4), Vector2(-4, -12), Vector2(2, -9), Vector2(8, -17)]), Color(1.0, 0.55, 0.12, glow), 2.6, true)
			ci.draw_polyline(PackedVector2Array([Vector2(-10, -4), Vector2(-4, -12), Vector2(2, -9), Vector2(8, -17)]), Color(1.0, 0.9, 0.5, glow), 1.0, true)
		"brazier":
			BattleScenery.soft_shadow(ci, 18.0)
			BattleScenery._bar(ci, Vector2(-8, 0), Vector2(-4, -22), 4.0, Color(0.25, 0.2, 0.2))
			BattleScenery._bar(ci, Vector2(8, 0), Vector2(4, -22), 4.0, Color(0.25, 0.2, 0.2))
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-13, -22), Vector2(13, -22), Vector2(9, -32), Vector2(-9, -32)]), Color(0.32, 0.25, 0.24))
			for i: int in range(3):
				var fl2: float = sin(t * 7.0 + float(i) * 2.0) * 2.0
				ci.draw_colored_polygon(PackedVector2Array([Vector2(-6 + float(i) * 6.0, -32), Vector2(-4 + float(i) * 6.0 + fl2, -52 + float(i % 2) * 6.0), Vector2(-1 + float(i) * 6.0, -32)]), Color(1.0, 0.55 + 0.2 * float(i), 0.12))
			ci.draw_circle(Vector2(0, -38), 22.0, Color(1.0, 0.5, 0.15, 0.10 + 0.04 * sin(t * 5.0)))
		"smoke_vent":
			BattleScenery.soft_shadow(ci, 18.0)
			_poly(ci, PackedVector2Array([Vector2(-14, 0), Vector2(-8, -12), Vector2(8, -12), Vector2(14, 0)]), Color(0.26, 0.19, 0.18))
			ci.draw_circle(Vector2(0, -12), 6.0, Color(1.0, 0.5, 0.12, 0.8))
			for i: int in range(4):
				var f3: float = fposmod(t * 0.5 + float(i) * 0.25, 1.0)
				ci.draw_circle(Vector2(sin(f3 * 6.0 + float(i)) * 6.0, -14.0 - f3 * 54.0), 6.0 + f3 * 10.0, Color(0.30, 0.26, 0.26, 0.5 * (1.0 - f3)))
		"charred_tree":
			BattleScenery.soft_shadow(ci, 22.0)
			var ch: Color = Color(0.16, 0.12, 0.12)
			BattleScenery._bar(ci, Vector2(0, 0), Vector2(2, -52), 9.0, ch)
			BattleScenery._bar(ci, Vector2(1, -34), Vector2(-18, -56), 5.0, ch)
			BattleScenery._bar(ci, Vector2(2, -42), Vector2(18, -62), 5.0, ch)
			BattleScenery._bar(ci, Vector2(-14, -50), Vector2(-24, -58), 3.0, ch)
			ci.draw_circle(Vector2(-18, -56), 2.4, Color(1.0, 0.5, 0.15, 0.7 + 0.3 * sin(t * 4.0)))
			ci.draw_circle(Vector2(18, -62), 2.4, Color(1.0, 0.5, 0.15, 0.7 + 0.3 * sin(t * 4.5)))
		"volcano_cone":
			BattleScenery.soft_shadow(ci, 54.0, 0.3)
			_poly(ci, PackedVector2Array([Vector2(-60, 0), Vector2(-16, -92), Vector2(16, -92), Vector2(60, 0)]), Color(0.26, 0.19, 0.19), Color(0.8, 0.5, 0.4, 0.5))
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-16, -92), Vector2(-10, -100), Vector2(10, -100), Vector2(16, -92)]), Color(1.0, 0.45, 0.10))
			ci.draw_polyline(PackedVector2Array([Vector2(-6, -92), Vector2(-14, -60), Vector2(-8, -30), Vector2(-20, 0)]), Color(1.0, 0.5, 0.12, 0.9), 3.0, true)
			ci.draw_polyline(PackedVector2Array([Vector2(6, -92), Vector2(12, -64), Vector2(6, -34), Vector2(16, 0)]), Color(1.0, 0.5, 0.12, 0.9), 3.0, true)
			for i: int in range(5):
				var f4: float = fposmod(t * 0.35 + float(i) * 0.2, 1.0)
				ci.draw_circle(Vector2(sin(f4 * 5.0 + float(i)) * 12.0, -100.0 - f4 * 70.0), 8.0 + f4 * 16.0, Color(0.35, 0.3, 0.3, 0.45 * (1.0 - f4)))
		# ───────────────────────── Brumes ─────────────────────────
		"mushroom_big":
			BattleScenery.soft_shadow(ci, 24.0, 0.22)
			var mc: Color = Color(0.62, 0.85, 0.95) if rng.randf() < 0.5 else Color(0.80, 0.62, 0.95)
			BattleScenery._bar(ci, Vector2(0, 0), Vector2(0, -24), 8.0, Color(0.92, 0.9, 0.8))
			ci.draw_set_transform(Vector2(0, -26), 0.0, Vector2(1.0, 0.62))
			ci.draw_circle(Vector2.ZERO, 22.0, mc.darkened(0.3))
			ci.draw_circle(Vector2(0, -2), 19.0, mc)
			ci.draw_circle(Vector2(-6, -8), 6.0, mc.lightened(0.35))
			ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
			for i: int in range(3):
				ci.draw_circle(Vector2(-8.0 + float(i) * 8.0, -28.0 + float(i % 2) * 4.0), 2.2, Color(1, 1, 1, 0.9))
			ci.draw_circle(Vector2(0, -26), 30.0, Color(mc.r, mc.g, mc.b, 0.09 + 0.04 * sin(t * 2.0)))
		"dead_tree":
			BattleScenery.soft_shadow(ci, 24.0)
			var dw: Color = Color(0.36, 0.32, 0.30)
			BattleScenery._bar(ci, Vector2(0, 0), Vector2(-2, -60), 9.0, dw)
			BattleScenery._bar(ci, Vector2(-2, -38), Vector2(-24, -62), 5.0, dw)
			BattleScenery._bar(ci, Vector2(-2, -48), Vector2(20, -72), 5.0, dw)
			BattleScenery._bar(ci, Vector2(-16, -54), Vector2(-26, -50), 3.0, dw)
			for i: int in range(3):
				var mx2: float = -22.0 + float(i) * 14.0
				ci.draw_line(Vector2(mx2, -58), Vector2(mx2 + sin(t + float(i)) * 3.0, -36), Color(0.62, 0.85, 0.72, 0.7), 2.4, true)
		"wisp_lantern":
			BattleScenery.soft_shadow(ci, 14.0, 0.2)
			BattleScenery._bar(ci, Vector2(0, 0), Vector2(0, -44), 3.6, Color(0.42, 0.34, 0.28))
			BattleScenery._bar(ci, Vector2(0, -44), Vector2(12, -50), 3.0, Color(0.42, 0.34, 0.28))
			var wob: float = sin(t * 3.0 + float(rng.seed % 9)) * 2.0
			for i: int in range(4):
				ci.draw_circle(Vector2(12, -40 + wob), 18.0 - float(i) * 4.0, Color(0.6, 1.0, 0.85, 0.07 + 0.07 * float(i)))
			ci.draw_circle(Vector2(12, -40 + wob), 4.5, Color(0.92, 1.0, 0.95))
		"fog_puff":
			for i: int in range(4):
				var fo := Vector2(-18.0 + float(i) * 12.0, -6.0 - sin(t * 0.8 + float(i)) * 3.0)
				ci.draw_set_transform(fo, 0.0, Vector2(1.0, 0.5))
				ci.draw_circle(Vector2.ZERO, 16.0, Color(0.92, 1.0, 0.96, 0.32))
				ci.draw_circle(Vector2(-3, -3), 10.0, Color(1, 1, 1, 0.3))
			ci.draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		"spirit_tree":
			BattleScenery.soft_shadow(ci, 46.0, 0.3)
			var tr: Color = Color(0.40, 0.36, 0.34)
			_poly(ci, PackedVector2Array([Vector2(-18, 0), Vector2(-10, -50), Vector2(-6, -100), Vector2(6, -100), Vector2(10, -50), Vector2(18, 0)]), tr)
			BattleScenery._bar(ci, Vector2(-6, -80), Vector2(-40, -110), 7.0, tr)
			BattleScenery._bar(ci, Vector2(6, -84), Vector2(42, -116), 7.0, tr)
			BattleScenery._bar(ci, Vector2(0, -98), Vector2(2, -130), 6.0, tr)
			for k: int in range(7):
				var lx: float = -38.0 + float(k) * 12.5
				ci.draw_line(Vector2(lx, -104 + float(k % 3) * 6.0), Vector2(lx + sin(t * 1.4 + float(k)) * 3.0, -62 - float(k % 2) * 10.0), Color(0.65, 0.92, 0.80, 0.8), 3.0, true)
			ci.draw_circle(Vector2(0, -60), 14.0, Color(0.7, 1.0, 0.85, 0.35 + 0.15 * sin(t * 2.0)))
			ci.draw_circle(Vector2(0, -60), 5.0, Color(0.95, 1.0, 0.98))
		# ───────────────────────── Ombres ─────────────────────────
		"gravestone":
			BattleScenery.soft_shadow(ci, 18.0)
			var gs: Color = Color(0.48, 0.45, 0.58)
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-12, 0), Vector2(-12, -30), Vector2(-8, -38), Vector2(8, -38), Vector2(12, -30), Vector2(12, 0)]), gs)
			ci.draw_polyline(PackedVector2Array([Vector2(-12, 0), Vector2(-12, -30), Vector2(-8, -38), Vector2(8, -38), Vector2(12, -30), Vector2(12, 0)]), gs.darkened(0.55), 2.0, true)
			ci.draw_line(Vector2(0, -32), Vector2(0, -14), Color(0.75, 0.55, 1.0, 0.85), 2.2, true)
			ci.draw_line(Vector2(-6, -26), Vector2(6, -26), Color(0.75, 0.55, 1.0, 0.85), 2.2, true)
		"dark_spire":
			BattleScenery.soft_shadow(ci, 20.0)
			_poly(ci, PackedVector2Array([Vector2(-11, 0), Vector2(-6, -52), Vector2(0, -88), Vector2(6, -52), Vector2(11, 0)]), Color(0.20, 0.15, 0.30), Color(0.7, 0.5, 1.0, 0.6))
			_poly(ci, PackedVector2Array([Vector2(8, 0), Vector2(14, -30), Vector2(20, 0)]), Color(0.24, 0.18, 0.34))
			ci.draw_circle(Vector2(0, -60), 16.0, Color(0.6, 0.35, 1.0, 0.08 + 0.05 * sin(t * 2.0)))
		"purple_torch":
			BattleScenery.soft_shadow(ci, 14.0, 0.2)
			BattleScenery._bar(ci, Vector2(0, 0), Vector2(0, -34), 5.0, Color(0.30, 0.24, 0.36))
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-6, -34), Vector2(6, -34), Vector2(4, -40), Vector2(-4, -40)]), Color(0.4, 0.32, 0.5))
			for i: int in range(3):
				var fl3: float = sin(t * 6.0 + float(i) * 2.0) * 2.0
				ci.draw_colored_polygon(PackedVector2Array([Vector2(-5 + float(i) * 5.0, -40), Vector2(-3 + float(i) * 5.0 + fl3, -58 + float(i % 2) * 5.0), Vector2(float(i) * 5.0, -40)]), Color(0.72, 0.45, 1.0).lightened(0.12 * float(i)))
			ci.draw_circle(Vector2(0, -46), 20.0, Color(0.65, 0.4, 1.0, 0.10 + 0.04 * sin(t * 4.0)))
		"thorn_bush":
			BattleScenery.soft_shadow(ci, 26.0, 0.22)
			for i: int in range(9):
				var a2: float = -PI * 0.5 + (float(i) - 4.0) * 0.32
				var L: float = rng.randf_range(20.0, 38.0)
				var tip2 := Vector2(cos(a2), sin(a2)) * L + Vector2(0, -4)
				BattleScenery._bar(ci, Vector2(0, -2), tip2, 3.0, Color(0.30, 0.18, 0.40))
				ci.draw_colored_polygon(PackedVector2Array([tip2 + Vector2(-2, 0), tip2 + Vector2(cos(a2), sin(a2)) * 8.0, tip2 + Vector2(2, 0)]), Color(0.65, 0.40, 0.90))
			ci.draw_circle(Vector2(0, -8), 3.0, Color(0.85, 0.55, 1.0, 0.8 + 0.2 * sin(t * 3.0)))
		"raven_perch":
			BattleScenery.soft_shadow(ci, 16.0, 0.2)
			BattleScenery._bar(ci, Vector2(0, 0), Vector2(0, -40), 4.5, Color(0.28, 0.22, 0.32))
			BattleScenery._bar(ci, Vector2(-14, -40), Vector2(14, -42), 3.4, Color(0.28, 0.22, 0.32))
			var rv: Vector2 = Vector2(4, -50)
			ci.draw_circle(rv, 8.0, Color(0.10, 0.08, 0.14))
			ci.draw_circle(rv + Vector2(-7, -5), 4.6, Color(0.10, 0.08, 0.14))
			ci.draw_colored_polygon(PackedVector2Array([rv + Vector2(-11, -5), rv + Vector2(-17, -3), rv + Vector2(-11, -2)]), Color(0.95, 0.7, 0.3))
			ci.draw_circle(rv + Vector2(-8, -6), 1.1, Color(0.9, 0.7, 1.0))
		"cracked_obelisk":
			BattleScenery.soft_shadow(ci, 22.0)
			_poly(ci, PackedVector2Array([Vector2(-12, 0), Vector2(-9, -70), Vector2(0, -80), Vector2(9, -70), Vector2(12, 0)]), Color(0.30, 0.25, 0.40), Color(0.7, 0.55, 1.0, 0.5))
			ci.draw_polyline(PackedVector2Array([Vector2(-2, -76), Vector2(3, -56), Vector2(-4, -40), Vector2(2, -20)]), Color(0.7, 0.45, 1.0, 0.85), 2.0, true)
			for i: int in range(3):
				ci.draw_circle(Vector2(0, -58.0 + float(i) * 16.0), 2.0, Color(0.8, 0.6, 1.0, 0.6 + 0.3 * sin(t * 2.0 + float(i))))
		"dark_gate":
			BattleScenery.soft_shadow(ci, 50.0, 0.3)
			var dg: Color = Color(0.24, 0.19, 0.34)
			_poly(ci, PackedVector2Array([Vector2(-46, 0), Vector2(-44, -100), Vector2(-28, -106), Vector2(-26, 0)]), dg)
			_poly(ci, PackedVector2Array([Vector2(26, 0), Vector2(28, -106), Vector2(44, -100), Vector2(46, 0)]), dg)
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-28, -106), Vector2(-26, -94), Vector2(26, -94), Vector2(28, -106), Vector2(0, -122)]), dg.darkened(0.1))
			ci.draw_rect(Rect2(-26, -92, 52, 92), Color(0.12, 0.07, 0.22))
			for i: int in range(5):
				ci.draw_circle(Vector2(0, -50), 46.0 - float(i) * 8.0, Color(0.55, 0.3, 0.95, 0.04 + 0.03 * float(i) + 0.02 * sin(t * 1.8)))
			ci.draw_line(Vector2(-35, -80), Vector2(-35, -30), Color(0.75, 0.55, 1.0, 0.8), 2.0, true)
			ci.draw_line(Vector2(35, -80), Vector2(35, -30), Color(0.75, 0.55, 1.0, 0.8), 2.0, true)
		# ───────────────────────── Rouages ─────────────────────────
		"cog_wheel":
			BattleScenery.soft_shadow(ci, 24.0, 0.25)
			_gear(ci, Vector2(0, -26), 24.0, 10, Color(0.62, 0.45, 0.26), t * 0.5)
			_gear(ci, Vector2(0, -26), 11.0, 6, Color(0.30, 0.24, 0.20), -t * 0.5)
			ci.draw_circle(Vector2(0, -26), 4.0, Color(0.95, 0.75, 0.35))
		"steam_pipe":
			BattleScenery.soft_shadow(ci, 18.0, 0.22)
			BattleScenery._bar(ci, Vector2(0, 0), Vector2(0, -44), 11.0, Color(0.48, 0.42, 0.38))
			BattleScenery._bar(ci, Vector2(0, -44), Vector2(16, -44), 11.0, Color(0.48, 0.42, 0.38))
			ci.draw_rect(Rect2(-8, -20, 16, 5), Color(0.72, 0.50, 0.24))
			for i: int in range(3):
				var ph: float = fmod(t * 0.7 + float(i) * 0.33, 1.0)
				ci.draw_circle(Vector2(16.0 + ph * 8.0, -50.0 - ph * 26.0), 5.0 + ph * 7.0, Color(0.92, 0.92, 0.95, 0.45 * (1.0 - ph)))
		"gear_tower":
			BattleScenery.soft_shadow(ci, 24.0, 0.28)
			_poly(ci, PackedVector2Array([Vector2(-16, 0), Vector2(-11, -64), Vector2(11, -64), Vector2(16, 0)]), Color(0.38, 0.34, 0.32), Color(0.9, 0.62, 0.28, 0.5))
			ci.draw_rect(Rect2(-14, -40, 28, 5), Color(0.72, 0.50, 0.24))
			_gear(ci, Vector2(0, -72), 15.0, 8, Color(0.70, 0.50, 0.26), t * 0.6)
			ci.draw_circle(Vector2(0, -72), 4.0, Color(0.20, 0.17, 0.15))
		"anvil":
			BattleScenery.soft_shadow(ci, 20.0, 0.25)
			ci.draw_rect(Rect2(-9, -10, 18, 10), Color(0.30, 0.26, 0.24))
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-22, -16), Vector2(18, -16), Vector2(26, -22), Vector2(-14, -22)]), Color(0.52, 0.52, 0.58))
			ci.draw_rect(Rect2(-14, -16, 28, 6), Color(0.40, 0.40, 0.46))
			ci.draw_circle(Vector2(8.0, -24.0), 2.5 + 1.2 * sin(t * 7.0), Color(1.0, 0.8, 0.3, 0.8))
		"tesla_coil":
			BattleScenery.soft_shadow(ci, 20.0, 0.25)
			ci.draw_rect(Rect2(-14, -12, 28, 12), Color(0.34, 0.30, 0.28))
			BattleScenery._bar(ci, Vector2(0, -12), Vector2(0, -56), 9.0, Color(0.72, 0.50, 0.24))
			for k: int in range(4):
				ci.draw_line(Vector2(-9, -20.0 - float(k) * 9.0), Vector2(9, -20.0 - float(k) * 9.0), Color(0.45, 0.30, 0.16), 2.0, true)
			ci.draw_circle(Vector2(0, -62), 10.0, Color(0.75, 0.80, 0.90))
			ci.draw_circle(Vector2(0, -62), 22.0 + 3.0 * sin(t * 5.0), Color(0.55, 0.75, 1.0, 0.14))
			var arc: float = sin(t * 9.0)
			ci.draw_polyline(PackedVector2Array([Vector2(0, -62), Vector2(10.0 + arc * 4.0, -70), Vector2(4, -78), Vector2(16.0 + arc * 5.0, -84)]), Color(0.7, 0.9, 1.0, 0.85), 2.0, true)
		"scrap_pile":
			BattleScenery.soft_shadow(ci, 24.0, 0.25)
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-22, 0), Vector2(-14, -18), Vector2(-2, -26), Vector2(12, -20), Vector2(22, 0)]), Color(0.36, 0.32, 0.30))
			ci.draw_colored_polygon(PackedVector2Array([Vector2(-10, -8), Vector2(0, -22), Vector2(14, -6)]), Color(0.58, 0.40, 0.22))
			_gear(ci, Vector2(8, -12), 8.0, 6, Color(0.62, 0.62, 0.68), 0.4)
			ci.draw_line(Vector2(-18, -4), Vector2(-4, -16), Color(0.75, 0.55, 0.30), 2.2, true)
		"workshop_crane":
			BattleScenery.soft_shadow(ci, 44.0, 0.3)
			var wc: Color = Color(0.36, 0.32, 0.30)
			BattleScenery._bar(ci, Vector2(-30, 0), Vector2(-30, -110), 10.0, wc)
			BattleScenery._bar(ci, Vector2(-30, -108), Vector2(40, -108), 8.0, Color(0.72, 0.50, 0.24))
			ci.draw_line(Vector2(34, -108), Vector2(34, -64.0 + 4.0 * sin(t * 1.2)), Color(0.8, 0.8, 0.85), 2.0, true)
			ci.draw_rect(Rect2(24, -64.0 + 4.0 * sin(t * 1.2), 20, 14), Color(0.55, 0.38, 0.22))
			_gear(ci, Vector2(-30, -112), 14.0, 8, Color(0.82, 0.60, 0.30), t * 0.5)
			ci.draw_rect(Rect2(-12, -34, 38, 34), Color(0.30, 0.27, 0.26))
			ci.draw_rect(Rect2(-6, -26, 10, 12), Color(1.0, 0.7, 0.3, 0.8 + 0.2 * sin(t * 3.0)))
		_:
			return false
	return true
