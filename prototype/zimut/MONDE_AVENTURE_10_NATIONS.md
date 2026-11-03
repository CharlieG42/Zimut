# Monde Aventure — architecture des 10 Nations

> Document de conception et d'intégration — novembre 2026  
> Statut : direction artistique validée pour la Nation Sylvestre ; intégration de la nouvelle illustration à finaliser.

## 1. Vision validée

Le monde de Zimut est constitué de **10 grandes Nations**. Chaque Nation est un territoire continu, parcourable librement en vue isométrique 2.5D. Le joueur ne sélectionne pas une succession de petits niveaux : il se déplace sur une grande carte vivante, dont les donjons, villages, camps de monstres et lieux remarquables font partie du décor.

Deux niveaux de carte sont nécessaires :

- **Carte du monde** : vue synthétique des dix Nations, leurs frontières naturelles, leurs liaisons et leur état de découverte. Peu de détails ; elle sert à se repérer et voyager.
- **Carte détaillée d'une Nation** : illustration complète du territoire, avec les lieux importants, les entrées de donjon, les zones de monstres et les découvertes. C'est la carte d'exploration jouable.

La Nation Sylvestre est la première référence visuelle et fonctionnelle. Sa carte approuvée comporte cinq donjons : quatre répartis aux extrémités nord-ouest, nord-est, sud-ouest et sud-est, et un donjon majeur au centre.

## 2. État du prototype existant

Le prototype contient déjà plusieurs fondations à conserver :

- `AdventureMapUI.gd` : rendu de la carte, déplacement, interactions, héros, mobs, POI et défilement.
- `AdventureManager.gd` : état d'exploration, sauvegarde, brouillard, récompenses et ponts vers les autres modes.
- `AdventureTerrain.gd` : grille, chemins, obstacles et trouvailles.
- `BoardArt.gd` + `data/boards/foret_sylve.json` : planche illustrée, masque de cases praticables, point de départ et POI.
- `ProgressionManager.gd` : catalogue des zones, donjons, énigmes et progression.
- `AdventureLandscape.gd` : environnement et profondeur autour de la carte.

La définition actuelle de `foret_sylve` référence déjà cinq donjons dans `data/boards/foret_sylve.json`. Il faut préserver leurs identifiants de gardien et leurs liens avec le système `Dungeons`, ainsi que les positions sauvegardées du héros et des mobs.

Le scrolling de la carte existe déjà. La prochaine intégration doit donc s'appuyer sur ce système plutôt que créer une seconde caméra ou un système de déplacement concurrent.

## 3. Contenu attendu par Nation

Chaque Nation doit pouvoir accueillir, sans surcharge visuelle :

- **4 à 5 donjons** avec entrées physiques reconnaissables et gardiens distincts ;
- plusieurs territoires de monstres de niveaux progressifs, avec groupes errants ;
- des villages, hameaux, avant-postes et PNJ ;
- des coffres, reliques, ressources et caches cachées ;
- des énigmes environnementales et sanctuaires ;
- des camps de repos et points de vue ;
- des raccourcis, ponts, passages secrets et chemins alternatifs ;
- des éléments de lore et découvertes qui donnent une raison d'explorer les zones éloignées.

Les points remarquables doivent récompenser l'exploration par de l'XP, de l'or, des ressources, des équipements, des objets de collection ou des informations de lore. Les récompenses uniques doivent être persistantes dans la sauvegarde commune et ne pas être réattribuées après rechargement.

## 4. Règles de conception de la carte détaillée

### 4.1 Géographie

Chaque carte doit former un seul territoire cohérent, avec des régions naturelles différenciées. Les chemins principaux relient les lieux structurants ; les chemins secondaires et passages cachés récompensent la curiosité.

Les cinq donjons de la Sylvestre doivent rester bien séparés et visibles à l'échelle de la carte. Le donjon central est le point culminant narratif et visuel. Les quatre donjons périphériques doivent guider l'exploration sans enfermer le joueur dans un ordre rigide, sauf verrouillage de progression explicitement défini.

### 4.2 Éléments interactifs et décor

Séparer strictement :

1. le fond illustré (relief, sol, eau, grandes masses végétales) ;
2. les éléments de décor statiques indépendants (arbres, rochers, ruines, bâtiments) ;
3. les éléments interactifs (donjons, coffres, énigmes, récoltes, PNJ) ;
4. les entités dynamiques (héros, monstres, compagnons, effets).

Les noms, niveaux, états, marqueurs de quête et récompenses ne doivent jamais être peints dans l'illustration. Ils sont rendus par Godot, afin de rester lisibles, localisables et accessibles.

Les éléments devant masquer le héros doivent participer au tri de profondeur (Y-sort ou couches de premier plan). Les zones de collision et les zones cliquables doivent être distinctes de la simple silhouette graphique.

### 4.3 Navigation mobile

- Garder une échelle minimale garantissant la lecture des lieux ; ne jamais réduire la Nation entière pour la faire tenir à l'écran.
- Conserver le déplacement par glissement tactile de la carte et le recentrage sur le héros.
- Ajouter des contrôles de zoom progressif avec limites min/max et zoom centré sur le point touché.
- Ajouter un bouton « recentrer sur le héros » toujours accessible.
- Prévoir un mini-plan local discret, avec position du héros, donjons découverts et objectifs actifs.
- La carte globale des Nations doit rester une vue séparée, moins détaillée, et ne pas remplacer la carte locale.
- Ne pas charger simultanément les dix cartes détaillées : charger uniquement la Nation active et libérer ses ressources en quittant la carte.

