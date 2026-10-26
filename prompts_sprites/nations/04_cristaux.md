# Nation Cristaux (Cristaux)

Palette : silver white, sapphire blue, amethyst violet. Effets : prismatic blue and violet crystal shards. Contre-jour : violet.

Format 3 planches par personnage (V44) :

1. **Vues** — 4 cases : repos de FACE ×2 (deux attitudes différentes) puis repos de DOS ×2, tout orienté vers la droite (le jeu retourne l'image pour la gauche). Grille 2 × 2 sur image 2:1, poses largement espacées. Génération normale.
2. **Actions de face** — 3 attaques + 2 sorts + 1 marche (3 colonnes × 2 rangées), en **édition** de la planche vues : le personnage réellement dessiné sert d'ancre.
3. **Actions de dos** — les mêmes 6 poses vues de dos, en édition de la planche vues. Une planche = un seul sens de vue (face et dos mélangés sur une même planche étaient dessinés de face). Facultative pour les monstres.

Les personnages **armés** ont l'arme écrite dans la première phrase, dans la carte d'identité, en fin de prompt et dans chaque pose ; les **créatures** reçoivent « UNARMED » (plus de torche inventée). Chaque prompt recopie la carte d'identité (`identites.py`) : aucune image à joindre. Ordre conseillé : 1) planche de style, 2) héros, 3) ennemis, 4) boss ; pour chaque personnage : vues, actions de face, actions de dos. Prompt négatif : en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Cristaux nation (Cristaux biome).
NATION PALETTE: silver white, sapphire blue, amethyst violet. Signature effects: prismatic blue and violet crystal shards.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle violet highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: two rows with the same 6 characters in the same order, all in idle pose. Top row: 3/4 front view, facing front-right. Bottom row: 3/4 back view, seen from behind, turned toward the upper right. All feet of a row on the same ground line. Leave a wide empty gap (at least half a character width) between characters and between the two rows: nobody overlaps or touches anyone, held items and capes included. Image aspect ratio 2:1, as large as possible.
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

### Mage — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `mage_vues.png`, `mage_actions.png` et `mage_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE playable hero: Mage, carrying: ornate silver staff topped with a glowing blue crystal (#5CC8FF), RIGHT hand.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Mage (hero of the Cristaux nation)
- Hair: dark navy-blue hair (#1E2C5A), medium length, side bangs
- Eyes: bright blue eyes (#3FA0FF), always open
- Skin: fair skin
- Top: long silver-white robe (#E8ECF4) with light-blue crystal patterns and sapphire trims (#2A5BD7)
- Bottom: the robe reaches the ankles, dark blue trousers visible below
- Feet: dark blue boots with silver tips
- Held item: ornate silver staff topped with a glowing blue crystal (#5CC8FF), RIGHT hand
- Held item: an ornate brown leather spellbook with golden corners and a sapphire gem on the cover, held open in the LEFT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wizard hat, no white or silver hair, no beard, no missing spellbook.
HELD ITEM: ornate silver staff topped with a glowing blue crystal (#5CC8FF), RIGHT hand. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle violet highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm. The ornate silver staff topped with a glowing blue crystal is held in the right hand and fully visible in this cell.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the held item stays in its hand); the face is visible and the drawing must not be a copy of cell 1. The ornate silver staff topped with a glowing blue crystal is held in the right hand and fully visible in this cell.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile. The ornate silver staff topped with a glowing blue crystal is held in the right hand and fully visible in this cell.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the held item stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3. The ornate silver staff topped with a glowing blue crystal is held in the right hand and fully visible in this cell.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: ornate silver staff topped with a glowing blue crystal (#5CC8FF), RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Mage: ornate silver staff topped with a glowing blue crystal (#5CC8FF), RIGHT hand; dark navy-blue hair (#1E2C5A), medium length, side bangs; bright blue eyes (#3FA0FF), always open; long silver-white robe (#E8ECF4) with light-blue crystal patterns and sapphire trims (#2A5BD7); fair skin; the robe reaches the ankles, dark blue trousers visible below; dark blue boots with silver tips; an ornate brown leather spellbook with golden corners and a sapphire gem on the cover, held open in the LEFT hand. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no wizard hat, no white or silver hair, no beard, no missing spellbook. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `mage.png` |
| 1-2 | repos de face, variante | `mage_idle_2.png` |
| 2-1 | repos de dos | `mage_back.png` |
| 2-2 | repos de dos, variante | `mage_back_idle_2.png` |

##### Version courte de la planche vues

À utiliser si le générateur reformule le prompt, bloque sur un mot ou ne respecte pas le nombre de cases : mêmes consignes, 1 000 caractères.

```text
Character sheet, exactly 4 sprites in a 2x2 grid, plain flat medium gray background, wide empty gaps, no overlap, no text, no frame. ONE playable hero: Mage. dark navy-blue hair (#1E2C5A), medium length, side bangs; bright blue eyes (#3FA0FF), always open; fair skin; long silver-white robe (#E8ECF4) with light-blue crystal patterns and sapphire trims (#2A5BD7); the robe reaches the ankles, dark blue trousers visible below; dark blue boots with silver tips; ornate silver staff topped with a glowing blue crystal (#5CC8FF), RIGHT hand; an ornate brown leather spellbook with golden corners and a sapphire gem on the cover, held open in the LEFT hand. It always holds the ornate silver staff topped with a glowing blue crystal in the right hand, clearly visible in all 4 sprites. Top row: two front 3/4 views facing right, two slightly different relaxed stances (not mirrored). Bottom row: two views from behind, facing away toward the upper right, no face visible, two different stances. Same outfit, colors and size in all 4, feet on one line. Style: smooth hand-drawn vector cartoon, thick dark outlines, Dofus / Waven look, NOT pixel art. Never facing left. Forbidden: no wizard hat, no white or silver hair, no beard, no missing spellbook.
```

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE playable hero: Mage, carrying: ornate silver staff topped with a glowing blue crystal (#5CC8FF), RIGHT hand.
SOURCE IMAGE: it shows this playable hero, Mage, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Mage (hero of the Cristaux nation)
- Hair: dark navy-blue hair (#1E2C5A), medium length, side bangs
- Eyes: bright blue eyes (#3FA0FF), always open
- Skin: fair skin
- Top: long silver-white robe (#E8ECF4) with light-blue crystal patterns and sapphire trims (#2A5BD7)
- Bottom: the robe reaches the ankles, dark blue trousers visible below
- Feet: dark blue boots with silver tips
- Held item: ornate silver staff topped with a glowing blue crystal (#5CC8FF), RIGHT hand
- Held item: an ornate brown leather spellbook with golden corners and a sapphire gem on the cover, held open in the LEFT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wizard hat, no white or silver hair, no beard, no missing spellbook.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its held item in the correct hand — add the held item where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm. The ornate silver staff topped with a glowing blue crystal is held in the right hand and fully visible in this cell.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the held item stays in its hand); the face is visible and the drawing must not be a copy of cell 1. The ornate silver staff topped with a glowing blue crystal is held in the right hand and fully visible in this cell.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile. The ornate silver staff topped with a glowing blue crystal is held in the right hand and fully visible in this cell.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the held item stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3. The ornate silver staff topped with a glowing blue crystal is held in the right hand and fully visible in this cell.
HELD ITEM: ornate silver staff topped with a glowing blue crystal (#5CC8FF), RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Mage: ornate silver staff topped with a glowing blue crystal (#5CC8FF), RIGHT hand; dark navy-blue hair (#1E2C5A), medium length, side bangs; bright blue eyes (#3FA0FF), always open; long silver-white robe (#E8ECF4) with light-blue crystal patterns and sapphire trims (#2A5BD7); fair skin; the robe reaches the ankles, dark blue trousers visible below; dark blue boots with silver tips; an ornate brown leather spellbook with golden corners and a sapphire gem on the cover, held open in the LEFT hand. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no wizard hat, no white or silver hair, no beard, no missing spellbook. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE playable hero: Mage, carrying: ornate silver staff topped with a glowing blue crystal (#5CC8FF), RIGHT hand.
SOURCE IMAGE: it shows this playable hero, Mage, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, held item in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Mage (hero of the Cristaux nation)
- Hair: dark navy-blue hair (#1E2C5A), medium length, side bangs
- Eyes: bright blue eyes (#3FA0FF), always open
- Skin: fair skin
- Top: long silver-white robe (#E8ECF4) with light-blue crystal patterns and sapphire trims (#2A5BD7)
- Bottom: the robe reaches the ankles, dark blue trousers visible below
- Feet: dark blue boots with silver tips
- Held item: ornate silver staff topped with a glowing blue crystal (#5CC8FF), RIGHT hand
- Held item: an ornate brown leather spellbook with golden corners and a sapphire gem on the cover, held open in the LEFT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wizard hat, no white or silver hair, no beard, no missing spellbook.
HELD ITEM: ornate silver staff topped with a glowing blue crystal (#5CC8FF), RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle violet highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands — silhouette: tall and vertical, limbs raised above the head. The ornate silver staff topped with a glowing blue crystal is held in the right hand and fully visible in this cell.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short prismatic blue and violet crystal shards spark — silhouette: wide and horizontal, body stretched far forward. The ornate silver staff topped with a glowing blue crystal is held in the right hand and fully visible in this cell.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach. The ornate silver staff topped with a glowing blue crystal is held in the right hand and fully visible in this cell.
4. FOCUS: eyes closed, staff held vertically in front of the face, prismatic blue and violet crystal shards orb at the top — silhouette: compact and rounded, hands gathered near the chest. The ornate silver staff topped with a glowing blue crystal is held in the right hand and fully visible in this cell.
5. INVOCATION: staff raised high with both hands, prismatic blue and violet crystal shards swirling above the head — silhouette: tall, both arms thrown up or spread wide. The ornate silver staff topped with a glowing blue crystal is held in the right hand and fully visible in this cell.
6. WALK: mid-stride, one foot raised, arms swinging naturally, held item held — silhouette: mid-stride with legs clearly apart, moving forward. The ornate silver staff topped with a glowing blue crystal is held in the right hand and fully visible in this cell.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: ornate silver staff topped with a glowing blue crystal (#5CC8FF), RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Mage: ornate silver staff topped with a glowing blue crystal (#5CC8FF), RIGHT hand; dark navy-blue hair (#1E2C5A), medium length, side bangs; bright blue eyes (#3FA0FF), always open; long silver-white robe (#E8ECF4) with light-blue crystal patterns and sapphire trims (#2A5BD7); fair skin; the robe reaches the ankles, dark blue trousers visible below; dark blue boots with silver tips; an ornate brown leather spellbook with golden corners and a sapphire gem on the cover, held open in the LEFT hand. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no wizard hat, no white or silver hair, no beard, no missing spellbook. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `mage_attack.png` |
| 1-2 | attaque 2 | `mage_attack_2.png` |
| 1-3 | attaque 3 | `mage_attack_3.png` |
| 2-1 | sort 1 | `mage_cast.png` |
| 2-2 | sort 2 | `mage_cast_2.png` |
| 2-3 | marche | `mage_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE playable hero: Mage, carrying: ornate silver staff topped with a glowing blue crystal (#5CC8FF), RIGHT hand.
SOURCE IMAGE: it shows this playable hero, Mage, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, held item in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Mage (hero of the Cristaux nation)
- Hair: dark navy-blue hair (#1E2C5A), medium length, side bangs
- Eyes: bright blue eyes (#3FA0FF), always open
- Skin: fair skin
- Top: long silver-white robe (#E8ECF4) with light-blue crystal patterns and sapphire trims (#2A5BD7)
- Bottom: the robe reaches the ankles, dark blue trousers visible below
- Feet: dark blue boots with silver tips
- Held item: ornate silver staff topped with a glowing blue crystal (#5CC8FF), RIGHT hand
- Held item: an ornate brown leather spellbook with golden corners and a sapphire gem on the cover, held open in the LEFT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wizard hat, no white or silver hair, no beard, no missing spellbook.
HELD ITEM: ornate silver staff topped with a glowing blue crystal (#5CC8FF), RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle violet highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands — silhouette: tall and vertical, limbs raised above the head. The ornate silver staff topped with a glowing blue crystal is held in the right hand and fully visible in this cell.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short prismatic blue and violet crystal shards spark — silhouette: wide and horizontal, body stretched far forward. The ornate silver staff topped with a glowing blue crystal is held in the right hand and fully visible in this cell.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach. The ornate silver staff topped with a glowing blue crystal is held in the right hand and fully visible in this cell.
4. FOCUS: eyes closed, staff held vertically in front of the face, prismatic blue and violet crystal shards orb at the top — silhouette: compact and rounded, hands gathered near the chest. The ornate silver staff topped with a glowing blue crystal is held in the right hand and fully visible in this cell.
5. INVOCATION: staff raised high with both hands, prismatic blue and violet crystal shards swirling above the head — silhouette: tall, both arms thrown up or spread wide. The ornate silver staff topped with a glowing blue crystal is held in the right hand and fully visible in this cell.
6. WALK: mid-stride, one foot raised, arms swinging naturally, held item held — silhouette: mid-stride with legs clearly apart, moving forward. The ornate silver staff topped with a glowing blue crystal is held in the right hand and fully visible in this cell.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: ornate silver staff topped with a glowing blue crystal (#5CC8FF), RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Mage: ornate silver staff topped with a glowing blue crystal (#5CC8FF), RIGHT hand; dark navy-blue hair (#1E2C5A), medium length, side bangs; bright blue eyes (#3FA0FF), always open; long silver-white robe (#E8ECF4) with light-blue crystal patterns and sapphire trims (#2A5BD7); fair skin; the robe reaches the ankles, dark blue trousers visible below; dark blue boots with silver tips; an ornate brown leather spellbook with golden corners and a sapphire gem on the cover, held open in the LEFT hand. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no wizard hat, no white or silver hair, no beard, no missing spellbook. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `mage_back_attack.png` |
| 1-2 | attaque 2 — dos | `mage_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `mage_back_attack_3.png` |
| 2-1 | sort 1 — dos | `mage_back_cast.png` |
| 2-2 | sort 2 — dos | `mage_back_cast_2.png` |
| 2-3 | marche — dos | `mage_back_walk.png` |

L'export Zimut de l'Atelier copie aussi le repos (case 1 de la planche vues) vers `nations/heros/mage.png`.

## 3. Ennemis

### Araignée de cristal — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cristaux/` ; nomme tes images `araignee_de_cristal_vues.png`, `araignee_de_cristal_actions.png` et `araignee_de_cristal_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Araignée de cristal — an NO HELD ITEM creature (no held item of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Araignée de cristal (enemy of the Cristaux nation)
- Body: spider with a round body made of violet amethyst crystals (#8A4FD8)
- Head: cluster of small glowing ice-blue eyes (#9FE3FF), crystal fangs
- Details: eight thin glowing ice-blue crystal legs (#9FE3FF)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no fur, no green, no human body.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 4 cells; it acts only with its own body (claws, fists, tail, magic). Never add an item.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle violet highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in every cell; it acts only with its own body (claws, fists, tail, magic). Never add an item.
REMINDER: this is Araignée de cristal: spider with a round body made of violet amethyst crystals (#8A4FD8); cluster of small glowing ice-blue eyes (#9FE3FF), crystal fangs; eight thin glowing ice-blue crystal legs (#9FE3FF). NO held item and no held object, ever. Forbidden: no fur, no green, no human body. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `araignee_de_cristal.png` |
| 1-2 | repos de face, variante | `araignee_de_cristal_idle_2.png` |
| 2-1 | repos de dos | `araignee_de_cristal_back.png` |
| 2-2 | repos de dos, variante | `araignee_de_cristal_back_idle_2.png` |

##### Version courte de la planche vues

À utiliser si le générateur reformule le prompt, bloque sur un mot ou ne respecte pas le nombre de cases : mêmes consignes, 1 000 caractères.

```text
Character sheet, exactly 4 sprites in a 2x2 grid, plain flat white background, wide empty gaps, no overlap, no text, no frame. ONE enemy monster: Araignée de cristal. spider with a round body made of violet amethyst crystals (#8A4FD8); cluster of small glowing ice-blue eyes (#9FE3FF), crystal fangs; eight thin glowing ice-blue crystal legs (#9FE3FF). It holds nothing in its hands, paws or claws. Top row: two front 3/4 views facing right, two slightly different relaxed stances (not mirrored). Bottom row: two views from behind, facing away toward the upper right, no face visible, two different stances. Same outfit, colors and size in all 4, feet on one line. Style: smooth hand-drawn vector cartoon, thick dark outlines, Dofus / Waven look, NOT pixel art. Never facing left. Forbidden: no fur, no green, no human body.
```

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Araignée de cristal — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Araignée de cristal, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Araignée de cristal (enemy of the Cristaux nation)
- Body: spider with a round body made of violet amethyst crystals (#8A4FD8)
- Head: cluster of small glowing ice-blue eyes (#9FE3FF), crystal fangs
- Details: eight thin glowing ice-blue crystal legs (#9FE3FF)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no fur, no green, no human body.
TASK: REMOVE every held item, torch, tool or held object from the hands, claws or tail — this creature is item-free. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in every cell; it acts only with its own body (claws, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Araignée de cristal: spider with a round body made of violet amethyst crystals (#8A4FD8); cluster of small glowing ice-blue eyes (#9FE3FF), crystal fangs; eight thin glowing ice-blue crystal legs (#9FE3FF). NO held item and no held object, ever. Forbidden: no fur, no green, no human body. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Araignée de cristal — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Araignée de cristal, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Araignée de cristal (enemy of the Cristaux nation)
- Body: spider with a round body made of violet amethyst crystals (#8A4FD8)
- Head: cluster of small glowing ice-blue eyes (#9FE3FF), crystal fangs
- Details: eight thin glowing ice-blue crystal legs (#9FE3FF)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no fur, no green, no human body.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 6 poses; it acts only with its own body (claws, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle violet highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high — silhouette: tall and vertical, limbs raised above the head.
2. POUNCE: body stretched forward in the air, jaws open — silhouette: wide and horizontal, body stretched far forward.
3. SIDE SWIPE: head and claws swept to the side, body twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. HOWL: head raised to the sky, prismatic blue and violet crystal shards gathering around the body — silhouette: compact and rounded, hands gathered near the chest.
5. ROAR: mouth wide open, prismatic blue and violet crystal shards burst in front of the head — silhouette: tall, both arms thrown up or spread wide.
6. WALK: mid-stride, one front paw raised, body moving forward — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Araignée de cristal: spider with a round body made of violet amethyst crystals (#8A4FD8); cluster of small glowing ice-blue eyes (#9FE3FF), crystal fangs; eight thin glowing ice-blue crystal legs (#9FE3FF). NO held item and no held object, ever. Forbidden: no fur, no green, no human body. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `araignee_de_cristal_attack.png` |
| 1-2 | attaque 2 | `araignee_de_cristal_attack_2.png` |
| 1-3 | attaque 3 | `araignee_de_cristal_attack_3.png` |
| 2-1 | sort 1 | `araignee_de_cristal_cast.png` |
| 2-2 | sort 2 | `araignee_de_cristal_cast_2.png` |
| 2-3 | marche | `araignee_de_cristal_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Araignée de cristal — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Araignée de cristal, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Araignée de cristal (enemy of the Cristaux nation)
- Body: spider with a round body made of violet amethyst crystals (#8A4FD8)
- Head: cluster of small glowing ice-blue eyes (#9FE3FF), crystal fangs
- Details: eight thin glowing ice-blue crystal legs (#9FE3FF)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no fur, no green, no human body.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 6 poses; it acts only with its own body (claws, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle violet highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high — silhouette: tall and vertical, limbs raised above the head.
2. POUNCE: body stretched forward in the air, jaws open — silhouette: wide and horizontal, body stretched far forward.
3. SIDE SWIPE: head and claws swept to the side, body twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. HOWL: head raised to the sky, prismatic blue and violet crystal shards gathering around the body — silhouette: compact and rounded, hands gathered near the chest.
5. ROAR: mouth wide open, prismatic blue and violet crystal shards burst in front of the head — silhouette: tall, both arms thrown up or spread wide.
6. WALK: mid-stride, one front paw raised, body moving forward — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Araignée de cristal: spider with a round body made of violet amethyst crystals (#8A4FD8); cluster of small glowing ice-blue eyes (#9FE3FF), crystal fangs; eight thin glowing ice-blue crystal legs (#9FE3FF). NO held item and no held object, ever. Forbidden: no fur, no green, no human body. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `araignee_de_cristal_back_attack.png` |
| 1-2 | attaque 2 — dos | `araignee_de_cristal_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `araignee_de_cristal_back_attack_3.png` |
| 2-1 | sort 1 — dos | `araignee_de_cristal_back_cast.png` |
| 2-2 | sort 2 — dos | `araignee_de_cristal_back_cast_2.png` |
| 2-3 | marche — dos | `araignee_de_cristal_back_walk.png` |

### Mage cristallin — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cristaux/` ; nomme tes images `mage_cristallin_vues.png`, `mage_cristallin_actions.png` et `mage_cristallin_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Mage cristallin, carrying: slim crystal staff with a violet crystal tip, RIGHT hand.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Mage cristallin (enemy of the Cristaux nation)
- Body: slender crystal mage with a smooth pale blue body (#BFD8FF)
- Head: hair made of sharp violet crystal shards (#8A4FD8), glowing white eyes
- Top: short dark violet robe with silver trims
- Held item: slim crystal staff with a violet crystal tip, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human skin, no hat, no hood.
HELD ITEM: slim crystal staff with a violet crystal tip, RIGHT hand. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle violet highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm. The slim crystal staff with a violet crystal tip is held in the right hand and fully visible in this cell.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the held item stays in its hand); the face is visible and the drawing must not be a copy of cell 1. The slim crystal staff with a violet crystal tip is held in the right hand and fully visible in this cell.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile. The slim crystal staff with a violet crystal tip is held in the right hand and fully visible in this cell.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the held item stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3. The slim crystal staff with a violet crystal tip is held in the right hand and fully visible in this cell.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: slim crystal staff with a violet crystal tip, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Mage cristallin: slim crystal staff with a violet crystal tip, RIGHT hand; short dark violet robe with silver trims; slender crystal mage with a smooth pale blue body (#BFD8FF); hair made of sharp violet crystal shards (#8A4FD8), glowing white eyes. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no human skin, no hat, no hood. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `mage_cristallin.png` |
| 1-2 | repos de face, variante | `mage_cristallin_idle_2.png` |
| 2-1 | repos de dos | `mage_cristallin_back.png` |
| 2-2 | repos de dos, variante | `mage_cristallin_back_idle_2.png` |

##### Version courte de la planche vues

À utiliser si le générateur reformule le prompt, bloque sur un mot ou ne respecte pas le nombre de cases : mêmes consignes, 1 000 caractères.

```text
Character sheet, exactly 4 sprites in a 2x2 grid, plain flat medium gray background, wide empty gaps, no overlap, no text, no frame. ONE enemy monster: Mage cristallin. slender crystal mage with a smooth pale blue body (#BFD8FF); hair made of sharp violet crystal shards (#8A4FD8), glowing white eyes; short dark violet robe with silver trims; slim crystal staff with a violet crystal tip, RIGHT hand. It always holds the slim crystal staff with a violet crystal tip in the right hand, clearly visible in all 4 sprites. Top row: two front 3/4 views facing right, two slightly different relaxed stances (not mirrored). Bottom row: two views from behind, facing away toward the upper right, no face visible, two different stances. Same outfit, colors and size in all 4, feet on one line. Style: smooth hand-drawn vector cartoon, thick dark outlines, Dofus / Waven look, NOT pixel art. Never facing left. Forbidden: no human skin, no hat, no hood.
```

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Mage cristallin, carrying: slim crystal staff with a violet crystal tip, RIGHT hand.
SOURCE IMAGE: it shows this enemy monster, Mage cristallin, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Mage cristallin (enemy of the Cristaux nation)
- Body: slender crystal mage with a smooth pale blue body (#BFD8FF)
- Head: hair made of sharp violet crystal shards (#8A4FD8), glowing white eyes
- Top: short dark violet robe with silver trims
- Held item: slim crystal staff with a violet crystal tip, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human skin, no hat, no hood.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its held item in the correct hand — add the held item where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm. The slim crystal staff with a violet crystal tip is held in the right hand and fully visible in this cell.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the held item stays in its hand); the face is visible and the drawing must not be a copy of cell 1. The slim crystal staff with a violet crystal tip is held in the right hand and fully visible in this cell.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile. The slim crystal staff with a violet crystal tip is held in the right hand and fully visible in this cell.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the held item stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3. The slim crystal staff with a violet crystal tip is held in the right hand and fully visible in this cell.
HELD ITEM: slim crystal staff with a violet crystal tip, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Mage cristallin: slim crystal staff with a violet crystal tip, RIGHT hand; short dark violet robe with silver trims; slender crystal mage with a smooth pale blue body (#BFD8FF); hair made of sharp violet crystal shards (#8A4FD8), glowing white eyes. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no human skin, no hat, no hood. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Mage cristallin, carrying: slim crystal staff with a violet crystal tip, RIGHT hand.
SOURCE IMAGE: it shows this enemy monster, Mage cristallin, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, held item in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Mage cristallin (enemy of the Cristaux nation)
- Body: slender crystal mage with a smooth pale blue body (#BFD8FF)
- Head: hair made of sharp violet crystal shards (#8A4FD8), glowing white eyes
- Top: short dark violet robe with silver trims
- Held item: slim crystal staff with a violet crystal tip, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human skin, no hat, no hood.
HELD ITEM: slim crystal staff with a violet crystal tip, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle violet highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands — silhouette: tall and vertical, limbs raised above the head. The slim crystal staff with a violet crystal tip is held in the right hand and fully visible in this cell.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short prismatic blue and violet crystal shards spark — silhouette: wide and horizontal, body stretched far forward. The slim crystal staff with a violet crystal tip is held in the right hand and fully visible in this cell.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach. The slim crystal staff with a violet crystal tip is held in the right hand and fully visible in this cell.
4. FOCUS: eyes closed, staff held vertically in front of the face, prismatic blue and violet crystal shards orb at the top — silhouette: compact and rounded, hands gathered near the chest. The slim crystal staff with a violet crystal tip is held in the right hand and fully visible in this cell.
5. INVOCATION: staff raised high with both hands, prismatic blue and violet crystal shards swirling above the head — silhouette: tall, both arms thrown up or spread wide. The slim crystal staff with a violet crystal tip is held in the right hand and fully visible in this cell.
6. WALK: mid-stride, one foot raised, arms swinging naturally, held item held — silhouette: mid-stride with legs clearly apart, moving forward. The slim crystal staff with a violet crystal tip is held in the right hand and fully visible in this cell.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: slim crystal staff with a violet crystal tip, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Mage cristallin: slim crystal staff with a violet crystal tip, RIGHT hand; short dark violet robe with silver trims; slender crystal mage with a smooth pale blue body (#BFD8FF); hair made of sharp violet crystal shards (#8A4FD8), glowing white eyes. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no human skin, no hat, no hood. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `mage_cristallin_attack.png` |
| 1-2 | attaque 2 | `mage_cristallin_attack_2.png` |
| 1-3 | attaque 3 | `mage_cristallin_attack_3.png` |
| 2-1 | sort 1 | `mage_cristallin_cast.png` |
| 2-2 | sort 2 | `mage_cristallin_cast_2.png` |
| 2-3 | marche | `mage_cristallin_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Mage cristallin, carrying: slim crystal staff with a violet crystal tip, RIGHT hand.
SOURCE IMAGE: it shows this enemy monster, Mage cristallin, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, held item in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Mage cristallin (enemy of the Cristaux nation)
- Body: slender crystal mage with a smooth pale blue body (#BFD8FF)
- Head: hair made of sharp violet crystal shards (#8A4FD8), glowing white eyes
- Top: short dark violet robe with silver trims
- Held item: slim crystal staff with a violet crystal tip, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human skin, no hat, no hood.
HELD ITEM: slim crystal staff with a violet crystal tip, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle violet highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands — silhouette: tall and vertical, limbs raised above the head. The slim crystal staff with a violet crystal tip is held in the right hand and fully visible in this cell.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short prismatic blue and violet crystal shards spark — silhouette: wide and horizontal, body stretched far forward. The slim crystal staff with a violet crystal tip is held in the right hand and fully visible in this cell.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach. The slim crystal staff with a violet crystal tip is held in the right hand and fully visible in this cell.
4. FOCUS: eyes closed, staff held vertically in front of the face, prismatic blue and violet crystal shards orb at the top — silhouette: compact and rounded, hands gathered near the chest. The slim crystal staff with a violet crystal tip is held in the right hand and fully visible in this cell.
5. INVOCATION: staff raised high with both hands, prismatic blue and violet crystal shards swirling above the head — silhouette: tall, both arms thrown up or spread wide. The slim crystal staff with a violet crystal tip is held in the right hand and fully visible in this cell.
6. WALK: mid-stride, one foot raised, arms swinging naturally, held item held — silhouette: mid-stride with legs clearly apart, moving forward. The slim crystal staff with a violet crystal tip is held in the right hand and fully visible in this cell.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: slim crystal staff with a violet crystal tip, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Mage cristallin: slim crystal staff with a violet crystal tip, RIGHT hand; short dark violet robe with silver trims; slender crystal mage with a smooth pale blue body (#BFD8FF); hair made of sharp violet crystal shards (#8A4FD8), glowing white eyes. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no human skin, no hat, no hood. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `mage_cristallin_back_attack.png` |
| 1-2 | attaque 2 — dos | `mage_cristallin_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `mage_cristallin_back_attack_3.png` |
| 2-1 | sort 1 — dos | `mage_cristallin_back_cast.png` |
| 2-2 | sort 2 — dos | `mage_cristallin_back_cast_2.png` |
| 2-3 | marche — dos | `mage_cristallin_back_walk.png` |

### Golem de cristal — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cristaux/` ; nomme tes images `golem_de_cristal_vues.png`, `golem_de_cristal_actions.png` et `golem_de_cristal_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Golem de cristal — an NO HELD ITEM creature (no held item of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Golem de cristal (enemy of the Cristaux nation)
- Body: heavy golem made of violet (#8A4FD8) and blue (#4F7FE0) crystal clusters on a dark grey rock core
- Head: small head of crystal with two glowing white eyes
- Details: huge crystal fists
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no held item, no green, no moss.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 4 cells; it acts only with its own body (claws, fists, tail, magic). Never add an item.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle violet highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in every cell; it acts only with its own body (claws, fists, tail, magic). Never add an item.
REMINDER: this is Golem de cristal: heavy golem made of violet (#8A4FD8) and blue (#4F7FE0) crystal clusters on a dark grey rock core; small head of crystal with two glowing white eyes; huge crystal fists. NO held item and no held object, ever. Forbidden: no held item, no green, no moss. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `golem_de_cristal.png` |
| 1-2 | repos de face, variante | `golem_de_cristal_idle_2.png` |
| 2-1 | repos de dos | `golem_de_cristal_back.png` |
| 2-2 | repos de dos, variante | `golem_de_cristal_back_idle_2.png` |

##### Version courte de la planche vues

À utiliser si le générateur reformule le prompt, bloque sur un mot ou ne respecte pas le nombre de cases : mêmes consignes, 1 000 caractères.

```text
Character sheet, exactly 4 sprites in a 2x2 grid, plain flat white background, wide empty gaps, no overlap, no text, no frame. ONE enemy monster: Golem de cristal. heavy golem made of violet (#8A4FD8) and blue (#4F7FE0) crystal clusters on a dark grey rock core; small head of crystal with two glowing white eyes; huge crystal fists. It holds nothing in its hands, paws or claws. Top row: two front 3/4 views facing right, two slightly different relaxed stances (not mirrored). Bottom row: two views from behind, facing away toward the upper right, no face visible, two different stances. Same outfit, colors and size in all 4, feet on one line. Style: smooth hand-drawn vector cartoon, thick dark outlines, Dofus / Waven look, NOT pixel art. Never facing left. Forbidden: no held item, no green, no moss.
```

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Golem de cristal — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Golem de cristal, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Golem de cristal (enemy of the Cristaux nation)
- Body: heavy golem made of violet (#8A4FD8) and blue (#4F7FE0) crystal clusters on a dark grey rock core
- Head: small head of crystal with two glowing white eyes
- Details: huge crystal fists
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no held item, no green, no moss.
TASK: REMOVE every held item, torch, tool or held object from the hands, claws or tail — this creature is item-free. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in every cell; it acts only with its own body (claws, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Golem de cristal: heavy golem made of violet (#8A4FD8) and blue (#4F7FE0) crystal clusters on a dark grey rock core; small head of crystal with two glowing white eyes; huge crystal fists. NO held item and no held object, ever. Forbidden: no held item, no green, no moss. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Golem de cristal — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Golem de cristal, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Golem de cristal (enemy of the Cristaux nation)
- Body: heavy golem made of violet (#8A4FD8) and blue (#4F7FE0) crystal clusters on a dark grey rock core
- Head: small head of crystal with two glowing white eyes
- Details: huge crystal fists
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no held item, no green, no moss.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 6 poses; it acts only with its own body (claws, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle violet highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: both fists or held item raised high above the head — silhouette: tall and vertical, limbs raised above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward — silhouette: wide and horizontal, body stretched far forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. ROOTED: stomping, prismatic blue and violet crystal shards cracks spreading under the feet — silhouette: compact and rounded, hands gathered near the chest.
5. GATHER: arms raised, prismatic blue and violet crystal shards gathering between the hands — silhouette: tall, both arms thrown up or spread wide.
6. WALK: heavy mid-stride, one foot raised, arms swinging — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Golem de cristal: heavy golem made of violet (#8A4FD8) and blue (#4F7FE0) crystal clusters on a dark grey rock core; small head of crystal with two glowing white eyes; huge crystal fists. NO held item and no held object, ever. Forbidden: no held item, no green, no moss. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `golem_de_cristal_attack.png` |
| 1-2 | attaque 2 | `golem_de_cristal_attack_2.png` |
| 1-3 | attaque 3 | `golem_de_cristal_attack_3.png` |
| 2-1 | sort 1 | `golem_de_cristal_cast.png` |
| 2-2 | sort 2 | `golem_de_cristal_cast_2.png` |
| 2-3 | marche | `golem_de_cristal_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Golem de cristal — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Golem de cristal, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Golem de cristal (enemy of the Cristaux nation)
- Body: heavy golem made of violet (#8A4FD8) and blue (#4F7FE0) crystal clusters on a dark grey rock core
- Head: small head of crystal with two glowing white eyes
- Details: huge crystal fists
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no held item, no green, no moss.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 6 poses; it acts only with its own body (claws, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle violet highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: both fists or held item raised high above the head — silhouette: tall and vertical, limbs raised above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward — silhouette: wide and horizontal, body stretched far forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. ROOTED: stomping, prismatic blue and violet crystal shards cracks spreading under the feet — silhouette: compact and rounded, hands gathered near the chest.
5. GATHER: arms raised, prismatic blue and violet crystal shards gathering between the hands — silhouette: tall, both arms thrown up or spread wide.
6. WALK: heavy mid-stride, one foot raised, arms swinging — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Golem de cristal: heavy golem made of violet (#8A4FD8) and blue (#4F7FE0) crystal clusters on a dark grey rock core; small head of crystal with two glowing white eyes; huge crystal fists. NO held item and no held object, ever. Forbidden: no held item, no green, no moss. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `golem_de_cristal_back_attack.png` |
| 1-2 | attaque 2 — dos | `golem_de_cristal_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `golem_de_cristal_back_attack_3.png` |
| 2-1 | sort 1 — dos | `golem_de_cristal_back_cast.png` |
| 2-2 | sort 2 — dos | `golem_de_cristal_back_cast_2.png` |
| 2-3 | marche — dos | `golem_de_cristal_back_walk.png` |

### Élémentaire de cristal — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cristaux/` ; nomme tes images `elementaire_de_cristal_vues.png`, `elementaire_de_cristal_actions.png` et `elementaire_de_cristal_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Élémentaire de cristal — an NO HELD ITEM creature (no held item of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Élémentaire de cristal (enemy of the Cristaux nation)
- Body: floating humanoid elemental made of sharp violet crystal shards (#8A4FD8), no legs, shards hovering apart at the joints
- Head: pointed crystal head with two glowing ice-blue eyes (#9FE3FF)
- Details: a glowing ice-blue core in the chest
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no feet on the ground, no held item, no clothes.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 4 cells; it acts only with its own body (claws, fists, tail, magic). Never add an item.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle violet highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in every cell; it acts only with its own body (claws, fists, tail, magic). Never add an item.
REMINDER: this is Élémentaire de cristal: floating humanoid elemental made of sharp violet crystal shards (#8A4FD8), no legs, shards hovering apart at the joints; pointed crystal head with two glowing ice-blue eyes (#9FE3FF); a glowing ice-blue core in the chest. NO held item and no held object, ever. Forbidden: no feet on the ground, no held item, no clothes. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `elementaire_de_cristal.png` |
| 1-2 | repos de face, variante | `elementaire_de_cristal_idle_2.png` |
| 2-1 | repos de dos | `elementaire_de_cristal_back.png` |
| 2-2 | repos de dos, variante | `elementaire_de_cristal_back_idle_2.png` |

##### Version courte de la planche vues

À utiliser si le générateur reformule le prompt, bloque sur un mot ou ne respecte pas le nombre de cases : mêmes consignes, 1 000 caractères.

```text
Character sheet, exactly 4 sprites in a 2x2 grid, plain flat white background, wide empty gaps, no overlap, no text, no frame. ONE enemy monster: Élémentaire de cristal. floating humanoid elemental made of sharp violet crystal shards (#8A4FD8), no legs, shards hovering apart at the joints; pointed crystal head with two glowing ice-blue eyes (#9FE3FF); a glowing ice-blue core in the chest. It holds nothing in its hands, paws or claws. Top row: two front 3/4 views facing right, two slightly different relaxed stances (not mirrored). Bottom row: two views from behind, facing away toward the upper right, no face visible, two different stances. Same outfit, colors and size in all 4, feet on one line. Style: smooth hand-drawn vector cartoon, thick dark outlines, Dofus / Waven look, NOT pixel art. Never facing left. Forbidden: no feet on the ground, no held item, no clothes.
```

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Élémentaire de cristal — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Élémentaire de cristal, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Élémentaire de cristal (enemy of the Cristaux nation)
- Body: floating humanoid elemental made of sharp violet crystal shards (#8A4FD8), no legs, shards hovering apart at the joints
- Head: pointed crystal head with two glowing ice-blue eyes (#9FE3FF)
- Details: a glowing ice-blue core in the chest
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no feet on the ground, no held item, no clothes.
TASK: REMOVE every held item, torch, tool or held object from the hands, claws or tail — this creature is item-free. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in every cell; it acts only with its own body (claws, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Élémentaire de cristal: floating humanoid elemental made of sharp violet crystal shards (#8A4FD8), no legs, shards hovering apart at the joints; pointed crystal head with two glowing ice-blue eyes (#9FE3FF); a glowing ice-blue core in the chest. NO held item and no held object, ever. Forbidden: no feet on the ground, no held item, no clothes. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Élémentaire de cristal — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Élémentaire de cristal, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Élémentaire de cristal (enemy of the Cristaux nation)
- Body: floating humanoid elemental made of sharp violet crystal shards (#8A4FD8), no legs, shards hovering apart at the joints
- Head: pointed crystal head with two glowing ice-blue eyes (#9FE3FF)
- Details: a glowing ice-blue core in the chest
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no feet on the ground, no held item, no clothes.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 6 poses; it acts only with its own body (claws, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle violet highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised — silhouette: tall and vertical, limbs raised above the head.
2. LUNGE: body stretched forward, claws of prismatic blue and violet crystal shards reaching out — silhouette: wide and horizontal, body stretched far forward.
3. SPIN: body whirling, prismatic blue and violet crystal shards trail around it — silhouette: low and wide, crouched or twisted with a long side reach.
4. HOVER: floating higher, prismatic blue and violet crystal shards orbs circling — silhouette: compact and rounded, hands gathered near the chest.
5. PULSE: arms spread, prismatic blue and violet crystal shards pulsing outward — silhouette: tall, both arms thrown up or spread wide.
6. DRIFT: floating forward with the body tilted slightly ahead, a short trail behind — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Élémentaire de cristal: floating humanoid elemental made of sharp violet crystal shards (#8A4FD8), no legs, shards hovering apart at the joints; pointed crystal head with two glowing ice-blue eyes (#9FE3FF); a glowing ice-blue core in the chest. NO held item and no held object, ever. Forbidden: no feet on the ground, no held item, no clothes. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `elementaire_de_cristal_attack.png` |
| 1-2 | attaque 2 | `elementaire_de_cristal_attack_2.png` |
| 1-3 | attaque 3 | `elementaire_de_cristal_attack_3.png` |
| 2-1 | sort 1 | `elementaire_de_cristal_cast.png` |
| 2-2 | sort 2 | `elementaire_de_cristal_cast_2.png` |
| 2-3 | marche | `elementaire_de_cristal_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Élémentaire de cristal — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Élémentaire de cristal, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Élémentaire de cristal (enemy of the Cristaux nation)
- Body: floating humanoid elemental made of sharp violet crystal shards (#8A4FD8), no legs, shards hovering apart at the joints
- Head: pointed crystal head with two glowing ice-blue eyes (#9FE3FF)
- Details: a glowing ice-blue core in the chest
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no feet on the ground, no held item, no clothes.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 6 poses; it acts only with its own body (claws, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle violet highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised — silhouette: tall and vertical, limbs raised above the head.
2. LUNGE: body stretched forward, claws of prismatic blue and violet crystal shards reaching out — silhouette: wide and horizontal, body stretched far forward.
3. SPIN: body whirling, prismatic blue and violet crystal shards trail around it — silhouette: low and wide, crouched or twisted with a long side reach.
4. HOVER: floating higher, prismatic blue and violet crystal shards orbs circling — silhouette: compact and rounded, hands gathered near the chest.
5. PULSE: arms spread, prismatic blue and violet crystal shards pulsing outward — silhouette: tall, both arms thrown up or spread wide.
6. DRIFT: floating forward with the body tilted slightly ahead, a short trail behind — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Élémentaire de cristal: floating humanoid elemental made of sharp violet crystal shards (#8A4FD8), no legs, shards hovering apart at the joints; pointed crystal head with two glowing ice-blue eyes (#9FE3FF); a glowing ice-blue core in the chest. NO held item and no held object, ever. Forbidden: no feet on the ground, no held item, no clothes. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `elementaire_de_cristal_back_attack.png` |
| 1-2 | attaque 2 — dos | `elementaire_de_cristal_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `elementaire_de_cristal_back_attack_3.png` |
| 2-1 | sort 1 — dos | `elementaire_de_cristal_back_cast.png` |
| 2-2 | sort 2 — dos | `elementaire_de_cristal_back_cast_2.png` |
| 2-3 | marche — dos | `elementaire_de_cristal_back_walk.png` |

## 4. Boss

### Zyphéron le Cristallin — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `cristaux_vues.png`, `cristaux_actions.png` et `cristaux_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE final boss: Zyphéron le Cristallin, carrying: ornate crystal staff, RIGHT hand.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Zyphéron le Cristallin (boss of the Cristaux nation)
- Body: tall crystal sorcerer in a long robe of shattered pale crystal plates (#CFE4FF)
- Head: crown of ice-blue shards, pale face, glowing violet eyes
- Held item: ornate crystal staff, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no beard.
HELD ITEM: ornate crystal staff, RIGHT hand. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle violet highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm. The ornate crystal staff is held in the right hand and fully visible in this cell.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the held item stays in its hand); the face is visible and the drawing must not be a copy of cell 1. The ornate crystal staff is held in the right hand and fully visible in this cell.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile. The ornate crystal staff is held in the right hand and fully visible in this cell.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the held item stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3. The ornate crystal staff is held in the right hand and fully visible in this cell.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: ornate crystal staff, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Zyphéron le Cristallin: ornate crystal staff, RIGHT hand; tall crystal sorcerer in a long robe of shattered pale crystal plates (#CFE4FF); crown of ice-blue shards, pale face, glowing violet eyes. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no beard. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `cristaux.png` |
| 1-2 | repos de face, variante | `cristaux_idle_2.png` |
| 2-1 | repos de dos | `cristaux_back.png` |
| 2-2 | repos de dos, variante | `cristaux_back_idle_2.png` |

##### Version courte de la planche vues

À utiliser si le générateur reformule le prompt, bloque sur un mot ou ne respecte pas le nombre de cases : mêmes consignes, 1 000 caractères.

```text
Character sheet, exactly 4 sprites in a 2x2 grid, plain flat medium gray background, wide empty gaps, no overlap, no text, no frame. ONE final boss: Zyphéron le Cristallin. tall crystal sorcerer in a long robe of shattered pale crystal plates (#CFE4FF); crown of ice-blue shards, pale face, glowing violet eyes; ornate crystal staff, RIGHT hand. It always holds the ornate crystal staff in the right hand, clearly visible in all 4 sprites. Top row: two front 3/4 views facing right, two slightly different relaxed stances (not mirrored). Bottom row: two views from behind, facing away toward the upper right, no face visible, two different stances. Same outfit, colors and size in all 4, feet on one line. Style: smooth hand-drawn vector cartoon, thick dark outlines, Dofus / Waven look, NOT pixel art. Never facing left. Forbidden: no hood, no beard.
```

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE final boss: Zyphéron le Cristallin, carrying: ornate crystal staff, RIGHT hand.
SOURCE IMAGE: it shows this final boss, Zyphéron le Cristallin, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Zyphéron le Cristallin (boss of the Cristaux nation)
- Body: tall crystal sorcerer in a long robe of shattered pale crystal plates (#CFE4FF)
- Head: crown of ice-blue shards, pale face, glowing violet eyes
- Held item: ornate crystal staff, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no beard.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its held item in the correct hand — add the held item where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm. The ornate crystal staff is held in the right hand and fully visible in this cell.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the held item stays in its hand); the face is visible and the drawing must not be a copy of cell 1. The ornate crystal staff is held in the right hand and fully visible in this cell.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile. The ornate crystal staff is held in the right hand and fully visible in this cell.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the held item stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3. The ornate crystal staff is held in the right hand and fully visible in this cell.
HELD ITEM: ornate crystal staff, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Zyphéron le Cristallin: ornate crystal staff, RIGHT hand; tall crystal sorcerer in a long robe of shattered pale crystal plates (#CFE4FF); crown of ice-blue shards, pale face, glowing violet eyes. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no beard. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE final boss: Zyphéron le Cristallin, carrying: ornate crystal staff, RIGHT hand.
SOURCE IMAGE: it shows this final boss, Zyphéron le Cristallin, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, held item in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Zyphéron le Cristallin (boss of the Cristaux nation)
- Body: tall crystal sorcerer in a long robe of shattered pale crystal plates (#CFE4FF)
- Head: crown of ice-blue shards, pale face, glowing violet eyes
- Held item: ornate crystal staff, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no beard.
HELD ITEM: ornate crystal staff, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle violet highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands — silhouette: tall and vertical, limbs raised above the head. The ornate crystal staff is held in the right hand and fully visible in this cell.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short prismatic blue and violet crystal shards spark — silhouette: wide and horizontal, body stretched far forward. The ornate crystal staff is held in the right hand and fully visible in this cell.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach. The ornate crystal staff is held in the right hand and fully visible in this cell.
4. FOCUS: eyes closed, staff held vertically in front of the face, prismatic blue and violet crystal shards orb at the top — silhouette: compact and rounded, hands gathered near the chest. The ornate crystal staff is held in the right hand and fully visible in this cell.
5. INVOCATION: staff raised high with both hands, prismatic blue and violet crystal shards swirling above the head — silhouette: tall, both arms thrown up or spread wide. The ornate crystal staff is held in the right hand and fully visible in this cell.
6. WALK: mid-stride, one foot raised, arms swinging naturally, held item held — silhouette: mid-stride with legs clearly apart, moving forward. The ornate crystal staff is held in the right hand and fully visible in this cell.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: ornate crystal staff, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Zyphéron le Cristallin: ornate crystal staff, RIGHT hand; tall crystal sorcerer in a long robe of shattered pale crystal plates (#CFE4FF); crown of ice-blue shards, pale face, glowing violet eyes. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no beard. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `cristaux_attack.png` |
| 1-2 | attaque 2 | `cristaux_attack_2.png` |
| 1-3 | attaque 3 | `cristaux_attack_3.png` |
| 2-1 | sort 1 | `cristaux_cast.png` |
| 2-2 | sort 2 | `cristaux_cast_2.png` |
| 2-3 | marche | `cristaux_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE final boss: Zyphéron le Cristallin, carrying: ornate crystal staff, RIGHT hand.
SOURCE IMAGE: it shows this final boss, Zyphéron le Cristallin, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, held item in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Zyphéron le Cristallin (boss of the Cristaux nation)
- Body: tall crystal sorcerer in a long robe of shattered pale crystal plates (#CFE4FF)
- Head: crown of ice-blue shards, pale face, glowing violet eyes
- Held item: ornate crystal staff, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no beard.
HELD ITEM: ornate crystal staff, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle violet highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands — silhouette: tall and vertical, limbs raised above the head. The ornate crystal staff is held in the right hand and fully visible in this cell.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short prismatic blue and violet crystal shards spark — silhouette: wide and horizontal, body stretched far forward. The ornate crystal staff is held in the right hand and fully visible in this cell.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach. The ornate crystal staff is held in the right hand and fully visible in this cell.
4. FOCUS: eyes closed, staff held vertically in front of the face, prismatic blue and violet crystal shards orb at the top — silhouette: compact and rounded, hands gathered near the chest. The ornate crystal staff is held in the right hand and fully visible in this cell.
5. INVOCATION: staff raised high with both hands, prismatic blue and violet crystal shards swirling above the head — silhouette: tall, both arms thrown up or spread wide. The ornate crystal staff is held in the right hand and fully visible in this cell.
6. WALK: mid-stride, one foot raised, arms swinging naturally, held item held — silhouette: mid-stride with legs clearly apart, moving forward. The ornate crystal staff is held in the right hand and fully visible in this cell.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: ornate crystal staff, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Zyphéron le Cristallin: ornate crystal staff, RIGHT hand; tall crystal sorcerer in a long robe of shattered pale crystal plates (#CFE4FF); crown of ice-blue shards, pale face, glowing violet eyes. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no beard. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `cristaux_back_attack.png` |
| 1-2 | attaque 2 — dos | `cristaux_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `cristaux_back_attack_3.png` |
| 2-1 | sort 1 — dos | `cristaux_back_cast.png` |
| 2-2 | sort 2 — dos | `cristaux_back_cast_2.png` |
| 2-3 | marche — dos | `cristaux_back_walk.png` |

## Prompt négatif

**Personnages armés — planches vues** :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, held item crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, held item switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, golden glow, light flare, sun rays, color tint over the sprite, glowing aura on one side, cream background, beige background, colored background, ground shadow ellipse, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, pixel grid, low-resolution pixels, painterly soft brush style, mirror image of another sprite, flipped copy, copy of the source pose, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, held item changing shape, held item changing color, held item replaced by another held item, missing held item, missing accessories, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, held item drawn alone without the character, extra objects, different character between poses, realistic proportions, small head, more than 4 sprites, extra sprites, only 3 sprites, empty cell, duplicated row of sprites, one sprite bigger or smaller than the others, size changing between cells, mirror image of another sprite, flipped copy, left-right mirrored pair, four identical front views, back row drawn from the front, low-resolution pixels, pixel grid
```

**Personnages armés — planches actions et planche de style** :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, held item crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, held item switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, golden glow, light flare, sun rays, color tint over the sprite, glowing aura on one side, cream background, beige background, colored background, ground shadow ellipse, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, pixel grid, low-resolution pixels, painterly soft brush style, mirror image of another sprite, flipped copy, copy of the source pose, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, held item changing shape, held item changing color, held item replaced by another held item, missing held item, missing accessories, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, held item drawn alone without the character, extra objects, different character between poses, realistic proportions, small head
```

**Créatures sans arme (Salamandre, golems, bêtes…) — planches vues** :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, golden glow, light flare, sun rays, color tint over the sprite, glowing aura on one side, cream background, beige background, colored background, ground shadow ellipse, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, pixel grid, low-resolution pixels, painterly soft brush style, mirror image of another sprite, flipped copy, copy of the source pose, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, extra objects, different character between poses, realistic proportions, small head, more than 4 sprites, extra sprites, only 3 sprites, empty cell, duplicated row of sprites, one sprite bigger or smaller than the others, size changing between cells, mirror image of another sprite, flipped copy, left-right mirrored pair, four identical front views, back row drawn from the front, low-resolution pixels, pixel grid, held item, torch, staff, sword, bow, held object, tool, item in the hands or claws
```

**Créatures sans arme — planches actions** :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, golden glow, light flare, sun rays, color tint over the sprite, glowing aura on one side, cream background, beige background, colored background, ground shadow ellipse, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, pixel grid, low-resolution pixels, painterly soft brush style, mirror image of another sprite, flipped copy, copy of the source pose, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, extra objects, different character between poses, realistic proportions, small head, held item, torch, staff, sword, bow, held object, tool, item in the hands or claws
```
