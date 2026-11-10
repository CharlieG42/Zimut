class_name Adv3DMeshes
extends RefCounted
## Adv3DMeshes.gd — Bibliothèque de meshes low-poly du monde 3D (V61).
##
## Tout est construit en code (pas d'asset) : facettes plates (une normale par triangle),
## couleurs de sommets dégradées (ombre propre en bas, lumière en haut) qui donnent du volume
## sans coûter de lumières ni de textures. Chaque mesh est mis en cache : un MultiMesh par type
## de décor, donc un seul appel de rendu pour des dizaines d'arbres.
##
## Les couleurs sont données en sRGB (ce que l'on voit) ; les matériaux les convertissent.

static var _cache: Dictionary = {}
## V85 : ombres temps réel du soleil actives (qualité Haute) — les ombres rondes au sol s'allègent alors.
static var real_shadows: bool = false


## Règle le soleil et l'environnement (ombres portées, éclat, lueur du soleil dans la brume).
static func setup_sun(sun: DirectionalLight3D, env: Environment) -> void:
	real_shadows = not GfxQuality.low()
	sun.shadow_enabled = real_shadows
	if real_shadows:
		sun.directional_shadow_mode = DirectionalLight3D.SHADOW_PARALLEL_2_SPLITS
		sun.directional_shadow_max_distance = 70.0
		sun.directional_shadow_split_1 = 0.28
		sun.shadow_bias = 0.06
		sun.shadow_normal_bias = 1.4
		sun.shadow_blur = 1.6
	env.fog_sun_scatter = 0.22
	env.glow_hdr_threshold = 0.95



# ══════════════════════════════════════════════════════════════════════
#  Matériaux
# ══════════════════════════════════════════════════════════════════════

## V85 : éclairage « cartoon » façon Zelda / Genshin — dégradé en paliers adoucis (lumière chaude,
## ombres teintées), liseré lumineux (rim) côté soleil, ombres portées du soleil quand elles sont actives.
const TOON_LIGHT := """
uniform vec3 rim_color : source_color = vec3(1.0, 0.93, 0.78);
uniform float rim = 0.45;
uniform float toon = 0.7;
uniform vec3 shade_tint : source_color = vec3(0.62, 0.66, 0.95);
void light() {
	float ndl = dot(NORMAL, LIGHT);
	float h = ndl * 0.5 + 0.5;
	float soft = h * h * (3.0 - 2.0 * h);
	float band = smoothstep(0.40, 0.55, h) * 0.55 + smoothstep(0.68, 0.82, h) * 0.45;
	float lit = mix(soft, band, toon);
	float sh = ATTENUATION;
	vec3 shade = mix(shade_tint, vec3(1.0), sh);
	// V138 : la teinte d'ombre ne s'applique qu'à la contribution du SOLEIL. Avant, elle multipliait toute la
	// lumière déjà accumulée à chaque lumière : près d'un feu de camp ou d'une lanterne (lumière ponctuelle en
	// bord de portée), le sol entier virait au bleu-violet sombre.
	if (LIGHT_IS_DIRECTIONAL) {
		DIFFUSE_LIGHT += LIGHT_COLOR * lit * sh / PI * shade;
		float fres = pow(1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0), 3.0);
		DIFFUSE_LIGHT += rim_color * fres * rim * clamp(ndl + 0.6, 0.0, 1.0) * sh * 0.5;
	} else {
		DIFFUSE_LIGHT += LIGHT_COLOR * lit * sh / PI;
	}
}
"""

