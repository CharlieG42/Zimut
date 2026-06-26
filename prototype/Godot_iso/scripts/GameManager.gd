extends Node
## GameManager - Logique globale Zimut (version isométrique)
## Autoload configuré dans project.godot
## FIXES : fonctions get_*_data() sans type retour → crash parse ; 
##         load_data_fallback crée un DataLoader enfant qui écrase l'autoload ;
##         init_entities() cherche colonne "Classe" inexistante dans le CSV ennemis

const GRID_SIZE        := 10
const CELL_SIZE        := Vector2i(100, 100)
const CELL_HALF_OFFSET := Vector2i(50, 50)

const DEFAULT_PLAYER_LEVEL := 30
const DEFAULT_ENEMY_LEVEL  := 30

const COLORS: Dictionary = {
	"Tank":      Color(0, 0.4, 0.8),
	"Assassin":  Color(0.8, 0, 0),
	"Chasseur":  Color(0, 0.8, 0),
	"Mage":      Color(0.6, 0, 0.8),
	"Support":   Color(1, 0.8, 0),
	"Heal":      Color(0, 0.8, 0.8),
	"Gobelin":   Color(0.5, 0.8, 0.3),
	"Squelette": Color(0.8, 0.8, 0.8),
	"Loup":      Color(0.6, 0.6, 0.4),
}

var grid: Array                  = []
var players: Array               = []
var enemies: Array               = []
var current_turn: int            = 0
var current_player_index: int    = 0
var turn_count: int              = 1
var selected_entity              = null
var selected_spell               = null
var selected_cell: Vector2i      = Vector2i(0, 0)
var show_spells: bool            = false
var game_over: bool              = false
var victory: bool                = false

signal turn_changed(turn: int)
signal player_changed(index: int)
signal entity_selected(entity)
signal spell_selected(spell)
signal game_ended(victory: bool)
signal entity_moved(entity, from_pos: Vector2i, to_pos: Vector2i)
signal entity_attacked(attacker, target, damage: int)
signal spell_casted(caster, spell, target, result: String)
signal message_requested(text: String)


## Helper function to get numeric value from spell with fallback to effect parsing
func _get_spell_damage(spell: Dictionary, damage_type: String) -> int:
	# Try new numeric columns first
	var column_name = ""
	match damage_type:
		"physical":
			column_name = "Degats_physiques"
		"magical":
			column_name = "Degats_magiques"
		"heal":
			column_name = "Soins"
		"resistance_physical":
			column_name = "Resistance_physique"
		"resistance_magical":
			column_name = "Resistance_magique"
		"debuff_physical":
			column_name = "Debuff_physique"
		"debuff_magical":
			column_name = "Debuff_magique"
		"buff_physical":
			column_name = "Buff_physique"
		"buff_magical":
			column_name = "Buff_magique"
		_:
			return 0
	
	# Check new column
	if spell.has(column_name) and spell[column_name] != "" and spell[column_name] != "0":
		return int(spell[column_name])
	
	# Fallback to old columns (Coût PA, etc.)
	if damage_type == "physical" and spell.has("Coût PA"):
		pass  # Not applicable
	
	# Fallback to effect parsing for backward compatibility
	return _extract_damage_from_effect(spell.get("Effet", spell.get("effect", "")), damage_type)


## Helper function to extract damage value from spell effect string (fallback)
func _extract_damage_from_effect(effect: String, damage_type: String = "") -> int:
	var damage_patterns = [
		"dégâts",
		"dégâts magiques",
		"dégâts en zone",
		"dégâts/tour"
	]
	for pattern in damage_patterns:
		if pattern in effect:
			var parts = effect.split(pattern)[0].split(" ")
			for part in parts:
				if part.is_valid_int():
					return int(part)
	return 0


## Helper function to extract heal value from spell effect string (fallback)
func _extract_heal_from_effect(effect: String) -> int:
	if "Restaure" in effect:
		var parts = effect.split("Restaure")[1].split("PV")[0].split(" ")
		for part in parts:
			if part.is_valid_int():
				return int(part)
	return 0


