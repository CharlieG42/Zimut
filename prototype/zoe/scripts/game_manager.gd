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
	world._on_game_victory()

func _on_defeat():
	if world == null:
		return
	world._on_game_defeat()
