# Nation Cimes (Montagne)

Palette : steel blue, dark iron, snow white fur, ice cyan crystals. Effets : ice shards and snow bursts. Contre-jour : cold icy blue.

Format 2 planches par personnage :

1. **Vues** — le personnage au repos vu sous 4 angles en quarts de tour (3/4 avant droite, 3/4 dos droite, 3/4 dos gauche, 3/4 avant gauche) : la caméra ne bouge pas, le personnage tourne sur lui-même. 2 vues plutôt de face, 2 plutôt de dos ; un seul angle par case, aucun doublon possible. Grille 2 × 2 sur image 2:1, poses largement espacées.
2. **Actions** — 2 attaques + 1 sort, chacune vue DE FACE puis DE DOS (3 colonnes × 2 rangées), générées **en édition** de la planche vues (image source = planche vues) : le personnage réellement dessiné sert d'ancre, il ne peut pas changer d'une planche à l'autre. L'arme est verrouillée d'une planche à l'autre (ligne WEAPON LOCK + rappel final). Repli : génération normale (la carte d'identité est recopiée dans chaque prompt).

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

### Tank — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `tank_vues.png` et `tank_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held in hand in every cell, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
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
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm — the character visibly HOLDS it in every cell; hands are never empty.
REMINDER: this is Tank: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm; white hair combed back and a big full white beard; steel-blue eyes (#4A7FB0), thick white eyebrows, always open; heavy dark steel-blue plate armor (#3A4E6E) with white fur trim on the shoulders and small ice-blue crystal inlays (#9FE3FF); tanned skin; steel-blue armored tassets over dark grey trousers; heavy steel boots. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no cape, no sword, no brown beard.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `tank.png` |
| 1-2 | 3/4 dos droite | `tank_back.png` |
| 2-1 | 3/4 dos gauche | `tank_back_left.png` |
| 2-2 | 3/4 avant gauche | `tank_face_left.png` |

##### Édition corrective (arme manquante sur des cases)

Si l'arme manque sur certaines cases de la planche générée : édition avec la planche `vues` en image source. Ce prompt RÉPÈTE la liste des angles — une édition corrective qui ne la répète pas aplatit toutes les vues dans le même angle.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE playable hero, Tank, several times, in the SAME relaxed idle pose seen from DIFFERENT viewing angles (successive quarter turns of the character, the camera fixed).
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
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWING ANGLES: every sprite keeps its own DIFFERENT viewing angle; the angles must NOT become identical. Never redraw the whole sheet from a single angle. The character turns in place by exact quarter turns between sprites:
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
WEAPON CHECK: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm — the character visibly HOLDS it in every cell; hands are never empty.
CHANGE NOTHING ELSE: keep the exact same characters, poses, sizes, outfits, hair, background and layout. Only add the missing weapon in the correct hand.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Tank: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm; white hair combed back and a big full white beard; steel-blue eyes (#4A7FB0), thick white eyebrows, always open; heavy dark steel-blue plate armor (#3A4E6E) with white fur trim on the shoulders and small ice-blue crystal inlays (#9FE3FF); tanned skin; steel-blue armored tassets over dark grey trousers; heavy steel boots. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no cape, no sword, no brown beard.
```

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE playable hero, Tank, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
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
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: hammer raised high above the head with both arms up, shield on the back arm.
2. SIDE SWING: hammer swept horizontally to the side at full arm length, torso twisted.
3. BRACING: shield planted on the ground in front, head down, ice shards and snow bursts gathering at the feet.
4. Seen from BEHIND, the SAME action as pose 1 — OVERHEAD SMASH: hammer raised high above the head with both arms up, shield on the back arm.
5. Seen from BEHIND, the SAME action as pose 2 — SIDE SWING: hammer swept horizontally to the side at full arm length, torso twisted.
6. Seen from BEHIND, the SAME action as pose 3 — BRACING: shield planted on the ground in front, head down, ice shards and snow bursts gathering at the feet.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tank: rune-engraved war hammer in the RIGHT hand; large round steel shield with a cloud-and-mountain emblem on the LEFT arm; white hair combed back and a big full white beard; steel-blue eyes (#4A7FB0), thick white eyebrows, always open; heavy dark steel-blue plate armor (#3A4E6E) with white fur trim on the shoulders and small ice-blue crystal inlays (#9FE3FF); tanned skin; steel-blue armored tassets over dark grey trousers; heavy steel boots. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no cape, no sword, no brown beard.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `tank_attack.png` |
| 1-2 | attaque 2 — face | `tank_attack_2.png` |
| 1-3 | sort — face | `tank_cast.png` |
| 2-1 | attaque 1 — dos | `tank_attack_back.png` |
| 2-2 | attaque 2 — dos | `tank_attack_2_back.png` |
| 2-3 | sort — dos | `tank_cast_back.png` |

L'export Zimut de l'Atelier copie aussi le repos (case 1 de la planche vues) vers `nations/heros/tank.png`.

## 3. Ennemis

### Guerrier des monts — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cimes/` ; nomme tes images `guerrier_des_monts_vues.png` et `guerrier_des_monts_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held in hand in every cell, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Guerrier des monts (enemy of the Cimes nation)
- Body: stocky mountain warrior with rocky brown skin (#8A6A4A) cracked like stone
- Head: bald rocky head, small white eyes, short stone beard
- Top: fur vest of white snow fur with a leather belt
- Bottom: dark brown fur trousers, bare stone feet
- Weapon: crude grey stone gauntlets on both fists, no other weapon
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword, no axe, no human skin.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: crude grey stone gauntlets on both fists, no other weapon — the character visibly HOLDS it in every cell; hands are never empty.
REMINDER: this is Guerrier des monts: crude grey stone gauntlets on both fists, no other weapon; fur vest of white snow fur with a leather belt; stocky mountain warrior with rocky brown skin (#8A6A4A) cracked like stone; bald rocky head, small white eyes, short stone beard; dark brown fur trousers, bare stone feet. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no sword, no axe, no human skin.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `guerrier_des_monts.png` |
| 1-2 | 3/4 dos droite | `guerrier_des_monts_back.png` |
| 2-1 | 3/4 dos gauche | `guerrier_des_monts_back_left.png` |
| 2-2 | 3/4 avant gauche | `guerrier_des_monts_face_left.png` |

##### Édition corrective (arme manquante sur des cases)

Si l'arme manque sur certaines cases de la planche générée : édition avec la planche `vues` en image source. Ce prompt RÉPÈTE la liste des angles — une édition corrective qui ne la répète pas aplatit toutes les vues dans le même angle.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Guerrier des monts, several times, in the SAME relaxed idle pose seen from DIFFERENT viewing angles (successive quarter turns of the character, the camera fixed).
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Guerrier des monts (enemy of the Cimes nation)
- Body: stocky mountain warrior with rocky brown skin (#8A6A4A) cracked like stone
- Head: bald rocky head, small white eyes, short stone beard
- Top: fur vest of white snow fur with a leather belt
- Bottom: dark brown fur trousers, bare stone feet
- Weapon: crude grey stone gauntlets on both fists, no other weapon
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword, no axe, no human skin.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWING ANGLES: every sprite keeps its own DIFFERENT viewing angle; the angles must NOT become identical. Never redraw the whole sheet from a single angle. The character turns in place by exact quarter turns between sprites:
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
WEAPON CHECK: crude grey stone gauntlets on both fists, no other weapon — the character visibly HOLDS it in every cell; hands are never empty.
CHANGE NOTHING ELSE: keep the exact same characters, poses, sizes, outfits, hair, background and layout. Only add the missing weapon in the correct hand.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Guerrier des monts: crude grey stone gauntlets on both fists, no other weapon; fur vest of white snow fur with a leather belt; stocky mountain warrior with rocky brown skin (#8A6A4A) cracked like stone; bald rocky head, small white eyes, short stone beard; dark brown fur trousers, bare stone feet. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no sword, no axe, no human skin.
```

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Guerrier des monts, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Guerrier des monts (enemy of the Cimes nation)
- Body: stocky mountain warrior with rocky brown skin (#8A6A4A) cracked like stone
- Head: bald rocky head, small white eyes, short stone beard
- Top: fur vest of white snow fur with a leather belt
- Bottom: dark brown fur trousers, bare stone feet
- Weapon: crude grey stone gauntlets on both fists, no other weapon
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no sword, no axe, no human skin.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. BACKHAND: arm swept horizontally to the side, torso twisted.
3. ROOTED: stomping, ice shards and snow bursts cracks spreading under the feet.
4. Seen from BEHIND, the SAME action as pose 1 — OVERHEAD SMASH: both fists or weapon raised high above the head.
5. Seen from BEHIND, the SAME action as pose 2 — BACKHAND: arm swept horizontally to the side, torso twisted.
6. Seen from BEHIND, the SAME action as pose 3 — ROOTED: stomping, ice shards and snow bursts cracks spreading under the feet.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Guerrier des monts: crude grey stone gauntlets on both fists, no other weapon; fur vest of white snow fur with a leather belt; stocky mountain warrior with rocky brown skin (#8A6A4A) cracked like stone; bald rocky head, small white eyes, short stone beard; dark brown fur trousers, bare stone feet. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no sword, no axe, no human skin.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `guerrier_des_monts_attack.png` |
| 1-2 | attaque 2 — face | `guerrier_des_monts_attack_2.png` |
| 1-3 | sort — face | `guerrier_des_monts_cast.png` |
| 2-1 | attaque 1 — dos | `guerrier_des_monts_attack_back.png` |
| 2-2 | attaque 2 — dos | `guerrier_des_monts_attack_2_back.png` |
| 2-3 | sort — dos | `guerrier_des_monts_cast_back.png` |

### Griffon des cimes — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cimes/` ; nomme tes images `griffon_des_cimes_vues.png` et `griffon_des_cimes_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held in hand in every cell, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Griffon des cimes (enemy of the Cimes nation)
- Body: griffin with a tawny lion body (#C9A060) and four legs, front legs with eagle talons
- Head: white eagle head, yellow hooked beak, golden eyes
- Details: large blue-grey feathered wings (#7A8CA8), lion tail with a white tuft
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no rider, no saddle, no armor.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Griffon des cimes: griffin with a tawny lion body (#C9A060) and four legs, front legs with eagle talons; white eagle head, yellow hooked beak, golden eyes; large blue-grey feathered wings (#7A8CA8), lion tail with a white tuft. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no rider, no saddle, no armor.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `griffon_des_cimes.png` |
| 1-2 | 3/4 dos droite | `griffon_des_cimes_back.png` |
| 2-1 | 3/4 dos gauche | `griffon_des_cimes_back_left.png` |
| 2-2 | 3/4 avant gauche | `griffon_des_cimes_face_left.png` |

##### Édition corrective (arme manquante sur des cases)

Si l'arme manque sur certaines cases de la planche générée : édition avec la planche `vues` en image source. Ce prompt RÉPÈTE la liste des angles — une édition corrective qui ne la répète pas aplatit toutes les vues dans le même angle.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Griffon des cimes, several times, in the SAME relaxed idle pose seen from DIFFERENT viewing angles (successive quarter turns of the character, the camera fixed).
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Griffon des cimes (enemy of the Cimes nation)
- Body: griffin with a tawny lion body (#C9A060) and four legs, front legs with eagle talons
- Head: white eagle head, yellow hooked beak, golden eyes
- Details: large blue-grey feathered wings (#7A8CA8), lion tail with a white tuft
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no rider, no saddle, no armor.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWING ANGLES: every sprite keeps its own DIFFERENT viewing angle; the angles must NOT become identical. Never redraw the whole sheet from a single angle. The character turns in place by exact quarter turns between sprites:
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
CHANGE NOTHING ELSE: keep the exact same characters, poses, sizes, outfits, hair, background and layout. Only add the missing weapon in the correct hand.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Griffon des cimes: griffin with a tawny lion body (#C9A060) and four legs, front legs with eagle talons; white eagle head, yellow hooked beak, golden eyes; large blue-grey feathered wings (#7A8CA8), lion tail with a white tuft. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no rider, no saddle, no armor.
```

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Griffon des cimes, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Griffon des cimes (enemy of the Cimes nation)
- Body: griffin with a tawny lion body (#C9A060) and four legs, front legs with eagle talons
- Head: white eagle head, yellow hooked beak, golden eyes
- Details: large blue-grey feathered wings (#7A8CA8), lion tail with a white tuft
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no rider, no saddle, no armor.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. SIDE SWIPE: head and claws swept to the side, body twisted.
3. HOWL: head raised to the sky, ice shards and snow bursts gathering around the body.
4. Seen from BEHIND, the SAME action as pose 1 — REARING: standing up on the hind legs, front claws raised high.
5. Seen from BEHIND, the SAME action as pose 2 — SIDE SWIPE: head and claws swept to the side, body twisted.
6. Seen from BEHIND, the SAME action as pose 3 — HOWL: head raised to the sky, ice shards and snow bursts gathering around the body.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Griffon des cimes: griffin with a tawny lion body (#C9A060) and four legs, front legs with eagle talons; white eagle head, yellow hooked beak, golden eyes; large blue-grey feathered wings (#7A8CA8), lion tail with a white tuft. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no rider, no saddle, no armor.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `griffon_des_cimes_attack.png` |
| 1-2 | attaque 2 — face | `griffon_des_cimes_attack_2.png` |
| 1-3 | sort — face | `griffon_des_cimes_cast.png` |
| 2-1 | attaque 1 — dos | `griffon_des_cimes_attack_back.png` |
| 2-2 | attaque 2 — dos | `griffon_des_cimes_attack_2_back.png` |
| 2-3 | sort — dos | `griffon_des_cimes_cast_back.png` |

### Garde des pics — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cimes/` ; nomme tes images `garde_des_pics_vues.png` et `garde_des_pics_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held in hand in every cell, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Garde des pics (enemy of the Cimes nation)
- Body: peak guardian golem of smooth blue-grey stone blocks (#6E8296)
- Head: small square stone head with two glowing ice-blue eyes (#9FE3FF)
- Details: clusters of glowing ice-blue crystals (#9FE3FF) on both shoulders, big stone fists
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no moss, no brown stone.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Garde des pics: peak guardian golem of smooth blue-grey stone blocks (#6E8296); small square stone head with two glowing ice-blue eyes (#9FE3FF); clusters of glowing ice-blue crystals (#9FE3FF) on both shoulders, big stone fists. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no weapon, no moss, no brown stone.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `garde_des_pics.png` |
| 1-2 | 3/4 dos droite | `garde_des_pics_back.png` |
| 2-1 | 3/4 dos gauche | `garde_des_pics_back_left.png` |
| 2-2 | 3/4 avant gauche | `garde_des_pics_face_left.png` |

##### Édition corrective (arme manquante sur des cases)

Si l'arme manque sur certaines cases de la planche générée : édition avec la planche `vues` en image source. Ce prompt RÉPÈTE la liste des angles — une édition corrective qui ne la répète pas aplatit toutes les vues dans le même angle.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Garde des pics, several times, in the SAME relaxed idle pose seen from DIFFERENT viewing angles (successive quarter turns of the character, the camera fixed).
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Garde des pics (enemy of the Cimes nation)
- Body: peak guardian golem of smooth blue-grey stone blocks (#6E8296)
- Head: small square stone head with two glowing ice-blue eyes (#9FE3FF)
- Details: clusters of glowing ice-blue crystals (#9FE3FF) on both shoulders, big stone fists
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no moss, no brown stone.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWING ANGLES: every sprite keeps its own DIFFERENT viewing angle; the angles must NOT become identical. Never redraw the whole sheet from a single angle. The character turns in place by exact quarter turns between sprites:
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
CHANGE NOTHING ELSE: keep the exact same characters, poses, sizes, outfits, hair, background and layout. Only add the missing weapon in the correct hand.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Garde des pics: peak guardian golem of smooth blue-grey stone blocks (#6E8296); small square stone head with two glowing ice-blue eyes (#9FE3FF); clusters of glowing ice-blue crystals (#9FE3FF) on both shoulders, big stone fists. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no weapon, no moss, no brown stone.
```

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Garde des pics, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Garde des pics (enemy of the Cimes nation)
- Body: peak guardian golem of smooth blue-grey stone blocks (#6E8296)
- Head: small square stone head with two glowing ice-blue eyes (#9FE3FF)
- Details: clusters of glowing ice-blue crystals (#9FE3FF) on both shoulders, big stone fists
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no moss, no brown stone.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. BACKHAND: arm swept horizontally to the side, torso twisted.
3. ROOTED: stomping, ice shards and snow bursts cracks spreading under the feet.
4. Seen from BEHIND, the SAME action as pose 1 — OVERHEAD SMASH: both fists or weapon raised high above the head.
5. Seen from BEHIND, the SAME action as pose 2 — BACKHAND: arm swept horizontally to the side, torso twisted.
6. Seen from BEHIND, the SAME action as pose 3 — ROOTED: stomping, ice shards and snow bursts cracks spreading under the feet.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Garde des pics: peak guardian golem of smooth blue-grey stone blocks (#6E8296); small square stone head with two glowing ice-blue eyes (#9FE3FF); clusters of glowing ice-blue crystals (#9FE3FF) on both shoulders, big stone fists. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no weapon, no moss, no brown stone.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `garde_des_pics_attack.png` |
| 1-2 | attaque 2 — face | `garde_des_pics_attack_2.png` |
| 1-3 | sort — face | `garde_des_pics_cast.png` |
| 2-1 | attaque 1 — dos | `garde_des_pics_attack_back.png` |
| 2-2 | attaque 2 — dos | `garde_des_pics_attack_2_back.png` |
| 2-3 | sort — dos | `garde_des_pics_cast_back.png` |

### Rochebrute — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/cimes/` ; nomme tes images `rochebrute_vues.png` et `rochebrute_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held in hand in every cell, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Rochebrute (enemy of the Cimes nation)
- Body: hulking brute made of round brown boulders (#7A5A3A), huge hunched shoulders
- Head: small boulder head sunk between the shoulders, two small glowing orange eyes (#FF9A3A)
- Details: huge boulder fists, short stumpy legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no crystals, no weapon, no grey stone.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Rochebrute: hulking brute made of round brown boulders (#7A5A3A), huge hunched shoulders; small boulder head sunk between the shoulders, two small glowing orange eyes (#FF9A3A); huge boulder fists, short stumpy legs. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no crystals, no weapon, no grey stone.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `rochebrute.png` |
| 1-2 | 3/4 dos droite | `rochebrute_back.png` |
| 2-1 | 3/4 dos gauche | `rochebrute_back_left.png` |
| 2-2 | 3/4 avant gauche | `rochebrute_face_left.png` |

##### Édition corrective (arme manquante sur des cases)

Si l'arme manque sur certaines cases de la planche générée : édition avec la planche `vues` en image source. Ce prompt RÉPÈTE la liste des angles — une édition corrective qui ne la répète pas aplatit toutes les vues dans le même angle.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Rochebrute, several times, in the SAME relaxed idle pose seen from DIFFERENT viewing angles (successive quarter turns of the character, the camera fixed).
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Rochebrute (enemy of the Cimes nation)
- Body: hulking brute made of round brown boulders (#7A5A3A), huge hunched shoulders
- Head: small boulder head sunk between the shoulders, two small glowing orange eyes (#FF9A3A)
- Details: huge boulder fists, short stumpy legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no crystals, no weapon, no grey stone.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWING ANGLES: every sprite keeps its own DIFFERENT viewing angle; the angles must NOT become identical. Never redraw the whole sheet from a single angle. The character turns in place by exact quarter turns between sprites:
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
CHANGE NOTHING ELSE: keep the exact same characters, poses, sizes, outfits, hair, background and layout. Only add the missing weapon in the correct hand.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Rochebrute: hulking brute made of round brown boulders (#7A5A3A), huge hunched shoulders; small boulder head sunk between the shoulders, two small glowing orange eyes (#FF9A3A); huge boulder fists, short stumpy legs. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no crystals, no weapon, no grey stone.
```

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Rochebrute, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Rochebrute (enemy of the Cimes nation)
- Body: hulking brute made of round brown boulders (#7A5A3A), huge hunched shoulders
- Head: small boulder head sunk between the shoulders, two small glowing orange eyes (#FF9A3A)
- Details: huge boulder fists, short stumpy legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no crystals, no weapon, no grey stone.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. BACKHAND: arm swept horizontally to the side, torso twisted.
3. ROOTED: stomping, ice shards and snow bursts cracks spreading under the feet.
4. Seen from BEHIND, the SAME action as pose 1 — OVERHEAD SMASH: both fists or weapon raised high above the head.
5. Seen from BEHIND, the SAME action as pose 2 — BACKHAND: arm swept horizontally to the side, torso twisted.
6. Seen from BEHIND, the SAME action as pose 3 — ROOTED: stomping, ice shards and snow bursts cracks spreading under the feet.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Rochebrute: hulking brute made of round brown boulders (#7A5A3A), huge hunched shoulders; small boulder head sunk between the shoulders, two small glowing orange eyes (#FF9A3A); huge boulder fists, short stumpy legs. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no crystals, no weapon, no grey stone.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `rochebrute_attack.png` |
| 1-2 | attaque 2 — face | `rochebrute_attack_2.png` |
| 1-3 | sort — face | `rochebrute_cast.png` |
| 2-1 | attaque 1 — dos | `rochebrute_attack_back.png` |
| 2-2 | attaque 2 — dos | `rochebrute_attack_2_back.png` |
| 2-3 | sort — dos | `rochebrute_cast_back.png` |

## 4. Boss

### Vorkann le Givre — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `cimes_vues.png` et `cimes_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held in hand in every cell, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Vorkann le Givre (boss of the Cimes nation)
- Body: massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur
- Head: closed crowned helm of ice spikes, glowing ice-blue eye slit
- Weapon: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visible face, no cape.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm — the character visibly HOLDS it in every cell; hands are never empty.
REMINDER: this is Vorkann le Givre: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm; massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur; closed crowned helm of ice spikes, glowing ice-blue eye slit. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no visible face, no cape.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `cimes.png` |
| 1-2 | 3/4 dos droite | `cimes_back.png` |
| 2-1 | 3/4 dos gauche | `cimes_back_left.png` |
| 2-2 | 3/4 avant gauche | `cimes_face_left.png` |

##### Édition corrective (arme manquante sur des cases)

Si l'arme manque sur certaines cases de la planche générée : édition avec la planche `vues` en image source. Ce prompt RÉPÈTE la liste des angles — une édition corrective qui ne la répète pas aplatit toutes les vues dans le même angle.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE final boss, Vorkann le Givre, several times, in the SAME relaxed idle pose seen from DIFFERENT viewing angles (successive quarter turns of the character, the camera fixed).
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Vorkann le Givre (boss of the Cimes nation)
- Body: massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur
- Head: closed crowned helm of ice spikes, glowing ice-blue eye slit
- Weapon: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visible face, no cape.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWING ANGLES: every sprite keeps its own DIFFERENT viewing angle; the angles must NOT become identical. Never redraw the whole sheet from a single angle. The character turns in place by exact quarter turns between sprites:
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
WEAPON CHECK: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm — the character visibly HOLDS it in every cell; hands are never empty.
CHANGE NOTHING ELSE: keep the exact same characters, poses, sizes, outfits, hair, background and layout. Only add the missing weapon in the correct hand.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Vorkann le Givre: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm; massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur; closed crowned helm of ice spikes, glowing ice-blue eye slit. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no visible face, no cape.
```

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE final boss, Vorkann le Givre, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Vorkann le Givre (boss of the Cimes nation)
- Body: massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur
- Head: closed crowned helm of ice spikes, glowing ice-blue eye slit
- Weapon: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visible face, no cape.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: hammer raised high above the head with both arms up, shield on the back arm.
2. SIDE SWING: hammer swept horizontally to the side at full arm length, torso twisted.
3. BRACING: shield planted on the ground in front, head down, ice shards and snow bursts gathering at the feet.
4. Seen from BEHIND, the SAME action as pose 1 — OVERHEAD SMASH: hammer raised high above the head with both arms up, shield on the back arm.
5. Seen from BEHIND, the SAME action as pose 2 — SIDE SWING: hammer swept horizontally to the side at full arm length, torso twisted.
6. Seen from BEHIND, the SAME action as pose 3 — BRACING: shield planted on the ground in front, head down, ice shards and snow bursts gathering at the feet.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Vorkann le Givre: heavy rune hammer in the RIGHT hand, huge crystal-studded tower shield on the LEFT arm; massive frost knight in dark steel armor (#2E3A4E) covered with ice crystals and white snow fur; closed crowned helm of ice spikes, glowing ice-blue eye slit. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no visible face, no cape.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `cimes_attack.png` |
| 1-2 | attaque 2 — face | `cimes_attack_2.png` |
| 1-3 | sort — face | `cimes_cast.png` |
| 2-1 | attaque 1 — dos | `cimes_attack_back.png` |
| 2-2 | attaque 2 — dos | `cimes_attack_2_back.png` |
| 2-3 | sort — dos | `cimes_cast_back.png` |

## Prompt négatif

**Planches vues** (la même pose vue sous 4 angles est voulue, les vues vers la gauche aussi — le négatif commun est adapté) :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, one sprite bigger or smaller than the others, size changing between cells, more than 4 sprites, extra sprites, duplicated row of sprites, all sprites in the same viewing angle, all sprites in the same orientation, empty hands, character without its weapon in a cell, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, different character between cells, pose changing between cells, different outfit between angles, weapon changing shape, weapon changing color, weapon replaced by another weapon, missing weapon, missing accessories, realistic proportions, small head
```

**Planches actions et planche de style** (les actions répétées de dos en rangée 2 sont voulues : seules les répétitions sous le même angle sont interdites) :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, weapon changing shape, weapon changing color, weapon replaced by another weapon, missing weapon, missing accessories, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, different character between poses, realistic proportions, small head
```
