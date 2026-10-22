# Nation Sables (Désert)

Palette : sand gold, terracotta, amber, small turquoise accents. Effets : swirling sand and amber shards. Contre-jour : warm golden.

Format 2 planches par personnage :

1. **Vues** — le personnage au repos vu sous 6 angles (face, 3/4 avant droite, 3/4 dos droite, dos, 3/4 dos gauche, 3/4 avant gauche), grille 3 × 2 sur image 2:1, poses largement espacées. Un seul angle par case : aucun doublon possible.
2. **Actions** — 3 attaques + 3 sorts en vue 3/4 avant, générées **en édition** de la planche vues (image source = planche vues) : le personnage réellement dessiné sert d'ancre, il ne peut pas changer d'une planche à l'autre. Repli : génération normale (la carte d'identité est recopiée dans chaque prompt).

Chaque prompt recopie la carte d'identité du personnage (`identites.py`) : aucune image à joindre. Ordre conseillé : 1) planche de style, 2) héros, 3) ennemis, 4) boss ; pour chaque personnage : vues puis actions. Prompt négatif : en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Sables nation (Désert biome).
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents. Signature effects: swirling sand and amber shards.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: two rows with the same 6 characters in the same order, all in idle pose. Top row: 3/4 front view, facing front-right. Bottom row: 3/4 back view, seen from behind, turned toward the upper right. All feet of a row on the same ground line. Leave a wide empty gap (at least half a character width) between characters and between the two rows: nobody overlaps or touches anyone, weapons and capes included. Image aspect ratio 2:1, as large as possible.
CHARACTERS, left to right:
1. the hero (Géomancien: young geomancer with short brown hair, layered sand-gold robe with terracotta panels and amber gems, sandals and wraps, a golden staff topped with a large faceted amber crystal in the right hand).
2. Bandit des dunes (small desert jackal-folk bandit with orange fur, a sand-colored scarf and a curved dagger).
3. Scarabée géant (giant scarab beetle with a black and gold shell and golden horns).
4. Génie du désert (golden sand djinn with muscular arms and a lower body of swirling sand).
5. Sphinx (golden lion sphinx wearing a striped pharaoh headdress).
6. the final boss Zahor le Sableux (sand sovereign in ornate golden armor with sharp layered plates, crested golden helm, holding a tall golden staff with a giant amber crystal), about 1.5x taller than the others.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Géomancien — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `geomancien_vues.png` et `geomancien_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Géomancien (hero of the Sables nation)
- Hair: short brown hair (#7A4A28)
- Eyes: amber-brown eyes, always open
- Skin: light tan skin
- Top: layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and small amber gems
- Bottom: sand-colored wrapped trousers
- Feet: brown sandals with cloth wraps
- Weapon: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no turban, no blue or green clothes.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Géomancien: short brown hair (#7A4A28); amber-brown eyes, always open; light tan skin; layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and small amber gems. Forbidden: no hood, no turban, no blue or green clothes.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `geomancien.png` |
| 1-2 | 3/4 avant droite | `geomancien_face_right.png` |
| 1-3 | 3/4 dos droite | `geomancien_back_right.png` |
| 2-1 | dos complet | `geomancien_back.png` |
| 2-2 | 3/4 dos gauche | `geomancien_back_left.png` |
| 2-3 | 3/4 avant gauche | `geomancien_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE playable hero, Géomancien, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Géomancien (hero of the Sables nation)
- Hair: short brown hair (#7A4A28)
- Eyes: amber-brown eyes, always open
- Skin: light tan skin
- Top: layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and small amber gems
- Bottom: sand-colored wrapped trousers
- Feet: brown sandals with cloth wraps
- Weapon: golden staff topped with a large faceted amber crystal (#F2A93B), RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no hood, no turban, no blue or green clothes.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short swirling sand and amber shards spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. FOCUS: eyes closed, staff held vertically in front of the face, swirling sand and amber shards orb at the top.
5. INVOCATION: staff raised high with both hands, swirling sand and amber shards swirling above the head.
6. BLAST: staff pointed forward, a compact swirling sand and amber shards blast leaving the tip.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Géomancien: short brown hair (#7A4A28); amber-brown eyes, always open; light tan skin; layered sand-gold robe (#D9B26A) with terracotta panels (#B8562E) and small amber gems. Forbidden: no hood, no turban, no blue or green clothes.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `geomancien_attack.png` |
| 1-2 | attaque 2 | `geomancien_attack_2.png` |
| 1-3 | attaque 3 | `geomancien_attack_3.png` |
| 2-1 | sort 1 | `geomancien_cast.png` |
| 2-2 | sort 2 | `geomancien_cast_2.png` |
| 2-3 | sort 3 | `geomancien_cast_3.png` |

L'export Zimut de l'Atelier copie aussi le repos (case 1 de la planche vues) vers `nations/heros/geomancien.png`.

## 3. Ennemis

### Bandit des dunes — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sables/` ; nomme tes images `bandit_des_dunes_vues.png` et `bandit_des_dunes_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Bandit des dunes (enemy of the Sables nation)
- Body: small jackal-folk bandit standing on two legs, orange fur (#D9822B) with a cream muzzle
- Head: tall jackal ears, yellow eyes, sand-colored scarf (#E3CF9A) over the mouth
- Top: brown leather vest with a red sash
- Bottom: baggy sand-colored trousers, bare paws
- Weapon: one curved dagger in the RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no bow, no sword, no hood, no human face.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Bandit des dunes: small jackal-folk bandit standing on two legs, orange fur (#D9822B) with a cream muzzle; tall jackal ears, yellow eyes, sand-colored scarf (#E3CF9A) over the mouth; brown leather vest with a red sash; baggy sand-colored trousers, bare paws. Forbidden: no bow, no sword, no hood, no human face.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `bandit_des_dunes.png` |
| 1-2 | 3/4 avant droite | `bandit_des_dunes_face_right.png` |
| 1-3 | 3/4 dos droite | `bandit_des_dunes_back_right.png` |
| 2-1 | dos complet | `bandit_des_dunes_back.png` |
| 2-2 | 3/4 dos gauche | `bandit_des_dunes_back_left.png` |
| 2-3 | 3/4 avant gauche | `bandit_des_dunes_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Bandit des dunes, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Bandit des dunes (enemy of the Sables nation)
- Body: small jackal-folk bandit standing on two legs, orange fur (#D9822B) with a cream muzzle
- Head: tall jackal ears, yellow eyes, sand-colored scarf (#E3CF9A) over the mouth
- Top: brown leather vest with a red sash
- Bottom: baggy sand-colored trousers, bare paws
- Weapon: one curved dagger in the RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no bow, no sword, no hood, no human face.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. CROSS SLASH: both daggers crossed high above the head, about to strike down.
2. LUNGE STAB: body stretched forward almost horizontal, one dagger thrust far ahead.
3. SPIN: body twisted, arms spread to both sides, short swirling sand and amber shards slash arcs.
4. SHADOW KNEEL: kneeling, one hand on the ground, swirling sand and amber shards rising around.
5. VANISH: half the body dissolving into swirling sand and amber shards, only the eyes and daggers clear.
6. MARK: one arm pointing forward, a swirling sand and amber shards sigil appearing in front of the hand.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Bandit des dunes: small jackal-folk bandit standing on two legs, orange fur (#D9822B) with a cream muzzle; tall jackal ears, yellow eyes, sand-colored scarf (#E3CF9A) over the mouth; brown leather vest with a red sash; baggy sand-colored trousers, bare paws. Forbidden: no bow, no sword, no hood, no human face.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `bandit_des_dunes_attack.png` |
| 1-2 | attaque 2 | `bandit_des_dunes_attack_2.png` |
| 1-3 | attaque 3 | `bandit_des_dunes_attack_3.png` |
| 2-1 | sort 1 | `bandit_des_dunes_cast.png` |
| 2-2 | sort 2 | `bandit_des_dunes_cast_2.png` |
| 2-3 | sort 3 | `bandit_des_dunes_cast_3.png` |

### Scarabée géant — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sables/` ; nomme tes images `scarabee_geant_vues.png` et `scarabee_geant_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Scarabée géant (enemy of the Sables nation)
- Body: giant scarab beetle on six legs, glossy black shell (#1A1A1E) with gold edges and patterns (#E0B040)
- Head: big golden horn and two smaller golden horns, small red eyes
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings spread, no rider, no human body.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Scarabée géant: giant scarab beetle on six legs, glossy black shell (#1A1A1E) with gold edges and patterns (#E0B040); big golden horn and two smaller golden horns, small red eyes. Forbidden: no wings spread, no rider, no human body.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `scarabee_geant.png` |
| 1-2 | 3/4 avant droite | `scarabee_geant_face_right.png` |
| 1-3 | 3/4 dos droite | `scarabee_geant_back_right.png` |
| 2-1 | dos complet | `scarabee_geant_back.png` |
| 2-2 | 3/4 dos gauche | `scarabee_geant_back_left.png` |
| 2-3 | 3/4 avant gauche | `scarabee_geant_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Scarabée géant, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Scarabée géant (enemy of the Sables nation)
- Body: giant scarab beetle on six legs, glossy black shell (#1A1A1E) with gold edges and patterns (#E0B040)
- Head: big golden horn and two smaller golden horns, small red eyes
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings spread, no rider, no human body.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. POUNCE: body stretched forward in the air, jaws open.
3. SIDE SWIPE: head and claws swept to the side, body twisted.
4. HOWL: head raised to the sky, swirling sand and amber shards gathering around the body.
5. ROAR: mouth wide open, swirling sand and amber shards burst in front of the head.
6. BREATH: a short swirling sand and amber shards breath released forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Scarabée géant: giant scarab beetle on six legs, glossy black shell (#1A1A1E) with gold edges and patterns (#E0B040); big golden horn and two smaller golden horns, small red eyes. Forbidden: no wings spread, no rider, no human body.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `scarabee_geant_attack.png` |
| 1-2 | attaque 2 | `scarabee_geant_attack_2.png` |
| 1-3 | attaque 3 | `scarabee_geant_attack_3.png` |
| 2-1 | sort 1 | `scarabee_geant_cast.png` |
| 2-2 | sort 2 | `scarabee_geant_cast_2.png` |
| 2-3 | sort 3 | `scarabee_geant_cast_3.png` |

### Génie du désert — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sables/` ; nomme tes images `genie_du_desert_vues.png` et `genie_du_desert_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Génie du désert (enemy of the Sables nation)
- Body: golden-skinned sand djinn (#E0B050) with a muscular bare chest and arms, golden bracelets
- Head: bald head with a long black topknot, glowing amber eyes, pointed ears
- Bottom: no legs: lower body of swirling sand (#D9C08A)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no blue skin, no clothes on the torso.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Génie du désert: golden-skinned sand djinn (#E0B050) with a muscular bare chest and arms, golden bracelets; bald head with a long black topknot, glowing amber eyes, pointed ears; no legs: lower body of swirling sand (#D9C08A). Forbidden: no weapon, no blue skin, no clothes on the torso.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `genie_du_desert.png` |
| 1-2 | 3/4 avant droite | `genie_du_desert_face_right.png` |
| 1-3 | 3/4 dos droite | `genie_du_desert_back_right.png` |
| 2-1 | dos complet | `genie_du_desert_back.png` |
| 2-2 | 3/4 dos gauche | `genie_du_desert_back_left.png` |
| 2-3 | 3/4 avant gauche | `genie_du_desert_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Génie du désert, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Génie du désert (enemy of the Sables nation)
- Body: golden-skinned sand djinn (#E0B050) with a muscular bare chest and arms, golden bracelets
- Head: bald head with a long black topknot, glowing amber eyes, pointed ears
- Bottom: no legs: lower body of swirling sand (#D9C08A)
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no weapon, no blue skin, no clothes on the torso.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. LUNGE: body stretched forward, claws of swirling sand and amber shards reaching out.
3. SPIN: body whirling, swirling sand and amber shards trail around it.
4. HOVER: floating higher, swirling sand and amber shards orbs circling.
5. PULSE: arms spread, swirling sand and amber shards pulsing outward.
6. WAVE: a compact swirling sand and amber shards wave released forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Génie du désert: golden-skinned sand djinn (#E0B050) with a muscular bare chest and arms, golden bracelets; bald head with a long black topknot, glowing amber eyes, pointed ears; no legs: lower body of swirling sand (#D9C08A). Forbidden: no weapon, no blue skin, no clothes on the torso.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `genie_du_desert_attack.png` |
| 1-2 | attaque 2 | `genie_du_desert_attack_2.png` |
| 1-3 | attaque 3 | `genie_du_desert_attack_3.png` |
| 2-1 | sort 1 | `genie_du_desert_cast.png` |
| 2-2 | sort 2 | `genie_du_desert_cast_2.png` |
| 2-3 | sort 3 | `genie_du_desert_cast_3.png` |

### Sphinx — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/sables/` ; nomme tes images `sphinx_vues.png` et `sphinx_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sphinx (enemy of the Sables nation)
- Body: golden lion sphinx on four legs (#D9A848) with a lion tail
- Head: human-like calm face, striped blue-and-gold pharaoh headdress (#2E56A8, #E0B040), kohl-lined amber eyes
- Details: small golden collar, no wings
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no weapon, standing on four legs only.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Sphinx: golden lion sphinx on four legs (#D9A848) with a lion tail; human-like calm face, striped blue-and-gold pharaoh headdress (#2E56A8, #E0B040), kohl-lined amber eyes; small golden collar, no wings. Forbidden: no wings, no weapon, standing on four legs only.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `sphinx.png` |
| 1-2 | 3/4 avant droite | `sphinx_face_right.png` |
| 1-3 | 3/4 dos droite | `sphinx_back_right.png` |
| 2-1 | dos complet | `sphinx_back.png` |
| 2-2 | 3/4 dos gauche | `sphinx_back_left.png` |
| 2-3 | 3/4 avant gauche | `sphinx_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE enemy monster, Sphinx, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sphinx (enemy of the Sables nation)
- Body: golden lion sphinx on four legs (#D9A848) with a lion tail
- Head: human-like calm face, striped blue-and-gold pharaoh headdress (#2E56A8, #E0B040), kohl-lined amber eyes
- Details: small golden collar, no wings
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no wings, no weapon, standing on four legs only.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. POUNCE: body stretched forward in the air, jaws open.
3. SIDE SWIPE: head and claws swept to the side, body twisted.
4. HOWL: head raised to the sky, swirling sand and amber shards gathering around the body.
5. ROAR: mouth wide open, swirling sand and amber shards burst in front of the head.
6. BREATH: a short swirling sand and amber shards breath released forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Sphinx: golden lion sphinx on four legs (#D9A848) with a lion tail; human-like calm face, striped blue-and-gold pharaoh headdress (#2E56A8, #E0B040), kohl-lined amber eyes; small golden collar, no wings. Forbidden: no wings, no weapon, standing on four legs only.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `sphinx_attack.png` |
| 1-2 | attaque 2 | `sphinx_attack_2.png` |
| 1-3 | attaque 3 | `sphinx_attack_3.png` |
| 2-1 | sort 1 | `sphinx_cast.png` |
| 2-2 | sort 2 | `sphinx_cast_2.png` |
| 2-3 | sort 3 | `sphinx_cast_3.png` |

## 4. Boss

### Zahor le Sableux — 12 poses

2 planches : **vues** (6 angles), puis **actions** (3 attaques + 3 sorts). La planche actions se génère **en édition** de la planche vues (image source = planche vues de ce personnage) : c'est ce qui garantit le même personnage sur les deux planches. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `sables_vues.png` et `sables_actions.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 6 angles (`vues`)

Génération normale, aucune image à joindre.

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 6 times: the SAME relaxed idle pose (standing calm, weapon held calmly, eyes open) seen from 6 different viewing angles.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Zahor le Sableux (boss of the Sables nation)
- Body: sand sovereign in ornate golden armor (#D4A63A) with sharp layered plates
- Head: crested golden helm, dark face shadow with glowing amber eyes
- Weapon: tall golden staff with a giant amber crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no cape, no sword.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand. Only the viewing angle changes from cell to cell.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
VIEWS, left to right, top to bottom (the camera turns around the character; the character's design never changes; never a pure side profile):
1. FRONT view: the character stands squared to the viewer and looks straight at the camera; the full face and both eyes are clearly visible.
2. 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right.
3. 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes.
4. FULL BACK view: the character is seen exactly from behind, back of the head and back of the outfit visible; no face, no eyes.
5. 3/4 BACK view: the character is seen from behind and turns slightly to the left (back of the head and left shoulder visible), facing away from the viewer toward the upper left; we see the BACK of the head: no face, no eyes.
6. 3/4 FRONT view: the character faces the viewer and turns slightly to the left (face, chest and left side visible), facing front-left.
All 6 cells show ONE character in ONE pose under 6 angles: same height, same stance, same weapon in the same hand everywhere. The pose does not change, only the angle.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Zahor le Sableux: sand sovereign in ornate golden armor (#D4A63A) with sharp layered plates; crested golden helm, dark face shadow with glowing amber eyes; tall golden staff with a giant amber crystal, RIGHT hand. Forbidden: no cape, no sword.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | face (regard vers le spectateur) | `sables.png` |
| 1-2 | 3/4 avant droite | `sables_face_right.png` |
| 1-3 | 3/4 dos droite | `sables_back_right.png` |
| 2-1 | dos complet | `sables_back.png` |
| 2-2 | 3/4 dos gauche | `sables_back_left.png` |
| 2-3 | 3/4 avant gauche | `sables_face_left.png` |

#### Planche 2 — Actions · 3 attaques + 3 sorts (`actions`)

**Édition d'image** : source = la planche `vues` ci-dessus (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit for a chibi isometric tactical RPG sprite sheet.
SOURCE IMAGE: it shows ONE final boss, Zahor le Sableux, in 6 different views. Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Zahor le Sableux (boss of the Sables nation)
- Body: sand sovereign in ornate golden armor (#D4A63A) with sharp layered plates
- Head: crested golden helm, dark face shadow with glowing amber eyes
- Weapon: tall golden staff with a giant amber crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no cape, no sword.
TASK: replace the 6 views with 6 ACTION poses, all in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never a back view.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: same as the source image — 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short swirling sand and amber shards spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. FOCUS: eyes closed, staff held vertically in front of the face, swirling sand and amber shards orb at the top.
5. INVOCATION: staff raised high with both hands, swirling sand and amber shards swirling above the head.
6. BLAST: staff pointed forward, a compact swirling sand and amber shards blast leaving the tip.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Zahor le Sableux: sand sovereign in ornate golden armor (#D4A63A) with sharp layered plates; crested golden helm, dark face shadow with glowing amber eyes; tall golden staff with a giant amber crystal, RIGHT hand. Forbidden: no cape, no sword.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `sables_attack.png` |
| 1-2 | attaque 2 | `sables_attack_2.png` |
| 1-3 | attaque 3 | `sables_attack_3.png` |
| 2-1 | sort 1 | `sables_cast.png` |
| 2-2 | sort 2 | `sables_cast_2.png` |
| 2-3 | sort 3 | `sables_cast_3.png` |

## Prompt négatif

**Planches vues** (la même pose vue sous 6 angles est voulue, les vues vers la gauche aussi — le négatif commun est adapté) :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, different character between cells, pose changing between cells, different outfit between angles, realistic proportions, small head
```

**Planches actions et planche de style** :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses, identical poses, repeated pose, copy of the same pose, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, front and back views mixed, different character between poses, realistic proportions, small head
```
