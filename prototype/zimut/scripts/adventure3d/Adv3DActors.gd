class_name Adv3DActors
extends RefCounted
## Adv3DActors.gd — Personnages et marqueurs du monde 3D (V61) : l'explorateur (le joueur),
## les groupes de monstres, les lieux (un style par type) et les portes entre cartes.
## Tout est généré en code, low-poly à couleurs de sommets (voir Adv3DMeshes).

const POI_COLORS := {
	"combat": Color(0.90, 0.28, 0.22), "chest": Color(0.96, 0.78, 0.25), "puzzle": Color(0.62, 0.42, 0.90),
	"camp": Color(0.35, 0.80, 0.45), "reveal": Color(0.40, 0.75, 0.95), "exit": Color(0.30, 0.82, 0.78),
}

static var _cache: Dictionary = {}


# ── Aides ──────────────────────────────────────────────────────────────

static func _st() -> SurfaceTool:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	return st


static func _rng(s: int) -> RandomNumberGenerator:
	var r := RandomNumberGenerator.new()
	r.seed = s
	return r


static func _part(parent: Node3D, mesh: Mesh, pos: Vector3 = Vector3.ZERO, nm: String = "") -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.mesh = mesh
	mi.material_override = Adv3DMeshes.solid_material(true)
	mi.position = pos
	if nm != "":
		mi.name = nm
	parent.add_child(mi)
	return mi


static func _cached(key: String, f: Callable) -> Mesh:
	if not _cache.has(key):
		_cache[key] = f.call()
	return _cache[key]


static func _glow(col: Color, energy: float = 1.6) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.specular_mode = BaseMaterial3D.SPECULAR_DISABLED   # évite les taches noires (NaN) sur GPU mobiles
	m.albedo_color = col
	m.emission_enabled = true
	m.emission = col
	m.emission_energy_multiplier = energy
	m.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	return m


static func _label(text: String, y: float, size_px: int = 40, col: Color = Color(1, 1, 1)) -> Label3D:
	var l := Label3D.new()
	l.text = text
	l.position = Vector3(0, y, 0)
	l.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	l.font_size = size_px
	l.pixel_size = 0.011
	l.outline_size = 12
	l.modulate = col
	l.no_depth_test = true
	l.render_priority = 5
	return l


static func _particles(col: Color, amount: int, life: float, vel: float, grav: Vector3, size: float) -> CPUParticles3D:
	var p := CPUParticles3D.new()
	p.amount = amount
	p.lifetime = life
	p.direction = Vector3.UP
	p.spread = 25.0
	p.initial_velocity_min = vel * 0.6
	p.initial_velocity_max = vel
	p.gravity = grav
	p.scale_amount_min = size * 0.6
	p.scale_amount_max = size
	var sm := SphereMesh.new()
	sm.radius = 0.5
	sm.height = 1.0
	sm.radial_segments = 4
	sm.rings = 2
	p.mesh = sm
	p.material_override = _glow(col, 1.2)
	p.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return p


static func add_shadow(parent: Node3D, radius: float) -> void:
	_shadow(parent, radius)


## Poussière de pas (désactivée par défaut ; l'appelant active « emitting » en marchant).
static func make_dust() -> CPUParticles3D:
	var dust := _particles(Color(0.85, 0.78, 0.62), 10, 0.55, 0.7, Vector3(0, 0.2, 0), 0.16)
	dust.position = Vector3(0, 0.08, -0.12)
	dust.emitting = false
	dust.spread = 60.0
	return dust


static func _shadow(parent: Node3D, radius: float) -> void:
	var s := MeshInstance3D.new()
	s.mesh = Adv3DMeshes.shadow_mesh()
	s.material_override = Adv3DMeshes.shadow_material()
	s.scale = Vector3(radius, 1.0, radius)
	s.position.y = 0.07
	s.name = "Shadow"
	parent.add_child(s)


# ══════════════════════════════════════════════════════════════════════
#  Explorateur (le joueur lui-même, pas un héros)
# ══════════════════════════════════════════════════════════════════════

