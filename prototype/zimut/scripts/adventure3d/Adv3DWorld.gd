class_name Adv3DWorld
extends RefCounted
## Adv3DWorld.gd — Terrain 3D low-poly d'une carte d'Aventure (V60, refondu en V61).
##
## Génère, à partir du terrain DÉJÀ utilisé par la carte classique (AdventureTerrain : cases,
## obstacles, sentiers, portes, lieux), une île 3D flottante : même monde, vu au sol.
## Rien n'est importé : tout est construit en code (légèreté Android, style low-poly).
## Les meshes de décor viennent de Adv3DMeshes ; personnages et marqueurs de Adv3DActors.
##
## Repère : la case (cx, cy) de la grille occupe [cx·CELL, (cx+1)·CELL] sur X et
## [cy·CELL, (cy+1)·CELL] sur Z. L'axe Y est la hauteur.

const CELL := 3.0
const SKIRT := 3.4                 # profondeur de la falaise sous l'île
const OBSTACLE_RADIUS := 0.95      # rayon bloquant d'un arbre / rocher (< demi-case : les cases restent reliées)
const HEIGHT_AMPLITUDE := 0.6
const SUN_SHADOW_OFFSET := Vector3(0.28, 0.0, 0.22)   # les ombres tombent du côté opposé au soleil

## Couleurs par biome (sRGB ; les Nations sans palette propre reprennent celle de la Forêt).
const PALETTES := {
	"Forêt": {
		"ground": [Color(0.38, 0.66, 0.27), Color(0.45, 0.72, 0.31), Color(0.33, 0.58, 0.25)],
		"path": Color(0.74, 0.60, 0.40), "cliff_top": Color(0.50, 0.37, 0.25), "cliff_bot": Color(0.20, 0.15, 0.13),
		"sky_top": Color(0.24, 0.50, 0.84), "sky_hor": Color(0.74, 0.88, 0.96), "fog": Color(0.74, 0.86, 0.92),
		"sun": Color(1.0, 0.94, 0.80), "ambient": Color(0.62, 0.74, 0.92),
	},
	"Montagne": {
		"ground": [Color(0.50, 0.57, 0.62), Color(0.64, 0.71, 0.76), Color(0.84, 0.90, 0.95)],
		"path": Color(0.50, 0.46, 0.42), "cliff_top": Color(0.44, 0.46, 0.52), "cliff_bot": Color(0.17, 0.18, 0.23),
		"sky_top": Color(0.30, 0.52, 0.82), "sky_hor": Color(0.82, 0.90, 0.97), "fog": Color(0.82, 0.88, 0.95),
		"sun": Color(0.96, 0.97, 1.0), "ambient": Color(0.66, 0.74, 0.92),
	},
	"Désert": {
		"ground": [Color(0.90, 0.74, 0.46), Color(0.94, 0.80, 0.52), Color(0.84, 0.68, 0.40)],
		"path": Color(0.74, 0.55, 0.34), "cliff_top": Color(0.70, 0.48, 0.28), "cliff_bot": Color(0.30, 0.20, 0.14),
		"sky_top": Color(0.28, 0.54, 0.88), "sky_hor": Color(0.98, 0.88, 0.72), "fog": Color(0.97, 0.86, 0.68),
		"sun": Color(1.0, 0.92, 0.72), "ambient": Color(0.92, 0.80, 0.68),
	},
}

static var _noise: FastNoiseLite = null
static var _patch_noise: FastNoiseLite = null


# ══════════════════════════════════════════════════════════════════════
#  Repère monde ↔ grille
# ══════════════════════════════════════════════════════════════════════

static func cell_center(c: Vector2i) -> Vector3:
	var p := Vector3((float(c.x) + 0.5) * CELL, 0.0, (float(c.y) + 0.5) * CELL)
	p.y = height_at(p.x, p.z)
	return p


static func world_to_cell(p: Vector3) -> Vector2i:
	return Vector2i(floori(p.x / CELL), floori(p.z / CELL))


static func palette(biome: String) -> Dictionary:
	return PALETTES.get(biome, PALETTES["Forêt"])


