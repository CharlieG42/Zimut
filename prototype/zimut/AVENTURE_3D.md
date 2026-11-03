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


## V83 — Planches illustrées du mode 2D (TEST)

- `BoardArt` (scripts/BoardArt.gd) : une zone peut avoir une planche `data/boards/<zone>.json` + `assets/boards/<zone>.jpg`. Active **uniquement** quand la partie est dans la carte 2D (`adventure_view == "map"`, posé avant le chargement de l'état) ; les vues 3D/monde ouvert gardent le terrain généré.
- Le JSON contient : grille (cases de 16 px d'illustration, 32 px dans le monde 2D), masque des cases jouables (`#`), départ, lieux (entrées de donjon en « Forêt#1 » à « Forêt#4 » + « Forêt » = Grand Arbre).
- `tools/gen_board.py <image> <zone>` : détecte les sentiers/clairières par couleur, applique des blocs (couronnes d'arbres) et des traits (accès aux entrées), écrit le JSON et une image de contrôle.
- `Dungeons.TIERS` = 5 : le monde ouvert utilise les paliers 2 et 4 (+ le Gardien), la planche 2D les paliers 1 à 4 (+ le Gardien).
- Pas de portes sur une planche (voyage par la carte du monde) ; pas de brouillard ; 14 groupes de monstres maximum.
- V84 : masque « inversé » (tout est marchable sauf eau/roche/arbres denses, `tools/gen_board.py`), grille 96 × 64, `BOARD_STEP_TIME` 0,085 s, appui sur un obstacle → case libre la plus proche (`_board_nearest_free`).
- Retouche en jeu : bouton « ✎ Masque » (Ouvrir / Fermer / Déplacer / Enregistrer / Copier / Annuler tout). Enregistrée dans `user://boards/<zone>_edits.json` ({open, close}) et rechargée au lancement ; « Copier » met le JSON dans le presse-papiers pour l'intégrer au masque généré.
- Test : `tests/test_planche_2d.gd` ; captures : `tests/shot_planche.gd`.


## V85 — Rendu « cartoon » (TEST)

- `Adv3DMeshes.TOON_LIGHT` : fonction `light()` partagée (demi-Lambert en paliers adoucis, ombre teintée `shade_tint`, rim `rim_color`). `solid_material()` et `foliage_material()` sont désormais des `ShaderMaterial` (même shader, `sway = 0` pour le rigide) ; la matière des personnages (`Adv3DHeroModel.char_material`) l'utilise aussi, avec son contour.
- `Adv3DMeshes.setup_sun(sun, env)` : ombres temps réel du soleil (2 cascades, 70 m) quand `GfxQuality` n'est pas « Économie » ; `real_shadows` allège alors les ombres rondes et active `cast_shadow` sur les gros décors (`_casts_shadow`) et le héros. L'herbe, les fleurs et les cailloux ne projettent pas d'ombre.
- Ciel : `sky_curve`, disque solaire, `fog_sun_scatter`. Captures : `tests/shot_openworld.gd`.


## V86 — Peinture et feuillage en cartes (TEST)

- `tools/gen_textures3d.py` → `assets/textures3d/paint.png` (aplats + coups de pinceau, tuilable) et `leaf.png` (amas de feuilles RGBA). Mipmaps activés dans leurs `.import`.
- Shader partagé (`Adv3DMeshes.FOLIAGE_SHADER`) : peinture triplanaire monde (`paint_amt` : 0,4 solide / 0,18 feuillage), et « cartes » : un sommet à UV non nul échantillonne `leaf_tex` (alpha scissor). `_begin()` pose UV (0,0) pour tous les sommets ordinaires.
- `Adv3DMeshes.add_cards()` : couronne de quads orientés en spirale, normales dirigées vers l'extérieur (ombrage rond) ; utilisée par `broadleaf`, `birch`, `bush`. Pins, palmiers et cactus restent inchangés.
- Assets externes : les dépôts publics Kenney (starter kits) n'ont presque rien de naturel et kenney.nl / Quaternius sont inaccessibles depuis l'environnement de travail → pas d'import glTF pour l'instant (un pack déposé dans `assets/` pourrait être instancié via `PackedScene`).


## V87 — Nature MegaKit (TEST)

- `assets/nature/` : sous-ensemble du *Stylized Nature MegaKit [Standard]* (Quaternius, CC0), produit par `tools/prep_nature_kit.py` (textures 512 px, normales retirées). Import Godot : mipmaps + compression VRAM sur les textures.
- `Adv3DKit` : charge un glTF, en extrait le maillage et remplace ses matériaux par un `ShaderMaterial` maison (texture de base, découpe alpha des feuilles, vent, `TOON_LIGHT`). `variants("CommonTree", 5)` → liste de maillages ; `Adv3DWorld._multi_kit()` répartit les instances entre variantes (échelle `k`).
- Remplacés : feuillus (CommonTree 1-5), pins hors Montagne (Pine 1-5), rochers (Rock_Medium), buissons (Bush_Common, rouge → vert par `swap_rg`), fleurs, champignons, galets, 1 touffe d'herbe sur 3 en Forêt. Gardés : bouleaux, palmiers, cactus, pins enneigés, décor des Nations.
- Si `assets/nature/` est absent (`Adv3DKit.available()`), on retombe sur les maillages codés (V61-V86).
- Coût : ~240 000 à 340 000 primitives par image sur les captures (ombres comprises) ; la qualité « Économie » coupe les ombres temps réel.
- Bestiary (Imp, Puglin) : reçu mais non intégré (monstres ~9 Mo pièce, licence QAL : pas de redistribution comme assets).


## V88 — Décors de Nation avec le kit (TEST)

- `Adv3DKit.override_for(kind)` : décors de Nation rendus par un modèle du kit (`dead_tree` → DeadTree teinté gris-vert, `charred_tree` → DeadTree charbon, `tide_rock` → Rock_Medium). Les autres clés gardent leurs maillages `Adv3DNationMeshes` (lueurs).
- `Adv3DKit.arena(model)` : modèles de la « Mini Arena » de Kenney (`assets/kenney_arena/`, CC0 : colonnes pour les piliers, statue/bannière/mur disponibles). Palette `colormap.png`.
- Teintes par biome : rochers (Désert chaud, Montagne froid), piliers (sable), dalles de chemin (`RockPath_*`, 28 % des cases de sentier).
- Les packs reçus qui restent à exploiter : Mini Arena `statue`, `wall`, `bricks`, `banner` (ruines, entrées de donjon) ; Bestiary (Imp, Puglin) pour des monstres animés.


## V89 — Nations sans kit : peinture, cartes, formes organiques (TEST)

- `Adv3DNationMeshes.glow_material()` utilise désormais le shader peint/toon (`Adv3DMeshes.solid_material`) avec un paramètre `glow` : les sommets d'alpha 0 restent lumineux, mais les décors reçoivent peinture triplanaire, éclairage cartoon et ombres du soleil.
- Rochers/socles (cristaux, marée, nuages, lave, Ombres) en normales lissées (9–10 segments) ; pointes et cristaux restent à facettes.
- `palm()` : cartes de feuilles le long des frondes ; `pine()` : touffes d'aiguilles (cartes) sur chaque étage, blanches pour la version enneigée.
- Constat : l'Atelier des Rouages monte à ~550 k primitives (existant avant V89) — à alléger si le téléphone peine.


## V90 — Personnage plus propre (TEST)

- `Adv3DHeroModel.detail_material()` : yeux et détails du visage (`h_face` : sourcils, joues, nez, bouche) rendus sans coque de contour ; contour du corps 0,011 → 0,0065 ; `paint_amt` du personnage 0,10.
- Cheveux : mèches par `Adv3DNationMeshes._spike` (11 + 3 de frange) sur la calotte ; cape : drapé en blob aplati ; pantalon éclairci.
- Outil : `tests/shot_hero_close.gd <dossier> [classe]` (face, trois-quarts, dos, tête).
