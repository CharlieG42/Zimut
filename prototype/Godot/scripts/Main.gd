extends Node2D
## Main.gd - Scene principale avec Node2D
## TurnOrderContainer is a Control (not VBoxContainer) for manual positioning

@onready var grid: Node2D = $Grid
@onready var turn_label: Label = $UI/TurnLabel
@onready var player_info_label: Label = $UI/PlayerInfoLabel
@onready var message_label: Label = $UI/MessageLabel
@onready var game_over_panel: ColorRect = $UI/GameOverPanel
@onready var game_over_label: Label = $UI/GameOverPanel/GameOverLabel
@onready var restart_button: Button = $UI/GameOverPanel/RestartButton

@onready var spell_panel: Panel = $UI/SpellPanel
@onready var spell_container: VBoxContainer = $UI/SpellPanel/SpellContainer
@onready var spell_description: Label = $UI/SpellPanel/SpellDescription
@onready var turn_order_panel: Panel = $UI/TurnOrderPanel
@onready var turn_order_container: Control = $UI/TurnOrderPanel/TurnOrderContainer

var game_manager

var cell_nodes: Array = []
var spell_buttons: Array = []
var turn_order_labels: Array = []
var turn_order_health_bars: Array = []
var end_turn_button: Button


func _ready():
    game_manager = GameManager
    init_grid_display()
    init_turn_order_display()
    init_ui_elements()
    game_manager.turn_changed.connect(_on_turn_changed)
    game_manager.player_changed.connect(_on_player_changed)
    game_manager.entity_selected.connect(_on_entity_selected)
    game_manager.spell_selected.connect(_on_spell_selected)
    game_manager.game_ended.connect(_on_game_ended)
    game_manager.entity_moved.connect(_on_entity_moved)
    game_manager.entity_attacked.connect(_on_entity_attacked)
    game_manager.spell_casted.connect(_on_spell_casted)
    game_manager.message_requested.connect(_on_message_requested)
    restart_button.pressed.connect(_on_restart_pressed)
    spell_panel.visible = false
    update_ui()
    if game_manager.players.size() > 0:
        show_spells_for_player(game_manager.players[0])


func init_ui_elements():
    # End turn button - under spell panel, centered, narrower to fit
    end_turn_button = Button.new()
    end_turn_button.name = "EndTurnButton"
    end_turn_button.text = "Passer le tour"
    end_turn_button.position = Vector2(1660, 985)  # Centered: 1580 + 320/2 - 160/2 = 1660
    end_turn_button.size = Vector2(160, 50)  # Narrower to fit on screen
    end_turn_button.add_theme_font_size_override("font_size", 24)  # Smaller font
    end_turn_button.z_index = 51  # Above SpellPanel (z_index=50)
    add_child(end_turn_button)
    end_turn_button.pressed.connect(_on_end_turn_pressed)
    
    # Player info label - 44px
    if player_info_label:
        var settings = LabelSettings.new()
        settings.font_size = 44
        player_info_label.label_settings = settings


func init_grid_display():
    cell_nodes = []
    for y in range(game_manager.GRID_SIZE):
        var row: Array = []
        for x in range(game_manager.GRID_SIZE):
            var cell = preload("res://scripts/Cell.gd").new()
            cell.position = Vector2(x * 80 - 320, y * 80 - 320)
            cell.grid_position = Vector2i(x, y)
            cell.connect("cell_clicked", Callable(self, "_on_cell_clicked"))
            grid.add_child(cell)
            row.append(cell)
        cell_nodes.append(row)
    update_entity_display()


