# Zimut — chantiers à venir

Liste tenue à jour à chaque version. Les quatre Nations existantes (Sylve, Brasier, Brumes, Cimes) sont
peaufinées avant d'en créer d'autres.

## Rendu

- [ ] **Diorama des Cimes (carte 2D)** : neige sur les pins et les rochers, toits enneigés, bord de plateau
      en pierre avec congères. Demande de relancer la chaîne `tools/diorama` ; le *Stylized Nature MegaKit*
      de Quaternius n'est pas dans le dépôt et doit être fourni (ou versionné).
- [ ] **Cimes 3D** : neige sur les constructions des lieux et des donjons (`Adv3DActors`), stalactites de
      glace sous le bord de l'île, cabanes du kit Kenney *Holiday* (déjà dans `atelier_3d/kenney/holiday`).
- [x] **Sylve, Brasier, Brumes en 3D** : même passe que les Cimes (V143).
- [ ] Mesure de fluidité des quatre Nations sur téléphone après V142 et V143.

## Mode Tactique

- [x] Fond de scène par nation et cases variées pour Sylve, Brasier, Brumes, Cimes (V144).
- [x] Sylve : tuiles redessinées en 3 niveaux (calme / détail / accident) (V150).
- [ ] Décor non bloquant au milieu du plateau, flancs de falaise plus travaillés.
- [ ] Teinte d'ambiance par nation sur les personnages, ombres au sol plus marquées.
- [ ] Fond de scène des six autres nations.

- [ ] Aperçu des dégâts sur la cible avant de valider un sort.
- [ ] Frise de l'ordre des tours.
- [ ] IA par type d'ennemi (fonceur, tireur, soigneur).
- [ ] Objectifs variés : survivre X tours, protéger un allié, capturer une case.

## Mode Aventure

- [ ] Brouillard de découverte dans les vues 3D.
- [ ] Quêtes par Nation, qui mènent d'un donjon au suivant.
- [ ] Capture des familiers (idée Rappelz).
- [ ] Énigmes dans le monde 3D (aujourd'hui : par la carte 2D).

## Mode Conquête

Le mode est déjà riche (garnisons, gouverneurs, offensives, généraux, diplomatie, villes à 5 niveaux) :
les idées ci-dessous visent le rythme, le lien avec les autres modes et le confort, pas de nouveaux
systèmes d'économie. Production par ville et défense chiffrée existent déjà (lignes retirées de la liste).

### Jeu

- [x] **Défendre en personne** (V145). Une offensive annoncée peut se jouer en combat Tactique ; le niveau
      des assaillants dépend de la défense de la ville ; le gouverneur peut se battre.
- [ ] **Défense en personne, suite**. Soldats de la garnison présents sur le plateau comme alliés, muraille
      en cases d'obstacle, général en personne (boss) quand il mène l'offensive.
- [x] **Empire vivant** (V146). Offensives pendant l'absence (3 jours de grâce, 2 villes perdues au plus),
      bilan « Pendant votre absence », impôts accumulés, première victoire du jour doublée, offensives
      pendant les autres modes.
- [x] **Notification Android avant une offensive** (V147). Module Notification Scheduler, export Gradle,
      permission demandée au premier rappel utile, réglage pour couper, icônes Zimut. À valider sur téléphone.
- [ ] **Empire vivant, réglages**. Ajuster les valeurs après quelques semaines de jeu réel (délai de
      grâce, rythme, plafond de pertes, fréquence des alertes hors Conquête).
- [x] **Nation complète** (V151). Bannière par Nation (bonus pour tous les héros dans les trois modes, +5 de
      défense à ses villes), suspendue si une ville est perdue.
- [x] **Chapitres de campagne** (V151). Huit étapes récompensées, de « Les premiers pas » à la chute du Roi.
- [ ] **Routes commerciales**. Relier deux villes de spécialités différentes rapporte de l'or à chaque
      victoire ; un raid coupe la route tant que la ville est pillée. Donne un enjeu à la géographie.
- [ ] **Riposte du Roi Squelette**. Après la chute d'un général, une contre-offensive ciblée sur la
      ville la moins défendue, annoncée à l'avance.

### Lien avec les autres modes

- [ ] **Bâtiments utiles ailleurs**. Une ville au niveau Cité ouvre un service dans les autres modes :
      forge à prix réduit, point de voyage rapide en Aventure, entraînement d'un familier.
- [ ] **Généraux croisés en Aventure**. Un général encore en vie patrouille dans la zone d'Aventure de
      sa Nation ; le battre là-bas affaiblit sa forteresse en Conquête.

### Confort

- [x] **Vue d'ensemble de l'empire** (V148). Tableau de toutes les villes, « recruter partout »,
      « améliorer ce qui est payable », « réparer les ruines ».
- [ ] **Pastilles d'action sur la carte**. Marquer les villes où quelque chose est possible ou urgent :
      amélioration payable, garnison vide, ville ruinée.
- [ ] **Bilan après bataille**. Regrouper sur un seul écran ce qui s'est passé (revenus, raid, événement,
      avancée d'une offensive) au lieu de nouvelles dispersées.

### Rendu

- [x] **Écran de ville** (V149). Sol par Nation, rues courbes, chantiers, arbres propres aux Nations.
- [ ] **Carte**. Flèche d'attaque animée vers la cible choisie ; noms de villes masqués au dézoom pour
      alléger.

## Personnages, sorts, forge

- [ ] Spécialisation par classe à certains paliers de niveau.
- [ ] Synergies d'équipe entre éléments ou Nations.
- [ ] Forge : panoplies avec bonus de set, comparaison avant / après.

## Équilibrage et confort

- [ ] Simulateur de combats automatiques pour caler la courbe des niveaux 1 à 94 à partir des CSV.
- [ ] Tutoriel des premières minutes.
- [ ] Le compteur de performances reste visible derrière la carte plein écran : le masquer quand une
      fenêtre est ouverte.
- [ ] `tests/test_adventure_world.gd` : 16 villes de Conquête ne sont révélées par aucune zone d'Aventure
      (échec antérieur à V142).
- [ ] `tests/test_bomb_chain.gd` échoue par intermittence (environ 1 lancement sur 3, déjà avant V144).
