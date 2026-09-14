extends Node2D
## Main.gd - Point d'entree de la scene du mode Empire.
## EmpireManager et EmpireDataLoader sont des autoloads (cf project.godot).
## La carte monde et l'UI sont construites en code par les sous-managers.
## Cette scene s'occupe uniquement de la camera et du centrage de la carte.

const CAMERA_CENTER := Vector2(840, 540)

@onready var camera: Camera2D = $Camera2D

func _ready() -> void:
	if camera:
		camera.position = CAMERA_CENTER
	# Le WorldMapManager (Node2D) est ajoute comme enfant de l'autoload EmpireManager.
	# On le reparente dans cette scene pour qu'il s'affiche dans le viewport.
	var empire: Node = get_node_or_null("/root/EmpireManager")
	if empire and empire.world_map_manager:
		var wmm: Node2D = empire.world_map_manager
		var old_parent: Node = wmm.get_parent()
		if old_parent:
			old_parent.remove_child(wmm)
		add_child(wmm)
		empire.world_map_manager = wmm
		wmm.refresh_display()
	print("[Main] mode Empire pret.")
