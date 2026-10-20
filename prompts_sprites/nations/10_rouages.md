# Nation Rouages (Rouages)

Palette : brass, copper, dark steel, teal glowing lights. Effets : sparks, steam puffs and teal electric arcs. Contre-jour : warm brass.

Ordre conseillé : 1) planche de référence, 2) héros (en joignant la planche 1 comme image de référence), 3) ennemis, 4) boss. Prompt négatif : voir en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes. Joins-la comme image de référence aux planches suivantes.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Rouages nation (Rouages biome).
NATION PALETTE: brass, copper, dark steel, teal glowing lights. Signature effects: sparks, steam puffs and teal electric arcs.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm brass rim light on the right edge.
LAYOUT: 6 characters standing side by side in ONE single row, all in idle pose, all in 3/4 view facing front-right, all feet on the same ground line, a wide empty gap between characters (at least half a character width). Nobody overlaps or touches another character.
CHARACTERS, left to right:
1. the hero (Artificier: young engineer with spiky brown hair, brass goggles on the forehead, bronze and steel steampunk armor with teal glowing gems, tool belt with pouches, a big gear-headed hammer in the right hand).
2. Drone aérien (bronze flying drone with claw arms, small propellers and a glowing blue core).
3. Araignée mécanique (bronze mechanical spider with long jointed legs and a blue gem eye).
4. Roue engrenée (rolling bronze cog-wheel creature with a single glowing blue gem eye in the center).
5. Automate de combat (heavy combat automaton of riveted bronze and stone plates with big fists).
6. the final boss Mécanoptère, Colosse d'Engrenages (giant steam colossus of steel and brass with two smoking chimneys on the back, a glowing blue core in the chest and a huge gear hammer), about 1.5x taller than the others.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Artificier — 12 poses

Grille 4 × 3.

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Artificier, hero of the Rouages nation. Young engineer with spiky brown hair, brass goggles on the forehead, bronze and steel steampunk armor with teal glowing gems, tool belt with pouches, a big gear-headed hammer in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm brass rim light on the right edge.
GRID: Strict grid of 4 columns x 3 rows, 12 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised, same stance.
3. idle variant, alert, glancing to the side, weapon ready.
4. idle seen from behind, 3/4 back-right view.
5. walking, 3/4 front-right, mid-stride, left foot forward.
6. wind-up, gear hammer swung back over the shoulder.
7. smash forward, gear hammer hitting with a burst of sparks, steam puffs and teal electric arcs.
8. follow-through, hammer low, goggles bouncing.
9. throwing a small round bomb forward with the free hand.
10. kneeling, adjusting a small device on the ground, sparks, steam puffs and teal electric arcs crackling.
11. standing, raising a glowing remote control, sparks, steam puffs and teal electric arcs arcing around.
12. pointing forward, a sparks, steam puffs and teal electric arcs blast leaving the device.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/players/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `artificier` | `artificier.png` |
| 1-2 | repos 2 | `artificier_idle_2` | `artificier_idle_2.png` |
| 1-3 | repos 3 | `artificier_idle_3` | `artificier_idle_3.png` |
| 1-4 | dos | `artificier_back` | `artificier_back.png` |
| 2-1 | marche | `artificier_walk` | `artificier_walk.png` |
| 2-2 | attaque 1 | `artificier_attack` | `artificier_attack.png` |
| 2-3 | attaque 2 | `artificier_attack_2` | `artificier_attack_2.png` |
| 2-4 | attaque 3 | `artificier_attack_3` | `artificier_attack_3.png` |
| 3-1 | attaque 4 | `artificier_attack_4` | `artificier_attack_4.png` |
| 3-2 | sort 1 | `artificier_cast` | `artificier_cast.png` |
| 3-3 | sort 2 | `artificier_cast_2` | `artificier_cast_2.png` |
| 3-4 | sort 3 | `artificier_cast_3` | `artificier_cast_3.png` |

Copie conseillée de la pose de repos vers `prototype/zimut/assets/sprites/nations/heros/artificier.png` et des poses vers `nations/heros/poses/`.

## 3. Ennemis

### Drone aérien — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Drone aérien, enemy of the Rouages nation. Bronze flying drone with claw arms, small propellers and a glowing blue core.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm brass rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. drawing back, body stretched upward.
6. lunging forward, claws of sparks, steam puffs and teal electric arcs reaching out.
7. hovering higher, sparks, steam puffs and teal electric arcs orbs circling the body.
8. releasing a compact sparks, steam puffs and teal electric arcs wave forward.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/rouages/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `drone_aerien` | `drone_aerien.png` |
| 1-2 | repos 2 | `drone_aerien_idle_2` | `drone_aerien_idle_2.png` |
| 1-3 | dos | `drone_aerien_back` | `drone_aerien_back.png` |
| 1-4 | marche | `drone_aerien_walk` | `drone_aerien_walk.png` |
| 2-1 | attaque 1 | `drone_aerien_attack` | `drone_aerien_attack.png` |
| 2-2 | attaque 2 | `drone_aerien_attack_2` | `drone_aerien_attack_2.png` |
| 2-3 | sort 1 | `drone_aerien_cast` | `drone_aerien_cast.png` |
| 2-4 | sort 2 | `drone_aerien_cast_2` | `drone_aerien_cast_2.png` |

