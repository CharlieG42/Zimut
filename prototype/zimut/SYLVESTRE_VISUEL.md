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

## Passe actuelle — profondeur, héros et intégration des lieux

- Trois couches transparentes : lumière/brume atmosphérique, lisière forestière intermédiaire et canopée de premier plan.
- Six arbres indépendants à ancrage Y-sorté sur les marges, avec le pied du tronc comme origine.
- Les arbres sont des nœuds indépendants dans le conteneur trié en profondeur : leur origine est placée au pied du tronc, afin que le héros puisse passer derrière eux.
- Les deux points d'ancrage sont hors du masque jouable ; aucune case ni interaction n'est changée.
- Le héros Sylvestre reçoit une taille de rendu légèrement supérieure, une ombre plus douce et un repère au sol vert discret.
- Les lieux Sylvestre reçoivent une assise organique de mousse et de pierres, sans déplacement ni changement de zone tactile.
- Les réglages sont conditionnés explicitement à foret_sylve ; aucune autre carte n'est affectée.

Les couches sont statiques, alignées sur la taille de la planche et placées sous les entités ; la canopée cadre le plateau sans modifier la zone jouable. La validation visuelle finale reste à faire sur appareil.

## Étapes suivantes

### C — Consolider les plans du paysage

- Vérifier l'alignement et le dosage des couches après capture en jeu.
- Étendre les zones d'occlusion aux grands arbres et constructions réellement présents dans l'illustration.
- Ajuster lumière et brume pour conserver un contraste suffisant sur les chemins et les POI.

### Héros

- Comparer les sprites 2D animés existants aux modèles 3D de chaque classe.
- Évaluer une conversion en sprites 2D multi-vues avant d'envisager un rendu 3D temps réel dans la carte 2D.
- Harmoniser l'échelle, les ombres, les animations directionnelles, l'accélération et l'arrêt.
- Ne pas remplacer les contrôles ou le gameplay de la carte 2D.

### D — Lieux remarquables

- Première intégration : assises de mousse et pierres pour les POI Sylvestre, avec repères d'interaction conservés.
- Finition à prévoir : contextualiser les cinq entrées de donjon et sanctuaires par des éléments dédiés, sans déplacer leurs positions.
- Garder une indication d'interaction visible et accessible au tactile.
- Préserver strictement les cinq entrées de donjon validées.

## Validation de Sylvestre

La Nation ne sera considérée comme terminée qu'après :
- tests de navigation et d'accessibilité de tous les POI ;
- vérification des cinq entrées de donjon ;
- contrôle des couches, de l'occlusion et des animations ;
- CI verte et exports Android Debug/Release ;
- validation visuelle sur appareil par le joueur.

La validation finale de Sylvestre est une décision explicite du joueur, pas une conséquence automatique d'une CI verte.
