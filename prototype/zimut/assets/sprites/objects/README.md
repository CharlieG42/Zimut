# Décors de forêt — kit graphique 01

Ressources SVG vectorielles, fond transparent, dans le style cartoon coloré de Zimut.

- `forest_tree.svg`, `forest_tree_broad.svg`, `forest_tree_round.svg` : trois silhouettes d'arbres forestiers choisies de façon déterministe pour limiter la répétition.
- `forest_boulder.svg` : rocher. Il est chargé par `scripts/Prop.gd` pour le type d'obstacle `rock`.
- `forest_fern.svg` : fougère décorative, prête pour un futur placement de décor.
- `forest_mushrooms.svg` : groupe de champignons décoratifs.
- `forest_stump.svg` : souche décorative.

Les SVG sont des ressources Godot standard et restent modifiables. `scripts/ForestAmbience.gd` ajoute aussi des lucioles et feuilles flottantes discrètes, actives uniquement dans le biome Forêt. Les fougères, champignons et souches restent disponibles comme éléments décoratifs pour une prochaine étape de placement.