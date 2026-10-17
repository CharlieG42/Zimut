class_name ConquestSystem
extends RefCounted
## Cœur de la campagne Conquête, V14 : villes évolutives, garnisons, héros
## gouverneurs, offensives annoncées et événements entre les batailles.
##
## Tout est stocké dans data["conquest"] (rétro-compatible : chaque clé a une
## valeur par défaut), et toutes les fonctions sont statiques pour être testées
## sans interface. ProgressionManager garde les points d'entrée publics
## (conquest_*) et passe ici le catalogue de routes (pas d'autoload en static).
##
## Clés de data["conquest"] ajoutées :
##   city_levels {id:int}        niveau 1..3 (Hameau / Bourg / Cité)
##   garrisons   {id:{troops,hero}}
##   threat      {city,power,eta}   offensive annoncée (compte à rebours en batailles)
##   event_pending {…}           événement à trancher par le joueur
##   news        [String]        nouvelles de la dernière bataille (affichées puis vidées)
##   truce int                   batailles restantes sans raid ni offensive
##   lost        [id]            villes perdues (reprise en 1 bataille)
##   rewarded    [id]            villes dont le butin d'annexion a déjà été versé
##   battle_count, event_cd, threat_cd

const MAX_LEVEL := 3
const LEVEL_NAMES: Array[String] = ["Hameau", "Bourg", "Cité"]
const TROOP_COST := 30
const WALL_DEFENSE := 6
const RAID_CHANCE := 0.35
const RAVAGE_BATTLES := 3
const THREAT_ETA := 3
const THREAT_MIN_GAP := 5
const THREAT_CHANCE := 0.35
const EVENT_MIN_GAP := 2
const EVENT_CHANCE := 0.45
const RES_KEYS: Array[String] = ["Bois", "Fer", "Cuir", "Magie", "Venin"]

## Coût (or + ressources) pour atteindre le niveau clé.
const UPGRADE := {
	2: {"gold": 120, "res": {"Bois": 10, "Fer": 10}},
	3: {"gold": 300, "res": {"Fer": 20, "Cuir": 10, "Magie": 10}},
}

## Effets d'un héros gouverneur, par classe : def = défense en plus,
## gold = or par bataille, res = ressources par bataille, heal = soldats
## recrutés gratuitement par bataille dans sa ville.
const GOVERNOR := {
	"Tank":       {"def": 8, "gold": 0, "res": {}, "heal": 0, "text": "Rempart vivant : +8 défense"},
	"Assassin":   {"def": 0, "gold": 4, "res": {}, "heal": 0, "text": "Réseau d'informateurs : +4 or par bataille"},
	"Chasseur":   {"def": 2, "gold": 0, "res": {"Cuir": 2}, "heal": 0, "text": "Chasse et peaux : +2 Cuir par bataille"},
	"Mage":       {"def": 2, "gold": 0, "res": {"Magie": 1}, "heal": 0, "text": "Tour d'étude : +1 Magie par bataille"},
	"Druide":     {"def": 0, "gold": 0, "res": {"Bois": 2, "Venin": 1}, "heal": 0, "text": "Jardins sacrés : +2 Bois, +1 Venin"},
	"Heal":       {"def": 0, "gold": 0, "res": {}, "heal": 1, "text": "Infirmerie : +1 soldat par bataille"},
	"Invocateur": {"def": 4, "gold": 0, "res": {}, "heal": 0, "text": "Gardiens invoqués : +4 défense"},
	"Sylvain":    {"def": 3, "gold": 0, "res": {"Bois": 1}, "heal": 0, "text": "Sentinelles : +3 défense, +1 Bois"},
	"Géomancien": {"def": 2, "gold": 0, "res": {"Fer": 2}, "heal": 0, "text": "Filons : +2 Fer, +2 défense"},
}

# ═══════════════════════════════════════════════════════════════════════
#  Lecture de l'état
# ═══════════════════════════════════════════════════════════════════════

static func city_level(conq: Dictionary, id: String) -> int:
	return clampi(int(conq.get("city_levels", {}).get(id, 1)), 1, MAX_LEVEL)

static func level_name(level: int) -> String:
	return LEVEL_NAMES[clampi(level, 1, MAX_LEVEL) - 1]

static func garrison_cap(conq: Dictionary, id: String) -> int:
	return 2 + 2 * city_level(conq, id)