func _ready() -> void:
	var data_loader: Node = get_node_or_null("/root/DataLoader")
	if data_loader == null:
		push_error("DataLoader autoload introuvable — vérifier project.godot")
		_init_with_fallback_data()
		return

	if data_loader.data_loaded:
		_on_data_loaded()
	else:
		if not data_loader.data_loaded_successfully.is_connected(_on_data_loaded):
			data_loader.data_loaded_successfully.connect(_on_data_loaded)


func _on_data_loaded() -> void:
	init_grid()
	init_entities()
	current_turn = 0
	turn_count   = 1
	turn_changed.emit(current_turn)
	if players.size() > 0:
		var first_alive: int = 0
		for i: int in range(players.size()):
			if int(players[i]["current_pv"]) > 0:
				first_alive = i
				break
		current_player_index = first_alive
		selected_entity = players[current_player_index]
		players[current_player_index]["is_active"] = true
		show_spells = true
		entity_selected.emit(selected_entity)
		player_changed.emit(current_player_index)


# ── Accesseurs DataLoader (retour Array explicite) ──────────────────────────

func get_classes_data() -> Array:
	var dl: Node = get_node_or_null("/root/DataLoader")
	if dl:
		return dl.classes_data
	return []


func get_spells_data() -> Array:
	var dl: Node = get_node_or_null("/root/DataLoader")
	if dl:
		return dl.spells_data
	return []


func get_enemies_data() -> Array:
	var dl: Node = get_node_or_null("/root/DataLoader")
	if dl:
		return dl.enemies_data
	return []


# ── Fallback si DataLoader absent ──────────────────────────────────────────

func _init_with_fallback_data() -> void:
	## Données minimales intégrées (même structure que les CSV)
	var dl_node := Node.new()
	dl_node.name = "DataLoaderFallback"
	dl_node.set_script(load("res://scripts/DataLoader.gd"))
	add_child(dl_node)
	# Forcer le chargement maintenant que le nœud existe
	_on_data_loaded()


# ═══════════════════════════════════════════════════════
#  INITIALISATION GRILLE / ENTITÉS
# ═══════════════════════════════════════════════════════

func init_grid() -> void:
	grid = []
	for _y: int in range(GRID_SIZE):
		var row: Array = []
		for _x: int in range(GRID_SIZE):
			row.append(null)
		grid.append(row)


