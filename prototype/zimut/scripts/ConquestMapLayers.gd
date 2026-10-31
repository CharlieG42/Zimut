class_name ConquestMapLayers
extends RefCounted
## ConquestMapLayers.gd — Couches vivantes de la carte de Conquête (V60).
##
## • Matériau de la carte peinte : eau qui scintille, lave qui pulse, cristaux qui luisent,
##   ombres de nuages qui dérivent (masques de couleur conquest_world_fx.png), territoire
##   de l'empire (teinte + frontière dorée), brouillard sur les terres inconnues.
## • TerritoryBaker : calcule une fois (SubViewport, mise à jour unique) la carte des
##   territoires à partir des villes ; la carte n'a plus qu'à la lire.
## • Routes : chemins courbes — pavés dorés dans l'empire, pointillés animés vers les cibles,
##   sentiers discrets ailleurs, colonne ennemie en marche pendant une offensive.
## • Pin : repère compact d'une ville (médaillon d'état, drapeau qui flotte, fumée, crâne
##   de général, pions de siège) — l'illustration complète reste dans le conseil.
## • Ambient : navires, oiseaux et nuages qui traversent la carte.

const STATE_OWNED := 1.0
const STATE_NEUTRAL := 2.0
const STATE_UNKNOWN := 3.0
const STATE_ENEMY := 4.0

const MAP_SHADER := """
shader_type canvas_item;
uniform sampler2D fx_masks : filter_linear, repeat_disable;
uniform sampler2D territory : filter_linear, repeat_disable;
uniform float fx = 1.0;          // 0 : rendu économique (pas d'animation)
uniform float has_territory = 0.0;

float hash(vec2 p) { return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }
float noise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	return mix(mix(hash(i), hash(i + vec2(1.0, 0.0)), f.x),
		mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), f.x), f.y);
}
float fbm(vec2 p) {
	float v = 0.0;
	float a = 0.55;
	for (int i = 0; i < 3; i++) { v += a * noise(p); p *= 2.03; a *= 0.5; }
	return v;
}

void fragment() {
	vec2 uv = UV;
	vec4 m = texture(fx_masks, uv);
	float t = TIME * fx;
	// eau : légère ondulation de l'image
	vec2 wuv = uv + fx * m.r * vec2(sin(uv.y * 160.0 + t * 1.4), cos(uv.x * 210.0 + t * 1.1)) * 0.00075;
	vec4 col = texture(TEXTURE, wuv);
	if (fx > 0.5) {
		// reflets qui scintillent sur l'eau
		float sh = noise(uv * vec2(150.0, 100.0) + vec2(t * 0.35, -t * 0.2));
		col.rgb += m.r * smoothstep(0.80, 0.97, sh) * 0.16 * vec3(0.85, 0.97, 1.0);
		// lave : pulsation lente, plus vive dans les coulées
		float lp = 0.5 + 0.5 * sin(t * 1.7 + noise(uv * 40.0 + t * 0.15) * 6.2831);
		col.rgb += m.g * (0.06 + 0.20 * lp) * vec3(1.0, 0.42, 0.08);
		// cristaux : lueur qui respire
		col.rgb += m.b * (0.05 + 0.16 * (0.5 + 0.5 * sin(t * 2.4 + uv.x * 60.0))) * vec3(0.55, 0.62, 1.0);
		// ombres de nuages qui dérivent
		float c = fbm(uv * vec2(3.2, 2.1) + vec2(t * 0.010, t * 0.004));
		col.rgb *= 1.0 - 0.17 * smoothstep(0.52, 0.82, c);
	} else {
		col.rgb += m.g * 0.12 * vec3(1.0, 0.42, 0.08) + m.b * 0.10 * vec3(0.55, 0.62, 1.0);
	}
	if (has_territory > 0.5) {
		vec4 ter = texture(territory, uv);
		// territoire de l'empire : terres plus vives et chaudes
		col.rgb = mix(col.rgb, col.rgb * vec3(1.04, 1.14, 0.90) + vec3(0.05, 0.06, 0.0), ter.r * 0.6);
		// terres des places fortes ennemies : assombries, rougeâtres
		col.rgb = mix(col.rgb, col.rgb * vec3(0.92, 0.68, 0.70), ter.a * 0.45);
		// brouillard sur les terres inconnues
		float mist = fbm(uv * vec2(9.0, 6.0) + vec2(t * 0.03, t * 0.01));
		float g = dot(col.rgb, vec3(0.30, 0.59, 0.11));
		vec3 fogged = mix(vec3(g * 0.55 + 0.08), vec3(0.80, 0.83, 0.88), 0.25 + 0.45 * mist);
		col.rgb = mix(col.rgb, fogged, ter.b * 0.88);
		// frontière dorée de l'empire
		col.rgb = mix(col.rgb, vec3(1.0, 0.86, 0.42), smoothstep(0.30, 0.85, ter.g) * 0.80);
	}
	COLOR = col;
}
"""

