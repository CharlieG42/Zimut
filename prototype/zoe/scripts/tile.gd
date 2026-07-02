extends Area2D

# NOTE : ce script n'est actuellement attache a aucun noeud cree dans world.gd
# (les tiles sont des Node2D simples, sans script). Il est corrige ici au cas
# ou tu veuilles l'utiliser plus tard pour du clic case-par-case.

@export var tile_type: String = "grass"
const CELL_SIZE := 140

func _ready():
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if get_global_mouse_position().distance_to(global_position) < 70:
			var world = get_tree().current_scene
			var player = world.get_node("Player")
			var player_grid_pos: Vector2i = player.position_grid
			var this_grid_pos := Vector2i(int(position.x / CELL_SIZE), int(position.y / CELL_SIZE))

			if (player_grid_pos - this_grid_pos).length_squared() == 1:
				player.move_to_grid_position(this_grid_pos)

func _on_body_entered(body):
	pass
