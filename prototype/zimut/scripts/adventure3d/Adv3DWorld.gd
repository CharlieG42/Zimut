class_name Adv3DWorld
extends RefCounted
## Adv3DWorld.gd — Monde 3D low-poly d'une carte d'Aventure (V60, bêta).
##
## Génère, à partir du terrain DÉJÀ utilisé par la carte classique (AdventureTerrain :
## cases, obstacles, sentiers, portes, lieux), une île 3D flottante : même monde, vu au sol.
## Rien n'est importé : tout est construit en code (légèreté Android, style low-poly).
##
## Repère : la case (cx, cy) de la grille occupe [cx·CELL, (cx+1)·CELL] sur X et
## [cy·CELL, (cy+1)·CELL] sur Z. L'axe Y est la hauteur.

const CELL := 3.0
const SKIRT := 3.2                 # profondeur de la falaise sous l'île
const OBSTACLE_RADIUS := 0.95      # rayon bloquant d'un arbre / rocher (< demi-case : les cases restent reliées)
const HEIGHT_AMPLITUDE := 0.42

## Couleurs par biome (les Nations sans palette propre reprennent celle de la Forêt).
const PALETTES := {
	"Forêt": {
		"ground": [Color(0.29, 0.51, 0.22), Color(0.34, 0.57, 0.25), Color(0.26, 0.46, 0.21)],
		"path": Color(0.62, 0.49, 0.31), "cliff_top": Color(0.45, 0.33, 0.22), "cliff_bot": Color(0.20, 0.15, 0.12),
		"sky_top": Color(0.30, 0.55, 0.82), "sky_hor": Color(0.80, 0.89, 0.92), "fog": Color(0.76, 0.86, 0.88),
		"sun": Color(1.0, 0.95, 0.82),
	},
	"Montagne": {
		"ground": [Color(0.55, 0.57, 0.60), Color(0.62, 0.64, 0.67), Color(0.82, 0.86, 0.90)],
		"path": Color(0.45, 0.42, 0.40), "cliff_top": Color(0.40, 0.42, 0.46), "cliff_bot": Color(0.16, 0.17, 0.20),
		"sky_top": Color(0.40, 0.58, 0.82), "sky_hor": Color(0.86, 0.90, 0.95), "fog": Color(0.84, 0.88, 0.93),
		"sun": Color(0.95, 0.97, 1.0),
	},
	"Désert": {
		"ground": [Color(0.86, 0.72, 0.45), Color(0.90, 0.77, 0.50), Color(0.82, 0.66, 0.40)],
		"path": Color(0.72, 0.55, 0.34), "cliff_top": Color(0.66, 0.46, 0.28), "cliff_bot": Color(0.30, 0.20, 0.13),
		"sky_top": Color(0.38, 0.62, 0.88), "sky_hor": Color(0.96, 0.88, 0.74), "fog": Color(0.95, 0.86, 0.70),
		"sun": Color(1.0, 0.92, 0.75),
	},
}

## Couleur des marqueurs de lieux, par type (POI).
const POI_COLORS := {
	"combat": Color(0.90, 0.28, 0.22), "chest": Color(0.96, 0.78, 0.25), "puzzle": Color(0.62, 0.42, 0.90),
	"camp": Color(0.35, 0.80, 0.45), "reveal": Color(0.40, 0.75, 0.95), "exit": Color(0.30, 0.82, 0.78),
}

static var _noise: FastNoiseLite = null


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
		_noise.frequency = 0.16
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


# ══════════════════════════════════════════════════════════════════════
#  Construction de la carte
# ══════════════════════════════════════════════════════════════════════

## Racine 3D de la zone : sol, falaises, arbres/rochers, décors de sol.
static func build(zone_id: String) -> Node3D:
	var t: Dictionary = AdventureTerrain.zone_terrain(zone_id)
	var biome: String = String(t["biome"])
	var pal: Dictionary = palette(biome)
	var root := Node3D.new()
	root.name = "ZoneWorld"
	root.add_child(_build_ground(zone_id, t, pal))
	_build_obstacles(root, zone_id, t, biome)
	_build_decor(root, zone_id, t)
	return root


