# Équilibrage V15 — héros niveau 1→100, ennemis 1→150, 10 sorts par héros

Document généré avec `tools/gen_balance_v15.py` (données) et un modèle analytique (EHP = PV / (1 − réduction de défense)).
Les sources d'origine (V14) sont conservées dans `data/_src_v14/` ; relancer le script régénère `classes.txt`, `sorts.txt`, `progression_sorts.txt`, `ennemis.txt`, `stuff.txt` et `craft.txt`.

## 1. Principes

- **Étirement ×2 de l'axe des niveaux** : le héros de niveau L vaut l'ancien héros de niveau 1 + (L−1)×49/99. Le capital total de points reste identique (2 points × 99 niveaux ≈ 4 × 49) : mêmes stats finales qu'avant, mais deux fois plus de paliers.
- **Niveau 1 de départ, 3 sorts par héros** ; les 7 autres sorts se débloquent aux niveaux **10 · 20 · 35 · 50 · 65 · 80 · 100** (soit 4 sorts au niveau 10, 5 au 20, 6 au 35, 7 au 50, 8 au 65, 9 au 80, 10 au 100).
- **Points de sort** : 3 par niveau de héros (297 au niveau 100). Passer un sort du niveau n au n+1 coûte n points → 45 points pour un sort de 1 à 10. Au niveau 100 : **5 sorts au niveau 10** (225 points) + 72 points pour les autres ; les 10 à fond coûteraient 450 points : le joueur doit **choisir**. +6 % d'efficacité par niveau de sort. Remise à zéro **gratuite** (comme les points de caractéristiques).
- **Ennemis niveau 1→150** : le niveau suit la moyenne de l'équipe (+1 niveau toutes les 25 victoires, plafonné à 150). Le facteur de niveau (+0,8 %/niveau) est cuit dans `ennemis.txt` ; début de partie adouci (×0,85 au niveau 1 → ×1 au niveau 20).
- **Durée de vie** : ≈ 2 500 combats de la frontière pour passer du niveau 1 au niveau 100 (≈ 2 combats par niveau au début, ≈ 100 pour le dernier palier).
- **Difficulté** : réglage propre à chaque partie (Mes Parties), modifiable à tout moment.

## 2. Identité des classes (stats au niveau 100, capital réparti automatiquement)