static func troops(conq: Dictionary, id: String) -> int:
	return clampi(int(conq.get("garrisons", {}).get(id, {}).get("troops", 0)), 0, garrison_cap(conq, id))

static func hero_of(conq: Dictionary, id: String) -> String:
	return String(conq.get("garrisons", {}).get(id, {}).get("hero", ""))

## Ville où ce héros est en poste, ou "".
static func hero_city(conq: Dictionary, classe: String) -> String:
	var g: Dictionary = conq.get("garrisons", {})
	for id: String in g.keys():
		if String(g[id].get("hero", "")) == classe:
			return id
	return ""

## Héros en poste (classes), pour les exclure de la sélection d'équipe.
static func stationed_heroes(conq: Dictionary) -> Array:
	var out: Array = []
	var g: Dictionary = conq.get("garrisons", {})
	for id: String in g.keys():
		var h: String = String(g[id].get("hero", ""))
		if h != "" and (conq.get("owned", []) as Array).has(id):
			out.append(h)
	return out

static func is_ravaged(conq: Dictionary, id: String) -> bool:
	return int(conq.get("ravage", {}).get(id, 0)) > 0

static func has_wall(conq: Dictionary, id: String) -> bool:
	return (conq.get("buildings", {}).get(id, []) as Array).has("muraille")

static func hero_level(data: Dictionary, classe: String) -> int:
	return int(data.get("roster", {}).get(classe, {}).get("level", 1))

static func governor_text(classe: String) -> String:
	return String(GOVERNOR.get(classe, {}).get("text", "Gouverneur"))

## Défense d'une ville : soldats, niveau, muraille et héros gouverneur.
static func defense(data: Dictionary, id: String) -> int:
	var conq: Dictionary = data.get("conquest", {})
	var d: int = troops(conq, id) * 2 + city_level(conq, id) * 3
	if has_wall(conq, id):
		d += WALL_DEFENSE
	var h: String = hero_of(conq, id)
	if h != "":
		d += 6 + int(float(hero_level(data, h)) * 0.5) + int(GOVERNOR.get(h, {}).get("def", 0))
	return d

## Or versé par bataille gagnée par une ville (gelé si pillée).
static func city_income(data: Dictionary, id: String) -> int:
	var conq: Dictionary = data.get("conquest", {})
	if is_ravaged(conq, id):
		return 0
	var base: int = (3 if id == "capitale" else 2) * city_level(conq, id)
	var h: String = hero_of(conq, id)
	if h != "":
		base += 2 + int(GOVERNOR.get(h, {}).get("gold", 0))
	return base

static func total_income(data: Dictionary) -> int:
	var conq: Dictionary = data.get("conquest", {})
	var t: int = 0
	for id: String in conq.get("owned", []):
		t += city_income(data, id)
	return t

## Facteur de production des bâtiments selon le niveau de la ville.
static func level_multiplier(conq: Dictionary, id: String) -> float:
	return 1.0 + 0.5 * float(city_level(conq, id) - 1)

## Ressources produites par les héros gouverneurs (villes non pillées).
static func governor_yield(conq: Dictionary) -> Dictionary:
	var out: Dictionary = {}
	for id: String in conq.get("owned", []):
		if is_ravaged(conq, id):
			continue
		var h: String = hero_of(conq, id)
		if h == "":
			continue
		var r: Dictionary = GOVERNOR.get(h, {}).get("res", {})
		for k: String in r.keys():
			out[k] = int(out.get(k, 0)) + int(r[k])
	return out

static func threat(conq: Dictionary) -> Dictionary:
	return conq.get("threat", {})

# ═══════════════════════════════════════════════════════════════════════
#  Actions du joueur
# ═══════════════════════════════════════════════════════════════════════

static func upgrade_cost(conq: Dictionary, id: String) -> Dictionary:
	return UPGRADE.get(city_level(conq, id) + 1, {})

