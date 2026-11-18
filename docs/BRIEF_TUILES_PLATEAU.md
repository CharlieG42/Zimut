# Brief : tuiles de sol du plateau (rendu façon Waven)

Objectif : remplacer les tuiles SVG actuelles (128×64, plates) par des tuiles peintes, avec du relief et de la matière, pour chaque biome. C'est le plus gros écart restant avec Waven.

## Constat actuel
- 10 biomes × 12 variantes, SVG 128×64, losange 2:1 (`assets/sprites/tiles/<biome>_ground_NN.svg`).
- Aplats avec petites taches répétées ; la grille et un voile de teinte sont ajoutés par `Cell.gd` par-dessus.
- À l'écran sur téléphone, une tuile fait environ 128×64 px logiques : la définition actuelle suffit à peine.

## Format demandé (par tuile)
- PNG transparent, **256×128 px** (2× la taille de jeu, pour rester net sur le S23+ et sur PC). Si ton outil le permet, 512×256 est un plus, je réduirai.
- Losange 2:1 aligné sur la grille : sommets en (128,2), (254,64), (128,126), (2,64). Rien ne dépasse du losange, sauf (optionnel) quelques brins d'herbe ou cailloux qui débordent d'au plus 10 px vers le haut.
- **Raccord sans couture** : les motifs qui touchent un bord doivent se continuer sur la tuile voisine (herbe, fissures, dalles). Teste en juxtaposant 4×4 tuiles.
- 12 variantes par biome (6 au minimum), avec des fréquences de rareté : 5 courantes, 4 moyennes, 3 rares (détails : fleurs, pierres, fissures).
- Pas de grille, pas de contour sombre dans l'image : le jeu les ajoute.

## Style
- Lumière unique : **en haut à gauche**, ombres douces vers le bas à droite.
- Valeurs calmes et peu contrastées (les personnages et les cases colorées doivent ressortir) ; la variation vient de la matière (touffes, dalles, éclats), pas d'aplats vifs.
- Bord supérieur légèrement plus clair, bord inférieur légèrement plus sombre : donne l'effet de dalle épaisse.
- Les détails restent sous le niveau des pieds des personnages : pas d'élément haut ni sombre au centre de la tuile.

## Motifs par biome
| Biome | Matière dominante | Détails |
|---|---|---|
| Forêt | herbe, mousse | trèfles, petites fleurs, pierres moussues, racines |
| Montagne (Cimes) | neige, roche | givre, cailloux, traces de pas |
| Désert (Sables) | sable, grès | rides de dune, pierres plates, fissures |
| Cristaux | ardoise | éclats lumineux, veines, poussière brillante |
| Marées | sable mouillé | flaques turquoise, coquillages, algues |
| Vents | herbe rase, pierre claire | plumes, rubans, dalles fendues |
| Brasier | basalte noir | fissures de lave, braises, cendres |
| Brumes | boue, mousse sombre | champignons phosphorescents, flaques, racines |
| Ombres | pavés runiques | ronces violettes, runes pâles, mousse noire |
| Rouages | dalles d'acier | rivets, engrenages gravés, plaques, rainures |

## Pour aller plus loin (optionnel, après un premier biome)
- **Bords de plateau** : une face latérale (terre/roche) en tuiles de 256×128 pour les falaises, par biome.
- **Surcouche de transition** (herbe qui déborde sur la pierre, eau/sable) : tuiles de bord à 4 orientations.
- **Carte de relief** (normal map) en niveaux de gris : je l'utiliserais pour un éclairage dynamique léger.

## Ce que je fais de mon côté
1. Charger les PNG à la place des SVG (repli automatique sur les SVG si un fichier manque).
2. Garder les tuiles de la Forêt comme biome de test, comparer avant/après sur téléphone, puis généraliser.
3. Régler la teinte du voile par biome pour qu'elle n'écrase pas la peinture.

## Questions ouvertes
- Quel outil pour dessiner les tuiles (génération d'images, Blender, dessin à la main) ? Cela décide du format de livraison et de la façon d'assurer le raccord.
- Un premier biome à traiter (je propose la Forêt, pour comparer directement avec l'existant) ?
