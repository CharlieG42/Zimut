extends Node
## GameManager.gd — Règles et état du combat Zimut (autoload).
##
## Nouveautés par rapport à la version précédente :
##  - Tours par INITIATIVE individuelle (façon Dofus / Waven) au lieu de « camp par camp »
##  - Déplacements case par case avec pathfinding (BFS), obstacles réels
##  - Ligne de vue, portée min/max, zones d'effet, poussée, collisions
##  - Statuts avec durée (poison, étourdissement, buffs/debuffs, régénération...)
##  - Coups critiques, attaques dans le dos, résistances en %
##  - Invocations, pièges, téléportations, résurrection
##  - Événements « fx » consommés par GridManager pour animer le tout

signal turn_changed(turn: int)
signal player_changed(index: int)
signal entity_selected(entity)
signal spell_selected(spell)
signal game_ended(victory: bool)
signal entity_moved(entity, from_pos: Vector2i, to_pos: Vector2i)
signal entity_attacked(attacker, target, damage: int)
signal spell_casted(caster, spell, target, result: String)
signal message_requested(text: String)
signal turn_started(entity)
signal ai_turn_requested(entity)
signal fx(kind: String, data: Dictionary)
signal state_changed()

const GRID_SIZE        := 8
const CELL_SIZE        := Vector2i(140, 140)   # conservé pour compatibilité
const CELL_HALF_OFFSET := Vector2i(70, 70)

const DEFAULT_PLAYER_LEVEL := 10
const DEFAULT_ENEMY_LEVEL  := 10

const PLAYER_SPAWNS: Array[Vector2i] = [Vector2i(1, 1), Vector2i(2, 1), Vector2i(1, 2)]
const ENEMY_SPAWNS: Array[Vector2i]  = [Vector2i(6, 6), Vector2i(6, 5), Vector2i(5, 6), Vector2i(6, 4)]

const COLORS: Dictionary = {
	"Tank":      Color(0, 0.4, 0.8),
	"Assassin":  Color(0.8, 0, 0),
	"Chasseur":  Color(0, 0.8, 0),
	"Mage":      Color(0.6, 0, 0.8),
	"Druide":    Color(1, 0.8, 0),
	"Heal":      Color(0, 0.8, 0.8),
	"Invocateur": Color(0.9, 0.5, 0.1),
	"Gobelin":   Color(0.5, 0.8, 0.3),
	"Squelette": Color(0.8, 0.8, 0.8),
	"Loup":      Color(0.6, 0.6, 0.4),
	"Troll":     Color(0.45, 0.6, 0.35),
	"Dragonnet": Color(0.9, 0.35, 0.2),
}

## Multiplicateur de PV ennemis (équilibrage)
const ENEMY_HP_MULT := 1.8

var grid: Array                  = []
var obstacles: Dictionary        = {}   # Vector2i -> "tree" | "rock"
var traps: Array                 = []   # {pos, dmg, team, owner}
var players: Array               = []
var enemies: Array               = []
var summons: Array               = []
var turn_order: Array            = []
var graveyard: Array             = []
var active_entity: Dictionary    = {}
var current_turn: int            = 0     # 0 = le joueur contrôle, 1 = IA en action
var current_player_index: int    = 0
var turn_count: int              = 1
var selected_entity              = null
var selected_spell               = null
var selected_cell: Vector2i      = Vector2i(0, 0)
var show_spells: bool            = false
var game_over: bool              = false
var victory: bool                = false
var auto_mode: bool              = false
var custom_team: Array           = []

var _turn_index: int = -1
var _uid_counter: int = 0
var _epoch: int = 0
var _rng := RandomNumberGenerator.new()


# ═══════════════════════════════════════════════════════════════════════════
#  Équipe personnalisée / démarrage
# ═══════════════════════════════════════════════════════════════════════════

func set_custom_team(team_data: Array) -> void:
	custom_team = team_data


func clear_custom_team() -> void:
	custom_team = []


func _ready() -> void:
	_rng.randomize()
	var data_loader: Node = get_node_or_null("/root/DataLoader")
	if data_loader == null:
		push_error("DataLoader autoload introuvable — vérifier project.godot")
		return
	if data_loader.data_loaded:
		_on_data_loaded()
	elif not data_loader.data_loaded_successfully.is_connected(_on_data_loaded):
		data_loader.data_loaded_successfully.connect(_on_data_loaded)


func _on_data_loaded() -> void:
	init_grid()
	init_entities()
	start_battle()


func get_classes_data() -> Array:
	var dl: Node = get_node_or_null("/root/DataLoader")
	return dl.classes_data if dl else []


func get_spells_data() -> Array:
	var dl: Node = get_node_or_null("/root/DataLoader")
	return dl.spells_data if dl else []


func get_enemies_data() -> Array:
	var dl: Node = get_node_or_null("/root/DataLoader")
	return dl.enemies_data if dl else []


# ═══════════════════════════════════════════════════════════════════════════
#  Grille, obstacles, entités
# ═══════════════════════════════════════════════════════════════════════════

func init_grid() -> void:
	grid = []
	for _y: int in range(GRID_SIZE):
		var row: Array = []
		for _x: int in range(GRID_SIZE):
			row.append(null)
		grid.append(row)
	_generate_obstacles()


func _generate_obstacles() -> void:
	obstacles = {}
	var forbidden: Dictionary = {}
	for sp: Vector2i in PLAYER_SPAWNS + ENEMY_SPAWNS:
		forbidden[sp] = true
		for d: Vector2i in Combat.DIRS:
			forbidden[sp + d] = true
	var wanted: int = _rng.randi_range(6, 9)
	var attempts: int = 0
	while obstacles.size() < wanted and attempts < 300:
		attempts += 1
		var c := Vector2i(_rng.randi_range(0, GRID_SIZE - 1), _rng.randi_range(0, GRID_SIZE - 1))
		if forbidden.has(c) or obstacles.has(c):
			continue
		obstacles[c] = "tree" if _rng.randf() < 0.55 else "rock"
		if not _all_free_connected():
			obstacles.erase(c)


func _all_free_connected() -> bool:
	var start: Vector2i = PLAYER_SPAWNS[0]
	var seen: Dictionary = {start: true}
	var queue: Array[Vector2i] = [start]
	while not queue.is_empty():
		var cur: Vector2i = queue.pop_front()
		for d: Vector2i in Combat.DIRS:
			var n: Vector2i = cur + d
			if _in_bounds(n) and not obstacles.has(n) and not seen.has(n):
				seen[n] = true
				queue.append(n)
	return seen.size() == GRID_SIZE * GRID_SIZE - obstacles.size()


