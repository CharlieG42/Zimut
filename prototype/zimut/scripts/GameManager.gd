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

const DEFAULT_PLAYER_LEVEL := 20
const DEFAULT_ENEMY_LEVEL  := 20
## Niveau des persos en « combat rapide » (sans partie sauvegardée)
const QUICK_PLAYER_LEVEL   := 20
## Niveau des ennemis : celui de la partie active (progression), sinon défaut.

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
	"Sylvain":    Color(0.35, 0.65, 0.25),
	"Géomancien": Color(0.85, 0.62, 0.25),
	"Gobelin":   Color(0.5, 0.8, 0.3),
	"Squelette": Color(0.8, 0.8, 0.8),
	"Loup":      Color(0.6, 0.6, 0.4),
	"Troll":     Color(0.45, 0.6, 0.35),
	"Dragonnet": Color(0.9, 0.35, 0.2),
}

## Équilibrage des ennemis (valeurs de ennemis.txt x multiplicateurs).
## Le capital de caractéristiques et l'équipement rendent l'équipe plus forte que la
## table de base : les ennemis gagnent ENEMY_LEVEL_SCALE par niveau au-dessus de 10.
const ENEMY_HP_MULT := 3.0
## V16 : 2.0 -> 1.7 pour compenser les sorts des héros / 1,5 (combats plus longs, même difficulté
## en simulation : tests/sim_balance.gd)
const ENEMY_ATK_MULT := 1.5
const ENEMY_LEVEL_SCALE := 0.0   ## le facteur de niveau est cuit dans ennemis.txt (V15)
const BOSS_HP_MULT := 1.2
const BOSS_ATK_MULT := 0.85
## Enrage : au-delà de ce tour, les ennemis frappent +10 % par tour supplémentaire
## (évite les combats interminables).
const ENRAGE_AFTER_TURN := 14

var grid: Array                  = []
var obstacles: Dictionary        = {}   # Vector2i -> "tree" | "rock"
var traps: Array                 = []   # {pos, dmg, team, owner}
var glyphs: Array                = []   # V19 : {name, cells, team, owner, turns, foes, allies, snap, last, element}
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
var active_save: Dictionary      = {}   # sauvegarde ProgressionManager en cours
var active_slot: int             = -1
var menu_intent: String           = ""   # intention transmise à l’écran Parties (ex. nouvelle partie)
var fight_enemies: Array         = []   # [{type, level, boss}] du combat en cours (pour l'XP)
var fight_is_boss: bool          = false
var _last_banner_round: int = 0
var fight_biome: String          = "Forêt"  # biome du combat en cours

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
	# Les positions de départ seront tirées parmi toutes les cases libres :
	# les équipes peuvent donc être mélangées sur l'ensemble du plateau.
	# La forêt garde des couloirs de déplacement plus lisibles : moins d’obstacles décoratifs.
	var wanted: int = _rng.randi_range(5, 7) if fight_biome == "Forêt" else _rng.randi_range(6, 9)
	var tree_chance: float = 0.55
	match fight_biome:
		"Montagne":
			tree_chance = 0.25   # surtout des rochers
		"Désert":
			tree_chance = 0.45   # « tree » = cactus dessiné selon le biome (cf. Prop)
	var attempts: int = 0
	while obstacles.size() < wanted and attempts < 300:
		attempts += 1
		var c := Vector2i(_rng.randi_range(0, GRID_SIZE - 1), _rng.randi_range(0, GRID_SIZE - 1))
		if forbidden.has(c) or obstacles.has(c):
			continue
		obstacles[c] = "tree" if _rng.randf() < tree_chance else "rock"
		if not _all_free_connected():
			obstacles.erase(c)


func _all_free_connected() -> bool:
	var start := Vector2i(-1, -1)
	for y: int in range(GRID_SIZE):
		for x: int in range(GRID_SIZE):
			var candidate := Vector2i(x, y)
			if not obstacles.has(candidate):
				start = candidate
				break
		if start.x >= 0:
			break
	if start.x < 0:
		return false
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
		"lifetime": -1, "fly": false, "fx": {},
	}


## Tire des positions distinctes sur toutes les cases libres du plateau.
## Alliés et ennemis partagent le même espace de déploiement et peuvent être mêlés.
func _random_spawn_positions(count: int) -> Array[Vector2i]:
	var candidates: Array[Vector2i] = []
	for y: int in range(GRID_SIZE):
		for x: int in range(GRID_SIZE):
			var pos := Vector2i(x, y)
			if not obstacles.has(pos):
				candidates.append(pos)
	var positions: Array[Vector2i] = []
	while positions.size() < count and not candidates.is_empty():
		var idx: int = _rng.randi_range(0, candidates.size() - 1)
		positions.append(candidates[idx])
		candidates.remove_at(idx)
	return positions


