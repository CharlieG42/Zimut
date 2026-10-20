# Nation Sylvestre (Forêt)

Palette : moss green, bark brown, leaf gold, small emerald glows. Effets : green leaves and glowing spores. Contre-jour : warm golden sunlight.

Ordre conseillé : 1) planche de référence, 2) héros (en joignant la planche 1 comme image de référence), 3) ennemis, 4) boss. Prompt négatif : voir en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes. Joins-la comme image de référence aux planches suivantes.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Sylvestre nation (Forêt biome).
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows. Signature effects: green leaves and glowing spores.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
LAYOUT: 6 characters standing side by side in ONE single row, all in idle pose, all in 3/4 view facing front-right, all feet on the same ground line, a wide empty gap between characters (at least half a character width). Nobody overlaps or touches another character.
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

### Druide — 12 poses

Grille 4 × 3.

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Druide, hero of the Sylvestre nation. Young druid with messy dark green hair, layered armor-robe made of overlapping leaves and bark plates in moss green and brown, leather belts, a tall wooden staff topped with a carved leaf-shaped emerald crystal held in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
GRID: Strict grid of 4 columns x 3 rows, 12 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised, same stance.
3. idle variant, alert, glancing to the side, weapon ready.
4. idle seen from behind, 3/4 back-right view.
5. walking, 3/4 front-right, mid-stride, left foot forward.
6. wind-up, staff held back with both hands.
7. staff swing forward, small green leaves and glowing spores burst at the tip.
8. follow-through, staff low, body turned.
9. thrust with the staff tip forward, short green leaves and glowing spores spark.
10. staff raised, green leaves and glowing spores orb forming at the top.
11. staff held high with both hands, green leaves and glowing spores swirling around.
12. staff pointed forward, releasing a compact green leaves and glowing spores blast.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/players/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `druide` | `druide.png` |
| 1-2 | repos 2 | `druide_idle_2` | `druide_idle_2.png` |
| 1-3 | repos 3 | `druide_idle_3` | `druide_idle_3.png` |
| 1-4 | dos | `druide_back` | `druide_back.png` |
| 2-1 | marche | `druide_walk` | `druide_walk.png` |
| 2-2 | attaque 1 | `druide_attack` | `druide_attack.png` |
| 2-3 | attaque 2 | `druide_attack_2` | `druide_attack_2.png` |
| 2-4 | attaque 3 | `druide_attack_3` | `druide_attack_3.png` |
| 3-1 | attaque 4 | `druide_attack_4` | `druide_attack_4.png` |
| 3-2 | sort 1 | `druide_cast` | `druide_cast.png` |
| 3-3 | sort 2 | `druide_cast_2` | `druide_cast_2.png` |
| 3-4 | sort 3 | `druide_cast_3` | `druide_cast_3.png` |

Copie conseillée de la pose de repos vers `prototype/zimut/assets/sprites/nations/heros/druide.png` et des poses vers `nations/heros/poses/`.

## 3. Ennemis

### Araknéa — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Araknéa, enemy of the Sylvestre nation. Forest spider-beetle with an emerald armored carapace, curved horns, sharp mandibles and six legs.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. crouched wind-up, ready to pounce.
6. lunge forward, jaws or claws first, small green leaves and glowing spores impact.
7. head raised, green leaves and glowing spores gathering around the body.
8. releasing a short green leaves and glowing spores breath or wave forward.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/sylvestre/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `araknea` | `araknea.png` |
| 1-2 | repos 2 | `araknea_idle_2` | `araknea_idle_2.png` |
| 1-3 | dos | `araknea_back` | `araknea_back.png` |
| 1-4 | marche | `araknea_walk` | `araknea_walk.png` |
| 2-1 | attaque 1 | `araknea_attack` | `araknea_attack.png` |
| 2-2 | attaque 2 | `araknea_attack_2` | `araknea_attack_2.png` |
| 2-3 | sort 1 | `araknea_cast` | `araknea_cast.png` |
| 2-4 | sort 2 | `araknea_cast_2` | `araknea_cast_2.png` |

### Loup forestier — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Loup forestier, enemy of the Sylvestre nation. Sturdy wolf with dark moss-green fur, a mane of leaves and twigs, amber eyes.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. crouched wind-up, ready to pounce.
6. lunge forward, jaws or claws first, small green leaves and glowing spores impact.
7. head raised, green leaves and glowing spores gathering around the body.
8. releasing a short green leaves and glowing spores breath or wave forward.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/sylvestre/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `loup_forestier` | `loup_forestier.png` |
| 1-2 | repos 2 | `loup_forestier_idle_2` | `loup_forestier_idle_2.png` |
| 1-3 | dos | `loup_forestier_back` | `loup_forestier_back.png` |
| 1-4 | marche | `loup_forestier_walk` | `loup_forestier_walk.png` |
| 2-1 | attaque 1 | `loup_forestier_attack` | `loup_forestier_attack.png` |
| 2-2 | attaque 2 | `loup_forestier_attack_2` | `loup_forestier_attack_2.png` |
| 2-3 | sort 1 | `loup_forestier_cast` | `loup_forestier_cast.png` |
| 2-4 | sort 2 | `loup_forestier_cast_2` | `loup_forestier_cast_2.png` |

