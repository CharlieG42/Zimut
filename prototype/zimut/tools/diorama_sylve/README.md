# Diorama de la Sylve (V115, monde vaste V116)

Chaîne hors moteur qui produit la carte 2D « Diorama » de la Sylve
(`data/boards/foret_sylve_diorama.json` + `assets/boards/sylve_diorama/`).
Le résultat est une **scène 3D pré-rendue** (style HD-2D) posée sur le plateau iso du jeu :
la case (x, y) au sol tombe exactement sur son pixel du rendu (`BoardArt.diorama_*`).

Monde de 96×96 unités (144×144 cases) : le village (plan 48×48) au centre, et autour des
plaines sauvages, un lac, des bois, des ruines de fort, des pierres levées et un hameau.

Assets (tous CC0) : kits Kenney du dépôt (`atelier_3d/kenney/` : Fantasy Town, Castle,
Graveyard, Survival) et le *Stylized Nature MegaKit* de Quaternius (CC0, non versionné :
chemin dans `QUATERNIUS_NATURE`).

## Étapes (dossier de travail `DIORAMA_WORK`, Python 3 + numpy/scipy/opencv/Pillow)

1. `python3 make_colormap.py` — palette Fantasy Town réchauffée (`colormap_warm.png`).
2. `python3 terrain96.py` — relief (`height.npy`, lac creusé, bords en dôme) puis texture du sol
   en 2×2 morceaux de 4096 px (`ground_i_j.png`) ; bruits continus d'un morceau à l'autre
   (grandes échelles sur une grille globale, petites par bruit haché). Plan commun : `plan96.py`.
3. `python3 layout96.py` — village (bâtiments assemblés depuis Fantasy Town, ×1,3), puis
   `wild96.py` (plaines, bois, lac, ruines, pierres levées, hameau) → `objects.json`, `plan.json`,
   `height2.npy/png`. Puis `python3 assign_oid.py` (identifiants des occultants).
4. `./render96.sh` — rendu Godot 4×4 tuiles de 5120×2880 pour les passes beauty / depth / normal / id
   (caméra orthographique iso 2:1, élévation 30°).
5. `python3 post96.py 4` — finition B (ombres de contact, contours fins, étalonnage chaud, brume
   légère, halo, vignette ; pas de flou de bord), tuile par tuile → `fin_tx_ty.webp` (2560×1440).
6. `python3 bake96.py` — cases jouables, hauteurs, 20 lieux (village → plaines → bois), tuiles de fond
   et **occultants** (bâtiments, arbres, ruines… découpés grâce à la passe `id`, une page d'atlas par
   tuile) ; en jeu, tuiles et pages sont chargées à la demande autour de la vue.

Contrôle : `tests/test_sylve_diorama.gd`, `tests/test_boutons_carte.gd` (CI) et
`xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_sylve_diorama.gd -- <dossier>`.
