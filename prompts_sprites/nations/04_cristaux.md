# Nation Cristaux (Cristaux)

Palette : silver white, sapphire blue, amethyst violet. Effets : prismatic blue and violet crystal shards. Contre-jour : violet.

Format 2 planches par personnage :

1. **Vues** — le personnage au repos vu sous 6 angles (face, 3/4 avant droite, 3/4 dos droite, dos, 3/4 dos gauche, 3/4 avant gauche), grille 3 × 2 sur image 2:1, poses largement espacées. Un seul angle par case : aucun doublon possible.
2. **Actions** — 3 attaques + 3 sorts en vue 3/4 avant, générées **en édition** de la planche vues (image source = planche vues) : le personnage réellement dessiné sert d'ancre, il ne peut pas changer d'une planche à l'autre. Repli : génération normale (la carte d'identité est recopiée dans chaque prompt).

Chaque prompt recopie la carte d'identité du personnage (`identites.py`) : aucune image à joindre. Ordre conseillé : 1) planche de style, 2) héros, 3) ennemis, 4) boss ; pour chaque personnage : vues puis actions. Prompt négatif : en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Cristaux nation (Cristaux biome).
NATION PALETTE: silver white, sapphire blue, amethyst violet. Signature effects: prismatic blue and violet crystal shards.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
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

