# Zimut — Mode « Cartes tactiques » (croisement MTG Arena × Krosmaga)

> Document de design et d'architecture pour un nouveau mode de jeu.
> Statut : **décisions Q1–Q5 actées — prêt pour la phase 0 (prototype pygame)**.
> Références : MTG Arena (jeu de cartes : deck, pioche, main, ressource qui croît, PV de vie) × Krosmaga (plateau tactique : grille, PA/PM, positionnement, initiative).

## 1. Pitch

Un duel sur la grille tactique existante, mais où les actions du héros ne viennent plus d'une barre de sorts fixe : le joueur construit un **deck de cartes**, en pioche une **main**, et joue ses cartes en payant leur coût en **PA/PM** — l'économie du tour fait office de « mana ». Les cartes invoquent des unités sur la grille (qui agissent immédiatement avec les PA/PM restants du héros, décision Q4) ou lancent des sorts ciblés sur la grille. Victoire quand les PV du héros adverse tombent à 0.

En v1, on vise le plus petit produit viable : **« le combat tactique actuel, mais piloté par un deck de cartes »**.

## 2. Contrat de conception (hérité du chantier des modes)

- Le mode a sa propre entrée **« Cartes tactiques »** dans « Mes Parties » (décision Q5), tout en respectant le contrat des modes (voir `CHANTIER_MODES_PROGRESSION_ET_UI.md`) : chaque mode reste autonome et partage la sauvegarde commune.
- L'état du duel (deck, main, pioche, défausse) est **local au combat** ; seules les récompenses de fin de duel passent par `ProgressionManager` et la sauvegarde commune.
- On ne touche pas aux règles des autres modes : tout le comportement cartes est encapsulé derrière un flag de mode (`battle_mode == "cards"`).

## 3. Règles v1 (« Wakfu avec deck »)

### 3.1 Composants

| Composant | Règle v1 |
|---|---|
| Deck | 20 cartes, construit à l'avance (deck fixe de test en phase 1) |
| Main de départ | 5 cartes |
| Pioche | 1 carte au début de chaque tour du héros |
| Main max | 7 cartes (au-delà, la carte piochée est défaussée) |
| Ressource | PA/PM du héros uniquement — pas de mana séparé (décision Q1) |
| Vie | PV du héros = total de vie, comme un combat classique |
| Victoire | PV du héros adverse à 0 (condition de victoire existante) |

### 3.2 Types de cartes

| Type | Effet | Source de données |
|---|---|---|
| `Invocation` | Pose une unité sur une case libre de la zone de départ (max 3 actives, règle existante) ; l'unité **agit immédiatement** avec les PA/PM restants du héros (décision Q4) | `data/invocations.txt` |
| `Sort` | Lance un sort sur une cible de la grille (dégâts, soin, buff, debuff, déplacement) | `data/sorts.txt` |
| `Objet` | Buff permanent sur le héros ou une invocation (phase 2, optionnel) | nouveau |

### 3.3 Déroulement d'un tour du héros (mode cartes)

1. `_begin_turn(e)` existant : reset PA/PM, statuts, etc. (`GameManager.gd:1197`).
2. **Nouveau** : piocher 1 carte (main + pioche du deck).
3. Le joueur sélectionne une carte de sa main → le ciblage sur la grille réutilise `validate_cast` / `spell_range_cells` / `get_aoe_cells` existants (`GameManager.gd:1541-1691`).
4. Jouer la carte appelle `cast_spell(caster, spell, cell)` (`GameManager.gd:1733`) qui déduit déjà PA/PM et résout l'effet, y compris `_resolve_summon` (`GameManager.gd:2142`) pour les invocations ; puis la carte part en **défausse**.
5. **Invocation immédiate (décision Q4)** : une carte `Invocation` pose l'unité, qui peut agir **tout de suite** en dépensant les PA/PM **restants du héros**. Elle ne reçoit pas de tour propre pendant la manche en cours ; elle rejoint l'ordre d'initiative (`turn_order`) au round suivant.
6. Le héros n'a **plus sa barre de sorts de classe** en mode cartes (décision Q2) : seules les cartes de la main sont jouables.

