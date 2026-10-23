# Familiers (invocations)

Fichiers dans `prototype/zimut/assets/sprites/summons/`. Format 3 planches par familier : **vues** (2 repos de face + 2 de dos), **actions de face** et **actions de dos** (3 attaques, 2 sorts, 1 marche), générées en édition de la planche vues comme pour les personnages. Joins la planche du héros qui l'invoque comme référence de style.

### Golem de pierre (Invocateur, ex-Tortue) — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/summons/` ; nomme tes images `golem_de_pierre_vues.png`, `golem_de_pierre_actions.png` et `golem_de_pierre_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE summoned familiar: Golem de pierre — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Golem de pierre (a summon)
- Body: grey stone golem (#7A7A82) with a broad body and big stone fists
- Head: small head with two glowing blue eyes
- Details: blue crystals (#5CC8FF) growing from the shoulders and back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no moss, no brown stone.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Golem de pierre: grey stone golem (#7A7A82) with a broad body and big stone fists; small head with two glowing blue eyes; blue crystals (#5CC8FF) growing from the shoulders and back. NO weapon and no held object, ever. Forbidden: no weapon, no moss, no brown stone. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `golem_de_pierre.png` |
| 1-2 | repos de face, variante | `golem_de_pierre_idle_2.png` |
| 2-1 | repos de dos | `golem_de_pierre_back.png` |
| 2-2 | repos de dos, variante | `golem_de_pierre_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE summoned familiar: Golem de pierre — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Golem de pierre, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Golem de pierre (a summon)
- Body: grey stone golem (#7A7A82) with a broad body and big stone fists
- Head: small head with two glowing blue eyes
- Details: blue crystals (#5CC8FF) growing from the shoulders and back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no moss, no brown stone.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Golem de pierre: grey stone golem (#7A7A82) with a broad body and big stone fists; small head with two glowing blue eyes; blue crystals (#5CC8FF) growing from the shoulders and back. NO weapon and no held object, ever. Forbidden: no weapon, no moss, no brown stone. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE summoned familiar: Golem de pierre — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Golem de pierre, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Golem de pierre (a summon)
- Body: grey stone golem (#7A7A82) with a broad body and big stone fists
- Head: small head with two glowing blue eyes
- Details: blue crystals (#5CC8FF) growing from the shoulders and back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no moss, no brown stone.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted.
4. ROOTED: stomping, matching magical sparks cracks spreading under the feet.
5. GATHER: arms raised, matching magical sparks gathering between the hands.
6. WALK: heavy mid-stride, one foot raised, arms swinging.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Golem de pierre: grey stone golem (#7A7A82) with a broad body and big stone fists; small head with two glowing blue eyes; blue crystals (#5CC8FF) growing from the shoulders and back. NO weapon and no held object, ever. Forbidden: no weapon, no moss, no brown stone. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `golem_de_pierre_attack.png` |
| 1-2 | attaque 2 | `golem_de_pierre_attack_2.png` |
| 1-3 | attaque 3 | `golem_de_pierre_attack_3.png` |
| 2-1 | sort 1 | `golem_de_pierre_cast.png` |
| 2-2 | sort 2 | `golem_de_pierre_cast_2.png` |
| 2-3 | marche | `golem_de_pierre_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE summoned familiar: Golem de pierre — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Golem de pierre, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Golem de pierre (a summon)
- Body: grey stone golem (#7A7A82) with a broad body and big stone fists
- Head: small head with two glowing blue eyes
- Details: blue crystals (#5CC8FF) growing from the shoulders and back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no moss, no brown stone.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted.
4. ROOTED: stomping, matching magical sparks cracks spreading under the feet.
5. GATHER: arms raised, matching magical sparks gathering between the hands.
6. WALK: heavy mid-stride, one foot raised, arms swinging.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Golem de pierre: grey stone golem (#7A7A82) with a broad body and big stone fists; small head with two glowing blue eyes; blue crystals (#5CC8FF) growing from the shoulders and back. NO weapon and no held object, ever. Forbidden: no weapon, no moss, no brown stone. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `golem_de_pierre_back_attack.png` |
| 1-2 | attaque 2 — dos | `golem_de_pierre_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `golem_de_pierre_back_attack_3.png` |
| 2-1 | sort 1 — dos | `golem_de_pierre_back_cast.png` |
| 2-2 | sort 2 — dos | `golem_de_pierre_back_cast_2.png` |
| 2-3 | marche — dos | `golem_de_pierre_back_walk.png` |

### Loup spectral (Invocateur) — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/summons/` ; nomme tes images `loup_spectral_vues.png`, `loup_spectral_actions.png` et `loup_spectral_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE summoned familiar: Loup spectral — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Loup spectral (a summon)
- Body: spectral violet wolf (#7A4FD8) on four legs with flame-like spiky fur
- Head: glowing white eyes, pointed ears
- Details: fur tips turning into opaque violet flame shapes with dark outlines
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no armor, no transparency, never on two legs.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Loup spectral: spectral violet wolf (#7A4FD8) on four legs with flame-like spiky fur; glowing white eyes, pointed ears; fur tips turning into opaque violet flame shapes with dark outlines. NO weapon and no held object, ever. Forbidden: no armor, no transparency, never on two legs. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `loup_spectral.png` |
| 1-2 | repos de face, variante | `loup_spectral_idle_2.png` |
| 2-1 | repos de dos | `loup_spectral_back.png` |
| 2-2 | repos de dos, variante | `loup_spectral_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE summoned familiar: Loup spectral — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Loup spectral, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Loup spectral (a summon)
- Body: spectral violet wolf (#7A4FD8) on four legs with flame-like spiky fur
- Head: glowing white eyes, pointed ears
- Details: fur tips turning into opaque violet flame shapes with dark outlines
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no armor, no transparency, never on two legs.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Loup spectral: spectral violet wolf (#7A4FD8) on four legs with flame-like spiky fur; glowing white eyes, pointed ears; fur tips turning into opaque violet flame shapes with dark outlines. NO weapon and no held object, ever. Forbidden: no armor, no transparency, never on two legs. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE summoned familiar: Loup spectral — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Loup spectral, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Loup spectral (a summon)
- Body: spectral violet wolf (#7A4FD8) on four legs with flame-like spiky fur
- Head: glowing white eyes, pointed ears
- Details: fur tips turning into opaque violet flame shapes with dark outlines
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no armor, no transparency, never on two legs.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. POUNCE: body stretched forward in the air, jaws open.
3. SIDE SWIPE: head and claws swept to the side, body twisted.
4. HOWL: head raised to the sky, matching magical sparks gathering around the body.
5. ROAR: mouth wide open, matching magical sparks burst in front of the head.
6. WALK: mid-stride, one front paw raised, body moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Loup spectral: spectral violet wolf (#7A4FD8) on four legs with flame-like spiky fur; glowing white eyes, pointed ears; fur tips turning into opaque violet flame shapes with dark outlines. NO weapon and no held object, ever. Forbidden: no armor, no transparency, never on two legs. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `loup_spectral_attack.png` |
| 1-2 | attaque 2 | `loup_spectral_attack_2.png` |
| 1-3 | attaque 3 | `loup_spectral_attack_3.png` |
| 2-1 | sort 1 | `loup_spectral_cast.png` |
| 2-2 | sort 2 | `loup_spectral_cast_2.png` |
| 2-3 | marche | `loup_spectral_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE summoned familiar: Loup spectral — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Loup spectral, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Loup spectral (a summon)
- Body: spectral violet wolf (#7A4FD8) on four legs with flame-like spiky fur
- Head: glowing white eyes, pointed ears
- Details: fur tips turning into opaque violet flame shapes with dark outlines
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no armor, no transparency, never on two legs.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. POUNCE: body stretched forward in the air, jaws open.
3. SIDE SWIPE: head and claws swept to the side, body twisted.
4. HOWL: head raised to the sky, matching magical sparks gathering around the body.
5. ROAR: mouth wide open, matching magical sparks burst in front of the head.
6. WALK: mid-stride, one front paw raised, body moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Loup spectral: spectral violet wolf (#7A4FD8) on four legs with flame-like spiky fur; glowing white eyes, pointed ears; fur tips turning into opaque violet flame shapes with dark outlines. NO weapon and no held object, ever. Forbidden: no armor, no transparency, never on two legs. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `loup_spectral_back_attack.png` |
| 1-2 | attaque 2 — dos | `loup_spectral_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `loup_spectral_back_attack_3.png` |
| 2-1 | sort 1 — dos | `loup_spectral_back_cast.png` |
| 2-2 | sort 2 — dos | `loup_spectral_back_cast_2.png` |
| 2-3 | marche — dos | `loup_spectral_back_walk.png` |

### Requin des marées (Invocateur, ex-Sirène) — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/summons/` ; nomme tes images `requin_des_marees_vues.png`, `requin_des_marees_actions.png` et `requin_des_marees_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE summoned familiar: Requin des marées — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Requin des marées (a summon)
- Body: bright blue shark (#2E8CE0) with a white belly floating upright
- Head: friendly grin, small black eyes
- Details: pectoral fins like small arms
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no weapon.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Requin des marées: bright blue shark (#2E8CE0) with a white belly floating upright; friendly grin, small black eyes; pectoral fins like small arms. NO weapon and no held object, ever. Forbidden: no legs, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `requin_des_marees.png` |
| 1-2 | repos de face, variante | `requin_des_marees_idle_2.png` |
| 2-1 | repos de dos | `requin_des_marees_back.png` |
| 2-2 | repos de dos, variante | `requin_des_marees_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE summoned familiar: Requin des marées — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Requin des marées, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Requin des marées (a summon)
- Body: bright blue shark (#2E8CE0) with a white belly floating upright
- Head: friendly grin, small black eyes
- Details: pectoral fins like small arms
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no weapon.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Requin des marées: bright blue shark (#2E8CE0) with a white belly floating upright; friendly grin, small black eyes; pectoral fins like small arms. NO weapon and no held object, ever. Forbidden: no legs, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE summoned familiar: Requin des marées — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Requin des marées, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Requin des marées (a summon)
- Body: bright blue shark (#2E8CE0) with a white belly floating upright
- Head: friendly grin, small black eyes
- Details: pectoral fins like small arms
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no weapon.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. POUNCE: body stretched forward in the air, jaws open.
3. SIDE SWIPE: head and claws swept to the side, body twisted.
4. HOWL: head raised to the sky, matching magical sparks gathering around the body.
5. ROAR: mouth wide open, matching magical sparks burst in front of the head.
6. WALK: mid-stride, one front paw raised, body moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Requin des marées: bright blue shark (#2E8CE0) with a white belly floating upright; friendly grin, small black eyes; pectoral fins like small arms. NO weapon and no held object, ever. Forbidden: no legs, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `requin_des_marees_attack.png` |
| 1-2 | attaque 2 | `requin_des_marees_attack_2.png` |
| 1-3 | attaque 3 | `requin_des_marees_attack_3.png` |
| 2-1 | sort 1 | `requin_des_marees_cast.png` |
| 2-2 | sort 2 | `requin_des_marees_cast_2.png` |
| 2-3 | marche | `requin_des_marees_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE summoned familiar: Requin des marées — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Requin des marées, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Requin des marées (a summon)
- Body: bright blue shark (#2E8CE0) with a white belly floating upright
- Head: friendly grin, small black eyes
- Details: pectoral fins like small arms
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no weapon.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. POUNCE: body stretched forward in the air, jaws open.
3. SIDE SWIPE: head and claws swept to the side, body twisted.
4. HOWL: head raised to the sky, matching magical sparks gathering around the body.
5. ROAR: mouth wide open, matching magical sparks burst in front of the head.
6. WALK: mid-stride, one front paw raised, body moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Requin des marées: bright blue shark (#2E8CE0) with a white belly floating upright; friendly grin, small black eyes; pectoral fins like small arms. NO weapon and no held object, ever. Forbidden: no legs, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `requin_des_marees_back_attack.png` |
| 1-2 | attaque 2 — dos | `requin_des_marees_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `requin_des_marees_back_attack_3.png` |
| 2-1 | sort 1 — dos | `requin_des_marees_back_cast.png` |
| 2-2 | sort 2 — dos | `requin_des_marees_back_cast_2.png` |
| 2-3 | marche — dos | `requin_des_marees_back_walk.png` |

### Élémentaire de cristal (Invocateur, ex-Ange) — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/summons/` ; nomme tes images `elementaire_de_cristal_vues.png`, `elementaire_de_cristal_actions.png` et `elementaire_de_cristal_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE summoned familiar: Élémentaire de cristal — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Élémentaire de cristal (a summon)
- Body: small floating elemental made of violet (#8A4FD8) and blue (#4F7FE0) crystals, round and cute
- Head: friendly glowing ice-blue eyes (#9FE3FF)
- Details: tiny crystal arms, no legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no sharp menacing look.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Élémentaire de cristal: small floating elemental made of violet (#8A4FD8) and blue (#4F7FE0) crystals, round and cute; friendly glowing ice-blue eyes (#9FE3FF); tiny crystal arms, no legs. NO weapon and no held object, ever. Forbidden: no weapon, no sharp menacing look. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `elementaire_de_cristal.png` |
| 1-2 | repos de face, variante | `elementaire_de_cristal_idle_2.png` |
| 2-1 | repos de dos | `elementaire_de_cristal_back.png` |
| 2-2 | repos de dos, variante | `elementaire_de_cristal_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE summoned familiar: Élémentaire de cristal — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Élémentaire de cristal, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Élémentaire de cristal (a summon)
- Body: small floating elemental made of violet (#8A4FD8) and blue (#4F7FE0) crystals, round and cute
- Head: friendly glowing ice-blue eyes (#9FE3FF)
- Details: tiny crystal arms, no legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no sharp menacing look.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Élémentaire de cristal: small floating elemental made of violet (#8A4FD8) and blue (#4F7FE0) crystals, round and cute; friendly glowing ice-blue eyes (#9FE3FF); tiny crystal arms, no legs. NO weapon and no held object, ever. Forbidden: no weapon, no sharp menacing look. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE summoned familiar: Élémentaire de cristal — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Élémentaire de cristal, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Élémentaire de cristal (a summon)
- Body: small floating elemental made of violet (#8A4FD8) and blue (#4F7FE0) crystals, round and cute
- Head: friendly glowing ice-blue eyes (#9FE3FF)
- Details: tiny crystal arms, no legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no sharp menacing look.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. LUNGE: body stretched forward, claws of matching magical sparks reaching out.
3. SPIN: body whirling, matching magical sparks trail around it.
4. HOVER: floating higher, matching magical sparks orbs circling.
5. PULSE: arms spread, matching magical sparks pulsing outward.
6. DRIFT: floating forward with the body tilted slightly ahead, a short trail behind.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Élémentaire de cristal: small floating elemental made of violet (#8A4FD8) and blue (#4F7FE0) crystals, round and cute; friendly glowing ice-blue eyes (#9FE3FF); tiny crystal arms, no legs. NO weapon and no held object, ever. Forbidden: no weapon, no sharp menacing look. Every sprite faces RIGHT (front or back 3/4), never left.
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
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE summoned familiar: Élémentaire de cristal — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Élémentaire de cristal, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Élémentaire de cristal (a summon)
- Body: small floating elemental made of violet (#8A4FD8) and blue (#4F7FE0) crystals, round and cute
- Head: friendly glowing ice-blue eyes (#9FE3FF)
- Details: tiny crystal arms, no legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no sharp menacing look.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. LUNGE: body stretched forward, claws of matching magical sparks reaching out.
3. SPIN: body whirling, matching magical sparks trail around it.
4. HOVER: floating higher, matching magical sparks orbs circling.
5. PULSE: arms spread, matching magical sparks pulsing outward.
6. DRIFT: floating forward with the body tilted slightly ahead, a short trail behind.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Élémentaire de cristal: small floating elemental made of violet (#8A4FD8) and blue (#4F7FE0) crystals, round and cute; friendly glowing ice-blue eyes (#9FE3FF); tiny crystal arms, no legs. NO weapon and no held object, ever. Forbidden: no weapon, no sharp menacing look. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `elementaire_de_cristal_back_attack.png` |
| 1-2 | attaque 2 — dos | `elementaire_de_cristal_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `elementaire_de_cristal_back_attack_3.png` |
| 2-1 | sort 1 — dos | `elementaire_de_cristal_back_cast.png` |
| 2-2 | sort 2 — dos | `elementaire_de_cristal_back_cast_2.png` |
| 2-3 | marche — dos | `elementaire_de_cristal_back_walk.png` |

### Ombre (Invocateur, ex-Homme-Faucon) — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/summons/` ; nomme tes images `ombre_vues.png`, `ombre_actions.png` et `ombre_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE summoned familiar: Ombre — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombre (a summon)
- Body: coiled purple shadow serpent (#4A2A7A) with darker stripes
- Head: dragon-like head with small horns and glowing violet eyes (#B070FF)
- Details: stylized opaque smoke curls with dark outlines along the body
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no wings, no transparency.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Ombre: coiled purple shadow serpent (#4A2A7A) with darker stripes; dragon-like head with small horns and glowing violet eyes (#B070FF); stylized opaque smoke curls with dark outlines along the body. NO weapon and no held object, ever. Forbidden: no legs, no wings, no transparency. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `ombre.png` |
| 1-2 | repos de face, variante | `ombre_idle_2.png` |
| 2-1 | repos de dos | `ombre_back.png` |
| 2-2 | repos de dos, variante | `ombre_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE summoned familiar: Ombre — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Ombre, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombre (a summon)
- Body: coiled purple shadow serpent (#4A2A7A) with darker stripes
- Head: dragon-like head with small horns and glowing violet eyes (#B070FF)
- Details: stylized opaque smoke curls with dark outlines along the body
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no wings, no transparency.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Ombre: coiled purple shadow serpent (#4A2A7A) with darker stripes; dragon-like head with small horns and glowing violet eyes (#B070FF); stylized opaque smoke curls with dark outlines along the body. NO weapon and no held object, ever. Forbidden: no legs, no wings, no transparency. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE summoned familiar: Ombre — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Ombre, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombre (a summon)
- Body: coiled purple shadow serpent (#4A2A7A) with darker stripes
- Head: dragon-like head with small horns and glowing violet eyes (#B070FF)
- Details: stylized opaque smoke curls with dark outlines along the body
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no wings, no transparency.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. LUNGE: body stretched forward, claws of matching magical sparks reaching out.
3. SPIN: body whirling, matching magical sparks trail around it.
4. HOVER: floating higher, matching magical sparks orbs circling.
5. PULSE: arms spread, matching magical sparks pulsing outward.
6. DRIFT: floating forward with the body tilted slightly ahead, a short trail behind.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Ombre: coiled purple shadow serpent (#4A2A7A) with darker stripes; dragon-like head with small horns and glowing violet eyes (#B070FF); stylized opaque smoke curls with dark outlines along the body. NO weapon and no held object, ever. Forbidden: no legs, no wings, no transparency. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `ombre_attack.png` |
| 1-2 | attaque 2 | `ombre_attack_2.png` |
| 1-3 | attaque 3 | `ombre_attack_3.png` |
| 2-1 | sort 1 | `ombre_cast.png` |
| 2-2 | sort 2 | `ombre_cast_2.png` |
| 2-3 | marche | `ombre_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE summoned familiar: Ombre — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Ombre, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombre (a summon)
- Body: coiled purple shadow serpent (#4A2A7A) with darker stripes
- Head: dragon-like head with small horns and glowing violet eyes (#B070FF)
- Details: stylized opaque smoke curls with dark outlines along the body
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no wings, no transparency.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. LUNGE: body stretched forward, claws of matching magical sparks reaching out.
3. SPIN: body whirling, matching magical sparks trail around it.
4. HOVER: floating higher, matching magical sparks orbs circling.
5. PULSE: arms spread, matching magical sparks pulsing outward.
6. DRIFT: floating forward with the body tilted slightly ahead, a short trail behind.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Ombre: coiled purple shadow serpent (#4A2A7A) with darker stripes; dragon-like head with small horns and glowing violet eyes (#B070FF); stylized opaque smoke curls with dark outlines along the body. NO weapon and no held object, ever. Forbidden: no legs, no wings, no transparency. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `ombre_back_attack.png` |
| 1-2 | attaque 2 — dos | `ombre_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `ombre_back_attack_3.png` |
| 2-1 | sort 1 — dos | `ombre_back_cast.png` |
| 2-2 | sort 2 — dos | `ombre_back_cast_2.png` |
| 2-3 | marche — dos | `ombre_back_walk.png` |

### Esprit de la forêt (Invocateur, ex-Centaure) — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/summons/` ; nomme tes images `esprit_de_la_foret_vues.png`, `esprit_de_la_foret_actions.png` et `esprit_de_la_foret_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE summoned familiar: Esprit de la forêt — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Esprit de la forêt (a summon)
- Body: forest stag spirit on four legs, body of green leaves (#5FAE48) and moss
- Head: large branching wooden antlers with small leaves, glowing green eyes
- Details: small white flowers on the back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no rider, no armor, never on two legs.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Esprit de la forêt: forest stag spirit on four legs, body of green leaves (#5FAE48) and moss; large branching wooden antlers with small leaves, glowing green eyes; small white flowers on the back. NO weapon and no held object, ever. Forbidden: no rider, no armor, never on two legs. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `esprit_de_la_foret.png` |
| 1-2 | repos de face, variante | `esprit_de_la_foret_idle_2.png` |
| 2-1 | repos de dos | `esprit_de_la_foret_back.png` |
| 2-2 | repos de dos, variante | `esprit_de_la_foret_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE summoned familiar: Esprit de la forêt — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Esprit de la forêt, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Esprit de la forêt (a summon)
- Body: forest stag spirit on four legs, body of green leaves (#5FAE48) and moss
- Head: large branching wooden antlers with small leaves, glowing green eyes
- Details: small white flowers on the back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no rider, no armor, never on two legs.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Esprit de la forêt: forest stag spirit on four legs, body of green leaves (#5FAE48) and moss; large branching wooden antlers with small leaves, glowing green eyes; small white flowers on the back. NO weapon and no held object, ever. Forbidden: no rider, no armor, never on two legs. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE summoned familiar: Esprit de la forêt — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Esprit de la forêt, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Esprit de la forêt (a summon)
- Body: forest stag spirit on four legs, body of green leaves (#5FAE48) and moss
- Head: large branching wooden antlers with small leaves, glowing green eyes
- Details: small white flowers on the back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no rider, no armor, never on two legs.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. POUNCE: body stretched forward in the air, jaws open.
3. SIDE SWIPE: head and claws swept to the side, body twisted.
4. HOWL: head raised to the sky, matching magical sparks gathering around the body.
5. ROAR: mouth wide open, matching magical sparks burst in front of the head.
6. WALK: mid-stride, one front paw raised, body moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Esprit de la forêt: forest stag spirit on four legs, body of green leaves (#5FAE48) and moss; large branching wooden antlers with small leaves, glowing green eyes; small white flowers on the back. NO weapon and no held object, ever. Forbidden: no rider, no armor, never on two legs. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `esprit_de_la_foret_attack.png` |
| 1-2 | attaque 2 | `esprit_de_la_foret_attack_2.png` |
| 1-3 | attaque 3 | `esprit_de_la_foret_attack_3.png` |
| 2-1 | sort 1 | `esprit_de_la_foret_cast.png` |
| 2-2 | sort 2 | `esprit_de_la_foret_cast_2.png` |
| 2-3 | marche | `esprit_de_la_foret_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE summoned familiar: Esprit de la forêt — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Esprit de la forêt, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Esprit de la forêt (a summon)
- Body: forest stag spirit on four legs, body of green leaves (#5FAE48) and moss
- Head: large branching wooden antlers with small leaves, glowing green eyes
- Details: small white flowers on the back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no rider, no armor, never on two legs.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. POUNCE: body stretched forward in the air, jaws open.
3. SIDE SWIPE: head and claws swept to the side, body twisted.
4. HOWL: head raised to the sky, matching magical sparks gathering around the body.
5. ROAR: mouth wide open, matching magical sparks burst in front of the head.
6. WALK: mid-stride, one front paw raised, body moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Esprit de la forêt: forest stag spirit on four legs, body of green leaves (#5FAE48) and moss; large branching wooden antlers with small leaves, glowing green eyes; small white flowers on the back. NO weapon and no held object, ever. Forbidden: no rider, no armor, never on two legs. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `esprit_de_la_foret_back_attack.png` |
| 1-2 | attaque 2 — dos | `esprit_de_la_foret_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `esprit_de_la_foret_back_attack_3.png` |
| 2-1 | sort 1 — dos | `esprit_de_la_foret_back_cast.png` |
| 2-2 | sort 2 — dos | `esprit_de_la_foret_back_cast_2.png` |
| 2-3 | marche — dos | `esprit_de_la_foret_back_walk.png` |

### Archer sylvestre (Sylvain) — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/summons/` ; nomme tes images `archer_sylvestre_vues.png`, `archer_sylvestre_actions.png` et `archer_sylvestre_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE summoned familiar: Archer sylvestre, armed with: wooden bow in the LEFT hand, leaf quiver on the back.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Archer sylvestre (a summon)
- Body: slim wooden archer made of light-brown branches (#8A6238) and green leaves
- Head: leafy crown, two glowing green eyes, no mouth
- Weapon: wooden bow in the LEFT hand, leaf quiver on the back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human skin, no metal.
WEAPON: wooden bow in the LEFT hand, leaf quiver on the back. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: wooden bow in the LEFT hand, leaf quiver on the back. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Archer sylvestre: wooden bow in the LEFT hand, leaf quiver on the back; slim wooden archer made of light-brown branches (#8A6238) and green leaves; leafy crown, two glowing green eyes, no mouth. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no human skin, no metal. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `archer_sylvestre.png` |
| 1-2 | repos de face, variante | `archer_sylvestre_idle_2.png` |
| 2-1 | repos de dos | `archer_sylvestre_back.png` |
| 2-2 | repos de dos, variante | `archer_sylvestre_back_idle_2.png` |

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE summoned familiar: Archer sylvestre, armed with: wooden bow in the LEFT hand, leaf quiver on the back.
SOURCE IMAGE: it shows this summoned familiar, Archer sylvestre, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Archer sylvestre (a summon)
- Body: slim wooden archer made of light-brown branches (#8A6238) and green leaves
- Head: leafy crown, two glowing green eyes, no mouth
- Weapon: wooden bow in the LEFT hand, leaf quiver on the back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human skin, no metal.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
WEAPON: wooden bow in the LEFT hand, leaf quiver on the back. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Archer sylvestre: wooden bow in the LEFT hand, leaf quiver on the back; slim wooden archer made of light-brown branches (#8A6238) and green leaves; leafy crown, two glowing green eyes, no mouth. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no human skin, no metal. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE summoned familiar: Archer sylvestre, armed with: wooden bow in the LEFT hand, leaf quiver on the back.
SOURCE IMAGE: it shows this summoned familiar, Archer sylvestre, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Archer sylvestre (a summon)
- Body: slim wooden archer made of light-brown branches (#8A6238) and green leaves
- Head: leafy crown, two glowing green eyes, no mouth
- Weapon: wooden bow in the LEFT hand, leaf quiver on the back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human skin, no metal.
WEAPON: wooden bow in the LEFT hand, leaf quiver on the back. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. SKY SHOT: bow pointed almost straight up, string fully drawn.
2. FULL DRAW: bow aimed straight forward, string pulled to the cheek, body sideways.
3. RELEASE: string hand open behind, bow arm extended, arrow leaving with a matching magical sparks trail.
4. ENCHANTED ARROW: arrow held up to the face, its tip wrapped in matching magical sparks.
5. VOLLEY: bow raised overhead, three matching magical sparks arrows rising into the air.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: wooden bow in the LEFT hand, leaf quiver on the back — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Archer sylvestre: wooden bow in the LEFT hand, leaf quiver on the back; slim wooden archer made of light-brown branches (#8A6238) and green leaves; leafy crown, two glowing green eyes, no mouth. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no human skin, no metal. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `archer_sylvestre_attack.png` |
| 1-2 | attaque 2 | `archer_sylvestre_attack_2.png` |
| 1-3 | attaque 3 | `archer_sylvestre_attack_3.png` |
| 2-1 | sort 1 | `archer_sylvestre_cast.png` |
| 2-2 | sort 2 | `archer_sylvestre_cast_2.png` |
| 2-3 | marche | `archer_sylvestre_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE summoned familiar: Archer sylvestre, armed with: wooden bow in the LEFT hand, leaf quiver on the back.
SOURCE IMAGE: it shows this summoned familiar, Archer sylvestre, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Archer sylvestre (a summon)
- Body: slim wooden archer made of light-brown branches (#8A6238) and green leaves
- Head: leafy crown, two glowing green eyes, no mouth
- Weapon: wooden bow in the LEFT hand, leaf quiver on the back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human skin, no metal.
WEAPON: wooden bow in the LEFT hand, leaf quiver on the back. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. SKY SHOT: bow pointed almost straight up, string fully drawn.
2. FULL DRAW: bow aimed straight forward, string pulled to the cheek, body sideways.
3. RELEASE: string hand open behind, bow arm extended, arrow leaving with a matching magical sparks trail.
4. ENCHANTED ARROW: arrow held up to the face, its tip wrapped in matching magical sparks.
5. VOLLEY: bow raised overhead, three matching magical sparks arrows rising into the air.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: wooden bow in the LEFT hand, leaf quiver on the back — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Archer sylvestre: wooden bow in the LEFT hand, leaf quiver on the back; slim wooden archer made of light-brown branches (#8A6238) and green leaves; leafy crown, two glowing green eyes, no mouth. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no human skin, no metal. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `archer_sylvestre_back_attack.png` |
| 1-2 | attaque 2 — dos | `archer_sylvestre_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `archer_sylvestre_back_attack_3.png` |
| 2-1 | sort 1 — dos | `archer_sylvestre_back_cast.png` |
| 2-2 | sort 2 — dos | `archer_sylvestre_back_cast_2.png` |
| 2-3 | marche — dos | `archer_sylvestre_back_walk.png` |

### Ent de combat (Sylvain) — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/summons/` ; nomme tes images `ent_de_combat_vues.png`, `ent_de_combat_actions.png` et `ent_de_combat_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE summoned familiar: Ent de combat — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ent de combat (a summon)
- Body: small wooden ent warrior of brown bark (#6B4A2B) covered in green leaves
- Head: face carved in the bark with glowing green eyes, leafy top
- Details: stubby branch arms, root feet
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no metal.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Ent de combat: small wooden ent warrior of brown bark (#6B4A2B) covered in green leaves; face carved in the bark with glowing green eyes, leafy top; stubby branch arms, root feet. NO weapon and no held object, ever. Forbidden: no weapon, no metal. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `ent_de_combat.png` |
| 1-2 | repos de face, variante | `ent_de_combat_idle_2.png` |
| 2-1 | repos de dos | `ent_de_combat_back.png` |
| 2-2 | repos de dos, variante | `ent_de_combat_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE summoned familiar: Ent de combat — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Ent de combat, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ent de combat (a summon)
- Body: small wooden ent warrior of brown bark (#6B4A2B) covered in green leaves
- Head: face carved in the bark with glowing green eyes, leafy top
- Details: stubby branch arms, root feet
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no metal.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Ent de combat: small wooden ent warrior of brown bark (#6B4A2B) covered in green leaves; face carved in the bark with glowing green eyes, leafy top; stubby branch arms, root feet. NO weapon and no held object, ever. Forbidden: no weapon, no metal. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE summoned familiar: Ent de combat — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Ent de combat, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ent de combat (a summon)
- Body: small wooden ent warrior of brown bark (#6B4A2B) covered in green leaves
- Head: face carved in the bark with glowing green eyes, leafy top
- Details: stubby branch arms, root feet
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no metal.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted.
4. ROOTED: stomping, matching magical sparks cracks spreading under the feet.
5. GATHER: arms raised, matching magical sparks gathering between the hands.
6. WALK: heavy mid-stride, one foot raised, arms swinging.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Ent de combat: small wooden ent warrior of brown bark (#6B4A2B) covered in green leaves; face carved in the bark with glowing green eyes, leafy top; stubby branch arms, root feet. NO weapon and no held object, ever. Forbidden: no weapon, no metal. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `ent_de_combat_attack.png` |
| 1-2 | attaque 2 | `ent_de_combat_attack_2.png` |
| 1-3 | attaque 3 | `ent_de_combat_attack_3.png` |
| 2-1 | sort 1 | `ent_de_combat_cast.png` |
| 2-2 | sort 2 | `ent_de_combat_cast_2.png` |
| 2-3 | marche | `ent_de_combat_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE summoned familiar: Ent de combat — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Ent de combat, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ent de combat (a summon)
- Body: small wooden ent warrior of brown bark (#6B4A2B) covered in green leaves
- Head: face carved in the bark with glowing green eyes, leafy top
- Details: stubby branch arms, root feet
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no metal.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted.
4. ROOTED: stomping, matching magical sparks cracks spreading under the feet.
5. GATHER: arms raised, matching magical sparks gathering between the hands.
6. WALK: heavy mid-stride, one foot raised, arms swinging.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Ent de combat: small wooden ent warrior of brown bark (#6B4A2B) covered in green leaves; face carved in the bark with glowing green eyes, leafy top; stubby branch arms, root feet. NO weapon and no held object, ever. Forbidden: no weapon, no metal. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `ent_de_combat_back_attack.png` |
| 1-2 | attaque 2 — dos | `ent_de_combat_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `ent_de_combat_back_attack_3.png` |
| 2-1 | sort 1 — dos | `ent_de_combat_back_cast.png` |
| 2-2 | sort 2 — dos | `ent_de_combat_back_cast_2.png` |
| 2-3 | marche — dos | `ent_de_combat_back_walk.png` |

### Tronc (Sylvain) — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/summons/` ; nomme tes images `tronc_vues.png`, `tronc_actions.png` et `tronc_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE summoned familiar: Tronc — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tronc (a summon)
- Body: cute walking tree stump of brown bark (#7A5534)
- Head: round leafy green crown on top (#5FAE48), big round friendly eyes on the trunk
- Details: two small branch arms, little root feet
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no angry face.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Tronc: cute walking tree stump of brown bark (#7A5534); round leafy green crown on top (#5FAE48), big round friendly eyes on the trunk; two small branch arms, little root feet. NO weapon and no held object, ever. Forbidden: no weapon, no angry face. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `tronc.png` |
| 1-2 | repos de face, variante | `tronc_idle_2.png` |
| 2-1 | repos de dos | `tronc_back.png` |
| 2-2 | repos de dos, variante | `tronc_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE summoned familiar: Tronc — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Tronc, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tronc (a summon)
- Body: cute walking tree stump of brown bark (#7A5534)
- Head: round leafy green crown on top (#5FAE48), big round friendly eyes on the trunk
- Details: two small branch arms, little root feet
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no angry face.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Tronc: cute walking tree stump of brown bark (#7A5534); round leafy green crown on top (#5FAE48), big round friendly eyes on the trunk; two small branch arms, little root feet. NO weapon and no held object, ever. Forbidden: no weapon, no angry face. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE summoned familiar: Tronc — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Tronc, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tronc (a summon)
- Body: cute walking tree stump of brown bark (#7A5534)
- Head: round leafy green crown on top (#5FAE48), big round friendly eyes on the trunk
- Details: two small branch arms, little root feet
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no angry face.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted.
4. ROOTED: stomping, matching magical sparks cracks spreading under the feet.
5. GATHER: arms raised, matching magical sparks gathering between the hands.
6. WALK: heavy mid-stride, one foot raised, arms swinging.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tronc: cute walking tree stump of brown bark (#7A5534); round leafy green crown on top (#5FAE48), big round friendly eyes on the trunk; two small branch arms, little root feet. NO weapon and no held object, ever. Forbidden: no weapon, no angry face. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `tronc_attack.png` |
| 1-2 | attaque 2 | `tronc_attack_2.png` |
| 1-3 | attaque 3 | `tronc_attack_3.png` |
| 2-1 | sort 1 | `tronc_cast.png` |
| 2-2 | sort 2 | `tronc_cast_2.png` |
| 2-3 | marche | `tronc_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE summoned familiar: Tronc — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Tronc, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tronc (a summon)
- Body: cute walking tree stump of brown bark (#7A5534)
- Head: round leafy green crown on top (#5FAE48), big round friendly eyes on the trunk
- Details: two small branch arms, little root feet
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no angry face.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted.
4. ROOTED: stomping, matching magical sparks cracks spreading under the feet.
5. GATHER: arms raised, matching magical sparks gathering between the hands.
6. WALK: heavy mid-stride, one foot raised, arms swinging.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tronc: cute walking tree stump of brown bark (#7A5534); round leafy green crown on top (#5FAE48), big round friendly eyes on the trunk; two small branch arms, little root feet. NO weapon and no held object, ever. Forbidden: no weapon, no angry face. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `tronc_back_attack.png` |
| 1-2 | attaque 2 — dos | `tronc_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `tronc_back_attack_3.png` |
| 2-1 | sort 1 — dos | `tronc_back_cast.png` |
| 2-2 | sort 2 — dos | `tronc_back_cast_2.png` |
| 2-3 | marche — dos | `tronc_back_walk.png` |

### Sarriette (Sylvain) — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/summons/` ; nomme tes images `sarriette_vues.png`, `sarriette_actions.png` et `sarriette_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE summoned familiar: Sarriette — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sarriette (a summon)
- Body: tiny leaf sprite girl with light green skin (#BFE8A8)
- Head: green leaf hood (#5FAE48) with two little horns, big dark eyes
- Details: a curly vine in the hand, leaf dress
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no weapon.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Sarriette: tiny leaf sprite girl with light green skin (#BFE8A8); green leaf hood (#5FAE48) with two little horns, big dark eyes; a curly vine in the hand, leaf dress. NO weapon and no held object, ever. Forbidden: no wings, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `sarriette.png` |
| 1-2 | repos de face, variante | `sarriette_idle_2.png` |
| 2-1 | repos de dos | `sarriette_back.png` |
| 2-2 | repos de dos, variante | `sarriette_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE summoned familiar: Sarriette — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Sarriette, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sarriette (a summon)
- Body: tiny leaf sprite girl with light green skin (#BFE8A8)
- Head: green leaf hood (#5FAE48) with two little horns, big dark eyes
- Details: a curly vine in the hand, leaf dress
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no weapon.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Sarriette: tiny leaf sprite girl with light green skin (#BFE8A8); green leaf hood (#5FAE48) with two little horns, big dark eyes; a curly vine in the hand, leaf dress. NO weapon and no held object, ever. Forbidden: no wings, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE summoned familiar: Sarriette — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Sarriette, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sarriette (a summon)
- Body: tiny leaf sprite girl with light green skin (#BFE8A8)
- Head: green leaf hood (#5FAE48) with two little horns, big dark eyes
- Details: a curly vine in the hand, leaf dress
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no weapon.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short matching magical sparks spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. FOCUS: eyes closed, staff held vertically in front of the face, matching magical sparks orb at the top.
5. INVOCATION: staff raised high with both hands, matching magical sparks swirling above the head.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Sarriette: tiny leaf sprite girl with light green skin (#BFE8A8); green leaf hood (#5FAE48) with two little horns, big dark eyes; a curly vine in the hand, leaf dress. NO weapon and no held object, ever. Forbidden: no wings, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `sarriette_attack.png` |
| 1-2 | attaque 2 | `sarriette_attack_2.png` |
| 1-3 | attaque 3 | `sarriette_attack_3.png` |
| 2-1 | sort 1 | `sarriette_cast.png` |
| 2-2 | sort 2 | `sarriette_cast_2.png` |
| 2-3 | marche | `sarriette_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE summoned familiar: Sarriette — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Sarriette, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sarriette (a summon)
- Body: tiny leaf sprite girl with light green skin (#BFE8A8)
- Head: green leaf hood (#5FAE48) with two little horns, big dark eyes
- Details: a curly vine in the hand, leaf dress
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no weapon.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short matching magical sparks spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. FOCUS: eyes closed, staff held vertically in front of the face, matching magical sparks orb at the top.
5. INVOCATION: staff raised high with both hands, matching magical sparks swirling above the head.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Sarriette: tiny leaf sprite girl with light green skin (#BFE8A8); green leaf hood (#5FAE48) with two little horns, big dark eyes; a curly vine in the hand, leaf dress. NO weapon and no held object, ever. Forbidden: no wings, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `sarriette_back_attack.png` |
| 1-2 | attaque 2 — dos | `sarriette_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `sarriette_back_attack_3.png` |
| 2-1 | sort 1 — dos | `sarriette_back_cast.png` |
| 2-2 | sort 2 — dos | `sarriette_back_cast_2.png` |
| 2-3 | marche — dos | `sarriette_back_walk.png` |

### Ronce agressive (Sylvain) — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/summons/` ; nomme tes images `ronce_agressive_vues.png`, `ronce_agressive_actions.png` et `ronce_agressive_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE summoned familiar: Ronce agressive — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ronce agressive (a summon)
- Body: angry dark-green bramble bulb (#3E6A2E) covered in sharp thorns
- Head: two angry red eyes (#E02A2A), jagged mouth
- Details: whipping thorny vines around it, rooted in the ground
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no flowers.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Ronce agressive: angry dark-green bramble bulb (#3E6A2E) covered in sharp thorns; two angry red eyes (#E02A2A), jagged mouth; whipping thorny vines around it, rooted in the ground. NO weapon and no held object, ever. Forbidden: no legs, no flowers. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `ronce_agressive.png` |
| 1-2 | repos de face, variante | `ronce_agressive_idle_2.png` |
| 2-1 | repos de dos | `ronce_agressive_back.png` |
| 2-2 | repos de dos, variante | `ronce_agressive_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE summoned familiar: Ronce agressive — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Ronce agressive, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ronce agressive (a summon)
- Body: angry dark-green bramble bulb (#3E6A2E) covered in sharp thorns
- Head: two angry red eyes (#E02A2A), jagged mouth
- Details: whipping thorny vines around it, rooted in the ground
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no flowers.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Ronce agressive: angry dark-green bramble bulb (#3E6A2E) covered in sharp thorns; two angry red eyes (#E02A2A), jagged mouth; whipping thorny vines around it, rooted in the ground. NO weapon and no held object, ever. Forbidden: no legs, no flowers. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE summoned familiar: Ronce agressive — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Ronce agressive, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ronce agressive (a summon)
- Body: angry dark-green bramble bulb (#3E6A2E) covered in sharp thorns
- Head: two angry red eyes (#E02A2A), jagged mouth
- Details: whipping thorny vines around it, rooted in the ground
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no flowers.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. LUNGE: body stretched forward, claws of matching magical sparks reaching out.
3. SPIN: body whirling, matching magical sparks trail around it.
4. HOVER: floating higher, matching magical sparks orbs circling.
5. PULSE: arms spread, matching magical sparks pulsing outward.
6. DRIFT: floating forward with the body tilted slightly ahead, a short trail behind.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Ronce agressive: angry dark-green bramble bulb (#3E6A2E) covered in sharp thorns; two angry red eyes (#E02A2A), jagged mouth; whipping thorny vines around it, rooted in the ground. NO weapon and no held object, ever. Forbidden: no legs, no flowers. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `ronce_agressive_attack.png` |
| 1-2 | attaque 2 | `ronce_agressive_attack_2.png` |
| 1-3 | attaque 3 | `ronce_agressive_attack_3.png` |
| 2-1 | sort 1 | `ronce_agressive_cast.png` |
| 2-2 | sort 2 | `ronce_agressive_cast_2.png` |
| 2-3 | marche | `ronce_agressive_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE summoned familiar: Ronce agressive — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this summoned familiar, Ronce agressive, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ronce agressive (a summon)
- Body: angry dark-green bramble bulb (#3E6A2E) covered in sharp thorns
- Head: two angry red eyes (#E02A2A), jagged mouth
- Details: whipping thorny vines around it, rooted in the ground
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no flowers.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. LUNGE: body stretched forward, claws of matching magical sparks reaching out.
3. SPIN: body whirling, matching magical sparks trail around it.
4. HOVER: floating higher, matching magical sparks orbs circling.
5. PULSE: arms spread, matching magical sparks pulsing outward.
6. DRIFT: floating forward with the body tilted slightly ahead, a short trail behind.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Ronce agressive: angry dark-green bramble bulb (#3E6A2E) covered in sharp thorns; two angry red eyes (#E02A2A), jagged mouth; whipping thorny vines around it, rooted in the ground. NO weapon and no held object, ever. Forbidden: no legs, no flowers. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `ronce_agressive_back_attack.png` |
| 1-2 | attaque 2 — dos | `ronce_agressive_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `ronce_agressive_back_attack_3.png` |
| 2-1 | sort 1 — dos | `ronce_agressive_back_cast.png` |
| 2-2 | sort 2 — dos | `ronce_agressive_back_cast_2.png` |
| 2-3 | marche — dos | `ronce_agressive_back_walk.png` |

### Sentinelle de grès (pas encore utilisée) — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/summons/` ; nomme tes images `sentinelle_de_gres_vues.png`, `sentinelle_de_gres_actions.png` et `sentinelle_de_gres_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE summoned familiar: Sentinelle de grès, armed with: carved stone spear, RIGHT hand.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sentinelle de grès (a summon)
- Body: sandstone sentinel statue (#D9B07A) with carved armor
- Head: carved helmet-head with glowing amber eyes (#F2A93B)
- Weapon: carved stone spear, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no cloth, no skin.
WEAPON: carved stone spear, RIGHT hand. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: carved stone spear, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Sentinelle de grès: carved stone spear, RIGHT hand; sandstone sentinel statue (#D9B07A) with carved armor; carved helmet-head with glowing amber eyes (#F2A93B). The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no cloth, no skin. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `sentinelle_de_gres.png` |
| 1-2 | repos de face, variante | `sentinelle_de_gres_idle_2.png` |
| 2-1 | repos de dos | `sentinelle_de_gres_back.png` |
| 2-2 | repos de dos, variante | `sentinelle_de_gres_back_idle_2.png` |

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE summoned familiar: Sentinelle de grès, armed with: carved stone spear, RIGHT hand.
SOURCE IMAGE: it shows this summoned familiar, Sentinelle de grès, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sentinelle de grès (a summon)
- Body: sandstone sentinel statue (#D9B07A) with carved armor
- Head: carved helmet-head with glowing amber eyes (#F2A93B)
- Weapon: carved stone spear, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no cloth, no skin.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly tilted, free hand or weapon moved a little — it must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT relaxed stance — weight on the other leg, head slightly turned, free hand or weapon moved a little — it must not be a copy of cell 3; no face, no eyes.
WEAPON: carved stone spear, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Sentinelle de grès: carved stone spear, RIGHT hand; sandstone sentinel statue (#D9B07A) with carved armor; carved helmet-head with glowing amber eyes (#F2A93B). The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no cloth, no skin. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE summoned familiar: Sentinelle de grès, armed with: carved stone spear, RIGHT hand.
SOURCE IMAGE: it shows this summoned familiar, Sentinelle de grès, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sentinelle de grès (a summon)
- Body: sandstone sentinel statue (#D9B07A) with carved armor
- Head: carved helmet-head with glowing amber eyes (#F2A93B)
- Weapon: carved stone spear, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no cloth, no skin.
WEAPON: carved stone spear, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted.
4. ROOTED: stomping, matching magical sparks cracks spreading under the feet.
5. GATHER: arms raised, matching magical sparks gathering between the hands.
6. WALK: heavy mid-stride, one foot raised, arms swinging.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: carved stone spear, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Sentinelle de grès: carved stone spear, RIGHT hand; sandstone sentinel statue (#D9B07A) with carved armor; carved helmet-head with glowing amber eyes (#F2A93B). The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no cloth, no skin. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `sentinelle_de_gres_attack.png` |
| 1-2 | attaque 2 | `sentinelle_de_gres_attack_2.png` |
| 1-3 | attaque 3 | `sentinelle_de_gres_attack_3.png` |
| 2-1 | sort 1 | `sentinelle_de_gres_cast.png` |
| 2-2 | sort 2 | `sentinelle_de_gres_cast_2.png` |
| 2-3 | marche | `sentinelle_de_gres_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE summoned familiar: Sentinelle de grès, armed with: carved stone spear, RIGHT hand.
SOURCE IMAGE: it shows this summoned familiar, Sentinelle de grès, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sentinelle de grès (a summon)
- Body: sandstone sentinel statue (#D9B07A) with carved armor
- Head: carved helmet-head with glowing amber eyes (#F2A93B)
- Weapon: carved stone spear, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no cloth, no skin.
WEAPON: carved stone spear, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: colors as described.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted.
4. ROOTED: stomping, matching magical sparks cracks spreading under the feet.
5. GATHER: arms raised, matching magical sparks gathering between the hands.
6. WALK: heavy mid-stride, one foot raised, arms swinging.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: carved stone spear, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Sentinelle de grès: carved stone spear, RIGHT hand; sandstone sentinel statue (#D9B07A) with carved armor; carved helmet-head with glowing amber eyes (#F2A93B). The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no cloth, no skin. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `sentinelle_de_gres_back_attack.png` |
| 1-2 | attaque 2 — dos | `sentinelle_de_gres_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `sentinelle_de_gres_back_attack_3.png` |
| 2-1 | sort 1 — dos | `sentinelle_de_gres_back_cast.png` |
| 2-2 | sort 2 — dos | `sentinelle_de_gres_back_cast_2.png` |
| 2-3 | marche — dos | `sentinelle_de_gres_back_walk.png` |

## Prompt négatif

Familiers sans arme — planches vues :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, extra objects, different character between poses, realistic proportions, small head, more than 4 sprites, extra sprites, duplicated row of sprites, one sprite bigger or smaller than the others, size changing between cells, weapon, torch, staff, sword, bow, held object, tool, item in the hands or claws
```

Familiers sans arme — planches actions :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, extra objects, different character between poses, realistic proportions, small head, weapon, torch, staff, sword, bow, held object, tool, item in the hands or claws
```

Familiers armés (Archer sylvestre, Sarriette) : négatifs des fichiers nation.
