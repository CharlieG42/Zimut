class_name Shards
extends RefCounted
## Shards.gd — Éclats de Pierre Élémentaire et fortification des équipements (V113).
##
## Un éclat appartient à une Nation (comme la Pierre) : « Éclat de Sève », « Éclat d'Airain »…
## On en trouve :
##   • très rarement après n'importe quel combat (un peu plus après un boss) ;
##   • après un donjon d'Aventure, MÊME SI la Pierre de la Nation est déjà possédée (ou ratée) ;
##   • en brisant une Pierre Élémentaire (la Pierre est perdue, mais le Gardien peut la redonner).
##
## Deux familles d'éclats servent à fortifier un équipement (Forge › Fortifier) :
##
## 1. Éclats de CARACTÉRISTIQUE (V362) : Force, Défense, Vitalité, Agilité, Intelligence, Sagesse, PA, PM, Portée.
##    Chacun a un RANG de 1 à 5 : un rang élevé donne une plage de valeurs plus haute (les plages se chevauchent,
##    donc un rang 4 chanceux peut battre un rang 5 moyen). La valeur est tirée au hasard à la pose.
##    Un équipement porte au plus UNE ligne par caractéristique (sans limite sur le nombre de caractéristiques) :
##    poser un éclat de la même caractéristique REMPLACE la ligne en place, même si la nouvelle est plus faible
##    (avertissement avant d'écraser) ; une ligne peut être VERROUILLÉE pour la protéger.
##    Obtention : butin de combat / de donjon, fabrication à la forge (rangs 1-3), fusion 3 → 1, brisure 1 → 2.
##
## 2. Éclats de PIERRE ÉLÉMENTAIRE (par Nation, V113) : greffent un bonus spécial (Critique, Vol de vie…) ; ils sont
##    CUMULABLES (jusqu'à PIERRE_MAX_STACK fois par Nation et par objet, coût croissant, Nations différentes
##    additionnées). Ils servent aussi à l'éveil des Pierres.
##
## Tout est plafonné en VALEUR : par ligne et par objet (ITEM_CAP, PIERRE_ITEM_CAP), puis par héros (HERO_CAP).
##
## Sauvegarde (clés optionnelles, rétro-compatibles) :
##   save["shards"]            = { biome: quantité }                    (éclats de Pierre)
##   save["rshards"]           = { "stat|rang": quantité }              (éclats de caractéristique)
##   équipement["forts"]       = { stat: { "v": valeur, "rank": rang, "lock": bool } }
##   équipement["pfort"]       = { biome: nombre_de_pose }              (Pierre ; l'ancien « fort » est converti)

## Bonus greffé par chaque Nation : fx (clés de ItemRules.FX_LABEL) et nombre d'éclats requis.
const FORT := {
	"Rouages": {"fx": {"pa": 1}, "cost": 8},
	"Vents": {"fx": {"pm": 1}, "cost": 6},
	"Cristaux": {"fx": {"po": 1}, "cost": 6},
	"Forêt": {"fx": {"lifesteal": 3}, "cost": 3},
	"Montagne": {"fx": {"mres": 4}, "cost": 3},
	"Désert": {"fx": {"crit": 3}, "cost": 3},
	"Marées": {"fx": {"heal_pct": 5}, "cost": 3},
	"Brasier": {"fx": {"phys_pct": 4}, "cost": 3},
	"Brumes": {"fx": {"mag_pct": 4}, "cost": 3},
	"Ombres": {"fx": {"crit": 4}, "cost": 4},
}

## Plafond cumulé, par héros, des PA / PM / PO apportés par les fortifications (tous types d'éclats).
const FORT_CAP := {"pa": 2, "pm": 2, "po": 2}

## Chances d'éclat (une chance par victoire / par donjon terminé).
const DROP_FIGHT := 0.03        # n'importe quel combat gagné
const DROP_BOSS := 0.15         # combat de boss
const DROP_DUNGEON := 0.40      # fin de donjon sans Pierre gagnée (déjà possédée ou ratée) : 1 à 3 éclats

## Éclats rendus en brisant une Pierre : une base + la moitié des éclats investis dans son éveil
## (toujours inférieur au coût investi : briser n'est jamais rentable pour « recycler » un éveil).
const SHATTER_BASE := 3


