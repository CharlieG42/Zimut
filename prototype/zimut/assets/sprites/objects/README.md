# Décors de forêt — kit graphique 01

Ressources SVG vectorielles, fond transparent, dans le style cartoon coloré de Zimut.

- `forest_tree.svg`, `forest_tree_broad.svg`, `forest_tree_round.svg` : trois silhouettes d'arbres forestiers choisies de façon déterministe pour limiter la répétition.
- `forest_boulder.svg` : rocher. Il est chargé par `scripts/Prop.gd` pour le type d'obstacle `rock`.
- `forest_fern.svg` : fougère décorative, prête pour un futur placement de décor.
- `forest_mushrooms.svg` : groupe de champignons décoratifs.
- `forest_stump.svg` : souche décorative.

Les SVG sont des ressources Godot standard et restent modifiables. `scripts/ForestAmbience.gd` ajoute aussi des lucioles et feuilles flottantes discrètes, actives uniquement dans le biome Forêt. Les fougères, champignons et souches restent disponibles comme éléments décoratifs pour une prochaine étape de placement.

## Direction artistique — forêt (lot peint)

Les trois variantes d'arbres et le rocher ont été redessinés avec des silhouettes plus organiques, des masses de feuillage superposées, des dégradés simples et des ombres intégrées. La palette du sol forestier est légèrement plus profonde et moins fluorescente, avec des reflets plus doux. Ces ressources conservent leurs dimensions et leur ancrage afin de limiter les changements dans le placement existant.

Note : il s'agit d'une étape intermédiaire en SVG vectoriel stylisé, pas encore d'une texture peinte haute définition comme les références. Elle prépare l'intégration et la cohérence avant un éventuel lot d'illustrations raster plus détaillées.

## Chargement dans le jeu

- Les arbres d'obstacle et le rocher sont chargés par `scripts/Prop.gd` depuis `res://assets/sprites/objects/`.
- Les nouvelles tuiles de sol sont chargées par `scripts/Cell.gd` depuis `res://assets/sprites/tiles/` ; voir le README du dossier `tiles`.
- Les fichiers fougère, champignons et souche ne sont pas encore instanciés automatiquement dans le combat ; ils sont uniquement disponibles pour le futur habillage du décor.