func init_entities() -> void:
	var player_classes: Array[String]    = ["Tank", "Assassin", "Mage"]
	var player_positions: Array[Vector2i] = [Vector2i(2, 2), Vector2i(2, 3), Vector2i(3, 2)]
	players = []

	var classes_data: Array = get_classes_data()
	var spells_data: Array  = get_spells_data()
	var enemies_data: Array = get_enemies_data()

	# ── Joueurs ────────────────────────────────────────────────────────────
	for i: int in range(player_classes.size()):
		var classe: String = player_classes[i]
		var pos: Vector2i  = player_positions[i]

		# Chercher les stats au niveau DEFAULT_PLAYER_LEVEL (ou le plus proche ≤)
		var class_info: Dictionary = _find_best_match(classes_data, "Classe", classe,
			"Niveau", DEFAULT_PLAYER_LEVEL)
		if class_info.is_empty():
			push_error("Classe '%s' introuvable dans classes.csv" % classe)
			continue

		var player: Dictionary = {
			"name":         "%s Lv%d" % [classe, DEFAULT_PLAYER_LEVEL],
			"entity_type":  "Player",
			"classe":       classe,
			"level":        DEFAULT_PLAYER_LEVEL,
			"max_pv":       _csv_int(class_info, "Vita (PV)",             60),
			"current_pv":   _csv_int(class_info, "Vita (PV)",             60),
			"force":        _csv_int(class_info, "Force (CAC)",           10),
			"intelligence": _csv_int(class_info, "Intelligence (Magie)",  10),
			"agility":      _csv_int(class_info, "Agilité (Vit. Atk)",    10),
			"wisdom":       _csv_int(class_info, "Sagesse (Précision)",   10),
			"defense":      _csv_int(class_info, "Défense",               10),
			"max_pa":       _csv_int(class_info, "PA",                     5),
			"current_pa":   _csv_int(class_info, "PA",                     5),
			"max_pm":       _csv_int(class_info, "PM",                     3),
			"current_pm":   _csv_int(class_info, "PM",                     3),
			"x": pos.x, "y": pos.y,
			"spells":    [],
			"is_active": false,
		}

		# Sorts disponibles (colonne "Classe" dans sorts.csv)
		for spell_info: Dictionary in spells_data:
			if spell_info.get("Classe", "") == classe:
				var req_lvl: int = int(spell_info.get("Niveau_requis", spell_info.get("Niveau requis", "1")))
				if req_lvl <= DEFAULT_PLAYER_LEVEL:
					player["spells"].append({
						"name":              spell_info.get("Nom", "Sort"),
						"classe":            classe,
						"cost_pa":           int(spell_info.get("Cout_PA", spell_info.get("Coût PA", "1"))),
						"cost_pm":           int(spell_info.get("Cout_PM", spell_info.get("Coût PM", "0"))),
						"range":             int(spell_info.get("Portee", spell_info.get("Portée", "1"))),
						"effect":            spell_info.get("Effet", ""),
						"level_required":    req_lvl,
						"spell_type":        spell_info.get("Type", "Attaque"),
						# Nouvelles colonnes numériques
						"Degats_physiques": int(spell_info.get("Degats_physiques", "0")),
						"Degats_magiques":  int(spell_info.get("Degats_magiques", "0")),
						"Soins":             int(spell_info.get("Soins", "0")),
						"Resistance_physique": int(spell_info.get("Resistance_physique", "0")),
						"Resistance_magique": int(spell_info.get("Resistance_magique", "0")),
						"Debuff_physique":   int(spell_info.get("Debuff_physique", "0")),
						"Debuff_magique":    int(spell_info.get("Debuff_magique", "0")),
						"Buff_physique":     int(spell_info.get("Buff_physique", "0")),
						"Buff_magique":      int(spell_info.get("Buff_magique", "0")),
					})

		players.append(player)
		grid[pos.y][pos.x] = player

	# ── Ennemis ────────────────────────────────────────────────────────────
	var enemy_types: Array[String]       = ["Gobelin", "Squelette", "Loup"]
	var enemy_positions: Array[Vector2i]  = [Vector2i(7, 7), Vector2i(7, 6), Vector2i(6, 7)]
	enemies = []

	for i: int in range(enemy_types.size()):
		var etype: String  = enemy_types[i]
		var pos: Vector2i  = enemy_positions[i]

		# CSV ennemis : colonne "Type" (pas "Classe")
		var enemy_info: Dictionary = _find_best_match(enemies_data, "Type", etype,
			"Niveau", DEFAULT_ENEMY_LEVEL)
		if enemy_info.is_empty():
			push_error("Ennemi '%s' introuvable dans ennemis.csv" % etype)
			continue

		var enemy: Dictionary = {
			"name":         "%s Lv%d" % [etype, DEFAULT_ENEMY_LEVEL],
			"entity_type":  "Enemy",
			"classe":       etype,
			"level":        DEFAULT_ENEMY_LEVEL,
			"max_pv":       _csv_int(enemy_info, "PV",       50),
			"current_pv":   _csv_int(enemy_info, "PV",       50),
			"force":        _csv_int(enemy_info, "Attaque",  10),
			"intelligence": 0,
			"agility":      float(_csv_int(enemy_info, "Attaque", 10)) / 2.0,
			"wisdom":       0,
			"defense":      _csv_int(enemy_info, "Défense",   5),
			"max_pa":       _csv_int(enemy_info, "PA",        3),
			"current_pa":   _csv_int(enemy_info, "PA",        3),
			"max_pm":       _csv_int(enemy_info, "PM",        2),
			"current_pm":   _csv_int(enemy_info, "PM",        2),
			"x": pos.x, "y": pos.y,
		}
		enemies.append(enemy)
		grid[pos.y][pos.x] = enemy


