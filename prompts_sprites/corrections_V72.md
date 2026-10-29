# Corrections V72 — contrôle des planches du 2026-10-29

## Règles communes (toutes les générations)
- Fond blanc uni #FFFFFF, aucun cadre, aucune ombre, aucun sol, aucun texte. Personnage entier, 80–100 px de marge, plus haut que large.
- Tous les personnages regardent vers la DROITE. Style Dofus/Waven vectoriel, gros contours sombres, tête = 1/3 de la hauteur (chibi).
- **Les vues de repos font foi** : visage, âge, couleurs, silhouette identiques à la planche `*_vues.png` du même personnage.
- Ne PAS écraser les planches existantes : livrer sous un nouveau nom `<nom>_v2_actions.png` etc.
- Chaque case d'une planche 2×2 doit être une pose DIFFÉRENTE (pas de doublon).

## À reprendre

| # | Personnage | Défaut | Planche à refaire |
|---|---|---|---|
| 1 | assassin_des_ombres (ennemi) | face = humanoïde, dos = félin à épines : deux créatures différentes | vues (repos dos) + actions_dos |
| 2 | soigneur (héros) | sort 2 de face : bloc blanc en haut à gauche | actions (case sort 2 seule) |
| 3 | géomancien (héros) | actions de dos : petit enfant en robe | actions_dos |
| 4 | chasseur (héros) | sort de face : gros plan | actions (case sort 1 et 2) |
| 5 | araignee_mecanique, araignee_de_cristal, spectre | poses de dos toutes identiques | actions_dos |

## Prompt 1 — assassin_des_ombres, cohérence face/dos
Référence : la case « repos face » de `assassin_des_ombres_vues.png` (garder CE personnage, pas le félin).
Planche 2×2, 2048×1024, fond blanc uni, 4 cases égales : repos dos, repos dos 2 (léger changement de posture), attaque dos, sort dos.
Le MÊME personnage que la face, vu de DERRIÈRE, tourné vers le haut-droite : mêmes vêtements, même capuche, mêmes lames, même palette. Aucun félin, aucune épine dorsale, aucun second personnage.
NEGATIVE: cat, feline, spikes, different creature, ground, shadow, cropped body.

## Prompt 2 — soigneur, sort 2 de face
Une seule pose (ou case 4 d'une planche actions), fond blanc uni PARTOUT, y compris les coins : aucun carré, aucune forme blanche, aucun halo plein.
Même soigneur adulte aux cheveux blancs que `soigneur_vues.png`, de face, 3/4 vers la droite, bras levés, lumière de soin verte qui s'échappe des mains (sans disque blanc derrière).
NEGATIVE: white square, white block, white disc, frame, child, turquoise hair.

## Prompt 3 — géomancien, actions de dos
Planche 2×2 actions_dos (attaque, attaque 2, sort, sort 2), de DOS vers le haut-droite.
Même géomancien adulte que `geomancien_vues.png` : MÊMES proportions (pas plus petit, pas enfant), même robe, mêmes bijoux/cristaux. Têtes à 1/3 de la hauteur comme sur les vues de repos, personnage aussi grand que dans les autres cases.
NEGATIVE: child, smaller character, oversized head, different robe.

## Prompt 4 — chasseur, sorts de face
Même chasseuse que `chasseur_vues.png` (queue de cheval rouge, écharpe rouge, armure noire flammes), ENTIÈRE, des bottes à la tête, plan large, pas de gros plan.
Sort 1 : arc levé, flamme qui s'enroule autour de la flèche. Sort 2 : flèche enflammée tirée vers le haut-droite, cheveux et écharpe au vent.
Intérieur de l'arc = fond blanc uni (pas de disque ni de voile blanc).
NEGATIVE: close-up, cropped body, filled white bow interior, ground, shadow.

## Prompt 5 — poses de dos distinctes (araignee_mecanique, araignee_de_cristal, spectre)
Planche 2×2 actions_dos pour chacun : 4 poses réellement différentes, de dos vers le haut-droite :
1 attaque (corps ramassé, patte/bras levé), 2 attaque 2 (coup de côté, corps pivoté), 3 sort (élan, énergie qui se charge), 4 sort 2 (énergie libérée, corps étiré).
Même créature que la planche `*_vues.png` (même couleurs, même taille). Aucune case identique à une autre ni au repos de dos.
NEGATIVE: duplicate poses, identical cells, different creature, ground, shadow.

## Rappel : marche
À envoyer à part, après validation des vues de repos : un 2×2 « marche » par héros (2 face + 2 dos), livré en NOUVEAUX fichiers `<héros>_marche.png` / `<héros>_marche_dos.png`, sans toucher aux repos.
