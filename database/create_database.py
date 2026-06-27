#!/usr/bin/env python3
"""
Script pour créer une base de données SQLite pour Zimut.
Inspiré de Waven, ce script charge tous les CSV et les intègre dans une base SQLite.
"""

import sqlite3
import csv
import os
from pathlib import Path

# Chemin vers les données
DATA_DIR = Path(__file__).parent.parent / "data"
DB_PATH = Path(__file__).parent / "zimut.db"

# Encodage par défaut pour les fichiers CSV
DEFAULT_ENCODING = "utf-8"

# Encodages spécifiques pour certains fichiers
FILE_ENCODINGS = {
    "invocations.csv": "iso-8859-1",
    "sorts_invocations.csv": "iso-8859-1"
}


def get_encoding(filename: str) -> str:
    """Récupère l'encodage pour un fichier donné."""
    return FILE_ENCODINGS.get(filename, DEFAULT_ENCODING)


def fix_row_encoding(row: dict) -> dict:
    """Corrige les noms de colonnes mal encodés dans les fichiers ISO-8859-1."""
    # Mapping des noms de colonnes mal encodés
    column_mapping = {
        "D\u00c3\u00a9fense": "Défense",
        "D\u00e9fense": "Défense",
        "Co\u00c3\u00bbt PA": "Coût PA",
        "Co\u00c3\u00bbt PM": "Coût PM",
        "Port\u00c3\u00a9e": "Portée",
        "Co\u00fbt PA": "Coût PA",
        "Co\u00fbt PM": "Coût PM",
        "Port\u00e9e": "Portée"
    }
    
    new_row = {}
    for key, value in row.items():
        new_key = column_mapping.get(key, key)
        new_row[new_key] = value
    return new_row


def create_database():
    """Crée la base de données et les tables."""
    if os.path.exists(DB_PATH):
        os.remove(DB_PATH)
    
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    
    # Activation des clés étrangères
    cursor.execute("PRAGMA foreign_keys = ON")
    
    # Création des tables
    cursor.executescript("""
        -- Table des classes (Tank, Assassin, etc.)
        CREATE TABLE IF NOT EXISTS classes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT UNIQUE NOT NULL
        );

        -- Table des niveaux de classe (stats par niveau)
        CREATE TABLE IF NOT EXISTS class_levels (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            class_id INTEGER NOT NULL,
            level INTEGER NOT NULL,
            pa INTEGER NOT NULL,
            pm INTEGER NOT NULL,
            vita INTEGER NOT NULL,
            force INTEGER NOT NULL,
            intelligence INTEGER NOT NULL,
            agility INTEGER NOT NULL,
            wisdom INTEGER NOT NULL,
            defense INTEGER NOT NULL,
            xp_required INTEGER NOT NULL,
            FOREIGN KEY (class_id) REFERENCES classes(id),
            UNIQUE (class_id, level)
        );

        -- Table des sorts
        CREATE TABLE IF NOT EXISTS spells (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            cost_pa INTEGER NOT NULL,
            cost_pm INTEGER NOT NULL,
            range INTEGER NOT NULL,
            effect TEXT NOT NULL,
            required_level INTEGER NOT NULL,
            spell_type TEXT NOT NULL,
            class_required TEXT DEFAULT NULL,
            UNIQUE (name, class_required)
        );

        -- Table des associations entre classes et sorts débloqués
        CREATE TABLE IF NOT EXISTS class_spells (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            class_id INTEGER NOT NULL,
            spell_id INTEGER NOT NULL,
            level_required INTEGER NOT NULL,
            FOREIGN KEY (class_id) REFERENCES classes(id),
            FOREIGN KEY (spell_id) REFERENCES spells(id),
            UNIQUE (class_id, spell_id)
        );

        -- Table des ennemis
        CREATE TABLE IF NOT EXISTS enemies (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT NOT NULL,
            level INTEGER NOT NULL,
            pv INTEGER NOT NULL,
            attack INTEGER NOT NULL,
            defense INTEGER NOT NULL,
            pa INTEGER NOT NULL,
            pm INTEGER NOT NULL,
            xp INTEGER NOT NULL,
            biome TEXT NOT NULL,
            special_effects TEXT DEFAULT NULL,
            UNIQUE (type, level)
        );

        -- Table des types d'items (Arme, Armure, etc.)
        CREATE TABLE IF NOT EXISTS item_types (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT UNIQUE NOT NULL
        );

        -- Table des items (équipements)
        CREATE TABLE IF NOT EXISTS items (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type_id INTEGER NOT NULL,
            name TEXT NOT NULL,
            required_level INTEGER NOT NULL,
            bonus_force INTEGER DEFAULT 0,
            bonus_intelligence INTEGER DEFAULT 0,
            bonus_agility INTEGER DEFAULT 0,
            bonus_wisdom INTEGER DEFAULT 0,
            bonus_vita INTEGER DEFAULT 0,
            bonus_defense INTEGER DEFAULT 0,
            special_effect TEXT DEFAULT NULL,
            FOREIGN KEY (type_id) REFERENCES item_types(id),
            UNIQUE (type_id, name)
        );

        -- Table des recettes de craft
        CREATE TABLE IF NOT EXISTS craft_recipes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            item_id INTEGER NOT NULL,
            resource1 TEXT NOT NULL,
            quantity1 INTEGER NOT NULL,
            resource2 TEXT DEFAULT NULL,
            quantity2 INTEGER DEFAULT 0,
            resource3 TEXT DEFAULT NULL,
            quantity3 INTEGER DEFAULT 0,
            gold_cost INTEGER DEFAULT 0,
            FOREIGN KEY (item_id) REFERENCES items(id),
            UNIQUE (item_id)
        );

        -- Table des invocations
        CREATE TABLE IF NOT EXISTS invocations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT UNIQUE NOT NULL,
            required_level INTEGER NOT NULL,
            pv INTEGER NOT NULL,
            attack INTEGER NOT NULL,
            defense INTEGER NOT NULL,
            pa INTEGER NOT NULL,
            pm INTEGER NOT NULL,
            invocation_type TEXT NOT NULL,
            biome TEXT NOT NULL
        );

        -- Table des sorts des invocations
        CREATE TABLE IF NOT EXISTS invocation_spells (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            invocation_id INTEGER NOT NULL,
            name TEXT NOT NULL,
            cost_pa INTEGER NOT NULL,
            cost_pm INTEGER NOT NULL,
            range INTEGER NOT NULL,
            effect TEXT NOT NULL,
            spell_type TEXT NOT NULL,
            FOREIGN KEY (invocation_id) REFERENCES invocations(id),
            UNIQUE (invocation_id, name)
        );

        -- Table de progression des sorts par classe et niveau
        CREATE TABLE IF NOT EXISTS progression_spells (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            class_id INTEGER NOT NULL,
            level INTEGER NOT NULL,
            spells TEXT NOT NULL,  -- Liste de sorts séparés par ";"
            FOREIGN KEY (class_id) REFERENCES classes(id),
            UNIQUE (class_id, level)
        );

        -- Index pour optimiser les requêtes (inspiré de Waven)
        CREATE INDEX IF NOT EXISTS idx_class_levels_class_level ON class_levels(class_id, level);
        CREATE INDEX IF NOT EXISTS idx_spells_name ON spells(name);
        CREATE INDEX IF NOT EXISTS idx_enemies_type_level ON enemies(type, level);
        CREATE INDEX IF NOT EXISTS idx_items_name ON items(name);
        CREATE INDEX IF NOT EXISTS idx_invocations_name ON invocations(name);
        CREATE INDEX IF NOT EXISTS idx_class_spells_class_level ON class_spells(class_id, level_required);
    """)
    
    conn.commit()
    return conn


