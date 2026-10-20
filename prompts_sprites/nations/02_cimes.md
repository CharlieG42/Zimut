# Nation Cimes (Montagne)

Palette : steel blue, dark iron, snow white fur, ice cyan crystals. Effets : ice shards and snow bursts. Contre-jour : cold icy blue.

Chaque personnage est dessiné en **vue 3/4 avant (face)** et en **vue 3/4 arrière (dos)**. Le jeu retourne l'image pour les directions vers la gauche. Toutes les planches sont des grilles 4 × 2 aux cases bien séparées. Prompt négatif : voir en bas de page.

Ordre conseillé : 1) planche de référence, 2) héros, 3) ennemis, 4) boss.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos. Joins-la comme image de référence à toutes les planches suivantes.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Cimes nation (Montagne biome).
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals. Signature effects: ice shards and snow bursts.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: two rows with the same 6 characters in the same order, all in idle pose. Top row: 3/4 front view, facing front-right. Bottom row: 3/4 back view, seen from behind, turned toward the upper right. All feet of a row on the same ground line. Leave a wide empty gap (at least half a character width) between characters and between the two rows: nobody overlaps or touches anyone, weapons and capes included. Image aspect ratio 2:1, as large as possible.
CHARACTERS, left to right:
1. the hero (Tank: stout veteran warrior with a big white beard and white hair, heavy dark steel-blue plate armor with white fur trim and ice-blue crystal inlays, a large round shield with a cloud and mountain emblem on the left arm, a rune-engraved war hammer in the right hand).
2. Guerrier des monts (mountain warrior with rocky brown skin, stocky body, crude stone gauntlets).
3. Griffon des cimes (griffin with a white eagle head, blue-grey feathered wings and a lion body).
4. Garde des pics (peak guardian golem of blue-grey stone with glowing ice-blue crystals on the shoulders).
5. Rochebrute (hulking brute made of brown boulders, small glowing eyes, huge fists).
6. the final boss Vorkann le Givre (massive frost knight in dark steel armor covered with ice crystals and snow fur, crowned helm of ice spikes, huge crystal-studded tower shield and a heavy rune hammer), about 1.5x taller than the others.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Tank — 32 poses

