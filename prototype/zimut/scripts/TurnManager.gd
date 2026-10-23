extends Node
class_name TurnManager
## TurnManager.gd — IA tactique (ennemis, invocations alliées, mode « Auto »).
##
## À chaque tour, l'entité enchaîne des actions tant qu'il lui reste des PA/PM :
##   1. lancer le sort le plus rentable depuis sa position actuelle
##   2. sinon, se déplacer vers une case de tir (mêlée : au contact ; distance : à portée max)
##   3. fin du tour
## Les scores tiennent compte des dégâts estimés (résistances, critiques), des morts,
## des soins utiles, des statuts et de la provocation.

var game_manager: Node
var _running_uid: int = -1


func init(manager: Node) -> void:
	game_manager = manager
	game_manager.ai_turn_requested.connect(_on_ai_turn)


func _on_ai_turn(entity: Dictionary) -> void:
	var uid: int = int(entity["uid"])
	if uid == _running_uid:
		return
	_running_uid = uid
	await _run(entity)
	if _running_uid == uid:
		_running_uid = -1


func _grid() -> Node:
	return get_node_or_null("/root/Main/GridManager")


func _idle() -> void:
	var g: Node = _grid()
	var guard: int = 0
	while g != null and g.has_method("is_busy") and g.is_busy() and guard < 600:
		guard += 1
		await get_tree().process_frame


func _sleep(sec: float) -> void:
	await get_tree().create_timer(sec).timeout


func _still_active(e: Dictionary) -> bool:
	return not game_manager.game_over and game_manager.is_alive(e) \
		and int(game_manager.active_entity.get("uid", -1)) == int(e["uid"])


func _run(e: Dictionary) -> void:
	await _idle()
	await _sleep(0.35)
	var guard: int = 0
	while guard < 14:
		guard += 1
		if not _still_active(e):
			return
		var act: Dictionary = plan(e)
		if act.is_empty():
			break
		var ok: bool = false
		if act["type"] == "cast":
			ok = game_manager.cast_spell(e, act["spell"], act["cell"])
		else:
			ok = game_manager.try_move(e, act["cell"])
		if not ok:
			break
		await _idle()
		await _sleep(0.12)
	if _still_active(e):
		await _idle()
		if _still_active(e):
			game_manager.end_current_turn()


# ═══════════════════════════════════════════════════════════════════════════
#  Planification
# ═══════════════════════════════════════════════════════════════════════════

func plan(e: Dictionary) -> Dictionary:
	var best: Dictionary = {}
	var best_eff: float = 0.0
	for spell: Dictionary in e["spells"]:
		if not game_manager.can_afford(e, spell) or game_manager.casts_left(e, spell) <= 0:
			continue
		var p: Dictionary = Combat.parse(spell)
		for c: Vector2i in game_manager.spell_range_cells(e, spell):
			if game_manager.validate_cast(e, spell, c) != "":
				continue
			var sc: float = _score_cast(e, spell, p, c)
			if sc <= 0.0:
				continue
			sc *= 1.0 + _score_jitter(e)
			var eff: float = sc / (float(spell["cost_pa"]) + 1.0)
			if eff > best_eff:
				best_eff = eff
				best = {"type": "cast", "spell": spell, "cell": c}
	if not best.is_empty():
		return best
	return _plan_move(e)


