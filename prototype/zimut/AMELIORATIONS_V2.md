# Zimut_Iso — Améliorations V2

Analyse du module `prototype/zimut` puis implémentation. Tout est testé en headless
(Godot 4.7.2) : 7 suites de tests, simulations IA contre IA et captures d'écran sous Xvfb.

## 1. Ce que l'analyse a révélé

| Constat | Conséquence |
|---|---|
| Les persos étaient **toujours niveau 10** (`DEFAULT_PLAYER_LEVEL`) alors que les ennemis gagnaient +2 niveaux par victoire. | Aucune évolution de personnage, difficulté qui explose. L'XP de `classes.txt` et `ennemis.txt` n'était jamais utilisée. |
| En partie sauvegardée, les stats venaient de la **ligne niveau 1** de `classes.txt` mais étaient étiquetées « Lv10 ». | Incohérence stats / niveau / sorts. |
| Les **effets d'objets** (« Critique +10% », « +1 PM », « Vol de vie »…) n'étaient que du texte. | Une partie des objets ne servait à rien. |
| La **Sagesse** n'avait aucun effet en combat. | Stat inutile sur beaucoup d'objets. |
| L'équipement d'un perso **retiré de l'équipe était perdu**. | Perte d'objets. |
| Le niveau requis des objets n'était pas vérifié ; loot uniforme sur tous les objets de niveau ≤ N. | Loots obsolètes très fréquents. |
| Les **invocations n'avaient pas de skin** (rond coloré), Troll/Dragonnet dessinés en code. | Rendu hétérogène. |
| Effets de sorts : seule la **couleur** changeait. | Peu de lisibilité des sorts. |

## 2. Évolution des personnages (`ClassRules.gd`, `ProgressionManager.gd`)

