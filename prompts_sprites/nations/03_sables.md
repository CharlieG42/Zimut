# Nation Sables (Désert)

Palette : sand gold, terracotta, amber, small turquoise accents. Effets : swirling sand and amber shards. Contre-jour : warm golden.

Ordre conseillé : 1) planche de référence, 2) héros (en joignant la planche 1 comme image de référence), 3) ennemis, 4) boss. Prompt négatif : voir en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes. Joins-la comme image de référence aux planches suivantes.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Sables nation (Désert biome).
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents. Signature effects: swirling sand and amber shards.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
LAYOUT: 6 characters standing side by side in ONE single row, all in idle pose, all in 3/4 view facing front-right, all feet on the same ground line, a wide empty gap between characters (at least half a character width). Nobody overlaps or touches another character.
CHARACTERS, left to right:
1. the hero (Géomancien: young geomancer with short brown hair, layered sand-gold robe with terracotta panels and amber gems, sandals and wraps, a golden staff topped with a large faceted amber crystal in the right hand).
2. Bandit des dunes (small desert jackal-folk bandit with orange fur, a sand-colored scarf and a curved dagger).
3. Scarabée géant (giant scarab beetle with a black and gold shell and golden horns).
4. Génie du désert (golden sand djinn with muscular arms and a lower body of swirling sand).
5. Sphinx (golden lion sphinx wearing a striped pharaoh headdress).
6. the final boss Zahor le Sableux (sand sovereign in ornate golden armor with sharp layered plates, crested golden helm, holding a tall golden staff with a giant amber crystal), about 1.5x taller than the others.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

## 2. Héros

### Géomancien — 12 poses

Grille 4 × 3.

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Géomancien, hero of the Sables nation. Young geomancer with short brown hair, layered sand-gold robe with terracotta panels and amber gems, sandals and wraps, a golden staff topped with a large faceted amber crystal in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
GRID: Strict grid of 4 columns x 3 rows, 12 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised, same stance.
3. idle variant, alert, glancing to the side, weapon ready.
4. idle seen from behind, 3/4 back-right view.
5. walking, 3/4 front-right, mid-stride, left foot forward.
6. wind-up, staff held back with both hands.
7. staff swing forward, small swirling sand and amber shards burst at the tip.
8. follow-through, staff low, body turned.
9. thrust with the staff tip forward, short swirling sand and amber shards spark.
10. staff raised, swirling sand and amber shards orb forming at the top.
11. staff held high with both hands, swirling sand and amber shards swirling around.
12. staff pointed forward, releasing a compact swirling sand and amber shards blast.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/players/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `geomancien` | `geomancien.png` |
| 1-2 | repos 2 | `geomancien_idle_2` | `geomancien_idle_2.png` |
| 1-3 | repos 3 | `geomancien_idle_3` | `geomancien_idle_3.png` |
| 1-4 | dos | `geomancien_back` | `geomancien_back.png` |
| 2-1 | marche | `geomancien_walk` | `geomancien_walk.png` |
| 2-2 | attaque 1 | `geomancien_attack` | `geomancien_attack.png` |
| 2-3 | attaque 2 | `geomancien_attack_2` | `geomancien_attack_2.png` |
| 2-4 | attaque 3 | `geomancien_attack_3` | `geomancien_attack_3.png` |
| 3-1 | attaque 4 | `geomancien_attack_4` | `geomancien_attack_4.png` |
| 3-2 | sort 1 | `geomancien_cast` | `geomancien_cast.png` |
| 3-3 | sort 2 | `geomancien_cast_2` | `geomancien_cast_2.png` |
| 3-4 | sort 3 | `geomancien_cast_3` | `geomancien_cast_3.png` |

Copie conseillée de la pose de repos vers `prototype/zimut/assets/sprites/nations/heros/geomancien.png` et des poses vers `nations/heros/poses/`.

## 3. Ennemis

### Bandit des dunes — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Bandit des dunes, enemy of the Sables nation. Small desert jackal-folk bandit with orange fur, a sand-colored scarf and a curved dagger.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. crouched wind-up, both daggers crossed in front of the chest.
6. dash slash forward, both arms extended, short swirling sand and amber shards slash crescents.
7. kneeling, one hand on the ground, swirling sand and amber shards rising from the shadow below.
8. reappearing from a burst of swirling sand and amber shards, daggers ready.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/sables/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `bandit_des_dunes` | `bandit_des_dunes.png` |
| 1-2 | repos 2 | `bandit_des_dunes_idle_2` | `bandit_des_dunes_idle_2.png` |
| 1-3 | dos | `bandit_des_dunes_back` | `bandit_des_dunes_back.png` |
| 1-4 | marche | `bandit_des_dunes_walk` | `bandit_des_dunes_walk.png` |
| 2-1 | attaque 1 | `bandit_des_dunes_attack` | `bandit_des_dunes_attack.png` |
| 2-2 | attaque 2 | `bandit_des_dunes_attack_2` | `bandit_des_dunes_attack_2.png` |
| 2-3 | sort 1 | `bandit_des_dunes_cast` | `bandit_des_dunes_cast.png` |
| 2-4 | sort 2 | `bandit_des_dunes_cast_2` | `bandit_des_dunes_cast_2.png` |