## Aventurier à chapeau, manteau, écharpe et sac à dos. Nœuds animés : LegL/LegR (hanches),
## ArmL/ArmR (épaules), Body (rebond), Dust (poussière quand il marche).
static func make_explorer() -> Node3D:
	var n := Node3D.new()
	var rng := _rng(11)
	_shadow(n, 0.55)
	var body := Node3D.new()
	body.name = "Body"
	n.add_child(body)
	# Torse : manteau évasé.
	var coat := _cached("ex_coat", func() -> Mesh:
		var st := _st()
		Adv3DMeshes.add_cone(st, Vector3(0, 0.55, 0), 0.34, 0.24, 0.62, 8, Color(0.50, 0.27, 0.15), Color(0.72, 0.42, 0.22), _rng(1), 0.0, false)
		Adv3DMeshes.add_cone(st, Vector3(0, 0.50, 0), 0.31, 0.31, 0.07, 8, Color(0.27, 0.17, 0.10), Color(0.27, 0.17, 0.10), _rng(2), 0.0, false)  # ceinture
		return st.commit())
	_part(body, coat)
	# Écharpe rouge + nœud.
	var scarf := _cached("ex_scarf", func() -> Mesh:
		var st := _st()
		Adv3DMeshes.add_cone(st, Vector3(0, 1.12, 0), 0.25, 0.2, 0.12, 8, Color(0.80, 0.18, 0.18), Color(0.92, 0.30, 0.25), _rng(3), 0.0, false)
		Adv3DMeshes.add_blob(st, Vector3(0.12, 1.02, 0.2), Vector3(0.06, 0.14, 0.04), 6, 4, Color(0.70, 0.14, 0.14), Color(0.86, 0.24, 0.20), _rng(13), 0.0)
		return st.commit())
	_part(body, scarf)
	# Tête : visage, cheveux, yeux.
	var head := _cached("ex_head", func() -> Mesh:
		var st := _st()
		Adv3DMeshes.add_blob(st, Vector3(0, 1.4, 0), Vector3(0.25, 0.26, 0.25), 12, 8, Color(0.88, 0.66, 0.50), Color(0.97, 0.78, 0.62), _rng(4), 0.0)
		Adv3DMeshes.add_blob(st, Vector3(0, 1.47, -0.07), Vector3(0.27, 0.23, 0.22), 10, 6, Color(0.22, 0.14, 0.10), Color(0.34, 0.22, 0.14), _rng(5), 0.01)
		Adv3DMeshes.add_blob(st, Vector3(0.09, 1.42, 0.23), Vector3(0.036, 0.045, 0.02), 6, 4, Color(0.08, 0.06, 0.06), Color(0.14, 0.1, 0.1), _rng(14), 0.0)
		Adv3DMeshes.add_blob(st, Vector3(-0.09, 1.42, 0.23), Vector3(0.036, 0.045, 0.02), 6, 4, Color(0.08, 0.06, 0.06), Color(0.14, 0.1, 0.1), _rng(15), 0.0)
		Adv3DMeshes.add_blob(st, Vector3(0, 1.38, 0.25), Vector3(0.035, 0.03, 0.03), 6, 4, Color(0.92, 0.62, 0.48), Color(0.98, 0.72, 0.58), _rng(19), 0.0)   # nez
		for sx: float in [-1.0, 1.0]:
			Adv3DMeshes.add_blob(st, Vector3(0.15 * sx, 1.34, 0.19), Vector3(0.05, 0.03, 0.02), 6, 3, Color(0.95, 0.55, 0.50), Color(0.98, 0.62, 0.56), _rng(20), 0.0)   # joues
			Adv3DMeshes.add_blob(st, Vector3(0.09 * sx, 1.425, 0.245), Vector3(0.012, 0.016, 0.01), 4, 3, Color(1, 1, 1), Color(1, 1, 1), _rng(21), 0.0)   # reflet des yeux
		return st.commit())
	_part(body, head)
	# Chapeau d'explorateur à large bord et ruban.
	var hat := _cached("ex_hat", func() -> Mesh:
		var st := _st()
		Adv3DMeshes.add_cone(st, Vector3(0, 1.62, 0), 0.46, 0.42, 0.05, 14, Color(0.40, 0.27, 0.15), Color(0.52, 0.36, 0.20), _rng(6), 0.0)
		Adv3DMeshes.add_cone(st, Vector3(0, 1.66, 0), 0.26, 0.2, 0.22, 12, Color(0.46, 0.31, 0.17), Color(0.58, 0.41, 0.23), _rng(7), 0.0)
		Adv3DMeshes.add_cone(st, Vector3(0, 1.67, 0), 0.265, 0.265, 0.05, 12, Color(0.78, 0.20, 0.18), Color(0.78, 0.20, 0.18), _rng(8), 0.0, false)
		return st.commit())
	_part(body, hat)
	# Écharpe flottante (animée par l'explorateur).
	var tail := Node3D.new()
	tail.name = "ScarfTail"
	tail.position = Vector3(-0.1, 1.08, -0.2)
	body.add_child(tail)
	var tm := _cached("ex_tail", func() -> Mesh:
		var st := _st()
		Adv3DMeshes.add_blob(st, Vector3(0, 0, -0.17), Vector3(0.07, 0.035, 0.22), 6, 4, Color(0.70, 0.14, 0.14), Color(0.92, 0.30, 0.25), _rng(22), 0.0)
		Adv3DMeshes.add_blob(st, Vector3(0, 0, -0.42), Vector3(0.06, 0.03, 0.14), 6, 4, Color(0.66, 0.12, 0.12), Color(0.88, 0.26, 0.22), _rng(23), 0.0)
		return st.commit())
	_part(tail, tm)
	# Sac à dos + rouleau de couchage.
	var pack := _cached("ex_pack", func() -> Mesh:
		var st := _st()
		Adv3DMeshes.add_blob(st, Vector3(0, 0.88, -0.27), Vector3(0.2, 0.25, 0.13), 10, 6, Color(0.24, 0.36, 0.22), Color(0.36, 0.52, 0.31), _rng(16), 0.0)
		Adv3DMeshes.add_blob(st, Vector3(0, 1.16, -0.3), Vector3(0.23, 0.07, 0.09), 10, 4, Color(0.70, 0.62, 0.40), Color(0.84, 0.76, 0.52), _rng(17), 0.0)
		return st.commit())
	_part(body, pack)
	# Bras (pivot à l'épaule).
	for sgn: float in [-1.0, 1.0]:
		var arm := Node3D.new()
		arm.name = "Arm%s" % ("L" if sgn < 0.0 else "R")
		arm.position = Vector3(0.29 * sgn, 1.08, 0)
		body.add_child(arm)
		var am := _cached("ex_arm", func() -> Mesh:
			var st := _st()
			Adv3DMeshes.add_cone(st, Vector3(0, -0.34, 0), 0.07, 0.085, 0.34, 6, Color(0.50, 0.27, 0.15), Color(0.68, 0.40, 0.21), _rng(9), 0.0)
			Adv3DMeshes.add_blob(st, Vector3(0, -0.4, 0), Vector3(0.075, 0.075, 0.075), 6, 4, Color(0.88, 0.66, 0.50), Color(0.97, 0.78, 0.62), _rng(10), 0.0)
			return st.commit())
		_part(arm, am)
		if sgn > 0.0:
			# lanterne tenue à la main droite
			var lan := MeshInstance3D.new()
			var ls := SphereMesh.new()
			ls.radius = 0.07
			ls.height = 0.14
			ls.radial_segments = 6
			ls.rings = 3
			lan.mesh = ls
			lan.material_override = _glow(Color(1.0, 0.82, 0.4), 2.2)
			lan.position = Vector3(0.0, -0.58, 0.04)
			arm.add_child(lan)
			var ll := OmniLight3D.new()
			ll.light_color = Color(1.0, 0.85, 0.5)
			ll.omni_range = 3.2
			ll.light_energy = 0.55
			ll.position = Vector3(0.0, -0.58, 0.04)
			arm.add_child(ll)
	# Jambes (pivot à la hanche) avec bottes.
	for sgn2: float in [-1.0, 1.0]:
		var leg := Node3D.new()
		leg.name = "Leg%s" % ("L" if sgn2 < 0.0 else "R")
		leg.position = Vector3(0.12 * sgn2, 0.56, 0)
		n.add_child(leg)
		var lm := _cached("ex_leg", func() -> Mesh:
			var st := _st()
			Adv3DMeshes.add_cone(st, Vector3(0, -0.4, 0), 0.085, 0.1, 0.4, 6, Color(0.20, 0.22, 0.32), Color(0.30, 0.33, 0.46), _rng(12), 0.0, false)
			Adv3DMeshes.add_blob(st, Vector3(0, -0.5, 0.05), Vector3(0.1, 0.08, 0.15), 8, 5, Color(0.18, 0.11, 0.07), Color(0.34, 0.22, 0.13), _rng(18), 0.0)
			return st.commit())
		_part(leg, lm)
	# Poussière aux pieds (activée par Adv3DExplorer quand il marche).
	var dust := _particles(Color(0.85, 0.78, 0.62), 10, 0.55, 0.7, Vector3(0, 0.2, 0), 0.16)
	dust.name = "Dust"
	dust.position = Vector3(0, 0.08, -0.12)
	dust.emitting = false
	dust.spread = 60.0
	n.add_child(dust)
	return n


