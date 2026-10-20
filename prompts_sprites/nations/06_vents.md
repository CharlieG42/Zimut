# Nation Vents (Vents)

Palette : pale teal, silver, sky white, mint. Effets : wind ribbons and feathers. Contre-jour : pale sky white.

Chaque personnage est dessiné en **vue 3/4 avant (face)** et en **vue 3/4 arrière (dos)**. Le jeu retourne l'image pour les directions vers la gauche. Toutes les planches sont des grilles 4 × 2 aux cases bien séparées. Prompt négatif : voir en bas de page.

Ordre conseillé : 1) planche de référence, 2) héros, 3) ennemis, 4) boss.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos. Joins-la comme image de référence à toutes les planches suivantes.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Vents nation (Vents biome).
NATION PALETTE: pale teal, silver, sky white, mint. Signature effects: wind ribbons and feathers.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: two rows with the same 6 characters in the same order, all in idle pose. Top row: 3/4 front view, facing front-right. Bottom row: 3/4 back view, seen from behind, turned toward the upper right. All feet of a row on the same ground line. Leave a wide empty gap (at least half a character width) between characters and between the two rows: nobody overlaps or touches anyone, weapons and capes included. Image aspect ratio 2:1, as large as possible.
CHARACTERS, left to right:
1. the hero (Sylvain: nature-wind guardian with silver-teal hair, robe of pale teal layered leaves and feathers, silver bracers, a staff topped with a wing-shaped mint crystal in the right hand).
2. Garde aérien (sky guard in blue and silver armor with small wings on the helmet, holding a halberd).
3. Aigle céleste (large deep blue eagle with golden talons and spread wings).
4. Harpie (harpy with green and gold feathered wings for arms and bird legs).
5. Élémentaire de vent (swirling pale blue wind spirit with a round cloud body and small arms of wind).
6. the final boss Aéron le Céleste (celestial lord in pale cyan feathered armor with long flowing layers, crown of silver spikes, holding a tall silver staff with a wing crystal), about 1.5x taller than the others.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Sylvain — 32 poses

