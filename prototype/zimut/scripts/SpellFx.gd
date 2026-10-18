class_name SpellFx
extends RefCounted
## SpellFx.gd — Éléments des sorts et petits nœuds d'effets visuels dessinés par code
## (anneaux, éclairs, entailles, flèches, éclats, piliers de lumière, runes).
## GridManager les crée dans sa couche d'effets ; chacun se détruit seul.

const ELEMENTS := {
	"fire":      {"col": Color(1.00, 0.45, 0.12), "col2": Color(1.00, 0.86, 0.30)},
	"ice":       {"col": Color(0.55, 0.85, 1.00), "col2": Color(1.00, 1.00, 1.00)},
	"lightning": {"col": Color(0.65, 0.78, 1.00), "col2": Color(1.00, 1.00, 0.80)},
	"poison":    {"col": Color(0.55, 0.90, 0.28), "col2": Color(0.62, 0.30, 0.80)},
	"shadow":    {"col": Color(0.52, 0.26, 0.78), "col2": Color(0.16, 0.06, 0.28)},
	"holy":      {"col": Color(1.00, 0.95, 0.55), "col2": Color(1.00, 1.00, 1.00)},
	"nature":    {"col": Color(0.42, 0.85, 0.32), "col2": Color(0.80, 1.00, 0.50)},
	"earth":     {"col": Color(0.72, 0.52, 0.30), "col2": Color(0.50, 0.36, 0.20)},
	"water":     {"col": Color(0.30, 0.65, 1.00), "col2": Color(0.72, 0.92, 1.00)},
	"arcane":    {"col": Color(0.62, 0.50, 1.00), "col2": Color(0.92, 0.82, 1.00)},
	"physical":  {"col": Color(1.00, 0.88, 0.55), "col2": Color(1.00, 1.00, 1.00)},
}

## Mots-clés (sans accents, minuscules) -> élément. L'ordre compte (premier trouvé).
const KEYWORDS: Array = [
	["ice", ["gel", "glace", "givre"]],
	["lightning", ["eclair", "foudre", "tonnerre", "orage"]],
	["fire", ["feu", "flamm", "enflamme", "meteor", "explosion", "apocalypse", "brul", "desintegration", "incendi"]],
	["poison", ["poison", "venin", "empoison", "spore"]],
	["shadow", ["ombre", "assassin", "fatale", "mortel", "mort", "malediction", "invisib", "camouflage",
		"coup bas", "eviscer", "clignot", "spectral"]],
	["holy", ["soin", "sacre", "lumiere", "benedic", "benit", "divin", "ange", "resurrection", "renaissance",
		"purif", "jugement", "celeste", "restauration", "eclat", "guerisseur", "inspiration", "vie"]],
	["nature", ["entrave", "ronce", "seve", "racine", "lierre", "feuille", "petale", "graine", "foret", "epine", "nature",
		"buisson", "sarriette", "pose un piege de ronces", "meute", "regression"]],
	["earth", ["gres", "sismique", "seisme", "terre", "pierre", "tremblement", "ecras", "mur", "barriere", "rocher"]],
	["water", ["vague", "sirene", "marin", "brume", "eau"]],
]


static func _norm(s: String) -> String:
	var t: String = s.to_lower()
	for pair in [["é", "e"], ["è", "e"], ["ê", "e"], ["ë", "e"], ["à", "a"], ["â", "a"], ["î", "i"], ["ï", "i"],
			["ô", "o"], ["û", "u"], ["ù", "u"], ["ç", "c"], ["œ", "oe"]]:
		t = t.replace(pair[0], pair[1])
	return t


