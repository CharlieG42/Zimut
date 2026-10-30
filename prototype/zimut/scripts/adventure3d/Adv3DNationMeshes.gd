class_name Adv3DNationMeshes
extends RefCounted
## Adv3DNationMeshes.gd — Décors 3D propres à chaque Nation (obstacles et décors de sol) pour le
## monde d'Aventure 3D. Mêmes clés que Nations.DATA (obs_tree, obs_rock, props) et AdventureTerrain,
## donc la carte classique et la 3D montrent les mêmes lieux.
##
## Lueurs : un sommet dont la couleur a un alpha à 0 « brille » (émission) avec glow_material() —
## pointes de cristaux, fissures de lave, chapeaux phosphorescents, runes, fenêtres de forge…
## Tout est mis en cache et rendu en MultiMesh par Adv3DWorld (un appel de rendu par type).

const GLOW_SHADER := """
shader_type spatial;
render_mode cull_disabled, specular_disabled;
// Couleurs de sommets (sRGB) ; alpha du sommet = 0 → la couleur devient lumineuse.
uniform float glow = 2.2;
uniform float fade_near = 1.0;
uniform float fade_far = 2.6;
float bayer4(vec2 p) {
	ivec2 q = ivec2(mod(p, 4.0));
	int i = q.x + q.y * 4;
	int m[16] = int[16](0, 8, 2, 10, 12, 4, 14, 6, 3, 11, 1, 9, 15, 7, 13, 5);
	return (float(m[i]) + 0.5) / 16.0;
}
void fragment() {
	float dist = length(VERTEX);
	if (dist < fade_far) {
		float a = clamp((dist - fade_near) / (fade_far - fade_near), 0.0, 1.0);
		if (a < bayer4(FRAGCOORD.xy)) {
			discard;
		}
	}
	ALBEDO = pow(clamp(COLOR.rgb, vec3(0.0), vec3(1.0)), vec3(2.2));
	EMISSION = ALBEDO * (1.0 - clamp(COLOR.a, 0.0, 1.0)) * glow;
	ROUGHNESS = 0.9;
}
"""

static var _shader: Shader = null


## Matériau des décors de Nation (avec lueurs).
static func glow_material(strength: float = 2.2) -> ShaderMaterial:
	if _shader == null:
		_shader = Shader.new()
		_shader.code = GLOW_SHADER
	var m := ShaderMaterial.new()
	m.shader = _shader
	m.set_shader_parameter("glow", strength)
	return m


## Clés gérées ici (obstacles et décors de sol des Nations).
const KINDS := ["amethyst_spire", "crystal_rock", "tide_rock", "wind_totem", "cloud_rock", "charred_tree", "lava_rock",
	"dead_tree", "mushroom_big", "dark_spire", "gravestone", "gear_tower", "scrap_pile",
	"glow_orb", "fog_puff", "cloud_puff", "shell_big", "coral", "driftwood", "bones", "smoke_vent", "thorn_bush",
	"stalagmite", "feather_banner"]

## Rayon de l'ombre au sol par clé (1.0 par défaut).
const SHADOW := {"amethyst_spire": 0.9, "crystal_rock": 1.0, "tide_rock": 1.1, "wind_totem": 0.55, "cloud_rock": 1.1,
	"charred_tree": 0.9, "lava_rock": 1.05, "dead_tree": 0.9, "mushroom_big": 1.15, "dark_spire": 0.7, "gravestone": 0.6,
	"gear_tower": 0.85, "scrap_pile": 0.95}


static func has(kind: String) -> bool:
	return kind in KINDS


## Mesh d'une clé de décor de Nation (null si inconnue).
static func mesh_for(kind: String) -> Mesh:
	match kind:
		"amethyst_spire": return Adv3DMeshes._cached("n_amethyst", _amethyst_spire)
		"crystal_rock": return Adv3DMeshes._cached("n_crystal_rock", _crystal_rock)
		"tide_rock": return Adv3DMeshes._cached("n_tide_rock", _tide_rock)
		"wind_totem": return Adv3DMeshes._cached("n_wind_totem", _wind_totem)
		"cloud_rock": return Adv3DMeshes._cached("n_cloud_rock", _cloud_rock)
		"charred_tree": return Adv3DMeshes._cached("n_charred", _charred_tree)
		"lava_rock": return Adv3DMeshes._cached("n_lava_rock", _lava_rock)
		"dead_tree": return Adv3DMeshes._cached("n_dead_tree", _dead_tree)
		"mushroom_big": return Adv3DMeshes._cached("n_mushroom_big", _mushroom_big)
		"dark_spire": return Adv3DMeshes._cached("n_dark_spire", _dark_spire)
		"gravestone": return Adv3DMeshes._cached("n_gravestone", _gravestone)
		"gear_tower": return Adv3DMeshes._cached("n_gear_tower", _gear_tower)
		"scrap_pile": return Adv3DMeshes._cached("n_scrap", _scrap_pile)
		"glow_orb": return Adv3DMeshes._cached("n_shards", _shards)
		"fog_puff": return Adv3DMeshes._cached("n_glowcaps", _glowcaps)
		"cloud_puff": return Adv3DMeshes._cached("n_cloud_puff", _cloud_puff)
		"shell_big": return Adv3DMeshes._cached("n_shell", _shell)
		"coral": return Adv3DMeshes._cached("n_coral", _coral)
		"driftwood": return Adv3DMeshes._cached("n_driftwood", _driftwood)
		"bones": return Adv3DMeshes._cached("n_bones", _bones)
		"smoke_vent": return Adv3DMeshes._cached("n_vent", _smoke_vent)
		"thorn_bush": return Adv3DMeshes._cached("n_thorn", _thorn_bush)
		"stalagmite": return Adv3DMeshes._cached("n_stalagmite", _stalagmite)
		"feather_banner": return Adv3DMeshes._cached("n_banner", _feather_banner)
	return null