static func _build_ground(zone_id: String, t: Dictionary, pal: Dictionary) -> MeshInstance3D:
	var size: Vector2i = t["size"]
	var voids: Dictionary = t["voids"]
	var paths: Dictionary = t["paths"]
	var rng := RandomNumberGenerator.new()
	rng.seed = absi(zone_id.hash()) + 77
	var ground_cols: Array = pal["ground"]
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
			var col: Color = pal["path"] if paths.has(c) else ground_cols[rng.randi_range(0, ground_cols.size() - 1)]
			col = col.lightened(rng.randf_range(-0.04, 0.05))
			var x0: float = float(cx) * CELL
			var x1: float = float(cx + 1) * CELL
			var z0: float = float(cy) * CELL
			var z1: float = float(cy + 1) * CELL
			var a := Vector3(x0, corner_h(cx, cy), z0)
			var b := Vector3(x1, corner_h(cx + 1, cy), z0)
			var d := Vector3(x1, corner_h(cx + 1, cy + 1), z1)
			var e := Vector3(x0, corner_h(cx, cy + 1), z1)
			# Dessus : deux triangles à normales distinctes → facettes low-poly.
			_tri(st, a, b, d, col)
			_tri(st, a, d, e, col.darkened(0.04))
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
				_skirt(st, p0, p1, o, pal)
	var mi := MeshInstance3D.new()
	mi.name = "Ground"
	mi.mesh = st.commit()
	var mat := StandardMaterial3D.new()
	mat.vertex_color_use_as_albedo = true
	mat.roughness = 1.0
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	mi.material_override = mat
	return mi


## Triangle à normale plate (le sens de la normale est forcé vers le haut).
static func _tri(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3, col: Color) -> void:
	var n: Vector3 = (c - a).cross(b - a).normalized()
	if n.y < 0.0:
		n = -n
	for v: Vector3 in [a, b, c]:
		st.set_color(col)
		st.set_normal(n)
		st.add_vertex(v)


## Pan de falaise sous l'arête p0-p1, dégradé du brun clair vers le sombre.
static func _skirt(st: SurfaceTool, p0: Vector3, p1: Vector3, outward: Vector3, pal: Dictionary) -> void:
	var top: Color = pal["cliff_top"]
	var bot: Color = pal["cliff_bot"]
	var q0 := Vector3(p0.x, -SKIRT, p0.z)
	var q1 := Vector3(p1.x, -SKIRT, p1.z)
	var verts: Array = [[p0, top], [p1, top], [q1, bot], [p0, top], [q1, bot], [q0, bot]]
	for e: Array in verts:
		st.set_color(e[1])
		st.set_normal(outward)
		st.add_vertex(e[0])


# ── Arbres, rochers, cactus (MultiMesh : un seul appel de rendu par type) ──

static func _kind_category(kind: String) -> String:
	var k: String = kind.to_lower()
	if k.contains("pine") or k.contains("sapin"):
		return "cone"
	if k.contains("cactus"):
		return "cactus"
	if k.contains("palm"):
		return "palm"
	if k.contains("rock") or k.contains("stone") or k.contains("pillar") or k.contains("crystal") \
			or k.contains("rubble") or k.contains("crate") or k.contains("jar") or k.contains("column"):
		return "rock"
	if k.contains("hedge") or k.contains("bush") or k.contains("stump") or k.contains("thorn"):
		return "bush"
	return "round"


