# Sylvestre — refonte visuelle de la carte 2D

> Chantier prioritaire exclusif jusqu'à validation explicite de Sylvestre.
> Aucune autre Nation ne doit recevoir de nouvelle carte, de décor, de héros ou de travail graphique avant cette validation.

## Ordre de priorité

1. **C — Profondeur réelle du décor** : reconstruire l'environnement à partir de plans cohérents avec la géométrie et la composition de la carte existante.
2. **Héros** : l'intégrer à ces plans avec une échelle, une lumière, des ombres et des occultations cohérentes.
3. **D — Lieux remarquables** : intégrer les donjons, sanctuaires, coffres et camps sans déplacer leurs coordonnées ni modifier leurs interactions.

## Contraintes

- Périmètre exclusif : `foret_sylve`.
- Les modes Aventure 2D et 3D restent indépendants côté gameplay et contrôles.
- La progression et les ressources communes ne changent pas.
- Ne pas modifier le masque, les chemins, les collisions, les coordonnées des POI, les entrées de donjon ni les déplacements.
- Les ajouts graphiques ne doivent jamais masquer les zones jouables ou les interactions tactiles.
- Préserver les performances Android.

## État après correction

Les couches décoratives plein cadre et les arbres flottants ajoutés dans la première tentative ont été retirés : ils masquaient la planche et ne constituaient pas un vrai décor en profondeur. La planche originale reste la seule base visuelle jusqu'à la reconstruction cohérente de l'environnement.

## Critères d'acceptation du point C

- Un arrière-plan lointain peint, cohérent avec la perspective et la composition du terrain.
- Des plans intermédiaires qui encadrent les chemins sans recouvrir les zones de déplacement.
- Un sol illustré qui fait partie du paysage, et non une texture indépendante plaquée.
- Des éléments de premier plan limités à des zones d'occlusion définies, testées avec le héros.
- La profondeur doit être perceptible en capture de jeu, sans perte de lisibilité.
- Les chemins, les cinq entrées de donjon et tous les POI restent exactement aux mêmes coordonnées.

La simple présence de feuillages, d'effets de lumière ou de sprites au premier plan ne valide pas le point C.