4 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/players/`.

#### Planche 1 — Face (3/4 avant) · Repos, marche et sorts

Dans l'Atelier : personnage « Tank », planche « Face (3/4 avant) · Repos, marche et sorts ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Tank, hero of the Cimes nation. Stout veteran warrior with a big white beard and white hair, heavy dark steel-blue plate armor with white fur trim and ice-blue crystal inlays, a large round shield with a cloud and mountain emblem on the left arm, a rune-engraved war hammer in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. bracing, shield planted on the ground, ice shards and snow bursts gathering around.
7. war cry, hammer raised to the sky, ice shards and snow bursts swirling around the body.
8. releasing a ring of ice shards and snow bursts around the feet.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `tank.png` |
| 1-2 | repos 2 | `tank_idle_2.png` |
| 1-3 | repos 3 | `tank_idle_3.png` |
| 1-4 | marche 1 | `tank_walk.png` |
| 2-1 | marche 2 | `tank_walk_2.png` |
| 2-2 | sort 1 | `tank_cast.png` |
| 2-3 | sort 2 | `tank_cast_2.png` |
| 2-4 | sort 3 | `tank_cast_3.png` |

#### Planche 2 — Face (3/4 avant) · Attaques

Dans l'Atelier : personnage « Tank », planche « Face (3/4 avant) · Attaques ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Tank, hero of the Cimes nation. Stout veteran warrior with a big white beard and white hair, heavy dark steel-blue plate armor with white fur trim and ice-blue crystal inlays, a large round shield with a cloud and mountain emblem on the left arm, a rune-engraved war hammer in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. wind-up, hammer raised high behind the head, shield forward.
2. overhead strike, hammer slamming down in front, small ice shards and snow bursts impact at the hammer head.
3. follow-through, hammer low, body leaning forward.
4. shield bash, shield thrust forward, hammer pulled back.
5. horizontal swing, hammer sweeping at waist height, body twisted.
6. rising uppercut with the hammer, one foot lifted.
7. spinning attack, hammer held out to the side, small ice shards and snow bursts whirl.
8. jumping slam, both feet off the ground, hammer above the head.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `tank_attack.png` |
| 1-2 | attaque 2 | `tank_attack_2.png` |
| 1-3 | attaque 3 | `tank_attack_3.png` |
| 1-4 | attaque 4 | `tank_attack_4.png` |
| 2-1 | attaque 5 | `tank_attack_5.png` |
| 2-2 | attaque 6 | `tank_attack_6.png` |
| 2-3 | attaque 7 | `tank_attack_7.png` |
| 2-4 | attaque 8 | `tank_attack_8.png` |

#### Planche 3 — Dos (3/4 arrière) · Repos, marche et sorts

Dans l'Atelier : personnage « Tank », planche « Dos (3/4 arrière) · Repos, marche et sorts ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Tank, hero of the Cimes nation. Stout veteran warrior with a big white beard and white hair, heavy dark steel-blue plate armor with white fur trim and ice-blue crystal inlays, a large round shield with a cloud and mountain emblem on the left arm, a rune-engraved war hammer in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. bracing, shield planted on the ground, ice shards and snow bursts gathering around.
7. war cry, hammer raised to the sky, ice shards and snow bursts swirling around the body.
8. releasing a ring of ice shards and snow bursts around the feet.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `tank_back.png` |
| 1-2 | repos 2 | `tank_back_idle_2.png` |
| 1-3 | repos 3 | `tank_back_idle_3.png` |
| 1-4 | marche 1 | `tank_back_walk.png` |
| 2-1 | marche 2 | `tank_back_walk_2.png` |
| 2-2 | sort 1 | `tank_back_cast.png` |
| 2-3 | sort 2 | `tank_back_cast_2.png` |
| 2-4 | sort 3 | `tank_back_cast_3.png` |

#### Planche 4 — Dos (3/4 arrière) · Attaques

Dans l'Atelier : personnage « Tank », planche « Dos (3/4 arrière) · Attaques ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Tank, hero of the Cimes nation. Stout veteran warrior with a big white beard and white hair, heavy dark steel-blue plate armor with white fur trim and ice-blue crystal inlays, a large round shield with a cloud and mountain emblem on the left arm, a rune-engraved war hammer in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. wind-up, hammer raised high behind the head, shield forward.
2. overhead strike, hammer slamming down in front, small ice shards and snow bursts impact at the hammer head.
3. follow-through, hammer low, body leaning forward.
4. shield bash, shield thrust forward, hammer pulled back.
5. horizontal swing, hammer sweeping at waist height, body twisted.
6. rising uppercut with the hammer, one foot lifted.
7. spinning attack, hammer held out to the side, small ice shards and snow bursts whirl.
8. jumping slam, both feet off the ground, hammer above the head.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `tank_back_attack.png` |
| 1-2 | attaque 2 | `tank_back_attack_2.png` |
| 1-3 | attaque 3 | `tank_back_attack_3.png` |
| 1-4 | attaque 4 | `tank_back_attack_4.png` |
| 2-1 | attaque 5 | `tank_back_attack_5.png` |
| 2-2 | attaque 6 | `tank_back_attack_6.png` |
| 2-3 | attaque 7 | `tank_back_attack_7.png` |
| 2-4 | attaque 8 | `tank_back_attack_8.png` |

L'export Zimut de l'Atelier copie aussi le repos vers `nations/heros/tank.png` et les autres poses vers `nations/heros/poses/`.

## 3. Ennemis

### Guerrier des monts — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cimes/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Guerrier des monts », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Guerrier des monts, enemy of the Cimes nation. Mountain warrior with rocky brown skin, stocky body, crude stone gauntlets.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. wind-up, fist or weapon raised high.
5. heavy smash forward, ground cracking with a small ice shards and snow bursts burst.
6. follow-through, body leaning forward.
7. sweeping backhand blow.
8. stomping, ice shards and snow bursts cracks spreading under the feet.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `guerrier_des_monts.png` |
| 1-2 | repos 2 | `guerrier_des_monts_idle_2.png` |
| 1-3 | marche 1 | `guerrier_des_monts_walk.png` |
| 1-4 | attaque 1 | `guerrier_des_monts_attack.png` |
| 2-1 | attaque 2 | `guerrier_des_monts_attack_2.png` |
| 2-2 | attaque 3 | `guerrier_des_monts_attack_3.png` |
| 2-3 | attaque 4 | `guerrier_des_monts_attack_4.png` |
| 2-4 | sort 1 | `guerrier_des_monts_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Guerrier des monts », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Guerrier des monts, enemy of the Cimes nation. Mountain warrior with rocky brown skin, stocky body, crude stone gauntlets.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. wind-up, fist or weapon raised high.
5. heavy smash forward, ground cracking with a small ice shards and snow bursts burst.
6. follow-through, body leaning forward.
7. sweeping backhand blow.
8. stomping, ice shards and snow bursts cracks spreading under the feet.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `guerrier_des_monts_back.png` |
| 1-2 | repos 2 | `guerrier_des_monts_back_idle_2.png` |
| 1-3 | marche 1 | `guerrier_des_monts_back_walk.png` |
| 1-4 | attaque 1 | `guerrier_des_monts_back_attack.png` |
| 2-1 | attaque 2 | `guerrier_des_monts_back_attack_2.png` |
| 2-2 | attaque 3 | `guerrier_des_monts_back_attack_3.png` |
| 2-3 | attaque 4 | `guerrier_des_monts_back_attack_4.png` |
| 2-4 | sort 1 | `guerrier_des_monts_back_cast.png` |

