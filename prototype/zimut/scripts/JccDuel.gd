class_name JccDuel
extends RefCounted
## JccDuel.gd — Règles du mode Cartes (JCC à voies, inspiré de Krosmaga / Magic). Aucune UI : testable en headless.
##
## Plateau : 4 voies. Chaque camp a UN emplacement par voie. Une créature attaque la créature adverse de SA voie ;
## si cette voie est vide, elle frappe directement le héros. Attaque manuelle, une fois par tour, pas le tour où
## la créature est posée (mal d'invocation). Chaque créature porte UN sort distinctif (payé en mana, une fois par tour).
## Mana : 1 au premier tour, +1 par tour, max 10. Une pioche par tour. Pioche vide = fatigue croissante.
## Une carte jouée (sort) ou perdue (créature morte) rejoint la fosse ; les jetons disparaissent.

const COLS: int = 4
const ROWS: int = 6
## Plateau 4 x 6. « lane » (hérité) = index de case = y * COLS + x.
## Camp 1 en haut (ligne arrière y = 0), camp 0 en bas (ligne arrière y = ROWS - 1).
const LANES: int = COLS * ROWS
const HERO_HP: int = 20
const HAND_MAX: int = 7
const MANA_MAX: int = 10
const START_HAND: int = 4
const TERRAIN_TYPES: Array = ["boue", "hauteur", "buisson"]
const TERRAIN_COUNT: int = 6
## Obstacles infranchissables (rochers) : 2 cases, toujours dans les lignes centrales (jamais en zone de déploiement).
const ROCK: String = "rocher"
const ROCK_COUNT: int = 2
const HERO_POWER_DEFAULT := {"name": "Frappe du héros", "effet": "degats_heros", "valeur": "3", "duree": 0, "cible": ""}
const HERO_POWERS := {
	"mage": {"name": "Éclair céleste", "effet": "degats_heros", "valeur": "4", "duree": 0, "cible": ""},
	"tank": {"name": "Mur de pierre", "effet": "bouclier_zone", "valeur": "4", "duree": 0, "cible": ""},
	"chasseur": {"name": "Tir précis", "effet": "degats", "valeur": "3", "duree": 0, "cible": "ennemi"},
	"druide": {"name": "Épines sauvages", "effet": "degats_zone", "valeur": "3", "duree": 0, "cible": ""},
	"heal": {"name": "Vague de soin", "effet": "soin_zone", "valeur": "5", "duree": 0, "cible": ""},
	"assassin": {"name": "Frappe sournoise", "effet": "degats", "valeur": "4", "duree": 0, "cible": "ennemi"},
	"invocateur": {"name": "Appel des morts", "effet": "invoquer", "valeur": "j_squelette", "duree": 0, "cible": "voie"},
	"sylvain": {"name": "Ouragan", "effet": "degats_zone", "valeur": "3", "duree": 0, "cible": ""},
	"geomancien": {"name": "Séisme", "effet": "degats_zone", "valeur": "3", "duree": 0, "cible": ""},
	"artificier": {"name": "Bombe", "effet": "degats", "valeur": "3", "duree": 0, "cible": "ennemi"},
	"boss_hero": {"name": "Frappe du boss", "effet": "degats_heros", "valeur": "4", "duree": 0, "cible": ""},
	"boss": {"name": "Frappe du boss", "effet": "degats_heros", "valeur": "5", "duree": 0, "cible": ""},
}

## Bonus de héros (cartes possédées jouables comme héros). Rareté Commun/Rare : bonus de début de duel
## {"start": {"hp"|"draw"|"mana": n}} ; Épique/Légendaire : bonus par tour {"turn": {"kind": "heal"|"dmg"|"mana"|"draw", "n": n, "every": k}}
## (appliqué au début de chacun de ses tours, un tour sur `every`).
const HERO_BONUS := {
	"c_tank": {"name": "Rempart", "start": {"hp": 4}},
	"c_chevalier": {"name": "Armure d'acier", "start": {"hp": 4}},
	"c_mage": {"name": "Étude arcanique", "start": {"draw": 1}},
	"c_chasseur": {"name": "Œil de lynx", "start": {"hp": 3}},
	"c_druide": {"name": "Sève vivace", "start": {"hp": 4}},
	"c_heal": {"name": "Bénédiction", "start": {"hp": 4}},
	"c_assassin": {"name": "Initiative", "start": {"hp": 1}},
	"c_invocateur": {"name": "Grimoire", "start": {"hp": 2}},
	"c_sylvain": {"name": "Cartes du vent", "start": {"hp": 3, "draw": 1}},
	"c_geomancien": {"name": "Peau de roche", "start": {"hp": 4}},
	"c_artificier": {"name": "Étincelle", "start": {"hp": 2}},
	"c_samourai": {"name": "Lame du samouraï", "turn": {"kind": "dmg", "n": 1, "every": 4}},
	"b_gobelin_roi": {"name": "Tribut du roi", "turn": {"kind": "mana", "n": 1, "every": 2}},
	"b_loup_alpha": {"name": "Morsure d'alpha", "turn": {"kind": "dmg", "n": 1, "every": 3}},
	"b_roi_squelette": {"name": "Malédiction", "turn": {"kind": "dmg", "n": 1, "every": 3}},
	"b_troll_geant": {"name": "Régénération", "turn": {"kind": "heal", "n": 2, "every": 2}},
	"b_dragon": {"name": "Souffle ardent", "turn": {"kind": "dmg", "n": 1, "every": 3}},
	"b_seigneur_lave": {"name": "Brasier", "turn": {"kind": "dmg", "n": 1, "every": 3}},
	"b_liche_brumes": {"name": "Voile des brumes", "turn": {"kind": "heal", "n": 1, "every": 1}},
	"b_liche_eternelle": {"name": "Pacte éternel", "turn": {"kind": "mana", "n": 1, "every": 3}},
	"b_crabe_titan": {"name": "Carapace", "turn": {"kind": "heal", "n": 2, "every": 2}},
	"b_colosse": {"name": "Moteur à vapeur", "turn": {"kind": "mana", "n": 1, "every": 2}},
	"b_golem_prisme": {"name": "Éclat prismatique", "turn": {"kind": "heal", "n": 2, "every": 2}},
	"b_seigneur_tempetes": {"name": "Foudre captive", "turn": {"kind": "mana", "n": 1, "every": 2}},
	"b_tharok": {"name": "Racines vives", "turn": {"kind": "heal", "n": 2, "every": 2}},
	"b_vorkann": {"name": "Givre mordant", "turn": {"kind": "dmg", "n": 1, "every": 3}},
}

