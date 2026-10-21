# Nation Cimes (Montagne)

Palette : steel blue, dark iron, snow white fur, ice cyan crystals. Effets : ice shards and snow bursts. Contre-jour : cold icy blue.

Chaque personnage est dessiné en **vue 3/4 avant (face)** et en **vue 3/4 arrière (dos)**. Le jeu retourne l'image pour les directions vers la gauche. Une fiche de référence (repos face + dos), puis des planches de 4 poses (2 × 2) bien séparées. Prompt négatif : voir en bas de page.

Ordre conseillé : 1) planche de référence, 2) héros, 3) ennemis, 4) boss.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos. Joins-la comme image de référence à toutes les planches suivantes.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Cimes nation (Montagne biome).
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals. Signature effects: ice shards and snow bursts.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: two rows with the same 6 characters in the same order, all in idle pose. Top row: 3/4 front view, facing front-right. Bottom row: 3/4 back view, seen from behind, turned toward the upper right. All feet of a row on the same ground line. Leave a wide empty gap (at least half a character width) between characters and between the two rows: nobody overlaps or touches anyone, weapons and capes included. Image aspect ratio 2:1, as large as possible.
CHARACTERS, left to right:
1. the hero (Tank: stout veteran warrior with a big white beard and white hair, heavy dark steel-blue plate armor with white fur trim and ice-blue crystal inlays, a large round shield with a cloud and mountain emblem on the left arm, a rune-engraved war hammer in the right hand).
2. Guerrier des monts (mountain warrior with rocky brown skin, stocky body, crude stone gauntlets).
3. Griffon des cimes (griffin with a white eagle head, blue-grey feathered wings and a lion body).
4. Garde des pics (peak guardian golem of blue-grey stone with glowing ice-blue crystals on the shoulders).
5. Rochebrute (hulking brute made of brown boulders, small glowing eyes, huge fists).
6. the final boss Vorkann le Givre (massive frost knight in dark steel armor covered with ice crystals and snow fur, crowned helm of ice spikes, huge crystal-studded tower shield and a heavy rune hammer), about 1.5x taller than the others.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Tank — 22 poses

