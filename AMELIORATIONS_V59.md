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

## Détail des modifications
- `prototype/zimut/scripts/ConquestSystem.gd` : moteur (constantes, `CITY_TRAITS`, édits, buffs, `defense`, `after_victory`).
- `prototype/zimut/scripts/ProgressionManager.gd` : production d'empire (+ spécialités, + routes) et `conquest_city_trait`.
- `prototype/zimut/scripts/CityScreenUI.gd`, `ConquestMapUI.gd` : affichages.
- `prototype/zimut/tests/test_conquest_system.gd` : bloc V59 (audience, impôt, manœuvres, routes, spécialités, pillage).
- `prototype/zimut/CONQUETE.md` : doc du mode à jour.
