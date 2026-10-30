class_name Adv3DHeroModel
extends RefCounted
## Adv3DHeroModel.gd — Personnage joueur et Gligli en VRAIE 3D low-poly, reconstruits d'après les planches
## de référence (couleurs, accessoires, silhouette). Tout est généré en code : aucun fichier 3D importé.
## Repère : pieds en y = 0, regarde vers +Z. Nœuds animés : LegL/LegR, ArmL/ArmR, Body.

const SKIN_B := Color(0.86, 0.62, 0.46)
const SKIN_T := Color(0.98, 0.78, 0.62)
const GREEN_D := Color(0.10, 0.34, 0.13)
const GREEN_L := Color(0.24, 0.58, 0.20)
const BROWN_D := Color(0.24, 0.15, 0.09)
const BROWN_L := Color(0.50, 0.32, 0.17)
const GOLD := Color(0.92, 0.74, 0.25)
const HAIR_D := Color(0.72, 0.46, 0.18)
const HAIR_L := Color(0.96, 0.72, 0.36)

static var _cache: Dictionary = {}


## Réglage Options « Personnages du monde 3D » (true = vrais modèles). Lu via l'arbre pour ne pas dépendre de l'autoload à la compilation.
static func enabled() -> bool:
	var tree := Engine.get_main_loop() as SceneTree
	if tree == null:
		return true
	var gs: Node = tree.root.get_node_or_null("GameSettings")
	return true if gs == null else bool(gs.get("adventure_models_3d"))


static func _st() -> SurfaceTool:
	Adv3DMeshes.smooth_mode = true
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	return st


static func _r(s: int) -> RandomNumberGenerator:
	var r := RandomNumberGenerator.new()
	r.seed = s
	return r


static func _node(parent: Node3D, mesh: Mesh, pos: Vector3 = Vector3.ZERO, nm: String = "") -> MeshInstance3D:
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


# ══════════════════════════════════════════════════════════════════════
#  Joueur
# ══════════════════════════════════════════════════════════════════════

static func make_hero() -> Node3D:
	var root := Node3D.new()
	root.name = "Hero3D"
	Adv3DActors.add_shadow(root, 0.6)
	var body := Node3D.new()
	body.name = "Body"
	root.add_child(body)
	_node(body, _cached("h_torso", _torso))
	_node(body, _cached("h_cape", _cape))
	_node(body, _cached("h_pack", _pack))
	_node(body, _cached("h_head", _head))
	for sgn: float in [-1.0, 1.0]:
		var side: String = "L" if sgn < 0.0 else "R"
		var leg := Node3D.new()
		leg.name = "Leg" + side
		leg.position = Vector3(0.13 * sgn, 0.95, 0.0)
		root.add_child(leg)
		_node(leg, _cached("h_leg_%s" % side, func() -> Mesh: return _leg(sgn)))
		var arm := Node3D.new()
		arm.name = "Arm" + side
		arm.position = Vector3(0.31 * sgn, 1.52, 0.0)
		arm.rotation.z = -0.07 * sgn
		body.add_child(arm)
		_node(arm, _cached("h_arm", _arm))
	return root


static func _leg(sgn: float) -> Mesh:
	var st := _st()
	var r := _r(1)
	Adv3DMeshes.add_cone(st, Vector3(0, -0.56, 0), 0.10, 0.125, 0.56, 8, Color(0.14, 0.15, 0.12), Color(0.25, 0.26, 0.20), r, 0.0, false)     # pantalon
	Adv3DMeshes.add_cone(st, Vector3(0, -0.95, 0), 0.115, 0.125, 0.40, 8, BROWN_D, BROWN_L, r, 0.0)                                         # botte
	Adv3DMeshes.add_cone(st, Vector3(0, -0.62, 0), 0.145, 0.145, 0.09, 8, Color(0.42, 0.27, 0.14), Color(0.62, 0.42, 0.22), r, 0.0, false)  # revers
	Adv3DMeshes.add_blob(st, Vector3(0, -0.9, 0.08), Vector3(0.115, 0.08, 0.19), 8, 5, BROWN_D, BROWN_L, r, 0.0)                              # bout de botte
	Adv3DMeshes.add_box(st, Vector3(0.115 * sgn, -0.3, 0.02), Vector3(0.05, 0.16, 0.13), Color(0.18, 0.2, 0.15), Color(0.30, 0.31, 0.24))     # poche cargo
	Adv3DMeshes.add_box(st, Vector3(0, -0.66, 0.145), Vector3(0.06, 0.07, 0.02), GOLD, GOLD)                                                 # boucle
	return st.commit()


