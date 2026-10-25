# Nation Sylvestre (Forêt)

Palette : moss green, bark brown, leaf gold, small emerald glows. Effets : green leaves and glowing spores. Contre-jour : warm golden sunlight.

Format 3 planches par personnage (V44) :

1. **Vues** — 4 cases : repos de FACE ×2 (deux attitudes différentes) puis repos de DOS ×2, tout orienté vers la droite (le jeu retourne l'image pour la gauche). Grille 2 × 2 sur image 2:1, poses largement espacées. Génération normale.
2. **Actions de face** — 3 attaques + 2 sorts + 1 marche (3 colonnes × 2 rangées), en **édition** de la planche vues : le personnage réellement dessiné sert d'ancre.
3. **Actions de dos** — les mêmes 6 poses vues de dos, en édition de la planche vues. Une planche = un seul sens de vue (face et dos mélangés sur une même planche étaient dessinés de face). Facultative pour les monstres.

Les personnages **armés** ont l'arme écrite dans la première phrase, dans la carte d'identité, en fin de prompt et dans chaque pose ; les **créatures** reçoivent « UNARMED » (plus de torche inventée). Chaque prompt recopie la carte d'identité (`identites.py`) : aucune image à joindre. Ordre conseillé : 1) planche de style, 2) héros, 3) ennemis, 4) boss ; pour chaque personnage : vues, actions de face, actions de dos. Prompt négatif : en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Sylvestre nation (Forêt biome).
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows. Signature effects: green leaves and glowing spores.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden sunlight highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: two rows with the same 6 characters in the same order, all in idle pose. Top row: 3/4 front view, facing front-right. Bottom row: 3/4 back view, seen from behind, turned toward the upper right. All feet of a row on the same ground line. Leave a wide empty gap (at least half a character width) between characters and between the two rows: nobody overlaps or touches anyone, weapons and capes included. Image aspect ratio 2:1, as large as possible.
CHARACTERS, left to right:
1. the hero (Druide: young druid with messy dark green hair, layered armor-robe made of overlapping leaves and bark plates in moss green and brown, leather belts, a tall wooden staff topped with a carved leaf-shaped emerald crystal held in the right hand).
2. Araknéa (forest spider-beetle with an emerald armored carapace, curved horns, sharp mandibles and six legs).
3. Loup forestier (sturdy wolf with dark moss-green fur, a mane of leaves and twigs, amber eyes).
4. Dryade (dryad archer whose body is made of branches and leaves, wooden bow, leafy hair).
5. Tréant (walking tree trunk brute covered in moss and leaves, root-like legs, glowing green eyes).
6. the final boss Tharok le Végétal (towering forest giant with a body of bark and moss, great deer antlers covered in leaves, a long beard of hanging moss, wielding a thorny wooden club set with a green crystal), about 1.5x taller than the others.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Druide — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `druide_vues.png`, `druide_actions.png` et `druide_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE playable hero: Druide, armed with: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Druide (hero of the Sylvestre nation)
- Hair: messy short dark green hair (#2E5E3A) with a few small leaves in it
- Eyes: amber eyes (#E0A030), always open
- Skin: light peach skin
- Top: armor-robe of overlapping moss-green leaves (#5E8C3A) and brown bark plates (#6B4A2B)
- Bottom: dark brown trousers (#4A3420)
- Feet: brown leather boots wrapped with green cloth
- Weapon: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand
- Details: two crossed leather belts on the chest
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no cape, no blond hair, no blue clothes.
WEAPON: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden sunlight highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Druide: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand; messy short dark green hair (#2E5E3A) with a few small leaves in it; amber eyes (#E0A030), always open; armor-robe of overlapping moss-green leaves (#5E8C3A) and brown bark plates (#6B4A2B); light peach skin; dark brown trousers (#4A3420); brown leather boots wrapped with green cloth; two crossed leather belts on the chest. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no cape, no blond hair, no blue clothes. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `druide.png` |
| 1-2 | repos de face, variante | `druide_idle_2.png` |
| 2-1 | repos de dos | `druide_back.png` |
| 2-2 | repos de dos, variante | `druide_back_idle_2.png` |

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE playable hero: Druide, armed with: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand.
SOURCE IMAGE: it shows this playable hero, Druide, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Druide (hero of the Sylvestre nation)
- Hair: messy short dark green hair (#2E5E3A) with a few small leaves in it
- Eyes: amber eyes (#E0A030), always open
- Skin: light peach skin
- Top: armor-robe of overlapping moss-green leaves (#5E8C3A) and brown bark plates (#6B4A2B)
- Bottom: dark brown trousers (#4A3420)
- Feet: brown leather boots wrapped with green cloth
- Weapon: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand
- Details: two crossed leather belts on the chest
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no cape, no blond hair, no blue clothes.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
WEAPON: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Druide: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand; messy short dark green hair (#2E5E3A) with a few small leaves in it; amber eyes (#E0A030), always open; armor-robe of overlapping moss-green leaves (#5E8C3A) and brown bark plates (#6B4A2B); light peach skin; dark brown trousers (#4A3420); brown leather boots wrapped with green cloth; two crossed leather belts on the chest. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no cape, no blond hair, no blue clothes. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE playable hero: Druide, armed with: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand.
SOURCE IMAGE: it shows this playable hero, Druide, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Druide (hero of the Sylvestre nation)
- Hair: messy short dark green hair (#2E5E3A) with a few small leaves in it
- Eyes: amber eyes (#E0A030), always open
- Skin: light peach skin
- Top: armor-robe of overlapping moss-green leaves (#5E8C3A) and brown bark plates (#6B4A2B)
- Bottom: dark brown trousers (#4A3420)
- Feet: brown leather boots wrapped with green cloth
- Weapon: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand
- Details: two crossed leather belts on the chest
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no cape, no blond hair, no blue clothes.
WEAPON: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden sunlight highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands — silhouette: tall and vertical, limbs raised above the head.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short green leaves and glowing spores spark — silhouette: wide and horizontal, body stretched far forward.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. FOCUS: eyes closed, staff held vertically in front of the face, green leaves and glowing spores orb at the top — silhouette: compact and rounded, hands gathered near the chest.
5. INVOCATION: staff raised high with both hands, green leaves and glowing spores swirling above the head — silhouette: tall, both arms thrown up or spread wide.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Druide: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand; messy short dark green hair (#2E5E3A) with a few small leaves in it; amber eyes (#E0A030), always open; armor-robe of overlapping moss-green leaves (#5E8C3A) and brown bark plates (#6B4A2B); light peach skin; dark brown trousers (#4A3420); brown leather boots wrapped with green cloth; two crossed leather belts on the chest. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no cape, no blond hair, no blue clothes. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `druide_attack.png` |
| 1-2 | attaque 2 | `druide_attack_2.png` |
| 1-3 | attaque 3 | `druide_attack_3.png` |
| 2-1 | sort 1 | `druide_cast.png` |
| 2-2 | sort 2 | `druide_cast_2.png` |
| 2-3 | marche | `druide_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE playable hero: Druide, armed with: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand.
SOURCE IMAGE: it shows this playable hero, Druide, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Druide (hero of the Sylvestre nation)
- Hair: messy short dark green hair (#2E5E3A) with a few small leaves in it
- Eyes: amber eyes (#E0A030), always open
- Skin: light peach skin
- Top: armor-robe of overlapping moss-green leaves (#5E8C3A) and brown bark plates (#6B4A2B)
- Bottom: dark brown trousers (#4A3420)
- Feet: brown leather boots wrapped with green cloth
- Weapon: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand
- Details: two crossed leather belts on the chest
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no cape, no blond hair, no blue clothes.
WEAPON: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden sunlight highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands — silhouette: tall and vertical, limbs raised above the head.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short green leaves and glowing spores spark — silhouette: wide and horizontal, body stretched far forward.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. FOCUS: eyes closed, staff held vertically in front of the face, green leaves and glowing spores orb at the top — silhouette: compact and rounded, hands gathered near the chest.
5. INVOCATION: staff raised high with both hands, green leaves and glowing spores swirling above the head — silhouette: tall, both arms thrown up or spread wide.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Druide: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand; messy short dark green hair (#2E5E3A) with a few small leaves in it; amber eyes (#E0A030), always open; armor-robe of overlapping moss-green leaves (#5E8C3A) and brown bark plates (#6B4A2B); light peach skin; dark brown trousers (#4A3420); brown leather boots wrapped with green cloth; two crossed leather belts on the chest. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no cape, no blond hair, no blue clothes. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `druide_back_attack.png` |
| 1-2 | attaque 2 — dos | `druide_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `druide_back_attack_3.png` |
| 2-1 | sort 1 — dos | `druide_back_cast.png` |
| 2-2 | sort 2 — dos | `druide_back_cast_2.png` |
| 2-3 | marche — dos | `druide_back_walk.png` |

L'export Zimut de l'Atelier copie aussi le repos (case 1 de la planche vues) vers `nations/heros/druide.png`.

## 3. Ennemis

### Araknéa — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sylvestre/` ; nomme tes images `araknea_vues.png`, `araknea_actions.png` et `araknea_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Araknéa — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Araknéa (enemy of the Sylvestre nation)
- Body: forest spider-beetle with six thin dark-brown legs (#3B2A1E) and a domed emerald armored carapace (#2FA060) with lighter green edges
- Head: two curved ivory horns, sharp brown mandibles, four small glowing amber eyes (#F2B233)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no eight legs, no wings, no human body, no weapon.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden sunlight highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Araknéa: forest spider-beetle with six thin dark-brown legs (#3B2A1E) and a domed emerald armored carapace (#2FA060) with lighter green edges; two curved ivory horns, sharp brown mandibles, four small glowing amber eyes (#F2B233). NO weapon and no held object, ever. Forbidden: no eight legs, no wings, no human body, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `araknea.png` |
| 1-2 | repos de face, variante | `araknea_idle_2.png` |
| 2-1 | repos de dos | `araknea_back.png` |
| 2-2 | repos de dos, variante | `araknea_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Araknéa — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Araknéa, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Araknéa (enemy of the Sylvestre nation)
- Body: forest spider-beetle with six thin dark-brown legs (#3B2A1E) and a domed emerald armored carapace (#2FA060) with lighter green edges
- Head: two curved ivory horns, sharp brown mandibles, four small glowing amber eyes (#F2B233)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no eight legs, no wings, no human body, no weapon.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Araknéa: forest spider-beetle with six thin dark-brown legs (#3B2A1E) and a domed emerald armored carapace (#2FA060) with lighter green edges; two curved ivory horns, sharp brown mandibles, four small glowing amber eyes (#F2B233). NO weapon and no held object, ever. Forbidden: no eight legs, no wings, no human body, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Araknéa — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Araknéa, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Araknéa (enemy of the Sylvestre nation)
- Body: forest spider-beetle with six thin dark-brown legs (#3B2A1E) and a domed emerald armored carapace (#2FA060) with lighter green edges
- Head: two curved ivory horns, sharp brown mandibles, four small glowing amber eyes (#F2B233)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no eight legs, no wings, no human body, no weapon.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden sunlight highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high — silhouette: tall and vertical, limbs raised above the head.
2. POUNCE: body stretched forward in the air, jaws open — silhouette: wide and horizontal, body stretched far forward.
3. SIDE SWIPE: head and claws swept to the side, body twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. HOWL: head raised to the sky, green leaves and glowing spores gathering around the body — silhouette: compact and rounded, hands gathered near the chest.
5. ROAR: mouth wide open, green leaves and glowing spores burst in front of the head — silhouette: tall, both arms thrown up or spread wide.
6. WALK: mid-stride, one front paw raised, body moving forward — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Araknéa: forest spider-beetle with six thin dark-brown legs (#3B2A1E) and a domed emerald armored carapace (#2FA060) with lighter green edges; two curved ivory horns, sharp brown mandibles, four small glowing amber eyes (#F2B233). NO weapon and no held object, ever. Forbidden: no eight legs, no wings, no human body, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `araknea_attack.png` |
| 1-2 | attaque 2 | `araknea_attack_2.png` |
| 1-3 | attaque 3 | `araknea_attack_3.png` |
| 2-1 | sort 1 | `araknea_cast.png` |
| 2-2 | sort 2 | `araknea_cast_2.png` |
| 2-3 | marche | `araknea_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Araknéa — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Araknéa, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Araknéa (enemy of the Sylvestre nation)
- Body: forest spider-beetle with six thin dark-brown legs (#3B2A1E) and a domed emerald armored carapace (#2FA060) with lighter green edges
- Head: two curved ivory horns, sharp brown mandibles, four small glowing amber eyes (#F2B233)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no eight legs, no wings, no human body, no weapon.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden sunlight highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high — silhouette: tall and vertical, limbs raised above the head.
2. POUNCE: body stretched forward in the air, jaws open — silhouette: wide and horizontal, body stretched far forward.
3. SIDE SWIPE: head and claws swept to the side, body twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. HOWL: head raised to the sky, green leaves and glowing spores gathering around the body — silhouette: compact and rounded, hands gathered near the chest.
5. ROAR: mouth wide open, green leaves and glowing spores burst in front of the head — silhouette: tall, both arms thrown up or spread wide.
6. WALK: mid-stride, one front paw raised, body moving forward — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Araknéa: forest spider-beetle with six thin dark-brown legs (#3B2A1E) and a domed emerald armored carapace (#2FA060) with lighter green edges; two curved ivory horns, sharp brown mandibles, four small glowing amber eyes (#F2B233). NO weapon and no held object, ever. Forbidden: no eight legs, no wings, no human body, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `araknea_back_attack.png` |
| 1-2 | attaque 2 — dos | `araknea_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `araknea_back_attack_3.png` |
| 2-1 | sort 1 — dos | `araknea_back_cast.png` |
| 2-2 | sort 2 — dos | `araknea_back_cast_2.png` |
| 2-3 | marche — dos | `araknea_back_walk.png` |

### Loup forestier — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sylvestre/` ; nomme tes images `loup_forestier_vues.png`, `loup_forestier_actions.png` et `loup_forestier_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Loup forestier — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Loup forestier (enemy of the Sylvestre nation)
- Body: sturdy four-legged wolf with dark moss-green fur (#3E5E34) and a lighter sage belly
- Head: mane of green leaves and brown twigs around the neck, amber eyes (#E0A030), black nose
- Details: bushy tail tipped with leaves
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no armor, no rider, no grey or brown fur, never standing on two legs.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden sunlight highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Loup forestier: sturdy four-legged wolf with dark moss-green fur (#3E5E34) and a lighter sage belly; mane of green leaves and brown twigs around the neck, amber eyes (#E0A030), black nose; bushy tail tipped with leaves. NO weapon and no held object, ever. Forbidden: no armor, no rider, no grey or brown fur, never standing on two legs. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `loup_forestier.png` |
| 1-2 | repos de face, variante | `loup_forestier_idle_2.png` |
| 2-1 | repos de dos | `loup_forestier_back.png` |
| 2-2 | repos de dos, variante | `loup_forestier_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Loup forestier — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Loup forestier, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Loup forestier (enemy of the Sylvestre nation)
- Body: sturdy four-legged wolf with dark moss-green fur (#3E5E34) and a lighter sage belly
- Head: mane of green leaves and brown twigs around the neck, amber eyes (#E0A030), black nose
- Details: bushy tail tipped with leaves
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no armor, no rider, no grey or brown fur, never standing on two legs.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Loup forestier: sturdy four-legged wolf with dark moss-green fur (#3E5E34) and a lighter sage belly; mane of green leaves and brown twigs around the neck, amber eyes (#E0A030), black nose; bushy tail tipped with leaves. NO weapon and no held object, ever. Forbidden: no armor, no rider, no grey or brown fur, never standing on two legs. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Loup forestier — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Loup forestier, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Loup forestier (enemy of the Sylvestre nation)
- Body: sturdy four-legged wolf with dark moss-green fur (#3E5E34) and a lighter sage belly
- Head: mane of green leaves and brown twigs around the neck, amber eyes (#E0A030), black nose
- Details: bushy tail tipped with leaves
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no armor, no rider, no grey or brown fur, never standing on two legs.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden sunlight highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high — silhouette: tall and vertical, limbs raised above the head.
2. POUNCE: body stretched forward in the air, jaws open — silhouette: wide and horizontal, body stretched far forward.
3. SIDE SWIPE: head and claws swept to the side, body twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. HOWL: head raised to the sky, green leaves and glowing spores gathering around the body — silhouette: compact and rounded, hands gathered near the chest.
5. ROAR: mouth wide open, green leaves and glowing spores burst in front of the head — silhouette: tall, both arms thrown up or spread wide.
6. WALK: mid-stride, one front paw raised, body moving forward — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Loup forestier: sturdy four-legged wolf with dark moss-green fur (#3E5E34) and a lighter sage belly; mane of green leaves and brown twigs around the neck, amber eyes (#E0A030), black nose; bushy tail tipped with leaves. NO weapon and no held object, ever. Forbidden: no armor, no rider, no grey or brown fur, never standing on two legs. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `loup_forestier_attack.png` |
| 1-2 | attaque 2 | `loup_forestier_attack_2.png` |
| 1-3 | attaque 3 | `loup_forestier_attack_3.png` |
| 2-1 | sort 1 | `loup_forestier_cast.png` |
| 2-2 | sort 2 | `loup_forestier_cast_2.png` |
| 2-3 | marche | `loup_forestier_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Loup forestier — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Loup forestier, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Loup forestier (enemy of the Sylvestre nation)
- Body: sturdy four-legged wolf with dark moss-green fur (#3E5E34) and a lighter sage belly
- Head: mane of green leaves and brown twigs around the neck, amber eyes (#E0A030), black nose
- Details: bushy tail tipped with leaves
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no armor, no rider, no grey or brown fur, never standing on two legs.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden sunlight highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high — silhouette: tall and vertical, limbs raised above the head.
2. POUNCE: body stretched forward in the air, jaws open — silhouette: wide and horizontal, body stretched far forward.
3. SIDE SWIPE: head and claws swept to the side, body twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. HOWL: head raised to the sky, green leaves and glowing spores gathering around the body — silhouette: compact and rounded, hands gathered near the chest.
5. ROAR: mouth wide open, green leaves and glowing spores burst in front of the head — silhouette: tall, both arms thrown up or spread wide.
6. WALK: mid-stride, one front paw raised, body moving forward — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Loup forestier: sturdy four-legged wolf with dark moss-green fur (#3E5E34) and a lighter sage belly; mane of green leaves and brown twigs around the neck, amber eyes (#E0A030), black nose; bushy tail tipped with leaves. NO weapon and no held object, ever. Forbidden: no armor, no rider, no grey or brown fur, never standing on two legs. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `loup_forestier_back_attack.png` |
| 1-2 | attaque 2 — dos | `loup_forestier_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `loup_forestier_back_attack_3.png` |
| 2-1 | sort 1 — dos | `loup_forestier_back_cast.png` |
| 2-2 | sort 2 — dos | `loup_forestier_back_cast_2.png` |
| 2-3 | marche — dos | `loup_forestier_back_walk.png` |

### Dryade — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sylvestre/` ; nomme tes images `dryade_vues.png`, `dryade_actions.png` et `dryade_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Dryade, armed with: simple wooden bow in the LEFT hand, no quiver.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Dryade (enemy of the Sylvestre nation)
- Body: slim dryad woman whose body is made of light-brown branches (#8A6238) and green leaves (#5FAE48)
- Head: long hair made of green leaves with small pink flowers, glowing green eyes (#7CFF8A)
- Weapon: simple wooden bow in the LEFT hand, no quiver
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no clothes, no metal, no human skin.
WEAPON: simple wooden bow in the LEFT hand, no quiver. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden sunlight highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: simple wooden bow in the LEFT hand, no quiver. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Dryade: simple wooden bow in the LEFT hand, no quiver; slim dryad woman whose body is made of light-brown branches (#8A6238) and green leaves (#5FAE48); long hair made of green leaves with small pink flowers, glowing green eyes (#7CFF8A). The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no clothes, no metal, no human skin. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `dryade.png` |
| 1-2 | repos de face, variante | `dryade_idle_2.png` |
| 2-1 | repos de dos | `dryade_back.png` |
| 2-2 | repos de dos, variante | `dryade_back_idle_2.png` |

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Dryade, armed with: simple wooden bow in the LEFT hand, no quiver.
SOURCE IMAGE: it shows this enemy monster, Dryade, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Dryade (enemy of the Sylvestre nation)
- Body: slim dryad woman whose body is made of light-brown branches (#8A6238) and green leaves (#5FAE48)
- Head: long hair made of green leaves with small pink flowers, glowing green eyes (#7CFF8A)
- Weapon: simple wooden bow in the LEFT hand, no quiver
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no clothes, no metal, no human skin.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
WEAPON: simple wooden bow in the LEFT hand, no quiver. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Dryade: simple wooden bow in the LEFT hand, no quiver; slim dryad woman whose body is made of light-brown branches (#8A6238) and green leaves (#5FAE48); long hair made of green leaves with small pink flowers, glowing green eyes (#7CFF8A). The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no clothes, no metal, no human skin. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Dryade, armed with: simple wooden bow in the LEFT hand, no quiver.
SOURCE IMAGE: it shows this enemy monster, Dryade, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Dryade (enemy of the Sylvestre nation)
- Body: slim dryad woman whose body is made of light-brown branches (#8A6238) and green leaves (#5FAE48)
- Head: long hair made of green leaves with small pink flowers, glowing green eyes (#7CFF8A)
- Weapon: simple wooden bow in the LEFT hand, no quiver
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no clothes, no metal, no human skin.
WEAPON: simple wooden bow in the LEFT hand, no quiver. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden sunlight highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. SKY SHOT: bow pointed almost straight up, string fully drawn — silhouette: tall and vertical, limbs raised above the head.
2. FULL DRAW: bow aimed straight forward, string pulled to the cheek, body sideways — silhouette: wide and horizontal, body stretched far forward.
3. RELEASE: string hand open behind, bow arm extended, arrow leaving with a green leaves and glowing spores trail — silhouette: low and wide, crouched or twisted with a long side reach.
4. ENCHANTED ARROW: arrow held up to the face, its tip wrapped in green leaves and glowing spores — silhouette: compact and rounded, hands gathered near the chest.
5. VOLLEY: bow raised overhead, three green leaves and glowing spores arrows rising into the air — silhouette: tall, both arms thrown up or spread wide.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: simple wooden bow in the LEFT hand, no quiver — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Dryade: simple wooden bow in the LEFT hand, no quiver; slim dryad woman whose body is made of light-brown branches (#8A6238) and green leaves (#5FAE48); long hair made of green leaves with small pink flowers, glowing green eyes (#7CFF8A). The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no clothes, no metal, no human skin. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `dryade_attack.png` |
| 1-2 | attaque 2 | `dryade_attack_2.png` |
| 1-3 | attaque 3 | `dryade_attack_3.png` |
| 2-1 | sort 1 | `dryade_cast.png` |
| 2-2 | sort 2 | `dryade_cast_2.png` |
| 2-3 | marche | `dryade_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Dryade, armed with: simple wooden bow in the LEFT hand, no quiver.
SOURCE IMAGE: it shows this enemy monster, Dryade, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Dryade (enemy of the Sylvestre nation)
- Body: slim dryad woman whose body is made of light-brown branches (#8A6238) and green leaves (#5FAE48)
- Head: long hair made of green leaves with small pink flowers, glowing green eyes (#7CFF8A)
- Weapon: simple wooden bow in the LEFT hand, no quiver
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no clothes, no metal, no human skin.
WEAPON: simple wooden bow in the LEFT hand, no quiver. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden sunlight highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. SKY SHOT: bow pointed almost straight up, string fully drawn — silhouette: tall and vertical, limbs raised above the head.
2. FULL DRAW: bow aimed straight forward, string pulled to the cheek, body sideways — silhouette: wide and horizontal, body stretched far forward.
3. RELEASE: string hand open behind, bow arm extended, arrow leaving with a green leaves and glowing spores trail — silhouette: low and wide, crouched or twisted with a long side reach.
4. ENCHANTED ARROW: arrow held up to the face, its tip wrapped in green leaves and glowing spores — silhouette: compact and rounded, hands gathered near the chest.
5. VOLLEY: bow raised overhead, three green leaves and glowing spores arrows rising into the air — silhouette: tall, both arms thrown up or spread wide.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: simple wooden bow in the LEFT hand, no quiver — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Dryade: simple wooden bow in the LEFT hand, no quiver; slim dryad woman whose body is made of light-brown branches (#8A6238) and green leaves (#5FAE48); long hair made of green leaves with small pink flowers, glowing green eyes (#7CFF8A). The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no clothes, no metal, no human skin. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `dryade_back_attack.png` |
| 1-2 | attaque 2 — dos | `dryade_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `dryade_back_attack_3.png` |
| 2-1 | sort 1 — dos | `dryade_back_cast.png` |
| 2-2 | sort 2 — dos | `dryade_back_cast_2.png` |
| 2-3 | marche — dos | `dryade_back_walk.png` |

### Tréant — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sylvestre/` ; nomme tes images `treant_vues.png`, `treant_actions.png` et `treant_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Tréant — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tréant (enemy of the Sylvestre nation)
- Body: walking tree-trunk brute of dark brown bark (#5A3E26) covered in green moss (#4F7A32)
- Head: no neck, a face carved in the trunk with two glowing green eyes (#7CFF8A) and a crooked mouth, leafy crown on top
- Details: two thick branch arms, root-like legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no armor, no flowers.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden sunlight highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Tréant: walking tree-trunk brute of dark brown bark (#5A3E26) covered in green moss (#4F7A32); no neck, a face carved in the trunk with two glowing green eyes (#7CFF8A) and a crooked mouth, leafy crown on top; two thick branch arms, root-like legs. NO weapon and no held object, ever. Forbidden: no weapon, no armor, no flowers. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `treant.png` |
| 1-2 | repos de face, variante | `treant_idle_2.png` |
| 2-1 | repos de dos | `treant_back.png` |
| 2-2 | repos de dos, variante | `treant_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Tréant — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Tréant, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tréant (enemy of the Sylvestre nation)
- Body: walking tree-trunk brute of dark brown bark (#5A3E26) covered in green moss (#4F7A32)
- Head: no neck, a face carved in the trunk with two glowing green eyes (#7CFF8A) and a crooked mouth, leafy crown on top
- Details: two thick branch arms, root-like legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no armor, no flowers.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly toward the right, the weight is on the other leg; the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — one limb (paw, claw or hand) is lifted or resting in a different position, the head is turned slightly to the left, the weight is on the other leg; no face, no eyes; the drawing must not be a copy of cell 3.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Tréant: walking tree-trunk brute of dark brown bark (#5A3E26) covered in green moss (#4F7A32); no neck, a face carved in the trunk with two glowing green eyes (#7CFF8A) and a crooked mouth, leafy crown on top; two thick branch arms, root-like legs. NO weapon and no held object, ever. Forbidden: no weapon, no armor, no flowers. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Tréant — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Tréant, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tréant (enemy of the Sylvestre nation)
- Body: walking tree-trunk brute of dark brown bark (#5A3E26) covered in green moss (#4F7A32)
- Head: no neck, a face carved in the trunk with two glowing green eyes (#7CFF8A) and a crooked mouth, leafy crown on top
- Details: two thick branch arms, root-like legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no armor, no flowers.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden sunlight highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head — silhouette: tall and vertical, limbs raised above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward — silhouette: wide and horizontal, body stretched far forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. ROOTED: stomping, green leaves and glowing spores cracks spreading under the feet — silhouette: compact and rounded, hands gathered near the chest.
5. GATHER: arms raised, green leaves and glowing spores gathering between the hands — silhouette: tall, both arms thrown up or spread wide.
6. WALK: heavy mid-stride, one foot raised, arms swinging — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tréant: walking tree-trunk brute of dark brown bark (#5A3E26) covered in green moss (#4F7A32); no neck, a face carved in the trunk with two glowing green eyes (#7CFF8A) and a crooked mouth, leafy crown on top; two thick branch arms, root-like legs. NO weapon and no held object, ever. Forbidden: no weapon, no armor, no flowers. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `treant_attack.png` |
| 1-2 | attaque 2 | `treant_attack_2.png` |
| 1-3 | attaque 3 | `treant_attack_3.png` |
| 2-1 | sort 1 | `treant_cast.png` |
| 2-2 | sort 2 | `treant_cast_2.png` |
| 2-3 | marche | `treant_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Tréant — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Tréant, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tréant (enemy of the Sylvestre nation)
- Body: walking tree-trunk brute of dark brown bark (#5A3E26) covered in green moss (#4F7A32)
- Head: no neck, a face carved in the trunk with two glowing green eyes (#7CFF8A) and a crooked mouth, leafy crown on top
- Details: two thick branch arms, root-like legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no armor, no flowers.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden sunlight highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head — silhouette: tall and vertical, limbs raised above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward — silhouette: wide and horizontal, body stretched far forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. ROOTED: stomping, green leaves and glowing spores cracks spreading under the feet — silhouette: compact and rounded, hands gathered near the chest.
5. GATHER: arms raised, green leaves and glowing spores gathering between the hands — silhouette: tall, both arms thrown up or spread wide.
6. WALK: heavy mid-stride, one foot raised, arms swinging — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tréant: walking tree-trunk brute of dark brown bark (#5A3E26) covered in green moss (#4F7A32); no neck, a face carved in the trunk with two glowing green eyes (#7CFF8A) and a crooked mouth, leafy crown on top; two thick branch arms, root-like legs. NO weapon and no held object, ever. Forbidden: no weapon, no armor, no flowers. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `treant_back_attack.png` |
| 1-2 | attaque 2 — dos | `treant_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `treant_back_attack_3.png` |
| 2-1 | sort 1 — dos | `treant_back_cast.png` |
| 2-2 | sort 2 — dos | `treant_back_cast_2.png` |
| 2-3 | marche — dos | `treant_back_walk.png` |

## 4. Boss

### Tharok le Végétal — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `sylvestre_vues.png`, `sylvestre_actions.png` et `sylvestre_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE final boss: Tharok le Végétal, armed with: thorny wooden club set with a green crystal, RIGHT hand.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tharok le Végétal (boss of the Sylvestre nation)
- Body: towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32)
- Head: great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes
- Weapon: thorny wooden club set with a green crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no armor, no metal.
WEAPON: thorny wooden club set with a green crystal, RIGHT hand. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden sunlight highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
COUNT AND VIEWS: exactly FOUR sprites, two per row, no empty cell. The two sprites of the SAME row are NOT a mirrored pair and NOT a copy: change the head tilt, the arm and hand positions and which leg carries the weight. The BOTTOM row is drawn from BEHIND: we see the back of the head, the back of the outfit and the tail or cape from behind — no face, no eyes, no beak or snout visible. A bottom-row sprite that shows a face is wrong.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: thorny wooden club set with a green crystal, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Tharok le Végétal: thorny wooden club set with a green crystal, RIGHT hand; towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32); great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no armor, no metal. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `sylvestre.png` |
| 1-2 | repos de face, variante | `sylvestre_idle_2.png` |
| 2-1 | repos de dos | `sylvestre_back.png` |
| 2-2 | repos de dos, variante | `sylvestre_back_idle_2.png` |

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE final boss: Tharok le Végétal, armed with: thorny wooden club set with a green crystal, RIGHT hand.
SOURCE IMAGE: it shows this final boss, Tharok le Végétal, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tharok le Végétal (boss of the Sylvestre nation)
- Body: towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32)
- Head: great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes
- Weapon: thorny wooden club set with a green crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no armor, no metal.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
WEAPON: thorny wooden club set with a green crystal, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Tharok le Végétal: thorny wooden club set with a green crystal, RIGHT hand; towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32); great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no armor, no metal. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

**Si les 6 poses sortent identiques** (V55) : relance deux fois avec le même prompt en ne gardant que les poses 1 à 3 (« draw ONLY poses 1, 2 and 3, 3 columns x 1 row »), puis que les poses 4 à 6 : le générateur recopie beaucoup moins la pose source avec 3 cases qu'avec 6. Découpe en `--grid 3x1`.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE final boss: Tharok le Végétal, armed with: thorny wooden club set with a green crystal, RIGHT hand.
SOURCE IMAGE: it shows this final boss, Tharok le Végétal, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tharok le Végétal (boss of the Sylvestre nation)
- Body: towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32)
- Head: great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes
- Weapon: thorny wooden club set with a green crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no armor, no metal.
WEAPON: thorny wooden club set with a green crystal, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden sunlight highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head — silhouette: tall and vertical, limbs raised above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward — silhouette: wide and horizontal, body stretched far forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. ROOTED: stomping, green leaves and glowing spores cracks spreading under the feet — silhouette: compact and rounded, hands gathered near the chest.
5. GATHER: arms raised, green leaves and glowing spores gathering between the hands — silhouette: tall, both arms thrown up or spread wide.
6. WALK: heavy mid-stride, one foot raised, arms swinging — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: thorny wooden club set with a green crystal, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Tharok le Végétal: thorny wooden club set with a green crystal, RIGHT hand; towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32); great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no armor, no metal. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `sylvestre_attack.png` |
| 1-2 | attaque 2 | `sylvestre_attack_2.png` |
| 1-3 | attaque 3 | `sylvestre_attack_3.png` |
| 2-1 | sort 1 | `sylvestre_cast.png` |
| 2-2 | sort 2 | `sylvestre_cast_2.png` |
| 2-3 | marche | `sylvestre_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE final boss: Tharok le Végétal, armed with: thorny wooden club set with a green crystal, RIGHT hand.
SOURCE IMAGE: it shows this final boss, Tharok le Végétal, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged. The source is ONLY a CHARACTER REFERENCE (design, colors, proportions): do NOT reuse, copy, trace or lightly modify ANY of its poses — every one of the 6 poses below is a brand-NEW drawing with its own silhouette. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tharok le Végétal (boss of the Sylvestre nation)
- Body: towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32)
- Head: great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes
- Weapon: thorny wooden club set with a green crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no armor, no metal.
WEAPON: thorny wooden club set with a green crystal, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE LOCK: smooth hand-drawn vector cartoon with THICK DARK OUTLINES, exactly like Dofus / Waven / Wakfu character art and like the other sheets of this game — NEVER pixel art, never low-resolution, never a painterly or soft-edged style, never a thin or white outline.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden sunlight highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head — silhouette: tall and vertical, limbs raised above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward — silhouette: wide and horizontal, body stretched far forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted — silhouette: low and wide, crouched or twisted with a long side reach.
4. ROOTED: stomping, green leaves and glowing spores cracks spreading under the feet — silhouette: compact and rounded, hands gathered near the chest.
5. GATHER: arms raised, green leaves and glowing spores gathering between the hands — silhouette: tall, both arms thrown up or spread wide.
6. WALK: heavy mid-stride, one foot raised, arms swinging — silhouette: mid-stride with legs clearly apart, moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one. SELF-CHECK before answering: fill every pose in solid black — the 6 black silhouettes must be easy to tell apart, and none may be the standing idle pose.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: thorny wooden club set with a green crystal, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Tharok le Végétal: thorny wooden club set with a green crystal, RIGHT hand; towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32); great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no armor, no metal. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `sylvestre_back_attack.png` |
| 1-2 | attaque 2 — dos | `sylvestre_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `sylvestre_back_attack_3.png` |
| 2-1 | sort 1 — dos | `sylvestre_back_cast.png` |
| 2-2 | sort 2 — dos | `sylvestre_back_cast_2.png` |
| 2-3 | marche — dos | `sylvestre_back_walk.png` |

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
