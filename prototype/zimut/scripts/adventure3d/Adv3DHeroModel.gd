class_name Adv3DHeroModel
extends RefCounted
## Adv3DHeroModel.gd — Personnage joueur et Gligli en VRAIE 3D low-poly, reconstruits d'après les planches
## de référence (couleurs, accessoires, silhouette). Tout est généré en code : aucun fichier 3D importé.
##
## Chaque personnage est un petit squelette de nœuds (articulations) : les maillages sont construits en
## coordonnées « monde du personnage » (pieds en y = 0, regard vers +Z) puis décalés sous leur articulation.
## L'animation (marche, course, repos, assis…) est faite par Adv3DHeroRig / Adv3DGligliRig.

const SKIN_B := Color(0.86, 0.62, 0.46)
const SKIN_T := Color(0.98, 0.78, 0.62)
const GREEN_D := Color(0.10, 0.34, 0.13)
const GREEN_L := Color(0.24, 0.58, 0.20)
const BROWN_D := Color(0.24, 0.15, 0.09)
const BROWN_L := Color(0.50, 0.32, 0.17)
const GOLD := Color(0.92, 0.74, 0.25)
const HAIR_D := Color(0.72, 0.46, 0.18)
const HAIR_L := Color(0.96, 0.72, 0.36)
const PANTS_D := Color(0.14, 0.15, 0.12)
const PANTS_L := Color(0.25, 0.26, 0.20)

# articulations du héros (repère du personnage)
const H_HIPS := Vector3(0, 0.95, 0)
const H_NECK := Vector3(0, 1.60, 0)
const H_CHEST := Vector3(0, 1.20, 0)
const H_SHOULDER := Vector3(0.285, 1.49, -0.01)  # x signé
const H_ELBOW_DROP := 0.30
const H_HIP_X := 0.11
const H_KNEE_Y := 0.52
const H_EYES := Vector3(0, 1.80, 0.19)
const H_CAPE := Vector3(0, 0.98, -0.165)
const H_PACK := Vector3(0, 1.30, -0.30)

# articulations de Gligli
const G_HEAD := Vector3(0, 0.60, 0.02)
const G_EYES := Vector3(0, 0.81, 0.27)
const G_EAR := Vector3(0.17, 0.93, -0.02)       # x signé
const G_PAW_F := Vector3(0.11, 0.24, 0.15)      # x signé
const G_PAW_B := Vector3(0.20, 0.24, -0.04)     # x signé
const G_TAIL := Vector3(0, 0.22, -0.25)

static var _cache: Dictionary = {}


## Réglage Options « Personnages du monde 3D » (true = vrais modèles). Lu via l'arbre pour ne pas dépendre de l'autoload à la compilation.
static func enabled() -> bool:
	var tree := Engine.get_main_loop() as SceneTree
	if tree == null:
		return true
	var gs: Node = tree.root.get_node_or_null("GameSettings")
	return true if gs == null else bool(gs.get("adventure_models_3d"))


## Matériau unique des personnages : couleurs de sommets, léger liseré de lumière (rim) pour les détacher
## du décor, et contour sombre fin (coque inversée) façon dessin animé. Partagé → peu d'appels de rendu.
static func char_material() -> Material:
	if _cache.has("mat"):
		return _cache["mat"]
	var m := StandardMaterial3D.new()
	m.vertex_color_use_as_albedo = true
	m.vertex_color_is_srgb = true
	m.roughness = 0.82
	m.rim_enabled = true
	m.rim = 0.35
	m.rim_tint = 0.55
	var ol := StandardMaterial3D.new()
	ol.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	ol.cull_mode = BaseMaterial3D.CULL_FRONT
	ol.albedo_color = Color(0.13, 0.10, 0.08)
	ol.grow = true
	ol.grow_amount = 0.011
	m.next_pass = ol
	_cache["mat"] = m
	return m


static func _st() -> SurfaceTool:
	Adv3DMeshes.smooth_mode = true
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	return st


static func _r(s: int) -> RandomNumberGenerator:
	var r := RandomNumberGenerator.new()
	r.seed = s
	return r


static func _cached(key: String, f: Callable) -> Mesh:
	if not _cache.has(key):
		_cache[key] = _fix_winding(f.call())
	return _cache[key]


