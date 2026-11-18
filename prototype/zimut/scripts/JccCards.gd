class_name JccCards
extends RefCounted
## JccCards.gd — Catalogue des cartes du mode Cartes (JCC à voies) : data/cartes_jcc.txt.
## Colonnes (séparateur « | ») : Id|Nom|Type|Cout|Atq|PV|Rarete|Classe|Sort|SortCout|Effet|Valeur|Duree|Cible|Sprite
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
			"rarity": String(row["Rarete"]) if String(row["Rarete"]) != "" else "C",
			"classe": String(row["Classe"]), "sort": String(row["Sort"]), "sort_cost": int(row["SortCout"]),
			"effet": String(row["Effet"]), "valeur": String(row["Valeur"]), "duree": int(row["Duree"]),
			"cible": String(row["Cible"]), "sprite": String(row["Sprite"]),
		}
		_cards[card["id"]] = card
		_order.append(card["id"])


static func get_card(id: String) -> Dictionary:
	_load()
	return _cards.get(id, {})


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
			t = "Invoque %s (%d/%d)" % [tok.get("name", "une créature"), int(tok.get("atk", 0)), int(tok.get("hp", 0))]
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
