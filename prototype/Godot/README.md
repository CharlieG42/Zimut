# WildZimut - Prototype Godot pour Android

Prototype du jeu **WildZimut** développé avec **Godot Engine 4.2** pour un export Android.

Ce projet est une transposition du prototype Python/Pygame existant en Godot, avec une architecture adaptée aux jeux mobiles.

---

## 📁 Structure du projet

```
prototype/Godot/
├── project.godot          # Fichier de configuration du projet Godot
├── README.md              # Ce fichier
├── scenes/
│   └── Main.tscn          # Scène principale du jeu
├── scripts/
│   ├── GameManager.gd     # Gestion de la logique du jeu
│   ├── Main.gd            # Contrôleur de la scène principale
│   └── Cell.gd            # Classe pour les cellules de la grille
└── assets/                # (À créer) Dossier pour les sprites et assets
```

---

## 🚀 Prérequis

### 1. Installer Godot Engine

Téléchargez et installez **Godot Engine 4.2** (ou version ultérieure) :
- [Site officiel](https://godotengine.org/download)
- **Version recommandée** : Godot 4.2 LTS

### 2. Installer Android Studio (pour l'export APK)

1. Téléchargez [Android Studio](https://developer.android.com/studio)
2. Installez les composants suivants via **SDK Manager** :
   - **Android SDK** (version 33 ou supérieure)
   - **Android NDK** (version 25 ou supérieure)
   - **Java JDK 17** (ou OpenJDK 17)
   - **Build-Tools** (version compatible avec votre SDK)
   - **Android Emulator** (optionnel, pour les tests)

### 3. Configurer Godot pour Android

1. **Télécharger les templates Android** :
   - Ouvrez Godot
   - Allez dans **Éditeur > Gérer les templates d'export**
   - Téléchargez les templates pour **Android**

2. **Configurer le chemin vers Android SDK/NDK** :
   - Allez dans **Éditeur > Paramètres de l'éditeur > Export > Android**
   - Définissez les chemins :
     - **Chemin du SDK Android** : `C:\Users\<user>\AppData\Local\Android\Sdk` (Windows) ou `~/Android/Sdk` (Linux/macOS)
     - **Chemin du NDK Android** : `<SDK_PATH>/ndk/<version>`
     - **Chemin de Java** : `<JAVA_HOME>/bin/java`

---

## 📱 Export vers Android (APK)

### Méthode 1 : Via l'interface Godot (recommandé)

1. **Ouvrir le projet** dans Godot
2. **Configurer l'export** :
   - Cliquez sur **Projet > Exporter**
   - Cliquez sur **Ajouter...** et sélectionnez **Android**
   - Configurez les options :
     - **Nom du package** : `com.wildzimut.game` (ou autre)
     - **Nom de l'application** : `WildZimut`
     - **Version** : `1.0.0`
     - **Orientation** : **Paysage** (Landscape)
     - **Résolution** : **1200x700** (ou adapter)
     - **ICône** : Ajoutez une icône (64x64 minimum)

3. **Signer l'APK** (obligatoire) :
   - Allez dans **Android > Keystore**
   - **Créer un nouveau keystore** :
     - **Chemin** : `wildzimut.keystore` (dans le dossier du projet)
     - **Mot de passe** : (choisissez un mot de passe sécurisé)
     - **Alias** : `wildzimut`
     - **Mot de passe alias** : (même que ci-dessus ou différent)
   - **Valider**

4. **Exporter** :
   - Cliquez sur **Exporter le projet**
   - Choisissez un dossier de destination (ex: `export/`)
   - Godot génère un fichier **`WildZimut.apk`**

5. **Installer l'APK** :
   - Copiez le fichier `.apk` sur votre appareil Android
   - Activez **Sources inconnues** dans les paramètres Android
   - Installez l'APK via un gestionnaire de fichiers

### Méthode 2 : Via la ligne de commande

```bash
# Exporter depuis la ligne de commande
godot --export "Android" --path /chemin/vers/WildZimut.apk
```

**Options requises** :
- Assurez-vous que `godot` est dans votre PATH
- Le template Android doit être téléchargé
- Le keystore doit être configuré

---

## 🎮 Contrôles du jeu

| Action | Contrôle |
|--------|----------|
| Sélectionner une cellule | Clic gauche |
| Sélectionner un sort | Clic sur le sort dans le panneau |
| Fin de tour | Bouton "Fin de tour" ou touche **ESPACE** |
| Recommencer | Bouton "Recommencer" (après game over) |

---

## 🛠 Personnalisation

### Ajouter des sprites

1. Placez vos images dans `assets/` (ex: `assets/sprites/tank.png`)
2. Modifiez `Cell.gd` pour charger les sprites :
   ```gdscript
   var sprite := Sprite2D.new()
   sprite.texture = load("res://assets/sprites/%s.png" % entity.classe.to_lower())
   add_child(sprite)
   ```

### Modifier les données

Les données des classes, sorts et ennemis sont définies dans `GameManager.gd`.
Vous pouvez :
- Modifier les valeurs directement dans le code
- **OU** charger depuis des fichiers CSV (recommandé pour la maintenance)

Exemple pour charger depuis CSV :
```gdscript
func load_csv(filepath: String) -> Array:
    var file = FileAccess.open(filepath, FileAccess.READ)
    var lines = file.get_as_text().split("\n")
    var data = []
    for line in lines:
        if line.is_empty():
            continue
        var values = line.split(",")
        data.append(values)
    return data
```

---

## ⚙️ Dépannage

### Problèmes courants avec Android

| Problème | Solution |
|----------|----------|
| **Erreur : SDK/NDK introuvable** | Vérifiez les chemins dans **Éditeur > Paramètres > Export > Android** |
| **Erreur : Keystore manquant** | Créez un keystore via **Android > Keystore** |
| **APK ne s'installe pas** | Vérifiez que **Sources inconnues** est activé sur l'appareil |
| **Écran noir au lancement** | Vérifiez que `Main.tscn` est bien défini comme scène principale |
| **Performances lentes** | Réduisez la taille des sprites (max 1024x1024) |

### Vérifier la configuration Android

Dans Godot :
1. Allez dans **Projet > Paramètres du projet > Export > Android**
2. Vérifiez que :
   - **Module** : `org.godotengine.godot.GodotGame`
   - **Permissions** : `INTERNET`, `WRITE_EXTERNAL_STORAGE` (si nécessaire)
   - **Orientation** : `landscape`

---

## 📊 Architecture du code

### GameManager.gd
- **Rôle** : Gère la logique métier (tour par tour, combats, déplacements)
- **Fonctions clés** :
  - `handle_cell_selected()` : Gère la sélection des cellules
  - `next_player()` : Passe au joueur suivant
  - `enemy_turn()` : Gère le tour des ennemis
  - `check_game_over()` : Vérifie les conditions de fin de jeu

### Main.gd
- **Rôle** : Gère l'interface utilisateur et les interactions
- **Fonctions clés** :
  - `update_ui()` : Met à jour les labels et panneaux
  - `update_entity_display()` : Rafraîchit l'affichage des entités
  - `update_spell_panel()` : Affiche les sorts disponibles

### Cell.gd
- **Rôle** : Représente une case de la grille
- **Fonctions clés** :
  - `_draw()` : Dessine la cellule et son contenu
  - `draw_entity()` : Dessine l'entité sur la cellule

---

## 🎨 Styles et Assets

### Couleurs par classe

| Classe | Couleur |
|--------|---------|
| Tank | Bleu (#0064C8) |
| Assassin | Rouge (#C80000) |
| Chasseur | Vert (#00C800) |
| Mage | Violet (#9600C8) |
| Support | Orange (#FFC800) |
| Heal | Cyan (#00C8C8) |
| Gobelin | Vert clair (#80C832) |
| Squelette | Gris (#C8C8C8) |
| Loup | Brun (#969664) |

### Assets par défaut

Le prototype utilise des formes géométriques simples (cercles) pour représenter les entités.
Pour améliorer le style :
1. Créez des sprites dans `assets/sprites/` (format PNG, 64x64 pixels)
2. Modifiez `Cell.gd` pour charger les sprites au lieu de dessiner des cercles

---

## 🔄 Mises à jour futures

- [ ] Charger les données depuis des fichiers CSV externes
- [ ] Ajouter des animations pour les déplacements/attaques
- [ ] Implémenter un système de sauvegarde
- [ ] Ajouter des effets sonores
- [ ] Optimiser pour les petits écrans (téléphones)
- [ ] Ajouter un menu principal

---

## 📜 Licence

Ce projet est la propriété de **WildZimut** et **Charlie Gentil**.
Toute utilisation ou distribution doit être approuvée par les auteurs.

---

## 🙏 Remerciements

- **Godot Engine** : Moteur de jeu open-source puissant et léger
- **Dofus** : Inspiration pour les mécaniques de combat tour par tour
- **Communauté Godot** : Pour les tutoriels et l'aide technique

---

## 📞 Support

Pour toute question ou problème :
- Consultez la [documentation officielle Godot](https://docs.godotengine.org/)
- Posez votre question sur le [forum Godot](https://forum.godotengine.org/)
- Contactez l'équipe WildZimut
