extends Node2D

var grid_node
var player_node
var turn_label
var faim_label
var soif_label
var faim_bar
var soif_bar
var message_label
var restart_button
var quit_button

var turn_count := 0
var water_positions := []

const GRID_SIZE := 8
const CELL_SIZE := 140

func _ready():
	create_ui()
	grid_node = Node2D.new()
	grid_node.name = "Grid"
	grid_node.position = Vector2(GRID_SIZE * CELL_SIZE / 2, GRID_SIZE * CELL_SIZE / 2)
	add_child(grid_node)
	create_player()
	generate_grid()
	player_node.connect("moved", Callable(self, "_on_player_moved"))
	player_node.connect("resource_changed", Callable(self, "_on_resource_changed"))
	restart_button.connect("pressed", Callable(self, "_on_restart_pressed"))
	quit_button.connect("pressed", Callable(self, "_on_quit_pressed"))
	update_ui()

func create_ui():
	var ui_layer = CanvasLayer.new()
	ui_layer.name = "UI"
	add_child(ui_layer)
	faim_bar = ProgressBar.new()
	faim_bar.name = "FaimBar"
	faim_bar.position = Vector2(20, 20)
	faim_bar.size = Vector2(200, 20)
	faim_bar.value = 100
	faim_bar.max_value = 100
	faim_bar.step = 1
	ui_layer.add_child(faim_bar)
	faim_label = Label.new()
	faim_label.name = "FaimLabel"
	faim_label.position = Vector2(220, 20)
	faim_label.text = "Faim: 100"
	ui_layer.add_child(faim_label)
	soif_bar = ProgressBar.new()
	soif_bar.name = "SoifBar"
	soif_bar.position = Vector2(20, 50)
	soif_bar.size = Vector2(200, 20)
	soif_bar.value = 100
	soif_bar.max_value = 100
	soif_bar.step = 1
	ui_layer.add_child(soif_bar)
	soif_label = Label.new()
	soif_label.name = "SoifLabel"
	soif_label.position = Vector2(220, 50)
	soif_label.text = "Soif: 100"
	ui_layer.add_child(soif_label)
	turn_label = Label.new()
	turn_label.name = "TurnLabel"
	turn_label.position = Vector2(20, 80)
	turn_label.text = "Tour: 0"
	ui_layer.add_child(turn_label)
	restart_button = Button.new()
	restart_button.name = "RestartButton"
	restart_button.position = Vector2(900, 20)
	restart_button.size = Vector2(150, 40)
	restart_button.text = "Recommencer"
	ui_layer.add_child(restart_button)
	quit_button = Button.new()
	quit_button.name = "QuitButton"
	quit_button.position = Vector2(900, 70)
	quit_button.size = Vector2(150, 40)
	quit_button.text = "Quitter"
	ui_layer.add_child(quit_button)
	message_label = Label.new()
	message_label.name = "MessageLabel"
	message_label.position = Vector2(400, 400)
	message_label.text = ""
	message_label.visible = false
	ui_layer.add_child(message_label)

func create_player():
	player_node = Node2D.new()
	player_node.name = "Player"
	player_node.position = Vector2(GRID_SIZE * CELL_SIZE / 2, GRID_SIZE * CELL_SIZE / 2)
	var player_sprite = Sprite2D.new()
	player_sprite.texture = load("res://assets/sprites/druid.png")
	player_sprite.position = Vector2(70, 70)
	player_node.add_child(player_sprite)
	var player_collision = CollisionShape2D.new()
	player_collision.shape = Rect2(60, 60, 70, 70)
	player_node.add_child(player_collision)
	player_node.set_script(load("res://scripts/player.gd"))
	add_child(player_node)
	player_node.position_grid = Vector2(4, 4)

