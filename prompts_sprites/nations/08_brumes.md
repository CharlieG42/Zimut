# Nation Brumes (Brumes)

Palette : black, deep violet, mist mint green, silver. Effets : mint mist and violet spectral wisps. Contre-jour : pale mint.

Format 3 planches par personnage (V44) :

1. **Vues** — 4 cases : repos de FACE ×2 (deux attitudes différentes) puis repos de DOS ×2, tout orienté vers la droite (le jeu retourne l'image pour la gauche). Grille 2 × 2 sur image 2:1, poses largement espacées. Génération normale.
2. **Actions de face** — 3 attaques + 2 sorts + 1 marche (3 colonnes × 2 rangées), en **édition** de la planche vues : le personnage réellement dessiné sert d'ancre.
3. **Actions de dos** — les mêmes 6 poses vues de dos, en édition de la planche vues. Une planche = un seul sens de vue (face et dos mélangés sur une même planche étaient dessinés de face). Facultative pour les monstres.

Les personnages **armés** ont l'arme écrite dans la première phrase, dans la carte d'identité, en fin de prompt et dans chaque pose ; les **créatures** reçoivent « UNARMED » (plus de torche inventée). Chaque prompt recopie la carte d'identité (`identites.py`) : aucune image à joindre. Ordre conseillé : 1) planche de style, 2) héros, 3) ennemis, 4) boss ; pour chaque personnage : vues, actions de face, actions de dos. Prompt négatif : en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Brumes nation (Brumes biome).
NATION PALETTE: black, deep violet, mist mint green, silver. Signature effects: mint mist and violet spectral wisps.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale mint highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: two rows with the same 6 characters in the same order, all in idle pose. Top row: 3/4 front view, facing front-right. Bottom row: 3/4 back view, seen from behind, turned toward the upper right. All feet of a row on the same ground line. Leave a wide empty gap (at least half a character width) between characters and between the two rows: nobody overlaps or touches anyone, held items and capes included. Image aspect ratio 2:1, as large as possible.
CHARACTERS, left to right:
1. the hero (Invocateur: summoner with black hair, long black coat with violet trims and silver clasps, a spiked dark staff topped with a violet crystal in the right hand, a grimoire floating at his side).
2. Brumeux (hulking lavender mist beast with a fluffy cloud body and small glowing eyes).
3. Gargouille (grey stone gargoyle with bat wings and a long tail).
4. Liche des brumes (thin violet lich in tattered robes holding a crooked staff).
5. Fantôme (pale blue ghost with a wavy tail and a mischievous face).
6. the final boss Ombrelis le Brumeux (dark necromancer in black spiked armor with a violet tattered cloak, spiked crown, holding a skull-topped staff surrounded by mist), about 1.5x taller than the others.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Invocateur — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `invocateur_vues.png`, `invocateur_actions.png` et `invocateur_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE playable hero: Invocateur, carrying: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Invocateur (hero of the Brumes nation)
- Hair: black hair (#15151C), medium length, messy bangs
- Eyes: violet eyes (#9B6BFF), always open
- Skin: pale skin
- Top: long black coat with violet trims (#7A3FD0) and silver clasps
- Bottom: black trousers
- Feet: black boots with silver buckles
- Held item: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no mask, no white hair.
HELD ITEM: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale mint highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm. The spiked dark staff topped with a violet crystal is held in the right hand and fully visible in this cell.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the held item stays in its hand); the face is visible and the drawing must not be a copy of cell 1. The spiked dark staff topped with a violet crystal is held in the right hand and fully visible in this cell.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile. The spiked dark staff topped with a violet crystal is held in the right hand and fully visible in this cell.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the held item stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3. The spiked dark staff topped with a violet crystal is held in the right hand and fully visible in this cell.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Invocateur: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side; black hair (#15151C), medium length, messy bangs; violet eyes (#9B6BFF), always open; long black coat with violet trims (#7A3FD0) and silver clasps; pale skin; black trousers; black boots with silver buckles. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no mask, no white hair. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `invocateur.png` |
| 1-2 | repos de face, variante | `invocateur_idle_2.png` |
| 2-1 | repos de dos | `invocateur_back.png` |
| 2-2 | repos de dos, variante | `invocateur_back_idle_2.png` |

##### Version courte de la planche vues

À utiliser si le générateur reformule le prompt, bloque sur un mot ou ne respecte pas le nombre de cases : mêmes consignes, 1 000 caractères.

```text
Character sheet, exactly 4 sprites in a 2x2 grid, plain flat medium gray background, wide empty gaps, no overlap, no text, no frame. ONE playable hero: Invocateur. black hair (#15151C), medium length, messy bangs; violet eyes (#9B6BFF), always open; pale skin; long black coat with violet trims (#7A3FD0) and silver clasps; black trousers; black boots with silver buckles; spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side. It always holds the spiked dark staff topped with a violet crystal in the right hand, clearly visible in all 4 sprites. Top row: two front 3/4 views facing right, two slightly different relaxed stances (not mirrored). Bottom row: two views from behind, facing away toward the upper right, no face visible, two different stances. Same outfit, colors and size in all 4, feet on one line. Style: smooth hand-drawn vector cartoon, thick dark outlines, Dofus / Waven look, NOT pixel art. Never facing left. Forbidden: no hood, no mask, no white hair.
```

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE playable hero: Invocateur, carrying: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side.
SOURCE IMAGE: it shows this playable hero, Invocateur, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Invocateur (hero of the Brumes nation)
- Hair: black hair (#15151C), medium length, messy bangs
- Eyes: violet eyes (#9B6BFF), always open
- Skin: pale skin
- Top: long black coat with violet trims (#7A3FD0) and silver clasps
- Bottom: black trousers
- Feet: black boots with silver buckles
- Held item: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no mask, no white hair.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its held item in the correct hand — add the held item where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm. The spiked dark staff topped with a violet crystal is held in the right hand and fully visible in this cell.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the held item stays in its hand); the face is visible and the drawing must not be a copy of cell 1. The spiked dark staff topped with a violet crystal is held in the right hand and fully visible in this cell.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile. The spiked dark staff topped with a violet crystal is held in the right hand and fully visible in this cell.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the held item stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3. The spiked dark staff topped with a violet crystal is held in the right hand and fully visible in this cell.
HELD ITEM: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Invocateur: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side; black hair (#15151C), medium length, messy bangs; violet eyes (#9B6BFF), always open; long black coat with violet trims (#7A3FD0) and silver clasps; pale skin; black trousers; black boots with silver buckles. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no mask, no white hair. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE playable hero: Invocateur, carrying: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side.
SOURCE IMAGE: it shows this playable hero, Invocateur, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, held item in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Invocateur (hero of the Brumes nation)
- Hair: black hair (#15151C), medium length, messy bangs
- Eyes: violet eyes (#9B6BFF), always open
- Skin: pale skin
- Top: long black coat with violet trims (#7A3FD0) and silver clasps
- Bottom: black trousers
- Feet: black boots with silver buckles
- Held item: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no mask, no white hair.
HELD ITEM: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale mint highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head, grimoire floating behind — silhouette: tall and vertical, limbs raised above the head. The spiked dark staff topped with a violet crystal is held in the right hand and fully visible in this cell.
2. PALM BOLT: free arm stretched forward, a mint mist and violet spectral wisps bolt leaving the open palm — silhouette: wide and horizontal, body stretched far forward. The spiked dark staff topped with a violet crystal is held in the right hand and fully visible in this cell.
3. SIDE SWING: staff swept horizontally, coat swirling — silhouette: low and wide, crouched or twisted with a long side reach. The spiked dark staff topped with a violet crystal is held in the right hand and fully visible in this cell.
4. READING: grimoire floating open in front, pages turning, mint mist and violet spectral wisps rising from it — silhouette: compact and rounded, hands gathered near the chest. The spiked dark staff topped with a violet crystal is held in the right hand and fully visible in this cell.
5. SUMMONING CIRCLE: staff raised, a mint mist and violet spectral wisps circle drawn on the ground — silhouette: tall, both arms thrown up or spread wide. The spiked dark staff topped with a violet crystal is held in the right hand and fully visible in this cell.
6. WALK: mid-stride, one foot raised, arms swinging naturally, held item held — silhouette: mid-stride with legs clearly apart, moving forward. The spiked dark staff topped with a violet crystal is held in the right hand and fully visible in this cell.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Invocateur: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side; black hair (#15151C), medium length, messy bangs; violet eyes (#9B6BFF), always open; long black coat with violet trims (#7A3FD0) and silver clasps; pale skin; black trousers; black boots with silver buckles. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no mask, no white hair. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `invocateur_attack.png` |
| 1-2 | attaque 2 | `invocateur_attack_2.png` |
| 1-3 | attaque 3 | `invocateur_attack_3.png` |
| 2-1 | sort 1 | `invocateur_cast.png` |
| 2-2 | sort 2 | `invocateur_cast_2.png` |
| 2-3 | marche | `invocateur_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE playable hero: Invocateur, carrying: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side.
SOURCE IMAGE: it shows this playable hero, Invocateur, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, held item in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Invocateur (hero of the Brumes nation)
- Hair: black hair (#15151C), medium length, messy bangs
- Eyes: violet eyes (#9B6BFF), always open
- Skin: pale skin
- Top: long black coat with violet trims (#7A3FD0) and silver clasps
- Bottom: black trousers
- Feet: black boots with silver buckles
- Held item: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no mask, no white hair.
HELD ITEM: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale mint highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head, grimoire floating behind — silhouette: tall and vertical, limbs raised above the head. The spiked dark staff topped with a violet crystal is held in the right hand and fully visible in this cell.
2. PALM BOLT: free arm stretched forward, a mint mist and violet spectral wisps bolt leaving the open palm — silhouette: wide and horizontal, body stretched far forward. The spiked dark staff topped with a violet crystal is held in the right hand and fully visible in this cell.
3. SIDE SWING: staff swept horizontally, coat swirling — silhouette: low and wide, crouched or twisted with a long side reach. The spiked dark staff topped with a violet crystal is held in the right hand and fully visible in this cell.
4. READING: grimoire floating open in front, pages turning, mint mist and violet spectral wisps rising from it — silhouette: compact and rounded, hands gathered near the chest. The spiked dark staff topped with a violet crystal is held in the right hand and fully visible in this cell.
5. SUMMONING CIRCLE: staff raised, a mint mist and violet spectral wisps circle drawn on the ground — silhouette: tall, both arms thrown up or spread wide. The spiked dark staff topped with a violet crystal is held in the right hand and fully visible in this cell.
6. WALK: mid-stride, one foot raised, arms swinging naturally, held item held — silhouette: mid-stride with legs clearly apart, moving forward. The spiked dark staff topped with a violet crystal is held in the right hand and fully visible in this cell.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Invocateur: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side; black hair (#15151C), medium length, messy bangs; violet eyes (#9B6BFF), always open; long black coat with violet trims (#7A3FD0) and silver clasps; pale skin; black trousers; black boots with silver buckles. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no mask, no white hair. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `invocateur_back_attack.png` |
| 1-2 | attaque 2 — dos | `invocateur_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `invocateur_back_attack_3.png` |
| 2-1 | sort 1 — dos | `invocateur_back_cast.png` |
| 2-2 | sort 2 — dos | `invocateur_back_cast_2.png` |
| 2-3 | marche — dos | `invocateur_back_walk.png` |

L'export Zimut de l'Atelier copie aussi le repos (case 1 de la planche vues) vers `nations/heros/invocateur.png`.

## 3. Ennemis

### Brumeux — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brumes/` ; nomme tes images `brumeux_vues.png`, `brumeux_actions.png` et `brumeux_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Brumeux — an NO HELD ITEM creature (no held item of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Brumeux (enemy of the Brumes nation)
- Body: hulking mist beast with a fluffy lavender cloud body (#B8A8E0)
- Head: no visible neck, two small glowing mint eyes (#9FFFD8)
- Details: two thick cloud arms with small dark claws, no legs visible
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no held item, no clothes, no teeth.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 4 cells; it acts only with its own body (claws, fists, tail, magic). Never add an item.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale mint highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in every cell; it acts only with its own body (claws, fists, tail, magic). Never add an item.
REMINDER: this is Brumeux: hulking mist beast with a fluffy lavender cloud body (#B8A8E0); no visible neck, two small glowing mint eyes (#9FFFD8); two thick cloud arms with small dark claws, no legs visible. NO held item and no held object, ever. Forbidden: no held item, no clothes, no teeth. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `brumeux.png` |
| 1-2 | repos de face, variante | `brumeux_idle_2.png` |
| 2-1 | repos de dos | `brumeux_back.png` |
| 2-2 | repos de dos, variante | `brumeux_back_idle_2.png` |

##### Version courte de la planche vues

À utiliser si le générateur reformule le prompt, bloque sur un mot ou ne respecte pas le nombre de cases : mêmes consignes, 1 000 caractères.

```text
Character sheet, exactly 4 sprites in a 2x2 grid, plain flat white background, wide empty gaps, no overlap, no text, no frame. ONE enemy monster: Brumeux. hulking mist beast with a fluffy lavender cloud body (#B8A8E0); no visible neck, two small glowing mint eyes (#9FFFD8); two thick cloud arms with small dark claws, no legs visible. It holds nothing in its hands, paws or claws. Top row: two front 3/4 views facing right, two slightly different relaxed stances (not mirrored). Bottom row: two views from behind, facing away toward the upper right, no face visible, two different stances. Same outfit, colors and size in all 4, feet on one line. Style: smooth hand-drawn vector cartoon, thick dark outlines, Dofus / Waven look, NOT pixel art. Never facing left. Forbidden: no held item, no clothes, no teeth.
```

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Brumeux — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Brumeux, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Brumeux (enemy of the Brumes nation)
- Body: hulking mist beast with a fluffy lavender cloud body (#B8A8E0)
- Head: no visible neck, two small glowing mint eyes (#9FFFD8)
- Details: two thick cloud arms with small dark claws, no legs visible
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no held item, no clothes, no teeth.
TASK: REMOVE every held item, torch, tool or held object from the hands, claws or tail — this creature is item-free. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in every cell; it acts only with its own body (claws, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Brumeux: hulking mist beast with a fluffy lavender cloud body (#B8A8E0); no visible neck, two small glowing mint eyes (#9FFFD8); two thick cloud arms with small dark claws, no legs visible. NO held item and no held object, ever. Forbidden: no held item, no clothes, no teeth. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Brumeux — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Brumeux, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Brumeux (enemy of the Brumes nation)
- Body: hulking mist beast with a fluffy lavender cloud body (#B8A8E0)
- Head: no visible neck, two small glowing mint eyes (#9FFFD8)
- Details: two thick cloud arms with small dark claws, no legs visible
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no held item, no clothes, no teeth.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 6 poses; it acts only with its own body (claws, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale mint highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised — silhouette: tall and vertical, limbs raised above the head.
2. LUNGE: body stretched forward, claws of mint mist and violet spectral wisps reaching out — silhouette: wide and horizontal, body stretched far forward.
3. SPIN: body whirling, mint mist and violet spectral wisps trail around it — silhouette: low and wide, crouched or twisted with a long side reach.
4. HOVER: floating higher, mint mist and violet spectral wisps orbs circling — silhouette: compact and rounded, hands gathered near the chest.
5. PULSE: arms spread, mint mist and violet spectral wisps pulsing outward — silhouette: tall, both arms thrown up or spread wide.
6. DRIFT: floating forward with the body tilted slightly ahead, a short trail behind — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Brumeux: hulking mist beast with a fluffy lavender cloud body (#B8A8E0); no visible neck, two small glowing mint eyes (#9FFFD8); two thick cloud arms with small dark claws, no legs visible. NO held item and no held object, ever. Forbidden: no held item, no clothes, no teeth. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `brumeux_attack.png` |
| 1-2 | attaque 2 | `brumeux_attack_2.png` |
| 1-3 | attaque 3 | `brumeux_attack_3.png` |
| 2-1 | sort 1 | `brumeux_cast.png` |
| 2-2 | sort 2 | `brumeux_cast_2.png` |
| 2-3 | marche | `brumeux_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Brumeux — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Brumeux, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Brumeux (enemy of the Brumes nation)
- Body: hulking mist beast with a fluffy lavender cloud body (#B8A8E0)
- Head: no visible neck, two small glowing mint eyes (#9FFFD8)
- Details: two thick cloud arms with small dark claws, no legs visible
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no held item, no clothes, no teeth.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 6 poses; it acts only with its own body (claws, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale mint highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised — silhouette: tall and vertical, limbs raised above the head.
2. LUNGE: body stretched forward, claws of mint mist and violet spectral wisps reaching out — silhouette: wide and horizontal, body stretched far forward.
3. SPIN: body whirling, mint mist and violet spectral wisps trail around it — silhouette: low and wide, crouched or twisted with a long side reach.
4. HOVER: floating higher, mint mist and violet spectral wisps orbs circling — silhouette: compact and rounded, hands gathered near the chest.
5. PULSE: arms spread, mint mist and violet spectral wisps pulsing outward — silhouette: tall, both arms thrown up or spread wide.
6. DRIFT: floating forward with the body tilted slightly ahead, a short trail behind — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Brumeux: hulking mist beast with a fluffy lavender cloud body (#B8A8E0); no visible neck, two small glowing mint eyes (#9FFFD8); two thick cloud arms with small dark claws, no legs visible. NO held item and no held object, ever. Forbidden: no held item, no clothes, no teeth. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `brumeux_back_attack.png` |
| 1-2 | attaque 2 — dos | `brumeux_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `brumeux_back_attack_3.png` |
| 2-1 | sort 1 — dos | `brumeux_back_cast.png` |
| 2-2 | sort 2 — dos | `brumeux_back_cast_2.png` |
| 2-3 | marche — dos | `brumeux_back_walk.png` |

### Gargouille — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brumes/` ; nomme tes images `gargouille_vues.png`, `gargouille_actions.png` et `gargouille_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Gargouille — an NO HELD ITEM creature (no held item of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Gargouille (enemy of the Brumes nation)
- Body: grey stone gargoyle (#7A7A82) crouching on two legs, cracked stone texture
- Head: small horns, pointed ears, fanged mouth, glowing mint eyes (#9FFFD8)
- Details: stone bat wings, long tail with an arrow tip
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no held item, no color other than grey stone and mint eyes.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 4 cells; it acts only with its own body (claws, fists, tail, magic). Never add an item.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale mint highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in every cell; it acts only with its own body (claws, fists, tail, magic). Never add an item.
REMINDER: this is Gargouille: grey stone gargoyle (#7A7A82) crouching on two legs, cracked stone texture; small horns, pointed ears, fanged mouth, glowing mint eyes (#9FFFD8); stone bat wings, long tail with an arrow tip. NO held item and no held object, ever. Forbidden: no held item, no color other than grey stone and mint eyes. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `gargouille.png` |
| 1-2 | repos de face, variante | `gargouille_idle_2.png` |
| 2-1 | repos de dos | `gargouille_back.png` |
| 2-2 | repos de dos, variante | `gargouille_back_idle_2.png` |

##### Version courte de la planche vues

À utiliser si le générateur reformule le prompt, bloque sur un mot ou ne respecte pas le nombre de cases : mêmes consignes, 1 000 caractères.

```text
Character sheet, exactly 4 sprites in a 2x2 grid, plain flat white background, wide empty gaps, no overlap, no text, no frame. ONE enemy monster: Gargouille. grey stone gargoyle (#7A7A82) crouching on two legs, cracked stone texture; small horns, pointed ears, fanged mouth, glowing mint eyes (#9FFFD8); stone bat wings, long tail with an arrow tip. It holds nothing in its hands, paws or claws. Top row: two front 3/4 views facing right, two slightly different relaxed stances (not mirrored). Bottom row: two views from behind, facing away toward the upper right, no face visible, two different stances. Same outfit, colors and size in all 4, feet on one line. Style: smooth hand-drawn vector cartoon, thick dark outlines, Dofus / Waven look, NOT pixel art. Never facing left. Forbidden: no held item, no color other than grey stone and mint eyes.
```

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Gargouille — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Gargouille, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Gargouille (enemy of the Brumes nation)
- Body: grey stone gargoyle (#7A7A82) crouching on two legs, cracked stone texture
- Head: small horns, pointed ears, fanged mouth, glowing mint eyes (#9FFFD8)
- Details: stone bat wings, long tail with an arrow tip
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no held item, no color other than grey stone and mint eyes.
TASK: REMOVE every held item, torch, tool or held object from the hands, claws or tail — this creature is item-free. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in every cell; it acts only with its own body (claws, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Gargouille: grey stone gargoyle (#7A7A82) crouching on two legs, cracked stone texture; small horns, pointed ears, fanged mouth, glowing mint eyes (#9FFFD8); stone bat wings, long tail with an arrow tip. NO held item and no held object, ever. Forbidden: no held item, no color other than grey stone and mint eyes. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Gargouille — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Gargouille, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Gargouille (enemy of the Brumes nation)
- Body: grey stone gargoyle (#7A7A82) crouching on two legs, cracked stone texture
- Head: small horns, pointed ears, fanged mouth, glowing mint eyes (#9FFFD8)
- Details: stone bat wings, long tail with an arrow tip
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no held item, no color other than grey stone and mint eyes.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 6 poses; it acts only with its own body (claws, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale mint highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high — silhouette: tall and vertical, limbs raised above the head.
2. POUNCE: body stretched forward in the air, jaws open — silhouette: wide and horizontal, body stretched far forward.
3. SIDE SWIPE: head and claws swept to the side, body twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. HOWL: head raised to the sky, mint mist and violet spectral wisps gathering around the body — silhouette: compact and rounded, hands gathered near the chest.
5. ROAR: mouth wide open, mint mist and violet spectral wisps burst in front of the head — silhouette: tall, both arms thrown up or spread wide.
6. WALK: mid-stride, one front paw raised, body moving forward — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Gargouille: grey stone gargoyle (#7A7A82) crouching on two legs, cracked stone texture; small horns, pointed ears, fanged mouth, glowing mint eyes (#9FFFD8); stone bat wings, long tail with an arrow tip. NO held item and no held object, ever. Forbidden: no held item, no color other than grey stone and mint eyes. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `gargouille_attack.png` |
| 1-2 | attaque 2 | `gargouille_attack_2.png` |
| 1-3 | attaque 3 | `gargouille_attack_3.png` |
| 2-1 | sort 1 | `gargouille_cast.png` |
| 2-2 | sort 2 | `gargouille_cast_2.png` |
| 2-3 | marche | `gargouille_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Gargouille — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Gargouille, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Gargouille (enemy of the Brumes nation)
- Body: grey stone gargoyle (#7A7A82) crouching on two legs, cracked stone texture
- Head: small horns, pointed ears, fanged mouth, glowing mint eyes (#9FFFD8)
- Details: stone bat wings, long tail with an arrow tip
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no held item, no color other than grey stone and mint eyes.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 6 poses; it acts only with its own body (claws, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale mint highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high — silhouette: tall and vertical, limbs raised above the head.
2. POUNCE: body stretched forward in the air, jaws open — silhouette: wide and horizontal, body stretched far forward.
3. SIDE SWIPE: head and claws swept to the side, body twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. HOWL: head raised to the sky, mint mist and violet spectral wisps gathering around the body — silhouette: compact and rounded, hands gathered near the chest.
5. ROAR: mouth wide open, mint mist and violet spectral wisps burst in front of the head — silhouette: tall, both arms thrown up or spread wide.
6. WALK: mid-stride, one front paw raised, body moving forward — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Gargouille: grey stone gargoyle (#7A7A82) crouching on two legs, cracked stone texture; small horns, pointed ears, fanged mouth, glowing mint eyes (#9FFFD8); stone bat wings, long tail with an arrow tip. NO held item and no held object, ever. Forbidden: no held item, no color other than grey stone and mint eyes. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `gargouille_back_attack.png` |
| 1-2 | attaque 2 — dos | `gargouille_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `gargouille_back_attack_3.png` |
| 2-1 | sort 1 — dos | `gargouille_back_cast.png` |
| 2-2 | sort 2 — dos | `gargouille_back_cast_2.png` |
| 2-3 | marche — dos | `gargouille_back_walk.png` |

### Liche des brumes — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brumes/` ; nomme tes images `liche_des_brumes_vues.png`, `liche_des_brumes_actions.png` et `liche_des_brumes_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Liche des brumes, carrying: crooked wooden staff, RIGHT hand.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Liche des brumes (enemy of the Brumes nation)
- Body: thin skeletal lich, bony grey hands
- Head: skull face with glowing mint eyes (#9FFFD8) under a tattered hood
- Top: tattered violet robes (#6A4A9A) with torn edges
- Held item: crooked wooden staff, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no crown, no armor, no hair.
HELD ITEM: crooked wooden staff, RIGHT hand. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale mint highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm. The crooked wooden staff is held in the right hand and fully visible in this cell.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the held item stays in its hand); the face is visible and the drawing must not be a copy of cell 1. The crooked wooden staff is held in the right hand and fully visible in this cell.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile. The crooked wooden staff is held in the right hand and fully visible in this cell.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the held item stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3. The crooked wooden staff is held in the right hand and fully visible in this cell.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: crooked wooden staff, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Liche des brumes: crooked wooden staff, RIGHT hand; tattered violet robes (#6A4A9A) with torn edges; thin skeletal lich, bony grey hands; skull face with glowing mint eyes (#9FFFD8) under a tattered hood. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no crown, no armor, no hair. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `liche_des_brumes.png` |
| 1-2 | repos de face, variante | `liche_des_brumes_idle_2.png` |
| 2-1 | repos de dos | `liche_des_brumes_back.png` |
| 2-2 | repos de dos, variante | `liche_des_brumes_back_idle_2.png` |

##### Version courte de la planche vues

À utiliser si le générateur reformule le prompt, bloque sur un mot ou ne respecte pas le nombre de cases : mêmes consignes, 1 000 caractères.

```text
Character sheet, exactly 4 sprites in a 2x2 grid, plain flat white background, wide empty gaps, no overlap, no text, no frame. ONE enemy monster: Liche des brumes. thin skeletal lich, bony grey hands; skull face with glowing mint eyes (#9FFFD8) under a tattered hood; tattered violet robes (#6A4A9A) with torn edges; crooked wooden staff, RIGHT hand. It always holds the crooked wooden staff in the right hand, clearly visible in all 4 sprites. Top row: two front 3/4 views facing right, two slightly different relaxed stances (not mirrored). Bottom row: two views from behind, facing away toward the upper right, no face visible, two different stances. Same outfit, colors and size in all 4, feet on one line. Style: smooth hand-drawn vector cartoon, thick dark outlines, Dofus / Waven look, NOT pixel art. Never facing left. Forbidden: no crown, no armor, no hair.
```

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Liche des brumes, carrying: crooked wooden staff, RIGHT hand.
SOURCE IMAGE: it shows this enemy monster, Liche des brumes, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Liche des brumes (enemy of the Brumes nation)
- Body: thin skeletal lich, bony grey hands
- Head: skull face with glowing mint eyes (#9FFFD8) under a tattered hood
- Top: tattered violet robes (#6A4A9A) with torn edges
- Held item: crooked wooden staff, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no crown, no armor, no hair.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its held item in the correct hand — add the held item where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm. The crooked wooden staff is held in the right hand and fully visible in this cell.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the held item stays in its hand); the face is visible and the drawing must not be a copy of cell 1. The crooked wooden staff is held in the right hand and fully visible in this cell.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile. The crooked wooden staff is held in the right hand and fully visible in this cell.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the held item stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3. The crooked wooden staff is held in the right hand and fully visible in this cell.
HELD ITEM: crooked wooden staff, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Liche des brumes: crooked wooden staff, RIGHT hand; tattered violet robes (#6A4A9A) with torn edges; thin skeletal lich, bony grey hands; skull face with glowing mint eyes (#9FFFD8) under a tattered hood. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no crown, no armor, no hair. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Liche des brumes, carrying: crooked wooden staff, RIGHT hand.
SOURCE IMAGE: it shows this enemy monster, Liche des brumes, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, held item in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Liche des brumes (enemy of the Brumes nation)
- Body: thin skeletal lich, bony grey hands
- Head: skull face with glowing mint eyes (#9FFFD8) under a tattered hood
- Top: tattered violet robes (#6A4A9A) with torn edges
- Held item: crooked wooden staff, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no crown, no armor, no hair.
HELD ITEM: crooked wooden staff, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale mint highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands — silhouette: tall and vertical, limbs raised above the head. The crooked wooden staff is held in the right hand and fully visible in this cell.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short mint mist and violet spectral wisps spark — silhouette: wide and horizontal, body stretched far forward. The crooked wooden staff is held in the right hand and fully visible in this cell.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach. The crooked wooden staff is held in the right hand and fully visible in this cell.
4. FOCUS: eyes closed, staff held vertically in front of the face, mint mist and violet spectral wisps orb at the top — silhouette: compact and rounded, hands gathered near the chest. The crooked wooden staff is held in the right hand and fully visible in this cell.
5. INVOCATION: staff raised high with both hands, mint mist and violet spectral wisps swirling above the head — silhouette: tall, both arms thrown up or spread wide. The crooked wooden staff is held in the right hand and fully visible in this cell.
6. WALK: mid-stride, one foot raised, arms swinging naturally, held item held — silhouette: mid-stride with legs clearly apart, moving forward. The crooked wooden staff is held in the right hand and fully visible in this cell.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: crooked wooden staff, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Liche des brumes: crooked wooden staff, RIGHT hand; tattered violet robes (#6A4A9A) with torn edges; thin skeletal lich, bony grey hands; skull face with glowing mint eyes (#9FFFD8) under a tattered hood. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no crown, no armor, no hair. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `liche_des_brumes_attack.png` |
| 1-2 | attaque 2 | `liche_des_brumes_attack_2.png` |
| 1-3 | attaque 3 | `liche_des_brumes_attack_3.png` |
| 2-1 | sort 1 | `liche_des_brumes_cast.png` |
| 2-2 | sort 2 | `liche_des_brumes_cast_2.png` |
| 2-3 | marche | `liche_des_brumes_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Liche des brumes, carrying: crooked wooden staff, RIGHT hand.
SOURCE IMAGE: it shows this enemy monster, Liche des brumes, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, held item in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Liche des brumes (enemy of the Brumes nation)
- Body: thin skeletal lich, bony grey hands
- Head: skull face with glowing mint eyes (#9FFFD8) under a tattered hood
- Top: tattered violet robes (#6A4A9A) with torn edges
- Held item: crooked wooden staff, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no crown, no armor, no hair.
HELD ITEM: crooked wooden staff, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale mint highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands — silhouette: tall and vertical, limbs raised above the head. The crooked wooden staff is held in the right hand and fully visible in this cell.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short mint mist and violet spectral wisps spark — silhouette: wide and horizontal, body stretched far forward. The crooked wooden staff is held in the right hand and fully visible in this cell.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach. The crooked wooden staff is held in the right hand and fully visible in this cell.
4. FOCUS: eyes closed, staff held vertically in front of the face, mint mist and violet spectral wisps orb at the top — silhouette: compact and rounded, hands gathered near the chest. The crooked wooden staff is held in the right hand and fully visible in this cell.
5. INVOCATION: staff raised high with both hands, mint mist and violet spectral wisps swirling above the head — silhouette: tall, both arms thrown up or spread wide. The crooked wooden staff is held in the right hand and fully visible in this cell.
6. WALK: mid-stride, one foot raised, arms swinging naturally, held item held — silhouette: mid-stride with legs clearly apart, moving forward. The crooked wooden staff is held in the right hand and fully visible in this cell.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: crooked wooden staff, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Liche des brumes: crooked wooden staff, RIGHT hand; tattered violet robes (#6A4A9A) with torn edges; thin skeletal lich, bony grey hands; skull face with glowing mint eyes (#9FFFD8) under a tattered hood. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no crown, no armor, no hair. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `liche_des_brumes_back_attack.png` |
| 1-2 | attaque 2 — dos | `liche_des_brumes_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `liche_des_brumes_back_attack_3.png` |
| 2-1 | sort 1 — dos | `liche_des_brumes_back_cast.png` |
| 2-2 | sort 2 — dos | `liche_des_brumes_back_cast_2.png` |
| 2-3 | marche — dos | `liche_des_brumes_back_walk.png` |

### Fantôme — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brumes/` ; nomme tes images `fantome_vues.png`, `fantome_actions.png` et `fantome_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Fantôme — an NO HELD ITEM creature (no held item of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Fantôme (enemy of the Brumes nation)
- Body: pale blue ghost (#BFE3FF) with a round head-body and a wavy tail, no legs
- Head: mischievous face: big dark eyes, tongue out
- Details: two small rounded arms
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no sheet with holes, no chains, no held item.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 4 cells; it acts only with its own body (claws, fists, tail, magic). Never add an item.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale mint highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in every cell; it acts only with its own body (claws, fists, tail, magic). Never add an item.
REMINDER: this is Fantôme: pale blue ghost (#BFE3FF) with a round head-body and a wavy tail, no legs; mischievous face: big dark eyes, tongue out; two small rounded arms. NO held item and no held object, ever. Forbidden: no sheet with holes, no chains, no held item. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `fantome.png` |
| 1-2 | repos de face, variante | `fantome_idle_2.png` |
| 2-1 | repos de dos | `fantome_back.png` |
| 2-2 | repos de dos, variante | `fantome_back_idle_2.png` |

##### Version courte de la planche vues

À utiliser si le générateur reformule le prompt, bloque sur un mot ou ne respecte pas le nombre de cases : mêmes consignes, 1 000 caractères.

```text
Character sheet, exactly 4 sprites in a 2x2 grid, plain flat medium gray background, wide empty gaps, no overlap, no text, no frame. ONE enemy monster: Fantôme. pale blue ghost (#BFE3FF) with a round head-body and a wavy tail, no legs; mischievous face: big dark eyes, tongue out; two small rounded arms. It holds nothing in its hands, paws or claws. Top row: two front 3/4 views facing right, two slightly different relaxed stances (not mirrored). Bottom row: two views from behind, facing away toward the upper right, no face visible, two different stances. Same outfit, colors and size in all 4, feet on one line. Style: smooth hand-drawn vector cartoon, thick dark outlines, Dofus / Waven look, NOT pixel art. Never facing left. Forbidden: no sheet with holes, no chains, no held item.
```

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Fantôme — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Fantôme, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Fantôme (enemy of the Brumes nation)
- Body: pale blue ghost (#BFE3FF) with a round head-body and a wavy tail, no legs
- Head: mischievous face: big dark eyes, tongue out
- Details: two small rounded arms
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no sheet with holes, no chains, no held item.
TASK: REMOVE every held item, torch, tool or held object from the hands, claws or tail — this creature is item-free. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in every cell; it acts only with its own body (claws, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Fantôme: pale blue ghost (#BFE3FF) with a round head-body and a wavy tail, no legs; mischievous face: big dark eyes, tongue out; two small rounded arms. NO held item and no held object, ever. Forbidden: no sheet with holes, no chains, no held item. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Fantôme — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Fantôme, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Fantôme (enemy of the Brumes nation)
- Body: pale blue ghost (#BFE3FF) with a round head-body and a wavy tail, no legs
- Head: mischievous face: big dark eyes, tongue out
- Details: two small rounded arms
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no sheet with holes, no chains, no held item.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 6 poses; it acts only with its own body (claws, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale mint highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised — silhouette: tall and vertical, limbs raised above the head.
2. LUNGE: body stretched forward, claws of mint mist and violet spectral wisps reaching out — silhouette: wide and horizontal, body stretched far forward.
3. SPIN: body whirling, mint mist and violet spectral wisps trail around it — silhouette: low and wide, crouched or twisted with a long side reach.
4. HOVER: floating higher, mint mist and violet spectral wisps orbs circling — silhouette: compact and rounded, hands gathered near the chest.
5. PULSE: arms spread, mint mist and violet spectral wisps pulsing outward — silhouette: tall, both arms thrown up or spread wide.
6. DRIFT: floating forward with the body tilted slightly ahead, a short trail behind — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Fantôme: pale blue ghost (#BFE3FF) with a round head-body and a wavy tail, no legs; mischievous face: big dark eyes, tongue out; two small rounded arms. NO held item and no held object, ever. Forbidden: no sheet with holes, no chains, no held item. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `fantome_attack.png` |
| 1-2 | attaque 2 | `fantome_attack_2.png` |
| 1-3 | attaque 3 | `fantome_attack_3.png` |
| 2-1 | sort 1 | `fantome_cast.png` |
| 2-2 | sort 2 | `fantome_cast_2.png` |
| 2-3 | marche | `fantome_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Fantôme — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Fantôme, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Fantôme (enemy of the Brumes nation)
- Body: pale blue ghost (#BFE3FF) with a round head-body and a wavy tail, no legs
- Head: mischievous face: big dark eyes, tongue out
- Details: two small rounded arms
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no sheet with holes, no chains, no held item.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 6 poses; it acts only with its own body (claws, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale mint highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised — silhouette: tall and vertical, limbs raised above the head.
2. LUNGE: body stretched forward, claws of mint mist and violet spectral wisps reaching out — silhouette: wide and horizontal, body stretched far forward.
3. SPIN: body whirling, mint mist and violet spectral wisps trail around it — silhouette: low and wide, crouched or twisted with a long side reach.
4. HOVER: floating higher, mint mist and violet spectral wisps orbs circling — silhouette: compact and rounded, hands gathered near the chest.
5. PULSE: arms spread, mint mist and violet spectral wisps pulsing outward — silhouette: tall, both arms thrown up or spread wide.
6. DRIFT: floating forward with the body tilted slightly ahead, a short trail behind — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Fantôme: pale blue ghost (#BFE3FF) with a round head-body and a wavy tail, no legs; mischievous face: big dark eyes, tongue out; two small rounded arms. NO held item and no held object, ever. Forbidden: no sheet with holes, no chains, no held item. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `fantome_back_attack.png` |
| 1-2 | attaque 2 — dos | `fantome_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `fantome_back_attack_3.png` |
| 2-1 | sort 1 — dos | `fantome_back_cast.png` |
| 2-2 | sort 2 — dos | `fantome_back_cast_2.png` |
| 2-3 | marche — dos | `fantome_back_walk.png` |

## 4. Boss

### Ombrelis le Brumeux — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `brumes_vues.png`, `brumes_actions.png` et `brumes_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE final boss: Ombrelis le Brumeux, carrying: skull-topped staff surrounded by mint mist, RIGHT hand.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombrelis le Brumeux (boss of the Brumes nation)
- Body: dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A)
- Head: spiked crown, gaunt pale face, glowing mint eyes
- Held item: skull-topped staff surrounded by mint mist, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no sword.
HELD ITEM: skull-topped staff surrounded by mint mist, RIGHT hand. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale mint highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm. The skull-topped staff surrounded by mint mist is held in the right hand and fully visible in this cell.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the held item stays in its hand); the face is visible and the drawing must not be a copy of cell 1. The skull-topped staff surrounded by mint mist is held in the right hand and fully visible in this cell.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile. The skull-topped staff surrounded by mint mist is held in the right hand and fully visible in this cell.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the held item stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3. The skull-topped staff surrounded by mint mist is held in the right hand and fully visible in this cell.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: skull-topped staff surrounded by mint mist, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Ombrelis le Brumeux: skull-topped staff surrounded by mint mist, RIGHT hand; dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A); spiked crown, gaunt pale face, glowing mint eyes. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no sword. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `brumes.png` |
| 1-2 | repos de face, variante | `brumes_idle_2.png` |
| 2-1 | repos de dos | `brumes_back.png` |
| 2-2 | repos de dos, variante | `brumes_back_idle_2.png` |

##### Version courte de la planche vues

À utiliser si le générateur reformule le prompt, bloque sur un mot ou ne respecte pas le nombre de cases : mêmes consignes, 1 000 caractères.

```text
Character sheet, exactly 4 sprites in a 2x2 grid, plain flat white background, wide empty gaps, no overlap, no text, no frame. ONE final boss: Ombrelis le Brumeux. dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A); spiked crown, gaunt pale face, glowing mint eyes; skull-topped staff surrounded by mint mist, RIGHT hand. It always holds the skull-topped staff surrounded by mint mist in the right hand, clearly visible in all 4 sprites. Top row: two front 3/4 views facing right, two slightly different relaxed stances (not mirrored). Bottom row: two views from behind, facing away toward the upper right, no face visible, two different stances. Same outfit, colors and size in all 4, feet on one line. Style: smooth hand-drawn vector cartoon, thick dark outlines, Dofus / Waven look, NOT pixel art. Never facing left. Forbidden: no hood, no sword.
```

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE final boss: Ombrelis le Brumeux, carrying: skull-topped staff surrounded by mint mist, RIGHT hand.
SOURCE IMAGE: it shows this final boss, Ombrelis le Brumeux, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombrelis le Brumeux (boss of the Brumes nation)
- Body: dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A)
- Head: spiked crown, gaunt pale face, glowing mint eyes
- Held item: skull-topped staff surrounded by mint mist, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no sword.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its held item in the correct hand — add the held item where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm. The skull-topped staff surrounded by mint mist is held in the right hand and fully visible in this cell.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the held item stays in its hand); the face is visible and the drawing must not be a copy of cell 1. The skull-topped staff surrounded by mint mist is held in the right hand and fully visible in this cell.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile. The skull-topped staff surrounded by mint mist is held in the right hand and fully visible in this cell.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the held item stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3. The skull-topped staff surrounded by mint mist is held in the right hand and fully visible in this cell.
HELD ITEM: skull-topped staff surrounded by mint mist, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Ombrelis le Brumeux: skull-topped staff surrounded by mint mist, RIGHT hand; dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A); spiked crown, gaunt pale face, glowing mint eyes. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no sword. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE final boss: Ombrelis le Brumeux, carrying: skull-topped staff surrounded by mint mist, RIGHT hand.
SOURCE IMAGE: it shows this final boss, Ombrelis le Brumeux, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, held item in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombrelis le Brumeux (boss of the Brumes nation)
- Body: dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A)
- Head: spiked crown, gaunt pale face, glowing mint eyes
- Held item: skull-topped staff surrounded by mint mist, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no sword.
HELD ITEM: skull-topped staff surrounded by mint mist, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale mint highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head, grimoire floating behind — silhouette: tall and vertical, limbs raised above the head. The skull-topped staff surrounded by mint mist is held in the right hand and fully visible in this cell.
2. PALM BOLT: free arm stretched forward, a mint mist and violet spectral wisps bolt leaving the open palm — silhouette: wide and horizontal, body stretched far forward. The skull-topped staff surrounded by mint mist is held in the right hand and fully visible in this cell.
3. SIDE SWING: staff swept horizontally, coat swirling — silhouette: low and wide, crouched or twisted with a long side reach. The skull-topped staff surrounded by mint mist is held in the right hand and fully visible in this cell.
4. READING: grimoire floating open in front, pages turning, mint mist and violet spectral wisps rising from it — silhouette: compact and rounded, hands gathered near the chest. The skull-topped staff surrounded by mint mist is held in the right hand and fully visible in this cell.
5. SUMMONING CIRCLE: staff raised, a mint mist and violet spectral wisps circle drawn on the ground — silhouette: tall, both arms thrown up or spread wide. The skull-topped staff surrounded by mint mist is held in the right hand and fully visible in this cell.
6. WALK: mid-stride, one foot raised, arms swinging naturally, held item held — silhouette: mid-stride with legs clearly apart, moving forward. The skull-topped staff surrounded by mint mist is held in the right hand and fully visible in this cell.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: skull-topped staff surrounded by mint mist, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Ombrelis le Brumeux: skull-topped staff surrounded by mint mist, RIGHT hand; dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A); spiked crown, gaunt pale face, glowing mint eyes. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no sword. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `brumes_attack.png` |
| 1-2 | attaque 2 | `brumes_attack_2.png` |
| 1-3 | attaque 3 | `brumes_attack_3.png` |
| 2-1 | sort 1 | `brumes_cast.png` |
| 2-2 | sort 2 | `brumes_cast_2.png` |
| 2-3 | marche | `brumes_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE final boss: Ombrelis le Brumeux, carrying: skull-topped staff surrounded by mint mist, RIGHT hand.
SOURCE IMAGE: it shows this final boss, Ombrelis le Brumeux, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, held item in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombrelis le Brumeux (boss of the Brumes nation)
- Body: dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A)
- Head: spiked crown, gaunt pale face, glowing mint eyes
- Held item: skull-topped staff surrounded by mint mist, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no sword.
HELD ITEM: skull-topped staff surrounded by mint mist, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale mint highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head, grimoire floating behind — silhouette: tall and vertical, limbs raised above the head. The skull-topped staff surrounded by mint mist is held in the right hand and fully visible in this cell.
2. PALM BOLT: free arm stretched forward, a mint mist and violet spectral wisps bolt leaving the open palm — silhouette: wide and horizontal, body stretched far forward. The skull-topped staff surrounded by mint mist is held in the right hand and fully visible in this cell.
3. SIDE SWING: staff swept horizontally, coat swirling — silhouette: low and wide, crouched or twisted with a long side reach. The skull-topped staff surrounded by mint mist is held in the right hand and fully visible in this cell.
4. READING: grimoire floating open in front, pages turning, mint mist and violet spectral wisps rising from it — silhouette: compact and rounded, hands gathered near the chest. The skull-topped staff surrounded by mint mist is held in the right hand and fully visible in this cell.
5. SUMMONING CIRCLE: staff raised, a mint mist and violet spectral wisps circle drawn on the ground — silhouette: tall, both arms thrown up or spread wide. The skull-topped staff surrounded by mint mist is held in the right hand and fully visible in this cell.
6. WALK: mid-stride, one foot raised, arms swinging naturally, held item held — silhouette: mid-stride with legs clearly apart, moving forward. The skull-topped staff surrounded by mint mist is held in the right hand and fully visible in this cell.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: skull-topped staff surrounded by mint mist, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Ombrelis le Brumeux: skull-topped staff surrounded by mint mist, RIGHT hand; dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A); spiked crown, gaunt pale face, glowing mint eyes. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no sword. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `brumes_back_attack.png` |
| 1-2 | attaque 2 — dos | `brumes_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `brumes_back_attack_3.png` |
| 2-1 | sort 1 — dos | `brumes_back_cast.png` |
| 2-2 | sort 2 — dos | `brumes_back_cast_2.png` |
| 2-3 | marche — dos | `brumes_back_walk.png` |

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
