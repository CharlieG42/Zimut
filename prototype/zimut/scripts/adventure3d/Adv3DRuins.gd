class_name Adv3DRuins
extends RefCounted
## Adv3DRuins.gd — V437 : ruines et rochers à facettes (style « ruines éclairées à la torche »).
##
## Colonnes brisées, arches, murs écroulés, dalles, rochers anguleux, braseros : posés autour des lieux d'une
## zone pour donner de la matière et des points d'intérêt, avec de la lumière chaude locale (feux) et des rayons
## de soleil. Tout est construit en code (facettes plates, couleurs de sommets, ombre propre en bas / lumière en
## haut), un MultiMesh par pièce : quelques appels de rendu pour toute la zone. Les pièces sont décoratives
## (sans collision) et placées hors des sentiers.

const NATIONS := ["Forêt"]            # biomes qui reçoivent des ruines (la Sylve pour le prototype)
const MAX_LIGHTS := 4                 # feux avec une vraie lumière (qualité Haute) ; les autres ne font que briller
const STONE_BOT := Color(0.52, 0.50, 0.50)
const STONE_TOP := Color(0.88, 0.84, 0.76)
const MOSS_BOT := Color(0.20, 0.36, 0.18)
const MOSS_TOP := Color(0.40, 0.58, 0.26)

static var _cache: Dictionary = {}


static func enabled(biome: String) -> bool:
	return biome in NATIONS


# ══════════════════════════════════════════════════════════════════════
#  Meshes
# ══════════════════════════════════════════════════════════════════════

## Boîte orientée : `xf` donne la position du centre et la rotation ; couleurs bas / haut selon la hauteur locale.
static func _box_xf(st: SurfaceTool, xf: Transform3D, size: Vector3, col_bot: Color, col_top: Color) -> void:
	var h: Vector3 = size * 0.5
	var v: Array[Vector3] = []
	var lowv: Array[bool] = []
	for sx: float in [-1.0, 1.0]:
		for sy: float in [-1.0, 1.0]:
			for sz: float in [-1.0, 1.0]:
				v.append(xf * Vector3(h.x * sx, h.y * sy, h.z * sz))
				lowv.append(sy < 0.0)
	var faces: Array = [[0, 1, 3, 2], [4, 6, 7, 5], [0, 4, 5, 1], [2, 3, 7, 6], [0, 2, 6, 4], [1, 5, 7, 3]]
	for f: Array in faces:
		var cs: Array[Color] = []
		for i: int in range(4):
			cs.append(col_bot if lowv[f[i]] else col_top)
		Adv3DMeshes._tri(st, v[f[0]], v[f[1]], v[f[2]], cs[0], cs[1], cs[2], xf.origin)
		Adv3DMeshes._tri(st, v[f[0]], v[f[2]], v[f[3]], cs[0], cs[2], cs[3], xf.origin)


static func _xf(pos: Vector3, rot: Vector3 = Vector3.ZERO) -> Transform3D:
	return Transform3D(Basis.from_euler(rot), pos)


static func _stone(rng: RandomNumberGenerator, light: float = 0.0) -> Array:
	var k: float = rng.randf_range(-0.05, 0.05) + light
	return [STONE_BOT.lightened(maxf(k, 0.0)).darkened(maxf(-k, 0.0)), STONE_TOP.lightened(maxf(k, 0.0)).darkened(maxf(-k, 0.0))]


static func _begin() -> SurfaceTool:
	Adv3DMeshes.smooth_mode = false
	return Adv3DMeshes._begin()


static func _cached(key: String, builder: Callable) -> Mesh:
	if not _cache.has(key):
		_cache[key] = builder.call()
	return _cache[key]


