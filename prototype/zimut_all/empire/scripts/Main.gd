extends Node2D

## Main.gd - Point d'entree de la scene du mode Empire (carte monde).
## EmpireManager et EmpireDataLoader sont des autoloads (cf project.godot).
## La carte monde et l'UI sont construites en code par les sous-managers,
## qui restent enfants de l'autoload : ainsi ils survivent aux allers-retours
## de scene vers la bataille tactique (res://empire/scenes/Battle.tscn).
## Cette scene s'occupe uniquement de la camera et du rafraichissement.

const CAMERA_CENTER := Vector2(840, 540)

@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	if camera:
		camera.position = CAMERA_CENTER
	var empire: Node = get_node_or_null("/root/EmpireManager")
	if empire:
		if empire.has_method("initialize_mode"):
			empire.initialize_mode()
		empire.in_battle = false
		var wmm: Node2D = empire.world_map_manager
		if wmm:
			wmm.visible = true
			wmm.refresh_display()
		if empire.ui_manager and empire.ui_manager.has_method("_refresh_ui_visibility"):
			empire.ui_manager._refresh_ui_visibility()
	print("[Main] Carte Empire prete.")