static func shard_name(biome: String) -> String:
	return "Éclat %s" % Stones.stone_name(biome).trim_prefix("Pierre ")


static func color_of(biome: String) -> Color:
	return Stones.info(biome).get("color", Color(0.8, 0.8, 0.8))


static func owned(data: Dictionary) -> Dictionary:
	return data.get("shards", {})


static func count(data: Dictionary, biome: String) -> int:
	return int(owned(data).get(biome, 0))


static func total(data: Dictionary) -> int:
	var n: int = 0
	for b: String in owned(data).keys():
		n += int(owned(data)[b])
	return n


static func add(data: Dictionary, biome: String, n: int) -> void:
	if not Stones.DATA.has(biome) or n <= 0:
		return
	var sh: Dictionary = owned(data)
	sh[biome] = int(sh.get(biome, 0)) + n
	data["shards"] = sh


## Tirage d'éclat après un combat gagné : retourne {biome: quantité} (vide si rien).
## Possible même si la Pierre de la Nation est déjà possédée.
static func roll_fight(rng: RandomNumberGenerator, biome: String, boss: bool) -> Dictionary:
	if not Stones.DATA.has(biome):
		return {}
	if rng.randf() < (DROP_BOSS if boss else DROP_FIGHT):
		return {biome: 1}
	return {}


## Tirage à la fin d'un donjon quand la Pierre n'est pas tombée (possédée ou ratée).
static func roll_dungeon(rng: RandomNumberGenerator, biome: String) -> Dictionary:
	if not Stones.DATA.has(biome):
		return {}
	if rng.randf() < DROP_DUNGEON:
		return {biome: rng.randi_range(1, 3)}
	return {}


# ── Brisure d'une Pierre ────────────────────────────────────────────────────

static func shatter_yield(data: Dictionary, biome: String) -> int:
	var lv: int = maxi(1, Stones.level(data, biome))
	var invested: int = Stones.AWAKEN_SHARDS_PER_LEVEL * lv * (lv - 1) / 2   # 2+4+… éclats déjà payés
	return SHATTER_BASE + invested / 2


## Brise la Pierre `biome` : elle disparaît (il faudra la regagner) et donne des éclats.
## Retourne {"ok", "shards", "reason"}.
static func shatter(data: Dictionary, biome: String) -> Dictionary:
	if not Stones.has(data, biome):
		return {"ok": false, "shards": 0, "reason": "Pierre non trouvée."}
	var n: int = shatter_yield(data, biome)
	var st: Dictionary = Stones.owned(data)
	st.erase(biome)
	data["stones"] = st
	add(data, biome, n)
	return {"ok": true, "shards": n, "reason": ""}


# ── Fortification par éclats de Pierre (cumulable) ──────────────────────────

const PIERRE_MAX_STACK := 3

## Plafond par objet des effets de Pierre (somme des Nations).
const PIERRE_ITEM_CAP := {"crit": 15, "lifesteal": 9, "mres": 12, "heal_pct": 15, "phys_pct": 12, "mag_pct": 12,
	"pa": 2, "pm": 2, "po": 2}

static func fort_fx(biome: String) -> Dictionary:
	return (FORT.get(biome, {}).get("fx", {}) as Dictionary).duplicate()


## Coût en éclats pour la pose n° `stacks_now + 1` d'une Nation (croît à chaque pose).
static func fort_cost(biome: String, stacks_now: int = 0) -> int:
	return int(FORT.get(biome, {}).get("cost", 99)) * (stacks_now + 1)


static func gold_cost(item: Dictionary) -> int:
	return 100 + 10 * maxi(1, int(item.get("level", 1)))


## Poses de Pierre d'un objet : { biome: nombre }. Convertit à la lecture l'ancien format « fort » (une pose).
static func pierre_of(item: Dictionary) -> Dictionary:
	var out: Dictionary = {}
	if item.has("pfort"):
		for b: String in (item["pfort"] as Dictionary).keys():
			out[b] = int(item["pfort"][b])
	elif item.has("fort") and (item["fort"] as Dictionary).has("biome"):
		out[String(item["fort"]["biome"])] = 1
	return out