## Feuillage et décor : couleurs de sommets (sRGB), balancement au vent croissant avec la hauteur
## (sway = 0 pour les objets rigides) et éclairage cartoon (TOON_LIGHT).
const FOLIAGE_SHADER := """
shader_type spatial;
render_mode @CULL@ specular_disabled;
uniform float sway = 0.16;
uniform float speed = 1.5;
// Normales tirées vers le haut : l'herbe et les feuillages restent éclairés des deux côtés
// (sinon le revers des brins, tourné à l'opposé du soleil, paraît presque noir).
uniform float normal_up = 0.35;
uniform float flip_back = 0.0;
// Fondu « tramé » près de la caméra : un buisson qui passe devant l'objectif devient transparent.
uniform float fade_near = 1.0;
uniform float fade_far = 2.6;
uniform float emit = 0.12;
// V89 : sommet d'alpha 0 = lumineux (cristaux, lave, runes des décors de Nation).
uniform float glow = 0.0;
// V86 : peinture triplanaire (aplats + coups de pinceau) et cartes de feuilles (UV non nul = carte).
uniform sampler2D paint : filter_linear_mipmap, repeat_enable, hint_default_white;
uniform sampler2D leaf_tex : filter_linear_mipmap, repeat_disable, hint_default_white;
uniform float paint_amt = 0.5;
uniform float paint_scale = 0.11;
// V128 : grandes plaques de teinte (sol) — couleur multipliée là où la peinture basse fréquence est forte.
uniform vec3 macro_col = vec3(1.0);
uniform float macro_amt = 0.0;
// V142 : neige posée sur les faces tournées vers le ciel (Nations enneigées). `zimut_snow` est réglé une
// fois par zone (Adv3DWorld.build) ; `snow_k` = 1 sur les décors qui en reçoivent (jamais le sol ni l'herbe).
global uniform float zimut_snow;
uniform float snow_k = 0.0;
varying vec3 wpos;
varying vec3 wnorm;
float bayer4(vec2 p) {
	ivec2 q = ivec2(mod(p, 4.0));
	int i = q.x + q.y * 4;
	int m[16] = int[16](0, 8, 2, 10, 12, 4, 14, 6, 3, 11, 1, 9, 15, 7, 13, 5);
	return (float(m[i]) + 0.5) / 16.0;
}
void vertex() {
	float h = max(VERTEX.y, 0.0);
	vec3 wp = MODEL_MATRIX[3].xyz;
	float ph = wp.x * 0.42 + wp.z * 0.31;
	float w = sin(TIME * speed + ph) * 0.6 + sin(TIME * speed * 1.7 + ph * 1.3) * 0.25;
	VERTEX.x += w * sway * h * h * 0.18;
	VERTEX.z += cos(TIME * speed * 0.8 + ph) * sway * h * h * 0.10;
	wpos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	wnorm = normalize((MODEL_MATRIX * vec4(NORMAL, 0.0)).xyz);
}
void fragment() {
	float dist = length(VERTEX);
	if (dist < fade_far) {
		float a = clamp((dist - fade_near) / (fade_far - fade_near), 0.0, 1.0);
		if (a < bayer4(FRAGCOORD.xy)) {
			discard;
		}
	}
	float leaf_k = 1.0;
	if (UV.x + UV.y > 0.001) {
		vec4 lt = texture(leaf_tex, UV);
		if (lt.a < 0.5) {
			discard;
		}
		leaf_k = 0.72 + lt.r * 0.5;
	}
	if (flip_back > 0.5 && !FRONT_FACING) {
		NORMAL = -NORMAL;
	}
	vec3 up_v = normalize((VIEW_MATRIX * vec4(0.0, 1.0, 0.0, 0.0)).xyz);
	NORMAL = normalize(mix(NORMAL, up_v, normal_up));
	// Variation douce de teinte à grande échelle (aplats peints) : évite les surfaces uniformes.
	float v = sin(wpos.x * 0.35 + sin(wpos.z * 0.23) * 2.0) * sin(wpos.z * 0.31 + sin(wpos.x * 0.19) * 2.0);
	vec3 bw = pow(abs(wnorm), vec3(4.0));
	bw /= (bw.x + bw.y + bw.z + 0.0001);
	vec2 px = wpos.zy * paint_scale;
	vec2 py = wpos.xz * paint_scale;
	vec2 pz = wpos.xy * paint_scale;
	float pa = texture(paint, px).r * bw.x + texture(paint, py).r * bw.y + texture(paint, pz).r * bw.z;
	float pb = texture(paint, px * 0.23 + 0.31).r * bw.x + texture(paint, py * 0.23 + 0.31).r * bw.y + texture(paint, pz * 0.23 + 0.31).r * bw.z;
	float pv = mix(pa, pb, 0.5);
	vec3 col = COLOR.rgb * (1.0 + v * 0.06) * (1.0 + (pv - 0.5) * paint_amt * 2.0) * leaf_k;
	col = mix(col, col * macro_col, macro_amt * smoothstep(0.40, 0.62, pb));
	float sn = zimut_snow * snow_k;
	if (sn > 0.001) {
		float cap = smoothstep(0.28, 0.70, wnorm.y + (pa - 0.5) * 0.45);
		col = mix(col, vec3(0.93, 0.96, 1.0) * (0.95 + pa * 0.07), cap * sn);
	}
	ALBEDO = pow(max(col, vec3(0.0)), vec3(2.2));
	EMISSION = ALBEDO * emit + ALBEDO * (1.0 - clamp(COLOR.a, 0.0, 1.0)) * glow;
	ROUGHNESS = 0.92;
}
""" + TOON_LIGHT


static func _shader_for(double_sided: bool) -> Shader:
	var key: String = "toon_ds" if double_sided else "toon_cb"
	if not _cache.has(key):
		var sh := Shader.new()
		sh.code = FOLIAGE_SHADER.replace("@CULL@", "cull_disabled," if double_sided else "cull_back,")
		_cache[key] = sh
	return _cache[key]


## Matériau opaque à couleurs de sommets sRGB (sol, rochers, falaises), éclairage cartoon.
static func tex(name: String) -> Texture2D:
	var key: String = "tex_" + name
	if not _cache.has(key):
		_cache[key] = load("res://assets/textures3d/%s.png" % name)
	return _cache[key]


static func _set_textures(m: ShaderMaterial, amt: float) -> void:
	m.set_shader_parameter("paint", tex("paint"))
	m.set_shader_parameter("leaf_tex", tex("leaf"))
	m.set_shader_parameter("paint_amt", amt)


static func solid_material(double_sided: bool = false, near_fade: bool = false) -> ShaderMaterial:
	var m := ShaderMaterial.new()
	m.shader = _shader_for(double_sided)
	m.set_shader_parameter("sway", 0.0)
	m.set_shader_parameter("normal_up", 0.0)
	m.set_shader_parameter("flip_back", 1.0 if double_sided else 0.0)
	m.set_shader_parameter("emit", 0.05)
	_set_textures(m, 0.4)
	if near_fade:
		# un rocher / une souche qui passe devant la caméra s'efface (tramage, sans tri de transparence)
		m.set_shader_parameter("fade_near", 1.0)
		m.set_shader_parameter("fade_far", 2.6)
	else:
		m.set_shader_parameter("fade_near", 0.0)
		m.set_shader_parameter("fade_far", 0.0)
	return m


## V142 : ce matériau reçoit la neige des Nations enneigées (voir `zimut_snow` dans le shader).
static func snowy(m: ShaderMaterial, amount: float = 1.0) -> ShaderMaterial:
	m.set_shader_parameter("snow_k", amount)
	return m


## Nation enneigée ? (neige sur les décors, herbe givrée, terre au pied des arbres)
static func is_snow_biome(biome: String) -> bool:
	return biome == "Montagne"


