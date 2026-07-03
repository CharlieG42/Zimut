extends Node2D

const GRID_SIZE := 8
const CELL_SIZE := 140
const PLAYER_START := Vector2i(0, 0)
const SAVE_FILE := "user://savegame.save"

@onready var player_node: Area2D
@onready var ui: Control
@onready var game_manager: Node
@onready var game_over_panel: CanvasLayer
@onready var victory_panel: CanvasLayer
@onready var quest_manager: QuestManager

var grid := []
var turn_count := 0
var hunger := 100
var thirst := 100
var game_over := false
var all_quests_completed := false
var victories := 0
var defeats := 0

func _ready():
	_setup_grid()
	_setup_player()
	_setup_ui()
	_setup_game_manager()
	_setup_game_over_panel()
	_setup_victory_panel()
	_setup_quest_manager()
	print("[World] pret. Node racine='", name, "'")

func _setup_grid():
	for y in range(GRID_SIZE):
		grid.append([])
		for x in range(GRID_SIZE):
			grid[y].append(_create_tile(Vector2i(x, y)))

func _create_tile(pos: Vector2i) -> Node2D:
	var tile := Node2D.new()
	tile.name = "Tile_%d_%d" % [pos.x, pos.y]
	tile.position = Vector2(float(pos.x) * CELL_SIZE, float(pos.y) * CELL_SIZE)
	add_child(tile)
	var sprite := Sprite2D.new()
	sprite.texture = load("res://assets/sprites/elements/grass.png")
	sprite.position = Vector2(CELL_SIZE / 2, CELL_SIZE / 2)
	tile.add_child(sprite)
	if pos != PLAYER_START:
		if randf() < 0.1:
			_add_obstacle(tile)
		elif randf() < 0.05:
			_add_collectible(tile, "berries")
		elif randf() < 0.05:
			_add_collectible(tile, "water")
	return tile

func _count_collectibles() -> Dictionary:
	var counts: Dictionary = {"berries": 0, "water": 0}
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			var tile: Node2D = grid[y][x]
			for child in tile.get_children():
				if child.name.begins_with("Collectible_") and child.has_meta("type"):
					var type: String = child.get_meta("type") as String
					if counts.has(type):
						counts[type] += 1
	return counts

func _add_obstacle(tile: Node2D):
	var obstacle := Area2D.new()
	obstacle.name = "Obstacle"
	var sprite := Sprite2D.new()
	sprite.texture = load("res://assets/sprites/elements/rock.png")
	sprite.position = Vector2(CELL_SIZE / 2, CELL_SIZE / 2)
	obstacle.add_child(sprite)
	var collision := CollisionShape2D.new()
	collision.shape = RectangleShape2D.new()
	collision.shape.size = Vector2(CELL_SIZE, CELL_SIZE)
	obstacle.add_child(collision)
	tile.add_child(obstacle)

func _add_collectible(tile: Node2D, type: String):
	var collectible := Area2D.new()
	collectible.name = "Collectible_%s" % type
	var sprite := Sprite2D.new()
	sprite.texture = load("res://assets/sprites/elements/%s.png" % type)
	sprite.position = Vector2(CELL_SIZE / 2, CELL_SIZE / 2)
	collectible.add_child(sprite)
	var collision := CollisionShape2D.new()
	collision.shape = RectangleShape2D.new()
	collision.shape.size = Vector2(CELL_SIZE, CELL_SIZE)
	collectible.add_child(collision)
	collectible.set_meta("type", type)
	tile.add_child(collectible)

func _setup_player():
	player_node = Area2D.new()
	player_node.name = "Player"
	player_node.position = Vector2(PLAYER_START.x * CELL_SIZE, PLAYER_START.y * CELL_SIZE)
	player_node.set_script(load("res://scripts/player.gd"))
	add_child(player_node)
	player_node.move_request.connect(_on_player_move_request)
	player_node.collect.connect(_on_player_collect)

