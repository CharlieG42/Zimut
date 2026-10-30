# Prompt — carte HD du monde de Zimut (Conquête)

But : remplacer `assets/ui/conquest/conquest_world_map.jpg` par une carte peinte **haute définition**
où les **10 Nations + le Donjon** sont présentes et où chaque ville tombe sur un **emplacement peint**.
Le jeu pose ses repères aux coordonnées ci-dessous (en % de la largeur / hauteur de l'image) :
il suffit que la carte peinte ait un lieu reconnaissable à chaque emplacement.

## Format demandé
- Rapport **3:2 paysage**, idéalement **3072 × 2048** (au minimum 1536 × 1024).
- Vue aérienne **en légère plongée** (3/4, ~35°), style peinture fantasy lumineuse, très détaillée.
- **Aucun texte**, aucune étiquette, aucun cadre, aucune rose des vents, aucun personnage.
- Océan sur tout le pourtour (bords ouest, sud, est), îles flottantes et nuages en haut à gauche.

## Prompt (à copier dans Mistral / Le Chat)

> Carte du monde fantasy peinte à la main, vue aérienne en plongée à 35°, format paysage 3:2, très haute définition,
> lumière dorée de fin d'après-midi, couleurs saturées et lisibles, style illustration de jeu vidéo de stratégie,
> sans aucun texte ni étiquette ni bordure. Un continent entouré d'un océan turquoise et bleu profond, divisé en
> régions nettement distinctes :
> — au **nord-ouest** (haut gauche) : des **îles flottantes** dans les nuages, reliées par des ponts de corde,
> avec deux forteresses perchées battues par les vents et les éclairs (Nation des Vents) ;
> — à **l'ouest** : une **grande forêt** luxuriante avec un arbre géant millénaire qui abrite une capitale elfique
> radieuse aux toits dorés, des clairières, des villages de bois, une tour en ruine, un fort de racines, des rivières
> et des cascades (Nation Sylvestre) ;
> — au **nord, au centre** : une chaîne de **montagnes enneigées** avec cols, cascades gelées, un hameau, une
> garnison fortifiée, et au plus haut des cimes la **forteresse noire et sinistre du Roi Squelette** (donjon aux
> tours acérées, lueurs violettes) ;
> — au **centre** : une région de **ronces violettes et de rochers sombres** avec une citadelle gothique, une abbaye
> et des ruines envahies par le lierre (Nation des Ombres) ;
> — au **sud-ouest** : un **volcan** actif, des coulées de lave orange, des roches noires, un fort et une citadelle
> de pierre volcanique (Nation du Brasier) ;
> — au **sud, au centre** : des **marais brumeux** turquoise avec champignons géants, villages sur pilotis et un bois
> aux arbres argentés (Nation des Brumes) ;
> — à **l'est** : un **désert** de dunes dorées et de mesas avec une oasis, un temple du soleil, un observatoire et
> une tour de grès (Nation des Sables) ;
> — sur la **côte est** : un **archipel** de lagons avec un port fortifié et un caravansérail sur pilotis (Nation des
> Marées) ;
> — au **sud-est** : des **îles de cristaux bleus** lumineux avec une forge de cristal (Nation des Cristaux) ;
> — à **l'extrême nord-est** : une **cité mécanique de cuivre et de laiton**, engrenages géants, cheminées fumantes,
> un atelier et une citadelle aux murs à engrenages (Nation des Rouages).
> Chaque lieu habité est un petit bâtiment ou un groupe de bâtiments bien visible, séparé de ses voisins, avec des
> chemins de terre qui les relient. Composition équilibrée, détails fins, pas de flou, pas de texte.

### Variante anglaise (souvent mieux comprise par les générateurs d'images)

> Hand-painted fantasy world map, aerial view tilted at 35 degrees, 3:2 landscape, ultra detailed, golden late-afternoon
> light, vivid readable colors, strategy video game illustration, absolutely no text, no labels, no border. One continent
> surrounded by turquoise and deep-blue ocean, divided into clearly distinct regions: north-west: floating sky islands
> above the clouds linked by rope bridges, two windswept lightning fortresses; west: lush great forest with a giant ancient
> tree sheltering a radiant elven capital with golden roofs, clearings, wooden villages, a ruined tower, a root fort,
> rivers and waterfalls; north-center: snowy mountain range with passes, frozen waterfalls, a hamlet, a fortified
> garrison, and on the highest peaks the sinister black spiky fortress of the Skeleton King with violet glow; center:
> violet bramble lands with dark rocks, a gothic citadel, an abbey and ivy-covered ruins; south-west: an active volcano
> with orange lava flows, black rocks, a volcanic fort and citadel; south-center: misty turquoise swamps with giant
> mushrooms, stilt villages and a silver-tree wood; east: golden desert dunes and mesas with an oasis, a sun temple, an
> observatory and a sandstone tower; east coast: lagoon archipelago with a fortified harbor and a stilt caravanserai;
> south-east: glowing blue crystal islands with a crystal forge; far north-east: a copper and brass clockwork city with
> giant gears, smoking chimneys, a workshop and a gear-walled citadel. Every settlement is a small, clearly visible,
> well separated building group connected by dirt roads. Balanced composition, crisp details, no blur, no text.

## Emplacements des villes (le jeu y pose ses repères)
Si Mistral accepte une image de référence, joindre la carte actuelle avec les points (`reference/carte_emplacements.jpg`).
x = % de la largeur depuis la gauche, y = % de la hauteur depuis le haut.

| Ville | Nation | Type | x | y |
|---|---|---|---|---|
| Pic Foudroyant | Vents (îles flottantes) | forteresse | 26 % | 8 % |
| Donjon du Roi Squelette | Roi Squelette | forteresse | 59 % | 9 % |
| Atelier de Cuivre | Rouages (cité mécanique de cuivre) | village | 91 % | 9 % |
| Bastion de l'Orage | Vents (îles flottantes) | forteresse | 13 % | 10 % |
| Vieille Tour | Sylvestre (forêt) | forteresse | 33 % | 15 % |
| Col du Givre | Cimes (montagnes enneigées) | village | 47 % | 19 % |
| Clairière d'Aube | Sylvestre (forêt) | village | 24 % | 20 % |
| Tour des Sables | Sables (désert) | forteresse | 85 % | 21 % |
| Garnison des Pics | Cimes (montagnes enneigées) | forteresse | 67 % | 24 % |
| Citadelle des Engrenages | Rouages (cité mécanique de cuivre) | forteresse | 96 % | 25 % |
| Sylve-Cœur | Sylvestre (forêt) | capitale | 12 % | 28 % |
| Hameau du Pin | Cimes (montagnes enneigées) | village | 41 % | 29 % |
| Mine de Cristal | Cristaux (cristaux bleus) | forteresse | 55 % | 31 % |
| Temple du Soleil | Sables (désert) | village | 79 % | 31 % |
| Fort Racine | Sylvestre (forêt) | forteresse | 27 % | 37 % |
| Oasis Perdue | Sables (désert) | village | 72 % | 40 % |
| Pont-Mousse | Sylvestre (forêt) | village | 7 % | 43 % |
| Citadelle des Ronces | Ombres (ronces violettes) | forteresse | 47 % | 46 % |
| Port des Sables | Marées (archipel, ports) | forteresse | 93 % | 46 % |
| Sanctuaire Moussu | Sylvestre (forêt) | village | 22 % | 50 % |
| Ruines du Lierre | Ombres (ronces violettes) | forteresse | 36 % | 50 % |
| Observatoire Solaire | Sables (désert) | village | 66 % | 51 % |
| Caravansérail Rouge | Marées (archipel, ports) | village | 84 % | 55 % |
| Abbaye des Ronces | Ombres (ronces violettes) | village | 54 % | 56 % |
| Fort des Cendres | Brasier (volcan, lave) | forteresse | 13 % | 62 % |
| Village des Brumes | Brumes (marais brumeux) | village | 37 % | 68 % |
| Bois de Lune | Brumes (marais brumeux) | village | 50 % | 75 % |
| Forge du Givre | Cristaux (cristaux bleus) | forteresse | 86 % | 76 % |
| Citadelle de Sable | Brasier (volcan, lave) | forteresse | 18 % | 80 % |
| Marais des Spectres | Brumes (marais brumeux) | village | 63 % | 85 % |

## Après génération
1. Exporter en JPG qualité 90, 3072 × 2048, le déposer à la place de `assets/ui/conquest/conquest_world_map.jpg`.
2. Régénérer les masques d'animation (eau / lave / cristaux) : `python3 tools/conquest_fx_masks.py` (écrit
   `conquest_world_fx.png`).
3. Si un lieu peint ne tombe pas exactement sur son emplacement, ajuster `CITY_POS` dans `scripts/ConquestMapUI.gd`.
