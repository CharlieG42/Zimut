# Nation Vents (Vents)

Palette : pale teal, silver, sky white, mint. Effets : wind ribbons and feathers. Contre-jour : pale sky white.

Ordre conseillé : 1) planche de référence, 2) héros (en joignant la planche 1 comme image de référence), 3) ennemis, 4) boss. Prompt négatif : voir en bas de page.

## 1. Planche de référence (style de la nation)

Ne sert pas en jeu : elle fixe palette, matières et silhouettes. Joins-la comme image de référence aux planches suivantes.

```text
Character lineup reference sheet for a chibi isometric tactical RPG: the Vents nation (Vents biome).
NATION PALETTE: pale teal, silver, sky white, mint. Signature effects: wind ribbons and feathers.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
LAYOUT: 6 characters standing side by side in ONE single row, all in idle pose, all in 3/4 view facing front-right, all feet on the same ground line, a wide empty gap between characters (at least half a character width). Nobody overlaps or touches another character.
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

### Sylvain — 12 poses

Grille 4 × 3.

```text
Sprite sheet of ONE playable hero for a chibi isometric tactical RPG.
CHARACTER: Sylvain, hero of the Vents nation. Nature-wind guardian with silver-teal hair, robe of pale teal layered leaves and feathers, silver bracers, a staff topped with a wing-shaped mint crystal in the right hand.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
GRID: Strict grid of 4 columns x 3 rows, 12 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised, same stance.
3. idle variant, alert, glancing to the side, weapon ready.
4. idle seen from behind, 3/4 back-right view.
5. walking, 3/4 front-right, mid-stride, left foot forward.
6. wind-up, staff held back with both hands.
7. staff swing forward, small wind ribbons and feathers burst at the tip.
8. follow-through, staff low, body turned.
9. thrust with the staff tip forward, short wind ribbons and feathers spark.
10. staff raised, wind ribbons and feathers orb forming at the top.
11. staff held high with both hands, wind ribbons and feathers swirling around.
12. staff pointed forward, releasing a compact wind ribbons and feathers blast.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/players/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `sylvain` | `sylvain.png` |
| 1-2 | repos 2 | `sylvain_idle_2` | `sylvain_idle_2.png` |
| 1-3 | repos 3 | `sylvain_idle_3` | `sylvain_idle_3.png` |
| 1-4 | dos | `sylvain_back` | `sylvain_back.png` |
| 2-1 | marche | `sylvain_walk` | `sylvain_walk.png` |
| 2-2 | attaque 1 | `sylvain_attack` | `sylvain_attack.png` |
| 2-3 | attaque 2 | `sylvain_attack_2` | `sylvain_attack_2.png` |
| 2-4 | attaque 3 | `sylvain_attack_3` | `sylvain_attack_3.png` |
| 3-1 | attaque 4 | `sylvain_attack_4` | `sylvain_attack_4.png` |
| 3-2 | sort 1 | `sylvain_cast` | `sylvain_cast.png` |
| 3-3 | sort 2 | `sylvain_cast_2` | `sylvain_cast_2.png` |
| 3-4 | sort 3 | `sylvain_cast_3` | `sylvain_cast_3.png` |

Copie conseillée de la pose de repos vers `prototype/zimut/assets/sprites/nations/heros/sylvain.png` et des poses vers `nations/heros/poses/`.

## 3. Ennemis

### Garde aérien — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Garde aérien, enemy of the Vents nation. Sky guard in blue and silver armor with small wings on the helmet, holding a halberd.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. wind-up, staff held back with both hands.
6. staff swing forward, small wind ribbons and feathers burst at the tip.
7. staff raised, wind ribbons and feathers orb forming at the top.
8. staff pointed forward, releasing a compact wind ribbons and feathers blast.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/vents/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `garde_aerien` | `garde_aerien.png` |
| 1-2 | repos 2 | `garde_aerien_idle_2` | `garde_aerien_idle_2.png` |
| 1-3 | dos | `garde_aerien_back` | `garde_aerien_back.png` |
| 1-4 | marche | `garde_aerien_walk` | `garde_aerien_walk.png` |
| 2-1 | attaque 1 | `garde_aerien_attack` | `garde_aerien_attack.png` |
| 2-2 | attaque 2 | `garde_aerien_attack_2` | `garde_aerien_attack_2.png` |
| 2-3 | sort 1 | `garde_aerien_cast` | `garde_aerien_cast.png` |
| 2-4 | sort 2 | `garde_aerien_cast_2` | `garde_aerien_cast_2.png` |

### Aigle céleste — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Aigle céleste, enemy of the Vents nation. Large deep blue eagle with golden talons and spread wings.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. crouched wind-up, ready to pounce.
6. lunge forward, jaws or claws first, small wind ribbons and feathers impact.
7. head raised, wind ribbons and feathers gathering around the body.
8. releasing a short wind ribbons and feathers breath or wave forward.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/vents/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `aigle_celeste` | `aigle_celeste.png` |
| 1-2 | repos 2 | `aigle_celeste_idle_2` | `aigle_celeste_idle_2.png` |
| 1-3 | dos | `aigle_celeste_back` | `aigle_celeste_back.png` |
| 1-4 | marche | `aigle_celeste_walk` | `aigle_celeste_walk.png` |
| 2-1 | attaque 1 | `aigle_celeste_attack` | `aigle_celeste_attack.png` |
| 2-2 | attaque 2 | `aigle_celeste_attack_2` | `aigle_celeste_attack_2.png` |
| 2-3 | sort 1 | `aigle_celeste_cast` | `aigle_celeste_cast.png` |
| 2-4 | sort 2 | `aigle_celeste_cast_2` | `aigle_celeste_cast_2.png` |

