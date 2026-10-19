# Héros « Artificier » (ingénieur, bombardier) — proposition pour une future Nation

> Statut : **concept de design**, non implémenté. Nom de travail : *Artificier*. Nation suggérée : **Nation des Rouages**
> (technologie, forges, cités-ateliers) ; à valider avec `NATIONS.md`.

## 1. Fantasme
Un ingénieur qui gagne par la **préparation** : il arme le terrain de bombes, de glyphes-pièges et de tourelles, puis
fait parler la poudre. Il joue le **tempo** (poser, attendre, déclencher), pas le blocage.

## 2. Ce qui le distingue du Géomancien
| | **Géomancien** (existant) | **Artificier** (proposé) |
|---|---|---|
| Matière | Pierre et sable | Poudre, métal, mécanismes |
| Rôle | Contrôle de position, protection | Dégâts de zone planifiés, zone-denial |
| Outils | Piliers, murs, failles qui **bloquent** les cases | Bombes **à retardement**, glyphes **déclenchés**, tourelles **qui tirent** |
| Défense | Très résistant (bloque et isole) | Fragile : il se protège par la distance et le placement |
| Temps | Effets immédiats / durables | Effets **différés** (explose dans N tours, se déclenche au passage) |
| Ressource | PA classiques | **Charges** : les gadgets en consomment, elles se rechargent chaque tour |

Règle de design : l'Artificier **ne crée aucun obstacle de terrain** (pas de murs ni de piliers). Ses tourelles sont des invocations
fragiles à 1 case, qui ne bloquent pas la ligne de vue.

## 3. Kit de sorts proposé (déblocages comme les autres classes : 1 · 1 · 1 · 10 · 20 · 35 · 50 · 65 · 80 · 100)

**Principe central : le Déclencheur.** Un sort à **1 PA** (disponible dès le niveau 1) qui **active à distance l'effet d'un mécanisme déjà posé**.
Le héros pose ses mécanismes (coût normal) puis choisit quand ils agissent : l'attente et le tempo sont au cœur du gameplay.

| Niv. | Sort | PA | Type | Effet (idée) |
|---|---|---|---|---|
| 1 | **Tir de précision** | 3 | Arme | Dégâts à distance (portée 5), bonus si la cible n'a pas bougé |
| 1 | **Bombe** | 2 | Mécanisme | Pose une bombe (zone 3×3) qui explose seule au bout de 2 tours |
| 1 | **Déclencheur** | **1** | Contrôle | Cible un de ses mécanismes (portée 6) et **déclenche son effet immédiatement** (voir tableau ci-dessous) |
| 10 | **Balise de transposition** | 2 | Mécanisme | Voir §3 bis : le héros **inverse sa place** avec la balise |
| 20 | **Mine** | 2 | Mécanisme | Piège caché : dégâts fixes + étourdissement au passage, ou sur ordre du Déclencheur |
| 35 | **Tourelle sentinelle** | 3 | Mécanisme | Invocation fragile : tire sur l'ennemi le plus proche chaque tour ; le Déclencheur lui fait faire **un tir immédiat** |
| 50 | **Glyphe de surcharge** | 2 | Mécanisme | Allié sur la case : +dégâts 2 tours ; ennemi : dégâts subis +25 % ; déclenchable pour un effet sur l'occupant actuel |
| 65 | **Tourelle à fragmentation** | 3 | Mécanisme | Tire en zone ; détruite au premier coup reçu |
| 80 | **Barrage** | 4 | Arme | 3 tirs répartis sur des cibles différentes |
| 100 | **Bombardement** | 5 | Mécanisme | Pluie de bombes sur une zone 5×5, que le Déclencheur peut faire exploser dès le même tour |

*Remplace l'ancien « Détonateur » (qui faisait exploser toutes les bombes d'un coup) : le Déclencheur agit sur un mécanisme à la fois, pour un coût de 1 PA.*

### Effet du Déclencheur selon le mécanisme visé
| Mécanisme | Effet immédiat |
|---|---|
| Bombe / Bombardement | Explose maintenant (le compte à rebours est ignoré) |
| Mine | Se déclenche sur la case : dégâts et étourdissement à l'occupant s'il y en a un, sinon elle reste armée |
| Tourelle | Tire tout de suite un tir supplémentaire |
| Glyphe | Applique son effet à l'unité qui s'y trouve |
| **Balise de transposition** | **Inverse la place du héros et de la balise** (voir ci-dessous) |

### 3 bis. Balise de transposition (échange de position)
- **Pose** : le héros lance le sort sur une case libre à portée (≈ 5). La balise apparaît sur la case du héros et **le héros prend la place visée** : au lancement, le héros et la balise **échangent leurs positions**.
- **Ensuite** : lors d'un **tour suivant** (ou plus tard dans un tour sans échange), le héros peut lancer le **Déclencheur (1 PA)** sur la balise pour **échanger de nouveau leurs places**. L'effet est **répétable d'un tour à l'autre** : aller-retour entre deux cases, ou se replacer derrière une ligne alliée sans dépenser de PM.
- **Garde-fous proposés** : 1 balise à la fois ; PV très faibles (un ennemi qui l'attaque la détruit) ; l'échange est impossible vers une case occupée par une autre unité ; **un seul échange de position par tour** (la pose compte comme un échange ; les autres usages du Déclencheur, sur bombes, mines ou tourelles, ne sont pas concernés). La balise doit être dans la portée du Déclencheur (6).
- **Intérêt tactique** : mobilité de repli, tir de couverture (poser, se placer, revenir), échange pour sortir d'un corps à corps pour 1 PA seulement.
- *Variante possible si cette lecture n'est pas la bonne* : la balise est posée **sans échange** (2 PA) et c'est le Déclencheur (1 PA) qui effectue chaque échange, y compris le premier.

## 4. Équilibrage et garde-fous
- Limites : 3 mécanismes posés en même temps (bombes, mines, glyphes), 1 balise, 1 tourelle (2 après le niveau 65) ; le plus ancien disparaît.
- Le Déclencheur coûte 1 PA et agit sur **un seul** mécanisme par lancer ; il ne peut pas viser un mécanisme ennemi. Limite de 3 lancers par tour pour éviter les boucles de PA ; l'échange de la balise reste limité à 1 par tour.
- Les bombes blessent aussi les alliés (risque de « tir ami »), ce qui demande de la précision sans bloquer le jeu auto.
- Stats cibles (niveau 100, à comparer avec `EQUILIBRAGE.md`) : PV ≈ 250, Force 75, Intelligence 60, Agilité 70, Défense ≈ 28, soit environ le profil de l'Assassin en plus technique.
- IA des ennemis : les glyphes doivent être invisibles pour l'ennemi, mais l'IA ne les évite pas systématiquement (tests à prévoir).

## 5. Intégration
- Nouvelle ligne dans `data/classes.txt` / `sorts.txt` / `progression_sorts.txt` (générés par `tools/gen_balance_v15.py`) ; le mécanisme « glyphe / mine / balise » est nouveau (cases à effet déclenché, échange de position entre le héros et une invocation statique), les tourelles réutilisent les invocations statiques existantes ; le Déclencheur est un sort ciblant un allié statique « mécanisme ».
- Sprite : à fournir. Nation des Rouages : à créer dans `Nations.gd` / `NATIONS.md`, avec une Pierre Élémentaire (voir `PIERRES_ELEMENTAIRES.md`).
