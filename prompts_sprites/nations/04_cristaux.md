# Nation Cristaux (Cristaux)

Palette : silver white, sapphire blue, amethyst violet. Effets : prismatic blue and violet crystal shards. Contre-jour : violet.

Ordre conseillé : 1) planche de référence, 2) héros (en joignant la planche 1 comme image de référence), 3) ennemis, 4) boss. Prompt négatif : voir en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes. Joins-la comme image de référence aux planches suivantes.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Cristaux nation (Cristaux biome).
NATION PALETTE: silver white, sapphire blue, amethyst violet. Signature effects: prismatic blue and violet crystal shards.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 6 characters standing side by side in ONE single row, all in idle pose, all in 3/4 view facing front-right, all feet on the same ground line, a wide empty gap between characters (at least half a character width). Nobody overlaps or touches another character.
CHARACTERS, left to right:
1. the hero (Mage: young mage with dark blue hair, long silver-white robe with crystal patterns and sapphire trims, an ornate silver staff topped with a glowing blue crystal in the right hand).
2. Araignée de cristal (spider made of violet amethyst crystals with ice-blue glowing legs).
3. Mage cristallin (slender crystal mage with violet crystal hair and a pale blue body, crystal staff).
4. Golem de cristal (heavy golem made of violet and blue crystal clusters).
5. Élémentaire de cristal (floating elemental made of sharp violet crystal shards in a humanoid shape).
6. the final boss Zyphéron le Cristallin (tall crystal sorcerer with a crown of ice-blue shards, long robe of shattered pale crystal plates, holding an ornate crystal staff), about 1.5x taller than the others.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Mage — 12 poses

Grille 4 × 3.

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Mage, hero of the Cristaux nation. Young mage with dark blue hair, long silver-white robe with crystal patterns and sapphire trims, an ornate silver staff topped with a glowing blue crystal in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 3 rows, 12 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised, same stance.
3. idle variant, alert, glancing to the side, weapon ready.
4. idle seen from behind, 3/4 back-right view.
5. walking, 3/4 front-right, mid-stride, left foot forward.
6. wind-up, staff held back with both hands.
7. staff swing forward, small prismatic blue and violet crystal shards burst at the tip.
8. follow-through, staff low, body turned.
9. thrust with the staff tip forward, short prismatic blue and violet crystal shards spark.
10. staff raised, prismatic blue and violet crystal shards orb forming at the top.
11. staff held high with both hands, prismatic blue and violet crystal shards swirling around.
12. staff pointed forward, releasing a compact prismatic blue and violet crystal shards blast.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/players/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `mage` | `mage.png` |
| 1-2 | repos 2 | `mage_idle_2` | `mage_idle_2.png` |
| 1-3 | repos 3 | `mage_idle_3` | `mage_idle_3.png` |
| 1-4 | dos | `mage_back` | `mage_back.png` |
| 2-1 | marche | `mage_walk` | `mage_walk.png` |
| 2-2 | attaque 1 | `mage_attack` | `mage_attack.png` |
| 2-3 | attaque 2 | `mage_attack_2` | `mage_attack_2.png` |
| 2-4 | attaque 3 | `mage_attack_3` | `mage_attack_3.png` |
| 3-1 | attaque 4 | `mage_attack_4` | `mage_attack_4.png` |
| 3-2 | sort 1 | `mage_cast` | `mage_cast.png` |
| 3-3 | sort 2 | `mage_cast_2` | `mage_cast_2.png` |
| 3-4 | sort 3 | `mage_cast_3` | `mage_cast_3.png` |

Copie conseillée de la pose de repos vers `prototype/zimut/assets/sprites/nations/heros/mage.png` et des poses vers `nations/heros/poses/`.

## 3. Ennemis

### Araignée de cristal — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Araignée de cristal, enemy of the Cristaux nation. Spider made of violet amethyst crystals with ice-blue glowing legs.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. crouched wind-up, ready to pounce.
6. lunge forward, jaws or claws first, small prismatic blue and violet crystal shards impact.
7. head raised, prismatic blue and violet crystal shards gathering around the body.
8. releasing a short prismatic blue and violet crystal shards breath or wave forward.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/cristaux/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `araignee_de_cristal` | `araignee_de_cristal.png` |
| 1-2 | repos 2 | `araignee_de_cristal_idle_2` | `araignee_de_cristal_idle_2.png` |
| 1-3 | dos | `araignee_de_cristal_back` | `araignee_de_cristal_back.png` |
| 1-4 | marche | `araignee_de_cristal_walk` | `araignee_de_cristal_walk.png` |
| 2-1 | attaque 1 | `araignee_de_cristal_attack` | `araignee_de_cristal_attack.png` |
| 2-2 | attaque 2 | `araignee_de_cristal_attack_2` | `araignee_de_cristal_attack_2.png` |
| 2-3 | sort 1 | `araignee_de_cristal_cast` | `araignee_de_cristal_cast.png` |
| 2-4 | sort 2 | `araignee_de_cristal_cast_2` | `araignee_de_cristal_cast_2.png` |

