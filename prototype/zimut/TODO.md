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
- [ ] Sylve : redessiner les tuiles (calmes / détail / accident) comme les trois autres nations.
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

- [ ] Production de ressources par ville, qui alimente la forge.
- [ ] Défense de ses villes (contre-attaques ennemies).

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
