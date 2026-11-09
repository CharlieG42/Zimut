# Dioramas des Nations (V115 → V118)

Chaîne hors moteur qui produit les cartes 2D « Diorama » : une **scène 3D pré-rendue** (style HD-2D)
posée sur le plateau iso du jeu — la case (x, y) au sol tombe exactement sur son pixel du rendu
(`BoardArt.diorama_*`). Monde de 96×96 unités = 144×144 cases.

| Nation | Plan | Mise en place | Planche |
|---|---|---|---|
| Sylve | `plan96.py` | `layout96.py` (+ `wild96.py`) | `data/boards/foret_sylve_diorama.json`, `assets/boards/sylve_diorama/` |
| Brasier | `plan_brasier.py` | `layout_brasier.py` | `data/boards/brasier_cendres_diorama.json`, `assets/boards/brasier_diorama/` |

Partagés : `terrain96.py` (sol + relief, palette `PAL`, lave `LAVA`, volcan `VOLCANO`),
`batiments.py` (maisons assemblées depuis Fantasy Town), `dungeons3d.py` (**bâtiments de donjon** :
grotte, mine, antre, sanctuaire, crypte, porte de la Sylve, fosse de lave, forteresse — le lieu du
donjon est posé devant l'entrée), `assign_oid.py`, `scene96.gd`, `post96.py` (+ `post_lib.py`), `bake96.py`.

Assets (tous CC0) : kits Kenney du dépôt (`atelier_3d/kenney/`) et le *Stylized Nature MegaKit* de
Quaternius (non versionné : chemin dans `QUATERNIUS_NATURE`).

## Étapes (dossier de travail `DIORAMA_WORK`, `DIORAMA_PLAN` = module du plan)

1. `python3 make_colormap.py` — palette Fantasy Town réchauffée (`colormap_warm.png`).
2. `python3 terrain96.py` — relief (`height.npy`, lac / volcan, `lava.npy`, `forbid.npy`) puis sol en
   2×2 morceaux de 4096 px (`ground_i_j.png`, `ground_emit_i_j.png` pour la lave).
3. `python3 layout96.py` (Sylve) ou `python3 layout_brasier.py` (Brasier) → `objects.json`, `plan.json`,
   `height2.npy/png` ; puis `python3 assign_oid.py` (un occultant par bâtiment / donjon / arbre ;
   les petits décors ne sont plus découpés).
4. `./render96.sh` — rendu Godot 4×4 tuiles de 5120×2880 (passes beauty / depth / normal / id).
   Brasier : `DIORAMA_AMP=12 DIORAMA_MOOD=brasier`.
5. `python3 post96.py 4` — finition B (ombres de contact, contours fins, étalonnage, brume, halo,
   vignette ; Brasier : ombres pourpres, lave rayonnante) → `fin_tx_ty.webp`.
6. `python3 bake96.py` — cases jouables, hauteurs, lieux (`PLACES` + donjons), tuiles, occultants,
   fond basse définition. Puis importer dans Godot et régler les `.import` en **VRAM compressée +
   mipmaps** (`compress/mode=2`, `mipmaps/generate=true`).

Contrôle : `tests/test_sylve_diorama.gd`, `tests/test_brasier_diorama.gd`, `tests/test_boutons_carte.gd`
(CI) et `xvfb-run -a godot --rendering-method gl_compatibility --path . -s tests/shot_sylve_diorama.gd -- <dossier> 26 17 brasier`.
