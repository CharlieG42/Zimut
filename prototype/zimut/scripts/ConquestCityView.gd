class_name ConquestCityView
extends Control
## ConquestCityView.gd — Vue illustrée d'une ville de Conquête (V61).
##
## La ville est dessinée devant l'illustration de sa Nation : hôtel de ville au centre (il grandit
## avec le niveau de la ville : ailes, tours, dôme, flèche dorée), caserne avec ses soldats,
## résidence du gouverneur (le héros en poste se tient devant), six parcelles de production et
## la parcelle de la Merveille. Chaque bâtiment change d'allure avec son niveau (1 à 3) et
## s'anime (scie qui tourne, lanterne de la mine, orbe des mages, fumées, drapeaux) ; des
## habitants circulent sur les chemins. Toucher un bâtiment émet `plot_pressed(clé)`.
##
## V61b — sprites découpés : si le PNG d'un bâtiment existe dans
## assets/ui/conquest/cities/batiments/<nation>/, il remplace le dessin vectoriel
## (même échelle, posé au point au sol de sa parcelle) ; sinon la vue dessine comme
## avant. Les effets vivants (soldats à l'exercice, gouverneur, plaques, étoiles)
## restent dessinés par-dessus le sprite.

signal plot_pressed(key: String)

const BUILD_ORDER: Array[String] = ["scierie", "mine", "tannerie", "cabane", "verger", "muraille"]
## Point au sol de chaque parcelle (fractions de la vue).
const PLOTS := {
	"hall": Vector2(0.50, 0.50), "barracks": Vector2(0.19, 0.58), "residence": Vector2(0.81, 0.58),
	"wonder": Vector2(0.50, 0.79),
	"scierie": Vector2(0.10, 0.83), "mine": Vector2(0.22, 0.91), "tannerie": Vector2(0.35, 0.84),
	"cabane": Vector2(0.65, 0.84), "verger": Vector2(0.80, 0.91), "muraille": Vector2(0.92, 0.83),
}
const NODE_NAMES := {"hall": "CardHall", "barracks": "CardBarracks", "residence": "CardResidence", "wonder": "CardWonder"}
const LABELS := {"hall": "Hôtel de ville", "barracks": "Caserne", "residence": "Résidence", "wonder": "Merveille",
	"scierie": "Scierie", "mine": "Mine", "tannerie": "Tannerie", "cabane": "Cabane des mages", "verger": "Verger", "muraille": "Muraille"}
## Matériaux de construction par Nation : murs, toits, ornements, sol.
const STYLE := {
	"Forêt": [Color(0.62, 0.46, 0.30), Color(0.24, 0.50, 0.27), Color(0.92, 0.80, 0.45), Color(0.27, 0.40, 0.20)],
	"Montagne": [Color(0.72, 0.74, 0.78), Color(0.28, 0.40, 0.64), Color(0.92, 0.96, 1.0), Color(0.55, 0.60, 0.66)],
	"Désert": [Color(0.90, 0.78, 0.55), Color(0.80, 0.45, 0.22), Color(0.98, 0.86, 0.45), Color(0.80, 0.66, 0.42)],
	"Cristaux": [Color(0.56, 0.53, 0.74), Color(0.42, 0.60, 0.98), Color(0.82, 0.72, 1.0), Color(0.30, 0.28, 0.46)],
	"Marées": [Color(0.90, 0.88, 0.80), Color(0.20, 0.52, 0.72), Color(0.96, 0.86, 0.55), Color(0.78, 0.72, 0.55)],
	"Vents": [Color(0.86, 0.89, 0.92), Color(0.40, 0.68, 0.82), Color(0.96, 0.96, 0.99), Color(0.52, 0.66, 0.50)],
	"Brasier": [Color(0.34, 0.27, 0.24), Color(0.74, 0.28, 0.12), Color(1.0, 0.62, 0.22), Color(0.24, 0.18, 0.16)],
	"Brumes": [Color(0.52, 0.60, 0.52), Color(0.26, 0.50, 0.48), Color(0.72, 0.96, 0.86), Color(0.26, 0.38, 0.34)],
	"Ombres": [Color(0.38, 0.32, 0.44), Color(0.44, 0.25, 0.58), Color(0.78, 0.58, 1.0), Color(0.22, 0.19, 0.27)],
	"Rouages": [Color(0.64, 0.52, 0.40), Color(0.76, 0.48, 0.22), Color(0.96, 0.76, 0.36), Color(0.38, 0.32, 0.28)],
	"Donjon": [Color(0.32, 0.30, 0.34), Color(0.24, 0.20, 0.30), Color(0.72, 0.56, 0.96), Color(0.20, 0.18, 0.22)],
}
const RES_GLOW := {"Bois": Color(0.62, 0.85, 0.40), "Fer": Color(0.80, 0.86, 0.95), "Cuir": Color(0.90, 0.66, 0.42),
	"Magie": Color(0.72, 0.58, 1.0), "Venin": Color(0.55, 0.92, 0.55)}

## V61b — planches de bâtiments découpées (même clé de nation que CityScreenUI.ART).
const NATION_KEY := {"Forêt": "sylvestre", "Montagne": "cimes", "Désert": "sables", "Cristaux": "cristaux",
	"Marées": "marees", "Vents": "vents", "Brasier": "brasier", "Brumes": "brumes", "Ombres": "ombres",
	"Rouages": "rouages", "Donjon": "donjon"}
## Dossier des sprites : <SPRITE_DIR>/<nation>/<bâtiment>[_<niveau>].png
const SPRITE_DIR := "res://assets/ui/conquest/cities/batiments"
## Largeur cible (unités) de chaque bâtiment quand un sprite existe (hauteur = aspect conservé).
const SPRITE_WIDTH := {"hall": 250.0, "caserne": 180.0, "residence": 180.0, "merveille": 250.0,
	"scierie": 200.0, "mine": 200.0, "tannerie": 200.0, "cabane": 180.0, "verger": 200.0, "muraille": 200.0}

## État de la ville à dessiner (rempli par CityScreenUI).
var biome: String = "Forêt"
var art: Texture2D = null
var hero_tex: Texture2D = null
var city_level: int = 1
var troops: int = 0
var levels: Dictionary = {}          # bâtiment -> niveau (0 = non construit)
var locked: Dictionary = {}          # bâtiment / "wonder" -> vrai si pas encore constructible
var wonder: bool = false
var wonder_shape: String = "tree"
var ravaged: bool = false
var threat: bool = false
var selected: String = "hall"
var animate: bool = true

var _t: float = 0.0
var _fx_key: String = ""
var _fx_t: float = -1.0
var _buttons: Dictionary = {}
var _fade: GradientTexture2D = null
var _tex_cache: Dictionary = {}       # V61b : chemin -> Texture2D (ou null, repli vectoriel)


