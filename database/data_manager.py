#!/usr/bin/env python3
"""
Gestionnaire de données SQLite pour Zimut.
Inspiré de Waven, ce module fournit une API pour interroger la base de données.
"""

import sqlite3
from pathlib import Path
from typing import List, Dict, Optional, Any


class ZimutDataManager:
    """Gestionnaire de données pour Zimut."""
    
    def __init__(self, db_path: Optional[str] = None):
        """
        Initialise le gestionnaire de données.
        
        Args:
            db_path: Chemin vers la base de données SQLite. Si None, utilise le chemin par défaut.
        """
        if db_path is None:
            db_path = str(Path(__file__).parent / "zimut.db")
        self.db_path = db_path
        self.conn = sqlite3.connect(db_path)
        self.conn.row_factory = sqlite3.Row
        self._initialize()
    
    def _initialize(self):
        """Initialise la connexion et vérifie que la base existe."""
        try:
            self.conn.execute("SELECT 1 FROM classes LIMIT 1")
        except sqlite3.OperationalError:
            raise ValueError(f"La base de données {self.db_path} n'existe pas ou est corrompue.")
    
    def close(self):
        """Fermer la connexion à la base de données."""
        self.conn.close()
    
    # ==================== Méthodes pour les classes ====================
    
    def get_all_classes(self) -> List[Dict[str, Any]]:
        """Récupère toutes les classes."""
        cursor = self.conn.cursor()
        cursor.execute("SELECT * FROM classes")
        return [dict(row) for row in cursor.fetchall()]
    
    def get_class_id(self, class_name: str) -> Optional[int]:
        """Récupère l'ID d'une classe par son nom."""
        cursor = self.conn.cursor()
        cursor.execute("SELECT id FROM classes WHERE name = ?", (class_name,))
        row = cursor.fetchone()
        return row["id"] if row else None
    
    def get_class_levels(self, class_name: str) -> List[Dict[str, Any]]:
        """Récupère tous les niveaux d'une classe avec leurs stats."""
        class_id = self.get_class_id(class_name)
        if not class_id:
            return []
        
        cursor = self.conn.cursor()
        cursor.execute("""
            SELECT * FROM class_levels 
            WHERE class_id = ? 
            ORDER BY level
        """, (class_id,))
        return [dict(row) for row in cursor.fetchall()]
    
    def get_class_stats_at_level(self, class_name: str, level: int) -> Optional[Dict[str, Any]]:
        """Récupère les stats d'une classe à un niveau donné."""
        class_id = self.get_class_id(class_name)
        if not class_id:
            return None
        
        cursor = self.conn.cursor()
        cursor.execute("""
            SELECT * FROM class_levels 
            WHERE class_id = ? AND level = ?
        """, (class_id, level))
        row = cursor.fetchone()
        return dict(row) if row else None
    
    # ==================== Méthodes pour les sorts ====================
    
    def get_all_spells(self, class_name: Optional[str] = None) -> List[Dict[str, Any]]:
        """Récupère tous les sorts, éventuellement filtrés par classe."""
        cursor = self.conn.cursor()
        if class_name:
            cursor.execute("""
                SELECT * FROM spells 
                WHERE class_required = ? 
                ORDER BY required_level
            """, (class_name,))
        else:
            cursor.execute("SELECT * FROM spells ORDER BY required_level")
        return [dict(row) for row in cursor.fetchall()]
    
    def get_spell_by_name(self, spell_name: str, class_name: Optional[str] = None) -> Optional[Dict[str, Any]]:
        """Récupère un sort par son nom et éventuellement sa classe."""
        cursor = self.conn.cursor()
        if class_name:
            cursor.execute("""
                SELECT * FROM spells 
                WHERE name = ? AND class_required = ?
            """, (spell_name, class_name))
        else:
            cursor.execute("SELECT * FROM spells WHERE name = ?", (spell_name,))
        row = cursor.fetchone()
        return dict(row) if row else None
    
    def get_spells_for_class_at_level(self, class_name: str, level: int) -> List[Dict[str, Any]]:
        """Récupère les sorts débloqués pour une classe à un niveau donné."""
        class_id = self.get_class_id(class_name)
        if not class_id:
            return []
        
        cursor = self.conn.cursor()
        cursor.execute("""
            SELECT s.* FROM spells s
            JOIN class_spells cs ON s.id = cs.spell_id
            WHERE cs.class_id = ? AND cs.level_required <= ?
            ORDER BY s.required_level
        """, (class_id, level))
        return [dict(row) for row in cursor.fetchall()]
    
    def get_progression_spells(self, class_name: str) -> List[Dict[str, Any]]:
        """Récupère la progression des sorts pour une classe."""
        class_id = self.get_class_id(class_name)
        if not class_id:
            return []
        
        cursor = self.conn.cursor()
        cursor.execute("""
            SELECT * FROM progression_spells 
            WHERE class_id = ? 
            ORDER BY level
        """, (class_id,))
        return [dict(row) for row in cursor.fetchall()]
    
    # ==================== Méthodes pour les ennemis ====================
    
    def get_all_enemies(self, biome: Optional[str] = None) -> List[Dict[str, Any]]:
        """Récupère tous les ennemis, éventuellement filtrés par biome."""
        cursor = self.conn.cursor()
        if biome:
            cursor.execute("""
                SELECT * FROM enemies 
                WHERE biome = ? 
                ORDER BY level
            """, (biome,))
        else:
            cursor.execute("SELECT * FROM enemies ORDER BY level")
        return [dict(row) for row in cursor.fetchall()]
    
    def get_enemy_by_type_and_level(self, enemy_type: str, level: int) -> Optional[Dict[str, Any]]:
        """Récupère un ennemi par son type et son niveau."""
        cursor = self.conn.cursor()
        cursor.execute("""
            SELECT * FROM enemies 
            WHERE type = ? AND level = ?
        """, (enemy_type, level))
        row = cursor.fetchone()
        return dict(row) if row else None
    
    def get_enemies_by_biome(self, biome: str) -> List[Dict[str, Any]]:
        """Récupère tous les ennemis d'un biome donné."""
        cursor = self.conn.cursor()
        cursor.execute("""
            SELECT * FROM enemies 
            WHERE biome = ? 
            ORDER BY level
        """, (biome,))
        return [dict(row) for row in cursor.fetchall()]
    
    # ==================== Méthodes pour les items ====================
    
    def get_all_items(self, item_type: Optional[str] = None) -> List[Dict[str, Any]]:
        """Récupère tous les items, éventuellement filtrés par type."""
        cursor = self.conn.cursor()
        if item_type:
            cursor.execute("""
                SELECT i.* FROM items i
                JOIN item_types it ON i.type_id = it.id
                WHERE it.name = ?
                ORDER BY i.required_level
            """, (item_type,))
        else:
            cursor.execute("SELECT i.* FROM items i ORDER BY i.required_level")
        return [dict(row) for row in cursor.fetchall()]
    
    def get_item_by_name(self, item_name: str) -> Optional[Dict[str, Any]]:
        """Récupère un item par son nom."""
        cursor = self.conn.cursor()
        cursor.execute("SELECT * FROM items WHERE name = ?", (item_name,))
        row = cursor.fetchone()
        return dict(row) if row else None
    
    def get_items_by_required_level(self, level: int) -> List[Dict[str, Any]]:
        """Récupère tous les items accessibles à un niveau donné."""
        cursor = self.conn.cursor()
        cursor.execute("""
            SELECT * FROM items 
            WHERE required_level <= ? 
            ORDER BY required_level
        """, (level,))
        return [dict(row) for row in cursor.fetchall()]
    
    def get_craft_recipe(self, item_name: str) -> Optional[Dict[str, Any]]:
        """Récupère la recette de craft pour un item."""
        item = self.get_item_by_name(item_name)
        if not item:
            return None
        
        cursor = self.conn.cursor()
        cursor.execute("""
            SELECT * FROM craft_recipes 
            WHERE item_id = ?
        """, (item["id"],))
        row = cursor.fetchone()
        return dict(row) if row else None
    
    # ==================== Méthodes pour les invocations ====================
    
    def get_all_invocations(self) -> List[Dict[str, Any]]:
        """Récupère toutes les invocations."""
        cursor = self.conn.cursor()
        cursor.execute("SELECT * FROM invocations ORDER BY required_level")
        return [dict(row) for row in cursor.fetchall()]
    
    def get_invocation_by_name(self, invocation_name: str) -> Optional[Dict[str, Any]]:
        """Récupère une invocation par son nom."""
        cursor = self.conn.cursor()
        cursor.execute("SELECT * FROM invocations WHERE name = ?", (invocation_name,))
        row = cursor.fetchone()
        return dict(row) if row else None
    
    def get_invocation_spells(self, invocation_name: str) -> List[Dict[str, Any]]:
        """Récupère les sorts d'une invocation."""
        invocation = self.get_invocation_by_name(invocation_name)
        if not invocation:
            return []
        
        cursor = self.conn.cursor()
        cursor.execute("""
            SELECT * FROM invocation_spells 
            WHERE invocation_id = ?
        """, (invocation["id"],))
        return [dict(row) for row in cursor.fetchall()]
    
    # ==================== Méthodes utilitaires pour le combat ====================
    
    def get_combat_data_for_class(self, class_name: str, level: int) -> Dict[str, Any]:
        """
        Récupère toutes les données nécessaires pour le combat pour une classe à un niveau donné.
        
        Returns:
            Dict avec les stats de base, les sorts débloqués, etc.
        """
        stats = self.get_class_stats_at_level(class_name, level)
        if not stats:
            return {}
        
        spells = self.get_spells_for_class_at_level(class_name, level)
        
        return {
            "class_name": class_name,
            "level": level,
            "stats": stats,
            "spells": spells
        }
    
    def get_combat_data_for_enemy(self, enemy_type: str, level: int) -> Dict[str, Any]:
        """
        Récupère toutes les données nécessaires pour le combat pour un ennemi.
        
        Returns:
            Dict avec les stats de l'ennemi.
        """
        enemy = self.get_enemy_by_type_and_level(enemy_type, level)
        if not enemy:
            return {}
        return {
            "enemy_type": enemy_type,
            "level": level,
            "stats": enemy
        }
    
    def search_spells(self, keyword: str) -> List[Dict[str, Any]]:
        """Recherche des sorts par mot-clé (dans le nom ou l'effet)."""
        cursor = self.conn.cursor()
        cursor.execute("""
            SELECT * FROM spells 
            WHERE name LIKE ? OR effect LIKE ?
            ORDER BY required_level
        """, (f"%{keyword}%", f"%{keyword}%"))
        return [dict(row) for row in cursor.fetchall()]
    
    def search_items(self, keyword: str) -> List[Dict[str, Any]]:
        """Recherche des items par mot-clé (dans le nom ou l'effet spécial)."""
        cursor = self.conn.cursor()
        cursor.execute("""
            SELECT * FROM items 
            WHERE name LIKE ? OR special_effect LIKE ?
            ORDER BY required_level
        """, (f"%{keyword}%", f"%{keyword}%"))
        return [dict(row) for row in cursor.fetchall()]


