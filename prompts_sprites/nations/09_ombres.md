# Nation Ombres (Ombres)

Palette : black, charcoal, violet glow, silver-teal cloth accents. Effets : violet shadow smoke. Contre-jour : violet.

Ordre conseillé : 1) planche de référence, 2) héros (en joignant la planche 1 comme image de référence), 3) ennemis, 4) boss. Prompt négatif : voir en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes. Joins-la comme image de référence aux planches suivantes.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Ombres nation (Ombres biome).
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents. Signature effects: violet shadow smoke.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
LAYOUT: 6 characters standing side by side in ONE single row, all in idle pose, all in 3/4 view facing front-right, all feet on the same ground line, a wide empty gap between characters (at least half a character width). Nobody overlaps or touches another character.
CHARACTERS, left to right:
1. the hero (Assassin: agile assassin with black hair, a black cloth mask covering the lower face (eyes clearly visible), dark charcoal hooded armor with layered tattered silver-teal cloth panels, violet glowing rune details, a curved dagger in each hand).
2. Assassin des ombres (hunched shadow beast-assassin with a spiky purple mane and long claws).
3. Ombre infernale (swirling mass of purple shadow with claws and glowing eyes).
4. Spectre (violet spectral figure wrapped in shadow curls, long claw-like hands).
5. Liche (tall dark purple lich in a spiked robe holding a staff).
6. the final boss Nébulia l'Illusionniste (tall illusionist in black armor with spiky layers of silver-teal tattered cloth, horned mask-helm, long blades, mirror-like violet glints), about 1.5x taller than the others.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Assassin — 12 poses

Grille 4 × 3.

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Assassin, hero of the Ombres nation. Agile assassin with black hair, a black cloth mask covering the lower face (eyes clearly visible), dark charcoal hooded armor with layered tattered silver-teal cloth panels, violet glowing rune details, a curved dagger in each hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 3 rows, 12 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised, same stance.
3. idle variant, alert, glancing to the side, weapon ready.
4. idle seen from behind, 3/4 back-right view.
5. walking, 3/4 front-right, mid-stride, left foot forward.
6. crouched wind-up, both daggers crossed in front of the chest.
7. dash slash forward, both arms extended, short violet shadow smoke slash crescents.
8. spinning follow-through, one dagger high, one low.
9. backhand stab, one dagger thrust forward, body twisted.
10. kneeling, one hand on the ground, violet shadow smoke rising from the shadow below.
11. half vanished into violet shadow smoke, only the eyes and daggers clearly visible.
12. reappearing from a burst of violet shadow smoke, daggers ready.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/players/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `assassin` | `assassin.png` |
| 1-2 | repos 2 | `assassin_idle_2` | `assassin_idle_2.png` |
| 1-3 | repos 3 | `assassin_idle_3` | `assassin_idle_3.png` |
| 1-4 | dos | `assassin_back` | `assassin_back.png` |
| 2-1 | marche | `assassin_walk` | `assassin_walk.png` |
| 2-2 | attaque 1 | `assassin_attack` | `assassin_attack.png` |
| 2-3 | attaque 2 | `assassin_attack_2` | `assassin_attack_2.png` |
| 2-4 | attaque 3 | `assassin_attack_3` | `assassin_attack_3.png` |
| 3-1 | attaque 4 | `assassin_attack_4` | `assassin_attack_4.png` |
| 3-2 | sort 1 | `assassin_cast` | `assassin_cast.png` |
| 3-3 | sort 2 | `assassin_cast_2` | `assassin_cast_2.png` |
| 3-4 | sort 3 | `assassin_cast_3` | `assassin_cast_3.png` |

Copie conseillée de la pose de repos vers `prototype/zimut/assets/sprites/nations/heros/assassin.png` et des poses vers `nations/heros/poses/`.

## 3. Ennemis

### Assassin des ombres — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Assassin des ombres, enemy of the Ombres nation. Hunched shadow beast-assassin with a spiky purple mane and long claws.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. crouched wind-up, ready to pounce.
6. lunge forward, jaws or claws first, small violet shadow smoke impact.
7. head raised, violet shadow smoke gathering around the body.
8. releasing a short violet shadow smoke breath or wave forward.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/ombres/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `assassin_des_ombres` | `assassin_des_ombres.png` |
| 1-2 | repos 2 | `assassin_des_ombres_idle_2` | `assassin_des_ombres_idle_2.png` |
| 1-3 | dos | `assassin_des_ombres_back` | `assassin_des_ombres_back.png` |
| 1-4 | marche | `assassin_des_ombres_walk` | `assassin_des_ombres_walk.png` |
| 2-1 | attaque 1 | `assassin_des_ombres_attack` | `assassin_des_ombres_attack.png` |
| 2-2 | attaque 2 | `assassin_des_ombres_attack_2` | `assassin_des_ombres_attack_2.png` |
| 2-3 | sort 1 | `assassin_des_ombres_cast` | `assassin_des_ombres_cast.png` |
| 2-4 | sort 2 | `assassin_des_ombres_cast_2` | `assassin_des_ombres_cast_2.png` |

