extends Area2D

# Type de la case (grass, berries, water, etc.)
@export var tile_type: String = "grass"

func _ready():
    # Detecter les clics sur la case
    set_process_input(true)

func _input(event):
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        if get_global_mouse_position().distance_to(position) < 70:  # Clic sur la case
            var world = get_tree().root.get_node("World")
            var player = world.get_node("Player")
            var player_grid_pos = player.position_grid
            var this_grid_pos = Vector2(position.x / 140, position.y / 140)
            
            # Verifier si la case est adjacente au joueur
            if (player_grid_pos - this_grid_pos).length_squared() == 1:
                # Deplacer le joueur vers cette case
                player.move_to_grid_position(this_grid_pos)

func _on_body_entered(body):
    pass