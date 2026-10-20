# Nation Brumes (Brumes)

Palette : black, deep violet, mist mint green, silver. Effets : mint mist and violet spectral wisps. Contre-jour : pale mint.

Chaque personnage est dessiné en **vue 3/4 avant (face)** et en **vue 3/4 arrière (dos)**. Le jeu retourne l'image pour les directions vers la gauche. Toutes les planches sont des grilles 4 × 2 aux cases bien séparées. Prompt négatif : voir en bas de page.

Ordre conseillé : 1) planche de référence, 2) héros, 3) ennemis, 4) boss.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos. Joins-la comme image de référence à toutes les planches suivantes.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Brumes nation (Brumes biome).
NATION PALETTE: black, deep violet, mist mint green, silver. Signature effects: mint mist and violet spectral wisps.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: two rows with the same 6 characters in the same order, all in idle pose. Top row: 3/4 front view, facing front-right. Bottom row: 3/4 back view, seen from behind, turned toward the upper right. All feet of a row on the same ground line. Leave a wide empty gap (at least half a character width) between characters and between the two rows: nobody overlaps or touches anyone, weapons and capes included. Image aspect ratio 2:1, as large as possible.
CHARACTERS, left to right:
1. the hero (Invocateur: summoner with black hair, long black coat with violet trims and silver clasps, a spiked dark staff topped with a violet crystal in the right hand, a grimoire floating at his side).
2. Brumeux (hulking lavender mist beast with a fluffy cloud body and small glowing eyes).
3. Gargouille (grey stone gargoyle with bat wings and a long tail).
4. Liche des brumes (thin violet lich in tattered robes holding a crooked staff).
5. Fantôme (pale blue ghost with a wavy tail and a mischievous face).
6. the final boss Ombrelis le Brumeux (dark necromancer in black spiked armor with a violet tattered cloak, spiked crown, holding a skull-topped staff surrounded by mist), about 1.5x taller than the others.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Invocateur — 32 poses

