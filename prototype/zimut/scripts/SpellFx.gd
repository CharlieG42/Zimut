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


## V47 — Retour visuel côté CIBLE d'un statut : style dessiné par code. La teinte est celle du
## statut (Combat.STATUS_INFO). Pilotée par données : un nouveau statut = une ligne ici.
const STATUS_VFX := {
	"poison": "drip", "bleed": "drip", "burn": "embers",
	"stun": "stars", "root": "roots", "slow": "down", "curse": "swirl", "weaken": "down", "taunted": "target",
	"def_up": "dome", "mres_up": "dome", "immune": "dome", "immune_phys": "dome", "immune_mag": "dome", "immune_neg": "dome",
	"dmg_up": "up", "pa_up": "up", "pm_up": "up", "dodge": "ghost", "invisible": "ghost",
	"regen": "cross", "mark": "target", "chief": "crown",
}

## Pointes d'impact par élément : [nombre, longueur, rotation du motif].
const IMPACT_SPIKES := {
	"ice": [7, 62.0, 0.0], "earth": [6, 54.0, 0.4], "nature": [8, 50.0, 0.2], "holy": [8, 74.0, 0.0],
	"arcane": [5, 58.0, 0.3], "lightning": [6, 66.0, 0.1],
}


## Style d'effet d'un statut ; repli sur « up » (positif) ou « down » (négatif).
static func status_style(id: String, good: bool) -> String:
	if STATUS_VFX.has(id):
		return String(STATUS_VFX[id])
	return "up" if good else "down"


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
		if t < 0.0:
			return   # V47 : départ différé (ondulation d'une zone d'effet)
		var k: float = clampf(t / life, 0.0, 1.0)
		var e: float = 1.0 - pow(1.0 - k, 3.0)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.0, squash))
		draw_arc(Vector2.ZERO, lerpf(r0, r1, e), 0.0, TAU, 56, Color(col.r, col.g, col.b, (1.0 - k) * 0.95), maxf(1.5, thick * (1.0 - k * 0.7)), true)


## V73 — Trace laissée AU SOL par un impact (brûlure, givre, flaque, fissure, ronces…),
## sous les personnages ; s'estompe en ~1,6 s. Forme irrégulière stable (graine).
class GroundMark extends Node2D:
	var col: Color = Color.WHITE
	var col2: Color = Color.WHITE
	var style: String = "scorch"
	var life: float = 1.6
	var t: float = 0.0
	var seed_v: int = 1
	var _pts: PackedVector2Array = PackedVector2Array()
	func _ready() -> void:
		var r := RandomNumberGenerator.new()
		r.seed = seed_v
		for i: int in range(14):
			var a: float = float(i) / 14.0 * TAU
			var rr: float = r.randf_range(0.65, 1.0) * 40.0
			_pts.append(Vector2(cos(a) * rr, sin(a) * rr * 0.5))
	func _process(d: float) -> void:
		t += d
		if t >= life:
			queue_free()
			return
		queue_redraw()
	func _draw() -> void:
		var k: float = clampf(t / life, 0.0, 1.0)
		var grow: float = minf(1.0, t / 0.12)
		var a: float = (1.0 - k * k) * 0.55
		draw_set_transform(Vector2.ZERO, 0.0, Vector2(grow, grow))
		match style:
			"crack":                                          # pierre : fissures rayonnantes
				for i: int in range(6):
					var ang: float = float(i) / 6.0 * TAU + 0.3
					var p1 := Vector2(cos(ang), sin(ang) * 0.5) * 18.0
					var p2 := Vector2(cos(ang + 0.25), sin(ang + 0.25) * 0.5) * 38.0
					draw_polyline(PackedVector2Array([Vector2.ZERO, p1, p2]), Color(0.12, 0.08, 0.05, a * 1.4), 3.0, true)
			"frost":                                          # glace : plaque givrée + cristaux
				draw_colored_polygon(_pts, Color(col2.r, col2.g, col2.b, a * 0.6))
				for i2: int in range(8):
					var ang2: float = float(i2) / 8.0 * TAU
					draw_line(Vector2.ZERO, Vector2(cos(ang2), sin(ang2) * 0.5) * 34.0, Color(col.r, col.g, col.b, a), 2.0, true)
			"glow":                                           # sacré / arcane : cercle de lumière
				draw_circle(Vector2.ZERO, 34.0, Color(col.r, col.g, col.b, a * 0.35))
				draw_arc(Vector2.ZERO, 34.0, 0.0, TAU, 40, Color(col2.r, col2.g, col2.b, a), 2.0, true)
			_:                                                # brûlure, flaque, poison, ombre, ronces
				draw_colored_polygon(_pts, Color(col.r, col.g, col.b, a))
				var inner := PackedVector2Array()
				for p: Vector2 in _pts:
					inner.append(p * 0.55)
				draw_colored_polygon(inner, Color(col2.r, col2.g, col2.b, a * 0.8))


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


