# Corrections ponctuelles (hors planches 2x2)

Sprites corrigés case par case (défauts constatés en contrôle V72 / PR #221),
livrés sous un nouveau nom, sans écraser les planches existantes.

| Fichier | Personnage | Défaut corrigé | Source / méthode |
|---|---|---|---|
| `soigneur_cast2_v2.png` | soigneur (héros Marées, `heal`) | `heal_cast_2` : bloc blanc en haut à gauche + tête effacée à l'origine | `edit_image` sur la case « repos face » de `soigneur_vues.png` (référence personnage : cheveux blancs adultes), puis passe de restauration de la tête. Fond blanc uni #FFFFFF partout (coins et quart haut-gauche à 100 % blancs), lumière de soin verte en particules (pas de disque blanc), tête = 1/3 de la hauteur, personnage entier. |

Contrôles automatiques sur `soigneur_cast2_v2.png` (1456x720) : 4 coins blancs purs, quart haut-gauche blanc à 1.0, contenu 491x582 px, tête présente dans le tiers supérieur, ~570 px de particules vertes.

À intégrer avec la case « sort 2 » de la planche actions du soigneur
(`tools/integrer_heros_v2b.py` découpe normalement `soigneur_actions.png` en 4 cases ;
ce fichier sert de remplacement de la case `cast_2` si la planche reste défectueuse).