const BAKE_SHADER := """
shader_type canvas_item;
render_mode blend_disabled;
uniform vec4 cities[32];
uniform int count = 0;
uniform float radius = 0.088;
const vec2 ASP = vec2(1.5, 1.0);

// Champs « métaballes » : le territoire épouse les villes en formes souples.
void fragment() {
	vec2 uv = UV;
	float f_own = 0.0;
	float f_oth = 0.0;
	float f_unk = 0.0;
	float f_en = 0.0;
	for (int i = 0; i < 32; i++) {
		if (i >= count) { break; }
		vec4 c = cities[i];
		vec2 dd = (uv - c.xy) * ASP / radius;
		float f = exp(-dot(dd, dd) * 0.9);
		if (c.z < 1.5) { f_own += f; } else { f_oth += f; }
		if (c.z > 2.5 && c.z < 3.5) { f_unk += f; }
		if (c.z > 3.5) { f_en += f; }
	}
	float v = min(f_own - 0.22, f_own - f_oth);
	float own = smoothstep(-0.03, 0.08, v);
	float w = max(fwidth(v), 0.0001);
	float border = (1.0 - smoothstep(0.0, 1.3 * w, abs(v))) * step(0.08, f_own);
	float fog = clamp((f_unk - f_own) * 1.6, 0.0, 1.0);
	fog = smoothstep(0.08, 0.75, fog);
	float hostile = smoothstep(0.10, 0.8, clamp(f_en - f_own - 0.5 * f_unk, 0.0, 1.0));
	COLOR = vec4(own, border, fog, hostile);
}
"""

static var _map_shader: Shader = null


## Matériau de la carte peinte. masks : RGB = eau / lave / cristaux.
static func world_material(masks: Texture2D, low: bool) -> ShaderMaterial:
	if _map_shader == null:
		_map_shader = Shader.new()
		_map_shader.code = MAP_SHADER
	var mat := ShaderMaterial.new()
	mat.shader = _map_shader
	mat.set_shader_parameter("fx_masks", masks)
	mat.set_shader_parameter("fx", 0.0 if low else 1.0)
	return mat


## Calcule la carte des territoires dans une petite texture (mise à jour à la demande).
class TerritoryBaker:
	extends SubViewport
	var _rect: ColorRect

	func _init() -> void:
		size = Vector2i(768, 512)
		transparent_bg = true
		disable_3d = true
		render_target_update_mode = SubViewport.UPDATE_ONCE
		_rect = ColorRect.new()
		_rect.size = Vector2(size)
		var sh := Shader.new()
		sh.code = ConquestMapLayers.BAKE_SHADER
		var mat := ShaderMaterial.new()
		mat.shader = sh
		_rect.material = mat
		add_child(_rect)

	## cities : [{ "pos": Vector2 normalisée, "state": float (STATE_*) }]
	func bake(cities: Array) -> void:
		var arr: Array = []
		for c: Dictionary in cities:
			var p: Vector2 = c["pos"]
			arr.append(Vector4(p.x, p.y, float(c["state"]), 0.0))
		while arr.size() < 32:
			arr.append(Vector4(-5.0, -5.0, STATE_NEUTRAL, 0.0))
		var mat: ShaderMaterial = _rect.material
		mat.set_shader_parameter("cities", arr.slice(0, 32))
		mat.set_shader_parameter("count", mini(cities.size(), 32))
		render_target_update_mode = SubViewport.UPDATE_ONCE