func init_entities() -> void:
	players = []
	enemies = []
	summons = []
	graveyard = []
	traps = []
	glyphs = []

	var player_classes: Array = []
	if custom_team.size() == 3:
		for m: Dictionary in custom_team:
			player_classes.append(m["classe"])
	else:
		player_classes = ["Tank", "Assassin", "Mage"]

	var classes_data: Array = get_classes_data()
	var use_save: bool = not active_save.is_empty() and active_save.get("team", []).size() == player_classes.size()
	if use_save:
		for i: int in range(player_classes.size()):
			if String(active_save["team"][i].get("classe", "")) != String(player_classes[i]):
				use_save = false

	var bless: int = 0
	# Quatre ennemis sont prévus pour chaque combat ; on tire toutes les cases
	# en une seule fois pour garantir des positions uniques et des camps mélangés.
	var combat_spawn_positions: Array[Vector2i] = _random_spawn_positions(player_classes.size() + 4)
	var player_spawn_positions: Array[Vector2i] = combat_spawn_positions.slice(0, player_classes.size())
	for i: int in range(player_classes.size()):
		var classe: String = player_classes[i]
		var pos: Vector2i = player_spawn_positions[i]
		var st: Dictionary = {}
		var plevel: int = QUICK_PLAYER_LEVEL
		var pfx: Dictionary = {}
		if use_save:
			# Stats = classes.txt au niveau du perso + points investis + équipement/panoplies
			st = ProgressionManager.member_stats(active_save, active_save["team"][i])
			if not st.is_empty():
				plevel = int(st["level"])
				pfx = st["fx"]
				st["color"] = COLORS.get(classe, Color(1, 1, 1))
		if st.is_empty():
			st = _stats_from_csv(classes_data, classe, plevel)
			if st.is_empty():
				push_error("Classe '%s' introuvable dans classes.txt" % classe)
				continue
		var player: Dictionary = _base_entity("%s Lv%d" % [classe, plevel], "Player", "player",
			classe, plevel, pos)
		player.merge({
			"max_pv": int(st["max_pv"]), "current_pv": int(st["max_pv"]),
			"force": int(st["force"]), "intelligence": int(st["intelligence"]),
			"agility": int(st["agility"]), "wisdom": int(st["wisdom"]), "defense": int(st["defense"]),
			"max_pa": int(st["pa"]), "current_pa": int(st["pa"]), "max_pm": int(st["pm"]), "current_pm": int(st["pm"]),
			"color": st["color"], "fx": pfx,
		}, true)
		player["spells"] = _build_spells(classe, plevel)
		# Portée bonus du perso (points de caractéristiques + objets, plafonnée à 3)
		var po_bonus: int = int(st.get("po", 0))
		if po_bonus > 0:
			for s: Dictionary in player["spells"]:
				var sp: Dictionary = Combat.parse(s)
				if String(sp["target"]) != "self" and int(s["range"]) < 99:
					s["range"] = int(s["range"]) + po_bonus
		# Niveaux de sorts améliorés (1..10) : multiplicateur d'efficacité
		if not active_save.is_empty():
			for s: Dictionary in player["spells"]:
				var slvl: int = ProgressionManager.spell_level(active_save, classe, String(s["name"]))
				if slvl > 1:
					s["spell_level"] = slvl
					s["mult"] = 1.0 + (float(slvl) - 1.0) * ProgressionManager.SPELL_LEVEL_BONUS_PCT / 100.0
		# Effets d'objets actifs dès le début du combat
		if int(pfx.get("start_immune_neg", 0)) > 0:
			Combat.add_status(player, "immune_neg", int(pfx["start_immune_neg"]), 0.0)
		if int(pfx.get("start_immune", 0)) > 0:
			Combat.add_status(player, "immune", int(pfx["start_immune"]), 0.0)
		bless = maxi(bless, int(pfx.get("bless_def", 0)))
		players.append(player)
		grid[pos.y][pos.x] = player
	if bless > 0:
		for pl: Dictionary in players:
			Combat.add_status(pl, "def_up", 3, float(bless))

	# ── Ennemis du biome : boss + 3 sbires tous les 4 combats, sinon 4 ennemis ──
	var lvl: int = ProgressionManager.enemy_level_for(active_save) if not active_save.is_empty() else DEFAULT_ENEMY_LEVEL
	var conquest_tactic: String = ""
	# En Conquête, la difficulté suit la ville ciblée sans créer une seconde progression.
	if not active_save.is_empty() and String(active_save.get("campaign_mode", "")) == "conquest":
		var conquest: Dictionary = active_save.get("conquest", {})
		if String(conquest.get("pending_city", "")) != "":
			lvl = maxi(1, int(conquest.get("pending_level", lvl)))
			conquest_tactic = String(conquest.get("pending_tactic", "none"))
			if conquest_tactic == "scouts":
				lvl = maxi(1, lvl - 1)
	# En Aventure, le défi en cours (POI) fixe le niveau du combat : le
	# brouillard, les POI et les zones sont dans ProgressionManager/AdventureManager.
	if not active_save.is_empty() and String(active_save.get("campaign_mode", "")) == "adventure":
		var adv: Dictionary = active_save.get("adventure", {})
		if String(adv.get("pending_challenge", "")) != "":
			lvl = maxi(1, int(adv.get("pending_level", lvl)))
	fight_enemies = []
	fight_is_boss = false
	var boss_fight: bool = not active_save.is_empty() and ProgressionManager.is_boss_fight(active_save)
	fight_is_boss = boss_fight
	var campaign_mode: String = String(active_save.get("campaign_mode", "")) if not active_save.is_empty() else ""
	if campaign_mode in ["adventure", "conquest"]:
		boss_fight = false
		fight_is_boss = false
	# Conquête : siège d’une ville adverse — la 4e bataille oppose le boss
	# du biome ; les 3 premières des mobs de champs. Une ville neutre : 1 mobs.
	var conquest_siege_boss: bool = false
	if campaign_mode == "conquest" and not active_save.is_empty():
		var cqst: Dictionary = active_save.get("conquest", {})
		var target: String = String(cqst.get("pending_city", ""))
		if target != "" and ProgressionManager.conquest_siege_is_boss(cqst, target):
			conquest_siege_boss = true
			boss_fight = true
			fight_is_boss = true
	# Aventure : le biome du combat est celui de la zone explorée.
	if campaign_mode == "adventure" and not active_save.is_empty():
		fight_biome = ProgressionManager.adventure_zone_biome(
			String(active_save.get("adventure", {}).get("zone", "foret_sylve")))
	elif not active_save.is_empty():
		fight_biome = ProgressionManager.next_biome(active_save)
	else:
		fight_biome = "Forêt"
	# Conquête : le biome est celui de la ville ciblée (les Dunes opposent des
	# ennemis du désert, le Donjon des squelettes).
	if campaign_mode == "conquest" and not active_save.is_empty():
		var cqst_city: String = String(active_save.get("conquest", {}).get("pending_city", ""))
		if cqst_city != "":
			fight_biome = ProgressionManager.conquest_city_biome(cqst_city)
	# Donjon : chaque salle est un combat de boss ; la salle affiche le biome de
	# la salle (décor du biome) mais le boss est celui de la salle de donjon.
	var donjon_room: String = ""
	if not active_save.is_empty() and campaign_mode == "":
		donjon_room = ProgressionManager.donjon_room(ProgressionManager.next_fight_number(active_save))
		if donjon_room != "":
			fight_biome = donjon_room
			boss_fight = true
			fight_is_boss = true
	## Boss de fin de cycle : le boss est au niveau du combat, ses sbires 2 niveaux en dessous
	var minion_lvl: int = maxi(1, lvl - 2) if boss_fight else lvl
	var biome_types: Array[String] = ProgressionManager.biome_enemy_types(fight_biome)
	var enemy_types: Array[String] = []
	if boss_fight:
		enemy_types = [biome_types[0], biome_types[0], biome_types[1], "BOSS"]
	else:
		enemy_types = [biome_types[0], biome_types[1], biome_types[0] if _rng.randf() < 0.5 else biome_types[1],
			biome_types[1] if _rng.randf() < 0.5 else biome_types[0]]
	# Aventure : un groupe de monstres errant fixe le nombre d'ennemis (2 à 4).
	if campaign_mode == "adventure" and not active_save.is_empty() and not boss_fight:
		var adv_c: Dictionary = active_save.get("adventure", {})
		var cnt: int = int(adv_c.get("pending_count", 0))
		if String(adv_c.get("pending_challenge", "")) != "" and cnt >= 1 and cnt < enemy_types.size():
			enemy_types = enemy_types.slice(0, cnt)
	var enemies_data: Array = get_enemies_data()
	var enemy_spawn_positions: Array[Vector2i] = combat_spawn_positions.slice(player_classes.size(), player_classes.size() + enemy_types.size())
	for i: int in range(enemy_types.size()):
		var etype: String = enemy_types[i]
		var pos: Vector2i = enemy_spawn_positions[i]
		if etype == "BOSS":
			_spawn_boss(pos, lvl)
			continue
		var info: Dictionary = _find_best_match(enemies_data, "Type", etype, "Niveau", minion_lvl)
		if info.is_empty():
			info = _find_best_match(enemies_data, "Type", etype, "Niveau", 999)   # type qui débute plus haut (Troll, Dragonnet)
		if info.is_empty():
			push_error("Ennemi '%s' introuvable dans ennemis.txt" % etype)
			continue
		var lscale: float = 1.0 + float(maxi(0, lvl - 10)) * ENEMY_LEVEL_SCALE
		var settings: Node = get_node_or_null("/root/GameSettings")
		var hp_mult: float = settings.enemy_hp_mult(active_save) if settings != null else 1.0
		var atk_mult: float = settings.enemy_attack_mult(active_save) if settings != null else 1.0
		var hp_tactic_mult: float = 0.85 if conquest_tactic == "sabotage" else 1.0
		var atk_tactic_mult: float = 0.85 if conquest_tactic == "sabotage" else (0.90 if conquest_tactic == "supply" else 1.0)
		var pv: int = maxi(1, int(float(_csv_int(info, "PV", 50)) * ENEMY_HP_MULT * lscale * hp_mult * hp_tactic_mult))
		var atk: int = maxi(1, int(float(_csv_int(info, "Attaque", 10)) * ENEMY_ATK_MULT * lscale * atk_mult * atk_tactic_mult))
		var enemy: Dictionary = _base_entity("%s Lv%d" % [etype, minion_lvl], "Enemy", "enemy",
			etype, minion_lvl, pos)
		enemy.merge({
			"max_pv": pv, "current_pv": pv,
			"force": atk, "intelligence": atk, "agility": atk / 2.0, "wisdom": 0,
			"defense": _csv_int(info, "Défense", 5),
			"max_pa": _csv_int(info, "PA", 3), "current_pa": _csv_int(info, "PA", 3),
			"max_pm": _csv_int(info, "PM", 2), "current_pm": _csv_int(info, "PM", 2),
			"color": COLORS.get(etype, Color(0.8, 0.3, 0.3)),
		}, true)
		enemy["spells"] = Combat.enemy_spells(etype, atk)
		var nation_label: String = Nations.enemy_label(etype, fight_biome)
		if nation_label != "":
			enemy["name"] = "%s Lv%d" % [nation_label, minion_lvl]
		if etype == "Troll":
			Combat.add_status(enemy, "regen", 999, 5.0)
		if etype == "Dragonnet":
			enemy["fly"] = true
		fight_enemies.append({"type": etype, "level": minion_lvl, "boss": false})
		enemies.append(enemy)
		grid[pos.y][pos.x] = enemy

