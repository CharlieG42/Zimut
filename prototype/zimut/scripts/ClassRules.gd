class_name ClassRules
extends RefCounted
## ClassRules.gd — Règles d'évolution des classes (XP, points de caractéristiques,
## paliers PA/PM). Données pures, sans état : tout est ajustable ici.
##
## Principe (façon Dofus / Waven) :
##  - les stats de BASE viennent de classes.txt au niveau du perso ;
##  - à chaque niveau gagné, le perso reçoit POINTS_PER_LEVEL points de « capital » ;
##  - chaque point investi coûte 1, 2 ou 3 points de capital selon l'AFFINITÉ de la
##    classe pour la stat (A = cœur de métier, B = secondaire, C = hors-métier) ;
##  - chaque classe a son rythme d'XP et ses paliers de PA / PM bonus.

const STATS: Array[String] = ["vita", "force", "intelligence", "agility", "wisdom", "defense"]

const STAT_LABEL := {
	"vita": "Vitalité", "force": "Force", "intelligence": "Intelligence",
	"agility": "Agilité", "wisdom": "Sagesse", "defense": "Défense",
}

## Rôle de chaque stat en combat (affiché dans la fiche perso)
const STAT_HELP := {
	"vita": "+3 PV par point",
	"force": "Dégâts physiques",
	"intelligence": "Dégâts magiques et soins",
	"agility": "Initiative et coups critiques",
	"wisdom": "Précision (anti-esquive), soins, altérations",
	"defense": "Réduit les dégâts reçus",
}

## Gain réel par point investi
const STAT_GAIN := {"vita": 3, "force": 1, "intelligence": 1, "agility": 1, "wisdom": 1, "defense": 1}

const MAX_LEVEL := 100
const START_LEVEL := 1
const POINTS_PER_LEVEL := 2
## Niveau maximum des ennemis (le héros plafonne à MAX_LEVEL).
const ENEMY_MAX_LEVEL := 150
## Points de sort : 1 par niveau de héros ; améliorer un sort de n à n+1 coûte n
## points (45 pour monter un sort de 1 à 10). 10 sorts x 45 = 450 > 99 : le héros
## ne peut pas tout maximiser, il doit choisir. Réinitialisation gratuite.
const SPELL_POINTS_PER_LEVEL := 1
const SPELL_MAX_LEVEL := 10

## XP d'un combat = somme(XP des ennemis) x FIGHT_XP_MULT
const FIGHT_XP_MULT := 1.5
const BOSS_XP_MULT := 1.5

## Gain d'XP par victoire sur le combat de la frontière, calibré sur le niveau du
## combat (ProgressionManager.combat_xp) : progression progressive et évolutive —
## environ 3 combats pour passer du niveau 10 au 11, et de plus en plus de combats
## à mesure que le niveau monte (jusqu'à ~200 pour le palier final).
const XP_PER_COMBAT_BASE := 75.6
const XP_PER_COMBAT_GROWTH := 1.038   ## par niveau de l'ancienne échelle (= 2 niveaux actuels)
const XP_PER_COMBAT_FLOOR := 110.0
const XP_PER_COMBAT_CEIL := 476.0
## Les classes hors équipe gagnent une part de l'XP (pour tester d'autres compos)
const BENCH_XP_RATIO := 0.05
## Une défaite rapporte quand même un peu d'XP
const DEFEAT_XP_RATIO := 0.15

## Caractéristiques bonus achetables avec du capital : PA, PM, PO (Portée).
## Maximum 3 niveaux chacune, 4 points de capital par niveau.
const BONUS_STATS: Array[String] = ["pa", "pm", "po"]
const BONUS_STAT_LABEL := {"pa": "PA", "pm": "PM", "po": "Portée"}
const BONUS_STAT_HELP := {
	"pa": "+1 PA par niveau (14 PA maximum au total)",
	"pm": "+1 PM par niveau (6 PM maximum au total)",
	"po": "+1 de portée pour tous les sorts (3 maximum)",
}
const BONUS_MAX_LEVELS := 3
const BONUS_POINT_COST := 4
const PA_CAP := 14
const PM_CAP := 6
const PO_CAP := 3

## Coût d'un point de capital par palier d'affinité : [[investis_max, coût], ...]
const TIER_COST := {
	"A": [[40, 1], [90, 2], [9999, 3]],
	"B": [[40, 2], [9999, 3]],
	"C": [[9999, 3]],
}