func _in_bounds(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < GRID_SIZE and pos.y >= 0 and pos.y < GRID_SIZE


func _is_valid(pos: Vector2i) -> bool:
	return _in_bounds(pos)


func is_free(pos: Vector2i) -> bool:
	return _in_bounds(pos) and grid[pos.y][pos.x] == null and not obstacles.has(pos)


func entity_at(pos: Vector2i) -> Dictionary:
	if not _in_bounds(pos):
		return {}
	var v = grid[pos.y][pos.x]
	if v == null:
		return {}
	return v


func pos_of(e: Dictionary) -> Vector2i:
	return Vector2i(int(e.get("x", 0)), int(e.get("y", 0)))


func is_alive(e: Dictionary) -> bool:
	return not e.is_empty() and int(e.get("current_pv", 0)) > 0 and not e.get("dead", false)


func _new_uid() -> int:
	_uid_counter += 1
	return _uid_counter


func _base_entity(ename: String, etype: String, team: String, classe: String, level: int, pos: Vector2i) -> Dictionary:
	return {
		"uid": _new_uid(), "name": ename, "entity_type": etype, "team": team,
		"classe": classe, "level": level, "x": pos.x, "y": pos.y,
		"spells": [], "statuses": [], "casts": {}, "is_active": false, "dead": false,
		"facing": Vector2i(1, 0) if team == "player" else Vector2i(-1, 0),
		"lifetime": -1, "fly": false,
	}


func init_entities() -> void:
	players = []
	enemies = []
	summons = []
	graveyard = []
	traps = []

	var player_classes: Array = []
	if custom_team.size() == 3:
		for m: Dictionary in custom_team:
			player_classes.append(m["classe"])
	else:
		player_classes = ["Tank", "Assassin", "Mage"]

	var classes_data: Array = get_classes_data()

	for i: int in range(player_classes.size()):
		var classe: String = player_classes[i]
		var pos: Vector2i = PLAYER_SPAWNS[i]
		var st: Dictionary = {}
		if custom_team.size() == 3:
			st = _stats_from_custom(custom_team[i], classe)
		else:
			st = _stats_from_csv(classes_data, classe)
			if st.is_empty():
				push_error("Classe '%s' introuvable dans classes.txt" % classe)
				continue
		var player: Dictionary = _base_entity("%s Lv%d" % [classe, DEFAULT_PLAYER_LEVEL], "Player", "player",
			classe, DEFAULT_PLAYER_LEVEL, pos)
		player.merge({
			"max_pv": st["max_pv"], "current_pv": st["max_pv"],
			"force": st["force"], "intelligence": st["intelligence"],
			"agility": st["agility"], "wisdom": st["wisdom"], "defense": st["defense"],
			"max_pa": st["pa"], "current_pa": st["pa"], "max_pm": st["pm"], "current_pm": st["pm"],
			"color": st["color"],
		}, true)
		player["spells"] = _build_spells(classe)
		players.append(player)
		grid[pos.y][pos.x] = player

	# ── Ennemis : 3 types fixes + 1 type aléatoire ─────────────────────────
	var enemy_types: Array[String] = ["Gobelin", "Squelette", "Loup", "Troll" if _rng.randf() < 0.5 else "Dragonnet"]
	var enemies_data: Array = get_enemies_data()
	for i: int in range(enemy_types.size()):
		var etype: String = enemy_types[i]
		var pos: Vector2i = ENEMY_SPAWNS[i]
		var info: Dictionary = _find_best_match(enemies_data, "Type", etype, "Niveau", DEFAULT_ENEMY_LEVEL)
		if info.is_empty():
			push_error("Ennemi '%s' introuvable dans ennemis.txt" % etype)
			continue
		var pv: int = int(float(_csv_int(info, "PV", 50)) * ENEMY_HP_MULT)
		var atk: int = _csv_int(info, "Attaque", 10)
		var enemy: Dictionary = _base_entity("%s Lv%d" % [etype, DEFAULT_ENEMY_LEVEL], "Enemy", "enemy",
			etype, DEFAULT_ENEMY_LEVEL, pos)
		enemy.merge({
			"max_pv": pv, "current_pv": pv,
			"force": atk, "intelligence": atk, "agility": atk / 2.0, "wisdom": 0,
			"defense": _csv_int(info, "Défense", 5),
			"max_pa": _csv_int(info, "PA", 3), "current_pa": _csv_int(info, "PA", 3),
			"max_pm": _csv_int(info, "PM", 2), "current_pm": _csv_int(info, "PM", 2),
			"color": COLORS.get(etype, Color(0.8, 0.3, 0.3)),
		}, true)
		enemy["spells"] = Combat.enemy_spells(etype, atk)
		if etype == "Troll":
			Combat.add_status(enemy, "regen", 999, 5.0)
		if etype == "Dragonnet":
			enemy["fly"] = true
		enemies.append(enemy)
		grid[pos.y][pos.x] = enemy


func _stats_from_custom(m: Dictionary, classe: String) -> Dictionary:
	return {
		"max_pv": int(m.get("max_pv", 200)),
		"force": int(m.get("force", 10)),
		"intelligence": int(m.get("intelligence", 10)),
		"agility": int(m.get("agilite", m.get("agility", 10))),
		"wisdom": int(m.get("sagesse", m.get("wisdom", 10))),
		"defense": int(m.get("defense", 10)),
		"pa": int(m.get("pa", m.get("max_pa", 6))),
		"pm": int(m.get("pm", m.get("max_pm", 3))),
		"color": m.get("color", COLORS.get(classe, Color(1, 1, 1))),
	}


func _stats_from_csv(classes_data: Array, classe: String) -> Dictionary:
	var ci: Dictionary = _find_best_match(classes_data, "Classe", classe, "Niveau", DEFAULT_PLAYER_LEVEL)
	if ci.is_empty():
		return {}
	return {
		"max_pv": _csv_int(ci, "Vita (PV)", 60),
		"force": _csv_int(ci, "Force (CAC)", 10),
		"intelligence": _csv_int(ci, "Intelligence (Magie)", 10),
		"agility": _csv_int(ci, "Agilité (Vit. Atk)", 10),
		"wisdom": _csv_int(ci, "Sagesse (Précision)", 10),
		"defense": _csv_int(ci, "Défense", 10),
		"pa": _csv_int(ci, "PA", 5),
		"pm": _csv_int(ci, "PM", 3),
		"color": COLORS.get(classe, Color(1, 1, 1)),
	}


func _build_spells(classe: String) -> Array:
	var out: Array = []
	var spells_data: Array = get_spells_data()
	for pass_idx: int in range(2):
		var wanted: String = classe if pass_idx == 0 else "Druide"   # classe sans sorts → sorts de soutien
		for info: Dictionary in spells_data:
			if info.get("Classe", "") != wanted:
				continue
			var req_lvl: int = int(info.get("Niveau_requis", info.get("Niveau requis", "1")))
			if req_lvl > DEFAULT_PLAYER_LEVEL:
				continue
			out.append({
				"name": info.get("Nom", "Sort"),
				"classe": classe,
				"cost_pa": int(info.get("Cout_PA", info.get("Coût PA", "1"))),
				"cost_pm": int(info.get("Cout_PM", info.get("Coût PM", "0"))),
				"range": int(info.get("Portee", info.get("Portée", "1"))),
				"effect": info.get("Effet", ""),
				"level_required": req_lvl,
				"spell_type": info.get("Type", "Attaque"),
				"Degats_physiques": int(info.get("Degats_physiques", "0")),
				"Degats_magiques": int(info.get("Degats_magiques", "0")),
				"Soins": int(info.get("Soins", "0")),
				"Resistance_physique": int(info.get("Resistance_physique", "0")),
				"Resistance_magique": int(info.get("Resistance_magique", "0")),
				"Debuff_physique": int(info.get("Debuff_physique", "0")),
				"Debuff_magique": int(info.get("Debuff_magique", "0")),
				"Buff_physique": int(info.get("Buff_physique", "0")),
				"Buff_magique": int(info.get("Buff_magique", "0")),
			})
		if not out.is_empty():
			break
	return out


func _find_best_match(data_array: Array, key_col: String, key_val: String,
		level_col: String, target_level: int) -> Dictionary:
	var best: Dictionary = {}
	var best_lvl: int = -1
	for row: Dictionary in data_array:
		if row.get(key_col, "") != key_val:
			continue
		var lvl: int = int(row.get(level_col, "0"))
		if lvl <= target_level and lvl > best_lvl:
			best = row
			best_lvl = lvl
	return best


func _csv_int(row: Dictionary, col: String, default_val: int) -> int:
	return int(row.get(col, str(default_val)))


# ═══════════════════════════════════════════════════════════════════════════
#  Accès aux équipes
# ═══════════════════════════════════════════════════════════════════════════

func all_entities() -> Array:
	var out: Array = []
	for arr: Array in [players, enemies, summons]:
		for e: Dictionary in arr:
			if is_alive(e):
				out.append(e)
	return out


func entities_of_team(team: String) -> Array:
	var out: Array = []
	for e: Dictionary in all_entities():
		if e["team"] == team:
			out.append(e)
	return out


func enemies_of(e: Dictionary) -> Array:
	return entities_of_team("enemy" if e["team"] == "player" else "player")


func summons_of(owner: Dictionary) -> Array:
	var out: Array = []
	for s: Dictionary in summons:
		if is_alive(s) and int(s.get("owner", -1)) == int(owner["uid"]):
			out.append(s)
	return out


func hp_ratio(e: Dictionary) -> float:
	return float(e["current_pv"]) / maxf(1.0, float(e["max_pv"]))


# ═══════════════════════════════════════════════════════════════════════════
#  Déroulement du combat (initiative)
# ═══════════════════════════════════════════════════════════════════════════

func start_battle() -> void:
	_epoch += 1
	turn_count = 1
	_turn_index = -1
	active_entity = {}
	turn_order = all_entities()
	for e: Dictionary in turn_order:
		e["init"] = float(e.get("agility", 0)) + _rng.randf_range(-25.0, 25.0)
	turn_order.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return a["init"] > b["init"])
	message_requested.emit("Le combat commence !")
	fx.emit("banner", {"text": "Combat !"})
	advance_turn()


