extends Node

# Signaux pour la victoire/defaite
signal victory
signal defeat

func _ready():
	# Connecter les signaux
	connect("victory", Callable(self, "_on_victory"))
	connect("defeat", Callable(self, "_on_defeat"))

func _on_victory():
	var world = get_tree().root.get_node("World")
	world.get_node("UI/MessageLabel").text = "Victoire ! Pierre de la Terre trouvee !"
	world.get_node("UI/MessageLabel").visible = true

func _on_defeat():
	var world = get_tree().root.get_node("World")
	world.get_node("UI/MessageLabel").text = "Game Over ! Faim ou soif a 0..."
	world.get_node("UI/MessageLabel").visible = true