func _score_cast(e: Dictionary, spell: Dictionary, p: Dictionary, c: Vector2i) -> float:
	var gm: Node = game_manager
	match String(p["kind"]):
		"attack":
			var taunt_uid: int = int(Combat.status_value(e, "taunted")) if Combat.has_status(e, "taunted") else -1
			var targets: Array = gm._attack_targets(e, p, c, spell)
			if targets.is_empty():
				return 0.0
			if taunt_uid >= 0 and p["aoe"] == "single" and int(targets[0]["uid"]) != taunt_uid:
				return 0.0
			var total: float = 0.0
			for t: Dictionary in targets:
				var hp: float = float(t["current_pv"])
				var dmg: float = float(gm.estimate_damage(e, spell, t))
				if p["cond"] == "kill_20" and gm.hp_ratio(t) < 0.2:
					dmg = hp
				total += minf(dmg, hp)
				if dmg >= hp:
					total += 60.0
				for dt: Dictionary in p["dots"]:
					total += float(dt["value"]) * float(dt["turns"]) * 0.55
				total += 12.0 * float(p["debuffs"].size())
				if int(p["stun_turns"]) > 0:
					total += 0.4 * float(p["stun_chance"])
				if int(p["push"]) > 0:
					total += 8.0
				if taunt_uid >= 0 and int(t["uid"]) == taunt_uid:
					total += 15.0
			return total
		"heal":
			var targets2: Array = gm.entities_of_team(String(e["team"])) if p["aoe"] == "team" else [gm.entity_at(c)]
			var total2: float = 0.0
			for t2: Dictionary in targets2:
				if t2.is_empty():
					continue
				var missing: float = float(t2["max_pv"]) - float(t2["current_pv"])
				var amt: float = float(p["heal"]) * (1.0 + float(e.get("intelligence", 0)) / 300.0)
				if int(p["heal_pct"]) > 0:
					amt = float(t2["max_pv"]) * float(p["heal_pct"]) / 100.0
				if int(p["regen"]) > 0:
					amt = maxf(amt, float(p["regen"]) * float(p["regen_turns"]) * 0.6)
				if missing > 0.0:
					total2 += minf(missing, amt) * 1.1
				if p["cure"] and _has_negative(t2):
					total2 += 25.0
			if int(p["adj_dmg"]) > 0 and not gm.entity_at(c).is_empty():
				for en: Dictionary in gm.enemies_of(e):
					if Combat.manhattan(gm.pos_of(en), c) == 1:
						total2 += float(p["adj_dmg"]) * 0.8
			return total2 if total2 >= 12.0 else 0.0
		"buff":
			var tgts: Array = []
			if p["buff_summons"]:
				tgts = gm.summons_of(e)
			elif p["aoe"] == "team":
				tgts = gm.entities_of_team(String(e["team"]))
			elif p["target"] == "ally":
				tgts = [gm.entity_at(c)]
			else:
				tgts = [e]
			var s: float = 0.0
			for t3: Dictionary in tgts:
				if t3.is_empty():
					continue
				if p["cure"] and _has_negative(t3):
					s += 25.0
				for b: Dictionary in p["buffs"]:
					if not Combat.has_status(t3, String(b["id"])):
						s += 18.0
				if gm.enemies_of(e).is_empty():
					return 0.0
			return s
		"glyph":
			var gcells: Array[Vector2i] = Combat.zone_cells(c, int(p["zone_r"]), String(p["zone_shape"]), gm.GRID_SIZE)
			for og: Dictionary in gm.glyphs_of(e):
				if og["name"] == spell["name"] and (og["cells"] as Array).has(c):
					return 0.0   # déjà posé ici
			var gs: float = 0.0
			var foes_fx: Dictionary = p["glyph_foes"]
			var allies_fx: Dictionary = p["glyph_allies"]
			for x: Dictionary in gm.all_entities():
				if not gm.is_alive(x) or bool(x.get("terrain", false)) or bool(x.get("beacon", false)) or not gcells.has(gm.pos_of(x)):
					continue
				if String(x["team"]) == String(e["team"]):
					if not allies_fx.is_empty():
						for b: Dictionary in allies_fx["buffs"]:
							if not Combat.has_status(x, String(b["id"])):
								gs += 16.0
					else:
						gs -= 10.0
				elif not foes_fx.is_empty():
					gs += float(foes_fx["dmg"]) * 1.4
					for dt: Dictionary in foes_fx["dots"]:
						gs += float(dt["value"]) * float(dt["turns"]) * 0.7
					gs += 14.0 * float(foes_fx["debuffs"].size())
			return gs if gs >= 20.0 else 0.0
		"summon":
			return 75.0 if gm.summons_of(e).size() < 2 else 0.0
		"revive":
			return 140.0 if not gm.graveyard.is_empty() else 0.0
	return 0.0


