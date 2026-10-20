# Familiers (invocations)

Fichiers dans `prototype/zimut/assets/sprites/summons/`. Deux planches par familier : vue 3/4 avant (face) et vue 3/4 arrière (dos). Joins la planche du héros qui l'invoque comme référence de style.

### Golem de pierre (Invocateur, ex-Tortue) — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/summons/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Golem de pierre », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Golem de pierre, a summon. Grey stone golem with blue crystals growing from the shoulders and back.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. wind-up, fist or weapon raised high.
5. heavy smash forward, ground cracking with a small matching magical sparks burst.
6. follow-through, body leaning forward.
7. sweeping backhand blow.
8. stomping, matching magical sparks cracks spreading under the feet.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `golem_de_pierre.png` |
| 1-2 | repos 2 | `golem_de_pierre_idle_2.png` |
| 1-3 | marche 1 | `golem_de_pierre_walk.png` |
| 1-4 | attaque 1 | `golem_de_pierre_attack.png` |
| 2-1 | attaque 2 | `golem_de_pierre_attack_2.png` |
| 2-2 | attaque 3 | `golem_de_pierre_attack_3.png` |
| 2-3 | attaque 4 | `golem_de_pierre_attack_4.png` |
| 2-4 | sort 1 | `golem_de_pierre_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Golem de pierre », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Golem de pierre, a summon. Grey stone golem with blue crystals growing from the shoulders and back.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. wind-up, fist or weapon raised high.
5. heavy smash forward, ground cracking with a small matching magical sparks burst.
6. follow-through, body leaning forward.
7. sweeping backhand blow.
8. stomping, matching magical sparks cracks spreading under the feet.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `golem_de_pierre_back.png` |
| 1-2 | repos 2 | `golem_de_pierre_back_idle_2.png` |
| 1-3 | marche 1 | `golem_de_pierre_back_walk.png` |
| 1-4 | attaque 1 | `golem_de_pierre_back_attack.png` |
| 2-1 | attaque 2 | `golem_de_pierre_back_attack_2.png` |
| 2-2 | attaque 3 | `golem_de_pierre_back_attack_3.png` |
| 2-3 | attaque 4 | `golem_de_pierre_back_attack_4.png` |
| 2-4 | sort 1 | `golem_de_pierre_back_cast.png` |

### Loup spectral (Invocateur) — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/summons/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Loup spectral », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Loup spectral, a summon. Spectral violet wolf with flame-like spiky fur and glowing eyes.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, ready to pounce.
5. lunge forward, jaws or claws first, small matching magical sparks impact.
6. follow-through, landing after the lunge.
7. second strike, swiping sideways.
8. head raised, matching magical sparks gathering around the body.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `loup_spectral.png` |
| 1-2 | repos 2 | `loup_spectral_idle_2.png` |
| 1-3 | marche 1 | `loup_spectral_walk.png` |
| 1-4 | attaque 1 | `loup_spectral_attack.png` |
| 2-1 | attaque 2 | `loup_spectral_attack_2.png` |
| 2-2 | attaque 3 | `loup_spectral_attack_3.png` |
| 2-3 | attaque 4 | `loup_spectral_attack_4.png` |
| 2-4 | sort 1 | `loup_spectral_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Loup spectral », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Loup spectral, a summon. Spectral violet wolf with flame-like spiky fur and glowing eyes.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, ready to pounce.
5. lunge forward, jaws or claws first, small matching magical sparks impact.
6. follow-through, landing after the lunge.
7. second strike, swiping sideways.
8. head raised, matching magical sparks gathering around the body.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `loup_spectral_back.png` |
| 1-2 | repos 2 | `loup_spectral_back_idle_2.png` |
| 1-3 | marche 1 | `loup_spectral_back_walk.png` |
| 1-4 | attaque 1 | `loup_spectral_back_attack.png` |
| 2-1 | attaque 2 | `loup_spectral_back_attack_2.png` |
| 2-2 | attaque 3 | `loup_spectral_back_attack_3.png` |
| 2-3 | attaque 4 | `loup_spectral_back_attack_4.png` |
| 2-4 | sort 1 | `loup_spectral_back_cast.png` |

