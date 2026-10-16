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
  AdventureManager.gd   # logique pure : état, brouillard, récompenses, ponts
  AdventureMapUI.gd     # rendu uniquement (carte isométrique, dialogs)
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

- [ ] Événements aléatoires en déplacement (rencontres, découvertes).
- [ ] PNJ et dialogues dans les zones ; faim/soif (héritées du proto ZOE)
      à réévaluer.
- [ ] Boss de zone par « Pierre de l'Élément » (objectif narratif).
- [ ] Récompenses exclusives (panoplies d'exploration, sorts uniques).
- [ ] Mini-carte de survol du monde (toutes zones, brouillard global).
- [ ] Animations de déplacement du héros (tween case par case).
- [ ] Sons spécifiques POI (Sfx) et variantes de musique par zone.

## 8. Assets

Tous les sprites vivent dans `assets/adventure/` (SVG, style isométrique
Waven approximatif mais organisé) : remplacer les fichiers suffit, le code
charge les chemins constants en tête de `AdventureMapUI.gd`
(`ZONE_TILES`, `POI_ICONS`, `HERO_SPRITE`, `FOG_TILE`).
