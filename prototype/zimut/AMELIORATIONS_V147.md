# V147 — Notification Android avant une offensive de Conquête

Le jeu calculait déjà quand prévenir (V146) ; il peut maintenant **envoyer la notification** sur Android.

## Ce qui est en place

- **Module** : « Notification Scheduler » v6.0, libre (licence MIT), de godot-mobile-plugins
  (github.com/godot-mobile-plugins/godot-notification-scheduler). Copié dans `addons/NotificationSchedulerPlugin`
  (+ `addons/GMPShared` pour ses deux scripts utilitaires) et activé dans `project.godot`.
- **Icônes aux couleurs de Zimut** dans `assets/NotificationSchedulerPlugin/android` (`.gdignore` : pas
  importées par Godot, copiées telles quelles dans l'APK par le module) :
  - petite icône `ic_zimut_notification` : l'étoile-boussole du logo, en silhouette blanche (Android impose
    une petite icône monochrome et la teinte lui-même), en PNG pour 5 densités et en vectoriel ;
  - grande icône `zimut_notification_large` : le héros et son familier, recadrés depuis l'icône du jeu,
    affichée en couleur à droite de la notification.
- **Export Android en Gradle** (`export_presets.cfg` : `use_gradle_build=true`), indispensable pour embarquer un
  module natif. Permission `POST_NOTIFICATIONS` cochée.
- **Workflow GitHub** : Java 17 (`actions/setup-java`), chemins Java / SDK Android dans les réglages de Godot,
  installation du modèle de build Android à chaque build (`--install-android-build-template`, dossier
  `android/` ignoré par git), délais allongés (export Gradle plus long), et vérification que le module est bien
  dans l'APK debug.
- **Jeu** : `Notifier.gd` (logique) + `NotifierService.gd` (nœud qui pilote le module, créé seulement sur
  Android). À chaque ouverture de la carte de Conquête, le rappel est (re)programmé un jour avant la première
  offensive d'absence ; une bataille de Conquête le repousse d'autant. Texte : « Zimut — votre empire est
  menacé ».
- **Permission** : demandée la première fois qu'un rappel devient utile (empire d'au moins 3 villes), pas au
  lancement du jeu. Si elle est refusée, rien n'est envoyé ; on peut l'accorder plus tard dans les réglages
  Android de l'application.
- **Réglage** : Réglages › Général › « Rappels de Conquête » (affiché sur Android seulement) — Activés / Désactivés. Désactiver annule
  le rappel en attente.

## À vérifier sur téléphone

Rien de tout cela ne se teste hors d'un appareil Android :

1. Installer l'APK de la PR, ouvrir la Conquête avec au moins 3 villes : Android doit demander l'autorisation
   d'envoyer des notifications.
2. Le rappel tombe 2 jours après la dernière bataille de Conquête. Pour le voir plus vite, la constante
   `WARN_BEFORE_SECONDS` de `Notifier.gd` peut être montée temporairement.
3. Si rien n'arrive, vérifier Réglages Android › Applications › Zimut › Batterie : en mode « Optimisé » ou
   « Restreint », certains téléphones (Xiaomi notamment) bloquent les notifications programmées.

## Tests

`tests/test_v147_notifications.gd` (nouveau, inscrit au workflow par `tests/ci/`).

## Et l'EXE Windows ?

Rien ne change : Gradle et la permission ne concernent que le préréglage Android, le module ne s'active que
pour Android et iOS, et sur PC `Notifier.gd` ne trouve pas le module et ne fait rien. Les scripts du module
(quelques Ko) sont inclus dans l'EXE sans effet ; les bibliothèques Android (`.aar`) ne le sont pas.
