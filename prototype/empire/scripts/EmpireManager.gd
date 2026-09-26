extends Node
## EmpireManager.gd - Logique globale du mode Empire / Conquete (autoload)
## Couche strategique macro au-dessus du combat tactique Zimut.
## Orchestre: carte monde, economie, armees, IA des seigneurs, pont de combat.
## Solo / PvE uniquement. Chaque conquete lance le combat tactique Zimut.

const GRID_SIZE := 12
const CELL_SIZE := Vector2i(140, 140)
const SAVE_FILE := "user://empire_save.save"
const TICK_SECONDS := 5.0

const OWNER_NEUTRAL := "neutral"
const OWNER_PLAYER := "player"
const OWNER_AI := "ai"

# Types de villes sur la carte monde
const CITY_CAPITAL := "capital"
const CITY_VILLAGE := "village"
const CITY_FORTRESS := "fortress"

var cities: Array = []          # Array[Dictionary] des villes de la carte
var heroes: Array = []           # Array[Dictionary] des heros recrutes
var resources: Dictionary = {}   # or, fer, bois, magie, venin
var favor_points: int = 0
var player_divinity: String = ""
var game_over: bool = false
var victory: bool = false
var pending_battle: Dictionary = {}  # contexte de la bataille en cours
var in_battle: bool = false          # vrai pendant le combat tactique (suspend les ticks)

# Sous-managers (noeuds enfants)
var world_map_manager: Node
var economy_manager: Node
var army_manager: Node
var ai_manager: Node
var battle_bridge: Node
var ui_manager: Node

var _tick_accumulator: float = 0.0

signal resources_changed(resources: Dictionary)
signal city_changed(city: Dictionary)
signal battle_started(target_city: Dictionary, attacking_army: Dictionary)
signal battle_resolved(victory: bool, target_city: Dictionary)
signal game_ended(victory: bool)
signal message_requested(text: String)

func _ready() -> void:
	resources = {
		"or": 200,
		"fer": 100,
		"bois": 100,
		"magie": 20,
		"venin": 0,
	}
	_setup_managers()
	_init_world()
	print("[EmpireManager] pret. villes=", cities.size())

func _setup_managers() -> void:
	world_map_manager = _add_child_script("res://scripts/WorldMapManager.gd", "WorldMapManager")
	economy_manager = _add_child_script("res://scripts/EconomyManager.gd", "EconomyManager")
	army_manager = _add_child_script("res://scripts/ArmyManager.gd", "ArmyManager")
	ai_manager = _add_child_script("res://scripts/AIManager.gd", "AIManager")
	battle_bridge = _add_child_script("res://scripts/BattleBridge.gd", "BattleBridge")
	ui_manager = _add_child_script("res://scripts/EmpireUIManager.gd", "EmpireUIManager")

	world_map_manager.init(self)
	economy_manager.init(self)
	army_manager.init(self)
	ai_manager.init(self)
	battle_bridge.init(self)
	ui_manager.init(self)

func _add_child_script(script_path: String, node_name: String) -> Node:
	var script: Script = load(script_path)
	var node: Node = script.new()
	node.name = node_name
	add_child(node)
	return node

## Genere la carte monde initiale: capitale du joueur + villages neutres + seigneurs IA.
func _init_world() -> void:
	cities = []
	# Capitale du joueur au centre
	cities.append({
		"id": 0,
		"name": "Capitale",
		"type": CITY_CAPITAL,
		"owner": OWNER_PLAYER,
		"x": GRID_SIZE / 2,
		"y": GRID_SIZE / 2,
		"level": 1,
		"buildings": [],
		"garrison": _default_garrison(5),
	})
	# Quelques villages neutres autour
	var neutral_positions := [Vector2i(2, 3), Vector2i(9, 2), Vector2i(3, 9), Vector2i(10, 9), Vector2i(6, 1)]
	for i: int in range(neutral_positions.size()):
		cities.append({
			"id": i + 1,
			"name": "Village neutre %d" % (i + 1),
			"type": CITY_VILLAGE,
			"owner": OWNER_NEUTRAL,
			"x": neutral_positions[i].x,
			"y": neutral_positions[i].y,
			"level": 1,
			"buildings": [],
			"garrison": _default_garrison(3),
		})
	# Seigneurs IA (forteresses)
	var ai_positions := [Vector2i(1, 1), Vector2i(10, 10), Vector2i(1, 10)]
	for i: int in range(ai_positions.size()):
		cities.append({
			"id": neutral_positions.size() + i + 1,
			"name": "Forteresse %d" % (i + 1),
			"type": CITY_FORTRESS,
			"owner": OWNER_AI,
			"x": ai_positions[i].x,
			"y": ai_positions[i].y,
			"level": 2,
			"buildings": [],
			"garrison": _default_garrison(6),
		})