func _setup_ui():
	var layer := CanvasLayer.new()
	layer.name = "UILayer"
	add_child(layer)
	ui = Control.new()
	ui.name = "UI"
	ui.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ui.position = Vector2(10, get_viewport_rect().size.y - 280)
	var vbox := VBoxContainer.new()
	vbox.name = "StatsContainer"
	vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	ui.add_child(vbox)
	
	# Stats label
	var hunger_label := Label.new()
	hunger_label.name = "HungerLabel"
	hunger_label.text = "Hunger: %d" % hunger
	vbox.add_child(hunger_label)
	
	var thirst_label := Label.new()
	thirst_label.name = "ThirstLabel"
	thirst_label.text = "Thirst: %d" % thirst
	vbox.add_child(thirst_label)
	
	var turn_label := Label.new()
	turn_label.name = "TurnLabel"
	turn_label.text = "Turns: %d" % turn_count
	vbox.add_child(turn_label)
	
	var quest_objectives_label := Label.new()
	quest_objectives_label.name = "QuestObjectivesLabel"
	quest_objectives_label.text = "Objectifs: -"
	vbox.add_child(quest_objectives_label)
	
	var stats_label := Label.new()
	stats_label.name = "StatsLabel"
	stats_label.text = "V: %d | D: %d" % [victories, defeats]
	vbox.add_child(stats_label)
	
	var debug_label := Label.new()
	debug_label.name = "DebugLabel"
	debug_label.text = "Debug: -"
	vbox.add_child(debug_label)
	
	var message_label := Label.new()
	message_label.name = "MessageLabel"
	message_label.visible = false
	ui.add_child(message_label)
	
	# Buttons container
	var buttons_hbox := HBoxContainer.new()
	buttons_hbox.name = "ButtonsContainer"
	buttons_hbox.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	vbox.add_child(buttons_hbox)
	
	var new_game_button := Button.new()
	new_game_button.text = "Nouvelle partie"
	new_game_button.mouse_filter = Control.MOUSE_FILTER_STOP
	new_game_button.pressed.connect(_on_new_game_pressed)
	buttons_hbox.add_child(new_game_button)
	
	var save_button := Button.new()
	save_button.text = "Sauvegarder"
	save_button.mouse_filter = Control.MOUSE_FILTER_STOP
	save_button.pressed.connect(_on_save_pressed)
	buttons_hbox.add_child(save_button)
	
	var load_button := Button.new()
	load_button.text = "Charger"
	load_button.mouse_filter = Control.MOUSE_FILTER_STOP
	load_button.pressed.connect(_on_load_pressed)
	buttons_hbox.add_child(load_button)
	
	var quit_button := Button.new()
	quit_button.text = "Quitter"
	quit_button.mouse_filter = Control.MOUSE_FILTER_STOP
	quit_button.pressed.connect(_on_quit_pressed)
	buttons_hbox.add_child(quit_button)
	
	layer.add_child(ui)

func _setup_game_over_panel():
	var layer := CanvasLayer.new()
	layer.name = "GameOverLayer"
	add_child(layer)
	var background := ColorRect.new()
	background.name = "GameOverBackground"
	background.color = Color(0, 0, 0, 0.7)
	background.anchor_right = 1.0
	background.anchor_bottom = 1.0
	background.size = get_viewport_rect().size
	layer.add_child(background)
	var panel := VBoxContainer.new()
	panel.name = "GameOverPanel"
	panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	panel.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	background.add_child(panel)
	var title_label := Label.new()
	title_label.name = "GameOverTitle"
	title_label.text = "Game Over !"
	title_label.add_theme_color_override("font_color", Color.RED)
	title_label.add_theme_font_size_override("font_size", 32)
	panel.add_child(title_label)
	var message_label_go := Label.new()
	message_label_go.name = "GameOverMessage"
	message_label_go.text = "Faim ou soif a 0..."
	message_label_go.add_theme_font_size_override("font_size", 24)
	panel.add_child(message_label_go)
	var restart_btn := Button.new()
	restart_btn.name = "GameOverRestart"
	restart_btn.text = "Recommencer"
	restart_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	restart_btn.pressed.connect(_on_new_game_pressed)
	panel.add_child(restart_btn)
	var quit_btn := Button.new()
	quit_btn.name = "GameOverQuit"
	quit_btn.text = "Quitter"
	quit_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	quit_btn.pressed.connect(_on_quit_pressed)
	panel.add_child(quit_btn)
	layer.visible = false
	game_over_panel = layer

