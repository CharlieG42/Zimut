class_name Stones
extends RefCounted
## Stones.gd — Les Pierres Élémentaires (V27), objectif final de Zimut.
##
## Une Pierre par Nation. On la gagne en battant le boss de la Nation (boss illustré),
## quel que soit le mode : Tactique, Aventure (sanctuaire de la Pierre) ou Conquête (siège).
## Un héros porte 2 Pierres au maximum ; une Pierre n'existe qu'en un exemplaire.
## Elle s'éveille du niveau 1 au niveau 5 avec de l'or et la ressource de sa Nation.
##
## Sauvegarde (clé optionnelle, rétro-compatible) :
##   save["stones"] = { biome: { "owner": "Classe" | "", "level": 1..5 } }

const MAX_PER_HERO := 2
const MAX_LEVEL := 5

## stats : bonus par niveau d'éveil ; fx : effets par niveau ; flat : effets fixes (PA/PM).
const DATA := {
	"Forêt": {"name": "Pierre de Sève", "color": Color(0.45, 0.85, 0.40),
		"stats": {"vita": 20, "wisdom": 2}, "fx": {"lifesteal": 2}, "flat": {},
		"lore": "La sève de l'Arbre-Mère y bat encore."},
	"Montagne": {"name": "Pierre de Givre", "color": Color(0.65, 0.85, 1.0),
		"stats": {"defense": 5}, "fx": {"mres": 3}, "flat": {},
		"lore": "Un éclat de glace qui ne fond jamais."},
	"Désert": {"name": "Pierre d'Ocre", "color": Color(0.95, 0.70, 0.30),
		"stats": {"agility": 5}, "fx": {"crit": 2}, "flat": {},
		"lore": "Les mirages naissent à sa surface."},
	"Cristaux": {"name": "Pierre de Prisme", "color": Color(0.72, 0.60, 1.0),
		"stats": {"intelligence": 5}, "fx": {"mag_pct": 3}, "flat": {},
		"lore": "Elle décompose la magie comme la lumière."},
	"Marées": {"name": "Pierre de Corail", "color": Color(0.40, 0.85, 0.90),
		"stats": {"wisdom": 5, "vita": 8}, "fx": {"heal_pct": 4}, "flat": {},
		"lore": "On y entend le ressac, même au cœur des terres."},
	"Vents": {"name": "Pierre d'Azur", "color": Color(0.75, 0.92, 1.0),
		"stats": {"agility": 3}, "fx": {}, "flat": {"pm": 1},
		"lore": "Légère comme une plume, elle porte son porteur."},
	"Brasier": {"name": "Pierre de Braise", "color": Color(1.0, 0.50, 0.20),
		"stats": {"force": 5}, "fx": {"phys_pct": 3}, "flat": {},
		"lore": "Tiède au toucher, brûlante au combat."},
	"Brumes": {"name": "Pierre de Lune-des-Marais", "color": Color(0.70, 0.95, 0.85),
		"stats": {"intelligence": 3, "wisdom": 3}, "fx": {"lifesteal": 3}, "flat": {},
		"lore": "Elle luit faiblement, comme un feu follet."},
	"Ombres": {"name": "Pierre d'Ébène", "color": Color(0.62, 0.45, 0.90),
		"stats": {"force": 3, "agility": 3}, "fx": {"crit": 3}, "flat": {},
		"lore": "Elle boit la lumière qui l'entoure."},
	"Rouages": {"name": "Pierre d'Airain", "color": Color(0.95, 0.62, 0.22),
		"stats": {"defense": 3, "force": 3}, "fx": {}, "flat": {"pa": 1},
		"lore": "Un cœur de métal qui tourne sans fin."},
}

## Ordre d'affichage (celui des Nations).
const ORDER: Array[String] = ["Forêt", "Montagne", "Désert", "Cristaux", "Marées", "Vents", "Brasier", "Brumes", "Ombres", "Rouages"]


static func info(biome: String) -> Dictionary:
	return DATA.get(biome, {})


static func stone_name(biome: String) -> String:
	return String(DATA.get(biome, {}).get("name", biome))


static func owned(data: Dictionary) -> Dictionary:
	return data.get("stones", {})


static func has(data: Dictionary, biome: String) -> bool:
	return owned(data).has(biome)


static func count(data: Dictionary) -> int:
	return owned(data).size()


## Donne la Pierre de la Nation `biome` (une seule fois). Retourne true si elle est nouvelle.
static func grant(data: Dictionary, biome: String) -> bool:
	if not DATA.has(biome) or has(data, biome):
		return false
	var st: Dictionary = owned(data)
	st[biome] = {"owner": "", "level": 1}
	data["stones"] = st
	return true


static func level(data: Dictionary, biome: String) -> int:
	return int(owned(data).get(biome, {}).get("level", 0))


static func owner_of(data: Dictionary, biome: String) -> String:
	return String(owned(data).get(biome, {}).get("owner", ""))