## Routes de la carte : courbes calculées une fois, styles selon l'état, animations douces.
class Routes:
	extends Control
	var city_pos: Dictionary = {}        # id -> Vector2 normalisée
	var owned: Array = []
	var attackable: Array = []
	var unknown: Array = []
	var threat_city: String = ""
	var threat_from: String = ""
	var threat_progress: float = 0.0     # 0 = départ, 1 = aux portes
	var animate: bool = true
	var _t: float = 0.0
	var _curves: Dictionary = {}         # "a|b" -> PackedVector2Array (normalisée)

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE

	func _process(d: float) -> void:
		if not animate or not is_visible_in_tree():
			return
		_t += d
		queue_redraw()

	static func _bezier(a: Vector2, b: Vector2, seed_str: String) -> PackedVector2Array:
		var mid: Vector2 = (a + b) * 0.5
		var dir: Vector2 = b - a
		var perp := Vector2(-dir.y, dir.x)
		var k: float = float(absi(hash(seed_str)) % 7 - 3) * 0.045
		var c: Vector2 = mid + perp * k
		var pts := PackedVector2Array()
		for i: int in range(17):
			var t: float = float(i) / 16.0
			pts.append(a.lerp(c, t).lerp(c.lerp(b, t), t))
		return pts

	func curve(a_id: String, b_id: String) -> PackedVector2Array:
		var key: String = a_id + "|" + b_id
		if not _curves.has(key):
			var rkey: String = b_id + "|" + a_id
			if _curves.has(rkey):
				var rev: PackedVector2Array = _curves[rkey].duplicate()
				rev.reverse()
				_curves[key] = rev
			else:
				var s: String = a_id + b_id if a_id < b_id else b_id + a_id
				var pts: PackedVector2Array = _bezier(city_pos.get(a_id, Vector2.ZERO), city_pos.get(b_id, Vector2.ZERO), s)
				if a_id > b_id:
					pts = _bezier(city_pos.get(b_id, Vector2.ZERO), city_pos.get(a_id, Vector2.ZERO), s)
					pts.reverse()
				_curves[key] = pts
		var out := PackedVector2Array()
		for p: Vector2 in _curves[key]:
			out.append(p * size)
		return out

	## Raccourcit une courbe aux deux bouts (ne pas passer sous les repères des villes).
	static func _trim(pts: PackedVector2Array, cut: float) -> PackedVector2Array:
		var out := PackedVector2Array()
		var total: float = 0.0
		for i: int in range(1, pts.size()):
			total += pts[i].distance_to(pts[i - 1])
		var acc: float = 0.0
		for i: int in range(pts.size()):
			if i > 0:
				acc += pts[i].distance_to(pts[i - 1])
			if acc >= cut and acc <= total - cut:
				out.append(pts[i])
		return out

	func _dashed(pts: PackedVector2Array, dash: float, gap: float, phase: float, col: Color, w: float) -> void:
		var period: float = dash + gap
		var acc: float = -fposmod(phase, period)
		for i: int in range(1, pts.size()):
			var a: Vector2 = pts[i - 1]
			var b: Vector2 = pts[i]
			var seg: float = a.distance_to(b)
			var s: float = 0.0
			while s < seg:
				var local: float = fposmod(acc + s, period)
				var step: float = minf(seg - s, (dash - local) if local < dash else (period - local))
				step = maxf(step, 0.5)
				if local < dash:
					draw_line(a.lerp(b, s / seg), a.lerp(b, minf(s + step, seg) / seg), col, w, true)
				s += step
			acc += seg

	func _dotted(pts: PackedVector2Array, spacing: float, col: Color, r: float) -> void:
		var carry: float = 0.0
		for i: int in range(1, pts.size()):
			var a: Vector2 = pts[i - 1]
			var b: Vector2 = pts[i]
			var seg: float = a.distance_to(b)
			var s: float = carry
			while s < seg:
				draw_circle(a.lerp(b, s / seg), r, col)
				s += spacing
			carry = s - seg

	func _draw() -> void:
		var march: float = _t * 26.0
		for pair: Array in ProgressionManager.CONQUEST_ROUTES:
			var a_id: String = String(pair[0])
			var b_id: String = String(pair[1])
			var a_own: bool = owned.has(a_id)
			var b_own: bool = owned.has(b_id)
			var pts: PackedVector2Array
			if b_own and not a_own:
				pts = curve(b_id, a_id)     # toujours dessinée depuis l'empire vers l'extérieur
			else:
				pts = curve(a_id, b_id)
			pts = _trim(pts, 22.0)
			if pts.size() < 2:
				continue
			var fade: float = 0.35 if (unknown.has(a_id) or unknown.has(b_id)) else 1.0
			if a_own and b_own:
				draw_polyline(pts, Color(0.22, 0.14, 0.06, 0.55), 8.0, true)
				draw_polyline(pts, Color(0.93, 0.76, 0.40, 0.95), 4.5, true)
				_dashed(pts, 6.0, 12.0, 0.0, Color(1.0, 0.94, 0.70, 0.55), 1.6)
			elif (a_own and attackable.has(b_id)) or (b_own and attackable.has(a_id)):
				draw_polyline(pts, Color(0.18, 0.10, 0.04, 0.50), 7.0, true)
				_dashed(pts, 14.0, 9.0, -march, Color(1.0, 0.84, 0.36, 0.98 * fade), 4.0)
				# pointe de flèche à l'arrivée
				var tip: Vector2 = pts[pts.size() - 1]
				var dir: Vector2 = (tip - pts[pts.size() - 2]).normalized()
				var nrm := Vector2(-dir.y, dir.x)
				draw_colored_polygon(PackedVector2Array([tip + dir * 9.0, tip - dir * 6.0 + nrm * 7.0, tip - dir * 6.0 - nrm * 7.0]),
					Color(1.0, 0.84, 0.36, fade))
			else:
				_dotted(pts, 11.0, Color(0.20, 0.13, 0.06, 0.55 * fade), 2.4)
				_dotted(pts, 11.0, Color(0.93, 0.84, 0.62, 0.55 * fade), 1.4)
		_draw_threat()

	## Colonne ennemie en marche vers la ville menacée.
	func _draw_threat() -> void:
		if threat_city == "" or threat_from == "" or not city_pos.has(threat_from):
			return
		var pts: PackedVector2Array = _trim(curve(threat_from, threat_city), 20.0)
		if pts.size() < 2:
			return
		_dashed(pts, 10.0, 8.0, -_t * 34.0, Color(0.95, 0.20, 0.16, 0.92), 3.5)
		var f: float = clampf(threat_progress + sin(_t * 1.3) * 0.025, 0.0, 1.0)
		var total: float = 0.0
		for i: int in range(1, pts.size()):
			total += pts[i].distance_to(pts[i - 1])
		var want: float = total * f
		var p: Vector2 = pts[0]
		var acc: float = 0.0
		for i: int in range(1, pts.size()):
			var seg: float = pts[i].distance_to(pts[i - 1])
			if acc + seg >= want:
				p = pts[i - 1].lerp(pts[i], (want - acc) / maxf(seg, 0.001))
				break
			acc += seg
		draw_set_transform(p, 0.0, Vector2(1.35, 1.35))
		p = Vector2.ZERO
		# trois soldats qui piétinent derrière l'étendard
		for k: int in range(3):
			var off := Vector2(-10.0 + 10.0 * float(k), 12.0 + absf(sin(_t * 6.0 + float(k))) * -3.0)
			draw_circle(p + off + Vector2(0, 2), 4.5, Color(0.0, 0.0, 0.0, 0.35))
			draw_circle(p + off, 4.0, Color(0.20, 0.06, 0.08))
			draw_line(p + off + Vector2(2, -2), p + off + Vector2(5, -11), Color(0.75, 0.75, 0.78), 1.5, true)
		draw_line(p + Vector2(0, 8), p + Vector2(0, -22), Color(0.15, 0.10, 0.08), 2.5, true)
		var wave: float = sin(_t * 5.0) * 2.0
		draw_colored_polygon(PackedVector2Array([p + Vector2(0, -22), p + Vector2(17, -19 + wave), p + Vector2(15, -11 + wave), p + Vector2(0, -12)]),
			Color(0.55, 0.06, 0.08))
		var font: Font = get_theme_default_font()
		draw_string(font, p + Vector2(3, -13 + wave * 0.5), "☠", HORIZONTAL_ALIGNMENT_LEFT, -1, 11, Color(1.0, 0.92, 0.85))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)