var hero_ids: Array = ["", ""]   # carte-héros choisie par camp (bonus)

var sides: Array = []
var current: int = 0
var turn: int = 0              # numéro de tour global (1, 2, 3…)
var winner: int = -1           # -1 en cours, 0 joueur, 1 adversaire, 2 égalité
var puzzle: Dictionary = {}   # non vide : mode puzzle (voir setup_puzzle)
var events: Array = []         # événements pour l'interface : {k, side, lane, n, ...}
var log: Array = []
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _uid: int = 0
var _turns_started: Array = [0, 0]
var terrain: Array = []        # 24 cases : "", "boue", "hauteur", "buisson"


func setup(deck0: Array, deck1: Array, seed_value: int = 0, powers: Array = [], heroes: Array = []) -> void:
	hero_ids = ["", ""]
	for hi: int in mini(2, heroes.size()):
		hero_ids[hi] = String(heroes[hi])
	_rng.seed = seed_value if seed_value != 0 else int(Time.get_ticks_usec())
	sides = []
	for deck_ids: Array in [deck0, deck1]:
		var d: Array = []
		for id: Variant in deck_ids:
			var inst: Dictionary = _make_instance(String(id))
			if not inst.is_empty():
				d.append(inst)
		_shuffle(d)
		sides.append({"hero_hp": HERO_HP, "mana": 0, "mana_max": 0, "deck": d, "hand": [], "fosse": [],
			"units": [], "fatigue": 0, "power": {}, "power_used": false, "mulligan": true,
			"stats": {"creatures": 0, "spells": 0, "hero_dmg": 0}})
	for s: int in 2:
		sides[s]["power"] = power_for(String(powers[s]) if s < powers.size() else "")
		for i: int in START_HAND + (1 if s == 1 else 0):
			if not (sides[s]["deck"] as Array).is_empty():
				_draw_card(s, false)
	winner = -1
	turn = 0
	events = []
	log = []
	_turns_started = [0, 0]
	for hs: int in 2:
		_apply_hero_start(hs)
	terrain = _gen_terrain()
	var tnames: Array = []
	for i in LANES:
		if terrain_at(i) != "":
			tnames.append("%s en (%d,%d)" % [terrain_at(i), i % COLS, i / COLS])
	if not tnames.is_empty():
		log.append("Terrain : " + ", ".join(PackedStringArray(tnames)))
	start_turn(0)


## Bonus de début de duel du héros (Commun/Rare).
func _apply_hero_start(s: int) -> void:
	var b: Dictionary = hero_bonus(String(hero_ids[s]))
	if not b.has("start"):
		return
	var st: Dictionary = b["start"]
	if st.has("hp"):
		sides[s]["hero_hp"] = int(sides[s]["hero_hp"]) + int(st["hp"])
	if st.has("mana"):
		sides[s]["mana_max"] = int(sides[s]["mana_max"]) + int(st["mana"])
	for i: int in int(st.get("draw", 0)):
		_draw_card(s, false)
	log.append("Héros %s : %s" % [("allié" if s == 0 else "adverse"), hero_bonus_text(String(hero_ids[s]))])


static func hero_bonus(card_id: String) -> Dictionary:
	return HERO_BONUS.get(card_id, {})


## Texte court du bonus (« +4 PV au héros », « 1 dégât au héros adverse (1 tour sur 2) »…).
static func hero_bonus_text(card_id: String) -> String:
	var b: Dictionary = hero_bonus(card_id)
	if b.is_empty():
		return "Aucun bonus"
	var parts: Array = []
	if b.has("start"):
		var st: Dictionary = b["start"]
		if st.has("hp"):
			parts.append("+%d PV au héros" % int(st["hp"]))
		if st.has("mana"):
			parts.append("+%d mana dès le 1er tour" % int(st["mana"]))
		if st.has("draw"):
			parts.append("+%d carte en main au départ" % int(st["draw"]))
		return "Début de duel : " + ", ".join(PackedStringArray(parts))
	var t: Dictionary = b["turn"]
	var what: String = ""
	match String(t["kind"]):
		"heal":
			what = "soigne le héros de %d" % int(t["n"])
		"dmg":
			what = "%d dégât au héros adverse" % int(t["n"])
		"mana":
			what = "+%d mana" % int(t["n"])
		"draw":
			what = "pioche %d carte" % int(t["n"])
	var ev: int = int(t.get("every", 1))
	return "Chaque tour : " + what if ev <= 1 else "Un tour sur %d : %s" % [ev, what]


## Bonus par tour du héros (Épique/Légendaire), appliqué au début du tour de `s`.
func _apply_hero_turn(s: int) -> void:
	var b: Dictionary = hero_bonus(String(hero_ids[s]))
	if not b.has("turn"):
		return
	var t: Dictionary = b["turn"]
	if int(_turns_started[s]) % maxi(1, int(t.get("every", 1))) != 0:
		return
	var n: int = int(t["n"])
	match String(t["kind"]):
		"heal":
			_heal(s, -1, n)
		"dmg":
			_hit(other(s), -1, n, "hero_bonus")
		"mana":
			sides[s]["mana"] = int(sides[s]["mana"]) + n
			_ev("mana", s, -1, n)
		"draw":
			_draw_card(s, true)


## Pouvoir de héros associé à une classe (ou "boss") ; défaut si inconnu.
static func power_for(key: String) -> Dictionary:
	var k: String = key.to_lower().replace("é", "e").replace("è", "e").replace(" ", "")
	if HERO_POWERS.has(k):
		return (HERO_POWERS[k] as Dictionary).duplicate()
	return HERO_POWER_DEFAULT.duplicate()


## Terrain du duel : 6 cases (2 boue, 2 hauteur, 2 buisson), tirage seedé.
func _gen_terrain() -> Array:
	var t: Array = []
	for i in LANES:
		t.append("")
	var mid: Array = []
	for i in LANES:
		var cy: int = cell_xy(i).y
		if not deploy_rows(0).has(cy) and not deploy_rows(1).has(cy):
			mid.append(i)
	_shuffle(mid)
	for i in mini(ROCK_COUNT, mid.size()):
		t[int(mid[i])] = ROCK
	var cells: Array = []
	for i in LANES:
		if String(t[i]) == "":
			cells.append(i)
	_shuffle(cells)
	var kinds: Array = TERRAIN_TYPES.duplicate()
	kinds.append_array(TERRAIN_TYPES)
	for i in mini(TERRAIN_COUNT, cells.size()):
		t[int(cells[i])] = String(kinds[i % kinds.size()])
	return t


