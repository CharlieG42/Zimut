# V42 — Refactor, features, arbre de talents, timer de tour, succès contre-la-montre, builds

Toutes les améliorations V42 (octobre 2026), par thème. PRs : #126, #129, #130, #131, #132.

---

## 1. Nettoyage du code (PR #126)

- **Suppression de `SpellManager.gd`** — code mort, doublon de `GameManager.cast_spell`.
- **Suppression de `EntityManager.gd`** — relais de signaux inutile ; `Main.gd` connecte
  directement `entity_moved` / `entity_attacked` / `spell_casted` à
  `grid_manager.update_entity_display()` via un `Callable` `refresh_display`.
- **`Main.tscn`** — nœuds `SpellManager` / `EntityManager` retirés.
- **`DataLoader.gd` refactorisé** — parsing CSV générique `_load_csv(paths, kind, label)`
  partagé par les 4 types de données (classes, sorts, ennemis, items) au lieu de 4 copies.
  Tables `NUMERIC_COLS`, `_load_defaults()`, `_is_numeric_prefix()`.
- Typage explicite renforcé sur les variables publiques.

## 2. Arbre de talents PAR PERSONNAGE (PR #126 → #129)

Refonte complète : l'arbre n'est plus account-wide, il est **propre à chaque héros**.

- **Déverrouillage** : niveau **15** (`TalentTree.UNLOCK_LEVEL`).
- **Points de pouvoir** : **1 point tous les 5 niveaux** à partir du 15
  (niv 15 = 1 pt, niv 20 = 2 pts, … niv 100 = 18 pts).
- **Stockage** : `data["roster"][classe]["talents"] = {"unlocked": {id: true}, "points": n}`.
- **Migration rétroactive** : `ensure_roster` crée l'entrée talents pour les héros existants.
- **14 talents, 4 branches** (aucune restriction de séquence, coût en points) :

| Branche | Talents (coût) | Effet |
|---|---|---|
| ⚔️ Offense | Vétéran (1), Coup critique (2), Fureur (3), Maître d'armes (4) | +5/10 % dégâts, +5/10 % crit |
| 🛡️ Défense | Robuste (1), Armure (2), Résilience (3), Implacable (4) | +5/10 % PV, +5/10 % défense |
| ✨ Utilitaire | Action supp. (2), Course (2), Soigneur né (3) | +1 PA, +1 PM, +10 % soins |
| ★ Puissance | Rage intérieure (3), Aura vitale (3), Second souffle (4) | +15 % dégâts, +15 % PV +10 % soins, renaissance 25 % PV 1×/combat |

- **Application** : `ProgressionManager.member_stats()` agrège les bonus via
  `TalentTree.total_bonus()` → `talent_dmg_pct`, `talent_heal_pct`, `talent_crit_pct`,
  `talent_def_pct`, `talent_revive_pct` ; consommés par `Combat.calc_damage()` et
  `GameManager._heal_amount()`.
- **« Second souffle » fonctionnel** : `GameManager._check_deaths()` réanime le héros
  à 25 % PV, 1 fois par combat (flag `talent_revived` reset à la création).
- **UI** : onglet **TALENTS** dans la fiche personnage (`CharacterSheetUI`),
  verrouillé avant le niveau 15 (écran cadenas), grille 2×2 des branches.
- Les bonus account-wide (XP, or, ressources) ont été **retirés** — un arbre par
  personnage ne doit pas avantager les autres héros.
- `TalentTreeUI.gd` (écran séparé) supprimé au profit de l'onglet fiche perso.

## 3. Timer de tour (PR #126 → #129 → #130)

- **Durée configurable** dans Options : Désactivé / 10 s / 20 s / **30 s (défaut)** / 60 s
  (`GameSettings.TURN_TIMER_MODES`, `turn_timer_mode = 3`).
- **Par personnage** (alliés, ennemis, invocations) : démarre au début du tour,
  **termine automatiquement le tour** à l'expiration.
- Le compteur redémarre à zéro pour le personnage suivant.
- **Jauge jaune-or en pourcentage du périmètre** de la vignette rectangulaire
  (tête + PV + PA + PM) : 100 % au début, diminue de manière fluide jusqu'à 0 %.
  Piste complète en fond (alpha 0.18), jauge dorée 4 px avec pointe pulsante.
- **Compte à rebours ⏱ N** en haut à droite de la vignette.
- **Son « timer »** (3 tons) à l'expiration + fx anneau doré + burst sur le personnage.
- Implémentation : `GameManager._start_turn_timer()` (coroutine fire-and-forget,
  `ignore_time_scale=true` pour le temps réel pendant les tours IA accélérés),
  invalidation par `_epoch` ; `UIManager.StatsView._draw()` dessine la jauge.
- Géométrie validée par simulation : périmètre à 0,04 % du théorique, fermeture
  exacte à 100 %.

## 4. Succès contre-la-montre (PR #131)

Le mode « Contre-la-montre » global (Options + bonus/malus XP/or) a été **remplacé
par des succès par partie**, avec des succès dédiés aux boss.

**Nouveaux succès :**