4 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/players/`.

#### Planche 1 — Face (3/4 avant) · Repos, marche et sorts

Dans l'Atelier : personnage « Sylvain », planche « Face (3/4 avant) · Repos, marche et sorts ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Sylvain, hero of the Vents nation. Nature-wind guardian with silver-teal hair, robe of pale teal layered leaves and feathers, silver bracers, a staff topped with a wing-shaped mint crystal in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. staff raised, wind ribbons and feathers orb forming at the top.
7. staff held high with both hands, wind ribbons and feathers swirling around.
8. staff pointed forward, releasing a compact wind ribbons and feathers blast.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `sylvain.png` |
| 1-2 | repos 2 | `sylvain_idle_2.png` |
| 1-3 | repos 3 | `sylvain_idle_3.png` |
| 1-4 | marche 1 | `sylvain_walk.png` |
| 2-1 | marche 2 | `sylvain_walk_2.png` |
| 2-2 | sort 1 | `sylvain_cast.png` |
| 2-3 | sort 2 | `sylvain_cast_2.png` |
| 2-4 | sort 3 | `sylvain_cast_3.png` |

#### Planche 2 — Face (3/4 avant) · Attaques

Dans l'Atelier : personnage « Sylvain », planche « Face (3/4 avant) · Attaques ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Sylvain, hero of the Vents nation. Nature-wind guardian with silver-teal hair, robe of pale teal layered leaves and feathers, silver bracers, a staff topped with a wing-shaped mint crystal in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. wind-up, staff held back with both hands.
2. staff swing forward, small wind ribbons and feathers burst at the tip.
3. follow-through, staff low, body turned.
4. thrust with the staff tip forward, short wind ribbons and feathers spark.
5. overhead staff strike, both hands high.
6. spinning the staff around the body, small wind ribbons and feathers trail.
7. low sweep with the staff at the feet.
8. staff planted, kicking forward with one leg.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `sylvain_attack.png` |
| 1-2 | attaque 2 | `sylvain_attack_2.png` |
| 1-3 | attaque 3 | `sylvain_attack_3.png` |
| 1-4 | attaque 4 | `sylvain_attack_4.png` |
| 2-1 | attaque 5 | `sylvain_attack_5.png` |
| 2-2 | attaque 6 | `sylvain_attack_6.png` |
| 2-3 | attaque 7 | `sylvain_attack_7.png` |
| 2-4 | attaque 8 | `sylvain_attack_8.png` |

#### Planche 3 — Dos (3/4 arrière) · Repos, marche et sorts

Dans l'Atelier : personnage « Sylvain », planche « Dos (3/4 arrière) · Repos, marche et sorts ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Sylvain, hero of the Vents nation. Nature-wind guardian with silver-teal hair, robe of pale teal layered leaves and feathers, silver bracers, a staff topped with a wing-shaped mint crystal in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. staff raised, wind ribbons and feathers orb forming at the top.
7. staff held high with both hands, wind ribbons and feathers swirling around.
8. staff pointed forward, releasing a compact wind ribbons and feathers blast.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `sylvain_back.png` |
| 1-2 | repos 2 | `sylvain_back_idle_2.png` |
| 1-3 | repos 3 | `sylvain_back_idle_3.png` |
| 1-4 | marche 1 | `sylvain_back_walk.png` |
| 2-1 | marche 2 | `sylvain_back_walk_2.png` |
| 2-2 | sort 1 | `sylvain_back_cast.png` |
| 2-3 | sort 2 | `sylvain_back_cast_2.png` |
| 2-4 | sort 3 | `sylvain_back_cast_3.png` |

#### Planche 4 — Dos (3/4 arrière) · Attaques

Dans l'Atelier : personnage « Sylvain », planche « Dos (3/4 arrière) · Attaques ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Sylvain, hero of the Vents nation. Nature-wind guardian with silver-teal hair, robe of pale teal layered leaves and feathers, silver bracers, a staff topped with a wing-shaped mint crystal in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. wind-up, staff held back with both hands.
2. staff swing forward, small wind ribbons and feathers burst at the tip.
3. follow-through, staff low, body turned.
4. thrust with the staff tip forward, short wind ribbons and feathers spark.
5. overhead staff strike, both hands high.
6. spinning the staff around the body, small wind ribbons and feathers trail.
7. low sweep with the staff at the feet.
8. staff planted, kicking forward with one leg.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `sylvain_back_attack.png` |
| 1-2 | attaque 2 | `sylvain_back_attack_2.png` |
| 1-3 | attaque 3 | `sylvain_back_attack_3.png` |
| 1-4 | attaque 4 | `sylvain_back_attack_4.png` |
| 2-1 | attaque 5 | `sylvain_back_attack_5.png` |
| 2-2 | attaque 6 | `sylvain_back_attack_6.png` |
| 2-3 | attaque 7 | `sylvain_back_attack_7.png` |
| 2-4 | attaque 8 | `sylvain_back_attack_8.png` |

L'export Zimut de l'Atelier copie aussi le repos vers `nations/heros/sylvain.png` et les autres poses vers `nations/heros/poses/`.

## 3. Ennemis

### Garde aérien — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/vents/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Garde aérien », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Garde aérien, enemy of the Vents nation. Sky guard in blue and silver armor with small wings on the helmet, holding a halberd.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. wind-up, staff held back with both hands.
5. staff swing forward, small wind ribbons and feathers burst at the tip.
6. follow-through, staff low, body turned.
7. thrust with the staff tip forward, short wind ribbons and feathers spark.
8. staff raised, wind ribbons and feathers orb forming at the top.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `garde_aerien.png` |
| 1-2 | repos 2 | `garde_aerien_idle_2.png` |
| 1-3 | marche 1 | `garde_aerien_walk.png` |
| 1-4 | attaque 1 | `garde_aerien_attack.png` |
| 2-1 | attaque 2 | `garde_aerien_attack_2.png` |
| 2-2 | attaque 3 | `garde_aerien_attack_3.png` |
| 2-3 | attaque 4 | `garde_aerien_attack_4.png` |
| 2-4 | sort 1 | `garde_aerien_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Garde aérien », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Garde aérien, enemy of the Vents nation. Sky guard in blue and silver armor with small wings on the helmet, holding a halberd.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. wind-up, staff held back with both hands.
5. staff swing forward, small wind ribbons and feathers burst at the tip.
6. follow-through, staff low, body turned.
7. thrust with the staff tip forward, short wind ribbons and feathers spark.
8. staff raised, wind ribbons and feathers orb forming at the top.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `garde_aerien_back.png` |
| 1-2 | repos 2 | `garde_aerien_back_idle_2.png` |
| 1-3 | marche 1 | `garde_aerien_back_walk.png` |
| 1-4 | attaque 1 | `garde_aerien_back_attack.png` |
| 2-1 | attaque 2 | `garde_aerien_back_attack_2.png` |
| 2-2 | attaque 3 | `garde_aerien_back_attack_3.png` |
| 2-3 | attaque 4 | `garde_aerien_back_attack_4.png` |
| 2-4 | sort 1 | `garde_aerien_back_cast.png` |

