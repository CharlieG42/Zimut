# V38 — Essai Sylvain + Garde aérien, cartes d'identité dans les prompts

## Essai en jeu (planches Mistral fournies le 21/10)
- **Sylvain** : 21 poses (`players/sylvain*.png`, copie `nations/heros/`). Repos face/dos = fiche de référence ;
  garde, marche, 6 attaques, 3 sorts de face ; garde, marche, 3 attaques, 2 sorts de dos.
  Écartées : l'arme dessinée seule, la planche de marche de profil (4 cases identiques), le dos « lavande ».
- **Garde aérien** (`nations/ennemis/vents/garde_aerien*.png`) : planche 3×2 (repos, garde, marche, 3 attaques).
  La fiche « chevalier ailé » n'est pas utilisée : autre dessin, et sa vue « de dos » est une vue de face visière fermée.
- Découpe : fond gris dégradé ou blanc retiré par remplissage depuis les bords, bloqué par les contours sombres
  (les cheveux blancs restent intacts), ombres au sol retirées, échelle commune par planche.
- Dérive visible en jeu : le repos (cheveux menthe, yeux verts) et les attaques (cheveux blancs en pointes, yeux marron)
  ne sont pas le même personnage → corrigé à la source par les cartes d'identité.

## Prompts : cartes d'identité (`prompts_sprites/identites.py`)
Cartes pour les 73 personnages (héros, boss, ennemis de toutes les nations, familiers).
Voir `prompts_sprites/README.md`, section V38.

## Capture
`tests/shot_nation_sprites.gd -- <dossier> <héros> <zone> <préfixe> <types>` (ex. `Sylvain vents_plateau vents Gobelin,Gobelin`).
