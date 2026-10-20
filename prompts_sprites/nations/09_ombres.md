# Nation Ombres (Ombres)

Palette : black, charcoal, violet glow, silver-teal cloth accents. Effets : violet shadow smoke. Contre-jour : violet.

Chaque personnage est dessiné en **vue 3/4 avant (face)** et en **vue 3/4 arrière (dos)**. Le jeu retourne l'image pour les directions vers la gauche. Toutes les planches sont des grilles 4 × 2 aux cases bien séparées. Prompt négatif : voir en bas de page.

Ordre conseillé : 1) planche de référence, 2) héros, 3) ennemis, 4) boss.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos. Joins-la comme image de référence à toutes les planches suivantes.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Ombres nation (Ombres biome).
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents. Signature effects: violet shadow smoke.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: two rows with the same 6 characters in the same order, all in idle pose. Top row: 3/4 front view, facing front-right. Bottom row: 3/4 back view, seen from behind, turned toward the upper right. All feet of a row on the same ground line. Leave a wide empty gap (at least half a character width) between characters and between the two rows: nobody overlaps or touches anyone, weapons and capes included. Image aspect ratio 2:1, as large as possible.
CHARACTERS, left to right:
1. the hero (Assassin: agile assassin with black hair, a black cloth mask covering the lower face (eyes clearly visible), dark charcoal hooded armor with layered tattered silver-teal cloth panels, violet glowing rune details, a curved dagger in each hand).
2. Assassin des ombres (hunched shadow beast-assassin with a spiky purple mane and long claws).
3. Ombre infernale (swirling mass of purple shadow with claws and glowing eyes).
4. Spectre (violet spectral figure wrapped in shadow curls, long claw-like hands).
5. Liche (tall dark purple lich in a spiked robe holding a staff).
6. the final boss Nébulia l'Illusionniste (tall illusionist in black armor with spiky layers of silver-teal tattered cloth, horned mask-helm, long blades, mirror-like violet glints), about 1.5x taller than the others.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Assassin — 32 poses