func _ready() -> void:
	clip_contents = true
	for key: String in PLOTS.keys():
		var b := Button.new()
		b.name = String(NODE_NAMES.get(key, "CardBuilding_" + key))
		b.flat = true
		b.focus_mode = Control.FOCUS_NONE
		for st: String in ["normal", "hover", "pressed", "focus", "disabled"]:
			b.add_theme_stylebox_override(st, StyleBoxEmpty.new())
		b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		b.pressed.connect(func() -> void: plot_pressed.emit(key))
		add_child(b)
		_buttons[key] = b
	resized.connect(_place_buttons)
	_place_buttons()


func _place_buttons() -> void:
	var u: float = _unit()
	for key: String in _buttons.keys():
		var g: Vector2 = (PLOTS[key] as Vector2) * size
		var sz := Vector2(150, 140) * u
		if key == "hall":
			sz = Vector2(230, 230) * u
		var b: Button = _buttons[key]
		b.size = sz
		b.position = g - Vector2(sz.x * 0.5, sz.y - 22.0 * u)


## Effet de construction / d'amélioration (étincelles dorées, poussière).
func celebrate(key: String) -> void:
	_fx_key = key
	_fx_t = 0.0


func _process(d: float) -> void:
	if not is_visible_in_tree():
		return
	_t += d
	if _fx_t >= 0.0:
		_fx_t += d
		if _fx_t > 1.6:
			_fx_t = -1.0
	if animate or _fx_t >= 0.0:
		queue_redraw()


func _unit() -> float:
	return clampf(minf(size.x / 1000.0, size.y / 640.0), 0.45, 2.0)


func _style(i: int) -> Color:
	return (STYLE.get(biome, STYLE["Forêt"]) as Array)[i]


# ── Sprites de bâtiments (V61b) ──────────────────────────────────────────────

## Chemin du sprite d'un bâtiment (niveau 0 : sans suffixe, ex. caserne).
static func sprite_path(nation_key: String, building: String, level: int = 0) -> String:
	if level > 0:
		return "%s/%s/%s_%d.png" % [SPRITE_DIR, nation_key, building, level]
	return "%s/%s/%s.png" % [SPRITE_DIR, nation_key, building]


## Texture découpée d'un bâtiment pour la nation courante (null → dessin vectoriel).
func _sprite(building: String, level: int = 0) -> Texture2D:
	var path: String = sprite_path(String(NATION_KEY.get(biome, "sylvestre")), building, level)
	if _tex_cache.has(path):
		return _tex_cache[path]
	var tex: Texture2D = null
	if ResourceLoader.exists(path):
		tex = load(path) as Texture2D
	_tex_cache[path] = tex
	return tex


## Affiche le sprite d'un bâtiment posé au sol en g ; faux → dessiner en vectoriel.
func _draw_tex_if_any(sprite_key: String, level: int, g: Vector2, u: float) -> bool:
	var tex: Texture2D = _sprite(sprite_key, level)
	if tex == null:
		return false
	var dw: float = SPRITE_WIDTH.get(sprite_key, 180.0) * u
	_shadow(g, dw * 0.72, u)
	var ts: Vector2 = tex.get_size()
	var dh: float = dw * ts.y / maxf(ts.x, 1.0)
	draw_texture_rect(tex, Rect2(g.x - dw * 0.5, g.y - dh, dw, dh), false)
	return true


# ── Dessin général ─────────────────────────────────────────────────────────

func _draw() -> void:
	var u: float = _unit()
	var ground: Color = _style(3)
	# ciel / illustration de la Nation en fond
	if art != null:
		var ts: Vector2 = art.get_size()
		var sc: float = maxf(size.x / ts.x, size.y * 0.75 / ts.y)
		var dw: Vector2 = ts * sc
		draw_texture_rect(art, Rect2(Vector2((size.x - dw.x) * 0.5, size.y * 0.62 - dw.y), dw), false, Color(0.66, 0.66, 0.72))
	else:
		draw_rect(Rect2(Vector2.ZERO, size), _style(1).darkened(0.6))
	# sol : fondu de l'illustration vers la place de la ville
	if _fade == null:
		var gr := Gradient.new()
		gr.colors = PackedColorArray([Color(ground.r, ground.g, ground.b, 0.0), ground])
		_fade = GradientTexture2D.new()
		_fade.gradient = gr
		_fade.fill_from = Vector2(0.5, 0.0)
		_fade.fill_to = Vector2(0.5, 1.0)
		_fade.width = 4
		_fade.height = 128
	draw_texture_rect(_fade, Rect2(0, size.y * 0.30, size.x, size.y * 0.31), false)
	draw_rect(Rect2(0, size.y * 0.60, size.x, size.y * 0.40), ground)
	if threat:
		var pulse: float = 0.5 + 0.5 * sin(_t * 2.0)
		for i: int in range(4):
			draw_rect(Rect2(Vector2(float(i) * 6.0, float(i) * 6.0), size - Vector2(float(i) * 12.0, float(i) * 12.0)), Color(0.95, 0.15, 0.08, (0.35 - 0.08 * float(i)) * (0.5 + 0.5 * pulse)), false, 6.0)
	# place pavée et chemins
	var hall_p: Vector2 = (PLOTS["hall"] as Vector2) * size
	var path_col := Color(0.86, 0.78, 0.60, 0.55)
	for key: String in PLOTS.keys():
		if key == "hall":
			continue
		var p: Vector2 = (PLOTS[key] as Vector2) * size
		draw_line(hall_p + Vector2(0, 8 * u), p, Color(0.20, 0.15, 0.10, 0.22), 14.0 * u, true)
		draw_line(hall_p + Vector2(0, 8 * u), p, path_col, 9.0 * u, true)
	_ellipse(hall_p + Vector2(0, 14 * u), Vector2(170, 52) * u, Color(0.80, 0.74, 0.60, 0.85))
	_ellipse(hall_p + Vector2(0, 14 * u), Vector2(150, 42) * u, Color(0.72, 0.66, 0.52, 0.85))
	# lanternes autour de la place (elles s'allument et vacillent)
	for i: int in range(6):
		var a: float = PI * (0.08 + 0.84 * float(i) / 5.0)
		var lp: Vector2 = hall_p + Vector2(-cos(a) * 190.0 * u, 14.0 * u + sin(a) * 62.0 * u)
		draw_line(lp, lp + Vector2(0, -30 * u), Color(0.20, 0.16, 0.12), 2.5 * u, true)
		var fl: float = 0.75 + 0.25 * sin(_t * 9.0 + float(i) * 1.7)
		draw_circle(lp + Vector2(0, -32 * u), 9.0 * u, Color(1.0, 0.80, 0.35, 0.22 * fl))
		draw_circle(lp + Vector2(0, -32 * u), 3.5 * u, Color(1.0, 0.88, 0.50, fl))
	# muraille : rempart en avant de la ville
	var wall_lv: int = int(levels.get("muraille", 0))
	if wall_lv > 0:
		_rampart(wall_lv, u)
	# habitants
	_villagers(u)
	# bâtiments, du fond vers l'avant
	var keys: Array = PLOTS.keys()
	keys.sort_custom(func(a: String, b: String) -> bool: return (PLOTS[a] as Vector2).y < (PLOTS[b] as Vector2).y)
	for key: String in keys:
		_draw_plot(key, (PLOTS[key] as Vector2) * size, u)
	if ravaged:
		for i: int in range(5):
			var ph: float = fposmod(_t * 0.35 + float(i) * 0.2, 1.0)
			var sp: Vector2 = hall_p + Vector2(-60.0 * u + float(i) * 30.0 * u + sin(ph * 6.0) * 8.0 * u, -120.0 * u - ph * 120.0 * u)
			draw_circle(sp, (10.0 + ph * 22.0) * u, Color(0.15, 0.14, 0.14, 0.55 * (1.0 - ph)))
	if _fx_t >= 0.0 and PLOTS.has(_fx_key):
		_draw_fx((PLOTS[_fx_key] as Vector2) * size, u)


