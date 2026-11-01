# Norme de génération des sprites de bâtiments — V65 « 1 bâtiment par image » (2026-11-01)

Document de référence pour la **génération** et l'**intégration** des sprites de bâtiments de
l'écran de ville de Conquête. Il remplace l'ancien format « planche multi-bâtiments » pour toutes
les nouvelles images (l'ancien format reste documenté plus haut dans ce dossier, à titre historique).

## 1. Principes

1. **Un seul type de bâtiment par image** (ou un seul décor isolé — arbre, puits, bannière…).
2. Le MÊME bâtiment à ses **5 niveaux** dans la même image, une case par niveau, de gauche
   (niveau 1) à droite (niveau 5).
3. **Même caméra isométrique 2:1** pour tous les bâtiments, toutes nations confondues.
4. **Même losange de socle** (dalle isométrique) pour tous les bâtiments d'une même emprise.
5. **Emprise fixe par bâtiment** (table §2), identique sur les 5 niveaux — c'est l'échelle
   relative entre emprises qui fait la hiérarchie visuelle, pas la taille du dessin.
6. **Fond uni** : blanc pur, ou vert chroma `#00B140` (recommandé pour les nations claires :
   Cimes, Marées, Vents). Jamais de dégradé, jamais de bande noire, jamais d'arrière-plan de scène.
7. **Pas d'ombre portée au sol, pas de halo lumineux, pas de reflet** dans l'image : le jeu
   dessine lui-même l'ombre au sol, la plaque de nom et les étoiles de niveau.
8. **Pas de personnages** : le jeu dessine habitants, soldats à l'exercice (caserne) et
   gouverneur (résidence) par-dessus le sprite.

**Style validé** : rendu 3D stylisé peint (painterly) type stratégie mobile premium — palette très
saturée, lumière chaude golden-hour, proportions « jouet », toits brillants exagérés, silhouettes
très lisibles, socle de terrain sous chaque bâtiment.

## 2. Table des emprises

| Bâtiment | Emprise | Niveaux |
|---|---|---|
| Hôtel de ville | **3×3** | 1→5 (Hameau→Métropole) |
| Merveille | **3×3** | sprite unique |
| Mine | **3×3** | 1→5 |
| Verger | **3×3** | 1→5 |
| Muraille | **3×3** | 1→5 |
| Caserne | **2×2** | 1→5 |
| Résidence | **2×2** | 1→5 |
| Cabane des mages | **2×2** | 1→5 |
| Tannerie | **2×2** | 1→5 |
| Scierie | **2×2** | 1→5 |
| Décors isolés (arbre, puits, bannière…) | **1×1** | sprite unique |

## 3. Évolutions par niveau (référence commune à toutes les nations)

| Bâtiment | 1 | 2 | 3 | 4 | 5 |
|---|---|---|---|---|---|
| Hôtel de ville | maison simple | + 2 ailes | tour d'horloge centrale | tours d'angle à drapeaux | dôme doré + flèche |
| Caserne | corps de garde | + tour de guet | créneaux + 2 mannequins d'entraînement | mur d'enceinte + râteliers | grande caserne, drapeaux, porte de cour |
| Résidence | maison élégante à porche à colonnes | + ailes | drapeaux + balcon | jardin + lanternes | manoir + tourelle |
| Scierie | hutte + pile de rondins | scie circulaire sous auvent | 2 bancs + rampe | abri à planches | scierie complète + cheminée |
| Mine | entrée + lanterne | chevalement + wagonnet | 2 wagonnets + cheminée | double chevalement + trémie | grand complexe minier |
| Tannerie | tente + 2 peaux | 3 séchoirs + cabane | atelier complet + cheminée | cuves + caisses | grande tannerie + cour |
| Cabane des mages | hutte ronde + orbe | plus haute + annexe | petite tour + anneau de runes | lanternes magiques | grande tour + dôme runique |
| Verger | 3 arbres fruitiers | 5 arbres + puits | 2 rangées + lanterne + abri | treillis + paniers | verger en terrasses + murets |
| Muraille | mur crénelé + porte | + 2 tours | tours + drapeaux | porte renforcée | porte citadelle + plus hautes tours |

Merveille et icône de ville : sprite unique (pas de niveaux).

## 4. Stockage et nommage

- **Planches brutes** (images générées, avant découpe) : `batiments/planches/<nation>/<batiment>.png`
  — sources conservées mais **jamais chargées par le jeu**.
- **Sprites finaux** : `batiments/<nation>/<batiment>_<niveau>.png`, avec le `.png.import`
  Godot commité à côté (la CI `tools/check_assets.py` vérifie la paire).
- Bâtiments à niveaux : suffixes `_1` … `_5` (hall, caserne, résidence, scierie, mine,
  tannerie, cabane, verger, muraille). `merveille.png` et `icone_ville.png` restent sans suffixe.
- Clés nation (dossiers) : `sylvestre`, `cimes`, `sables`, `cristaux`, `marees`, `vents`,
  `brasier`, `brumes`, `ombres`, `rouages`.
- ⚠️ **Adaptation code requise au passage complet V65** : aujourd'hui `caserne`/`residence`
  sont sans suffixe et la production/muraille est sur 3 niveaux (`ConquestCityView.gd`).
  Le repli de niveau déjà en place facilite la transition : une nation qui ne livre qu'un dessin
  par bâtiment l'utilise à tous les niveaux en attendant les 5.
- **Détourage** : le canal alpha est indispensable. Depuis la V64, `ConquestCityView` recadre
  automatiquement chaque PNG sur ses pixels visibles — une découpe « au bord de case » est
  corrigée seule ; un PNG opaque est utilisé tel quel.

## 5. Cartes d'architecture par nation (palettes de référence)

| Nation | Murs | Toits | Trim / détails |
|---|---|---|---|
| Sylvestre (Forêt) | bois miel `#9E754D`, colombage chêne `#4A3420`, mousse | vert mousse `#3D8045` | crème doré `#EBCC73`, buissons, drapeau vert `#349E57` |
| Cimes (Montagne) | granit `#B8BDC7` + poutres sombres | ardoise bleue `#4766A3` + neige | blanc neige/fourrure `#EBF5FF`, glaçons, cristaux `#9FE3FF` |
| Sables (Désert) | grès `#E6C78C` | terre cuite `#CC7338` (+ dômes) | doré `#FADB73`, auvents rayés, palmier, lanternes |
| Cristaux | pierre violet-gris `#8F87BD` + gemmes | bleu ciel `#6B99FA` | lilas `#D1B8FF`, cristaux `#8FD4FF`, fenêtres en ogive |
| Marées | murs chaulés `#E6E0CC` + cordes/coquillages | bleu profond `#3385B8` | or `#F5DB8C`, corail `#FF8A70`, ancre, filet |
| Vents | plâtre pâle `#DBE3EB` | sarcelle `#66ADD1` | blanc `#F5F5FF`, totems, girouettes, volutes |
| Brasier | basalte `#57443D` | rouge braise `#BD471F` | lave orange `#FF9E38`, roches volcaniques, braseros `#E8452C` |
| Brumes | pierre vert pâle moussue `#859985` | vert-de-gris `#42807A` | menthe pâle `#B8F5DB`, champignons tachetés, brume |
| Ombres | pierre violette `#615270` | violet profond `#704094` | lilas luisant `#C794FF`, ronces, ogives gothiques `#7858F0` |
| Rouages | brique cuivrée `#A38566` + laiton | cuivre `#C27A38` | laiton/engrenages `#F5C25C`, tuyaux, vapeur |

Fond par nation : blanc pur par défaut ; **vert chroma `#00B140` pour les nations claires**
(Cimes, Marées, Vents) — l'ancien gris `#808080` est déconseillé en V65.

Merveilles : Sylvestre **Arbre-Ancêtre**, Cimes **Forge des Cimes**, Sables **Grand Bazar**,
Cristaux **Prisme Éternel**, Marées **Grand Phare**, Vents **Moulin des Tempêtes**,
Brasier **Haut-Fourneau**, Brumes **Serre des Brumes**, Ombres **Crypte des Serments**,
Rouages **Grande Horloge** (Donjon : Trône d'Os — siège ennemi, jamais possédé).

## 6. Gabarit de prompt (réutilisable)

Structure en anglais, sans référence à aucune marque :

```text
Building sprite sheet for a premium mobile strategy game: the <bâtiment> of a <nation theme>
nation, ONE single building shown at its 5 upgrade levels, for a city-building screen.
STYLE: hand-painted stylized 3D game render like a premium mobile strategy game, vibrant
saturated palette, warm golden-hour lighting, toy-like proportions with exaggerated glossy
roofs, highly readable silhouettes.
ARCHITECTURE ID CARD: <murs> ; roofs <toits> ; trim and details <trim>. FORBIDDEN: <interdits>.
LAYOUT: 5 cells in one horizontal row; ONE building per cell; the SAME building, one upgrade
level higher in each cell; EVERY cell uses the exact SAME isometric 2:1 camera angle and the
exact SAME diamond-shaped stone plaza base, identical footprint of <NxN> tiles in every cell,
so all five levels could sit on the same isometric grid; NO cast shadow on the ground,
NO glow halo, NO reflections; plain <white / uniform green chroma key #00B140> background,
no gradient.
LEVELS: cell 1 …; cell 2 …; cell 3 …; cell 4 …; cell 5 …
BUILDING CHECK: EXACTLY 5 buildings, the SAME building growing.
AVOID: people, characters, flat vector art, outline cartoon, pixel art, anime, text, logos,
different base shapes, different scales, cast shadows, background gradients.
```
