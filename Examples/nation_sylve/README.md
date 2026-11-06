# Nation Sylve — carte du territoire (mode Aventure)

Carte isométrique 3/4 (angle de vue ~30–35°) du territoire flottant de la **Nation Sylve**
(faction nature / forêt féerique) pour Zimut. Style peint à la main façon **Dofus / Waven** :
cel-shading doux, contours brun foncé nets, couleurs riches mais douces, lumière chaude de
l'après-midi venant du haut à gauche, brume douce aux bords de l'île. Format 16:9, 1920×1080.

- Génération : gen-image (édition v2 affinée), 2026-11-06, puis reformatage 16:9 1920×1080
- Fichier source ici : `carte_nation_sylve_v1.jpg.b64` (base64)
- MD5 attendu après décodage : `a9a8a57b5088e12271a942c77b394834` (519 120 octets)

## Pourquoi un .b64 ?

Voir `Examples/foret_feerique/README.md` : le connecteur GitHub applique un encodage UTF-8
qui corrompt les fichiers binaires. Le JPEG est donc stocké en base64 texte, transporté et
vérifié intégralement. La GitHub Action `.github/workflows/decode-examples-b64.yml` décode
automatiquement tout `.b64` poussé dans `Examples/` (push sur `main`).

## Décoder le JPG

Linux / macOS / Git Bash :

    base64 -d carte_nation_sylve_v1.jpg.b64 > carte_nation_sylve_v1.jpg

Vérifier : `md5sum carte_nation_sylve_v1.jpg` doit retourner
`a9a8a57b5088e12271a942c77b394834`.

## Contenu de la carte

- **5 entrées de donjon**, toutes lisibles et uniques :
  1. Haut gauche : arbre creux géant à la porte dorée lumineuse et racines apparentes
  2. Haut droite : ruines de pierre moussues avec ancienne arche et lianes
  3. Bas gauche : grotte derrière une cascade, cristaux turquoise lumineux
  4. Bas droite : temple ancien à moitié englouti par les racines et les champignons
  5. **Centre (donjon final, point focal)** : sanctuaire de l'Arbre-Monde / citadelle en
     ruine sur un plateau surélevé, grand escalier, runes lumineuses, rayon de lumière magique
- Chemins de terre et pavés sinueux reliant les 4 coins au centre, avec ponts de bois,
  marches de pierre et lampadaires
- Forêt dense mais lisible (~40 % de la carte) : canopées rondes et stratifiées en plusieurs
  verts, accents d'arbres or automnal et à fleurs roses ; clairières avec herbes hautes,
  fleurs, champignons, souches, troncs, rochers, buissons et feuilles mortes
- Rivière traversant la carte, lac et cascade depuis une falaise : eau turquoise claire,
  écume douce, reflets, nénuphars
- Bâtiments variés : maisons perchées sur plateformes, village sylvestre (toits de
  chaume/mousse), moulin à eau au bord de la rivière, tour de guet en pierre, petit
  sanctuaire, zone de marché, campement (tentes + feu de camp), ponton de bois ; fenêtres
  chaudes allumées, lanternes suspendues, tonneaux, caisses, enseignes et bannières à
  l'emblème de feuille
- Relief et profondeur : falaises, plateaux en terrasses, escaliers, rampes, plateformes
  surélevées et ponts ; premier plan légèrement plus grand et foncé, arrière-plan plus
  clair avec haze atmosphérique, ombres portées douces et occlusion ambiante sous les
  arbres et falaises ; flancs rocheux de l'île avec mousse et racines pendantes
- Lumière : soleil doux de l'après-midi en haut à gauche, contre-jour doré sur les
  feuilles, rayons de lumière à travers la canopée, pollen / lucioles / particules magiques
- Palette : verts émeraude et mousse, bruns chauds, eau teal douce, jaune doré et touches
  de magie rose/violet
- Aucun texte, UI, personnage, logo ou watermark
