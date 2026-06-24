# WildZimut_Iso - Prototype Godot Isométrique (Architecture Modulaire)

Prototype du jeu **WildZimut** avec un **rendu isométrique 2D** dans le style de Dofus Touch ou Waven, développé avec **Godot Engine 4.7** pour un export Android.

Ce projet reprend **TOUTES les fonctionnalités** du prototype `prototype/Godot` (système de combat tour par tour, classes, sorts, ennemis) mais avec :
- Une **vue isométrique 2D**
- Une **architecture modulaire** (scripts découpés par responsabilité)

---

## 📁 Structure du projet

```
prototype/Godot_iso/
├── project.godot              # Configuration Godot 4.7
├── main.tscn                 # Scène principale avec tous les managers
├── README.md
├── scenes/
│   └── Main.tscn              # Scène racine
├── scripts/
│   ├── Main.gd               # 🆕 Script principal (coordination)
│   ├── GameManager.gd        # ✅ Gère la logique métier (identique à Godot/)
│   ├── GridManager.gd        # 🆕 Gestion de la grille isométrique
│   ├── UIManager.gd          # 🆕 Gestion de l'interface utilisateur
│   ├── TurnManager.gd        # 🆕 Gestion des tours
│   ├── EntityManager.gd      # 🆕 Gestion des entités
│   ├── SpellManager.gd       # 🆕 Gestion des sorts
│   ├── Cell.gd               # ✅ Classe pour les cellules (adaptée isométrique)
│   └── SpellButton.gd        # ✅ Bouton de sort (identique à Godot/)
├── assets/
│   ├── tiles/               # Tuiles de sol (herbe, eau)
│   │   ├── grass.svg
│   │   └── water.svg
│   ├── objects/             # Objets (rochers, arbres)
│   │   ├── rock.svg
│   │   └── tree.svg
│   └── sprites/             # (À créer) Sprites pour les entités
└── export_presets.cfg       # Configuration d'export Android
```

---

## 🎯 Différences avec `prototype/Godot`

| Aspect | `prototype/Godot` | `prototype/Godot_iso` |
|--------|-------------------|----------------------|
| **Rendu** | 2D classique (grille carrée) | **Isométrique 2D** (losanges) |
| **Taille grille** | 8x8 | **10x10** |
| **Architecture** | Monolithique (1 script `Main.gd`) | **Modulaire** (6 scripts spécialisés) |
| **Tuiles** | Dessinees dynamiquement | **TileMap** + textures SVG |
| **Compatibilité** | Fonctionnalités de base | **100% des fonctionnalités** + rendu isométrique |

---

## 🚀 Prérequis

