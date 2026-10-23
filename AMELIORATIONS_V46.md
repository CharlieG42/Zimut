# V46 — Compteur de temps de jeu par partie

## Fonctionnement
- **Autoload `PlayTimer`** (`scripts/PlayTimer.gd`, enregistré dans `project.godot`) :
  le temps ne tourne que pendant le jeu effectif. Il démarre à l'entrée dans une
  scène de jeu (combat `Main.tscn`, sélection d'équipe `TeamSelection.tscn` →
  mode **tactique** ; `AdventureMap.tscn` → **adventure** ; `ConquestMap.tscn` →
  **conquest**) et se met en pause dès qu'on revient sur un écran de menu
  (« Mes Parties », Accueil, Réglages).
- Le temps écoulé est écrit dans la sauvegarde toutes les 10 s et à chaque
  changement de scène : `playtime` (total, en secondes) et `playtime_modes`
  (`{tactique, adventure, conquest}` en secondes), via
  `ProgressionManager.add_playtime()`.
- Les anciennes parties sont migrées au chargement (`ensure_playtime`, appelé
  par `load_save` / `import_save`) : les champs manquants sont ajoutés à 0.
- Le temps de la sélection d'équipe compte dans le mode tactique (c'est la
  préparation du combat). Les écrans de menu (Mes Parties, Accueil, Réglages,
  fin de combat) sont exclus du compteur.

## Affichage dans « Mes Parties »
- **Zone de gauche** : chaque vignette de partie affiche le **temps total**
  (`⏱ 45 s`, `⏱ 12 min`, `⏱ 3 h 05`) sous les victoires.
- **Zone de droite** : sous les trois cartes de mode (Combats Tactiques,
  Aventure, Conquête), une ligne affiche le **temps par mode** (`⏱ 0 s` tant
  que le mode n'a pas été joué).
- Formats traduits en anglais (`45 s` → `45 sec`).

## Fichiers modifiés
- `scripts/PlayTimer.gd` (+ `.uid`) : autoload du compteur.
- `scripts/ProgressionManager.gd` : champs `playtime` / `playtime_modes`,
  migration, `playtime_total` / `playtime_mode` / `add_playtime` /
  `format_playtime`, `playtime` exposé dans `list_saves`.
- `scripts/SaveSlotsUI.gd` : temps total dans la vignette, temps par mode sous
  les cartes, flush à l'ouverture.
- `scripts/MainMenuUI.gd`, `scripts/TeamSelectionUI.gd`,
  `scripts/TeamSelectionManager.gd`, `scripts/AdventureMapUI.gd`,
  `scripts/ConquestMapUI.gd`, `scripts/UIManager.gd`, `scripts/SettingsUI.gd` :
  flush du timer aux changements de scène / retours menu.
- `data/i18n/en.txt` : traductions du libellé de vignette et des formats de durée.
- `tests/test_playtime.gd` : test headless (création, incrément, persistance,
  migration, timer en mémoire, formatage).
- `.github/workflows/build-android-apks.yml` : le test est exécuté en CI.
