# ZOE - Prototype (Tour par Tour)
*Zimut: L'Odyssée des Éléments - Version 0.1*

## Description
Premier prototype du mode Aventure/Stratégie de Zimut.
- Grille 8x8 (140px par case).
- Tour par tour: Cliquez sur une case adjacente pour vous déplacer.
- Systeme de ressources: Faim et Soif diminuent a chaque tour.
- Objectif: Trouver la Pierre de la Terre.

## Lancer le Projet
1. Ouvrir Godot 4.x.
2. Importer le projet depuis prototype/zoe/.
3. Lancer la scene world.tscn.

## Controles
- Deplacement: Cliquez sur une case adjacente (haut, bas, gauche, droite).
- Recommencer: Bouton en haut a droite.
- Quitter: Bouton en haut a droite.

## Structure
- scenes/: Scenes Godot (player, tile, world, etc.).
- scripts/: Logique du jeu (GDScript).
- assets/sprites/: Images (a copier depuis prototype/shared/).

## Personnalisation
- Equilibrage: Modifiez les valeurs dans player.gd (faim, soif).
- Grille: Modifiez generate_grid() dans world.gd.
- Assets: Remplacez les sprites dans assets/sprites/.

## Prochaines Etapes
- Ajouter des enigmes simples (ex: pousser un rocher).
- Implementer le brouillard de guerre.
- Ajouter plus de biomes (Montagne, Ocean).