## Matériau de feuillage qui ondule au vent.
static func foliage_material(sway: float = 0.16, up: float = 0.35) -> ShaderMaterial:
	var m := ShaderMaterial.new()
	m.shader = _shader_for(true)
	m.set_shader_parameter("sway", sway)
	m.set_shader_parameter("normal_up", up)
	_set_textures(m, 0.18)
	return m


## Ombre douce posée au sol : disque sombre translucide.
static func shadow_material() -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.specular_mode = BaseMaterial3D.SPECULAR_DISABLED   # évite les taches noires (NaN) sur GPU mobiles
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	m.albedo_color = Color(0.04, 0.07, 0.03, 0.16 if real_shadows else 0.34)
	m.cull_mode = BaseMaterial3D.CULL_DISABLED
	m.no_depth_test = false
	return m


## V142 : rond de terre dégagée au pied des arbres, dans la neige.
static func dirt_ring_material(col: Color = Color(0.50, 0.40, 0.31, 0.62)) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.specular_mode = BaseMaterial3D.SPECULAR_DISABLED
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	m.albedo_color = col
	m.cull_mode = BaseMaterial3D.CULL_DISABLED
	return m


static func shadow_mesh() -> Mesh:
	if _cache.has("shadow"):
		return _cache["shadow"]
	var c := CylinderMesh.new()
	c.top_radius = 1.0
	c.bottom_radius = 1.0
	c.height = 0.01
	c.radial_segments = 12
	c.rings = 1
	c.cap_bottom = false
	_cache["shadow"] = c
	return c


# ══════════════════════════════════════════════════════════════════════
#  Outils de construction (facettes plates)
# ══════════════════════════════════════════════════════════════════════

## Triangle à normale plate orientée « vers l'extérieur » du volume centré en `center`.
## Ombrage doux (organique) ou facettes plates (minéral) : réglé par chaque constructeur de mesh.
static var smooth_mode: bool = true


## Triangle avec une normale par sommet (ombrage lissé).
static func _tri_n(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3, ca: Color, cb: Color, cc: Color,
		na: Vector3, nb: Vector3, nc: Vector3, center: Vector3) -> void:
	var fn: Vector3 = (c - a).cross(b - a)
	if fn.length_squared() < 0.0000001:
		return
	var vs: Array = [a, b, c]
	var cs: Array = [ca, cb, cc]
	var ns: Array = [na, nb, nc]
	for i: int in range(3):
		st.set_color(cs[i])
		st.set_normal(ns[i])
		st.add_vertex(vs[i])


static func _tri(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3, ca: Color, cb: Color, cc: Color, center: Vector3) -> void:
	var n: Vector3 = (c - a).cross(b - a)
	if n.length_squared() < 0.0000001:
		return
	n = n.normalized()
	var mid: Vector3 = (a + b + c) / 3.0
	if n.dot(mid - center) < 0.0:
		n = -n
	st.set_color(ca)
	st.set_normal(n)
	st.add_vertex(a)
	st.set_color(cb)
	st.set_normal(n)
	st.add_vertex(b)
	st.set_color(cc)
	st.set_normal(n)
	st.add_vertex(c)


static func _jit(rng: RandomNumberGenerator, amount: float) -> Vector3:
	return Vector3(rng.randf_range(-amount, amount), rng.randf_range(-amount, amount), rng.randf_range(-amount, amount))


## Cône (ou tronc de cône) à `segs` côtés, de `base` (cercle bas) vers le haut.
static func add_cone(st: SurfaceTool, base: Vector3, r_bot: float, r_top: float, height: float, segs: int,
		col_bot: Color, col_top: Color, rng: RandomNumberGenerator, jitter: float = 0.0, cap_bottom: bool = true) -> void:
	var center: Vector3 = base + Vector3(0, height * 0.5, 0)
	var ring_b: Array[Vector3] = []
	var ring_t: Array[Vector3] = []
	var rot0: float = rng.randf() * TAU
	for i: int in range(segs):
		var a: float = rot0 + float(i) / float(segs) * TAU
		ring_b.append(base + Vector3(cos(a) * r_bot, 0.0, sin(a) * r_bot) + _jit(rng, jitter) * Vector3(1, 0.2, 1))
		ring_t.append(base + Vector3(cos(a) * r_top, height, sin(a) * r_top) + _jit(rng, jitter * 0.5) * Vector3(1, 0.2, 1))
	var top_c: Vector3 = base + Vector3(0, height, 0)
	var bot_c: Vector3 = base
	var slope: float = (r_bot - r_top) / maxf(height, 0.001)
	for i: int in range(segs):
		var j: int = (i + 1) % segs
		var ni: Vector3 = (Vector3(ring_b[i].x - base.x, 0.0, ring_b[i].z - base.z).normalized() + Vector3(0, slope, 0)).normalized()
		var nj: Vector3 = (Vector3(ring_b[j].x - base.x, 0.0, ring_b[j].z - base.z).normalized() + Vector3(0, slope, 0)).normalized()
		if r_top <= 0.001:
			if smooth_mode:
				var nt: Vector3 = (ni + nj).normalized()
				_tri_n(st, ring_b[i], ring_b[j], top_c, col_bot, col_bot, col_top, ni, nj, nt, center)
			else:
				_tri(st, ring_b[i], ring_b[j], top_c, col_bot, col_bot, col_top, center)
		else:
			if smooth_mode:
				_tri_n(st, ring_b[i], ring_b[j], ring_t[j], col_bot, col_bot, col_top, ni, nj, nj, center)
				_tri_n(st, ring_b[i], ring_t[j], ring_t[i], col_bot, col_top, col_top, ni, nj, ni, center)
			else:
				_tri(st, ring_b[i], ring_b[j], ring_t[j], col_bot, col_bot, col_top, center)
				_tri(st, ring_b[i], ring_t[j], ring_t[i], col_bot, col_top, col_top, center)
			_tri(st, ring_t[i], ring_t[j], top_c, col_top, col_top, col_top, center)
		if cap_bottom:
			_tri(st, ring_b[i], ring_b[j], bot_c, col_bot, col_bot, col_bot, center)


