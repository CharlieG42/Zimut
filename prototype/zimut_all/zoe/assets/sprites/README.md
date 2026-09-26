# Sprites pour Zimut

Ce dossier contient les sprites pour les personnages du jeu Zimut.

## Structure

```
assets/sprites/
├── players/
│   ├── tank.svg         # Sprite du Tank (format vectoriel)
│   ├── assassin.svg     # Sprite de l'Assassin
│   ├── mage.svg         # Sprite du Mage
│   └── ...
└── enemies/
    ├── gobelin.svg      # Sprite du Gobelin
    ├── squelette.svg    # Sprite du Squelette
    ├── loup.svg         # Sprite du Loup
    └── ...
```

## Format des sprites

- **Format** : SVG (vectoriel, recommandé) ou PNG
- **Taille recommandée** : 64x64 pixels ou 128x128 pixels
- **Transparence** : Fond transparent (alpha channel)
- **Orientation** : Face vers le bas (pour correspondre à la vue isométrique)

## Nommage

Les sprites doivent être nommés **exactement** comme les classes/types dans le jeu :
- **Joueurs** : `tank.svg`, `assassin.svg`, `mage.svg`, etc.
- **Ennemis** : `gobelin.svg`, `squelette.svg`, `loup.svg`, etc.

> ⚠️ **Important** : Les noms doivent être en **minuscules** et correspondre exactement aux valeurs de `classe` dans les données CSV.

## Comment ajouter des sprites ?

1. Placez vos images dans le dossier approprié (`players/` ou `enemies/`)
2. Nommez-les correctement (ex: `tank.png` pour la classe "Tank")
3. Le jeu les chargera automatiquement !

## Fallback

Si un sprite est manquant, le jeu utilisera des **formes géométriques** :
- **Joueurs** : Cercle coloré selon la classe
- **Ennemis** : Triangle coloré selon le type

## Ressources pour trouver des sprites

- [Kenney.nl](https://kenney.nl/) - Assets de jeu gratuits
- [OpenGameArt.org](https://opengameart.org/) - Sprites open source
- [Itch.io (Free Assets)](https://itch.io/game-assets/free) - Assets gratuits
- [Lospec](https://lospec.com/) - Pixel art

## Exemple de sprites

Pour un style cohérent avec Zimut (inspiré de Dofus/Waven) :
- **Tank** : Armure lourde, bouclier
- **Assassin** : Silhouette fine, dagues
- **Mage** : Robe, bâton
- **Gobelin** : Petit, vert, oreilles pointues
- **Squelette** : Blanc, os, épée
- **Loup** : Quadrupède, gris/brun

## Personnalisation

Vous pouvez modifier l'échelle des sprites dans `Cell.gd` :
```gdscript
entity_sprite.scale = Vector2(0.8, 0.8)  # 80% de la taille originale
```

## Notes

- Les sprites sont chargés **dynamiquement** au runtime
- Pas besoin de modifier le code pour ajouter de nouveaux sprites
- Le jeu gère automatiquement les sprites manquants (fallback aux formes géométriques)
