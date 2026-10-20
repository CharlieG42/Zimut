# Nation Marées (Marées)

Palette : turquoise, white, gold trims, coral pink accents. Effets : water splashes and bubbles. Contre-jour : aqua.

Ordre conseillé : 1) planche de référence, 2) héros (en joignant la planche 1 comme image de référence), 3) ennemis, 4) boss. Prompt négatif : voir en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes. Joins-la comme image de référence aux planches suivantes.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Marées nation (Marées biome).
NATION PALETTE: turquoise, white, gold trims, coral pink accents. Signature effects: water splashes and bubbles.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
LAYOUT: 6 characters standing side by side in ONE single row, all in idle pose, all in 3/4 view facing front-right, all feet on the same ground line, a wide empty gap between characters (at least half a character width). Nobody overlaps or touches another character.
CHARACTERS, left to right:
1. the hero (Heal (Soigneur): gentle healer with teal hair, ornate white and turquoise robe with gold embroidery and wave patterns, a golden staff topped with a glowing water-drop crystal in the right hand).
2. Pirate des mers (sea pirate with a red bandana, blue coat, leather belts and a short cutlass).
3. Requin (blue shark with a white belly swimming upright in the air, toothy grin).
4. Néréide (water nymph made of translucent-looking turquoise water, flowing hair of waves).
5. Crabe géant (giant crab with a blue shell striped with red, huge pincers).
6. the final boss Néréa la Tempête (sea queen in turquoise coral armor with gold edges, crown of red coral branches, flowing sea-foam cape, holding a golden trident), about 1.5x taller than the others.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Heal (Soigneur) — 12 poses

Grille 4 × 3.

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Heal (Soigneur), hero of the Marées nation. Gentle healer with teal hair, ornate white and turquoise robe with gold embroidery and wave patterns, a golden staff topped with a glowing water-drop crystal in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
GRID: Strict grid of 4 columns x 3 rows, 12 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised, same stance.
3. idle variant, alert, glancing to the side, weapon ready.
4. idle seen from behind, 3/4 back-right view.
5. walking, 3/4 front-right, mid-stride, left foot forward.
6. wind-up, staff held back with both hands.
7. staff swing forward, small water splashes and bubbles burst at the tip.
8. follow-through, staff low, body turned.
9. thrust with the staff tip forward, short water splashes and bubbles spark.
10. staff raised, water splashes and bubbles orb forming at the top.
11. staff held high with both hands, water splashes and bubbles swirling around.
12. staff pointed forward, releasing a compact water splashes and bubbles blast.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/players/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `heal` | `heal.png` |
| 1-2 | repos 2 | `heal_idle_2` | `heal_idle_2.png` |
| 1-3 | repos 3 | `heal_idle_3` | `heal_idle_3.png` |
| 1-4 | dos | `heal_back` | `heal_back.png` |
| 2-1 | marche | `heal_walk` | `heal_walk.png` |
| 2-2 | attaque 1 | `heal_attack` | `heal_attack.png` |
| 2-3 | attaque 2 | `heal_attack_2` | `heal_attack_2.png` |
| 2-4 | attaque 3 | `heal_attack_3` | `heal_attack_3.png` |
| 3-1 | attaque 4 | `heal_attack_4` | `heal_attack_4.png` |
| 3-2 | sort 1 | `heal_cast` | `heal_cast.png` |
| 3-3 | sort 2 | `heal_cast_2` | `heal_cast_2.png` |
| 3-4 | sort 3 | `heal_cast_3` | `heal_cast_3.png` |

Copie conseillée de la pose de repos vers `prototype/zimut/assets/sprites/nations/heros/heal.png` et des poses vers `nations/heros/poses/`.

## 3. Ennemis

### Pirate des mers — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Pirate des mers, enemy of the Marées nation. Sea pirate with a red bandana, blue coat, leather belts and a short cutlass.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. crouched wind-up, both daggers crossed in front of the chest.
6. dash slash forward, both arms extended, short water splashes and bubbles slash crescents.
7. kneeling, one hand on the ground, water splashes and bubbles rising from the shadow below.
8. reappearing from a burst of water splashes and bubbles, daggers ready.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/marees/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `pirate_des_mers` | `pirate_des_mers.png` |
| 1-2 | repos 2 | `pirate_des_mers_idle_2` | `pirate_des_mers_idle_2.png` |
| 1-3 | dos | `pirate_des_mers_back` | `pirate_des_mers_back.png` |
| 1-4 | marche | `pirate_des_mers_walk` | `pirate_des_mers_walk.png` |
| 2-1 | attaque 1 | `pirate_des_mers_attack` | `pirate_des_mers_attack.png` |
| 2-2 | attaque 2 | `pirate_des_mers_attack_2` | `pirate_des_mers_attack_2.png` |
| 2-3 | sort 1 | `pirate_des_mers_cast` | `pirate_des_mers_cast.png` |
| 2-4 | sort 2 | `pirate_des_mers_cast_2` | `pirate_des_mers_cast_2.png` |