func init_turn_order_display():
    turn_order_labels = []
    turn_order_health_bars = []
    
    for child in turn_order_container.get_children():
        child.queue_free()
    
    var y_pos = 0
    
    # Alive players only
    for i in range(game_manager.players.size()):
        var player = game_manager.players[i]
        if player["current_pv"] > 0:
            var label = Label.new()
            label.text = "%d. %s" % [i + 1, player.get("name", "Joueur")]
            var settings = LabelSettings.new()
            settings.font_size = 24
            label.label_settings = settings
            label.add_theme_color_override("font_color", Color.WHITE)
            label.position = Vector2(10, y_pos)
            label.size = Vector2(260, 25)
            turn_order_container.add_child(label)
            turn_order_labels.append(label)
            
            var health_bar_bg = ColorRect.new()
            health_bar_bg.color = Color(0, 0, 0)
            health_bar_bg.position = Vector2(10, y_pos + 28)
            health_bar_bg.size = Vector2(120, 20)
            turn_order_container.add_child(health_bar_bg)
            
            var health_bar_fill = ColorRect.new()
            health_bar_fill.name = "HealthBar_%d" % i
            health_bar_fill.color = Color(0, 1.0, 0)
            health_bar_fill.position = Vector2(10, y_pos + 28)
            var health_ratio = player.get("current_pv", 0) / max(1, player.get("max_pv", 1))
            health_bar_fill.size.x = 120.0 * health_ratio
            health_bar_fill.size.y = 20
            health_bar_fill.z_index = 1
            turn_order_container.add_child(health_bar_fill)
            turn_order_health_bars.append(health_bar_fill)
            
            y_pos += 55
    
    # Alive enemies only
    for i in range(game_manager.enemies.size()):
        var enemy = game_manager.enemies[i]
        if enemy["current_pv"] > 0:
            var label = Label.new()
            label.text = "%d. %s" % [i + 1 + game_manager.players.size(), enemy.get("name", "Ennemi")]
            var settings = LabelSettings.new()
            settings.font_size = 24
            label.label_settings = settings
            label.add_theme_color_override("font_color", Color(0.9, 0.4, 0.4))
            label.position = Vector2(10, y_pos)
            label.size = Vector2(260, 25)
            turn_order_container.add_child(label)
            turn_order_labels.append(label)
            
            var health_bar_bg = ColorRect.new()
            health_bar_bg.color = Color(0, 0, 0)
            health_bar_bg.position = Vector2(10, y_pos + 28)
            health_bar_bg.size = Vector2(120, 20)
            turn_order_container.add_child(health_bar_bg)
            
            var health_bar_fill = ColorRect.new()
            health_bar_fill.name = "HealthBar_%d" % (game_manager.players.size() + i)
            health_bar_fill.color = Color(1.0, 0, 0)
            health_bar_fill.position = Vector2(10, y_pos + 28)
            var health_ratio = enemy.get("current_pv", 0) / max(1, enemy.get("max_pv", 1))
            health_bar_fill.size.x = 120.0 * health_ratio
            health_bar_fill.size.y = 20
            health_bar_fill.z_index = 1
            turn_order_container.add_child(health_bar_fill)
            turn_order_health_bars.append(health_bar_fill)
            
            y_pos += 55


func _on_cell_clicked(x: int, y: int):
    if game_manager.game_over:
        return
    game_manager.handle_cell_selected(Vector2i(x, y))


func show_spells_for_player(player: Dictionary):
    for button in spell_buttons:
        button.queue_free()
    spell_buttons = []
    for child in spell_container.get_children():
        child.queue_free()
    for spell in player.get("spells", []):
        var button = preload("res://scripts/SpellButton.gd").new()
        button.spell = spell
        button.spell_selected.connect(_on_spell_button_selected)
        button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        button.size_flags_vertical = Control.SIZE_SHRINK_CENTER
        button.mouse_filter = Control.MOUSE_FILTER_PASS
        
        button.add_theme_color_override("font_color", Color.WHITE)
        button.add_theme_color_override("font_pressed_color", Color.YELLOW)
        button.add_theme_color_override("font_hover_color", Color(1, 1, 0.8))
        
        spell_container.add_child(button)
        spell_buttons.append(button)
    spell_panel.visible = true


func hide_spell_panel():
    spell_panel.visible = false
    if spell_description:
        spell_description.text = ""