4 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/players/`.

#### Planche 1 — Face (3/4 avant) · Repos, marche et sorts

Dans l'Atelier : personnage « Invocateur », planche « Face (3/4 avant) · Repos, marche et sorts ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Invocateur, hero of the Brumes nation. Summoner with black hair, long black coat with violet trims and silver clasps, a spiked dark staff topped with a violet crystal in the right hand, a grimoire floating at his side.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. grimoire floating open, pages turning, mint mist and violet spectral wisps rising from it.
7. staff raised, a mint mist and violet spectral wisps summoning circle drawn on the ground.
8. both arms open, a mint mist and violet spectral wisps creature silhouette emerging from the circle.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `invocateur.png` |
| 1-2 | repos 2 | `invocateur_idle_2.png` |
| 1-3 | repos 3 | `invocateur_idle_3.png` |
| 1-4 | marche 1 | `invocateur_walk.png` |
| 2-1 | marche 2 | `invocateur_walk_2.png` |
| 2-2 | sort 1 | `invocateur_cast.png` |
| 2-3 | sort 2 | `invocateur_cast_2.png` |
| 2-4 | sort 3 | `invocateur_cast_3.png` |

#### Planche 2 — Face (3/4 avant) · Attaques

Dans l'Atelier : personnage « Invocateur », planche « Face (3/4 avant) · Attaques ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Invocateur, hero of the Brumes nation. Summoner with black hair, long black coat with violet trims and silver clasps, a spiked dark staff topped with a violet crystal in the right hand, a grimoire floating at his side.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. wind-up, staff held back, grimoire floating open beside.
2. staff swing forward, small mint mist and violet spectral wisps burst at the tip.
3. follow-through, staff low, coat swirling.
4. open palm thrust, mint mist and violet spectral wisps bolt leaving the hand.
5. grimoire snapping shut, a small mint mist and violet spectral wisps shockwave in front.
6. staff thrust forward with both hands.
7. two-handed overhead strike with the staff.
8. free hand clawing forward, mint mist and violet spectral wisps claws forming.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `invocateur_attack.png` |
| 1-2 | attaque 2 | `invocateur_attack_2.png` |
| 1-3 | attaque 3 | `invocateur_attack_3.png` |
| 1-4 | attaque 4 | `invocateur_attack_4.png` |
| 2-1 | attaque 5 | `invocateur_attack_5.png` |
| 2-2 | attaque 6 | `invocateur_attack_6.png` |
| 2-3 | attaque 7 | `invocateur_attack_7.png` |
| 2-4 | attaque 8 | `invocateur_attack_8.png` |

#### Planche 3 — Dos (3/4 arrière) · Repos, marche et sorts

Dans l'Atelier : personnage « Invocateur », planche « Dos (3/4 arrière) · Repos, marche et sorts ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Invocateur, hero of the Brumes nation. Summoner with black hair, long black coat with violet trims and silver clasps, a spiked dark staff topped with a violet crystal in the right hand, a grimoire floating at his side.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. grimoire floating open, pages turning, mint mist and violet spectral wisps rising from it.
7. staff raised, a mint mist and violet spectral wisps summoning circle drawn on the ground.
8. both arms open, a mint mist and violet spectral wisps creature silhouette emerging from the circle.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `invocateur_back.png` |
| 1-2 | repos 2 | `invocateur_back_idle_2.png` |
| 1-3 | repos 3 | `invocateur_back_idle_3.png` |
| 1-4 | marche 1 | `invocateur_back_walk.png` |
| 2-1 | marche 2 | `invocateur_back_walk_2.png` |
| 2-2 | sort 1 | `invocateur_back_cast.png` |
| 2-3 | sort 2 | `invocateur_back_cast_2.png` |
| 2-4 | sort 3 | `invocateur_back_cast_3.png` |

#### Planche 4 — Dos (3/4 arrière) · Attaques

Dans l'Atelier : personnage « Invocateur », planche « Dos (3/4 arrière) · Attaques ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Invocateur, hero of the Brumes nation. Summoner with black hair, long black coat with violet trims and silver clasps, a spiked dark staff topped with a violet crystal in the right hand, a grimoire floating at his side.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. wind-up, staff held back, grimoire floating open beside.
2. staff swing forward, small mint mist and violet spectral wisps burst at the tip.
3. follow-through, staff low, coat swirling.
4. open palm thrust, mint mist and violet spectral wisps bolt leaving the hand.
5. grimoire snapping shut, a small mint mist and violet spectral wisps shockwave in front.
6. staff thrust forward with both hands.
7. two-handed overhead strike with the staff.
8. free hand clawing forward, mint mist and violet spectral wisps claws forming.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `invocateur_back_attack.png` |
| 1-2 | attaque 2 | `invocateur_back_attack_2.png` |
| 1-3 | attaque 3 | `invocateur_back_attack_3.png` |
| 1-4 | attaque 4 | `invocateur_back_attack_4.png` |
| 2-1 | attaque 5 | `invocateur_back_attack_5.png` |
| 2-2 | attaque 6 | `invocateur_back_attack_6.png` |
| 2-3 | attaque 7 | `invocateur_back_attack_7.png` |
| 2-4 | attaque 8 | `invocateur_back_attack_8.png` |

L'export Zimut de l'Atelier copie aussi le repos vers `nations/heros/invocateur.png` et les autres poses vers `nations/heros/poses/`.

## 3. Ennemis

### Brumeux — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brumes/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Brumeux », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Brumeux, enemy of the Brumes nation. Hulking lavender mist beast with a fluffy cloud body and small glowing eyes.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. drawing back, body stretched upward.
5. lunging forward, claws of mint mist and violet spectral wisps reaching out.
6. follow-through, body trailing behind.
7. spinning strike, mint mist and violet spectral wisps whirl around the body.
8. hovering higher, mint mist and violet spectral wisps orbs circling the body.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `brumeux.png` |
| 1-2 | repos 2 | `brumeux_idle_2.png` |
| 1-3 | marche 1 | `brumeux_walk.png` |
| 1-4 | attaque 1 | `brumeux_attack.png` |
| 2-1 | attaque 2 | `brumeux_attack_2.png` |
| 2-2 | attaque 3 | `brumeux_attack_3.png` |
| 2-3 | attaque 4 | `brumeux_attack_4.png` |
| 2-4 | sort 1 | `brumeux_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Brumeux », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Brumeux, enemy of the Brumes nation. Hulking lavender mist beast with a fluffy cloud body and small glowing eyes.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. drawing back, body stretched upward.
5. lunging forward, claws of mint mist and violet spectral wisps reaching out.
6. follow-through, body trailing behind.
7. spinning strike, mint mist and violet spectral wisps whirl around the body.
8. hovering higher, mint mist and violet spectral wisps orbs circling the body.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `brumeux_back.png` |
| 1-2 | repos 2 | `brumeux_back_idle_2.png` |
| 1-3 | marche 1 | `brumeux_back_walk.png` |
| 1-4 | attaque 1 | `brumeux_back_attack.png` |
| 2-1 | attaque 2 | `brumeux_back_attack_2.png` |
| 2-2 | attaque 3 | `brumeux_back_attack_3.png` |
| 2-3 | attaque 4 | `brumeux_back_attack_4.png` |
| 2-4 | sort 1 | `brumeux_back_cast.png` |