* **Roster** : chaque classe a sa progression sauvegardée (niveau, XP, points investis, capital).
  Les anciennes parties sont migrées automatiquement (l'équipe reprend le niveau des ennemis).
* **XP** : somme des XP des ennemis (`ennemis.txt`) × 3 (×1,5 pour le boss). ≈ **40 combats** de niv. 10 à 50.
  Rythme propre à chaque classe (Tank/Heal ×1,10 — Assassin/Mage/Invocateur/Sylvain ×0,95).
  Classes **hors équipe : 35 %** de l'XP ; classe en retard de plus de 4 niveaux : +50 % (rattrapage).
  Une **défaite** rapporte 25 % de l'XP.
* **Points de caractéristiques** : 4 par niveau. Coût d'un point selon l'**affinité** de la classe
  (A = 1 pt jusqu'à 40 investis, puis 2, puis 3 — B = 2 puis 3 — C = 3). Vitalité = +3 PV/point.
  Répartition **auto** par défaut (recette par classe) ou **manuelle**, respec gratuit.
* **Paliers PA/PM** par classe (ex. Assassin +1 PM niv. 20, Mage +1 PA niv. 40…).
* **Sorts** débloqués selon le **vrai niveau** du perso (colonne `Niveau_requis` de `sorts.txt`).
* **Niveau des ennemis** = niveau moyen de l'équipe (+1 toutes les 10 victoires) : plus de mur de difficulté.
* **Fiche PERSONNAGES** (`CharacterSheetUI.gd`) depuis la sélection d'équipe et l'écran des parties :
  barre d'XP, détail base / points / objets, coût du prochain point, prochain sort.

## 3. Objets (`ItemRules.gd`)

* **Effets réellement appliqués** : critique, vol de vie, dégâts magiques, résistance magie, PA/PM,
  poison à l'impact (35 %), venin, bénédiction d'équipe, anti-altération / invulnérabilité de départ.
* **Raretés** : Commun / Rare (+15 %) / Épique (+30 %, +1 stat) / Légendaire (+50 %, +2 stats).
  Le boss garantit un objet rare ou mieux et 3-4 loots. Couleurs dans toutes les listes.
* **Panoplies** (11) : bonus à 2 / 3 / 4 / 6 pièces (cuir, fer, runique, lumière, légendaire…).
* **Règles** : niveau requis, arme à 2 mains libère le bouclier, équipement rendu à l'inventaire
  quand un perso quitte l'équipe, bouton **ÉQUIPER LE MEILLEUR**.
* **Loots** pondérés vers le niveau du combat (objets légèrement au-dessus possibles).

## 4. Combat

* **Sagesse** : réduit l'esquive adverse, augmente les soins, aide à résister aux altérations de contrôle.
* Soins : intelligence × sagesse × bonus d'objets. Invocations : héritent du niveau et de l'intelligence de l'invocateur.
* **Enrage** : au-delà du tour 14, les ennemis frappent +10 % par tour (fin des combats interminables).
* Boss : niveau du combat, sbires 2 niveaux en dessous (le nom ET les stats, avant seul le nom changeait).
* Équilibrage (constantes en tête de `GameManager.gd`) : `ENEMY_HP_MULT 3.0`, `ENEMY_ATK_MULT 2.0`,
  `ENEMY_LEVEL_SCALE 0.008`, `BOSS_HP_MULT 1.2`, `BOSS_ATK_MULT 0.85`.
  Simulations IA : ~80-90 % de victoires pour une équipe équilibrée, boss plus dur (IA basique, un humain fait mieux).
  Une équipe sans tank est nettement plus fragile.
* Combat rapide (sans partie) : persos niveau 10 avec stats cohérentes.

## 5. Graphismes

* **16 nouveaux skins SVG** (`tools/gen_skins.py` les régénère) : Gobelin, Squelette, Loup, Troll, Dragonnet,
  **Dragonnet boss** ; invocations Tortue, Loup spirituel, Sirène, Ange, Homme-Faucon, Centaure, Buisson,
  Champignon, Tronc, Sarriette.
* `EntityView` : tailles par type (Troll/Dragonnet imposants, boss géant avec aura rouge, invocations plus petites),
  noms de fichiers sans accents, dossier `summons/`. Portraits (timeline, HUD) corrigés pour les invocations.
* **Effets de sorts par élément** (`SpellFx.gd`) : feu, glace, foudre, poison, ombre, lumière, nature, terre, eau,
  arcane, physique — projectile propre (flèche, éclat, boule de feu, glu, orbe, feuille, éclair), rune d'incantation,
  anneau de zone, impact spécifique (braises, éclats, éclair, bulles, fumée, pilier de lumière, débris…).
  L'élément est déduit du nom du sort (mots-clés dans `SpellFx.KEYWORDS`, faciles à compléter).

## 6. Installation

Dézipper à la **racine du dépôt** (les chemins commencent par `prototype/zimut/`) en acceptant les remplacements,
puis ouvrir le projet une fois dans Godot (génération des `.import`).

Fichiers modifiés : `GameManager`, `Combat`, `ProgressionManager`, `EntityView`, `GridManager`, `UIManager`,
`Portraits`, `TeamSelectionUI`, `TeamSelectionManager`, `TeamEquipmentUI`, `SaveSlotsUI`.
Nouveaux : `ClassRules`, `ItemRules`, `SpellFx`, `CharacterSheetUI`, `tools/gen_skins.py`, skins SVG, tests.

## 7. Tests

```
godot --headless --path prototype/zimut -s tests/test_progression_v2.gd   # XP, points, objets, panoplies, fiche
godot --headless --path prototype/zimut -s tests/test_spellfx.gd          # éléments de sorts, skins présents
godot --headless --path prototype/zimut -s tests/sim_progression.gd -- Tank,Assassin,Mage 40   # 40 combats IA
godot --headless --path prototype/zimut -s tests/sim_progression.gd -- Tank,Mage,Heal 8 lvl:30  # taux de victoire à niv. 30
xvfb-run -a godot --rendering-method gl_compatibility --path prototype/zimut -s tests/shot_battle.gd -- /tmp/shots 5 boss
```

## 8. Biomes et craft (V3)

**Biomes** : le cycle des combats traverse désormais **Forêt → Montagne → Désert** (4 combats chacun,
le 4ᵉ étant le boss). La colonne `Biome` de `ennemis.txt` est utilisée : chaque biome a ses 2 types
d'ennemis et son **boss nommé** (Gobelin Roi, Troll Géant, Dragon — kits spéciaux : drain de vie,
résistance magie, dégâts magiques, poison permanent). La grille change de palette selon le biome
(cactus dans le Désert, rochers en Montagne — `Cell.gd`, `Prop.gd`), et la bannière / les titres
annoncent la zone (sélection d'équipe, fenêtre de victoire).

**Craft** : les ennemis lâchent des **ressources** (Fer, Bois, Cuir, Magie, Venin) et de l'**or**.
La **FORGE** (bouton dans l'équipement) fabrique les 66 recettes de `craft.txt` : l'objet reprend les
stats de `stuff.txt`, les ressources et l'or sont consommés. Le stock est visible dans la forge et la
fenêtre de victoire.

Test : `godot --headless --path prototype/zimut -s tests/test_biome_craft.gd`

## 9. Pistes suivantes

Skin Sylvain, IA ennemie plus tactique, équilibrage fin avec de vraies parties.
