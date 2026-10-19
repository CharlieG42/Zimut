# Sprites à fournir — noms de fichiers attendus (V28)

**Principe :** déposez un PNG détouré (fond transparent) au chemin indiqué. Le jeu le prend tout seul, **sans changer le code**.
Un `.png` passe avant un `.svg` de même nom. Après avoir ajouté des fichiers, ouvrez une fois le projet dans Godot (import automatique).

Conseils généraux :
- Personnages vus de face ou de 3/4, **pieds en bas de l'image**, sans ombre au sol (le jeu dessine l'ombre et l'anneau).
- Hauteur conseillée : 256 à 512 px (le jeu redimensionne). Format portrait, marges transparentes minimales.
- Noms en minuscules, sans accents, espaces → `_` (ex. « Élémentaire de Cristal » → `elementaire_de_cristal.png`).

## 1. Héros — `assets/sprites/players/<classe>.png`
`tank`, `assassin`, `chasseur`, `mage`, `druide`, `heal`, `invocateur`, `sylvain`, `geomancien`, **`artificier`** (provisoire actuellement).
Copie facultative pour la planche des nations : `assets/sprites/nations/heros/<classe>.png`.

## 2. Gultur (tutoriel) — `assets/sprites/npc/gultur.png`
Buste ou plein pied ; remplace automatiquement le dessin vectoriel.

## 3. Boss des Nations — `assets/sprites/nations/boss/<dossier>.png`
`sylvestre`, `cimes`, `sables`, `cristaux`, `marees`, `vents`, `brasier`, `brumes`, `ombres`, **`rouages`** (provisoire : recoloration du boss du Brasier).
Hauteur ≥ 200 px.

## 4. Ennemis des Nations — `assets/sprites/nations/ennemis/<dossier>/<fichier>.png`
Chaque Nation associe un fichier à chaque type d'ennemi du moteur (Gobelin, Loup, Squelette, Troll, Dragonnet).
Pour **Rouages** (dossier `rouages/`) — **V29 : provisoires, découpés automatiquement dans la planche « 10 classes »** :

| Type moteur | Fichier | Monstre |
|---|---|---|
| Gobelin | `drone_aerien.png` | Drone Aérien |
| Loup | `araignee_mecanique.png` | Araignée Mécanique |
| Squelette | `roue_engrenee.png` | Roue Engrenée |
| Troll | `automate_de_combat.png` | Automate de Combat |
| Dragonnet | `drone_aerien.png` | (même fichier) |

Boss Rouages (Mécanoptère) : `nations/boss/rouages.png` ; héros Ingénieur : `nations/heros/artificier.png` (pleine taille)
puis `players/artificier.png` (version « chibi » produite par `tools/chibify_heroes.py artificier`).

Les autres Nations ont déjà leurs fichiers ; un nouveau PNG au même nom les remplace.

## 5. Invocations et mécanismes — `assets/sprites/summons/<nom>.png`
| Classe | Fichiers |
|---|---|
| Invocateur | `golem_de_pierre`, `loup_spectral`, `requin_des_marees`, `elementaire_de_cristal`, `ombre`, `esprit_de_la_foret` |
| Sylvain | `archer_sylvestre`, `arbre`, `ent_de_combat`, `tronc`, `sarriette`, `ronce_agressive`, `racines` |
| Chasseur | `balise` |
| Géomancien | `pilier`, `muraille`, `faille`, `cristal_ambre` (SVG provisoires) |
| **Artificier** | `bombe`, `tourelle`, `balise_de_transposition` (SVG provisoires V27) |

## 6. Illustrations de ville (Conquête / écran de ville) — `assets/ui/conquest/cities/<dossier>.jpg`
Manquant : **`rouages.jpg`** (l'illustration du Brasier sert de remplaçante tant que le fichier n'existe pas ; il sera pris automatiquement).

## 7. Après dépôt
Envoyez-moi les fichiers (ou poussez-les dans le dépôt) : je vérifie les tailles et le détourage, je les intègre, puis je fais les captures de contrôle.
