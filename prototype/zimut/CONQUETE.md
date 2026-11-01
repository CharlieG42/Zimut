# Conquête — V62 : la ville illustrée, jour & nuit, événements de ville et spécialisation

Toute la logique est dans `scripts/ConquestSystem.gd` (statique, testable sans interface) ;
`ProgressionManager` expose les points d'entrée `conquest_*` ; l'interface est `ConquestMapUI.gd`.

## Villes évolutives
- 3 niveaux : Hameau → Bourg → Cité (coûts : 120 or + 10 Bois + 10 Fer ; puis 300 or + 20 Fer + 10 Cuir + 10 Magie).
- Chaque niveau : +2 places de garnison (4 / 6 / 8), +50 % de production des bâtiments, +2 or par victoire, +3 de défense.
- Un Bourg ou plus est protégé de l'épidémie.
- Nouveau bâtiment : **Muraille** (+6 défense).

## Garnisons
- Soldats à 30 or pièce (par 1 ou « remplir »). Chaque soldat = 2 de défense.
- **Défense** = soldats×2 + niveau×3 + muraille + gouverneur.

## Héros gouverneurs
- Un héros par ville, une ville par héros, 6 gouverneurs maximum (3 héros restent libres).
- Il défend (6 + niv/2 + bonus de classe) et produit selon sa classe (Tank rempart, Assassin or, Chasseur Cuir, Mage Magie, Druide Bois/Venin, Heal +1 soldat/bataille, Invocateur, Sylvain, Géomancien Fer).
- **Il ne combat plus en assaut** : il disparaît de la sélection d'équipe de Conquête.

## Menaces
- **Raids** (35 % par victoire) : repoussés si défense ≥ 4 + villes/2, sinon ville pillée 3 batailles. Villes frontalières ciblées 3× plus.
- **Grandes offensives** annoncées 3 batailles à l'avance (force affichée) : défense ≥ force → repoussée + butin ; ≥ 60 % → brèche (pillage 4 batailles, garnison /2) ; sinon **ville perdue** (reprise en une bataille, sans second butin).
- La capitale et le Donjon ne sont jamais ciblés.

## Événements (45 % par victoire, au plus un en attente)
Interactifs : Caravane marchande, Réfugiés, Mercenaires, Agitation (villes sans garnison), Espion capturé, Émissaire (trêve payante).
Automatiques : Bonne récolte, Cache découverte, Épidémie, Rapport du gouverneur.
Les nouvelles s'affichent au retour sur la carte ; l'événement à trancher apparaît en popup.

## Chancelier (V59)
Tous les 5 batailles (dès 2 villes conquises), le Chancelier demande audience via le popup d'événement et propose un édit :
- **Impôt** : encaisse le revenu d'une victoire par ville immédiatement, mais chaque garnison perd 1 soldat.
- **Manœuvres** (60 or) : +2 défense dans toutes les villes pendant 3 batailles.
- **Entretien des routes** (40 or) : +2 Bois et +1 Cuir à chaque victoire pendant 4 batailles.

