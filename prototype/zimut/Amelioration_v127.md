# Amélioration graphique du mode Aventure — plan V127 et suivantes

Objectif : améliorer nettement le rendu des deux vues du mode Aventure, la **carte Diorama 2D** et le
**monde 3D**, sans dégrader la fluidité sur téléphone (référence : Galaxy S23+).

Ce document décrit ce que je compte faire, dans quel ordre, et comment on jugera le résultat.
Rien n'est encore codé : chaque lot ci-dessous sera une PR séparée, testable sur téléphone.

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

### Lot 1 — Diorama : la carte prend vie (V127)

Sans retoucher les tuiles (aucun nouveau rendu, mémoire inchangée) :

- **Eau et lave animées** : un shader léger sur les zones d'eau / de lave (masque exporté par l'outil de
  génération) : reflets qui glissent, liseré d'écume sur les berges, lueur pulsée pour la lave.
- **Vent dans le feuillage** : légère ondulation des cimes d'arbres et des herbes hautes, limitée aux
  zones visibles à l'écran.
- **Particules d'ambiance par Nation** : pollen et lucioles (Sylve), braises et cendres (Brasier),
  feux follets (Brumes, plus tard). Quantité liée au réglage de qualité.
- **Rayons de lumière et ombres de nuages** qui dérivent lentement sur la carte.

Critère : sur une vidéo de 10 s sans toucher l'écran, la carte doit paraître vivante ; le compteur ne
doit pas bouger de plus de 1 ms.

### Lot 2 — Diorama : personnages intégrés au décor (V128)

- **Ombre de contact** douce sous le héros, Gligli et chaque groupe de monstres.
- **Teinte de lumière locale** : les personnages prennent la couleur ambiante du lieu (sous-bois plus
  sombre et vert, lueur orangée près de la lave), lue dans une petite carte de lumière exportée par
  l'outil.
- **Filtrage adapté** des sprites pour qu'ils ne jurent plus avec le décor peint (contour léger,
  lissage quand la carte est dézoomée).
- **Poussière de pas** et petite animation d'arrivée sur un lieu.

### Lot 3 — Diorama : lieux, portail et bord du monde (V129)

- **Portail** : vraie structure dans le décor (arche + vortex animé), dégagée comme les entrées de
  donjon. Nécessite de régénérer les tuiles concernées.
- **Repères de lieux** redessinés : médaillons avec relief, états plus lisibles (ouvert, verrouillé,
  terminé), halo au sol plutôt que colonne plate.
- **Ciel et lointain** : nuages en couches derrière l'île, cascade ou brume au bord du monde.
- **Moment de la journée** (optionnel, à valider) : teinte globale matin / jour / soir.

### Lot 4 — Monde 3D : sol, lumière et ciel (V130)

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

### Lot 5 — Monde 3D : végétation, eau et vie (V131)

- **Herbe dense autour du joueur** (instanciée, ondulant au vent, qui s'efface avec la distance) à la
  place des touffes isolées.
- **Eau et lave** avec shader animé (reflets, écume de rive, lueur).
- **Arbres** : feuillage plus fourni, variation de taille et de teinte, vent.
- **Particules d'ambiance** par Nation, papillons / oiseaux lointains.

### Lot 6 — Monde 3D : lieux, monstres et interface (V132)

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
