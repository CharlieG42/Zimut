# Nation Rouages (Rouages)

Palette : brass, copper, dark steel, teal glowing lights. Effets : sparks, steam puffs and teal electric arcs. Contre-jour : warm brass.

Format 2 planches par personnage :

1. **Vues** — le personnage au repos vu sous 4 angles en quarts de tour (3/4 avant droite, 3/4 dos droite, 3/4 dos gauche, 3/4 avant gauche) : la caméra ne bouge pas, le personnage tourne sur lui-même. 2 vues plutôt de face, 2 plutôt de dos ; un seul angle par case, aucun doublon possible. Grille 2 × 2 sur image 2:1, poses largement espacées.
2. **Actions** — 2 attaques + 1 sort, chacune vue DE FACE puis DE DOS (3 colonnes × 2 rangées), générées **en édition** de la planche vues (image source = planche vues) : le personnage réellement dessiné sert d'ancre, il ne peut pas changer d'une planche à l'autre. L'arme est verrouillée d'une planche à l'autre (ligne WEAPON LOCK + rappel final). Repli : génération normale (la carte d'identité est recopiée dans chaque prompt).

Chaque prompt recopie la carte d'identité du personnage (`identites.py`) : aucune image à joindre. Ordre conseillé : 1) planche de style, 2) héros, 3) ennemis, 4) boss ; pour chaque personnage : vues puis actions. Prompt négatif : en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Rouages nation (Rouages biome).
NATION PALETTE: brass, copper, dark steel, teal glowing lights. Signature effects: sparks, steam puffs and teal electric arcs.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm brass rim light on the right edge.
LAYOUT: two rows with the same 6 characters in the same order, all in idle pose. Top row: 3/4 front view, facing front-right. Bottom row: 3/4 back view, seen from behind, turned toward the upper right. All feet of a row on the same ground line. Leave a wide empty gap (at least half a character width) between characters and between the two rows: nobody overlaps or touches anyone, weapons and capes included. Image aspect ratio 2:1, as large as possible.
CHARACTERS, left to right:
1. the hero (Artificier: young engineer with spiky brown hair, brass goggles on the forehead, bronze and steel steampunk armor with teal glowing gems, tool belt with pouches, a big gear-headed hammer in the right hand).
2. Drone aérien (bronze flying drone with claw arms, small propellers and a glowing blue core).
3. Araignée mécanique (bronze mechanical spider with long jointed legs and a blue gem eye).
4. Roue engrenée (rolling bronze cog-wheel creature with a single glowing blue gem eye in the center).
5. Automate de combat (heavy combat automaton of riveted bronze and stone plates with big fists).
6. the final boss Mécanoptère, Colosse d'Engrenages (giant steam colossus of steel and brass with two smoking chimneys on the back, a glowing blue core in the chest and a huge gear hammer), about 1.5x taller than the others.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Artificier — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `artificier_vues.png` et `artificier_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held in hand in every cell, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Artificier (hero of the Rouages nation)
- Hair: spiky brown hair (#6B3E1E)
- Eyes: green eyes, always open
- Head: brass goggles pushed up on the forehead
- Top: bronze and steel steampunk armor with small teal glowing gems (#2FE0C8)
- Bottom: brown trousers, tool belt with pouches
- Feet: heavy brown boots with brass caps
- Weapon: big gear-headed hammer, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no top hat, no gun, no cape.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm brass rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: big gear-headed hammer, RIGHT hand — the character visibly HOLDS it in every cell; hands are never empty.
REMINDER: this is Artificier: big gear-headed hammer, RIGHT hand; spiky brown hair (#6B3E1E); green eyes, always open; bronze and steel steampunk armor with small teal glowing gems (#2FE0C8); brass goggles pushed up on the forehead; brown trousers, tool belt with pouches; heavy brown boots with brass caps. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no top hat, no gun, no cape.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `artificier.png` |
| 1-2 | 3/4 dos droite | `artificier_back.png` |
| 2-1 | 3/4 dos gauche | `artificier_back_left.png` |
| 2-2 | 3/4 avant gauche | `artificier_face_left.png` |

##### Édition corrective (arme manquante sur des cases)

Si l'arme manque sur certaines cases de la planche générée : édition avec la planche `vues` en image source. Ce prompt RÉPÈTE la liste des angles — une édition corrective qui ne la répète pas aplatit toutes les vues dans le même angle.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE playable hero, Artificier, several times, in the SAME relaxed idle pose seen from DIFFERENT viewing angles (successive quarter turns of the character, the camera fixed).
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Artificier (hero of the Rouages nation)
- Hair: spiky brown hair (#6B3E1E)
- Eyes: green eyes, always open
- Head: brass goggles pushed up on the forehead
- Top: bronze and steel steampunk armor with small teal glowing gems (#2FE0C8)
- Bottom: brown trousers, tool belt with pouches
- Feet: heavy brown boots with brass caps
- Weapon: big gear-headed hammer, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no top hat, no gun, no cape.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWING ANGLES: every sprite keeps its own DIFFERENT viewing angle; the angles must NOT become identical. Never redraw the whole sheet from a single angle. The character turns in place by exact quarter turns between sprites:
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
WEAPON CHECK: big gear-headed hammer, RIGHT hand — the character visibly HOLDS it in every cell; hands are never empty.
CHANGE NOTHING ELSE: keep the exact same characters, poses, sizes, outfits, hair, background and layout. Only add the missing weapon in the correct hand.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Artificier: big gear-headed hammer, RIGHT hand; spiky brown hair (#6B3E1E); green eyes, always open; bronze and steel steampunk armor with small teal glowing gems (#2FE0C8); brass goggles pushed up on the forehead; brown trousers, tool belt with pouches; heavy brown boots with brass caps. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no top hat, no gun, no cape.
```

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE playable hero, Artificier, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Artificier (hero of the Rouages nation)
- Hair: spiky brown hair (#6B3E1E)
- Eyes: green eyes, always open
- Head: brass goggles pushed up on the forehead
- Top: bronze and steel steampunk armor with small teal glowing gems (#2FE0C8)
- Bottom: brown trousers, tool belt with pouches
- Feet: heavy brown boots with brass caps
- Weapon: big gear-headed hammer, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no top hat, no gun, no cape.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm brass rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: gear hammer raised high above the head with both hands.
2. SIDE SWING: gear hammer swept horizontally, goggles bouncing.
3. TINKERING: kneeling, adjusting a small device on the ground, sparks, steam puffs and teal electric arcs crackling.
4. Seen from BEHIND, the SAME action as pose 1 — OVERHEAD SMASH: gear hammer raised high above the head with both hands.
5. Seen from BEHIND, the SAME action as pose 2 — SIDE SWING: gear hammer swept horizontally, goggles bouncing.
6. Seen from BEHIND, the SAME action as pose 3 — TINKERING: kneeling, adjusting a small device on the ground, sparks, steam puffs and teal electric arcs crackling.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Artificier: big gear-headed hammer, RIGHT hand; spiky brown hair (#6B3E1E); green eyes, always open; bronze and steel steampunk armor with small teal glowing gems (#2FE0C8); brass goggles pushed up on the forehead; brown trousers, tool belt with pouches; heavy brown boots with brass caps. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no top hat, no gun, no cape.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `artificier_attack.png` |
| 1-2 | attaque 2 — face | `artificier_attack_2.png` |
| 1-3 | sort — face | `artificier_cast.png` |
| 2-1 | attaque 1 — dos | `artificier_attack_back.png` |
| 2-2 | attaque 2 — dos | `artificier_attack_2_back.png` |
| 2-3 | sort — dos | `artificier_cast_back.png` |

L'export Zimut de l'Atelier copie aussi le repos (case 1 de la planche vues) vers `nations/heros/artificier.png`.

## 3. Ennemis

### Drone aérien — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/rouages/` ; nomme tes images `drone_aerien_vues.png` et `drone_aerien_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held in hand in every cell, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Drone aérien (enemy of the Rouages nation)
- Body: round bronze flying drone (#B8873A) with riveted plates
- Head: single glowing blue core eye (#3FC8FF) in the front
- Details: two small propellers on top, two jointed claw arms below
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no wings, no human parts.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm brass rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Drone aérien: round bronze flying drone (#B8873A) with riveted plates; single glowing blue core eye (#3FC8FF) in the front; two small propellers on top, two jointed claw arms below. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no legs, no wings, no human parts.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `drone_aerien.png` |
| 1-2 | 3/4 dos droite | `drone_aerien_back.png` |
| 2-1 | 3/4 dos gauche | `drone_aerien_back_left.png` |
| 2-2 | 3/4 avant gauche | `drone_aerien_face_left.png` |

##### Édition corrective (arme manquante sur des cases)

Si l'arme manque sur certaines cases de la planche générée : édition avec la planche `vues` en image source. Ce prompt RÉPÈTE la liste des angles — une édition corrective qui ne la répète pas aplatit toutes les vues dans le même angle.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Drone aérien, several times, in the SAME relaxed idle pose seen from DIFFERENT viewing angles (successive quarter turns of the character, the camera fixed).
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Drone aérien (enemy of the Rouages nation)
- Body: round bronze flying drone (#B8873A) with riveted plates
- Head: single glowing blue core eye (#3FC8FF) in the front
- Details: two small propellers on top, two jointed claw arms below
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no wings, no human parts.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWING ANGLES: every sprite keeps its own DIFFERENT viewing angle; the angles must NOT become identical. Never redraw the whole sheet from a single angle. The character turns in place by exact quarter turns between sprites:
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
CHANGE NOTHING ELSE: keep the exact same characters, poses, sizes, outfits, hair, background and layout. Only add the missing weapon in the correct hand.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Drone aérien: round bronze flying drone (#B8873A) with riveted plates; single glowing blue core eye (#3FC8FF) in the front; two small propellers on top, two jointed claw arms below. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no legs, no wings, no human parts.
```

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Drone aérien, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Drone aérien (enemy of the Rouages nation)
- Body: round bronze flying drone (#B8873A) with riveted plates
- Head: single glowing blue core eye (#3FC8FF) in the front
- Details: two small propellers on top, two jointed claw arms below
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no wings, no human parts.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm brass rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. SPIN: body whirling, sparks, steam puffs and teal electric arcs trail around it.
3. HOVER: floating higher, sparks, steam puffs and teal electric arcs orbs circling.
4. Seen from BEHIND, the SAME action as pose 1 — RISE: body stretched tall upward, arms raised.
5. Seen from BEHIND, the SAME action as pose 2 — SPIN: body whirling, sparks, steam puffs and teal electric arcs trail around it.
6. Seen from BEHIND, the SAME action as pose 3 — HOVER: floating higher, sparks, steam puffs and teal electric arcs orbs circling.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Drone aérien: round bronze flying drone (#B8873A) with riveted plates; single glowing blue core eye (#3FC8FF) in the front; two small propellers on top, two jointed claw arms below. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no legs, no wings, no human parts.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `drone_aerien_attack.png` |
| 1-2 | attaque 2 — face | `drone_aerien_attack_2.png` |
| 1-3 | sort — face | `drone_aerien_cast.png` |
| 2-1 | attaque 1 — dos | `drone_aerien_attack_back.png` |
| 2-2 | attaque 2 — dos | `drone_aerien_attack_2_back.png` |
| 2-3 | sort — dos | `drone_aerien_cast_back.png` |

### Araignée mécanique — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/rouages/` ; nomme tes images `araignee_mecanique_vues.png` et `araignee_mecanique_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held in hand in every cell, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Araignée mécanique (enemy of the Rouages nation)
- Body: bronze mechanical spider (#B8873A) with a riveted round body
- Head: single blue gem eye (#3FC8FF)
- Details: eight long jointed steel legs (#8A9098)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no fur, no organic parts.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm brass rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Araignée mécanique: bronze mechanical spider (#B8873A) with a riveted round body; single blue gem eye (#3FC8FF); eight long jointed steel legs (#8A9098). The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no fur, no organic parts.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `araignee_mecanique.png` |
| 1-2 | 3/4 dos droite | `araignee_mecanique_back.png` |
| 2-1 | 3/4 dos gauche | `araignee_mecanique_back_left.png` |
| 2-2 | 3/4 avant gauche | `araignee_mecanique_face_left.png` |

##### Édition corrective (arme manquante sur des cases)

Si l'arme manque sur certaines cases de la planche générée : édition avec la planche `vues` en image source. Ce prompt RÉPÈTE la liste des angles — une édition corrective qui ne la répète pas aplatit toutes les vues dans le même angle.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Araignée mécanique, several times, in the SAME relaxed idle pose seen from DIFFERENT viewing angles (successive quarter turns of the character, the camera fixed).
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Araignée mécanique (enemy of the Rouages nation)
- Body: bronze mechanical spider (#B8873A) with a riveted round body
- Head: single blue gem eye (#3FC8FF)
- Details: eight long jointed steel legs (#8A9098)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no fur, no organic parts.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWING ANGLES: every sprite keeps its own DIFFERENT viewing angle; the angles must NOT become identical. Never redraw the whole sheet from a single angle. The character turns in place by exact quarter turns between sprites:
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
CHANGE NOTHING ELSE: keep the exact same characters, poses, sizes, outfits, hair, background and layout. Only add the missing weapon in the correct hand.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Araignée mécanique: bronze mechanical spider (#B8873A) with a riveted round body; single blue gem eye (#3FC8FF); eight long jointed steel legs (#8A9098). The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no fur, no organic parts.
```

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Araignée mécanique, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Araignée mécanique (enemy of the Rouages nation)
- Body: bronze mechanical spider (#B8873A) with a riveted round body
- Head: single blue gem eye (#3FC8FF)
- Details: eight long jointed steel legs (#8A9098)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no fur, no organic parts.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm brass rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. SIDE SWIPE: head and claws swept to the side, body twisted.
3. HOWL: head raised to the sky, sparks, steam puffs and teal electric arcs gathering around the body.
4. Seen from BEHIND, the SAME action as pose 1 — REARING: standing up on the hind legs, front claws raised high.
5. Seen from BEHIND, the SAME action as pose 2 — SIDE SWIPE: head and claws swept to the side, body twisted.
6. Seen from BEHIND, the SAME action as pose 3 — HOWL: head raised to the sky, sparks, steam puffs and teal electric arcs gathering around the body.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Araignée mécanique: bronze mechanical spider (#B8873A) with a riveted round body; single blue gem eye (#3FC8FF); eight long jointed steel legs (#8A9098). The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no fur, no organic parts.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `araignee_mecanique_attack.png` |
| 1-2 | attaque 2 — face | `araignee_mecanique_attack_2.png` |
| 1-3 | sort — face | `araignee_mecanique_cast.png` |
| 2-1 | attaque 1 — dos | `araignee_mecanique_attack_back.png` |
| 2-2 | attaque 2 — dos | `araignee_mecanique_attack_2_back.png` |
| 2-3 | sort — dos | `araignee_mecanique_cast_back.png` |

### Roue engrenée — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/rouages/` ; nomme tes images `roue_engrenee_vues.png` et `roue_engrenee_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held in hand in every cell, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Roue engrenée (enemy of the Rouages nation)
- Body: rolling bronze cog-wheel creature (#B8873A) standing upright on its edge
- Head: single glowing blue gem eye (#3FC8FF) in the center of the wheel
- Details: two small jointed steel arms on the sides
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no face other than the gem eye.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm brass rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Roue engrenée: rolling bronze cog-wheel creature (#B8873A) standing upright on its edge; single glowing blue gem eye (#3FC8FF) in the center of the wheel; two small jointed steel arms on the sides. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no legs, no face other than the gem eye.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `roue_engrenee.png` |
| 1-2 | 3/4 dos droite | `roue_engrenee_back.png` |
| 2-1 | 3/4 dos gauche | `roue_engrenee_back_left.png` |
| 2-2 | 3/4 avant gauche | `roue_engrenee_face_left.png` |

##### Édition corrective (arme manquante sur des cases)

Si l'arme manque sur certaines cases de la planche générée : édition avec la planche `vues` en image source. Ce prompt RÉPÈTE la liste des angles — une édition corrective qui ne la répète pas aplatit toutes les vues dans le même angle.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Roue engrenée, several times, in the SAME relaxed idle pose seen from DIFFERENT viewing angles (successive quarter turns of the character, the camera fixed).
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Roue engrenée (enemy of the Rouages nation)
- Body: rolling bronze cog-wheel creature (#B8873A) standing upright on its edge
- Head: single glowing blue gem eye (#3FC8FF) in the center of the wheel
- Details: two small jointed steel arms on the sides
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no face other than the gem eye.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWING ANGLES: every sprite keeps its own DIFFERENT viewing angle; the angles must NOT become identical. Never redraw the whole sheet from a single angle. The character turns in place by exact quarter turns between sprites:
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
CHANGE NOTHING ELSE: keep the exact same characters, poses, sizes, outfits, hair, background and layout. Only add the missing weapon in the correct hand.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Roue engrenée: rolling bronze cog-wheel creature (#B8873A) standing upright on its edge; single glowing blue gem eye (#3FC8FF) in the center of the wheel; two small jointed steel arms on the sides. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no legs, no face other than the gem eye.
```

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Roue engrenée, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Roue engrenée (enemy of the Rouages nation)
- Body: rolling bronze cog-wheel creature (#B8873A) standing upright on its edge
- Head: single glowing blue gem eye (#3FC8FF) in the center of the wheel
- Details: two small jointed steel arms on the sides
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no legs, no face other than the gem eye.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm brass rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. BACKHAND: arm swept horizontally to the side, torso twisted.
3. ROOTED: stomping, sparks, steam puffs and teal electric arcs cracks spreading under the feet.
4. Seen from BEHIND, the SAME action as pose 1 — OVERHEAD SMASH: both fists or weapon raised high above the head.
5. Seen from BEHIND, the SAME action as pose 2 — BACKHAND: arm swept horizontally to the side, torso twisted.
6. Seen from BEHIND, the SAME action as pose 3 — ROOTED: stomping, sparks, steam puffs and teal electric arcs cracks spreading under the feet.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Roue engrenée: rolling bronze cog-wheel creature (#B8873A) standing upright on its edge; single glowing blue gem eye (#3FC8FF) in the center of the wheel; two small jointed steel arms on the sides. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no legs, no face other than the gem eye.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `roue_engrenee_attack.png` |
| 1-2 | attaque 2 — face | `roue_engrenee_attack_2.png` |
| 1-3 | sort — face | `roue_engrenee_cast.png` |
| 2-1 | attaque 1 — dos | `roue_engrenee_attack_back.png` |
| 2-2 | attaque 2 — dos | `roue_engrenee_attack_2_back.png` |
| 2-3 | sort — dos | `roue_engrenee_cast_back.png` |

### Automate de combat — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/rouages/` ; nomme tes images `automate_de_combat_vues.png` et `automate_de_combat_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held in hand in every cell, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Automate de combat (enemy of the Rouages nation)
- Body: heavy combat automaton of riveted bronze (#B8873A) and grey stone plates
- Head: small dome head with a glowing blue visor slit (#3FC8FF)
- Details: huge fists, small smoking pipe on the back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human face, no weapon.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm brass rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Automate de combat: heavy combat automaton of riveted bronze (#B8873A) and grey stone plates; small dome head with a glowing blue visor slit (#3FC8FF); huge fists, small smoking pipe on the back. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no human face, no weapon.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `automate_de_combat.png` |
| 1-2 | 3/4 dos droite | `automate_de_combat_back.png` |
| 2-1 | 3/4 dos gauche | `automate_de_combat_back_left.png` |
| 2-2 | 3/4 avant gauche | `automate_de_combat_face_left.png` |

##### Édition corrective (arme manquante sur des cases)

Si l'arme manque sur certaines cases de la planche générée : édition avec la planche `vues` en image source. Ce prompt RÉPÈTE la liste des angles — une édition corrective qui ne la répète pas aplatit toutes les vues dans le même angle.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Automate de combat, several times, in the SAME relaxed idle pose seen from DIFFERENT viewing angles (successive quarter turns of the character, the camera fixed).
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Automate de combat (enemy of the Rouages nation)
- Body: heavy combat automaton of riveted bronze (#B8873A) and grey stone plates
- Head: small dome head with a glowing blue visor slit (#3FC8FF)
- Details: huge fists, small smoking pipe on the back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human face, no weapon.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWING ANGLES: every sprite keeps its own DIFFERENT viewing angle; the angles must NOT become identical. Never redraw the whole sheet from a single angle. The character turns in place by exact quarter turns between sprites:
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
CHANGE NOTHING ELSE: keep the exact same characters, poses, sizes, outfits, hair, background and layout. Only add the missing weapon in the correct hand.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Automate de combat: heavy combat automaton of riveted bronze (#B8873A) and grey stone plates; small dome head with a glowing blue visor slit (#3FC8FF); huge fists, small smoking pipe on the back. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no human face, no weapon.
```

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Automate de combat, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Automate de combat (enemy of the Rouages nation)
- Body: heavy combat automaton of riveted bronze (#B8873A) and grey stone plates
- Head: small dome head with a glowing blue visor slit (#3FC8FF)
- Details: huge fists, small smoking pipe on the back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human face, no weapon.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm brass rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. BACKHAND: arm swept horizontally to the side, torso twisted.
3. ROOTED: stomping, sparks, steam puffs and teal electric arcs cracks spreading under the feet.
4. Seen from BEHIND, the SAME action as pose 1 — OVERHEAD SMASH: both fists or weapon raised high above the head.
5. Seen from BEHIND, the SAME action as pose 2 — BACKHAND: arm swept horizontally to the side, torso twisted.
6. Seen from BEHIND, the SAME action as pose 3 — ROOTED: stomping, sparks, steam puffs and teal electric arcs cracks spreading under the feet.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Automate de combat: heavy combat automaton of riveted bronze (#B8873A) and grey stone plates; small dome head with a glowing blue visor slit (#3FC8FF); huge fists, small smoking pipe on the back. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no human face, no weapon.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `automate_de_combat_attack.png` |
| 1-2 | attaque 2 — face | `automate_de_combat_attack_2.png` |
| 1-3 | sort — face | `automate_de_combat_cast.png` |
| 2-1 | attaque 1 — dos | `automate_de_combat_attack_back.png` |
| 2-2 | attaque 2 — dos | `automate_de_combat_attack_2_back.png` |
| 2-3 | sort — dos | `automate_de_combat_cast_back.png` |

## 4. Boss

### Mécanoptère, Colosse d'Engrenages — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `rouages_vues.png` et `rouages_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held in hand in every cell, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Mécanoptère, Colosse d'Engrenages (boss of the Rouages nation)
- Body: giant steam colossus of steel and brass (#B8873A) with two smoking chimneys on the back
- Head: riveted steel head with two glowing blue eyes
- Details: glowing blue core in the chest
- Weapon: huge gear hammer, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no human face.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm brass rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: huge gear hammer, RIGHT hand — the character visibly HOLDS it in every cell; hands are never empty.
REMINDER: this is Mécanoptère, Colosse d'Engrenages: huge gear hammer, RIGHT hand; giant steam colossus of steel and brass (#B8873A) with two smoking chimneys on the back; riveted steel head with two glowing blue eyes; glowing blue core in the chest. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no wings, no human face.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `rouages.png` |
| 1-2 | 3/4 dos droite | `rouages_back.png` |
| 2-1 | 3/4 dos gauche | `rouages_back_left.png` |
| 2-2 | 3/4 avant gauche | `rouages_face_left.png` |

##### Édition corrective (arme manquante sur des cases)

Si l'arme manque sur certaines cases de la planche générée : édition avec la planche `vues` en image source. Ce prompt RÉPÈTE la liste des angles — une édition corrective qui ne la répète pas aplatit toutes les vues dans le même angle.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE final boss, Mécanoptère, Colosse d'Engrenages, several times, in the SAME relaxed idle pose seen from DIFFERENT viewing angles (successive quarter turns of the character, the camera fixed).
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Mécanoptère, Colosse d'Engrenages (boss of the Rouages nation)
- Body: giant steam colossus of steel and brass (#B8873A) with two smoking chimneys on the back
- Head: riveted steel head with two glowing blue eyes
- Details: glowing blue core in the chest
- Weapon: huge gear hammer, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no human face.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWING ANGLES: every sprite keeps its own DIFFERENT viewing angle; the angles must NOT become identical. Never redraw the whole sheet from a single angle. The character turns in place by exact quarter turns between sprites:
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
WEAPON CHECK: huge gear hammer, RIGHT hand — the character visibly HOLDS it in every cell; hands are never empty.
CHANGE NOTHING ELSE: keep the exact same characters, poses, sizes, outfits, hair, background and layout. Only add the missing weapon in the correct hand.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Mécanoptère, Colosse d'Engrenages: huge gear hammer, RIGHT hand; giant steam colossus of steel and brass (#B8873A) with two smoking chimneys on the back; riveted steel head with two glowing blue eyes; glowing blue core in the chest. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no wings, no human face.
```

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE final boss, Mécanoptère, Colosse d'Engrenages, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Mécanoptère, Colosse d'Engrenages (boss of the Rouages nation)
- Body: giant steam colossus of steel and brass (#B8873A) with two smoking chimneys on the back
- Head: riveted steel head with two glowing blue eyes
- Details: glowing blue core in the chest
- Weapon: huge gear hammer, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no human face.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm brass rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. BACKHAND: arm swept horizontally to the side, torso twisted.
3. ROOTED: stomping, sparks, steam puffs and teal electric arcs cracks spreading under the feet.
4. Seen from BEHIND, the SAME action as pose 1 — OVERHEAD SMASH: both fists or weapon raised high above the head.
5. Seen from BEHIND, the SAME action as pose 2 — BACKHAND: arm swept horizontally to the side, torso twisted.
6. Seen from BEHIND, the SAME action as pose 3 — ROOTED: stomping, sparks, steam puffs and teal electric arcs cracks spreading under the feet.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Mécanoptère, Colosse d'Engrenages: huge gear hammer, RIGHT hand; giant steam colossus of steel and brass (#B8873A) with two smoking chimneys on the back; riveted steel head with two glowing blue eyes; glowing blue core in the chest. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no wings, no human face.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `rouages_attack.png` |
| 1-2 | attaque 2 — face | `rouages_attack_2.png` |
| 1-3 | sort — face | `rouages_cast.png` |
| 2-1 | attaque 1 — dos | `rouages_attack_back.png` |
| 2-2 | attaque 2 — dos | `rouages_attack_2_back.png` |
| 2-3 | sort — dos | `rouages_cast_back.png` |

## Prompt négatif

**Planches vues** (la même pose vue sous 4 angles est voulue, les vues vers la gauche aussi — le négatif commun est adapté) :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, one sprite bigger or smaller than the others, size changing between cells, more than 4 sprites, extra sprites, duplicated row of sprites, all sprites in the same viewing angle, all sprites in the same orientation, empty hands, character without its weapon in a cell, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, different character between cells, pose changing between cells, different outfit between angles, weapon changing shape, weapon changing color, weapon replaced by another weapon, missing weapon, missing accessories, realistic proportions, small head
```

**Planches actions et planche de style** (les actions répétées de dos en rangée 2 sont voulues : seules les répétitions sous le même angle sont interdites) :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, weapon changing shape, weapon changing color, weapon replaced by another weapon, missing weapon, missing accessories, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, different character between poses, realistic proportions, small head
```
