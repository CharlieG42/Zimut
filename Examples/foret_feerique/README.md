# Forêt féerique — planche de sprites décor (mode Aventure)

Planche 5×4 / 20 sprites pour la forêt féerique du mode Aventure de Zimut
(style Northgard 2D : vue 3/4, peint à la main / low-poly, verts saturés,
pierre gris-beige, torches orange, cristaux bleus, ombres cohérentes).

- Génération : gen-image, 2026-11-05
- Fichier source ici : `planche_5x4_v1.jpg.b64` (base64, sans retour à la ligne)
- MD5 attendu après décodage : `671984e051cc741dd7b39810dce105fa` (347 237 octets)

## Pourquoi un .b64 ?

Le connecteur GitHub applique un encodage UTF-8 qui corrompt les fichiers
binaires (> +50 % d'octets, md5 invalidé). Le JPEG est donc stocké en base64
texte, transporté et vérifié intégralement.

## Décoder le JPG

Linux / macOS / Git Bash :

    base64 -d planche_5x4_v1.jpg.b64 > planche_5x4_v1.jpg

Windows (cmd) :

    certutil -decode planche_5x4_v1.jpg.b64 planche_5x4_v1.jpg

Windows (PowerShell) :

    [IO.File]::WriteAllBytes("planche_5x4_v1.jpg", [Convert]::FromBase64String((Get-Content planche_5x4_v1.jpg.b64 -Raw)))

Vérifier : `md5sum planche_5x4_v1.jpg` (ou `certutil -hashfile planche_5x4_v1.jpg MD5`)
doit retourner `671984e051cc741dd7b39810dce105fa`.

## Contenu de la planche (cellules 1→20, grille 5×4)

| # | Sprite | # | Sprite |
|---|---|---|---|
| 1 | feuillu_1 (gros chêne) | 11 | muret_droit (2 cases) |
| 2 | feuillu_2 (bouleau) | 12 | muret_coin (L) |
| 3 | feuillu_3 (jeune) | 13 | escalier (3 marches) |
| 4 | sapin_1 (grand) | 14 | torche |
| 5 | sapin_2 (moyen) | 15 | cristal |
| 6 | sapin_3 (jeune) | 16 | buisson |
| 7 | rocher_1 (gros moussu) | 17 | buisson_baies |
| 8 | rocher_2 (moyen moussu) | 18 | fleurs |
| 9 | rocher_3 (petit moussu) | 19 | champignon |
| 10 | rocher_4 (galet) | 20 | champignons (×3) |

Découpage : `tools/extract_sheet_sprites.py --grid 5x4` puis `detoure_planche.py`.
Prompt complet et intégration Godot : canvas « Forêt féerique — Projet Godot 4 de démonstration ».
