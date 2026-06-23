extends Node2D

@onready var tile_map = $TileMap

# Tile IDs
enum TileType {
    GRASS = 0,
    WATER = 1,
    ROCK = 2,
    TREE = 3
}

func _ready():
    var tile_set = tile_map.tile_set
    if tile_set == null:
        push_error("TileSet non chargé ! Configurez-le dans l'éditeur.")
        return
    
    var grid_size = Vector2i(10, 10)
    var map_data = [
        [0, 0, 0, 2, 0, 0, 3, 0, 0, 0],
        [0, 0, 1, 1, 0, 3, 0, 0, 2, 0],
        [0, 0, 0, 0, 0, 0, 0, 1, 1, 0],
        [2, 0, 0, 0, 3, 0, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 1, 1, 0, 0, 0],
        [0, 0, 3, 0, 0, 0, 2, 0, 0, 0],
        [1, 1, 0, 0, 0, 0, 0, 0, 3, 0],
        [0, 0, 0, 2, 0, 0, 0, 0, 0, 0],
        [0, 3, 0, 0, 1, 1, 0, 0, 0, 0],
        [0, 0, 0, 0, 0, 2, 0, 3, 0, 0]
    ]
    
    for y in range(grid_size.y):
        for x in range(grid_size.x):
            var tile_type = map_data[y][x]
            if tile_type != -1:
                tile_map.set_cell(0, Vector2i(x, y), tile_type)
    
    var camera = $Camera2D
    camera.position = Vector2(grid_size.x * 32, grid_size.y * 16)

func _input(event):
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        var mouse_pos = get_global_mouse_position()
        var cell_pos = tile_map.local_to_map(tile_map.to_local(mouse_pos))
        tile_map.set_cell(0, cell_pos, TileType.ROCK)
    
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
        var mouse_pos = get_global_mouse_position()
        var cell_pos = tile_map.local_to_map(tile_map.to_local(mouse_pos))
        tile_map.set_cell(0, cell_pos, TileType.TREE)