## 5. Architecture de données recommandée

À terme, chaque Nation doit être décrite par des données, et non par des conditions codées en dur dans l'interface :

- identifiant stable et nom localisé ;
- biome, palette, ambiance audio et effets météo ;
- dimensions de l'illustration et échelle monde ;
- grille / masque de navigation ou navigation polygonale ;
- point de départ et points de sortie ;
- POI typés et leurs identifiants persistants ;
- donjons et identifiants de gardiens ;
- régions de monstres, niveaux et tables de butin ;
- objets de découverte et récompenses ;
- liens vers les autres Nations.

Les identifiants existants doivent être conservés lors de la migration afin de ne pas invalider les sauvegardes. La carte du monde doit référencer les Nations par identifiant, jamais par leur nom affiché.

## 6. Performance et rendu

- Préférer une grande illustration compressée en texture adaptée à Android, avec dimensions maîtrisées et mipmaps si le zoom arrière le nécessite.
- Découper les éléments indépendants en atlas ou sprites séparés ; éviter une texture géante pour chaque petit objet.
- Utiliser le culling hors écran pour les décors et entités.
- Ne mettre à jour les effets animés que dans la zone visible.
- Garder les collisions simples et limiter les objets physiques.
- Tester la mémoire GPU, le temps de chargement et la fluidité sur un appareil Android réel.
- Prévoir un niveau de détail réduit pour les appareils modestes.

## 7. Carte du monde des dix Nations

La carte synthétique devra afficher les dix Nations déjà prévues par le lore :

1. Nation Sylvestre
2. Nation des Cimes
3. Nation des Sables
4. Nation des Ombres
5. Nation des Vents
6. Nation des Marées
7. Nation du Brasier
8. Nation des Cristaux
9. Nation des Brumes
10. Nation des Rouages

Cette carte montrera les territoires, les grandes voies de liaison et les accès débloqués. Elle ne doit pas reprendre le détail des coffres, monstres ou énigmes des cartes locales.

## 8. Plan d'intégration proposé

### Étape 1 — Nation Sylvestre, référence jouable
- Remplacer l'illustration actuelle de `assets/boards/foret_sylve.jpg` par la nouvelle illustration validée, après préparation de l'image source et contrôle de ses dimensions.
- Recaler le masque de navigation sur les chemins réellement visibles.
- Vérifier le point de départ, les cinq entrées de donjon et les zones praticables.
- Ajouter des zones de monstres, découvertes, coffres et énigmes sans déplacer les POI persistants déjà utilisés par les sauvegardes.
- Tester déplacement, scrolling, interactions, récompenses, combats et retour depuis un donjon.

### Étape 2 — Navigation et lisibilité
- Ajouter le zoom tactile progressif et ses limites.
- Ajouter un mini-plan local et une légende filtrable.
- Ajouter un panneau d'information au toucher sur les donjons et points remarquables.
- Renforcer le feedback de découverte sans surcharger la carte.

### Étape 3 — Monde global
- Créer la carte synthétique des dix Nations.
- Gérer déverrouillage, découverte, voyage et prérequis entre Nations.
- Conserver une progression partagée entre Aventure, Tactique et Conquête.

### Étape 4 — Industrialisation
- Extraire les données communes dans un catalogue de Nations.
- Définir un gabarit d'assets et un pipeline de préparation des cartes.
- Décliner le système sur les neuf autres territoires.
- Profiler les performances sur Android.

## 9. Intégration initiale du nouveau fond

Le fond de la Nation Sylvestre a été ajouté au dépôt sur `main` sous le nom exact :

`assets/boards/Sylvestre.png`

La définition `data/boards/foret_sylve.json` est mise à jour dans la branche de travail pour référencer ce PNG. La grille actuelle reste de 96 × 64 cases, avec un masque de déplacement existant et 18 points d'intérêt, dont les cinq donjons. Les coordonnées ne sont pas déplacées automatiquement : elles devront être validées visuellement sur la nouvelle illustration avant d'ajouter de nouveaux POI.

Dans `AdventureMapUI.gd`, la carte illustrée conserve son défilement et le recentrage sur le héros. Le zoom a été ajouté :
- pincement à deux doigts sur écran tactile ;
- boutons + / − à l'écran pour les appareils mobiles ;
- molette de souris en test sur ordinateur ;
- zoom centré sur le point visé, avec limites pour préserver la lisibilité.

Les contrôles de zoom ne modifient pas la position logique du héros ni la grille de déplacement.

## 10. Critères d'acceptation de la Nation Sylvestre

- La carte complète est parcourable sans réduire son échelle à l'écran.
- Le héros se déplace uniquement sur les chemins et surfaces praticables.
- Les cinq donjons sont visibles, distincts et interactifs.
- Les éléments de décor peuvent masquer correctement le héros selon la profondeur.
- Les monstres de champs sont visibles dans les zones découvertes et déclenchent le combat existant.
- Les coffres, énigmes et découvertes donnent des récompenses persistantes.
- Le mini-plan et les panneaux restent lisibles sur écran Android paysage.
- Les modes Tactique et Conquête et les sauvegardes existantes ne régressent pas.
