class_name AdventureMobs
## AdventureMobs.gd — Groupes de monstres errants et contrats du mode Aventure (V22).
##
## Logique pure (aucun rendu), sur le dictionnaire d'état Aventure `adv` de la sauvegarde :
##   adv["mobs"][zone]      = [ {id, x, y, level, count, elite} ]  groupes visibles sur la carte
##   adv["mob_next"][zone]  = pas (adv.moves) à partir duquel un nouveau groupe peut apparaître
##   adv["mob_seq"]         = compteur d'identifiants
##   adv["mob_kills"][zone] = groupes vaincus sur la carte
##   adv["contracts"][zone] = contrat actif {kind, need, have, level, elite_id}
##   adv["contracts_done"]  = nombre de contrats remplis
##
## Les groupes, façon Dofus : 2 à 4 ennemis au niveau de la carte (+0 à +2), visibles,
## qui flânent quand le héros marche. Les toucher lance un combat Tactique de cette taille.
## Un groupe vaincu réapparaît ailleurs après RESPAWN_STEPS pas : la carte reste un terrain
## de chasse pour monter de niveau avant la carte suivante.

const PER_ZONE := 5
const RESPAWN_STEPS := 12
const WANDER_CHANCE := 0.35
const MIN_SPAWN_DIST := 3
const ELITE_BONUS_LEVEL := 4      # élite : haut de la fourchette + ELITE_BONUS_LEVEL / 2
const CONTRACT_EVERY_ELITE := 3     # un contrat sur trois est un contrat d'élite


## ProgressionManager (autoload) résolu à l'exécution : ProgressionManager dépend de ce
## script, une référence directe créerait une dépendance circulaire à la compilation.
static func _pm() -> Node:
	return (Engine.get_main_loop() as SceneTree).root.get_node("ProgressionManager")


static func _zone_list(adv: Dictionary, key: String, zone: String) -> Array:
	if not adv.has(key) or not (adv[key] is Dictionary):
		adv[key] = {}
	var d: Dictionary = adv[key]
	if not d.has(zone) or not (d[zone] is Array):
		d[zone] = []
	return d[zone]


## Groupes vivants d'une carte (liste modifiable en place).
static func groups(adv: Dictionary, zone: String) -> Array:
	return _zone_list(adv, "mobs", zone)


static func pos_of(g: Dictionary) -> Vector2i:
	return Vector2i(int(g.get("x", 0)), int(g.get("y", 0)))


## Groupe sur une case ({} sinon).
static func at(adv: Dictionary, zone: String, p: Vector2i) -> Dictionary:
	for g: Dictionary in groups(adv, zone):
		if pos_of(g) == p:
			return g
	return {}


static func by_id(adv: Dictionary, zone: String, id: int) -> Dictionary:
	for g: Dictionary in groups(adv, zone):
		if int(g.get("id", -1)) == id:
			return g
	return {}


## Cases occupées par un groupe : { Vector2i: true }.
static func occupied(adv: Dictionary, zone: String) -> Dictionary:
	var out: Dictionary = {}
	for g: Dictionary in groups(adv, zone):
		out[pos_of(g)] = true
	return out


## Case où un groupe peut se tenir : franchissable, ni lieu, ni porte, ni trouvaille, ni départ.
static func _free(adv: Dictionary, zone: String, p: Vector2i, hero: Vector2i) -> bool:
	if p == hero or not AdventureTerrain.walkable(zone, p):
		return false
	var t: Dictionary = AdventureTerrain.zone_terrain(zone)
	if (t["pois"] as Array).has(p) or (t["gates"] as Array).has(p) or p == t["start"]:
		return false
	if AdventureTerrain.finds_of(zone).has(p):
		return false
	return at(adv, zone, p).is_empty()


## Fourchette de niveaux des groupes par carte, DANS la tranche de sa nation
## (voir Nations.LEVEL_BANDS) : chaque nation occupe une tranche de niveaux distincte, les
## cartes d'une même nation se partagent la sienne. Hors liste : niveau de la carte à +2.
const LEVEL_RANGE := {
	"foret_sylve": [1, 7], "foret_ronces": [8, 14], "lisiere_col": [12, 17],
	"brasier_cendres": [18, 25], "brumes_marais": [26, 31],
	"montagne_pics": [32, 37], "piemont_ocre": [38, 41], "cretes_givre": [42, 45],
	"vents_plateau": [46, 54], "ombres_necropole": [55, 63], "desert_dunes": [64, 70],
	"marees_cotes": [71, 78], "cristaux_caverne": [79, 86], "rouages_atelier": [87, 93],
	"portes_donjon": [94, 100],
}

