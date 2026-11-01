# Découpe V65 — de la planche générée au sprite du jeu (8 nations restantes)

## 1. Générer les planches (Mistral / Le Chat)
Un prompt par bâtiment, depuis `nations_v65.md` (cartes d'identité par nation + gabarit commun) :

```
planches/<nation>/<batiment>.png      ex. planches/sables/hall.png
```

- 10 images par nation : `hall, caserne, residence, scierie, mine, tannerie, cabane, verger, muraille` (5 niveaux en ligne) + `merveille` (1 case).
- Fond uni : **blanc pur**, sauf **Marées et Vents → vert chroma `#00B140`**.
- Caméra iso 2:1 identique dans les 5 cases, même losange de socle, même emprise (3×3 hall/mine/verger/muraille/merveille, 2×2 les autres).
- Sans ombre au sol, sans halo, sans reflets, sans personnages.

## 2. Découper

```bash
cd prototype/zimut
python3 tools/slice_city_sprites.py assets/ui/conquest/cities/batiments --v65            # les 8 nations
python3 tools/slice_city_sprites.py assets/ui/conquest/cities/batiments --v65 --only sables   # une seule
```

Produit `batiments/<nation>/<batiment>_<1..5>.png` (et `merveille.png`) : détourage du fond,
découpe en 5 cases égales, toile commune par bâtiment (pied centré en bas → les niveaux gardent
leur taille relative), largeur normalisée (`TARGET_W`).

## 3. Intégrer au dépôt

```bash
godot --headless --import --path prototype/zimut     # génère les .png.import
cd prototype/zimut && python3 tools/check_assets.py  # doit finir par OK
```

Committer PNG + `.png.import` ensemble (la CI vérifie la paire).

## 4. Vérifier dans le jeu
- `tests/test_ville_sprites.gd` (chemins + repli) et capture `tests/shot_ville_iso.gd`.
- Le jeu charge automatiquement `batiments/<nation>/…` en priorité, avec repli de niveau
  (`_sprite_best`) puis vectoriel : **aucun code à changer**.

## Check-list par nation (à cocher)
- [ ] 10 planches générées (9 à 5 niveaux + merveille), fond conforme (blanc / chroma #00B140 pour marees, vents)
- [ ] esprit de la nation respecté (palette + détails de la carte d'identité)
- [ ] 5 cases bien remplies, même socle, même caméra, tailles croissantes lisibles
- [ ] découpe lancée, 46 PNG produits (9×5 + merveille)
- [ ] `.png.import` générés + `check_assets.py` OK
- [ ] capture `shot_ville_iso.gd` validée visuellement
