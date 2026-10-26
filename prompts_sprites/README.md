# Prompts de sprites chibi — Zimut

Prompts prêts à copier dans un générateur d'images pour refaire **tous les sprites de combat** au format chibi, avec une finition proche de Dofus / Waven.

| Fichier | Contenu |
|---|---|
| `nations/01_sylvestre.md` … `10_rouages.md` | pour chaque nation : planche de style + 3 planches par personnage (vues, actions de face, actions de dos) — héros, 4 ennemis, boss |
| `familiers.md` | 12 familiers / invocations, même format (3 planches) |
| `mecanismes.md` | objets fixes : arbre, racines, pilier, muraille, faille, cristal d'ambre, balise, bombe, tourelle, balise de transposition |
| `generer_prompts.py` | source de tout le reste : descriptions, palettes, poses (230 prompts) |
| `identites.py` | **cartes d'identité** des personnages (couleurs exactes de chaque partie, variations interdites) |

Les héros, ennemis, boss et familiers viennent de `scripts/Nations.gd`, `assets/sprites/nations/README.md` et `SPRITES_A_FOURNIR.md`.

## V57 : héros adulte, objet tenu conservé, vocabulaire adapté à la modération

Retour de la nation des Sables (Mistral) : le Géomancien ressemble à un enfant, perd son bâton dans 4 cases sur 5,
et Mistral est souvent bloqué par la modération ou reformule les prompts.

| Constat | Correction |
|---|---|
| Héros « trop enfant » (« young geomancer » + chibi à grosse tête = visage de gamin, et risque de filtre « mineur ») | carte d'identité : **adulte d'une trentaine d'années** (mâchoire marquée, barbe légère, carrure) ; description sans « young » ; ligne `PROPORTIONS` : tête = 1/3 de la hauteur (pas 40 %) et « never a child » ; interdits : turban/chapeau/bandeau (la planche en avait un), proportions d'enfant, bâton absent. Réglage réutilisable : champ `proportions=` d'une carte (identites.py) |
| **Bâton absent** de 4 cases sur 5 (le mot « weapon » est le premier réécrit par la modération) | l'objet tenu est rappelé **dans chaque case** (« The golden staff… is held in the right hand and fully visible in this cell ») ; le bloc WEAPON devient « HELD ITEM » |
| **Modération** | tous les prompts publiés passent par `soften()` : weapon → held item, unarmed → no held item, dagger → short curved blade, smash/slam/stab/slash/kick/blast → strike/drive/thrust/sweep/leg lift/burst, bomb → round charge, fight/kill/blood/death → act/defeat/red paint. Les consignes restent identiques ; `verifier_prompts.py` vérifie qu'aucun de ces mots ne reste dans un prompt |
| Prompts trop longs : Mistral ignore le nombre de cases (5, 6 ou 8 sprites au lieu de 4) | **version courte** de la planche vues (≈ 1 600 caractères) sous chaque planche 1 |

Pour régénérer : `python3 prompts_sprites/generer_prompts.py` puis `python3 prompts_sprites/verifier_prompts.py`.

## V55 : défauts des planches Cimes → corrections dans les prompts

Retour des planches Guerrier des monts, Garde des pics, Vorkann et Griffon des cimes :