func advance_turn() -> void:
	if game_over:
		return
	var guard: int = 0
	while guard < 64:
		guard += 1
		if turn_order.is_empty():
			return
		_turn_index += 1
		if _turn_index >= turn_order.size():
			_turn_index = 0
			turn_count += 1
		var e: Dictionary = turn_order[_turn_index]
		if is_alive(e):
			_begin_turn(e)
			return


func _begin_turn(e: Dictionary) -> void:
	active_entity = e
	for x: Dictionary in all_entities():
		x["is_active"] = (int(x["uid"]) == int(e["uid"]))
	e["casts"] = {}

	var pa: int = int(e["max_pa"]) + int(Combat.status_value(e, "pa_up")) - int(Combat.status_value(e, "curse"))
	var pm: int = int(e["max_pm"]) + int(Combat.status_value(e, "pm_up")) - int(Combat.status_value(e, "slow"))
	if Combat.has_status(e, "root"):
		pm = 0
	e["current_pa"] = maxi(0, pa)
	e["current_pm"] = maxi(0, pm)

	# Effets de début de tour : dégâts sur la durée, régénération
	for s: Dictionary in e["statuses"].duplicate():
		match String(s["id"]):
			"poison", "bleed", "burn":
				var info: Dictionary = Combat.status_info(String(s["id"]))
				_apply_damage({}, e, int(s["value"]), "dot", false, false, true)
				fx.emit("status", {"target": e, "text": info["label"], "color": info["color"]})
			"regen":
				_do_heal({}, e, int(s["value"]))
	_check_deaths()
	if not is_alive(e) or game_over:
		active_entity = {}
		_end_turn_later(0.6)
		return

	var stunned: bool = Combat.has_status(e, "stun")
	if stunned:
		e["current_pa"] = 0
		e["current_pm"] = 0

	selected_spell = null
	selected_entity = e
	var controllable: bool = (e["entity_type"] == "Player") and not auto_mode
	current_turn = 0 if controllable else 1
	if e["entity_type"] == "Player":
		current_player_index = maxi(0, players.find(e))

	fx.emit("turn", {"entity": e})
	turn_started.emit(e)
	turn_changed.emit(current_turn)
	if e["entity_type"] == "Player":
		player_changed.emit(current_player_index)
	entity_selected.emit(e)
	spell_selected.emit(null)
	_refresh_grid()
	state_changed.emit()

	if stunned:
		message_requested.emit("%s est étourdi et passe son tour !" % e["name"])
		_end_turn_later(1.1)
	elif not controllable:
		ai_turn_requested.emit(e)


func _end_turn_later(delay: float) -> void:
	var ep: int = _epoch
	await get_tree().create_timer(delay).timeout
	if ep != _epoch or game_over:
		return
	if active_entity.is_empty():
		advance_turn()
	else:
		end_current_turn()


## Bouton « Fin du tour » (compatibilité : ancien nom)
func next_player() -> void:
	if game_over or current_turn != 0 or _grid_busy():
		return
	end_current_turn()


func end_current_turn() -> void:
	if game_over or active_entity.is_empty():
		return
	var e: Dictionary = active_entity
	var kept: Array = []
	for s: Dictionary in e["statuses"]:
		s["turns"] = int(s["turns"]) - 1
		if int(s["turns"]) > 0:
			kept.append(s)
	e["statuses"] = kept
	e["casts"] = {}
	e["is_active"] = false
	if int(e.get("lifetime", -1)) > 0:
		e["lifetime"] = int(e["lifetime"]) - 1
		if int(e["lifetime"]) == 0:
			e["current_pv"] = 0
			message_requested.emit("%s disparaît." % e["name"])
	active_entity = {}
	selected_spell = null
	spell_selected.emit(null)
	var ep: int = _epoch
	_check_deaths()
	state_changed.emit()
	await get_tree().create_timer(0.2).timeout
	if ep != _epoch or game_over:
		return
	advance_turn()