### Harpie — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Harpie, enemy of the Vents nation. Harpy with green and gold feathered wings for arms and bird legs.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. drawing back, body stretched upward.
6. lunging forward, claws of wind ribbons and feathers reaching out.
7. hovering higher, wind ribbons and feathers orbs circling the body.
8. releasing a compact wind ribbons and feathers wave forward.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/vents/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `harpie` | `harpie.png` |
| 1-2 | repos 2 | `harpie_idle_2` | `harpie_idle_2.png` |
| 1-3 | dos | `harpie_back` | `harpie_back.png` |
| 1-4 | marche | `harpie_walk` | `harpie_walk.png` |
| 2-1 | attaque 1 | `harpie_attack` | `harpie_attack.png` |
| 2-2 | attaque 2 | `harpie_attack_2` | `harpie_attack_2.png` |
| 2-3 | sort 1 | `harpie_cast` | `harpie_cast.png` |
| 2-4 | sort 2 | `harpie_cast_2` | `harpie_cast_2.png` |

### Élémentaire de vent — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE enemy monster for a chibi isometric tactical RPG.
CHARACTER: Élémentaire de vent, enemy of the Vents nation. Swirling pale blue wind spirit with a round cloud body and small arms of wind.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. drawing back, body stretched upward.
6. lunging forward, claws of wind ribbons and feathers reaching out.
7. hovering higher, wind ribbons and feathers orbs circling the body.
8. releasing a compact wind ribbons and feathers wave forward.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/ennemis/vents/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `elementaire_de_vent` | `elementaire_de_vent.png` |
| 1-2 | repos 2 | `elementaire_de_vent_idle_2` | `elementaire_de_vent_idle_2.png` |
| 1-3 | dos | `elementaire_de_vent_back` | `elementaire_de_vent_back.png` |
| 1-4 | marche | `elementaire_de_vent_walk` | `elementaire_de_vent_walk.png` |
| 2-1 | attaque 1 | `elementaire_de_vent_attack` | `elementaire_de_vent_attack.png` |
| 2-2 | attaque 2 | `elementaire_de_vent_attack_2` | `elementaire_de_vent_attack_2.png` |
| 2-3 | sort 1 | `elementaire_de_vent_cast` | `elementaire_de_vent_cast.png` |
| 2-4 | sort 2 | `elementaire_de_vent_cast_2` | `elementaire_de_vent_cast_2.png` |

## 4. Boss

### Aéron le Céleste — 12 poses

Grille 4 × 3.

```text
Sprite sheet of ONE final boss for a chibi isometric tactical RPG.
CHARACTER: Aéron le Céleste, boss of the Vents nation. Celestial lord in pale cyan feathered armor with long flowing layers, crown of silver spikes, holding a tall silver staff with a wing crystal, imposing chibi with slightly longer body proportions than regular characters (head about 1/4 of total height).
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories, weapon always in the same hand.
NATION PALETTE: pale teal, silver, sky white, mint.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle pale sky white rim light on the right edge.
GRID: Strict grid of 4 columns x 3 rows, 12 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right, relaxed ready stance.
2. idle variant, breathing in, shoulders slightly raised, same stance.
3. idle variant, alert, glancing to the side, weapon ready.
4. idle seen from behind, 3/4 back-right view.
5. walking, 3/4 front-right, mid-stride, left foot forward.
6. wind-up, staff held back with both hands.
7. staff swing forward, small wind ribbons and feathers burst at the tip.
8. follow-through, staff low, body turned.
9. thrust with the staff tip forward, short wind ribbons and feathers spark.
10. staff raised, wind ribbons and feathers orb forming at the top.
11. staff held high with both hands, wind ribbons and feathers swirling around.
12. staff pointed forward, releasing a compact wind ribbons and feathers blast.
EFFECTS: wind ribbons and feathers, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat medium gray background (#808080) (the character is pale, a white background would merge with it), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/nations/boss/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `vents` | `vents.png` |
| 1-2 | repos 2 | `vents_idle_2` | `vents_idle_2.png` |
| 1-3 | repos 3 | `vents_idle_3` | `vents_idle_3.png` |
| 1-4 | dos | `vents_back` | `vents_back.png` |
| 2-1 | marche | `vents_walk` | `vents_walk.png` |
| 2-2 | attaque 1 | `vents_attack` | `vents_attack.png` |
| 2-3 | attaque 2 | `vents_attack_2` | `vents_attack_2.png` |
| 2-4 | attaque 3 | `vents_attack_3` | `vents_attack_3.png` |
| 3-1 | attaque 4 | `vents_attack_4` | `vents_attack_4.png` |
| 3-2 | sort 1 | `vents_cast` | `vents_cast.png` |
| 3-3 | sort 2 | `vents_cast_2` | `vents_cast_2.png` |
| 3-4 | sort 3 | `vents_cast_3` | `vents_cast_3.png` |

## Prompt négatif (toutes les planches de cette page)

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art
```
