# Nation Brumes (Brumes)

Palette : black, deep violet, mist mint green, silver. Effets : mint mist and violet spectral wisps. Contre-jour : pale mint.

Ordre conseillé : 1) planche de référence, 2) héros (en joignant la planche 1 comme image de référence), 3) ennemis, 4) boss. Prompt négatif : voir en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes. Joins-la comme image de référence aux planches suivantes.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Brumes nation (Brumes biome).
NATION PALETTE: black, deep violet, mist mint green, silver. Signature effects: mint mist and violet spectral wisps.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
LAYOUT: 6 characters standing side by side in ONE single row, all in idle pose, all in 3/4 view facing front-right, all feet on the same ground line, a wide empty gap between characters (at least half a character width). Nobody overlaps or touches another character.
CHARACTERS, left to right:
1. the hero (Invocateur: summoner with black hair, long black coat with violet trims and silver clasps, a spiked dark staff topped with a violet crystal in the right hand, a grimoire floating at his side).
2. Brumeux (hulking lavender mist beast with a fluffy cloud body and small glowing eyes).
3. Gargouille (grey stone gargoyle with bat wings and a long tail).
4. Liche des brumes (thin violet lich in tattered robes holding a crooked staff).
5. Fantôme (pale blue ghost with a wavy tail and a mischievous face).
6. the final boss Ombrelis le Brumeux (dark necromancer in black spiked armor with a violet tattered cloak, spiked crown, holding a skull-topped staff surrounded by mist), about 1.5x taller than the others.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Invocateur — 12 poses

Grille 4 × 3.

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Invocateur, hero of the Brumes nation. Summoner with black hair, long black coat with violet trims and silver clasps, a spiked dark staff topped with a violet crystal in the right hand, a grimoire floating at his side.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
GRID: Strict grid of 4 columns x 3 rows, 12 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised, same stance.
3. idle variant, alert, glancing to the side, weapon ready.
4. idle seen from behind, 3/4 back-right view.
5. walking, 3/4 front-right, mid-stride, left foot forward.
6. wind-up, staff held back, grimoire floating open beside.
7. staff swing forward, small mint mist and violet spectral wisps burst at the tip.
8. follow-through, staff low, coat swirling.
9. open palm thrust, mint mist and violet spectral wisps bolt leaving the hand.
10. grimoire floating open, pages turning, mint mist and violet spectral wisps rising from it.
11. staff raised, a mint mist and violet spectral wisps summoning circle drawn on the ground.
12. both arms open, a mint mist and violet spectral wisps creature silhouette emerging from the circle.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/players/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `invocateur` | `invocateur.png` |
| 1-2 | repos 2 | `invocateur_idle_2` | `invocateur_idle_2.png` |
| 1-3 | repos 3 | `invocateur_idle_3` | `invocateur_idle_3.png` |
| 1-4 | dos | `invocateur_back` | `invocateur_back.png` |
| 2-1 | marche | `invocateur_walk` | `invocateur_walk.png` |
| 2-2 | attaque 1 | `invocateur_attack` | `invocateur_attack.png` |
| 2-3 | attaque 2 | `invocateur_attack_2` | `invocateur_attack_2.png` |
| 2-4 | attaque 3 | `invocateur_attack_3` | `invocateur_attack_3.png` |
| 3-1 | attaque 4 | `invocateur_attack_4` | `invocateur_attack_4.png` |
| 3-2 | sort 1 | `invocateur_cast` | `invocateur_cast.png` |
| 3-3 | sort 2 | `invocateur_cast_2` | `invocateur_cast_2.png` |
| 3-4 | sort 3 | `invocateur_cast_3` | `invocateur_cast_3.png` |

Copie conseillée de la pose de repos vers `prototype/zimut/assets/sprites/nations/heros/invocateur.png` et des poses vers `nations/heros/poses/`.

## 3. Ennemis

### Brumeux — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Brumeux, enemy of the Brumes nation. Hulking lavender mist beast with a fluffy cloud body and small glowing eyes.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. drawing back, body stretched upward.
6. lunging forward, claws of mint mist and violet spectral wisps reaching out.
7. hovering higher, mint mist and violet spectral wisps orbs circling the body.
8. releasing a compact mint mist and violet spectral wisps wave forward.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/brumes/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `brumeux` | `brumeux.png` |
| 1-2 | repos 2 | `brumeux_idle_2` | `brumeux_idle_2.png` |
| 1-3 | dos | `brumeux_back` | `brumeux_back.png` |
| 1-4 | marche | `brumeux_walk` | `brumeux_walk.png` |
| 2-1 | attaque 1 | `brumeux_attack` | `brumeux_attack.png` |
| 2-2 | attaque 2 | `brumeux_attack_2` | `brumeux_attack_2.png` |
| 2-3 | sort 1 | `brumeux_cast` | `brumeux_cast.png` |
| 2-4 | sort 2 | `brumeux_cast_2` | `brumeux_cast_2.png` |

