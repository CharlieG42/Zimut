extends Node2D

const GRID_SIZE := 8
const CELL_SIZE := 140
const PLAYER_START := Vector2i(0, 0)

@onready var player_node: Area2D
@onready var ui: Control
@onready var game_manager: Node

var grid := []
var turn_count := 0
var hunger := 100
var thirst := 100

func _ready():
	_setup_grid()
	_setup_player()
	_setup_ui()
	_setup_game_manager()

func _setup_grid():
	for y in range(GRID_SIZE):
		grid.append([])
		for x in range(GRID_SIZE):
			grid[y].append(_create_tile(Vector2i(x, y)))

func _create_tile(position: Vector2i) -> Node2D:
	var tile := Node2D.new()
	tile.name = "Tile_%d_%d" % [position.x, position.y]
	tile.position = Vector2(position.x * CELL_SIZE, position.y * CELL_SIZE)
	add_child(tile)

	var sprite := Sprite2D.new()
	sprite.texture = load("res://assets/sprites/elements/grass.png")
	tile.add_child(sprite)

	if randf() < 0.2:
		_add_obstacle(tile)
	elif randf() < 0.1:
		_add_collectible(tile, "berries")
	elif randf() < 0.1:
		_add_collectible(tile, "water")
	return tile

func _add_obstacle(tile: Node2D):
	var obstacle := Area2D.new()
	obstacle.name = "Obstacle"
	obstacle.position = Vector2(CELL_SIZE / 2, CELL_SIZE / 2)

	var sprite := Sprite2D.new()
	sprite.texture = load("res://assets/sprites/elements/rock.png")
	obstacle.add_child(sprite)

	var collision := CollisionShape2D.new()
	collision.shape = RectangleShape2D.new()
	collision.shape.size = Vector2(CELL_SIZE, CELL_SIZE)
	obstacle.add_child(collision)
	tile.add_child(obstacle)

func _add_collectible(tile: Node2D, type: String):
	var collectible := Area2D.new()
	collectible.name = "Collectible_%s" % type
	collectible.position = Vector2(CELL_SIZE / 2, CELL_SIZE / 2)
	collectible.set_meta("type", type)

	var sprite := Sprite2D.new()
	sprite.texture = load("res://assets/sprites/elements/%s.png" % type)
	collectible.add_child(sprite)

	var collision := CollisionShape2D.new()
	collision.shape = RectangleShape2D.new()
	collision.shape.size = Vector2(CELL_SIZE, CELL_SIZE)
	collectible.add_child(collision)
	tile.add_child(collectible)

func _setup_player():
	player_node = Area2D.new()
	player_node.name = "Player"
	player_node.position = Vector2(
		PLAYER_START.x * CELL_SIZE,
		PLAYER_START.y * CELL_SIZE
	)
	player_node.set_script(load("res://scripts/player.gd"))
	add_child(player_node)

func _setup_ui():
	ui = Control.new()
	ui.name = "UI"
	ui.anchor_right = 1.0
	ui.anchor_top = 0.0
	ui.margin_right = -10
	ui.margin_top = 10

	var vbox := VBoxContainer.new()
	vbox.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	ui.add_child(vbox)

	var hunger_label := Label.new()
	hunger_label.text = "Hunger: %d" % hunger
	vbox.add_child(hunger_label)

	var thirst_label := Label.new()
	thirst_label.text = "Thirst: %d" % thirst
	vbox.add_child(thirst_label)

	var turn_label := Label.new()
	turn_label.text = "Turns: %d" % turn_count
	vbox.add_child(turn_label)

	var restart_button := Button.new()
	restart_button.text = "Restart"
	restart_button.pressed.connect(_on_restart_pressed)
	vbox.add_child(restart_button)

	var quit_button := Button.new()
	quit_button.text = "Quit"
	quit_button.pressed.connect(_on_quit_pressed)
	vbox.add_child(quit_button)

	add_child(ui)

func _setup_game_manager():
	game_manager = Node.new()
	game_manager.name = "GameManager"
	game_manager.set_script(load("res://scripts/game_manager.gd"))
	add_child(game_manager)

func _on_restart_pressed():
	get_tree().reload_current_scene()

func _on_quit_pressed():
	get_tree().quit()

func end_turn():
	turn_count += 1
	hunger = max(0, hunger - 5)
	thirst = max(0, thirst - 5)

	if hunger <= 0 or thirst <= 0:
		game_manager.emit_signal("defeat")

	ui.get_node("VBoxContainer/Label").text = "Hunger: %d" % hunger
	ui.get_node("VBoxContainer/Label2").text = "Thirst: %d" % thirst
	ui.get_node("VBoxContainer/Label3").text = "Turns: %d" % turn_count