func terrain_at(cell: int) -> String:
	if cell < 0 or cell >= terrain.size():
		return ""
	return String(terrain[cell])


func _shuffle(a: Array) -> void:
	for i: int in range(a.size() - 1, 0, -1):
		var j: int = _rng.randi_range(0, i)
		var tmp: Variant = a[i]
		a[i] = a[j]
		a[j] = tmp


func _make_instance(id: String) -> Dictionary:
	var row: Dictionary = JccCards.get_card(id)
	if row.is_empty():
		return {}
	var c: Dictionary = row.duplicate()
	_uid += 1
	c["uid"] = _uid
	c["max_hp"] = int(row["hp"])
	c["max_pa"] = int(row.get("pa", 1))
	c["pa"] = c["max_pa"]
	c["max_pm"] = int(row.get("pm", 2))
	c["pm"] = c["max_pm"]
	c["po"] = int(row.get("po", 1))
	c["x"] = -1
	c["y"] = -1
	c["sick"] = false
	c["attacked"] = false
	c["used"] = false
	c["stun"] = 0
	c["poison"] = []
	c["keywords"] = (row.get("keywords", []) as Array).duplicate()
	return c


func side(s: int) -> Dictionary:
	return sides[s]


func other(s: int) -> int:
	return 1 - s


# ── Grille 4 x 6 ──

func cell_xy(cell: int) -> Vector2i:
	return Vector2i(cell % COLS, cell / COLS)


func xy_cell(x: int, y: int) -> int:
	return y * COLS + x


func manhattan_cell(a: int, b: int) -> int:
	var pa := cell_xy(a)
	var pb := cell_xy(b)
	return absi(pa.x - pb.x) + absi(pa.y - pb.y)


## Ligne arrière d'un camp (dépôt des créatures) : y = ROWS-1 pour le joueur, 0 pour l'IA.
func back_row_y(s: int) -> int:
	return ROWS - 1 if s == 0 else 0


## Zone de déploiement : les 2 lignes les plus proches de son héros.
func deploy_rows(s: int) -> Array:
	var by: int = back_row_y(s)
	return [by, by - 1] if s == 0 else [by, by + 1]


## Distance d'une case à la ligne du héros adverse (le héros est hors plateau, derrière sa ligne arrière).
func hero_dist_to(s: int, cell: int) -> int:
	var p := cell_xy(cell)
	var foe: int = other(s)
	return (ROWS - p.y) if foe == 0 else (p.y + 1)


func unit_at(gx: int, gy: int) -> Variant:
	for s in 2:
		for u: Variant in sides[s]["units"]:
			var c: Dictionary = u
			if int(c["x"]) == gx and int(c["y"]) == gy:
				return c
	return null


func is_free_xy(gx: int, gy: int) -> bool:
	return gx >= 0 and gx < COLS and gy >= 0 and gy < ROWS and unit_at(gx, gy) == null and terrain_at(xy_cell(gx, gy)) != ROCK


## Occupant d'une case : {"side": s, "unit": c} ou {}.
func occupant(cell: int) -> Dictionary:
	var p := cell_xy(cell)
	for s in 2:
		for u: Variant in sides[s]["units"]:
			var c: Dictionary = u
			if int(c["x"]) == p.x and int(c["y"]) == p.y:
				return {"side": s, "unit": c}
	return {}


func creature_at(s: int, lane: int) -> Variant:
	if lane < 0 or lane >= LANES:
		return null
	var p := cell_xy(lane)
	for u: Variant in sides[s]["units"]:
		var c: Dictionary = u
		if int(c["x"]) == p.x and int(c["y"]) == p.y:
			return c
	return null


func creatures(s: int) -> Array:
	return sides[s]["units"]


func lane_of(s: int, c: Dictionary) -> int:
	return xy_cell(int(c["x"]), int(c["y"]))


## Vrai si la carte/unité porte le mot-clé (colonne MotsCles : "vol;provocation;...").
func has_kw(cr: Dictionary, kw: String) -> bool:
	return (cr.get("keywords", []) as Array).has(kw)


## Pose une unité directement sur la grille (tests / debug).
## Puzzle : plateau et main prédéfinis, l'adversaire ne joue pas ; il faut abattre son héros en `turns` tours.
## def : {mana, turns, my_hp, foe_hp, hand: [ids], mine: [[id, x, y]], foe: [[id, x, y]]}
func setup_puzzle(def: Dictionary) -> void:
	setup([], [], 7)
	puzzle = def
	for s: int in 2:
		sides[s]["mulligan"] = false
		sides[s]["power_used"] = true
	sides[0]["hero_hp"] = int(def.get("my_hp", HERO_HP))
	sides[1]["hero_hp"] = int(def.get("foe_hp", 10))
	for id: Variant in def.get("hand", []):
		(sides[0]["hand"] as Array).append(_make_instance(String(id)))
	for u: Variant in def.get("mine", []):
		var a: Array = u
		place_unit(0, String(a[0]), int(a[1]), int(a[2]))
	for u: Variant in def.get("foe", []):
		var b: Array = u
		place_unit(1, String(b[0]), int(b[1]), int(b[2]))
	_turns_started = [0, 0]
	turn = 0
	start_turn(0)


func place_unit(s: int, id: String, x: int, y: int) -> Dictionary:
	var c: Dictionary = _make_instance(id)
	c["x"] = x
	c["y"] = y
	(sides[s]["units"] as Array).append(c)
	return c


func is_over() -> bool:
	return winner != -1


func _ev(k: String, s: int, lane: int, n: int = 0, extra: Dictionary = {}) -> void:
	var e: Dictionary = {"k": k, "side": s, "lane": lane, "n": n}
	e.merge(extra)
	events.append(e)


func take_events() -> Array:
	var e: Array = events
	events = []
	return e


# ─── Début / fin de tour ─────────────────────────────────────────────────────

