# Nation Cimes (Montagne)

Palette : steel blue, dark iron, snow white fur, ice cyan crystals. Effets : ice shards and snow bursts. Contre-jour : cold icy blue.

Format 2 planches par personnage :

1. **Vues** — le personnage au repos vu sous 6 angles (face, 3/4 avant droite, 3/4 dos droite, dos, 3/4 dos gauche, 3/4 avant gauche), grille 3 × 2 sur image 2:1, poses largement espacées. Un seul angle par case : aucun doublon possible.
2. **Actions** — 3 attaques + 3 sorts en vue 3/4 avant, générées **en édition** de la planche vues (image source = planche vues) : le personnage réellement dessiné sert d'ancre, il ne peut pas changer d'une planche à l'autre. Repli : génération normale (la carte d'identité est recopiée dans chaque prompt).

Chaque prompt recopie la carte d'identité du personnage (`identites.py`) : aucune image à joindre. Ordre conseillé : 1) planche de style, 2) héros, 3) ennemis, 4) boss ; pour chaque personnage : vues puis actions. Prompt négatif : en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Cimes nation (Montagne biome).
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals. Signature effects: ice shards and snow bursts.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: two rows with the same 6 characters in the same order, all in idle pose. Top row: 3/4 front view, facing front-right. Bottom row: 3/4 back view, seen from behind, turned toward the upper right. All feet of a row on the same ground line. Leave a wide empty gap (at least half a character width) between characters and between the two rows: nobody overlaps or touches anyone, weapons and capes included. Image aspect ratio 2:1, as large as possible.
CHARACTERS, left to right:
1. the hero (Tank: stout veteran warrior with a big white beard and white hair, heavy dark steel-blue plate armor with white fur trim and ice-blue crystal inlays, a large round shield with a cloud and mountain emblem on the left arm, a rune-engraved war hammer in the right hand).
2. Guerrier des monts (mountain warrior with rocky brown skin, stocky body, crude stone gauntlets).
3. Griffon des cimes (griffin with a white eagle head, blue-grey feathered wings and a lion body).
4. Garde des pics (peak guardian golem of blue-grey stone with glowing ice-blue crystals on the shoulders).
5. Rochebrute (hulking brute made of brown boulders, small glowing eyes, huge fists).
6. the final boss Vorkann le Givre (massive frost knight in dark steel armor covered with ice crystals and snow fur, crowned helm of ice spikes, huge crystal-studded tower shield and a heavy rune hammer), about 1.5x taller than the others.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Tank — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `tank_vues.png` et `tank_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tank (hero of the Cimes nation)
- Hair: white hair combed back and a big full white beard
- Eyes: steel-blue eyes (#4A7FB0), thick white eyebrows, always open
- Skin: tanned skin
- Top: heavy dark steel-blue plate armor (#3A4E6E) with white fur trim on the shoulders and small ice-blue crystal inlays (#9FE3FF)
- Bottom: steel-blue armored tassets over dark grey trousers
- Feet: heavy steel boots
- Weapon: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no cape, no sword, no brown beard.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tank: white hair combed back and a big full white beard; steel-blue eyes (#4A7FB0), thick white eyebrows, always open; tanned skin; heavy dark steel-blue plate armor (#3A4E6E) with white fur trim on the shoulders and small ice-blue crystal inlays (#9FE3FF). Forbidden: no helmet, no cape, no sword, no brown beard.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `tank.png` |
| 1-2 | 3/4 avant droite | `tank_face_right.png` |
| 1-3 | 3/4 dos droite | `tank_back_right.png` |
| 2-1 | dos complet | `tank_back.png` |
| 2-2 | 3/4 dos gauche | `tank_back_left.png` |
| 2-3 | 3/4 avant gauche | `tank_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE playable hero, Tank, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tank (hero of the Cimes nation)
- Hair: white hair combed back and a big full white beard
- Eyes: steel-blue eyes (#4A7FB0), thick white eyebrows, always open
- Skin: tanned skin
- Top: heavy dark steel-blue plate armor (#3A4E6E) with white fur trim on the shoulders and small ice-blue crystal inlays (#9FE3FF)
- Bottom: steel-blue armored tassets over dark grey trousers
- Feet: heavy steel boots
- Weapon: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no cape, no sword, no brown beard.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: hammer raised high above the head with both arms up, shield on the back arm.
2. SHIELD CHARGE: body leaning far forward, shield thrust in front, hammer pulled back low.
3. SIDE SWING: hammer swept horizontally to the side at full arm length, torso twisted.
4. BRACING: shield planted on the ground in front, head down, ice shards and snow bursts gathering at the feet.
5. WAR CRY: mouth open, hammer raised straight to the sky, ice shards and snow bursts swirling above.
6. AURA: arms spread wide, a dome of ice shards and snow bursts around the body.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tank: white hair combed back and a big full white beard; steel-blue eyes (#4A7FB0), thick white eyebrows, always open; tanned skin; heavy dark steel-blue plate armor (#3A4E6E) with white fur trim on the shoulders and small ice-blue crystal inlays (#9FE3FF). Forbidden: no helmet, no cape, no sword, no brown beard.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `tank_attack.png` |
| 1-2 | attaque 2 | `tank_attack_2.png` |
| 1-3 | attaque 3 | `tank_attack_3.png` |
| 2-1 | sort 1 | `tank_cast.png` |
| 2-2 | sort 2 | `tank_cast_2.png` |
| 2-3 | sort 3 | `tank_cast_3.png` |

L'export Zimut de l'Atelier copie aussi le repos (case 1 de la planche vues) vers `nations/heros/tank.png`.

## 3. Ennemis

### Guerrier des monts — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cimes/` ; nomme tes images `guerrier_des_monts_vues.png` et `guerrier_des_monts_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Guerrier des monts (enemy of the Cimes nation)
- Body: stocky mountain warrior with rocky brown skin (#8A6A4A) cracked like stone
- Head: bald rocky head, small white eyes, short stone beard
- Top: fur vest of white snow fur with a leather belt
- Bottom: dark brown fur trousers, bare stone feet
- Weapon: crude grey stone gauntlets on both fists, no other weapon
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword, no axe, no human skin.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Guerrier des monts: stocky mountain warrior with rocky brown skin (#8A6A4A) cracked like stone; bald rocky head, small white eyes, short stone beard; fur vest of white snow fur with a leather belt; dark brown fur trousers, bare stone feet. Forbidden: no helmet, no sword, no axe, no human skin.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `guerrier_des_monts.png` |
| 1-2 | 3/4 avant droite | `guerrier_des_monts_face_right.png` |
| 1-3 | 3/4 dos droite | `guerrier_des_monts_back_right.png` |
| 2-1 | dos complet | `guerrier_des_monts_back.png` |
| 2-2 | 3/4 dos gauche | `guerrier_des_monts_back_left.png` |
| 2-3 | 3/4 avant gauche | `guerrier_des_monts_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Guerrier des monts, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Guerrier des monts (enemy of the Cimes nation)
- Body: stocky mountain warrior with rocky brown skin (#8A6A4A) cracked like stone
- Head: bald rocky head, small white eyes, short stone beard
- Top: fur vest of white snow fur with a leather belt
- Bottom: dark brown fur trousers, bare stone feet
- Weapon: crude grey stone gauntlets on both fists, no other weapon
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword, no axe, no human skin.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted.
4. ROOTED: stomping, ice shards and snow bursts cracks spreading under the feet.
5. GATHER: arms raised, ice shards and snow bursts gathering between the hands.
6. SHOCKWAVE: both fists slammed into the ground, ice shards and snow bursts wave.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Guerrier des monts: stocky mountain warrior with rocky brown skin (#8A6A4A) cracked like stone; bald rocky head, small white eyes, short stone beard; fur vest of white snow fur with a leather belt; dark brown fur trousers, bare stone feet. Forbidden: no helmet, no sword, no axe, no human skin.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `guerrier_des_monts_attack.png` |
| 1-2 | attaque 2 | `guerrier_des_monts_attack_2.png` |
| 1-3 | attaque 3 | `guerrier_des_monts_attack_3.png` |
| 2-1 | sort 1 | `guerrier_des_monts_cast.png` |
| 2-2 | sort 2 | `guerrier_des_monts_cast_2.png` |
| 2-3 | sort 3 | `guerrier_des_monts_cast_3.png` |

### Griffon des cimes — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cimes/` ; nomme tes images `griffon_des_cimes_vues.png` et `griffon_des_cimes_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Griffon des cimes (enemy of the Cimes nation)
- Body: griffin with a tawny lion body (#C9A060) and four legs, front legs with eagle talons
- Head: white eagle head, yellow hooked beak, golden eyes
- Details: large blue-grey feathered wings (#7A8CA8), lion tail with a white tuft
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no rider, no saddle, no armor.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Griffon des cimes: griffin with a tawny lion body (#C9A060) and four legs, front legs with eagle talons; white eagle head, yellow hooked beak, golden eyes; large blue-grey feathered wings (#7A8CA8), lion tail with a white tuft. Forbidden: no rider, no saddle, no armor.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `griffon_des_cimes.png` |
| 1-2 | 3/4 avant droite | `griffon_des_cimes_face_right.png` |
| 1-3 | 3/4 dos droite | `griffon_des_cimes_back_right.png` |
| 2-1 | dos complet | `griffon_des_cimes_back.png` |
| 2-2 | 3/4 dos gauche | `griffon_des_cimes_back_left.png` |
| 2-3 | 3/4 avant gauche | `griffon_des_cimes_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Griffon des cimes, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Griffon des cimes (enemy of the Cimes nation)
- Body: griffin with a tawny lion body (#C9A060) and four legs, front legs with eagle talons
- Head: white eagle head, yellow hooked beak, golden eyes
- Details: large blue-grey feathered wings (#7A8CA8), lion tail with a white tuft
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no rider, no saddle, no armor.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. POUNCE: body stretched forward in the air, jaws open.
3. SIDE SWIPE: head and claws swept to the side, body twisted.
4. HOWL: head raised to the sky, ice shards and snow bursts gathering around the body.
5. ROAR: mouth wide open, ice shards and snow bursts burst in front of the head.
6. BREATH: a short ice shards and snow bursts breath released forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Griffon des cimes: griffin with a tawny lion body (#C9A060) and four legs, front legs with eagle talons; white eagle head, yellow hooked beak, golden eyes; large blue-grey feathered wings (#7A8CA8), lion tail with a white tuft. Forbidden: no rider, no saddle, no armor.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `griffon_des_cimes_attack.png` |
| 1-2 | attaque 2 | `griffon_des_cimes_attack_2.png` |
| 1-3 | attaque 3 | `griffon_des_cimes_attack_3.png` |
| 2-1 | sort 1 | `griffon_des_cimes_cast.png` |
| 2-2 | sort 2 | `griffon_des_cimes_cast_2.png` |
| 2-3 | sort 3 | `griffon_des_cimes_cast_3.png` |

### Garde des pics — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cimes/` ; nomme tes images `garde_des_pics_vues.png` et `garde_des_pics_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Garde des pics (enemy of the Cimes nation)
- Body: peak guardian golem of smooth blue-grey stone blocks (#6E8296)
- Head: small square stone head with two glowing ice-blue eyes (#9FE3FF)
- Details: clusters of glowing ice-blue crystals (#9FE3FF) on both shoulders, big stone fists
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no moss, no brown stone.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Garde des pics: peak guardian golem of smooth blue-grey stone blocks (#6E8296); small square stone head with two glowing ice-blue eyes (#9FE3FF); clusters of glowing ice-blue crystals (#9FE3FF) on both shoulders, big stone fists. Forbidden: no weapon, no moss, no brown stone.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `garde_des_pics.png` |
| 1-2 | 3/4 avant droite | `garde_des_pics_face_right.png` |
| 1-3 | 3/4 dos droite | `garde_des_pics_back_right.png` |
| 2-1 | dos complet | `garde_des_pics_back.png` |
| 2-2 | 3/4 dos gauche | `garde_des_pics_back_left.png` |
| 2-3 | 3/4 avant gauche | `garde_des_pics_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Garde des pics, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Garde des pics (enemy of the Cimes nation)
- Body: peak guardian golem of smooth blue-grey stone blocks (#6E8296)
- Head: small square stone head with two glowing ice-blue eyes (#9FE3FF)
- Details: clusters of glowing ice-blue crystals (#9FE3FF) on both shoulders, big stone fists
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no moss, no brown stone.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted.
4. ROOTED: stomping, ice shards and snow bursts cracks spreading under the feet.
5. GATHER: arms raised, ice shards and snow bursts gathering between the hands.
6. SHOCKWAVE: both fists slammed into the ground, ice shards and snow bursts wave.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Garde des pics: peak guardian golem of smooth blue-grey stone blocks (#6E8296); small square stone head with two glowing ice-blue eyes (#9FE3FF); clusters of glowing ice-blue crystals (#9FE3FF) on both shoulders, big stone fists. Forbidden: no weapon, no moss, no brown stone.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `garde_des_pics_attack.png` |
| 1-2 | attaque 2 | `garde_des_pics_attack_2.png` |
| 1-3 | attaque 3 | `garde_des_pics_attack_3.png` |
| 2-1 | sort 1 | `garde_des_pics_cast.png` |
| 2-2 | sort 2 | `garde_des_pics_cast_2.png` |
| 2-3 | sort 3 | `garde_des_pics_cast_3.png` |

### Rochebrute — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cimes/` ; nomme tes images `rochebrute_vues.png` et `rochebrute_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Rochebrute (enemy of the Cimes nation)
- Body: hulking brute made of round brown boulders (#7A5A3A), huge hunched shoulders
- Head: small boulder head sunk between the shoulders, two small glowing orange eyes (#FF9A3A)
- Details: huge boulder fists, short stumpy legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no crystals, no weapon, no grey stone.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Rochebrute: hulking brute made of round brown boulders (#7A5A3A), huge hunched shoulders; small boulder head sunk between the shoulders, two small glowing orange eyes (#FF9A3A); huge boulder fists, short stumpy legs. Forbidden: no crystals, no weapon, no grey stone.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `rochebrute.png` |
| 1-2 | 3/4 avant droite | `rochebrute_face_right.png` |
| 1-3 | 3/4 dos droite | `rochebrute_back_right.png` |
| 2-1 | dos complet | `rochebrute_back.png` |
| 2-2 | 3/4 dos gauche | `rochebrute_back_left.png` |
| 2-3 | 3/4 avant gauche | `rochebrute_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Rochebrute, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Rochebrute (enemy of the Cimes nation)
- Body: hulking brute made of round brown boulders (#7A5A3A), huge hunched shoulders
- Head: small boulder head sunk between the shoulders, two small glowing orange eyes (#FF9A3A)
- Details: huge boulder fists, short stumpy legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no crystals, no weapon, no grey stone.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted.
4. ROOTED: stomping, ice shards and snow bursts cracks spreading under the feet.
5. GATHER: arms raised, ice shards and snow bursts gathering between the hands.
6. SHOCKWAVE: both fists slammed into the ground, ice shards and snow bursts wave.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Rochebrute: hulking brute made of round brown boulders (#7A5A3A), huge hunched shoulders; small boulder head sunk between the shoulders, two small glowing orange eyes (#FF9A3A); huge boulder fists, short stumpy legs. Forbidden: no crystals, no weapon, no grey stone.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `rochebrute_attack.png` |
| 1-2 | attaque 2 | `rochebrute_attack_2.png` |
| 1-3 | attaque 3 | `rochebrute_attack_3.png` |
| 2-1 | sort 1 | `rochebrute_cast.png` |
| 2-2 | sort 2 | `rochebrute_cast_2.png` |
| 2-3 | sort 3 | `rochebrute_cast_3.png` |

## 4. Boss

### Vorkann le Givre — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `cimes_vues.png` et `cimes_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Vorkann le Givre (boss of the Cimes nation)
- Body: massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur
- Head: closed crowned helm of ice spikes, glowing ice-blue eye slit
- Weapon: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visible face, no cape.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Vorkann le Givre: massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur; closed crowned helm of ice spikes, glowing ice-blue eye slit; heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm. Forbidden: no visible face, no cape.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `cimes.png` |
| 1-2 | 3/4 avant droite | `cimes_face_right.png` |
| 1-3 | 3/4 dos droite | `cimes_back_right.png` |
| 2-1 | dos complet | `cimes_back.png` |
| 2-2 | 3/4 dos gauche | `cimes_back_left.png` |
| 2-3 | 3/4 avant gauche | `cimes_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE final boss, Vorkann le Givre, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Vorkann le Givre (boss of the Cimes nation)
- Body: massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur
- Head: closed crowned helm of ice spikes, glowing ice-blue eye slit
- Weapon: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visible face, no cape.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: hammer raised high above the head with both arms up, shield on the back arm.
2. SHIELD CHARGE: body leaning far forward, shield thrust in front, hammer pulled back low.
3. SIDE SWING: hammer swept horizontally to the side at full arm length, torso twisted.
4. BRACING: shield planted on the ground in front, head down, ice shards and snow bursts gathering at the feet.
5. WAR CRY: mouth open, hammer raised straight to the sky, ice shards and snow bursts swirling above.
6. AURA: arms spread wide, a dome of ice shards and snow bursts around the body.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Vorkann le Givre: massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur; closed crowned helm of ice spikes, glowing ice-blue eye slit; heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm. Forbidden: no visible face, no cape.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `cimes_attack.png` |
| 1-2 | attaque 2 | `cimes_attack_2.png` |
| 1-3 | attaque 3 | `cimes_attack_3.png` |
| 2-1 | sort 1 | `cimes_cast.png` |
| 2-2 | sort 2 | `cimes_cast_2.png` |
| 2-3 | sort 3 | `cimes_cast_3.png` |

## Prompt négatif

**Planches vues** (la même pose vue sous 6 angles est voulue, les vues vers la gauche aussi — le négatif commun est adapté) :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, different character between cells, pose changing between cells, different outfit between angles, realistic proportions, small head
```

**Planches actions et planche de style** :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses, identical poses, repeated pose, copy of the same pose, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, front and back views mixed, different character between poses, realistic proportions, small head
```
