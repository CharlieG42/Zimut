# V59 — Conquête : le Chancelier, les missions de lieutenance et les spécialités des villes

## Chancelier (décisions stratégiques récurrentes)
- Tous les 5 batailles gagnées, dès 2 villes conquises, le Chancelier demande audience (popup des événements, `ConquestSystem.maybe_chancellor`).
- Trois édits à trade-off :
  - **Impôt** : encaisse immédiatement le revenu d'une victoire par ville, mais chaque garnison perd 1 soldat.
  - **Manœuvres** (60 or) : +2 défense dans toutes les villes pendant 3 batailles (`drill`, inclus dans `ConquestSystem.defense`).
  - **Entretien des routes** (40 or) : +2 Bois et +1 Cuir à chaque victoire pendant 4 batailles (`roadworks`, versés par `conquest_empire_yield`).
- Les buffs actifs s'affichent dans le panneau de ville sur la carte ; les édits disponibles tiennent compte de ce qui est déjà en cours.
- Sauvegarde rétro-compatible : clés optionnelles `chancellor_cd`, `chancellor_seen`, `drill`, `roadworks`.

## Spécialités économiques par ville (biome/Nation)
- Chaque ville conquise verse en plus une ressource propre à son biome (`ConquestSystem.CITY_TRAITS`), à chaque victoire : Mine de Cristal +3 Magie, Forge du Givre +3 Fer, Marais des Spectres +3 Venin, Port des Sables +3 Cuir, etc. (28 villes couvertes).
- Production mise à l'échelle du niveau de la ville (×1 / ×1,5 / ×2), gelée si la ville est pillée.
- Sommée dans `ConquestSystem.trait_yield` et versée par `conquest_empire_yield` ; affichée dans le Conseil de l'écran de ville (« Spécialité — … ») et sur la carte.
- Renforce l'identité économique des Nations (voir `NATIONS.md`) : conquérir un biome donne accès à sa ressource, pas seulement à son bestiaire.

## Missions de lieutenance (héros libres)
- Depuis une ville alliée, bouton « ⚑ MISSIONS DES LIEUTENANTS » : envoyer un héros libre 3 batailles en **Escorte de caravane** (+90 or, +4 Cuir), **Cartographie** (révèle 2 villes inconnues — même état que les belvédères d'Aventure) ou **Prospection** (+30 or, +8 Fer) ; récompenses mises à l'échelle du niveau du héros.
- 20 % de complication : l'expédition échoue et coûte de l'or (journalisée dans les nouvelles).
- Un héros en mission ne peut ni combattre (exclu de la sélection d'équipe) ni gouverner (exclu du sélecteur) ; mission rappelable sans récompense.
- Sauvegarde : clés optionnelles `missions` {classe -> {type, eta}} et `missions_revealed`.

## Généraux du Roi Squelette
- Quatre généraux nommés tiennent les forteresses ennemies : Tharok le Végétal (Fort Racine), Vorkann le Givre (Garnison des Pics), Zahor le Sableux (Tour des Sables), Nébulia l'Illusionniste (Citadelle des Ronces) — `ConquestSystem.GENERALS`.
- Tant qu'il vit : siège durci (+3 niveaux via `general_defense_bonus`) et offensives nommées possibles (25 % après chaque victoire, +2 de force, bannière « ☠ … mène l'offensive »).
- La 4ᵉ bataille de sa forteresse l'oppose en personne : `GameManager._spawn_boss` substitue le nom du général (kit du boss de sa Nation, affichage du titre existant).
- Vaincus : journal de la chute ; tous vaincus → assaut du Donjon -3 niveaux et message « ★ Tous les généraux sont tombés ».
- Compteur en tête de carte : « ☠ N général(aux) du Roi Squelette en vie ».

## Plans d'assaut (sans combat) et reconquête ennemie
- **Blocus** (40 or) et **Infiltration** (50 or, Assassin libre requis) : font avancer un siège ennemi d'une vague sans combat, depuis le popup de préparation (pas proposés sur la vague boss). Le blocus risque des représailles (35 % : pillage d'une ville possédée) ; l'infiltration est sûre mais l'Assassin revient à la victoire suivante (mission « infiltration » de 1 bataille).
- Un plan peut annexer la ville sans combat (annexion, butin, chute du général le cas échéant : `conquest_apply_plan` → `_progress_to_annex`).
- **Reconquête ennemie** : chaque ville non possédée gagne 1 soldat de garnison toutes les 3 victoires (max 6) ; +1 niveau de bataille par tranche de 2 soldats (`enemy_garrison_bonus`, appliqué dans `GameManager`), affiché sur la carte (« ⚑ Garnison adverse ») — attendre une cible la durcit.

## Diplomatie, ruine & reconstruction, fins multiples
- **Diplomatie** : les villes neutres atteignables peuvent être annexées sans combat (bouton « ☮ NÉGOCIER » : 120 or + 8 de la ressource spécialité de la ville) — `ConquestSystem.negotiate_city` ; les annexions pacifiques sont comptées (`annexed_diplomacy`) et pèsent dans la Légende.
- **Ruine & reconstruction** : une ville perdue puis reprise est **ruinée** — la chute coûte un niveau, la production (revenu, spécialité, bâtiments, gouverneur) est gelée 3 batailles, réparable pour 80 or (`ruin`, `repair_city`) ; la ruine se résorbe aussi seule à chaque victoire.
- **Légende & fins multiples** : à la chute du Donjon, l'épilogue calcule un score (villes, développement, gouverneurs, Pierres, diplomatie, ruines) et affiche l'une des trois fins selon le style de jeu — Âge des Héros / Empire marchand (4+ négociations) / Bastion de Zimut (villes développées + gouverneurs).

## Détail des modifications
- `prototype/zimut/scripts/ConquestSystem.gd` : moteur (constantes, `CITY_TRAITS`, édits, buffs, `defense`, `after_victory`).
- `prototype/zimut/scripts/ProgressionManager.gd` : production d'empire (+ spécialités, + routes) et `conquest_city_trait`.
- `prototype/zimut/scripts/CityScreenUI.gd`, `ConquestMapUI.gd` : affichages.
- `prototype/zimut/tests/test_conquest_system.gd` : bloc V59 (audience, impôt, manœuvres, routes, spécialités, pillage).
- `prototype/zimut/CONQUETE.md` : doc du mode à jour.
