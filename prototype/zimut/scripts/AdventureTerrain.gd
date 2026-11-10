class_name AdventureTerrain
extends RefCounted
## AdventureTerrain.gd — Terrain d'une zone d'Aventure (logique pure, sans rendu).
##
## Le catalogue officiel (ProgressionManager.ADVENTURE_ZONES / ADVENTURE_POIS) ne
## décrit que la taille de la zone, son départ et ses lieux. Ce script en déduit,
## de façon DÉTERMINISTE (même zone = même terrain, d'une partie à l'autre) :
##   • des obstacles de décor (arbres, rochers, pins, cactus…) qui bloquent le passage ;
##   • les sentiers qui relient le départ à chaque lieu (dessinés au sol) ;
##   • le plus court chemin entre deux cases (déplacement par appui sur une case).
##   • les portes vers les cartes voisines (milieu des bords) et les sentiers qui y mènent ;
##   • le biome de chaque case (cartes de lisière : un biome voisin déborde sur un côté).
## Garanties : jamais d'obstacle sur le départ, un lieu, une porte ou un sentier, et
## chaque lieu et chaque porte reste accessible depuis le départ.

const OBSTACLE_RATIO := 0.16

## Décors bloquants et décors de sol (non bloquants) par biome — noms de BattleScenery.draw_prop.
const OBSTACLES := {
	"Forêt": ["tree", "tree", "big_tree", "rock", "hedge", "stump"],
	"Montagne": ["pine", "pine", "rock_snow", "crystal", "pine", "rock_snow"],
	"Désert": ["cactus", "sand_pillar", "palm", "rock", "cactus", "jar"],
	"Donjon": ["stone_pillar", "rubble", "crate", "torch", "rubble", "banner"],
}
const GROUND_DECOR := {
	"Forêt": ["flowers", "grass", "mushrooms", "grass", "reeds"],
	"Montagne": ["snow_mound", "grass", "log", "stakes"],
	"Désert": ["dry_grass", "bones", "dry_grass", "log"],
	"Donjon": ["bones", "chains", "rubble"],
}

static var _cache: Dictionary = {}


## Obstacles bloquants d'un biome (les nations utilisent leurs propres décors).
## Autoload ProgressionManager, résolu à l'exécution : un identifiant global ne compile pas quand un
## script (test headless) charge ce fichier avant que les autoloads n'existent.
static func _pm() -> Node:
	return (Engine.get_main_loop() as SceneTree).root.get_node("ProgressionManager")


static func _obstacles_for(biome: String) -> Array:
	if SpriteDecor.active(biome):
		return SpriteDecor.OBSTACLES
	if Nations.is_new(biome):
		var inf: Dictionary = Nations.info(biome)
		return [inf["obs_tree"], inf["obs_tree"], inf["obs_rock"], inf["obs_rock"], inf["obs_tree"]]
	return OBSTACLES.get(biome, OBSTACLES["Forêt"])


## Décors de sol (non bloquants) d'un biome.
static func _ground_for(biome: String) -> Array:
	if SpriteDecor.active(biome):
		return SpriteDecor.GROUND
	if Nations.is_new(biome):
		var out: Array = []
		for e: Array in Nations.info(biome).get("props", []):
			var k: String = String(e[0])
			if k in ["glow_orb", "fog_puff", "cloud_puff", "shell_big", "coral", "driftwood", "bones", "rubble", "smoke_vent", "thorn_bush", "stalagmite", "feather_banner", "mushroom_big"]:
				out.append(k)
		return out if not out.is_empty() else ["bones"]
	return GROUND_DECOR.get(biome, GROUND_DECOR["Forêt"])


