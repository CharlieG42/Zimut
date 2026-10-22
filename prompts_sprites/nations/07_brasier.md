# Nation Brasier (Brasier)

Palette : crimson red, black obsidian, ember orange, gold. Effets : flames and embers. Contre-jour : orange ember.

Format 2 planches par personnage :

1. **Vues** — le personnage au repos vu sous 6 angles (face, 3/4 avant droite, 3/4 dos droite, dos, 3/4 dos gauche, 3/4 avant gauche), grille 3 × 2 sur image 2:1, poses largement espacées. Un seul angle par case : aucun doublon possible.
2. **Actions** — 3 attaques + 3 sorts en vue 3/4 avant, générées **en édition** de la planche vues (image source = planche vues) : le personnage réellement dessiné sert d'ancre, il ne peut pas changer d'une planche à l'autre. Repli : génération normale (la carte d'identité est recopiée dans chaque prompt).

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
2. Lieutenant (fire cultist lieutenant in orange and red robes holding a flaming staff).
3. Salamandre (orange lava lizard with glowing cracks on its back and a flaming tail).
4. Dévoreur de flammes (fiery orange beast with a mane of flames and big claws).
5. Golem de lave (dark basalt golem with bright orange lava cracks and a molten core).
6. the final boss Kharaz le Flamboyant (flame warlord with burning hair, black and crimson ember armor with sharp plates, holding a great curved flame bow), about 1.5x taller than the others.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Chasseur — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `chasseur_vues.png` et `chasseur_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
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
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Chasseur: long bright red hair (#D6332A) in a high ponytail; golden eyes, always open; fair skin; red and black armor with flame-shaped plates (#C8281E, #1E1A1C) and glowing ember cracks, red scarf. Forbidden: no helmet, no sword, no brown hair.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `chasseur.png` |
| 1-2 | 3/4 avant droite | `chasseur_face_right.png` |
| 1-3 | 3/4 dos droite | `chasseur_back_right.png` |
| 2-1 | dos complet | `chasseur_back.png` |
| 2-2 | 3/4 dos gauche | `chasseur_back_left.png` |
| 2-3 | 3/4 avant gauche | `chasseur_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE playable hero, Chasseur, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
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
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. SKY SHOT: bow pointed almost straight up, string fully drawn.
2. FULL DRAW: bow aimed straight forward, string pulled to the cheek, body sideways.
3. RELEASE: string hand open behind, bow arm extended, arrow leaving with a flames and embers trail.
4. ENCHANTED ARROW: arrow held up to the face, its tip wrapped in flames and embers.
5. VOLLEY: bow raised overhead, three flames and embers arrows rising into the air.
6. TRAP: crouched, placing a flames and embers trap on the ground with the free hand.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Chasseur: long bright red hair (#D6332A) in a high ponytail; golden eyes, always open; fair skin; red and black armor with flame-shaped plates (#C8281E, #1E1A1C) and glowing ember cracks, red scarf. Forbidden: no helmet, no sword, no brown hair.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `chasseur_attack.png` |
| 1-2 | attaque 2 | `chasseur_attack_2.png` |
| 1-3 | attaque 3 | `chasseur_attack_3.png` |
| 2-1 | sort 1 | `chasseur_cast.png` |
| 2-2 | sort 2 | `chasseur_cast_2.png` |
| 2-3 | sort 3 | `chasseur_cast_3.png` |

L'export Zimut de l'Atelier copie aussi le repos (case 1 de la planche vues) vers `nations/heros/chasseur.png`.

## 3. Ennemis

### Lieutenant — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brasier/` ; nomme tes images `lieutenant_vues.png` et `lieutenant_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Lieutenant (enemy of the Brasier nation)
- Hair: hood up, face in shadow with two glowing orange eyes (#FF8A2A)
- Top: orange and red layered cultist robes (#E06A1E, #B0201A) with a black belt
- Bottom: long robe to the ankles
- Feet: black boots
- Weapon: black staff topped with a burning flame, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visible face, no armor, no sword.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Lieutenant: hood up, face in shadow with two glowing orange eyes (#FF8A2A); orange and red layered cultist robes (#E06A1E, #B0201A) with a black belt; long robe to the ankles; black boots. Forbidden: no visible face, no armor, no sword.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `lieutenant.png` |
| 1-2 | 3/4 avant droite | `lieutenant_face_right.png` |
| 1-3 | 3/4 dos droite | `lieutenant_back_right.png` |
| 2-1 | dos complet | `lieutenant_back.png` |
| 2-2 | 3/4 dos gauche | `lieutenant_back_left.png` |
| 2-3 | 3/4 avant gauche | `lieutenant_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Lieutenant, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Lieutenant (enemy of the Brasier nation)
- Hair: hood up, face in shadow with two glowing orange eyes (#FF8A2A)
- Top: orange and red layered cultist robes (#E06A1E, #B0201A) with a black belt
- Bottom: long robe to the ankles
- Feet: black boots
- Weapon: black staff topped with a burning flame, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visible face, no armor, no sword.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short flames and embers spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. FOCUS: eyes closed, staff held vertically in front of the face, flames and embers orb at the top.
5. INVOCATION: staff raised high with both hands, flames and embers swirling above the head.
6. BLAST: staff pointed forward, a compact flames and embers blast leaving the tip.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Lieutenant: hood up, face in shadow with two glowing orange eyes (#FF8A2A); orange and red layered cultist robes (#E06A1E, #B0201A) with a black belt; long robe to the ankles; black boots. Forbidden: no visible face, no armor, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `lieutenant_attack.png` |
| 1-2 | attaque 2 | `lieutenant_attack_2.png` |
| 1-3 | attaque 3 | `lieutenant_attack_3.png` |
| 2-1 | sort 1 | `lieutenant_cast.png` |
| 2-2 | sort 2 | `lieutenant_cast_2.png` |
| 2-3 | sort 3 | `lieutenant_cast_3.png` |

### Salamandre — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brasier/` ; nomme tes images `salamandre_vues.png` et `salamandre_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Salamandre (enemy of the Brasier nation)
- Body: orange lava lizard (#E0701E) on four short legs, darker orange back
- Head: round head, big yellow eyes, small smile
- Details: glowing yellow cracks along the back, tail ending in a flame
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no armor, never standing on two legs.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Salamandre: orange lava lizard (#E0701E) on four short legs, darker orange back; round head, big yellow eyes, small smile; glowing yellow cracks along the back, tail ending in a flame. Forbidden: no wings, no armor, never standing on two legs.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `salamandre.png` |
| 1-2 | 3/4 avant droite | `salamandre_face_right.png` |
| 1-3 | 3/4 dos droite | `salamandre_back_right.png` |
| 2-1 | dos complet | `salamandre_back.png` |
| 2-2 | 3/4 dos gauche | `salamandre_back_left.png` |
| 2-3 | 3/4 avant gauche | `salamandre_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Salamandre, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Salamandre (enemy of the Brasier nation)
- Body: orange lava lizard (#E0701E) on four short legs, darker orange back
- Head: round head, big yellow eyes, small smile
- Details: glowing yellow cracks along the back, tail ending in a flame
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no armor, never standing on two legs.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. POUNCE: body stretched forward in the air, jaws open.
3. SIDE SWIPE: head and claws swept to the side, body twisted.
4. HOWL: head raised to the sky, flames and embers gathering around the body.
5. ROAR: mouth wide open, flames and embers burst in front of the head.
6. BREATH: a short flames and embers breath released forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Salamandre: orange lava lizard (#E0701E) on four short legs, darker orange back; round head, big yellow eyes, small smile; glowing yellow cracks along the back, tail ending in a flame. Forbidden: no wings, no armor, never standing on two legs.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `salamandre_attack.png` |
| 1-2 | attaque 2 | `salamandre_attack_2.png` |
| 1-3 | attaque 3 | `salamandre_attack_3.png` |
| 2-1 | sort 1 | `salamandre_cast.png` |
| 2-2 | sort 2 | `salamandre_cast_2.png` |
| 2-3 | sort 3 | `salamandre_cast_3.png` |

### Dévoreur de flammes — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brasier/` ; nomme tes images `devoreur_de_flammes_vues.png` et `devoreur_de_flammes_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Dévoreur de flammes (enemy of the Brasier nation)
- Body: fiery orange four-legged beast (#E05A1E) with a dark charcoal belly
- Head: big jaw with fangs, glowing yellow eyes, mane of flames
- Details: big black claws, flaming tail tip
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no armor, no rider.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Dévoreur de flammes: fiery orange four-legged beast (#E05A1E) with a dark charcoal belly; big jaw with fangs, glowing yellow eyes, mane of flames; big black claws, flaming tail tip. Forbidden: no wings, no armor, no rider.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `devoreur_de_flammes.png` |
| 1-2 | 3/4 avant droite | `devoreur_de_flammes_face_right.png` |
| 1-3 | 3/4 dos droite | `devoreur_de_flammes_back_right.png` |
| 2-1 | dos complet | `devoreur_de_flammes_back.png` |
| 2-2 | 3/4 dos gauche | `devoreur_de_flammes_back_left.png` |
| 2-3 | 3/4 avant gauche | `devoreur_de_flammes_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Dévoreur de flammes, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Dévoreur de flammes (enemy of the Brasier nation)
- Body: fiery orange four-legged beast (#E05A1E) with a dark charcoal belly
- Head: big jaw with fangs, glowing yellow eyes, mane of flames
- Details: big black claws, flaming tail tip
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no armor, no rider.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. POUNCE: body stretched forward in the air, jaws open.
3. SIDE SWIPE: head and claws swept to the side, body twisted.
4. HOWL: head raised to the sky, flames and embers gathering around the body.
5. ROAR: mouth wide open, flames and embers burst in front of the head.
6. BREATH: a short flames and embers breath released forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Dévoreur de flammes: fiery orange four-legged beast (#E05A1E) with a dark charcoal belly; big jaw with fangs, glowing yellow eyes, mane of flames; big black claws, flaming tail tip. Forbidden: no wings, no armor, no rider.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `devoreur_de_flammes_attack.png` |
| 1-2 | attaque 2 | `devoreur_de_flammes_attack_2.png` |
| 1-3 | attaque 3 | `devoreur_de_flammes_attack_3.png` |
| 2-1 | sort 1 | `devoreur_de_flammes_cast.png` |
| 2-2 | sort 2 | `devoreur_de_flammes_cast_2.png` |
| 2-3 | sort 3 | `devoreur_de_flammes_cast_3.png` |

### Golem de lave — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brasier/` ; nomme tes images `golem_de_lave_vues.png` et `golem_de_lave_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Golem de lave (enemy of the Brasier nation)
- Body: dark basalt golem (#2A2426) with bright orange lava cracks (#FF7A1E)
- Head: small head with two glowing orange eyes
- Details: molten glowing core in the chest, huge rock fists
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no crystals, no moss.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Golem de lave: dark basalt golem (#2A2426) with bright orange lava cracks (#FF7A1E); small head with two glowing orange eyes; molten glowing core in the chest, huge rock fists. Forbidden: no weapon, no crystals, no moss.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `golem_de_lave.png` |
| 1-2 | 3/4 avant droite | `golem_de_lave_face_right.png` |
| 1-3 | 3/4 dos droite | `golem_de_lave_back_right.png` |
| 2-1 | dos complet | `golem_de_lave_back.png` |
| 2-2 | 3/4 dos gauche | `golem_de_lave_back_left.png` |
| 2-3 | 3/4 avant gauche | `golem_de_lave_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Golem de lave, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Golem de lave (enemy of the Brasier nation)
- Body: dark basalt golem (#2A2426) with bright orange lava cracks (#FF7A1E)
- Head: small head with two glowing orange eyes
- Details: molten glowing core in the chest, huge rock fists
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no crystals, no moss.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted.
4. ROOTED: stomping, flames and embers cracks spreading under the feet.
5. GATHER: arms raised, flames and embers gathering between the hands.
6. SHOCKWAVE: both fists slammed into the ground, flames and embers wave.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Golem de lave: dark basalt golem (#2A2426) with bright orange lava cracks (#FF7A1E); small head with two glowing orange eyes; molten glowing core in the chest, huge rock fists. Forbidden: no weapon, no crystals, no moss.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `golem_de_lave_attack.png` |
| 1-2 | attaque 2 | `golem_de_lave_attack_2.png` |
| 1-3 | attaque 3 | `golem_de_lave_attack_3.png` |
| 2-1 | sort 1 | `golem_de_lave_cast.png` |
| 2-2 | sort 2 | `golem_de_lave_cast_2.png` |
| 2-3 | sort 3 | `golem_de_lave_cast_3.png` |

## 4. Boss

### Kharaz le Flamboyant — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `brasier_vues.png` et `brasier_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Kharaz le Flamboyant (boss of the Brasier nation)
- Body: flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks
- Head: burning orange hair like flames, golden eyes
- Weapon: great curved flame bow, LEFT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Kharaz le Flamboyant: flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks; burning orange hair like flames, golden eyes; great curved flame bow, LEFT hand. Forbidden: no helmet, no sword.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `brasier.png` |
| 1-2 | 3/4 avant droite | `brasier_face_right.png` |
| 1-3 | 3/4 dos droite | `brasier_back_right.png` |
| 2-1 | dos complet | `brasier_back.png` |
| 2-2 | 3/4 dos gauche | `brasier_back_left.png` |
| 2-3 | 3/4 avant gauche | `brasier_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE final boss, Kharaz le Flamboyant, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Kharaz le Flamboyant (boss of the Brasier nation)
- Body: flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks
- Head: burning orange hair like flames, golden eyes
- Weapon: great curved flame bow, LEFT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. SKY SHOT: bow pointed almost straight up, string fully drawn.
2. FULL DRAW: bow aimed straight forward, string pulled to the cheek, body sideways.
3. RELEASE: string hand open behind, bow arm extended, arrow leaving with a flames and embers trail.
4. ENCHANTED ARROW: arrow held up to the face, its tip wrapped in flames and embers.
5. VOLLEY: bow raised overhead, three flames and embers arrows rising into the air.
6. TRAP: crouched, placing a flames and embers trap on the ground with the free hand.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Kharaz le Flamboyant: flame warlord in black and crimson ember armor (#1E1418, #B0201A) with sharp plates and glowing cracks; burning orange hair like flames, golden eyes; great curved flame bow, LEFT hand. Forbidden: no helmet, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `brasier_attack.png` |
| 1-2 | attaque 2 | `brasier_attack_2.png` |
| 1-3 | attaque 3 | `brasier_attack_3.png` |
| 2-1 | sort 1 | `brasier_cast.png` |
| 2-2 | sort 2 | `brasier_cast_2.png` |
| 2-3 | sort 3 | `brasier_cast_3.png` |

## Prompt négatif

**Planches vues** (la même pose vue sous 6 angles est voulue, les vues vers la gauche aussi — le négatif commun est adapté) :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, different character between cells, pose changing between cells, different outfit between angles, realistic proportions, small head
```

**Planches actions et planche de style** :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses, identical poses, repeated pose, copy of the same pose, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, front and back views mixed, different character between poses, realistic proportions, small head
```
