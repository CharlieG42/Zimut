# Nation Brumes (Brumes)

Palette : black, deep violet, mist mint green, silver. Effets : mint mist and violet spectral wisps. Contre-jour : pale mint.

Format 2 planches par personnage :

1. **Vues** — le personnage au repos vu sous 4 angles en quarts de tour (3/4 avant droite, 3/4 dos droite, 3/4 dos gauche, 3/4 avant gauche) : la caméra ne bouge pas, le personnage tourne sur lui-même. 2 vues plutôt de face, 2 plutôt de dos ; un seul angle par case, aucun doublon possible. Grille 2 × 2 sur image 2:1, poses largement espacées.
2. **Actions** — 2 attaques + 1 sort, chacune vue DE FACE puis DE DOS (3 colonnes × 2 rangées), générées **en édition** de la planche vues (image source = planche vues) : le personnage réellement dessiné sert d'ancre, il ne peut pas changer d'une planche à l'autre. L'arme est verrouillée d'une planche à l'autre (ligne WEAPON LOCK + rappel final). Repli : génération normale (la carte d'identité est recopiée dans chaque prompt).

Chaque prompt recopie la carte d'identité du personnage (`identites.py`) : aucune image à joindre. Ordre conseillé : 1) planche de style, 2) héros, 3) ennemis, 4) boss ; pour chaque personnage : vues puis actions. Prompt négatif : en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Brumes nation (Brumes biome).
NATION PALETTE: black, deep violet, mist mint green, silver. Signature effects: mint mist and violet spectral wisps.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: two rows with the same 6 characters in the same order, all in idle pose. Top row: 3/4 front view, facing front-right. Bottom row: 3/4 back view, seen from behind, turned toward the upper right. All feet of a row on the same ground line. Leave a wide empty gap (at least half a character width) between characters and between the two rows: nobody overlaps or touches anyone, weapons and capes included. Image aspect ratio 2:1, as large as possible.
CHARACTERS, left to right:
1. the hero (Invocateur: summoner with black hair, long black coat with violet trims and silver clasps, a spiked dark staff topped with a violet crystal in the right hand, a grimoire floating at his side).
2. Brumeux (hulking lavender mist beast with a fluffy cloud body and small glowing eyes).
3. Gargouille (grey stone gargoyle with bat wings and a long tail).
4. Liche des brumes (thin violet lich in tattered robes holding a crooked staff).
5. Fantôme (pale blue ghost with a wavy tail and a mischievous face).
6. the final boss Ombrelis le Brumeux (dark necromancer in black spiked armor with a violet tattered cloak, spiked crown, holding a skull-topped staff surrounded by mist), about 1.5x taller than the others.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Invocateur — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `invocateur_vues.png` et `invocateur_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held in hand in every cell, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Invocateur (hero of the Brumes nation)
- Hair: black hair (#15151C), medium length, messy bangs
- Eyes: violet eyes (#9B6BFF), always open
- Skin: pale skin
- Top: long black coat with violet trims (#7A3FD0) and silver clasps
- Bottom: black trousers
- Feet: black boots with silver buckles
- Weapon: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no mask, no white hair.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side — the character visibly HOLDS it in every cell; hands are never empty.
REMINDER: this is Invocateur: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side; black hair (#15151C), medium length, messy bangs; violet eyes (#9B6BFF), always open; long black coat with violet trims (#7A3FD0) and silver clasps; pale skin; black trousers; black boots with silver buckles. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no mask, no white hair.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `invocateur.png` |
| 1-2 | 3/4 dos droite | `invocateur_back.png` |
| 2-1 | 3/4 dos gauche | `invocateur_back_left.png` |
| 2-2 | 3/4 avant gauche | `invocateur_face_left.png` |

##### Édition corrective (arme manquante sur des cases)

Si l'arme manque sur certaines cases de la planche générée : édition avec la planche `vues` en image source. Ce prompt RÉPÈTE la liste des angles — une édition corrective qui ne la répète pas aplatit toutes les vues dans le même angle.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE playable hero, Invocateur, several times, in the SAME relaxed idle pose seen from DIFFERENT viewing angles (successive quarter turns of the character, the camera fixed).
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Invocateur (hero of the Brumes nation)
- Hair: black hair (#15151C), medium length, messy bangs
- Eyes: violet eyes (#9B6BFF), always open
- Skin: pale skin
- Top: long black coat with violet trims (#7A3FD0) and silver clasps
- Bottom: black trousers
- Feet: black boots with silver buckles
- Weapon: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no mask, no white hair.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWING ANGLES: every sprite keeps its own DIFFERENT viewing angle; the angles must NOT become identical. Never redraw the whole sheet from a single angle. The character turns in place by exact quarter turns between sprites:
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
WEAPON CHECK: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side — the character visibly HOLDS it in every cell; hands are never empty.
CHANGE NOTHING ELSE: keep the exact same characters, poses, sizes, outfits, hair, background and layout. Only add the missing weapon in the correct hand.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Invocateur: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side; black hair (#15151C), medium length, messy bangs; violet eyes (#9B6BFF), always open; long black coat with violet trims (#7A3FD0) and silver clasps; pale skin; black trousers; black boots with silver buckles. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no mask, no white hair.
```

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE playable hero, Invocateur, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Invocateur (hero of the Brumes nation)
- Hair: black hair (#15151C), medium length, messy bangs
- Eyes: violet eyes (#9B6BFF), always open
- Skin: pale skin
- Top: long black coat with violet trims (#7A3FD0) and silver clasps
- Bottom: black trousers
- Feet: black boots with silver buckles
- Weapon: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no mask, no white hair.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head, grimoire floating behind.
2. SIDE SWING: staff swept horizontally, coat swirling.
3. READING: grimoire floating open in front, pages turning, mint mist and violet spectral wisps rising from it.
4. Seen from BEHIND, the SAME action as pose 1 — OVERHEAD STRIKE: staff raised high above the head, grimoire floating behind.
5. Seen from BEHIND, the SAME action as pose 2 — SIDE SWING: staff swept horizontally, coat swirling.
6. Seen from BEHIND, the SAME action as pose 3 — READING: grimoire floating open in front, pages turning, mint mist and violet spectral wisps rising from it.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Invocateur: spiked dark staff topped with a violet crystal, RIGHT hand; a dark grimoire floating at his left side; black hair (#15151C), medium length, messy bangs; violet eyes (#9B6BFF), always open; long black coat with violet trims (#7A3FD0) and silver clasps; pale skin; black trousers; black boots with silver buckles. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no mask, no white hair.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `invocateur_attack.png` |
| 1-2 | attaque 2 — face | `invocateur_attack_2.png` |
| 1-3 | sort — face | `invocateur_cast.png` |
| 2-1 | attaque 1 — dos | `invocateur_attack_back.png` |
| 2-2 | attaque 2 — dos | `invocateur_attack_2_back.png` |
| 2-3 | sort — dos | `invocateur_cast_back.png` |

L'export Zimut de l'Atelier copie aussi le repos (case 1 de la planche vues) vers `nations/heros/invocateur.png`.

## 3. Ennemis

### Brumeux — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brumes/` ; nomme tes images `brumeux_vues.png` et `brumeux_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held in hand in every cell, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Brumeux (enemy of the Brumes nation)
- Body: hulking mist beast with a fluffy lavender cloud body (#B8A8E0)
- Head: no visible neck, two small glowing mint eyes (#9FFFD8)
- Details: two thick cloud arms with small dark claws, no legs visible
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no clothes, no teeth.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Brumeux: hulking mist beast with a fluffy lavender cloud body (#B8A8E0); no visible neck, two small glowing mint eyes (#9FFFD8); two thick cloud arms with small dark claws, no legs visible. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no weapon, no clothes, no teeth.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `brumeux.png` |
| 1-2 | 3/4 dos droite | `brumeux_back.png` |
| 2-1 | 3/4 dos gauche | `brumeux_back_left.png` |
| 2-2 | 3/4 avant gauche | `brumeux_face_left.png` |

##### Édition corrective (arme manquante sur des cases)

Si l'arme manque sur certaines cases de la planche générée : édition avec la planche `vues` en image source. Ce prompt RÉPÈTE la liste des angles — une édition corrective qui ne la répète pas aplatit toutes les vues dans le même angle.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Brumeux, several times, in the SAME relaxed idle pose seen from DIFFERENT viewing angles (successive quarter turns of the character, the camera fixed).
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Brumeux (enemy of the Brumes nation)
- Body: hulking mist beast with a fluffy lavender cloud body (#B8A8E0)
- Head: no visible neck, two small glowing mint eyes (#9FFFD8)
- Details: two thick cloud arms with small dark claws, no legs visible
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no clothes, no teeth.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWING ANGLES: every sprite keeps its own DIFFERENT viewing angle; the angles must NOT become identical. Never redraw the whole sheet from a single angle. The character turns in place by exact quarter turns between sprites:
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
CHANGE NOTHING ELSE: keep the exact same characters, poses, sizes, outfits, hair, background and layout. Only add the missing weapon in the correct hand.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Brumeux: hulking mist beast with a fluffy lavender cloud body (#B8A8E0); no visible neck, two small glowing mint eyes (#9FFFD8); two thick cloud arms with small dark claws, no legs visible. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no weapon, no clothes, no teeth.
```

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Brumeux, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Brumeux (enemy of the Brumes nation)
- Body: hulking mist beast with a fluffy lavender cloud body (#B8A8E0)
- Head: no visible neck, two small glowing mint eyes (#9FFFD8)
- Details: two thick cloud arms with small dark claws, no legs visible
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no clothes, no teeth.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. SPIN: body whirling, mint mist and violet spectral wisps trail around it.
3. HOVER: floating higher, mint mist and violet spectral wisps orbs circling.
4. Seen from BEHIND, the SAME action as pose 1 — RISE: body stretched tall upward, arms raised.
5. Seen from BEHIND, the SAME action as pose 2 — SPIN: body whirling, mint mist and violet spectral wisps trail around it.
6. Seen from BEHIND, the SAME action as pose 3 — HOVER: floating higher, mint mist and violet spectral wisps orbs circling.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Brumeux: hulking mist beast with a fluffy lavender cloud body (#B8A8E0); no visible neck, two small glowing mint eyes (#9FFFD8); two thick cloud arms with small dark claws, no legs visible. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no weapon, no clothes, no teeth.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `brumeux_attack.png` |
| 1-2 | attaque 2 — face | `brumeux_attack_2.png` |
| 1-3 | sort — face | `brumeux_cast.png` |
| 2-1 | attaque 1 — dos | `brumeux_attack_back.png` |
| 2-2 | attaque 2 — dos | `brumeux_attack_2_back.png` |
| 2-3 | sort — dos | `brumeux_cast_back.png` |

### Gargouille — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brumes/` ; nomme tes images `gargouille_vues.png` et `gargouille_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held in hand in every cell, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Gargouille (enemy of the Brumes nation)
- Body: grey stone gargoyle (#7A7A82) crouching on two legs, cracked stone texture
- Head: small horns, pointed ears, fanged mouth, glowing mint eyes (#9FFFD8)
- Details: stone bat wings, long tail with an arrow tip
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no color other than grey stone and mint eyes.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Gargouille: grey stone gargoyle (#7A7A82) crouching on two legs, cracked stone texture; small horns, pointed ears, fanged mouth, glowing mint eyes (#9FFFD8); stone bat wings, long tail with an arrow tip. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no weapon, no color other than grey stone and mint eyes.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `gargouille.png` |
| 1-2 | 3/4 dos droite | `gargouille_back.png` |
| 2-1 | 3/4 dos gauche | `gargouille_back_left.png` |
| 2-2 | 3/4 avant gauche | `gargouille_face_left.png` |

##### Édition corrective (arme manquante sur des cases)

Si l'arme manque sur certaines cases de la planche générée : édition avec la planche `vues` en image source. Ce prompt RÉPÈTE la liste des angles — une édition corrective qui ne la répète pas aplatit toutes les vues dans le même angle.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Gargouille, several times, in the SAME relaxed idle pose seen from DIFFERENT viewing angles (successive quarter turns of the character, the camera fixed).
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Gargouille (enemy of the Brumes nation)
- Body: grey stone gargoyle (#7A7A82) crouching on two legs, cracked stone texture
- Head: small horns, pointed ears, fanged mouth, glowing mint eyes (#9FFFD8)
- Details: stone bat wings, long tail with an arrow tip
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no color other than grey stone and mint eyes.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWING ANGLES: every sprite keeps its own DIFFERENT viewing angle; the angles must NOT become identical. Never redraw the whole sheet from a single angle. The character turns in place by exact quarter turns between sprites:
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
CHANGE NOTHING ELSE: keep the exact same characters, poses, sizes, outfits, hair, background and layout. Only add the missing weapon in the correct hand.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Gargouille: grey stone gargoyle (#7A7A82) crouching on two legs, cracked stone texture; small horns, pointed ears, fanged mouth, glowing mint eyes (#9FFFD8); stone bat wings, long tail with an arrow tip. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no weapon, no color other than grey stone and mint eyes.
```

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Gargouille, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Gargouille (enemy of the Brumes nation)
- Body: grey stone gargoyle (#7A7A82) crouching on two legs, cracked stone texture
- Head: small horns, pointed ears, fanged mouth, glowing mint eyes (#9FFFD8)
- Details: stone bat wings, long tail with an arrow tip
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no color other than grey stone and mint eyes.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. SIDE SWIPE: head and claws swept to the side, body twisted.
3. HOWL: head raised to the sky, mint mist and violet spectral wisps gathering around the body.
4. Seen from BEHIND, the SAME action as pose 1 — REARING: standing up on the hind legs, front claws raised high.
5. Seen from BEHIND, the SAME action as pose 2 — SIDE SWIPE: head and claws swept to the side, body twisted.
6. Seen from BEHIND, the SAME action as pose 3 — HOWL: head raised to the sky, mint mist and violet spectral wisps gathering around the body.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Gargouille: grey stone gargoyle (#7A7A82) crouching on two legs, cracked stone texture; small horns, pointed ears, fanged mouth, glowing mint eyes (#9FFFD8); stone bat wings, long tail with an arrow tip. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no weapon, no color other than grey stone and mint eyes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `gargouille_attack.png` |
| 1-2 | attaque 2 — face | `gargouille_attack_2.png` |
| 1-3 | sort — face | `gargouille_cast.png` |
| 2-1 | attaque 1 — dos | `gargouille_attack_back.png` |
| 2-2 | attaque 2 — dos | `gargouille_attack_2_back.png` |
| 2-3 | sort — dos | `gargouille_cast_back.png` |

### Liche des brumes — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brumes/` ; nomme tes images `liche_des_brumes_vues.png` et `liche_des_brumes_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held in hand in every cell, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Liche des brumes (enemy of the Brumes nation)
- Body: thin skeletal lich, bony grey hands
- Head: skull face with glowing mint eyes (#9FFFD8) under a tattered hood
- Top: tattered violet robes (#6A4A9A) with torn edges
- Weapon: crooked wooden staff, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no crown, no armor, no hair.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: crooked wooden staff, RIGHT hand — the character visibly HOLDS it in every cell; hands are never empty.
REMINDER: this is Liche des brumes: crooked wooden staff, RIGHT hand; tattered violet robes (#6A4A9A) with torn edges; thin skeletal lich, bony grey hands; skull face with glowing mint eyes (#9FFFD8) under a tattered hood. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no crown, no armor, no hair.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `liche_des_brumes.png` |
| 1-2 | 3/4 dos droite | `liche_des_brumes_back.png` |
| 2-1 | 3/4 dos gauche | `liche_des_brumes_back_left.png` |
| 2-2 | 3/4 avant gauche | `liche_des_brumes_face_left.png` |

##### Édition corrective (arme manquante sur des cases)

Si l'arme manque sur certaines cases de la planche générée : édition avec la planche `vues` en image source. Ce prompt RÉPÈTE la liste des angles — une édition corrective qui ne la répète pas aplatit toutes les vues dans le même angle.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Liche des brumes, several times, in the SAME relaxed idle pose seen from DIFFERENT viewing angles (successive quarter turns of the character, the camera fixed).
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Liche des brumes (enemy of the Brumes nation)
- Body: thin skeletal lich, bony grey hands
- Head: skull face with glowing mint eyes (#9FFFD8) under a tattered hood
- Top: tattered violet robes (#6A4A9A) with torn edges
- Weapon: crooked wooden staff, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no crown, no armor, no hair.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWING ANGLES: every sprite keeps its own DIFFERENT viewing angle; the angles must NOT become identical. Never redraw the whole sheet from a single angle. The character turns in place by exact quarter turns between sprites:
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
WEAPON CHECK: crooked wooden staff, RIGHT hand — the character visibly HOLDS it in every cell; hands are never empty.
CHANGE NOTHING ELSE: keep the exact same characters, poses, sizes, outfits, hair, background and layout. Only add the missing weapon in the correct hand.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Liche des brumes: crooked wooden staff, RIGHT hand; tattered violet robes (#6A4A9A) with torn edges; thin skeletal lich, bony grey hands; skull face with glowing mint eyes (#9FFFD8) under a tattered hood. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no crown, no armor, no hair.
```

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Liche des brumes, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Liche des brumes (enemy of the Brumes nation)
- Body: thin skeletal lich, bony grey hands
- Head: skull face with glowing mint eyes (#9FFFD8) under a tattered hood
- Top: tattered violet robes (#6A4A9A) with torn edges
- Weapon: crooked wooden staff, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no crown, no armor, no hair.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
3. FOCUS: eyes closed, staff held vertically in front of the face, mint mist and violet spectral wisps orb at the top.
4. Seen from BEHIND, the SAME action as pose 1 — OVERHEAD STRIKE: staff raised high above the head with both hands.
5. Seen from BEHIND, the SAME action as pose 2 — SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
6. Seen from BEHIND, the SAME action as pose 3 — FOCUS: eyes closed, staff held vertically in front of the face, mint mist and violet spectral wisps orb at the top.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Liche des brumes: crooked wooden staff, RIGHT hand; tattered violet robes (#6A4A9A) with torn edges; thin skeletal lich, bony grey hands; skull face with glowing mint eyes (#9FFFD8) under a tattered hood. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no crown, no armor, no hair.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `liche_des_brumes_attack.png` |
| 1-2 | attaque 2 — face | `liche_des_brumes_attack_2.png` |
| 1-3 | sort — face | `liche_des_brumes_cast.png` |
| 2-1 | attaque 1 — dos | `liche_des_brumes_attack_back.png` |
| 2-2 | attaque 2 — dos | `liche_des_brumes_attack_2_back.png` |
| 2-3 | sort — dos | `liche_des_brumes_cast_back.png` |

### Fantôme — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brumes/` ; nomme tes images `fantome_vues.png` et `fantome_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held in hand in every cell, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Fantôme (enemy of the Brumes nation)
- Body: pale blue ghost (#BFE3FF) with a round head-body and a wavy tail, no legs
- Head: mischievous face: big dark eyes, tongue out
- Details: two small rounded arms
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no sheet with holes, no chains, no weapon.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Fantôme: pale blue ghost (#BFE3FF) with a round head-body and a wavy tail, no legs; mischievous face: big dark eyes, tongue out; two small rounded arms. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no sheet with holes, no chains, no weapon.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `fantome.png` |
| 1-2 | 3/4 dos droite | `fantome_back.png` |
| 2-1 | 3/4 dos gauche | `fantome_back_left.png` |
| 2-2 | 3/4 avant gauche | `fantome_face_left.png` |

##### Édition corrective (arme manquante sur des cases)

Si l'arme manque sur certaines cases de la planche générée : édition avec la planche `vues` en image source. Ce prompt RÉPÈTE la liste des angles — une édition corrective qui ne la répète pas aplatit toutes les vues dans le même angle.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Fantôme, several times, in the SAME relaxed idle pose seen from DIFFERENT viewing angles (successive quarter turns of the character, the camera fixed).
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Fantôme (enemy of the Brumes nation)
- Body: pale blue ghost (#BFE3FF) with a round head-body and a wavy tail, no legs
- Head: mischievous face: big dark eyes, tongue out
- Details: two small rounded arms
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no sheet with holes, no chains, no weapon.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWING ANGLES: every sprite keeps its own DIFFERENT viewing angle; the angles must NOT become identical. Never redraw the whole sheet from a single angle. The character turns in place by exact quarter turns between sprites:
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
CHANGE NOTHING ELSE: keep the exact same characters, poses, sizes, outfits, hair, background and layout. Only add the missing weapon in the correct hand.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Fantôme: pale blue ghost (#BFE3FF) with a round head-body and a wavy tail, no legs; mischievous face: big dark eyes, tongue out; two small rounded arms. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no sheet with holes, no chains, no weapon.
```

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Fantôme, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Fantôme (enemy of the Brumes nation)
- Body: pale blue ghost (#BFE3FF) with a round head-body and a wavy tail, no legs
- Head: mischievous face: big dark eyes, tongue out
- Details: two small rounded arms
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no sheet with holes, no chains, no weapon.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. SPIN: body whirling, mint mist and violet spectral wisps trail around it.
3. HOVER: floating higher, mint mist and violet spectral wisps orbs circling.
4. Seen from BEHIND, the SAME action as pose 1 — RISE: body stretched tall upward, arms raised.
5. Seen from BEHIND, the SAME action as pose 2 — SPIN: body whirling, mint mist and violet spectral wisps trail around it.
6. Seen from BEHIND, the SAME action as pose 3 — HOVER: floating higher, mint mist and violet spectral wisps orbs circling.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Fantôme: pale blue ghost (#BFE3FF) with a round head-body and a wavy tail, no legs; mischievous face: big dark eyes, tongue out; two small rounded arms. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no sheet with holes, no chains, no weapon.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `fantome_attack.png` |
| 1-2 | attaque 2 — face | `fantome_attack_2.png` |
| 1-3 | sort — face | `fantome_cast.png` |
| 2-1 | attaque 1 — dos | `fantome_attack_back.png` |
| 2-2 | attaque 2 — dos | `fantome_attack_2_back.png` |
| 2-3 | sort — dos | `fantome_cast_back.png` |

## 4. Boss

### Ombrelis le Brumeux — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `brumes_vues.png` et `brumes_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held in hand in every cell, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombrelis le Brumeux (boss of the Brumes nation)
- Body: dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A)
- Head: spiked crown, gaunt pale face, glowing mint eyes
- Weapon: skull-topped staff surrounded by mint mist, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no sword.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: skull-topped staff surrounded by mint mist, RIGHT hand — the character visibly HOLDS it in every cell; hands are never empty.
REMINDER: this is Ombrelis le Brumeux: skull-topped staff surrounded by mint mist, RIGHT hand; dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A); spiked crown, gaunt pale face, glowing mint eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no sword.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `brumes.png` |
| 1-2 | 3/4 dos droite | `brumes_back.png` |
| 2-1 | 3/4 dos gauche | `brumes_back_left.png` |
| 2-2 | 3/4 avant gauche | `brumes_face_left.png` |

##### Édition corrective (arme manquante sur des cases)

Si l'arme manque sur certaines cases de la planche générée : édition avec la planche `vues` en image source. Ce prompt RÉPÈTE la liste des angles — une édition corrective qui ne la répète pas aplatit toutes les vues dans le même angle.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE final boss, Ombrelis le Brumeux, several times, in the SAME relaxed idle pose seen from DIFFERENT viewing angles (successive quarter turns of the character, the camera fixed).
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombrelis le Brumeux (boss of the Brumes nation)
- Body: dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A)
- Head: spiked crown, gaunt pale face, glowing mint eyes
- Weapon: skull-topped staff surrounded by mint mist, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no sword.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWING ANGLES: every sprite keeps its own DIFFERENT viewing angle; the angles must NOT become identical. Never redraw the whole sheet from a single angle. The character turns in place by exact quarter turns between sprites:
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
WEAPON CHECK: skull-topped staff surrounded by mint mist, RIGHT hand — the character visibly HOLDS it in every cell; hands are never empty.
CHANGE NOTHING ELSE: keep the exact same characters, poses, sizes, outfits, hair, background and layout. Only add the missing weapon in the correct hand.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Ombrelis le Brumeux: skull-topped staff surrounded by mint mist, RIGHT hand; dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A); spiked crown, gaunt pale face, glowing mint eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no sword.
```

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE final boss, Ombrelis le Brumeux, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombrelis le Brumeux (boss of the Brumes nation)
- Body: dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A)
- Head: spiked crown, gaunt pale face, glowing mint eyes
- Weapon: skull-topped staff surrounded by mint mist, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no sword.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head, grimoire floating behind.
2. SIDE SWING: staff swept horizontally, coat swirling.
3. READING: grimoire floating open in front, pages turning, mint mist and violet spectral wisps rising from it.
4. Seen from BEHIND, the SAME action as pose 1 — OVERHEAD STRIKE: staff raised high above the head, grimoire floating behind.
5. Seen from BEHIND, the SAME action as pose 2 — SIDE SWING: staff swept horizontally, coat swirling.
6. Seen from BEHIND, the SAME action as pose 3 — READING: grimoire floating open in front, pages turning, mint mist and violet spectral wisps rising from it.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Ombrelis le Brumeux: skull-topped staff surrounded by mint mist, RIGHT hand; dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A); spiked crown, gaunt pale face, glowing mint eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `brumes_attack.png` |
| 1-2 | attaque 2 — face | `brumes_attack_2.png` |
| 1-3 | sort — face | `brumes_cast.png` |
| 2-1 | attaque 1 — dos | `brumes_attack_back.png` |
| 2-2 | attaque 2 — dos | `brumes_attack_2_back.png` |
| 2-3 | sort — dos | `brumes_cast_back.png` |

## Prompt négatif

**Planches vues** (la même pose vue sous 4 angles est voulue, les vues vers la gauche aussi — le négatif commun est adapté) :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, one sprite bigger or smaller than the others, size changing between cells, more than 4 sprites, extra sprites, duplicated row of sprites, all sprites in the same viewing angle, all sprites in the same orientation, empty hands, character without its weapon in a cell, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, different character between cells, pose changing between cells, different outfit between angles, weapon changing shape, weapon changing color, weapon replaced by another weapon, missing weapon, missing accessories, realistic proportions, small head
```

**Planches actions et planche de style** (les actions répétées de dos en rangée 2 sont voulues : seules les répétitions sous le même angle sont interdites) :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, weapon changing shape, weapon changing color, weapon replaced by another weapon, missing weapon, missing accessories, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, different character between poses, realistic proportions, small head
```
