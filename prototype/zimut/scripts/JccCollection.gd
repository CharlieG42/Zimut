class_name JccCollection
extends RefCounted
## JccCollection.gd — Collection de cartes du joueur, decks de 20 cartes, défis du jour, adversaires et butin (mode Cartes).
## Tout vit dans save["jcc"] = {"collection": {id: n}, "deck": [ids] (miroir du deck actif), "decks": {nom: [ids]},
##   "active_deck": nom, "wins": n, "losses": n, "unlocked": [idx], "challenge": {date, id, text, target, progress, done}}.

const DECK_SIZE: int = 20
const MAX_COPIES: int = 2
const DECK_SLOTS: int = 3

## Défis quotidiens : un par jour (hash de la date). "wins" se gagne sur n'importe quel duel, les autres en un seul duel.
const CHALLENGES: Array = [
	{"id": "win", "text": "Gagner un duel", "stat": "wins", "target": 1},
	{"id": "creatures", "text": "Poser 4 créatures en un duel", "stat": "creatures", "target": 4},
	{"id": "spells", "text": "Lancer 3 sorts en un duel", "stat": "spells", "target": 3},
	{"id": "hero_dmg", "text": "Infliger 12 dégâts au héros adverse en un duel", "stat": "hero_dmg", "target": 12},
]

