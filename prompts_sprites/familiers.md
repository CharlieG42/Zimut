# Familiers (invocations)

Fichiers dans `prototype/zimut/assets/sprites/summons/`. Palette libre par familier, même style que les nations. Les familiers d'une même classe gagnent à être générés avec la planche du héros en référence.

### Golem de pierre (Invocateur, ex-Tortue) — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Golem de pierre, a summon. Grey stone golem with blue crystals growing from the shoulders and back.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. wind-up, fist or weapon raised high.
6. heavy smash forward, ground cracking with a small matching magical sparks burst.
7. stomping, matching magical sparks cracks spreading under the feet.
8. slamming both fists down, matching magical sparks shockwave.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/summons/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `golem_de_pierre` | `golem_de_pierre.png` |
| 1-2 | repos 2 | `golem_de_pierre_idle_2` | `golem_de_pierre_idle_2.png` |
| 1-3 | dos | `golem_de_pierre_back` | `golem_de_pierre_back.png` |
| 1-4 | marche | `golem_de_pierre_walk` | `golem_de_pierre_walk.png` |
| 2-1 | attaque 1 | `golem_de_pierre_attack` | `golem_de_pierre_attack.png` |
| 2-2 | attaque 2 | `golem_de_pierre_attack_2` | `golem_de_pierre_attack_2.png` |
| 2-3 | sort 1 | `golem_de_pierre_cast` | `golem_de_pierre_cast.png` |
| 2-4 | sort 2 | `golem_de_pierre_cast_2` | `golem_de_pierre_cast_2.png` |

### Loup spectral (Invocateur) — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Loup spectral, a summon. Spectral violet wolf with flame-like spiky fur and glowing eyes.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. crouched wind-up, ready to pounce.
6. lunge forward, jaws or claws first, small matching magical sparks impact.
7. head raised, matching magical sparks gathering around the body.
8. releasing a short matching magical sparks breath or wave forward.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/summons/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `loup_spectral` | `loup_spectral.png` |
| 1-2 | repos 2 | `loup_spectral_idle_2` | `loup_spectral_idle_2.png` |
| 1-3 | dos | `loup_spectral_back` | `loup_spectral_back.png` |
| 1-4 | marche | `loup_spectral_walk` | `loup_spectral_walk.png` |
| 2-1 | attaque 1 | `loup_spectral_attack` | `loup_spectral_attack.png` |
| 2-2 | attaque 2 | `loup_spectral_attack_2` | `loup_spectral_attack_2.png` |
| 2-3 | sort 1 | `loup_spectral_cast` | `loup_spectral_cast.png` |
| 2-4 | sort 2 | `loup_spectral_cast_2` | `loup_spectral_cast_2.png` |

### Requin des marées (Invocateur, ex-Sirène) — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Requin des marées, a summon. Bright blue shark with a white belly floating upright, fins like small arms.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. crouched wind-up, ready to pounce.
6. lunge forward, jaws or claws first, small matching magical sparks impact.
7. head raised, matching magical sparks gathering around the body.
8. releasing a short matching magical sparks breath or wave forward.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/summons/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `requin_des_marees` | `requin_des_marees.png` |
| 1-2 | repos 2 | `requin_des_marees_idle_2` | `requin_des_marees_idle_2.png` |
| 1-3 | dos | `requin_des_marees_back` | `requin_des_marees_back.png` |
| 1-4 | marche | `requin_des_marees_walk` | `requin_des_marees_walk.png` |
| 2-1 | attaque 1 | `requin_des_marees_attack` | `requin_des_marees_attack.png` |
| 2-2 | attaque 2 | `requin_des_marees_attack_2` | `requin_des_marees_attack_2.png` |
| 2-3 | sort 1 | `requin_des_marees_cast` | `requin_des_marees_cast.png` |
| 2-4 | sort 2 | `requin_des_marees_cast_2` | `requin_des_marees_cast_2.png` |

