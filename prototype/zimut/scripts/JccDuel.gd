class_name JccDuel
extends RefCounted
## JccDuel.gd — Règles du mode Cartes (JCC à voies, inspiré de Krosmaga / Magic). Aucune UI : testable en headless.
##
## Plateau : 4 voies. Chaque camp a UN emplacement par voie. Une créature attaque la créature adverse de SA voie ;
## si cette voie est vide, elle frappe directement le héros. Attaque manuelle, une fois par tour, pas le tour où
## la créature est posée (mal d'invocation). Chaque créature porte UN sort distinctif (payé en mana, une fois par tour).
## Mana : 1 au premier tour, +1 par tour, max 10. Une pioche par tour. Pioche vide = fatigue croissante.
## Une carte jouée (sort) ou perdue (créature morte) rejoint la fosse ; les jetons disparaissent.

const LANES: int = 4
const HERO_HP: int = 30
const HAND_MAX: int = 7
const MANA_MAX: int = 10
const START_HAND: int = 4

var sides: Array = []
var current: int = 0
var turn: int = 0              # numéro de tour global (1, 2, 3…)
var winner: int = -1           # -1 en cours, 0 joueur, 1 adversaire, 2 égalité
var events: Array = []         # événements pour l'interface : {k, side, lane, n, ...}
var log: Array = []
var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _uid: int = 0
var _turns_started: Array = [0, 0]


func setup(deck0: Array, deck1: Array, seed_value: int = 0) -> void:
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
			"lanes": [null, null, null, null], "fatigue": 0})
	for s: int in 2:
		for i: int in START_HAND:
			if not (sides[s]["deck"] as Array).is_empty():
				_draw_card(s, false)
	winner = -1
	turn = 0
	events = []
	log = []
	_turns_started = [0, 0]
	start_turn(0)


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
	c["sick"] = false
	c["attacked"] = false
	c["used"] = false
	c["stun"] = 0
	c["poison"] = []
	return c


func side(s: int) -> Dictionary:
	return sides[s]


func other(s: int) -> int:
	return 1 - s


func creature_at(s: int, lane: int) -> Variant:
	if lane < 0 or lane >= LANES:
		return null
	return (sides[s]["lanes"] as Array)[lane]


func creatures(s: int) -> Array:
	var out: Array = []
	for c: Variant in sides[s]["lanes"]:
		if c != null:
			out.append(c)
	return out


func lane_of(s: int, c: Dictionary) -> int:
	var lanes: Array = sides[s]["lanes"]
	for i: int in LANES:
		if lanes[i] != null and int((lanes[i] as Dictionary)["uid"]) == int(c["uid"]):
			return i
	return -1


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
	sd["mana_max"] = mini(MANA_MAX, int(sd["mana_max"]) + 1)
	sd["mana"] = sd["mana_max"]
	if int(_turns_started[s]) > 1 or s == 1:
		_draw_card(s, true)
	for c: Variant in creatures(s):
		var cr: Dictionary = c
		cr["sick"] = false
		cr["attacked"] = false
		cr["used"] = false
		if int(cr["stun"]) > 0:
			cr["attacked"] = true
			cr["used"] = true
			cr["stun"] = int(cr["stun"]) - 1
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
	start_turn(other(s))
	return true


func _draw_card(s: int, with_event: bool) -> void:
	var sd: Dictionary = sides[s]
	var deck: Array = sd["deck"]
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
			for i: int in LANES:
				if creature_at(foe, i) != null:
					out.append({"side": foe, "lane": i})
			if cible == "ennemi_ou_heros":
				out.append({"side": foe, "lane": -1})
		"allie", "allie_ou_heros":
			for i: int in LANES:
				if creature_at(s, i) != null:
					out.append({"side": s, "lane": i})
			if cible == "allie_ou_heros":
				out.append({"side": s, "lane": -1})
		"voie":
			for i: int in LANES:
				if creature_at(s, i) == null:
					out.append({"side": s, "lane": i})
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
		(sd["hand"] as Array).remove_at(hand_idx)
		sd["mana"] = int(sd["mana"]) - int(c["cost"])
		c["sick"] = true
		(sd["lanes"] as Array)[int(target["lane"])] = c
		_ev("summon", s, int(target["lane"]), 0, {"name": c["name"]})
		log.append("%s pose %s" % [_nm(s), c["name"]])
		return true
	if not _target_ok(s, String(c["cible"]), target):
		return false
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
	if int(cr["sort_cost"]) > int(sides[s]["mana"]):
		return false
	return not targets_for(s, String(cr["cible"])).is_empty()


