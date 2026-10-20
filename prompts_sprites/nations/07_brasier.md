# Nation Brasier (Brasier)

Palette : crimson red, black obsidian, ember orange, gold. Effets : flames and embers. Contre-jour : orange ember.

Ordre conseillé : 1) planche de référence, 2) héros (en joignant la planche 1 comme image de référence), 3) ennemis, 4) boss. Prompt négatif : voir en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes. Joins-la comme image de référence aux planches suivantes.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Brasier nation (Brasier biome).
NATION PALETTE: crimson red, black obsidian, ember orange, gold. Signature effects: flames and embers.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
LAYOUT: 6 characters standing side by side in ONE single row, all in idle pose, all in 3/4 view facing front-right, all feet on the same ground line, a wide empty gap between characters (at least half a character width). Nobody overlaps or touches another character.
CHARACTERS, left to right:
1. the hero (Chasseur: hunter with long red hair in a high ponytail, red and black armor with flame-shaped plates and glowing ember cracks, a red scarf, quiver of arrows on the back, a curved flame-patterned bow in the left hand).
2. Lieutenant (fire cultist lieutenant in orange and red robes holding a flaming staff).
3. Salamandre (orange lava lizard with glowing cracks on its back and a flaming tail).
4. Dévoreur de flammes (fiery orange beast with a mane of flames and big claws).
5. Golem de lave (dark basalt golem with bright orange lava cracks and a molten core).
6. the final boss Kharaz le Flamboyant (flame warlord with burning hair, black and crimson ember armor with sharp plates, holding a great curved flame bow), about 1.5x taller than the others.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Chasseur — 12 poses

Grille 4 × 3.

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Chasseur, hero of the Brasier nation. Hunter with long red hair in a high ponytail, red and black armor with flame-shaped plates and glowing ember cracks, a red scarf, quiver of arrows on the back, a curved flame-patterned bow in the left hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
GRID: Strict grid of 4 columns x 3 rows, 12 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised, same stance.
3. idle variant, alert, glancing to the side, weapon ready.
4. idle seen from behind, 3/4 back-right view.
5. walking, 3/4 front-right, mid-stride, left foot forward.
6. drawing the bow, arrow nocked, string pulled to the cheek.
7. release, arrow flying forward with a short flames and embers trail.
8. follow-through, bow arm extended, string hand open behind.
9. quick shot from a low crouch, bow tilted.
10. arrow raised to the sky, flames and embers gathering on the arrowhead.
11. aiming upward, the arrow fully wrapped in flames and embers.
12. releasing a volley of three flames and embers arrows into the air.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/players/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `chasseur` | `chasseur.png` |
| 1-2 | repos 2 | `chasseur_idle_2` | `chasseur_idle_2.png` |
| 1-3 | repos 3 | `chasseur_idle_3` | `chasseur_idle_3.png` |
| 1-4 | dos | `chasseur_back` | `chasseur_back.png` |
| 2-1 | marche | `chasseur_walk` | `chasseur_walk.png` |
| 2-2 | attaque 1 | `chasseur_attack` | `chasseur_attack.png` |
| 2-3 | attaque 2 | `chasseur_attack_2` | `chasseur_attack_2.png` |
| 2-4 | attaque 3 | `chasseur_attack_3` | `chasseur_attack_3.png` |
| 3-1 | attaque 4 | `chasseur_attack_4` | `chasseur_attack_4.png` |
| 3-2 | sort 1 | `chasseur_cast` | `chasseur_cast.png` |
| 3-3 | sort 2 | `chasseur_cast_2` | `chasseur_cast_2.png` |
| 3-4 | sort 3 | `chasseur_cast_3` | `chasseur_cast_3.png` |

Copie conseillée de la pose de repos vers `prototype/zimut/assets/sprites/nations/heros/chasseur.png` et des poses vers `nations/heros/poses/`.

## 3. Ennemis

### Lieutenant — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Lieutenant, enemy of the Brasier nation. Fire cultist lieutenant in orange and red robes holding a flaming staff.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. wind-up, staff held back with both hands.
6. staff swing forward, small flames and embers burst at the tip.
7. staff raised, flames and embers orb forming at the top.
8. staff pointed forward, releasing a compact flames and embers blast.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/brasier/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `lieutenant` | `lieutenant.png` |
| 1-2 | repos 2 | `lieutenant_idle_2` | `lieutenant_idle_2.png` |
| 1-3 | dos | `lieutenant_back` | `lieutenant_back.png` |
| 1-4 | marche | `lieutenant_walk` | `lieutenant_walk.png` |
| 2-1 | attaque 1 | `lieutenant_attack` | `lieutenant_attack.png` |
| 2-2 | attaque 2 | `lieutenant_attack_2` | `lieutenant_attack_2.png` |
| 2-3 | sort 1 | `lieutenant_cast` | `lieutenant_cast.png` |
| 2-4 | sort 2 | `lieutenant_cast_2` | `lieutenant_cast_2.png` |

