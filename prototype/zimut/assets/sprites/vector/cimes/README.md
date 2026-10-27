# Nation des Cimes — sprites vectoriels (v3 : toutes les poses)

6 personnages × face/dos × 6 poses = **72 sprites** (PNG x1,5 sans ombre — le jeu dessine la sienne — + SVG sources).

| Personnage | Dossier | Fichiers (mêmes noms que le jeu) |
|---|---|---|
| Tank | `heros/` | `tank`, `tank_idle_2`, `tank_walk`, `tank_attack`, `tank_attack_2`, `tank_cast` + `tank_back*` |
| Guerrier des monts, Griffon des cimes, Garde des pics, Rochebrute | `ennemis/` | `<nom>`, `<nom>_idle_2`, `_walk`, `_attack`, `_attack_2`, `_cast` + `<nom>_back*` |
| Vorkann le Givre (boss) | `boss/` | `cimes`, `cimes_idle_2`, … + `cimes_back*` |

- `svg/` : sources vectorielles · `apercu/` : planches de contrôle de chaque personnage (avec ombre).
- Tous les sprites d'un personnage partagent le même cadre (même échelle d'une pose à l'autre) ; rien n'est rogné.
- Régénérer : `python3 tools/vector/render_cimes.py` (`pip install cairosvg pillow`). Chaque personnage est un sprite articulé
  (`tools/vector/<perso>.py` + `rig.py`) : une pose = des rotations/translations par membre.

## Brancher dans le jeu (optionnel, rien n'est appliqué par défaut)
```
python3 tools/vector/integrer_cimes_vectoriel.py --apply      # sauvegarde les PNG actuels puis copie les vectoriels
python3 tools/vector/integrer_cimes_vectoriel.py --restore    # remet les PNG d'avant
```
Le jeu règle la hauteur d'affichage d'après la hauteur du PNG : si un personnage paraît plus petit/grand qu'avant, ajuster `_target_height()` (EntityView.gd).

## Versions précédentes conservées
- `../cimes_v1/` : premier essai (contours bruns épais) · `../cimes_v2/` : repos 3/4 à contours fins (sources dans `tools/vector/v2/`)
- `../_archive/cimes_png_v57/` : PNG d'origine du jeu (ignorés par Godot via `.gdignore`)