## Améliore une ville. Retourne "" si OK, sinon la raison.
static func upgrade_city(data: Dictionary, id: String, city_name: String = "") -> String:
	var conq: Dictionary = data.get("conquest", {})
	if not (conq.get("owned", []) as Array).has(id):
		return "Ville non conquise."
	if is_ravaged(conq, id):
		return "Ville pillée : impossible de l'améliorer."
	if city_level(conq, id) >= MAX_LEVEL:
		return "Cette ville est déjà une Cité."
	var cost: Dictionary = upgrade_cost(conq, id)
	var res: Dictionary = data.get("resources", {})
	for k: String in cost.get("res", {}).keys():
		if int(res.get(k, 0)) < int(cost["res"][k]):
			return "Ressource insuffisante : %s (%d/%d)." % [k, int(res.get(k, 0)), int(cost["res"][k])]
	if int(data.get("gold", 0)) < int(cost.get("gold", 0)):
		return "Or insuffisant : %d pièces requises." % int(cost.get("gold", 0))
	for k: String in cost.get("res", {}).keys():
		res[k] = int(res.get(k, 0)) - int(cost["res"][k])
	data["resources"] = res
	data["gold"] = int(data.get("gold", 0)) - int(cost.get("gold", 0))
	var lv: Dictionary = conq.get("city_levels", {})
	lv[id] = city_level(conq, id) + 1
	conq["city_levels"] = lv
	log_event(conq, "Ville améliorée : %s devient un %s" % [city_name if city_name != "" else id, level_name(int(lv[id]))])
	data["conquest"] = conq
	return ""

## Recrute n soldats (30 or pièce) dans la garnison, dans la limite de la place.
static func recruit(data: Dictionary, id: String, n: int) -> String:
	var conq: Dictionary = data.get("conquest", {})
	if not (conq.get("owned", []) as Array).has(id):
		return "Ville non conquise."
	var room: int = garrison_cap(conq, id) - troops(conq, id)
	if room <= 0:
		return "Garnison pleine (%d/%d) : améliorez la ville pour l'agrandir." % [troops(conq, id), garrison_cap(conq, id)]
	var count: int = mini(n, room)
	var cost: int = count * TROOP_COST
	if int(data.get("gold", 0)) < cost:
		return "Or insuffisant : %d pièces requises." % cost
	data["gold"] = int(data.get("gold", 0)) - cost
	_set_garrison(conq, id, troops(conq, id) + count, hero_of(conq, id))
	data["conquest"] = conq
	return ""

static func assign_hero(data: Dictionary, id: String, classe: String) -> String:
	var conq: Dictionary = data.get("conquest", {})
	if not (conq.get("owned", []) as Array).has(id):
		return "Ville non conquise."
	if not GOVERNOR.has(classe):
		return "Héros inconnu."
	if hero_of(conq, id) != "":
		return "Cette ville a déjà un gouverneur."
	if stationed_heroes(conq).size() >= 6:
		return "Trop de gouverneurs : 3 héros doivent rester disponibles pour les assauts."
	var elsewhere: String = hero_city(conq, classe)
	if elsewhere != "":
		return "%s gouverne déjà une autre ville." % classe
	_set_garrison(conq, id, troops(conq, id), classe)
	data["conquest"] = conq
	return ""

static func recall_hero(data: Dictionary, id: String) -> String:
	var conq: Dictionary = data.get("conquest", {})
	if hero_of(conq, id) == "":
		return "Aucun gouverneur dans cette ville."
	_set_garrison(conq, id, troops(conq, id), "")
	data["conquest"] = conq
	return ""

static func _set_garrison(conq: Dictionary, id: String, n: int, hero: String) -> void:
	var g: Dictionary = conq.get("garrisons", {})
	g[id] = {"troops": clampi(n, 0, garrison_cap(conq, id)), "hero": hero}
	conq["garrisons"] = g

# ═══════════════════════════════════════════════════════════════════════
#  Journal
# ═══════════════════════════════════════════════════════════════════════

static func log_event(conq: Dictionary, text: String) -> void:
	var events: Array = conq.get("events", [])
	events.append(text)
	while events.size() > 10:
		events.pop_front()
	conq["events"] = events

## Nouvelle affichée au retour sur la carte, et gardée dans la chronique.
static func note(conq: Dictionary, text: String) -> void:
	var news: Array = conq.get("news", [])
	news.append(text)
	conq["news"] = news
	log_event(conq, text)

static func _add_res(data: Dictionary, drops: Dictionary) -> void:
	var res: Dictionary = data.get("resources", {})
	for k: String in drops.keys():
		res[k] = int(res.get(k, 0)) + int(drops[k])
	data["resources"] = res

## Noms de villes (renseignés une fois par ProgressionManager au démarrage).
static var city_names: Dictionary = {}