static func level_range(zone: String) -> Vector2i:
	if LEVEL_RANGE.has(zone):
		var r: Array = LEVEL_RANGE[zone]
		return Vector2i(int(r[0]), int(r[1]))
	var l: int = zone_level(zone)
	return Vector2i(l, l + 2)


## Niveau de base des groupes d'une carte.
static func zone_level(zone: String) -> int:
	return int(_pm().adventure_zone_level(zone))


## Tire un nouveau groupe (sans position).
static func roll_group(adv: Dictionary, zone: String, rng: RandomNumberGenerator, elite: bool = false) -> Dictionary:
	var seq: int = int(adv.get("mob_seq", 0)) + 1
	adv["mob_seq"] = seq
	var rg: Vector2i = level_range(zone)
	var count: int = 4 if elite else [2, 2, 3, 3, 4][rng.randi_range(0, 4)]
	# Les gros groupes tirent vers le haut de la fourchette.
	var level: int = rg.y + ELITE_BONUS_LEVEL / 2 if elite else rng.randi_range(rg.x, rg.y - (2 if count < 4 and rg.y - rg.x > 3 else 0))
	return {"id": seq, "x": 0, "y": 0, "level": maxi(1, level), "count": count, "elite": elite}


## Place un groupe sur une case libre loin du héros. Retourne false s'il n'y a pas de place.
static func place(adv: Dictionary, zone: String, g: Dictionary, hero: Vector2i, rng: RandomNumberGenerator) -> bool:
	var t: Dictionary = AdventureTerrain.zone_terrain(zone)
	var size: Vector2i = t["size"]
	var paths: Dictionary = t["paths"]
	var cands: Array[Vector2i] = []
	var off_path: Array[Vector2i] = []
	for y: int in range(size.y):
		for x: int in range(size.x):
			var c := Vector2i(x, y)
			if absi(c.x - hero.x) + absi(c.y - hero.y) < MIN_SPAWN_DIST or not _free(adv, zone, c, hero):
				continue
			cands.append(c)
			if not paths.has(c):
				off_path.append(c)
	var pool: Array[Vector2i] = off_path if not off_path.is_empty() else cands
	if pool.is_empty():
		return false
	var c2: Vector2i = pool[rng.randi_range(0, pool.size() - 1)]
	g["x"] = c2.x
	g["y"] = c2.y
	groups(adv, zone).append(g)
	return true


## Complète la carte en groupes : au premier passage elle est remplie ; ensuite un
## groupe réapparaît tous les RESPAWN_STEPS pas tant qu'il en manque.
## Retourne les groupes ajoutés.
static func ensure(adv: Dictionary, zone: String, hero: Vector2i, rng: RandomNumberGenerator) -> Array:
	var added: Array = []
	var list: Array = groups(adv, zone)
	if not adv.has("mob_next") or not (adv["mob_next"] is Dictionary):
		adv["mob_next"] = {}
	var nxt: Dictionary = adv["mob_next"]
	var moves: int = int(adv.get("moves", 0))
	var normal: int = list.filter(func(g: Dictionary) -> bool: return not bool(g.get("elite", false))).size()
	if not nxt.has(zone):
		# première visite : la carte se peuple d'un coup
		while normal < PER_ZONE:
			var g: Dictionary = roll_group(adv, zone, rng)
			if not place(adv, zone, g, hero, rng):
				break
			added.append(g)
			normal += 1
		nxt[zone] = moves + RESPAWN_STEPS
		return added
	if normal < PER_ZONE and moves >= int(nxt[zone]):
		var g2: Dictionary = roll_group(adv, zone, rng)
		if place(adv, zone, g2, hero, rng):
			added.append(g2)
		nxt[zone] = moves + RESPAWN_STEPS
	return added


## Les groupes flânent d'une case (sauf les élites et le groupe visé `frozen_id`).
## Retourne [{id, from, to}] pour l'animation.
static func wander(adv: Dictionary, zone: String, hero: Vector2i, rng: RandomNumberGenerator, frozen_id: int = -1) -> Array:
	var moved: Array = []
	for g: Dictionary in groups(adv, zone):
		if bool(g.get("elite", false)) or int(g.get("id", -1)) == frozen_id:
			continue
		if rng.randf() > WANDER_CHANCE:
			continue
		var from: Vector2i = pos_of(g)
		var dirs: Array = [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]
		dirs.shuffle()
		for d: Vector2i in dirs:
			var to: Vector2i = from + d
			if _free(adv, zone, to, hero) and absi(to.x - hero.x) + absi(to.y - hero.y) >= 1:
				g["x"] = to.x
				g["y"] = to.y
				moved.append({"id": int(g["id"]), "from": from, "to": to})
				break
	return moved