## Bloc arrondi (sphère basse définition, aplatie / étirée par `radii`), couleur du bas vers le haut.
static func add_blob(st: SurfaceTool, center: Vector3, radii: Vector3, segs: int, rings: int,
		col_bot: Color, col_top: Color, rng: RandomNumberGenerator, jitter: float = 0.0) -> void:
	var pts: Array = []        # [ring][seg] -> Vector3
	var cols: Array = []
	for r: int in range(rings + 1):
		var v: float = float(r) / float(rings)
		var phi: float = v * PI                  # 0 = pôle haut, PI = pôle bas
		var row_p: Array[Vector3] = []
		var row_c: Array[Color] = []
		var cc: Color = col_top.lerp(col_bot, v)
		for s: int in range(segs):
			var th: float = float(s) / float(segs) * TAU
			var p := Vector3(sin(phi) * cos(th) * radii.x, cos(phi) * radii.y, sin(phi) * sin(th) * radii.z)
			if r != 0 and r != rings:
				p += _jit(rng, jitter) * Vector3(radii.x, radii.y, radii.z)
			row_p.append(center + p)
			row_c.append(cc)
		pts.append(row_p)
		cols.append(row_c)
	for r: int in range(rings):
		for s: int in range(segs):
			var s2: int = (s + 1) % segs
			var a: Vector3 = pts[r][s]
			var b: Vector3 = pts[r][s2]
			var c: Vector3 = pts[r + 1][s2]
			var d: Vector3 = pts[r + 1][s]
			var ca: Color = cols[r][s]
			var cb: Color = cols[r][s2]
			var cc2: Color = cols[r + 1][s2]
			var cd: Color = cols[r + 1][s]
			if smooth_mode:
				var na: Vector3 = ((a - center) / radii).normalized()
				var nb: Vector3 = ((b - center) / radii).normalized()
				var nc: Vector3 = ((c - center) / radii).normalized()
				var nd: Vector3 = ((d - center) / radii).normalized()
				if r == 0:
					_tri_n(st, a, c, d, ca, cc2, cd, na, nc, nd, center)
				elif r == rings - 1:
					_tri_n(st, a, b, d, ca, cb, cd, na, nb, nd, center)
				else:
					_tri_n(st, a, b, c, ca, cb, cc2, na, nb, nc, center)
					_tri_n(st, a, c, d, ca, cc2, cd, na, nc, nd, center)
			elif r == 0:
				_tri(st, a, c, d, ca, cc2, cd, center)
			elif r == rings - 1:
				_tri(st, a, b, d, ca, cb, cd, center)
			else:
				_tri(st, a, b, c, ca, cb, cc2, center)
				_tri(st, a, c, d, ca, cc2, cd, center)


## Boîte (pour planches, cabanes, panneaux), couleur unie ou dégradée vertical.
static func add_box(st: SurfaceTool, center: Vector3, size: Vector3, col_bot: Color, col_top: Color) -> void:
	var h: Vector3 = size * 0.5
	var v: Array[Vector3] = []
	for sx: float in [-1.0, 1.0]:
		for sy: float in [-1.0, 1.0]:
			for sz: float in [-1.0, 1.0]:
				v.append(center + Vector3(h.x * sx, h.y * sy, h.z * sz))
	# indices : x*4 + y*2 + z (0/1)
	var faces: Array = [[0, 1, 3, 2], [4, 6, 7, 5], [0, 4, 5, 1], [2, 3, 7, 6], [0, 2, 6, 4], [1, 5, 7, 3]]
	for f: Array in faces:
		var c0: Color = col_bot if v[f[0]].y < center.y else col_top
		var c1: Color = col_bot if v[f[1]].y < center.y else col_top
		var c2: Color = col_bot if v[f[2]].y < center.y else col_top
		var c3: Color = col_bot if v[f[3]].y < center.y else col_top
		_tri(st, v[f[0]], v[f[1]], v[f[2]], c0, c1, c2, center)
		_tri(st, v[f[0]], v[f[2]], v[f[3]], c0, c2, c3, center)


## Lame d'herbe / palme : triangle fin et incliné.
static func add_blade(st: SurfaceTool, base: Vector3, tip: Vector3, width: float, col_bot: Color, col_top: Color) -> void:
	var dir: Vector3 = (tip - base)
	var side: Vector3 = dir.cross(Vector3.UP)
	if side.length() < 0.001:
		side = Vector3.RIGHT
	side = side.normalized() * width * 0.5
	var a: Vector3 = base - side
	var b: Vector3 = base + side
	var n: Vector3 = (b - a).cross(tip - a).normalized()
	for e: Array in [[a, col_bot], [b, col_bot], [tip, col_top]]:
		st.set_color(e[1])
		st.set_normal(n)
		st.add_vertex(e[0])


static func _commit(st: SurfaceTool) -> ArrayMesh:
	return st.commit()


# ══════════════════════════════════════════════════════════════════════
#  Décors (un mesh par catégorie, mis en cache)
# ══════════════════════════════════════════════════════════════════════

static func _rng(seed_v: int) -> RandomNumberGenerator:
	var r := RandomNumberGenerator.new()
	r.seed = seed_v
	return r


static func _begin() -> SurfaceTool:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	st.set_uv(Vector2.ZERO)     # tous les sommets portent un UV (0,0 = pas une carte de feuilles)
	return st


