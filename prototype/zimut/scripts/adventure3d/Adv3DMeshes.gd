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


# ══════════════════════════════════════════════════════════════════════
#  Matériaux
# ══════════════════════════════════════════════════════════════════════

const FOLIAGE_SHADER := """
shader_type spatial;
render_mode cull_disabled;
// Feuillage : couleurs de sommets (sRGB) + balancement au vent croissant avec la hauteur.
uniform float sway = 0.16;
uniform float speed = 1.5;
void vertex() {
	float h = max(VERTEX.y, 0.0);
	vec3 wp = MODEL_MATRIX[3].xyz;
	float ph = wp.x * 0.42 + wp.z * 0.31;
	float w = sin(TIME * speed + ph) * 0.6 + sin(TIME * speed * 1.7 + ph * 1.3) * 0.25;
	VERTEX.x += w * sway * h * h * 0.18;
	VERTEX.z += cos(TIME * speed * 0.8 + ph) * sway * h * h * 0.10;
}
void fragment() {
	ALBEDO = pow(COLOR.rgb, vec3(2.2));
	ROUGHNESS = 0.92;
}
"""


## Matériau opaque à couleurs de sommets sRGB (sol, rochers, falaises).
static func solid_material(double_sided: bool = false) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.vertex_color_use_as_albedo = true
	m.vertex_color_is_srgb = true
	m.roughness = 0.95
	if double_sided:
		m.cull_mode = BaseMaterial3D.CULL_DISABLED
	return m


## Matériau de feuillage qui ondule au vent.
static func foliage_material(sway: float = 0.16) -> ShaderMaterial:
	if not _cache.has("foliage_shader"):
		var sh := Shader.new()
		sh.code = FOLIAGE_SHADER
		_cache["foliage_shader"] = sh
	var m := ShaderMaterial.new()
	m.shader = _cache["foliage_shader"]
	m.set_shader_parameter("sway", sway)
	return m


## Ombre douce posée au sol : disque sombre translucide.
static func shadow_material() -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	m.albedo_color = Color(0.04, 0.07, 0.03, 0.34)
	m.cull_mode = BaseMaterial3D.CULL_DISABLED
	m.no_depth_test = false
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
	for i: int in range(segs):
		var j: int = (i + 1) % segs
		if r_top <= 0.001:
			_tri(st, ring_b[i], ring_b[j], top_c, col_bot, col_bot, col_top, center)
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
			if r == 0:
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
	return st


static func _cached(key: String, builder: Callable) -> Mesh:
	if not _cache.has(key):
		_cache[key] = builder.call()
	return _cache[key]


## Sapin à trois étages (version enneigée pour la montagne).
static func pine(snow: bool = false) -> Mesh:
	return _cached("pine_%s" % snow, func() -> Mesh:
		var st: SurfaceTool = _begin()
		var rng: RandomNumberGenerator = _rng(11)
		var bark_b := Color(0.30, 0.20, 0.13)
		var bark_t := Color(0.42, 0.29, 0.18)
		add_cone(st, Vector3.ZERO, 0.19, 0.12, 1.0, 6, bark_b, bark_t, rng, 0.01)
		var tiers: Array = [[0.55, 1.15, 1.35], [1.35, 0.88, 1.20], [2.05, 0.60, 1.10]]
		for i: int in range(tiers.size()):
			var t: Array = tiers[i]
			var dark := Color(0.08, 0.26, 0.17).lerp(Color(0.12, 0.31, 0.20), float(i) * 0.5)
			var light := Color(0.20, 0.47, 0.28).lerp(Color(0.30, 0.56, 0.32), float(i) * 0.5)
			if snow:
				light = Color(0.92, 0.96, 0.98)
				dark = Color(0.36, 0.56, 0.52)
			add_cone(st, Vector3(0, t[0], 0), t[1], 0.0, t[2], 7, dark, light, rng, 0.05, false)
		return _commit(st))


## Arbre à feuillage : tronc légèrement conique + amas de boules de feuilles.
static func broadleaf() -> Mesh:
	return _cached("broadleaf", func() -> Mesh:
		var st: SurfaceTool = _begin()
		var rng: RandomNumberGenerator = _rng(23)
		add_cone(st, Vector3.ZERO, 0.22, 0.12, 1.5, 6, Color(0.28, 0.19, 0.12), Color(0.45, 0.31, 0.20), rng, 0.015)
		add_cone(st, Vector3(0, 1.0, 0), 0.10, 0.06, 0.7, 5, Color(0.40, 0.28, 0.18), Color(0.42, 0.30, 0.19), rng, 0.01)
		var dark := Color(0.12, 0.33, 0.14)
		var light := Color(0.42, 0.68, 0.26)
		add_blob(st, Vector3(0.0, 2.05, 0.0), Vector3(1.05, 0.88, 1.05), 8, 4, dark, light, rng, 0.05)
		add_blob(st, Vector3(0.62, 1.72, 0.25), Vector3(0.72, 0.62, 0.72), 7, 3, dark, light.darkened(0.04), rng, 0.05)
		add_blob(st, Vector3(-0.58, 1.78, -0.30), Vector3(0.70, 0.60, 0.70), 7, 3, dark, light.darkened(0.06), rng, 0.05)
		add_blob(st, Vector3(0.05, 2.65, 0.05), Vector3(0.62, 0.50, 0.62), 7, 3, dark.lightened(0.05), light.lightened(0.05), rng, 0.05)
		return _commit(st))


## Rocher + petits cailloux ; `warm` = grès du désert, sinon granit moussu.
static func rock(warm: bool = false) -> Mesh:
	return _cached("rock_%s" % warm, func() -> Mesh:
		var st: SurfaceTool = _begin()
		var rng: RandomNumberGenerator = _rng(37)
		var bot: Color = Color(0.34, 0.26, 0.20) if warm else Color(0.34, 0.34, 0.36)
		var top: Color = Color(0.84, 0.66, 0.44) if warm else Color(0.66, 0.68, 0.62)
		add_blob(st, Vector3(0, 0.42, 0), Vector3(1.0, 0.72, 0.85), 6, 4, bot, top, rng, 0.14)
		add_blob(st, Vector3(0.95, 0.18, 0.4), Vector3(0.40, 0.28, 0.36), 5, 3, bot, top.darkened(0.06), rng, 0.12)
		add_blob(st, Vector3(-0.8, 0.14, -0.55), Vector3(0.30, 0.22, 0.28), 5, 3, bot, top.darkened(0.1), rng, 0.12)
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
		add_blob(st, Vector3(0, 0.38, 0), Vector3(0.75, 0.55, 0.72), 7, 3, dark, light, rng, 0.06)
		add_blob(st, Vector3(0.50, 0.28, 0.2), Vector3(0.48, 0.38, 0.48), 6, 3, dark, light.darkened(0.05), rng, 0.06)
		add_blob(st, Vector3(-0.42, 0.30, -0.18), Vector3(0.50, 0.40, 0.46), 6, 3, dark, light.darkened(0.08), rng, 0.06)
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
		add_blob(st, Vector3(0, 1.72, 0), Vector3(0.27, 0.22, 0.27), 7, 3, dark.lightened(0.1), light, rng, 0.01)
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
		return _commit(st))


## Cristal (grappe de pointes) pour les décors de montagne.
static func crystal() -> Mesh:
	return _cached("crystal", func() -> Mesh:
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
		var dark := Color(0.16, 0.38, 0.14)
		var light := Color(0.50, 0.74, 0.30)
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
