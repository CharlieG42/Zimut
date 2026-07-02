extends Node

signal victory
signal defeat

var world: Node2D

func _ready():
	connect("victory", Callable(self, "_on_victory"))
	connect("defeat", Callable(self, "_on_defeat"))

func _on_victory():
	if world == null:
		return
	var label = world.get_node("UILayer/UI/MessageLabel")
	label.text = "Victoire ! Pierre de la Terre trouvee !"
	label.visible = true

func _on_defeat():
	if world == null:
		return
	world.show_game_over()
	if world.player_node:
		world.player_node.can_move = false