## Lieutenance — missions des héros libres (V59)
Les héros qui ne gouvernent ni ne combattent peuvent partir en **mission de 3 batailles** (bouton « ⚑ MISSIONS DES LIEUTENANTS » sur une ville alliée). Ils redeviennent disponibles à leur retour :
- **Escorte de caravane** : +90 or et +4 Cuir (mis à l'échelle du niveau du héros).
- **Cartographie** : révèle 2 villes inconnues sur la carte (même état que les belvédères d'Aventure).
- **Prospection** : +30 or et +8 Fer.

20 % de complication : l'expédition échoue et coûte de l'or. Un héros en mission ne peut ni combattre ni gouverner ; une mission peut être rappelée sans récompense.

## Spécialités économiques (V59)
Chaque ville conquise produit en plus une ressource propre à son biome/Nation (`ConquestSystem.CITY_TRAITS`), versée à chaque victoire et mise à l'échelle du niveau de la ville (×1 / ×1,5 / ×2). Gelée si la ville est pillée. Exemples : Mine de Cristal → +3 Magie, Forge du Givre → +3 Fer, Marais des Spectres → +3 Venin. Affichée dans le Conseil de l'écran de ville et sur la carte.

## Généraux du Roi Squelette (V59)
Quatre généraux nommés tiennent les forteresses ennemies : **Tharok le Végétal** (Fort Racine), **Vorkann le Givre** (Garnison des Pics), **Zahor le Sableux** (Tour des Sables) et **Nébulia l'Illusionniste** (Citadelle des Ronces).
- Tant qu'il vit, son siège est durci (+3 niveaux) et il peut lancer une **offensive nommée** (bannière rouge « ☠ … mène l'offensive »).
- La 4ᵉ bataille de sa forteresse l'oppose **en personne** (boss nommé, kit du boss de sa Nation).
- Le vaincre journalise sa chute ; **tous les vaincre** affaiblit l'assaut du Donjon du Roi Squelette (-3 niveaux).
- Compteur « ☠ N généraux en vie » dans l'en-tête de la carte.

## Plans d'assaut (V59)
Avant chaque bataille d'un siège ennemi (hors vague boss), le popup de préparation propose en plus des tactiques : 
- **Blocus** (40 or) : fait avancer le siège d'une vague **sans combat** ; 35 % de représailles (une ville possédée est pillée 3 batailles).
- **Infiltration** (50 or) : l'Assassin **libre** (ni gouverneur ni en mission) saborde une vague de l'intérieur — sans combat ni risque ; il revient à la victoire suivante.
Un plan peut mener à l'annexion sans verser de sang (butin normal, général vaincu le cas échéant).

## Reconquête ennemie (V59)
Les villes non possédées accumulent une garnison adverse : +1 soldat toutes les 3 victoires (max 6), soit +1 niveau de bataille par tranche de 2 soldats. Attendre une cible la durcit — la garnison est affichée dans le panneau de la ville et le bonus appliqué au combat.

## Diplomatie (V59)
Une ville **neutre attaquable** peut rejoindre l'empire sans combat : bouton « ☮ NÉGOCIER L'ANNEXION » (120 or + 8 de la ressource spécialité de la ville). Même règle de routes que l'assaut. Les annexions pacifiques comptent pour la Légende (fin « Empire marchand » dès 4).

## Ruine & reconstruction (V59)
Une ville **perdue** puis reprise reste **ruinée** : la chute coûte un niveau, et la production (revenu, spécialité, bâtiments, gouverneur) reste gelée 3 batailles après la reprise. Réparable à tout moment pour 80 or (bouton « ⚒ RÉPARER »). La ruine se résorbe aussi d'elle-même, bataille après bataille.

## Légende & fins multiples (V59)
À la chute du Donjon, un **épilogue** calcule le score de Légende : villes (10 pts), développement (5 pts/niveau), gouverneurs (4 pts), Pierres Élémentaires (30 pts), annexions diplomatiques (6 pts), ruines non réparées (-8 pts). Selon le style de jeu, la fin affichée change :
- **Âge des Héros** (défaut) — les assauts et les généraux vaincus en personne.
- **Empire marchand** — 4 villes ou plus annexées par négociation.
- **Bastion de Zimut** — villes développées (40 pts de niveaux) et 3+ gouverneurs.

## Carte vivante (V60)
La carte du monde n'est plus un plateau d'illustrations : chaque ville est posée **sur sa région peinte** (forêt, cimes, désert, Ronces, lave, archipels, Rouages) et le réseau de routes suit la géographie (`CONQUEST_ROUTES`, sans croisements).

- **Repères compacts** (`ConquestMapLayers.Pin`) : médaillon coloré par l'état (★ capitale, ⚑ empire, ⌂ neutre, ⚔ adverse, ☠ forteresse d'un général, ? inconnue, ✖ perdue), liseré aux couleurs de la Nation, drapeau qui flotte sur les villes de l'empire, petites tours = niveau, pions rouges = avancée du siège, fumée = ville pillée/ruinée/perdue, cadenas sur le Donjon, anneau doré pulsant = attaquable, anneau rouge = offensive annoncée. L'illustration complète reste dans le conseil et l'écran de ville.
- **Routes** (`ConquestMapLayers.Routes`) : pavées dorées dans l'empire, pointillés dorés animés avec flèche vers les villes attaquables, sentiers pâles ailleurs. Pendant une offensive, une **colonne ennemie** marche vers la ville menacée (elle avance à mesure que l'échéance approche).
- **Territoire** : calculé une fois par changement (SubViewport « mise à jour unique ») en champ de métaballes → teinte plus vive et frontière dorée autour de l'empire, terres des places fortes ennemies assombries, **brouillard** animé sur les terres pas encore révélées en Aventure.
- **Carte animée** (shader + masques `conquest_world_fx.png` : R = eau, G = lave, B = cristaux) : reflets sur l'eau, lave qui pulse, cristaux qui luisent, ombres de nuages qui dérivent ; navires, oiseaux et nuages traversent la carte. En qualité « Économie », la carte reste fixe.
- Carte en 3072×2048 (`conquest_world_map.jpg`, mipmaps), vignette sur les bords, titre et légende fixes sur la vue.
- Gultur présente la carte une fois (`conq_carte`).

## Villes vivantes & bâtiments à niveaux (V61)
L'écran de ville montre la ville **dessinée** devant l'illustration de sa Nation (`ConquestCityView`) : on touche un bâtiment, sa gestion s'affiche à droite, avec un résumé de la ville dessous.