## Les briques d'Adv3DMeshes n'ont pas toutes le même sens de triangles (le décor est rendu double face).
## Les personnages sont rendus en face avant seule (+ contour en coque inversée) : on réoriente chaque
## triangle pour que sa face avant regarde dans le sens de sa normale.
static func _fix_winding(m: Mesh) -> Mesh:
	var arr: Array = m.surface_get_arrays(0)
	var v: PackedVector3Array = arr[Mesh.ARRAY_VERTEX]
	var n: PackedVector3Array = arr[Mesh.ARRAY_NORMAL]
	var c: PackedColorArray = arr[Mesh.ARRAY_COLOR]
	var idx: Variant = arr[Mesh.ARRAY_INDEX]
	if idx != null and (idx as PackedInt32Array).size() > 0:
		return m
	for t: int in range(0, v.size() - 2, 3):
		var g: Vector3 = (v[t + 1] - v[t]).cross(v[t + 2] - v[t])
		if g.dot(n[t] + n[t + 1] + n[t + 2]) > 0.0:
			var tv: Vector3 = v[t + 1]
			v[t + 1] = v[t + 2]
			v[t + 2] = tv
			var tn: Vector3 = n[t + 1]
			n[t + 1] = n[t + 2]
			n[t + 2] = tn
			if c.size() == v.size():
				var tc: Color = c[t + 1]
				c[t + 1] = c[t + 2]
				c[t + 2] = tc
	arr[Mesh.ARRAY_VERTEX] = v
	arr[Mesh.ARRAY_NORMAL] = n
	if c.size() == v.size():
		arr[Mesh.ARRAY_COLOR] = c
	var out := ArrayMesh.new()
	out.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arr)
	return out


## Articulation : nœud placé au point `pivot` (repère personnage) sous `parent` (lui-même au point `parent_pivot`).
static func _joint(parent: Node3D, nm: String, pivot: Vector3, parent_pivot: Vector3) -> Node3D:
	var j := Node3D.new()
	j.name = nm
	j.position = pivot - parent_pivot
	parent.add_child(j)
	return j


## Pose un maillage (construit en repère personnage) sous une articulation située en `pivot`.
static func _part(joint: Node3D, mesh: Mesh, pivot: Vector3) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.mesh = mesh
	mi.material_override = char_material()
	mi.position = -pivot
	mi.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	joint.add_child(mi)
	return mi


# ══════════════════════════════════════════════════════════════════════
#  Joueur
# ══════════════════════════════════════════════════════════════════════

static func make_hero() -> Node3D:
	var rig := Adv3DHeroRig.new()
	rig.name = "Hero3D"
	Adv3DActors.add_shadow(rig, 0.6)
	var hips := _joint(rig, "Hips", H_HIPS, Vector3.ZERO)
	_part(hips, _cached("h_pelvis", _pelvis), H_HIPS)
	var torso := _joint(hips, "Torso", H_HIPS, H_HIPS)              # ventre / taille
	_part(torso, _cached("h_abdomen", _abdomen), H_HIPS)
	var chest := _joint(torso, "Chest", H_CHEST, H_HIPS)            # poitrine : la colonne plie en deux points
	_part(chest, _cached("h_chest", _chest), H_CHEST)
	var head := _joint(chest, "Head", H_NECK, H_CHEST)
	_part(head, _cached("h_head", _head), H_NECK)
	var eyes := _joint(head, "Eyes", H_EYES, H_NECK)
	_part(eyes, _cached("h_eyes", _eyes), H_EYES)
	var cape := _joint(hips, "Cape", H_CAPE, H_HIPS)
	_part(cape, _cached("h_cape", _cape), H_CAPE)
	var pack := _joint(chest, "Pack", H_PACK, H_CHEST)
	_part(pack, _cached("h_pack", _pack), H_PACK)
	for sgn: float in [-1.0, 1.0]:
		var side: String = "L" if sgn < 0.0 else "R"
		var sh := Vector3(H_SHOULDER.x * sgn, H_SHOULDER.y, H_SHOULDER.z)
		var arm := _joint(chest, "Arm" + side, sh, H_CHEST)
		_part(arm, _cached("h_uarm", _upper_arm), Vector3(0, sh.y, 0))
		var el := sh + Vector3(0, -H_ELBOW_DROP, 0)
		var fore := _joint(arm, "Forearm" + side, el, sh)
		_part(fore, _cached("h_farm", _forearm), Vector3(0, el.y, 0))
		var hip := Vector3(H_HIP_X * sgn, H_HIPS.y, 0.0)
		var leg := _joint(hips, "Leg" + side, hip, H_HIPS)
		_part(leg, _cached("h_thigh_" + side, func() -> Mesh: return _thigh(sgn)), hip)
		var knee := Vector3(hip.x, H_KNEE_Y, 0.0)
		var shin := _joint(leg, "Shin" + side, knee, hip)
		_part(shin, _cached("h_shin_" + side, func() -> Mesh: return _shin(sgn)), knee)
	rig.setup()
	return rig


