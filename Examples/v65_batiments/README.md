# V65 — Vraies planches de bâtiments, toutes nations (générées et intégrées)

Sprites 3D peints isométriques générés directement (outil `image_generation`, Black Forest),
découpés par `tools/slice_city_sprites.py --v65` (5 cases égales, détourage, ombre au sol et
chroma vert supprimés, toile commune par bâtiment), déposés dans
`prototype/zimut/assets/ui/conquest/cities/batiments/<nation>/` avec leurs `.png.import`.
Le jeu les charge en priorité (`ConquestCityView._draw_tex_if_any` + repli de niveau `_sprite_best`),
sans aucun changement de code.

## Nations livrées (46 sprites chacune : 9 bâtiments × 5 niveaux + merveille)
| Nation | Dossier | Fond des planches | Esprit |
|---|---|---|---|
| Forêt | `sylvestre` | blanc | (PR #211) |
| Montagne | `cimes` | gris | (PR #211) |
| Brasier | `brasier` | blanc | volcan, lave, braseros |
| Sables | `sables` | blanc | dunes, bazar, auvents rayés |
| Cristaux | `cristaux` | blanc | grottes, gemmes, runes |
| Marées | `marees` | chroma `#00B140` | côte, phare, coraux |
| Vents | `vents` | chroma `#00B140` | îles flottantes, moulins, plumes |
| Brumes | `brumes` | blanc | marais, champignons, feux follets |
| Ombres | `ombres` | blanc | gothique, runes violettes, corbeaux |
| Rouages | `rouages` | blanc | cuivre, laiton, engrenages, vapeur |

## Aperçus
- `planche_brute_<nation>.png` — les 10 planches sources générées.
- `sprites_<nation>.png` — les 46 sprites finaux découpés.
- `ville_generee_<nation>.png` — scènes 1000×640 recomposées comme dans le jeu (parcelles + largeurs).

## Régénérer / corriger
- Prompts : `prompts_sprites/villes/prompts_v65/<nation>_<batiment>.txt` (norme V65 : 1 bâtiment/image,
  5 niveaux, iso 2:1, emprise fixe, fond uni).
- Découpe : `cd prototype/zimut && python3 tools/slice_city_sprites.py assets/ui/conquest/cities/batiments --v65 [--only <nation>]`
- Import + CI : `python3 tools/check_assets.py` (OK).