### Aigle céleste — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/vents/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Aigle céleste », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Aigle céleste, enemy of the Vents nation. Large deep blue eagle with golden talons and spread wings.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, ready to pounce.
5. lunge forward, jaws or claws first, small wind ribbons and feathers impact.
6. follow-through, landing after the lunge.
7. second strike, swiping sideways.
8. head raised, wind ribbons and feathers gathering around the body.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `aigle_celeste.png` |
| 1-2 | repos 2 | `aigle_celeste_idle_2.png` |
| 1-3 | marche 1 | `aigle_celeste_walk.png` |
| 1-4 | attaque 1 | `aigle_celeste_attack.png` |
| 2-1 | attaque 2 | `aigle_celeste_attack_2.png` |
| 2-2 | attaque 3 | `aigle_celeste_attack_3.png` |
| 2-3 | attaque 4 | `aigle_celeste_attack_4.png` |
| 2-4 | sort 1 | `aigle_celeste_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Aigle céleste », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Aigle céleste, enemy of the Vents nation. Large deep blue eagle with golden talons and spread wings.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, ready to pounce.
5. lunge forward, jaws or claws first, small wind ribbons and feathers impact.
6. follow-through, landing after the lunge.
7. second strike, swiping sideways.
8. head raised, wind ribbons and feathers gathering around the body.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `aigle_celeste_back.png` |
| 1-2 | repos 2 | `aigle_celeste_back_idle_2.png` |
| 1-3 | marche 1 | `aigle_celeste_back_walk.png` |
| 1-4 | attaque 1 | `aigle_celeste_back_attack.png` |
| 2-1 | attaque 2 | `aigle_celeste_back_attack_2.png` |
| 2-2 | attaque 3 | `aigle_celeste_back_attack_3.png` |
| 2-3 | attaque 4 | `aigle_celeste_back_attack_4.png` |
| 2-4 | sort 1 | `aigle_celeste_back_cast.png` |

### Harpie — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/vents/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Harpie », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Harpie, enemy of the Vents nation. Harpy with green and gold feathered wings for arms and bird legs.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. drawing back, body stretched upward.
5. lunging forward, claws of wind ribbons and feathers reaching out.
6. follow-through, body trailing behind.
7. spinning strike, wind ribbons and feathers whirl around the body.
8. hovering higher, wind ribbons and feathers orbs circling the body.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `harpie.png` |
| 1-2 | repos 2 | `harpie_idle_2.png` |
| 1-3 | marche 1 | `harpie_walk.png` |
| 1-4 | attaque 1 | `harpie_attack.png` |
| 2-1 | attaque 2 | `harpie_attack_2.png` |
| 2-2 | attaque 3 | `harpie_attack_3.png` |
| 2-3 | attaque 4 | `harpie_attack_4.png` |
| 2-4 | sort 1 | `harpie_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Harpie », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Harpie, enemy of the Vents nation. Harpy with green and gold feathered wings for arms and bird legs.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. drawing back, body stretched upward.
5. lunging forward, claws of wind ribbons and feathers reaching out.
6. follow-through, body trailing behind.
7. spinning strike, wind ribbons and feathers whirl around the body.
8. hovering higher, wind ribbons and feathers orbs circling the body.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `harpie_back.png` |
| 1-2 | repos 2 | `harpie_back_idle_2.png` |
| 1-3 | marche 1 | `harpie_back_walk.png` |
| 1-4 | attaque 1 | `harpie_back_attack.png` |
| 2-1 | attaque 2 | `harpie_back_attack_2.png` |
| 2-2 | attaque 3 | `harpie_back_attack_3.png` |
| 2-3 | attaque 4 | `harpie_back_attack_4.png` |
| 2-4 | sort 1 | `harpie_back_cast.png` |

