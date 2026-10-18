# V19 — Équilibrage du début de partie, glyphes, correctif Gouverneurs

## Équilibrage (retours de test sur téléphone)
- **Sorts des héros** : dégâts, soins et dégâts sur la durée divisés par **1,8** (au lieu de 1,5). Les attaques des invocations et du Pilier suivent (÷ 2).
- **Début de partie plus coriace** : les ennemis ont jusqu'à **+60 % de PV** au niveau 1, effet qui s'efface au niveau 11 ; ils frappent **×0,6** au niveau 1 (retour à ×1 au niveau 11), et `ENEMY_ATK_MULT` passe de 1,7 à 1,5. Résultat en simulation (sans équipement, niveau 2) : 4 à 6 tours par combat (avant : 2 à 3).
- **XP** : les premiers niveaux demandent **~3 combats** chacun (avant : ~2, et jusqu'à 1,5 avec le bonus d'écart de niveau). L'effet s'estompe jusqu'au niveau 30. Le bonus d'XP « ennemis plus forts que toi » est plafonné à +25 % (avant +50 %).
  Les sauvegardes existantes gardent leur XP : les héros devront simplement accumuler un peu plus pour passer le prochain niveau.
- **Tours du Géomancien** : Pilier 160 → **70 PV** (défense 40 → 30), Muraille 110 → 70, Cristal ambré 200 → 90.

## Glyphes (Géomancien, Assassin, Chasseur)
Un glyphe est une zone posée au sol pendant **3 tours du lanceur** (2 glyphes actifs maximum par héros, le plus ancien s'efface). Il agit sur les créatures présentes **à l'instant du lancer, en entrant dans la zone, puis au début de chacun de leurs tours** (une fois par tour de jeu). Les runes sont dessinées au sol.

| Classe | Glyphe (remplace) | Niveau | Effet |
|---|---|---|---|
| Géomancien | **Glyphe de grès** (Armure de grès) | 1 | zone 3×3 : alliés +25 % défense |
| Géomancien | **Glyphe sismique** (Invoquer Faille) | 50 | zone 3×3 : ennemis 30 dégâts magiques + ralentis 1 PM |
| Assassin | **Glyphe de venin** (Marque de la mort) | 35 | croix : ennemis 25 dégâts/tour (poison, 2 tours) |
| Assassin | **Glyphe d'ombre** (Invisibilité) | 65 | croix : alliés invisibles |
| Chasseur | **Glyphe d'entrave** (Piège) | 1 | croix : ennemis ralentis de 2 PM |
| Chasseur | **Glyphe de flammes** (Flèche enflammée) | 50 | zone 3×3 : ennemis 25 dégâts + brûlure 20/tour |

- Les sorts sont décrits en texte (`Trace un glyphe (3x3; 3 tours) : alliés … | ennemis …`) dans `data/sorts.txt` ; le format est lu par `Combat.parse`.
- Les niveaux de sort (+6 %/niveau) augmentent les valeurs des glyphes.
- Les anciennes sauvegardes sont migrées (renommage des sorts, points conservés).
- L'IA des héros (mode auto) sait poser les glyphes sur les groupes d'ennemis.

## Correctif
- **Fenêtre de choix du Gouverneur** (écran de ville) : elle partait du centre vers le bas/droite et sortait de l'écran. Elle est maintenant centrée et sa hauteur s'adapte. Même protection sur les fenêtres de la carte de Conquête.

## Outils / tests
- `tools/gen_balance_v15.py` : `HERO_SPELL_DIV`, `early_hp`, `early_atk` (réglables par variables d'environnement `HERO_DIV`, `EARLY_BONUS`, `EARLY_ATK`, `EARLY_SPAN`) + sorts glyphes.
- `tools/gen_glyph_icons.py` : icônes des glyphes. `tests/test_glyphs.gd`, `tests/shot_glyph.gd`, `tests/shot_governors.gd`, `tests/sim_balance.gd` accepte une équipe : `-- <victoires> <niveau> <n> x Géomancien,Chasseur,Assassin`.
