# Nation Cristaux (Cristaux)

Palette : silver white, sapphire blue, amethyst violet. Effets : prismatic blue and violet crystal shards. Contre-jour : violet.

Chaque personnage est dessiné en **vue 3/4 avant (face)** et en **vue 3/4 arrière (dos)**. Le jeu retourne l'image pour les directions vers la gauche. Toutes les planches sont des grilles 4 × 2 aux cases bien séparées. Prompt négatif : voir en bas de page.

Ordre conseillé : 1) planche de référence, 2) héros, 3) ennemis, 4) boss.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos. Joins-la comme image de référence à toutes les planches suivantes.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Cristaux nation (Cristaux biome).
NATION PALETTE: silver white, sapphire blue, amethyst violet. Signature effects: prismatic blue and violet crystal shards.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: two rows with the same 6 characters in the same order, all in idle pose. Top row: 3/4 front view, facing front-right. Bottom row: 3/4 back view, seen from behind, turned toward the upper right. All feet of a row on the same ground line. Leave a wide empty gap (at least half a character width) between characters and between the two rows: nobody overlaps or touches anyone, weapons and capes included. Image aspect ratio 2:1, as large as possible.
CHARACTERS, left to right:
1. the hero (Mage: young mage with dark blue hair, long silver-white robe with crystal patterns and sapphire trims, an ornate silver staff topped with a glowing blue crystal in the right hand).
2. Araignée de cristal (spider made of violet amethyst crystals with ice-blue glowing legs).
3. Mage cristallin (slender crystal mage with violet crystal hair and a pale blue body, crystal staff).
4. Golem de cristal (heavy golem made of violet and blue crystal clusters).
5. Élémentaire de cristal (floating elemental made of sharp violet crystal shards in a humanoid shape).
6. the final boss Zyphéron le Cristallin (tall crystal sorcerer with a crown of ice-blue shards, long robe of shattered pale crystal plates, holding an ornate crystal staff), about 1.5x taller than the others.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Mage — 32 poses