static func _arm() -> Mesh:
	var st := _st()
	var r := _r(2)
	Adv3DMeshes.add_blob(st, Vector3(0, -0.04, 0), Vector3(0.115, 0.11, 0.115), 8, 5, GREEN_D, GREEN_L, r, 0.0)                               # manche verte
	Adv3DMeshes.add_cone(st, Vector3(0, -0.30, 0), 0.07, 0.06, 0.22, 8, SKIN_B, SKIN_T, r, 0.0, false)                                       # bras
	Adv3DMeshes.add_cone(st, Vector3(0, -0.58, 0), 0.075, 0.09, 0.27, 8, BROWN_D, BROWN_L, r, 0.0, false)                                     # gantelet
	Adv3DMeshes.add_cone(st, Vector3(0, -0.40, 0), 0.093, 0.093, 0.04, 8, Color(0.3, 0.19, 0.1), Color(0.3, 0.19, 0.1), r, 0.0, false)        # sangle
	Adv3DMeshes.add_blob(st, Vector3(0, -0.63, 0.01), Vector3(0.07, 0.075, 0.065), 8, 5, Color(0.2, 0.13, 0.08), Color(0.34, 0.22, 0.13), r, 0.0)  # main gantée
	return st.commit()


static func _torso() -> Mesh:
	var st := _st()
	var r := _r(3)
	Adv3DMeshes.add_cone(st, Vector3(0, 0.98, 0), 0.25, 0.225, 0.52, 10, Color(0.78, 0.69, 0.50), Color(0.93, 0.85, 0.66), r, 0.0, false)  # chemise beige
	Adv3DMeshes.add_cone(st, Vector3(0, 0.92, 0), 0.265, 0.265, 0.12, 10, BROWN_D, BROWN_L, r, 0.0, false)                                # ceinture
	Adv3DMeshes.add_box(st, Vector3(0, 0.98, 0.265), Vector3(0.11, 0.09, 0.03), GOLD, Color(1.0, 0.88, 0.45))                              # boucle
	Adv3DMeshes.add_blob(st, Vector3(0.27, 0.9, 0.06), Vector3(0.075, 0.1, 0.085), 8, 5, BROWN_D, BROWN_L, r, 0.0)                         # sacoche
	for sx: float in [-1.0, 1.0]:
		Adv3DMeshes.add_box(st, Vector3(0.2 * sx, 1.27, 0.2), Vector3(0.12, 0.5, 0.05), GREEN_D, GREEN_L)                                    # pans de la veste
	Adv3DMeshes.add_box(st, Vector3(0.05, 1.28, 0.23), Vector3(0.05, 0.52, 0.02), BROWN_D, BROWN_L)                                         # bretelle
	Adv3DMeshes.add_blob(st, Vector3(-0.15, 1.46, 0.235), Vector3(0.04, 0.04, 0.02), 8, 4, GOLD, Color(1.0, 0.9, 0.5), r, 0.0)             # médaillon
	Adv3DMeshes.add_blob(st, Vector3(0, 1.57, 0.0), Vector3(0.31, 0.14, 0.29), 10, 5, GREEN_D, GREEN_L, r, 0.0)                            # écharpe / capuche
	Adv3DMeshes.add_blob(st, Vector3(0, 1.59, -0.14), Vector3(0.25, 0.16, 0.18), 10, 5, GREEN_D, GREEN_L, r, 0.0)                          # capuche dans le dos
	return st.commit()


static func _cape() -> Mesh:
	var st := _st()
	var r := _r(4)
	Adv3DMeshes.add_box(st, Vector3(0, 1.02, -0.2), Vector3(0.5, 0.56, 0.04), Color(0.30, 0.55, 0.20), GREEN_L)
	for i: int in range(3):
		var x: float = (float(i) - 1.0) * 0.185
		Adv3DMeshes.add_cone(st, Vector3(x, 0.66, -0.2), 0.0, 0.09, 0.14, 4, Color(0.55, 0.72, 0.28), Color(0.40, 0.64, 0.24), r, 0.0, false)
	Adv3DMeshes.add_blob(st, Vector3(0, 0.98, -0.225), Vector3(0.06, 0.1, 0.01), 6, 4, Color(0.78, 0.86, 0.32), Color(0.88, 0.94, 0.42), r, 0.0)   # emblème feuille
	return st.commit()