| Constat | Correction dans les prompts |
|---|---|
| **Actions** : les 6 cases recopient la pose de la planche source (Guerrier des monts) | la source n'est plus qu'une « référence de personnage » (« do NOT reuse, copy, trace… ANY of its poses ») ; chaque pose reçoit une **silhouette** attendue (haute, large, basse, compacte…) et une auto-vérification « remplis les 6 poses en noir : les silhouettes doivent se distinguer » ; si ça recopie encore : **2 demi-planches de 3 poses** (`--grid 3x1`), rappel en tête de chaque planche actions |
| **Vues** : 3 cases au lieu de 4 (griffon), 4 poses de face identiques sans dos (boss, Garde des pics) | bloc « COUNT AND VIEWS » : exactement 4 sprites, rangée du bas **vue de dos réelle** (« no face, no eyes, no beak or snout visible »), négatifs « only 3 sprites », « back row drawn from the front », « four identical front views » |
| **Miroir** : colonne de droite = copie retournée de celle de gauche (griffon) | « NOT a mirrored pair and NOT a copy » + négatifs « mirror image of another sprite, flipped copy » |
| **Style** : un griffon en pixel art entre des planches en dessin vectoriel | ligne **STYLE LOCK** (vectoriel à contours épais, jamais pixel art) dans les planches vues et actions ; « pixel grid / low-resolution pixels » ajoutés aux négatifs |
| **Découpe** : fourrure et têtes blanches mangées sur fond blanc | fond **gris** automatique dès que la description contient white / snow / pale / silver… (`PALE_WORDS`) ; côté découpe : `couper_planche.py --holes 60000 --shadow-delta 300` pour les sprites clairs |
| Créatures : « la main sur la hanche », « l'arme reste dans sa main » | ces consignes sont retirées pour les créatures sans arme (`view_text`) |

**Check-list avant d'envoyer une planche à découper** : (1) bon nombre de cases (4 ou 6, 3 pour une demi-planche) ;
(2) poses vraiment différentes, aucune en miroir ; (3) rangée du bas bien de dos ; (4) même personnage que la planche
vues (tête, oreilles, barbe, tenue) ; (5) même style (contours noirs épais, pas de pixel art) ; (6) fond uni.
`python3 prompts_sprites/verifier_prompts.py` contrôle désormais le verrou de style, l'anti-copie, l'anti-miroir.

## V44 : 3 planches par personnage, une seule direction de vue par planche, armes réservées aux armés

Retour de l'essai Brasier (héros, 3 monstres, boss) : ce qui allait de travers vient des prompts, pas du hasard.

| Constat sur les planches | Cause dans les prompts V40-V43 | Correction V44 |
|---|---|---|
| **Torches inventées** pour la Salamandre et le Dévoreur ; le Chasseur attaque avec un bâton | l'ordre générique « WEAPON LOCK : mains jamais vides, l'arme de la classe » s'appliquait aussi aux **créatures sans arme** | l'arme n'existe que si la carte d'identité en a une : elle ouvre le prompt (« armed with… »), est reprise dans chaque pose et en fin de prompt. Les 31 créatures reçoivent **UNARMED** (+ négatif sans mot « weapon ») |
| **Doublons** : vues de face et de dos répétées 2 fois, poses identiques | 4 « quarts de tour » : le générateur ne sait pas tourner un personnage et retombe sur face/dos/face/dos | on le demande tel quel : **2 repos de face (deux attitudes) + 2 repos de dos**, tout orienté à droite |
| **Orientation** : vues de profil, personnages tournés vers la gauche | angles « dos gauche » / « avant gauche », que le jeu n'utilise de toute façon pas (il retourne l'image) | plus aucune vue vers la gauche ; « every sprite faces RIGHT » dans le prompt et le rappel final |
| **Actions de dos jamais obtenues** (6 cases toutes de face) | face et dos sur la même planche : le générateur choisit un seul sens | **2 planches d'actions** : de face, puis de dos (mêmes 6 poses). Facultative pour les monstres |
| Noms de fichiers inutilisables | `_attack_back`, `_back_left`, `_face_left` : le jeu lit `_back_attack`, `_idle_2`, `_walk`… | noms alignés sur `EntityView.gd` ; `_attack_3`, `_cast_2`, `_walk` et `_idle_2` ajoutés (le jeu les anime) |
| Cartes d'identité en désaccord avec les dessins retenus | Salamandre « jamais sur deux pattes », Dévoreur « quatre pattes » alors que les planches validées sont debout | cartes du Chasseur, de la Salamandre et du Dévoreur mises à jour d'après les dessins intégrés |

Format V44 :

