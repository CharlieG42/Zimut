extends Node2D
class_name Cell
## Cell.gd - Cellule isométrique pour WildZimut
## Version adaptée pour le rendu isométrique 2D

const CELL_SIZE := Vector2i(64, 32)  # Taille des tuiles isométriques
const HALF := Vector2(32, 16)  # Centre de la cellule

var grid_position: Vector2i = Vector2i(0, 0)
var entity = null
var selected: bool = false
var highlighted: bool = false

signal cell_clicked(x: int, y: int)


func _ready():
    # Background as Sprite2D with a filled texture
    var bg = Sprite2D.new()
    bg.name = "Background"
    bg.centered = false
    bg.position = Vector2.ZERO
    bg.z_index = 0
    add_child(bg)

    var entity_sprite = Sprite2D.new()
    entity_sprite.name = "EntitySprite"
    entity_sprite.centered = true
    entity_sprite.position = HALF
    entity_sprite.z_index = 1
    entity_sprite.visible = false
    add_child(entity_sprite)

    var border = Sprite2D.new()
    border.name = "Border"
    border.centered = true
    border.position = HALF
    border.z_index = 2
    border.visible = false
    add_child(border)

    update_appearance()


# Utilitaires pour générer textures (compatible Godot 4.7)
func _make_filled_texture(color: Color) -> ImageTexture:
    var img = Image.create(CELL_SIZE.x, CELL_SIZE.y, false, Image.FORMAT_RGBA8)
    img.fill(color)
    return ImageTexture.create_from_image(img)

func _make_circle_texture(color: Color, radius: float = 25.0) -> ImageTexture:
    var img = Image.create(CELL_SIZE.x, CELL_SIZE.y, false, Image.FORMAT_RGBA8)
    img.fill(Color(0, 0, 0, 0))
    var center = HALF
    for x in range(CELL_SIZE.x):
        for y in range(CELL_SIZE.y):
            if (Vector2(x, y) - center).length() < radius:
                img.set_pixel(x, y, color)
    return ImageTexture.create_from_image(img)

func _make_triangle_texture(color: Color, size: float = 25.0) -> ImageTexture:
    var img = Image.create(CELL_SIZE.x, CELL_SIZE.y, false, Image.FORMAT_RGBA8)
    img.fill(Color(0, 0, 0, 0))
    var center = HALF
    var height = size * 0.866  # Hauteur d'un triangle équilatéral
    var top = center - Vector2(0, height / 2)
    var bottom_left = center + Vector2(-size / 2, height / 2)
    var bottom_right = center + Vector2(size / 2, height / 2)
    
    # Dessiner le triangle
    for x in range(CELL_SIZE.x):
        for y in range(CELL_SIZE.y):
            var point = Vector2(x, y)
            if _point_in_triangle(point, top, bottom_left, bottom_right):
                img.set_pixel(x, y, color)
    return ImageTexture.create_from_image(img)

func _point_in_triangle(p: Vector2, a: Vector2, b: Vector2, c: Vector2) -> bool:
    var v0 = c - a
    var v1 = b - a
    var v2 = p - a
    var dot00 = v0.dot(v0)
    var dot01 = v0.dot(v1)
    var dot02 = v0.dot(v2)
    var dot11 = v1.dot(v1)
    var dot12 = v1.dot(v2)
    var inv_denom = 1.0 / (dot00 * dot11 - dot01 * dot01)
    var u = (dot11 * dot02 - dot01 * dot12) * inv_denom
    var v = (dot00 * dot12 - dot01 * dot02) * inv_denom
    return (u >= 0) and (v >= 0) and (u + v < 1)

func _make_ring_texture(color: Color, radius: float = 25.0, thickness: float = 2.0) -> ImageTexture:
    var img = Image.create(CELL_SIZE.x, CELL_SIZE.y, false, Image.FORMAT_RGBA8)
    img.fill(Color(0, 0, 0, 0))
    var center = HALF
    for x in range(CELL_SIZE.x):
        for y in range(CELL_SIZE.y):
            var d = (Vector2(x, y) - center).length()
            if d > radius - thickness and d < radius + thickness:
                img.set_pixel(x, y, color)
    return ImageTexture.create_from_image(img)


func update_appearance():
    var bg = get_node_or_null("Background") as Sprite2D
    if bg:
        # Damier pour le fond
        var bg_color = Color(0.95, 0.95, 0.95) if (grid_position.x + grid_position.y) % 2 == 0 else Color(0.65, 0.65, 0.65)
        bg.texture = _make_filled_texture(bg_color)

    var entity_sprite = get_node_or_null("EntitySprite") as Sprite2D
    var border = get_node_or_null("Border") as Sprite2D

    if entity:
        var color = GameManager.COLORS.get(entity.get("classe", ""), Color(0.5, 0.5, 0.5))
        if entity_sprite:
            entity_sprite.visible = true
            # Utiliser un cercle pour les joueurs, un triangle pour les ennemis
            if entity.get("entity_type", "") == "Player":
                entity_sprite.texture = _make_circle_texture(color, 25.0)
            else:
                entity_sprite.texture = _make_triangle_texture(color, 25.0)
        if border:
            border.visible = true
            var border_color = Color.BLUE if entity.get("entity_type", "") == "Player" else Color.RED
            if entity.get("is_active", false):
                border_color = Color.YELLOW
            border.texture = _make_ring_texture(border_color, 25.0)
        
        # Selection overlay
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
        
        # Highlight overlay
        if highlighted:
            var hl = get_node_or_null("Highlight")
            if not hl:
                hl = Sprite2D.new()
                hl.name = "Highlight"
                hl.centered = false
                hl.position = Vector2.ZERO
                hl.z_index = 4
                add_child(hl)
            hl.texture = _make_filled_texture(Color(1, 1, 1, 0.3))
        else:
            if has_node("Highlight"):
                get_node("Highlight").queue_free()
    else:
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
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        var local_pos = to_local(get_global_mouse_position())
        # Check if click is within cell bounds (isometric diamond shape)
        if _is_point_in_cell(local_pos):
            emit_signal("cell_clicked", grid_position.x, grid_position.y)


func _is_point_in_cell(point: Vector2) -> bool:
    """Check if a point is within the isometric cell bounds (diamond shape)"""
    var center = HALF
    # For a diamond (rotated square), check if point is within the rotated bounds
    # Transform point to diamond coordinate system
    var dx = abs(point.x - center.x)
    var dy = abs(point.y - center.y)
    # Diamond equation: dx/width + dy/height < 0.5
    return (dx / (CELL_SIZE.x / 2) + dy / (CELL_SIZE.y / 2)) < 0.8
