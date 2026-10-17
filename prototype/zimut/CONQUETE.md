# Conquête — V14 : villes vivantes, garnisons, héros et événements

Toute la logique est dans `scripts/ConquestSystem.gd` (statique, testable sans interface) ;
`ProgressionManager` expose les points d'entrée `conquest_*` ; l'interface est `ConquestMapUI.gd`.

## Villes évolutives
- 3 niveaux : Hameau → Bourg → Cité (coûts : 120 or + 10 Bois + 10 Fer ; puis 300 or + 20 Fer + 10 Cuir + 10 Magie).
- Chaque niveau : +2 places de garnison (4 / 6 / 8), +50 % de production des bâtiments, +2 or par victoire, +3 de défense.
- Un Bourg ou plus est protégé de l'épidémie.
- Nouveau bâtiment : **Muraille** (+6 défense).

## Garnisons
- Soldats à 30 or pièce (par 1 ou « remplir »). Chaque soldat = 2 de défense.
- **Défense** = soldats×2 + niveau×3 + muraille + gouverneur.

## Héros gouverneurs
- Un héros par ville, une ville par héros, 6 gouverneurs maximum (3 héros restent libres).
- Il défend (6 + niv/2 + bonus de classe) et produit selon sa classe (Tank rempart, Assassin or, Chasseur Cuir, Mage Magie, Druide Bois/Venin, Heal +1 soldat/bataille, Invocateur, Sylvain, Géomancien Fer).
- **Il ne combat plus en assaut** : il disparaît de la sélection d'équipe de Conquête.

## Menaces
- **Raids** (35 % par victoire) : repoussés si défense ≥ 4 + villes/2, sinon ville pillée 3 batailles. Villes frontalières ciblées 3× plus.
- **Grandes offensives** annoncées 3 batailles à l'avance (force affichée) : défense ≥ force → repoussée + butin ; ≥ 60 % → brèche (pillage 4 batailles, garnison /2) ; sinon **ville perdue** (reprise en une bataille, sans second butin).
- La capitale et le Donjon ne sont jamais ciblés.

## Événements (45 % par victoire, au plus un en attente)
Interactifs : Caravane marchande, Réfugiés, Mercenaires, Agitation (villes sans garnison), Espion capturé, Émissaire (trêve payante).
Automatiques : Bonne récolte, Cache découverte, Épidémie, Rapport du gouverneur.
Les nouvelles s'affichent au retour sur la carte ; l'événement à trancher apparaît en popup.

## Sauvegarde
Clés ajoutées à `conquest` (toutes optionnelles) : `city_levels`, `garrisons`, `threat`, `event_pending`, `news`, `truce`, `lost`, `rewarded`, `battle_count`, `event_cd`, `threat_cd`.

## Tests
`tests/test_conquest_system.gd` (moteur, 69 vérifications), `tests/test_conquest_team.gd` (sélection d'équipe, nécessite xvfb), `tests/shot_conquest_v14.gd` (captures).

## Écran de ville (V15)

Cliquer sur une ville **alliée** (capitale comprise) « entre dans la ville » : `CityScreenUI` s'ouvre par-dessus la carte, aux couleurs de la nation de la ville (fond, bordures, noms des quartiers : Hutte du Conseil / Amirauté / Sanctum de Cristal…).

- **Hôtel de ville** : évolution Hameau → Bourg → Cité (coûts en or et ressources).
- **Caserne** : recrutement (+1 ou remplir la garnison).
- **Résidence du gouverneur** : nommer / rappeler un héros (liste des 9 héros, ceux déjà en poste sont grisés).
- **Bâtiments de production** : scierie, mine, tannerie, cabane des mages, verger, muraille.
- **Conseil de la ville** (colonne de droite) : niveau, garnison, défense, revenu, gouverneur, menace en cours, production.

Chaque action écrit la sauvegarde ; le bouton « ← CARTE » revient à la carte. Le panneau latéral de la carte ne garde que le bouton « ⌂ ENTRER DANS LA VILLE ». Capture de test : `tests/shot_city_screen.gd`.
