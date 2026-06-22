extends Node2D
class_name Cell
## Cell.gd - 80px cells, sans highlight bloquant

var grid_position: Vector2i = Vector2i(0, 0)
var entity = null
var selected: bool = false
var highlighted: bool = false

signal cell_clicked(x: int, y: int)


func _ready():
    # Background as a Sprite2D (controls mixed with Node2D can be hidden depending on canvas)
    var bg = Sprite2D.new()
    bg.name = "Background"
    bg.centered = false
    bg.position = Vector2.ZERO
    add_child(bg)

    var entity_sprite = Sprite2D.new()
    entity_sprite.name = "EntitySprite"
    # entity sprites are drawn centered at the cell center
    entity_sprite.position = Vector2(40, 40)
    add_child(entity_sprite)

    var border = Sprite2D.new()
    border.name = "Border"
    border.position = Vector2(40, 40)
    add_child(border)

    update_appearance()


func _create_filled_texture(color: Color) -> ImageTexture:
    var img = Image.create(80, 80, false, Image.FORMAT_RGBA8)
    img.lock()
    for x in range(80):
        for y in range(80):
            img.set_pixel(x, y, color)
    img.unlock()
    var tex = ImageTexture.create_from_image(img)
    return tex


func update_appearance():
    var bg_sprite = get_node_or_null("Background")
    if bg_sprite:
        var bg_color = Color.LIGHT_GRAY if (grid_position.x + grid_position.y) % 2 == 0 else Color(0.8, 0.8, 0.8)
        bg_sprite.texture = _create_filled_texture(bg_color)

    if entity:
        var entity_sprite = get_node_or_null("EntitySprite")
        var border = get_node_or_null("Border")
        var center: Vector2 = Vector2(40, 40)
        var radius: float = 30.0

        if entity_sprite:
            entity_sprite.visible = true
            # draw a filled circle texture for the entity
            var img = Image.create(80, 80, false, Image.FORMAT_RGBA8)
            img.fill(Color(0, 0, 0, 0))
            img.lock()
            var color = GameManager.COLORS.get(entity.get("classe", ""), Color(0.5, 0.5, 0.5))
            for px in range(80):
                for py in range(80):
                    if (Vector2(px, py) - center).length() < radius:
                        img.set_pixel(px, py, color)
            img.unlock()
            entity_sprite.texture = ImageTexture.create_from_image(img)

        if border:
            border.visible = true
            var border_color = Color.BLUE if entity.get("entity_type", "") == "Player" else Color.RED
            if entity.get("is_active", false):
                border_color = Color.YELLOW
            var border_img = Image.create(80, 80, false, Image.FORMAT_RGBA8)
            border_img.fill(Color(0, 0, 0, 0))
            border_img.lock()
            for px in range(80):
                for py in range(80):
                    var dist = (Vector2(px, py) - center).length()
                    if dist > radius - 2 and dist < radius + 2:
                        border_img.set_pixel(px, py, border_color)
            border_img.unlock()
            border.texture = ImageTexture.create_from_image(border_img)

        if selected:
            var select = get_node_or_null("Selection")
            if not select:
                select = Sprite2D.new()
                select.name = "Selection"
                select.position = Vector2.ZERO
                select.centered = false
                add_child(select)
            var select_img = Image.create(80, 80, false, Image.FORMAT_RGBA8)
            select_img.fill(Color(1, 1, 0, 0.3))
            select.texture = ImageTexture.create_from_image(select_img)
        else:
            if has_node("Selection"):
                get_node("Selection").queue_free()

        if has_node("Highlight"):
            get_node("Highlight").queue_free()
    else:
        var entity_sprite = get_node_or_null("EntitySprite")
        var border = get_node_or_null("Border")
        if entity_sprite:
            entity_sprite.visible = false
            entity_sprite.texture = null
        if border:
            border.visible = false
            border.texture = null
        if has_node("Selection"):
            get_node("Selection").queue_free()
        if has_node("Highlight"):
            get_node("Highlight").queue_free()


func _input(event: InputEvent) -> void:
    # Use the global mouse position which is the most reliable for Node2D
    if event is InputEventMouseButton and event.pressed and event.button_index == MouseButton.LEFT:
        var local_pos = to_local(get_global_mouse_position())
        if Rect2(Vector2.ZERO, Vector2(80, 80)).has_point(local_pos):
            emit_signal("cell_clicked", grid_position.x, grid_position.y)