const SHIRT_D := Color(0.78, 0.69, 0.50)
const SHIRT_L := Color(0.93, 0.85, 0.66)


static func _pelvis() -> Mesh:
	var st := _st()
	var r := _r(10)
	Adv3DMeshes.add_blob(st, Vector3(0, 0.93, -0.005), Vector3(0.2, 0.13, 0.15), 10, 6, PANTS_D, PANTS_L, r, 0.0)
	return st.commit()


## Cuisse galbée : plus large en haut, muscle à l'avant, poche cargo sur le côté.
static func _thigh(sgn: float) -> Mesh:
	var st := _st()
	var r := _r(1)
	var x: float = H_HIP_X * sgn
	Adv3DMeshes.add_cone(st, Vector3(x, 0.52, 0), 0.082, 0.112, 0.43, 8, PANTS_D, PANTS_L, r, 0.0, false)
	Adv3DMeshes.add_blob(st, Vector3(x, 0.77, 0.015), Vector3(0.108, 0.19, 0.112), 8, 6, PANTS_D, PANTS_L, r, 0.0)                     # muscle
	Adv3DMeshes.add_blob(st, Vector3(x + 0.095 * sgn, 0.70, 0.02), Vector3(0.03, 0.075, 0.06), 6, 4, Color(0.18, 0.2, 0.15), Color(0.30, 0.31, 0.24), r, 0.0)  # poche cargo
	return st.commit()


## Genou, mollet bombé à l'arrière, botte avec revers.
static func _shin(sgn: float) -> Mesh:
	var st := _st()
	var r := _r(7)
	var x: float = H_HIP_X * sgn
	Adv3DMeshes.add_blob(st, Vector3(x, H_KNEE_Y, 0.012), Vector3(0.088, 0.07, 0.092), 8, 5, PANTS_D, PANTS_L, r, 0.0)                     # genou
	Adv3DMeshes.add_blob(st, Vector3(x, 0.41, -0.022), Vector3(0.086, 0.11, 0.09), 8, 5, PANTS_D, PANTS_L, r, 0.0)                         # mollet
	Adv3DMeshes.add_cone(st, Vector3(x, 0.0, 0), 0.098, 0.108, 0.37, 8, BROWN_D, BROWN_L, r, 0.0)                                         # botte
	Adv3DMeshes.add_cone(st, Vector3(x, 0.31, 0), 0.122, 0.13, 0.08, 8, Color(0.42, 0.27, 0.14), Color(0.62, 0.42, 0.22), r, 0.0, false)  # revers
	Adv3DMeshes.add_blob(st, Vector3(x, 0.05, 0.075), Vector3(0.1, 0.07, 0.17), 8, 5, BROWN_D, BROWN_L, r, 0.0)                             # avant du pied
	Adv3DMeshes.add_box(st, Vector3(x, 0.27, 0.118), Vector3(0.05, 0.06, 0.02), GOLD, GOLD)                                                # boucle
	return st.commit()