| Classe | PV | Force | Int. | Agi. | Sag. | Déf. | EHP | Rôle |
|---|---|---|---|---|---|---|---|---|
| Tank | 567 | 79 | 20 | 26 | 31 | 113 | 1208 | Encaisse (×2,3 à ×3,9 l'EHP des autres) |
| Assassin | 252 | 99 | 22 | 110 | 39 | 26 | 318 | Dégâts physiques, fragile |
| Chasseur | 272 | 101 | 24 | 86 | 46 | 57 | 427 | Tireur polyvalent |
| Mage | 248 | 28 | 135 | 34 | 66 | 26 | 312 | Canon de verre magique |
| Druide | 267 | 34 | 98 | 39 | 89 | 64 | 438 | Soutien / dégâts sacrés |
| Heal | 362 | 20 | 101 | 28 | 106 | 40 | 507 | Soigneur robuste |
| Invocateur | 304 | 22 | 95 | 48 | 66 | 36 | 413 | Familiers |
| Sylvain | 307 | 30 | 87 | 32 | 79 | 53 | 470 | Invocations + terrain |
| Géomancien | 318 | 22 | 84 | 22 | 53 | 70 | 541 | Contrôle du terrain, très résistant |

Le **Tank** reçoit +30 % de PV et +25 % de défense de base ; le Géomancien perd 12 % de défense (il n'est plus presque aussi résistant que le Tank), le Mage et l'Assassin restent les plus fragiles.

## 3. Progression par niveau (exemple Tank / Mage)

| Niveau | Sorts | Points de sort cumulés | Tank PV/Déf | Mage PV/Int |
|---|---|---|---|---|
| 1 | 3 | 0 | 156 / 31 | 66 / 25 |
| 10 | 4 | 27 | 194 / 39 | 86 / 36 |
| 20 | 5 | 57 | 238 / 48 | 104 / 51 |
| 35 | 6 | 102 | 304 / 61 | 136 / 71 |
| 50 | 7 | 147 | 369 / 75 | 163 / 86 |
| 65 | 8 | 192 | 435 / 89 | 187 / 102 |
| 80 | 9 | 237 | 494 / 99 | 213 / 116 |
| 100 | 10 | 297 | 567 / 113 | 248 / 135 |

## 4. Kits de sorts (niveau de déblocage)

- **Tank** : Coup de bouclier (1) · Protection (1) · Soin de combat (1) · Frappe puissante (10) · Provocation (20) · Mur de pierre (35) · Tremblement de terre (50) · Colère (65) · Coup écrasant (80) · Bouclier légendaire (100)
- **Assassin** : Lame fatale (1) · Poison (1) · Soin rapide (1) · Coup bas (10) · Ombre (20) · Marque de la mort (35) · Éviscération (50) · Invisibilité (65) · Lame de l'ombre (80) · Coup final (100)
- **Chasseur** : Tir précis (1) · Piège (1) · Soin de chasseur (1) · Balise de chasse (10) · Tir explosif (20) · Rappel de balise (35) · Fleche enflammée (50) · Tir de recul (65) · Tir légendaire (80) · Tir perçant ultime (100)
- **Mage** : Boule de feu (1) · Éclair (1) · Bouclier magique (1) · Explosion (10) · Téléportation (20) · Météore (35) · Gel (50) · Chaîne de foudre (65) · Désintégration (80) · Apocalypse (100)
- **Druide** : Bénédiction (1) · Soin (1) · Attaque sacrée (1) · Barrière (10) · Inspiration (20) · Soin de groupe (35) · Renaissance (50) · Attaque divine (65) · Résurrection (80) · Jugement (100)
- **Heal** : Toucher guérisseur (1) · Éclair sacré (1) · Bénédiction de vie (1) · Bouclier de lumière (10) · Mot de restauration (20) · Éclat de lumière (35) · Soin supérieur (50) · Soin de groupe supérieur (65) · Protection vitale (80) · Soin ultime (100)
- **Invocateur** : Frappe spectrale (1) · Symbiose (1) · Invoquer Tortue (1) · Invoquer Loup (10) · Attaque de l'invocation (20) · Invoquer Sirène (35) · Buff de l'invocation (50) · Invoquer Ange (65) · Invoquer Homme-Faucon (80) · Invoquer Centaure (100)
- **Sylvain** : Ronce (1) · Sève vitale (1) · Invoquer Buisson (1) · Poison de ronce (10) · Invoquer Arbre (20) · Racine (35) · Soin de sève (50) · Invoquer Champignon (65) · Pluie de graines (80) · Tempête de pétales (100)
- **Géomancien** : Éclat de grès (1) · Invoquer Pilier (1) · Armure de grès (1) · Lance de cristal (10) · Invoquer Muraille (20) · Éboulement (35) · Invoquer Faille (50) · Tempête de sable (65) · Séisme ambré (80) · Cataclysme minéral (100)

## 5. Répartition des points

- 2 points de capital par niveau (coût 1/2/3 selon l'affinité A/B/C de la classe pour la stat, comme avant).
- Répartition automatique **proportionnelle** à la recette de la classe (l'ancienne boucle donnait tous les points à la première stat quand il y en avait peu par niveau).
- Remise à zéro gratuite des points de caractéristiques et des points de sort.

## 6. Migration des anciennes parties

Au chargement, une sauvegarde d'avant V15 est convertie (`ensure_roster` → `_migrate_balance`) : niveaux 1→50 étirés en 1→100, **points investis conservés**, capital restant recalculé, points de sort remis à zéro (les sorts ont changé), historique des niveaux de combat converti, difficulté reprise du réglage global d'avant.

## 7. Mesures (simulation IA contre IA, `tests/sim_progression.gd`)

- Départ niveau 1 : 30 victoires / 30 combats avec Tank·Assassin·Mage (niveau 15 atteint), 29/30 avec Chasseur·Heal·Sylvain, 30/30 avec Druide·Invocateur·Géomancien.
- Niveau 50 fixe : 11/12 pour les trois compositions.
- Niveau 100 fixe, sans équipement ni points de sort : 7/12 (Tank·Assassin·Mage), 10/12 (Chasseur·Heal·Sylvain), 12/12 (Druide·Invocateur·Géomancien) — la fin de jeu est volontairement exigeante ; les compositions à dégâts purs sont les plus fragiles.

## 8. Points à surveiller en test réel

- Le niveau 1 : les dégâts de départ varient beaucoup selon les classes (Assassin ≫ Tank) car les valeurs de sorts n'ont pas été normalisées par rôle.
- Fin de jeu : valeurs de sorts figées (pas de croissance par niveau de héros hors stats) — à ajuster après essais.
- Équipement : niveaux requis étirés de 5-50 à 1-100.