# ══════════════════════════════════════════════════════════════════════
#  Lieux : un décor distinct par type
# ══════════════════════════════════════════════════════════════════════

static func _stone_ring(st: SurfaceTool, r: float, h: float, count: int) -> void:
	for i: int in range(count):
		var a: float = float(i) / float(count) * TAU
		var p := Vector3(cos(a) * r, 0.0, sin(a) * r)
		Adv3DMeshes.add_blob(st, p + Vector3(0, h * 0.5, 0), Vector3(0.22, h, 0.22), 6, 4, Color(0.40, 0.40, 0.42), Color(0.66, 0.66, 0.68), _rng(40 + i), 0.02)


## Marqueur de lieu. Nœuds animés par Adventure3D : « Gem » (flotte/tourne), « Pulse » (anneau).
static func make_poi_marker(kind: String, title: String, done: bool) -> Node3D:
	var col: Color = POI_COLORS.get(kind, Color(0.9, 0.9, 0.9))
	var shown: Color = col.darkened(0.5) if done else col
	var n := Node3D.new()
	_shadow(n, 1.0)
	var base := _cached("poi_base_%s" % kind, func() -> Mesh:
		var st := _st()
		Adv3DMeshes.add_cone(st, Vector3(0, 0, 0), 1.0, 0.85, 0.16, 10, Color(0.42, 0.40, 0.38), Color(0.64, 0.62, 0.58), _rng(20), 0.0)
		match kind:
			"camp":
				_stone_ring(st, 0.5, 0.2, 7)
				for i: int in range(3):
					var a: float = float(i) / 3.0 * TAU
					Adv3DMeshes.add_box(st, Vector3(cos(a) * 0.18, 0.28, sin(a) * 0.18), Vector3(0.09, 0.09, 0.5), Color(0.35, 0.22, 0.12), Color(0.5, 0.33, 0.18))
			"chest":
				Adv3DMeshes.add_box(st, Vector3(0, 0.42, 0), Vector3(0.78, 0.4, 0.5), Color(0.40, 0.24, 0.12), Color(0.58, 0.36, 0.18))
				Adv3DMeshes.add_blob(st, Vector3(0, 0.62, 0), Vector3(0.4, 0.2, 0.26), 8, 3, Color(0.50, 0.30, 0.15), Color(0.68, 0.43, 0.22), _rng(21), 0.0)
				Adv3DMeshes.add_box(st, Vector3(0, 0.5, 0.26), Vector3(0.12, 0.2, 0.04), Color(0.95, 0.78, 0.25), Color(1.0, 0.88, 0.4))
			"puzzle":
				for i2: int in range(3):
					var a2: float = float(i2) / 3.0 * TAU
					Adv3DMeshes.add_cone(st, Vector3(cos(a2) * 0.55, 0.14, sin(a2) * 0.55), 0.14, 0.1, 1.1 + float(i2) * 0.15, 5, Color(0.36, 0.32, 0.46), Color(0.58, 0.52, 0.72), _rng(30 + i2), 0.02)
			"reveal":
				Adv3DMeshes.add_cone(st, Vector3(0, 0.14, 0), 0.22, 0.12, 1.1, 6, Color(0.36, 0.40, 0.48), Color(0.62, 0.68, 0.78), _rng(35), 0.02)
				Adv3DMeshes.add_cone(st, Vector3(0, 1.24, 0), 0.32, 0.0, 0.0001, 6, Color(0.6, 0.7, 0.9), Color(0.6, 0.7, 0.9), _rng(36), 0.0, false)
			"exit":
				_stone_ring(st, 0.62, 0.9, 6)
			_:
				for sgn: float in [-1.0, 1.0]:
					Adv3DMeshes.add_cone(st, Vector3(0.55 * sgn, 0.14, 0), 0.1, 0.08, 1.2, 5, Color(0.30, 0.26, 0.24), Color(0.48, 0.42, 0.38), _rng(37), 0.01)
		return st.commit())
	_part(n, base)
	# Cœur lumineux (flamme de camp, gemme…).
	var gem := MeshInstance3D.new()
	gem.name = "Gem"
	var sph := SphereMesh.new()
	sph.radius = 0.3
	sph.height = 0.7 if kind != "camp" else 0.9
	sph.radial_segments = 5
	sph.rings = 3
	gem.mesh = sph
	gem.material_override = _glow(shown, 0.6 if done else 1.8)
	gem.position.y = 0.55 if kind == "camp" else (1.45 if kind != "chest" else 1.2)
	n.add_child(gem)
	if not done:
		var ring := MeshInstance3D.new()
		ring.name = "Pulse"
		var tm := TorusMesh.new()
		tm.inner_radius = 0.92
		tm.outer_radius = 1.0
		tm.rings = 24
		tm.ring_segments = 4
		ring.mesh = tm
		ring.material_override = _glow(shown, 1.2)
		ring.position.y = 0.12
		n.add_child(ring)
		var light := OmniLight3D.new()
		light.light_color = shown
		light.omni_range = 4.5
		light.light_energy = 0.9
		light.position.y = 1.0
		n.add_child(light)
		var sp := _particles(shown.lightened(0.3), 8, 1.4, 0.9, Vector3(0, 0.2, 0), 0.09)
		sp.position.y = 0.4
		sp.spread = 12.0
		n.add_child(sp)
	n.add_child(_label(title, 2.4, 34, Color(0.78, 0.78, 0.78) if done else Color(1, 1, 1)))
	return n


