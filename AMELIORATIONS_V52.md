# V52 — Animation d'ouverture

- **Écran Godot masqué** : `application/boot_splash/show_image=false`, fond sombre du jeu (`boot_splash/bg_color`).
- **Nouvelle scène de démarrage** `scenes/Intro.tscn` (`scripts/IntroUI.gd`, ~3 s) : les dix Pierres Élémentaires (couleurs des Nations) tournoient puis convergent, éclat lumineux, le logo Zimut apparaît, fondu vers l'Accueil. **Un appui passe l'animation.** L'Accueil est chargé en arrière-plan pendant ce temps.
- Logo détouré pour l'intro : `assets/ui/logo_intro.png` (coins arrondis transparents).
- Test : `tests/test_intro.gd` ; captures : `tests/shot_intro.gd`.
- Limite Android : sur Android 12 et plus, le système affiche toujours un bref écran avec l'icône de l'application avant le lancement du moteur (imposé par Android, pas par Godot).