## Hauteur du coin de grille (ix, iz) : relief doux, continu d'une case à l'autre.
static func corner_h(ix: int, iz: int) -> float:
	if _noise == null:
		_noise = FastNoiseLite.new()
		_noise.seed = 4242
		_noise.frequency = 0.11
	return _noise.get_noise_2d(float(ix), float(iz)) * HEIGHT_AMPLITUDE


## Hauteur du sol au point (x, z) : interpolation bilinéaire des quatre coins de la case.
static func height_at(x: float, z: float) -> float:
	var fx: float = x / CELL
	var fz: float = z / CELL
	var ix: int = floori(fx)
	var iz: int = floori(fz)
	var tx: float = fx - float(ix)
	var tz: float = fz - float(iz)
	var h0: float = lerpf(corner_h(ix, iz), corner_h(ix + 1, iz), tx)
	var h1: float = lerpf(corner_h(ix, iz + 1), corner_h(ix + 1, iz + 1), tx)
	return lerpf(h0, h1, tz)


## Un point est-il praticable ? (hors île, case vide ou arbre/rocher = non.)
static func point_walkable(t: Dictionary, p: Vector3) -> bool:
	var size: Vector2i = t["size"]
	var c: Vector2i = world_to_cell(p)
	if c.x < 0 or c.y < 0 or c.x >= size.x or c.y >= size.y:
		return false
	if (t["voids"] as Dictionary).has(c):
		return false
	if (t["obstacles"] as Dictionary).has(c):
		var ctr := Vector3((float(c.x) + 0.5) * CELL, p.y, (float(c.y) + 0.5) * CELL)
		return Vector2(p.x - ctr.x, p.z - ctr.z).length() >= OBSTACLE_RADIUS
	return true


## Bruit de « plaques » (0..1) : variations douces de la couleur du sol.
static func _patch(x: float, z: float) -> float:
	if _patch_noise == null:
		_patch_noise = FastNoiseLite.new()
		_patch_noise.seed = 777
		_patch_noise.frequency = 0.11
	return clampf(_patch_noise.get_noise_2d(x, z) * 0.5 + 0.5, 0.0, 1.0)


# ══════════════════════════════════════════════════════════════════════
#  Construction de la carte
# ══════════════════════════════════════════════════════════════════════

## Racine 3D de la zone : sol, falaises, dessous d'île, arbres/rochers, décors de sol, ombres.
static func build(zone_id: String) -> Node3D:
	var t: Dictionary = AdventureTerrain.zone_terrain(zone_id)
	var biome: String = String(t["biome"])
	var pal: Dictionary = palette(biome)
	var root := Node3D.new()
	root.name = "ZoneWorld"
	root.add_child(_build_ground(zone_id, t, pal))
	_build_underside(root, zone_id, t, pal)
	_build_props(root, zone_id, t, biome)
	_build_decor(root, zone_id, t, biome)
	return root


# ── Sol : couleurs lissées entre cases (plus de damier), facettes plates ──

static func _cell_color(c: Vector2i, t: Dictionary, pal: Dictionary) -> Color:
	if (t["paths"] as Dictionary).has(c):
		return pal["path"]
	var cols: Array = pal["ground"]
	var n: float = _patch((float(c.x) + 0.5) * CELL * 0.5, (float(c.y) + 0.5) * CELL * 0.5)
	var f: float = n * float(cols.size() - 1)
	var i: int = clampi(floori(f), 0, cols.size() - 2)
	return (cols[i] as Color).lerp(cols[i + 1], f - float(i))


