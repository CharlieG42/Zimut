# Mode Aventure — document unique

> Référence de travail du mode Aventure : design arbitré, état d'avancement
> (fait / à faire) et pistes d'amélioration. À mettre à jour à chaque évolution
> du mode. Même format que `CONQUETE.md`.

## 1. La promesse

« **Explorez le monde de Zimut, découvrez ses secrets, et revenez plus fort.** »

L'Aventure est la **couche exploration** posée sur le même socle que le mode
Tactique : chaque lieu remarquable (POI) sert la progression du roster, et la
carte d'Aventure est **le même monde que la carte de Conquête, vu au sol**.

| Mode | Ce que le joueur vit |
|---|---|
| Combats Tactiques | Enchaîner des combats équilibrés, progresser son roster (arène) |
| **Aventure** | **Explorer, découvrir, résoudre** (aventure) |
| Conquête | Décider, développer, dominer (stratégie) |

## 2. La boucle de jeu cœur

```
CARTE DE ZONE  →  EXPLORER (brouillard)  →  POI  →  DÉFI / TROUVAILLE
      ↑                                                        |
      |                                                        |
ZONE SUIVANTE  ←  SORTIE DÉCOUVERTE  ←  RÉCOMPENSES PARTAGÉES ←─┘
```

1. **Carte de zone** : grille isométrique, brouillard de guerre persistant.
2. **Exploration** : déplacement case par case, le brouillard se lève dans un
   rayon de 2 cases autour du héros.
3. **POI** : combat (moteur tactique), coffre (loot commun), énigme (saisie
   libre), camp (repos), belvédère (révèle des villes), sortie (zone suivante).
4. **Récompenses** : XP, loots et ressources dans la sauvegarde commune aux
   trois modes — jamais de duplication d'état.
5. **Sortie** : la zone suivante du monde se débloque.

## 3. Le monde — FAIT

**Quatre zones** rattachées aux biomes existants (catalogue officiel
`ProgressionManager.ADVENTURE_ZONES`, miroir des biomes de la Conquête) :

| Zone | Biome | Débloque | Villes révélées (Conquête) |
|---|---|---|---|
| `foret_sylve` | Forêt | — (départ) | Clairière d'Aube, Village des Brumes |
| `foret_ronces` | Forêt | Sentiers de la Sylve | Abbaye des Ronces, Ruines du Lierre |
| `montagne_pics` | Montagne | Sentiers de la Sylve | Hameau du Pin, Col du Givre |
| `desert_dunes` | Désert | Pics du Givre | Oasis Perdue, Caravansérail Rouge |

### POI (catalogue `ADVENTURE_POIS`)

| Type | Effet | Réutilisable |
|---|---|---|
| `combat` | Combat tactique au niveau du POI, biome de la zone | non |
| `chest` | Loot d'inventaire + XP d'exploration | non |
| `puzzle` | Énigme à saisie libre (`ADVENTURE_PUZZLES`), +120 XP | non |
| `camp` | Repos : +30 XP d'exploration | oui |
| `reveal` | Révèle des villes de Conquête (belvédère) | non |
| `exit` | Débloque la zone suivante | non |

## 4. Architecture — FAIT

```
scripts/
  AdventureTerrain.gd   # terrain déterministe : obstacles, sentiers, plus court chemin
  AdventureManager.gd   # logique pure : état, brouillard, récompenses, événements, ponts
  AdventureMapUI.gd     # rendu uniquement (île isométrique style combat, panneau, dialogs)
  ProgressionManager.gd # catalogue officiel + persistance + règles campagne
assets/adventure/       # sprites organisés, remplaçables sans toucher au code
  tiles/   forest_grass.svg, forest_water.svg, mountain_stone.svg,
           mountain_snow.svg, desert_sand.svg, desert_rock.svg, fog.svg
  poi/     combat.svg, chest.svg, puzzle.svg, camp.svg, reveal.svg, exit.svg
  hero/    hero.svg
```

### Sauvegarde (commune aux trois modes)

```json
"adventure": {
  "zone": "foret_sylve",
  "hero_pos": [x, y],
  "moves": 12,
  "discovered": ["zone,x,y", ...],
  "completed": ["zone,x,y", ...],
  "pending_challenge": "zone,x,y" | "",
  "pending_level": 10,              // niveau du défi en cours
  "zones_unlocked": ["foret_sylve", ...],
  "revealed_cities": ["clairiere", ...]
}
```

### Refonte V7 (carte, énigmes, événements)

- **Carte** : même direction artistique que les arènes Tactique — île
  isométrique flottante (tuiles `BattleScenery.tile_tex`, falaises, ciel et
  `BackdropFx` du biome), décors de `BattleScenery.draw_prop`, sentiers
  dessinés entre le départ et chaque lieu, brouillard en nuages.
- **Terrain** (`AdventureTerrain`) : généré de façon déterministe à partir du
  catalogue (même zone = même terrain). ~16 % d'obstacles (arbres, pins,
  cactus…), jamais sur un lieu, un sentier ou le départ ; chaque lieu reste
  accessible (vérifié par les tests).
