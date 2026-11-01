# Planches brutes V65 (sources, jamais chargées par le jeu)

`planches/<nation>/<batiment>.png` = image générée telle quelle (1 bâtiment, 5 niveaux en ligne,
iso 2:1, fond uni blanc ou chroma `#00B140` pour `marees` et `vents`).

Découpe en sprites du jeu :

```bash
cd prototype/zimut
python3 tools/slice_city_sprites.py assets/ui/conquest/cities/batiments --v65
```

Nations à livrer : `sables`, `cristaux`, `marees`, `vents`, `brasier`, `brumes`, `ombres`, `rouages`
(déjà livrées : `sylvestre`, `cimes`). Prompts prêts à l'emploi : `prompts_sprites/villes/prompts_v65/`.