## Bras construits centrés en x = 0 (même maillage des deux côtés) : posés avec un pivot sans x.
## Épaule arrondie, manche courte, biceps qui s'affine vers le coude.
static func _upper_arm() -> Mesh:
	var st := _st()
	var r := _r(2)
	var y0: float = H_SHOULDER.y
	Adv3DMeshes.add_blob(st, Vector3(0, y0 - 0.035, 0), Vector3(0.085, 0.085, 0.09), 8, 5, GREEN_D, GREEN_L, r, 0.0)        # épaule
	Adv3DMeshes.add_cone(st, Vector3(0, y0 - 0.17, 0), 0.074, 0.088, 0.15, 8, GREEN_D, GREEN_L, r, 0.0, false)              # manche
	Adv3DMeshes.add_cone(st, Vector3(0, y0 - 0.30, 0), 0.052, 0.066, 0.16, 8, SKIN_B, SKIN_T, r, 0.0, false)               # bras
	Adv3DMeshes.add_blob(st, Vector3(0, y0 - 0.30, -0.005), Vector3(0.055, 0.055, 0.056), 8, 4, SKIN_B, SKIN_T, r, 0.0)    # coude
	return st.commit()


## Avant-bras : gantelet évasé vers le coude, poignet fin, main un peu aplatie.
static func _forearm() -> Mesh:
	var st := _st()
	var r := _r(3)
	var y0: float = H_SHOULDER.y - H_ELBOW_DROP
	Adv3DMeshes.add_cone(st, Vector3(0, y0 - 0.26, 0), 0.056, 0.074, 0.24, 8, BROWN_D, BROWN_L, r, 0.0, false)                                # gantelet
	Adv3DMeshes.add_cone(st, Vector3(0, y0 - 0.09, 0), 0.076, 0.076, 0.035, 8, Color(0.3, 0.19, 0.1), Color(0.3, 0.19, 0.1), r, 0.0, false)  # sangle
	Adv3DMeshes.add_blob(st, Vector3(0, y0 - 0.31, 0.012), Vector3(0.05, 0.068, 0.045), 8, 5, Color(0.2, 0.13, 0.08), Color(0.34, 0.22, 0.13), r, 0.0)  # main gantée
	Adv3DMeshes.add_blob(st, Vector3(0, y0 - 0.285, 0.05), Vector3(0.022, 0.035, 0.022), 6, 4, Color(0.2, 0.13, 0.08), Color(0.34, 0.22, 0.13), r, 0.0)  # pouce
	return st.commit()


## Ventre / taille : plus étroite que la poitrine (silhouette en V), ceinture, bas de la veste.
static func _abdomen() -> Mesh:
	var st := _st()
	var r := _r(4)
	Adv3DMeshes.add_blob(st, Vector3(0, 1.1, 0.01), Vector3(0.172, 0.17, 0.138), 10, 6, SHIRT_D, SHIRT_L, r, 0.0)                          # taille
	for sx: float in [-1.0, 1.0]:
		Adv3DMeshes.add_blob(st, Vector3(0.118 * sx, 1.08, -0.005), Vector3(0.098, 0.165, 0.148), 8, 6, GREEN_D, GREEN_L, r, 0.0)         # bas de la veste
	Adv3DMeshes.add_blob(st, Vector3(0, 1.08, -0.05), Vector3(0.165, 0.16, 0.1), 8, 6, GREEN_D, GREEN_L, r, 0.0)                         # dos
	Adv3DMeshes.add_cone(st, Vector3(0, 0.895, 0), 0.198, 0.188, 0.1, 12, BROWN_D, BROWN_L, r, 0.0, false)                                # ceinture
	Adv3DMeshes.add_box(st, Vector3(0, 0.945, 0.192), Vector3(0.09, 0.07, 0.025), GOLD, Color(1.0, 0.88, 0.45))                           # boucle
	Adv3DMeshes.add_blob(st, Vector3(0.205, 0.9, 0.07), Vector3(0.062, 0.085, 0.072), 8, 5, BROWN_D, BROWN_L, r, 0.0)                    # sacoche
	return st.commit()


