class_name Adv3DMobMeshes
extends RefCounted
## Adv3DMobMeshes.gd — Créatures 3D propres à chaque Nation pour les groupes de monstres du monde
## d'Aventure 3D (la Forêt, la Montagne et le Désert gardent leurs gobelins).
## Hauteur ≈ 1 m (même gabarit que les gobelins), regard vers +Z. Lueurs : sommets à alpha 0
## (rendus par Adv3DNationMeshes.glow_material).
##
## Cristaux : golem de cristal · Marées : crabe · Vents : harpie · Brasier : diablotin de lave ·
## Brumes : feu follet · Ombres : spectre encapuchonné · Rouages : automate · Donjon : squelette.

static func has(biome: String) -> bool:
	return biome in ["Cristaux", "Marées", "Vents", "Brasier", "Brumes", "Ombres", "Rouages", "Donjon"]


## Créature qui flotte (bobbing plus ample, pas d'ombre de pieds) ?
static func floats(biome: String) -> bool:
	return biome in ["Brumes", "Ombres"]


static func mesh_for(biome: String, elite: bool) -> Mesh:
	if not has(biome):
		return null
	return Adv3DMeshes._cached("mob3d_%s_%s" % [biome, elite], func() -> Mesh:
		var st := Adv3DMeshes._begin()
		var r := Adv3DMeshes._rng(700 + biome.hash() % 97)
		match biome:
			"Cristaux": _crystal_golem(st, r, elite)
			"Marées": _crab(st, r, elite)
			"Vents": _harpy(st, r, elite)
			"Brasier": _lava_imp(st, r, elite)
			"Brumes": _wisp(st, r, elite)
			"Ombres": _spectre(st, r, elite)
			"Rouages": _automaton(st, r, elite)
			"Donjon": _skeleton(st, r, elite)
		return st.commit())


static func _g(c: Color) -> Color:
	return Color(c.r, c.g, c.b, 0.0)


static func _eyes(st: SurfaceTool, r: RandomNumberGenerator, y: float, z: float, dx: float, rad: float, col: Color) -> void:
	for sgn: float in [-1.0, 1.0]:
		Adv3DMeshes.add_blob(st, Vector3(dx * sgn, y, z), Vector3(rad, rad * 1.1, rad * 0.6), 6, 3, _g(col), _g(col.lightened(0.4)), r, 0.0)


# ── Cristaux : golem trapu fait d'éclats ──────────────────────────────────
static func _crystal_golem(st: SurfaceTool, r: RandomNumberGenerator, elite: bool) -> void:
	Adv3DMeshes.smooth_mode = false
	var rb := Color(0.18, 0.16, 0.30)
	var rt := Color(0.40, 0.36, 0.58)
	Adv3DMeshes.add_blob(st, Vector3(0, 0.45, 0), Vector3(0.32, 0.32, 0.26), 6, 4, rb, rt, r, 0.12)         # torse rocheux
	Adv3DMeshes.add_blob(st, Vector3(0, 0.86, 0.03), Vector3(0.2, 0.17, 0.18), 6, 3, rb, rt, r, 0.1)          # tête
	for sgn: float in [-1.0, 1.0]:
		Adv3DMeshes.add_blob(st, Vector3(0.38 * sgn, 0.5, 0.04), Vector3(0.12, 0.22, 0.12), 5, 3, rb, rt, r, 0.1)   # bras
		Adv3DMeshes.add_blob(st, Vector3(0.4 * sgn, 0.25, 0.08), Vector3(0.14, 0.12, 0.14), 5, 3, rb, rt, r, 0.1)   # poings
		Adv3DMeshes.add_cone(st, Vector3(0.14 * sgn, 0.0, 0), 0.1, 0.09, 0.2, 5, rb, rt, r, 0.0)                    # jambes
	var cb := Color(0.30, 0.50, 0.85)
	for e: Array in [[Vector3(0.12, 0.7, -0.15), Vector3(0.3, 1, -0.4), 0.07, 0.4], [Vector3(-0.12, 0.72, -0.12), Vector3(-0.4, 1, -0.3), 0.06, 0.34],
			[Vector3(0.3, 0.68, -0.05), Vector3(0.8, 1, 0), 0.05, 0.28], [Vector3(0.0, 0.95, -0.05), Vector3(0, 1, -0.2), 0.05, 0.3 if not elite else 0.5]]:
		Adv3DNationMeshes._spike(st, e[0], e[1], e[2], e[3], 0.35, 6, cb, Color(0.6, 0.85, 1.0), _g(Color(0.85, 0.97, 1.0)))
	_eyes(st, r, 0.87, 0.19, 0.07, 0.035, Color(0.5, 0.9, 1.0))
	Adv3DMeshes.add_blob(st, Vector3(0, 0.5, 0.24), Vector3(0.08, 0.08, 0.04), 6, 3, _g(Color(0.55, 0.85, 1.0)), _g(Color(0.85, 1.0, 1.0)), r, 0.0)   # cœur


