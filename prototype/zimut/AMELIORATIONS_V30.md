# V30 — Profondeur des personnages en mode Tactique (étape 1, sans nouveaux dessins)

Tout passe par des nœuds et des teintes standard (aucun shader personnalisé ajouté) : le rendu est le même sur téléphone,
où le shader de contour reste désactivé.

- **Ombre portée** : la silhouette du personnage, aplatie, projetée vers l'avant du plateau (contre-jour), inclinée selon la
  lumière du biome ; elle reste au sol pendant les sauts (elle se resserre et pâlit quand le personnage est en l'air).
- **Contact au sol** : zone sombre resserrée sous les pieds.
- **Touffes devant les pieds** (herbe qui ondule, ou cailloux dans les biomes minéraux : Rouages, Donjon, Brasier, Cristaux, Ombres, Désert) :
  le personnage « entre » dans la case.
- **Lumière du biome** (`EntityView.LIGHT`) : teinte du personnage + **liseré de contre-jour** (copie claire décalée vers la lumière) —
  doré en forêt, bleuté en montagne, orange au Brasier, violet aux Ombres, ambré aux Rouages…
- **Profondeur du plateau** : au fond, un peu plus petit et voilé de bleu ; au premier plan, légèrement plus grand et contrasté.
- **Animations** : respiration + léger balancement au repos (désynchronisés), rebond et écrasement à chaque pas, penché dans le sens
  de la marche, étirement pendant l'élan d'attaque, **recul et bascule à l'opposé de l'attaquant** quand on est touché,
  **chute en arrière** puis fondu au K.O. Les éléments posés (terrain, mécanismes, balises) ne respirent pas.

Captures de contrôle : `tests/shot_depth.gd -- <dossier> <zone>` et `tests/shot_anim.gd`.