## Trouvailles cachées d'une zone (déterministes) : { Vector2i : kind } avec kind ∈ herb | gold | relic.
static func finds_of(zone_id: String) -> Dictionary:
	var t: Dictionary = zone_terrain(zone_id)
	var size: Vector2i = t["size"]
	var rng := RandomNumberGenerator.new()
	rng.seed = absi(zone_id.hash()) + 777
	var out: Dictionary = {}
	var kinds: Array = ["herb", "gold", "herb", "relic", "gold", "herb", "herb", "relic", "gold", "herb"]
	var guard: int = 0
	while out.size() < kinds.size() and guard < 300:
		guard += 1
		var c := Vector2i(rng.randi_range(0, size.x - 1), rng.randi_range(0, size.y - 1))
		if (t["voids"] as Dictionary).has(c) or (t["obstacles"] as Dictionary).has(c) or (t["pois"] as Array).has(c) or (t["gates"] as Array).has(c) or c == t["start"] or out.has(c):
			continue
		# dispersées : pas deux trouvailles voisines
		var near: bool = false
		for o: Vector2i in out.keys():
			if absi(o.x - c.x) + absi(o.y - c.y) < 3:
				near = true
		if near:
			continue
		out[c] = kinds[out.size()]
	return out

const DIRS := {"N": Vector2i(0, -1), "E": Vector2i(1, 0), "S": Vector2i(0, 1), "W": Vector2i(-1, 0)}


# ── Monde en grille (logique pure, utilisée aussi par ProgressionManager) ──
static func grid_of(zone_id: String) -> Vector2i:
	var g: Array = _pm().ADVENTURE_ZONES.get(zone_id, {}).get("grid", [0, 0])
	return Vector2i(int(g[0]), int(g[1]))


## Carte voisine dans une direction ("" si le bord donne sur le vide).
static func neighbor(zone_id: String, dir: String) -> String:
	var target: Vector2i = grid_of(zone_id) + DIRS.get(dir, Vector2i.ZERO)
	for other: String in _pm().ADVENTURE_ZONES.keys():
		if other != zone_id and grid_of(other) == target:
			return other
	return ""


## Case de la porte d'un bord : milieu du côté (axe x de la grille = est/ouest).
static func gate_cell(zone_id: String, dir: String) -> Vector2i:
	var sz: Array = _pm().ADVENTURE_ZONES.get(zone_id, {}).get("size", [14, 10])
	var w: int = int(sz[0])
	var h: int = int(sz[1])
	match dir:
		"N": return Vector2i(w / 2, 0)
		"S": return Vector2i(w / 2, h - 1)
		"W": return Vector2i(0, h / 2)
		_: return Vector2i(w - 1, h / 2)


## Portes d'une carte : { Vector2i : {"dir", "to"} }.
static func gates_of(zone_id: String) -> Dictionary:
	var out: Dictionary = {}
	if not BoardArt.def(zone_id).is_empty():
		return out          # V83 : une planche illustrée n'a pas de portes (voyage par la carte du monde)
	for dir: String in DIRS.keys():
		var to: String = neighbor(zone_id, dir)
		if to != "":
			out[gate_cell(zone_id, dir)] = {"dir": dir, "to": to}
	return out