### Requin — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Requin, enemy of the Marées nation. Blue shark with a white belly swimming upright in the air, toothy grin.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. crouched wind-up, ready to pounce.
6. lunge forward, jaws or claws first, small water splashes and bubbles impact.
7. head raised, water splashes and bubbles gathering around the body.
8. releasing a short water splashes and bubbles breath or wave forward.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/marees/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `requin` | `requin.png` |
| 1-2 | repos 2 | `requin_idle_2` | `requin_idle_2.png` |
| 1-3 | dos | `requin_back` | `requin_back.png` |
| 1-4 | marche | `requin_walk` | `requin_walk.png` |
| 2-1 | attaque 1 | `requin_attack` | `requin_attack.png` |
| 2-2 | attaque 2 | `requin_attack_2` | `requin_attack_2.png` |
| 2-3 | sort 1 | `requin_cast` | `requin_cast.png` |
| 2-4 | sort 2 | `requin_cast_2` | `requin_cast_2.png` |

### Néréide — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Néréide, enemy of the Marées nation. Water nymph made of translucent-looking turquoise water, flowing hair of waves.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. drawing back, body stretched upward.
6. lunging forward, claws of water splashes and bubbles reaching out.
7. hovering higher, water splashes and bubbles orbs circling the body.
8. releasing a compact water splashes and bubbles wave forward.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/marees/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `nereide` | `nereide.png` |
| 1-2 | repos 2 | `nereide_idle_2` | `nereide_idle_2.png` |
| 1-3 | dos | `nereide_back` | `nereide_back.png` |
| 1-4 | marche | `nereide_walk` | `nereide_walk.png` |
| 2-1 | attaque 1 | `nereide_attack` | `nereide_attack.png` |
| 2-2 | attaque 2 | `nereide_attack_2` | `nereide_attack_2.png` |
| 2-3 | sort 1 | `nereide_cast` | `nereide_cast.png` |
| 2-4 | sort 2 | `nereide_cast_2` | `nereide_cast_2.png` |

### Crabe géant — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Crabe géant, enemy of the Marées nation. Giant crab with a blue shell striped with red, huge pincers.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. crouched wind-up, ready to pounce.
6. lunge forward, jaws or claws first, small water splashes and bubbles impact.
7. head raised, water splashes and bubbles gathering around the body.
8. releasing a short water splashes and bubbles breath or wave forward.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/marees/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `crabe_geant` | `crabe_geant.png` |
| 1-2 | repos 2 | `crabe_geant_idle_2` | `crabe_geant_idle_2.png` |
| 1-3 | dos | `crabe_geant_back` | `crabe_geant_back.png` |
| 1-4 | marche | `crabe_geant_walk` | `crabe_geant_walk.png` |
| 2-1 | attaque 1 | `crabe_geant_attack` | `crabe_geant_attack.png` |
| 2-2 | attaque 2 | `crabe_geant_attack_2` | `crabe_geant_attack_2.png` |
| 2-3 | sort 1 | `crabe_geant_cast` | `crabe_geant_cast.png` |
| 2-4 | sort 2 | `crabe_geant_cast_2` | `crabe_geant_cast_2.png` |

## 4. Boss

### Néréa la Tempête — 12 poses

Grille 4 × 3.

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Néréa la Tempête, boss of the Marées nation. Sea queen in turquoise coral armor with gold edges, crown of red coral branches, flowing sea-foam cape, holding a golden trident, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
NATION PALETTE: turquoise, white, gold trims, coral pink accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle aqua rim light on the right edge.
GRID: Strict grid of 4 columns x 3 rows, 12 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised, same stance.
3. idle variant, alert, glancing to the side, weapon ready.
4. idle seen from behind, 3/4 back-right view.
5. walking, 3/4 front-right, mid-stride, left foot forward.
6. wind-up, staff held back with both hands.
7. staff swing forward, small water splashes and bubbles burst at the tip.
8. follow-through, staff low, body turned.
9. thrust with the staff tip forward, short water splashes and bubbles spark.
10. staff raised, water splashes and bubbles orb forming at the top.
11. staff held high with both hands, water splashes and bubbles swirling around.
12. staff pointed forward, releasing a compact water splashes and bubbles blast.
EFFECTS: water splashes and bubbles, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/boss/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `marees` | `marees.png` |
| 1-2 | repos 2 | `marees_idle_2` | `marees_idle_2.png` |
| 1-3 | repos 3 | `marees_idle_3` | `marees_idle_3.png` |
| 1-4 | dos | `marees_back` | `marees_back.png` |
| 2-1 | marche | `marees_walk` | `marees_walk.png` |
| 2-2 | attaque 1 | `marees_attack` | `marees_attack.png` |
| 2-3 | attaque 2 | `marees_attack_2` | `marees_attack_2.png` |
| 2-4 | attaque 3 | `marees_attack_3` | `marees_attack_3.png` |
| 3-1 | attaque 4 | `marees_attack_4` | `marees_attack_4.png` |
| 3-2 | sort 1 | `marees_cast` | `marees_cast.png` |
| 3-3 | sort 2 | `marees_cast_2` | `marees_cast_2.png` |
| 3-4 | sort 3 | `marees_cast_3` | `marees_cast_3.png` |

## Prompt négatif (toutes les planches de cette page)

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art
```
