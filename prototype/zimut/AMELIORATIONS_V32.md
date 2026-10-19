# V32 — Animations variées à partir des planches

- Toutes les poses d'action des planches sont extraites : `<sprite>_attack`, `_attack_2`…, `_cast`, `_cast_2`…, et les poses fixes
  `_idle_2`, `_idle_3` (héros : versions chibi dans `players/`, sources dans `nations/heros/poses/` ; boss : `nations/boss/`).
- **Attaque / incantation** : une variante au hasard, ou (6 fois sur 10 quand il y en a au moins 2) un enchaînement de 2 variantes
  dans un ordre aléatoire (élan → frappe, saut → tir…).
- **Marche** : alternance pose de marche / pose de repos à chaque pas (foulée).
- **Repos** : toutes les 4 à 8 s, passage d'1 à 2 s sur une autre pose fixe de la planche (léger changement d'attitude).
- Nombre de variantes d'attaque (héros) : Assassin 5, Artificier 3, Heal 3, Tank 2, Mage 2, Druide 2, autres 1.
  Boss : Ombres et Rouages 5, Sables 3, Brumes/Vents, Marées, Sylvestre 2. Cristaux et Cimes : pas de pose d'action exploitable sur leur planche.
- Sylvain et boss des Vents : variantes recolorées depuis les Brumes (provisoire).

Capture : `tests/shot_combo.gd`.
