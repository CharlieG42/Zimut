# Nation Marées (Marées)

Palette : turquoise, white, gold trims, coral pink accents. Effets : water splashes and bubbles. Contre-jour : aqua.

Chaque personnage est dessiné en **vue 3/4 avant (face)** et en **vue 3/4 arrière (dos)**. Le jeu retourne l'image pour les directions vers la gauche. Toutes les planches sont des grilles 4 × 2 aux cases bien séparées. Prompt négatif : voir en bas de page.

Ordre conseillé : 1) planche de référence, 2) héros, 3) ennemis, 4) boss.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos. Joins-la comme image de référence à toutes les planches suivantes.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Marées nation (Marées biome).
NATION PALETTE: turquoise, white, gold trims, coral pink accents. Signature effects: water splashes and bubbles.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: two rows with the same 6 characters in the same order, all in idle pose. Top row: 3/4 front view, facing front-right. Bottom row: 3/4 back view, seen from behind, turned toward the upper right. All feet of a row on the same ground line. Leave a wide empty gap (at least half a character width) between characters and between the two rows: nobody overlaps or touches anyone, weapons and capes included. Image aspect ratio 2:1, as large as possible.
CHARACTERS, left to right:
1. the hero (Heal (Soigneur): gentle healer with teal hair, ornate white and turquoise robe with gold embroidery and wave patterns, a golden staff topped with a glowing water-drop crystal in the right hand).
2. Pirate des mers (sea pirate with a red bandana, blue coat, leather belts and a short cutlass).
3. Requin (blue shark with a white belly swimming upright in the air, toothy grin).
4. Néréide (water nymph made of translucent-looking turquoise water, flowing hair of waves).
5. Crabe géant (giant crab with a blue shell striped with red, huge pincers).
6. the final boss Néréa la Tempête (sea queen in turquoise coral armor with gold edges, crown of red coral branches, flowing sea-foam cape, holding a golden trident), about 1.5x taller than the others.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Heal (Soigneur) — 32 poses