func _draw_plot(key: String, g: Vector2, u: float) -> void:
	var sel: bool = key == selected
	if sel:
		var pulse: float = 0.5 + 0.5 * sin(_t * 3.0)
		_ellipse(g, Vector2(84, 26) * u * (1.3 if key == "hall" else 1.0), Color(1.0, 0.85, 0.35, 0.25 + 0.2 * pulse))
		draw_set_transform(g, 0.0, Vector2(1.0, 0.32))
		draw_arc(Vector2.ZERO, 88.0 * u * (1.3 if key == "hall" else 1.0), 0.0, TAU, 48, Color(1.0, 0.86, 0.40, 0.9), 3.0 * u / 0.32 * 0.32, true)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	var lv: int = 0
	match key:
		"hall":
			lv = city_level
			if not _draw_tex_if_any("hall", lv, g, u):
				_hall(g, u)
		"barracks":
			lv = 1
			if not _draw_tex_if_any("caserne", 0, g, u):
				_barracks(g, u)
			_troops_drill(g, u)
		"residence":
			lv = 1
			if not _draw_tex_if_any("residence", 0, g, u):
				_residence(g, u)
			_governor_stand(g, u)
		"wonder":
			lv = 1 if wonder else 0
			if wonder:
				if not _draw_tex_if_any("merveille", 0, g, u):
					_wonder(g, u)
			else:
				_empty_plot(g, u, bool(locked.get("wonder", true)))
		_:
			lv = int(levels.get(key, 0))
			if lv <= 0:
				_empty_plot(g, u, bool(locked.get(key, false)))
			elif not _draw_tex_if_any(key, lv, g, u):
				call("_b_" + key, g, u, lv)
	_plate(key, g, u, lv)


## Nom et niveau sous chaque bâtiment.
func _plate(key: String, g: Vector2, u: float, lv: int) -> void:
	var font: Font = get_theme_default_font()
	var fs: int = int(clampf(17.0 * u, 12.0, 30.0))
	var txt: String = String(LABELS.get(key, key))
	var col := Color(1.0, 0.96, 0.86)
	if key == "hall":
		txt = ConquestSystem.level_name(city_level)
		col = Color(1.0, 0.88, 0.45)
	elif key == "wonder":
		txt = String(ConquestSystem.wonder_for(biome)["label"]) if wonder else "Merveille"
		col = Color(1.0, 0.88, 0.45) if wonder else Color(0.85, 0.85, 0.82)
	elif key in BUILD_ORDER:
		if lv <= 0:
			txt = ("" if bool(locked.get(key, false)) else "+ ") + txt
			col = Color(0.70, 0.70, 0.68) if bool(locked.get(key, false)) else Color(0.92, 0.92, 0.86)
	var w: float = font.get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
	var p: Vector2 = g + Vector2(-w * 0.5, 28.0 * u)
	draw_string_outline(font, p, txt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, int(5 * u) + 2, Color(0.05, 0.04, 0.02, 0.9))
	draw_string(font, p, txt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, col)
	# étoiles de niveau
	var maxs: int = 0
	var cur: int = 0
	if key in BUILD_ORDER and lv > 0:
		maxs = ConquestSystem.BUILD_MAX_LEVEL
		cur = lv
	elif key == "hall":
		maxs = ConquestSystem.MAX_LEVEL
		cur = city_level
	for i: int in range(maxs):
		var sp: Vector2 = g + Vector2((float(i) - float(maxs - 1) * 0.5) * 15.0 * u, 42.0 * u)
		_star(sp, 6.5 * u, Color(1.0, 0.82, 0.30) if i < cur else Color(0.25, 0.22, 0.18, 0.85))


# ── Formes de base ─────────────────────────────────────────────────────────

func _ellipse(c: Vector2, r: Vector2, col: Color) -> void:
	draw_set_transform(c, 0.0, Vector2(1.0, r.y / maxf(r.x, 0.01)))
	draw_circle(Vector2.ZERO, r.x, col)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


func _star(c: Vector2, r: float, col: Color) -> void:
	var pts := PackedVector2Array()
	for i: int in range(10):
		var a: float = -PI * 0.5 + float(i) * PI / 5.0
		pts.append(c + Vector2(cos(a), sin(a)) * (r if i % 2 == 0 else r * 0.45))
	draw_colored_polygon(pts, col)
	pts.append(pts[0])
	draw_polyline(pts, Color(0.2, 0.12, 0.04, 0.8), 1.0, true)


func _shadow(g: Vector2, w: float, u: float) -> void:
	_ellipse(g + Vector2(4 * u, 2 * u), Vector2(w * 0.62, w * 0.16), Color(0, 0, 0, 0.30))