## Boss de fin de cycle : le boss nommé du biome (ennemies.txt, lignes « Boss »).
## PV x3, attaques x1.5, +1 PA/PM, vole (comme un Dragonnet), régénère.
func _spawn_boss(pos: Vector2i, lvl: int) -> void:
	var enemies_data: Array = get_enemies_data()
	var boss_name: String = ProgressionManager.biome_boss(fight_biome)
	if not active_save.is_empty() and String(active_save.get("campaign_mode", "")) == "" \
			and ProgressionManager.donjon_room(ProgressionManager.next_fight_number(active_save)) != "":
		boss_name = ProgressionManager.donjon_boss(active_save)
	# Conquête : l'assaut final du Donjon du Roi Squelette oppose le roi lui-même.
	if not active_save.is_empty() and String(active_save.get("campaign_mode", "")) == "conquest" \
			and String(active_save.get("conquest", {}).get("pending_city", "")) == "donjon_roi":
		boss_name = "Roi Squelette"
	## Type de base dont le boss reprend le kit et la skin : le nom complet est
	## « Boss Gobelin Roi » -> type de base « Gobelin » (2e mot).
	var base_type: String = String({"Gobelin Roi": "Gobelin", "Troll Géant": "Troll", "Dragon": "Dragonnet",
		"Squelette Seigneur": "Squelette", "Loup Alpha": "Loup", "Roi Squelette": "Squelette"}.get(boss_name, Nations.boss_base(boss_name) if Nations.boss_base(boss_name) != "" else "Dragonnet"))
	var info: Dictionary = _find_best_match(enemies_data, "Type", "Boss " + boss_name, "Niveau", lvl)
	if info.is_empty():
		# Aucune ligne boss au niveau du combat : prendre la ligne boss la plus proche
		# (première ligne de ce boss), sinon le type de base.
		for row: Dictionary in enemies_data:
			if String(row.get("Type", "")) == "Boss " + boss_name:
				info = row
				break
	if info.is_empty():
		info = _find_best_match(enemies_data, "Type", base_type, "Niveau", lvl)
	if info.is_empty():
		info = _find_best_match(enemies_data, "Type", base_type, "Niveau", 999)
	if info.is_empty():
		push_error("Boss '%s' introuvable dans ennemis.txt — boss remplacé par un Troll" % boss_name)
		info = _find_best_match(enemies_data, "Type", "Troll", "Niveau", lvl)
		base_type = "Troll"
		if info.is_empty():
			return
	var lscale: float = 1.0 + float(maxi(0, lvl - 10)) * ENEMY_LEVEL_SCALE
	var settings: Node = get_node_or_null("/root/GameSettings")
	var hp_mult: float = settings.enemy_hp_mult(active_save) if settings != null else 1.0
	var atk_mult: float = settings.enemy_attack_mult(active_save) if settings != null else 1.0
	var conquest_tactic: String = String(active_save.get("conquest", {}).get("pending_tactic", "none")) if not active_save.is_empty() and String(active_save.get("campaign_mode", "")) == "conquest" else "none"
	var hp_tactic_mult: float = 0.85 if conquest_tactic == "sabotage" else 1.0
	var atk_tactic_mult: float = 0.85 if conquest_tactic == "sabotage" else (0.90 if conquest_tactic == "supply" else 1.0)
	var pv: int = maxi(1, int(float(_csv_int(info, "PV", 120)) * ENEMY_HP_MULT * BOSS_HP_MULT * lscale * hp_mult * hp_tactic_mult))
	var atk: int = maxi(1, int(float(_csv_int(info, "Attaque", 20)) * ENEMY_ATK_MULT * BOSS_ATK_MULT * lscale * atk_mult * atk_tactic_mult))
	fight_enemies.append({"type": boss_name, "level": lvl, "boss": true})
	# V20 : le boss attitré du biome prend le nom et le portrait de la planche « Boss des Nations »
	var nation_boss: bool = boss_name == ProgressionManager.biome_boss(fight_biome) and Nations.boss_title(fight_biome) != ""
	var shown: String = Nations.boss_title(fight_biome) if nation_boss else boss_name
	var boss: Dictionary = _base_entity("☠ BOSS %s Lv%d" % [shown, lvl], "Enemy", "enemy", boss_name, lvl, pos)
	if nation_boss:
		boss["nation_boss"] = fight_biome
		boss["title"] = shown
	boss.merge({
		"max_pv": pv, "current_pv": pv,
		"force": atk, "intelligence": atk, "agility": atk / 2.0, "wisdom": 10,
		"defense": int(float(_csv_int(info, "Défense", 15)) * 1.5),
		"max_pa": _csv_int(info, "PA", 4) + 1, "current_pa": _csv_int(info, "PA", 4) + 1,
		"max_pm": _csv_int(info, "PM", 3) + 1, "current_pm": _csv_int(info, "PM", 3) + 1,
		"color": Color(0.9, 0.2, 0.1),
	}, true)
	boss["boss"] = true
	boss["spells"] = Combat.boss_spells(base_type, atk) + Combat.nation_boss_spells(boss_name, atk)
	boss["skin"] = base_type
	boss["fly"] = base_type == "Dragonnet"
	Combat.add_status(boss, "regen", 999, 8.0)
	# Kits spéciaux des boss nommés (Effets spéciaux de ennemis.txt)
	match boss_name:
		"Gobelin Roi":
			boss["fx"] = {"lifesteal": 5}
		"Loup Alpha":
			Combat.add_status(boss, "poison", 999, 10.0)
		"Troll Géant":
			boss["fx"] = {"mres": 50}
		"Dragon":
			boss["fx"] = {"mag_pct": 30}
		"Squelette Seigneur":
			boss["fx"] = {"crit": 20}
		"Roi Squelette":
			boss["fx"] = {"mres": 60, "lifesteal": 10}
			Combat.add_status(boss, "regen", 999, 15.0)
		"Golem Prismatique":
			boss["fx"] = {"mres": 50}
		"Crabe Titan":
			boss["fx"] = {"mres": 30}
			boss["defense"] = int(float(boss["defense"]) * 1.25)
		"Seigneur des Tempêtes":
			boss["fx"] = {"crit": 25}
			boss["fly"] = true
		"Seigneur de Lave":
			boss["fx"] = {"mag_pct": 30}
		"Liche des Brumes":
			boss["fx"] = {"lifesteal": 8}
		"Liche Éternelle":
			boss["fx"] = {"mres": 60, "lifesteal": 10}
			Combat.add_status(boss, "regen", 999, 12.0)
	enemies.append(boss)
	grid[pos.y][pos.x] = boss



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