## Poitrine : plus large, épaules tombantes, veste ouverte sur la chemise, bandoulière, écharpe-capuche.
static func _chest() -> Mesh:
	var st := _st()
	var r := _r(5)
	Adv3DMeshes.add_blob(st, Vector3(0, 1.36, 0.03), Vector3(0.188, 0.19, 0.148), 10, 7, SHIRT_D, SHIRT_L, r, 0.0)                         # poitrine
	for sx: float in [-1.0, 1.0]:
		Adv3DMeshes.add_blob(st, Vector3(0.16 * sx, 1.34, -0.01), Vector3(0.115, 0.23, 0.158), 8, 7, GREEN_D, GREEN_L, r, 0.0)            # veste
		Adv3DMeshes.add_blob(st, Vector3(0.18 * sx, 1.465, -0.02), Vector3(0.1, 0.055, 0.095), 8, 5, GREEN_D, GREEN_L, r, 0.0)            # trapèzes / épaules
	Adv3DMeshes.add_blob(st, Vector3(0, 1.33, -0.05), Vector3(0.215, 0.235, 0.128), 10, 7, GREEN_D, GREEN_L, r, 0.0)                       # dos
	# bandoulière en diagonale, posée sur la poitrine
	for i: int in range(12):
		var f: float = float(i) / 11.0
		var x: float = lerpf(0.15, -0.14, f)
		var y: float = lerpf(1.5, 1.14, f)
		var q: float = 1.0 - pow(x / 0.188, 2.0) - pow((y - 1.36) / 0.19, 2.0)
		var z: float = 0.03 + 0.148 * sqrt(maxf(q, 0.05)) + 0.004
		Adv3DMeshes.add_blob(st, Vector3(x, y, z), Vector3(0.026, 0.026, 0.01), 6, 3, BROWN_D, BROWN_L, r, 0.0)
	Adv3DMeshes.add_blob(st, Vector3(-0.07, 1.41, 0.172), Vector3(0.03, 0.03, 0.014), 8, 4, GOLD, Color(1.0, 0.9, 0.5), r, 0.0)          # médaillon
	Adv3DMeshes.add_blob(st, Vector3(0, 1.545, 0.0), Vector3(0.215, 0.085, 0.195), 10, 5, GREEN_D, GREEN_L, r, 0.0)                       # écharpe
	Adv3DMeshes.add_blob(st, Vector3(0, 1.565, -0.12), Vector3(0.19, 0.12, 0.13), 10, 5, GREEN_D, GREEN_L, r, 0.0)                       # capuche dans le dos
	return st.commit()


## Pans du manteau dans le dos, sous le sac (ils flottent à la marche), ourlet en pointes de feuille.
static func _cape() -> Mesh:
	var st := _st()
	var r := _r(5)
	Adv3DMeshes.add_box(st, Vector3(0, 0.81, -0.17), Vector3(0.5, 0.34, 0.04), Color(0.30, 0.55, 0.20), GREEN_L)
	for i: int in range(3):
		var x: float = (float(i) - 1.0) * 0.17
		Adv3DMeshes.add_cone(st, Vector3(x, 0.55, -0.17), 0.0, 0.085, 0.10, 5, Color(0.55, 0.72, 0.28), Color(0.40, 0.64, 0.24), r, 0.0, false)
	Adv3DMeshes.add_blob(st, Vector3(0, 0.80, -0.195), Vector3(0.05, 0.08, 0.012), 6, 4, Color(0.78, 0.86, 0.32), Color(0.88, 0.94, 0.42), r, 0.0)   # emblème feuille
	return st.commit()


static func _pack() -> Mesh:
	var st := _st()
	var r := _r(6)
	Adv3DMeshes.add_blob(st, Vector3(0, 1.05, -0.335), Vector3(0.21, 0.25, 0.12), 10, 6, BROWN_D, BROWN_L, r, 0.0)                          # sac
	Adv3DMeshes.add_box(st, Vector3(0, 1.17, -0.435), Vector3(0.28, 0.12, 0.03), Color(0.32, 0.2, 0.11), Color(0.46, 0.3, 0.16))              # rabat
	for sx: float in [-1.0, 1.0]:
		Adv3DMeshes.add_blob(st, Vector3(0.17 * sx, 0.92, -0.335), Vector3(0.07, 0.1, 0.06), 8, 5, BROWN_D, BROWN_L, r, 0.0)                  # poches
		Adv3DMeshes.add_blob(st, Vector3(0.27 * sx, 1.42, -0.335), Vector3(0.03, 0.08, 0.08), 8, 5, Color(0.2, 0.12, 0.07), Color(0.32, 0.2, 0.11), r, 0.0)  # bout du rouleau
	Adv3DMeshes.add_blob(st, Vector3(0, 1.42, -0.335), Vector3(0.27, 0.08, 0.08), 10, 5, Color(0.36, 0.42, 0.22), Color(0.50, 0.56, 0.30), r, 0.0)  # rouleau de couchage (kaki)
	Adv3DMeshes.add_box(st, Vector3(0, 1.0, -0.45), Vector3(0.05, 0.3, 0.02), Color(0.32, 0.2, 0.11), Color(0.40, 0.26, 0.14))            # sangle
	Adv3DMeshes.add_box(st, Vector3(0, 0.97, -0.465), Vector3(0.07, 0.05, 0.015), GOLD, Color(1.0, 0.88, 0.45))                              # boucle
	# pousse de feuille qui sort du sac (comme sur le logo)
	Adv3DMeshes.add_blob(st, Vector3(0.12, 1.58, -0.315), Vector3(0.025, 0.12, 0.05), 6, 4, GREEN_D, Color(0.35, 0.75, 0.25), r, 0.0)
	Adv3DMeshes.add_blob(st, Vector3(0.05, 1.56, -0.335), Vector3(0.022, 0.1, 0.045), 6, 4, GREEN_D, Color(0.30, 0.68, 0.22), r, 0.0)
	return st.commit()


