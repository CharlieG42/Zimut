# Prompts V65 — bâtiments des 8 nations restantes (Sables, Cristaux, Marées, Vents, Brasier, Brumes, Ombres, Rouages)

Norme V65 (`assets/ui/conquest/cities/batiments/NORME_GENERATION_V65.md`) :
**1 bâtiment par image**, ses **5 niveaux en ligne horizontale** (gauche = niveau 1, droite = niveau 5),
**caméra isométrique 2:1 identique** dans les 5 cases, **même losange de socle** et **même emprise**
par bâtiment dans les 5 cases, **fond uni** (blanc pur, ou vert chroma `#00B140` pour Marées et Vents),
**sans ombre au sol, sans halo, sans reflets, sans personnages** (le jeu dessine ombre, nom, étoiles,
soldats et gouverneur).

Emprises : hall / mine / verger / muraille / merveille = **3×3** ; caserne / résidence / cabane /
tannerie / scierie = **2×2** ; décors isolés = 1×1 (hors périmètre ici).

Style validé : rendu 3D peint « jouet », palette saturée, lumière chaude golden-hour, toits brillants
exagérés, silhouettes très lisibles — comme les planches Forêt/Montagne déjà livrées.

Évolutions par niveau (communes à toutes les nations, à recopier dans chaque prompt) :

| Bâtiment | niv 1 | niv 2 | niv 3 | niv 4 | niv 5 |
|---|---|---|---|---|---|
| hall | maison simple | + 2 ailes | tour d'horloge centrale | tours d'angle à drapeaux | dôme doré + flèche |
| caserne | corps de garde | + tour de guet | créneaux + 2 mannequins | mur d'enceinte + râteliers | grande caserne, drapeaux, porte de cour |
| résidence | maison à porche à colonnes | + ailes | drapeaux + balcon | jardin + lanternes | manoir + tourelle |
| scierie | hutte + pile de rondins | scie circulaire sous auvent | 2 bancs + rampe | abri à planches | scierie complète + cheminée |
| mine | entrée + lanterne | chevalement + wagonnet | 2 wagonnets + cheminée | double chevalement + trémie | grand complexe minier |
| tannerie | tente + 2 peaux | 3 séchoirs + cabane | atelier complet + cheminée | cuves + caisses | grande tannerie + cour |
| cabane | hutte ronde + orbe | plus haute + annexe | petite tour + anneau de runes | lanternes magiques | grande tour + dôme runique |
| verger | 3 arbres fruitiers | 5 arbres + puits | 2 rangées + lanterne + abri | treillis + paniers | verger en terrasses + murets |
| muraille | mur crénelé + porte | + 2 tours | tours + drapeaux | porte renforcée | porte citadelle + hautes tours |
| merveille | sprite unique (pas de niveaux) | | | | |

Merveilles par nation : Sables **Grand Bazar** (bazar à dômes et auvents rayés) · Cristaux **Prisme
Éternel** (monolithe de cristal géant) · Marées **Grand Phare** (phare à lanterne brillante) ·
Vents **Moulin des Tempêtes** (grand moulin à 4 ailes) · Brasier **Haut-Fourneau** (tour de fonte
avec brasier ardent) · Brumes **Serre des Brumes** (serre de verre dans la brume, plantes rares) ·
Ombres **Crypte des Serments** (chapelle/crypte gothique à ogives) · Rouages **Grande Horloge**
(tour à engrenages visibles et grand cadran).

---

## Gabarit commun (à copier dans chaque prompt, en remplaçant les champs entre < >)

```text
Building sprite sheet for a premium mobile strategy game: the <BATIMENT> of the <NATION THEME>
nation, ONE single building shown at its 5 upgrade levels, for a city-building screen.
STYLE: hand-painted stylized 3D game render like a premium mobile strategy game, vibrant saturated
palette, warm golden-hour lighting, toy-like proportions with exaggerated glossy roofs, highly
readable silhouettes — same art style as the existing forest and mountain building sheets.
NATION IDENTITY (keep the spirit of the nation in every level): <TRAIT + PALETTE + DETAILS, voir carte ci-dessous>.
ARCHITECTURE ID CARD: walls <MURS> ; roofs <TOITS> ; trim and details <TRIM>.
FORBIDDEN: <INTERDITS de la nation>.
LAYOUT: 5 cells in one horizontal row; ONE building per cell; the SAME building, one upgrade level
higher in each cell; EVERY cell uses the exact SAME isometric 2:1 camera angle and the exact SAME
diamond-shaped stone plaza base, identical footprint of <EMPRISE> tiles in every cell, so all five
levels could sit on the same isometric grid; NO cast shadow on the ground, NO glow halo, NO
reflections; plain <white / uniform green chroma key #00B140> background, no gradient, no vignette.
LEVELS: cell 1 = <niv1> ; cell 2 = <niv2> ; cell 3 = <niv3> ; cell 4 = <niv4> ; cell 5 = <niv5>
(voir table des évolutions ci-dessus).
BUILDING CHECK: EXACTLY 5 buildings, the SAME building growing, same base in every cell.
AVOID: people, characters, flat vector art, outline cartoon, pixel art, anime, text, labels, logos,
different base shapes, different scales, cast shadows, background gradients, extra buildings.
```

