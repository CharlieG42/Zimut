# V148 — Conquête : vue d'ensemble de l'empire

Gérer l'empire demandait d'entrer dans chaque ville une à une. Un bouton **« ▦ MON EMPIRE »**, en haut du
Conseil de guerre, ouvre un tableau de toutes les villes avec trois actions groupées.

## Le bouton

Il indique combien de villes demandent un regard (« 5 villes à voir ») : ville menacée, ruinée, sans
soldats, amélioration payable, ou garnison incomplète quand l'or permet de recruter.

## Le tableau

Une ligne par ville : nom et niveau, soldats / capacité, défense, revenus par victoire, état (offensive,
ruinée, pillée, sans soldats, amélioration payable, gouverneur). Ordre : la ville menacée d'abord (ligne
rouge), puis les villes en alerte (ligne brune), puis par défense croissante. Toucher une ligne ouvre la
ville sur la carte.

## Les actions groupées

- **♜ Recruter partout** : un soldat à la fois, d'abord dans la ville menacée, puis dans la moins défendue,
  jusqu'à ce que les garnisons soient pleines ou que l'or manque. Le bouton affiche le coût pour tout remplir.
- **▲ Améliorer ce qui est payable** : un niveau par ville et par appui, la moins chère d'abord, tant que
  l'or et les ressources suivent.
- **⚒ Réparer les ruines** (s'il y en a) : 80 or par ville, tant que l'or suit.

Le résultat s'affiche en haut du tableau, qui se met à jour.

## Technique

`ConquestSystem` : `empire_rows`, `empire_action_count`, `can_afford_upgrade`, `recruit_all_cost`,
`recruit_all`, `upgrade_all_affordable`, `repair_all`. Interface : `ConquestMapUI._show_empire`.

## Tests

`tests/test_v148_vue_empire.gd` (nouveau, inscrit au workflow par `tests/ci/`).