### Requin des marées (Invocateur, ex-Sirène) — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/summons/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Requin des marées », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Requin des marées, a summon. Bright blue shark with a white belly floating upright, fins like small arms.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, ready to pounce.
5. lunge forward, jaws or claws first, small matching magical sparks impact.
6. follow-through, landing after the lunge.
7. second strike, swiping sideways.
8. head raised, matching magical sparks gathering around the body.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `requin_des_marees.png` |
| 1-2 | repos 2 | `requin_des_marees_idle_2.png` |
| 1-3 | marche 1 | `requin_des_marees_walk.png` |
| 1-4 | attaque 1 | `requin_des_marees_attack.png` |
| 2-1 | attaque 2 | `requin_des_marees_attack_2.png` |
| 2-2 | attaque 3 | `requin_des_marees_attack_3.png` |
| 2-3 | attaque 4 | `requin_des_marees_attack_4.png` |
| 2-4 | sort 1 | `requin_des_marees_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Requin des marées », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Requin des marées, a summon. Bright blue shark with a white belly floating upright, fins like small arms.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, ready to pounce.
5. lunge forward, jaws or claws first, small matching magical sparks impact.
6. follow-through, landing after the lunge.
7. second strike, swiping sideways.
8. head raised, matching magical sparks gathering around the body.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `requin_des_marees_back.png` |
| 1-2 | repos 2 | `requin_des_marees_back_idle_2.png` |
| 1-3 | marche 1 | `requin_des_marees_back_walk.png` |
| 1-4 | attaque 1 | `requin_des_marees_back_attack.png` |
| 2-1 | attaque 2 | `requin_des_marees_back_attack_2.png` |
| 2-2 | attaque 3 | `requin_des_marees_back_attack_3.png` |
| 2-3 | attaque 4 | `requin_des_marees_back_attack_4.png` |
| 2-4 | sort 1 | `requin_des_marees_back_cast.png` |

### Élémentaire de cristal (Invocateur, ex-Ange) — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/summons/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Élémentaire de cristal », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Élémentaire de cristal, a summon. Small elemental made of violet and blue crystals, friendly glowing eyes.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. drawing back, body stretched upward.
5. lunging forward, claws of matching magical sparks reaching out.
6. follow-through, body trailing behind.
7. spinning strike, matching magical sparks whirl around the body.
8. hovering higher, matching magical sparks orbs circling the body.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `elementaire_de_cristal.png` |
| 1-2 | repos 2 | `elementaire_de_cristal_idle_2.png` |
| 1-3 | marche 1 | `elementaire_de_cristal_walk.png` |
| 1-4 | attaque 1 | `elementaire_de_cristal_attack.png` |
| 2-1 | attaque 2 | `elementaire_de_cristal_attack_2.png` |
| 2-2 | attaque 3 | `elementaire_de_cristal_attack_3.png` |
| 2-3 | attaque 4 | `elementaire_de_cristal_attack_4.png` |
| 2-4 | sort 1 | `elementaire_de_cristal_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Élémentaire de cristal », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Élémentaire de cristal, a summon. Small elemental made of violet and blue crystals, friendly glowing eyes.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. drawing back, body stretched upward.
5. lunging forward, claws of matching magical sparks reaching out.
6. follow-through, body trailing behind.
7. spinning strike, matching magical sparks whirl around the body.
8. hovering higher, matching magical sparks orbs circling the body.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `elementaire_de_cristal_back.png` |
| 1-2 | repos 2 | `elementaire_de_cristal_back_idle_2.png` |
| 1-3 | marche 1 | `elementaire_de_cristal_back_walk.png` |
| 1-4 | attaque 1 | `elementaire_de_cristal_back_attack.png` |
| 2-1 | attaque 2 | `elementaire_de_cristal_back_attack_2.png` |
| 2-2 | attaque 3 | `elementaire_de_cristal_back_attack_3.png` |
| 2-3 | attaque 4 | `elementaire_de_cristal_back_attack_4.png` |
| 2-4 | sort 1 | `elementaire_de_cristal_back_cast.png` |

