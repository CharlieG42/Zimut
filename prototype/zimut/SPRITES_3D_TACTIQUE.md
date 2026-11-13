# Héros 3D animés en Tactique (V155)

Un héros modélisé en 3D (Blender, squelette) est cuit en **planches de sprites** : le mode Tactique reste en 2D, mais le
héros joue de vraies animations image par image (repos, marche, attaque, sort, coup reçu), de face et de dos.
Héros animés : **Sylvain** (V155) et le **Géomancien** (V160). Les autres classes gardent leurs poses PNG.

## Ce que lit le jeu
À côté du sprite `assets/sprites/players/<classe>.png` :

| Fichier | Rôle |
|---|---|
| `<classe>_seq_front.png`, `<classe>_seq_back.png` | planches compactes (V157) : chaque image est rognée à sa partie visible, les images identiques ne sont stockées qu'une fois |
| `<classe>_seq.txt` | JSON : durée, boucle, image clé (impact), position du bout du bâton, et pour chaque image son rectangle dans la planche + son décalage dans la cellule 192 × 192 |
| `<classe>_anim.txt` | réglages existants ; on y met à 0 les mouvements procéduraux (respiration, rebond…) que l'animation 3D fait déjà |

`EntityView` charge ces fichiers s'ils existent (sinon : poses PNG comme avant). Il expose :
- `impact_delay("attack" | "cast")` : délai jusqu'à l'image clé ; `GridManager` y déclenche projectile, éclat de soin, onde ;
- `tip_position(repli)` : position du bout du bâton dans l'image affichée (départ des projectiles).

## Refaire ou ajouter un héros
1. Sous Blender, exporter le FBX avec **les textures intégrées** (Mode de chemin : Copier + icône boîte). Une seule racine d'os.
2. Cuire les images brutes (écran virtuel, pas de GPU nécessaire) :
   `xvfb-run -a -s "-screen 0 1280x720x24" godot --rendering-method gl_compatibility --path . -s tools/bake_hero_seq.gd -- hero.fbx /tmp/brut profile=geomancien`
   (`profile=` : `sylvain` par défaut ; voir les profils ci-dessous)
3. Assembler : `python3 tools/pack_hero_seq.py /tmp/brut assets/sprites/players/<classe>.png`
4. `godot --headless --import`, puis le test `tests/test_sylvain_seq.gd` (à dupliquer pour la nouvelle classe).

Les animations sont **écrites en code** (`scripts/HeroAnim.gd`), os par os, avec les noms d'os du modèle de Sylvain
(`bassin`, `torax`, `tete`, `bras.r`, `avantBras.r`, `main.r`, `cuisse.l`, `tibia.l`…). Un héros avec les mêmes noms les
réutilise tel quel. Le bâton est orienté directement (`staff` : direction voulue, la main pivote en conséquence).