## Maison : corps, toit à deux pans, porte, fenêtres. Retourne le sommet du toit.
func _house(g: Vector2, w: float, h: float, roof_h: float, wall: Color, roof: Color, u: float, windows: int = 1) -> Vector2:
	var x0: float = g.x - w * 0.5
	var y0: float = g.y - h
	draw_rect(Rect2(x0, y0, w, h), wall)
	draw_rect(Rect2(x0 + w * 0.62, y0, w * 0.38, h), wall.darkened(0.16))
	draw_rect(Rect2(x0, y0, w, h), wall.darkened(0.5), false, 1.5 * u)
	var over: float = w * 0.08
	draw_colored_polygon(PackedVector2Array([Vector2(x0 - over, y0), Vector2(g.x, y0 - roof_h), Vector2(x0 + w + over, y0)]), roof)
	draw_colored_polygon(PackedVector2Array([Vector2(g.x, y0 - roof_h), Vector2(x0 + w + over, y0), Vector2(g.x + w * 0.1, y0)]), roof.darkened(0.2))
	draw_polyline(PackedVector2Array([Vector2(x0 - over, y0), Vector2(g.x, y0 - roof_h), Vector2(x0 + w + over, y0)]), roof.darkened(0.5), 1.5 * u, true)
	var dw: float = minf(w * 0.22, 16.0 * u)
	draw_rect(Rect2(g.x - dw * 0.5, g.y - h * 0.48, dw, h * 0.48), Color(0.22, 0.14, 0.08))
	for i: int in range(windows):
		var wx: float = x0 + w * (0.18 + 0.64 * float(i) / maxf(1.0, float(windows - 1))) if windows > 1 else x0 + w * 0.2
		var lit: float = 0.6 + 0.4 * sin(_t * 1.3 + wx)
		draw_rect(Rect2(wx - 4 * u, y0 + h * 0.25, 8 * u, 8 * u), Color(1.0, 0.82, 0.40, 0.55 + 0.35 * lit))
	return Vector2(g.x, y0 - roof_h)


## Tour : fût et toit conique. Retourne la pointe.
func _tower(g: Vector2, w: float, h: float, wall: Color, roof: Color, u: float) -> Vector2:
	draw_rect(Rect2(g.x - w * 0.5, g.y - h, w, h), wall.darkened(0.06))
	draw_rect(Rect2(g.x, g.y - h, w * 0.5, h), wall.darkened(0.2))
	draw_rect(Rect2(g.x - w * 0.5, g.y - h, w, h), wall.darkened(0.5), false, 1.5 * u)
	var top: Vector2 = Vector2(g.x, g.y - h - w * 1.1)
	draw_colored_polygon(PackedVector2Array([Vector2(g.x - w * 0.65, g.y - h), top, Vector2(g.x + w * 0.65, g.y - h)]), roof)
	draw_colored_polygon(PackedVector2Array([top, Vector2(g.x + w * 0.65, g.y - h), Vector2(g.x + w * 0.1, g.y - h)]), roof.darkened(0.2))
	draw_rect(Rect2(g.x - 3 * u, g.y - h * 0.7, 6 * u, 9 * u), Color(1.0, 0.82, 0.40, 0.8))
	return top


func _flag(top: Vector2, col: Color, u: float, big: float = 1.0) -> void:
	var pole: Vector2 = top + Vector2(0, -24 * u * big)
	draw_line(top, pole, Color(0.25, 0.17, 0.08), 2.0 * u, true)
	var pts := PackedVector2Array()
	var fw: float = 22.0 * u * big
	var fh: float = 13.0 * u * big
	for i: int in range(7):
		var x: float = float(i) / 6.0
		pts.append(pole + Vector2(x * fw, sin(_t * 5.0 - x * 4.0) * 2.5 * u * x))
	for i: int in range(6, -1, -1):
		var x2: float = float(i) / 6.0
		pts.append(pole + Vector2(x2 * fw, fh + sin(_t * 5.0 - x2 * 4.0) * 2.5 * u * x2))
	draw_colored_polygon(pts, col)


func _smoke(p: Vector2, u: float, dark: bool = false) -> void:
	for k: int in range(4):
		var ph: float = fposmod(_t * 0.4 + float(k) * 0.25, 1.0)
		var sp: Vector2 = p + Vector2(sin(ph * 5.0 + float(k)) * 4.0 * u + ph * 14.0 * u, -ph * 46.0 * u)
		var c: float = 0.25 if dark else 0.85
		draw_circle(sp, (4.0 + ph * 9.0) * u, Color(c, c, c * 1.02, 0.5 * (1.0 - ph)))


func _empty_plot(g: Vector2, u: float, is_locked: bool) -> void:
	_ellipse(g, Vector2(52, 16) * u, Color(0.16, 0.12, 0.08, 0.35))
	draw_set_transform(g, 0.0, Vector2(1.0, 0.31))
	for i: int in range(16):
		var a: float = float(i) / 16.0 * TAU
		draw_arc(Vector2.ZERO, 52.0 * u, a, a + TAU / 32.0, 3, Color(0.95, 0.88, 0.65, 0.75), 2.0 * u, true)
	draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
	# piquets de chantier
	for sx: float in [-1.0, 1.0]:
		draw_line(g + Vector2(sx * 40.0 * u, 0), g + Vector2(sx * 40.0 * u, -18.0 * u), Color(0.45, 0.32, 0.18), 3.0 * u, true)
	if is_locked:
		var c: Vector2 = g + Vector2(0, -30.0 * u)
		draw_arc(c + Vector2(0, -8 * u), 9.0 * u, PI, TAU, 12, Color(0.85, 0.85, 0.90), 3.5 * u, true)
		draw_rect(Rect2(c + Vector2(-13, -8) * u, Vector2(26, 20) * u), Color(0.92, 0.75, 0.30))
		draw_rect(Rect2(c + Vector2(-13, -8) * u, Vector2(26, 20) * u), Color(0.30, 0.18, 0.05), false, 1.5 * u)
	else:
		var c2: Vector2 = g + Vector2(0, -28.0 * u)
		var pulse: float = 0.5 + 0.5 * sin(_t * 2.5 + g.x)
		draw_circle(c2, (15.0 + 2.0 * pulse) * u, Color(1.0, 0.85, 0.35, 0.85))
		draw_line(c2 + Vector2(-8, 0) * u, c2 + Vector2(8, 0) * u, Color(0.25, 0.15, 0.04), 3.5 * u, true)
		draw_line(c2 + Vector2(0, -8) * u, c2 + Vector2(0, 8) * u, Color(0.25, 0.15, 0.04), 3.5 * u, true)


# ── Bâtiments principaux ───────────────────────────────────────────────────

