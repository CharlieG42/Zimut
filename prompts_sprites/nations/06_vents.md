# Nation Vents (Vents)

Palette : pale teal, silver, sky white, mint. Effets : wind ribbons and feathers. Contre-jour : pale sky white.

Chaque personnage est dessiné en **vue 3/4 avant (face)** et en **vue 3/4 arrière (dos)**. Le jeu retourne l'image pour les directions vers la gauche. Une fiche de référence (repos face + dos), puis des planches de 4 poses (2 × 2) bien séparées. Prompt négatif : voir en bas de page.

Ordre conseillé : 1) planche de référence, 2) héros, 3) ennemis, 4) boss.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos. Joins-la comme image de référence à toutes les planches suivantes.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Vents nation (Vents biome).
NATION PALETTE: pale teal, silver, sky white, mint. Signature effects: wind ribbons and feathers.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: two rows with the same 6 characters in the same order, all in idle pose. Top row: 3/4 front view, facing front-right. Bottom row: 3/4 back view, seen from behind, turned toward the upper right. All feet of a row on the same ground line. Leave a wide empty gap (at least half a character width) between characters and between the two rows: nobody overlaps or touches anyone, weapons and capes included. Image aspect ratio 2:1, as large as possible.
CHARACTERS, left to right:
1. the hero (Sylvain: nature-wind guardian with silver-teal hair, robe of pale teal layered leaves and feathers, silver bracers, a staff topped with a wing-shaped mint crystal in the right hand).
2. Garde aérien (sky guard in blue and silver armor with small wings on the helmet, holding a halberd).
3. Aigle céleste (large deep blue eagle with golden talons and spread wings).
4. Harpie (harpy with green and gold feathered wings for arms and bird legs).
5. Élémentaire de vent (swirling pale blue wind spirit with a round cloud body and small arms of wind).
6. the final boss Aéron le Céleste (celestial lord in pale cyan feathered armor with long flowing layers, crown of silver spikes, holding a tall silver staff with a wing crystal), about 1.5x taller than the others.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Sylvain — 22 poses