6 planches, 22 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `tank_<clé>.png` (ex. `tank_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Tank », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tank (hero of the Cimes nation)
- Hair: white hair combed back and a big full white beard
- Eyes: steel-blue eyes (#4A7FB0), thick white eyebrows, always open
- Skin: tanned skin
- Top: heavy dark steel-blue plate armor (#3A4E6E) with white fur trim on the shoulders and small ice-blue crystal inlays (#9FE3FF)
- Bottom: steel-blue armored tassets over dark grey trousers
- Feet: heavy steel boots
- Weapon: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no cape, no sword, no brown beard.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals. Signature effects (keep them small): ice shards and snow bursts.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tank: white hair combed back and a big full white beard; steel-blue eyes (#4A7FB0), thick white eyebrows, always open; tanned skin; heavy dark steel-blue plate armor (#3A4E6E) with white fur trim on the shoulders and small ice-blue crystal inlays (#9FE3FF). Forbidden: no helmet, no cape, no sword, no brown beard.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `tank.png` |
| 1-2 | repos 1 (dos) | `tank_back.png` |

#### Planche 2 — Face 1 · garde, marche, sort (`face_1`)

Dans l'Atelier : personnage « Tank », planche « Face 1 · garde, marche, sort ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tank (hero of the Cimes nation)
- Hair: white hair combed back and a big full white beard
- Eyes: steel-blue eyes (#4A7FB0), thick white eyebrows, always open
- Skin: tanned skin
- Top: heavy dark steel-blue plate armor (#3A4E6E) with white fur trim on the shoulders and small ice-blue crystal inlays (#9FE3FF)
- Bottom: steel-blue armored tassets over dark grey trousers
- Feet: heavy steel boots
- Weapon: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no cape, no sword, no brown beard.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. GUARD: knees bent, weapon raised in front of the body, ready to fight.
2. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
3. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
4. BRACING: shield planted on the ground in front, head down, ice shards and snow bursts gathering at the feet.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tank: white hair combed back and a big full white beard; steel-blue eyes (#4A7FB0), thick white eyebrows, always open; tanned skin; heavy dark steel-blue plate armor (#3A4E6E) with white fur trim on the shoulders and small ice-blue crystal inlays (#9FE3FF). Forbidden: no helmet, no cape, no sword, no brown beard.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 2 | `tank_idle_2.png` |
| 1-2 | marche 1 | `tank_walk.png` |
| 2-1 | marche 2 | `tank_walk_2.png` |
| 2-2 | sort 1 | `tank_cast.png` |

#### Planche 3 — Face 2 · attaques 1 à 4 (`face_2`)

Dans l'Atelier : personnage « Tank », planche « Face 2 · attaques 1 à 4 ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tank (hero of the Cimes nation)
- Hair: white hair combed back and a big full white beard
- Eyes: steel-blue eyes (#4A7FB0), thick white eyebrows, always open
- Skin: tanned skin
- Top: heavy dark steel-blue plate armor (#3A4E6E) with white fur trim on the shoulders and small ice-blue crystal inlays (#9FE3FF)
- Bottom: steel-blue armored tassets over dark grey trousers
- Feet: heavy steel boots
- Weapon: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no cape, no sword, no brown beard.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. OVERHEAD SMASH: hammer raised high above the head with both arms up, shield on the back arm.
2. SHIELD CHARGE: body leaning far forward, shield thrust in front, hammer pulled back low.
3. SIDE SWING: hammer swept horizontally to the side at full arm length, torso twisted.
4. JUMPING SLAM: whole body in the air, knees tucked, hammer above the head.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tank: white hair combed back and a big full white beard; steel-blue eyes (#4A7FB0), thick white eyebrows, always open; tanned skin; heavy dark steel-blue plate armor (#3A4E6E) with white fur trim on the shoulders and small ice-blue crystal inlays (#9FE3FF). Forbidden: no helmet, no cape, no sword, no brown beard.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `tank_attack.png` |
| 1-2 | attaque 2 | `tank_attack_2.png` |
| 2-1 | attaque 3 | `tank_attack_3.png` |
| 2-2 | attaque 4 | `tank_attack_4.png` |

#### Planche 4 — Face 3 · attaques 5-6, sorts 2-3 (`face_3`)

Dans l'Atelier : personnage « Tank », planche « Face 3 · attaques 5-6, sorts 2-3 ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tank (hero of the Cimes nation)
- Hair: white hair combed back and a big full white beard
- Eyes: steel-blue eyes (#4A7FB0), thick white eyebrows, always open
- Skin: tanned skin
- Top: heavy dark steel-blue plate armor (#3A4E6E) with white fur trim on the shoulders and small ice-blue crystal inlays (#9FE3FF)
- Bottom: steel-blue armored tassets over dark grey trousers
- Feet: heavy steel boots
- Weapon: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no cape, no sword, no brown beard.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. LOW SWEEP: crouched on one knee, hammer swinging just above the ground.
2. GROUND QUAKE: hammer slammed into the ground in front, a ring of ice shards and snow bursts bursting around it.
3. WAR CRY: mouth open, hammer raised straight to the sky, ice shards and snow bursts swirling above.
4. AURA: arms spread wide, a dome of ice shards and snow bursts around the body.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tank: white hair combed back and a big full white beard; steel-blue eyes (#4A7FB0), thick white eyebrows, always open; tanned skin; heavy dark steel-blue plate armor (#3A4E6E) with white fur trim on the shoulders and small ice-blue crystal inlays (#9FE3FF). Forbidden: no helmet, no cape, no sword, no brown beard.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 5 | `tank_attack_5.png` |
| 1-2 | attaque 6 | `tank_attack_6.png` |
| 2-1 | sort 2 | `tank_cast_2.png` |
| 2-2 | sort 3 | `tank_cast_3.png` |

#### Planche 5 — Dos 1 · marche, attaque, sort (`dos_1`)

Dans l'Atelier : personnage « Tank », planche « Dos 1 · marche, attaque, sort ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tank (hero of the Cimes nation)
- Hair: white hair combed back and a big full white beard
- Eyes: steel-blue eyes (#4A7FB0), thick white eyebrows, always open
- Skin: tanned skin
- Top: heavy dark steel-blue plate armor (#3A4E6E) with white fur trim on the shoulders and small ice-blue crystal inlays (#9FE3FF)
- Bottom: steel-blue armored tassets over dark grey trousers
- Feet: heavy steel boots
- Weapon: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no cape, no sword, no brown beard.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
3. OVERHEAD SMASH: hammer raised high above the head with both arms up, shield on the back arm.
4. BRACING: shield planted on the ground in front, head down, ice shards and snow bursts gathering at the feet.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tank: white hair combed back and a big full white beard; steel-blue eyes (#4A7FB0), thick white eyebrows, always open; tanned skin; heavy dark steel-blue plate armor (#3A4E6E) with white fur trim on the shoulders and small ice-blue crystal inlays (#9FE3FF). Forbidden: no helmet, no cape, no sword, no brown beard.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `tank_back_walk.png` |
| 1-2 | marche 2 | `tank_back_walk_2.png` |
| 2-1 | attaque 1 | `tank_back_attack.png` |
| 2-2 | sort 1 | `tank_back_cast.png` |

#### Planche 6 — Dos 2 · attaques 2 à 4, garde (`dos_2`)

Dans l'Atelier : personnage « Tank », planche « Dos 2 · attaques 2 à 4, garde ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tank (hero of the Cimes nation)
- Hair: white hair combed back and a big full white beard
- Eyes: steel-blue eyes (#4A7FB0), thick white eyebrows, always open
- Skin: tanned skin
- Top: heavy dark steel-blue plate armor (#3A4E6E) with white fur trim on the shoulders and small ice-blue crystal inlays (#9FE3FF)
- Bottom: steel-blue armored tassets over dark grey trousers
- Feet: heavy steel boots
- Weapon: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no cape, no sword, no brown beard.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. SHIELD CHARGE: body leaning far forward, shield thrust in front, hammer pulled back low.
2. SIDE SWING: hammer swept horizontally to the side at full arm length, torso twisted.
3. JUMPING SLAM: whole body in the air, knees tucked, hammer above the head.
4. GUARD: knees bent, weapon raised in front of the body, ready to fight.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tank: white hair combed back and a big full white beard; steel-blue eyes (#4A7FB0), thick white eyebrows, always open; tanned skin; heavy dark steel-blue plate armor (#3A4E6E) with white fur trim on the shoulders and small ice-blue crystal inlays (#9FE3FF). Forbidden: no helmet, no cape, no sword, no brown beard.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 2 | `tank_back_attack_2.png` |
| 1-2 | attaque 3 | `tank_back_attack_3.png` |
| 2-1 | attaque 4 | `tank_back_attack_4.png` |
| 2-2 | repos 2 | `tank_back_idle_2.png` |

L'export Zimut de l'Atelier copie aussi le repos vers `nations/heros/tank.png` et les autres poses vers `nations/heros/poses/`.

## 3. Ennemis

### Guerrier des monts — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cimes/` ; nomme tes images `guerrier_des_monts_<clé>.png` (ex. `guerrier_des_monts_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Guerrier des monts », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Guerrier des monts (enemy of the Cimes nation)
- Look: mountain warrior with rocky brown skin, stocky body, crude stone gauntlets
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals. Signature effects (keep them small): ice shards and snow bursts.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Guerrier des monts: mountain warrior with rocky brown skin, stocky body, crude stone gauntlets.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `guerrier_des_monts.png` |
| 1-2 | repos 1 (dos) | `guerrier_des_monts_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Guerrier des monts », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Guerrier des monts (enemy of the Cimes nation)
- Look: mountain warrior with rocky brown skin, stocky body, crude stone gauntlets
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. OVERHEAD SMASH: both fists or weapon raised high above the head.
3. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward.
4. ROOTED: stomping, ice shards and snow bursts cracks spreading under the feet.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Guerrier des monts: mountain warrior with rocky brown skin, stocky body, crude stone gauntlets.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `guerrier_des_monts_walk.png` |
| 1-2 | attaque 1 | `guerrier_des_monts_attack.png` |
| 2-1 | attaque 2 | `guerrier_des_monts_attack_2.png` |
| 2-2 | sort 1 | `guerrier_des_monts_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Guerrier des monts », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Guerrier des monts (enemy of the Cimes nation)
- Look: mountain warrior with rocky brown skin, stocky body, crude stone gauntlets
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. OVERHEAD SMASH: both fists or weapon raised high above the head.
3. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward.
4. ROOTED: stomping, ice shards and snow bursts cracks spreading under the feet.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Guerrier des monts: mountain warrior with rocky brown skin, stocky body, crude stone gauntlets.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `guerrier_des_monts_back_walk.png` |
| 1-2 | attaque 1 | `guerrier_des_monts_back_attack.png` |
| 2-1 | attaque 2 | `guerrier_des_monts_back_attack_2.png` |
| 2-2 | sort 1 | `guerrier_des_monts_back_cast.png` |

### Griffon des cimes — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cimes/` ; nomme tes images `griffon_des_cimes_<clé>.png` (ex. `griffon_des_cimes_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Griffon des cimes », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Griffon des cimes (enemy of the Cimes nation)
- Look: griffin with a white eagle head, blue-grey feathered wings and a lion body
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals. Signature effects (keep them small): ice shards and snow bursts.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Griffon des cimes: griffin with a white eagle head, blue-grey feathered wings and a lion body.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `griffon_des_cimes.png` |
| 1-2 | repos 1 (dos) | `griffon_des_cimes_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Griffon des cimes », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Griffon des cimes (enemy of the Cimes nation)
- Look: griffin with a white eagle head, blue-grey feathered wings and a lion body
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. REARING: standing up on the hind legs, front claws raised high.
3. POUNCE: body stretched forward in the air, jaws open.
4. HOWL: head raised to the sky, ice shards and snow bursts gathering around the body.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Griffon des cimes: griffin with a white eagle head, blue-grey feathered wings and a lion body.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `griffon_des_cimes_walk.png` |
| 1-2 | attaque 1 | `griffon_des_cimes_attack.png` |
| 2-1 | attaque 2 | `griffon_des_cimes_attack_2.png` |
| 2-2 | sort 1 | `griffon_des_cimes_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Griffon des cimes », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Griffon des cimes (enemy of the Cimes nation)
- Look: griffin with a white eagle head, blue-grey feathered wings and a lion body
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. REARING: standing up on the hind legs, front claws raised high.
3. POUNCE: body stretched forward in the air, jaws open.
4. HOWL: head raised to the sky, ice shards and snow bursts gathering around the body.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Griffon des cimes: griffin with a white eagle head, blue-grey feathered wings and a lion body.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `griffon_des_cimes_back_walk.png` |
| 1-2 | attaque 1 | `griffon_des_cimes_back_attack.png` |
| 2-1 | attaque 2 | `griffon_des_cimes_back_attack_2.png` |
| 2-2 | sort 1 | `griffon_des_cimes_back_cast.png` |

### Garde des pics — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cimes/` ; nomme tes images `garde_des_pics_<clé>.png` (ex. `garde_des_pics_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Garde des pics », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Garde des pics (enemy of the Cimes nation)
- Look: peak guardian golem of blue-grey stone with glowing ice-blue crystals on the shoulders
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals. Signature effects (keep them small): ice shards and snow bursts.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Garde des pics: peak guardian golem of blue-grey stone with glowing ice-blue crystals on the shoulders.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `garde_des_pics.png` |
| 1-2 | repos 1 (dos) | `garde_des_pics_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Garde des pics », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Garde des pics (enemy of the Cimes nation)
- Look: peak guardian golem of blue-grey stone with glowing ice-blue crystals on the shoulders
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. OVERHEAD SMASH: both fists or weapon raised high above the head.
3. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward.
4. ROOTED: stomping, ice shards and snow bursts cracks spreading under the feet.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Garde des pics: peak guardian golem of blue-grey stone with glowing ice-blue crystals on the shoulders.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `garde_des_pics_walk.png` |
| 1-2 | attaque 1 | `garde_des_pics_attack.png` |
| 2-1 | attaque 2 | `garde_des_pics_attack_2.png` |
| 2-2 | sort 1 | `garde_des_pics_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Garde des pics », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Garde des pics (enemy of the Cimes nation)
- Look: peak guardian golem of blue-grey stone with glowing ice-blue crystals on the shoulders
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. OVERHEAD SMASH: both fists or weapon raised high above the head.
3. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward.
4. ROOTED: stomping, ice shards and snow bursts cracks spreading under the feet.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Garde des pics: peak guardian golem of blue-grey stone with glowing ice-blue crystals on the shoulders.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `garde_des_pics_back_walk.png` |
| 1-2 | attaque 1 | `garde_des_pics_back_attack.png` |
| 2-1 | attaque 2 | `garde_des_pics_back_attack_2.png` |
| 2-2 | sort 1 | `garde_des_pics_back_cast.png` |

### Rochebrute — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cimes/` ; nomme tes images `rochebrute_<clé>.png` (ex. `rochebrute_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Rochebrute », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Rochebrute (enemy of the Cimes nation)
- Look: hulking brute made of brown boulders, small glowing eyes, huge fists
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals. Signature effects (keep them small): ice shards and snow bursts.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Rochebrute: hulking brute made of brown boulders, small glowing eyes, huge fists.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `rochebrute.png` |
| 1-2 | repos 1 (dos) | `rochebrute_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Rochebrute », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Rochebrute (enemy of the Cimes nation)
- Look: hulking brute made of brown boulders, small glowing eyes, huge fists
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. OVERHEAD SMASH: both fists or weapon raised high above the head.
3. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward.
4. ROOTED: stomping, ice shards and snow bursts cracks spreading under the feet.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Rochebrute: hulking brute made of brown boulders, small glowing eyes, huge fists.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `rochebrute_walk.png` |
| 1-2 | attaque 1 | `rochebrute_attack.png` |
| 2-1 | attaque 2 | `rochebrute_attack_2.png` |
| 2-2 | sort 1 | `rochebrute_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Rochebrute », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Rochebrute (enemy of the Cimes nation)
- Look: hulking brute made of brown boulders, small glowing eyes, huge fists
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. OVERHEAD SMASH: both fists or weapon raised high above the head.
3. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward.
4. ROOTED: stomping, ice shards and snow bursts cracks spreading under the feet.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Rochebrute: hulking brute made of brown boulders, small glowing eyes, huge fists.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `rochebrute_back_walk.png` |
| 1-2 | attaque 1 | `rochebrute_back_attack.png` |
| 2-1 | attaque 2 | `rochebrute_back_attack_2.png` |
| 2-2 | sort 1 | `rochebrute_back_cast.png` |

## 4. Boss

### Vorkann le Givre — 22 poses

6 planches, 22 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `cimes_<clé>.png` (ex. `cimes_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Vorkann le Givre », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Vorkann le Givre (boss of the Cimes nation)
- Body: massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur
- Head: closed crowned helm of ice spikes, glowing ice-blue eye slit
- Weapon: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visible face, no cape.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals. Signature effects (keep them small): ice shards and snow bursts.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Vorkann le Givre: massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur; closed crowned helm of ice spikes, glowing ice-blue eye slit; heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm. Forbidden: no visible face, no cape.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `cimes.png` |
| 1-2 | repos 1 (dos) | `cimes_back.png` |

#### Planche 2 — Face 1 · garde, marche, sort (`face_1`)

Dans l'Atelier : personnage « Vorkann le Givre », planche « Face 1 · garde, marche, sort ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Vorkann le Givre (boss of the Cimes nation)
- Body: massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur
- Head: closed crowned helm of ice spikes, glowing ice-blue eye slit
- Weapon: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visible face, no cape.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. GUARD: knees bent, weapon raised in front of the body, ready to fight.
2. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
3. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
4. BRACING: shield planted on the ground in front, head down, ice shards and snow bursts gathering at the feet.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Vorkann le Givre: massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur; closed crowned helm of ice spikes, glowing ice-blue eye slit; heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm. Forbidden: no visible face, no cape.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 2 | `cimes_idle_2.png` |
| 1-2 | marche 1 | `cimes_walk.png` |
| 2-1 | marche 2 | `cimes_walk_2.png` |
| 2-2 | sort 1 | `cimes_cast.png` |

#### Planche 3 — Face 2 · attaques 1 à 4 (`face_2`)

Dans l'Atelier : personnage « Vorkann le Givre », planche « Face 2 · attaques 1 à 4 ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Vorkann le Givre (boss of the Cimes nation)
- Body: massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur
- Head: closed crowned helm of ice spikes, glowing ice-blue eye slit
- Weapon: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visible face, no cape.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. OVERHEAD SMASH: hammer raised high above the head with both arms up, shield on the back arm.
2. SHIELD CHARGE: body leaning far forward, shield thrust in front, hammer pulled back low.
3. SIDE SWING: hammer swept horizontally to the side at full arm length, torso twisted.
4. JUMPING SLAM: whole body in the air, knees tucked, hammer above the head.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Vorkann le Givre: massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur; closed crowned helm of ice spikes, glowing ice-blue eye slit; heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm. Forbidden: no visible face, no cape.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `cimes_attack.png` |
| 1-2 | attaque 2 | `cimes_attack_2.png` |
| 2-1 | attaque 3 | `cimes_attack_3.png` |
| 2-2 | attaque 4 | `cimes_attack_4.png` |

#### Planche 4 — Face 3 · attaques 5-6, sorts 2-3 (`face_3`)

Dans l'Atelier : personnage « Vorkann le Givre », planche « Face 3 · attaques 5-6, sorts 2-3 ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Vorkann le Givre (boss of the Cimes nation)
- Body: massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur
- Head: closed crowned helm of ice spikes, glowing ice-blue eye slit
- Weapon: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visible face, no cape.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. LOW SWEEP: crouched on one knee, hammer swinging just above the ground.
2. GROUND QUAKE: hammer slammed into the ground in front, a ring of ice shards and snow bursts bursting around it.
3. WAR CRY: mouth open, hammer raised straight to the sky, ice shards and snow bursts swirling above.
4. AURA: arms spread wide, a dome of ice shards and snow bursts around the body.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Vorkann le Givre: massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur; closed crowned helm of ice spikes, glowing ice-blue eye slit; heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm. Forbidden: no visible face, no cape.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 5 | `cimes_attack_5.png` |
| 1-2 | attaque 6 | `cimes_attack_6.png` |
| 2-1 | sort 2 | `cimes_cast_2.png` |
| 2-2 | sort 3 | `cimes_cast_3.png` |

#### Planche 5 — Dos 1 · marche, attaque, sort (`dos_1`)

Dans l'Atelier : personnage « Vorkann le Givre », planche « Dos 1 · marche, attaque, sort ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Vorkann le Givre (boss of the Cimes nation)
- Body: massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur
- Head: closed crowned helm of ice spikes, glowing ice-blue eye slit
- Weapon: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visible face, no cape.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
3. OVERHEAD SMASH: hammer raised high above the head with both arms up, shield on the back arm.
4. BRACING: shield planted on the ground in front, head down, ice shards and snow bursts gathering at the feet.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Vorkann le Givre: massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur; closed crowned helm of ice spikes, glowing ice-blue eye slit; heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm. Forbidden: no visible face, no cape.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `cimes_back_walk.png` |
| 1-2 | marche 2 | `cimes_back_walk_2.png` |
| 2-1 | attaque 1 | `cimes_back_attack.png` |
| 2-2 | sort 1 | `cimes_back_cast.png` |

#### Planche 6 — Dos 2 · attaques 2 à 4, garde (`dos_2`)

Dans l'Atelier : personnage « Vorkann le Givre », planche « Dos 2 · attaques 2 à 4, garde ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Vorkann le Givre (boss of the Cimes nation)
- Body: massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur
- Head: closed crowned helm of ice spikes, glowing ice-blue eye slit
- Weapon: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visible face, no cape.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. SHIELD CHARGE: body leaning far forward, shield thrust in front, hammer pulled back low.
2. SIDE SWING: hammer swept horizontally to the side at full arm length, torso twisted.
3. JUMPING SLAM: whole body in the air, knees tucked, hammer above the head.
4. GUARD: knees bent, weapon raised in front of the body, ready to fight.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Vorkann le Givre: massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur; closed crowned helm of ice spikes, glowing ice-blue eye slit; heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm. Forbidden: no visible face, no cape.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 2 | `cimes_back_attack_2.png` |
| 1-2 | attaque 3 | `cimes_back_attack_3.png` |
| 2-1 | attaque 4 | `cimes_back_attack_4.png` |
| 2-2 | repos 2 | `cimes_back_idle_2.png` |

## Prompt négatif (toutes les planches de cette page)

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses, identical poses, repeated pose, copy of the same pose, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, front and back views mixed, different character between poses, realistic proportions, small head
```