func _hall(g: Vector2, u: float) -> void:
	var wall: Color = _style(0)
	var roof: Color = _style(1)
	var trim: Color = _style(2)
	var lv: int = city_level
	var w: float = (110.0 + 12.0 * float(lv)) * u
	_shadow(g, w * (1.6 if lv >= 2 else 1.0), u)
	if lv >= 2:   # ailes
		_house(g + Vector2(-w * 0.62, 0), w * 0.55, 46.0 * u, 26.0 * u, wall.darkened(0.06), roof.darkened(0.08), u)
		_house(g + Vector2(w * 0.62, 0), w * 0.55, 46.0 * u, 26.0 * u, wall.darkened(0.06), roof.darkened(0.08), u)
	if lv >= 4:   # tours d'angle
		var t1: Vector2 = _tower(g + Vector2(-w * 0.95, 4 * u), 26.0 * u, 110.0 * u, wall, roof, u)
		var t2: Vector2 = _tower(g + Vector2(w * 0.95, 4 * u), 26.0 * u, 110.0 * u, wall, roof, u)
		_flag(t1, trim, u, 0.8)
		_flag(t2, trim, u, 0.8)
	var top: Vector2 = _house(g, w, (64.0 + 8.0 * float(lv)) * u, (40.0 + 4.0 * float(lv)) * u, wall, roof, u, 3)
	draw_rect(Rect2(g.x - w * 0.5, g.y - (64.0 + 8.0 * float(lv)) * u, w, 6 * u), trim)
	if lv >= 3:   # tour centrale ou dôme
		var ct: Vector2 = Vector2(g.x, top.y + 26.0 * u)
		draw_rect(Rect2(ct.x - 18 * u, ct.y - 40 * u, 36 * u, 40 * u), wall.lightened(0.05))
		draw_rect(Rect2(ct.x - 18 * u, ct.y - 40 * u, 36 * u, 40 * u), wall.darkened(0.5), false, 1.5 * u)
		draw_circle(Vector2(ct.x, ct.y - 22 * u), 7.0 * u, Color(1.0, 0.92, 0.6))   # horloge / vitrail
		if lv >= 5:
			draw_circle(Vector2(ct.x, ct.y - 40 * u), 22.0 * u, trim)
			draw_rect(Rect2(ct.x - 22 * u, ct.y - 40 * u, 44 * u, 4 * u), trim.darkened(0.3))
			var spire := Vector2(ct.x, ct.y - 92 * u)
			draw_colored_polygon(PackedVector2Array([Vector2(ct.x - 5 * u, ct.y - 58 * u), spire, Vector2(ct.x + 5 * u, ct.y - 58 * u)]), Color(1.0, 0.85, 0.35))
			draw_circle(spire, 4.0 * u + sin(_t * 3.0) * 1.0 * u, Color(1.0, 0.95, 0.7, 0.9))
			_flag(spire, Color(0.20, 0.62, 0.34), u, 1.2)
		else:
			var cone := Vector2(ct.x, ct.y - 78 * u)
			draw_colored_polygon(PackedVector2Array([Vector2(ct.x - 24 * u, ct.y - 40 * u), cone, Vector2(ct.x + 24 * u, ct.y - 40 * u)]), roof.lightened(0.08))
			_flag(cone, Color(0.20, 0.62, 0.34), u, 1.0)
	else:
		_flag(top, Color(0.20, 0.62, 0.34), u, 0.9)
	_smoke(Vector2(g.x + w * 0.3, g.y - (64.0 + 8.0 * float(lv)) * u - 18.0 * u), u)


func _barracks(g: Vector2, u: float) -> void:
	var wall: Color = _style(0).darkened(0.08)
	var roof: Color = _style(1)
	var w: float = 120.0 * u
	var h: float = 44.0 * u
	_shadow(g, w, u)
	draw_rect(Rect2(g.x - w * 0.5, g.y - h, w, h), wall)
	draw_rect(Rect2(g.x - w * 0.5, g.y - h, w, h), wall.darkened(0.5), false, 1.5 * u)
	for i: int in range(7):   # créneaux
		if i % 2 == 0:
			draw_rect(Rect2(g.x - w * 0.5 + float(i) * w / 7.0, g.y - h - 9 * u, w / 7.0, 9 * u), wall.lightened(0.05))
	draw_rect(Rect2(g.x - 13 * u, g.y - 30 * u, 26 * u, 30 * u), Color(0.20, 0.13, 0.08))
	var top: Vector2 = _tower(g + Vector2(w * 0.38, 0), 30.0 * u, 70.0 * u, wall, roof, u)
	_flag(top, Color(0.55, 0.68, 0.95), u, 0.9)


## Soldats à l'exercice devant la caserne (dessinés par-dessus le sprite aussi).
func _troops_drill(g: Vector2, u: float) -> void:
	for i: int in range(mini(troops, 12)):
		var row: int = i / 6
		var col: int = i % 6
		var sx: float = g.x - 52 * u + float(col) * 19.0 * u + sin(_t * 1.2 + float(i)) * 3.0 * u
		var sy: float = g.y + 10.0 * u + float(row) * 13.0 * u
		var bob: float = absf(sin(_t * 4.0 + float(i) * 0.7)) * 2.0 * u
		draw_circle(Vector2(sx, sy + 2 * u), 4.5 * u, Color(0, 0, 0, 0.3))
		draw_rect(Rect2(sx - 3.5 * u, sy - 12 * u - bob, 7 * u, 10 * u), Color(0.35, 0.45, 0.70))
		draw_circle(Vector2(sx, sy - 15 * u - bob), 3.4 * u, Color(0.95, 0.80, 0.62))
		draw_line(Vector2(sx + 5 * u, sy - 2 * u - bob), Vector2(sx + 5 * u, sy - 24 * u - bob), Color(0.75, 0.75, 0.78), 1.5 * u, true)


func _residence(g: Vector2, u: float) -> void:
	var wall: Color = _style(0).lightened(0.10)
	var roof: Color = _style(1).darkened(0.05)
	var trim: Color = _style(2)
	_shadow(g, 120.0 * u, u)
	var top: Vector2 = _house(g, 104.0 * u, 58.0 * u, 34.0 * u, wall, roof, u, 2)
	for i: int in range(4):   # colonnade
		var x: float = g.x - 40 * u + float(i) * 26.7 * u
		draw_rect(Rect2(x - 3 * u, g.y - 30 * u, 6 * u, 30 * u), trim.lightened(0.2))
	draw_rect(Rect2(g.x - 50 * u, g.y - 34 * u, 100 * u, 5 * u), trim)
	_flag(top, Color(0.85, 0.62, 0.90), u, 0.9)


## Le gouverneur se tient devant sa résidence (dessiné par-dessus le sprite aussi).
func _governor_stand(g: Vector2, u: float) -> void:
	if hero_tex != null:
		var hs: float = 70.0 * u
		var hp: Vector2 = g + Vector2(40 * u, 12 * u)
		_ellipse(hp, Vector2(18, 6) * u, Color(0, 0, 0, 0.35))
		var bob: float = sin(_t * 1.8) * 1.5 * u
		draw_texture_rect(hero_tex, Rect2(hp - Vector2(hs * 0.5, hs - 4 * u + bob), Vector2(hs, hs)), false)


