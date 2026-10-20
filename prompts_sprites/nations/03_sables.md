# Nation Sables (Désert)

Palette : sand gold, terracotta, amber, small turquoise accents. Effets : swirling sand and amber shards. Contre-jour : warm golden.

Chaque personnage est dessiné en **vue 3/4 avant (face)** et en **vue 3/4 arrière (dos)**. Le jeu retourne l'image pour les directions vers la gauche. Toutes les planches sont des grilles 4 × 2 aux cases bien séparées. Prompt négatif : voir en bas de page.

Ordre conseillé : 1) planche de référence, 2) héros, 3) ennemis, 4) boss.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos. Joins-la comme image de référence à toutes les planches suivantes.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Sables nation (Désert biome).
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents. Signature effects: swirling sand and amber shards.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: two rows with the same 6 characters in the same order, all in idle pose. Top row: 3/4 front view, facing front-right. Bottom row: 3/4 back view, seen from behind, turned toward the upper right. All feet of a row on the same ground line. Leave a wide empty gap (at least half a character width) between characters and between the two rows: nobody overlaps or touches anyone, weapons and capes included. Image aspect ratio 2:1, as large as possible.
CHARACTERS, left to right:
1. the hero (Géomancien: young geomancer with short brown hair, layered sand-gold robe with terracotta panels and amber gems, sandals and wraps, a golden staff topped with a large faceted amber crystal in the right hand).
2. Bandit des dunes (small desert jackal-folk bandit with orange fur, a sand-colored scarf and a curved dagger).
3. Scarabée géant (giant scarab beetle with a black and gold shell and golden horns).
4. Génie du désert (golden sand djinn with muscular arms and a lower body of swirling sand).
5. Sphinx (golden lion sphinx wearing a striped pharaoh headdress).
6. the final boss Zahor le Sableux (sand sovereign in ornate golden armor with sharp layered plates, crested golden helm, holding a tall golden staff with a giant amber crystal), about 1.5x taller than the others.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Géomancien — 32 poses