## V86 : couronne de feuillage en cartes (quads texturés, normales dirigées vers l'extérieur du volume
## → ombrage doux et rond comme un feuillage peint). UV non nul : le shader y applique `leaf_tex`.
static func add_cards(st: SurfaceTool, center: Vector3, radii: Vector3, count: int, card: float,
		col_bot: Color, col_top: Color, rng: RandomNumberGenerator) -> void:
	for i: int in range(count):
		# répartition en spirale dorée sur la demi-sphère haute + un peu sur les flancs
		var u: float = (float(i) + 0.5) / float(count)
		var y: float = lerpf(-0.35, 1.0, u)
		var rr: float = sqrt(maxf(0.0, 1.0 - y * y))
		var th: float = float(i) * 2.399963 + rng.randf() * 0.3
		var dir := Vector3(cos(th) * rr, y, sin(th) * rr)
		var depth: float = rng.randf_range(0.62, 1.0)
		var p: Vector3 = center + dir * radii * depth
		var right: Vector3 = dir.cross(Vector3.UP)
		if right.length_squared() < 0.01:
			right = Vector3.RIGHT
		right = right.normalized().rotated(dir, rng.randf() * TAU)
		var upv: Vector3 = right.cross(dir).normalized()
		var h: float = card * 1.3 * rng.randf_range(0.8, 1.2)
		var k: float = clampf((p.y - (center.y - radii.y)) / maxf(radii.y * 2.0, 0.001), 0.0, 1.0)
		var base_c: Color = col_bot.lerp(col_top, k)
		var vv: float = rng.randf_range(0.92, 1.08)
		base_c = Color(base_c.r * vv, base_c.g * vv, base_c.b * vv)
		var corners: Array = [p - right * h + upv * h * 0.2, p + right * h + upv * h * 0.2, p + right * h + upv * h * 1.8, p - right * h + upv * h * 1.8]
		var uvs: Array = [Vector2(0.02, 0.98), Vector2(0.98, 0.98), Vector2(0.98, 0.02), Vector2(0.02, 0.02)]
		for idx: Array in [[0, 1, 2], [0, 2, 3]]:
			for j: int in idx:
				var cp: Vector3 = corners[j]
				var nrm: Vector3 = ((cp - center) / radii).normalized()
				st.set_uv(uvs[j])
				st.set_color(base_c)
				st.set_normal(nrm)
				st.add_vertex(cp)
	st.set_uv(Vector2.ZERO)


static func _cached(key: String, builder: Callable) -> Mesh:
	if not _cache.has(key):
		smooth_mode = true
		_cache[key] = builder.call()
		smooth_mode = true
	return _cache[key]


## Sapin à trois étages (version enneigée pour la montagne).
static func pine(snow: bool = false) -> Mesh:
	return _cached("pine_%s" % snow, func() -> Mesh:
		var st: SurfaceTool = _begin()
		var rng: RandomNumberGenerator = _rng(11)
		var bark_b := Color(0.30, 0.20, 0.13)
		var bark_t := Color(0.42, 0.29, 0.18)
		add_cone(st, Vector3.ZERO, 0.19, 0.12, 1.0, 8, bark_b, bark_t, rng, 0.01)
		var tiers: Array = [[0.55, 1.15, 1.35], [1.35, 0.88, 1.20], [2.05, 0.60, 1.10]]
		for i: int in range(tiers.size()):
			var t: Array = tiers[i]
			var dark := Color(0.08, 0.26, 0.17).lerp(Color(0.12, 0.31, 0.20), float(i) * 0.5)
			var light := Color(0.20, 0.47, 0.28).lerp(Color(0.30, 0.56, 0.32), float(i) * 0.5)
			if snow:
				light = Color(0.92, 0.96, 0.98)
				dark = Color(0.36, 0.56, 0.52)
			add_cone(st, Vector3(0, t[0], 0), t[1], 0.0, t[2], 12, dark, light, rng, 0.03, false)
			# V89 : touffes d'aiguilles (cartes) par-dessus chaque étage, branches plus fournies et organiques
			var ccol: Color = light if not snow else Color(0.96, 0.98, 1.0)
			add_cards(st, Vector3(0, float(t[0]) + float(t[2]) * 0.30, 0), Vector3(float(t[1]) * 0.92, float(t[2]) * 0.42, float(t[1]) * 0.92),
				24 - i * 4, 0.24 - float(i) * 0.03, dark.lightened(0.05), ccol, rng)
		return _commit(st))


## Arbre à feuillage : tronc légèrement conique + amas de boules de feuilles.
static func broadleaf() -> Mesh:
	return _cached("broadleaf", func() -> Mesh:
		var st: SurfaceTool = _begin()
		var rng: RandomNumberGenerator = _rng(23)
		add_cone(st, Vector3.ZERO, 0.22, 0.12, 1.5, 6, Color(0.28, 0.19, 0.12), Color(0.45, 0.31, 0.20), rng, 0.015)
		add_cone(st, Vector3(0, 1.0, 0), 0.10, 0.06, 0.7, 5, Color(0.40, 0.28, 0.18), Color(0.42, 0.30, 0.19), rng, 0.01)
		var dark := Color(0.18, 0.42, 0.19)
		var light := Color(0.52, 0.78, 0.30)
		# V86 : noyau sombre (évite les trous) + cartes de feuilles par amas
		add_blob(st, Vector3(0.0, 2.0, 0.0), Vector3(0.9, 0.75, 0.9), 8, 4, dark, dark.lerp(light, 0.3), rng, 0.03)
		add_cards(st, Vector3(0.0, 2.05, 0.0), Vector3(1.12, 0.92, 1.12), 34, 0.46, dark, light, rng)
		add_cards(st, Vector3(0.62, 1.72, 0.25), Vector3(0.78, 0.66, 0.78), 16, 0.38, dark, light.darkened(0.04), rng)
		add_cards(st, Vector3(-0.58, 1.78, -0.30), Vector3(0.76, 0.64, 0.76), 16, 0.38, dark, light.darkened(0.06), rng)
		add_cards(st, Vector3(0.05, 2.65, 0.05), Vector3(0.66, 0.54, 0.66), 14, 0.34, dark.lightened(0.05), light.lightened(0.05), rng)
		return _commit(st))