## Colonne : socle, fût à six pans, chapiteau. `broken` : fût cassé en biseau, tambours tombés au pied.
static func column(broken: bool) -> Mesh:
	return _cached("column_%s" % broken, func() -> Mesh:
		var st: SurfaceTool = _begin()
		var rng: RandomNumberGenerator = Adv3DMeshes._rng(11 if broken else 12)
		var c: Array = _stone(rng)
		_box_xf(st, _xf(Vector3(0, 0.14, 0)), Vector3(1.0, 0.28, 1.0), c[0], c[1].darkened(0.1))
		var shaft_h: float = 1.35 if broken else 2.35
		Adv3DMeshes.add_cone(st, Vector3(0, 0.28, 0), 0.40, 0.33, shaft_h, 6, c[0].lightened(0.04), c[1], rng, 0.015)
		if broken:
			_box_xf(st, _xf(Vector3(0.06, 0.28 + shaft_h + 0.08, 0.0), Vector3(0.0, 0.5, 0.35)), Vector3(0.50, 0.26, 0.38), c[0].lightened(0.1), c[1].darkened(0.04))
			_box_xf(st, _xf(Vector3(0.95, 0.20, 0.45), Vector3(0.0, 0.7, 0.0)), Vector3(0.62, 0.40, 0.62), c[0], c[1].darkened(0.06))
			_box_xf(st, _xf(Vector3(-0.85, 0.16, -0.7), Vector3(0.1, 0.3, 0.2)), Vector3(0.58, 0.32, 0.56), c[0], c[1].darkened(0.12))
			# touffe de mousse sur le tambour
			_box_xf(st, _xf(Vector3(0.95, 0.42, 0.45), Vector3(0.0, 0.7, 0.0)), Vector3(0.54, 0.08, 0.54), MOSS_BOT, MOSS_TOP)
		else:
			_box_xf(st, _xf(Vector3(0, 0.28 + shaft_h + 0.11, 0)), Vector3(0.86, 0.22, 0.86), c[0].lightened(0.06), c[1].lightened(0.04))
		return Adv3DMeshes._commit(st))


## Arche : deux piliers et un cintre de claveaux ; `broken` : trois claveaux manquent côté droit.
static func arch(broken: bool) -> Mesh:
	return _cached("arch_%s" % broken, func() -> Mesh:
		var st: SurfaceTool = _begin()
		var rng: RandomNumberGenerator = Adv3DMeshes._rng(21 if broken else 22)
		var c: Array = _stone(rng)
		var span: float = 1.25
		var spring: float = 2.2
		for sx: float in [-1.0, 1.0]:
			var h: float = spring if (not broken or sx < 0.0) else spring * 0.62
			Adv3DMeshes.add_cone(st, Vector3(sx * span, 0.0, 0.0), 0.50, 0.44, h, 6, c[0], c[1], rng, 0.02)
			_box_xf(st, _xf(Vector3(sx * span, 0.12, 0.0)), Vector3(1.15, 0.24, 1.0), c[0].darkened(0.06), c[1].darkened(0.1))
		var n: int = 9
		for i: int in range(n):
			var a: float = PI * (float(i) + 0.5) / float(n)
			if broken and i < 3:
				continue
			var pos := Vector3(cos(a) * span, spring + sin(a) * span * 0.95, 0.0)
			var cc: Array = _stone(rng, 0.03)
			_box_xf(st, _xf(pos, Vector3(0.0, 0.0, a - PI * 0.5)), Vector3(0.46, 0.50, 0.62), cc[0].lightened(0.05), cc[1])
		if broken:
			# claveaux tombés au sol
			_box_xf(st, _xf(Vector3(1.9, 0.18, 0.9), Vector3(0.1, 0.5, 0.2)), Vector3(0.52, 0.34, 0.60), c[0], c[1].darkened(0.05))
			_box_xf(st, _xf(Vector3(2.5, 0.14, 0.2), Vector3(0.0, 1.0, 0.1)), Vector3(0.46, 0.28, 0.56), c[0], c[1].darkened(0.1))
		_box_xf(st, _xf(Vector3(-span, spring + 0.1, 0.0)), Vector3(0.0001, 0.0001, 0.0001), c[0], c[1])
		return Adv3DMeshes._commit(st))


