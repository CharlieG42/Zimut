# Familiers (invocations)

Fichiers dans `prototype/zimut/assets/sprites/summons/`. Format 2 planches par familier : **vues** (4 angles en quarts de tour) puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos), générées en édition de la planche vues comme pour les personnages. Joins la planche du héros qui l'invoque comme référence de style.

### Golem de pierre (Invocateur, ex-Tortue) — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/summons/` ; nomme tes images `golem_de_pierre_vues.png` et `golem_de_pierre_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Golem de pierre (a summon)
- Body: grey stone golem (#7A7A82) with a broad body and big stone fists
- Head: small head with two glowing blue eyes
- Details: blue crystals (#5CC8FF) growing from the shoulders and back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no moss, no brown stone.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Golem de pierre: grey stone golem (#7A7A82) with a broad body and big stone fists; small head with two glowing blue eyes; blue crystals (#5CC8FF) growing from the shoulders and back. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no weapon, no moss, no brown stone.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `golem_de_pierre.png` |
| 1-2 | 3/4 dos droite | `golem_de_pierre_back.png` |
| 2-1 | 3/4 dos gauche | `golem_de_pierre_back_left.png` |
| 2-2 | 3/4 avant gauche | `golem_de_pierre_face_left.png` |

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE summoned familiar, Golem de pierre, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Golem de pierre (a summon)
- Body: grey stone golem (#7A7A82) with a broad body and big stone fists
- Head: small head with two glowing blue eyes
- Details: blue crystals (#5CC8FF) growing from the shoulders and back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no moss, no brown stone.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. BACKHAND: arm swept horizontally to the side, torso twisted.
3. ROOTED: stomping, matching magical sparks cracks spreading under the feet.
4. Seen from BEHIND, the SAME action as pose 1 — OVERHEAD SMASH: both fists or weapon raised high above the head.
5. Seen from BEHIND, the SAME action as pose 2 — BACKHAND: arm swept horizontally to the side, torso twisted.
6. Seen from BEHIND, the SAME action as pose 3 — ROOTED: stomping, matching magical sparks cracks spreading under the feet.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Golem de pierre: grey stone golem (#7A7A82) with a broad body and big stone fists; small head with two glowing blue eyes; blue crystals (#5CC8FF) growing from the shoulders and back. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no weapon, no moss, no brown stone.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `golem_de_pierre_attack.png` |
| 1-2 | attaque 2 — face | `golem_de_pierre_attack_2.png` |
| 1-3 | sort — face | `golem_de_pierre_cast.png` |
| 2-1 | attaque 1 — dos | `golem_de_pierre_attack_back.png` |
| 2-2 | attaque 2 — dos | `golem_de_pierre_attack_2_back.png` |
| 2-3 | sort — dos | `golem_de_pierre_cast_back.png` |

### Loup spectral (Invocateur) — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/summons/` ; nomme tes images `loup_spectral_vues.png` et `loup_spectral_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Loup spectral (a summon)
- Body: spectral violet wolf (#7A4FD8) on four legs with flame-like spiky fur
- Head: glowing white eyes, pointed ears
- Details: fur tips turning into opaque violet flame shapes with dark outlines
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no armor, no transparency, never on two legs.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Loup spectral: spectral violet wolf (#7A4FD8) on four legs with flame-like spiky fur; glowing white eyes, pointed ears; fur tips turning into opaque violet flame shapes with dark outlines. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no armor, no transparency, never on two legs.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `loup_spectral.png` |
| 1-2 | 3/4 dos droite | `loup_spectral_back.png` |
| 2-1 | 3/4 dos gauche | `loup_spectral_back_left.png` |
| 2-2 | 3/4 avant gauche | `loup_spectral_face_left.png` |

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE summoned familiar, Loup spectral, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Loup spectral (a summon)
- Body: spectral violet wolf (#7A4FD8) on four legs with flame-like spiky fur
- Head: glowing white eyes, pointed ears
- Details: fur tips turning into opaque violet flame shapes with dark outlines
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no armor, no transparency, never on two legs.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. SIDE SWIPE: head and claws swept to the side, body twisted.
3. HOWL: head raised to the sky, matching magical sparks gathering around the body.
4. Seen from BEHIND, the SAME action as pose 1 — REARING: standing up on the hind legs, front claws raised high.
5. Seen from BEHIND, the SAME action as pose 2 — SIDE SWIPE: head and claws swept to the side, body twisted.
6. Seen from BEHIND, the SAME action as pose 3 — HOWL: head raised to the sky, matching magical sparks gathering around the body.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Loup spectral: spectral violet wolf (#7A4FD8) on four legs with flame-like spiky fur; glowing white eyes, pointed ears; fur tips turning into opaque violet flame shapes with dark outlines. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no armor, no transparency, never on two legs.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `loup_spectral_attack.png` |
| 1-2 | attaque 2 — face | `loup_spectral_attack_2.png` |
| 1-3 | sort — face | `loup_spectral_cast.png` |
| 2-1 | attaque 1 — dos | `loup_spectral_attack_back.png` |
| 2-2 | attaque 2 — dos | `loup_spectral_attack_2_back.png` |
| 2-3 | sort — dos | `loup_spectral_cast_back.png` |

### Requin des marées (Invocateur, ex-Sirène) — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/summons/` ; nomme tes images `requin_des_marees_vues.png` et `requin_des_marees_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Requin des marées (a summon)
- Body: bright blue shark (#2E8CE0) with a white belly floating upright
- Head: friendly grin, small black eyes
- Details: pectoral fins like small arms
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no weapon.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Requin des marées: bright blue shark (#2E8CE0) with a white belly floating upright; friendly grin, small black eyes; pectoral fins like small arms. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no legs, no weapon.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `requin_des_marees.png` |
| 1-2 | 3/4 dos droite | `requin_des_marees_back.png` |
| 2-1 | 3/4 dos gauche | `requin_des_marees_back_left.png` |
| 2-2 | 3/4 avant gauche | `requin_des_marees_face_left.png` |

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE summoned familiar, Requin des marées, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Requin des marées (a summon)
- Body: bright blue shark (#2E8CE0) with a white belly floating upright
- Head: friendly grin, small black eyes
- Details: pectoral fins like small arms
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no weapon.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. SIDE SWIPE: head and claws swept to the side, body twisted.
3. HOWL: head raised to the sky, matching magical sparks gathering around the body.
4. Seen from BEHIND, the SAME action as pose 1 — REARING: standing up on the hind legs, front claws raised high.
5. Seen from BEHIND, the SAME action as pose 2 — SIDE SWIPE: head and claws swept to the side, body twisted.
6. Seen from BEHIND, the SAME action as pose 3 — HOWL: head raised to the sky, matching magical sparks gathering around the body.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Requin des marées: bright blue shark (#2E8CE0) with a white belly floating upright; friendly grin, small black eyes; pectoral fins like small arms. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no legs, no weapon.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `requin_des_marees_attack.png` |
| 1-2 | attaque 2 — face | `requin_des_marees_attack_2.png` |
| 1-3 | sort — face | `requin_des_marees_cast.png` |
| 2-1 | attaque 1 — dos | `requin_des_marees_attack_back.png` |
| 2-2 | attaque 2 — dos | `requin_des_marees_attack_2_back.png` |
| 2-3 | sort — dos | `requin_des_marees_cast_back.png` |

### Élémentaire de cristal (Invocateur, ex-Ange) — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/summons/` ; nomme tes images `elementaire_de_cristal_vues.png` et `elementaire_de_cristal_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Élémentaire de cristal (a summon)
- Body: small floating elemental made of violet (#8A4FD8) and blue (#4F7FE0) crystals, round and cute
- Head: friendly glowing ice-blue eyes (#9FE3FF)
- Details: tiny crystal arms, no legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no sharp menacing look.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Élémentaire de cristal: small floating elemental made of violet (#8A4FD8) and blue (#4F7FE0) crystals, round and cute; friendly glowing ice-blue eyes (#9FE3FF); tiny crystal arms, no legs. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no weapon, no sharp menacing look.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `elementaire_de_cristal.png` |
| 1-2 | 3/4 dos droite | `elementaire_de_cristal_back.png` |
| 2-1 | 3/4 dos gauche | `elementaire_de_cristal_back_left.png` |
| 2-2 | 3/4 avant gauche | `elementaire_de_cristal_face_left.png` |

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE summoned familiar, Élémentaire de cristal, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Élémentaire de cristal (a summon)
- Body: small floating elemental made of violet (#8A4FD8) and blue (#4F7FE0) crystals, round and cute
- Head: friendly glowing ice-blue eyes (#9FE3FF)
- Details: tiny crystal arms, no legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no sharp menacing look.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. SPIN: body whirling, matching magical sparks trail around it.
3. HOVER: floating higher, matching magical sparks orbs circling.
4. Seen from BEHIND, the SAME action as pose 1 — RISE: body stretched tall upward, arms raised.
5. Seen from BEHIND, the SAME action as pose 2 — SPIN: body whirling, matching magical sparks trail around it.
6. Seen from BEHIND, the SAME action as pose 3 — HOVER: floating higher, matching magical sparks orbs circling.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Élémentaire de cristal: small floating elemental made of violet (#8A4FD8) and blue (#4F7FE0) crystals, round and cute; friendly glowing ice-blue eyes (#9FE3FF); tiny crystal arms, no legs. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no weapon, no sharp menacing look.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `elementaire_de_cristal_attack.png` |
| 1-2 | attaque 2 — face | `elementaire_de_cristal_attack_2.png` |
| 1-3 | sort — face | `elementaire_de_cristal_cast.png` |
| 2-1 | attaque 1 — dos | `elementaire_de_cristal_attack_back.png` |
| 2-2 | attaque 2 — dos | `elementaire_de_cristal_attack_2_back.png` |
| 2-3 | sort — dos | `elementaire_de_cristal_cast_back.png` |

### Ombre (Invocateur, ex-Homme-Faucon) — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/summons/` ; nomme tes images `ombre_vues.png` et `ombre_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombre (a summon)
- Body: coiled purple shadow serpent (#4A2A7A) with darker stripes
- Head: dragon-like head with small horns and glowing violet eyes (#B070FF)
- Details: stylized opaque smoke curls with dark outlines along the body
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no wings, no transparency.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Ombre: coiled purple shadow serpent (#4A2A7A) with darker stripes; dragon-like head with small horns and glowing violet eyes (#B070FF); stylized opaque smoke curls with dark outlines along the body. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no legs, no wings, no transparency.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `ombre.png` |
| 1-2 | 3/4 dos droite | `ombre_back.png` |
| 2-1 | 3/4 dos gauche | `ombre_back_left.png` |
| 2-2 | 3/4 avant gauche | `ombre_face_left.png` |

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE summoned familiar, Ombre, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombre (a summon)
- Body: coiled purple shadow serpent (#4A2A7A) with darker stripes
- Head: dragon-like head with small horns and glowing violet eyes (#B070FF)
- Details: stylized opaque smoke curls with dark outlines along the body
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no wings, no transparency.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. SPIN: body whirling, matching magical sparks trail around it.
3. HOVER: floating higher, matching magical sparks orbs circling.
4. Seen from BEHIND, the SAME action as pose 1 — RISE: body stretched tall upward, arms raised.
5. Seen from BEHIND, the SAME action as pose 2 — SPIN: body whirling, matching magical sparks trail around it.
6. Seen from BEHIND, the SAME action as pose 3 — HOVER: floating higher, matching magical sparks orbs circling.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Ombre: coiled purple shadow serpent (#4A2A7A) with darker stripes; dragon-like head with small horns and glowing violet eyes (#B070FF); stylized opaque smoke curls with dark outlines along the body. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no legs, no wings, no transparency.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `ombre_attack.png` |
| 1-2 | attaque 2 — face | `ombre_attack_2.png` |
| 1-3 | sort — face | `ombre_cast.png` |
| 2-1 | attaque 1 — dos | `ombre_attack_back.png` |
| 2-2 | attaque 2 — dos | `ombre_attack_2_back.png` |
| 2-3 | sort — dos | `ombre_cast_back.png` |

### Esprit de la forêt (Invocateur, ex-Centaure) — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/summons/` ; nomme tes images `esprit_de_la_foret_vues.png` et `esprit_de_la_foret_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Esprit de la forêt (a summon)
- Body: forest stag spirit on four legs, body of green leaves (#5FAE48) and moss
- Head: large branching wooden antlers with small leaves, glowing green eyes
- Details: small white flowers on the back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no rider, no armor, never on two legs.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Esprit de la forêt: forest stag spirit on four legs, body of green leaves (#5FAE48) and moss; large branching wooden antlers with small leaves, glowing green eyes; small white flowers on the back. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no rider, no armor, never on two legs.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `esprit_de_la_foret.png` |
| 1-2 | 3/4 dos droite | `esprit_de_la_foret_back.png` |
| 2-1 | 3/4 dos gauche | `esprit_de_la_foret_back_left.png` |
| 2-2 | 3/4 avant gauche | `esprit_de_la_foret_face_left.png` |

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE summoned familiar, Esprit de la forêt, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Esprit de la forêt (a summon)
- Body: forest stag spirit on four legs, body of green leaves (#5FAE48) and moss
- Head: large branching wooden antlers with small leaves, glowing green eyes
- Details: small white flowers on the back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no rider, no armor, never on two legs.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. SIDE SWIPE: head and claws swept to the side, body twisted.
3. HOWL: head raised to the sky, matching magical sparks gathering around the body.
4. Seen from BEHIND, the SAME action as pose 1 — REARING: standing up on the hind legs, front claws raised high.
5. Seen from BEHIND, the SAME action as pose 2 — SIDE SWIPE: head and claws swept to the side, body twisted.
6. Seen from BEHIND, the SAME action as pose 3 — HOWL: head raised to the sky, matching magical sparks gathering around the body.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Esprit de la forêt: forest stag spirit on four legs, body of green leaves (#5FAE48) and moss; large branching wooden antlers with small leaves, glowing green eyes; small white flowers on the back. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no rider, no armor, never on two legs.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `esprit_de_la_foret_attack.png` |
| 1-2 | attaque 2 — face | `esprit_de_la_foret_attack_2.png` |
| 1-3 | sort — face | `esprit_de_la_foret_cast.png` |
| 2-1 | attaque 1 — dos | `esprit_de_la_foret_attack_back.png` |
| 2-2 | attaque 2 — dos | `esprit_de_la_foret_attack_2_back.png` |
| 2-3 | sort — dos | `esprit_de_la_foret_cast_back.png` |

### Archer sylvestre (Sylvain) — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/summons/` ; nomme tes images `archer_sylvestre_vues.png` et `archer_sylvestre_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Archer sylvestre (a summon)
- Body: slim wooden archer made of light-brown branches (#8A6238) and green leaves
- Head: leafy crown, two glowing green eyes, no mouth
- Weapon: wooden bow in the LEFT hand, leaf quiver on the back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human skin, no metal.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Archer sylvestre: wooden bow in the LEFT hand, leaf quiver on the back; slim wooden archer made of light-brown branches (#8A6238) and green leaves; leafy crown, two glowing green eyes, no mouth. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no human skin, no metal.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `archer_sylvestre.png` |
| 1-2 | 3/4 dos droite | `archer_sylvestre_back.png` |
| 2-1 | 3/4 dos gauche | `archer_sylvestre_back_left.png` |
| 2-2 | 3/4 avant gauche | `archer_sylvestre_face_left.png` |

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE summoned familiar, Archer sylvestre, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Archer sylvestre (a summon)
- Body: slim wooden archer made of light-brown branches (#8A6238) and green leaves
- Head: leafy crown, two glowing green eyes, no mouth
- Weapon: wooden bow in the LEFT hand, leaf quiver on the back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human skin, no metal.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. SKY SHOT: bow pointed almost straight up, string fully drawn.
2. RELEASE: string hand open behind, bow arm extended, arrow leaving with a matching magical sparks trail.
3. ENCHANTED ARROW: arrow held up to the face, its tip wrapped in matching magical sparks.
4. Seen from BEHIND, the SAME action as pose 1 — SKY SHOT: bow pointed almost straight up, string fully drawn.
5. Seen from BEHIND, the SAME action as pose 2 — RELEASE: string hand open behind, bow arm extended, arrow leaving with a matching magical sparks trail.
6. Seen from BEHIND, the SAME action as pose 3 — ENCHANTED ARROW: arrow held up to the face, its tip wrapped in matching magical sparks.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Archer sylvestre: wooden bow in the LEFT hand, leaf quiver on the back; slim wooden archer made of light-brown branches (#8A6238) and green leaves; leafy crown, two glowing green eyes, no mouth. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no human skin, no metal.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `archer_sylvestre_attack.png` |
| 1-2 | attaque 2 — face | `archer_sylvestre_attack_2.png` |
| 1-3 | sort — face | `archer_sylvestre_cast.png` |
| 2-1 | attaque 1 — dos | `archer_sylvestre_attack_back.png` |
| 2-2 | attaque 2 — dos | `archer_sylvestre_attack_2_back.png` |
| 2-3 | sort — dos | `archer_sylvestre_cast_back.png` |

### Ent de combat (Sylvain) — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/summons/` ; nomme tes images `ent_de_combat_vues.png` et `ent_de_combat_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ent de combat (a summon)
- Body: small wooden ent warrior of brown bark (#6B4A2B) covered in green leaves
- Head: face carved in the bark with glowing green eyes, leafy top
- Details: stubby branch arms, root feet
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no metal.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Ent de combat: small wooden ent warrior of brown bark (#6B4A2B) covered in green leaves; face carved in the bark with glowing green eyes, leafy top; stubby branch arms, root feet. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no weapon, no metal.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `ent_de_combat.png` |
| 1-2 | 3/4 dos droite | `ent_de_combat_back.png` |
| 2-1 | 3/4 dos gauche | `ent_de_combat_back_left.png` |
| 2-2 | 3/4 avant gauche | `ent_de_combat_face_left.png` |

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE summoned familiar, Ent de combat, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ent de combat (a summon)
- Body: small wooden ent warrior of brown bark (#6B4A2B) covered in green leaves
- Head: face carved in the bark with glowing green eyes, leafy top
- Details: stubby branch arms, root feet
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no metal.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. BACKHAND: arm swept horizontally to the side, torso twisted.
3. ROOTED: stomping, matching magical sparks cracks spreading under the feet.
4. Seen from BEHIND, the SAME action as pose 1 — OVERHEAD SMASH: both fists or weapon raised high above the head.
5. Seen from BEHIND, the SAME action as pose 2 — BACKHAND: arm swept horizontally to the side, torso twisted.
6. Seen from BEHIND, the SAME action as pose 3 — ROOTED: stomping, matching magical sparks cracks spreading under the feet.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Ent de combat: small wooden ent warrior of brown bark (#6B4A2B) covered in green leaves; face carved in the bark with glowing green eyes, leafy top; stubby branch arms, root feet. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no weapon, no metal.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `ent_de_combat_attack.png` |
| 1-2 | attaque 2 — face | `ent_de_combat_attack_2.png` |
| 1-3 | sort — face | `ent_de_combat_cast.png` |
| 2-1 | attaque 1 — dos | `ent_de_combat_attack_back.png` |
| 2-2 | attaque 2 — dos | `ent_de_combat_attack_2_back.png` |
| 2-3 | sort — dos | `ent_de_combat_cast_back.png` |

### Tronc (Sylvain) — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/summons/` ; nomme tes images `tronc_vues.png` et `tronc_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tronc (a summon)
- Body: cute walking tree stump of brown bark (#7A5534)
- Head: round leafy green crown on top (#5FAE48), big round friendly eyes on the trunk
- Details: two small branch arms, little root feet
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no angry face.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tronc: cute walking tree stump of brown bark (#7A5534); round leafy green crown on top (#5FAE48), big round friendly eyes on the trunk; two small branch arms, little root feet. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no weapon, no angry face.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `tronc.png` |
| 1-2 | 3/4 dos droite | `tronc_back.png` |
| 2-1 | 3/4 dos gauche | `tronc_back_left.png` |
| 2-2 | 3/4 avant gauche | `tronc_face_left.png` |

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE summoned familiar, Tronc, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tronc (a summon)
- Body: cute walking tree stump of brown bark (#7A5534)
- Head: round leafy green crown on top (#5FAE48), big round friendly eyes on the trunk
- Details: two small branch arms, little root feet
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no angry face.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. BACKHAND: arm swept horizontally to the side, torso twisted.
3. ROOTED: stomping, matching magical sparks cracks spreading under the feet.
4. Seen from BEHIND, the SAME action as pose 1 — OVERHEAD SMASH: both fists or weapon raised high above the head.
5. Seen from BEHIND, the SAME action as pose 2 — BACKHAND: arm swept horizontally to the side, torso twisted.
6. Seen from BEHIND, the SAME action as pose 3 — ROOTED: stomping, matching magical sparks cracks spreading under the feet.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tronc: cute walking tree stump of brown bark (#7A5534); round leafy green crown on top (#5FAE48), big round friendly eyes on the trunk; two small branch arms, little root feet. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no weapon, no angry face.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `tronc_attack.png` |
| 1-2 | attaque 2 — face | `tronc_attack_2.png` |
| 1-3 | sort — face | `tronc_cast.png` |
| 2-1 | attaque 1 — dos | `tronc_attack_back.png` |
| 2-2 | attaque 2 — dos | `tronc_attack_2_back.png` |
| 2-3 | sort — dos | `tronc_cast_back.png` |

### Sarriette (Sylvain) — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/summons/` ; nomme tes images `sarriette_vues.png` et `sarriette_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sarriette (a summon)
- Body: tiny leaf sprite girl with light green skin (#BFE8A8)
- Head: green leaf hood (#5FAE48) with two little horns, big dark eyes
- Details: a curly vine in the hand, leaf dress
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no weapon.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Sarriette: tiny leaf sprite girl with light green skin (#BFE8A8); green leaf hood (#5FAE48) with two little horns, big dark eyes; a curly vine in the hand, leaf dress. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no wings, no weapon.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `sarriette.png` |
| 1-2 | 3/4 dos droite | `sarriette_back.png` |
| 2-1 | 3/4 dos gauche | `sarriette_back_left.png` |
| 2-2 | 3/4 avant gauche | `sarriette_face_left.png` |

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE summoned familiar, Sarriette, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sarriette (a summon)
- Body: tiny leaf sprite girl with light green skin (#BFE8A8)
- Head: green leaf hood (#5FAE48) with two little horns, big dark eyes
- Details: a curly vine in the hand, leaf dress
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no weapon.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
3. FOCUS: eyes closed, staff held vertically in front of the face, matching magical sparks orb at the top.
4. Seen from BEHIND, the SAME action as pose 1 — OVERHEAD STRIKE: staff raised high above the head with both hands.
5. Seen from BEHIND, the SAME action as pose 2 — SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
6. Seen from BEHIND, the SAME action as pose 3 — FOCUS: eyes closed, staff held vertically in front of the face, matching magical sparks orb at the top.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Sarriette: tiny leaf sprite girl with light green skin (#BFE8A8); green leaf hood (#5FAE48) with two little horns, big dark eyes; a curly vine in the hand, leaf dress. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no wings, no weapon.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `sarriette_attack.png` |
| 1-2 | attaque 2 — face | `sarriette_attack_2.png` |
| 1-3 | sort — face | `sarriette_cast.png` |
| 2-1 | attaque 1 — dos | `sarriette_attack_back.png` |
| 2-2 | attaque 2 — dos | `sarriette_attack_2_back.png` |
| 2-3 | sort — dos | `sarriette_cast_back.png` |

### Ronce agressive (Sylvain) — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/summons/` ; nomme tes images `ronce_agressive_vues.png` et `ronce_agressive_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ronce agressive (a summon)
- Body: angry dark-green bramble bulb (#3E6A2E) covered in sharp thorns
- Head: two angry red eyes (#E02A2A), jagged mouth
- Details: whipping thorny vines around it, rooted in the ground
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no flowers.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Ronce agressive: angry dark-green bramble bulb (#3E6A2E) covered in sharp thorns; two angry red eyes (#E02A2A), jagged mouth; whipping thorny vines around it, rooted in the ground. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no legs, no flowers.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `ronce_agressive.png` |
| 1-2 | 3/4 dos droite | `ronce_agressive_back.png` |
| 2-1 | 3/4 dos gauche | `ronce_agressive_back_left.png` |
| 2-2 | 3/4 avant gauche | `ronce_agressive_face_left.png` |

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE summoned familiar, Ronce agressive, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ronce agressive (a summon)
- Body: angry dark-green bramble bulb (#3E6A2E) covered in sharp thorns
- Head: two angry red eyes (#E02A2A), jagged mouth
- Details: whipping thorny vines around it, rooted in the ground
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no flowers.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. SPIN: body whirling, matching magical sparks trail around it.
3. HOVER: floating higher, matching magical sparks orbs circling.
4. Seen from BEHIND, the SAME action as pose 1 — RISE: body stretched tall upward, arms raised.
5. Seen from BEHIND, the SAME action as pose 2 — SPIN: body whirling, matching magical sparks trail around it.
6. Seen from BEHIND, the SAME action as pose 3 — HOVER: floating higher, matching magical sparks orbs circling.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Ronce agressive: angry dark-green bramble bulb (#3E6A2E) covered in sharp thorns; two angry red eyes (#E02A2A), jagged mouth; whipping thorny vines around it, rooted in the ground. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no legs, no flowers.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `ronce_agressive_attack.png` |
| 1-2 | attaque 2 — face | `ronce_agressive_attack_2.png` |
| 1-3 | sort — face | `ronce_agressive_cast.png` |
| 2-1 | attaque 1 — dos | `ronce_agressive_attack_back.png` |
| 2-2 | attaque 2 — dos | `ronce_agressive_attack_2_back.png` |
| 2-3 | sort — dos | `ronce_agressive_cast_back.png` |

### Sentinelle de grès (pas encore utilisée) — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/summons/` ; nomme tes images `sentinelle_de_gres_vues.png` et `sentinelle_de_gres_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sentinelle de grès (a summon)
- Body: sandstone sentinel statue (#D9B07A) with carved armor
- Head: carved helmet-head with glowing amber eyes (#F2A93B)
- Weapon: carved stone spear, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no cloth, no skin.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Sentinelle de grès: carved stone spear, RIGHT hand; sandstone sentinel statue (#D9B07A) with carved armor; carved helmet-head with glowing amber eyes (#F2A93B). The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no cloth, no skin.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `sentinelle_de_gres.png` |
| 1-2 | 3/4 dos droite | `sentinelle_de_gres_back.png` |
| 2-1 | 3/4 dos gauche | `sentinelle_de_gres_back_left.png` |
| 2-2 | 3/4 avant gauche | `sentinelle_de_gres_face_left.png` |

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE summoned familiar, Sentinelle de grès, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sentinelle de grès (a summon)
- Body: sandstone sentinel statue (#D9B07A) with carved armor
- Head: carved helmet-head with glowing amber eyes (#F2A93B)
- Weapon: carved stone spear, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no cloth, no skin.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. BACKHAND: arm swept horizontally to the side, torso twisted.
3. ROOTED: stomping, matching magical sparks cracks spreading under the feet.
4. Seen from BEHIND, the SAME action as pose 1 — OVERHEAD SMASH: both fists or weapon raised high above the head.
5. Seen from BEHIND, the SAME action as pose 2 — BACKHAND: arm swept horizontally to the side, torso twisted.
6. Seen from BEHIND, the SAME action as pose 3 — ROOTED: stomping, matching magical sparks cracks spreading under the feet.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Sentinelle de grès: carved stone spear, RIGHT hand; sandstone sentinel statue (#D9B07A) with carved armor; carved helmet-head with glowing amber eyes (#F2A93B). The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no cloth, no skin.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `sentinelle_de_gres_attack.png` |
| 1-2 | attaque 2 — face | `sentinelle_de_gres_attack_2.png` |
| 1-3 | sort — face | `sentinelle_de_gres_cast.png` |
| 2-1 | attaque 1 — dos | `sentinelle_de_gres_attack_back.png` |
| 2-2 | attaque 2 — dos | `sentinelle_de_gres_attack_2_back.png` |
| 2-3 | sort — dos | `sentinelle_de_gres_cast_back.png` |

## Prompt négatif

Planches vues : voir le négatif adapté dans chaque fichier nation. Planches actions :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, weapon changing shape, weapon changing color, weapon replaced by another weapon, missing weapon, missing accessories, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, different character between poses, realistic proportions, small head
```