## Ancien nom : une seule fortification. Renvoie la première pose de Pierre ({} si aucune).
static func fort_of(item: Dictionary) -> Dictionary:
	var p: Dictionary = pierre_of(item)
	if p.is_empty():
		return {}
	var b: String = String(p.keys()[0])
	return {"biome": b, "fx": fort_fx(b)}


## Effets des Pierres d'un objet (cumulés, plafonnés par objet).
static func pierre_fx(item: Dictionary) -> Dictionary:
	var fx: Dictionary = {}
	var p: Dictionary = pierre_of(item)
	for b: String in p.keys():
		var one: Dictionary = fort_fx(b)
		for k: String in one.keys():
			fx[k] = int(fx.get(k, 0)) + int(one[k]) * int(p[b])
	for k: String in fx.keys():
		fx[k] = mini(int(fx[k]), int(PIERRE_ITEM_CAP.get(k, 99)))
	return fx


## Libellé du bonus d'une Nation : « +1 PA ».
static func fx_text(fx: Dictionary) -> String:
	return " · ".join(ItemRules.fx_lines(fx))


## Un équipement se porte dans un emplacement (arme, casque, bague…) ; une potion non.
static func _is_equipment(item: Dictionary) -> bool:
	var pm: Node = (Engine.get_main_loop() as SceneTree).root.get_node_or_null("ProgressionManager")
	return pm != null and String(pm.call("slot_for_type", String(item.get("type", "")))) != ""


## "" si la pose d'un éclat de Pierre est possible, sinon la raison.
static func can_fortify(data: Dictionary, item: Dictionary, biome: String) -> String:
	if item.is_empty() or not _is_equipment(item):
		return "Seul un équipement peut être fortifié."
	if not FORT.has(biome):
		return "Éclat inconnu."
	var n: int = int(pierre_of(item).get(biome, 0))
	if n >= PIERRE_MAX_STACK:
		return "Cet objet porte déjà ce bonus au maximum (%d fois)." % PIERRE_MAX_STACK
	var fx: Dictionary = fort_fx(biome)
	var cur: Dictionary = pierre_fx(item)
	var all_capped: bool = true
	for k: String in fx.keys():
		if int(cur.get(k, 0)) < int(PIERRE_ITEM_CAP.get(k, 99)):
			all_capped = false
	if all_capped:
		return "Plafond atteint pour ce bonus sur cet objet."
	if count(data, biome) < fort_cost(biome, n):
		return "Il faut %d × %s." % [fort_cost(biome, n), shard_name(biome)]
	if int(data.get("gold", 0)) < gold_cost(item):
		return "Il faut %d or." % gold_cost(item)
	return ""


## Pose un éclat de Pierre sur `item` (modifié en place) : le bonus S'AJOUTE à ceux déjà présents. "" si OK.
static func fortify(data: Dictionary, item: Dictionary, biome: String) -> String:
	var err: String = can_fortify(data, item, biome)
	if err != "":
		return err
	var p: Dictionary = pierre_of(item)
	data["shards"][biome] = count(data, biome) - fort_cost(biome, int(p.get(biome, 0)))
	data["gold"] = int(data.get("gold", 0)) - gold_cost(item)
	p[biome] = int(p.get(biome, 0)) + 1
	item["pfort"] = p
	item.erase("fort")
	return ""


# ── Éclats de caractéristique (rang 1 à 5) ──────────────────────────────────

const MAX_SHARD_RANK := 5
const STAT_SHARDS: Array[String] = ["force", "defense", "vita", "agility", "intelligence", "wisdom", "pa", "pm", "po"]
const STAT_ONLY: Array[String] = ["force", "defense", "vita", "agility", "intelligence", "wisdom"]
const FORTABLE_FX: Array[String] = ["pa", "pm", "po"]
const SHARD_NAME_OF := {"force": "Force", "defense": "Défense", "vita": "Vitalité", "agility": "Agilité",
	"intelligence": "Intelligence", "wisdom": "Sagesse", "pa": "PA", "pm": "PM", "po": "Portée"}
const SHARD_COLOR := {"force": Color(0.95, 0.45, 0.35), "defense": Color(0.55, 0.70, 0.95), "vita": Color(0.50, 0.90, 0.50),
	"agility": Color(0.95, 0.85, 0.40), "intelligence": Color(0.70, 0.55, 1.0), "wisdom": Color(0.45, 0.85, 0.90),
	"pa": Color(1.0, 0.65, 0.25), "pm": Color(0.45, 0.80, 1.0), "po": Color(0.85, 0.75, 0.55)}

