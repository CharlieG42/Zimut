# Diorama de la Sylve (V115)

Chaîne hors moteur qui produit la carte 2D « Diorama » de la Sylve
(`data/boards/foret_sylve_diorama.json` + `assets/boards/sylve_diorama/`).
Le résultat est une **scène 3D pré-rendue** (style HD-2D) posée sur le plateau iso du jeu :
la case (x, y) au sol tombe exactement sur son pixel du rendu (`BoardArt.diorama_*`).

Assets utilisés (tous CC0) : kits Kenney du dépôt (`atelier_3d/kenney/` : Fantasy Town, Castle,
Graveyard, Survival) et le *Stylized Nature MegaKit* de Quaternius (CC0, non versionné :
chemin dans `QUATERNIUS_NATURE`).

## Étapes (dossier de travail `DIORAMA_WORK`, Python 3 + numpy/scipy/opencv/Pillow)

1. `python3 terrain.py` — texture du sol 4096² (herbe, chemins, place, champs, prairies) + relief
   (`ground4k.png`, `height.png`, `mask_path.npy`). Le plan commun est dans `plan_v2.py`
   (routes, champs, prairies, verger).
2. `python3 layout_v2.py` — bâtiments (assemblés depuis Fantasy Town, ×1,3), décors, arbres,
   herbes, cultures → `objects.json`, `plan.json`, `height2.png`.
   Puis `python3 assign_oid.py` (identifiants des occultants).
3. `colormap_warm.png` : palette Fantasy Town réchauffée (pierre lavande → pierre chaude,
   roses → terre cuite).
4. `MODES="beauty depth normal id" ./render_tiles.sh` — rendu Godot par tuiles 2×2 en
   5120×2880 (caméra orthographique iso 2:1, élévation 30°).
5. `python3 post48.py 2` — finition B (ombres de contact, contours fins, étalonnage chaud,
   brume légère, halo, vignette ; **pas** de flou de bord) → `sylve48_B.png` (5120×2880).
6. `python3 bake_board.py` — cases jouables (72×72, 1 case = 2/3 d'unité), hauteurs,
   20 lieux (ceux de la planche iso, répartis du village vers les bois), tuiles de fond
   WebP et **occultants** (bâtiments, arbres, étals… découpés grâce à la passe `id`,
   rangés en atlas, triés en profondeur avec le héros en jeu).

Contrôle : `tests/test_sylve_diorama.gd` (CI) et
`xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_sylve_diorama.gd -- <dossier>`.