# ── Marées : crabe ────────────────────────────────────────────────────────
static func _crab(st: SurfaceTool, r: RandomNumberGenerator, elite: bool) -> void:
	var sb := Color(0.70, 0.20, 0.12) if not elite else Color(0.42, 0.14, 0.40)
	var stp := Color(0.98, 0.48, 0.28) if not elite else Color(0.78, 0.36, 0.70)
	Adv3DMeshes.add_blob(st, Vector3(0, 0.36, 0), Vector3(0.42, 0.2, 0.32), 10, 5, sb, stp, r, 0.02)          # carapace
	Adv3DMeshes.add_blob(st, Vector3(0, 0.3, 0.05), Vector3(0.36, 0.12, 0.28), 10, 3, Color(0.92, 0.80, 0.66), Color(0.98, 0.88, 0.74), r, 0.0)   # ventre
	for sgn: float in [-1.0, 1.0]:
		Adv3DMeshes.add_cone(st, Vector3(0.1 * sgn, 0.5, 0.18), 0.025, 0.02, 0.22, 5, sb, stp, r, 0.0)           # pédoncules
		Adv3DMeshes.add_blob(st, Vector3(0.1 * sgn, 0.74, 0.18), Vector3(0.05, 0.05, 0.05), 6, 3, Color.WHITE, Color.WHITE, r, 0.0)
		Adv3DMeshes.add_blob(st, Vector3(0.1 * sgn, 0.75, 0.22), Vector3(0.025, 0.03, 0.02), 5, 2, Color(0.05, 0.05, 0.05), Color(0.05, 0.05, 0.05), r, 0.0)
		Adv3DMeshes.add_blob(st, Vector3(0.48 * sgn, 0.42, 0.3), Vector3(0.17, 0.12, 0.2), 8, 4, sb, stp, r, 0.0)   # pinces
		Adv3DMeshes.add_blob(st, Vector3(0.56 * sgn, 0.48, 0.44), Vector3(0.07, 0.05, 0.1), 6, 3, sb, stp, r, 0.0)
		Adv3DMeshes.smooth_mode = false
		Adv3DNationMeshes._spike(st, Vector3(0.3 * sgn, 0.36, 0.15), Vector3(1.0 * sgn, 0.3, 0.6), 0.04, 0.22, 0.0, 5, sb, stp, stp)
		for k: int in range(3):
			var z: float = 0.1 - float(k) * 0.14
			Adv3DNationMeshes._spike(st, Vector3(0.34 * sgn, 0.3, z), Vector3(0.9 * sgn, -0.9, 0.0), 0.03, 0.36, 0.3, 4, sb, stp, sb)   # pattes
		Adv3DMeshes.smooth_mode = true