### Gargouille — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brumes/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Gargouille », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Gargouille, enemy of the Brumes nation. Grey stone gargoyle with bat wings and a long tail.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, ready to pounce.
5. lunge forward, jaws or claws first, small mint mist and violet spectral wisps impact.
6. follow-through, landing after the lunge.
7. second strike, swiping sideways.
8. head raised, mint mist and violet spectral wisps gathering around the body.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `gargouille.png` |
| 1-2 | repos 2 | `gargouille_idle_2.png` |
| 1-3 | marche 1 | `gargouille_walk.png` |
| 1-4 | attaque 1 | `gargouille_attack.png` |
| 2-1 | attaque 2 | `gargouille_attack_2.png` |
| 2-2 | attaque 3 | `gargouille_attack_3.png` |
| 2-3 | attaque 4 | `gargouille_attack_4.png` |
| 2-4 | sort 1 | `gargouille_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Gargouille », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Gargouille, enemy of the Brumes nation. Grey stone gargoyle with bat wings and a long tail.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, ready to pounce.
5. lunge forward, jaws or claws first, small mint mist and violet spectral wisps impact.
6. follow-through, landing after the lunge.
7. second strike, swiping sideways.
8. head raised, mint mist and violet spectral wisps gathering around the body.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `gargouille_back.png` |
| 1-2 | repos 2 | `gargouille_back_idle_2.png` |
| 1-3 | marche 1 | `gargouille_back_walk.png` |
| 1-4 | attaque 1 | `gargouille_back_attack.png` |
| 2-1 | attaque 2 | `gargouille_back_attack_2.png` |
| 2-2 | attaque 3 | `gargouille_back_attack_3.png` |
| 2-3 | attaque 4 | `gargouille_back_attack_4.png` |
| 2-4 | sort 1 | `gargouille_back_cast.png` |

### Liche des brumes — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brumes/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Liche des brumes », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Liche des brumes, enemy of the Brumes nation. Thin violet lich in tattered robes holding a crooked staff.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. wind-up, staff held back with both hands.
5. staff swing forward, small mint mist and violet spectral wisps burst at the tip.
6. follow-through, staff low, body turned.
7. thrust with the staff tip forward, short mint mist and violet spectral wisps spark.
8. staff raised, mint mist and violet spectral wisps orb forming at the top.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `liche_des_brumes.png` |
| 1-2 | repos 2 | `liche_des_brumes_idle_2.png` |
| 1-3 | marche 1 | `liche_des_brumes_walk.png` |
| 1-4 | attaque 1 | `liche_des_brumes_attack.png` |
| 2-1 | attaque 2 | `liche_des_brumes_attack_2.png` |
| 2-2 | attaque 3 | `liche_des_brumes_attack_3.png` |
| 2-3 | attaque 4 | `liche_des_brumes_attack_4.png` |
| 2-4 | sort 1 | `liche_des_brumes_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Liche des brumes », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Liche des brumes, enemy of the Brumes nation. Thin violet lich in tattered robes holding a crooked staff.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. wind-up, staff held back with both hands.
5. staff swing forward, small mint mist and violet spectral wisps burst at the tip.
6. follow-through, staff low, body turned.
7. thrust with the staff tip forward, short mint mist and violet spectral wisps spark.
8. staff raised, mint mist and violet spectral wisps orb forming at the top.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `liche_des_brumes_back.png` |
| 1-2 | repos 2 | `liche_des_brumes_back_idle_2.png` |
| 1-3 | marche 1 | `liche_des_brumes_back_walk.png` |
| 1-4 | attaque 1 | `liche_des_brumes_back_attack.png` |
| 2-1 | attaque 2 | `liche_des_brumes_back_attack_2.png` |
| 2-2 | attaque 3 | `liche_des_brumes_back_attack_3.png` |
| 2-3 | attaque 4 | `liche_des_brumes_back_attack_4.png` |
| 2-4 | sort 1 | `liche_des_brumes_back_cast.png` |

