# Nation Sylve — carte du territoire (mode Aventure)

Carte isométrique 3/4 (angle de vue ~30–35°) du territoire flottant de la **Nation Sylve**
(faction nature / forêt féerique) pour Zimut. Style peint à la main façon **Dofus / Waven** :
cel-shading doux, contours brun foncé nets, couleurs riches mais douces, lumière chaude de
l'après-midi venant du haut à gauche, brume douce aux bords de l'île.

## Versions

- **v4 (retenue — plein écran Samsung Galaxy S23+)** — `carte_nation_sylve_v4.*` :
  **2340×1080 (19,5:9, paysage)** : l'image remplit tout l'écran, **sans bandes noires ni
  flou latéral** (extension des bords en miroir net de la brume peinte d'origine, aucun
  flou ajouté). Les **4 bâtiments-donjons des coins sont des repères autonomes bien
  séparés** (rien ne se chevauche) + sanctuaire central Arbre-Monde.
  - MD5 après décodage : JPG `4f03b93d2c38237d85a99f6b8aef1940` (817 206 octets),
    PNG `6fe191bd6eedcf7bef5a8ba0c56c177a` (3 387 708 octets)
  - Lien direct PNG (branche) : `https://raw.githubusercontent.com/CharlieG42/Zimut/vibe/nation-sylve-map-44586e/Examples/nation_sylve/carte_nation_sylve_v4.png`
- **v3** — `carte_nation_sylve_v3.*` : 16:9 en **2560×1440**, territoire panoramique étiré
  d'un bord à l'autre, esprit aéré façon Northgard.
  - MD5 : JPG `b0894396a6c2296e519bc4acf97acb71` (564 080 o), PNG `3f00e73abe7e9025ddbc6f8f220e6e02` (3 331 047 o)
  - Lien direct PNG (branche) : `https://raw.githubusercontent.com/CharlieG42/Zimut/vibe/nation-sylve-map-44586e/Examples/nation_sylve/carte_nation_sylve_v3.png`
- **v2** — `carte_nation_sylve_v2.*` : allégée façon Northgard en 1920×1080 (prairies ouvertes
  dominantes, forêt en îlots espacés, bâtiments réduits et espacés).
  - MD5 : JPG `053c1a994398f23dc090088ef175b561` (379 892 o), PNG `5b8a0df179d8d08eaa059008bfcf8246` (2 219 205 o)
  - Lien direct PNG (branche) : `https://raw.githubusercontent.com/CharlieG42/Zimut/vibe/nation-sylve-map-44586e/Examples/nation_sylve/carte_nation_sylve_v2.png`
- **v1 (conservée pour comparaison)** — `carte_nation_sylve_v1.*` : première version, plus
  dense et chargée, 1920×1080.
  - MD5 : JPG `a9a8a57b5088e12271a942c77b394834` (519 120 o), PNG `a9311b3d84a07023f8b73bae659c7e88` (2 795 886 o)
  - Lien direct PNG (branche) : `https://raw.githubusercontent.com/CharlieG42/Zimut/vibe/nation-sylve-map-44586e/Examples/nation_sylve/carte_nation_sylve_v1.png`

Après merge sur `main`, remplacer la branche par `main` dans les URL raw.

- Génération : gen-image, 2026-11-06, puis reformatage — v1/v2 : 1920×1080, v3 : 2560×1440,
  v4 : 2340×1080 (19,5:9) avec extension miroir **nette** sans flou pour v4
- Fichiers source ici : `carte_nation_sylve_v1.*.b64` … `carte_nation_sylve_v4.*.b64` (base64)

## Pourquoi un .b64 ?

Voir `Examples/foret_feerique/README.md` : le connecteur GitHub applique un encodage UTF-8
qui corrompt les fichiers binaires. Le JPEG/PNG est donc stocké en base64 texte, transporté
et vérifié intégralement. La GitHub Action `.github/workflows/decode-examples-b64.yml` décode
automatiquement tout `.b64` poussé dans `Examples/` (push sur `main`).

## Décoder le JPG / le PNG (v1 à v4)

Linux / macOS / Git Bash :

    base64 -d carte_nation_sylve_v4.jpg.b64 > carte_nation_sylve_v4.jpg
    base64 -d carte_nation_sylve_v4.png.b64 > carte_nation_sylve_v4.png

Vérifier : `md5sum carte_nation_sylve_v4.jpg` → `4f03b93d2c38237d85a99f6b8aef1940`,
`md5sum carte_nation_sylve_v4.png` → `6fe191bd6eedcf7bef5a8ba0c56c177a`
(mêmes commandes avec `_v1` / `_v2` / `_v3` pour les autres versions).

## Contenu de la carte (v4, retenue — plein écran S23+ 2340×1080)

- **4 bâtiments-donjons aux coins, repères autonomes bien séparés** (aucun chevauchement) :
  haut gauche : arbre creux géant à la porte dorée lumineuse et racines apparentes ;
  haut droite : ruines de pierre moussues avec ancienne arche et lianes ; bas gauche :
  grotte sombre derrière une cascade, cristaux turquoise lumineux ; bas droite : temple
  ancien à moitié englouti par les racines et les champignons
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
- Image **edge-to-edge 19,5:9** : aucun flou ni bande ajoutée sur les côtés (extension en
  miroir net de la brume d'origine, couture invisible vérifiée)
- Relief : falaises, plateau central en terrasses, escaliers, rampes ; ombres portées douces
  et occlusion ambiante ; flancs rocheux de l'île avec mousse et racines pendantes ; brume
  douce aux bords
- Lumière : soleil doux de l'après-midi en haut à gauche, contre-jour doré sur les feuilles,
  quelques rayons à travers la canopée, pollen / lucioles / particules magiques
- Palette : verts émeraude et mousse, bruns chauds, eau teal douce, jaune doré et touches
  de magie rose/violet
- Aucun texte, UI, personnage, logo ou watermark

(v1 : version dense ; v2 : 1920×1080 aérée ; v3 : 2560×1440 panoramique — voir les fichiers
`carte_nation_sylve_v1/v2/v3.*`)