### Élémentaire de vent — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/vents/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Élémentaire de vent », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Élémentaire de vent, enemy of the Vents nation. Swirling pale blue wind spirit with a round cloud body and small arms of wind.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. drawing back, body stretched upward.
5. lunging forward, claws of wind ribbons and feathers reaching out.
6. follow-through, body trailing behind.
7. spinning strike, wind ribbons and feathers whirl around the body.
8. hovering higher, wind ribbons and feathers orbs circling the body.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `elementaire_de_vent.png` |
| 1-2 | repos 2 | `elementaire_de_vent_idle_2.png` |
| 1-3 | marche 1 | `elementaire_de_vent_walk.png` |
| 1-4 | attaque 1 | `elementaire_de_vent_attack.png` |
| 2-1 | attaque 2 | `elementaire_de_vent_attack_2.png` |
| 2-2 | attaque 3 | `elementaire_de_vent_attack_3.png` |
| 2-3 | attaque 4 | `elementaire_de_vent_attack_4.png` |
| 2-4 | sort 1 | `elementaire_de_vent_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Élémentaire de vent », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Élémentaire de vent, enemy of the Vents nation. Swirling pale blue wind spirit with a round cloud body and small arms of wind.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. drawing back, body stretched upward.
5. lunging forward, claws of wind ribbons and feathers reaching out.
6. follow-through, body trailing behind.
7. spinning strike, wind ribbons and feathers whirl around the body.
8. hovering higher, wind ribbons and feathers orbs circling the body.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `elementaire_de_vent_back.png` |
| 1-2 | repos 2 | `elementaire_de_vent_back_idle_2.png` |
| 1-3 | marche 1 | `elementaire_de_vent_back_walk.png` |
| 1-4 | attaque 1 | `elementaire_de_vent_back_attack.png` |
| 2-1 | attaque 2 | `elementaire_de_vent_back_attack_2.png` |
| 2-2 | attaque 3 | `elementaire_de_vent_back_attack_3.png` |
| 2-3 | attaque 4 | `elementaire_de_vent_back_attack_4.png` |
| 2-4 | sort 1 | `elementaire_de_vent_back_cast.png` |

## 4. Boss

### Aéron le Céleste — 32 poses

4 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/`.

#### Planche 1 — Face (3/4 avant) · Repos, marche et sorts

Dans l'Atelier : personnage « Aéron le Céleste », planche « Face (3/4 avant) · Repos, marche et sorts ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Aéron le Céleste, boss of the Vents nation. Celestial lord in pale cyan feathered armor with long flowing layers, crown of silver spikes, holding a tall silver staff with a wing crystal, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. staff raised, wind ribbons and feathers orb forming at the top.
7. staff held high with both hands, wind ribbons and feathers swirling around.
8. staff pointed forward, releasing a compact wind ribbons and feathers blast.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `vents.png` |
| 1-2 | repos 2 | `vents_idle_2.png` |
| 1-3 | repos 3 | `vents_idle_3.png` |
| 1-4 | marche 1 | `vents_walk.png` |
| 2-1 | marche 2 | `vents_walk_2.png` |
| 2-2 | sort 1 | `vents_cast.png` |
| 2-3 | sort 2 | `vents_cast_2.png` |
| 2-4 | sort 3 | `vents_cast_3.png` |