# ── Vents : harpie ronde ailée ────────────────────────────────────────────
static func _harpy(st: SurfaceTool, r: RandomNumberGenerator, elite: bool) -> void:
	var fb := Color(0.46, 0.56, 0.70)
	var ft := Color(0.86, 0.92, 1.0)
	Adv3DMeshes.add_blob(st, Vector3(0, 0.5, 0), Vector3(0.26, 0.3, 0.24), 10, 5, fb, ft, r, 0.02)            # corps
	Adv3DMeshes.add_blob(st, Vector3(0, 0.46, 0.13), Vector3(0.17, 0.2, 0.12), 8, 4, Color(0.92, 0.92, 0.86), Color(1, 1, 0.96), r, 0.0)   # poitrail
	Adv3DMeshes.add_blob(st, Vector3(0, 0.88, 0.04), Vector3(0.18, 0.17, 0.17), 10, 5, fb, ft, r, 0.0)        # tête
	Adv3DMeshes.add_cone(st, Vector3(0, 0.84, 0.17), 0.05, 0.0, 0.12, 5, Color(0.92, 0.66, 0.20), Color(1.0, 0.82, 0.32), r, 0.0)   # bec (pointé vers le haut ≈ crochu)
	_eyes(st, r, 0.92, 0.17, 0.07, 0.03, Color(1.0, 0.85, 0.3))
	for sgn: float in [-1.0, 1.0]:
		Adv3DMeshes.add_blob(st, Vector3(0.36 * sgn, 0.6, -0.05), Vector3(0.28, 0.08, 0.16), 8, 3, fb, ft, r, 0.0)   # ailes
		Adv3DMeshes.add_blob(st, Vector3(0.58 * sgn, 0.66, -0.08), Vector3(0.16, 0.05, 0.11), 6, 3, fb, ft, r, 0.0)
		Adv3DMeshes.add_cone(st, Vector3(0.09 * sgn, 0.0, 0.03), 0.03, 0.03, 0.22, 4, Color(0.80, 0.60, 0.20), Color(0.92, 0.72, 0.28), r, 0.0)   # pattes
	for i: int in range(3):
		Adv3DMeshes.add_blob(st, Vector3((float(i) - 1.0) * 0.07, 0.3, -0.28), Vector3(0.04, 0.03, 0.14), 6, 2, fb, ft, r, 0.0)   # queue
	if elite:
		Adv3DMeshes.add_blob(st, Vector3(0, 1.08, -0.02), Vector3(0.05, 0.12, 0.04), 6, 3, _g(Color(0.6, 0.9, 1.0)), _g(Color(0.9, 1.0, 1.0)), r, 0.0)   # aigrette d'orage


# ── Brasier : diablotin de lave ───────────────────────────────────────────
static func _lava_imp(st: SurfaceTool, r: RandomNumberGenerator, elite: bool) -> void:
	Adv3DMeshes.smooth_mode = false
	var bb := Color(0.10, 0.07, 0.07)
	var bt := Color(0.30, 0.20, 0.18)
	Adv3DMeshes.add_blob(st, Vector3(0, 0.4, 0), Vector3(0.26, 0.3, 0.23), 7, 4, bb, bt, r, 0.08)             # corps de basalte
	Adv3DMeshes.add_blob(st, Vector3(0, 0.8, 0.02), Vector3(0.2, 0.18, 0.19), 7, 4, bb, bt, r, 0.06)           # tête
	for i: int in range(5):                                                                                    # flammes sur la tête
		var a: float = float(i) / 5.0 * TAU
		Adv3DNationMeshes._spike(st, Vector3(cos(a) * 0.1, 0.92, sin(a) * 0.08 - 0.02), Vector3(cos(a) * 0.3, 1, sin(a) * 0.2), 0.05, 0.22 + float(i % 2) * 0.1,
			0.6, 4, _g(Color(1.0, 0.35, 0.05)), _g(Color(1.0, 0.65, 0.15)), _g(Color(1.0, 0.92, 0.5)))
	for k: int in range(4):                                                                                    # fissures de lave
		var a2: float = float(k) * 1.7
		Adv3DNationMeshes._spike(st, Vector3(cos(a2) * 0.22, 0.25 + float(k) * 0.08, sin(a2) * 0.2), Vector3(cos(a2) * 0.2, 1, sin(a2) * 0.2), 0.03, 0.22, 0.0, 4,
			_g(Color(1.0, 0.4, 0.06)), _g(Color(1.0, 0.7, 0.2)), _g(Color(1.0, 0.7, 0.2)))
	Adv3DMeshes.smooth_mode = true
	_eyes(st, r, 0.82, 0.18, 0.07, 0.035, Color(1.0, 0.75, 0.2))
	for sgn: float in [-1.0, 1.0]:
		Adv3DMeshes.add_cone(st, Vector3(0.13 * sgn, 0.0, 0.02), 0.07, 0.08, 0.16, 5, bb, bt, r, 0.0)
		Adv3DMeshes.add_blob(st, Vector3(0.3 * sgn, 0.42, 0.06), Vector3(0.07, 0.17, 0.07), 6, 3, bb, bt, r, 0.0)
		if elite:
			Adv3DMeshes.add_cone(st, Vector3(0.12 * sgn, 0.94, 0), 0.05, 0.0, 0.28, 4, Color(0.2, 0.12, 0.1), Color(0.4, 0.25, 0.18), r, 0.0, false)   # cornes