func _stats_from_csv(classes_data: Array, classe: String, level: int = DEFAULT_PLAYER_LEVEL) -> Dictionary:
	var ci: Dictionary = _find_best_match(classes_data, "Classe", classe, "Niveau", level)
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


func _build_spells(classe: String, level: int = DEFAULT_PLAYER_LEVEL) -> Array:
	var out: Array = []
	var spells_data: Array = get_spells_data()
	for pass_idx: int in range(2):
		var wanted: String = classe if pass_idx == 0 else "Druide"   # classe sans sorts → sorts de soutien
		for info: Dictionary in spells_data:
			if info.get("Classe", "") != wanted:
				continue
			var req_lvl: int = int(info.get("Niveau_requis", info.get("Niveau requis", "1")))
			if req_lvl > level:
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
		if is_alive(s) and int(s.get("owner", -1)) == int(owner["uid"]) and not bool(s.get("terrain", false)) and not bool(s.get("beacon", false)):
			out.append(s)
	return out


# ═══════════════════════════════════════════════════════════════════════════
#  Glyphes (V19) : zones posées au sol qui agissent 2 à 4 tours
# ═══════════════════════════════════════════════════════════════════════════

const GLYPH_MAX_PER_CASTER := 2
var _glyph_seq: int = 0


## Glyphes actifs d'un lanceur (du plus ancien au plus récent).
func glyphs_of(owner: Dictionary) -> Array:
	var out: Array = []
	for g: Dictionary in glyphs:
		if int(g["owner"]) == int(owner["uid"]):
			out.append(g)
	return out


func glyph_at(cell: Vector2i) -> Array:
	var out: Array = []
	for g: Dictionary in glyphs:
		if (g["cells"] as Array).has(cell):
			out.append(g)
	return out


func _resolve_glyph(caster: Dictionary, spell: Dictionary, p: Dictionary, cell: Vector2i) -> String:
	var cells: Array[Vector2i] = []
	for c: Vector2i in Combat.zone_cells(cell, int(p["zone_r"]), String(p["zone_shape"]), GRID_SIZE):
		if not obstacles.has(c):
			cells.append(c)
	var mine: Array = glyphs_of(caster)
	while mine.size() >= GLYPH_MAX_PER_CASTER:
		glyphs.erase(mine[0])
		fx.emit("glyph_end", {"glyph": mine[0]})
		mine.remove_at(0)
	var snap: Dictionary = caster.duplicate(true)
	_glyph_seq += 1
	var g: Dictionary = {
		"id": _glyph_seq, "name": String(spell["name"]), "cells": cells, "team": String(caster["team"]), "owner": int(caster["uid"]),
		"turns": int(p["glyph_turns"]), "foes": p["glyph_foes"], "allies": p["glyph_allies"],
		"snap": snap, "last": {}, "center": cell,
		"element": SpellFx.element_for(String(spell["name"]), String(p["dtype"]), "glyph"),
	}
	glyphs.append(g)
	fx.emit("glyph_set", {"glyph": g, "caster": caster})
	# effet immédiat sur ceux qui se trouvent déjà dans la zone
	for e: Dictionary in all_entities():
		if is_alive(e) and cells.has(pos_of(e)):
			_glyph_apply(g, e)
	return "%s trace %s (%d tours)." % [caster["name"], spell["name"], int(g["turns"])]


