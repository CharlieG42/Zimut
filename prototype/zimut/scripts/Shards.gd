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
## Fortification (Forge) : dépenser des éclats d'une Nation pour greffer à un équipement un bonus
## qu'il n'avait pas (PA, PM, Portée, Vol de vie…). Un seul bonus par équipement ; fortifier à nouveau
## remplace l'ancien. Le bonus est signalé par ❖ dans les caractéristiques de l'objet.
##
## Sauvegarde (clés optionnelles, rétro-compatibles) :
##   save["shards"]            = { biome: quantité }
##   équipement["fort"]        = { "biome": biome, "fx": { effet: valeur } }

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

## Plafond cumulé, par héros, des PA / PM / PO apportés par les fortifications.
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


# ── Fortification ───────────────────────────────────────────────────────────

static func fort_fx(biome: String) -> Dictionary:
	return (FORT.get(biome, {}).get("fx", {}) as Dictionary).duplicate()


static func fort_cost(biome: String) -> int:
	return int(FORT.get(biome, {}).get("cost", 99))


static func gold_cost(item: Dictionary) -> int:
	return 100 + 10 * maxi(1, int(item.get("level", 1)))


## Fortification actuelle d'un objet ({} si aucune).
static func fort_of(item: Dictionary) -> Dictionary:
	return item.get("fort", {})


## Libellé du bonus d'une Nation : « +1 PA ».
static func fx_text(fx: Dictionary) -> String:
	return " · ".join(ItemRules.fx_lines(fx))


## Ligne affichée sur l'objet : « ❖ +1 PA (Éclat d'Airain) » ("" si non fortifié).
static func fort_line(item: Dictionary) -> String:
	var f: Dictionary = fort_of(item)
	if f.is_empty():
		return ""
	return "❖ %s" % fx_text(f.get("fx", {}))


## Un équipement se porte dans un emplacement (arme, casque, bague…) ; une potion non.
static func _is_equipment(item: Dictionary) -> bool:
	var pm: Node = (Engine.get_main_loop() as SceneTree).root.get_node_or_null("ProgressionManager")
	return pm != null and String(pm.call("slot_for_type", String(item.get("type", "")))) != ""


## "" si la fortification est possible, sinon la raison.
static func can_fortify(data: Dictionary, item: Dictionary, biome: String) -> String:
	if item.is_empty() or not _is_equipment(item):
		return "Seul un équipement peut être fortifié."
	if not FORT.has(biome):
		return "Éclat inconnu."
	var cur: Dictionary = fort_of(item)
	if not cur.is_empty() and String(cur.get("biome", "")) == biome:
		return "Cet objet porte déjà ce bonus."
	if count(data, biome) < fort_cost(biome):
		return "Il faut %d × %s." % [fort_cost(biome), shard_name(biome)]
	if int(data.get("gold", 0)) < gold_cost(item):
		return "Il faut %d or." % gold_cost(item)
	return ""


## Fortifie `item` (modifié en place) avec les éclats de `biome`. "" si OK.
static func fortify(data: Dictionary, item: Dictionary, biome: String) -> String:
	var err: String = can_fortify(data, item, biome)
	if err != "":
		return err
	data["shards"][biome] = count(data, biome) - fort_cost(biome)
	data["gold"] = int(data.get("gold", 0)) - gold_cost(item)
	item["fort"] = {"biome": biome, "fx": fort_fx(biome)}
	return ""


## Effets des fortifications d'un équipement complet, plafonnés (PA / PM / PO) : {fx}.
static func equipment_fx(equipment: Dictionary) -> Dictionary:
	var fx: Dictionary = {}
	for slot: String in equipment.keys():
		var f: Dictionary = fort_of(equipment[slot])
		if not f.is_empty():
			ItemRules.merge_fx(fx, f.get("fx", {}))
	for k: String in FORT_CAP.keys():
		if fx.has(k):
			fx[k] = mini(int(fx[k]), int(FORT_CAP[k]))
	return fx
