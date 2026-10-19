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
| Niv. | Sort | Type | Effet (idée) |
|---|---|---|---|
| 1 | **Tir de précision** | Arme | Dégâts à distance (portée 5), bonus si la cible n'a pas bougé |
| 1 | **Bombe à retardement** | Bombe | Pose une bombe : explose dans 2 tours (zone 3×3) ; peut être déclenchée plus tôt |
| 1 | **Glyphe de ralentissement** | Glyphe | Case piégée : −PM à qui la traverse (invisible pour l'ennemi) |
| 10 | **Mine** | Piège | Dégâts fixes au passage + étourdissement |
| 20 | **Tourelle sentinelle** | Tourelle | Invocation (PV faibles) : tire sur l'ennemi le plus proche à chaque tour |
| 35 | **Détonateur** | Bombe | Fait exploser toutes les bombes posées, dégâts +20 % par bombe |
| 50 | **Glyphe de surcharge** | Glyphe | Allié qui entre : +dégâts 2 tours ; ennemi : dégâts subis +25 % |
| 65 | **Tourelle à fragmentation** | Tourelle | Tire en zone, détruit par le premier coup reçu |
| 80 | **Barrage** | Arme | 3 tirs répartis sur des cibles différentes |
| 100 | **Bombardement** | Bombe | Pluie de bombes sur une zone 5×5, explosion au tour suivant |

## 4. Équilibrage et garde-fous
- Limites : 3 gadgets posés en même temps (bombes + glyphes), 1 tourelle (2 après le niveau 65) ; le plus ancien disparaît.
- Les bombes blessent aussi les alliés (risque de « tir ami »), ce qui demande de la précision sans bloquer le jeu auto.
- Stats cibles (niveau 100, à comparer avec `EQUILIBRAGE.md`) : PV ≈ 250, Force 75, Intelligence 60, Agilité 70, Défense ≈ 28, soit environ le profil de l'Assassin en plus technique.
- IA des ennemis : les glyphes doivent être invisibles pour l'ennemi, mais l'IA ne les évite pas systématiquement (tests à prévoir).

## 5. Intégration
- Nouvelle ligne dans `data/classes.txt` / `sorts.txt` / `progression_sorts.txt` (générés par `tools/gen_balance_v15.py`) ; le mécanisme « glyphe / mine » est nouveau (cases à effet déclenché), les tourelles réutilisent les invocations statiques existantes.
- Sprite : à fournir. Nation des Rouages : à créer dans `Nations.gd` / `NATIONS.md`, avec une Pierre Élémentaire (voir `PIERRES_ELEMENTAIRES.md`).