static func _pack() -> Mesh:
	var st := _st()
	var r := _r(5)
	Adv3DMeshes.add_blob(st, Vector3(0, 1.05, -0.4), Vector3(0.21, 0.25, 0.12), 10, 6, BROWN_D, BROWN_L, r, 0.01)                         # sac
	Adv3DMeshes.add_box(st, Vector3(0, 1.17, -0.5), Vector3(0.28, 0.12, 0.03), Color(0.32, 0.2, 0.11), Color(0.46, 0.3, 0.16))                # rabat
	for sx: float in [-1.0, 1.0]:
		Adv3DMeshes.add_blob(st, Vector3(0.17 * sx, 0.9, -0.4), Vector3(0.07, 0.1, 0.06), 8, 5, BROWN_D, BROWN_L, r, 0.0)                  # poches
		Adv3DMeshes.add_box(st, Vector3(0.08 * sx, 1.07, -0.52), Vector3(0.05, 0.07, 0.02), GOLD, GOLD)                                      # boucles
		Adv3DMeshes.add_blob(st, Vector3(0.27 * sx, 1.42, -0.4), Vector3(0.03, 0.08, 0.08), 8, 5, Color(0.2, 0.12, 0.07), Color(0.32, 0.2, 0.11), r, 0.0)  # bout du rouleau
	Adv3DMeshes.add_blob(st, Vector3(0, 1.42, -0.4), Vector3(0.27, 0.08, 0.08), 10, 5, BROWN_D, BROWN_L, r, 0.0)                              # rouleau de couchage
	# pousse de feuille sur l'épaule (comme sur le logo)
	Adv3DMeshes.add_blade(st, Vector3(0.09, 1.6, -0.17), Vector3(0.17, 1.82, -0.2), 0.1, GREEN_D, Color(0.35, 0.75, 0.25))
	Adv3DMeshes.add_blade(st, Vector3(0.09, 1.6, -0.17), Vector3(0.04, 1.8, -0.2), 0.09, GREEN_D, Color(0.30, 0.68, 0.22))
	return st.commit()


static func _head() -> Mesh:
	var st := _st()
	var r := _r(6)
	Adv3DMeshes.add_cone(st, Vector3(0, 1.58, 0), 0.075, 0.07, 0.12, 8, SKIN_B, SKIN_T, r, 0.0, false)                                         # cou
	Adv3DMeshes.add_blob(st, Vector3(0, 1.8, 0.0), Vector3(0.205, 0.225, 0.2), 12, 8, SKIN_B, SKIN_T, r, 0.0)                                  # visage
	Adv3DMeshes.add_blob(st, Vector3(0, 1.87, -0.03), Vector3(0.225, 0.2, 0.225), 12, 7, HAIR_D, HAIR_L, r, 0.0)                               # calotte de cheveux
	for t: Array in [[0.12, 2.04, 0.05, 0.09], [-0.1, 2.05, 0.0, 0.09], [0.0, 2.09, 0.08, 0.085], [0.2, 1.95, 0.0, 0.08], [-0.2, 1.93, 0.02, 0.08], [0.0, 1.95, -0.2, 0.1], [0.14, 1.99, -0.12, 0.08], [-0.14, 1.99, -0.12, 0.08]]:
		Adv3DMeshes.add_blob(st, Vector3(t[0], t[1], t[2]), Vector3(t[3], t[3] * 1.1, t[3]), 8, 5, HAIR_D, HAIR_L, r, 0.0)                    # mèches
	Adv3DMeshes.add_blob(st, Vector3(0.085, 1.97, 0.17), Vector3(0.1, 0.05, 0.07), 8, 4, HAIR_D, HAIR_L, r, 0.0)                                # frange
	Adv3DMeshes.add_blob(st, Vector3(-0.09, 1.96, 0.18), Vector3(0.1, 0.05, 0.07), 8, 4, HAIR_D, HAIR_L, r, 0.0)
	for sx: float in [-1.0, 1.0]:
		Adv3DMeshes.add_blob(st, Vector3(0.076 * sx, 1.79, 0.185), Vector3(0.03, 0.046, 0.02), 8, 5, Color(0.28, 0.16, 0.05), Color(0.50, 0.30, 0.10), r, 0.0)   # yeux
		Adv3DMeshes.add_blob(st, Vector3(0.068 * sx, 1.805, 0.2), Vector3(0.011, 0.014, 0.008), 5, 3, Color.WHITE, Color.WHITE, r, 0.0)               # reflet
		Adv3DMeshes.add_blob(st, Vector3(0.2 * sx, 1.77, 0.0), Vector3(0.03, 0.05, 0.03), 6, 4, SKIN_B, SKIN_T, r, 0.0)                             # oreilles
		Adv3DMeshes.add_blob(st, Vector3(0.12 * sx, 1.74, 0.17), Vector3(0.04, 0.025, 0.015), 6, 3, Color(0.96, 0.58, 0.5), Color(0.98, 0.64, 0.56), r, 0.0)  # joues
	Adv3DMeshes.add_box(st, Vector3(0, 1.7, 0.2), Vector3(0.05, 0.012, 0.01), Color(0.5, 0.25, 0.2), Color(0.5, 0.25, 0.2))                       # sourire
	return st.commit()


