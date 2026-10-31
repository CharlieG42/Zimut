# V62 — Conquête : la ville illustrée, jour & nuit, événements et spécialisation

L'écran de ville (V61, `ConquestCityView`) passe des dessins vectoriels à de **vraies illustrations
par bâtiment**, avec un cycle **jour / soir / nuit**, des **événements de ville** et une
**spécialisation** au niveau Cité.

## Illustrations par bâtiment (remplacement 1:1 des SVG vectoriels)
- 605 illustrations générées dans `prototype/zimut/assets/ui/conquest/city/<biome>/` par
  `tools/gen_city_art.py` : par biome (11 Nations), par bâtiment (`hall_1..5`, `barracks/residence/
  scierie/mine/tannerie/cabane/verger/muraille_1..3`), les 7 formes de Merveille, 7 décors
  (arbre, rocher, puits, étal, lanterne, charrette, feu) et 3 ciels (jour / soir / nuit).
- Chaque sprite est ancré à son pied **(130, 200)** de son canvas 260×220 (voir
  `city_layout.json`) : le jeu pose le bâtiment exactement sur sa parcelle.
- **Repli automatique** : si un fichier manque, le dessin vectoriel V61 reprend la main
  (`_draw_plot` teste la texture avant de dessiner).
- Pour passer aux vraies illustrations (générateur d'images) : prompts prêts à l'emploi dans
  `prompts_sprites/villes/` (style verrouillé Ankama/Dofus, palettes par biome, ancrage 130,200,
  fond transparent) — déposer les PNG à la place des SVG (mêmes noms de base).

## Jour, soir, nuit
- Trois ciels par biome (`sky_jour|soir|nuit`) ; la ville a un voile nocturne bleu, le sol
  s'assombrit, le soir teinte orange.
- **La nuit (et le soir), les fenêtres s'allument** (rects ambrés sur chaque bâtiment construit)
  et les **lanternes de la place brillent** avec halos vacillants (`_draw_night_glows`).
- Bouton **☀ Jour / 🌇 Soir / 🌙 Nuit** dans la barre de l'écran de ville : décale l'heure
  manuellement (`ConquestSystem.cycle_time_of_day`, sauvegardé dans `conquest.city_time`).
  Sans choix manuel, l'heure tourne automatiquement avec les batailles (`time_of_day`).

## Événements de ville (décor + annonce dans le conseil)
- **🎉 Fête** : étals de marché + feu de joie sur la place.
- **🔥 Incendie** : flammes et fumée noire sur l'hôtel de ville.
- **🛒 Marchand de passage** : charrette dressée près de la place.
- Déclenchement à l'entrée dans la ville (25 %, `ConquestSystem.maybe_city_event`),
  persistant jusqu'à expiration (`tick_city_events` à chaque victoire) ; affiché dans le
  panneau de droite de l'écran de ville.

## Spécialisation au niveau Cité (niveau 3)
- Choix **⚑ Cité militaire** (+2 défense) ou **⚑ Cité marchande** (+3 or par victoire),
  proposé dans le conseil dès que la ville atteint la Cité (`ConquestSystem.choose_spec`,
  `CITY_SPECS`) ; un seul choix par ville, journalisé.
- **Allure de la ville** : militaire = décors de rochers/pieux plus sobres ; marchande = la place
  se peuple d'étals et de charrettes (`_draw_decorations` selon `spec`).
- Bonus intégrés à `ConquestSystem.defense` et `city_income`, gelés si la ville est pillée/ruinée.

## Fichiers
- `scripts/ConquestCityView.gd` : rendu par sprites (ancrage, voile jour/nuit, halos, décors,
  événements) + repli vectoriel V61 intact.
- `scripts/ConquestSystem.gd` : `DAY_CYCLE`, `time_of_day` / `cycle_time_of_day` /
  `effective_time`, `CITY_EVENTS` / `maybe_city_event` / `tick_city_events`, `CITY_SPECS` /
  `choose_spec` / `spec_bonus` ; bonus dans `defense` et `city_income`.
- `scripts/CityScreenUI.gd` : bouton jour/nuit, remplissage de la vue (heure, événement,
  spécialisation), panneau de choix de spécialisation et ligne d'événement.
- `tools/gen_city_art.py` + `assets/ui/conquest/city/**` + `prompts_sprites/villes/`.
- Tests : `tests/test_conquest_v62.gd` (logique), `tests/shot_city_v62.gd` (captures).

## Sauvegarde
Nouvelles clés optionnelles dans `conquest` : `city_time {ville: 0..2}`, `city_events {ville: id}`,
`city_specs {ville: "militaire"|"marchande"}`. Rétro-compatible (toutes optionnelles).