## Pierres portées par une classe.
static func stones_of(data: Dictionary, classe: String) -> Array[String]:
	var out: Array[String] = []
	for b: String in ORDER:
		if owner_of(data, b) == classe and classe != "":
			out.append(b)
	return out


## Confie une Pierre à `classe` (la retire à son ancien porteur). "" si OK.
static func equip(data: Dictionary, biome: String, classe: String) -> String:
	if not has(data, biome):
		return "Pierre non trouvée."
	if owner_of(data, biome) == classe:
		return ""
	if stones_of(data, classe).size() >= MAX_PER_HERO:
		return "%s porte déjà %d Pierres." % [classe, MAX_PER_HERO]
	owned(data)[biome]["owner"] = classe
	return ""


static func unequip(data: Dictionary, biome: String) -> void:
	if has(data, biome):
		owned(data)[biome]["owner"] = ""


## Coût de l'éveil vers le niveau suivant : or + ressource de la Nation.
static func awaken_cost(data: Dictionary, biome: String) -> Dictionary:
	var lv: int = level(data, biome)
	var res: String = Nations.resource_of(biome)
	return {"gold": 250 * lv * lv, "res": res, "qty": 8 * lv}


static func can_awaken(data: Dictionary, biome: String) -> String:
	var lv: int = level(data, biome)
	if lv <= 0:
		return "Pierre non trouvée."
	if lv >= MAX_LEVEL:
		return "Éveil complet."
	var c: Dictionary = awaken_cost(data, biome)
	if int(data.get("gold", 0)) < int(c["gold"]):
		return "Il faut %d or." % int(c["gold"])
	if int(data.get("resources", {}).get(String(c["res"]), 0)) < int(c["qty"]):
		return "Il faut %d %s." % [int(c["qty"]), String(c["res"])]
	return ""


static func awaken(data: Dictionary, biome: String) -> String:
	var err: String = can_awaken(data, biome)
	if err != "":
		return err
	var c: Dictionary = awaken_cost(data, biome)
	data["gold"] = int(data.get("gold", 0)) - int(c["gold"])
	var res: Dictionary = data.get("resources", {})
	res[String(c["res"])] = int(res.get(String(c["res"]), 0)) - int(c["qty"])
	data["resources"] = res
	owned(data)[biome]["level"] = level(data, biome) + 1
	return ""


## Bonus d'une Pierre au niveau `lv` : {"stats": {...}, "fx": {...}}.
static func bonus(biome: String, lv: int) -> Dictionary:
	var d: Dictionary = DATA.get(biome, {})
	var stats: Dictionary = {}
	var fx: Dictionary = {}
	if d.is_empty() or lv <= 0:
		return {"stats": stats, "fx": fx}
	for k: String in d["stats"].keys():
		stats[k] = int(d["stats"][k]) * lv
	for k2: String in d["fx"].keys():
		fx[k2] = int(d["fx"][k2]) * lv
	for k3: String in d["flat"].keys():
		fx[k3] = int(fx.get(k3, 0)) + int(d["flat"][k3])
	return {"stats": stats, "fx": fx}


## Bonus cumulé des Pierres portées par `classe`.
static func hero_bonus(data: Dictionary, classe: String) -> Dictionary:
	var stats: Dictionary = {}
	var fx: Dictionary = {}
	for b: String in stones_of(data, classe):
		var bo: Dictionary = bonus(b, level(data, b))
		for k: String in bo["stats"].keys():
			stats[k] = int(stats.get(k, 0)) + int(bo["stats"][k])
		for k2: String in bo["fx"].keys():
			fx[k2] = int(fx.get(k2, 0)) + int(bo["fx"][k2])
	return {"stats": stats, "fx": fx}


const STAT_LABEL := {"vita": "PV", "force": "Force", "intelligence": "Intelligence", "agility": "Agilité",
	"wisdom": "Sagesse", "defense": "Défense"}
const FX_LABEL := {"lifesteal": "Vol de vie +%d %%", "mres": "Résistance magie +%d %%", "crit": "Critique +%d %%",
	"mag_pct": "Dégâts magiques +%d %%", "phys_pct": "Dégâts physiques +%d %%", "heal_pct": "Soins +%d %%",
	"pa": "+%d PA", "pm": "+%d PM"}


## Lignes lisibles du bonus d'une Pierre au niveau `lv`.
static func bonus_lines(biome: String, lv: int) -> Array[String]:
	var out: Array[String] = []
	var bo: Dictionary = bonus(biome, maxi(1, lv))
	for k: String in bo["stats"].keys():
		out.append("%s +%d" % [String(STAT_LABEL.get(k, k)), int(bo["stats"][k])])
	for k2: String in bo["fx"].keys():
		out.append(String(FX_LABEL.get(k2, k2 + " +%d")) % int(bo["fx"][k2]))
	return out
