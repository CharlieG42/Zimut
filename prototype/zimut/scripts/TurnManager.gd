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

## V152 : équipes forcées sur l'ancienne IA « gloutonne » (simulations d'équilibrage :
## on garde les héros sur l'ancienne IA pour mesurer le gain de la nouvelle côté ennemi).
static var legacy_teams: Array = []
## V152 : cible de concentration par équipe (uid) — les alliés finissent la même proie.
var _focus: Dictionary = {}
## Planification en cours avec l'IA tactique (calculé au début de plan()).
var _cur_smart: bool = false


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
	var acted: bool = false
	while guard < 14:
		guard += 1
		if not _still_active(e):
			return
		var act: Dictionary = plan(e, acted)
		if act.is_empty():
			break
		var ok: bool = false
		if act["type"] == "cast":
			var tgt: Dictionary = game_manager.entity_at(act["cell"])
			ok = game_manager.cast_spell(e, act["spell"], act["cell"])
			if ok:
				acted = true
				if not tgt.is_empty() and String(tgt.get("team", "")) != String(e["team"]):
					_focus[String(e["team"])] = int(tgt["uid"])
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

## Choisit la prochaine action. `acted` : l'entité a déjà lancé un sort ce tour
## (l'IA tactique en profite pour se replier avec ses PM restants).
func plan(e: Dictionary, acted: bool = false) -> Dictionary:
	_cur_smart = _smart(e)
	var now: Dictionary = _best_cast_here(e)
	if not _cur_smart:
		return now.get("act", _plan_move(e))
	# IA tactique : se déplacer d'abord si une meilleure attaque (ou un soin) devient possible
	if int(e["current_pm"]) > 0 and not Combat.has_status(e, "root"):
		var mv: Dictionary = _best_move_then_cast(e)
		if not mv.is_empty() and float(mv["eff"]) > float(now.get("eff", 0.0)) * 1.15 + 1.0:
			return {"type": "move", "cell": mv["cell"]}
	if now.has("act"):
		return now["act"]
	if acted:
		var back: Dictionary = _plan_retreat(e)
		if not back.is_empty():
			return back
	return _plan_move(e)


## Meilleur sort lançable depuis la position actuelle : {"act", "eff"} (vide si aucun).
func _best_cast_here(e: Dictionary) -> Dictionary:
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
	if best.is_empty():
		return {}
	return {"act": best, "eff": best_eff}


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
				if _cur_smart and String(t.get("team", "")) != String(e["team"]):
					total += _focus_bonus(e, t, minf(dmg, hp), dmg >= hp)
				for dt: Dictionary in p["dots"]:
					total += float(dt["value"]) * float(dt["turns"]) * 0.55
				total += 12.0 * float(p["debuffs"].size())
				if int(p["stun_turns"]) > 0:
					total += 0.4 * float(p["stun_chance"])
				if int(p["push"]) > 0:
					total += 8.0
				if int(p["pull"]) > 0:
					total += 6.0
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
			return _score_summon(e, p, c)
		"trigger":
			return _score_trigger(e, c)
		"trigger_all":
			var tot: float = 0.0
			for m: Dictionary in gm.mechs_of(e):
				if String(m["mech"]) == "bomb":
					tot += _score_trigger(e, gm.pos_of(m))
			return tot
		"reinforce":
			var hurt: int = 0
			for m2: Dictionary in gm.mechs_of(e):
				if float(m2["current_pv"]) < float(m2["max_pv"]) * 0.7:
					hurt += 1
			return 30.0 * float(hurt) if hurt > 0 else 0.0
		"trap":
			# Mines / pièges : utiles seulement près des ennemis, et pas en rafale
			var nt: int = 0
			for tr: Dictionary in gm.traps:
				if int(tr["owner"]) == int(e["uid"]):
					nt += 1
			return 30.0 if nt < 3 and _foes_near(e, c, 3) > 0 else 0.0
		"revive":
			return 140.0 if not gm.graveyard.is_empty() else 0.0
	return 0.0



func _foes_near(e: Dictionary, c: Vector2i, r: int) -> int:
	var n: int = 0
	for f: Dictionary in game_manager.enemies_of(e):
		if game_manager.is_alive(f) and not bool(f.get("terrain", false)) and not bool(f.get("beacon", false)) \
				and Combat.manhattan(c, game_manager.pos_of(f)) <= r:
			n += 1
	return n


