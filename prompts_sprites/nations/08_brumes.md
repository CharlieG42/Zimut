# Nation Brumes (Brumes)

Palette : black, deep violet, mist mint green, silver. Effets : mint mist and violet spectral wisps. Contre-jour : pale mint.

Chaque personnage est dessiné en **vue 3/4 avant (face)** et en **vue 3/4 arrière (dos)**. Le jeu retourne l'image pour les directions vers la gauche. Une fiche de référence (repos face + dos), puis des planches de 4 poses (2 × 2) bien séparées. Prompt négatif : voir en bas de page.

Ordre conseillé : 1) planche de référence, 2) héros, 3) ennemis, 4) boss.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos. Joins-la comme image de référence à toutes les planches suivantes.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Brumes nation (Brumes biome).
NATION PALETTE: black, deep violet, mist mint green, silver. Signature effects: mint mist and violet spectral wisps.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
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

### Invocateur — 22 poses

6 planches, 22 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `invocateur_<clé>.png` (ex. `invocateur_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Invocateur », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Invocateur (hero of the Brumes nation)
- Hair: black hair (#15151C), medium length, messy bangs
- Eyes: violet eyes (#9B6BFF), always open
- Skin: pale skin
- Top: long black coat with violet trims (#7A3FD0) and silver clasps
- Bottom: black trousers
- Feet: black boots with silver buckles
- Weapon: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no mask, no white hair.
NATION PALETTE: black, deep violet, mist mint green, silver. Signature effects (keep them small): mint mist and violet spectral wisps.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Invocateur: black hair (#15151C), medium length, messy bangs; violet eyes (#9B6BFF), always open; pale skin; long black coat with violet trims (#7A3FD0) and silver clasps. Forbidden: no hood, no mask, no white hair.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `invocateur.png` |
| 1-2 | repos 1 (dos) | `invocateur_back.png` |

#### Planche 2 — Face 1 · garde, marche, sort (`face_1`)

Dans l'Atelier : personnage « Invocateur », planche « Face 1 · garde, marche, sort ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Invocateur (hero of the Brumes nation)
- Hair: black hair (#15151C), medium length, messy bangs
- Eyes: violet eyes (#9B6BFF), always open
- Skin: pale skin
- Top: long black coat with violet trims (#7A3FD0) and silver clasps
- Bottom: black trousers
- Feet: black boots with silver buckles
- Weapon: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no mask, no white hair.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. GUARD: knees bent, weapon raised in front of the body, ready to fight.
2. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
3. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
4. READING: grimoire floating open in front, pages turning, mint mist and violet spectral wisps rising from it.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Invocateur: black hair (#15151C), medium length, messy bangs; violet eyes (#9B6BFF), always open; pale skin; long black coat with violet trims (#7A3FD0) and silver clasps. Forbidden: no hood, no mask, no white hair.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 2 | `invocateur_idle_2.png` |
| 1-2 | marche 1 | `invocateur_walk.png` |
| 2-1 | marche 2 | `invocateur_walk_2.png` |
| 2-2 | sort 1 | `invocateur_cast.png` |

#### Planche 3 — Face 2 · attaques 1 à 4 (`face_2`)

Dans l'Atelier : personnage « Invocateur », planche « Face 2 · attaques 1 à 4 ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Invocateur (hero of the Brumes nation)
- Hair: black hair (#15151C), medium length, messy bangs
- Eyes: violet eyes (#9B6BFF), always open
- Skin: pale skin
- Top: long black coat with violet trims (#7A3FD0) and silver clasps
- Bottom: black trousers
- Feet: black boots with silver buckles
- Weapon: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no mask, no white hair.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. OVERHEAD STRIKE: staff raised high above the head, grimoire floating behind.
2. PALM BOLT: free arm stretched forward, a mint mist and violet spectral wisps bolt leaving the open palm.
3. SIDE SWING: staff swept horizontally, coat swirling.
4. GRIMOIRE SLAM: grimoire snapping shut in front, a small mint mist and violet spectral wisps shockwave.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Invocateur: black hair (#15151C), medium length, messy bangs; violet eyes (#9B6BFF), always open; pale skin; long black coat with violet trims (#7A3FD0) and silver clasps. Forbidden: no hood, no mask, no white hair.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `invocateur_attack.png` |
| 1-2 | attaque 2 | `invocateur_attack_2.png` |
| 2-1 | attaque 3 | `invocateur_attack_3.png` |
| 2-2 | attaque 4 | `invocateur_attack_4.png` |

#### Planche 4 — Face 3 · attaques 5-6, sorts 2-3 (`face_3`)

Dans l'Atelier : personnage « Invocateur », planche « Face 3 · attaques 5-6, sorts 2-3 ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Invocateur (hero of the Brumes nation)
- Hair: black hair (#15151C), medium length, messy bangs
- Eyes: violet eyes (#9B6BFF), always open
- Skin: pale skin
- Top: long black coat with violet trims (#7A3FD0) and silver clasps
- Bottom: black trousers
- Feet: black boots with silver buckles
- Weapon: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no mask, no white hair.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. LOW SWEEP: crouched, staff swinging near the ground.
2. CLAWS: free hand raised as a claw, mint mist and violet spectral wisps claws forming in front.
3. SUMMONING CIRCLE: staff raised, a mint mist and violet spectral wisps circle drawn on the ground.
4. SUMMON: both arms open wide, a mint mist and violet spectral wisps creature silhouette emerging beside.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Invocateur: black hair (#15151C), medium length, messy bangs; violet eyes (#9B6BFF), always open; pale skin; long black coat with violet trims (#7A3FD0) and silver clasps. Forbidden: no hood, no mask, no white hair.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 5 | `invocateur_attack_5.png` |
| 1-2 | attaque 6 | `invocateur_attack_6.png` |
| 2-1 | sort 2 | `invocateur_cast_2.png` |
| 2-2 | sort 3 | `invocateur_cast_3.png` |

#### Planche 5 — Dos 1 · marche, attaque, sort (`dos_1`)

Dans l'Atelier : personnage « Invocateur », planche « Dos 1 · marche, attaque, sort ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Invocateur (hero of the Brumes nation)
- Hair: black hair (#15151C), medium length, messy bangs
- Eyes: violet eyes (#9B6BFF), always open
- Skin: pale skin
- Top: long black coat with violet trims (#7A3FD0) and silver clasps
- Bottom: black trousers
- Feet: black boots with silver buckles
- Weapon: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no mask, no white hair.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
3. OVERHEAD STRIKE: staff raised high above the head, grimoire floating behind.
4. READING: grimoire floating open in front, pages turning, mint mist and violet spectral wisps rising from it.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Invocateur: black hair (#15151C), medium length, messy bangs; violet eyes (#9B6BFF), always open; pale skin; long black coat with violet trims (#7A3FD0) and silver clasps. Forbidden: no hood, no mask, no white hair.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `invocateur_back_walk.png` |
| 1-2 | marche 2 | `invocateur_back_walk_2.png` |
| 2-1 | attaque 1 | `invocateur_back_attack.png` |
| 2-2 | sort 1 | `invocateur_back_cast.png` |

#### Planche 6 — Dos 2 · attaques 2 à 4, garde (`dos_2`)

Dans l'Atelier : personnage « Invocateur », planche « Dos 2 · attaques 2 à 4, garde ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Invocateur (hero of the Brumes nation)
- Hair: black hair (#15151C), medium length, messy bangs
- Eyes: violet eyes (#9B6BFF), always open
- Skin: pale skin
- Top: long black coat with violet trims (#7A3FD0) and silver clasps
- Bottom: black trousers
- Feet: black boots with silver buckles
- Weapon: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no mask, no white hair.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. PALM BOLT: free arm stretched forward, a mint mist and violet spectral wisps bolt leaving the open palm.
2. SIDE SWING: staff swept horizontally, coat swirling.
3. GRIMOIRE SLAM: grimoire snapping shut in front, a small mint mist and violet spectral wisps shockwave.
4. GUARD: knees bent, weapon raised in front of the body, ready to fight.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Invocateur: black hair (#15151C), medium length, messy bangs; violet eyes (#9B6BFF), always open; pale skin; long black coat with violet trims (#7A3FD0) and silver clasps. Forbidden: no hood, no mask, no white hair.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 2 | `invocateur_back_attack_2.png` |
| 1-2 | attaque 3 | `invocateur_back_attack_3.png` |
| 2-1 | attaque 4 | `invocateur_back_attack_4.png` |
| 2-2 | repos 2 | `invocateur_back_idle_2.png` |

L'export Zimut de l'Atelier copie aussi le repos vers `nations/heros/invocateur.png` et les autres poses vers `nations/heros/poses/`.

## 3. Ennemis

### Brumeux — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brumes/` ; nomme tes images `brumeux_<clé>.png` (ex. `brumeux_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Brumeux », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Brumeux (enemy of the Brumes nation)
- Look: hulking lavender mist beast with a fluffy cloud body and small glowing eyes
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
NATION PALETTE: black, deep violet, mist mint green, silver. Signature effects (keep them small): mint mist and violet spectral wisps.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Brumeux: hulking lavender mist beast with a fluffy cloud body and small glowing eyes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `brumeux.png` |
| 1-2 | repos 1 (dos) | `brumeux_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Brumeux », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Brumeux (enemy of the Brumes nation)
- Look: hulking lavender mist beast with a fluffy cloud body and small glowing eyes
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. RISE: body stretched tall upward, arms raised.
3. LUNGE: body stretched forward, claws of mint mist and violet spectral wisps reaching out.
4. HOVER: floating higher, mint mist and violet spectral wisps orbs circling.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Brumeux: hulking lavender mist beast with a fluffy cloud body and small glowing eyes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `brumeux_walk.png` |
| 1-2 | attaque 1 | `brumeux_attack.png` |
| 2-1 | attaque 2 | `brumeux_attack_2.png` |
| 2-2 | sort 1 | `brumeux_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Brumeux », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Brumeux (enemy of the Brumes nation)
- Look: hulking lavender mist beast with a fluffy cloud body and small glowing eyes
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. RISE: body stretched tall upward, arms raised.
3. LUNGE: body stretched forward, claws of mint mist and violet spectral wisps reaching out.
4. HOVER: floating higher, mint mist and violet spectral wisps orbs circling.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Brumeux: hulking lavender mist beast with a fluffy cloud body and small glowing eyes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `brumeux_back_walk.png` |
| 1-2 | attaque 1 | `brumeux_back_attack.png` |
| 2-1 | attaque 2 | `brumeux_back_attack_2.png` |
| 2-2 | sort 1 | `brumeux_back_cast.png` |

### Gargouille — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brumes/` ; nomme tes images `gargouille_<clé>.png` (ex. `gargouille_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Gargouille », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Gargouille (enemy of the Brumes nation)
- Look: grey stone gargoyle with bat wings and a long tail
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
NATION PALETTE: black, deep violet, mist mint green, silver. Signature effects (keep them small): mint mist and violet spectral wisps.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Gargouille: grey stone gargoyle with bat wings and a long tail.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `gargouille.png` |
| 1-2 | repos 1 (dos) | `gargouille_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Gargouille », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Gargouille (enemy of the Brumes nation)
- Look: grey stone gargoyle with bat wings and a long tail
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. REARING: standing up on the hind legs, front claws raised high.
3. POUNCE: body stretched forward in the air, jaws open.
4. HOWL: head raised to the sky, mint mist and violet spectral wisps gathering around the body.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Gargouille: grey stone gargoyle with bat wings and a long tail.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `gargouille_walk.png` |
| 1-2 | attaque 1 | `gargouille_attack.png` |
| 2-1 | attaque 2 | `gargouille_attack_2.png` |
| 2-2 | sort 1 | `gargouille_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Gargouille », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Gargouille (enemy of the Brumes nation)
- Look: grey stone gargoyle with bat wings and a long tail
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. REARING: standing up on the hind legs, front claws raised high.
3. POUNCE: body stretched forward in the air, jaws open.
4. HOWL: head raised to the sky, mint mist and violet spectral wisps gathering around the body.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Gargouille: grey stone gargoyle with bat wings and a long tail.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `gargouille_back_walk.png` |
| 1-2 | attaque 1 | `gargouille_back_attack.png` |
| 2-1 | attaque 2 | `gargouille_back_attack_2.png` |
| 2-2 | sort 1 | `gargouille_back_cast.png` |

### Liche des brumes — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brumes/` ; nomme tes images `liche_des_brumes_<clé>.png` (ex. `liche_des_brumes_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Liche des brumes », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Liche des brumes (enemy of the Brumes nation)
- Look: thin violet lich in tattered robes holding a crooked staff
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
NATION PALETTE: black, deep violet, mist mint green, silver. Signature effects (keep them small): mint mist and violet spectral wisps.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Liche des brumes: thin violet lich in tattered robes holding a crooked staff.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `liche_des_brumes.png` |
| 1-2 | repos 1 (dos) | `liche_des_brumes_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Liche des brumes », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Liche des brumes (enemy of the Brumes nation)
- Look: thin violet lich in tattered robes holding a crooked staff
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. OVERHEAD STRIKE: staff raised high above the head with both hands.
3. THRUST: body leaning forward, staff tip pushed far ahead with a short mint mist and violet spectral wisps spark.
4. FOCUS: eyes closed, staff held vertically in front of the face, mint mist and violet spectral wisps orb at the top.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Liche des brumes: thin violet lich in tattered robes holding a crooked staff.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `liche_des_brumes_walk.png` |
| 1-2 | attaque 1 | `liche_des_brumes_attack.png` |
| 2-1 | attaque 2 | `liche_des_brumes_attack_2.png` |
| 2-2 | sort 1 | `liche_des_brumes_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Liche des brumes », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Liche des brumes (enemy of the Brumes nation)
- Look: thin violet lich in tattered robes holding a crooked staff
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. OVERHEAD STRIKE: staff raised high above the head with both hands.
3. THRUST: body leaning forward, staff tip pushed far ahead with a short mint mist and violet spectral wisps spark.
4. FOCUS: eyes closed, staff held vertically in front of the face, mint mist and violet spectral wisps orb at the top.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Liche des brumes: thin violet lich in tattered robes holding a crooked staff.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `liche_des_brumes_back_walk.png` |
| 1-2 | attaque 1 | `liche_des_brumes_back_attack.png` |
| 2-1 | attaque 2 | `liche_des_brumes_back_attack_2.png` |
| 2-2 | sort 1 | `liche_des_brumes_back_cast.png` |

### Fantôme — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brumes/` ; nomme tes images `fantome_<clé>.png` (ex. `fantome_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Fantôme », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Fantôme (enemy of the Brumes nation)
- Look: pale blue ghost with a wavy tail and a mischievous face
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
NATION PALETTE: black, deep violet, mist mint green, silver. Signature effects (keep them small): mint mist and violet spectral wisps.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Fantôme: pale blue ghost with a wavy tail and a mischievous face.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `fantome.png` |
| 1-2 | repos 1 (dos) | `fantome_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Fantôme », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Fantôme (enemy of the Brumes nation)
- Look: pale blue ghost with a wavy tail and a mischievous face
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. RISE: body stretched tall upward, arms raised.
3. LUNGE: body stretched forward, claws of mint mist and violet spectral wisps reaching out.
4. HOVER: floating higher, mint mist and violet spectral wisps orbs circling.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Fantôme: pale blue ghost with a wavy tail and a mischievous face.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `fantome_walk.png` |
| 1-2 | attaque 1 | `fantome_attack.png` |
| 2-1 | attaque 2 | `fantome_attack_2.png` |
| 2-2 | sort 1 | `fantome_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Fantôme », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Fantôme (enemy of the Brumes nation)
- Look: pale blue ghost with a wavy tail and a mischievous face
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. RISE: body stretched tall upward, arms raised.
3. LUNGE: body stretched forward, claws of mint mist and violet spectral wisps reaching out.
4. HOVER: floating higher, mint mist and violet spectral wisps orbs circling.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Fantôme: pale blue ghost with a wavy tail and a mischievous face.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `fantome_back_walk.png` |
| 1-2 | attaque 1 | `fantome_back_attack.png` |
| 2-1 | attaque 2 | `fantome_back_attack_2.png` |
| 2-2 | sort 1 | `fantome_back_cast.png` |

## 4. Boss

### Ombrelis le Brumeux — 22 poses

6 planches, 22 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `brumes_<clé>.png` (ex. `brumes_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Ombrelis le Brumeux », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombrelis le Brumeux (boss of the Brumes nation)
- Body: dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A)
- Head: spiked crown, gaunt pale face, glowing mint eyes
- Weapon: skull-topped staff surrounded by mint mist, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no sword.
NATION PALETTE: black, deep violet, mist mint green, silver. Signature effects (keep them small): mint mist and violet spectral wisps.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Ombrelis le Brumeux: dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A); spiked crown, gaunt pale face, glowing mint eyes; skull-topped staff surrounded by mint mist, RIGHT hand. Forbidden: no hood, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `brumes.png` |
| 1-2 | repos 1 (dos) | `brumes_back.png` |

#### Planche 2 — Face 1 · garde, marche, sort (`face_1`)

Dans l'Atelier : personnage « Ombrelis le Brumeux », planche « Face 1 · garde, marche, sort ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombrelis le Brumeux (boss of the Brumes nation)
- Body: dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A)
- Head: spiked crown, gaunt pale face, glowing mint eyes
- Weapon: skull-topped staff surrounded by mint mist, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. GUARD: knees bent, weapon raised in front of the body, ready to fight.
2. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
3. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
4. READING: grimoire floating open in front, pages turning, mint mist and violet spectral wisps rising from it.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Ombrelis le Brumeux: dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A); spiked crown, gaunt pale face, glowing mint eyes; skull-topped staff surrounded by mint mist, RIGHT hand. Forbidden: no hood, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 2 | `brumes_idle_2.png` |
| 1-2 | marche 1 | `brumes_walk.png` |
| 2-1 | marche 2 | `brumes_walk_2.png` |
| 2-2 | sort 1 | `brumes_cast.png` |

#### Planche 3 — Face 2 · attaques 1 à 4 (`face_2`)

Dans l'Atelier : personnage « Ombrelis le Brumeux », planche « Face 2 · attaques 1 à 4 ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombrelis le Brumeux (boss of the Brumes nation)
- Body: dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A)
- Head: spiked crown, gaunt pale face, glowing mint eyes
- Weapon: skull-topped staff surrounded by mint mist, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. OVERHEAD STRIKE: staff raised high above the head, grimoire floating behind.
2. PALM BOLT: free arm stretched forward, a mint mist and violet spectral wisps bolt leaving the open palm.
3. SIDE SWING: staff swept horizontally, coat swirling.
4. GRIMOIRE SLAM: grimoire snapping shut in front, a small mint mist and violet spectral wisps shockwave.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Ombrelis le Brumeux: dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A); spiked crown, gaunt pale face, glowing mint eyes; skull-topped staff surrounded by mint mist, RIGHT hand. Forbidden: no hood, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `brumes_attack.png` |
| 1-2 | attaque 2 | `brumes_attack_2.png` |
| 2-1 | attaque 3 | `brumes_attack_3.png` |
| 2-2 | attaque 4 | `brumes_attack_4.png` |

