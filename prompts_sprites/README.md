# Prompts de sprites chibi — Zimut

Prompts prêts à copier dans un générateur d'images pour refaire **tous les sprites de combat** au format chibi, avec une finition proche de Dofus / Waven.

| Fichier | Contenu |
|---|---|
| `nations/01_sylvestre.md` … `10_rouages.md` | pour chaque nation : planche de style, héros (6 planches, 22 poses), 4 ennemis (3 planches, 10 poses), boss (6 planches, 22 poses) |
| `familiers.md` | 12 familiers / invocations (3 planches, 10 poses) |
| `mecanismes.md` | objets fixes : arbre, racines, pilier, muraille, faille, cristal d'ambre, balise, bombe, tourelle, balise de transposition |
| `generer_prompts.py` | source de tout le reste : descriptions, palettes, poses (290 prompts) |
| `identites.py` | V38 : **cartes d'identité** des personnages (couleurs exactes de chaque partie, variations interdites) |

Les héros, ennemis, boss et familiers viennent de `scripts/Nations.gd`, `assets/sprites/nations/README.md` et `SPRITES_A_FOURNIR.md`.

## V38 : le même personnage d'une planche à l'autre, sans image jointe

Le générateur ne voit jamais les planches précédentes : tout ce que le prompt ne précise pas, il le réinvente
(sur l'essai du Sylvain : cheveux menthe, blancs puis lavande, yeux verts puis marron, pantalon orange sur la planche de dos).
Chaque prompt commence donc par une **carte d'identité** recopiée mot pour mot (fichier `identites.py`) :

- **chaque partie visible** est décrite : cheveux, yeux, peau, haut, bas, chaussures, bras, arme et main qui la tient ;
- **couleurs nommées + code hexadécimal** (`pale mint-white hair (#DDF2EE)`) : bien plus stable qu'un « silver-teal » vague ;
- **« rien d'autre »** : le générateur ne doit ajouter aucune pièce ni couleur absente de la carte ;
- **variations interdites** : les dérives déjà vues (yeux fermés, cheveux en pointes, pantalon orange…) ;
- **rappel en fin de prompt** des 4 traits principaux (les générateurs pèsent surtout le début et la fin).

S'ajoutent : yeux toujours ouverts, marche en vue 3/4 tête droite (plus de profil « nez en l'air »), et vue de dos
qui interdit visage, yeux, masque ou visière (le chevalier « de dos » était en fait de face, visière fermée).

