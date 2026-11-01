# V65 — Vraies planches de bâtiments (Forêt & Montagne), intégrées au jeu

Sprites réels découpés des planches Mistral (style 3D peint isométrique), servis par le jeu depuis
`prototype/zimut/assets/ui/conquest/cities/batiments/<nation>/` (PR #211, norme V65 de la PR #212).
Le jeu les charge **en priorité** sur les illustrations vectorielles (`ConquestCityView._draw_tex_if_any`,
repli de niveau `_sprite_best`, puis vectoriel).

## Aperçus

| Fichier | Contenu |
|---|---|
| `planche_sylvestre.png` | Les 17 sprites de la Forêt (hall_1, caserne, résidence, scierie, mine, tannerie 1-3, cabane 1-3, verger 1-3, muraille 1/3, merveille) |
| `planche_cimes.png` | Les 16 sprites de la Montagne (hall 1-5, caserne, résidence, scierie, mine, tannerie 1-3, cabane 1-3, verger 1) |
| `ville_reelle_sylvestre.png` | Scène 1000×640 recomposée avec les sprites Forêt, posés comme dans le jeu (parcelles + largeurs) |
| `ville_reelle_cimes_hall5.png` | Scène Montagne avec hall_5 (métropole) au centre |

## Pour produire les 8 autres nations
Suivre `prototype/zimut/assets/ui/conquest/cities/batiments/NORME_GENERATION_V65.md` :
1 bâtiment par image, ses 5 niveaux en ligne, caméra iso 2:1, même losange de socle,
emprise fixe (1×1 décors / 2×2 caserne-résidence-cabane-tannerie-scierie / 3×3 hall-mine-verger-muraille-merveille),
fond uni blanc ou chroma `#00B140` (Cimes/Marées/Vents), sans ombre au sol ni personnages.
Puis découper avec `prototype/zimut/tools/slice_city_sprites.py` (table MANIFEST) et déposer les PNG
+ `.png.import` dans `batiments/<nation>/` — le jeu les prend automatiquement.