## Bouleau : fin tronc clair tacheté, feuillage léger jaune-vert.
static func birch() -> Mesh:
	return _cached("birch", func() -> Mesh:
		var st: SurfaceTool = _begin()
		var rng: RandomNumberGenerator = _rng(71)
		add_cone(st, Vector3.ZERO, 0.13, 0.08, 2.3, 7, Color(0.80, 0.78, 0.72), Color(0.95, 0.94, 0.90), rng, 0.01)
		for i: int in range(4):
			add_cone(st, Vector3(0, 0.35 + float(i) * 0.5, 0), 0.136 - float(i) * 0.012, 0.136 - float(i) * 0.012, 0.07, 7, Color(0.12, 0.11, 0.10), Color(0.16, 0.14, 0.13), rng, 0.0, false)
		var dark := Color(0.30, 0.52, 0.20)
		var light := Color(0.66, 0.82, 0.30)
		add_blob(st, Vector3(0, 2.45, 0), Vector3(0.6, 0.7, 0.6), 8, 4, dark, dark.lerp(light, 0.3), rng, 0.03)
		add_cards(st, Vector3(0, 2.55, 0), Vector3(0.84, 0.96, 0.84), 28, 0.40, dark, light, rng)
		add_cards(st, Vector3(0.38, 2.15, 0.2), Vector3(0.54, 0.56, 0.54), 12, 0.32, dark, light.lightened(0.05), rng)
		add_cards(st, Vector3(-0.36, 2.2, -0.2), Vector3(0.54, 0.54, 0.54), 12, 0.32, dark, light.lightened(0.05), rng)
		return _commit(st))


## Rocher + petits cailloux ; `warm` = grès du désert, sinon granit moussu.
static func rock(warm: bool = false) -> Mesh:
	return _cached("rock_%s" % warm, func() -> Mesh:
		smooth_mode = true   # V86 : rochers aux volumes arrondis, la peinture triplanaire fait la matière
		var st: SurfaceTool = _begin()
		var rng: RandomNumberGenerator = _rng(37)
		var bot: Color = Color(0.34, 0.26, 0.20) if warm else Color(0.34, 0.34, 0.36)
		var top: Color = Color(0.84, 0.66, 0.44) if warm else Color(0.66, 0.68, 0.62)
		add_blob(st, Vector3(0, 0.42, 0), Vector3(1.0, 0.72, 0.85), 9, 5, bot, top, rng, 0.12)
		add_blob(st, Vector3(0.95, 0.18, 0.4), Vector3(0.40, 0.28, 0.36), 7, 4, bot, top.darkened(0.06), rng, 0.1)
		add_blob(st, Vector3(-0.8, 0.14, -0.55), Vector3(0.30, 0.22, 0.28), 7, 4, bot, top.darkened(0.1), rng, 0.1)
		if not warm:
			# calotte de mousse sur le dessus
			add_blob(st, Vector3(0.05, 0.92, 0.0), Vector3(0.62, 0.20, 0.55), 6, 2, Color(0.22, 0.42, 0.20), Color(0.36, 0.60, 0.26), rng, 0.05)
		return _commit(st))


## Buisson : trois touffes.
static func bush() -> Mesh:
	return _cached("bush", func() -> Mesh:
		var st: SurfaceTool = _begin()
		var rng: RandomNumberGenerator = _rng(41)
		var dark := Color(0.12, 0.32, 0.14)
		var light := Color(0.36, 0.62, 0.24)
		add_blob(st, Vector3(0, 0.34, 0), Vector3(0.55, 0.38, 0.52), 7, 3, dark, dark.lerp(light, 0.3), rng, 0.05)
		add_cards(st, Vector3(0, 0.38, 0), Vector3(0.82, 0.6, 0.78), 22, 0.30, dark, light, rng)
		add_cards(st, Vector3(0.50, 0.28, 0.2), Vector3(0.52, 0.4, 0.52), 9, 0.24, dark, light.darkened(0.05), rng)
		add_cards(st, Vector3(-0.42, 0.30, -0.18), Vector3(0.54, 0.42, 0.5), 9, 0.24, dark, light.darkened(0.08), rng)
		return _commit(st))


## Souche : tronc court, dessus clair avec ses cernes.
static func stump() -> Mesh:
	return _cached("stump", func() -> Mesh:
		var st: SurfaceTool = _begin()
		var rng: RandomNumberGenerator = _rng(53)
		add_cone(st, Vector3.ZERO, 0.46, 0.38, 0.62, 7, Color(0.26, 0.18, 0.12), Color(0.46, 0.32, 0.20), rng, 0.02)
		add_cone(st, Vector3(0, 0.62, 0), 0.36, 0.30, 0.04, 7, Color(0.78, 0.62, 0.40), Color(0.84, 0.68, 0.44), rng, 0.0)
		add_blob(st, Vector3(0.5, 0.12, 0.2), Vector3(0.32, 0.14, 0.26), 5, 2, Color(0.20, 0.34, 0.16), Color(0.34, 0.54, 0.24), rng, 0.04)
		return _commit(st))


