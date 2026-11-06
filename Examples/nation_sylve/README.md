# Nation Sylve — carte du territoire (mode Aventure)

Carte isométrique 3/4 (angle de vue ~30–35°) du territoire flottant de la **Nation Sylve**
(faction nature / forêt féerique) pour Zimut. Style peint à la main façon **Dofus / Waven** :
cel-shading doux, contours brun foncé nets, couleurs riches mais douces, lumière chaude de
l'après-midi venant du haut à gauche, brume douce aux bords de l'île.

## Versions

- **v5 (retenue — plein écran Samsung Galaxy S23+, définitif)** — `carte_nation_sylve_v5.*` :
  **2340×1080 (19,5:9 paysage)**. Construction = recadrage 19,5:9 de la scène + upscale
  uniquement : **100 % de contenu peint réel, bord à bord — pas de miroir, pas de flou,
  pas de bandes latérales ajoutées**. Les **4 bâtiments-donjons** (haut-gauche arbre creux
  porte dorée, bas-gauche ruines à l'arche, haut-droite grotte/cascade/cristaux, bas-droite
  temple englouti) sont des repères autonomes bien séparés (rien ne se chevauche), tous
  conservés dans la bande 19,5:9, + sanctuaire central Arbre-Monde (point focal).
  - MD5 après décodage : JPG `114d30fc69c5db63c6d43f8251bb6304` (556 096 octets),
    PNG `d48547834b0074133d6647bde538aaf9` (2 990 207 octets)
  - Lien direct PNG (branche) : `https://raw.githubusercontent.com/CharlieG42/Zimut/vibe/nation-sylve-map-44586e/Examples/nation_sylve/carte_nation_sylve_v5.png`
- **v4** — `carte_nation_sylve_v4.*` : 2340×1080 mais bords remplis par **miroir** (copie du
  centre) — remplacée par la v5 car le miroir dupliquait l'image centrale.
  - MD5 : JPG `4f03b93d2c38237d85a99f6b8aef1940` (817 206 o), PNG `6fe191bd6eedcf7bef5a8ba0c56c177a` (3 387 708 o)
- **v3** — `carte_nation_sylve_v3.*` : 16:9 en **2560×1440**, territoire panoramique.
  - MD5 : JPG `b0894396a6c2296e519bc4acf97acb71` (564 080 o), PNG `3f00e73abe7e9025ddbc6f8f220e6e02` (3 331 047 o)
  - Lien PNG (branche) : `.../carte_nation_sylve_v3.png`
- **v2** — `carte_nation_sylve_v2.*` : allégée façon Northgard en 1920×1080.
  - MD5 : JPG `053c1a994398f23dc090088ef175b561` (379 892 o), PNG `5b8a0df179d8d08eaa059008bfcf8246` (2 219 205 o)
- **v1 (conservée pour comparaison)** — `carte_nation_sylve_v1.*` : première version, dense.
  - MD5 : JPG `a9a8a57b5088e12271a942c77b394834` (519 120 o), PNG `a9311b3d84a07023f8b73bae659c7e88` (2 795 886 o)
- `carte_nation_sylve_core.jpg` : noyau brut 1184×896 de la scène retenue (v12), conservé
  comme source d'édition (URL raw stable).

Après merge sur `main`, remplacer la branche par `main` dans les URL raw.

- Génération : gen-image, 2026-11-06, puis reformatage — v1/v2 : 1920×1080, v3 : 2560×1440,
  v4 : 2340×1080 (miroir), **v5 : 2340×1080 par recadrage 19,5:9 du contenu réel (aucun ajout)**
- Fichiers source ici : `carte_nation_sylve_v1.*.b64` … `carte_nation_sylve_v5.*.b64` et
  `carte_nation_sylve_core.jpg.b64` (base64)

## Pourquoi un .b64 ?

Voir `Examples/foret_feerique/README.md` : le connecteur GitHub applique un encodage UTF-8
qui corrompt les fichiers binaires. Le JPEG/PNG est donc stocké en base64 texte, transporté
et vérifié intégralement. La GitHub Action `.github/workflows/decode-examples-b64.yml` décode
automatiquement tout `.b64` poussé dans `Examples/` (push sur `main`).

## Décoder le JPG / le PNG (v1 à v5)

Linux / macOS / Git Bash :

    base64 -d carte_nation_sylve_v5.jpg.b64 > carte_nation_sylve_v5.jpg
    base64 -d carte_nation_sylve_v5.png.b64 > carte_nation_sylve_v5.png

Vérifier : `md5sum carte_nation_sylve_v5.jpg` → `114d30fc69c5db63c6d43f8251bb6304`,
`md5sum carte_nation_sylve_v5.png` → `d48547834b0074133d6647bde538aaf9`
(mêmes commandes avec `_v1` … `_v4` pour les autres versions).

## Contenu de la carte (v5, retenue — plein écran S23+ 2340×1080, contenu 100 % réel)

- **4 bâtiments-donjons, repères autonomes bien séparés** (aucun chevauchement) :
  haut gauche : arbre creux géant à la porte dorée lumineuse et racines apparentes ;
  bas gauche : ruines de pierre moussues avec ancienne arche et lianes ; haut droite :
  grotte derrière la cascade, cristaux turquoise lumineux ; bas droite : temple ancien
  à moitié englouti par les racines et les champignons
- **Centre (donjon final, point focal)** : sanctuaire de l'Arbre-Monde / citadelle en ruine
  sur un plateau surélevé, grand escalier, runes lumineuses, rayon de lumière magique
- Chemins de terre larges et propres reliant chaque bâtiment-donjon au centre, 2 ponts de
  bois, 3–4 lampadaires
- Grandes prairies ouvertes dominantes ; forêt en **quelques îlots espacés** (canopées
  rondes en plusieurs verts, quelques arbres or automnal et à fleurs roses) ; accessoires
  minimaux
- Rivière traversant la carte, lac et cascade depuis une falaise : eau turquoise claire,
  écume douce, reflets, nénuphars
- Bâtiments peu nombreux et espacés, entourés d'espace vide : petit village sylvestre
  (toits de chaume/mousse), 2 maisons perchées, moulin à eau, tour de guet en pierre,
  petit sanctuaire, campement (2 tentes + feu de camp), ponton de bois, marché de 2 étals ;
  fenêtres chaudes allumées, quelques lanternes, bannières à l'emblème de feuille
- Image **2340×1080 (19,5:9) 100 % contenu peint bord à bord** : recadrage + upscale
  uniquement — pas de miroir, pas de flou, pas de bandes ajoutées ; netteté conservée
- Relief : falaises, plateau central en terrasses, escaliers, rampes ; ombres portées douces
  et occlusion ambiante ; flancs rocheux de l'île avec mousse et racines pendantes ; brume
  douce aux bords de l'île
- Lumière : soleil doux de l'après-midi en haut à gauche, contre-jour doré sur les feuilles,
  quelques rayons à travers la canopée, pollen / lucioles / particules magiques
- Palette : verts émeraude et mousse, bruns chauds, eau teal douce, jaune doré et touches
  de magie rose/violet
- Aucun texte, UI, personnage, logo ou watermark

(v1 : dense ; v2 : 1920×1080 aérée ; v3 : 2560×1440 panoramique ; v4 : 2340×1080 avec miroir
latéral — voir `carte_nation_sylve_v1…v4.*`)
