# Zimut — refonte « style Dofus / Waven »

Testé avec Godot 4.5 : lancement sans erreur, ~60 combats IA contre IA (3 équipes différentes),
tour manuel (déplacement, fin de tour, sort sur soi) et captures d'écran du rendu.

## Installation
1. Dézipper **à la racine du dépôt** (les chemins sont `prototype/zimut/...`), en écrasant les fichiers.
2. Lancer `bash prototype/zimut/nettoyage.sh` pour supprimer les fichiers `*.tmp` parasites (facultatif).
3. Ouvrir le projet une fois dans Godot (génère les `.uid` éventuels), puis lancer.

## Graphismes
- Projection isométrique **2:1** (cases 128×64) dessinée par code : herbe, fleurs, falaises sur les bords de l'île.
- Arbres et rochers = **vrais obstacles** (bloquent déplacement et ligne de vue), générés à chaque combat.
- Tri en profondeur (y-sort) : plus de personnages qui se chevauchent à l'envers.
- Animations : déplacement case par case, fente d'attaque, projectiles, flash d'impact, mort, apparition, téléportation, poussée.
- Dégâts flottants colorés (critique en doré, magie en bleu, poison en violet), particules, secousse d'écran.
- Contour du personnage actif, anneau d'équipe, flèche d'orientation (utile pour les attaques dans le dos).
- Fond dégradé + vignette. Dragonnet et Troll ont un dessin procédural (pas de sprite fourni).

## Interface (HUD façon Waven)
- Timeline d'initiative en portraits, panneau du personnage actif (PV, orbes **PA / PM**).
- Barre de sorts défilante : coûts PA/PM, portée, lancers restants, raccourcis **1-9 / 0**, infobulle.
- Gros bouton **FIN DU TOUR** (Espace / Entrée), boutons **Auto**, **Son**, **Équipe**.
- Prévisualisation : trajet et coût en PM, portée, zone d'effet, **dégâts estimés** sur chaque cible.
- Fiche de survol (PV, PA/PM, statuts), journal de combat, bannières « À vous de jouer ! ».
- Mobile : premier tap = prévisualisation, deuxième tap = confirmation. Clic droit / Échap = annuler un sort.

## Gameplay
- **Tours par initiative** individuelle (agilité) au lieu de « tous les joueurs puis tous les ennemis ».
- **Pathfinding** (BFS), obstacles, portée min/max, **ligne de vue**, zones d'effet (2×2, 3×3, 4×4), sorts multi-cibles.
- **Statuts avec durée** : poison, saignement, brûlure, étourdissement, immobilisation, ralentissement,
  malédiction (-PA), affaiblissement, provocation, bonus de défense / dégâts / PA / PM / esquive, invisibilité,
  immunités, régénération, critique garanti.
- Formule de dégâts : stat (Force/Intelligence), résistance en %, **critiques**, **+25 % dans le dos**,
  « critique garanti dans le dos » pour l'Assassin, exécutions (<20 % / <30 % PV).
- **Poussée** (Coup de bouclier, Coup écrasant, Tremblement de terre, Poing de pierre) avec dégâts de collision.
- **Invocations** (Invocateur, Appel de la meute), **pièges** (Chasseur), **téléportations**, **résurrection**.
- Limite de lancers par tour pour chaque sort (évite le spam du meilleur sort).
- Ennemis avec kits propres : Gobelin (étourdit), Squelette (tireur), Loup (saignement), Troll (régénère, repousse),
  Dragonnet (vole, souffle en zone). 4 ennemis par combat (le 4ᵉ est Troll ou Dragonnet au hasard).
- **IA** : choisit le meilleur sort (dégâts estimés, kills, soins, statuts), se place à portée ou au contact,
  les tireurs évitent la mêlée. Le même code gère invocations alliées et le mode **Auto**.
- Classe « Heal » (aucun sort dans le CSV) : reçoit les sorts du Druide.

## Technique
- `Combat.gd` (nouveau) : règles pures sans état (lecture du texte des sorts du CSV, statuts, dégâts, LOS).
- `GameManager.gd` : règles et état ; émet des événements `fx` consommés par `GridManager` (file d'animations).
- `Sfx.gd` (nouvel autoload) : effets sonores synthétisés par code, aucun fichier audio.
- `invocations.csv` : encodage mixte (UTF-8 + Latin-1) corrigé.
- Entités passent par un `uid` (plus de références croisées entre dictionnaires).

## Équilibrage
`ENEMY_HP_MULT` (en haut de `GameManager.gd`, 1.8 aujourd'hui) règle la difficulté.
Simulations IA contre IA : ~50-70 % de victoires, 4-6 tours. Un joueur humain qui utilise dos, poussées,
ligne de vue et buffs fera mieux que l'IA : augmenter la valeur si c'est trop facile.

## Limites connues
- Le rendu a été vérifié sur captures logicielles (Linux), pas sur un téléphone : les tailles de HUD sont à ajuster
  à ton écran. Caméra : `Main.gd` → `_setup_camera()` (zoom 1.38).
- Les sorts sont interprétés depuis le **texte** de la colonne « Effet » : un texte inhabituel donnera un petit bonus
  de dégâts par défaut (voir `Combat.parse`). Les Invocations restent sans sprite (rond coloré).
- `SpellManager.gd` / `EntityManager.gd` d'origine sont conservés mais n'ont plus de rôle dans les règles.
- Pas de dénivelé ni de tacle/fuite pour l'instant.

## Pistes suivantes
Sprites Dragonnet/Troll/invocations, terrain en hauteur, tacle/fuite (PM perdus au contact), mode campagne
relié à ZOE, musique, choix d'ennemis/niveau avant le combat, sauvegarde de progression.
