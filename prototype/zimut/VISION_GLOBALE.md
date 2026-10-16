# Zimut — vision globale du jeu

> Document de référence transversal pour aligner la direction artistique, la technique et le gameplay.  
> Statut : **direction validée, mise en œuvre progressive**.  
> Ce document décrit les intentions validées ; il ne signifie pas que tous les éléments sont déjà intégrés au jeu.

## 1. Vision

Zimut est un RPG tactique multiplateforme, avec priorité à Android, combinant des combats au tour par tour, une aventure d'exploration et un mode Conquête stratégique. Les modes partagent la progression du joueur : héros/classes, expérience, équipement, inventaire, ressources et réglages doivent rester cohérents entre les modes.

Références d'ambiance : lisibilité tactique inspirée de jeux comme Dofus Touch et Waven, sans chercher à copier exactement leur direction artistique. Zimut doit conserver sa propre identité.

## 2. Piliers de gameplay

- **Tactique** : combats au tour par tour lisibles, placement sur grille, sorts distincts, coûts PA/PM/PO clairement indiqués et décisions significatives.
- **Aventure** : exploration d'un monde, découvertes, défis de réflexion et combats tactiques.
- **Conquête** : carte stratégique, routes entre les villes, choix de cibles, assauts tactiques, annexions, économie et développement de l'empire.
- **Progression partagée** : les gains et les choix persistants du roster sont réutilisables entre les modes.
- **Sessions accessibles sur mobile** : contrôles tactiles fiables, texte lisible, interfaces adaptées au paysage et possibilité de faire défiler les grandes cartes.

## 3. Direction artistique

### 3.1 Identité générale

- Univers fantasy coloré, chaleureux et expressif.
- Personnages et lieux stylisés, silhouettes immédiatement reconnaissables.
- Vue 3/4 ou isométrique pour les personnages et environnements de combat, adaptée à la grille.
- Priorité à la lisibilité du gameplay : les décors enrichissent l'expérience sans masquer unités, cases, routes ou informations.
- Illustrations peintes et détaillées pour les grands paysages ; éléments d'interface séparés, modifiables et interactifs.
- Éviter les décors de carte composés uniquement de rectangles, cadres géométriques ou symboles répétitifs.

### 3.2 Carte du monde et mode Conquête

La carte du monde doit être un **fond illustré de grande taille**, plus large et plus haut que la fenêtre, parcourable horizontalement et verticalement. Le fond donne le relief, les côtes, les rivières, les montagnes, les forêts et les régions ; Godot dessine au-dessus les villes interactives, routes, états territoriaux et sélections.

Le fond ne doit contenir ni noms de villes, ni boutons, ni légendes incrustés : ces éléments doivent rester indépendants pour pouvoir évoluer avec le jeu.

Les villes ne doivent plus être représentées par de simples rectangles. À terme, elles utilisent des sprites illustrés détourés sur fond transparent, choisis selon leur type (village, cité, capitale, port, forteresse, temple, donjon, repaire de boss). L'état du territoire doit être signalé discrètement par un halo, une bordure ou un emblème, sans dénaturer le sprite.

Routes, marqueurs et villes doivent rester alignés avec le fond lors du défilement. Le panneau Conseil de guerre reste une interface indépendante.

## 4. Nations — concept validé, système à concevoir

Les Nations sont une future couche de fiction, d'identité visuelle et potentiellement de gameplay. Leurs noms et thèmes sont validés comme direction créative ; ils ne sont pas encore une fonctionnalité de jeu complète. Les Nations ne doivent pas être confondues avec les couleurs territoriales actuelles (allié, neutre, ennemi).

Première liste de Nations proposées :

