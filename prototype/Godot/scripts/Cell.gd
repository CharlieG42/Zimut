extends Control
class_name Cell
## Cell.gd - Représente une case de la grille de jeu

var position: Vector2i = Vector2i(0, 0)
var size: Vector2 = Vector2(64, 64)
var entity: EntityData = null
var selected: bool = false
var highlighted: bool = false

signal cell_clicked(x: int, y: int)


func _ready():
    self.size = size
    connect("mouse_entered", _on_mouse_entered)
    connect("mouse_exited", _on_mouse_exited)
    connect("pressed", _on_pressed)


func _draw():
    var color := Color.LIGHT_GRAY if (position.x + position.y) % 2 == 0 else Color(0.8, 0.8, 0.8)
    draw_rect(Rect2(0, 0, size.x, size.y), color, true)
    draw_rect(Rect2(0, 0, size.x, size.y), Color.BLACK, false, 1)
    
    if entity != null:
        draw_entity()
    
    if selected:
        draw_rect(Rect2(2, 2, size.x - 4, size.y - 4), Color.YELLOW, false, 3)
    
    if highlighted:
        draw_rect(Rect2(0, 0, size.x, size.y), Color(1, 1, 0, 0.5), true)
        draw_rect(Rect2(0, 0, size.x, size.y), Color.YELLOW, false, 3)


func draw_entity():
    var center := Vector2(size.x / 2, size.y / 2)
    var radius := size.x / 3
    
    var color := GameManager.COLORS.get(entity.classe, Color(0.5, 0.5, 0.5))
    draw_circle(center, radius, color, true)
    
    var border_color := Color.BLUE if entity.entity_type == "Player" else Color.RED
    draw_circle(center, radius, border_color, false, 2)
    
    var pv_percentage := entity.current_pv / float(entity.max_pv)
    var bar_width := size.x - 10
    var bar_height := 5
    draw_rect(Rect2(5, 5, bar_width, bar_height), Color.DARK_GRAY, true)
    
    var bar_color := Color.GREEN if pv_percentage > 0.5 else Color.ORANGE if pv_percentage > 0.25 else Color.RED
    draw_rect(Rect2(5, 5, bar_width * pv_percentage, bar_height), bar_color, true)
    
    var level_text := str(entity.level)
    var font := get_theme_font("font", "Label")
    draw_string(font, Vector2(center.x - 5, center.y - 10), level_text, HORIZONTAL_ALIGNMENT_CENTER)
    
    if (entity == GameManager.players[GameManager.current_player_index] and 
        GameManager.current_turn == 0 and 
        entity.entity_type == "Player"):
        var pa_text := "PA:%d/%d" % [entity.current_pa, entity.max_pa]
        var pm_text := "PM:%d/%d" % [entity.current_pm, entity.max_pm]
        draw_string(font, Vector2(center.x - 25, center.y + radius + 10), pa_text, HORIZONTAL_ALIGNMENT_LEFT)
        draw_string(font, Vector2(center.x - 25, center.y + radius + 30), pm_text, HORIZONTAL_ALIGNMENT_LEFT)


func _on_mouse_entered():
    if entity != null:
        get_parent().get_parent().add_message("%s - PV: %d/%d" % [entity.name, entity.current_pv, entity.max_pv])

func _on_mouse_exited():
    pass

func _on_pressed():
    cell_clicked.emit(position.x, position.y)