func set_auto(value: bool) -> void:
	auto_mode = value
	message_requested.emit("Combat automatique : %s" % ("activé" if value else "désactivé"))
	if value and current_turn == 0 and not active_entity.is_empty() and not game_over:
		current_turn = 1
		turn_changed.emit(current_turn)
		ai_turn_requested.emit(active_entity)
	state_changed.emit()


func _grid_busy() -> bool:
	var g: Node = get_node_or_null("/root/Main/GridManager")
	return g != null and g.has_method("is_busy") and g.is_busy()


func can_player_act() -> bool:
	return not game_over and current_turn == 0 and not active_entity.is_empty() and not _grid_busy()


# ═══════════════════════════════════════════════════════════════════════════
#  Déplacement
# ═══════════════════════════════════════════════════════════════════════════

## BFS : renvoie {"cost": {pos: n}, "prev": {pos: pos}}. max_cost < 0 → PM courants.
func compute_reach(e: Dictionary, max_cost: int = -1) -> Dictionary:
	var limit: int = int(e["current_pm"]) if max_cost < 0 else max_cost
	var start: Vector2i = pos_of(e)
	var cost: Dictionary = {start: 0}
	var prev: Dictionary = {}
	var queue: Array[Vector2i] = [start]
	var flies: bool = bool(e.get("fly", false))
	while not queue.is_empty():
		var cur: Vector2i = queue.pop_front()
		if int(cost[cur]) >= limit:
			continue
		for d: Vector2i in Combat.DIRS:
			var n: Vector2i = cur + d
			if cost.has(n) or not _in_bounds(n) or grid[n.y][n.x] != null:
				continue
			if obstacles.has(n) and not flies:
				continue
			cost[n] = int(cost[cur]) + 1
			prev[n] = cur
			queue.append(n)
	return {"cost": cost, "prev": prev}


func reach_path(reach: Dictionary, start: Vector2i, goal: Vector2i) -> Array[Vector2i]:
	var path: Array[Vector2i] = []
	if not reach["cost"].has(goal) or goal == start:
		return path
	var cur: Vector2i = goal
	var guard: int = 0
	while cur != start and guard < 200:
		guard += 1
		path.push_front(cur)
		cur = reach["prev"][cur]
	return path


func move_cells(e: Dictionary) -> Array[Vector2i]:
	var out: Array[Vector2i] = []
	var reach: Dictionary = compute_reach(e)
	var start: Vector2i = pos_of(e)
	for c: Vector2i in reach["cost"].keys():
		if c != start:
			out.append(c)
	return out


func try_move(e: Dictionary, cell: Vector2i) -> bool:
	if not is_alive(e) or game_over:
		return false
	var start: Vector2i = pos_of(e)
	var reach: Dictionary = compute_reach(e)
	var path: Array[Vector2i] = reach_path(reach, start, cell)
	if path.is_empty():
		if Combat.has_status(e, "root"):
			message_requested.emit("%s est immobilisé !" % e["name"])
		return false
	e["current_pm"] = int(e["current_pm"]) - path.size()
	grid[start.y][start.x] = null
	grid[cell.y][cell.x] = e
	e["x"] = cell.x
	e["y"] = cell.y
	var prev_cell: Vector2i = path[path.size() - 2] if path.size() > 1 else start
	e["facing"] = cell - prev_cell
	fx.emit("move", {"entity": e, "path": path, "from": start})
	entity_moved.emit(e, start, cell)
	_check_traps(e)
	_after_action()
	return true


func _check_traps(e: Dictionary) -> void:
	if not is_alive(e):
		return
	var p: Vector2i = pos_of(e)
	for t: Dictionary in traps.duplicate():
		if t["pos"] == p and t["team"] != e["team"]:
			traps.erase(t)
			fx.emit("trap_trigger", {"cell": p})
			message_requested.emit("%s déclenche un piège !" % e["name"])
			_apply_damage({}, e, int(t["dmg"]), "phys", false, false, true)


# ═══════════════════════════════════════════════════════════════════════════
#  Sorts : validation
# ═══════════════════════════════════════════════════════════════════════════

func can_afford(e: Dictionary, spell: Dictionary) -> bool:
	return int(e["current_pa"]) >= int(spell["cost_pa"]) and int(e["current_pm"]) >= int(spell.get("cost_pm", 0))


func casts_left(e: Dictionary, spell: Dictionary) -> int:
	return Combat.max_casts(spell) - int(e["casts"].get(spell["name"], 0))


func spell_range_cells(caster: Dictionary, spell: Dictionary) -> Array[Vector2i]:
	var p: Dictionary = Combat.parse(spell)
	var cpos: Vector2i = pos_of(caster)
	var out: Array[Vector2i] = []
	if p["target"] == "self":
		out.append(cpos)
		return out
	var rng: int = int(spell["range"])
	for dy: int in range(-rng, rng + 1):
		for dx: int in range(-rng, rng + 1):
			var d: int = absi(dx) + absi(dy)
			if d > rng or d < int(p["min_range"]):
				continue
			var c := Vector2i(cpos.x + dx, cpos.y + dy)
			if not _in_bounds(c):
				continue
			if p["needs_los"] and d > 1 and not Combat.has_los(cpos, c, obstacles):
				continue
			out.append(c)
	return out


## Retourne "" si le lancer est valide, sinon la raison de l'échec.
func validate_cast(caster: Dictionary, spell: Dictionary, cell: Vector2i) -> String:
	if not can_afford(caster, spell):
		return "Pas assez de PA/PM pour %s." % spell["name"]
	if casts_left(caster, spell) <= 0:
		return "%s ne peut plus être lancé ce tour." % spell["name"]
	var p: Dictionary = Combat.parse(spell)
	if not spell_range_cells(caster, spell).has(cell):
		return "Cible hors de portée ou sans ligne de vue."
	var t: Dictionary = entity_at(cell)
	var cpos: Vector2i = pos_of(caster)
	match String(p["target"]):
		"enemy":
			if t.is_empty() or t["team"] == caster["team"]:
				return "Il faut viser un ennemi."
			if Combat.has_status(t, "invisible") and Combat.manhattan(cpos, cell) > 1:
				return "Cible invisible."
		"ally":
			if t.is_empty() or t["team"] != caster["team"]:
				return "Il faut viser un allié."
		"free_cell":
			if not is_free(cell):
				return "La case doit être libre."
		"any_entity":
			if t.is_empty() or int(t["uid"]) == int(caster["uid"]):
				return "Il faut viser une créature."
	if p["cond"] == "exec_30" and not t.is_empty() and hp_ratio(t) >= 0.3:
		return "L'ennemi doit avoir moins de 30 % de PV."
	if p["needs_summon"] or p["buff_summons"]:
		if summons_of(caster).is_empty():
			return "Aucune invocation active."
	if p["kind"] == "summon" and summons_of(caster).size() >= 3:
		return "Trop d'invocations (3 max)."
	if p["kind"] == "revive" and graveyard.is_empty():
		return "Aucun allié à ressusciter."
	if p["kind"] == "teleport":
		if _teleport_landing(caster, p, cell) == Vector2i(-1, -1):
			return "Aucune case libre pour atterrir."
	return ""