## Applique les glyphes qui couvrent la case de `e` (une fois par créature et par tour de jeu).
func _glyph_tick(e: Dictionary) -> void:
	if glyphs.is_empty() or not is_alive(e) or bool(e.get("terrain", false)) or bool(e.get("beacon", false)):
		return
	var pos: Vector2i = pos_of(e)
	for g: Dictionary in glyphs.duplicate():
		if not is_alive(e):
			return
		if (g["cells"] as Array).has(pos):
			_glyph_apply(g, e)


func _glyph_apply(g: Dictionary, e: Dictionary) -> void:
	if bool(e.get("terrain", false)) or bool(e.get("beacon", false)) or not is_alive(e):
		return
	var uid: int = int(e["uid"])
	var last: Dictionary = g["last"]
	if int(last.get(uid, -1)) == turn_count:
		return
	last[uid] = turn_count
	var fx_def: Dictionary = g["allies"] if String(e["team"]) == String(g["team"]) else g["foes"]
	if fx_def.is_empty():
		return
	var owner: Dictionary = _entity_by_uid(int(g["owner"]))
	var src: Dictionary = owner if not owner.is_empty() else {}
	if int(fx_def["dmg"]) > 0:
		var r: Dictionary = Combat.calc_damage(g["snap"], e, float(fx_def["dmg"]), String(fx_def["dtype"]), 0.0, false, false)
		_apply_damage(src, e, int(r["dmg"]), String(fx_def["dtype"]), bool(r["crit"]), false, true)
	if int(fx_def.get("heal", 0)) > 0:
		_do_heal(src, e, int(fx_def["heal"]))
	if not is_alive(e):
		return
	for d: Dictionary in fx_def["dots"]:
		_apply_status(src, e, String(d["id"]), int(d["turns"]), float(d["value"]))
	for d2: Dictionary in fx_def["debuffs"]:
		_apply_status(src, e, String(d2["id"]), int(d2["turns"]), float(d2["value"]))
	for b: Dictionary in fx_def["buffs"]:
		_apply_status(src, e, String(b["id"]), int(b["turns"]), float(b["value"]))
	fx.emit("status", {"target": e, "text": "Glyphe", "color": SpellFx.colors(String(g["element"]))[0]})


func _entity_by_uid(uid: int) -> Dictionary:
	for x: Dictionary in all_entities():
		if int(x["uid"]) == uid and is_alive(x):
			return x
	return {}


## Fin du tour de `e` : ses glyphes vieillissent ; ceux dont le lanceur est mort disparaissent.
func _glyphs_expire(e: Dictionary) -> void:
	for g: Dictionary in glyphs.duplicate():
		var gone: bool = false
		if int(g["owner"]) == int(e["uid"]):
			g["turns"] = int(g["turns"]) - 1
			gone = int(g["turns"]) <= 0
		elif _entity_by_uid(int(g["owner"])).is_empty():
			gone = true
		if gone:
			glyphs.erase(g)
			fx.emit("glyph_end", {"glyph": g})
			message_requested.emit("%s s'efface." % g["name"])


## Cases de terrain (piliers, murailles, failles, cristaux) posées par un Géomancien.
func terrain_of(owner: Dictionary) -> Array:
	var out: Array = []
	for s: Dictionary in summons:
		if is_alive(s) and int(s.get("owner", -1)) == int(owner["uid"]) and bool(s.get("terrain", false)):
			out.append(s)
	return out


func hp_ratio(e: Dictionary) -> float:
	return float(e["current_pv"]) / maxf(1.0, float(e["max_pv"]))


# ═══════════════════════════════════════════════════════════════════════════
#  Déroulement du combat (initiative)
# ═══════════════════════════════════════════════════════════════════════════

## Statistiques du combat en cours (écran de victoire) : uid -> {name, classe, dmg, heal, kills, taken}
var combat_stats: Dictionary = {}
## Objectif annoncé pour ce combat (voir ProgressionManager.combat_objective) et suivi du chef
var fight_objective: Dictionary = {}
var _chief_uid: int = -1
var _first_kill_uid: int = -1


## Héros (ou entité) à qui attribuer une action : une invocation compte pour son invocateur.
func _stat_owner(e: Dictionary) -> Dictionary:
	if e.is_empty():
		return {}
	if String(e.get("entity_type", "")) == "Summon" and int(e.get("owner", -1)) >= 0:
		for p: Dictionary in players:
			if int(p["uid"]) == int(e["owner"]):
				return p
	return e


func _stat(e: Dictionary) -> Dictionary:
	var o: Dictionary = _stat_owner(e)
	if o.is_empty():
		return {}
	var uid: int = int(o.get("uid", -1))
	if not combat_stats.has(uid):
		combat_stats[uid] = {"name": String(o.get("name", "?")), "classe": String(o.get("classe", "")),
			"team": String(o.get("team", "")), "dmg": 0, "heal": 0, "kills": 0, "taken": 0}
	return combat_stats[uid]


## V18 : objectif du combat (annoncé), chef désigné, synergies de classes appliquées.
func _setup_objective_and_synergies() -> void:
	fight_objective = ProgressionManager.combat_objective(active_save) if not active_save.is_empty() else {}
	var chief: Dictionary = {}
	for en: Dictionary in enemies:
		if chief.is_empty() or int(en.get("max_pv", 0)) > int(chief.get("max_pv", 0)):
			chief = en
	if not chief.is_empty():
		_chief_uid = int(chief["uid"])
	if not fight_objective.is_empty():
		var lab: String = String(fight_objective["label"])
		if String(fight_objective["kind"]) == "chief" and not chief.is_empty():
			lab = "Vaincre en premier le chef : %s" % String(chief.get("name", "?"))
			Combat.add_status(chief, "chief", 99, 0.0)
		message_requested.emit("◆ Objectif : %s (%s)" % [lab, String(fight_objective.get("reward_text", ""))])
	var classes: Array = []
	for p: Dictionary in players:
		classes.append(String(p.get("classe", "")))
	for sy: Dictionary in ProgressionManager.active_synergies(classes):
		for p2: Dictionary in players:
			Combat.add_status(p2, String(sy["status"]), 99, float(sy["value"]))
		message_requested.emit("✦ Synergie %s (%s) : %s" % [sy["name"], sy["pair"], sy["desc"]])


