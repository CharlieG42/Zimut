class_name VoidPit
extends Node2D
## VoidPit.gd — Rendu d'une case « hors plateau » (obstacle "void", V49).
## Au lieu d'un trou qui laisse voir le ciel, la case devient un gouffre : fond sombre
## dégradé propre au biome, brume qui monte lentement, et (au bord de l'île) la paroi
## extérieure reste continue. Les parois intérieures du gouffre sont les faces des cases
## voisines (Cell.pit_left / pit_right), décorées par biome (racines, glaçons, sable…).
## L'origine du nœud est le centre du losange de la case (comme Cell).

const HW := 64.0
const HH := 32.0
const DEPTH := 68.0

var biome: String = "Forêt"
var outer_left: bool = false    # dernière rangée : la face extérieure gauche doit rester visible
var outer_right: bool = false   # dernière colonne : face extérieure droite
## Case vide reliée au bord de l'île : rendue comme un replat en contrebas (la falaise
## descend d'un étage) plutôt qu'un gouffre noir au milieu du vide.
var ledge: bool = false
var _t: float = 0.0
var _seed: float = 0.0


func setup(cell: Vector2i, b: String, n: int, is_ledge: bool = false) -> void:
	biome = b
	ledge = is_ledge
	outer_left = cell.y == n - 1
	outer_right = cell.x == n - 1
	_seed = float((cell.x * 73 + cell.y * 31) % 97) * 0.37
	queue_redraw()


## Couleurs du gouffre : [bord, fond, brume] selon le biome.
static func abyss(b: String) -> Array:
	match b:
		"Forêt":
			return [Color(0.10, 0.17, 0.10), Color(0.02, 0.05, 0.03), Color(0.62, 0.86, 0.62)]
		"Montagne":
			return [Color(0.20, 0.30, 0.42), Color(0.03, 0.06, 0.12), Color(0.84, 0.92, 1.0)]
		"Désert":
			return [Color(0.46, 0.31, 0.18), Color(0.13, 0.07, 0.03), Color(1.0, 0.88, 0.62)]
		"Donjon":
			return [Color(0.16, 0.13, 0.22), Color(0.03, 0.02, 0.06), Color(0.66, 0.56, 0.90)]
	var p: Dictionary = BattleScenery.pal(b)
	return [(p["l_b"] as Color).darkened(0.55), (p["l_b"] as Color).darkened(0.9), p["mist"]]


func _process(delta: float) -> void:
	_t += delta
	queue_redraw()


func _draw() -> void:
	var col: Array = abyss(biome)
	var rim: Color = col[0]
	var deep: Color = col[1]
	var mist: Color = col[2]
	var p: Dictionary = BattleScenery.pal(biome)
	if ledge:
		_draw_ledge(p, mist)
		return
	# Faces extérieures (bord de l'île) : la paroi reste continue sous le gouffre.
	if outer_left:
		draw_polygon(PackedVector2Array([Vector2(-HW, 0), Vector2(0, HH), Vector2(0, HH + DEPTH), Vector2(-HW, DEPTH)]),
			PackedColorArray([p["l_t"], p["l_t"], p["l_b"], p["l_b"]]))
	if outer_right:
		draw_polygon(PackedVector2Array([Vector2(0, HH), Vector2(HW, 0), Vector2(HW, DEPTH), Vector2(0, HH + DEPTH)]),
			PackedColorArray([p["r_t"], p["r_t"], p["r_b"], p["r_b"]]))
	# Fond du gouffre : clair près des bords arrière (lumière rasante), noir vers l'avant.
	var top := PackedVector2Array([Vector2(0, -HH), Vector2(HW, 0), Vector2(0, HH), Vector2(-HW, 0)])
	draw_polygon(top, PackedColorArray([rim, rim.lerp(deep, 0.55), deep, rim.lerp(deep, 0.55)]))
	# Anneaux d'obscurité : impression de profondeur
	for i: int in range(3):
		var k: float = 0.75 - 0.2 * float(i)
		var pts := PackedVector2Array([Vector2(0, -HH * k + 8.0), Vector2(HW * k, 8.0), Vector2(0, HH * k + 8.0), Vector2(-HW * k, 8.0)])
		draw_colored_polygon(pts, Color(deep.r, deep.g, deep.b, 0.35))
	# Brume qui respire au fond du gouffre
	for i: int in range(3):
		var ph: float = _t * 0.6 + _seed + float(i) * 2.1
		var c: Vector2 = Vector2(sin(ph) * 16.0, 10.0 + cos(ph * 0.8) * 5.0)
		draw_set_transform(c, 0.0, Vector2(1.0, 0.42))
		draw_circle(Vector2.ZERO, 26.0 + 6.0 * float(i), Color(mist.r, mist.g, mist.b, 0.07 + 0.03 * sin(ph * 1.3)))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	# Particules propres au biome
	for i: int in range(4):
		var f: float = fmod(_t * 0.18 + _seed + float(i) * 0.25, 1.0)
		var x: float = sin(float(i) * 2.7 + _seed) * HW * 0.45
		match biome:
			"Forêt":   # lucioles qui montent du gouffre
				draw_circle(Vector2(x, 14.0 - f * 34.0), 1.8, Color(0.75, 1.0, 0.45, 0.65 * sin(f * PI)))
			"Montagne":   # flocons qui tombent dans la crevasse
				draw_circle(Vector2(x, -10.0 + f * 30.0), 1.6, Color(0.95, 0.98, 1.0, 0.75 * sin(f * PI)))
			"Désert":   # sable qui s'écoule
				draw_line(Vector2(x, -6.0 + f * 24.0), Vector2(x, f * 24.0 + 2.0), Color(0.95, 0.82, 0.55, 0.6 * sin(f * PI)), 1.4)
			_:
				draw_circle(Vector2(x, 14.0 - f * 30.0), 1.6, Color(mist.r, mist.g, mist.b, 0.5 * sin(f * PI)))