#### Planche 4 — Face 3 · attaques 5-6, sorts 2-3 (`face_3`)

Dans l'Atelier : personnage « Ombrelis le Brumeux », planche « Face 3 · attaques 5-6, sorts 2-3 ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombrelis le Brumeux (boss of the Brumes nation)
- Body: dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A)
- Head: spiked crown, gaunt pale face, glowing mint eyes
- Weapon: skull-topped staff surrounded by mint mist, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. LOW SWEEP: crouched, staff swinging near the ground.
2. CLAWS: free hand raised as a claw, mint mist and violet spectral wisps claws forming in front.
3. SUMMONING CIRCLE: staff raised, a mint mist and violet spectral wisps circle drawn on the ground.
4. SUMMON: both arms open wide, a mint mist and violet spectral wisps creature silhouette emerging beside.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Ombrelis le Brumeux: dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A); spiked crown, gaunt pale face, glowing mint eyes; skull-topped staff surrounded by mint mist, RIGHT hand. Forbidden: no hood, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 5 | `brumes_attack_5.png` |
| 1-2 | attaque 6 | `brumes_attack_6.png` |
| 2-1 | sort 2 | `brumes_cast_2.png` |
| 2-2 | sort 3 | `brumes_cast_3.png` |

#### Planche 5 — Dos 1 · marche, attaque, sort (`dos_1`)