# ==================== Fonction utilitaire pour tester le gestionnaire ====================

def test_data_manager():
    """Teste le gestionnaire de données."""
    print("Test du gestionnaire de données Zimut...")
    
    try:
        manager = ZimutDataManager()
        
        # Test des classes
        classes = manager.get_all_classes()
        print(f"Nombre de classes : {len(classes)}")
        
        # Test des sorts pour une classe
        tank_spells = manager.get_all_spells("Tank")
        print(f"Nombre de sorts pour Tank : {len(tank_spells)}")
        
        # Test des ennemis
        enemies = manager.get_all_enemies()
        print(f"Nombre d'ennemis : {len(enemies)}")
        
        # Test des items
        items = manager.get_all_items()
        print(f"Nombre d'items : {len(items)}")
        
        # Test des invocations
        invocations = manager.get_all_invocations()
        print(f"Nombre d'invocations : {len(invocations)}")
        
        # Test des données de combat
        combat_data = manager.get_combat_data_for_class("Tank", 10)
        print(f"Données de combat pour Tank niveau 10 : {combat_data['stats']['vita']} PV")
        
        manager.close()
        print("Tous les tests ont réussi !")
        
    except Exception as e:
        print(f"Erreur : {e}")


if __name__ == "__main__":
    test_data_manager()