### Griffon des cimes — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cimes/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Griffon des cimes », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Griffon des cimes, enemy of the Cimes nation. Griffin with a white eagle head, blue-grey feathered wings and a lion body.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, ready to pounce.
5. lunge forward, jaws or claws first, small ice shards and snow bursts impact.
6. follow-through, landing after the lunge.
7. second strike, swiping sideways.
8. head raised, ice shards and snow bursts gathering around the body.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `griffon_des_cimes.png` |
| 1-2 | repos 2 | `griffon_des_cimes_idle_2.png` |
| 1-3 | marche 1 | `griffon_des_cimes_walk.png` |
| 1-4 | attaque 1 | `griffon_des_cimes_attack.png` |
| 2-1 | attaque 2 | `griffon_des_cimes_attack_2.png` |
| 2-2 | attaque 3 | `griffon_des_cimes_attack_3.png` |
| 2-3 | attaque 4 | `griffon_des_cimes_attack_4.png` |
| 2-4 | sort 1 | `griffon_des_cimes_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Griffon des cimes », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Griffon des cimes, enemy of the Cimes nation. Griffin with a white eagle head, blue-grey feathered wings and a lion body.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, ready to pounce.
5. lunge forward, jaws or claws first, small ice shards and snow bursts impact.
6. follow-through, landing after the lunge.
7. second strike, swiping sideways.
8. head raised, ice shards and snow bursts gathering around the body.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `griffon_des_cimes_back.png` |
| 1-2 | repos 2 | `griffon_des_cimes_back_idle_2.png` |
| 1-3 | marche 1 | `griffon_des_cimes_back_walk.png` |
| 1-4 | attaque 1 | `griffon_des_cimes_back_attack.png` |
| 2-1 | attaque 2 | `griffon_des_cimes_back_attack_2.png` |
| 2-2 | attaque 3 | `griffon_des_cimes_back_attack_3.png` |
| 2-3 | attaque 4 | `griffon_des_cimes_back_attack_4.png` |
| 2-4 | sort 1 | `griffon_des_cimes_back_cast.png` |

### Garde des pics — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cimes/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Garde des pics », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Garde des pics, enemy of the Cimes nation. Peak guardian golem of blue-grey stone with glowing ice-blue crystals on the shoulders.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. wind-up, fist or weapon raised high.
5. heavy smash forward, ground cracking with a small ice shards and snow bursts burst.
6. follow-through, body leaning forward.
7. sweeping backhand blow.
8. stomping, ice shards and snow bursts cracks spreading under the feet.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `garde_des_pics.png` |
| 1-2 | repos 2 | `garde_des_pics_idle_2.png` |
| 1-3 | marche 1 | `garde_des_pics_walk.png` |
| 1-4 | attaque 1 | `garde_des_pics_attack.png` |
| 2-1 | attaque 2 | `garde_des_pics_attack_2.png` |
| 2-2 | attaque 3 | `garde_des_pics_attack_3.png` |
| 2-3 | attaque 4 | `garde_des_pics_attack_4.png` |
| 2-4 | sort 1 | `garde_des_pics_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Garde des pics », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Garde des pics, enemy of the Cimes nation. Peak guardian golem of blue-grey stone with glowing ice-blue crystals on the shoulders.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. wind-up, fist or weapon raised high.
5. heavy smash forward, ground cracking with a small ice shards and snow bursts burst.
6. follow-through, body leaning forward.
7. sweeping backhand blow.
8. stomping, ice shards and snow bursts cracks spreading under the feet.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `garde_des_pics_back.png` |
| 1-2 | repos 2 | `garde_des_pics_back_idle_2.png` |
| 1-3 | marche 1 | `garde_des_pics_back_walk.png` |
| 1-4 | attaque 1 | `garde_des_pics_back_attack.png` |
| 2-1 | attaque 2 | `garde_des_pics_back_attack_2.png` |
| 2-2 | attaque 3 | `garde_des_pics_back_attack_3.png` |
| 2-3 | attaque 4 | `garde_des_pics_back_attack_4.png` |
| 2-4 | sort 1 | `garde_des_pics_back_cast.png` |