#### Planche 2 — Face (3/4 avant) · Attaques

Dans l'Atelier : personnage « Aéron le Céleste », planche « Face (3/4 avant) · Attaques ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Aéron le Céleste, boss of the Vents nation. Celestial lord in pale cyan feathered armor with long flowing layers, crown of silver spikes, holding a tall silver staff with a wing crystal, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. wind-up, staff held back with both hands.
2. staff swing forward, small wind ribbons and feathers burst at the tip.
3. follow-through, staff low, body turned.
4. thrust with the staff tip forward, short wind ribbons and feathers spark.
5. overhead staff strike, both hands high.
6. spinning the staff around the body, small wind ribbons and feathers trail.
7. low sweep with the staff at the feet.
8. staff planted, kicking forward with one leg.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `vents_attack.png` |
| 1-2 | attaque 2 | `vents_attack_2.png` |
| 1-3 | attaque 3 | `vents_attack_3.png` |
| 1-4 | attaque 4 | `vents_attack_4.png` |
| 2-1 | attaque 5 | `vents_attack_5.png` |
| 2-2 | attaque 6 | `vents_attack_6.png` |
| 2-3 | attaque 7 | `vents_attack_7.png` |
| 2-4 | attaque 8 | `vents_attack_8.png` |

#### Planche 3 — Dos (3/4 arrière) · Repos, marche et sorts

Dans l'Atelier : personnage « Aéron le Céleste », planche « Dos (3/4 arrière) · Repos, marche et sorts ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Aéron le Céleste, boss of the Vents nation. Celestial lord in pale cyan feathered armor with long flowing layers, crown of silver spikes, holding a tall silver staff with a wing crystal, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. staff raised, wind ribbons and feathers orb forming at the top.
7. staff held high with both hands, wind ribbons and feathers swirling around.
8. staff pointed forward, releasing a compact wind ribbons and feathers blast.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `vents_back.png` |
| 1-2 | repos 2 | `vents_back_idle_2.png` |
| 1-3 | repos 3 | `vents_back_idle_3.png` |
| 1-4 | marche 1 | `vents_back_walk.png` |
| 2-1 | marche 2 | `vents_back_walk_2.png` |
| 2-2 | sort 1 | `vents_back_cast.png` |
| 2-3 | sort 2 | `vents_back_cast_2.png` |
| 2-4 | sort 3 | `vents_back_cast_3.png` |

#### Planche 4 — Dos (3/4 arrière) · Attaques

Dans l'Atelier : personnage « Aéron le Céleste », planche « Dos (3/4 arrière) · Attaques ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Aéron le Céleste, boss of the Vents nation. Celestial lord in pale cyan feathered armor with long flowing layers, crown of silver spikes, holding a tall silver staff with a wing crystal, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. wind-up, staff held back with both hands.
2. staff swing forward, small wind ribbons and feathers burst at the tip.
3. follow-through, staff low, body turned.
4. thrust with the staff tip forward, short wind ribbons and feathers spark.
5. overhead staff strike, both hands high.
6. spinning the staff around the body, small wind ribbons and feathers trail.
7. low sweep with the staff at the feet.
8. staff planted, kicking forward with one leg.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `vents_back_attack.png` |
| 1-2 | attaque 2 | `vents_back_attack_2.png` |
| 1-3 | attaque 3 | `vents_back_attack_3.png` |
| 1-4 | attaque 4 | `vents_back_attack_4.png` |
| 2-1 | attaque 5 | `vents_back_attack_5.png` |
| 2-2 | attaque 6 | `vents_back_attack_6.png` |
| 2-3 | attaque 7 | `vents_back_attack_7.png` |
| 2-4 | attaque 8 | `vents_back_attack_8.png` |

## Prompt négatif (toutes les planches de cette page)

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art
```