1. **Planche `vues`** (génération normale, 2 × 2) : haut = repos de face ×2, bas = repos de dos ×2 →
   `<id>.png`, `<id>_idle_2.png`, `<id>_back.png`, `<id>_back_idle_2.png`.
2. **Planche `actions` de face** (en édition de la planche vues, 3 × 2) : 3 attaques, 2 sorts, 1 marche →
   `_attack`, `_attack_2`, `_attack_3`, `_cast`, `_cast_2`, `_walk`.
3. **Planche `actions_dos`** (en édition, 3 × 2) : les mêmes 6 poses vues de dos → `_back_attack`…`_back_walk`.
4. **Édition corrective** (si une case est fausse) : répète la structure des cases ; pour une créature,
   elle **retire** l'objet inventé au lieu d'ajouter une arme.

Découpe : `tools/couper_planche.py` (fond blanc, gris ou rose, ombres, zones enfermées, doublons) puis
`tools/integrer_brasier.py` donne un exemple de table case → pose. `python3 prompts_sprites/verifier_prompts.py`
contrôle les 230 prompts (arme en première phrase, UNARMED, noms de fichiers, pas de vue vers la gauche).

## V43 (historique) : 4 vues en quarts de tour, arme verrouillée

Format abandonné en V44 (voir ci-dessus) ; les verrous d'arme V41-V42 (WEAPON CHECK, mains jamais vides) sont conservés
pour les personnages armés, la taille verrouillée aussi (« EXACTLY the same size »).

## V38 : le même personnage, sans image jointe — les cartes d'identité

