# Prompts d'illustrations de villes — Conquête (V62)

Objectif : remplacer les illustrations SVG générées (`prototype/zimut/assets/ui/conquest/city/…`)
par de **vraies illustrations** (générateur d'images type Mistral/Le Chat), dans le même style
que les sprites de combat (Ankama / Dofus-like, cf. `prompts_sprites/README.md`).

## Format attendu (identique aux SVG, pour un remplacement 1:1)

Chaque image remplace un fichier de `assets/ui/conquest/city/<biome>/`.
**Le jeu charge le `.png` en priorité** (`ConquestCityView._art` essaie `<nom>.png` d'abord,
puis retombe sur `<nom>.svg`) : il suffit de déposer le PNG généré à côté du SVG, même nom,
même taille de canvas — aucun changement de code.

| Fichier | Taille | Contenu |
|---|---|---|
| `<biome>/hall_1..5.svg` → `.png` | 260×220 | hôtel de ville, niveau 1 (hameau) à 5 (métropole) |
| `<biome>/barracks_1..3.png` | 260×220 | caserne (crénelée, tour de guet, soldats) |
| `<biome>/residence_1..3.png` | 260×220 | résidence du gouverneur (colonnade) |
| `<biome>/scierie|mine|tannerie|cabane|verger|muraille_1..3.png` | 260×220 | bâtiments de production, 3 niveaux |
| `<biome>/wonder_<forme>.png` | 260×220 | Merveille de la Nation (tree, forge, pyramid, crystal, tower, mill, crypt) |
| `<biome>/deco_<type>.png` | 120×110 | arbre, rocher, puits, étal, lanterne, charrette, feu de camp |
| `<biome>/sky_jour|soir|nuit.png` | 1000×400 | ciel (fond) |

**Ancrage** : le pied du bâtiment est au point **(130, 200)** du canvas 260×220 — le dessin doit
toucher ce point par le bas (le jeu positionne le sprite par cette ancre). Fond **transparent**.

Biomes (clés de dossier) : `foret, montagne, desert, cristaux, marees, vents, brasier, brumes, ombres, rouages, donjon`.

## Style verrouillé (identique aux planches de personnages)

```text
STYLE LOCK: smooth hand-drawn vector-cartoon illustration with THICK DARK-BROWN OUTLINES
(thicker on the outer silhouette), exactly like Dofus / Waven / Wakfu scenery art and like the
other assets of this game — NEVER pixel art, never low-resolution, never painterly soft edges,
never thin or white outlines. Flat colors with 2-3 tone cel shading, very few gradients,
crisp material details (wood grain, stone joints, fabric folds, metal shine). Soft key light
from the upper left with a thin warm highlight on the right edge (edge highlight, NOT a glow).
Strong readable silhouette at small size.
```

Fond : **transparent** (pas de fond blanc/uni) — l'SVG de remplacement est un PNG à alpha.

## Palettes par biome (couleurs dominantes, codes hex)

| Biome | murs | toits | ornements | sol |
|---|---|---|---|---|
| Forêt | #8A6A44 | #3F7A44 | #E8C86A | #4A6B33 |
| Montagne | #B8BCC4 | #40608C | #E8F0FF | #6A7280 |
| Désert | #E0C088 | #C87838 | #F8DC78 | #D8B070 |
| Cristaux | #8A86B8 | #5A80C8 | #C8B8F8 | #4A4468 |
| Marées | #E0DDD0 | #3080B0 | #F0D888 | #C0B090 |
| Vents | #D8DCE2 | #58A0C8 | #F0F0F8 | #788A70 |
| Brasier | #584840 | #B8482A | #FF9040 | #3C302A |
| Brumes | #848C80 | #428078 | #B8F0DC | #42564C |
| Ombres | #605878 | #7040A0 | #C090F8 | #38304A |
| Rouages | #A08868 | #C07838 | #F0C060 | #584A40 |
| Donjon | #525058 | #3C3448 | #B090F0 | #322E38 |

## Prompts prêts à l'emploi

Un prompt par bâtiment et par biome dans `batiments.md` (structure : biome × bâtiment × niveau),
un par décor dans `decors.md`, un par ciel dans `cieux.md`. Chaque prompt reprend la carte
d'identité du bâtiment (silhouette, matériaux, détails obligatoires) + la palette du biome +
le STYLE LOCK ci-dessus + les négatifs communs :

```text
NEGATIVE: no text, no labels, no numbers, no arrows, no frame or border, no watermark,
no white/cream/opaque background (transparent background required), no pixel art,
no low resolution, no blur, no glow effect around the building, no extra buildings,
no people unless the building description says so (barracks: 3-5 soldiers drilling).
```

Ordre conseillé : ciels → décors → bâtiments niveau 1 → niveaux supérieurs (en **édition** de
l'image du niveau précédent, pour garder le même bâtiment qui grandit) → merveilles.
