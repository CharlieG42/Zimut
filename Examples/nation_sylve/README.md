# Nation Sylve — carte du territoire (mode Aventure)

Carte isométrique 3/4 (angle de vue ~30–35°) du territoire flottant de la **Nation Sylve**
(faction nature / forêt féerique) pour Zimut. Style peint à la main façon **Dofus / Waven** :
cel-shading doux, contours brun foncé nets, couleurs riches mais douces, lumière chaude de
l'après-midi venant du haut à gauche, brume douce aux bords de l'île. Format 16:9, 1920×1080.

## Versions

- **v2 (retenue)** — `carte_nation_sylve_v2.*` : version **allégée et étendue**, inspirée de
  **Northgard** : grandes prairies ouvertes dominantes, forêt en quelques îlots espacés
  (~11 % de canopée contre ~16 % en v1), bâtiments réduits et bien espacés, accessoires
  minimaux, chemins larges et propres. Les 5 entrées de donjon restent parfaitement lisibles.
  - MD5 après décodage : JPG `053c1a994398f23dc090088ef175b561` (379 892 octets),
    PNG `5b8a0df179d8d08eaa059008bfcf8246` (2 219 205 octets)
  - Lien direct PNG (branche) : `https://raw.githubusercontent.com/CharlieG42/Zimut/vibe/nation-sylve-map-44586e/Examples/nation_sylve/carte_nation_sylve_v2.png`
- **v1 (conservée pour comparaison)** — `carte_nation_sylve_v1.*` : première version, plus
  dense et chargée.
  - MD5 après décodage : JPG `a9a8a57b5088e12271a942c77b394834` (519 120 octets),
    PNG `a9311b3d84a07023f8b73bae659c7e88` (2 795 886 octets)
  - Lien direct PNG (branche) : `https://raw.githubusercontent.com/CharlieG42/Zimut/vibe/nation-sylve-map-44586e/Examples/nation_sylve/carte_nation_sylve_v1.png`

Après merge sur `main`, remplacer la branche par `main` dans les URL raw.

- Génération : gen-image, 2026-11-06, puis reformatage 16:9 1920×1080 (upscale + extension de
  brume sur les côtés, couture invisible)
- Fichiers source ici : `carte_nation_sylve_v1.jpg.b64`, `carte_nation_sylve_v1.png.b64`,
  `carte_nation_sylve_v2.jpg.b64`, `carte_nation_sylve_v2.png.b64` (base64)

## Pourquoi un .b64 ?

Voir `Examples/foret_feerique/README.md` : le connecteur GitHub applique un encodage UTF-8
qui corrompt les fichiers binaires. Le JPEG est donc stocké en base64 texte, transporté et
vérifié intégralement. La GitHub Action `.github/workflows/decode-examples-b64.yml` décode
automatiquement tout `.b64` poussé dans `Examples/` (push sur `main`).

## Décoder le JPG / le PNG (v1 et v2)

Linux / macOS / Git Bash :

    base64 -d carte_nation_sylve_v2.jpg.b64 > carte_nation_sylve_v2.jpg
    base64 -d carte_nation_sylve_v2.png.b64 > carte_nation_sylve_v2.png

Vérifier : `md5sum carte_nation_sylve_v2.jpg` → `053c1a994398f23dc090088ef175b561`,
`md5sum carte_nation_sylve_v2.png` → `5b8a0df179d8d08eaa059008bfcf8246`
(mêmes commandes avec `_v1` pour la v1).

## Contenu de la carte (v2, retenue)

- **5 entrées de donjon**, chacune dans sa propre zone ouverte et bien lisible :
  1. Haut gauche : arbre creux géant à la porte dorée lumineuse et racines apparentes
  2. Haut droite : ruines de pierre moussues avec ancienne arche et lianes
  3. Bas gauche : grotte derrière une cascade, cristaux turquoise lumineux
  4. Bas droite : temple ancien à moitié englouti par les racines et les champignons
  5. **Centre (donjon final, point focal)** : sanctuaire de l'Arbre-Monde / citadelle en
     ruine sur un plateau surélevé, grand escalier, runes lumineuses, rayon de lumière magique
- Chemins de terre larges et propres reliant les 4 coins au centre, 2 ponts de bois,
  3–4 lampadaires
- Grandes prairies ouvertes dominantes ; forêt en **quelques îlots espacés** (canopées
  rondes en plusieurs verts, quelques arbres or automnal et à fleurs roses) ; accessoires
  minimaux
- Rivière traversant la carte, lac et cascade depuis une falaise : eau turquoise claire,
  écume douce, reflets, nénuphars
- Bâtiments peu nombreux et espacés, entourés d'espace vide : petit village sylvestre
  (toits de chaume/mousse), 2 maisons perchées, moulin à eau, tour de guet en pierre,
  petit sanctuaire, campement (2 tentes + feu de camp), ponton de bois, marché de 2
  étals ; fenêtres chaudes allumées, quelques lanternes, bannières à l'emblème de feuille
- Relief : falaises, plateau central en terrasses, escaliers, rampes ; ombres portées
  douces et occlusion ambiante ; flancs rocheux de l'île avec mousse et racines pendantes ;
  brume douce aux bords
- Lumière : soleil doux de l'après-midi en haut à gauche, contre-jour doré, quelques
  rayons à travers la canopée, particules flottantes
- Palette : verts émeraude et mousse, bruns chauds, eau teal douce, jaune doré et touches
  de magie rose/violet
- Aucun texte, UI, personnage, logo ou watermark

(v1 : même contenu mais forêt dense ~40 %, nombreux accessoires et bâtiments — voir
`carte_nation_sylve_v1.*`)