## Pan de mur écroulé : assises de blocs, plus basses vers un bout, quelques blocs tombés.
static func wall() -> Mesh:
	return _cached("wall", func() -> Mesh:
		var st: SurfaceTool = _begin()
		var rng: RandomNumberGenerator = Adv3DMeshes._rng(31)
		var cols: int = 6
		for i: int in range(cols):
			var rows: int = clampi(3 - int(float(i) * 0.5) + rng.randi_range(-1, 0), 1, 3)
			for j: int in range(rows):
				var c: Array = _stone(rng, 0.02 * float(j))
				var w: float = rng.randf_range(0.78, 0.92)
				var pos := Vector3((float(i) - float(cols) * 0.5) * 0.9 + rng.randf_range(-0.04, 0.04), 0.23 + float(j) * 0.47, rng.randf_range(-0.05, 0.05))
				_box_xf(st, _xf(pos, Vector3(0.0, rng.randf_range(-0.05, 0.05), 0.0)), Vector3(w, 0.45, 0.56), c[0], c[1])
			if rows >= 2 and rng.randf() < 0.5:
				_box_xf(st, _xf(Vector3((float(i) - float(cols) * 0.5) * 0.9, 0.23 + float(rows) * 0.47 + 0.06, 0.0), Vector3(0, 0, 0)), Vector3(0.7, 0.08, 0.5), MOSS_BOT, MOSS_TOP)
		for k: int in range(3):
			var c2: Array = _stone(rng)
			_box_xf(st, _xf(Vector3(rng.randf_range(-2.4, 2.4), 0.16, rng.randf_range(0.7, 1.3)), Vector3(rng.randf_range(-0.2, 0.2), rng.randf_range(0, 3.0), rng.randf_range(-0.3, 0.3))), Vector3(0.5, 0.32, 0.46), c2[0], c2[1].darkened(0.05))
		return Adv3DMeshes._commit(st))


## Rochers anguleux : dalles posées de guingois, la plus grande dressée comme un menhir.
static func slabs() -> Mesh:
	return _cached("slabs", func() -> Mesh:
		var st: SurfaceTool = _begin()
		var rng: RandomNumberGenerator = Adv3DMeshes._rng(41)
		var c: Array = _stone(rng)
		_box_xf(st, _xf(Vector3(0, 0.62, 0), Vector3(0.12, 0.4, 0.18)), Vector3(0.9, 1.5, 0.55), c[0], c[1])
		_box_xf(st, _xf(Vector3(0.0, 1.36, 0.0), Vector3(0.15, 0.4, 0.32)), Vector3(0.50, 0.30, 0.34), c[0].lightened(0.08), c[1].lightened(0.05))
		for i: int in range(4):
			var a: float = float(i) * 1.7 + 0.5
			var cc: Array = _stone(rng, 0.02)
			var sz := Vector3(rng.randf_range(0.7, 1.2), rng.randf_range(0.30, 0.55), rng.randf_range(0.6, 1.0))
			_box_xf(st, _xf(Vector3(cos(a) * 1.1, sz.y * 0.4, sin(a) * 1.1), Vector3(rng.randf_range(-0.25, 0.25), rng.randf_range(0, 3.1), rng.randf_range(-0.3, 0.3))), sz, cc[0], cc[1])
		_box_xf(st, _xf(Vector3(0.0, 1.55, 0.0), Vector3(0.15, 0.4, 0.32)), Vector3(0.40, 0.07, 0.28), MOSS_BOT, MOSS_TOP)
		return Adv3DMeshes._commit(st))


## Brasero : pied de bois, coupe de pierre.
static func brazier() -> Mesh:
	return _cached("brazier", func() -> Mesh:
		var st: SurfaceTool = _begin()
		var rng: RandomNumberGenerator = Adv3DMeshes._rng(51)
		var wood_b := Color(0.20, 0.13, 0.09)
		var wood_t := Color(0.46, 0.32, 0.20)
		Adv3DMeshes.add_cone(st, Vector3.ZERO, 0.20, 0.10, 1.25, 5, wood_b, wood_t, rng, 0.0)
		Adv3DMeshes.add_cone(st, Vector3(0, 1.20, 0), 0.20, 0.42, 0.26, 7, Color(0.18, 0.16, 0.17), Color(0.42, 0.38, 0.36), rng, 0.0)
		return Adv3DMeshes._commit(st))


