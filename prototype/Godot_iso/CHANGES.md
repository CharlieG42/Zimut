# Corrections appliquées — WildZimut Godot_iso v2

## 🔴 Bugs critiques corrigés

### `GameManager.gd` — Fonctions manquantes restaurées
Le fichier était **tronqué** : toutes les fonctions de gameplay étaient absentes.
Fonctions ajoutées / restaurées :
- `handle_cell_selected(x, y)` — gestion des clics sur la grille
- `_try_move()` — déplacement avec contrôle PM et distance
- `_try_basic_attack()` — attaque de mêlée (portée 1)
- `_try_cast_spell()` — lancement de sort avec vérification portée/PA/PM
- `_apply_spell()` — application des effets de sort (CAC, Magie, Défense, Soin)
- `handle_spell_selected()` — sélection/désélection d'un sort
- `next_player()` — passage au joueur suivant ou tour ennemi
- `_set_active_player()` — changement de joueur actif
- `_end_player_turn()` — fin du tour joueur
- `start_player_turn()` — début d'un nouveau tour joueur
- `remove_entity_from_grid()` — suppression d'une entité morte
- `check_game_over()` — vérification victoire/défaite
- `reset_game()` — remise à zéro complète
- `_refresh_grid()` — redessine la grille

### `Cell.gd` — Détection de clic corrigée
`_is_point_in_cell()` avait une logique **entièrement inversée** → aucun clic ne fonctionnait.
Remplacée par la formule mathématique correcte du losange :
  `|px - cx| / hw + |py - cy| / hh <= 1.0`

### `Main.gd` — Crash au démarrage supprimé
Des `disconnect()` étaient appelés sur des signaux **jamais connectés** → crash immédiat.
Remplacés par des `connect()` avec garde `is_connected()`.

## 🟡 Améliorations gameplay

### `TurnManager.gd` — IA ennemie corrigée
- Utilise `game_manager.start_player_turn()` (au lieu de `current_turn = 0` en dur)
- Les ennemis se déplacent case par case (multi-step selon PM)
- Vérification adjacence avant attaque cohérente avec le déplacement effectif

### `GameManager.gd` — Gameplay amélioré
- Déplacement multi-cases (distance Manhattan ≤ PM disponibles)
- Sort de soin auto-ciblé sur soi-même si aucun allié cliqué
- Désélection du sort en recliquant sur le même bouton
- Filtres `players`/`enemies` cohérents après mort d'entité

## 🟢 Améliorations visuelles (Cell.gd)

- Overlays d'état distincts : portée sort (rouge), portée déplacement (bleu), sélection (or)
- Double contour intérieur sur la cellule sélectionnée (style Waven)
- Barre de vie sous chaque entité (verte → jaune → rouge)
- Chevron "tour actif" au-dessus du personnage courant
- Ombre portée sous les entités
- Helpers `_colors3/_colors4` pour clarifier le code des polygones