## Cases affectées si on lance le sort sur `cell` (pour la prévisualisation).
func get_aoe_cells(caster: Dictionary, spell: Dictionary, cell: Vector2i) -> Array[Vector2i]:
	var p: Dictionary = Combat.parse(spell)
	var out: Array[Vector2i] = []
	var cpos: Vector2i = pos_of(caster)
	match String(p["aoe"]):
		"zone":
			out = Combat.zone_cells(cell, int(p["zone_r"]), String(p["zone_shape"]), GRID_SIZE)
		"adjacent_enemies":
			for d: Vector2i in Combat.DIRS:
				if _in_bounds(cpos + d):
					out.append(cpos + d)
		"enemies_in_range":
			for e: Dictionary in enemies_of(caster):
				if Combat.manhattan(cpos, pos_of(e)) <= int(spell["range"]):
					out.append(pos_of(e))
		"team":
			for e: Dictionary in entities_of_team(String(caster["team"])):
				out.append(pos_of(e))
		_:
			out.append(cell)
	return out


func estimate_damage(caster: Dictionary, spell: Dictionary, target: Dictionary) -> int:
	var p: Dictionary = Combat.parse(spell)
	var base: float = float(p["dmg"])
	if p["needs_summon"]:
		base = float(p["summon_dmg_base"]) + float(caster["level"]) * float(p["summon_dmg_lvl"])
	if base <= 0.0:
		return 0
	var r: Dictionary = Combat.calc_damage(caster, target, base, String(p["dtype"]), float(p["ignore_def"]), false, true)
	return int(r["dmg"])


# ═══════════════════════════════════════════════════════════════════════════
#  Sorts : résolution
# ═══════════════════════════════════════════════════════════════════════════

func cast_spell(caster: Dictionary, spell: Dictionary, cell: Vector2i) -> bool:
	if game_over or not is_alive(caster):
		return false
	var reason: String = validate_cast(caster, spell, cell)
	if reason != "":
		message_requested.emit(reason)
		fx.emit("error", {})
		return false

	var p: Dictionary = Combat.parse(spell)
	var cpos: Vector2i = pos_of(caster)
	caster["current_pa"] = int(caster["current_pa"]) - int(spell["cost_pa"])
	caster["current_pm"] = int(caster["current_pm"]) - int(spell.get("cost_pm", 0))
	caster["casts"][spell["name"]] = int(caster["casts"].get(spell["name"], 0)) + 1
	if cell != cpos:
		caster["facing"] = Combat.dir_to(cpos, cell)

	fx.emit("cast", {
		"caster": caster, "spell": spell["name"], "kind": p["kind"], "dtype": p["dtype"],
		"from": cpos, "to": cell, "ranged": Combat.manhattan(cpos, cell) > 1,
		"cells": get_aoe_cells(caster, spell, cell),
	})

	var target: Dictionary = entity_at(cell)
	var summary: String = ""
	match String(p["kind"]):
		"attack":
			summary = _resolve_attack(caster, spell, p, cell)
		"heal":
			summary = _resolve_heal(caster, spell, p, cell)
		"buff":
			summary = _resolve_buff(caster, spell, p, cell)
		"summon":
			summary = _resolve_summon(caster, spell, p, cell)
		"teleport":
			summary = _resolve_teleport(caster, spell, p, cell)
		"trap":
			traps.append({"pos": cell, "dmg": int(p["trap"]), "team": caster["team"], "owner": caster["uid"]})
			fx.emit("trap_set", {"cell": cell})
			summary = "%s pose un piège." % caster["name"]
		"revive":
			summary = _resolve_revive(caster, spell, p)

	if Combat.has_status(caster, "invisible") and p["kind"] == "attack":
		Combat.remove_status(caster, "invisible")
		fx.emit("status", {"target": caster, "text": "Révélé", "color": Color(0.9, 0.9, 1.0)})

	message_requested.emit(summary)
	spell_casted.emit(caster, spell, target, summary)
	_after_action()
	return true


func _attack_targets(caster: Dictionary, p: Dictionary, cell: Vector2i, spell: Dictionary) -> Array:
	var out: Array = []
	var cpos: Vector2i = pos_of(caster)
	match String(p["aoe"]):
		"zone":
			var cells: Array[Vector2i] = Combat.zone_cells(cell, int(p["zone_r"]), String(p["zone_shape"]), GRID_SIZE)
			for e: Dictionary in enemies_of(caster):
				if cells.has(pos_of(e)):
					out.append(e)
		"adjacent_enemies":
			for e: Dictionary in enemies_of(caster):
				if Combat.manhattan(cpos, pos_of(e)) == 1:
					out.append(e)
		"enemies_in_range":
			for e: Dictionary in enemies_of(caster):
				if Combat.manhattan(cpos, pos_of(e)) <= int(spell["range"]):
					out.append(e)
		_:
			var t: Dictionary = entity_at(cell)
			if not t.is_empty():
				out.append(t)
			var extra: int = int(p["chain"]) - 1
			var last: Vector2i = cell
			while extra > 0:
				var best: Dictionary = {}
				var best_d: int = 99
				for e: Dictionary in enemies_of(caster):
					var dd: int = Combat.manhattan(last, pos_of(e))
					if not out.has(e) and dd <= 3 and dd < best_d:
						best = e
						best_d = dd
				if best.is_empty():
					break
				out.append(best)
				last = pos_of(best)
				extra -= 1
	return out


func _resolve_attack(caster: Dictionary, spell: Dictionary, p: Dictionary, cell: Vector2i) -> String:
	var targets: Array = _attack_targets(caster, p, cell, spell)
	var base: float = float(p["dmg"])
	if p["needs_summon"]:
		base = float(p["summon_dmg_base"]) + float(caster["level"]) * float(p["summon_dmg_lvl"])
	var total: int = 0
	var names: Array[String] = []
	for t: Dictionary in targets:
		if not is_alive(t):
			continue
		total += _hit_target(caster, spell, p, t, base)
		names.append(String(t["name"]))
	for b: Dictionary in p["self_buffs"]:
		_apply_status(caster, caster, String(b["id"]), int(b["turns"]), float(b["value"]))
	if names.is_empty():
		return "%s lance %s." % [caster["name"], spell["name"]]
	if total > 0:
		return "%s lance %s : %d dégâts (%s)" % [caster["name"], spell["name"], total, ", ".join(names)]
	return "%s lance %s sur %s." % [caster["name"], spell["name"], ", ".join(names)]


