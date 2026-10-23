# Nation Ombres (Ombres)

Palette : black, charcoal, violet glow, silver-teal cloth accents. Effets : violet shadow smoke. Contre-jour : violet.

Format 3 planches par personnage (V44) :

1. **Vues** — 4 cases : repos de FACE ×2 (deux attitudes différentes) puis repos de DOS ×2, tout orienté vers la droite (le jeu retourne l'image pour la gauche). Grille 2 × 2 sur image 2:1, poses largement espacées. Génération normale.
2. **Actions de face** — 3 attaques + 2 sorts + 1 marche (3 colonnes × 2 rangées), en **édition** de la planche vues : le personnage réellement dessiné sert d'ancre.
3. **Actions de dos** — les mêmes 6 poses vues de dos, en édition de la planche vues. Une planche = un seul sens de vue (face et dos mélangés sur une même planche étaient dessinés de face). Facultative pour les monstres.

Les personnages **armés** ont l'arme écrite dans la première phrase, dans la carte d'identité, en fin de prompt et dans chaque pose ; les **créatures** reçoivent « UNARMED » (plus de torche inventée). Chaque prompt recopie la carte d'identité (`identites.py`) : aucune image à joindre. Ordre conseillé : 1) planche de style, 2) héros, 3) ennemis, 4) boss ; pour chaque personnage : vues, actions de face, actions de dos. Prompt négatif : en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Ombres nation (Ombres biome).
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents. Signature effects: violet shadow smoke.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: two rows with the same 6 characters in the same order, all in idle pose. Top row: 3/4 front view, facing front-right. Bottom row: 3/4 back view, seen from behind, turned toward the upper right. All feet of a row on the same ground line. Leave a wide empty gap (at least half a character width) between characters and between the two rows: nobody overlaps or touches anyone, weapons and capes included. Image aspect ratio 2:1, as large as possible.
CHARACTERS, left to right:
1. the hero (Assassin: agile assassin with black hair, a black cloth mask covering the lower face (eyes clearly visible), dark charcoal hooded armor with layered tattered silver-teal cloth panels, violet glowing rune details, a curved dagger in each hand).
2. Assassin des ombres (hunched shadow beast-assassin with a spiky purple mane and long claws).
3. Ombre infernale (swirling mass of purple shadow with claws and glowing eyes).
4. Spectre (violet spectral figure wrapped in shadow curls, long claw-like hands).
5. Liche (tall dark purple lich in a spiked robe holding a staff).
6. the final boss Nébulia l'Illusionniste (tall illusionist in black armor with spiky layers of silver-teal tattered cloth, horned mask-helm, long blades, mirror-like violet glints), about 1.5x taller than the others.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Assassin — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `assassin_vues.png`, `assassin_actions.png` et `assassin_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE playable hero: Assassin, armed with: one curved dagger in EACH hand.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Assassin (hero of the Ombres nation)
- Hair: spiky black hair (#121216)
- Eyes: violet glowing eyes (#B070FF), always visible above the mask
- Face: black cloth mask covering the nose and mouth
- Top: dark charcoal hooded armor (#2A2C33), hood DOWN, layered tattered silver-teal cloth panels (#8FC9C0), violet rune details
- Bottom: charcoal trousers with silver-teal cloth strips
- Feet: black soft boots
- Weapon: one curved dagger in EACH hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no horns, no helmet, no claws, no sword.
WEAPON: one curved dagger in EACH hand. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: one curved dagger in EACH hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Assassin: one curved dagger in EACH hand; spiky black hair (#121216); violet glowing eyes (#B070FF), always visible above the mask; dark charcoal hooded armor (#2A2C33), hood DOWN, layered tattered silver-teal cloth panels (#8FC9C0), violet rune details; black cloth mask covering the nose and mouth; charcoal trousers with silver-teal cloth strips; black soft boots. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no horns, no helmet, no claws, no sword. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `assassin.png` |
| 1-2 | repos de face, variante | `assassin_idle_2.png` |
| 2-1 | repos de dos | `assassin_back.png` |
| 2-2 | repos de dos, variante | `assassin_back_idle_2.png` |

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE playable hero: Assassin, armed with: one curved dagger in EACH hand.
SOURCE IMAGE: it shows this playable hero, Assassin, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Assassin (hero of the Ombres nation)
- Hair: spiky black hair (#121216)
- Eyes: violet glowing eyes (#B070FF), always visible above the mask
- Face: black cloth mask covering the nose and mouth
- Top: dark charcoal hooded armor (#2A2C33), hood DOWN, layered tattered silver-teal cloth panels (#8FC9C0), violet rune details
- Bottom: charcoal trousers with silver-teal cloth strips
- Feet: black soft boots
- Weapon: one curved dagger in EACH hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no horns, no helmet, no claws, no sword.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
WEAPON: one curved dagger in EACH hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Assassin: one curved dagger in EACH hand; spiky black hair (#121216); violet glowing eyes (#B070FF), always visible above the mask; dark charcoal hooded armor (#2A2C33), hood DOWN, layered tattered silver-teal cloth panels (#8FC9C0), violet rune details; black cloth mask covering the nose and mouth; charcoal trousers with silver-teal cloth strips; black soft boots. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no horns, no helmet, no claws, no sword. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE playable hero: Assassin, armed with: one curved dagger in EACH hand.
SOURCE IMAGE: it shows this playable hero, Assassin, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Assassin (hero of the Ombres nation)
- Hair: spiky black hair (#121216)
- Eyes: violet glowing eyes (#B070FF), always visible above the mask
- Face: black cloth mask covering the nose and mouth
- Top: dark charcoal hooded armor (#2A2C33), hood DOWN, layered tattered silver-teal cloth panels (#8FC9C0), violet rune details
- Bottom: charcoal trousers with silver-teal cloth strips
- Feet: black soft boots
- Weapon: one curved dagger in EACH hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no horns, no helmet, no claws, no sword.
WEAPON: one curved dagger in EACH hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. CROSS SLASH: both daggers crossed high above the head, about to strike down.
2. LUNGE STAB: body stretched forward almost horizontal, one dagger thrust far ahead.
3. SPIN: body twisted, arms spread to both sides, short violet shadow smoke slash arcs.
4. SHADOW KNEEL: kneeling, one hand on the ground, violet shadow smoke rising around.
5. VANISH: half the body dissolving into violet shadow smoke, only the eyes and daggers clear.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: one curved dagger in EACH hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Assassin: one curved dagger in EACH hand; spiky black hair (#121216); violet glowing eyes (#B070FF), always visible above the mask; dark charcoal hooded armor (#2A2C33), hood DOWN, layered tattered silver-teal cloth panels (#8FC9C0), violet rune details; black cloth mask covering the nose and mouth; charcoal trousers with silver-teal cloth strips; black soft boots. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no horns, no helmet, no claws, no sword. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `assassin_attack.png` |
| 1-2 | attaque 2 | `assassin_attack_2.png` |
| 1-3 | attaque 3 | `assassin_attack_3.png` |
| 2-1 | sort 1 | `assassin_cast.png` |
| 2-2 | sort 2 | `assassin_cast_2.png` |
| 2-3 | marche | `assassin_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE playable hero: Assassin, armed with: one curved dagger in EACH hand.
SOURCE IMAGE: it shows this playable hero, Assassin, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Assassin (hero of the Ombres nation)
- Hair: spiky black hair (#121216)
- Eyes: violet glowing eyes (#B070FF), always visible above the mask
- Face: black cloth mask covering the nose and mouth
- Top: dark charcoal hooded armor (#2A2C33), hood DOWN, layered tattered silver-teal cloth panels (#8FC9C0), violet rune details
- Bottom: charcoal trousers with silver-teal cloth strips
- Feet: black soft boots
- Weapon: one curved dagger in EACH hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no horns, no helmet, no claws, no sword.
WEAPON: one curved dagger in EACH hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. CROSS SLASH: both daggers crossed high above the head, about to strike down.
2. LUNGE STAB: body stretched forward almost horizontal, one dagger thrust far ahead.
3. SPIN: body twisted, arms spread to both sides, short violet shadow smoke slash arcs.
4. SHADOW KNEEL: kneeling, one hand on the ground, violet shadow smoke rising around.
5. VANISH: half the body dissolving into violet shadow smoke, only the eyes and daggers clear.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: one curved dagger in EACH hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Assassin: one curved dagger in EACH hand; spiky black hair (#121216); violet glowing eyes (#B070FF), always visible above the mask; dark charcoal hooded armor (#2A2C33), hood DOWN, layered tattered silver-teal cloth panels (#8FC9C0), violet rune details; black cloth mask covering the nose and mouth; charcoal trousers with silver-teal cloth strips; black soft boots. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no horns, no helmet, no claws, no sword. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `assassin_back_attack.png` |
| 1-2 | attaque 2 — dos | `assassin_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `assassin_back_attack_3.png` |
| 2-1 | sort 1 — dos | `assassin_back_cast.png` |
| 2-2 | sort 2 — dos | `assassin_back_cast_2.png` |
| 2-3 | marche — dos | `assassin_back_walk.png` |

L'export Zimut de l'Atelier copie aussi le repos (case 1 de la planche vues) vers `nations/heros/assassin.png`.

## 3. Ennemis

### Assassin des ombres — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/ombres/` ; nomme tes images `assassin_des_ombres_vues.png`, `assassin_des_ombres_actions.png` et `assassin_des_ombres_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Assassin des ombres — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Assassin des ombres (enemy of the Ombres nation)
- Body: hunched four-legged shadow beast, black body (#141418) with charcoal armor straps and silver-teal cloth bands (#8FC9C0) on the legs
- Head: spiky purple mane (#8A3FD8) on head and back, glowing violet eyes (#B070FF)
- Details: long black claws, violet lightning glints
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human face, no hood, no weapon in hand.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Assassin des ombres: hunched four-legged shadow beast, black body (#141418) with charcoal armor straps and silver-teal cloth bands (#8FC9C0) on the legs; spiky purple mane (#8A3FD8) on head and back, glowing violet eyes (#B070FF); long black claws, violet lightning glints. NO weapon and no held object, ever. Forbidden: no human face, no hood, no weapon in hand. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `assassin_des_ombres.png` |
| 1-2 | repos de face, variante | `assassin_des_ombres_idle_2.png` |
| 2-1 | repos de dos | `assassin_des_ombres_back.png` |
| 2-2 | repos de dos, variante | `assassin_des_ombres_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Assassin des ombres — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Assassin des ombres, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Assassin des ombres (enemy of the Ombres nation)
- Body: hunched four-legged shadow beast, black body (#141418) with charcoal armor straps and silver-teal cloth bands (#8FC9C0) on the legs
- Head: spiky purple mane (#8A3FD8) on head and back, glowing violet eyes (#B070FF)
- Details: long black claws, violet lightning glints
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human face, no hood, no weapon in hand.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Assassin des ombres: hunched four-legged shadow beast, black body (#141418) with charcoal armor straps and silver-teal cloth bands (#8FC9C0) on the legs; spiky purple mane (#8A3FD8) on head and back, glowing violet eyes (#B070FF); long black claws, violet lightning glints. NO weapon and no held object, ever. Forbidden: no human face, no hood, no weapon in hand. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Assassin des ombres — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Assassin des ombres, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Assassin des ombres (enemy of the Ombres nation)
- Body: hunched four-legged shadow beast, black body (#141418) with charcoal armor straps and silver-teal cloth bands (#8FC9C0) on the legs
- Head: spiky purple mane (#8A3FD8) on head and back, glowing violet eyes (#B070FF)
- Details: long black claws, violet lightning glints
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human face, no hood, no weapon in hand.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. POUNCE: body stretched forward in the air, jaws open.
3. SIDE SWIPE: head and claws swept to the side, body twisted.
4. HOWL: head raised to the sky, violet shadow smoke gathering around the body.
5. ROAR: mouth wide open, violet shadow smoke burst in front of the head.
6. WALK: mid-stride, one front paw raised, body moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Assassin des ombres: hunched four-legged shadow beast, black body (#141418) with charcoal armor straps and silver-teal cloth bands (#8FC9C0) on the legs; spiky purple mane (#8A3FD8) on head and back, glowing violet eyes (#B070FF); long black claws, violet lightning glints. NO weapon and no held object, ever. Forbidden: no human face, no hood, no weapon in hand. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `assassin_des_ombres_attack.png` |
| 1-2 | attaque 2 | `assassin_des_ombres_attack_2.png` |
| 1-3 | attaque 3 | `assassin_des_ombres_attack_3.png` |
| 2-1 | sort 1 | `assassin_des_ombres_cast.png` |
| 2-2 | sort 2 | `assassin_des_ombres_cast_2.png` |
| 2-3 | marche | `assassin_des_ombres_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Assassin des ombres — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Assassin des ombres, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Assassin des ombres (enemy of the Ombres nation)
- Body: hunched four-legged shadow beast, black body (#141418) with charcoal armor straps and silver-teal cloth bands (#8FC9C0) on the legs
- Head: spiky purple mane (#8A3FD8) on head and back, glowing violet eyes (#B070FF)
- Details: long black claws, violet lightning glints
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human face, no hood, no weapon in hand.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. POUNCE: body stretched forward in the air, jaws open.
3. SIDE SWIPE: head and claws swept to the side, body twisted.
4. HOWL: head raised to the sky, violet shadow smoke gathering around the body.
5. ROAR: mouth wide open, violet shadow smoke burst in front of the head.
6. WALK: mid-stride, one front paw raised, body moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Assassin des ombres: hunched four-legged shadow beast, black body (#141418) with charcoal armor straps and silver-teal cloth bands (#8FC9C0) on the legs; spiky purple mane (#8A3FD8) on head and back, glowing violet eyes (#B070FF); long black claws, violet lightning glints. NO weapon and no held object, ever. Forbidden: no human face, no hood, no weapon in hand. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `assassin_des_ombres_back_attack.png` |
| 1-2 | attaque 2 — dos | `assassin_des_ombres_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `assassin_des_ombres_back_attack_3.png` |
| 2-1 | sort 1 — dos | `assassin_des_ombres_back_cast.png` |
| 2-2 | sort 2 — dos | `assassin_des_ombres_back_cast_2.png` |
| 2-3 | marche — dos | `assassin_des_ombres_back_walk.png` |

### Ombre infernale — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/ombres/` ; nomme tes images `ombre_infernale_vues.png`, `ombre_infernale_actions.png` et `ombre_infernale_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Ombre infernale — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombre infernale (enemy of the Ombres nation)
- Body: humanoid of purple-black shadow (#1E1428) in dark armor with silver-teal cloth panels (#8FC9C0)
- Head: round head of swirling purple shadow with ONE glowing violet eye (#C080FF), no mouth
- Details: long black claws, small purple flame wisps around the hands
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human face, no hair, no weapon.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Ombre infernale: humanoid of purple-black shadow (#1E1428) in dark armor with silver-teal cloth panels (#8FC9C0); round head of swirling purple shadow with ONE glowing violet eye (#C080FF), no mouth; long black claws, small purple flame wisps around the hands. NO weapon and no held object, ever. Forbidden: no human face, no hair, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `ombre_infernale.png` |
| 1-2 | repos de face, variante | `ombre_infernale_idle_2.png` |
| 2-1 | repos de dos | `ombre_infernale_back.png` |
| 2-2 | repos de dos, variante | `ombre_infernale_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Ombre infernale — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Ombre infernale, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombre infernale (enemy of the Ombres nation)
- Body: humanoid of purple-black shadow (#1E1428) in dark armor with silver-teal cloth panels (#8FC9C0)
- Head: round head of swirling purple shadow with ONE glowing violet eye (#C080FF), no mouth
- Details: long black claws, small purple flame wisps around the hands
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human face, no hair, no weapon.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Ombre infernale: humanoid of purple-black shadow (#1E1428) in dark armor with silver-teal cloth panels (#8FC9C0); round head of swirling purple shadow with ONE glowing violet eye (#C080FF), no mouth; long black claws, small purple flame wisps around the hands. NO weapon and no held object, ever. Forbidden: no human face, no hair, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Ombre infernale — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Ombre infernale, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombre infernale (enemy of the Ombres nation)
- Body: humanoid of purple-black shadow (#1E1428) in dark armor with silver-teal cloth panels (#8FC9C0)
- Head: round head of swirling purple shadow with ONE glowing violet eye (#C080FF), no mouth
- Details: long black claws, small purple flame wisps around the hands
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human face, no hair, no weapon.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. LUNGE: body stretched forward, claws of violet shadow smoke reaching out.
3. SPIN: body whirling, violet shadow smoke trail around it.
4. HOVER: floating higher, violet shadow smoke orbs circling.
5. PULSE: arms spread, violet shadow smoke pulsing outward.
6. DRIFT: floating forward with the body tilted slightly ahead, a short trail behind.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Ombre infernale: humanoid of purple-black shadow (#1E1428) in dark armor with silver-teal cloth panels (#8FC9C0); round head of swirling purple shadow with ONE glowing violet eye (#C080FF), no mouth; long black claws, small purple flame wisps around the hands. NO weapon and no held object, ever. Forbidden: no human face, no hair, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `ombre_infernale_attack.png` |
| 1-2 | attaque 2 | `ombre_infernale_attack_2.png` |
| 1-3 | attaque 3 | `ombre_infernale_attack_3.png` |
| 2-1 | sort 1 | `ombre_infernale_cast.png` |
| 2-2 | sort 2 | `ombre_infernale_cast_2.png` |
| 2-3 | marche | `ombre_infernale_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Ombre infernale — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Ombre infernale, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombre infernale (enemy of the Ombres nation)
- Body: humanoid of purple-black shadow (#1E1428) in dark armor with silver-teal cloth panels (#8FC9C0)
- Head: round head of swirling purple shadow with ONE glowing violet eye (#C080FF), no mouth
- Details: long black claws, small purple flame wisps around the hands
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human face, no hair, no weapon.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. LUNGE: body stretched forward, claws of violet shadow smoke reaching out.
3. SPIN: body whirling, violet shadow smoke trail around it.
4. HOVER: floating higher, violet shadow smoke orbs circling.
5. PULSE: arms spread, violet shadow smoke pulsing outward.
6. DRIFT: floating forward with the body tilted slightly ahead, a short trail behind.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Ombre infernale: humanoid of purple-black shadow (#1E1428) in dark armor with silver-teal cloth panels (#8FC9C0); round head of swirling purple shadow with ONE glowing violet eye (#C080FF), no mouth; long black claws, small purple flame wisps around the hands. NO weapon and no held object, ever. Forbidden: no human face, no hair, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `ombre_infernale_back_attack.png` |
| 1-2 | attaque 2 — dos | `ombre_infernale_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `ombre_infernale_back_attack_3.png` |
| 2-1 | sort 1 — dos | `ombre_infernale_back_cast.png` |
| 2-2 | sort 2 — dos | `ombre_infernale_back_cast_2.png` |
| 2-3 | marche — dos | `ombre_infernale_back_walk.png` |

### Spectre — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/ombres/` ; nomme tes images `spectre_vues.png`, `spectre_actions.png` et `spectre_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Spectre — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Spectre (enemy of the Ombres nation)
- Body: small hunched spectral figure, violet-grey skin (#5A4A78) wrapped in silver bandages
- Head: big bald round violet head, half-closed glowing lilac eyes (#C8A8FF)
- Bottom: silver-teal loincloth (#8FC9C0), lower body fading into dark shadow curls
- Details: long claw-like hands
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hair, no hood, no weapon.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Spectre: small hunched spectral figure, violet-grey skin (#5A4A78) wrapped in silver bandages; big bald round violet head, half-closed glowing lilac eyes (#C8A8FF); silver-teal loincloth (#8FC9C0), lower body fading into dark shadow curls; long claw-like hands. NO weapon and no held object, ever. Forbidden: no hair, no hood, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `spectre.png` |
| 1-2 | repos de face, variante | `spectre_idle_2.png` |
| 2-1 | repos de dos | `spectre_back.png` |
| 2-2 | repos de dos, variante | `spectre_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Spectre — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Spectre, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Spectre (enemy of the Ombres nation)
- Body: small hunched spectral figure, violet-grey skin (#5A4A78) wrapped in silver bandages
- Head: big bald round violet head, half-closed glowing lilac eyes (#C8A8FF)
- Bottom: silver-teal loincloth (#8FC9C0), lower body fading into dark shadow curls
- Details: long claw-like hands
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hair, no hood, no weapon.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Spectre: small hunched spectral figure, violet-grey skin (#5A4A78) wrapped in silver bandages; big bald round violet head, half-closed glowing lilac eyes (#C8A8FF); silver-teal loincloth (#8FC9C0), lower body fading into dark shadow curls; long claw-like hands. NO weapon and no held object, ever. Forbidden: no hair, no hood, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Spectre — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Spectre, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Spectre (enemy of the Ombres nation)
- Body: small hunched spectral figure, violet-grey skin (#5A4A78) wrapped in silver bandages
- Head: big bald round violet head, half-closed glowing lilac eyes (#C8A8FF)
- Bottom: silver-teal loincloth (#8FC9C0), lower body fading into dark shadow curls
- Details: long claw-like hands
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hair, no hood, no weapon.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. LUNGE: body stretched forward, claws of violet shadow smoke reaching out.
3. SPIN: body whirling, violet shadow smoke trail around it.
4. HOVER: floating higher, violet shadow smoke orbs circling.
5. PULSE: arms spread, violet shadow smoke pulsing outward.
6. DRIFT: floating forward with the body tilted slightly ahead, a short trail behind.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Spectre: small hunched spectral figure, violet-grey skin (#5A4A78) wrapped in silver bandages; big bald round violet head, half-closed glowing lilac eyes (#C8A8FF); silver-teal loincloth (#8FC9C0), lower body fading into dark shadow curls; long claw-like hands. NO weapon and no held object, ever. Forbidden: no hair, no hood, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `spectre_attack.png` |
| 1-2 | attaque 2 | `spectre_attack_2.png` |
| 1-3 | attaque 3 | `spectre_attack_3.png` |
| 2-1 | sort 1 | `spectre_cast.png` |
| 2-2 | sort 2 | `spectre_cast_2.png` |
| 2-3 | marche | `spectre_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Spectre — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Spectre, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Spectre (enemy of the Ombres nation)
- Body: small hunched spectral figure, violet-grey skin (#5A4A78) wrapped in silver bandages
- Head: big bald round violet head, half-closed glowing lilac eyes (#C8A8FF)
- Bottom: silver-teal loincloth (#8FC9C0), lower body fading into dark shadow curls
- Details: long claw-like hands
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hair, no hood, no weapon.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. LUNGE: body stretched forward, claws of violet shadow smoke reaching out.
3. SPIN: body whirling, violet shadow smoke trail around it.
4. HOVER: floating higher, violet shadow smoke orbs circling.
5. PULSE: arms spread, violet shadow smoke pulsing outward.
6. DRIFT: floating forward with the body tilted slightly ahead, a short trail behind.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Spectre: small hunched spectral figure, violet-grey skin (#5A4A78) wrapped in silver bandages; big bald round violet head, half-closed glowing lilac eyes (#C8A8FF); silver-teal loincloth (#8FC9C0), lower body fading into dark shadow curls; long claw-like hands. NO weapon and no held object, ever. Forbidden: no hair, no hood, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `spectre_back_attack.png` |
| 1-2 | attaque 2 — dos | `spectre_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `spectre_back_attack_3.png` |
| 2-1 | sort 1 — dos | `spectre_back_cast.png` |
| 2-2 | sort 2 — dos | `spectre_back_cast_2.png` |
| 2-3 | marche — dos | `spectre_back_walk.png` |

### Liche — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/ombres/` ; nomme tes images `liche_vues.png`, `liche_actions.png` et `liche_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Liche, armed with: dark staff topped with a violet crystal, RIGHT hand.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Liche (enemy of the Ombres nation)
- Body: tall dark lich in a black and purple spiked robe (#1E1428, #5A2A8A) with silver-teal trims
- Head: purple skull (#4A3460) with glowing white-violet eyes and a crown of black spikes
- Weapon: dark staff topped with a violet crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hair, no hood, no flesh face.
WEAPON: dark staff topped with a violet crystal, RIGHT hand. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: dark staff topped with a violet crystal, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Liche: dark staff topped with a violet crystal, RIGHT hand; tall dark lich in a black and purple spiked robe (#1E1428, #5A2A8A) with silver-teal trims; purple skull (#4A3460) with glowing white-violet eyes and a crown of black spikes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hair, no hood, no flesh face. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `liche.png` |
| 1-2 | repos de face, variante | `liche_idle_2.png` |
| 2-1 | repos de dos | `liche_back.png` |
| 2-2 | repos de dos, variante | `liche_back_idle_2.png` |

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Liche, armed with: dark staff topped with a violet crystal, RIGHT hand.
SOURCE IMAGE: it shows this enemy monster, Liche, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Liche (enemy of the Ombres nation)
- Body: tall dark lich in a black and purple spiked robe (#1E1428, #5A2A8A) with silver-teal trims
- Head: purple skull (#4A3460) with glowing white-violet eyes and a crown of black spikes
- Weapon: dark staff topped with a violet crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hair, no hood, no flesh face.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
WEAPON: dark staff topped with a violet crystal, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Liche: dark staff topped with a violet crystal, RIGHT hand; tall dark lich in a black and purple spiked robe (#1E1428, #5A2A8A) with silver-teal trims; purple skull (#4A3460) with glowing white-violet eyes and a crown of black spikes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hair, no hood, no flesh face. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Liche, armed with: dark staff topped with a violet crystal, RIGHT hand.
SOURCE IMAGE: it shows this enemy monster, Liche, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Liche (enemy of the Ombres nation)
- Body: tall dark lich in a black and purple spiked robe (#1E1428, #5A2A8A) with silver-teal trims
- Head: purple skull (#4A3460) with glowing white-violet eyes and a crown of black spikes
- Weapon: dark staff topped with a violet crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hair, no hood, no flesh face.
WEAPON: dark staff topped with a violet crystal, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short violet shadow smoke spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. FOCUS: eyes closed, staff held vertically in front of the face, violet shadow smoke orb at the top.
5. INVOCATION: staff raised high with both hands, violet shadow smoke swirling above the head.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: dark staff topped with a violet crystal, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Liche: dark staff topped with a violet crystal, RIGHT hand; tall dark lich in a black and purple spiked robe (#1E1428, #5A2A8A) with silver-teal trims; purple skull (#4A3460) with glowing white-violet eyes and a crown of black spikes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hair, no hood, no flesh face. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `liche_attack.png` |
| 1-2 | attaque 2 | `liche_attack_2.png` |
| 1-3 | attaque 3 | `liche_attack_3.png` |
| 2-1 | sort 1 | `liche_cast.png` |
| 2-2 | sort 2 | `liche_cast_2.png` |
| 2-3 | marche | `liche_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Liche, armed with: dark staff topped with a violet crystal, RIGHT hand.
SOURCE IMAGE: it shows this enemy monster, Liche, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Liche (enemy of the Ombres nation)
- Body: tall dark lich in a black and purple spiked robe (#1E1428, #5A2A8A) with silver-teal trims
- Head: purple skull (#4A3460) with glowing white-violet eyes and a crown of black spikes
- Weapon: dark staff topped with a violet crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hair, no hood, no flesh face.
WEAPON: dark staff topped with a violet crystal, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short violet shadow smoke spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. FOCUS: eyes closed, staff held vertically in front of the face, violet shadow smoke orb at the top.
5. INVOCATION: staff raised high with both hands, violet shadow smoke swirling above the head.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: dark staff topped with a violet crystal, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Liche: dark staff topped with a violet crystal, RIGHT hand; tall dark lich in a black and purple spiked robe (#1E1428, #5A2A8A) with silver-teal trims; purple skull (#4A3460) with glowing white-violet eyes and a crown of black spikes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hair, no hood, no flesh face. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `liche_back_attack.png` |
| 1-2 | attaque 2 — dos | `liche_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `liche_back_attack_3.png` |
| 2-1 | sort 1 — dos | `liche_back_cast.png` |
| 2-2 | sort 2 — dos | `liche_back_cast_2.png` |
| 2-3 | marche — dos | `liche_back_walk.png` |

## 4. Boss

### Nébulia l'Illusionniste — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `ombres_vues.png`, `ombres_actions.png` et `ombres_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE final boss: Nébulia l'Illusionniste, armed with: two long thin blades, one in each hand, violet mirror-like glints.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Nébulia l'Illusionniste (boss of the Ombres nation)
- Body: tall illusionist in black armor (#18181E) with spiky layers of silver-teal tattered cloth (#8FC9C0)
- Head: horned black mask-helm with a silver face plate, long white hair, glowing violet eyes
- Weapon: two long thin blades, one in each hand, violet mirror-like glints
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no shield, no staff.
WEAPON: two long thin blades, one in each hand, violet mirror-like glints. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: two long thin blades, one in each hand, violet mirror-like glints. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Nébulia l'Illusionniste: two long thin blades, one in each hand, violet mirror-like glints; tall illusionist in black armor (#18181E) with spiky layers of silver-teal tattered cloth (#8FC9C0); horned black mask-helm with a silver face plate, long white hair, glowing violet eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no shield, no staff. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `ombres.png` |
| 1-2 | repos de face, variante | `ombres_idle_2.png` |
| 2-1 | repos de dos | `ombres_back.png` |
| 2-2 | repos de dos, variante | `ombres_back_idle_2.png` |

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE final boss: Nébulia l'Illusionniste, armed with: two long thin blades, one in each hand, violet mirror-like glints.
SOURCE IMAGE: it shows this final boss, Nébulia l'Illusionniste, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Nébulia l'Illusionniste (boss of the Ombres nation)
- Body: tall illusionist in black armor (#18181E) with spiky layers of silver-teal tattered cloth (#8FC9C0)
- Head: horned black mask-helm with a silver face plate, long white hair, glowing violet eyes
- Weapon: two long thin blades, one in each hand, violet mirror-like glints
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no shield, no staff.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
WEAPON: two long thin blades, one in each hand, violet mirror-like glints. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Nébulia l'Illusionniste: two long thin blades, one in each hand, violet mirror-like glints; tall illusionist in black armor (#18181E) with spiky layers of silver-teal tattered cloth (#8FC9C0); horned black mask-helm with a silver face plate, long white hair, glowing violet eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no shield, no staff. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE final boss: Nébulia l'Illusionniste, armed with: two long thin blades, one in each hand, violet mirror-like glints.
SOURCE IMAGE: it shows this final boss, Nébulia l'Illusionniste, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Nébulia l'Illusionniste (boss of the Ombres nation)
- Body: tall illusionist in black armor (#18181E) with spiky layers of silver-teal tattered cloth (#8FC9C0)
- Head: horned black mask-helm with a silver face plate, long white hair, glowing violet eyes
- Weapon: two long thin blades, one in each hand, violet mirror-like glints
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no shield, no staff.
WEAPON: two long thin blades, one in each hand, violet mirror-like glints. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. CROSS SLASH: both daggers crossed high above the head, about to strike down.
2. LUNGE STAB: body stretched forward almost horizontal, one dagger thrust far ahead.
3. SPIN: body twisted, arms spread to both sides, short violet shadow smoke slash arcs.
4. SHADOW KNEEL: kneeling, one hand on the ground, violet shadow smoke rising around.
5. VANISH: half the body dissolving into violet shadow smoke, only the eyes and daggers clear.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: two long thin blades, one in each hand, violet mirror-like glints — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Nébulia l'Illusionniste: two long thin blades, one in each hand, violet mirror-like glints; tall illusionist in black armor (#18181E) with spiky layers of silver-teal tattered cloth (#8FC9C0); horned black mask-helm with a silver face plate, long white hair, glowing violet eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no shield, no staff. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `ombres_attack.png` |
| 1-2 | attaque 2 | `ombres_attack_2.png` |
| 1-3 | attaque 3 | `ombres_attack_3.png` |
| 2-1 | sort 1 | `ombres_cast.png` |
| 2-2 | sort 2 | `ombres_cast_2.png` |
| 2-3 | marche | `ombres_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE final boss: Nébulia l'Illusionniste, armed with: two long thin blades, one in each hand, violet mirror-like glints.
SOURCE IMAGE: it shows this final boss, Nébulia l'Illusionniste, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Nébulia l'Illusionniste (boss of the Ombres nation)
- Body: tall illusionist in black armor (#18181E) with spiky layers of silver-teal tattered cloth (#8FC9C0)
- Head: horned black mask-helm with a silver face plate, long white hair, glowing violet eyes
- Weapon: two long thin blades, one in each hand, violet mirror-like glints
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no shield, no staff.
WEAPON: two long thin blades, one in each hand, violet mirror-like glints. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. CROSS SLASH: both daggers crossed high above the head, about to strike down.
2. LUNGE STAB: body stretched forward almost horizontal, one dagger thrust far ahead.
3. SPIN: body twisted, arms spread to both sides, short violet shadow smoke slash arcs.
4. SHADOW KNEEL: kneeling, one hand on the ground, violet shadow smoke rising around.
5. VANISH: half the body dissolving into violet shadow smoke, only the eyes and daggers clear.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: two long thin blades, one in each hand, violet mirror-like glints — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Nébulia l'Illusionniste: two long thin blades, one in each hand, violet mirror-like glints; tall illusionist in black armor (#18181E) with spiky layers of silver-teal tattered cloth (#8FC9C0); horned black mask-helm with a silver face plate, long white hair, glowing violet eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no shield, no staff. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `ombres_back_attack.png` |
| 1-2 | attaque 2 — dos | `ombres_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `ombres_back_attack_3.png` |
| 2-1 | sort 1 — dos | `ombres_back_cast.png` |
| 2-2 | sort 2 — dos | `ombres_back_cast_2.png` |
| 2-3 | marche — dos | `ombres_back_walk.png` |

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