func _wonder(g: Vector2, u: float) -> void:
	var trim: Color = _style(2)
	var roof: Color = _style(1)
	var wall: Color = _style(0)
	var pulse: float = 0.5 + 0.5 * sin(_t * 2.0)
	_ellipse(g, Vector2(80, 22) * u, Color(trim.r, trim.g, trim.b, 0.25 + 0.15 * pulse))
	_shadow(g, 90.0 * u, u)
	match wonder_shape:
		"tree":
			draw_rect(Rect2(g.x - 10 * u, g.y - 70 * u, 20 * u, 70 * u), Color(0.42, 0.28, 0.16))
			for k: int in range(5):
				var a: float = float(k) / 5.0 * TAU + sin(_t * 0.6) * 0.05
				draw_circle(g + Vector2(cos(a) * 34.0 * u, -96.0 * u + sin(a) * 18.0 * u), 30.0 * u, roof.lightened(0.05 * float(k % 2)))
			draw_circle(g + Vector2(0, -104.0 * u), 34.0 * u, roof.lightened(0.12))
			for k2: int in range(6):
				var ph: float = fposmod(_t * 0.3 + float(k2) / 6.0, 1.0)
				draw_circle(g + Vector2(sin(float(k2) * 2.1) * 50.0 * u, -60.0 * u - ph * 80.0 * u), 2.5 * u, Color(trim.r, trim.g, trim.b, 1.0 - ph))
		"crystal":
			for k: int in range(3):
				var off: float = (float(k) - 1.0) * 26.0 * u
				var hgt: float = (120.0 if k == 1 else 70.0) * u
				draw_colored_polygon(PackedVector2Array([g + Vector2(off - 16 * u, 0), g + Vector2(off, -hgt), g + Vector2(off + 16 * u, 0)]),
					Color(trim.r, trim.g, trim.b, 0.85).lightened(0.1 * pulse))
				draw_line(g + Vector2(off, 0), g + Vector2(off, -hgt), Color(1, 1, 1, 0.6), 1.5 * u, true)
			draw_circle(g + Vector2(0, -90.0 * u), (24.0 + 6.0 * pulse) * u, Color(trim.r, trim.g, trim.b, 0.25))
		"pyramid":
			draw_colored_polygon(PackedVector2Array([g + Vector2(-70 * u, 0), g + Vector2(0, -95 * u), g + Vector2(70 * u, 0)]), wall)
			draw_colored_polygon(PackedVector2Array([g + Vector2(0, -95 * u), g + Vector2(70 * u, 0), g + Vector2(10 * u, 0)]), wall.darkened(0.2))
			draw_colored_polygon(PackedVector2Array([g + Vector2(-10 * u, -82 * u), g + Vector2(0, -95 * u), g + Vector2(10 * u, -82 * u)]), Color(1.0, 0.85, 0.35))
			_flag(g + Vector2(0, -95 * u), roof, u, 1.0)
		"forge":
			_house(g, 110.0 * u, 54.0 * u, 20.0 * u, wall.darkened(0.2), roof, u, 2)
			draw_rect(Rect2(g.x + 26 * u, g.y - 120 * u, 18 * u, 70 * u), wall.darkened(0.3))
			_smoke(Vector2(g.x + 35 * u, g.y - 124 * u), u, true)
			draw_rect(Rect2(g.x - 30 * u, g.y - 30 * u, 26 * u, 22 * u), Color(1.0, 0.5 + 0.2 * pulse, 0.12))
		"crypt":
			draw_rect(Rect2(g.x - 55 * u, g.y - 50 * u, 110 * u, 50 * u), wall.darkened(0.1))
			draw_circle(g + Vector2(0, -50 * u), 40.0 * u, wall)
			draw_rect(Rect2(g.x - 55 * u, g.y - 50 * u, 110 * u, 6 * u), trim)
			draw_rect(Rect2(g.x - 14 * u, g.y - 36 * u, 28 * u, 36 * u), Color(0.08, 0.05, 0.10))
			draw_circle(g + Vector2(0, -20 * u), 6.0 * u, Color(trim.r, trim.g, trim.b, 0.5 + 0.5 * pulse))
		"mill":
			var top: Vector2 = _tower(g, 40.0 * u, 80.0 * u, wall, roof, u)
			var hub: Vector2 = Vector2(g.x, g.y - 70 * u)
			for k: int in range(4):
				var a2: float = _t * 1.2 + float(k) * PI * 0.5
				var tip: Vector2 = hub + Vector2(cos(a2), sin(a2)) * 58.0 * u
				draw_line(hub, tip, Color(0.45, 0.32, 0.18), 3.0 * u, true)
				var nrm := Vector2(-sin(a2), cos(a2)) * 10.0 * u
				draw_colored_polygon(PackedVector2Array([hub.lerp(tip, 0.3), tip, tip + nrm, hub.lerp(tip, 0.3) + nrm]), Color(0.95, 0.93, 0.85))
			draw_circle(hub, 5.0 * u, Color(0.3, 0.2, 0.1))
			_flag(top, trim, u, 0.8)
		_:   # "tower" : phare / horloge
			var tp: Vector2 = _tower(g, 44.0 * u, 120.0 * u, wall, roof, u)
			var lamp: Vector2 = Vector2(g.x, g.y - 120 * u)
			draw_circle(lamp, (12.0 + 4.0 * pulse) * u, Color(1.0, 0.92, 0.55, 0.9))
			var a3: float = _t * 0.8
			draw_colored_polygon(PackedVector2Array([lamp, lamp + Vector2(cos(a3), sin(a3) * 0.3) * 160.0 * u + Vector2(0, -20 * u),
				lamp + Vector2(cos(a3), sin(a3) * 0.3) * 160.0 * u + Vector2(0, 20 * u)]), Color(1.0, 0.95, 0.6, 0.12))
			_flag(tp, trim, u, 0.8)


# ── Bâtiments de production (niveau 1 à 3) ─────────────────────────────────

func _b_scierie(g: Vector2, u: float, lv: int) -> void:
	_shadow(g, 100.0 * u, u)
	var top: Vector2 = _house(g + Vector2(-14 * u, 0), (66.0 + 10.0 * float(lv)) * u, 40.0 * u, 26.0 * u, Color(0.62, 0.44, 0.26), _style(1), u)
	for i: int in range(lv * 2 + 1):   # pile de rondins
		var lx: float = g.x + 30 * u + float(i % 3) * 11.0 * u
		var ly: float = g.y - 6 * u - float(i / 3) * 10.0 * u
		draw_circle(Vector2(lx, ly), 6.0 * u, Color(0.50, 0.32, 0.16))
		draw_circle(Vector2(lx, ly), 3.5 * u, Color(0.86, 0.68, 0.42))
	for k: int in range(1 if lv < 3 else 2):   # scie(s) circulaire(s)
		var sc: Vector2 = g + Vector2(-48 * u - float(k) * 4 * u, -24 * u - float(k) * 28 * u)
		var r: float = (13.0 + 2.0 * float(lv)) * u
		draw_circle(sc, r, Color(0.78, 0.80, 0.84))
		for j: int in range(10):
			var a: float = _t * 6.0 + float(j) * TAU / 10.0
			draw_line(sc + Vector2(cos(a), sin(a)) * r, sc + Vector2(cos(a + 0.2), sin(a + 0.2)) * (r + 4 * u), Color(0.55, 0.57, 0.62), 2.0 * u, true)
		draw_circle(sc, 3.0 * u, Color(0.3, 0.3, 0.32))
	if lv >= 2:
		_flag(top, RES_GLOW["Bois"], u, 0.7)


