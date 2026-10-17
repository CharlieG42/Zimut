# Forge — système de rangs, fusion et amélioration (implémenté)

## Principe
- Les ressources (Fer, Bois, Cuir, Magie, Venin) existent en **rangs 1 à 10** (clé de sauvegarde : `Fer` = R1, `Fer@2` = R2, …).
- Les équipements ont un **rang 1 à 10** : chaque rang ajoute **+12 %** aux stats de base (affiché « Nom R3 »).

## Onglets de la Forge
1. **Fabriquer** : choisir la recette, le rang (1–10) puis fabriquer. Rang 1 = coût normal ; rang N>1 = ressources de rang N (quantité /5, min. 1) et or × rang.
2. **Améliorer** : tout équipement (porté ou en inventaire) passe du rang N au rang N+1 pour 1 ressource de rang N+1 de son type principal + de l'or.
3. **Fusion** : 2 ressources identiques de rang N + or (10 × 2^(N-1)) → 1 ressource de rang N+1.
4. **Briseur** : détruit un objet ; rend des ressources (+ 1 ressource de rang inférieur si rang ≥ 2).

## Coûts de fusion
| Rang visé | ≈ ressources R1 | Or |
|---|---|---|
| R2 | 2 | 10 |
| R3 | 4 | 20 |
| R4 | 8 | 40 |
| R5 | 16 | 80 |
| R6 | 32 | 160 |
| R7 | 64 | 320 |
| R8 | 128 | 640 |
| R9 | 256 | 1280 |
| R10 | 512 | 2560 |

Constantes ajustables dans `ProgressionManager.gd` (MAX_RANK, RANK_BONUS, FUSE_RATIO, UPGRADE_QTY). Tests : `tests/test_forge.gd`.
