# Design Document — Mode « Empire / Conquête » (3e mode Zimut)

Dernière mise à jour : prototype — solo / PvE uniquement.
Sources d'inspiration : **Grepolis** (InnoGames) et **MillionLords** (Million Victories).

---

## 1. Objectif et cadrage

Ajouter un troisième mode de jeu à Zimut, à côté des deux modes existants :

- **Zimut** (`prototype/zimut/`) : combat tactique tour par tour sur grille isométrique 8×8.
- **ZOE** (`prototype/zoe/`) : aventure / survie solo sur grille 8×8.

Le nouveau mode **Empire / Conquête** est une couche **stratégique macro** au-dessus
du combat tactique Zimut. Le joueur bâtit et étend un empire ; chaque attaque déclenche
une instance du **combat Zimut existant** pour résoudre la bataille.

### Cadrage retenu (décision utilisateur)

- **Solo / PvE** uniquement. Pas de backend, pas de PvP, pas de serveur persistant.
- **Chaque conquête lance le combat tactique Zimut** (pas de combat auto-résolu).

### Hors périmètre (reporté)

PvP, backend, saisons online, commerce inter-joueurs, alliances multijoueurs,
combats auto-résolus.

---

## 2. Résumé des jeux de référence et emprunts

### Grepolis (stratégie MMO, Grèce antique)
- Bâtir une cité sur une île, exploiter villages de paysans et ressources.
- 13 bâtiments + 8 bâtiments spéciaux, 30+ technologies à l'académie.
- **Panthéon de 6 divinités** accordant faveurs, unités mythiques (hydres, manticores,
  pégases) et interventions divines ; héros recrutés contre des points de faveur.
- Conquête : coloniser ou conquérir des villes ; unités terrestres, navales, mythiques.
- Merveilles du monde comme objectif de fin de saison.

### MillionLords (4X mobile reconstruit)
- Conquête de territoire en temps réel, **sans city-builder, farming ni timer** : purement tactique.
- 2 ressources produites automatiquement par les villes.
- Déplacement de troupes, équipement, **espionnage** des cibles avant attaque.
- **Saisons** : reset du classement, on garde l'équipement.
- **Bonus/malus d'XP** selon la taille du royaume (anti-écrasement).

### Emprunts retenus pour Zimut

| Mécanique | Origine | Transposition Zimut |
|---|---|---|
| Production de ressources automatique par ville | MillionLords | Économie passive (or, fer, bois, magie, venin) |
| Pas de farming/timer lourd | MillionLords | Pas de timers de construction « wait-or-pay » |
| Espionnage d'une cible avant attaque | MillionLords | Action « Reconnaissance » sur une ville voisine |
| Bonus/malus d'XP selon taille du royaume | MillionLords | Ajuste niveau des garnisons IA selon rapport de force |
| Panthéon de divinités / faveurs | Grepolis | `divinites.csv` — faveurs passives et sorts bonus |
| Unités mythiques / créatures | Grepolis | Réutilisation de `invocations.csv` (Loup, Centaure, Ange…) |
| Bâtiments et technologies | Grepolis | `batiments.csv` — développe une ville |
| Merveilles comme objectif de fin | Grepolis | Condition de victoire de la campagne |
| Combat tactique détaillé | Zimut (existant) | **Réutilisé tel quel** via `BattleBridge` |

---

## 3. Boucle de jeu

1. **Carte monde** (grille régionale isométrique). Le joueur possède une **capitale** ;
   des villages neutres et des **seigneurs IA** occupent le reste de la carte.
2. **Phase stratégique** (temps réel, sans timers lourds) :
   - Les villes produisent automatiquement des ressources.
   - Le joueur recrute/équipe des **héros** (classes Zimut) et lève des **armées**.
   - Le joueur développe ses villes via des **bâtiments** (`batiments.csv`).
   - Le joueur peut **reconnaître** une cible avant d'attaquer.
3. **Attaquer une ville** → instanciation du **combat Zimut** :
   - `BattleBridge` peuple `GameManager.players[]` avec l'armée attaquante
     (héros + invocations) via `set_custom_team()`.
   - `GameManager.enemies[]` est peuplé avec la garnison de la ville ciblée.
   - L'issue du combat (victoire/défaite) est remontée au `EmpireManager`.