# ══════════════════════════════════════════════════════════════════════
#  Portes entre cartes
# ══════════════════════════════════════════════════════════════════════

static func make_gate(dir: String, title: String, open: bool) -> Node3D:
	var n := Node3D.new()
	var col: Color = Color(0.40, 0.88, 0.68) if open else Color(0.88, 0.36, 0.30)
	var along_x: bool = dir == "N" or dir == "S"
	var arch := _cached("gate_arch", func() -> Mesh:
		var st := _st()
		for sgn: float in [-1.0, 1.0]:
			Adv3DMeshes.add_box(st, Vector3(1.1 * sgn, 1.3, 0), Vector3(0.5, 2.6, 0.5), Color(0.42, 0.40, 0.38), Color(0.66, 0.64, 0.60))
			Adv3DMeshes.add_box(st, Vector3(1.1 * sgn, 0.12, 0), Vector3(0.72, 0.24, 0.72), Color(0.36, 0.34, 0.32), Color(0.52, 0.50, 0.46))
			Adv3DMeshes.add_box(st, Vector3(1.1 * sgn, 2.7, 0), Vector3(0.66, 0.16, 0.66), Color(0.5, 0.48, 0.44), Color(0.72, 0.70, 0.66))
		Adv3DMeshes.add_box(st, Vector3(0, 2.62, 0), Vector3(2.9, 0.4, 0.5), Color(0.46, 0.44, 0.40), Color(0.68, 0.66, 0.62))
		return st.commit())
	var pivot := Node3D.new()
	pivot.rotation.y = 0.0 if along_x else PI * 0.5
	n.add_child(pivot)
	_part(pivot, arch)
	# Voile d'énergie : translucide, vert si ouvert, rouge sinon.
	var veil := MeshInstance3D.new()
	veil.name = "Veil"
	var qm := QuadMesh.new()
	qm.size = Vector2(1.9, 2.4)
	veil.mesh = qm
	var vm := StandardMaterial3D.new()
	vm.specular_mode = BaseMaterial3D.SPECULAR_DISABLED   # évite les taches noires (NaN) sur GPU mobiles
	vm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	vm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	vm.albedo_color = Color(col.r, col.g, col.b, 0.35 if open else 0.22)
	vm.cull_mode = BaseMaterial3D.CULL_DISABLED
	veil.material_override = vm
	veil.position = Vector3(0, 1.3, 0)
	pivot.add_child(veil)
	var light := OmniLight3D.new()
	light.light_color = col
	light.omni_range = 4.0
	light.light_energy = 0.8
	light.position.y = 1.4
	n.add_child(light)
	if open:
		var sp := _particles(col.lightened(0.3), 12, 1.6, 0.8, Vector3(0, 0.1, 0), 0.08)
		sp.position.y = 0.3
		sp.spread = 20.0
		n.add_child(sp)
	if not open:
		# route gardée : planches clouées en croix dans l'arche + écriteau
		var bars := _cached("gate_bars", func() -> Mesh:
			var st := _st()
			var wd := Color(0.36, 0.22, 0.12)
			var wl := Color(0.58, 0.38, 0.20)
			for k: float in [0.58, -0.58]:
				var ax := Vector3(0.88, k * 1.05, 0.0)          # demi-longueur de la planche, en diagonale
				var ay := Vector3(-k, 0.88, 0.0).normalized() * 0.11
				_obox(st, Vector3(0, 1.3, k * 0.03), ax, ay, Vector3(0, 0, 0.05), wd, wl)
			Adv3DMeshes.add_box(st, Vector3(0, 1.3, 0.08), Vector3(0.62, 0.42, 0.06), Color(0.45, 0.30, 0.16), Color(0.70, 0.50, 0.28))   # écriteau
			Adv3DMeshes.add_box(st, Vector3(0, 1.3, 0.115), Vector3(0.12, 0.16, 0.02), Color(0.75, 0.22, 0.18), Color(0.9, 0.3, 0.25))   # cadenas
			return st.commit())
		_part(pivot, bars)
		var lb := _label("➜ " + title, 3.55, 34, col.lightened(0.3))
		n.add_child(lb)
		n.add_child(_label("route fermée", 3.12, 26, Color(1.0, 0.82, 0.72)))
		return n
	n.add_child(_label("➜ " + title, 3.3, 34, col.lightened(0.3)))
	return n


