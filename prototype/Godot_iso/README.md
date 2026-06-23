# WildZimut_Iso - Prototype Godot Isométrique

Prototype du jeu **WildZimut** avec un **rendu isométrique 2D** dans le style de Dofus Touch ou Waven.

Ce projet reprend **TOUTES les fonctionnalités** du prototype prototype/Godot (système de combat tour par tour, classes, sorts, ennemis) mais avec une **vue isométrique 2D**.

## Structure
- 3 classes de joueurs: Tank, Assassin, Mage
- 3 types d'ennemis: Gobelin, Squelette, Loup
- 6 sorts avec système PA/PM
- Tour par tour: joueurs puis ennemis
- Grille isométrique 10x10
- UI complète avec panneau de sorts et ordre de tour

## Comparaison avec prototype/Godot
- Même GameManager.gd (logique de jeu)
- Même Main.gd (UI) adapté pour isométrique
- Même Cell.gd adapté pour rendu isométrique
- Même SpellButton.gd
- Grille 10x10 au lieu de 8x8
- Rendu isométrique au lieu de 2D classique