### Ombre (Invocateur, ex-Homme-Faucon) — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/summons/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Ombre », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Ombre, a summon. Coiled purple shadow serpent with a dragon-like head, stylized opaque smoke curls.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. drawing back, body stretched upward.
5. lunging forward, claws of matching magical sparks reaching out.
6. follow-through, body trailing behind.
7. spinning strike, matching magical sparks whirl around the body.
8. hovering higher, matching magical sparks orbs circling the body.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `ombre.png` |
| 1-2 | repos 2 | `ombre_idle_2.png` |
| 1-3 | marche 1 | `ombre_walk.png` |
| 1-4 | attaque 1 | `ombre_attack.png` |
| 2-1 | attaque 2 | `ombre_attack_2.png` |
| 2-2 | attaque 3 | `ombre_attack_3.png` |
| 2-3 | attaque 4 | `ombre_attack_4.png` |
| 2-4 | sort 1 | `ombre_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Ombre », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Ombre, a summon. Coiled purple shadow serpent with a dragon-like head, stylized opaque smoke curls.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. drawing back, body stretched upward.
5. lunging forward, claws of matching magical sparks reaching out.
6. follow-through, body trailing behind.
7. spinning strike, matching magical sparks whirl around the body.
8. hovering higher, matching magical sparks orbs circling the body.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `ombre_back.png` |
| 1-2 | repos 2 | `ombre_back_idle_2.png` |
| 1-3 | marche 1 | `ombre_back_walk.png` |
| 1-4 | attaque 1 | `ombre_back_attack.png` |
| 2-1 | attaque 2 | `ombre_back_attack_2.png` |
| 2-2 | attaque 3 | `ombre_back_attack_3.png` |
| 2-3 | attaque 4 | `ombre_back_attack_4.png` |
| 2-4 | sort 1 | `ombre_back_cast.png` |

### Esprit de la forêt (Invocateur, ex-Centaure) — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/summons/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Esprit de la forêt », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Esprit de la forêt, a summon. Forest stag spirit with a body of leaves and moss and large branching antlers.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, ready to pounce.
5. lunge forward, jaws or claws first, small matching magical sparks impact.
6. follow-through, landing after the lunge.
7. second strike, swiping sideways.
8. head raised, matching magical sparks gathering around the body.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `esprit_de_la_foret.png` |
| 1-2 | repos 2 | `esprit_de_la_foret_idle_2.png` |
| 1-3 | marche 1 | `esprit_de_la_foret_walk.png` |
| 1-4 | attaque 1 | `esprit_de_la_foret_attack.png` |
| 2-1 | attaque 2 | `esprit_de_la_foret_attack_2.png` |
| 2-2 | attaque 3 | `esprit_de_la_foret_attack_3.png` |
| 2-3 | attaque 4 | `esprit_de_la_foret_attack_4.png` |
| 2-4 | sort 1 | `esprit_de_la_foret_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Esprit de la forêt », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Esprit de la forêt, a summon. Forest stag spirit with a body of leaves and moss and large branching antlers.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, ready to pounce.
5. lunge forward, jaws or claws first, small matching magical sparks impact.
6. follow-through, landing after the lunge.
7. second strike, swiping sideways.
8. head raised, matching magical sparks gathering around the body.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `esprit_de_la_foret_back.png` |
| 1-2 | repos 2 | `esprit_de_la_foret_back_idle_2.png` |
| 1-3 | marche 1 | `esprit_de_la_foret_back_walk.png` |
| 1-4 | attaque 1 | `esprit_de_la_foret_back_attack.png` |
| 2-1 | attaque 2 | `esprit_de_la_foret_back_attack_2.png` |
| 2-2 | attaque 3 | `esprit_de_la_foret_back_attack_3.png` |
| 2-3 | attaque 4 | `esprit_de_la_foret_back_attack_4.png` |
| 2-4 | sort 1 | `esprit_de_la_foret_back_cast.png` |