func use_sort(s: int, lane: int, target: Dictionary = {}) -> bool:
	if not can_use_sort(s, lane):
		return false
	var cr: Dictionary = creature_at(s, lane)
	if not _target_ok(s, String(cr["cible"]), target):
		return false
	sides[s]["mana"] = int(sides[s]["mana"]) - int(cr["sort_cost"])
	cr["used"] = true
	_ev("cast", s, lane, 0, {"name": cr["sort"]})
	log.append("%s : %s utilise %s" % [_nm(s), cr["name"], cr["sort"]])
	_apply(s, String(cr["effet"]), String(cr["valeur"]), int(cr["duree"]), target)
	return true


func can_attack(s: int, lane: int) -> bool:
	if is_over() or s != current:
		return false
	var c: Variant = creature_at(s, lane)
	if c == null:
		return false
	var cr: Dictionary = c
	return not bool(cr["sick"]) and not bool(cr["attacked"]) and int(cr["atk"]) > 0


func attack(s: int, lane: int) -> bool:
	if not can_attack(s, lane):
		return false
	var cr: Dictionary = creature_at(s, lane)
	cr["attacked"] = true
	var foe: int = other(s)
	var blocker: Variant = creature_at(foe, lane)
	_ev("attack", s, lane, 0, {"hero": blocker == null})
	if blocker == null:
		_hit(foe, -1, int(cr["atk"]), "attack")
		log.append("%s frappe le héros de %s (%d)" % [cr["name"], _nm(foe), int(cr["atk"])])
	else:
		var b: Dictionary = blocker
		var back: int = int(b["atk"])
		_hit(foe, lane, int(cr["atk"]), "attack")
		if not is_over():
			_hit(s, lane, back, "attack")
		log.append("%s attaque %s" % [cr["name"], b["name"]])
	return true


func can_move(s: int, lane: int, to: int) -> bool:
	if is_over() or s != current or abs(lane - to) != 1 or to < 0 or to >= LANES:
		return false
	var c: Variant = creature_at(s, lane)
	if c == null or creature_at(s, to) != null:
		return false
	var cr: Dictionary = c
	return not bool(cr["sick"]) and not bool(cr["attacked"])


func move(s: int, lane: int, to: int) -> bool:
	if not can_move(s, lane, to):
		return false
	var lanes: Array = sides[s]["lanes"]
	var cr: Dictionary = lanes[lane]
	lanes[lane] = null
	lanes[to] = cr
	cr["attacked"] = true
	_ev("move", s, to, 0, {"from": lane})
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
			if lane < 0 or creature_at(s, lane) != null:
				lane = -1
				for i: int in LANES:
					if creature_at(s, i) == null:
						lane = i
						break
			if lane >= 0:
				var tok: Dictionary = _make_instance(valeur)
				if not tok.is_empty():
					tok["sick"] = true
					(sides[s]["lanes"] as Array)[lane] = tok
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
	_ev("stun", s, lane, n)


func _heal(s: int, lane: int, n: int) -> void:
	if lane == -1:
		var before: int = int(sides[s]["hero_hp"])
		sides[s]["hero_hp"] = mini(HERO_HP, before + n)
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
		(sides[s]["lanes"] as Array)[lane] = null
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
			var lane: int = _ai_lane(s)
			if lane >= 0 and play_card(s, idx, {"side": s, "lane": lane}):
				return {"type": "play", "card": c["name"]}
		else:
			var tg2: Variant = _ai_target(s, String(c["effet"]), int(c["valeur"]) if String(c["effet"]) != "invoquer" else 0, String(c["cible"]), -1)
			if tg2 != null and play_card(s, idx, tg2):
				return {"type": "play", "card": c["name"]}
	# 2) attaques
	for i: int in LANES:
		if can_attack(s, i):
			var me: Dictionary = creature_at(s, i)
			var bl: Variant = creature_at(foe, i)
			var go: bool = true
			if bl != null:
				var b: Dictionary = bl
				var kills: bool = int(me["atk"]) >= int(b["hp"])
				var survives: bool = int(b["atk"]) < int(me["hp"])
				go = kills or survives or (int(me["atk"]) >= int(b["atk"]) and int(sides[s]["hero_hp"]) > 12)
			if go and attack(s, i):
				return {"type": "attack", "lane": i}
	return {"type": "end"}


func _ai_lane(s: int) -> int:
	var foe: int = other(s)
	var best: int = -1
	var best_score: float = -999.0
	for t: Variant in targets_for(s, "voie"):
		var i: int = int((t as Dictionary)["lane"])
		var score: float = 0.0
		var b: Variant = creature_at(foe, i)
		if b == null:
			score = 3.0   # voie ouverte : menace directe sur le héros
		else:
			score = 1.0 - float(int((b as Dictionary)["atk"])) * 0.3
		score += _rng.randf() * 0.5
		if score > best_score:
			best_score = score
			best = i
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
			var lane: int = _ai_lane(s)
			return {"side": s, "lane": lane} if lane >= 0 else null
		"pioche":
			return {} if (sides[s]["hand"] as Array).size() <= 5 else null
		"mana":
			return {}
	return null