func _friends_near(e: Dictionary, c: Vector2i, r: int) -> int:
	var n: int = 0
	for f: Dictionary in game_manager.entities_of_team(String(e["team"])):
		if game_manager.is_alive(f) and not bool(f.get("terrain", false)) and not bool(f.get("beacon", false)) \
				and Combat.manhattan(c, game_manager.pos_of(f)) <= r:
			n += 1
	return n


## Invocation : créature (75 tant qu'il en a moins de 2) ; constructions et mécanismes jugés sur leur emplacement.
## (Les balises de chasse ne font rien seules : l'IA ne les repose pas en boucle — blocage observé.)
func _score_summon(e: Dictionary, p: Dictionary, c: Vector2i) -> float:
	var gm: Node = game_manager
	var info: Dictionary = Combat.SUMMONS.get(String(p.get("summon", "")), {})
	if bool(info.get("beacon", false)):
		return 0.0
	var mech: String = String(info.get("mech", ""))
	if mech == "swap":
		return 0.0   # balise de transposition : demande un enchaînement que l'IA ne joue pas
	if mech == "bomb":
		# une bombe n'a d'intérêt que si des ennemis sont (ou seront) dans son rayon
		var r: int = int(info.get("bomb_radius", gm.BOMB_RADIUS))
		var foes: int = _foes_near(e, c, r + 1)
		if foes == 0:
			return 0.0
		return 20.0 + 28.0 * float(foes) - 25.0 * float(_friends_near(e, c, r))
	if mech == "turret":
		return 65.0 if _foes_near(e, c, int(info.get("turret_range", gm.TURRET_RANGE)) + 2) > 0 else 0.0
	if bool(info.get("terrain", false)):
		# pilier / muraille / cristal : à portée de tir d'un ennemi, jamais collé à un allié
		if _foes_near(e, c, gm.TOWER_RANGE) == 0 or _friends_near(e, c, 1) > 0:
			return 0.0
		return 55.0 if int(info.get("span", 1)) == 1 else 0.0
	return 75.0 if gm.summons_of(e).size() < 2 else 0.0


## Déclencheur sur une bombe : dégâts attendus (ennemis dans le rayon) moins les alliés touchés.
func _score_trigger(e: Dictionary, c: Vector2i) -> float:
	var gm: Node = game_manager
	if gm.trigger_kind(e, c) != "bomb":
		return 0.0
	var bomb: Dictionary = gm.entity_at(c)
	var r: int = int(bomb.get("bomb_radius", gm.BOMB_RADIUS))
	var foes: int = _foes_near(e, c, r)
	var lvl: int = int(bomb.get("bomb_level", 1))
	var sc: float = 38.0 * float(foes) * (0.8 + 0.2 * float(lvl)) - 30.0 * float(_friends_near(e, c, r))
	return sc if sc >= 30.0 else 0.0


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
#  V152 — IA tactique : se placer puis frapper, concentrer, se replier
# ═══════════════════════════════════════════════════════════════════════════

## IA tactique active pour cette entité ? Les ennemis en Facile gardent l'ancienne IA
## (plus prévisible) ; les simulations peuvent forcer une équipe sur l'ancienne IA.
func _smart(e: Dictionary) -> bool:
	var team: String = String(e.get("team", ""))
	if legacy_teams.has(team):
		return false
	if team == "enemy":
		var gs: Node = (Engine.get_main_loop() as SceneTree).root.get_node_or_null("GameSettings")
		var d: int = int(gs.call("save_difficulty", game_manager.active_save)) if gs != null else 1
		return d >= 1
	return true


## Bonus de « concentration » : finir les blessés, viser les soigneurs, suivre la cible
## déjà entamée par l'équipe — ce que fait un joueur humain et que l'IA ignorait.
func _focus_bonus(e: Dictionary, t: Dictionary, dealt: float, kills: bool) -> float:
	var gm: Node = game_manager
	var b: float = dealt * (1.0 - gm.hp_ratio(t)) * 0.5
	var classe: String = String(t.get("classe", ""))
	if classe in ["Heal", "Druide"]:
		b += dealt * 0.25
	if int(_focus.get(String(e["team"]), -1)) == int(t["uid"]):
		b += dealt * 0.2 + 8.0
	if kills:
		b += 25.0
	if bool(t.get("terrain", false)) or bool(t.get("beacon", false)):
		b -= dealt * 0.5
	return b