### Gargouille — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Gargouille, enemy of the Brumes nation. Grey stone gargoyle with bat wings and a long tail.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. crouched wind-up, ready to pounce.
6. lunge forward, jaws or claws first, small mint mist and violet spectral wisps impact.
7. head raised, mint mist and violet spectral wisps gathering around the body.
8. releasing a short mint mist and violet spectral wisps breath or wave forward.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/brumes/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `gargouille` | `gargouille.png` |
| 1-2 | repos 2 | `gargouille_idle_2` | `gargouille_idle_2.png` |
| 1-3 | dos | `gargouille_back` | `gargouille_back.png` |
| 1-4 | marche | `gargouille_walk` | `gargouille_walk.png` |
| 2-1 | attaque 1 | `gargouille_attack` | `gargouille_attack.png` |
| 2-2 | attaque 2 | `gargouille_attack_2` | `gargouille_attack_2.png` |
| 2-3 | sort 1 | `gargouille_cast` | `gargouille_cast.png` |
| 2-4 | sort 2 | `gargouille_cast_2` | `gargouille_cast_2.png` |

### Liche des brumes — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Liche des brumes, enemy of the Brumes nation. Thin violet lich in tattered robes holding a crooked staff.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. wind-up, staff held back with both hands.
6. staff swing forward, small mint mist and violet spectral wisps burst at the tip.
7. staff raised, mint mist and violet spectral wisps orb forming at the top.
8. staff pointed forward, releasing a compact mint mist and violet spectral wisps blast.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/brumes/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `liche_des_brumes` | `liche_des_brumes.png` |
| 1-2 | repos 2 | `liche_des_brumes_idle_2` | `liche_des_brumes_idle_2.png` |
| 1-3 | dos | `liche_des_brumes_back` | `liche_des_brumes_back.png` |
| 1-4 | marche | `liche_des_brumes_walk` | `liche_des_brumes_walk.png` |
| 2-1 | attaque 1 | `liche_des_brumes_attack` | `liche_des_brumes_attack.png` |
| 2-2 | attaque 2 | `liche_des_brumes_attack_2` | `liche_des_brumes_attack_2.png` |
| 2-3 | sort 1 | `liche_des_brumes_cast` | `liche_des_brumes_cast.png` |
| 2-4 | sort 2 | `liche_des_brumes_cast_2` | `liche_des_brumes_cast_2.png` |

### Fantôme — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Fantôme, enemy of the Brumes nation. Pale blue ghost with a wavy tail and a mischievous face.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. drawing back, body stretched upward.
6. lunging forward, claws of mint mist and violet spectral wisps reaching out.
7. hovering higher, mint mist and violet spectral wisps orbs circling the body.
8. releasing a compact mint mist and violet spectral wisps wave forward.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/brumes/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `fantome` | `fantome.png` |
| 1-2 | repos 2 | `fantome_idle_2` | `fantome_idle_2.png` |
| 1-3 | dos | `fantome_back` | `fantome_back.png` |
| 1-4 | marche | `fantome_walk` | `fantome_walk.png` |
| 2-1 | attaque 1 | `fantome_attack` | `fantome_attack.png` |
| 2-2 | attaque 2 | `fantome_attack_2` | `fantome_attack_2.png` |
| 2-3 | sort 1 | `fantome_cast` | `fantome_cast.png` |
| 2-4 | sort 2 | `fantome_cast_2` | `fantome_cast_2.png` |

## 4. Boss

### Ombrelis le Brumeux — 12 poses

Grille 4 × 3.

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Ombrelis le Brumeux, boss of the Brumes nation. Dark necromancer in black spiked armor with a violet tattered cloak, spiked crown, holding a skull-topped staff surrounded by mist, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
NATION PALETTE: black, deep violet, mist mint green, silver.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale mint rim light on the right edge.
GRID: Strict grid of 4 columns x 3 rows, 12 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised, same stance.
3. idle variant, alert, glancing to the side, weapon ready.
4. idle seen from behind, 3/4 back-right view.
5. walking, 3/4 front-right, mid-stride, left foot forward.
6. wind-up, staff held back, grimoire floating open beside.
7. staff swing forward, small mint mist and violet spectral wisps burst at the tip.
8. follow-through, staff low, coat swirling.
9. open palm thrust, mint mist and violet spectral wisps bolt leaving the hand.
10. grimoire floating open, pages turning, mint mist and violet spectral wisps rising from it.
11. staff raised, a mint mist and violet spectral wisps summoning circle drawn on the ground.
12. both arms open, a mint mist and violet spectral wisps creature silhouette emerging from the circle.
EFFECTS: mint mist and violet spectral wisps, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/boss/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `brumes` | `brumes.png` |
| 1-2 | repos 2 | `brumes_idle_2` | `brumes_idle_2.png` |
| 1-3 | repos 3 | `brumes_idle_3` | `brumes_idle_3.png` |
| 1-4 | dos | `brumes_back` | `brumes_back.png` |
| 2-1 | marche | `brumes_walk` | `brumes_walk.png` |
| 2-2 | attaque 1 | `brumes_attack` | `brumes_attack.png` |
| 2-3 | attaque 2 | `brumes_attack_2` | `brumes_attack_2.png` |
| 2-4 | attaque 3 | `brumes_attack_3` | `brumes_attack_3.png` |
| 3-1 | attaque 4 | `brumes_attack_4` | `brumes_attack_4.png` |
| 3-2 | sort 1 | `brumes_cast` | `brumes_cast.png` |
| 3-3 | sort 2 | `brumes_cast_2` | `brumes_cast_2.png` |
| 3-4 | sort 3 | `brumes_cast_3` | `brumes_cast_3.png` |

## Prompt négatif (toutes les planches de cette page)

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art
```
