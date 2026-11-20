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

## 9. Phase 0 — prototype pygame et résultats

Implémenté dans `prototype/main.py` : `python3 main.py --cards` (duel interactif) et `python3 main.py --simulate 30` (duel automatique headless, avec assertions d'invariants).

Mécaniques validées (décisions Q1–Q4) :

- Deck 20 / main 5 / pioche 1 par tour / main max 7 (au-delà, la carte piochée est défaussée) — invariants vérifiés par assertion : 20 cartes conservées, main ≤ 7.
- Q1 : les cartes coûtent les PA/PM du héros (`Card.can_play` + `play_card`).
- Q2 : en mode cartes, `hero.spells = []` — seule la main est jouable.
- Q4 : `play_card` sur une `Invocation` pose l'unité et la rend contrôlable immédiatement (`summon_control`) ; `summon_attack`/`summon_move` dépensent les PA/PM **restants du héros**.
- IA adverse : pioche + joue ses cartes (dégâts/soin/invocation) puis se rapproche.
- Victoire : PV du héros adverse à 0 (`check_game_over`).

Retours d'expérience du prototype :

- `data/invocations.csv` a un **encodage mixte** (en-tête UTF-8, corps latin-1) : `load_csv` lit les octets et repli sur `utf-8` avec `errors="replace"`.
- **Pioche vide** : prévoir des dégâts de fatigue (style MTG) — le prototype se contente d'un message.
- **Q4 est puissant** : jusqu'à `max_pa` frappes d'invocation par tour en dépensant le pool du héros — point d'équilibrage à surveiller.
- L'IA greedy du prototype peut rester bloquée derrière ses propres invocations — limite connue du prototype pygame, pas du moteur Godot (`TurnManager` gère déjà le déplacement tactique).

## 10. Phase 1 — intégration Godot

Implémentation livrée (branche de la PR) :

- `data/cartes.txt` (23 cartes, colonnes identiques à `sorts.txt`) + `data/decks.txt` (`Deck,Cartes`, séparateur `;`) : « Deck de test » (joueur) et « Deck de test ennemis », 20 cartes chacun.
- `scripts/CardDeck.gd` : pioche/main/défausse, `from_names` (mélange Fisher-Yates avec rng fourni, `card_uid` par instance), `draw` (main max 7 → défausse), `play_uid`. Testé par `tests/test_card_deck.gd` (inscrit en CI via `tests/ci/test_card_deck.ci`).
- `DataLoader.gd` : chargement `cartes.txt`/`decks.txt` (non bloquant), accesseurs `get_cards_data` / `get_card_by_name` / `get_deck_names` / `get_deck_cards`.
- `GameManager.gd` : `battle_mode` lu depuis la sauvegarde dans `start_battle()` ; `_init_card_decks()` ; au `_begin_turn` pioche 1 carte (sauf 1re manche) ; **`e["spells"] = main de l'entité`** (Q2 : la barre de sorts devient la main — l'UI `UIManager._rebuild_spell_bar`, les raccourcis 1-9 et le ciblage sont réutilisés tels quels) ; dans `cast_spell`, la carte jouée (`card_uid`) quitte la main → défausse. Les ennemis gardent une attaque de base en plus de leur main, donc `TurnManager` joue des cartes sans modification.
- `SaveSlotsUI.gd` (« Mes Parties ») : 5e bouton « Cartes » qui pose `battle_mode = "cards"` dans la sauvegarde puis lance `TeamSelection.tscn` comme le mode Tactique (qui remet `battle_mode = ""`) ; entrée « Cartes » ajoutée à la rangée des temps de jeu.

Écart assumé vs le prototype (Q4) : dans le moteur Godot, `_resolve_summon` insère déjà l'invocation **juste après le lanceur dans `turn_order`** (`GameManager.gd` `_resolve_summon`), avec ses propres PA/PM — l'invocation agit donc immédiatement après le héros, sans dépenser le pool du héros. C'est plus simple et cohérent avec le système d'initiative existant ; le « pool du héros » du prototype reste une option d'équilibrage v2.

Retour de test utilisateur (tuile « Cartes » lançait un combat normal) — correctif : la tuile pose **à la fois** la clé `battle_mode = "cards"` dans la sauvegarde **et** le drapeau en mémoire `GameManager.battle_mode` ; `start_battle()` donne la priorité à la clé de sauvegarde quand elle est non vide, sinon conserve le drapeau (cas où l'écriture disque échoue, ex. renommage atomique indisponible). Garde-fou : `campaign_mode != ""` (combats d'Aventure/Conquête) force `battle_mode = ""`, et `_launch_campaign_mode` efface la clé. Test de régression ajouté dans `tests/test_card_deck.gd` (`_test_battle_mode_flag`).

## 11. V402 — refonte : le mode Cartes devient un vrai JCC à voies

Le mode « Cartes tactiques » (sorts du combat tactique piochés dans un deck) est **remplacé** : il ne passe plus du tout par la grille tactique. La tuile « Cartes » de Mes Parties ouvre `scenes/CardDuel.tscn`.

**Règles** (`scripts/JccDuel.gd`, sans UI, testé en headless) :
- 4 voies ; un emplacement par voie et par camp. Une créature attaque la créature de sa voie (riposte), ou le héros si la voie est vide. Attaque manuelle, une fois par tour ; la créature posée ne peut ni attaquer ni lancer son sort ce tour-là. Déplacement d'une voie vers une voie libre voisine (compte comme l'action d'attaque).
- Héros à 20 PV, victoire quand le héros adverse tombe. Mana : 1 au premier tour, +1 par tour, max 10. Une pioche par tour (pas pour le premier joueur au 1er tour), main max 7, **fatigue** croissante si la pioche est vide.
- Chaque créature porte **un seul sort distinctif** (coût en mana, une fois par tour). Les cartes-sorts sont à usage unique. Une carte jouée (sort) ou perdue (créature morte) rejoint la **fosse** ; les jetons invoqués disparaissent.
- Effets : dégâts (cible / zone / héros), soin, bonus d'attaque, bouclier, étourdissement, poison, invocation, pioche, mana.
- IA adverse (`ai_step`) : sorts utiles, carte la plus chère jouable, attaques rentables. 24 parties IA contre IA vont toutes au bout (test).

**Cartes** (`data/cartes_jcc.txt`, 65 cartes, séparateur `|`) :
- 10 créatures de classe (Tank, Mage, Chasseur, Druide, Soigneur, Assassin, Invocateur, Sylvain, Géomancien, Artificier) : chacune a le sort de sa classe ;
- monstres communs, épiques et **14 boss légendaires** (Gobelin Roi, Troll Géant, Dragon, Tharok le Végétal, Vorkann le Givre…) ;
- 28 cartes-sorts issues des sorts des personnages ; 4 jetons d'invocation.
- Rareté : C commune, R rare, E épique, L légendaire. Un deck : 20 cartes, 2 exemplaires max (1 pour épique/légendaire), uniquement des cartes possédées.

**Collection, deck et butin** (`scripts/JccCollection.gd`, stocké dans `save["jcc"]`) : collection de départ généreuse, deck de départ valide, constructeur de deck (`CardDeckBuilder.gd`). Une victoire donne une carte ; un adversaire boss laisse sa carte légendaire 4 fois sur 10.

**Interface** : `CardDuelUI.gd` (accueil, adversaires, duel, résultat, fosse), `JccCardView.gd` (carte dessinée en vectoriel : emblèmes par effet, sprites des héros et monstres). Toucher une carte la sélectionne ; créature → toucher une voie libre ; sort ciblé → toucher la cible (liseré doré) ; sort sans cible → toucher à nouveau. Créature du plateau : barre « Attaquer / sort / ◀ ▶ ».

Tests : `tests/test_jcc.gd` (catalogue, règles, IA, collection, butin) et `tests/test_jcc_ui.gd` (duel complet par l'interface). **Non testé sur téléphone** : seuls des rendus xvfb ont été vérifiés.

## 12. V403 — plateau 4×6, déplacements (PM) et portée (PO), biome 2D, Gultur

Retour de test utilisateur après V402 : le plateau à 4 voies est remplacé par une **grille 4×6** (24 cases, `JccDuel.COLS/ROWS`), avec la gestion des déplacements façon Krosmaga.

**Règles** (`scripts/JccDuel.gd`) :
- Chaque camp a une liste d'unités positionnées (`x`, `y`). Le déploiement (« voie ») se fait sur une **case libre de sa ligne arrière** (y=5 pour le joueur, y=0 pour l'adversaire). Le héros reste hors plateau.
- **PM** (points de mouvement) : déplacement case par case en 4 directions sur les cases libres (BFS), **1 PM par case franchie**. **PO** (portée) : l'attaque touche toute unité ennemie à distance de Manhattan 1..PO, et le héros adverse si sa ligne est à portée PO (`hero_dist_to`). **PA** (points d'action) : 1 attaque **ou** 1 sort par PA.
- PA et PM sont rechargés à chaque début de tour depuis `max_pa`/`max_pm` de la carte. Une créature invoquée ce tour (`sick`) peut se déplacer mais ni attaquer ni lancer de sort.
- L'IA se déplace vers le héros adverse quand aucune cible n'est à portée.

**Cartes** (`data/cartes_jcc.txt`) : trois colonnes `PA|PM|PO` ajoutées après `PV` (PA 2 pour les légendaires sinon 1 ; PM 1 pour Tank/Géomancien/Golem sinon 2 ; PO 3 Chasseur/Sylvain/Invocateur, 2 Mage/Soigneur/Druide, 1 sinon, 2 pour les jetons). `JccCards.gd` les lit (`pa`/`pm`/`po`, défauts 1/2/1). Sur chaque carte (`JccCardView.gd`) : gemme de mana toujours visible, et badges **PA / PM / PO** lisibles (3 pastilles en mode plateau, ligne texte en mode fiche).

**Interface** (`CardDuelUI.gd`) : plateau 4×6 dessiné sur un **biome 2D stylisé** procédural (5 biomes — Forêt, Plaine, Désert, Montagne, Marais — dégradé + arbres/rochers/buissons seedés autour du plateau, grille et cadre). Cases cliquables ; barre d'actions « Attaquer (1 PA, portée PO) » puis ciblage des cases/ennemis à portée, « Sort » (1 PA + mana), déplacement en touchant une case atteignable (PM). Dans le constructeur de deck, **toute la zone des cartes capte la molette**, plus seulement la scrollbar (`CardDeckBuilder.gd`).

**Tutoriel** : Gultur explique le mode en début de duel (3 bulles enchaînées, affichées une seule fois) : règles du plateau 4×6, mana/pioche, et lecture d'une carte (PA / PM / PO / mana) — `Gultur.JCC_INTRO/JCC_BOARD/JCC_STATS` + `CardDuelUI._tutorial()`.

Tests : `tests/test_jcc.gd` (règles réécrites pour la grille : déploiement ligne arrière, PM en BFS, PO, PA attaque/sort, héros à portée, fosse) et `tests/test_jcc_ui.gd` (duel par l'interface, cases 21/22).

## 13. Audit des sorts, lisibilité du plateau, défilement tactile

Retour de test : « des sorts ne fonctionnaient pas alors que leur descriptif laissait penser qu'ils le devraient ».

**Audit** : `tests/test_jcc_sorts.gd` joue au niveau moteur chacun des 28 sorts-cartes et 33 sorts de créatures et vérifie l'effet annoncé ; `tests/test_jcc_ui_sorts.gd` joue les 61 sorts par l'interface (touchers simulés). Bug réel trouvé : une unité **étourdie pouvait encore se déplacer** (PM non remis à 0) — corrigé (`pa = pm = 0`, drapeau `frozen`).

**Causes de « sort qui ne marche pas »** : indisponibilités jamais expliquées (créature invoquée ce tour, plus de PA, mana insuffisant, unité étourdie, aucune cible) et déploiement limité à une seule ligne. Désormais :
- `JccDuel.play_block_reason / sort_block_reason / attack_block_reason` donnent la raison, affichée en rouge dans la barre d'actions quand un bouton est grisé ;
- zone de déploiement = **2 lignes proches du héros** (`deploy_rows`) ; l'invocation de jetons l'utilise aussi.

**Lisibilité** : plateau élargi (cases 280×96, `CardDuelUI.BOARD/CELL`) ; en mode plateau (`JccCardView._draw_board_body`) : illustration à gauche, nom jamais masqué, pastilles **PA / PM / PO** étiquetées (valeurs courantes, grisées à 0), puces **ATQ / PV**, gemme de mana, pastille de sort, statuts (ZZ étourdi, poison, zZ invocation).

**Constructeur de deck** : glisser n'importe où dans la zone des cartes ou du deck fait défiler (`CardDeckBuilder._drag_scroll`) ; le tap se déclenche au relâchement (`JccCardView.release_tap`) et un glissement ne sélectionne pas de carte (`tests/test_jcc_deck_scroll.gd`). **Non testé sur téléphone.**

## 14. Plateau iso (option), biomes enrichis, aides visuelles

- **Option** : Options > onglet « 🃏 Cartes » > « Plateau du mode Cartes » : *Plat* (défaut) ou *Iso (perspective 2.5D)* (`GameSettings.cards_iso`, pris en compte au duel suivant).
- **Géométrie** (`CardDuelUI._build_geometry`) : chaque case a un polygone, un centre et une échelle d'unité. En iso, plateau en trapèze (rangée lointaine à 80 % de la largeur, rangées plus hautes vers le joueur) ; les unités sont des vues `JccCardView` mises à l'échelle de leur rangée. Les cases sont des `_CellNode` (clic limité au polygone via `_has_point`).
- **Biomes** (`_BiomeBG`) : ciel dégradé, sol texturé, silhouettes d'horizon (pins, collines, dunes, pics enneigés, roseaux) et accessoires propres à chaque biome (arbres à étages, herbes et fleurs, cactus, rochers/neige, roseaux et mares) sur tout l'écran ; en iso, dalle épaisse, damier ombré en profondeur.
- **Aides** : cases à portée PO en rouge et cases de déplacement (PM) en bleu quand une unité est sélectionnée ; aperçu au-dessus des cibles (attaque : `-ATQ` et `riposte -n` ; sorts : `-n`, `+n PV`, `+n ATQ`, `ZZ`, `poison n`) ; le journal indique aussi les déplacements ; polices agrandies.
- Tests : `tests/test_jcc_iso.gd`.

## 13. V407 — habillage visuel du duel (vignette, relief du plateau, tours, effets)

Retour de test avec 2 screenshots (`Examples/Screenshot_2026111*`) : rendre le mode plus attrayant.

- **Vignette carte** (`_info_holder` 360×520 + carte 344×504 encadrée) : polices du mode « full » relevées selon la largeur (`JccCardView.gd` : nom cap 30, corps 21 px si w≥300, sous-titre, ligne PA/PM/PO, gemmes mana/ATQ/PV proportionnelles).
- **Plateau en relief** (`_BiomeBG._draw_board`) : dalle épaisse sous le plateau — mode plat : ombre + face avant + 2 côtés + poteaux aux 4 coins ; mode iso : ombre + 3 faces (épaisseur 26) + poteaux.
- **Tours des héros** (`_BiomeBG._draw_towers/_draw_tower`) : une tour crénelée par camp (ennemi derrière le haut du plateau, vous en bas), girouette aux couleurs du camp (bleu/rouge) et **portrait du héros dans la fenêtre ronde**, porte arquée, ombre au sol. Positions calculées pour les 2 modes (plat et iso).
- **Encarts et boutons** : helper `_panel_sb` (ombre portée + bordure) appliqué au journal (avec titre « Journal »), aux panneaux héros, à la fosse et à la confirmation ; `_fancy_btn` (4 états + ombre) pour **Fin du tour** (doré 32 px, 330×104), Abandonner, fosses ; socle (« tray ») sous la main ; toast en 32 px.
- **Effets de combat** : nouvelle classe interne `_FxDraw` (couche vectorielle animée) — **projectile lumineux** en arc de l'attaquant vers la victime à chaque attaque (événement `attack` + `dmg`, joueur et IA), **gerbe d'impact** (anneau + 8 particules + flash) sur dégâts/mort/invocation/sort, soin vert, secousse du panneau héros quand il est touché (`_shake_node`), chiffres flottants existants conservés.

Tests : `test_jcc.gd` et `test_jcc_ui.gd` toujours à 0 échec en headless. Maquettes de mise en page (plat + iso) vérifiées hors moteur.

## 14. V408 — plateau façon biome tactique + camps détaillés aux extrémités

Retour de test après V407 : le plateau « plat » manquait de profondeur.

**Plateau biome tactique** (`_BiomeBG` réécrit) :
- Mapping biome Cartes → nation du mode tactique (`BIOME_NATION` : Forêt→Forêt, Plaine→Vents, Désert→Désert, Montagne→Montagne, Marais→Marées) : on réutilise **les vraies tuiles de sol** (`BattleScenery.tile_tex`/`tile_variant`) et **la palette de falaise** (`BattleScenery.pal` : top_a/top_b/lip/l_*/r_*/mist).
- Sol pavé de tuiles du biome sur toute la zone sous l'horizon, assombri avec la profondeur + voile de teinte (accent de la nation).
- Cases = dalles texturées (texture déformée sur le trapèze en mode iso via `draw_set_transform_matrix`), voile damier top_a/top_b, lèvre lumineuse en haut, ombre interne en bas, bord de case marqué.
- Falaise sous le plateau (30 px) : face avant en dégradé l_b→r_b avec strates et cailloux, 2 côtés, poteaux aux 4 coins.
- **Décors sur les côtés** : vrais sprites (`assets/sprites/decor/sylve/…`, liste par biome) semés dans les bandes gauche/droite/haut/bas, triés par profondeur, échelle selon la profondeur, teintés par biome.
- Effets : brume animée (3 bandes dérivantes, ~20 ips), rayons de lumière, vignette.

**Camps aux 2 extrémités** (`_draw_camps`/`_draw_camp`) : clairière, palissade (murs) et piliers d'entrée, **tour en vrai sprite** (`decor/kenney/batiments/tour.png`) avec **girouette aux couleurs du camp** (bleu/rouge), **héros du camp en vrai sprite** (`players/<classe>.png` / sprite de l'adversaire) avec lueur d'équipe sous les pieds, et **feu de camp animé** (torche + flamme qui vacille + halo chaud). Camp ennemi en haut du plateau, vôtre en bas (positions plat + iso).

Tests : `test_jcc.gd` / `test_jcc_ui.gd` → 0 échec en headless. Maquette PIL avec les vrais sprites du dépôt pour valider la composition (sol, plateau, décors, camps).

## 15. V409 — fond uni peint et damier net du plateau

Retour de test après V408 : le pavage de tuiles identique au sol et aux cases faisait perdre le plateau.

- **Fond uni peint** : plus de tuiles répétées sous le plateau — dégradé du biome (top_a assombri) + ~46 grandes taches douces (leaf/top_b, alpha 0.05-0.11) + ligne d'horizon ; les décors sprite restent sur les côtés.
- **Damier du plateau** : cases en plein contraste (`top_a.lightened(0.10)` vs `top_b.darkened(0.22)`), texture de matière en voile très léger (alpha 0.16) uniquement, biseautage par dalle (lèvre claire haut/gauche, ombre bas/droite), bord de case marqué, et **cadre épais** autour du plateau (ombre 7 px + lèvre du biome 4 px).
- La falaise (30 px, strates, cailloux), les camps et la brume de V408 sont conservés.

Tests : `test_jcc.gd` / `test_jcc_ui.gd` → 0 échec. Maquette PIL (fond peint + damier + camps) validée.

## 16. V410 — gameplay : cases de terrain, pouvoir du héros, mulligan

Trois mécaniques ajoutées au duel (moteur `JccDuel.gd`, UI `CardDuelUI.gd`) :

- **Terrain** (`terrain[24]`, tirage seedé : 6 cases = 2 boue / 2 hauteur / 2 buisson, annoncé dans le journal) :
  - *boue* : entrer coûte **2 PM** au lieu de 1 (BFS `_path_cost`) ;
  - *hauteur* : l'unité dessus a **+1 PO** (`attack_targets`) ;
  - *buisson* : **camouflage**, l'unité dessus n'est ciblable qu'au corps à corps (distance 1).
  - Glyphes dessinés sur chaque case (`_CellNode.terrain`) ; l'IA en tient compte via `move_targets`/`attack_targets`.
- **Pouvoir du héros** : 1 fois par duel, par camp (`HERO_POWERS` : chaque classe a le sien — Mage = 4 dégâts au héros, Tank = bouclier de zone, Chasseur/Assassin/Artificier = dégâts ciblés, Heal = soin de zone, Druide/Sylvain/Géomancien = dégâts de zone, Invocateur = invocation, boss = 5 dégâts au héros). Bouton « ⚡ » à droite (colonne droite), ciblage au toucher si le pouvoir en a besoin ; l'IA l'utilise dans `ai_step` ; effet visuel : grosse gerbe dorée + secousse du panneau héros (événement `power`).
- **Mulligan** : bouton « ↺ Nouvelle main (1×) » pendant son tour : la main retourne sous la pioche et on repioché 4 cartes, une seule fois par duel.

Tests : `test_jcc.gd` (terrain déterministe, boue 2 PM, hauteur +1 PO, buisson camouflage, pouvoir 1×, mulligan 1× et 20 cartes conservées, 24 parties IA/IA) et `test_jcc_ui.gd` (6 cases de terrain affichées, boutons visibles puis cachés, pouvoir lancé par l'UI). 0 échec.

## 17. V411 — mots-clés des cartes (vol, perforation, provocation, régénération, initiative)

Nouvelle colonne `MotsCles` dans `data/cartes_jcc.txt` (séparateur `;`, ex. `vol;provocation`), parsée en `keywords` dans `JccCards.gd` et copiée sur chaque instance (`JccDuel._make_instance`). Moteur (`JccDuel.gd`) :

- **vol** : l'attaquant se soigne des dégâts réellement infligés (`attack`, cible unité ou héros).
- **perforation** : si l'attaque tue une unité, l'excédent de dégâts passe au héros adverse.
- **provocation** : si une unité ennemie à portée a provocation, `attack_targets` ne renvoie que les provocation (l'attaque y est redirigée automatiquement).
- **regeneration** : +2 PV au début du tour de son camp (`start_turn`).
- **initiative** : jamais de riposte. Correctif au passage : une cible morte ne riposte plus (pour tout le monde).

5 nouvelles cartes les utilisent : Vampire (vol, R), Bélier (perforation, C), Chevalier (provocation, R), Moine (regeneration, C), Samouraï (initiative, E). Elles entrent automatiquement dans la collection de départ et le butin (`collectible_ids`). Affichage : ligne dorée sous le type en mode fiche, pastilles colorées sur l'illustration en mode plateau (`JccCardView.gd`).

Tests : `test_jcc.gd` (bloc mots-clés : parsing, vol, mort sans riposte, perforation 30→28, provocation redirige, régénération 2→4, initiative sans riposte, riposte normale sinon) — 0 échec ; `test_jcc_ui.gd` 0 échec.

## 18. V412 — méta : plusieurs decks, défi du jour, adversaires à débloquer

Trois ajouts de progression autour du duel (`JccCollection.gd`, `CardDuelUI.gd`, `CardDeckBuilder.gd`) :

- **Plusieurs decks** (3 slots, `decks` + `active_deck` dans la sauvegarde, `j["deck"]` reste le miroir du deck actif) : onglets en haut de la colonne de droite dans le constructeur de deck, bouton « + » pour copier le deck courant dans un nouveau slot ; le duel se lance avec le deck actif.
- **Défi du jour** : un défi tiré du hash de la date (`CHALLENGES` : gagner un duel, poser 4 créatures, lancer 3 sorts, infliger 12 dégâts au héros adverse — les trois derniers en un seul duel, suivis via les stats du duel `JccDuel.side(s)["stats"]`). Affiché sur l'accueil (« Défi du jour : … (x/y) », doré si réussi) et rappelé à l'écran de résultat ; la réussite offre une carte de butin.
- **Adversaires verrouillés** : seul le premier adversaire est disponible au départ ; battre l'adversaire *i* débloque le *i+1* (`unlocked`), les cases verrouillées apparaissent grisées avec « 🔒 Battre « … » pour débloquer », et l'écran de victoire annonce « 🔓 Adversaire débloqué : … ».

Tests : `test_jcc.gd` (migration multi-decks, `deck_of`/`set_active_deck`, défi du jour stable et complétable avec récompense, `is_unlocked`/`unlock_next`) et `test_jcc_ui.gd` (victoire : butin + déblocage de l'adversaire 1 + défi du jour présent, sauvegarde relue). 0 échec.

## 19. V413 — unités en sprites sur le plateau

Les créatures posées sur la grille ne sont plus des cartes compactes mais des **sprites en pied** (nouvelle classe interne `_UnitView` dans `CardDuelUI.gd`, à la place du `JccCardView` en `board_mode`) :

- le **sprite complet de la carte** (`card["sprite"]`, image entière) est dessiné dans un carré au-dessus de la case, pieds sur le bas de la case, mis à l'échelle de la rangée (iso) ; ombre portée elliptique au sol ;
- **nom** en pastille au-dessus du sprite, **gemmes ATQ (orange) / PV (rouge)** en bas à gauche/droite de la case, **pastilles PA / PM / PO** centrées en bas (grisées si 0) ;
- **étoile de sort** (violet, vive si le sort est lançable) et **pastilles de mots-clés** en haut à droite du sprite, statuts (ZZ / poison) en haut à gauche ; voile assombrissant si l'unité a déjà agi ;
- liserés pulsants au sol : **or = sélectionnée**, **rouge = cible valide**, **vert = peut agir** ; le tap sur le sprite émet `tapped` (sélection / ciblage, comme avant).

La carte complète reste affichée en vignette à la sélection, et dans la main / la fosse. Les animations existantes (lunge d'attaque, secousse, apparition en `summon`) fonctionnent sur la nouvelle vue via `position`/`scale`.

Tests : `test_jcc_ui.gd` (l'unité posée est un `_UnitView` avec le bon sprite, le tap sur le sprite sélectionne la case). 0 échec. Maquette PIL avec les vrais sprites validée.

## 20. Équilibrage (duels plus courts, 2ᵉ joueur compensé, difficulté croissante)
Mesures par simulations IA/IA (80 parties par adversaire, deux côtés) :
- **Avant** : le 1er joueur gagnait 59 % des miroirs, ~33 tours en moyenne (58 % des parties > 30 tours, 45 tours contre le Troll Géant). Les adversaires n'étaient pas ordonnés par force (Troll Géant 90 % vs Gobelin Roi 21 %).
- **Changements** : héros à **20 PV** (au lieu de 30) pour des duels plus courts ; le **2ᵉ joueur pioche une carte de plus** au départ (5 au lieu de 4) ; decks de la Couvée de feu, du Gobelin Roi et du Troll Géant retouchés ; la Couvée de feu passe **après** le Gobelin Roi.
- **Après** : P0 ≈ 51–54 %, ~26–28 tours, force croissante Meute < Squelettes ≈ Gobelin Roi < Couvée < Troll < Dragon.
- Test de non-régression : `tests/test_jcc_balance.gd` (seuils sur l'avantage du 1er joueur, la durée moyenne et la difficulté croissante, ~8 s).
- Limite : l'IA joue les deux camps ; le ressenti humain (mobile) reste à valider.

## 21. Lot visuel : camps, biomes, aperçu de menace, aide
- Chaque adversaire a un **biome** (`biome`) et une **couleur de camp** (`accent`) dans `OPPONENTS` : Meute → Forêt, Squelettes → Marais, Gobelin Roi → Plaine, Couvée → Désert, Troll → Montagne, Dragon → Montagne.
- Chaque unité a un **anneau d'équipe** (bleu pour vous, couleur du camp pour l'ennemi) ; les 2 rangées de déploiement de chaque camp sont **teintées** ; panneau et girouette de l'adversaire à sa couleur, badge 👑 BOSS.
- **Toucher une unité ennemie** montre ses déplacements possibles (orange) et les cases qu'elle peut menacer (rose).
- Bouton **❓ Aide** en haut : légende PA/PM/PO/mana, mots-clés et couleurs du plateau.
- Test : `tests/test_jcc_visuel.gd`.

## 22. Puzzle de la semaine
- Un puzzle par semaine (3 puzzles en rotation, `JccCollection.PUZZLES`) depuis le hub : plateau, main et mana par tour imposés, l'adversaire ne joue pas, il faut abattre son héros en un nombre de tours limité (sinon défaite).
- Pas de pioche ni de fatigue ; ne compte ni dans les victoires/défaites ni dans le défi du jour. Une carte de butin est offerte à la **première** réussite de la semaine.
- Moteur : `JccDuel.setup_puzzle(def)` (`puzzle` non vide). Chaque puzzle porte sa solution scriptée, rejouée par `tests/test_jcc_puzzle.gd`.
- Pour ajouter un puzzle : une entrée dans `PUZZLES` avec sa `solution` (le test échoue si elle ne gagne pas).

## 23. Boss de chapitre
- 8 boss (`JccCollection.CHAPTER_BOSSES`), un par chapitre de la campagne de Conquête (`ConquestSystem.CHAPTERS`, même ordre), listés après les 6 adversaires (liste défilante). Débloqué quand le chapitre est accompli.
- 1re victoire sur chacun : sa carte légendaire + de l'or (100 × n° du chapitre) ; ensuite c'est un boss ordinaire (40 % de sa carte).
- Decks de 20 cartes, boss en tête, biome et couleur propres ; sprites ajoutés aux boss qui n'en avaient pas. Force mesurée en simulation de ~33 % à ~66 %.
- Test : `tests/test_jcc_chapitres.gd`.

## 25. Atelier de fusion (niveaux de cartes)
- Une carte possédée a un niveau 1 à 5 (★). Clé de collection : `id` (niveau 1) ou `id@n` (niveau n) ; les decks peuvent contenir ces clés.
- **Fusion** : 2 exemplaires du même niveau → 1 exemplaire de niveau +1 (`JccCollection.fuse`). Les decks sont réparés (la carte fusionnée remplace une carte retirée, une seule fois).
- **Bonus** (`JccCards._leveled`) : créatures +1 ATQ / +1 PV par niveau ; sorts +1 à l'effet par niveau ; coût −1 au niveau 3, −1 de plus au niveau 5 (plancher 1).
- UI : bouton « ⚗ Atelier de fusion » dans le hub (`CardFusionUI`), aperçu avant → après ; étoiles sur les cartes, ★n dans la liste du deck.
- Prévu ensuite : fortification (autres caractéristiques), butin de cartes, choix du héros.
- Test : `tests/test_jcc_fusion.gd`.
## 24. Camp adverse en pleine largeur
- Le héros adverse est désormais un **personnage posé au centre du bord haut**, devant la porte d'un **rempart sur toute la largeur** (palissade teintée par biome, bannières et torches à la couleur du camp). C'est lui qu'on touche pour le cibler ; il brille et pulse quand il est une cible valide. Sa pastille de PV est à sa gauche.
- Le haut-gauche ne garde qu'une **pastille d'infos non cliquable** (nom, main, pioche, mana, badge BOSS).
- Correctif : un pouvoir de héros à cible ne fait plus planter l'aperçu des cibles (#419).

## 27. Choix du héros
- Toute carte de héros possédée (cartes de classe `c_*`, Samouraï, cartes de boss `b_*`) peut être choisie comme héros (bouton « 🦸 Héros » du hub, `CardHeroUI`). Par défaut : la carte de la classe d'Aventure.
- Pouvoir de héros : celui de la classe de la carte ; « Frappe du boss » pour un boss. Sprite du camp : celui de la carte.
- Bonus selon la rareté (`JccDuel.HERO_BONUS`) : Commun/Rare = début de duel (+3/+4 PV, +1 mana au 1er tour, ou +1 carte de départ) ; Épique/Légendaire = par tour (soin 2 chaque tour, 1 dégât au héros adverse 1 tour sur 2, +1 mana 1 tour sur 2, pioche 1 carte 1 tour sur 3).
- Seul le joueur bénéficie du bonus pour l'instant. Test : `tests/test_jcc_heros.gd`.

## 26. Butin de cartes hors mode Cartes
- Après une victoire en combat tactique, Aventure ou Conquête (`ProgressionManager.register_victory`), `JccCollection.combat_loot` peut ajouter une carte à la collection : 30 % (40 % en Aventure), 100 % sur un boss.
- Le niveau du combat améliore les raretés ; un boss a 20 % de laisser une carte de boss. Les cartes en double servent à la fusion (§25).
- La carte obtenue s'affiche dans la fenêtre de résultat (puce « 🃏 Carte : … »). Test : `tests/test_jcc_butin.gd`.

## 29. Fortification
- Dans l'atelier (« Fusion & fortification »), une **créature** possédée (quel que soit son niveau) peut être fortifiée contre de l'or : +1 PA, +1 PM, +1 PO, ou un mot-clé (Provocation, Initiative, Régénération, Perforation, Vol). 2 fortifications maximum par carte, jamais deux fois la même, ni un mot-clé que la carte a déjà.
- Coût : 150 × (fortifications déjà posées + 1) + 50 × (niveau − 1) or ; consomme un exemplaire de la carte, qui devient une version fortifiée.
- Clé de collection : `id[@niveau][~codes]` (ex. `c_tank@3~AM`, codes triés : A=PA, M=PM, O=PO, P=provocation, I=initiative, R=régénération, F=perforation, V=vol). Une carte fortifiée ne peut plus être fusionnée.
- Les decks qui perdent l'exemplaire reçoivent la version fortifiée (une fois). Les sorts ne sont pas fortifiables. Test : `tests/test_jcc_fusion.gd`.
## 28. Équilibrage des héros et des classes
Simulation IA (même deck, 14 adversaires × 12 graines) : avant, les héros allaient de 52 % à 78 % de victoires. Après réglage : classes 61–69 %, boss/légendaires ≈ 70 % (légèrement au-dessus, comme leur rareté).
- Pouvoirs : Frappe sournoise (assassin) 5 → 4 ; Bombe (artificier) 4 → 3 ; Appel de la meute (invocateur) → « Appel des morts » (Squelette au lieu du Loup spectral).
- Héros boss joueur : pouvoir `boss_hero` (4 dégâts au héros adverse) ; les boss adverses gardent `boss` (5).
- Bonus de classe : PV de départ 1 à 4 (plus de mana de départ, qui était trop fort sur chasseur/assassin/artificier).
- Bonus par tour : dégât 1 tour sur 3 (Samouraï 1 sur 4), soin 2 un tour sur 2, mana 1 un tour sur 2 (Liche éternelle 1 sur 3), Liche des brumes soin 1 par tour. La pioche supplémentaire est retirée (elle provoquait la fatigue : 35 % de victoires).
