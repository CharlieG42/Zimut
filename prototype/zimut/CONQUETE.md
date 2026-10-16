# Mode Conquête — document unique

> Référence de travail du mode Conquête : design arbitré, état d'avancement
> (fait / à faire) et pistes d'amélioration. À mettre à jour à chaque évolution
> du mode. Le même format est prévu pour l'Aventure et le mode Tactique.

## 1. La promesse

« **Construisez votre empire dans le monde de Zimut.** »

La Conquête est la couche stratégique posée sur le combat tactique existant :
chaque bataille sert un objectif territorial, et le territoire conquis
**débloque de la puissance** (ressources, bâtiments, sorts, panoplies).
Le joueur ne « farme » plus des combats abstraits : il agrandit un empire.

| Mode | Ce que le joueur vit |
|---|---|
| Combats Tactiques | Enchaîner des combats équilibrés, progresser son roster (mode « arène ») |
| Aventure | Explorer, découvrir, résoudre (mode « aventure ») |
| **Conquête** | **Décider, développer, dominer** (mode « stratégie ») |

## 2. La boucle de jeu cœur

```
CARTE  →  CHOISIR LA PROCHAINE CIBLE  →  ASSAUT TACTIQUE  →  VICTOIRE
  ↑                                                        |
  |                                        VILLE ANNEXÉE : revenus + options
  ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ← ←
```

1. **Carte** : voir son territoire, les routes ouvertes, les revenus.
2. **Décision** : quelle ville **reliée par route** attaquer, avec quelle
   équipe — les combats perdus ne coûtent rien d'autre qu'une retraite
   (le siège en cours est conservé, pas de remise à zéro).
3. **Bataille tactique** : biome et niveau de la ville ; boss pour les
   places fortes et le Donjon.
4. **Annexion** : écran « VILLE ANNEXÉE ! » (production versée, contre-
   attaque éventuelle, conseil de développement), puis la ville produit
   à chaque bataille gagnée.
5. Retour à la carte, plus riche — et la pression ennemie (35 %) augmente.

## 3. Le territoire — FAIT

**Carte fixe narrative** (décision du 15/10) : le monde de Zimut reste
identique d'une partie à l'autre ; la rejouabilité vient de l'économie
et des choix de bâtiments.

### Catalogue officiel (`ProgressionManager.CONQUEST_CITIES`)
10 villes sur les 3 biomes + le Donjon (miroir exact de la carte) :

| id | Ville | Type | Biome | Niveau |
|---|---|---|---|---|
| capitale | Sylve-Cœur | Capitale imprenable | Forêt | — |
| clairiere | Clairière d'Aube | Neutre (1 bataille) | Forêt | 10 |
| pont_mousse | Pont-Mousse | Neutre | Forêt | 11 |
| vieille_tour | Vieille Tour | Adverse (siège ×4) | Forêt | 12 |
| fort_racine | Fort Racine | Adverse | Forêt | 14 |
| hameau_pin | Hameau du Pin | Neutre | Montagne | 16 |
| garnison | Garnison des Pics | Adverse | Montagne | 18 |
| oasis | Oasis Perdue | Neutre | Désert | 20 |
| tour_sable | Tour des Sables | Adverse | Désert | 22 |
| donjon_roi | Donjon du Roi Squelette | Objectif final (siège ×4, boss) | Donjon | 25 |

### Adjacence — FAIT
On ne peut attaquer qu'une ville **reliée par route à son territoire**
(`ProgressionManager.CONQUEST_ROUTES`, bouton grisé « HORS DE PORTÉE »
sinon). Le Donjon n'est relié qu'aux trois places fortes : il exige de
tenir tout Zimut. Les routes relient deux villes du territoire en doré.

### Type de bataille — FAIT
- Neutre : 1 bataille de mobs.
- Adverse : siège en 4 batailles (3 plateaux de mobs puis le **boss du
  biome** ; le Donjon oppose le **Roi Squelette**).
- Le biome de la ville pilote le décor et le bestiaire
  (`GameManager.fight_biome`, `conquest_city_biome`).

## 4. L'économie — FAIT (base)

- 5 ressources de craft existantes (Fer, Bois, Cuir, Magie, Venin), l'or,
  la Forge et les recettes sont réutilisés tels quels.
