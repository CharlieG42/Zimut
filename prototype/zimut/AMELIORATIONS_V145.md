# V145 — Conquête : défendre une ville en personne

Une offensive annoncée se réglait uniquement par une comparaison de chiffres (défense de la ville contre
force ennemie) à l'échéance. On peut maintenant la **jouer en combat Tactique**.

## Déroulé

1. Une offensive est annoncée sur une ville de l'empire (inchangé).
2. Sous la bannière rouge du Conseil de guerre, bouton **« ⚔ DÉFENDRE EN PERSONNE — assaillants niv. N »**.
   Une fenêtre rappelle la règle avant de lancer.
3. Choix de l'équipe, puis combat dans le biome de la ville, contre les ennemis de ce biome.
4. **Victoire** : offensive brisée, garnison intacte, butin ×1,5 par rapport à une offensive repoussée
   aux chiffres. La bataille compte comme une victoire de Conquête (revenus, production).
5. **Défaite ou abandon en plein combat** : la tentative est consommée (une seule par offensive).
   L'offensive suit son cours et se règle aux chiffres à l'échéance, comme avant ; on peut encore
   renforcer la ville. Revenir en arrière depuis le choix de l'équipe n'est pas un abandon.

## La préparation compte

Niveau des assaillants = niveau moyen de l'équipe + écart (force − défense) / 5, borné de −3 à +4.
Une ville bien gardée (soldats, muraille, gouverneur) donne un combat facile ; une ville négligée, un
combat difficile. Constantes dans `ConquestSystem` : `DEFEND_LEVEL_STEP`, `DEFEND_LEVEL_MIN`,
`DEFEND_LEVEL_MAX`, `DEFEND_LOOT_BONUS`.

Le **gouverneur de la ville attaquée** peut rejoindre l'équipe pour ce combat (il reste exclu des assauts).

## Technique

- `ConquestSystem` : `can_defend`, `defense_battle_level`, `start_defense`, `defense_won`,
  `defense_lost`, `mark_defense_started`, `settle_unresolved_defense`.
- Sauvegarde, clés optionnelles de `conquest` : `pending_defense`, `defense_started` (le temps du combat),
  `threat.fought`, `defended_in_person` (compteur), `last_defense`.
- `ProgressionManager._apply_campaign_victory` / `_apply_campaign_defeat` : branche défense, sans siège.
- `GameManager.init_entities` : pas de bonus de siège ni de vague de boss en défense.

## Pas encore fait

Soldats de la garnison présents sur le plateau, muraille en cases d'obstacle, général en personne quand
il mène l'offensive : notés dans `TODO.md`.

## Tests

`tests/test_v145_defense.gd` (nouveau).