- **Déplacement** : appui sur une case révélée → le héros (sprite de sa classe)
  suit le plus court chemin case par case ; aperçu du trajet au survol. Le
  trajet s'arrête sur un lieu ; un camp ennemi non vaincu barre la route.
- **Énigmes — 3 types** (`ADVENTURE_PUZZLES[...]["type"]`) :
  `riddle` (3 réponses proposées + saisie libre tolérante aux accents/articles),
  `runes` (mémoriser et rejouer une suite de runes colorées),
  `lights` (dalles « lights out » à allumer toutes).
- **Événements de route** (`AdventureManager.roll_event`, 16 %, pause de 3 pas) :
  cueillette, cache, conseil d'un sage, embuscade (combattre ou contourner).
- **Panneau latéral** : explorateur (classe changeable parmi l'équipe), zone
  (lieux explorés / carte révélée), lieu courant + action, journal (6 lignes),
  liste des zones.
- **Combats de campagne isolés** : `ProgressionManager.CAMPAIGN_FIGHTS_ISOLATED`
  (true) — une victoire en Aventure/Conquête n'avance plus la campagne
  Tactique ni les compteurs de rejouabilité ; XP, objets, or et ressources
  restent partagés. Mettre `false` pour revenir à l'ancien comportement.

### Monde en grille façon Dofus Touch (V8)

```
              x=0             x=1              x=2               x=3
  y=0                                     Pics du Givre 17   Crêtes du Givre 19
  y=1   Ronces 13  ←→  Sylve 10 (départ) ←→ Lisière du Col 14
  y=2                                     Piémont Ocre 19 ←→ Dunes Perdues 21
  y=3                                     Portes du Donjon 24
```

- Chaque zone est une **carte** posée sur la grille du monde (`grid` dans
  `ADVENTURE_ZONES`). La grille suit la géographie de la Conquête : forêts à
  l'ouest, montagnes au nord, désert à l'est, Donjon au sud.
- **Portes** : au milieu de chaque bord qui touche une carte voisine
  (`AdventureTerrain.gates_of`). Panonceau « ➜ Carte · niv N », chevrons animés,
  sentier qui file hors de l'île. On marche jusqu'à la porte : le héros sort par
  le bord, voile de nuages, il entre sur la carte voisine par la porte opposée.
- **Routes gardées** (`adventure_gate_open`) : une carte déjà visitée ou de
  niveau inférieur/égal est toujours ouverte ; vers une carte plus difficile, il
  faut remporter le combat clé de la carte (`key_poi`, ex. Camp gobelin).
- **Lisières** (`blend`) : un biome voisin déborde sur un côté de la carte
  (tuiles, obstacles et décors du biome voisin) — Lisière du Col (forêt →
  montagne au nord), Piémont Ocre (montagne → désert à l'est).
- **Mini-carte du monde** dans le panneau : cartes visitées (couleur du biome,
  niveau), voisines inexplorées en « ? », héros sur la carte courante. Toucher
  une carte visitée = voyage rapide.
- Les anciens lieux « sortie » (9,3) sont remplacés par les portes ; les
  anciennes sauvegardes gardent leurs zones débloquées.
- **Réutilisation** : tuiles, décors, fonds et sprites viennent du mode
  Tactique (BattleScenery, BackdropFx, Portraits) ; seules les icônes de lieux
  restent dans `assets/adventure/poi/`. Les SVG `assets/adventure/tiles/` et
  `hero/` ne sont plus utilisés (supprimables).
- **Conquête** : chaque ville (hors capitale) est désormais révélée par un
  belvédère d'au moins une carte (avant, une dizaine ne l'étaient par aucune et
  devenaient inattaquables dès qu'on avait joué l'Aventure).
- Ajouter une carte = une entrée `ADVENTURE_ZONES` (grid, biome, key_poi,
  reveals) + ses lieux dans `ADVENTURE_POIS` (+ énigmes) : le terrain est généré.

## 5. Ponts inter-modes — FAIT

- **Aventure → Conquête** : franchir un belvédère (`reveal`) marque les villes
  de la zone comme `revealed_cities`. Côté Conquête, `conquest_city_attackable`
  n'autorise alors l'assaut que sur les villes révélées (badge « ? » sur la
  carte). **Rétrocompatible** : si aucune ville n'a été révélée (l'Aventure
  n'a pas été jouée), toutes les villes reliées restent attaquables.
- **Conquête → Aventure** : `adventure_unlock_zone` permet de débloquer une
  zone d'exploration depuis la Conquête (extension future : récompenses de
  siège).
- **Aventure → Tactique** : les combats de POI utilisent le moteur standard
  (`GameManager`), le titre de sélection d'équipe affiche le nom du défi,
  et la fenêtre de résultat ramène à la carte d'Aventure.

## 6. Équilibrage — arbitré