## Repère compact d'une ville, dessiné dans un bouton (cible tactile généreuse).
class Pin:
	extends Control
	var state: String = "neutral"   # capital / owned / attackable / neutral / enemy / unknown / lost
	var accent: Color = Color(0.6, 0.7, 0.5)
	var selected: bool = false
	var smoke: bool = false
	var general: bool = false
	var threatened: bool = false
	var locked: bool = false
	var far: bool = false           # V64 : révélée mais sans route (vue de loin)
	var siege: int = 0
	var siege_max: int = 4
	var level: int = 1
	var animate: bool = true
	var _t: float = 0.0

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		_t = float(absi(hash(name)) % 1000) * 0.01

	func _process(d: float) -> void:
		if not is_visible_in_tree():
			return
		_t += d
		if animate or selected:
			queue_redraw()

	func _fill() -> Color:
		match state:
			"capital": return Color(0.86, 0.66, 0.20)
			"owned": return Color(0.17, 0.48, 0.27)
			"attackable": return Color(0.42, 0.40, 0.36) if not _is_enemy() else Color(0.62, 0.16, 0.14)
			"enemy": return Color(0.50, 0.12, 0.11)
			"lost": return Color(0.30, 0.10, 0.10)
			"unknown": return Color(0.22, 0.24, 0.27)
		return Color(0.40, 0.40, 0.38)

	var enemy_kind: bool = false
	func _is_enemy() -> bool:
		return enemy_kind

	func _glyph() -> String:
		match state:
			"capital": return "★"
			"owned": return "⚑"
			"unknown": return "?"
			"lost": return "✖"
		if general:
			return "☠"
		return "⚔" if enemy_kind else "⌂"

	func _draw() -> void:
		var s: float = 1.3 if state == "capital" else 1.0
		var g := Vector2(size.x * 0.5, size.y * 0.66)      # point au sol = emplacement de la ville
		var r: float = 15.0 * s
		var c: Vector2 = g + Vector2(0, -r - 11.0 * s)       # centre du médaillon
		var pulse: float = 0.5 + 0.5 * sin(_t * 3.0)
		# ombre au sol
		draw_set_transform(g, 0.0, Vector2(1.0, 0.38))
		draw_circle(Vector2.ZERO, 13.0 * s, Color(0, 0, 0, 0.40))
		if state == "attackable":
			draw_arc(Vector2.ZERO, 20.0 * s + pulse * 6.0, 0.0, TAU, 40, Color(1.0, 0.84, 0.36, 0.85 - 0.5 * pulse), 3.0, true)
		if threatened:
			draw_arc(Vector2.ZERO, 22.0 * s + pulse * 8.0, 0.0, TAU, 40, Color(1.0, 0.22, 0.16, 0.95 - 0.6 * pulse), 4.0, true)
		if selected:
			for k: int in range(8):
				var a0: float = _t * 1.4 + float(k) * TAU / 8.0
				draw_arc(Vector2.ZERO, 26.0 * s, a0, a0 + 0.45, 6, Color(1.0, 0.88, 0.42, 0.95), 3.5, true)
		if far:
			# anneau pointillé : repère « vue de loin », pas encore à portée
			for k: int in range(14):
				var a1: float = float(k) * TAU / 14.0
				draw_arc(Vector2.ZERO, 20.0 * s, a1, a1 + 0.2, 4, Color(0.86, 0.90, 0.95, 0.75), 2.5, true)
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
		# halo de la capitale
		if state == "capital":
			for i: int in range(4):
				draw_circle(c, r * (2.1 - 0.25 * float(i)), Color(1.0, 0.85, 0.35, 0.05 + 0.03 * pulse))
		# tige du repère
		draw_line(c + Vector2(0, r * 0.7), g, Color(0.12, 0.08, 0.05, 0.9), 3.0 * s, true)
		# drapeau qui flotte (villes de l'empire)
		if state == "owned" or state == "capital":
			var base: Vector2 = c + Vector2(r * 0.55, -r * 0.55)
			var top: Vector2 = base + Vector2(0, -22.0 * s)
			draw_line(base, top, Color(0.25, 0.17, 0.08), 2.0 * s, true)
			var pts := PackedVector2Array()
			var fw: float = 18.0 * s
			var fh: float = 11.0 * s
			for i: int in range(7):
				var x: float = float(i) / 6.0
				pts.append(top + Vector2(x * fw, sin(_t * 5.0 - x * 4.0) * 2.2 * x * s))
			for i: int in range(6, -1, -1):
				var x2: float = float(i) / 6.0
				pts.append(top + Vector2(x2 * fw, fh + sin(_t * 5.0 - x2 * 4.0) * 2.2 * x2 * s))
			var flag_col: Color = Color(0.95, 0.78, 0.25) if state == "capital" else Color(0.20, 0.62, 0.34)
			draw_colored_polygon(pts, flag_col)
			draw_polyline(pts.slice(0, 7), Color(1.0, 0.92, 0.6, 0.9), 1.4, true)
		# médaillon
		var fill: Color = _fill()
		if locked:
			fill = fill.darkened(0.35)
		if far:
			fill = fill.darkened(0.2)
		draw_circle(c + Vector2(0, 2), r + 3.0, Color(0, 0, 0, 0.45))
		draw_circle(c, r + 3.0 * s, accent if state != "unknown" else Color(0.45, 0.47, 0.50))
		draw_circle(c, r, fill)
		draw_arc(c, r - 2.0, PI * 1.1, PI * 1.9, 12, Color(1, 1, 1, 0.28), 2.0, true)
		if state == "capital" or state == "owned":
			draw_arc(c, r + 3.0 * s, 0.0, TAU, 32, Color(1.0, 0.90, 0.55), 1.6, true)
		var font: Font = get_theme_default_font()
		var fs: int = int(17.0 * s)
		var glyph: String = _glyph()
		var gw: float = font.get_string_size(glyph, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
		draw_string_outline(font, c + Vector2(-gw * 0.5, fs * 0.36), glyph, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, 3, Color(0, 0, 0, 0.6))
		draw_string(font, c + Vector2(-gw * 0.5, fs * 0.36), glyph, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color(1.0, 0.97, 0.88))
		# niveau de la ville (petites tours dorées)
		if state == "owned" or state == "capital":
			for i: int in range(level):
				var p := c + Vector2((float(i) - float(level - 1) * 0.5) * 8.0 * s, r + 6.0 * s)
				draw_rect(Rect2(p - Vector2(2.5, 3.0), Vector2(5, 6)), Color(1.0, 0.86, 0.40))
				draw_rect(Rect2(p - Vector2(2.5, 3.0), Vector2(5, 6)), Color(0.25, 0.15, 0.05), false, 1.0)
		if locked:
			# cadenas : le Donjon n'ouvre qu'une fois tout Zimut conquis
			var lk: Vector2 = c + Vector2(r * 0.85, -r * 0.75)
			draw_arc(lk + Vector2(0, -3), 4.0, PI, TAU, 10, Color(0.85, 0.85, 0.88), 2.0, true)
			draw_rect(Rect2(lk + Vector2(-6, -3), Vector2(12, 9)), Color(0.95, 0.78, 0.30))
			draw_rect(Rect2(lk + Vector2(-6, -3), Vector2(12, 9)), Color(0.25, 0.15, 0.05), false, 1.2)
		# pions de siège
		if siege > 0:
			for i: int in range(siege_max):
				var pp := c + Vector2((float(i) - float(siege_max - 1) * 0.5) * 9.0, -r - 8.0)
				draw_circle(pp, 3.6, Color(0, 0, 0, 0.6))
				draw_circle(pp, 2.8, Color(1.0, 0.30, 0.22) if i < siege else Color(0.55, 0.55, 0.55))
		# crâne du général (forteresse ennemie)
		if general and state != "owned":
			var sk: Vector2 = c + Vector2(r * 0.95, -r * 0.95 + sin(_t * 2.0) * 2.0)
			draw_circle(sk, 8.0, Color(0.85, 0.15, 0.12, 0.35 + 0.25 * pulse))
			draw_circle(sk, 6.5, Color(0.10, 0.06, 0.08))
			draw_string(font, sk + Vector2(-5, 4), "☠", HORIZONTAL_ALIGNMENT_LEFT, -1, 11, Color(1.0, 0.9, 0.85))
		# fumée : ville pillée, ruinée ou perdue
		if smoke:
			for k: int in range(5):
				var ph: float = fposmod(_t * 0.40 + float(k) * 0.2, 1.0)
				var sp: Vector2 = c + Vector2(-r * 0.3 + sin(ph * 5.0 + float(k)) * 5.0 + ph * 14.0, -r * 0.6 - ph * 42.0)
				draw_circle(sp, 5.0 + ph * 10.0, Color(0.16, 0.15, 0.15, 0.70 * (1.0 - ph)))
				draw_circle(sp + Vector2(-1.5, -1.5), 3.0 + ph * 7.0, Color(0.45, 0.43, 0.42, 0.45 * (1.0 - ph)))
			# braises
			draw_circle(c + Vector2(-r * 0.2, -r * 0.4), 2.0 + sin(_t * 7.0), Color(1.0, 0.5, 0.15, 0.8))


## Vie ambiante : navires sur la mer, oiseaux et nuages.
class Ambient:
	extends Control
	var _t: float = 0.0
	var clouds: bool = true
	var active: bool = true            # faux : image fixe (rendu économique)
	var _cloud_tex: Texture2D = null
	# navires : centre, rayons (normalisés), vitesse
	const SHIPS := [
		[Vector2(0.93, 0.66), Vector2(0.030, 0.055), 0.05],
		[Vector2(0.36, 0.965), Vector2(0.090, 0.012), -0.035],
		[Vector2(0.95, 0.08), Vector2(0.025, 0.030), 0.06],
		[Vector2(0.03, 0.36), Vector2(0.012, 0.050), -0.05],
	]

	func _ready() -> void:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		var g := Gradient.new()
		g.colors = PackedColorArray([Color(1, 1, 1, 0.9), Color(1, 1, 1, 0.0)])
		var gt := GradientTexture2D.new()
		gt.gradient = g
		gt.fill = GradientTexture2D.FILL_RADIAL
		gt.fill_from = Vector2(0.5, 0.5)
		gt.fill_to = Vector2(1.0, 0.5)
		gt.width = 64
		gt.height = 64
		_cloud_tex = gt

	func _process(d: float) -> void:
		if not active or not is_visible_in_tree():
			return
		_t += d
		queue_redraw()

	func _draw() -> void:
		for sh: Array in SHIPS:
			var ctr: Vector2 = sh[0]
			var rad: Vector2 = sh[1]
			var a: float = _t * float(sh[2]) * TAU
			var p: Vector2 = (ctr + Vector2(cos(a) * rad.x, sin(a) * rad.y)) * size
			var v: Vector2 = Vector2(-sin(a) * rad.x, cos(a) * rad.y) * signf(float(sh[2]))
			var right: bool = v.x >= 0.0
			_ship(p, right)
		# oiseaux : petits V qui traversent lentement
		for k: int in range(5):
			var ph: float = fposmod(_t * 0.018 + float(k) * 0.21, 1.0)
			var bp := Vector2(ph * (size.x + 200.0) - 100.0, size.y * (0.22 + 0.13 * float(k % 3)) + sin(_t * 0.7 + float(k)) * 18.0)
			var flap: float = sin(_t * 9.0 + float(k) * 1.7) * 3.0
			draw_polyline(PackedVector2Array([bp + Vector2(-6, -flap), bp, bp + Vector2(6, -flap)]), Color(0.12, 0.10, 0.10, 0.75), 1.6, true)
		if clouds and _cloud_tex != null:
			for k2: int in range(6):
				var ph2: float = fposmod(_t * 0.006 + float(k2) * 0.17, 1.0)
				var w: float = 260.0 + 90.0 * float(k2 % 3)
				var cp := Vector2(ph2 * (size.x + w * 2.0) - w, size.y * (0.10 + 0.16 * float(k2)))
				for j: int in range(3):
					var o := Vector2(float(j - 1) * w * 0.33, sin(float(j + k2)) * 18.0)
					draw_texture_rect(_cloud_tex, Rect2(cp + o - Vector2(w, w * 0.45) * 0.5, Vector2(w, w * 0.45)), false, Color(1, 1, 1, 0.13))

	func _ship(p: Vector2, right: bool) -> void:
		draw_set_transform(p, 0.0, Vector2(1.5, 1.5))
		p = Vector2.ZERO
		var dx: float = 1.0 if right else -1.0
		var bob: float = sin(_t * 2.2 + p.x) * 1.2
		p.y += bob
		# sillage
		for i: int in range(3):
			draw_line(p + Vector2(-dx * (10.0 + 6.0 * float(i)), 4.0 + float(i)), p + Vector2(-dx * (16.0 + 7.0 * float(i)), 2.0 + float(i) * 2.0),
				Color(1, 1, 1, 0.45 - 0.12 * float(i)), 1.4, true)
		draw_colored_polygon(PackedVector2Array([p + Vector2(-11 * dx, 0), p + Vector2(12 * dx, 0), p + Vector2(8 * dx, 6), p + Vector2(-8 * dx, 6)]),
			Color(0.36, 0.22, 0.12))
		draw_line(p + Vector2(0, 0), p + Vector2(0, -20), Color(0.25, 0.16, 0.08), 1.6, true)
		draw_colored_polygon(PackedVector2Array([p + Vector2(0, -19), p + Vector2(10 * dx, -4), p + Vector2(0, -3)]), Color(0.96, 0.93, 0.84))
		draw_colored_polygon(PackedVector2Array([p + Vector2(0, -17), p + Vector2(-7 * dx, -5), p + Vector2(0, -5)]), Color(0.88, 0.85, 0.76))
		draw_set_transform(Vector2.ZERO, 0.0, Vector2.ONE)