## Brin d'herbe neutre (gris clair → blanc) : teinté par la couleur d'instance (herbe orange du Brasier,
## bleutée des Cristaux, violette des Ombres…).
static func tuft_neutral() -> Mesh:
	return Adv3DMeshes._cached("n_tuft", func() -> Mesh:
		var st := Adv3DMeshes._begin()
		var rng := Adv3DMeshes._rng(79)
		for i: int in range(5):
			var a: float = rng.randf() * TAU
			var r: float = rng.randf_range(0.0, 0.10)
			var base := Vector3(cos(a) * r, 0, sin(a) * r)
			var lean := Vector3(cos(a), 0, sin(a)) * rng.randf_range(0.04, 0.16)
			Adv3DMeshes.add_blade(st, base, base + lean + Vector3(0, rng.randf_range(0.30, 0.52), 0), 0.11, Color(0.55, 0.55, 0.55), Color(1, 1, 1))
		return st.commit())


# ══════════════════════════════════════════════════════════════════════
#  Outils : prisme / pointe orienté (facettes plates)
# ══════════════════════════════════════════════════════════════════════

## Prisme à `segs` faces de `base` dans la direction `dir`, terminé par une pointe sur `tip` (fraction de la longueur).
static func _spike(st: SurfaceTool, base: Vector3, dir: Vector3, r: float, length: float, tip: float, segs: int,
		cb: Color, ct: Color, cpeak: Color, r_top: float = -1.0) -> void:
	var d: Vector3 = dir.normalized()
	var side: Vector3 = d.cross(Vector3.UP if absf(d.y) < 0.95 else Vector3.RIGHT).normalized()
	var up2: Vector3 = side.cross(d).normalized()
	var rt: float = r if r_top < 0.0 else r_top
	var p1: Vector3 = base + d * length * (1.0 - tip)
	var peak: Vector3 = base + d * length
	var center: Vector3 = base + d * length * 0.5
	var r0: Array[Vector3] = []
	var r1: Array[Vector3] = []
	for i: int in range(segs):
		var a: float = float(i) / float(segs) * TAU
		var o: Vector3 = side * cos(a) + up2 * sin(a)
		r0.append(base + o * r)
		r1.append(p1 + o * rt)
	for i: int in range(segs):
		var j: int = (i + 1) % segs
		Adv3DMeshes._tri(st, r0[i], r0[j], r1[j], cb, cb, ct, center)
		Adv3DMeshes._tri(st, r0[i], r1[j], r1[i], cb, ct, ct, center)
		if tip > 0.0:
			Adv3DMeshes._tri(st, r1[i], r1[j], peak, ct, ct, cpeak, center)
		else:
			Adv3DMeshes._tri(st, r1[i], r1[j], p1, ct, ct, ct, center)
		Adv3DMeshes._tri(st, r0[j], r0[i], base, cb, cb, cb, center)


static func _g(c: Color) -> Color:
	return Color(c.r, c.g, c.b, 0.0)      # sommet lumineux


# ══════════════════════════════════════════════════════════════════════
#  Cristaux
# ══════════════════════════════════════════════════════════════════════

static func _amethyst_spire() -> Mesh:
	Adv3DMeshes.smooth_mode = false
	var st := Adv3DMeshes._begin()
	var rng := Adv3DMeshes._rng(301)
	Adv3DMeshes.add_blob(st, Vector3(0, 0.18, 0), Vector3(0.85, 0.32, 0.75), 6, 3, Color(0.16, 0.13, 0.26), Color(0.34, 0.30, 0.48), rng, 0.12)
	var cb := Color(0.30, 0.18, 0.52)
	var ct := Color(0.66, 0.48, 0.96)
	for e: Array in [[Vector3(0, 0.2, 0), Vector3(0.05, 1, 0.02), 0.32, 2.7], [Vector3(0.35, 0.15, 0.15), Vector3(0.45, 1, 0.2), 0.22, 1.7],
			[Vector3(-0.3, 0.15, 0.2), Vector3(-0.4, 1, 0.3), 0.2, 1.5], [Vector3(0.05, 0.12, -0.38), Vector3(0.1, 1, -0.55), 0.18, 1.2],
			[Vector3(-0.15, 0.1, -0.1), Vector3(-0.6, 1, -0.3), 0.14, 0.9]]:
		_spike(st, e[0], e[1], e[2], e[3], 0.28, 6, cb, ct, _g(Color(0.92, 0.82, 1.0)))
	return st.commit()


static func _crystal_rock() -> Mesh:
	Adv3DMeshes.smooth_mode = false
	var st := Adv3DMeshes._begin()
	var rng := Adv3DMeshes._rng(303)
	Adv3DMeshes.add_blob(st, Vector3(0, 0.42, 0), Vector3(0.95, 0.68, 0.82), 6, 4, Color(0.16, 0.14, 0.26), Color(0.40, 0.36, 0.56), rng, 0.14)
	for e: Array in [[Vector3(0.3, 0.8, 0.2), Vector3(0.4, 1, 0.3), 0.14, 0.7], [Vector3(-0.35, 0.6, 0.35), Vector3(-0.6, 1, 0.4), 0.11, 0.55],
			[Vector3(0.1, 0.9, -0.3), Vector3(0.0, 1, -0.4), 0.12, 0.6]]:
		_spike(st, e[0], e[1], e[2], e[3], 0.3, 6, Color(0.24, 0.42, 0.70), Color(0.52, 0.86, 1.0), _g(Color(0.80, 0.97, 1.0)))
	return st.commit()