4 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/players/`.

#### Planche 1 — Face (3/4 avant) · Repos, marche et sorts

Dans l'Atelier : personnage « Géomancien », planche « Face (3/4 avant) · Repos, marche et sorts ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Géomancien, hero of the Sables nation. Young geomancer with short brown hair, layered sand-gold robe with terracotta panels and amber gems, sandals and wraps, a golden staff topped with a large faceted amber crystal in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. staff raised, swirling sand and amber shards orb forming at the top.
7. staff held high with both hands, swirling sand and amber shards swirling around.
8. staff pointed forward, releasing a compact swirling sand and amber shards blast.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `geomancien.png` |
| 1-2 | repos 2 | `geomancien_idle_2.png` |
| 1-3 | repos 3 | `geomancien_idle_3.png` |
| 1-4 | marche 1 | `geomancien_walk.png` |
| 2-1 | marche 2 | `geomancien_walk_2.png` |
| 2-2 | sort 1 | `geomancien_cast.png` |
| 2-3 | sort 2 | `geomancien_cast_2.png` |
| 2-4 | sort 3 | `geomancien_cast_3.png` |

#### Planche 2 — Face (3/4 avant) · Attaques

Dans l'Atelier : personnage « Géomancien », planche « Face (3/4 avant) · Attaques ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Géomancien, hero of the Sables nation. Young geomancer with short brown hair, layered sand-gold robe with terracotta panels and amber gems, sandals and wraps, a golden staff topped with a large faceted amber crystal in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. wind-up, staff held back with both hands.
2. staff swing forward, small swirling sand and amber shards burst at the tip.
3. follow-through, staff low, body turned.
4. thrust with the staff tip forward, short swirling sand and amber shards spark.
5. overhead staff strike, both hands high.
6. spinning the staff around the body, small swirling sand and amber shards trail.
7. low sweep with the staff at the feet.
8. staff planted, kicking forward with one leg.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `geomancien_attack.png` |
| 1-2 | attaque 2 | `geomancien_attack_2.png` |
| 1-3 | attaque 3 | `geomancien_attack_3.png` |
| 1-4 | attaque 4 | `geomancien_attack_4.png` |
| 2-1 | attaque 5 | `geomancien_attack_5.png` |
| 2-2 | attaque 6 | `geomancien_attack_6.png` |
| 2-3 | attaque 7 | `geomancien_attack_7.png` |
| 2-4 | attaque 8 | `geomancien_attack_8.png` |

#### Planche 3 — Dos (3/4 arrière) · Repos, marche et sorts

Dans l'Atelier : personnage « Géomancien », planche « Dos (3/4 arrière) · Repos, marche et sorts ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Géomancien, hero of the Sables nation. Young geomancer with short brown hair, layered sand-gold robe with terracotta panels and amber gems, sandals and wraps, a golden staff topped with a large faceted amber crystal in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. staff raised, swirling sand and amber shards orb forming at the top.
7. staff held high with both hands, swirling sand and amber shards swirling around.
8. staff pointed forward, releasing a compact swirling sand and amber shards blast.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `geomancien_back.png` |
| 1-2 | repos 2 | `geomancien_back_idle_2.png` |
| 1-3 | repos 3 | `geomancien_back_idle_3.png` |
| 1-4 | marche 1 | `geomancien_back_walk.png` |
| 2-1 | marche 2 | `geomancien_back_walk_2.png` |
| 2-2 | sort 1 | `geomancien_back_cast.png` |
| 2-3 | sort 2 | `geomancien_back_cast_2.png` |
| 2-4 | sort 3 | `geomancien_back_cast_3.png` |

#### Planche 4 — Dos (3/4 arrière) · Attaques

Dans l'Atelier : personnage « Géomancien », planche « Dos (3/4 arrière) · Attaques ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Géomancien, hero of the Sables nation. Young geomancer with short brown hair, layered sand-gold robe with terracotta panels and amber gems, sandals and wraps, a golden staff topped with a large faceted amber crystal in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. wind-up, staff held back with both hands.
2. staff swing forward, small swirling sand and amber shards burst at the tip.
3. follow-through, staff low, body turned.
4. thrust with the staff tip forward, short swirling sand and amber shards spark.
5. overhead staff strike, both hands high.
6. spinning the staff around the body, small swirling sand and amber shards trail.
7. low sweep with the staff at the feet.
8. staff planted, kicking forward with one leg.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `geomancien_back_attack.png` |
| 1-2 | attaque 2 | `geomancien_back_attack_2.png` |
| 1-3 | attaque 3 | `geomancien_back_attack_3.png` |
| 1-4 | attaque 4 | `geomancien_back_attack_4.png` |
| 2-1 | attaque 5 | `geomancien_back_attack_5.png` |
| 2-2 | attaque 6 | `geomancien_back_attack_6.png` |
| 2-3 | attaque 7 | `geomancien_back_attack_7.png` |
| 2-4 | attaque 8 | `geomancien_back_attack_8.png` |

L'export Zimut de l'Atelier copie aussi le repos vers `nations/heros/geomancien.png` et les autres poses vers `nations/heros/poses/`.

## 3. Ennemis

### Bandit des dunes — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sables/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Bandit des dunes », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Bandit des dunes, enemy of the Sables nation. Small desert jackal-folk bandit with orange fur, a sand-colored scarf and a curved dagger.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, both daggers crossed in front of the chest.
5. dash slash forward, both arms extended, short swirling sand and amber shards slash crescents.
6. spinning follow-through, one dagger high, one low.
7. backhand stab, one dagger thrust forward, body twisted.
8. kneeling, one hand on the ground, swirling sand and amber shards rising from the shadow below.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `bandit_des_dunes.png` |
| 1-2 | repos 2 | `bandit_des_dunes_idle_2.png` |
| 1-3 | marche 1 | `bandit_des_dunes_walk.png` |
| 1-4 | attaque 1 | `bandit_des_dunes_attack.png` |
| 2-1 | attaque 2 | `bandit_des_dunes_attack_2.png` |
| 2-2 | attaque 3 | `bandit_des_dunes_attack_3.png` |
| 2-3 | attaque 4 | `bandit_des_dunes_attack_4.png` |
| 2-4 | sort 1 | `bandit_des_dunes_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Bandit des dunes », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Bandit des dunes, enemy of the Sables nation. Small desert jackal-folk bandit with orange fur, a sand-colored scarf and a curved dagger.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, both daggers crossed in front of the chest.
5. dash slash forward, both arms extended, short swirling sand and amber shards slash crescents.
6. spinning follow-through, one dagger high, one low.
7. backhand stab, one dagger thrust forward, body twisted.
8. kneeling, one hand on the ground, swirling sand and amber shards rising from the shadow below.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `bandit_des_dunes_back.png` |
| 1-2 | repos 2 | `bandit_des_dunes_back_idle_2.png` |
| 1-3 | marche 1 | `bandit_des_dunes_back_walk.png` |
| 1-4 | attaque 1 | `bandit_des_dunes_back_attack.png` |
| 2-1 | attaque 2 | `bandit_des_dunes_back_attack_2.png` |
| 2-2 | attaque 3 | `bandit_des_dunes_back_attack_3.png` |
| 2-3 | attaque 4 | `bandit_des_dunes_back_attack_4.png` |
| 2-4 | sort 1 | `bandit_des_dunes_back_cast.png` |