# ══════════════════════════════════════════════════════════════════════
#  Gligli
# ══════════════════════════════════════════════════════════════════════

static func make_gligli() -> Node3D:
	var root := Node3D.new()
	root.name = "Gligli3D"
	Adv3DActors.add_shadow(root, 0.45)
	var body := Node3D.new()
	body.name = "Body"
	root.add_child(body)
	_node(body, _cached("g_body", _gligli_mesh))
	return root


static func _gligli_mesh() -> Mesh:
	var st := _st()
	var r := _r(9)
	var gd := Color(0.34, 0.56, 0.17)
	var gl := Color(0.60, 0.80, 0.30)
	var leaf_d := Color(0.20, 0.46, 0.15)
	var leaf_l := Color(0.45, 0.72, 0.25)
	Adv3DMeshes.add_blob(st, Vector3(0, 0.34, 0), Vector3(0.3, 0.33, 0.28), 12, 8, gd, gl, r, 0.0)                                              # corps
	Adv3DMeshes.add_blob(st, Vector3(0, 0.3, 0.17), Vector3(0.17, 0.23, 0.12), 10, 6, Color(0.78, 0.84, 0.50), Color(0.92, 0.94, 0.66), r, 0.0)   # ventre
	Adv3DMeshes.add_blob(st, Vector3(0, 0.78, 0.04), Vector3(0.31, 0.27, 0.28), 12, 8, gd, gl, r, 0.0)                                         # tête
	for sx: float in [-1.0, 1.0]:
		Adv3DMeshes.add_blob(st, Vector3(0.2 * sx, 1.07, -0.02), Vector3(0.1, 0.32, 0.03), 8, 6, leaf_d, leaf_l, r, 0.0)                           # grandes oreilles-feuilles
		Adv3DMeshes.add_blob(st, Vector3(0.2 * sx, 1.04, 0.0), Vector3(0.055, 0.2, 0.02), 8, 5, Color(0.65, 0.38, 0.16), Color(0.85, 0.55, 0.25), r, 0.0)  # intérieur orangé
		Adv3DMeshes.add_blob(st, Vector3(0.125 * sx, 0.8, 0.255), Vector3(0.072, 0.09, 0.04), 8, 6, Color(0.10, 0.12, 0.05), Color(0.28, 0.30, 0.08), r, 0.0)   # yeux
		Adv3DMeshes.add_blob(st, Vector3(0.108 * sx, 0.835, 0.285), Vector3(0.024, 0.03, 0.012), 5, 3, Color.WHITE, Color.WHITE, r, 0.0)             # reflets
		Adv3DMeshes.add_blob(st, Vector3(0.2 * sx, 0.72, 0.23), Vector3(0.05, 0.03, 0.02), 6, 4, Color(0.95, 0.65, 0.4), Color(0.98, 0.72, 0.48), r, 0.0)  # joues
		Adv3DMeshes.add_blob(st, Vector3(0.11 * sx, 0.05, 0.2), Vector3(0.075, 0.06, 0.1), 8, 5, gd, gl, r, 0.0)                                  # pattes avant
		Adv3DMeshes.add_blob(st, Vector3(0.22 * sx, 0.1, -0.03), Vector3(0.09, 0.09, 0.14), 8, 5, gd, gl, r, 0.0)                                 # pattes arrière
	Adv3DMeshes.add_blob(st, Vector3(0, 1.1, 0.0), Vector3(0.06, 0.24, 0.025), 8, 6, leaf_d, leaf_l, r, 0.0)                                       # feuille centrale
	Adv3DMeshes.add_blob(st, Vector3(0, 0.74, 0.31), Vector3(0.03, 0.02, 0.02), 6, 4, Color(0.2, 0.3, 0.1), Color(0.3, 0.4, 0.15), r, 0.0)       # nez
	for i: int in range(5):                                                                                                                         # collerette de feuilles
		var a: float = float(i) / 5.0 * TAU + 0.3
		Adv3DMeshes.add_blob(st, Vector3(cos(a) * 0.2, 0.58, sin(a) * 0.17 + 0.05), Vector3(0.09, 0.03, 0.12), 6, 4, leaf_d, leaf_l, r, 0.0)
	for t: Array in [[-0.2, 0.16, -0.3, 0.1], [0.0, 0.2, -0.36, 0.11], [0.2, 0.16, -0.3, 0.1]]:                                                      # queue en feuilles
		Adv3DMeshes.add_blob(st, Vector3(t[0], t[1], t[2]), Vector3(0.06, 0.04, t[3] * 1.4), 6, 4, leaf_d, leaf_l, r, 0.0)
	return st.commit()