### Mage cristallin — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Mage cristallin, enemy of the Cristaux nation. Slender crystal mage with violet crystal hair and a pale blue body, crystal staff.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. wind-up, staff held back with both hands.
6. staff swing forward, small prismatic blue and violet crystal shards burst at the tip.
7. staff raised, prismatic blue and violet crystal shards orb forming at the top.
8. staff pointed forward, releasing a compact prismatic blue and violet crystal shards blast.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/cristaux/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `mage_cristallin` | `mage_cristallin.png` |
| 1-2 | repos 2 | `mage_cristallin_idle_2` | `mage_cristallin_idle_2.png` |
| 1-3 | dos | `mage_cristallin_back` | `mage_cristallin_back.png` |
| 1-4 | marche | `mage_cristallin_walk` | `mage_cristallin_walk.png` |
| 2-1 | attaque 1 | `mage_cristallin_attack` | `mage_cristallin_attack.png` |
| 2-2 | attaque 2 | `mage_cristallin_attack_2` | `mage_cristallin_attack_2.png` |
| 2-3 | sort 1 | `mage_cristallin_cast` | `mage_cristallin_cast.png` |
| 2-4 | sort 2 | `mage_cristallin_cast_2` | `mage_cristallin_cast_2.png` |

### Golem de cristal — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Golem de cristal, enemy of the Cristaux nation. Heavy golem made of violet and blue crystal clusters.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. wind-up, fist or weapon raised high.
6. heavy smash forward, ground cracking with a small prismatic blue and violet crystal shards burst.
7. stomping, prismatic blue and violet crystal shards cracks spreading under the feet.
8. slamming both fists down, prismatic blue and violet crystal shards shockwave.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/cristaux/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `golem_de_cristal` | `golem_de_cristal.png` |
| 1-2 | repos 2 | `golem_de_cristal_idle_2` | `golem_de_cristal_idle_2.png` |
| 1-3 | dos | `golem_de_cristal_back` | `golem_de_cristal_back.png` |
| 1-4 | marche | `golem_de_cristal_walk` | `golem_de_cristal_walk.png` |
| 2-1 | attaque 1 | `golem_de_cristal_attack` | `golem_de_cristal_attack.png` |
| 2-2 | attaque 2 | `golem_de_cristal_attack_2` | `golem_de_cristal_attack_2.png` |
| 2-3 | sort 1 | `golem_de_cristal_cast` | `golem_de_cristal_cast.png` |
| 2-4 | sort 2 | `golem_de_cristal_cast_2` | `golem_de_cristal_cast_2.png` |

### Élémentaire de cristal — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Élémentaire de cristal, enemy of the Cristaux nation. Floating elemental made of sharp violet crystal shards in a humanoid shape.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. drawing back, body stretched upward.
6. lunging forward, claws of prismatic blue and violet crystal shards reaching out.
7. hovering higher, prismatic blue and violet crystal shards orbs circling the body.
8. releasing a compact prismatic blue and violet crystal shards wave forward.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/cristaux/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `elementaire_de_cristal` | `elementaire_de_cristal.png` |
| 1-2 | repos 2 | `elementaire_de_cristal_idle_2` | `elementaire_de_cristal_idle_2.png` |
| 1-3 | dos | `elementaire_de_cristal_back` | `elementaire_de_cristal_back.png` |
| 1-4 | marche | `elementaire_de_cristal_walk` | `elementaire_de_cristal_walk.png` |
| 2-1 | attaque 1 | `elementaire_de_cristal_attack` | `elementaire_de_cristal_attack.png` |
| 2-2 | attaque 2 | `elementaire_de_cristal_attack_2` | `elementaire_de_cristal_attack_2.png` |
| 2-3 | sort 1 | `elementaire_de_cristal_cast` | `elementaire_de_cristal_cast.png` |
| 2-4 | sort 2 | `elementaire_de_cristal_cast_2` | `elementaire_de_cristal_cast_2.png` |

## 4. Boss

### Zyphéron le Cristallin — 12 poses

Grille 4 × 3.

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Zyphéron le Cristallin, boss of the Cristaux nation. Tall crystal sorcerer with a crown of ice-blue shards, long robe of shattered pale crystal plates, holding an ornate crystal staff, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
NATION PALETTE: silver white, sapphire blue, amethyst violet.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 3 rows, 12 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised, same stance.
3. idle variant, alert, glancing to the side, weapon ready.
4. idle seen from behind, 3/4 back-right view.
5. walking, 3/4 front-right, mid-stride, left foot forward.
6. wind-up, staff held back with both hands.
7. staff swing forward, small prismatic blue and violet crystal shards burst at the tip.
8. follow-through, staff low, body turned.
9. thrust with the staff tip forward, short prismatic blue and violet crystal shards spark.
10. staff raised, prismatic blue and violet crystal shards orb forming at the top.
11. staff held high with both hands, prismatic blue and violet crystal shards swirling around.
12. staff pointed forward, releasing a compact prismatic blue and violet crystal shards blast.
EFFECTS: prismatic blue and violet crystal shards, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/boss/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `cristaux` | `cristaux.png` |
| 1-2 | repos 2 | `cristaux_idle_2` | `cristaux_idle_2.png` |
| 1-3 | repos 3 | `cristaux_idle_3` | `cristaux_idle_3.png` |
| 1-4 | dos | `cristaux_back` | `cristaux_back.png` |
| 2-1 | marche | `cristaux_walk` | `cristaux_walk.png` |
| 2-2 | attaque 1 | `cristaux_attack` | `cristaux_attack.png` |
| 2-3 | attaque 2 | `cristaux_attack_2` | `cristaux_attack_2.png` |
| 2-4 | attaque 3 | `cristaux_attack_3` | `cristaux_attack_3.png` |
| 3-1 | attaque 4 | `cristaux_attack_4` | `cristaux_attack_4.png` |
| 3-2 | sort 1 | `cristaux_cast` | `cristaux_cast.png` |
| 3-3 | sort 2 | `cristaux_cast_2` | `cristaux_cast_2.png` |
| 3-4 | sort 3 | `cristaux_cast_3` | `cristaux_cast_3.png` |

## Prompt négatif (toutes les planches de cette page)

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art
```
