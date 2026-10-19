# V31 — Planches d'animation des héros et des boss (détourage automatique provisoire)

Les planches JPEG (damier peint, sans transparence) sont dans `assets/sprites/_sheets/v31/` et découpées par
`tools/cut_sheets_v31.py` (suppression du damier depuis les bords + trous à damier, liseré adouci, regroupement des poses).

## Héros (9 planches + Tank)
- Repos (`players/<classe>.png`) et **4 poses** : `_back` (de dos), `_walk` (marche), `_attack`, `_cast` — sources pleine taille
  dans `nations/heros/` et `nations/heros/poses/`, versions « chibi » produites par `tools/chibify_heroes.py --all-poses`.
- L'outil chibi repère maintenant la tête au-dessus du corps (les bâtons dépassent souvent) et déforme plus doucement les poses d'action.
- **Sylvain (Vents)** : provisoire — planche de l'Invocateur (Brumes) recolorée en tons de vent (`tools/windify_v31.py`).

## Boss des Nations
Repos + dos / attaque / incantation quand la planche les sépare bien (`nations/boss/<nation>[_pose].png`) :
Sylvestre, Cimes, Sables, Cristaux, Marées, Brasier, Brumes, Ombres, Rouages ; **Vents** : boss des Brumes recoloré (provisoire).

## Terrain du Géomancien
Pilier (colonne de grès), Muraille (porte de grès) et Cristal ambré (obélisque) tirés des planches du Géomancien et du boss des Sables.

## En combat
- Le personnage **se montre de dos** quand il regarde vers le haut du plateau, passe en **pose de marche** en se déplaçant,
  en **pose d'attaque** (corps à corps et tirs) ou **d'incantation** pendant ses sorts ; la taille reste celle de la pose de repos.
- Portraits (timeline, panneau) centrés sur le visage même quand un bâton dépasse au-dessus de la tête.
