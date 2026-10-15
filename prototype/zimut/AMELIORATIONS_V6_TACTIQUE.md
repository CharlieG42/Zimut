# Zimut — V6 · Optimisation du mode Tactique

## 1. Biomes et aire de combat uniformisés
* **Obstacles de l'aire de combat** (`Prop.gd`) : arbres, rochers... sont désormais dessinés par la même
  fonction que le décor du rebord (`BattleScenery.draw_prop`) — mêmes palettes, mêmes ombres douces,
  même langage graphique : feuillus et grands arbres (Forêt), pins enneigés et rochers à neige (Montagne),
  cactus, palmiers, grès (Désert), piliers, torches, gravats (Donjon). Les anciens SVG d'arbres/rochers de la forêt
  restent dans `assets/` mais ne sont plus utilisés.
* **Sol du rebord = sol de l'aire** : les blocs du rebord reçoivent les mêmes textures de tuiles
  (`forest_ground`, `mountain_ground`, `desert_ground`) que les cases jouables.
* Arbres plus riches (ombre sous la canopée, feuillage détaillé, tronc dégradé).

## 2. Icônes de sorts (nouveau)
* **153 icônes distinctes pour 171 sorts** (`tools/gen_icons.py`) : motif vectoriel (épée, bouclier, flamme, feuille,
  flèche, piège, portail...) sur une pastille à la couleur de la famille du sort (physique, feu, glace, foudre,
  poison, ombre, soin, sacré, soutien, affaiblissement, nature, terre, eau, arcane, invocation) ;
  **étoiles de rang** pour les variantes « supérieur / suprême / ultime / final ».
* **Réutilisation d'une classe à l'autre** : un sort du même nom porte la même icône (`data/spell_icons.txt`,
  éditable à la main : « Nom du sort,id_icône »).
* **Sorts « Invoquer X »** : portrait de la créature invoquée dans une pastille violette (`tools/gen_summon_icons.py`).
* Utilisées dans la colonne de sorts en combat (`SpellIcons.gd`) et sur les cartes de la fiche Personnages.
  Si un sort n'a pas d'icône, l'ancien pictogramme est conservé en secours.

## 3. Sprites des ennemis et des invocations
* **Passe de finition « peinture »** (`tools/polish_sprites.py`) : volume calculé sur la silhouette (lumière en haut à gauche),
  lumière de bord chaude / ombre froide, dégradé ambiant, légère matière. Les PNG générés remplacent les SVG
  (priorité PNG > SVG dans `EntityView` et `Portraits`) ; les SVG restent la source.
* **Variantes par biome** : loup blanc (Montagne) / sable (Désert), gobelin givré / sable, squelette pâle / ocre,
  troll de pierre bleutée / de grès, dragonnet de glace / doré. Choisies automatiquement selon `GameManager.fight_biome`.
* Le Sylvain (skin Sadida) passe aussi par la finition.

## 4. Tests et outils
`tests/test_icons.gd` (chaque sort a une icône chargeable, ≥ 100 icônes distinctes, même nom = même icône) ;
les suites existantes passent (hors 3 vérifications de `test_summons.gd` déjà en échec dans ta version).
Régénération : `python3 tools/gen_icons.py && python3 tools/gen_summon_icons.py && python3 tools/polish_sprites.py`
(nécessite `cairosvg`, `Pillow`, `numpy`).
