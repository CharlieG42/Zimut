# Corrections ponctuelles — Cimes (Tank)

Sprites corrigés case par case (défaut constaté PR #221 : tête/barbe blanche effacées
à l'origine sur les poses de dos), livrés sous un nouveau nom, sans écraser les planches.

| Fichier | Pose | Défaut corrigé | Méthode |
|---|---|---|---|
| `tank_back_attack_v2.png` | attaque 1 de dos (frappe overhead) | tête + barbe blanche effacées | `edit_image` sur la case « repos dos » de `tank_vues.png` (référence personnage), bras levés marteau au-dessus de la tête, bouclier bras gauche |
| `tank_back_attack_2_v2.png` | attaque 2 de dos (charge bouclier) | idem | `edit_image` même source, corps penché en avant, bouclier en avant, marteau bas |
| `tank_back_cast_v2.png` | sort 1 de dos (braver) | idem | `edit_image` même source, tête baissée, bouclier planté au sol, éclats de glace aux pieds |

Personnage verrouillé : Tank (cheveux blancs ramenés en arrière + grande barbe blanche,
armure acier bleu foncé #3A4E6E, bordures fourrure blanche, inlays cristal glace #9FE3FF,
marteau lourd à runes main DROITE, grand bouclier rond emblème nuage/montagne bras GAUCHE).
Vue 3/4 de dos vers le haut-droite, aucune face. Fond blanc uni #FFFFFF partout.

Contrôles automatiques (1456x720 chacun) : 4 coins blancs purs à 1.0, quart haut-gauche
blanc à 1.0, tête présente dans le tiers supérieur (~29 500-34 000 px de contenu,
700-1 050 px quasi-blancs de cheveux/barbe), personnage entier (487-738 px de large,
537-569 px de haut).
