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
28 villes au total dans les trois biomes, Donjon compris (miroir exact de la carte) :

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
| village_brume | Village des Brumes | Neutre | Forêt | 11 |
| ruines_lierre | Ruines du Lierre | Adverse (siège ×4) | Forêt | 13 |
| abbaye_ronce | Abbaye des Ronces | Neutre | Forêt | 14 |
| citadelle_ronce | Citadelle des Ronces | Adverse (siège ×4) | Forêt | 15 |
| col_givre | Col du Givre | Neutre | Montagne | 17 |
| mine_cristal | Mine de Cristal | Adverse (siège ×4) | Montagne | 19 |
| bastion_orage | Bastion de l'Orage | Adverse (siège ×4) | Montagne | 21 |
| caravanserail | Caravansérail Rouge | Neutre | Désert | 22 |
| observatoire | Observatoire Solaire | Neutre | Désert | 23 |
| port_sable | Port des Sables | Adverse (siège ×4) | Désert | 24 |
| bois_lune | Bois de Lune | Neutre | Forêt | 16 |
| sanctuaire_mousse | Sanctuaire Moussu | Neutre | Forêt | 17 |
| forge_givre | Forge du Givre | Adverse | Montagne | 23 |
| pic_foudroyant | Pic Foudroyant | Adverse | Montagne | 24 |
| marais_spectres | Marais des Spectres | Neutre | Forêt | 18 |
| fort_cendre | Fort des Cendres | Adverse | Désert | 26 |
| temple_soleil | Temple du Soleil | Neutre | Désert | 25 |
| citadelle_sable | Citadelle de Sable | Adverse | Désert | 27 |
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

- **Condition de victoire** : contrôler les 18 villes de conquête, puis vaincre le
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
- **Mise en page responsive** : en paysage large, carte et conseil de guerre restent côte à côte ; sur les écrans compacts, le conseil passe sous la carte dans une zone verticalement défilante. Le panneau de conseil possède son propre défilement. **Carte étendue (PR en cours)** : vingt-huit villes réparties sur sept rangées verticales. La carte conserve une hauteur minimale de 1600 px, afin de créer une vraie progression à parcourir par défilement. Le glissement peut commencer n'importe où dans la zone de carte, même sur un bouton de ville ; un déplacement de plus de 7 px déplace la carte au lieu de sélectionner la ville. Pour une manipulation plus précise au doigt, la barre verticale est plus large et contrastée, le seuil de glissement est réduit à 2 px et le pas de défilement à 18 px. La carte capte aussi les glissements commencés sur le fond, les routes ou les boutons de villes (pas seulement sur la scrollbar), avec conversion des coordonnées viewport/locales pour Android. Sur les petits écrans, la carte conserve aussi une largeur minimale de 1320 px et peut se défiler horizontalement. Le mode portrait n'est pas une cible prioritaire ; à vérifier dans Godot sur téléphone paysage et sur 1280×720.

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

## 10. Pistes d'amélioration (priorités proposées)

### Priorité 1 — Rendre chaque décision amusante
1. **Préparation d'assaut (première version intégrée)** : avant chaque bataille, choisir de payer 25 or pour les éclaireurs (ennemis d'un niveau inférieur), 12 Bois + 8 Fer pour saboter (−15 % de PV et d'attaque ennemis), ou partir sans préparation. Le bonus est consommé après une seule bataille, même lors d'un siège multi-vagues.
2. **Contre-attaques jouables** : avertissement avant le pillage, puis choix
   entre défendre la ville ou accepter une perte temporaire de production.
3. **Récompenses uniques par ville — première version intégrée** : chaque
   annexion accorde un butin thématique (ressources et or), affiché dans la
   fenêtre de victoire. Le butin est crédité une seule fois, à la prise finale.
   Une prochaine itération pourra ajouter recettes, équipement ou trophées.
4. **Défis optionnels** : gagner en peu de tours, sans mort ou avec une classe
   donnée pour obtenir une récompense bonus.

**Bonus de contrôle de biome (première version intégrée)** : posséder toutes les villes conquérables d'un biome ajoute à chaque victoire +5 Bois (Forêt), +5 Fer (Montagne) ou +5 Venin (Désert). Le bonus est inclus dans la production de l'empire affichée sur la carte et dans l'écran d'annexion.

### Priorité 2 — Donner une vraie identité visuelle au monde
5. **Illustrations par biome** : fond de carte forêt/montagne/désert, reliefs,
   routes dessinées et points d'intérêt.
6. **Vignettes et icônes cohérentes** : une silhouette distincte par ville,
   icônes de bâtiments et états lisibles (allié, neutre, ennemi, assiégé).
7. **Micro-animations et retours** : animation à la sélection, route qui s'allume,
   effet d'annexion, notification de production et son discret.
8. **Carte mieux racontée** : nom de région, courte description et historique
   des 2-3 derniers événements (annexion, siège, pillage).

### Priorité 3 — Équilibrer et rendre les sessions plus fluides
9. **Bonus de contrôle de biome** : conquérir toutes les villes d'un biome
   donne un bonus de production et une récompense dédiée.
10. **Sièges moins répétitifs** : payer pour affaiblir une garnison, ou choisir
    une approche tactique qui modifie la bataille plutôt que de supprimer du contenu.
11. **Bâtiments liés aux biomes** : des choix différents selon forêt, montagne
    ou désert, avec des compromis lisibles.
12. **Équilibrage et tests sur appareil** : durée de campagne, économie, taille
    des textes et interactions tactiles vérifiées en paysage Android.

## 11. Historique des arbitrages

- **15/10** : carte fixe narrative ; contre-attaques OUI (35 %, pillage
  temporaire, jamais de perte de ville, capitale intouchable) ; une
  seule équipe héroïque ; bâtiments de ressources ; brisage.
- **17/10** : adjacence obligatoire (routes) ; extension aux 3 biomes
  (18 villes de conquête + capitale et Donjon) ; fin de campagne (Roi Squelette verrouillé tant
  que Zimut n'est pas contrôlé) ; écran d'annexion + compteurs d'empire ;
  production de l'empire visible (carte, résultat, popup).