4 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/players/`.

#### Planche 1 — Face (3/4 avant) · Repos, marche et sorts

Dans l'Atelier : personnage « Assassin », planche « Face (3/4 avant) · Repos, marche et sorts ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Assassin, hero of the Ombres nation. Agile assassin with black hair, a black cloth mask covering the lower face (eyes clearly visible), dark charcoal hooded armor with layered tattered silver-teal cloth panels, violet glowing rune details, a curved dagger in each hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. kneeling, one hand on the ground, violet shadow smoke rising from the shadow below.
7. half vanished into violet shadow smoke, only the eyes and daggers clearly visible.
8. reappearing from a burst of violet shadow smoke, daggers ready.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `assassin.png` |
| 1-2 | repos 2 | `assassin_idle_2.png` |
| 1-3 | repos 3 | `assassin_idle_3.png` |
| 1-4 | marche 1 | `assassin_walk.png` |
| 2-1 | marche 2 | `assassin_walk_2.png` |
| 2-2 | sort 1 | `assassin_cast.png` |
| 2-3 | sort 2 | `assassin_cast_2.png` |
| 2-4 | sort 3 | `assassin_cast_3.png` |

#### Planche 2 — Face (3/4 avant) · Attaques

Dans l'Atelier : personnage « Assassin », planche « Face (3/4 avant) · Attaques ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Assassin, hero of the Ombres nation. Agile assassin with black hair, a black cloth mask covering the lower face (eyes clearly visible), dark charcoal hooded armor with layered tattered silver-teal cloth panels, violet glowing rune details, a curved dagger in each hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. crouched wind-up, both daggers crossed in front of the chest.
2. dash slash forward, both arms extended, short violet shadow smoke slash crescents.
3. spinning follow-through, one dagger high, one low.
4. backhand stab, one dagger thrust forward, body twisted.
5. double downward stab, both daggers pointing down, knees bent.
6. rising cross slash, both arms opening upward.
7. low sweeping slash, crouched on one knee.
8. leaping strike, body in the air, daggers held forward.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `assassin_attack.png` |
| 1-2 | attaque 2 | `assassin_attack_2.png` |
| 1-3 | attaque 3 | `assassin_attack_3.png` |
| 1-4 | attaque 4 | `assassin_attack_4.png` |
| 2-1 | attaque 5 | `assassin_attack_5.png` |
| 2-2 | attaque 6 | `assassin_attack_6.png` |
| 2-3 | attaque 7 | `assassin_attack_7.png` |
| 2-4 | attaque 8 | `assassin_attack_8.png` |

#### Planche 3 — Dos (3/4 arrière) · Repos, marche et sorts

Dans l'Atelier : personnage « Assassin », planche « Dos (3/4 arrière) · Repos, marche et sorts ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Assassin, hero of the Ombres nation. Agile assassin with black hair, a black cloth mask covering the lower face (eyes clearly visible), dark charcoal hooded armor with layered tattered silver-teal cloth panels, violet glowing rune details, a curved dagger in each hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. kneeling, one hand on the ground, violet shadow smoke rising from the shadow below.
7. half vanished into violet shadow smoke, only the eyes and daggers clearly visible.
8. reappearing from a burst of violet shadow smoke, daggers ready.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `assassin_back.png` |
| 1-2 | repos 2 | `assassin_back_idle_2.png` |
| 1-3 | repos 3 | `assassin_back_idle_3.png` |
| 1-4 | marche 1 | `assassin_back_walk.png` |
| 2-1 | marche 2 | `assassin_back_walk_2.png` |
| 2-2 | sort 1 | `assassin_back_cast.png` |
| 2-3 | sort 2 | `assassin_back_cast_2.png` |
| 2-4 | sort 3 | `assassin_back_cast_3.png` |

#### Planche 4 — Dos (3/4 arrière) · Attaques

Dans l'Atelier : personnage « Assassin », planche « Dos (3/4 arrière) · Attaques ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Assassin, hero of the Ombres nation. Agile assassin with black hair, a black cloth mask covering the lower face (eyes clearly visible), dark charcoal hooded armor with layered tattered silver-teal cloth panels, violet glowing rune details, a curved dagger in each hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. crouched wind-up, both daggers crossed in front of the chest.
2. dash slash forward, both arms extended, short violet shadow smoke slash crescents.
3. spinning follow-through, one dagger high, one low.
4. backhand stab, one dagger thrust forward, body twisted.
5. double downward stab, both daggers pointing down, knees bent.
6. rising cross slash, both arms opening upward.
7. low sweeping slash, crouched on one knee.
8. leaping strike, body in the air, daggers held forward.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `assassin_back_attack.png` |
| 1-2 | attaque 2 | `assassin_back_attack_2.png` |
| 1-3 | attaque 3 | `assassin_back_attack_3.png` |
| 1-4 | attaque 4 | `assassin_back_attack_4.png` |
| 2-1 | attaque 5 | `assassin_back_attack_5.png` |
| 2-2 | attaque 6 | `assassin_back_attack_6.png` |
| 2-3 | attaque 7 | `assassin_back_attack_7.png` |
| 2-4 | attaque 8 | `assassin_back_attack_8.png` |

L'export Zimut de l'Atelier copie aussi le repos vers `nations/heros/assassin.png` et les autres poses vers `nations/heros/poses/`.

## 3. Ennemis

### Assassin des ombres — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/ombres/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Assassin des ombres », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Assassin des ombres, enemy of the Ombres nation. Hunched shadow beast-assassin with a spiky purple mane and long claws.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, ready to pounce.
5. lunge forward, jaws or claws first, small violet shadow smoke impact.
6. follow-through, landing after the lunge.
7. second strike, swiping sideways.
8. head raised, violet shadow smoke gathering around the body.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `assassin_des_ombres.png` |
| 1-2 | repos 2 | `assassin_des_ombres_idle_2.png` |
| 1-3 | marche 1 | `assassin_des_ombres_walk.png` |
| 1-4 | attaque 1 | `assassin_des_ombres_attack.png` |
| 2-1 | attaque 2 | `assassin_des_ombres_attack_2.png` |
| 2-2 | attaque 3 | `assassin_des_ombres_attack_3.png` |
| 2-3 | attaque 4 | `assassin_des_ombres_attack_4.png` |
| 2-4 | sort 1 | `assassin_des_ombres_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Assassin des ombres », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Assassin des ombres, enemy of the Ombres nation. Hunched shadow beast-assassin with a spiky purple mane and long claws.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, ready to pounce.
5. lunge forward, jaws or claws first, small violet shadow smoke impact.
6. follow-through, landing after the lunge.
7. second strike, swiping sideways.
8. head raised, violet shadow smoke gathering around the body.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `assassin_des_ombres_back.png` |
| 1-2 | repos 2 | `assassin_des_ombres_back_idle_2.png` |
| 1-3 | marche 1 | `assassin_des_ombres_back_walk.png` |
| 1-4 | attaque 1 | `assassin_des_ombres_back_attack.png` |
| 2-1 | attaque 2 | `assassin_des_ombres_back_attack_2.png` |
| 2-2 | attaque 3 | `assassin_des_ombres_back_attack_3.png` |
| 2-3 | attaque 4 | `assassin_des_ombres_back_attack_4.png` |
| 2-4 | sort 1 | `assassin_des_ombres_back_cast.png` |