static func _head() -> Mesh:
	var st := _st()
	var r := _r(8)
	Adv3DMeshes.add_cone(st, Vector3(0, 1.52, 0), 0.064, 0.058, 0.17, 8, SKIN_B, SKIN_T, r, 0.0, false)                                        # cou
	Adv3DMeshes.add_blob(st, Vector3(0, 1.8, 0.0), Vector3(0.205, 0.225, 0.2), 12, 8, SKIN_B, SKIN_T, r, 0.0)                                  # visage
	Adv3DMeshes.add_blob(st, Vector3(0, 1.87, -0.03), Vector3(0.225, 0.2, 0.225), 12, 7, HAIR_D, HAIR_L, r, 0.0)                               # calotte de cheveux
	for t: Array in [[0.12, 2.04, 0.05, 0.09], [-0.1, 2.05, 0.0, 0.09], [0.0, 2.09, 0.08, 0.085], [0.2, 1.95, 0.0, 0.08], [-0.2, 1.93, 0.02, 0.08], [0.0, 1.95, -0.2, 0.1], [0.14, 1.99, -0.12, 0.08], [-0.14, 1.99, -0.12, 0.08]]:
		Adv3DMeshes.add_blob(st, Vector3(t[0], t[1], t[2]), Vector3(t[3], t[3] * 1.1, t[3]), 8, 5, HAIR_D, HAIR_L, r, 0.0)                    # mèches
	Adv3DMeshes.add_blob(st, Vector3(0.085, 1.97, 0.17), Vector3(0.1, 0.05, 0.07), 8, 4, HAIR_D, HAIR_L, r, 0.0)                                # frange
	Adv3DMeshes.add_blob(st, Vector3(-0.09, 1.96, 0.18), Vector3(0.1, 0.05, 0.07), 8, 4, HAIR_D, HAIR_L, r, 0.0)
	for sx: float in [-1.0, 1.0]:
		Adv3DMeshes.add_box(st, Vector3(0.08 * sx, 1.875, 0.19), Vector3(0.07, 0.018, 0.02), HAIR_D, HAIR_D)                                    # sourcils
		Adv3DMeshes.add_blob(st, Vector3(0.2 * sx, 1.77, 0.0), Vector3(0.03, 0.05, 0.03), 6, 4, SKIN_B, SKIN_T, r, 0.0)                         # oreilles
		Adv3DMeshes.add_blob(st, Vector3(0.12 * sx, 1.73, 0.17), Vector3(0.04, 0.025, 0.015), 6, 3, Color(0.96, 0.58, 0.5), Color(0.98, 0.64, 0.56), r, 0.0)  # joues
	Adv3DMeshes.add_blob(st, Vector3(0, 1.755, 0.2), Vector3(0.02, 0.026, 0.02), 6, 4, SKIN_B, SKIN_T, r, 0.0)                                 # nez
	Adv3DMeshes.add_box(st, Vector3(0, 1.69, 0.2), Vector3(0.05, 0.012, 0.01), Color(0.5, 0.25, 0.2), Color(0.5, 0.25, 0.2))                       # sourire
	return st.commit()


