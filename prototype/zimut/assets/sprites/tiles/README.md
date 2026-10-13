# Tuiles de sol — biome Forêt

Ces textures sont dessinées en SVG, format 128 × 64 px, avec un losange transparent aligné sur la grille isométrique 2:1.

- `forest_ground_01.svg` : herbe moussue lumineuse.
- `forest_ground_02.svg` : variante plus claire.
- `forest_ground_03.svg` : variante plus ombragée, avec pierres.
- `forest_ground_04.svg` : variante avec petites pierres moussues.

## Intégration au code

`scripts/Cell.gd` charge les fichiers depuis `res://assets/sprites/tiles/` dans `setup()`, uniquement si `biome == "Forêt"`. La variante est déterminée à partir des coordonnées de la case ; elle reste donc stable. Les autres biomes continuent à utiliser le sol dessiné par code.

Les contours et les surbrillances tactiques sont toujours dessinés par `Cell.gd` après la texture : les cases de déplacement, de portée, de cible et de survol restent fonctionnelles.

Si une texture est absente, le code émet un avertissement et revient au sol procédural existant.
