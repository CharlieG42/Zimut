# Inventaire des biomes et des sprites (tous modes : Tactique, Aventure, Conquête)

État au 17/10/2026. « Dans le jeu » = chargé par le code ; « Disponible » = fichier présent mais pas encore relié.

## 1. Biomes

| Biome | Sol (cases) | Décors | Palette / falaise | Musique | Ennemis (`ennemis.txt`) | Cartes d'Aventure |
|---|---|---|---|---|---|---|
| **Forêt** | 6 tuiles SVG | arbres ×3, rocher, souche, champignons, fougère | oui | forest_1, forest_2 | Gobelin, Loup, Squelette… | Sylve, Ronces, Lisière (mixte) |
| **Montagne** | 6 tuiles SVG | recyclés de la forêt (pas de décor propre) | oui | mountain_1, mountain_2 | variantes `_montagne` | Pics, Lisière (mixte) |
| **Désert** | 6 tuiles SVG | recyclés de la forêt (pas de décor propre) | oui | desert_1 | variantes `_desert` | Piémont Ocre, Dunes |
| **Donjon** | pierre (tuile générique) | portes / ruines | oui | — (musique générale) | Boss | Portes du Donjon |

**Biomes manquants (9 nations dessinées sur la planche, aucune n'a encore de sol ni de décor) :**
Sylvestre (≈ Forêt, à distinguer), Cimes, Sables (≈ Désert), Cristaux, Marées, Vents, Ombres, Brasier, Brumes.
Pour chacun il faudrait : 6 tuiles de sol, 3-5 décors, une palette de falaise, une ambiance sonore.
Priorité suggérée : **Sables** (Géomancien), **Marées**, **Cristaux**, **Brasier**.

Manques transversaux : décors propres Montagne et Désert, musique Donjon/Conquête-ville, tuiles de transition entre biomes
(aujourd'hui un simple mélange de cases).

## 2. Héros (9 classes) — `assets/sprites/players/<classe>.png`

| Classe | Nation | Sprite planche | Dans le jeu |
|---|---|---|---|
| Tank | Cimes | oui | oui |
| Assassin | Ombres | oui | oui |
| Chasseur | Brasier | oui | oui |
| Mage | Cristaux | oui | oui |
| Druide | Sylvestre | oui | oui |
| Heal | Marées | oui | oui |
| Invocateur | Brumes | oui | **oui (nouveau)** |
| Sylvain | Vents | oui | **oui (nouveau)** |
| Géomancien | Sables | oui | **oui (nouveau, classe créée)** |

Manque : animations (le jeu n'utilise qu'une image fixe par héros), poses « attaque » / « touché » / « KO », portraits d'équipe en buste.

## 3. Invocations et terrain

| Sprite | Classe | Style planche ? | Remarque |
|---|---|---|---|
| Loup | Invocateur | **oui** (Loup spectral) | remplacé |
| Arbre | Sylvain | **oui** (Ent de combat) | remplacé |
| Tortue, Sirène, Ange, Homme-Faucon, Centaure | Invocateur | non (ancien style) | **à redessiner** |
| Buisson, Champignon, Tronc, Sarriette, Ronce agressive, Racines | Sylvain | non (ancien style) | **à redessiner** |
| Balise | Chasseur | non | à redessiner |
| Pilier, Muraille, Faille, Cristal ambré | Géomancien | SVG provisoires (dessinés par code) | **à remplacer par de vraies illustrations** |

## 4. Familiers (ex-invocations, planche) — `assets/sprites/familiers/` (9)

golem_de_pierre, loup_spectral*, archer_sylvestre, elementaire_de_cristal, esprit_de_la_foret, requin_des_marees, ombre_invoquee,
ent_de_combat*, sentinelle_de_gres. (*utilisés comme sprites d'invocation.) Les autres attendent la mécanique de capture en Aventure.

## 5. Ennemis

- **Dans le jeu** : 5 types (Gobelin, Loup, Squelette, Troll, Dragonnet) × variantes normal / `_desert` / `_montagne` / `_boss`.
  Ce sont les anciens skins, pas ceux de la planche.
- **Disponibles** (planche) : 36 ennemis, 4 par nation, dans `assets/sprites/nations/ennemis/<nation>/` — pas reliés à `data/ennemis.txt`
  (il faut des lignes de stats, un biome et des sorts par ennemi).
- **Manquent** : un boss par nation, des variantes d'élite, des PNJ.

## 6. Interface et Conquête

- Aventure : 6 icônes de lieux SVG (camp, coffre, combat, sortie, énigme, belvédère) ; il manque Donjon, Marchand, Fontaine, Porte verrouillée.
- Conquête : icônes de ville pour Forêt, Montagne, Désert, Donjon (+ Brasier, Cristaux, Marées, Vents) ; **manquent** Sylvestre, Cimes, Sables, Ombres, Brumes, et la carte du monde `conquest_world_map.png` n'a que 4 nations.
- Sorts : 187 sorts / ≈ 170 icônes générées par `tools/gen_icons.py` (style générique, pas celui de la planche).
- Objets : icônes d'équipement générées ; pas de sprites d'objets en main sur les héros.
- Sons : 7 musiques, aucun effet sonore propre aux sorts de terrain (pilier, faille).