### 1. Installer Godot Engine
- **Version recommandée** : Godot 4.7 (comme dans `prototype/Godot`)
- Téléchargez-le depuis [le site officiel](https://godotengine.org/download)

### 2. Installer Android Studio (pour l'export APK)
Voir les instructions dans `prototype/Godot/README.md` pour la configuration complète.

---

## 🎮 Fonctionnalités implémentées

### ✅ Reprises de `prototype/Godot`
- **3 classes de joueurs** : Tank, Assassin, Mage (niveau 30)
- **3 types d'ennemis** : Gobelin, Squelette, Loup (niveau 30)
- **6 sorts** : Coup puissant, Bouclier, Attaque furtive, Poison, Boule de feu, Soin
- **Système de tour par tour** : Tour des joueurs → Tour des ennemis
- **Points d'Action (PA)** et **Points de Mouvement (PM)**
- **Gestion des PV, défense, dégâts**
- **IA des ennemis** : Déplacement vers le joueur et attaque
- **Interface utilisateur complète** :
  - Affichage du tour
  - Info joueur (PA/PM)
  - Panneau des sorts
  - Ordre de tour avec barres de PV
  - Messages de jeu
  - Écran de fin de partie (victoire/défaite)

### ✅ Spécifiques à `Godot_iso`
- **Grille isométrique 10x10** (vs 8x8 en 2D classique)
- **Rendu visuel style Dofus Touch**
- **Tuiles SVG** pour le sol et les objets
- **Architecture modulaire** pour une meilleure maintenabilité

---

## 🏗️ Architecture Modulaire

### 📌 **Pourquoi cette architecture ?**
- **Séparation des responsabilités** : Chaque script a un rôle unique (Single Responsibility Principle).
- **Maintenabilité** : Plus facile à modifier, déboguer et étendre.
- **Réutilisabilité** : Les composants peuvent être réutilisés dans d'autres projets.
- **Collaboration** : Plusieurs développeurs peuvent travailler sur des fichiers différents.

### 📊 **Rôle de chaque script**

| Script | Responsabilité | Dépendances |
|--------|---------------|-------------|
| **Main.gd** | Coordination des managers | Tous les managers |
| **GameManager.gd** | Logique métier (tours, combats) | Aucun (autoload) |
| **GridManager.gd** | Gestion de la grille isométrique | GameManager |
| **UIManager.gd** | Gestion de l'interface utilisateur | GameManager |
| **TurnManager.gd** | Gestion des tours (joueurs/ennemis) | GameManager |
| **EntityManager.gd** | Gestion des entités (mouvement, attaque) | GameManager |
| **SpellManager.gd** | Gestion des sorts et de leurs effets | GameManager |
| **Cell.gd** | Affichage d'une cellule | GameManager |
| **SpellButton.gd** | Bouton de sort | Aucun |

### 🔄 **Flux de communication**
```
Main.gd
├── GridManager (gère la grille isométrique)
│   └── Cell.gd (affiche les cellules)
├── UIManager (gère l'UI)
│   └── SpellButton.gd (boutons de sorts)
├── TurnManager (gère les tours)
├── EntityManager (gère les entités)
└── SpellManager (gère les sorts)
    
GameManager (autoload) ←─ Signaux ──→ Tous les managers
```

---

## 📁 Structure de la scène `Main.tscn`

```
Main (Node2D)
├── Camera2D
├── Grid (Node2D)
│   └── GridManager (Node2D)
│       └── Cell x100 (Node2D)
├── UI (CanvasLayer)
│   ├── UIManager (CanvasLayer)
│   │   ├── TurnLabel
│   │   ├── PlayerInfoLabel
│   │   ├── MessageLabel
│   │   ├── GameOverPanel
│   │   │   ├── GameOverLabel
│   │   │   └── RestartButton
│   │   ├── SpellPanel
│   │   │   ├── SpellPanelBackground
│   │   │   ├── SpellPanelLabel
│   │   │   ├── SpellContainer (VBoxContainer)
│   │   │   └── SpellDescription
│   │   └── TurnOrderPanel
│   │       ├── TurnOrderBackground
│   │       ├── TurnOrderLabel
│   │       └── TurnOrderContainer
├── TurnManager (Node)
├── EntityManager (Node)
└── SpellManager (Node)
```

---

## 🎮 Contrôles du jeu

| Action | Contrôle |
|--------|----------|
| Sélectionner une cellule | Clic gauche |
| Sélectionner un sort | Clic sur le sort dans le panneau |
| Passer le tour | Bouton "Passer le tour" ou touche **ESPACE** |
| Recommencer | Bouton "Recommencer" (après game over) |

---

## 🛠 Personnalisation

### Ajouter des sprites pour les entités

1. Créez des images dans `assets/sprites/` (ex: `tank.png`, `assassin.png`, etc.)
2. Modifiez `Cell.gd` pour charger les sprites au lieu de dessiner des cercles/triangles :
   ```gdscript
   # Dans Cell.gd, remplacez la génération de texture par :
   if entity_sprite:
       entity_sprite.visible = true
       var sprite_path = "res://assets/sprites/%s.png" % entity.get("classe", "default").to_lower()
       if ResourceLoader.exists(sprite_path):
           entity_sprite.texture = load(sprite_path)
       else:
           # Fallback aux formes géométriques
           if entity.get("entity_type", "") == "Player":
               entity_sprite.texture = _make_circle_texture(color, 25.0)
           else:
               entity_sprite.texture = _make_triangle_texture(color, 25.0)
   ```

### Modifier les données

Les données des classes, sorts et ennemis sont définies dans `GameManager.gd`. Vous pouvez :
- Modifier les valeurs directement dans le code
- **OU** charger depuis des fichiers CSV (comme prévu dans `prototype/Godot`)

---

## 📱 Export vers Android

Le projet est **100% compatible** avec l'export Android. Voir `prototype/Godot/README.md` pour les instructions détaillées.

### Configuration recommandée
- **Nom du package** : `com.wildzimut.iso`
- **Nom de l'application** : `WildZimut Iso`
- **Orientation** : **Paysage** (Landscape)
- **Résolution** : 1920x1080 (ou adapter)

---

## 🎨 Styles et Assets

### Couleurs par classe (identiques à `prototype/Godot`)

| Classe | Couleur | Représentation |
|--------|---------|----------------|
| Tank | Bleu (#0064C8) | Cercle |
| Assassin | Rouge (#C80000) | Cercle |
| Mage | Violet (#9600C8) | Cercle |
| Gobelin | Vert clair (#80C832) | Triangle |
| Squelette | Gris (#C8C8C8) | Triangle |
| Loup | Brun (#969664) | Triangle |

### Assets par défaut

Le prototype utilise :
- **Tuiles SVG** pour le sol (herbe, eau) et les objets (rochers, arbres)
- **Formes géométriques** pour les entités (cercles = joueurs, triangles = ennemis)

Pour améliorer le style :
1. Créez des sprites dans `assets/sprites/` (format PNG, 64x64 pixels)
2. Modifiez `Cell.gd` pour charger les sprites

---

## 🔄 Comparaison avec `prototype/Godot`

### Ce qui a été conservé
✅ **Toute la logique de jeu** (GameManager.gd)
✅ **Toutes les classes et stats** (Tank, Assassin, Mage, Gobelin, Squelette, Loup)
✅ **Tous les sorts et leurs effets**
✅ **Le système de tour par tour**
✅ **L'IA des ennemis**
✅ **L'interface utilisateur**
✅ **La gestion des PV, PA, PM**

### Ce qui a été adapté
🔄 **Rendu** : 2D classique → **Isométrique 2D**
🔄 **Taille de la grille** : 8x8 → **10x10**
🔄 **Architecture** : Monolithique → **Modulaire**
🔄 **Cell.gd** : Adapté pour le rendu isométrique

### Ce qui est nouveau
✨ **TileMap** pour le fond (herbe, eau)
✨ **Textures SVG** pour les tuiles et objets
✨ **Rendu visuel style Dofus Touch**
✨ **Architecture modulaire** (6 scripts spécialisés)

---

## 📊 Améliorations futures

- [ ] Charger les données depuis des fichiers CSV externes
- [ ] Ajouter des **animations** pour les déplacements/attaques
- [ ] Implémenter un **système de sauvegarde**
- [ ] Ajouter des **effets sonores**
- [ ] Optimiser pour les **petits écrans** (téléphones)
- [ ] Ajouter un **menu principal**
- [ ] Améliorer les **sprites des entités** (remplacer cercles/triangles)
- [ ] Ajouter des **effets visuels** (particules pour les sorts)
- [ ] Implémenter un **système de vision** (brouillard de guerre)
- [ ] Ajouter des **obstacles** sur la grille

---

## 📜 Licence

Ce projet fait partie de **WildZimut** et est la propriété de **Charlie Gentil**.
Toute utilisation ou distribution doit être approuvée par les auteurs.

---

## 🙏 Remerciements

- **Godot Engine** : Moteur de jeu open-source puissant et léger
- **Dofus Touch** : Inspiration pour le rendu isométrique
- **Waven** : Inspiration pour le style visuel
- **Communauté Godot** : Pour les tutoriels et l'aide technique

---

## 📞 Support

Pour toute question ou problème :
- Consultez la [documentation officielle Godot](https://docs.godotengine.org/)
- Posez votre question sur le [forum Godot](https://forum.godotengine.org/)

---

## 🔗 Liens utiles

- [Dépôt GitHub - WildZimut](https://github.com/CharlieG42/Zimut)
- [Prototype Godot (2D classique)](../Godot/README.md)
- [Prototype Godot Iso (Isométrique)](../Godot_iso/README.md)