static func _build_ground(zone_id: String, t: Dictionary, pal: Dictionary) -> MeshInstance3D:
	var size: Vector2i = t["size"]
	var voids: Dictionary = t["voids"]
	# Couleur de chaque coin de grille = moyenne des cases voisines praticables (adoucit sentiers et plaques).
	var corner_col: Dictionary = {}
	for iz: int in range(size.y + 1):
		for ix: int in range(size.x + 1):
			var acc := Color(0, 0, 0, 0)
			var n: int = 0
			for d: Vector2i in [Vector2i(-1, -1), Vector2i(0, -1), Vector2i(-1, 0), Vector2i(0, 0)]:
				var c := Vector2i(ix, iz) + d
				if c.x < 0 or c.y < 0 or c.x >= size.x or c.y >= size.y or voids.has(c):
					continue
				var cc: Color = _cell_color(c, t, pal)
				acc += cc
				n += 1
			if n > 0:
				var avg: Color = acc / float(n)
				var tone: float = (_patch(float(ix) * 1.7, float(iz) * 1.7) - 0.5) * 0.10
				corner_col[Vector2i(ix, iz)] = Color(avg.r + tone, avg.g + tone, avg.b + tone * 0.6)
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var dirs: Array = [
		[Vector2i(0, -1), Vector3(0, 0, -1)], [Vector2i(0, 1), Vector3(0, 0, 1)],
		[Vector2i(-1, 0), Vector3(-1, 0, 0)], [Vector2i(1, 0), Vector3(1, 0, 0)]]
	for cy: int in range(size.y):
		for cx: int in range(size.x):
			var c := Vector2i(cx, cy)
			if voids.has(c):
				continue
			var x0: float = float(cx) * CELL
			var x1: float = float(cx + 1) * CELL
			var z0: float = float(cy) * CELL
			var z1: float = float(cy + 1) * CELL
			var a := Vector3(x0, corner_h(cx, cy), z0)
			var b := Vector3(x1, corner_h(cx + 1, cy), z0)
			var d := Vector3(x1, corner_h(cx + 1, cy + 1), z1)
			var e := Vector3(x0, corner_h(cx, cy + 1), z1)
			var ca: Color = corner_col.get(Vector2i(cx, cy), pal["path"])
			var cb: Color = corner_col.get(Vector2i(cx + 1, cy), ca)
			var cd: Color = corner_col.get(Vector2i(cx + 1, cy + 1), ca)
			var ce: Color = corner_col.get(Vector2i(cx, cy + 1), ca)
			# Dessus : deux triangles à normales distinctes → facettes low-poly.
			var na: Vector3 = _corner_normal(cx, cy)
			var nb: Vector3 = _corner_normal(cx + 1, cy)
			var nd: Vector3 = _corner_normal(cx + 1, cy + 1)
			var ne: Vector3 = _corner_normal(cx, cy + 1)
			_tri_n(st, a, b, d, ca, cb, cd, na, nb, nd)
			_tri_n(st, a, d, e, ca, cd, ce, na, nd, ne)
			# Falaises : sur chaque bord qui touche le vide ou l'extérieur de l'île.
			for dd: Array in dirs:
				var n: Vector2i = c + (dd[0] as Vector2i)
				var edge_open: bool = n.x < 0 or n.y < 0 or n.x >= size.x or n.y >= size.y or voids.has(n)
				if not edge_open:
					continue
				var o: Vector3 = dd[1]
				var p0: Vector3
				var p1: Vector3
				if o.z < 0.0:
					p0 = a; p1 = b
				elif o.z > 0.0:
					p0 = e; p1 = d
				elif o.x < 0.0:
					p0 = a; p1 = e
				else:
					p0 = b; p1 = d
				_skirt(st, p0, p1, o, pal, zone_id)
	var mi := MeshInstance3D.new()
	mi.name = "Ground"
	mi.mesh = st.commit()
	mi.material_override = Adv3DMeshes.solid_material(true)
	return mi


## Normale lissée au coin de grille (ix, iz), d'après le relief voisin : fini l'aspect « blocs ».
static func _corner_normal(ix: int, iz: int) -> Vector3:
	var dx: float = corner_h(ix - 1, iz) - corner_h(ix + 1, iz)
	var dz: float = corner_h(ix, iz - 1) - corner_h(ix, iz + 1)
	return Vector3(dx, 2.0 * CELL, dz).normalized()


static func _tri_n(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3, ca: Color, cb: Color, cc: Color,
		na: Vector3, nb: Vector3, nc: Vector3) -> void:
	var cols: Array = [ca, cb, cc]
	var vs: Array = [a, b, c]
	var ns: Array = [na, nb, nc]
	for i: int in range(3):
		st.set_color(cols[i])
		st.set_normal(ns[i])
		st.add_vertex(vs[i])