const CLASSES := {
	"Tank": {
		"xp": 1.10, "pa": [70], "pm": [],
		"aff": {"vita": "A", "defense": "A", "force": "B", "agility": "C", "wisdom": "C", "intelligence": "C"},
		"auto": {"vita": 3, "defense": 3, "force": 2},
		"role": "Encaisse et protège. Rythme d'XP rapide.",
	},
	"Assassin": {
		"xp": 0.95, "pa": [90], "pm": [40],
		"aff": {"force": "A", "agility": "A", "wisdom": "B", "vita": "B", "defense": "C", "intelligence": "C"},
		"auto": {"force": 3, "agility": 3, "vita": 1},
		"role": "Dégâts explosifs dans le dos. +1 PM au niv. 40.",
	},
	"Chasseur": {
		"xp": 1.00, "pa": [90], "pm": [60],
		"aff": {"force": "A", "agility": "A", "wisdom": "B", "vita": "B", "defense": "B", "intelligence": "C"},
		"auto": {"force": 3, "agility": 2, "vita": 1, "defense": 1},
		"role": "Tireur polyvalent. +1 PM au niv. 60.",
	},
	"Mage": {
		"xp": 0.95, "pa": [80], "pm": [],
		"aff": {"intelligence": "A", "wisdom": "A", "agility": "B", "vita": "B", "defense": "C", "force": "C"},
		"auto": {"intelligence": 4, "wisdom": 1, "vita": 1},
		"role": "Dégâts magiques. +1 PA au niv. 80.",
	},
	"Druide": {
		"xp": 1.00, "pa": [80], "pm": [],
		"aff": {"intelligence": "A", "wisdom": "A", "vita": "B", "defense": "B", "agility": "C", "force": "C"},
		"auto": {"intelligence": 3, "wisdom": 2, "vita": 1, "defense": 1},
		"role": "Soins et bénédictions. +1 PA au niv. 80.",
	},
	"Heal": {
		"xp": 1.10, "pa": [80], "pm": [],
		"aff": {"wisdom": "A", "intelligence": "A", "vita": "A", "defense": "B", "agility": "C", "force": "C"},
		"auto": {"wisdom": 3, "intelligence": 3, "vita": 2},
		"role": "Soigneur pur. Rythme d'XP rapide.",
	},
	"Invocateur": {
		"xp": 0.95, "pa": [80], "pm": [],
		"aff": {"intelligence": "A", "vita": "B", "wisdom": "B", "agility": "B", "defense": "C", "force": "C"},
		"auto": {"intelligence": 3, "vita": 2, "wisdom": 1, "agility": 1},
		"role": "Ses familiers héritent de son niveau. +1 PA au niv. 80.",
	},
	"Sylvain": {
		"xp": 0.95, "pa": [90], "pm": [70],
		"aff": {"intelligence": "A", "wisdom": "A", "vita": "B", "defense": "B", "agility": "C", "force": "C"},
		"auto": {"intelligence": 3, "wisdom": 2, "vita": 2, "defense": 1},
		"role": "Maître de la forêt. +1 PM au niv. 70.",
	},
	"Géomancien": {
		"xp": 1.0, "pa": [90], "pm": [],
		"aff": {"intelligence": "A", "defense": "B", "vita": "B", "wisdom": "B", "agility": "C", "force": "C"},
		"auto": {"intelligence": 3, "defense": 2, "vita": 2, "wisdom": 1},
		"role": "Contrôle du terrain : piliers, murailles et failles bloquent les passages. +1 PA au niv. 90.",
	},
}

const DEFAULT_RULES := {
	"xp": 1.0, "pa": [], "pm": [],
	"aff": {}, "auto": {"force": 2, "vita": 2, "defense": 1}, "role": "",
}


static func rules(classe: String) -> Dictionary:
	return CLASSES.get(classe, DEFAULT_RULES)


static func xp_mult(classe: String) -> float:
	return float(rules(classe).get("xp", 1.0))


static func affinity(classe: String, stat: String) -> String:
	return String(rules(classe).get("aff", {}).get(stat, "C"))


## Capital total gagné jusqu'au niveau `level` (le niveau 1 n'en donne pas).
static func total_points_for_level(level: int) -> int:
	return maxi(0, level - 1) * POINTS_PER_LEVEL


## Coût du PROCHAIN point pour une stat déjà investie de `invested` points.
static func point_cost(classe: String, stat: String, invested: int) -> int:
	if BONUS_STATS.has(stat):
		return BONUS_POINT_COST
	for tier: Array in TIER_COST[affinity(classe, stat)]:
		if invested < int(tier[0]):
			return int(tier[1])
	return 3


## Coût cumulé pour passer de `from_inv` à `to_inv` points investis.
static func cost_between(classe: String, stat: String, from_inv: int, to_inv: int) -> int:
	var total: int = 0
	for i: int in range(from_inv, to_inv):
		total += point_cost(classe, stat, i)
	return total


## Bonus de PA / PM obtenus par les paliers jusqu'au niveau `level`.
static func milestone_bonus(classe: String, level: int) -> Dictionary:
	var out := {"pa": 0, "pm": 0}
	for k: String in ["pa", "pm"]:
		for lv in rules(classe).get(k, []):
			if level >= int(lv):
				out[k] = int(out[k]) + 1
	return out


## Répartition automatique : dépense tout le capital selon la recette de la classe.
## Proportionnelle : on achète toujours la stat dont le ratio investi / poids est le
## plus faible (parmi celles que le capital restant permet d'acheter). Marche aussi
## avec 2 points par niveau (l'ancienne boucle donnait tout à la 1re stat).
## invested : { stat: points investis } (modifié) ; retourne le capital restant.
static func auto_allocate(classe: String, invested: Dictionary, unspent: int) -> int:
	var recipe: Dictionary = rules(classe).get("auto", {})
	if recipe.is_empty():
		return unspent
	var guard: int = 0
	while unspent > 0 and guard < 5000:
		guard += 1
		var best: String = ""
		var best_ratio: float = 1e18
		for stat in recipe.keys():
			var cost: int = point_cost(classe, String(stat), int(invested.get(stat, 0)))
			if cost > unspent:
				continue
			var ratio: float = float(invested.get(stat, 0) + 1) / float(maxi(1, int(recipe[stat])))
			if ratio < best_ratio:
				best_ratio = ratio
				best = String(stat)
		if best == "":
			break
		unspent -= point_cost(classe, best, int(invested.get(best, 0)))
		invested[best] = int(invested.get(best, 0)) + 1
	return unspent