func start_battle() -> void:
	_epoch += 1
	combat_stats = {}
	_first_kill_uid = -1
	_chief_uid = -1
	turn_count = 1
	_last_banner_round = 0
	_turn_index = -1
	active_entity = {}
	turn_order = all_entities()
	for e: Dictionary in turn_order:
		e["init"] = float(e.get("agility", 0)) + _rng.randf_range(-25.0, 25.0)
	# Bestiaire (V18) : chaque ennemi présent est inscrit
	if not active_save.is_empty():
		for en: Dictionary in enemies:
			Achievements.bestiary_seen(active_save, en, fight_biome)
	turn_order.sort_custom(func(a: Dictionary, b: Dictionary) -> bool: return a["init"] > b["init"])
	# Numéro d'ordre des adversaires (timeline + zone de combat) : repère rapide quand
	# plusieurs ennemis partagent le même skin.
	var enemy_no: int = 0
	for e: Dictionary in turn_order:
		if String(e.get("team", "")) == "enemy" and String(e.get("entity_type", "")) != "Summon":
			enemy_no += 1
			e["ord"] = enemy_no
	if enemy_no < 2:
		for e: Dictionary in turn_order:
			e.erase("ord")
	message_requested.emit("Le combat commence !")
	_setup_objective_and_synergies()
	fx.emit("banner", {"text": "Combat !"})
	BiomeEffects.setup(fight_biome, turn_order)
	var biome_txt: String = BiomeEffects.describe(fight_biome)
	if biome_txt != "":
		message_requested.emit("✦ " + biome_txt)
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
	if String(e["team"]) == "enemy" and turn_count > ENRAGE_AFTER_TURN:
		Combat.add_status(e, "dmg_up", 2, 10.0 * float(turn_count - ENRAGE_AFTER_TURN))

	var pa: int = int(e["max_pa"]) + int(Combat.status_value(e, "pa_up")) - int(Combat.status_value(e, "curse"))
	var pm: int = int(e["max_pm"]) + int(Combat.status_value(e, "pm_up")) - int(Combat.status_value(e, "slow")) \
			+ BiomeEffects.pm_bonus(fight_biome, turn_count)
	if turn_count != _last_banner_round:
		_last_banner_round = turn_count
		var rb: String = BiomeEffects.round_banner(fight_biome, turn_count)
		if rb != "":
			message_requested.emit("🌊 " + rb)
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
	_glyph_tick(e)
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
	# Tours de l'ordinateur accélérés selon le réglage « Vitesse des tours ennemis »
	Engine.time_scale = 1.0 if controllable else GameSettings.combat_speed_mult()
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
	var bdmg: int = BiomeEffects.end_turn_damage(fight_biome, e)
	if bdmg > 0:
		_apply_damage({}, e, bdmg, "dot", false, false, true)
		fx.emit("status", {"target": e, "text": "Chaleur", "color": Color(1.0, 0.5, 0.2)})
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
	_tower_attacks(e)
	for tp: Dictionary in terrain_of(e):
		tp["lifetime"] = int(tp["lifetime"]) - 1
		if int(tp["lifetime"]) <= 0:
			tp["current_pv"] = 0
			message_requested.emit("%s s'effrite." % tp["name"])
	_glyphs_expire(e)
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
	_glyph_tick(e)
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
			if p["needs_los"] and d > 1 and not Combat.has_los(cpos, c, los_blockers()):
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
			return "Aucun familier actif."
	var terr: bool = bool(Combat.SUMMONS.get(String(p["summon"]), {}).get("terrain", false))
	var is_beacon: bool = bool(Combat.SUMMONS.get(String(p["summon"]), {}).get("beacon", false))
	if p["kind"] == "summon" and not terr and not is_beacon and summons_of(caster).size() >= 3:
		return "Trop de familiers (3 max)."
	if p["kind"] == "summon" and terr and terrain_of(caster).size() >= 8:
		return "Trop de terrain modifié (8 cases max)."
	if p["kind"] == "recall":
		if t.is_empty() or not bool(t.get("beacon", false)) or int(t.get("owner", -1)) != int(caster["uid"]):
			return "Il faut viser une de vos balises."
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
		base = float(p["summon_dmg_base"]) + float(caster["level"]) * 0.5 * float(p["summon_dmg_lvl"])
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
		"glyph":
			summary = _resolve_glyph(caster, spell, p, cell)
		"recall":
			remove_entity_from_grid(target)
			fx.emit("beacon", {"from": cell, "cells": [cell] as Array[Vector2i]})
			summary = "%s rappelle une balise." % caster["name"]

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
		base = float(p["summon_dmg_base"]) + float(caster["level"]) * 0.5 * float(p["summon_dmg_lvl"])
	var total: int = 0
	var names: Array[String] = []
	for t: Dictionary in targets:
		if not is_alive(t):
			continue
		total += _hit_target(caster, spell, p, t, base)
		names.append(String(t["name"]))
	# Balises du Chasseur : chaque zone d'attaque touchée réplique les dégâts de
	# zone autour des balises alliées qui couvrent une case touchée.
	if p["aoe"] == "zone":
		var rep: Dictionary = _beacon_replicas(caster, spell, p, cell, base)
		if rep.size() > 0:
			total += int(rep["dmg"])
			names.append("balise (%d)" % int(rep["dmg"]))
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
		# La Sagesse (précision) de l'attaquant réduit l'esquive de la cible
		var dodge_chance: float = Combat.status_value(tgt, "dodge") - float(attacker.get("wisdom", 0)) * 0.25
		if _rng.randf() * 100.0 < dodge_chance:
			fx.emit("status", {"target": tgt, "text": "Esquive !", "color": Color(0.7, 0.95, 0.5)})
			return 0
	var pv_before: int = int(tgt["current_pv"])
	tgt["current_pv"] = pv_before - dmg
	var real_dmg: int = mini(dmg, maxi(0, pv_before))
	if not attacker.is_empty():
		var sa: Dictionary = _stat(attacker)
		if not sa.is_empty():
			sa["dmg"] = int(sa["dmg"]) + real_dmg
			if pv_before > 0 and int(tgt["current_pv"]) <= 0:
				sa["kills"] = int(sa["kills"]) + 1
				if not active_save.is_empty():
					Achievements.bestiary_kill(active_save, tgt)
				if _first_kill_uid < 0 and String(tgt.get("team", "")) == "enemy":
					_first_kill_uid = int(tgt.get("uid", -1))
	var st_t: Dictionary = _stat(tgt)
	if not st_t.is_empty():
		st_t["taken"] = int(st_t["taken"]) + real_dmg
	fx.emit("damage", {
		"target": tgt, "attacker": attacker, "amount": dmg, "dtype": dtype, "crit": crit, "back": back,
		"pv_after": maxi(0, int(tgt["current_pv"])),
	})
	if not attacker.is_empty():
		entity_attacked.emit(attacker, tgt, dmg)
		if dtype != "dot":
			_on_hit_item_effects(attacker, tgt, dmg, dtype)
	return dmg


