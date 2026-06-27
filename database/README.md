# Gestionnaire de données SQLite pour Zimut

Ce dossier contient une **base de données SQLite** (`zimut.db`) et un **gestionnaire de données** (`data_manager.py`) pour l'application **Zimut**, inspiré de **Waven**.

## Structure

- `zimut.db` : Base de données SQLite contenant toutes les données des fichiers CSV.
- `create_database.py` : Script Python pour générer la base de données à partir des CSV.
- `data_manager.py` : Gestionnaire de données pour interroger la base SQLite.

## Schéma de la base de données

La base de données contient les tables suivantes :

### 1. **Classes et niveaux**
- `classes` : Liste des classes (Tank, Assassin, Mage, etc.).
- `class_levels` : Stats (PA, PM, Vita, Force, etc.) pour chaque classe et niveau.

### 2. **Sorts**
- `spells` : Tous les sorts avec leurs coûts, effets, et niveaux requis.
- `class_spells` : Association entre classes et sorts débloqués.
- `progression_spells` : Progression des sorts par classe et niveau.

### 3. **Ennemis**
- `enemies` : Tous les ennemis (Gobelin, Dragonnet, Troll, etc.) avec leurs stats et biomes.

### 4. **Items et Craft**
- `item_types` : Types d'items (Arme, Armure, Bouclier, etc.).
- `items` : Tous les items avec leurs bonus et effets spéciaux.
- `craft_recipes` : Recettes de craft pour fabriquer les items.

### 5. **Invocations**
- `invocations` : Invocations (Tortue, Loup, Sirène, etc.) avec leurs stats.
- `invocation_spells` : Sorts spécifiques aux invocations.

## Intégration dans l'APK

### Étape 1 : Placer la base de données dans les assets

1. Copiez le fichier `zimut.db` dans le dossier `assets` de votre projet Android/Godot :
   ```bash
   cp /workspace/CharlieG42__Zimut/database/zimut.db /chemin/vers/votre/projet/assets/
   ```

2. Assurez-vous que le fichier est accessible en lecture depuis l'application.

### Étape 2 : Utiliser le gestionnaire de données

#### En Python (pour Godot avec GDNative ou un backend Python)

```python
from database.data_manager import ZimutDataManager

# Initialiser le gestionnaire
manager = ZimutDataManager(db_path="/chemin/vers/zimut.db")

# Exemple : Récupérer les stats d'un Tank niveau 10
stats = manager.get_class_stats_at_level("Tank", 10)
print(f"PV du Tank niveau 10 : {stats['vita']}")

# Exemple : Récupérer les sorts d'un Mage niveau 5
spells = manager.get_spells_for_class_at_level("Mage", 5)
for spell in spells:
    print(f"{spell['name']} (Coût : {spell['cost_pa']} PA)")

# Exemple : Récupérer les ennemis de la forêt
forests_enemies = manager.get_enemies_by_biome("Forêt")
for enemy in forests_enemies:
    print(f"{enemy['type']} niveau {enemy['level']} : {enemy['pv']} PV")

# Fermer la connexion
manager.close()
```

#### En GDScript (Godot)

Si vous utilisez Godot, vous pouvez utiliser le module `SQLite` natif :

```gdscript
var db = SQLite.new()
db.path = "res://assets/zimut.db"
db.open()

# Exemple : Récupérer les stats d'un Tank niveau 10
var query = """
    SELECT vita, force, intelligence FROM class_levels 
    JOIN classes ON class_levels.class_id = classes.id 
    WHERE classes.name = 'Tank' AND class_levels.level = 10
"""
db.query(query)
var result = db.fetch()
if result.size() > 0:
    print("PV du Tank niveau 10 : ", result[0]["vita"])

db.close()
```

## Utilisation depuis la page de combat

### Exemple en Python (backend)

