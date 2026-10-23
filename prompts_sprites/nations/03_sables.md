# Nation Sables (Désert)

Palette : sand gold, terracotta, amber, small turquoise accents. Effets : swirling sand and amber shards. Contre-jour : warm golden.

Format 3 planches par personnage (V44) :

1. **Vues** — 4 cases : repos de FACE ×2 (deux attitudes différentes) puis repos de DOS ×2, tout orienté vers la droite (le jeu retourne l'image pour la gauche). Grille 2 × 2 sur image 2:1, poses largement espacées. Génération normale.
2. **Actions de face** — 3 attaques + 2 sorts + 1 marche (3 colonnes × 2 rangées), en **édition** de la planche vues : le personnage réellement dessiné sert d'ancre.
3. **Actions de dos** — les mêmes 6 poses vues de dos, en édition de la planche vues. Une planche = un seul sens de vue (face et dos mélangés sur une même planche étaient dessinés de face). Facultative pour les monstres.

Les personnages **armés** ont l'arme écrite dans la première phrase, dans la carte d'identité, en fin de prompt et dans chaque pose ; les **créatures** reçoivent « UNARMED » (plus de torche inventée). Chaque prompt recopie la carte d'identité (`identites.py`) : aucune image à joindre. Ordre conseillé : 1) planche de style, 2) héros, 3) ennemis, 4) boss ; pour chaque personnage : vues, actions de face, actions de dos. Prompt négatif : en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Sables nation (Désert biome).
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents. Signature effects: swirling sand and amber shards.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: two rows with the same 6 characters in the same order, all in idle pose. Top row: 3/4 front view, facing front-right. Bottom row: 3/4 back view, seen from behind, turned toward the upper right. All feet of a row on the same ground line. Leave a wide empty gap (at least half a character width) between characters and between the two rows: nobody overlaps or touches anyone, weapons and capes included. Image aspect ratio 2:1, as large as possible.
CHARACTERS, left to right:
1. the hero (Géomancien: young geomancer with short brown hair, layered sand-gold robe with terracotta panels and amber gems, sandals and wraps, a golden staff topped with a large faceted amber crystal in the right hand).
2. Bandit des dunes (small desert jackal-folk bandit with orange fur, a sand-colored scarf and a curved dagger).
3. Scarabée géant (giant scarab beetle with a black and gold shell and golden horns).
4. Génie du désert (golden sand djinn with muscular arms and a lower body of swirling sand).
5. Sphinx (golden lion sphinx wearing a striped pharaoh headdress).
6. the final boss Zahor le Sableux (sand sovereign in ornate golden armor with sharp layered plates, crested golden helm, holding a tall golden staff with a giant amber crystal), about 1.5x taller than the others.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Géomancien — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `geomancien_vues.png`, `geomancien_actions.png` et `geomancien_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE playable hero: Géomancien, armed with: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Géomancien (hero of the Sables nation)
- Hair: short brown hair (#7A4A28)
- Eyes: amber-brown eyes, always open
- Skin: light tan skin
- Top: layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and small amber gems
- Bottom: sand-colored wrapped trousers
- Feet: brown sandals with cloth wraps
- Weapon: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no turban, no blue or green clothes.
WEAPON: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Géomancien: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand; short brown hair (#7A4A28); amber-brown eyes, always open; layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and small amber gems; light tan skin; sand-colored wrapped trousers; brown sandals with cloth wraps. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no turban, no blue or green clothes. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `geomancien.png` |
| 1-2 | repos de face, variante | `geomancien_idle_2.png` |
| 2-1 | repos de dos | `geomancien_back.png` |
| 2-2 | repos de dos, variante | `geomancien_back_idle_2.png` |

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE playable hero: Géomancien, armed with: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand.
SOURCE IMAGE: it shows this playable hero, Géomancien, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Géomancien (hero of the Sables nation)
- Hair: short brown hair (#7A4A28)
- Eyes: amber-brown eyes, always open
- Skin: light tan skin
- Top: layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and small amber gems
- Bottom: sand-colored wrapped trousers
- Feet: brown sandals with cloth wraps
- Weapon: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no turban, no blue or green clothes.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
WEAPON: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Géomancien: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand; short brown hair (#7A4A28); amber-brown eyes, always open; layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and small amber gems; light tan skin; sand-colored wrapped trousers; brown sandals with cloth wraps. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no turban, no blue or green clothes. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE playable hero: Géomancien, armed with: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand.
SOURCE IMAGE: it shows this playable hero, Géomancien, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Géomancien (hero of the Sables nation)
- Hair: short brown hair (#7A4A28)
- Eyes: amber-brown eyes, always open
- Skin: light tan skin
- Top: layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and small amber gems
- Bottom: sand-colored wrapped trousers
- Feet: brown sandals with cloth wraps
- Weapon: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no turban, no blue or green clothes.
WEAPON: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short swirling sand and amber shards spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. FOCUS: eyes closed, staff held vertically in front of the face, swirling sand and amber shards orb at the top.
5. INVOCATION: staff raised high with both hands, swirling sand and amber shards swirling above the head.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Géomancien: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand; short brown hair (#7A4A28); amber-brown eyes, always open; layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and small amber gems; light tan skin; sand-colored wrapped trousers; brown sandals with cloth wraps. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no turban, no blue or green clothes. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `geomancien_attack.png` |
| 1-2 | attaque 2 | `geomancien_attack_2.png` |
| 1-3 | attaque 3 | `geomancien_attack_3.png` |
| 2-1 | sort 1 | `geomancien_cast.png` |
| 2-2 | sort 2 | `geomancien_cast_2.png` |
| 2-3 | marche | `geomancien_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE playable hero: Géomancien, armed with: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand.
SOURCE IMAGE: it shows this playable hero, Géomancien, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Géomancien (hero of the Sables nation)
- Hair: short brown hair (#7A4A28)
- Eyes: amber-brown eyes, always open
- Skin: light tan skin
- Top: layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and small amber gems
- Bottom: sand-colored wrapped trousers
- Feet: brown sandals with cloth wraps
- Weapon: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no turban, no blue or green clothes.
WEAPON: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short swirling sand and amber shards spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. FOCUS: eyes closed, staff held vertically in front of the face, swirling sand and amber shards orb at the top.
5. INVOCATION: staff raised high with both hands, swirling sand and amber shards swirling above the head.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Géomancien: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand; short brown hair (#7A4A28); amber-brown eyes, always open; layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and small amber gems; light tan skin; sand-colored wrapped trousers; brown sandals with cloth wraps. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no turban, no blue or green clothes. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `geomancien_back_attack.png` |
| 1-2 | attaque 2 — dos | `geomancien_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `geomancien_back_attack_3.png` |
| 2-1 | sort 1 — dos | `geomancien_back_cast.png` |
| 2-2 | sort 2 — dos | `geomancien_back_cast_2.png` |
| 2-3 | marche — dos | `geomancien_back_walk.png` |

L'export Zimut de l'Atelier copie aussi le repos (case 1 de la planche vues) vers `nations/heros/geomancien.png`.

## 3. Ennemis

### Bandit des dunes — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sables/` ; nomme tes images `bandit_des_dunes_vues.png`, `bandit_des_dunes_actions.png` et `bandit_des_dunes_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Bandit des dunes, armed with: one curved dagger in the RIGHT hand.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Bandit des dunes (enemy of the Sables nation)
- Body: small jackal-folk bandit standing on two legs, orange fur (#D9822B) with a cream muzzle
- Head: tall jackal ears, yellow eyes, sand-colored scarf (#E3CF9A) over the mouth
- Top: brown leather vest with a red sash
- Bottom: baggy sand-colored trousers, bare paws
- Weapon: one curved dagger in the RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no bow, no sword, no hood, no human face.
WEAPON: one curved dagger in the RIGHT hand. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: one curved dagger in the RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Bandit des dunes: one curved dagger in the RIGHT hand; brown leather vest with a red sash; small jackal-folk bandit standing on two legs, orange fur (#D9822B) with a cream muzzle; tall jackal ears, yellow eyes, sand-colored scarf (#E3CF9A) over the mouth; baggy sand-colored trousers, bare paws. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no bow, no sword, no hood, no human face. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `bandit_des_dunes.png` |
| 1-2 | repos de face, variante | `bandit_des_dunes_idle_2.png` |
| 2-1 | repos de dos | `bandit_des_dunes_back.png` |
| 2-2 | repos de dos, variante | `bandit_des_dunes_back_idle_2.png` |

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Bandit des dunes, armed with: one curved dagger in the RIGHT hand.
SOURCE IMAGE: it shows this enemy monster, Bandit des dunes, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Bandit des dunes (enemy of the Sables nation)
- Body: small jackal-folk bandit standing on two legs, orange fur (#D9822B) with a cream muzzle
- Head: tall jackal ears, yellow eyes, sand-colored scarf (#E3CF9A) over the mouth
- Top: brown leather vest with a red sash
- Bottom: baggy sand-colored trousers, bare paws
- Weapon: one curved dagger in the RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no bow, no sword, no hood, no human face.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
WEAPON: one curved dagger in the RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Bandit des dunes: one curved dagger in the RIGHT hand; brown leather vest with a red sash; small jackal-folk bandit standing on two legs, orange fur (#D9822B) with a cream muzzle; tall jackal ears, yellow eyes, sand-colored scarf (#E3CF9A) over the mouth; baggy sand-colored trousers, bare paws. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no bow, no sword, no hood, no human face. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Bandit des dunes, armed with: one curved dagger in the RIGHT hand.
SOURCE IMAGE: it shows this enemy monster, Bandit des dunes, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Bandit des dunes (enemy of the Sables nation)
- Body: small jackal-folk bandit standing on two legs, orange fur (#D9822B) with a cream muzzle
- Head: tall jackal ears, yellow eyes, sand-colored scarf (#E3CF9A) over the mouth
- Top: brown leather vest with a red sash
- Bottom: baggy sand-colored trousers, bare paws
- Weapon: one curved dagger in the RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no bow, no sword, no hood, no human face.
WEAPON: one curved dagger in the RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. CROSS SLASH: both daggers crossed high above the head, about to strike down.
2. LUNGE STAB: body stretched forward almost horizontal, one dagger thrust far ahead.
3. SPIN: body twisted, arms spread to both sides, short swirling sand and amber shards slash arcs.
4. SHADOW KNEEL: kneeling, one hand on the ground, swirling sand and amber shards rising around.
5. VANISH: half the body dissolving into swirling sand and amber shards, only the eyes and daggers clear.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: one curved dagger in the RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Bandit des dunes: one curved dagger in the RIGHT hand; brown leather vest with a red sash; small jackal-folk bandit standing on two legs, orange fur (#D9822B) with a cream muzzle; tall jackal ears, yellow eyes, sand-colored scarf (#E3CF9A) over the mouth; baggy sand-colored trousers, bare paws. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no bow, no sword, no hood, no human face. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `bandit_des_dunes_attack.png` |
| 1-2 | attaque 2 | `bandit_des_dunes_attack_2.png` |
| 1-3 | attaque 3 | `bandit_des_dunes_attack_3.png` |
| 2-1 | sort 1 | `bandit_des_dunes_cast.png` |
| 2-2 | sort 2 | `bandit_des_dunes_cast_2.png` |
| 2-3 | marche | `bandit_des_dunes_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Bandit des dunes, armed with: one curved dagger in the RIGHT hand.
SOURCE IMAGE: it shows this enemy monster, Bandit des dunes, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Bandit des dunes (enemy of the Sables nation)
- Body: small jackal-folk bandit standing on two legs, orange fur (#D9822B) with a cream muzzle
- Head: tall jackal ears, yellow eyes, sand-colored scarf (#E3CF9A) over the mouth
- Top: brown leather vest with a red sash
- Bottom: baggy sand-colored trousers, bare paws
- Weapon: one curved dagger in the RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no bow, no sword, no hood, no human face.
WEAPON: one curved dagger in the RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. CROSS SLASH: both daggers crossed high above the head, about to strike down.
2. LUNGE STAB: body stretched forward almost horizontal, one dagger thrust far ahead.
3. SPIN: body twisted, arms spread to both sides, short swirling sand and amber shards slash arcs.
4. SHADOW KNEEL: kneeling, one hand on the ground, swirling sand and amber shards rising around.
5. VANISH: half the body dissolving into swirling sand and amber shards, only the eyes and daggers clear.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: one curved dagger in the RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Bandit des dunes: one curved dagger in the RIGHT hand; brown leather vest with a red sash; small jackal-folk bandit standing on two legs, orange fur (#D9822B) with a cream muzzle; tall jackal ears, yellow eyes, sand-colored scarf (#E3CF9A) over the mouth; baggy sand-colored trousers, bare paws. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no bow, no sword, no hood, no human face. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `bandit_des_dunes_back_attack.png` |
| 1-2 | attaque 2 — dos | `bandit_des_dunes_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `bandit_des_dunes_back_attack_3.png` |
| 2-1 | sort 1 — dos | `bandit_des_dunes_back_cast.png` |
| 2-2 | sort 2 — dos | `bandit_des_dunes_back_cast_2.png` |
| 2-3 | marche — dos | `bandit_des_dunes_back_walk.png` |

### Scarabée géant — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sables/` ; nomme tes images `scarabee_geant_vues.png`, `scarabee_geant_actions.png` et `scarabee_geant_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Scarabée géant — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Scarabée géant (enemy of the Sables nation)
- Body: giant scarab beetle on six legs, glossy black shell (#1A1A1E) with gold edges and patterns (#E0B040)
- Head: big golden horn and two smaller golden horns, small red eyes
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings spread, no rider, no human body.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Scarabée géant: giant scarab beetle on six legs, glossy black shell (#1A1A1E) with gold edges and patterns (#E0B040); big golden horn and two smaller golden horns, small red eyes. NO weapon and no held object, ever. Forbidden: no wings spread, no rider, no human body. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `scarabee_geant.png` |
| 1-2 | repos de face, variante | `scarabee_geant_idle_2.png` |
| 2-1 | repos de dos | `scarabee_geant_back.png` |
| 2-2 | repos de dos, variante | `scarabee_geant_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Scarabée géant — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Scarabée géant, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Scarabée géant (enemy of the Sables nation)
- Body: giant scarab beetle on six legs, glossy black shell (#1A1A1E) with gold edges and patterns (#E0B040)
- Head: big golden horn and two smaller golden horns, small red eyes
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings spread, no rider, no human body.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Scarabée géant: giant scarab beetle on six legs, glossy black shell (#1A1A1E) with gold edges and patterns (#E0B040); big golden horn and two smaller golden horns, small red eyes. NO weapon and no held object, ever. Forbidden: no wings spread, no rider, no human body. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Scarabée géant — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Scarabée géant, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Scarabée géant (enemy of the Sables nation)
- Body: giant scarab beetle on six legs, glossy black shell (#1A1A1E) with gold edges and patterns (#E0B040)
- Head: big golden horn and two smaller golden horns, small red eyes
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings spread, no rider, no human body.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. POUNCE: body stretched forward in the air, jaws open.
3. SIDE SWIPE: head and claws swept to the side, body twisted.
4. HOWL: head raised to the sky, swirling sand and amber shards gathering around the body.
5. ROAR: mouth wide open, swirling sand and amber shards burst in front of the head.
6. WALK: mid-stride, one front paw raised, body moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Scarabée géant: giant scarab beetle on six legs, glossy black shell (#1A1A1E) with gold edges and patterns (#E0B040); big golden horn and two smaller golden horns, small red eyes. NO weapon and no held object, ever. Forbidden: no wings spread, no rider, no human body. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `scarabee_geant_attack.png` |
| 1-2 | attaque 2 | `scarabee_geant_attack_2.png` |
| 1-3 | attaque 3 | `scarabee_geant_attack_3.png` |
| 2-1 | sort 1 | `scarabee_geant_cast.png` |
| 2-2 | sort 2 | `scarabee_geant_cast_2.png` |
| 2-3 | marche | `scarabee_geant_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Scarabée géant — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Scarabée géant, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Scarabée géant (enemy of the Sables nation)
- Body: giant scarab beetle on six legs, glossy black shell (#1A1A1E) with gold edges and patterns (#E0B040)
- Head: big golden horn and two smaller golden horns, small red eyes
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings spread, no rider, no human body.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. POUNCE: body stretched forward in the air, jaws open.
3. SIDE SWIPE: head and claws swept to the side, body twisted.
4. HOWL: head raised to the sky, swirling sand and amber shards gathering around the body.
5. ROAR: mouth wide open, swirling sand and amber shards burst in front of the head.
6. WALK: mid-stride, one front paw raised, body moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Scarabée géant: giant scarab beetle on six legs, glossy black shell (#1A1A1E) with gold edges and patterns (#E0B040); big golden horn and two smaller golden horns, small red eyes. NO weapon and no held object, ever. Forbidden: no wings spread, no rider, no human body. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `scarabee_geant_back_attack.png` |
| 1-2 | attaque 2 — dos | `scarabee_geant_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `scarabee_geant_back_attack_3.png` |
| 2-1 | sort 1 — dos | `scarabee_geant_back_cast.png` |
| 2-2 | sort 2 — dos | `scarabee_geant_back_cast_2.png` |
| 2-3 | marche — dos | `scarabee_geant_back_walk.png` |

### Génie du désert — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sables/` ; nomme tes images `genie_du_desert_vues.png`, `genie_du_desert_actions.png` et `genie_du_desert_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Génie du désert — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Génie du désert (enemy of the Sables nation)
- Body: golden-skinned sand djinn (#E0B050) with a muscular bare chest and arms, golden bracelets
- Head: bald head with a long black topknot, glowing amber eyes, pointed ears
- Bottom: no legs: lower body of swirling sand (#D9C08A)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no blue skin, no clothes on the torso.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Génie du désert: golden-skinned sand djinn (#E0B050) with a muscular bare chest and arms, golden bracelets; bald head with a long black topknot, glowing amber eyes, pointed ears; no legs: lower body of swirling sand (#D9C08A). NO weapon and no held object, ever. Forbidden: no weapon, no blue skin, no clothes on the torso. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `genie_du_desert.png` |
| 1-2 | repos de face, variante | `genie_du_desert_idle_2.png` |
| 2-1 | repos de dos | `genie_du_desert_back.png` |
| 2-2 | repos de dos, variante | `genie_du_desert_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Génie du désert — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Génie du désert, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Génie du désert (enemy of the Sables nation)
- Body: golden-skinned sand djinn (#E0B050) with a muscular bare chest and arms, golden bracelets
- Head: bald head with a long black topknot, glowing amber eyes, pointed ears
- Bottom: no legs: lower body of swirling sand (#D9C08A)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no blue skin, no clothes on the torso.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Génie du désert: golden-skinned sand djinn (#E0B050) with a muscular bare chest and arms, golden bracelets; bald head with a long black topknot, glowing amber eyes, pointed ears; no legs: lower body of swirling sand (#D9C08A). NO weapon and no held object, ever. Forbidden: no weapon, no blue skin, no clothes on the torso. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Génie du désert — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Génie du désert, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Génie du désert (enemy of the Sables nation)
- Body: golden-skinned sand djinn (#E0B050) with a muscular bare chest and arms, golden bracelets
- Head: bald head with a long black topknot, glowing amber eyes, pointed ears
- Bottom: no legs: lower body of swirling sand (#D9C08A)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no blue skin, no clothes on the torso.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. LUNGE: body stretched forward, claws of swirling sand and amber shards reaching out.
3. SPIN: body whirling, swirling sand and amber shards trail around it.
4. HOVER: floating higher, swirling sand and amber shards orbs circling.
5. PULSE: arms spread, swirling sand and amber shards pulsing outward.
6. DRIFT: floating forward with the body tilted slightly ahead, a short trail behind.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Génie du désert: golden-skinned sand djinn (#E0B050) with a muscular bare chest and arms, golden bracelets; bald head with a long black topknot, glowing amber eyes, pointed ears; no legs: lower body of swirling sand (#D9C08A). NO weapon and no held object, ever. Forbidden: no weapon, no blue skin, no clothes on the torso. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `genie_du_desert_attack.png` |
| 1-2 | attaque 2 | `genie_du_desert_attack_2.png` |
| 1-3 | attaque 3 | `genie_du_desert_attack_3.png` |
| 2-1 | sort 1 | `genie_du_desert_cast.png` |
| 2-2 | sort 2 | `genie_du_desert_cast_2.png` |
| 2-3 | marche | `genie_du_desert_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Génie du désert — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Génie du désert, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Génie du désert (enemy of the Sables nation)
- Body: golden-skinned sand djinn (#E0B050) with a muscular bare chest and arms, golden bracelets
- Head: bald head with a long black topknot, glowing amber eyes, pointed ears
- Bottom: no legs: lower body of swirling sand (#D9C08A)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no blue skin, no clothes on the torso.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. LUNGE: body stretched forward, claws of swirling sand and amber shards reaching out.
3. SPIN: body whirling, swirling sand and amber shards trail around it.
4. HOVER: floating higher, swirling sand and amber shards orbs circling.
5. PULSE: arms spread, swirling sand and amber shards pulsing outward.
6. DRIFT: floating forward with the body tilted slightly ahead, a short trail behind.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Génie du désert: golden-skinned sand djinn (#E0B050) with a muscular bare chest and arms, golden bracelets; bald head with a long black topknot, glowing amber eyes, pointed ears; no legs: lower body of swirling sand (#D9C08A). NO weapon and no held object, ever. Forbidden: no weapon, no blue skin, no clothes on the torso. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `genie_du_desert_back_attack.png` |
| 1-2 | attaque 2 — dos | `genie_du_desert_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `genie_du_desert_back_attack_3.png` |
| 2-1 | sort 1 — dos | `genie_du_desert_back_cast.png` |
| 2-2 | sort 2 — dos | `genie_du_desert_back_cast_2.png` |
| 2-3 | marche — dos | `genie_du_desert_back_walk.png` |

### Sphinx — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sables/` ; nomme tes images `sphinx_vues.png`, `sphinx_actions.png` et `sphinx_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Sphinx — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sphinx (enemy of the Sables nation)
- Body: golden lion sphinx on four legs (#D9A848) with a lion tail
- Head: human-like calm face, striped blue-and-gold pharaoh headdress (#2E56A8, #E0B040), kohl-lined amber eyes
- Details: small golden collar, no wings
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no weapon, standing on four legs only.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Sphinx: golden lion sphinx on four legs (#D9A848) with a lion tail; human-like calm face, striped blue-and-gold pharaoh headdress (#2E56A8, #E0B040), kohl-lined amber eyes; small golden collar, no wings. NO weapon and no held object, ever. Forbidden: no wings, no weapon, standing on four legs only. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `sphinx.png` |
| 1-2 | repos de face, variante | `sphinx_idle_2.png` |
| 2-1 | repos de dos | `sphinx_back.png` |
| 2-2 | repos de dos, variante | `sphinx_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Sphinx — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Sphinx, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sphinx (enemy of the Sables nation)
- Body: golden lion sphinx on four legs (#D9A848) with a lion tail
- Head: human-like calm face, striped blue-and-gold pharaoh headdress (#2E56A8, #E0B040), kohl-lined amber eyes
- Details: small golden collar, no wings
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no weapon, standing on four legs only.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Sphinx: golden lion sphinx on four legs (#D9A848) with a lion tail; human-like calm face, striped blue-and-gold pharaoh headdress (#2E56A8, #E0B040), kohl-lined amber eyes; small golden collar, no wings. NO weapon and no held object, ever. Forbidden: no wings, no weapon, standing on four legs only. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Sphinx — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Sphinx, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sphinx (enemy of the Sables nation)
- Body: golden lion sphinx on four legs (#D9A848) with a lion tail
- Head: human-like calm face, striped blue-and-gold pharaoh headdress (#2E56A8, #E0B040), kohl-lined amber eyes
- Details: small golden collar, no wings
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no weapon, standing on four legs only.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. POUNCE: body stretched forward in the air, jaws open.
3. SIDE SWIPE: head and claws swept to the side, body twisted.
4. HOWL: head raised to the sky, swirling sand and amber shards gathering around the body.
5. ROAR: mouth wide open, swirling sand and amber shards burst in front of the head.
6. WALK: mid-stride, one front paw raised, body moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Sphinx: golden lion sphinx on four legs (#D9A848) with a lion tail; human-like calm face, striped blue-and-gold pharaoh headdress (#2E56A8, #E0B040), kohl-lined amber eyes; small golden collar, no wings. NO weapon and no held object, ever. Forbidden: no wings, no weapon, standing on four legs only. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `sphinx_attack.png` |
| 1-2 | attaque 2 | `sphinx_attack_2.png` |
| 1-3 | attaque 3 | `sphinx_attack_3.png` |
| 2-1 | sort 1 | `sphinx_cast.png` |
| 2-2 | sort 2 | `sphinx_cast_2.png` |
| 2-3 | marche | `sphinx_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Sphinx — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Sphinx, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sphinx (enemy of the Sables nation)
- Body: golden lion sphinx on four legs (#D9A848) with a lion tail
- Head: human-like calm face, striped blue-and-gold pharaoh headdress (#2E56A8, #E0B040), kohl-lined amber eyes
- Details: small golden collar, no wings
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no weapon, standing on four legs only.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. POUNCE: body stretched forward in the air, jaws open.
3. SIDE SWIPE: head and claws swept to the side, body twisted.
4. HOWL: head raised to the sky, swirling sand and amber shards gathering around the body.
5. ROAR: mouth wide open, swirling sand and amber shards burst in front of the head.
6. WALK: mid-stride, one front paw raised, body moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Sphinx: golden lion sphinx on four legs (#D9A848) with a lion tail; human-like calm face, striped blue-and-gold pharaoh headdress (#2E56A8, #E0B040), kohl-lined amber eyes; small golden collar, no wings. NO weapon and no held object, ever. Forbidden: no wings, no weapon, standing on four legs only. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `sphinx_back_attack.png` |
| 1-2 | attaque 2 — dos | `sphinx_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `sphinx_back_attack_3.png` |
| 2-1 | sort 1 — dos | `sphinx_back_cast.png` |
| 2-2 | sort 2 — dos | `sphinx_back_cast_2.png` |
| 2-3 | marche — dos | `sphinx_back_walk.png` |

## 4. Boss

### Zahor le Sableux — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `sables_vues.png`, `sables_actions.png` et `sables_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE final boss: Zahor le Sableux, armed with: tall golden staff with a giant amber crystal, RIGHT hand.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Zahor le Sableux (boss of the Sables nation)
- Body: sand sovereign in ornate golden armor (#D4A63A) with sharp layered plates
- Head: crested golden helm, dark face shadow with glowing amber eyes
- Weapon: tall golden staff with a giant amber crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no cape, no sword.
WEAPON: tall golden staff with a giant amber crystal, RIGHT hand. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: tall golden staff with a giant amber crystal, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Zahor le Sableux: tall golden staff with a giant amber crystal, RIGHT hand; sand sovereign in ornate golden armor (#D4A63A) with sharp layered plates; crested golden helm, dark face shadow with glowing amber eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no cape, no sword. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `sables.png` |
| 1-2 | repos de face, variante | `sables_idle_2.png` |
| 2-1 | repos de dos | `sables_back.png` |
| 2-2 | repos de dos, variante | `sables_back_idle_2.png` |

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE final boss: Zahor le Sableux, armed with: tall golden staff with a giant amber crystal, RIGHT hand.
SOURCE IMAGE: it shows this final boss, Zahor le Sableux, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Zahor le Sableux (boss of the Sables nation)
- Body: sand sovereign in ornate golden armor (#D4A63A) with sharp layered plates
- Head: crested golden helm, dark face shadow with glowing amber eyes
- Weapon: tall golden staff with a giant amber crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no cape, no sword.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
WEAPON: tall golden staff with a giant amber crystal, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Zahor le Sableux: tall golden staff with a giant amber crystal, RIGHT hand; sand sovereign in ornate golden armor (#D4A63A) with sharp layered plates; crested golden helm, dark face shadow with glowing amber eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no cape, no sword. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE final boss: Zahor le Sableux, armed with: tall golden staff with a giant amber crystal, RIGHT hand.
SOURCE IMAGE: it shows this final boss, Zahor le Sableux, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Zahor le Sableux (boss of the Sables nation)
- Body: sand sovereign in ornate golden armor (#D4A63A) with sharp layered plates
- Head: crested golden helm, dark face shadow with glowing amber eyes
- Weapon: tall golden staff with a giant amber crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no cape, no sword.
WEAPON: tall golden staff with a giant amber crystal, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short swirling sand and amber shards spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. FOCUS: eyes closed, staff held vertically in front of the face, swirling sand and amber shards orb at the top.
5. INVOCATION: staff raised high with both hands, swirling sand and amber shards swirling above the head.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: tall golden staff with a giant amber crystal, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Zahor le Sableux: tall golden staff with a giant amber crystal, RIGHT hand; sand sovereign in ornate golden armor (#D4A63A) with sharp layered plates; crested golden helm, dark face shadow with glowing amber eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no cape, no sword. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `sables_attack.png` |
| 1-2 | attaque 2 | `sables_attack_2.png` |
| 1-3 | attaque 3 | `sables_attack_3.png` |
| 2-1 | sort 1 | `sables_cast.png` |
| 2-2 | sort 2 | `sables_cast_2.png` |
| 2-3 | marche | `sables_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE final boss: Zahor le Sableux, armed with: tall golden staff with a giant amber crystal, RIGHT hand.
SOURCE IMAGE: it shows this final boss, Zahor le Sableux, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Zahor le Sableux (boss of the Sables nation)
- Body: sand sovereign in ornate golden armor (#D4A63A) with sharp layered plates
- Head: crested golden helm, dark face shadow with glowing amber eyes
- Weapon: tall golden staff with a giant amber crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no cape, no sword.
WEAPON: tall golden staff with a giant amber crystal, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle warm golden highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short swirling sand and amber shards spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. FOCUS: eyes closed, staff held vertically in front of the face, swirling sand and amber shards orb at the top.
5. INVOCATION: staff raised high with both hands, swirling sand and amber shards swirling above the head.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: tall golden staff with a giant amber crystal, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Zahor le Sableux: tall golden staff with a giant amber crystal, RIGHT hand; sand sovereign in ornate golden armor (#D4A63A) with sharp layered plates; crested golden helm, dark face shadow with glowing amber eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no cape, no sword. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `sables_back_attack.png` |
| 1-2 | attaque 2 — dos | `sables_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `sables_back_attack_3.png` |
| 2-1 | sort 1 — dos | `sables_back_cast.png` |
| 2-2 | sort 2 — dos | `sables_back_cast_2.png` |
| 2-3 | marche — dos | `sables_back_walk.png` |

## Prompt négatif

**Personnages armés — planches vues** :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, golden glow, light flare, sun rays, color tint over the sprite, glowing aura on one side, cream background, beige background, colored background, ground shadow ellipse, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, weapon changing shape, weapon changing color, weapon replaced by another weapon, missing weapon, missing accessories, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, different character between poses, realistic proportions, small head, more than 4 sprites, extra sprites, duplicated row of sprites, one sprite bigger or smaller than the others, size changing between cells
```

**Personnages armés — planches actions et planche de style** :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, golden glow, light flare, sun rays, color tint over the sprite, glowing aura on one side, cream background, beige background, colored background, ground shadow ellipse, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, weapon changing shape, weapon changing color, weapon replaced by another weapon, missing weapon, missing accessories, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, different character between poses, realistic proportions, small head
```

**Créatures sans arme (Salamandre, golems, bêtes…) — planches vues** :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, golden glow, light flare, sun rays, color tint over the sprite, glowing aura on one side, cream background, beige background, colored background, ground shadow ellipse, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, extra objects, different character between poses, realistic proportions, small head, more than 4 sprites, extra sprites, duplicated row of sprites, one sprite bigger or smaller than the others, size changing between cells, weapon, torch, staff, sword, bow, held object, tool, item in the hands or claws
```

**Créatures sans arme — planches actions** :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, golden glow, light flare, sun rays, color tint over the sprite, glowing aura on one side, cream background, beige background, colored background, ground shadow ellipse, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, extra objects, different character between poses, realistic proportions, small head, weapon, torch, staff, sword, bow, held object, tool, item in the hands or claws
```