## V47 : contour irrégulier. Cases « hors île » d'une zone (méta "shape" de ADVENTURE_ZONES).
## Elles sont infranchissables et non dessinées. Les deux bords de façade (dernière ligne
## et dernière colonne, où est dessinée la falaise) restent pleins ; les portes, le départ,
## les lieux et leurs abords ne sont jamais coupés. Déterministe (même zone = même contour).
static func voids_of(zone_id: String) -> Dictionary:
	var meta: Dictionary = _pm().ADVENTURE_ZONES.get(zone_id, {})
	var out: Dictionary = {}
	var shape: String = String(meta.get("shape", ""))
	if shape == "":
		return out
	var sz: Array = meta.get("size", [14, 10])
	var w: int = int(sz[0])
	var h: int = int(sz[1])
	var st: Array = meta.get("start", [1, 3])
	var keep: Array[Vector2i] = [Vector2i(int(st[0]), int(st[1]))]
	for k: String in _pm().pois_of(zone_id).keys():
		keep.append(parse(k))
	for g: Vector2i in gates_of(zone_id).keys():
		keep.append(g)
	# Portes possibles (même sans voisin) : on garde leurs abords libres par prudence.
	for dir: String in DIRS.keys():
		keep.append(gate_cell(zone_id, dir))
	var rng := RandomNumberGenerator.new()
	rng.seed = absi(zone_id.hash()) + 2026
	var cuts: Array[Vector2i] = []
	# Coin nord (0,0) : morsure en escalier.
	var depth_n: int = rng.randi_range(4, 6)
	for y: int in range(h):
		for x: int in range(w):
			if x + y < depth_n - 1:
				cuts.append(Vector2i(x, y))
	# Coins ouest-sud et nord-est : morsures plus courtes, bords du fond uniquement.
	var depth_w: int = rng.randi_range(3, 4)
	for i: int in range(depth_w):
		for j: int in range(depth_w - i):
			cuts.append(Vector2i(j, h - 2 - i))      # coin sud-ouest (hors dernière ligne)
			cuts.append(Vector2i(w - 2 - i, j))      # coin nord-est (hors dernière colonne)
	# Anse sur le bord nord et sur le bord ouest (loin des portes).
	var nx: int = rng.randi_range(3, maxi(3, w / 2 - 4))
	cuts.append_array([Vector2i(nx, 0), Vector2i(nx + 1, 0), Vector2i(nx + 1, 1)])
	var wy: int = rng.randi_range(h / 2 + 3, maxi(h / 2 + 3, h - 4))
	cuts.append_array([Vector2i(0, wy), Vector2i(0, wy + 1), Vector2i(1, wy)])
	# Ravin intérieur : une faille de 7 cases traversée par un pont de 2 cases au milieu.
	var rx: int = w * 2 / 3
	var ry: int = h / 3
	for dy: int in range(-3, 4):
		cuts.append(Vector2i(rx, ry + dy))
		cuts.append(Vector2i(rx + 1, ry + dy))
	cuts.erase(Vector2i(rx, ry))
	cuts.erase(Vector2i(rx + 1, ry))
	cuts.erase(Vector2i(rx, ry + 1))
	cuts.erase(Vector2i(rx + 1, ry + 1))
	# Petit étang au sud-ouest.
	cuts.append_array([Vector2i(2, h - 4), Vector2i(3, h - 4), Vector2i(2, h - 3), Vector2i(3, h - 3)])
	for c: Vector2i in cuts:
		if c.x < 0 or c.y < 0 or c.x >= w - 1 or c.y >= h - 1:
			continue
		var protected_cell: bool = false
		for kp: Vector2i in keep:
			if absi(kp.x - c.x) + absi(kp.y - c.y) <= 2:
				protected_cell = true
				break
		if not protected_cell:
			out[c] = true
	# Sécurité : seules les cases reliées au départ restent jouables ; une poche isolée par les
	# coupes devient « hors île ». Si un lieu ou une porte était isolé, on renonce au contour.
	var reach: Dictionary = _reachable(Vector2i(w, h), out, keep[0])
	for y: int in range(h):
		for x: int in range(w):
			var c2 := Vector2i(x, y)
			if not out.has(c2) and not reach.has(c2):
				out[c2] = true
	for kp2: Vector2i in keep:
		if out.has(kp2):
			return {}
	return out


## Cases atteignables depuis `from` sans traverser `voids` : { Vector2i: true }.
static func _reachable(size: Vector2i, voids: Dictionary, from: Vector2i) -> Dictionary:
	var seen: Dictionary = {from: true}
	var queue: Array[Vector2i] = [from]
	var head: int = 0
	while head < queue.size():
		var cur: Vector2i = queue[head]
		head += 1
		for d: Vector2i in [Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(0, -1)]:
			var n: Vector2i = cur + d
			if _inside(size, n) and not voids.has(n) and not seen.has(n):
				seen[n] = true
				queue.append(n)
	return seen


static func key(p: Vector2i) -> String:
	return "%d,%d" % [p.x, p.y]


static func parse(k: String) -> Vector2i:
	var parts: PackedStringArray = k.split(",")
	if parts.size() < 2:
		return Vector2i(-1, -1)
	return Vector2i(int(parts[parts.size() - 2]), int(parts[parts.size() - 1]))