## Élément visuel d'un sort d'après son nom, son type de dégâts et sa nature.
static func element_for(spell_name: String, dtype: String, kind: String) -> String:
	var n: String = _norm(spell_name)
	if kind == "summon" and n.begins_with("invoquer "):
		return "arcane"
	for entry: Array in KEYWORDS:
		for kw in entry[1]:
			if n.contains(String(kw)):
				return String(entry[0])
	if kind == "heal":
		return "holy"
	if kind == "summon" or kind == "teleport":
		return "arcane"
	if kind == "trap" or kind == "glyph":
		return "earth"
	return "physical" if dtype == "phys" else "arcane"


static func colors(element: String) -> Array:
	var e: Dictionary = ELEMENTS.get(element, ELEMENTS["arcane"])
	return [e["col"], e["col2"]]


# ═══════════════════════════════════════════════════════════════════════════
#  Nœuds d'effets
# ═══════════════════════════════════════════════════════════════════════════

## Anneau qui s'étend au sol (iso : écrasé verticalement).
class Ring extends Node2D:
	var col: Color = Color.WHITE
	var r0: float = 10.0
	var r1: float = 70.0
	var life: float = 0.5
	var thick: float = 6.0
	var squash: float = 0.5
	var t: float = 0.0
	func _process(d: float) -> void:
		t += d
		if t >= life:
			queue_free()
			return
		queue_redraw()
	func _draw() -> void:
		var k: float = clampf(t / life, 0.0, 1.0)
		var e: float = 1.0 - pow(1.0 - k, 3.0)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.0, squash))
		draw_arc(Vector2.ZERO, lerpf(r0, r1, e), 0.0, TAU, 56, Color(col.r, col.g, col.b, (1.0 - k) * 0.95), maxf(1.5, thick * (1.0 - k * 0.7)), true)


## Rune magique tournante sous le lanceur (cercle + étoile).
class Rune extends Node2D:
	var col: Color = Color.WHITE
	var radius: float = 46.0
	var life: float = 0.7
	var t: float = 0.0
	func _process(d: float) -> void:
		t += d
		if t >= life:
			queue_free()
			return
		queue_redraw()
	func _draw() -> void:
		var k: float = clampf(t / life, 0.0, 1.0)
		var a: float = sin(k * PI)
		var c := Color(col.r, col.g, col.b, a * 0.9)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.0, 0.5))
		var r: float = radius * (0.7 + 0.3 * minf(1.0, k * 3.0))
		draw_arc(Vector2.ZERO, r, 0.0, TAU, 48, c, 3.0, true)
		draw_arc(Vector2.ZERO, r * 0.78, 0.0, TAU, 48, c, 1.6, true)
		var rot: float = t * 2.4
		var pts := PackedVector2Array()
		for i: int in range(6):
			var ang: float = rot + float(i) * TAU / 5.0 * 2.0
			pts.append(Vector2(cos(ang), sin(ang)) * r * 0.78)
		pts.append(pts[0])
		draw_polyline(pts, c, 2.0, true)


## Éclair en zigzag (de start à end).
class Bolt extends Node2D:
	var pts: PackedVector2Array = PackedVector2Array()
	var col: Color = Color(0.7, 0.8, 1.0)
	var life: float = 0.28
	var t: float = 0.0
	func setup(a: Vector2, b: Vector2, col_: Color, jag: float = 16.0) -> void:
		col = col_
		pts = PackedVector2Array([a])
		var n: int = 7
		var dir: Vector2 = b - a
		var perp: Vector2 = Vector2(-dir.y, dir.x).normalized()
		for i: int in range(1, n):
			var f: float = float(i) / float(n)
			pts.append(a + dir * f + perp * randf_range(-jag, jag))
		pts.append(b)
	func _process(d: float) -> void:
		t += d
		if t >= life:
			queue_free()
			return
		queue_redraw()
	func _draw() -> void:
		var a: float = 1.0 - clampf(t / life, 0.0, 1.0)
		if pts.size() < 2:
			return
		draw_polyline(pts, Color(col.r, col.g, col.b, a * 0.55), 11.0, true)
		draw_polyline(pts, Color(col.r, col.g, col.b, a), 5.0, true)
		draw_polyline(pts, Color(1, 1, 1, a), 2.2, true)