static func _build_obstacles(root: Node3D, zone_id: String, t: Dictionary, biome: String) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = absi(zone_id.hash()) + 913
	var buckets: Dictionary = {"cone": [], "round": [], "rock": [], "bush": [], "cactus": [], "palm": []}
	for c: Vector2i in (t["obstacles"] as Dictionary).keys():
		var cat: String = _kind_category(String(t["obstacles"][c]))
		var ctr := Vector3((float(c.x) + 0.5) * CELL + rng.randf_range(-0.25, 0.25), 0.0, (float(c.y) + 0.5) * CELL + rng.randf_range(-0.25, 0.25))
		ctr.y = height_at(ctr.x, ctr.z)
		(buckets[cat] as Array).append({"pos": ctr, "rot": rng.randf() * TAU, "s": rng.randf_range(0.85, 1.3), "v": rng.randf()})
	# Troncs (arbres à feuillage, pins, palmiers) + couronnes
	var trunk_mesh := CylinderMesh.new()
	trunk_mesh.top_radius = 0.10
	trunk_mesh.bottom_radius = 0.17
	trunk_mesh.height = 1.0
	trunk_mesh.radial_segments = 5
	trunk_mesh.rings = 1
	var trunk_items: Array = []
	var cone_mesh := CylinderMesh.new()
	cone_mesh.top_radius = 0.0
	cone_mesh.bottom_radius = 0.95
	cone_mesh.height = 2.2
	cone_mesh.radial_segments = 6
	cone_mesh.rings = 1
	var round_mesh := SphereMesh.new()
	round_mesh.radius = 0.95
	round_mesh.height = 1.7
	round_mesh.radial_segments = 6
	round_mesh.rings = 3
	var rock_mesh := SphereMesh.new()
	rock_mesh.radius = 0.8
	rock_mesh.height = 1.2
	rock_mesh.radial_segments = 5
	rock_mesh.rings = 3
	var bush_mesh := SphereMesh.new()
	bush_mesh.radius = 0.62
	bush_mesh.height = 0.9
	bush_mesh.radial_segments = 6
	bush_mesh.rings = 3
	var cactus_mesh := CapsuleMesh.new()
	cactus_mesh.radius = 0.24
	cactus_mesh.height = 1.7
	cactus_mesh.radial_segments = 6
	cactus_mesh.rings = 2
	var leaf_cols: Array = [Color(0.22, 0.46, 0.20), Color(0.28, 0.54, 0.24), Color(0.20, 0.40, 0.22)]
	var pine_cols: Array = [Color(0.14, 0.34, 0.24), Color(0.18, 0.40, 0.28)]
	if biome == "Montagne":
		pine_cols = [Color(0.16, 0.32, 0.30), Color(0.74, 0.82, 0.86)]
	var dry_cols: Array = [Color(0.40, 0.55, 0.26), Color(0.52, 0.58, 0.30)]
	var trunk_col := Color(0.42, 0.29, 0.18)
	var rock_cols: Array = [Color(0.52, 0.50, 0.48), Color(0.60, 0.58, 0.54), Color(0.46, 0.45, 0.46)]
	var round_xf: Array = []
	var round_cl: Array = []
	var cone_xf: Array = []
	var cone_cl: Array = []
	var rock_xf: Array = []
	var rock_cl: Array = []
	var bush_xf: Array = []
	var bush_cl: Array = []
	var cactus_xf: Array = []
	var cactus_cl: Array = []
	var trunk_xf: Array = []
	var trunk_cl: Array = []
	for it: Dictionary in buckets["round"]:
		var s: float = it["s"]
		trunk_xf.append(_xf(it["pos"] + Vector3(0, 0.5 * s * 1.1, 0), it["rot"], Vector3(s, 1.1 * s, s)))
		trunk_cl.append(trunk_col)
		round_xf.append(_xf(it["pos"] + Vector3(0, 1.55 * s, 0), it["rot"], Vector3(s, s, s)))
		round_cl.append(dry_cols[int(float(it["v"]) * dry_cols.size()) % dry_cols.size()] if biome == "Désert" else leaf_cols[int(float(it["v"]) * 3.0) % 3])
	for it2: Dictionary in buckets["cone"]:
		var s2: float = it2["s"]
		trunk_xf.append(_xf(it2["pos"] + Vector3(0, 0.45 * s2, 0), it2["rot"], Vector3(s2, 0.9 * s2, s2)))
		trunk_cl.append(trunk_col)
		cone_xf.append(_xf(it2["pos"] + Vector3(0, 1.9 * s2, 0), it2["rot"], Vector3(s2, s2, s2)))
		cone_cl.append(pine_cols[int(float(it2["v"]) * pine_cols.size()) % pine_cols.size()])
	for it3: Dictionary in buckets["palm"]:
		var s3: float = it3["s"]
		trunk_xf.append(_xf(it3["pos"] + Vector3(0, 0.9 * s3, 0), it3["rot"], Vector3(0.9 * s3, 1.8 * s3, 0.9 * s3)))
		trunk_cl.append(trunk_col.lightened(0.15))
		round_xf.append(_xf(it3["pos"] + Vector3(0, 1.95 * s3, 0), it3["rot"], Vector3(1.1 * s3, 0.45 * s3, 1.1 * s3)))
		round_cl.append(Color(0.36, 0.58, 0.28))
	for it4: Dictionary in buckets["rock"]:
		var s4: float = it4["s"]
		rock_xf.append(_xf(it4["pos"] + Vector3(0, 0.35 * s4, 0), it4["rot"], Vector3(s4 * 1.1, s4 * (0.8 + float(it4["v"]) * 0.7), s4)))
		rock_cl.append(rock_cols[int(float(it4["v"]) * 3.0) % 3])
	for it5: Dictionary in buckets["bush"]:
		var s5: float = it5["s"]
		bush_xf.append(_xf(it5["pos"] + Vector3(0, 0.3 * s5, 0), it5["rot"], Vector3(s5 * 1.2, s5, s5 * 1.2)))
		bush_cl.append(leaf_cols[int(float(it5["v"]) * 3.0) % 3].darkened(0.1))
	for it6: Dictionary in buckets["cactus"]:
		var s6: float = it6["s"]
		cactus_xf.append(_xf(it6["pos"] + Vector3(0, 0.85 * s6, 0), it6["rot"], Vector3(s6, s6, s6)))
		cactus_cl.append(Color(0.30, 0.52, 0.30))
	_multi(root, "Troncs", trunk_mesh, trunk_xf, trunk_cl)
	_multi(root, "Feuillages", round_mesh, round_xf, round_cl)
	_multi(root, "Pins", cone_mesh, cone_xf, cone_cl)
	_multi(root, "Rochers", rock_mesh, rock_xf, rock_cl)
	_multi(root, "Buissons", bush_mesh, bush_xf, bush_cl)
	_multi(root, "Cactus", cactus_mesh, cactus_xf, cactus_cl)