```python
from database.data_manager import ZimutDataManager

class CombatPage:
    def __init__(self):
        self.manager = ZimutDataManager()
    
    def get_player_combat_data(self, class_name: str, level: int):
        """Récupère les données de combat pour un joueur."""
        return self.manager.get_combat_data_for_class(class_name, level)
    
    def get_enemy_combat_data(self, enemy_type: str, level: int):
        """Récupère les données de combat pour un ennemi."""
        return self.manager.get_combat_data_for_enemy(enemy_type, level)
    
    def get_available_spells(self, class_name: str, level: int):
        """Récupère les sorts disponibles pour un joueur."""
        return self.manager.get_spells_for_class_at_level(class_name, level)
    
    def close(self):
        self.manager.close()

# Utilisation
combat_page = CombatPage()
player_data = combat_page.get_player_combat_data("Tank", 10)
enemy_data = combat_page.get_enemy_combat_data("Gobelin", 10)
spells = combat_page.get_available_spells("Tank", 10)

print("Données du joueur :", player_data)
print("Données de l'ennemi :", enemy_data)
print("Sorts disponibles :", [spell["name"] for spell in spells])

combat_page.close()
```

### Exemple en GDScript (Godot)

```gdscript
extends Node

var db: SQLite

func _ready():
    db = SQLite.new()
    db.path = "res://assets/zimut.db"
    db.open()

func get_player_combat_data(class_name: String, level: int) -> Dictionary:
    var query = """
        SELECT 
            cl.pa, cl.pm, cl.vita, cl.force, cl.intelligence, cl.agility, cl.wisdom, cl.defense
        FROM class_levels cl
        JOIN classes c ON cl.class_id = c.id
        WHERE c.name = ? AND cl.level = ?
    """
    db.query(query, [class_name, level])
    var result = db.fetch()
    if result.size() > 0:
        return result[0]
    return {}

func get_available_spells(class_name: String, level: int) -> Array:
    var query = """
        SELECT s.name, s.cost_pa, s.cost_pm, s.range, s.effect
        FROM spells s
        JOIN class_spells cs ON s.id = cs.spell_id
        JOIN classes c ON cs.class_id = c.id
        WHERE c.name = ? AND cs.level_required <= ?
    """
    db.query(query, [class_name, level])
    return db.fetch()

func _exit_tree():
    db.close()
```

## Requêtes utiles pour le combat

### 1. Récupérer les stats d'un joueur
```sql
SELECT * FROM class_levels 
JOIN classes ON class_levels.class_id = classes.id 
WHERE classes.name = 'Tank' AND class_levels.level = 10;
```

### 2. Récupérer les sorts disponibles pour un joueur
```sql
SELECT * FROM spells 
JOIN class_spells ON spells.id = class_spells.spell_id
JOIN classes ON class_spells.class_id = classes.id
WHERE classes.name = 'Mage' AND class_spells.level_required <= 15;
```

### 3. Récupérer les ennemis d'un biome
```sql
SELECT * FROM enemies WHERE biome = 'Forêt' AND level BETWEEN 10 AND 20;
```

### 4. Récupérer les items accessibles à un niveau donné
```sql
SELECT * FROM items WHERE required_level <= 10;
```

### 5. Récupérer les invocations disponibles pour un joueur
```sql
SELECT * FROM invocations WHERE required_level <= 15;
```

## Génération de la base de données

Si vous modifiez les fichiers CSV, vous pouvez régénérer la base de données en exécutant :
```bash
python3 database/create_database.py
```

## Inspiration de Waven

Ce système est inspiré de **Waven**, un jeu mobile qui utilise une base de données structurée pour gérer :
- Les **personnages** (classes, stats, progression).
- Les **compétences** (sorts, effets, coûts).
- Les **ennemis** (stats, biomes, effets spéciaux).
- Les **objets** (équipements, craft).

Comme dans Waven, les données sont organisées de manière **modulaire** et **optimisée** pour les requêtes en temps réel pendant le combat.

## Performances

Pour optimiser les performances (surtout sur mobile) :
1. Utilisez des **index** (déjà créés dans le schéma).
2. Évitez les requêtes `SELECT *` : sélectionnez uniquement les colonnes nécessaires.
3. Utilisez des **requêtes préparées** pour éviter les injections SQL.
4. Cachez les données fréquemment utilisées (ex: stats du joueur).

## Contribution

Si vous ajoutez de nouvelles données :
1. Ajoutez les données dans les fichiers CSV correspondants.
2. Mettez à jour le schéma SQLite si nécessaire.
3. Régénérez la base de données avec `create_database.py`.
4. Testez avec `data_manager.py`.

## Licence

Ce code fait partie du projet **Zimut** et suit la même licence.
