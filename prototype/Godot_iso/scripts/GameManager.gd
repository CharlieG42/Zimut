extends Node
## GameManager - Logique globale Zimut (version isométrique)
## Autoload configuré dans project.godot
## Tous les types sont explicites pour éviter les warnings/erreurs en mode strict

const GRID_SIZE        := 10
const CELL_SIZE        := Vector2i(100, 100)
const CELL_HALF_OFFSET := Vector2i(50, 50)

## Niveau par défaut pour les joueurs et ennemis
const DEFAULT_PLAYER_LEVEL := 30
const DEFAULT_ENEMY_LEVEL := 30

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


func _ready() -> void:
	# Attendre que DataLoader ait chargé les données
	if not DataLoader.data_loaded:
		# Se connecter au signal du singleton DataLoader
		var data_loader_node = get_node_or_null("/root/DataLoader")
		if data_loader_node:
			(data_loader_node as DataLoader).data_loaded_successfully.connect(_on_data_loaded)
		else:
			push_error("DataLoader node not found in scene tree!")
			# Essayer de charger les données directement
			if DataLoader.load_all_data():
				_on_data_loaded()
			else:
				push_error("Failed to load data!")
		return
	else:
		_on_data_loaded()


## Callback appelé quand les données sont chargées
func _on_data_loaded() -> void:
	init_grid()
	init_entities()
	current_turn = 0
	turn_count   = 1
	turn_changed.emit(current_turn)
	if players.size() > 0:
		var first_alive: int = 0
		for i: int in range(players.size()):
			if players[i]["current_pv"] > 0:
				first_alive = i
				break
		current_player_index = first_alive
		selected_entity = players[current_player_index]
		players[current_player_index]["is_active"] = true
		show_spells = true
		entity_selected.emit(selected_entity)
		player_changed.emit(current_player_index)


# ═══════════════════════════════════════════════════════
#  DONNÉES
# ═══════════════════════════════════════════════════════

## Obtenir les données des classes depuis le DataLoader
func get_classes_data() -> Array:
	return DataLoader.classes_data


## Obtenir les données des sorts depuis le DataLoader
func get_spells_data() -> Array:
	return DataLoader.spells_data


## Obtenir les données des ennemis depuis le DataLoader
func get_enemies_data() -> Array:
	return DataLoader.enemies_data


func init_grid() -> void:
	grid = []
	for _y: int in range(GRID_SIZE):
		var row: Array = []
		for _x: int in range(GRID_SIZE):
			row.append(null)
		grid.append(row)