### Scarabée géant — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sables/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Scarabée géant », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Scarabée géant, enemy of the Sables nation. Giant scarab beetle with a black and gold shell and golden horns.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, ready to pounce.
5. lunge forward, jaws or claws first, small swirling sand and amber shards impact.
6. follow-through, landing after the lunge.
7. second strike, swiping sideways.
8. head raised, swirling sand and amber shards gathering around the body.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `scarabee_geant.png` |
| 1-2 | repos 2 | `scarabee_geant_idle_2.png` |
| 1-3 | marche 1 | `scarabee_geant_walk.png` |
| 1-4 | attaque 1 | `scarabee_geant_attack.png` |
| 2-1 | attaque 2 | `scarabee_geant_attack_2.png` |
| 2-2 | attaque 3 | `scarabee_geant_attack_3.png` |
| 2-3 | attaque 4 | `scarabee_geant_attack_4.png` |
| 2-4 | sort 1 | `scarabee_geant_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Scarabée géant », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Scarabée géant, enemy of the Sables nation. Giant scarab beetle with a black and gold shell and golden horns.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, ready to pounce.
5. lunge forward, jaws or claws first, small swirling sand and amber shards impact.
6. follow-through, landing after the lunge.
7. second strike, swiping sideways.
8. head raised, swirling sand and amber shards gathering around the body.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `scarabee_geant_back.png` |
| 1-2 | repos 2 | `scarabee_geant_back_idle_2.png` |
| 1-3 | marche 1 | `scarabee_geant_back_walk.png` |
| 1-4 | attaque 1 | `scarabee_geant_back_attack.png` |
| 2-1 | attaque 2 | `scarabee_geant_back_attack_2.png` |
| 2-2 | attaque 3 | `scarabee_geant_back_attack_3.png` |
| 2-3 | attaque 4 | `scarabee_geant_back_attack_4.png` |
| 2-4 | sort 1 | `scarabee_geant_back_cast.png` |

### Génie du désert — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sables/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Génie du désert », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Génie du désert, enemy of the Sables nation. Golden sand djinn with muscular arms and a lower body of swirling sand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. drawing back, body stretched upward.
5. lunging forward, claws of swirling sand and amber shards reaching out.
6. follow-through, body trailing behind.
7. spinning strike, swirling sand and amber shards whirl around the body.
8. hovering higher, swirling sand and amber shards orbs circling the body.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `genie_du_desert.png` |
| 1-2 | repos 2 | `genie_du_desert_idle_2.png` |
| 1-3 | marche 1 | `genie_du_desert_walk.png` |
| 1-4 | attaque 1 | `genie_du_desert_attack.png` |
| 2-1 | attaque 2 | `genie_du_desert_attack_2.png` |
| 2-2 | attaque 3 | `genie_du_desert_attack_3.png` |
| 2-3 | attaque 4 | `genie_du_desert_attack_4.png` |
| 2-4 | sort 1 | `genie_du_desert_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Génie du désert », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Génie du désert, enemy of the Sables nation. Golden sand djinn with muscular arms and a lower body of swirling sand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. drawing back, body stretched upward.
5. lunging forward, claws of swirling sand and amber shards reaching out.
6. follow-through, body trailing behind.
7. spinning strike, swirling sand and amber shards whirl around the body.
8. hovering higher, swirling sand and amber shards orbs circling the body.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `genie_du_desert_back.png` |
| 1-2 | repos 2 | `genie_du_desert_back_idle_2.png` |
| 1-3 | marche 1 | `genie_du_desert_back_walk.png` |
| 1-4 | attaque 1 | `genie_du_desert_back_attack.png` |
| 2-1 | attaque 2 | `genie_du_desert_back_attack_2.png` |
| 2-2 | attaque 3 | `genie_du_desert_back_attack_3.png` |
| 2-3 | attaque 4 | `genie_du_desert_back_attack_4.png` |
| 2-4 | sort 1 | `genie_du_desert_back_cast.png` |

