# V45 — Nation Sylvestre (premiers sprites) + outillage

## Intégré tel quel (planches Mistral)
- **Druide** (héros) : repos, attaque, repos de dos, lancer de dos, marche de dos. Design B retenu (pince feuille, yeux ambre, bâton main gauche). Pas de lancer/marche de face exploitables → repli automatique sur les poses existantes.
- **Araknéa** (monstre) : repos + variante (les 4 variantes d'origine ne diffèrent que par l'expression, dédoublonnées).
- Non utilisés : design A (cheveux sombres, yeux verts), design C (orienté à gauche, fond crème, lumière dorée incrustée).

## Problèmes constatés dans le lot
- 8 cases au lieu de 4, 5 au lieu de 6 ; face et dos mélangés sur la planche d'actions.
- 3 designs différents du Druide selon les planches ; une planche orientée à gauche.
- Fond crème et lueur dorée peinte dans le sprite.

## Outils
- `tools/integrer_planches.py` + `tools/mappings/*.json` : intégration générique (échelle, miroir pour sprites orientés à gauche, dédoublonnage, copies héros). Remplace les scripts codés en dur.

## Prompts (régénérés, QC OK)
- Fond blanc pur « pas crème/beige/ivoire ».
- Éclairage : simple liseré, jamais de lueur/halo/teinte ; négatifs ajoutés (golden glow, flare, ombre au sol…).
- Variantes de repos explicitement différentes (main sur la hanche, tête tournée, appui inversé) pour éviter les doublons.