4 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/players/`.

#### Planche 1 — Face (3/4 avant) · Repos, marche et sorts

Dans l'Atelier : personnage « Heal », planche « Face (3/4 avant) · Repos, marche et sorts ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Heal, hero of the Marées nation. Gentle healer with teal hair, ornate white and turquoise robe with gold embroidery and wave patterns, a golden staff topped with a glowing water-drop crystal in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. staff raised, water splashes and bubbles orb forming at the top.
7. staff held high with both hands, water splashes and bubbles swirling around.
8. staff pointed forward, releasing a compact water splashes and bubbles blast.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `heal.png` |
| 1-2 | repos 2 | `heal_idle_2.png` |
| 1-3 | repos 3 | `heal_idle_3.png` |
| 1-4 | marche 1 | `heal_walk.png` |
| 2-1 | marche 2 | `heal_walk_2.png` |
| 2-2 | sort 1 | `heal_cast.png` |
| 2-3 | sort 2 | `heal_cast_2.png` |
| 2-4 | sort 3 | `heal_cast_3.png` |

#### Planche 2 — Face (3/4 avant) · Attaques

Dans l'Atelier : personnage « Heal », planche « Face (3/4 avant) · Attaques ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Heal, hero of the Marées nation. Gentle healer with teal hair, ornate white and turquoise robe with gold embroidery and wave patterns, a golden staff topped with a glowing water-drop crystal in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. wind-up, staff held back with both hands.
2. staff swing forward, small water splashes and bubbles burst at the tip.
3. follow-through, staff low, body turned.
4. thrust with the staff tip forward, short water splashes and bubbles spark.
5. overhead staff strike, both hands high.
6. spinning the staff around the body, small water splashes and bubbles trail.
7. low sweep with the staff at the feet.
8. staff planted, kicking forward with one leg.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `heal_attack.png` |
| 1-2 | attaque 2 | `heal_attack_2.png` |
| 1-3 | attaque 3 | `heal_attack_3.png` |
| 1-4 | attaque 4 | `heal_attack_4.png` |
| 2-1 | attaque 5 | `heal_attack_5.png` |
| 2-2 | attaque 6 | `heal_attack_6.png` |
| 2-3 | attaque 7 | `heal_attack_7.png` |
| 2-4 | attaque 8 | `heal_attack_8.png` |

#### Planche 3 — Dos (3/4 arrière) · Repos, marche et sorts

Dans l'Atelier : personnage « Heal », planche « Dos (3/4 arrière) · Repos, marche et sorts ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Heal, hero of the Marées nation. Gentle healer with teal hair, ornate white and turquoise robe with gold embroidery and wave patterns, a golden staff topped with a glowing water-drop crystal in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. staff raised, water splashes and bubbles orb forming at the top.
7. staff held high with both hands, water splashes and bubbles swirling around.
8. staff pointed forward, releasing a compact water splashes and bubbles blast.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `heal_back.png` |
| 1-2 | repos 2 | `heal_back_idle_2.png` |
| 1-3 | repos 3 | `heal_back_idle_3.png` |
| 1-4 | marche 1 | `heal_back_walk.png` |
| 2-1 | marche 2 | `heal_back_walk_2.png` |
| 2-2 | sort 1 | `heal_back_cast.png` |
| 2-3 | sort 2 | `heal_back_cast_2.png` |
| 2-4 | sort 3 | `heal_back_cast_3.png` |

#### Planche 4 — Dos (3/4 arrière) · Attaques

Dans l'Atelier : personnage « Heal », planche « Dos (3/4 arrière) · Attaques ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Heal, hero of the Marées nation. Gentle healer with teal hair, ornate white and turquoise robe with gold embroidery and wave patterns, a golden staff topped with a glowing water-drop crystal in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. wind-up, staff held back with both hands.
2. staff swing forward, small water splashes and bubbles burst at the tip.
3. follow-through, staff low, body turned.
4. thrust with the staff tip forward, short water splashes and bubbles spark.
5. overhead staff strike, both hands high.
6. spinning the staff around the body, small water splashes and bubbles trail.
7. low sweep with the staff at the feet.
8. staff planted, kicking forward with one leg.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `heal_back_attack.png` |
| 1-2 | attaque 2 | `heal_back_attack_2.png` |
| 1-3 | attaque 3 | `heal_back_attack_3.png` |
| 1-4 | attaque 4 | `heal_back_attack_4.png` |
| 2-1 | attaque 5 | `heal_back_attack_5.png` |
| 2-2 | attaque 6 | `heal_back_attack_6.png` |
| 2-3 | attaque 7 | `heal_back_attack_7.png` |
| 2-4 | attaque 8 | `heal_back_attack_8.png` |

L'export Zimut de l'Atelier copie aussi le repos vers `nations/heros/heal.png` et les autres poses vers `nations/heros/poses/`.

## 3. Ennemis

### Pirate des mers — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/marees/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Pirate des mers », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Pirate des mers, enemy of the Marées nation. Sea pirate with a red bandana, blue coat, leather belts and a short cutlass.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, both daggers crossed in front of the chest.
5. dash slash forward, both arms extended, short water splashes and bubbles slash crescents.
6. spinning follow-through, one dagger high, one low.
7. backhand stab, one dagger thrust forward, body twisted.
8. kneeling, one hand on the ground, water splashes and bubbles rising from the shadow below.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `pirate_des_mers.png` |
| 1-2 | repos 2 | `pirate_des_mers_idle_2.png` |
| 1-3 | marche 1 | `pirate_des_mers_walk.png` |
| 1-4 | attaque 1 | `pirate_des_mers_attack.png` |
| 2-1 | attaque 2 | `pirate_des_mers_attack_2.png` |
| 2-2 | attaque 3 | `pirate_des_mers_attack_3.png` |
| 2-3 | attaque 4 | `pirate_des_mers_attack_4.png` |
| 2-4 | sort 1 | `pirate_des_mers_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Pirate des mers », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Pirate des mers, enemy of the Marées nation. Sea pirate with a red bandana, blue coat, leather belts and a short cutlass.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, both daggers crossed in front of the chest.
5. dash slash forward, both arms extended, short water splashes and bubbles slash crescents.
6. spinning follow-through, one dagger high, one low.
7. backhand stab, one dagger thrust forward, body twisted.
8. kneeling, one hand on the ground, water splashes and bubbles rising from the shadow below.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `pirate_des_mers_back.png` |
| 1-2 | repos 2 | `pirate_des_mers_back_idle_2.png` |
| 1-3 | marche 1 | `pirate_des_mers_back_walk.png` |
| 1-4 | attaque 1 | `pirate_des_mers_back_attack.png` |
| 2-1 | attaque 2 | `pirate_des_mers_back_attack_2.png` |
| 2-2 | attaque 3 | `pirate_des_mers_back_attack_3.png` |
| 2-3 | attaque 4 | `pirate_des_mers_back_attack_4.png` |
| 2-4 | sort 1 | `pirate_des_mers_back_cast.png` |