### Élémentaire de cristal (Invocateur, ex-Ange) — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Élémentaire de cristal, a summon. Small elemental made of violet and blue crystals, friendly glowing eyes.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. drawing back, body stretched upward.
6. lunging forward, claws of matching magical sparks reaching out.
7. hovering higher, matching magical sparks orbs circling the body.
8. releasing a compact matching magical sparks wave forward.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/summons/` :

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

### Ombre (Invocateur, ex-Homme-Faucon) — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Ombre, a summon. Coiled purple shadow serpent with a dragon-like head, stylized opaque smoke curls.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. drawing back, body stretched upward.
6. lunging forward, claws of matching magical sparks reaching out.
7. hovering higher, matching magical sparks orbs circling the body.
8. releasing a compact matching magical sparks wave forward.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/summons/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `ombre` | `ombre.png` |
| 1-2 | repos 2 | `ombre_idle_2` | `ombre_idle_2.png` |
| 1-3 | dos | `ombre_back` | `ombre_back.png` |
| 1-4 | marche | `ombre_walk` | `ombre_walk.png` |
| 2-1 | attaque 1 | `ombre_attack` | `ombre_attack.png` |
| 2-2 | attaque 2 | `ombre_attack_2` | `ombre_attack_2.png` |
| 2-3 | sort 1 | `ombre_cast` | `ombre_cast.png` |
| 2-4 | sort 2 | `ombre_cast_2` | `ombre_cast_2.png` |

### Esprit de la forêt (Invocateur, ex-Centaure) — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Esprit de la forêt, a summon. Forest stag spirit with a body of leaves and moss and large branching antlers.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. crouched wind-up, ready to pounce.
6. lunge forward, jaws or claws first, small matching magical sparks impact.
7. head raised, matching magical sparks gathering around the body.
8. releasing a short matching magical sparks breath or wave forward.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/summons/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `esprit_de_la_foret` | `esprit_de_la_foret.png` |
| 1-2 | repos 2 | `esprit_de_la_foret_idle_2` | `esprit_de_la_foret_idle_2.png` |
| 1-3 | dos | `esprit_de_la_foret_back` | `esprit_de_la_foret_back.png` |
| 1-4 | marche | `esprit_de_la_foret_walk` | `esprit_de_la_foret_walk.png` |
| 2-1 | attaque 1 | `esprit_de_la_foret_attack` | `esprit_de_la_foret_attack.png` |
| 2-2 | attaque 2 | `esprit_de_la_foret_attack_2` | `esprit_de_la_foret_attack_2.png` |
| 2-3 | sort 1 | `esprit_de_la_foret_cast` | `esprit_de_la_foret_cast.png` |
| 2-4 | sort 2 | `esprit_de_la_foret_cast_2` | `esprit_de_la_foret_cast_2.png` |

### Archer sylvestre (Sylvain) — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Archer sylvestre, a summon. Slim wooden archer made of branches and leaves, carrying a wooden bow.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. drawing the bow, arrow nocked, string pulled to the cheek.
6. release, arrow flying forward with a short matching magical sparks trail.
7. arrow raised to the sky, matching magical sparks gathering on the arrowhead.
8. releasing a volley of three matching magical sparks arrows into the air.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/summons/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `archer_sylvestre` | `archer_sylvestre.png` |
| 1-2 | repos 2 | `archer_sylvestre_idle_2` | `archer_sylvestre_idle_2.png` |
| 1-3 | dos | `archer_sylvestre_back` | `archer_sylvestre_back.png` |
| 1-4 | marche | `archer_sylvestre_walk` | `archer_sylvestre_walk.png` |
| 2-1 | attaque 1 | `archer_sylvestre_attack` | `archer_sylvestre_attack.png` |
| 2-2 | attaque 2 | `archer_sylvestre_attack_2` | `archer_sylvestre_attack_2.png` |
| 2-3 | sort 1 | `archer_sylvestre_cast` | `archer_sylvestre_cast.png` |
| 2-4 | sort 2 | `archer_sylvestre_cast_2` | `archer_sylvestre_cast_2.png` |

### Ent de combat (Sylvain) — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Ent de combat, a summon. Small wooden ent warrior covered in leaves, stubby branch arms.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. wind-up, fist or weapon raised high.
6. heavy smash forward, ground cracking with a small matching magical sparks burst.
7. stomping, matching magical sparks cracks spreading under the feet.
8. slamming both fists down, matching magical sparks shockwave.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/summons/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `ent_de_combat` | `ent_de_combat.png` |
| 1-2 | repos 2 | `ent_de_combat_idle_2` | `ent_de_combat_idle_2.png` |
| 1-3 | dos | `ent_de_combat_back` | `ent_de_combat_back.png` |
| 1-4 | marche | `ent_de_combat_walk` | `ent_de_combat_walk.png` |
| 2-1 | attaque 1 | `ent_de_combat_attack` | `ent_de_combat_attack.png` |
| 2-2 | attaque 2 | `ent_de_combat_attack_2` | `ent_de_combat_attack_2.png` |
| 2-3 | sort 1 | `ent_de_combat_cast` | `ent_de_combat_cast.png` |
| 2-4 | sort 2 | `ent_de_combat_cast_2` | `ent_de_combat_cast_2.png` |

### Tronc (Sylvain) — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Tronc, a summon. Cute walking tree stump with a round leafy crown, big eyes and branch arms.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. wind-up, fist or weapon raised high.
6. heavy smash forward, ground cracking with a small matching magical sparks burst.
7. stomping, matching magical sparks cracks spreading under the feet.
8. slamming both fists down, matching magical sparks shockwave.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/summons/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `tronc` | `tronc.png` |
| 1-2 | repos 2 | `tronc_idle_2` | `tronc_idle_2.png` |
| 1-3 | dos | `tronc_back` | `tronc_back.png` |
| 1-4 | marche | `tronc_walk` | `tronc_walk.png` |
| 2-1 | attaque 1 | `tronc_attack` | `tronc_attack.png` |
| 2-2 | attaque 2 | `tronc_attack_2` | `tronc_attack_2.png` |
| 2-3 | sort 1 | `tronc_cast` | `tronc_cast.png` |
| 2-4 | sort 2 | `tronc_cast_2` | `tronc_cast_2.png` |

### Sarriette (Sylvain) — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Sarriette, a summon. Tiny leaf sprite girl in a green leaf hood with little horns and a curly vine.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. wind-up, staff held back with both hands.
6. staff swing forward, small matching magical sparks burst at the tip.
7. staff raised, matching magical sparks orb forming at the top.
8. staff pointed forward, releasing a compact matching magical sparks blast.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/summons/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `sarriette` | `sarriette.png` |
| 1-2 | repos 2 | `sarriette_idle_2` | `sarriette_idle_2.png` |
| 1-3 | dos | `sarriette_back` | `sarriette_back.png` |
| 1-4 | marche | `sarriette_walk` | `sarriette_walk.png` |
| 2-1 | attaque 1 | `sarriette_attack` | `sarriette_attack.png` |
| 2-2 | attaque 2 | `sarriette_attack_2` | `sarriette_attack_2.png` |
| 2-3 | sort 1 | `sarriette_cast` | `sarriette_cast.png` |
| 2-4 | sort 2 | `sarriette_cast_2` | `sarriette_cast_2.png` |

### Ronce agressive (Sylvain) — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Ronce agressive, a summon. Angry bramble bulb covered in thorns with red eyes and whipping vines.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. drawing back, body stretched upward.
6. lunging forward, claws of matching magical sparks reaching out.
7. hovering higher, matching magical sparks orbs circling the body.
8. releasing a compact matching magical sparks wave forward.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/summons/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `ronce_agressive` | `ronce_agressive.png` |
| 1-2 | repos 2 | `ronce_agressive_idle_2` | `ronce_agressive_idle_2.png` |
| 1-3 | dos | `ronce_agressive_back` | `ronce_agressive_back.png` |
| 1-4 | marche | `ronce_agressive_walk` | `ronce_agressive_walk.png` |
| 2-1 | attaque 1 | `ronce_agressive_attack` | `ronce_agressive_attack.png` |
| 2-2 | attaque 2 | `ronce_agressive_attack_2` | `ronce_agressive_attack_2.png` |
| 2-3 | sort 1 | `ronce_agressive_cast` | `ronce_agressive_cast.png` |
| 2-4 | sort 2 | `ronce_agressive_cast_2` | `ronce_agressive_cast_2.png` |

### Sentinelle de grès (pas encore utilisée) — 8 poses

Grille 4 × 2.

```text
Sprite sheet of ONE summoned familiar for a chibi isometric tactical RPG.
CHARACTER: Sentinelle de grès, a summon. Sandstone sentinel statue with amber eyes and carved armor.
Keep exactly the same design in every cell: same outfit, colors, proportions, accessories.
NATION PALETTE: colors as described.
STYLE: Chibi proportions: big head (about 1/3 of total height), short body, expressive large eyes. Polished 2D game art inspired by Dofus and Waven: clean bold dark outlines (thicker on the outer silhouette, thinner inside), 3-tone cel shading, crisp material details (metal shine, fabric folds, leather straps), saturated but harmonious colors, readable silhouette at small size. Soft key light from the upper left, subtle soft colored rim light on the right edge.
GRID: Strict grid of 4 columns x 2 rows, 8 equal cells, exactly one pose per cell. The character is centered in its cell and entirely inside it, with clear empty space all around. Wide empty gutters between cells (at least 20% of a cell). Same scale in every cell. Feet on the same ground line in each row. Effects stay small and inside their own cell.
CELLS, left to right, top to bottom:
1. idle, 3/4 view facing front-right.
2. idle variant, breathing, slightly different posture.
3. idle seen from behind, 3/4 back-right view.
4. moving forward, 3/4 front-right.
5. wind-up, fist or weapon raised high.
6. heavy smash forward, ground cracking with a small matching magical sparks burst.
7. stomping, matching magical sparks cracks spreading under the feet.
8. slamming both fists down, matching magical sparks shockwave.
EFFECTS: matching magical sparks, stylized, opaque, with dark outlines, small and inside their cell.
BACKGROUND: Pure flat white background (#FFFFFF), no checkerboard pattern, no gradient, no floor, no ground shadow, no text, no labels, no numbers, no arrows, no frame or border lines.
```

Fichiers attendus dans `prototype/zimut/assets/sprites/summons/` :

| Case | Pose | Nom à donner dans l'Atelier | Fichier |
|---|---|---|---|
| 1-1 | repos | `sentinelle_de_gres` | `sentinelle_de_gres.png` |
| 1-2 | repos 2 | `sentinelle_de_gres_idle_2` | `sentinelle_de_gres_idle_2.png` |
| 1-3 | dos | `sentinelle_de_gres_back` | `sentinelle_de_gres_back.png` |
| 1-4 | marche | `sentinelle_de_gres_walk` | `sentinelle_de_gres_walk.png` |
| 2-1 | attaque 1 | `sentinelle_de_gres_attack` | `sentinelle_de_gres_attack.png` |
| 2-2 | attaque 2 | `sentinelle_de_gres_attack_2` | `sentinelle_de_gres_attack_2.png` |
| 2-3 | sort 1 | `sentinelle_de_gres_cast` | `sentinelle_de_gres_cast.png` |
| 2-4 | sort 2 | `sentinelle_de_gres_cast_2` | `sentinelle_de_gres_cast_2.png` |

## Prompt négatif

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art
```