Pour la merveille (1 seule case) : même gabarit avec `LAYOUT: 1 single cell, ONE <MERVEILLE>
building, isometric 2:1 camera, diamond stone plaza base of 3x3 tiles, plain <fond> background,
no cast shadow, no glow halo, no people`.

---

## Cartes d'identité des 8 nations (esprit + palettes hex, d'après NORME_GENERATION_V65.md §5 et Nations.gd)

### Sables (Désert) — fond blanc pur
- Esprit : dunes, oasis, caravanes, marché oriental. Trait : « Dunes, cactus, obélisque et puits de grès. »
- Murs : grès `#E6C78C` · Toits : terre cuite `#CC7338` (+ dômes blancs) · Trim : doré `#FADB73`, auvents rayés, palmiers, lanternes.
- Interdits : pas de neige, pas de bois sombre, pas de vert forêt.

### Cristaux — fond blanc pur
- Esprit : grottes de cristal, éclats lumineux, runes. Trait : « Sol d'ardoise, éclats lumineux, monolithe de cristal et lueurs flottantes. »
- Murs : pierre violet-gris `#8F87BD` + gemmes · Toits : bleu ciel `#6B99FA` · Trim : lilas `#D1B8FF`, cristaux `#8FD4FF`, fenêtres en ogive.
- Interdits : pas de briques rouges, pas de doré médiéval, pas de bois.

### Marées — fond vert chroma `#00B140`
- Esprit : côte, phare, quais, coquillages. Trait : « Sable mouillé, flaques turquoise, coraux, phare et ancre rouillée. »
- Murs : chaulé `#E6E0CC` + cordes/coquillages · Toits : bleu profond `#3385B8` · Trim : or `#F5DB8C`, corail `#FF8A70`, ancre, filets.
- Interdits : pas de désert, pas de lave, pas de violet.

### Vents — fond vert chroma `#00B140`
- Esprit : îles flottantes, moulins, rubans de vent, plumes. Trait : « Îles flottantes, rubans de vent, moulins, totems à plumes et arche céleste. »
- Murs : plâtre pâle `#DBE3EB` · Toits : sarcelle `#66ADD1` · Trim : blanc `#F5F5FF`, totems, girouettes, volutes.
- Interdits : pas de pierre sombre, pas de lave, pas de doré.

### Brasier — fond blanc pur
- Esprit : volcan, lave, forges ardentes. Trait : « Basalte noir, fissures de lave, braseros, fumerolles et cône volcanique. »
- Murs : basalte `#57443D` · Toits : rouge braise `#BD471F` · Trim : lave orange `#FF9E38`, roches volcaniques, braseros `#E8452C`.
- Interdits : pas de neige, pas de bleu océan, pas de bois clair.

### Brumes — fond blanc pur
- Esprit : marais embrumé, champignons phosphorescents, feux follets. Trait : « Marais embrumé, champignons phosphorescents, arbres morts et feux follets. »
- Murs : pierre vert pâle moussue `#859985` · Toits : vert-de-gris `#42807A` · Trim : menthe pâle `#B8F5DB`, champignons tachetés, brume.
- Interdits : pas de couleurs vives saturées, pas de lave, pas de doré.

### Ombres — fond blanc pur
- Esprit : landes gothiques, runes, torches mauves, corbeaux. Trait : « Pavés runiques, ronces violettes, torches mauves, corbeaux et porte sombre. »
- Murs : pierre violette `#615270` · Toits : violet profond `#704094` · Trim : lilas luisant `#C794FF`, ronces, ogives gothiques `#7858F0`.
- Interdits : pas de couleurs claires/blanches dominantes, pas de doré, pas de vert.

### Rouages — fond blanc pur
- Esprit : ateliers industriels, vapeur, engrenages. Trait : « Dalles d'acier, engrenages géants, tuyaux fumants, enclumes et bobines à arcs. »
- Murs : brique cuivrée `#A38566` + laiton · Toits : cuivre `#C27A38` · Trim : laiton/engrenages `#F5C25C`, tuyaux, vapeur.
- Interdits : pas de bois naturel, pas de pierre médiévale, pas de violet.

---

## Ordre de génération conseillé (par nation)
1. `hall` (5 niveaux) → 2. `caserne` → 3. `residence` → 4. `scierie` → 5. `mine` → 6. `tannerie` →
7. `cabane` → 8. `verger` → 9. `muraille` → 10. `merveille` (1 case).

Chaque image = 1 prompt. Nommer les fichiers sources `planches/<nation>/<batiment>.png`
puis lancer la découpe (voir `DECOUPE_V65.md`).