### Araignée mécanique — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Araignée mécanique, enemy of the Rouages nation. Bronze mechanical spider with long jointed legs and a blue gem eye.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm brass rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. crouched wind-up, ready to pounce.
6. lunge forward, jaws or claws first, small sparks, steam puffs and teal electric arcs impact.
7. head raised, sparks, steam puffs and teal electric arcs gathering around the body.
8. releasing a short sparks, steam puffs and teal electric arcs breath or wave forward.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/rouages/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `araignee_mecanique` | `araignee_mecanique.png` |
| 1-2 | repos 2 | `araignee_mecanique_idle_2` | `araignee_mecanique_idle_2.png` |
| 1-3 | dos | `araignee_mecanique_back` | `araignee_mecanique_back.png` |
| 1-4 | marche | `araignee_mecanique_walk` | `araignee_mecanique_walk.png` |
| 2-1 | attaque 1 | `araignee_mecanique_attack` | `araignee_mecanique_attack.png` |
| 2-2 | attaque 2 | `araignee_mecanique_attack_2` | `araignee_mecanique_attack_2.png` |
| 2-3 | sort 1 | `araignee_mecanique_cast` | `araignee_mecanique_cast.png` |
| 2-4 | sort 2 | `araignee_mecanique_cast_2` | `araignee_mecanique_cast_2.png` |

### Roue engrenée — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Roue engrenée, enemy of the Rouages nation. Rolling bronze cog-wheel creature with a single glowing blue gem eye in the center.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm brass rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. wind-up, fist or weapon raised high.
6. heavy smash forward, ground cracking with a small sparks, steam puffs and teal electric arcs burst.
7. stomping, sparks, steam puffs and teal electric arcs cracks spreading under the feet.
8. slamming both fists down, sparks, steam puffs and teal electric arcs shockwave.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/rouages/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `roue_engrenee` | `roue_engrenee.png` |
| 1-2 | repos 2 | `roue_engrenee_idle_2` | `roue_engrenee_idle_2.png` |
| 1-3 | dos | `roue_engrenee_back` | `roue_engrenee_back.png` |
| 1-4 | marche | `roue_engrenee_walk` | `roue_engrenee_walk.png` |
| 2-1 | attaque 1 | `roue_engrenee_attack` | `roue_engrenee_attack.png` |
| 2-2 | attaque 2 | `roue_engrenee_attack_2` | `roue_engrenee_attack_2.png` |
| 2-3 | sort 1 | `roue_engrenee_cast` | `roue_engrenee_cast.png` |
| 2-4 | sort 2 | `roue_engrenee_cast_2` | `roue_engrenee_cast_2.png` |

### Automate de combat — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Automate de combat, enemy of the Rouages nation. Heavy combat automaton of riveted bronze and stone plates with big fists.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm brass rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. wind-up, fist or weapon raised high.
6. heavy smash forward, ground cracking with a small sparks, steam puffs and teal electric arcs burst.
7. stomping, sparks, steam puffs and teal electric arcs cracks spreading under the feet.
8. slamming both fists down, sparks, steam puffs and teal electric arcs shockwave.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/rouages/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `automate_de_combat` | `automate_de_combat.png` |
| 1-2 | repos 2 | `automate_de_combat_idle_2` | `automate_de_combat_idle_2.png` |
| 1-3 | dos | `automate_de_combat_back` | `automate_de_combat_back.png` |
| 1-4 | marche | `automate_de_combat_walk` | `automate_de_combat_walk.png` |
| 2-1 | attaque 1 | `automate_de_combat_attack` | `automate_de_combat_attack.png` |
| 2-2 | attaque 2 | `automate_de_combat_attack_2` | `automate_de_combat_attack_2.png` |
| 2-3 | sort 1 | `automate_de_combat_cast` | `automate_de_combat_cast.png` |
| 2-4 | sort 2 | `automate_de_combat_cast_2` | `automate_de_combat_cast_2.png` |

## 4. Boss

### Mécanoptère, Colosse d'Engrenages — 12 poses

Grille 4 × 3.

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Mécanoptère, Colosse d'Engrenages, boss of the Rouages nation. Giant steam colossus of steel and brass with two smoking chimneys on the back, a glowing blue core in the chest and a huge gear hammer, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
NATION PALETTE: brass, copper, dark steel, teal glowing lights.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm brass rim light on the right edge.
GRID: Strict grid of 4 columns x 3 rows, 12 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised, same stance.
3. idle variant, alert, glancing to the side, weapon ready.
4. idle seen from behind, 3/4 back-right view.
5. walking, 3/4 front-right, mid-stride, left foot forward.
6. wind-up, fist or weapon raised high.
7. heavy smash forward, ground cracking with a small sparks, steam puffs and teal electric arcs burst.
8. follow-through, body leaning forward.
9. sweeping backhand blow.
10. stomping, sparks, steam puffs and teal electric arcs cracks spreading under the feet.
11. arms raised, sparks, steam puffs and teal electric arcs gathering between the hands.
12. slamming both fists down, sparks, steam puffs and teal electric arcs shockwave.
EFFECTS: sparks, steam puffs and teal electric arcs, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/boss/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `rouages` | `rouages.png` |
| 1-2 | repos 2 | `rouages_idle_2` | `rouages_idle_2.png` |
| 1-3 | repos 3 | `rouages_idle_3` | `rouages_idle_3.png` |
| 1-4 | dos | `rouages_back` | `rouages_back.png` |
| 2-1 | marche | `rouages_walk` | `rouages_walk.png` |
| 2-2 | attaque 1 | `rouages_attack` | `rouages_attack.png` |
| 2-3 | attaque 2 | `rouages_attack_2` | `rouages_attack_2.png` |
| 2-4 | attaque 3 | `rouages_attack_3` | `rouages_attack_3.png` |
| 3-1 | attaque 4 | `rouages_attack_4` | `rouages_attack_4.png` |
| 3-2 | sort 1 | `rouages_cast` | `rouages_cast.png` |
| 3-3 | sort 2 | `rouages_cast_2` | `rouages_cast_2.png` |
| 3-4 | sort 3 | `rouages_cast_3` | `rouages_cast_3.png` |

## Prompt négatif (toutes les planches de cette page)

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art
```