func init_entities() -> void:
	var player_classes: Array[String]   = ["Tank", "Assassin", "Mage"]
	var player_positions: Array[Vector2i] = [Vector2i(2, 2), Vector2i(2, 3), Vector2i(3, 2)]
	players = []

	# Obtenir les données depuis le DataLoader
	var classes_data := get_classes_data()
	var spells_data := get_spells_data()
	var enemies_data := get_enemies_data()

	for i: int in range(player_classes.size()):
		var classe: String = player_classes[i]
		var pos: Vector2i  = player_positions[i]
		
		# Trouver les données de la classe pour le niveau par défaut
		var class_info: Dictionary = {}
		for data: Dictionary in classes_data:
			if data.get("Classe", "") == classe and int(data.get("Niveau", "0")) == DEFAULT_PLAYER_LEVEL:
				class_info = data
				break
		
		# Si pas trouvé au niveau exact, prendre le niveau le plus proche inférieur
		if class_info.is_empty():
			for data: Dictionary in classes_data:
				if data.get("Classe", "") == classe and int(data.get("Niveau", "0")) <= DEFAULT_PLAYER_LEVEL:
					class_info = data
					break
		
		if not class_info.is_empty():
			var player: Dictionary = {
				"name":         "%s Lv%d" % [classe, DEFAULT_PLAYER_LEVEL],
				"entity_type":  "Player",
				"classe":       classe,
				"level":        DEFAULT_PLAYER_LEVEL,
				"max_pv":       int(class_info.get("Vita (PV)", "60")),
				"current_pv":   int(class_info.get("Vita (PV)", "60")),
				"force":        int(class_info.get("Force (CAC)", "10")),
				"intelligence": int(class_info.get("Intelligence (Magie)", "10")),
				"agility":      int(class_info.get("Agilité (Vit. Atk)", "10")),
				"wisdom":       int(class_info.get("Sagesse (Précision)", "10")),
				"defense":      int(class_info.get("Défense", "10")),
				"max_pa":       int(class_info.get("PA", "5")),
				"current_pa":   int(class_info.get("PA", "5")),
				"max_pm":       int(class_info.get("PM", "3")),
				"current_pm":   int(class_info.get("PM", "3")),
				"x": pos.x, "y": pos.y,
				"spells":    [],
				"is_active": false,
			}
			
			# Ajouter les sorts pour cette classe (niveau requis <= niveau du joueur)
			for spell_info: Dictionary in spells_data:
				if spell_info.get("Classe", "") == classe:
					var required_level := int(spell_info.get("Niveau requis", "1"))
					if required_level <= DEFAULT_PLAYER_LEVEL:
						player["spells"].append({
							"name":           spell_info.get("Nom", "Sort inconnu"),
							"classe":         spell_info.get("Classe", ""),
							"cost_pa":        int(spell_info.get("Coût PA", "1")),
							"cost_pm":        int(spell_info.get("Coût PM", "0")),
							"range":          int(spell_info.get("Portée", "1")),
							"effect":         spell_info.get("Effet", ""),
							"level_required": required_level,
							"spell_type":     spell_info.get("Type", "CAC"),
						})
			
			players.append(player)
			grid[pos.y][pos.x] = player

	# Types d'ennemis à créer
	var enemy_types: Array[String]      = ["Gobelin", "Squelette", "Loup"]
	var enemy_positions: Array[Vector2i] = [Vector2i(7, 7), Vector2i(7, 6), Vector2i(6, 7)]
	enemies = []

	for i: int in range(enemy_types.size()):
		var enemy_type: String    = enemy_types[i]
		var pos: Vector2i         = enemy_positions[i]
		
		# Trouver les données de l'ennemi pour le niveau par défaut
		var enemy_info: Dictionary = {}
		for data: Dictionary in enemies_data:
			if data.get("Type", "") == enemy_type and int(data.get("Niveau", "0")) == DEFAULT_ENEMY_LEVEL:
				enemy_info = data
				break
		
		# Si pas trouvé au niveau exact, prendre le niveau le plus proche inférieur
		if enemy_info.is_empty():
			for data: Dictionary in enemies_data:
				if data.get("Type", "") == enemy_type and int(data.get("Niveau", "0")) <= DEFAULT_ENEMY_LEVEL:
					enemy_info = data
					break
		
		if not enemy_info.is_empty():
			var enemy: Dictionary = {
				"name":         "%s Lv%d" % [enemy_type, DEFAULT_ENEMY_LEVEL],
				"entity_type":  "Enemy",
				"classe":       enemy_type,
				"level":        DEFAULT_ENEMY_LEVEL,
				"max_pv":       int(enemy_info.get("PV", "50")),
				"current_pv":   int(enemy_info.get("PV", "50")),
				"force":        int(enemy_info.get("Attaque", "10")),
				"intelligence": 0,
				"agility":      float(int(enemy_info.get("Attaque", "10"))) / 2.0,
				"wisdom":       0,
				"defense":      int(enemy_info.get("Défense", "5")),
				"max_pa":       int(enemy_info.get("PA", "3")),
				"current_pa":   int(enemy_info.get("PA", "3")),
				"max_pm":       int(enemy_info.get("PM", "2")),
				"current_pm":   int(enemy_info.get("PM", "2")),
				"x": pos.x, "y": pos.y,
			}
			enemies.append(enemy)
			grid[pos.y][pos.x] = enemy


# ═══════════════════════════════════════════════════════
#  GESTION DES CLICS / ACTIONS JOUEUR
# ═══════════════════════════════════════════════════════