| Nation | Affinité | Identité visuelle et lieux |
|---|---|---|
| **Nation Sylvestre** | Forêt / nature | Cités arboricoles, villages de clairière, forteresses de bois, sanctuaires vivants |
| **Nation des Cimes** | Glace / montagne | Citadelles enneigées, cols, mines, monastères de haute altitude |
| **Nation des Sables** | Désert | Cités de grès, caravanes, oasis, marchés et ports désertiques |
| **Nation des Ombres** | Ruines / ténèbres | Nécropoles, temples oubliés, architectures anciennes, donjons |
| **Nation des Vents** | Air | Îles flottantes, ponts suspendus, tours aériennes, sanctuaires dans les nuages |
| **Nation des Marées** | Eau | Archipels, ports fortifiés, cités côtières, récifs et temples immergés |
| **Nation du Brasier** | Feu | Volcans, basalte, forges monumentales, rivières de lave |
| **Nation des Cristaux** | Magie / cristal | Montagnes cristallines, gisements lumineux, cités imprégnées d'énergie magique |
| **Nation des Brumes** | Marais | Marécages, champignons géants, villages sur pilotis, ruines englouties |

### Règle d'extension par classe

Le catalogue actuel de `ProgressionManager.CLASS_ORDER` contient huit classes : **Tank, Assassin, Chasseur, Mage, Druide, Heal, Invocateur et Sylvain**. La correspondance ci-dessous est une **proposition de direction artistique**, pas encore une règle de gameplay ni une appartenance exclusive.

| Classe | Nation / identité visuelle proposée | Intention |
|---|---|---|
| **Tank** | Nation des Cimes | Armures lourdes, remparts, bastions et citadelles de montagne |
| **Assassin** | Nation des Ombres | Ruelles secrètes, ruines, silhouettes discrètes et forteresses nocturnes |
| **Chasseur** | Nation Sylvestre | Avant-postes forestiers, tours de guet et villages de chasseurs |
| **Mage** | Nation des Cristaux | Observatoires, tours arcanes et architectures cristallines |
| **Druide** | Nation Sylvestre, avec liens possibles aux Brumes | Sanctuaires vivants, bosquets sacrés et marais enchantés |
| **Heal** | Nation des Marées | Temples d'eau, sanctuaires côtiers et cités de guérisseurs |
| **Invocateur** | Nation des Brumes, avec liens possibles aux Ombres | Cercles d'invocation, marais mystérieux et nécropoles |
| **Sylvain** | Nation Sylvestre | Cités arboricoles, clairières sacrées et forteresses de bois |

Les Nations des **Vents** et du **Brasier** sont également réservées comme grandes régions du monde et pourront accueillir des villes, des factions ou des quêtes liées à plusieurs classes. Une classe n'est pas obligée d'être exclusivement associée à une seule Nation.

Avant d'en faire un système officiel, vérifier les mécaniques et le lore déjà associés aux classes, puis valider les correspondances avec le game design.

### Sprites de villes et de cités

Prévoir une bibliothèque cohérente de sprites PNG avec transparence, à une échelle homogène et avec une marge suffisante pour le rendu mobile. Catégories initiales :
- hameau / village ;
- bourg / cité ;
- capitale ;
- forteresse / garnison ;
- mine / forge ;
- port / cité insulaire ;
- temple / sanctuaire ;
- ruines / nécropole ;
- donjon / repaire de boss.

Les variantes par Nation partageront une silhouette et une qualité de rendu cohérentes, mais utiliseront matériaux, toitures, végétation, lumières et ornements distinctifs. Les sprites restent séparés du fond de carte.

## 5. Architecture technique et contraintes

- Moteur : Godot 4.7, prototype 2D isométrique, export Android prioritaire.
- Garder les scènes et scripts de gameplay responsables des interactions ; les illustrations servent de ressources visuelles et ne remplacent pas la logique.
- Carte de Conquête : fond en texture, couche de routes, couche de villes interactives, sélection/indicateurs, panneau Conseil de guerre indépendant.
- Le défilement doit déplacer fond et éléments de carte ensemble, sans déplacer le panneau latéral.
- Les textes et marqueurs doivent rester lisibles à la résolution mobile cible.
- Les ressources importées doivent être suivies dans Git et vérifier leur présence dans la branche testée.
- Toute modification de carte doit préserver l'identifiant, les données, les règles et les routes des villes, sauf décision de gameplay explicite.
- Ne pas considérer une modification comme validée avant d'avoir lancé les tests concernés et, si possible, vérifié une build Android.