## Triangle à normale plate (le sens de la normale est forcé vers le haut).
static func _tri(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3, ca: Color, cb: Color, cc: Color) -> void:
	var n: Vector3 = (c - a).cross(b - a).normalized()
	if n.y < 0.0:
		n = -n
	var cols: Array = [ca, cb, cc]
	var vs: Array = [a, b, c]
	for i: int in range(3):
		st.set_color(cols[i])
		st.set_normal(n)
		st.add_vertex(vs[i])


## Pan de falaise : dégradé terre → roche sombre, avec une lèvre d'herbe au sommet et une strate.
static func _skirt(st: SurfaceTool, p0: Vector3, p1: Vector3, outward: Vector3, pal: Dictionary, zone_id: String) -> void:
	var top: Color = pal["cliff_top"]
	var mid: Color = (pal["cliff_top"] as Color).lerp(pal["cliff_bot"], 0.45)
	var bot: Color = pal["cliff_bot"]
	var lip: Color = (pal["ground"] as Array)[2]
	var y_lip: float = 0.28
	var y_mid: float = SKIRT * 0.45
	var tap: Vector3 = -outward * 1.5           # l'île s'effile vers le bas : silhouette de rocher flottant
	var q0 := Vector3(p0.x, -SKIRT, p0.z) + tap * 1.6
	var q1 := Vector3(p1.x, -SKIRT, p1.z) + tap * 1.6
	var l0 := Vector3(p0.x, p0.y - y_lip, p0.z) - outward * 0.12
	var l1 := Vector3(p1.x, p1.y - y_lip, p1.z) - outward * 0.12
	var m0 := Vector3(p0.x, -y_mid, p0.z) + tap * 0.55
	var m1 := Vector3(p1.x, -y_mid, p1.z) + tap * 0.55
	var quads: Array = [
		[p0, p1, l1, l0, lip.darkened(0.15), lip.darkened(0.15), top, top],
		[l0, l1, m1, m0, top, top, mid, mid],
		[m0, m1, q1, q0, mid, mid, bot, bot]]
	for q: Array in quads:
		var order: Array = [[0, 1, 2], [0, 2, 3]]
		for tri: Array in order:
			for i: int in tri:
				st.set_color(q[4 + i])
				st.set_normal((outward + Vector3(0, -0.35, 0)).normalized())
				st.add_vertex(q[i])


## Dessous de l'île : stalactites de roche qui pendent, pour le côté « île flottante ».
static func _build_underside(root: Node3D, zone_id: String, t: Dictionary, pal: Dictionary) -> void:
	var size: Vector2i = t["size"]
	var voids: Dictionary = t["voids"]
	var rng := RandomNumberGenerator.new()
	rng.seed = absi(zone_id.hash()) + 5
	var xf: Array = []
	var cl: Array = []
	for cy: int in range(size.y):
		for cx: int in range(size.x):
			var c := Vector2i(cx, cy)
			if voids.has(c):
				continue
			var edge: bool = false
			for d: Vector2i in [Vector2i(0, -1), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(1, 0)]:
				var n: Vector2i = c + d
				if n.x < 0 or n.y < 0 or n.x >= size.x or n.y >= size.y or voids.has(n):
					edge = true
			var count: int = 2 if edge else (1 if rng.randf() < 0.3 else 0)
			for k: int in range(count):
				var p := Vector3((float(cx) + rng.randf_range(0.15, 0.85)) * CELL, -SKIRT + 0.2, (float(cy) + rng.randf_range(0.15, 0.85)) * CELL)
				var len: float = rng.randf_range(1.6, 4.6) * (1.0 if edge else 1.3)
				var wid: float = rng.randf_range(0.9, 1.7)
				xf.append(_xf(p, rng.randf() * TAU, Vector3(wid, len, wid)))
				cl.append(Color.WHITE)
	var mesh: Mesh = Adv3DMeshes.stalactite(pal["cliff_bot"].lerp(pal["cliff_top"], 0.35), pal["cliff_bot"].darkened(0.3))
	_multi(root, "Stalactites", mesh, xf, cl, Adv3DMeshes.solid_material(true))


# ── Arbres, rochers, cactus (MultiMesh : un seul appel de rendu par type) ──