## Replat en contrebas (case vide au bord de l'île) : sol du biome un étage plus bas.
func _draw_ledge(p: Dictionary, mist: Color) -> void:
	var o := Vector2(0, DEPTH)
	if outer_left:
		draw_polygon(PackedVector2Array([o + Vector2(-HW, 0), o + Vector2(0, HH), o + Vector2(0, HH + DEPTH * 0.6), o + Vector2(-HW, DEPTH * 0.6)]),
			PackedColorArray([p["l_t"], p["l_t"], p["l_b"], p["l_b"]]))
	if outer_right:
		draw_polygon(PackedVector2Array([o + Vector2(0, HH), o + Vector2(HW, 0), o + Vector2(HW, DEPTH * 0.6), o + Vector2(0, HH + DEPTH * 0.6)]),
			PackedColorArray([p["r_t"], p["r_t"], p["r_b"], p["r_b"]]))
	var g: Color = (p["top_a"] as Color).darkened(0.28)
	var floor_pts := PackedVector2Array([o + Vector2(0, -HH), o + Vector2(HW, 0), o + Vector2(0, HH), o + Vector2(-HW, 0)])
	draw_polygon(floor_pts, PackedColorArray([g.darkened(0.25), g, g.lightened(0.05), g]))
	draw_polyline(PackedVector2Array([o + Vector2(-HW, 0), o + Vector2(0, HH), o + Vector2(HW, 0)]), (p["lip"] as Color).darkened(0.2), 2.0, true)
	# ombre portée par la marche (haut du replat)
	draw_colored_polygon(PackedVector2Array([o + Vector2(0, -HH), o + Vector2(HW, 0), o + Vector2(HW * 0.6, 6.0), o + Vector2(0, -HH + 14.0), o + Vector2(-HW * 0.6, 6.0), o + Vector2(-HW, 0)]),
		Color(0, 0, 0, 0.28))
	for i: int in range(5):
		var a: float = float(i) * 1.7 + _seed
		var tp: Vector2 = o + Vector2(sin(a) * HW * 0.5, cos(a * 1.3) * HH * 0.45)
		draw_line(tp, tp + Vector2(1.5, -5.0), (p["leaf"] as Color), 1.4)
	draw_set_transform(o + Vector2(sin(_t * 0.5 + _seed) * 10.0, 4.0), 0.0, Vector2(1.0, 0.4))
	draw_circle(Vector2.ZERO, 30.0, Color(mist.r, mist.g, mist.b, 0.10))
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