func start_turn(s: int) -> void:
	current = s
	turn += 1
	_turns_started[s] += 1
	var sd: Dictionary = sides[s]
	sd["mana_max"] = int(puzzle.get("mana", 1)) if not puzzle.is_empty() else mini(MANA_MAX, int(sd["mana_max"]) + 1)
	sd["mana"] = sd["mana_max"]
	if int(_turns_started[s]) > 1 or s == 1:
		_draw_card(s, true)
	_apply_hero_turn(s)
	if is_over():
		return
	for c: Variant in creatures(s):
		var cr: Dictionary = c
		cr["sick"] = false
		cr["attacked"] = false
		cr["used"] = false
		cr["frozen"] = false
		cr["pa"] = int(cr.get("max_pa", 1))
		cr["pm"] = int(cr.get("max_pm", 2))
		if int(cr["stun"]) > 0:
			cr["attacked"] = true
			cr["used"] = true
			cr["pa"] = 0
			cr["pm"] = 0
			cr["frozen"] = true
			cr["stun"] = int(cr["stun"]) - 1
		if has_kw(cr, "regeneration") and int(cr["hp"]) < int(cr["max_hp"]):
			_heal(s, lane_of(s, cr), 2)
	# poison
	for c: Variant in creatures(s):
		var cr2: Dictionary = c
		var plane: int = lane_of(s, cr2)
		var left: Array = []
		for p: Variant in cr2["poison"]:
			var pd: Dictionary = p
			_hit(s, plane, int(pd["n"]), "poison")
			if is_over():
				return
			if lane_of(s, cr2) < 0:
				break
			pd["t"] = int(pd["t"]) - 1
			if int(pd["t"]) > 0:
				left.append(pd)
		cr2["poison"] = left


func end_turn(s: int) -> bool:
	if is_over() or s != current:
		return false
	if not puzzle.is_empty() and s == 0 and int(_turns_started[0]) >= int(puzzle.get("turns", 1)):
		winner = 1   # puzzle : plus de tours, c'est perdu
		return true
	start_turn(other(s))
	return true


func _draw_card(s: int, with_event: bool) -> void:
	var sd: Dictionary = sides[s]
	var deck: Array = sd["deck"]
	if deck.is_empty() and not puzzle.is_empty():
		return   # puzzle : pas de pioche ni de fatigue
	if deck.is_empty():
		sd["fatigue"] = int(sd["fatigue"]) + 1
		_hit(s, -1, int(sd["fatigue"]), "fatigue")
		return
	var card: Dictionary = deck.pop_front()
	if (sd["hand"] as Array).size() >= HAND_MAX:
		(sd["fosse"] as Array).append(card)
		_ev("burn", s, -1, 0, {"name": card["name"]})
		return
	(sd["hand"] as Array).append(card)
	if with_event:
		_ev("draw", s, -1, 1, {"name": card["name"]})


func draw(s: int, n: int) -> void:
	for i: int in n:
		_draw_card(s, true)


# ─── Cibles ──────────────────────────────────────────────────────────────────

## Cibles valides pour un effet : liste de {side, lane} (lane -1 = héros). [{}] si aucune cible n'est à choisir.
func targets_for(s: int, cible: String) -> Array:
	var out: Array = []
	var foe: int = other(s)
	match cible:
		"ennemi", "ennemi_ou_heros":
			for c: Variant in creatures(foe):
				out.append({"side": foe, "lane": lane_of(foe, c as Dictionary)})
			if cible == "ennemi_ou_heros":
				out.append({"side": foe, "lane": -1})
		"allie", "allie_ou_heros":
			for c: Variant in creatures(s):
				out.append({"side": s, "lane": lane_of(s, c as Dictionary)})
			if cible == "allie_ou_heros":
				out.append({"side": s, "lane": -1})
		"voie":
			# dépôt : cases libres des 2 lignes proches du héros
			for by: Variant in deploy_rows(s):
				for x in COLS:
					if unit_at(x, int(by)) == null and terrain_at(xy_cell(x, int(by))) != ROCK:
						out.append({"side": s, "lane": xy_cell(x, int(by))})
		_:
			out.append({})
	return out


func needs_target(cible: String) -> bool:
	return cible in ["ennemi", "ennemi_ou_heros", "allie", "allie_ou_heros", "voie"]


func _target_ok(s: int, cible: String, target: Dictionary) -> bool:
	for t: Variant in targets_for(s, cible):
		var td: Dictionary = t
		if td.is_empty():
			return true
		if target.has("side") and target.has("lane") and int(td["side"]) == int(target["side"]) and int(td["lane"]) == int(target["lane"]):
			return true
	return false


# ─── Actions ─────────────────────────────────────────────────────────────────

func can_play(s: int, hand_idx: int) -> bool:
	if is_over() or s != current:
		return false
	var hand: Array = sides[s]["hand"]
	if hand_idx < 0 or hand_idx >= hand.size():
		return false
	var c: Dictionary = hand[hand_idx]
	if int(c["cost"]) > int(sides[s]["mana"]):
		return false
	if String(c["type"]) == "Creature":
		return not targets_for(s, "voie").is_empty()
	return not targets_for(s, String(c["cible"])).is_empty()


func play_card(s: int, hand_idx: int, target: Dictionary = {}) -> bool:
	if not can_play(s, hand_idx):
		return false
	var sd: Dictionary = sides[s]
	var c: Dictionary = (sd["hand"] as Array)[hand_idx]
	if String(c["type"]) == "Creature":
		if not _target_ok(s, "voie", target):
			return false
		sd["stats"]["creatures"] = int(sd["stats"]["creatures"]) + 1
		(sd["hand"] as Array).remove_at(hand_idx)
		sd["mana"] = int(sd["mana"]) - int(c["cost"])
		c["sick"] = true
		var tp := cell_xy(int(target["lane"]))
		c["x"] = tp.x
		c["y"] = tp.y
		(sd["units"] as Array).append(c)
		_ev("summon", s, int(target["lane"]), 0, {"name": c["name"]})
		log.append("%s pose %s" % [_nm(s), c["name"]])
		return true
	if not _target_ok(s, String(c["cible"]), target):
		return false
	sd["stats"]["spells"] = int(sd["stats"]["spells"]) + 1
	(sd["hand"] as Array).remove_at(hand_idx)
	sd["mana"] = int(sd["mana"]) - int(c["cost"])
	_ev("cast", s, -1, 0, {"name": c["name"]})
	log.append("%s joue %s" % [_nm(s), c["name"]])
	_apply(s, String(c["effet"]), String(c["valeur"]), int(c["duree"]), target)
	(sd["fosse"] as Array).append(c)
	return true


func can_use_sort(s: int, lane: int) -> bool:
	if is_over() or s != current:
		return false
	var c: Variant = creature_at(s, lane)
	if c == null:
		return false
	var cr: Dictionary = c
	if String(cr["sort"]) == "" or bool(cr["used"]) or bool(cr["sick"]):
		return false
	if int(cr.get("pa", 1)) < 1:
		return false
	if int(cr["sort_cost"]) > int(sides[s]["mana"]):
		return false
	return not targets_for(s, String(cr["cible"])).is_empty()