## 6. Règles de lisibilité

- Le statut territorial (allié / neutre / ennemi) reste immédiatement compréhensible.
- Le biome ou la Nation doit se lire par l'illustration, les matériaux et un emblème ; il ne remplace pas le statut territorial.
- Les noms de villes restent du texte dynamique, jamais intégrés à l'image de fond.
- Les routes doivent rester visibles sur les paysages complexes, sans couvrir les points d'intérêt importants.
- Les éléments sélectionnés doivent être identifiables, mais les effets lumineux restent sobres.
- La priorité est la clarté du jeu, pas la densité décorative.

## 7. Feuille de route artistique et technique

1. **Fond du monde** : intégrer la carte illustrée validée comme ressource, définir ses dimensions réelles et calibrer les coordonnées des villes et routes.
2. **Placement des villes** : placer les 28 villes existantes dans les régions correspondantes, sans modifier leurs identifiants ou leur logique de conquête.
3. **Sprites de villes** : premier lot intégré dans la branche : quatre illustrations SVG transparentes (forêt, montagne, désert, donjon) sont affichées au-dessus de petites plaques de nom portant le statut territorial. Étape suivante : enrichir les variantes par type de cité et par Nation, puis valider le rendu sur Android.
4. **Lisibilité** : ajuster noms, emblèmes, halos de territoire, routes, sélection et défilement sur Android paysage.
5. **Nations** : vérifier les classes existantes, proposer une correspondance argumentée, puis concevoir les emblèmes et architectures propres à chaque Nation.
6. **Gameplay des Nations** : à définir plus tard ; ne pas ajouter de bonus, diplomatie ou mécanique nationale sans arbitrage explicite.
7. **Validation** : exécuter tests Godot, vérifier l'import des ressources et produire une build Android de test.

## 8. Décisions à ne pas perdre

- Les Nations sont une direction de worldbuilding validée, mais leur système de gameplay reste à concevoir.
- Le fond de carte est une illustration sans texte ni boutons ; les villes et routes sont des couches dynamiques par-dessus.
- Les villes doivent progressivement abandonner l'apparence de rectangles pour des sprites illustrés.
- L'eau et l'air sont des régions à part entière, aux côtés de la forêt, la montagne/glace, le désert, les ruines, le feu, les cristaux et les marais.
- Au moins une Nation ou identité forte par classe est un objectif ; la correspondance dépendra de la liste réelle des classes.
- Ne pas sacrifier la lisibilité mobile ni la progression partagée entre les modes.

## 9. Documents associés

- `CONQUETE.md` : règles, économie, campagne et suivi du mode Conquête.
- `README.md` : présentation technique du prototype.
- Les futures fiches de Nations pourront détailler emblème, palette, architecture, bestiaire, villes et liens aux classes une fois les choix validés.


## Mise à jour interface — build #304

- Le champ de version de l'application affiche désormais `0.0.01.84#304`. Le suffixe `#xxx` représente l'identifiant de push/build affiché à l'utilisateur ; il devra être incrémenté pour les prochains builds publiés.
- La fenêtre Options a été agrandie et ses titres, libellés, boutons et informations de version ont une taille de police supérieure.
- La carte Conquête prend en charge le pincement à deux doigts sur écran tactile, avec un zoom minimal de `1.0` (le cadrage de référence actuel) et un maximum de `2.2`. La molette de souris permet également de zoomer et dézoomer en test sur ordinateur.
- Premier lot complémentaire de sprites SVG créé pour les Nations des Vents, des Marées, du Brasier et des Cristaux. Ces variantes doivent encore être affectées aux villes dans les données et testées en jeu.