func _hit_target(caster: Dictionary, spell: Dictionary, p: Dictionary, t: Dictionary, base: float) -> int:
	var dealt: int = 0
	var cpos: Vector2i = pos_of(caster)
	var tpos: Vector2i = pos_of(t)
	if base > 0.0:
		if p["cond"] == "kill_20" and hp_ratio(t) < 0.2:
			dealt = _apply_damage(caster, t, int(t["current_pv"]), String(p["dtype"]), true, false, true)
		else:
			var forced_crit: bool = p["cond"] == "back_crit" and Combat.is_behind(cpos, tpos, t["facing"])
			var r: Dictionary = Combat.calc_damage(caster, t, base, String(p["dtype"]),
				float(p["ignore_def"]), forced_crit, false)
			dealt = _apply_damage(caster, t, int(r["dmg"]), String(p["dtype"]), bool(r["crit"]), bool(r["back"]))
		if Combat.has_status(caster, "mark"):
			Combat.remove_status(caster, "mark")
	if int(t["current_pv"]) <= 0:
		return dealt
	if int(p["stun_turns"]) > 0 and _rng.randf() * 100.0 < float(p["stun_chance"]):
		_apply_status(caster, t, "stun", int(p["stun_turns"]), 1.0)
	for d: Dictionary in p["dots"]:
		_apply_status(caster, t, String(d["id"]), int(d["turns"]), float(d["value"]))
	for d: Dictionary in p["debuffs"]:
		var v: float = float(d["value"])
		if d["id"] == "taunted":
			v = float(caster["uid"])
		_apply_status(caster, t, String(d["id"]), int(d["turns"]), v)
	if int(p["push"]) > 0 and int(t["current_pv"]) > 0:
		_push(caster, t, int(p["push"]))
	return dealt


## Applique des dégâts ; renvoie la valeur réellement infligée.
func _apply_damage(attacker: Dictionary, tgt: Dictionary, dmg: int, dtype: String,
		crit: bool, back: bool, ignore_dodge: bool = false) -> int:
	if not is_alive(tgt):
		return 0
	if Combat.has_status(tgt, "immune") or (dtype == "phys" and Combat.has_status(tgt, "immune_phys")) \
			or (dtype == "mag" and Combat.has_status(tgt, "immune_mag")):
		fx.emit("status", {"target": tgt, "text": "Immunisé", "color": Color(1, 1, 0.7)})
		return 0
	if not ignore_dodge and dtype == "phys" and Combat.has_status(tgt, "dodge"):
		if _rng.randf() * 100.0 < Combat.status_value(tgt, "dodge"):
			fx.emit("status", {"target": tgt, "text": "Esquive !", "color": Color(0.7, 0.95, 0.5)})
			return 0
	tgt["current_pv"] = int(tgt["current_pv"]) - dmg
	fx.emit("damage", {
		"target": tgt, "attacker": attacker, "amount": dmg, "dtype": dtype, "crit": crit, "back": back,
		"pv_after": maxi(0, int(tgt["current_pv"])),
	})
	if not attacker.is_empty():
		entity_attacked.emit(attacker, tgt, dmg)
	return dmg


func _apply_status(_src: Dictionary, tgt: Dictionary, id: String, turns: int, value: float) -> void:
	if not is_alive(tgt):
		return
	var info: Dictionary = Combat.status_info(id)
	if Combat.NEGATIVE.has(id):
		if Combat.has_status(tgt, "immune_neg") or Combat.has_status(tgt, "immune"):
			fx.emit("status", {"target": tgt, "text": "Résiste", "color": Color(0.8, 1.0, 0.8)})
			return
	var t: int = turns
	var is_active_target: bool = not active_entity.is_empty() and int(tgt["uid"]) == int(active_entity["uid"])
	if is_active_target:
		t += 1    # survit à la fin du tour en cours
	Combat.add_status(tgt, id, t, value)
	if is_active_target:
		if id == "pa_up":
			tgt["current_pa"] = int(tgt["current_pa"]) + int(value)
		elif id == "pm_up":
			tgt["current_pm"] = int(tgt["current_pm"]) + int(value)
		elif id == "curse":
			tgt["current_pa"] = maxi(0, int(tgt["current_pa"]) - int(value))
		elif id == "slow":
			tgt["current_pm"] = maxi(0, int(tgt["current_pm"]) - int(value))
		elif id == "root":
			tgt["current_pm"] = 0
		elif id == "stun":
			tgt["current_pa"] = 0
			tgt["current_pm"] = 0
	var text: String = String(info["label"])
	if id in ["def_up", "mres_up", "dmg_up"]:
		text = "%s %d%%" % [text, int(value)]
	fx.emit("status", {"target": tgt, "text": text, "color": info["color"], "good": not Combat.NEGATIVE.has(id)})


func _do_heal(_caster: Dictionary, tgt: Dictionary, amount: int) -> int:
	if not is_alive(tgt) or amount <= 0:
		return 0
	var real: int = mini(amount, int(tgt["max_pv"]) - int(tgt["current_pv"]))
	if real <= 0:
		return 0
	tgt["current_pv"] = int(tgt["current_pv"]) + real
	fx.emit("heal", {"target": tgt, "amount": real, "pv_after": int(tgt["current_pv"])})
	return real