## Cherche dans `data_array` la ligne où `key_col`==`key_val`
## au niveau `level_col`==`target_level` (ou le plus proche ≤)
func _find_best_match(data_array: Array, key_col: String, key_val: String,
		level_col: String, target_level: int) -> Dictionary:
	var best: Dictionary = {}
	var best_lvl: int    = -1
	for row: Dictionary in data_array:
		if row.get(key_col, "") != key_val:
			continue
		var lvl: int = int(row.get(level_col, "0"))
		if lvl <= target_level and lvl > best_lvl:
			best     = row
			best_lvl = lvl
	return best


func _csv_int(row: Dictionary, col: String, default_val: int) -> int:
	return int(row.get(col, str(default_val)))


# ═══════════════════════════════════════════════════════
#  ACTIONS JOUEUR
# ═══════════════════════════════════════════════════════

func handle_cell_selected(x: int, y: int) -> void:
	if game_over or current_turn != 0:
		return

	var target_pos: Vector2i       = Vector2i(x, y)
	var target_entity              = grid[y][x]
	var current_player: Dictionary = players[current_player_index]
	var player_pos: Vector2i       = Vector2i(int(current_player["x"]), int(current_player["y"]))

	# 1. Sort sélectionné → lancer
	if selected_spell != null:
		_try_cast_spell(current_player, target_pos, target_entity)
		return

	# 2. Clic sur sa propre case → rien
	if target_pos == player_pos:
		return

	# 3. Clic sur un allié → ignoré (pas de changement de joueur actif)
	for p: Dictionary in players:
		if int(p["x"]) == x and int(p["y"]) == y and int(p["current_pv"]) > 0:
			return

	# 4. Case vide → déplacer
	if target_entity == null:
		_try_move(current_player, target_pos)
		return

	# 5. Ennemi → attaque de base
	if target_entity.get("entity_type", "") == "Enemy":
		_try_basic_attack(current_player, target_entity, target_pos)


func _try_move(player: Dictionary, target_pos: Vector2i) -> void:
	var from_pos: Vector2i = Vector2i(player["x"], player["y"])
	var dist: int = abs(target_pos.x - from_pos.x) + abs(target_pos.y - from_pos.y)
	if dist > int(player["current_pm"]):
		message_requested.emit("Pas assez de PM ! (%d requis, %d dispo)" % [dist, player["current_pm"]])
		return
	if not _is_valid(target_pos) or grid[target_pos.y][target_pos.x] != null:
		message_requested.emit("Case inaccessible.")
		return
	grid[from_pos.y][from_pos.x] = null
	player["x"] = target_pos.x
	player["y"] = target_pos.y
	player["current_pm"] = int(player["current_pm"]) - dist
	grid[target_pos.y][target_pos.x] = player
	selected_cell = target_pos
	entity_moved.emit(player, from_pos, target_pos)
	message_requested.emit("%s se déplace en (%d,%d)" % [player["name"], target_pos.x, target_pos.y])
	player_changed.emit(current_player_index)
	_refresh_grid()


func _try_basic_attack(attacker: Dictionary, target: Dictionary, target_pos: Vector2i) -> void:
	var from_pos: Vector2i = Vector2i(attacker["x"], attacker["y"])
	var dist: int = abs(target_pos.x - from_pos.x) + abs(target_pos.y - from_pos.y)
	if dist > 1:
		message_requested.emit("Ennemi hors de portée (distance %d)." % dist)
		return
	if int(attacker["current_pa"]) <= 0:
		message_requested.emit("Plus de PA !")
		return
	var raw_dmg: int    = int(attacker["force"]) + (randi() % 5 - 2)
	var actual_dmg: int = maxi(1, raw_dmg - int(int(target["defense"]) / 2.0))
	target["current_pv"] = int(target["current_pv"]) - actual_dmg
	attacker["current_pa"] = int(attacker["current_pa"]) - 1
	entity_attacked.emit(attacker, target, actual_dmg)
	message_requested.emit("%s attaque %s : %d dégâts !" % [attacker["name"], target["name"], actual_dmg])
	if int(target["current_pv"]) <= 0:
		remove_entity_from_grid(target)
	player_changed.emit(current_player_index)
	_refresh_grid()


