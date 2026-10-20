# Nation Cimes (Montagne)

Palette : steel blue, dark iron, snow white fur, ice cyan crystals. Effets : ice shards and snow bursts. Contre-jour : cold icy blue.

Ordre conseillé : 1) planche de référence, 2) héros (en joignant la planche 1 comme image de référence), 3) ennemis, 4) boss. Prompt négatif : voir en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes. Joins-la comme image de référence aux planches suivantes.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Cimes nation (Montagne biome).
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals. Signature effects: ice shards and snow bursts.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
LAYOUT: 6 characters standing side by side in ONE single row, all in idle pose, all in 3/4 view facing front-right, all feet on the same ground line, a wide empty gap between characters (at least half a character width). Nobody overlaps or touches another character.
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

### Tank — 12 poses

Grille 4 × 3.

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Tank, hero of the Cimes nation. Stout veteran warrior with a big white beard and white hair, heavy dark steel-blue plate armor with white fur trim and ice-blue crystal inlays, a large round shield with a cloud and mountain emblem on the left arm, a rune-engraved war hammer in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
GRID: Strict grid of 4 columns x 3 rows, 12 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised, same stance.
3. idle variant, alert, glancing to the side, weapon ready.
4. idle seen from behind, 3/4 back-right view.
5. walking, 3/4 front-right, mid-stride, left foot forward.
6. wind-up, hammer raised high behind the head, shield forward.
7. overhead strike, hammer slamming down in front, small ice shards and snow bursts impact at the hammer head.
8. follow-through, hammer low, body leaning forward.
9. shield bash, shield thrust forward, hammer pulled back.
10. bracing, shield planted on the ground, ice shards and snow bursts gathering around.
11. war cry, hammer raised to the sky, ice shards and snow bursts swirling around the body.
12. releasing a ring of ice shards and snow bursts around the feet.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/players/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `tank` | `tank.png` |
| 1-2 | repos 2 | `tank_idle_2` | `tank_idle_2.png` |
| 1-3 | repos 3 | `tank_idle_3` | `tank_idle_3.png` |
| 1-4 | dos | `tank_back` | `tank_back.png` |
| 2-1 | marche | `tank_walk` | `tank_walk.png` |
| 2-2 | attaque 1 | `tank_attack` | `tank_attack.png` |
| 2-3 | attaque 2 | `tank_attack_2` | `tank_attack_2.png` |
| 2-4 | attaque 3 | `tank_attack_3` | `tank_attack_3.png` |
| 3-1 | attaque 4 | `tank_attack_4` | `tank_attack_4.png` |
| 3-2 | sort 1 | `tank_cast` | `tank_cast.png` |
| 3-3 | sort 2 | `tank_cast_2` | `tank_cast_2.png` |
| 3-4 | sort 3 | `tank_cast_3` | `tank_cast_3.png` |

Copie conseillée de la pose de repos vers `prototype/zimut/assets/sprites/nations/heros/tank.png` et des poses vers `nations/heros/poses/`.

## 3. Ennemis

### Guerrier des monts — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Guerrier des monts, enemy of the Cimes nation. Mountain warrior with rocky brown skin, stocky body, crude stone gauntlets.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. wind-up, fist or weapon raised high.
6. heavy smash forward, ground cracking with a small ice shards and snow bursts burst.
7. stomping, ice shards and snow bursts cracks spreading under the feet.
8. slamming both fists down, ice shards and snow bursts shockwave.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/cimes/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `guerrier_des_monts` | `guerrier_des_monts.png` |
| 1-2 | repos 2 | `guerrier_des_monts_idle_2` | `guerrier_des_monts_idle_2.png` |
| 1-3 | dos | `guerrier_des_monts_back` | `guerrier_des_monts_back.png` |
| 1-4 | marche | `guerrier_des_monts_walk` | `guerrier_des_monts_walk.png` |
| 2-1 | attaque 1 | `guerrier_des_monts_attack` | `guerrier_des_monts_attack.png` |
| 2-2 | attaque 2 | `guerrier_des_monts_attack_2` | `guerrier_des_monts_attack_2.png` |
| 2-3 | sort 1 | `guerrier_des_monts_cast` | `guerrier_des_monts_cast.png` |
| 2-4 | sort 2 | `guerrier_des_monts_cast_2` | `guerrier_des_monts_cast_2.png` |

### Griffon des cimes — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Griffon des cimes, enemy of the Cimes nation. Griffin with a white eagle head, blue-grey feathered wings and a lion body.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. crouched wind-up, ready to pounce.
6. lunge forward, jaws or claws first, small ice shards and snow bursts impact.
7. head raised, ice shards and snow bursts gathering around the body.
8. releasing a short ice shards and snow bursts breath or wave forward.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/cimes/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `griffon_des_cimes` | `griffon_des_cimes.png` |
| 1-2 | repos 2 | `griffon_des_cimes_idle_2` | `griffon_des_cimes_idle_2.png` |
| 1-3 | dos | `griffon_des_cimes_back` | `griffon_des_cimes_back.png` |
| 1-4 | marche | `griffon_des_cimes_walk` | `griffon_des_cimes_walk.png` |
| 2-1 | attaque 1 | `griffon_des_cimes_attack` | `griffon_des_cimes_attack.png` |
| 2-2 | attaque 2 | `griffon_des_cimes_attack_2` | `griffon_des_cimes_attack_2.png` |
| 2-3 | sort 1 | `griffon_des_cimes_cast` | `griffon_des_cimes_cast.png` |
| 2-4 | sort 2 | `griffon_des_cimes_cast_2` | `griffon_des_cimes_cast_2.png` |