4. **Résolution** : conquête (la ville change de propriétaire) ou échec
   (pertes retenues sur l'armée attaquante). Expansion ville par ville.
5. **Objectif de campagne** : domination de la carte, ou construction d'une merveille
   une fois un seuil de villes atteint.

---

## 4. Architecture technique (cohérente avec le dépôt)

### 4.1 Structure de dossiers

Suivre exactement le patron des modes existants (`prototype/zimut/`, `prototype/zoe/`) :

```
prototype/empire/
├── project.godot              # projet Godot dédié, comme zimut/ et zoe/
├── scenes/
│   └── Main.tscn              # point d'entrée (comme zimut/scenes/Main.tscn)
├── scripts/
│   ├── EmpireManager.gd       # autoload — logique globale (comme GameManager.gd)
│   ├── WorldMapManager.gd     # grille isométrique de la carte monde
│   ├── EconomyManager.gd      # production ressources, achat/recrutement
│   ├── ArmyManager.gd         # héros, armées, garnisons
│   ├── AIManager.gd           # comportement des seigneurs IA sur la carte
│   ├── BattleBridge.gd        # pont avec le combat Zimut existant
│   ├── EmpireUIManager.gd     # interface stratégique
│   └── Main.gd                # script de la scène Main
└── assets/                   # réutiliser prototype/shared/assets/
```

### 4.2 Point d'intégration clé : `BattleBridge` ↔ combat Zimut

Le combat Zimut **supporte déjà une équipe personnalisée** via
`GameManager.set_custom_team(team_data: Array)` (cf. `prototype/zimut/scripts/GameManager.gd:130`).
Le tableau attendu contient 3 dicts de la forme :

```
{ "classe": "Tank", "max_pv": int, "force": int, "intelligence": int,
  "agilite"/"agility": int, "sagesse"/"wisdom": int, "defense": int,
  "pa": int, "pm": int, "color": Color (optionnel) }
```

`init_entities()` (`GameManager.gd:221`) peuple alors `players[]` depuis `custom_team`
et `enemies[]` depuis les types ennemis par défaut (Gobelin, Squelette, Loup).

**`BattleBridge` étend cela** :
- Constitue `custom_team` à partir de l'armée attaquante du joueur (3 héros menant
  l'assaut, équipement appliqué via `craft.csv`/`stuff.csv`).
- Surcharge la liste des ennemis pour peupler `enemies[]` depuis la garnison réelle
  de la ville ciblée (composée d'unités `unites.csv` + ennemis `ennemis.csv`).
- Déclenche la scène de combat Zimut via `change_scene`, puis récupère l'issue
  via le signal `game_ended(victory)` de `GameManager` et met à jour l'état Empire.

> Note d'implémentation : `GameManager` peuple `enemies[]` en dur dans
> `init_entities()`. Pour la V1 du squelette, `BattleBridge` fournit `custom_team`
> (déjà supporté) et expose une API pour injecter une garnison personnalisée
> (extension minimale à documenter dans `BattleBridge.gd`).

### 4.3 Réutilisation des données existantes (dossier `data/`)

| Fichier | Rôle dans Empire |
|---|---|
| `classes.csv` | Stats des héros/commandants menant les armées |
| `sorts.csv` + `progression_sorts.csv` | Compétences des héros en campagne |
| `craft.csv` | Équipement des armées et héros (armes, armures, accessoires) |
| `invocations.csv` + `sorts_invocations.csv` | Créatures mythiques / unités d'élite (Grepolis) |
| `ennemis.csv` | Garnisons PvE des villages neutres et IA |

### 4.4 Nouveaux fichiers de données (`data/`, même convention que `craft.csv`)

- `batiments.csv` — bâtiments développables dans une ville (production, recrutement, tech).
- `unites.csv` — unités d'armée recrutables et garnisons.
- `divinites.csv` — panthéon et faveurs (bonus passifs + sorts bonus).

Schémas détaillés en §5.

### 4.5 Persistance

Étendre `database/data_manager.py` (SQLite `zimut.db` déjà présent) avec des tables
pour la carte monde, les villes, les armées et l'économie. Le mode ZOE utilise déjà
une sauvegarde simple (`user://savegame.save`) ; Empire suit la même philosophie
persistante solo.

### 4.6 Conformité

- Respecter `GODOT_BEST_PRACTICES.md` : 1 fichier = 1 responsabilité, typage explicite,
  signaux compatibles, détection isométrique éprouvée dans `Cell.gd`.
- Compatible chaîne CI du dépôt : export Godot 4.1.3 LTS pour Android
  (cf. `.github/`). Le nouveau mode garde `config/features` cohérent avec les projets
  existants (Forward Plus).

---

## 5. Schéma de données des nouveaux CSV

### 5.1 `batiments.csv`

```
Nom,Type,Niveau requis,Coût or,Coût fer,Coût bois,Coût magie,Production or,Production fer,Production bois,Effet,Description
Maison du peuple,Habitat,1,50,10,5,0,2,0,0,+5 population,Bergerie augmentant la population
Mine de fer,Production,1,80,5,20,0,0,3,0,-,Extrait le fer de la montagne
Scierie,Production,1,60,10,0,0,0,0,3,-,Abat la forêt environnante
Caserne,Recrutement,2,150,30,20,0,0,0,0,Débloque les unités de base,Forme les soldats
Académie,Technologie,3,200,20,30,10,0,0,0,Débloque technologies,Recherche militaire
Temple,Divinité,2,120,10,10,5,0,0,0,Débloque le panthéon,Vénération des divinités
Port,Commerce,3,180,20,40,0,1,0,0,Échange de ressources,Commerce maritime
Merveille,Objectif,5,1000,200,200,100,0,0,0,Victoire de campagne,Monument de domination
```

### 5.2 `unites.csv`

```
Nom,Niveau requis,Coût or,Coût fer,Coût bois,PV,Attaque,Défense,PA,PM,Type,Biome
Soldat,1,40,15,0,80,12,8,3,2,Humain,Plaine
Archer,2,50,10,20,60,15,4,3,3,Humain,Forêt
Lancier,2,60,20,10,100,10,15,3,2,Humain,Plaine
Cavalier,3,120,30,20,140,20,10,4,4,Humain,Plaine
Loup,1,30,5,10,80,20,10,4,3,Mythique,Forêt
Tortue,1,40,10,0,150,10,30,4,3,Mythique,Forêt
Sirène,2,80,0,0,70,15,15,4,3,Mythique,Désert
Ange,3,120,0,0,90,18,20,4,3,Mythique,Montagne
Centaure,4,160,20,10,120,22,25,4,3,Mythique,Plaine
```

### 5.3 `divinites.csv`

```
Nom,Faveur,Coût, Effet,Bonus production,Bonus combat,Sort bonus
Héra,Protection,50,Protège la capitale,+10% or,-10% dégâts reçus,Soin divin
Athéna,Sagesse,80,Accélère la recherche,+10% magie,+15% attaque,Lance d'Athéna
Poséidon,Marine,60,Renforce les unités navales/port,+10% bois,+20% PM,Tsunami
Hadès,Outre-tombe,90,Invoque des esprits,+10% fer,+20% dégâts,Ombre d'Hadès
Artémis,Chasse,70,Renforce archers et bêtes,+10% bois,+15% précision,Flèche d'argent
Zeus,Foudre,150,Frappe divine sur garnison,+10% or,+25% dégâts magiques,Foudre de Zeus
```

---

## 6. Plan d'implémentation par étapes

### Étape 1 — Squelette (livré dans cette PR)
- `prototype/empire/` + `project.godot` (même patron que `prototype/zimut/`).
- `EmpireManager.gd` (autoload), `WorldMapManager.gd`, `EconomyManager.gd`,
  `ArmyManager.gd`, `AIManager.gd`, `BattleBridge.gd`, `EmpireUIManager.gd`, `Main.gd`.
- Scène `Main.tscn`.
- Nouveaux CSV : `batiments.csv`, `unites.csv`, `divinites.csv`.
- Extension `database/data_manager.py` pour la persistance Empire.
- Pont `BattleBridge` documenté et fonctionnel avec `set_custom_team()` existant.

### Étape 2 — Démo jouable (livrée)
- Carte monde + capitale + villages neutres, économie passive, recrutement,
  attaque d'un village neutre → combat Zimut → conquête.
- **Combat tactique Zimut intégré** : portage du combat dans 
  `prototype/empire/scripts/battle/` (`BattleGameManager`, `BattleGridManager`, 
  `BattleUIManager`, `BattleTurnManager`, `BattleCell`, `BattleSpellButton`, 
  orchestrateur `BattleMain.gd`) + scène `scenes/Battle.tscn`.
- **Garnison personnalisée** : `BattleGameManager.set_custom_enemy_team()` 
  (parallèle à `set_custom_team()`) peuple les ennemis depuis la garnison 
  réelle de la ville ciblée — résout le point d'attention §7.
- **Recrutement utile au combat** : les héros recrutés forment l'escouade ; 
  les unités (`unites.csv`) complètent l'assaut à défaut de héros ; 
  l'échec d'une conquête inflige des pertes à l'armée.
- UI Empire : sélection de classe d'héros et d'unité à recruter, affichage 
  de l'armée, masquage de l'UI stratégique pendant la bataille.
- CI : export Android du projet Empire ajouté à la chaîne 
  `.github/workflows/build-android-apks.yml`.
- Preset d'export Android : `prototype/empire/export_presets.cfg`.

### Étape 3 — Profondeur
- Seigneurs IA (expansionniste/défensif/agressif), espionnage, bâtiments,
  panthéon/faveurs, merveille comme objectif de victoire, équilibrage.

---

## 7. Risques et points d'attention

- **Injection de garnison personnalisée** : résolu en étape 2 — le portage 
  `BattleGameManager` du mode Empire accepte une `custom_enemy_team` 
  (parallèle à `custom_team`) et `BattleBridge` y injecte la garnison réelle 
  de la ville ciblée. Le `GameManager` du mode Zimut reste inchangé.
- **Taille de carte vs performance Android** : garder la grille monde modeste
  (ex. 12×12 régions) sur mobile.
- **Équilibrage économique** : sans timers, le rythme de production doit être calibré
  pour éviter la résolution triviale ou la sécheresse.

---

Document créé pour le prototype Zimut — mode Empire / Conquête.