func handle_cell_selected(x: int, y: int) -> void:
	if game_over or current_turn != 0:
		return

	var target_pos: Vector2i       = Vector2i(x, y)
	var target_entity              = grid[y][x]
	var current_player: Dictionary = players[current_player_index]
	var player_pos: Vector2i       = Vector2i(int(current_player["x"]), int(current_player["y"]))

	# ── 1. Sort sélectionné → lancer sur la case cliquée ──────────────────
	if selected_spell != null:
		_try_cast_spell(current_player, target_pos, target_entity)
		# Après lancer, effacer le sort et la portée (géré dans _try_cast_spell)
		return

	# ── 2. Clic sur la case du joueur actif → ne rien faire ──────────────
	if target_pos == player_pos:
		return

	# ── 3. Clic sur n'importe quel allié → ignoré (pas de changement de joueur) ──
	for p: Dictionary in players:
		if int(p["x"]) == x and int(p["y"]) == y and int(p["current_pv"]) > 0:
			return

	# ── 4. Clic sur case vide → déplacer le joueur actif ─────────────────
	if target_entity == null:
		_try_move(current_player, target_pos)
		return

	# ── 5. Clic sur ennemi → attaque de base si adjacent ─────────────────
	if target_entity.get("entity_type", "") == "Enemy":
		_try_basic_attack(current_player, target_entity, target_pos)


func _try_move(player: Dictionary, target_pos: Vector2i) -> void:
	var from_pos: Vector2i = Vector2i(player["x"], player["y"])
	var dist: int = abs(target_pos.x - from_pos.x) + abs(target_pos.y - from_pos.y)
	if dist > int(player["current_pm"]):
		message_requested.emit("Pas assez de PM ! (%d requis, %d disponibles)" % [dist, player["current_pm"]])
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
	player_changed.emit(current_player_index)  # Force refresh PA/PM dans UIManager
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
	var raw_dmg: int     = int(attacker["force"]) + (randi() % 5 - 2)
	var actual_dmg: int  = maxi(1, raw_dmg - int(int(target["defense"]) / 2.0))
	target["current_pv"] = int(target["current_pv"]) - actual_dmg
	attacker["current_pa"] = int(attacker["current_pa"]) - 1
	entity_attacked.emit(attacker, target, actual_dmg)
	message_requested.emit("%s attaque %s : %d dégâts !" % [attacker["name"], target["name"], actual_dmg])
	if int(target["current_pv"]) <= 0:
		remove_entity_from_grid(target)
	player_changed.emit(current_player_index)  # Force refresh PA/PM
	_refresh_grid()


func _try_cast_spell(caster: Dictionary, target_pos: Vector2i, target_entity) -> void:
	var spell: Dictionary      = selected_spell
	var spell_range: int       = int(spell.get("range", 1))
	var from_pos: Vector2i     = Vector2i(caster["x"], caster["y"])
	var dist: int              = abs(target_pos.x - from_pos.x) + abs(target_pos.y - from_pos.y)

	if dist > spell_range:
		message_requested.emit("Cible hors de portée (portée %d, distance %d)." % [spell_range, dist])
		selected_spell = null
		_refresh_grid()
		return
	if int(caster["current_pa"]) < int(spell["cost_pa"]) or int(caster["current_pm"]) < int(spell["cost_pm"]):
		message_requested.emit("Ressources insuffisantes pour %s." % spell["name"])
		selected_spell = null
		_refresh_grid()
		return

	var actual_target: Dictionary = {}
	var spell_type: String = spell.get("spell_type", "")
	if spell_type == "Soin":
		if target_entity != null and target_entity.get("entity_type", "") == "Player":
			actual_target = target_entity
		else:
			actual_target = caster
	elif spell_type == "Défense":
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
	# Notifier UIManager d'effacer la portée affichée
	player_changed.emit(current_player_index)
	_refresh_grid()