static func _name(conq: Dictionary, id: String) -> String:
	return String(conq.get("_names", city_names).get(id, city_names.get(id, id)))

# ═══════════════════════════════════════════════════════════════════════
#  Boucle après chaque victoire
# ═══════════════════════════════════════════════════════════════════════

## names : id -> nom de ville (fourni par ProgressionManager pour les messages).
## routes : CONQUEST_ROUTES (pour repérer les villes frontalières).
static func after_victory(data: Dictionary, conq: Dictionary, rng: RandomNumberGenerator,
		routes: Array, names: Dictionary, just_conquered: String) -> void:
	conq["_names"] = names
	conq["news"] = []
	conq["battle_count"] = int(conq.get("battle_count", 0)) + 1
	conq["last_counterattack"] = ""
	data["conquest"] = conq
	_collect_income(data, conq)
	_regen_garrisons(data, conq)
	_tick_threat(data, conq, rng)
	if int(conq.get("truce", 0)) > 0:
		conq["truce"] = int(conq["truce"]) - 1
	else:
		_roll_raid(data, conq, rng, routes, just_conquered)
		_maybe_spawn_threat(data, conq, rng, routes, just_conquered)
	_maybe_event(data, conq, rng, routes, just_conquered)
	conq.erase("_names")
	data["conquest"] = conq

static func _collect_income(data: Dictionary, conq: Dictionary) -> void:
	var gold: int = total_income(data)
	if gold > 0:
		data["gold"] = int(data.get("gold", 0)) + gold
	conq["last_income"] = gold

static func _regen_garrisons(data: Dictionary, conq: Dictionary) -> void:
	for id: String in conq.get("owned", []):
		var h: String = hero_of(conq, id)
		if h == "" or is_ravaged(conq, id):
			continue
		var heal: int = int(GOVERNOR.get(h, {}).get("heal", 0))
		if heal > 0 and troops(conq, id) < garrison_cap(conq, id):
			_set_garrison(conq, id, troops(conq, id) + heal, h)

## Villes possédées pouvant être visées (ni la capitale, ni le Donjon, ni la
## ville fraîchement conquise), les villes frontalières comptant triple.
static func _target_pool(conq: Dictionary, routes: Array, just_conquered: String, skip_ravaged: bool) -> Array:
	var owned: Array = conq.get("owned", [])
	var pool: Array = []
	for id: String in owned:
		if id == "capitale" or id == "donjon_roi" or id == just_conquered:
			continue
		if skip_ravaged and is_ravaged(conq, id):
			continue
		var weight: int = 1
		for pair: Array in routes:
			var other: String = ""
			if String(pair[0]) == id:
				other = String(pair[1])
			elif String(pair[1]) == id:
				other = String(pair[0])
			if other != "" and not owned.has(other):
				weight = 3
				break
		for i: int in range(weight):
			pool.append(id)
	return pool

static func owned_count(conq: Dictionary) -> int:
	var n: int = 0
	for id: String in conq.get("owned", []):
		if id != "capitale" and id != "donjon_roi":
			n += 1
	return n

# ── Raids : petites attaques, contrées par la garnison ──────────────────
static func raid_power(conq: Dictionary) -> int:
	return 4 + int(float(owned_count(conq)) * 0.5)

static func _roll_raid(data: Dictionary, conq: Dictionary, rng: RandomNumberGenerator,
		routes: Array, just_conquered: String) -> void:
	if rng.randf() > RAID_CHANCE:
		return
	var pool: Array = _target_pool(conq, routes, just_conquered, true)
	if pool.is_empty():
		return
	var id: String = String(pool[rng.randi_range(0, pool.size() - 1)])
	if defense(data, id) >= raid_power(conq):
		var t: int = troops(conq, id)
		if t > 0:
			_set_garrison(conq, id, t - 1, hero_of(conq, id))
		note(conq, "♜ Raid repoussé à %s : la garnison tient bon." % _name(conq, id))
		return
	var r: Dictionary = conq.get("ravage", {})
	r[id] = RAVAGE_BATTLES
	conq["ravage"] = r
	conq["last_counterattack"] = id
	note(conq, "Contre-attaque : %s est pillée (%d batailles)" % [_name(conq, id), RAVAGE_BATTLES])

