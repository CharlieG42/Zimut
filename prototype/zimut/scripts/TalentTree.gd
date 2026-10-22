class_name TalentTree
extends RefCounted
## TalentTree.gd — Arbre de talents PAR PERSONNAGE (V42, refonte).
##
## Chaque héros possède son propre arbre, débloqué à partir du niveau 15.
## Les talents sont stockés DANS la sauvegarde, dans le roster :
##   data["roster"][classe]["talents"] = {"unlocked": {id: true}, "points": n}
##
## Les points de pouvoir se gagnent en atteignant des paliers de niveau :
##   1 point tous les POWER_PER_LEVEL niveaux à partir de UNLOCK_LEVEL.
##
## Les bonus (dégâts, soins, critique, PV, défense, PA, PM, résurrection)
## s'appliquent UNIQUEMENT au héros concerné, via member_stats().
## Les bonus account-wide (XP, or, ressources) ont été retirés : un arbre
## par personnage ne doit pas avantager les autres héros de la partie.

signal talents_changed(classe: String)

## Niveau à partir duquel l'arbre se débloque.
const UNLOCK_LEVEL := 15
## 1 point de pouvoir tous les N niveaux à partir de UNLOCK_LEVEL.
const POWER_PER_LEVEL := 5

## id, nom, description, coût (points), branche, bonus {clé: valeur}
## Branches : "offense", "defense", "utility", "power"
const LIST: Array = [
	# ── Branche Offense ──
	["off_veteran", "Vétéran", "+5 % de dégâts", 1, "offense", {"dmg_pct": 5}],
	["off_critique", "Coup critique", "+5 % de chance de critique", 2, "offense", {"crit_pct": 5}],
	["off_fury", "Fureur", "+10 % de dégâts", 3, "offense", {"dmg_pct": 10}],
	["off_master", "Maître d'armes", "+10 % de critique", 4, "offense", {"crit_pct": 10}],
	# ── Branche Défense ──
	["def_vita", "Robuste", "+5 % de PV max", 1, "defense", {"pv_pct": 5}],
	["def_armure", "Armure", "+5 % de défense", 2, "defense", {"def_pct": 5}],
	["def_resilience", "Résilience", "+10 % de PV max", 3, "defense", {"pv_pct": 10}],
	["def_implacable", "Implacable", "+10 % de défense", 4, "defense", {"def_pct": 10}],
	# ── Branche Utilitaire ──
	["util_pa", "Action supplémentaire", "+1 PA au début de chaque combat", 2, "utility", {"pa": 1}],
	["util_pm", "Course", "+1 PM au début de chaque combat", 2, "utility", {"pm": 1}],
	["util_soin", "Soigneur né", "+10 % de soins", 3, "utility", {"heal_pct": 10}],
	# ── Branche Puissance (spécifique arbre de perso) ──
	["pow_rage", "Rage intérieure", "+15 % de dégâts", 3, "power", {"dmg_pct": 15}],
	["pow_aura", "Aura vitale", "+15 % de PV max et +10 % de soins", 3, "power", {"pv_pct": 15, "heal_pct": 10}],
	["pow_second_souffle", "Second souffle", "Renaît avec 25 % PV (1 fois/combat)", 4, "power", {"revive_pct": 25}],
]

const BRANCHES: Dictionary = {
	"offense": {"label": "Offense", "color": Color(0.95, 0.45, 0.35), "icon": "⚔"},
	"defense": {"label": "Défense", "color": Color(0.45, 0.65, 0.95), "icon": "⛨"},
	"utility": {"label": "Utilitaire", "color": Color(0.55, 0.90, 0.55), "icon": "✨"},
	"power": {"label": "Puissance", "color": Color(0.85, 0.45, 0.95), "icon": "★"},
}


## ── État d'un héros (dans data["roster"][classe]) ──

static func _entry(data: Dictionary, classe: String) -> Dictionary:
	if not data.has("roster") or not data["roster"].has(classe):
		return {}
	return data["roster"][classe]


static func _talents(data: Dictionary, classe: String) -> Dictionary:
	var ent: Dictionary = _entry(data, classe)
	if ent.is_empty():
		return {}
	if not ent.has("talents"):
		ent["talents"] = {"unlocked": {}, "points": 0}
	return ent["talents"]


