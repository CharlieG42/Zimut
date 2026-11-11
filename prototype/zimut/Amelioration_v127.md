# Amélioration graphique du mode Aventure — plan V127 et suivantes

Objectif : améliorer nettement le rendu des deux vues du mode Aventure, la **carte Diorama 2D** et le
**monde 3D**, sans dégrader la fluidité sur téléphone (référence : Galaxy S23+).

Ce document décrit ce que je compte faire, dans quel ordre, et comment on jugera le résultat.
Chaque lot est une PR séparée, testable sur téléphone. Ordre validé : lot 1, puis lot 4, puis le reste ;
la Nation des Brumes passe après.

## Règles que je m'impose

- **Fluidité d'abord.** La marche sur la carte Diorama coûte déjà ~16 ms de scène et ~25 ms de rendu
  (≈ 40 i/s). Aucun lot ne doit faire baisser ce chiffre ; chaque PR donne les mesures avant / après
  avec le compteur à 3 lignes (V121).
- **Qualité réglable.** Tout effet nouveau respecte le réglage de qualité existant (`GfxQuality`) :
  absent en « Économie », complet en qualité haute.
- **Assets libres uniquement** (CC0 : Kenney, Quaternius, KayKit). Aucune image générée par IA.
- **Mémoire.** Pas d'augmentation de la mémoire vidéo des cartes Diorama (les tuiles gardent leur taille).
- **Jugement sur pièces.** Chaque PR contient des captures avant / après aux mêmes endroits.

## État des lieux

### Carte Diorama 2D (Sylve, Brasier)

Ce qui est bon : le décor pré-rendu (relief, ombres, lumière peinte) a du caractère, les donjons ont de
vrais bâtiments, l'île flottante est lisible.

Ce qui manque :

1. **L'image est figée.** Rien ne bouge : ni l'eau, ni la lave, ni le feuillage, ni la lumière.
2. **Les personnages sont « posés » sur le décor.** Le héros et les monstres n'ont pas d'ombre de
   contact, ne prennent pas la teinte de la lumière du lieu, et leur filtrage (pixels nets) jure avec le
   décor peint.
3. **Pas d'atmosphère vivante.** Pas de particules (pollen, braises, lucioles), pas de rayons de
   lumière, pas de brume qui dérive.
4. **Les repères de lieux sont plats** (médaillons 2D) ; le portail est peu visible (constaté en V126).
5. **Le bord du monde et le ciel** sont un simple dégradé.

### Monde 3D (monde ouvert)

Constaté sur captures (Sylve) :

1. **Sol uniforme et très saturé** : un vert presque fluo, sans variation ni détail (pas de terre, de
   mousse, de sentiers marqués).
2. **Ciel vide et horizon abrupt** : pas de nuages, pas de lointain, le monde s'arrête net.
3. **Lumière plate** : ombres dures et noires, pas d'occlusion au pied des objets, pas de lumière de
   contre-jour.
4. **Végétation clairsemée** : touffes d'herbe isolées, qui flottent sur un sol nu.
5. **Lieux et monstres peu incarnés** : repères géométriques simples (socles, gemmes), eau et lave
   absentes ou sans animation.
6. **Lisibilité de l'interface** : textes superposés en haut de l'écran, noms de lieux qui se
   chevauchent.

## Ce que je compte faire

### Lot 1 — Diorama : la carte prend vie (V127) — FAIT

Sans retoucher les tuiles (aucun nouveau rendu des cartes) :

- **Eau animée** : reflets, creux plus sombres et écume sur la berge du lac de la Sylve.
- **Lave animée** : croûte sombre qui dérive et lueurs qui pulsent sur les coulées et le cratère du Brasier.
- **Ombres de nuages et rayons de lumière** qui glissent lentement sur l'île (fumées sombres au Brasier).
- Un seul masque basse définition par Nation (1280 × 720) ; tout est coupé en qualité « Économie ».

Écarts par rapport au plan initial :

- **Particules d'ambiance** : elles existaient déjà (feuilles et lucioles en Sylve, braises au Brasier), je
  n'y ai pas touché.
- **Vent dans le feuillage** : non fait. Déformer les tuiles demande une passe plein écran et fait
  apparaître un double des arbres découpés ; à reprendre autrement (lot 3, avec une régénération).
- **Fluidité** : non mesurée sur téléphone. À vérifier avec le compteur (3 lignes) : si le rendu perd plus
  de 1 ms, le calque « ciel » est le premier à alléger.

### Lot 2 — Diorama : personnages intégrés au décor (V130) — FAIT

- **Teinte de lumière locale** : héros et monstres prennent la couleur ambiante de leur case (carte de
  lumière 320 × 180 par Nation).
- **Sprites lissés** sur la carte Diorama.
- Les ombres de contact existaient déjà. La poussière de pas n'est pas faite.

### Lot 3 — Diorama : portail et bord du monde (V129, V131) — FAIT

- **Portail toujours visible** (V129) : dessiné devant le décor, tourbillon animé, bouton pour le montrer.
- **Portail en vraie structure** (V131) : arche de pierre, obélisques et cristaux dans le décor des deux
  Nations (cartes régénérées), vue dégagée devant.
- **Mer de nuages** qui dérive autour de l'île.
- Non fait : les repères de lieux (déjà travaillés en V114 / V119, je ne les ai pas refaits), la cascade au
  bord du monde, le moment de la journée (non tranché).