static func _shards() -> Mesh:
	Adv3DMeshes.smooth_mode = false
	var st := Adv3DMeshes._begin()
	for e: Array in [[Vector3(0, 0, 0), Vector3(0.1, 1, 0), 0.07, 0.42], [Vector3(0.14, 0, 0.06), Vector3(0.5, 1, 0.2), 0.05, 0.28],
			[Vector3(-0.12, 0, 0.08), Vector3(-0.4, 1, 0.3), 0.05, 0.24]]:
		_spike(st, e[0], e[1], e[2], e[3], 0.35, 5, Color(0.36, 0.30, 0.70), _g(Color(0.62, 0.80, 1.0)), _g(Color(0.95, 0.95, 1.0)))
	return st.commit()


# ══════════════════════════════════════════════════════════════════════
#  Marées
# ══════════════════════════════════════════════════════════════════════

static func _tide_rock() -> Mesh:
	Adv3DMeshes.smooth_mode = false
	var st := Adv3DMeshes._begin()
	var rng := Adv3DMeshes._rng(311)
	Adv3DMeshes.add_blob(st, Vector3(0, 0.45, 0), Vector3(1.0, 0.75, 0.85), 7, 4, Color(0.30, 0.36, 0.40), Color(0.66, 0.72, 0.74), rng, 0.12)
	Adv3DMeshes.add_blob(st, Vector3(0.85, 0.2, 0.35), Vector3(0.38, 0.28, 0.34), 5, 3, Color(0.30, 0.36, 0.40), Color(0.58, 0.64, 0.66), rng, 0.1)
	Adv3DMeshes.smooth_mode = true
	Adv3DMeshes.add_blob(st, Vector3(0, 0.08, 0), Vector3(1.08, 0.13, 0.93), 10, 3, Color(0.14, 0.34, 0.28), Color(0.24, 0.52, 0.40), rng, 0.04)   # algues
	for i: int in range(7):
		var a: float = rng.randf() * TAU
		var p := Vector3(cos(a) * 0.8, rng.randf_range(0.25, 0.75), sin(a) * 0.68)
		Adv3DMeshes.add_blob(st, p, Vector3(0.07, 0.05, 0.07), 5, 2, Color(0.82, 0.80, 0.74), Color(0.96, 0.95, 0.90), rng, 0.0)   # bernaches
	Adv3DMeshes.add_blob(st, Vector3(0.5, 0.95, 0.35), Vector3(0.13, 0.03, 0.13), 5, 2, Color(0.92, 0.42, 0.25), Color(1.0, 0.55, 0.32), rng, 0.0)   # étoile de mer
	return st.commit()


static func _shell() -> Mesh:
	var st := Adv3DMeshes._begin()
	var rng := Adv3DMeshes._rng(313)
	Adv3DMeshes.add_blob(st, Vector3(0, 0.08, 0), Vector3(0.24, 0.1, 0.2), 8, 3, Color(0.86, 0.66, 0.60), Color(1.0, 0.88, 0.82), rng, 0.0)
	Adv3DMeshes.add_blob(st, Vector3(0, 0.06, -0.18), Vector3(0.08, 0.06, 0.06), 6, 2, Color(0.86, 0.66, 0.60), Color(0.96, 0.82, 0.76), rng, 0.0)
	Adv3DMeshes.add_blob(st, Vector3(0.4, 0.05, 0.25), Vector3(0.12, 0.05, 0.1), 6, 2, Color(0.78, 0.82, 0.88), Color(0.96, 0.96, 1.0), rng, 0.0)
	return st.commit()


static func _coral() -> Mesh:
	var st := Adv3DMeshes._begin()
	Adv3DMeshes.smooth_mode = false
	var cb := Color(0.86, 0.36, 0.42)
	var ct := Color(1.0, 0.62, 0.55)
	_spike(st, Vector3.ZERO, Vector3(0, 1, 0), 0.06, 0.5, 0.0, 5, cb, ct, ct, 0.04)
	for e: Array in [[Vector3(0, 0.22, 0), Vector3(0.6, 1, 0.1), 0.35], [Vector3(0, 0.3, 0), Vector3(-0.5, 1, 0.3), 0.3], [Vector3(0, 0.15, 0), Vector3(0.1, 1, -0.7), 0.28]]:
		_spike(st, e[0], e[1], 0.04, e[2], 0.0, 5, cb, ct, ct, 0.03)
	var rng := Adv3DMeshes._rng(317)
	Adv3DMeshes.smooth_mode = true
	Adv3DMeshes.add_blob(st, Vector3(0.3, 0.1, 0.1), Vector3(0.14, 0.12, 0.14), 7, 3, Color(0.92, 0.66, 0.26), Color(1.0, 0.82, 0.42), rng, 0.02)
	return st.commit()