## Plage de valeur tirée à la pose, par rang (les plages se chevauchent volontairement). Vitalité × VITA_MULT.
const RANGE_BY_RANK := {1: [1, 2], 2: [2, 4], 3: [3, 6], 4: [5, 9], 5: [7, 12]}
const RANGE_PA := {1: [1, 1], 2: [1, 1], 3: [1, 1], 4: [1, 2], 5: [2, 2]}
const VITA_MULT := 3

## Plafonds en valeur : par ligne / par objet, puis par héros (somme de tous ses équipements).
const ITEM_CAP := {"force": 12, "defense": 12, "agility": 12, "intelligence": 12, "wisdom": 12, "vita": 36,
	"pa": 2, "pm": 2, "po": 2}
const HERO_CAP := {"force": 60, "defense": 60, "agility": 60, "intelligence": 60, "wisdom": 60, "vita": 180,
	"pa": 2, "pm": 2, "po": 2, "crit": 40, "lifesteal": 20, "mres": 40, "heal_pct": 40, "phys_pct": 30, "mag_pct": 30}

## Butin : chance d'éclat de caractéristique (un tirage par victoire / par donjon terminé).
const STAT_DROP_FIGHT := 0.25      # V376 : 12 % → 25 %
const STAT_DROP_BOSS := 0.50       # V376 : 40 % → 50 %
const STAT_DROP_DUNGEON := 0.35

## Fabrication (rangs 1 à 3 seulement ; PA/PM/Portée uniquement en butin ou par fusion).
const CRAFT_MAX_RANK := 3
const CRAFT_RES := {"force": "Fer", "defense": "Cuir", "vita": "Bois", "agility": "Venin", "intelligence": "Magie", "wisdom": "Magie"}
const FUSE_COUNT := 3


static func stat_name(stat: String) -> String:
	return String(SHARD_NAME_OF.get(stat, stat))


static func stat_shard_name(stat: String, rank: int) -> String:
	return "Éclat de %s R%d" % [stat_name(stat), rank]


static func stat_color(stat: String) -> Color:
	return SHARD_COLOR.get(stat, Color(0.8, 0.8, 0.8))


static func _key(stat: String, rank: int) -> String:
	return "%s|%d" % [stat, rank]


static func stat_owned(data: Dictionary) -> Dictionary:
	return data.get("rshards", {})


static func stat_count(data: Dictionary, stat: String, rank: int) -> int:
	return int(stat_owned(data).get(_key(stat, rank), 0))


static func stat_total(data: Dictionary) -> int:
	var n: int = 0
	for k: String in stat_owned(data).keys():
		n += int(stat_owned(data)[k])
	return n


static func stat_add(data: Dictionary, stat: String, rank: int, n: int) -> void:
	if not STAT_SHARDS.has(stat) or rank < 1 or rank > MAX_SHARD_RANK or n == 0:
		return
	var sh: Dictionary = stat_owned(data)
	sh[_key(stat, rank)] = maxi(0, int(sh.get(_key(stat, rank), 0)) + n)
	data["rshards"] = sh


## [min, max] de la valeur d'un éclat de caractéristique de ce rang.
static func value_range(stat: String, rank: int) -> Array:
	rank = clampi(rank, 1, MAX_SHARD_RANK)
	if FORTABLE_FX.has(stat):
		return (RANGE_PA[rank] as Array).duplicate()
	var r: Array = (RANGE_BY_RANK[rank] as Array).duplicate()
	if stat == "vita":
		r = [int(r[0]) * VITA_MULT, int(r[1]) * VITA_MULT]
	return r


static func range_text(stat: String, rank: int) -> String:
	var r: Array = value_range(stat, rank)
	return "+%d" % int(r[0]) if int(r[0]) == int(r[1]) else "+%d à +%d" % [int(r[0]), int(r[1])]


static func roll_value(rng: RandomNumberGenerator, stat: String, rank: int) -> int:
	var r: Array = value_range(stat, rank)
	return mini(rng.randi_range(int(r[0]), int(r[1])), int(ITEM_CAP.get(stat, 99)))