### Scarabée géant — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Scarabée géant, enemy of the Sables nation. Giant scarab beetle with a black and gold shell and golden horns.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. crouched wind-up, ready to pounce.
6. lunge forward, jaws or claws first, small swirling sand and amber shards impact.
7. head raised, swirling sand and amber shards gathering around the body.
8. releasing a short swirling sand and amber shards breath or wave forward.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/sables/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `scarabee_geant` | `scarabee_geant.png` |
| 1-2 | repos 2 | `scarabee_geant_idle_2` | `scarabee_geant_idle_2.png` |
| 1-3 | dos | `scarabee_geant_back` | `scarabee_geant_back.png` |
| 1-4 | marche | `scarabee_geant_walk` | `scarabee_geant_walk.png` |
| 2-1 | attaque 1 | `scarabee_geant_attack` | `scarabee_geant_attack.png` |
| 2-2 | attaque 2 | `scarabee_geant_attack_2` | `scarabee_geant_attack_2.png` |
| 2-3 | sort 1 | `scarabee_geant_cast` | `scarabee_geant_cast.png` |
| 2-4 | sort 2 | `scarabee_geant_cast_2` | `scarabee_geant_cast_2.png` |

### Génie du désert — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Génie du désert, enemy of the Sables nation. Golden sand djinn with muscular arms and a lower body of swirling sand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. drawing back, body stretched upward.
6. lunging forward, claws of swirling sand and amber shards reaching out.
7. hovering higher, swirling sand and amber shards orbs circling the body.
8. releasing a compact swirling sand and amber shards wave forward.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/sables/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `genie_du_desert` | `genie_du_desert.png` |
| 1-2 | repos 2 | `genie_du_desert_idle_2` | `genie_du_desert_idle_2.png` |
| 1-3 | dos | `genie_du_desert_back` | `genie_du_desert_back.png` |
| 1-4 | marche | `genie_du_desert_walk` | `genie_du_desert_walk.png` |
| 2-1 | attaque 1 | `genie_du_desert_attack` | `genie_du_desert_attack.png` |
| 2-2 | attaque 2 | `genie_du_desert_attack_2` | `genie_du_desert_attack_2.png` |
| 2-3 | sort 1 | `genie_du_desert_cast` | `genie_du_desert_cast.png` |
| 2-4 | sort 2 | `genie_du_desert_cast_2` | `genie_du_desert_cast_2.png` |

### Sphinx — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Sphinx, enemy of the Sables nation. Golden lion sphinx wearing a striped pharaoh headdress.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. crouched wind-up, ready to pounce.
6. lunge forward, jaws or claws first, small swirling sand and amber shards impact.
7. head raised, swirling sand and amber shards gathering around the body.
8. releasing a short swirling sand and amber shards breath or wave forward.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/sables/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `sphinx` | `sphinx.png` |
| 1-2 | repos 2 | `sphinx_idle_2` | `sphinx_idle_2.png` |
| 1-3 | dos | `sphinx_back` | `sphinx_back.png` |
| 1-4 | marche | `sphinx_walk` | `sphinx_walk.png` |
| 2-1 | attaque 1 | `sphinx_attack` | `sphinx_attack.png` |
| 2-2 | attaque 2 | `sphinx_attack_2` | `sphinx_attack_2.png` |
| 2-3 | sort 1 | `sphinx_cast` | `sphinx_cast.png` |
| 2-4 | sort 2 | `sphinx_cast_2` | `sphinx_cast_2.png` |

## 4. Boss

### Zahor le Sableux — 12 poses

Grille 4 × 3.

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Zahor le Sableux, boss of the Sables nation. Sand sovereign in ornate golden armor with sharp layered plates, crested golden helm, holding a tall golden staff with a giant amber crystal, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
NATION PALETTE: sand gold, terracotta, amber, small turquoise accents.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle warm golden rim light on the right edge.
GRID: Strict grid of 4 columns x 3 rows, 12 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised, same stance.
3. idle variant, alert, glancing to the side, weapon ready.
4. idle seen from behind, 3/4 back-right view.
5. walking, 3/4 front-right, mid-stride, left foot forward.
6. wind-up, staff held back with both hands.
7. staff swing forward, small swirling sand and amber shards burst at the tip.
8. follow-through, staff low, body turned.
9. thrust with the staff tip forward, short swirling sand and amber shards spark.
10. staff raised, swirling sand and amber shards orb forming at the top.
11. staff held high with both hands, swirling sand and amber shards swirling around.
12. staff pointed forward, releasing a compact swirling sand and amber shards blast.
EFFECTS: swirling sand and amber shards, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/boss/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `sables` | `sables.png` |
| 1-2 | repos 2 | `sables_idle_2` | `sables_idle_2.png` |
| 1-3 | repos 3 | `sables_idle_3` | `sables_idle_3.png` |
| 1-4 | dos | `sables_back` | `sables_back.png` |
| 2-1 | marche | `sables_walk` | `sables_walk.png` |
| 2-2 | attaque 1 | `sables_attack` | `sables_attack.png` |
| 2-3 | attaque 2 | `sables_attack_2` | `sables_attack_2.png` |
| 2-4 | attaque 3 | `sables_attack_3` | `sables_attack_3.png` |
| 3-1 | attaque 4 | `sables_attack_4` | `sables_attack_4.png` |
| 3-2 | sort 1 | `sables_cast` | `sables_cast.png` |
| 3-3 | sort 2 | `sables_cast_2` | `sables_cast_2.png` |
| 3-4 | sort 3 | `sables_cast_3` | `sables_cast_3.png` |

## Prompt négatif (toutes les planches de cette page)

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art
```
