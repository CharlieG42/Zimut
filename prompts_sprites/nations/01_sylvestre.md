# Nation Sylvestre (Forêt)

Palette : moss green, bark brown, leaf gold, small emerald glows. Effets : green leaves and glowing spores. Contre-jour : warm golden sunlight.

Chaque personnage est dessiné en **vue 3/4 avant (face)** et en **vue 3/4 arrière (dos)**. Le jeu retourne l'image pour les directions vers la gauche. Une fiche de référence (repos face + dos), puis des planches de 4 poses (2 × 2) bien séparées. Prompt négatif : voir en bas de page.

Ordre conseillé : 1) planche de référence, 2) héros, 3) ennemis, 4) boss.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos. Joins-la comme image de référence à toutes les planches suivantes.

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

### Druide — 22 poses

6 planches, 22 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `druide_<clé>.png` (ex. `druide_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Druide », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE playable hero for a chibi isometric tactical RPG.
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
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows. Signature effects (keep them small): green leaves and glowing spores.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Druide: messy short dark green hair (#2E5E3A) with a few small leaves in it; amber eyes (#E0A030), always open; light peach skin; armor-robe of overlapping moss-green leaves (#5E8C3A) and brown bark plates (#6B4A2B). Forbidden: no hood, no cape, no blond hair, no blue clothes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `druide.png` |
| 1-2 | repos 1 (dos) | `druide_back.png` |

#### Planche 2 — Face 1 · garde, marche, sort (`face_1`)

Dans l'Atelier : personnage « Druide », planche « Face 1 · garde, marche, sort ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
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
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. GUARD: knees bent, weapon raised in front of the body, ready to fight.
2. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
3. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
4. FOCUS: eyes closed, staff held vertically in front of the face, green leaves and glowing spores orb at the top.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Druide: messy short dark green hair (#2E5E3A) with a few small leaves in it; amber eyes (#E0A030), always open; light peach skin; armor-robe of overlapping moss-green leaves (#5E8C3A) and brown bark plates (#6B4A2B). Forbidden: no hood, no cape, no blond hair, no blue clothes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 2 | `druide_idle_2.png` |
| 1-2 | marche 1 | `druide_walk.png` |
| 2-1 | marche 2 | `druide_walk_2.png` |
| 2-2 | sort 1 | `druide_cast.png` |

#### Planche 3 — Face 2 · attaques 1 à 4 (`face_2`)

Dans l'Atelier : personnage « Druide », planche « Face 2 · attaques 1 à 4 ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
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
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short green leaves and glowing spores spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. JUMPING STRIKE: whole body in the air, staff held back over the shoulder.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Druide: messy short dark green hair (#2E5E3A) with a few small leaves in it; amber eyes (#E0A030), always open; light peach skin; armor-robe of overlapping moss-green leaves (#5E8C3A) and brown bark plates (#6B4A2B). Forbidden: no hood, no cape, no blond hair, no blue clothes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `druide_attack.png` |
| 1-2 | attaque 2 | `druide_attack_2.png` |
| 2-1 | attaque 3 | `druide_attack_3.png` |
| 2-2 | attaque 4 | `druide_attack_4.png` |

#### Planche 4 — Face 3 · attaques 5-6, sorts 2-3 (`face_3`)

Dans l'Atelier : personnage « Druide », planche « Face 3 · attaques 5-6, sorts 2-3 ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
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
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. LOW SWEEP: crouched, staff swinging at ankle height.
2. SPIN: staff whirling around the body, a green leaves and glowing spores trail circling it.
3. INVOCATION: staff raised high with both hands, green leaves and glowing spores swirling above the head.
4. BLAST: staff pointed forward, a compact green leaves and glowing spores blast leaving the tip.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Druide: messy short dark green hair (#2E5E3A) with a few small leaves in it; amber eyes (#E0A030), always open; light peach skin; armor-robe of overlapping moss-green leaves (#5E8C3A) and brown bark plates (#6B4A2B). Forbidden: no hood, no cape, no blond hair, no blue clothes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 5 | `druide_attack_5.png` |
| 1-2 | attaque 6 | `druide_attack_6.png` |
| 2-1 | sort 2 | `druide_cast_2.png` |
| 2-2 | sort 3 | `druide_cast_3.png` |

#### Planche 5 — Dos 1 · marche, attaque, sort (`dos_1`)

Dans l'Atelier : personnage « Druide », planche « Dos 1 · marche, attaque, sort ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
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
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
3. OVERHEAD STRIKE: staff raised high above the head with both hands.
4. FOCUS: eyes closed, staff held vertically in front of the face, green leaves and glowing spores orb at the top.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Druide: messy short dark green hair (#2E5E3A) with a few small leaves in it; amber eyes (#E0A030), always open; light peach skin; armor-robe of overlapping moss-green leaves (#5E8C3A) and brown bark plates (#6B4A2B). Forbidden: no hood, no cape, no blond hair, no blue clothes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `druide_back_walk.png` |
| 1-2 | marche 2 | `druide_back_walk_2.png` |
| 2-1 | attaque 1 | `druide_back_attack.png` |
| 2-2 | sort 1 | `druide_back_cast.png` |

#### Planche 6 — Dos 2 · attaques 2 à 4, garde (`dos_2`)

Dans l'Atelier : personnage « Druide », planche « Dos 2 · attaques 2 à 4, garde ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
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
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. THRUST: body leaning forward, staff tip pushed far ahead with a short green leaves and glowing spores spark.
2. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
3. JUMPING STRIKE: whole body in the air, staff held back over the shoulder.
4. GUARD: knees bent, weapon raised in front of the body, ready to fight.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Druide: messy short dark green hair (#2E5E3A) with a few small leaves in it; amber eyes (#E0A030), always open; light peach skin; armor-robe of overlapping moss-green leaves (#5E8C3A) and brown bark plates (#6B4A2B). Forbidden: no hood, no cape, no blond hair, no blue clothes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 2 | `druide_back_attack_2.png` |
| 1-2 | attaque 3 | `druide_back_attack_3.png` |
| 2-1 | attaque 4 | `druide_back_attack_4.png` |
| 2-2 | repos 2 | `druide_back_idle_2.png` |

L'export Zimut de l'Atelier copie aussi le repos vers `nations/heros/druide.png` et les autres poses vers `nations/heros/poses/`.

## 3. Ennemis

### Araknéa — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sylvestre/` ; nomme tes images `araknea_<clé>.png` (ex. `araknea_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Araknéa », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Araknéa (enemy of the Sylvestre nation)
- Look: forest spider-beetle with an emerald armored carapace, curved horns, sharp mandibles and six legs
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows. Signature effects (keep them small): green leaves and glowing spores.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Araknéa: forest spider-beetle with an emerald armored carapace, curved horns, sharp mandibles and six legs.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `araknea.png` |
| 1-2 | repos 1 (dos) | `araknea_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Araknéa », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Araknéa (enemy of the Sylvestre nation)
- Look: forest spider-beetle with an emerald armored carapace, curved horns, sharp mandibles and six legs
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. REARING: standing up on the hind legs, front claws raised high.
3. POUNCE: body stretched forward in the air, jaws open.
4. HOWL: head raised to the sky, green leaves and glowing spores gathering around the body.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Araknéa: forest spider-beetle with an emerald armored carapace, curved horns, sharp mandibles and six legs.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `araknea_walk.png` |
| 1-2 | attaque 1 | `araknea_attack.png` |
| 2-1 | attaque 2 | `araknea_attack_2.png` |
| 2-2 | sort 1 | `araknea_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Araknéa », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Araknéa (enemy of the Sylvestre nation)
- Look: forest spider-beetle with an emerald armored carapace, curved horns, sharp mandibles and six legs
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. REARING: standing up on the hind legs, front claws raised high.
3. POUNCE: body stretched forward in the air, jaws open.
4. HOWL: head raised to the sky, green leaves and glowing spores gathering around the body.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Araknéa: forest spider-beetle with an emerald armored carapace, curved horns, sharp mandibles and six legs.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `araknea_back_walk.png` |
| 1-2 | attaque 1 | `araknea_back_attack.png` |
| 2-1 | attaque 2 | `araknea_back_attack_2.png` |
| 2-2 | sort 1 | `araknea_back_cast.png` |

### Loup forestier — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sylvestre/` ; nomme tes images `loup_forestier_<clé>.png` (ex. `loup_forestier_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Loup forestier », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Loup forestier (enemy of the Sylvestre nation)
- Look: sturdy wolf with dark moss-green fur, a mane of leaves and twigs, amber eyes
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows. Signature effects (keep them small): green leaves and glowing spores.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Loup forestier: sturdy wolf with dark moss-green fur, a mane of leaves and twigs, amber eyes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `loup_forestier.png` |
| 1-2 | repos 1 (dos) | `loup_forestier_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Loup forestier », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Loup forestier (enemy of the Sylvestre nation)
- Look: sturdy wolf with dark moss-green fur, a mane of leaves and twigs, amber eyes
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. REARING: standing up on the hind legs, front claws raised high.
3. POUNCE: body stretched forward in the air, jaws open.
4. HOWL: head raised to the sky, green leaves and glowing spores gathering around the body.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Loup forestier: sturdy wolf with dark moss-green fur, a mane of leaves and twigs, amber eyes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `loup_forestier_walk.png` |
| 1-2 | attaque 1 | `loup_forestier_attack.png` |
| 2-1 | attaque 2 | `loup_forestier_attack_2.png` |
| 2-2 | sort 1 | `loup_forestier_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Loup forestier », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Loup forestier (enemy of the Sylvestre nation)
- Look: sturdy wolf with dark moss-green fur, a mane of leaves and twigs, amber eyes
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. REARING: standing up on the hind legs, front claws raised high.
3. POUNCE: body stretched forward in the air, jaws open.
4. HOWL: head raised to the sky, green leaves and glowing spores gathering around the body.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Loup forestier: sturdy wolf with dark moss-green fur, a mane of leaves and twigs, amber eyes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `loup_forestier_back_walk.png` |
| 1-2 | attaque 1 | `loup_forestier_back_attack.png` |
| 2-1 | attaque 2 | `loup_forestier_back_attack_2.png` |
| 2-2 | sort 1 | `loup_forestier_back_cast.png` |

### Dryade — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sylvestre/` ; nomme tes images `dryade_<clé>.png` (ex. `dryade_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Dryade », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Dryade (enemy of the Sylvestre nation)
- Look: dryad archer whose body is made of branches and leaves, wooden bow, leafy hair
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows. Signature effects (keep them small): green leaves and glowing spores.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Dryade: dryad archer whose body is made of branches and leaves, wooden bow, leafy hair.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `dryade.png` |
| 1-2 | repos 1 (dos) | `dryade_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Dryade », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Dryade (enemy of the Sylvestre nation)
- Look: dryad archer whose body is made of branches and leaves, wooden bow, leafy hair
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. SKY SHOT: bow pointed almost straight up, string fully drawn.
3. FULL DRAW: bow aimed straight forward, string pulled to the cheek, body sideways.
4. ENCHANTED ARROW: arrow held up to the face, its tip wrapped in green leaves and glowing spores.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Dryade: dryad archer whose body is made of branches and leaves, wooden bow, leafy hair.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `dryade_walk.png` |
| 1-2 | attaque 1 | `dryade_attack.png` |
| 2-1 | attaque 2 | `dryade_attack_2.png` |
| 2-2 | sort 1 | `dryade_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Dryade », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Dryade (enemy of the Sylvestre nation)
- Look: dryad archer whose body is made of branches and leaves, wooden bow, leafy hair
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. SKY SHOT: bow pointed almost straight up, string fully drawn.
3. FULL DRAW: bow aimed straight forward, string pulled to the cheek, body sideways.
4. ENCHANTED ARROW: arrow held up to the face, its tip wrapped in green leaves and glowing spores.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Dryade: dryad archer whose body is made of branches and leaves, wooden bow, leafy hair.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `dryade_back_walk.png` |
| 1-2 | attaque 1 | `dryade_back_attack.png` |
| 2-1 | attaque 2 | `dryade_back_attack_2.png` |
| 2-2 | sort 1 | `dryade_back_cast.png` |

### Tréant — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sylvestre/` ; nomme tes images `treant_<clé>.png` (ex. `treant_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Tréant », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tréant (enemy of the Sylvestre nation)
- Look: walking tree trunk brute covered in moss and leaves, root-like legs, glowing green eyes
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows. Signature effects (keep them small): green leaves and glowing spores.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tréant: walking tree trunk brute covered in moss and leaves, root-like legs, glowing green eyes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `treant.png` |
| 1-2 | repos 1 (dos) | `treant_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Tréant », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tréant (enemy of the Sylvestre nation)
- Look: walking tree trunk brute covered in moss and leaves, root-like legs, glowing green eyes
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. OVERHEAD SMASH: both fists or weapon raised high above the head.
3. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward.
4. ROOTED: stomping, green leaves and glowing spores cracks spreading under the feet.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tréant: walking tree trunk brute covered in moss and leaves, root-like legs, glowing green eyes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `treant_walk.png` |
| 1-2 | attaque 1 | `treant_attack.png` |
| 2-1 | attaque 2 | `treant_attack_2.png` |
| 2-2 | sort 1 | `treant_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Tréant », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tréant (enemy of the Sylvestre nation)
- Look: walking tree trunk brute covered in moss and leaves, root-like legs, glowing green eyes
- Every color, eye color, hairstyle, outfit piece and weapon named above is fixed; do not add any piece of clothing, color or accessory that is not named.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. OVERHEAD SMASH: both fists or weapon raised high above the head.
3. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward.
4. ROOTED: stomping, green leaves and glowing spores cracks spreading under the feet.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tréant: walking tree trunk brute covered in moss and leaves, root-like legs, glowing green eyes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `treant_back_walk.png` |
| 1-2 | attaque 1 | `treant_back_attack.png` |
| 2-1 | attaque 2 | `treant_back_attack_2.png` |
| 2-2 | sort 1 | `treant_back_cast.png` |

## 4. Boss

### Tharok le Végétal — 22 poses

6 planches, 22 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `sylvestre_<clé>.png` (ex. `sylvestre_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Tharok le Végétal », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tharok le Végétal (boss of the Sylvestre nation)
- Body: towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32)
- Head: great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes
- Weapon: thorny wooden club set with a green crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no armor, no metal.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows. Signature effects (keep them small): green leaves and glowing spores.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tharok le Végétal: towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32); great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes; thorny wooden club set with a green crystal, RIGHT hand. Forbidden: no armor, no metal.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `sylvestre.png` |
| 1-2 | repos 1 (dos) | `sylvestre_back.png` |

#### Planche 2 — Face 1 · garde, marche, sort (`face_1`)

Dans l'Atelier : personnage « Tharok le Végétal », planche « Face 1 · garde, marche, sort ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tharok le Végétal (boss of the Sylvestre nation)
- Body: towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32)
- Head: great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes
- Weapon: thorny wooden club set with a green crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no armor, no metal.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. GUARD: knees bent, weapon raised in front of the body, ready to fight.
2. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
3. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
4. ROOTED: stomping, green leaves and glowing spores cracks spreading under the feet.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tharok le Végétal: towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32); great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes; thorny wooden club set with a green crystal, RIGHT hand. Forbidden: no armor, no metal.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 2 | `sylvestre_idle_2.png` |
| 1-2 | marche 1 | `sylvestre_walk.png` |
| 2-1 | marche 2 | `sylvestre_walk_2.png` |
| 2-2 | sort 1 | `sylvestre_cast.png` |

#### Planche 3 — Face 2 · attaques 1 à 4 (`face_2`)

Dans l'Atelier : personnage « Tharok le Végétal », planche « Face 2 · attaques 1 à 4 ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tharok le Végétal (boss of the Sylvestre nation)
- Body: towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32)
- Head: great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes
- Weapon: thorny wooden club set with a green crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no armor, no metal.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. OVERHEAD SMASH: both fists or weapon raised high above the head.
2. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward.
3. BACKHAND: arm swept horizontally to the side, torso twisted.
4. JUMPING SLAM: whole body in the air, fists above the head.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tharok le Végétal: towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32); great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes; thorny wooden club set with a green crystal, RIGHT hand. Forbidden: no armor, no metal.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `sylvestre_attack.png` |
| 1-2 | attaque 2 | `sylvestre_attack_2.png` |
| 2-1 | attaque 3 | `sylvestre_attack_3.png` |
| 2-2 | attaque 4 | `sylvestre_attack_4.png` |