func generate_grid():
	for child in grid_node.get_children():
		child.queue_free()
	water_positions.clear()
	var stone_pos = Vector2(randi_range(0, GRID_SIZE-1), randi_range(0, GRID_SIZE-1))
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			var current_pos = Vector2(x, y)
			var cell_pos = Vector2(x * CELL_SIZE, y * CELL_SIZE)
			if current_pos == stone_pos:
				var stone = create_collectible("res://assets/sprites/stone.png", ["collectible", "stone"], {"is_goal": true})
				stone.position = cell_pos
				grid_node.add_child(stone)
				continue
			if randf() < 0.2:
				var obstacle = Node2D.new()
				obstacle.name = "Obstacle_" + str(x) + "_" + str(y)
				var sprite = Sprite2D.new()
				if randf() < 0.5:
					sprite.texture = load("res://assets/sprites/rock.png")
				else:
					sprite.texture = load("res://assets/sprites/tree.png")
				var collision = CollisionShape2D.new()
				collision.shape = Rect2(0, 0, CELL_SIZE, CELL_SIZE)
				obstacle.add_child(sprite)
				obstacle.add_child(collision)
				obstacle.add_to_group("obstacle")
				grid_node.add_child(obstacle)
				continue
			var tile = create_tile(cell_pos, current_pos)
			grid_node.add_child(tile)
			if randf() < 0.15:
				if randf() < 0.5:
					var berries = create_collectible("res://assets/sprites/berries.png", ["collectible", "berries"], {"value": 10})
					berries.position = cell_pos
					grid_node.add_child(berries)
				else:
					var water = create_collectible("res://assets/sprites/water.png", ["collectible", "water"], {"value": 15})
					water.position = cell_pos
					grid_node.add_child(water)
					water_positions.append(current_pos)

func create_tile(pos: Vector2, grid_pos: Vector2) -> Node2D:
	var tile = Node2D.new()
	tile.name = "Tile_" + str(int(grid_pos.x)) + "_" + str(int(grid_pos.y))
	var tile_sprite = Sprite2D.new()
	tile_sprite.texture = load("res://assets/sprites/grass.png")
	tile.add_child(tile_sprite)
	var tile_collision = CollisionShape2D.new()
	tile_collision.shape = Rect2(0, 0, CELL_SIZE, CELL_SIZE)
	tile.add_child(tile_collision)
	tile.add_to_group("tile")
	var click_area = Area2D.new()
	click_area.name = "ClickArea"
	var click_collision = CollisionShape2D.new()
	click_collision.shape = Rect2(0, 0, CELL_SIZE, CELL_SIZE)
	click_area.add_child(click_collision)
	click_area.connect("input_event", Callable(self, "_on_tile_input").bind(grid_pos))
	tile.add_child(click_area)
	return tile

func create_collectible(texture_path: String, groups: Array, metadata: Dictionary) -> Node2D:
	var collectible = Node2D.new()
	collectible.name = texture_path.get_file().get_basename()
	var sprite = Sprite2D.new()
	sprite.texture = load(texture_path)
	collectible.add_child(sprite)
	var collision = CollisionShape2D.new()
	collision.shape = Rect2(0, 0, CELL_SIZE, CELL_SIZE)
	collectible.add_child(collision)
	for group in groups:
		collectible.add_to_group(group)
	for key in metadata:
		collectible.set_meta(key, metadata[key])
	return collectible

func _on_tile_input(viewport, event, shape_idx, grid_pos: Vector2):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if (player_node.position_grid - grid_pos).length_squared() == 1:
			player_node.move_to_grid_position(grid_pos)

func _on_player_moved(new_pos: Vector2):
	turn_count += 1
	update_ui()
	if turn_count % 5 == 0 and water_positions.size() > 0:
		var pos = water_positions[randi() % water_positions.size()]
		var has_object = false
		for child in grid_node.get_children():
			if child.position == Vector2(pos.x * CELL_SIZE, pos.y * CELL_SIZE) and not child.is_in_group("obstacle"):
				has_object = true
				break
		if not has_object:
			var water = create_collectible("res://assets/sprites/water.png", ["collectible", "water"], {"value": 15})
			water.position = Vector2(pos.x * CELL_SIZE, pos.y * CELL_SIZE)
			grid_node.add_child(water)

func _on_resource_changed():
	update_ui()
	if player_node.get_faim() <= 0 or player_node.get_soif() <= 0:
		GameManager.emit_signal("defeat")

func update_ui():
	turn_label.text = "Tour: " + str(turn_count)
	faim_label.text = "Faim: " + str(player_node.get_faim())
	soif_label.text = "Soif: " + str(player_node.get_soif())
	faim_bar.value = player_node.get_faim()
	soif_bar.value = player_node.get_soif()

func _on_restart_pressed():
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().quit()