static func _eyes() -> Mesh:
	var st := _st()
	var r := _r(9)
	for sx: float in [-1.0, 1.0]:
		Adv3DMeshes.add_blob(st, Vector3(0.076 * sx, 1.80, 0.185), Vector3(0.034, 0.05, 0.02), 8, 5, Color(0.22, 0.12, 0.04), Color(0.46, 0.27, 0.09), r, 0.0)   # iris
		Adv3DMeshes.add_blob(st, Vector3(0.066 * sx, 1.818, 0.2), Vector3(0.012, 0.015, 0.008), 5, 3, Color.WHITE, Color.WHITE, r, 0.0)                     # reflet
	return st.commit()


# ══════════════════════════════════════════════════════════════════════
#  Gligli
# ══════════════════════════════════════════════════════════════════════

const G_GD := Color(0.34, 0.56, 0.17)
const G_GL := Color(0.60, 0.80, 0.30)
const G_LEAF_D := Color(0.20, 0.46, 0.15)
const G_LEAF_L := Color(0.45, 0.72, 0.25)


static func make_gligli() -> Node3D:
	var rig := Adv3DGligliRig.new()
	rig.name = "Gligli3D"
	Adv3DActors.add_shadow(rig, 0.45)
	var body := _joint(rig, "Body", Vector3.ZERO, Vector3.ZERO)
	_part(body, _cached("g_body", _g_body), Vector3.ZERO)
	var head := _joint(body, "Head", G_HEAD, Vector3.ZERO)
	_part(head, _cached("g_head", _g_head), G_HEAD)
	var eyes := _joint(head, "Eyes", G_EYES, G_HEAD)
	_part(eyes, _cached("g_eyes", _g_eyes), G_EYES)
	var tail := _joint(body, "Tail", G_TAIL, Vector3.ZERO)
	_part(tail, _cached("g_tail", _g_tail), G_TAIL)
	for sgn: float in [-1.0, 1.0]:
		var side: String = "L" if sgn < 0.0 else "R"
		var ep := Vector3(G_EAR.x * sgn, G_EAR.y, G_EAR.z)
		var ear := _joint(head, "Ear" + side, ep, G_HEAD)
		_part(ear, _cached("g_ear_" + side, func() -> Mesh: return _g_ear(sgn)), ep)
		var fp := Vector3(G_PAW_F.x * sgn, G_PAW_F.y, G_PAW_F.z)
		var pf := _joint(body, "PawF" + side, fp, Vector3.ZERO)
		_part(pf, _cached("g_pawf_" + side, func() -> Mesh: return _g_paw_front(sgn)), fp)
		var bp := Vector3(G_PAW_B.x * sgn, G_PAW_B.y, G_PAW_B.z)
		var pb := _joint(body, "PawB" + side, bp, Vector3.ZERO)
		_part(pb, _cached("g_pawb_" + side, func() -> Mesh: return _g_paw_back(sgn)), bp)
	rig.setup()
	return rig


static func _g_body() -> Mesh:
	var st := _st()
	var r := _r(11)
	Adv3DMeshes.add_blob(st, Vector3(0, 0.36, 0), Vector3(0.29, 0.31, 0.27), 12, 8, G_GD, G_GL, r, 0.0)                                           # corps
	Adv3DMeshes.add_blob(st, Vector3(0, 0.32, 0.165), Vector3(0.17, 0.22, 0.12), 10, 6, Color(0.78, 0.84, 0.50), Color(0.92, 0.94, 0.66), r, 0.0) # ventre
	for i: int in range(5):                                                                                                                        # collerette de feuilles
		var a: float = float(i) / 5.0 * TAU + 0.3
		Adv3DMeshes.add_blob(st, Vector3(cos(a) * 0.2, 0.6, sin(a) * 0.17 + 0.05), Vector3(0.09, 0.03, 0.12), 6, 4, G_LEAF_D, G_LEAF_L, r, 0.0)
	return st.commit()


