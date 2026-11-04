# Zimut — chantier des quatre modes et de la progression partagée

## Contrat de conception (à préserver)

Les quatre modes sont des expériences de gameplay autonomes :

1. **Tactique** — combats au tour par tour, gestion des PA/PM/PO et équipe.
2. **Découverte 2D** — exploration sur cartes illustrées, déplacement sur grille, lieux et secrets.
3. **Découverte 3D** — exploration libre en monde ouvert, caméra et interactions propres à cet espace.
4. **Conquête** — stratégie territoriale, villes, armées et économie.

Aucun mode ne doit être une simple bascule de caméra vers un autre. Le joueur entre dans chaque mode depuis « Mes Parties » et peut revenir à ce menu. Le retour d'un combat doit ramener le joueur dans le mode d'exploration qui l'a déclenché.

### Données communes

Les modes lisent et écrivent dans la même sauvegarde de partie. Les données partagées comprennent au minimum :

- roster, équipe active, classes et niveaux ;
- expérience, caractéristiques, sorts et progression ;
- équipement, inventaire, butin et or ;
- ressources et rangs de ressources ;
- état de campagne, déblocages et récompenses persistantes.

Les états purement spatiaux et les règles locales restent indépendants : position et caméra 3D, position sur la grille 2D, brouillard propre à l'exploration, unités et territoires de Conquête, état d'un combat tactique. Une action locale ne doit pas écraser l'état d'un autre mode.

## Programme d'amélioration en cinq phases

### 1 — Héros et sensations
- Harmoniser les animations idle, marche, demi-tour et interaction.
- Lisser les transitions et renforcer l'anticipation/réaction aux découvertes.
- Ajouter ombre de contact et feedbacks visuels cohérents sans pénaliser les appareils mobiles.
- Conserver les contrôles propres à chaque mode.

### 2 — Environnements vivants
- Renforcer le tri de profondeur : le héros passe naturellement derrière les arbres, bâtiments et éléments hauts.
- Ajouter animations d'ambiance légères, variations de lumière et brume par biome.
- Prévoir des profils de qualité pour Android et éviter les effets coûteux en qualité basse.
- Décliner les ambiances sans uniformiser les Nations.

### 3 — Interactions et exploration
- Donner des interactions claires aux coffres, ressources, PNJ, portails, lieux remarquables et donjons.
- Afficher un retour explicite sur la récompense et enregistrer chaque action dans la sauvegarde commune.
- Développer les secrets, points d'intérêt, objectifs et découvertes sans rendre la carte illisible.
- Garder les interactions 2D et 3D adaptées à leur locomotion respective.

### 4 — Progression RPG transversale
- Vérifier chaque flux de récompense : combat, exploration, donjon et Conquête.
- Centraliser les mutations de ressources/XP/inventaire dans les services de progression.
- Ajouter des tests de non-régression sur les échanges entre les quatre modes.
- Garantir l'absence de duplication ou de perte de récompenses lors des transitions et rechargements.

### 5 — Interface graphique et cohérence
- Clarifier la hiérarchie visuelle : personnage, objectif, état de zone, ressources et action contextuelle.
- Uniformiser typographie, panneaux, couleurs d'accent, feedbacks tactiles et fenêtres modales.
- Adapter les interfaces aux formats Android, aux petites hauteurs et aux commandes tactiles.
- Éviter les HUD trop chargés : les informations secondaires doivent rester consultables sans masquer le monde.

## Première livraison

Cette première tranche rend visibles les ressources de la sauvegarde commune dans l'exploration 2D et dans le HUD du monde ouvert 3D. Elle ajoute des vérifications statiques au test de séparation des modes. Elle ne prétend pas terminer les cinq phases : elle pose le contrat commun et ouvre le chantier par une amélioration transversale vérifiable.


## Audit d'accessibilité — planche Sylvestre (04/11/2026)

La grille de `data/boards/foret_sylve.json` contient 96 × 54 cases. Un contrôle de connexité du masque confirme que les 2 031 cases marquées comme praticables sont toutes reliées au point de départ et que les 18 POI déclarés, dont les cinq donjons, sont posés sur des cases praticables.

Le défaut identifié se situe dans le calcul de trajet : les donjons sont des POI de type combat, mais `poi_done()` les considère volontairement toujours rejouables. `path_to()` les classait donc systématiquement parmi les cases interdites. Cela transformait certaines entrées en murs permanents, notamment lorsqu'elles se trouvaient sur un passage vers une autre partie de la carte.

Correction engagée :
- une entrée de donjon n'est plus ajoutée aux cases bloquées du pathfinder ;
- pendant un trajet vers une autre destination, le héros peut traverser une case d'entrée de donjon ;
- si l'entrée est la destination, l'arrêt et l'interaction habituels sont conservés.

Les combats ordinaires non terminés restent des obstacles intentionnels : ils continuent de provoquer une rencontre au contact.

Limite de l'audit : cette vérification confirme la connexité du masque et des coordonnées de POI, pas encore le bon alignement pixel par pixel entre la planche graphique et chaque cellule. Une validation tactile sur appareil Android reste nécessaire.