Le générateur ne voit jamais les autres planches : tout ce que le prompt ne précise pas, il le réinvente
(sur l'essai du Sylvain : cheveux menthe, blancs puis lavande, yeux verts puis marron). Chaque prompt
commence donc par une **carte d'identité** recopiée mot pour mot (fichier `identites.py`) :

- **chaque partie visible** est décrite : cheveux, yeux, peau, haut, bas, chaussures, bras, arme et main qui la tient ;
- **couleurs nommées + code hexadécimal** (`pale mint-white hair (#DDF2EE)`) : bien plus stable qu'un « silver-teal » vague ;
- **« rien d'autre »** : le générateur ne doit ajouter aucune pièce ni couleur absente de la carte ;
- **variations interdites** : les dérives déjà vues (yeux fermés, cheveux en pointes, pantalon orange…) ;
- **rappel en fin de prompt** des 4 traits principaux (les générateurs pèsent surtout le début et la fin) ;
- **vues de dos** qui interdisent visage, yeux, masque ou visière (le chevalier « de dos » était en fait de face).

Cartes écrites pour **tous les personnages** : 10 héros, 10 boss, 40 ennemis et 13 familiers (les objets de
`mecanismes.md` n'en ont pas besoin). Les ennemis des Ombres sont décrits d'après les sprites déjà intégrés.
Quand une planche `vues` te plaît, recopie dans sa carte les couleurs vues sur l'image : c'est ce qui verrouille
toutes les planches suivantes — et la planche `actions` éditée depuis la planche `vues` verrouille le reste.

## Méthode, personnage par personnage

1. **Planche de style de la nation** (section 1 de chaque fichier, facultative) : palette et matières de toute la nation.
2. **Planche `vues`** : copie le prompt tel quel, carte d'identité comprise. Recommence jusqu'à ce qu'elle te
   plaise : la planche `actions` en découle.
3. **Planches `actions` (face puis dos)** : donne à l'outil d'édition la planche `vues` comme image source, avec
   chaque prompt. Si l'outil n'édite pas, génère-les normalement. Dos facultatif pour les monstres.
4. **Nom du fichier** : `<id>_vues.png`, `<id>_actions.png` et `<id>_actions_dos.png`, par exemple
   `chasseur_vues.png`, `chasseur_actions.png`. L'Atelier (SpriteBuilder) reconnaît alors le personnage et la planche tout seul.
5. **Atelier Sprites** : importe, vérifie les cadres, regarde l'alerte « Poses en double » (bouton « Exclure
   les doublons »), puis exporte le zip et décompresse-le à la racine du dépôt Zimut. Ouvre une fois le
   projet dans Godot pour l'import.

## Fond de la planche

- **Fond blanc uni** par défaut.
- **Fond gris moyen uni (#808080)** pour les personnages clairs (Mage, Heal, Sylvain, boss Cristaux et Vents) : c'est déjà écrit dans leurs prompts.
- **Jamais de fond vert ou rose** : l'Atelier ne reconnaît que les fonds neutres (blanc, gris, damier). Un fond saturé ne serait pas retiré.
- **Jamais « transparent background »** : la plupart des générateurs dessinent alors un faux damier dans l'image.

## Pièges observés sur les planches précédentes

| Problème | Conséquence | Ce que le format V44 impose |
|---|---|---|
| Même pose recopiée dans plusieurs cases | animations figées | 2 repos de face + 2 repos de dos, deux attitudes différentes par rangée ; actions aux silhouettes décrites une par une |
| Personnage différent d'une planche à l'autre | héros méconnaissable | planche `actions` **éditée depuis** la planche `vues` + carte d'identité recopiée partout |
| Arme ou accessoire différent d'une planche à l'autre | le chasseur perd son arc | ligne « WEAPON LOCK » dans les deux prompts, rappel final qui commence par l'arme, négatif « weapon replaced by another weapon, missing weapon » |
| Arme absente d'une case (mains vides) | le chasseur combat à mains nues | « the character HOLDS its weapon in EVERY cell — hands are NEVER empty » + ligne « WEAPON CHECK » avec l'arme exacte en fin de prompt + négatif « empty hands » |
| Un sprite plus grand ou plus petit que les autres | échelle cassée à la découpe | « The 4 sprites have EXACTLY the same size: same scale, same height in pixels » + négatif « one sprite bigger or smaller than the others » |
| Angles mélangés entre les cases, vue de côté | le jeu reçoit la mauvaise vue | position de case écrite dans la liste (TOP-LEFT…) + « every sprite faces RIGHT » + « NOT a pure side profile » (plus de quarts de tour) |
| Plus de sprites que prévu (10 au lieu de 4, rangées dupliquées) | découpe désalignée | « The sheet contains EXACTLY 4 sprites » + négatif « more than 4 sprites, duplicated row of sprites » |
| Édition corrective qui aplatit toutes les vues dans le même angle | plus d'angles du tout sur la planche | le prompt d'édition corrective **répète la structure des cases** (haut = face, bas = dos) + « never redraw the whole sheet from a single angle » |
| Poses qui se touchent (épées, effets) | un seul cadre pour deux poses | autocollants ≤ 55 % de leur sixième d'image, larges vides, **surtout horizontaux** |
| Cadres dessinés, grille isométrique au sol | tout est relié, découpe impossible | « no frames, no grid on the ground », négatif « frames, isometric floor grid » |
| Face et dos mélangés dans une case | le jeu ne sait pas quelle vue utiliser | un seul angle par case, listé explicitement |
| Ombre grise sous les pieds | pieds mal posés | « no ground shadow » (le jeu dessine l'ombre) |
| Étiquettes de texte | texte collé au sprite | « no text, no labels, no numbers » |

## Prompt négatif

Trois jeux de négatifs sont générés **en bas de chaque fichier nation** : personnages armés (vues / actions) et
**créatures sans arme** (vues / actions, sans aucun mot « weapon » : un négatif qui nomme une arme peut la faire
apparaître).

## Modifier ou régénérer

Les fichiers Markdown sont générés : modifie les descriptions dans `generer_prompts.py` puis relance depuis la racine du dépôt :

```bash
python3 prompts_sprites/generer_prompts.py
```

Ordre conseillé : commencer par un personnage (ex. Chasseur du Brasier), valider le rendu en jeu, puis enchaîner les autres.