### Ombre infernale — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/ombres/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Ombre infernale », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Ombre infernale, enemy of the Ombres nation. Swirling mass of purple shadow with claws and glowing eyes.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. drawing back, body stretched upward.
5. lunging forward, claws of violet shadow smoke reaching out.
6. follow-through, body trailing behind.
7. spinning strike, violet shadow smoke whirl around the body.
8. hovering higher, violet shadow smoke orbs circling the body.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `ombre_infernale.png` |
| 1-2 | repos 2 | `ombre_infernale_idle_2.png` |
| 1-3 | marche 1 | `ombre_infernale_walk.png` |
| 1-4 | attaque 1 | `ombre_infernale_attack.png` |
| 2-1 | attaque 2 | `ombre_infernale_attack_2.png` |
| 2-2 | attaque 3 | `ombre_infernale_attack_3.png` |
| 2-3 | attaque 4 | `ombre_infernale_attack_4.png` |
| 2-4 | sort 1 | `ombre_infernale_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Ombre infernale », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Ombre infernale, enemy of the Ombres nation. Swirling mass of purple shadow with claws and glowing eyes.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. drawing back, body stretched upward.
5. lunging forward, claws of violet shadow smoke reaching out.
6. follow-through, body trailing behind.
7. spinning strike, violet shadow smoke whirl around the body.
8. hovering higher, violet shadow smoke orbs circling the body.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `ombre_infernale_back.png` |
| 1-2 | repos 2 | `ombre_infernale_back_idle_2.png` |
| 1-3 | marche 1 | `ombre_infernale_back_walk.png` |
| 1-4 | attaque 1 | `ombre_infernale_back_attack.png` |
| 2-1 | attaque 2 | `ombre_infernale_back_attack_2.png` |
| 2-2 | attaque 3 | `ombre_infernale_back_attack_3.png` |
| 2-3 | attaque 4 | `ombre_infernale_back_attack_4.png` |
| 2-4 | sort 1 | `ombre_infernale_back_cast.png` |

### Spectre — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/ombres/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Spectre », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Spectre, enemy of the Ombres nation. Violet spectral figure wrapped in shadow curls, long claw-like hands.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. drawing back, body stretched upward.
5. lunging forward, claws of violet shadow smoke reaching out.
6. follow-through, body trailing behind.
7. spinning strike, violet shadow smoke whirl around the body.
8. hovering higher, violet shadow smoke orbs circling the body.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `spectre.png` |
| 1-2 | repos 2 | `spectre_idle_2.png` |
| 1-3 | marche 1 | `spectre_walk.png` |
| 1-4 | attaque 1 | `spectre_attack.png` |
| 2-1 | attaque 2 | `spectre_attack_2.png` |
| 2-2 | attaque 3 | `spectre_attack_3.png` |
| 2-3 | attaque 4 | `spectre_attack_4.png` |
| 2-4 | sort 1 | `spectre_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Spectre », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Spectre, enemy of the Ombres nation. Violet spectral figure wrapped in shadow curls, long claw-like hands.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. drawing back, body stretched upward.
5. lunging forward, claws of violet shadow smoke reaching out.
6. follow-through, body trailing behind.
7. spinning strike, violet shadow smoke whirl around the body.
8. hovering higher, violet shadow smoke orbs circling the body.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `spectre_back.png` |
| 1-2 | repos 2 | `spectre_back_idle_2.png` |
| 1-3 | marche 1 | `spectre_back_walk.png` |
| 1-4 | attaque 1 | `spectre_back_attack.png` |
| 2-1 | attaque 2 | `spectre_back_attack_2.png` |
| 2-2 | attaque 3 | `spectre_back_attack_3.png` |
| 2-3 | attaque 4 | `spectre_back_attack_4.png` |
| 2-4 | sort 1 | `spectre_back_cast.png` |