### Dryade — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Dryade, enemy of the Sylvestre nation. Dryad archer whose body is made of branches and leaves, wooden bow, leafy hair.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. drawing the bow, arrow nocked, string pulled to the cheek.
6. release, arrow flying forward with a short green leaves and glowing spores trail.
7. arrow raised to the sky, green leaves and glowing spores gathering on the arrowhead.
8. releasing a volley of three green leaves and glowing spores arrows into the air.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/sylvestre/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `dryade` | `dryade.png` |
| 1-2 | repos 2 | `dryade_idle_2` | `dryade_idle_2.png` |
| 1-3 | dos | `dryade_back` | `dryade_back.png` |
| 1-4 | marche | `dryade_walk` | `dryade_walk.png` |
| 2-1 | attaque 1 | `dryade_attack` | `dryade_attack.png` |
| 2-2 | attaque 2 | `dryade_attack_2` | `dryade_attack_2.png` |
| 2-3 | sort 1 | `dryade_cast` | `dryade_cast.png` |
| 2-4 | sort 2 | `dryade_cast_2` | `dryade_cast_2.png` |

### Tréant — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Tréant, enemy of the Sylvestre nation. Walking tree trunk brute covered in moss and leaves, root-like legs, glowing green eyes.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. wind-up, fist or weapon raised high.
6. heavy smash forward, ground cracking with a small green leaves and glowing spores burst.
7. stomping, green leaves and glowing spores cracks spreading under the feet.
8. slamming both fists down, green leaves and glowing spores shockwave.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/sylvestre/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `treant` | `treant.png` |
| 1-2 | repos 2 | `treant_idle_2` | `treant_idle_2.png` |
| 1-3 | dos | `treant_back` | `treant_back.png` |
| 1-4 | marche | `treant_walk` | `treant_walk.png` |
| 2-1 | attaque 1 | `treant_attack` | `treant_attack.png` |
| 2-2 | attaque 2 | `treant_attack_2` | `treant_attack_2.png` |
| 2-3 | sort 1 | `treant_cast` | `treant_cast.png` |
| 2-4 | sort 2 | `treant_cast_2` | `treant_cast_2.png` |

## 4. Boss

### Tharok le Végétal — 12 poses

Grille 4 × 3.

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Tharok le Végétal, boss of the Sylvestre nation. Towering forest giant with a body of bark and moss, great deer antlers covered in leaves, a long beard of hanging moss, wielding a thorny wooden club set with a green crystal, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
NATION PALETTE: moss green, bark brown, leaf gold, small emerald glows.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden sunlight rim light on the right edge.
GRID: Strict grid of 4 columns x 3 rows, 12 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised, same stance.
3. idle variant, alert, glancing to the side, weapon ready.
4. idle seen from behind, 3/4 back-right view.
5. walking, 3/4 front-right, mid-stride, left foot forward.
6. wind-up, fist or weapon raised high.
7. heavy smash forward, ground cracking with a small green leaves and glowing spores burst.
8. follow-through, body leaning forward.
9. sweeping backhand blow.
10. stomping, green leaves and glowing spores cracks spreading under the feet.
11. arms raised, green leaves and glowing spores gathering between the hands.
12. slamming both fists down, green leaves and glowing spores shockwave.
EFFECTS: green leaves and glowing spores, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/boss/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `sylvestre` | `sylvestre.png` |
| 1-2 | repos 2 | `sylvestre_idle_2` | `sylvestre_idle_2.png` |
| 1-3 | repos 3 | `sylvestre_idle_3` | `sylvestre_idle_3.png` |
| 1-4 | dos | `sylvestre_back` | `sylvestre_back.png` |
| 2-1 | marche | `sylvestre_walk` | `sylvestre_walk.png` |
| 2-2 | attaque 1 | `sylvestre_attack` | `sylvestre_attack.png` |
| 2-3 | attaque 2 | `sylvestre_attack_2` | `sylvestre_attack_2.png` |
| 2-4 | attaque 3 | `sylvestre_attack_3` | `sylvestre_attack_3.png` |
| 3-1 | attaque 4 | `sylvestre_attack_4` | `sylvestre_attack_4.png` |
| 3-2 | sort 1 | `sylvestre_cast` | `sylvestre_cast.png` |
| 3-3 | sort 2 | `sylvestre_cast_2` | `sylvestre_cast_2.png` |
| 3-4 | sort 3 | `sylvestre_cast_3` | `sylvestre_cast_3.png` |

## Prompt négatif (toutes les planches de cette page)

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art
```
