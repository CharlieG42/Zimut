extends Node2D
class_name Cell
## Cell.gd - 80px cells, fond en Sprite2D pour compatibilité Node2D

const CELL_SIZE := 80
const HALF := CELL_SIZE / 2

var grid_position: Vector2i = Vector2i(0, 0)
var entity = null
var selected: bool = false
var highlighted: bool = false

signal cell_clicked(x: int, y: int)


func _ready():
    # Background as Sprite2D with a filled texture (works reliably under Node2D)
    var bg = Sprite2D.new()
    bg.name = "Background"
    bg.centered = false
    bg.position = Vector2.ZERO
    bg.z_index = 0
    add_child(bg)

    var entity_sprite = Sprite2D.new()
    entity_sprite.name = "EntitySprite"
    entity_sprite.centered = true
    entity_sprite.position = Vector2(HALF, HALF)
    entity_sprite.z_index = 1
    entity_sprite.visible = false
    add_child(entity_sprite)

    var border = Sprite2D.new()
    border.name = "Border"
    border.centered = true
    border.position = Vector2(HALF, HALF)
    border.z_index = 2
    border.visible = false
    add_child(border)

    update_appearance()


# utilitaires pour générer textures
func _make_filled_texture(color: Color) -> ImageTexture:
    var img = Image.create(CELL_SIZE, CELL_SIZE, false, Image.FORMAT_RGBA8)
    img.lock()
    img.fill(color)
    img.unlock()
    return ImageTexture.create_from_image(img)

func _make_circle_texture(color: Color, radius: float = 30.0) -> ImageTexture:
    var img = Image.create(CELL_SIZE, CELL_SIZE, false, Image.FORMAT_RGBA8)
    img.lock()
    img.fill(Color(0, 0, 0, 0))
    var center = Vector2(HALF, HALF)
    for x in range(CELL_SIZE):
        for y in range(CELL_SIZE):
            if (Vector2(x, y) - center).length() < radius:
                img.set_pixel(x, y, color)
    img.unlock()
    return ImageTexture.create_from_image(img)

func _make_ring_texture(color: Color, radius: float = 30.0, thickness: float = 2.0) -> ImageTexture:
    var img = Image.create(CELL_SIZE, CELL_SIZE, false, Image.FORMAT_RGBA8)
    img.lock()
    img.fill(Color(0, 0, 0, 0))
    var center = Vector2(HALF, HALF)
    for x in range(CELL_SIZE):
        for y in range(CELL_SIZE):
            var d = (Vector2(x, y) - center).length()
            if d > radius - thickness and d < radius + thickness:
                img.set_pixel(x, y, color)
    img.unlock()
    return ImageTexture.create_from_image(img)


func update_appearance():
    var bg = get_node_or_null("Background") as Sprite2D
    if bg:
        var bg_color = Color.LIGHT_GRAY if (grid_position.x + grid_position.y) % 2 == 0 else Color(0.8, 0.8, 0.8)
        bg.texture = _make_filled_texture(bg_color)

    var entity_sprite = get_node_or_null("EntitySprite") as Sprite2D
    var border = get_node_or_null("Border") as Sprite2D

    if entity:
        var color = GameManager.COLORS.get(entity.get("classe", ""), Color(0.5, 0.5, 0.5))
        if entity_sprite:
            entity_sprite.visible = true
            entity_sprite.texture = _make_circle_texture(color, 30.0)
        if border:
            border.visible = true
            var border_color = Color.BLUE if entity.get("entity_type", "") == "Player" else Color.RED
            if entity.get("is_active", false):
                border_color = Color.YELLOW
            border.texture = _make_ring_texture(border_color, 30.0)
        # selection overlay as Sprite2D
        if selected:
            var sel = get_node_or_null("Selection")
            if not sel:
                sel = Sprite2D.new()
                sel.name = "Selection"
                sel.centered = false
                sel.position = Vector2.ZERO
                sel.z_index = 3
                add_child(sel)
            sel.texture = _make_filled_texture(Color(1, 1, 0, 0.25))
        else:
            if has_node("Selection"):
                get_node("Selection").queue_free()
    else:
        if entity_sprite:
            entity_sprite.visible = false
            entity_sprite.texture = null
        if border:
            border.visible = false
            border.texture = null
        if has_node("Selection"):
            get_node("Selection").queue_free()


func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed and event.button_index == MouseButton.LEFT:
        var local_pos = to_local(get_global_mouse_position())
        if Rect2(Vector2.ZERO, Vector2(CELL_SIZE, CELL_SIZE)).has_point(local_pos):
            emit_signal("cell_clicked", grid_position.x, grid_position.y)