## Flamme : trois cônes qui se coupent, émissifs (matériau sans éclairage).
static func flame() -> Mesh:
	return _cached("flame", func() -> Mesh:
		var st: SurfaceTool = _begin()
		var rng: RandomNumberGenerator = Adv3DMeshes._rng(52)
		Adv3DMeshes.add_cone(st, Vector3(0, 0, 0), 0.30, 0.0, 0.85, 6, Color(1.0, 0.45, 0.08), Color(1.0, 0.86, 0.35), rng, 0.0)
		Adv3DMeshes.add_cone(st, Vector3(0.08, 0, 0.04), 0.18, 0.0, 0.62, 5, Color(1.0, 0.62, 0.14), Color(1.0, 0.95, 0.60), rng, 0.0)
		return Adv3DMeshes._commit(st))


static func stone_material() -> ShaderMaterial:
	var m: ShaderMaterial = Adv3DMeshes.solid_material(false, false)
	m.set_shader_parameter("emit", 0.04)
	return m


static func flame_material() -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	m.vertex_color_use_as_albedo = true
	m.albedo_color = Color(1.4, 1.1, 0.7)
	m.cull_mode = BaseMaterial3D.CULL_DISABLED
	return m


# ══════════════════════════════════════════════════════════════════════
#  Placement
# ══════════════════════════════════════════════════════════════════════

