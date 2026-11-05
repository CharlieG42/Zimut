# Évolution de référence — Zimut

> Document vivant : cette feuille de route est mise à jour à chaque livraison significative.
> Les statuts décrivent le travail réellement intégré et vérifié, pas les intentions.

## Principes directeurs

- Priorité à Android : lisibilité sur écran mobile, performances et zones tactiles confortables.
- Identité graphique : cartoon coloré, expressif et soigné, inspiré de Dofus/Waven et de l'animation peinte, sans imitation directe.
- Les modes Tactique, Aventure 2D, Aventure 3D et Conquête conservent leurs mécaniques et contrôles propres. Les ressources et la progression restent partagées.
- Préférer des changements ciblés, réversibles et testés. Pas de refonte globale sans nécessité.
- Préserver les données de gameplay : ne pas modifier le masque de Sylvestre, les coordonnées des POI, les collisions ni les chemins de déplacement sans validation visuelle explicite.
- Toute livraison indique clairement ce qui a été contrôlé par tests automatisés et ce qui reste à valider sur appareil.

## Vue d'ensemble des cinq étapes

| Étape | Chantier | Priorité | Statut |
|---|---|---:|---|
| 1 | Monde 2D et zone pilote Sylvestre | Très haute | En cours |
| 2 | Héros, monstres et animations | Très haute | En cours |
| 3 | Présentation des combats et effets de sorts | Haute | À venir |
| 4 | Monde Aventure 3D et cohérence des biomes | Moyenne | À venir |
| 5 | Interface, performances et robustesse technique | Continue | À venir |

---

## Étape 1 — Monde 2D et zone pilote Sylvestre

### Objectif
Faire de Sylvestre la référence de qualité du monde Aventure 2D, puis appliquer progressivement les règles visuelles aux autres Nations sans uniformiser leurs identités.

### Axes de travail
- Conserver le fond illustré existant et le traiter comme une couche indépendante du gameplay.
- Renforcer la lecture des sentiers, des contours de terrain et des différences de profondeur sans déplacer les cases de jeu.
- Améliorer l'intégration visuelle des ombres, de la lumière et des ambiances atmosphériques.
- Donner une présence claire aux POI : donjons, sanctuaires, camps, trésors et trouvailles, avec une hiérarchie visuelle lisible à distance et à proximité.
- Garder des effets subtils : feuilles, lucioles, brume, poussière ou braises selon la Nation.
- Adapter le nombre et le coût des effets au réglage de qualité graphique.

### Critères de validation
- Le fond illustré reste intact et indépendant des couches interactives.
- Les POI et les accès restent atteignables ; aucun masque, chemin, collision ou coordonnée n'est modifié sans preuve visuelle.
- La carte reste lisible à l'échelle générale et lors du zoom rapproché.
- Les effets restent fluides sur Android et leur densité respecte le réglage graphique.
- Vérifier Sylvestre en premier, puis contrôler que les profils des autres Nations ne régressent pas.

### Avancement
- Base existante confirmée : fond illustré Sylvestre, sentiers, falaises, POI animés et ambiances par biome/Nation.
- Livraison initiale : variation de profondeur des particules d'ambiance ; la profondeur module désormais leur taille et leur vitesse.
- Complément : les marqueurs de POI disposent d'une assise au sol (ombre et anneau de matière), d'un médaillon à double liseré et d'un libellé avec ombre portée pour améliorer leur séparation du décor. Les positions, dimensions interactives et données de terrain restent inchangées.
- Optimisation : les POI non découverts ne rafraîchissent plus leur rendu en continu.
- Ambiance Sylvestre : mélange de feuilles dérivantes et de lucioles à faible densité, avec halos localisés ; le type d'effet est résolu à la configuration et réutilisé pendant l'animation et le rendu.
- À poursuivre : contrôle visuel sur appareil, retouches fines des contours et des points d'intérêt à partir de captures annotées.
- **Précaution active :** ne pas retoucher le masque ni les coordonnées de Sylvestre sans capture annotée.

---

## Étape 2 — Héros, monstres et animations

### Objectif
Donner aux personnages une présence vivante et cohérente, avec des animations expressives, sans sacrifier la lisibilité tactique ni la stabilité des performances.