Particularités de Sylvain (constantes en tête de `tools/bake_hero_seq.gd`) : le bout de son bâton était réparti sur le torse
dans les poids de peau (le cristal s'étirait dès que le bras bougeait) ; le script le rend rigide (100 % main) pour les
sommets du côté du bâton (`STAFF_X`, `STAFF_Z_MAX` : au-dessus, ce sont des mèches de cheveux). Un autre modèle demandera
d'autres seuils, ou des poids de peau corrigés dans Blender.

## Profils de cuisson (V160)
`PROFILES` en tête de `tools/bake_hero_seq.gd` règle ce qui change d'un modèle à l'autre :
- `staff_x`, `staff_z_max` : zone du maillage rendue rigide (100 % main droite) pour le bâton ; `orb_x`, `orb_z_min` : même chose pour
  l'orbe du Géomancien (main gauche). La pointe du bâton (départ des projectiles) est mesurée sur le rendu du seul bâton.
- `base` : rotations ajoutées à la pose de repos avant l'animation. Le Géomancien est livré en **pose en T** : bras baissés, avant-bras plié
  (bâton tenu à hauteur de poitrine, orbe en avant), puis les animations de `HeroAnim.gd` jouent par-dessus.
- `staff_idle` : direction du bâton quand l'animation n'en impose pas (debout dans la main, légèrement écarté) ; `gain` : exposition
  (la peau du Géomancien brûlait avec l'éclairage de Sylvain).
- Les noms d'os `torse`, `avantbras.*` sont reconnus comme `torax`, `avantBras.*` (`_bone_idx`). Le maillage du Géomancien compte 792 000
  triangles et 8 influences par sommet : sans importance ici (seules les planches sont versionnées), le script garde les 4 plus fortes.
- Réglage des poses : la variable d'environnement `HERO_BASE_DEBUG` (JSON `{"base": {...}, "staff_idle": [x,y,z], "gain": g}`) remplace
  le profil le temps d'un essai, avec une cuisson partielle (`idle:0 walk:2`).

## Poids mémoire et limites
- Planches compactes (V157) : ≈ 3,8 Mo de mémoire graphique pour Sylvain, 6,7 Mo pour le Géomancien (bâton vertical et orbe : images plus grandes),
  sans perte de qualité. Dix héros ≈ 40 à 70 Mo. Pistes s'il faut descendre encore : ne charger la planche de dos qu'au premier besoin, ou la compression VRAM (avec perte, à juger sur téléphone).
- Le sprite est cuit en 3/4 (tourné de 28° vers la droite) ; le jeu le retourne (`flip_h`) pour la gauche.
- L'animation « mort » n'est pas cuite : la dissolution en lumière (V70) reste.
- Rien n'a été testé sur téléphone.

## Prototype : 3D en direct (V161)
Alternative aux planches cuites, derrière le réglage « Sylvain en combat (prototype) » (`hero_3d_direct`, éteint par défaut ; seul Sylvain).
- `scripts/Hero3D.gd` : un `SubViewport` par héros (monde 3D propre, fond transparent, caméra orthographique cadrée comme la cuisson :
  `CHAR_FRAC`, `FEET_ROW`), matériau toon + contour par coque inversée, pose évaluée à l'exécution par `HeroAnim.pose` (phase continue).
  Le rendu n'est refait que si la pose change (`UPDATE_ONCE`). La pointe du bâton (origine des projectiles) est calculée sur le maillage.
- `EntityView` lit la texture du viewport à la place de la planche (`_seq_tex_3d`) ; les temps d'action restent ceux des planches
  (image clé au même instant, `impact_delay`). Sans le réglage, ou pour les autres classes, rien ne change.
- Modèle : `assets/heroes3d/sylvain.glb` (≈ 600 Ko, 5 500 triangles, 4 influences de peau), produit avec
  `godot --headless --path . -s tools/import_fbx.gd -- sylvain.fbx assets/heroes3d/sylvain.glb none 1024 7000`.
- `HeroAnim.gd` a été déplacé de `tools/` vers `scripts/` (il est maintenant utilisé par le jeu).
- Le compteur d'images (Réglages) s'affiche aussi en combat.
- **Non mesuré sur téléphone** : coût du rendu (un viewport par héros), contour (fissures possibles aux arêtes vives), mémoire. À comparer avec le compteur.
  Le code de cadrage et de bâton duplique celui de `tools/bake_hero_seq.gd` : à fusionner si le prototype est gardé.
- Les tests de rendu sont impossibles en headless : `tests/test_hero3d_direct.gd` ne couvre que la logique.

## Personnages à animations intégrées (V163)
`Hero3D` gère maintenant deux familles de modèles (voir `Hero3D.MODELS`) :
- **procédural** (Sylvain) : pose calculée par `HeroAnim`, bâton rigide ;
- **clips** (Tharok, Ingénieur — modèles Meshy « rigify » avec animations) : les animations vivent dans le `.glb`. Chaque action du jeu
  (`idle`, `walk`, `attack`, `cast`, `hit`) renvoie à une plage `[t0, t1]` d'un clip, jouée sur `dur` secondes (≥ 1 s de clip → ~1 s de jeu),
  avec `key` = fraction de l'action où tombe l'impact (les effets partent à ce moment). Une action sans clip (`motion`) garde une pose tenue
  et ajoute un mouvement du corps (penché, saut, recul). `EntityView._try_clip_model` fabrique les mêmes tables que les planches cuites.
- Choix du modèle : `Hero3D.model_key` (boss `Gobelin Roi` / général `Tharok le Végétal` → Tharok ; classe interne `Artificier` → Ingénieur).
  Ajouter un personnage = un `.glb` (`tools/import_fbx.gd -- x.fbx assets/heroes3d/x.glb none 1024 12000`) + une entrée dans `MODELS`.
- Le maillage Meshy (~10 400 triangles) est gardé tel quel ; chaque `.glb` pèse ≈ 1,8-2 Mo (texture 1024 px).
- Ingénieur : un seul clip fourni (« Stand_and_Drink », 8,9 s : il boit de la main gauche, marteau sur l'épaule) → pas de marche ni d'attaque propres.
- Pas de pointe d'arme calculée pour ces modèles : les projectiles partent du point de repli habituel.
