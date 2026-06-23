# Godot_iso - Prototype de carte isométrique

Projet Godot 4.2 avec une grille isométrique 10x10 dans le style de Dofus Touch ou Waven.

## 📁 Structure du projet
```
Godot_iso/
├── project.godot          # Configuration du projet
├── main.tscn             # Scène principale
├── scripts/
│   └── main.gd           # Script principal
├── assets/
│   ├── tiles/            # Tuiles de base (herbe, eau)
│   │   ├── grass.svg
│   │   └── water.svg
│   └── objects/          # Objets (rochers, arbres)
│       ├── rock.svg
│       └── tree.svg
├── .gitignore
└── README.md
```

## 🚀 Configuration requise

1. **Godot 4.2** (ou version supérieure)
   - Téléchargez-le depuis [le site officiel](https://godotengine.org/)

2. **Importer les assets** :
   - Les fichiers SVG dans `assets/tiles/` et `assets/objects/` seront automatiquement convertis en textures par Godot.
   - Si vous préférez utiliser des PNG, remplacez simplement les fichiers SVG par vos propres images (64x64 pour les tuiles, 64x96 pour les arbres).

## 🎮 Utilisation

### Dans l'éditeur Godot :
1. Ouvrez `project.godot` avec Godot 4.2
2. La scène `main.tscn` s'ouvre automatiquement
3. **Configurer le TileSet** :
   - Sélectionnez le nœud `TileMap`
   - Dans l'inspecteur, cliquez sur **TileSet > Nouveau TileSet**
   - Ajoutez vos images comme sources de tuiles (dans l'ordre : grass.svg, water.svg, rock.svg, tree.svg)
   - Assurez-vous que les **IDs** correspondent à ceux dans `main.gd` :
     - 0 : Herbe (grass.svg)
     - 1 : Eau (water.svg)
     - 2 : Roche (rock.svg)
     - 3 : Arbre (tree.svg)

4. **Exécuter la scène** :
   - Appuyez sur **F5** pour lancer
   - **Clic gauche** : Place un rocher
   - **Clic droit** : Place un arbre

### Personnalisation :
- **Modifier la taille de la grille** : Éditez `grid_size` dans `main.gd`
- **Changer le design** : Remplacez les fichiers SVG par vos propres assets
- **Ajouter des tuiles** : Ajoutez de nouvelles entrées dans l'énum `TileType` et mettez à jour `map_data`

## 📱 Export vers Android

1. Allez dans **Projet > Exporter**
2. Ajoutez une présélection **Android**
3. Configurez les paramètres (keystore, permissions, etc.)
4. Cliquez sur **Exporter**

## 🎨 Améliorations possibles

- [ ] Ajouter des animations aux tuiles (eau qui bouge)
- [ ] Implémenter un système de déplacement pour un personnage
- [ ] Ajouter des collisions
- [ ] Créer un système de génération procédurale

## 📝 Notes

- Les tuiles sont en **isométrie** avec une taille de cellule de 64x32 pixels
- Le `y_sort_enabled` est activé pour un rendu correct des couches
- La caméra est centrée sur la carte par défaut

---

*Créé pour le projet WildZimut - Prototype de jeu mobile*