## Entaille en croissant (attaque physique au contact).
class Slash extends Node2D:
	var col: Color = Color.WHITE
	var life: float = 0.26
	var t: float = 0.0
	var ang: float = -0.6
	var size: float = 46.0
	func _process(d: float) -> void:
		t += d
		if t >= life:
			queue_free()
			return
		queue_redraw()
	func _draw() -> void:
		var k: float = clampf(t / life, 0.0, 1.0)
		var sweep: float = lerpf(0.2, 1.0, 1.0 - pow(1.0 - k, 2.0))
		draw_set_transform(Vector2.ZERO, ang, Vector2.ONE)
		var a0: float = -1.05
		var a1: float = a0 + 2.1 * sweep
		draw_arc(Vector2.ZERO, size, a0, a1, 22, Color(col.r, col.g, col.b, (1.0 - k) * 0.55), 14.0 * (1.0 - k * 0.5), true)
		draw_arc(Vector2.ZERO, size, a0, a1, 22, Color(1, 1, 1, 1.0 - k), 5.0 * (1.0 - k * 0.5), true)


## Pilier de lumière (soins, magie sacrée) qui monte puis s'estompe.
class Pillar extends Node2D:
	var col: Color = Color(1.0, 0.95, 0.55)
	var life: float = 0.7
	var width: float = 34.0
	var height: float = 150.0
	var t: float = 0.0
	func _process(d: float) -> void:
		t += d
		if t >= life:
			queue_free()
			return
		queue_redraw()
	func _draw() -> void:
		var k: float = clampf(t / life, 0.0, 1.0)
		var a: float = sin(k * PI)
		var w: float = width * (1.0 - 0.35 * k)
		var h: float = height * minf(1.0, k * 4.0)
		var pts := PackedVector2Array([Vector2(-w, 0), Vector2(-w * 0.45, -h), Vector2(w * 0.45, -h), Vector2(w, 0)])
		var cols := PackedColorArray([Color(col.r, col.g, col.b, a * 0.55), Color(col.r, col.g, col.b, 0.0),
			Color(col.r, col.g, col.b, 0.0), Color(col.r, col.g, col.b, a * 0.55)])
		draw_polygon(pts, cols)
		draw_line(Vector2(0, 0), Vector2(0, -h), Color(1, 1, 1, a * 0.7), 3.0, true)