## Effets d'objets déclenchés à l'impact : vol de vie, poison de l'arme.
func _on_hit_item_effects(attacker: Dictionary, tgt: Dictionary, dmg: int, dtype: String) -> void:
	var afx: Dictionary = attacker.get("fx", {})
	if afx.is_empty():
		return
	var ls: int = int(afx.get("lifesteal", 0))
	if ls > 0 and dmg > 0 and is_alive(attacker):
		_do_heal(attacker, attacker, maxi(1, roundi(float(dmg) * float(ls) / 100.0)))
	var pd: int = int(afx.get("poison_hit_dmg", 0))
	if pd > 0 and dtype == "phys" and is_alive(tgt) and _rng.randf() < 0.35:
		_apply_status(attacker, tgt, "poison", int(afx.get("poison_hit_turns", 2)), float(pd))


func _apply_status(src: Dictionary, tgt: Dictionary, id: String, turns: int, value: float) -> void:
	if not is_alive(tgt):
		return
	var info: Dictionary = Combat.status_info(id)
	if Combat.NEGATIVE.has(id):
		if Combat.has_status(tgt, "immune_neg") or Combat.has_status(tgt, "immune"):
			fx.emit("status", {"target": tgt, "text": "Résiste", "color": Color(0.8, 1.0, 0.8)})
			return
		# Altérations de contrôle : la Sagesse de la cible (vs celle du lanceur) peut les faire échouer
		if not src.is_empty() and id in ["stun", "root", "slow", "curse", "weaken"]:
			var land: float = clampf(0.9 + (float(src.get("wisdom", 0)) - float(tgt.get("wisdom", 0))) / 250.0, 0.5, 1.0)
			if _rng.randf() > land:
				fx.emit("status", {"target": tgt, "text": "Résiste", "color": Color(0.8, 1.0, 0.8)})
				return
	if id == "poison" and not src.is_empty():
		value *= 1.0 + float(src.get("fx", {}).get("poison_pct", 0)) / 100.0
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
	var sh: Dictionary = _stat(_caster)
	if not sh.is_empty():
		sh["heal"] = int(sh["heal"]) + real
	tgt["current_pv"] = int(tgt["current_pv"]) + real
	fx.emit("heal", {"target": tgt, "amount": real, "pv_after": int(tgt["current_pv"])})
	return real


## Obstacles de vue : arbres/rochers du décor + arbres invoqués par les Sylvains.
func los_blockers() -> Dictionary:
	var out: Dictionary = obstacles.duplicate()
	for s: Dictionary in summons:
		if bool(s.get("blocks_los", false)) and is_alive(s):
			out[pos_of(s)] = "tree"
	return out


## Montant de soin d'un sort pour une cible donnée.
func _heal_amount(caster: Dictionary, p: Dictionary, t: Dictionary) -> int:
	var amt: int = 0
	if int(p["heal"]) > 0:
		amt = roundi(float(p["heal"]) * (1.0 + float(caster.get("intelligence", 0)) / 300.0)
			* (1.0 + float(caster.get("wisdom", 0)) / 300.0)
			* (1.0 + float(caster.get("fx", {}).get("heal_pct", 0)) / 100.0))
	if int(p["heal_pct"]) > 0:
		amt = roundi(float(t["max_pv"]) * float(p["heal_pct"]) / 100.0)
	return amt


## Arbres de soin vivants d'un Sylvain.
func trees_of(owner: Dictionary) -> Array:
	var out: Array = []
	for s: Dictionary in summons:
		if bool(s.get("relay", false)) and int(s.get("owner", -1)) == int(owner["uid"]) and is_alive(s):
			out.append(s)
	return out

## Balises actives d'un Chasseur (3 max).
func beacons_of(owner: Dictionary) -> Array:
	var out: Array = []
	for s: Dictionary in summons:
		if bool(s.get("beacon", false)) and int(s.get("owner", -1)) == int(owner["uid"]) and is_alive(s):
			out.append(s)
	return out


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
		var amt: int = _heal_amount(caster, p, t)
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
	# Relais de l'arbre du Sylvain : alliés ET invocations autour de l'arbre reçoivent le même soin
	var relayed: Array[String] = []
	if String(caster.get("classe", "")) == "Sylvain" and p["aoe"] != "team":
		for tree: Dictionary in trees_of(caster):
			var tp: Vector2i = pos_of(tree)
			var shown: bool = false
			for ally: Dictionary in entities_of_team(String(caster["team"])):
				if ally == tree or targets.has(ally) or not is_alive(ally):
					continue
				var ap: Vector2i = pos_of(ally)
				if maxi(absi(ap.x - tp.x), absi(ap.y - tp.y)) > 1:
					continue
				total += _do_heal(caster, ally, _heal_amount(caster, p, ally))
				relayed.append(String(ally["name"]))
				targets.append(ally)
				shown = true
			if shown:
				fx.emit("status", {"target": tree, "text": "🌳 Relais", "color": Color(0.55, 1.0, 0.55), "good": true})
	var relay_txt: String = ("  🌳 relais : %s" % ", ".join(relayed)) if not relayed.is_empty() else ""
	if names.is_empty() and relayed.is_empty():
		return "%s lance %s." % [caster["name"], spell["name"]]
	return "%s lance %s : +%d PV (%s)%s" % [caster["name"], spell["name"], total, ", ".join(names), relay_txt]


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
	var info: Dictionary = Combat.SUMMONS.get(sname, Combat.SUMMONS["Loup Spectral"])
	if bool(info.get("beacon", false)):
		# 3 balises max : la plus ancienne disparaît
		var old_b: Array = beacons_of(caster)
		while old_b.size() >= 3:
			var oldest: Dictionary = old_b.pop_front()
			message_requested.emit("La plus ancienne balise disparaît.")
			remove_entity_from_grid(oldest)
	var s: Dictionary = _base_entity("%s (inv.)" % sname, "Summon", String(caster["team"]), sname,
		int(caster["level"]), cell)
	var scale: float = (0.7 + float(caster["level"]) / 400.0) * (1.0 + float(caster.get("intelligence", 0)) / 400.0)
	s.merge({
		"max_pv": int(float(info["pv"]) * scale), "current_pv": int(float(info["pv"]) * scale),
		"force": int(float(info["force"]) * scale), "intelligence": int(float(info["force"]) * scale),
		"agility": info["agility"], "wisdom": 20, "defense": info["defense"],
		"max_pa": info["pa"], "current_pa": 0, "max_pm": info["pm"], "current_pm": 0,
		"color": info["color"], "owner": caster["uid"],
		"lifetime": int(info.get("turns", p["summon_turns"])),
		"facing": caster["facing"],
	}, true)
	if bool(info.get("terrain", false)):
		s["terrain"] = true
	if bool(info.get("indestructible", false)):
		s["indestructible"] = true
	if bool(info.get("tower", false)):
		s["tower"] = true
	s["spells"] = Combat.summon_spells(sname)
	s["init"] = float(caster.get("init", 0.0)) - 0.01
	var is_static: bool = bool(info.get("static", false))
	if bool(info.get("unique", false)):
		# 1 seul exemplaire par invocateur : le précédent se fane
		for old: Dictionary in summons_of(caster):
			if String(old.get("classe", "")) == sname:
				remove_entity_from_grid(old)
	if bool(info.get("blocks_los", false)):
		s["blocks_los"] = true
	if bool(info.get("relay", false)):
		s["relay"] = true
	if bool(info.get("beacon", false)):
		s["beacon"] = true
	if is_static:
		s["static"] = true
	summons.append(s)
	grid[cell.y][cell.x] = s
	var span: int = int(info.get("span", 1))
	if span > 1:
		# ligne perpendiculaire à l'axe lanceur → case visée
		var cp: Vector2i = pos_of(caster)
		var d: Vector2i = cell - cp
		var perp: Vector2i = Vector2i(0, 1) if abs(d.x) >= abs(d.y) else Vector2i(1, 0)
		for k: int in range(1, (span - 1) / 2 + 1):
			for sign_v: int in [-1, 1]:
				var c2: Vector2i = cell + perp * k * sign_v
				if not is_free(c2):
					continue
				var s2: Dictionary = s.duplicate(true)
				s2["uid"] = _new_uid()
				s2["x"] = c2.x
				s2["y"] = c2.y
				summons.append(s2)
				grid[c2.y][c2.x] = s2
				fx.emit("summon", {"entity": s2})
	if not is_static:
		var idx: int = turn_order.find(caster)
		if idx >= 0:
			turn_order.insert(idx + 1, s)
		else:
			turn_order.append(s)
	fx.emit("summon", {"entity": s})
	return "%s invoque %s !" % [caster["name"], sname]