static func is_unlocked(data: Dictionary, classe: String, id: String) -> bool:
	var t: Dictionary = _talents(data, classe)
	if t.is_empty():
		return false
	return bool((t["unlocked"] as Dictionary).get(id, false))


## Points de pouvoir disponibles pour ce héros.
static func points(data: Dictionary, classe: String) -> int:
	var ent: Dictionary = _entry(data, classe)
	if ent.is_empty():
		return 0
	return int(_talents(data, classe).get("points", 0))


## Nombre de talents débloqués.
static func unlocked_count(data: Dictionary, classe: String) -> int:
	var t: Dictionary = _talents(data, classe)
	if t.is_empty():
		return 0
	return (t["unlocked"] as Dictionary).size()


## Débloque un talent pour ce héros. Retourne true si réussi.
static func spend_point(data: Dictionary, classe: String, id: String) -> bool:
	var t: Dictionary = _talents(data, classe)
	if t.is_empty():
		return false
	var unlocked: Dictionary = t["unlocked"]
	if bool(unlocked.get(id, false)) or int(t.get("points", 0)) <= 0:
		return false
	if talent_info(id).is_empty():
		return false
	unlocked[id] = true
	t["points"] = int(t.get("points", 0)) - 1
	return true


## ── Points de pouvoir gagnés par paliers de niveau ──

## Nombre de points de pouvoir que le héros AURA au niveau `level`
## (1 point tous les POWER_PER_LEVEL niveaux à partir de UNLOCK_LEVEL).
static func power_for_level(level: int) -> int:
	if level < UNLOCK_LEVEL:
		return 0
	return (level - UNLOCK_LEVEL) / POWER_PER_LEVEL + 1


## Nombre de points gagnés entre deux niveaux (appelé quand le héros monte
## de `from_level` à `to_level`). Retourne le nombre de points à ajouter.
static func power_gained(from_level: int, to_level: int) -> int:
	return maxi(0, power_for_level(to_level) - power_for_level(from_level))


## Applique les paliers : à chaque montée de niveau, ajoute les points de
## pouvoir gagnés au roster. Appelé par award_xp().
static func apply_level_up(data: Dictionary, classe: String, from_level: int, to_level: int) -> int:
	if to_level <= from_level:
		return 0
	var gained: int = power_gained(from_level, to_level)
	if gained <= 0:
		return 0
	var t: Dictionary = _talents(data, classe)
	if t.is_empty():
		return 0
	t["points"] = int(t.get("points", 0)) + gained
	return gained


## ── Métadonnées et bonus ──

static func talent_info(id: String) -> Dictionary:
	for t: Array in LIST:
		if String(t[0]) == id:
			return {"id": id, "name": String(t[1]), "desc": String(t[2]),
				"cost": int(t[3]), "branch": String(t[4]), "bonus": t[5]}
	return {}


static func branch_talents(branch: String) -> Array:
	var out: Array = []
	for t: Array in LIST:
		if String(t[4]) == branch:
			out.append(t)
	return out


static func all_ids() -> Array[String]:
	var out: Array[String] = []
	for t: Array in LIST:
		out.append(String(t[0]))
	return out


## Bonus agrégés des talents débloqués pour CE héros.
## Clés : dmg_pct, crit_pct, pv_pct, def_pct, pa, pm, heal_pct, revive_pct.
static func total_bonus(data: Dictionary, classe: String) -> Dictionary:
	var out: Dictionary = {"dmg_pct": 0, "crit_pct": 0, "pv_pct": 0, "def_pct": 0,
		"pa": 0, "pm": 0, "heal_pct": 0, "revive_pct": 0}
	var t: Dictionary = _talents(data, classe)
	if t.is_empty():
		return out
	for id: String in (t["unlocked"] as Dictionary).keys():
		var info: Dictionary = talent_info(id)
		if info.is_empty():
			continue
		var bonus: Dictionary = info["bonus"]
		for k: String in bonus.keys():
			out[k] = int(out.get(k, 0)) + int(bonus[k])
	return out


## Libellé lisible du bonus d'un talent.
static func bonus_label(id: String) -> String:
	var info: Dictionary = talent_info(id)
	if info.is_empty():
		return ""
	return String(info["desc"])