func _apply_spell(caster: Dictionary, spell: Dictionary, target: Dictionary) -> String:
	var spell_type: String = spell.get("spell_type", "")
	match spell_type:
		"CAC":
			var raw_dmg: int    = int(caster["force"]) + (randi() % 5 - 2)
			var actual_dmg: int = maxi(1, raw_dmg - int(int(target["defense"]) / 2.0))
			target["current_pv"] = int(target["current_pv"]) - actual_dmg
			entity_attacked.emit(caster, target, actual_dmg)
			return "%s utilise %s sur %s : %d dégâts !" % [caster["name"], spell["name"], target["name"], actual_dmg]
		"Magie":
			var raw_dmg: int    = int(caster["intelligence"]) + (randi() % 5 - 2)
			var actual_dmg: int = max(1, raw_dmg)
			target["current_pv"] = int(target["current_pv"]) - actual_dmg
			entity_attacked.emit(caster, target, actual_dmg)
			return "%s utilise %s sur %s : %d dégâts !" % [caster["name"], spell["name"], target["name"], actual_dmg]
		"Défense":
			target["defense"] = int(float(int(target["defense"]) * 3) / 2.0)
			return "%s utilise %s : défense augmentée !" % [caster["name"], spell["name"]]
		"Soin":
			var heal_amount: int = int(caster["intelligence"]) + (randi() % 5 - 2)
			target["current_pv"] = min(int(target["max_pv"]), int(target["current_pv"]) + heal_amount)
			return "%s utilise %s sur %s : +%d PV !" % [caster["name"], spell["name"], target["name"], heal_amount]
	return ""


func handle_spell_selected(spell: Dictionary) -> void:
	if current_turn != 0 or game_over:
		return
	if selected_spell != null and selected_spell == spell:
		selected_spell = null
		message_requested.emit("Sort annulé.")
	else:
		selected_spell = spell
		message_requested.emit("Sort sélectionné : %s. Cliquez sur une cible." % spell.get("name", ""))
	spell_selected.emit(selected_spell)


# ═══════════════════════════════════════════════════════
#  GESTION DES TOURS
# ═══════════════════════════════════════════════════════

func next_player() -> void:
	if game_over or current_turn != 0:
		return
	
	players[current_player_index]["is_active"] = false
	selected_spell = null

	# Trouver le prochain joueur vivant
	var next_index: int = -1
	var first_alive_index: int = -1
	
	# Trouver le premier joueur vivant (pour détecter quand on a fait le tour)
	for i: int in range(players.size()):
		if int(players[i]["current_pv"]) > 0:
			first_alive_index = i
			break
	
	# Trouver le prochain joueur vivant après l'actuel
	for i: int in range(1, players.size() + 1):
		var idx: int = (current_player_index + i) % players.size()
		if int(players[idx]["current_pv"]) > 0:
			next_index = idx
			break

	if next_index == -1:
		# Plus de joueurs vivants → fin du tour des joueurs
		_end_player_turn()
		return

	# Si le prochain joueur est le premier joueur vivant, on a fait le tour complet
	if next_index == first_alive_index:
		# Tous les joueurs vivants ont joué → fin du tour des joueurs
		_end_player_turn()
		return

	# Passer au joueur suivant
	_set_active_player(next_index)
	message_requested.emit("C'est au tour de %s." % players[next_index]["name"])


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
	# Réinitialiser les PA/PM des joueurs pour le prochain tour
	for p: Dictionary in players:
		if int(p["current_pv"]) > 0:
			p["current_pa"] = p["max_pa"]
			p["current_pm"] = p["max_pm"]
	
	# Passer au tour des ennemis
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
	message_requested.emit("Tour %d — À vous de jouer !" % turn_count)
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
	var alive_players: int = 0
	for p: Dictionary in players:
		if int(p["current_pv"]) > 0:
			alive_players += 1
	var alive_enemies: int = 0
	for e: Dictionary in enemies:
		if int(e["current_pv"]) > 0:
			alive_enemies += 1

	if alive_players == 0:
		game_over = true
		victory   = false
		game_ended.emit(false)
		message_requested.emit("Tous vos personnages sont morts. DÉFAITE !")
	elif alive_enemies == 0:
		game_over = true
		victory   = true
		game_ended.emit(true)
		message_requested.emit("Tous les ennemis sont vaincus ! VICTOIRE !")


func reset_game() -> void:
	game_over            = false
	victory              = false
	selected_spell       = null
	selected_entity      = null
	current_turn         = 0
	current_player_index = 0
	turn_count           = 1
	load_data()
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
