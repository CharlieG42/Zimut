extends Area2D

const GRID_SIZE := 8
const CELL_SIZE := 140

var position_grid: Vector2i = Vector2i(0, 0)
var can_move := true

signal move_request(direction: Vector2i)
signal collect(item_type: String)

func _ready():
	var sprite := Sprite2D.new()
	sprite.texture = load("res://assets/sprites/players/druide.png")
	sprite.position = Vector2(CELL_SIZE / 2, CELL_SIZE / 2)
	add_child(sprite)

	var collision := CollisionShape2D.new()
	collision.shape = RectangleShape2D.new()
	collision.shape.size = Vector2(CELL_SIZE, CELL_SIZE)
	add_child(collision)

func _input(event):
	if not can_move:
		return

	if event.is_action_pressed("ui_right") and position_grid.x < GRID_SIZE - 1:
		_request_move(Vector2i(1, 0))
	elif event.is_action_pressed("ui_left") and position_grid.x > 0:
		_request_move(Vector2i(-1, 0))
	elif event.is_action_pressed("ui_down") and position_grid.y < GRID_SIZE - 1:
		_request_move(Vector2i(0, 1))
	elif event.is_action_pressed("ui_up") and position_grid.y > 0:
		_request_move(Vector2i(0, -1))

func _unhandled_input(event):
	if not can_move:
		return

	# Touch support for Android
	if event is InputEventScreenTouch and event.pressed:
		var world_pos = get_global_mouse_position()
		var target_x = floor(world_pos.x / CELL_SIZE)
		var target_y = floor(world_pos.y / CELL_SIZE)
		
		# Check if touching adjacent cell
		var dx = target_x - position_grid.x
		var dy = target_y - position_grid.y
		
		if abs(dx) + abs(dy) == 1:
			_request_move(Vector2i(dx, dy))

func _request_move(direction: Vector2i):
	var new_position := position_grid + direction
	emit_signal("move_request", direction)
	can_move = false

func move_to_grid_position(new_position: Vector2i):
	position_grid = new_position
	position = Vector2(
		new_position.x * CELL_SIZE,
		new_position.y * CELL_SIZE
	)
	can_move = true

func _on_area_entered(area: Area2D):
	if area.name == "Collectible_berries":
		emit_signal("collect", "berries")
		area.queue_free()
	elif area.name == "Collectible_water":
		emit_signal("collect", "water")
		area.queue_free()