# ── Décors de sol non bloquants (herbes, fleurs, champignons…) ──────────

static func _build_decor(root: Node3D, zone_id: String, t: Dictionary) -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = absi(zone_id.hash()) + 311
	var tuft_mesh := CylinderMesh.new()
	tuft_mesh.top_radius = 0.0
	tuft_mesh.bottom_radius = 0.10
	tuft_mesh.height = 0.38
	tuft_mesh.radial_segments = 4
	tuft_mesh.rings = 1
	var dot_mesh := SphereMesh.new()
	dot_mesh.radius = 0.10
	dot_mesh.height = 0.20
	dot_mesh.radial_segments = 5
	dot_mesh.rings = 2
	var tuft_xf: Array = []
	var tuft_cl: Array = []
	var dot_xf: Array = []
	var dot_cl: Array = []
	for c: Vector2i in (t["decor"] as Dictionary).keys():
		var kind: String = String(t["decor"][c]).to_lower()
		for i: int in range(3):
			var p := Vector3((float(c.x) + rng.randf_range(0.18, 0.82)) * CELL, 0.0, (float(c.y) + rng.randf_range(0.18, 0.82)) * CELL)
			p.y = height_at(p.x, p.z)
			if kind.contains("flower"):
				dot_xf.append(_xf(p + Vector3(0, 0.12, 0), 0.0, Vector3.ONE))
				dot_cl.append([Color(0.95, 0.40, 0.45), Color(0.98, 0.85, 0.30), Color(0.95, 0.95, 0.90), Color(0.65, 0.50, 0.95)][rng.randi_range(0, 3)])
			elif kind.contains("mushroom"):
				dot_xf.append(_xf(p + Vector3(0, 0.10, 0), 0.0, Vector3(1.3, 1.0, 1.3)))
				dot_cl.append(Color(0.85, 0.25, 0.22))
			elif kind.contains("grass") or kind.contains("reed"):
				tuft_xf.append(_xf(p + Vector3(0, 0.19, 0), rng.randf() * TAU, Vector3.ONE * rng.randf_range(0.8, 1.5)))
				tuft_cl.append(Color(0.34, 0.56, 0.24) if not kind.contains("dry") else Color(0.68, 0.60, 0.34))
			else:
				dot_xf.append(_xf(p + Vector3(0, 0.07, 0), rng.randf() * TAU, Vector3(1.2, 0.7, 1.0)))
				dot_cl.append(Color(0.62, 0.60, 0.56))
	_multi(root, "HerbesDecor", tuft_mesh, tuft_xf, tuft_cl)
	_multi(root, "PetitsDecors", dot_mesh, dot_xf, dot_cl)