static func _driftwood() -> Mesh:
	Adv3DMeshes.smooth_mode = false
	var st := Adv3DMeshes._begin()
	_spike(st, Vector3(-0.55, 0.08, 0), Vector3(1, 0.05, 0.15), 0.09, 1.1, 0.0, 6, Color(0.46, 0.40, 0.34), Color(0.70, 0.64, 0.56), Color(0.70, 0.64, 0.56), 0.06)
	_spike(st, Vector3(0.1, 0.1, 0.02), Vector3(0.4, 0.5, 0.6), 0.04, 0.35, 0.0, 5, Color(0.46, 0.40, 0.34), Color(0.66, 0.60, 0.52), Color(0.66, 0.60, 0.52), 0.02)
	return st.commit()


# ══════════════════════════════════════════════════════════════════════
#  Vents
# ══════════════════════════════════════════════════════════════════════

static func _wind_totem() -> Mesh:
	var st := Adv3DMeshes._begin()
	var rng := Adv3DMeshes._rng(321)
	Adv3DMeshes.smooth_mode = false
	Adv3DMeshes.add_blob(st, Vector3(0, 0.12, 0), Vector3(0.5, 0.2, 0.45), 6, 3, Color(0.46, 0.50, 0.54), Color(0.72, 0.76, 0.78), rng, 0.08)
	Adv3DMeshes.smooth_mode = true
	Adv3DMeshes.add_cone(st, Vector3(0, 0.1, 0), 0.15, 0.12, 2.5, 7, Color(0.42, 0.30, 0.20), Color(0.62, 0.46, 0.30), rng, 0.0)
	var bands: Array = [[0.75, Color(0.30, 0.62, 0.70)], [1.2, Color(0.92, 0.94, 0.96)], [1.65, Color(0.30, 0.62, 0.70)]]
	for b: Array in bands:
		Adv3DMeshes.add_box(st, Vector3(0, b[0], 0), Vector3(0.36, 0.26, 0.36), (b[1] as Color).darkened(0.25), b[1])
	Adv3DMeshes.add_blob(st, Vector3(0, 2.35, 0), Vector3(0.22, 0.2, 0.22), 8, 4, Color(0.30, 0.62, 0.70), Color(0.70, 0.92, 0.96), rng, 0.0)
	for sx: float in [-1.0, 1.0]:
		Adv3DMeshes.add_blob(st, Vector3(0.42 * sx, 2.25, 0), Vector3(0.38, 0.1, 0.05), 8, 3, Color(0.82, 0.88, 0.94), Color(1, 1, 1), rng, 0.0)        # ailes
		Adv3DMeshes.add_blob(st, Vector3(0.36 * sx, 2.1, 0), Vector3(0.3, 0.08, 0.04), 8, 3, Color(0.70, 0.82, 0.90), Color(0.94, 0.98, 1.0), rng, 0.0)
	# rubans qui flottent au vent
	for i: int in range(3):
		var y: float = 1.95 - float(i) * 0.18
		var base := Vector3(0.12, y, 0)
		Adv3DMeshes.add_blade(st, base, base + Vector3(0.9, -0.12 - float(i) * 0.05, 0.2), 0.08, Color(0.92, 0.36, 0.30) if i == 1 else Color(0.96, 0.96, 1.0), Color(0.40, 0.75, 0.88))
		Adv3DMeshes.add_blade(st, base + Vector3(0, 0, 0.01), base + Vector3(0.9, -0.12 - float(i) * 0.05, 0.21), 0.08, Color(0.96, 0.96, 1.0), Color(0.40, 0.75, 0.88))
	return st.commit()


static func _cloud_rock() -> Mesh:
	var st := Adv3DMeshes._begin()
	var rng := Adv3DMeshes._rng(323)
	Adv3DMeshes.smooth_mode = false
	Adv3DMeshes.add_blob(st, Vector3(0, 0.3, 0), Vector3(0.9, 0.5, 0.78), 6, 3, Color(0.46, 0.52, 0.60), Color(0.74, 0.78, 0.84), rng, 0.12)
	Adv3DMeshes.smooth_mode = true
	Adv3DMeshes.add_blob(st, Vector3(0.1, 0.8, 0.05), Vector3(0.62, 0.36, 0.55), 10, 5, Color(0.86, 0.90, 0.96), Color(1, 1, 1), rng, 0.03)
	Adv3DMeshes.add_blob(st, Vector3(-0.42, 0.66, 0.2), Vector3(0.38, 0.26, 0.36), 8, 4, Color(0.86, 0.90, 0.96), Color(1, 1, 1), rng, 0.03)
	Adv3DMeshes.add_blob(st, Vector3(0.48, 0.62, -0.25), Vector3(0.34, 0.22, 0.3), 8, 4, Color(0.86, 0.90, 0.96), Color(1, 1, 1), rng, 0.03)
	return st.commit()


static func _cloud_puff() -> Mesh:
	var st := Adv3DMeshes._begin()
	var rng := Adv3DMeshes._rng(325)
	for e: Array in [[Vector3(0, 0.12, 0), 0.24], [Vector3(0.22, 0.09, 0.08), 0.16], [Vector3(-0.2, 0.08, -0.06), 0.15]]:
		var r: float = e[1]
		Adv3DMeshes.add_blob(st, e[0], Vector3(r, r * 0.7, r), 8, 4, Color(0.84, 0.90, 0.96), Color(1, 1, 1), rng, 0.0)
	return st.commit()