## Tirage d'éclat de caractéristique après un combat (niveau `level`, boss ou non) : {"stat","rank"} ou {}.
static func roll_stat_fight(rng: RandomNumberGenerator, level: int, boss: bool) -> Dictionary:
	if rng.randf() >= (STAT_DROP_BOSS if boss else STAT_DROP_FIGHT):
		return {}
	return _roll_stat_shard(rng, level, boss)


static func roll_stat_dungeon(rng: RandomNumberGenerator, level: int) -> Dictionary:
	if rng.randf() >= STAT_DROP_DUNGEON:
		return {}
	return _roll_stat_shard(rng, level, true)


## Rang : plafond selon le niveau (+1 pour un boss), départ 2 rangs sous le plafond puis 35 % de monter d'un cran.
static func _roll_stat_shard(rng: RandomNumberGenerator, level: int, boss: bool) -> Dictionary:
	var stat: String = STAT_SHARDS[rng.randi_range(0, STAT_SHARDS.size() - 1)]
	if FORTABLE_FX.has(stat) and rng.randf() < 0.55:   # PA/PM/Portée : plus rares
		stat = STAT_ONLY[rng.randi_range(0, STAT_ONLY.size() - 1)]
	var cap: int = clampi(1 + level / 10 + (1 if boss else 0), 1, MAX_SHARD_RANK)
	var rank: int = maxi(1, cap - 2)
	while rank < cap and rng.randf() < 0.35:
		rank += 1
	return {"stat": stat, "rank": rank}


# ── Lignes de fortification d'un objet ──────────────────────────────────────

static func lines_of(item: Dictionary) -> Dictionary:
	return item.get("forts", {})


static func line_of(item: Dictionary, stat: String) -> Dictionary:
	return lines_of(item).get(stat, {})


static func is_locked(item: Dictionary, stat: String) -> bool:
	return bool(line_of(item, stat).get("lock", false))


## Verrouille / déverrouille une ligne (sans coût). Retourne false si la ligne n'existe pas.
static func set_lock(item: Dictionary, stat: String, locked: bool) -> bool:
	var lines: Dictionary = lines_of(item)
	if not lines.has(stat):
		return false
	lines[stat]["lock"] = locked
	return true


## Or demandé pour retirer une ligne.
static func remove_gold(item: Dictionary) -> int:
	return maxi(50, gold_cost(item) / 2)


## Retire une ligne (l'éclat est perdu). Une ligne verrouillée doit d'abord être déverrouillée. "" si OK.
static func remove_line(data: Dictionary, item: Dictionary, stat: String) -> String:
	if not lines_of(item).has(stat):
		return "Aucune ligne à retirer."
	if is_locked(item, stat):
		return "Ligne verrouillée : déverrouillez-la d'abord."
	var cost: int = remove_gold(item)
	if int(data.get("gold", 0)) < cost:
		return "Il faut %d or." % cost
	data["gold"] = int(data.get("gold", 0)) - cost
	lines_of(item).erase(stat)
	if lines_of(item).is_empty():
		item.erase("forts")
	return ""


## Valeurs des lignes de caractéristique d'un objet, plafonnées par objet : { stat: valeur } (PA/PM/PO inclus).
static func item_line_values(item: Dictionary) -> Dictionary:
	var out: Dictionary = {}
	var lines: Dictionary = lines_of(item)
	for stat: String in lines.keys():
		out[stat] = mini(int(lines[stat].get("v", 0)), int(ITEM_CAP.get(stat, 99)))
	return out


## Bonus de caractéristiques (Force…Vitalité) apportés par les fortifications d'UN objet.
static func item_fort_stats(item: Dictionary) -> Dictionary:
	var out: Dictionary = {}
	var vals: Dictionary = item_line_values(item)
	for stat: String in STAT_ONLY:
		if vals.has(stat):
			out[stat] = int(vals[stat])
	return out


## Effets (PA/PM/PO des lignes + effets de Pierre) apportés par les fortifications d'UN objet.
static func item_fort_fx(item: Dictionary) -> Dictionary:
	var fx: Dictionary = pierre_fx(item)
	var vals: Dictionary = item_line_values(item)
	for stat: String in FORTABLE_FX:
		if vals.has(stat):
			fx[stat] = mini(int(fx.get(stat, 0)) + int(vals[stat]), int(ITEM_CAP.get(stat, 99)))
	return fx