## Cactus à deux bras.
static func cactus() -> Mesh:
	return _cached("cactus", func() -> Mesh:
		var st: SurfaceTool = _begin()
		var rng: RandomNumberGenerator = _rng(61)
		var dark := Color(0.16, 0.38, 0.20)
		var light := Color(0.38, 0.64, 0.32)
		add_cone(st, Vector3.ZERO, 0.30, 0.26, 1.7, 7, dark, light, rng, 0.012)
		add_blob(st, Vector3(0, 1.72, 0), Vector3(0.27, 0.22, 0.27), 10, 5, dark.lightened(0.1), light, rng, 0.01)
		add_cone(st, Vector3(0.25, 0.7, 0), 0.15, 0.13, 0.42, 6, dark, light, rng, 0.008)
		add_cone(st, Vector3(0.56, 0.7, 0), 0.14, 0.13, 0.75, 6, dark, light, rng, 0.008)
		add_blob(st, Vector3(0.56, 1.47, 0), Vector3(0.15, 0.13, 0.15), 6, 3, dark.lightened(0.1), light, rng, 0.01)
		add_cone(st, Vector3(-0.25, 0.95, 0), 0.13, 0.12, 0.40, 6, dark, light, rng, 0.008)
		add_cone(st, Vector3(-0.54, 0.95, 0), 0.12, 0.11, 0.58, 6, dark, light, rng, 0.008)
		add_blob(st, Vector3(-0.54, 1.55, 0), Vector3(0.13, 0.12, 0.13), 6, 3, dark.lightened(0.1), light, rng, 0.01)
		return _commit(st))


## Palmier : tronc courbe + frondes retombantes.
static func palm() -> Mesh:
	return _cached("palm", func() -> Mesh:
		var st: SurfaceTool = _begin()
		var rng: RandomNumberGenerator = _rng(67)
		var bark_b := Color(0.36, 0.25, 0.16)
		var bark_t := Color(0.55, 0.40, 0.26)
		var base := Vector3.ZERO
		for i: int in range(5):
			var f: float = float(i) / 5.0
			var seg_base: Vector3 = Vector3(f * f * 0.45, f * 2.2, 0)
			add_cone(st, seg_base, 0.17 - f * 0.05, 0.15 - f * 0.05, 0.46, 6, bark_b.lerp(bark_t, f), bark_b.lerp(bark_t, f + 0.2), rng, 0.01, false)
		var crown := Vector3(0.45, 2.25, 0)
		var dark := Color(0.14, 0.38, 0.16)
		var light := Color(0.40, 0.68, 0.26)
		for k: int in range(8):
			var ang: float = float(k) / 8.0 * TAU + rng.randf() * 0.2
			var out := Vector3(cos(ang), 0.0, sin(ang))
			var mid: Vector3 = crown + out * 0.9 + Vector3(0, 0.45, 0)
			var tip: Vector3 = crown + out * 1.75 + Vector3(0, -0.35, 0)
			add_blade(st, crown, mid, 0.5, dark, light)
			add_blade(st, mid, tip, 0.42, light, dark.lightened(0.1))
		add_blob(st, crown + Vector3(0, 0.08, 0), Vector3(0.2, 0.17, 0.2), 6, 3, Color(0.45, 0.30, 0.15), Color(0.62, 0.44, 0.22), rng, 0.01)
		# V89 : frondes plus fournies — cartes de feuilles le long de chaque palme
		for k2: int in range(8):
			var ang2: float = float(k2) / 8.0 * TAU + 0.2
			var out2 := Vector3(cos(ang2), 0.0, sin(ang2))
			add_cards(st, crown + out2 * 0.95 + Vector3(0, 0.12, 0), Vector3(0.62, 0.22, 0.62), 6, 0.30, dark, light, rng)
		return _commit(st))


## Cristal (grappe de pointes) pour les décors de montagne.
static func crystal() -> Mesh:
	return _cached("crystal", func() -> Mesh:
		smooth_mode = false
		var st: SurfaceTool = _begin()
		var rng: RandomNumberGenerator = _rng(71)
		var cols: Array = [[Color(0.30, 0.55, 0.78), Color(0.78, 0.94, 1.0)], [Color(0.42, 0.40, 0.80), Color(0.86, 0.84, 1.0)]]
		var spec: Array = [[Vector3(0, 0, 0), 0.30, 1.6, 0], [Vector3(0.42, 0, 0.1), 0.22, 1.0, 1], [Vector3(-0.38, 0, -0.1), 0.2, 0.85, 0], [Vector3(0.1, 0, 0.42), 0.18, 0.7, 1]]
		for e: Array in spec:
			var c: Array = cols[e[3]]
			add_cone(st, e[0], e[1], e[1] * 0.55, e[2] * 0.6, 6, c[0], c[0].lerp(c[1], 0.6), rng, 0.0, true)
			add_cone(st, (e[0] as Vector3) + Vector3(0, e[2] * 0.6, 0), e[1] * 0.55, 0.0, e[2] * 0.4, 6, c[0].lerp(c[1], 0.5), c[1], rng, 0.0, false)
		return _commit(st))


## Pilier de pierre (donjon / ruines).
static func pillar() -> Mesh:
	return _cached("pillar", func() -> Mesh:
		smooth_mode = false
		var st: SurfaceTool = _begin()
		var rng: RandomNumberGenerator = _rng(73)
		var bot := Color(0.30, 0.30, 0.34)
		var top := Color(0.62, 0.62, 0.66)
		add_cone(st, Vector3.ZERO, 0.52, 0.40, 0.22, 6, bot, top.darkened(0.3), rng, 0.0)
		add_cone(st, Vector3(0, 0.22, 0), 0.36, 0.32, 1.7, 6, bot.lightened(0.05), top, rng, 0.02)
		add_cone(st, Vector3(0, 1.92, 0), 0.46, 0.52, 0.2, 6, top.darkened(0.1), top.lightened(0.05), rng, 0.0)
		return _commit(st))