### 3.4 Adversaire

IA avec son propre deck (deck fixe ou pioché parmi les cartes disponibles), qui joue ses cartes via une extension de `TurnManager.plan(e)` en s'appuyant sur `_score_cast` / `_score_summon` existants (`TurnManager.gd:141,290`).

## 4. Données

Nouveau fichier `prototype/zimut/data/cartes.txt` (CSV, même format que les autres fichiers `data/*.txt`) :

| Colonne | Description | Exemple |
|---|---|---|
| Nom | Nom de la carte | Loup spectral |
| Type | `Invocation` / `Sort` / `Objet` | Invocation |
| Reference | Nom dans `invocations.txt` ou `sorts.txt` (+ classe) | Loup Spectral |
| Cout_PA | Coût en PA du héros | 3 |
| Cout_PM | Coût en PM du héros | 0 |
| Portee | Portée de pose/ciblage en cases | 4 |
| Niveau_requis | Niveau du héros pour jouer la carte | 5 |
| Description | Texte affiché sur la carte | Invoque un loup spectral |

Un deck est simplement une liste de noms de cartes (ex. `data/decks.txt` : `Nom_deck;carte1,carte2,...`), stockée dans la sauvegarde comme les builds existants (`Builds.gd`).

## 5. Architecture (fichiers concrets)

### 5.1 Nouveaux fichiers

| Fichier | Rôle |
|---|---|
| `scripts/CardDeck.gd` | `class_name CardDeck` : deck, pioche, main, défausse. Fonctions : `shuffle()`, `draw(n)`, `play(card)`, `discard(card)`, `hand()`, `is_empty()`. Données pures, testable sans scène. |
| `scripts/CardButton.gd` | Miroir de `SpellButton.gd` : bouton de carte dans la main (icône, coût PA/PM, nom). |
| `data/cartes.txt`, `data/decks.txt` | Données cartes et decks. |
| `tests/` | Tests unitaires GDScript de `CardDeck` (pioche, main max, défausse, deck vide → fatigue/PV du héros). |

### 5.2 Fichiers modifiés (hooks minimaux)

| Fichier | Changement |
|---|---|
| `scripts/DataLoader.gd` | Nouveau `kind` « cartes » : `_load_csv(...)` + `get_cards_data()` / `get_deck_cards(name)`, sur le modèle de `get_spells_for_class` (`DataLoader.gd:168`). |
| `scripts/GameManager.gd` | Flag `battle_mode`. Dans `_begin_turn(e)` : si mode cartes et `e.entity_type == "Player"`, piocher 1 carte. Nouvelle fonction `play_card(hero, card, cell)` : vérifie `can_afford`, convertit la carte en `spell` (Dictionary existant), appelle `cast_spell`, puis retire la carte de la main → défausse. Réutilise tel quel `_resolve_summon`, `summons_of` (cap 3, `GameManager.gd:1604`). Pour une carte `Invocation` (Q4), l'unité posée peut agir immédiatement en dépensant le pool PA/PM restant du héros jusqu'à la fin du tour. |
| `scripts/UIManager.gd` | Panneau « main » en bas de l'écran (sur le modèle du panneau de sorts, `UIManager.gd:1251`) listant les `CardButton` ; sélection de carte → mode ciblage grille existant (`_on_spell_button_selected`, `UIManager.gd:2535`). En mode cartes, le panneau de sorts de classe est masqué. |
| `scripts/TurnManager.gd` | Si l'entité IA a une main de cartes : choisir une carte (score `_score_cast` / `_score_summon`) puis appeler `play_card` ; sinon comportement actuel. |
| `scripts/GridManager.gd` | Réutilise `show_start_zones()` (`GridManager.gd:77`) comme zone de pose des invocations ; aucun changement prévu en v1. |
| Menu / « Mes Parties » | Entrée dédiée **« Cartes tactiques »** (décision Q5) qui lance `start_battle()` avec `battle_mode = "cards"` et un deck choisi. |
| `prototype/main.py` | Prototype pygame des règles (phase 0) avant le portage Godot. |

### 5.3 Flux d'une carte jouée