static func _feather_banner() -> Mesh:
	var st := Adv3DMeshes._begin()
	var rng := Adv3DMeshes._rng(327)
	Adv3DMeshes.add_cone(st, Vector3.ZERO, 0.04, 0.03, 1.0, 5, Color(0.42, 0.30, 0.20), Color(0.60, 0.44, 0.28), rng, 0.0)
	Adv3DMeshes.add_blade(st, Vector3(0.02, 0.95, 0), Vector3(0.5, 0.75, 0.05), 0.22, Color(0.30, 0.62, 0.70), Color(0.92, 0.96, 1.0))
	Adv3DMeshes.add_blade(st, Vector3(0.02, 0.95, 0.005), Vector3(0.5, 0.75, 0.055), 0.22, Color(0.92, 0.96, 1.0), Color(0.30, 0.62, 0.70))
	Adv3DMeshes.add_blob(st, Vector3(0, 1.02, 0), Vector3(0.05, 0.12, 0.02), 6, 3, Color(0.86, 0.90, 0.96), Color(1, 1, 1), rng, 0.0)   # plume
	return st.commit()


# ══════════════════════════════════════════════════════════════════════
#  Brasier
# ══════════════════════════════════════════════════════════════════════

static func _charred_tree() -> Mesh:
	Adv3DMeshes.smooth_mode = false
	var st := Adv3DMeshes._begin()
	var cb := Color(0.08, 0.06, 0.06)
	var ct := Color(0.24, 0.17, 0.15)
	_spike(st, Vector3(0, -0.05, 0), Vector3(0.08, 1, 0.04), 0.26, 2.3, 0.18, 6, cb, ct, ct, 0.13)
	for e: Array in [[Vector3(0.05, 1.3, 0), Vector3(0.9, 0.9, 0.2), 0.09, 0.9], [Vector3(0.0, 1.6, 0), Vector3(-0.8, 1, -0.3), 0.08, 0.8],
			[Vector3(0.05, 1.9, 0), Vector3(0.3, 1, -0.8), 0.06, 0.6], [Vector3(0, 0.9, 0), Vector3(-0.9, 0.5, 0.5), 0.07, 0.6]]:
		_spike(st, e[0], e[1], e[2], e[3], 0.3, 5, cb, ct, _g(Color(1.0, 0.45, 0.12)))     # bouts de branches rougeoyants
	# fissures de braise sur le tronc
	for i: int in range(5):
		var y: float = 0.3 + float(i) * 0.35
		var a: float = float(i) * 2.1
		var p := Vector3(cos(a) * 0.2, y, sin(a) * 0.2)
		_spike(st, p, Vector3(cos(a) * 0.3, 1, sin(a) * 0.3), 0.035, 0.22, 0.0, 4, _g(Color(1.0, 0.42, 0.08)), _g(Color(1.0, 0.7, 0.2)), _g(Color(1.0, 0.7, 0.2)))
	var rng := Adv3DMeshes._rng(331)
	Adv3DMeshes.add_blob(st, Vector3(0, 0.05, 0), Vector3(0.55, 0.12, 0.5), 6, 2, Color(0.10, 0.08, 0.08), Color(0.22, 0.16, 0.14), rng, 0.1)   # racines
	return st.commit()


static func _lava_rock() -> Mesh:
	Adv3DMeshes.smooth_mode = false
	var st := Adv3DMeshes._begin()
	var rng := Adv3DMeshes._rng(333)
	var cb := Color(0.07, 0.06, 0.06)
	var ct := Color(0.24, 0.19, 0.18)
	Adv3DMeshes.add_blob(st, Vector3(0, 0.42, 0), Vector3(1.0, 0.72, 0.85), 6, 4, cb, ct, rng, 0.16)
	Adv3DMeshes.add_blob(st, Vector3(0.9, 0.2, -0.3), Vector3(0.4, 0.3, 0.35), 5, 3, cb, ct, rng, 0.12)
	for i: int in range(6):                                        # veines de lave
		var a: float = float(i) / 6.0 * TAU + 0.3
		var p := Vector3(cos(a) * 0.82, 0.2 + float(i % 3) * 0.22, sin(a) * 0.7)
		_spike(st, p, Vector3(cos(a) * 0.2, 1, sin(a) * 0.2), 0.05, 0.5, 0.0, 4, _g(Color(1.0, 0.36, 0.06)), _g(Color(1.0, 0.62, 0.16)), _g(Color(1.0, 0.62, 0.16)))
	Adv3DMeshes.smooth_mode = true
	Adv3DMeshes.add_blob(st, Vector3(-0.75, 0.03, 0.55), Vector3(0.5, 0.04, 0.38), 10, 2, _g(Color(0.95, 0.36, 0.06)), _g(Color(1.0, 0.72, 0.2)), rng, 0.0)   # flaque de lave
	return st.commit()


static func _smoke_vent() -> Mesh:
	Adv3DMeshes.smooth_mode = false
	var st := Adv3DMeshes._begin()
	var rng := Adv3DMeshes._rng(335)
	Adv3DMeshes.add_cone(st, Vector3.ZERO, 0.32, 0.16, 0.28, 7, Color(0.10, 0.08, 0.08), Color(0.28, 0.22, 0.20), rng, 0.03, true)
	Adv3DMeshes.add_cone(st, Vector3(0, 0.27, 0), 0.15, 0.0, 0.02, 7, _g(Color(1.0, 0.4, 0.08)), _g(Color(1.0, 0.75, 0.25)), rng, 0.0, false)
	return st.commit()


# ══════════════════════════════════════════════════════════════════════
#  Brumes
# ══════════════════════════════════════════════════════════════════════

