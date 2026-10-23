# Nation Sylvestre (Forêt)

Palette : moss green, bark brown, leaf gold, small emerald glows. Effets : green leaves and glowing spores. Contre-jour : warm golden sunlight.

Format 2 planches par personnage :

1. **Vues** — le personnage au repos vu sous 4 angles en quarts de tour (3/4 avant droite, 3/4 dos droite, 3/4 dos gauche, 3/4 avant gauche) : la caméra ne bouge pas, le personnage tourne sur lui-même. 2 vues plutôt de face, 2 plutôt de dos ; un seul angle par case, aucun doublon possible. Grille 2 × 2 sur image 2:1, poses largement espacées.
2. **Actions** — 2 attaques + 1 sort, chacune vue DE FACE puis DE DOS (3 colonnes × 2 rangées), générées **en édition** de la planche vues (image source = planche vues) : le personnage réellement dessiné sert d'ancre, il ne peut pas changer d'une planche à l'autre. L'arme est verrouillée d'une planche à l'autre (ligne WEAPON LOCK + rappel final). Repli : génération normale (la carte d'identité est recopiée dans chaque prompt).

Chaque prompt recopie la carte d'identité du personnage (`identites.py`) : aucune image à joindre. Ordre conseillé : 1) planche de style, 2) héros, 3) ennemis, 4) boss ; pour chaque personnage : vues puis actions. Prompt négatif : en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Sylvestre nation (Forêt biome).
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows. Signature effects: green leaves and glowing spores.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: two rows with the same 6 characters in the same order, all in idle pose. Top row: 3/4 front view, facing front-right. Bottom row: 3/4 back view, seen from behind, turned toward the upper right. All feet of a row on the same ground line. Leave a wide empty gap (at least half a character width) between characters and between the two rows: nobody overlaps or touches anyone, weapons and capes included. Image aspect ratio 2:1, as large as possible.
CHARACTERS, left to right:
1. the hero (Druide: young druid with messy dark green hair, layered armor-robe made of overlapping leaves and bark plates in moss green and brown, leather belts, a tall wooden staff topped with a carved leaf-shaped emerald crystal held in the right hand).
2. Araknéa (forest spider-beetle with an emerald armored carapace, curved horns, sharp mandibles and six legs).
3. Loup forestier (sturdy wolf with dark moss-green fur, a mane of leaves and twigs, amber eyes).
4. Dryade (dryad archer whose body is made of branches and leaves, wooden bow, leafy hair).
5. Tréant (walking tree trunk brute covered in moss and leaves, root-like legs, glowing green eyes).
6. the final boss Tharok le Végétal (towering forest giant with a body of bark and moss, great deer antlers covered in leaves, a long beard of hanging moss, wielding a thorny wooden club set with a green crystal), about 1.5x taller than the others.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Druide — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `druide_vues.png` et `druide_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held in hand in every cell, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Druide (hero of the Sylvestre nation)
- Hair: messy short dark green hair (#2E5E3A) with a few small leaves in it
- Eyes: amber eyes (#E0A030), always open
- Skin: light peach skin
- Top: armor-robe of overlapping moss-green leaves (#5E8C3A) and brown bark plates (#6B4A2B)
- Bottom: dark brown trousers (#4A3420)
- Feet: brown leather boots wrapped with green cloth
- Weapon: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand
- Details: two crossed leather belts on the chest
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no cape, no blond hair, no blue clothes.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand — the character visibly HOLDS it in every cell; hands are never empty.
REMINDER: this is Druide: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand; messy short dark green hair (#2E5E3A) with a few small leaves in it; amber eyes (#E0A030), always open; armor-robe of overlapping moss-green leaves (#5E8C3A) and brown bark plates (#6B4A2B); light peach skin; dark brown trousers (#4A3420); brown leather boots wrapped with green cloth; two crossed leather belts on the chest. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no cape, no blond hair, no blue clothes.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `druide.png` |
| 1-2 | 3/4 dos droite | `druide_back.png` |
| 2-1 | 3/4 dos gauche | `druide_back_left.png` |
| 2-2 | 3/4 avant gauche | `druide_face_left.png` |

##### Édition corrective (arme manquante sur des cases)

Si l'arme manque sur certaines cases de la planche générée : édition avec la planche `vues` en image source. Ce prompt RÉPÈTE la liste des angles — une édition corrective qui ne la répète pas aplatit toutes les vues dans le même angle.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE playable hero, Druide, several times, in the SAME relaxed idle pose seen from DIFFERENT viewing angles (successive quarter turns of the character, the camera fixed).
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Druide (hero of the Sylvestre nation)
- Hair: messy short dark green hair (#2E5E3A) with a few small leaves in it
- Eyes: amber eyes (#E0A030), always open
- Skin: light peach skin
- Top: armor-robe of overlapping moss-green leaves (#5E8C3A) and brown bark plates (#6B4A2B)
- Bottom: dark brown trousers (#4A3420)
- Feet: brown leather boots wrapped with green cloth
- Weapon: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand
- Details: two crossed leather belts on the chest
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no cape, no blond hair, no blue clothes.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWING ANGLES: every sprite keeps its own DIFFERENT viewing angle; the angles must NOT become identical. Never redraw the whole sheet from a single angle. The character turns in place by exact quarter turns between sprites:
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
WEAPON CHECK: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand — the character visibly HOLDS it in every cell; hands are never empty.
CHANGE NOTHING ELSE: keep the exact same characters, poses, sizes, outfits, hair, background and layout. Only add the missing weapon in the correct hand.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Druide: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand; messy short dark green hair (#2E5E3A) with a few small leaves in it; amber eyes (#E0A030), always open; armor-robe of overlapping moss-green leaves (#5E8C3A) and brown bark plates (#6B4A2B); light peach skin; dark brown trousers (#4A3420); brown leather boots wrapped with green cloth; two crossed leather belts on the chest. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no cape, no blond hair, no blue clothes.
```

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE playable hero, Druide, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Druide (hero of the Sylvestre nation)
- Hair: messy short dark green hair (#2E5E3A) with a few small leaves in it
- Eyes: amber eyes (#E0A030), always open
- Skin: light peach skin
- Top: armor-robe of overlapping moss-green leaves (#5E8C3A) and brown bark plates (#6B4A2B)
- Bottom: dark brown trousers (#4A3420)
- Feet: brown leather boots wrapped with green cloth
- Weapon: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand
- Details: two crossed leather belts on the chest
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no cape, no blond hair, no blue clothes.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
3. FOCUS: eyes closed, staff held vertically in front of the face, green leaves and glowing spores orb at the top.
4. Seen from BEHIND, the SAME action as pose 1 — OVERHEAD STRIKE: staff raised high above the head with both hands.
5. Seen from BEHIND, the SAME action as pose 2 — SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
6. Seen from BEHIND, the SAME action as pose 3 — FOCUS: eyes closed, staff held vertically in front of the face, green leaves and glowing spores orb at the top.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Druide: tall wooden staff topped with a leaf-shaped emerald crystal (#3FD08A), RIGHT hand; messy short dark green hair (#2E5E3A) with a few small leaves in it; amber eyes (#E0A030), always open; armor-robe of overlapping moss-green leaves (#5E8C3A) and brown bark plates (#6B4A2B); light peach skin; dark brown trousers (#4A3420); brown leather boots wrapped with green cloth; two crossed leather belts on the chest. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no hood, no cape, no blond hair, no blue clothes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `druide_attack.png` |
| 1-2 | attaque 2 — face | `druide_attack_2.png` |
| 1-3 | sort — face | `druide_cast.png` |
| 2-1 | attaque 1 — dos | `druide_attack_back.png` |
| 2-2 | attaque 2 — dos | `druide_attack_2_back.png` |
| 2-3 | sort — dos | `druide_cast_back.png` |

L'export Zimut de l'Atelier copie aussi le repos (case 1 de la planche vues) vers `nations/heros/druide.png`.

## 3. Ennemis

### Araknéa — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sylvestre/` ; nomme tes images `araknea_vues.png` et `araknea_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held in hand in every cell, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Araknéa (enemy of the Sylvestre nation)
- Body: forest spider-beetle with six thin dark-brown legs (#3B2A1E) and a domed emerald armored carapace (#2FA060) with lighter green edges
- Head: two curved ivory horns, sharp brown mandibles, four small glowing amber eyes (#F2B233)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no eight legs, no wings, no human body, no weapon.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Araknéa: forest spider-beetle with six thin dark-brown legs (#3B2A1E) and a domed emerald armored carapace (#2FA060) with lighter green edges; two curved ivory horns, sharp brown mandibles, four small glowing amber eyes (#F2B233). The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no eight legs, no wings, no human body, no weapon.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `araknea.png` |
| 1-2 | 3/4 dos droite | `araknea_back.png` |
| 2-1 | 3/4 dos gauche | `araknea_back_left.png` |
| 2-2 | 3/4 avant gauche | `araknea_face_left.png` |

##### Édition corrective (arme manquante sur des cases)

Si l'arme manque sur certaines cases de la planche générée : édition avec la planche `vues` en image source. Ce prompt RÉPÈTE la liste des angles — une édition corrective qui ne la répète pas aplatit toutes les vues dans le même angle.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Araknéa, several times, in the SAME relaxed idle pose seen from DIFFERENT viewing angles (successive quarter turns of the character, the camera fixed).
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Araknéa (enemy of the Sylvestre nation)
- Body: forest spider-beetle with six thin dark-brown legs (#3B2A1E) and a domed emerald armored carapace (#2FA060) with lighter green edges
- Head: two curved ivory horns, sharp brown mandibles, four small glowing amber eyes (#F2B233)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no eight legs, no wings, no human body, no weapon.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWING ANGLES: every sprite keeps its own DIFFERENT viewing angle; the angles must NOT become identical. Never redraw the whole sheet from a single angle. The character turns in place by exact quarter turns between sprites:
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
CHANGE NOTHING ELSE: keep the exact same characters, poses, sizes, outfits, hair, background and layout. Only add the missing weapon in the correct hand.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Araknéa: forest spider-beetle with six thin dark-brown legs (#3B2A1E) and a domed emerald armored carapace (#2FA060) with lighter green edges; two curved ivory horns, sharp brown mandibles, four small glowing amber eyes (#F2B233). The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no eight legs, no wings, no human body, no weapon.
```

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Araknéa, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Araknéa (enemy of the Sylvestre nation)
- Body: forest spider-beetle with six thin dark-brown legs (#3B2A1E) and a domed emerald armored carapace (#2FA060) with lighter green edges
- Head: two curved ivory horns, sharp brown mandibles, four small glowing amber eyes (#F2B233)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no eight legs, no wings, no human body, no weapon.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. SIDE SWIPE: head and claws swept to the side, body twisted.
3. HOWL: head raised to the sky, green leaves and glowing spores gathering around the body.
4. Seen from BEHIND, the SAME action as pose 1 — REARING: standing up on the hind legs, front claws raised high.
5. Seen from BEHIND, the SAME action as pose 2 — SIDE SWIPE: head and claws swept to the side, body twisted.
6. Seen from BEHIND, the SAME action as pose 3 — HOWL: head raised to the sky, green leaves and glowing spores gathering around the body.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Araknéa: forest spider-beetle with six thin dark-brown legs (#3B2A1E) and a domed emerald armored carapace (#2FA060) with lighter green edges; two curved ivory horns, sharp brown mandibles, four small glowing amber eyes (#F2B233). The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no eight legs, no wings, no human body, no weapon.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `araknea_attack.png` |
| 1-2 | attaque 2 — face | `araknea_attack_2.png` |
| 1-3 | sort — face | `araknea_cast.png` |
| 2-1 | attaque 1 — dos | `araknea_attack_back.png` |
| 2-2 | attaque 2 — dos | `araknea_attack_2_back.png` |
| 2-3 | sort — dos | `araknea_cast_back.png` |

### Loup forestier — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sylvestre/` ; nomme tes images `loup_forestier_vues.png` et `loup_forestier_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held in hand in every cell, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Loup forestier (enemy of the Sylvestre nation)
- Body: sturdy four-legged wolf with dark moss-green fur (#3E5E34) and a lighter sage belly
- Head: mane of green leaves and brown twigs around the neck, amber eyes (#E0A030), black nose
- Details: bushy tail tipped with leaves
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no armor, no rider, no grey or brown fur, never standing on two legs.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Loup forestier: sturdy four-legged wolf with dark moss-green fur (#3E5E34) and a lighter sage belly; mane of green leaves and brown twigs around the neck, amber eyes (#E0A030), black nose; bushy tail tipped with leaves. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no armor, no rider, no grey or brown fur, never standing on two legs.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `loup_forestier.png` |
| 1-2 | 3/4 dos droite | `loup_forestier_back.png` |
| 2-1 | 3/4 dos gauche | `loup_forestier_back_left.png` |
| 2-2 | 3/4 avant gauche | `loup_forestier_face_left.png` |

##### Édition corrective (arme manquante sur des cases)

Si l'arme manque sur certaines cases de la planche générée : édition avec la planche `vues` en image source. Ce prompt RÉPÈTE la liste des angles — une édition corrective qui ne la répète pas aplatit toutes les vues dans le même angle.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Loup forestier, several times, in the SAME relaxed idle pose seen from DIFFERENT viewing angles (successive quarter turns of the character, the camera fixed).
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Loup forestier (enemy of the Sylvestre nation)
- Body: sturdy four-legged wolf with dark moss-green fur (#3E5E34) and a lighter sage belly
- Head: mane of green leaves and brown twigs around the neck, amber eyes (#E0A030), black nose
- Details: bushy tail tipped with leaves
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no armor, no rider, no grey or brown fur, never standing on two legs.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWING ANGLES: every sprite keeps its own DIFFERENT viewing angle; the angles must NOT become identical. Never redraw the whole sheet from a single angle. The character turns in place by exact quarter turns between sprites:
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
CHANGE NOTHING ELSE: keep the exact same characters, poses, sizes, outfits, hair, background and layout. Only add the missing weapon in the correct hand.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Loup forestier: sturdy four-legged wolf with dark moss-green fur (#3E5E34) and a lighter sage belly; mane of green leaves and brown twigs around the neck, amber eyes (#E0A030), black nose; bushy tail tipped with leaves. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no armor, no rider, no grey or brown fur, never standing on two legs.
```

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Loup forestier, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Loup forestier (enemy of the Sylvestre nation)
- Body: sturdy four-legged wolf with dark moss-green fur (#3E5E34) and a lighter sage belly
- Head: mane of green leaves and brown twigs around the neck, amber eyes (#E0A030), black nose
- Details: bushy tail tipped with leaves
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no armor, no rider, no grey or brown fur, never standing on two legs.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. SIDE SWIPE: head and claws swept to the side, body twisted.
3. HOWL: head raised to the sky, green leaves and glowing spores gathering around the body.
4. Seen from BEHIND, the SAME action as pose 1 — REARING: standing up on the hind legs, front claws raised high.
5. Seen from BEHIND, the SAME action as pose 2 — SIDE SWIPE: head and claws swept to the side, body twisted.
6. Seen from BEHIND, the SAME action as pose 3 — HOWL: head raised to the sky, green leaves and glowing spores gathering around the body.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Loup forestier: sturdy four-legged wolf with dark moss-green fur (#3E5E34) and a lighter sage belly; mane of green leaves and brown twigs around the neck, amber eyes (#E0A030), black nose; bushy tail tipped with leaves. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no armor, no rider, no grey or brown fur, never standing on two legs.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `loup_forestier_attack.png` |
| 1-2 | attaque 2 — face | `loup_forestier_attack_2.png` |
| 1-3 | sort — face | `loup_forestier_cast.png` |
| 2-1 | attaque 1 — dos | `loup_forestier_attack_back.png` |
| 2-2 | attaque 2 — dos | `loup_forestier_attack_2_back.png` |
| 2-3 | sort — dos | `loup_forestier_cast_back.png` |

### Dryade — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sylvestre/` ; nomme tes images `dryade_vues.png` et `dryade_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held in hand in every cell, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Dryade (enemy of the Sylvestre nation)
- Body: slim dryad woman whose body is made of light-brown branches (#8A6238) and green leaves (#5FAE48)
- Head: long hair made of green leaves with small pink flowers, glowing green eyes (#7CFF8A)
- Weapon: simple wooden bow in the LEFT hand, no quiver
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no clothes, no metal, no human skin.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: simple wooden bow in the LEFT hand, no quiver — the character visibly HOLDS it in every cell; hands are never empty.
REMINDER: this is Dryade: simple wooden bow in the LEFT hand, no quiver; slim dryad woman whose body is made of light-brown branches (#8A6238) and green leaves (#5FAE48); long hair made of green leaves with small pink flowers, glowing green eyes (#7CFF8A). The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no clothes, no metal, no human skin.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `dryade.png` |
| 1-2 | 3/4 dos droite | `dryade_back.png` |
| 2-1 | 3/4 dos gauche | `dryade_back_left.png` |
| 2-2 | 3/4 avant gauche | `dryade_face_left.png` |

##### Édition corrective (arme manquante sur des cases)

Si l'arme manque sur certaines cases de la planche générée : édition avec la planche `vues` en image source. Ce prompt RÉPÈTE la liste des angles — une édition corrective qui ne la répète pas aplatit toutes les vues dans le même angle.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Dryade, several times, in the SAME relaxed idle pose seen from DIFFERENT viewing angles (successive quarter turns of the character, the camera fixed).
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Dryade (enemy of the Sylvestre nation)
- Body: slim dryad woman whose body is made of light-brown branches (#8A6238) and green leaves (#5FAE48)
- Head: long hair made of green leaves with small pink flowers, glowing green eyes (#7CFF8A)
- Weapon: simple wooden bow in the LEFT hand, no quiver
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no clothes, no metal, no human skin.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWING ANGLES: every sprite keeps its own DIFFERENT viewing angle; the angles must NOT become identical. Never redraw the whole sheet from a single angle. The character turns in place by exact quarter turns between sprites:
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
WEAPON CHECK: simple wooden bow in the LEFT hand, no quiver — the character visibly HOLDS it in every cell; hands are never empty.
CHANGE NOTHING ELSE: keep the exact same characters, poses, sizes, outfits, hair, background and layout. Only add the missing weapon in the correct hand.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Dryade: simple wooden bow in the LEFT hand, no quiver; slim dryad woman whose body is made of light-brown branches (#8A6238) and green leaves (#5FAE48); long hair made of green leaves with small pink flowers, glowing green eyes (#7CFF8A). The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no clothes, no metal, no human skin.
```

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Dryade, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Dryade (enemy of the Sylvestre nation)
- Body: slim dryad woman whose body is made of light-brown branches (#8A6238) and green leaves (#5FAE48)
- Head: long hair made of green leaves with small pink flowers, glowing green eyes (#7CFF8A)
- Weapon: simple wooden bow in the LEFT hand, no quiver
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no clothes, no metal, no human skin.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. SKY SHOT: bow pointed almost straight up, string fully drawn.
2. RELEASE: string hand open behind, bow arm extended, arrow leaving with a green leaves and glowing spores trail.
3. ENCHANTED ARROW: arrow held up to the face, its tip wrapped in green leaves and glowing spores.
4. Seen from BEHIND, the SAME action as pose 1 — SKY SHOT: bow pointed almost straight up, string fully drawn.
5. Seen from BEHIND, the SAME action as pose 2 — RELEASE: string hand open behind, bow arm extended, arrow leaving with a green leaves and glowing spores trail.
6. Seen from BEHIND, the SAME action as pose 3 — ENCHANTED ARROW: arrow held up to the face, its tip wrapped in green leaves and glowing spores.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Dryade: simple wooden bow in the LEFT hand, no quiver; slim dryad woman whose body is made of light-brown branches (#8A6238) and green leaves (#5FAE48); long hair made of green leaves with small pink flowers, glowing green eyes (#7CFF8A). The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no clothes, no metal, no human skin.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `dryade_attack.png` |
| 1-2 | attaque 2 — face | `dryade_attack_2.png` |
| 1-3 | sort — face | `dryade_cast.png` |
| 2-1 | attaque 1 — dos | `dryade_attack_back.png` |
| 2-2 | attaque 2 — dos | `dryade_attack_2_back.png` |
| 2-3 | sort — dos | `dryade_cast_back.png` |

### Tréant — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sylvestre/` ; nomme tes images `treant_vues.png` et `treant_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held in hand in every cell, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tréant (enemy of the Sylvestre nation)
- Body: walking tree-trunk brute of dark brown bark (#5A3E26) covered in green moss (#4F7A32)
- Head: no neck, a face carved in the trunk with two glowing green eyes (#7CFF8A) and a crooked mouth, leafy crown on top
- Details: two thick branch arms, root-like legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no armor, no flowers.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tréant: walking tree-trunk brute of dark brown bark (#5A3E26) covered in green moss (#4F7A32); no neck, a face carved in the trunk with two glowing green eyes (#7CFF8A) and a crooked mouth, leafy crown on top; two thick branch arms, root-like legs. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no weapon, no armor, no flowers.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `treant.png` |
| 1-2 | 3/4 dos droite | `treant_back.png` |
| 2-1 | 3/4 dos gauche | `treant_back_left.png` |
| 2-2 | 3/4 avant gauche | `treant_face_left.png` |

##### Édition corrective (arme manquante sur des cases)

Si l'arme manque sur certaines cases de la planche générée : édition avec la planche `vues` en image source. Ce prompt RÉPÈTE la liste des angles — une édition corrective qui ne la répète pas aplatit toutes les vues dans le même angle.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Tréant, several times, in the SAME relaxed idle pose seen from DIFFERENT viewing angles (successive quarter turns of the character, the camera fixed).
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tréant (enemy of the Sylvestre nation)
- Body: walking tree-trunk brute of dark brown bark (#5A3E26) covered in green moss (#4F7A32)
- Head: no neck, a face carved in the trunk with two glowing green eyes (#7CFF8A) and a crooked mouth, leafy crown on top
- Details: two thick branch arms, root-like legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no armor, no flowers.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWING ANGLES: every sprite keeps its own DIFFERENT viewing angle; the angles must NOT become identical. Never redraw the whole sheet from a single angle. The character turns in place by exact quarter turns between sprites:
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
CHANGE NOTHING ELSE: keep the exact same characters, poses, sizes, outfits, hair, background and layout. Only add the missing weapon in the correct hand.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Tréant: walking tree-trunk brute of dark brown bark (#5A3E26) covered in green moss (#4F7A32); no neck, a face carved in the trunk with two glowing green eyes (#7CFF8A) and a crooked mouth, leafy crown on top; two thick branch arms, root-like legs. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no weapon, no armor, no flowers.
```

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Tréant, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tréant (enemy of the Sylvestre nation)
- Body: walking tree-trunk brute of dark brown bark (#5A3E26) covered in green moss (#4F7A32)
- Head: no neck, a face carved in the trunk with two glowing green eyes (#7CFF8A) and a crooked mouth, leafy crown on top
- Details: two thick branch arms, root-like legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no armor, no flowers.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. BACKHAND: arm swept horizontally to the side, torso twisted.
3. ROOTED: stomping, green leaves and glowing spores cracks spreading under the feet.
4. Seen from BEHIND, the SAME action as pose 1 — OVERHEAD SMASH: both fists or weapon raised high above the head.
5. Seen from BEHIND, the SAME action as pose 2 — BACKHAND: arm swept horizontally to the side, torso twisted.
6. Seen from BEHIND, the SAME action as pose 3 — ROOTED: stomping, green leaves and glowing spores cracks spreading under the feet.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tréant: walking tree-trunk brute of dark brown bark (#5A3E26) covered in green moss (#4F7A32); no neck, a face carved in the trunk with two glowing green eyes (#7CFF8A) and a crooked mouth, leafy crown on top; two thick branch arms, root-like legs. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no weapon, no armor, no flowers.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `treant_attack.png` |
| 1-2 | attaque 2 — face | `treant_attack_2.png` |
| 1-3 | sort — face | `treant_cast.png` |
| 2-1 | attaque 1 — dos | `treant_attack_back.png` |
| 2-2 | attaque 2 — dos | `treant_attack_2_back.png` |
| 2-3 | sort — dos | `treant_cast_back.png` |

## 4. Boss

### Tharok le Végétal — 10 poses

2 planches : **vues** (4 angles en quarts de tour), puis **actions** (2 attaques + 1 sort, chacune vue de face puis de dos). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage et la même arme sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `sylvestre_vues.png` et `sylvestre_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 4 angles (`vues`)

Génération normale, aucune image à joindre. La caméra ne bouge pas : le personnage tourne sur lui-même par quarts de tour — 2 vues plutôt de face, 2 plutôt de dos.

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times: the SAME relaxed idle pose (standing calm, weapon held in hand in every cell, eyes open) seen from 4 viewing angles. The CAMERA never moves: it stays fixed in front of the character while the character TURNS IN PLACE by exact quarter turns (90 degrees) between cells — same distance, same height, same framing, only the character rotates. The 4 sprites have EXACTLY the same size: same scale, same height, same proportions in every cell.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tharok le Végétal (boss of the Sylvestre nation)
- Body: towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32)
- Head: great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes
- Weapon: thorny wooden club set with a green crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no armor, no metal.
WEAPON LOCK: the character HOLDS its weapon in its hand in EVERY cell — the hands are NEVER empty, the weapon is always visible on the drawing. The weapon and every accessory (quiver, scarf, cape, floating items) are IDENTICAL in all 4 cells: same shape, same color, same details, same hand as written in the ID card. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop, hide or omit it. The weapon matches the character's class.
Keep exactly the same design in every cell: same outfit, colors, proportions. Only the viewing angle changes from cell to cell.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, one per cell — follow the grid positions EXACTLY (successive quarter turns of the character, the camera stays fixed; the character's design and weapon never change; never a pure side profile):
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
All 4 cells show ONE character in ONE pose under 4 angles: TOP-LEFT and BOTTOM-RIGHT rather from the front, TOP-RIGHT and BOTTOM-LEFT rather from the back. Same height, same stance, same weapon held in the same hand everywhere. The pose does not change, only the angle — each turn is exactly a quarter turn, no more, no less.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: thorny wooden club set with a green crystal, RIGHT hand — the character visibly HOLDS it in every cell; hands are never empty.
REMINDER: this is Tharok le Végétal: thorny wooden club set with a green crystal, RIGHT hand; towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32); great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no armor, no metal.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | 3/4 avant droite | `sylvestre.png` |
| 1-2 | 3/4 dos droite | `sylvestre_back.png` |
| 2-1 | 3/4 dos gauche | `sylvestre_back_left.png` |
| 2-2 | 3/4 avant gauche | `sylvestre_face_left.png` |

##### Édition corrective (arme manquante sur des cases)

Si l'arme manque sur certaines cases de la planche générée : édition avec la planche `vues` en image source. Ce prompt RÉPÈTE la liste des angles — une édition corrective qui ne la répète pas aplatit toutes les vues dans le même angle.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE final boss, Tharok le Végétal, several times, in the SAME relaxed idle pose seen from DIFFERENT viewing angles (successive quarter turns of the character, the camera fixed).
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tharok le Végétal (boss of the Sylvestre nation)
- Body: towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32)
- Head: great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes
- Weapon: thorny wooden club set with a green crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no armor, no metal.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWING ANGLES: every sprite keeps its own DIFFERENT viewing angle; the angles must NOT become identical. Never redraw the whole sheet from a single angle. The character turns in place by exact quarter turns between sprites:
1. TOP-LEFT cell: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible.
2. TOP-RIGHT cell: 3/4 BACK view: the character has made ONE exact quarter turn to the right — seen from behind, back of the head and right shoulder visible, facing away toward the upper right; no face, no eyes; NOT a pure side profile (a side profile means the turn went too far).
3. BOTTOM-LEFT cell: 3/4 BACK view: the character has made TWO exact quarter turns — seen from behind, back of the head and left shoulder visible, facing away toward the upper left; no face, no eyes; NOT a pure side profile.
4. BOTTOM-RIGHT cell: 3/4 FRONT view: the character has made THREE exact quarter turns — faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left; both eyes visible.
WEAPON CHECK: thorny wooden club set with a green crystal, RIGHT hand — the character visibly HOLDS it in every cell; hands are never empty.
CHANGE NOTHING ELSE: keep the exact same characters, poses, sizes, outfits, hair, background and layout. Only add the missing weapon in the correct hand.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Tharok le Végétal: thorny wooden club set with a green crystal, RIGHT hand; towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32); great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no armor, no metal.
```

#### Planche 2 — Actions · 2 attaques + 1 sort, face et dos (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE final boss, Tharok le Végétal, in 4 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tharok le Végétal (boss of the Sylvestre nation)
- Body: towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32)
- Head: great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes
- Weapon: thorny wooden club set with a green crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no armor, no metal.
WEAPON LOCK: the weapon and every accessory stay EXACTLY as in the source image in all 6 poses: same shape, same color, same details, same hand. The weapon is held or used in EVERY pose — a cell without the weapon is wrong. Never replace the weapon with another weapon (a bow stays a bow, a staff stays a staff), never change its color or shape, never drop or hide it.
TASK: replace the 4 views with 6 ACTION poses: 3 different actions, each shown TWICE — once seen from the front, once seen from behind. TOP ROW (poses 1-3), all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. BOTTOM ROW (poses 4-6), all in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. BACKHAND: arm swept horizontally to the side, torso twisted.
3. ROOTED: stomping, green leaves and glowing spores cracks spreading under the feet.
4. Seen from BEHIND, the SAME action as pose 1 — OVERHEAD SMASH: both fists or weapon raised high above the head.
5. Seen from BEHIND, the SAME action as pose 2 — BACKHAND: arm swept horizontally to the side, torso twisted.
6. Seen from BEHIND, the SAME action as pose 3 — ROOTED: stomping, green leaves and glowing spores cracks spreading under the feet.
Poses 4-6 repeat poses 1-3 from behind: same action, same energy, same weapon, only the viewing angle changes. The 3 actions MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose in the same viewing angle; if two poses look alike, change one.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tharok le Végétal: thorny wooden club set with a green crystal, RIGHT hand; towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32); great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no armor, no metal.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — face | `sylvestre_attack.png` |
| 1-2 | attaque 2 — face | `sylvestre_attack_2.png` |
| 1-3 | sort — face | `sylvestre_cast.png` |
| 2-1 | attaque 1 — dos | `sylvestre_attack_back.png` |
| 2-2 | attaque 2 — dos | `sylvestre_attack_2_back.png` |
| 2-3 | sort — dos | `sylvestre_cast_back.png` |

## Prompt négatif

**Planches vues** (la même pose vue sous 4 angles est voulue, les vues vers la gauche aussi — le négatif commun est adapté) :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, one sprite bigger or smaller than the others, size changing between cells, more than 4 sprites, extra sprites, duplicated row of sprites, all sprites in the same viewing angle, all sprites in the same orientation, empty hands, character without its weapon in a cell, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, different character between cells, pose changing between cells, different outfit between angles, weapon changing shape, weapon changing color, weapon replaced by another weapon, missing weapon, missing accessories, realistic proportions, small head
```

**Planches actions et planche de style** (les actions répétées de dos en rangée 2 sont voulues : seules les répétitions sous le même angle sont interdites) :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, weapon changing shape, weapon changing color, weapon replaced by another weapon, missing weapon, missing accessories, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, different character between poses, realistic proportions, small head
```
