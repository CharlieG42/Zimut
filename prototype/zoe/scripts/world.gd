extends Node2D

const GRID_SIZE := 8
const CELL_SIZE := 140
const PLAYER_START := Vector2i(0, 0)

@onready var player_node: Area2D
@onready var ui: Control
@onready var game_manager: Node
@onready var game_over_panel: CanvasLayer

var grid := []
var turn_count := 0
var hunger := 100
var thirst := 100
var game_over := false

func _ready():
	_setup_grid()
	_setup_player()
	_setup_ui()
	_setup_game_manager()
	_setup_game_over_panel()
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
	ui.position = Vector2(10, get_viewport_rect().size.y - 150)
	var vbox := VBoxContainer.new()
	vbox.name = "StatsContainer"
	vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	ui.add_child(vbox)
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
	var debug_label := Label.new()
	debug_label.name = "DebugLabel"
	debug_label.text = "Debug: -"
	vbox.add_child(debug_label)
	var message_label := Label.new()
	message_label.name = "MessageLabel"
	message_label.visible = false
	ui.add_child(message_label)
	var restart_button := Button.new()
	restart_button.text = "Restart"
	restart_button.mouse_filter = Control.MOUSE_FILTER_STOP
	restart_button.pressed.connect(_on_restart_pressed)
	vbox.add_child(restart_button)
	var quit_button := Button.new()
	quit_button.text = "Quit"
	quit_button.mouse_filter = Control.MOUSE_FILTER_STOP
	quit_button.pressed.connect(_on_quit_pressed)
	vbox.add_child(quit_button)
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
	restart_btn.pressed.connect(_on_restart_pressed)
	panel.add_child(restart_btn)
	var quit_btn := Button.new()
	quit_btn.name = "GameOverQuit"
	quit_btn.text = "Quitter"
	quit_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	quit_btn.pressed.connect(_on_quit_pressed)
	panel.add_child(quit_btn)
	layer.visible = false
	game_over_panel = layer

func update_ui():
	ui.get_node("StatsContainer/HungerLabel").text = "Hunger: %d" % hunger
	ui.get_node("StatsContainer/ThirstLabel").text = "Thirst: %d" % thirst
	ui.get_node("StatsContainer/TurnLabel").text = "Turns: %d" % turn_count

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

func _on_player_collect(item_type: String):
	if item_type == "berries":
		hunger = min(100, hunger + 20)
	elif item_type == "water":
		thirst = min(100, thirst + 20)
	update_ui()

func _on_player_move_request(direction: Vector2i):
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
			if type == "berries":
				hunger = min(100, hunger + 20)
				elif type == "water":
					thirst = min(100, thirst + 20)
				child.queue_free()
	end_turn()

func _on_restart_pressed():
	hide_game_over()
	get_tree().reload_current_scene()

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
	if not player_node.can_move or game_over:
		return
	var current_pos: Vector2i = player_node.position_grid
	var dx: int = target_x - current_pos.x
	var dy: int = target_y - current_pos.y
	if abs(dx) + abs(dy) == 1:
		player_node.can_move = false
		player_node.move_request.emit(Vector2i(dx, dy))