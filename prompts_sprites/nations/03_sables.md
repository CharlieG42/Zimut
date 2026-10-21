# Nation Sables (Désert)

Palette : sand gold, terracotta, amber, small turquoise accents. Effets : swirling sand and amber shards. Contre-jour : warm golden.

Chaque personnage est dessiné en **vue 3/4 avant (face)** et en **vue 3/4 arrière (dos)**. Le jeu retourne l'image pour les directions vers la gauche. Une fiche de référence (repos face + dos), puis des planches de 4 poses (2 × 2) bien séparées. Prompt négatif : voir en bas de page.

Ordre conseillé : 1) planche de référence, 2) héros, 3) ennemis, 4) boss.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos. Joins-la comme image de référence à toutes les planches suivantes.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Sables nation (Désert biome).
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents. Signature effects: swirling sand and amber shards.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
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

### Géomancien — 22 poses

6 planches, 22 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `geomancien_<clé>.png` (ex. `geomancien_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Géomancien », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Géomancien (hero of the Sables nation)
- Hair: short brown hair (#7A4A28)
- Eyes: amber-brown eyes, always open
- Skin: light tan skin
- Top: layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and small amber gems
- Bottom: sand-colored wrapped trousers
- Feet: brown sandals with cloth wraps
- Weapon: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no turban, no blue or green clothes.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents. Signature effects (keep them small): swirling sand and amber shards.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Géomancien: short brown hair (#7A4A28); amber-brown eyes, always open; light tan skin; layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and small amber gems. Forbidden: no hood, no turban, no blue or green clothes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `geomancien.png` |
| 1-2 | repos 1 (dos) | `geomancien_back.png` |

#### Planche 2 — Face 1 · garde, marche, sort (`face_1`)

Dans l'Atelier : personnage « Géomancien », planche « Face 1 · garde, marche, sort ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Géomancien (hero of the Sables nation)
- Hair: short brown hair (#7A4A28)
- Eyes: amber-brown eyes, always open
- Skin: light tan skin
- Top: layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and small amber gems
- Bottom: sand-colored wrapped trousers
- Feet: brown sandals with cloth wraps
- Weapon: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no turban, no blue or green clothes.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. GUARD: knees bent, weapon raised in front of the body, ready to fight.
2. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
3. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
4. FOCUS: eyes closed, staff held vertically in front of the face, swirling sand and amber shards orb at the top.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Géomancien: short brown hair (#7A4A28); amber-brown eyes, always open; light tan skin; layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and small amber gems. Forbidden: no hood, no turban, no blue or green clothes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 2 | `geomancien_idle_2.png` |
| 1-2 | marche 1 | `geomancien_walk.png` |
| 2-1 | marche 2 | `geomancien_walk_2.png` |
| 2-2 | sort 1 | `geomancien_cast.png` |

#### Planche 3 — Face 2 · attaques 1 à 4 (`face_2`)

Dans l'Atelier : personnage « Géomancien », planche « Face 2 · attaques 1 à 4 ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Géomancien (hero of the Sables nation)
- Hair: short brown hair (#7A4A28)
- Eyes: amber-brown eyes, always open
- Skin: light tan skin
- Top: layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and small amber gems
- Bottom: sand-colored wrapped trousers
- Feet: brown sandals with cloth wraps
- Weapon: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no turban, no blue or green clothes.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short swirling sand and amber shards spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. JUMPING STRIKE: whole body in the air, staff held back over the shoulder.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Géomancien: short brown hair (#7A4A28); amber-brown eyes, always open; light tan skin; layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and small amber gems. Forbidden: no hood, no turban, no blue or green clothes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `geomancien_attack.png` |
| 1-2 | attaque 2 | `geomancien_attack_2.png` |
| 2-1 | attaque 3 | `geomancien_attack_3.png` |
| 2-2 | attaque 4 | `geomancien_attack_4.png` |

#### Planche 4 — Face 3 · attaques 5-6, sorts 2-3 (`face_3`)

Dans l'Atelier : personnage « Géomancien », planche « Face 3 · attaques 5-6, sorts 2-3 ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Géomancien (hero of the Sables nation)
- Hair: short brown hair (#7A4A28)
- Eyes: amber-brown eyes, always open
- Skin: light tan skin
- Top: layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and small amber gems
- Bottom: sand-colored wrapped trousers
- Feet: brown sandals with cloth wraps
- Weapon: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no turban, no blue or green clothes.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. LOW SWEEP: crouched, staff swinging at ankle height.
2. SPIN: staff whirling around the body, a swirling sand and amber shards trail circling it.
3. INVOCATION: staff raised high with both hands, swirling sand and amber shards swirling above the head.
4. BLAST: staff pointed forward, a compact swirling sand and amber shards blast leaving the tip.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Géomancien: short brown hair (#7A4A28); amber-brown eyes, always open; light tan skin; layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and small amber gems. Forbidden: no hood, no turban, no blue or green clothes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 5 | `geomancien_attack_5.png` |
| 1-2 | attaque 6 | `geomancien_attack_6.png` |
| 2-1 | sort 2 | `geomancien_cast_2.png` |
| 2-2 | sort 3 | `geomancien_cast_3.png` |

#### Planche 5 — Dos 1 · marche, attaque, sort (`dos_1`)

Dans l'Atelier : personnage « Géomancien », planche « Dos 1 · marche, attaque, sort ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Géomancien (hero of the Sables nation)
- Hair: short brown hair (#7A4A28)
- Eyes: amber-brown eyes, always open
- Skin: light tan skin
- Top: layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and small amber gems
- Bottom: sand-colored wrapped trousers
- Feet: brown sandals with cloth wraps
- Weapon: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no turban, no blue or green clothes.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
3. OVERHEAD STRIKE: staff raised high above the head with both hands.
4. FOCUS: eyes closed, staff held vertically in front of the face, swirling sand and amber shards orb at the top.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Géomancien: short brown hair (#7A4A28); amber-brown eyes, always open; light tan skin; layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and small amber gems. Forbidden: no hood, no turban, no blue or green clothes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `geomancien_back_walk.png` |
| 1-2 | marche 2 | `geomancien_back_walk_2.png` |
| 2-1 | attaque 1 | `geomancien_back_attack.png` |
| 2-2 | sort 1 | `geomancien_back_cast.png` |

#### Planche 6 — Dos 2 · attaques 2 à 4, garde (`dos_2`)

Dans l'Atelier : personnage « Géomancien », planche « Dos 2 · attaques 2 à 4, garde ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Géomancien (hero of the Sables nation)
- Hair: short brown hair (#7A4A28)
- Eyes: amber-brown eyes, always open
- Skin: light tan skin
- Top: layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and small amber gems
- Bottom: sand-colored wrapped trousers
- Feet: brown sandals with cloth wraps
- Weapon: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no turban, no blue or green clothes.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. THRUST: body leaning forward, staff tip pushed far ahead with a short swirling sand and amber shards spark.
2. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
3. JUMPING STRIKE: whole body in the air, staff held back over the shoulder.
4. GUARD: knees bent, weapon raised in front of the body, ready to fight.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Géomancien: short brown hair (#7A4A28); amber-brown eyes, always open; light tan skin; layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and small amber gems. Forbidden: no hood, no turban, no blue or green clothes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 2 | `geomancien_back_attack_2.png` |
| 1-2 | attaque 3 | `geomancien_back_attack_3.png` |
| 2-1 | attaque 4 | `geomancien_back_attack_4.png` |
| 2-2 | repos 2 | `geomancien_back_idle_2.png` |

L'export Zimut de l'Atelier copie aussi le repos vers `nations/heros/geomancien.png` et les autres poses vers `nations/heros/poses/`.

## 3. Ennemis

### Bandit des dunes — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sables/` ; nomme tes images `bandit_des_dunes_<clé>.png` (ex. `bandit_des_dunes_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Bandit des dunes », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Bandit des dunes (enemy of the Sables nation)
- Body: small jackal-folk bandit standing on two legs, orange fur (#D9822B) with a cream muzzle
- Head: tall jackal ears, yellow eyes, sand-colored scarf (#E3CF9A) over the mouth
- Top: brown leather vest with a red sash
- Bottom: baggy sand-colored trousers, bare paws
- Weapon: one curved dagger in the RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no bow, no sword, no hood, no human face.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents. Signature effects (keep them small): swirling sand and amber shards.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Bandit des dunes: small jackal-folk bandit standing on two legs, orange fur (#D9822B) with a cream muzzle; tall jackal ears, yellow eyes, sand-colored scarf (#E3CF9A) over the mouth; brown leather vest with a red sash; baggy sand-colored trousers, bare paws. Forbidden: no bow, no sword, no hood, no human face.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `bandit_des_dunes.png` |
| 1-2 | repos 1 (dos) | `bandit_des_dunes_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Bandit des dunes », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Bandit des dunes (enemy of the Sables nation)
- Body: small jackal-folk bandit standing on two legs, orange fur (#D9822B) with a cream muzzle
- Head: tall jackal ears, yellow eyes, sand-colored scarf (#E3CF9A) over the mouth
- Top: brown leather vest with a red sash
- Bottom: baggy sand-colored trousers, bare paws
- Weapon: one curved dagger in the RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no bow, no sword, no hood, no human face.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. CROSS SLASH: both daggers crossed high above the head, about to strike down.
3. LUNGE STAB: body stretched forward almost horizontal, one dagger thrust far ahead.
4. SHADOW KNEEL: kneeling, one hand on the ground, swirling sand and amber shards rising around.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Bandit des dunes: small jackal-folk bandit standing on two legs, orange fur (#D9822B) with a cream muzzle; tall jackal ears, yellow eyes, sand-colored scarf (#E3CF9A) over the mouth; brown leather vest with a red sash; baggy sand-colored trousers, bare paws. Forbidden: no bow, no sword, no hood, no human face.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `bandit_des_dunes_walk.png` |
| 1-2 | attaque 1 | `bandit_des_dunes_attack.png` |
| 2-1 | attaque 2 | `bandit_des_dunes_attack_2.png` |
| 2-2 | sort 1 | `bandit_des_dunes_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Bandit des dunes », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Bandit des dunes (enemy of the Sables nation)
- Body: small jackal-folk bandit standing on two legs, orange fur (#D9822B) with a cream muzzle
- Head: tall jackal ears, yellow eyes, sand-colored scarf (#E3CF9A) over the mouth
- Top: brown leather vest with a red sash
- Bottom: baggy sand-colored trousers, bare paws
- Weapon: one curved dagger in the RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no bow, no sword, no hood, no human face.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. CROSS SLASH: both daggers crossed high above the head, about to strike down.
3. LUNGE STAB: body stretched forward almost horizontal, one dagger thrust far ahead.
4. SHADOW KNEEL: kneeling, one hand on the ground, swirling sand and amber shards rising around.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Bandit des dunes: small jackal-folk bandit standing on two legs, orange fur (#D9822B) with a cream muzzle; tall jackal ears, yellow eyes, sand-colored scarf (#E3CF9A) over the mouth; brown leather vest with a red sash; baggy sand-colored trousers, bare paws. Forbidden: no bow, no sword, no hood, no human face.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `bandit_des_dunes_back_walk.png` |
| 1-2 | attaque 1 | `bandit_des_dunes_back_attack.png` |
| 2-1 | attaque 2 | `bandit_des_dunes_back_attack_2.png` |
| 2-2 | sort 1 | `bandit_des_dunes_back_cast.png` |

### Scarabée géant — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sables/` ; nomme tes images `scarabee_geant_<clé>.png` (ex. `scarabee_geant_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Scarabée géant », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Scarabée géant (enemy of the Sables nation)
- Body: giant scarab beetle on six legs, glossy black shell (#1A1A1E) with gold edges and patterns (#E0B040)
- Head: big golden horn and two smaller golden horns, small red eyes
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings spread, no rider, no human body.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents. Signature effects (keep them small): swirling sand and amber shards.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Scarabée géant: giant scarab beetle on six legs, glossy black shell (#1A1A1E) with gold edges and patterns (#E0B040); big golden horn and two smaller golden horns, small red eyes. Forbidden: no wings spread, no rider, no human body.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `scarabee_geant.png` |
| 1-2 | repos 1 (dos) | `scarabee_geant_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Scarabée géant », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Scarabée géant (enemy of the Sables nation)
- Body: giant scarab beetle on six legs, glossy black shell (#1A1A1E) with gold edges and patterns (#E0B040)
- Head: big golden horn and two smaller golden horns, small red eyes
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings spread, no rider, no human body.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. REARING: standing up on the hind legs, front claws raised high.
3. POUNCE: body stretched forward in the air, jaws open.
4. HOWL: head raised to the sky, swirling sand and amber shards gathering around the body.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Scarabée géant: giant scarab beetle on six legs, glossy black shell (#1A1A1E) with gold edges and patterns (#E0B040); big golden horn and two smaller golden horns, small red eyes. Forbidden: no wings spread, no rider, no human body.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `scarabee_geant_walk.png` |
| 1-2 | attaque 1 | `scarabee_geant_attack.png` |
| 2-1 | attaque 2 | `scarabee_geant_attack_2.png` |
| 2-2 | sort 1 | `scarabee_geant_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Scarabée géant », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Scarabée géant (enemy of the Sables nation)
- Body: giant scarab beetle on six legs, glossy black shell (#1A1A1E) with gold edges and patterns (#E0B040)
- Head: big golden horn and two smaller golden horns, small red eyes
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings spread, no rider, no human body.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. REARING: standing up on the hind legs, front claws raised high.
3. POUNCE: body stretched forward in the air, jaws open.
4. HOWL: head raised to the sky, swirling sand and amber shards gathering around the body.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Scarabée géant: giant scarab beetle on six legs, glossy black shell (#1A1A1E) with gold edges and patterns (#E0B040); big golden horn and two smaller golden horns, small red eyes. Forbidden: no wings spread, no rider, no human body.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `scarabee_geant_back_walk.png` |
| 1-2 | attaque 1 | `scarabee_geant_back_attack.png` |
| 2-1 | attaque 2 | `scarabee_geant_back_attack_2.png` |
| 2-2 | sort 1 | `scarabee_geant_back_cast.png` |

### Génie du désert — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sables/` ; nomme tes images `genie_du_desert_<clé>.png` (ex. `genie_du_desert_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Génie du désert », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Génie du désert (enemy of the Sables nation)
- Body: golden-skinned sand djinn (#E0B050) with a muscular bare chest and arms, golden bracelets
- Head: bald head with a long black topknot, glowing amber eyes, pointed ears
- Bottom: no legs: lower body of swirling sand (#D9C08A)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no blue skin, no clothes on the torso.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents. Signature effects (keep them small): swirling sand and amber shards.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Génie du désert: golden-skinned sand djinn (#E0B050) with a muscular bare chest and arms, golden bracelets; bald head with a long black topknot, glowing amber eyes, pointed ears; no legs: lower body of swirling sand (#D9C08A). Forbidden: no weapon, no blue skin, no clothes on the torso.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `genie_du_desert.png` |
| 1-2 | repos 1 (dos) | `genie_du_desert_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Génie du désert », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Génie du désert (enemy of the Sables nation)
- Body: golden-skinned sand djinn (#E0B050) with a muscular bare chest and arms, golden bracelets
- Head: bald head with a long black topknot, glowing amber eyes, pointed ears
- Bottom: no legs: lower body of swirling sand (#D9C08A)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no blue skin, no clothes on the torso.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. RISE: body stretched tall upward, arms raised.
3. LUNGE: body stretched forward, claws of swirling sand and amber shards reaching out.
4. HOVER: floating higher, swirling sand and amber shards orbs circling.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Génie du désert: golden-skinned sand djinn (#E0B050) with a muscular bare chest and arms, golden bracelets; bald head with a long black topknot, glowing amber eyes, pointed ears; no legs: lower body of swirling sand (#D9C08A). Forbidden: no weapon, no blue skin, no clothes on the torso.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `genie_du_desert_walk.png` |
| 1-2 | attaque 1 | `genie_du_desert_attack.png` |
| 2-1 | attaque 2 | `genie_du_desert_attack_2.png` |
| 2-2 | sort 1 | `genie_du_desert_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Génie du désert », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Génie du désert (enemy of the Sables nation)
- Body: golden-skinned sand djinn (#E0B050) with a muscular bare chest and arms, golden bracelets
- Head: bald head with a long black topknot, glowing amber eyes, pointed ears
- Bottom: no legs: lower body of swirling sand (#D9C08A)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no blue skin, no clothes on the torso.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. RISE: body stretched tall upward, arms raised.
3. LUNGE: body stretched forward, claws of swirling sand and amber shards reaching out.
4. HOVER: floating higher, swirling sand and amber shards orbs circling.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Génie du désert: golden-skinned sand djinn (#E0B050) with a muscular bare chest and arms, golden bracelets; bald head with a long black topknot, glowing amber eyes, pointed ears; no legs: lower body of swirling sand (#D9C08A). Forbidden: no weapon, no blue skin, no clothes on the torso.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `genie_du_desert_back_walk.png` |
| 1-2 | attaque 1 | `genie_du_desert_back_attack.png` |
| 2-1 | attaque 2 | `genie_du_desert_back_attack_2.png` |
| 2-2 | sort 1 | `genie_du_desert_back_cast.png` |

### Sphinx — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sables/` ; nomme tes images `sphinx_<clé>.png` (ex. `sphinx_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Sphinx », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sphinx (enemy of the Sables nation)
- Body: golden lion sphinx on four legs (#D9A848) with a lion tail
- Head: human-like calm face, striped blue-and-gold pharaoh headdress (#2E56A8, #E0B040), kohl-lined amber eyes
- Details: small golden collar, no wings
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no weapon, standing on four legs only.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents. Signature effects (keep them small): swirling sand and amber shards.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Sphinx: golden lion sphinx on four legs (#D9A848) with a lion tail; human-like calm face, striped blue-and-gold pharaoh headdress (#2E56A8, #E0B040), kohl-lined amber eyes; small golden collar, no wings. Forbidden: no wings, no weapon, standing on four legs only.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `sphinx.png` |
| 1-2 | repos 1 (dos) | `sphinx_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Sphinx », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sphinx (enemy of the Sables nation)
- Body: golden lion sphinx on four legs (#D9A848) with a lion tail
- Head: human-like calm face, striped blue-and-gold pharaoh headdress (#2E56A8, #E0B040), kohl-lined amber eyes
- Details: small golden collar, no wings
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no weapon, standing on four legs only.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. REARING: standing up on the hind legs, front claws raised high.
3. POUNCE: body stretched forward in the air, jaws open.
4. HOWL: head raised to the sky, swirling sand and amber shards gathering around the body.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Sphinx: golden lion sphinx on four legs (#D9A848) with a lion tail; human-like calm face, striped blue-and-gold pharaoh headdress (#2E56A8, #E0B040), kohl-lined amber eyes; small golden collar, no wings. Forbidden: no wings, no weapon, standing on four legs only.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `sphinx_walk.png` |
| 1-2 | attaque 1 | `sphinx_attack.png` |
| 2-1 | attaque 2 | `sphinx_attack_2.png` |
| 2-2 | sort 1 | `sphinx_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Sphinx », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sphinx (enemy of the Sables nation)
- Body: golden lion sphinx on four legs (#D9A848) with a lion tail
- Head: human-like calm face, striped blue-and-gold pharaoh headdress (#2E56A8, #E0B040), kohl-lined amber eyes
- Details: small golden collar, no wings
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no weapon, standing on four legs only.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. REARING: standing up on the hind legs, front claws raised high.
3. POUNCE: body stretched forward in the air, jaws open.
4. HOWL: head raised to the sky, swirling sand and amber shards gathering around the body.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Sphinx: golden lion sphinx on four legs (#D9A848) with a lion tail; human-like calm face, striped blue-and-gold pharaoh headdress (#2E56A8, #E0B040), kohl-lined amber eyes; small golden collar, no wings. Forbidden: no wings, no weapon, standing on four legs only.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `sphinx_back_walk.png` |
| 1-2 | attaque 1 | `sphinx_back_attack.png` |
| 2-1 | attaque 2 | `sphinx_back_attack_2.png` |
| 2-2 | sort 1 | `sphinx_back_cast.png` |

## 4. Boss

### Zahor le Sableux — 22 poses

6 planches, 22 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `sables_<clé>.png` (ex. `sables_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Zahor le Sableux », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Zahor le Sableux (boss of the Sables nation)
- Body: sand sovereign in ornate golden armor (#D4A63A) with sharp layered plates
- Head: crested golden helm, dark face shadow with glowing amber eyes
- Weapon: tall golden staff with a giant amber crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no cape, no sword.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents. Signature effects (keep them small): swirling sand and amber shards.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Zahor le Sableux: sand sovereign in ornate golden armor (#D4A63A) with sharp layered plates; crested golden helm, dark face shadow with glowing amber eyes; tall golden staff with a giant amber crystal, RIGHT hand. Forbidden: no cape, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `sables.png` |
| 1-2 | repos 1 (dos) | `sables_back.png` |

#### Planche 2 — Face 1 · garde, marche, sort (`face_1`)

Dans l'Atelier : personnage « Zahor le Sableux », planche « Face 1 · garde, marche, sort ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Zahor le Sableux (boss of the Sables nation)
- Body: sand sovereign in ornate golden armor (#D4A63A) with sharp layered plates
- Head: crested golden helm, dark face shadow with glowing amber eyes
- Weapon: tall golden staff with a giant amber crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no cape, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. GUARD: knees bent, weapon raised in front of the body, ready to fight.
2. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
3. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
4. FOCUS: eyes closed, staff held vertically in front of the face, swirling sand and amber shards orb at the top.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Zahor le Sableux: sand sovereign in ornate golden armor (#D4A63A) with sharp layered plates; crested golden helm, dark face shadow with glowing amber eyes; tall golden staff with a giant amber crystal, RIGHT hand. Forbidden: no cape, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 2 | `sables_idle_2.png` |
| 1-2 | marche 1 | `sables_walk.png` |
| 2-1 | marche 2 | `sables_walk_2.png` |
| 2-2 | sort 1 | `sables_cast.png` |

#### Planche 3 — Face 2 · attaques 1 à 4 (`face_2`)

Dans l'Atelier : personnage « Zahor le Sableux », planche « Face 2 · attaques 1 à 4 ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Zahor le Sableux (boss of the Sables nation)
- Body: sand sovereign in ornate golden armor (#D4A63A) with sharp layered plates
- Head: crested golden helm, dark face shadow with glowing amber eyes
- Weapon: tall golden staff with a giant amber crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no cape, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short swirling sand and amber shards spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. JUMPING STRIKE: whole body in the air, staff held back over the shoulder.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Zahor le Sableux: sand sovereign in ornate golden armor (#D4A63A) with sharp layered plates; crested golden helm, dark face shadow with glowing amber eyes; tall golden staff with a giant amber crystal, RIGHT hand. Forbidden: no cape, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `sables_attack.png` |
| 1-2 | attaque 2 | `sables_attack_2.png` |
| 2-1 | attaque 3 | `sables_attack_3.png` |
| 2-2 | attaque 4 | `sables_attack_4.png` |

#### Planche 4 — Face 3 · attaques 5-6, sorts 2-3 (`face_3`)

Dans l'Atelier : personnage « Zahor le Sableux », planche « Face 3 · attaques 5-6, sorts 2-3 ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Zahor le Sableux (boss of the Sables nation)
- Body: sand sovereign in ornate golden armor (#D4A63A) with sharp layered plates
- Head: crested golden helm, dark face shadow with glowing amber eyes
- Weapon: tall golden staff with a giant amber crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no cape, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. LOW SWEEP: crouched, staff swinging at ankle height.
2. SPIN: staff whirling around the body, a swirling sand and amber shards trail circling it.
3. INVOCATION: staff raised high with both hands, swirling sand and amber shards swirling above the head.
4. BLAST: staff pointed forward, a compact swirling sand and amber shards blast leaving the tip.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Zahor le Sableux: sand sovereign in ornate golden armor (#D4A63A) with sharp layered plates; crested golden helm, dark face shadow with glowing amber eyes; tall golden staff with a giant amber crystal, RIGHT hand. Forbidden: no cape, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 5 | `sables_attack_5.png` |
| 1-2 | attaque 6 | `sables_attack_6.png` |
| 2-1 | sort 2 | `sables_cast_2.png` |
| 2-2 | sort 3 | `sables_cast_3.png` |

#### Planche 5 — Dos 1 · marche, attaque, sort (`dos_1`)

Dans l'Atelier : personnage « Zahor le Sableux », planche « Dos 1 · marche, attaque, sort ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Zahor le Sableux (boss of the Sables nation)
- Body: sand sovereign in ornate golden armor (#D4A63A) with sharp layered plates
- Head: crested golden helm, dark face shadow with glowing amber eyes
- Weapon: tall golden staff with a giant amber crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no cape, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
3. OVERHEAD STRIKE: staff raised high above the head with both hands.
4. FOCUS: eyes closed, staff held vertically in front of the face, swirling sand and amber shards orb at the top.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Zahor le Sableux: sand sovereign in ornate golden armor (#D4A63A) with sharp layered plates; crested golden helm, dark face shadow with glowing amber eyes; tall golden staff with a giant amber crystal, RIGHT hand. Forbidden: no cape, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `sables_back_walk.png` |
| 1-2 | marche 2 | `sables_back_walk_2.png` |
| 2-1 | attaque 1 | `sables_back_attack.png` |
| 2-2 | sort 1 | `sables_back_cast.png` |

#### Planche 6 — Dos 2 · attaques 2 à 4, garde (`dos_2`)

Dans l'Atelier : personnage « Zahor le Sableux », planche « Dos 2 · attaques 2 à 4, garde ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Zahor le Sableux (boss of the Sables nation)
- Body: sand sovereign in ornate golden armor (#D4A63A) with sharp layered plates
- Head: crested golden helm, dark face shadow with glowing amber eyes
- Weapon: tall golden staff with a giant amber crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no cape, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. THRUST: body leaning forward, staff tip pushed far ahead with a short swirling sand and amber shards spark.
2. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
3. JUMPING STRIKE: whole body in the air, staff held back over the shoulder.
4. GUARD: knees bent, weapon raised in front of the body, ready to fight.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Zahor le Sableux: sand sovereign in ornate golden armor (#D4A63A) with sharp layered plates; crested golden helm, dark face shadow with glowing amber eyes; tall golden staff with a giant amber crystal, RIGHT hand. Forbidden: no cape, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 2 | `sables_back_attack_2.png` |
| 1-2 | attaque 3 | `sables_back_attack_3.png` |
| 2-1 | attaque 4 | `sables_back_attack_4.png` |
| 2-2 | repos 2 | `sables_back_idle_2.png` |

## Prompt négatif (toutes les planches de cette page)

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses, identical poses, repeated pose, copy of the same pose, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, front and back views mixed, different character between poses, realistic proportions, small head
```