6 planches, 22 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `sylvain_<clé>.png` (ex. `sylvain_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Sylvain », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sylvain (hero of the Vents nation)
- Hair: short messy pale mint-white hair (#DDF2EE) with long bangs over the forehead
- Eyes: teal-green eyes (#2E9C94), always open, calm smile
- Skin: light peach skin
- Top: pale teal tunic (#9FE0D6) made of layered leaf-shaped feathers, white collar and a white front panel, small gold leaf brooch on the chest
- Bottom: pale teal and white layered skirt-robe down to the knees, dark charcoal leggings (#33383F)
- Feet: white boots with gold trims
- Arms: silver bracers on both forearms
- Weapon: slim brown wooden staff topped with a mint crystal (#7FF0D8) between two small white wings, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no orange or brown trousers, no brown eyes, no closed eyes, no pure white spiky hair, no long hair, no blue robe, no spear.
NATION PALETTE: pale teal, silver, sky white, mint. Signature effects (keep them small): wind ribbons and feathers.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Sylvain: short messy pale mint-white hair (#DDF2EE) with long bangs over the forehead; teal-green eyes (#2E9C94), always open, calm smile; light peach skin; pale teal tunic (#9FE0D6) made of layered leaf-shaped feathers, white collar and a white front panel, small gold leaf brooch on the chest. Forbidden: no orange or brown trousers, no brown eyes, no closed eyes, no pure white spiky hair, no long hair, no blue robe, no spear.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `sylvain.png` |
| 1-2 | repos 1 (dos) | `sylvain_back.png` |

#### Planche 2 — Face 1 · garde, marche, sort (`face_1`)

Dans l'Atelier : personnage « Sylvain », planche « Face 1 · garde, marche, sort ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sylvain (hero of the Vents nation)
- Hair: short messy pale mint-white hair (#DDF2EE) with long bangs over the forehead
- Eyes: teal-green eyes (#2E9C94), always open, calm smile
- Skin: light peach skin
- Top: pale teal tunic (#9FE0D6) made of layered leaf-shaped feathers, white collar and a white front panel, small gold leaf brooch on the chest
- Bottom: pale teal and white layered skirt-robe down to the knees, dark charcoal leggings (#33383F)
- Feet: white boots with gold trims
- Arms: silver bracers on both forearms
- Weapon: slim brown wooden staff topped with a mint crystal (#7FF0D8) between two small white wings, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no orange or brown trousers, no brown eyes, no closed eyes, no pure white spiky hair, no long hair, no blue robe, no spear.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. GUARD: knees bent, weapon raised in front of the body, ready to fight.
2. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
3. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
4. FOCUS: eyes closed, staff held vertically in front of the face, wind ribbons and feathers orb at the top.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Sylvain: short messy pale mint-white hair (#DDF2EE) with long bangs over the forehead; teal-green eyes (#2E9C94), always open, calm smile; light peach skin; pale teal tunic (#9FE0D6) made of layered leaf-shaped feathers, white collar and a white front panel, small gold leaf brooch on the chest. Forbidden: no orange or brown trousers, no brown eyes, no closed eyes, no pure white spiky hair, no long hair, no blue robe, no spear.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 2 | `sylvain_idle_2.png` |
| 1-2 | marche 1 | `sylvain_walk.png` |
| 2-1 | marche 2 | `sylvain_walk_2.png` |
| 2-2 | sort 1 | `sylvain_cast.png` |

#### Planche 3 — Face 2 · attaques 1 à 4 (`face_2`)

Dans l'Atelier : personnage « Sylvain », planche « Face 2 · attaques 1 à 4 ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sylvain (hero of the Vents nation)
- Hair: short messy pale mint-white hair (#DDF2EE) with long bangs over the forehead
- Eyes: teal-green eyes (#2E9C94), always open, calm smile
- Skin: light peach skin
- Top: pale teal tunic (#9FE0D6) made of layered leaf-shaped feathers, white collar and a white front panel, small gold leaf brooch on the chest
- Bottom: pale teal and white layered skirt-robe down to the knees, dark charcoal leggings (#33383F)
- Feet: white boots with gold trims
- Arms: silver bracers on both forearms
- Weapon: slim brown wooden staff topped with a mint crystal (#7FF0D8) between two small white wings, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no orange or brown trousers, no brown eyes, no closed eyes, no pure white spiky hair, no long hair, no blue robe, no spear.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short wind ribbons and feathers spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. JUMPING STRIKE: whole body in the air, staff held back over the shoulder.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Sylvain: short messy pale mint-white hair (#DDF2EE) with long bangs over the forehead; teal-green eyes (#2E9C94), always open, calm smile; light peach skin; pale teal tunic (#9FE0D6) made of layered leaf-shaped feathers, white collar and a white front panel, small gold leaf brooch on the chest. Forbidden: no orange or brown trousers, no brown eyes, no closed eyes, no pure white spiky hair, no long hair, no blue robe, no spear.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `sylvain_attack.png` |
| 1-2 | attaque 2 | `sylvain_attack_2.png` |
| 2-1 | attaque 3 | `sylvain_attack_3.png` |
| 2-2 | attaque 4 | `sylvain_attack_4.png` |

#### Planche 4 — Face 3 · attaques 5-6, sorts 2-3 (`face_3`)

Dans l'Atelier : personnage « Sylvain », planche « Face 3 · attaques 5-6, sorts 2-3 ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sylvain (hero of the Vents nation)
- Hair: short messy pale mint-white hair (#DDF2EE) with long bangs over the forehead
- Eyes: teal-green eyes (#2E9C94), always open, calm smile
- Skin: light peach skin
- Top: pale teal tunic (#9FE0D6) made of layered leaf-shaped feathers, white collar and a white front panel, small gold leaf brooch on the chest
- Bottom: pale teal and white layered skirt-robe down to the knees, dark charcoal leggings (#33383F)
- Feet: white boots with gold trims
- Arms: silver bracers on both forearms
- Weapon: slim brown wooden staff topped with a mint crystal (#7FF0D8) between two small white wings, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no orange or brown trousers, no brown eyes, no closed eyes, no pure white spiky hair, no long hair, no blue robe, no spear.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. LOW SWEEP: crouched, staff swinging at ankle height.
2. SPIN: staff whirling around the body, a wind ribbons and feathers trail circling it.
3. INVOCATION: staff raised high with both hands, wind ribbons and feathers swirling above the head.
4. BLAST: staff pointed forward, a compact wind ribbons and feathers blast leaving the tip.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Sylvain: short messy pale mint-white hair (#DDF2EE) with long bangs over the forehead; teal-green eyes (#2E9C94), always open, calm smile; light peach skin; pale teal tunic (#9FE0D6) made of layered leaf-shaped feathers, white collar and a white front panel, small gold leaf brooch on the chest. Forbidden: no orange or brown trousers, no brown eyes, no closed eyes, no pure white spiky hair, no long hair, no blue robe, no spear.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 5 | `sylvain_attack_5.png` |
| 1-2 | attaque 6 | `sylvain_attack_6.png` |
| 2-1 | sort 2 | `sylvain_cast_2.png` |
| 2-2 | sort 3 | `sylvain_cast_3.png` |

#### Planche 5 — Dos 1 · marche, attaque, sort (`dos_1`)

Dans l'Atelier : personnage « Sylvain », planche « Dos 1 · marche, attaque, sort ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sylvain (hero of the Vents nation)
- Hair: short messy pale mint-white hair (#DDF2EE) with long bangs over the forehead
- Eyes: teal-green eyes (#2E9C94), always open, calm smile
- Skin: light peach skin
- Top: pale teal tunic (#9FE0D6) made of layered leaf-shaped feathers, white collar and a white front panel, small gold leaf brooch on the chest
- Bottom: pale teal and white layered skirt-robe down to the knees, dark charcoal leggings (#33383F)
- Feet: white boots with gold trims
- Arms: silver bracers on both forearms
- Weapon: slim brown wooden staff topped with a mint crystal (#7FF0D8) between two small white wings, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no orange or brown trousers, no brown eyes, no closed eyes, no pure white spiky hair, no long hair, no blue robe, no spear.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
3. OVERHEAD STRIKE: staff raised high above the head with both hands.
4. FOCUS: eyes closed, staff held vertically in front of the face, wind ribbons and feathers orb at the top.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Sylvain: short messy pale mint-white hair (#DDF2EE) with long bangs over the forehead; teal-green eyes (#2E9C94), always open, calm smile; light peach skin; pale teal tunic (#9FE0D6) made of layered leaf-shaped feathers, white collar and a white front panel, small gold leaf brooch on the chest. Forbidden: no orange or brown trousers, no brown eyes, no closed eyes, no pure white spiky hair, no long hair, no blue robe, no spear.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `sylvain_back_walk.png` |
| 1-2 | marche 2 | `sylvain_back_walk_2.png` |
| 2-1 | attaque 1 | `sylvain_back_attack.png` |
| 2-2 | sort 1 | `sylvain_back_cast.png` |

#### Planche 6 — Dos 2 · attaques 2 à 4, garde (`dos_2`)

Dans l'Atelier : personnage « Sylvain », planche « Dos 2 · attaques 2 à 4, garde ».

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Sylvain (hero of the Vents nation)
- Hair: short messy pale mint-white hair (#DDF2EE) with long bangs over the forehead
- Eyes: teal-green eyes (#2E9C94), always open, calm smile
- Skin: light peach skin
- Top: pale teal tunic (#9FE0D6) made of layered leaf-shaped feathers, white collar and a white front panel, small gold leaf brooch on the chest
- Bottom: pale teal and white layered skirt-robe down to the knees, dark charcoal leggings (#33383F)
- Feet: white boots with gold trims
- Arms: silver bracers on both forearms
- Weapon: slim brown wooden staff topped with a mint crystal (#7FF0D8) between two small white wings, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no orange or brown trousers, no brown eyes, no closed eyes, no pure white spiky hair, no long hair, no blue robe, no spear.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. THRUST: body leaning forward, staff tip pushed far ahead with a short wind ribbons and feathers spark.
2. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
3. JUMPING STRIKE: whole body in the air, staff held back over the shoulder.
4. GUARD: knees bent, weapon raised in front of the body, ready to fight.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Sylvain: short messy pale mint-white hair (#DDF2EE) with long bangs over the forehead; teal-green eyes (#2E9C94), always open, calm smile; light peach skin; pale teal tunic (#9FE0D6) made of layered leaf-shaped feathers, white collar and a white front panel, small gold leaf brooch on the chest. Forbidden: no orange or brown trousers, no brown eyes, no closed eyes, no pure white spiky hair, no long hair, no blue robe, no spear.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 2 | `sylvain_back_attack_2.png` |
| 1-2 | attaque 3 | `sylvain_back_attack_3.png` |
| 2-1 | attaque 4 | `sylvain_back_attack_4.png` |
| 2-2 | repos 2 | `sylvain_back_idle_2.png` |

L'export Zimut de l'Atelier copie aussi le repos vers `nations/heros/sylvain.png` et les autres poses vers `nations/heros/poses/`.

## 3. Ennemis

### Garde aérien — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/vents/` ; nomme tes images `garde_aerien_<clé>.png` (ex. `garde_aerien_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Garde aérien », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Garde aérien (enemy of the Vents nation)
- Body: small chibi sky guard, round body
- Head: round pale ice-blue helmet (#BFE6F0) with a short fin on top and two small white wings on the sides, a WHITE face mask with two big dark-red eyes (#8A1E1E)
- Top: pale ice-blue armor (#BFE6F0) with silver shoulder plates and a brown leather strap across the chest
- Bottom: pale ice-blue tabard over dark navy trousers (#2E3550)
- Feet: dark navy armored boots
- Weapon: halberd with a brown wooden shaft and a large silver axe blade, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visor, no spear, no cape, no human face.
NATION PALETTE: pale teal, silver, sky white, mint. Signature effects (keep them small): wind ribbons and feathers.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Garde aérien: small chibi sky guard, round body; round pale ice-blue helmet (#BFE6F0) with a short fin on top and two small white wings on the sides, a WHITE face mask with two big dark-red eyes (#8A1E1E); pale ice-blue armor (#BFE6F0) with silver shoulder plates and a brown leather strap across the chest; pale ice-blue tabard over dark navy trousers (#2E3550). Forbidden: no visor, no spear, no cape, no human face.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `garde_aerien.png` |
| 1-2 | repos 1 (dos) | `garde_aerien_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Garde aérien », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Garde aérien (enemy of the Vents nation)
- Body: small chibi sky guard, round body
- Head: round pale ice-blue helmet (#BFE6F0) with a short fin on top and two small white wings on the sides, a WHITE face mask with two big dark-red eyes (#8A1E1E)
- Top: pale ice-blue armor (#BFE6F0) with silver shoulder plates and a brown leather strap across the chest
- Bottom: pale ice-blue tabard over dark navy trousers (#2E3550)
- Feet: dark navy armored boots
- Weapon: halberd with a brown wooden shaft and a large silver axe blade, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visor, no spear, no cape, no human face.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. OVERHEAD STRIKE: staff raised high above the head with both hands.
3. THRUST: body leaning forward, staff tip pushed far ahead with a short wind ribbons and feathers spark.
4. FOCUS: eyes closed, staff held vertically in front of the face, wind ribbons and feathers orb at the top.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Garde aérien: small chibi sky guard, round body; round pale ice-blue helmet (#BFE6F0) with a short fin on top and two small white wings on the sides, a WHITE face mask with two big dark-red eyes (#8A1E1E); pale ice-blue armor (#BFE6F0) with silver shoulder plates and a brown leather strap across the chest; pale ice-blue tabard over dark navy trousers (#2E3550). Forbidden: no visor, no spear, no cape, no human face.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `garde_aerien_walk.png` |
| 1-2 | attaque 1 | `garde_aerien_attack.png` |
| 2-1 | attaque 2 | `garde_aerien_attack_2.png` |
| 2-2 | sort 1 | `garde_aerien_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Garde aérien », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Garde aérien (enemy of the Vents nation)
- Body: small chibi sky guard, round body
- Head: round pale ice-blue helmet (#BFE6F0) with a short fin on top and two small white wings on the sides, a WHITE face mask with two big dark-red eyes (#8A1E1E)
- Top: pale ice-blue armor (#BFE6F0) with silver shoulder plates and a brown leather strap across the chest
- Bottom: pale ice-blue tabard over dark navy trousers (#2E3550)
- Feet: dark navy armored boots
- Weapon: halberd with a brown wooden shaft and a large silver axe blade, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no visor, no spear, no cape, no human face.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. OVERHEAD STRIKE: staff raised high above the head with both hands.
3. THRUST: body leaning forward, staff tip pushed far ahead with a short wind ribbons and feathers spark.
4. FOCUS: eyes closed, staff held vertically in front of the face, wind ribbons and feathers orb at the top.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Garde aérien: small chibi sky guard, round body; round pale ice-blue helmet (#BFE6F0) with a short fin on top and two small white wings on the sides, a WHITE face mask with two big dark-red eyes (#8A1E1E); pale ice-blue armor (#BFE6F0) with silver shoulder plates and a brown leather strap across the chest; pale ice-blue tabard over dark navy trousers (#2E3550). Forbidden: no visor, no spear, no cape, no human face.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `garde_aerien_back_walk.png` |
| 1-2 | attaque 1 | `garde_aerien_back_attack.png` |
| 2-1 | attaque 2 | `garde_aerien_back_attack_2.png` |
| 2-2 | sort 1 | `garde_aerien_back_cast.png` |

### Aigle céleste — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/vents/` ; nomme tes images `aigle_celeste_<clé>.png` (ex. `aigle_celeste_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Aigle céleste », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Aigle céleste (enemy of the Vents nation)
- Body: large deep blue eagle (#1F4FA8) with lighter blue chest feathers
- Head: white-blue head, golden hooked beak, sharp yellow eyes
- Details: golden talons, wide spread wings
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no rider, no armor.
NATION PALETTE: pale teal, silver, sky white, mint. Signature effects (keep them small): wind ribbons and feathers.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Aigle céleste: large deep blue eagle (#1F4FA8) with lighter blue chest feathers; white-blue head, golden hooked beak, sharp yellow eyes; golden talons, wide spread wings. Forbidden: no rider, no armor.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `aigle_celeste.png` |
| 1-2 | repos 1 (dos) | `aigle_celeste_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Aigle céleste », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Aigle céleste (enemy of the Vents nation)
- Body: large deep blue eagle (#1F4FA8) with lighter blue chest feathers
- Head: white-blue head, golden hooked beak, sharp yellow eyes
- Details: golden talons, wide spread wings
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no rider, no armor.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. REARING: standing up on the hind legs, front claws raised high.
3. POUNCE: body stretched forward in the air, jaws open.
4. HOWL: head raised to the sky, wind ribbons and feathers gathering around the body.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Aigle céleste: large deep blue eagle (#1F4FA8) with lighter blue chest feathers; white-blue head, golden hooked beak, sharp yellow eyes; golden talons, wide spread wings. Forbidden: no rider, no armor.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `aigle_celeste_walk.png` |
| 1-2 | attaque 1 | `aigle_celeste_attack.png` |
| 2-1 | attaque 2 | `aigle_celeste_attack_2.png` |
| 2-2 | sort 1 | `aigle_celeste_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Aigle céleste », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Aigle céleste (enemy of the Vents nation)
- Body: large deep blue eagle (#1F4FA8) with lighter blue chest feathers
- Head: white-blue head, golden hooked beak, sharp yellow eyes
- Details: golden talons, wide spread wings
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no rider, no armor.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. REARING: standing up on the hind legs, front claws raised high.
3. POUNCE: body stretched forward in the air, jaws open.
4. HOWL: head raised to the sky, wind ribbons and feathers gathering around the body.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Aigle céleste: large deep blue eagle (#1F4FA8) with lighter blue chest feathers; white-blue head, golden hooked beak, sharp yellow eyes; golden talons, wide spread wings. Forbidden: no rider, no armor.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `aigle_celeste_back_walk.png` |
| 1-2 | attaque 1 | `aigle_celeste_back_attack.png` |
| 2-1 | attaque 2 | `aigle_celeste_back_attack_2.png` |
| 2-2 | sort 1 | `aigle_celeste_back_cast.png` |

### Harpie — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/vents/` ; nomme tes images `harpie_<clé>.png` (ex. `harpie_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Harpie », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Harpie (enemy of the Vents nation)
- Body: harpy woman with green and gold feathered wings (#3E9A5A, #E0B040) instead of arms
- Head: wild green hair, yellow eyes
- Bottom: bird legs with yellow talons, short green feather skirt
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human arms, no weapon.
NATION PALETTE: pale teal, silver, sky white, mint. Signature effects (keep them small): wind ribbons and feathers.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Harpie: harpy woman with green and gold feathered wings (#3E9A5A, #E0B040) instead of arms; wild green hair, yellow eyes; bird legs with yellow talons, short green feather skirt. Forbidden: no human arms, no weapon.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `harpie.png` |
| 1-2 | repos 1 (dos) | `harpie_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Harpie », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Harpie (enemy of the Vents nation)
- Body: harpy woman with green and gold feathered wings (#3E9A5A, #E0B040) instead of arms
- Head: wild green hair, yellow eyes
- Bottom: bird legs with yellow talons, short green feather skirt
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human arms, no weapon.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. RISE: body stretched tall upward, arms raised.
3. LUNGE: body stretched forward, claws of wind ribbons and feathers reaching out.
4. HOVER: floating higher, wind ribbons and feathers orbs circling.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Harpie: harpy woman with green and gold feathered wings (#3E9A5A, #E0B040) instead of arms; wild green hair, yellow eyes; bird legs with yellow talons, short green feather skirt. Forbidden: no human arms, no weapon.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `harpie_walk.png` |
| 1-2 | attaque 1 | `harpie_attack.png` |
| 2-1 | attaque 2 | `harpie_attack_2.png` |
| 2-2 | sort 1 | `harpie_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Harpie », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Harpie (enemy of the Vents nation)
- Body: harpy woman with green and gold feathered wings (#3E9A5A, #E0B040) instead of arms
- Head: wild green hair, yellow eyes
- Bottom: bird legs with yellow talons, short green feather skirt
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human arms, no weapon.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. RISE: body stretched tall upward, arms raised.
3. LUNGE: body stretched forward, claws of wind ribbons and feathers reaching out.
4. HOVER: floating higher, wind ribbons and feathers orbs circling.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Harpie: harpy woman with green and gold feathered wings (#3E9A5A, #E0B040) instead of arms; wild green hair, yellow eyes; bird legs with yellow talons, short green feather skirt. Forbidden: no human arms, no weapon.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `harpie_back_walk.png` |
| 1-2 | attaque 1 | `harpie_back_attack.png` |
| 2-1 | attaque 2 | `harpie_back_attack_2.png` |
| 2-2 | sort 1 | `harpie_back_cast.png` |

### Élémentaire de vent — 10 poses

3 planches, 10 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/vents/` ; nomme tes images `elementaire_de_vent_<clé>.png` (ex. `elementaire_de_vent_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Élémentaire de vent », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Élémentaire de vent (enemy of the Vents nation)
- Body: round pale blue cloud body (#CFEFFF) with swirling wind ribbons around it
- Head: two big friendly dark eyes on the cloud, no mouth
- Details: two small arms made of wind swirls, no legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human body, no weapon.
NATION PALETTE: pale teal, silver, sky white, mint. Signature effects (keep them small): wind ribbons and feathers.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Élémentaire de vent: round pale blue cloud body (#CFEFFF) with swirling wind ribbons around it; two big friendly dark eyes on the cloud, no mouth; two small arms made of wind swirls, no legs. Forbidden: no human body, no weapon.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `elementaire_de_vent.png` |
| 1-2 | repos 1 (dos) | `elementaire_de_vent_back.png` |

#### Planche 2 — Face · marche, 2 attaques, sort (`face_1`)

Dans l'Atelier : personnage « Élémentaire de vent », planche « Face · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Élémentaire de vent (enemy of the Vents nation)
- Body: round pale blue cloud body (#CFEFFF) with swirling wind ribbons around it
- Head: two big friendly dark eyes on the cloud, no mouth
- Details: two small arms made of wind swirls, no legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human body, no weapon.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. RISE: body stretched tall upward, arms raised.
3. LUNGE: body stretched forward, claws of wind ribbons and feathers reaching out.
4. HOVER: floating higher, wind ribbons and feathers orbs circling.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Élémentaire de vent: round pale blue cloud body (#CFEFFF) with swirling wind ribbons around it; two big friendly dark eyes on the cloud, no mouth; two small arms made of wind swirls, no legs. Forbidden: no human body, no weapon.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `elementaire_de_vent_walk.png` |
| 1-2 | attaque 1 | `elementaire_de_vent_attack.png` |
| 2-1 | attaque 2 | `elementaire_de_vent_attack_2.png` |
| 2-2 | sort 1 | `elementaire_de_vent_cast.png` |

#### Planche 3 — Dos · marche, 2 attaques, sort (`dos_1`)

Dans l'Atelier : personnage « Élémentaire de vent », planche « Dos · marche, 2 attaques, sort ».

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Élémentaire de vent (enemy of the Vents nation)
- Body: round pale blue cloud body (#CFEFFF) with swirling wind ribbons around it
- Head: two big friendly dark eyes on the cloud, no mouth
- Details: two small arms made of wind swirls, no legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human body, no weapon.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. RISE: body stretched tall upward, arms raised.
3. LUNGE: body stretched forward, claws of wind ribbons and feathers reaching out.
4. HOVER: floating higher, wind ribbons and feathers orbs circling.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Élémentaire de vent: round pale blue cloud body (#CFEFFF) with swirling wind ribbons around it; two big friendly dark eyes on the cloud, no mouth; two small arms made of wind swirls, no legs. Forbidden: no human body, no weapon.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `elementaire_de_vent_back_walk.png` |
| 1-2 | attaque 1 | `elementaire_de_vent_back_attack.png` |
| 2-1 | attaque 2 | `elementaire_de_vent_back_attack_2.png` |
| 2-2 | sort 1 | `elementaire_de_vent_back_cast.png` |

## 4. Boss

### Aéron le Céleste — 22 poses

6 planches, 22 poses. Commence par la fiche de référence. Chaque prompt recopie la carte d'identité du personnage : aucune image à joindre. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `vents_<clé>.png` (ex. `vents_face_2.png`) pour que l'Atelier les reconnaisse.

#### Planche 1 — Référence · repos de face + repos de dos (`ref`)

Dans l'Atelier : personnage « Aéron le Céleste », planche « Référence · repos de face + repos de dos ».

```text
Character reference sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Aéron le Céleste (boss of the Vents nation)
- Body: celestial lord in pale cyan feathered armor (#BDEFFF) with long flowing feather layers
- Head: crown of silver spikes, long white hair, pale blue eyes
- Weapon: tall silver staff with a wing-shaped crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no dark colors.
NATION PALETTE: pale teal, silver, sky white, mint. Signature effects (keep them small): wind ribbons and feathers.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: exactly 2 poses side by side on a 2:1 image (as large as possible, e.g. 2048x1024), like two separate stickers: each pose occupies at most 55% of its half of the image and is centered in it, with a wide empty space between them, feet on the same ground line. No frames, borders or dividing line.
POSES: 1. LEFT: idle pose in 3/4 FRONT view, facing the viewer and turned slightly to the right. 2. RIGHT: the same idle pose in 3/4 BACK view, seen from behind, turned toward the upper right, face hidden.
Exactly the same character, outfit, colors and weapon in both poses (weapon in the same hand).
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Aéron le Céleste: celestial lord in pale cyan feathered armor (#BDEFFF) with long flowing feather layers; crown of silver spikes, long white hair, pale blue eyes; tall silver staff with a wing-shaped crystal, RIGHT hand. Forbidden: no helmet, no dark colors.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 1 (face) | `vents.png` |
| 1-2 | repos 1 (dos) | `vents_back.png` |

#### Planche 2 — Face 1 · garde, marche, sort (`face_1`)

Dans l'Atelier : personnage « Aéron le Céleste », planche « Face 1 · garde, marche, sort ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Aéron le Céleste (boss of the Vents nation)
- Body: celestial lord in pale cyan feathered armor (#BDEFFF) with long flowing feather layers
- Head: crown of silver spikes, long white hair, pale blue eyes
- Weapon: tall silver staff with a wing-shaped crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no dark colors.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. GUARD: knees bent, weapon raised in front of the body, ready to fight.
2. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
3. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
4. FOCUS: eyes closed, staff held vertically in front of the face, wind ribbons and feathers orb at the top.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Aéron le Céleste: celestial lord in pale cyan feathered armor (#BDEFFF) with long flowing feather layers; crown of silver spikes, long white hair, pale blue eyes; tall silver staff with a wing-shaped crystal, RIGHT hand. Forbidden: no helmet, no dark colors.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | repos 2 | `vents_idle_2.png` |
| 1-2 | marche 1 | `vents_walk.png` |
| 2-1 | marche 2 | `vents_walk_2.png` |
| 2-2 | sort 1 | `vents_cast.png` |

#### Planche 3 — Face 2 · attaques 1 à 4 (`face_2`)

Dans l'Atelier : personnage « Aéron le Céleste », planche « Face 2 · attaques 1 à 4 ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Aéron le Céleste (boss of the Vents nation)
- Body: celestial lord in pale cyan feathered armor (#BDEFFF) with long flowing feather layers
- Head: crown of silver spikes, long white hair, pale blue eyes
- Weapon: tall silver staff with a wing-shaped crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no dark colors.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short wind ribbons and feathers spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. JUMPING STRIKE: whole body in the air, staff held back over the shoulder.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Aéron le Céleste: celestial lord in pale cyan feathered armor (#BDEFFF) with long flowing feather layers; crown of silver spikes, long white hair, pale blue eyes; tall silver staff with a wing-shaped crystal, RIGHT hand. Forbidden: no helmet, no dark colors.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `vents_attack.png` |
| 1-2 | attaque 2 | `vents_attack_2.png` |
| 2-1 | attaque 3 | `vents_attack_3.png` |
| 2-2 | attaque 4 | `vents_attack_4.png` |

#### Planche 4 — Face 3 · attaques 5-6, sorts 2-3 (`face_3`)

Dans l'Atelier : personnage « Aéron le Céleste », planche « Face 3 · attaques 5-6, sorts 2-3 ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Aéron le Céleste (boss of the Vents nation)
- Body: celestial lord in pale cyan feathered armor (#BDEFFF) with long flowing feather layers
- Head: crown of silver spikes, long white hair, pale blue eyes
- Weapon: tall silver staff with a wing-shaped crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no dark colors.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in front-right 3/4 view, never mix front and back views):
1. LOW SWEEP: crouched, staff swinging at ankle height.
2. SPIN: staff whirling around the body, a wind ribbons and feathers trail circling it.
3. INVOCATION: staff raised high with both hands, wind ribbons and feathers swirling above the head.
4. BLAST: staff pointed forward, a compact wind ribbons and feathers blast leaving the tip.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Aéron le Céleste: celestial lord in pale cyan feathered armor (#BDEFFF) with long flowing feather layers; crown of silver spikes, long white hair, pale blue eyes; tall silver staff with a wing-shaped crystal, RIGHT hand. Forbidden: no helmet, no dark colors.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 5 | `vents_attack_5.png` |
| 1-2 | attaque 6 | `vents_attack_6.png` |
| 2-1 | sort 2 | `vents_cast_2.png` |
| 2-2 | sort 3 | `vents_cast_3.png` |

#### Planche 5 — Dos 1 · marche, attaque, sort (`dos_1`)

Dans l'Atelier : personnage « Aéron le Céleste », planche « Dos 1 · marche, attaque, sort ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Aéron le Céleste (boss of the Vents nation)
- Body: celestial lord in pale cyan feathered armor (#BDEFFF) with long flowing feather layers
- Head: crown of silver spikes, long white hair, pale blue eyes
- Weapon: tall silver staff with a wing-shaped crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no dark colors.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. WALK (contact): walking toward the lower right in the same 3/4 view, head level, long stride, left leg far forward, right leg far back, opposite arm swinging forward.
2. WALK (passing): same 3/4 view, head level, standing on the left leg, right knee raised high, body slightly higher.
3. OVERHEAD STRIKE: staff raised high above the head with both hands.
4. FOCUS: eyes closed, staff held vertically in front of the face, wind ribbons and feathers orb at the top.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Aéron le Céleste: celestial lord in pale cyan feathered armor (#BDEFFF) with long flowing feather layers; crown of silver spikes, long white hair, pale blue eyes; tall silver staff with a wing-shaped crystal, RIGHT hand. Forbidden: no helmet, no dark colors.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | marche 1 | `vents_back_walk.png` |
| 1-2 | marche 2 | `vents_back_walk_2.png` |
| 2-1 | attaque 1 | `vents_back_attack.png` |
| 2-2 | sort 1 | `vents_back_cast.png` |

#### Planche 6 — Dos 2 · attaques 2 à 4, garde (`dos_2`)

Dans l'Atelier : personnage « Aéron le Céleste », planche « Dos 2 · attaques 2 à 4, garde ».

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG. The same character appears 4 times.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Aéron le Céleste (boss of the Vents nation)
- Body: celestial lord in pale cyan feathered armor (#BDEFFF) with long flowing feather layers
- Head: crown of silver spikes, long white hair, pale blue eyes
- Weapon: tall silver staff with a wing-shaped crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no dark colors.
Keep exactly the same design in every pose: same outfit, colors, proportions, accessories, weapon always in the same hand, eyes open.
VIEW: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back, back of the head and right shoulder visible), facing away from the viewer toward the upper right in every pose. We see the BACK of the head or helmet: NO face, NO eyes, NO mask or visor visible. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a square image (1:1, as large as possible, e.g. 2048x2048), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and effects are drawn smaller or tucked in so they fit. Same character size in every pose, feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom (all in back-right, away from the viewer 3/4 view, never mix front and back views):
1. THRUST: body leaning forward, staff tip pushed far ahead with a short wind ribbons and feathers spark.
2. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
3. JUMPING STRIKE: whole body in the air, staff held back over the shoulder.
4. GUARD: knees bent, weapon raised in front of the body, ready to fight.
The 4 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Aéron le Céleste: celestial lord in pale cyan feathered armor (#BDEFFF) with long flowing feather layers; crown of silver spikes, long white hair, pale blue eyes; tall silver staff with a wing-shaped crystal, RIGHT hand. Forbidden: no helmet, no dark colors.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 2 | `vents_back_attack_2.png` |
| 1-2 | attaque 3 | `vents_back_attack_3.png` |
| 2-1 | attaque 4 | `vents_back_attack_4.png` |
| 2-2 | repos 2 | `vents_back_idle_2.png` |

## Prompt négatif (toutes les planches de cette page)

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses, identical poses, repeated pose, copy of the same pose, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, front and back views mixed, different character between poses, realistic proportions, small head
```
