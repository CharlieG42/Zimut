# Nation Brasier (Brasier)

Palette : crimson red, black obsidian, ember orange, gold. Effets : flames and embers. Contre-jour : orange ember.

Chaque personnage est dessiné en **vue 3/4 avant (face)** et en **vue 3/4 arrière (dos)**. Le jeu retourne l'image pour les directions vers la gauche. Une fiche de référence (repos face + dos), puis des planches de 4 poses (2 × 2) bien séparées. Prompt négatif : voir en bas de page.

Ordre conseillé : 1) planche de référence, 2) héros, 3) ennemis, 4) boss.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos. Joins-la comme image de référence à toutes les planches suivantes.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Brasier nation (Brasier biome).
NATION PALETTE: crimson red, black obsidian, ember orange, gold. Signature effects: flames and embers.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: two rows with the same 6 characters in the same order, all in idle pose. Top row: 3/4 front view, facing front-right. Bottom row: 3/4 back view, seen from behind, turned toward the upper right. All feet of a row on the same ground line. Leave a wide empty gap (at least half a character width) between characters and between the two rows: nobody overlaps or touches anyone, weapons and capes included. Image aspect ratio 2:1, as large as possible.
CHARACTERS, left to right:
1. the hero (Chasseur: hunter with long red hair in a high ponytail, red and black armor with flame-shaped plates and glowing ember cracks, a red scarf, quiver of arrows on the back, a curved flame-patterned bow in the left hand).
2. Lieutenant (fire cultist lieutenant in orange and red robes holding a flaming staff).
3. Salamandre (orange lava lizard with glowing cracks on its back and a flaming tail).
4. Dévoreur de flammes (fiery orange beast with a mane of flames and big claws).
5. Golem de lave (dark basalt golem with bright orange lava cracks and a molten core).
6. the final boss Kharaz le Flamboyant (flame warlord with burning hair, black and crimson ember armor with sharp plates, holding a great curved flame bow), about 1.5x taller than the others.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Chasseur — 22 poses