func _resolve_heal(caster: Dictionary, spell: Dictionary, p: Dictionary, cell: Vector2i) -> String:
	var targets: Array = []
	if p["aoe"] == "team":
		targets = entities_of_team(String(caster["team"]))
	else:
		var t0: Dictionary = entity_at(cell)
		if not t0.is_empty():
			targets.append(t0)
	var total: int = 0
	var names: Array[String] = []
	for t: Dictionary in targets:
		var amt: int = 0
		if int(p["heal"]) > 0:
			amt = roundi(float(p["heal"]) * (1.0 + float(caster.get("intelligence", 0)) / 300.0))
		if int(p["heal_pct"]) > 0:
			amt = roundi(float(t["max_pv"]) * float(p["heal_pct"]) / 100.0)
		total += _do_heal(caster, t, amt)
		names.append(String(t["name"]))
		if p["cure"]:
			if Combat.cure_negative(t) > 0:
				fx.emit("status", {"target": t, "text": "Purifié", "color": Color(0.8, 1, 0.8), "good": true})
		for b: Dictionary in p["buffs"]:
			_apply_status(caster, t, String(b["id"]), int(b["turns"]), float(b["value"]))
		if int(p["adj_dmg"]) > 0 or p["dots"].size() > 0:
			for e: Dictionary in enemies_of(caster):
				if Combat.manhattan(pos_of(t), pos_of(e)) == 1:
					if int(p["adj_dmg"]) > 0:
						var r: Dictionary = Combat.calc_damage(caster, e, float(p["adj_dmg"]), "mag", 0.0, false, false)
						_apply_damage(caster, e, int(r["dmg"]), "mag", bool(r["crit"]), false)
					for d: Dictionary in p["dots"]:
						_apply_status(caster, e, String(d["id"]), int(d["turns"]), float(d["value"]))
	for b: Dictionary in p["self_buffs"]:
		_apply_status(caster, caster, String(b["id"]), int(b["turns"]), float(b["value"]))
	if names.is_empty():
		return "%s lance %s." % [caster["name"], spell["name"]]
	return "%s lance %s : +%d PV (%s)" % [caster["name"], spell["name"], total, ", ".join(names)]


func _resolve_buff(caster: Dictionary, spell: Dictionary, p: Dictionary, cell: Vector2i) -> String:
	var targets: Array = []
	if p["buff_summons"]:
		targets = summons_of(caster)
	elif p["aoe"] == "team":
		targets = entities_of_team(String(caster["team"]))
	elif p["target"] == "ally":
		var t0: Dictionary = entity_at(cell)
		if not t0.is_empty():
			targets.append(t0)
	else:
		targets.append(caster)
	var names: Array[String] = []
	for t: Dictionary in targets:
		names.append(String(t["name"]))
		for b: Dictionary in p["buffs"]:
			_apply_status(caster, t, String(b["id"]), int(b["turns"]), float(b["value"]))
		if p["cure"]:
			Combat.cure_negative(t)
			fx.emit("status", {"target": t, "text": "Purifié", "color": Color(0.8, 1, 0.8), "good": true})
	return "%s lance %s (%s)" % [caster["name"], spell["name"], ", ".join(names)]


func _resolve_summon(caster: Dictionary, _spell: Dictionary, p: Dictionary, cell: Vector2i) -> String:
	var sname: String = String(p["summon"])
	var info: Dictionary = Combat.SUMMONS.get(sname, Combat.SUMMONS["Loup"])
	var s: Dictionary = _base_entity("%s (inv.)" % sname, "Summon", String(caster["team"]), sname,
		int(caster["level"]), cell)
	var scale: float = 0.7 + float(caster["level"]) / 200.0
	s.merge({
		"max_pv": int(float(info["pv"]) * scale), "current_pv": int(float(info["pv"]) * scale),
		"force": int(float(info["force"]) * scale), "intelligence": int(float(info["force"]) * scale),
		"agility": info["agility"], "wisdom": 20, "defense": info["defense"],
		"max_pa": info["pa"], "current_pa": 0, "max_pm": info["pm"], "current_pm": 0,
		"color": info["color"], "owner": caster["uid"],
		"lifetime": int(p["summon_turns"]),
		"facing": caster["facing"],
	}, true)
	s["spells"] = Combat.summon_spells(sname)
	s["init"] = float(caster.get("init", 0.0)) - 0.01
	summons.append(s)
	grid[cell.y][cell.x] = s
	var idx: int = turn_order.find(caster)
	if idx >= 0:
		turn_order.insert(idx + 1, s)
	else:
		turn_order.append(s)
	fx.emit("summon", {"entity": s})
	return "%s invoque %s !" % [caster["name"], sname]


func _resolve_revive(caster: Dictionary, _spell: Dictionary, p: Dictionary) -> String:
	var dead: Dictionary = graveyard.pop_back()
	var spot := Vector2i(-1, -1)
	var cpos: Vector2i = pos_of(caster)
	var best: int = 99
	for y: int in range(GRID_SIZE):
		for x: int in range(GRID_SIZE):
			var c := Vector2i(x, y)
			if is_free(c) and Combat.manhattan(c, cpos) < best:
				best = Combat.manhattan(c, cpos)
				spot = c
	if spot == Vector2i(-1, -1):
		graveyard.append(dead)
		return "Pas de place pour ressusciter."
	dead["dead"] = false
	dead["current_pv"] = mini(int(dead["max_pv"]), int(p["heal"]))
	dead["statuses"] = []
	dead["x"] = spot.x
	dead["y"] = spot.y
	players.append(dead)
	grid[spot.y][spot.x] = dead
	var idx: int = turn_order.find(caster)
	turn_order.insert(idx + 1 if idx >= 0 else turn_order.size(), dead)
	fx.emit("summon", {"entity": dead})
	return "%s ressuscite %s !" % [caster["name"], dead["name"]]


# ── Téléportation ──────────────────────────────────────────────────────────

func _teleport_landing(caster: Dictionary, p: Dictionary, cell: Vector2i) -> Vector2i:
	var cpos: Vector2i = pos_of(caster)
	match String(p["tele"]):
		"group":
			return cell if is_free(cell) else Vector2i(-1, -1)
		"behind":
			var behind: Vector2i = cell + Combat.dir_to(cpos, cell)
			if is_free(behind):
				return behind
	var best := Vector2i(-1, -1)
	var bd: int = 99
	for d: Vector2i in Combat.DIRS:
		var c: Vector2i = cell + d
		if is_free(c) and Combat.manhattan(c, cpos) < bd:
			best = c
			bd = Combat.manhattan(c, cpos)
	return best


func _teleport_entity(e: Dictionary, to: Vector2i) -> void:
	var from: Vector2i = pos_of(e)
	grid[from.y][from.x] = null
	grid[to.y][to.x] = e
	e["x"] = to.x
	e["y"] = to.y
	fx.emit("teleport", {"entity": e, "from": from, "to": to})
	entity_moved.emit(e, from, to)
	_check_traps(e)


func _resolve_teleport(caster: Dictionary, _spell: Dictionary, p: Dictionary, cell: Vector2i) -> String:
	var landing: Vector2i = _teleport_landing(caster, p, cell)
	if p["tele"] == "group":
		var cells: Array[Vector2i] = []
		for y: int in range(GRID_SIZE):
			for x: int in range(GRID_SIZE):
				var c := Vector2i(x, y)
				if is_free(c):
					cells.append(c)
		cells.sort_custom(func(a: Vector2i, b: Vector2i) -> bool: return Combat.manhattan(a, landing) < Combat.manhattan(b, landing))
		var allies: Array = entities_of_team(String(caster["team"]))
		for a: Dictionary in allies:
			for c: Vector2i in cells:
				if is_free(c):
					_teleport_entity(a, c)
					break
		return "%s téléporte l'équipe !" % caster["name"]
	caster["facing"] = Combat.dir_to(landing, cell)
	_teleport_entity(caster, landing)
	return "%s se téléporte !" % caster["name"]