# ── Brumes : feu follet ───────────────────────────────────────────────────
static func _wisp(st: SurfaceTool, r: RandomNumberGenerator, elite: bool) -> void:
	var gb := Color(0.40, 0.70, 0.62)
	var gt := Color(0.82, 0.98, 0.92)
	Adv3DMeshes.add_blob(st, Vector3(0, 0.7, 0), Vector3(0.26, 0.28, 0.26), 10, 6, gb, gt, r, 0.0)            # tête-flamme
	Adv3DMeshes.add_cone(st, Vector3(0, 0.22, -0.05), 0.04, 0.22, 0.48, 8, gb.darkened(0.2), gb, r, 0.0, false)   # traîne
	Adv3DMeshes.add_blob(st, Vector3(0, 0.95, -0.04), Vector3(0.1, 0.16, 0.1), 7, 3, gb, gt, r, 0.0)            # mèche
	_eyes(st, r, 0.74, 0.22, 0.09, 0.05, Color(0.6, 1.0, 0.85))
	Adv3DMeshes.add_blob(st, Vector3(0, 0.62, 0.23), Vector3(0.05, 0.03, 0.02), 5, 2, Color(0.1, 0.2, 0.18), Color(0.1, 0.2, 0.18), r, 0.0)
	for sgn: float in [-1.0, 1.0]:
		Adv3DMeshes.add_blob(st, Vector3(0.3 * sgn, 0.6, 0.02), Vector3(0.08, 0.06, 0.05), 6, 3, gb, gt, r, 0.0)   # petites mains
	if elite:
		for i: int in range(3):
			var a: float = float(i) / 3.0 * TAU
			Adv3DMeshes.add_blob(st, Vector3(cos(a) * 0.42, 0.85, sin(a) * 0.42), Vector3(0.06, 0.06, 0.06), 6, 3, _g(gt), _g(Color.WHITE), r, 0.0)   # orbes