## Données de terrain d'une zone : { size, start, biome, obstacles {Vector2i: kind},
##   paths {Vector2i: true}, decor {Vector2i: kind}, pois [Vector2i], gates [Vector2i],
##   voids {Vector2i: true} (cases hors île, V47),
##   cell_biome {Vector2i: biome} (uniquement les cases d'un autre biome que la carte) }
## V83 : terrain d'une planche illustrée : cases jouables = masque, aucun décor généré.
static func _board_terrain(zone_id: String) -> Dictionary:
	var key: String = "board:%s:%d" % [BoardArt.file_stem(zone_id), BoardArt.rev]
	if _cache.has(key):
		return _cache[key]
	var meta: Dictionary = _pm().ADVENTURE_ZONES.get(zone_id, {})
	var pois: Array[Vector2i] = []
	for k: String in BoardArt.pois(zone_id).keys():
		pois.append(parse(k))
	var paths: Dictionary = {}
	var sz: Vector2i = BoardArt.size(zone_id)
	for y: int in range(sz.y):
		for x: int in range(sz.x):
			if BoardArt.walkable_cell(zone_id, Vector2i(x, y)):
				paths[Vector2i(x, y)] = true
	var obstacles: Dictionary = {}
	var decor: Dictionary = {}
	var heights: Dictionary = {}
	if BoardArt.is_iso(zone_id):
		# V106 : plateau isométrique — sentiers, arbres, décors et hauteurs viennent des données de la planche.
		var d: Dictionary = BoardArt.raw(zone_id)
		paths = {}
		for k: Variant in d.get("trail", []):
			paths[parse(String(k))] = true
		for k: String in (d.get("obstacles", {}) as Dictionary).keys():
			obstacles[parse(k)] = String(d["obstacles"][k])
		for k: String in (d.get("decor", {}) as Dictionary).keys():
			decor[parse(k)] = String(d["decor"][k])
		heights = BoardArt.heights(zone_id)
		# V117 : le diorama est un rendu : ses hauteurs servent à poser le héros sur le sol,
		# pas à bloquer la marche (une pente douce quantifiée y ferait de fausses falaises).
		if BoardArt.is_diorama(zone_id):
			heights = {}
	var out: Dictionary = {"size": sz, "start": BoardArt.start(zone_id), "biome": String(meta.get("biome", "Forêt")),
		"obstacles": obstacles, "paths": paths, "decor": decor, "pois": pois, "gates": [] as Array[Vector2i],
		"cell_biome": {}, "voids": BoardArt.voids(zone_id), "heights": heights}
	_cache[key] = out
	return out