# ── Offensives annoncées ─────────────────────────────────────────────────
static func _maybe_spawn_threat(data: Dictionary, conq: Dictionary, rng: RandomNumberGenerator,
		routes: Array, just_conquered: String) -> void:
	if not threat(conq).is_empty():
		return
	conq["threat_cd"] = int(conq.get("threat_cd", 0)) + 1
	if owned_count(conq) < 3 or int(conq["threat_cd"]) < THREAT_MIN_GAP or rng.randf() > THREAT_CHANCE:
		return
	var pool: Array = _target_pool(conq, routes, just_conquered, true)
	if pool.is_empty():
		return
	var id: String = String(pool[rng.randi_range(0, pool.size() - 1)])
	var power: int = roundi((8.0 + 2.0 * float(owned_count(conq)) + float(int(conq.get("battle_count", 0))) / 3.0) * rng.randf_range(0.85, 1.15))
	conq["threat"] = {"city": id, "power": power, "eta": THREAT_ETA}
	conq["threat_cd"] = 0
	note(conq, "⚠ GRANDE OFFENSIVE ennemie (force %d) : %s sera attaquée dans %d batailles !" % [power, _name(conq, id), THREAT_ETA])

static func _tick_threat(data: Dictionary, conq: Dictionary, rng: RandomNumberGenerator) -> void:
	var th: Dictionary = threat(conq)
	if th.is_empty():
		return
	var id: String = String(th.get("city", ""))
	if not (conq.get("owned", []) as Array).has(id):
		conq.erase("threat")
		return
	th["eta"] = int(th.get("eta", 1)) - 1
	if int(th["eta"]) > 0:
		conq["threat"] = th
		note(conq, "⚠ Offensive (force %d) sur %s : encore %d bataille(s). Défense actuelle : %d." % [
			int(th["power"]), _name(conq, id), int(th["eta"]), defense(data, id)])
		return
	conq.erase("threat")
	resolve_assault(data, conq, id, int(th.get("power", 10)))

## Résolution d'une offensive : repoussée, brèche, ou ville perdue.
static func resolve_assault(data: Dictionary, conq: Dictionary, id: String, power: int) -> String:
	var d: int = defense(data, id)
	var nm: String = _name(conq, id)
	var t: int = troops(conq, id)
	var h: String = hero_of(conq, id)
	if d >= power:
		_set_garrison(conq, id, t - int(ceil(float(t) * 0.25)), h)
		var loot: int = 20 + power * 3
		data["gold"] = int(data.get("gold", 0)) + loot
		note(conq, "★ OFFENSIVE REPOUSSÉE à %s (défense %d contre force %d) ! Butin : +%d or." % [nm, d, power, loot])
		return "repelled"
	if float(d) >= float(power) * 0.6:
		_set_garrison(conq, id, int(float(t) * 0.5), h)
		var r: Dictionary = conq.get("ravage", {})
		r[id] = RAVAGE_BATTLES + 1
		conq["ravage"] = r
		conq["last_counterattack"] = id
		note(conq, "⚔ BRÈCHE à %s (défense %d contre force %d) : la ville est pillée %d batailles." % [nm, d, power, RAVAGE_BATTLES + 1])
		return "breach"
	# Ville perdue : retirée de l'empire, garnison dispersée, héros libéré.
	var owned: Array = conq.get("owned", [])
	owned.erase(id)
	conq["owned"] = owned
	var g: Dictionary = conq.get("garrisons", {})
	g.erase(id)
	conq["garrisons"] = g
	var lv: Dictionary = conq.get("city_levels", {})
	lv[id] = maxi(1, city_level(conq, id) - 1)
	conq["city_levels"] = lv
	var lost: Array = conq.get("lost", [])
	if not lost.has(id):
		lost.append(id)
	conq["lost"] = lost
	var r2: Dictionary = conq.get("ravage", {})
	r2.erase(id)
	conq["ravage"] = r2
	note(conq, "☠ %s EST TOMBÉE (défense %d contre force %d) ! Reprenez-la : une seule bataille suffit." % [nm, d, power])
	return "lost"

# ═══════════════════════════════════════════════════════════════════════
#  Événements
# ═══════════════════════════════════════════════════════════════════════

static func pending_event(conq: Dictionary) -> Dictionary:
	return conq.get("event_pending", {})

