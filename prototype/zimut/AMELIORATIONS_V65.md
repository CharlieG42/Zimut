# V65 — Ville de Conquête : premiers sprites isométriques

- La vue de ville (`ConquestCityView`) utilise désormais les planches isométriques de la Forêt (`sylvestre`) et de la
  Montagne (`cimes`) : hôtel de ville, caserne, résidence, six bâtiments de production et, pour la Forêt, l'arbre-Merveille et la muraille.
- **Repli de niveau** (`_sprite_best`) : sans fichier pour le niveau demandé, le dessin du niveau inférieur le plus proche est utilisé ;
  les nations sans planche gardent le dessin vectoriel.
- **Outil** `tools/slice_city_sprites.py` : détourage (fonds blanc et gris), découpe, toile commune par bâtiment, taille normalisée.
  `MANIFEST` = quelle partie de quelle planche devient quel fichier.
- Largeurs d'affichage ajustées (`SPRITE_WIDTH`) pour que les nouveaux dessins ne se chevauchent pas.
- Test : `test_ville_sprites` étendu (planches livrées, repli de niveau, nation sans planche) ; capture `tests/shot_ville_iso.gd`.
- Les bâtiments, niveaux, coûts et bonus existaient déjà (V61) : aucune règle de jeu modifiée.