func _has_negative(e: Dictionary) -> bool:
	for s: Dictionary in e.get("statuses", []):
		if Combat.NEGATIVE.has(s["id"]):
			return true
	return false

## Personnalité de combat d'une entité ennemie, stable au fil du combat (dérivée
## de l'uid) pour varier les comportements entre ennemis et rendre les combats
## moins monotones : choix de cible, distance de tir, repli.
##   - agressif : fonce sur la cible la plus proche, reste au contact
##   - prudent : garde ses distances, se replie quand il est blessé
##   - opportuniste : chasse les lanceurs de sorts fragiles
##   - bagarreur (boss) : reste au CaC en forme, snipe à distance quand blessé
func _trait(e: Dictionary) -> String:
	if bool(e.get("boss", false)):
		return "brawler"
	if String(e.get("team", "")) != "enemy":
		return "balanced"
	match absi(int(e.get("uid", 0))) % 3:
		0:
			return "aggressive"
		1:
			return "cautious"
		_:
			return "opportunist"

## Petite variation des scores de sort selon l'entité et le tour : deux ennemis
## du même type ne lanceront pas toujours exactement les mêmes sorts.
func _score_jitter(e: Dictionary) -> float:
	if String(e.get("team", "")) != "enemy":
		return 0.0
	var h: int = (absi(int(e.get("uid", 0))) * 131 + int(game_manager.turn_count) * 17) % 100
	return float(h - 50) / 250.0


# ═══════════════════════════════════════════════════════════════════════════
#  Déplacement
# ═══════════════════════════════════════════════════════════════════════════

func _dist_map(from_pos: Vector2i, flies: bool) -> Dictionary:
	var gm: Node = game_manager
	var dist: Dictionary = {from_pos: 0}
	var queue: Array[Vector2i] = [from_pos]
	while not queue.is_empty():
		var cur: Vector2i = queue.pop_front()
		for d: Vector2i in Combat.DIRS:
			var n: Vector2i = cur + d
			if dist.has(n) or n.x < 0 or n.y < 0 or n.x >= gm.GRID_SIZE or n.y >= gm.GRID_SIZE:
				continue
			if gm.obstacles.has(n) and (not flies or String(gm.obstacles[n]) == "void"):
				continue
			dist[n] = int(dist[cur]) + 1
			queue.append(n)
	return dist


func _pick_target(e: Dictionary) -> Dictionary:
	var gm: Node = game_manager
	var epos: Vector2i = gm.pos_of(e)
	var foes: Array = gm.enemies_of(e)
	if foes.is_empty():
		return {}
	if Combat.has_status(e, "taunted"):
		for f: Dictionary in foes:
			if int(f["uid"]) == int(Combat.status_value(e, "taunted")):
				return f
	var persona: String = _trait(e)
	var best: Dictionary = {}
	var best_score: float = -1e9
	for f2: Dictionary in foes:
		var d: float = float(Combat.manhattan(epos, gm.pos_of(f2)))
		var sc: float = -d * 3.0 + (1.0 - gm.hp_ratio(f2)) * 12.0
		if Combat.has_status(f2, "invisible") and d > 1.0:
			sc -= 30.0
		# IA plus tactique : prioriser les soigneurs et les invocations gênantes
		var classe: String = String(f2.get("classe", ""))
		if classe == "Heal" or classe == "Druide":
			sc += 14.0
		if f2.get("entity_type", "") == "Summon":
			sc += 8.0
		# Finir les cibles quasi mortes (chasse à l'exécution)
		if gm.hp_ratio(f2) < 0.25:
			sc += 10.0
		# Personnalités : l'agressif fonce sur le plus proche (distance dominante),
		# l'opportuniste chasse les mages et soigneurs, le prudent reste neutre.
		match persona:
			"aggressive":
				sc -= d * 4.0
			"opportunist":
				if classe in ["Mage", "Heal", "Invocateur", "Druide"]:
					sc += 16.0
			"brawler":
				if gm.hp_ratio(e) < 0.5:
					sc += 6.0 * (1.0 - gm.hp_ratio(f2))
		if sc > best_score:
			best_score = sc
			best = f2
	return best


