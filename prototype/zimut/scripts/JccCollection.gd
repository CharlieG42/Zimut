class_name JccCollection
extends RefCounted
## JccCollection.gd — Collection de cartes du joueur, deck de 20 cartes, adversaires et butin (mode Cartes).
## Tout vit dans save["jcc"] = {"collection": {id: n}, "deck": [ids], "wins": n, "losses": n}.

const DECK_SIZE: int = 20
const MAX_COPIES: int = 2

## Adversaires : nom, camp d'héros (sprite du portrait), deck de 20 cartes, éventuel boss (carte à gagner).
const OPPONENTS: Array = [
	{"name": "Meute de gobelins", "sprite": "enemies/gobelin", "boss": "",
		"deck": "m_gobelin m_gobelin m_gobelin m_gobelin m_loup m_loup m_loup e_archer e_archer m_troll s_etincelle s_etincelle s_charge s_charge s_javelot s_loup s_loup s_volee s_volee s_frappe"},
	{"name": "Armée de squelettes", "sprite": "enemies/squelette", "boss": "",
		"deck": "m_squelette m_squelette m_squelette m_squelette c_assassin c_assassin m_troll e_ent s_protection s_protection s_eclair s_eclair s_fleche_poison s_fleche_poison c_chasseur s_javelot s_trait_glace s_benediction m_loup m_gobelin"},
	{"name": "Couvée de feu", "sprite": "enemies/dragonnet", "boss": "",
		"deck": "m_dragonnet m_dragonnet m_dragonnet c_mage c_mage s_boule_feu s_boule_feu s_eclair s_eclair s_explosion s_etincelle s_etincelle c_artificier c_artificier e_cristal e_cristal s_frappe s_inspiration s_javelot s_attaque_sacree"},
	{"name": "Gobelin Roi", "sprite": "enemies/gobelin_boss", "boss": "b_gobelin_roi",
		"deck": "b_gobelin_roi m_gobelin m_gobelin m_gobelin m_gobelin m_loup m_loup m_loup m_troll m_troll s_charge s_charge s_cri_guerre s_frappe s_frappe s_javelot e_archer e_archer s_volee s_etincelle"},
	{"name": "Troll Géant", "sprite": "enemies/troll_boss", "boss": "b_troll_geant",
		"deck": "b_troll_geant m_troll m_troll m_troll e_golem e_ent c_tank c_tank s_protection s_protection s_soin_combat s_soin_combat s_javelot s_javelot s_frappe s_frappe s_mur_pierre s_mur_pierre c_druide s_soin"},
	{"name": "Dragon", "sprite": "enemies/dragonnet_boss", "boss": "b_dragon",
		"deck": "b_dragon m_dragonnet m_dragonnet m_dragonnet c_mage c_mage c_artificier e_cristal e_cristal s_boule_feu s_boule_feu s_explosion s_explosion s_eclair s_etincelle s_etincelle s_attaque_sacree s_inspiration s_cristal_mana s_trait_glace"},
]


static func ensure(save: Dictionary) -> Dictionary:
	if not save.has("jcc") or typeof(save["jcc"]) != TYPE_DICTIONARY:
		save["jcc"] = {}
	var j: Dictionary = save["jcc"]
	if not j.has("collection") or (j["collection"] as Dictionary).is_empty():
		j["collection"] = starter_collection()
	if not j.has("deck") or (j["deck"] as Array).is_empty():
		j["deck"] = starter_deck()
	j["wins"] = int(j.get("wins", 0))
	j["losses"] = int(j.get("losses", 0))
	return j


static func starter_collection() -> Dictionary:
	var col: Dictionary = {}
	for id: String in JccCards.collectible_ids():
		var c: Dictionary = JccCards.get_card(id)
		match String(c["rarity"]):
			"C":
				col[id] = 2
			"R":
				col[id] = 1
			"E":
				if id in ["e_archer", "e_ent"]:
					col[id] = 1
	return col


static func starter_deck() -> Array:
	return "c_tank c_mage c_druide c_chasseur c_assassin m_gobelin m_gobelin m_loup m_loup m_squelette m_troll s_etincelle s_etincelle s_javelot s_eclair s_soin s_protection s_volee s_loup s_frappe".split(" ")


static func parse_deck(text: String) -> Array:
	return Array(text.split(" ", false))


static func max_copies(id: String) -> int:
	return 1 if String(JccCards.get_card(id).get("rarity", "C")) in ["L", "E"] else MAX_COPIES


## Possédées (collection) ; nombre d'exemplaires d'une carte.
static func owned(save: Dictionary, id: String) -> int:
	var j: Dictionary = ensure(save)
	return int((j["collection"] as Dictionary).get(id, 0))


## Un deck est valide : 20 cartes, jamais plus d'exemplaires que possédés/autorisés, aucun jeton.
static func deck_error(save: Dictionary, deck: Array) -> String:
	if deck.size() != DECK_SIZE:
		return "Le deck doit contenir %d cartes (%d)." % [DECK_SIZE, deck.size()]
	var counts: Dictionary = {}
	for id: Variant in deck:
		var sid: String = String(id)
		var c: Dictionary = JccCards.get_card(sid)
		if c.is_empty() or String(c["type"]) == "Jeton":
			return "Carte inconnue : %s." % sid
		counts[sid] = int(counts.get(sid, 0)) + 1
		if int(counts[sid]) > mini(max_copies(sid), owned(save, sid)):
			return "Trop d'exemplaires de %s." % c["name"]
	return ""


static func add_card(save: Dictionary, id: String) -> void:
	var j: Dictionary = ensure(save)
	var col: Dictionary = j["collection"]
	col[id] = int(col.get(id, 0)) + 1


## Tire une carte de butin après une victoire. Un adversaire boss peut laisser sa propre carte.
static func roll_loot(rng: RandomNumberGenerator, boss_id: String = "") -> String:
	if boss_id != "" and rng.randf() < 0.4:
		return boss_id
	var r: float = rng.randf()
	var rar: String = "C"
	if r < 0.08:
		rar = "L"
	elif r < 0.28:
		rar = "E"
	elif r < 0.60:
		rar = "R"
	var pool: Array = []
	for id: String in JccCards.collectible_ids():
		if String(JccCards.get_card(id)["rarity"]) == rar:
			pool.append(id)
	if pool.is_empty():
		return "m_gobelin"
	return String(pool[rng.randi_range(0, pool.size() - 1)])


static func opponent(index: int) -> Dictionary:
	return OPPONENTS[clampi(index, 0, OPPONENTS.size() - 1)]