static func _xf(pos: Vector3, yaw: float, scl: Vector3) -> Transform3D:
	var b := Basis(Vector3.UP, yaw).scaled(scl)
	return Transform3D(b, pos)


static func _multi(parent: Node3D, node_name: String, mesh: Mesh, xforms: Array, colors: Array) -> void:
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
	var mat := StandardMaterial3D.new()
	mat.vertex_color_use_as_albedo = true
	mat.roughness = 0.95
	var mmi := MultiMeshInstance3D.new()
	mmi.name = node_name
	mmi.multimesh = mm
	mmi.material_override = mat
	parent.add_child(mmi)


# ══════════════════════════════════════════════════════════════════════
#  Éléments de jeu : marqueurs de lieux, portes, groupes de monstres, explorateur
# ══════════════════════════════════════════════════════════════════════

static func _mat(col: Color, emissive: float = 0.0) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = col
	m.roughness = 0.9
	if emissive > 0.0:
		m.emission_enabled = true
		m.emission = col
		m.emission_energy_multiplier = emissive
	return m


static func _label(text: String, y: float, size_px: int = 40, col: Color = Color(1, 1, 1)) -> Label3D:
	var l := Label3D.new()
	l.text = text
	l.position = Vector3(0, y, 0)
	l.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	l.font_size = size_px
	l.pixel_size = 0.011
	l.outline_size = 10
	l.modulate = col
	l.no_depth_test = true
	return l


## Marqueur de lieu : socle de pierre, cristal lumineux, nom flottant.
static func make_poi_marker(kind: String, title: String, done: bool) -> Node3D:
	var col: Color = POI_COLORS.get(kind, Color(0.9, 0.9, 0.9))
	if done:
		col = col.darkened(0.55)
	var n := Node3D.new()
	var base := MeshInstance3D.new()
	var cyl := CylinderMesh.new()
	cyl.top_radius = 0.55
	cyl.bottom_radius = 0.7
	cyl.height = 0.35
	cyl.radial_segments = 8
	base.mesh = cyl
	base.material_override = _mat(Color(0.52, 0.50, 0.48))
	base.position.y = 0.17
	n.add_child(base)
	var gem := MeshInstance3D.new()
	var sph := SphereMesh.new()
	sph.radius = 0.38
	sph.height = 0.9
	sph.radial_segments = 4
	sph.rings = 2
	gem.mesh = sph
	gem.material_override = _mat(col, 0.0 if done else 1.6)
	gem.position.y = 1.15
	gem.name = "Gem"
	n.add_child(gem)
	n.add_child(_label(title, 2.15, 34, Color(0.8, 0.8, 0.8) if done else Color(1, 1, 1)))
	return n


## Porte vers une carte voisine : arche de pierre orientée selon le bord de l'île.
static func make_gate(dir: String, title: String, open: bool) -> Node3D:
	var n := Node3D.new()
	var col: Color = Color(0.40, 0.85, 0.65) if open else Color(0.85, 0.35, 0.30)
	var along_x: bool = dir == "N" or dir == "S"     # les piliers s'écartent le long de l'axe du bord
	var off: Vector3 = Vector3(1.05, 0, 0) if along_x else Vector3(0, 0, 1.05)
	for sgn: float in [-1.0, 1.0]:
		var pil := MeshInstance3D.new()
		var box := BoxMesh.new()
		box.size = Vector3(0.45, 2.4, 0.45)
		pil.mesh = box
		pil.material_override = _mat(Color(0.55, 0.52, 0.48))
		pil.position = off * sgn + Vector3(0, 1.2, 0)
		n.add_child(pil)
	var lintel := MeshInstance3D.new()
	var lb := BoxMesh.new()
	lb.size = Vector3(2.9, 0.4, 0.5) if along_x else Vector3(0.5, 0.4, 2.9)
	lintel.mesh = lb
	lintel.material_override = _mat(col, 1.2)
	lintel.position = Vector3(0, 2.5, 0)
	n.add_child(lintel)
	n.add_child(_label("➜ " + title, 3.2, 34, col.lightened(0.3)))
	return n


