# Prompts — décors et ciels de ville (V62)

## Décors (`deco_<type>.png`, canvas 120×110, pied au sol en (60, 100), fond transparent)

```text
Small 2D game prop, canvas 120x110, transparent background, prop foot at (60, 100).
<BIOME> palette. Prop: <TYPE> —
  tree: gnarled trunk + 3 round green canopies (#3F7A3A);
  rock: grey boulder #8A8A92;
  well: stone ring, wooden posts and little roof, water inside;
  stall: market stall with striped awning (<BIOME> roof color), 3 fruits on the counter;
  lamp: tall iron lantern post with a warm glowing lamp (#FFE9A0, halo inside the sprite);
  cart: wooden merchant cart with two wheels;
  fire: campfire / brazier with orange flames (#FF8028 / #FFD870) and a warm halo.
STYLE LOCK: smooth hand-drawn vector-cartoon, THICK DARK-BROWN OUTLINES, Dofus/Waven-like,
flat colors + cel shading, key light upper left — never pixel art, never thin outline.
NEGATIVE: no text, no labels, no frame, no opaque background, no people, no pixel art.
```

## Ciels (`sky_jour|soir|nuit.png`, canvas 1000×400, fond plein OPAQUE — pas de transparence ici)

```text
Wide painted sky backdrop, canvas 1000x400, full opaque background, game UI header art.
- jour: gradient sky #7EC0EE → #C8E8F8, sun top-right with soft disc, 3 fluffy white clouds.
- soir: gradient #4A5AA8 → #E88A50 → #F8C060, low sun on the horizon, 2 mauve clouds.
- nuit: gradient #0C1030 → #2C3468, 60 stars, crescent moon top-right, faint nebula clouds.
Add distant silhouettes of <BIOME> landscape along the bottom edge (hills / palms / peaks /
crystals / waves / dunes…), darkened by 30%.
STYLE LOCK identical (vector-cartoon, thick outlines on the silhouettes, cel shading).
NEGATIVE: no text, no frame, no watermark, no people, no buildings in the foreground.
```