4 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/players/`.

#### Planche 1 — Face (3/4 avant) · Repos, marche et sorts

Dans l'Atelier : personnage « Mage », planche « Face (3/4 avant) · Repos, marche et sorts ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Mage, hero of the Cristaux nation. Young mage with dark blue hair, long silver-white robe with crystal patterns and sapphire trims, an ornate silver staff topped with a glowing blue crystal in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. staff raised, prismatic blue and violet crystal shards orb forming at the top.
7. staff held high with both hands, prismatic blue and violet crystal shards swirling around.
8. staff pointed forward, releasing a compact prismatic blue and violet crystal shards blast.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `mage.png` |
| 1-2 | repos 2 | `mage_idle_2.png` |
| 1-3 | repos 3 | `mage_idle_3.png` |
| 1-4 | marche 1 | `mage_walk.png` |
| 2-1 | marche 2 | `mage_walk_2.png` |
| 2-2 | sort 1 | `mage_cast.png` |
| 2-3 | sort 2 | `mage_cast_2.png` |
| 2-4 | sort 3 | `mage_cast_3.png` |

#### Planche 2 — Face (3/4 avant) · Attaques

Dans l'Atelier : personnage « Mage », planche « Face (3/4 avant) · Attaques ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Mage, hero of the Cristaux nation. Young mage with dark blue hair, long silver-white robe with crystal patterns and sapphire trims, an ornate silver staff topped with a glowing blue crystal in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. wind-up, staff held back with both hands.
2. staff swing forward, small prismatic blue and violet crystal shards burst at the tip.
3. follow-through, staff low, body turned.
4. thrust with the staff tip forward, short prismatic blue and violet crystal shards spark.
5. overhead staff strike, both hands high.
6. spinning the staff around the body, small prismatic blue and violet crystal shards trail.
7. low sweep with the staff at the feet.
8. staff planted, kicking forward with one leg.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `mage_attack.png` |
| 1-2 | attaque 2 | `mage_attack_2.png` |
| 1-3 | attaque 3 | `mage_attack_3.png` |
| 1-4 | attaque 4 | `mage_attack_4.png` |
| 2-1 | attaque 5 | `mage_attack_5.png` |
| 2-2 | attaque 6 | `mage_attack_6.png` |
| 2-3 | attaque 7 | `mage_attack_7.png` |
| 2-4 | attaque 8 | `mage_attack_8.png` |

#### Planche 3 — Dos (3/4 arrière) · Repos, marche et sorts

Dans l'Atelier : personnage « Mage », planche « Dos (3/4 arrière) · Repos, marche et sorts ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Mage, hero of the Cristaux nation. Young mage with dark blue hair, long silver-white robe with crystal patterns and sapphire trims, an ornate silver staff topped with a glowing blue crystal in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. staff raised, prismatic blue and violet crystal shards orb forming at the top.
7. staff held high with both hands, prismatic blue and violet crystal shards swirling around.
8. staff pointed forward, releasing a compact prismatic blue and violet crystal shards blast.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `mage_back.png` |
| 1-2 | repos 2 | `mage_back_idle_2.png` |
| 1-3 | repos 3 | `mage_back_idle_3.png` |
| 1-4 | marche 1 | `mage_back_walk.png` |
| 2-1 | marche 2 | `mage_back_walk_2.png` |
| 2-2 | sort 1 | `mage_back_cast.png` |
| 2-3 | sort 2 | `mage_back_cast_2.png` |
| 2-4 | sort 3 | `mage_back_cast_3.png` |

#### Planche 4 — Dos (3/4 arrière) · Attaques

Dans l'Atelier : personnage « Mage », planche « Dos (3/4 arrière) · Attaques ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Mage, hero of the Cristaux nation. Young mage with dark blue hair, long silver-white robe with crystal patterns and sapphire trims, an ornate silver staff topped with a glowing blue crystal in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. wind-up, staff held back with both hands.
2. staff swing forward, small prismatic blue and violet crystal shards burst at the tip.
3. follow-through, staff low, body turned.
4. thrust with the staff tip forward, short prismatic blue and violet crystal shards spark.
5. overhead staff strike, both hands high.
6. spinning the staff around the body, small prismatic blue and violet crystal shards trail.
7. low sweep with the staff at the feet.
8. staff planted, kicking forward with one leg.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `mage_back_attack.png` |
| 1-2 | attaque 2 | `mage_back_attack_2.png` |
| 1-3 | attaque 3 | `mage_back_attack_3.png` |
| 1-4 | attaque 4 | `mage_back_attack_4.png` |
| 2-1 | attaque 5 | `mage_back_attack_5.png` |
| 2-2 | attaque 6 | `mage_back_attack_6.png` |
| 2-3 | attaque 7 | `mage_back_attack_7.png` |
| 2-4 | attaque 8 | `mage_back_attack_8.png` |

L'export Zimut de l'Atelier copie aussi le repos vers `nations/heros/mage.png` et les autres poses vers `nations/heros/poses/`.

## 3. Ennemis

### Araignée de cristal — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cristaux/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Araignée de cristal », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Araignée de cristal, enemy of the Cristaux nation. Spider made of violet amethyst crystals with ice-blue glowing legs.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, ready to pounce.
5. lunge forward, jaws or claws first, small prismatic blue and violet crystal shards impact.
6. follow-through, landing after the lunge.
7. second strike, swiping sideways.
8. head raised, prismatic blue and violet crystal shards gathering around the body.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `araignee_de_cristal.png` |
| 1-2 | repos 2 | `araignee_de_cristal_idle_2.png` |
| 1-3 | marche 1 | `araignee_de_cristal_walk.png` |
| 1-4 | attaque 1 | `araignee_de_cristal_attack.png` |
| 2-1 | attaque 2 | `araignee_de_cristal_attack_2.png` |
| 2-2 | attaque 3 | `araignee_de_cristal_attack_3.png` |
| 2-3 | attaque 4 | `araignee_de_cristal_attack_4.png` |
| 2-4 | sort 1 | `araignee_de_cristal_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Araignée de cristal », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Araignée de cristal, enemy of the Cristaux nation. Spider made of violet amethyst crystals with ice-blue glowing legs.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, ready to pounce.
5. lunge forward, jaws or claws first, small prismatic blue and violet crystal shards impact.
6. follow-through, landing after the lunge.
7. second strike, swiping sideways.
8. head raised, prismatic blue and violet crystal shards gathering around the body.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `araignee_de_cristal_back.png` |
| 1-2 | repos 2 | `araignee_de_cristal_back_idle_2.png` |
| 1-3 | marche 1 | `araignee_de_cristal_back_walk.png` |
| 1-4 | attaque 1 | `araignee_de_cristal_back_attack.png` |
| 2-1 | attaque 2 | `araignee_de_cristal_back_attack_2.png` |
| 2-2 | attaque 3 | `araignee_de_cristal_back_attack_3.png` |
| 2-3 | attaque 4 | `araignee_de_cristal_back_attack_4.png` |
| 2-4 | sort 1 | `araignee_de_cristal_back_cast.png` |