### Ombre infernale — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Ombre infernale, enemy of the Ombres nation. Swirling mass of purple shadow with claws and glowing eyes.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. drawing back, body stretched upward.
6. lunging forward, claws of violet shadow smoke reaching out.
7. hovering higher, violet shadow smoke orbs circling the body.
8. releasing a compact violet shadow smoke wave forward.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/ombres/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `ombre_infernale` | `ombre_infernale.png` |
| 1-2 | repos 2 | `ombre_infernale_idle_2` | `ombre_infernale_idle_2.png` |
| 1-3 | dos | `ombre_infernale_back` | `ombre_infernale_back.png` |
| 1-4 | marche | `ombre_infernale_walk` | `ombre_infernale_walk.png` |
| 2-1 | attaque 1 | `ombre_infernale_attack` | `ombre_infernale_attack.png` |
| 2-2 | attaque 2 | `ombre_infernale_attack_2` | `ombre_infernale_attack_2.png` |
| 2-3 | sort 1 | `ombre_infernale_cast` | `ombre_infernale_cast.png` |
| 2-4 | sort 2 | `ombre_infernale_cast_2` | `ombre_infernale_cast_2.png` |

### Spectre — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Spectre, enemy of the Ombres nation. Violet spectral figure wrapped in shadow curls, long claw-like hands.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. drawing back, body stretched upward.
6. lunging forward, claws of violet shadow smoke reaching out.
7. hovering higher, violet shadow smoke orbs circling the body.
8. releasing a compact violet shadow smoke wave forward.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/ombres/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `spectre` | `spectre.png` |
| 1-2 | repos 2 | `spectre_idle_2` | `spectre_idle_2.png` |
| 1-3 | dos | `spectre_back` | `spectre_back.png` |
| 1-4 | marche | `spectre_walk` | `spectre_walk.png` |
| 2-1 | attaque 1 | `spectre_attack` | `spectre_attack.png` |
| 2-2 | attaque 2 | `spectre_attack_2` | `spectre_attack_2.png` |
| 2-3 | sort 1 | `spectre_cast` | `spectre_cast.png` |
| 2-4 | sort 2 | `spectre_cast_2` | `spectre_cast_2.png` |

### Liche — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Liche, enemy of the Ombres nation. Tall dark purple lich in a spiked robe holding a staff.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. wind-up, staff held back with both hands.
6. staff swing forward, small violet shadow smoke burst at the tip.
7. staff raised, violet shadow smoke orb forming at the top.
8. staff pointed forward, releasing a compact violet shadow smoke blast.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/ombres/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `liche` | `liche.png` |
| 1-2 | repos 2 | `liche_idle_2` | `liche_idle_2.png` |
| 1-3 | dos | `liche_back` | `liche_back.png` |
| 1-4 | marche | `liche_walk` | `liche_walk.png` |
| 2-1 | attaque 1 | `liche_attack` | `liche_attack.png` |
| 2-2 | attaque 2 | `liche_attack_2` | `liche_attack_2.png` |
| 2-3 | sort 1 | `liche_cast` | `liche_cast.png` |
| 2-4 | sort 2 | `liche_cast_2` | `liche_cast_2.png` |

## 4. Boss

### Nébulia l'Illusionniste — 12 poses

Grille 4 × 3.

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Nébulia l'Illusionniste, boss of the Ombres nation. Tall illusionist in black armor with spiky layers of silver-teal tattered cloth, horned mask-helm, long blades, mirror-like violet glints, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
NATION PALETTE: black, charcoal, violet glow, silver-teal cloth accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle violet rim light on the right edge.
GRID: Strict grid of 4 columns x 3 rows, 12 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised, same stance.
3. idle variant, alert, glancing to the side, weapon ready.
4. idle seen from behind, 3/4 back-right view.
5. walking, 3/4 front-right, mid-stride, left foot forward.
6. crouched wind-up, both daggers crossed in front of the chest.
7. dash slash forward, both arms extended, short violet shadow smoke slash crescents.
8. spinning follow-through, one dagger high, one low.
9. backhand stab, one dagger thrust forward, body twisted.
10. kneeling, one hand on the ground, violet shadow smoke rising from the shadow below.
11. half vanished into violet shadow smoke, only the eyes and daggers clearly visible.
12. reappearing from a burst of violet shadow smoke, daggers ready.
EFFECTS: violet shadow smoke, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/boss/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `ombres` | `ombres.png` |
| 1-2 | repos 2 | `ombres_idle_2` | `ombres_idle_2.png` |
| 1-3 | repos 3 | `ombres_idle_3` | `ombres_idle_3.png` |
| 1-4 | dos | `ombres_back` | `ombres_back.png` |
| 2-1 | marche | `ombres_walk` | `ombres_walk.png` |
| 2-2 | attaque 1 | `ombres_attack` | `ombres_attack.png` |
| 2-3 | attaque 2 | `ombres_attack_2` | `ombres_attack_2.png` |
| 2-4 | attaque 3 | `ombres_attack_3` | `ombres_attack_3.png` |
| 3-1 | attaque 4 | `ombres_attack_4` | `ombres_attack_4.png` |
| 3-2 | sort 1 | `ombres_cast` | `ombres_cast.png` |
| 3-3 | sort 2 | `ombres_cast_2` | `ombres_cast_2.png` |
| 3-4 | sort 3 | `ombres_cast_3` | `ombres_cast_3.png` |

## Prompt négatif (toutes les planches de cette page)

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art
```