static func _dead_tree() -> Mesh:
	Adv3DMeshes.smooth_mode = false
	var st := Adv3DMeshes._begin()
	var cb := Color(0.24, 0.24, 0.22)
	var ct := Color(0.48, 0.48, 0.43)
	_spike(st, Vector3(0, -0.05, 0), Vector3(-0.12, 1, 0.06), 0.25, 1.4, 0.0, 6, cb, ct, ct, 0.18)
	_spike(st, Vector3(-0.17, 1.33, 0.08), Vector3(0.25, 1, -0.05), 0.18, 1.1, 0.25, 6, ct.darkened(0.1), ct, ct)
	for e: Array in [[Vector3(-0.1, 1.5, 0.05), Vector3(-1, 0.7, 0.2), 0.08, 1.0], [Vector3(0.0, 1.9, 0.0), Vector3(0.9, 0.8, 0.3), 0.07, 0.9],
			[Vector3(-0.05, 1.2, 0), Vector3(0.2, 0.4, -1), 0.06, 0.7]]:
		_spike(st, e[0], e[1], e[2], e[3], 0.3, 5, cb, ct, ct)
	# mousse grise qui pend des branches
	var moss := Color(0.40, 0.52, 0.42)
	for e2: Array in [[Vector3(-0.75, 1.95, 0.2)], [Vector3(-0.45, 1.75, 0.12)], [Vector3(0.6, 2.35, 0.2)], [Vector3(0.3, 2.15, 0.1)], [Vector3(0.12, 1.32, -0.5)]]:
		var p: Vector3 = e2[0]
		Adv3DMeshes.add_blade(st, p, p + Vector3(0.03, -0.55, 0.02), 0.12, moss.lightened(0.2), moss.darkened(0.2))
		Adv3DMeshes.add_blade(st, p + Vector3(0.0, 0, 0.01), p + Vector3(-0.03, -0.45, 0.03), 0.1, moss.lightened(0.25), moss.darkened(0.15))
	var rng := Adv3DMeshes._rng(341)
	Adv3DMeshes.add_blob(st, Vector3(0, 0.05, 0), Vector3(0.5, 0.12, 0.46), 6, 2, cb, ct.darkened(0.2), rng, 0.1)
	return st.commit()


static func _mushroom_big() -> Mesh:
	var st := Adv3DMeshes._begin()
	var rng := Adv3DMeshes._rng(343)
	Adv3DMeshes.add_cone(st, Vector3.ZERO, 0.3, 0.2, 1.4, 9, Color(0.70, 0.72, 0.62), Color(0.90, 0.92, 0.84), rng, 0.01)
	Adv3DMeshes.add_blob(st, Vector3(0, 1.36, 0), Vector3(0.85, 0.1, 0.85), 12, 3, Color(0.62, 0.78, 0.72), Color(0.74, 0.88, 0.82), rng, 0.0)     # lamelles
	Adv3DMeshes.add_blob(st, Vector3(0, 1.55, 0), Vector3(1.0, 0.42, 1.0), 12, 5, Color(0.12, 0.34, 0.38), Color(0.26, 0.62, 0.62), rng, 0.02)    # chapeau
	for i: int in range(9):
		var a: float = float(i) / 9.0 * TAU + rng.randf() * 0.4
		var rr: float = 0.45 + float(i % 3) * 0.15
		var y: float = 1.55 + sqrt(maxf(0.0, 1.0 - rr * rr)) * 0.4
		Adv3DMeshes.add_blob(st, Vector3(cos(a) * rr, y, sin(a) * rr), Vector3(0.09, 0.04, 0.09), 6, 2, _g(Color(0.55, 1.0, 0.85)), _g(Color(0.8, 1.0, 0.95)), rng, 0.0)
	# deux petits champignons au pied
	for e: Array in [[Vector3(0.55, 0, 0.3), 0.35], [Vector3(-0.45, 0, -0.35), 0.28]]:
		var s: float = e[1]
		var b: Vector3 = e[0]
		Adv3DMeshes.add_cone(st, b, 0.07 * s / 0.3, 0.05 * s / 0.3, s, 6, Color(0.70, 0.72, 0.62), Color(0.90, 0.92, 0.84), rng, 0.0, false)
		Adv3DMeshes.add_blob(st, b + Vector3(0, s, 0), Vector3(0.22, 0.1, 0.22) * (s / 0.3), 8, 3, _g(Color(0.22, 0.6, 0.6)), _g(Color(0.5, 0.95, 0.85)), rng, 0.0)
	return st.commit()


static func _glowcaps() -> Mesh:
	var st := Adv3DMeshes._begin()
	var rng := Adv3DMeshes._rng(345)
	for e: Array in [[Vector3(0, 0, 0), 0.22], [Vector3(0.15, 0, 0.1), 0.15], [Vector3(-0.12, 0, 0.12), 0.12]]:
		var s: float = e[1]
		var b: Vector3 = e[0]
		Adv3DMeshes.add_cone(st, b, 0.03, 0.025, s, 5, Color(0.70, 0.72, 0.62), Color(0.90, 0.92, 0.84), rng, 0.0, false)
		Adv3DMeshes.add_blob(st, b + Vector3(0, s, 0), Vector3(0.09, 0.05, 0.09) * (s / 0.2), 7, 3, _g(Color(0.25, 0.65, 0.62)), _g(Color(0.6, 1.0, 0.9)), rng, 0.0)
	return st.commit()


# ══════════════════════════════════════════════════════════════════════
#  Ombres
# ══════════════════════════════════════════════════════════════════════

