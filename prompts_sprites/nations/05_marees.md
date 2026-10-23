# Nation Marées (Marées)

Palette : turquoise, white, gold trims, coral pink accents. Effets : water splashes and bubbles. Contre-jour : aqua.

Format 3 planches par personnage (V44) :

1. **Vues** — 4 cases : repos de FACE ×2 (deux attitudes différentes) puis repos de DOS ×2, tout orienté vers la droite (le jeu retourne l'image pour la gauche). Grille 2 × 2 sur image 2:1, poses largement espacées. Génération normale.
2. **Actions de face** — 3 attaques + 2 sorts + 1 marche (3 colonnes × 2 rangées), en **édition** de la planche vues : le personnage réellement dessiné sert d'ancre.
3. **Actions de dos** — les mêmes 6 poses vues de dos, en édition de la planche vues. Une planche = un seul sens de vue (face et dos mélangés sur une même planche étaient dessinés de face). Facultative pour les monstres.

Les personnages **armés** ont l'arme écrite dans la première phrase, dans la carte d'identité, en fin de prompt et dans chaque pose ; les **créatures** reçoivent « UNARMED » (plus de torche inventée). Chaque prompt recopie la carte d'identité (`identites.py`) : aucune image à joindre. Ordre conseillé : 1) planche de style, 2) héros, 3) ennemis, 4) boss ; pour chaque personnage : vues, actions de face, actions de dos. Prompt négatif : en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Marées nation (Marées biome).
NATION PALETTE: turquoise, white, gold trims, coral pink accents. Signature effects: water splashes and bubbles.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: two rows with the same 6 characters in the same order, all in idle pose. Top row: 3/4 front view, facing front-right. Bottom row: 3/4 back view, seen from behind, turned toward the upper right. All feet of a row on the same ground line. Leave a wide empty gap (at least half a character width) between characters and between the two rows: nobody overlaps or touches anyone, weapons and capes included. Image aspect ratio 2:1, as large as possible.
CHARACTERS, left to right:
1. the hero (Heal (Soigneur): gentle healer with teal hair, ornate white and turquoise robe with gold embroidery and wave patterns, a golden staff topped with a glowing water-drop crystal in the right hand).
2. Pirate des mers (sea pirate with a red bandana, blue coat, leather belts and a short cutlass).
3. Requin (blue shark with a white belly swimming upright in the air, toothy grin).
4. Néréide (water nymph made of translucent-looking turquoise water, flowing hair of waves).
5. Crabe géant (giant crab with a blue shell striped with red, huge pincers).
6. the final boss Néréa la Tempête (sea queen in turquoise coral armor with gold edges, crown of red coral branches, flowing sea-foam cape, holding a golden trident), about 1.5x taller than the others.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Heal (Soigneur) — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `heal_vues.png`, `heal_actions.png` et `heal_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE playable hero: Heal, armed with: golden staff topped with a glowing water-drop crystal (#7FE8FF), RIGHT hand.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Heal (hero of the Marées nation)
- Hair: long teal hair (#2BB3A8) tied low behind the back
- Eyes: soft turquoise eyes, always open
- Skin: fair skin
- Top: ornate white robe with turquoise panels (#3CC7C0), gold embroidery and wave patterns
- Bottom: long white robe skirt with turquoise hem
- Feet: white and gold slippers
- Weapon: golden staff topped with a glowing water-drop crystal (#7FE8FF), RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no armor, no dark clothes.
WEAPON: golden staff topped with a glowing water-drop crystal (#7FE8FF), RIGHT hand. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: golden staff topped with a glowing water-drop crystal (#7FE8FF), RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Heal: golden staff topped with a glowing water-drop crystal (#7FE8FF), RIGHT hand; long teal hair (#2BB3A8) tied low behind the back; soft turquoise eyes, always open; ornate white robe with turquoise panels (#3CC7C0), gold embroidery and wave patterns; fair skin; long white robe skirt with turquoise hem; white and gold slippers. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no armor, no dark clothes. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `heal.png` |
| 1-2 | repos de face, variante | `heal_idle_2.png` |
| 2-1 | repos de dos | `heal_back.png` |
| 2-2 | repos de dos, variante | `heal_back_idle_2.png` |

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE playable hero: Heal, armed with: golden staff topped with a glowing water-drop crystal (#7FE8FF), RIGHT hand.
SOURCE IMAGE: it shows this playable hero, Heal, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Heal (hero of the Marées nation)
- Hair: long teal hair (#2BB3A8) tied low behind the back
- Eyes: soft turquoise eyes, always open
- Skin: fair skin
- Top: ornate white robe with turquoise panels (#3CC7C0), gold embroidery and wave patterns
- Bottom: long white robe skirt with turquoise hem
- Feet: white and gold slippers
- Weapon: golden staff topped with a glowing water-drop crystal (#7FE8FF), RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no armor, no dark clothes.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
WEAPON: golden staff topped with a glowing water-drop crystal (#7FE8FF), RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Heal: golden staff topped with a glowing water-drop crystal (#7FE8FF), RIGHT hand; long teal hair (#2BB3A8) tied low behind the back; soft turquoise eyes, always open; ornate white robe with turquoise panels (#3CC7C0), gold embroidery and wave patterns; fair skin; long white robe skirt with turquoise hem; white and gold slippers. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no armor, no dark clothes. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE playable hero: Heal, armed with: golden staff topped with a glowing water-drop crystal (#7FE8FF), RIGHT hand.
SOURCE IMAGE: it shows this playable hero, Heal, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Heal (hero of the Marées nation)
- Hair: long teal hair (#2BB3A8) tied low behind the back
- Eyes: soft turquoise eyes, always open
- Skin: fair skin
- Top: ornate white robe with turquoise panels (#3CC7C0), gold embroidery and wave patterns
- Bottom: long white robe skirt with turquoise hem
- Feet: white and gold slippers
- Weapon: golden staff topped with a glowing water-drop crystal (#7FE8FF), RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no armor, no dark clothes.
WEAPON: golden staff topped with a glowing water-drop crystal (#7FE8FF), RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short water splashes and bubbles spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. FOCUS: eyes closed, staff held vertically in front of the face, water splashes and bubbles orb at the top.
5. INVOCATION: staff raised high with both hands, water splashes and bubbles swirling above the head.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: golden staff topped with a glowing water-drop crystal (#7FE8FF), RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Heal: golden staff topped with a glowing water-drop crystal (#7FE8FF), RIGHT hand; long teal hair (#2BB3A8) tied low behind the back; soft turquoise eyes, always open; ornate white robe with turquoise panels (#3CC7C0), gold embroidery and wave patterns; fair skin; long white robe skirt with turquoise hem; white and gold slippers. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no armor, no dark clothes. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `heal_attack.png` |
| 1-2 | attaque 2 | `heal_attack_2.png` |
| 1-3 | attaque 3 | `heal_attack_3.png` |
| 2-1 | sort 1 | `heal_cast.png` |
| 2-2 | sort 2 | `heal_cast_2.png` |
| 2-3 | marche | `heal_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE playable hero: Heal, armed with: golden staff topped with a glowing water-drop crystal (#7FE8FF), RIGHT hand.
SOURCE IMAGE: it shows this playable hero, Heal, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Heal (hero of the Marées nation)
- Hair: long teal hair (#2BB3A8) tied low behind the back
- Eyes: soft turquoise eyes, always open
- Skin: fair skin
- Top: ornate white robe with turquoise panels (#3CC7C0), gold embroidery and wave patterns
- Bottom: long white robe skirt with turquoise hem
- Feet: white and gold slippers
- Weapon: golden staff topped with a glowing water-drop crystal (#7FE8FF), RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no armor, no dark clothes.
WEAPON: golden staff topped with a glowing water-drop crystal (#7FE8FF), RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short water splashes and bubbles spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. FOCUS: eyes closed, staff held vertically in front of the face, water splashes and bubbles orb at the top.
5. INVOCATION: staff raised high with both hands, water splashes and bubbles swirling above the head.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: golden staff topped with a glowing water-drop crystal (#7FE8FF), RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Heal: golden staff topped with a glowing water-drop crystal (#7FE8FF), RIGHT hand; long teal hair (#2BB3A8) tied low behind the back; soft turquoise eyes, always open; ornate white robe with turquoise panels (#3CC7C0), gold embroidery and wave patterns; fair skin; long white robe skirt with turquoise hem; white and gold slippers. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no armor, no dark clothes. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `heal_back_attack.png` |
| 1-2 | attaque 2 — dos | `heal_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `heal_back_attack_3.png` |
| 2-1 | sort 1 — dos | `heal_back_cast.png` |
| 2-2 | sort 2 — dos | `heal_back_cast_2.png` |
| 2-3 | marche — dos | `heal_back_walk.png` |

L'export Zimut de l'Atelier copie aussi le repos (case 1 de la planche vues) vers `nations/heros/heal.png`.

## 3. Ennemis

### Pirate des mers — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/marees/` ; nomme tes images `pirate_des_mers_vues.png`, `pirate_des_mers_actions.png` et `pirate_des_mers_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Pirate des mers, armed with: short cutlass in the RIGHT hand.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Pirate des mers (enemy of the Marées nation)
- Hair: red bandana (#C8281E) over messy black hair, stubble
- Eyes: dark brown eyes, always open, one gold earring
- Top: blue coat (#2A4E8A) with gold buttons over a white shirt, crossed brown leather belts
- Bottom: dark brown trousers
- Feet: black boots
- Weapon: short cutlass in the RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hat, no eye patch, no wooden leg, no pistol, no parrot.
WEAPON: short cutlass in the RIGHT hand. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: short cutlass in the RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Pirate des mers: short cutlass in the RIGHT hand; red bandana (#C8281E) over messy black hair, stubble; dark brown eyes, always open, one gold earring; blue coat (#2A4E8A) with gold buttons over a white shirt, crossed brown leather belts; dark brown trousers; black boots. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hat, no eye patch, no wooden leg, no pistol, no parrot. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `pirate_des_mers.png` |
| 1-2 | repos de face, variante | `pirate_des_mers_idle_2.png` |
| 2-1 | repos de dos | `pirate_des_mers_back.png` |
| 2-2 | repos de dos, variante | `pirate_des_mers_back_idle_2.png` |

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Pirate des mers, armed with: short cutlass in the RIGHT hand.
SOURCE IMAGE: it shows this enemy monster, Pirate des mers, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Pirate des mers (enemy of the Marées nation)
- Hair: red bandana (#C8281E) over messy black hair, stubble
- Eyes: dark brown eyes, always open, one gold earring
- Top: blue coat (#2A4E8A) with gold buttons over a white shirt, crossed brown leather belts
- Bottom: dark brown trousers
- Feet: black boots
- Weapon: short cutlass in the RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hat, no eye patch, no wooden leg, no pistol, no parrot.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
WEAPON: short cutlass in the RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Pirate des mers: short cutlass in the RIGHT hand; red bandana (#C8281E) over messy black hair, stubble; dark brown eyes, always open, one gold earring; blue coat (#2A4E8A) with gold buttons over a white shirt, crossed brown leather belts; dark brown trousers; black boots. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hat, no eye patch, no wooden leg, no pistol, no parrot. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Pirate des mers, armed with: short cutlass in the RIGHT hand.
SOURCE IMAGE: it shows this enemy monster, Pirate des mers, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Pirate des mers (enemy of the Marées nation)
- Hair: red bandana (#C8281E) over messy black hair, stubble
- Eyes: dark brown eyes, always open, one gold earring
- Top: blue coat (#2A4E8A) with gold buttons over a white shirt, crossed brown leather belts
- Bottom: dark brown trousers
- Feet: black boots
- Weapon: short cutlass in the RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hat, no eye patch, no wooden leg, no pistol, no parrot.
WEAPON: short cutlass in the RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. CROSS SLASH: both daggers crossed high above the head, about to strike down.
2. LUNGE STAB: body stretched forward almost horizontal, one dagger thrust far ahead.
3. SPIN: body twisted, arms spread to both sides, short water splashes and bubbles slash arcs.
4. SHADOW KNEEL: kneeling, one hand on the ground, water splashes and bubbles rising around.
5. VANISH: half the body dissolving into water splashes and bubbles, only the eyes and daggers clear.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: short cutlass in the RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Pirate des mers: short cutlass in the RIGHT hand; red bandana (#C8281E) over messy black hair, stubble; dark brown eyes, always open, one gold earring; blue coat (#2A4E8A) with gold buttons over a white shirt, crossed brown leather belts; dark brown trousers; black boots. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hat, no eye patch, no wooden leg, no pistol, no parrot. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `pirate_des_mers_attack.png` |
| 1-2 | attaque 2 | `pirate_des_mers_attack_2.png` |
| 1-3 | attaque 3 | `pirate_des_mers_attack_3.png` |
| 2-1 | sort 1 | `pirate_des_mers_cast.png` |
| 2-2 | sort 2 | `pirate_des_mers_cast_2.png` |
| 2-3 | marche | `pirate_des_mers_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Pirate des mers, armed with: short cutlass in the RIGHT hand.
SOURCE IMAGE: it shows this enemy monster, Pirate des mers, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Pirate des mers (enemy of the Marées nation)
- Hair: red bandana (#C8281E) over messy black hair, stubble
- Eyes: dark brown eyes, always open, one gold earring
- Top: blue coat (#2A4E8A) with gold buttons over a white shirt, crossed brown leather belts
- Bottom: dark brown trousers
- Feet: black boots
- Weapon: short cutlass in the RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hat, no eye patch, no wooden leg, no pistol, no parrot.
WEAPON: short cutlass in the RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. CROSS SLASH: both daggers crossed high above the head, about to strike down.
2. LUNGE STAB: body stretched forward almost horizontal, one dagger thrust far ahead.
3. SPIN: body twisted, arms spread to both sides, short water splashes and bubbles slash arcs.
4. SHADOW KNEEL: kneeling, one hand on the ground, water splashes and bubbles rising around.
5. VANISH: half the body dissolving into water splashes and bubbles, only the eyes and daggers clear.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: short cutlass in the RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Pirate des mers: short cutlass in the RIGHT hand; red bandana (#C8281E) over messy black hair, stubble; dark brown eyes, always open, one gold earring; blue coat (#2A4E8A) with gold buttons over a white shirt, crossed brown leather belts; dark brown trousers; black boots. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hat, no eye patch, no wooden leg, no pistol, no parrot. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `pirate_des_mers_back_attack.png` |
| 1-2 | attaque 2 — dos | `pirate_des_mers_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `pirate_des_mers_back_attack_3.png` |
| 2-1 | sort 1 — dos | `pirate_des_mers_back_cast.png` |
| 2-2 | sort 2 — dos | `pirate_des_mers_back_cast_2.png` |
| 2-3 | marche — dos | `pirate_des_mers_back_walk.png` |

### Requin — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/marees/` ; nomme tes images `requin_vues.png`, `requin_actions.png` et `requin_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Requin — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Requin (enemy of the Marées nation)
- Body: blue shark (#3A6EB8) with a white belly, standing upright in the air on its tail
- Head: wide toothy grin with white teeth, small black eyes
- Details: two pectoral fins used like small arms
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no weapon, no armor.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Requin: blue shark (#3A6EB8) with a white belly, standing upright in the air on its tail; wide toothy grin with white teeth, small black eyes; two pectoral fins used like small arms. NO weapon and no held object, ever. Forbidden: no legs, no weapon, no armor. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `requin.png` |
| 1-2 | repos de face, variante | `requin_idle_2.png` |
| 2-1 | repos de dos | `requin_back.png` |
| 2-2 | repos de dos, variante | `requin_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Requin — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Requin, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Requin (enemy of the Marées nation)
- Body: blue shark (#3A6EB8) with a white belly, standing upright in the air on its tail
- Head: wide toothy grin with white teeth, small black eyes
- Details: two pectoral fins used like small arms
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no weapon, no armor.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Requin: blue shark (#3A6EB8) with a white belly, standing upright in the air on its tail; wide toothy grin with white teeth, small black eyes; two pectoral fins used like small arms. NO weapon and no held object, ever. Forbidden: no legs, no weapon, no armor. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Requin — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Requin, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Requin (enemy of the Marées nation)
- Body: blue shark (#3A6EB8) with a white belly, standing upright in the air on its tail
- Head: wide toothy grin with white teeth, small black eyes
- Details: two pectoral fins used like small arms
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no weapon, no armor.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. POUNCE: body stretched forward in the air, jaws open.
3. SIDE SWIPE: head and claws swept to the side, body twisted.
4. HOWL: head raised to the sky, water splashes and bubbles gathering around the body.
5. ROAR: mouth wide open, water splashes and bubbles burst in front of the head.
6. WALK: mid-stride, one front paw raised, body moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Requin: blue shark (#3A6EB8) with a white belly, standing upright in the air on its tail; wide toothy grin with white teeth, small black eyes; two pectoral fins used like small arms. NO weapon and no held object, ever. Forbidden: no legs, no weapon, no armor. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `requin_attack.png` |
| 1-2 | attaque 2 | `requin_attack_2.png` |
| 1-3 | attaque 3 | `requin_attack_3.png` |
| 2-1 | sort 1 | `requin_cast.png` |
| 2-2 | sort 2 | `requin_cast_2.png` |
| 2-3 | marche | `requin_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Requin — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Requin, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Requin (enemy of the Marées nation)
- Body: blue shark (#3A6EB8) with a white belly, standing upright in the air on its tail
- Head: wide toothy grin with white teeth, small black eyes
- Details: two pectoral fins used like small arms
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no weapon, no armor.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. POUNCE: body stretched forward in the air, jaws open.
3. SIDE SWIPE: head and claws swept to the side, body twisted.
4. HOWL: head raised to the sky, water splashes and bubbles gathering around the body.
5. ROAR: mouth wide open, water splashes and bubbles burst in front of the head.
6. WALK: mid-stride, one front paw raised, body moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Requin: blue shark (#3A6EB8) with a white belly, standing upright in the air on its tail; wide toothy grin with white teeth, small black eyes; two pectoral fins used like small arms. NO weapon and no held object, ever. Forbidden: no legs, no weapon, no armor. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `requin_back_attack.png` |
| 1-2 | attaque 2 — dos | `requin_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `requin_back_attack_3.png` |
| 2-1 | sort 1 — dos | `requin_back_cast.png` |
| 2-2 | sort 2 — dos | `requin_back_cast_2.png` |
| 2-3 | marche — dos | `requin_back_walk.png` |

### Néréide — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/marees/` ; nomme tes images `nereide_vues.png`, `nereide_actions.png` et `nereide_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Néréide — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Néréide (enemy of the Marées nation)
- Body: water nymph whose body is made of opaque turquoise water (#3CC7C0) with lighter highlights
- Head: flowing hair of white-capped waves, glowing white eyes, small shell crown
- Bottom: lower body ends in a swirl of water, no legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no clothes, no weapon, no fish tail with scales.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Néréide: water nymph whose body is made of opaque turquoise water (#3CC7C0) with lighter highlights; flowing hair of white-capped waves, glowing white eyes, small shell crown; lower body ends in a swirl of water, no legs. NO weapon and no held object, ever. Forbidden: no clothes, no weapon, no fish tail with scales. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `nereide.png` |
| 1-2 | repos de face, variante | `nereide_idle_2.png` |
| 2-1 | repos de dos | `nereide_back.png` |
| 2-2 | repos de dos, variante | `nereide_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Néréide — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Néréide, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Néréide (enemy of the Marées nation)
- Body: water nymph whose body is made of opaque turquoise water (#3CC7C0) with lighter highlights
- Head: flowing hair of white-capped waves, glowing white eyes, small shell crown
- Bottom: lower body ends in a swirl of water, no legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no clothes, no weapon, no fish tail with scales.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Néréide: water nymph whose body is made of opaque turquoise water (#3CC7C0) with lighter highlights; flowing hair of white-capped waves, glowing white eyes, small shell crown; lower body ends in a swirl of water, no legs. NO weapon and no held object, ever. Forbidden: no clothes, no weapon, no fish tail with scales. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Néréide — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Néréide, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Néréide (enemy of the Marées nation)
- Body: water nymph whose body is made of opaque turquoise water (#3CC7C0) with lighter highlights
- Head: flowing hair of white-capped waves, glowing white eyes, small shell crown
- Bottom: lower body ends in a swirl of water, no legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no clothes, no weapon, no fish tail with scales.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. LUNGE: body stretched forward, claws of water splashes and bubbles reaching out.
3. SPIN: body whirling, water splashes and bubbles trail around it.
4. HOVER: floating higher, water splashes and bubbles orbs circling.
5. PULSE: arms spread, water splashes and bubbles pulsing outward.
6. DRIFT: floating forward with the body tilted slightly ahead, a short trail behind.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Néréide: water nymph whose body is made of opaque turquoise water (#3CC7C0) with lighter highlights; flowing hair of white-capped waves, glowing white eyes, small shell crown; lower body ends in a swirl of water, no legs. NO weapon and no held object, ever. Forbidden: no clothes, no weapon, no fish tail with scales. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `nereide_attack.png` |
| 1-2 | attaque 2 | `nereide_attack_2.png` |
| 1-3 | attaque 3 | `nereide_attack_3.png` |
| 2-1 | sort 1 | `nereide_cast.png` |
| 2-2 | sort 2 | `nereide_cast_2.png` |
| 2-3 | marche | `nereide_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Néréide — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Néréide, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Néréide (enemy of the Marées nation)
- Body: water nymph whose body is made of opaque turquoise water (#3CC7C0) with lighter highlights
- Head: flowing hair of white-capped waves, glowing white eyes, small shell crown
- Bottom: lower body ends in a swirl of water, no legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no clothes, no weapon, no fish tail with scales.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. LUNGE: body stretched forward, claws of water splashes and bubbles reaching out.
3. SPIN: body whirling, water splashes and bubbles trail around it.
4. HOVER: floating higher, water splashes and bubbles orbs circling.
5. PULSE: arms spread, water splashes and bubbles pulsing outward.
6. DRIFT: floating forward with the body tilted slightly ahead, a short trail behind.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Néréide: water nymph whose body is made of opaque turquoise water (#3CC7C0) with lighter highlights; flowing hair of white-capped waves, glowing white eyes, small shell crown; lower body ends in a swirl of water, no legs. NO weapon and no held object, ever. Forbidden: no clothes, no weapon, no fish tail with scales. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `nereide_back_attack.png` |
| 1-2 | attaque 2 — dos | `nereide_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `nereide_back_attack_3.png` |
| 2-1 | sort 1 — dos | `nereide_back_cast.png` |
| 2-2 | sort 2 — dos | `nereide_back_cast_2.png` |
| 2-3 | marche — dos | `nereide_back_walk.png` |

### Crabe géant — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/marees/` ; nomme tes images `crabe_geant_vues.png`, `crabe_geant_actions.png` et `crabe_geant_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Crabe géant — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Crabe géant (enemy of the Marées nation)
- Body: giant crab with a blue shell (#2E62B0) striped with red (#D23A2A), six walking legs
- Head: two eyes on short stalks, small mouth
- Details: two huge pincers, the right one bigger
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human body, no weapon.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Crabe géant: giant crab with a blue shell (#2E62B0) striped with red (#D23A2A), six walking legs; two eyes on short stalks, small mouth; two huge pincers, the right one bigger. NO weapon and no held object, ever. Forbidden: no human body, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `crabe_geant.png` |
| 1-2 | repos de face, variante | `crabe_geant_idle_2.png` |
| 2-1 | repos de dos | `crabe_geant_back.png` |
| 2-2 | repos de dos, variante | `crabe_geant_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Crabe géant — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Crabe géant, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Crabe géant (enemy of the Marées nation)
- Body: giant crab with a blue shell (#2E62B0) striped with red (#D23A2A), six walking legs
- Head: two eyes on short stalks, small mouth
- Details: two huge pincers, the right one bigger
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human body, no weapon.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Crabe géant: giant crab with a blue shell (#2E62B0) striped with red (#D23A2A), six walking legs; two eyes on short stalks, small mouth; two huge pincers, the right one bigger. NO weapon and no held object, ever. Forbidden: no human body, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Crabe géant — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Crabe géant, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Crabe géant (enemy of the Marées nation)
- Body: giant crab with a blue shell (#2E62B0) striped with red (#D23A2A), six walking legs
- Head: two eyes on short stalks, small mouth
- Details: two huge pincers, the right one bigger
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human body, no weapon.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. POUNCE: body stretched forward in the air, jaws open.
3. SIDE SWIPE: head and claws swept to the side, body twisted.
4. HOWL: head raised to the sky, water splashes and bubbles gathering around the body.
5. ROAR: mouth wide open, water splashes and bubbles burst in front of the head.
6. WALK: mid-stride, one front paw raised, body moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Crabe géant: giant crab with a blue shell (#2E62B0) striped with red (#D23A2A), six walking legs; two eyes on short stalks, small mouth; two huge pincers, the right one bigger. NO weapon and no held object, ever. Forbidden: no human body, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `crabe_geant_attack.png` |
| 1-2 | attaque 2 | `crabe_geant_attack_2.png` |
| 1-3 | attaque 3 | `crabe_geant_attack_3.png` |
| 2-1 | sort 1 | `crabe_geant_cast.png` |
| 2-2 | sort 2 | `crabe_geant_cast_2.png` |
| 2-3 | marche | `crabe_geant_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Crabe géant — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Crabe géant, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Crabe géant (enemy of the Marées nation)
- Body: giant crab with a blue shell (#2E62B0) striped with red (#D23A2A), six walking legs
- Head: two eyes on short stalks, small mouth
- Details: two huge pincers, the right one bigger
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human body, no weapon.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. POUNCE: body stretched forward in the air, jaws open.
3. SIDE SWIPE: head and claws swept to the side, body twisted.
4. HOWL: head raised to the sky, water splashes and bubbles gathering around the body.
5. ROAR: mouth wide open, water splashes and bubbles burst in front of the head.
6. WALK: mid-stride, one front paw raised, body moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Crabe géant: giant crab with a blue shell (#2E62B0) striped with red (#D23A2A), six walking legs; two eyes on short stalks, small mouth; two huge pincers, the right one bigger. NO weapon and no held object, ever. Forbidden: no human body, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `crabe_geant_back_attack.png` |
| 1-2 | attaque 2 — dos | `crabe_geant_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `crabe_geant_back_attack_3.png` |
| 2-1 | sort 1 — dos | `crabe_geant_back_cast.png` |
| 2-2 | sort 2 — dos | `crabe_geant_back_cast_2.png` |
| 2-3 | marche — dos | `crabe_geant_back_walk.png` |

## 4. Boss

### Néréa la Tempête — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `marees_vues.png`, `marees_actions.png` et `marees_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE final boss: Néréa la Tempête, armed with: golden trident, RIGHT hand.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Néréa la Tempête (boss of the Marées nation)
- Body: sea queen in turquoise coral armor (#2BB8B0) with gold edges, flowing white sea-foam cape
- Head: crown of red coral branches, long deep-blue hair, blue eyes
- Weapon: golden trident, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no fish tail, no sword.
WEAPON: golden trident, RIGHT hand. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: golden trident, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Néréa la Tempête: golden trident, RIGHT hand; sea queen in turquoise coral armor (#2BB8B0) with gold edges, flowing white sea-foam cape; crown of red coral branches, long deep-blue hair, blue eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no fish tail, no sword. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `marees.png` |
| 1-2 | repos de face, variante | `marees_idle_2.png` |
| 2-1 | repos de dos | `marees_back.png` |
| 2-2 | repos de dos, variante | `marees_back_idle_2.png` |

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE final boss: Néréa la Tempête, armed with: golden trident, RIGHT hand.
SOURCE IMAGE: it shows this final boss, Néréa la Tempête, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Néréa la Tempête (boss of the Marées nation)
- Body: sea queen in turquoise coral armor (#2BB8B0) with gold edges, flowing white sea-foam cape
- Head: crown of red coral branches, long deep-blue hair, blue eyes
- Weapon: golden trident, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no fish tail, no sword.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
WEAPON: golden trident, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Néréa la Tempête: golden trident, RIGHT hand; sea queen in turquoise coral armor (#2BB8B0) with gold edges, flowing white sea-foam cape; crown of red coral branches, long deep-blue hair, blue eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no fish tail, no sword. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE final boss: Néréa la Tempête, armed with: golden trident, RIGHT hand.
SOURCE IMAGE: it shows this final boss, Néréa la Tempête, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Néréa la Tempête (boss of the Marées nation)
- Body: sea queen in turquoise coral armor (#2BB8B0) with gold edges, flowing white sea-foam cape
- Head: crown of red coral branches, long deep-blue hair, blue eyes
- Weapon: golden trident, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no fish tail, no sword.
WEAPON: golden trident, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short water splashes and bubbles spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. FOCUS: eyes closed, staff held vertically in front of the face, water splashes and bubbles orb at the top.
5. INVOCATION: staff raised high with both hands, water splashes and bubbles swirling above the head.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: golden trident, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Néréa la Tempête: golden trident, RIGHT hand; sea queen in turquoise coral armor (#2BB8B0) with gold edges, flowing white sea-foam cape; crown of red coral branches, long deep-blue hair, blue eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no fish tail, no sword. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `marees_attack.png` |
| 1-2 | attaque 2 | `marees_attack_2.png` |
| 1-3 | attaque 3 | `marees_attack_3.png` |
| 2-1 | sort 1 | `marees_cast.png` |
| 2-2 | sort 2 | `marees_cast_2.png` |
| 2-3 | marche | `marees_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE final boss: Néréa la Tempête, armed with: golden trident, RIGHT hand.
SOURCE IMAGE: it shows this final boss, Néréa la Tempête, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Néréa la Tempête (boss of the Marées nation)
- Body: sea queen in turquoise coral armor (#2BB8B0) with gold edges, flowing white sea-foam cape
- Head: crown of red coral branches, long deep-blue hair, blue eyes
- Weapon: golden trident, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no fish tail, no sword.
WEAPON: golden trident, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short water splashes and bubbles spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. FOCUS: eyes closed, staff held vertically in front of the face, water splashes and bubbles orb at the top.
5. INVOCATION: staff raised high with both hands, water splashes and bubbles swirling above the head.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: golden trident, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Néréa la Tempête: golden trident, RIGHT hand; sea queen in turquoise coral armor (#2BB8B0) with gold edges, flowing white sea-foam cape; crown of red coral branches, long deep-blue hair, blue eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no fish tail, no sword. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `marees_back_attack.png` |
| 1-2 | attaque 2 — dos | `marees_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `marees_back_attack_3.png` |
| 2-1 | sort 1 — dos | `marees_back_cast.png` |
| 2-2 | sort 2 — dos | `marees_back_cast_2.png` |
| 2-3 | marche — dos | `marees_back_walk.png` |

## Prompt négatif

**Personnages armés — planches vues** :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, weapon changing shape, weapon changing color, weapon replaced by another weapon, missing weapon, missing accessories, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, different character between poses, realistic proportions, small head, more than 4 sprites, extra sprites, duplicated row of sprites, one sprite bigger or smaller than the others, size changing between cells
```

**Personnages armés — planches actions et planche de style** :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, weapon changing shape, weapon changing color, weapon replaced by another weapon, missing weapon, missing accessories, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, different character between poses, realistic proportions, small head
```

**Créatures sans arme (Salamandre, golems, bêtes…) — planches vues** :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, extra objects, different character between poses, realistic proportions, small head, more than 4 sprites, extra sprites, duplicated row of sprites, one sprite bigger or smaller than the others, size changing between cells, weapon, torch, staff, sword, bow, held object, tool, item in the hands or claws
```

**Créatures sans arme — planches actions** :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, extra objects, different character between poses, realistic proportions, small head, weapon, torch, staff, sword, bow, held object, tool, item in the hands or claws
```
