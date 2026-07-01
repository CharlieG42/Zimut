extends Node2D

@onready var grid = $Grid
@onready var player = $Player
@onready var turn_label = $UI/TurnLabel
@onready var faim_label = $UI/FaimLabel
@onready var soif_label = $UI/SoifLabel
@onready var message_label = $UI/MessageLabel
@onready var restart_button = $UI/RestartButton
@onready var quit_button = $UI/QuitButton

var turn_count := 0
var water_positions := []

func _ready():
    # Generer la grille aleatoirement
    generate_grid()
    
    # Connecter les signaux du joueur
    player.connect("moved", Callable(self, "_on_player_moved"))
    player.connect("resource_changed", Callable(self, "_on_resource_changed"))
    
    # Connecter les boutons
    restart_button.connect("pressed", Callable(self, "_on_restart_pressed"))
    quit_button.connect("pressed", Callable(self, "_on_quit_pressed"))
    
    # Initialiser l UI
    update_ui()

func generate_grid():
    # Effacer la grille actuelle
    for child in grid.get_children():
        child.queue_free()
    
    # Scenes a instancier
    var tile_scene = preload("res://scenes/tile.tscn")
    var berries_scene = preload("res://scenes/berries.tscn")
    var water_scene = preload("res://scenes/water.tscn")
    var stone_scene = preload("res://scenes/stone.tscn")
    var rock_scene = preload("res://scenes/rock.tscn")
    var tree_scene = preload("res://scenes/tree.tscn")
    
    # Position de la Pierre de la Terre (objectif)
    var stone_pos = Vector2(randi_range(0, 7), randi_range(0, 7))
    water_positions.clear()
    
    # Generer la grille 8x8
    for y in range(8):
        for x in range(8):
            var current_pos = Vector2(x, y)
            
            # Placer la Pierre de la Terre
            if current_pos == stone_pos:
                var stone = stone_scene.instantiate()
                stone.position = Vector2(x * 140, y * 140)
                grid.add_child(stone)
                continue
            
            # Placer des obstacles (rochers/arbres) - 20% de chance
            if randf() < 0.2:
                var obstacle
                if randf() < 0.5:
                    obstacle = rock_scene.instantiate()
                else:
                    obstacle = tree_scene.instantiate()
                obstacle.position = Vector2(x * 140, y * 140)
                grid.add_child(obstacle)
                continue
            
            # Placer une case de base (herbe)
            var tile = tile_scene.instantiate()
            tile.position = Vector2(x * 140, y * 140)
            grid.add_child(tile)
            
            # Ajouter des collectibles - 15% de chance
            if randf() < 0.15:
                if randf() < 0.5:
                    var berries = berries_scene.instantiate()
                    berries.position = Vector2(x * 140, y * 140)
                    grid.add_child(berries)
                else:
                    var water = water_scene.instantiate()
                    water.position = Vector2(x * 140, y * 140)
                    grid.add_child(water)
                    water_positions.append(current_pos)

func _on_player_moved(new_pos: Vector2):
    turn_count += 1
    update_ui()
    
    # Toutes les 5 tours, faire reapparaitre une source d eau
    if turn_count % 5 == 0 and water_positions.size() > 0:
        var water_scene = preload("res://scenes/water.tscn")
        var pos = water_positions[randi() % water_positions.size()]
        # Verifier qu il n y a pas deja un objet a cette position
        var has_object = false
        for child in grid.get_children():
            if child.position == Vector2(pos.x * 140, pos.y * 140) and not child.is_in_group("obstacle"):
                has_object = true
                break
        if not has_object:
            var water = water_scene.instantiate()
            water.position = Vector2(pos.x * 140, pos.y * 140)
            grid.add_child(water)

func _on_resource_changed():
    update_ui()
    # Verifier la defaite
    if player.get_faim() <= 0 or player.get_soif() <= 0:
        GameManager.emit_signal("defeat")

func update_ui():
    turn_label.text = "Tour: " + str(turn_count)
    faim_label.text = "Faim: " + str(player.get_faim())
    soif_label.text = "Soif: " + str(player.get_soif())
    $UI/FaimBar.value = player.get_faim()
    $UI/SoifBar.value = player.get_soif()

func _on_restart_pressed():
    get_tree().reload_current_scene()

func _on_quit_pressed():
    get_tree().quit()