- **5 niveaux de ville** : Hameau → Bourg → Cité → Grande Cité → Métropole (550 or + Bois/Fer/Magie, puis 900 or + Fer/Cuir/Magie/Venin). Garnison 4 → 12, production ×1 / 1,5 / 2 / 2,4 / 2,8. L'hôtel de ville se transforme : ailes, tour à horloge, tours d'angle, dôme et flèche dorée.
- **Emplacements** : 3 / 4 / 5 / 6 / 6 bâtiments selon le niveau (les villes existantes gardent leurs bâtiments).
- **Bâtiments à 5 niveaux** (V66, étoiles) : le niveau N d'un bâtiment exige une ville de niveau N (Hameau→Métropole). Production ×1 / 1,7 / 2,3 / 3 / 3,7, coût ×1 / 2 / 3,5 / 6 / 10 (le coût croît plus vite que la production : les derniers niveaux sont un investissement de long terme qui allonge la partie) ; muraille +6 / +10 / +14 / +18 / +22 défense. Les niveaux 4-5 réutilisent le dessin du niveau 3 faute d'illustration dédiée ; les sprites iso (V65) vont jusqu'à 5.
- **Merveille de la Nation** (dès la Cité, une par ville, 450 or + 20 de la ressource de la Nation + 10) : Arbre-Ancêtre, Forge des Cimes, Grand Bazar, Prisme Éternel, Grand Phare, Moulin des Tempêtes, Haut-Fourneau, Serre des Brumes, Crypte des Serments, Grande Horloge, Trône d'Os — or, défense et ressources à chaque victoire.
- Vie de la ville : habitants qui circulent (plus nombreux avec le niveau), soldats à l'exercice selon la garnison, gouverneur devant sa résidence, lanternes, fumées, drapeaux ; fumée sur une ville pillée, cadre rouge pendant une offensive ; feu d'artifice doré à chaque construction.
- Sauvegarde : `building_levels {ville:{bâtiment:niveau}}`, `wonders [ville]` (optionnelles).

## Ville illustrée, jour & nuit, événements et spécialisation (V62)
L'écran de ville affiche des **illustrations par bâtiment** (`assets/ui/conquest/city/<biome>/`,
générées par `tools/gen_city_art.py`, repli vectoriel si un fichier manque) :
- **Jour / soir / nuit** : 3 ciels par biome, voile nocturne, **fenêtres et lanternes allumées**
  la nuit ; bouton ☀/🌇/🌙 dans la barre de l'écran (`ConquestSystem.cycle_time_of_day`,
  sinon cycle auto avec les batailles).
- **Événements de ville** : fête (étals + feu), incendie (fumée sur l'hôtel), marchand de passage
  (charrette) — `ConquestSystem.CITY_EVENTS`, déclenchés à l'entrée dans la ville, affichés dans
  le conseil.
- **Spécialisation au niveau Cité** : militaire (+2 défense, allure hérissée) ou marchande
  (+3 or, place commerçante) — `ConquestSystem.CITY_SPECS` / `choose_spec`, bonus dans
  `defense` et `city_income`.
- Pour remplacer les SVG par de vraies illustrations IA : prompts dans `prompts_sprites/villes/`.

## Sauvegarde
Clés ajoutées à `conquest` (toutes optionnelles) : `city_levels`, `garrisons`, `threat`, `event_pending`, `news`, `truce`, `lost`, `rewarded`, `battle_count`, `event_cd`, `threat_cd`, `chancellor_cd`, `chancellor_seen`, `drill`, `roadworks`, `missions`, `missions_revealed`, `annexed_diplomacy`, `ruin`, `city_time`, `city_events`, `city_specs`.

## Tests
`tests/test_conquest_system.gd` (moteur, + bloc V59 Chancelier/spécialités), `tests/test_conquest_team.gd` (sélection d'équipe, nécessite xvfb), `tests/shot_conquest_v14.gd` (captures).

## Écran de ville (V15)

Cliquer sur une ville **alliée** (capitale comprise) « entre dans la ville » : `CityScreenUI` s'ouvre par-dessus la carte, aux couleurs de la nation de la ville (fond, bordures, noms des quartiers : Hutte du Conseil / Amirauté / Sanctum de Cristal…).

- **Hôtel de ville** : évolution Hameau → Bourg → Cité (coûts en or et ressources).
- **Caserne** : recrutement (+1 ou remplir la garnison).
- **Résidence du gouverneur** : nommer / rappeler un héros (liste des 9 héros, ceux déjà en poste sont grisés).
- **Bâtiments de production** : scierie, mine, tannerie, cabane des mages, verger, muraille.
- **Conseil de la ville** (colonne de droite) : niveau, garnison, défense, revenu, gouverneur, menace en cours, production.

Chaque action écrit la sauvegarde ; le bouton « ← CARTE » revient à la carte. Le panneau latéral de la carte ne garde que le bouton « ⌂ ENTRER DANS LA VILLE ». Capture de test : `tests/shot_city_screen.gd`.