### Mage cristallin — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cristaux/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Mage cristallin », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Mage cristallin, enemy of the Cristaux nation. Slender crystal mage with violet crystal hair and a pale blue body, crystal staff.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. wind-up, staff held back with both hands.
5. staff swing forward, small prismatic blue and violet crystal shards burst at the tip.
6. follow-through, staff low, body turned.
7. thrust with the staff tip forward, short prismatic blue and violet crystal shards spark.
8. staff raised, prismatic blue and violet crystal shards orb forming at the top.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `mage_cristallin.png` |
| 1-2 | repos 2 | `mage_cristallin_idle_2.png` |
| 1-3 | marche 1 | `mage_cristallin_walk.png` |
| 1-4 | attaque 1 | `mage_cristallin_attack.png` |
| 2-1 | attaque 2 | `mage_cristallin_attack_2.png` |
| 2-2 | attaque 3 | `mage_cristallin_attack_3.png` |
| 2-3 | attaque 4 | `mage_cristallin_attack_4.png` |
| 2-4 | sort 1 | `mage_cristallin_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Mage cristallin », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Mage cristallin, enemy of the Cristaux nation. Slender crystal mage with violet crystal hair and a pale blue body, crystal staff.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. wind-up, staff held back with both hands.
5. staff swing forward, small prismatic blue and violet crystal shards burst at the tip.
6. follow-through, staff low, body turned.
7. thrust with the staff tip forward, short prismatic blue and violet crystal shards spark.
8. staff raised, prismatic blue and violet crystal shards orb forming at the top.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `mage_cristallin_back.png` |
| 1-2 | repos 2 | `mage_cristallin_back_idle_2.png` |
| 1-3 | marche 1 | `mage_cristallin_back_walk.png` |
| 1-4 | attaque 1 | `mage_cristallin_back_attack.png` |
| 2-1 | attaque 2 | `mage_cristallin_back_attack_2.png` |
| 2-2 | attaque 3 | `mage_cristallin_back_attack_3.png` |
| 2-3 | attaque 4 | `mage_cristallin_back_attack_4.png` |
| 2-4 | sort 1 | `mage_cristallin_back_cast.png` |

### Golem de cristal — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cristaux/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Golem de cristal », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Golem de cristal, enemy of the Cristaux nation. Heavy golem made of violet and blue crystal clusters.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. wind-up, fist or weapon raised high.
5. heavy smash forward, ground cracking with a small prismatic blue and violet crystal shards burst.
6. follow-through, body leaning forward.
7. sweeping backhand blow.
8. stomping, prismatic blue and violet crystal shards cracks spreading under the feet.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `golem_de_cristal.png` |
| 1-2 | repos 2 | `golem_de_cristal_idle_2.png` |
| 1-3 | marche 1 | `golem_de_cristal_walk.png` |
| 1-4 | attaque 1 | `golem_de_cristal_attack.png` |
| 2-1 | attaque 2 | `golem_de_cristal_attack_2.png` |
| 2-2 | attaque 3 | `golem_de_cristal_attack_3.png` |
| 2-3 | attaque 4 | `golem_de_cristal_attack_4.png` |
| 2-4 | sort 1 | `golem_de_cristal_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Golem de cristal », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Golem de cristal, enemy of the Cristaux nation. Heavy golem made of violet and blue crystal clusters.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. wind-up, fist or weapon raised high.
5. heavy smash forward, ground cracking with a small prismatic blue and violet crystal shards burst.
6. follow-through, body leaning forward.
7. sweeping backhand blow.
8. stomping, prismatic blue and violet crystal shards cracks spreading under the feet.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `golem_de_cristal_back.png` |
| 1-2 | repos 2 | `golem_de_cristal_back_idle_2.png` |
| 1-3 | marche 1 | `golem_de_cristal_back_walk.png` |
| 1-4 | attaque 1 | `golem_de_cristal_back_attack.png` |
| 2-1 | attaque 2 | `golem_de_cristal_back_attack_2.png` |
| 2-2 | attaque 3 | `golem_de_cristal_back_attack_3.png` |
| 2-3 | attaque 4 | `golem_de_cristal_back_attack_4.png` |
| 2-4 | sort 1 | `golem_de_cristal_back_cast.png` |

