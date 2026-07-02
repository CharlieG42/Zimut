extends Node

# Signaux pour la victoire/defaite
signal victory
signal defeat

# Reference directe injectee par world.gd (plus fiable que get_node("World"),
# qui plantait car le noeud racine ne s'appelait pas "World")
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
	var label = world.get_node("UILayer/UI/MessageLabel")
	label.text = "Game Over ! Faim ou soif a 0..."
	label.visible = true
	# Bloquer les déplacements après la défaite
	if world.player_node:
		world.player_node.can_move = false