## Total des fortifications de tout l'équipement d'un héros, plafonné par héros : {"stats", "fx"}.
static func equipment_fort(equipment: Dictionary) -> Dictionary:
	var stats: Dictionary = {}
	var fx: Dictionary = {}
	for slot: String in equipment.keys():
		var it: Dictionary = equipment[slot]
		ItemRules.merge_fx(stats, item_fort_stats(it))
		ItemRules.merge_fx(fx, item_fort_fx(it))
	for k: String in stats.keys():
		stats[k] = mini(int(stats[k]), int(HERO_CAP.get(k, 999)))
	for k: String in fx.keys():
		fx[k] = mini(int(fx[k]), int(HERO_CAP.get(k, 999)))
	return {"stats": stats, "fx": fx}


## Effets des fortifications d'un équipement complet, plafonnés : {fx}.
static func equipment_fx(equipment: Dictionary) -> Dictionary:
	return equipment_fort(equipment)["fx"]


## Une ligne de texte par fortification : « Force +7 (R4) 🔒 », puis les Pierres : « Critique +3% (Éclat d'Ombre ×2) ».
static func fort_lines(item: Dictionary) -> Array[String]:
	var out: Array[String] = []
	var lines: Dictionary = lines_of(item)
	for stat: String in STAT_SHARDS:
		if lines.has(stat):
			var l: Dictionary = lines[stat]
			out.append("%s +%d (R%d)%s" % [stat_name(stat), int(l.get("v", 0)), int(l.get("rank", 1)), " 🔒" if bool(l.get("lock", false)) else ""])
	var p: Dictionary = pierre_of(item)
	for b: String in p.keys():
		var txt: String = fx_text(scaled(fort_fx(b), int(p[b])))
		out.append("%s (%s%s)" % [txt, shard_name(b), " ×%d" % int(p[b]) if int(p[b]) > 1 else ""])
	return out


static func scaled(fx: Dictionary, n: int) -> Dictionary:
	var out: Dictionary = {}
	for k: String in fx.keys():
		out[k] = int(fx[k]) * n
	return out


## Ligne compacte affichée dans les caractéristiques de l'objet : « ❖ Force +7 · ❖ Vitalité +12 » ("" si rien).
## Chaque entrée porte le ❖ pour ne pas être confondue avec les caractéristiques de base.
static func fort_line(item: Dictionary) -> String:
	var parts: Array[String] = []
	var lines: Dictionary = lines_of(item)
	for stat: String in STAT_SHARDS:
		if lines.has(stat):
			parts.append("❖ %s +%d" % [stat_name(stat), int(lines[stat].get("v", 0))])
	for l: String in ItemRules.fx_lines(pierre_fx(item)):
		parts.append("❖ " + l)
	return " · ".join(parts)


## Raison pour laquelle on ne peut pas poser cet éclat ("" si possible).
static func can_fortify_stat(data: Dictionary, item: Dictionary, stat: String, rank: int) -> String:
	if item.is_empty() or not _is_equipment(item):
		return "Seul un équipement peut être fortifié."
	if not STAT_SHARDS.has(stat) or rank < 1 or rank > MAX_SHARD_RANK:
		return "Éclat inconnu."
	if is_locked(item, stat):
		return "La ligne %s est verrouillée." % stat_name(stat)
	if stat_count(data, stat, rank) < 1:
		return "Il faut 1 × %s." % stat_shard_name(stat, rank)
	if int(data.get("gold", 0)) < stat_gold(item, rank):
		return "Il faut %d or." % stat_gold(item, rank)
	return ""


static func stat_gold(item: Dictionary, rank: int) -> int:
	return int(gold_cost(item) * (1.0 + 0.5 * float(rank - 1)))