### Requin — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/marees/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Requin », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Requin, enemy of the Marées nation. Blue shark with a white belly swimming upright in the air, toothy grin.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, ready to pounce.
5. lunge forward, jaws or claws first, small water splashes and bubbles impact.
6. follow-through, landing after the lunge.
7. second strike, swiping sideways.
8. head raised, water splashes and bubbles gathering around the body.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `requin.png` |
| 1-2 | repos 2 | `requin_idle_2.png` |
| 1-3 | marche 1 | `requin_walk.png` |
| 1-4 | attaque 1 | `requin_attack.png` |
| 2-1 | attaque 2 | `requin_attack_2.png` |
| 2-2 | attaque 3 | `requin_attack_3.png` |
| 2-3 | attaque 4 | `requin_attack_4.png` |
| 2-4 | sort 1 | `requin_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Requin », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Requin, enemy of the Marées nation. Blue shark with a white belly swimming upright in the air, toothy grin.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, ready to pounce.
5. lunge forward, jaws or claws first, small water splashes and bubbles impact.
6. follow-through, landing after the lunge.
7. second strike, swiping sideways.
8. head raised, water splashes and bubbles gathering around the body.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `requin_back.png` |
| 1-2 | repos 2 | `requin_back_idle_2.png` |
| 1-3 | marche 1 | `requin_back_walk.png` |
| 1-4 | attaque 1 | `requin_back_attack.png` |
| 2-1 | attaque 2 | `requin_back_attack_2.png` |
| 2-2 | attaque 3 | `requin_back_attack_3.png` |
| 2-3 | attaque 4 | `requin_back_attack_4.png` |
| 2-4 | sort 1 | `requin_back_cast.png` |

### Néréide — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/marees/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Néréide », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Néréide, enemy of the Marées nation. Water nymph made of translucent-looking turquoise water, flowing hair of waves.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. drawing back, body stretched upward.
5. lunging forward, claws of water splashes and bubbles reaching out.
6. follow-through, body trailing behind.
7. spinning strike, water splashes and bubbles whirl around the body.
8. hovering higher, water splashes and bubbles orbs circling the body.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `nereide.png` |
| 1-2 | repos 2 | `nereide_idle_2.png` |
| 1-3 | marche 1 | `nereide_walk.png` |
| 1-4 | attaque 1 | `nereide_attack.png` |
| 2-1 | attaque 2 | `nereide_attack_2.png` |
| 2-2 | attaque 3 | `nereide_attack_3.png` |
| 2-3 | attaque 4 | `nereide_attack_4.png` |
| 2-4 | sort 1 | `nereide_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Néréide », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Néréide, enemy of the Marées nation. Water nymph made of translucent-looking turquoise water, flowing hair of waves.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. drawing back, body stretched upward.
5. lunging forward, claws of water splashes and bubbles reaching out.
6. follow-through, body trailing behind.
7. spinning strike, water splashes and bubbles whirl around the body.
8. hovering higher, water splashes and bubbles orbs circling the body.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `nereide_back.png` |
| 1-2 | repos 2 | `nereide_back_idle_2.png` |
| 1-3 | marche 1 | `nereide_back_walk.png` |
| 1-4 | attaque 1 | `nereide_back_attack.png` |
| 2-1 | attaque 2 | `nereide_back_attack_2.png` |
| 2-2 | attaque 3 | `nereide_back_attack_3.png` |
| 2-3 | attaque 4 | `nereide_back_attack_4.png` |
| 2-4 | sort 1 | `nereide_back_cast.png` |

### Crabe géant — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/marees/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Crabe géant », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Crabe géant, enemy of the Marées nation. Giant crab with a blue shell striped with red, huge pincers.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, ready to pounce.
5. lunge forward, jaws or claws first, small water splashes and bubbles impact.
6. follow-through, landing after the lunge.
7. second strike, swiping sideways.
8. head raised, water splashes and bubbles gathering around the body.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `crabe_geant.png` |
| 1-2 | repos 2 | `crabe_geant_idle_2.png` |
| 1-3 | marche 1 | `crabe_geant_walk.png` |
| 1-4 | attaque 1 | `crabe_geant_attack.png` |
| 2-1 | attaque 2 | `crabe_geant_attack_2.png` |
| 2-2 | attaque 3 | `crabe_geant_attack_3.png` |
| 2-3 | attaque 4 | `crabe_geant_attack_4.png` |
| 2-4 | sort 1 | `crabe_geant_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Crabe géant », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Crabe géant, enemy of the Marées nation. Giant crab with a blue shell striped with red, huge pincers.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, ready to pounce.
5. lunge forward, jaws or claws first, small water splashes and bubbles impact.
6. follow-through, landing after the lunge.
7. second strike, swiping sideways.
8. head raised, water splashes and bubbles gathering around the body.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `crabe_geant_back.png` |
| 1-2 | repos 2 | `crabe_geant_back_idle_2.png` |
| 1-3 | marche 1 | `crabe_geant_back_walk.png` |
| 1-4 | attaque 1 | `crabe_geant_back_attack.png` |
| 2-1 | attaque 2 | `crabe_geant_back_attack_2.png` |
| 2-2 | attaque 3 | `crabe_geant_back_attack_3.png` |
| 2-3 | attaque 4 | `crabe_geant_back_attack_4.png` |
| 2-4 | sort 1 | `crabe_geant_back_cast.png` |

## 4. Boss

### Néréa la Tempête — 32 poses

4 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/`.