func _on_spell_button_selected(spell: Dictionary):
    game_manager.handle_spell_selected(spell)
    for button in spell_buttons:
        if button.spell == spell:
            button.add_theme_color_override("font_color", Color.YELLOW)
        else:
            button.add_theme_color_override("font_color", Color.WHITE)
    
    if spell_description:
        spell_description.text = "%s: %s" % [spell.get("name", ""), spell.get("effect", "")]


func _on_message_requested(text: String):
    add_message(text)


func _on_turn_changed(turn: int):
    update_ui()
    update_turn_order_display()
    if turn == 1:
        hide_spell_panel()
        if spell_description:
            spell_description.text = ""


func _on_player_changed(index: int):
    update_ui()
    update_entity_display()
    update_turn_order_display()  # Rebuild to update health bars
    if game_manager.current_turn == 0 and game_manager.players.size() > index:
        var current_player = game_manager.players[index]
        show_spells_for_player(current_player)
    else:
        hide_spell_panel()


func _on_entity_selected(_entity):
    update_ui()


func _on_spell_selected(spell):
    for button in spell_buttons:
        if button.spell == spell:
            button.add_theme_color_override("font_color", Color.YELLOW)
        else:
            button.add_theme_color_override("font_color", Color.WHITE)
    if spell_description:
        spell_description.text = "%s: %s" % [spell.get("name", ""), spell.get("effect", "")]


func _on_game_ended(victory: bool):
    game_over_panel.visible = true
    hide_spell_panel()
    if spell_description:
        spell_description.text = ""
    if victory:
        game_over_label.text = "VICTOIRE !"
    else:
        game_over_label.text = "DEFAITE..."


func _on_entity_moved(_entity, _from_pos: Vector2i, _to_pos: Vector2i):
    update_entity_display()
    update_turn_order_display()


func _on_entity_attacked(_attacker, _target, _damage: int):
    update_entity_display()
    update_turn_order_display()


func _on_spell_casted(_caster, _spell, _target, _result: String):
    update_entity_display()
    update_turn_order_display()
    if spell_description:
        spell_description.text = ""
    for button in spell_buttons:
        button.add_theme_color_override("font_color", Color.WHITE)


func _on_end_turn_pressed():
    game_manager.next_player()
    if spell_description:
        spell_description.text = ""


func _on_restart_pressed():
    game_manager.reset_game()
    game_over_panel.visible = false
    update_entity_display()
    update_ui()
    init_turn_order_display()
    if game_manager.players.size() > 0:
        show_spells_for_player(game_manager.players[0])
    if spell_description:
        spell_description.text = ""


func update_ui():
    if game_manager.current_turn == 0:
        turn_label.text = "Tour des joueurs"
        end_turn_button.visible = true
    else:
        turn_label.text = "Tour des ennemis"
        end_turn_button.visible = false
    if game_manager.current_turn == 0 and game_manager.players.size() > 0:
        var current_player = game_manager.players[game_manager.current_player_index]
        player_info_label.text = "Joueur: %s | PV: %d/%d | PA: %d/%d | PM: %d/%d" % [
            current_player.get("name", "?"),
            current_player.get("current_pv", 0), current_player.get("max_pv", 0),
            current_player.get("current_pa", 0), current_player.get("max_pa", 0),
            current_player.get("current_pm", 0), current_player.get("max_pm", 0)
        ]
    else:
        player_info_label.text = ""


