# Nation Rouages (Rouages)

Palette : brass, copper, dark steel, teal glowing lights. Effets : sparks, steam puffs and teal electric arcs. Contre-jour : warm brass.

Format 3 planches par personnage (V44) :

1. **Vues** — 4 cases : repos de FACE ×2 (deux attitudes différentes) puis repos de DOS ×2, tout orienté vers la droite (le jeu retourne l'image pour la gauche). Grille 2 × 2 sur image 2:1, poses largement espacées. Génération normale.
2. **Actions de face** — 3 attaques + 2 sorts + 1 marche (3 colonnes × 2 rangées), en **édition** de la planche vues : le personnage réellement dessiné sert d'ancre.
3. **Actions de dos** — les mêmes 6 poses vues de dos, en édition de la planche vues. Une planche = un seul sens de vue (face et dos mélangés sur une même planche étaient dessinés de face). Facultative pour les monstres.

Les personnages **armés** ont l'arme écrite dans la première phrase, dans la carte d'identité, en fin de prompt et dans chaque pose ; les **créatures** reçoivent « UNARMED » (plus de torche inventée). Chaque prompt recopie la carte d'identité (`identites.py`) : aucune image à joindre. Ordre conseillé : 1) planche de style, 2) héros, 3) ennemis, 4) boss ; pour chaque personnage : vues, actions de face, actions de dos. Prompt négatif : en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Rouages nation (Rouages biome).
NATION PALETTE: brass, copper, dark steel, teal glowing lights. Signature effects: sparks, steam puffs and teal electric arcs.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm brass highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: two rows with the same 6 characters in the same order, all in idle pose. Top row: 3/4 front view, facing front-right. Bottom row: 3/4 back view, seen from behind, turned toward the upper right. All feet of a row on the same ground line. Leave a wide empty gap (at least half a character width) between characters and between the two rows: nobody overlaps or touches anyone, held items and capes included. Image aspect ratio 2:1, as large as possible.
CHARACTERS, left to right:
1. the hero (Artificier: young engineer with spiky brown hair, brass goggles on the forehead, bronze and steel steampunk armor with teal glowing gems, tool belt with pouches, a big gear-headed hammer in the right hand).
2. Drone aérien (bronze flying drone with claw arms, small propellers and a glowing blue core).
3. Araignée mécanique (bronze mechanical spider with long jointed legs and a blue gem eye).
4. Roue engrenée (rolling bronze cog-wheel creature with a single glowing blue gem eye in the center).
5. Automate de combat (heavy combat automaton of riveted bronze and stone plates with big fists).
6. the final boss Mécanoptère, Colosse d'Engrenages (giant steam colossus of steel and brass with two smoking chimneys on the back, a glowing blue core in the chest and a huge gear hammer), about 1.5x taller than the others.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Artificier — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `artificier_vues.png`, `artificier_actions.png` et `artificier_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE playable hero: Artificier, carrying: big gear-headed hammer, RIGHT hand.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Artificier (hero of the Rouages nation)
- Hair: spiky brown hair (#6B3E1E)
- Eyes: green eyes, always open
- Head: brass goggles pushed up on the forehead
- Top: bronze and steel steampunk armor with small teal glowing gems (#2FE0C8)
- Bottom: brown trousers, tool belt with pouches
- Feet: heavy brown boots with brass caps
- Held item: big gear-headed hammer, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no top hat, no gun, no cape.
HELD ITEM: big gear-headed hammer, RIGHT hand. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm brass highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm. The big gear-headed hammer is held in the right hand and fully visible in this cell.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the held item stays in its hand); the face is visible and the drawing must not be a copy of cell 1. The big gear-headed hammer is held in the right hand and fully visible in this cell.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile. The big gear-headed hammer is held in the right hand and fully visible in this cell.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the held item stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3. The big gear-headed hammer is held in the right hand and fully visible in this cell.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: big gear-headed hammer, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Artificier: big gear-headed hammer, RIGHT hand; spiky brown hair (#6B3E1E); green eyes, always open; bronze and steel steampunk armor with small teal glowing gems (#2FE0C8); brass goggles pushed up on the forehead; brown trousers, tool belt with pouches; heavy brown boots with brass caps. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no top hat, no gun, no cape. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `artificier.png` |
| 1-2 | repos de face, variante | `artificier_idle_2.png` |
| 2-1 | repos de dos | `artificier_back.png` |
| 2-2 | repos de dos, variante | `artificier_back_idle_2.png` |

##### Version courte de la planche vues

À utiliser si le générateur reformule le prompt, bloque sur un mot ou ne respecte pas le nombre de cases : mêmes consignes, 1 000 caractères.

```text
Character sheet, exactly 4 sprites in a 2x2 grid, plain flat white background, wide empty gaps, no overlap, no text, no frame. ONE playable hero: Artificier. spiky brown hair (#6B3E1E); green eyes, always open; brass goggles pushed up on the forehead; bronze and steel steampunk armor with small teal glowing gems (#2FE0C8); brown trousers, tool belt with pouches; heavy brown boots with brass caps; big gear-headed hammer, RIGHT hand. It always holds the big gear-headed hammer in the right hand, clearly visible in all 4 sprites. Top row: two front 3/4 views facing right, two slightly different relaxed stances (not mirrored). Bottom row: two views from behind, facing away toward the upper right, no face visible, two different stances. Same outfit, colors and size in all 4, feet on one line. Style: smooth hand-drawn vector cartoon, thick dark outlines, Dofus / Waven look, NOT pixel art. Never facing left. Forbidden: no top hat, no gun, no cape.
```

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE playable hero: Artificier, carrying: big gear-headed hammer, RIGHT hand.
SOURCE IMAGE: it shows this playable hero, Artificier, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Artificier (hero of the Rouages nation)
- Hair: spiky brown hair (#6B3E1E)
- Eyes: green eyes, always open
- Head: brass goggles pushed up on the forehead
- Top: bronze and steel steampunk armor with small teal glowing gems (#2FE0C8)
- Bottom: brown trousers, tool belt with pouches
- Feet: heavy brown boots with brass caps
- Held item: big gear-headed hammer, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no top hat, no gun, no cape.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its held item in the correct hand — add the held item where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm. The big gear-headed hammer is held in the right hand and fully visible in this cell.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the held item stays in its hand); the face is visible and the drawing must not be a copy of cell 1. The big gear-headed hammer is held in the right hand and fully visible in this cell.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile. The big gear-headed hammer is held in the right hand and fully visible in this cell.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the held item stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3. The big gear-headed hammer is held in the right hand and fully visible in this cell.
HELD ITEM: big gear-headed hammer, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Artificier: big gear-headed hammer, RIGHT hand; spiky brown hair (#6B3E1E); green eyes, always open; bronze and steel steampunk armor with small teal glowing gems (#2FE0C8); brass goggles pushed up on the forehead; brown trousers, tool belt with pouches; heavy brown boots with brass caps. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no top hat, no gun, no cape. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE playable hero: Artificier, carrying: big gear-headed hammer, RIGHT hand.
SOURCE IMAGE: it shows this playable hero, Artificier, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, held item in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Artificier (hero of the Rouages nation)
- Hair: spiky brown hair (#6B3E1E)
- Eyes: green eyes, always open
- Head: brass goggles pushed up on the forehead
- Top: bronze and steel steampunk armor with small teal glowing gems (#2FE0C8)
- Bottom: brown trousers, tool belt with pouches
- Feet: heavy brown boots with brass caps
- Held item: big gear-headed hammer, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no top hat, no gun, no cape.
HELD ITEM: big gear-headed hammer, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm brass highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: gear hammer raised high above the head with both hands — silhouette: tall and vertical, limbs raised above the head. The big gear-headed hammer is held in the right hand and fully visible in this cell.
2. ROUND CHARGE THROW: free arm extended forward after throwing a small round round charge — silhouette: wide and horizontal, body stretched far forward. The big gear-headed hammer is held in the right hand and fully visible in this cell.
3. SIDE SWING: gear hammer swept horizontally, goggles bouncing — silhouette: low and wide, crouched or twisted with a long side reach. The big gear-headed hammer is held in the right hand and fully visible in this cell.
4. TINKERING: kneeling, adjusting a small device on the ground, sparks, steam puffs and teal electric arcs crackling — silhouette: compact and rounded, hands gathered near the chest. The big gear-headed hammer is held in the right hand and fully visible in this cell.
5. REMOTE: standing, raising a glowing remote control high, sparks, steam puffs and teal electric arcs arcing around — silhouette: tall, both arms thrown up or spread wide. The big gear-headed hammer is held in the right hand and fully visible in this cell.
6. WALK: mid-stride, one foot raised, arms swinging naturally, held item held — silhouette: mid-stride with legs clearly apart, moving forward. The big gear-headed hammer is held in the right hand and fully visible in this cell.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: big gear-headed hammer, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Artificier: big gear-headed hammer, RIGHT hand; spiky brown hair (#6B3E1E); green eyes, always open; bronze and steel steampunk armor with small teal glowing gems (#2FE0C8); brass goggles pushed up on the forehead; brown trousers, tool belt with pouches; heavy brown boots with brass caps. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no top hat, no gun, no cape. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `artificier_attack.png` |
| 1-2 | attaque 2 | `artificier_attack_2.png` |
| 1-3 | attaque 3 | `artificier_attack_3.png` |
| 2-1 | sort 1 | `artificier_cast.png` |
| 2-2 | sort 2 | `artificier_cast_2.png` |
| 2-3 | marche | `artificier_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE playable hero: Artificier, carrying: big gear-headed hammer, RIGHT hand.
SOURCE IMAGE: it shows this playable hero, Artificier, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, held item in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Artificier (hero of the Rouages nation)
- Hair: spiky brown hair (#6B3E1E)
- Eyes: green eyes, always open
- Head: brass goggles pushed up on the forehead
- Top: bronze and steel steampunk armor with small teal glowing gems (#2FE0C8)
- Bottom: brown trousers, tool belt with pouches
- Feet: heavy brown boots with brass caps
- Held item: big gear-headed hammer, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no top hat, no gun, no cape.
HELD ITEM: big gear-headed hammer, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm brass highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: gear hammer raised high above the head with both hands — silhouette: tall and vertical, limbs raised above the head. The big gear-headed hammer is held in the right hand and fully visible in this cell.
2. ROUND CHARGE THROW: free arm extended forward after throwing a small round round charge — silhouette: wide and horizontal, body stretched far forward. The big gear-headed hammer is held in the right hand and fully visible in this cell.
3. SIDE SWING: gear hammer swept horizontally, goggles bouncing — silhouette: low and wide, crouched or twisted with a long side reach. The big gear-headed hammer is held in the right hand and fully visible in this cell.
4. TINKERING: kneeling, adjusting a small device on the ground, sparks, steam puffs and teal electric arcs crackling — silhouette: compact and rounded, hands gathered near the chest. The big gear-headed hammer is held in the right hand and fully visible in this cell.
5. REMOTE: standing, raising a glowing remote control high, sparks, steam puffs and teal electric arcs arcing around — silhouette: tall, both arms thrown up or spread wide. The big gear-headed hammer is held in the right hand and fully visible in this cell.
6. WALK: mid-stride, one foot raised, arms swinging naturally, held item held — silhouette: mid-stride with legs clearly apart, moving forward. The big gear-headed hammer is held in the right hand and fully visible in this cell.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: big gear-headed hammer, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Artificier: big gear-headed hammer, RIGHT hand; spiky brown hair (#6B3E1E); green eyes, always open; bronze and steel steampunk armor with small teal glowing gems (#2FE0C8); brass goggles pushed up on the forehead; brown trousers, tool belt with pouches; heavy brown boots with brass caps. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no top hat, no gun, no cape. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `artificier_back_attack.png` |
| 1-2 | attaque 2 — dos | `artificier_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `artificier_back_attack_3.png` |
| 2-1 | sort 1 — dos | `artificier_back_cast.png` |
| 2-2 | sort 2 — dos | `artificier_back_cast_2.png` |
| 2-3 | marche — dos | `artificier_back_walk.png` |

L'export Zimut de l'Atelier copie aussi le repos (case 1 de la planche vues) vers `nations/heros/artificier.png`.

## 3. Ennemis

### Drone aérien — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/rouages/` ; nomme tes images `drone_aerien_vues.png`, `drone_aerien_actions.png` et `drone_aerien_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Drone aérien — an NO HELD ITEM creature (no held item of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Drone aérien (enemy of the Rouages nation)
- Body: round bronze flying drone (#B8873A) with riveted plates
- Head: single glowing blue core eye (#3FC8FF) in the front
- Details: two small propellers on top, two jointed claw arms below
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no wings, no human parts.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 4 cells; it acts only with its own body (claws, fists, tail, magic). Never add an item.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm brass highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in every cell; it acts only with its own body (claws, fists, tail, magic). Never add an item.
REMINDER: this is Drone aérien: round bronze flying drone (#B8873A) with riveted plates; single glowing blue core eye (#3FC8FF) in the front; two small propellers on top, two jointed claw arms below. NO held item and no held object, ever. Forbidden: no legs, no wings, no human parts. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `drone_aerien.png` |
| 1-2 | repos de face, variante | `drone_aerien_idle_2.png` |
| 2-1 | repos de dos | `drone_aerien_back.png` |
| 2-2 | repos de dos, variante | `drone_aerien_back_idle_2.png` |

##### Version courte de la planche vues

À utiliser si le générateur reformule le prompt, bloque sur un mot ou ne respecte pas le nombre de cases : mêmes consignes, 1 000 caractères.

```text
Character sheet, exactly 4 sprites in a 2x2 grid, plain flat white background, wide empty gaps, no overlap, no text, no frame. ONE enemy monster: Drone aérien. round bronze flying drone (#B8873A) with riveted plates; single glowing blue core eye (#3FC8FF) in the front; two small propellers on top, two jointed claw arms below. It holds nothing in its hands, paws or claws. Top row: two front 3/4 views facing right, two slightly different relaxed stances (not mirrored). Bottom row: two views from behind, facing away toward the upper right, no face visible, two different stances. Same outfit, colors and size in all 4, feet on one line. Style: smooth hand-drawn vector cartoon, thick dark outlines, Dofus / Waven look, NOT pixel art. Never facing left. Forbidden: no legs, no wings, no human parts.
```

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Drone aérien — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Drone aérien, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Drone aérien (enemy of the Rouages nation)
- Body: round bronze flying drone (#B8873A) with riveted plates
- Head: single glowing blue core eye (#3FC8FF) in the front
- Details: two small propellers on top, two jointed claw arms below
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no wings, no human parts.
TASK: REMOVE every held item, torch, tool or held object from the hands, claws or tail — this creature is item-free. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in every cell; it acts only with its own body (claws, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Drone aérien: round bronze flying drone (#B8873A) with riveted plates; single glowing blue core eye (#3FC8FF) in the front; two small propellers on top, two jointed claw arms below. NO held item and no held object, ever. Forbidden: no legs, no wings, no human parts. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Drone aérien — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Drone aérien, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Drone aérien (enemy of the Rouages nation)
- Body: round bronze flying drone (#B8873A) with riveted plates
- Head: single glowing blue core eye (#3FC8FF) in the front
- Details: two small propellers on top, two jointed claw arms below
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no wings, no human parts.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 6 poses; it acts only with its own body (claws, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm brass highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised — silhouette: tall and vertical, limbs raised above the head.
2. LUNGE: body stretched forward, claws of sparks, steam puffs and teal electric arcs reaching out — silhouette: wide and horizontal, body stretched far forward.
3. SPIN: body whirling, sparks, steam puffs and teal electric arcs trail around it — silhouette: low and wide, crouched or twisted with a long side reach.
4. HOVER: floating higher, sparks, steam puffs and teal electric arcs orbs circling — silhouette: compact and rounded, hands gathered near the chest.
5. PULSE: arms spread, sparks, steam puffs and teal electric arcs pulsing outward — silhouette: tall, both arms thrown up or spread wide.
6. DRIFT: floating forward with the body tilted slightly ahead, a short trail behind — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Drone aérien: round bronze flying drone (#B8873A) with riveted plates; single glowing blue core eye (#3FC8FF) in the front; two small propellers on top, two jointed claw arms below. NO held item and no held object, ever. Forbidden: no legs, no wings, no human parts. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `drone_aerien_attack.png` |
| 1-2 | attaque 2 | `drone_aerien_attack_2.png` |
| 1-3 | attaque 3 | `drone_aerien_attack_3.png` |
| 2-1 | sort 1 | `drone_aerien_cast.png` |
| 2-2 | sort 2 | `drone_aerien_cast_2.png` |
| 2-3 | marche | `drone_aerien_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Drone aérien — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Drone aérien, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Drone aérien (enemy of the Rouages nation)
- Body: round bronze flying drone (#B8873A) with riveted plates
- Head: single glowing blue core eye (#3FC8FF) in the front
- Details: two small propellers on top, two jointed claw arms below
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no wings, no human parts.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 6 poses; it acts only with its own body (claws, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm brass highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised — silhouette: tall and vertical, limbs raised above the head.
2. LUNGE: body stretched forward, claws of sparks, steam puffs and teal electric arcs reaching out — silhouette: wide and horizontal, body stretched far forward.
3. SPIN: body whirling, sparks, steam puffs and teal electric arcs trail around it — silhouette: low and wide, crouched or twisted with a long side reach.
4. HOVER: floating higher, sparks, steam puffs and teal electric arcs orbs circling — silhouette: compact and rounded, hands gathered near the chest.
5. PULSE: arms spread, sparks, steam puffs and teal electric arcs pulsing outward — silhouette: tall, both arms thrown up or spread wide.
6. DRIFT: floating forward with the body tilted slightly ahead, a short trail behind — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Drone aérien: round bronze flying drone (#B8873A) with riveted plates; single glowing blue core eye (#3FC8FF) in the front; two small propellers on top, two jointed claw arms below. NO held item and no held object, ever. Forbidden: no legs, no wings, no human parts. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `drone_aerien_back_attack.png` |
| 1-2 | attaque 2 — dos | `drone_aerien_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `drone_aerien_back_attack_3.png` |
| 2-1 | sort 1 — dos | `drone_aerien_back_cast.png` |
| 2-2 | sort 2 — dos | `drone_aerien_back_cast_2.png` |
| 2-3 | marche — dos | `drone_aerien_back_walk.png` |

### Araignée mécanique — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/rouages/` ; nomme tes images `araignee_mecanique_vues.png`, `araignee_mecanique_actions.png` et `araignee_mecanique_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Araignée mécanique — an NO HELD ITEM creature (no held item of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Araignée mécanique (enemy of the Rouages nation)
- Body: bronze mechanical spider (#B8873A) with a riveted round body
- Head: single blue gem eye (#3FC8FF)
- Details: eight long jointed steel legs (#8A9098)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no fur, no organic parts.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 4 cells; it acts only with its own body (claws, fists, tail, magic). Never add an item.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm brass highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in every cell; it acts only with its own body (claws, fists, tail, magic). Never add an item.
REMINDER: this is Araignée mécanique: bronze mechanical spider (#B8873A) with a riveted round body; single blue gem eye (#3FC8FF); eight long jointed steel legs (#8A9098). NO held item and no held object, ever. Forbidden: no fur, no organic parts. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `araignee_mecanique.png` |
| 1-2 | repos de face, variante | `araignee_mecanique_idle_2.png` |
| 2-1 | repos de dos | `araignee_mecanique_back.png` |
| 2-2 | repos de dos, variante | `araignee_mecanique_back_idle_2.png` |

##### Version courte de la planche vues

À utiliser si le générateur reformule le prompt, bloque sur un mot ou ne respecte pas le nombre de cases : mêmes consignes, 1 000 caractères.

```text
Character sheet, exactly 4 sprites in a 2x2 grid, plain flat white background, wide empty gaps, no overlap, no text, no frame. ONE enemy monster: Araignée mécanique. bronze mechanical spider (#B8873A) with a riveted round body; single blue gem eye (#3FC8FF); eight long jointed steel legs (#8A9098). It holds nothing in its hands, paws or claws. Top row: two front 3/4 views facing right, two slightly different relaxed stances (not mirrored). Bottom row: two views from behind, facing away toward the upper right, no face visible, two different stances. Same outfit, colors and size in all 4, feet on one line. Style: smooth hand-drawn vector cartoon, thick dark outlines, Dofus / Waven look, NOT pixel art. Never facing left. Forbidden: no fur, no organic parts.
```

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Araignée mécanique — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Araignée mécanique, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Araignée mécanique (enemy of the Rouages nation)
- Body: bronze mechanical spider (#B8873A) with a riveted round body
- Head: single blue gem eye (#3FC8FF)
- Details: eight long jointed steel legs (#8A9098)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no fur, no organic parts.
TASK: REMOVE every held item, torch, tool or held object from the hands, claws or tail — this creature is item-free. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in every cell; it acts only with its own body (claws, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Araignée mécanique: bronze mechanical spider (#B8873A) with a riveted round body; single blue gem eye (#3FC8FF); eight long jointed steel legs (#8A9098). NO held item and no held object, ever. Forbidden: no fur, no organic parts. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Araignée mécanique — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Araignée mécanique, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Araignée mécanique (enemy of the Rouages nation)
- Body: bronze mechanical spider (#B8873A) with a riveted round body
- Head: single blue gem eye (#3FC8FF)
- Details: eight long jointed steel legs (#8A9098)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no fur, no organic parts.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 6 poses; it acts only with its own body (claws, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm brass highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high — silhouette: tall and vertical, limbs raised above the head.
2. POUNCE: body stretched forward in the air, jaws open — silhouette: wide and horizontal, body stretched far forward.
3. SIDE SWIPE: head and claws swept to the side, body twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. HOWL: head raised to the sky, sparks, steam puffs and teal electric arcs gathering around the body — silhouette: compact and rounded, hands gathered near the chest.
5. ROAR: mouth wide open, sparks, steam puffs and teal electric arcs burst in front of the head — silhouette: tall, both arms thrown up or spread wide.
6. WALK: mid-stride, one front paw raised, body moving forward — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Araignée mécanique: bronze mechanical spider (#B8873A) with a riveted round body; single blue gem eye (#3FC8FF); eight long jointed steel legs (#8A9098). NO held item and no held object, ever. Forbidden: no fur, no organic parts. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `araignee_mecanique_attack.png` |
| 1-2 | attaque 2 | `araignee_mecanique_attack_2.png` |
| 1-3 | attaque 3 | `araignee_mecanique_attack_3.png` |
| 2-1 | sort 1 | `araignee_mecanique_cast.png` |
| 2-2 | sort 2 | `araignee_mecanique_cast_2.png` |
| 2-3 | marche | `araignee_mecanique_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Araignée mécanique — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Araignée mécanique, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Araignée mécanique (enemy of the Rouages nation)
- Body: bronze mechanical spider (#B8873A) with a riveted round body
- Head: single blue gem eye (#3FC8FF)
- Details: eight long jointed steel legs (#8A9098)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no fur, no organic parts.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 6 poses; it acts only with its own body (claws, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm brass highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high — silhouette: tall and vertical, limbs raised above the head.
2. POUNCE: body stretched forward in the air, jaws open — silhouette: wide and horizontal, body stretched far forward.
3. SIDE SWIPE: head and claws swept to the side, body twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. HOWL: head raised to the sky, sparks, steam puffs and teal electric arcs gathering around the body — silhouette: compact and rounded, hands gathered near the chest.
5. ROAR: mouth wide open, sparks, steam puffs and teal electric arcs burst in front of the head — silhouette: tall, both arms thrown up or spread wide.
6. WALK: mid-stride, one front paw raised, body moving forward — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Araignée mécanique: bronze mechanical spider (#B8873A) with a riveted round body; single blue gem eye (#3FC8FF); eight long jointed steel legs (#8A9098). NO held item and no held object, ever. Forbidden: no fur, no organic parts. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `araignee_mecanique_back_attack.png` |
| 1-2 | attaque 2 — dos | `araignee_mecanique_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `araignee_mecanique_back_attack_3.png` |
| 2-1 | sort 1 — dos | `araignee_mecanique_back_cast.png` |
| 2-2 | sort 2 — dos | `araignee_mecanique_back_cast_2.png` |
| 2-3 | marche — dos | `araignee_mecanique_back_walk.png` |

### Roue engrenée — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/rouages/` ; nomme tes images `roue_engrenee_vues.png`, `roue_engrenee_actions.png` et `roue_engrenee_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Roue engrenée — an NO HELD ITEM creature (no held item of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Roue engrenée (enemy of the Rouages nation)
- Body: rolling bronze cog-wheel creature (#B8873A) standing upright on its edge
- Head: single glowing blue gem eye (#3FC8FF) in the center of the wheel
- Details: two small jointed steel arms on the sides
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no face other than the gem eye.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 4 cells; it acts only with its own body (claws, fists, tail, magic). Never add an item.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm brass highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in every cell; it acts only with its own body (claws, fists, tail, magic). Never add an item.
REMINDER: this is Roue engrenée: rolling bronze cog-wheel creature (#B8873A) standing upright on its edge; single glowing blue gem eye (#3FC8FF) in the center of the wheel; two small jointed steel arms on the sides. NO held item and no held object, ever. Forbidden: no legs, no face other than the gem eye. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `roue_engrenee.png` |
| 1-2 | repos de face, variante | `roue_engrenee_idle_2.png` |
| 2-1 | repos de dos | `roue_engrenee_back.png` |
| 2-2 | repos de dos, variante | `roue_engrenee_back_idle_2.png` |

##### Version courte de la planche vues

À utiliser si le générateur reformule le prompt, bloque sur un mot ou ne respecte pas le nombre de cases : mêmes consignes, 1 000 caractères.

```text
Character sheet, exactly 4 sprites in a 2x2 grid, plain flat white background, wide empty gaps, no overlap, no text, no frame. ONE enemy monster: Roue engrenée. rolling bronze cog-wheel creature (#B8873A) standing upright on its edge; single glowing blue gem eye (#3FC8FF) in the center of the wheel; two small jointed steel arms on the sides. It holds nothing in its hands, paws or claws. Top row: two front 3/4 views facing right, two slightly different relaxed stances (not mirrored). Bottom row: two views from behind, facing away toward the upper right, no face visible, two different stances. Same outfit, colors and size in all 4, feet on one line. Style: smooth hand-drawn vector cartoon, thick dark outlines, Dofus / Waven look, NOT pixel art. Never facing left. Forbidden: no legs, no face other than the gem eye.
```

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Roue engrenée — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Roue engrenée, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Roue engrenée (enemy of the Rouages nation)
- Body: rolling bronze cog-wheel creature (#B8873A) standing upright on its edge
- Head: single glowing blue gem eye (#3FC8FF) in the center of the wheel
- Details: two small jointed steel arms on the sides
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no face other than the gem eye.
TASK: REMOVE every held item, torch, tool or held object from the hands, claws or tail — this creature is item-free. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in every cell; it acts only with its own body (claws, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Roue engrenée: rolling bronze cog-wheel creature (#B8873A) standing upright on its edge; single glowing blue gem eye (#3FC8FF) in the center of the wheel; two small jointed steel arms on the sides. NO held item and no held object, ever. Forbidden: no legs, no face other than the gem eye. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Roue engrenée — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Roue engrenée, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Roue engrenée (enemy of the Rouages nation)
- Body: rolling bronze cog-wheel creature (#B8873A) standing upright on its edge
- Head: single glowing blue gem eye (#3FC8FF) in the center of the wheel
- Details: two small jointed steel arms on the sides
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no face other than the gem eye.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 6 poses; it acts only with its own body (claws, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm brass highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: both fists or held item raised high above the head — silhouette: tall and vertical, limbs raised above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward — silhouette: wide and horizontal, body stretched far forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. ROOTED: stomping, sparks, steam puffs and teal electric arcs cracks spreading under the feet — silhouette: compact and rounded, hands gathered near the chest.
5. GATHER: arms raised, sparks, steam puffs and teal electric arcs gathering between the hands — silhouette: tall, both arms thrown up or spread wide.
6. WALK: heavy mid-stride, one foot raised, arms swinging — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Roue engrenée: rolling bronze cog-wheel creature (#B8873A) standing upright on its edge; single glowing blue gem eye (#3FC8FF) in the center of the wheel; two small jointed steel arms on the sides. NO held item and no held object, ever. Forbidden: no legs, no face other than the gem eye. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `roue_engrenee_attack.png` |
| 1-2 | attaque 2 | `roue_engrenee_attack_2.png` |
| 1-3 | attaque 3 | `roue_engrenee_attack_3.png` |
| 2-1 | sort 1 | `roue_engrenee_cast.png` |
| 2-2 | sort 2 | `roue_engrenee_cast_2.png` |
| 2-3 | marche | `roue_engrenee_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Roue engrenée — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Roue engrenée, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Roue engrenée (enemy of the Rouages nation)
- Body: rolling bronze cog-wheel creature (#B8873A) standing upright on its edge
- Head: single glowing blue gem eye (#3FC8FF) in the center of the wheel
- Details: two small jointed steel arms on the sides
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no face other than the gem eye.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 6 poses; it acts only with its own body (claws, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm brass highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: both fists or held item raised high above the head — silhouette: tall and vertical, limbs raised above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward — silhouette: wide and horizontal, body stretched far forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. ROOTED: stomping, sparks, steam puffs and teal electric arcs cracks spreading under the feet — silhouette: compact and rounded, hands gathered near the chest.
5. GATHER: arms raised, sparks, steam puffs and teal electric arcs gathering between the hands — silhouette: tall, both arms thrown up or spread wide.
6. WALK: heavy mid-stride, one foot raised, arms swinging — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Roue engrenée: rolling bronze cog-wheel creature (#B8873A) standing upright on its edge; single glowing blue gem eye (#3FC8FF) in the center of the wheel; two small jointed steel arms on the sides. NO held item and no held object, ever. Forbidden: no legs, no face other than the gem eye. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `roue_engrenee_back_attack.png` |
| 1-2 | attaque 2 — dos | `roue_engrenee_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `roue_engrenee_back_attack_3.png` |
| 2-1 | sort 1 — dos | `roue_engrenee_back_cast.png` |
| 2-2 | sort 2 — dos | `roue_engrenee_back_cast_2.png` |
| 2-3 | marche — dos | `roue_engrenee_back_walk.png` |

### Automate de combat — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/rouages/` ; nomme tes images `automate_de_combat_vues.png`, `automate_de_combat_actions.png` et `automate_de_combat_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Automate de combat — an NO HELD ITEM creature (no held item of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Automate de combat (enemy of the Rouages nation)
- Body: heavy combat automaton of riveted bronze (#B8873A) and grey stone plates
- Head: small dome head with a glowing blue visor slit (#3FC8FF)
- Details: huge fists, small smoking pipe on the back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human face, no held item.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 4 cells; it acts only with its own body (claws, fists, tail, magic). Never add an item.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm brass highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in every cell; it acts only with its own body (claws, fists, tail, magic). Never add an item.
REMINDER: this is Automate de combat: heavy combat automaton of riveted bronze (#B8873A) and grey stone plates; small dome head with a glowing blue visor slit (#3FC8FF); huge fists, small smoking pipe on the back. NO held item and no held object, ever. Forbidden: no human face, no held item. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `automate_de_combat.png` |
| 1-2 | repos de face, variante | `automate_de_combat_idle_2.png` |
| 2-1 | repos de dos | `automate_de_combat_back.png` |
| 2-2 | repos de dos, variante | `automate_de_combat_back_idle_2.png` |

##### Version courte de la planche vues

À utiliser si le générateur reformule le prompt, bloque sur un mot ou ne respecte pas le nombre de cases : mêmes consignes, 1 000 caractères.

```text
Character sheet, exactly 4 sprites in a 2x2 grid, plain flat white background, wide empty gaps, no overlap, no text, no frame. ONE enemy monster: Automate de combat. heavy combat automaton of riveted bronze (#B8873A) and grey stone plates; small dome head with a glowing blue visor slit (#3FC8FF); huge fists, small smoking pipe on the back. It holds nothing in its hands, paws or claws. Top row: two front 3/4 views facing right, two slightly different relaxed stances (not mirrored). Bottom row: two views from behind, facing away toward the upper right, no face visible, two different stances. Same outfit, colors and size in all 4, feet on one line. Style: smooth hand-drawn vector cartoon, thick dark outlines, Dofus / Waven look, NOT pixel art. Never facing left. Forbidden: no human face, no held item.
```

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Automate de combat — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Automate de combat, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Automate de combat (enemy of the Rouages nation)
- Body: heavy combat automaton of riveted bronze (#B8873A) and grey stone plates
- Head: small dome head with a glowing blue visor slit (#3FC8FF)
- Details: huge fists, small smoking pipe on the back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human face, no held item.
TASK: REMOVE every held item, torch, tool or held object from the hands, claws or tail — this creature is item-free. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in every cell; it acts only with its own body (claws, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Automate de combat: heavy combat automaton of riveted bronze (#B8873A) and grey stone plates; small dome head with a glowing blue visor slit (#3FC8FF); huge fists, small smoking pipe on the back. NO held item and no held object, ever. Forbidden: no human face, no held item. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Automate de combat — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Automate de combat, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Automate de combat (enemy of the Rouages nation)
- Body: heavy combat automaton of riveted bronze (#B8873A) and grey stone plates
- Head: small dome head with a glowing blue visor slit (#3FC8FF)
- Details: huge fists, small smoking pipe on the back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human face, no held item.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 6 poses; it acts only with its own body (claws, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm brass highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: both fists or held item raised high above the head — silhouette: tall and vertical, limbs raised above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward — silhouette: wide and horizontal, body stretched far forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. ROOTED: stomping, sparks, steam puffs and teal electric arcs cracks spreading under the feet — silhouette: compact and rounded, hands gathered near the chest.
5. GATHER: arms raised, sparks, steam puffs and teal electric arcs gathering between the hands — silhouette: tall, both arms thrown up or spread wide.
6. WALK: heavy mid-stride, one foot raised, arms swinging — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Automate de combat: heavy combat automaton of riveted bronze (#B8873A) and grey stone plates; small dome head with a glowing blue visor slit (#3FC8FF); huge fists, small smoking pipe on the back. NO held item and no held object, ever. Forbidden: no human face, no held item. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `automate_de_combat_attack.png` |
| 1-2 | attaque 2 | `automate_de_combat_attack_2.png` |
| 1-3 | attaque 3 | `automate_de_combat_attack_3.png` |
| 2-1 | sort 1 | `automate_de_combat_cast.png` |
| 2-2 | sort 2 | `automate_de_combat_cast_2.png` |
| 2-3 | marche | `automate_de_combat_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Automate de combat — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Automate de combat, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Automate de combat (enemy of the Rouages nation)
- Body: heavy combat automaton of riveted bronze (#B8873A) and grey stone plates
- Head: small dome head with a glowing blue visor slit (#3FC8FF)
- Details: huge fists, small smoking pipe on the back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human face, no held item.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 6 poses; it acts only with its own body (claws, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm brass highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: both fists or held item raised high above the head — silhouette: tall and vertical, limbs raised above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward — silhouette: wide and horizontal, body stretched far forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. ROOTED: stomping, sparks, steam puffs and teal electric arcs cracks spreading under the feet — silhouette: compact and rounded, hands gathered near the chest.
5. GATHER: arms raised, sparks, steam puffs and teal electric arcs gathering between the hands — silhouette: tall, both arms thrown up or spread wide.
6. WALK: heavy mid-stride, one foot raised, arms swinging — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Automate de combat: heavy combat automaton of riveted bronze (#B8873A) and grey stone plates; small dome head with a glowing blue visor slit (#3FC8FF); huge fists, small smoking pipe on the back. NO held item and no held object, ever. Forbidden: no human face, no held item. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `automate_de_combat_back_attack.png` |
| 1-2 | attaque 2 — dos | `automate_de_combat_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `automate_de_combat_back_attack_3.png` |
| 2-1 | sort 1 — dos | `automate_de_combat_back_cast.png` |
| 2-2 | sort 2 — dos | `automate_de_combat_back_cast_2.png` |
| 2-3 | marche — dos | `automate_de_combat_back_walk.png` |

## 4. Boss

### Mécanoptère, Colosse d'Engrenages — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `rouages_vues.png`, `rouages_actions.png` et `rouages_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE final boss: Mécanoptère, Colosse d'Engrenages, carrying: huge gear hammer, RIGHT hand.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Mécanoptère, Colosse d'Engrenages (boss of the Rouages nation)
- Body: giant steam colossus of steel and brass (#B8873A) with two smoking chimneys on the back
- Head: riveted steel head with two glowing blue eyes
- Details: glowing blue core in the chest
- Held item: huge gear hammer, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no human face.
HELD ITEM: huge gear hammer, RIGHT hand. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm brass highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm. The huge gear hammer is held in the right hand and fully visible in this cell.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the held item stays in its hand); the face is visible and the drawing must not be a copy of cell 1. The huge gear hammer is held in the right hand and fully visible in this cell.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile. The huge gear hammer is held in the right hand and fully visible in this cell.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the held item stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3. The huge gear hammer is held in the right hand and fully visible in this cell.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: huge gear hammer, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Mécanoptère, Colosse d'Engrenages: huge gear hammer, RIGHT hand; giant steam colossus of steel and brass (#B8873A) with two smoking chimneys on the back; riveted steel head with two glowing blue eyes; glowing blue core in the chest. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no wings, no human face. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `rouages.png` |
| 1-2 | repos de face, variante | `rouages_idle_2.png` |
| 2-1 | repos de dos | `rouages_back.png` |
| 2-2 | repos de dos, variante | `rouages_back_idle_2.png` |

##### Version courte de la planche vues

À utiliser si le générateur reformule le prompt, bloque sur un mot ou ne respecte pas le nombre de cases : mêmes consignes, 1 000 caractères.

```text
Character sheet, exactly 4 sprites in a 2x2 grid, plain flat white background, wide empty gaps, no overlap, no text, no frame. ONE final boss: Mécanoptère, Colosse d'Engrenages. giant steam colossus of steel and brass (#B8873A) with two smoking chimneys on the back; riveted steel head with two glowing blue eyes; glowing blue core in the chest; huge gear hammer, RIGHT hand. It always holds the huge gear hammer in the right hand, clearly visible in all 4 sprites. Top row: two front 3/4 views facing right, two slightly different relaxed stances (not mirrored). Bottom row: two views from behind, facing away toward the upper right, no face visible, two different stances. Same outfit, colors and size in all 4, feet on one line. Style: smooth hand-drawn vector cartoon, thick dark outlines, Dofus / Waven look, NOT pixel art. Never facing left. Forbidden: no wings, no human face.
```

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE final boss: Mécanoptère, Colosse d'Engrenages, carrying: huge gear hammer, RIGHT hand.
SOURCE IMAGE: it shows this final boss, Mécanoptère, Colosse d'Engrenages, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Mécanoptère, Colosse d'Engrenages (boss of the Rouages nation)
- Body: giant steam colossus of steel and brass (#B8873A) with two smoking chimneys on the back
- Head: riveted steel head with two glowing blue eyes
- Details: glowing blue core in the chest
- Held item: huge gear hammer, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no human face.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its held item in the correct hand — add the held item where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm. The huge gear hammer is held in the right hand and fully visible in this cell.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the held item stays in its hand); the face is visible and the drawing must not be a copy of cell 1. The huge gear hammer is held in the right hand and fully visible in this cell.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile. The huge gear hammer is held in the right hand and fully visible in this cell.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the held item stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3. The huge gear hammer is held in the right hand and fully visible in this cell.
HELD ITEM: huge gear hammer, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Mécanoptère, Colosse d'Engrenages: huge gear hammer, RIGHT hand; giant steam colossus of steel and brass (#B8873A) with two smoking chimneys on the back; riveted steel head with two glowing blue eyes; glowing blue core in the chest. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no wings, no human face. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE final boss: Mécanoptère, Colosse d'Engrenages, carrying: huge gear hammer, RIGHT hand.
SOURCE IMAGE: it shows this final boss, Mécanoptère, Colosse d'Engrenages, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, held item in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Mécanoptère, Colosse d'Engrenages (boss of the Rouages nation)
- Body: giant steam colossus of steel and brass (#B8873A) with two smoking chimneys on the back
- Head: riveted steel head with two glowing blue eyes
- Details: glowing blue core in the chest
- Held item: huge gear hammer, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no human face.
HELD ITEM: huge gear hammer, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm brass highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: both fists or held item raised high above the head — silhouette: tall and vertical, limbs raised above the head. The huge gear hammer is held in the right hand and fully visible in this cell.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward — silhouette: wide and horizontal, body stretched far forward. The huge gear hammer is held in the right hand and fully visible in this cell.
3. BACKHAND: arm swept horizontally to the side, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach. The huge gear hammer is held in the right hand and fully visible in this cell.
4. ROOTED: stomping, sparks, steam puffs and teal electric arcs cracks spreading under the feet — silhouette: compact and rounded, hands gathered near the chest. The huge gear hammer is held in the right hand and fully visible in this cell.
5. GATHER: arms raised, sparks, steam puffs and teal electric arcs gathering between the hands — silhouette: tall, both arms thrown up or spread wide. The huge gear hammer is held in the right hand and fully visible in this cell.
6. WALK: heavy mid-stride, one foot raised, arms swinging — silhouette: mid-stride with legs clearly apart, moving forward. The huge gear hammer is held in the right hand and fully visible in this cell.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: huge gear hammer, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Mécanoptère, Colosse d'Engrenages: huge gear hammer, RIGHT hand; giant steam colossus of steel and brass (#B8873A) with two smoking chimneys on the back; riveted steel head with two glowing blue eyes; glowing blue core in the chest. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no wings, no human face. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `rouages_attack.png` |
| 1-2 | attaque 2 | `rouages_attack_2.png` |
| 1-3 | attaque 3 | `rouages_attack_3.png` |
| 2-1 | sort 1 | `rouages_cast.png` |
| 2-2 | sort 2 | `rouages_cast_2.png` |
| 2-3 | marche | `rouages_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE final boss: Mécanoptère, Colosse d'Engrenages, carrying: huge gear hammer, RIGHT hand.
SOURCE IMAGE: it shows this final boss, Mécanoptère, Colosse d'Engrenages, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, held item in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Mécanoptère, Colosse d'Engrenages (boss of the Rouages nation)
- Body: giant steam colossus of steel and brass (#B8873A) with two smoking chimneys on the back
- Head: riveted steel head with two glowing blue eyes
- Details: glowing blue core in the chest
- Held item: huge gear hammer, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no human face.
HELD ITEM: huge gear hammer, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm brass highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: both fists or held item raised high above the head — silhouette: tall and vertical, limbs raised above the head. The huge gear hammer is held in the right hand and fully visible in this cell.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward — silhouette: wide and horizontal, body stretched far forward. The huge gear hammer is held in the right hand and fully visible in this cell.
3. BACKHAND: arm swept horizontally to the side, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach. The huge gear hammer is held in the right hand and fully visible in this cell.
4. ROOTED: stomping, sparks, steam puffs and teal electric arcs cracks spreading under the feet — silhouette: compact and rounded, hands gathered near the chest. The huge gear hammer is held in the right hand and fully visible in this cell.
5. GATHER: arms raised, sparks, steam puffs and teal electric arcs gathering between the hands — silhouette: tall, both arms thrown up or spread wide. The huge gear hammer is held in the right hand and fully visible in this cell.
6. WALK: heavy mid-stride, one foot raised, arms swinging — silhouette: mid-stride with legs clearly apart, moving forward. The huge gear hammer is held in the right hand and fully visible in this cell.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: huge gear hammer, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Mécanoptère, Colosse d'Engrenages: huge gear hammer, RIGHT hand; giant steam colossus of steel and brass (#B8873A) with two smoking chimneys on the back; riveted steel head with two glowing blue eyes; glowing blue core in the chest. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no wings, no human face. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `rouages_back_attack.png` |
| 1-2 | attaque 2 — dos | `rouages_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `rouages_back_attack_3.png` |
| 2-1 | sort 1 — dos | `rouages_back_cast.png` |
| 2-2 | sort 2 — dos | `rouages_back_cast_2.png` |
| 2-3 | marche — dos | `rouages_back_walk.png` |

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
