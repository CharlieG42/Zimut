# Nation Vents (Vents)

Palette : pale teal, silver, sky white, mint. Effets : wind ribbons and feathers. Contre-jour : pale sky white.

Format 3 planches par personnage (V44) :

1. **Vues** — 4 cases : repos de FACE ×2 (deux attitudes différentes) puis repos de DOS ×2, tout orienté vers la droite (le jeu retourne l'image pour la gauche). Grille 2 × 2 sur image 2:1, poses largement espacées. Génération normale.
2. **Actions de face** — 3 attaques + 2 sorts + 1 marche (3 colonnes × 2 rangées), en **édition** de la planche vues : le personnage réellement dessiné sert d'ancre.
3. **Actions de dos** — les mêmes 6 poses vues de dos, en édition de la planche vues. Une planche = un seul sens de vue (face et dos mélangés sur une même planche étaient dessinés de face). Facultative pour les monstres.

Les personnages **armés** ont l'arme écrite dans la première phrase, dans la carte d'identité, en fin de prompt et dans chaque pose ; les **créatures** reçoivent « UNARMED » (plus de torche inventée). Chaque prompt recopie la carte d'identité (`identites.py`) : aucune image à joindre. Ordre conseillé : 1) planche de style, 2) héros, 3) ennemis, 4) boss ; pour chaque personnage : vues, actions de face, actions de dos. Prompt négatif : en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes, de face et de dos.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Vents nation (Vents biome).
NATION PALETTE: pale teal, silver, sky white, mint. Signature effects: wind ribbons and feathers.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale sky white highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
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

### Sylvain — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/players/` ; nomme tes images `sylvain_vues.png`, `sylvain_actions.png` et `sylvain_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE playable hero: Sylvain, armed with: slim brown wooden staff topped with a mint crystal (#7FF0D8) between two small white wings, RIGHT hand.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
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
WEAPON: slim brown wooden staff topped with a mint crystal (#7FF0D8) between two small white wings, RIGHT hand. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale sky white highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: slim brown wooden staff topped with a mint crystal (#7FF0D8) between two small white wings, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Sylvain: slim brown wooden staff topped with a mint crystal (#7FF0D8) between two small white wings, RIGHT hand; short messy pale mint-white hair (#DDF2EE) with long bangs over the forehead; teal-green eyes (#2E9C94), always open, calm smile; pale teal tunic (#9FE0D6) made of layered leaf-shaped feathers, white collar and a white front panel, small gold leaf brooch on the chest; light peach skin; pale teal and white layered skirt-robe down to the knees, dark charcoal leggings (#33383F); white boots with gold trims; silver bracers on both forearms. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no orange or brown trousers, no brown eyes, no closed eyes, no pure white spiky hair, no long hair, no blue robe, no spear. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `sylvain.png` |
| 1-2 | repos de face, variante | `sylvain_idle_2.png` |
| 2-1 | repos de dos | `sylvain_back.png` |
| 2-2 | repos de dos, variante | `sylvain_back_idle_2.png` |

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE playable hero: Sylvain, armed with: slim brown wooden staff topped with a mint crystal (#7FF0D8) between two small white wings, RIGHT hand.
SOURCE IMAGE: it shows this playable hero, Sylvain, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
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
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
WEAPON: slim brown wooden staff topped with a mint crystal (#7FF0D8) between two small white wings, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Sylvain: slim brown wooden staff topped with a mint crystal (#7FF0D8) between two small white wings, RIGHT hand; short messy pale mint-white hair (#DDF2EE) with long bangs over the forehead; teal-green eyes (#2E9C94), always open, calm smile; pale teal tunic (#9FE0D6) made of layered leaf-shaped feathers, white collar and a white front panel, small gold leaf brooch on the chest; light peach skin; pale teal and white layered skirt-robe down to the knees, dark charcoal leggings (#33383F); white boots with gold trims; silver bracers on both forearms. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no orange or brown trousers, no brown eyes, no closed eyes, no pure white spiky hair, no long hair, no blue robe, no spear. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE playable hero: Sylvain, armed with: slim brown wooden staff topped with a mint crystal (#7FF0D8) between two small white wings, RIGHT hand.
SOURCE IMAGE: it shows this playable hero, Sylvain, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
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
WEAPON: slim brown wooden staff topped with a mint crystal (#7FF0D8) between two small white wings, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale sky white highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short wind ribbons and feathers spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. FOCUS: eyes closed, staff held vertically in front of the face, wind ribbons and feathers orb at the top.
5. INVOCATION: staff raised high with both hands, wind ribbons and feathers swirling above the head.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: slim brown wooden staff topped with a mint crystal (#7FF0D8) between two small white wings, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Sylvain: slim brown wooden staff topped with a mint crystal (#7FF0D8) between two small white wings, RIGHT hand; short messy pale mint-white hair (#DDF2EE) with long bangs over the forehead; teal-green eyes (#2E9C94), always open, calm smile; pale teal tunic (#9FE0D6) made of layered leaf-shaped feathers, white collar and a white front panel, small gold leaf brooch on the chest; light peach skin; pale teal and white layered skirt-robe down to the knees, dark charcoal leggings (#33383F); white boots with gold trims; silver bracers on both forearms. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no orange or brown trousers, no brown eyes, no closed eyes, no pure white spiky hair, no long hair, no blue robe, no spear. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `sylvain_attack.png` |
| 1-2 | attaque 2 | `sylvain_attack_2.png` |
| 1-3 | attaque 3 | `sylvain_attack_3.png` |
| 2-1 | sort 1 | `sylvain_cast.png` |
| 2-2 | sort 2 | `sylvain_cast_2.png` |
| 2-3 | marche | `sylvain_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE playable hero: Sylvain, armed with: slim brown wooden staff topped with a mint crystal (#7FF0D8) between two small white wings, RIGHT hand.
SOURCE IMAGE: it shows this playable hero, Sylvain, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
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
WEAPON: slim brown wooden staff topped with a mint crystal (#7FF0D8) between two small white wings, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale sky white highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short wind ribbons and feathers spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. FOCUS: eyes closed, staff held vertically in front of the face, wind ribbons and feathers orb at the top.
5. INVOCATION: staff raised high with both hands, wind ribbons and feathers swirling above the head.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: slim brown wooden staff topped with a mint crystal (#7FF0D8) between two small white wings, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Sylvain: slim brown wooden staff topped with a mint crystal (#7FF0D8) between two small white wings, RIGHT hand; short messy pale mint-white hair (#DDF2EE) with long bangs over the forehead; teal-green eyes (#2E9C94), always open, calm smile; pale teal tunic (#9FE0D6) made of layered leaf-shaped feathers, white collar and a white front panel, small gold leaf brooch on the chest; light peach skin; pale teal and white layered skirt-robe down to the knees, dark charcoal leggings (#33383F); white boots with gold trims; silver bracers on both forearms. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no orange or brown trousers, no brown eyes, no closed eyes, no pure white spiky hair, no long hair, no blue robe, no spear. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `sylvain_back_attack.png` |
| 1-2 | attaque 2 — dos | `sylvain_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `sylvain_back_attack_3.png` |
| 2-1 | sort 1 — dos | `sylvain_back_cast.png` |
| 2-2 | sort 2 — dos | `sylvain_back_cast_2.png` |
| 2-3 | marche — dos | `sylvain_back_walk.png` |

L'export Zimut de l'Atelier copie aussi le repos (case 1 de la planche vues) vers `nations/heros/sylvain.png`.

## 3. Ennemis

### Garde aérien — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/vents/` ; nomme tes images `garde_aerien_vues.png`, `garde_aerien_actions.png` et `garde_aerien_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Garde aérien, armed with: halberd with a brown wooden shaft and a large silver axe blade, RIGHT hand.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
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
WEAPON: halberd with a brown wooden shaft and a large silver axe blade, RIGHT hand. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale sky white highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: halberd with a brown wooden shaft and a large silver axe blade, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Garde aérien: halberd with a brown wooden shaft and a large silver axe blade, RIGHT hand; pale ice-blue armor (#BFE6F0) with silver shoulder plates and a brown leather strap across the chest; small chibi sky guard, round body; round pale ice-blue helmet (#BFE6F0) with a short fin on top and two small white wings on the sides, a WHITE face mask with two big dark-red eyes (#8A1E1E); pale ice-blue tabard over dark navy trousers (#2E3550); dark navy armored boots. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no visor, no spear, no cape, no human face. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `garde_aerien.png` |
| 1-2 | repos de face, variante | `garde_aerien_idle_2.png` |
| 2-1 | repos de dos | `garde_aerien_back.png` |
| 2-2 | repos de dos, variante | `garde_aerien_back_idle_2.png` |

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Garde aérien, armed with: halberd with a brown wooden shaft and a large silver axe blade, RIGHT hand.
SOURCE IMAGE: it shows this enemy monster, Garde aérien, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
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
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
WEAPON: halberd with a brown wooden shaft and a large silver axe blade, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Garde aérien: halberd with a brown wooden shaft and a large silver axe blade, RIGHT hand; pale ice-blue armor (#BFE6F0) with silver shoulder plates and a brown leather strap across the chest; small chibi sky guard, round body; round pale ice-blue helmet (#BFE6F0) with a short fin on top and two small white wings on the sides, a WHITE face mask with two big dark-red eyes (#8A1E1E); pale ice-blue tabard over dark navy trousers (#2E3550); dark navy armored boots. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no visor, no spear, no cape, no human face. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Garde aérien, armed with: halberd with a brown wooden shaft and a large silver axe blade, RIGHT hand.
SOURCE IMAGE: it shows this enemy monster, Garde aérien, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
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
WEAPON: halberd with a brown wooden shaft and a large silver axe blade, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale sky white highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short wind ribbons and feathers spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. FOCUS: eyes closed, staff held vertically in front of the face, wind ribbons and feathers orb at the top.
5. INVOCATION: staff raised high with both hands, wind ribbons and feathers swirling above the head.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: halberd with a brown wooden shaft and a large silver axe blade, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Garde aérien: halberd with a brown wooden shaft and a large silver axe blade, RIGHT hand; pale ice-blue armor (#BFE6F0) with silver shoulder plates and a brown leather strap across the chest; small chibi sky guard, round body; round pale ice-blue helmet (#BFE6F0) with a short fin on top and two small white wings on the sides, a WHITE face mask with two big dark-red eyes (#8A1E1E); pale ice-blue tabard over dark navy trousers (#2E3550); dark navy armored boots. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no visor, no spear, no cape, no human face. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `garde_aerien_attack.png` |
| 1-2 | attaque 2 | `garde_aerien_attack_2.png` |
| 1-3 | attaque 3 | `garde_aerien_attack_3.png` |
| 2-1 | sort 1 | `garde_aerien_cast.png` |
| 2-2 | sort 2 | `garde_aerien_cast_2.png` |
| 2-3 | marche | `garde_aerien_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Garde aérien, armed with: halberd with a brown wooden shaft and a large silver axe blade, RIGHT hand.
SOURCE IMAGE: it shows this enemy monster, Garde aérien, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
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
WEAPON: halberd with a brown wooden shaft and a large silver axe blade, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale sky white highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short wind ribbons and feathers spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. FOCUS: eyes closed, staff held vertically in front of the face, wind ribbons and feathers orb at the top.
5. INVOCATION: staff raised high with both hands, wind ribbons and feathers swirling above the head.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: halberd with a brown wooden shaft and a large silver axe blade, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Garde aérien: halberd with a brown wooden shaft and a large silver axe blade, RIGHT hand; pale ice-blue armor (#BFE6F0) with silver shoulder plates and a brown leather strap across the chest; small chibi sky guard, round body; round pale ice-blue helmet (#BFE6F0) with a short fin on top and two small white wings on the sides, a WHITE face mask with two big dark-red eyes (#8A1E1E); pale ice-blue tabard over dark navy trousers (#2E3550); dark navy armored boots. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no visor, no spear, no cape, no human face. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `garde_aerien_back_attack.png` |
| 1-2 | attaque 2 — dos | `garde_aerien_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `garde_aerien_back_attack_3.png` |
| 2-1 | sort 1 — dos | `garde_aerien_back_cast.png` |
| 2-2 | sort 2 — dos | `garde_aerien_back_cast_2.png` |
| 2-3 | marche — dos | `garde_aerien_back_walk.png` |

### Aigle céleste — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/vents/` ; nomme tes images `aigle_celeste_vues.png`, `aigle_celeste_actions.png` et `aigle_celeste_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Aigle céleste — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Aigle céleste (enemy of the Vents nation)
- Body: large deep blue eagle (#1F4FA8) with lighter blue chest feathers
- Head: white-blue head, golden hooked beak, sharp yellow eyes
- Details: golden talons, wide spread wings
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no rider, no armor.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale sky white highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Aigle céleste: large deep blue eagle (#1F4FA8) with lighter blue chest feathers; white-blue head, golden hooked beak, sharp yellow eyes; golden talons, wide spread wings. NO weapon and no held object, ever. Forbidden: no rider, no armor. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `aigle_celeste.png` |
| 1-2 | repos de face, variante | `aigle_celeste_idle_2.png` |
| 2-1 | repos de dos | `aigle_celeste_back.png` |
| 2-2 | repos de dos, variante | `aigle_celeste_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Aigle céleste — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Aigle céleste, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Aigle céleste (enemy of the Vents nation)
- Body: large deep blue eagle (#1F4FA8) with lighter blue chest feathers
- Head: white-blue head, golden hooked beak, sharp yellow eyes
- Details: golden talons, wide spread wings
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no rider, no armor.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Aigle céleste: large deep blue eagle (#1F4FA8) with lighter blue chest feathers; white-blue head, golden hooked beak, sharp yellow eyes; golden talons, wide spread wings. NO weapon and no held object, ever. Forbidden: no rider, no armor. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Aigle céleste — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Aigle céleste, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Aigle céleste (enemy of the Vents nation)
- Body: large deep blue eagle (#1F4FA8) with lighter blue chest feathers
- Head: white-blue head, golden hooked beak, sharp yellow eyes
- Details: golden talons, wide spread wings
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no rider, no armor.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale sky white highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. POUNCE: body stretched forward in the air, jaws open.
3. SIDE SWIPE: head and claws swept to the side, body twisted.
4. HOWL: head raised to the sky, wind ribbons and feathers gathering around the body.
5. ROAR: mouth wide open, wind ribbons and feathers burst in front of the head.
6. WALK: mid-stride, one front paw raised, body moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Aigle céleste: large deep blue eagle (#1F4FA8) with lighter blue chest feathers; white-blue head, golden hooked beak, sharp yellow eyes; golden talons, wide spread wings. NO weapon and no held object, ever. Forbidden: no rider, no armor. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `aigle_celeste_attack.png` |
| 1-2 | attaque 2 | `aigle_celeste_attack_2.png` |
| 1-3 | attaque 3 | `aigle_celeste_attack_3.png` |
| 2-1 | sort 1 | `aigle_celeste_cast.png` |
| 2-2 | sort 2 | `aigle_celeste_cast_2.png` |
| 2-3 | marche | `aigle_celeste_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Aigle céleste — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Aigle céleste, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Aigle céleste (enemy of the Vents nation)
- Body: large deep blue eagle (#1F4FA8) with lighter blue chest feathers
- Head: white-blue head, golden hooked beak, sharp yellow eyes
- Details: golden talons, wide spread wings
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no rider, no armor.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale sky white highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. REARING: standing up on the hind legs, front claws raised high.
2. POUNCE: body stretched forward in the air, jaws open.
3. SIDE SWIPE: head and claws swept to the side, body twisted.
4. HOWL: head raised to the sky, wind ribbons and feathers gathering around the body.
5. ROAR: mouth wide open, wind ribbons and feathers burst in front of the head.
6. WALK: mid-stride, one front paw raised, body moving forward.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Aigle céleste: large deep blue eagle (#1F4FA8) with lighter blue chest feathers; white-blue head, golden hooked beak, sharp yellow eyes; golden talons, wide spread wings. NO weapon and no held object, ever. Forbidden: no rider, no armor. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `aigle_celeste_back_attack.png` |
| 1-2 | attaque 2 — dos | `aigle_celeste_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `aigle_celeste_back_attack_3.png` |
| 2-1 | sort 1 — dos | `aigle_celeste_back_cast.png` |
| 2-2 | sort 2 — dos | `aigle_celeste_back_cast_2.png` |
| 2-3 | marche — dos | `aigle_celeste_back_walk.png` |

### Harpie — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/vents/` ; nomme tes images `harpie_vues.png`, `harpie_actions.png` et `harpie_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Harpie — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Harpie (enemy of the Vents nation)
- Body: harpy woman with green and gold feathered wings (#3E9A5A, #E0B040) instead of arms
- Head: wild green hair, yellow eyes
- Bottom: bird legs with yellow talons, short green feather skirt
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human arms, no weapon.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale sky white highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Harpie: harpy woman with green and gold feathered wings (#3E9A5A, #E0B040) instead of arms; wild green hair, yellow eyes; bird legs with yellow talons, short green feather skirt. NO weapon and no held object, ever. Forbidden: no human arms, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `harpie.png` |
| 1-2 | repos de face, variante | `harpie_idle_2.png` |
| 2-1 | repos de dos | `harpie_back.png` |
| 2-2 | repos de dos, variante | `harpie_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Harpie — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Harpie, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Harpie (enemy of the Vents nation)
- Body: harpy woman with green and gold feathered wings (#3E9A5A, #E0B040) instead of arms
- Head: wild green hair, yellow eyes
- Bottom: bird legs with yellow talons, short green feather skirt
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human arms, no weapon.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Harpie: harpy woman with green and gold feathered wings (#3E9A5A, #E0B040) instead of arms; wild green hair, yellow eyes; bird legs with yellow talons, short green feather skirt. NO weapon and no held object, ever. Forbidden: no human arms, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Harpie — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Harpie, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Harpie (enemy of the Vents nation)
- Body: harpy woman with green and gold feathered wings (#3E9A5A, #E0B040) instead of arms
- Head: wild green hair, yellow eyes
- Bottom: bird legs with yellow talons, short green feather skirt
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human arms, no weapon.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale sky white highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. LUNGE: body stretched forward, claws of wind ribbons and feathers reaching out.
3. SPIN: body whirling, wind ribbons and feathers trail around it.
4. HOVER: floating higher, wind ribbons and feathers orbs circling.
5. PULSE: arms spread, wind ribbons and feathers pulsing outward.
6. DRIFT: floating forward with the body tilted slightly ahead, a short trail behind.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Harpie: harpy woman with green and gold feathered wings (#3E9A5A, #E0B040) instead of arms; wild green hair, yellow eyes; bird legs with yellow talons, short green feather skirt. NO weapon and no held object, ever. Forbidden: no human arms, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `harpie_attack.png` |
| 1-2 | attaque 2 | `harpie_attack_2.png` |
| 1-3 | attaque 3 | `harpie_attack_3.png` |
| 2-1 | sort 1 | `harpie_cast.png` |
| 2-2 | sort 2 | `harpie_cast_2.png` |
| 2-3 | marche | `harpie_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Harpie — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Harpie, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Harpie (enemy of the Vents nation)
- Body: harpy woman with green and gold feathered wings (#3E9A5A, #E0B040) instead of arms
- Head: wild green hair, yellow eyes
- Bottom: bird legs with yellow talons, short green feather skirt
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human arms, no weapon.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale sky white highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. LUNGE: body stretched forward, claws of wind ribbons and feathers reaching out.
3. SPIN: body whirling, wind ribbons and feathers trail around it.
4. HOVER: floating higher, wind ribbons and feathers orbs circling.
5. PULSE: arms spread, wind ribbons and feathers pulsing outward.
6. DRIFT: floating forward with the body tilted slightly ahead, a short trail behind.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Harpie: harpy woman with green and gold feathered wings (#3E9A5A, #E0B040) instead of arms; wild green hair, yellow eyes; bird legs with yellow talons, short green feather skirt. NO weapon and no held object, ever. Forbidden: no human arms, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `harpie_back_attack.png` |
| 1-2 | attaque 2 — dos | `harpie_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `harpie_back_attack_3.png` |
| 2-1 | sort 1 — dos | `harpie_back_cast.png` |
| 2-2 | sort 2 — dos | `harpie_back_cast_2.png` |
| 2-3 | marche — dos | `harpie_back_walk.png` |

### Élémentaire de vent — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Créature **sans arme** : chaque prompt interdit tout objet tenu. Fichiers dans `prototype/zimut/assets/sprites/nations/ennemis/vents/` ; nomme tes images `elementaire_de_vent_vues.png`, `elementaire_de_vent_actions.png` et `elementaire_de_vent_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Élémentaire de vent — an UNARMED creature (no weapon of any kind).
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Élémentaire de vent (enemy of the Vents nation)
- Body: round pale blue cloud body (#CFEFFF) with swirling wind ribbons around it
- Head: two big friendly dark eyes on the cloud, no mouth
- Details: two small arms made of wind swirls, no legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human body, no weapon.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 4 cells; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale sky white highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat white background (#FFFFFF) — not cream, not beige, not ivory, no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
REMINDER: this is Élémentaire de vent: round pale blue cloud body (#CFEFFF) with swirling wind ribbons around it; two big friendly dark eyes on the cloud, no mouth; two small arms made of wind swirls, no legs. NO weapon and no held object, ever. Forbidden: no human body, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `elementaire_de_vent.png` |
| 1-2 | repos de face, variante | `elementaire_de_vent_idle_2.png` |
| 2-1 | repos de dos | `elementaire_de_vent_back.png` |
| 2-2 | repos de dos, variante | `elementaire_de_vent_back_idle_2.png` |

##### Édition corrective (objet inventé dans les mains)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE enemy monster: Élémentaire de vent — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Élémentaire de vent, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Élémentaire de vent (enemy of the Vents nation)
- Body: round pale blue cloud body (#CFEFFF) with swirling wind ribbons around it
- Head: two big friendly dark eyes on the cloud, no mouth
- Details: two small arms made of wind swirls, no legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human body, no weapon.
TASK: REMOVE every weapon, torch, tool or held object from the hands, claws or tail — this creature is unarmed. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in every cell; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Élémentaire de vent: round pale blue cloud body (#CFEFFF) with swirling wind ribbons around it; two big friendly dark eyes on the cloud, no mouth; two small arms made of wind swirls, no legs. NO weapon and no held object, ever. Forbidden: no human body, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE enemy monster: Élémentaire de vent — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Élémentaire de vent, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Élémentaire de vent (enemy of the Vents nation)
- Body: round pale blue cloud body (#CFEFFF) with swirling wind ribbons around it
- Head: two big friendly dark eyes on the cloud, no mouth
- Details: two small arms made of wind swirls, no legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human body, no weapon.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale sky white highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. LUNGE: body stretched forward, claws of wind ribbons and feathers reaching out.
3. SPIN: body whirling, wind ribbons and feathers trail around it.
4. HOVER: floating higher, wind ribbons and feathers orbs circling.
5. PULSE: arms spread, wind ribbons and feathers pulsing outward.
6. DRIFT: floating forward with the body tilted slightly ahead, a short trail behind.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Élémentaire de vent: round pale blue cloud body (#CFEFFF) with swirling wind ribbons around it; two big friendly dark eyes on the cloud, no mouth; two small arms made of wind swirls, no legs. NO weapon and no held object, ever. Forbidden: no human body, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `elementaire_de_vent_attack.png` |
| 1-2 | attaque 2 | `elementaire_de_vent_attack_2.png` |
| 1-3 | attaque 3 | `elementaire_de_vent_attack_3.png` |
| 2-1 | sort 1 | `elementaire_de_vent_cast.png` |
| 2-2 | sort 2 | `elementaire_de_vent_cast_2.png` |
| 2-3 | marche | `elementaire_de_vent_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. **Facultative pour un monstre** : sans elle, le jeu utilise les poses de face. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE enemy monster: Élémentaire de vent — an UNARMED creature (no weapon of any kind).
SOURCE IMAGE: it shows this enemy monster, Élémentaire de vent, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Élémentaire de vent (enemy of the Vents nation)
- Body: round pale blue cloud body (#CFEFFF) with swirling wind ribbons around it
- Head: two big friendly dark eyes on the cloud, no mouth
- Details: two small arms made of wind swirls, no legs
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no human body, no weapon.
UNARMED: this creature has NO weapon, tool, torch, staff or held object of any kind in all 6 poses; it fights only with its own body (claws, teeth, fists, tail, magic). Never add an item.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale sky white highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. RISE: body stretched tall upward, arms raised.
2. LUNGE: body stretched forward, claws of wind ribbons and feathers reaching out.
3. SPIN: body whirling, wind ribbons and feathers trail around it.
4. HOVER: floating higher, wind ribbons and feathers orbs circling.
5. PULSE: arms spread, wind ribbons and feathers pulsing outward.
6. DRIFT: floating forward with the body tilted slightly ahead, a short trail behind.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat white background (#FFFFFF) — not cream, not beige, not ivory), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
REMINDER: this is Élémentaire de vent: round pale blue cloud body (#CFEFFF) with swirling wind ribbons around it; two big friendly dark eyes on the cloud, no mouth; two small arms made of wind swirls, no legs. NO weapon and no held object, ever. Forbidden: no human body, no weapon. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `elementaire_de_vent_back_attack.png` |
| 1-2 | attaque 2 — dos | `elementaire_de_vent_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `elementaire_de_vent_back_attack_3.png` |
| 2-1 | sort 1 — dos | `elementaire_de_vent_back_cast.png` |
| 2-2 | sort 2 — dos | `elementaire_de_vent_back_cast_2.png` |
| 2-3 | marche — dos | `elementaire_de_vent_back_walk.png` |

## 4. Boss

### Aéron le Céleste — 10 poses

3 planches : **vues** (génération normale), puis **actions de face** et **actions de dos** en **édition** de la planche vues (image source = planche vues de ce personnage : c'est ce qui garantit le même personnage). Personnage armé : l'arme est verrouillée dans chaque prompt. Fichiers dans `prototype/zimut/assets/sprites/nations/boss/` ; nomme tes images `vents_vues.png`, `vents_actions.png` et `vents_actions_dos.png` pour que l'Atelier les reconnaisse.

#### Planche 1 — Vues · 2 repos de face + 2 repos de dos (`vues`)

Génération normale, aucune image à joindre. Tout est orienté vers la droite ; deux attitudes différentes par rangée.

```text
Sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE final boss: Aéron le Céleste, armed with: tall silver staff with a wing-shaped crystal, RIGHT hand.
The sheet contains EXACTLY 4 sprites of the SAME character: the top row shows it from the FRONT twice (two different relaxed stances), the bottom row shows it from BEHIND twice (two different relaxed stances). Same design, same outfit, same colors, same size in all 4 cells.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Aéron le Céleste (boss of the Vents nation)
- Body: celestial lord in pale cyan feathered armor (#BDEFFF) with long flowing feather layers
- Head: crown of silver spikes, long white hair, pale blue eyes
- Weapon: tall silver staff with a wing-shaped crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no dark colors.
WEAPON: tall silver staff with a wing-shaped crystal, RIGHT hand. It is held in the SAME hand and is clearly visible in all 4 cells: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale sky white highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 4 poses arranged as 2 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like four separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its quarter of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own quarter, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The sheet contains EXACTLY 4 sprites — one per cell of the 2 x 2 grid, never more, no extra or duplicated row. The 4 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
CELLS — follow the grid positions EXACTLY:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
Every sprite faces RIGHT (front-right on the top row, away toward the upper right on the bottom row): never facing left, never a pure side profile. The two sprites of a row are clearly different stances, never the same drawing twice.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own quarter of the image.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: tall silver staff with a wing-shaped crystal, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
REMINDER: this is Aéron le Céleste: tall silver staff with a wing-shaped crystal, RIGHT hand; celestial lord in pale cyan feathered armor (#BDEFFF) with long flowing feather layers; crown of silver spikes, long white hair, pale blue eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no dark colors. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Vue | Fichier |
|---|---|---|
| 1-1 | repos de face | `vents.png` |
| 1-2 | repos de face, variante | `vents_idle_2.png` |
| 2-1 | repos de dos | `vents_back.png` |
| 2-2 | repos de dos, variante | `vents_back_idle_2.png` |

##### Édition corrective (arme manquante)

Si une case est fausse : édition avec la planche `vues` en image source. Ce prompt répète la structure des cases (haut = face, bas = dos) pour que l'éditeur n'aplatisse pas toutes les vues dans le même angle.

```text
Image edit of a sprite sheet for a chibi isometric tactical RPG showing 4 idle poses of ONE final boss: Aéron le Céleste, armed with: tall silver staff with a wing-shaped crystal, RIGHT hand.
SOURCE IMAGE: it shows this final boss, Aéron le Céleste, 4 times: top row from the FRONT twice, bottom row from BEHIND twice, all facing right.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Aéron le Céleste (boss of the Vents nation)
- Body: celestial lord in pale cyan feathered armor (#BDEFFF) with long flowing feather layers
- Head: crown of silver spikes, long white hair, pale blue eyes
- Weapon: tall silver staff with a wing-shaped crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no dark colors.
TASK: fix the sprites so that EVERY sprite visibly HOLDS its weapon in the correct hand — add the weapon where it is missing, correct the hand if it is held wrong. Nothing else changes.
CRITICAL — KEEP THE VIEWS: the top row stays FRONT views and the bottom row stays BACK views; the two sprites of a row stay two different stances. Never redraw the whole sheet from a single angle:
1. TOP-LEFT cell: FRONT idle: 3/4 FRONT view, the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right; both eyes visible; standing calm.
2. TOP-RIGHT cell: FRONT idle, VARIANT: the same 3/4 front view facing front-right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly toward the right, the weight is on the other leg (the weapon stays in its hand); the face is visible and the drawing must not be a copy of cell 1.
3. BOTTOM-LEFT cell: BACK idle: 3/4 BACK view, seen from behind, turned toward the upper right (back of the head and right shoulder visible); we see the BACK of the head: no face, no eyes; not a pure side profile.
4. BOTTOM-RIGHT cell: BACK idle, VARIANT: the same 3/4 back view toward the upper right, but a clearly DIFFERENT pose — the free hand rests on the hip, the head is turned slightly to the left, the weight is on the other leg (the weapon stays in its hand); no face, no eyes; the drawing must not be a copy of cell 3.
WEAPON: tall silver staff with a wing-shaped crystal, RIGHT hand. It is held in the SAME hand and is clearly visible in every cell: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
CHANGE NOTHING ELSE: keep the exact same character, poses, sizes, outfit, hair, background and layout.
BACKGROUND: keep the plain flat background of the source image.
REMINDER: this is Aéron le Céleste: tall silver staff with a wing-shaped crystal, RIGHT hand; celestial lord in pale cyan feathered armor (#BDEFFF) with long flowing feather layers; crown of silver spikes, long white hair, pale blue eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no dark colors. Every sprite faces RIGHT (front or back 3/4), never left.
```

#### Planche 2 — Actions de face · 3 attaques, 2 sorts, 1 marche (`actions`)

**Édition d'image** : source = la planche `vues` (l'image générée à l'étape précédente). Si ton outil ne permet pas l'édition, repli : génération normale avec ce prompt tel quel, la carte d'identité reste recopiée.

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from the FRONT of ONE final boss: Aéron le Céleste, armed with: tall silver staff with a wing-shaped crystal, RIGHT hand.
SOURCE IMAGE: it shows this final boss, Aéron le Céleste, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Aéron le Céleste (boss of the Vents nation)
- Body: celestial lord in pale cyan feathered armor (#BDEFFF) with long flowing feather layers
- Head: crown of silver spikes, long white hair, pale blue eyes
- Weapon: tall silver staff with a wing-shaped crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no dark colors.
WEAPON: tall silver staff with a wing-shaped crystal, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 FRONT view: the character faces the viewer and turns slightly to the right (face, chest and right side visible), facing front-right in every pose, facing front-right in every pose. Never a pure side profile, never facing left.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale sky white highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short wind ribbons and feathers spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. FOCUS: eyes closed, staff held vertically in front of the face, wind ribbons and feathers orb at the top.
5. INVOCATION: staff raised high with both hands, wind ribbons and feathers swirling above the head.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: tall silver staff with a wing-shaped crystal, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Aéron le Céleste: tall silver staff with a wing-shaped crystal, RIGHT hand; celestial lord in pale cyan feathered armor (#BDEFFF) with long flowing feather layers; crown of silver spikes, long white hair, pale blue eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no dark colors. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 | `vents_attack.png` |
| 1-2 | attaque 2 | `vents_attack_2.png` |
| 1-3 | attaque 3 | `vents_attack_3.png` |
| 2-1 | sort 1 | `vents_cast.png` |
| 2-2 | sort 2 | `vents_cast_2.png` |
| 2-3 | marche | `vents_walk.png` |

#### Planche 3 — Actions de dos · mêmes 6 poses vues de dos (`actions_dos`)

**Édition d'image**, source = la planche `vues`. 

```text
Image edit — sprite sheet for a chibi isometric tactical RPG showing 6 action poses seen from BEHIND of ONE final boss: Aéron le Céleste, armed with: tall silver staff with a wing-shaped crystal, RIGHT hand.
SOURCE IMAGE: it shows this final boss, Aéron le Céleste, in 4 idle views (top row from the front, bottom row from behind). Keep EXACTLY the character of the source image: same face, hair color, eyes, outfit, colors, proportions, accessories, weapon in the same hand. The 6 new poses must show this SAME character, unchanged. Use the BACK views of the source as the reference for the back of the outfit.
CHARACTER ID CARD — copy these features EXACTLY in every pose; they NEVER change between images:
- Name: Aéron le Céleste (boss of the Vents nation)
- Body: celestial lord in pale cyan feathered armor (#BDEFFF) with long flowing feather layers
- Head: crown of silver spikes, long white hair, pale blue eyes
- Weapon: tall silver staff with a wing-shaped crystal, RIGHT hand
- Nothing else: do not add clothing, colors or accessories that are not listed.
- FORBIDDEN variations: no helmet, no dark colors.
WEAPON: tall silver staff with a wing-shaped crystal, RIGHT hand. It is held in the SAME hand and is clearly visible in all 6 poses: never missing, never swapped for another weapon (a bow stays a bow, a staff stays a staff), never a different shape or color.
TASK: replace the 4 idle views with 6 ACTION poses, ALL in the same view: 3/4 BACK view: the character is seen from behind and turns slightly to the right (back of the head and right shoulder visible), facing away from the viewer toward the upper right; we see the BACK of the head: no face, no eyes. Never a pure side profile, never facing left; no face and no eyes visible in any pose.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Ankama style (Dofus, Waven, Wakfu): chibi proportions with a very big head (about 40% of total height), short round body, big hands, small rounded feet, large expressive eyes, soft rounded shapes everywhere. Clean bold dark-brown outlines (thicker on the outer silhouette, thinner inside), flat colors with 2-3 tone cel shading and very few gradients, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, strong readable silhouette at small size. Soft key light from the upper left, with only a thin subtle pale sky white highlight along the right edge (a clean edge highlight, NOT a glow, haze, flare or color tint over the sprite; identical lighting in every cell).
LAYOUT: 6 poses arranged as 3 columns x 2 rows on a wide 2:1 image (as large as possible, e.g. 2048x1024), like six separate stickers floating on the background. Each pose occupies at most 55% of the width and height of its sixth of the image and is centered in it, so that there is a wide empty space, especially horizontally, between any two poses; the character AND its weapon, cape, hair, tail and effects stay inside its own sixth, nothing touches or overlaps a neighbouring pose. Long weapons, capes and wide effects are drawn smaller or tucked in so they fit. The 6 sprites have EXACTLY the same size: same scale, same height in pixels, same proportions — if one sprite looks bigger or smaller than the others it is wrong. Feet on the same ground line in each row. No frames, boxes, borders or dividing lines between poses, no floor, no grid on the ground.
POSES, left to right, top to bottom:
1. OVERHEAD STRIKE: staff raised high above the head with both hands.
2. THRUST: body leaning forward, staff tip pushed far ahead with a short wind ribbons and feathers spark.
3. SIDE SWING: staff swept horizontally at shoulder height, torso twisted.
4. FOCUS: eyes closed, staff held vertically in front of the face, wind ribbons and feathers orb at the top.
5. INVOCATION: staff raised high with both hands, wind ribbons and feathers swirling above the head.
6. WALK: mid-stride, one foot raised, arms swinging naturally, weapon held.
The 6 poses MUST be clearly different from each other: different arm, leg and weapon positions, different body angle and height. Never repeat or copy a pose; if two poses look alike, change one.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small, kept close to the character inside its own sixth of the image.
BACKGROUND: keep the plain flat background of the source image (Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it)), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
WEAPON CHECK: tall silver staff with a wing-shaped crystal, RIGHT hand — visible in EVERY one of the 6 poses (held or used).
REMINDER: this is Aéron le Céleste: tall silver staff with a wing-shaped crystal, RIGHT hand; celestial lord in pale cyan feathered armor (#BDEFFF) with long flowing feather layers; crown of silver spikes, long white hair, pale blue eyes. The WEAPON never changes and is never replaced (a bow stays a bow, a staff stays a staff). Forbidden: no helmet, no dark colors. Every sprite faces RIGHT (front or back 3/4), never left.
```

| Case | Pose | Fichier |
|---|---|---|
| 1-1 | attaque 1 — dos | `vents_back_attack.png` |
| 1-2 | attaque 2 — dos | `vents_back_attack_2.png` |
| 1-3 | attaque 3 — dos | `vents_back_attack_3.png` |
| 2-1 | sort 1 — dos | `vents_back_cast.png` |
| 2-2 | sort 2 — dos | `vents_back_cast_2.png` |
| 2-3 | marche — dos | `vents_back_walk.png` |

## Prompt négatif

**Personnages armés — planches vues** :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, golden glow, light flare, sun rays, color tint over the sprite, glowing aura on one side, cream background, beige background, colored background, ground shadow ellipse, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, weapon changing shape, weapon changing color, weapon replaced by another weapon, missing weapon, missing accessories, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, different character between poses, realistic proportions, small head, more than 4 sprites, extra sprites, duplicated row of sprites, one sprite bigger or smaller than the others, size changing between cells
```

**Personnages armés — planches actions et planche de style** :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, golden glow, light flare, sun rays, color tint over the sprite, glowing aura on one side, cream background, beige background, colored background, ground shadow ellipse, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, weapon changing shape, weapon changing color, weapon replaced by another weapon, missing weapon, missing accessories, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, weapon drawn alone without the character, extra objects, different character between poses, realistic proportions, small head
```

**Créatures sans arme (Salamandre, golems, bêtes…) — planches vues** :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, golden glow, light flare, sun rays, color tint over the sprite, glowing aura on one side, cream background, beige background, colored background, ground shadow ellipse, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, extra objects, different character between poses, realistic proportions, small head, more than 4 sprites, extra sprites, duplicated row of sprites, one sprite bigger or smaller than the others, size changing between cells, weapon, torch, staff, sword, bow, held object, tool, item in the hands or claws
```

**Créatures sans arme — planches actions** :

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, golden glow, light flare, sun rays, color tint over the sprite, glowing aura on one side, cream background, beige background, colored background, ground shadow ellipse, photorealistic, 3D render, pixel art, frames around poses, boxes, borders, dividing lines, grid lines, isometric floor grid, tiles, duplicate poses in the same viewing angle, identical poses side by side, the same pose copied twice in the same view, front and back mixed inside one cell, closed eyes, looking up at the sky, different hair color, different eye color, different hairstyle, new clothing pieces, extra objects, different character between poses, realistic proportions, small head, weapon, torch, staff, sword, bow, held object, tool, item in the hands or claws
```