static func _dark_spire() -> Mesh:
	Adv3DMeshes.smooth_mode = false
	var st := Adv3DMeshes._begin()
	var rng := Adv3DMeshes._rng(351)
	Adv3DMeshes.add_blob(st, Vector3(0, 0.15, 0), Vector3(0.6, 0.25, 0.55), 6, 3, Color(0.10, 0.08, 0.14), Color(0.26, 0.22, 0.32), rng, 0.1)
	_spike(st, Vector3(0, 0.1, 0), Vector3(0, 1, 0), 0.32, 3.0, 0.16, 4, Color(0.06, 0.05, 0.10), Color(0.22, 0.16, 0.32), _g(Color(0.80, 0.55, 1.0)), 0.2)
	# runes lumineuses sur les quatre faces
	for i: int in range(4):
		var a: float = float(i) * PI * 0.5 + PI * 0.25
		var n := Vector3(cos(a), 0, sin(a))
		for k: int in range(3):
			var y: float = 0.8 + float(k) * 0.55
			var r: float = lerpf(0.32, 0.2, (y - 0.1) / 2.5) * 0.72
			Adv3DMeshes.add_box(st, n * (r + 0.01) + Vector3(0, y, 0), Vector3(0.07, 0.16, 0.07), _g(Color(0.72, 0.42, 1.0)), _g(Color(0.9, 0.7, 1.0)))
	return st.commit()


static func _gravestone() -> Mesh:
	var st := Adv3DMeshes._begin()
	var rng := Adv3DMeshes._rng(353)
	Adv3DMeshes.smooth_mode = false
	Adv3DMeshes.add_blob(st, Vector3(0, 0.04, 0.35), Vector3(0.42, 0.14, 0.62), 6, 2, Color(0.20, 0.16, 0.16), Color(0.34, 0.28, 0.26), rng, 0.06)   # tertre
	Adv3DMeshes.add_box(st, Vector3(0, 0.55, 0), Vector3(0.62, 1.0, 0.18), Color(0.34, 0.34, 0.40), Color(0.58, 0.58, 0.64))
	Adv3DMeshes.smooth_mode = true
	Adv3DMeshes.add_blob(st, Vector3(0, 1.05, 0), Vector3(0.31, 0.2, 0.09), 10, 4, Color(0.50, 0.50, 0.56), Color(0.62, 0.62, 0.68), rng, 0.0)
	Adv3DMeshes.add_box(st, Vector3(0, 0.75, 0.095), Vector3(0.06, 0.4, 0.02), Color(0.22, 0.22, 0.28), Color(0.26, 0.26, 0.32))   # croix gravée
	Adv3DMeshes.add_box(st, Vector3(0, 0.84, 0.095), Vector3(0.26, 0.06, 0.02), Color(0.22, 0.22, 0.28), Color(0.26, 0.26, 0.32))
	Adv3DMeshes.add_blob(st, Vector3(0.2, 0.15, 0.06), Vector3(0.16, 0.1, 0.12), 6, 3, Color(0.26, 0.36, 0.26), Color(0.40, 0.50, 0.36), rng, 0.04)   # mousse
	return st.commit()


static func _thorn_bush() -> Mesh:
	var st := Adv3DMeshes._begin()
	var rng := Adv3DMeshes._rng(355)
	var cb := Color(0.20, 0.10, 0.26)
	var ct := Color(0.46, 0.26, 0.58)
	Adv3DMeshes.add_blob(st, Vector3(0, 0.22, 0), Vector3(0.4, 0.26, 0.36), 8, 4, cb, ct, rng, 0.08)
	Adv3DMeshes.add_blob(st, Vector3(0.28, 0.16, 0.15), Vector3(0.24, 0.18, 0.22), 7, 3, cb, ct, rng, 0.08)
	Adv3DMeshes.smooth_mode = false
	for i: int in range(9):
		var a: float = float(i) / 9.0 * TAU
		var p := Vector3(cos(a) * 0.32, 0.25 + float(i % 3) * 0.08, sin(a) * 0.3)
		_spike(st, p, Vector3(cos(a), 0.6, sin(a)), 0.03, 0.22, 1.0, 3, cb, ct, Color(0.70, 0.50, 0.85))
	return st.commit()


static func _bones() -> Mesh:
	var st := Adv3DMeshes._begin()
	var rng := Adv3DMeshes._rng(357)
	var cb := Color(0.78, 0.74, 0.64)
	var ct := Color(0.96, 0.94, 0.86)
	Adv3DMeshes.smooth_mode = false
	_spike(st, Vector3(-0.25, 0.05, 0), Vector3(1, 0, 0.3), 0.035, 0.5, 0.0, 5, cb, ct, ct)
	Adv3DMeshes.smooth_mode = true
	for p: Vector3 in [Vector3(-0.27, 0.05, -0.01), Vector3(0.23, 0.05, 0.14)]:
		Adv3DMeshes.add_blob(st, p, Vector3(0.06, 0.05, 0.08), 6, 3, cb, ct, rng, 0.0)
	Adv3DMeshes.add_blob(st, Vector3(0.1, 0.09, -0.25), Vector3(0.12, 0.1, 0.13), 8, 4, cb, ct, rng, 0.0)   # crâne
	Adv3DMeshes.add_blob(st, Vector3(0.06, 0.11, -0.15), Vector3(0.03, 0.03, 0.02), 5, 2, Color(0.1, 0.08, 0.08), Color(0.1, 0.08, 0.08), rng, 0.0)
	Adv3DMeshes.add_blob(st, Vector3(0.14, 0.11, -0.15), Vector3(0.03, 0.03, 0.02), 5, 2, Color(0.1, 0.08, 0.08), Color(0.1, 0.08, 0.08), rng, 0.0)
	return st.commit()