static func zone_terrain(zone_id: String) -> Dictionary:
	if not BoardArt.def(zone_id).is_empty():
		return _board_terrain(zone_id)
	if _cache.has(zone_id):
		return _cache[zone_id]
	var meta: Dictionary = _pm().ADVENTURE_ZONES.get(zone_id, {})
	var sz: Array = meta.get("size", [14, 10])
	var size := Vector2i(int(sz[0]), int(sz[1]))
	var st: Array = meta.get("start", [1, 3])
	var start := Vector2i(int(st[0]), int(st[1]))
	var biome: String = String(meta.get("biome", "Forêt"))
	var pois: Array[Vector2i] = []
	for k: String in _pm().pois_of(zone_id).keys():
		pois.append(parse(k))
	var gates: Array[Vector2i] = []
	for g: Vector2i in gates_of(zone_id).keys():
		gates.append(g)
	var rng := RandomNumberGenerator.new()
	rng.seed = absi(zone_id.hash()) + 4099
	var voids: Dictionary = voids_of(zone_id)

	# 0) Lisière : un biome voisin gagne un côté de la carte (bord irrégulier).
	var cell_biome: Dictionary = {}
	var blend: Dictionary = meta.get("blend", {})
	if not blend.is_empty():
		var other: String = String(blend.get("biome", biome))
		var side: String = String(blend.get("side", "N"))
		for y: int in range(size.y):
			for x: int in range(size.x):
				var fx: float = float(x) / float(maxi(1, size.x - 1))
				var fy: float = float(y) / float(maxi(1, size.y - 1))
				var t: float = {"N": 1.0 - fy, "S": fy, "W": 1.0 - fx, "E": fx}.get(side, 0.0)
				if t + rng.randf_range(-0.16, 0.16) > 0.58:
					cell_biome[Vector2i(x, y)] = other

	# 1) Sentiers : réseau en arbre qui serpente de lieu en lieu (V142, voir _trail_network).
	var paths: Dictionary = _trail_network(size, voids, start, pois, gates, absi(zone_id.hash()) + 14200)

	# 2) Obstacles : bosquets aléatoires hors sentiers / lieux / départ / abords des portes.
	var obstacles: Dictionary = {}
	var gate_mouth: Dictionary = {}
	for g: Vector2i in gates:
		for d: Vector2i in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
			gate_mouth[g + d] = true
	var wanted: int = int(float(size.x * size.y) * OBSTACLE_RATIO)
	var guard: int = 0
	while obstacles.size() < wanted and guard < 400:
		guard += 1
		var c := Vector2i(rng.randi_range(0, size.x - 1), rng.randi_range(0, size.y - 1))
		if voids.has(c) or paths.has(c) or gate_mouth.has(c) or pois.has(c) or gates.has(c) or obstacles.has(c) or c.distance_to(Vector2(start)) < 1.5:
			continue
		var kinds: Array = _obstacles_for(String(cell_biome.get(c, biome)))
		obstacles[c] = String(kinds[rng.randi_range(0, kinds.size() - 1)])
		# Bosquet : une case voisine de temps en temps
		if rng.randf() < 0.45:
			var n: Vector2i = c + [Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(0, -1)][rng.randi_range(0, 3)]
			if _inside(size, n) and not voids.has(n) and not paths.has(n) and not gate_mouth.has(n) and not pois.has(n) and not gates.has(n) and not obstacles.has(n) and n != start:
				var nk: Array = _obstacles_for(String(cell_biome.get(n, biome)))
				obstacles[n] = String(nk[rng.randi_range(0, nk.size() - 1)])

	# 3) Sécurité : chaque lieu et chaque porte reste accessible (sans traverser une
	#    autre porte, que le héros franchirait) ; sinon on retire les obstacles fautifs.
	for p: Vector2i in pois + gates:
		var tries: int = 0
		while _bfs_path(size, _with_gates(_merge(obstacles, voids), gates, p), start, p).is_empty() and tries < 40 and not obstacles.is_empty():
			tries += 1
			var best: Vector2i = obstacles.keys()[0]
			var best_d: float = INF
			for o: Vector2i in obstacles.keys():
				var d: float = o.distance_to(Vector2(p)) + o.distance_to(Vector2(start)) * 0.25
				if d < best_d:
					best_d = d
					best = o
			obstacles.erase(best)

	# 4) Décors de sol non bloquants (fleurs, herbes…) sur quelques cases libres.
	var decor: Dictionary = {}
	for y: int in range(size.y):
		for x: int in range(size.x):
			var c2 := Vector2i(x, y)
			if voids.has(c2) or obstacles.has(c2) or pois.has(c2) or paths.has(c2) or gates.has(c2) or c2 == start:
				continue
			var gkinds: Array = _ground_for(String(cell_biome.get(c2, biome)))
			if rng.randf() < 0.28:   # V81 : un peu plus de fleurs/herbes sur les grandes zones
				decor[c2] = String(gkinds[rng.randi_range(0, gkinds.size() - 1)])
	var out: Dictionary = {"size": size, "start": start, "biome": biome, "obstacles": obstacles,
		"paths": paths, "decor": decor, "pois": pois, "gates": gates, "cell_biome": cell_biome, "voids": voids}
	_cache[zone_id] = out
	return out