# ── Ombres : spectre encapuchonné ─────────────────────────────────────────
static func _spectre(st: SurfaceTool, r: RandomNumberGenerator, elite: bool) -> void:
	var rb := Color(0.08, 0.06, 0.12)
	var rt := Color(0.30, 0.22, 0.42)
	Adv3DMeshes.add_cone(st, Vector3(0, 0.08, 0), 0.32, 0.16, 0.66, 9, rb, rt, r, 0.02, false)              # robe
	Adv3DMeshes.smooth_mode = false
	for i: int in range(6):                                                                                   # bas déchiré
		var a: float = float(i) / 6.0 * TAU
		Adv3DNationMeshes._spike(st, Vector3(cos(a) * 0.26, 0.14, sin(a) * 0.26), Vector3(cos(a) * 0.4, -1, sin(a) * 0.4), 0.06, 0.16, 1.0, 3, rt, rb, rb)
	Adv3DMeshes.smooth_mode = true
	Adv3DMeshes.add_blob(st, Vector3(0, 0.84, -0.01), Vector3(0.2, 0.21, 0.2), 10, 5, rb, rt, r, 0.0)        # capuche
	Adv3DMeshes.add_blob(st, Vector3(0, 0.82, 0.08), Vector3(0.13, 0.14, 0.12), 8, 4, Color(0.02, 0.02, 0.04), Color(0.04, 0.03, 0.06), r, 0.0)   # visage d'ombre
	_eyes(st, r, 0.84, 0.19, 0.055, 0.03, Color(0.78, 0.45, 1.0))
	for sgn: float in [-1.0, 1.0]:
		Adv3DMeshes.add_cone(st, Vector3(0.22 * sgn, 0.38, 0.04), 0.07, 0.1, 0.3, 6, rb, rt, r, 0.0, false)   # manches
		Adv3DMeshes.add_blob(st, Vector3(0.24 * sgn, 0.34, 0.08), Vector3(0.04, 0.05, 0.04), 6, 3, Color(0.70, 0.66, 0.78), Color(0.86, 0.82, 0.92), r, 0.0)   # mains pâles
	if elite:
		Adv3DMeshes.add_cone(st, Vector3(-0.3, 0.0, 0.1), 0.02, 0.02, 1.15, 5, rb, rt, r, 0.0)                 # faux
		Adv3DMeshes.add_blob(st, Vector3(-0.18, 1.15, 0.1), Vector3(0.16, 0.03, 0.03), 6, 2, _g(Color(0.7, 0.5, 1.0)), _g(Color(0.95, 0.85, 1.0)), r, 0.0)


# ── Rouages : petit automate ──────────────────────────────────────────────
static func _automaton(st: SurfaceTool, r: RandomNumberGenerator, elite: bool) -> void:
	var ib := Color(0.26, 0.26, 0.28)
	var it := Color(0.56, 0.55, 0.52)
	var cb := Color(0.62, 0.34, 0.16)
	var ct := Color(0.94, 0.64, 0.34)
	Adv3DMeshes.smooth_mode = false
	Adv3DMeshes.add_box(st, Vector3(0, 0.44, 0), Vector3(0.42, 0.38, 0.32), ib, it)                         # torse
	Adv3DMeshes.add_box(st, Vector3(0, 0.44, 0.165), Vector3(0.24, 0.2, 0.02), cb, ct)                         # plastron
	Adv3DMeshes.add_box(st, Vector3(0, 0.82, 0.02), Vector3(0.3, 0.24, 0.26), ib, it)                          # tête
	Adv3DMeshes.add_box(st, Vector3(0, 0.84, 0.15), Vector3(0.2, 0.06, 0.02), _g(Color(1.0, 0.55, 0.15)), _g(Color(1.0, 0.8, 0.35)))   # visière lumineuse
	Adv3DMeshes.add_cone(st, Vector3(0, 0.94, 0), 0.015, 0.015, 0.16, 4, cb, ct, r, 0.0)                         # antenne
	Adv3DMeshes.smooth_mode = true
	Adv3DMeshes.add_blob(st, Vector3(0, 1.12, 0), Vector3(0.035, 0.035, 0.035), 6, 3, _g(Color(1.0, 0.7, 0.2)), _g(Color(1.0, 0.9, 0.5)), r, 0.0)
	for sgn: float in [-1.0, 1.0]:
		Adv3DMeshes.add_cone(st, Vector3(0.28 * sgn, 0.22, 0), 0.05, 0.06, 0.4, 6, cb, ct, r, 0.0)               # bras (tuyaux)
		Adv3DMeshes.add_blob(st, Vector3(0.28 * sgn, 0.2, 0.02), Vector3(0.08, 0.07, 0.08), 6, 3, ib, it, r, 0.0)
		Adv3DMeshes.add_cone(st, Vector3(0.12 * sgn, 0.0, 0), 0.07, 0.06, 0.26, 6, ib, it, r, 0.0)              # jambes
	Adv3DNationMeshes._gear(st, Vector3(0, 0.46, -0.18), Vector3(0, 0, -1), 0.16 if not elite else 0.24, 0.05, 8, cb, ct)   # engrenage dorsal