```
CardButton (main) → UIManager sélectionne la carte
  → GameManager.play_card(hero, card, cell)
      → can_afford(hero, spell)          (PA/PM, GameManager.gd:1541)
      → cast_spell(hero, spell, cell)    (déduit PA/PM + effet, GameManager.gd:1733)
          → _resolve_summon(...) pour une Invocation (GameManager.gd:2142)
      → CardDeck : main.remove(card), defausse.add(card)
  → UIManager rafraîchit la main + les PA/PM restants
```

Note (Q4) : après une carte `Invocation`, l'unité posée est jouable immédiatement avec les PA/PM restants du héros.

## 6. Phases de livraison

1. **Phase 0 — règles en prototype** : porter les règles v1 dans `prototype/main.py` (pygame) pour valider pioche, coûts PA/PM, pose d'invocation et victoire en quelques sessions de test.
2. **Phase 1 — mode jouable vs IA** : `cartes.txt` + `CardDeck.gd` + `DataLoader` + panneau main (`CardButton.gd`) + hooks `GameManager` + IA `TurnManager` qui joue des cartes. Un deck de test fixe pour chaque camp. Tests unitaires `CardDeck`.
3. **Phase 2 — collection et méta** : écran de construction de deck, plusieurs decks déblocables via `ProgressionManager`, cartes `Objet`, match en best-of-3, équilibrage data-driven.
4. **Phase 3 — hors v1** : draft, PvP réseau, saison/classé.

## 7. Forces, faiblesses et risques

| Aspect | Évaluation | Mitigation |
|---|---|---|
| Réutilisation du moteur | Force : grille, PA/PM, invocations, sorts, IA existent déjà | Hooks minimes listés en 5.2 |
| Rejouabilité | Force : decks = méta et variété, là où le tactique seul s'use | Decks déblocables en phase 2 |
| Double ressource | Risque : une carte coûte du PA et l'invocation pourrait sembler avoir ses propres PA/PM | Décision Q1 : économie unique (PA/PM = mana) ; mana snowball seulement en v2 si le test le demande |
| Aléa de la pioche | Risque : tension avec l'esprit tactique déterministe | Pioche de 1/tour + main de 5 + main max 7 ; mulligan simple en phase 2 |
| Équilibrage | Risque : courbe de coût, tempo, removal — difficile à l'aveugle | Tout est data (`cartes.txt`) ; simulations IA vs IA automatisées pour valider |
| IA | Risque : évaluer carte + position est coûteux à coder | Réutilise `_score_cast` / `_score_summon` / `_best_move_then_cast` existants |
| UI | Risque : main + grille + journal = écran chargé (déjà tendu à 1200×700 dans le prototype) | Panneau main repliable, cartes compactes type `SpellButton`, panneau sorts de classe masqué en mode cartes |
| Scope | Risque : dérive vers un TCG complet | MVP strict de la phase 1 ; PvP/draft exclus du périmètre v1 |

## 8. Décisions actées

| Question | Décision | Conséquence dans le design |
|---|---|---|
| Q1 — Économie | **A : PA/PM unique** | Les cartes coûtent les PA/PM du héros ; pas de mana séparé. Le mana qui croît (+1/tour) reste une option v2, à tester seulement si la phase 0 le réclame. |
| Q2 — Sorts de classe du héros | **A : remplacés par les cartes** | En mode cartes, le panneau de sorts de classe est masqué ; seules les cartes de la main sont jouables par le héros. |
| Q3 — Tailles | **A : deck 20 / main 5 / pioche 1** | Main de départ 5, pioche 1 carte au début de chaque tour du héros, main max 7. Chiffres de départ, ajustables en équilibrage. |
| Q4 — Invocation invoquée | **B : agit immédiatement** | L'unité posée dépense les PA/PM restants du héros dans la foulée (attaques, sorts, déplacement) ; elle rejoint `turn_order` au round suivant, sans tour propre à la manche en cours. |
| Q5 — Nom et intégration | **B : entrée dédiée « Mes Parties »** | Entrée « Cartes tactiques » à part dans « Mes Parties », qui lance `start_battle()` avec `battle_mode = "cards"` et le deck choisi. |