## Pose un éclat de caractéristique. Retourne {"ok", "reason", "confirm", "value"} :
##   • "confirm" = true (sans rien dépenser) quand la pose écraserait une ligne existante et que
##     `confirmed` est faux : l'interface demande alors une confirmation.
static func fortify_stat(data: Dictionary, item: Dictionary, stat: String, rank: int,
		rng: RandomNumberGenerator, confirmed: bool = false) -> Dictionary:
	var err: String = can_fortify_stat(data, item, stat, rank)
	if err != "":
		return {"ok": false, "reason": err, "confirm": false, "value": 0}
	if lines_of(item).has(stat) and not confirmed:
		return {"ok": false, "reason": "", "confirm": true, "value": 0}
	stat_add(data, stat, rank, -1)
	data["gold"] = int(data.get("gold", 0)) - stat_gold(item, rank)
	var v: int = roll_value(rng, stat, rank)
	var lines: Dictionary = lines_of(item)
	lines[stat] = {"v": v, "rank": rank, "lock": false}
	item["forts"] = lines
	return {"ok": true, "reason": "", "confirm": false, "value": v}


# ── Atelier d'éclats : fabrication, fusion, brisure ─────────────────────────

static func _res_key(res_name: String, tier: int) -> String:
	return res_name if tier <= 1 else "%s@%d" % [res_name, tier]


## Coût de fabrication d'un éclat : {"res": clé, "res_name", "qty", "gold"} ({} si non fabricable).
static func craft_cost(stat: String, rank: int) -> Dictionary:
	if not CRAFT_RES.has(stat) or rank < 1 or rank > CRAFT_MAX_RANK:
		return {}
	var rn: String = String(CRAFT_RES[stat])
	return {"res": _res_key(rn, rank), "res_name": rn, "qty": 4 if rank == 1 else 3, "gold": 40 * rank * rank}


static func can_craft(data: Dictionary, stat: String, rank: int) -> String:
	var c: Dictionary = craft_cost(stat, rank)
	if c.is_empty():
		return "Cet éclat ne se fabrique pas (butin ou fusion)."
	if int(data.get("resources", {}).get(String(c["res"]), 0)) < int(c["qty"]):
		return "Il faut %d × %s (rang %d)." % [int(c["qty"]), String(c["res_name"]), rank]
	if int(data.get("gold", 0)) < int(c["gold"]):
		return "Il faut %d or." % int(c["gold"])
	return ""


static func craft(data: Dictionary, stat: String, rank: int) -> String:
	var err: String = can_craft(data, stat, rank)
	if err != "":
		return err
	var c: Dictionary = craft_cost(stat, rank)
	var res: Dictionary = data.get("resources", {})
	res[String(c["res"])] = int(res.get(String(c["res"]), 0)) - int(c["qty"])
	data["resources"] = res
	data["gold"] = int(data.get("gold", 0)) - int(c["gold"])
	stat_add(data, stat, rank, 1)
	return ""


static func fuse_gold(rank: int) -> int:
	return 50 * rank


static func can_fuse(data: Dictionary, stat: String, rank: int) -> String:
	if rank < 1 or rank >= MAX_SHARD_RANK:
		return "Rang maximum atteint."
	if stat_count(data, stat, rank) < FUSE_COUNT:
		return "Il faut %d × %s." % [FUSE_COUNT, stat_shard_name(stat, rank)]
	if int(data.get("gold", 0)) < fuse_gold(rank):
		return "Il faut %d or." % fuse_gold(rank)
	return ""


## Fond FUSE_COUNT éclats de rang `rank` en 1 éclat de rang + 1.
static func fuse(data: Dictionary, stat: String, rank: int) -> String:
	var err: String = can_fuse(data, stat, rank)
	if err != "":
		return err
	stat_add(data, stat, rank, -FUSE_COUNT)
	stat_add(data, stat, rank + 1, 1)
	data["gold"] = int(data.get("gold", 0)) - fuse_gold(rank)
	return ""


static func can_split(data: Dictionary, stat: String, rank: int) -> String:
	if rank < 2 or rank > MAX_SHARD_RANK:
		return "Un éclat de rang 1 ne se brise pas."
	if stat_count(data, stat, rank) < 1:
		return "Il faut 1 × %s." % stat_shard_name(stat, rank)
	return ""


## Brise 1 éclat de rang ≥ 2 en 2 éclats de rang - 1 (toujours moins rentable qu'une fusion).
static func split(data: Dictionary, stat: String, rank: int) -> String:
	var err: String = can_split(data, stat, rank)
	if err != "":
		return err
	stat_add(data, stat, rank, -1)
	stat_add(data, stat, rank - 1, 2)
	return ""
