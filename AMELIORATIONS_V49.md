# V49 — Zones inaccessibles et sauvegarde Cloud

## Zones inaccessibles (cases « hors plateau »)
- **Trou à l'intérieur du plateau → gouffre** : fond sombre propre au biome, brume qui respire, particules (lucioles en Forêt, flocons en Montagne, sable qui s'écoule dans le Désert). Les faces des cases voisines deviennent les **parois** du gouffre, décorées (racines et lianes, glaçons, coulées de sable) et assombries vers le bas.
- **Case manquante reliée au bord de l'île → replat en contrebas** : le sol du biome un étage plus bas, avec l'ombre de la marche, au lieu d'un trou dans le vide.
- Les falaises des cases prennent les couleurs du biome (gris en Montagne, grès dans le Désert…).
- Fichiers : `scripts/VoidPit.gd`, `Cell.gd` (`pit_left` / `pit_right`), `GridManager._sync_void_pits()`. Test : `tests/test_void_pits.gd`, captures : `tests/shot_void_shapes.gd`.

## Sauvegarde Cloud (Options)
Deux boutons : **Sauvegarde sur Cloud** (envoie toutes les parties + réglages) et **Restauration depuis Cloud** (affiche la date et les parties, demande confirmation, puis remplace les parties de l'appareil).

### Choix technique : Google Drive par « code appareil »
Pas de connexion Google native (elle demanderait un module Android compilé + l'empreinte SHA-1) :
la première fois, le jeu affiche un code et ouvre google.com/device ; le joueur valide avec son compte, puis c'est automatique (jeton gardé sur l'appareil).
Les données vont dans l'**espace privé du jeu sur Drive** (`appDataFolder`, portée `drive.appdata`) : invisible dans le Drive, inaccessible aux autres apps.

### À faire une fois dans Google Cloud Console (même projet que BaroudeurStudio possible)
1. **API et services → Bibliothèque** : activer **Google Drive API**.
2. **Écran de consentement OAuth** : type Externe, en mode *Test*, ajouter ton adresse Gmail comme utilisateur test ; ajouter la portée `.../auth/drive.appdata`.
3. **Identifiants → Créer → ID client OAuth → type « TV et appareils à saisie limitée »** (nom : Zimut).
4. Dans GitHub (Settings → Secrets → Actions), créer **ZIMUT_GDRIVE_CLIENT_ID** et **ZIMUT_GDRIVE_CLIENT_SECRET**. Le workflow écrit `cloud_oauth.json` dans le jeu (fichier ignoré par git).
Sans ces secrets, les boutons indiquent « Google Drive n'est pas encore configuré ».

### Keystore
Inutile d'en régénérer un : le keystore de release est déjà dans les secrets GitHub. Le workflow affiche désormais ses **empreintes SHA-1 / SHA-256** (étape « Afficher les empreintes du keystore ») si un jour on passe à la connexion Google native.

### Divers
- Permission Android **INTERNET** activée dans l'export.
- Test : `tests/test_cloud_save.gd` (paquet, restauration, écran) ; captures : `tests/shot_cloud.gd`.

### Sécurités (V49b)
- **Restauration d'une sauvegarde plus ancienne** que les parties de l'appareil : avertissement « ⚠ Sauvegarde Cloud plus ancienne » avec la date de la dernière partie locale, bouton « RESTAURER QUAND MÊME ».
- **Envoi alors qu'une sauvegarde plus récente existe, faite sur un autre appareil** : rien n'est envoyé, fenêtre « ⚠ Sauvegarde Cloud plus récente » (date + appareil), au choix « ÉCRASER QUAND MÊME » ou utiliser la restauration.
- **Sauvegarde Cloud automatique** (bouton « ⟳ Auto : Oui/Non » dans Options) : après chaque combat, si un compte Google est relié. Silencieuse : elle ne demande jamais de code et n'écrase jamais une sauvegarde plus récente d'un autre appareil.
- Chaque sauvegarde Cloud porte sa date et le nom de l'appareil (propriétés du fichier Drive).

### Aussi dans cette PR
- Rattrapage des retours de test V48b (Chasseur dans le discours de Gultur, textes agrandis, fiches défilables au doigt, grandes fenêtres Supprimer/Renommer/Importer), poussés après la fusion de #151.