func _try_cast_spell(caster: Dictionary, target_pos: Vector2i, target_entity) -> void:
	var spell: Dictionary  = selected_spell
	var spell_range: int   = int(spell.get("range", 1))
	var from_pos: Vector2i = Vector2i(caster["x"], caster["y"])
	var dist: int          = abs(target_pos.x - from_pos.x) + abs(target_pos.y - from_pos.y)

	if dist > spell_range:
		message_requested.emit("Hors de portée (portée %d, dist %d)." % [spell_range, dist])
		selected_spell = null
		player_changed.emit(current_player_index)
		_refresh_grid()
		return
	if int(caster["current_pa"]) < int(spell["cost_pa"]) or int(caster["current_pm"]) < int(spell["cost_pm"]):
		message_requested.emit("Ressources insuffisantes.")
		selected_spell = null
		player_changed.emit(current_player_index)
		_refresh_grid()
		return

	# Déterminer la cible selon le type de sort
	var actual_target: Dictionary = {}
	var spell_type: String = spell.get("spell_type", spell.get("Type", "Attaque"))
	if spell_type == "Soin":
		if target_entity != null and target_entity.get("entity_type", "") == "Player":
			actual_target = target_entity
		else:
			actual_target = caster
	elif spell_type == "Buff" or spell_type == "Défense":
		actual_target = caster
	else:
		if target_entity != null and target_entity.get("entity_type", "") == "Enemy":
			actual_target = target_entity
		else:
			message_requested.emit("Ciblez un ennemi pour ce sort.")
			return

	caster["current_pa"] = int(caster["current_pa"]) - int(spell["cost_pa"])
	caster["current_pm"] = int(caster["current_pm"]) - int(spell["cost_pm"])
	var result: String = _apply_spell(caster, spell, actual_target)
	spell_casted.emit(caster, spell, actual_target, result)
	message_requested.emit(result)

	if not actual_target.is_empty() and int(actual_target.get("current_pv", 1)) <= 0:
		remove_entity_from_grid(actual_target)

	selected_spell = null
	player_changed.emit(current_player_index)
	_refresh_grid()


