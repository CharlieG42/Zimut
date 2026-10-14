# Zimut — Améliorations V5 : rendu de la scène façon Waven + HUD

Références : captures Zimut/Waven, île de forêt stylisée (souches, rondins, passerelle) et plateau
« Forêt » avec ruines, rivière, champignons, végétation dense.

## Décor de contour de l'aire de bataille (nouveau)
* **`BattleScenery.gd`** — l'île est bordée sur ses deux bords arrière d'un **rebord surélevé à deux terrasses**
  (blocs avec lèvre de gazon festonnée, faces éclairées/ombrées, strates et cailloux), façon plateau de Waven.
  Silhouette irrégulière (terrasse haute présente à ~70 %), générée à partir d'une graine = n° du combat
  (le décor est stable pour un combat donné et varie d'un combat à l'autre).
* **Décor posé sur le rebord, par biome** :
  * *Forêt* : clôtures en bois le long des bords, haies fleuries, roseaux/feuilles hautes, fleurs, grands arbres,
    souches, piles de rondins, champignons, murets en ruine, menhir à rune, blé doré, tonneaux ;
    **arche en pierre en ruine** au fond ; **rivière** qui court sur le rebord gauche et **tombe en cascade**
    (eau animée, écume, embruns).
  * *Montagne* : pins enneigés, rochers à neige, cristaux de glace, piquets, congères, rondins.
  * *Désert* : cactus, piliers de grès, palmiers, herbes sèches, ossements, jarres, rochers.
  * *Donjon* : piliers, torches à flamme vacillante, caisses, bannières, gravats, chaînes.
  * Les herbes hautes, blé, arbres et haies **se balancent** doucement ; ombres douces portées vers la droite.
* **Falaise prolongée** sous l'île (strates, bas déchiqueté, pierres encastrées, racines), **brume** et ombre sur l'eau.
* **`SceneryOver.gd`** — lèvre de l'île **devant** les falaises : touffes d'herbe (neige / sable / mousse selon le biome),
  fleurs, lianes qui se balancent (glaçons, racines, chaînes ailleurs).
* **`SceneryAmbient.gd`** — lucioles (forêt), neige (montagne), poussière chaude (désert), braises (donjon).
* **`BackdropFx.gd`** — nouveau fond : lumière douce, **nuages qui dérivent**, **petites îles flottantes** lointaines
  (avec arbres/cactus/pins/ruines) teintées par la brume, surface de l'eau avec reflets, poussières lumineuses.
  Remplace les montagnes plates et les bouquets ronds sur les côtés (ancien cadre de `ForestAmbience`
  désactivé via `DRAW_FRAME = false`, ses lucioles/feuilles sont conservées).
* **Caméra** légèrement reculée (zoom 1,38 → 1,18) pour voir tout le rebord.

## HUD
* **Cartes de sorts** : médaillon d'élément à gauche (flamme, glace, éclair, poison, ombre, soleil/croix, feuille, roche,
  goutte, étoile arcane, épée), **gemmes hexagonales** PA (bleue, rouge si non payable) en haut à gauche et PM
  (verte) en haut à droite si le sort en coûte, **pastille dorée de portée** en bas à droite avec légende
  (« Portée » / « Sur soi »), nom sur 2 lignes max (plus de troncature), puces ★ niveau de sort, zone, lancers restants,
  touche ; halo doré quand le sort est sélectionné, voile sombre quand il est indisponible. Panneau de colonne allégé.
* **Vignette du personnage actif** : grand portrait encadré (halo à la couleur de l'équipe), **badge de niveau**,
  nom + classe, **barre de PV épaisse** (graduations, vert → orange → rouge), **effets en cours avec durée**,
  **gemmes hexagonales PA / PM** et bandeau « TOUR n · À vous / Adverse ».

## Corrections
* `Combat.summon_spells` : `String(int)` n'existe pas en Godot 4.7 → erreur à l'exécution pour les invocations
  à dégâts chiffrés ; corrigé.
* `tests/test_summons.gd` : lancé trop tôt (autoloads absents) → exécution différée. Trois vérifications de ce test
  échouent déjà dans ta version (Buisson « buff défense », Balise « se parse en invocation » / « 3 balises posées ») :
  non modifiées.

## Tests et outils
`tests/test_scenery.gd` (4 biomes, déterminisme, arche et rivière de la forêt) ; captures : `tests/shot_battle.gd`
(`-- /tmp/x 1 manual <victoires>` pour choisir le biome), `tests/shot_ui.gd`.