## Adversaires : nom, camp d'héros (sprite du portrait), deck de 20 cartes, éventuel boss (carte à gagner).
const OPPONENTS: Array = [
	{"name": "Meute de gobelins", "biome": "Forêt", "accent": "#6fcf5a", "sprite": "enemies/gobelin", "boss": "",
		"deck": "m_gobelin m_gobelin m_gobelin m_gobelin m_loup m_loup m_loup e_archer e_archer m_troll s_etincelle s_etincelle s_charge s_charge s_javelot s_loup s_loup s_volee s_volee s_frappe"},
	{"name": "Armée de squelettes", "biome": "Marais", "accent": "#b8a6e8", "sprite": "enemies/squelette", "boss": "",
		"deck": "m_squelette m_squelette m_squelette m_squelette c_assassin c_assassin m_troll e_ent s_protection s_protection s_eclair s_eclair s_fleche_poison s_fleche_poison c_chasseur s_javelot s_trait_glace s_benediction m_loup m_gobelin"},
	{"name": "Gobelin Roi", "biome": "Plaine", "accent": "#e8c040", "sprite": "enemies/gobelin_boss", "boss": "b_gobelin_roi",
		"deck": "b_gobelin_roi m_gobelin m_gobelin m_gobelin m_gobelin m_loup m_loup m_loup m_troll m_troll s_charge s_charge s_cri_guerre s_frappe s_frappe s_javelot e_archer e_archer s_volee s_boule_feu"},
	{"name": "Couvée de feu", "biome": "Désert", "accent": "#ff7a30", "sprite": "enemies/dragonnet", "boss": "",
		"deck": "m_dragonnet m_dragonnet m_dragonnet c_mage m_gobelin s_boule_feu m_loup s_eclair m_gobelin s_explosion s_etincelle m_loup c_artificier e_archer e_cristal e_cristal s_frappe s_inspiration s_javelot s_attaque_sacree"},
	{"name": "Troll Géant", "biome": "Montagne", "accent": "#c07a50", "sprite": "enemies/troll_boss", "boss": "b_troll_geant",
		"deck": "b_troll_geant m_troll m_troll m_gobelin e_golem m_loup m_gobelin c_tank s_protection m_loup s_soin_combat s_charge s_javelot s_javelot s_frappe s_frappe s_mur_pierre s_cri_guerre c_druide s_volee"},
	{"name": "Dragon", "biome": "Montagne", "accent": "#ff3b3b", "sprite": "enemies/dragonnet_boss", "boss": "b_dragon",
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
	# migration multi-decks : j["decks"] = {nom: [ids]} ; j["deck"] reste le miroir du deck actif
	if not j.has("decks") or typeof(j["decks"]) != TYPE_DICTIONARY or (j["decks"] as Dictionary).is_empty():
		j["decks"] = {"Deck 1": (j["deck"] as Array).duplicate()}
	if not j.has("active_deck") or not (j["decks"] as Dictionary).has(String(j["active_deck"])):
		j["active_deck"] = String((j["decks"] as Dictionary).keys()[0])
	if not j.has("unlocked") or typeof(j["unlocked"]) != TYPE_ARRAY:
		j["unlocked"] = [0]
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


## --- Atelier de fusion : 2 exemplaires de niveau n -> 1 exemplaire de niveau n+1 (max niveau 5) ---

const FUSE_COST: int = 2


static func can_fuse(save: Dictionary, key: String) -> bool:
	return not JccCards.get_card(key).is_empty() and JccCards.level_of(key) < JccCards.MAX_LEVEL and owned(save, key) >= FUSE_COST


## Fusionne 2 exemplaires de `key`. Retourne la clé obtenue, ou "" si impossible.
## Les decks qui utilisaient plus d'exemplaires que possédés sont réparés (la carte fusionnée remplace l'une des cartes retirées).
static func fuse(save: Dictionary, key: String) -> String:
	if not can_fuse(save, key):
		return ""
	var j: Dictionary = ensure(save)
	var col: Dictionary = j["collection"]
	var out_key: String = JccCards.key_of(JccCards.base_of(key), JccCards.level_of(key) + 1)
	col[key] = int(col[key]) - FUSE_COST
	if int(col[key]) <= 0:
		col.erase(key)
	col[out_key] = int(col.get(out_key, 0)) + 1
	var swapped: bool = false
	for nm: Variant in (j["decks"] as Dictionary).keys():
		var d: Array = (j["decks"] as Dictionary)[nm]
		var seen: int = 0
		var i: int = 0
		while i < d.size():
			if String(d[i]) == key:
				seen += 1
				if seen > int(col.get(key, 0)):
					if not swapped and _count(d, out_key) < mini(max_copies(out_key), int(col.get(out_key, 0))):
						d[i] = out_key
						swapped = true
					else:
						d.remove_at(i)
						continue
			i += 1
	j["deck"] = deck_of(save, active_deck_name(save)).duplicate()
	return out_key


static func _count(d: Array, key: String) -> int:
	var n: int = 0
	for x: Variant in d:
		if String(x) == key:
			n += 1
	return n


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


## --- Multi-decks (jusqu'à DECK_SLOTS decks nommés) ---

static func decks(save: Dictionary) -> Dictionary:
	return ensure(save)["decks"]


static func active_deck_name(save: Dictionary) -> String:
	var j: Dictionary = ensure(save)
	var n: String = String(j.get("active_deck", ""))
	if n == "" or not (j["decks"] as Dictionary).has(n):
		var keys: Array = (j["decks"] as Dictionary).keys()
		n = String(keys[0]) if not keys.is_empty() else "Deck 1"
	return n


static func set_active_deck(save: Dictionary, name: String) -> void:
	var j: Dictionary = ensure(save)
	if (j["decks"] as Dictionary).has(name):
		j["active_deck"] = name
		j["deck"] = deck_of(save, name).duplicate()


## Deck nommé ; retombe sur le deck actif puis le deck de départ si le nom est inconnu ou vide.
static func deck_of(save: Dictionary, name: String) -> Array:
	var j: Dictionary = ensure(save)
	var d: Array = (j["decks"] as Dictionary).get(name, [])
	if d.is_empty():
		d = j.get("deck", [])
	if d.is_empty():
		d = starter_deck()
	return d


## Boss de chapitre : un par chapitre de la campagne de Conquête (`ConquestSystem.CHAPTERS`, même ordre).
## Débloqué quand le chapitre `chapter` est accompli ; indices d'adversaire = OPPONENTS.size() + chapter.
## 1re victoire : la carte du boss + de l'or ; ensuite il redevient un boss ordinaire (40 % de sa carte).
const CHAPTER_BOSSES: Array = [
	{"name": "Loup Alpha", "chapter": 0, "biome": "Forêt", "accent": "#6fcf5a", "sprite": "enemies/loup_boss", "boss": "b_loup_alpha",
		"deck": "b_loup_alpha m_loup m_loup m_loup m_loup s_loup s_loup e_archer e_archer c_chasseur c_sylvain s_volee s_volee s_tir_precis s_charge m_gobelin m_gobelin m_gobelin s_fleche_poison s_javelot"},
	{"name": "Tharok le Végétal", "chapter": 1, "biome": "Forêt", "accent": "#4fbf6a", "sprite": "summons/ent_de_combat", "boss": "b_tharok",
		"deck": "b_tharok e_ent e_ent c_druide c_druide c_sylvain s_regeneration s_benediction s_benediction s_soin s_mur_pierre m_troll m_troll s_archer s_archer s_protection s_attaque_sacree m_loup m_loup s_javelot"},
	{"name": "Colosse d'Engrenages", "chapter": 2, "biome": "Plaine", "accent": "#c8c8d8", "sprite": "summons/golem_de_pierre", "boss": "b_colosse",
		"deck": "b_colosse c_chevalier c_chevalier c_tank c_tank e_golem e_golem m_belier m_belier s_cri_guerre s_charge s_charge s_frappe s_frappe s_javelot s_protection m_troll m_vampire m_vampire c_mage"},
	{"name": "Roi Squelette", "chapter": 3, "biome": "Marais", "accent": "#b8a6e8", "sprite": "enemies/squelette_boss", "boss": "b_roi_squelette",
		"deck": "b_roi_squelette m_squelette m_squelette m_squelette m_squelette c_assassin c_assassin m_vampire m_vampire s_fleche_poison s_fleche_poison s_trait_glace s_eclair s_javelot c_invocateur s_golem m_troll m_vampire s_boule_feu m_troll"},
	{"name": "Crabe Titan", "chapter": 4, "biome": "Marais", "accent": "#40b8c8", "sprite": "summons/requin_des_marees", "boss": "b_crabe_titan",
		"deck": "b_crabe_titan c_geomancien c_geomancien e_golem m_belier s_mur_pierre s_mur_pierre s_charge s_etincelle m_gobelin m_loup c_heal m_gobelin m_loup s_etincelle m_troll m_troll s_javelot s_frappe s_blizzard"},
	{"name": "Seigneur des Tempêtes", "chapter": 5, "biome": "Montagne", "accent": "#6fa8ff", "sprite": "summons/elementaire_de_cristal", "boss": "b_seigneur_tempetes",
		"deck": "b_seigneur_tempetes c_mage c_mage e_cristal e_cristal s_eclair s_eclair s_boule_feu s_boule_feu s_explosion s_blizzard s_trait_glace s_etincelle s_etincelle c_artificier c_artificier s_inspiration c_chasseur s_volee m_dragonnet"},
	{"name": "Seigneur de Lave", "chapter": 6, "biome": "Désert", "accent": "#ff5a20", "sprite": "enemies/dragonnet_desert", "boss": "b_seigneur_lave",
		"deck": "b_seigneur_lave m_dragonnet m_dragonnet m_dragonnet m_dragonnet c_mage c_mage s_boule_feu s_boule_feu s_explosion s_explosion s_eclair s_etincelle s_etincelle c_artificier c_artificier e_cristal s_attaque_sacree s_cri_guerre m_troll"},
	{"name": "Liche Éternelle", "chapter": 7, "biome": "Marais", "accent": "#a050d0", "sprite": "summons/ombre", "boss": "b_liche_eternelle",
		"deck": "b_liche_eternelle e_golem e_golem m_vampire m_vampire m_vampire c_chevalier c_tank m_troll m_troll m_troll c_assassin c_assassin s_boule_feu s_boule_feu s_explosion s_frappe s_javelot c_mage s_cri_guerre"},
]


## --- Puzzle de la semaine : plateau prédéfini, l'adversaire ne joue pas, il faut abattre son héros en `turns` tours ---
## `solution` (utilisée par les tests) : liste d'étapes {k: play|move|attack|end, ...}.
const PUZZLES: Array = [
	{"id": "compte_exact", "title": "Le compte exact", "text": "Abattez le héros adverse (9 PV) ce tour-ci. Une carte est inutile.",
		"mana": 5, "turns": 1, "my_hp": 20, "foe_hp": 9, "hand": ["s_boule_feu", "s_etincelle", "m_gobelin"], "mine": [], "foe": [["m_troll", 1, 0]],
		"solution": [{"k": "play", "hand": 0, "hero": true}, {"k": "play", "hand": 0, "hero": true}]},
	{"id": "passe_muraille", "title": "Passe-muraille", "text": "Atteignez le héros adverse (5 PV) en 2 tours : avancez, renforcez, frappez.",
		"mana": 4, "turns": 2, "my_hp": 20, "foe_hp": 5, "hand": ["s_charge"], "mine": [["m_loup", 0, 2]], "foe": [["m_troll", 0, 0], ["m_gobelin", 3, 3]],
		"solution": [{"k": "move", "from": [0, 2], "to": [1, 1]}, {"k": "play", "hand": 0, "ally": [1, 1]}, {"k": "end"}, {"k": "move", "from": [1, 1], "to": [1, 0]}, {"k": "attack", "from": [1, 0], "hero": true}]},
	{"id": "budget_mana", "title": "Budget de mana", "text": "7 mana, 12 PV à retirer au héros adverse : choisissez bien vos sorts.",
		"mana": 7, "turns": 1, "my_hp": 20, "foe_hp": 12, "hand": ["s_etincelle", "s_boule_feu", "s_eclair", "s_frappe"], "mine": [], "foe": [["m_loup", 2, 1]],
		"solution": [{"k": "play", "hand": 1, "hero": true}, {"k": "play", "hand": 2, "hero": true}]},
]


## Puzzle de la semaine (même puzzle toute la semaine) + état dans la sauvegarde.
static func weekly_puzzle(save: Dictionary) -> Dictionary:
	var j: Dictionary = ensure(save)
	var week: int = int(Time.get_unix_time_from_system() / 86400.0 / 7.0)
	var def: Dictionary = (PUZZLES[week % PUZZLES.size()] as Dictionary).duplicate(true)
	var st: Variant = j.get("puzzle", {})
	def["week"] = week
	def["done"] = typeof(st) == TYPE_DICTIONARY and int((st as Dictionary).get("week", -1)) == week and bool((st as Dictionary).get("done", false))
	return def


## Puzzle réussi : une carte de butin la première fois de la semaine. Retourne l'id de la carte ou "".
static func puzzle_won(save: Dictionary) -> String:
	var j: Dictionary = ensure(save)
	var def: Dictionary = weekly_puzzle(save)
	if bool(def["done"]):
		return ""
	j["puzzle"] = {"week": int(def["week"]), "done": true}
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var rew: String = roll_loot(rng, "")
	add_card(save, rew)
	return rew


## --- Défi du jour ---

static func daily_challenge(save: Dictionary) -> Dictionary:
	var j: Dictionary = ensure(save)
	var today: String = Time.get_date_string_from_system()
	var ch: Variant = j.get("challenge", {})
	if typeof(ch) != TYPE_DICTIONARY or String((ch as Dictionary).get("date", "")) != today or String((ch as Dictionary).get("id", "")) == "":
		var base: Dictionary = CHALLENGES[absi(today.hash()) % CHALLENGES.size()]
		ch = {"date": today, "id": base["id"], "text": base["text"], "target": int(base["target"]), "progress": 0, "done": false}
		j["challenge"] = ch
	return ch


## Rapporte le résultat d'un duel au défi du jour. Complété -> une carte de butin offerte.
## Retourne {id, text, target, progress, done, reward}.
static func challenge_report(save: Dictionary, stats: Dictionary, won: bool) -> Dictionary:
	var j: Dictionary = ensure(save)
	var ch: Dictionary = daily_challenge(save)
	var res: Dictionary = {"id": String(ch["id"]), "text": String(ch.get("text", "")), "target": int(ch.get("target", 0)),
		"progress": int(ch["progress"]), "done": bool(ch["done"]), "reward": ""}
	if res["done"]:
		return res
	var stat: String = ""
	for c: Variant in CHALLENGES:
		if String(c["id"]) == String(ch["id"]):
			stat = String(c["stat"])
	if stat == "":
		return res
	var gain: int = int(stats.get(stat, 0)) if stat != "wins" else (1 if won else 0)
	var prog: int = mini(int(ch["progress"]) + gain, int(res["target"]))
	ch["progress"] = prog
	res["progress"] = prog
	if prog >= int(res["target"]):
		ch["done"] = true
		res["done"] = true
		var rng := RandomNumberGenerator.new()
		rng.randomize()
		var rew: String = roll_loot(rng, "")
		add_card(save, rew)
		res["reward"] = rew
	j["challenge"] = ch
	return res


## --- Adversaires verrouillés : battre l'adversaire i débloque le i+1 ---

static func is_unlocked(save: Dictionary, idx: int) -> bool:
	if idx >= OPPONENTS.size():
		return chapter_done(save, int(opponent(idx).get("chapter", 99)))
	if idx <= 0:
		return true
	return (ensure(save)["unlocked"] as Array).has(idx)


## Renvoie l'index du nouvel adversaire débloqué, ou -1 s'il n'y en a pas.
static func unlock_next(save: Dictionary, beaten_idx: int) -> int:
	var j: Dictionary = ensure(save)
	var nxt: int = beaten_idx + 1
	if nxt < OPPONENTS.size() and not (j["unlocked"] as Array).has(nxt):
		(j["unlocked"] as Array).append(nxt)
		return nxt
	return -1


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
	if index >= OPPONENTS.size():
		return CHAPTER_BOSSES[clampi(index - OPPONENTS.size(), 0, CHAPTER_BOSSES.size() - 1)]
	return OPPONENTS[clampi(index, 0, OPPONENTS.size() - 1)]


static func total_opponents() -> int:
	return OPPONENTS.size() + CHAPTER_BOSSES.size()


## Chapitre de campagne accompli (ConquestSystem.chapter_index > chapitre du boss) ?
static func chapter_done(save: Dictionary, chapter: int) -> bool:
	return ConquestSystem.chapter_index(save.get("conquest", {})) > chapter


## Récompense de la 1re victoire sur un boss de chapitre : {card, gold}, ou {} si déjà obtenue / pas un boss de chapitre.
static func chapter_boss_won(save: Dictionary, idx: int) -> Dictionary:
	var op: Dictionary = opponent(idx)
	if idx < OPPONENTS.size() or not op.has("chapter"):
		return {}
	var j: Dictionary = ensure(save)
	var done: Array = j.get("chapter_bosses", [])
	if done.has(int(op["chapter"])):
		return {}
	done.append(int(op["chapter"]))
	j["chapter_bosses"] = done
	var gold: int = 100 * (int(op["chapter"]) + 1)
	save["gold"] = int(save.get("gold", 0)) + gold
	add_card(save, String(op["boss"]))
	return {"card": String(op["boss"]), "gold": gold}