## V142 : réseau de sentiers « naturel ». Avant, chaque lieu recevait son plus court chemin depuis le
## départ : tous longeaient le même axe puis partaient à angle droit (un peigne de couloirs parallèles).
## Ici chaque lieu, du plus proche au plus lointain, se raccorde au point de sentier DÉJÀ tracé le plus
## proche ; le tracé suit un relief de coûts (bruit lissé) qui le fait serpenter, évite le bord des
## vides et réutilise volontiers un sentier voisin. Déterministe (même zone = mêmes sentiers).
static func _trail_network(size: Vector2i, voids: Dictionary, start: Vector2i, pois: Array[Vector2i],
		gates: Array[Vector2i], trail_seed: int) -> Dictionary:
	var paths: Dictionary = {start: true}
	if size.x < 2 or size.y < 2:
		return paths
	var rng := RandomNumberGenerator.new()
	rng.seed = trail_seed
	# Relief de coûts : valeurs tirées sur un treillis grossier (une toutes les 3 cases), interpolées.
	const STEP := 3
	var gw: int = size.x / STEP + 2
	var gh: int = size.y / STEP + 2
	var lattice := PackedFloat32Array()
	lattice.resize(gw * gh)
	for i: int in range(gw * gh):
		lattice[i] = rng.randf()
	var grid := AStarGrid2D.new()
	grid.region = Rect2i(Vector2i.ZERO, size)
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	grid.update()
	var gate_set: Dictionary = {}
	for g: Vector2i in gates:
		gate_set[g] = true
	for y: int in range(size.y):
		for x: int in range(size.x):
			var c := Vector2i(x, y)
			if voids.has(c):
				grid.set_point_solid(c, true)
				continue
			var fx: float = float(x) / float(STEP)
			var fy: float = float(y) / float(STEP)
			var ix: int = int(fx)
			var iy: int = int(fy)
			var tx: float = fx - float(ix)
			var ty: float = fy - float(iy)
			tx = tx * tx * (3.0 - 2.0 * tx)
			ty = ty * ty * (3.0 - 2.0 * ty)
			var n: float = lerpf(lerpf(lattice[iy * gw + ix], lattice[iy * gw + ix + 1], tx),
				lerpf(lattice[(iy + 1) * gw + ix], lattice[(iy + 1) * gw + ix + 1], tx), ty)
			var cost: float = 1.0 + 6.0 * n * n + 1.6 * rng.randf()      # relief + grain fin : le tracé ondule
			for d: Vector2i in [Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(0, -1)]:
				if voids.has(c + d) or not _inside(size, c + d):
					cost += 1.5          # un sentier ne longe pas le vide ni le bord de l'île
					break
			if gate_set.has(c):
				cost += 40.0             # on ne traverse pas une porte pour aller ailleurs
			grid.set_point_weight_scale(c, cost)
	# Du plus proche au plus lointain : chaque lieu rejoint le sentier existant le plus proche.
	var targets: Array[Vector2i] = []
	targets.append_array(pois)
	targets.append_array(gates)
	targets.sort_custom(func(a: Vector2i, b: Vector2i) -> bool:
		var da: int = absi(a.x - start.x) + absi(a.y - start.y)
		var db: int = absi(b.x - start.x) + absi(b.y - start.y)
		return da < db if da != db else (a.x < b.x if a.x != b.x else a.y < b.y))
	for t: Vector2i in targets:
		if paths.has(t) or voids.has(t) or not _inside(size, t):
			continue
		var best: Vector2i = start
		var best_d: int = 1 << 30
		for pc: Vector2i in paths.keys():
			if gate_set.has(pc):
				continue
			var dd: int = absi(pc.x - t.x) + absi(pc.y - t.y)
			if dd < best_d or (dd == best_d and (pc.x < best.x or (pc.x == best.x and pc.y < best.y))):
				best_d = dd
				best = pc
		var route: Array[Vector2i] = grid.get_id_path(best, t)
		if route.is_empty():
			route = _bfs_path(size, voids, start, t)      # repli : plus court chemin depuis le départ
		for rc: Vector2i in route:
			if not paths.has(rc):
				paths[rc] = true
				if not gate_set.has(rc):
					grid.set_point_weight_scale(rc, 0.45)     # un sentier tracé attire les suivants
	return paths


static func _merge(a: Dictionary, b: Dictionary) -> Dictionary:
	var out: Dictionary = a.duplicate()
	for k: Vector2i in b.keys():
		out[k] = true
	return out


static func _with_gates(walls: Dictionary, gates: Array[Vector2i], target: Vector2i) -> Dictionary:
	var out: Dictionary = walls.duplicate()
	for g: Vector2i in gates:
		if g != target:
			out[g] = true
	return out


## Biome d'une case (lisières : biome voisin sur un côté de la carte).
static func cell_biome(zone_id: String, p: Vector2i) -> String:
	var t: Dictionary = zone_terrain(zone_id)
	return String((t["cell_biome"] as Dictionary).get(p, t["biome"]))