static func _g_head() -> Mesh:
	var st := _st()
	var r := _r(12)
	Adv3DMeshes.add_blob(st, Vector3(0, 0.80, 0.04), Vector3(0.31, 0.27, 0.28), 12, 8, G_GD, G_GL, r, 0.0)                                        # tête
	for sx: float in [-1.0, 1.0]:
		Adv3DMeshes.add_blob(st, Vector3(0.2 * sx, 0.73, 0.235), Vector3(0.05, 0.03, 0.02), 6, 4, Color(0.95, 0.65, 0.4), Color(0.98, 0.72, 0.48), r, 0.0)  # joues
	Adv3DMeshes.add_blob(st, Vector3(0, 1.12, 0.0), Vector3(0.05, 0.2, 0.025), 8, 6, G_LEAF_D, G_LEAF_L, r, 0.0)                                 # feuille centrale
	Adv3DMeshes.add_blob(st, Vector3(0, 0.755, 0.315), Vector3(0.03, 0.02, 0.02), 6, 4, Color(0.2, 0.3, 0.1), Color(0.3, 0.4, 0.15), r, 0.0)     # nez
	Adv3DMeshes.add_box(st, Vector3(0, 0.715, 0.305), Vector3(0.05, 0.01, 0.01), Color(0.25, 0.3, 0.12), Color(0.25, 0.3, 0.12))                  # bouche
	return st.commit()


static func _g_eyes() -> Mesh:
	var st := _st()
	var r := _r(13)
	for sx: float in [-1.0, 1.0]:
		Adv3DMeshes.add_blob(st, Vector3(0.125 * sx, 0.81, 0.26), Vector3(0.074, 0.092, 0.04), 8, 6, Color(0.08, 0.10, 0.04), Color(0.26, 0.28, 0.08), r, 0.0)   # yeux
		Adv3DMeshes.add_blob(st, Vector3(0.105 * sx, 0.85, 0.292), Vector3(0.026, 0.032, 0.012), 5, 3, Color.WHITE, Color.WHITE, r, 0.0)                   # reflet
		Adv3DMeshes.add_blob(st, Vector3(0.145 * sx, 0.78, 0.293), Vector3(0.012, 0.014, 0.008), 5, 3, Color.WHITE, Color.WHITE, r, 0.0)                   # petit reflet
	return st.commit()


static func _g_ear(sgn: float) -> Mesh:
	var st := _st()
	var r := _r(14)
	Adv3DMeshes.add_blob(st, Vector3(0.2 * sgn, 1.08, -0.02), Vector3(0.1, 0.31, 0.03), 8, 6, G_LEAF_D, G_LEAF_L, r, 0.0)                              # oreille-feuille
	Adv3DMeshes.add_blob(st, Vector3(0.2 * sgn, 1.05, 0.004), Vector3(0.055, 0.2, 0.02), 8, 5, Color(0.65, 0.38, 0.16), Color(0.85, 0.55, 0.25), r, 0.0)  # intérieur orangé
	return st.commit()


static func _g_paw_front(sgn: float) -> Mesh:
	var st := _st()
	var r := _r(15)
	var x: float = G_PAW_F.x * sgn
	Adv3DMeshes.add_cone(st, Vector3(x, 0.06, 0.17), 0.055, 0.065, 0.2, 8, G_GD, G_GL, r, 0.0, false)
	Adv3DMeshes.add_blob(st, Vector3(x, 0.05, 0.2), Vector3(0.075, 0.055, 0.1), 8, 5, G_GD, G_GL, r, 0.0)
	return st.commit()


static func _g_paw_back(sgn: float) -> Mesh:
	var st := _st()
	var r := _r(16)
	var x: float = G_PAW_B.x * sgn
	Adv3DMeshes.add_blob(st, Vector3(x, 0.17, -0.04), Vector3(0.1, 0.12, 0.14), 8, 5, G_GD, G_GL, r, 0.0)        # cuisse
	Adv3DMeshes.add_blob(st, Vector3(x, 0.045, 0.02), Vector3(0.08, 0.05, 0.13), 8, 5, G_GD, G_GL, r, 0.0)       # pied
	return st.commit()


static func _g_tail() -> Mesh:
	var st := _st()
	var r := _r(17)
	for t: Array in [[-0.16, 0.2, -0.33, 0.1, -0.5], [0.0, 0.25, -0.38, 0.11, 0.0], [0.16, 0.2, -0.33, 0.1, 0.5]]:
		Adv3DMeshes.add_blob(st, Vector3(t[0], t[1], t[2]), Vector3(0.06, 0.035, t[3] * 1.4), 6, 4, G_LEAF_D, G_LEAF_L, r, 0.0)
	return st.commit()
