# Nation Brumes (Brumes)

Palette : black, deep violet, mist mint green, silver. Effets : mint mist and violet spectral wisps. Contre-jour : pale mint.

Format 2 planches par personnage :

1. **Vues** — le personnage au repos vu sous 6 angles (face, 3/4 avant droite, 3/4 dos droite, dos, 3/4 dos gauche, 3/4 avant gauche), grille 3 × 2 sur image 2:1, poses largement espacées. Un seul angle par case : aucun doublon possible.
2. **Actions** — 3 attaques + 3 sorts en vue 3/4 avant, générées **en édition** de la planche vues (image source = planche vues) : le personnage réellement dessiné sert d'ancre, il ne peut pas changer d'une planche à l'autre. Repli : génération normale (la carte d'identité est recopiée dans chaque prompt).

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

### Invocateur — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `invocateur_vues.png` et `invocateur_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
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
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Invocateur: black hair (#15151C), medium length, messy bangs; violet eyes (#9B6BFF), always open; pale skin; long black coat with violet trims (#7A3FD0) and silver clasps. Forbidden: no hood, no mask, no white hair.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `invocateur.png` |
| 1-2 | 3/4 avant droite | `invocateur_face_right.png` |
| 1-3 | 3/4 dos droite | `invocateur_back_right.png` |
| 2-1 | dos complet | `invocateur_back.png` |
| 2-2 | 3/4 dos gauche | `invocateur_back_left.png` |
| 2-3 | 3/4 avant gauche | `invocateur_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE playable hero, Invocateur, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
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
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head, grimoire floating behind.
2. PALM BOLT: free arm stretched forward, a mint mist and violet spectral wisps bolt leaving the open palm.
3. SIDE SWING: staff swept horizontally, coat swirling.
4. READING: grimoire floating open in front, pages turning, mint mist and violet spectral wisps rising from it.
5. SUMMONING CIRCLE: staff raised, a mint mist and violet spectral wisps circle drawn on the ground.
6. SUMMON: both arms open wide, a mint mist and violet spectral wisps creature silhouette emerging beside.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Invocateur: black hair (#15151C), medium length, messy bangs; violet eyes (#9B6BFF), always open; pale skin; long black coat with violet trims (#7A3FD0) and silver clasps. Forbidden: no hood, no mask, no white hair.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `invocateur_attack.png` |
| 1-2 | attaque 2 | `invocateur_attack_2.png` |
| 1-3 | attaque 3 | `invocateur_attack_3.png` |
| 2-1 | sort 1 | `invocateur_cast.png` |
| 2-2 | sort 2 | `invocateur_cast_2.png` |
| 2-3 | sort 3 | `invocateur_cast_3.png` |

L'export Zimut de l'Atelier copie aussi le repos (case 1 de la planche vues) vers `nations/heros/invocateur.png`.

## 3. Ennemis

### Brumeux — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brumes/` ; nomme tes images `brumeux_vues.png` et `brumeux_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Brumeux (enemy of the Brumes nation)
- Body: hulking mist beast with a fluffy lavender cloud body (#B8A8E0)
- Head: no visible neck, two small glowing mint eyes (#9FFFD8)
- Details: two thick cloud arms with small dark claws, no legs visible
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no clothes, no teeth.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Brumeux: hulking mist beast with a fluffy lavender cloud body (#B8A8E0); no visible neck, two small glowing mint eyes (#9FFFD8); two thick cloud arms with small dark claws, no legs visible. Forbidden: no weapon, no clothes, no teeth.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `brumeux.png` |
| 1-2 | 3/4 avant droite | `brumeux_face_right.png` |
| 1-3 | 3/4 dos droite | `brumeux_back_right.png` |
| 2-1 | dos complet | `brumeux_back.png` |
| 2-2 | 3/4 dos gauche | `brumeux_back_left.png` |
| 2-3 | 3/4 avant gauche | `brumeux_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Brumeux, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Brumeux (enemy of the Brumes nation)
- Body: hulking mist beast with a fluffy lavender cloud body (#B8A8E0)
- Head: no visible neck, two small glowing mint eyes (#9FFFD8)
- Details: two thick cloud arms with small dark claws, no legs visible
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no clothes, no teeth.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. LUNGE: body stretched forward, claws of mint mist and violet spectral wisps reaching out.
3. SPIN: body whirling, mint mist and violet spectral wisps trail around it.
4. HOVER: floating higher, mint mist and violet spectral wisps orbs circling.
5. PULSE: arms spread, mint mist and violet spectral wisps pulsing outward.
6. WAVE: a compact mint mist and violet spectral wisps wave released forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Brumeux: hulking mist beast with a fluffy lavender cloud body (#B8A8E0); no visible neck, two small glowing mint eyes (#9FFFD8); two thick cloud arms with small dark claws, no legs visible. Forbidden: no weapon, no clothes, no teeth.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `brumeux_attack.png` |
| 1-2 | attaque 2 | `brumeux_attack_2.png` |
| 1-3 | attaque 3 | `brumeux_attack_3.png` |
| 2-1 | sort 1 | `brumeux_cast.png` |
| 2-2 | sort 2 | `brumeux_cast_2.png` |
| 2-3 | sort 3 | `brumeux_cast_3.png` |

### Gargouille — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brumes/` ; nomme tes images `gargouille_vues.png` et `gargouille_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Gargouille (enemy of the Brumes nation)
- Body: grey stone gargoyle (#7A7A82) crouching on two legs, cracked stone texture
- Head: small horns, pointed ears, fanged mouth, glowing mint eyes (#9FFFD8)
- Details: stone bat wings, long tail with an arrow tip
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no color other than grey stone and mint eyes.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Gargouille: grey stone gargoyle (#7A7A82) crouching on two legs, cracked stone texture; small horns, pointed ears, fanged mouth, glowing mint eyes (#9FFFD8); stone bat wings, long tail with an arrow tip. Forbidden: no weapon, no color other than grey stone and mint eyes.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `gargouille.png` |
| 1-2 | 3/4 avant droite | `gargouille_face_right.png` |
| 1-3 | 3/4 dos droite | `gargouille_back_right.png` |
| 2-1 | dos complet | `gargouille_back.png` |
| 2-2 | 3/4 dos gauche | `gargouille_back_left.png` |
| 2-3 | 3/4 avant gauche | `gargouille_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Gargouille, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Gargouille (enemy of the Brumes nation)
- Body: grey stone gargoyle (#7A7A82) crouching on two legs, cracked stone texture
- Head: small horns, pointed ears, fanged mouth, glowing mint eyes (#9FFFD8)
- Details: stone bat wings, long tail with an arrow tip
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no color other than grey stone and mint eyes.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. POUNCE: body stretched forward in the air, jaws open.
3. SIDE SWIPE: head and claws swept to the side, body twisted.
4. HOWL: head raised to the sky, mint mist and violet spectral wisps gathering around the body.
5. ROAR: mouth wide open, mint mist and violet spectral wisps burst in front of the head.
6. BREATH: a short mint mist and violet spectral wisps breath released forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Gargouille: grey stone gargoyle (#7A7A82) crouching on two legs, cracked stone texture; small horns, pointed ears, fanged mouth, glowing mint eyes (#9FFFD8); stone bat wings, long tail with an arrow tip. Forbidden: no weapon, no color other than grey stone and mint eyes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `gargouille_attack.png` |
| 1-2 | attaque 2 | `gargouille_attack_2.png` |
| 1-3 | attaque 3 | `gargouille_attack_3.png` |
| 2-1 | sort 1 | `gargouille_cast.png` |
| 2-2 | sort 2 | `gargouille_cast_2.png` |
| 2-3 | sort 3 | `gargouille_cast_3.png` |

### Liche des brumes — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brumes/` ; nomme tes images `liche_des_brumes_vues.png` et `liche_des_brumes_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Liche des brumes (enemy of the Brumes nation)
- Body: thin skeletal lich, bony grey hands
- Head: skull face with glowing mint eyes (#9FFFD8) under a tattered hood
- Top: tattered violet robes (#6A4A9A) with torn edges
- Weapon: crooked wooden staff, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no crown, no armor, no hair.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Liche des brumes: thin skeletal lich, bony grey hands; skull face with glowing mint eyes (#9FFFD8) under a tattered hood; tattered violet robes (#6A4A9A) with torn edges; crooked wooden staff, RIGHT hand. Forbidden: no crown, no armor, no hair.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `liche_des_brumes.png` |
| 1-2 | 3/4 avant droite | `liche_des_brumes_face_right.png` |
| 1-3 | 3/4 dos droite | `liche_des_brumes_back_right.png` |
| 2-1 | dos complet | `liche_des_brumes_back.png` |
| 2-2 | 3/4 dos gauche | `liche_des_brumes_back_left.png` |
| 2-3 | 3/4 avant gauche | `liche_des_brumes_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Liche des brumes, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Liche des brumes (enemy of the Brumes nation)
- Body: thin skeletal lich, bony grey hands
- Head: skull face with glowing mint eyes (#9FFFD8) under a tattered hood
- Top: tattered violet robes (#6A4A9A) with torn edges
- Weapon: crooked wooden staff, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no crown, no armor, no hair.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short mint mist and violet spectral wisps spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. FOCUS: eyes closed, staff held vertically in front of the face, mint mist and violet spectral wisps orb at the top.
5. INVOCATION: staff raised high with both hands, mint mist and violet spectral wisps swirling above the head.
6. BLAST: staff pointed forward, a compact mint mist and violet spectral wisps blast leaving the tip.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Liche des brumes: thin skeletal lich, bony grey hands; skull face with glowing mint eyes (#9FFFD8) under a tattered hood; tattered violet robes (#6A4A9A) with torn edges; crooked wooden staff, RIGHT hand. Forbidden: no crown, no armor, no hair.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `liche_des_brumes_attack.png` |
| 1-2 | attaque 2 | `liche_des_brumes_attack_2.png` |
| 1-3 | attaque 3 | `liche_des_brumes_attack_3.png` |
| 2-1 | sort 1 | `liche_des_brumes_cast.png` |
| 2-2 | sort 2 | `liche_des_brumes_cast_2.png` |
| 2-3 | sort 3 | `liche_des_brumes_cast_3.png` |

### Fantôme — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/brumes/` ; nomme tes images `fantome_vues.png` et `fantome_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Fantôme (enemy of the Brumes nation)
- Body: pale blue ghost (#BFE3FF) with a round head-body and a wavy tail, no legs
- Head: mischievous face: big dark eyes, tongue out
- Details: two small rounded arms
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no sheet with holes, no chains, no weapon.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Fantôme: pale blue ghost (#BFE3FF) with a round head-body and a wavy tail, no legs; mischievous face: big dark eyes, tongue out; two small rounded arms. Forbidden: no sheet with holes, no chains, no weapon.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `fantome.png` |
| 1-2 | 3/4 avant droite | `fantome_face_right.png` |
| 1-3 | 3/4 dos droite | `fantome_back_right.png` |
| 2-1 | dos complet | `fantome_back.png` |
| 2-2 | 3/4 dos gauche | `fantome_back_left.png` |
| 2-3 | 3/4 avant gauche | `fantome_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Fantôme, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Fantôme (enemy of the Brumes nation)
- Body: pale blue ghost (#BFE3FF) with a round head-body and a wavy tail, no legs
- Head: mischievous face: big dark eyes, tongue out
- Details: two small rounded arms
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no sheet with holes, no chains, no weapon.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. LUNGE: body stretched forward, claws of mint mist and violet spectral wisps reaching out.
3. SPIN: body whirling, mint mist and violet spectral wisps trail around it.
4. HOVER: floating higher, mint mist and violet spectral wisps orbs circling.
5. PULSE: arms spread, mint mist and violet spectral wisps pulsing outward.
6. WAVE: a compact mint mist and violet spectral wisps wave released forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Fantôme: pale blue ghost (#BFE3FF) with a round head-body and a wavy tail, no legs; mischievous face: big dark eyes, tongue out; two small rounded arms. Forbidden: no sheet with holes, no chains, no weapon.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `fantome_attack.png` |
| 1-2 | attaque 2 | `fantome_attack_2.png` |
| 1-3 | attaque 3 | `fantome_attack_3.png` |
| 2-1 | sort 1 | `fantome_cast.png` |
| 2-2 | sort 2 | `fantome_cast_2.png` |
| 2-3 | sort 3 | `fantome_cast_3.png` |

## 4. Boss

### Ombrelis le Brumeux — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `brumes_vues.png` et `brumes_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombrelis le Brumeux (boss of the Brumes nation)
- Body: dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A)
- Head: spiked crown, gaunt pale face, glowing mint eyes
- Weapon: skull-topped staff surrounded by mint mist, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no sword.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Ombrelis le Brumeux: dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A); spiked crown, gaunt pale face, glowing mint eyes; skull-topped staff surrounded by mint mist, RIGHT hand. Forbidden: no hood, no sword.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `brumes.png` |
| 1-2 | 3/4 avant droite | `brumes_face_right.png` |
| 1-3 | 3/4 dos droite | `brumes_back_right.png` |
| 2-1 | dos complet | `brumes_back.png` |
| 2-2 | 3/4 dos gauche | `brumes_back_left.png` |
| 2-3 | 3/4 avant gauche | `brumes_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE final boss, Ombrelis le Brumeux, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Ombrelis le Brumeux (boss of the Brumes nation)
- Body: dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A)
- Head: spiked crown, gaunt pale face, glowing mint eyes
- Weapon: skull-topped staff surrounded by mint mist, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no sword.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head, grimoire floating behind.
2. PALM BOLT: free arm stretched forward, a mint mist and violet spectral wisps bolt leaving the open palm.
3. SIDE SWING: staff swept horizontally, coat swirling.
4. READING: grimoire floating open in front, pages turning, mint mist and violet spectral wisps rising from it.
5. SUMMONING CIRCLE: staff raised, a mint mist and violet spectral wisps circle drawn on the ground.
6. SUMMON: both arms open wide, a mint mist and violet spectral wisps creature silhouette emerging beside.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Ombrelis le Brumeux: dark necromancer in black spiked armor with a violet tattered cloak (#5E3A8A); spiked crown, gaunt pale face, glowing mint eyes; skull-topped staff surrounded by mint mist, RIGHT hand. Forbidden: no hood, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `brumes_attack.png` |
| 1-2 | attaque 2 | `brumes_attack_2.png` |
| 1-3 | attaque 3 | `brumes_attack_3.png` |
| 2-1 | sort 1 | `brumes_cast.png` |
| 2-2 | sort 2 | `brumes_cast_2.png` |
| 2-3 | sort 3 | `brumes_cast_3.png` |

## Prompt négatif

**Planches vues** (la même pose vue sous 6 angles est voulue, les vues vers la gauche aussi — le négatif commun est adapté) :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, different character between cells, pose changing between cells, different outfit between angles, realistic proportions, small head
```

**Planches actions et planche de style** :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses, identical poses, repeated pose, copy of the same pose, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, front and back views mixed, different character between poses, realistic proportions, small head
```