#### Planche 4 — Face 3 · attaques 5-6, sorts 2-3 (`face_3`)

Dans l'Atelier : personnage « Tharok le Végétal », planche « Face 3 · attaques 5-6, sorts 2-3 ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tharok le Végétal (boss of the Sylvestre nation)
- Body: towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32)
- Head: great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes
- Weapon: thorny wooden club set with a green crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no armor, no metal.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. STOMP: one foot raised then slammed down, green leaves and glowing spores cracks under it.
2. CHARGE: shoulder first, body leaning far forward, running.
3. GATHER: arms raised, green leaves and glowing spores gathering between the hands.
4. SHOCKWAVE: both fists slammed into the ground, green leaves and glowing spores wave.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tharok le Végétal: towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32); great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes; thorny wooden club set with a green crystal, RIGHT hand. Forbidden: no armor, no metal.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 5 | `sylvestre_attack_5.png` |
| 1-2 | attaque 6 | `sylvestre_attack_6.png` |
| 2-1 | sort 2 | `sylvestre_cast_2.png` |
| 2-2 | sort 3 | `sylvestre_cast_3.png` |

#### Planche 5 — Dos 1 · marche, attaque, sort (`dos_1`)

Dans l'Atelier : personnage « Tharok le Végétal », planche « Dos 1 · marche, attaque, sort ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tharok le Végétal (boss of the Sylvestre nation)
- Body: towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32)
- Head: great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes
- Weapon: thorny wooden club set with a green crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no armor, no metal.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
3. OVERHEAD SMASH: both fists or weapon raised high above the head.
4. ROOTED: stomping, green leaves and glowing spores cracks spreading under the feet.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tharok le Végétal: towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32); great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes; thorny wooden club set with a green crystal, RIGHT hand. Forbidden: no armor, no metal.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `sylvestre_back_walk.png` |
| 1-2 | marche 2 | `sylvestre_back_walk_2.png` |
| 2-1 | attaque 1 | `sylvestre_back_attack.png` |
| 2-2 | sort 1 | `sylvestre_back_cast.png` |

