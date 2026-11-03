# Aventure 3D (bêta) — monde ouvert au sol

> Deuxième rendu du mode Aventure : le **même monde** que la carte classique, vu à la
> 3e personne. Réglage : **Réglages → Mode Aventure → Monde 3D (bêta)**. La carte classique
> reste le mode par défaut et reste accessible depuis le monde 3D (bouton « Carte classique »).

## Principe : deux couches

| Couche | Rendu | Rôle |
|---|---|---|
| **Exploration** | 3D low-poly (`scripts/adventure3d/`) | marcher, découvrir, ramasser, rencontrer |
| **Combats** | 2D isométrique, héros chibi (**inchangés**) | toute rencontre lance le combat Tactique habituel |

L'explorateur est **le joueur lui-même** (silhouette vectorielle low-poly), pas un héros.
Au retour d'un combat, on revient dans le monde 3D à la même place.

## Ce qui est réutilisé (aucune duplication d'état)

- `AdventureTerrain` : cases, île, obstacles, sentiers, portes, lieux → le monde 3D est généré
  à partir du même terrain déterministe (même carte = même disposition).
- `AdventureManager` / `AdventureMobs` / `ProgressionManager` : sauvegarde, groupes de monstres
  (apparition, errance, respawn), contrats, XP d'exploration, déblocage des cartes.
- `TeamSelection` → `Main` → fenêtre de résultat : le circuit de combat est exactement le même.

## Fichiers

```
scenes/Adventure3D.tscn
scripts/adventure3d/
  Adventure3D.gd      # scène : environnement, HUD, contacts (monstres, lieux, portes), sauvegarde
  Adv3DWorld.gd       # génération du monde 3D (sol, falaises, arbres, décors, marqueurs, explorateur)
  Adv3DExplorer.gd    # déplacement (glissement), caméra 3e personne orbitale
  Adv3DStick.gd       # joystick virtuel tactile / souris
tests/test_adventure3d.gd     # headless : monde, connexité, scène, combat
tests/shot_adventure3d.gd     # captures d'écran (xvfb)
```

## Contrôles

| Action | Tactile | PC |
|---|---|---|
| Se déplacer | stick à gauche | ZQSD / WASD / flèches |
| Tourner la caméra | glisser sur l'écran | clic droit + glisser |
| Lieu proche | bouton d'action en bas à droite | idem |

## Ce que gère déjà la bêta

- Groupes de monstres visibles : contact → proposition de combat (« Plus tard » le laisse passer).
- Lieux : combat, coffre, camp, belvédère, sentier.
- Portes entre cartes (routes gardées respectées) : on change de carte et la scène se recharge.
- Position 3D sauvegardée (`adventure.pos3d`) ; si la carte classique déplace le héros, on reprend sa case.

## Reste à faire

