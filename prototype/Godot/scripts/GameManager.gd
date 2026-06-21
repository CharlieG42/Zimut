extends Node
## GameManager - Gère la logique globale du jeu WildZimut

const GRID_SIZE := 10
const CELL_SIZE := 64
const MARGIN := 20

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

var grid: Array = []
var players: Array = []
var enemies: Array = []
var current_turn: int = 0
var current_player_index: int = 0
var selected_entity = null
var selected_spell = null
var selected_cell: Vector2i = Vector2i(0, 0)
var show_spells: bool = false
var game_over: bool = false
var victory: bool = false

signal turn_changed(turn: int)
signal player_changed(index: int)
signal entity_selected(entity)
signal spell_selected(spell)
signal game_ended(victory: bool)
signal entity_moved(entity, from_pos: Vector2i, to_pos: Vector2i)
signal entity_attacked(attacker, target, damage: int)
signal spell_casted(caster, spell, target, result: String)

var classes_data: Array = []
var spells_data: Array = []
var enemies_data: Array = []


func _ready():
    load_data()
    init_grid()
    init_entities()
    current_turn = 0
    turn_changed.emit(current_turn)


func load_data():
    classes_data = [
        {"Classe": "Tank", "Niveau": "10", "Vita (PV)": "120", "Force (CAC)": "20", "Intelligence (Magie)": "5", "Agilité (Vit. Atk)": "5", "Sagesse (Précision)": "10", "Défense": "30", "PA": "6", "PM": "3"},
        {"Classe": "Assassin", "Niveau": "10", "Vita (PV)": "80", "Force (CAC)": "15", "Intelligence (Magie)": "10", "Agilité (Vit. Atk)": "25", "Sagesse (Précision)": "20", "Défense": "10", "PA": "7", "PM": "4"},
        {"Classe": "Mage", "Niveau": "10", "Vita (PV)": "60", "Force (CAC)": "5", "Intelligence (Magie)": "25", "Agilité (Vit. Atk)": "10", "Sagesse (Précision)": "15", "Défense": "5", "PA": "8", "PM": "3"}
    ]
    spells_data = [
        {"Nom": "Coup puissant", "Classe": "Tank", "Coût PA": "1", "Coût PM": "0", "Portée": "1", "Effet": "25 dégâts", "Niveau requis": "1", "Type": "CAC"},
        {"Nom": "Bouclier", "Classe": "Tank", "Coût PA": "2", "Coût PM": "0", "Portée": "1", "Effet": "Réduit les dégâts de 50% pour 1 tour", "Niveau requis": "5", "Type": "Défense"},
        {"Nom": "Attaque furtive", "Classe": "Assassin", "Coût PA": "1", "Coût PM": "2", "Portée": "1", "Effet": "30 dégâts + ignore 50% défense", "Niveau requis": "1", "Type": "CAC"},
        {"Nom": "Poison", "Classe": "Assassin", "Coût PA": "2", "Coût PM": "0", "Portée": "3", "Effet": "15 dégâts + poison", "Niveau requis": "5", "Type": "Magie"},
        {"Nom": "Boule de feu", "Classe": "Mage", "Coût PA": "3", "Coût PM": "0", "Portée": "5", "Effet": "40 dégâts", "Niveau requis": "1", "Type": "Magie"},
        {"Nom": "Soin", "Classe": "Mage", "Coût PA": "2", "Coût PM": "0", "Portée": "4", "Effet": "Restaure 30 PV", "Niveau requis": "3", "Type": "Soin"}
    ]
    enemies_data = [
        {"Type": "Gobelin", "Niveau": "10", "PV": "60", "Attaque": "12", "Défense": "5", "PA": "5", "PM": "3", "Biome": "Forêt", "Effets spéciaux": ""},
        {"Type": "Squelette", "Niveau": "10", "PV": "50", "Attaque": "15", "Défense": "10", "PA": "4", "PM": "2", "Biome": "Donjon", "Effets spéciaux": ""},
        {"Type": "Loup", "Niveau": "10", "PV": "70", "Attaque": "10", "Défense": "3", "PA": "6", "PM": "4", "Biome": "Plaine", "Effets spéciaux": ""}
    ]