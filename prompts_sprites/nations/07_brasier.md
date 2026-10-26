# Nation Brasier (Brasier)

Palette : crimson red, black obsidian, ember orange, gold. Effets : flames and embers. Contre-jour : orange ember.

Format 3 planches par personnage (V44) :

1. **Vues** — 4 cases : repos de FACE ×2 (deux attitudes différentes) puis repos de DOS ×2, tout orienté vers la droite (le jeu retourne l'image pour la gauche). Grille 2 × 2 sur image 2:1, poses largement espacées. Génération normale.
2. **Actions de face** — 3 attaques + 2 sorts + 1 marche (3 colonnes × 2 rangées), en **édition** de la planche vues : le personnage réellement dessiné sert d'ancre.
3. **Actions de dos** — les mêmes 6 poses vues de dos, en édition de la planche vues. Une planche = un seul sens de vue (face et dos mélangés sur une même planche étaient dessinés de face). Facultative pour les monstres.

Les personnages **armés** ont l'arme écrite dans la première phrase, dans la carte d'identité, en fin de prompt et dans chaque pose ; les **créatures** reçoivent « UNARMED » (plus de torche inventée). Chaque prompt recopie la carte d'identité (`identites.py`) : aucune image à joindre. Ordre conseillé : 1) planche de style, 2) héros, 3) ennemis, 4) boss ; pour chaque personnage : vues, actions de face, actions de dos. Prompt négatif : en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Brasier nation (Brasier biome).
NATION PALETTE: crimson red, black obsidian, ember orange, gold. Signature effects: flames and embers.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle orange ember highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: two rows with the same 6 characters in the same order, all in idle pose. Top row: 3/4 front view, facing front-right. Bottom row: 3/4 back view, seen from behind, turned toward the upper right. All feet of a row on the same ground line. Leave a wide empty gap (at least half a character width) between characters and between the two rows: nobody overlaps or touches anyone, held items and capes included. Image aspect ratio 2:1, as large as possible.
CHARACTERS, left to right:
1. the hero (Chasseur: hunter with long red hair in a high ponytail, black armor with gold trims and red flame-shaped plates and glowing ember cracks, a red scarf and short red flame-hem cape, quiver of arrows on the back, a curved flame-patterned bow in the left hand).
2. Lieutenant (fire hooded lieutenant in orange and red robes holding a flaming staff).
3. Salamandre (chubby orange lava lizard standing upright, glowing cracks on its back and a flaming tail).
4. Dévoreur de flammes (stocky upright fiery orange beast with two curved horns, a mane of flames and big claws).
5. Golem de lave (dark basalt golem with bright orange lava cracks and a molten core).
6. the final boss Kharaz le Flamboyant (flame warlord with burning hair, black and crimson ember armor with sharp plates, holding a great curved flame bow), about 1.5x taller than the others.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Chasseur — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `chasseur_vues.png`, `chasseur_actions.png` et `chasseur_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE playable hero: Chasseur, carrying: curved flame-patterned bow in the LEFT hand, quiver of arrows on the back.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Chasseur (hero of the Brasier nation)
- Hair: long bright red hair (#D6332A) in a high ponytail
- Eyes: golden eyes, always open
- Skin: fair skin
- Top: black armor with gold trims and red flame-shaped plates (#1E1A1C, #C8281E) and glowing ember cracks, red scarf, short red cape with a flame-patterned hem
- Bottom: black trousers with red armored thigh plates
- Feet: brown boots with gold trims
- Held item: curved flame-patterned bow in the LEFT hand, quiver of arrows on the back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword, no brown hair.
HELD ITEM: curved flame-patterned bow in the LEFT hand, quiver of arrows on the back. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle orange ember highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm. The curved flame-patterned bow in the LEFT hand is held in the right hand and fully visible in this cell.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the held item stays in its hand); the face is visible and the drawing must not be a copy of cell 1. The curved flame-patterned bow in the LEFT hand is held in the right hand and fully visible in this cell.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile. The curved flame-patterned bow in the LEFT hand is held in the right hand and fully visible in this cell.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the held item stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3. The curved flame-patterned bow in the LEFT hand is held in the right hand and fully visible in this cell.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: curved flame-patterned bow in the LEFT hand, quiver of arrows on the back. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Chasseur: curved flame-patterned bow in the LEFT hand, quiver of arrows on the back; long bright red hair (#D6332A) in a high ponytail; golden eyes, always open; black armor with gold trims and red flame-shaped plates (#1E1A1C, #C8281E) and glowing ember cracks, red scarf, short red cape with a flame-patterned hem; fair skin; black trousers with red armored thigh plates; brown boots with gold trims. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no sword, no brown hair. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `chasseur.png` |
| 1-2 | repos de face, variante | `chasseur_idle_2.png` |
| 2-1 | repos de dos | `chasseur_back.png` |
| 2-2 | repos de dos, variante | `chasseur_back_idle_2.png` |

##### Version courte de la planche vues

À utiliser si le générateur reformule le prompt, bloque sur un mot ou ne respecte pas le nombre de cases : mêmes consignes, 1 000 caractères.

```text
Character sheet, exactly 4 sprites in a 2x2 grid, plain flat white background, wide empty gaps, no overlap, no text, no frame. ONE playable hero: Chasseur. long bright red hair (#D6332A) in a high ponytail; golden eyes, always open; fair skin; black armor with gold trims and red flame-shaped plates (#1E1A1C, #C8281E) and glowing ember cracks, red scarf, short red cape with a flame-patterned hem; black trousers with red armored thigh plates; brown boots with gold trims; curved flame-patterned bow in the LEFT hand, quiver of arrows on the back. It always holds the curved flame-patterned bow in the LEFT hand in the right hand, clearly visible in all 4 sprites. Top row: two front 3/4 views facing right, two slightly different relaxed stances (not mirrored). Bottom row: two views from behind, facing away toward the upper right, no face visible, two different stances. Same outfit, colors and size in all 4, feet on one line. Style: smooth hand-drawn vector cartoon, thick dark outlines, Dofus / Waven look, NOT pixel art. Never facing left. Forbidden: no helmet, no sword, no brown hair.
```

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE playable hero: Chasseur, carrying: curved flame-patterned bow in the LEFT hand, quiver of arrows on the back.
SOURCE IMAGE: it shows this playable hero, Chasseur, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Chasseur (hero of the Brasier nation)
- Hair: long bright red hair (#D6332A) in a high ponytail
- Eyes: golden eyes, always open
- Skin: fair skin
- Top: black armor with gold trims and red flame-shaped plates (#1E1A1C, #C8281E) and glowing ember cracks, red scarf, short red cape with a flame-patterned hem
- Bottom: black trousers with red armored thigh plates
- Feet: brown boots with gold trims
- Held item: curved flame-patterned bow in the LEFT hand, quiver of arrows on the back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword, no brown hair.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its held item in the correct hand — add the held item where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm. The curved flame-patterned bow in the LEFT hand is held in the right hand and fully visible in this cell.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the held item stays in its hand); the face is visible and the drawing must not be a copy of cell 1. The curved flame-patterned bow in the LEFT hand is held in the right hand and fully visible in this cell.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile. The curved flame-patterned bow in the LEFT hand is held in the right hand and fully visible in this cell.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the held item stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3. The curved flame-patterned bow in the LEFT hand is held in the right hand and fully visible in this cell.
HELD ITEM: curved flame-patterned bow in the LEFT hand, quiver of arrows on the back. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Chasseur: curved flame-patterned bow in the LEFT hand, quiver of arrows on the back; long bright red hair (#D6332A) in a high ponytail; golden eyes, always open; black armor with gold trims and red flame-shaped plates (#1E1A1C, #C8281E) and glowing ember cracks, red scarf, short red cape with a flame-patterned hem; fair skin; black trousers with red armored thigh plates; brown boots with gold trims. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no sword, no brown hair. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE playable hero: Chasseur, carrying: curved flame-patterned bow in the LEFT hand, quiver of arrows on the back.
SOURCE IMAGE: it shows this playable hero, Chasseur, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, held item in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Chasseur (hero of the Brasier nation)
- Hair: long bright red hair (#D6332A) in a high ponytail
- Eyes: golden eyes, always open
- Skin: fair skin
- Top: black armor with gold trims and red flame-shaped plates (#1E1A1C, #C8281E) and glowing ember cracks, red scarf, short red cape with a flame-patterned hem
- Bottom: black trousers with red armored thigh plates
- Feet: brown boots with gold trims
- Held item: curved flame-patterned bow in the LEFT hand, quiver of arrows on the back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword, no brown hair.
HELD ITEM: curved flame-patterned bow in the LEFT hand, quiver of arrows on the back. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle orange ember highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. SKY SHOT: bow pointed almost straight up, string fully drawn — silhouette: tall and vertical, limbs raised above the head. The curved flame-patterned bow in the LEFT hand is held in the right hand and fully visible in this cell.
2. FULL DRAW: bow aimed straight forward, string pulled to the cheek, body sideways — silhouette: wide and horizontal, body stretched far forward. The curved flame-patterned bow in the LEFT hand is held in the right hand and fully visible in this cell.
3. RELEASE: string hand open behind, bow arm extended, arrow leaving with a flames and embers trail — silhouette: low and wide, crouched or twisted with a long side reach. The curved flame-patterned bow in the LEFT hand is held in the right hand and fully visible in this cell.
4. ENCHANTED ARROW: arrow held up to the face, its tip wrapped in flames and embers — silhouette: compact and rounded, hands gathered near the chest. The curved flame-patterned bow in the LEFT hand is held in the right hand and fully visible in this cell.
5. VOLLEY: bow raised overhead, three flames and embers arrows rising into the air — silhouette: tall, both arms thrown up or spread wide. The curved flame-patterned bow in the LEFT hand is held in the right hand and fully visible in this cell.
6. WALK: mid-stride, one foot raised, arms swinging naturally, held item held — silhouette: mid-stride with legs clearly apart, moving forward. The curved flame-patterned bow in the LEFT hand is held in the right hand and fully visible in this cell.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: curved flame-patterned bow in the LEFT hand, quiver of arrows on the back — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Chasseur: curved flame-patterned bow in the LEFT hand, quiver of arrows on the back; long bright red hair (#D6332A) in a high ponytail; golden eyes, always open; black armor with gold trims and red flame-shaped plates (#1E1A1C, #C8281E) and glowing ember cracks, red scarf, short red cape with a flame-patterned hem; fair skin; black trousers with red armored thigh plates; brown boots with gold trims. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no sword, no brown hair. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `chasseur_attack.png` |
| 1-2 | attaque 2 | `chasseur_attack_2.png` |
| 1-3 | attaque 3 | `chasseur_attack_3.png` |
| 2-1 | sort 1 | `chasseur_cast.png` |
| 2-2 | sort 2 | `chasseur_cast_2.png` |
| 2-3 | marche | `chasseur_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE playable hero: Chasseur, carrying: curved flame-patterned bow in the LEFT hand, quiver of arrows on the back.
SOURCE IMAGE: it shows this playable hero, Chasseur, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, held item in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Chasseur (hero of the Brasier nation)
- Hair: long bright red hair (#D6332A) in a high ponytail
- Eyes: golden eyes, always open
- Skin: fair skin
- Top: black armor with gold trims and red flame-shaped plates (#1E1A1C, #C8281E) and glowing ember cracks, red scarf, short red cape with a flame-patterned hem
- Bottom: black trousers with red armored thigh plates
- Feet: brown boots with gold trims
- Held item: curved flame-patterned bow in the LEFT hand, quiver of arrows on the back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword, no brown hair.
HELD ITEM: curved flame-patterned bow in the LEFT hand, quiver of arrows on the back. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle orange ember highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. SKY SHOT: bow pointed almost straight up, string fully drawn — silhouette: tall and vertical, limbs raised above the head. The curved flame-patterned bow in the LEFT hand is held in the right hand and fully visible in this cell.
2. FULL DRAW: bow aimed straight forward, string pulled to the cheek, body sideways — silhouette: wide and horizontal, body stretched far forward. The curved flame-patterned bow in the LEFT hand is held in the right hand and fully visible in this cell.
3. RELEASE: string hand open behind, bow arm extended, arrow leaving with a flames and embers trail — silhouette: low and wide, crouched or twisted with a long side reach. The curved flame-patterned bow in the LEFT hand is held in the right hand and fully visible in this cell.
4. ENCHANTED ARROW: arrow held up to the face, its tip wrapped in flames and embers — silhouette: compact and rounded, hands gathered near the chest. The curved flame-patterned bow in the LEFT hand is held in the right hand and fully visible in this cell.
5. VOLLEY: bow raised overhead, three flames and embers arrows rising into the air — silhouette: tall, both arms thrown up or spread wide. The curved flame-patterned bow in the LEFT hand is held in the right hand and fully visible in this cell.
6. WALK: mid-stride, one foot raised, arms swinging naturally, held item held — silhouette: mid-stride with legs clearly apart, moving forward. The curved flame-patterned bow in the LEFT hand is held in the right hand and fully visible in this cell.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: curved flame-patterned bow in the LEFT hand, quiver of arrows on the back — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Chasseur: curved flame-patterned bow in the LEFT hand, quiver of arrows on the back; long bright red hair (#D6332A) in a high ponytail; golden eyes, always open; black armor with gold trims and red flame-shaped plates (#1E1A1C, #C8281E) and glowing ember cracks, red scarf, short red cape with a flame-patterned hem; fair skin; black trousers with red armored thigh plates; brown boots with gold trims. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no sword, no brown hair. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `chasseur_back_attack.png` |
| 1-2 | attaque 2 — dos | `chasseur_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `chasseur_back_attack_3.png` |
| 2-1 | sort 1 — dos | `chasseur_back_cast.png` |
| 2-2 | sort 2 — dos | `chasseur_back_cast_2.png` |
| 2-3 | marche — dos | `chasseur_back_walk.png` |

L'export Zimut de l'Atelier copie aussi le repos (case 1 de la planche vues) vers `nations/heros/chasseur.png`.

## 3. Ennemis

### Lieutenant — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brasier/` ; nomme tes images `lieutenant_vues.png`, `lieutenant_actions.png` et `lieutenant_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Lieutenant, carrying: black staff topped with a burning flame, RIGHT hand.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Lieutenant (enemy of the Brasier nation)
- Hair: hood up, face in shadow with two glowing orange eyes (#FF8A2A)
- Top: orange and red layered cultist robes (#E06A1E, #B0201A) with a black belt
- Bottom: long robe to the ankles
- Feet: black boots
- Held item: black staff topped with a burning flame, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visible face, no armor, no sword.
HELD ITEM: black staff topped with a burning flame, RIGHT hand. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle orange ember highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm. The black staff topped with a burning flame is held in the right hand and fully visible in this cell.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the held item stays in its hand); the face is visible and the drawing must not be a copy of cell 1. The black staff topped with a burning flame is held in the right hand and fully visible in this cell.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile. The black staff topped with a burning flame is held in the right hand and fully visible in this cell.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the held item stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3. The black staff topped with a burning flame is held in the right hand and fully visible in this cell.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: black staff topped with a burning flame, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Lieutenant: black staff topped with a burning flame, RIGHT hand; hood up, face in shadow with two glowing orange eyes (#FF8A2A); orange and red layered cultist robes (#E06A1E, #B0201A) with a black belt; long robe to the ankles; black boots. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no visible face, no armor, no sword. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `lieutenant.png` |
| 1-2 | repos de face, variante | `lieutenant_idle_2.png` |
| 2-1 | repos de dos | `lieutenant_back.png` |
| 2-2 | repos de dos, variante | `lieutenant_back_idle_2.png` |

##### Version courte de la planche vues

À utiliser si le générateur reformule le prompt, bloque sur un mot ou ne respecte pas le nombre de cases : mêmes consignes, 1 000 caractères.

```text
Character sheet, exactly 4 sprites in a 2x2 grid, plain flat white background, wide empty gaps, no overlap, no text, no frame. ONE enemy monster: Lieutenant. hood up, face in shadow with two glowing orange eyes (#FF8A2A); orange and red layered cultist robes (#E06A1E, #B0201A) with a black belt; long robe to the ankles; black boots; black staff topped with a burning flame, RIGHT hand. It always holds the black staff topped with a burning flame in the right hand, clearly visible in all 4 sprites. Top row: two front 3/4 views facing right, two slightly different relaxed stances (not mirrored). Bottom row: two views from behind, facing away toward the upper right, no face visible, two different stances. Same outfit, colors and size in all 4, feet on one line. Style: smooth hand-drawn vector cartoon, thick dark outlines, Dofus / Waven look, NOT pixel art. Never facing left. Forbidden: no visible face, no armor, no sword.
```

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Lieutenant, carrying: black staff topped with a burning flame, RIGHT hand.
SOURCE IMAGE: it shows this enemy monster, Lieutenant, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Lieutenant (enemy of the Brasier nation)
- Hair: hood up, face in shadow with two glowing orange eyes (#FF8A2A)
- Top: orange and red layered cultist robes (#E06A1E, #B0201A) with a black belt
- Bottom: long robe to the ankles
- Feet: black boots
- Held item: black staff topped with a burning flame, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visible face, no armor, no sword.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its held item in the correct hand — add the held item where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm. The black staff topped with a burning flame is held in the right hand and fully visible in this cell.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the held item stays in its hand); the face is visible and the drawing must not be a copy of cell 1. The black staff topped with a burning flame is held in the right hand and fully visible in this cell.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile. The black staff topped with a burning flame is held in the right hand and fully visible in this cell.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the held item stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3. The black staff topped with a burning flame is held in the right hand and fully visible in this cell.
HELD ITEM: black staff topped with a burning flame, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Lieutenant: black staff topped with a burning flame, RIGHT hand; hood up, face in shadow with two glowing orange eyes (#FF8A2A); orange and red layered cultist robes (#E06A1E, #B0201A) with a black belt; long robe to the ankles; black boots. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no visible face, no armor, no sword. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Lieutenant, carrying: black staff topped with a burning flame, RIGHT hand.
SOURCE IMAGE: it shows this enemy monster, Lieutenant, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, held item in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Lieutenant (enemy of the Brasier nation)
- Hair: hood up, face in shadow with two glowing orange eyes (#FF8A2A)
- Top: orange and red layered cultist robes (#E06A1E, #B0201A) with a black belt
- Bottom: long robe to the ankles
- Feet: black boots
- Held item: black staff topped with a burning flame, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visible face, no armor, no sword.
HELD ITEM: black staff topped with a burning flame, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle orange ember highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands — silhouette: tall and vertical, limbs raised above the head. The black staff topped with a burning flame is held in the right hand and fully visible in this cell.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short flames and embers spark — silhouette: wide and horizontal, body stretched far forward. The black staff topped with a burning flame is held in the right hand and fully visible in this cell.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach. The black staff topped with a burning flame is held in the right hand and fully visible in this cell.
4. FOCUS: eyes closed, staff held vertically in front of the face, flames and embers orb at the top — silhouette: compact and rounded, hands gathered near the chest. The black staff topped with a burning flame is held in the right hand and fully visible in this cell.
5. INVOCATION: staff raised high with both hands, flames and embers swirling above the head — silhouette: tall, both arms thrown up or spread wide. The black staff topped with a burning flame is held in the right hand and fully visible in this cell.
6. WALK: mid-stride, one foot raised, arms swinging naturally, held item held — silhouette: mid-stride with legs clearly apart, moving forward. The black staff topped with a burning flame is held in the right hand and fully visible in this cell.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: black staff topped with a burning flame, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Lieutenant: black staff topped with a burning flame, RIGHT hand; hood up, face in shadow with two glowing orange eyes (#FF8A2A); orange and red layered cultist robes (#E06A1E, #B0201A) with a black belt; long robe to the ankles; black boots. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no visible face, no armor, no sword. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `lieutenant_attack.png` |
| 1-2 | attaque 2 | `lieutenant_attack_2.png` |
| 1-3 | attaque 3 | `lieutenant_attack_3.png` |
| 2-1 | sort 1 | `lieutenant_cast.png` |
| 2-2 | sort 2 | `lieutenant_cast_2.png` |
| 2-3 | marche | `lieutenant_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Lieutenant, carrying: black staff topped with a burning flame, RIGHT hand.
SOURCE IMAGE: it shows this enemy monster, Lieutenant, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, held item in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Lieutenant (enemy of the Brasier nation)
- Hair: hood up, face in shadow with two glowing orange eyes (#FF8A2A)
- Top: orange and red layered cultist robes (#E06A1E, #B0201A) with a black belt
- Bottom: long robe to the ankles
- Feet: black boots
- Held item: black staff topped with a burning flame, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visible face, no armor, no sword.
HELD ITEM: black staff topped with a burning flame, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle orange ember highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands — silhouette: tall and vertical, limbs raised above the head. The black staff topped with a burning flame is held in the right hand and fully visible in this cell.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short flames and embers spark — silhouette: wide and horizontal, body stretched far forward. The black staff topped with a burning flame is held in the right hand and fully visible in this cell.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach. The black staff topped with a burning flame is held in the right hand and fully visible in this cell.
4. FOCUS: eyes closed, staff held vertically in front of the face, flames and embers orb at the top — silhouette: compact and rounded, hands gathered near the chest. The black staff topped with a burning flame is held in the right hand and fully visible in this cell.
5. INVOCATION: staff raised high with both hands, flames and embers swirling above the head — silhouette: tall, both arms thrown up or spread wide. The black staff topped with a burning flame is held in the right hand and fully visible in this cell.
6. WALK: mid-stride, one foot raised, arms swinging naturally, held item held — silhouette: mid-stride with legs clearly apart, moving forward. The black staff topped with a burning flame is held in the right hand and fully visible in this cell.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: black staff topped with a burning flame, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Lieutenant: black staff topped with a burning flame, RIGHT hand; hood up, face in shadow with two glowing orange eyes (#FF8A2A); orange and red layered cultist robes (#E06A1E, #B0201A) with a black belt; long robe to the ankles; black boots. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no visible face, no armor, no sword. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `lieutenant_back_attack.png` |
| 1-2 | attaque 2 — dos | `lieutenant_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `lieutenant_back_attack_3.png` |
| 2-1 | sort 1 — dos | `lieutenant_back_cast.png` |
| 2-2 | sort 2 — dos | `lieutenant_back_cast_2.png` |
| 2-3 | marche — dos | `lieutenant_back_walk.png` |

### Salamandre — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brasier/` ; nomme tes images `salamandre_vues.png`, `salamandre_actions.png` et `salamandre_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Salamandre — an NO HELD ITEM creature (no held item of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Salamandre (enemy of the Brasier nation)
- Body: chubby orange lava lizard (#E0701E) standing upright on two short hind legs with small front arms, darker orange back, cream belly
- Head: round head, big yellow eyes, small smile
- Details: glowing yellow cracks along the back, tail ending in a flame
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no armor, no held item, no torch, no held object.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 4 cells; it acts only with its own body (claws, fists, tail, magic). Never add an item.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle orange ember highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in every cell; it acts only with its own body (claws, fists, tail, magic). Never add an item.
REMINDER: this is Salamandre: chubby orange lava lizard (#E0701E) standing upright on two short hind legs with small front arms, darker orange back, cream belly; round head, big yellow eyes, small smile; glowing yellow cracks along the back, tail ending in a flame. NO held item and no held object, ever. Forbidden: no wings, no armor, no held item, no torch, no held object. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `salamandre.png` |
| 1-2 | repos de face, variante | `salamandre_idle_2.png` |
| 2-1 | repos de dos | `salamandre_back.png` |
| 2-2 | repos de dos, variante | `salamandre_back_idle_2.png` |

##### Version courte de la planche vues

À utiliser si le générateur reformule le prompt, bloque sur un mot ou ne respecte pas le nombre de cases : mêmes consignes, 1 000 caractères.

```text
Character sheet, exactly 4 sprites in a 2x2 grid, plain flat white background, wide empty gaps, no overlap, no text, no frame. ONE enemy monster: Salamandre. chubby orange lava lizard (#E0701E) standing upright on two short hind legs with small front arms, darker orange back, cream belly; round head, big yellow eyes, small smile; glowing yellow cracks along the back, tail ending in a flame. It holds nothing in its hands, paws or claws. Top row: two front 3/4 views facing right, two slightly different relaxed stances (not mirrored). Bottom row: two views from behind, facing away toward the upper right, no face visible, two different stances. Same outfit, colors and size in all 4, feet on one line. Style: smooth hand-drawn vector cartoon, thick dark outlines, Dofus / Waven look, NOT pixel art. Never facing left. Forbidden: no wings, no armor, no held item, no torch, no held object.
```

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Salamandre — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Salamandre, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Salamandre (enemy of the Brasier nation)
- Body: chubby orange lava lizard (#E0701E) standing upright on two short hind legs with small front arms, darker orange back, cream belly
- Head: round head, big yellow eyes, small smile
- Details: glowing yellow cracks along the back, tail ending in a flame
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no armor, no held item, no torch, no held object.
TASK: REMOVE every held item, torch, tool or held object from the hands, claws or tail — this creature is item-free. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in every cell; it acts only with its own body (claws, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Salamandre: chubby orange lava lizard (#E0701E) standing upright on two short hind legs with small front arms, darker orange back, cream belly; round head, big yellow eyes, small smile; glowing yellow cracks along the back, tail ending in a flame. NO held item and no held object, ever. Forbidden: no wings, no armor, no held item, no torch, no held object. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Salamandre — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Salamandre, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Salamandre (enemy of the Brasier nation)
- Body: chubby orange lava lizard (#E0701E) standing upright on two short hind legs with small front arms, darker orange back, cream belly
- Head: round head, big yellow eyes, small smile
- Details: glowing yellow cracks along the back, tail ending in a flame
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no armor, no held item, no torch, no held object.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 6 poses; it acts only with its own body (claws, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle orange ember highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high — silhouette: tall and vertical, limbs raised above the head.
2. POUNCE: body stretched forward in the air, jaws open — silhouette: wide and horizontal, body stretched far forward.
3. SIDE SWIPE: head and claws swept to the side, body twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. HOWL: head raised to the sky, flames and embers gathering around the body — silhouette: compact and rounded, hands gathered near the chest.
5. ROAR: mouth wide open, flames and embers burst in front of the head — silhouette: tall, both arms thrown up or spread wide.
6. WALK: mid-stride, one front paw raised, body moving forward — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Salamandre: chubby orange lava lizard (#E0701E) standing upright on two short hind legs with small front arms, darker orange back, cream belly; round head, big yellow eyes, small smile; glowing yellow cracks along the back, tail ending in a flame. NO held item and no held object, ever. Forbidden: no wings, no armor, no held item, no torch, no held object. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `salamandre_attack.png` |
| 1-2 | attaque 2 | `salamandre_attack_2.png` |
| 1-3 | attaque 3 | `salamandre_attack_3.png` |
| 2-1 | sort 1 | `salamandre_cast.png` |
| 2-2 | sort 2 | `salamandre_cast_2.png` |
| 2-3 | marche | `salamandre_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Salamandre — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Salamandre, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Salamandre (enemy of the Brasier nation)
- Body: chubby orange lava lizard (#E0701E) standing upright on two short hind legs with small front arms, darker orange back, cream belly
- Head: round head, big yellow eyes, small smile
- Details: glowing yellow cracks along the back, tail ending in a flame
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no armor, no held item, no torch, no held object.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 6 poses; it acts only with its own body (claws, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle orange ember highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high — silhouette: tall and vertical, limbs raised above the head.
2. POUNCE: body stretched forward in the air, jaws open — silhouette: wide and horizontal, body stretched far forward.
3. SIDE SWIPE: head and claws swept to the side, body twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. HOWL: head raised to the sky, flames and embers gathering around the body — silhouette: compact and rounded, hands gathered near the chest.
5. ROAR: mouth wide open, flames and embers burst in front of the head — silhouette: tall, both arms thrown up or spread wide.
6. WALK: mid-stride, one front paw raised, body moving forward — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Salamandre: chubby orange lava lizard (#E0701E) standing upright on two short hind legs with small front arms, darker orange back, cream belly; round head, big yellow eyes, small smile; glowing yellow cracks along the back, tail ending in a flame. NO held item and no held object, ever. Forbidden: no wings, no armor, no held item, no torch, no held object. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `salamandre_back_attack.png` |
| 1-2 | attaque 2 — dos | `salamandre_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `salamandre_back_attack_3.png` |
| 2-1 | sort 1 — dos | `salamandre_back_cast.png` |
| 2-2 | sort 2 — dos | `salamandre_back_cast_2.png` |
| 2-3 | marche — dos | `salamandre_back_walk.png` |

### Dévoreur de flammes — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brasier/` ; nomme tes images `devoreur_de_flammes_vues.png`, `devoreur_de_flammes_actions.png` et `devoreur_de_flammes_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Dévoreur de flammes — an NO HELD ITEM creature (no held item of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Dévoreur de flammes (enemy of the Brasier nation)
- Body: stocky upright fiery orange beast (#E05A1E) with a dark charcoal belly and two big curved dark horns
- Head: big jaw with fangs, glowing yellow eyes, mane of flames
- Details: big black claws, flaming tail tip
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no armor, no rider, no held item, no torch, no held object.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 4 cells; it acts only with its own body (claws, fists, tail, magic). Never add an item.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle orange ember highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in every cell; it acts only with its own body (claws, fists, tail, magic). Never add an item.
REMINDER: this is Dévoreur de flammes: stocky upright fiery orange beast (#E05A1E) with a dark charcoal belly and two big curved dark horns; big jaw with fangs, glowing yellow eyes, mane of flames; big black claws, flaming tail tip. NO held item and no held object, ever. Forbidden: no wings, no armor, no rider, no held item, no torch, no held object. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `devoreur_de_flammes.png` |
| 1-2 | repos de face, variante | `devoreur_de_flammes_idle_2.png` |
| 2-1 | repos de dos | `devoreur_de_flammes_back.png` |
| 2-2 | repos de dos, variante | `devoreur_de_flammes_back_idle_2.png` |

##### Version courte de la planche vues

À utiliser si le générateur reformule le prompt, bloque sur un mot ou ne respecte pas le nombre de cases : mêmes consignes, 1 000 caractères.

```text
Character sheet, exactly 4 sprites in a 2x2 grid, plain flat white background, wide empty gaps, no overlap, no text, no frame. ONE enemy monster: Dévoreur de flammes. stocky upright fiery orange beast (#E05A1E) with a dark charcoal belly and two big curved dark horns; big jaw with fangs, glowing yellow eyes, mane of flames; big black claws, flaming tail tip. It holds nothing in its hands, paws or claws. Top row: two front 3/4 views facing right, two slightly different relaxed stances (not mirrored). Bottom row: two views from behind, facing away toward the upper right, no face visible, two different stances. Same outfit, colors and size in all 4, feet on one line. Style: smooth hand-drawn vector cartoon, thick dark outlines, Dofus / Waven look, NOT pixel art. Never facing left. Forbidden: no wings, no armor, no rider, no held item, no torch, no held object.
```

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Dévoreur de flammes — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Dévoreur de flammes, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Dévoreur de flammes (enemy of the Brasier nation)
- Body: stocky upright fiery orange beast (#E05A1E) with a dark charcoal belly and two big curved dark horns
- Head: big jaw with fangs, glowing yellow eyes, mane of flames
- Details: big black claws, flaming tail tip
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no armor, no rider, no held item, no torch, no held object.
TASK: REMOVE every held item, torch, tool or held object from the hands, claws or tail — this creature is item-free. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in every cell; it acts only with its own body (claws, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Dévoreur de flammes: stocky upright fiery orange beast (#E05A1E) with a dark charcoal belly and two big curved dark horns; big jaw with fangs, glowing yellow eyes, mane of flames; big black claws, flaming tail tip. NO held item and no held object, ever. Forbidden: no wings, no armor, no rider, no held item, no torch, no held object. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Dévoreur de flammes — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Dévoreur de flammes, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Dévoreur de flammes (enemy of the Brasier nation)
- Body: stocky upright fiery orange beast (#E05A1E) with a dark charcoal belly and two big curved dark horns
- Head: big jaw with fangs, glowing yellow eyes, mane of flames
- Details: big black claws, flaming tail tip
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no armor, no rider, no held item, no torch, no held object.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 6 poses; it acts only with its own body (claws, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle orange ember highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high — silhouette: tall and vertical, limbs raised above the head.
2. POUNCE: body stretched forward in the air, jaws open — silhouette: wide and horizontal, body stretched far forward.
3. SIDE SWIPE: head and claws swept to the side, body twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. HOWL: head raised to the sky, flames and embers gathering around the body — silhouette: compact and rounded, hands gathered near the chest.
5. ROAR: mouth wide open, flames and embers burst in front of the head — silhouette: tall, both arms thrown up or spread wide.
6. WALK: mid-stride, one front paw raised, body moving forward — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Dévoreur de flammes: stocky upright fiery orange beast (#E05A1E) with a dark charcoal belly and two big curved dark horns; big jaw with fangs, glowing yellow eyes, mane of flames; big black claws, flaming tail tip. NO held item and no held object, ever. Forbidden: no wings, no armor, no rider, no held item, no torch, no held object. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `devoreur_de_flammes_attack.png` |
| 1-2 | attaque 2 | `devoreur_de_flammes_attack_2.png` |
| 1-3 | attaque 3 | `devoreur_de_flammes_attack_3.png` |
| 2-1 | sort 1 | `devoreur_de_flammes_cast.png` |
| 2-2 | sort 2 | `devoreur_de_flammes_cast_2.png` |
| 2-3 | marche | `devoreur_de_flammes_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Dévoreur de flammes — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Dévoreur de flammes, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Dévoreur de flammes (enemy of the Brasier nation)
- Body: stocky upright fiery orange beast (#E05A1E) with a dark charcoal belly and two big curved dark horns
- Head: big jaw with fangs, glowing yellow eyes, mane of flames
- Details: big black claws, flaming tail tip
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no armor, no rider, no held item, no torch, no held object.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 6 poses; it acts only with its own body (claws, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle orange ember highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high — silhouette: tall and vertical, limbs raised above the head.
2. POUNCE: body stretched forward in the air, jaws open — silhouette: wide and horizontal, body stretched far forward.
3. SIDE SWIPE: head and claws swept to the side, body twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. HOWL: head raised to the sky, flames and embers gathering around the body — silhouette: compact and rounded, hands gathered near the chest.
5. ROAR: mouth wide open, flames and embers burst in front of the head — silhouette: tall, both arms thrown up or spread wide.
6. WALK: mid-stride, one front paw raised, body moving forward — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Dévoreur de flammes: stocky upright fiery orange beast (#E05A1E) with a dark charcoal belly and two big curved dark horns; big jaw with fangs, glowing yellow eyes, mane of flames; big black claws, flaming tail tip. NO held item and no held object, ever. Forbidden: no wings, no armor, no rider, no held item, no torch, no held object. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `devoreur_de_flammes_back_attack.png` |
| 1-2 | attaque 2 — dos | `devoreur_de_flammes_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `devoreur_de_flammes_back_attack_3.png` |
| 2-1 | sort 1 — dos | `devoreur_de_flammes_back_cast.png` |
| 2-2 | sort 2 — dos | `devoreur_de_flammes_back_cast_2.png` |
| 2-3 | marche — dos | `devoreur_de_flammes_back_walk.png` |

### Golem de lave — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brasier/` ; nomme tes images `golem_de_lave_vues.png`, `golem_de_lave_actions.png` et `golem_de_lave_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Golem de lave — an NO HELD ITEM creature (no held item of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Golem de lave (enemy of the Brasier nation)
- Body: dark basalt golem (#2A2426) with bright orange lava cracks (#FF7A1E)
- Head: small head with two glowing orange eyes
- Details: molten glowing core in the chest, huge rock fists
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no held item, no crystals, no moss.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 4 cells; it acts only with its own body (claws, fists, tail, magic). Never add an item.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle orange ember highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in every cell; it acts only with its own body (claws, fists, tail, magic). Never add an item.
REMINDER: this is Golem de lave: dark basalt golem (#2A2426) with bright orange lava cracks (#FF7A1E); small head with two glowing orange eyes; molten glowing core in the chest, huge rock fists. NO held item and no held object, ever. Forbidden: no held item, no crystals, no moss. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `golem_de_lave.png` |
| 1-2 | repos de face, variante | `golem_de_lave_idle_2.png` |
| 2-1 | repos de dos | `golem_de_lave_back.png` |
| 2-2 | repos de dos, variante | `golem_de_lave_back_idle_2.png` |

##### Version courte de la planche vues

À utiliser si le générateur reformule le prompt, bloque sur un mot ou ne respecte pas le nombre de cases : mêmes consignes, 1 000 caractères.

```text
Character sheet, exactly 4 sprites in a 2x2 grid, plain flat white background, wide empty gaps, no overlap, no text, no frame. ONE enemy monster: Golem de lave. dark basalt golem (#2A2426) with bright orange lava cracks (#FF7A1E); small head with two glowing orange eyes; molten glowing core in the chest, huge rock fists. It holds nothing in its hands, paws or claws. Top row: two front 3/4 views facing right, two slightly different relaxed stances (not mirrored). Bottom row: two views from behind, facing away toward the upper right, no face visible, two different stances. Same outfit, colors and size in all 4, feet on one line. Style: smooth hand-drawn vector cartoon, thick dark outlines, Dofus / Waven look, NOT pixel art. Never facing left. Forbidden: no held item, no crystals, no moss.
```

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Golem de lave — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Golem de lave, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Golem de lave (enemy of the Brasier nation)
- Body: dark basalt golem (#2A2426) with bright orange lava cracks (#FF7A1E)
- Head: small head with two glowing orange eyes
- Details: molten glowing core in the chest, huge rock fists
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no held item, no crystals, no moss.
TASK: REMOVE every held item, torch, tool or held object from the hands, claws or tail — this creature is item-free. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in every cell; it acts only with its own body (claws, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Golem de lave: dark basalt golem (#2A2426) with bright orange lava cracks (#FF7A1E); small head with two glowing orange eyes; molten glowing core in the chest, huge rock fists. NO held item and no held object, ever. Forbidden: no held item, no crystals, no moss. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Golem de lave — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Golem de lave, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Golem de lave (enemy of the Brasier nation)
- Body: dark basalt golem (#2A2426) with bright orange lava cracks (#FF7A1E)
- Head: small head with two glowing orange eyes
- Details: molten glowing core in the chest, huge rock fists
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no held item, no crystals, no moss.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 6 poses; it acts only with its own body (claws, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle orange ember highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: both fists or held item raised high above the head — silhouette: tall and vertical, limbs raised above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward — silhouette: wide and horizontal, body stretched far forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. ROOTED: stomping, flames and embers cracks spreading under the feet — silhouette: compact and rounded, hands gathered near the chest.
5. GATHER: arms raised, flames and embers gathering between the hands — silhouette: tall, both arms thrown up or spread wide.
6. WALK: heavy mid-stride, one foot raised, arms swinging — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Golem de lave: dark basalt golem (#2A2426) with bright orange lava cracks (#FF7A1E); small head with two glowing orange eyes; molten glowing core in the chest, huge rock fists. NO held item and no held object, ever. Forbidden: no held item, no crystals, no moss. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `golem_de_lave_attack.png` |
| 1-2 | attaque 2 | `golem_de_lave_attack_2.png` |
| 1-3 | attaque 3 | `golem_de_lave_attack_3.png` |
| 2-1 | sort 1 | `golem_de_lave_cast.png` |
| 2-2 | sort 2 | `golem_de_lave_cast_2.png` |
| 2-3 | marche | `golem_de_lave_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Golem de lave — an NO HELD ITEM creature (no held item of any kind).
SOURCE IMAGE: it shows this enemy monster, Golem de lave, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Golem de lave (enemy of the Brasier nation)
- Body: dark basalt golem (#2A2426) with bright orange lava cracks (#FF7A1E)
- Head: small head with two glowing orange eyes
- Details: molten glowing core in the chest, huge rock fists
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no held item, no crystals, no moss.
NO HELD ITEM: this creature has NO held item, tool, torch, staff or held object of any kind in all 6 poses; it acts only with its own body (claws, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle orange ember highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: both fists or held item raised high above the head — silhouette: tall and vertical, limbs raised above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward — silhouette: wide and horizontal, body stretched far forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. ROOTED: stomping, flames and embers cracks spreading under the feet — silhouette: compact and rounded, hands gathered near the chest.
5. GATHER: arms raised, flames and embers gathering between the hands — silhouette: tall, both arms thrown up or spread wide.
6. WALK: heavy mid-stride, one foot raised, arms swinging — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Golem de lave: dark basalt golem (#2A2426) with bright orange lava cracks (#FF7A1E); small head with two glowing orange eyes; molten glowing core in the chest, huge rock fists. NO held item and no held object, ever. Forbidden: no held item, no crystals, no moss. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `golem_de_lave_back_attack.png` |
| 1-2 | attaque 2 — dos | `golem_de_lave_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `golem_de_lave_back_attack_3.png` |
| 2-1 | sort 1 — dos | `golem_de_lave_back_cast.png` |
| 2-2 | sort 2 — dos | `golem_de_lave_back_cast_2.png` |
| 2-3 | marche — dos | `golem_de_lave_back_walk.png` |

## 4. Boss

### Kharaz le Flamboyant — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `brasier_vues.png`, `brasier_actions.png` et `brasier_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE final boss: Kharaz le Flamboyant, carrying: great curved flame bow, LEFT hand.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Kharaz le Flamboyant (boss of the Brasier nation)
- Body: flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks
- Head: burning orange hair like flames, golden eyes
- Held item: great curved flame bow, LEFT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword.
HELD ITEM: great curved flame bow, LEFT hand. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle orange ember highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm. The great curved flame bow is held in the right hand and fully visible in this cell.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the held item stays in its hand); the face is visible and the drawing must not be a copy of cell 1. The great curved flame bow is held in the right hand and fully visible in this cell.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile. The great curved flame bow is held in the right hand and fully visible in this cell.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the held item stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3. The great curved flame bow is held in the right hand and fully visible in this cell.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: great curved flame bow, LEFT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Kharaz le Flamboyant: great curved flame bow, LEFT hand; flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks; burning orange hair like flames, golden eyes. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no sword. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `brasier.png` |
| 1-2 | repos de face, variante | `brasier_idle_2.png` |
| 2-1 | repos de dos | `brasier_back.png` |
| 2-2 | repos de dos, variante | `brasier_back_idle_2.png` |

##### Version courte de la planche vues

À utiliser si le générateur reformule le prompt, bloque sur un mot ou ne respecte pas le nombre de cases : mêmes consignes, 1 000 caractères.

```text
Character sheet, exactly 4 sprites in a 2x2 grid, plain flat white background, wide empty gaps, no overlap, no text, no frame. ONE final boss: Kharaz le Flamboyant. flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks; burning orange hair like flames, golden eyes; great curved flame bow, LEFT hand. It always holds the great curved flame bow in the right hand, clearly visible in all 4 sprites. Top row: two front 3/4 views facing right, two slightly different relaxed stances (not mirrored). Bottom row: two views from behind, facing away toward the upper right, no face visible, two different stances. Same outfit, colors and size in all 4, feet on one line. Style: smooth hand-drawn vector cartoon, thick dark outlines, Dofus / Waven look, NOT pixel art. Never facing left. Forbidden: no helmet, no sword.
```

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE final boss: Kharaz le Flamboyant, carrying: great curved flame bow, LEFT hand.
SOURCE IMAGE: it shows this final boss, Kharaz le Flamboyant, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Kharaz le Flamboyant (boss of the Brasier nation)
- Body: flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks
- Head: burning orange hair like flames, golden eyes
- Held item: great curved flame bow, LEFT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its held item in the correct hand — add the held item where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm. The great curved flame bow is held in the right hand and fully visible in this cell.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the held item stays in its hand); the face is visible and the drawing must not be a copy of cell 1. The great curved flame bow is held in the right hand and fully visible in this cell.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile. The great curved flame bow is held in the right hand and fully visible in this cell.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the held item stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3. The great curved flame bow is held in the right hand and fully visible in this cell.
HELD ITEM: great curved flame bow, LEFT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Kharaz le Flamboyant: great curved flame bow, LEFT hand; flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks; burning orange hair like flames, golden eyes. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no sword. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE final boss: Kharaz le Flamboyant, carrying: great curved flame bow, LEFT hand.
SOURCE IMAGE: it shows this final boss, Kharaz le Flamboyant, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, held item in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Kharaz le Flamboyant (boss of the Brasier nation)
- Body: flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks
- Head: burning orange hair like flames, golden eyes
- Held item: great curved flame bow, LEFT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword.
HELD ITEM: great curved flame bow, LEFT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle orange ember highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. SKY SHOT: bow pointed almost straight up, string fully drawn — silhouette: tall and vertical, limbs raised above the head. The great curved flame bow is held in the right hand and fully visible in this cell.
2. FULL DRAW: bow aimed straight forward, string pulled to the cheek, body sideways — silhouette: wide and horizontal, body stretched far forward. The great curved flame bow is held in the right hand and fully visible in this cell.
3. RELEASE: string hand open behind, bow arm extended, arrow leaving with a flames and embers trail — silhouette: low and wide, crouched or twisted with a long side reach. The great curved flame bow is held in the right hand and fully visible in this cell.
4. ENCHANTED ARROW: arrow held up to the face, its tip wrapped in flames and embers — silhouette: compact and rounded, hands gathered near the chest. The great curved flame bow is held in the right hand and fully visible in this cell.
5. VOLLEY: bow raised overhead, three flames and embers arrows rising into the air — silhouette: tall, both arms thrown up or spread wide. The great curved flame bow is held in the right hand and fully visible in this cell.
6. WALK: mid-stride, one foot raised, arms swinging naturally, held item held — silhouette: mid-stride with legs clearly apart, moving forward. The great curved flame bow is held in the right hand and fully visible in this cell.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: great curved flame bow, LEFT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Kharaz le Flamboyant: great curved flame bow, LEFT hand; flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks; burning orange hair like flames, golden eyes. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no sword. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `brasier_attack.png` |
| 1-2 | attaque 2 | `brasier_attack_2.png` |
| 1-3 | attaque 3 | `brasier_attack_3.png` |
| 2-1 | sort 1 | `brasier_cast.png` |
| 2-2 | sort 2 | `brasier_cast_2.png` |
| 2-3 | marche | `brasier_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE final boss: Kharaz le Flamboyant, carrying: great curved flame bow, LEFT hand.
SOURCE IMAGE: it shows this final boss, Kharaz le Flamboyant, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, held item in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Kharaz le Flamboyant (boss of the Brasier nation)
- Body: flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks
- Head: burning orange hair like flames, golden eyes
- Held item: great curved flame bow, LEFT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword.
HELD ITEM: great curved flame bow, LEFT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another held item (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle orange ember highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its held item, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long held items, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. SKY SHOT: bow pointed almost straight up, string fully drawn — silhouette: tall and vertical, limbs raised above the head. The great curved flame bow is held in the right hand and fully visible in this cell.
2. FULL DRAW: bow aimed straight forward, string pulled to the cheek, body sideways — silhouette: wide and horizontal, body stretched far forward. The great curved flame bow is held in the right hand and fully visible in this cell.
3. RELEASE: string hand open behind, bow arm extended, arrow leaving with a flames and embers trail — silhouette: low and wide, crouched or twisted with a long side reach. The great curved flame bow is held in the right hand and fully visible in this cell.
4. ENCHANTED ARROW: arrow held up to the face, its tip wrapped in flames and embers — silhouette: compact and rounded, hands gathered near the chest. The great curved flame bow is held in the right hand and fully visible in this cell.
5. VOLLEY: bow raised overhead, three flames and embers arrows rising into the air — silhouette: tall, both arms thrown up or spread wide. The great curved flame bow is held in the right hand and fully visible in this cell.
6. WALK: mid-stride, one foot raised, arms swinging naturally, held item held — silhouette: mid-stride with legs clearly apart, moving forward. The great curved flame bow is held in the right hand and fully visible in this cell.
The 6 poses MUST be clearly different from each other: different arm, leg and held item positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
ITEM CHECK: great curved flame bow, LEFT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Kharaz le Flamboyant: great curved flame bow, LEFT hand; flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks; burning orange hair like flames, golden eyes. The HELD ITEM never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no sword. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `brasier_back_attack.png` |
| 1-2 | attaque 2 — dos | `brasier_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `brasier_back_attack_3.png` |
| 2-1 | sort 1 — dos | `brasier_back_cast.png` |
| 2-2 | sort 2 — dos | `brasier_back_cast_2.png` |
| 2-3 | marche — dos | `brasier_back_walk.png` |

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