func _default_garrison(size: int) -> Array:
	# Garnison composee d'unites de base (cf unites.csv / ennemis.csv)
	var garrison: Array = []
	for i: int in range(size):
		garrison.append({
			"name": "Soldat",
			"level": 1,
			"pv": 80,
			"force": 12,
			"defense": 8,
		})
	return garrison

func _process(delta: float) -> void:
	if game_over or in_battle:
		return
	_tick_accumulator += delta
	if _tick_accumulator >= TICK_SECONDS:
		_tick_accumulator = 0.0
		_on_tick()

## Tick economique et IA (pas de timers lourds: production passive reguliere).
func _on_tick() -> void:
	economy_manager.produce_tick()
	ai_manager.process_tick()
	_check_victory()

func _check_victory() -> void:
	var player_cities: int = 0
	var total_cities: int = cities.size()
	for city: Dictionary in cities:
		if city["owner"] == OWNER_PLAYER:
			player_cities += 1
	# Victoire: posseder la majorite des villes OU construire la Merveille (etape 3)
	if player_cities >= total_cities:
		victory = true
		game_over = true
		game_ended.emit(true)

# ── Accesseurs villes ─────────────────────────────────────────────────────

func get_city_at(pos: Vector2i) -> Dictionary:
	for city: Dictionary in cities:
		if city["x"] == pos.x and city["y"] == pos.y:
			return city
	return {}

func get_player_cities() -> Array:
	var result: Array = []
	for city: Dictionary in cities:
		if city["owner"] == OWNER_PLAYER:
			result.append(city)
	return result

func get_capital() -> Dictionary:
	for city: Dictionary in cities:
		if city["type"] == CITY_CAPITAL and city["owner"] == OWNER_PLAYER:
			return city
	return {}

# ── Actions strategiques du joueur ────────────────────────────────────────

## Lance une attaque sur une ville cible avec une armee attaquante.
## Declenche le combat tactique Zimut via BattleBridge.
func attack_city(target_city: Dictionary, attacking_army: Dictionary) -> void:
	if target_city.is_empty():
		message_requested.emit("Aucune ville cible.")
		return
	pending_battle = {
		"target_city": target_city,
		"attacking_army": attacking_army,
	}
	battle_started.emit(target_city, attacking_army)
	# Le combat tactique est un aller-retour de scene : l'UI Empire (CanvasLayer
	# enfant de l'autoload) resterait affichée par-dessus la bataille.
	if ui_manager and ui_manager.has_method("set_ui_visible"):
		ui_manager.set_ui_visible(false)
	if world_map_manager:
		world_map_manager.visible = false
	in_battle = true
	battle_bridge.start_battle(target_city, attacking_army)

## Rapporte l'issue d'une bataille (appele par BattleBridge quand le combat Zimut se termine).
func resolve_battle(battle_victory: bool) -> void:
	if pending_battle.is_empty():
		return
	var target_city: Dictionary = pending_battle["target_city"]
	if battle_victory:
		target_city["owner"] = OWNER_PLAYER
		target_city["garrison"] = _default_garrison(3)
		city_changed.emit(target_city)
		message_requested.emit("%s conquise !" % target_city["name"])
	else:
		# Echec : la garnison de la ville decime une partie de l'armee attaquante.
		if army_manager != null and army_manager.has_method("apply_battle_losses"):
			army_manager.apply_battle_losses()
		message_requested.emit("Echec de la conquete de %s." % target_city["name"])
	battle_resolved.emit(battle_victory, target_city)
	pending_battle = {}
	in_battle = false

## Action de reconnaissance (espionnage) sur une ville cible (emprunt MillionLords).
func scout_city(target_city: Dictionary) -> Dictionary:
	if target_city.is_empty():
		return {}
	return {
		"name": target_city["name"],
		"owner": target_city["owner"],
		"level": target_city["level"],
		"garrison_size": target_city["garrison"].size(),
	}

# ── Sauvegarde (persistance solo, meme philosophie que ZOE) ─────────────────

func save_game() -> bool:
	var file: FileAccess = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file == null:
		push_error("Impossible de sauvegarder l'Empire")
		return false
	file.store_var(resources)
	file.store_var(cities)
	file.store_var(heroes)
	file.store_var(army_manager.army_units)
	file.store_var(favor_points)
	file.store_var(player_divinity)
	file.close()
	return true

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_FILE):
		return false
	var file: FileAccess = FileAccess.open(SAVE_FILE, FileAccess.READ)
	if file == null:
		return false
	resources = file.get_var()
	cities = file.get_var()
	heroes = file.get_var()
	if army_manager:
		army_manager.army_units = file.get_var()
	else:
		file.get_var()
	favor_points = int(file.get_var())
	player_divinity = file.get_var()
	file.close()
	resources_changed.emit(resources)
	city_changed.emit({})
	return true

func delete_save() -> void:
	if FileAccess.file_exists(SAVE_FILE):
		DirAccess.remove_absolute(SAVE_FILE)
