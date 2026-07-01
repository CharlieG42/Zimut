extends Area2D

# Ressources du joueur
var faim := 100
var soif := 100
var position_grid := Vector2(0, 0)

# Signal pour notifier le monde qu on a bouge
signal moved(new_pos)
signal resource_changed

func _ready():
    # Initialiser la position centrale
    position = Vector2(560, 448)  # Centre de la grille 8x8 (140*4 = 560)
    position_grid = Vector2(4, 4)  # Milieu de la grille

func move_to_grid_position(new_pos: Vector2):
    # Verifier que la nouvelle position est dans la grille
    if new_pos.x < 0 or new_pos.x >= 8 or new_pos.y < 0 or new_pos.y >= 8:
        return false
    
    # Verifier s il y a un obstacle
    var world = get_parent()
    for child in world.get_node("Grid").get_children():
        if child.position == Vector2(new_pos.x * 140, new_pos.y * 140) and child.is_in_group("obstacle"):
            return false
    
    # Deplacer le joueur
    position = Vector2(new_pos.x * 140, new_pos.y * 140)
    position_grid = new_pos
    
    # Consommer des ressources
    faim -= 2
    soif -= 1
    
    # Emettre les signaux
    emit_signal("moved", new_pos)
    emit_signal("resource_changed")
    
    # Verifier les collisions avec les collectibles
    for area in get_overlapping_areas():
        if area.is_in_group("berries"):
            faim = min(faim + area.get_meta("value", 0), 100)
            area.queue_free()
        elif area.is_in_group("water"):
            soif = min(soif + area.get_meta("value", 0), 100)
            area.queue_free()
        elif area.is_in_group("stone") and area.get_meta("is_goal", false):
            # Victoire !
            GameManager.emit_signal("victory")
    
    return true

func get_faim():
    return faim

func get_soif():
    return soif