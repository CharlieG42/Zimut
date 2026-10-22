# Prompts de sprites chibi — Zimut

Prompts prêts à copier dans un générateur d'images pour refaire **tous les sprites de combat** au format chibi, avec une finition proche de Dofus / Waven.

| Fichier | Contenu |
|---|---|
| `nations/01_sylvestre.md` … `10_rouages.md` | pour chaque nation : planche de style + 2 planches par personnage (vues, actions) — héros, 4 ennemis, boss, 12 poses chacun |
| `familiers.md` | 12 familiers / invocations, même format (2 planches, 12 poses) |
| `mecanismes.md` | objets fixes : arbre, racines, pilier, muraille, faille, cristal d'ambre, balise, bombe, tourelle, balise de transposition |
| `generer_prompts.py` | source de tout le reste : descriptions, palettes, poses (158 prompts) |
| `identites.py` | **cartes d'identité** des personnages (couleurs exactes de chaque partie, variations interdites) |

Les héros, ennemis, boss et familiers viennent de `scripts/Nations.gd`, `assets/sprites/nations/README.md` et `SPRITES_A_FOURNIR.md`.

## V39 : 2 planches par personnage

Les planches du format précédent (fiches `ref` + `face_1`…`dos_2` par personnage) ont montré deux défauts :
**doublons** (deux cases quasi identiques quand les poses sont trop subtiles) et **personnage qui change**
d'une planche à l'autre (cheveux, équipement), alors que la cohérence à l'intérieur d'une même planche est
bien conservée. Le format V39 exploite ce constat :

1. **Planche `vues`** — un seul personnage, la même pose de repos vue sous **6 angles** (face, 3/4 avant
   droite, 3/4 dos droite, dos, 3/4 dos gauche, 3/4 avant gauche), grille 3 × 2 sur image 2:1.
   Un seul angle par case : aucun doublon possible, et le jeu reçoit d'un coup toutes ses directions.
   **Génération normale.**
2. **Planche `actions`** — 3 attaques + 3 sorts en vue 3/4 avant droite.
   **Générée en édition** de la planche vues (image source = la planche `vues`) : le générateur repart du
   personnage réellement dessiné, il ne peut plus dériver. Repli : génération normale, la carte d'identité
   est recopiée dans chaque prompt.

| Personnage | Planches | Poses |
|---|---|---|
| Héros, ennemis, boss, familiers | `vues` (6 angles) · `actions` (3 attaques + 3 sorts) | 12 |

Les poses d'action viennent des archétypes de `generer_prompts.py` (6 attaques + 3 sorts aux silhouettes
toutes différentes par arme) ; les vues de gauche existent en propre, le jeu n'a plus besoin de retourner
l'image pour elles.

## V38 : le même personnage, sans image jointe — les cartes d'identité

Le générateur ne voit jamais les autres planches : tout ce que le prompt ne précise pas, il le réinvente
(sur l'essai du Sylvain : cheveux menthe, blancs puis lavande, yeux verts puis marron). Chaque prompt
commence donc par une **carte d'identité** recopiée mot pour mot (fichier `identites.py`) :

- **chaque partie visible** est décrite : cheveux, yeux, peau, haut, bas, chaussures, bras, arme et main qui la tient ;
- **couleurs nommées + code hexadécimal** (`pale mint-white hair (#DDF2EE)`) : bien plus stable qu'un « silver-teal » vague ;
- **« rien d'autre »** : le générateur ne doit ajouter aucune pièce ni couleur absente de la carte ;
- **variations interdites** : les dérives déjà vues (yeux fermés, cheveux en pointes, pantalon orange…) ;
- **rappel en fin de prompt** des 4 traits principaux (les générateurs pèsent surtout le début et la fin) ;
- **vues de dos** qui interdisent visage, yeux, masque ou visière (le chevalier « de dos » était en fait de face).

Cartes écrites pour **tous les personnages** : 10 héros, 10 boss, 40 ennemis et 13 familiers (les objets de
`mecanismes.md` n'en ont pas besoin). Les ennemis des Ombres sont décrits d'après les sprites déjà intégrés.
Quand une planche `vues` te plaît, recopie dans sa carte les couleurs vues sur l'image : c'est ce qui verrouille
toutes les planches suivantes — et la planche `actions` éditée depuis la planche `vues` verrouille le reste.

## Méthode, personnage par personnage

1. **Planche de style de la nation** (section 1 de chaque fichier, facultative) : palette et matières de toute la nation.
2. **Planche `vues`** : copie le prompt tel quel, carte d'identité comprise. Recommence jusqu'à ce qu'elle te
   plaise : la planche `actions` en découle.
3. **Planche `actions`** : donne à l'outil d'édition la planche `vues` comme image source, avec le prompt
   `actions`. Si l'outil n'édite pas, génère-la normalement.
4. **Nom du fichier** : `<id>_vues.png` et `<id>_actions.png`, par exemple `chasseur_vues.png`,
   `chasseur_actions.png`. L'Atelier (SpriteBuilder) reconnaît alors le personnage et la planche tout seul.
5. **Atelier Sprites** : importe, vérifie les cadres, regarde l'alerte « Poses en double » (bouton « Exclure
   les doublons »), puis exporte le zip et décompresse-le à la racine du dépôt Zimut. Ouvre une fois le
   projet dans Godot pour l'import.

## Fond de la planche

- **Fond blanc uni** par défaut.
- **Fond gris moyen uni (#808080)** pour les personnages clairs (Mage, Heal, Sylvain, boss Cristaux et Vents) : c'est déjà écrit dans leurs prompts.
- **Jamais de fond vert ou rose** : l'Atelier ne reconnaît que les fonds neutres (blanc, gris, damier). Un fond saturé ne serait pas retiré.
- **Jamais « transparent background »** : la plupart des générateurs dessinent alors un faux damier dans l'image.

## Pièges observés sur les planches précédentes

| Problème | Conséquence | Ce que le format V39 impose |
|---|---|---|
| Même pose recopiée dans plusieurs cases | animations figées | 6 angles par planche (un seul angle par case) ; actions aux silhouettes décrites une par une |
| Personnage différent d'une planche à l'autre | héros méconnaissable | planche `actions` **éditée depuis** la planche `vues` + carte d'identité recopiée partout |
| Poses qui se touchent (épées, effets) | un seul cadre pour deux poses | autocollants ≤ 55 % de leur sixième d'image, larges vides, **surtout horizontaux** |
| Cadres dessinés, grille isométrique au sol | tout est relié, découpe impossible | « no frames, no grid on the ground », négatif « frames, isometric floor grid » |
| Face et dos mélangés dans une case | le jeu ne sait pas quelle vue utiliser | un seul angle par case, listé explicitement |
| Ombre grise sous les pieds | pieds mal posés | « no ground shadow » (le jeu dessine l'ombre) |
| Étiquettes de texte | texte collé au sprite | « no text, no labels, no numbers » |

## Prompt négatif

**Planches `actions` et planches de style** :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art
```

**Planches `vues`** (la même pose vue sous 6 angles est voulue, vues vers la gauche comprises — le négatif
commun est adapté en bas de chaque fichier nation) :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, different character between cells, pose changing between cells, different outfit between angles, realistic proportions, small head
```

## Modifier ou régénérer

Les fichiers Markdown sont générés : modifie les descriptions dans `generer_prompts.py` puis relance depuis la racine du dépôt :

```bash
python3 prompts_sprites/generer_prompts.py
```

Ordre conseillé : commencer par un personnage (ex. Chasseur du Brasier), valider le rendu en jeu, puis enchaîner les autres.