## V70 : faisceau de lumière de la mort. Une colonne tombe du ciel sur le personnage vaincu,
## l'enveloppe un instant, puis s'éteint pendant que le personnage se dissout dans la lumière.
## `pos` = pied du personnage ; la tête du faisceau atteint le sol en HIT secondes.
class DeathBeam extends Node2D:
	const HIT := 0.20
	var col: Color = Color(0.85, 0.95, 1.0)
	var life: float = 1.05
	var half_w: float = 21.0
	var t: float = 0.0
	func _ready() -> void:
		var m := CanvasItemMaterial.new()
		m.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
		material = m
		z_index = 20
	func _process(d: float) -> void:
		t += d
		if t >= life:
			queue_free()
			return
		queue_redraw()
	func _draw() -> void:
		var top: float = -1100.0
		var land: float = clampf(t / HIT, 0.0, 1.0)
		var head: float = lerpf(top, 6.0, land * land)
		var fade: float = 1.0
		if t > life * 0.70:
			fade = clampf(1.0 - (t - life * 0.70) / (life * 0.30), 0.0, 1.0)
		var w: float = half_w * (1.0 + 0.10 * sin(t * 38.0)) * (0.35 + 0.65 * fade)
		# colonne en couches : halo large, corps, cœur blanc
		for layer: Array in [[2.2, 0.08], [1.5, 0.16], [0.9, 0.32], [0.4, 0.62]]:
			var lw: float = w * float(layer[0])
			var la: float = float(layer[1]) * fade
			var c: Color = col if float(layer[0]) > 0.5 else Color(1, 1, 1)
			draw_rect(Rect2(-lw, top, lw * 2.0, head - top), Color(c.r, c.g, c.b, la))
		# tête lumineuse qui tombe
		draw_circle(Vector2(0, head), w * (0.9 + (1.0 - land) * 0.8), Color(1, 1, 1, 0.40 * fade))
		if t < HIT:
			return
		# impact : onde elliptique au sol
		var k: float = clampf((t - HIT) / 0.55, 0.0, 1.0)
		draw_set_transform(Vector2(0, 6), 0.0, Vector2(1.0, 0.42))
		draw_arc(Vector2.ZERO, 24.0 + 78.0 * k, 0.0, TAU, 40, Color(col.r, col.g, col.b, (1.0 - k) * 0.9), 5.0 * (1.0 - k) + 1.0, true)
		draw_circle(Vector2.ZERO, 22.0 * (1.0 - k * 0.6), Color(1, 1, 1, 0.25 * (1.0 - k)))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		# étincelles qui montent le long du faisceau
		for i: int in range(16):
			var ph: float = fposmod((t - HIT) * 1.5 + float(i) * 0.137, 1.0)
			var x: float = sin(float(i) * 7.3) * w * 1.15
			var y: float = -ph * 150.0
			draw_circle(Vector2(x, y), 3.2 * (1.0 - ph), Color(1, 1, 1, (1.0 - ph) * fade))


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
			"wisp":
				# V47 : étincelle de soutien (soin/buff lancé à distance), scintille en tournant
				var pulse: float = 1.0 + 0.2 * sin(t * 24.0)
				draw_circle(Vector2.ZERO, 16.0 * pulse, Color(col.r, col.g, col.b, 0.35))
				draw_circle(Vector2.ZERO, 9.0 * pulse, Color(col.r, col.g, col.b, 0.9))
				draw_circle(Vector2.ZERO, 4.5, Color(1, 1, 1, 0.95))
				for i: int in range(4):
					var a: float = t * 6.0 + float(i) * PI * 0.5
					draw_line(Vector2.ZERO, Vector2(cos(a), sin(a)) * 20.0 * pulse, Color(col2.r, col2.g, col2.b, 0.8), 2.0, true)
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


# ═══════════════════════════════════════════════════════════════════════════
#  V47 — Effets de lanceur et de cible
# ═══════════════════════════════════════════════════════════════════════════