func update_turn_order_display():
    for child in turn_order_container.get_children():
        child.queue_free()
    
    turn_order_labels = []
    turn_order_health_bars = []
    
    var y_pos = 0
    
    # Alive players only
    for i in range(game_manager.players.size()):
        var player = game_manager.players[i]
        if player["current_pv"] > 0:
            var label = Label.new()
            label.text = "%d. %s" % [i + 1, player.get("name", "Joueur")]
            var settings = LabelSettings.new()
            settings.font_size = 24
            label.label_settings = settings
            label.add_theme_color_override("font_color", Color.WHITE)
            label.position = Vector2(10, y_pos)
            label.size = Vector2(260, 25)
            turn_order_container.add_child(label)
            turn_order_labels.append(label)
            
            var health_bar_bg = ColorRect.new()
            health_bar_bg.color = Color(0, 0, 0)
            health_bar_bg.position = Vector2(10, y_pos + 28)
            health_bar_bg.size = Vector2(120, 20)
            turn_order_container.add_child(health_bar_bg)
            
            var health_bar_fill = ColorRect.new()
            health_bar_fill.name = "HealthBar_%d" % i
            health_bar_fill.color = Color(0, 1.0, 0)
            health_bar_fill.position = Vector2(10, y_pos + 28)
            var health_ratio = player.get("current_pv", 0) / max(1, player.get("max_pv", 1))
            health_bar_fill.size.x = 120.0 * health_ratio
            health_bar_fill.size.y = 20
            health_bar_fill.z_index = 1
            turn_order_container.add_child(health_bar_fill)
            turn_order_health_bars.append(health_bar_fill)
            
            y_pos += 55
    
    # Alive enemies only
    for i in range(game_manager.enemies.size()):
        var enemy = game_manager.enemies[i]
        if enemy["current_pv"] > 0:
            var label = Label.new()
            label.text = "%d. %s" % [i + 1 + game_manager.players.size(), enemy.get("name", "Ennemi")]
            var settings = LabelSettings.new()
            settings.font_size = 24
            label.label_settings = settings
            label.add_theme_color_override("font_color", Color(0.9, 0.4, 0.4))
            label.position = Vector2(10, y_pos)
            label.size = Vector2(260, 25)
            turn_order_container.add_child(label)
            turn_order_labels.append(label)
            
            var health_bar_bg = ColorRect.new()
            health_bar_bg.color = Color(0, 0, 0)
            health_bar_bg.position = Vector2(10, y_pos + 28)
            health_bar_bg.size = Vector2(120, 20)
            turn_order_container.add_child(health_bar_bg)
            
            var health_bar_fill = ColorRect.new()
            health_bar_fill.name = "HealthBar_%d" % (game_manager.players.size() + i)
            health_bar_fill.color = Color(1.0, 0, 0)
            health_bar_fill.position = Vector2(10, y_pos + 28)
            var health_ratio = enemy.get("current_pv", 0) / max(1, enemy.get("max_pv", 1))
            health_bar_fill.size.x = 120.0 * health_ratio
            health_bar_fill.size.y = 20
            health_bar_fill.z_index = 1
            turn_order_container.add_child(health_bar_fill)
            turn_order_health_bars.append(health_bar_fill)
            
            y_pos += 55


func update_entity_display():
    for y in range(game_manager.GRID_SIZE):
        for x in range(game_manager.GRID_SIZE):
            var cell = cell_nodes[y][x]
            cell.entity = null
            cell.selected = false
            cell.highlighted = false
            cell.update_appearance()
    for y in range(game_manager.GRID_SIZE):
        for x in range(game_manager.GRID_SIZE):
            var entity = game_manager.grid[y][x]
            if entity != null:
                var cell = cell_nodes[y][x]
                cell.entity = entity
                cell.selected = (game_manager.selected_entity == entity)
                # Only highlight if current_player_index is valid
                var current_player = null
                if game_manager.current_player_index >= 0 and game_manager.current_player_index < game_manager.players.size():
                    current_player = game_manager.players[game_manager.current_player_index]
                cell.highlighted = (entity == current_player and game_manager.current_turn == 0 and entity.get("entity_type", "") == "Player")
                cell.update_appearance()


func add_message(message: String):
    message_label.text = message
    var timer = Timer.new()
    timer.wait_time = 3.0
    timer.one_shot = true
    timer.timeout.connect(func(): message_label.text = "")
    add_child(timer)
    timer.start()