static func _inside(size: Vector2i, p: Vector2i) -> bool:
	return p.x >= 0 and p.y >= 0 and p.x < size.x and p.y < size.y


## Case franchissable (dans la zone et sans obstacle).
static func walkable(zone_id: String, p: Vector2i) -> bool:
	var t: Dictionary = zone_terrain(zone_id)
	return _inside(t["size"], p) and not (t["obstacles"] as Dictionary).has(p) and not (t["voids"] as Dictionary).has(p)


## Plus court chemin (4 directions), départ exclu ; [] si inaccessible.
## `blocked` : cases interdites en plus des obstacles (sauf la destination).
static func find_path(zone_id: String, from: Vector2i, to: Vector2i, blocked: Dictionary = {}) -> Array[Vector2i]:
	var t: Dictionary = zone_terrain(zone_id)
	var tsz: Vector2i = t["size"]
	if tsz.x * tsz.y >= ASTAR_MIN_CELLS:
		return _astar_path(t, from, to, blocked)
	var walls: Dictionary = _merge(t["obstacles"], t["voids"])
	for b: Vector2i in blocked.keys():
		if b != to:
			walls[b] = true
	return _bfs_path(t["size"], walls, from, to, t.get("heights", {}))


## V139 : cases d'une ligne droite de `a` à `b` sur la grille (4 voisins, `a` exclu, `b` inclus) : l'escalier
## le plus régulier possible, qui colle au segment a-b.
static func grid_line(a: Vector2i, b: Vector2i) -> Array[Vector2i]:
	var out: Array[Vector2i] = []
	var dx: int = absi(b.x - a.x)
	var dy: int = absi(b.y - a.y)
	var sx: int = signi(b.x - a.x)
	var sy: int = signi(b.y - a.y)
	var ix: int = 0
	var iy: int = 0
	var c: Vector2i = a
	while ix < dx or iy < dy:
		# avance sur l'axe le plus « en retard » par rapport au segment
		if iy >= dy or (ix < dx and (2 * ix + 1) * dy <= (2 * iy + 1) * dx):
			c.x += sx
			ix += 1
		else:
			c.y += sy
			iy += 1
		out.append(c)
	return out


## V139 : redresse un chemin. Un plus court chemin sur grille peut longer un axe puis l'autre, ou zigzaguer
## sans régularité ; ici chaque tronçon est remplacé par la ligne droite de grille entre deux de ses points
## quand toutes ses cases sont libres (même nombre de pas). Le héros marche alors en lignes droites.
static func straighten_path(zone_id: String, from: Vector2i, path: Array[Vector2i], blocked: Dictionary = {}) -> Array[Vector2i]:
	if path.size() < 3:
		return path
	var t: Dictionary = zone_terrain(zone_id)
	if not t.has("_walls"):
		t["_walls"] = _merge(t["obstacles"], t["voids"])
	var walls: Dictionary = t["_walls"]
	var heights: Dictionary = t.get("heights", {})
	var size: Vector2i = t["size"]
	var pts: Array[Vector2i] = [from]
	pts.append_array(path)
	var goal: Vector2i = path[path.size() - 1]
	var out: Array[Vector2i] = []
	var a: int = 0
	while a < pts.size() - 1:
		var hi: int = mini(pts.size() - 1, a + 64)
		var done: bool = false
		var span: int = hi - a
		while span >= 2 and not done:
			var b: int = a + span
			var line: Array[Vector2i] = grid_line(pts[a], pts[b])
			if line.size() <= span:
				var ok: bool = true
				var prev: Vector2i = pts[a]
				for c: Vector2i in line:
					if not _inside(size, c) or walls.has(c) or (blocked.has(c) and c != goal) \
							or (not heights.is_empty() and absi(int(heights.get(c, 0)) - int(heights.get(prev, 0))) > 1):
						ok = false
						break
					prev = c
				if ok:
					out.append_array(line)
					a = b
					done = true
			span = span * 3 / 4 if span > 4 else span - 1
		if not done:
			a += 1
			out.append(pts[a])
	return out