func _setup_victory_panel():
	var layer := CanvasLayer.new()
	layer.name = "VictoryLayer"
	add_child(layer)
	var background := ColorRect.new()
	background.name = "VictoryBackground"
	background.color = Color(0, 0, 0, 0.7)
	background.anchor_right = 1.0
	background.anchor_bottom = 1.0
	background.size = get_viewport_rect().size
	layer.add_child(background)
	var panel := VBoxContainer.new()
	panel.name = "VictoryPanel"
	panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	panel.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	background.add_child(panel)
	var title_label := Label.new()
	title_label.name = "VictoryTitle"
	title_label.text = "Victoire !"
	title_label.add_theme_color_override("font_color", Color.GREEN)
	title_label.add_theme_font_size_override("font_size", 32)
	panel.add_child(title_label)
	var message_label_v := Label.new()
	message_label_v.name = "VictoryMessage"
	message_label_v.text = "Toutes les quetes sont terminees !"
	message_label_v.add_theme_font_size_override("font_size", 24)
	panel.add_child(message_label_v)
	var restart_btn := Button.new()
	restart_btn.name = "VictoryRestart"
	restart_btn.text = "Recommencer"
	restart_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	restart_btn.pressed.connect(_on_new_game_pressed)
	panel.add_child(restart_btn)
	var quit_btn := Button.new()
	quit_btn.name = "VictoryQuit"
	quit_btn.text = "Quitter"
	quit_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	quit_btn.pressed.connect(_on_quit_pressed)
	panel.add_child(quit_btn)
	layer.visible = false
	victory_panel = layer

func _setup_quest_manager():
	var qm := Node.new()
	qm.name = "QuestManager"
	qm.set_script(load("res://scripts/QuestManager.gd"))
	add_child(qm)
	quest_manager = qm
	quest_manager.player_node = player_node
	quest_manager.world_node = self
	
	# Count actual collectibles on the grid
	var collectible_counts = _count_collectibles()
	
	# Clamp collect objectives to actual available collectibles
	for quest_id in quest_manager.available_quests:
		var quest_data = quest_manager.available_quests[quest_id]
		for i in range(quest_data["objectives"].size()):
			var obj = quest_data["objectives"][i]
			var obj_type = obj.get("type", "")
			var target = obj.get("target", "")
			var required = obj.get("required", 0)
			
			if obj_type == "collect" and collectible_counts.has(target):
				var available = collectible_counts[target]
				if required > available:
					obj["required"] = available
					print("[World] Clamped collect objective for ", target, " from ", required, " to ", available)
			elif obj_type == "visit":
				var max_cells = GRID_SIZE * GRID_SIZE
				if required > max_cells:
					obj["required"] = max_cells
					print("[World] Clamped visit objective from ", required, " to ", max_cells)
	
	quest_manager.start_all_quests()
	quest_manager.quest_completed.connect(_on_quest_completed)
	update_ui()

func update_ui():
	ui.get_node("StatsContainer/HungerLabel").text = "Hunger: %d" % hunger
	ui.get_node("StatsContainer/ThirstLabel").text = "Thirst: %d" % thirst
	ui.get_node("StatsContainer/TurnLabel").text = "Turns: %d" % turn_count
	ui.get_node("StatsContainer/StatsLabel").text = "V: %d | D: %d" % [victories, defeats]
	if quest_manager:
		var objectives_text = "Objectifs: "
		var first_obj = true
		for quest_id in quest_manager.active_quests:
			var quest = quest_manager.active_quests[quest_id]
			var obj_text = quest.get_progress_text()
			if not first_obj:
				objectives_text += ", "
			else:
				first_obj = false
			objectives_text += obj_text
		ui.get_node("StatsContainer/QuestObjectivesLabel").text = objectives_text

func _set_debug(text: String):
	if ui and ui.has_node("StatsContainer/DebugLabel"):
		ui.get_node("StatsContainer/DebugLabel").text = "Debug: %s" % text

func _setup_game_manager():
	game_manager = Node.new()
	game_manager.name = "GameManager"
	game_manager.set_script(load("res://scripts/game_manager.gd"))
	add_child(game_manager)
	game_manager.world = self

func show_game_over():
	if game_over_panel:
		game_over_panel.visible = true

func hide_game_over():
	if game_over_panel:
		game_over_panel.visible = false

func show_victory():
	if victory_panel:
		victory_panel.visible = true

func hide_victory():
	if victory_panel:
		victory_panel.visible = false

func _on_game_victory():
	victories += 1
	show_victory()

func _on_game_defeat():
	defeats += 1
	show_game_over()
	if player_node:
		player_node.can_move = false

