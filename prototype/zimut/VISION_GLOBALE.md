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

À terme, prévoir **au moins une Nation ou une identité nationale forte pour chaque classe de héros**. La liste exacte des classes du projet doit être vérifiée avant d'arbitrer l'affectation. Certaines classes pourront partager une affinité, tandis que d'autres pourront justifier une Nation, une faction ou un territoire spécifique. Ne pas inventer de correspondances définitives sans vérifier les classes existantes et valider le choix.

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
3. **Sprites de villes** : créer un premier lot de sprites transparents et remplacer progressivement les boutons rectangulaires.
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
