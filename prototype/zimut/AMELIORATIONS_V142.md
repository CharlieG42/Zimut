# V142 — Donjons, portails et sentiers de l'Aventure 3D ; neige des Cimes

## 1. Cinq donjons par Nation dans les vues 3D

Le monde généré (vue 3D iso et Monde Ouvert 3D) ne posait que les paliers 2 et 4 plus le Gardien, soit
3 donjons. Il pose maintenant les **paliers 1 à 4 et le Gardien**, comme les planches de la carte 2D, avec
les mêmes noms (Sylve : Grotte de la Feuille, Antre de la Patte, Sanctuaire de Cristal, Crypte du Chêne
Noir, puis le Donjon de la Nation). Les paliers 2 et 4 n'ont pas bougé de place ; les compteurs de la
sauvegarde sont repris tels quels (ils sont rangés par donjon, pas par position).

`ProgressionManager.DUNGEON_TIER_NAMES` (4 noms par Nation), `DUNGEON_TIER_ANCHORS`, `DUNGEON_TIER_ORDER`.

## 2. Accès aux Nations : une seule règle

> Une Nation s'ouvre quand **tous les donjons de la Nation précédente** ont été terminés au moins une fois.
> Aucune condition de niveau. Revenir en arrière est toujours permis.

Avant, trois règles se contredisaient : un simple combat (`key_poi`) ouvrait la route dans les vues 3D, une
Nation « pas plus difficile » était toujours ouverte (d'où les liaisons vertes entre Nations verrouillées),
et la carte 2D demandait le seul donjon final.

- `adventure_chain()` : ordre des Nations ; `adventure_dungeons_left()` / `adventure_nation_cleared()` ;
  `adventure_zone_accessible()` ; `adventure_gate_open()` et `adventure_gate_lock_reason()` réécrits.
- `AdventureManager.portal_lock()` (carte 2D) suit la même règle et liste les donjons restants.
- Le dernier donjon manquant, quel que soit son palier, débloque la Nation suivante.
- **Sauvegardes** : à la lecture, les Nations ouvertes trop tôt par les anciennes règles sont refermées. La
  Nation où se trouve le joueur, et celles d'avant, restent toujours accessibles (personne n'est bloqué).
- **Carte du monde** : liaisons tracées dans l'ordre de progression, vertes seulement entre deux Nations
  accessibles, courbées pour ne pas passer sous le médaillon d'une autre Nation.

## 3. Sentiers

Chaque lieu recevait son plus court chemin depuis le départ : tous longeaient le même axe puis partaient
à angle droit, d'où un peigne de couloirs parallèles. `AdventureTerrain._trail_network` raccorde chaque
lieu, du plus proche au plus lointain, au sentier déjà tracé le plus proche ; le tracé suit un relief de
coûts qui le fait onduler et évite le bord des vides. Le ravin intérieur est dessiné comme une faille sur
la mini-carte (ce n'est plus un trou noir).

Effet de bord : dans les zones générées, l'emplacement des arbres et de quelques lieux secondaires change
(ils évitent les nouveaux sentiers).

## 4. Rendu des Cimes en 3D

Sans nouvel asset :

- **Neige sur le décor** : les shaders du décor blanchissent les faces tournées vers le ciel (buissons,
  rochers, souches, piliers, modèles des kits). Réglage global `zimut_snow` (project.godot,
  `[shader_globals]`), posé une fois par zone ; coût par image négligeable, aucune géométrie ajoutée.
- **Sol** : neige franche, sentiers de terre battue claire.
- **Herbe** : rare et givrée (densité 0,32) au lieu d'un tapis de touffes sombres ; perce-neige et fleurs
  de glace à la place des fleurs des prés.
- **Pied des pins** : rond de terre dégagée.
- **Lumière** : soleil plus chaud et plus franc, ambiance bleutée : ombres bleues nettes.

Triangles par image sur la vue de test : 182 310 avant, 178 627 après.

## Tests

`tests/test_v142_nations.gd` (nouveau) ; `test_adventure_world`, `test_monde_ouvert_v82`,
`test_portail_nations`, `test_portail_visible` alignés sur la nouvelle règle.