### Archer sylvestre (Sylvain) — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/summons/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Archer sylvestre », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Archer sylvestre, a summon. Slim wooden archer made of branches and leaves, carrying a wooden bow.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. drawing the bow, arrow nocked, string pulled to the cheek.
5. release, arrow flying forward with a short matching magical sparks trail.
6. follow-through, bow arm extended, string hand open behind.
7. quick shot from a low crouch, bow tilted.
8. arrow raised to the sky, matching magical sparks gathering on the arrowhead.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `archer_sylvestre.png` |
| 1-2 | repos 2 | `archer_sylvestre_idle_2.png` |
| 1-3 | marche 1 | `archer_sylvestre_walk.png` |
| 1-4 | attaque 1 | `archer_sylvestre_attack.png` |
| 2-1 | attaque 2 | `archer_sylvestre_attack_2.png` |
| 2-2 | attaque 3 | `archer_sylvestre_attack_3.png` |
| 2-3 | attaque 4 | `archer_sylvestre_attack_4.png` |
| 2-4 | sort 1 | `archer_sylvestre_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Archer sylvestre », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Archer sylvestre, a summon. Slim wooden archer made of branches and leaves, carrying a wooden bow.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. drawing the bow, arrow nocked, string pulled to the cheek.
5. release, arrow flying forward with a short matching magical sparks trail.
6. follow-through, bow arm extended, string hand open behind.
7. quick shot from a low crouch, bow tilted.
8. arrow raised to the sky, matching magical sparks gathering on the arrowhead.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `archer_sylvestre_back.png` |
| 1-2 | repos 2 | `archer_sylvestre_back_idle_2.png` |
| 1-3 | marche 1 | `archer_sylvestre_back_walk.png` |
| 1-4 | attaque 1 | `archer_sylvestre_back_attack.png` |
| 2-1 | attaque 2 | `archer_sylvestre_back_attack_2.png` |
| 2-2 | attaque 3 | `archer_sylvestre_back_attack_3.png` |
| 2-3 | attaque 4 | `archer_sylvestre_back_attack_4.png` |
| 2-4 | sort 1 | `archer_sylvestre_back_cast.png` |

### Ent de combat (Sylvain) — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/summons/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Ent de combat », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Ent de combat, a summon. Small wooden ent warrior covered in leaves, stubby branch arms.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. wind-up, fist or weapon raised high.
5. heavy smash forward, ground cracking with a small matching magical sparks burst.
6. follow-through, body leaning forward.
7. sweeping backhand blow.
8. stomping, matching magical sparks cracks spreading under the feet.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `ent_de_combat.png` |
| 1-2 | repos 2 | `ent_de_combat_idle_2.png` |
| 1-3 | marche 1 | `ent_de_combat_walk.png` |
| 1-4 | attaque 1 | `ent_de_combat_attack.png` |
| 2-1 | attaque 2 | `ent_de_combat_attack_2.png` |
| 2-2 | attaque 3 | `ent_de_combat_attack_3.png` |
| 2-3 | attaque 4 | `ent_de_combat_attack_4.png` |
| 2-4 | sort 1 | `ent_de_combat_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Ent de combat », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Ent de combat, a summon. Small wooden ent warrior covered in leaves, stubby branch arms.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. wind-up, fist or weapon raised high.
5. heavy smash forward, ground cracking with a small matching magical sparks burst.
6. follow-through, body leaning forward.
7. sweeping backhand blow.
8. stomping, matching magical sparks cracks spreading under the feet.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `ent_de_combat_back.png` |
| 1-2 | repos 2 | `ent_de_combat_back_idle_2.png` |
| 1-3 | marche 1 | `ent_de_combat_back_walk.png` |
| 1-4 | attaque 1 | `ent_de_combat_back_attack.png` |
| 2-1 | attaque 2 | `ent_de_combat_back_attack_2.png` |
| 2-2 | attaque 3 | `ent_de_combat_back_attack_3.png` |
| 2-3 | attaque 4 | `ent_de_combat_back_attack_4.png` |
| 2-4 | sort 1 | `ent_de_combat_back_cast.png` |

