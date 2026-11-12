# Héros 3D animés en Tactique (V155)

Un héros modélisé en 3D (Blender, squelette) est cuit en **planches de sprites** : le mode Tactique reste en 2D, mais le
héros joue de vraies animations image par image (repos, marche, attaque, sort, coup reçu), de face et de dos.
Premier héros : **Sylvain**. Les autres classes gardent leurs poses PNG.

## Ce que lit le jeu
À côté du sprite `assets/sprites/players/<classe>.png` :

| Fichier | Rôle |
|---|---|
| `<classe>_seq_front.png`, `<classe>_seq_back.png` | planches 1536 × 960 : une ligne par animation (idle, walk, attack, cast, hit), une colonne par image, cellule 192 × 192 |
| `<classe>_seq.txt` | JSON : durée, boucle, image clé (impact) et position du bout du bâton pour chaque image |
| `<classe>_anim.txt` | réglages existants ; on y met à 0 les mouvements procéduraux (respiration, rebond…) que l'animation 3D fait déjà |

`EntityView` charge ces fichiers s'ils existent (sinon : poses PNG comme avant). Il expose :
- `impact_delay("attack" | "cast")` : délai jusqu'à l'image clé ; `GridManager` y déclenche projectile, éclat de soin, onde ;
- `tip_position(repli)` : position du bout du bâton dans l'image affichée (départ des projectiles).

## Refaire ou ajouter un héros
1. Sous Blender, exporter le FBX avec **les textures intégrées** (Mode de chemin : Copier + icône boîte). Une seule racine d'os.
2. Cuire les images brutes (écran virtuel, pas de GPU nécessaire) :
   `xvfb-run -a -s "-screen 0 1280x720x24" godot --rendering-method gl_compatibility --path . -s tools/bake_hero_seq.gd -- hero.fbx /tmp/brut`
3. Assembler : `python3 tools/pack_hero_seq.py /tmp/brut assets/sprites/players/<classe>.png`
4. `godot --headless --import`, puis le test `tests/test_sylvain_seq.gd` (à dupliquer pour la nouvelle classe).

Les animations sont **écrites en code** (`tools/hero_anim.gd`), os par os, avec les noms d'os du modèle de Sylvain
(`bassin`, `torax`, `tete`, `bras.r`, `avantBras.r`, `main.r`, `cuisse.l`, `tibia.l`…). Un héros avec les mêmes noms les
réutilise tel quel. Le bâton est orienté directement (`staff` : direction voulue, la main pivote en conséquence).

Particularités de Sylvain (constantes en tête de `tools/bake_hero_seq.gd`) : le bout de son bâton était réparti sur le torse
dans les poids de peau (le cristal s'étirait dès que le bras bougeait) ; le script le rend rigide (100 % main) pour les
sommets du côté du bâton (`STAFF_X`, `STAFF_Z_MAX` : au-dessus, ce sont des mèches de cheveux). Un autre modèle demandera
d'autres seuils, ou des poids de peau corrigés dans Blender.

## Poids mémoire et limites
- Deux planches de 1536 × 960 en RVBA non compressé ≈ 11,8 Mo de mémoire graphique par héros animé. À surveiller si les
  dix classes passent en 3D (≈ 118 Mo) ; l'import en compression VRAM (ASTC/ETC2) diviserait cela par 4 à 6, à tester.
- Le sprite est cuit en 3/4 (tourné de 28° vers la droite) ; le jeu le retourne (`flip_h`) pour la gauche.
- L'animation « mort » n'est pas cuite : la dissolution en lumière (V70) reste.
- Rien n'a été testé sur téléphone.