### Lot 4 — Monde 3D : sol, lumière et ciel (V128)

Le lot qui change le plus l'image :

- **Sol texturé et nuancé** : mélange herbe / terre / mousse / roche selon la pente et le bruit, sentiers
  marqués entre les lieux, couleurs désaturées et harmonisées avec la palette de la Nation.
- **Lumière** : ombres adoucies et teintées (bleutées plutôt que noires), lumière de remplissage,
  contre-jour sur les personnages, occlusion simulée au pied des arbres et rochers (disque sombre
  peu coûteux, pas d'effet plein écran).
- **Ciel** : nuages en mouvement, soleil avec halo, dégradé d'horizon ; **lointain** : silhouettes de
  collines / montagnes de la Nation et brume de distance qui fond le bord du monde.
- **Étalonnage des couleurs** par Nation (contraste, saturation, teinte des ombres).

Critère : la capture « vue de jeu » de la Sylve ne doit plus montrer d'aplat vert uniforme ni d'horizon
coupé net.

### Lot 5 — Monde 3D : végétation, eau et vie (à numéroter)

- **Herbe dense autour du joueur** (instanciée, ondulant au vent, qui s'efface avec la distance) à la
  place des touffes isolées.
- **Eau et lave** avec shader animé (reflets, écume de rive, lueur).
- **Arbres** : feuillage plus fourni, variation de taille et de teinte, vent.
- **Particules d'ambiance** par Nation, papillons / oiseaux lointains.

### Lot 6 — Monde 3D : lieux, monstres et interface (à numéroter)

- **Lieux** : repères remplacés par de petites constructions du style de la Nation (camp, coffre,
  cercle de pierres), entrées de donjon reprises des bâtiments du Diorama.
- **Monstres** : ombre de contact, aura d'état (niveau trop haut / à portée), animation d'attente.
- **Interface** : textes du haut qui ne se superposent plus, noms de lieux qui ne se chevauchent plus et
  ne s'affichent qu'à proximité, mini-carte plus lisible.

## Ordre et dépendances

| Lot | Vue | Régénération des cartes | Risque fluidité |
|---|---|---|---|
| 1 | Diorama | non (masques seulement) | faible |
| 2 | Diorama | non (carte de lumière seulement) | faible |
| 3 | Diorama | oui (tuiles du portail) | faible |
| 4 | 3D | — | moyen : à mesurer |
| 5 | 3D | — | élevé : herbe dense, réglable |
| 6 | 3D | — | faible |

Je propose de commencer par le **lot 1** (effet visible, risque faible) puis le **lot 4** (plus gros
gain côté 3D), pour que tu voies vite un résultat dans chaque vue, puis de dérouler le reste.

## Ce que ce plan ne couvre pas

- Les sprites des héros et monstres eux-mêmes (versions HD prévues plus tard de ton côté).
- La carte 2D classique (hors Diorama) et les écrans de combat.
- La Nation des Brumes : elle profitera des lots 1 à 3 dès qu'elle sera générée.

## Points à trancher avec toi

1. **Ordre** : lot 1 puis lot 4, ou tout le Diorama d'abord ?
2. **Moment de la journée** sur le Diorama : utile ou superflu ?
3. **Monde 3D** : les deux vues 3D existent (« 3D » par cases et « monde ouvert »). Je prévois de
   traiter le **monde ouvert** et de faire profiter l'autre des éléments communs (ciel, lumière, sol).
   À confirmer.

## État d'avancement (V136)

| Lot | État | Versions |
|---|---|---|
| 1 — Diorama vivant | fait | V127 |
| 2 — Personnages intégrés | fait | V130 |
| 3 — Portail, bord du monde | fait (sauf cascade et moment de la journée) | V129, V131 |
| 4 — 3D : sol, lumière, ciel | fait (sauf texture de sol détaillée et nuages animés) | V128, V134 |
| 5 — 3D : végétation, eau | herbe rase faite ; eau, lave et arbres non retouchés | V132 |
| 6 — 3D : lieux, monstres, interface | non fait : à l'examen, les lieux sont déjà de petites constructions et les monstres ont leurs modèles ; seules les étiquettes ont été allégées | V134 |
| Nation des Brumes en Diorama | faite | V136 |
| Nation des Cimes en Diorama | faite | V141 |
| Cimes en 3D : neige sur le décor, sol, herbe givrée, lumière | fait | V142 |
| Sylve, Brasier, Brumes en 3D : sol, herbe, pied des arbres, lumière | fait | V143 |
| Tactique : fond de scène par nation, cases variées (4 nations) | fait | V144 |
| Conquête : défendre une ville en personne (combat Tactique) | fait | V145 |
| Conquête : empire vivant (absence, impôts, bonus du jour, autres modes) | fait | V146 |
| Conquête : notification Android avant une offensive (export Gradle) | fait | V147 |
| Conquête : vue d'ensemble de l'empire (tableau, actions groupées) | fait | V148 |
| Conquête : écran de ville (sol par Nation, rues courbes, chantiers, arbres) | fait | V149 |

Mesures sur Galaxy S23+ (vidéos du 10 novembre) : carte Diorama 53 à 58 images par seconde ; monde 3D du
Brasier 49 à 58 images par seconde, environ 300 000 triangles et 400 à 500 dessins par image.
| Tactique : tuiles de la Sylve en 3 niveaux de détail | fait | V150 |
| Conquête : Nations unies (Bannières) et chapitres de campagne | fait | V151 |