func _apply_spell(caster: Dictionary, spell: Dictionary, target: Dictionary) -> String:
	# Accepte "spell_type" (notre format) ET "Type" (format CSV direct)
	var spell_type: String = spell.get("spell_type", spell.get("Type", "Attaque"))
	
	# Utiliser les nouvelles colonnes numériques
	var physical_damage: int = _get_spell_damage(spell, "physical")
	var magical_damage: int = _get_spell_damage(spell, "magical")
	var heal_amount: int = _get_spell_damage(spell, "heal")
	var resistance_physical: int = _get_spell_damage(spell, "resistance_physical")
	var resistance_magical: int = _get_spell_damage(spell, "resistance_magical")
	var debuff_physical: int = _get_spell_damage(spell, "debuff_physical")
	var debuff_magical: int = _get_spell_damage(spell, "debuff_magical")
	var buff_physical: int = _get_spell_damage(spell, "buff_physical")
	var buff_magical: int = _get_spell_damage(spell, "buff_magical")
	
	match spell_type:
		"Attaque", "CAC":
			# Utiliser les dégâts physiques du CSV
			var raw_dmg: int = physical_damage if physical_damage > 0 else (int(caster["force"]) + (randi() % 5 - 2))
			var actual_dmg: int = maxi(1, raw_dmg - int(int(target["defense"]) / 2.0))
			target["current_pv"] = int(target["current_pv"]) - actual_dmg
			entity_attacked.emit(caster, target, actual_dmg)
			return "%s utilise %s : %d dégâts physiques !" % [caster["name"], spell["name"], actual_dmg]
		"Magie":
			# Utiliser les dégâts magiques du CSV
			var raw_dmg: int = magical_damage if magical_damage > 0 else (int(caster["intelligence"]) + (randi() % 5 - 2))
			var actual_dmg: int = maxi(1, raw_dmg)
			target["current_pv"] = int(target["current_pv"]) - actual_dmg
			entity_attacked.emit(caster, target, actual_dmg)
			return "%s utilise %s : %d dégâts magiques !" % [caster["name"], spell["name"], actual_dmg]
		"Buff", "Défense":
			if resistance_physical > 0:
				target["defense"] = int(float(int(target["defense"]) * (1 + resistance_physical / 100.0)))
				return "%s utilise %s : +%d%% défense !" % [caster["name"], spell["name"], resistance_physical]
			elif resistance_magical > 0:
				# Résistance magique (à implémenter selon votre système)
				return "%s utilise %s : +%d%% résistance magique !" % [caster["name"], spell["name"], resistance_magical]
			elif buff_physical > 0:
				return "%s utilise %s : +%d%% dégâts physiques !" % [caster["name"], spell["name"], buff_physical]
			elif buff_magical > 0:
				return "%s utilise %s : +%d%% dégâts magiques !" % [caster["name"], spell["name"], buff_magical]
			else:
				target["defense"] = int(float(int(target["defense"]) * 3) / 2.0)
				return "%s utilise %s : défense augmentée !" % [caster["name"], spell["name"]]
		"Soin":
			# Utiliser les soins du CSV
			var heal: int = heal_amount if heal_amount > 0 else (int(caster["intelligence"]) + (randi() % 5 - 2))
			target["current_pv"] = mini(int(target["max_pv"]), int(target["current_pv"]) + heal)
			return "%s utilise %s sur %s : +%d PV !" % [caster["name"], spell["name"], target["name"], heal]
		"Debuff":
			# Pour les debuffs avec dégâts
			if debuff_physical > 0:
				target["current_pa"] = maxi(0, int(target["current_pa"]) - debuff_physical)
				return "%s utilise %s : -%d PA !" % [caster["name"], spell["name"], debuff_physical]
			elif debuff_magical > 0:
				target["current_pv"] = int(target["current_pv"]) - debuff_magical
				entity_attacked.emit(caster, target, debuff_magical)
				return "%s utilise %s : %d dégâts magiques (DoT) !" % [caster["name"], spell["name"], debuff_magical]
			elif magical_damage > 0:
				target["current_pv"] = int(target["current_pv"]) - magical_damage
				entity_attacked.emit(caster, target, magical_damage)
				return "%s utilise %s : %d dégâts + effet spécial !" % [caster["name"], spell["name"], magical_damage]
			else:
				return "%s utilise %s : effet spécial appliqué !" % [caster["name"], spell["name"]]
	return "%s utilise %s." % [caster["name"], spell["name"]]


func handle_spell_selected(spell: Dictionary) -> void:
	if current_turn != 0 or game_over:
		return
	if selected_spell != null and selected_spell == spell:
		selected_spell = null
		message_requested.emit("Sort annulé.")
	else:
		selected_spell = spell
		message_requested.emit("Sort : %s — cliquez une cible." % spell.get("name", ""))
	spell_selected.emit(selected_spell)


# ═══════════════════════════════════════════════════════
#  GESTION DES TOURS
# ═══════════════════════════════════════════════════════

func next_player() -> void:
	if game_over or current_turn != 0:
		return
	players[current_player_index]["is_active"] = false
	selected_spell = null

	var first_alive: int = -1
	for i: int in range(players.size()):
		if int(players[i]["current_pv"]) > 0:
			first_alive = i
			break

	var next_index: int = -1
	for i: int in range(1, players.size() + 1):
		var idx: int = (current_player_index + i) % players.size()
		if int(players[idx]["current_pv"]) > 0:
			next_index = idx
			break

	if next_index == -1 or next_index == first_alive:
		_end_player_turn()
		return

	_set_active_player(next_index)
	message_requested.emit("Tour de %s." % players[next_index]["name"])