func _on_quest_completed(quest_id: String):
	if quest_manager:
		var active_count = quest_manager.active_quests.size()
		if active_count == 0 and quest_manager.completed_quests.size() > 0:
			all_quests_completed = true
			game_over = true
			game_manager.emit_signal("victory")

func _on_player_collect(item_type: String):
	if item_type == "berries":
		hunger = min(100, hunger + 20)
		if quest_manager:
			quest_manager.update_quest("find_berries", "collect", 1)
	elif item_type == "water":
		thirst = min(100, thirst + 20)
		if quest_manager:
			quest_manager.update_quest("find_water", "collect", 1)
	update_ui()

func _on_player_move_request(direction: Vector2i):
	if game_over or all_quests_completed:
		return
	var current_pos: Vector2i = player_node.position_grid
	var new_position: Vector2i = current_pos + direction
	if new_position.x < 0 or new_position.x >= GRID_SIZE or new_position.y < 0 or new_position.y >= GRID_SIZE:
		_set_debug("hors grille %s" % str(new_position))
		player_node.can_move = true
		return
	var target_tile: Node2D = grid[new_position.y][new_position.x]
	var has_obstacle := false
	for child in target_tile.get_children():
		if child.name == "Obstacle":
			has_obstacle = true
			break
	if has_obstacle:
		print("[World] Mouvement bloque : rocher en ", new_position)
		_set_debug("bloque par rocher en %s" % str(new_position))
		player_node.can_move = true
		return
	player_node.move_to_grid_position(new_position)
	_set_debug("deplace vers %s" % str(new_position))
	for child in target_tile.get_children():
		if child.name.begins_with("Collectible_") and child.has_meta("type"):
			var type: String = child.get_meta("type") as String
			var collectible = child
			if type == "berries":
				hunger = min(100, hunger + 20)
				if quest_manager:
					quest_manager.update_quest("find_berries", "collect", 1)
			elif type == "water":
				thirst = min(100, thirst + 20)
				if quest_manager:
					quest_manager.update_quest("find_water", "collect", 1)
			collectible.queue_free()
	end_turn()

func _on_new_game_pressed():
	delete_save()
	hide_game_over()
	hide_victory()
	get_tree().reload_current_scene()

func _on_save_pressed():
	save_game()
	_set_debug("Partie sauvegardee")

func _on_load_pressed():
	if load_game():
		_set_debug("Partie chargee")
	else:
		_set_debug("Aucune sauvegarde")

func _on_quit_pressed():
	get_tree().quit()

func end_turn():
	turn_count += 1
	hunger = max(0, hunger - 5)
	thirst = max(0, thirst - 5)
	if hunger <= 0 or thirst <= 0:
		game_over = true
		game_manager.emit_signal("defeat")
		return
	player_node.can_move = true
	update_ui()

func _input(event):
	if game_over or all_quests_completed:
		return
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		print("[World] event tactile/souris recu: ", event)
		var pressed_pos := Vector2.ZERO
		var is_tap := false
		if event is InputEventScreenTouch and event.pressed:
			pressed_pos = event.position
			is_tap = true
		elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			pressed_pos = event.position
			is_tap = true
		if not is_tap:
			return
		var world_pos: Vector2 = to_local(get_global_mouse_position())
		var target_x: int = int(floor(world_pos.x / CELL_SIZE))
		var target_y: int = int(floor(world_pos.y / CELL_SIZE))
		print("[World] tap ecran=", pressed_pos, " -> monde=", world_pos, " -> case=(", target_x, ",", target_y, ")")
		_set_debug("tap case (%d,%d)" % [target_x, target_y])
		if target_x < 0 or target_x >= GRID_SIZE or target_y < 0 or target_y >= GRID_SIZE:
			return
		if not player_node.can_move:
			return
		var current_pos: Vector2i = player_node.position_grid
		var dx: int = target_x - current_pos.x
		var dy: int = target_y - current_pos.y
		if abs(dx) + abs(dy) == 1:
			player_node.can_move = false
			player_node.move_request.emit(Vector2i(dx, dy))

# ===== SAVE/LOAD SYSTEM =====

func save_game() -> void:
	var save_data := {
		"player_pos": {"x": player_node.position_grid.x, "y": player_node.position_grid.y},
		"hunger": hunger,
		"thirst": thirst,
		"turn_count": turn_count,
		"grid": _serialize_grid(),
		"quests": _serialize_quests(),
		"stats": {"victories": victories, "defeats": defeats}
	}
	var file := FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()
		print("[Save] Game saved to ", SAVE_FILE)

