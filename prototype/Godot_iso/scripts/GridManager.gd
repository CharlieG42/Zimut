extends Node2D
class_name GridManager
## GridManager.gd - Gestion de la grille isométrique

const CELL_SIZE := Vector2i(64, 32)
const HALF_CELL := Vector2(32, 16)

var game_manager
var cell_nodes: Array = []

signal cell_clicked(x: int, y: int)


func init(manager):
    game_manager = manager
    _create_grid()


func _create_grid():
    """Create isometric grid display with Node2D cells"""
    cell_nodes = []
    
    for y in range(game_manager.GRID_SIZE):
        var row: Array = []
        for x in range(game_manager.GRID_SIZE):
            var cell = preload("res://scripts/Cell.gd").new()
            var screen_pos = grid_to_screen(Vector2i(x, y))
            cell.position = screen_pos
            cell.grid_position = Vector2i(x, y)
            cell.connect("cell_clicked", Callable(self, "_on_cell_clicked"))
            add_child(cell)
            row.append(cell)
        cell_nodes.append(row)
    
    update_entity_display()


func grid_to_screen(grid_pos: Vector2i) -> Vector2:
    """Convert grid coordinates to isometric screen coordinates"""
    var x = grid_pos.x
    var y = grid_pos.y
    # Isometric projection - using float() to avoid integer division warnings
    var screen_x = float(x - y) * CELL_SIZE.x / 2.0
    var screen_y = float(x + y) * CELL_SIZE.y / 2.0
    # Center the grid on screen
    screen_x += 960.0 - (float(game_manager.GRID_SIZE) * CELL_SIZE.x / 4.0)
    screen_y += 540.0 - (float(game_manager.GRID_SIZE) * CELL_SIZE.y / 4.0)
    return Vector2(screen_x, screen_y)


func screen_to_grid(screen_pos: Vector2) -> Vector2i:
    """Convert screen coordinates to grid coordinates"""
    var x_screen = screen_pos.x - (960.0 - (float(game_manager.GRID_SIZE) * CELL_SIZE.x / 4.0))
    var y_screen = screen_pos.y - (540.0 - (float(game_manager.GRID_SIZE) * CELL_SIZE.y / 4.0))
    
    var grid_x = (x_screen / (CELL_SIZE.x / 2.0) + y_screen / (CELL_SIZE.y / 2.0)) / 2.0
    var grid_y = (y_screen / (CELL_SIZE.y / 2.0) - x_screen / (CELL_SIZE.x / 2.0)) / 2.0
    
    return Vector2i(round(grid_x), round(grid_y))


func _on_cell_clicked(x: int, y: int):
    emit_signal("cell_clicked", x, y)


func update_entity_display():
    """Update all cell nodes to reflect current grid state"""
    for y in range(game_manager.GRID_SIZE):
        for x in range(game_manager.GRID_SIZE):
            if y < cell_nodes.size() and x < cell_nodes[y].size():
                var cell_node = cell_nodes[y][x]
                var entity = game_manager.grid[y][x]
                cell_node.entity = entity
                cell_node.selected = (game_manager.selected_cell == Vector2i(x, y))
                cell_node.highlighted = false
                
                # Highlight current player
                var current_player = null
                if game_manager.current_turn == 0 and game_manager.players.size() > game_manager.current_player_index:
                    current_player = game_manager.players[game_manager.current_player_index]
                
                if current_player and current_player["x"] == x and current_player["y"] == y:
                    cell_node.highlighted = true
                
                cell_node.update_appearance()


func get_cell_node_at(grid_pos: Vector2i) -> Node2D:
    """Return the cell node at the given grid position"""
    if grid_pos.y < cell_nodes.size() and grid_pos.x < cell_nodes[grid_pos.y].size():
        return cell_nodes[grid_pos.y][grid_pos.x]
    return null