static func _maybe_event(data: Dictionary, conq: Dictionary, rng: RandomNumberGenerator,
		routes: Array, just_conquered: String) -> void:
	if not pending_event(conq).is_empty():
		return
	conq["event_cd"] = int(conq.get("event_cd", 0)) + 1
	if int(conq["event_cd"]) < EVENT_MIN_GAP or rng.randf() > EVENT_CHANCE:
		return
	var ev: Dictionary = roll_event(data, conq, rng, just_conquered)
	if ev.is_empty():
		return
	conq["event_cd"] = 0
	if bool(ev.get("auto", false)):
		_apply_auto(data, conq, ev)
	else:
		conq["event_pending"] = ev

## Table des événements : id -> poids. Chacun vérifie ses propres conditions.
const EVENT_WEIGHTS := {
	"caravane": 3.0, "refugies": 2.0, "mercenaires": 2.0, "rebellion": 2.0,
	"espion": 1.5, "diplomatie": 1.0,
	"recolte": 2.0, "tresor": 1.5, "epidemie": 1.5, "rapport": 2.0,
}

## Tire un événement parmi ceux dont les conditions sont réunies.
static func roll_event(data: Dictionary, conq: Dictionary, rng: RandomNumberGenerator, just_conquered: String = "") -> Dictionary:
	var made: Array = []
	var weights: Array = []
	for eid: String in EVENT_WEIGHTS.keys():
		var ev: Dictionary = make_event(eid, data, conq, rng, just_conquered)
		if not ev.is_empty():
			made.append(ev)
			weights.append(float(EVENT_WEIGHTS[eid]))
	if made.is_empty():
		return {}
	var total: float = 0.0
	for w in weights:
		total += float(w)
	var pick: float = rng.randf() * total
	for i: int in range(made.size()):
		pick -= float(weights[i])
		if pick <= 0.0:
			return made[i]
	return made[made.size() - 1]

static func _room_cities(conq: Dictionary, skip_capital: bool) -> Array:
	var out: Array = []
	for id: String in conq.get("owned", []):
		if skip_capital and id == "capitale":
			continue
		if garrison_cap(conq, id) - troops(conq, id) > 0:
			out.append(id)
	return out

