extends Node2D
class_name Cell
## Cell.gd - Version Node2D avec Sprite2D pour Android

var position: Vector2i = Vector2i(0, 0)
var entity: EntityData = null
var selected: bool = false
var highlighted: bool = false

# Sprite pour afficher la cellule
@onready var sprite: Sprite2D = $Sprite2D
@onready var entity_sprite: Sprite2D = $EntitySprite
@onready var pv_bar: ColorRect = $PVBar
@onready var pv_bar_bg: ColorRect = $PVBarBG
@onready var level_label: Label = $LevelLabel

signal cell_clicked(x: int, y: int)


func _ready():
    # Créer les nœuds enfants si ils n'existent pas
    if not sprite:
        sprite = Sprite2D.new()
        add_child(sprite)
        sprite.position = Vector2(32, 32)
    
    if not entity_sprite:
        entity_sprite = Sprite2D.new()
        add_child(entity_sprite)
        entity_sprite.position = Vector2(32, 32)
    
    if not pv_bar_bg:
        pv_bar_bg = ColorRect.new()
        pv_bar_bg.color = Color.DARK_GRAY
        pv_bar_bg.size = Vector2(54, 5)
        pv_bar_bg.position = Vector2(5, 5)
        add_child(pv_bar_bg)
    
    if not pv_bar:
        pv_bar = ColorRect.new()
        pv_bar.color = Color.GREEN
        pv_bar.size = Vector2(54, 5)
        pv_bar.position = Vector2(5, 5)
        add_child(pv_bar)
    
    if not level_label:
        level_label = Label.new()
        level_label.position = Vector2(32, -15)
        level_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
        add_child(level_label)
    
    update_appearance()


func update_appearance():
    # Fond de la cellule (damier)
    var bg_color = Color.LIGHT_GRAY if (position.x + position.y) % 2 == 0 else Color(0.8, 0.8, 0.8)
    
    # Pour l'instant, on utilise un ColorRect pour le fond
    if not sprite.texture:
        # Créer un fond avec un ColorRect
        var bg = ColorRect.new()
        bg.color = bg_color
        bg.size = Vector2(64, 64)
        bg.position = Vector2(0, 0)
        if not has_node("Background"):
            add_child(bg)
            bg.name = "Background"
    
    # Afficher l'entité si elle existe
    if entity:
        entity_sprite.visible = true
        var color = GameManager.COLORS.get(entity.classe, Color(0.5, 0.5, 0.5))
        
        # Créer une texture de cercle (simplifié)
        var img = Image.create(64, 64, false, Image.FORMAT_RGBA8)
        img.fill(Color(0, 0, 0, 0))  # Transparent
        
        # Dessiner un cercle
        var center = Vector2(32, 32)
        var radius = 20
        for x in range(64):
            for y in range(64):
                if (Vector2(x, y) - center).length() < radius:
                    img.set_pixel(x, y, color)
        
        var tex = ImageTexture.create_from_image(img)
        entity_sprite.texture = tex
        
        # Bordure selon le type
        var border_img = Image.create(64, 64, false, Image.FORMAT_RGBA8)
        border_img.fill(Color(0, 0, 0, 0))
        var border_color = Color.BLUE if entity.entity_type == "Player" else Color.RED
        for x in range(64):
            for y in range(64):
                var dist = (Vector2(x, y) - center).length()
                if dist > radius - 2 and dist < radius + 2:
                    border_img.set_pixel(x, y, border_color)
        var border_tex = ImageTexture.create_from_image(border_img)
        sprite.texture = border_tex
        
        # Barre de PV
        var pv_percentage = entity.current_pv / float(entity.max_pv)
        pv_bar.size.x = 54 * pv_percentage
        pv_bar.color = Color.GREEN if pv_percentage > 0.5 else Color.ORANGE if pv_percentage > 0.25 else Color.RED
        
        # Niveau
        level_label.text = str(entity.level)
        
        # Surligner si sélectionné
        if selected:
            var select_img = Image.create(64, 64, false, Image.FORMAT_RGBA8)
            select_img.fill(Color(1, 1, 0, 0.3))
            var select_tex = ImageTexture.create_from_image(select_img)
            var select_sprite = Sprite2D.new()
            select_sprite.texture = select_tex
            select_sprite.position = Vector2(0, 0)
            if has_node("Selection"):
                get_node("Selection").queue_free()
            add_child(select_sprite)
            select_sprite.name = "Selection"
        
        if highlighted:
            var highlight_img = Image.create(64, 64, false, Image.FORMAT_RGBA8)
            highlight_img.fill(Color(1, 1, 0, 0.2))
            var highlight_tex = ImageTexture.create_from_image(highlight_img)
            var highlight_sprite = Sprite2D.new()
            highlight_sprite.texture = highlight_tex
            highlight_sprite.position = Vector2(0, 0)
            if has_node("Highlight"):
                get_node("Highlight").queue_free()
            add_child(highlight_sprite)
            highlight_sprite.name = "Highlight"
    else:
        entity_sprite.visible = false
        entity_sprite.texture = null
        sprite.texture = null
        if has_node("Selection"):
            get_node("Selection").queue_free()
        if has_node("Highlight"):
            get_node("Highlight").queue_free()


func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        var mouse_pos = get_global_mouse_position()
        var local_pos = to_local(mouse_pos)
        if Rect2(0, 0, 64, 64).has_point(local_pos):
            cell_clicked.emit(position.x, position.y)


func _on_mouse_entered():
    if entity != null:
        get_parent().get_parent().add_message("%s - PV: %d/%d" % [entity.name, entity.current_pv, entity.max_pv])