Dans l'Atelier : personnage « Ombrelis le Brumeux », planche « Dos 1 · marche, attaque, sort ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombrelis le Brumeux (boss of the Brumes nation)
- Body: dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A)
- Head: spiked crown, gaunt pale face, glowing mint eyes
- Weapon: skull-topped staff surrounded by mint mist, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
3. OVERHEAD STRIKE: staff raised high above the head, grimoire floating behind.
4. READING: grimoire floating open in front, pages turning, mint mist and violet spectral wisps rising from it.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Ombrelis le Brumeux: dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A); spiked crown, gaunt pale face, glowing mint eyes; skull-topped staff surrounded by mint mist, RIGHT hand. Forbidden: no hood, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `brumes_back_walk.png` |
| 1-2 | marche 2 | `brumes_back_walk_2.png` |
| 2-1 | attaque 1 | `brumes_back_attack.png` |
| 2-2 | sort 1 | `brumes_back_cast.png` |

#### Planche 6 — Dos 2 · attaques 2 à 4, garde (`dos_2`)

Dans l'Atelier : personnage « Ombrelis le Brumeux », planche « Dos 2 · attaques 2 à 4, garde ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombrelis le Brumeux (boss of the Brumes nation)
- Body: dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A)
- Head: spiked crown, gaunt pale face, glowing mint eyes
- Weapon: skull-topped staff surrounded by mint mist, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. PALM BOLT: free arm stretched forward, a mint mist and violet spectral wisps bolt leaving the open palm.
2. SIDE SWING: staff swept horizontally, coat swirling.
3. GRIMOIRE SLAM: grimoire snapping shut in front, a small mint mist and violet spectral wisps shockwave.
4. GUARD: knees bent, weapon raised in front of the body, ready to fight.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Ombrelis le Brumeux: dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A); spiked crown, gaunt pale face, glowing mint eyes; skull-topped staff surrounded by mint mist, RIGHT hand. Forbidden: no hood, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 2 | `brumes_back_attack_2.png` |
| 1-2 | attaque 3 | `brumes_back_attack_3.png` |
| 2-1 | attaque 4 | `brumes_back_attack_4.png` |
| 2-2 | repos 2 | `brumes_back_idle_2.png` |

## Prompt négatif (toutes les planches de cette page)

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses, identical poses, repeated pose, copy of the same pose, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, front and back views mixed, different character between poses, realistic proportions, small head
```