def load_classes(conn):
    """Charge les classes depuis classes.csv."""
    cursor = conn.cursor()
    
    # Insérer les classes
    classes = set()
    with open(DATA_DIR / "classes.csv", "r", encoding=get_encoding("classes.csv")) as f:
        reader = csv.DictReader(f)
        for row in reader:
            classes.add(row["Classe"])
    
    for class_name in classes:
        cursor.execute("INSERT INTO classes (name) VALUES (?)", (class_name,))
    
    conn.commit()


def load_class_levels(conn):
    """Charge les niveaux de classe depuis classes.csv."""
    cursor = conn.cursor()
    
    # Récupérer les IDs des classes
    cursor.execute("SELECT id, name FROM classes")
    class_ids = {row[1]: row[0] for row in cursor.fetchall()}
    
    with open(DATA_DIR / "classes.csv", "r", encoding=get_encoding("classes.csv")) as f:
        reader = csv.DictReader(f)
        for row in reader:
            class_name = row["Classe"]
            class_id = class_ids[class_name]
            
            cursor.execute("""
                INSERT INTO class_levels (
                    class_id, level, pa, pm, vita, force, intelligence, agility, wisdom, defense, xp_required
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                class_id,
                int(row["Niveau"]),
                int(row["PA"]),
                int(row["PM"]),
                int(row["Vita (PV)"]),
                int(row["Force (CAC)"]),
                int(row["Intelligence (Magie)"]),
                int(row["Agilité (Vit. Atk)"]),
                int(row["Sagesse (Précision)"]),
                int(row["Défense"]),
                int(row["XP pour atteindre ce niveau"])
            ))
    
    conn.commit()


def load_spells(conn):
    """Charge les sorts depuis sorts.csv."""
    cursor = conn.cursor()
    
    with open(DATA_DIR / "sorts.csv", "r", encoding=get_encoding("sorts.csv")) as f:
        reader = csv.DictReader(f)
        for row in reader:
            class_name = row["Classe"]
            
            cursor.execute("""
                INSERT INTO spells (
                    name, cost_pa, cost_pm, range, effect, required_level, spell_type, class_required
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                row["Nom"],
                int(row["Coût PA"]),
                int(row["Coût PM"]),
                int(row["Portée"]),
                row["Effet"],
                int(row["Niveau requis"]),
                row["Type"],
                class_name
            ))
    
    conn.commit()