## Ajoute les ruines de la zone sous `root`. Retourne le nombre de pièces posées.
static func build(root: Node3D, zone_id: String, t: Dictionary, biome: String) -> int:
	if not enabled(biome):
		return 0
	var size: Vector2i = t["size"]
	var rng := RandomNumberGenerator.new()
	rng.seed = absi(zone_id.hash()) + 9091
	var edge: Dictionary = {}
	for e: Vector2i in Adv3DWorld._edge_cells(t):
		edge[e] = true
	var taken: Dictionary = {}
	for k: Vector2i in (t["pois"] as Array):
		taken[k] = true
	for g: Vector2i in (t["gates"] as Array):
		taken[g] = true
	taken[t["start"]] = true
	var free := func(c: Vector2i) -> bool:
		return c.x > 0 and c.y > 0 and c.x < size.x - 1 and c.y < size.y - 1 \
			and not (t["voids"] as Dictionary).has(c) and not (t["obstacles"] as Dictionary).has(c) \
			and not (t["paths"] as Dictionary).has(c) and not edge.has(c) and not taken.has(c)
	var pieces: Dictionary = {"column_a": [], "column_b": [], "arch_a": [], "arch_b": [], "wall": [], "slabs": [], "brazier": []}
	var fires: Array = []
	var place := func(kind: String, c: Vector2i, face: Vector3, jitter: float) -> void:
		var ctr: Vector3 = Adv3DWorld.cell_center(c)
		var p := Vector3(ctr.x + rng.randf_range(-jitter, jitter), 0.0, ctr.z + rng.randf_range(-jitter, jitter))
		p.y = Adv3DWorld.height_at(p.x, p.z) - 0.05
		var yaw: float = atan2(face.x - p.x, face.z - p.z) + rng.randf_range(-0.35, 0.35)
		var s: float = rng.randf_range(0.92, 1.12)
		(pieces[kind] as Array).append(Transform3D(Basis(Vector3.UP, yaw).scaled(Vector3(s, s, s)), p))
		taken[c] = true
		if kind == "brazier":
			fires.append(p + Vector3(0, 1.3, 0))
	# 1) autour de chaque lieu : une arche brisée côté « fond », des colonnes, un mur, deux braseros
	var pois: Array = t["pois"]
	for pi: int in range(pois.size()):
		var poi: Vector2i = pois[pi]
		var poi_pos: Vector3 = Adv3DWorld.cell_center(poi)
		var ring: Array[Vector2i] = []
		for dy: int in range(-3, 4):
			for dx: int in range(-3, 4):
				var d2: int = dx * dx + dy * dy
				if d2 >= 4 and d2 <= 10 and free.call(poi + Vector2i(dx, dy)):
					ring.append(poi + Vector2i(dx, dy))
		# mélange déterministe
		for i: int in range(ring.size() - 1, 0, -1):
			var j: int = rng.randi_range(0, i)
			var tmp: Vector2i = ring[i]
			ring[i] = ring[j]
			ring[j] = tmp
		var plan: Array = ["arch_b" if pi % 2 == 0 else "arch_a", "column_b", "column_a" if pi % 3 == 0 else "slabs", "wall", "brazier", "brazier"]
		for kind: String in plan:
			if ring.is_empty():
				break
			var c: Vector2i = ring.pop_back()
			if not free.call(c):
				continue
			place.call(kind, c, poi_pos, 0.7)
	# 2) quelques ensembles épars (dalles, colonnes brisées) pour casser les grands vides
	var scatter: Array[Vector2i] = []
	for cy: int in range(1, size.y - 1):
		for cx: int in range(1, size.x - 1):
			var c := Vector2i(cx, cy)
			if free.call(c):
				scatter.append(c)
	var wanted: int = clampi(size.x * size.y / 28, 6, 22) / (2 if GfxQuality.low() else 1)   # Économie : moitié moins d'ensembles épars
	for n: int in range(wanted):
		if scatter.is_empty():
			break
		var c2: Vector2i = scatter[rng.randi_range(0, scatter.size() - 1)]
		if not free.call(c2):
			continue
		var kind2: String = ["slabs", "column_b", "wall", "slabs", "column_a"][rng.randi_range(0, 4)]
		place.call(kind2, c2, Adv3DWorld.cell_center(c2) + Vector3(rng.randf_range(-3, 3), 0, rng.randf_range(-3, 3)), 0.9)
	# 3) construction : un MultiMesh par type
	var node := Node3D.new()
	node.name = "Ruines"
	root.add_child(node)
	var mat: ShaderMaterial = stone_material()
	var meshes: Dictionary = {"column_a": column(false), "column_b": column(true), "arch_a": arch(false), "arch_b": arch(true),
		"wall": wall(), "slabs": slabs(), "brazier": brazier()}
	var count: int = 0
	for kind3: String in pieces.keys():
		var xfs: Array = pieces[kind3]
		if xfs.is_empty():
			continue
		var cls: Array = []
		for i: int in range(xfs.size()):
			var v: float = rng.randf_range(0.92, 1.06)
			cls.append(Color(v, v, v))
		count += xfs.size()
		Adv3DWorld._multi_one(node, "Ruines_" + kind3, meshes[kind3], xfs, cls, mat)
	# 4) feux : flamme émissive partout ; vraie lumière chaude pour les plus proches du départ (qualité Haute)
	var start_pos: Vector3 = Adv3DWorld.cell_center(t["start"])
	fires.sort_custom(func(a: Vector3, b: Vector3) -> bool: return a.distance_to(start_pos) < b.distance_to(start_pos))
	var flame_xf: Array = []
	var flame_cl: Array = []
	for i: int in range(fires.size()):
		var fp: Vector3 = fires[i]
		flame_xf.append(Transform3D(Basis(Vector3.UP, rng.randf() * TAU), fp - Vector3(0, 0.05, 0)))
		flame_cl.append(Color.WHITE)
		if not GfxQuality.low() and i < MAX_LIGHTS:
			var l := OmniLight3D.new()
			l.name = "FeuLumiere_%d" % i
			l.position = fp + Vector3(0, 0.5, 0)
			l.light_color = Color(1.0, 0.60, 0.28)
			l.light_energy = 2.4
			l.omni_range = 9.0
			l.omni_attenuation = 1.4
			l.shadow_enabled = false
			node.add_child(l)
	if not flame_xf.is_empty():
		Adv3DWorld._multi_one(node, "Ruines_flammes", flame(), flame_xf, flame_cl, flame_material())
	return count