### Tronc (Sylvain) — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/summons/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Tronc », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Tronc, a summon. Cute walking tree stump with a round leafy crown, big eyes and branch arms.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. wind-up, fist or weapon raised high.
5. heavy smash forward, ground cracking with a small matching magical sparks burst.
6. follow-through, body leaning forward.
7. sweeping backhand blow.
8. stomping, matching magical sparks cracks spreading under the feet.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `tronc.png` |
| 1-2 | repos 2 | `tronc_idle_2.png` |
| 1-3 | marche 1 | `tronc_walk.png` |
| 1-4 | attaque 1 | `tronc_attack.png` |
| 2-1 | attaque 2 | `tronc_attack_2.png` |
| 2-2 | attaque 3 | `tronc_attack_3.png` |
| 2-3 | attaque 4 | `tronc_attack_4.png` |
| 2-4 | sort 1 | `tronc_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Tronc », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Tronc, a summon. Cute walking tree stump with a round leafy crown, big eyes and branch arms.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. wind-up, fist or weapon raised high.
5. heavy smash forward, ground cracking with a small matching magical sparks burst.
6. follow-through, body leaning forward.
7. sweeping backhand blow.
8. stomping, matching magical sparks cracks spreading under the feet.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `tronc_back.png` |
| 1-2 | repos 2 | `tronc_back_idle_2.png` |
| 1-3 | marche 1 | `tronc_back_walk.png` |
| 1-4 | attaque 1 | `tronc_back_attack.png` |
| 2-1 | attaque 2 | `tronc_back_attack_2.png` |
| 2-2 | attaque 3 | `tronc_back_attack_3.png` |
| 2-3 | attaque 4 | `tronc_back_attack_4.png` |
| 2-4 | sort 1 | `tronc_back_cast.png` |

### Sarriette (Sylvain) — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/summons/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Sarriette », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Sarriette, a summon. Tiny leaf sprite girl in a green leaf hood with little horns and a curly vine.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. wind-up, staff held back with both hands.
5. staff swing forward, small matching magical sparks burst at the tip.
6. follow-through, staff low, body turned.
7. thrust with the staff tip forward, short matching magical sparks spark.
8. staff raised, matching magical sparks orb forming at the top.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `sarriette.png` |
| 1-2 | repos 2 | `sarriette_idle_2.png` |
| 1-3 | marche 1 | `sarriette_walk.png` |
| 1-4 | attaque 1 | `sarriette_attack.png` |
| 2-1 | attaque 2 | `sarriette_attack_2.png` |
| 2-2 | attaque 3 | `sarriette_attack_3.png` |
| 2-3 | attaque 4 | `sarriette_attack_4.png` |
| 2-4 | sort 1 | `sarriette_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Sarriette », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Sarriette, a summon. Tiny leaf sprite girl in a green leaf hood with little horns and a curly vine.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. wind-up, staff held back with both hands.
5. staff swing forward, small matching magical sparks burst at the tip.
6. follow-through, staff low, body turned.
7. thrust with the staff tip forward, short matching magical sparks spark.
8. staff raised, matching magical sparks orb forming at the top.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `sarriette_back.png` |
| 1-2 | repos 2 | `sarriette_back_idle_2.png` |
| 1-3 | marche 1 | `sarriette_back_walk.png` |
| 1-4 | attaque 1 | `sarriette_back_attack.png` |
| 2-1 | attaque 2 | `sarriette_back_attack_2.png` |
| 2-2 | attaque 3 | `sarriette_back_attack_3.png` |
| 2-3 | attaque 4 | `sarriette_back_attack_4.png` |
| 2-4 | sort 1 | `sarriette_back_cast.png` |