## Une marche d'une case à sa voisine est-elle possible ? (V106 : pas de falaise : écart ≤ 1 quart d'étage)
static func can_step(zone_id: String, a: Vector2i, b: Vector2i) -> bool:
	var hs: Dictionary = zone_terrain(zone_id).get("heights", {})
	return hs.is_empty() or absi(int(hs.get(b, 0)) - int(hs.get(a, 0))) <= 1


## V117 : grandes cartes (planches 144×144…) : recherche de chemin native (AStar2D, construite une fois par
## carte et gardée dans le terrain en cache) au lieu d'un parcours en largeur en GDScript (~100 ms par appui).
## Mêmes règles que _bfs_path : 4 voisins, murs = obstacles + vides, falaise si écart de hauteur > 1,
## cases « blocked » fermées le temps de la requête (sauf la destination). Chemin le plus court équivalent.
const ASTAR_MIN_CELLS := 4000

static func _astar_of(t: Dictionary) -> AStar2D:
	if t.has("_astar"):
		return t["_astar"]
	var size: Vector2i = t["size"]
	var walls: Dictionary = _merge(t["obstacles"], t["voids"])
	var heights: Dictionary = t.get("heights", {})
	var a := AStar2D.new()
	a.reserve_space(size.x * size.y)
	for y: int in range(size.y):
		for x: int in range(size.x):
			var c := Vector2i(x, y)
			if not walls.has(c):
				a.add_point(y * size.x + x, Vector2(x, y))
	for y: int in range(size.y):
		for x: int in range(size.x):
			var id: int = y * size.x + x
			if not a.has_point(id):
				continue
			for d: Vector2i in [Vector2i(1, 0), Vector2i(0, 1)]:
				var n := Vector2i(x, y) + d
				if not _inside(size, n):
					continue
				var nid: int = n.y * size.x + n.x
				if not a.has_point(nid):
					continue
				if not heights.is_empty() and absi(int(heights.get(n, 0)) - int(heights.get(Vector2i(x, y), 0))) > 1:
					continue
				a.connect_points(id, nid)
	t["_astar"] = a
	return a


static func _astar_path(t: Dictionary, from: Vector2i, to: Vector2i, blocked: Dictionary) -> Array[Vector2i]:
	var out: Array[Vector2i] = []
	var size: Vector2i = t["size"]
	if from == to or not _inside(size, to) or not _inside(size, from):
		return out
	var a: AStar2D = _astar_of(t)
	var fid: int = from.y * size.x + from.x
	var tid: int = to.y * size.x + to.x
	if not a.has_point(tid) or not a.has_point(fid):
		return out
	var closed: Array[int] = []
	for b: Vector2i in blocked.keys():
		if b == to or b == from or not _inside(size, b):
			continue
		var bid: int = b.y * size.x + b.x
		if a.has_point(bid) and not a.is_point_disabled(bid):
			a.set_point_disabled(bid, true)
			closed.append(bid)
	var ids: PackedInt64Array = a.get_id_path(fid, tid)
	for bid: int in closed:
		a.set_point_disabled(bid, false)
	for i: int in range(1, ids.size()):
		out.append(Vector2i(int(ids[i]) % size.x, int(ids[i]) / size.x))
	return out


static func _bfs_path(size: Vector2i, walls: Dictionary, from: Vector2i, to: Vector2i, heights: Dictionary = {}) -> Array[Vector2i]:
	var out: Array[Vector2i] = []
	if from == to or not _inside(size, to) or walls.has(to):
		return out
	var came: Dictionary = {from: from}
	var queue: Array[Vector2i] = [from]
	var head: int = 0
	while head < queue.size():
		var cur: Vector2i = queue[head]
		head += 1
		if cur == to:
			break
		for d: Vector2i in [Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(0, -1)]:
			var n: Vector2i = cur + d
			if not _inside(size, n) or walls.has(n) or came.has(n):
				continue
			if not heights.is_empty() and absi(int(heights.get(n, 0)) - int(heights.get(cur, 0))) > 1:
				continue          # falaise
			came[n] = cur
			queue.append(n)
	if not came.has(to):
		return out
	var p: Vector2i = to
	while p != from:
		out.push_front(p)
		p = came[p]
	return out