# ── Donjon : squelette ────────────────────────────────────────────────────
static func _skeleton(st: SurfaceTool, r: RandomNumberGenerator, elite: bool) -> void:
	var b0 := Color(0.74, 0.70, 0.60)
	var b1 := Color(0.96, 0.93, 0.84)
	Adv3DMeshes.add_blob(st, Vector3(0, 0.84, 0.02), Vector3(0.17, 0.17, 0.17), 10, 5, b0, b1, r, 0.0)        # crâne
	Adv3DMeshes.add_blob(st, Vector3(0, 0.74, 0.06), Vector3(0.11, 0.06, 0.1), 8, 3, b0, b1, r, 0.0)           # mâchoire
	for sgn: float in [-1.0, 1.0]:
		Adv3DMeshes.add_blob(st, Vector3(0.06 * sgn, 0.86, 0.15), Vector3(0.04, 0.045, 0.03), 6, 3, Color(0.05, 0.04, 0.04), Color(0.05, 0.04, 0.04), r, 0.0)   # orbites
		Adv3DMeshes.add_blob(st, Vector3(0.06 * sgn, 0.86, 0.17), Vector3(0.015, 0.015, 0.01), 5, 2, _g(Color(0.5, 0.85, 1.0)), _g(Color(0.8, 1.0, 1.0)), r, 0.0)
	Adv3DMeshes.add_cone(st, Vector3(0, 0.3, 0), 0.03, 0.03, 0.42, 5, b0, b1, r, 0.0)                            # colonne
	for k: int in range(3):                                                                                      # côtes
		Adv3DMeshes.add_blob(st, Vector3(0, 0.6 - float(k) * 0.08, 0.02), Vector3(0.15 - float(k) * 0.02, 0.02, 0.1), 8, 2, b0, b1, r, 0.0)
	Adv3DMeshes.add_blob(st, Vector3(0, 0.3, 0), Vector3(0.14, 0.05, 0.09), 8, 2, b0, b1, r, 0.0)                # bassin
	for sgn2: float in [-1.0, 1.0]:
		Adv3DMeshes.add_cone(st, Vector3(0.08 * sgn2, 0.0, 0), 0.025, 0.025, 0.3, 4, b0, b1, r, 0.0)            # jambes
		Adv3DMeshes.add_cone(st, Vector3(0.18 * sgn2, 0.36, 0.02), 0.02, 0.02, 0.28, 4, b0, b1, r, 0.0)         # bras
	Adv3DMeshes.add_cone(st, Vector3(0.28, 0.25, 0.1), 0.02, 0.012, 0.7, 4, Color(0.5, 0.5, 0.55), Color(0.85, 0.85, 0.9), r, 0.0)   # épée
	Adv3DMeshes.add_box(st, Vector3(0.28, 0.36, 0.1), Vector3(0.14, 0.02, 0.03), Color(0.4, 0.3, 0.2), Color(0.5, 0.38, 0.24))
	if elite:
		for i: int in range(4):
			var a: float = float(i) / 4.0 * TAU
			Adv3DMeshes.add_cone(st, Vector3(cos(a) * 0.1, 0.97, sin(a) * 0.1 + 0.02), 0.03, 0.0, 0.12, 4, Color(0.8, 0.6, 0.2), Color(1.0, 0.85, 0.35), r, 0.0, false)   # couronne