func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_FILE):
		return false
	
	var file := FileAccess.open(SAVE_FILE, FileAccess.READ)
	if not file:
		return false
	
	var json_content := file.get_as_text()
	file.close()
	
	var save_data := JSON.parse_string(json_content)
	if save_data == null:
		return false
	
	# Restore stats
	victories = save_data.get("stats", {}).get("victories", 0)
	defeats = save_data.get("stats", {}).get("defeats", 0)
	
	# Restore player position
	var saved_pos := save_data.get("player_pos", {"x": 0, "y": 0})
	player_node.position_grid = Vector2i(saved_pos.get("x", 0), saved_pos.get("y", 0))
	player_node.position = Vector2(saved_pos.get("x", 0) * CELL_SIZE, saved_pos.get("y", 0) * CELL_SIZE)
	
	# Restore state
	hunger = save_data.get("hunger", 100)
	thirst = save_data.get("thirst", 100)
	turn_count = save_data.get("turn_count", 0)
	
	# Restore grid
	_deserialize_grid(save_data.get("grid", []))
	
	# Restore quests
	_deserialize_quests(save_data.get("quests", {}))
	
	update_ui()
	print("[Save] Game loaded from ", SAVE_FILE)
	return true

func delete_save() -> void:
	if FileAccess.file_exists(SAVE_FILE):
		var file := FileAccess.open(SAVE_FILE, FileAccess.WRITE)
		if file:
			file.store_string("")
			file.close()
		OS.remove(SAVE_FILE)
		print("[Save] Save file deleted")

func _serialize_grid() -> Array:
	var grid_data := []
	for y in range(GRID_SIZE):
		var row_data := []
		for x in range(GRID_SIZE):
			var tile := grid[y][x]
			var tile_data := {"has_obstacle": false, "has_berries": false, "has_water": false}
			for child in tile.get_children():
				if child.name == "Obstacle":
					tile_data["has_obstacle"] = true
				elif child.name.begins_with("Collectible_") and child.has_meta("type"):
					var type := child.get_meta("type") as String
					if type == "berries":
						tile_data["has_berries"] = true
					elif type == "water":
						tile_data["has_water"] = true
			row_data.append(tile_data)
		grid_data.append(row_data)
	return grid_data

func _deserialize_grid(grid_data: Array) -> void:
	# Clear existing grid
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			var tile := grid[y][x]
			for child in tile.get_children():
				if child.name == "Obstacle" or child.name.begins_with("Collectible_"):
					child.queue_free()
	
	# Rebuild grid from save
	for y in range(grid_data.size()):
		for x in range(grid_data[y].size()):
			var tile_data := grid_data[y][x]
			var tile := grid[y][x]
			if tile_data.get("has_obstacle", false):
				_add_obstacle(tile)
			if tile_data.get("has_berries", false):
				_add_collectible(tile, "berries")
			if tile_data.get("has_water", false):
				_add_collectible(tile, "water")

func _serialize_quests() -> Dictionary:
	var quests_data := {}
	if quest_manager:
		for quest_id in quest_manager.active_quests:
			var quest := quest_manager.active_quests[quest_id]
			var quest_save := {
				"id": quest.id,
				"status": quest.status,
				"objectives": []
			}
			for obj in quest.objectives:
				var obj_save := {
					"type": obj.get("type", ""),
					"target": obj.get("target", ""),
					"current": obj.get("current", 0),
					"required": obj.get("required", 0)
				}
				quest_save["objectives"].append(obj_save)
			quests_data[quest_id] = quest_save
	return quests_data

func _deserialize_quests(quests_data: Dictionary) -> void:
	if not quest_manager:
		return
	
	# Reset all quests first
	for quest_id in quest_manager.active_quests:
		var quest := quest_manager.active_quests[quest_id]
		quest.reset()
	
	# Restore quest progress
	for quest_id in quests_data:
		if quest_manager.active_quests.has(quest_id):
			var quest := quest_manager.active_quests[quest_id]
			var quest_save := quests_data[quest_id]
			quest.status = quest_save.get("status", 0)
			for i in range(quest.objectives.size()):
				var obj := quest.objectives[i]
				var obj_save := quest_save.get("objectives", [])[i]
				if obj_save:
					obj["current"] = obj_save.get("current", 0)