static func _kind_category(kind: String) -> String:
	var k: String = kind.to_lower()
	if k.contains("pine") or k.contains("sapin"):
		return "pine"
	if k.contains("cactus"):
		return "cactus"
	if k.contains("palm"):
		return "palm"
	if k.contains("crystal"):
		return "crystal"
	if k.contains("pillar") or k.contains("column") or k.contains("torch") or k.contains("banner"):
		return "pillar"
	if k.contains("rock") or k.contains("stone") or k.contains("rubble") or k.contains("crate") or k.contains("jar"):
		return "rock"
	if k.contains("stump") or k.contains("log"):
		return "stump"
	if k.contains("hedge") or k.contains("bush") or k.contains("thorn"):
		return "bush"
	return "round"


## (rayon d'ombre, décalage vertical de l'ombre) par catégorie.
const SHADOW_R := {"birch": 0.95, "pine": 1.15, "round": 1.25, "rock": 1.1, "bush": 0.95, "cactus": 0.55, "palm": 0.9,
	"stump": 0.6, "crystal": 0.7, "pillar": 0.7}


static func _build_props(root: Node3D, zone_id: String, t: Dictionary, biome: String) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = absi(zone_id.hash()) + 913
	var buckets: Dictionary = {}
	for k: String in ["pine", "round", "birch", "rock", "bush", "cactus", "palm", "stump", "crystal", "pillar"]:
		buckets[k] = {"xf": [], "cl": []}
	var shadow_xf: Array = []
	var shadow_cl: Array = []
	var warm: bool = biome == "Désert"
	var snow: bool = biome == "Montagne"
	for c: Vector2i in (t["obstacles"] as Dictionary).keys():
		var cat: String = _kind_category(String(t["obstacles"][c]))
		if cat == "round" and biome == "Forêt" and rng.randf() < 0.28:
			cat = "birch"
		var ctr := Vector3((float(c.x) + 0.5) * CELL + rng.randf_range(-0.25, 0.25), 0.0, (float(c.y) + 0.5) * CELL + rng.randf_range(-0.25, 0.25))
		ctr.y = height_at(ctr.x, ctr.z)
		var s: float = rng.randf_range(0.85, 1.3)
		var tint: Color = Color.WHITE
		if cat == "round" and rng.randf() < 0.22:
			tint = Color(1.0, 0.86, 0.55) if rng.randf() < 0.6 else Color(0.85, 1.0, 0.78)
		else:
			var v: float = rng.randf_range(0.86, 1.0)
			tint = Color(v, v, v)
		(buckets[cat]["xf"] as Array).append(_xf(ctr, rng.randf() * TAU, Vector3(s, s * rng.randf_range(0.95, 1.2), s)))
		(buckets[cat]["cl"] as Array).append(tint)
		var sr: float = float(SHADOW_R.get(cat, 1.0)) * s
		shadow_xf.append(_xf(ctr + SUN_SHADOW_OFFSET * s + Vector3(0, 0.07, 0), 0.0, Vector3(sr, 1.0, sr * 0.9)))
		shadow_cl.append(Color.WHITE)
	_multi(root, "OmbresDecors", Adv3DMeshes.shadow_mesh(), shadow_xf, shadow_cl, Adv3DMeshes.shadow_material())
	var foliage: ShaderMaterial = Adv3DMeshes.foliage_material(0.16)
	var solid: StandardMaterial3D = Adv3DMeshes.solid_material(true)
	_multi(root, "Pins", Adv3DMeshes.pine(snow), buckets["pine"]["xf"], buckets["pine"]["cl"], foliage)
	_multi(root, "Feuillus", Adv3DMeshes.broadleaf(), buckets["round"]["xf"], buckets["round"]["cl"], foliage)
	_multi(root, "Bouleaux", Adv3DMeshes.birch(), buckets["birch"]["xf"], buckets["birch"]["cl"], foliage)
	_multi(root, "Palmiers", Adv3DMeshes.palm(), buckets["palm"]["xf"], buckets["palm"]["cl"], foliage)
	_multi(root, "Rochers", Adv3DMeshes.rock(warm), buckets["rock"]["xf"], buckets["rock"]["cl"], solid)
	_multi(root, "Cactus", Adv3DMeshes.cactus(), buckets["cactus"]["xf"], buckets["cactus"]["cl"], solid)
	_multi(root, "Souches", Adv3DMeshes.stump(), buckets["stump"]["xf"], buckets["stump"]["cl"], solid)
	_multi(root, "Cristaux", Adv3DMeshes.crystal(), buckets["crystal"]["xf"], buckets["crystal"]["cl"], solid)
	_multi(root, "Piliers", Adv3DMeshes.pillar(), buckets["pillar"]["xf"], buckets["pillar"]["cl"], solid)
	# Buissons : ceux de la carte + quelques-uns posés sur les bords de falaise (non bloquants).
	var bush_xf: Array = buckets["bush"]["xf"]
	var bush_cl: Array = buckets["bush"]["cl"]
	for c2: Vector2i in _edge_cells(t):
		if (t["obstacles"] as Dictionary).has(c2) or (t["paths"] as Dictionary).has(c2) or rng.randf() > 0.4:
			continue
		var p := Vector3((float(c2.x) + rng.randf_range(0.1, 0.9)) * CELL, 0.0, (float(c2.y) + rng.randf_range(0.1, 0.9)) * CELL)
		p.y = height_at(p.x, p.z)
		var sc: float = rng.randf_range(0.5, 0.85)
		bush_xf.append(_xf(p, rng.randf() * TAU, Vector3(sc, sc, sc)))
		bush_cl.append(Color(0.92, 0.92, 0.92))
	_multi(root, "Buissons", Adv3DMeshes.bush(), bush_xf, bush_cl, foliage)


