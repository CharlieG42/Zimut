# Forge — notes

## Fenêtre (V15e)
- Fond de forge en pierre, emblème, icônes d'équipement (tuiles) et de ressources : `assets/ui/forge/`
  (générées par `tools/gen_forge_art.py`).
- Mode **Briseur** (ex-« Brisage ») : détruit un objet de l'inventaire et rend des ressources selon sa rareté.
- Accessible depuis « Mes Parties » (bouton Forge) et depuis l'écran d'équipement.

## Idée (non implémentée) : fusion de ressources
Deux ressources du même type et du même niveau se fondent en une ressource du niveau supérieur ;
une ressource de niveau N permet de forger / améliorer un équipement de niveau N (jusqu'à N = 10).

Proposition de coûts (2 pour 1, plus un petit frais en or) :

| Niveau visé | Ressources de niveau précédent | Équivalent en niveau 1 | Frais d'or |
|---|---|---|---|
| 2 | 2 | 2 | 10 |
| 3 | 2 | 4 | 20 |
| 4 | 2 | 8 | 40 |
| 5 | 2 | 16 | 80 |
| 6 | 2 | 32 | 160 |
| 7 | 2 | 64 | 320 |
| 8 | 2 | 128 | 640 |
| 9 | 2 | 256 | 1 280 |
| 10 | 2 | 512 | 2 560 |

À valider : quantités de ressources lâchées par victoire (aujourd'hui quelques unités), place du niveau
dans les recettes (`craft.txt`), migration des sauvegardes (stock par type → stock par type et niveau).