## Boîte orientée (demi-axes ax, ay, az) : planches en diagonale.
static func _obox(st: SurfaceTool, c: Vector3, ax: Vector3, ay: Vector3, az: Vector3, col_d: Color, col_l: Color) -> void:
	var v: Array[Vector3] = []
	for sx: float in [-1.0, 1.0]:
		for sy: float in [-1.0, 1.0]:
			for sz: float in [-1.0, 1.0]:
				v.append(c + ax * sx + ay * sy + az * sz)
	for f: Array in [[0, 1, 3, 2], [4, 6, 7, 5], [0, 4, 5, 1], [2, 3, 7, 6], [0, 2, 6, 4], [1, 5, 7, 3]]:
		var k0: Color = col_d if v[f[0]].y < c.y else col_l
		var k1: Color = col_d if v[f[1]].y < c.y else col_l
		var k2: Color = col_d if v[f[2]].y < c.y else col_l
		var k3: Color = col_d if v[f[3]].y < c.y else col_l
		Adv3DMeshes._tri(st, v[f[0]], v[f[1]], v[f[2]], k0, k1, k2, c)
		Adv3DMeshes._tri(st, v[f[0]], v[f[2]], v[f[3]], k0, k2, k3, c)


# ══════════════════════════════════════════════════════════════════════
#  Groupes de monstres
# ══════════════════════════════════════════════════════════════════════