## Cases praticables qui touchent le vide (bord de falaise).
static func _edge_cells(t: Dictionary) -> Array:
	var size: Vector2i = t["size"]
	var voids: Dictionary = t["voids"]
	var out: Array = []
	for cy: int in range(size.y):
		for cx: int in range(size.x):
			var c := Vector2i(cx, cy)
			if voids.has(c):
				continue
			for d: Vector2i in [Vector2i(0, -1), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(1, 0)]:
				var n: Vector2i = c + d
				if n.x < 0 or n.y < 0 or n.x >= size.x or n.y >= size.y or voids.has(n):
					out.append(c)
					break
	return out


# ── Décors de sol non bloquants (herbes, fleurs, champignons…) ──────────

static func _build_decor(root: Node3D, zone_id: String, t: Dictionary, biome: String) -> void:
	var size: Vector2i = t["size"]
	var rng := RandomNumberGenerator.new()
	rng.seed = absi(zone_id.hash()) + 311
	var tuft_xf: Array = []
	var tuft_cl: Array = []
	var flower_xf: Array = []
	var flower_cl: Array = []
	var mush_xf: Array = []
	var mush_cl: Array = []
	var pebble_xf: Array = []
	var pebble_cl: Array = []
	var dry: bool = biome == "Désert"
	var decor: Dictionary = t["decor"]
	var flower_cols: Array = [Color(0.95, 0.38, 0.45), Color(0.98, 0.86, 0.30), Color(0.96, 0.96, 0.92), Color(0.66, 0.52, 0.96), Color(0.98, 0.62, 0.30)]
	for cy: int in range(size.y):
		for cx: int in range(size.x):
			var c := Vector2i(cx, cy)
			if (t["voids"] as Dictionary).has(c) or (t["obstacles"] as Dictionary).has(c):
				continue
			var on_path: bool = (t["paths"] as Dictionary).has(c)
			var dens: float = _patch(float(cx) * 2.3 + 40.0, float(cy) * 2.3 + 40.0)
			var n_tufts: int = (0 if on_path else int(2.0 + dens * 5.0))
			if on_path and rng.randf() < 0.35:
				n_tufts = 1                              # brins sur le bord du sentier
			for i: int in range(n_tufts):
				var p := _rand_in_cell(rng, c)
				var sc: float = rng.randf_range(0.8, 1.5)
				tuft_xf.append(_xf(p, rng.randf() * TAU, Vector3(sc, sc * rng.randf_range(0.8, 1.3), sc)))
				var v: float = rng.randf_range(0.82, 1.0)
				tuft_cl.append(Color(1.0, 0.95, 0.65) * v if dry else Color(v, v, v))
			var kind: String = String(decor.get(c, "")).to_lower()
			if kind.contains("flower") or (not on_path and not dry and rng.randf() < 0.07):
				for k: int in range(rng.randi_range(3, 6)):
					var pf := _rand_in_cell(rng, c)
					var sf: float = rng.randf_range(0.8, 1.3)
					flower_xf.append(_xf(pf, rng.randf() * TAU, Vector3(sf, sf, sf)))
					flower_cl.append(flower_cols[(c.x * 3 + c.y) % flower_cols.size()] if k < 3 else flower_cols[rng.randi_range(0, flower_cols.size() - 1)])
			elif kind.contains("mushroom"):
				for k2: int in range(rng.randi_range(2, 4)):
					var pm := _rand_in_cell(rng, c)
					var sm: float = rng.randf_range(0.8, 1.6)
					mush_xf.append(_xf(pm, rng.randf() * TAU, Vector3(sm, sm, sm)))
					mush_cl.append(Color.WHITE)
			elif kind != "" and not kind.contains("flower") and not kind.contains("grass") and not kind.contains("reed"):
				# bois mort, os, gravats… : petits cailloux discrets
				for k3: int in range(rng.randi_range(2, 3)):
					var pp := _rand_in_cell(rng, c)
					var sp: float = rng.randf_range(0.18, 0.34)
					pebble_xf.append(_xf(pp + Vector3(0, 0.02, 0), rng.randf() * TAU, Vector3(sp, sp * 0.8, sp)))
					pebble_cl.append(Color(0.85, 0.85, 0.85))
	# Herbes en bordure de falaise : le bord paraît vivant plutôt que coupé au couteau.
	for ce: Vector2i in _edge_cells(t):
		for i2: int in range(3):
			var pe := _rand_in_cell(rng, ce)
			var se: float = rng.randf_range(1.0, 1.7)
			tuft_xf.append(_xf(pe, rng.randf() * TAU, Vector3(se, se, se)))
			tuft_cl.append(Color(0.95, 0.95, 0.95))
	var foliage: ShaderMaterial = Adv3DMeshes.foliage_material(0.5)
	_multi(root, "Herbes", Adv3DMeshes.tuft(), tuft_xf, tuft_cl, foliage)
	_multi(root, "Fleurs", Adv3DMeshes.flower(), flower_xf, flower_cl, Adv3DMeshes.foliage_material(0.7))
	_multi(root, "Champignons", Adv3DMeshes.mushroom(), mush_xf, mush_cl, Adv3DMeshes.solid_material(true))
	_multi(root, "Cailloux", Adv3DMeshes.rock(dry), pebble_xf, pebble_cl, Adv3DMeshes.solid_material(true))


