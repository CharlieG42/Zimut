# Nation Ombres (Ombres)

Palette : black, charcoal, violet glow, silver-teal cloth accents. Effets : violet shadow smoke. Contre-jour : violet.

Chaque personnage est dessiné en **vue 3/4 avant (face)** et en **vue 3/4 arrière (dos)**. Le jeu retourne l'image pour les directions vers la gauche. Une fiche de référence (repos face + dos), puis des planches de 4 poses (2 × 2) bien séparées. Prompt négatif : voir en bas de page.

Ordre conseillé : 1) planche de référence, 2) héros, 3) ennemis, 4) boss.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos. Joins-la comme image de référence à toutes les planches suivantes.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Ombres nation (Ombres biome).
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents. Signature effects: violet shadow smoke.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
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

### Assassin — 22 poses

6 planches, 22 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `assassin_<clé>.png` (ex. `assassin_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Assassin », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Assassin (hero of the Ombres nation)
- Hair: spiky black hair (#121216)
- Eyes: violet glowing eyes (#B070FF), always visible above the mask
- Face: black cloth mask covering the nose and mouth
- Top: dark charcoal hooded armor (#2A2C33), hood DOWN, layered tattered silver-teal cloth panels (#8FC9C0), violet rune details
- Bottom: charcoal trousers with silver-teal cloth strips
- Feet: black soft boots
- Weapon: one curved dagger in EACH hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no horns, no helmet, no claws, no sword.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents. Signature effects (keep them small): violet shadow smoke.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Assassin: spiky black hair (#121216); violet glowing eyes (#B070FF), always visible above the mask; black cloth mask covering the nose and mouth; dark charcoal hooded armor (#2A2C33), hood DOWN, layered tattered silver-teal cloth panels (#8FC9C0), violet rune details. Forbidden: no horns, no helmet, no claws, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `assassin.png` |
| 1-2 | repos 1 (dos) | `assassin_back.png` |

#### Planche 2 — Face 1 · garde, marche, sort (`face_1`)

Dans l'Atelier : personnage « Assassin », planche « Face 1 · garde, marche, sort ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Assassin (hero of the Ombres nation)
- Hair: spiky black hair (#121216)
- Eyes: violet glowing eyes (#B070FF), always visible above the mask
- Face: black cloth mask covering the nose and mouth
- Top: dark charcoal hooded armor (#2A2C33), hood DOWN, layered tattered silver-teal cloth panels (#8FC9C0), violet rune details
- Bottom: charcoal trousers with silver-teal cloth strips
- Feet: black soft boots
- Weapon: one curved dagger in EACH hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no horns, no helmet, no claws, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. GUARD: knees bent, weapon raised in front of the body, ready to fight.
2. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
3. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
4. SHADOW KNEEL: kneeling, one hand on the ground, violet shadow smoke rising around.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Assassin: spiky black hair (#121216); violet glowing eyes (#B070FF), always visible above the mask; black cloth mask covering the nose and mouth; dark charcoal hooded armor (#2A2C33), hood DOWN, layered tattered silver-teal cloth panels (#8FC9C0), violet rune details. Forbidden: no horns, no helmet, no claws, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 2 | `assassin_idle_2.png` |
| 1-2 | marche 1 | `assassin_walk.png` |
| 2-1 | marche 2 | `assassin_walk_2.png` |
| 2-2 | sort 1 | `assassin_cast.png` |

#### Planche 3 — Face 2 · attaques 1 à 4 (`face_2`)

Dans l'Atelier : personnage « Assassin », planche « Face 2 · attaques 1 à 4 ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Assassin (hero of the Ombres nation)
- Hair: spiky black hair (#121216)
- Eyes: violet glowing eyes (#B070FF), always visible above the mask
- Face: black cloth mask covering the nose and mouth
- Top: dark charcoal hooded armor (#2A2C33), hood DOWN, layered tattered silver-teal cloth panels (#8FC9C0), violet rune details
- Bottom: charcoal trousers with silver-teal cloth strips
- Feet: black soft boots
- Weapon: one curved dagger in EACH hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no horns, no helmet, no claws, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. CROSS SLASH: both daggers crossed high above the head, about to strike down.
2. LUNGE STAB: body stretched forward almost horizontal, one dagger thrust far ahead.
3. SPIN: body twisted, arms spread to both sides, short violet shadow smoke slash arcs.
4. LEAP: whole body in the air, knees tucked, daggers pointed down.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Assassin: spiky black hair (#121216); violet glowing eyes (#B070FF), always visible above the mask; black cloth mask covering the nose and mouth; dark charcoal hooded armor (#2A2C33), hood DOWN, layered tattered silver-teal cloth panels (#8FC9C0), violet rune details. Forbidden: no horns, no helmet, no claws, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `assassin_attack.png` |
| 1-2 | attaque 2 | `assassin_attack_2.png` |
| 2-1 | attaque 3 | `assassin_attack_3.png` |
| 2-2 | attaque 4 | `assassin_attack_4.png` |

#### Planche 4 — Face 3 · attaques 5-6, sorts 2-3 (`face_3`)

Dans l'Atelier : personnage « Assassin », planche « Face 3 · attaques 5-6, sorts 2-3 ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Assassin (hero of the Ombres nation)
- Hair: spiky black hair (#121216)
- Eyes: violet glowing eyes (#B070FF), always visible above the mask
- Face: black cloth mask covering the nose and mouth
- Top: dark charcoal hooded armor (#2A2C33), hood DOWN, layered tattered silver-teal cloth panels (#8FC9C0), violet rune details
- Bottom: charcoal trousers with silver-teal cloth strips
- Feet: black soft boots
- Weapon: one curved dagger in EACH hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no horns, no helmet, no claws, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. LOW SWEEP: crouched very low on one knee, one dagger slashing near the ground.
2. THROW: one arm extended after throwing a dagger, the dagger flying ahead with a violet shadow smoke trail.
3. VANISH: half the body dissolving into violet shadow smoke, only the eyes and daggers clear.
4. MARK: one arm pointing forward, a violet shadow smoke sigil appearing in front of the hand.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Assassin: spiky black hair (#121216); violet glowing eyes (#B070FF), always visible above the mask; black cloth mask covering the nose and mouth; dark charcoal hooded armor (#2A2C33), hood DOWN, layered tattered silver-teal cloth panels (#8FC9C0), violet rune details. Forbidden: no horns, no helmet, no claws, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 5 | `assassin_attack_5.png` |
| 1-2 | attaque 6 | `assassin_attack_6.png` |
| 2-1 | sort 2 | `assassin_cast_2.png` |
| 2-2 | sort 3 | `assassin_cast_3.png` |

#### Planche 5 — Dos 1 · marche, attaque, sort (`dos_1`)

Dans l'Atelier : personnage « Assassin », planche « Dos 1 · marche, attaque, sort ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Assassin (hero of the Ombres nation)
- Hair: spiky black hair (#121216)
- Eyes: violet glowing eyes (#B070FF), always visible above the mask
- Face: black cloth mask covering the nose and mouth
- Top: dark charcoal hooded armor (#2A2C33), hood DOWN, layered tattered silver-teal cloth panels (#8FC9C0), violet rune details
- Bottom: charcoal trousers with silver-teal cloth strips
- Feet: black soft boots
- Weapon: one curved dagger in EACH hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no horns, no helmet, no claws, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
3. CROSS SLASH: both daggers crossed high above the head, about to strike down.
4. SHADOW KNEEL: kneeling, one hand on the ground, violet shadow smoke rising around.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Assassin: spiky black hair (#121216); violet glowing eyes (#B070FF), always visible above the mask; black cloth mask covering the nose and mouth; dark charcoal hooded armor (#2A2C33), hood DOWN, layered tattered silver-teal cloth panels (#8FC9C0), violet rune details. Forbidden: no horns, no helmet, no claws, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `assassin_back_walk.png` |
| 1-2 | marche 2 | `assassin_back_walk_2.png` |
| 2-1 | attaque 1 | `assassin_back_attack.png` |
| 2-2 | sort 1 | `assassin_back_cast.png` |

#### Planche 6 — Dos 2 · attaques 2 à 4, garde (`dos_2`)

Dans l'Atelier : personnage « Assassin », planche « Dos 2 · attaques 2 à 4, garde ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Assassin (hero of the Ombres nation)
- Hair: spiky black hair (#121216)
- Eyes: violet glowing eyes (#B070FF), always visible above the mask
- Face: black cloth mask covering the nose and mouth
- Top: dark charcoal hooded armor (#2A2C33), hood DOWN, layered tattered silver-teal cloth panels (#8FC9C0), violet rune details
- Bottom: charcoal trousers with silver-teal cloth strips
- Feet: black soft boots
- Weapon: one curved dagger in EACH hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no horns, no helmet, no claws, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. LUNGE STAB: body stretched forward almost horizontal, one dagger thrust far ahead.
2. SPIN: body twisted, arms spread to both sides, short violet shadow smoke slash arcs.
3. LEAP: whole body in the air, knees tucked, daggers pointed down.
4. GUARD: knees bent, weapon raised in front of the body, ready to fight.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Assassin: spiky black hair (#121216); violet glowing eyes (#B070FF), always visible above the mask; black cloth mask covering the nose and mouth; dark charcoal hooded armor (#2A2C33), hood DOWN, layered tattered silver-teal cloth panels (#8FC9C0), violet rune details. Forbidden: no horns, no helmet, no claws, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 2 | `assassin_back_attack_2.png` |
| 1-2 | attaque 3 | `assassin_back_attack_3.png` |
| 2-1 | attaque 4 | `assassin_back_attack_4.png` |
| 2-2 | repos 2 | `assassin_back_idle_2.png` |

L'export Zimut de l'Atelier copie aussi le repos vers `nations/heros/assassin.png` et les autres poses vers `nations/heros/poses/`.

## 3. Ennemis

### Assassin des ombres — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/ombres/` ; nomme tes images `assassin_des_ombres_<clé>.png` (ex. `assassin_des_ombres_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Assassin des ombres », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Assassin des ombres (enemy of the Ombres nation)
- Look: hunched shadow beast-assassin with a spiky purple mane and long claws
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents. Signature effects (keep them small): violet shadow smoke.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Assassin des ombres: hunched shadow beast-assassin with a spiky purple mane and long claws.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `assassin_des_ombres.png` |
| 1-2 | repos 1 (dos) | `assassin_des_ombres_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Assassin des ombres », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Assassin des ombres (enemy of the Ombres nation)
- Look: hunched shadow beast-assassin with a spiky purple mane and long claws
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. REARING: standing up on the hind legs, front claws raised high.
3. POUNCE: body stretched forward in the air, jaws open.
4. HOWL: head raised to the sky, violet shadow smoke gathering around the body.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Assassin des ombres: hunched shadow beast-assassin with a spiky purple mane and long claws.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `assassin_des_ombres_walk.png` |
| 1-2 | attaque 1 | `assassin_des_ombres_attack.png` |
| 2-1 | attaque 2 | `assassin_des_ombres_attack_2.png` |
| 2-2 | sort 1 | `assassin_des_ombres_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Assassin des ombres », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Assassin des ombres (enemy of the Ombres nation)
- Look: hunched shadow beast-assassin with a spiky purple mane and long claws
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. REARING: standing up on the hind legs, front claws raised high.
3. POUNCE: body stretched forward in the air, jaws open.
4. HOWL: head raised to the sky, violet shadow smoke gathering around the body.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Assassin des ombres: hunched shadow beast-assassin with a spiky purple mane and long claws.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `assassin_des_ombres_back_walk.png` |
| 1-2 | attaque 1 | `assassin_des_ombres_back_attack.png` |
| 2-1 | attaque 2 | `assassin_des_ombres_back_attack_2.png` |
| 2-2 | sort 1 | `assassin_des_ombres_back_cast.png` |

### Ombre infernale — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/ombres/` ; nomme tes images `ombre_infernale_<clé>.png` (ex. `ombre_infernale_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Ombre infernale », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombre infernale (enemy of the Ombres nation)
- Look: swirling mass of purple shadow with claws and glowing eyes
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents. Signature effects (keep them small): violet shadow smoke.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Ombre infernale: swirling mass of purple shadow with claws and glowing eyes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `ombre_infernale.png` |
| 1-2 | repos 1 (dos) | `ombre_infernale_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Ombre infernale », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombre infernale (enemy of the Ombres nation)
- Look: swirling mass of purple shadow with claws and glowing eyes
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. RISE: body stretched tall upward, arms raised.
3. LUNGE: body stretched forward, claws of violet shadow smoke reaching out.
4. HOVER: floating higher, violet shadow smoke orbs circling.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Ombre infernale: swirling mass of purple shadow with claws and glowing eyes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `ombre_infernale_walk.png` |
| 1-2 | attaque 1 | `ombre_infernale_attack.png` |
| 2-1 | attaque 2 | `ombre_infernale_attack_2.png` |
| 2-2 | sort 1 | `ombre_infernale_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Ombre infernale », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombre infernale (enemy of the Ombres nation)
- Look: swirling mass of purple shadow with claws and glowing eyes
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. RISE: body stretched tall upward, arms raised.
3. LUNGE: body stretched forward, claws of violet shadow smoke reaching out.
4. HOVER: floating higher, violet shadow smoke orbs circling.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Ombre infernale: swirling mass of purple shadow with claws and glowing eyes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `ombre_infernale_back_walk.png` |
| 1-2 | attaque 1 | `ombre_infernale_back_attack.png` |
| 2-1 | attaque 2 | `ombre_infernale_back_attack_2.png` |
| 2-2 | sort 1 | `ombre_infernale_back_cast.png` |

### Spectre — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/ombres/` ; nomme tes images `spectre_<clé>.png` (ex. `spectre_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Spectre », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Spectre (enemy of the Ombres nation)
- Look: violet spectral figure wrapped in shadow curls, long claw-like hands
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents. Signature effects (keep them small): violet shadow smoke.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Spectre: violet spectral figure wrapped in shadow curls, long claw-like hands.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `spectre.png` |
| 1-2 | repos 1 (dos) | `spectre_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Spectre », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Spectre (enemy of the Ombres nation)
- Look: violet spectral figure wrapped in shadow curls, long claw-like hands
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. RISE: body stretched tall upward, arms raised.
3. LUNGE: body stretched forward, claws of violet shadow smoke reaching out.
4. HOVER: floating higher, violet shadow smoke orbs circling.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Spectre: violet spectral figure wrapped in shadow curls, long claw-like hands.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `spectre_walk.png` |
| 1-2 | attaque 1 | `spectre_attack.png` |
| 2-1 | attaque 2 | `spectre_attack_2.png` |
| 2-2 | sort 1 | `spectre_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Spectre », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Spectre (enemy of the Ombres nation)
- Look: violet spectral figure wrapped in shadow curls, long claw-like hands
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. RISE: body stretched tall upward, arms raised.
3. LUNGE: body stretched forward, claws of violet shadow smoke reaching out.
4. HOVER: floating higher, violet shadow smoke orbs circling.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Spectre: violet spectral figure wrapped in shadow curls, long claw-like hands.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `spectre_back_walk.png` |
| 1-2 | attaque 1 | `spectre_back_attack.png` |
| 2-1 | attaque 2 | `spectre_back_attack_2.png` |
| 2-2 | sort 1 | `spectre_back_cast.png` |

### Liche — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/ombres/` ; nomme tes images `liche_<clé>.png` (ex. `liche_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Liche », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Liche (enemy of the Ombres nation)
- Look: tall dark purple lich in a spiked robe holding a staff
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents. Signature effects (keep them small): violet shadow smoke.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Liche: tall dark purple lich in a spiked robe holding a staff.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `liche.png` |
| 1-2 | repos 1 (dos) | `liche_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Liche », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Liche (enemy of the Ombres nation)
- Look: tall dark purple lich in a spiked robe holding a staff
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. OVERHEAD STRIKE: staff raised high above the head with both hands.
3. THRUST: body leaning forward, staff tip pushed far ahead with a short violet shadow smoke spark.
4. FOCUS: eyes closed, staff held vertically in front of the face, violet shadow smoke orb at the top.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Liche: tall dark purple lich in a spiked robe holding a staff.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `liche_walk.png` |
| 1-2 | attaque 1 | `liche_attack.png` |
| 2-1 | attaque 2 | `liche_attack_2.png` |
| 2-2 | sort 1 | `liche_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Liche », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Liche (enemy of the Ombres nation)
- Look: tall dark purple lich in a spiked robe holding a staff
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. OVERHEAD STRIKE: staff raised high above the head with both hands.
3. THRUST: body leaning forward, staff tip pushed far ahead with a short violet shadow smoke spark.
4. FOCUS: eyes closed, staff held vertically in front of the face, violet shadow smoke orb at the top.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Liche: tall dark purple lich in a spiked robe holding a staff.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `liche_back_walk.png` |
| 1-2 | attaque 1 | `liche_back_attack.png` |
| 2-1 | attaque 2 | `liche_back_attack_2.png` |
| 2-2 | sort 1 | `liche_back_cast.png` |

## 4. Boss

### Nébulia l'Illusionniste — 22 poses

6 planches, 22 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `ombres_<clé>.png` (ex. `ombres_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Nébulia l'Illusionniste », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Nébulia l'Illusionniste (boss of the Ombres nation)
- Body: tall illusionist in black armor (#18181E) with spiky layers of silver-teal tattered cloth (#8FC9C0)
- Head: horned black mask-helm with a silver face plate, long white hair, glowing violet eyes
- Weapon: two long thin blades, one in each hand, violet mirror-like glints
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no shield, no staff.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents. Signature effects (keep them small): violet shadow smoke.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Nébulia l'Illusionniste: tall illusionist in black armor (#18181E) with spiky layers of silver-teal tattered cloth (#8FC9C0); horned black mask-helm with a silver face plate, long white hair, glowing violet eyes; two long thin blades, one in each hand, violet mirror-like glints. Forbidden: no shield, no staff.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `ombres.png` |
| 1-2 | repos 1 (dos) | `ombres_back.png` |

#### Planche 2 — Face 1 · garde, marche, sort (`face_1`)

Dans l'Atelier : personnage « Nébulia l'Illusionniste », planche « Face 1 · garde, marche, sort ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Nébulia l'Illusionniste (boss of the Ombres nation)
- Body: tall illusionist in black armor (#18181E) with spiky layers of silver-teal tattered cloth (#8FC9C0)
- Head: horned black mask-helm with a silver face plate, long white hair, glowing violet eyes
- Weapon: two long thin blades, one in each hand, violet mirror-like glints
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no shield, no staff.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. GUARD: knees bent, weapon raised in front of the body, ready to fight.
2. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
3. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
4. SHADOW KNEEL: kneeling, one hand on the ground, violet shadow smoke rising around.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Nébulia l'Illusionniste: tall illusionist in black armor (#18181E) with spiky layers of silver-teal tattered cloth (#8FC9C0); horned black mask-helm with a silver face plate, long white hair, glowing violet eyes; two long thin blades, one in each hand, violet mirror-like glints. Forbidden: no shield, no staff.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 2 | `ombres_idle_2.png` |
| 1-2 | marche 1 | `ombres_walk.png` |
| 2-1 | marche 2 | `ombres_walk_2.png` |
| 2-2 | sort 1 | `ombres_cast.png` |

#### Planche 3 — Face 2 · attaques 1 à 4 (`face_2`)

Dans l'Atelier : personnage « Nébulia l'Illusionniste », planche « Face 2 · attaques 1 à 4 ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Nébulia l'Illusionniste (boss of the Ombres nation)
- Body: tall illusionist in black armor (#18181E) with spiky layers of silver-teal tattered cloth (#8FC9C0)
- Head: horned black mask-helm with a silver face plate, long white hair, glowing violet eyes
- Weapon: two long thin blades, one in each hand, violet mirror-like glints
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no shield, no staff.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. CROSS SLASH: both daggers crossed high above the head, about to strike down.
2. LUNGE STAB: body stretched forward almost horizontal, one dagger thrust far ahead.
3. SPIN: body twisted, arms spread to both sides, short violet shadow smoke slash arcs.
4. LEAP: whole body in the air, knees tucked, daggers pointed down.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Nébulia l'Illusionniste: tall illusionist in black armor (#18181E) with spiky layers of silver-teal tattered cloth (#8FC9C0); horned black mask-helm with a silver face plate, long white hair, glowing violet eyes; two long thin blades, one in each hand, violet mirror-like glints. Forbidden: no shield, no staff.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `ombres_attack.png` |
| 1-2 | attaque 2 | `ombres_attack_2.png` |
| 2-1 | attaque 3 | `ombres_attack_3.png` |
| 2-2 | attaque 4 | `ombres_attack_4.png` |

#### Planche 4 — Face 3 · attaques 5-6, sorts 2-3 (`face_3`)

Dans l'Atelier : personnage « Nébulia l'Illusionniste », planche « Face 3 · attaques 5-6, sorts 2-3 ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Nébulia l'Illusionniste (boss of the Ombres nation)
- Body: tall illusionist in black armor (#18181E) with spiky layers of silver-teal tattered cloth (#8FC9C0)
- Head: horned black mask-helm with a silver face plate, long white hair, glowing violet eyes
- Weapon: two long thin blades, one in each hand, violet mirror-like glints
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no shield, no staff.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. LOW SWEEP: crouched very low on one knee, one dagger slashing near the ground.
2. THROW: one arm extended after throwing a dagger, the dagger flying ahead with a violet shadow smoke trail.
3. VANISH: half the body dissolving into violet shadow smoke, only the eyes and daggers clear.
4. MARK: one arm pointing forward, a violet shadow smoke sigil appearing in front of the hand.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Nébulia l'Illusionniste: tall illusionist in black armor (#18181E) with spiky layers of silver-teal tattered cloth (#8FC9C0); horned black mask-helm with a silver face plate, long white hair, glowing violet eyes; two long thin blades, one in each hand, violet mirror-like glints. Forbidden: no shield, no staff.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 5 | `ombres_attack_5.png` |
| 1-2 | attaque 6 | `ombres_attack_6.png` |
| 2-1 | sort 2 | `ombres_cast_2.png` |
| 2-2 | sort 3 | `ombres_cast_3.png` |

#### Planche 5 — Dos 1 · marche, attaque, sort (`dos_1`)

Dans l'Atelier : personnage « Nébulia l'Illusionniste », planche « Dos 1 · marche, attaque, sort ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Nébulia l'Illusionniste (boss of the Ombres nation)
- Body: tall illusionist in black armor (#18181E) with spiky layers of silver-teal tattered cloth (#8FC9C0)
- Head: horned black mask-helm with a silver face plate, long white hair, glowing violet eyes
- Weapon: two long thin blades, one in each hand, violet mirror-like glints
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no shield, no staff.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
3. CROSS SLASH: both daggers crossed high above the head, about to strike down.
4. SHADOW KNEEL: kneeling, one hand on the ground, violet shadow smoke rising around.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Nébulia l'Illusionniste: tall illusionist in black armor (#18181E) with spiky layers of silver-teal tattered cloth (#8FC9C0); horned black mask-helm with a silver face plate, long white hair, glowing violet eyes; two long thin blades, one in each hand, violet mirror-like glints. Forbidden: no shield, no staff.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `ombres_back_walk.png` |
| 1-2 | marche 2 | `ombres_back_walk_2.png` |
| 2-1 | attaque 1 | `ombres_back_attack.png` |
| 2-2 | sort 1 | `ombres_back_cast.png` |

#### Planche 6 — Dos 2 · attaques 2 à 4, garde (`dos_2`)

Dans l'Atelier : personnage « Nébulia l'Illusionniste », planche « Dos 2 · attaques 2 à 4, garde ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Nébulia l'Illusionniste (boss of the Ombres nation)
- Body: tall illusionist in black armor (#18181E) with spiky layers of silver-teal tattered cloth (#8FC9C0)
- Head: horned black mask-helm with a silver face plate, long white hair, glowing violet eyes
- Weapon: two long thin blades, one in each hand, violet mirror-like glints
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no shield, no staff.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. LUNGE STAB: body stretched forward almost horizontal, one dagger thrust far ahead.
2. SPIN: body twisted, arms spread to both sides, short violet shadow smoke slash arcs.
3. LEAP: whole body in the air, knees tucked, daggers pointed down.
4. GUARD: knees bent, weapon raised in front of the body, ready to fight.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Nébulia l'Illusionniste: tall illusionist in black armor (#18181E) with spiky layers of silver-teal tattered cloth (#8FC9C0); horned black mask-helm with a silver face plate, long white hair, glowing violet eyes; two long thin blades, one in each hand, violet mirror-like glints. Forbidden: no shield, no staff.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 2 | `ombres_back_attack_2.png` |
| 1-2 | attaque 3 | `ombres_back_attack_3.png` |
| 2-1 | attaque 4 | `ombres_back_attack_4.png` |
| 2-2 | repos 2 | `ombres_back_idle_2.png` |

## Prompt négatif (toutes les planches de cette page)

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses, identical poses, repeated pose, copy of the same pose, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, front and back views mixed, different character between poses, realistic proportions, small head
```
