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

## Déplacement et lisibilité (V10)

- **Appui tactile** : un premier appui sur une case affiche le trajet et le nombre de pas ; un second appui sur la même case lance la marche. À la souris, un clic suffit (le survol montre déjà le trajet).
- **Brume** : toucher une case encore cachée amène le héros à la case connue la plus proche.
- **Joystick tactile** (bas gauche de la carte) : on pose le pouce et on glisse, le héros marche case par case tant qu'on tient (les directions « écran » haut/bas/gauche/droite alternent entre deux axes de grille en zigzag, et glissent le long d'un obstacle). **Flèches / ZQSD / WASD** : un pas à la fois (↖ = −x, ↗ = −y, ↘ = +x, ↙ = +y). Entrée / Espace / E déclenche l'action du lieu.
- Les longs trajets accélèrent (jusqu'à ×2).
- **Plaque d'infos** en haut à gauche (carte, biome, niveau, lieux) et **grand bouton d'action** en bas de la carte quand le héros est sur un lieu ou une frontière.
- Panneau latéral : l'action du lieu passe en premier, textes ≥ 17 px, boutons ≥ 56 px.
