# Nation Brasier (Brasier)

Palette : crimson red, black obsidian, ember orange, gold. Effets : flames and embers. Contre-jour : orange ember.

Format 2 planches par personnage :

1. **Vues** — le personnage au repos vu sous 4 angles en quarts de tour (3/4 avant droite, 3/4 dos droite, 3/4 dos gauche, 3/4 avant gauche) : la caméra ne bouge pas, le personnage tourne sur lui-même. 2 vues plutôt de face, 2 plutôt de dos ; un seul angle par case, aucun doublon possible. Grille 2 × 2 sur image 2:1, poses largement espacées.
2. **Actions** — 2 attaques + 1 sort, chacune vue DE FACE puis DE DOS (3 colonnes × 2 rangées), générées **en édition** de la planche vues (image source = planche vues) : le personnage réellement dessiné sert d'ancre, il ne peut pas changer d'une planche à l'autre. L'arme est verrouillée d'une planche à l'autre (ligne WEAPON LOCK + rappel final). Repli : génération normale (la carte d'identité est recopiée dans chaque prompt).

Chaque prompt recopie la carte d'identité du personnage (`identites.py`) : aucune image à joindre. Ordre conseillé : 1) planche de style, 2) héros, 3) ennemis, 4) boss ; pour chaque personnage : vues puis actions. Prompt négatif : en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Brasier nation (Brasier biome).
NATION PALETTE: crimson red, black obsidian, ember orange, gold. Signature effects: flames and embers.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: two rows with the same 6 characters in the same order, all in idle pose. Top row: 3/4 front view, facing front-right. Bottom row: 3/4 back view, seen from behind, turned toward the upper right. All feet of a row on the same ground line. Leave a wide empty gap (at least half a character width) between characters and between the two rows: nobody overlaps or touches anyone, weapons and capes included. Image aspect ratio 2:1, as large as possible.
CHARACTERS, left to right:
1. the hero (Chasseur: hunter with long red hair in a high ponytail, red and black armor with flame-shaped plates and glowing ember cracks, a red scarf, quiver of arrows on the back, a curved flame-patterned bow in the left hand).
2. Lieutenant (fire hooded lieutenant in orange and red robes holding a flaming staff).
3. Salamandre (orange lava lizard with glowing cracks on its back and a flaming tail).
4. Dévoreur de flammes (fiery orange beast with a mane of flames and big claws).
5. Golem de lave (dark basalt golem with bright orange lava cracks and a molten core).
6. the final boss Kharaz le Flamboyant (flame warlord with burning hair, black and crimson ember armor with sharp plates, holding a great curved flame bow), about 1.5x taller than the others.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Chasseur — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `chasseur_vues.png` et `chasseur_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Chasseur (hero of the Brasier nation)
- Hair: long bright red hair (#D6332A) in a high ponytail
- Eyes: golden eyes, always open
- Skin: fair skin
- Top: red and black armor with flame-shaped plates (#C8281E, #1E1A1C) and glowing ember cracks, red scarf
- Bottom: black trousers with red armored thigh plates
- Feet: black boots with red flame trims
- Weapon: curved flame-patterned bow in the LEFT hand, quiver of arrows on the back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword, no brown hair.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Chasseur: curved flame-patterned bow in the LEFT hand, quiver of arrows on the back; long bright red hair (#D6332A) in a high ponytail; golden eyes, always open; red and black armor with flame-shaped plates (#C8281E, #1E1A1C) and glowing ember cracks, red scarf; fair skin; black trousers with red armored thigh plates; black boots with red flame trims. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no sword, no brown hair.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `chasseur.png` |
| 1-2 | 3/4 dos droite | `chasseur_back.png` |
| 2-1 | 3/4 dos gauche | `chasseur_back_left.png` |
| 2-2 | 3/4 avant gauche | `chasseur_face_left.png` |

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE playable hero, Chasseur, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Chasseur (hero of the Brasier nation)
- Hair: long bright red hair (#D6332A) in a high ponytail
- Eyes: golden eyes, always open
- Skin: fair skin
- Top: red and black armor with flame-shaped plates (#C8281E, #1E1A1C) and glowing ember cracks, red scarf
- Bottom: black trousers with red armored thigh plates
- Feet: black boots with red flame trims
- Weapon: curved flame-patterned bow in the LEFT hand, quiver of arrows on the back
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword, no brown hair.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. SKY SHOT: bow pointed almost straight up, string fully drawn.
2. RELEASE: string hand open behind, bow arm extended, arrow leaving with a flames and embers trail.
3. ENCHANTED ARROW: arrow held up to the face, its tip wrapped in flames and embers.
4. Seen from BEHIND, the SAME action as pose 1 — SKY SHOT: bow pointed almost straight up, string fully drawn.
5. Seen from BEHIND, the SAME action as pose 2 — RELEASE: string hand open behind, bow arm extended, arrow leaving with a flames and embers trail.
6. Seen from BEHIND, the SAME action as pose 3 — ENCHANTED ARROW: arrow held up to the face, its tip wrapped in flames and embers.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Chasseur: curved flame-patterned bow in the LEFT hand, quiver of arrows on the back; long bright red hair (#D6332A) in a high ponytail; golden eyes, always open; red and black armor with flame-shaped plates (#C8281E, #1E1A1C) and glowing ember cracks, red scarf; fair skin; black trousers with red armored thigh plates; black boots with red flame trims. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no sword, no brown hair.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `chasseur_attack.png` |
| 1-2 | attaque 2 — face | `chasseur_attack_2.png` |
| 1-3 | sort — face | `chasseur_cast.png` |
| 2-1 | attaque 1 — dos | `chasseur_attack_back.png` |
| 2-2 | attaque 2 — dos | `chasseur_attack_2_back.png` |
| 2-3 | sort — dos | `chasseur_cast_back.png` |

L'export Zimut de l'Atelier copie aussi le repos (case 1 de la planche vues) vers `nations/heros/chasseur.png`.

## 3. Ennemis

### Lieutenant — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brasier/` ; nomme tes images `lieutenant_vues.png` et `lieutenant_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Lieutenant (enemy of the Brasier nation)
- Hair: hood up, face in shadow with two glowing orange eyes (#FF8A2A)
- Top: orange and red layered cultist robes (#E06A1E, #B0201A) with a black belt
- Bottom: long robe to the ankles
- Feet: black boots
- Weapon: black staff topped with a burning flame, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visible face, no armor, no sword.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Lieutenant: black staff topped with a burning flame, RIGHT hand; hood up, face in shadow with two glowing orange eyes (#FF8A2A); orange and red layered cultist robes (#E06A1E, #B0201A) with a black belt; long robe to the ankles; black boots. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no visible face, no armor, no sword.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `lieutenant.png` |
| 1-2 | 3/4 dos droite | `lieutenant_back.png` |
| 2-1 | 3/4 dos gauche | `lieutenant_back_left.png` |
| 2-2 | 3/4 avant gauche | `lieutenant_face_left.png` |

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Lieutenant, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Lieutenant (enemy of the Brasier nation)
- Hair: hood up, face in shadow with two glowing orange eyes (#FF8A2A)
- Top: orange and red layered cultist robes (#E06A1E, #B0201A) with a black belt
- Bottom: long robe to the ankles
- Feet: black boots
- Weapon: black staff topped with a burning flame, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visible face, no armor, no sword.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
3. FOCUS: eyes closed, staff held vertically in front of the face, flames and embers orb at the top.
4. Seen from BEHIND, the SAME action as pose 1 — OVERHEAD STRIKE: staff raised high above the head with both hands.
5. Seen from BEHIND, the SAME action as pose 2 — SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
6. Seen from BEHIND, the SAME action as pose 3 — FOCUS: eyes closed, staff held vertically in front of the face, flames and embers orb at the top.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Lieutenant: black staff topped with a burning flame, RIGHT hand; hood up, face in shadow with two glowing orange eyes (#FF8A2A); orange and red layered cultist robes (#E06A1E, #B0201A) with a black belt; long robe to the ankles; black boots. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no visible face, no armor, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `lieutenant_attack.png` |
| 1-2 | attaque 2 — face | `lieutenant_attack_2.png` |
| 1-3 | sort — face | `lieutenant_cast.png` |
| 2-1 | attaque 1 — dos | `lieutenant_attack_back.png` |
| 2-2 | attaque 2 — dos | `lieutenant_attack_2_back.png` |
| 2-3 | sort — dos | `lieutenant_cast_back.png` |

### Salamandre — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brasier/` ; nomme tes images `salamandre_vues.png` et `salamandre_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Salamandre (enemy of the Brasier nation)
- Body: orange lava lizard (#E0701E) on four short legs, darker orange back
- Head: round head, big yellow eyes, small smile
- Details: glowing yellow cracks along the back, tail ending in a flame
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no armor, never standing on two legs.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Salamandre: orange lava lizard (#E0701E) on four short legs, darker orange back; round head, big yellow eyes, small smile; glowing yellow cracks along the back, tail ending in a flame. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no wings, no armor, never standing on two legs.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `salamandre.png` |
| 1-2 | 3/4 dos droite | `salamandre_back.png` |
| 2-1 | 3/4 dos gauche | `salamandre_back_left.png` |
| 2-2 | 3/4 avant gauche | `salamandre_face_left.png` |

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Salamandre, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Salamandre (enemy of the Brasier nation)
- Body: orange lava lizard (#E0701E) on four short legs, darker orange back
- Head: round head, big yellow eyes, small smile
- Details: glowing yellow cracks along the back, tail ending in a flame
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no armor, never standing on two legs.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. SIDE SWIPE: head and claws swept to the side, body twisted.
3. HOWL: head raised to the sky, flames and embers gathering around the body.
4. Seen from BEHIND, the SAME action as pose 1 — REARING: standing up on the hind legs, front claws raised high.
5. Seen from BEHIND, the SAME action as pose 2 — SIDE SWIPE: head and claws swept to the side, body twisted.
6. Seen from BEHIND, the SAME action as pose 3 — HOWL: head raised to the sky, flames and embers gathering around the body.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Salamandre: orange lava lizard (#E0701E) on four short legs, darker orange back; round head, big yellow eyes, small smile; glowing yellow cracks along the back, tail ending in a flame. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no wings, no armor, never standing on two legs.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `salamandre_attack.png` |
| 1-2 | attaque 2 — face | `salamandre_attack_2.png` |
| 1-3 | sort — face | `salamandre_cast.png` |
| 2-1 | attaque 1 — dos | `salamandre_attack_back.png` |
| 2-2 | attaque 2 — dos | `salamandre_attack_2_back.png` |
| 2-3 | sort — dos | `salamandre_cast_back.png` |

### Dévoreur de flammes — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brasier/` ; nomme tes images `devoreur_de_flammes_vues.png` et `devoreur_de_flammes_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Dévoreur de flammes (enemy of the Brasier nation)
- Body: fiery orange four-legged beast (#E05A1E) with a dark charcoal belly
- Head: big jaw with fangs, glowing yellow eyes, mane of flames
- Details: big black claws, flaming tail tip
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no armor, no rider.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Dévoreur de flammes: fiery orange four-legged beast (#E05A1E) with a dark charcoal belly; big jaw with fangs, glowing yellow eyes, mane of flames; big black claws, flaming tail tip. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no wings, no armor, no rider.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `devoreur_de_flammes.png` |
| 1-2 | 3/4 dos droite | `devoreur_de_flammes_back.png` |
| 2-1 | 3/4 dos gauche | `devoreur_de_flammes_back_left.png` |
| 2-2 | 3/4 avant gauche | `devoreur_de_flammes_face_left.png` |

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Dévoreur de flammes, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Dévoreur de flammes (enemy of the Brasier nation)
- Body: fiery orange four-legged beast (#E05A1E) with a dark charcoal belly
- Head: big jaw with fangs, glowing yellow eyes, mane of flames
- Details: big black claws, flaming tail tip
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no armor, no rider.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. SIDE SWIPE: head and claws swept to the side, body twisted.
3. HOWL: head raised to the sky, flames and embers gathering around the body.
4. Seen from BEHIND, the SAME action as pose 1 — REARING: standing up on the hind legs, front claws raised high.
5. Seen from BEHIND, the SAME action as pose 2 — SIDE SWIPE: head and claws swept to the side, body twisted.
6. Seen from BEHIND, the SAME action as pose 3 — HOWL: head raised to the sky, flames and embers gathering around the body.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Dévoreur de flammes: fiery orange four-legged beast (#E05A1E) with a dark charcoal belly; big jaw with fangs, glowing yellow eyes, mane of flames; big black claws, flaming tail tip. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no wings, no armor, no rider.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `devoreur_de_flammes_attack.png` |
| 1-2 | attaque 2 — face | `devoreur_de_flammes_attack_2.png` |
| 1-3 | sort — face | `devoreur_de_flammes_cast.png` |
| 2-1 | attaque 1 — dos | `devoreur_de_flammes_attack_back.png` |
| 2-2 | attaque 2 — dos | `devoreur_de_flammes_attack_2_back.png` |
| 2-3 | sort — dos | `devoreur_de_flammes_cast_back.png` |

### Golem de lave — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brasier/` ; nomme tes images `golem_de_lave_vues.png` et `golem_de_lave_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Golem de lave (enemy of the Brasier nation)
- Body: dark basalt golem (#2A2426) with bright orange lava cracks (#FF7A1E)
- Head: small head with two glowing orange eyes
- Details: molten glowing core in the chest, huge rock fists
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no crystals, no moss.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Golem de lave: dark basalt golem (#2A2426) with bright orange lava cracks (#FF7A1E); small head with two glowing orange eyes; molten glowing core in the chest, huge rock fists. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no weapon, no crystals, no moss.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `golem_de_lave.png` |
| 1-2 | 3/4 dos droite | `golem_de_lave_back.png` |
| 2-1 | 3/4 dos gauche | `golem_de_lave_back_left.png` |
| 2-2 | 3/4 avant gauche | `golem_de_lave_face_left.png` |

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Golem de lave, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Golem de lave (enemy of the Brasier nation)
- Body: dark basalt golem (#2A2426) with bright orange lava cracks (#FF7A1E)
- Head: small head with two glowing orange eyes
- Details: molten glowing core in the chest, huge rock fists
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no crystals, no moss.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. BACKHAND: arm swept horizontally to the side, torso twisted.
3. ROOTED: stomping, flames and embers cracks spreading under the feet.
4. Seen from BEHIND, the SAME action as pose 1 — OVERHEAD SMASH: both fists or weapon raised high above the head.
5. Seen from BEHIND, the SAME action as pose 2 — BACKHAND: arm swept horizontally to the side, torso twisted.
6. Seen from BEHIND, the SAME action as pose 3 — ROOTED: stomping, flames and embers cracks spreading under the feet.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Golem de lave: dark basalt golem (#2A2426) with bright orange lava cracks (#FF7A1E); small head with two glowing orange eyes; molten glowing core in the chest, huge rock fists. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no weapon, no crystals, no moss.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `golem_de_lave_attack.png` |
| 1-2 | attaque 2 — face | `golem_de_lave_attack_2.png` |
| 1-3 | sort — face | `golem_de_lave_cast.png` |
| 2-1 | attaque 1 — dos | `golem_de_lave_attack_back.png` |
| 2-2 | attaque 2 — dos | `golem_de_lave_attack_2_back.png` |
| 2-3 | sort — dos | `golem_de_lave_cast_back.png` |

## 4. Boss

### Kharaz le Flamboyant — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `brasier_vues.png` et `brasier_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Kharaz le Flamboyant (boss of the Brasier nation)
- Body: flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks
- Head: burning orange hair like flames, golden eyes
- Weapon: great curved flame bow, LEFT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Kharaz le Flamboyant: great curved flame bow, LEFT hand; flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks; burning orange hair like flames, golden eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no sword.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `brasier.png` |
| 1-2 | 3/4 dos droite | `brasier_back.png` |
| 2-1 | 3/4 dos gauche | `brasier_back_left.png` |
| 2-2 | 3/4 avant gauche | `brasier_face_left.png` |

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE final boss, Kharaz le Flamboyant, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Kharaz le Flamboyant (boss of the Brasier nation)
- Body: flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks
- Head: burning orange hair like flames, golden eyes
- Weapon: great curved flame bow, LEFT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. SKY SHOT: bow pointed almost straight up, string fully drawn.
2. RELEASE: string hand open behind, bow arm extended, arrow leaving with a flames and embers trail.
3. ENCHANTED ARROW: arrow held up to the face, its tip wrapped in flames and embers.
4. Seen from BEHIND, the SAME action as pose 1 — SKY SHOT: bow pointed almost straight up, string fully drawn.
5. Seen from BEHIND, the SAME action as pose 2 — RELEASE: string hand open behind, bow arm extended, arrow leaving with a flames and embers trail.
6. Seen from BEHIND, the SAME action as pose 3 — ENCHANTED ARROW: arrow held up to the face, its tip wrapped in flames and embers.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Kharaz le Flamboyant: great curved flame bow, LEFT hand; flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks; burning orange hair like flames, golden eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `brasier_attack.png` |
| 1-2 | attaque 2 — face | `brasier_attack_2.png` |
| 1-3 | sort — face | `brasier_cast.png` |
| 2-1 | attaque 1 — dos | `brasier_attack_back.png` |
| 2-2 | attaque 2 — dos | `brasier_attack_2_back.png` |
| 2-3 | sort — dos | `brasier_cast_back.png` |

## Prompt négatif

**Planches vues** (la même pose vue sous 4 angles est voulue, les vues vers la gauche aussi — le négatif commun est adapté) :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, one sprite bigger or smaller than the others, size changing between cells, empty hands, character without its weapon in a cell, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, different character between cells, pose changing between cells, different outfit between angles, weapon changing shape, weapon changing color, weapon replaced by another weapon, missing weapon, missing accessories, realistic proportions, small head
```

**Planches actions et planche de style** (les actions répétées de dos en rangée 2 sont voulues : seules les répétitions sous le même angle sont interdites) :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, weapon changing shape, weapon changing color, weapon replaced by another weapon, missing weapon, missing accessories, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, different character between poses, realistic proportions, small head
```