func _plan_move(e: Dictionary) -> Dictionary:
	var gm: Node = game_manager
	if int(e["current_pm"]) <= 0:
		return {}
	var target: Dictionary = _pick_target(e)
	if target.is_empty():
		return {}
	var tpos: Vector2i = gm.pos_of(target)
	var epos: Vector2i = gm.pos_of(e)

	# Portée utile : plus longue portée d'un sort offensif (même s'il manque quelques PA)
	var reach_rng: int = 1
	for s: Dictionary in e["spells"]:
		var p: Dictionary = Combat.parse(s)
		if p["kind"] == "attack" and p["aoe"] in ["single", "zone"] and int(s["cost_pa"]) <= int(e["max_pa"]):
			reach_rng = maxi(reach_rng, int(s["range"]))
	var ranged: bool = reach_rng >= 3
	var desired: int = mini(reach_rng, 4) if ranged else 1
	# Personnalités : l'agressif colle sa cible même s'il sait tirer ; le prudent
	# reste à distance ; le bagarreur (boss) préfère le CaC en forme et snipe
	# à portée max quand il est blessé.
	var persona: String = _trait(e)
	var hp: float = gm.hp_ratio(e)
	match persona:
		"aggressive":
			desired = 1
		"cautious":
			if ranged:
				desired = mini(reach_rng, 5)
		"brawler":
			desired = maxi(1, mini(reach_rng, 4) if hp < 0.5 and ranged else 1)

	var dmap: Dictionary = _dist_map(tpos, bool(e.get("fly", false)))
	var reach: Dictionary = gm.compute_reach(e)
	var best_cell: Vector2i = epos
	var best_score: float = _cell_score(e, epos, tpos, dmap, desired, reach_rng, 0)
	for c: Vector2i in reach["cost"].keys():
		if c == epos:
			continue
		var sc: float = _cell_score(e, c, tpos, dmap, desired, reach_rng, int(reach["cost"][c]))
		if sc > best_score + 1.0:
			best_score = sc
			best_cell = c
	if best_cell == epos:
		return {}
	return {"type": "move", "cell": best_cell}


func _cell_score(e: Dictionary, c: Vector2i, tpos: Vector2i, dmap: Dictionary, desired: int, rng: int, cost: int) -> float:
	var gm: Node = game_manager
	var d: int = int(dmap.get(c, 99))
	var man: int = Combat.manhattan(c, tpos)
	var sc: float = -absf(float(d - desired)) * 10.0 - float(cost) * 0.4
	if man <= rng and man >= 1 and (man == 1 or Combat.has_los(c, tpos, gm.los_blockers())):
		sc += 28.0
	if desired > 1:
		# Les tireurs évitent d'être au contact d'un ennemi — et fuient carrément s'ils sont blessés
		var flee: float = 14.0 if gm.hp_ratio(e) >= 0.4 else 30.0
		match _trait(e):
			"cautious":
				flee *= 1.5
			"brawler":
				flee *= 0.5
		var in_contact: int = 0
		for f: Dictionary in gm.enemies_of(e):
			if Combat.manhattan(c, gm.pos_of(f)) <= 1:
				in_contact += 1
		sc -= flee * float(in_contact)
	return sc