### Mage — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `mage_vues.png` et `mage_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Mage (hero of the Cristaux nation)
- Hair: dark navy-blue hair (#1E2C5A), medium length, side bangs
- Eyes: bright blue eyes (#3FA0FF), always open
- Skin: fair skin
- Top: long silver-white robe (#E8ECF4) with light-blue crystal patterns and sapphire trims (#2A5BD7)
- Bottom: the robe reaches the ankles, dark blue trousers visible below
- Feet: dark blue boots with silver tips
- Weapon: ornate silver staff topped with a glowing blue crystal (#5CC8FF), RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wizard hat, no white or silver hair, no beard.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Mage: dark navy-blue hair (#1E2C5A), medium length, side bangs; bright blue eyes (#3FA0FF), always open; fair skin; long silver-white robe (#E8ECF4) with light-blue crystal patterns and sapphire trims (#2A5BD7). Forbidden: no wizard hat, no white or silver hair, no beard.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `mage.png` |
| 1-2 | 3/4 avant droite | `mage_face_right.png` |
| 1-3 | 3/4 dos droite | `mage_back_right.png` |
| 2-1 | dos complet | `mage_back.png` |
| 2-2 | 3/4 dos gauche | `mage_back_left.png` |
| 2-3 | 3/4 avant gauche | `mage_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE playable hero, Mage, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Mage (hero of the Cristaux nation)
- Hair: dark navy-blue hair (#1E2C5A), medium length, side bangs
- Eyes: bright blue eyes (#3FA0FF), always open
- Skin: fair skin
- Top: long silver-white robe (#E8ECF4) with light-blue crystal patterns and sapphire trims (#2A5BD7)
- Bottom: the robe reaches the ankles, dark blue trousers visible below
- Feet: dark blue boots with silver tips
- Weapon: ornate silver staff topped with a glowing blue crystal (#5CC8FF), RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wizard hat, no white or silver hair, no beard.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short prismatic blue and violet crystal shards spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. FOCUS: eyes closed, staff held vertically in front of the face, prismatic blue and violet crystal shards orb at the top.
5. INVOCATION: staff raised high with both hands, prismatic blue and violet crystal shards swirling above the head.
6. BLAST: staff pointed forward, a compact prismatic blue and violet crystal shards blast leaving the tip.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Mage: dark navy-blue hair (#1E2C5A), medium length, side bangs; bright blue eyes (#3FA0FF), always open; fair skin; long silver-white robe (#E8ECF4) with light-blue crystal patterns and sapphire trims (#2A5BD7). Forbidden: no wizard hat, no white or silver hair, no beard.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `mage_attack.png` |
| 1-2 | attaque 2 | `mage_attack_2.png` |
| 1-3 | attaque 3 | `mage_attack_3.png` |
| 2-1 | sort 1 | `mage_cast.png` |
| 2-2 | sort 2 | `mage_cast_2.png` |
| 2-3 | sort 3 | `mage_cast_3.png` |

L'export Zimut de l'Atelier copie aussi le repos (case 1 de la planche vues) vers `nations/heros/mage.png`.

## 3. Ennemis

### Araignée de cristal — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cristaux/` ; nomme tes images `araignee_de_cristal_vues.png` et `araignee_de_cristal_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Araignée de cristal (enemy of the Cristaux nation)
- Body: spider with a round body made of violet amethyst crystals (#8A4FD8)
- Head: cluster of small glowing ice-blue eyes (#9FE3FF), crystal fangs
- Details: eight thin glowing ice-blue crystal legs (#9FE3FF)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no fur, no green, no human body.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Araignée de cristal: spider with a round body made of violet amethyst crystals (#8A4FD8); cluster of small glowing ice-blue eyes (#9FE3FF), crystal fangs; eight thin glowing ice-blue crystal legs (#9FE3FF). Forbidden: no fur, no green, no human body.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `araignee_de_cristal.png` |
| 1-2 | 3/4 avant droite | `araignee_de_cristal_face_right.png` |
| 1-3 | 3/4 dos droite | `araignee_de_cristal_back_right.png` |
| 2-1 | dos complet | `araignee_de_cristal_back.png` |
| 2-2 | 3/4 dos gauche | `araignee_de_cristal_back_left.png` |
| 2-3 | 3/4 avant gauche | `araignee_de_cristal_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Araignée de cristal, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Araignée de cristal (enemy of the Cristaux nation)
- Body: spider with a round body made of violet amethyst crystals (#8A4FD8)
- Head: cluster of small glowing ice-blue eyes (#9FE3FF), crystal fangs
- Details: eight thin glowing ice-blue crystal legs (#9FE3FF)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no fur, no green, no human body.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. POUNCE: body stretched forward in the air, jaws open.
3. SIDE SWIPE: head and claws swept to the side, body twisted.
4. HOWL: head raised to the sky, prismatic blue and violet crystal shards gathering around the body.
5. ROAR: mouth wide open, prismatic blue and violet crystal shards burst in front of the head.
6. BREATH: a short prismatic blue and violet crystal shards breath released forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Araignée de cristal: spider with a round body made of violet amethyst crystals (#8A4FD8); cluster of small glowing ice-blue eyes (#9FE3FF), crystal fangs; eight thin glowing ice-blue crystal legs (#9FE3FF). Forbidden: no fur, no green, no human body.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `araignee_de_cristal_attack.png` |
| 1-2 | attaque 2 | `araignee_de_cristal_attack_2.png` |
| 1-3 | attaque 3 | `araignee_de_cristal_attack_3.png` |
| 2-1 | sort 1 | `araignee_de_cristal_cast.png` |
| 2-2 | sort 2 | `araignee_de_cristal_cast_2.png` |
| 2-3 | sort 3 | `araignee_de_cristal_cast_3.png` |

### Mage cristallin — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cristaux/` ; nomme tes images `mage_cristallin_vues.png` et `mage_cristallin_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Mage cristallin (enemy of the Cristaux nation)
- Body: slender crystal mage with a smooth pale blue body (#BFD8FF)
- Head: hair made of sharp violet crystal shards (#8A4FD8), glowing white eyes
- Top: short dark violet robe with silver trims
- Weapon: slim crystal staff with a violet crystal tip, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human skin, no hat, no hood.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Mage cristallin: slender crystal mage with a smooth pale blue body (#BFD8FF); hair made of sharp violet crystal shards (#8A4FD8), glowing white eyes; short dark violet robe with silver trims; slim crystal staff with a violet crystal tip, RIGHT hand. Forbidden: no human skin, no hat, no hood.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `mage_cristallin.png` |
| 1-2 | 3/4 avant droite | `mage_cristallin_face_right.png` |
| 1-3 | 3/4 dos droite | `mage_cristallin_back_right.png` |
| 2-1 | dos complet | `mage_cristallin_back.png` |
| 2-2 | 3/4 dos gauche | `mage_cristallin_back_left.png` |
| 2-3 | 3/4 avant gauche | `mage_cristallin_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Mage cristallin, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Mage cristallin (enemy of the Cristaux nation)
- Body: slender crystal mage with a smooth pale blue body (#BFD8FF)
- Head: hair made of sharp violet crystal shards (#8A4FD8), glowing white eyes
- Top: short dark violet robe with silver trims
- Weapon: slim crystal staff with a violet crystal tip, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human skin, no hat, no hood.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short prismatic blue and violet crystal shards spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. FOCUS: eyes closed, staff held vertically in front of the face, prismatic blue and violet crystal shards orb at the top.
5. INVOCATION: staff raised high with both hands, prismatic blue and violet crystal shards swirling above the head.
6. BLAST: staff pointed forward, a compact prismatic blue and violet crystal shards blast leaving the tip.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Mage cristallin: slender crystal mage with a smooth pale blue body (#BFD8FF); hair made of sharp violet crystal shards (#8A4FD8), glowing white eyes; short dark violet robe with silver trims; slim crystal staff with a violet crystal tip, RIGHT hand. Forbidden: no human skin, no hat, no hood.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `mage_cristallin_attack.png` |
| 1-2 | attaque 2 | `mage_cristallin_attack_2.png` |
| 1-3 | attaque 3 | `mage_cristallin_attack_3.png` |
| 2-1 | sort 1 | `mage_cristallin_cast.png` |
| 2-2 | sort 2 | `mage_cristallin_cast_2.png` |
| 2-3 | sort 3 | `mage_cristallin_cast_3.png` |

### Golem de cristal — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cristaux/` ; nomme tes images `golem_de_cristal_vues.png` et `golem_de_cristal_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Golem de cristal (enemy of the Cristaux nation)
- Body: heavy golem made of violet (#8A4FD8) and blue (#4F7FE0) crystal clusters on a dark grey rock core
- Head: small head of crystal with two glowing white eyes
- Details: huge crystal fists
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no green, no moss.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Golem de cristal: heavy golem made of violet (#8A4FD8) and blue (#4F7FE0) crystal clusters on a dark grey rock core; small head of crystal with two glowing white eyes; huge crystal fists. Forbidden: no weapon, no green, no moss.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `golem_de_cristal.png` |
| 1-2 | 3/4 avant droite | `golem_de_cristal_face_right.png` |
| 1-3 | 3/4 dos droite | `golem_de_cristal_back_right.png` |
| 2-1 | dos complet | `golem_de_cristal_back.png` |
| 2-2 | 3/4 dos gauche | `golem_de_cristal_back_left.png` |
| 2-3 | 3/4 avant gauche | `golem_de_cristal_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Golem de cristal, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Golem de cristal (enemy of the Cristaux nation)
- Body: heavy golem made of violet (#8A4FD8) and blue (#4F7FE0) crystal clusters on a dark grey rock core
- Head: small head of crystal with two glowing white eyes
- Details: huge crystal fists
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no green, no moss.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted.
4. ROOTED: stomping, prismatic blue and violet crystal shards cracks spreading under the feet.
5. GATHER: arms raised, prismatic blue and violet crystal shards gathering between the hands.
6. SHOCKWAVE: both fists slammed into the ground, prismatic blue and violet crystal shards wave.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Golem de cristal: heavy golem made of violet (#8A4FD8) and blue (#4F7FE0) crystal clusters on a dark grey rock core; small head of crystal with two glowing white eyes; huge crystal fists. Forbidden: no weapon, no green, no moss.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `golem_de_cristal_attack.png` |
| 1-2 | attaque 2 | `golem_de_cristal_attack_2.png` |
| 1-3 | attaque 3 | `golem_de_cristal_attack_3.png` |
| 2-1 | sort 1 | `golem_de_cristal_cast.png` |
| 2-2 | sort 2 | `golem_de_cristal_cast_2.png` |
| 2-3 | sort 3 | `golem_de_cristal_cast_3.png` |

### Élémentaire de cristal — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cristaux/` ; nomme tes images `elementaire_de_cristal_vues.png` et `elementaire_de_cristal_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Élémentaire de cristal (enemy of the Cristaux nation)
- Body: floating humanoid elemental made of sharp violet crystal shards (#8A4FD8), no legs, shards hovering apart at the joints
- Head: pointed crystal head with two glowing ice-blue eyes (#9FE3FF)
- Details: a glowing ice-blue core in the chest
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no feet on the ground, no weapon, no clothes.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Élémentaire de cristal: floating humanoid elemental made of sharp violet crystal shards (#8A4FD8), no legs, shards hovering apart at the joints; pointed crystal head with two glowing ice-blue eyes (#9FE3FF); a glowing ice-blue core in the chest. Forbidden: no feet on the ground, no weapon, no clothes.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `elementaire_de_cristal.png` |
| 1-2 | 3/4 avant droite | `elementaire_de_cristal_face_right.png` |
| 1-3 | 3/4 dos droite | `elementaire_de_cristal_back_right.png` |
| 2-1 | dos complet | `elementaire_de_cristal_back.png` |
| 2-2 | 3/4 dos gauche | `elementaire_de_cristal_back_left.png` |
| 2-3 | 3/4 avant gauche | `elementaire_de_cristal_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Élémentaire de cristal, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Élémentaire de cristal (enemy of the Cristaux nation)
- Body: floating humanoid elemental made of sharp violet crystal shards (#8A4FD8), no legs, shards hovering apart at the joints
- Head: pointed crystal head with two glowing ice-blue eyes (#9FE3FF)
- Details: a glowing ice-blue core in the chest
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no feet on the ground, no weapon, no clothes.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. LUNGE: body stretched forward, claws of prismatic blue and violet crystal shards reaching out.
3. SPIN: body whirling, prismatic blue and violet crystal shards trail around it.
4. HOVER: floating higher, prismatic blue and violet crystal shards orbs circling.
5. PULSE: arms spread, prismatic blue and violet crystal shards pulsing outward.
6. WAVE: a compact prismatic blue and violet crystal shards wave released forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Élémentaire de cristal: floating humanoid elemental made of sharp violet crystal shards (#8A4FD8), no legs, shards hovering apart at the joints; pointed crystal head with two glowing ice-blue eyes (#9FE3FF); a glowing ice-blue core in the chest. Forbidden: no feet on the ground, no weapon, no clothes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `elementaire_de_cristal_attack.png` |
| 1-2 | attaque 2 | `elementaire_de_cristal_attack_2.png` |
| 1-3 | attaque 3 | `elementaire_de_cristal_attack_3.png` |
| 2-1 | sort 1 | `elementaire_de_cristal_cast.png` |
| 2-2 | sort 2 | `elementaire_de_cristal_cast_2.png` |
| 2-3 | sort 3 | `elementaire_de_cristal_cast_3.png` |

## 4. Boss

### Zyphéron le Cristallin — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `cristaux_vues.png` et `cristaux_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Zyphéron le Cristallin (boss of the Cristaux nation)
- Body: tall crystal sorcerer in a long robe of shattered pale crystal plates (#CFE4FF)
- Head: crown of ice-blue shards, pale face, glowing violet eyes
- Weapon: ornate crystal staff, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no beard.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Zyphéron le Cristallin: tall crystal sorcerer in a long robe of shattered pale crystal plates (#CFE4FF); crown of ice-blue shards, pale face, glowing violet eyes; ornate crystal staff, RIGHT hand. Forbidden: no hood, no beard.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `cristaux.png` |
| 1-2 | 3/4 avant droite | `cristaux_face_right.png` |
| 1-3 | 3/4 dos droite | `cristaux_back_right.png` |
| 2-1 | dos complet | `cristaux_back.png` |
| 2-2 | 3/4 dos gauche | `cristaux_back_left.png` |
| 2-3 | 3/4 avant gauche | `cristaux_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE final boss, Zyphéron le Cristallin, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Zyphéron le Cristallin (boss of the Cristaux nation)
- Body: tall crystal sorcerer in a long robe of shattered pale crystal plates (#CFE4FF)
- Head: crown of ice-blue shards, pale face, glowing violet eyes
- Weapon: ornate crystal staff, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no beard.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short prismatic blue and violet crystal shards spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. FOCUS: eyes closed, staff held vertically in front of the face, prismatic blue and violet crystal shards orb at the top.
5. INVOCATION: staff raised high with both hands, prismatic blue and violet crystal shards swirling above the head.
6. BLAST: staff pointed forward, a compact prismatic blue and violet crystal shards blast leaving the tip.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Zyphéron le Cristallin: tall crystal sorcerer in a long robe of shattered pale crystal plates (#CFE4FF); crown of ice-blue shards, pale face, glowing violet eyes; ornate crystal staff, RIGHT hand. Forbidden: no hood, no beard.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `cristaux_attack.png` |
| 1-2 | attaque 2 | `cristaux_attack_2.png` |
| 1-3 | attaque 3 | `cristaux_attack_3.png` |
| 2-1 | sort 1 | `cristaux_cast.png` |
| 2-2 | sort 2 | `cristaux_cast_2.png` |
| 2-3 | sort 3 | `cristaux_cast_3.png` |

## Prompt négatif

**Planches vues** (la même pose vue sous 6 angles est voulue, les vues vers la gauche aussi — le négatif commun est adapté) :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, different character between cells, pose changing between cells, different outfit between angles, realistic proportions, small head
```

**Planches actions et planche de style** :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses, identical poses, repeated pose, copy of the same pose, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, front and back views mixed, different character between poses, realistic proportions, small head
```