## Construit l'événement `eid`, ou {} si ses conditions ne sont pas remplies.
static func make_event(eid: String, data: Dictionary, conq: Dictionary, rng: RandomNumberGenerator,
		just_conquered: String = "") -> Dictionary:
	var nc: int = owned_count(conq)
	var owned: Array = conq.get("owned", [])
	match eid:
		"caravane":
			var res: String = RES_KEYS[rng.randi_range(0, RES_KEYS.size() - 1)]
			return {"id": eid, "title": "CARAVANE MARCHANDE", "city": "", "res": res,
				"text": "Une caravane marchande demande le passage sur vos terres. Ses mules sont chargées de %s." % res,
				"options": [
					{"id": "commerce", "label": "Commercer — 50 or → +12 %s, +4 Magie" % res, "gold": 50},
					{"id": "taxe", "label": "Taxer le passage → +45 or", "gold": 0},
					{"id": "refus", "label": "Les laisser passer", "gold": 0}]}
		"refugies":
			var rooms: Array = _room_cities(conq, false)
			if rooms.is_empty():
				return {}
			var id: String = String(rooms[rng.randi_range(0, rooms.size() - 1)])
			return {"id": eid, "title": "RÉFUGIÉS", "city": id,
				"text": "Des villageois fuient les terres ennemies et demandent asile à %s." % _name(conq, id),
				"options": [
					{"id": "accueillir", "label": "Les accueillir → +2 soldats à %s" % _name(conq, id), "gold": 0},
					{"id": "former", "label": "Les équiper — 40 or → +4 soldats", "gold": 40},
					{"id": "refus", "label": "Les renvoyer", "gold": 0}]}
		"mercenaires":
			var rooms2: Array = _room_cities(conq, true)
			if rooms2.is_empty():
				return {}
			var weakest: String = String(rooms2[0])
			for c: String in rooms2:
				if defense(data, c) < defense(data, weakest):
					weakest = c
			var n: int = mini(4, garrison_cap(conq, weakest) - troops(conq, weakest))
			return {"id": eid, "title": "MERCENAIRES", "city": weakest, "n": n,
				"text": "Une compagnie de mercenaires offre ses lances. Ils se posteraient à %s." % _name(conq, weakest),
				"options": [
					{"id": "engager", "label": "Engager %d mercenaires — %d or" % [n, 15 * n], "gold": 15 * n},
					{"id": "refus", "label": "Décliner", "gold": 0}]}
		"rebellion":
			var restless: Array = []
			for id2: String in owned:
				if id2 == "capitale" or id2 == just_conquered or is_ravaged(conq, id2):
					continue
				if troops(conq, id2) == 0 and hero_of(conq, id2) == "":
					restless.append(id2)
			if restless.is_empty():
				return {}
			var rid: String = String(restless[rng.randi_range(0, restless.size() - 1)])
			return {"id": eid, "title": "AGITATION À %s" % _name(conq, rid).to_upper(), "city": rid,
				"text": "Sans garnison, %s gronde : la population réclame des vivres et de la sécurité." % _name(conq, rid),
				"options": [
					{"id": "vivres", "label": "Distribuer des vivres — 40 or", "gold": 40},
					{"id": "reprimer", "label": "Réprimer → ville pillée 2 batailles", "gold": 0},
					{"id": "ignorer", "label": "Ignorer → 50 % de révolte (3 batailles)", "gold": 0}]}
		"espion":
			if nc < 2:
				return {}
			var th: Dictionary = threat(conq)
			var inter: String = "Interroger → l'offensive affaiblie de 15 %, retardée d'1 bataille" if not th.is_empty() else "Interroger → +35 or de rançon"
			return {"id": eid, "title": "ESPION CAPTURÉ", "city": "",
				"text": "Vos sentinelles ont capturé un espion ennemi dans vos lignes.",
				"options": [
					{"id": "interroger", "label": inter, "gold": 0},
					{"id": "retourner", "label": "Le retourner — 60 or → 4 batailles sans raid", "gold": 60},
					{"id": "relacher", "label": "Le relâcher", "gold": 0}]}
		"diplomatie":
			if nc < 4:
				return {}
			return {"id": eid, "title": "ÉMISSAIRE ENNEMI", "city": "",
				"text": "Un émissaire propose une trêve en échange d'un tribut.",
				"options": [
					{"id": "tribut", "label": "Payer le tribut — 80 or → 6 batailles de paix", "gold": 80},
					{"id": "refus", "label": "Refuser", "gold": 0}]}
		"recolte":
			if nc < 1:
				return {}
			var rc: String = String(owned[rng.randi_range(0, owned.size() - 1)])
			return {"id": eid, "auto": true, "city": rc, "res": RES_KEYS[rng.randi_range(0, RES_KEYS.size() - 1)]}
		"tresor":
			return {"id": eid, "auto": true, "gold": 40 + nc * 6}
		"epidemie":
			if nc < 3:
				return {}
			var pool: Array = []
			for id3: String in owned:
				if id3 != "capitale" and not is_ravaged(conq, id3):
					pool.append(id3)
			if pool.is_empty():
				return {}
			return {"id": eid, "auto": true, "city": String(pool[rng.randi_range(0, pool.size() - 1)])}
		"rapport":
			var govs: Array = []
			for id4: String in owned:
				if hero_of(conq, id4) != "" and not is_ravaged(conq, id4):
					govs.append(id4)
			if govs.is_empty():
				return {}
			return {"id": eid, "auto": true, "city": String(govs[rng.randi_range(0, govs.size() - 1)])}
	return {}

static func _apply_auto(data: Dictionary, conq: Dictionary, ev: Dictionary) -> void:
	var id: String = String(ev.get("city", ""))
	match String(ev["id"]):
		"recolte":
			_add_res(data, {String(ev["res"]): 10})
			note(conq, "✦ Bonne récolte à %s : +10 %s." % [_name(conq, id), String(ev["res"])])
		"tresor":
			data["gold"] = int(data.get("gold", 0)) + int(ev["gold"])
			note(conq, "★ Vos éclaireurs découvrent une cache : +%d or." % int(ev["gold"]))
		"epidemie":
			var healer: bool = hero_city(conq, "Heal") != "" and not is_ravaged(conq, hero_city(conq, "Heal"))
			if healer or city_level(conq, id) >= 2:
				note(conq, "✦ Une fièvre menaçait %s, mais %s l'enraye." % [_name(conq, id),
					"votre soigneuse" if healer else "l'hospice de la ville"])
			else:
				var r: Dictionary = conq.get("ravage", {})
				r[id] = 2
				conq["ravage"] = r
				note(conq, "⚠ Une fièvre frappe %s : production gelée 2 batailles. (Un Bourg ou un Soigneur gouverneur l'aurait évité.)" % _name(conq, id))
		"rapport":
			var h: String = hero_of(conq, id)
			var gold: int = 20 + hero_level(data, h)
			data["gold"] = int(data.get("gold", 0)) + gold
			note(conq, "♞ %s (%s) rapporte les tributs de %s : +%d or." % [h, "gouverneur", _name(conq, id), gold])

