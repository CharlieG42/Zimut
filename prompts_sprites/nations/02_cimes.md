# Nation Cimes (Montagne)

Palette : steel blue, dark iron, snow white fur, ice cyan crystals. Effets : ice shards and snow bursts. Contre-jour : cold icy blue.

Format 3 planches par personnage (V44) :

1. **Vues** — 4 cases : repos de FACE ×2 (deux attitudes différentes) puis repos de DOS ×2, tout orienté vers la droite (le jeu retourne l'image pour la gauche). Grille 2 × 2 sur image 2:1, poses largement espacées. Génération normale.
2. **Actions de face** — 3 attaques + 2 sorts + 1 marche (3 colonnes × 2 rangées), en **édition** de la planche vues : le personnage réellement dessiné sert d'ancre.
3. **Actions de dos** — les mêmes 6 poses vues de dos, en édition de la planche vues. Une planche = un seul sens de vue (face et dos mélangés sur une même planche étaient dessinés de face). Facultative pour les monstres.

Les personnages **armés** ont l'arme écrite dans la première phrase, dans la carte d'identité, en fin de prompt et dans chaque pose ; les **créatures** reçoivent « UNARMED » (plus de torche inventée). Chaque prompt recopie la carte d'identité (`identites.py`) : aucune image à joindre. Ordre conseillé : 1) planche de style, 2) héros, 3) ennemis, 4) boss ; pour chaque personnage : vues, actions de face, actions de dos. Prompt négatif : en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Cimes nation (Montagne biome).
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals. Signature effects: ice shards and snow bursts.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle cold icy blue highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: two rows with the same 6 characters in the same order, all in idle pose. Top row: 3/4 front view, facing front-right. Bottom row: 3/4 back view, seen from behind, turned toward the upper right. All feet of a row on the same ground line. Leave a wide empty gap (at least half a character width) between characters and between the two rows: nobody overlaps or touches anyone, weapons and capes included. Image aspect ratio 2:1, as large as possible.
CHARACTERS, left to right:
1. the hero (Tank: stout veteran warrior with a big white beard and white hair, heavy dark steel-blue plate armor with white fur trim and ice-blue crystal inlays, a large round shield with a cloud and mountain emblem on the left arm, a rune-engraved war hammer in the right hand).
2. Guerrier des monts (mountain warrior with rocky brown skin, stocky body, crude stone gauntlets).
3. Griffon des cimes (griffin with a white eagle head, blue-grey feathered wings and a lion body).
4. Garde des pics (peak guardian golem of blue-grey stone with glowing ice-blue crystals on the shoulders).
5. Rochebrute (hulking brute made of brown boulders, small glowing eyes, huge fists).
6. the final boss Vorkann le Givre (massive frost knight in dark steel armor covered with ice crystals and snow fur, crowned helm of ice spikes, huge crystal-studded tower shield and a heavy rune hammer), about 1.5x taller than the others.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Tank — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `tank_vues.png`, `tank_actions.png` et `tank_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE playable hero: Tank, armed with: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
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
WEAPON: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle cold icy blue highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Tank: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm; white hair combed back and a big full white beard; steel-blue eyes (#4A7FB0), thick white eyebrows, always open; heavy dark steel-blue plate armor (#3A4E6E) with white fur trim on the shoulders and small ice-blue crystal inlays (#9FE3FF); tanned skin; steel-blue armored tassets over dark grey trousers; heavy steel boots. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no cape, no sword, no brown beard. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `tank.png` |
| 1-2 | repos de face, variante | `tank_idle_2.png` |
| 2-1 | repos de dos | `tank_back.png` |
| 2-2 | repos de dos, variante | `tank_back_idle_2.png` |

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE playable hero: Tank, armed with: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm.
SOURCE IMAGE: it shows this playable hero, Tank, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
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
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
WEAPON: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Tank: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm; white hair combed back and a big full white beard; steel-blue eyes (#4A7FB0), thick white eyebrows, always open; heavy dark steel-blue plate armor (#3A4E6E) with white fur trim on the shoulders and small ice-blue crystal inlays (#9FE3FF); tanned skin; steel-blue armored tassets over dark grey trousers; heavy steel boots. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no cape, no sword, no brown beard. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE playable hero: Tank, armed with: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm.
SOURCE IMAGE: it shows this playable hero, Tank, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
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
WEAPON: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle cold icy blue highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: hammer raised high above the head with both arms up, shield on the back arm — silhouette: tall and vertical, limbs raised above the head.
2. SHIELD CHARGE: body leaning far forward, shield thrust in front, hammer pulled back low — silhouette: wide and horizontal, body stretched far forward.
3. SIDE SWING: hammer swept horizontally to the side at full arm length, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. BRACING: shield planted on the ground in front, head down, ice shards and snow bursts gathering at the feet — silhouette: compact and rounded, hands gathered near the chest.
5. WAR CRY: mouth open, hammer raised straight to the sky, ice shards and snow bursts swirling above — silhouette: tall, both arms thrown up or spread wide.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Tank: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm; white hair combed back and a big full white beard; steel-blue eyes (#4A7FB0), thick white eyebrows, always open; heavy dark steel-blue plate armor (#3A4E6E) with white fur trim on the shoulders and small ice-blue crystal inlays (#9FE3FF); tanned skin; steel-blue armored tassets over dark grey trousers; heavy steel boots. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no cape, no sword, no brown beard. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `tank_attack.png` |
| 1-2 | attaque 2 | `tank_attack_2.png` |
| 1-3 | attaque 3 | `tank_attack_3.png` |
| 2-1 | sort 1 | `tank_cast.png` |
| 2-2 | sort 2 | `tank_cast_2.png` |
| 2-3 | marche | `tank_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE playable hero: Tank, armed with: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm.
SOURCE IMAGE: it shows this playable hero, Tank, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
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
WEAPON: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle cold icy blue highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: hammer raised high above the head with both arms up, shield on the back arm — silhouette: tall and vertical, limbs raised above the head.
2. SHIELD CHARGE: body leaning far forward, shield thrust in front, hammer pulled back low — silhouette: wide and horizontal, body stretched far forward.
3. SIDE SWING: hammer swept horizontally to the side at full arm length, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. BRACING: shield planted on the ground in front, head down, ice shards and snow bursts gathering at the feet — silhouette: compact and rounded, hands gathered near the chest.
5. WAR CRY: mouth open, hammer raised straight to the sky, ice shards and snow bursts swirling above — silhouette: tall, both arms thrown up or spread wide.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Tank: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm; white hair combed back and a big full white beard; steel-blue eyes (#4A7FB0), thick white eyebrows, always open; heavy dark steel-blue plate armor (#3A4E6E) with white fur trim on the shoulders and small ice-blue crystal inlays (#9FE3FF); tanned skin; steel-blue armored tassets over dark grey trousers; heavy steel boots. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no cape, no sword, no brown beard. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `tank_back_attack.png` |
| 1-2 | attaque 2 — dos | `tank_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `tank_back_attack_3.png` |
| 2-1 | sort 1 — dos | `tank_back_cast.png` |
| 2-2 | sort 2 — dos | `tank_back_cast_2.png` |
| 2-3 | marche — dos | `tank_back_walk.png` |

L'export Zimut de l'Atelier copie aussi le repos (case 1 de la planche vues) vers `nations/heros/tank.png`.

## 3. Ennemis

### Guerrier des monts — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cimes/` ; nomme tes images `guerrier_des_monts_vues.png`, `guerrier_des_monts_actions.png` et `guerrier_des_monts_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Guerrier des monts, armed with: crude grey stone gauntlets on both fists, no other weapon.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Guerrier des monts (enemy of the Cimes nation)
- Body: stocky mountain warrior with rocky brown skin (#8A6A4A) cracked like stone
- Head: bald rocky head, small white eyes, short stone beard
- Top: fur vest of white snow fur with a leather belt
- Bottom: dark brown fur trousers, bare stone feet
- Weapon: crude grey stone gauntlets on both fists, no other weapon
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword, no axe, no human skin.
WEAPON: crude grey stone gauntlets on both fists, no other weapon. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle cold icy blue highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: crude grey stone gauntlets on both fists, no other weapon. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Guerrier des monts: crude grey stone gauntlets on both fists, no other weapon; fur vest of white snow fur with a leather belt; stocky mountain warrior with rocky brown skin (#8A6A4A) cracked like stone; bald rocky head, small white eyes, short stone beard; dark brown fur trousers, bare stone feet. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no sword, no axe, no human skin. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `guerrier_des_monts.png` |
| 1-2 | repos de face, variante | `guerrier_des_monts_idle_2.png` |
| 2-1 | repos de dos | `guerrier_des_monts_back.png` |
| 2-2 | repos de dos, variante | `guerrier_des_monts_back_idle_2.png` |

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Guerrier des monts, armed with: crude grey stone gauntlets on both fists, no other weapon.
SOURCE IMAGE: it shows this enemy monster, Guerrier des monts, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Guerrier des monts (enemy of the Cimes nation)
- Body: stocky mountain warrior with rocky brown skin (#8A6A4A) cracked like stone
- Head: bald rocky head, small white eyes, short stone beard
- Top: fur vest of white snow fur with a leather belt
- Bottom: dark brown fur trousers, bare stone feet
- Weapon: crude grey stone gauntlets on both fists, no other weapon
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword, no axe, no human skin.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
WEAPON: crude grey stone gauntlets on both fists, no other weapon. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Guerrier des monts: crude grey stone gauntlets on both fists, no other weapon; fur vest of white snow fur with a leather belt; stocky mountain warrior with rocky brown skin (#8A6A4A) cracked like stone; bald rocky head, small white eyes, short stone beard; dark brown fur trousers, bare stone feet. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no sword, no axe, no human skin. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Guerrier des monts, armed with: crude grey stone gauntlets on both fists, no other weapon.
SOURCE IMAGE: it shows this enemy monster, Guerrier des monts, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Guerrier des monts (enemy of the Cimes nation)
- Body: stocky mountain warrior with rocky brown skin (#8A6A4A) cracked like stone
- Head: bald rocky head, small white eyes, short stone beard
- Top: fur vest of white snow fur with a leather belt
- Bottom: dark brown fur trousers, bare stone feet
- Weapon: crude grey stone gauntlets on both fists, no other weapon
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword, no axe, no human skin.
WEAPON: crude grey stone gauntlets on both fists, no other weapon. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle cold icy blue highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head — silhouette: tall and vertical, limbs raised above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward — silhouette: wide and horizontal, body stretched far forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. ROOTED: stomping, ice shards and snow bursts cracks spreading under the feet — silhouette: compact and rounded, hands gathered near the chest.
5. GATHER: arms raised, ice shards and snow bursts gathering between the hands — silhouette: tall, both arms thrown up or spread wide.
6. WALK: heavy mid-stride, one foot raised, arms swinging — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: crude grey stone gauntlets on both fists, no other weapon — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Guerrier des monts: crude grey stone gauntlets on both fists, no other weapon; fur vest of white snow fur with a leather belt; stocky mountain warrior with rocky brown skin (#8A6A4A) cracked like stone; bald rocky head, small white eyes, short stone beard; dark brown fur trousers, bare stone feet. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no sword, no axe, no human skin. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `guerrier_des_monts_attack.png` |
| 1-2 | attaque 2 | `guerrier_des_monts_attack_2.png` |
| 1-3 | attaque 3 | `guerrier_des_monts_attack_3.png` |
| 2-1 | sort 1 | `guerrier_des_monts_cast.png` |
| 2-2 | sort 2 | `guerrier_des_monts_cast_2.png` |
| 2-3 | marche | `guerrier_des_monts_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Guerrier des monts, armed with: crude grey stone gauntlets on both fists, no other weapon.
SOURCE IMAGE: it shows this enemy monster, Guerrier des monts, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Guerrier des monts (enemy of the Cimes nation)
- Body: stocky mountain warrior with rocky brown skin (#8A6A4A) cracked like stone
- Head: bald rocky head, small white eyes, short stone beard
- Top: fur vest of white snow fur with a leather belt
- Bottom: dark brown fur trousers, bare stone feet
- Weapon: crude grey stone gauntlets on both fists, no other weapon
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword, no axe, no human skin.
WEAPON: crude grey stone gauntlets on both fists, no other weapon. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle cold icy blue highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head — silhouette: tall and vertical, limbs raised above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward — silhouette: wide and horizontal, body stretched far forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. ROOTED: stomping, ice shards and snow bursts cracks spreading under the feet — silhouette: compact and rounded, hands gathered near the chest.
5. GATHER: arms raised, ice shards and snow bursts gathering between the hands — silhouette: tall, both arms thrown up or spread wide.
6. WALK: heavy mid-stride, one foot raised, arms swinging — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: crude grey stone gauntlets on both fists, no other weapon — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Guerrier des monts: crude grey stone gauntlets on both fists, no other weapon; fur vest of white snow fur with a leather belt; stocky mountain warrior with rocky brown skin (#8A6A4A) cracked like stone; bald rocky head, small white eyes, short stone beard; dark brown fur trousers, bare stone feet. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no sword, no axe, no human skin. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `guerrier_des_monts_back_attack.png` |
| 1-2 | attaque 2 — dos | `guerrier_des_monts_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `guerrier_des_monts_back_attack_3.png` |
| 2-1 | sort 1 — dos | `guerrier_des_monts_back_cast.png` |
| 2-2 | sort 2 — dos | `guerrier_des_monts_back_cast_2.png` |
| 2-3 | marche — dos | `guerrier_des_monts_back_walk.png` |

### Griffon des cimes — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cimes/` ; nomme tes images `griffon_des_cimes_vues.png`, `griffon_des_cimes_actions.png` et `griffon_des_cimes_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Griffon des cimes — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Griffon des cimes (enemy of the Cimes nation)
- Body: griffin with a tawny lion body (#C9A060) and four legs, front legs with eagle talons
- Head: white eagle head, yellow hooked beak, golden eyes
- Details: large blue-grey feathered wings (#7A8CA8), lion tail with a white tuft
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no rider, no saddle, no armor.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle cold icy blue highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Griffon des cimes: griffin with a tawny lion body (#C9A060) and four legs, front legs with eagle talons; white eagle head, yellow hooked beak, golden eyes; large blue-grey feathered wings (#7A8CA8), lion tail with a white tuft. NO weapon and no held object, ever. Forbidden: no rider, no saddle, no armor. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `griffon_des_cimes.png` |
| 1-2 | repos de face, variante | `griffon_des_cimes_idle_2.png` |
| 2-1 | repos de dos | `griffon_des_cimes_back.png` |
| 2-2 | repos de dos, variante | `griffon_des_cimes_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Griffon des cimes — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Griffon des cimes, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Griffon des cimes (enemy of the Cimes nation)
- Body: griffin with a tawny lion body (#C9A060) and four legs, front legs with eagle talons
- Head: white eagle head, yellow hooked beak, golden eyes
- Details: large blue-grey feathered wings (#7A8CA8), lion tail with a white tuft
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no rider, no saddle, no armor.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Griffon des cimes: griffin with a tawny lion body (#C9A060) and four legs, front legs with eagle talons; white eagle head, yellow hooked beak, golden eyes; large blue-grey feathered wings (#7A8CA8), lion tail with a white tuft. NO weapon and no held object, ever. Forbidden: no rider, no saddle, no armor. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Griffon des cimes — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Griffon des cimes, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Griffon des cimes (enemy of the Cimes nation)
- Body: griffin with a tawny lion body (#C9A060) and four legs, front legs with eagle talons
- Head: white eagle head, yellow hooked beak, golden eyes
- Details: large blue-grey feathered wings (#7A8CA8), lion tail with a white tuft
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no rider, no saddle, no armor.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle cold icy blue highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high — silhouette: tall and vertical, limbs raised above the head.
2. POUNCE: body stretched forward in the air, jaws open — silhouette: wide and horizontal, body stretched far forward.
3. SIDE SWIPE: head and claws swept to the side, body twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. HOWL: head raised to the sky, ice shards and snow bursts gathering around the body — silhouette: compact and rounded, hands gathered near the chest.
5. ROAR: mouth wide open, ice shards and snow bursts burst in front of the head — silhouette: tall, both arms thrown up or spread wide.
6. WALK: mid-stride, one front paw raised, body moving forward — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Griffon des cimes: griffin with a tawny lion body (#C9A060) and four legs, front legs with eagle talons; white eagle head, yellow hooked beak, golden eyes; large blue-grey feathered wings (#7A8CA8), lion tail with a white tuft. NO weapon and no held object, ever. Forbidden: no rider, no saddle, no armor. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `griffon_des_cimes_attack.png` |
| 1-2 | attaque 2 | `griffon_des_cimes_attack_2.png` |
| 1-3 | attaque 3 | `griffon_des_cimes_attack_3.png` |
| 2-1 | sort 1 | `griffon_des_cimes_cast.png` |
| 2-2 | sort 2 | `griffon_des_cimes_cast_2.png` |
| 2-3 | marche | `griffon_des_cimes_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Griffon des cimes — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Griffon des cimes, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Griffon des cimes (enemy of the Cimes nation)
- Body: griffin with a tawny lion body (#C9A060) and four legs, front legs with eagle talons
- Head: white eagle head, yellow hooked beak, golden eyes
- Details: large blue-grey feathered wings (#7A8CA8), lion tail with a white tuft
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no rider, no saddle, no armor.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle cold icy blue highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high — silhouette: tall and vertical, limbs raised above the head.
2. POUNCE: body stretched forward in the air, jaws open — silhouette: wide and horizontal, body stretched far forward.
3. SIDE SWIPE: head and claws swept to the side, body twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. HOWL: head raised to the sky, ice shards and snow bursts gathering around the body — silhouette: compact and rounded, hands gathered near the chest.
5. ROAR: mouth wide open, ice shards and snow bursts burst in front of the head — silhouette: tall, both arms thrown up or spread wide.
6. WALK: mid-stride, one front paw raised, body moving forward — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Griffon des cimes: griffin with a tawny lion body (#C9A060) and four legs, front legs with eagle talons; white eagle head, yellow hooked beak, golden eyes; large blue-grey feathered wings (#7A8CA8), lion tail with a white tuft. NO weapon and no held object, ever. Forbidden: no rider, no saddle, no armor. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `griffon_des_cimes_back_attack.png` |
| 1-2 | attaque 2 — dos | `griffon_des_cimes_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `griffon_des_cimes_back_attack_3.png` |
| 2-1 | sort 1 — dos | `griffon_des_cimes_back_cast.png` |
| 2-2 | sort 2 — dos | `griffon_des_cimes_back_cast_2.png` |
| 2-3 | marche — dos | `griffon_des_cimes_back_walk.png` |

### Garde des pics — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cimes/` ; nomme tes images `garde_des_pics_vues.png`, `garde_des_pics_actions.png` et `garde_des_pics_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Garde des pics — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Garde des pics (enemy of the Cimes nation)
- Body: peak guardian golem of smooth blue-grey stone blocks (#6E8296)
- Head: small square stone head with two glowing ice-blue eyes (#9FE3FF)
- Details: clusters of glowing ice-blue crystals (#9FE3FF) on both shoulders, big stone fists
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no moss, no brown stone.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle cold icy blue highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Garde des pics: peak guardian golem of smooth blue-grey stone blocks (#6E8296); small square stone head with two glowing ice-blue eyes (#9FE3FF); clusters of glowing ice-blue crystals (#9FE3FF) on both shoulders, big stone fists. NO weapon and no held object, ever. Forbidden: no weapon, no moss, no brown stone. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `garde_des_pics.png` |
| 1-2 | repos de face, variante | `garde_des_pics_idle_2.png` |
| 2-1 | repos de dos | `garde_des_pics_back.png` |
| 2-2 | repos de dos, variante | `garde_des_pics_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Garde des pics — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Garde des pics, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Garde des pics (enemy of the Cimes nation)
- Body: peak guardian golem of smooth blue-grey stone blocks (#6E8296)
- Head: small square stone head with two glowing ice-blue eyes (#9FE3FF)
- Details: clusters of glowing ice-blue crystals (#9FE3FF) on both shoulders, big stone fists
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no moss, no brown stone.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Garde des pics: peak guardian golem of smooth blue-grey stone blocks (#6E8296); small square stone head with two glowing ice-blue eyes (#9FE3FF); clusters of glowing ice-blue crystals (#9FE3FF) on both shoulders, big stone fists. NO weapon and no held object, ever. Forbidden: no weapon, no moss, no brown stone. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Garde des pics — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Garde des pics, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Garde des pics (enemy of the Cimes nation)
- Body: peak guardian golem of smooth blue-grey stone blocks (#6E8296)
- Head: small square stone head with two glowing ice-blue eyes (#9FE3FF)
- Details: clusters of glowing ice-blue crystals (#9FE3FF) on both shoulders, big stone fists
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no moss, no brown stone.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle cold icy blue highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head — silhouette: tall and vertical, limbs raised above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward — silhouette: wide and horizontal, body stretched far forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. ROOTED: stomping, ice shards and snow bursts cracks spreading under the feet — silhouette: compact and rounded, hands gathered near the chest.
5. GATHER: arms raised, ice shards and snow bursts gathering between the hands — silhouette: tall, both arms thrown up or spread wide.
6. WALK: heavy mid-stride, one foot raised, arms swinging — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Garde des pics: peak guardian golem of smooth blue-grey stone blocks (#6E8296); small square stone head with two glowing ice-blue eyes (#9FE3FF); clusters of glowing ice-blue crystals (#9FE3FF) on both shoulders, big stone fists. NO weapon and no held object, ever. Forbidden: no weapon, no moss, no brown stone. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `garde_des_pics_attack.png` |
| 1-2 | attaque 2 | `garde_des_pics_attack_2.png` |
| 1-3 | attaque 3 | `garde_des_pics_attack_3.png` |
| 2-1 | sort 1 | `garde_des_pics_cast.png` |
| 2-2 | sort 2 | `garde_des_pics_cast_2.png` |
| 2-3 | marche | `garde_des_pics_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Garde des pics — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Garde des pics, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Garde des pics (enemy of the Cimes nation)
- Body: peak guardian golem of smooth blue-grey stone blocks (#6E8296)
- Head: small square stone head with two glowing ice-blue eyes (#9FE3FF)
- Details: clusters of glowing ice-blue crystals (#9FE3FF) on both shoulders, big stone fists
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no moss, no brown stone.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle cold icy blue highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head — silhouette: tall and vertical, limbs raised above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward — silhouette: wide and horizontal, body stretched far forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. ROOTED: stomping, ice shards and snow bursts cracks spreading under the feet — silhouette: compact and rounded, hands gathered near the chest.
5. GATHER: arms raised, ice shards and snow bursts gathering between the hands — silhouette: tall, both arms thrown up or spread wide.
6. WALK: heavy mid-stride, one foot raised, arms swinging — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Garde des pics: peak guardian golem of smooth blue-grey stone blocks (#6E8296); small square stone head with two glowing ice-blue eyes (#9FE3FF); clusters of glowing ice-blue crystals (#9FE3FF) on both shoulders, big stone fists. NO weapon and no held object, ever. Forbidden: no weapon, no moss, no brown stone. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `garde_des_pics_back_attack.png` |
| 1-2 | attaque 2 — dos | `garde_des_pics_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `garde_des_pics_back_attack_3.png` |
| 2-1 | sort 1 — dos | `garde_des_pics_back_cast.png` |
| 2-2 | sort 2 — dos | `garde_des_pics_back_cast_2.png` |
| 2-3 | marche — dos | `garde_des_pics_back_walk.png` |

### Rochebrute — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cimes/` ; nomme tes images `rochebrute_vues.png`, `rochebrute_actions.png` et `rochebrute_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Rochebrute — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Rochebrute (enemy of the Cimes nation)
- Body: hulking brute made of round brown boulders (#7A5A3A), huge hunched shoulders
- Head: small boulder head sunk between the shoulders, two small glowing orange eyes (#FF9A3A)
- Details: huge boulder fists, short stumpy legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no crystals, no weapon, no grey stone.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle cold icy blue highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Rochebrute: hulking brute made of round brown boulders (#7A5A3A), huge hunched shoulders; small boulder head sunk between the shoulders, two small glowing orange eyes (#FF9A3A); huge boulder fists, short stumpy legs. NO weapon and no held object, ever. Forbidden: no crystals, no weapon, no grey stone. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `rochebrute.png` |
| 1-2 | repos de face, variante | `rochebrute_idle_2.png` |
| 2-1 | repos de dos | `rochebrute_back.png` |
| 2-2 | repos de dos, variante | `rochebrute_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Rochebrute — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Rochebrute, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Rochebrute (enemy of the Cimes nation)
- Body: hulking brute made of round brown boulders (#7A5A3A), huge hunched shoulders
- Head: small boulder head sunk between the shoulders, two small glowing orange eyes (#FF9A3A)
- Details: huge boulder fists, short stumpy legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no crystals, no weapon, no grey stone.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Rochebrute: hulking brute made of round brown boulders (#7A5A3A), huge hunched shoulders; small boulder head sunk between the shoulders, two small glowing orange eyes (#FF9A3A); huge boulder fists, short stumpy legs. NO weapon and no held object, ever. Forbidden: no crystals, no weapon, no grey stone. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Rochebrute — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Rochebrute, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Rochebrute (enemy of the Cimes nation)
- Body: hulking brute made of round brown boulders (#7A5A3A), huge hunched shoulders
- Head: small boulder head sunk between the shoulders, two small glowing orange eyes (#FF9A3A)
- Details: huge boulder fists, short stumpy legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no crystals, no weapon, no grey stone.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle cold icy blue highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head — silhouette: tall and vertical, limbs raised above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward — silhouette: wide and horizontal, body stretched far forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. ROOTED: stomping, ice shards and snow bursts cracks spreading under the feet — silhouette: compact and rounded, hands gathered near the chest.
5. GATHER: arms raised, ice shards and snow bursts gathering between the hands — silhouette: tall, both arms thrown up or spread wide.
6. WALK: heavy mid-stride, one foot raised, arms swinging — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Rochebrute: hulking brute made of round brown boulders (#7A5A3A), huge hunched shoulders; small boulder head sunk between the shoulders, two small glowing orange eyes (#FF9A3A); huge boulder fists, short stumpy legs. NO weapon and no held object, ever. Forbidden: no crystals, no weapon, no grey stone. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `rochebrute_attack.png` |
| 1-2 | attaque 2 | `rochebrute_attack_2.png` |
| 1-3 | attaque 3 | `rochebrute_attack_3.png` |
| 2-1 | sort 1 | `rochebrute_cast.png` |
| 2-2 | sort 2 | `rochebrute_cast_2.png` |
| 2-3 | marche | `rochebrute_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Rochebrute — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Rochebrute, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Rochebrute (enemy of the Cimes nation)
- Body: hulking brute made of round brown boulders (#7A5A3A), huge hunched shoulders
- Head: small boulder head sunk between the shoulders, two small glowing orange eyes (#FF9A3A)
- Details: huge boulder fists, short stumpy legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no crystals, no weapon, no grey stone.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle cold icy blue highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head — silhouette: tall and vertical, limbs raised above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward — silhouette: wide and horizontal, body stretched far forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. ROOTED: stomping, ice shards and snow bursts cracks spreading under the feet — silhouette: compact and rounded, hands gathered near the chest.
5. GATHER: arms raised, ice shards and snow bursts gathering between the hands — silhouette: tall, both arms thrown up or spread wide.
6. WALK: heavy mid-stride, one foot raised, arms swinging — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Rochebrute: hulking brute made of round brown boulders (#7A5A3A), huge hunched shoulders; small boulder head sunk between the shoulders, two small glowing orange eyes (#FF9A3A); huge boulder fists, short stumpy legs. NO weapon and no held object, ever. Forbidden: no crystals, no weapon, no grey stone. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `rochebrute_back_attack.png` |
| 1-2 | attaque 2 — dos | `rochebrute_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `rochebrute_back_attack_3.png` |
| 2-1 | sort 1 — dos | `rochebrute_back_cast.png` |
| 2-2 | sort 2 — dos | `rochebrute_back_cast_2.png` |
| 2-3 | marche — dos | `rochebrute_back_walk.png` |

## 4. Boss

### Vorkann le Givre — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `cimes_vues.png`, `cimes_actions.png` et `cimes_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE final boss: Vorkann le Givre, armed with: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Vorkann le Givre (boss of the Cimes nation)
- Body: massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur
- Head: closed crowned helm of ice spikes, glowing ice-blue eye slit
- Weapon: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visible face, no cape.
WEAPON: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle cold icy blue highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Vorkann le Givre: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm; massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur; closed crowned helm of ice spikes, glowing ice-blue eye slit. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no visible face, no cape. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `cimes.png` |
| 1-2 | repos de face, variante | `cimes_idle_2.png` |
| 2-1 | repos de dos | `cimes_back.png` |
| 2-2 | repos de dos, variante | `cimes_back_idle_2.png` |

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE final boss: Vorkann le Givre, armed with: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm.
SOURCE IMAGE: it shows this final boss, Vorkann le Givre, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Vorkann le Givre (boss of the Cimes nation)
- Body: massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur
- Head: closed crowned helm of ice spikes, glowing ice-blue eye slit
- Weapon: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visible face, no cape.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
WEAPON: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Vorkann le Givre: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm; massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur; closed crowned helm of ice spikes, glowing ice-blue eye slit. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no visible face, no cape. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE final boss: Vorkann le Givre, armed with: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm.
SOURCE IMAGE: it shows this final boss, Vorkann le Givre, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Vorkann le Givre (boss of the Cimes nation)
- Body: massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur
- Head: closed crowned helm of ice spikes, glowing ice-blue eye slit
- Weapon: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visible face, no cape.
WEAPON: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle cold icy blue highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: hammer raised high above the head with both arms up, shield on the back arm — silhouette: tall and vertical, limbs raised above the head.
2. SHIELD CHARGE: body leaning far forward, shield thrust in front, hammer pulled back low — silhouette: wide and horizontal, body stretched far forward.
3. SIDE SWING: hammer swept horizontally to the side at full arm length, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. BRACING: shield planted on the ground in front, head down, ice shards and snow bursts gathering at the feet — silhouette: compact and rounded, hands gathered near the chest.
5. WAR CRY: mouth open, hammer raised straight to the sky, ice shards and snow bursts swirling above — silhouette: tall, both arms thrown up or spread wide.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Vorkann le Givre: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm; massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur; closed crowned helm of ice spikes, glowing ice-blue eye slit. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no visible face, no cape. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `cimes_attack.png` |
| 1-2 | attaque 2 | `cimes_attack_2.png` |
| 1-3 | attaque 3 | `cimes_attack_3.png` |
| 2-1 | sort 1 | `cimes_cast.png` |
| 2-2 | sort 2 | `cimes_cast_2.png` |
| 2-3 | marche | `cimes_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE final boss: Vorkann le Givre, armed with: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm.
SOURCE IMAGE: it shows this final boss, Vorkann le Givre, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Vorkann le Givre (boss of the Cimes nation)
- Body: massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur
- Head: closed crowned helm of ice spikes, glowing ice-blue eye slit
- Weapon: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visible face, no cape.
WEAPON: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle cold icy blue highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: hammer raised high above the head with both arms up, shield on the back arm — silhouette: tall and vertical, limbs raised above the head.
2. SHIELD CHARGE: body leaning far forward, shield thrust in front, hammer pulled back low — silhouette: wide and horizontal, body stretched far forward.
3. SIDE SWING: hammer swept horizontally to the side at full arm length, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. BRACING: shield planted on the ground in front, head down, ice shards and snow bursts gathering at the feet — silhouette: compact and rounded, hands gathered near the chest.
5. WAR CRY: mouth open, hammer raised straight to the sky, ice shards and snow bursts swirling above — silhouette: tall, both arms thrown up or spread wide.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Vorkann le Givre: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm; massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur; closed crowned helm of ice spikes, glowing ice-blue eye slit. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no visible face, no cape. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `cimes_back_attack.png` |
| 1-2 | attaque 2 — dos | `cimes_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `cimes_back_attack_3.png` |
| 2-1 | sort 1 — dos | `cimes_back_cast.png` |
| 2-2 | sort 2 — dos | `cimes_back_cast_2.png` |
| 2-3 | marche — dos | `cimes_back_walk.png` |

## Prompt négatif

**Personnages armés — planches vues** :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, golden glow, light flare, sun rays, color tint over the sprite, glowing aura on one side, cream background, beige background, colored background, ground shadow ellipse, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, pixel grid, low-resolution pixels, painterly soft brush style, mirror image of another sprite, flipped copy, copy of the source pose, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, weapon changing shape, weapon changing color, weapon replaced by another weapon, missing weapon, missing accessories, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, different character between poses, realistic proportions, small head, more than 4 sprites, extra sprites, only 3 sprites, empty cell, duplicated row of sprites, one sprite bigger or smaller than the others, size changing between cells, mirror image of another sprite, flipped copy, left-right mirrored pair, four identical front views, back row drawn from the front, low-resolution pixels, pixel grid
```

**Personnages armés — planches actions et planche de style** :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, golden glow, light flare, sun rays, color tint over the sprite, glowing aura on one side, cream background, beige background, colored background, ground shadow ellipse, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, pixel grid, low-resolution pixels, painterly soft brush style, mirror image of another sprite, flipped copy, copy of the source pose, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, weapon changing shape, weapon changing color, weapon replaced by another weapon, missing weapon, missing accessories, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, different character between poses, realistic proportions, small head
```

**Créatures sans arme (Salamandre, golems, bêtes…) — planches vues** :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, golden glow, light flare, sun rays, color tint over the sprite, glowing aura on one side, cream background, beige background, colored background, ground shadow ellipse, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, pixel grid, low-resolution pixels, painterly soft brush style, mirror image of another sprite, flipped copy, copy of the source pose, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, extra objects, different character between poses, realistic proportions, small head, more than 4 sprites, extra sprites, only 3 sprites, empty cell, duplicated row of sprites, one sprite bigger or smaller than the others, size changing between cells, mirror image of another sprite, flipped copy, left-right mirrored pair, four identical front views, back row drawn from the front, low-resolution pixels, pixel grid, weapon, torch, staff, sword, bow, held object, tool, item in the hands or claws
```

**Créatures sans arme — planches actions** :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, golden glow, light flare, sun rays, color tint over the sprite, glowing aura on one side, cream background, beige background, colored background, ground shadow ellipse, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, pixel grid, low-resolution pixels, painterly soft brush style, mirror image of another sprite, flipped copy, copy of the source pose, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, extra objects, different character between poses, realistic proportions, small head, weapon, torch, staff, sword, bow, held object, tool, item in the hands or claws
```
