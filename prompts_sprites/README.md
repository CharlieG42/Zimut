# Prompts de sprites chibi — Zimut

Prompts prêts à copier dans un générateur d'images pour refaire **tous les sprites de combat** au format chibi, avec une finition proche de Dofus / Waven.

| Fichier | Contenu | Prompts |
|---|---|---|
| `nations/01_sylvestre.md` … `10_rouages.md` | pour chaque nation : planche de référence, héros (4 planches, 32 poses), 4 ennemis (2 planches, 16 poses), boss (4 planches, 32 poses) | 170 |
| `familiers.md` | 12 familiers / invocations (2 planches, 16 poses) | 24 |
| `mecanismes.md` | objets fixes : arbre, racines, pilier, muraille, faille, cristal d'ambre, balise, bombe, tourelle, balise de transposition | 4 |
| `generer_prompts.py` | source de tout le reste : descriptions, palettes, poses | — |

Les héros, ennemis, boss et familiers viennent de `scripts/Nations.gd`, `assets/sprites/nations/README.md` et `SPRITES_A_FOURNIR.md`. Les descriptions reprennent les dessins actuels du jeu (couleurs, armes, silhouettes) pour que chaque personnage reste reconnaissable.

## Vues, poses et planches

Chaque personnage est dessiné sous **deux angles** : **3/4 avant** (face) et **3/4 arrière** (dos). Le jeu retourne l'image horizontalement pour les directions vers la gauche (`sprite.flip_h`) : ces deux vues couvrent les 4 directions de la grille. L'arme change de main en miroir, c'est normal.

| Personnage | Planches (toutes en grille 4 × 2) | Poses par vue |
|---|---|---|
| Héros, boss | face · repos et sorts, face · attaques, dos · repos et sorts, dos · attaques | 3 repos, 2 marche, 3 sorts, **8 attaques** |
| Ennemis, familiers | face, dos | 2 repos, 1 marche, **4 attaques**, 1 sort |

Noms de fichiers : vue de face `<nom>.png`, `_idle_2`, `_walk_2`, `_attack_5`, `_cast_3`… ; vue de dos `<nom>_back.png`, `_back_idle_2`, `_back_walk_2`, `_back_attack_5`, `_back_cast_3`… `EntityView.gd` (V34) les charge tous (jusqu'à 9 variantes par pose) et choisit les poses de dos quand le personnage regarde vers le haut de l'écran.

## Méthode, planche par planche

1. **Planche de référence de la nation** (section 1 de chaque fichier). Elle ne sert pas en jeu : elle fixe la palette, les matières et les silhouettes de toute la nation.
2. **Planches de poses** (« Planche 1 » à « Planche 4 » sous chaque personnage). Joins la planche de référence comme image de référence (« image reference », « character reference », « style reference » selon l'outil). Garde le même modèle et, si possible, la même graine (seed) pour toute la nation.
3. **Atelier Sprites** : importe la planche, vérifie les cadres (« Ajuster » si deux poses ont fusionné, « Exclure » pour un texte), choisis le personnage dans la liste et la planche (face ou dos, repos ou attaques), puis touche « Nommer les poses ». Si le nom du fichier contient le personnage et « dos » ou « attaques » (`assassin_dos_attaques.png`), les deux sont présélectionnés. Les noms des tableaux ci-dessous sont appliqués automatiquement dans l'ordre des cases ; les tableaux servent seulement de contrôle.
4. **Dépôt** : « Exporter pour Zimut (.zip) » range déjà les PNG dans `prototype/zimut/assets/sprites/…` : décompresse le zip à la racine du dépôt. Le jeu les prend sans changer le code.
5. Ouvre une fois le projet dans Godot pour l'import.

## Fond de la planche

- **Fond blanc uni** par défaut.
- **Fond gris moyen uni (#808080)** pour les personnages clairs (Mage, Heal, Sylvain, boss Cristaux et Vents) : c'est déjà écrit dans leurs prompts.
- **Jamais de fond vert ou rose** : l'Atelier ne reconnaît que les fonds neutres (blanc, gris, damier). Un fond saturé ne serait pas retiré.
- **Jamais « transparent background »** : la plupart des générateurs dessinent alors un faux damier dans l'image.

## Pièges observés sur les planches précédentes

| Problème | Conséquence | Ce que le prompt impose |
|---|---|---|
| Poses qui se touchent (nain : Defense / Attack 1) | un seul cadre pour deux poses | grille 4 × 2 à cases carrées, marge de 10 % dans chaque case, gouttière vide de 25 % que rien ne traverse (arme, cape, effet) |
| Étiquettes de texte (« NEUTRAL », noms de monstres) | texte collé au sprite | « no text, no labels, no numbers » |
| Faux damier dans un JPG | détourage plus fragile | fond blanc uni |
| Effets flous ou lueur diffuse | halo coloré autour du sprite | effets opaques et cernés, « no soft glow halo » |
| Mélange profil / face / 3/4 | animations incohérentes | une seule vue par planche (3/4 avant ou 3/4 arrière), « never a pure side profile, never facing left » |
| Ombre au sol | pieds mal posés sur la case | « no ground shadow » (le jeu dessine l'ombre) |
| Personnage coupé au bord | pose inutilisable | « entirely inside its cell » |

Si l'outil respecte mal la grille, demande une image plus large (format 2:1) ou coupe la planche en deux grilles 2 × 2 (cases 1 à 4, puis 5 à 8) en gardant les mêmes textes et le même ordre.

## Prompt négatif commun

```text
checkerboard, transparency grid, text, letters, labels, numbers, watermark, signature, overlapping characters, touching poses, cropped limbs, character cut by the cell edge, effects crossing into another cell, weapon crossing into another cell, side profile view, facing left, inconsistent scale, different outfit between cells, weapon switching hands, extra arms, extra fingers, blurry smoke, semi-transparent effects, soft glow halo, floor, cast shadow, gradient background, photorealistic, 3D render, pixel art
```

## Modifier ou régénérer

Les fichiers Markdown sont générés : modifie les descriptions dans `generer_prompts.py` puis relance depuis la racine du dépôt :

```bash
python3 prompts_sprites/generer_prompts.py
```

Ordre conseillé : commencer par **Ombres** (planche de test), valider le rendu en jeu, puis enchaîner les autres nations.
