# Zimut: L'Odyssée des Éléments (ZOE) - Game Design Document (GDD)
*Version 1.0 - Date : 1er Juillet 2026*
*Auteurs : Charlie Gentil & Vibe*

---

## 📌 Table des Matières
1. [Overview du Jeu](#1-overview-du-jeu)
2. [Direction Artistique](#2-direction-artistique)
3. [Gameplay & Mécaniques](#3-gameplay--mécaniques)
4. [Design des Niveaux](#4-design-des-niveaux)
5. [Spécifications Techniques](#5-spécifications-techniques)
6. [Roadmap de Développement](#6-roadmap-de-développement)
7. [Budget et Ressources](#7-budget-et-ressources)
8. [Objectifs et Métriques de Succès](#8-objectifs-et-métriques-de-succès)

---

## 1. Overview du Jeu

### 1.1 Concept en Une Phrase
Un **jeu d’aventure stratégique et réflexif en 2D isométrique**, centré sur l’exploration des paysages variés de la France (montagnes, océans, plaines, toundras, déserts), où le joueur doit gérer des ressources, résoudre des énigmes et progresser dans un monde ouvert **sans combat**, avec un fil conducteur narratif.

### 1.2 Genre
- **Principal** : Aventure / Stratégie / Réflexion
- **Sous-genres** : Exploration, Survie légère, Puzzle, Gestion de ressources

### 1.3 Public Cible
- **Âge** : 12+ (accessible mais profond)
- **Type de Joueurs** :
  - Fans de jeux **contemplatifs** (*Firewatch*, *A Short Hike*)
  - Amateurs de **stratégie légère** (*Stardew Valley*, *Into the Breach*)
  - Joueurs qui aiment les **énigmes environnementales** (*The Witness*, *Tunic*)

### 1.4 Plateformes
- **PC** (Windows, Mac, Linux)
- **Mobile** (iOS/Android) – *À étudier après le MVP*

### 1.5 Durée de Vie
- **Temps de jeu estimé** : 15-20h pour explorer tous les biomes et résoudre toutes les énigmes.
- **Rejouabilité** :
  - Mode **Défi** (à venir) : Limite de ressources, objectifs chronométrés.
  - **Récompenses cosmétiques** pour le Mode Zimut (lien entre les deux modes).

---

## 2. Direction Artistique

### 2.1 Style Graphique
- **Inspiration** : *Monument Valley* (esthétique épurée, jeux de perspectives, couleurs vives et contrastées).
- **Approche** :
  - **2D Isométrique** pour une profondeur visuelle sans complexité 3D.
  - **Couleurs** : Palette riche et variée selon les biomes (ex: bleus profonds pour l’océan, verts émeraude pour les plaines).
  - **Détails** : Animations fluides (feuilles qui bougent, vagues, nuages), éclairage dynamique (jour/nuit, météo).

### 2.2 Ambiance Sonore
- **Musique** :
  - **Plaine** : Mélodies douces (violon, guitare acoustique).
  - **Montagne** : Thèmes épiques avec des cuivres.
  - **Océan** : Sons de vagues, musique ambiante.
  - **Toundra** : Ambiance glaciale, sons de vent.
  - **Désert** : Mélodies exotiques avec percussions.
- **Bruitages** : Pas du joueur, bruits d’objets, sons d’animaux, effets météorologiques.

### 2.3 UI/UX
- **Interface** : Minimaliste et intuitive.
  - **Inventaire** : Grille d’objets avec icônes stylisées.
  - **Carte** : Mini-carte + carte complète accessible via un bouton.
  - **Barres de ressources** : Faim, soif, énergie.
  - **Menu** : Accès rapide aux quêtes, craft, et options.
- **Langue** : Français (priorité), anglais (à venir).

---

## 3. Gameplay & Mécaniques

### 3.1 Core Loop
```
Exploration → Gestion des Ressources → Résolution d'Énigmes → Progression → Exploration
```

### 3.2 Systèmes Principaux

#### 🗺️ Exploration
- **Monde Ouvert** : Le joueur peut explorer librement, mais un **fil conducteur** guide vers les zones clés.
- **Brouillard de Guerre** : La carte est initialement cachée et se révèle au fur et à mesure.
- **Points d’Intérêt (POI)** :
  - **Naturels** : Grottes, cascades, arbres remarquables.
  - **Construits** : Ruines, villages abandonnés, temples.
  - **Interactifs** : PNJ, animaux, objets à ramasser.
- **Déplacement** : Marche, course (consomme énergie), nage, escalade.

#### 🎒 Gestion des Ressources
| **Ressource** | **Description** | **Consommation** | **Récupération** |
|---------------|-----------------|------------------|------------------|
| **Faim** | Énergie pour les actions physiques | Marche, course, nage, escalade | Nourriture (baies, poissons, pain) |
| **Soif** | Hydratation essentielle | Temps, activités intenses | Eau (rivières, sources, pluie) |
| **Énergie** | Capacité à effectuer des actions | Course, craft, énigmes | Repos (sieste, nuit complète) |
| **Outils** | Objets pour interagir avec l’environnement | Utilisation (ex: hache) | Craft ou achat |
| **Matériaux** | Ressources pour le craft | Utilisés pour créer des objets | Ramassage ou extraction |

- **Système de Craft** : Combinaison de matériaux pour créer des outils, abris, ou objets spéciaux.
  - Exemples : Bâton + Pierre = Hache, Bois + Pierre = Abri, Herbes + Eau = Potion.

#### 🧩 Résolution d’Énigmes
- **Types d’Énigmes** :
  1. **Environnementales** : Alignement de pierres, suivi de traces.
  2. **Logiques** : Puzzles de symboles, combinaisons de leviers.
  3. **Narratives** : Interaction avec des PNJ pour obtenir des indices.
- **Récompenses** : Déblocage de zones, objets rares, savoir (compétences).

#### 📈 Progression
- **Fil Conducteur** : Trouver les **5 Pierres des Éléments** (Terre, Eau, Air, Feu, Nature) cachées dans chaque biome.
- **Progression par Biome** : Chaque biome a ses propres énigmes, ressources et défis.
- **Récompenses** : Cosmétiques (skins, emblèmes pour Zimut), bonus permanents.

### 3.3 Biomes et leurs Spécificités

| **Biome** | **Environnement** | **Ressources Uniques** | **Énigmes Typiques** | **Défis** | **Récompense** |
|-----------|-------------------|------------------------|----------------------|-----------|----------------|
| ⛰️ Montagne | Alpes/Pyrénées | Minerais, herbes rares | Alignement de pierres, escalade | Froid, altitude | Pierre de la Terre |
| 🌊 Océan | Littoral atlantique | Poissons, algues, perles | Navigation, plongée | Courants, tempête | Pierre de l’Eau |
| 🌿 Plaine | Bocage normand | Céréales, fruits, bois | Agriculture, échanges PNJ | Prédateurs | Pierre de la Nature |
| ❄️ Toundra | Zones glacées | Fourrures, glace | Survie au froid, énigmes lumineuses | Températures extrêmes | Pierre de l’Air |
| 🏜️ Désert | Camargue, dunes | Sable, cactus, artefacts | Orientation, gestion de l’eau | Déshydratation | Pierre du Feu |

### 3.4 Système de Quêtes
- **Quêtes Principales** : Liées au fil conducteur (Pierres des Éléments).
- **Quêtes Secondaires** : Exploration, collecte, interaction, défis.
- **Récompenses** : Expérience, objets, accès à des zones secrètes.

### 3.5 Système de Sauvegarde
- **Sauvegarde Automatique** :
  - Déclencheurs : Changement de zone, résolution d’énigme majeure, fin de session.
  - Emplacement : Fichier local.
- **Sauvegarde Manuelle** : Optionnelle via le menu.

---

## 4. Design des Niveaux

### 4.1 Structure d’un Biome
1. **Zone de Départ** : Point d’entrée avec PNJ ou panneau explicatif.
2. **Points d’Intérêt (POI)** : 5-10 par biome (ressources, énigmes, quêtes).
3. **Énigme Principale** : 1 par biome, liée à la Pierre de l’Élément.
4. **Épreuve Finale** : Épreuve de réflexion ou de survie (ex: traversée de canyon).
5. **Sortie** : Accès au biome suivant ou retour au hub.

### 4.2 Exemple : Biome Montagne (*Les Cimes de Zimut*)
- **POI** : Village abandonné, grotte glacée, lac de montagne, sommet.
- **Ressources** : Minerais (fer, or), herbes rares, bois de résineux.
- **Défis** : Froid (perte de santé), altitude (mouvement ralenti).
- **Récompense** : Pierre de la Terre (déblocage de l’Océan).

### 4.3 Progression entre Biomes
- **Ordre Recommandé** : Plaine → Montagne → Océan → Toundra → Désert.
- **Ordre Libre** : Possible, mais certains biomes nécessitent des compétences/objets des précédents.

---

## 5. Spécifications Techniques

### 5.1 Moteur de Jeu
- **Recommandation** : **Godot** (open-source, léger, idéal pour le 2D).
- **Langage** : GDScript (Godot) ou C# (Unity).

### 5.2 Architecture
- **Structure Modulaire** :
  - Biomes : Niveaux indépendants avec leurs propres assets.
  - Systèmes : Gestion des ressources, craft, quêtes, énigmes séparés.
- **Sauvegarde** : Fichiers JSON pour l’état du jeu.

### 5.3 Assets
- **Graphismes** : Pixel Art ou Vectoriel (style *Monument Valley*).
- **Outils** : Aseprite (pixel art), Inkscape (vectoriel).
- **Sons** : BFXR (bruits), LMMS (musique), ou assets libres (Freesound, OpenGameArt).
- **Réutilisation** : Certains assets de Zimut (personnages, icônes) peuvent être réutilisés.

### 5.4 Intégration avec Zimut
- **Page d’Accueil** : 2 boutons (Zimut - Mode Combat / ZOE - Mode Aventure).
- **Lien entre les Modes** :
  - **Récompenses Partagées** : Cosmétiques (skins, emblèmes) pour Zimut.
  - **Progression Indépendante** : Sauvegardes séparées.

---

## 6. Roadmap de Développement

### 🟢 Phase 1 : Prototype (2-3 semaines)
- [ ] Core Loop de base (déplacement, ressources, 1 biome, 1 énigme).
- [ ] UI minimale (barres de ressources, inventaire, mini-carte).
- [ ] Page d’accueil avec 2 boutons.

### 🟡 Phase 2 : Alpha (1 mois)
- [ ] Ajout de 2 biomes (Montagne + Océan).
- [ ] Système de craft (10-15 recettes).
- [ ] Système de quêtes (5 principales + 10 secondaires).
- [ ] Ambiance sonore de base.
- [ ] Sauvegarde automatique.

### 🔵 Phase 3 : Bêta (2 mois)
- [ ] Ajout des 2 biomes restants (Toundra + Désert).
- [ ] Énigmes complexes (3-5 par biome).
- [ ] Fil conducteur complet.
- [ ] Polissage (équilibrage, bugs, performances).

### 🟣 Phase 4 : Version Finale (1 mois)
- [ ] Tests utilisateurs.
- [ ] Intégration complète avec Zimut.
- [ ] Documentation (guide du joueur, tutoriels).
- [ ] Lancement (itch.io ou Steam).

### ⚪ Phase 5 : Post-Lancement (Optionnel)
- [ ] Mode Défi.
- [ ] Nouveaux biomes (Forêt, Volcan).
- [ ] Contenu communautaire.

---

## 7. Budget et Ressources

### 7.1 Équipe
| **Rôle** | **Compétences** | **Temps Estimé** |
|----------|------------------|------------------|
| Game Designer | Conception des mécaniques | 50% |
| Développeur | Programmation (Godot) | 100% |
| Artiste 2D | Pixel Art / Vectoriel | 80% |
| Compositeur Sonore | Musique et bruitages | 30% |
| Testeur | Tests de gameplay | 20% |

### 7.2 Coûts Estimés
- **Logiciels** : Gratuits (Godot, Aseprite, BFXR).
- **Assets Externes** : ~100-500€ (packs d’assets sur itch.io).
- **Hébergement** : ~50-100€/an (itch.io ou Steam).

---

## 8. Objectifs et Métriques de Succès

### 8.1 Objectifs Qualitatifs
- Créer une expérience **immersive et relaxante**. 
- Offrir un **équilibre parfait** entre stratégie, aventure et réflexion.
- **Fidéliser** les joueurs de Zimut avec un nouveau mode.

### 8.2 Objectifs Quantitatifs
- **Taux de complétion** : 70% des joueurs terminent au moins 3 biomes.
- **Temps de jeu moyen** : 15-20h pour 100% de complétion.
- **Feedback positif** : 4.5/5 étoiles sur itch.io/Steam.

---

## 🔗 Liens Utiles
- [Schéma des Mécaniques](./SCHEMA_MECANIQUES.md)
- [Dépôt Zimut](../../../)
- [Godot Engine](https://godotengine.org/)
- [OpenGameArt](https://opengameart.org/)
- [Freesound](https://freesound.org/)

---

*Document généré par Vibe pour WildZimut. © 2026.*