## Tranche l'événement en attente. Retourne le texte du résultat ("" si choix invalide).
static func resolve_event(data: Dictionary, option_id: String, rng: RandomNumberGenerator, names: Dictionary = {}) -> String:
	var conq: Dictionary = data.get("conquest", {})
	var ev: Dictionary = pending_event(conq)
	if ev.is_empty():
		return ""
	var chosen: Dictionary = {}
	for o: Dictionary in ev.get("options", []):
		if String(o.get("id", "")) == option_id:
			chosen = o
	if chosen.is_empty():
		return ""
	var cost: int = int(chosen.get("gold", 0))
	if int(data.get("gold", 0)) < cost:
		return "Or insuffisant : %d pièces requises." % cost
	conq["_names"] = names
	data["gold"] = int(data.get("gold", 0)) - cost
	var id: String = String(ev.get("city", ""))
	var out: String = ""
	match String(ev["id"]) + ":" + option_id:
		"caravane:commerce":
			_add_res(data, {String(ev["res"]): 12, "Magie": 4})
			out = "Marché conclu : +12 %s, +4 Magie." % String(ev["res"])
		"caravane:taxe":
			data["gold"] = int(data.get("gold", 0)) + 45
			out = "Les marchands paient le péage : +45 or."
		"refugies:accueillir":
			_set_garrison(conq, id, troops(conq, id) + 2, hero_of(conq, id))
			out = "Deux réfugiés rejoignent la garnison de %s." % _name(conq, id)
		"refugies:former":
			_set_garrison(conq, id, troops(conq, id) + 4, hero_of(conq, id))
			out = "Quatre recrues équipées renforcent %s." % _name(conq, id)
		"mercenaires:engager":
			_set_garrison(conq, id, troops(conq, id) + int(ev.get("n", 1)), hero_of(conq, id))
			out = "%d mercenaires prennent position à %s." % [int(ev.get("n", 1)), _name(conq, id)]
		"rebellion:vivres":
			out = "Les vivres apaisent %s : le calme revient." % _name(conq, id)
		"rebellion:reprimer":
			var r: Dictionary = conq.get("ravage", {})
			r[id] = 2
			conq["ravage"] = r
			out = "La révolte est écrasée, mais %s est pillée 2 batailles." % _name(conq, id)
		"rebellion:ignorer":
			if rng.randf() < 0.5:
				var r2: Dictionary = conq.get("ravage", {})
				r2[id] = 3
				conq["ravage"] = r2
				out = "%s se révolte et se fait piller 3 batailles !" % _name(conq, id)
			else:
				out = "L'agitation retombe d'elle-même, cette fois."
		"espion:interroger":
			var th: Dictionary = threat(conq)
			if not th.is_empty():
				th["power"] = maxi(1, roundi(float(th["power"]) * 0.85))
				th["eta"] = int(th["eta"]) + 1
				conq["threat"] = th
				out = "L'espion parle : l'offensive est affaiblie (force %d) et retardée d'une bataille." % int(th["power"])
			else:
				data["gold"] = int(data.get("gold", 0)) + 35
				out = "Sa rançon rapporte 35 or."
		"espion:retourner":
			conq["truce"] = maxi(int(conq.get("truce", 0)), 4)
			out = "L'espion travaille pour vous : plus de raids pendant 4 batailles."
		"espion:relacher":
			out = "Vous relâchez l'espion. Il ne reviendra pas."
		"diplomatie:tribut":
			conq["truce"] = maxi(int(conq.get("truce", 0)), 6)
			out = "Le tribut est versé : paix pendant 6 batailles (pas de raid, pas de nouvelle offensive)."
		_:
			out = "Vous passez votre chemin."
	conq.erase("event_pending")
	conq.erase("_names")
	log_event(conq, "%s — %s" % [String(ev.get("title", "Événement")).capitalize(), out])
	data["conquest"] = conq
	return out