### Axes de travail
- Harmoniser progressivement proportions, échelle, orientation, contour et ombres des sprites.
- Améliorer les animations d'attente : respiration, micro-mouvements, variations de pose et compagnons.
- Soigner les déplacements : anticipation, foulée, accélération, arrêt et changement d'orientation.
- Renforcer les réactions : attaque, incantation, impact reçu, victoire et défaite.
- Donner aux monstres et aux boss des mouvements d'attente et des réactions qui reflètent leur silhouette et leur Nation.
- Préserver la compatibilité avec les sprites existants ; les poses dédiées sont utilisées lorsqu'elles existent, avec un repli propre sinon.

### Critères de validation
- Pas de mélange incohérent entre poses de face et de dos.
- Pas de changement brutal de taille entre les poses d'une même animation.
- Les silhouettes restent lisibles sur les décors clairs et sombres.
- Les animations n'interfèrent ni avec le ciblage ni avec l'ordre des tours.
- Les effets sont mesurés sur Android ; pas de boucle coûteuse ni de recalcul inutile par image.

### Avancement
- Base existante confirmée : poses multiples, variantes de dos, transitions, réactions aux impacts, ombres et contre-jours dans le combat.
- Base Aventure : marche, course, poses de repos, orientation, arrêt amorti et réaction positive du héros.
- Livraison initiale : respiration discrète du héros Aventure et micro-variations de respiration/balancement des groupes de monstres. Les variantes de repos déjà présentes dans les planches sont exploitées, avec ombres de contact individuelles.
- Complément : les groupes de monstres utilisent maintenant les poses `_walk` disponibles pendant leurs déplacements sur la carte ; en l'absence de planche de marche, le sprite de base reste utilisé.
- À poursuivre : audit des planches réellement disponibles par classe/Nation, puis combler les manques d'animations par lots cohérents.
- Audit automatisé initial (CI du 5 novembre 2026) : 657 fichiers de poses détectés, répartis en 22 `walk`, 20 `back_walk`, 61 `idle`, 60 `back_idle`, 138 `attack`, 130 `back_attack`, 114 `cast` et 112 `back_cast`. Aucun fichier de pose orphelin détecté. Ces volumes comptent des fichiers, pas des entités animées uniques ; ils ne prouvent donc pas à eux seuls une couverture complète de chaque héros ou ennemi. La prochaine passe doit établir les manques par sprite de base et par Nation avant de créer des assets.

---

## Étape 3 — Présentation des combats et effets de sorts

### Objectif
Rendre chaque action de combat immédiatement compréhensible et visuellement satisfaisante.

### Axes de travail
- Différencier les effets par classe, élément et Nation.
- Clarifier les prévisualisations de portée, de zone et de cible.
- Améliorer anticipation, impact, nombres de dégâts/soins, états et transitions de tour.
- Développer des signatures visuelles pour les boss, sans masquer les cases ni les unités.

### Critères de validation
- Les zones d'effet et les cibles restent compréhensibles sur petit écran.
- Les effets ne masquent pas les informations essentielles.
- Les coûts visuels sont compatibles avec les trois niveaux de qualité graphique.

### Avancement
- À venir. L'existant sera audité avant toute modification afin de conserver les effets déjà en place.

---

## Étape 4 — Monde Aventure 3D et cohérence des biomes

### Objectif
Faire progresser la qualité visuelle de l'Aventure 3D sans la rendre dépendante du gameplay 2D.

### Axes de travail
- Améliorer les transitions entre biomes, le relief, les silhouettes lointaines et les détails naturels.
- Harmoniser la direction artistique des héros, monstres, bâtiments et décors avec les Nations.
- Soigner caméra, zoom, interactions et lisibilité des chemins.
- Maintenir une implémentation et des contrôles indépendants du mode 2D.

### Critères de validation
- Les contrôles et règles du mode 3D restent autonomes.
- La progression et les ressources partagées restent cohérentes.
- Pas de régression de déplacement, de caméra ou de performance.

### Avancement
- À venir. Le mode 3D sera traité après stabilisation des deux premières étapes.

---

