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

const TINT := {
	"Forêt": Color(0.40, 0.62, 0.66, 0.18), "Montagne": Color(0.55, 0.70, 0.90, 0.22),
	"Désert": Color(0.95, 0.72, 0.42, 0.22), "Donjon": Color(0.30, 0.22, 0.45, 0.42),
}


func _ready() -> void:
	add_to_group("backdrop")
	var gm: Node = get_node_or_null("/root/GameManager")
	configure(String(gm.fight_biome) if gm != null else "Forêt")


func set_biome(biome: String) -> void:
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
	set_process(true)
	queue_redraw()


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