- XP d'exploration : 60 (coffre), 30 (camp), 120 (énigme) — volontairement
  sous le rythme des combats pour ne pas court-circuiter la Conquête.
- Le niveau des combats de POI est fixé par le catalogue (10 à 21), pas par
  le niveau de l'équipe : l'ordre des zones donne une courbe de difficulté.
- Les loots des coffres utilisent `_roll_loots` au niveau du POI (même
  économie d'items que le reste du jeu).

## 7. À faire (phases 3-4 de la roadmap)

- [x] Événements aléatoires en déplacement (rencontres, découvertes).
- [ ] PNJ et dialogues dans les zones ; faim/soif (héritées du proto ZOE)
      à réévaluer.
- [ ] Boss de zone par « Pierre de l'Élément » (objectif narratif).
- [ ] Récompenses exclusives (panoplies d'exploration, sorts uniques).
- [x] Mini-carte de survol du monde (cartes visitées, voisines en « ? »).
- [x] Animations de déplacement du héros (tween case par case).
- [ ] Sons spécifiques POI (Sfx) et variantes de musique par zone.

## 8. Assets

Tous les sprites vivent dans `assets/adventure/` (SVG, style isométrique
Waven approximatif mais organisé) : remplacer les fichiers suffit, le code
charge les chemins constants en tête de `AdventureMapUI.gd`
(`ZONE_TILES`, `POI_ICONS`, `HERO_SPRITE`, `FOG_TILE`).

### Planche Sylve « v2 enrichie » (V114)

La planche `foret_sylve_v2` peut porter deux clés de décors superposés, lues au
rendu dans la branche non-iso de `_rebuild_board` (`AdventureMapUI.gd`) :

- `"decor"` : petits décors non bloquants sur cases jouables (`grass`, `flowers`,
  `mushrooms`) — sprites `assets/sprites/decor/sylve/` via `SpriteDecor`, même hors
  réglage « Iso » (flag `use_sprites` sur `DecorNode`) ;
- `"over"` : grands arbres (`tree`, `big_tree`, `pine`) sur cases **non jouables**
  situées juste au sud d'un chemin : `z_index = _depth(case) + 4`, donc au-dessus du
  héros (`_depth + 2`) quand il passe au nord — occlusion de premier plan, l'anneau
  et l'ombre du héros restent visibles au sol.

Le masque, le départ, les POI et les déplacements ne changent jamais : les décors
sont générés par `tools/gen_sylve_v2_decor.py` (type de sol lu dans l'illustration,
distances de sécurité aux lieux) et contrôlés par `tests/test_sylve_v2_decor.gd`.
Les surfaces **peintes** (bâtiments, toits, murs : cases plates, écart-type des
pixels < 10) sont exclues : aucun arbre ni décor ne se pose sur un bâtiment.
Prévisualisation de composition : `tools/preview_sylve_v2.py` (PIL, hors moteur).

### Déplacement continu (V114)

`_walk` n'arrête plus le héros à chaque case : une seule tween parcourt une polyligne
à coins arrondis (`_smooth_path`), vitesse constante au milieu avec
accélération/décélération globales (`TRANS_SINE` / `EASE_IN_OUT` sur tout le trajet).
La logique par case (monstres bloquants, trouvailles, lieux, événements, portes) est
inchangée et se déclenche à chaque frontière de case (`_walk_until`) ; en cas de
blocage, `_walk_stop_s` freine le héros sur la dernière case atteinte. L'échelle de
profondeur du héros est interpolée en continu le long du trajet.
Test : `tests/test_walk_continu.gd`.

### Planche iso « test » de la Sylve enrichie (V114)

- `IsoGround` : eau animée autour de l'île flottante (clapot), ombre portée, arrière-plan
  (soleil, collines dans la brume, nuages qui dérivent), **rivage** (cases basses en bord
  d'île teintées sable humide) et **escaliers de bois** dessinés sur les faces où le
  sentier gravit une marche ;
- teinte d'altitude des décors (`_add_decor(..., hgt)`) : les basses terres sont ombrées,
  les hauteurs restent claires ;
- nouveaux aménagements dessinés en code dans `BuildingNode` : `puits`, `feu` (flamme
  animée), `etal` — placés par `tools/gen_sylve_iso_buildings.py` (empreintes en
  obstacles `building`, hors sentier/POI, sur des replats) ;
- prévisualisation : `tools/preview_sylve_iso.py` (`Examples/sylve_iso_preview/`) ;
- captures in-engine des deux variantes (écran virtuel requis) :
  `xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_sylve_variants.gd -- <dossier>` ;
- test : `tests/test_sylve_iso_v114.gd`.

> Perf : le sol iso (`IsoGround`) est **statique** — l'animation (clapot, nuages) est
> portée par une couche légère dédiée (`IsoFx`, ~30 ips, absente en qualité
> « Économie » via `GfxQuality.low()`), pour ne jamais redessiner tout le plateau
> à chaque frame.

### Carte « Diorama » de la Sylve (V115)

Quatrième style de carte 2D (Réglages › Graphismes › Cartes 2D › « Diorama (Sylve) ») :
une **scène 3D pré-rendue** (Kenney + Quaternius, CC0) posée sur un plateau iso
`foret_sylve_diorama` (`"iso": true, "diorama": true`). V116 : monde de 96×96 unités = 144×144 cases
(village au centre, plaines sauvages, bois, lac, ruines, pierres levées, hameau).

- l'image (16 tuiles WebP 2560×1440, chargées **à la demande** autour de la vue :
  `_diorama_stream`, chargement en fil) est calée sur `BoardArt.iso_pos` via `image_scale` /
  `image_offset` : chaque case au sol tombe sur son pixel du rendu (hauteurs par case, `unit` 16) ;
- **occultants** : bâtiments, arbres, étals, lanternes… sont découpés du rendu (passe
  d'identifiants) et rangés en atlas (`occluders`) ; posés dans `_entities` avec
  `z_index = _depth(case) + 3`, ils passent devant le héros quand il marche derrière ; une page
  d'atlas par tuile, chargée avec elle ;
- pas d'`IsoGround` / `IsoFx` / `BoardLight` : lumière, brume et étalonnage sont cuits dans le rendu ;
  échelle d'affichage `DIORAMA_SCALE` (≈ 1 pixel du rendu par pixel écran) ;
- seuls la Sylve change : les Cimes gardent leur planche v2 ;
- interface de la carte : z 1320+ (au-dessus des nœuds de profondeur, ~1150 sur 144×144) ;
  « Centrer » au-dessus du joystick, zoom au-dessus de l'aide (`tests/test_boutons_carte.gd`) ;
- chaîne de production : `tools/diorama/` (README) ; test `tests/test_sylve_diorama.gd`,
  captures `tests/shot_sylve_diorama.gd`.

### Diorama du Brasier et bâtiments de donjon (V118)

- `BoardArt.DIORAMA_BOARDS` : en réglage « Diorama », la Sylve **et** le Brasier (`brasier_cendres_diorama`)
  utilisent une scène pré-rendue ; les autres Nations gardent leur carte.
- Terres de Cendre : bourg de forgerons, lave (masque `lava.npy` infranchissable, émission non ombrée au
  rendu), volcan (`forbid.npy`), 5 donjons `Brasier#1..#4` + `Brasier`, portail vers les Brumes
  (`requires: "Brasier"`) et **sentier de retour** vers la Sylve (`kind: "exit"`, `back: true`, `to`) :
  toujours ouvert, il ne propose que la Nation précédente et ne débloque rien
  (`adventure_complete_poi` ignore les sorties `back`). Règle : N-1 toujours accessible, N+1 après le Gardien de N.
- Bâtiments de donjon (`tools/diorama/dungeons3d.py`) : un groupe d'objets par donjon = **un seul**
  occultant (`kind: "dungeon"`) ; le lieu est posé devant l'entrée (`DG.entrance`).
- Fluidité : petits décors non découpés (moins de nœuds) ; `PoiNode`, `FindNode`, `MobNode`,
  `GateNode`, `BuildingNode` ne se redessinent que s'ils sont à l'écran (`_on_screen`).
- Chaîne de production : `tools/diorama/` (README) ; test `tests/test_brasier_diorama.gd`.

### Fluidité, île flottante peinte et états des donjons (V119)

- Sauvegarde différée : `AdventureManager.persist_soon()` (1,2 s après le dernier pas, `flush()` à la
  sortie / mise en pause) au lieu d'une écriture complète du fichier à chaque case.
- Diorama : au plus **une** texture envoyée au GPU par image (`_dio_pending`), le voile de fondu et le
  toast sont masqués hors usage, la planche (`AdventureBoard`) ne se redessine que si sa signature change,
  `SceneryAmbient` ignore les particules hors écran.
- Réglages › Graphismes › « Compteur d'images » : affiche i/s, temps moyen, pire image et nombre de
  saccades (> 25 ms) sur la carte, pour mesurer sur téléphone.
- Taille de carte : le coût par image vient surtout des couches d'interface et des envois de textures,
  pas du nombre de cases ; réduire la carte allégerait surtout la mémoire et le chargement.
- Rendu (`tools/diorama/scene_bg.py`, phase 2 de `post96.py`) : l'île flotte dans un décor peint —
  ciel en dégradé, montagnes dans la brume, bancs de nuages, **falaise rocheuse** sous la dalle, cascades
  (eau pour la Sylve, **coulées de lave** détectées au bord pour le Brasier), mer de nuages ; étalonnage
  « peint » (filtre bilatéral, verts de prairie plus profonds) avec une marge prise chez les tuiles voisines.
- Netteté : lissage « peint » allégé + masque flou à deux rayons (`scene_bg.paint`) ; à l'écran, le décor
  et les occultants passent en filtrage **linéaire sans mipmaps** tant qu'un pixel du rendu fait au moins
  ~0,6 pixel écran (`_dio_filter_sync`, hystérésis 0,55 / 0,62), mipmaps au-delà (pas de scintillement).
- Donjons (`PoiNode`) : **ouvert** = colonne de lumière et halo dorés pulsés ; **verrouillé** = gris,
  anneau rouge en pointillés, cadenas vectoriel (plus d'émoji) ; **terminé** = vert. Une pastille
  OUVERT / VERROUILLÉ / TERMINÉ reste affichée sous le nom de chaque donjon.

### Cause des saccades en marchant (V123)

Le compteur à 3 lignes (V121) a montré que le temps de **scène** (jusqu'à 170 ms) et non le rendu (≤ 35 ms)
causait les saccades. Un profil par catégories de nœuds a désigné `AdventureBoard._draw` : l'aperçu du
trajet appelle `cell_center` → `BoardArt.iso_pos` → `iso_origin` → `iso_max_height`, qui parcourait les
20 000 hauteurs, et `file_stem` testait des fichiers, **à chaque appel**. `BoardArt` mémorise désormais le
choix de planche (`_stem_cache`), la hauteur maximale et l'origine (`_maxh_cache`, `_origin_cache`, clé = planche + `rev`).
Règle : rien qui parcourt toute la carte ou le disque dans une fonction appelée par case ou par image.

### Carte Diorama vivante (V127)

Premier lot de `Amelioration_v127.md`. Les tuiles pré-rendues ne changent pas : `tools/diorama/fx_masks.py`
produit un masque au 1/8 (`assets/boards/<nation>/fx.png`, 1280 × 720 : R = eau visible, V = lave et lumières,
B = terre ferme) à partir du rendu fini, de la passe d'identifiants (objets hauts devant l'eau), du relief et
d'`objects.json`, et inscrit `image_fx` (chemin, facteur, `ground_rect`) dans le JSON de la planche
(`bake96.py` conserve cette clé). À lancer après `bake96.py`.

`scripts/DioramaFx.gd` pose deux calques : **sol** (dans le porte-tuiles, sous les personnages, limité à
`ground_rect`) pour l'eau et la lave, **ciel** (z 1200, au-dessus des personnages, sous l'interface) pour les
ombres de nuages et les rayons. Un bruit 128 px répétable est calculé une fois. Réglages par Nation dans
`DioramaFx.MOODS`. Rien n'est posé en qualité « Économie ». Le vent dans le feuillage n'est pas fait : déformer
les tuiles coûterait une passe plein écran et ferait apparaître un double des arbres découpés.

### Reprise des donjons (V125)

La dernière salle terminée est mémorisée **par donjon** (`save["adventure"]["dungeon_rooms"] = {donjon: prochaine salle}`).
Défaite, combat abandonné ou arrêt du jeu ne font plus rien perdre (`Dungeons.DEFEAT_RESETS = false`, plus de numéro de
session). La porte d'un donjon commencé propose « REPRENDRE · SALLE n » et « ↺ RECOMMENCER » (`Dungeons.restart`, qui ne
touche que ce donjon). L'ancien format `adventure["dungeon"]` reste lu. Terminer la salle du Gardien efface la progression.

### Étalonnage des vues 3D (V128)

Lot 4 du plan d'amélioration graphique. `scripts/adventure3d/Adv3DLook.gd`, appelé par le monde ouvert et la
vue 3D par cases après `Adv3DMeshes.setup_sun` :

- **brume de distance** (`FOG_MODE_DEPTH`, début / fin / opacité par Nation dans `Adv3DLook.NATION`) à la place
  du brouillard exponentiel qui délavait toute l'image ; le ciel n'est plus voilé ;
- **lumière** : soleil 1,12, ambiance 0,44 plus froide, carte de reflets désactivée ;
- **ciel** : panorama de nuages 512 × 256 calculé une fois (`cloud_cover`, clé `sky_cover` du ciel procédural),
  sans shader de ciel animé ;
- **lointain** : `make_backdrop` = deux chaînes de crêtes sans éclairage qui suivent la caméra (rayon 138 et
  152 m, sous le plan lointain de 160 m) ;
- **sol** : uniformes `macro_col` / `macro_amt` du shader commun = plaques de teinte basse fréquence (mousse
  sur sol herbeux, neutre ailleurs ; clé `macro` possible dans la palette).

Réglé avec le rendu « mobile » (Vulkan), celui du téléphone : le rendu « compatibilité » des captures
habituelles donne des couleurs très différentes. Capture : `xvfb-run -a godot --rendering-method mobile
--path . -s tests/shot_openworld.gd -- <dossier> foret_sylve`. Test : `tests/test_adv3d_look.gd`.
### Carte Diorama du Marais des Brumes (V136)

Troisième Nation en Diorama : `plan_brumes.py` + `layout_brumes.py` (ambiance `DIORAMA_MOOD=brumes`),
`BoardArt.DIORAMA_BOARDS["brumes_marais"]`. Cinq mares (`LAKES`, pris en charge par `terrain96.py` et
`bake96.py`), feuillus sombres et arbres morts, roseaux, champignons, six cabanes. Donjons : `crypte`,
`ruine`, `pilotis`, `souche` aux quatre coins et `tour_brume` au centre (types ajoutés à `dungeons3d.py`),
vue dégagée jusqu'à 12,8 unités devant chaque entrée. Gardiens `Brumes#1` à `Brumes#4` puis `Brumes` (niveau 31).
Sorties : « Sentier des Cendres » (retour) et « Portail vers les Cimes ». Test : `tests/test_brumes_diorama.gd`.
Les Nations suivantes (Vents…) gardent leur carte.

### Carte Diorama des Hauts Pics du Givre (V141)

Quatrième Nation en Diorama : `plan_cimes.py` + `layout_cimes.py` (ambiance `DIORAMA_MOOD=cimes`, relief
`DIORAMA_AMP=3.0`), `BoardArt.DIORAMA_BOARDS["montagne_pics"]`. Sol enneigé, lac gelé (infranchissable),
pinèdes sombres, blocs de roche, cristaux de glace lumineux, hameau aux toits blancs. Donjons : `sanctuaire`
(Forge Givrée), `grotte` (Caverne du Givre), `tour_brume` (Tour des Runes Violettes), `mine` (Mine d'Or Gelée)
aux quatre coins et `forteresse` au centre, tous reteintés « givre » par `layout_cimes.py`. Gardiens
`Montagne#1` à `Montagne#4` puis `Montagne` (niveau 45), comme sur la planche illustrée. Sorties : « Sentier
des Brumes » (retour) et « Portail vers les Vents ». Ambiance en jeu : `DioramaFx.MOODS["Montagne"]`, neige
de `SceneryAmbient`. Hors réglage « Diorama », les Cimes gardent leur planche illustrée
(`montagne_pics_v2`). Test : `tests/test_cimes_diorama.gd`.

### Brumes : l'aspect brumeux, en Diorama et en 3D (V137)

Diorama : `post96.py` ambiance `brumes` désaturée (verts gris) avec `fog_k` 1,7 ; murs et pierres des donjons
assombris, cabane sur pilotis en bois détrempé, ruines complétées (rochers, arbre mort, cristal). En jeu,
`DioramaFx` ajoute des nappes de brume qui dérivent sur le sol (`mist_col` / `mist_amt`, plus denses sur l'eau),
une mer de nuages plus marquée, et `SceneryAmbient` change une part des particules en feux follets bleu-vert.

Monde 3D : `Adv3DLook.NATION["Brumes"]` (brume de distance dès 9 m, ambiance relevée) et
`make_ground_mist` = deux plans de brume au ras du sol (shader à bruit qui dérive, effacé près de la caméra,
au loin et en vue de dessus), absents en « Économie ».

### Marche en lignes droites sur la carte 2D (V139)

La grille reste à 4 voisins (règles, pas, rencontres inchangés). Deux changements :

- `AdventureTerrain.straighten_path` (appelé par `AdventureManager.path_to`) remplace chaque tronçon du plus
  court chemin par la ligne droite de grille (`grid_line`, escalier régulier) entre deux de ses points quand
  toutes ses cases sont libres : même nombre de pas, mais le trajet colle à la ligne de visée.
- `AdventureMapUI.straight_points` donne un point d'écran par case, aligné sur le segment de son tronçon
  (écart ≤ 0,75 case) : le héros glisse en ligne droite, garde la direction du tronçon (`locomotion`), et
  l'aperçu du trajet suit la même ligne. Les déclenchements restent par case.

Réglage `GameSettings.show_grid` (« Grille des cases ») : losanges des cases praticables dans un rayon de
14 cases autour du héros, dessinés par `AdventureBoard._draw_iso_overlay`. Test : `tests/test_marche_droite.gd`.

### Éclairage 3D : teinte d'ombre limitée au soleil (V138)

Défaut trouvé dans `Adv3DMeshes.TOON_LIGHT` : `DIFFUSE_LIGHT *= shade` s'exécutait pour CHAQUE lumière. Près
d'une lumière ponctuelle (feu de camp, lanterne, cristal) en bord de portée, toute la lumière déjà accumulée
était multipliée par la teinte d'ombre (0,62 / 0,66 / 0,95) : sol bleu-violet aux Cimes, sombre ailleurs.
C'est ce qui rendait le Brasier « presque noir » sur téléphone. La teinte et le liseré ne s'appliquent plus
qu'à la lumière directionnelle (`LIGHT_IS_DIRECTIONAL`). Réglages revus ensuite : soleil par défaut 1,02,
Brumes (exposition 0,90, brume 12 → 78 m, nappes 0,24), herbe givrée aux Cimes (`frost`), étiquettes 3D en
priorité de rendu 4 (devant les nappes de brume).

### Quitter la carte 2D proprement, compteur en 3D (V135)

Signalé sur S23+ : après un déplacement sur la carte 2D, « Mes Parties » figeait le jeu. Non reproduit sur
ma machine ; seul défaut démontré : quitter pendant une marche laissait la coroutine de marche tourner sur
une scène retirée de l'arbre (erreurs de script). `AdventureMapUI._leave_scene` remplace les changements de
scène directs (Mes Parties, combats) : drapeau `_leaving`, tween de marche tué, plus aucune tuile demandée, puis
attente (3 s au plus) de la fin des chargements de tuiles en arrière-plan (`_drain_tile_loads`) avant
`change_scene_to_file`. Test : `tests/test_quitter_carte.gd`.

`scripts/PerfCounter.gd` : compteur autonome (i/s, pire image, saccades, scène / rendu max, dessins, objets,
triangles, vram, nœuds), ajouté à l'interface des deux vues 3D quand `GameSettings.show_perf` est actif.

### Nations sombres lisibles en 3D (V134)

Constat sur vidéo du S23+ : en 3D, le sol du Brasier était presque noir. `Adv3DLook` a quatre réglages de plus
par Nation (`amb` énergie d'ambiance, `cool` part de bleu, `expo` exposition, `sun`) : Brasier 0,72 / 0,10 /
1,14 / 1,25, Ombres et Donjon 0,62 / 0,20 / 1,08. Le sol du Brasier est éclairci dans `Adv3DWorld.PALETTES`
et les plaques de teinte (`macro`) passent de ×0,80 à ×0,92 hors sols herbeux. Les étiquettes 3D
(`Adv3DActors._label`) s'effacent à 26 m au lieu de 34.

### Herbe rase autour du joueur, vues 3D (V132)

Lot 5 du plan d'amélioration graphique (première partie). `Adv3DWorld._build_decor` ajoute un calque
`HerbesProches` : 14 à 32 petites touffes par case hors sentier (tirage séparé, donc le reste du décor ne
bouge pas), découpées en blocs de 15 m comme l'herbe haute mais visibles jusqu'à `NEAR_GRASS_RANGE` (26 m)
seulement, sans ombre portée. Rien en qualité « Économie » ni dans les Nations presque sans herbe
(`grass` < 0,3). Environ 28 000 touffes en Sylve, dont quelques milliers dessinées à la fois.
Test : `tests/test_adv3d_herbe_proche.gd`. Eau, lave et arbres ne sont pas retouchés dans ce lot.

### Portail toujours visible (V129)

Sur la carte Diorama, le médaillon du portail passait derrière un arbre découpé du décor (occultant, profondeur
de case + 3) : on ne voyait que l'étiquette. Le nœud du portail est désormais à `PORTAL_Z` (1190, au-dessus de
tous les occultants, sous l'interface), agrandi ×1,3, et dessine un ovale de portail (`PoiNode._draw_portal`) :
cyan et animé quand il est ouvert, gris quand il est scellé. `portal_cell()` donne sa case ; le panneau des
objectifs a un bouton `PortalShow` qui centre la carte dessus.
### Personnages intégrés au décor du Diorama (V130)

Lot 2 du plan d'amélioration graphique. `tools/diorama/light_map.py` réduit l'image finie à 320 × 180 et
l'adoucit (`assets/boards/lumieres/<dossier des tuiles>.png`, import sans perte, trouvée par convention :
`BoardArt.diorama_light`). `AdventureMapUI.light_tint(case)` y lit la couleur ambiante et en tire une teinte
bornée (teinte ×0,28, luminosité 0,78 à 1,05). Le héros la rejoint en douceur (`HeroView.light_target`), les
monstres la reçoivent dans `_refresh_world` (alpha de fondu conservé). Héros et monstres passent en filtrage
linéaire sur le Diorama. Ombres de contact et liseré existaient déjà (V119) ; la poussière de pas n'est pas faite.

### Portail dans le décor et mer de nuages (V131)

Lot 3 du plan d'amélioration graphique. `dungeons3d.py` a un type `portail` (arche de pierre, obélisques, cristaux
lumineux) posé par `wild96.py` / `layout_brasier.py` pour chaque lieu de `PLACES` dont le nom commence par
« Portail », 0,6 unité derrière la case du lieu, avec la vue dégagée devant comme pour les donjons. Le
tourbillon (ouvert / scellé) reste dessiné par le jeu dans l'ouverture ; l'ancienne arche dessinée par-dessus
est retirée sur le Diorama. Les deux Nations sont régénérées (rendu, `bake96.py`, `fx_masks.py`,
`light_map.py`). Le calque « ciel » de `DioramaFx` dessine aussi une mer de nuages hors de l'île
(`sea_col` / `sea_amt` par Nation). Les médaillons de lieux, déjà travaillés (V114 / V119), ne sont pas refaits.

### Position des donjons dans une Nation (V122)

Règle pour **toutes** les Nations (Sylve, Brasier et les suivantes) : un donjon dans chacun des quatre
coins du monde (pointes du losange à l'écran : haut, droite, bas, gauche) et le **donjon de la Nation au
centre**, sur la place du bourg. Le bâtiment de donjon regarde la caméra (+x +z) : rien de haut ne doit
se dresser devant. Les boucles de donjons de `wild96.py` / `layout_brasier.py` posent donc trois cercles
d'`occupied` (à 4,8 / 7,4 / 10 unités, rayon 3) en diagonale devant chaque entrée ; il faut aussi
dégager à la main les gros décors (bois, hameaux). Les routes des plans partent du pourtour du donjon central
(`ROADS` des plans) et un chemin mène à chaque coin. `tests/test_brasier_diorama.gd` vérifie le centre et
les quatre coins pour chaque Nation.

### Lumière, atmosphère et détails peints (V114)

- `BoardLight` (z=5, statique, un seul redraw) au-dessus de toute carte 2D : teinte
  globale chaude, **taches de lumière** au sol, **ombres de contact renforcées** sous
  les arbres de premier plan, **rayons de soleil** aux lisières (clé `over`), vignette
  radiale ; allégé en qualité « Économie » ;
- micro-VFX : **étincelles** autour des médaillons de POI (absentes en Économie),
  **flash** à la récolte d'une trouvaille (`FxFlash`) ; particules ambiantes
  (lucioles/pollen) déjà présentes via `SceneryAmbient` ;
- clé `"detail"` dans une planche : PNG transparent peint par-dessus l'illustration
  (détails de sol générés par IA + détourage par saturation, `tools/chroma_key_overlay.py`)
  — `Sylvestre_v2_detail.png` (Forêt) et `Cimes_detail.png` (Montagne) ;
- pipeline décors étendue à la **Cimes** (`montagne_pics_v2`, kinds Montagne) ;
- prévisualisations : `tools/preview_sylve_v2.py` (Sylve + Cimes).

### Re-peinture des planches (V114, style cartoon Ankama/Waven/Dofus)

`tools/repaint_planche.py <art_IA.jpg> <planche.png> <zone.json>` repeint une planche
sans toucher au gameplay : le **masque reste identique**, la silhouette de l'île est
imposée depuis le masque (mer profonde autour, floutée sur ~1 case), et l'eau peinte
par l'IA sur une case jouable est remplacée par de l'herbe texturée (pas de damier).
L'art est généré par l'outil IA de la session (prompt style Ankama : couleurs
saturées, cel-shading, contours foncés) ; les décors `decor`/`over` sont ensuite
recalculés sur la nouvelle peinture (`tools/gen_sylve_v2_decor.py`). Appliqué à
`Sylvestre_v2.png` ; à répliquer sur `Cimes.png` ensuite.

### Extension de la carte (monde plus vaste, défilement) — V114

`tools/extend_planche.py <zone.json> <art.jpg> <+cols> <+rows>` agrandit une planche
(ici Sylve 96×73 → **128×96**, soit 2048×1536 px, monde 2D 4096×3072 px → défilement
caméra actif) : l'ancienne zone garde ses coordonnées exactes (masque, POI, départ),
la nouvelle terre pousse par dilation chaînée dans la marge + **isthme** vers l'île,
3 nouveaux lieux sont placés dans l'extension (tous atteignables — test), l'art est
calé sur le masque (eau sur case jouable → herbe, hors île → mer). L'overlay `detail`
est régénéré à la nouvelle taille. Les décors `decor`/`over` sont recalculés.
Sylve : 96×73 → 128×96 → **160×128** (image 2560×2048, monde 5120×4096 px).

L'overlay `detail` de la Sylve est désormais généré **procéduralement** à partir des
vrais sprites de décor du jeu (`tools/gen_detail_overlay.py`) : touffes de 6-26 px
(< 2 cases), densité ~11 %, style identique aux décors posés — vérifié à l'échelle du
jeu (preview x2). L'overlay IA (détourage par saturation) reste utilisable pour les
autres planches via `tools/chroma_key_overlay.py`.

## Déplacement et lisibilité (V10)

- **Appui tactile** : un premier appui sur une case affiche le trajet et le nombre de pas ; un second appui sur la même case lance la marche. À la souris, un clic suffit (le survol montre déjà le trajet).
- **Brume** : toucher une case encore cachée amène le héros à la case connue la plus proche.
- **Joystick tactile** (bas gauche de la carte) : on pose le pouce et on glisse, le héros marche case par case tant qu'on tient (les directions « écran » haut/bas/gauche/droite alternent entre deux axes de grille en zigzag, et glissent le long d'un obstacle). **Flèches / ZQSD / WASD** : un pas à la fois (↖ = −x, ↗ = −y, ↘ = +x, ↙ = +y). Entrée / Espace / E déclenche l'action du lieu.
- Les longs trajets accélèrent (jusqu'à ×2).
- **Plaque d'infos** en haut à gauche (carte, biome, niveau, lieux) et **grand bouton d'action** en bas de la carte quand le héros est sur un lieu ou une frontière.
- Panneau latéral : l'action du lieu passe en premier, textes ≥ 17 px, boutons ≥ 56 px.