## Retire un groupe vaincu, compte la victoire et programme une réapparition.
static func defeat(adv: Dictionary, zone: String, id: int) -> Dictionary:
	var list: Array = groups(adv, zone)
	var gone: Dictionary = {}
	for i: int in range(list.size()):
		if int(list[i].get("id", -1)) == id:
			gone = list[i]
			list.remove_at(i)
			break
	if gone.is_empty():
		return {}
	var kills: Dictionary = adv.get("mob_kills", {})
	kills[zone] = int(kills.get(zone, 0)) + 1
	adv["mob_kills"] = kills
	if not adv.has("mob_next") or not (adv["mob_next"] is Dictionary):
		adv["mob_next"] = {}
	adv["mob_next"][zone] = int(adv.get("moves", 0)) + RESPAWN_STEPS
	return gone


## Clé du défi en attente pour un groupe : "mob:zone:id".
static func challenge_key(zone: String, id: int) -> String:
	return "mob:%s:%d" % [zone, id]


static func parse_challenge(key: String) -> Dictionary:
	if not key.begins_with("mob:"):
		return {}
	var parts: PackedStringArray = key.split(":")
	if parts.size() < 3:
		return {}
	return {"zone": parts[1], "id": int(parts[2])}


## Nom du groupe pour les fenêtres (« Groupe de 3 Gobelins », « Élite : … »).
static func label(g: Dictionary, biome: String) -> String:
	var types: Array = _pm().biome_enemy_types(biome)
	var t0: String = types[0] if not types.is_empty() else "monstres"
	var nl: String = Nations.enemy_label(t0, biome)
	var who: String = nl if nl != "" else t0
	if bool(g.get("elite", false)):
		return "Élite : bande de %s" % who
	return "Groupe de %d · %s" % [int(g.get("count", 3)), who]


# ═══════════════════════════════════════════════════════════════════════
#  Contrats (pris aux camps)
# ═══════════════════════════════════════════════════════════════════════

static func contract(adv: Dictionary, zone: String) -> Dictionary:
	return (adv.get("contracts", {}) as Dictionary).get(zone, {})


## Contrat proposé au camp de cette carte (pas encore accepté).
static func offer(adv: Dictionary, zone: String) -> Dictionary:
	var done: int = int(adv.get("contracts_done", 0))
	var rg: Vector2i = level_range(zone)
	var lvl: int = (rg.x + rg.y) / 2
	if (done + 1) % CONTRACT_EVERY_ELITE == 0:
		return {"kind": "elite", "need": 1, "have": 0, "level": lvl}
	return {"kind": "hunt", "need": 2 + (done % 2), "have": 0, "level": lvl}


static func contract_text(c: Dictionary) -> String:
	if c.is_empty():
		return ""
	if String(c.get("kind", "")) == "elite":
		return "Vaincre la bande d'élite de la carte (%d/%d)" % [int(c.get("have", 0)), int(c.get("need", 1))]
	return "Vaincre %d groupes de monstres sur cette carte (%d/%d)" % [int(c.get("need", 2)), int(c.get("have", 0)), int(c.get("need", 2))]


## Accepte le contrat proposé. Un contrat d'élite fait apparaître la bande d'élite.
static func accept(adv: Dictionary, zone: String, hero: Vector2i, rng: RandomNumberGenerator) -> Dictionary:
	if not contract(adv, zone).is_empty():
		return contract(adv, zone)
	var c: Dictionary = offer(adv, zone)
	if String(c["kind"]) == "elite":
		var g: Dictionary = roll_group(adv, zone, rng, true)
		if place(adv, zone, g, hero, rng):
			c["elite_id"] = int(g["id"])
		else:
			c = {"kind": "hunt", "need": 2, "have": 0, "level": int(c["level"])}
	var all: Dictionary = adv.get("contracts", {})
	all[zone] = c
	adv["contracts"] = all
	return c


## Avance le contrat de la carte après une victoire contre un groupe. Retourne le contrat
## rempli ({} s'il ne l'est pas encore) : la récompense est versée par _pm().
static func progress(adv: Dictionary, zone: String, g: Dictionary) -> Dictionary:
	var c: Dictionary = contract(adv, zone)
	if c.is_empty():
		return {}
	if String(c.get("kind", "")) == "elite":
		if int(g.get("id", -1)) == int(c.get("elite_id", -2)):
			c["have"] = 1
	else:
		c["have"] = int(c.get("have", 0)) + 1
	if int(c["have"]) < int(c["need"]):
		return {}
	(adv["contracts"] as Dictionary).erase(zone)
	adv["contracts_done"] = int(adv.get("contracts_done", 0)) + 1
	return c