func _set_active_player(index: int) -> void:
	for p: Dictionary in players:
		p["is_active"] = false
	current_player_index = index
	players[index]["is_active"] = true
	selected_entity = players[index]
	selected_cell   = Vector2i(players[index]["x"], players[index]["y"])
	selected_spell  = null
	entity_selected.emit(selected_entity)
	player_changed.emit(current_player_index)
	_refresh_grid()


func _end_player_turn() -> void:
	for p: Dictionary in players:
		if int(p["current_pv"]) > 0:
			p["current_pa"] = p["max_pa"]
			p["current_pm"] = p["max_pm"]
	current_turn = 1
	selected_spell = null
	turn_changed.emit(current_turn)
	message_requested.emit("Tour des ennemis…")
	_refresh_grid()


func start_player_turn() -> void:
	current_turn = 0
	turn_count  += 1
	for p: Dictionary in players:
		if int(p["current_pv"]) > 0:
			p["current_pa"] = p["max_pa"]
			p["current_pm"] = p["max_pm"]
	var first_alive: int = 0
	for i: int in range(players.size()):
		if int(players[i]["current_pv"]) > 0:
			first_alive = i
			break
	_set_active_player(first_alive)
	turn_changed.emit(current_turn)
	player_changed.emit(current_player_index)
	message_requested.emit("Tour %d — À vous !" % turn_count)
	check_game_over()


# ═══════════════════════════════════════════════════════
#  UTILITAIRES
# ═══════════════════════════════════════════════════════

func remove_entity_from_grid(entity: Dictionary) -> void:
	var ex: int = int(entity.get("x", -1))
	var ey: int = int(entity.get("y", -1))
	if _is_valid(Vector2i(ex, ey)):
		grid[ey][ex] = null
	entity["current_pv"] = 0
	var msg: String = ""
	if entity.get("entity_type", "") == "Enemy":
		msg = "%s est vaincu !" % entity.get("name", "Ennemi")
		var new_enemies: Array = []
		for e: Dictionary in enemies:
			if int(e["current_pv"]) > 0:
				new_enemies.append(e)
		enemies = new_enemies
	else:
		msg = "%s est mort !" % entity.get("name", "Joueur")
		var new_players: Array = []
		for p: Dictionary in players:
			if int(p["current_pv"]) > 0:
				new_players.append(p)
		players = new_players
	message_requested.emit(msg)
	check_game_over()
	_refresh_grid()


func check_game_over() -> void:
	var alive_p: int = 0
	for p: Dictionary in players:
		if int(p["current_pv"]) > 0:
			alive_p += 1
	var alive_e: int = 0
	for e: Dictionary in enemies:
		if int(e["current_pv"]) > 0:
			alive_e += 1
	if alive_p == 0:
		game_over = true; victory = false
		game_ended.emit(false)
		message_requested.emit("Tous vos personnages sont morts. DÉFAITE !")
	elif alive_e == 0:
		game_over = true; victory = true
		game_ended.emit(true)
		message_requested.emit("Tous les ennemis sont vaincus ! VICTOIRE !")


func reset_game() -> void:
	game_over = false; victory = false
	selected_spell = null; selected_entity = null
	current_turn = 0; current_player_index = 0; turn_count = 1
	init_grid()
	init_entities()
	turn_changed.emit(current_turn)
	if players.size() > 0:
		_set_active_player(0)
	_refresh_grid()


func _is_valid(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < GRID_SIZE and pos.y >= 0 and pos.y < GRID_SIZE


func _refresh_grid() -> void:
	var gm: Node = get_node_or_null("/root/Main/GridManager")
	if gm:
		gm.update_entity_display()