- [ ] Énigmes (3 types) et donjons dans le monde 3D (aujourd'hui : via « Carte classique »).
- [ ] Brouillard de découverte 3D et mini-carte.
- [ ] Biomes des Nations (Vents, Brumes, Brasier…) : palettes et props dédiés (repli sur la Forêt).
- [ ] Sprites HD / ambiance sonore par zone ; pinch pour zoomer.
- [ ] Mesure de fluidité sur téléphone milieu de gamme (pas d'ombres temps réel pour l'instant).

---

# Monde Ouvert 3D — 4e mode de jeu (V79)

Quatrième bouton de mode dans **Mes Parties → Choisir un mode de jeu** :
« Monde Ouvert 3D ». C'est le **même monde et la même sauvegarde** que les
autres modes Aventure (héros, loots, XP, difficulté et temps de jeu sont ceux
de la partie) ; seule la présentation change, façon Zelda / RPG :

- déplacement libre au sol, caméra 3e personne plus basse et plus proche
  (`OW_PITCH` / `OW_DISTANCE` dans `AdventureOpen3D.gd`) ;
- **toucher un groupe de monstres → le combat Tactique se lance directement**
  (TeamSelection → Main, inchangé) ;
- **entrer dans un donjon → les 4 salles se lancent directement** ;
- franchir une porte ouverte → la zone voisine se charge ;
- au retour d'un combat (victoire ou défaite), on revient dans le monde ouvert
  à la même place : la vue utilisée est mémorisée dans la sauvegarde
  (`adventure_view` = `"open3d"`, et `GameSettings.adventure_scene()` s'y réfère).

Le HUD reprend tout ce qui est commun aux autres modes : bandeau de zone avec
biome, niveau, **difficulté de la partie** et **temps de jeu du mode** (bucket
`openworld`, affiché aussi dans « Mes Parties »), boutons d'accès aux **héros**
(fiches) et au **butin** (inventaire commun), mini-carte, boutons vers les deux
autres vues d'Aventure (« Carte 2D », « Vue 3D iso »).

Un contact déjà « décliné » (monstre/donjon encore sous le joueur au retour d'un
combat) ne redéclenche pas tant qu'on ne s'en éloigne pas.

```
scenes/AdventureOpen3D.tscn
scripts/adventure3d/AdventureOpen3D.gd   # scène du 4e mode (réutilise Adv3D* + AdventureManager)
tests/test_adventure_open3d.gd            # headless : routage, sauvegarde partagée, playtime, combats
```

## Le 4e mode « Monde Ouvert 3D » (V79)

La scène `AdventureOpen3D.tscn` (`scripts/adventure3d/AdventureOpen3D.gd`) est le **4e mode de jeu**,
lancé depuis « Mes Parties » : caméra plus basse et plus proche (façon Zelda/RPG), toucher un
groupe de monstres ou entrer dans un donjon lance **directement** le combat Tactique, et on
revient à la même place après le combat. La vue d'Aventure utilisée est mémorisée dans la
sauvegarde (`adventure_view` : `"map"`, `"3d"` ou `"open3d"`) : `GameSettings.adventure_scene()`
y revient après chaque combat. HUD du monde ouvert : boutons Carte 2D / Vue 3D iso / **Héros** /
Butin / Menu, ligne d'infos (biome, niveau de zone, difficulté de la partie, temps de jeu du
bucket « openworld »), mini-carte. Test : `tests/test_adventure_open3d.gd`.

## HUD de cette vue 3D iso (V80)

- Bouton **« Héros »** en haut à droite : fiche complète des héros (niveaux, caractéristiques,
  sorts, équipement), même écran que depuis « Mes Parties ».
- Ligne sous le nom de zone : vue en cours, **temps de jeu** du mode Aventure et **difficulté**
  de la partie (rafraîchie chaque seconde et à chaque écriture du compteur).
## V81 — Monde ouvert par nations, mini-carte ronde et pop-up de rencontre

- **Une grande zone instanciée par nation** (54 × 36 depuis V82 ; 36 × 24 en V81, 14 × 10 avant) : les anciennes
  petites cartes ont été fondues dans la zone de leur nation (ex. `foret_ronces`/`lisiere_col`
  → `foret_sylve`). Les 10 nations + le Donjon forment un chemin de 11 zones reliées par
  **1 à 2 portails maximum** chacune (`AdventureTerrain.gates_of` dérive les portails de la
  grille). Les POI du catalogue sont relocalisés (donjon de chaque nation en `30,18`) et
  complétés par des lieux **générés de façon déterministe** (`ProgressionManager.pois_of`)
  ; les groupes de monstres suivent la taille (`AdventureMobs.per_zone`).
- **Mini-carte ronde en haut à droite** (`Adv3DMinimap._tex_round`, masque circulaire) ;
  toucher → **carte plein écran à deux onglets** : « Instance » (la nation courante, avec
  lieux/monstres/portails et légende) et « **Monde** » (`Adv3DWorldMap` : toutes les nations,
  portails ouverts en vert / fermés en rouge, nation courante surlignée).
- **Caméra reculée** (`OW_DISTANCE` 7.2 → 9.8, `OW_PITCH` -0.46 → -0.55).
- **Rencontre avec un groupe de monstres → pop-up « COMBATTRE / PLUS TARD »** (comme la
  version initiale), au lieu de lancer le combat directement.
- **Graphisme** : entrée de donjon retravaillée (hautes tours crénelées, **portail violet
  lumineux**, bannières, gemme flottante et grosse gemme de marqueur), lumière ambiante et
  saturation relevées, brouillard un peu plus dense sur les grandes zones, plus de décor au sol.
- Tests : `test_adventure_open3d.gd` (monde par nations, ≤ 2 portails, caméra, mini-carte ronde,
  pop-up, onglets), `test_adventure_world.gd` / `test_adventure_island.gd` / `test_adventure_v2.gd`
  / `test_adventure_mobs.gd` mis à jour.


## V82 — Refonte du Monde Ouvert (TEST)

- **Zones ×1,5** (54 × 36) ; lieux, énigmes et sentiers recalés sur la nouvelle grille ; 12 lieux générés par zone, 10 trouvailles.
- **Relief** (`Adv3DWorld.set_relief`) : collines en deux octaves, amplitude par nation (`OPEN_AMPLITUDE`), aplanies autour des lieux/départ/portes ; la vue iso garde son relief doux. Nuances de couleur par région et altitude (`_open_tint`).
- **Caméra** : `OW_DISTANCE` 14,6 (contre 9,8 en V81 initial).
- **Donjons à paliers** : clé « Nation#1 », « Nation#2 » (paliers 1-2, générés par `ProgressionManager._add_dungeon_tiers`), « Nation » = palier 3 (Gardien + Pierre). `Dungeons.base/tier/tier_key` ; niveaux décalés dans la tranche de la nation, pas de Pierre aux paliers 1-2.
- **Carte du monde** : `Adv3DWorldMap` dessinée sur `conquest_world_map.jpg`, repères `NATION_POS`.
- Test : `tests/test_monde_ouvert_v82.gd` ; captures : `tests/shot_openworld.gd`.