# ── Poussée ────────────────────────────────────────────────────────────────

func _push(caster: Dictionary, tgt: Dictionary, n: int) -> void:
	var dir: Vector2i = Combat.dir_to(pos_of(caster), pos_of(tgt))
	if dir == Vector2i.ZERO:
		return
	var path: Array[Vector2i] = []
	var collided: bool = false
	var coll_dmg: int = 0
	var other: Dictionary = {}
	for i: int in range(n):
		var nxt: Vector2i = pos_of(tgt) + dir * (path.size() + 1)
		if not _in_bounds(nxt) or obstacles.has(nxt) or grid[nxt.y][nxt.x] != null:
			collided = true
			coll_dmg = 15 * (n - i) + int(float(caster["level"]) / 3.0)
			if _in_bounds(nxt):
				other = entity_at(nxt)
			break
		path.append(nxt)
	var from: Vector2i = pos_of(tgt)
	if not path.is_empty():
		var dest: Vector2i = path[path.size() - 1]
		grid[from.y][from.x] = null
		grid[dest.y][dest.x] = tgt
		tgt["x"] = dest.x
		tgt["y"] = dest.y
	if not path.is_empty() or collided:
		fx.emit("push", {"entity": tgt, "path": path, "from": from, "collided": collided, "dir": dir})
	if collided and coll_dmg > 0:
		_apply_damage(caster, tgt, coll_dmg, "fall", false, false, true)
		if not other.is_empty():
			_apply_damage(caster, other, coll_dmg, "fall", false, false, true)
	if not path.is_empty():
		_check_traps(tgt)


# ═══════════════════════════════════════════════════════════════════════════
#  Morts, fin de partie
# ═══════════════════════════════════════════════════════════════════════════

func _check_deaths() -> void:
	var dead: Array = []
	for arr: Array in [players, enemies, summons]:
		for x: Dictionary in arr:
			if int(x["current_pv"]) <= 0 and not x.get("dead", false):
				dead.append(x)
	for x: Dictionary in dead:
		x["dead"] = true
		x["current_pv"] = 0
		x["is_active"] = false
		var p: Vector2i = pos_of(x)
		if _in_bounds(p) and grid[p.y][p.x] == x:
			grid[p.y][p.x] = null
		players.erase(x)
		enemies.erase(x)
		summons.erase(x)
		var idx: int = turn_order.find(x)
		if idx >= 0:
			turn_order.remove_at(idx)
			if idx <= _turn_index:
				_turn_index -= 1
		if x["entity_type"] == "Player":
			graveyard.append(x)
		fx.emit("death", {"entity": x})
		if x["team"] == "enemy":
			message_requested.emit("%s est vaincu !" % x["name"])
		else:
			message_requested.emit("%s est tombé !" % x["name"])
	if not dead.is_empty():
		check_game_over()
		if not game_over and not active_entity.is_empty() and not is_alive(active_entity):
			active_entity = {}


func remove_entity_from_grid(entity: Dictionary) -> void:
	entity["current_pv"] = 0
	_check_deaths()
	_refresh_grid()


func check_game_over() -> void:
	if game_over:
		return
	var alive_p: int = 0
	for p: Dictionary in players:
		if is_alive(p):
			alive_p += 1
	var alive_e: int = 0
	for e: Dictionary in enemies:
		if is_alive(e):
			alive_e += 1
	if alive_p == 0:
		game_over = true
		victory = false
		game_ended.emit(false)
		message_requested.emit("Tous vos personnages sont tombés. DÉFAITE !")
	elif alive_e == 0:
		game_over = true
		victory = true
		game_ended.emit(true)
		message_requested.emit("Tous les ennemis sont vaincus ! VICTOIRE !")


func _after_action() -> void:
	_check_deaths()
	_refresh_grid()
	state_changed.emit()
	# Si l'entité active est morte (piège, collision...), on enchaîne
	if not game_over and active_entity.is_empty():
		_end_turn_later(0.8)


func reset_game() -> void:
	_epoch += 1
	game_over = false
	victory = false
	selected_spell = null
	selected_entity = null
	current_turn = 0
	current_player_index = 0
	turn_count = 1
	active_entity = {}
	var ui_manager: Node = get_node_or_null("/root/Main/UIManager")
	if ui_manager and ui_manager.has_method("hide_game_over_panel"):
		ui_manager.hide_game_over_panel()
	init_grid()
	init_entities()
	_refresh_grid()
	start_battle()


func _refresh_grid() -> void:
	var gm: Node = get_node_or_null("/root/Main/GridManager")
	if gm == null:
		return
	if not ("game_manager" in gm) or gm.game_manager == null:
		return
	gm.update_entity_display()


# ═══════════════════════════════════════════════════════════════════════════
#  Actions du joueur (entrées UI)
# ═══════════════════════════════════════════════════════════════════════════

func handle_cell_selected(x: int, y: int) -> void:
	if not can_player_act():
		return
	var e: Dictionary = active_entity
	var cell := Vector2i(x, y)
	selected_cell = cell
	if selected_spell != null:
		var spell: Dictionary = selected_spell
		var ok: bool = cast_spell(e, spell, cell)
		if ok:
			if not can_afford(e, spell) or casts_left(e, spell) <= 0:
				selected_spell = null
			spell_selected.emit(selected_spell)
		return
	if is_free(cell):
		if not try_move(e, cell):
			message_requested.emit("Case hors de portée de déplacement.")
			fx.emit("error", {})
	else:
		var t: Dictionary = entity_at(cell)
		if not t.is_empty():
			entity_selected.emit(t)
			message_requested.emit("Choisissez un sort pour agir sur %s." % t["name"])


func handle_spell_selected(spell: Dictionary) -> void:
	if not can_player_act():
		return
	var e: Dictionary = active_entity
	if selected_spell != null and selected_spell["name"] == spell["name"]:
		var p: Dictionary = Combat.parse(spell)
		if p["target"] == "self" and can_afford(e, spell):
			if cast_spell(e, spell, pos_of(e)):
				if not can_afford(e, spell) or casts_left(e, spell) <= 0:
					selected_spell = null
				spell_selected.emit(selected_spell)
			return
		selected_spell = null
		message_requested.emit("Sort annulé.")
	else:
		if not can_afford(e, spell):
			message_requested.emit("Pas assez de PA pour %s." % spell["name"])
			fx.emit("error", {})
			return
		if casts_left(e, spell) <= 0:
			message_requested.emit("%s ne peut plus être lancé ce tour." % spell["name"])
			fx.emit("error", {})
			return
		selected_spell = spell
		fx.emit("click", {})
	spell_selected.emit(selected_spell)
