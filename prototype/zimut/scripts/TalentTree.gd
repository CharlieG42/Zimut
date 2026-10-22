class_name TalentTree
extends RefCounted
## TalentTree.gd — Arbre de talents account-wide (V42).
##
## Talents permanents débloqués avec les succès (succès = "points de gloire").
## Stockés dans user://talents.json (indépendant des sauvegardes) :
##   { "unlocked": { id: true }, "points": n }
##
## Les bonus s'appliquent à TOUTES les parties : XP, or, ressources,
## PA/PM de départ, soins, etc.

signal talents_changed

const TALENTS_PATH := "user://talents.json"

## id, nom, description, coût (points), branche, bonus {clé: valeur}
## Branches : "offense", "defense", "utility", "economy"
const LIST: Array = [
	# ── Branche Offense ──
	["off_veteran", "Vétéran", "+5 % de dégâts", 1, "offense", {"dmg_pct": 5}],
	["off_critique", "Coup critique", "+5 % de chance de critique", 2, "offense", {"crit_pct": 5}],
	["off_fury", "Fureur", "+10 % de dégâts", 3, "offense", {"dmg_pct": 10}],
	["off_master", "Maître d'armes", "+10 % de critique", 4, "offense", {"crit_pct": 10}],
	# ── Branche Defense ──
	["def_vita", "Robuste", "+5 % de PV max", 1, "defense", {"pv_pct": 5}],
	["def_armure", "Armure", "+5 % de défense", 2, "defense", {"def_pct": 5}],
	["def_resilience", "Résilience", "+10 % de PV max", 3, "defense", {"pv_pct": 10}],
	["def_implacable", "Implacable", "+10 % de défense", 4, "defense", {"def_pct": 10}],
	# ── Branche Utility ──
	["util_pa", "Action supplémentaire", "+1 PA au début de chaque combat", 2, "utility", {"pa": 1}],
	["util_pm", "Course", "+1 PM au début de chaque combat", 2, "utility", {"pm": 1}],
	["util_soin", "Soigneur né", "+10 % de soins", 3, "utility", {"heal_pct": 10}],
	# ── Branche Economy ──
	["eco_xp", "Apprentissage", "+10 % d'XP gagnée", 1, "economy", {"xp_pct": 10}],
	["eco_or", "Avarice", "+15 % d'or gagné", 2, "economy", {"gold_pct": 15}],
	["eco_loot", "Butin", "+1 ressource de plus par combat", 3, "economy", {"res_bonus": 1}],
	["eco_rappel", "Rappel éclair", "Les héros K.O. renaissent avec 25 % PV (1 fois/combat)", 4, "economy", {"revive_pct": 25}],
]

const BRANCHES: Dictionary = {
	"offense": {"label": "Offense", "color": Color(0.95, 0.45, 0.35), "icon": "\u2694"},
	"defense": {"label": "Défense", "color": Color(0.45, 0.65, 0.95), "icon": "\u26e8"},
	"utility": {"label": "Utilitaire", "color": Color(0.55, 0.90, 0.55), "icon": "\u2728"},
	"economy": {"label": "Économie", "color": Color(1.0, 0.82, 0.35), "icon": "\ud83d\udcb0"},
}

static var _unlocked: Dictionary = {}
static var _points: int = 0
static var _loaded: bool = false


static func _ensure_loaded() -> void:
	if _loaded:
		return
	_loaded = true
	_unlocked = {}
	_points = 0
	if not FileAccess.file_exists(TALENTS_PATH):
		return
	var f: FileAccess = FileAccess.open(TALENTS_PATH, FileAccess.READ)
	if f == null:
		return
	var parsed: Variant = JSON.parse_string(f.get_as_text())
	f.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	var d: Dictionary = parsed
	var u: Variant = d.get("unlocked", {})
	if typeof(u) == TYPE_DICTIONARY:
		_unlocked = u
	_points = int(d.get("points", 0))


static func _save() -> void:
	var f: FileAccess = FileAccess.open(TALENTS_PATH, FileAccess.WRITE)
	if f == null:
		push_error("Impossible d'écrire les talents")
		return
	f.store_string(JSON.stringify({"unlocked": _unlocked, "points": _points}, "\t"))
	f.close()


static func is_unlocked(id: String) -> bool:
	_ensure_loaded()
	return _unlocked.has(id)


static func points() -> int:
	_ensure_loaded()
	return _points


## Ajoute des points de gloire (appelé quand un succès est débloqué).
static func add_points(n: int) -> void:
	_ensure_loaded()
	_points += n
	_save()


static func spend_point(id: String) -> bool:
	_ensure_loaded()
	if _points <= 0 or _unlocked.has(id):
		return false
	_unlocked[id] = true
	_points -= 1
	_save()
	return true


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


## Bonus agrégés de tous les talents débloqués.
static func total_bonus() -> Dictionary:
	_ensure_loaded()
	var out: Dictionary = {"dmg_pct": 0, "crit_pct": 0, "pv_pct": 0, "def_pct": 0,
		"pa": 0, "pm": 0, "heal_pct": 0, "xp_pct": 0, "gold_pct": 0, "res_bonus": 0, "revive_pct": 0}
	for id: String in _unlocked.keys():
		var info: Dictionary = talent_info(id)
		if info.is_empty():
			continue
		var bonus: Dictionary = info["bonus"]
		for k: String in bonus.keys():
			if k == "pa" or k == "pm" or k == "res_bonus" or k == "revive_pct":
				out[k] = int(out.get(k, 0)) + int(bonus[k])
			else:
				out[k] = int(out.get(k, 0)) + int(bonus[k])
	return out


## Libellé lisible du bonus d'un talent.
static func bonus_label(id: String) -> String:
	var info: Dictionary = talent_info(id)
	if info.is_empty():
		return ""
	return String(info["desc"])


## Nombre de talents débloqués (pour les stats).
static func unlocked_count() -> int:
	_ensure_loaded()
	return _unlocked.size()


## Réinitialise tous les talents (debug / option "reset").
static func reset_all() -> void:
	_unlocked = {}
	_points = 0
	_loaded = true
	_save()
