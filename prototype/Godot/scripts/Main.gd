extends Node2D
## Main.gd - Scène principale du jeu WildZimut (version corrigée pour Android)

# Références aux nœuds (adaptées à la nouvelle scène)
@onready var grid_node: Node2D = $Grid
@onready var turn_label: Label = $TurnLabel
@onready var player_info_label: Label = $PlayerInfoLabel
@onready var message_label: Label = $MessageLabel
@onready var game_over_panel: ColorRect = $GameOverPanel
@onready var game_over_label: Label = $GameOverPanel/GameOverLabel
@onready var restart_button: Button = $GameOverPanel/RestartButton

# Référence au GameManager
@onready var game_manager: GameManager = GameManager

# Grille visuelle
var cell_nodes: Array = []


func _ready():
    # Forcer la taille de la vue pour Android
    get_viewport().size = Vector2(1200, 700)
    
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
            var cell = preload("res://scripts/Cell.gd").new()
            cell.position = Vector2(x * game_manager.CELL_SIZE, y * game_manager.CELL_SIZE)
            cell.size = Vector2(game_manager.CELL_SIZE, game_manager.CELL_SIZE)
            cell.connect("cell_clicked", Callable(self, "_on_cell_clicked").bind(x, y))
            grid_node.add_child(cell)
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
        var current_player = game_manager.players[game_manager.current_player_index]
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
            var cell = cell_nodes[y][x]
            cell.entity = null
            cell.selected = false
            cell.highlighted = false
    
    for y in range(game_manager.GRID_SIZE):
        for x in range(game_manager.GRID_SIZE):
            var entity = game_manager.grid[y][x]
            if entity != null:
                var cell = cell_nodes[y][x]
                cell.entity = entity
                cell.selected = (game_manager.selected_entity == entity)
                cell.highlighted = (entity == game_manager.players[game_manager.current_player_index] and 
                                   game_manager.current_turn == 0 and 
                                   entity.entity_type == "Player")


# ==================== UTILITAIRES ====================
func add_message(message: String):
    message_label.text = message
    var timer = Timer.new()
    timer.timeout = 2.0
    timer.timeout.connect(func(): message_label.text = "")
    add_child(timer)
    timer.start()
