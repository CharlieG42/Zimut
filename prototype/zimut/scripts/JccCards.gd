class_name JccCards
extends RefCounted
## JccCards.gd — Catalogue des cartes du mode Cartes (JCC à voies) : data/cartes_jcc.txt.
## Colonnes (séparateur « | ») : Id|Nom|Type|Cout|Atq|PV|PA|PM|PO|Rarete|Classe|Sort|SortCout|Effet|Valeur|Duree|Cible|Sprite|MotsCles
## MotsCles (séparés par « ; ») : vol (soigne l'attaquant), perforation (excédent au héros),
## provocation (cible forcée), regeneration (+2 PV/tour), initiative (pas de riposte).
## Cout = mana ; PA = actions (attaque/sort) ; PM = déplacement ; PO = portée d'attaque.
## Types : Creature (porte UN sort distinctif), Sort (carte jouée une fois), Jeton (invocation, jamais dans un deck).

const PATH := "res://data/cartes_jcc.txt"
const RARITIES := {"C": "Commune", "R": "Rare", "E": "Épique", "L": "Légendaire"}

static var _cards: Dictionary = {}
static var _order: Array = []


static func _load() -> void:
	if not _cards.is_empty():
		return
	var f: FileAccess = FileAccess.open(PATH, FileAccess.READ)
	if f == null:
		push_warning("JccCards : %s introuvable" % PATH)
		return
	var header: PackedStringArray = PackedStringArray()
	while not f.eof_reached():
		var line: String = f.get_line().strip_edges()
		if line == "":
			continue
		var cols: PackedStringArray = line.split("|")
		if header.is_empty():
			header = cols
			continue
		var row: Dictionary = {}
		for i: int in header.size():
			row[header[i]] = cols[i] if i < cols.size() else ""
		var card: Dictionary = {
			"id": String(row["Id"]), "name": String(row["Nom"]), "type": String(row["Type"]),
			"cost": int(row["Cout"]), "atk": int(row["Atq"]), "hp": int(row["PV"]),
			"pa": int(row.get("PA", "1")) if row.has("PA") else 1,
			"pm": int(row.get("PM", "2")) if row.has("PM") else 2,
			"po": int(row.get("PO", "1")) if row.has("PO") else 1,
			"rarity": String(row["Rarete"]) if String(row["Rarete"]) != "" else "C",
			"classe": String(row["Classe"]), "sort": String(row["Sort"]), "sort_cost": int(row["SortCout"]),
			"effet": String(row["Effet"]), "valeur": String(row["Valeur"]), "duree": int(row["Duree"]),
			"cible": String(row["Cible"]), "sprite": String(row["Sprite"]),
		}
		var kws: Array = []
		for k in String(row.get("MotsCles", "")).split(";"):
			var kk: String = k.strip_edges()
			if kk != "":
				kws.append(kk)
		card["keywords"] = kws
		_cards[card["id"]] = card
		_order.append(card["id"])


static func get_card(id: String) -> Dictionary:
	_load()
	if id.contains("@") or id.contains("~"):
		return _leveled(id)
	var c: Dictionary = _cards.get(id, {})
	if c.is_empty():
		return c
	var out: Dictionary = c.duplicate()
	out["lvl"] = 1
	out["base_id"] = id
	return out


const MAX_LEVEL := 5


static func base_of(key: String) -> String:
	return key.get_slice("~", 0).get_slice("@", 0)


static func level_of(key: String) -> int:
	var head: String = key.get_slice("~", 0)
	if not head.contains("@"):
		return 1
	return clampi(int(head.get_slice("@", 1)), 1, MAX_LEVEL)


## Fortifications d'une clé (« id@3~AM » -> « AM »).
static func forts_of(key: String) -> String:
	return key.get_slice("~", 1) if key.contains("~") else ""


## Fortifications possibles sur une créature : code -> {label, kw (mot-clé) ou stat}.
const FORTS := {
	"A": {"label": "+1 PA", "stat": "pa"},
	"M": {"label": "+1 PM", "stat": "pm"},
	"O": {"label": "+1 PO", "stat": "po"},
	"P": {"label": "Provocation", "kw": "provocation"},
	"I": {"label": "Initiative", "kw": "initiative"},
	"R": {"label": "Régénération", "kw": "regeneration"},
	"F": {"label": "Perforation", "kw": "perforation"},
	"V": {"label": "Vol", "kw": "vol"},
}
const MAX_FORTS := 2