func _b_mine(g: Vector2, u: float, lv: int) -> void:
	_shadow(g, 110.0 * u, u)
	var rock := Color(0.48, 0.46, 0.48)
	var mh: float = (52.0 + 10.0 * float(lv)) * u
	draw_colored_polygon(PackedVector2Array([g + Vector2(-62 * u, 0), g + Vector2(-34 * u, -mh * 0.8), g + Vector2(-6 * u, -mh),
		g + Vector2(30 * u, -mh * 0.7), g + Vector2(62 * u, 0)]), rock)
	draw_colored_polygon(PackedVector2Array([g + Vector2(-6 * u, -mh), g + Vector2(30 * u, -mh * 0.7), g + Vector2(62 * u, 0), g + Vector2(10 * u, 0)]), rock.darkened(0.2))
	draw_circle(g + Vector2(-4 * u, -18 * u), 18.0 * u, Color(0.08, 0.06, 0.05))
	draw_rect(Rect2(g.x - 22 * u, g.y - 18 * u, 36 * u, 18 * u), Color(0.08, 0.06, 0.05))
	draw_rect(Rect2(g.x - 24 * u, g.y - 38 * u, 4 * u, 38 * u), Color(0.45, 0.30, 0.15))
	draw_rect(Rect2(g.x + 12 * u, g.y - 38 * u, 4 * u, 38 * u), Color(0.45, 0.30, 0.15))
	draw_rect(Rect2(g.x - 26 * u, g.y - 40 * u, 44 * u, 5 * u), Color(0.45, 0.30, 0.15))
	var glow: float = 0.6 + 0.4 * sin(_t * 3.0)
	draw_circle(g + Vector2(14 * u, -30 * u), 9.0 * u, Color(1.0, 0.75, 0.3, 0.25 * glow))
	draw_circle(g + Vector2(14 * u, -30 * u), 3.0 * u, Color(1.0, 0.85, 0.4))
	# wagonnet qui sort et rentre
	var cx: float = g.x - 4 * u + (0.5 + 0.5 * sin(_t * 0.8)) * 46.0 * u
	draw_line(g + Vector2(-10 * u, 2 * u), g + Vector2(60 * u, 2 * u), Color(0.35, 0.30, 0.28), 2.0 * u, true)
	draw_rect(Rect2(cx - 10 * u, g.y - 12 * u, 20 * u, 11 * u), Color(0.40, 0.28, 0.16))
	draw_circle(Vector2(cx - 3 * u, g.y - 13 * u), 4.0 * u, RES_GLOW["Fer"])
	draw_circle(Vector2(cx + 4 * u, g.y - 14 * u), 3.5 * u, RES_GLOW["Fer"].darkened(0.2))
	if lv >= 2:   # chevalement
		var hx: float = g.x - 40 * u
		draw_line(Vector2(hx - 12 * u, g.y - mh * 0.6), Vector2(hx, g.y - mh * 0.6 - 50 * u), Color(0.45, 0.30, 0.15), 3.0 * u, true)
		draw_line(Vector2(hx + 12 * u, g.y - mh * 0.6), Vector2(hx, g.y - mh * 0.6 - 50 * u), Color(0.45, 0.30, 0.15), 3.0 * u, true)
		draw_circle(Vector2(hx, g.y - mh * 0.6 - 50 * u), 7.0 * u, Color(0.35, 0.30, 0.28))
	if lv >= 3:
		_smoke(g + Vector2(40 * u, -mh * 0.7), u, true)


func _b_tannerie(g: Vector2, u: float, lv: int) -> void:
	_shadow(g, 110.0 * u, u)
	var tent := Color(0.80, 0.62, 0.40)
	draw_colored_polygon(PackedVector2Array([g + Vector2(-44 * u, 0), g + Vector2(-8 * u, -56 * u), g + Vector2(28 * u, 0)]), tent)
	draw_colored_polygon(PackedVector2Array([g + Vector2(-8 * u, -56 * u), g + Vector2(28 * u, 0), g + Vector2(-2 * u, 0)]), tent.darkened(0.2))
	draw_colored_polygon(PackedVector2Array([g + Vector2(-16 * u, 0), g + Vector2(-8 * u, -22 * u), g + Vector2(0, 0)]), Color(0.2, 0.12, 0.06))
	for i: int in range(lv + 1):   # séchoirs à peaux
		var rx: float = g.x + 30 * u + float(i) * 14.0 * u
		draw_line(Vector2(rx, g.y), Vector2(rx, g.y - 40 * u), Color(0.45, 0.30, 0.15), 2.0 * u, true)
		var sway: float = sin(_t * 1.5 + float(i)) * 2.0 * u
		draw_rect(Rect2(rx - 6 * u + sway, g.y - 38 * u, 12 * u, 20 * u), RES_GLOW["Cuir"].darkened(0.15 * float(i % 2)))
	if lv >= 2:
		_house(g + Vector2(-58 * u, 0), 36.0 * u, 30.0 * u, 18.0 * u, _style(0), _style(1), u)
	if lv >= 3:
		_smoke(g + Vector2(-58 * u, -50 * u), u)


func _b_cabane(g: Vector2, u: float, lv: int) -> void:
	_shadow(g, 80.0 * u, u)
	var top: Vector2 = _tower(g, (30.0 + 4.0 * float(lv)) * u, (60.0 + 16.0 * float(lv)) * u, _style(0).lerp(Color(0.5, 0.45, 0.7), 0.4), Color(0.36, 0.26, 0.62), u)
	var pulse: float = 0.5 + 0.5 * sin(_t * 2.6)
	var orb: Vector2 = top + Vector2(0, -14 * u + sin(_t * 1.7) * 3.0 * u)
	draw_circle(orb, (14.0 + 6.0 * pulse) * u, Color(0.72, 0.58, 1.0, 0.25))
	draw_circle(orb, 7.0 * u, Color(0.85, 0.78, 1.0))
	for k: int in range(lv * 2):
		var a: float = _t * 1.8 + float(k) * TAU / float(lv * 2)
		draw_circle(orb + Vector2(cos(a) * 22.0 * u, sin(a) * 8.0 * u), 2.2 * u, Color(0.80, 0.70, 1.0, 0.9))
	if lv >= 2:
		_house(g + Vector2(34 * u, 0), 38.0 * u, 28.0 * u, 18.0 * u, _style(0), Color(0.36, 0.26, 0.62), u)