## Charge d'incantation autour du lanceur : étincelles qui convergent + halo qui gonfle.
## Pour une attaque physique : traits de vitesse (élan) au lieu d'étincelles.
class Charge extends Node2D:
	var col: Color = Color.WHITE
	var col2: Color = Color.WHITE
	var physical: bool = false
	var life: float = 0.34
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
		if physical:
			for i: int in range(4):
				var y: float = -18.0 + float(i) * 12.0
				var x0: float = -52.0 + 30.0 * k
				draw_line(Vector2(x0 - 24.0, y), Vector2(x0, y), Color(col.r, col.g, col.b, a * 0.8), 3.0, true)
			return
		draw_circle(Vector2.ZERO, lerpf(8.0, 30.0, k), Color(col.r, col.g, col.b, a * 0.30))
		draw_circle(Vector2.ZERO, lerpf(4.0, 14.0, k), Color(col2.r, col2.g, col2.b, a * 0.55))
		for i: int in range(8):
			var ang: float = float(i) * TAU / 8.0 + k * 2.2
			var rad: float = lerpf(74.0, 6.0, k * k)
			var p := Vector2(cos(ang), sin(ang) * 0.75) * rad
			draw_circle(p, 3.2 * (1.0 - k * 0.4), Color(col2.r, col2.g, col2.b, a))
			draw_line(p, p * 1.18, Color(col.r, col.g, col.b, a * 0.6), 2.0, true)


## Pointes radiales (cristaux de glace, pierres, épines, rayons sacrés...) à l'impact.
class Spikes extends Node2D:
	var col: Color = Color.WHITE
	var n: int = 6
	var length: float = 56.0
	var rot: float = 0.0
	var life: float = 0.42
	var squash: float = 0.6
	var t: float = 0.0
	func _process(d: float) -> void:
		t += d
		if t >= life:
			queue_free()
			return
		queue_redraw()
	func _draw() -> void:
		var k: float = clampf(t / life, 0.0, 1.0)
		var grow: float = 1.0 - pow(1.0 - minf(1.0, k * 2.5), 3.0)
		var a: float = 1.0 - pow(k, 2.0)
		for i: int in range(n):
			var ang: float = rot + float(i) * TAU / float(n)
			var dir := Vector2(cos(ang), sin(ang) * squash)
			var base: Vector2 = dir * 10.0
			var tip: Vector2 = dir * (10.0 + length * grow)
			var perp := Vector2(-dir.y, dir.x).normalized() * 6.0 * (1.0 - k * 0.5)
			draw_colored_polygon(PackedVector2Array([base + perp, tip, base - perp]), Color(col.r, col.g, col.b, a * 0.9))
			draw_line(base, tip, Color(1, 1, 1, a * 0.6), 1.5, true)


