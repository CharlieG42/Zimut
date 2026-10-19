# V27 — Les Pierres Élémentaires (objectif final), mécanismes illustrés, villes Rouages

## 1. Pierres Élémentaires (implémentées)
- **10 Pierres, une par Nation** (Rouages compris). On gagne la Pierre en battant le **boss de la Nation**, dans n'importe quel mode :
  - **Tactique** : les boss de cycle (Forêt, Montagne, Désert) et les salles du Donjon ;
  - **Aventure** : un **sanctuaire** par Nation (nouveau lieu de combat contre le boss, une Pierre flotte au-dessus tant qu'elle n'est pas prise) ;
  - **Conquête** : la 4e bataille d'un siège (boss du biome).
- **2 Pierres max par héros**, une Pierre n'existe qu'une fois (la confier à un héros la retire à l'autre).
- **Éveil 1 → 5** : or + ressource de la Nation (250/1000/2250/4000 or ; 8/16/24/32 ressources). Le bonus est multiplié par le niveau.
- Les bonus passent par les stats du héros (tous les modes) :

| Nation | Pierre | Par niveau | Effet fixe |
|---|---|---|---|
| Sylvestre | Sève | PV +20, Sagesse +2, vol de vie +2 % | |
| Cimes | Givre | Défense +5, rés. magie +3 % | |
| Sables | Ocre | Agilité +5, critique +2 % | |
| Cristaux | Prisme | Intelligence +5, dégâts magiques +3 % | |
| Marées | Corail | Sagesse +5, PV +8, soins +4 % | |
| Vents | Azur | Agilité +3 | +1 PM |
| Brasier | Braise | Force +5, dégâts physiques +3 % | |
| Brumes | Lune-des-Marais | Int. +3, Sagesse +3, vol de vie +3 % | |
| Ombres | Ébène | Force +3, Agilité +3, critique +3 % | |
| Rouages | Airain | Défense +3, Force +3 | +1 PA |

- **Vitrine** : bouton « 💎 Pierres n/10 » dans Mes Parties (gemmes dessinées, indices pour les trouver, porteur, éveil).
- Bandeau « 💎 Pierre retrouvée ! » dans la fenêtre de victoire ; 3 succès (1, 5 et 10 Pierres).
- Sauvegarde : `save["stones"] = {biome: {owner, level}}` (rétro-compatible).

## 2. Graphismes
- Mécanismes de l'Artificier dessinés : bombe à mèche allumée, tourelle de cuivre, balise de transposition lumineuse (`assets/sprites/summons/`).

## 3. Conquête
- Deux villes Rouages au nord-est : **Atelier de Cuivre** (neutre, niv 95) et **Citadelle des Engrenages** (ennemie, niv 115), révélées par les Ateliers des Rouages en Aventure. La campagne passe à 30 villes.

Tests : `tests/test_stones.gd` (+ mise à jour de `test_conquest_roads.gd`), capture `tests/shot_stones.gd`.