## Raison lisible pour laquelle le sort d'une unité n'est pas utilisable ("" si utilisable).
func sort_block_reason(s: int, lane: int) -> String:
	var c: Variant = creature_at(s, lane)
	if c == null or is_over() or s != current:
		return ""
	var cr: Dictionary = c
	if String(cr["sort"]) == "":
		return "Cette unité n'a pas de sort."
	if bool(cr.get("frozen", false)):
		return "Étourdie : ne peut rien faire ce tour."
	if bool(cr["sick"]):
		return "Vient d'être invoquée : sort utilisable au prochain tour."
	if bool(cr["used"]) or int(cr.get("pa", 1)) < 1:
		return "Plus de PA ce tour."
	if int(cr["sort_cost"]) > int(sides[s]["mana"]):
		return "Mana insuffisant (%d requis)." % int(cr["sort_cost"])
	if targets_for(s, String(cr["cible"])).is_empty():
		return "Aucune cible valide."
	return ""


func attack_block_reason(s: int, lane: int) -> String:
	var c: Variant = creature_at(s, lane)
	if c == null or is_over() or s != current:
		return ""
	var cr: Dictionary = c
	if int(cr["atk"]) <= 0:
		return "Cette unité n'attaque pas (ATK 0)."
	if bool(cr.get("frozen", false)):
		return "Étourdie : ne peut rien faire ce tour."
	if bool(cr["sick"]):
		return "Vient d'être invoquée : attaque au prochain tour."
	if bool(cr["attacked"]) or int(cr.get("pa", 1)) < 1:
		return "Plus de PA ce tour."
	if attack_targets(s, lane).is_empty():
		return "Aucune cible à portée (PO %d) : avancez avec les PM." % int(cr.get("po", 1))
	return ""


func play_block_reason(s: int, hand_idx: int) -> String:
	if is_over() or s != current:
		return ""
	var hand: Array = sides[s]["hand"]
	if hand_idx < 0 or hand_idx >= hand.size():
		return ""
	var c: Dictionary = hand[hand_idx]
	if int(c["cost"]) > int(sides[s]["mana"]):
		return "Mana insuffisant (%d requis)." % int(c["cost"])
	if String(c["type"]) == "Creature":
		if targets_for(s, "voie").is_empty():
			return "Zone de déploiement pleine."
	elif targets_for(s, String(c["cible"])).is_empty():
		return "Aucune cible valide."
	return ""


func use_sort(s: int, lane: int, target: Dictionary = {}) -> bool:
	if not can_use_sort(s, lane):
		return false
	var cr: Dictionary = creature_at(s, lane)
	if not _target_ok(s, String(cr["cible"]), target):
		return false
	sides[s]["mana"] = int(sides[s]["mana"]) - int(cr["sort_cost"])
	cr["used"] = true
	cr["pa"] = int(cr["pa"]) - 1
	_ev("cast", s, lane, 0, {"name": cr["sort"]})
	log.append("%s : %s utilise %s" % [_nm(s), cr["name"], cr["sort"]])
	_apply(s, String(cr["effet"]), String(cr["valeur"]), int(cr["duree"]), target)
	return true


## Cibles d'attaque d'une unité : créatures ennemies à portée PO (distance de Manhattan)
## + le héros adverse si sa ligne est à portée PO. lane -1 = héros.
func attack_targets(s: int, cell: int) -> Array:
	var out: Array = []
	var cr: Variant = creature_at(s, cell)
	if cr == null:
		return out
	var po: int = int((cr as Dictionary).get("po", 1))
	if terrain_at(cell) == "hauteur":
		po += 1   # la hauteur donne +1 PO
	var foe: int = other(s)
	for u: Variant in sides[foe]["units"]:
		var c: Dictionary = u
		var fl: int = xy_cell(int(c["x"]), int(c["y"]))
		var d: int = manhattan_cell(cell, fl)
		if d >= 1 and d <= po:
			if d > 1 and terrain_at(fl) == "buisson":
				continue   # camouflage : le buisson protège des tirs à distance
			out.append({"side": foe, "lane": fl})
	if hero_dist_to(s, cell) <= po:
		out.append({"side": foe, "lane": -1})
	# provocation : si une unité ennemie à portée a provocation, seules les provocation sont ciblables
	var provs: Array = []
	for e: Variant in out:
		var ed: Dictionary = e
		if int(ed["lane"]) >= 0:
			var uc: Variant = creature_at(foe, int(ed["lane"]))
			if uc != null and has_kw(uc as Dictionary, "provocation"):
				provs.append(ed)
	if not provs.is_empty():
		return provs
	return out


func can_attack(s: int, lane: int) -> bool:
	if is_over() or s != current:
		return false
	var c: Variant = creature_at(s, lane)
	if c == null:
		return false
	var cr: Dictionary = c
	return not bool(cr["sick"]) and not bool(cr["attacked"]) and int(cr["atk"]) > 0 and int(cr.get("pa", 1)) >= 1


## Attaque : 1 PA, portée PO. Sans cible explicite, attaque l'ennemi le plus faible à
## portée, sinon le héros adverse si à portée.
func attack(s: int, lane: int, target: Dictionary = {}) -> bool:
	if not can_attack(s, lane):
		return false
	var tg: Array = attack_targets(s, lane)
	if tg.is_empty():
		return false
	var t: Dictionary = target
	var valid := false
	for e: Variant in tg:
		var ed: Dictionary = e
		if int(ed["side"]) == int(t.get("side", -99)) and int(ed["lane"]) == int(t.get("lane", -99)):
			valid = true
			break
	if not valid:
		t = {"side": other(s), "lane": -1}
		var best_hp := 9999
		for e: Variant in tg:
			var ed: Dictionary = e
			if int(ed["lane"]) == -1:
				continue
			var uc: Variant = creature_at(other(s), int(ed["lane"]))
			if uc != null and int((uc as Dictionary)["hp"]) < best_hp:
				best_hp = int((uc as Dictionary)["hp"])
				t = ed
	var cr: Dictionary = creature_at(s, lane)
	cr["attacked"] = true
	cr["pa"] = int(cr["pa"]) - 1
	var foe: int = other(s)
	_ev("attack", s, lane, 0, {"hero": int(t["lane"]) == -1})
	if int(t["lane"]) == -1:
		var hhp: int = int(sides[foe]["hero_hp"])
		_hit(foe, -1, int(cr["atk"]), "attack")
		if has_kw(cr, "vol"):
			_heal(s, lane, mini(int(cr["atk"]), hhp))
		log.append("%s frappe le héros de %s (%d)" % [cr["name"], _nm(foe), int(cr["atk"])])
	else:
		var b: Dictionary = creature_at(foe, int(t["lane"]))
		var hp_b: int = int(b["hp"])
		_hit(foe, int(t["lane"]), int(cr["atk"]), "attack")
		var dealt: int = mini(int(cr["atk"]), hp_b)
		if has_kw(cr, "vol") and dealt > 0:
			_heal(s, lane, dealt)   # vol : l'attaquant se soigne des dégâts infligés
		if has_kw(cr, "perforation") and int(cr["atk"]) > hp_b:
			_hit(foe, -1, int(cr["atk"]) - hp_b, "attack")   # perforation : l'excédent touche le héros
		# riposte seulement si la cible survit ; initiative = jamais de riposte
		if not is_over() and creature_at(s, lane) != null and creature_at(foe, int(t["lane"])) != null and not has_kw(cr, "initiative"):
			_hit(s, lane, int(b["atk"]), "attack")
		log.append("%s attaque %s" % [cr["name"], b["name"]])
	return true