## Balises du Chasseur : si une zone d'attaque touche une balise alliée, elle est
## répliquée (même zone) autour de TOUTES les autres balises alliées.
func _beacon_replicas(caster: Dictionary, spell: Dictionary, p: Dictionary, cell: Vector2i, base: float) -> Dictionary:
	var hit_cells: Array[Vector2i] = Combat.zone_cells(cell, int(p["zone_r"]), String(p["zone_shape"]), GRID_SIZE)
	var beacons: Array = beacons_of(caster)
	var triggered: bool = false
	for b: Dictionary in beacons:
		if hit_cells.has(pos_of(b)):
			triggered = true
	if not triggered:
		return {}
	var already: Array = []
	for e0: Dictionary in enemies_of(caster):
		if hit_cells.has(pos_of(e0)):
			already.append(int(e0["uid"]))
	var total: int = 0
	for b2: Dictionary in beacons:
		var bpos: Vector2i = pos_of(b2)
		if bpos == cell:
			continue
		var rep_cells: Array[Vector2i] = Combat.zone_cells(bpos, int(p["zone_r"]), String(p["zone_shape"]), GRID_SIZE)
		for e: Dictionary in enemies_of(caster):
			if rep_cells.has(pos_of(e)) and is_alive(e) and not bool(e.get("beacon", false)) \
					and not already.has(int(e["uid"])):
				already.append(int(e["uid"]))
				total += _hit_target(caster, spell, p, e, base)
		fx.emit("beacon", {"from": bpos, "cells": rep_cells})
	if total <= 0:
		return {}
	return {"dmg": total}


## Pilier du Géomancien : attaque l'ennemi le plus proche dans un rayon de 4 cases.
const TOWER_RANGE: int = 4

func _tower_attacks(owner: Dictionary) -> void:
	for tw: Dictionary in terrain_of(owner):
		if not bool(tw.get("tower", false)) or not is_alive(tw):
			continue
		var tpos: Vector2i = pos_of(tw)
		var best: Dictionary = {}
		var best_d: int = 99
		for e: Dictionary in enemies_of(owner):
			if not is_alive(e) or bool(e.get("terrain", false)) or Combat.has_status(e, "invisible"):
				continue
			var d: int = Combat.manhattan(tpos, pos_of(e))
			if d <= TOWER_RANGE and d < best_d:
				best = e
				best_d = d
		if best.is_empty():
			continue
		# V17/V19 : aligné sur les sorts des héros (/1,7)
		var base: float = (28.0 + float(owner["level"]) * 0.9) / 2.0
		var r: Dictionary = Combat.calc_damage(owner, best, base, "mag", 0.0, false, false)
		fx.emit("cast", {"caster": tw, "spell": "Éclat du pilier", "kind": "attack", "dtype": "mag",
			"from": tpos, "to": pos_of(best), "ranged": true, "cells": [pos_of(best)] as Array[Vector2i]})
		_apply_damage(owner, best, int(r["dmg"]), "mag", bool(r["crit"]), false)


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
	var deaths: int = 0
	for pl_d: Dictionary in players:
		if not is_alive(pl_d):
			deaths += 1
	var heal_total: int = 0
	var all_hit: bool = true
	for pl_s: Dictionary in players:
		var stp: Dictionary = combat_stats.get(int(pl_s["uid"]), {})
		heal_total += int(stp.get("heal", 0))
		if int(stp.get("dmg", 0)) <= 0:
			all_hit = false
	var info: Dictionary = {"enemies": fight_enemies, "turns": turn_count, "boss": fight_is_boss, "deaths": deaths,
		"objective": fight_objective.duplicate(), "chief_first": _first_kill_uid >= 0 and _first_kill_uid == _chief_uid,
		"heal_total": heal_total, "all_hit": all_hit}
	if alive_p == 0:
		game_over = true
		victory = false
		if not active_save.is_empty() and active_slot >= 0:
			ProgressionManager.register_defeat(active_save, info)
			ProgressionManager.write_save(active_slot, active_save)
		Engine.time_scale = 1.0
		game_ended.emit(false)
		message_requested.emit("Tous vos personnages sont tombés. DÉFAITE !")
	elif alive_e == 0:
		game_over = true
		victory = true
		if not active_save.is_empty() and active_slot >= 0:
			ProgressionManager.register_victory(active_save, info)
			ProgressionManager.write_save(active_slot, active_save)
		Engine.time_scale = 1.0
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
	if gm.has_method("apply_biome"):
		gm.apply_biome(fight_biome)
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