static func _rand_in_cell(rng: RandomNumberGenerator, c: Vector2i) -> Vector3:
	var p := Vector3((float(c.x) + rng.randf_range(0.08, 0.92)) * CELL, 0.0, (float(c.y) + rng.randf_range(0.08, 0.92)) * CELL)
	p.y = height_at(p.x, p.z)
	return p


static func _xf(pos: Vector3, yaw: float, scl: Vector3) -> Transform3D:
	var b := Basis(Vector3.UP, yaw).scaled(scl)
	return Transform3D(b, pos)


static func _multi(parent: Node3D, node_name: String, mesh: Mesh, xforms: Array, colors: Array, mat: Material) -> void:
	if xforms.is_empty():
		return
	var mm := MultiMesh.new()
	mm.transform_format = MultiMesh.TRANSFORM_3D
	mm.use_colors = true
	mm.mesh = mesh
	mm.instance_count = xforms.size()
	for i: int in range(xforms.size()):
		mm.set_instance_transform(i, xforms[i])
		mm.set_instance_color(i, colors[i])
	var mmi := MultiMeshInstance3D.new()
	mmi.name = node_name
	mmi.multimesh = mm
	mmi.material_override = mat
	mmi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	parent.add_child(mmi)


# ══════════════════════════════════════════════════════════════════════
#  Ciel : nuages qui dérivent autour et sous l'île
# ══════════════════════════════════════════════════════════════════════

