# Zimut sur Google Play — démo, bêta fermée et monétisation (V460)

Document de passation rédigé le 28/11/2026. Les points marqués **⚠ à vérifier** dépendent de règles Google ou de licences que je n'ai pas pu confirmer depuis le dépôt : contrôle-les dans la Play Console avant de publier. Ce n'est pas un avis juridique ni fiscal.

## 1. Ce que contient la V460

| Élément | Détail |
|---|---|
| Édition démo | `scripts/Edition.gd` : le joueur et ses héros s'arrêtent au **niveau 16** (`Edition.DEMO_MAX_LEVEL`), l'XP en trop n'est pas conservée. Bandeau « VERSION DÉMO » à l'accueil, bouton « Version complète » (accueil, Réglages > À propos, écran de fin de combat au plafond). |
| Choix de l'édition | À l'export, par les *custom features* du preset : `demo` (démo), `playstore` (build Play Store). Éditeur, APK et EXE : inchangés, jeu complet. |
| Application distincte | « Zimut Démo », package `com.zimut.iso.demo` (sauvegardes locales séparées de la version complète). |
| Presets Android | `Android Demo AAB` (démo) et `Android Play Store AAB` (version complète, package `com.zimut.iso`) : format **AAB**, **target SDK 36**, **sans** `REQUEST_INSTALL_PACKAGES`. |
| Mise à jour GitHub | `UpdateChecker` est désactivé dans tout build Play Store (Google interdit d'installer des APK hors Play Store ; Google Play gère les mises à jour). |
| CI | Chaque build produit l'AAB de la démo, signé avec la clé de release actuelle (secrets `ANDROID_KEYSTORE_BASE64`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`), et affiche les permissions du bundle. Artefact **`Zimut-demo-aab`** (14 jours). L'AAB n'est pas mis sur la release publique `build-latest`. |
| Politique de confidentialité | `docs/privacy.html` (FR + EN), lien ajouté dans Réglages > À propos. |
| Test | `tests/test_demo_edition.gd` (inscrit via `tests/ci/`). |

**Récupérer l'AAB** : GitHub > Actions > dernier build de la PR ou de `main` > section *Artifacts* > `Zimut-demo-aab` (zip contenant `Zimut-demo-v<version>-<sha>.aab`).

Changer le plafond : modifier `DEMO_MAX_LEVEL` dans `Edition.gd` (le test et la CI suivent).

## 2. Bêta fermée (test fermé de la démo)

1. **Compte développeur Play Console** (25 $ une seule fois, vérification d'identité).
2. **Créer l'application « Zimut Démo »** (gratuite) et remplir la configuration de base : la Console impose de terminer la configuration avant de lancer un test fermé.
3. **Play App Signing** : garder l'option par défaut. Ton keystore actuel sert de clé d'import ; **sauvegarde-le** (le secret `ANDROID_KEYSTORE_BASE64` est la seule copie dans la CI).
4. **Test > Test fermé > nouvelle version** : déposer le `.aab`, noter la version, créer une liste de testeurs (adresses Gmail) et partager le lien d'inscription.
5. **Compte personnel créé après le 13/11/2023** : avant de demander l'accès à la production il faut un test fermé avec **au moins 12 testeurs inscrits en continu pendant 14 jours**, puis « Demander l'accès à la production » depuis le tableau de bord ([règle Google](https://support.google.com/googleplay/android-developer/answer/14151465)). Un compte « organisation » n'est pas concerné.
6. Chaque nouvel envoi doit avoir un `versionCode` plus grand : la CI utilise le numéro de push, c'est automatique.

## 3. Monétisation : le plus simple

**Recommandation : démo gratuite + version complète payante (application distincte).** Aucun code de paiement à écrire : Google Play encaisse, le jeu n'a pas de bibliothèque de facturation, la politique de confidentialité reste valable telle quelle.

- ⚠ **Publie `com.zimut.iso` comme application PAYANTE dès la première version.** Une application publiée gratuite ne peut pas devenir payante ensuite (⚠ à vérifier dans la Console).
- Alternative : une seule application gratuite + achat intégré « Version complète ». Plus de travail : plugin Google Play Billing pour Godot, écran d'achat, restauration d'achat, mise à jour de la politique de confidentialité et du formulaire « Sécurité des données ».
- Les APK/EXE du dépôt GitHub (`build-latest`) sont publics et signés : si tu vends le jeu, ils le donnent aussi gratuitement. Décide si le dépôt reste public (tu as dit « pour le moment ») et si les builds publics restent publiés.
- ⚠ Commission Google : à vérifier dans la Console (taux réduit sur la première tranche de revenus annuels).
- Les APK installés depuis GitHub et l'application du Play Store ne se mettent pas à jour mutuellement (signatures différentes : Google re-signe avec sa propre clé).

## 4. Check-list avant publication

### Compte et paiement
- [ ] **Profil de paiement / marchand** (nécessaire pour vendre) et informations fiscales.
- [ ] **Statut de professionnel (« trader », règlement européen DSA)** : si tu vends, tu seras vraisemblablement considéré comme professionnel ; l'adresse, le téléphone et l'e-mail de contact peuvent alors s'afficher publiquement sur la fiche ⚠ à vérifier dans Play Console > Compte. Pour ton statut en France (micro-entreprise, déclaration des revenus), vois avec un comptable ou l'URSSAF.

### Confidentialité et conformité
- [ ] **Activer GitHub Pages** : dépôt > Settings > Pages > *Deploy from a branch* > `main` / dossier `/docs`. La page sera sur `https://charlieg42.github.io/Zimut/privacy.html` (c'est l'adresse codée dans `Edition.PRIVACY_URL`).
- [ ] **Play Console > Contenu de l'application** : coller cette URL (politique de confidentialité) et remplir :
  - **Sécurité des données** : le jeu n'a ni publicité, ni statistiques, ni compte ; l'éditeur ne reçoit aucune donnée. La sauvegarde Google Drive est facultative, envoyée par le téléphone vers le Drive du joueur (portée `drive.file`) : déclare-la selon les choix du formulaire pour un transfert vers le compte de l'utilisateur ⚠ à relire à l'écran.
  - **Public cible** : adultes/ados, pas « destiné aux enfants » (sinon règles Families).
  - **Classification du contenu** (questionnaire IARC) : combats fantastiques au tour par tour.
  - **Annonces** : « ne contient pas de publicités ».
- [ ] **Google Cloud (sauvegarde Drive)** : passer l'écran de consentement OAuth du projet Zimut de « Test » à **« En production »**. En mode Test, les jetons expirent au bout de 7 jours et seuls 100 testeurs déclarés peuvent se connecter : la bêta fermée ferait sauter la sauvegarde Cloud. `drive.file` est une portée peu sensible, mais Google peut exiger une page d'accueil et la politique de confidentialité (même URL) ⚠ à vérifier.
- [ ] **Permissions** : le bundle déclare `INTERNET` et `POST_NOTIFICATIONS`, plus ce que le module de notifications ajoute (alarmes). La CI affiche la liste exacte dans le journal de l'étape « Export Zimut Démo (AAB) » : relis-la et vérifie que chaque permission est justifiable dans la Console (les alarmes exactes sont encadrées par Google).
- [ ] **API cible** : Google exige l'API 36 pour toute nouvelle application ou mise à jour depuis le 31/08/2026 ([source](https://developer.android.com/google/play/requirements/target-sdk)). Les presets AAB sont réglés sur 36 ; si l'export échoue sur ce point dans la CI, c'est le premier endroit à regarder.

### Licences des ressources (important dès que tu vends)
- [ ] **Modèles 3D Meshy** : plan gratuit = licence CC BY 4.0 (usage commercial permis, mais **crédit à Meshy obligatoire**) ; plan payant = propriété complète sans crédit. Le droit suit le plan que tu avais **au moment de la génération de chaque modèle** ([aide Meshy](https://intercom.help/meshy/en/articles/16102098-can-i-use-meshy-assets-commercially)). Vérifie le plan utilisé pour chaque modèle. Le crédit existe déjà dans Réglages > À propos ; ajoute-le aussi à la description de la fiche si besoin.
- [ ] **Sprites et planches générés par IA (Mistral, Gemini, ChatGPT)** : relis les conditions d'utilisation de chaque outil, pour le plan que tu utilises, sur l'usage commercial des images générées.
- [ ] **Kits CC0** (Kenney, KayKit, Quaternius) : aucun problème de licence, crédits déjà dans À propos.
- [ ] **Marques** : le style « inspiré de Dofus/Waven » est une inspiration ; ne cite ni Dofus, ni Waven, ni leurs marques dans la fiche Play (titre, description, mots-clés), et n'utilise aucune image dont les droits sont incertains.
- [ ] **Dépôt public** : sans fichier LICENSE, le code reste « tous droits réservés », mais le dépôt est lisible par tous. À garder en tête si tu vends.

### Fiche Play Store (FR + EN, le jeu est bilingue)
- [ ] Icône 512×512, image de présentation 1024×500, au moins 2 captures d'écran téléphone (idéalement 4 à 8, sur ton S23+), description courte (80 car.) et longue.
- [ ] Catégorie Jeux > Stratégie, e-mail de contact, URL de la politique de confidentialité.
- [ ] Pour la démo : dire clairement « niveau 16 maximum, version complète sur Google Play ».

## 5. Passer à la version complète

1. Le preset `Android Play Store AAB` est prêt (package `com.zimut.iso`, target 36, sans installation d'APK).
2. Pour le produire en CI : dupliquer l'étape « Export Zimut Démo (AAB) » avec `"Android Play Store AAB"` et `export/Zimut-playstore.aab`.
3. Publier d'abord en **test fermé** (même règle des 12 testeurs / 14 jours si tu n'as pas encore l'accès à la production), puis en production.

## 6. Non vérifié

- La première génération de l'AAB par la CI (Gradle + target 36) : à confirmer sur le premier build de cette PR.
- L'installation de la démo depuis la Play Console sur ton S23+ : rien n'a été testé sur téléphone.
- Les points marqués ⚠ ci-dessus.
