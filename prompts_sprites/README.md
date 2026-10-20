# Prompts de sprites chibi — Zimut

Prompts prêts à copier dans un générateur d'images pour refaire **tous les sprites de combat** au format chibi, avec une finition proche de Dofus / Waven.

| Fichier | Contenu | Prompts |
|---|---|---|
| `nations/01_sylvestre.md` … `10_rouages.md` | pour chaque nation : planche de référence, héros (12 poses), 4 ennemis (8 poses), boss (12 poses) | 70 |
| `familiers.md` | 12 familiers / invocations (8 poses) | 12 |
| `mecanismes.md` | objets fixes : arbre, racines, pilier, muraille, faille, cristal d'ambre, balise, bombe, tourelle, balise de transposition | 4 |
| `generer_prompts.py` | source de tout le reste : descriptions, palettes, poses | — |

Les héros, ennemis, boss et familiers viennent de `scripts/Nations.gd`, `assets/sprites/nations/README.md` et `SPRITES_A_FOURNIR.md`. Les descriptions reprennent les dessins actuels du jeu (couleurs, armes, silhouettes) pour que chaque personnage reste reconnaissable.

## Méthode, planche par planche

1. **Planche de référence de la nation** (section 1 de chaque fichier). Elle ne sert pas en jeu : elle fixe la palette, les matières et les silhouettes de toute la nation.
2. **Planches de poses**, une par personnage. Joins la planche de référence comme image de référence (« image reference », « character reference », « style reference » selon l'outil). Garde le même modèle et, si possible, la même graine (seed) pour toute la nation.
3. **Atelier Sprites** : importe la planche, vérifie les cadres (« Ajuster » si deux poses ont fusionné, « Exclure » pour un texte), choisis le personnage dans la liste puis touche « Nommer les poses ». Les noms des tableaux ci-dessous sont appliqués automatiquement dans l'ordre des cases ; les tableaux servent seulement de contrôle.
4. **Dépôt** : « Exporter pour Zimut (.zip) » range déjà les PNG dans `prototype/zimut/assets/sprites/…` : décompresse le zip à la racine du dépôt. Le jeu les prend sans changer le code (`EntityView.gd` charge `<nom>.png`, `_idle_2`, `_idle_3`, `_back`, `_walk`, `_attack…`, `_cast…`).
5. Ouvre une fois le projet dans Godot pour l'import.

Le jeu affiche la vue 3/4 face et la **retourne horizontalement** quand le personnage va vers la gauche (`sprite.flip_h`) : une seule direction de face suffit, plus le dos. L'arme change donc de main en miroir, c'est normal.

## Fond de la planche

- **Fond blanc uni** par défaut.
- **Fond gris moyen uni (#808080)** pour les personnages clairs (Mage, Heal, Sylvain, boss Cristaux et Vents) : c'est déjà écrit dans leurs prompts.
- **Jamais de fond vert ou rose** : l'Atelier ne reconnaît que les fonds neutres (blanc, gris, damier). Un fond saturé ne serait pas retiré.
- **Jamais « transparent background »** : la plupart des générateurs dessinent alors un faux damier dans l'image.

## Pièges observés sur les planches précédentes

| Problème | Conséquence | Ce que le prompt impose |
|---|---|---|
| Poses qui se touchent (nain : Defense / Attack 1) | un seul cadre pour deux poses | grille stricte, gouttières de 20 % |
| Étiquettes de texte (« NEUTRAL », noms de monstres) | texte collé au sprite | « no text, no labels, no numbers » |
| Faux damier dans un JPG | détourage plus fragile | fond blanc uni |
| Effets flous ou lueur diffuse | halo coloré autour du sprite | effets opaques et cernés, « no soft glow halo » |
| Mélange profil / face / 3/4 | animations incohérentes | 3/4 face-droite répété dans chaque case |
| Ombre au sol | pieds mal posés sur la case | « no ground shadow » (le jeu dessine l'ombre) |
| Personnage coupé au bord | pose inutilisable | « entirely inside its cell » |

Si l'outil respecte mal la grille 4 × 3, coupe la demande en deux planches 4 × 2 (cases 1 à 8, puis 9 à 12) en gardant les mêmes textes.

## Prompt négatif commun

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art
```

## Modifier ou régénérer

Les fichiers Markdown sont générés : modifie les descriptions dans `generer_prompts.py` puis relance depuis la racine du dépôt :

```bash
python3 prompts_sprites/generer_prompts.py
```

Ordre conseillé : commencer par **Ombres** (planche de test), valider le rendu en jeu, puis enchaîner les autres nations.