### Liche — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/ombres/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Liche », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Liche, enemy of the Ombres nation. Tall dark purple lich in a spiked robe holding a staff.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. wind-up, staff held back with both hands.
5. staff swing forward, small violet shadow smoke burst at the tip.
6. follow-through, staff low, body turned.
7. thrust with the staff tip forward, short violet shadow smoke spark.
8. staff raised, violet shadow smoke orb forming at the top.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `liche.png` |
| 1-2 | repos 2 | `liche_idle_2.png` |
| 1-3 | marche 1 | `liche_walk.png` |
| 1-4 | attaque 1 | `liche_attack.png` |
| 2-1 | attaque 2 | `liche_attack_2.png` |
| 2-2 | attaque 3 | `liche_attack_3.png` |
| 2-3 | attaque 4 | `liche_attack_4.png` |
| 2-4 | sort 1 | `liche_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Liche », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Liche, enemy of the Ombres nation. Tall dark purple lich in a spiked robe holding a staff.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. wind-up, staff held back with both hands.
5. staff swing forward, small violet shadow smoke burst at the tip.
6. follow-through, staff low, body turned.
7. thrust with the staff tip forward, short violet shadow smoke spark.
8. staff raised, violet shadow smoke orb forming at the top.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `liche_back.png` |
| 1-2 | repos 2 | `liche_back_idle_2.png` |
| 1-3 | marche 1 | `liche_back_walk.png` |
| 1-4 | attaque 1 | `liche_back_attack.png` |
| 2-1 | attaque 2 | `liche_back_attack_2.png` |
| 2-2 | attaque 3 | `liche_back_attack_3.png` |
| 2-3 | attaque 4 | `liche_back_attack_4.png` |
| 2-4 | sort 1 | `liche_back_cast.png` |

## 4. Boss

### Nébulia l'Illusionniste — 32 poses

4 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/`.

#### Planche 1 — Face (3/4 avant) · Repos, marche et sorts

Dans l'Atelier : personnage « Nébulia l'Illusionniste », planche « Face (3/4 avant) · Repos, marche et sorts ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Nébulia l'Illusionniste, boss of the Ombres nation. Tall illusionist in black armor with spiky layers of silver-teal tattered cloth, horned mask-helm, long blades, mirror-like violet glints, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. kneeling, one hand on the ground, violet shadow smoke rising from the shadow below.
7. half vanished into violet shadow smoke, only the eyes and daggers clearly visible.
8. reappearing from a burst of violet shadow smoke, daggers ready.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `ombres.png` |
| 1-2 | repos 2 | `ombres_idle_2.png` |
| 1-3 | repos 3 | `ombres_idle_3.png` |
| 1-4 | marche 1 | `ombres_walk.png` |
| 2-1 | marche 2 | `ombres_walk_2.png` |
| 2-2 | sort 1 | `ombres_cast.png` |
| 2-3 | sort 2 | `ombres_cast_2.png` |
| 2-4 | sort 3 | `ombres_cast_3.png` |