### Élémentaire de cristal — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cristaux/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Élémentaire de cristal », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Élémentaire de cristal, enemy of the Cristaux nation. Floating elemental made of sharp violet crystal shards in a humanoid shape.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. drawing back, body stretched upward.
5. lunging forward, claws of prismatic blue and violet crystal shards reaching out.
6. follow-through, body trailing behind.
7. spinning strike, prismatic blue and violet crystal shards whirl around the body.
8. hovering higher, prismatic blue and violet crystal shards orbs circling the body.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
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
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Élémentaire de cristal, enemy of the Cristaux nation. Floating elemental made of sharp violet crystal shards in a humanoid shape.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. drawing back, body stretched upward.
5. lunging forward, claws of prismatic blue and violet crystal shards reaching out.
6. follow-through, body trailing behind.
7. spinning strike, prismatic blue and violet crystal shards whirl around the body.
8. hovering higher, prismatic blue and violet crystal shards orbs circling the body.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
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

## 4. Boss

### Zyphéron le Cristallin — 32 poses

4 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/`.

#### Planche 1 — Face (3/4 avant) · Repos, marche et sorts

Dans l'Atelier : personnage « Zyphéron le Cristallin », planche « Face (3/4 avant) · Repos, marche et sorts ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Zyphéron le Cristallin, boss of the Cristaux nation. Tall crystal sorcerer with a crown of ice-blue shards, long robe of shattered pale crystal plates, holding an ornate crystal staff, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. staff raised, prismatic blue and violet crystal shards orb forming at the top.
7. staff held high with both hands, prismatic blue and violet crystal shards swirling around.
8. staff pointed forward, releasing a compact prismatic blue and violet crystal shards blast.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `cristaux.png` |
| 1-2 | repos 2 | `cristaux_idle_2.png` |
| 1-3 | repos 3 | `cristaux_idle_3.png` |
| 1-4 | marche 1 | `cristaux_walk.png` |
| 2-1 | marche 2 | `cristaux_walk_2.png` |
| 2-2 | sort 1 | `cristaux_cast.png` |
| 2-3 | sort 2 | `cristaux_cast_2.png` |
| 2-4 | sort 3 | `cristaux_cast_3.png` |

#### Planche 2 — Face (3/4 avant) · Attaques

Dans l'Atelier : personnage « Zyphéron le Cristallin », planche « Face (3/4 avant) · Attaques ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Zyphéron le Cristallin, boss of the Cristaux nation. Tall crystal sorcerer with a crown of ice-blue shards, long robe of shattered pale crystal plates, holding an ornate crystal staff, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. wind-up, staff held back with both hands.
2. staff swing forward, small prismatic blue and violet crystal shards burst at the tip.
3. follow-through, staff low, body turned.
4. thrust with the staff tip forward, short prismatic blue and violet crystal shards spark.
5. overhead staff strike, both hands high.
6. spinning the staff around the body, small prismatic blue and violet crystal shards trail.
7. low sweep with the staff at the feet.
8. staff planted, kicking forward with one leg.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `cristaux_attack.png` |
| 1-2 | attaque 2 | `cristaux_attack_2.png` |
| 1-3 | attaque 3 | `cristaux_attack_3.png` |
| 1-4 | attaque 4 | `cristaux_attack_4.png` |
| 2-1 | attaque 5 | `cristaux_attack_5.png` |
| 2-2 | attaque 6 | `cristaux_attack_6.png` |
| 2-3 | attaque 7 | `cristaux_attack_7.png` |
| 2-4 | attaque 8 | `cristaux_attack_8.png` |

#### Planche 3 — Dos (3/4 arrière) · Repos, marche et sorts

Dans l'Atelier : personnage « Zyphéron le Cristallin », planche « Dos (3/4 arrière) · Repos, marche et sorts ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Zyphéron le Cristallin, boss of the Cristaux nation. Tall crystal sorcerer with a crown of ice-blue shards, long robe of shattered pale crystal plates, holding an ornate crystal staff, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. staff raised, prismatic blue and violet crystal shards orb forming at the top.
7. staff held high with both hands, prismatic blue and violet crystal shards swirling around.
8. staff pointed forward, releasing a compact prismatic blue and violet crystal shards blast.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `cristaux_back.png` |
| 1-2 | repos 2 | `cristaux_back_idle_2.png` |
| 1-3 | repos 3 | `cristaux_back_idle_3.png` |
| 1-4 | marche 1 | `cristaux_back_walk.png` |
| 2-1 | marche 2 | `cristaux_back_walk_2.png` |
| 2-2 | sort 1 | `cristaux_back_cast.png` |
| 2-3 | sort 2 | `cristaux_back_cast_2.png` |
| 2-4 | sort 3 | `cristaux_back_cast_3.png` |

#### Planche 4 — Dos (3/4 arrière) · Attaques

Dans l'Atelier : personnage « Zyphéron le Cristallin », planche « Dos (3/4 arrière) · Attaques ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Zyphéron le Cristallin, boss of the Cristaux nation. Tall crystal sorcerer with a crown of ice-blue shards, long robe of shattered pale crystal plates, holding an ornate crystal staff, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. wind-up, staff held back with both hands.
2. staff swing forward, small prismatic blue and violet crystal shards burst at the tip.
3. follow-through, staff low, body turned.
4. thrust with the staff tip forward, short prismatic blue and violet crystal shards spark.
5. overhead staff strike, both hands high.
6. spinning the staff around the body, small prismatic blue and violet crystal shards trail.
7. low sweep with the staff at the feet.
8. staff planted, kicking forward with one leg.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `cristaux_back_attack.png` |
| 1-2 | attaque 2 | `cristaux_back_attack_2.png` |
| 1-3 | attaque 3 | `cristaux_back_attack_3.png` |
| 1-4 | attaque 4 | `cristaux_back_attack_4.png` |
| 2-1 | attaque 5 | `cristaux_back_attack_5.png` |
| 2-2 | attaque 6 | `cristaux_back_attack_6.png` |
| 2-3 | attaque 7 | `cristaux_back_attack_7.png` |
| 2-4 | attaque 8 | `cristaux_back_attack_8.png` |

## Prompt négatif (toutes les planches de cette page)

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art
```
