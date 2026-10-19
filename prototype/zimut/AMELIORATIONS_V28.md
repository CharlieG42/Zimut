# V28 — Tableau des primes et préparation des nouveaux sprites

## 1. Primes du jour (rejouabilité)
- 3 primes tirées chaque jour (même tirage toute la journée pour une partie), parmi : vaincre N gobelins/loups/squelettes,
  gagner 2 combats dans une Nation, gagner 2 combats dans un mode (Tactique / Aventure / Conquête selon les modes débloqués),
  gagner sans K.O., gagner en 4 tours ou moins, vaincre un boss, gagner 4 combats.
- Valables dans **tous les modes** ; la récompense (or + ressource de la Nation, rang 2 ou 3 à haut niveau) est créditée dès la prime terminée.
- Les 3 primes du jour faites : **coffre bonus** (or + Magie et Fer de rang 2/3) et **série** de jours complets d'affilée.
- Bouton « 📜 Primes du jour n/3 » dans Mes Parties, à côté de « 💎 Pierres » : ces deux objectifs sont maintenant juste sous les modes de jeu, visibles sans défiler.
- Ligne « Prime accomplie » dans la fenêtre de victoire.
- Sauvegarde : `save["bounties"]` (rétro-compatible).

## 2. Sprites
- `SPRITES_A_FOURNIR.md` : liste exacte des fichiers attendus (héros, Gultur, boss, ennemis Rouages, invocations, mécanismes, illustrations de ville).
- L'illustration de ville Rouages (`rouages.jpg`) sera prise automatiquement dès qu'elle existe (repli : Brasier).

Tests : `tests/test_bounties.gd`, capture `tests/shot_bounties.gd`.

## V29 — Sprites de la planche « 10 classes » (détourage automatique provisoire)
- Planche RGB sans transparence : le damier peint est retiré automatiquement (`tools/cut_sheet_v29.py`, zones dans `tools/cut_sheet_v29_regions.json`) :
  remplissage depuis les bords sur les pixels gris/blancs, suppression des trous à damier, liseré clair adouci, étiquettes de texte écartées.
- Intégrés : héros **Ingénieur** (Artificier, version pleine taille + version chibi comme les autres héros), boss **Mécanoptère** (titre du boss Rouages),
  monstres **Automate de Combat, Drone Aérien, Araignée Mécanique, Roue Engrenée** (noms affichés en combat).
- Non remplacés : les 9 héros, familiers et ennemis des autres Nations (mêmes dessins que la planche précédente, déjà détourés proprement ;
  les héros en jeu restent en version chibi).
- À refaire quand la planche détourée arrivera : relancer le script, ou déposer les PNG aux noms de `SPRITES_A_FOURNIR.md`.
