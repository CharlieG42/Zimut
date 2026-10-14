# Modes Aventure et Conquête — première intégration

Cette première étape ajoute deux parcours au projet principal `prototype/zimut`, sans créer de sauvegardes séparées.

## Principe de progression partagée

Chaque mode utilise le même fichier `user://saves/partie_N.json` et les mêmes champs communs :
- `roster` : XP, niveaux, caractéristiques et niveaux de sorts des classes ;
- `team` : équipe sélectionnée et équipement ;
- `inventory`, `resources`, `gold` : butin et ressources.

Les champs `adventure` et `conquest` ne contiennent que l'état propre à leur campagne. Ils sont ajoutés à la sauvegarde existante et ne remplacent aucun champ historique.

## Mode Aventure

- Carte forestière en grille, déplacement case par case.
- Sanctuaire avec une première énigme, coffre donnant de l'XP et un objet, camp gobelin ouvrant la sélection d'équipe et le combat tactique.
- Position, pas parcourus, lieux découverts et défis terminés persistés dans `adventure`.
- Après le combat, le bouton de résultat ramène à la carte d'aventure. Le défi de combat n'est validé qu'en cas de victoire.

## Mode Conquête

- Carte de cinq villes : capitale de départ, villages neutres et avant-postes ennemis.
- Sélection d'une ville et lancement d'un assaut dans le combat tactique existant.
- La difficulté de la bataille est basée sur le niveau de la ville ciblée.
- Une victoire valide la conquête et l'ajoute au territoire ; une défaite ne la valide pas et permet de retenter.
- Après le résultat de combat, retour à la carte de conquête.

## Limites assumées de cette ébauche

- Une seule région forestière et quelques lieux fixes ; la carte procédurale, le brouillard de guerre, les déplacements libres, les énigmes à plusieurs étapes et les autres biomes viendront ensuite.
- Les combats de campagne réutilisent le système tactique actuel. Les garnisons propres à chaque ville, les objectifs de combat dédiés et les récompenses économiques de conquête restent à approfondir.
- L'économie de Conquête (production, bâtiments, recrutement d'armées, IA ennemie et expansion sur la carte) n'est pas encore simulée.
- La direction artistique reste dans la palette, les bordures et les panneaux de Zimut ; ces écrans sont une base fonctionnelle, pas encore la passe graphique finale.

## Vérifications à effectuer dans Godot

1. Ouvrir `prototype/zimut/project.godot` avec Godot 4.7.
2. Importer le projet, puis lancer une sauvegarde existante ou en créer une.
3. Depuis « Mes parties », ouvrir Aventure : se déplacer, ouvrir le coffre et tester le camp gobelin.
4. Depuis « Mes parties », ouvrir Conquête : attaquer une ville, gagner puis vérifier qu'elle apparaît comme territoire allié ; recommencer et perdre pour vérifier qu'elle reste ennemie.
5. Vérifier que l'XP, les loots, les caractéristiques, les sorts et l'équipement restent identiques lorsqu'on change de mode.

La validation runtime Godot/Android reste nécessaire avant de considérer cette PR comme prête à fusionner.
