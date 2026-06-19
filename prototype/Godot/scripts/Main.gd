extends Control
## Main.gd - Scène principale du jeu WildZimut
## Gère l'affichage et les interactions utilisateur

# Références aux nœuds
@onready var grid_container: GridContainer = $GridContainer
@onready var spell_panel: Panel = $SpellPanel
@onready var turn_label: Label = $TurnLabel
@onready var player_info_label: Label = $PlayerInfoLabel
@onready var message_label: Label = $MessageLabel
@onready var game_over_panel: Panel = $GameOverPanel
@onready var game_over_label: Label = $GameOverPanel/GameOverLabel
@onready var restart_button: Button = $GameOverPanel/RestartButton

# Référence au GameManager
@onready var game_manager: GameManager = GameManager

# Grille visuelle
var cell_nodes: Array = []


func _ready():
    init_grid_display()
    
    # Connexion des signaux
    game_manager.turn_changed.connect(_on_turn_changed)
    game_manager.player_changed.connect(_on_player_changed)
    game_manager.entity_selected.connect(_on_entity_selected)
    game_manager.spell_selected.connect(_on_spell_selected)
    game_manager.game_ended.connect(_on_game_ended)
    game_manager.entity_moved.connect(_on_entity_moved)
    game_manager.entity_attacked.connect(_on_entity_attacked)
    game_manager.spell_casted.connect(_on_spell_casted)
    
    restart_button.pressed.connect(_on_restart_pressed)
    
    update_ui()


# ==================== INITIALISATION DE LA GRILLE ====================
func init_grid_display():
    cell_nodes = []
    for y in range(game_manager.GRID_SIZE):
        var row: Array = []
        for x in range(game_manager.GRID_SIZE):
            var cell := preload("res://scripts/Cell.gd").new()
            cell.position = Vector2(x, y)
            cell.size = Vector2(game_manager.CELL_SIZE, game_manager.CELL_SIZE)
            cell.connect("cell_clicked", Callable(self, "_on_cell_clicked").bind(x, y))
            grid_container.add_child(cell)
            row.append(cell)
        cell_nodes.append(row)
    update_entity_display()


# ==================== GESTION DES CLICS ====================
func _on_cell_clicked(x: int, y: int):
    if game_manager.game_over:
        return
    game_manager.handle_cell_selected(Vector2i(x, y))


# ==================== GESTION DES SIGNAUX ====================
func _on_turn_changed(turn: int):
    update_ui()

func _on_player_changed(index: int):
    update_ui()

func _on_entity_selected(entity: EntityData):
    update_ui()
    update_spell_panel(entity)

func _on_spell_selected(spell: SpellData):
    pass

func _on_game_ended(victory: bool):
    game_over_panel.visible = true
    if victory:
        game_over_label.text = "VICTOIRE !"
    else:
        game_over_label.text = "DEFAITE..."

func _on_entity_moved(entity: EntityData, from_pos: Vector2i, to_pos: Vector2i):
    update_entity_display()

func _on_entity_attacked(attacker: EntityData, target: EntityData, damage: int):
    update_entity_display()

func _on_spell_casted(caster: EntityData, spell: SpellData, target: EntityData, result: String):
    update_entity_display()
    add_message(result)

func _on_restart_pressed():
    game_manager.reset_game()
    game_over_panel.visible = false
    update_entity_display()
    update_ui()


# ==================== MISE À JOUR DE L'UI ====================
func update_ui():
    if game_manager.current_turn == 0:
        turn_label.text = "Tour des joueurs"
    else:
        turn_label.text = "Tour des ennemis"
    
    if game_manager.current_turn == 0 and game_manager.players.size() > 0:
        var current_player := game_manager.players[game_manager.current_player_index]
        player_info_label.text = "Joueur: %s | PV: %d/%d | PA: %d/%d | PM: %d/%d" % [
            current_player.name,
            current_player.current_pv, current_player.max_pv,
            current_player.current_pa, current_player.max_pa,
            current_player.current_pm, current_player.max_pm
        ]
    else:
        player_info_label.text = ""

func update_entity_display():
    for y in range(game_manager.GRID_SIZE):
        for x in range(game_manager.GRID_SIZE):
            var cell := cell_nodes[y][x]
            cell.entity = null
            cell.selected = false
            cell.highlighted = false
    
    for y in range(game_manager.GRID_SIZE):
        for x in range(game_manager.GRID_SIZE):
            var entity := game_manager.grid[y][x]
            if entity != null:
                var cell := cell_nodes[y][x]
                cell.entity = entity
                cell.selected = (game_manager.selected_entity == entity)
                cell.highlighted = (entity == game_manager.players[game_manager.current_player_index] and 
                                   game_manager.current_turn == 0 and 
                                   entity.entity_type == "Player")

func update_spell_panel(entity: EntityData):
    for child in spell_panel.get_children():
        child.queue_free()
    
    if entity == null or entity != game_manager.players[game_manager.current_player_index]:
        spell_panel.visible = false
        return
    
    spell_panel.visible = true
    
    var title := Label.new()
    title.text = "Sorts disponibles"
    spell_panel.add_child(title)
    
    var y_offset := 40
    for i in range(entity.spells.size()):
        var spell := entity.spells[i]
        var can_cast := spell.can_cast(entity)
        
        var spell_button := Button.new()
        spell_button.text = "%d. %s (PA:%d, PM:%d)" % [i+1, spell.name, spell.cost_pa, spell.cost_pm]
        spell_button.position = Vector2(10, y_offset)
        spell_button.size = Vector2(spell_panel.size.x - 20, 30)
        spell_button.disabled = not can_cast
        spell_button.connect("pressed", Callable(self, "_on_spell_button_pressed").bind(i))
        
        spell_panel.add_child(spell_button)
        y_offset += 40

func _on_spell_button_pressed(spell_index: int):
    var current_player := game_manager.players[game_manager.current_player_index]
    if spell_index < current_player.spells.size():
        game_manager.selected_spell = current_player.spells[spell_index]
        game_manager.spell_selected.emit(game_manager.selected_spell)


# ==================== UTILITAIRES ====================
func add_message(message: String):
    message_label.text = message
    var timer := Timer.new()
    timer.timeout = 2.0
    timer.timeout.connect(func(): message_label.text = "")
    add_child(timer)
    timer.start()