6 planches, 22 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `chasseur_<clé>.png` (ex. `chasseur_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Chasseur », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE playable hero for a chibi isometric tactical RPG.
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
NATION PALETTE: crimson red, black obsidian, ember orange, gold. Signature effects (keep them small): flames and embers.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Chasseur: long bright red hair (#D6332A) in a high ponytail; golden eyes, always open; fair skin; red and black armor with flame-shaped plates (#C8281E, #1E1A1C) and glowing ember cracks, red scarf. Forbidden: no helmet, no sword, no brown hair.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `chasseur.png` |
| 1-2 | repos 1 (dos) | `chasseur_back.png` |

#### Planche 2 — Face 1 · garde, marche, sort (`face_1`)

Dans l'Atelier : personnage « Chasseur », planche « Face 1 · garde, marche, sort ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
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
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. GUARD: knees bent, weapon raised in front of the body, ready to fight.
2. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
3. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
4. ENCHANTED ARROW: arrow held up to the face, its tip wrapped in flames and embers.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Chasseur: long bright red hair (#D6332A) in a high ponytail; golden eyes, always open; fair skin; red and black armor with flame-shaped plates (#C8281E, #1E1A1C) and glowing ember cracks, red scarf. Forbidden: no helmet, no sword, no brown hair.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 2 | `chasseur_idle_2.png` |
| 1-2 | marche 1 | `chasseur_walk.png` |
| 2-1 | marche 2 | `chasseur_walk_2.png` |
| 2-2 | sort 1 | `chasseur_cast.png` |

#### Planche 3 — Face 2 · attaques 1 à 4 (`face_2`)

Dans l'Atelier : personnage « Chasseur », planche « Face 2 · attaques 1 à 4 ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
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
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. SKY SHOT: bow pointed almost straight up, string fully drawn.
2. FULL DRAW: bow aimed straight forward, string pulled to the cheek, body sideways.
3. RELEASE: string hand open behind, bow arm extended, arrow leaving with a flames and embers trail.
4. JUMPING SHOT: whole body in the air, aiming down and forward.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Chasseur: long bright red hair (#D6332A) in a high ponytail; golden eyes, always open; fair skin; red and black armor with flame-shaped plates (#C8281E, #1E1A1C) and glowing ember cracks, red scarf. Forbidden: no helmet, no sword, no brown hair.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `chasseur_attack.png` |
| 1-2 | attaque 2 | `chasseur_attack_2.png` |
| 2-1 | attaque 3 | `chasseur_attack_3.png` |
| 2-2 | attaque 4 | `chasseur_attack_4.png` |

#### Planche 4 — Face 3 · attaques 5-6, sorts 2-3 (`face_3`)

Dans l'Atelier : personnage « Chasseur », planche « Face 3 · attaques 5-6, sorts 2-3 ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
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
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. KNEELING SHOT: on one knee, bow held low and tilted.
2. POINT-BLANK KICK: bow held back, one leg kicking high forward.
3. VOLLEY: bow raised overhead, three flames and embers arrows rising into the air.
4. TRAP: crouched, placing a flames and embers trap on the ground with the free hand.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Chasseur: long bright red hair (#D6332A) in a high ponytail; golden eyes, always open; fair skin; red and black armor with flame-shaped plates (#C8281E, #1E1A1C) and glowing ember cracks, red scarf. Forbidden: no helmet, no sword, no brown hair.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 5 | `chasseur_attack_5.png` |
| 1-2 | attaque 6 | `chasseur_attack_6.png` |
| 2-1 | sort 2 | `chasseur_cast_2.png` |
| 2-2 | sort 3 | `chasseur_cast_3.png` |

#### Planche 5 — Dos 1 · marche, attaque, sort (`dos_1`)

Dans l'Atelier : personnage « Chasseur », planche « Dos 1 · marche, attaque, sort ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
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
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
3. SKY SHOT: bow pointed almost straight up, string fully drawn.
4. ENCHANTED ARROW: arrow held up to the face, its tip wrapped in flames and embers.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Chasseur: long bright red hair (#D6332A) in a high ponytail; golden eyes, always open; fair skin; red and black armor with flame-shaped plates (#C8281E, #1E1A1C) and glowing ember cracks, red scarf. Forbidden: no helmet, no sword, no brown hair.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `chasseur_back_walk.png` |
| 1-2 | marche 2 | `chasseur_back_walk_2.png` |
| 2-1 | attaque 1 | `chasseur_back_attack.png` |
| 2-2 | sort 1 | `chasseur_back_cast.png` |

#### Planche 6 — Dos 2 · attaques 2 à 4, garde (`dos_2`)

Dans l'Atelier : personnage « Chasseur », planche « Dos 2 · attaques 2 à 4, garde ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
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
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. FULL DRAW: bow aimed straight forward, string pulled to the cheek, body sideways.
2. RELEASE: string hand open behind, bow arm extended, arrow leaving with a flames and embers trail.
3. JUMPING SHOT: whole body in the air, aiming down and forward.
4. GUARD: knees bent, weapon raised in front of the body, ready to fight.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Chasseur: long bright red hair (#D6332A) in a high ponytail; golden eyes, always open; fair skin; red and black armor with flame-shaped plates (#C8281E, #1E1A1C) and glowing ember cracks, red scarf. Forbidden: no helmet, no sword, no brown hair.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 2 | `chasseur_back_attack_2.png` |
| 1-2 | attaque 3 | `chasseur_back_attack_3.png` |
| 2-1 | attaque 4 | `chasseur_back_attack_4.png` |
| 2-2 | repos 2 | `chasseur_back_idle_2.png` |

L'export Zimut de l'Atelier copie aussi le repos vers `nations/heros/chasseur.png` et les autres poses vers `nations/heros/poses/`.

## 3. Ennemis

### Lieutenant — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brasier/` ; nomme tes images `lieutenant_<clé>.png` (ex. `lieutenant_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Lieutenant », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Lieutenant (enemy of the Brasier nation)
- Hair: hood up, face in shadow with two glowing orange eyes (#FF8A2A)
- Top: orange and red layered cultist robes (#E06A1E, #B0201A) with a black belt
- Bottom: long robe to the ankles
- Feet: black boots
- Weapon: black staff topped with a burning flame, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visible face, no armor, no sword.
NATION PALETTE: crimson red, black obsidian, ember orange, gold. Signature effects (keep them small): flames and embers.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Lieutenant: hood up, face in shadow with two glowing orange eyes (#FF8A2A); orange and red layered cultist robes (#E06A1E, #B0201A) with a black belt; long robe to the ankles; black boots. Forbidden: no visible face, no armor, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `lieutenant.png` |
| 1-2 | repos 1 (dos) | `lieutenant_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Lieutenant », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Lieutenant (enemy of the Brasier nation)
- Hair: hood up, face in shadow with two glowing orange eyes (#FF8A2A)
- Top: orange and red layered cultist robes (#E06A1E, #B0201A) with a black belt
- Bottom: long robe to the ankles
- Feet: black boots
- Weapon: black staff topped with a burning flame, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visible face, no armor, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. OVERHEAD STRIKE: staff raised high above the head with both hands.
3. THRUST: body leaning forward, staff tip pushed far ahead with a short flames and embers spark.
4. FOCUS: eyes closed, staff held vertically in front of the face, flames and embers orb at the top.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Lieutenant: hood up, face in shadow with two glowing orange eyes (#FF8A2A); orange and red layered cultist robes (#E06A1E, #B0201A) with a black belt; long robe to the ankles; black boots. Forbidden: no visible face, no armor, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `lieutenant_walk.png` |
| 1-2 | attaque 1 | `lieutenant_attack.png` |
| 2-1 | attaque 2 | `lieutenant_attack_2.png` |
| 2-2 | sort 1 | `lieutenant_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Lieutenant », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Lieutenant (enemy of the Brasier nation)
- Hair: hood up, face in shadow with two glowing orange eyes (#FF8A2A)
- Top: orange and red layered cultist robes (#E06A1E, #B0201A) with a black belt
- Bottom: long robe to the ankles
- Feet: black boots
- Weapon: black staff topped with a burning flame, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visible face, no armor, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. OVERHEAD STRIKE: staff raised high above the head with both hands.
3. THRUST: body leaning forward, staff tip pushed far ahead with a short flames and embers spark.
4. FOCUS: eyes closed, staff held vertically in front of the face, flames and embers orb at the top.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Lieutenant: hood up, face in shadow with two glowing orange eyes (#FF8A2A); orange and red layered cultist robes (#E06A1E, #B0201A) with a black belt; long robe to the ankles; black boots. Forbidden: no visible face, no armor, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `lieutenant_back_walk.png` |
| 1-2 | attaque 1 | `lieutenant_back_attack.png` |
| 2-1 | attaque 2 | `lieutenant_back_attack_2.png` |
| 2-2 | sort 1 | `lieutenant_back_cast.png` |

### Salamandre — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brasier/` ; nomme tes images `salamandre_<clé>.png` (ex. `salamandre_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Salamandre », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Salamandre (enemy of the Brasier nation)
- Body: orange lava lizard (#E0701E) on four short legs, darker orange back
- Head: round head, big yellow eyes, small smile
- Details: glowing yellow cracks along the back, tail ending in a flame
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no armor, never standing on two legs.
NATION PALETTE: crimson red, black obsidian, ember orange, gold. Signature effects (keep them small): flames and embers.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Salamandre: orange lava lizard (#E0701E) on four short legs, darker orange back; round head, big yellow eyes, small smile; glowing yellow cracks along the back, tail ending in a flame. Forbidden: no wings, no armor, never standing on two legs.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `salamandre.png` |
| 1-2 | repos 1 (dos) | `salamandre_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Salamandre », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Salamandre (enemy of the Brasier nation)
- Body: orange lava lizard (#E0701E) on four short legs, darker orange back
- Head: round head, big yellow eyes, small smile
- Details: glowing yellow cracks along the back, tail ending in a flame
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no armor, never standing on two legs.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. REARING: standing up on the hind legs, front claws raised high.
3. POUNCE: body stretched forward in the air, jaws open.
4. HOWL: head raised to the sky, flames and embers gathering around the body.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Salamandre: orange lava lizard (#E0701E) on four short legs, darker orange back; round head, big yellow eyes, small smile; glowing yellow cracks along the back, tail ending in a flame. Forbidden: no wings, no armor, never standing on two legs.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `salamandre_walk.png` |
| 1-2 | attaque 1 | `salamandre_attack.png` |
| 2-1 | attaque 2 | `salamandre_attack_2.png` |
| 2-2 | sort 1 | `salamandre_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Salamandre », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Salamandre (enemy of the Brasier nation)
- Body: orange lava lizard (#E0701E) on four short legs, darker orange back
- Head: round head, big yellow eyes, small smile
- Details: glowing yellow cracks along the back, tail ending in a flame
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no armor, never standing on two legs.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. REARING: standing up on the hind legs, front claws raised high.
3. POUNCE: body stretched forward in the air, jaws open.
4. HOWL: head raised to the sky, flames and embers gathering around the body.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Salamandre: orange lava lizard (#E0701E) on four short legs, darker orange back; round head, big yellow eyes, small smile; glowing yellow cracks along the back, tail ending in a flame. Forbidden: no wings, no armor, never standing on two legs.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `salamandre_back_walk.png` |
| 1-2 | attaque 1 | `salamandre_back_attack.png` |
| 2-1 | attaque 2 | `salamandre_back_attack_2.png` |
| 2-2 | sort 1 | `salamandre_back_cast.png` |

### Dévoreur de flammes — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brasier/` ; nomme tes images `devoreur_de_flammes_<clé>.png` (ex. `devoreur_de_flammes_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Dévoreur de flammes », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Dévoreur de flammes (enemy of the Brasier nation)
- Body: fiery orange four-legged beast (#E05A1E) with a dark charcoal belly
- Head: big jaw with fangs, glowing yellow eyes, mane of flames
- Details: big black claws, flaming tail tip
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no armor, no rider.
NATION PALETTE: crimson red, black obsidian, ember orange, gold. Signature effects (keep them small): flames and embers.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Dévoreur de flammes: fiery orange four-legged beast (#E05A1E) with a dark charcoal belly; big jaw with fangs, glowing yellow eyes, mane of flames; big black claws, flaming tail tip. Forbidden: no wings, no armor, no rider.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `devoreur_de_flammes.png` |
| 1-2 | repos 1 (dos) | `devoreur_de_flammes_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Dévoreur de flammes », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Dévoreur de flammes (enemy of the Brasier nation)
- Body: fiery orange four-legged beast (#E05A1E) with a dark charcoal belly
- Head: big jaw with fangs, glowing yellow eyes, mane of flames
- Details: big black claws, flaming tail tip
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no armor, no rider.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. REARING: standing up on the hind legs, front claws raised high.
3. POUNCE: body stretched forward in the air, jaws open.
4. HOWL: head raised to the sky, flames and embers gathering around the body.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Dévoreur de flammes: fiery orange four-legged beast (#E05A1E) with a dark charcoal belly; big jaw with fangs, glowing yellow eyes, mane of flames; big black claws, flaming tail tip. Forbidden: no wings, no armor, no rider.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `devoreur_de_flammes_walk.png` |
| 1-2 | attaque 1 | `devoreur_de_flammes_attack.png` |
| 2-1 | attaque 2 | `devoreur_de_flammes_attack_2.png` |
| 2-2 | sort 1 | `devoreur_de_flammes_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Dévoreur de flammes », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Dévoreur de flammes (enemy of the Brasier nation)
- Body: fiery orange four-legged beast (#E05A1E) with a dark charcoal belly
- Head: big jaw with fangs, glowing yellow eyes, mane of flames
- Details: big black claws, flaming tail tip
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no armor, no rider.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. REARING: standing up on the hind legs, front claws raised high.
3. POUNCE: body stretched forward in the air, jaws open.
4. HOWL: head raised to the sky, flames and embers gathering around the body.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Dévoreur de flammes: fiery orange four-legged beast (#E05A1E) with a dark charcoal belly; big jaw with fangs, glowing yellow eyes, mane of flames; big black claws, flaming tail tip. Forbidden: no wings, no armor, no rider.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `devoreur_de_flammes_back_walk.png` |
| 1-2 | attaque 1 | `devoreur_de_flammes_back_attack.png` |
| 2-1 | attaque 2 | `devoreur_de_flammes_back_attack_2.png` |
| 2-2 | sort 1 | `devoreur_de_flammes_back_cast.png` |

### Golem de lave — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brasier/` ; nomme tes images `golem_de_lave_<clé>.png` (ex. `golem_de_lave_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Golem de lave », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Golem de lave (enemy of the Brasier nation)
- Body: dark basalt golem (#2A2426) with bright orange lava cracks (#FF7A1E)
- Head: small head with two glowing orange eyes
- Details: molten glowing core in the chest, huge rock fists
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no crystals, no moss.
NATION PALETTE: crimson red, black obsidian, ember orange, gold. Signature effects (keep them small): flames and embers.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Golem de lave: dark basalt golem (#2A2426) with bright orange lava cracks (#FF7A1E); small head with two glowing orange eyes; molten glowing core in the chest, huge rock fists. Forbidden: no weapon, no crystals, no moss.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `golem_de_lave.png` |
| 1-2 | repos 1 (dos) | `golem_de_lave_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Golem de lave », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Golem de lave (enemy of the Brasier nation)
- Body: dark basalt golem (#2A2426) with bright orange lava cracks (#FF7A1E)
- Head: small head with two glowing orange eyes
- Details: molten glowing core in the chest, huge rock fists
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no crystals, no moss.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. OVERHEAD SMASH: both fists or weapon raised high above the head.
3. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward.
4. ROOTED: stomping, flames and embers cracks spreading under the feet.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Golem de lave: dark basalt golem (#2A2426) with bright orange lava cracks (#FF7A1E); small head with two glowing orange eyes; molten glowing core in the chest, huge rock fists. Forbidden: no weapon, no crystals, no moss.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `golem_de_lave_walk.png` |
| 1-2 | attaque 1 | `golem_de_lave_attack.png` |
| 2-1 | attaque 2 | `golem_de_lave_attack_2.png` |
| 2-2 | sort 1 | `golem_de_lave_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Golem de lave », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Golem de lave (enemy of the Brasier nation)
- Body: dark basalt golem (#2A2426) with bright orange lava cracks (#FF7A1E)
- Head: small head with two glowing orange eyes
- Details: molten glowing core in the chest, huge rock fists
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no crystals, no moss.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. OVERHEAD SMASH: both fists or weapon raised high above the head.
3. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward.
4. ROOTED: stomping, flames and embers cracks spreading under the feet.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Golem de lave: dark basalt golem (#2A2426) with bright orange lava cracks (#FF7A1E); small head with two glowing orange eyes; molten glowing core in the chest, huge rock fists. Forbidden: no weapon, no crystals, no moss.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `golem_de_lave_back_walk.png` |
| 1-2 | attaque 1 | `golem_de_lave_back_attack.png` |
| 2-1 | attaque 2 | `golem_de_lave_back_attack_2.png` |
| 2-2 | sort 1 | `golem_de_lave_back_cast.png` |

## 4. Boss

### Kharaz le Flamboyant — 22 poses

6 planches, 22 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `brasier_<clé>.png` (ex. `brasier_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Kharaz le Flamboyant », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Kharaz le Flamboyant (boss of the Brasier nation)
- Body: flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks
- Head: burning orange hair like flames, golden eyes
- Weapon: great curved flame bow, LEFT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword.
NATION PALETTE: crimson red, black obsidian, ember orange, gold. Signature effects (keep them small): flames and embers.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Kharaz le Flamboyant: flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks; burning orange hair like flames, golden eyes; great curved flame bow, LEFT hand. Forbidden: no helmet, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `brasier.png` |
| 1-2 | repos 1 (dos) | `brasier_back.png` |

#### Planche 2 — Face 1 · garde, marche, sort (`face_1`)

Dans l'Atelier : personnage « Kharaz le Flamboyant », planche « Face 1 · garde, marche, sort ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Kharaz le Flamboyant (boss of the Brasier nation)
- Body: flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks
- Head: burning orange hair like flames, golden eyes
- Weapon: great curved flame bow, LEFT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. GUARD: knees bent, weapon raised in front of the body, ready to fight.
2. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
3. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
4. ENCHANTED ARROW: arrow held up to the face, its tip wrapped in flames and embers.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Kharaz le Flamboyant: flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks; burning orange hair like flames, golden eyes; great curved flame bow, LEFT hand. Forbidden: no helmet, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 2 | `brasier_idle_2.png` |
| 1-2 | marche 1 | `brasier_walk.png` |
| 2-1 | marche 2 | `brasier_walk_2.png` |
| 2-2 | sort 1 | `brasier_cast.png` |

#### Planche 3 — Face 2 · attaques 1 à 4 (`face_2`)

Dans l'Atelier : personnage « Kharaz le Flamboyant », planche « Face 2 · attaques 1 à 4 ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Kharaz le Flamboyant (boss of the Brasier nation)
- Body: flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks
- Head: burning orange hair like flames, golden eyes
- Weapon: great curved flame bow, LEFT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. SKY SHOT: bow pointed almost straight up, string fully drawn.
2. FULL DRAW: bow aimed straight forward, string pulled to the cheek, body sideways.
3. RELEASE: string hand open behind, bow arm extended, arrow leaving with a flames and embers trail.
4. JUMPING SHOT: whole body in the air, aiming down and forward.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Kharaz le Flamboyant: flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks; burning orange hair like flames, golden eyes; great curved flame bow, LEFT hand. Forbidden: no helmet, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `brasier_attack.png` |
| 1-2 | attaque 2 | `brasier_attack_2.png` |
| 2-1 | attaque 3 | `brasier_attack_3.png` |
| 2-2 | attaque 4 | `brasier_attack_4.png` |

#### Planche 4 — Face 3 · attaques 5-6, sorts 2-3 (`face_3`)

Dans l'Atelier : personnage « Kharaz le Flamboyant », planche « Face 3 · attaques 5-6, sorts 2-3 ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Kharaz le Flamboyant (boss of the Brasier nation)
- Body: flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks
- Head: burning orange hair like flames, golden eyes
- Weapon: great curved flame bow, LEFT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. KNEELING SHOT: on one knee, bow held low and tilted.
2. POINT-BLANK KICK: bow held back, one leg kicking high forward.
3. VOLLEY: bow raised overhead, three flames and embers arrows rising into the air.
4. TRAP: crouched, placing a flames and embers trap on the ground with the free hand.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Kharaz le Flamboyant: flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks; burning orange hair like flames, golden eyes; great curved flame bow, LEFT hand. Forbidden: no helmet, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 5 | `brasier_attack_5.png` |
| 1-2 | attaque 6 | `brasier_attack_6.png` |
| 2-1 | sort 2 | `brasier_cast_2.png` |
| 2-2 | sort 3 | `brasier_cast_3.png` |

#### Planche 5 — Dos 1 · marche, attaque, sort (`dos_1`)

Dans l'Atelier : personnage « Kharaz le Flamboyant », planche « Dos 1 · marche, attaque, sort ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Kharaz le Flamboyant (boss of the Brasier nation)
- Body: flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks
- Head: burning orange hair like flames, golden eyes
- Weapon: great curved flame bow, LEFT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
3. SKY SHOT: bow pointed almost straight up, string fully drawn.
4. ENCHANTED ARROW: arrow held up to the face, its tip wrapped in flames and embers.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Kharaz le Flamboyant: flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks; burning orange hair like flames, golden eyes; great curved flame bow, LEFT hand. Forbidden: no helmet, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `brasier_back_walk.png` |
| 1-2 | marche 2 | `brasier_back_walk_2.png` |
| 2-1 | attaque 1 | `brasier_back_attack.png` |
| 2-2 | sort 1 | `brasier_back_cast.png` |

#### Planche 6 — Dos 2 · attaques 2 à 4, garde (`dos_2`)

Dans l'Atelier : personnage « Kharaz le Flamboyant », planche « Dos 2 · attaques 2 à 4, garde ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Kharaz le Flamboyant (boss of the Brasier nation)
- Body: flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks
- Head: burning orange hair like flames, golden eyes
- Weapon: great curved flame bow, LEFT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. FULL DRAW: bow aimed straight forward, string pulled to the cheek, body sideways.
2. RELEASE: string hand open behind, bow arm extended, arrow leaving with a flames and embers trail.
3. JUMPING SHOT: whole body in the air, aiming down and forward.
4. GUARD: knees bent, weapon raised in front of the body, ready to fight.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Kharaz le Flamboyant: flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks; burning orange hair like flames, golden eyes; great curved flame bow, LEFT hand. Forbidden: no helmet, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 2 | `brasier_back_attack_2.png` |
| 1-2 | attaque 3 | `brasier_back_attack_3.png` |
| 2-1 | attaque 4 | `brasier_back_attack_4.png` |
| 2-2 | repos 2 | `brasier_back_idle_2.png` |

## Prompt négatif (toutes les planches de cette page)

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses, identical poses, repeated pose, copy of the same pose, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, front and back views mixed, different character between poses, realistic proportions, small head
```
