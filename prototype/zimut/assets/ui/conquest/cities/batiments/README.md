# Sprites de bâtiments — écran de ville de Conquête (V61b)

Chaque bâtiment dessiné par `ConquestCityView.gd` peut être remplacé par un PNG découpé
issu des planches de la génération. **Si le PNG n'existe pas, la vue dessine le bâtiment en
vectoriel comme avant** : aucun fichier n'est obligatoire, la ville reste jouable tant
qu'une nation n'est pas illustrée.

## Chemin

```
assets/ui/conquest/cities/batiments/<nation>/<bâtiment>[_<niveau>].png
```

Une nation = un dossier, même clé que `ConquestCityView.NATION_KEY` :
`sylvestre`, `cimes`, `sables`, `cristaux`, `marees`, `vents`, `brasier`, `brumes`,
`ombres`, `rouages`.

## Découpe des planches

Chaque planche livrée se découpe selon sa grille, cases numérotées de gauche à droite :

| Planche | Grille | Fichiers produits |
|---|---|---|
| hall | 5 × 1 | `hall_1.png` … `hall_5.png` (niveau de la ville) |
| caserne_residence | 2 × 1 | `caserne.png` (case 1), `residence.png` (case 2) |
| scierie, mine, tannerie, cabane, verger, muraille | 3 × 1 | `<bâtiment>_1.png`, `<bâtiment>_2.png`, `<bâtiment>_3.png` |
| merveille | 1 × 1 | `merveille.png` |
| icone | 1 × 1 | `icone_ville.png` (repère de l'icône de la nation — pas encore câblée dans le jeu) |

Nommage : minuscules, sans accent. Les bâtiments à niveaux (hall et production) portent le
suffixe `_1`/`_2`/`_3` ; `caserne`, `residence` et `merveille` n'ont pas de suffixe.

Détourage : fond transparent (les planches des Cimes, Marées et Vents ont un fond gris
`#808080` à supprimer). Personnages et accessoires facultatifs : le jeu dessine déjà
l'ombre au sol, la plaque de nom et les étoiles de niveau.

Recadrage automatique (V64) : au chargement, `ConquestCityView` recadre chaque PNG sur
ses pixels visibles — inutile de découper au pixel près, une découpe « au bord de case »
(avec des marges transparentes autour du bâtiment) est corrigée automatiquement et
l'échelle du bâtiment ne dépend plus de la découpe. Le canal alpha reste indispensable :
un PNG opaque est utilisé tel quel, bords compris.

## Dépôt dans le projet

1. Découper la planche selon la grille ci-dessus et déposer les PNG dans le dossier de la nation.
2. Ouvrir une fois le projet dans Godot (ou `godot --headless --import`) : les PNG sont
   importés automatiquement.
3. Commiter ensemble les `.png` **et** les `.png.import` générés :
   `tools/check_assets.py` (CI) échoue si un `.import` tracké n'a pas son PNG source tracké.

## Rendu dans le jeu

- Le sprite remplace le dessin vectoriel, posé au **point au sol** de la parcelle ;
  largeur fixée par `ConquestCityView.SPRITE_WIDTH` (hall et merveille 250 unités,
  production 200, caserne/résidence/cabane 180), hauteur à aspect conservé.
- Restent dessinés par-dessus le sprite : ombre au sol, plaque de nom/niveau, étoiles,
  soldats à l'exercice (caserne), gouverneur en poste (résidence).
- Test de non-régression : `tests/test_ville_sprites.gd` (chemins, couverture des nations,
  repli vectoriel) — exécuté par la CI.

Illustration de fond de l'écran de ville : `assets/ui/conquest/cities/<nation>.jpg`
(voir `SPRITES_A_FOURNIR.md`, §6).