## Coût (en PM) du chemin le plus court entre deux cases libres, -1 si inaccessible.
func _path_cost(from: int, to: int) -> int:
	if from == to:
		return 0
	var dist: Dictionary = {from: 0}
	var queue: Array = [from]
	while not queue.is_empty():
		var cur: int = queue.pop_front()
		var cp := cell_xy(cur)
		for d: Vector2i in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
			var np := cp + d
			if np.x < 0 or np.x >= COLS or np.y < 0 or np.y >= ROWS:
				continue
			var ncell := xy_cell(np.x, np.y)
			if dist.has(ncell):
				continue
			if ncell != from and unit_at(np.x, np.y) != null:
				continue
			if terrain_at(ncell) == ROCK:   # rocher : infranchissable
				continue
			var step: int = 2 if terrain_at(ncell) == "boue" else 1   # la boue ralentit
			dist[ncell] = int(dist[cur]) + step
			queue.append(ncell)
	return int(dist.get(to, -1))


## Cases atteignables en dépensant au plus les PM restants de l'unité.
func move_targets(s: int, cell: int) -> Array:
	var out: Array = []
	var cr: Variant = creature_at(s, cell)
	if cr == null:
		return out
	var pm: int = int((cr as Dictionary).get("pm", 0))
	if pm <= 0:
		return out
	var p := cell_xy(cell)
	for y in ROWS:
		for x in COLS:
			if x == p.x and y == p.y:
				continue
			if unit_at(x, y) != null:
				continue
			var cost: int = _path_cost(cell, xy_cell(x, y))
			if cost >= 1 and cost <= pm:
				out.append({"side": s, "lane": xy_cell(x, y)})
	return out


func can_move(s: int, from: int, to: int) -> bool:
	if is_over() or s != current:
		return false
	if from < 0 or from >= LANES or to < 0 or to >= LANES or from == to:
		return false
	if creature_at(s, from) == null or creature_at(s, to) != null:
		return false
	var cr: Dictionary = creature_at(s, from)
	if int(cr.get("pm", 0)) < 1:
		return false
	var cost: int = _path_cost(from, to)
	return cost >= 1 and cost <= int(cr["pm"])


## Déplacement : chaque case parcourue coûte 1 PM (chemin 4 directions, cases libres).
func move(s: int, from: int, to: int) -> bool:
	if not can_move(s, from, to):
		return false
	var cost: int = _path_cost(from, to)
	var cr: Dictionary = creature_at(s, from)
	cr["pm"] = int(cr["pm"]) - cost
	var tp := cell_xy(to)
	cr["x"] = tp.x
	cr["y"] = tp.y
	_ev("move", s, to, cost, {"from": from})
	log.append("%s : %s se déplace" % [_nm(s), cr["name"]])
	return true


# ─── Effets ──────────────────────────────────────────────────────────────────

func _apply(s: int, effet: String, valeur: String, duree: int, target: Dictionary) -> void:
	var v: int = int(valeur)
	var foe: int = other(s)
	var tside: int = int(target.get("side", s))
	var tlane: int = int(target.get("lane", -1))
	match effet:
		"degats":
			_hit(tside, tlane, v, "spell")
		"degats_zone":
			for c: Variant in creatures(foe):
				if not is_over():
					_hit(foe, lane_of(foe, c), v, "spell")
		"degats_heros":
			_hit(foe, -1, v, "spell")
		"soin":
			_heal(tside, tlane, v)
		"soin_zone":
			for c: Variant in creatures(s):
				_heal(s, lane_of(s, c), v)
		"atq":
			var cr: Variant = creature_at(tside, tlane)
			if cr != null:
				(cr as Dictionary)["atk"] = int((cr as Dictionary)["atk"]) + v
				_ev("buff", tside, tlane, v)
		"atq_zone":
			for c: Variant in creatures(s):
				(c as Dictionary)["atk"] = int((c as Dictionary)["atk"]) + v
				_ev("buff", s, lane_of(s, c), v)
		"bouclier":
			_shield(tside, tlane, v)
		"bouclier_zone":
			for c: Variant in creatures(s):
				_shield(s, lane_of(s, c), v)
		"etourdir":
			_stun(tside, tlane, maxi(duree, 1))
		"etourdir_zone":
			for c: Variant in creatures(foe):
				_stun(foe, lane_of(foe, c), maxi(duree, 1))
		"poison":
			var pc: Variant = creature_at(tside, tlane)
			if pc != null:
				((pc as Dictionary)["poison"] as Array).append({"n": v, "t": maxi(duree, 1)})
				_ev("poison", tside, tlane, v)
		"invoquer":
			var lane: int = int(target.get("lane", -1))
			if lane < 0 or lane >= LANES or creature_at(s, lane) != null or not (cell_xy(lane).y in deploy_rows(s)):
				lane = -1
				for by: Variant in deploy_rows(s):
					for x in COLS:
						if lane < 0 and is_free_xy(x, int(by)):
							lane = xy_cell(x, int(by))
			if lane >= 0:
				var tok: Dictionary = _make_instance(valeur)
				if not tok.is_empty():
					tok["sick"] = true
					var tp := cell_xy(lane)
					tok["x"] = tp.x
					tok["y"] = tp.y
					(sides[s]["units"] as Array).append(tok)
					_ev("summon", s, lane, 0, {"name": tok["name"]})
		"pioche":
			draw(s, v)
		"mana":
			sides[s]["mana"] = int(sides[s]["mana"]) + v
			_ev("mana", s, -1, v)


func _shield(s: int, lane: int, n: int) -> void:
	var c: Variant = creature_at(s, lane)
	if c == null:
		return
	var cr: Dictionary = c
	cr["hp"] = int(cr["hp"]) + n
	cr["max_hp"] = int(cr["max_hp"]) + n
	_ev("buff", s, lane, n)


