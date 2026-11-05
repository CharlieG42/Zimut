# Sylvestre — refonte visuelle de la carte 2D

> Chantier prioritaire exclusif jusqu'à validation explicite de Sylvestre.
> Aucune autre Nation ne doit recevoir de nouvelle carte, de décor, de héros ou de travail graphique avant cette validation.

## Ordre de priorité arbitré

1. **C — Profondeur du décor** : transformer la planche statique en environnement à plusieurs plans, avec arrière-plan, végétation intermédiaire, sol et éléments de premier plan capables d'occulter le héros.
2. **Héros** : le rendre plus lisible et cohérent avec le décor, améliorer ses transitions de marche et étudier une réutilisation pertinente des modèles/ressources 3D sans fusionner les gameplays 2D et 3D.
3. **D — Lieux remarquables** : intégrer visuellement donjons, sanctuaires, coffres, camps et autres POI au décor, sans déplacer leurs coordonnées ni modifier leurs interactions.

## Contraintes non négociables

- Le périmètre de développement est exclusivement foret_sylve.
- Les modes Aventure 2D et Aventure 3D gardent leurs contrôles et leur gameplay indépendants.
- Les ressources et la progression partagées entre modes restent inchangées.
- Ne pas modifier le masque de marche, les chemins, les collisions, les coordonnées des POI, les entrées de donjon ni les règles de déplacement dans une PR graphique.
- Toute nouvelle couche de décor doit être purement visuelle et ne pas bloquer les interactions tactiles.
- Préserver les performances sur Android ; les couches statiques doivent être mises en cache et les animations rester légères.

## Premier passage — profondeur et héros

- Ajout d'un arbre transparent de premier plan, instancié à deux emplacements périphériques de la planche Sylvestre.
- Les arbres sont des nœuds indépendants dans le conteneur trié en profondeur : leur origine est placée au pied du tronc, afin que le héros puisse passer derrière eux.
- Les deux points d'ancrage sont hors du masque jouable ; aucune case ni interaction n'est changée.
- Le héros Sylvestre reçoit une taille de rendu légèrement supérieure, une ombre plus douce et un repère au sol vert discret.
- Les réglages sont conditionnés explicitement à foret_sylve ; aucune autre carte n'est affectée.

Ce premier passage est une preuve technique d'occlusion et d'intégration. Il ne constitue pas encore la refonte complète du paysage.

## Étapes suivantes

### C — Construire les plans du paysage

- Décomposer la direction artistique validée en couches alignées sur la planche 1536 × 864.
- Prévoir un arrière-plan atmosphérique, un plan de végétation intermédiaire, les détails du sol et des éléments de premier plan.
- Définir des zones d'occlusion explicites autour des arbres et constructions, avec un tri cohérent selon la position du héros.
- Ajouter des variations discrètes de lumière, de brume et de végétation sans surcharger la lecture du terrain.

### Héros

- Comparer les sprites 2D animés existants aux modèles 3D de chaque classe.
- Évaluer une conversion en sprites 2D multi-vues avant d'envisager un rendu 3D temps réel dans la carte 2D.
- Harmoniser l'échelle, les ombres, les animations directionnelles, l'accélération et l'arrêt.
- Ne pas remplacer les contrôles ou le gameplay de la carte 2D.

### D — Lieux remarquables

- Remplacer progressivement les marqueurs génériques par des éléments contextualisés dans le décor.
- Garder une indication d'interaction suffisamment visible et accessible au tactile.
- Préserver strictement les positions existantes et les cinq entrées de donjon validées.

## Validation de Sylvestre

La Nation ne sera considérée comme terminée qu'après :
- tests de navigation et d'accessibilité de tous les POI ;
- vérification des cinq entrées de donjon ;
- contrôle des couches, de l'occlusion et des animations ;
- CI verte et exports Android Debug/Release ;
- validation visuelle sur appareil par le joueur.

La validation finale de Sylvestre est une décision explicite du joueur, pas une conséquence automatique d'une CI verte.