def load_class_spells(conn):
    """Charge les associations entre classes et sorts depuis progression_sorts.csv."""
    cursor = conn.cursor()
    
    # Récupérer les IDs des classes
    cursor.execute("SELECT id, name FROM classes")
    class_ids = {row[1]: row[0] for row in cursor.fetchall()}
    
    # Récupérer les IDs des sorts
    cursor.execute("SELECT id, name, class_required FROM spells")
    spell_ids = {(row[2], row[1]): row[0] for row in cursor.fetchall()}
    
    # Utiliser un set pour éviter les doublons
    inserted_pairs = set()
    
    with open(DATA_DIR / "progression_sorts.csv", "r", encoding=get_encoding("progression_sorts.csv")) as f:
        reader = csv.DictReader(f)
        for row in reader:
            class_name = row["Classe"]
            class_id = class_ids[class_name]
            level = int(row["Niveau"])
            spells_list = row["Sorts débloqués (séparés par \";\")"].split(";")
            
            for spell_name in spells_list:
                spell_name = spell_name.strip()
                if spell_name:
                    spell_id = spell_ids.get((class_name, spell_name))
                    if spell_id:
                        pair = (class_id, spell_id)
                        if pair not in inserted_pairs:
                            cursor.execute("""
                                INSERT INTO class_spells (class_id, spell_id, level_required)
                                VALUES (?, ?, ?)
                            """, (class_id, spell_id, level))
                            inserted_pairs.add(pair)
    
    conn.commit()


def load_enemies(conn):
    """Charge les ennemis depuis ennemis.csv."""
    cursor = conn.cursor()
    
    with open(DATA_DIR / "ennemis.csv", "r", encoding=get_encoding("ennemis.csv")) as f:
        reader = csv.DictReader(f)
        for row in reader:
            cursor.execute("""
                INSERT INTO enemies (
                    type, level, pv, attack, defense, pa, pm, xp, biome, special_effects
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                row["Type"],
                int(row["Niveau"]),
                int(row["PV"]),
                int(row["Attaque"]),
                int(row["Défense"]),
                int(row["PA"]),
                int(row["PM"]),
                int(row["XP"]),
                row["Biome"],
                row["Effets spéciaux"]
            ))
    
    conn.commit()


def load_items(conn):
    """Charge les items depuis stuff.csv."""
    cursor = conn.cursor()
    
    # Insérer les types d'items
    item_types = set()
    with open(DATA_DIR / "stuff.csv", "r", encoding=get_encoding("stuff.csv")) as f:
        reader = csv.DictReader(f)
        for row in reader:
            item_types.add(row["Type"])
    
    for item_type in item_types:
        cursor.execute("INSERT INTO item_types (name) VALUES (?)", (item_type,))
    
    # Récupérer les IDs des types
    cursor.execute("SELECT id, name FROM item_types")
    type_ids = {row[1]: row[0] for row in cursor.fetchall()}
    
    # Insérer les items
    with open(DATA_DIR / "stuff.csv", "r", encoding=get_encoding("stuff.csv")) as f:
        reader = csv.DictReader(f)
        for row in reader:
            type_id = type_ids[row["Type"]]
            
            cursor.execute("""
                INSERT INTO items (
                    type_id, name, required_level, bonus_force, bonus_intelligence,
                    bonus_agility, bonus_wisdom, bonus_vita, bonus_defense, special_effect
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                type_id,
                row["Nom"],
                int(row["Niveau requis"]),
                int(row["Bonus Force"]),
                int(row["Bonus Intelligence"]),
                int(row["Bonus Agilité"]),
                int(row["Bonus Sagesse"]),
                int(row["Bonus Vita"]),
                int(row["Bonus Défense"]),
                row["Effet spécial"]
            ))
    
    conn.commit()


