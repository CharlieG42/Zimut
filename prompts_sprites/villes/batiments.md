# Prompts — bâtiments de ville (V62)

Pour chaque biome (palette dans `README.md`) et chaque bâtiment, copier le bloc correspondant
en remplaçant `<BIOME>` par la palette du biome et `<N>` par le niveau.

## Hameau → Métropole : hôtel de ville (`hall_1..5`)

Niveaux : 1 = petite maison de bois à un étage ; 2 = maison plus large avec une aile de chaque
côté ; 3 = tour centrale avec horloge ; 4 = tours d'angle ; 5 = dôme + flèche dorée.

```text
Isometric-ish 2D illustration of a <BIOME> town hall at level <N>, game UI building sprite,
canvas 260x220, transparent background, building foot exactly at pixel (130, 200) bottom-center.
<BIOME> PALETTE: walls / roof / trim / ground colors from the table in README.md.
Silhouette level <N>: <description du niveau, voir table ci-dessus>.
Materials: timber/stone walls with visible joints, tiled roof with 2-tone cel shading, wooden
door, 3 warm lit windows (amber #FFDF8A) on the front, small chimney with faint smoke.
STYLE LOCK: smooth hand-drawn vector-cartoon with THICK DARK-BROWN OUTLINES, Dofus/Waven-like
scenery, flat colors + 2-3 tone cel shading, soft key light from upper left, thin warm edge
highlight on the right — never pixel art, never thin/white outline, never glow.
NEGATIVE: no text, no labels, no frame, no opaque background, no extra buildings, no people,
no pixel art, no blur.
```

## Caserne (`barracks_1..3`)

```text
<BIOOME> military barracks building sprite, level <N>, canvas 260x220 transparent, foot at
(130, 200). Crenellated stone hall with a watch tower and flag, <N+2> small soldiers drilling in
front (simple chibi soldiers, blue-grey tunics, spears). <BIOME> palette + stone grey.
STYLE LOCK + NEGATIVE identiques au bloc hall.
```

## Résidence du gouverneur (`residence_1..3`)

```text
<BIOOME> governor's residence, level <N>, canvas 260x220 transparent, foot at (130, 200).
Elegant house with a colonnade (4 columns), pediment, banner on the roof, 2 lit windows.
<BIOME> palette with lighter walls. STYLE LOCK + NEGATIVE identiques.
```

## Scierie (`scierie_1..3`)

```text
<BIOOME> sawmill, level <N>, canvas 260x220 transparent, foot at (130, 200): wooden shed,
stack of <1+2N> logs, a big circular saw blade (level 2: two blades). <BIOME> palette + wood
browns. STYLE LOCK + NEGATIVE identiques.
```

## Mine (`mine_1..3`)

```text
<BIOOME> mine entrance, level <N>, canvas 260x220 transparent, foot at (130, 200): rocky mound
with a dark tunnel mouth, timber frame, warm lantern glow at the entrance; level 2 adds a
headframe (winding tower), level 3 adds smoke. <BIOME> palette + rock grey #7A7880.
STYLE LOCK + NEGATIVE identiques.
```

## Tannerie (`tannerie_1..3`)

```text
<BIOOME> tannery, level <N>, canvas 260x220 transparent, foot at (130, 200): canvas tent,
<N+1> racks with hanging hides, level 2 adds a small workshop shed, level 3 smoke.
<BIOME> palette + tan #C89A68. STYLE LOCK + NEGATIVE identiques.
```

## Cabane des mages (`cabane_1..3`)

```text
<BIOOME> mage hut, level <N>, canvas 260x220 transparent, foot at (130, 200): crooked tower with
conical violet roof, glowing floating orb above it (purple #B89AFF with a soft halo INSIDE the
sprite), glowing window; level 2 adds a side shed. <BIOME> palette + violet #5C4480.
STYLE LOCK + NEGATIVE identiques (halo autorisé ici, uniquement autour de l'orbe).
```

## Verger (`verger_1..3`)

```text
<BIOOME> orchard, level <N>, canvas 260x220 transparent, foot at (130, 200): <1+2N> fruit trees
in a row (green canopies #4A8A3A with red apples), level 2 adds a well in the middle.
<BIOME> ground color. STYLE LOCK + NEGATIVE identiques.
```

## Muraille (`muraille_1..3`)

```text
<BIOOME> city wall section, level <N>, canvas 260x220 transparent, foot at (130, 200):
crenellated stone wall <30+10N> px tall with two flanking towers (banners at level 3),
stone grey #8A8A90 mixed with <BIOME> trim. STYLE LOCK + NEGATIVE identiques.
```

## Merveilles (`wonder_<forme>`)

Une forme par Nation : `tree` (Forêt, Brumes : great glowing tree), `forge` (Montagne, Brasier :
forge with chimney smoke and orange furnace mouth), `pyramid` (Désert : golden-capped pyramid),
`crystal` (Cristaux : 3 giant crystals), `tower` (Marées : lighthouse with rotating beam /
Rouages : clock tower), `mill` (Vents : windmill with 4 blades), `crypt` (Ombres, Donjon :
round crypt with glowing rune circle).

```text
<BIOOME> national wonder "<forme>", canvas 260x220 transparent, foot at (130, 200),
<BIOME> palette. The wonder is grander than a house: <description de la forme ci-dessus>,
with a soft colored halo (trim color, inside the sprite) and 1-2 glowing details.
STYLE LOCK + NEGATIVE identiques (halo autorisé autour de la merveille uniquement).
```
