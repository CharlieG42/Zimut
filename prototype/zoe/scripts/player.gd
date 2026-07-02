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

	# Nécessaire pour que area_entered soit émis
	area_entered.connect(_on_area_entered)

	# DEBUG : confirme que le joueur est bien pret et reçoit l'input
	print("[Player] pret. position_grid=", position_grid, " can_move=", can_move)

func _input(event):
	# DEBUG : log de TOUT event clavier pertinent, meme si can_move est false,
	# pour verifier que les evenements arrivent bien jusqu'ici.
	if event is InputEventKey and event.pressed and not event.echo:
		print("[Player] touche recue: ", event.as_text(), " | can_move=", can_move)

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

func _request_move(direction: Vector2i):
	print("[Player] demande de mouvement: ", direction)
	can_move = false
	move_request.emit(direction)

func move_to_grid_position(new_position: Vector2i):
	position_grid = new_position
	position = Vector2(
		new_position.x * CELL_SIZE,
		new_position.y * CELL_SIZE
	)
	can_move = true
	print("[Player] move_to_grid_position appele. position_grid maintenant=", position_grid, " can_move=", can_move)

func _on_area_entered(area: Area2D):
	if area.name == "Collectible_berries":
		collect.emit("berries")
		area.queue_free()
	elif area.name == "Collectible_water":
		collect.emit("water")
		area.queue_free()