## Plus longue portée offensive utile de l'entité.
func _attack_range(e: Dictionary) -> int:
	var r: int = 1
	for s: Dictionary in e.get("spells", []):
		var p: Dictionary = Combat.parse(s)
		if p["kind"] == "attack" and p["aoe"] in ["single", "zone"] and int(s["cost_pa"]) <= int(e.get("max_pa", 6)):
			r = maxi(r, int(s["range"]))
	return r


func _is_healer(e: Dictionary) -> bool:
	if String(e.get("classe", "")) in ["Heal", "Druide"]:
		return true
	for s: Dictionary in e.get("spells", []):
		if Combat.parse(s)["kind"] == "heal":
			return true
	return false


## Fragile = doit éviter la mêlée : tireur, soigneur ou prudent (les agressifs et les
## boss en forme assument le contact).
func _fragile(e: Dictionary) -> bool:
	match _trait(e):
		"aggressive":
			return false
		"brawler":
			return game_manager.hp_ratio(e) < 0.5
		"cautious":
			return true
	return _attack_range(e) >= 3 or _is_healer(e)


## Menaces adverses : position, portée totale (PM + portée d'attaque) et poids.
func _foe_info(e: Dictionary) -> Array:
	var gm: Node = game_manager
	var out: Array = []
	for f: Dictionary in gm.enemies_of(e):
		if not gm.is_alive(f) or bool(f.get("terrain", false)) or bool(f.get("beacon", false)):
			continue
		if String(f.get("mech", "")) != "" and String(f.get("mech", "")) != "turret":
			continue
		var mv: int = 0 if String(f.get("mech", "")) == "turret" else int(f.get("max_pm", f.get("current_pm", 3)))
		var w: float = 1.0
		if bool(f.get("boss", false)):
			w = 1.6
		elif String(f.get("entity_type", "")) == "Summon":
			w = 0.6
		out.append({"pos": gm.pos_of(f), "reach": mv + _attack_range(f), "w": w})
	return out


func _threat_at(c: Vector2i, info: Array) -> float:
	var t: float = 0.0
	for fi: Dictionary in info:
		var d: int = Combat.manhattan(c, fi["pos"])
		if d <= int(fi["reach"]):
			t += float(fi["w"])
			if d <= 1:
				t += 0.5 * float(fi["w"])
	return t


## Vérification rapide de la cible (le vrai contrôle est refait par cast_spell).
func _quick_target_ok(e: Dictionary, p: Dictionary, from: Vector2i, tc: Vector2i) -> bool:
	var gm: Node = game_manager
	var t: Dictionary = gm.entity_at(tc)
	match String(p["target"]):
		"enemy":
			if t.is_empty() or String(t["team"]) == String(e["team"]):
				return false
			if Combat.has_status(t, "invisible") and Combat.manhattan(from, tc) > 1:
				return false
		"ally":
			if t.is_empty() or String(t["team"]) != String(e["team"]):
				return false
		"free_cell":
			if not gm.is_free(tc):
				return false
		"any_entity":
			if t.is_empty() or int(t["uid"]) == int(e["uid"]):
				return false
	if p["cond"] == "exec_30" and not t.is_empty() and gm.hp_ratio(t) >= 0.3:
		return false
	if (p["needs_summon"] or p["buff_summons"]) and gm.summons_of(e).is_empty():
		return false
	return true


## Cases visables intéressantes depuis `from` (autour des cibles plutôt que toute la portée).
func _candidate_cells(e: Dictionary, spell: Dictionary, p: Dictionary, from: Vector2i, foes: Array, friends: Array, blockers: Dictionary) -> Array[Vector2i]:
	var gm: Node = game_manager
	var out: Array[Vector2i] = []
	if p["target"] == "self":
		out.append(from)
		return out
	var pool: Array[Vector2i] = []
	if p["kind"] == "attack":
		for f: Dictionary in foes:
			var fp: Vector2i = gm.pos_of(f)
			pool.append(fp)
			if p["aoe"] == "zone":
				for d: Vector2i in Combat.DIRS:
					pool.append(fp + d)
	else:
		for a: Dictionary in friends:
			pool.append(gm.pos_of(a))
	var rng: int = int(spell["range"])
	for tc: Vector2i in pool:
		if out.has(tc) or not gm._in_bounds(tc):
			continue
		var d2: int = Combat.manhattan(from, tc)
		if d2 > rng or d2 < int(p["min_range"]):
			continue
		if p["needs_los"] and d2 > 1 and not Combat.has_los(from, tc, blockers):
			continue
		if _quick_target_ok(e, p, from, tc):
			out.append(tc)
	return out