func _stun(s: int, lane: int, n: int) -> void:
	var c: Variant = creature_at(s, lane)
	if c == null:
		return
	var cr: Dictionary = c
	cr["stun"] = maxi(int(cr["stun"]), n)
	# une créature déjà étourdie ce tour-ci perd aussi ses actions restantes
	cr["attacked"] = true
	cr["used"] = true
	cr["pa"] = 0
	cr["pm"] = 0
	cr["frozen"] = true
	_ev("stun", s, lane, n)


func _heal(s: int, lane: int, n: int) -> void:
	if lane == -1:
		var before: int = int(sides[s]["hero_hp"])
		sides[s]["hero_hp"] = mini(maxi(HERO_HP, before), before + n)
		_ev("heal", s, -1, int(sides[s]["hero_hp"]) - before)
		return
	var c: Variant = creature_at(s, lane)
	if c == null:
		return
	var cr: Dictionary = c
	var hp0: int = int(cr["hp"])
	cr["hp"] = mini(int(cr["max_hp"]), hp0 + n)
	_ev("heal", s, lane, int(cr["hp"]) - hp0)


## Inflige des dégâts à un héros (lane -1) ou à une créature ; gère la mort et la fin de partie.
func _hit(s: int, lane: int, n: int, source: String = "") -> void:
	if n <= 0:
		return
	if lane == -1:
		sides[s]["hero_hp"] = int(sides[s]["hero_hp"]) - n
		var atk: int = other(s)
		sides[atk]["stats"]["hero_dmg"] = int(sides[atk]["stats"]["hero_dmg"]) + n
		_ev("dmg", s, -1, n, {"src": source})
		_check_winner()
		return
	var c: Variant = creature_at(s, lane)
	if c == null:
		return
	var cr: Dictionary = c
	cr["hp"] = int(cr["hp"]) - n
	_ev("dmg", s, lane, n, {"src": source})
	if int(cr["hp"]) <= 0:
		(sides[s]["units"] as Array).erase(cr)
		_ev("die", s, lane, 0, {"name": cr["name"]})
		if String(cr["type"]) != "Jeton":
			(sides[s]["fosse"] as Array).append(cr)


func _check_winner() -> void:
	var p0: bool = int(sides[0]["hero_hp"]) <= 0
	var p1: bool = int(sides[1]["hero_hp"]) <= 0
	if p0 and p1:
		winner = 2
	elif p0:
		winner = 1
	elif p1:
		winner = 0


func _nm(s: int) -> String:
	return "Vous" if s == 0 else "L'adversaire"



# ─── Pouvoir du héros (1 fois par duel) et mulligan ───

func can_use_hero_power(s: int) -> bool:
	if is_over() or s != current:
		return false
	var sd: Dictionary = sides[s]
	if bool(sd["power_used"]) or (sd["power"] as Dictionary).is_empty():
		return false
	var cible: String = String(sd["power"]["cible"])
	if needs_target(cible):
		return not targets_for(s, cible).is_empty()
	return true


func hero_power_targets(s: int) -> Array:
	var cible: String = String(sides[s]["power"]["cible"])
	if needs_target(cible):
		return targets_for(s, cible)
	return [{}]


func use_hero_power(s: int, target: Dictionary = {}) -> bool:
	if not can_use_hero_power(s):
		return false
	var sd: Dictionary = sides[s]
	var pw: Dictionary = sd["power"]
	var cible: String = String(pw["cible"])
	if needs_target(cible) and not _target_ok(s, cible, target):
		return false
	sd["power_used"] = true
	_ev("power", s, -1, 0, {"name": String(pw["name"])})
	log.append("%s lance son pouvoir : %s" % [_nm(s), String(pw["name"])])
	_apply(s, String(pw["effet"]), String(pw["valeur"]), int(pw["duree"]), target)
	return true


func can_mulligan(s: int) -> bool:
	if is_over() or s != current:
		return false
	var sd: Dictionary = sides[s]
	return bool(sd.get("mulligan", false)) and not (sd["hand"] as Array).is_empty()


## Nouvelle main (1 fois par duel) : la main retourne sous la pioche, on repioché START_HAND.
func mulligan(s: int) -> bool:
	if not can_mulligan(s):
		return false
	var sd: Dictionary = sides[s]
	var deck: Array = sd["deck"]
	for c: Variant in sd["hand"]:
		deck.append(c)
	sd["hand"] = []
	_shuffle(deck)
	for i in START_HAND:
		if not deck.is_empty():
			_draw_card(s, true)
	sd["mulligan"] = false
	_ev("mulligan", s, -1, 0, {})
	log.append("%s reprend une nouvelle main" % _nm(s))
	return true

# ─── IA ──────────────────────────────────────────────────────────────────────