Cartes écrites pour **tous les personnages** : 10 héros, 10 boss, 40 ennemis et 13 familiers (les objets de
`mecanismes.md` n'en ont pas besoin). Les ennemis des Ombres sont décrits d'après les sprites déjà intégrés (V37).
Les détails absents des descriptions d'origine (yeux, bottes…) ont été choisis dans la palette de la nation : quand une
fiche de référence te plaît, recopie dans sa carte les couleurs vues sur l'image (c'est ce qui verrouille toutes les planches suivantes.

## V36 : pourquoi des planches de 4 poses

Les premières planches générées (Mistral, oct. 2026) ont montré trois défauts quand on demande 8 à 20 poses d'un coup :
**doublons** (la même pose recopiée 4, 6 ou 20 fois), **personnage qui change** d'une planche à l'autre (coiffure, tenue, sexe)
et **poses qui se touchent** (épées, cadres dessinés, grille au sol). D'où :

1. **Une fiche de référence** par personnage : repos de face (gauche) et repos de dos (droite), image 2:1. Elle fixe l'apparence.
2. **Des planches de 4 poses (2 × 2), une seule vue**, image carrée. Chaque pose est imposée par sa silhouette
   (« COUP HAUT : arme levée au-dessus de la tête », « SAUT : tout le corps en l'air »…) et le prompt exige 4 poses différentes.
3. **Espacement « autocollants »** : chaque pose occupe au plus 55 % de son quart d'image. Ni cadre, ni ligne, ni sol, ni grille.
4. **Style Ankama** : tête ≈ 40 % de la hauteur, grandes mains, petits pieds ronds, contours brun foncé, aplats.

| Personnage | Planches | Poses |
|---|---|---|
| Héros, boss | `ref` · `face_1` (garde, 2 marches, sort) · `face_2` (attaques 1-4) · `face_3` (attaques 5-6, sorts 2-3) · `dos_1` (2 marches, attaque, sort) · `dos_2` (attaques 2-4, garde) | 22 |
| Ennemis, familiers | `ref` · `face_1` (marche, 2 attaques, sort) · `dos_1` (idem de dos) | 10 |

Les 6 attaques d'un héros ont des silhouettes toutes différentes : coup haut, poussée vers l'avant, coup de côté, saut, coup bas,
coup spécial. Les vues de dos ne reprennent que 4 attaques : en jeu, elles ne servent que quand le personnage regarde vers le haut.

## Méthode, planche par planche

1. **Planche de style de la nation** (section 1 de chaque fichier, facultative) : palette et matières de toute la nation.
2. **Fiche de référence** du personnage (`ref`). Recommence jusqu'à ce qu'elle te plaise : tout le reste en découle.
3. **Planches de poses** : copie le prompt tel quel, carte d'identité comprise (aucune image à joindre ; si ton outil le permet,
   joindre la fiche de référence aide encore plus).
   Si une planche contient deux poses semblables, régénère-la plutôt que de la garder.
4. **Nom du fichier** : `<id>_<clé>.png`, par exemple `chasseur_ref.png`, `chasseur_face_2.png`, `liche_dos_1.png`.
   L'Atelier (SpriteBuilder) reconnaît alors le personnage et la planche tout seul.
5. **Atelier Sprites** : importe, vérifie les cadres, regarde l'alerte « Poses en double » (bouton « Exclure les doublons »),
   puis exporte le zip et décompresse-le à la racine du dépôt Zimut. Ouvre une fois le projet dans Godot pour l'import.

## Fond de la planche

- **Fond blanc uni** par défaut.
- **Fond gris moyen uni (#808080)** pour les personnages clairs (Mage, Heal, Sylvain, boss Cristaux et Vents) : c'est déjà écrit dans leurs prompts.
- **Jamais de fond vert ou rose** : l'Atelier ne reconnaît que les fonds neutres (blanc, gris, damier). Un fond saturé ne serait pas retiré.
- **Jamais « transparent background »** : la plupart des générateurs dessinent alors un faux damier dans l'image.

## Pièges observés sur les planches précédentes

| Problème | Conséquence | Ce que le prompt impose |
|---|---|---|
| Même pose recopiée dans plusieurs cases | animations figées | 4 poses par image, chacune décrite par sa silhouette, « clearly different », négatif « duplicate poses » |
| Personnage différent d'une planche à l'autre | héros méconnaissable | fiche de référence jointe à chaque planche |
| Poses qui se touchent (épées, effets) | un seul cadre pour deux poses | pose ≤ 55 % de son quart d'image, armes et effets rentrés |
| Cadres dessinés, grille isométrique au sol | tout est relié, découpe impossible | « no frames, no grid on the ground », négatif « frames, isometric floor grid » |
| Face et dos mélangés | le jeu ne sait pas quelle vue utiliser | une seule vue par planche (sauf la fiche de référence) |
| Ombre grise sous les pieds | pieds mal posés | « no ground shadow » (le jeu dessine l'ombre) |
| Étiquettes de texte | texte collé au sprite | « no text, no labels, no numbers » |

## Prompt négatif commun

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art
```

## Modifier ou régénérer

Les fichiers Markdown sont générés : modifie les descriptions dans `generer_prompts.py` puis relance depuis la racine du dépôt :

```bash
python3 prompts_sprites/generer_prompts.py
```

Ordre conseillé : commencer par **Ombres** (planche de test), valider le rendu en jeu, puis enchaîner les autres nations.
