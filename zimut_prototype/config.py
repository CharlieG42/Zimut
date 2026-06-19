# Configuration du prototype Zimut

# ==================== PARAMÈTRES DE JEU ====================
GRID_SIZE = 10
CELL_SIZE = 50
MARGIN = 50
SCREEN_WIDTH = 1000
SCREEN_HEIGHT = 700

# ==================== PERSONNAGES ====================
PLAYER_CLASSES = ["Tank", "Assassin", "Mage"]
PLAYER_LEVELS = [10, 10, 10]
PLAYER_POSITIONS = [(1, 1), (1, 2), (2, 1)]

# ==================== ENNEMIS ====================
ENEMY_TYPES = ["Gobelin", "Squelette", "Loup"]
ENEMY_LEVELS = [10, 10, 10]
ENEMY_POSITIONS = [(8, 8), (8, 7), (7, 8)]

# ==================== CHEMINS ====================
DATA_DIR = "./"  # Les CSV seront dans le même dossier
CLASSES_FILE = "classes.csv"
SORTS_FILE = "sorts.csv"
ENNEMIS_FILE = "ennemis.csv"
STUFF_FILE = "stuff.csv"

# ==================== COULEURS ====================
CLASS_COLORS = {
    "Tank": (0, 100, 200),
    "Assassin": (200, 0, 0),
    "Chasseur": (0, 200, 0),
    "Mage": (150, 0, 200),
    "Support": (255, 200, 0),
    "Heal": (0, 200, 200),
    "Gobelin": (100, 150, 0),
    "Squelette": (200, 200, 200),
    "Loup": (150, 100, 50),
}