- **Bâtiments** (`CONQUEST_BUILDINGS`, 1 exemplaire par ville) :
  Scierie (Bois), Mine (Fer), Tannerie (Cuir), Cabane des mages (Magie),
  Verger (Venin). Production versée **à chaque bataille gagnée**
  (`conquest_empire_yield`, affichée dans le bandeau de la carte, dans la
  fenêtre de résultat et dans le popup d'annexion).
- **Brisage d'équipement** (Forge) : commun → 1 ressource, rare → 2,
  épique → 3, légendaire → 5 ; quantité ≈ (1 + niveau × 0,1) × rareté.
- Compteurs d'empire en haut de carte : « Villes X/N · production par
  victoire · objectif de campagne ».

## 5. La pression ennemie — FAIT (passive)

- **Contre-attaque : 35 % par bataille gagnée** — la ville ciblée est
  **pillage** (production gelée 3 batailles), **jamais perdue** ; la
  capitale ne peut jamais être attaquée ; la ville fraîchement conquise
  est épargnée.
- Affichage : bandeau ⚠ sur la carte au retour + ligne dans le popup
  d'annexion.

## 6. Fin de campagne — FAIT

- **Condition de victoire** : contrôler les 9 villes, puis vaincre le
  **Roi Squelette** dans le Donjon (verrouillé sinon).
- Fenêtre de résultat « ★ EMPIRE VICTORIEUX ! » + popup sur la carte ;
  possibilité de continuer en « empire libre » (fin ouverte).

## 7. Progression partagée — FAIT

XP, loots, or de bataille nourrissent le même roster que le mode
Tactique (`user://saves/partie_N.json`, champs `roster`/`team`/
`inventory`/`resources`/`gold` communs ; `conquest` ne contient que
l'état de la campagne : `owned`, `pending_city`, `sieges`, `buildings`,
`ravage`, `just_annexed`, `last_yield`…).

## 8. Rythme et accessibilité (mobile, sessions courtes)

- Une bataille = 5 à 15 min ; la carte doit rester lisible en 10 secondes :
  vert = territoire, gris = neutre, rouge = adverse, ⚔ = attaquable,
  routes dorées = ouvertes.
- Pas de temps réel, pas de timer hors combat.
- Fiche ville en panneau latéral, boutons gros et rares (existant).
- **Lisibilité renforcée (passe du 15/10)** : noms de villes agrandis (18 px), boutons plus hauts (76 px), titre de carte et légende plus visibles ; le panneau de conseil utilise une taille de texte plus confortable et le bouton d’assaut est plus grand.
- **Mise en page responsive (PR en cours)** : le corps de la carte s'adapte désormais à la taille disponible. En paysage large, carte et conseil de guerre restent côte à côte ; en format compact/portrait, la carte passe au-dessus du conseil dans une zone verticalement défilante. Les boutons de villes, textes et commandes sont redimensionnés selon la largeur disponible ; le panneau de conseil possède son propre défilement pour que les bâtiments restent accessibles. À valider dans Godot sur 360×800, 800×360 et 1280×720 avant de marquer ce point comme terminé.

## 9. Tests

- `tests/test_conquest_gameplay.gd` — contre-attaques, bâtiments,
  production d'empire, brisage.
- `tests/test_conquest_siege.gd` — sièges ×4, villes neutres ×1,
  reprise après défaite.
- `tests/test_conquest_roads.gd` — adjacence, verrouillage du Donjon,
  fin de campagne, `just_annexed`, biomes des nouvelles villes.
- Lancement type : `godot --headless --path prototype/zimut -s tests/test_conquest_roads.gd`.
- **Validé le 17/10** (Godot 4.7 headless) : les 3 tests conquête plus
  `test_progression`, `test_progression_v2`, `test_boss_flow`,
  `test_xp_pacing`, `test_donjon`, `test_biome_craft` passent ; les
  scènes `ConquestMap`, `AdventureMap`, `TeamSelection`, `SaveSlots`
  s'instancient sans erreur de script.

### Correctifs du 17/10 (écran gris au lancement d'un mode)

- `TeamSelectionUI.gd` : bloc `else:` vide (parse error) qui cassait le
  chargement de la scène — cause de l'écran gris sur tous les modes.
- `ConquestMapUI.gd` : la classe interne `_RouteLines` référençait
  `ConquestMapUI.CITY_POS` (non résolu dans une inner class) ; la
  position des villes est maintenant passée en variable d'instance.
- Lesson : toujours vérifier avec `godot --headless -s tests/…` et
  instancier les scènes avant de fusionner.

## 10. Pistes d'amélioration (non arbitré)

Idées identifiées lors de la revue du 17/10 — à arbitrer avant
implémentation, puis à déplacer dans les sections « FAIT » ci-dessus.

### Jeu
1. **Poids de la décision de siège** : option « affaiblir la garnison »
   (or / espions) pour réduire un siège de 4 à 3 batailles, vs assaut
   direct — transformer le siège en décision, pas en grind.
2. **Contre-attaques jouables** : avertissement 1 bataille à l'avance,
   puis choix défendre (bataille défensive spéciale) ou subir le pillage.
3. **Priorités ennemies lisibles** : l'ennemi cible les villes les plus
   productives plutôt qu'un tirage aléatoire.
4. **Bonus de contrôle de biome** : toutes les villes d'un biome → bonus
   d'empire (+10 % production du biome, recette exclusive).
5. **Récompenses uniques par ville** : villages → recettes exclusives ;
   avant-postes → pièces de panoplie ; places fortes → sort signature ou
   gemme ; Donjon → trophée cosmétique.
6. **Défis par ville** (rejouabilité) : conditions optionnelles (victoire
   sans mort, en ≤N tours, avec une classe) → récompense bonus, tirées
   par partie.

### UX
7. **Historique discret** : 2-3 derniers événements dans un coin de la
   carte (« Fort Racine annexée », « Pont-Mousse pillé »).
8. **Bâtiments filtrés par biome** : n'afficher que les bâtiments
   cohérents avec la ville (panneau plus court, choix plus signifiants).
9. **Vignettes PNG par ville** + icônes de bâtiments + texture de fond
   par biome (passe graphique, sans refonte du layout).

## 11. Historique des arbitrages

- **15/10** : carte fixe narrative ; contre-attaques OUI (35 %, pillage
  temporaire, jamais de perte de ville, capitale intouchable) ; une
  seule équipe héroïque ; bâtiments de ressources ; brisage.
- **17/10** : adjacence obligatoire (routes) ; extension aux 3 biomes
  (9 villes + Donjon) ; fin de campagne (Roi Squelette verrouillé tant
  que Zimut n'est pas contrôlé) ; écran d'annexion + compteurs d'empire ;
  production de l'empire visible (carte, résultat, popup).