### Ronce agressive (Sylvain) — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/summons/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Ronce agressive », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Ronce agressive, a summon. Angry bramble bulb covered in thorns with red eyes and whipping vines.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. drawing back, body stretched upward.
5. lunging forward, claws of matching magical sparks reaching out.
6. follow-through, body trailing behind.
7. spinning strike, matching magical sparks whirl around the body.
8. hovering higher, matching magical sparks orbs circling the body.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `ronce_agressive.png` |
| 1-2 | repos 2 | `ronce_agressive_idle_2.png` |
| 1-3 | marche 1 | `ronce_agressive_walk.png` |
| 1-4 | attaque 1 | `ronce_agressive_attack.png` |
| 2-1 | attaque 2 | `ronce_agressive_attack_2.png` |
| 2-2 | attaque 3 | `ronce_agressive_attack_3.png` |
| 2-3 | attaque 4 | `ronce_agressive_attack_4.png` |
| 2-4 | sort 1 | `ronce_agressive_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Ronce agressive », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Ronce agressive, a summon. Angry bramble bulb covered in thorns with red eyes and whipping vines.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. drawing back, body stretched upward.
5. lunging forward, claws of matching magical sparks reaching out.
6. follow-through, body trailing behind.
7. spinning strike, matching magical sparks whirl around the body.
8. hovering higher, matching magical sparks orbs circling the body.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `ronce_agressive_back.png` |
| 1-2 | repos 2 | `ronce_agressive_back_idle_2.png` |
| 1-3 | marche 1 | `ronce_agressive_back_walk.png` |
| 1-4 | attaque 1 | `ronce_agressive_back_attack.png` |
| 2-1 | attaque 2 | `ronce_agressive_back_attack_2.png` |
| 2-2 | attaque 3 | `ronce_agressive_back_attack_3.png` |
| 2-3 | attaque 4 | `ronce_agressive_back_attack_4.png` |
| 2-4 | sort 1 | `ronce_agressive_back_cast.png` |

### Sentinelle de grès (pas encore utilisée) — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/summons/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Sentinelle de grès », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Sentinelle de grès, a summon. Sandstone sentinel statue with amber eyes and carved armor.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. wind-up, fist or weapon raised high.
5. heavy smash forward, ground cracking with a small matching magical sparks burst.
6. follow-through, body leaning forward.
7. sweeping backhand blow.
8. stomping, matching magical sparks cracks spreading under the feet.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `sentinelle_de_gres.png` |
| 1-2 | repos 2 | `sentinelle_de_gres_idle_2.png` |
| 1-3 | marche 1 | `sentinelle_de_gres_walk.png` |
| 1-4 | attaque 1 | `sentinelle_de_gres_attack.png` |
| 2-1 | attaque 2 | `sentinelle_de_gres_attack_2.png` |
| 2-2 | attaque 3 | `sentinelle_de_gres_attack_3.png` |
| 2-3 | attaque 4 | `sentinelle_de_gres_attack_4.png` |
| 2-4 | sort 1 | `sentinelle_de_gres_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Sentinelle de grès », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Sentinelle de grès, a summon. Sandstone sentinel statue with amber eyes and carved armor.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. wind-up, fist or weapon raised high.
5. heavy smash forward, ground cracking with a small matching magical sparks burst.
6. follow-through, body leaning forward.
7. sweeping backhand blow.
8. stomping, matching magical sparks cracks spreading under the feet.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `sentinelle_de_gres_back.png` |
| 1-2 | repos 2 | `sentinelle_de_gres_back_idle_2.png` |
| 1-3 | marche 1 | `sentinelle_de_gres_back_walk.png` |
| 1-4 | attaque 1 | `sentinelle_de_gres_back_attack.png` |
| 2-1 | attaque 2 | `sentinelle_de_gres_back_attack_2.png` |
| 2-2 | attaque 3 | `sentinelle_de_gres_back_attack_3.png` |
| 2-3 | attaque 4 | `sentinelle_de_gres_back_attack_4.png` |
| 2-4 | sort 1 | `sentinelle_de_gres_back_cast.png` |

## Prompt négatif

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art
```