### Sphinx — 16 poses

2 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sables/`.

#### Planche 1 — Face (3/4 avant)

Dans l'Atelier : personnage « Sphinx », planche « Face (3/4 avant) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Sphinx, enemy of the Sables nation. Golden lion sphinx wearing a striped pharaoh headdress.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, ready to pounce.
5. lunge forward, jaws or claws first, small swirling sand and amber shards impact.
6. follow-through, landing after the lunge.
7. second strike, swiping sideways.
8. head raised, swirling sand and amber shards gathering around the body.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `sphinx.png` |
| 1-2 | repos 2 | `sphinx_idle_2.png` |
| 1-3 | marche 1 | `sphinx_walk.png` |
| 1-4 | attaque 1 | `sphinx_attack.png` |
| 2-1 | attaque 2 | `sphinx_attack_2.png` |
| 2-2 | attaque 3 | `sphinx_attack_3.png` |
| 2-3 | attaque 4 | `sphinx_attack_4.png` |
| 2-4 | sort 1 | `sphinx_cast.png` |

#### Planche 2 — Dos (3/4 arrière)

Dans l'Atelier : personnage « Sphinx », planche « Dos (3/4 arrière) ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Sphinx, enemy of the Sables nation. Golden lion sphinx wearing a striped pharaoh headdress.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. walking, mid-stride, left foot forward.
4. crouched wind-up, ready to pounce.
5. lunge forward, jaws or claws first, small swirling sand and amber shards impact.
6. follow-through, landing after the lunge.
7. second strike, swiping sideways.
8. head raised, swirling sand and amber shards gathering around the body.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `sphinx_back.png` |
| 1-2 | repos 2 | `sphinx_back_idle_2.png` |
| 1-3 | marche 1 | `sphinx_back_walk.png` |
| 1-4 | attaque 1 | `sphinx_back_attack.png` |
| 2-1 | attaque 2 | `sphinx_back_attack_2.png` |
| 2-2 | attaque 3 | `sphinx_back_attack_3.png` |
| 2-3 | attaque 4 | `sphinx_back_attack_4.png` |
| 2-4 | sort 1 | `sphinx_back_cast.png` |

## 4. Boss

### Zahor le Sableux — 32 poses

4 planches de 8 poses. Joins la planche de face « repos » déjà réussie comme référence pour les suivantes. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/`.

#### Planche 1 — Face (3/4 avant) · Repos, marche et sorts

Dans l'Atelier : personnage « Zahor le Sableux », planche « Face (3/4 avant) · Repos, marche et sorts ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Zahor le Sableux, boss of the Sables nation. Sand sovereign in ornate golden armor with sharp layered plates, crested golden helm, holding a tall golden staff with a giant amber crystal, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. staff raised, swirling sand and amber shards orb forming at the top.
7. staff held high with both hands, swirling sand and amber shards swirling around.
8. staff pointed forward, releasing a compact swirling sand and amber shards blast.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `sables.png` |
| 1-2 | repos 2 | `sables_idle_2.png` |
| 1-3 | repos 3 | `sables_idle_3.png` |
| 1-4 | marche 1 | `sables_walk.png` |
| 2-1 | marche 2 | `sables_walk_2.png` |
| 2-2 | sort 1 | `sables_cast.png` |
| 2-3 | sort 2 | `sables_cast_2.png` |
| 2-4 | sort 3 | `sables_cast_3.png` |

#### Planche 2 — Face (3/4 avant) · Attaques