### Rochebrute — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cimes/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Rochebrute », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Rochebrute, enemy of the Cimes nation. Hulking brute made of brown boulders, small glowing eyes, huge fists.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. wind-up, fist or weapon raised high.
5. heavy smash forward, ground cracking with a small ice shards and snow bursts burst.
6. follow-through, body leaning forward.
7. sweeping backhand blow.
8. stomping, ice shards and snow bursts cracks spreading under the feet.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `rochebrute.png` |
| 1-2 | repos 2 | `rochebrute_idle_2.png` |
| 1-3 | marche 1 | `rochebrute_walk.png` |
| 1-4 | attaque 1 | `rochebrute_attack.png` |
| 2-1 | attaque 2 | `rochebrute_attack_2.png` |
| 2-2 | attaque 3 | `rochebrute_attack_3.png` |
| 2-3 | attaque 4 | `rochebrute_attack_4.png` |
| 2-4 | sort 1 | `rochebrute_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Rochebrute », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Rochebrute, enemy of the Cimes nation. Hulking brute made of brown boulders, small glowing eyes, huge fists.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. wind-up, fist or weapon raised high.
5. heavy smash forward, ground cracking with a small ice shards and snow bursts burst.
6. follow-through, body leaning forward.
7. sweeping backhand blow.
8. stomping, ice shards and snow bursts cracks spreading under the feet.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `rochebrute_back.png` |
| 1-2 | repos 2 | `rochebrute_back_idle_2.png` |
| 1-3 | marche 1 | `rochebrute_back_walk.png` |
| 1-4 | attaque 1 | `rochebrute_back_attack.png` |
| 2-1 | attaque 2 | `rochebrute_back_attack_2.png` |
| 2-2 | attaque 3 | `rochebrute_back_attack_3.png` |
| 2-3 | attaque 4 | `rochebrute_back_attack_4.png` |
| 2-4 | sort 1 | `rochebrute_back_cast.png` |

## 4. Boss

### Vorkann le Givre — 32 poses

4 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/`.

#### Planche 1 — Face (3/4 avant) · Repos, marche et sorts

Dans l'Atelier : personnage « Vorkann le Givre », planche « Face (3/4 avant) · Repos, marche et sorts ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Vorkann le Givre, boss of the Cimes nation. Massive frost knight in dark steel armor covered with ice crystals and snow fur, crowned helm of ice spikes, huge crystal-studded tower shield and a heavy rune hammer, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. bracing, shield planted on the ground, ice shards and snow bursts gathering around.
7. war cry, hammer raised to the sky, ice shards and snow bursts swirling around the body.
8. releasing a ring of ice shards and snow bursts around the feet.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `cimes.png` |
| 1-2 | repos 2 | `cimes_idle_2.png` |
| 1-3 | repos 3 | `cimes_idle_3.png` |
| 1-4 | marche 1 | `cimes_walk.png` |
| 2-1 | marche 2 | `cimes_walk_2.png` |
| 2-2 | sort 1 | `cimes_cast.png` |
| 2-3 | sort 2 | `cimes_cast_2.png` |
| 2-4 | sort 3 | `cimes_cast_3.png` |