### Fantôme — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brumes/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Fantôme », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Fantôme, enemy of the Brumes nation. Pale blue ghost with a wavy tail and a mischievous face.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. drawing back, body stretched upward.
5. lunging forward, claws of mint mist and violet spectral wisps reaching out.
6. follow-through, body trailing behind.
7. spinning strike, mint mist and violet spectral wisps whirl around the body.
8. hovering higher, mint mist and violet spectral wisps orbs circling the body.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `fantome.png` |
| 1-2 | repos 2 | `fantome_idle_2.png` |
| 1-3 | marche 1 | `fantome_walk.png` |
| 1-4 | attaque 1 | `fantome_attack.png` |
| 2-1 | attaque 2 | `fantome_attack_2.png` |
| 2-2 | attaque 3 | `fantome_attack_3.png` |
| 2-3 | attaque 4 | `fantome_attack_4.png` |
| 2-4 | sort 1 | `fantome_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Fantôme », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Fantôme, enemy of the Brumes nation. Pale blue ghost with a wavy tail and a mischievous face.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. drawing back, body stretched upward.
5. lunging forward, claws of mint mist and violet spectral wisps reaching out.
6. follow-through, body trailing behind.
7. spinning strike, mint mist and violet spectral wisps whirl around the body.
8. hovering higher, mint mist and violet spectral wisps orbs circling the body.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `fantome_back.png` |
| 1-2 | repos 2 | `fantome_back_idle_2.png` |
| 1-3 | marche 1 | `fantome_back_walk.png` |
| 1-4 | attaque 1 | `fantome_back_attack.png` |
| 2-1 | attaque 2 | `fantome_back_attack_2.png` |
| 2-2 | attaque 3 | `fantome_back_attack_3.png` |
| 2-3 | attaque 4 | `fantome_back_attack_4.png` |
| 2-4 | sort 1 | `fantome_back_cast.png` |

## 4. Boss

### Ombrelis le Brumeux — 32 poses

4 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/`.

#### Planche 1 — Face (3/4 avant) · Repos, marche et sorts

Dans l'Atelier : personnage « Ombrelis le Brumeux », planche « Face (3/4 avant) · Repos, marche et sorts ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Ombrelis le Brumeux, boss of the Brumes nation. Dark necromancer in black spiked armor with a violet tattered cloak, spiked crown, holding a skull-topped staff surrounded by mist, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. grimoire floating open, pages turning, mint mist and violet spectral wisps rising from it.
7. staff raised, a mint mist and violet spectral wisps summoning circle drawn on the ground.
8. both arms open, a mint mist and violet spectral wisps creature silhouette emerging from the circle.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `brumes.png` |
| 1-2 | repos 2 | `brumes_idle_2.png` |
| 1-3 | repos 3 | `brumes_idle_3.png` |
| 1-4 | marche 1 | `brumes_walk.png` |
| 2-1 | marche 2 | `brumes_walk_2.png` |
| 2-2 | sort 1 | `brumes_cast.png` |
| 2-3 | sort 2 | `brumes_cast_2.png` |
| 2-4 | sort 3 | `brumes_cast_3.png` |