### Salamandre — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Salamandre, enemy of the Brasier nation. Orange lava lizard with glowing cracks on its back and a flaming tail.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. crouched wind-up, ready to pounce.
6. lunge forward, jaws or claws first, small flames and embers impact.
7. head raised, flames and embers gathering around the body.
8. releasing a short flames and embers breath or wave forward.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/brasier/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `salamandre` | `salamandre.png` |
| 1-2 | repos 2 | `salamandre_idle_2` | `salamandre_idle_2.png` |
| 1-3 | dos | `salamandre_back` | `salamandre_back.png` |
| 1-4 | marche | `salamandre_walk` | `salamandre_walk.png` |
| 2-1 | attaque 1 | `salamandre_attack` | `salamandre_attack.png` |
| 2-2 | attaque 2 | `salamandre_attack_2` | `salamandre_attack_2.png` |
| 2-3 | sort 1 | `salamandre_cast` | `salamandre_cast.png` |
| 2-4 | sort 2 | `salamandre_cast_2` | `salamandre_cast_2.png` |

### Dévoreur de flammes — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Dévoreur de flammes, enemy of the Brasier nation. Fiery orange beast with a mane of flames and big claws.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. crouched wind-up, ready to pounce.
6. lunge forward, jaws or claws first, small flames and embers impact.
7. head raised, flames and embers gathering around the body.
8. releasing a short flames and embers breath or wave forward.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/brasier/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `devoreur_de_flammes` | `devoreur_de_flammes.png` |
| 1-2 | repos 2 | `devoreur_de_flammes_idle_2` | `devoreur_de_flammes_idle_2.png` |
| 1-3 | dos | `devoreur_de_flammes_back` | `devoreur_de_flammes_back.png` |
| 1-4 | marche | `devoreur_de_flammes_walk` | `devoreur_de_flammes_walk.png` |
| 2-1 | attaque 1 | `devoreur_de_flammes_attack` | `devoreur_de_flammes_attack.png` |
| 2-2 | attaque 2 | `devoreur_de_flammes_attack_2` | `devoreur_de_flammes_attack_2.png` |
| 2-3 | sort 1 | `devoreur_de_flammes_cast` | `devoreur_de_flammes_cast.png` |
| 2-4 | sort 2 | `devoreur_de_flammes_cast_2` | `devoreur_de_flammes_cast_2.png` |

### Golem de lave — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Golem de lave, enemy of the Brasier nation. Dark basalt golem with bright orange lava cracks and a molten core.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. wind-up, fist or weapon raised high.
6. heavy smash forward, ground cracking with a small flames and embers burst.
7. stomping, flames and embers cracks spreading under the feet.
8. slamming both fists down, flames and embers shockwave.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/brasier/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `golem_de_lave` | `golem_de_lave.png` |
| 1-2 | repos 2 | `golem_de_lave_idle_2` | `golem_de_lave_idle_2.png` |
| 1-3 | dos | `golem_de_lave_back` | `golem_de_lave_back.png` |
| 1-4 | marche | `golem_de_lave_walk` | `golem_de_lave_walk.png` |
| 2-1 | attaque 1 | `golem_de_lave_attack` | `golem_de_lave_attack.png` |
| 2-2 | attaque 2 | `golem_de_lave_attack_2` | `golem_de_lave_attack_2.png` |
| 2-3 | sort 1 | `golem_de_lave_cast` | `golem_de_lave_cast.png` |
| 2-4 | sort 2 | `golem_de_lave_cast_2` | `golem_de_lave_cast_2.png` |

## 4. Boss

### Kharaz le Flamboyant — 12 poses

Grille 4 × 3.

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Kharaz le Flamboyant, boss of the Brasier nation. Flame warlord with burning hair, black and crimson ember armor with sharp plates, holding a great curved flame bow, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
NATION PALETTE: crimson red, black obsidian, ember orange, gold.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle orange ember rim light on the right edge.
GRID: Strict grid of 4 columns x 3 rows, 12 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised, same stance.
3. idle variant, alert, glancing to the side, weapon ready.
4. idle seen from behind, 3/4 back-right view.
5. walking, 3/4 front-right, mid-stride, left foot forward.
6. drawing the bow, arrow nocked, string pulled to the cheek.
7. release, arrow flying forward with a short flames and embers trail.
8. follow-through, bow arm extended, string hand open behind.
9. quick shot from a low crouch, bow tilted.
10. arrow raised to the sky, flames and embers gathering on the arrowhead.
11. aiming upward, the arrow fully wrapped in flames and embers.
12. releasing a volley of three flames and embers arrows into the air.
EFFECTS: flames and embers, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/boss/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `brasier` | `brasier.png` |
| 1-2 | repos 2 | `brasier_idle_2` | `brasier_idle_2.png` |
| 1-3 | repos 3 | `brasier_idle_3` | `brasier_idle_3.png` |
| 1-4 | dos | `brasier_back` | `brasier_back.png` |
| 2-1 | marche | `brasier_walk` | `brasier_walk.png` |
| 2-2 | attaque 1 | `brasier_attack` | `brasier_attack.png` |
| 2-3 | attaque 2 | `brasier_attack_2` | `brasier_attack_2.png` |
| 2-4 | attaque 3 | `brasier_attack_3` | `brasier_attack_3.png` |
| 3-1 | attaque 4 | `brasier_attack_4` | `brasier_attack_4.png` |
| 3-2 | sort 1 | `brasier_cast` | `brasier_cast.png` |
| 3-3 | sort 2 | `brasier_cast_2` | `brasier_cast_2.png` |
| 3-4 | sort 3 | `brasier_cast_3` | `brasier_cast_3.png` |

## Prompt négatif (toutes les planches de cette page)

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art
```