#### Planche 2 — Face (3/4 avant) · Attaques

Dans l'Atelier : personnage « Nébulia l'Illusionniste », planche « Face (3/4 avant) · Attaques ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Nébulia l'Illusionniste, boss of the Ombres nation. Tall illusionist in black armor with spiky layers of silver-teal tattered cloth, horned mask-helm, long blades, mirror-like violet glints, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. crouched wind-up, both daggers crossed in front of the chest.
2. dash slash forward, both arms extended, short violet shadow smoke slash crescents.
3. spinning follow-through, one dagger high, one low.
4. backhand stab, one dagger thrust forward, body twisted.
5. double downward stab, both daggers pointing down, knees bent.
6. rising cross slash, both arms opening upward.
7. low sweeping slash, crouched on one knee.
8. leaping strike, body in the air, daggers held forward.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `ombres_attack.png` |
| 1-2 | attaque 2 | `ombres_attack_2.png` |
| 1-3 | attaque 3 | `ombres_attack_3.png` |
| 1-4 | attaque 4 | `ombres_attack_4.png` |
| 2-1 | attaque 5 | `ombres_attack_5.png` |
| 2-2 | attaque 6 | `ombres_attack_6.png` |
| 2-3 | attaque 7 | `ombres_attack_7.png` |
| 2-4 | attaque 8 | `ombres_attack_8.png` |

#### Planche 3 — Dos (3/4 arrière) · Repos, marche et sorts

Dans l'Atelier : personnage « Nébulia l'Illusionniste », planche « Dos (3/4 arrière) · Repos, marche et sorts ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Nébulia l'Illusionniste, boss of the Ombres nation. Tall illusionist in black armor with spiky layers of silver-teal tattered cloth, horned mask-helm, long blades, mirror-like violet glints, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. kneeling, one hand on the ground, violet shadow smoke rising from the shadow below.
7. half vanished into violet shadow smoke, only the eyes and daggers clearly visible.
8. reappearing from a burst of violet shadow smoke, daggers ready.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `ombres_back.png` |
| 1-2 | repos 2 | `ombres_back_idle_2.png` |
| 1-3 | repos 3 | `ombres_back_idle_3.png` |
| 1-4 | marche 1 | `ombres_back_walk.png` |
| 2-1 | marche 2 | `ombres_back_walk_2.png` |
| 2-2 | sort 1 | `ombres_back_cast.png` |
| 2-3 | sort 2 | `ombres_back_cast_2.png` |
| 2-4 | sort 3 | `ombres_back_cast_3.png` |

#### Planche 4 — Dos (3/4 arrière) · Attaques

Dans l'Atelier : personnage « Nébulia l'Illusionniste », planche « Dos (3/4 arrière) · Attaques ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Nébulia l'Illusionniste, boss of the Ombres nation. Tall illusionist in black armor with spiky layers of silver-teal tattered cloth, horned mask-helm, long blades, mirror-like violet glints, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. crouched wind-up, both daggers crossed in front of the chest.
2. dash slash forward, both arms extended, short violet shadow smoke slash crescents.
3. spinning follow-through, one dagger high, one low.
4. backhand stab, one dagger thrust forward, body twisted.
5. double downward stab, both daggers pointing down, knees bent.
6. rising cross slash, both arms opening upward.
7. low sweeping slash, crouched on one knee.
8. leaping strike, body in the air, daggers held forward.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `ombres_back_attack.png` |
| 1-2 | attaque 2 | `ombres_back_attack_2.png` |
| 1-3 | attaque 3 | `ombres_back_attack_3.png` |
| 1-4 | attaque 4 | `ombres_back_attack_4.png` |
| 2-1 | attaque 5 | `ombres_back_attack_5.png` |
| 2-2 | attaque 6 | `ombres_back_attack_6.png` |
| 2-3 | attaque 7 | `ombres_back_attack_7.png` |
| 2-4 | attaque 8 | `ombres_back_attack_8.png` |

## Prompt négatif (toutes les planches de cette page)

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art
```