## Touffe d'herbe : quelques lames qui ondulent.
static func tuft() -> Mesh:
	return _cached("tuft", func() -> Mesh:
		var st: SurfaceTool = _begin()
		var rng: RandomNumberGenerator = _rng(79)
		var dark := Color(0.24, 0.48, 0.17)
		var light := Color(0.56, 0.80, 0.33)
		for i: int in range(5):
			var a: float = rng.randf() * TAU
			var r: float = rng.randf_range(0.0, 0.10)
			var base := Vector3(cos(a) * r, 0, sin(a) * r)
			var lean := Vector3(cos(a), 0, sin(a)) * rng.randf_range(0.04, 0.16)
			add_blade(st, base, base + lean + Vector3(0, rng.randf_range(0.30, 0.52), 0), 0.11, dark, light)
		return _commit(st))


## Fleur : tige + corolle (la corolle est teintée par la couleur d'instance).
static func flower() -> Mesh:
	return _cached("flower", func() -> Mesh:
		var st: SurfaceTool = _begin()
		var rng: RandomNumberGenerator = _rng(83)
		add_blade(st, Vector3.ZERO, Vector3(0, 0.30, 0), 0.04, Color(0.18, 0.40, 0.16), Color(0.30, 0.58, 0.22))
		add_blob(st, Vector3(0, 0.33, 0), Vector3(0.13, 0.06, 0.13), 6, 2, Color(0.85, 0.85, 0.85), Color(1, 1, 1), rng, 0.0)
		add_blob(st, Vector3(0, 0.37, 0), Vector3(0.05, 0.03, 0.05), 5, 2, Color(0.95, 0.80, 0.2), Color(1.0, 0.9, 0.35), rng, 0.0)
		return _commit(st))


## Champignon.
static func mushroom() -> Mesh:
	return _cached("mushroom", func() -> Mesh:
		var st: SurfaceTool = _begin()
		var rng: RandomNumberGenerator = _rng(89)
		add_cone(st, Vector3.ZERO, 0.06, 0.05, 0.2, 5, Color(0.80, 0.76, 0.66), Color(0.92, 0.88, 0.78), rng, 0.0, false)
		add_blob(st, Vector3(0, 0.22, 0), Vector3(0.17, 0.11, 0.17), 6, 3, Color(0.62, 0.14, 0.12), Color(0.88, 0.26, 0.20), rng, 0.0)
		return _commit(st))


## Stalactite pointe vers le bas (dessous de l'île) ; couleurs données par la palette du biome.
static func stalactite(top_col: Color, tip_col: Color) -> Mesh:
	return _cached("stalactite_%s_%s" % [top_col.to_html(), tip_col.to_html()], func() -> Mesh:
		smooth_mode = false
		var st: SurfaceTool = _begin()
		var rng: RandomNumberGenerator = _rng(97)
		var segs := 6
		var h := 1.0
		var ring: Array[Vector3] = []
		for i: int in range(segs):
			var a: float = float(i) / float(segs) * TAU
			ring.append(Vector3(cos(a) * 0.5, 0.0, sin(a) * 0.5) + _jit(rng, 0.05) * Vector3(1, 0, 1))
		var tip := Vector3(0, -h, 0)
		var center := Vector3(0, -h * 0.4, 0)
		for i: int in range(segs):
			var j: int = (i + 1) % segs
			_tri(st, ring[i], ring[j], tip, top_col, top_col, tip_col, center)
		return _commit(st))


## Nuage : amas d'ellipsoïdes blancs (matériau non éclairé fourni par l'appelant).
static func cloud() -> Mesh:
	return _cached("cloud", func() -> Mesh:
		var st: SurfaceTool = _begin()
		var rng: RandomNumberGenerator = _rng(101)
		var white_b := Color(0.86, 0.90, 0.96)
		var white_t := Color(1.0, 1.0, 1.0)
		add_blob(st, Vector3(0, 0, 0), Vector3(3.2, 1.1, 2.2), 8, 3, white_b, white_t, rng, 0.04)
		add_blob(st, Vector3(2.4, -0.15, 0.4), Vector3(2.2, 0.85, 1.7), 7, 3, white_b, white_t, rng, 0.04)
		add_blob(st, Vector3(-2.3, -0.1, -0.3), Vector3(2.0, 0.8, 1.6), 7, 3, white_b, white_t, rng, 0.04)
		add_blob(st, Vector3(0.4, 0.7, 0.2), Vector3(1.9, 0.9, 1.5), 7, 3, white_b, white_t, rng, 0.04)
		return _commit(st))


## Îlot flottant lointain : dessus d'herbe bombé, dessous de roche effilé (décor du ciel).
static func islet(top_col: Color, rock_col: Color) -> Mesh:
	return _cached("islet_%s_%s" % [top_col.to_html(), rock_col.to_html()], func() -> Mesh:
		var st: SurfaceTool = _begin()
		var rng: RandomNumberGenerator = _rng(83)
		add_blob(st, Vector3(0, 0, 0), Vector3(1.0, 0.28, 1.0), 12, 4, top_col.darkened(0.1), top_col.lightened(0.08), rng, 0.02)
		# dessous : cône inversé en trois étages de roche
		smooth_mode = false
		add_blob(st, Vector3(0, -0.45, 0), Vector3(0.82, 0.55, 0.82), 9, 5, rock_col.darkened(0.45), rock_col, rng, 0.08)
		add_blob(st, Vector3(0.05, -1.05, 0.0), Vector3(0.5, 0.65, 0.5), 7, 4, rock_col.darkened(0.55), rock_col.darkened(0.2), rng, 0.08)
		add_blob(st, Vector3(0.0, -1.6, 0.05), Vector3(0.24, 0.5, 0.24), 6, 3, rock_col.darkened(0.6), rock_col.darkened(0.3), rng, 0.06)
		smooth_mode = true
		return _commit(st))