func _b_verger(g: Vector2, u: float, lv: int) -> void:
	_shadow(g, 110.0 * u, u)
	var n: int = 1 + lv * 2
	for i: int in range(n):
		var tx: float = g.x - 48 * u + float(i) * 96.0 * u / maxf(1.0, float(n - 1))
		var ty: float = g.y - float(i % 2) * 10.0 * u
		var sway: float = sin(_t * 1.2 + float(i)) * 1.5 * u
		draw_rect(Rect2(tx - 3 * u, ty - 22 * u, 6 * u, 22 * u), Color(0.42, 0.28, 0.16))
		draw_circle(Vector2(tx + sway, ty - 32 * u), 15.0 * u, Color(0.25, 0.55, 0.25).lightened(0.05 * float(i % 2)))
		for j: int in range(3):
			draw_circle(Vector2(tx + sway + cos(float(j * 2 + i)) * 8.0 * u, ty - 32 * u + sin(float(j * 3 + i)) * 7.0 * u), 2.5 * u, Color(0.92, 0.30, 0.22))
	if lv >= 2:   # puits / ruche
		draw_circle(g + Vector2(0, 8 * u), 9.0 * u, Color(0.55, 0.55, 0.58))
		draw_circle(g + Vector2(0, 8 * u), 6.0 * u, Color(0.20, 0.35, 0.55))


func _b_muraille(g: Vector2, u: float, lv: int) -> void:
	_shadow(g, 110.0 * u, u)
	var stone: Color = _style(0).lerp(Color(0.62, 0.62, 0.64), 0.6)
	var h: float = (30.0 + 10.0 * float(lv)) * u
	draw_rect(Rect2(g.x - 50 * u, g.y - h, 100 * u, h), stone)
	draw_rect(Rect2(g.x - 50 * u, g.y - h, 100 * u, h), stone.darkened(0.5), false, 1.5 * u)
	for i: int in range(5):
		if i % 2 == 0:
			draw_rect(Rect2(g.x - 50 * u + float(i) * 20.0 * u, g.y - h - 9 * u, 20 * u, 9 * u), stone.lightened(0.05))
	for sx: float in [-1.0, 1.0]:
		var top: Vector2 = _tower(g + Vector2(sx * 50.0 * u, 0), 24.0 * u, h + 22.0 * u, stone, _style(1), u)
		if lv >= 3:
			_flag(top, _style(2), u, 0.6)


## Rempart dessiné en avant de toute la ville (muraille construite).
func _rampart(lv: int, u: float) -> void:
	var stone: Color = _style(0).lerp(Color(0.62, 0.62, 0.64), 0.6).darkened(0.1)
	var y: float = size.y - 4.0 * u
	var h: float = (12.0 + 6.0 * float(lv)) * u
	draw_rect(Rect2(0, y - h, size.x, h + 4 * u), stone)
	var n: int = int(size.x / (22.0 * u))
	for i: int in range(n):
		if i % 2 == 0:
			draw_rect(Rect2(float(i) * 22.0 * u, y - h - 8 * u, 22 * u, 8 * u), stone.lightened(0.06))
	draw_line(Vector2(0, y - h), Vector2(size.x, y - h), stone.darkened(0.4), 1.5 * u)


## Habitants qui vont et viennent entre l'hôtel de ville et les bâtiments.
func _villagers(u: float) -> void:
	var hall_p: Vector2 = (PLOTS["hall"] as Vector2) * size + Vector2(0, 10 * u)
	var targets: Array = []
	for key: String in PLOTS.keys():
		if key != "hall" and (key in ["barracks", "residence"] or int(levels.get(key, 0)) > 0 or (key == "wonder" and wonder)):
			targets.append(key)
	if targets.is_empty():
		return
	var n: int = 2 + city_level * 2
	var cols: Array = [Color(0.75, 0.30, 0.25), Color(0.25, 0.45, 0.75), Color(0.85, 0.70, 0.25), Color(0.40, 0.62, 0.35)]
	for i: int in range(n):
		var tgt: Vector2 = (PLOTS[targets[i % targets.size()]] as Vector2) * size
		var ph: float = fposmod(_t * (0.05 + 0.012 * float(i % 3)) + float(i) * 0.37, 1.0)
		var f: float = 1.0 - absf(ph * 2.0 - 1.0)   # aller-retour
		var p: Vector2 = hall_p.lerp(tgt, 0.12 + 0.76 * f) + Vector2(sin(float(i) * 3.1) * 6.0 * u, 0)
		var bob: float = absf(sin(_t * 7.0 + float(i))) * 1.6 * u
		_ellipse(p, Vector2(5, 2) * u, Color(0, 0, 0, 0.3))
		draw_rect(Rect2(p.x - 3 * u, p.y - 11 * u - bob, 6 * u, 9 * u), cols[i % cols.size()])
		draw_circle(Vector2(p.x, p.y - 14 * u - bob), 3.0 * u, Color(0.95, 0.80, 0.62))


func _draw_fx(g: Vector2, u: float) -> void:
	var t: float = _fx_t
	var a: float = clampf(1.0 - t / 1.6, 0.0, 1.0)
	_ellipse(g, Vector2(60 + 80 * t, 18 + 24 * t) * u, Color(0.85, 0.78, 0.62, 0.45 * a))
	for k: int in range(16):
		var ang: float = float(k) / 16.0 * TAU
		var r: float = (20.0 + 110.0 * t) * u
		var p: Vector2 = g + Vector2(cos(ang) * r, -60.0 * u + sin(ang) * r * 0.6 - 40.0 * t * u)
		_star(p, (5.0 + 3.0 * sin(t * 10.0 + float(k))) * u, Color(1.0, 0.85, 0.30, a))
	var font: Font = get_theme_default_font()
	var txt: String = "NIVEAU SUPÉRIEUR !" if _fx_key == "hall" else "★ CONSTRUIT !"
	var fs: int = int(26.0 * u)
	var w: float = font.get_string_size(txt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
	var tp: Vector2 = g + Vector2(-w * 0.5, -150.0 * u - 50.0 * t * u)
	draw_string_outline(font, tp, txt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, 6, Color(0.1, 0.05, 0.0, a))
	draw_string(font, tp, txt, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color(1.0, 0.88, 0.40, a))
