# Template Godot Complet - WildZimut

Exemple concret appliquant toutes les bonnes pratiques de GODOT_BEST_PRACTICES.md

## Structure

WildZimut/
- GODOT_BEST_PRACTICES.md
- project.godot
- scenes/
  - Main.tscn
  - Cell.tscn
- scripts/
  - entities/
    - Cell.gd
    - SpellButton.gd
  - GameManager.gd
  - Main.gd

## Cell.gd - Correction Critique

- Detection de clic isometrique avec formule du losange
- Signal cell_clicked(x: int, y: int)
- Rendu visuel professionnel

## GameManager.gd - Architecture Modulaire

- Typage explicite partout
- Signature compatible avec cell_clicked
- Deplacement multi-cases
- Utilisation de match

## Main.gd - Connexions Sure

- Connexions directes sans disconnect()
- Appel avec bonne signature

## Checklist

- Architecture modulaire
- Detection de clic testee
- Typage explicite
- Signaux compatibles
- Gameplay fonctionnel
- Rendu visuel riche

Reference: GODOT_BEST_PRACTICES.md