## Petits gobelins à oreilles pointues, yeux jaunes et gourdin ; l'élite est plus grande, rouge, cornue.
## Teinte des créatures selon la Nation (multipliée aux couleurs du modèle).
const MOB_TINT := {"Ombres": Color(0.78, 0.62, 1.0), "Brasier": Color(1.0, 0.62, 0.50), "Cristaux": Color(0.72, 0.82, 1.0),
	"Brumes": Color(0.78, 0.96, 0.92), "Marées": Color(0.70, 0.94, 1.0), "Rouages": Color(1.0, 0.86, 0.62), "Donjon": Color(0.82, 0.80, 0.88),
	"Vents": Color(0.92, 1.0, 1.0)}


static var _glow_mat: ShaderMaterial = null


static func _mob_glow() -> ShaderMaterial:
	if _glow_mat == null:
		_glow_mat = Adv3DNationMeshes.glow_material(2.4)
	return _glow_mat


static func make_mob_group(g: Dictionary, title: String, biome: String = "") -> Node3D:
	var n := Node3D.new()
	var elite: bool = bool(g.get("elite", false))
	var count: int = clampi(int(g.get("count", 3)), 1, 6)
	var sc: float = 1.4 if elite else 1.0
	var key: String = "mob_%s" % elite
	var skin_b: Color = Color(0.58, 0.16, 0.14) if elite else Color(0.34, 0.50, 0.20)
	var skin_t: Color = Color(0.82, 0.28, 0.22) if elite else Color(0.56, 0.74, 0.32)
	var mesh := _cached(key, func() -> Mesh:
		var st := _st()
		var r := _rng(60)
		Adv3DMeshes.add_blob(st, Vector3(0, 0.38, 0), Vector3(0.26, 0.3, 0.24), 8, 5, skin_b, skin_t, r, 0.01)               # corps
		Adv3DMeshes.add_blob(st, Vector3(0, 0.8, 0.02), Vector3(0.22, 0.2, 0.21), 8, 5, skin_b.lightened(0.1), skin_t.lightened(0.1), r, 0.01)   # tête
		for sgn: float in [-1.0, 1.0]:
			Adv3DMeshes.add_cone(st, Vector3(0.2 * sgn, 0.84, 0), 0.07, 0.0, 0.3, 4, skin_b, skin_t, r, 0.0, false)          # oreilles
			Adv3DMeshes.add_blob(st, Vector3(0.08 * sgn, 0.84, 0.2), Vector3(0.04, 0.03, 0.02), 6, 4, Color(1.0, 0.9, 0.2), Color(1.0, 0.95, 0.4), r, 0.0)
			Adv3DMeshes.add_cone(st, Vector3(0.13 * sgn, 0.0, 0.02), 0.07, 0.08, 0.16, 5, Color(0.2, 0.13, 0.08), Color(0.3, 0.2, 0.12), r, 0.0)  # pieds
		Adv3DMeshes.add_box(st, Vector3(0, 0.74, 0.215), Vector3(0.16, 0.03, 0.02), Color(0.12, 0.05, 0.05), Color(0.12, 0.05, 0.05))   # bouche
		Adv3DMeshes.add_cone(st, Vector3(0.3, 0.1, 0.1), 0.05, 0.09, 0.7, 5, Color(0.40, 0.26, 0.14), Color(0.54, 0.38, 0.2), r, 0.01)  # gourdin
		if elite:
			for sgn2: float in [-1.0, 1.0]:
				Adv3DMeshes.add_cone(st, Vector3(0.1 * sgn2, 0.95, 0), 0.05, 0.0, 0.24, 4, Color(0.9, 0.85, 0.7), Color(1.0, 0.97, 0.85), r, 0.0, false)  # cornes
		return st.commit())
	_shadow(n, 0.8 * sc + 0.15 * float(count))
	for i: int in range(count):
		var ang: float = float(i) / float(count) * TAU
		var m := Node3D.new()
		m.name = "Mob%d" % i
		m.position = Vector3(cos(ang), 0.0, sin(ang)) * (0.0 if count == 1 else 0.62 * sc)
		m.rotation.y = -ang + PI * 0.5
		m.scale = Vector3(sc, sc, sc)
		m.set_meta("phase", float(i) * 1.3)
		var nation_mesh: Mesh = Adv3DMobMeshes.mesh_for(biome, elite)
		if nation_mesh != null:
			# créature propre à la Nation (golem de cristal, crabe, harpie, diablotin de lave…)
			var mi2 := MeshInstance3D.new()
			mi2.mesh = nation_mesh
			mi2.material_override = _mob_glow()
			mi2.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
			if Adv3DMobMeshes.floats(biome):
				mi2.position.y = 0.22
			m.add_child(mi2)
		else:
			var mi: MeshInstance3D = _part(m, mesh)
			if MOB_TINT.has(biome):
				(mi.material_override as StandardMaterial3D).albedo_color = MOB_TINT[biome]
		n.add_child(m)
	if elite:
		var light := OmniLight3D.new()
		light.light_color = Color(1.0, 0.3, 0.2)
		if Adv3DMobMeshes.has(biome):
			# aura de l'élite aux couleurs de sa Nation (pas de rouge qui dénature le modèle)
			light.light_color = (Nations.info(biome).get("accent", Color(1.0, 0.85, 0.6)) as Color).lerp(Color.WHITE, 0.25)
			light.light_energy = 0.45
		light.omni_range = 3.5
		light.light_energy = 0.7
		light.position.y = 1.0
		n.add_child(light)
	n.add_child(_label("%s · niv %d" % [title, int(g.get("level", 1))], 1.9 * sc + 0.2, 32, Color(1.0, 0.82, 0.78) if elite else Color(1, 1, 1)))
	return n