## Joue UNE action pour le camp `s` et la décrit ({type, ...}). {"type": "end"} quand il n'y a plus rien d'utile.
func ai_step(s: int) -> Dictionary:
	if is_over() or s != current:
		return {"type": "end"}
	var foe: int = other(s)
	# 1) sorts de créatures (utilitaires) puis cartes de la main, la plus chère d'abord
	for i: int in LANES:
		if can_use_sort(s, i):
			var cr: Dictionary = creature_at(s, i)
			var tg: Variant = _ai_target(s, String(cr["effet"]), int(cr["valeur"]) if String(cr["effet"]) != "invoquer" and String(cr["effet"]) != "" else 0, String(cr["cible"]), i)
			if tg != null and use_sort(s, i, tg):
				return {"type": "sort", "lane": i}
	var order: Array = range((sides[s]["hand"] as Array).size())
	order.sort_custom(func(a: int, b: int) -> bool:
		return int(((sides[s]["hand"] as Array)[a] as Dictionary)["cost"]) > int(((sides[s]["hand"] as Array)[b] as Dictionary)["cost"]))
	for idx: int in order:
		if not can_play(s, idx):
			continue
		var c: Dictionary = (sides[s]["hand"] as Array)[idx]
		if String(c["type"]) == "Creature":
			var lane: int = _ai_cell(s)
			if lane >= 0 and play_card(s, idx, {"side": s, "lane": lane}):
				return {"type": "play", "card": c["name"]}
		else:
			var tg2: Variant = _ai_target(s, String(c["effet"]), int(c["valeur"]) if String(c["effet"]) != "invoquer" else 0, String(c["cible"]), -1)
			if tg2 != null and play_card(s, idx, tg2):
				return {"type": "play", "card": c["name"]}
	# 1.5) pouvoir du héros (une fois par duel)
	if can_use_hero_power(s):
		var pw: Dictionary = sides[s]["power"]
		var pcible: String = String(pw["cible"])
		var ptg: Variant = _ai_target(s, String(pw["effet"]), int(pw["valeur"]) if String(pw["valeur"]).is_valid_int() else 0, pcible, -1) if needs_target(pcible) else {}
		if ptg != null and use_hero_power(s, ptg if ptg is Dictionary else {}):
			return {"type": "power", "name": String(pw["name"])}
	# 2) attaques : pour chaque unité, la meilleure cible à portée PO
	#    (kill > cible faible), sinon le héros adverse si à portée
	for c: Variant in creatures(s):
		var cr: Dictionary = c
		var cell: int = lane_of(s, cr)
		if not can_attack(s, cell):
			continue
		var tg: Array = attack_targets(s, cell)
		if tg.is_empty():
			continue
		var best: Dictionary = {}
		var best_score: float = -1.0
		for e: Variant in tg:
			var ed: Dictionary = e
			var sc: float = 0.0
			if int(ed["lane"]) == -1:
				sc = 2.0 + (6.0 if int(sides[foe]["hero_hp"]) <= int(cr["atk"]) else 0.0)
			else:
				var b: Dictionary = creature_at(foe, int(ed["lane"]))
				sc = float(int(b["atk"])) * 0.5 + (3.0 if int(cr["atk"]) >= int(b["hp"]) else 0.0)
				if int(b["atk"]) >= int(cr["hp"]):
					sc -= 2.0   # la riposte tuerait notre unité
			if sc > best_score:
				best_score = sc
				best = ed
		if not best.is_empty() and attack(s, cell, best):
			return {"type": "attack", "lane": cell}
	# 3) déplacement : rapprocher une unité du héros adverse si elle n'a rien à attaquer
	for c: Variant in creatures(s):
		var cr: Dictionary = c
		var cell: int = lane_of(s, cr)
		if int(cr.get("pm", 0)) < 1 or bool(cr["sick"]):
			continue
		if not attack_targets(s, cell).is_empty():
			continue
		var cur_d: int = hero_dist_to(s, cell)
		var best_cell := -1
		var best_d := cur_d
		for t: Variant in move_targets(s, cell):
			var td: int = hero_dist_to(s, int((t as Dictionary)["lane"]))
			if td < best_d:
				best_d = td
				best_cell = int((t as Dictionary)["lane"])
		if best_cell >= 0 and move(s, cell, best_cell):
			return {"type": "move", "lane": best_cell, "from": cell}
	return {"type": "end"}


## Case de dépôt préférée par l'IA : ligne arrière, plutôt au centre.
func _ai_cell(s: int) -> int:
	var best: int = -1
	var best_score: float = -999.0
	for t: Variant in targets_for(s, "voie"):
		var cell: int = int((t as Dictionary)["lane"])
		var p := cell_xy(cell)
		var score: float = 2.0 - absf(float(p.x) - (COLS - 1) * 0.5) * 0.4
		score += _rng.randf() * 0.5
		if score > best_score:
			best_score = score
			best = cell
	return best


## Choisit la meilleure cible d'un effet, ou null si ça ne vaut pas la peine de le jouer.
func _ai_target(s: int, effet: String, v: int, cible: String, source_lane: int) -> Variant:
	var foe: int = other(s)
	var cands: Array = targets_for(s, cible)
	if cands.is_empty():
		return null
	match effet:
		"degats":
			var best: Variant = null
			var best_score: float = -1.0
			for t: Variant in cands:
				var td: Dictionary = t
				var sc: float = 0.0
				if int(td["lane"]) == -1:
					sc = 1.0 + (6.0 if int(sides[foe]["hero_hp"]) <= v else 0.0) + (1.0 if int(sides[foe]["hero_hp"]) <= 12 else 0.0)
				else:
					var c: Dictionary = creature_at(foe, int(td["lane"]))
					sc = float(int(c["atk"])) + (3.0 if v >= int(c["hp"]) else 0.0)
				if sc > best_score:
					best_score = sc
					best = td
			return best
		"degats_zone":
			var n: int = 0
			var kills: int = 0
			for c: Variant in creatures(foe):
				n += 1
				if int((c as Dictionary)["hp"]) <= v:
					kills += 1
			return {} if (kills >= 1 or n >= 2) else null
		"degats_heros":
			return {}
		"soin", "bouclier":
			var best2: Variant = null
			var miss: int = 0
			for t: Variant in cands:
				var td2: Dictionary = t
				var need: int = 0
				if int(td2["lane"]) == -1:
					need = HERO_HP - int(sides[s]["hero_hp"])
				else:
					var c2: Dictionary = creature_at(s, int(td2["lane"]))
					need = int(c2["max_hp"]) - int(c2["hp"]) if effet == "soin" else int(c2["atk"])
				if need > miss:
					miss = need
					best2 = td2
			return best2 if miss >= (2 if effet == "soin" else 1) else null
		"soin_zone":
			var hurt: int = 0
			for c3: Variant in creatures(s):
				if int((c3 as Dictionary)["hp"]) < int((c3 as Dictionary)["max_hp"]):
					hurt += 1
			return {} if hurt >= 1 else null
		"atq":
			var best3: Variant = null
			var ba: int = -1
			for t: Variant in cands:
				var cc: Variant = creature_at(s, int((t as Dictionary)["lane"]))
				if cc != null and int((cc as Dictionary)["atk"]) > ba and (source_lane < 0 or int((t as Dictionary)["lane"]) != source_lane or cands.size() == 1):
					ba = int((cc as Dictionary)["atk"])
					best3 = t
			return best3
		"atq_zone", "bouclier_zone":
			return {} if creatures(s).size() >= 2 else null
		"etourdir", "poison":
			var best4: Variant = null
			var bs: int = -1
			for t: Variant in cands:
				var td4: Dictionary = t
				var c4: Dictionary = creature_at(foe, int(td4["lane"]))
				var sc4: int = int(c4["atk"]) * 2 + int(c4["hp"])
				if bool(c4.get("stun", 0)) and effet == "etourdir":
					continue
				if sc4 > bs:
					bs = sc4
					best4 = td4
			return best4
		"etourdir_zone":
			return {} if creatures(foe).size() >= 2 else null
		"invoquer":
			var lane: int = _ai_cell(s)
			return {"side": s, "lane": lane} if lane >= 0 else null
		"pioche":
			return {} if (sides[s]["hand"] as Array).size() <= 5 else null
		"mana":
			return {}
	return null