Dans l'Atelier : personnage « Zahor le Sableux », planche « Face (3/4 avant) · Attaques ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Zahor le Sableux, boss of the Sables nation. Sand sovereign in ornate golden armor with sharp layered plates, crested golden helm, holding a tall golden staff with a giant amber crystal, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in front-right 3/4 view):
1. wind-up, staff held back with both hands.
2. staff swing forward, small swirling sand and amber shards burst at the tip.
3. follow-through, staff low, body turned.
4. thrust with the staff tip forward, short swirling sand and amber shards spark.
5. overhead staff strike, both hands high.
6. spinning the staff around the body, small swirling sand and amber shards trail.
7. low sweep with the staff at the feet.
8. staff planted, kicking forward with one leg.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `sables_attack.png` |
| 1-2 | attaque 2 | `sables_attack_2.png` |
| 1-3 | attaque 3 | `sables_attack_3.png` |
| 1-4 | attaque 4 | `sables_attack_4.png` |
| 2-1 | attaque 5 | `sables_attack_5.png` |
| 2-2 | attaque 6 | `sables_attack_6.png` |
| 2-3 | attaque 7 | `sables_attack_7.png` |
| 2-4 | attaque 8 | `sables_attack_8.png` |

#### Planche 3 — Dos (3/4 arrière) · Repos, marche et sorts

Dans l'Atelier : personnage « Zahor le Sableux », planche « Dos (3/4 arrière) · Repos, marche et sorts ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Zahor le Sableux, boss of the Sables nation. Sand sovereign in ornate golden armor with sharp layered plates, crested golden helm, holding a tall golden staff with a giant amber crystal, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. idle, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised.
3. idle variant, alert, weapon ready.
4. walking, mid-stride, left foot forward.
5. walking, mid-stride, right foot forward.
6. staff raised, swirling sand and amber shards orb forming at the top.
7. staff held high with both hands, swirling sand and amber shards swirling around.
8. staff pointed forward, releasing a compact swirling sand and amber shards blast.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 | `sables_back.png` |
| 1-2 | repos 2 | `sables_back_idle_2.png` |
| 1-3 | repos 3 | `sables_back_idle_3.png` |
| 1-4 | marche 1 | `sables_back_walk.png` |
| 2-1 | marche 2 | `sables_back_walk_2.png` |
| 2-2 | sort 1 | `sables_back_cast.png` |
| 2-3 | sort 2 | `sables_back_cast_2.png` |
| 2-4 | sort 3 | `sables_back_cast_3.png` |

#### Planche 4 — Dos (3/4 arrière) · Attaques

Dans l'Atelier : personnage « Zahor le Sableux », planche « Dos (3/4 arrière) · Attaques ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Zahor le Sableux, boss of the Sables nation. Sand sovereign in ornate golden armor with sharp layered plates, crested golden helm, holding a tall golden staff with a giant amber crystal, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible, face hidden), facing away from the viewer toward the upper right in every cell. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows of equal square cells, exactly one pose per cell (image aspect ratio 2:1, as large as possible, e.g. 2048x1024). Treat every cell as a separate sprite: the character AND its weapon, cape, hair, tail and effects stay entirely inside its own cell, with an empty margin of at least 10% of the cell on every side. Between two cells leave a wide empty gutter of at least 25% of a cell width that nothing may cross: no limb, weapon, trail, slash, spark or smoke reaches a neighbouring cell, and no two poses touch. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every cell, feet on the same ground line in each row.
CELLS, left to right, top to bottom (all in back-right, away from the viewer 3/4 view):
1. wind-up, staff held back with both hands.
2. staff swing forward, small swirling sand and amber shards burst at the tip.
3. follow-through, staff low, body turned.
4. thrust with the staff tip forward, short swirling sand and amber shards spark.
5. overhead staff strike, both hands high.
6. spinning the staff around the body, small swirling sand and amber shards trail.
7. low sweep with the staff at the feet.
8. staff planted, kicking forward with one leg.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept inside their own cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `sables_back_attack.png` |
| 1-2 | attaque 2 | `sables_back_attack_2.png` |
| 1-3 | attaque 3 | `sables_back_attack_3.png` |
| 1-4 | attaque 4 | `sables_back_attack_4.png` |
| 2-1 | attaque 5 | `sables_back_attack_5.png` |
| 2-2 | attaque 6 | `sables_back_attack_6.png` |
| 2-3 | attaque 7 | `sables_back_attack_7.png` |
| 2-4 | attaque 8 | `sables_back_attack_8.png` |

## Prompt négatif (toutes les planches de cette page)

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art
```