## Clé de collection pour un niveau (niveau 1 = id nu).
static func key_of(id: String, lvl: int, forts: String = "") -> String:
	var k: String = id if lvl <= 1 else "%s@%d" % [id, lvl]
	return k if forts == "" else "%s~%s" % [k, forts]


## Carte fusionnée « id@n » : créatures +1 ATQ/+1 PV par niveau, sorts +1 à l'effet par niveau,
## coût en mana −1 au niveau 3 puis −1 au niveau 5 (plancher 1, sauf coût de base 0).
static func _leveled(key: String) -> Dictionary:
	var base: String = base_of(key)
	var lvl: int = level_of(key)
	if not _cards.has(base):
		return {}
	var c: Dictionary = (_cards[base] as Dictionary).duplicate()
	c["lvl"] = lvl
	c["base_id"] = base
	c["forts"] = forts_of(key)
	if String(c["type"]) == "Creature":
		for ch in forts_of(key):
			var f: Dictionary = FORTS.get(String(ch), {})
			if f.has("stat"):
				c[String(f["stat"])] = int(c[String(f["stat"])]) + 1
			elif f.has("kw"):
				var kws: Array = (c["keywords"] as Array).duplicate()
				if not kws.has(String(f["kw"])):
					kws.append(String(f["kw"]))
				c["keywords"] = kws
	if lvl <= 1:
		c["id"] = key
		return c
	if String(c["type"]) == "Creature":
		c["atk"] = int(c["atk"]) + (lvl - 1)
		c["hp"] = int(c["hp"]) + (lvl - 1)
	elif String(c["effet"]) not in ["invoquer", ""] and String(c["valeur"]).is_valid_int():
		c["valeur"] = str(int(c["valeur"]) + (lvl - 1))
	var base_cost: int = int(c["cost"])
	if base_cost > 0:
		var red: int = (1 if lvl >= 3 else 0) + (1 if lvl >= 5 else 0)
		c["cost"] = maxi(1, base_cost - red)
	c["id"] = key
	return c


static func all_ids() -> Array:
	_load()
	return _order.duplicate()


## Cartes qui peuvent figurer dans un deck (tout sauf les jetons).
static func collectible_ids() -> Array:
	_load()
	var out: Array = []
	for id: String in _order:
		if String(_cards[id]["type"]) != "Jeton":
			out.append(id)
	return out


static func rarity_label(r: String) -> String:
	return String(RARITIES.get(r, "Commune"))


## Texte d'un effet ("Inflige 4 dégâts à une créature ennemie", …).
static func effect_text(card: Dictionary, creature_sort: bool = false) -> String:
	var v: String = String(card["valeur"])
	var d: int = int(card["duree"])
	var t: String = ""
	match String(card["effet"]):
		"degats":
			t = "Inflige %s dégâts" % v + _target_suffix(card)
		"degats_zone":
			t = "Inflige %s dégâts à toutes les créatures ennemies" % v
		"degats_heros":
			t = "Inflige %s dégâts au héros ennemi" % v
		"soin":
			t = "Rend %s PV" % v + _target_suffix(card)
		"soin_zone":
			t = "Rend %s PV à toutes vos créatures" % v
		"atq":
			t = "+%s attaque" % v + _target_suffix(card)
		"atq_zone":
			t = "+%s attaque à toutes vos créatures" % v
		"bouclier":
			t = "+%s PV" % v + _target_suffix(card)
		"bouclier_zone":
			t = "+%s PV à toutes vos créatures" % v
		"etourdir":
			t = "Étourdit %d tour" % maxi(d, 1) + _target_suffix(card)
		"etourdir_zone":
			t = "Étourdit toutes les créatures ennemies %d tour" % maxi(d, 1)
		"poison":
			t = "Poison : %s dégâts par tour pendant %d tours" % [v, d] + _target_suffix(card)
		"invoquer":
			var tok: Dictionary = get_card(v)
			t = "Invoque %s (%d/%d) sur une case libre de votre zone de déploiement" % [tok.get("name", "une créature"), int(tok.get("atk", 0)), int(tok.get("hp", 0))]
		"pioche":
			t = "Pioche %s cartes" % v
		"mana":
			t = "+%s mana ce tour" % v
	return t


static func _target_suffix(card: Dictionary) -> String:
	match String(card["cible"]):
		"ennemi":
			return " à une créature ennemie"
		"ennemi_ou_heros":
			return " à une cible ennemie"
		"allie":
			return " à une de vos créatures"
		"allie_ou_heros":
			return " à une cible alliée"
	return ""