## Marque de statut sur la cible. `style` : up, down, dome, stars, roots, drip, embers, swirl,
## target, ghost, cross, crown. Dessinée au-dessus des pieds de la cible (hauteur `h`).
class StatusMark extends Node2D:
	var col: Color = Color.WHITE
	var style: String = "up"
	var h: float = 90.0
	var life: float = 0.95
	var t: float = 0.0
	func _process(d: float) -> void:
		t += d
		if t >= life:
			queue_free()
			return
		queue_redraw()
	func _chevron(c: Vector2, w: float, up: bool, a: float) -> void:
		var s: float = -1.0 if up else 1.0
		var pts := PackedVector2Array([c + Vector2(-w, -s * w * 0.5), c + Vector2(0, s * w * 0.5), c + Vector2(w, -s * w * 0.5)])
		draw_polyline(pts, Color(0, 0, 0, a * 0.5), 7.0, true)
		draw_polyline(pts, Color(col.r, col.g, col.b, a), 4.0, true)
	func _star4(c: Vector2, r: float, a: float) -> void:
		draw_colored_polygon(PackedVector2Array([c + Vector2(0, -r), c + Vector2(r * 0.3, -r * 0.3), c + Vector2(r, 0), c + Vector2(r * 0.3, r * 0.3),
			c + Vector2(0, r), c + Vector2(-r * 0.3, r * 0.3), c + Vector2(-r, 0), c + Vector2(-r * 0.3, -r * 0.3)]), Color(col.r, col.g, col.b, a))
	func _draw() -> void:
		var k: float = clampf(t / life, 0.0, 1.0)
		var fade: float = minf(1.0, k * 6.0) * (1.0 - maxf(0.0, (k - 0.6) / 0.4))
		match style:
			"up", "down":
				var up: bool = style == "up"
				for i: int in range(3):
					var f: float = fposmod(k * 1.4 - float(i) * 0.22, 1.0)
					var y: float = lerpf(-8.0, -h, f) if up else lerpf(-h, -8.0, f)
					_chevron(Vector2(0, y), 18.0, up, fade * sin(f * PI))
			"dome":
				draw_set_transform(Vector2(0, -h * 0.45), 0.0, Vector2.ONE)
				var r: float = 50.0 + 6.0 * sin(t * 10.0)
				draw_circle(Vector2.ZERO, r, Color(col.r, col.g, col.b, 0.16 * fade))
				draw_arc(Vector2.ZERO, r, 0.0, TAU, 40, Color(col.r, col.g, col.b, 0.9 * fade), 3.5, true)
				for i: int in range(6):
					var ang: float = t * 1.5 + float(i) * TAU / 6.0
					draw_line(Vector2(cos(ang), sin(ang)) * r * 0.55, Vector2(cos(ang), sin(ang)) * r, Color(1, 1, 1, 0.5 * fade), 1.5, true)
			"stars":
				for i: int in range(3):
					var ang: float = t * 7.0 + float(i) * TAU / 3.0
					_star4(Vector2(cos(ang) * 34.0, -h - 6.0 + sin(ang) * 10.0), 9.0, fade)
			"roots":
				for i: int in range(5):
					var x: float = -30.0 + float(i) * 15.0
					var hh: float = (24.0 + float(i % 3) * 14.0) * minf(1.0, k * 4.0)
					var pts := PackedVector2Array()
					for j: int in range(6):
						var f: float = float(j) / 5.0
						pts.append(Vector2(x + sin(f * 5.0 + float(i)) * 6.0, -f * hh))
					draw_polyline(pts, Color(0.30, 0.20, 0.10, fade), 6.0, true)
					draw_polyline(pts, Color(col.r, col.g, col.b, fade), 3.0, true)
			"drip":
				for i: int in range(5):
					var f: float = fposmod(k * 1.5 + float(i) * 0.2, 1.0)
					var x: float = -26.0 + float(i) * 13.0
					var y: float = lerpf(-h, -6.0, f * f)
					draw_circle(Vector2(x, y), 4.5, Color(col.r, col.g, col.b, fade))
					draw_colored_polygon(PackedVector2Array([Vector2(x - 3.5, y - 1.0), Vector2(x, y - 12.0), Vector2(x + 3.5, y - 1.0)]), Color(col.r, col.g, col.b, fade))
			"embers":
				for i: int in range(6):
					var f: float = fposmod(k * 1.6 + float(i) * 0.17, 1.0)
					var x: float = -28.0 + float(i) * 11.0 + sin(f * 9.0 + float(i)) * 5.0
					var y: float = lerpf(-6.0, -h, f)
					draw_circle(Vector2(x, y), 6.0 * (1.0 - f * 0.6), Color(col.r, col.g, col.b, fade * (1.0 - f)))
					draw_circle(Vector2(x, y), 3.0 * (1.0 - f * 0.6), Color(1.0, 0.9, 0.5, fade * (1.0 - f)))
			"swirl":
				draw_set_transform(Vector2(0, -h * 0.5), 0.0, Vector2(1.0, 0.7))
				for i: int in range(3):
					var ang0: float = -t * 5.0 + float(i) * TAU / 3.0
					draw_arc(Vector2.ZERO, lerpf(52.0, 14.0, k), ang0, ang0 + 1.4, 14, Color(col.r, col.g, col.b, fade * 0.9), 5.0, true)
			"target":
				var r: float = lerpf(64.0, 22.0, minf(1.0, k * 2.0))
				var c := Vector2(0, -h * 0.5)
				draw_arc(c, r, 0.0, TAU, 32, Color(col.r, col.g, col.b, fade), 3.0, true)
				for i: int in range(4):
					var ang: float = float(i) * PI * 0.5
					draw_line(c + Vector2(cos(ang), sin(ang)) * (r - 12.0), c + Vector2(cos(ang), sin(ang)) * (r + 10.0), Color(col.r, col.g, col.b, fade), 3.0, true)
			"ghost":
				for i: int in range(4):
					var y: float = -h * (0.2 + 0.22 * float(i)) - 10.0 * sin(t * 8.0 + float(i))
					draw_line(Vector2(-36, y), Vector2(36, y), Color(col.r, col.g, col.b, fade * 0.7), 2.5, true)
			"cross":
				for i: int in range(4):
					var f: float = fposmod(k * 1.3 + float(i) * 0.25, 1.0)
					var c := Vector2(-24.0 + float(i) * 16.0, lerpf(-6.0, -h, f))
					var a: float = fade * sin(f * PI)
					draw_line(c + Vector2(-7, 0), c + Vector2(7, 0), Color(col.r, col.g, col.b, a), 4.0, true)
					draw_line(c + Vector2(0, -7), c + Vector2(0, 7), Color(col.r, col.g, col.b, a), 4.0, true)
			"crown":
				for i: int in range(3):
					_star4(Vector2(-22.0 + float(i) * 22.0, -h - 8.0 - 6.0 * sin(t * 9.0 + float(i) * 2.0)), 7.0 + 3.0 * sin(t * 12.0 + float(i)), fade)
