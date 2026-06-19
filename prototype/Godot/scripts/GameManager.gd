extends Node
## GameManager - Gère la logique globale du jeu WildZimut
## Transposition du prototype Python/Pygame en Godot

# ==================== CONSTANTES ====================
const GRID_SIZE := 10
const CELL_SIZE := 64
const MARGIN := 20

# Couleurs (pour le débogage et les UI)
const COLORS := {
    "Tank": Color(0, 0.4, 0.8),
    "Assassin": Color(0.8, 0, 0),
    "Chasseur": Color(0, 0.8, 0),
    "Mage": Color(0.6, 0, 0.8),
    "Support": Color(1, 0.8, 0),
    "Heal": Color(0, 0.8, 0.8),
    "Gobelin": Color(0.5, 0.8, 0.3),
    "Squelette": Color(0.8, 0.8, 0.8),
    "Loup": Color(0.6, 0.6, 0.4),
}

# ==================== DONNÉES DES ENTITÉS ====================
class_name EntityData
var name: String
var entity_type: String
var classe: String
var level: int
var max_pv: int
var current_pv: int
var force: int
var intelligence: int
var agility: int
var wisdom: int
var defense: int
var max_pa: int
var current_pa: int
var max_pm: int
var current_pm: int
var x: int
var y: int
var spells: Array = []
var is_active: bool = false

func get_color() -> Color:
    return COLORS.get(classe, Color(0.4, 0.4, 0.4))


class_name SpellData
var name: String
var classe: String
var cost_pa: int
var cost_pm: int
var range: int
var effect: String
var level_required: int
var spell_type: String

func can_cast(entity: EntityData) -> bool:
    return (entity.current_pa >= cost_pa and 
            entity.current_pm >= cost_pm and 
            entity.level >= level_required)


# ==================== VARIABLES GLOBALES ====================
var grid: Array = []
var players: Array = []
var enemies: Array = []
var current_turn: int = 0
var current_player_index: int = 0
var selected_entity: EntityData = null
var selected_spell: SpellData = null
var selected_cell: Vector2i = Vector2i(0, 0)
var show_spells: bool = false
var game_over: bool = false
var victory: bool = false

# Signaux
signal turn_changed(turn: int)
signal player_changed(index: int)
signal entity_selected(entity: EntityData)
signal spell_selected(spell: SpellData)
signal game_ended(victory: bool)
signal entity_moved(entity: EntityData, from_pos: Vector2i, to_pos: Vector2i)
signal entity_attacked(attacker: EntityData, target: EntityData, damage: int)
signal spell_casted(caster: EntityData, spell: SpellData, target: EntityData, result: String)

# Données préchargées
var classes_data: Array = []
var spells_data: Array = []
var enemies_data: Array = []


func _ready():
    load_data()
    init_grid()
    init_entities()
    current_turn = 0
    turn_changed.emit(current_turn)
