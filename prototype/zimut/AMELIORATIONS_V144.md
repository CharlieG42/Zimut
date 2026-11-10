# V144 — Mode Tactique : fond de scène par nation, cases variées

Sans nouvel asset. Concerne les quatre nations existantes (Sylve, Brasier, Brumes, Cimes) ; les autres
gardent le fond d'origine.

## 1. Fond de scène par nation (`BackdropFx.gd`)

Avant, toutes les nations partageaient le même fond : un voile de teinte, des nuages blancs et des îlots
verts. Chaque nation a maintenant son ciel en dégradé, deux plans de relief au lointain, sa « mer » et ses
particules (`BackdropFx.SKY`) :

| Nation | Lointain | Bas de l'image | Particules |
|---|---|---|---|
| Sylve | collines boisées | eau | lucioles |
| Brasier | volcans au cratère rougeoyant, panaches | lave | braises |
| Brumes | marais et arbres morts | eau dormante | feux follets |
| Cimes | pics enneigés | mer de nuages | neige qui tombe |

Le ciel et les reliefs sont dessinés une seule fois (plan fixe `FondFixe`) ; seuls les nuages, les reflets
et les particules sont redessinés à chaque image, comme avant.

**Correctif** : le fond était créé avant que le biome du combat soit décidé et gardait celui du combat
précédent (des Brumes sur fond orange après un combat au Brasier). `GameManager.init_entities` lui redonne
le bon biome.

## 2. Cases (`Cell.gd`, `BattleScenery.tile_variant`, `tools/gen_nation_tiles.py`)

- **Tirage** : l'ancien `x*3 + y*5` faisait des diagonales régulières. Le tirage par hachage donne environ
  62 % de cases calmes, 27 % avec un détail, 11 % de cases « accident ».
- **Brasier** : le sol calme est de la cendre ; la fissure de lave, avant sur chaque case, devient la case
  « accident ».
- **Brumes** : mousse et brume allégées ; flaque sombre en case « accident ».
- **Cimes** : cases en **neige** (avant : roche grise avec la même congère partout), roche qui affleure,
  plaque de glace en case « accident ». Dessus des blocs de bordure et voile de teinte ajustés.
- **Sylve** : tuiles inchangées, seul le tirage change.
- La carte Aventure 2D en tuiles utilise le même tirage.

Les cases « accident » sont décoratives : aucun effet de jeu.

## Tests

`tests/test_v144_tactique.gd` (nouveau).