#### Planche 1 — Face (3/4 avant) · Repos, marche et sorts

Dans l'Atelier : personnage « Néréa la Tempête », planche « Face (3/4 avant) · Repos, marche et sorts ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Néréa la Tempête, boss of the Marées nation. Sea queen in turquoise coral armor with gold edges, crown of red coral branches, flowing sea-foam cape, holding a golden trident, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. staff raised, water splashes and bubbles orb forming at the top.
7. staff held high with both hands, water splashes and bubbles swirling around.
8. staff pointed forward, releasing a compact water splashes and bubbles blast.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `marees.png` |
| 1-2 | repos 2 | `marees_idle_2.png` |
| 1-3 | repos 3 | `marees_idle_3.png` |
| 1-4 | marche 1 | `marees_walk.png` |
| 2-1 | marche 2 | `marees_walk_2.png` |
| 2-2 | sort 1 | `marees_cast.png` |
| 2-3 | sort 2 | `marees_cast_2.png` |
| 2-4 | sort 3 | `marees_cast_3.png` |

#### Planche 2 — Face (3/4 avant) · Attaques

Dans l'Atelier : personnage « Néréa la Tempête », planche « Face (3/4 avant) · Attaques ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Néréa la Tempête, boss of the Marées nation. Sea queen in turquoise coral armor with gold edges, crown of red coral branches, flowing sea-foam cape, holding a golden trident, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. wind-up, staff held back with both hands.
2. staff swing forward, small water splashes and bubbles burst at the tip.
3. follow-through, staff low, body turned.
4. thrust with the staff tip forward, short water splashes and bubbles spark.
5. overhead staff strike, both hands high.
6. spinning the staff around the body, small water splashes and bubbles trail.
7. low sweep with the staff at the feet.
8. staff planted, kicking forward with one leg.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `marees_attack.png` |
| 1-2 | attaque 2 | `marees_attack_2.png` |
| 1-3 | attaque 3 | `marees_attack_3.png` |
| 1-4 | attaque 4 | `marees_attack_4.png` |
| 2-1 | attaque 5 | `marees_attack_5.png` |
| 2-2 | attaque 6 | `marees_attack_6.png` |
| 2-3 | attaque 7 | `marees_attack_7.png` |
| 2-4 | attaque 8 | `marees_attack_8.png` |

#### Planche 3 — Dos (3/4 arrière) · Repos, marche et sorts

Dans l'Atelier : personnage « Néréa la Tempête », planche « Dos (3/4 arrière) · Repos, marche et sorts ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Néréa la Tempête, boss of the Marées nation. Sea queen in turquoise coral armor with gold edges, crown of red coral branches, flowing sea-foam cape, holding a golden trident, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. staff raised, water splashes and bubbles orb forming at the top.
7. staff held high with both hands, water splashes and bubbles swirling around.
8. staff pointed forward, releasing a compact water splashes and bubbles blast.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `marees_back.png` |
| 1-2 | repos 2 | `marees_back_idle_2.png` |
| 1-3 | repos 3 | `marees_back_idle_3.png` |
| 1-4 | marche 1 | `marees_back_walk.png` |
| 2-1 | marche 2 | `marees_back_walk_2.png` |
| 2-2 | sort 1 | `marees_back_cast.png` |
| 2-3 | sort 2 | `marees_back_cast_2.png` |
| 2-4 | sort 3 | `marees_back_cast_3.png` |

#### Planche 4 — Dos (3/4 arrière) · Attaques

Dans l'Atelier : personnage « Néréa la Tempête », planche « Dos (3/4 arrière) · Attaques ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Néréa la Tempête, boss of the Marées nation. Sea queen in turquoise coral armor with gold edges, crown of red coral branches, flowing sea-foam cape, holding a golden trident, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. wind-up, staff held back with both hands.
2. staff swing forward, small water splashes and bubbles burst at the tip.
3. follow-through, staff low, body turned.
4. thrust with the staff tip forward, short water splashes and bubbles spark.
5. overhead staff strike, both hands high.
6. spinning the staff around the body, small water splashes and bubbles trail.
7. low sweep with the staff at the feet.
8. staff planted, kicking forward with one leg.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `marees_back_attack.png` |
| 1-2 | attaque 2 | `marees_back_attack_2.png` |
| 1-3 | attaque 3 | `marees_back_attack_3.png` |
| 1-4 | attaque 4 | `marees_back_attack_4.png` |
| 2-1 | attaque 5 | `marees_back_attack_5.png` |
| 2-2 | attaque 6 | `marees_back_attack_6.png` |
| 2-3 | attaque 7 | `marees_back_attack_7.png` |
| 2-4 | attaque 8 | `marees_back_attack_8.png` |

## Prompt négatif (toutes les planches de cette page)

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art
```
