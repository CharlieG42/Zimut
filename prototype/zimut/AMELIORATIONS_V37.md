# V37 — Nation des Ombres : premier rendu avec les planches Mistral

Essai d'intégration des planches Mistral (anciens prompts, non passées dans SpriteBuilder).

| Personnage | Fichiers | Source | Poses retenues |
|---|---|---|---|
| Héros Assassin | `players/assassin*.png` (+ copie `nations/heros/`) | face : planche 2×2 aux dagues ; dos : planche 4×3 | repos + 3 attaques ; dos : repos + 3 attaques |
| Boss Nébulia | `nations/boss/ombres*.png` | face : planche 4×3 ; dos : planche 2×2 | repos, idle_2, 4 attaques, 2 sorts, dos |
| Spectre | `nations/ennemis/ombres/spectre*.png` | planche 5×4 | 7 poses (quasi identiques) |
| Ombre infernale | `…/ombre_infernale*.png` | planches 3×2 (face + dos) | repos face + dos |
| Liche | `…/liche.png` | planche 3×2 | repos (6 copies identiques) |
| Assassin des ombres | `…/assassin_des_ombres*.png` | planche 4×3 | 7 poses |

Traitement : découpe en grille, fond damier retiré, cadres et grille iso effacés, ombres au sol retirées,
doublons écartés (signature 32×32, seuil 0,05), poses classées par largeur (étroites = repos, larges = attaques).

Limites connues (réglées par les prompts V36 + SpriteBuilder) : beaucoup de doublons, identité qui dérive
entre face et dos, Liche de dos et personnage « fumée » (planches 3×2) non utilisés car trop différents.

Tests : `test_back_poses` utilise désormais le Chasseur ; `test_sheet_sprites` accepte une planche déjà chibi.
Capture : `tests/shot_ombres.gd`.