def load_craft_recipes(conn):
    """Charge les recettes de craft depuis craft.csv."""
    cursor = conn.cursor()
    
    # Récupérer les IDs des items
    cursor.execute("SELECT id, name FROM items")
    item_ids = {row[1]: row[0] for row in cursor.fetchall()}
    
    with open(DATA_DIR / "craft.csv", "r", encoding=get_encoding("craft.csv")) as f:
        reader = csv.DictReader(f)
        for row in reader:
            item_name = row["Nom"]
            item_id = item_ids.get(item_name)
            if not item_id:
                continue
            
            cursor.execute("""
                INSERT INTO craft_recipes (
                    item_id, resource1, quantity1, resource2, quantity2, resource3, quantity3, gold_cost
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                item_id,
                row["Ressource 1"],
                int(row["Quantité 1"]),
                row["Ressource 2"] if row["Ressource 2"] else None,
                int(row["Quantité 2"]) if row["Quantité 2"] else 0,
                row["Ressource 3"] if row["Ressource 3"] else None,
                int(row["Quantité 3"]) if row["Quantité 3"] else 0,
                int(row["Coût or"]) if row["Coût or"] else 0
            ))
    
    conn.commit()


def load_invocations(conn):
    """Charge les invocations depuis invocations.csv."""
    cursor = conn.cursor()
    filename = "invocations.csv"
    encoding = get_encoding(filename)
    
    with open(DATA_DIR / filename, "r", encoding=encoding) as f:
        reader = csv.DictReader(f)
        for row in reader:
            # Corriger les noms de colonnes mal encodés
            row = fix_row_encoding(row)
            
            cursor.execute("""
                INSERT INTO invocations (
                    name, required_level, pv, attack, defense, pa, pm, invocation_type, biome
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (
                row["Nom"],
                int(row["Niveau requis"]),
                int(row["PV"]),
                int(row["Attaque"]),
                int(row["Défense"]),
                int(row["PA"]),
                int(row["PM"]),
                row["Type"],
                row["Biome"]
            ))
    
    conn.commit()


def load_invocation_spells(conn):
    """Charge les sorts des invocations depuis sorts_invocations.csv."""
    cursor = conn.cursor()
    filename = "sorts_invocations.csv"
    encoding = get_encoding(filename)
    
    # Récupérer les IDs des invocations
    cursor.execute("SELECT id, name FROM invocations")
    invocation_ids = {row[1]: row[0] for row in cursor.fetchall()}
    
    with open(DATA_DIR / filename, "r", encoding=encoding) as f:
        reader = csv.DictReader(f)
        for row in reader:
            # Corriger les noms de colonnes mal encodés
            row = fix_row_encoding(row)
            
            invocation_name = row["Invocation"]
            if invocation_name == "Invocateur":
                continue  # Ignorer les sorts génériques de l'invocateur
            
            invocation_id = invocation_ids.get(invocation_name)
            if not invocation_id:
                continue
            
            cursor.execute("""
                INSERT INTO invocation_spells (
                    invocation_id, name, cost_pa, cost_pm, range, effect, spell_type
                ) VALUES (?, ?, ?, ?, ?, ?, ?)
            """, (
                invocation_id,
                row["Nom"],
                int(row["Coût PA"]),
                int(row["Coût PM"]),
                int(row["Portée"]),
                row["Effet"],
                row["Type"]
            ))
    
    conn.commit()


def load_progression_spells(conn):
    """Charge la progression des sorts depuis progression_sorts.csv."""
    cursor = conn.cursor()
    
    # Récupérer les IDs des classes
    cursor.execute("SELECT id, name FROM classes")
    class_ids = {row[1]: row[0] for row in cursor.fetchall()}
    
    with open(DATA_DIR / "progression_sorts.csv", "r", encoding=get_encoding("progression_sorts.csv")) as f:
        reader = csv.DictReader(f)
        for row in reader:
            class_name = row["Classe"]
            class_id = class_ids[class_name]
            level = int(row["Niveau"])
            spells_list = row["Sorts débloqués (séparés par \";\")"]
            
            cursor.execute("""
                INSERT INTO progression_spells (class_id, level, spells)
                VALUES (?, ?, ?)
            """, (class_id, level, spells_list))
    
    conn.commit()


def main():
    """Fonction principale."""
    print("Création de la base de données SQLite pour Zimut...")
    
    conn = create_database()
    
    print("Chargement des classes...")
    load_classes(conn)
    
    print("Chargement des niveaux de classe...")
    load_class_levels(conn)
    
    print("Chargement des sorts...")
    load_spells(conn)
    
    print("Chargement des associations classe/sort...")
    load_class_spells(conn)
    
    print("Chargement des ennemis...")
    load_enemies(conn)
    
    print("Chargement des items...")
    load_items(conn)
    
    print("Chargement des recettes de craft...")
    load_craft_recipes(conn)
    
    print("Chargement des invocations...")
    load_invocations(conn)
    
    print("Chargement des sorts des invocations...")
    load_invocation_spells(conn)
    
    print("Chargement de la progression des sorts...")
    load_progression_spells(conn)
    
    conn.close()
    print(f"Base de données créée avec succès : {DB_PATH}")


if __name__ == "__main__":
    main()