## Pour chaque case atteignable, meilleur sort (attaque / soin) lançable une fois arrivé.
## Les fragiles pénalisent les cases exposées. Retourne {"cell", "eff"} ou {}.
func _best_move_then_cast(e: Dictionary) -> Dictionary:
	var gm: Node = game_manager
	var spells: Array = []
	for s: Dictionary in e["spells"]:
		var k: String = String(Combat.parse(s)["kind"])
		if (k == "attack" or k == "heal") and int(e["current_pa"]) >= int(s["cost_pa"]) and gm.casts_left(e, s) > 0:
			spells.append(s)
	if spells.is_empty():
		return {}
	var foes: Array = []
	for f: Dictionary in gm.enemies_of(e):
		if gm.is_alive(f) and not bool(f.get("beacon", false)):
			foes.append(f)
	var friends: Array = gm.entities_of_team(String(e["team"]))
	var blockers: Dictionary = gm.los_blockers()
	var fragile: bool = _fragile(e)
	var info: Array = _foe_info(e) if fragile else []
	var reach: Dictionary = gm.compute_reach(e)
	var start: Vector2i = gm.pos_of(e)
	var pm0: int = int(e["current_pm"])
	var best: Dictionary = {}
	var best_eff: float = 0.0
	for c: Vector2i in reach["cost"].keys():
		if c == start:
			continue
		var cost: int = int(reach["cost"][c])
		# déplacement virtuel (restauré juste après)
		gm.grid[start.y][start.x] = null
		gm.grid[c.y][c.x] = e
		e["x"] = c.x
		e["y"] = c.y
		e["current_pm"] = pm0 - cost
		var cbest: float = 0.0
		for spell: Dictionary in spells:
			if not gm.can_afford(e, spell):
				continue
			var p: Dictionary = Combat.parse(spell)
			for tc: Vector2i in _candidate_cells(e, spell, p, c, foes, friends, blockers):
				var sc: float = _score_cast(e, spell, p, tc)
				if sc > 0.0:
					cbest = maxf(cbest, sc / (float(spell["cost_pa"]) + 1.0))
		gm.grid[c.y][c.x] = null
		gm.grid[start.y][start.x] = e
		e["x"] = start.x
		e["y"] = start.y
		e["current_pm"] = pm0
		if cbest <= 0.0:
			continue
		cbest -= float(cost) * 0.5
		if fragile:
			cbest *= clampf(1.0 - 0.12 * _threat_at(c, info), 0.4, 1.0)
		if cbest > best_eff:
			best_eff = cbest
			best = {"cell": c, "eff": cbest}
	return best


## Après avoir frappé (ou pour un soigneur sans rien à faire) : se mettre à l'abri
## en restant à portée utile — le « frapper puis reculer » des tireurs.
func _plan_retreat(e: Dictionary) -> Dictionary:
	var gm: Node = game_manager
	if int(e["current_pm"]) <= 0 or not _fragile(e):
		return {}
	var info: Array = _foe_info(e)
	var anchor: Vector2i = gm.pos_of(e)
	var desired: int = mini(_attack_range(e), 4)
	var target: Dictionary = _pick_target(e)
	if not target.is_empty():
		anchor = gm.pos_of(target)
	if _is_healer(e):
		# rester près de l'allié le plus blessé
		var worst: float = 2.0
		for a: Dictionary in gm.entities_of_team(String(e["team"])):
			if int(a["uid"]) == int(e["uid"]) or not gm.is_alive(a) or bool(a.get("terrain", false)) or bool(a.get("beacon", false)):
				continue
			if gm.hp_ratio(a) < worst:
				worst = gm.hp_ratio(a)
				anchor = gm.pos_of(a)
				desired = 2
	var reach: Dictionary = gm.compute_reach(e)
	var start: Vector2i = gm.pos_of(e)
	var best_cell: Vector2i = start
	var best_sc: float = -_threat_at(start, info) * 20.0 - absf(float(Combat.manhattan(start, anchor) - desired)) * 2.0
	for c: Vector2i in reach["cost"].keys():
		if c == start:
			continue
		var sc: float = -_threat_at(c, info) * 20.0 - absf(float(Combat.manhattan(c, anchor) - desired)) * 2.0 - float(reach["cost"][c]) * 0.3
		if sc > best_sc + 2.0:
			best_sc = sc
			best_cell = c
	if best_cell == start:
		return {}
	return {"type": "move", "cell": best_cell}


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
