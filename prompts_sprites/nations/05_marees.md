# Nation Marées (Marées)

Palette : turquoise, white, gold trims, coral pink accents. Effets : water splashes and bubbles. Contre-jour : aqua.

Chaque personnage est dessiné en **vue 3/4 avant (face)** et en **vue 3/4 arrière (dos)**. Le jeu retourne l'image pour les directions vers la gauche. Une fiche de référence (repos face + dos), puis des planches de 4 poses (2 × 2) bien séparées. Prompt négatif : voir en bas de page.

Ordre conseillé : 1) planche de référence, 2) héros, 3) ennemis, 4) boss.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos. Joins-la comme image de référence à toutes les planches suivantes.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Marées nation (Marées biome).
NATION PALETTE: turquoise, white, gold trims, coral pink accents. Signature effects: water splashes and bubbles.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
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

### Heal (Soigneur) — 22 poses

6 planches, 22 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `heal_<clé>.png` (ex. `heal_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Heal », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Heal (hero of the Marées nation)
- Hair: long teal hair (#2BB3A8) tied low behind the back
- Eyes: soft turquoise eyes, always open
- Skin: fair skin
- Top: ornate white robe with turquoise panels (#3CC7C0), gold embroidery and wave patterns
- Bottom: long white robe skirt with turquoise hem
- Feet: white and gold slippers
- Weapon: golden staff topped with a glowing water-drop crystal (#7FE8FF), RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no armor, no dark clothes.
NATION PALETTE: turquoise, white, gold trims, coral pink accents. Signature effects (keep them small): water splashes and bubbles.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Heal: long teal hair (#2BB3A8) tied low behind the back; soft turquoise eyes, always open; fair skin; ornate white robe with turquoise panels (#3CC7C0), gold embroidery and wave patterns. Forbidden: no hood, no armor, no dark clothes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `heal.png` |
| 1-2 | repos 1 (dos) | `heal_back.png` |

#### Planche 2 — Face 1 · garde, marche, sort (`face_1`)

Dans l'Atelier : personnage « Heal », planche « Face 1 · garde, marche, sort ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Heal (hero of the Marées nation)
- Hair: long teal hair (#2BB3A8) tied low behind the back
- Eyes: soft turquoise eyes, always open
- Skin: fair skin
- Top: ornate white robe with turquoise panels (#3CC7C0), gold embroidery and wave patterns
- Bottom: long white robe skirt with turquoise hem
- Feet: white and gold slippers
- Weapon: golden staff topped with a glowing water-drop crystal (#7FE8FF), RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no armor, no dark clothes.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. GUARD: knees bent, weapon raised in front of the body, ready to fight.
2. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
3. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
4. FOCUS: eyes closed, staff held vertically in front of the face, water splashes and bubbles orb at the top.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Heal: long teal hair (#2BB3A8) tied low behind the back; soft turquoise eyes, always open; fair skin; ornate white robe with turquoise panels (#3CC7C0), gold embroidery and wave patterns. Forbidden: no hood, no armor, no dark clothes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 2 | `heal_idle_2.png` |
| 1-2 | marche 1 | `heal_walk.png` |
| 2-1 | marche 2 | `heal_walk_2.png` |
| 2-2 | sort 1 | `heal_cast.png` |

#### Planche 3 — Face 2 · attaques 1 à 4 (`face_2`)

Dans l'Atelier : personnage « Heal », planche « Face 2 · attaques 1 à 4 ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Heal (hero of the Marées nation)
- Hair: long teal hair (#2BB3A8) tied low behind the back
- Eyes: soft turquoise eyes, always open
- Skin: fair skin
- Top: ornate white robe with turquoise panels (#3CC7C0), gold embroidery and wave patterns
- Bottom: long white robe skirt with turquoise hem
- Feet: white and gold slippers
- Weapon: golden staff topped with a glowing water-drop crystal (#7FE8FF), RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no armor, no dark clothes.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short water splashes and bubbles spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. JUMPING STRIKE: whole body in the air, staff held back over the shoulder.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Heal: long teal hair (#2BB3A8) tied low behind the back; soft turquoise eyes, always open; fair skin; ornate white robe with turquoise panels (#3CC7C0), gold embroidery and wave patterns. Forbidden: no hood, no armor, no dark clothes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `heal_attack.png` |
| 1-2 | attaque 2 | `heal_attack_2.png` |
| 2-1 | attaque 3 | `heal_attack_3.png` |
| 2-2 | attaque 4 | `heal_attack_4.png` |

#### Planche 4 — Face 3 · attaques 5-6, sorts 2-3 (`face_3`)

Dans l'Atelier : personnage « Heal », planche « Face 3 · attaques 5-6, sorts 2-3 ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Heal (hero of the Marées nation)
- Hair: long teal hair (#2BB3A8) tied low behind the back
- Eyes: soft turquoise eyes, always open
- Skin: fair skin
- Top: ornate white robe with turquoise panels (#3CC7C0), gold embroidery and wave patterns
- Bottom: long white robe skirt with turquoise hem
- Feet: white and gold slippers
- Weapon: golden staff topped with a glowing water-drop crystal (#7FE8FF), RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no armor, no dark clothes.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. LOW SWEEP: crouched, staff swinging at ankle height.
2. SPIN: staff whirling around the body, a water splashes and bubbles trail circling it.
3. INVOCATION: staff raised high with both hands, water splashes and bubbles swirling above the head.
4. BLAST: staff pointed forward, a compact water splashes and bubbles blast leaving the tip.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Heal: long teal hair (#2BB3A8) tied low behind the back; soft turquoise eyes, always open; fair skin; ornate white robe with turquoise panels (#3CC7C0), gold embroidery and wave patterns. Forbidden: no hood, no armor, no dark clothes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 5 | `heal_attack_5.png` |
| 1-2 | attaque 6 | `heal_attack_6.png` |
| 2-1 | sort 2 | `heal_cast_2.png` |
| 2-2 | sort 3 | `heal_cast_3.png` |

#### Planche 5 — Dos 1 · marche, attaque, sort (`dos_1`)

Dans l'Atelier : personnage « Heal », planche « Dos 1 · marche, attaque, sort ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Heal (hero of the Marées nation)
- Hair: long teal hair (#2BB3A8) tied low behind the back
- Eyes: soft turquoise eyes, always open
- Skin: fair skin
- Top: ornate white robe with turquoise panels (#3CC7C0), gold embroidery and wave patterns
- Bottom: long white robe skirt with turquoise hem
- Feet: white and gold slippers
- Weapon: golden staff topped with a glowing water-drop crystal (#7FE8FF), RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no armor, no dark clothes.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
3. OVERHEAD STRIKE: staff raised high above the head with both hands.
4. FOCUS: eyes closed, staff held vertically in front of the face, water splashes and bubbles orb at the top.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Heal: long teal hair (#2BB3A8) tied low behind the back; soft turquoise eyes, always open; fair skin; ornate white robe with turquoise panels (#3CC7C0), gold embroidery and wave patterns. Forbidden: no hood, no armor, no dark clothes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `heal_back_walk.png` |
| 1-2 | marche 2 | `heal_back_walk_2.png` |
| 2-1 | attaque 1 | `heal_back_attack.png` |
| 2-2 | sort 1 | `heal_back_cast.png` |

#### Planche 6 — Dos 2 · attaques 2 à 4, garde (`dos_2`)

Dans l'Atelier : personnage « Heal », planche « Dos 2 · attaques 2 à 4, garde ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Heal (hero of the Marées nation)
- Hair: long teal hair (#2BB3A8) tied low behind the back
- Eyes: soft turquoise eyes, always open
- Skin: fair skin
- Top: ornate white robe with turquoise panels (#3CC7C0), gold embroidery and wave patterns
- Bottom: long white robe skirt with turquoise hem
- Feet: white and gold slippers
- Weapon: golden staff topped with a glowing water-drop crystal (#7FE8FF), RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no armor, no dark clothes.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. THRUST: body leaning forward, staff tip pushed far ahead with a short water splashes and bubbles spark.
2. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
3. JUMPING STRIKE: whole body in the air, staff held back over the shoulder.
4. GUARD: knees bent, weapon raised in front of the body, ready to fight.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Heal: long teal hair (#2BB3A8) tied low behind the back; soft turquoise eyes, always open; fair skin; ornate white robe with turquoise panels (#3CC7C0), gold embroidery and wave patterns. Forbidden: no hood, no armor, no dark clothes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 2 | `heal_back_attack_2.png` |
| 1-2 | attaque 3 | `heal_back_attack_3.png` |
| 2-1 | attaque 4 | `heal_back_attack_4.png` |
| 2-2 | repos 2 | `heal_back_idle_2.png` |

L'export Zimut de l'Atelier copie aussi le repos vers `nations/heros/heal.png` et les autres poses vers `nations/heros/poses/`.

## 3. Ennemis

### Pirate des mers — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/marees/` ; nomme tes images `pirate_des_mers_<clé>.png` (ex. `pirate_des_mers_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Pirate des mers », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Pirate des mers (enemy of the Marées nation)
- Look: sea pirate with a red bandana, blue coat, leather belts and a short cutlass
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
NATION PALETTE: turquoise, white, gold trims, coral pink accents. Signature effects (keep them small): water splashes and bubbles.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Pirate des mers: sea pirate with a red bandana, blue coat, leather belts and a short cutlass.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `pirate_des_mers.png` |
| 1-2 | repos 1 (dos) | `pirate_des_mers_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Pirate des mers », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Pirate des mers (enemy of the Marées nation)
- Look: sea pirate with a red bandana, blue coat, leather belts and a short cutlass
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. CROSS SLASH: both daggers crossed high above the head, about to strike down.
3. LUNGE STAB: body stretched forward almost horizontal, one dagger thrust far ahead.
4. SHADOW KNEEL: kneeling, one hand on the ground, water splashes and bubbles rising around.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Pirate des mers: sea pirate with a red bandana, blue coat, leather belts and a short cutlass.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `pirate_des_mers_walk.png` |
| 1-2 | attaque 1 | `pirate_des_mers_attack.png` |
| 2-1 | attaque 2 | `pirate_des_mers_attack_2.png` |
| 2-2 | sort 1 | `pirate_des_mers_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Pirate des mers », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Pirate des mers (enemy of the Marées nation)
- Look: sea pirate with a red bandana, blue coat, leather belts and a short cutlass
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. CROSS SLASH: both daggers crossed high above the head, about to strike down.
3. LUNGE STAB: body stretched forward almost horizontal, one dagger thrust far ahead.
4. SHADOW KNEEL: kneeling, one hand on the ground, water splashes and bubbles rising around.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Pirate des mers: sea pirate with a red bandana, blue coat, leather belts and a short cutlass.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `pirate_des_mers_back_walk.png` |
| 1-2 | attaque 1 | `pirate_des_mers_back_attack.png` |
| 2-1 | attaque 2 | `pirate_des_mers_back_attack_2.png` |
| 2-2 | sort 1 | `pirate_des_mers_back_cast.png` |

### Requin — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/marees/` ; nomme tes images `requin_<clé>.png` (ex. `requin_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Requin », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Requin (enemy of the Marées nation)
- Look: blue shark with a white belly swimming upright in the air, toothy grin
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
NATION PALETTE: turquoise, white, gold trims, coral pink accents. Signature effects (keep them small): water splashes and bubbles.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Requin: blue shark with a white belly swimming upright in the air, toothy grin.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `requin.png` |
| 1-2 | repos 1 (dos) | `requin_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Requin », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Requin (enemy of the Marées nation)
- Look: blue shark with a white belly swimming upright in the air, toothy grin
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. REARING: standing up on the hind legs, front claws raised high.
3. POUNCE: body stretched forward in the air, jaws open.
4. HOWL: head raised to the sky, water splashes and bubbles gathering around the body.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Requin: blue shark with a white belly swimming upright in the air, toothy grin.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `requin_walk.png` |
| 1-2 | attaque 1 | `requin_attack.png` |
| 2-1 | attaque 2 | `requin_attack_2.png` |
| 2-2 | sort 1 | `requin_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Requin », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Requin (enemy of the Marées nation)
- Look: blue shark with a white belly swimming upright in the air, toothy grin
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. REARING: standing up on the hind legs, front claws raised high.
3. POUNCE: body stretched forward in the air, jaws open.
4. HOWL: head raised to the sky, water splashes and bubbles gathering around the body.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Requin: blue shark with a white belly swimming upright in the air, toothy grin.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `requin_back_walk.png` |
| 1-2 | attaque 1 | `requin_back_attack.png` |
| 2-1 | attaque 2 | `requin_back_attack_2.png` |
| 2-2 | sort 1 | `requin_back_cast.png` |

### Néréide — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/marees/` ; nomme tes images `nereide_<clé>.png` (ex. `nereide_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Néréide », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Néréide (enemy of the Marées nation)
- Look: water nymph made of translucent-looking turquoise water, flowing hair of waves
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
NATION PALETTE: turquoise, white, gold trims, coral pink accents. Signature effects (keep them small): water splashes and bubbles.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Néréide: water nymph made of translucent-looking turquoise water, flowing hair of waves.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `nereide.png` |
| 1-2 | repos 1 (dos) | `nereide_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Néréide », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Néréide (enemy of the Marées nation)
- Look: water nymph made of translucent-looking turquoise water, flowing hair of waves
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. RISE: body stretched tall upward, arms raised.
3. LUNGE: body stretched forward, claws of water splashes and bubbles reaching out.
4. HOVER: floating higher, water splashes and bubbles orbs circling.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Néréide: water nymph made of translucent-looking turquoise water, flowing hair of waves.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `nereide_walk.png` |
| 1-2 | attaque 1 | `nereide_attack.png` |
| 2-1 | attaque 2 | `nereide_attack_2.png` |
| 2-2 | sort 1 | `nereide_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Néréide », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Néréide (enemy of the Marées nation)
- Look: water nymph made of translucent-looking turquoise water, flowing hair of waves
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. RISE: body stretched tall upward, arms raised.
3. LUNGE: body stretched forward, claws of water splashes and bubbles reaching out.
4. HOVER: floating higher, water splashes and bubbles orbs circling.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Néréide: water nymph made of translucent-looking turquoise water, flowing hair of waves.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `nereide_back_walk.png` |
| 1-2 | attaque 1 | `nereide_back_attack.png` |
| 2-1 | attaque 2 | `nereide_back_attack_2.png` |
| 2-2 | sort 1 | `nereide_back_cast.png` |

### Crabe géant — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/marees/` ; nomme tes images `crabe_geant_<clé>.png` (ex. `crabe_geant_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Crabe géant », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Crabe géant (enemy of the Marées nation)
- Look: giant crab with a blue shell striped with red, huge pincers
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
NATION PALETTE: turquoise, white, gold trims, coral pink accents. Signature effects (keep them small): water splashes and bubbles.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Crabe géant: giant crab with a blue shell striped with red, huge pincers.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `crabe_geant.png` |
| 1-2 | repos 1 (dos) | `crabe_geant_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Crabe géant », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Crabe géant (enemy of the Marées nation)
- Look: giant crab with a blue shell striped with red, huge pincers
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. REARING: standing up on the hind legs, front claws raised high.
3. POUNCE: body stretched forward in the air, jaws open.
4. HOWL: head raised to the sky, water splashes and bubbles gathering around the body.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Crabe géant: giant crab with a blue shell striped with red, huge pincers.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `crabe_geant_walk.png` |
| 1-2 | attaque 1 | `crabe_geant_attack.png` |
| 2-1 | attaque 2 | `crabe_geant_attack_2.png` |
| 2-2 | sort 1 | `crabe_geant_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Crabe géant », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Crabe géant (enemy of the Marées nation)
- Look: giant crab with a blue shell striped with red, huge pincers
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. REARING: standing up on the hind legs, front claws raised high.
3. POUNCE: body stretched forward in the air, jaws open.
4. HOWL: head raised to the sky, water splashes and bubbles gathering around the body.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Crabe géant: giant crab with a blue shell striped with red, huge pincers.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `crabe_geant_back_walk.png` |
| 1-2 | attaque 1 | `crabe_geant_back_attack.png` |
| 2-1 | attaque 2 | `crabe_geant_back_attack_2.png` |
| 2-2 | sort 1 | `crabe_geant_back_cast.png` |

## 4. Boss

### Néréa la Tempête — 22 poses

6 planches, 22 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `marees_<clé>.png` (ex. `marees_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Néréa la Tempête », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Néréa la Tempête (boss of the Marées nation)
- Body: sea queen in turquoise coral armor (#2BB8B0) with gold edges, flowing white sea-foam cape
- Head: crown of red coral branches, long deep-blue hair, blue eyes
- Weapon: golden trident, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no fish tail, no sword.
NATION PALETTE: turquoise, white, gold trims, coral pink accents. Signature effects (keep them small): water splashes and bubbles.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Néréa la Tempête: sea queen in turquoise coral armor (#2BB8B0) with gold edges, flowing white sea-foam cape; crown of red coral branches, long deep-blue hair, blue eyes; golden trident, RIGHT hand. Forbidden: no fish tail, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `marees.png` |
| 1-2 | repos 1 (dos) | `marees_back.png` |

#### Planche 2 — Face 1 · garde, marche, sort (`face_1`)

Dans l'Atelier : personnage « Néréa la Tempête », planche « Face 1 · garde, marche, sort ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Néréa la Tempête (boss of the Marées nation)
- Body: sea queen in turquoise coral armor (#2BB8B0) with gold edges, flowing white sea-foam cape
- Head: crown of red coral branches, long deep-blue hair, blue eyes
- Weapon: golden trident, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no fish tail, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. GUARD: knees bent, weapon raised in front of the body, ready to fight.
2. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
3. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
4. FOCUS: eyes closed, staff held vertically in front of the face, water splashes and bubbles orb at the top.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Néréa la Tempête: sea queen in turquoise coral armor (#2BB8B0) with gold edges, flowing white sea-foam cape; crown of red coral branches, long deep-blue hair, blue eyes; golden trident, RIGHT hand. Forbidden: no fish tail, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 2 | `marees_idle_2.png` |
| 1-2 | marche 1 | `marees_walk.png` |
| 2-1 | marche 2 | `marees_walk_2.png` |
| 2-2 | sort 1 | `marees_cast.png` |

#### Planche 3 — Face 2 · attaques 1 à 4 (`face_2`)

Dans l'Atelier : personnage « Néréa la Tempête », planche « Face 2 · attaques 1 à 4 ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Néréa la Tempête (boss of the Marées nation)
- Body: sea queen in turquoise coral armor (#2BB8B0) with gold edges, flowing white sea-foam cape
- Head: crown of red coral branches, long deep-blue hair, blue eyes
- Weapon: golden trident, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no fish tail, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short water splashes and bubbles spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. JUMPING STRIKE: whole body in the air, staff held back over the shoulder.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Néréa la Tempête: sea queen in turquoise coral armor (#2BB8B0) with gold edges, flowing white sea-foam cape; crown of red coral branches, long deep-blue hair, blue eyes; golden trident, RIGHT hand. Forbidden: no fish tail, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `marees_attack.png` |
| 1-2 | attaque 2 | `marees_attack_2.png` |
| 2-1 | attaque 3 | `marees_attack_3.png` |
| 2-2 | attaque 4 | `marees_attack_4.png` |

#### Planche 4 — Face 3 · attaques 5-6, sorts 2-3 (`face_3`)

Dans l'Atelier : personnage « Néréa la Tempête », planche « Face 3 · attaques 5-6, sorts 2-3 ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Néréa la Tempête (boss of the Marées nation)
- Body: sea queen in turquoise coral armor (#2BB8B0) with gold edges, flowing white sea-foam cape
- Head: crown of red coral branches, long deep-blue hair, blue eyes
- Weapon: golden trident, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no fish tail, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. LOW SWEEP: crouched, staff swinging at ankle height.
2. SPIN: staff whirling around the body, a water splashes and bubbles trail circling it.
3. INVOCATION: staff raised high with both hands, water splashes and bubbles swirling above the head.
4. BLAST: staff pointed forward, a compact water splashes and bubbles blast leaving the tip.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Néréa la Tempête: sea queen in turquoise coral armor (#2BB8B0) with gold edges, flowing white sea-foam cape; crown of red coral branches, long deep-blue hair, blue eyes; golden trident, RIGHT hand. Forbidden: no fish tail, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 5 | `marees_attack_5.png` |
| 1-2 | attaque 6 | `marees_attack_6.png` |
| 2-1 | sort 2 | `marees_cast_2.png` |
| 2-2 | sort 3 | `marees_cast_3.png` |

#### Planche 5 — Dos 1 · marche, attaque, sort (`dos_1`)

Dans l'Atelier : personnage « Néréa la Tempête », planche « Dos 1 · marche, attaque, sort ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Néréa la Tempête (boss of the Marées nation)
- Body: sea queen in turquoise coral armor (#2BB8B0) with gold edges, flowing white sea-foam cape
- Head: crown of red coral branches, long deep-blue hair, blue eyes
- Weapon: golden trident, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no fish tail, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
3. OVERHEAD STRIKE: staff raised high above the head with both hands.
4. FOCUS: eyes closed, staff held vertically in front of the face, water splashes and bubbles orb at the top.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Néréa la Tempête: sea queen in turquoise coral armor (#2BB8B0) with gold edges, flowing white sea-foam cape; crown of red coral branches, long deep-blue hair, blue eyes; golden trident, RIGHT hand. Forbidden: no fish tail, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `marees_back_walk.png` |
| 1-2 | marche 2 | `marees_back_walk_2.png` |
| 2-1 | attaque 1 | `marees_back_attack.png` |
| 2-2 | sort 1 | `marees_back_cast.png` |

#### Planche 6 — Dos 2 · attaques 2 à 4, garde (`dos_2`)

Dans l'Atelier : personnage « Néréa la Tempête », planche « Dos 2 · attaques 2 à 4, garde ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Néréa la Tempête (boss of the Marées nation)
- Body: sea queen in turquoise coral armor (#2BB8B0) with gold edges, flowing white sea-foam cape
- Head: crown of red coral branches, long deep-blue hair, blue eyes
- Weapon: golden trident, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no fish tail, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. THRUST: body leaning forward, staff tip pushed far ahead with a short water splashes and bubbles spark.
2. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
3. JUMPING STRIKE: whole body in the air, staff held back over the shoulder.
4. GUARD: knees bent, weapon raised in front of the body, ready to fight.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Néréa la Tempête: sea queen in turquoise coral armor (#2BB8B0) with gold edges, flowing white sea-foam cape; crown of red coral branches, long deep-blue hair, blue eyes; golden trident, RIGHT hand. Forbidden: no fish tail, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 2 | `marees_back_attack_2.png` |
| 1-2 | attaque 3 | `marees_back_attack_3.png` |
| 2-1 | attaque 4 | `marees_back_attack_4.png` |
| 2-2 | repos 2 | `marees_back_idle_2.png` |

## Prompt négatif (toutes les planches de cette page)

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses, identical poses, repeated pose, copy of the same pose, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, front and back views mixed, different character between poses, realistic proportions, small head
```