#### Planche 2 — Face (3/4 avant) · Attaques

Dans l'Atelier : personnage « Ombrelis le Brumeux », planche « Face (3/4 avant) · Attaques ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Ombrelis le Brumeux, boss of the Brumes nation. Dark necromancer in black spiked armor with a violet tattered cloak, spiked crown, holding a skull-topped staff surrounded by mist, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. wind-up, staff held back, grimoire floating open beside.
2. staff swing forward, small mint mist and violet spectral wisps burst at the tip.
3. follow-through, staff low, coat swirling.
4. open palm thrust, mint mist and violet spectral wisps bolt leaving the hand.
5. grimoire snapping shut, a small mint mist and violet spectral wisps shockwave in front.
6. staff thrust forward with both hands.
7. two-handed overhead strike with the staff.
8. free hand clawing forward, mint mist and violet spectral wisps claws forming.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `brumes_attack.png` |
| 1-2 | attaque 2 | `brumes_attack_2.png` |
| 1-3 | attaque 3 | `brumes_attack_3.png` |
| 1-4 | attaque 4 | `brumes_attack_4.png` |
| 2-1 | attaque 5 | `brumes_attack_5.png` |
| 2-2 | attaque 6 | `brumes_attack_6.png` |
| 2-3 | attaque 7 | `brumes_attack_7.png` |
| 2-4 | attaque 8 | `brumes_attack_8.png` |

#### Planche 3 — Dos (3/4 arrière) · Repos, marche et sorts

Dans l'Atelier : personnage « Ombrelis le Brumeux », planche « Dos (3/4 arrière) · Repos, marche et sorts ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Ombrelis le Brumeux, boss of the Brumes nation. Dark necromancer in black spiked armor with a violet tattered cloak, spiked crown, holding a skull-topped staff surrounded by mist, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. grimoire floating open, pages turning, mint mist and violet spectral wisps rising from it.
7. staff raised, a mint mist and violet spectral wisps summoning circle drawn on the ground.
8. both arms open, a mint mist and violet spectral wisps creature silhouette emerging from the circle.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `brumes_back.png` |
| 1-2 | repos 2 | `brumes_back_idle_2.png` |
| 1-3 | repos 3 | `brumes_back_idle_3.png` |
| 1-4 | marche 1 | `brumes_back_walk.png` |
| 2-1 | marche 2 | `brumes_back_walk_2.png` |
| 2-2 | sort 1 | `brumes_back_cast.png` |
| 2-3 | sort 2 | `brumes_back_cast_2.png` |
| 2-4 | sort 3 | `brumes_back_cast_3.png` |

#### Planche 4 — Dos (3/4 arrière) · Attaques

Dans l'Atelier : personnage « Ombrelis le Brumeux », planche « Dos (3/4 arrière) · Attaques ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Ombrelis le Brumeux, boss of the Brumes nation. Dark necromancer in black spiked armor with a violet tattered cloak, spiked crown, holding a skull-topped staff surrounded by mist, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. wind-up, staff held back, grimoire floating open beside.
2. staff swing forward, small mint mist and violet spectral wisps burst at the tip.
3. follow-through, staff low, coat swirling.
4. open palm thrust, mint mist and violet spectral wisps bolt leaving the hand.
5. grimoire snapping shut, a small mint mist and violet spectral wisps shockwave in front.
6. staff thrust forward with both hands.
7. two-handed overhead strike with the staff.
8. free hand clawing forward, mint mist and violet spectral wisps claws forming.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `brumes_back_attack.png` |
| 1-2 | attaque 2 | `brumes_back_attack_2.png` |
| 1-3 | attaque 3 | `brumes_back_attack_3.png` |
| 1-4 | attaque 4 | `brumes_back_attack_4.png` |
| 2-1 | attaque 5 | `brumes_back_attack_5.png` |
| 2-2 | attaque 6 | `brumes_back_attack_6.png` |
| 2-3 | attaque 7 | `brumes_back_attack_7.png` |
| 2-4 | attaque 8 | `brumes_back_attack_8.png` |

## Prompt négatif (toutes les planches de cette page)

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art
```