#### Planche 6 — Dos 2 · attaques 2 à 4, garde (`dos_2`)

Dans l'Atelier : personnage « Tharok le Végétal », planche « Dos 2 · attaques 2 à 4, garde ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Tharok le Végétal (boss of the Sylvestre nation)
- Body: towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32)
- Head: great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes
- Weapon: thorny wooden club set with a green crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no armor, no metal.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. PUNCH: one arm thrust far forward, the other pulled back, body leaning forward.
2. BACKHAND: arm swept horizontally to the side, torso twisted.
3. JUMPING SLAM: whole body in the air, fists above the head.
4. GUARD: knees bent, weapon raised in front of the body, ready to fight.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Tharok le Végétal: towering forest giant with a body of brown bark (#5A3E26) and green moss (#4F7A32); great deer antlers covered in leaves, long beard of hanging moss, glowing green eyes; thorny wooden club set with a green crystal, RIGHT hand. Forbidden: no armor, no metal.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 2 | `sylvestre_back_attack_2.png` |
| 1-2 | attaque 3 | `sylvestre_back_attack_3.png` |
| 2-1 | attaque 4 | `sylvestre_back_attack_4.png` |
| 2-2 | repos 2 | `sylvestre_back_idle_2.png` |

## Prompt négatif (toutes les planches de cette page)

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses, identical poses, repeated pose, copy of the same pose, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, front and back views mixed, different character between poses, realistic proportions, small head
```
