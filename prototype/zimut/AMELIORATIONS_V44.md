# V44 — Nation du Brasier : essai avec les planches Mistral

Intégration « telle quelle » des 12 planches fournies le 23/10 (outil : `tools/couper_planche.py` puis `tools/integrer_brasier.py`,
qui contient la table case → pose).

| Personnage | Poses | Source |
|---|---|---|
| Chasseur (héros) | repos, idle ×2, marche, 3 attaques, sort, dos + idle de dos | vues 10 cases (armure rouge/flammes) + actions 6 cases |
| Salamandre | repos, idle ×2, marche, 3 attaques, sort | 2 planches 3×2 |
| Dévoreur de flammes | idem | 2 planches 3×2 |
| Golem de lave | idem | 2 planches 3×2 |
| Kharaz (boss) | repos, idle, dos, idle de dos | vues 2×2 |

Traitement : fond et ombres retirés (blanc, gris, rose), zones enfermées (entre l'arc et le corps) rendues transparentes,
échelle commune par personnage, doublons écartés (signature 32×32).
Anciennes poses du Chasseur, du boss et des 3 monstres remplacées (plus de mélange de dessins).

Limites constatées : le Chasseur attaque avec un bâton enflammé (planche d'actions sans arc), certaines poses regardent à gauche,
pas de poses de dos pour les monstres, pas d'attaques ni de sorts pour Kharaz. Corrigé à la source par la PR de prompts suivante.

Test : `test_back_poses` (le Chasseur a maintenant 3 attaques de face).

Non intégrées : 2 planches (capuche noire, cheveux de flammes ; vues 3×2 + actions 3×2). Elles ne correspondent ni au Lieutenant (capuche, bâton) ni à Kharaz (arc, cape rouge) et mélangent un arc et des torches : le Lieutenant garde son sprite actuel.