## Groupe de monstres : petits « gobelins » low-poly (nombre = effectif du groupe).
static func make_mob_group(g: Dictionary, title: String) -> Node3D:
	var n := Node3D.new()
	var elite: bool = bool(g.get("elite", false))
	var count: int = clampi(int(g.get("count", 3)), 1, 6)
	var skin: Color = Color(0.78, 0.30, 0.25) if elite else Color(0.52, 0.66, 0.30)
	var sc: float = 1.35 if elite else 1.0
	for i: int in range(count):
		var ang: float = float(i) / float(count) * TAU
		var m := Node3D.new()
		m.position = Vector3(cos(ang), 0.0, sin(ang)) * (0.0 if count == 1 else 0.62 * sc)
		m.rotation.y = -ang + PI * 0.5
		var body := MeshInstance3D.new()
		var cap := CapsuleMesh.new()
		cap.radius = 0.24 * sc
		cap.height = 0.85 * sc
		cap.radial_segments = 6
		cap.rings = 2
		body.mesh = cap
		body.material_override = _mat(skin)
		body.position.y = 0.45 * sc
		m.add_child(body)
		for sgn: float in [-1.0, 1.0]:
			var eye := MeshInstance3D.new()
			var es := SphereMesh.new()
			es.radius = 0.05 * sc
			es.height = 0.10 * sc
			es.radial_segments = 4
			es.rings = 2
			eye.mesh = es
			eye.material_override = _mat(Color(1.0, 0.9, 0.2), 1.0)
			eye.position = Vector3(0.09 * sc * sgn, 0.72 * sc, 0.2 * sc)
			m.add_child(eye)
		n.add_child(m)
	n.add_child(_label("%s · niv %d" % [title, int(g.get("level", 1))], 1.9 * sc, 32, Color(1.0, 0.82, 0.78) if elite else Color(1, 1, 1)))
	return n


## Explorateur (le joueur lui-même, pas un héros) : silhouette low-poly vectorielle.
static func make_explorer() -> Node3D:
	var n := Node3D.new()
	var coat := _mat(Color(0.62, 0.36, 0.20))
	var skin := _mat(Color(0.90, 0.72, 0.56))
	var hat := _mat(Color(0.36, 0.25, 0.16))
	var pack := _mat(Color(0.30, 0.42, 0.28))
	var legs := _mat(Color(0.26, 0.28, 0.36))
	var torso := MeshInstance3D.new()
	var cap := CapsuleMesh.new()
	cap.radius = 0.27
	cap.height = 0.95
	cap.radial_segments = 8
	cap.rings = 3
	torso.mesh = cap
	torso.material_override = coat
	torso.position.y = 0.95
	torso.name = "Torso"
	n.add_child(torso)
	for sgn: float in [-1.0, 1.0]:
		var leg := MeshInstance3D.new()
		var lb := BoxMesh.new()
		lb.size = Vector3(0.18, 0.55, 0.20)
		leg.mesh = lb
		leg.material_override = legs
		leg.position = Vector3(0.12 * sgn, 0.28, 0)
		leg.name = "Leg%s" % ("L" if sgn < 0.0 else "R")
		n.add_child(leg)
	var head := MeshInstance3D.new()
	var hs := SphereMesh.new()
	hs.radius = 0.2
	hs.height = 0.4
	hs.radial_segments = 8
	hs.rings = 4
	head.mesh = hs
	head.material_override = skin
	head.position.y = 1.62
	n.add_child(head)
	var brim := MeshInstance3D.new()
	var bc := CylinderMesh.new()
	bc.top_radius = 0.34
	bc.bottom_radius = 0.34
	bc.height = 0.04
	bc.radial_segments = 10
	brim.mesh = bc
	brim.material_override = hat
	brim.position.y = 1.74
	n.add_child(brim)
	var crown := MeshInstance3D.new()
	var cc := CylinderMesh.new()
	cc.top_radius = 0.17
	cc.bottom_radius = 0.21
	cc.height = 0.2
	cc.radial_segments = 8
	crown.mesh = cc
	crown.material_override = hat
	crown.position.y = 1.84
	n.add_child(crown)
	var bag := MeshInstance3D.new()
	var bb := BoxMesh.new()
	bb.size = Vector3(0.42, 0.55, 0.22)
	bag.mesh = bb
	bag.material_override = pack
	bag.position = Vector3(0, 1.0, -0.3)
	n.add_child(bag)
	return n