#### Planche 2 — Face (3/4 avant) · Attaques

Dans l'Atelier : personnage « Vorkann le Givre », planche « Face (3/4 avant) · Attaques ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Vorkann le Givre, boss of the Cimes nation. Massive frost knight in dark steel armor covered with ice crystals and snow fur, crowned helm of ice spikes, huge crystal-studded tower shield and a heavy rune hammer, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. wind-up, hammer raised high behind the head, shield forward.
2. overhead strike, hammer slamming down in front, small ice shards and snow bursts impact at the hammer head.
3. follow-through, hammer low, body leaning forward.
4. shield bash, shield thrust forward, hammer pulled back.
5. horizontal swing, hammer sweeping at waist height, body twisted.
6. rising uppercut with the hammer, one foot lifted.
7. spinning attack, hammer held out to the side, small ice shards and snow bursts whirl.
8. jumping slam, both feet off the ground, hammer above the head.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `cimes_attack.png` |
| 1-2 | attaque 2 | `cimes_attack_2.png` |
| 1-3 | attaque 3 | `cimes_attack_3.png` |
| 1-4 | attaque 4 | `cimes_attack_4.png` |
| 2-1 | attaque 5 | `cimes_attack_5.png` |
| 2-2 | attaque 6 | `cimes_attack_6.png` |
| 2-3 | attaque 7 | `cimes_attack_7.png` |
| 2-4 | attaque 8 | `cimes_attack_8.png` |

#### Planche 3 — Dos (3/4 arrière) · Repos, marche et sorts

Dans l'Atelier : personnage « Vorkann le Givre », planche « Dos (3/4 arrière) · Repos, marche et sorts ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Vorkann le Givre, boss of the Cimes nation. Massive frost knight in dark steel armor covered with ice crystals and snow fur, crowned helm of ice spikes, huge crystal-studded tower shield and a heavy rune hammer, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. bracing, shield planted on the ground, ice shards and snow bursts gathering around.
7. war cry, hammer raised to the sky, ice shards and snow bursts swirling around the body.
8. releasing a ring of ice shards and snow bursts around the feet.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `cimes_back.png` |
| 1-2 | repos 2 | `cimes_back_idle_2.png` |
| 1-3 | repos 3 | `cimes_back_idle_3.png` |
| 1-4 | marche 1 | `cimes_back_walk.png` |
| 2-1 | marche 2 | `cimes_back_walk_2.png` |
| 2-2 | sort 1 | `cimes_back_cast.png` |
| 2-3 | sort 2 | `cimes_back_cast_2.png` |
| 2-4 | sort 3 | `cimes_back_cast_3.png` |

#### Planche 4 — Dos (3/4 arrière) · Attaques

Dans l'Atelier : personnage « Vorkann le Givre », planche « Dos (3/4 arrière) · Attaques ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Vorkann le Givre, boss of the Cimes nation. Massive frost knight in dark steel armor covered with ice crystals and snow fur, crowned helm of ice spikes, huge crystal-studded tower shield and a heavy rune hammer, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. wind-up, hammer raised high behind the head, shield forward.
2. overhead strike, hammer slamming down in front, small ice shards and snow bursts impact at the hammer head.
3. follow-through, hammer low, body leaning forward.
4. shield bash, shield thrust forward, hammer pulled back.
5. horizontal swing, hammer sweeping at waist height, body twisted.
6. rising uppercut with the hammer, one foot lifted.
7. spinning attack, hammer held out to the side, small ice shards and snow bursts whirl.
8. jumping slam, both feet off the ground, hammer above the head.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `cimes_back_attack.png` |
| 1-2 | attaque 2 | `cimes_back_attack_2.png` |
| 1-3 | attaque 3 | `cimes_back_attack_3.png` |
| 1-4 | attaque 4 | `cimes_back_attack_4.png` |
| 2-1 | attaque 5 | `cimes_back_attack_5.png` |
| 2-2 | attaque 6 | `cimes_back_attack_6.png` |
| 2-3 | attaque 7 | `cimes_back_attack_7.png` |
| 2-4 | attaque 8 | `cimes_back_attack_8.png` |

## Prompt négatif (toutes les planches de cette page)

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art
```