## Nuages (MeshInstance3D) autour de l'île ; chacun porte meta « speed » (m/s) pour la dérive.
static func make_clouds(size: Vector2i, seed_v: int) -> Node3D:
	var root := Node3D.new()
	root.name = "Nuages"
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_v
	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.vertex_color_use_as_albedo = true
	mat.vertex_color_is_srgb = true
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.albedo_color = Color(1, 1, 1, 0.92)
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	var w: float = float(size.x) * CELL
	var d: float = float(size.y) * CELL
	for i: int in range(18):
		var m := MeshInstance3D.new()
		m.mesh = Adv3DMeshes.cloud()
		m.material_override = mat
		var below: bool = i < 12
		var x: float = rng.randf_range(-w * 0.7, w * 1.7)
		var z: float = rng.randf_range(-d * 0.7, d * 1.7)
		var y: float = rng.randf_range(-16.0, -7.0) if below else rng.randf_range(16.0, 30.0)
		# les nuages du dessus restent à distance de l'île pour ne jamais gêner la vue
		if not below:
			if x > -w * 0.1 and x < w * 1.1 and z > -d * 0.1 and z < d * 1.1:
				x += w * 1.6
		m.position = Vector3(x, y, z)
		var sc: float = rng.randf_range(1.2, 2.6)
		m.scale = Vector3(sc, sc * 0.8, sc)
		m.rotation.y = rng.randf() * TAU
		m.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		m.set_meta("speed", rng.randf_range(0.35, 0.9))
		root.add_child(m)
	root.set_meta("min_x", -w * 0.9)
	root.set_meta("max_x", w * 1.9)
	return root


# ══════════════════════════════════════════════════════════════════════
#  Îlots flottants lointains (décor du ciel)
# ══════════════════════════════════════════════════════════════════════

## Quelques îlots à l'horizon ; chacun porte meta « base_y » / « phase » pour flotter doucement.
static func make_islets(size: Vector2i, biome: String, seed_v: int) -> Node3D:
	var root := Node3D.new()
	root.name = "Ilots"
	var pal: Dictionary = palette(biome)
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_v + 99
	var w: float = float(size.x) * CELL
	var d: float = float(size.y) * CELL
	var top: Color = (pal["ground"] as Array)[0]
	var rock: Color = (pal["cliff_top"] as Color).lerp(pal["cliff_bot"], 0.2)
	var mat: StandardMaterial3D = Adv3DMeshes.solid_material(true)
	var foliage: ShaderMaterial = Adv3DMeshes.foliage_material(0.12)
	var count: int = 9
	for i: int in range(count):
		var ang: float = float(i) / float(count) * TAU + rng.randf_range(-0.2, 0.2)
		var dist: float = maxf(w, d) * rng.randf_range(0.85, 1.25) + 18.0
		var n := Node3D.new()
		var cx: float = w * 0.5 + cos(ang) * dist
		var cz: float = d * 0.5 + sin(ang) * dist
		var by: float = rng.randf_range(-6.0, 9.0)
		n.position = Vector3(cx, by, cz)
		var sc: float = rng.randf_range(3.5, 8.0)
		n.scale = Vector3(sc, sc, sc)
		n.rotation.y = rng.randf() * TAU
		var body := MeshInstance3D.new()
		body.mesh = Adv3DMeshes.islet(top, rock)
		body.material_override = mat
		n.add_child(body)
		# un arbre (ou un cactus / pin) sur la plupart des îlots
		if rng.randf() < 0.8:
			var tree := MeshInstance3D.new()
			if biome == "Désert":
				tree.mesh = Adv3DMeshes.cactus()
				tree.material_override = mat
			elif biome == "Montagne":
				tree.mesh = Adv3DMeshes.pine(true)
				tree.material_override = foliage
			else:
				tree.mesh = Adv3DMeshes.broadleaf() if rng.randf() < 0.6 else Adv3DMeshes.birch()
				tree.material_override = foliage
			tree.position = Vector3(rng.randf_range(-0.3, 0.3), 0.2, rng.randf_range(-0.3, 0.3))
			tree.scale = Vector3.ONE * 0.22
			n.add_child(tree)
		n.set_meta("base_y", by)
		n.set_meta("phase", rng.randf() * TAU)
		root.add_child(n)
	return root