| Succès | Condition | Récompense |
|---|---|---|
| ⚡ Sprinter | Gagner un combat en ≤ 5 tours | +2 Bois R2, +1 Cuir R2 |
| 💥 Fulgurance | Gagner en ≤ 3 tours, 3 fois | +2 Bois R3 |
| 🌪️ Tornade | Vaincre un boss en ≤ 5 tours | +2 Fer R3 |
| ⚔️ Frappe de maître | Vaincre un boss en ≤ 3 tours | +3 Magie R3, +1 Fer R3 |

(« Éclair » ≤ 3 tours, « Tueur de boss », « Chasseur de boss » conservés.)

- **Records** : `Achievements.set_min()` garde le meilleur score
  (`best_turns`, `boss_turns`) ; `Achievements.record_speed()` appelé à chaque
  victoire par `ProgressionManager.register_victory`.
- **Affichage** : ligne « ⏱ Records : X tours · Boss : Y tours » dans l'écran Succès.
- **Supprimé** : ligne « Contre-la-montre » dans Options, `SPEEDRUN_*` dans
  `GameSettings`, `speedrun_limit/success` dans `GameManager`, bonus XP/or
  conditionnels dans `register_victory`, compteur ⏱ dans la vignette.

## 5. Synergies de trio (PR #126)

8 nouveaux bonus d'équipe à **3 classes**, en complément des synergies de duo existantes :

| Trio | Nom | Effet |
|---|---|---|
| Tank + Mage + Druide | Égide arcanique | +15 % défense équipe |
| Tank + Heal + Artificier | Bastion vivant | +12 % défense équipe |
| Assassin + Chasseur + Sylvain | Meute | +12 % dégâts équipe |
| Mage + Druide + Invocateur | Cercle ancien | +15 % résistance magique équipe |
| Tank + Chasseur + Heal | Ligne de front | +10 % dégâts équipe |
| Artificier + Géomancien + Invocateur | Forge élémentaire | +12 % dégâts équipe |
| Assassin + Mage + Géomancien | Assaut mystique | +15 % dégâts équipe |
| Druide + Sylvain + Heal | Bénédiction sylvestre | +12 % résistance magique équipe |

- Application au début du combat (`GameManager.start_battle` → `Combat.add_status`).
- Affichage « ✦✦ » dans `TeamSelectionUI`.

## 6. UX/UI (PR #126)

- **Recherche texte dans l'inventaire** (`InventoryUI` : champ `LineEdit`, filtrage live).
- **Comparaison stat par stat de l'équipement** (`TeamEquipmentUI` : delta par caractéristique
  dans les tooltips, ex. « V+30 F+5 »).
- **Choix du héros « Explorateur »** dans la sélection d'équipe (PR #125, `TeamSelectionUI`).

## 7. 3 Builds par personnage (PR #132)

Nouveau module **`Builds.gd`** (`RefCounted`, `class_name`) — 3 builds nommables par héros.

**Chaque build regroupe :**
- 🛡️ **Équipement complet** (10 emplacements, mêmes règles : niveau requis, arme 2 mains/bouclier)
- ⚔ **Jusqu'à 10 sorts actifs** choisis parmi tous les sorts débloqués par niveau
  (les niveaux de sort 1-10 restent ceux du héros, partagés entre builds)
- ★ **Arbre de talents dédié** (14 talents, points indépendants)

**Stockage** (roster) :
```
data["roster"][classe]["builds"] = [{"name", "equipment", "spells", "talents"}, ...]  (max 3)
data["roster"][classe]["build_index"] = 0..2  (-1 = « équipement libre »)
data["roster"][classe]["active_spells"] = [noms]  (hors build)
```

**Fonctionnement :**
- Créer / renommer / supprimer / activer un build depuis l'onglet **BUILDS** de la fiche perso.
- **Activer** = copie équipement + sorts + talents dans le héros ; l'ancien état est
  automatiquement sauvegardé dans le build quitté.
- **État « Équipement libre »** (index -1) = comportement actuel inchangé.
- En combat, **seuls les sorts actifs** du build courant apparaissent dans la barre.
- **Migration rétroactive** : `ensure_roster` → `Builds.ensure` (builds vides,
  10 premiers sorts débloqués comme sorts actifs par défaut).

## 8. Améliorations techniques (PR #126)

- **`AssetCache.gd`** — autoload, cache centralisé de textures (évite les rechargements).
- **CI headless** — tests exécutés avant le build APK :
  `test_combat.gd` (bloquant), `test_progression.gd`, `test_talents.gd`,
  `test_timer.gd`, `test_builds.gd` (non bloquants, `timeout 60`).
- **Tests V42** :
  - `test_talents.gd` — paliers, isolation par perso, intégration `member_stats`,
    agrégation bonus, synergies trio, succès contre-la-montre.
  - `test_timer.gd` — modes 0/10/20/30/60 s, clamping, défaut 30 s.
  - `test_builds.gd` — CRUD builds, sorts actifs (limite 10), activation, talents,
    migration.

---

## Récapitulatif des PRs

| PR | Titre | Statut |
|---|---|---|
| #126 | Refactor + features + arbre de talents + timer 10 s | mergée |
| #129 | Timer 30 s + bordure vignette + talents par perso + fix écran gris | mergée |
| #130 | Jauge jaune-or du timer en % du périmètre (fluide) | ouverte |
| #131 | Contre-la-montre → succès par partie (boss inclus) | ouverte |
| #132 | 3 builds par personnage (équipement + sorts actifs + talents) | ouverte |