### Garde des pics — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Garde des pics, enemy of the Cimes nation. Peak guardian golem of blue-grey stone with glowing ice-blue crystals on the shoulders.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. wind-up, fist or weapon raised high.
6. heavy smash forward, ground cracking with a small ice shards and snow bursts burst.
7. stomping, ice shards and snow bursts cracks spreading under the feet.
8. slamming both fists down, ice shards and snow bursts shockwave.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/cimes/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `garde_des_pics` | `garde_des_pics.png` |
| 1-2 | repos 2 | `garde_des_pics_idle_2` | `garde_des_pics_idle_2.png` |
| 1-3 | dos | `garde_des_pics_back` | `garde_des_pics_back.png` |
| 1-4 | marche | `garde_des_pics_walk` | `garde_des_pics_walk.png` |
| 2-1 | attaque 1 | `garde_des_pics_attack` | `garde_des_pics_attack.png` |
| 2-2 | attaque 2 | `garde_des_pics_attack_2` | `garde_des_pics_attack_2.png` |
| 2-3 | sort 1 | `garde_des_pics_cast` | `garde_des_pics_cast.png` |
| 2-4 | sort 2 | `garde_des_pics_cast_2` | `garde_des_pics_cast_2.png` |

### Rochebrute — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Rochebrute, enemy of the Cimes nation. Hulking brute made of brown boulders, small glowing eyes, huge fists.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. wind-up, fist or weapon raised high.
6. heavy smash forward, ground cracking with a small ice shards and snow bursts burst.
7. stomping, ice shards and snow bursts cracks spreading under the feet.
8. slamming both fists down, ice shards and snow bursts shockwave.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/cimes/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `rochebrute` | `rochebrute.png` |
| 1-2 | repos 2 | `rochebrute_idle_2` | `rochebrute_idle_2.png` |
| 1-3 | dos | `rochebrute_back` | `rochebrute_back.png` |
| 1-4 | marche | `rochebrute_walk` | `rochebrute_walk.png` |
| 2-1 | attaque 1 | `rochebrute_attack` | `rochebrute_attack.png` |
| 2-2 | attaque 2 | `rochebrute_attack_2` | `rochebrute_attack_2.png` |
| 2-3 | sort 1 | `rochebrute_cast` | `rochebrute_cast.png` |
| 2-4 | sort 2 | `rochebrute_cast_2` | `rochebrute_cast_2.png` |

## 4. Boss

### Vorkann le Givre — 12 poses

Grille 4 × 3.

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Vorkann le Givre, boss of the Cimes nation. Massive frost knight in dark steel armor covered with ice crystals and snow fur, crowned helm of ice spikes, huge crystal-studded tower shield and a heavy rune hammer, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
NATION PALETTE: steel blue, dark iron, snow white fur, ice cyan crystals.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle cold icy blue rim light on the right edge.
GRID: Strict grid of 4 columns x 3 rows, 12 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised, same stance.
3. idle variant, alert, glancing to the side, weapon ready.
4. idle seen from behind, 3/4 back-right view.
5. walking, 3/4 front-right, mid-stride, left foot forward.
6. wind-up, hammer raised high behind the head, shield forward.
7. overhead strike, hammer slamming down in front, small ice shards and snow bursts impact at the hammer head.
8. follow-through, hammer low, body leaning forward.
9. shield bash, shield thrust forward, hammer pulled back.
10. bracing, shield planted on the ground, ice shards and snow bursts gathering around.
11. war cry, hammer raised to the sky, ice shards and snow bursts swirling around the body.
12. releasing a ring of ice shards and snow bursts around the feet.
EFFECTS: ice shards and snow bursts, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/boss/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `cimes` | `cimes.png` |
| 1-2 | repos 2 | `cimes_idle_2` | `cimes_idle_2.png` |
| 1-3 | repos 3 | `cimes_idle_3` | `cimes_idle_3.png` |
| 1-4 | dos | `cimes_back` | `cimes_back.png` |
| 2-1 | marche | `cimes_walk` | `cimes_walk.png` |
| 2-2 | attaque 1 | `cimes_attack` | `cimes_attack.png` |
| 2-3 | attaque 2 | `cimes_attack_2` | `cimes_attack_2.png` |
| 2-4 | attaque 3 | `cimes_attack_3` | `cimes_attack_3.png` |
| 3-1 | attaque 4 | `cimes_attack_4` | `cimes_attack_4.png` |
| 3-2 | sort 1 | `cimes_cast` | `cimes_cast.png` |
| 3-3 | sort 2 | `cimes_cast_2` | `cimes_cast_2.png` |
| 3-4 | sort 3 | `cimes_cast_3` | `cimes_cast_3.png` |

## Prompt négatif (toutes les planches de cette page)

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art
```
