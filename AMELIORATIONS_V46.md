# V46 — fin de la Nation Sylvestre + Tank (Cimes)

Intégré tel quel depuis les planches Mistral (`tools/mappings/sylvestre_cimes.json`, outil `tools/integrer_planches.py`).

| Personnage | Poses | Remarques |
|---|---|---|
| Araknéa | 7 | face/dos symétriques ; attaque/sort/marche issues de la planche d'actions |
| Loup forestier | 11 | planche de dos regardant à gauche → retournée |
| Dryade | 10 | arc ; planche de vues mélangeant arc/sans arc |
| Tréant | 11 | dos très proches entre eux (doublons écartés si besoin) |
| Boss Sylvestre (Tharok) | 7 | pas d'actions de face (attaque/sort) : repli automatique |
| Tank (héros Cimes) | 11 | dessiné tourné vers la gauche → toutes les cases retournées |

## Constats sur le lot
- Fonds crème (Araknéa, Dryade, Boss) et gris (Tank) au lieu du blanc demandé ; lueur dorée résiduelle sur certaines vues.
- Boss : planche de vues à 8 cases au lieu de 4, planche d'actions de face absente.
- Tank : sprites tournés vers la gauche ; cheveux blancs proches du fond gris.
- Loup : deux vues de face sur quatre ne regardent pas à droite.
- Dryade : jeune elfe sans chaussures, loin de la fiche « corps de branches et de feuilles ».

## Outils
- `couper_planche.py --shadow-delta N` : n'efface comme ombre que les pixels plus sombres de N que le fond (évite de manger les cheveux/barbes blancs sur fond gris : N=22 et `--holes 2500` pour le Tank).