## Étape 5 — Interface, performances et robustesse technique

### Objectif
Consolider la qualité générale du jeu et réduire les risques de régression à chaque évolution.

### Axes de travail
- Unifier progressivement les composants visuels des fiches, inventaires, équipements, sorts, quêtes, Nations et récompenses.
- Maintenir des cibles tactiles adaptées au mobile et des états de boutons explicites.
- Optimiser textures, planches, chargement/libération des ressources, particules et reconstructions de cartes.
- Préserver l'intégrité des sauvegardes et prévoir les migrations de données.
- Étendre les tests automatisés aux scènes, accès aux POI, ressources partagées et assets des Nations.
- Conserver des niveaux de qualité graphique et des diagnostics utiles.

### Critères de validation
- Les parcours courants sont testés sur Android.
- Les tests automatisés couvrent les fonctions touchées.
- Les erreurs de chargement d'assets et les régressions de sauvegarde sont détectées avant livraison.
- Les performances sont observées sur appareil réel, pas seulement en headless.

### Avancement
- Travail transversal obligatoire à chaque étape.
- À venir : définir un bilan de performance de référence sur appareil et renforcer les contrôles de chargement.

---

## Journal des livraisons

### 2026-11-05 — Ambiance Sylvestre (complément)
- Réintégration sur la base incluant les PR #262 et #263.
- Mélange de feuilles et de lucioles à faible densité, avec dérive lente, halos localisés et profondeur conservée.
- Le type d'ambiance est calculé une fois à la configuration et réutilisé dans les boucles d'animation et de dessin.
- Tests statiques étendus ; validation CI de cette réintégration à venir.


### 2026-11-05 — Résultat de l'audit des animations
- 657 fichiers de poses recensés : 22 marche face, 20 marche dos, 61 repos face, 60 repos dos, 138 attaques face, 130 attaques dos, 114 incantations face et 112 incantations dos.
- 0 pose orpheline : chaque fichier d'animation analysé possède un sprite de base dans son dossier ou dans le dossier parent.
- CI réussie : tests headless et exports APK Debug/Release. La couverture par personnage reste à détailler ; le nombre de fichiers ne signifie pas que chaque entité possède toutes les animations.


### 2026-11-04 — Audit des ressources d'animation
- Ajout d'un test headless qui inventorie les poses `walk`, `idle`, `attack` et `cast` (face/dos) dans les dossiers de sprites des Nations et des familiers.
- Le contrôle signale les poses orphelines dont le sprite de base est absent ; les manques de couverture restent informatifs afin de ne pas bloquer la livraison lorsqu'une animation n'a pas encore été créée.
- Après analyse des journaux CI, le test a été déplacé après l'import Godot et rendu bloquant indépendamment : les erreurs de chargement précédentes ne doivent plus être masquées par la boucle de tests tolérante.
- Validation CI du 5 novembre 2026 : test d'inventaire exécuté après import Godot, 657 poses détectées et 0 pose orpheline ; tests GDScript et exports APK Debug/Release réussis.

### 2026-11-04 — Complément des étapes 1 et 2
- La CI de la première livraison a réussi : tests GDScript, exports APK Debug et Release.
- Les particules utilisent désormais la profondeur pour leur taille et leur vitesse.
- Les groupes de monstres exploitent les poses alternatives de repos disponibles et disposent d'ombres de contact par silhouette.
- Les poses `_walk` existantes sont maintenant jouées pendant le déplacement des groupes ; repli automatique sur le sprite de base si aucune pose n'est présente.
- Les POI reçoivent une assise au sol, un anneau de matière et un médaillon à double liseré avec libellé ombré ; aucune coordonnée ni zone interactive n'est modifiée.
- Les POI non découverts ne rafraîchissent plus leur rendu en continu.
- Ajout de contrôles automatisés pour ces comportements ; validation visuelle Android toujours attendue.

### 2026-11-04 — Initialisation de la feuille de route
- Création de cette référence.
- Démarrage des étapes 1 et 2 : profondeur des particules d'ambiance, animation organique discrète du héros et des groupes de monstres.
- Les validations CI et appareil seront consignées après exécution ; aucune réussite n'est présumée à la création de cette version.
