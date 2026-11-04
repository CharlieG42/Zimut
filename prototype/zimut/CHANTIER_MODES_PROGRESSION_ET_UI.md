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

## Plan détaillé des prochaines améliorations

Les étapes sont volontairement petites et vérifiables. Sylvestre reste la zone pilote ; les autres Nations recevront ensuite les mêmes systèmes avec leurs propres palettes, végétations et effets. Le décor peint des cartes n'est pas remplacé.

### Étape A — Sensations et lisibilité du héros
<small>Intégré à cette tranche : poses de repos stabilisées, transition de demi-tour, amortissement des départs/arrêts et ombre de contact sensible à la profondeur.</small>
- Stabiliser les poses de repos alternatives et vérifier qu'elles ne changent pas pendant la marche ou une action.
- Ajouter une transition de demi-tour lisible, sans miroir incohérent pour les armes, compagnons ou accessoires.
- Renforcer l'anticipation au départ et l'amortissement à l'arrêt ; conserver une foulée courte sur les petits déplacements et la course légère sur les longs.
- Faire varier subtilement l'ombre de contact avec l'échelle de profondeur pour que les pieds restent ancrés au sol.
- Critères : aucune pose manquante ne bloque l'animation ; retour au repos garanti après chaque déplacement ; aucune modification des commandes ou du chemin calculé.

### Étape B — Environnement illustré plus vivant
<small>Base intégrée : couche d'ambiance indépendante et densité des particules reliée au réglage graphique Auto/Économie/Haute. La végétation de premier plan reste à valider visuellement avant tout placement sur la carte annotée.</small>
- Ajouter une végétation de premier plan en petites touffes ou silhouettes, uniquement aux emplacements validés comme praticables et sans masquer les points d'intérêt.
- Faire passer le héros derrière les éléments hauts lorsque leur profondeur le demande ; garder les éléments de premier plan devant ses jambes.
- Enrichir l'ambiance de Sylvestre avec quelques lucioles/pollens à trajectoires lentes, une variation de lumière très douce et des feuilles au vent. Garder les particules rares et de petite taille.
- Préparer des profils de qualité : densité réduite et effets désactivables sur les appareils Android modestes.
- Décliner les mêmes principes avec des effets propres à chaque Nation (brume, braises, embruns, poussière, cristaux), sans copier-coller une ambiance unique.
- Critères : illustration originale intacte ; héros toujours lisible ; pas d'effet sur la navigation, les zones tactiles ou les performances au-delà du budget défini.

### Étape C — Interactions contextuelles
<small>Intégré à cette tranche : action contextuelle disponible à une case pour les POI, trouvailles et portes ouvertes ; l'activation emprunte le déplacement normal pour conserver les règles de navigation et de récompense.</small>
- Afficher une indication de proximité cohérente pour les coffres, ressources, PNJ, sanctuaires, entrées de donjon et portails.
- Au contact, proposer une action explicite et adaptée au type d'objet ; distinguer une porte traversée d'une destination à activer.
- Ajouter un retour visuel et sonore optionnel à l'activation, puis un récapitulatif compact de la récompense.
- Prévoir l'accessibilité tactile : zones d'appui généreuses, priorité à l'icône visible, aucune dépendance à un appui précis sur une petite case.
- Critères : une interaction ne se déclenche qu'une fois ; les objets déjà consommés sont visuellement différenciés ; l'action reste possible sans précision de souris.

### Étape D — Récompenses et progression commune
<small>Audit confirmé : les vues Aventure 2D, 3D isométrique et 3D ouverte instancient le même AdventureManager et lisent la même sauvegarde. Les trois affichent maintenant le sac de ressources commun ; les récompenses d'exploration passent par ProgressionManager (XP, or, objets, ressources). La centralisation complète des flux Tactique/Conquête et les tests de persistance croisée restent à étendre.</small>
- Cartographier les points d'entrée/sortie de récompense de Tactique, Découverte 2D, Découverte 3D et Conquête.
- Centraliser les ajouts d'XP, d'or, d'objets et de ressources dans les services de progression partagés.
- Vérifier la persistance après changement de mode, retour au menu, sauvegarde et rechargement.
- Ajouter des tests anti-duplication et anti-perte, notamment lorsqu'un combat est lancé depuis l'exploration.
- Critères : même inventaire et même roster dans les quatre modes ; aucune position/caméra/armée locale écrasée par un autre mode.

### Étape E — Cohérence de l'interface et validation Android
<small>Les réglages de taille de texte, qualité graphique et adaptations d'écran existent déjà. Reste la campagne de vérification tactile multi-format et la mesure sur appareils Android réels.</small>
- Harmoniser les panneaux contextuels, les couleurs d'accent, la typographie et les retours d'action sans ajouter un HUD permanent chargé.
- Vérifier les petits écrans, les orientations prises en charge, les zones sûres et les gestes tactiles.
- Mesurer le coût des animations et particules ; réduire automatiquement les effets décoratifs si nécessaire.
- Critères : texte lisible, aucun bouton recouvert, retour au mode appelant correct, framerate stable sur l'appareil de référence.

### Ordre de livraison proposé
1. Finir A et C sur Sylvestre, avec tests de non-régression.
2. Réaliser B par couches indépendantes et faire valider le rendu avant de le décliner aux autres Nations.
3. Traiter D avec tests couvrant les quatre modes et les sauvegardes.
4. Finaliser E et seulement ensuite généraliser les améliorations graphiques à l'ensemble des zones.

Chaque étape sera livrée dans une PR distincte ou dans une tranche clairement isolée, sans fusion automatique.

## Première livraison

Cette première tranche rend visibles les ressources de la sauvegarde commune dans l'exploration 2D et dans le HUD du monde ouvert 3D. Elle ajoute des vérifications statiques au test de séparation des modes. Elle ne prétend pas terminer les cinq phases : elle pose le contrat commun et ouvre le chantier par une amélioration transversale vérifiable.
