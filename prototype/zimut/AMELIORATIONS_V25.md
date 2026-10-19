# V25 — Tutoriel de Gultur, pseudo, déblocage des modes, équipe, numéros d'ordre, .zimut

- **Gultur** (`scripts/Gultur.gd`) : guide dessiné en vectoriel (sprite final à brancher dans `assets/sprites/npc/gultur.png`, qui remplace automatiquement le dessin). Dialogues avec effet machine à écrire, cadre pulsant sur la cible, bouton « Passer le tutoriel ».
- **Étapes** (une fois chacune, mémorisées dans les réglages) : `intro` (récit + but : les Pierres Élémentaires) → `team` (préparation de l'équipe) → `equip` (stuff trouvé) → `lvl3` (Aventure) → `lvl5` (Conquête). L'aide du premier combat (3 bulles) reste active.
- **Options → « Relancer le tutoriel de Gultur »** remet toutes les étapes à zéro (et l'aide du premier combat).
- **Pseudo** demandé à chaque nouvelle partie (`ProgressionManager.new_game(slot, pseudo)`) ; les doublons sont autorisés.
- **Niveaux minimum** (`ProgressionManager.MODE_MIN_LEVEL`) : Tactique 1, Aventure 3, Conquête 5, selon le plus haut niveau d'un héros. Boutons grisés avec 🔒 et info-bulle.
- **Équipe** : cadre doré « ★ TON ÉQUIPE : n / 3 » avec consigne, emplacements numérotés (« Héros 1 (à choisir) »).
- **Numéros d'ordre en combat** : héros, ennemis et invocations, sur la timeline et au-dessus de la barre de vie (bleu = héros, or = ennemi, vert = invocation). Recalculés quand une unité entre dans la timeline (invocation, résurrection) ; une mort ne décale pas les numéros.
- **Import / export** : extension **`.zimut`** = fichier texte UTF-8 contenant exactement le code `ZIMUT1:<base64 du JSON gzip>` ; le préfixe porte la version du format. Export : sélecteur de fichier + copie du code ; import : fichier `.zimut` ou presse-papiers. Si le sélecteur natif est absent, le fichier va dans `user://exports/`.
- **Documents de conception** : `PIERRES_ELEMENTAIRES.md`, `HEROS_INGENIEUR.md`.
- Tests : `tests/test_tutorial.gd` ; captures : `tests/shot_tutorial.gd`.