## Projectile : flèche, éclat de glace, boule... orienté dans le sens du déplacement.
class Missile extends Node2D:
	var kind: String = "orb"
	var col: Color = Color.WHITE
	var col2: Color = Color.WHITE
	var spin: float = 0.0
	var t: float = 0.0
	func _process(d: float) -> void:
		t += d
		if kind == "shard":
			rotation += d * 14.0
		queue_redraw()
	func _draw() -> void:
		match kind:
			"arrow":
				draw_line(Vector2(-34, 0), Vector2(8, 0), Color(0.35, 0.22, 0.1), 4.0, true)
				draw_colored_polygon(PackedVector2Array([Vector2(8, -7), Vector2(24, 0), Vector2(8, 7)]), Color(0.85, 0.88, 0.95))
				draw_colored_polygon(PackedVector2Array([Vector2(-34, 0), Vector2(-42, -6), Vector2(-26, 0), Vector2(-42, 6)]), col)
			"shard":
				draw_colored_polygon(PackedVector2Array([Vector2(0, -22), Vector2(9, 0), Vector2(0, 22), Vector2(-9, 0)]), Color(col.r, col.g, col.b, 0.95))
				draw_polyline(PackedVector2Array([Vector2(0, -22), Vector2(9, 0), Vector2(0, 22), Vector2(-9, 0), Vector2(0, -22)]), col2, 2.0, true)
			"flame":
				var f: float = 1.0 + 0.15 * sin(t * 30.0)
				draw_circle(Vector2.ZERO, 16.0 * f, Color(col.r, col.g, col.b, 0.85))
				draw_circle(Vector2(3, 0), 10.0 * f, Color(col2.r, col2.g, col2.b, 0.95))
				draw_colored_polygon(PackedVector2Array([Vector2(-6, -12), Vector2(-36, 0), Vector2(-6, 12)]), Color(col.r, col.g, col.b, 0.55))
			"glob":
				draw_circle(Vector2.ZERO, 13.0, Color(col.r, col.g, col.b, 0.95))
				draw_circle(Vector2(-4, -4), 5.0, Color(1, 1, 1, 0.6))
				draw_circle(Vector2(6, 5), 4.0, Color(col2.r, col2.g, col2.b, 0.8))
			"dark":
				draw_circle(Vector2.ZERO, 17.0, Color(col2.r, col2.g, col2.b, 0.95))
				draw_arc(Vector2.ZERO, 17.0, 0.0, TAU, 28, col, 3.0, true)
				draw_circle(Vector2.ZERO, 7.0, Color(col.r, col.g, col.b, 0.6))
			"leaf":
				draw_colored_polygon(PackedVector2Array([Vector2(-14, 0), Vector2(0, -8), Vector2(14, 0), Vector2(0, 8)]), col)
				draw_line(Vector2(-14, 0), Vector2(14, 0), col2, 1.6, true)
			_:
				draw_circle(Vector2.ZERO, 14.0, Color(col.r, col.g, col.b, 0.9))
				draw_circle(Vector2.ZERO, 7.0, Color(col2.r, col2.g, col2.b, 1.0))


## Glyphe posé au sol : cases teintées + runes qui pulsent, tant que le glyphe existe.
class GlyphMark extends Node2D:
	var col: Color = Color.WHITE
	var offsets: Array[Vector2] = []     # position des cases, relative au nœud
	var center_off: Vector2 = Vector2.ZERO
	var friendly: bool = true
	var t: float = 0.0
	func _process(d: float) -> void:
		t += d
		queue_redraw()
	func _diamond(c: Vector2, k: float) -> PackedVector2Array:
		return PackedVector2Array([c + Vector2(0, -32 * k), c + Vector2(64 * k, 0), c + Vector2(0, 32 * k), c + Vector2(-64 * k, 0)])
	func _draw() -> void:
		var pulse: float = 0.5 + 0.5 * sin(t * 3.0)
		var fill := Color(col.r, col.g, col.b, 0.26 + 0.14 * pulse)
		var line := Color(col.r, col.g, col.b, 0.55 + 0.35 * pulse)
		for o: Vector2 in offsets:
			var poly: PackedVector2Array = _diamond(o, 0.92)
			draw_colored_polygon(poly, fill)
			var closed := PackedVector2Array(poly)
			closed.append(poly[0])
			draw_polyline(closed, Color(0, 0, 0, 0.35), 4.5, true)
			draw_polyline(closed, line, 2.6, true)
			# petit symbole au centre de chaque case
			draw_set_transform(o, 0.0, Vector2(1.0, 0.5))
			draw_arc(Vector2.ZERO, 11.0, 0.0, TAU, 20, Color(line.r, line.g, line.b, 0.6), 1.5, true)
			draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		# grande rune tournante sur la case centrale
		draw_set_transform(center_off, 0.0, Vector2(1.0, 0.5))
		var r: float = 40.0
		draw_arc(Vector2.ZERO, r, 0.0, TAU, 40, line, 2.5, true)
		var rot: float = t * 0.9
		var pts := PackedVector2Array()
		for i: int in range(6):
			var ang: float = rot + float(i) * TAU / 5.0 * 2.0
			pts.append(Vector2(cos(ang), sin(ang)) * r * 0.85)
		pts.append(pts[0])
		draw_polyline(pts, line, 1.8, true)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