static func _stalagmite() -> Mesh:
	Adv3DMeshes.smooth_mode = false
	var st := Adv3DMeshes._begin()
	_spike(st, Vector3.ZERO, Vector3(0.05, 1, 0), 0.22, 0.9, 0.55, 6, Color(0.26, 0.22, 0.36), Color(0.48, 0.42, 0.62), Color(0.60, 0.55, 0.80))
	_spike(st, Vector3(0.25, 0, 0.1), Vector3(0.1, 1, 0.05), 0.12, 0.5, 0.55, 5, Color(0.26, 0.22, 0.36), Color(0.48, 0.42, 0.62), Color(0.60, 0.55, 0.80))
	return st.commit()


# ══════════════════════════════════════════════════════════════════════
#  Rouages
# ══════════════════════════════════════════════════════════════════════

static func _gear(st: SurfaceTool, c: Vector3, axis: Vector3, r: float, w: float, teeth: int, cb: Color, ct: Color) -> void:
	var d: Vector3 = axis.normalized()
	_spike(st, c - d * w * 0.5, d, r, w, 0.0, 12, cb, ct, ct)
	var side: Vector3 = d.cross(Vector3.UP if absf(d.y) < 0.95 else Vector3.RIGHT).normalized()
	var up2: Vector3 = side.cross(d).normalized()
	for i: int in range(teeth):
		var a: float = float(i) / float(teeth) * TAU
		var o: Vector3 = side * cos(a) + up2 * sin(a)
		_spike(st, c - d * w * 0.5 + o * r * 0.92, d, r * 0.14, w, 0.0, 4, cb, ct, ct)
	_spike(st, c - d * w * 0.8, d, r * 0.22, w * 1.6, 0.0, 6, cb.darkened(0.2), ct.darkened(0.1), ct)   # moyeu


static func _gear_tower() -> Mesh:
	Adv3DMeshes.smooth_mode = false
	var st := Adv3DMeshes._begin()
	var rng := Adv3DMeshes._rng(361)
	var iron_b := Color(0.22, 0.22, 0.24)
	var iron_t := Color(0.50, 0.49, 0.47)
	var cu_b := Color(0.62, 0.34, 0.16)
	var cu_t := Color(0.92, 0.62, 0.32)
	Adv3DMeshes.add_cone(st, Vector3.ZERO, 0.62, 0.46, 0.35, 8, iron_b, iron_t, rng, 0.0)
	Adv3DMeshes.add_cone(st, Vector3(0, 0.35, 0), 0.42, 0.32, 1.9, 8, iron_b, iron_t, rng, 0.0)
	for y: float in [0.6, 1.3, 2.0]:
		Adv3DMeshes.add_cone(st, Vector3(0, y, 0), 0.43 - y * 0.05, 0.42 - y * 0.05, 0.1, 8, cu_b, cu_t, rng, 0.0, false)
	Adv3DMeshes.add_cone(st, Vector3(0, 2.25, 0), 0.36, 0.0, 0.5, 8, cu_b, cu_t, rng, 0.0)   # toit de cuivre
	Adv3DMeshes.add_box(st, Vector3(0, 1.55, 0.36), Vector3(0.2, 0.28, 0.06), _g(Color(1.0, 0.62, 0.22)), _g(Color(1.0, 0.85, 0.45)))   # fenêtre éclairée
	_gear(st, Vector3(0.42, 1.05, 0), Vector3(1, 0, 0), 0.48, 0.1, 10, cu_b, cu_t)
	_gear(st, Vector3(-0.38, 1.6, 0.1), Vector3(-1, 0, 0.2), 0.28, 0.08, 8, iron_b, iron_t)
	_spike(st, Vector3(0.2, 2.1, -0.2), Vector3(0.1, 1, -0.1), 0.08, 0.7, 0.0, 6, iron_b, iron_t, iron_t)   # cheminée
	return st.commit()


static func _scrap_pile() -> Mesh:
	Adv3DMeshes.smooth_mode = false
	var st := Adv3DMeshes._begin()
	var rng := Adv3DMeshes._rng(363)
	Adv3DMeshes.add_blob(st, Vector3(0, 0.3, 0), Vector3(0.95, 0.5, 0.8), 6, 3, Color(0.30, 0.20, 0.14), Color(0.56, 0.40, 0.28), rng, 0.18)
	Adv3DMeshes.add_box(st, Vector3(0.3, 0.62, 0.1), Vector3(0.6, 0.06, 0.45), Color(0.40, 0.40, 0.42), Color(0.62, 0.62, 0.62))
	Adv3DMeshes.add_box(st, Vector3(-0.35, 0.5, -0.2), Vector3(0.5, 0.05, 0.4), Color(0.36, 0.30, 0.26), Color(0.52, 0.44, 0.38))
	_gear(st, Vector3(-0.1, 0.72, 0.15), Vector3(0.3, 1, 0.4), 0.34, 0.08, 9, Color(0.62, 0.34, 0.16), Color(0.92, 0.62, 0.32))
	_spike(st, Vector3(0.4, 0.2, -0.45), Vector3(-0.6, 0.5, 0.3), 0.07, 1.0, 0.0, 6, Color(0.50, 0.30, 0.16), Color(0.82, 0.56, 0.30), Color(0.82, 0.56, 0.30))
	return st.commit()
